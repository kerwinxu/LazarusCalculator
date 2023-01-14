unit calculator;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  StrUtils,             // 字符串的相关操作
  GStack,               // 这个是堆栈
  generics.collections, // 这个是队列
  GQueue
  ;

type
    STYLES = ( NUMBER, OPERATOR1, LEFT_BRACKET, RIGHT_BRACKET);
// 这里添加结构
type
    pNUMS=^NUMS;          // 是为了动态创建的时候需要的。
    NUMS=record
       style : STYLES;     // 类型
       c     : char;      // 运算符
       num   : Double;    // 数值
     end;

     // 如下是这个函数用用到的变量
type
    TNUMSStack = specialize  TStack<pNUMS>;        // 堆栈定义。
    TNUMSQueue = specialize  TQueue<pNUMS>;        // 队列定义

implementation

// 返回操作符的优先级的。
function get_priority(c:Char):Integer;
begin
  case c of
       '+':    get_priority:=1;
       '-':    get_priority:=1;
       '*':    get_priority:=2;
       '/':    get_priority:=2;
  end;

end;

// 这里有一个函数是计算的
function calcu(s:String):Double;
// 数据类型，用枚举


var
  stack:   TNUMSStack;     // 堆栈变量
  queue:   TNUMSQueue;     // 队列变量
  I    :   Integer;        // 临时变量
  start_I: Integer;        // 临时的变量
  len  :   Integer;        // 字符串的长度
  c    :   char;           // 临时的一个字符
  pnum : pNUMS;          // 这个是动态创建的指针
  pnum1 : pNUMS;         // 2个操作数
  pnum2 : pNUMS;
  pnum3 : pNUMS;

begin
  // 这里是计算了
  // 首先将中缀表达式转成后缀表达式
  I:=0;
  len:=length(s);  // 取得字符串长度
  stack:=  TNUMSStack.create;
  queue:=  TNUMSQueue.create;
  //
  while I<=len do
        begin
          // 读取一个字符
          c:=s[I];
          // 分支语句判断
          case c of
               '0'..'9': begin
                 // 这里是数字
                 start_I:=I;  // 先保存原先的，然后寻找这个数字的边界
                 while ((I<=len) and  (((s[I]>='0') and (s[I] <= '9')) or (s[I] = '.'))) do
                 begin
                       I := I + 1
                 end;
                 // 这里将截取字符串，然后转成数字
                 //GetMem(pnum, SizeOf(NUMS)); // 动态申请。
                 New(pnum);
                 with   pnum^ do
                 begin
                    style :=  NUMBER;
                    num   :=  MidStr(s,start_I,I-start_I).toDouble()  ;
                 end;
                 // 添加到堆栈
                 stack.Push(pnum);
                 I := I + 1  ; // 下一个
               end;
               'a'..'z','A'..'Z': begin
                 // 这里是标识符
               end;
               '+','-','*','/': begin
                 // 这里是操作符
                 while  ((stack.Count > 0) and (not ((stack.Peek()^.style = OPERATOR1) and (get_priority(stack.Peek()^.c) >= get_priority(c))))) do
                 begin
                      // 从堆栈中弹出，然后加入到队列。
                      queue.push(stack.pop)
                 end;
                 // 然后添加这个操作符
                 New(pnum);
                 with   pnum^ do
                 begin
                    style :=  OPERATOR1;
                    c   :=  c  ;
                 end;
                 // 添加到堆栈
                 stack.Push(pnum);

               end;
               '(': begin
                 // 左括号,直接压入堆栈
                 New(pnum);
                 with pnum^ do
                 begin
                  style := LEFT_BRACKET
                 end;
               end;
               ')': begin
                 // 右括号,不断的从堆栈中弹出，直到一个左括号
                while stack.Peek()^.Style <>   LEFT_BRACKET do
                   queue.push(stack.pop)
               end;
          end;


        end;

  // 这里将所有的堆栈中的放到队列
  while  (stack.count > 0) do
  begin
    queue.push(stack.pop);
  end;
  // 如下是计算后缀表达式。
  while not queue.IsEmpty  do
  begin
     pnum :=    queue.Front; // 得到第一个。
     queue.Pop; // 弹出一个
     // 下边要判断，
     if (pnum^.style =   NUMBER) then
        // 压入堆栈
        begin
        stack.push(pnum);
     end
     else if (pnum^.style =  OPERATOR1) then
        begin
          // 这里要判断是哪个操作符
          pnum2 := stack.pop;
          pnum1 := stack.pop;
          new(pnum3);
          pnum3^.style:= NUMBER;
          case pnum^.c of
               '+' :  pnum3^.num:= pnum1^.num+pnum2^.num;
               '-' :  pnum3^.num:= pnum1^.num-pnum2^.num;
               '*' :  pnum3^.num:= pnum1^.num*pnum2^.num;
               '/' :  pnum3^.num:= pnum1^.num/pnum2^.num;
          end;
          // 结果压入堆栈
          stack.push(pnum3);
          // todo 这里需要销毁

        end;


  end;
  // 这里从堆栈中弹出一个
  pnum :=  stack.pop();
  calcu := pnum^.num;


end;

end.
