**请注意，pascal语言的变量是不区分大小写的!!!**,头一次学习这个语言，一直报错，结果后来才想到是不是不识别大小写。
如下是这门Lazarus的简单介绍（我用的是delphi7的介绍）。


# 文件格式

单元文件(.pas)是如下的格式:  
```
unit Unit1;   //单元文件名
interface     //接口，起始于interface，到implementation结束。
uses          //程序用到的公共单元
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs;
type // 定义类型
    TForm1 = class(TForm)
    private //定义私有变量和私有过程
        { Private declarations }
    public //定义公共变量和公共过程
        { Public declarations }
end;
var // 声明变量以及类型，
    Form1: TForm1;
implementation //程序代码实现部分
{$R *.dfm}
end. 

```

工程文件(.dpr)是如下的格式:  
```
program Welcome; //指出可执行文件名
uses //显示包括在工程中的文件
    Forms,
    Unit1 in ’Unit1.pas’ {Form1};
{$R *.res} //$R 语句是编译器指令
begin
    Application.Initialize;                    // 程序初始化
    Application.CreateForm(TForm1, Form1);     // 创建窗口
    Application.Run;                           // 程序运行
end.
```  

# pascal基础

## 注释

```
{花括号注释}
(*圆括号/星号注释*)
//C++风格的注释
```

## 数据类型

### 实型
浮点数

|实数类型|有效位数|字节数|
|----|----|----|
|Real48|11~12|6|
|Single|7~8|4|
|Double|15~16|8|
|Extended|19~20|10|
|Comp|19～20|8|
|Currency |19～20|8|
|Real|15~16|8|


### 有序类型
#### 整数

|整数类型|备注|
|-------|----|
|Integer|32位带符号整数|
|Cardinal|32位无符号整数|
|Shortint|8位带符号整数|
|Smallint|16位带符号整数|
|Longint|32位带符号整数|
|Int64|64位带符号整数|
|Byte|8位无符号|
|Word|16位无符号|
|Longword|32位无符号|

#### 字符

|字符类型|备注|
|------|----|
|AnsiChar|8位字符|
|WideChar|16位字符|
|Char|通用字符类型，相当于WideChar|

#### 布尔

|布尔类型|备注|
|------|---|
|Boolean|常用|
|ByteBool|8位|
|WordBool|16位|
|LongBool|32位|

其中常用的是Boolean，值是0和1，其他的是为了跟window兼容，有些是拿32位整数当作布尔值的。

#### 枚举

```
type
 DayOfWeek=(Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday);//变量名=(枚举列表)
 // 声明是如下
 var
 Days:DayOfWeek; 
```
简化步骤  
```
var
 Days:(Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday);
```

#### 子界类型
限定某个范围的取值。  

```
type
    Month=1..12;
    Letters=’A’.. ’H’;
    DayOfWeek=(Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday); //枚举型
    Days=Monday..Friday; //一个 DayOfWeek 型的子界
```

### 字符串

```
var
    MyStr1:ShortString;  // 短字符串，最大长度是255个字符
    MyStr2:String[200];  // 长字符串，长度可以无限，这里是固定最大200个字符。

```

   - 短字符从索引0开始，但索引0存放的是短字符的实际长度
   - 长字符从索引1开始，最后添加一个NULL字符表示结束。
   - ：字符串变量必须用一对单引号括起来，如果字符串本身就有单引号，这个单引号要用两个连续的单引号表示。


### 结构类型
结构数据类型包括：集合类型、数组类型、记录类型、文件类型、类类型、类引用类型和接口类型等。

#### 集合类型
一群具有相同类型的元素的集合，这些类型必须是有限类型，如整型、布尔型、字符型、枚举型和子界类型。
```
type
    Set1=set of ’A’.. ’Z’; //基类型是子界型
    Set2=set of Char; //基类型是字符型
    Set3=set(Jan,Feb,Mar,Apr); //基类型是枚举型
```
赋值运算与简单类型一样，声明了一个集合类型的变量后，要为这个变量设定一个明确的值，例如：
```
var
 TInt1,Tint2:set of 1..10; 
```
以上代码虽然声明了两个集合变量，但变量 TInt1 和 TInt2 并不是代表 1～10 组成的集合，必须对它们赋值：
```
TInt1:=[1,3,5,7,9];
TInt2:=[2..5,8..10]; 
```
集合运算   

   - = ： 等于，无论顺序。
   - <> ： 不等于
   - >= : 如果集合 B 中的元素在集合 A 中都可以找到，那么称集合 A 大于等于集合 B
   - <= : 小于扽古
#### 数组

```
var
    TInt:array [1..15] of Integer;  // 
```

```
type
    Int=array [1..15] of Integer;     // 类型
var
    TInt:Int;                         // 声明

begin
    for I=0 to 15 do                  // 赋值
        TInt[I]:=0; //为数组各元素赋初值为 0
end;
```
多维 TArr=array [1..15,1..15] of Integer;

#### 记录类型
一群数据的集合
```
type
    PTStudent=^TStudent  // 这里表示是这个记录的指针类型
    TStudent=record      // 记录类型
    ID:Integer;
    Name:String[10];
    Age:Integer;
    Memo:String[100];
end;
```

使用记录

```
var
    Stu:TStudent;
    with Stu do //以下代码为记录赋值，也可以只给记录的单个域赋值
    begin
        ID:=1;
        Name:= ’Jim’;
        Age:=18;
        Memo:= ’He is a good student.’;
    end; 
```

#### 指针类型
```
type
    指针类型标识符=^基类型；
```

   - 定义指针类型中是^基类型
   - 取地址操作符是@ ，获取变量的地址
   - 取地址指向的值的内容是： 指针^

## 函数
函数声明
```
function 函数名(<形式参数表>):<类型>;
begin
    <语句>;
    <语句>;
    ...
    <语句>;
end; 
```
函数调用
```
<函数名>(<实参表>);  // 如果没有参数可以省略括号。
```
## 过程
过程声明
```
proceduce <过程名>(<形式参数表>)
begin
    <语句>
    <语句>
    ...
    <语句>
end; 
```
过程跟函数的区别是，过程不返回值。

## 递归调用
函数或者过程的标题部分的最后加上关键词Forward。

## 运算符
### 算数运算符
   - +
   - - 
   - *
   - / 
   - mod : 取余数
   - div ： 整除

### 逻辑运算符
   - and
   - or
   - not
   - xor

### 比较运算符
### 按位运算符
### 运算符优先级

|运算符|说明|
|---|---|
|()|括号|
|+，-|正负号|
|^|乘方|
|*,/|乘除|
|+,-|加减，字符串连接|
|=,>,<,<=,>=,<>|运算关系符|
|not|逻辑非|
|and|逻辑与|
|or|逻辑或|

## 语句

### 常量声明语句
跟变量不同的是，变量是var，而常量是const

### 赋值语句
```
variable:=expression; //变量: = 表达式;
```
### 复合语句
开头用begin，结尾用end包括起来的。
### if
```
if <条件> then
    <语句>
else
    <语句>; 
```
### case 
c中的switch。
```
case <表达式> of
    <数值>:<语句>;
    <数值>:<语句>;
else
    <语句>;
end;
```
### repeat
```
repeat
    <语句>
until <条件表达式>
```
### while
```
while <条件表达式> do
begin
 <语句>
end; 
```
### for
```
for <条件表达式> do
begin
    <语句>
end; 
```
比如如下的1-5.
```
for I:=1 to 5 do
begin
    Writeln(IntToStr(I));
end; 
```
如下的是5-1
```
for I:=5 downto 1 do
begin
    Writeln(IntToStr(I));
end;
```
### break和continue

### with 语句
当用到记录类型时，简化代码的输入量。

## 面向对象

### 类的定义
```
type ClassName = class (AncestorClass) 
    MemberList
end;
```
   - ClassName ： 类名
   - AncestorClass ： 继承的类的名称

类成员的能见度
|名称|说明|
|---|---|
|private|私有，不能被类所在的单元以外的程序访问|
|protected|保护，可以被该类的派生类访问，并且成为派生类的私有成员|
|public|共有，可以被该类以外访问|
|published|基本同共有|


不更新了，我总结了一下，delphi的强大是控件体系，并且pascal没有明显的短板，作为一个老古董语言，这很不容易，只是我看这个语言真的是别扭，语法严谨（begin和end一大堆，真不如{}），竟然没有好的编辑器，最大的问题是，我找问题的解决方案，找不到人啊，这个太小众了。

我收回前面的话，我刚才看了，[https://wiki.freepascal.org/LazReport_Tutorial](https://wiki.freepascal.org/LazReport_Tutorial),快速的做一个报表的，不得不说，真香.

有时间的话多看一下控件，快速开发，名不虚传。