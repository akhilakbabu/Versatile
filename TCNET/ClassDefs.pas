unit ClassDefs;

interface


uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,menus,
  Buttons, ExtCtrls, Dialogs, SysUtils, Messages,printers, TimeChartGlobals,
  StBarC,StrUtils, XML.UTILS, GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

 type TDrawWin=Class(Tform)  {General-purpose window where contents are drawn and scrolled.}
     procedure FormActivate(Sender: TObject);
     procedure FormDeActivate(Sender: TObject);
   private
    tabsDoPriv:          bool;
    leftCutoff,rightCutoff:  integer;
    procedure MyMouseWheelDown(Sender: TObject;  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure MyMouseWheelUp(Sender: TObject;  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure SetScroll;   {Sets Hscroll and Vscroll, cutoffs, x and y to top left}
    procedure SetScrollRange; {Initializes scroll bars based on MaxH, MaxW and Headwidth}
    procedure HomeEndPageUpDown(var key: word); {uses keys for scrolling}
    //procedure PopupMenuPopup(Sender: TObject);
   protected
    procedure Paint; override; {if Tabs do then (set font, call SetTabs, SetScrollRange methods),
                               SetScroll, normal paint (inherited)}
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
              {if 'V' pressed, calls Change View method, HomeEndPageUpDown.}
    procedure SetTabs; virtual;  {overridde to do Tabs calcs}
   public
    x,y: integer;           {window canvas position}
    codecolor:  integer;    {colour used text for main body of window}
    maxW,maxH:  integer;    {maximum width and height of contents (pixels)}
    headwidth:  integer;    {maximum width of heading}
    bottomCutoff,topCutoff:  integer;   {window limits to avoid unnecessary drawing}
    Hscroll,Vscroll:      integer;  {horizontal and vertical scroll positions}
    Tabs: array of integer;  {dynamic array for window tab positions.
                              Set size with SetLength in SetTabs method.}
    procedure printw(a:string);    {prints string a, at position x,y}
    procedure printwl(a:string);   {prints string and increments x to end of string}
    procedure fcolor(fcol:integer); {sets font and brush colour using FontColorPair array}
    procedure topcolor(fcol:integer); {sets font colour using FontColorPair}
    procedure printw2(a,b:string);  {prints a in colour 1, and b in codecolor}
    procedure newline;              {set x=0, y to next  line}
    procedure drawMyLine(x1,y1,x2,y2: integer);  {draws a line from x1,y1 to x2,y2, offset by Hmargin-Hscroll }
    procedure ChangeView; virtual;  {Increments WinView array and calls UpdateWin}
    procedure UpdateWin;            {set TabsDo and call refresh}
    destructor Destroy; override;   {Set winpos array to window position and wnFlag[] to false}
    constructor Create(AOwner: TComponent); override;
    procedure Maxtab(i,tab:integer;s:string);
              {Next Tab = Previous tab + larger of (tab and screen width of s) +blankwidth}
    property tabsDo:  bool read tabsDoPriv write tabsDoPriv; {Set to true when window is created}
      {If true, then SetTabs is called on paint. UpdateWin method sets it to true.}
 end;
{Implementation
1. Subclass from TdrawWin  e.g. TInfoWin = class(TDrawWin)
2. Add SetTabs method e.g.
  protected
    procedure SetTabs; override;
3. In SetTabs
(a) SetLength(Tabs, n)
(b) Use MaxTab procedure to calculate Tabs array
4. Don't need any sub - procedures in Paint procedure.}

 type TPrintDrawWin=Class(TPersistent)   {general-purpose class for printing the contents
  of a window.  It includes all the functions and variables needed for printing.}
   public
    x,y:        integer;    {position on page}
    mypagenumber: integer;  {current page number}
    PrintPageHeight,PrintPageWidth: integer;
    PrintCanvas: Tcanvas;
    codecolor:        integer;
    TabsDo: boolean;          {flag to calculate printing tabs;}
    PrntTabs: array of integer; {dynamic array for printing - set length before using.}
    DoHeader: boolean;
    function PageCount: string;  {returns a string with page number (if page >1)}
    procedure header;     {sets margins, prints school name & date stamp, calls Head procedure.}
    procedure SetTabs; virtual; abstract;  {override to calculate printing tabs.}
    procedure head; virtual; abstract;  {override to print additional headings}
    procedure PrintHead;   {calls SetTabs, then header. Use to print headings in main print}
    procedure UnderlineOn;    {turns underline on}
    procedure UnderlineOff;   {turns underline off}
    procedure fcolor(fcol:integer);  {if colorPrinterFlag, sets pen and brush colours using FontColorPair array.}
    procedure printw(a:string);    {prints string at x,y (offset by left margin)}
    procedure printwl(a:string);   {calls printw and increments x}
    procedure printw2(a,b:string); {prints a in colour 1, and b in codecolor}
    procedure StartNewPage;        {starts a new page and sets top margin}
    procedure newline;    {increases y by one line. If within 2 lines from bottom of page,
                         calls StartNewPage and Header}
    procedure drawMyLine(x1,y1,x2,y2: integer);  {draws a line from x1,y1 to x2,y2 (offset by left margin)}
    procedure printCustomAddon;    {prints custom add-on.}
    procedure Maxtab(i,tab:integer;s:string);  {Next Tab = Previous tab + larger of (tab and screen width of s) +Prntblankwidth}
    procedure AfterConstruction; override;     {sets TabsDo to true, so that SetTabs
             is automatically called from PrintHead, and sets pagewidth and Pageheight}
 end;
{Implementation
1. Subclass from TPrintDrawWin and override head and SetTabs procedures.
Example:
 type TPrintInfoWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;
var
 PrintInfoWin:    TPrintInfoWin;
2. In SetTabs
(a) SetLength(PrntTabs, n)
(b) Use MaxTab procedure to calculate Tabs array
3. In Head, add any additional headings for the printout. (school name, date stamp and page number printed automatically).
4. In main print procedure
(a) create an instance of class.  Put into a try finally loop so that instance is freed at the end.
(b) Don't need any sub - procedures in Print procedure.
(c) Call PrintHead at least once to print headings and call SetTabs procedure.
Example
PrintInfoWin:=TPrintInfoWin.create;
 with PrintInfoWin do
  try
   PrintHead;
   (do other stuff here)
Finally
   PrintInfoWin.free
End;}

 type TOutputWin=Class(TPersistent)   {general-purpose class for copying the contents
  of a window to the clipboard or a text file.  It includes all the functions and variables needed.}
   private
    delim,delim2:   string;
   public
      OutStream: Tstream;
      OutString: string;
      EndLineOut: string;
      DoHeader: boolean;
    procedure header;     {prints school name & date stamp, calls Head procedure.}
    procedure head; virtual; abstract;  {override to print additional headings}
    procedure printw(a:string);    {prints string at x,y (offset by left margin)}
    procedure printc(a:string);
    function Addc(a:string): string;
    procedure printLine(const a:array of string);
    procedure newline;    {start new line by adding end of line character(s)}
    procedure printCustomAddon;    {prints custom add-on.}
    procedure AfterConstruction; override;     {sets TabsDo to true, so that SetTabs is automatically called from PrintHead}
    destructor Destroy; override;  
 end;
{Implementation
1. Subclass from TOutputWin and override head procedure.
Example:
 type TOutInfoWin=class(TOutputWin)
  public
   procedure head; override;
 end;
var
 OutInfoWin:      TOutInfoWin;

2. In Head, add any additional headings for the printout.
  (school name, date stamp and page number printed automatically).
3. In main print procedure
(a) create an instance of class.  Put into a try finally loop so that instance is freed at the end.
(b) Don't need any sub procedures.
(c) Call Header to print headings.
(d)  In each line, use Printw for first item, Printc for later items, then newline.
Or, use PrintLine to print all iterms on a line
}




 type TCodeWin=Class(TDrawWin)     {print codes window with multiple views
                  The view is specified from winView[tag].
                  The codes only view (=0) shows multiple codes across the page.
                  Other views show one code for each line.
                  The paint method is part of the class.
                  Code selection is handled in the class.}
   private
    FselBox:    Trect;              {rectangle for selected code}
   protected
    procedure Paint; override;     {draws window based on PaintItem method}
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X1, Y1: Integer); override;
                                   {used to select a code}
    procedure DblClick; override;
    procedure PaintItem(i:integer;SelFlag:boolean); virtual; abstract;
                                   {override to draw code I at position x,y}
    procedure PaintItemFull(i:integer;SelFlag:boolean); virtual;
              {calculates the item position, highlights code (if selected) and calls PaintItem}
    procedure CalcItemPosition(i:integer); virtual;  {calculates the screen position of item i}
    function MyCodePoint(i:integer): integer; virtual;
    procedure PaintHead; virtual; abstract; {override to paint the heading at the top of the window}

   public
    CodeFit: smallint;       {number of codes per line}
    TotalCodes: smallint;    {number of codes in window}
    CodeWidth: smallint;     {width of code in pixels}
    yHead: integer;         {y position after heading is drawn}
    NewRect: Trect;          {rectangle used when changing a selected code}
    DoubleClick:        boolean;    {Used when window is double clicked,
                                to prevent additional code selection from MouseDown method}
    myselect,selCode:  smallint;  {selected code,code position}
    property selBox: Trect  read FselBox write FselBox;         {rectangle for selected code}
    procedure CalcScreenCodeFit;                               {calculates CodeFit}
    procedure HighlightBox(newrect:Trect);    {highlights rectangle for selected code}
    procedure RedoSelection;
    constructor Create(AOwner: TComponent); override;
 end;

{Implementation

1. Subclass from TcodeWin e.g. TTeWindow = class(TCodeWin)
2. Add required methods fo class e.g.
  Protected
    procedure PaintItem(i:integer;SelFlag:boolean); override;
    procedure SetTabs; override;
    procedure PaintHead; override;
3. In SetTabs:
(a)  Set Length for Tabs array e.g. setlength(Tabs,15);
(b)  Set TotalCodes
(c)  Calculate headwidth (width of heading)
 (d)  Calculate CodeWidth    e.g.  CodeWidth:=fwCode[mycode]+blankWidth
 (e)  Call  CalcScreenCodeFit method
(f)  Calculate tabs needed for longer views in PaintItem method
 (g) Add ReDoSelect for codes that have add/edit/delete dialogues
4. In Head - print headings (for each view)
5. In PaintItem print each item (for each view), making use of any sort order being used.}

type TPrintCodeWin=Class(TPrintDrawWin)   {class for printing code windows.
                It includes extra variables and procedures to simplify the print routine.}
  public
    CodeFit: smallint;        {number of codes per line on printed page}
    TotalCodes: smallint;     {number of codes to print}
    CodeWidth: smallint;      {width of code (on printed page)}
    procedure CalcPrintCodeFit;   {calculates CodeFit}
 end;


{Implementation

Same implementation as for TprintDrawWin except
(a) Subclass from TprintCodeWin
(b) In SetTabs, set Codefit, totalcodes and Codewidth.  Call CalcPrintCodeFit.
(c) In printing, can make use of printMap to show load maps. }

type TOutCodeWin=Class(TOutPutWin)   {class for printing code windows.
                It includes extra variables and procedures to simplify the print routine.}
  private
   FirstInLine: boolean;
  public
    CodeFit: smallint;        {number of codes per line on output}
    TotalCodes: smallint;     {number of codes to output}
    function CodeToPrint(i:integer):string; virtual; abstract;
    procedure CalcPrintCodeFit;   {calculates CodeFit}
    procedure Setup(setTotal: smallint);
    procedure PrintCode(i:integer);
 end;

type TLineCodewin=Class(TCodeWin)   {codes window with only one view - one line per code
                                    It includes all the features of TcodeWin, but with
                                    CalcItemPosition and MouseDown overridden in the class
                                    to do the different calculation of position.}
   protected
    procedure CalcItemPosition(i:integer); override;
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X1, Y1: Integer); override;
 end;

{Implementation
  Same implementation as for TcodeWin except:
  -  in SetTabs, don't need to calculate CodeWidth or call CalcScreenCodeFit method.}

type TListWin=Class(TDrawWin)   {base class for list windows - student and timetable}
   protected
    procedure GetLists; virtual; abstract; {override to set NumOfLists and sizes of lists}
    procedure GetListContents(i: integer); virtual; abstract; {override to set list contents}
   public
    listtype: smallint;   {sets whether handled from class(student), or type of timetable}
    tabStField: smallint; {tab spacing of student fields being shown}
    NumOfLists: smallint;  {number of lists}
    TotalCount: integer;  {number of items in all the lists}
    ListSize: array of integer;  {number of items in each list}
    ListTop: array of integer;    {top y setting for each list}
    ListSet: array of integer;    {descriptor for list e.g. teacher, tutor, roll class}
    ListContents: array of integer;  {array pointing to items for a particular list}
    StBarCode1:   TStBarCode;
    procedure StudEnrolment(i:integer;SelFlag,DoDouble:boolean);  {prints choices in enrolment format}
    procedure CalcTabStField;     {calculates tabStField based of preference settings}
    procedure SetArraySizes;      {sets array sizes needed based on NumOfLists}
    procedure ShowStudentNameBrief(i: integer);   {print student name and increment x}
    procedure ShowStudentHouse(i: integer);    {print student details and increment x}
    procedure ShowStudentName(i: integer);    {print student name and details, increment x}
    procedure ShowIDbarcode(i:integer;SelFlag:boolean);
    procedure BarcodeMake;
 end;
 {No implemenation - used as base class for other list classes}


 type TPrintListWin=Class(TPrintDrawWin)    {general list class for printing}
   protected
    procedure GetLists; virtual; abstract; {override to set NumOfLists and sizes of lists}
    procedure GetListContents(i: integer); virtual; abstract; {override to set list contents}
   public
    listtype: smallint;  {listtype=1 is handled from class, other types handled directly }
    tabStField: smallint;  {tab spacing of student fields being shown}
    NumOfLists: smallint;   {number of lists}
    TotalCount: integer;    {number of items in all the lists}
    ListSize: array of integer;  {number of items in each list}
    ListSet: array of integer;   {descriptor for list e.g. teacher, tutor, roll class}
    ListContents: array of integer;  {array pointing to items for a particular list}
    StBarCode1:   TStBarCode;
    procedure StudEnrolment(i:integer;DoDouble:boolean);   {prints choices in enrolment format}
    procedure CalcTabStField;      {calculates tabStField based of preference settings}
    procedure SetArraySizes;       {sets array sizes needed based on NumOfLists}
    procedure ShowStudentNameBrief(i: integer);  {print student name and increment x}
    procedure ShowStudentHouse(i: integer);   {print student details and increment x}
    procedure ShowStudentName(i: integer);    {print student name and details, increment x}
    procedure PrintIDbarcode(i:integer);
    procedure BarcodeMake;
 end;
 {No implemenation - used as base class for other list classes}

  type TOutListWin=Class(TOutputWin)    {general list class for output}
   protected
    procedure GetLists; virtual; abstract; {override to set NumOfLists and sizes of lists}
    procedure GetListContents(i: integer); virtual; abstract; {override to set list contents}
   public
    listtype: smallint;  {listtype=1 is handled from class, other types handled directly }
    NumOfLists: smallint;   {number of lists}
    TotalCount: integer;    {number of items in all the lists}
    TabCount: smallint;   {number of tabs used in student name}
    ListSize: array of integer;  {number of items in each list}
    ListSet: array of integer;   {descriptor for list e.g. teacher, tutor, roll class}
    ListContents: array of integer;  {array pointing to items for a particular list}
    procedure StudEnrolment(i:integer;DoDouble:boolean);   {prints choices in enrolment format}
    procedure SetArraySizes;       {sets array sizes needed based on NumOfLists}
    procedure ShowStudentName(i: integer);    {print student name and details}
    procedure CalcTotalCount;
    procedure CalcTabCount; {calculate name tabs}
 end;
 {No implemenation - used as base class for other list classes}



 type TStudListWin=Class(TListWin)   {class for showing student lists}
   private
    selbox,newrect: Trect;       {rectangle for selected student, and changing selection}
    procedure DisplayStudent(i:integer;SelFlag:boolean);  {print a student}
    procedure PaintItemFull(pos,list:integer;SelFlag:boolean);
                   {calculate position,highlight if selected, show student}
    procedure CalcItemPosition(pos,list: integer);  {calculate position of student}
    procedure ShowLists;       {overall routine to show all lists}
    procedure BlockTitles(i:integer);  {show headings on block columns}
    procedure HighlightBox(newrect:Trect);   {set colour and highlight box}
    procedure RemoveSelection(pos,list: integer); {remove highlight and repaint student}
   protected
    procedure ListHead(i:integer); virtual; abstract;   {override to print list heading}
    procedure ListFooter(i:integer);    {print footer of list - number of students in list}
    procedure PaintHead; virtual; abstract;    {main heading of all lists}
    procedure Paint; override;     {class paints all student lists if listtype=1}
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X1, Y1: Integer); override;
           {calculate  which list and item, remove existing selection, and select student}
   public
    StudSelect,ListSelect,Selcode: integer;   {student, list and item of selected student}
    StudHeight: integer;     {height for one student - pixels}
    StudLines: integer;      {lines for one student}
    ListHeadLines: integer;   {lines in list heading}
    EnrolFlag: boolean;        {flag for printing in enrolment format}
    ShowZeroList: boolean;      {if true, show empty lists (no items in list)}
    DoubleClick:        boolean;   {flag to set for mouse double click}
    procedure CalcArrayTops;    {calculates the top position of each list}
    procedure RedoSelection;    {find selcode and ListSelect for selected student}
    procedure ShowStudTt;       {show student timetable for selected student}
    procedure AfterConstruction; override;   { tabsDo:=true; SelCode:=0;}
 end;
 {Implementation
1. SubClass from TStudListWin e.g. TStudentListWin = class(TStudListWin)
2. Add required methods fo class e.g.
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure PaintHead;  override;
    procedure ListHead(i:integer);  override;
3. In SetTabs
 (a) Set Length of Tabs array if needed for lists not printed by class e.g. SetLength(Tabs,8);
 (b) set ListType, codeColor, EnrolFlag, ShowZeroList, ListHeadLines
 (c) if ListType=1 then call GetLists and CalcArrayTops
 (c) call RedoSelection (in case Selection dialogue used with new settings)
4.  In GetLists
(a) Calculate how many lists (NumOfLists) and call SetArraySizes
(b) Calulated number of students in each list (ListSize array)
(c) Define ListSet to specify the list e.g. roll class code, tutor code, etc.
5. In GetListContents - set ListContents array size and set the array to the students in
the list.
e.g.  SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents); - separate procedure so can
 be reused for printing
6.  In PaintHead - print the contents of the list
7.  In ListHead - print the heading for list i
8.  Paint - only need paint if also showing a student list not implemented in the class}


 type TPrintStudListWin=Class(TPrintListWin)  {class for printing student lists}
   private
    LastOne: boolean;      {last student to print}
    procedure DisplayStudent(i:integer);  {print a student}
    procedure BlockTitles(i:integer);  {show headings on block columns}
   protected
    procedure ListFooter(i:integer);  {print footer of list - number of students in list}
    procedure ListHead(i:integer); virtual; abstract;  {override to print list heading}
   public
    StudHeight: integer;   {height for one student - pixels}
    StudLines: integer;     {lines for one student}
    EnrolFlag: boolean;     {flag for printing in enrolment format}
    ShowZeroList: boolean;  {if true, show empty lists (no items in list)}
    procedure CalcHeights;  {calculates StudLines and StudHeight}
    procedure ShowLists;    {prints all student lists}
 end;
{Implementation
1.  Define type and methods to override e.g.
type TPrintStudList=class(TPrintStudListWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;
2.  Define variable e.g. PrintStudList:    TPrintStudList;
3. In printing routine
(a) define instance of class
(b) if ListType=1 then call SetTabs and ShowLists, else do own printing
e.g.
 PrintStudList:=TPrintStudList.Create;
 with PrintStudList do
  try
   SetTabs;
   ShowLists;
  finally
   PrintStudList.free;
  end;
4. In Head, print overall list heading
5. In ListHead print heading for list i
6. In SetTabs
 (a) Set Length of PrntTabs array if needed for lists not printed by class
 (b) set ListType, codeColor, EnrolFlag, ShowZeroList
 (c) if ListType=1 then call GetLists and CalcHeights
7. In GetLists define number of lists and sizes.  Can reuse code from window e.g.
 NumOfLists:=StudentListWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=StudentListWin.ListSize[i];
    ListSet[i]:=StudentListWin.ListSet[i];
   end;
 8. In GetListContents - set ListContents array size and set the array to the students in
the list.  Can re-use procedure from window}

 type TOutStudListWin=Class(TOutListWin)  {class for printing student lists}
   private
    LastOne: boolean;      {last student to print}
    procedure DisplayStudent(i:integer);  {print a student}
   protected
    procedure ListFooter(i:integer);  {print footer of list - number of students in list}
    procedure ListHead(i:integer); virtual; abstract;  {override to print list heading}
   public
    EnrolFlag: boolean;     {flag for printing in enrolment format}
    ShowZeroList: boolean;  {if true, show empty lists (no items in list)}
    procedure ShowLists(const pIsSpecial: Boolean = False);    {prints all student lists}
    procedure ExportToSpecialTextFile;
 end;
{Implementation
1.  Define type and methods to override e.g.
type TOutStudList=class(TOutStudListWin)
  public
   procedure head; override;
   procedure SetTabs;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;
2.  Define variable e.g. OutStudList:    TOutStudList;
3. In printing routine
(a) define instance of class
(b) if ListType=1 then call SetTabs and ShowLists, else do own printing
e.g.
 OutStudList:=TOutStudList.Create;
 with OutStudList do
  try
   SetTabs;
   ShowLists;
  finally
   OutStudList.free;
  end;
4. In Head, print overall list heading
5. In ListHead print heading for list i
6. In SetTabs
 (a) set ListType, EnrolFlag, ShowZeroList
 (b) if ListType=1 then call GetLists and CalcTotalCount
7. In GetLists define number of lists and sizes.  Can reuse code from window e.g.
 NumOfLists:=StudentListWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=StudentListWin.ListSize[i];
    ListSet[i]:=StudentListWin.ListSet[i];
   end;
 8. In GetListContents - set ListContents array size and set the array to the students in
the list.  Can re-use procedure from window}

 type TListTtWin=Class(TListWin)   {class for daily and weekly timetables}
   private
    WeeklyHeight: integer;    {height of weekly timetable}
    procedure DailyTt;   {prints daily timetables using list information}
    procedure WeeklyTt;   {prints weekly timetables using list information}
    Function DayListSize(i:integer):integer;  {size of day list}
   protected
    procedure ShowTtItems(i,d,p,x1: integer); virtual; abstract; {override to print cell in timetable}
    procedure ListHead(i,d:integer); virtual; abstract; {override to print list heading}
    procedure ShowName(i:integer); virtual; abstract;  {override to print name for timetable}
    procedure WeeklyFooter(i:integer);  virtual; abstract; {override to print weekly footer}
    procedure Paint; override;
   public
    dx: smallint;      {spacing for timetable column}
    tab1: smallint;    {spacing at left of daily timetable}
    tabP: smallint;    {spacing for time slot name}
    day1,day2: smallint;  {range of days for daily timetable}
    yFooter,FooterWidth: smallint;   {spacing needed for weekly footer}
    procedure ShowDaily(studnum,dI: integer); {prints individual daily timetable}
    procedure ShowWeekly(studnum: integer);  {prints individual weekly timetable}
    procedure CalcArrayTops;   {calculates the top position of each list}
 end;
{Implementation
1. SubClass from TListTtWin e.g. TRoTtable = class(TListTtWin)
2. Add required methods fo class e.g.
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure ShowTtItems(i,d,p,x1: integer); override;
    procedure ListHead(i,d:integer);  override;
    procedure ShowName(i:integer);  override;
    procedure WeeklyFooter(i:integer); override;
3. In SetTabs
(a) Set listtype (1=daily,2=weekly), codecolor, day1, day2, yFooter
(b) Calculate dx, tab1
(c) Call GetLists, CalcArrayTops
4. Implement GetLIsts,GetListContents,ListHead,ShowName (as in TStudListWin)
5. ShowTtItems - print the contents of the timetable cell
6. WeeklyFooter - print the required footer.}



 type TPrintListTtWin=Class(TPrintListWin)    {print list of timetables}
   private
    y2t,y1t: integer;    {y positions used for drawing lines}
    WeeklyHeight: integer;    {height of weekly timetable}
    procedure ShowDaily(var FirstOne:boolean; studnum,dI: integer); {prints individual daily timetable}
    procedure ShowWeekly(studnum: integer);  {prints individual weekly timetable}
   protected
    procedure ShowTtItems(i,d,p,x1: integer); virtual; abstract; {override to print cell in timetable}
    procedure ShowName(i:integer); virtual; abstract; {override to print name for timetable}
    procedure WeeklyFooter(i:integer);  virtual; abstract;
    procedure ListHead(i,d:integer); virtual; abstract;  {override to print list heading}
   public
    dx: smallint;   {spacing for timetable column}
    tab1: smallint;  {spacing at left of daily timetable}
    day1,day2: smallint;  {range of days for daily timetable}
    yFooter: smallint;    {spacing needed for weekly footer}
    procedure DailyTt;    {prints daily timetables using list information}
    procedure WeeklyTt;   {prints weekly timetables using list information}
    procedure PaintOnPrinter;  {prints all lists of timetables}
 end;
{Implementation
1.  Define type and methods to override e.g.
type TPrintRoTtWin=class(TPrintListTtWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i,d:integer); override;
   procedure ShowName(i:integer);  override;
   procedure WeeklyFooter(i:integer); override;
   procedure ShowTtItems(i,d,p,x1: integer);  override;
 end;
2.  Define variable e.g. PrintRoTtWin:    TPrintRoTtWin;
3. In SetTabs
(a) Set listtype (1=daily,2=weekly), codecolor, day1, day2, yFooter
(b) Calculate dx, tab1
(c) Call GetLists
4. Implement GetLIsts,GetListContents,ListHead,ShowName (as in TPrintStudListWin)
5. ShowTtItems - print the contents of the timetable cell
6. WeeklyFooter - print the required footer.}


 type TOutListTtWin=Class(TOutListWin)    {print list of timetables}
   private
    procedure ShowDaily(studnum,dI: integer); {prints individual daily timetable}
    procedure ShowWeekly(studnum: integer);  {prints individual weekly timetable}
   protected
    procedure ShowTtItems(i,d,p: integer); virtual; abstract; {override to print cell in timetable}
    procedure ShowName(i:integer); virtual; abstract; {override to print name for timetable}
    procedure WeeklyFooter(i:integer);  virtual; abstract;
    procedure ListHead(i,d:integer); virtual; abstract;  {override to print list heading}
    procedure SetTabs; virtual; abstract;
   public
    day1,day2: smallint;  {range of days for daily timetable}
    procedure DailyTt;    {prints daily timetables using list information}
    procedure WeeklyTt;   {prints weekly timetables using list information}
    procedure PaintOnOutput;  {prints all lists of timetables}
 end;
{Implementation   ********  yet to do ************
1.  Define type and methods to override e.g.
type TOutRoTtWin=class(TOutListTtWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i,d:integer); override;
   procedure ShowName(i:integer);  override;
   procedure WeeklyFooter(i:integer); override;
   procedure ShowTtItems(i,d,p,x1: integer);  override;
 end;
2.  Define variable e.g. OutRoTtWin:    TOutRoTtWin;
3. In SetTabs
(a) Set listtype (1=daily,2=weekly), day1, day2
(b) Call GetLists
(c) set TabCount
4. Implement GetLIsts,GetListContents,ListHead,ShowName (as in TPrintStudListWin)
5. ShowTtItems - print the contents of the timetable cell
6. WeeklyFooter - print the required footer.}


implementation

uses tcommon,StCommon,tcommon2,main,PrintPreviewForm, customOutput;

// TDrawWin Procedures


destructor TDrawWin.Destroy;
begin
 XML_DISPLAY.winpos[tag].state:=windowstate;
 XML_DISPLAY.winpos[tag].top:=top;
 XML_DISPLAY.winpos[tag].left:=left;
 XML_DISPLAY.winpos[tag].width:=width;
 XML_DISPLAY.winpos[tag].height:=height;
 wnFlag[tag]:=false;
 inherited;
end;

constructor TDrawWin.Create(AOwner: TComponent);
begin
  OnActivate := FormActivate;
  inherited;
  self.VertScrollBar.Tracking := true;
  self.HorzScrollBar.Tracking := true;
  self.OnMouseWheelDown := MyMouseWheelDown;
  self.OnMouseWheelUp := MyMouseWheelUp;
  //if Assigned(Self.PopupMenu) then
    //Self.PopupMenu.OnPopup := PopupMenuPopup;
end;

procedure TDrawWin.FormActivate(Sender: TObject);
begin
 mainform.Copy1.ShortCut:=ShortCut(word('C'),[ssCtrl]);
 mainform.CopyWin.ShortCut:=ShortCut(word('C'),[ssCtrl]);
 inherited;
end;

procedure TDrawWin.FormDeActivate(Sender: TObject);
begin
 mainform.Copy1.ShortCut:=ShortCut(0,[]);
 mainform.CopyWin.ShortCut:=ShortCut(0,[]);
 inherited;
end;

procedure TDrawWin.SetTabs;
begin
 tabsDo:=false;
end;

procedure TDrawWin.SetScrollRange;
begin
 if maxW<Headwidth then maxW:=Headwidth;
 if maxH>maxWinScrollRange then maxH:=maxWinScrollRange;
 if (maxW+Hmargin)>maxWinScrollRange then maxW:=maxWinScrollRange-Hmargin;
 horzscrollbar.range:=maxW+Hmargin;
 vertscrollbar.range:=maxH;
end;


procedure TDrawWin.Paint;
begin
 SetScroll;
 if tabsDo then
  begin
   maxW:=0;
   canvas.font.assign(XML_DISPLAY.tcfont);
   setTabs;
   SetScrollRange;
   Invalidate;
  end;
 tabsDo:=false;
 inherited;
end;

{procedure TDrawWin.PopupMenuPopup(Sender: TObject);
begin
  Self.Show;
end;}

procedure TDrawWin.UpdateWin;
begin
 tabsDo:=True;
 repaint;
end;

procedure TDrawWin.ChangeView;
begin
 inc(winView[tag]);
 if winView[tag]>XML_DISPLAY.winViewMax[tag] then winView[tag]:=0;
 UpdateWin;
end;



procedure TDrawWin.HomeEndPageUpDown(var key: word);
var
 t,r,hs:       integer;
 t2,horzr,horzw:       integer;
 vertCorrect:   integer;
begin
 if key=0 then exit;
 t:=vertscrollbar.position;
 r:=vertscrollbar.range;
 hs:=horzscrollbar.increment;
 t2:=horzscrollbar.position;
 horzr:=horzscrollbar.range;
 horzw:=clientwidth;
 vertCorrect:=0;
 if txtHeight<clientHeight then vertCorrect:=txtHeight;
 case key of
  vk_prior: begin  {page up}
             t:=t-clientheight+vertCorrect;
             if t<0 then t:=0;
             vertscrollbar.position:=t;
            end;
  vk_next: begin  {page down}
             t:=t+clientheight-vertCorrect;
             if t>(r-clientheight) then t:=r-clientheight;
             vertscrollbar.position:=t;
            end;
  vk_home: vertscrollbar.position:=0;   {home}
  vk_end: vertscrollbar.position:=r-clientheight;  {end}
  { 4 arrow keys }
  vk_up:  begin
           t:=t-txtHeight;  if t<0 then t:=0;
           vertscrollbar.position:=t;
          end;
  vk_down: begin
            t:=t+txtHeight;
            if t>(r-clientheight) then t:=r-clientheight;
            vertscrollbar.position:=t;
           end;
  vk_left:  begin
             t2:=t2-hs;
             if t2<0 then t2:=0;
             horzscrollbar.position:=t2;
            end;
  vk_right: begin
             t2:=t2+hs;
             if t2>(horzr-horzw) then t2:=horzr-horzw;
             horzscrollbar.position:=t2;
            end;

 end; {case}

end;

procedure TDrawWin.KeyDown(var Key: Word; Shift: TShiftState);
begin
 if (uppercase(chr(key))='V') and (XML_DISPLAY.winViewMax[tag]>0) then
  begin
   ChangeView;
   key:=0;
  end;
 HomeEndPageUpDown(key);
 inherited;
end;

procedure TDrawWin.MyMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
 VertScrollBar.Position:=VertScrollBar.Position+100;
end;

procedure TDrawWin.MyMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
 VertScrollBar.Position:=VertScrollBar.Position-100;
end;


procedure TDrawWin.SetScroll;
begin
  Hscroll:=self.HorzScrollBar.Position;
  Vscroll:=self.VertScrollBar.Position;
  topCutoff:=-2*txtHeight;
  bottomCutoff:=Height+txtHeight;
  leftCutoff:=Hscroll-Hmargin;
  rightCutoff:=leftCutoff+Width+Hmargin;
  if rightCutoff>maxWinScrollRange then rightCutoff:=maxWinScrollRange;
  x:=0;  y:=txtHeight-Vscroll;
end;

procedure TDrawWin.printw(a:string);
 var
  x1,x2:   integer;
 begin
  x1:=x+Hmargin;
  x2:=x1+canvas.textwidth(a);

  if (y>topCutoff) and (x2>leftCutoff) and (x1<rightCutoff)
       then canvas.textout(x+Hmargin-Hscroll,y,a);
 end;

procedure TDrawWin.printwl(a:string);
begin
 printw(a);
 x:=x+canvas.textwidth(a);
end;

procedure TDrawWin.fcolor(fcol:integer);
  begin
    canvas.font.color:=FontColorPair[fcol,1];
    canvas.brush.color:=FontColorPair[fcol,2];
  end;

procedure TDrawWin.topcolor(fcol:integer);
 begin
  canvas.font.color:=FontColorPair[fcol,1];
 end;


procedure TDrawWin.printw2(a,b:string);
  begin
    fcolor(cpNormal);
    printwl(a);
    fcolor(codeColor);
    printwl(b);
  end;

procedure TDrawWin.newline;
 begin
   x:=0; y:=y+txtHeight;
 end;

procedure TDrawWin.drawMyLine(x1,y1,x2,y2: integer);
begin
  canvas.moveto(x1+Hmargin-Hscroll,y1);
  canvas.lineto(x2+Hmargin-Hscroll,y2);
end;

procedure TDrawWin.Maxtab(i,tab:integer;s:string);
var
 temp: integer;
begin
 temp:=canvas.textwidth(s);
 if tab>temp then temp:=tab;
 Tabs[i]:=Tabs[i-1]+temp+blankwidth;
end;

// TPrintDrawWin procedures

procedure TPrintDrawWin.AfterConstruction;
begin
 TabsDo:=true; DoHeader:=true;
 if PrinterOn then
  begin
   PrintCanvas:=Printer.Canvas;
   PrintPageHeight:=Printer.PageHeight;
   PrintPageWidth:=Printer.PageWidth;
  end
 else if PreviewOn then
  begin
   PrintCanvas:=ppCanvas;
   PrintPageHeight:=PrntPreviewForm.PageHeight;
   PrintPageWidth:=PrntPreviewForm.PageWidth;
  end;
end;

procedure TPrintDrawWin.PrintHead;
begin
 if TabsDo then SetTabs;
 TabsDo:=false;
 x:=0;    y:=prntVmargin;
 fcolor(cpNormal);
 header;
end;

procedure TPrintDrawWin.UnderlineOn;
begin
 PrintCanvas.font.style:=PrintCanvas.font.style+[fsunderline];
end;

procedure TPrintDrawWin.UnderlineOff;
begin
 PrintCanvas.font.style:=PrintCanvas.font.style-[fsunderline];
end;



procedure TPrintDrawWin.header;
begin
 y:=PrntVmargin;
 //UnderlineOn;
 NewLine;
if DoHeader then printwl(School+'  '+Version+'  ');
 if XML_DISPLAY.datestamp then
   begin
    printwl(dateStr);
    printwl('  '+timetostr(time));
   end;
 x:=0; y:=y+PrnttxtHeight;
 NewLine;
 UnderlineOff;
 head;
end;

procedure TPrintDrawWin.printw(a:string);
begin
 PrintCanvas.textout(x+prntHmargin,y,a);
end;

procedure TPrintDrawWin.printwl(a:string);
begin
 printw(a);
 x:=x+PrintCanvas.textwidth(a);
end;

procedure TPrintDrawWin.fcolor(fcol:integer);
begin
 if XML_DISPLAY.colorPrinterFlag then
  begin
   PrintCanvas.font.color:=FontColorPair[fcol,1];
   PrintCanvas.brush.color:=FontColorPair[fcol,2];
  end; 
end;

procedure TPrintDrawWin.printw2(a,b:string);
begin
 fcolor(cpNormal);
 printwl(A);
 fcolor(codeColor);
 printwl(b);
end;


procedure TPrintDrawWin.StartNewPage;
begin
 if PrinterOn then Printer.newpage
  else if PreviewOn then
  begin
   PrntPreviewForm.NewPage;
   PrintCanvas:=ppCanvas;
   ppcanvas.Font.Assign(PreviewFont);
  end;
 x:=0; y:=prntVmargin;
end;

procedure TPrintDrawWin.newline;
begin
 x:=0; y:=y+PrnttxtHeight;
 if (y+PrnttxtHeight)>(PrintPageHeight-2*prntTxtHeight) then
   begin
    StartNewPage;
    Header;
   end;
end;

procedure TPrintDrawWin.drawMyLine(x1,y1,x2,y2: integer);
begin
  PrintCanvas.moveto(x1+prntHmargin,y1);
  PrintCanvas.lineto(x2+prntHmargin,y2);
end;

function TPrintDrawWin.PageCount:string;
begin
 mypagenumber:=1;
 if PrinterOn then mypagenumber:=Printer.PageNumber
  else if PreviewOn then mypagenumber:=1+PrntPreviewForm.TotalPages;
 result:='';
 if mypagenumber>1 then
   result:='  Page '+inttostr(mypagenumber);
end;

procedure TPrintDrawWin.printCustomAddon;
var
 i:       integer;
begin
 fcolor(cpNormal);
 parseCustomInfo;
 if CustomCnt=0 then exit;
 newline;
 fcolor(cpNormal);
 for i:=1 to CustomCnt do
 begin
  printw(CustomArr[i]);
  newline;
 end;
end;

procedure TPrintDrawWin.Maxtab(i,tab:integer;s:string);
var
 temp: integer;
begin
 temp:=PrintCanvas.textwidth(s);
 if tab>temp then temp:=tab;
 PrntTabs[i]:=PrntTabs[i-1]+temp+PrntBlankwidth;
end;



// TOutputWin procedures

procedure TOutputWin.printCustomAddon;
var
 i:       integer;
begin
 parseCustomInfo;
 if CustomCnt=0 then exit;
 newline;
 for i:=1 to CustomCnt do
 begin
  printw(CustomArr[i]);
  newline;
 end;
end;

procedure TOutputWin.newline;
begin
 OutStream.Write(Pchar(EndLineOut)^,length(EndLineOut));
end;

procedure TOutputWin.printw(a:string);
var
 b: string;
begin
 b:=delim2+a+delim2;
 OutStream.Write(Pchar(b)^,length(b))
end;

function TOutputWin.Addc(a:string): string;
var
 b: string;
begin
 b:=delim+delim2+a+delim2;
 result:=b;
end;

procedure TOutputWin.printc(a:string);
var
 b: string;
begin
 b:=delim+delim2+a+delim2;
 OutStream.Write(Pchar(b)^,length(b))
end;

procedure TOutputWin.printLine(const a:array of string);
var
 i: integer;
begin
 printw(a[Low(a)]);
 if High(a)>Low(a) then
  for i:=Low(a)+1 to High(a) do printc(a[i]);
 newline; 
end;

procedure TOutputWin.header;
var
 hasOutput: boolean;
begin
 hasOutput:=false;
 if DoHeader then
  begin
   hasOutput:=true;
   printw(School);
   printc(Version);
  end;
 if XML_DISPLAY.datestamp then
   begin
    hasOutput:=true;
    printc(dateStr);
    printc(timetostr(time));
   end;
 if hasOutput then newline;
 head;
end;


procedure TOutputWin.AfterConstruction;
begin
 DoHeader:=true;
 if TextFileOut then
  begin
   OutStream:=TFileStream.Create(TextFileName,fmCreate or fmOpenWrite);
   delim:=chr(XML_DISPLAY.txtsep);
   delim2:=chr(XML_DISPLAY.txtlim);
   if XML_DISPLAY.txtlim=0 then delim2:='';
   EndLineOut:=endline;
  end
 else if CopyOut then
  begin
   OutString:='';
   OutStream:=TStringStream.Create(OutString);
   delim:=ht;delim2:='';
   EndLineOut:=endline;
  end;
end;

destructor TOutputWin.Destroy;
begin
 if CopyOut then
  myCopyString:=TStringStream(OutStream).DataString;
 OutStream.Free;
 Inherited;
end;


// TCodeWin procedures

procedure TCodeWin.CalcScreenCodeFit;
var
 tmpInt: integer;
begin
  //tmpInt:=trunc(screen.width*0.9);
  //CodeFit:= tmpInt div CodeWidth;
  tmpInt := Trunc(Self.Width - HMargin);
  if CodeWidth <> 0 then
    CodeFit := tmpInt div CodeWidth
  else
    CodeFit := 0;
  if CodeFit<minCodeFit then CodeFit:=minCodeFit;
  if CodeFit>TotalCodes then CodeFit:=TotalCodes;
  if Codefit=0 then Codefit:=1;
  if winView[tag]>0 then Codefit:=1;
  maxH:=txtheight*((TotalCodes div CodeFit)+5)
end;

procedure TCodeWin.PaintItemFull(i:integer;SelFlag:boolean);
begin
 CalcItemPosition(i);
 if (y<topCutoff) or (y>bottomCutoff) then exit;
 if selFlag then HighlightBox(newrect);
 PaintItem(i,SelFlag);
end;

procedure TCodeWin.paint;
var
 i: integer;
 SelFlag:       boolean;
begin
 inherited;
 if (selcode<0) or (selcode>Totalcodes) then
  begin
   selcode:=0; Fselbox.left:=0; Fselbox.top:=0; Fselbox.bottom:=0; Fselbox.right:=0;
  end;
 canvas.fillrect(selbox);
 Fselbox.left:=0; Fselbox.top:=0; Fselbox.bottom:=0; Fselbox.right:=0;
 PaintHead;
 fcolor(codecolor); yHead:=y;
 if TotalCodes>0 then
   for i:=1 to TotalCodes do
     begin
      selFlag:=(selCode>0) and (i=selCode);
      PaintItemFull(i,SelFlag);
      if y>bottomCutoff then break; {no printing past range}
     end;  {for i  to totalcodes}
end;

procedure TCodeWin.HighlightBox(newrect:Trect);
begin
 SelBox:=newrect;
 canvas.font.color:=FontColorHiLitePair[codeColor,1];
 canvas.brush.color:=FontColorHiLitePair[codeColor,2];
 canvas.fillrect(selbox);
end;



constructor TCodeWin.Create(AOwner: TComponent); 
begin
 inherited;
 myselect:=0;
end;

function TCodeWin.MyCodePoint(i:integer): integer;
begin
 result:=i;
end;

procedure TCodeWin.RedoSelection;
var
 i: integer;
begin
 SelCode:=0;
 if MySelect>0 then
  for i:=1 to TotalCodes do
   if MySelect=MyCodePoint(i) then
    begin SelCode:=i; break; end;
end;


procedure TCodeWin.CalcItemPosition(i:integer);
begin
 if winView[tag]=0 then
   begin
     x:=((i-1) mod codefit)*CodeWidth;
     y:=yHead + ((i-1) div codefit)*txtHeight;
     {if X >= Self.ClientWidth -10 then
     begin
       x := 0;
       y := y + txtHeight;
     end
     else
     begin
     end;}
     newrect.left:=x+Hmargin-Hscroll;
     newrect.right:=newrect.left+CodeWidth-blankWidth;
   end
 else
   begin
    x:=0; y:=yHead +(i-1)*txtHeight;
    newrect.left:=x+Hmargin-Hscroll;
    newrect.right:=newrect.left+maxW;
   end;
 newrect.top:=y; newrect.bottom:=y+TxtHeight;
end;


procedure TCodeWin.DblClick;
begin
 inherited;
 DoubleClick:=true;
 Mainform.SelectDlgExecute(Self);
end;


procedure TCodeWin.MouseDown(Button: TMouseButton;Shift: TShiftState; X1, Y1: Integer);
var
 xx,yy:  integer;
 newselcode: integer;
begin
 if doubleclick then
   begin
    doubleclick:=false;
    exit;
   end;

 if winView[tag]=0 then
 begin
  xx:=((x1-Hmargin+Hscroll) div CodeWidth)+1;
  if (xx>Codefit) then xx:=Codefit;
  yy:=((y1-yHead) div txtHeight);
  newselcode:=xx+yy*Codefit;
 end
 else  {not winView[tag]=0}
  begin
   yy:=((y1-yHead) div txtHeight);
   newselcode:=yy+1;
  end;
 if (y1+Vscroll)<=(yHead) then newselcode:=0;
 if ((newselcode>0) and (newselcode<=TotalCodes)
      and (newselcode<>selCode)) then
 begin
  if selCode>0 then
  begin
   canvas.fillrect(selbox);
   PaintItemFull(selcode,false);
  end;
  selCode:=newselcode;
  PaintItemFull(selcode,true);
 end;
  if SelCode>0 then MySelect:=MyCodePoint(SelCode) else MySelect:=0;
end;






// TPrintCodeWin procedures



procedure TPrintCodeWin.CalcPrintCodeFit;
var
 tmpInt: integer;
begin
 tmpInt:=trunc(PrintPageWidth*0.9)-prntHmargin;
 CodeFit:= tmpInt div Codewidth;
 if CodeFit>TotalCodes then CodeFit:=TotalCodes;
 if Codefit=0 then Codefit:=1;
end;


// TOutCodeWin procedures

procedure TOutCodeWin.CalcPrintCodeFit;
begin
 CodeFit:=10;
 if CodeFit>TotalCodes then CodeFit:=TotalCodes;
 if Codefit=0 then Codefit:=1;
end;

procedure TOutCodeWin.Setup(setTotal: smallint);
begin
 TotalCodes:=setTotal;
 FirstInLine:=true;
 CalcPrintCodeFit;
 Header;
end;

procedure TOutCodeWin.PrintCode(i:integer);
begin
 if FirstInLine then
   begin printw(CodeToPrint(i)); FirstInLine:=false; end
  else printc(CodeToPrint(i));
  if (i mod codefit)=0 then begin newline;FirstInLine:=true; end;
end;

//  TLineCodeWin procedures

procedure TLineCodeWin.CalcItemPosition(i:integer);
begin
 x:=0; y:=yHead +(i-1)*txtHeight;
 newrect.left:=x+Hmargin-Hscroll;
 newrect.right:=newrect.left+maxW;
 newrect.top:=y; newrect.bottom:=y+TxtHeight;
end;

procedure TLineCodeWin.MouseDown(Button: TMouseButton;Shift: TShiftState; X1, Y1: Integer);
var
 yy:  integer;
 newselcode: integer;
begin
 if doubleclick then
   begin
    doubleclick:=false;
    exit;
   end;
 yy:=((y1-yHead) div txtHeight);
 newselcode:=yy+1;
 if (y1+Vscroll)<=(yHead) then newselcode:=0;
 if ((newselcode>0) and (newselcode<=TotalCodes)
      and (newselcode<>selCode)) then
 begin
  if selCode>0 then
  begin
   canvas.fillrect(selbox);
   PaintItemFull(selcode,false);
  end;
  selCode:=newselcode;
  PaintItemFull(selcode,true);
 end;
end;

//  TListWin procedures

procedure TListWin.SetArraySizes;
begin
 SetLength(ListSize,NumOfLists+2);
 SetLength(ListTop,NumOfLists+2);
 SetLength(ListSet,NumOfLists+2);
end;

procedure TListWin.ShowStudentNameBrief(i: integer);
begin
 canvas.font.color:=FontColorPair[cpStList,1]; {as in student list}
 x:=blankwidth div 3;
 if XML_STUDENTS.NumStud > 0 then
   printw(XML_STUDENTS.Stud[i].stname + ' ' + XML_STUDENTS.Stud[i].first);
 Inc(x,fwStname+blankwidth);
end;

procedure TListWin.ShowStudentHouse(i: integer);
var
 j,k: smallint;
begin
 if XML_STUDENTS.NumStud > 0 then
   if XML_DISPLAY.sTyear then
    begin
     printw(yearname[XML_STUDENTS.Stud[i].TcYear]);
     inc(x,fwyearname+blankwidth);
    end;
   if XML_DISPLAY.stSex then
    begin
     printw(XML_STUDENTS.Stud[i].Sex);
     inc(x,fwSex+blankwidth);
    end;
   if XML_DISPLAY.stID then
    begin
     printw(XML_STUDENTS.Stud[i].ID);
     inc(x,fwID+blankwidth);
    end;

   //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
   begin
    if XML_DISPLAY.stID2 then
    begin
     printw(studID2[i]);
     inc(x,fwID2+blankwidth);
    end;
    if XML_DISPLAY.stEmail then
    begin
     printw(studEmail[i]);
     inc(x,fwEmail+blankwidth);
    end;
   end;

   if XML_DISPLAY.stClass then
    begin
     printw(ClassCode[XML_STUDENTS.Stud[i].Tcclass]);
     inc(x,fwClass+blankwidth);
    end;
   if XML_DISPLAY.stHouse then
    begin
     printw(HouseName[XML_STUDENTS.Stud[i].house]);
     inc(x,fwHouse+blankwidth);
    end;
   if XML_DISPLAY.stTutor then
    begin
     printw(XML_TEACHERS.Tecode[XML_STUDENTS.Stud[i].tutor,0]);
     inc(x,fwcode[1]+blankwidth);
    end;
   if XML_DISPLAY.stHome then
    begin
     printw(XML_TEACHERS.Tecode[XML_STUDENTS.Stud[i].home,1]);
     inc(x,fwcode[2]+blankwidth);
    end;
   if XML_DISPLAY.stTag and (TagOrderNum>0) then
    begin
     for j:=1 to TagOrderNum do
      begin
       k:=TagOrder[j];
       if StudHasTag(i,k) then printw(TagCode[k]);
       inc(x,fwTag);
      end;
     inc(x,blankwidth);
    end;
end;

procedure TListWin.showStudentName(i: integer);
begin
  if XML_STUDENTS.NumStud > 0  then
  begin
    ShowStudentNameBrief(i);
    ShowStudentHouse(i);
  end;
end;

procedure TListWin.CalcTabStField;
begin
 TabStField:=0;
 if XML_DISPLAY.sTyear then inc(TabStField,(fwyearname+blankwidth));
 if XML_DISPLAY.sTsex then inc(TabStField,(fwSex+blankwidth));
 if XML_DISPLAY.sTclass then inc(TabStField,(fwclass+blankwidth));
 if XML_DISPLAY.sThouse then inc(TabStField,(fwhouse+blankwidth));
 if XML_DISPLAY.sTtutor then inc(TabStField,(fwcode[1]+blankwidth));
 if XML_DISPLAY.sThome then inc(TabStField,(fwcode[2]+blankwidth));
 if XML_DISPLAY.sTID then inc(TabStField,(fwID+blankwidth));

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  if XML_DISPLAY.sTID2 then inc(TabStField,(fwID2+blankwidth));
  if XML_DISPLAY.stEmail then inc(TabStField, (fwEmail+blankwidth));

 end;

 if XML_DISPLAY.sTtag and (TagOrderNum>0) then
   inc(TabStField,fwTag*TagOrderNum+blankwidth);
end;

procedure TListWin.BarcodeMake;
begin
 StBarCode1:=TStBarCode.Create(self);
 StBarCode1.BarCodeType:=bcCode128;
 StBarCode1.BarColor:=clBlack;
 StBarCode1.BarToSpaceRatio:=1;
 StBarCode1.BarWidth:=12;
 StBarCode1.BearerBars:=true;
 StBarCode1.Code128Subset:=csCodeB;
 StBarCode1.ShowGuardChars:=true;
 StBarCode1.TallGuardBars:=true;
 StBarCode1.Height:=68;
 StBarCode1.Width:=130;
 StBarCode1.ShowCode:=false;
end;

procedure TListWin.ShowIDbarcode(i:integer;SelFlag:boolean);
var
 ar:                   trect;
 IDlen:  smallint;
 mx,my:     integer;
begin
 if trim(XML_STUDENTS.Stud[i].ID)>'' then
  begin
   IDlen:=CalcIDlen;
   mx:=x; my:=y;
//   dec(y,txtheight div 2);
   inc(x,StBarCode1.width div 3);
   ar.top:=y; ar.bottom:=y+2*txtheight;
   ar.left:=x+Hmargin-Hscroll; ar.right:=ar.left+StBarCode1.width;
   StBarcode1.code:=RpadString(XML_STUDENTS.Stud[i].ID,idlen);
   if SelFlag then stbarcode1.color:=FontColorHiLitePair[codeColor,2]
    else stbarcode1.color:=FontColorPair[codeColor,2];
   StBarcode1.paintToCanvas(Canvas,ar);
   x:=mx; y:=my;
  end;
 newline;
 if XML_DISPLAY.double_space then
    newline;
end;



procedure TListWin.StudEnrolment(i:integer;SelFlag,DoDouble:boolean);
var
 j,su,skip: integer;
 te,ro: smallint;
begin
 skip:=0;
 newline; if DoDouble then newline;
 for j:=1 to chmax do
  begin
   su:=XML_STUDENTS.Stud[i].Choices[j];
   if trim(SubCode[su])>'' then
    begin
     if SelFlag then canvas.font.color:=FontColorHiLitePair[cpSub,1]
          else canvas.font.color:=FontColorPair[cpSub,1];
     x:=0; printw('    '+SubCode[su]+': ');
     x:=fwCode[0]+blankwidth*5; printw(Subname[su]);
     findteacher(i,j,te,ro);
     if trim(XML_TEACHERS.TeCode[te,0])>'' then
       begin
        canvas.font.color:=FontColorPair[cpTeach,1];
        x:=fwCode[0]+blankwidth*5+fwCodename[0];
        printw('    '+XML_TEACHERS.TeCode[te,0]+': ');
        x:=fwCode[0]+blankwidth*5+fwCodename[0]+fwCode[1]+blankwidth*3;
        printw(XML_TEACHERS.TeName[te,0]);
       end;
     newline; if DoDouble then newline;
    end
   else inc(skip);
  end; {for j}

 for j:=0 to skip do begin newline; if DoDouble then newline; end;
 fcolor(codecolor);
end;

//  TStudListWin procedures

procedure TStudListWin.AfterConstruction;
begin
 tabsDo:=true;
 SelCode:=0;
end;

procedure TStudListWin.BlockTitles(i:integer);
var
 j,mymax,offset,oldx,startx: integer;
 astr: string;
begin
 oldx:=x+blankwidth;
 startx:=fwStname+blankwidth+TabStField;
 if XML_DISPLAY.BlockShow and not(EnrolFlag) and (ListSize[i]>0) and (XML_DISPLAY.sTselect=1)
  and (startx>oldx) then
  begin
   mymax:=XML_DISPLAY.blocknum;
   if chmax<mymax then mymax:=chmax;
   for j:=1 to mymax do
    begin
     astr:='Blk'+inttostr(j);
     offset:=(fwCode[0]-canvas.textwidth(astr)) div 2;
     if offset<0 then offset:=0;
     x:=offset+startx+((j-1)*(fwCode[0]+blankwidth));
     printw(astr);
    end;
  end;
 newline;
 fcolor(codecolor);
end;

procedure TStudListWin.CalcItemPosition(pos,list:integer);
begin
 GetListContents(list);
 StudSelect:=ListContents[pos];
 x:=0; y:=ListTop[List]+ListHeadLines*TxtHeight*XML_DISPLAY.double_print+StudHeight*(pos-1)-Vscroll;
 newrect.left:=x+Hmargin-Hscroll;  newrect.right:=newrect.left+maxW;
 newrect.top:=y; newrect.bottom:=y+StudHeight;
end;

procedure TStudListWin.HighlightBox(newrect:Trect);
begin
 SelBox:=newrect;
 canvas.font.color:=FontColorHiLitePair[codeColor,1];
 canvas.brush.color:=FontColorHiLitePair[codeColor,2];
 canvas.fillrect(selbox);
end;

procedure TStudListWin.PaintItemFull(pos,list:integer;SelFlag:boolean);
var
 oldCol: integer;
begin
 oldCol:=CodeColor;
 CalcItemPosition(pos,list);
 if (y<(topCutoff-2*StudHeight)) or (y>bottomCutoff) then exit;
 if selFlag then HighlightBox(newrect);
 DisplayStudent(StudSelect,SelFlag);
 MySelStud:=StudSelect;
 CodeColor:=oldCol; fcolor(codeColor);
end;

procedure TStudListWin.RemoveSelection(pos,list: integer);
begin
 CalcItemPosition(pos,list);
 canvas.fillrect(newrect);
 PaintItemFull(pos,list,false);
end;

procedure TStudListWin.RedoSelection;
var
 i,j: integer;
begin
 if (ListType<>1) or (selcode<1) then
  begin
   selcode:=0;
   exit;
  end;
 selcode:=0; ListSelect:=0;
 for i:=1 to NumOfLists do
  begin
   if ListSize[i]>0 then
    begin
     GetListContents(i);
     for j:=1 to ListSize[i] do
      if ListContents[j]=StudSelect then begin selcode:=j; ListSelect:=i; break; end;
    end;
   if selcode>0 then break;
  end;
end;

procedure TStudListWin.ShowStudTt;
begin
 if selcode>0 then
 begin
  XML_DISPLAY.StudTtListType:=1; {selection}
  winView[wnStudentTt]:=1; {weekly}
  XML_DISPLAY.studentttselection[0]:=1;
  XML_DISPLAY.studentttselection[1]:=StudSelect;
  XML_DISPLAY.stuttlistvals[3]:=0; {class;}
  XML_DISPLAY.stuttlistvals[4]:=0; {tmphouse;}
  XML_DISPLAY.stuttlistvals[5]:=0; {tmptutor;}
  XML_DISPLAY.stuttlistvals[6]:=0; {room;}
  studentTtablewinSelect;
  UpdateWindow(wnStudentTt);
 end;
end;

procedure TStudListWin.MouseDown(Button: TMouseButton;Shift: TShiftState; X1, Y1: Integer);
var
 yy,i:  integer;
 newselcode,NewListSelect: integer;
begin
 if listtype<>1 then exit; {selection only for student lists}
 if doubleclick then
   begin
    doubleclick:=false;
    exit;
   end;
 yy:=y1+Vscroll;
 newListSelect:=0;
 for i:=1 to NumOfLists do
  if yy>ListTop[i] then newListSelect:=i;
 if newListSelect=0 then exit;
 yy:=yy-ListTop[newListSelect]-ListHeadLines*TxtHeight*XML_DISPLAY.double_print;
 if StudHeight > 0 then
   newselcode := 1 + (yy div StudHeight)
 else
   newselcode := 1;

 if (newselcode<1) or (newselcode>ListSize[newListSelect]) then exit;
 if (newselcode<>selcode) or (NewListSelect<>ListSelect) then
  begin
   if selCode>0 then RemoveSelection(selcode,ListSelect);
   selCode:=newselcode;
   ListSelect:=NewListSelect;
   PaintItemFull(selcode,ListSelect,true);
  end;
end;



procedure TStudListWin.DisplayStudent(i:integer;SelFlag:boolean);
var
 j,su:       integer;
 tab: integer;
 myRect: Trect;
begin
 x:=0;
 if y>bottomCutoff then exit; {no printing past range}
 ShowStudentName(i); tab:=x;
 if EnrolFlag then
  begin
   if XML_DISPLAY.EnrolBarcodeFlg then ShowIDbarcode(i,SelFlag);
   StudEnrolment(i,SelFlag,XML_DISPLAY.double_space);
   exit;
  end;
 case XML_DISPLAY.sTselect of
   1: begin    {other subs}
       for j:=1 to chmax do
        begin
         if SelFlag then canvas.font.color:=FontColorHiLitePair[cpSub,1]
          else canvas.font.color:=FontColorPair[cpSub,1];
         x:=tab+((j-1)*(fwCode[0]+blankwidth));
         su:=XML_STUDENTS.Stud[i].Choices[j];
         if (XML_DISPLAY.blockshow and (j<=XML_DISPLAY.blocknum) and (SelFlag=false)) then  {highlight blocks}
          begin
           MyRect.Left:=x+Hmargin-Hscroll-(blankwidth div 3);  MyRect.Right:=MyRect.Left+fwcode[0];
           MyRect.Top:=y;  MyRect.Bottom:=y+txtheight*XML_DISPLAY.Double_Print;
           canvas.brush.Color:=clMoneyGreen;
           canvas.FillRect(MyRect);
          end;
         if XML_DISPLAY.listShowClashes then if CheckStudChoiceForClash(i,su) then
          begin {highlight clashes}
           canvas.font.style:=canvas.font.style+[fsUnderline];
            if SelFlag then canvas.font.color:=clBlue else canvas.font.color:=clRed;
          end;
         if (su>0) then printw(trim(SubCode[su]))
           else printw(copy('-------------',1,lencodes[0])); {print underscores for blank}
         if XML_DISPLAY.listShowClashes then canvas.font.style:=canvas.font.style-[fsUnderline];
        end; {for j}
       fcolor(codecolor);
      end;
   2: begin  {boxes}
       canvas.moveto(x,y);
       canvas.lineto(x,y);
       x:=tab+Hmargin-Hscroll;;
       canvas.moveto(x,y+boxGap*2);
       canvas.lineto(x,y+txtheight);
       for j:=1 to nmbrBoxes do
        begin
         x:=tab+((j-1)*(boxWidth))+Hmargin-Hscroll;;
         canvas.moveto(x,y+txtheight-1);
         canvas.lineto(x+boxWidth,y+txtheight-1);
         canvas.lineto(x+boxWidth,y+boxGap);
        end; {for j}
      end;
   3: begin {lines}
       x:=tab+Hmargin-Hscroll;
       canvas.moveto(x,y+txtheight-1);
       canvas.lineto(x+boxWidth*nmbrBoxes,y+txtheight-1);
      end;
 end; {case}
 newline; if XML_DISPLAY.double_space then newline;
end;

procedure TStudListWin.ListFooter(i:integer);
begin
 printw('Number of Students: '+inttostr(ListSize[i]));
 newline; newline;
 if XML_DISPLAY.double_space then begin newline;newline; end;
end;

procedure TStudListWin.ShowLists;
var
 i,j,k: integer;
 selFlag: boolean;
begin
 fcolor(cpNormal);
 if XML_DISPLAY.sTtag and TagCalcFlag and (TagOrderNum>0) then
   fwTag:=getTagFontWidths(mainform.canvas);
 painthead;
 newline;
 if (NumOfLists=0) or ((TotalCount=0) and not(ShowZeroList)) then
   begin
    printw('No student lists selected.');
    exit;
   end;
 for i:=1 to NumOfLists do
  if (ListSize[i]>0) or ShowZeroList then
   begin
    if (i<NumofLists) then
     if ((ListTop[i+1]-Vscroll)<-StudHeight) then
      begin
       y:=ListTop[i+1]-Vscroll;
       continue;
      end;
    GetListContents(i);
    fcolor(cpNormal); ListHead(i);BlockTitles(i);
    if XML_DISPLAY.double_space then newline;
    for j:=1 to ListSize[i] do
     begin
      k:=ListContents[j];
      if (y<-(2*StudHeight)) then
        begin
         inc(y,StudHeight);
         continue;
        end;
      fcolor(codecolor);
      selflag:=(ListSelect=i) and (SelCode=j);
      if selFlag then PaintItemFull(j,i,SelFlag) else
      DisplayStudent(k,selflag);
      if y>bottomCutoff then exit; {no printing past range}
     end;
    fcolor(cpNormal);
    ListFooter(i);
   end;
end;



procedure TStudListWin.paint;
begin
 inherited;
 if listtype=1 then showlists;
end;

procedure TStudListWin.CalcArrayTops;
var
 i,zerolists: integer;
begin
 TotalCount:=0;
 zerolists:=0;
 StudLines:=1;
 if EnrolFlag then
  begin
   StudLines:=2+chmax;
   if XML_DISPLAY.EnrolBarcodeFlg then inc(StudLines);
  end;
 StudHeight:=TxtHeight*StudLines*XML_DISPLAY.double_print;
 if NumOfLists>0 then
  begin
   for i:=1 to NumOfLists do
     if (ListSize[i]=0) and not(ShowZeroList) then inc(zerolists);
   for i:=1 to NumOfLists do inc(TotalCount,ListSize[i]);
  end;
 if listtype=1 then
  begin  {student list}
   if NumOfLists>0 then ListTop[1]:=3*txtHeight;
   if NumofLists>1 then
    for i:=2 to NumofLists do
     if (ListSize[i-1]>0) or ShowZeroList then
       ListTop[i]:=ListTop[i-1]+XML_DISPLAY.double_print*txtHeight*(ListHeadLines+2+StudLines*ListSize[i-1])
      else ListTop[i]:=ListTop[i-1];
   CalcTabStField;
   maxW:=fwStName+blankwidth+TabStField;
   if EnrolFlag and XML_DISPLAY.EnrolBarcodeFlg then inc(maxW,StBarCode1.width);
   case XML_DISPLAY.sTselect of
    1: inc(maxW,(fwCode[0]+blankwidth)*chmax);
    2,3: inc(maxW,(nmbrBoxes+2)*boxwidth);
   end; {case}
   maxH:=4*TxtHeight+XML_DISPLAY.double_print*TxtHeight*((ListHeadLines+2)*(NumOfLists-zerolists)+TotalCount*StudLines);
  end;
end;

// TListTtWin procedures

Function TListTtWin.DayListSize(i:integer):integer;
begin
 result:=0; if ListSize[i]>0 then
  result:=(day2-day1+1)*(6+(4*txtHeight)+ListSize[i]*(txtHeight*2+6));
end;


procedure TListTtWin.CalcArrayTops;
var
 i,mydays,tsNameNum: integer;
begin
 TotalCount:=0; tsNameNum:=1;
 SetPshowMax;
 for i:=1 to days-1 do
  if DayGroup[i]<>DayGroup[i-1] then inc(tsNameNum);
 WeeklyHeight:=yFooter+4*txtHeight+ (txtheight div 2)+6+
        (tsShowMax*(txtHeight*2+9));
 for i:=1 to NumOfLists do inc(TotalCount,ListSize[i]);
 if listtype=1 then
 begin  {daily}
   mydays:=day2-day1+1;
   maxH:=txtHeight+mydays*(((6+(4*txtHeight))*NumOfLists)+(TotalCount*(txtHeight*2+6)));
   maxW:=Hmargin*2+tab1+(dx+3)*periods;
   ListTop[1]:=txtHeight;
   if NumofLists>1 then
    for i:=2 to NumofLists do ListTop[i]:=ListTop[i-1]+DayListSize(i-1);
 end
 else  {weekly}
  begin
   tab1:=fwPeriodname+blankwidth;
   if XML_DISPLAY.ttClockShowFlg then
    if tab1<fwClockStartEnd then tab1:=fwClockStartEnd;
   maxH:=((2+NumOfLists)*txtHeight)+TotalCount*WeeklyHeight;
   maxW:=Hmargin*2+(tab1*tsNameNum)+(dx+3)*days;
   if FooterWidth>maxW then maxW:=FooterWidth;
  end;
end;


procedure TListTtWin.paint;
begin
 inherited;
 fcolor(cpNormal); {main headings etc -black}
 if TotalCount=0 then
   begin
    printw('No timetables selected.');
    exit;
   end;
 if listtype=1 then DailyTt else WeeklyTt;
end;

procedure TListTtWin.WeeklyTt;
var
 i,j,k:    integer;
begin
 for i:=1 to NumOfLists do
  if ListSize[i]>0 then
   begin
    GetListContents(i);
    fcolor(cpNormal);  ListHead(i,0);
    for j:=1 to ListSize[i] do
     begin
      k:=ListContents[j];
      if (y+WeeklyHeight)<(-2*TxtHeight) then
       begin
        inc(y,WeeklyHeight);
        continue;
       end;
      newline;
      fcolor(codecolor); ShowName(k);
      newline;
      ShowWeekly(k);
      WeeklyFooter(k);
      inc(y,6);
      if y>bottomCutoff then exit; {no printing past range}
     end;
   end;
end;



procedure TListTtWin.DailyTt;
var
 i,j,k,p,Ip,dI,dailyHeight:    integer;
begin
 dailyHeight:=txtHeight*2+6;
 for i:=1 to NumOfLists do
  if ListSize[i]>0 then
   begin
    if (i<NumofLists) then
     if ((ListTop[i+1]-Vscroll)<-dailyHeight) then
      begin
       y:=ListTop[i+1]-Vscroll;
       continue;
      end;
    for dI:=day1 to day2 do
     begin
      GetListContents(i);
      fcolor(cpNormal); ListHead(i,dI);
       for p:=1 to tsShowMax do   {period header}
         begin
          Ip:=tsShow[dI,p];
          if (Ip=0) and (p>1) then break;
          x:=tab1+dx*(p-1)+((dx-Canvas.textwidth(TimeSlotName[dI,Ip])) div 2); {centre period name}
          printw(TimeSlotName[dI,Ip]);
         end;
         inc(y,6);
      for j:=1 to ListSize[i] do
       begin
        k:=ListContents[j];
        if (y<-(2*dailyHeight)) then
          begin
           inc(y,dailyHeight);
           continue;
          end;
        newline;
        fcolor(codecolor); ShowName(k);
        ShowDaily(k,dI);
        inc(y,6);
        if y>bottomCutoff then exit; {no printing past range}
       end;
      newline; fcolor(cpNormal);
      WeeklyFooter(i);
      newline;     newline;
     end;
   end;
end;

procedure TListTtWin.ShowWeekly(studnum: integer);
var
 dI,dI2,Ip,p:      integer;
 y1t,y2t:                 integer;
 firstOne:                   bool;
 dayStart: array[0..nmbrdays] of integer;
begin
 if y>bottomCutoff then exit; {no printing past range}
 firstOne:=true;
 fcolor(cpNormal);
 dayStart[0]:=Hmargin;

 if (SelDays=0) or (tsShowMax=0) then printw(NoWeekSelect);

 if SelDays>0 then
  for dI:=1 to SelDays do
   begin
    dayStart[dI]:=dayStart[dI-1]+dx;
    if ShowTnames[dI-1] then inc(dayStart[dI],tab1);
   end;

 if (SelDays>0) and (tsShowMax>0) then  {print headings if some content}
  for dI:=0 to SelDays-1 do
   begin
    dI2:=Xday[dI];
    x:=dayStart[dI]; if ShowTnames[dI] then inc(x,tab1);
    x:=x+((dx-canvas.textwidth(dayname[dI2])) div 2); {centre dayname}
    printw(dayname[dI2]);
   end; {for dI}
 newline;
 newline;  inc(y,txtheight div 2);

 if tsShowMax>0 then
  for Ip:=1 to tsShowMax do
   begin
    y2t:=y+txtHeight+3;  y1t:=y-txtHeight-6;
    dec(y,txtheight);
    if SelDays>0 then
     for dI:=0 to SelDays-1 do
      begin
       dI2:=Xday[dI];
       p:=tsShow[dI2,Ip];
       if (p=0) and (Ip>1) then continue;
       if ShowTnames[dI] then
        begin
         x:=dayStart[dI]+blankwidth div 3;
         fcolor(cpNormal);
         printw(TimeSlotName[dI2,p]);
         if XML_DISPLAY.ttClockShowFlg then
          begin
           inc(y,txtHeight);
           printw(StartEndTime(dI2,p));
           dec(y,txtheight);
          end;
        end;
       x:=dayStart[dI]; if ShowTnames[dI] then inc(x,tab1);
       ShowTtItems(studnum,dI2,p,x);
      end; {for dI}
    inc(y,txtheight*3);
    x:=hmargin;
    if firstOne then
     begin
      firstOne:=false;
      drawMyLine(x-3,y1t,dayStart[SelDays]-3,y1t);
     end;
    drawMyLine(x-3,y2t,dayStart[SelDays]-3,y2t);
    if SelDays>0 then
     for dI:=0 to SelDays do
      begin
       drawMyLine(dayStart[dI]-3,y1t,dayStart[dI]-3,y2t);
       if dI<SelDays then if ShowTnames[dI] then
        drawMyLine(dayStart[dI]+tab1-3,y1t,dayStart[dI]+tab1-3,y2t);
      end;  {for dI}
    inc(y,9);
   end; {for Ip}
end;

procedure TListTtWin.ShowDaily(studnum,dI: integer);
var
 Ip,k:      integer;
 y1t,y2t:                 integer;
begin
 if y>bottomCutoff then exit; {no printing past range}
 for k:=1 to tsShowMaxDay[dI] do
 begin
  Ip:=tsShow[dI,k];
  if (Ip=0) and (k>1) then break;
  ShowTtItems(studnum,dI,Ip,tab1+dx*(k-1));
 end; {for k}
 newline;
 y1t:=y-txtheight-3; y2t:=y+txtheight+3; x:=0;
 drawMyLine(x-3,y2t,x+tab1+dx*tsShowMaxDay[dI]-3,y2t);
 drawMyLine(x-3,y1t,x+tab1+dx*tsShowMaxDay[dI]-3,y1t);
 drawMyLine(x-3,y1t,x-3,y2t);
 for Ip:=0 to tsShowMaxDay[dI] do
  drawMyLine(x+tab1+dx*Ip-3,y1t,x+tab1+dx*Ip-3,y2t);
end;


//TPrintListWin  procedures

procedure TPrintListWin.SetArraySizes;
begin
 SetLength(ListSize,NumOfLists+1);
 SetLength(ListSet,NumOfLists+1);
end;

procedure TPrintListWin.ShowStudentNameBrief(i: integer);
begin
 fcolor(cpStList); {as in student list}
 x:=PrntBlankwidth div 3;
 printw(XML_STUDENTS.Stud[i].stname+' '+XML_STUDENTS.Stud[i].first);
 inc(x,fwPrntStname+PrntBlankwidth);
end;

procedure TPrintListWin.ShowStudentHouse(i: integer);
var
 j,k: smallint;
begin
 if XML_DISPLAY.sTyear then
  begin
   printw(yearname[XML_STUDENTS.Stud[i].TcYear]);
   inc(x,fwPrntyearname+PrntBlankwidth);
  end;
 if XML_DISPLAY.stSex then
  begin
   printw(XML_STUDENTS.Stud[i].Sex);
   inc(x,fwPrntSex+PrntBlankwidth);
  end;
 if XML_DISPLAY.stID then
  begin
   printw(XML_STUDENTS.Stud[i].ID);
   inc(x,fwPrntID+PrntBlankwidth);
  end;

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  if XML_DISPLAY.stID2 then
  begin
   printw(studID2[i]);
   inc(x,fwPrntID2+PrntBlankwidth);
  end;
  if XML_DISPLAY.stEmail then
  begin
   printw(studEmail[i]);
   inc(x,fwPrntEmail+PrntBlankwidth);
  end;
 end;

 if XML_DISPLAY.sTclass then
  begin
   printw(ClassCode[XML_STUDENTS.Stud[i].Tcclass]);
   inc(x,fwPrntClass+PrntBlankwidth);
  end;
 if XML_DISPLAY.stHouse then
  begin
   printw(HouseName[XML_STUDENTS.Stud[i].house]);
   inc(x,fwPrntHouse+PrntBlankwidth);
  end;
 if XML_DISPLAY.stTutor then
  begin
   printw(XML_TEACHERS.Tecode[XML_STUDENTS.Stud[i].tutor,0]);
   inc(x,fwPrntcode[1]+PrntBlankwidth);
  end;
 if XML_DISPLAY.stHome then
  begin
   printw(XML_TEACHERS.Tecode[XML_STUDENTS.Stud[i].home,1]);
   inc(x,fwPrntcode[2]+PrntBlankwidth);
  end;
 if XML_DISPLAY.stTag and (TagOrderNum>0) then
  begin
   for j:=1 to TagOrderNum do
    begin
     k:=TagOrder[j];
     if StudHasTag(i,k) then printw(TagCode[k]);
     inc(x,fwPrntTag);
    end;
   inc(x,PrntBlankwidth);
  end;
end;

procedure TPrintListWin.showStudentName(i: integer);
begin
 ShowStudentNameBrief(i);
 ShowStudentHouse(i);
end;

procedure TPrintListWin.CalcTabStField;
begin
 TabStField:=0;
 if XML_DISPLAY.sTyear then inc(TabStField,(fwPrntyearname+PrntBlankwidth));
 if XML_DISPLAY.sTsex then inc(TabStField,(fwPrntSex+PrntBlankwidth));
 if XML_DISPLAY.sTclass then inc(TabStField,(fwPrntclass+PrntBlankwidth));
 if XML_DISPLAY.sThouse then inc(TabStField,(fwPrnthouse+PrntBlankwidth));
 if XML_DISPLAY.sTtutor then inc(TabStField,(fwPrntcode[1]+PrntBlankwidth));
 if XML_DISPLAY.sThome then inc(TabStField,(fwPrntcode[2]+PrntBlankwidth));
 if XML_DISPLAY.sTID then inc(TabStField,(fwPrntID+PrntBlankwidth));
 if XML_DISPLAY.sTtag and (TagOrderNum>0) then
     inc(TabStField,fwPrntTag*TagOrderNum+PrntBlankwidth);
end;

procedure TPrintListWin.StudEnrolment(i:integer;DoDouble:boolean);
var
 j,su,skip: integer;
 te,ro: smallint;
begin
 skip:=0;
 newline; if DoDouble then newline;
 for j:=1 to chmax do
  begin
   su:=XML_STUDENTS.Stud[i].Choices[j];
   if trim(SubCode[su])>'' then
    begin
     fcolor(cpSub);
     x:=0; printw('    '+SubCode[su]+': ');
     x:=fwPrntCode[0]+PrntBlankwidth*5; printw(Subname[su]);
     findteacher(i,j,te,ro);
     if trim(XML_TEACHERS.TeCode[te,0])>'' then
       begin
        fcolor(cpTeach);
        x:=fwPrntCode[0]+PrntBlankwidth*5+fwPrntCodename[0];
        printw('    '+XML_TEACHERS.TeCode[te,0]+': ');
        x:=fwPrntCode[0]+PrntBlankwidth*5+fwPrntCodename[0]+fwPrntCode[1]+PrntBlankwidth*3;
        printw(XML_TEACHERS.TeName[te,0]);
       end;
     newline; if DoDouble then newline;
    end
   else inc(skip);

  end; {for j}
 for j:=0 to skip do begin newline; if DoDouble then newline; end;
 fcolor(codecolor);
end;

procedure TPrintListWin.BarcodeMake;
var
 ratio: integer;
begin
 ratio:=PrntTxtHeight div TxtHeight;
 if ratio<1 then ratio:=1;
 StBarCode1:=TStBarCode.Create(application);
 StBarCode1.BarCodeType:=bcCode128;
 StBarCode1.BarColor:=clBlack;
 StBarCode1.BarToSpaceRatio:=1;
 if PrinterOn then StBarCode1.BarWidth:=12
   else if PreviewOn then StBarCode1.BarWidth:=12*ratio;
 StBarCode1.BearerBars:=true;
 StBarCode1.Code128Subset:=csCodeB;
 StBarCode1.ShowGuardChars:=true;
 StBarCode1.TallGuardBars:=true;
 StBarCode1.Height:=68;
 StBarCode1.Width:=130*ratio;
 StBarCode1.ShowCode:=false;
end;

procedure TPrintListWin.PrintIDbarcode(i:integer);
var
 ar:                   trect;
 IDlen:  smallint;
 mx,my:     integer;
begin
 if trim(XML_STUDENTS.Stud[i].ID)>'' then
  begin
   IDlen:=CalcIDlen;
   mx:=x; my:=y;
   dec(y,PrntTxtheight div 2);
   inc(x,StBarCode1.width div 4);
   ar.top:=y; ar.bottom:=y+2*PrntTxtheight;
   ar.left:=x+prntHmargin; ar.right:=ar.left+StBarCode1.width;
   StBarcode1.code:=RpadString(XML_STUDENTS.Stud[i].ID,idlen);
   StBarcode1.paintToCanvas(PrintCanvas,ar);
   x:=mx; y:=my;
  end;
 newline; if XML_DISPLAY.double_space then newline;
end;



// TOutListWin procedures

procedure TOutListWin.StudEnrolment(i:integer;DoDouble:boolean);
var
 j,su,skip: integer;
 te,ro: smallint;
 astr: string;
begin
 skip:=0;
 astr:=EndLineOut; if DoDouble then astr:=astr+EndLineOut;
 for j:=1 to chmax do
  begin
   su:=XML_STUDENTS.Stud[i].Choices[j];
   if trim(SubCode[su])>'' then
    begin
     astr:=astr+delim2+SubCode[su]+delim2+Addc(Subname[su]);
     findteacher(i,j,te,ro);
     if trim(XML_TEACHERS.TeCode[te,0])>'' then
       begin
        astr:=astr+Addc(XML_TEACHERS.TeCode[te,0])+Addc(XML_TEACHERS.TeName[te,0]);
       end;
     astr:=astr+EndLineOut; if DoDouble then astr:=astr+EndLineOut;;
    end
   else inc(skip);
  end; {for j}
 for j:=0 to skip do
  begin astr:=astr+EndLineOut; if DoDouble then astr:=astr+EndLineOut; end;
 OutStream.Write(Pchar(astr)^,length(astr));
end;

procedure TOutListWin.SetArraySizes;
begin
 SetLength(ListSize,NumOfLists+1);
 SetLength(ListSet,NumOfLists+1);
end;


procedure TOutListWin.CalcTabCount;
begin
 TabCount:=1;
 if XML_DISPLAY.sTyear then inc(TabCount);
 if XML_DISPLAY.stSex then inc(TabCount);
 if XML_DISPLAY.stID then inc(TabCount);
 if XML_DISPLAY.stClass then inc(TabCount);
 if XML_DISPLAY.stHouse then inc(TabCount);
 if XML_DISPLAY.stTutor then inc(TabCount);
 if XML_DISPLAY.stHome then inc(TabCount);
 if XML_DISPLAY.sTtag then inc(TabCount);
end;

procedure TOutListWin.showStudentName(i: integer);
var
 astr,bstr: string;
 j,k: smallint;
begin
 bstr:='';
 astr:=delim2+XML_STUDENTS.Stud[i].stname+delim2+Addc(XML_STUDENTS.Stud[i].first);
 if XML_DISPLAY.sTyear then astr:=astr+Addc(yearname[XML_STUDENTS.Stud[i].TcYear]);
 if XML_DISPLAY.stSex then astr:=astr+Addc(XML_STUDENTS.Stud[i].Sex);
 if XML_DISPLAY.stID then astr:=astr+Addc(XML_STUDENTS.Stud[i].ID);

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  if XML_DISPLAY.stID2 then astr:=astr+Addc(studID2[i]);
  if XML_DISPLAY.stEmail then astr:=astr+Addc(studEmail[i]);
 end;

 if XML_DISPLAY.stClass then astr:=astr+Addc(ClassCode[XML_STUDENTS.Stud[i].Tcclass]);
 if XML_DISPLAY.stHouse then astr:=astr+Addc(HouseName[XML_STUDENTS.Stud[i].house]);
 if XML_DISPLAY.stTutor then astr:=astr+Addc(XML_TEACHERS.Tecode[XML_STUDENTS.Stud[i].tutor,0]);
 if XML_DISPLAY.stHome then astr:=astr+Addc(XML_TEACHERS.Tecode[XML_STUDENTS.Stud[i].home,1]);
 if XML_DISPLAY.stTag and (TagOrderNum>0) then
  begin
   for j:=1 to TagOrderNum do
    begin
     k:=TagOrder[j];
     if StudHasTag(i,k) then bstr:=bstr+TagCode[k]+' ';
    end;
   astr:=astr+Addc(bstr);
  end;
 OutStream.Write(Pchar(astr)^,length(astr));
end;

procedure TOutListWin.CalcTotalCount;
var
 i: integer;
begin
 TotalCount:=0;
 for i:=1 to NumOfLists do inc(TotalCount,ListSize[i]);
end;

// TPrintStudListWin procedures



procedure TPrintStudListWin.CalcHeights;
var
 i: integer;
begin
 TotalCount:=0;
 for i:=1 to NumOfLists do inc(TotalCount,ListSize[i]);
 StudLines:=1;
 if EnrolFlag then StudLines:=2+chmax;
 StudHeight:=PrntTxtHeight*StudLines*XML_DISPLAY.double_print;
 CalcTabStField;
end;



procedure TPrintStudListWin.BlockTitles(i:integer);
var
 j,mymax,offset,oldx,startx: integer;
 astr: string;
begin
 oldx:=x+PrntBlankwidth;
 startx:=fwPrntStname+Prntblankwidth+TabStField;
 if XML_DISPLAY.BlockShow and not(EnrolFlag) and (ListSize[i]>0) and (XML_DISPLAY.sTselect=1)
  and (startx>oldx) then
  begin
   mymax:=XML_DISPLAY.blocknum; if chmax<mymax then mymax:=chmax;
   for j:=1 to mymax do
    begin
     astr:='Blk'+inttostr(j);
     offset:=(fwPrntCode[0]-PrintCanvas.textwidth(astr)) div 2;
     if offset<0 then offset:=0;
     x:=offset+startx+((j-1)*(fwPrntCode[0]+Prntblankwidth));
     printw(astr);
    end;
  end;
 newline;
 fcolor(codecolor);
end;


procedure TPrintStudListWin.DisplayStudent(i:integer);
var
 j,su:       integer;
 tab: integer;
 MyRect: Trect;
begin
 x:=0;
 ShowStudentName(i); tab:=x;
 if EnrolFlag then
  begin
   if XML_DISPLAY.EnrolBarcodeFlg then PrintIDbarcode(i);
   StudEnrolment(i,XML_DISPLAY.double_space); exit;
  end;
 case XML_DISPLAY.sTselect of
   1: begin    {other subs}
       for j:=1 to chmax do
        begin
         fcolor(cpSub);
         x:=tab+((j-1)*(fwPrntCode[0]+PrntBlankwidth));
         su:=XML_STUDENTS.Stud[i].Choices[j];
         if XML_DISPLAY.listShowClashes then if CheckStudChoiceForClash(i,su) then
          begin
           PrintCanvas.font.style:=PrintCanvas.font.style+[fsUnderline];
           fcolor(cpDouble);
          end;
         if (XML_DISPLAY.blockshow and (j<=XML_DISPLAY.blocknum) and XML_DISPLAY.colorPrinterFlag) then  {highlight blocks}
          begin
           MyRect.Left:=x+prntHmargin-(Prntblankwidth div 3);  MyRect.Right:=MyRect.Left+fwPrntcode[0];
           MyRect.Top:=y;  MyRect.Bottom:=y+Prnttxtheight*XML_DISPLAY.Double_Print;
           PrintCanvas.brush.Color:=clMoneyGreen;
           PrintCanvas.FillRect(MyRect);
          end;
         if (su>0) then printw(trim(SubCode[su]))
           else printw(copy('-------------',1,lencodes[0])); {print underscores for blank}
         if XML_DISPLAY.listShowClashes then PrintCanvas.font.style:=PrintCanvas.font.style-[fsUnderline];
        end; {for j}
       fcolor(codecolor);
      end;
   2: begin  {boxes}
       x:=tab+prntHmargin;
       PrintCanvas.moveto(x,y+boxGap*2);
       PrintCanvas.lineto(x,y);
       PrintCanvas.lineto(x,y+prntTxtHeight);
       for j:=1 to nmbrBoxes do
        begin
         x:=tab+((j-1)*(prntboxwidth))+prntHmargin;;
         PrintCanvas.moveto(x,y+prntTxtHeight);
         PrintCanvas.lineto(x+prntboxwidth,y+prntTxtHeight);
         PrintCanvas.lineto(x+prntboxwidth,y+boxGap);
        end; {for j}
      end;
   3: begin {lines}
       x:=tab+prntHmargin;
       PrintCanvas.moveto(x,y+prntTxtHeight);
       PrintCanvas.lineto(x+prntboxwidth*nmbrBoxes,y+prntTxtHeight);
      end;
 end; {case}
 newline; if XML_DISPLAY.double_space then newline;
end;

procedure TPrintStudListWin.ListFooter(i:integer);
begin
 printw('Number of Students: '+inttostr(ListSize[i]));
 newline; newline;
 if XML_DISPLAY.double_space then begin newline;newline; end;
end;

procedure TPrintStudListWin.ShowLists;
var
 i,j,k: integer;

  procedure checkNewPage;
  begin
   if XML_DISPLAY.Formfeed then
     begin
      printCustomAddon;
      if not(lastone) then  begin StartNewPage; header; newline; end;
     end
    else {not formfeed}
     if EnrolFlag and (y+StudHeight>(PrintPageHeight-2*prntTxtHeight)) and
      ((PrintPageHeight div 2)>StudHeight) and not(lastone) then
       begin StartNewPage; header; newline; end;  {prevent part on enrol on end of page}
  end;


begin
 fcolor(cpNormal);
 header;
 newline;
 lastone:=false;
 if (NumOfLists=0) or ((TotalCount=0) and not(ShowZeroList)) then
  begin
   printw('No students selected.');
   exit;
  end;
 for i:=1 to NumOfLists do
  begin
    if (ListSize[i]>0) or ShowZeroList then
     begin
      GetListContents(i);
      fcolor(cpNormal); ListHead(i); BlockTitles(i);
      if XML_DISPLAY.double_space then newline;
      for j:=1 to ListSize[i] do
       begin
        if ((j=ListSize[i]) or (not(EnrolFlag))) and (i=NumOfLists) then lastOne:=true;
        k:=ListContents[j];
        fcolor(codecolor);
        DisplayStudent(k);
        if EnrolFlag then CheckNewPage;
       end;
      fcolor(cpNormal);
      if not(enrolflag and XML_DISPLAY.formfeed) then ListFooter(i);
      if not(enrolflag) then CheckNewPage;
     end;
  end;
 if not(XML_DISPLAY.formfeed) then printCustomAddon;
end;

// TOutStudListWin



procedure TOutStudListWin.DisplayStudent(i:integer);
var
 j,su:       integer;
 astr,bstr:       string;
begin
 ShowStudentName(i);
 if EnrolFlag then begin StudEnrolment(i,XML_DISPLAY.double_space); exit; end;
 astr:='';
 case XML_DISPLAY.sTselect of
   1: begin    {other subs}
       for j:=1 to XML_DISPLAY.FAsubnum do
        begin
         su:=XML_STUDENTS.Stud[i].Choices[j];
         if (su>0) then bstr:=trim(SubCode[su]) else bstr:=''; {print blank}
         astr:=astr+Addc(bstr);
        end; {for j}
      end;
   2: begin  {boxes}
       for j:=1 to nmbrBoxes do astr:=astr+Addc('_|');
      end;
   3: begin {lines}
       astr:=astr+Addc('___________________________________');
      end;
 end; {case}
 if astr>'' then OutStream.Write(Pchar(astr)^,length(astr));
 newline; if XML_DISPLAY.double_space then newline;
end;


procedure TOutStudListWin.ExportToSpecialTextFile;
var
  i, j, k: Integer;
begin
  for i:=1 to NumOfLists do
  begin
    if (ListSize[i]>0) or ShowZeroList then
     begin
      GetListContents(i);
      ListHead(i);
      if XML_DISPLAY.double_space then newline;
      for j:=1 to ListSize[i] do
       begin
        if ((j=ListSize[i]) or (not(EnrolFlag))) and (i=NumOfLists) then lastOne:=true;
        k:=ListContents[j];
        DisplayStudent(k);
       end;
     end;
  end;
end;

procedure TOutStudListWin.ListFooter(i:integer);
begin
 printLine(['Number of Students: ',inttostr(ListSize[i])]);
 newline; newline;
 if XML_DISPLAY.double_space then begin newline;newline; end;
end;

procedure TOutStudListWin.ShowLists(const pIsSpecial: Boolean = False);
var
 i,j,k: integer;

  procedure checkNewPage;
  begin
   if XML_DISPLAY.Formfeed then printCustomAddon;
  end;

  procedure CreateSpecialTextFile;
  var
    lChoiceNo: Integer;
    lList: TStringList;
    i: Integer;
    j:Integer;
    l:Integer;
    lFileName: string;
  begin
    lList := TStringList.Create;
    try
      lList.Add('student_number' + Chr(9) + 'class_code');

      for i := 1 to NumOfLists do
      begin
        if (ListSize[i] > 0) or ShowZeroList then
        begin
          GetListContents(i);
          for j := 1 to ListSize[i] do
          begin
            k := ListContents[j];
            for l := 1 to nmbrchoices do
            begin
              lChoiceNo := XML_STUDENTS.Stud[k].Choices[l];
              if (lChoiceNo > 0) and (XML_STUDENTS.Stud[k].ID <> '') then
                lList.Add(XML_STUDENTS.Stud[k].ID + Chr(9) + Trim(SubCode[lChoiceNo]));
            end; {for j}
          end;
        end;
      end; // for
      lFileName := Directories.DataDir + '\StudentClassSpecial.TXT';
      lList.SaveToFile(lFileName);
      MessageDlg('The new file has been create as ' + lFileName, mtInformation, [mbOK], 0);
    finally
      FreeAndNil(lList);
    end;
  end;

begin
  if pIsSpecial then
  begin
    CreateSpecialTextFile;
  end
  else
  begin
    header;
    newline;
    lastone:=false;
    if (NumOfLists=0) or ((TotalCount=0) and not(ShowZeroList)) then
    begin
     printLine(['No student lists selected.']);
     exit;
    end;
    for i:=1 to NumOfLists do
    begin
      if (ListSize[i]>0) or ShowZeroList then
       begin
        GetListContents(i);
        ListHead(i);if XML_DISPLAY.double_space then newline;
        for j:=1 to ListSize[i] do
         begin
          if ((j=ListSize[i]) or (not(EnrolFlag))) and (i=NumOfLists) then lastOne:=true;
          k:=ListContents[j];
          DisplayStudent(k);
          if EnrolFlag then CheckNewPage;
         end;
        if not(enrolflag and XML_DISPLAY.formfeed) then ListFooter(i);
        if not(enrolflag) then CheckNewPage;
       end;
    end;
    if not(XML_DISPLAY.formfeed) then printCustomAddon;
  end; // if
end;


// TPrintListTtWin procedures

procedure TPrintListTtWin.PaintOnPrinter;
var
 i: integer;
begin
 SetTabs;
 TotalCount:=0;
 for i:=1 to NumOfLists do inc(TotalCount,ListSize[i]);
 if TotalCount=0 then
  begin
   printw('No timetables selected.');
   exit;
  end;
 if listtype=1 then
   begin
    printhead;
    DailyTt;
   end
    else WeeklyTt;
end;

procedure TPrintListTtWin.ShowDaily(var FirstOne:boolean; studnum,dI: integer);
var
 Ip,k,VertOffset:      integer;
begin
 for k:=1 to tsShowMaxDay[dI] do
  begin
   Ip:=tsShow[dI,k];
   if (Ip=0) and (k>1) then break;
   ShowTtItems(studnum,dI,Ip,tab1+dx*(k-1));
  end; {for k}
 newline;
 VertOffset:=PrntTxtHeight div 3;
 y1t:=y-PrntTxtheight-VertOffset; y2t:=y+PrntTxtheight; x:=0;
 drawMyLine(x-3,y2t,x+tab1+dx*tsShowMaxDay[dI]-3,y2t);
 if firstOne then
  begin
   firstOne:=false;
   drawMyLine(x-3,y1t,x+tab1+dx*tsShowMaxDay[dI]-3,y1t);
  end;
 drawMyLine(x-3,y1t,x-3,y2t);
 for Ip:=0 to tsShowMaxDay[dI] do
  drawMyLine(x+tab1+dx*Ip-3,y1t,x+tab1+dx*Ip-3,y2t);
end;



procedure TPrintListTtWin.DailyTt;
var
 i,j,k,dI,VertOffset:    integer;
 firstOne:         boolean;

   procedure DayHead;
   var
    p,Ip: integer;
   begin
     newline;
     fcolor(cpNormal); ListHead(i,dI); firstOne:=true;
     for p:=1 to tsShowMax do   {period header}
       begin
        Ip:=tsShow[dI,p];
        if (Ip=0) and (p>1) then break;
        x:=tab1+dx*(p-1)+ ((dx-PrintCanvas.textwidth(TimeSlotName[dI,Ip])) div 2); {centre period name}
        printw(TimeSlotName[dI,Ip]);
       end;
       inc(y,VertOffset);
   end;

begin
 VertOffset:=PrntTxtHeight div 3;
 for i:=1 to NumOfLists do
  if ListSize[i]>0 then
   begin
    for dI:=day1 to day2 do
     begin
      GetListContents(i);
      DayHead;
      for j:=1 to ListSize[i] do
       begin
        k:=ListContents[j];
        newline;
        fcolor(codecolor); ShowName(k);
        ShowDaily(FirstOne,k,dI);
        inc(y,VertOffset);
        if ((y+5*PrntTxtheight+2*VertOffset)>PrintPageHeight) and (j<ListSize[i]) then
         begin
          startnewPage;
          PrintHead;
          DayHead;
         end;
       end;
      newline; fcolor(cpNormal);
      WeeklyFooter(i);
      newline;
      printCustomAddon;
       if XML_DISPLAY.formfeed and ((dI<day2) or (i<NumOfLists)) then
        begin  startnewPage; PrintHead; end
       else  newline;
     end;
   end;
end;



procedure TPrintListTtWin.ShowWeekly(studnum: integer);
var
 dI,dI2,Ip,p,VertOffset,headgap:      integer;
 firstOne:                   bool;
 dayStart: array[0..nmbrdays] of integer;

 procedure WeekHead;
 var dI,dI2: integer;
 begin
  firstOne:=true;
  fcolor(codecolor);
  ShowName(studnum);   newline; fcolor(cpNormal);
  if (SelDays=0) or (tsShowMax=0) then printw(NoWeekSelect);
  if (SelDays>0) and (tsShowMax>0) then  {print headings if some content}
   for dI:=0 to SelDays-1 do
    begin
     dI2:=Xday[dI];
     x:=dayStart[dI]; if ShowTnames[dI] then inc(x,tab1);
     x:=x+((dx-PrintCanvas.textwidth(dayname[dI2])) div 2); {centre dayname}
     printw(dayname[dI2]);
    end; {for dI}
  x:=0; y:=y+PrnttxtHeight+headgap;   //newline
 end;


begin
 tab1:=fwPrntPeriodname+PrntBlankwidth;
 if XML_DISPLAY.ttClockShowFlg then
   if tab1<fwPrntClockStartEnd then tab1:=fwPrntClockStartEnd;
 dayStart[0]:=0;
 if SelDays>0 then
  for dI:=1 to SelDays do
   begin
    dayStart[dI]:=dayStart[dI-1]+dx;
    if ShowTnames[dI-1] then inc(dayStart[dI],tab1);
   end;

 VertOffset:=PrntTxtHeight div 5;
 headgap:=PrntTxtHeight div 4;
 WeekHead;

 if tsShowMax>0 then
  for Ip:=1 to tsShowMax do
   begin
    y1t:=y; inc(y,VertOffset);
    if SelDays>0 then
     for dI:=0 to SelDays-1 do
      begin
       dI2:=Xday[dI];
       p:=tsShow[dI2,Ip];
       if (p=0) and (Ip>1) then continue;
       if ShowTnames[dI] then
        begin
         x:=dayStart[dI]+PrntBlankwidth div 2;
         fcolor(cpNormal);
         printw(TimeSlotName[dI2,p]);
         if XML_DISPLAY.ttClockShowFlg then
          begin
           inc(y,PrntTxtHeight);
           printw(StartEndTime(dI2,p));
           dec(y,PrntTxtHeight);
          end;
        end;
       x:=dayStart[dI]; if ShowTnames[dI] then inc(x,tab1);
       ShowTtItems(studnum,dI2,p,x);
      end; {for dI}
    inc(y,2*PrntTxtheight+VertOffset);
    x:=0;
    if firstOne then
    begin
     firstOne:=false;
     drawMyLine(x-3,y1t,dayStart[SelDays]-3,y1t);
    end;
    drawMyLine(x-3,y,dayStart[SelDays]-3,y);
    drawMyLine(x-3,y1t,x-3,y);
    if SelDays>0 then
     for dI:=0 to SelDays do
      begin
       drawMyLine(dayStart[dI]-3,y1t,dayStart[dI]-3,y);
       if dI<SelDays then if ShowTnames[dI] then
        drawMyLine(dayStart[dI]+tab1-3,y1t,dayStart[dI]+tab1-3,y);
      end;
    if ((y+PrntTxtHeight*2+9)>PrintPageheight) and (Ip<tsShowMax) then
     begin
      startnewPage;
      PrintHead;
      WeekHead;
     end;
   end; {for Ip}
end;

procedure TPrintListTtWin.WeeklyTt;
var
 i,j,k,PweekCount,count:    integer;
 weekspace,smallWeekSpace: integer;
begin
 count:=0; PweekCount:=0;
 if XML_DISPLAY.Pweek<1 then
    XML_DISPLAY.Pweek:=1;
 WeeklyHeight:=yFooter+4*PrntTxtHeight+ (Prnttxtheight div 2)+6+
        (tsShowMax*2*(PrntTxtHeight+(PrntTxtHeight div 5)));
 parseCustomInfo;
 if CustomCnt>0 then inc(WeeklyHeight,(1+CustomCnt)*PrntTxtHeight);
 smallWeekSpace:=3*prntTxtHeight;
 weekspace:=(PrintPageheight-4*prntTxtHeight-prntVmargin-XML_DISPLAY.Pweek*WeeklyHeight) div (1+XML_DISPLAY.Pweek);
 if weekspace<0 then weekspace:=0;
 if XML_DISPLAY.Pweek=1 then if smallWeekSpace<weekspace then weekspace:=smallWeekSpace;
 for i:=1 to NumOfLists do
  if ListSize[i]>0 then
   begin
    GetListContents(i);
    fcolor(cpNormal);
    for j:=1 to ListSize[i] do
     begin
      k:=ListContents[j];
      if PweekCount=0 then
       begin
        PrintHead;
        if weekspace>0 then inc(y,weekspace);
       end;
      newline;
      ShowWeekly(k);
      newline;
      WeeklyFooter(k);
      inc(y,6);
      printCustomAddon;
      if weekspace>0 then inc(y,weekspace);
      inc(PweekCount); inc(count);
       if ((PweekCount>=XML_DISPLAY.Pweek)
        or (  ((y+WeeklyHeight)>PrintPageheight) and
         (WeeklyHeight<(PrintPageheight-4*prntTxtHeight-prntVmargin)) )) then

   {avoiding orphaned lines in print out -ensure at least 10 lines can print}
       begin
        PweekCount:=0;
        if count<>TotalCount then startnewPage; {only if not last}
       end;
     end;
   end;
end;


// TOutListTtWin procedures

procedure TOutListTtWin.PaintOnOutput;
var
 i: integer;
begin
 SetTabs;
 TotalCount:=0;
 for i:=1 to NumOfLists do inc(TotalCount,ListSize[i]);
 if TotalCount=0 then
  begin
   printLine(['No timetables selected.']);
   exit;
  end;
 if listtype=1 then
   begin
    header;
    DailyTt;
   end
    else WeeklyTt;
end;



procedure TOutListTtWin.ShowDaily(studnum,dI: integer);
var
 Ip,k:      integer;
begin
 for k:=1 to tsShowMaxDay[dI] do
 begin
  Ip:=tsShow[dI,k];
  if (Ip=0) and (k>1) then break;
  ShowTtItems(studnum,dI,Ip);
 end; {for k}
 newline;
end;

procedure TOutListTtWin.DailyTt;
var
 i,j,k,dI:    integer;
   procedure DayHead;
   var
    p,Ip: integer;
   begin
     newline;
     ListHead(i,dI);
     if Tabcount>0 then
      for Ip:= 1 to tabcount do printc(''); {match heading tabs with item tabs}
     for p:=1 to tsShowMax do   {period header}
       begin
        Ip:=tsShow[dI,p];
        if (Ip=0) and (p>1) then break;
        printc(TimeSlotName[dI,Ip]);printc('');printc('');
       end;
   end;

begin
 for i:=1 to NumOfLists do
  if ListSize[i]>0 then
   begin
    for dI:=day1 to day2 do
     begin
      GetListContents(i);
      DayHead;
      for j:=1 to ListSize[i] do
       begin
        k:=ListContents[j];
        newline;
        ShowName(k);
        ShowDaily(k,dI);
       end;
      newline;
      WeeklyFooter(i);
      newline;
      printCustomAddon;
      newline;
     end;
   end;
end;

procedure TOutListTtWin.ShowWeekly(studnum: integer);
var
 dI,dI2,Ip,p:      integer;
 firstOne:                   bool;

 procedure WeekHead;
 var dI,dI2: integer;
 begin
  firstOne:=true;
  ShowName(studnum);   newline;
  if (SelDays=0) or (tsShowMax=0) then printw(NoWeekSelect);

  if (SelDays>0) and (tsShowMax>0) then  {print headings if some content}
   begin
    if XML_DISPLAY.ttClockShowFlg then printc('');
    for dI:=0 to SelDays-1 do
     begin
      dI2:=Xday[dI];
      if (ShowTnames[dI] and (dI>0)) then
       begin
        printc('');
        if XML_DISPLAY.ttClockShowFlg then printc('');
       end;
     printc(dayname[dI2]);printc('');printc('');
    end; {for dI}
   end;
  newline;
 end;

  procedure ShowDummy;
  var
   aStr,bStr,cStr,dStr,eStr:                    string;
  begin
   astr:=''; bStr:=''; cStr:=''; eStr:='';
   dStr:='';
   if ShowTnames[dI] then
    begin
     if ((p>0) or (Ip=1)) then
        begin dStr:=TimeSlotName[dI2,p];  eStr:=StartEndTime(dI2,p); end;
     if dI=0 then printw(dStr) else printc(dStr);
     if XML_DISPLAY.ttClockShowFlg then printc(eStr);
    end;

   printc(aStr); printc(bStr);printc(cStr);
  end;


begin
 WeekHead;
 if tsShowMax>0 then
  for Ip:=1 to tsShowMax do
   begin
    if SelDays>0 then
     for dI:=0 to SelDays-1 do
      begin
       dI2:=Xday[dI];
       p:=tsShow[dI2,Ip];
       if (p=0) and (Ip>1) then
        begin
         ShowDummy;
         continue;
        end;
       if ShowTnames[dI] then
        begin
         if dI=0 then printw(TimeSlotName[dI2,p]) else printc(TimeSlotName[dI2,p]);
         if XML_DISPLAY.ttClockShowFlg then printc(StartEndTime(dI2,p));
        end;
       ShowTtItems(studnum,dI2,p);
      end; {for dI}
    newline;
   end; {for Ip}
 newline;
end;

procedure TOutListTtWin.WeeklyTt;
var
 i,j,k:    integer;
begin
 for i:=1 to NumOfLists do
  if ListSize[i]>0 then
   begin
    GetListContents(i);
    for j:=1 to ListSize[i] do
     begin
      k:=ListContents[j];
      if PweekCount=0 then
      newline;
      ShowWeekly(k);
      WeeklyFooter(k);
      printCustomAddon;
      newline;newline;
     end;
   end;
end;


end.
 