unit StudFree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ClassDefs, TimeChartGlobals, Menus, XML.DISPLAY;

type
  TStudFreeWin = class(TStudListWin)
    PopupMenu1: TPopupMenu;
    ChangeStudent1: TMenuItem;
    StudentTimetable1: TMenuItem;
    N2: TMenuItem;
    Print1: TMenuItem;
    PrintSetup1: TMenuItem;
    Copy2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StudentTimetable1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ChangeStudent1Click(Sender: TObject);
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure PaintHead;  override;
    procedure ListHead(i:integer);  override;
  end;

var
  StudFreeWin: TStudFreeWin;

procedure StudFreePrint;
procedure StudFreeOut;

implementation
uses tcommon,tcommon2,StCommon,main;
{$R *.dfm}

type TPrintStudFree=class(TPrintStudListWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;

type TOutStudFree=class(TOutStudListWin)
  public
   procedure head; override;
   procedure SetTabs;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;

var
 PrintStudFree:  TPrintStudFree;
 OutStudFree:   TOutStudFree;


procedure TStudFreeWin.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnStFRee);
end;

procedure TStudFreeWin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=cafree;
end;

procedure TStudFreeWin.SetTabs;
begin
 studentPointerSet;
 caption:='Students Free in Blocks - '+groupname;
 ListType:=1;  {1 - student list}
 ShowZeroList:=true;
 codeColor:=cpStList; EnrolFlag:=false; 
 ListHeadLines:=1;
 GetLists;
 CalcArrayTops;
 RedoSelection;
end;

procedure TStudFreeWin.GetLists;
var
 i,j,st: integer;
begin
 countsubsinblock;
 if SubsInBlock=0 then
  begin
   NumOfLists:=0;SetArraySizes;
   exit
  end;
 NumOfLists:=XML_DISPLAY.Blocknum; SetArraySizes;
 for i:=1 to XML_DISPLAY.BlockNum do
  begin
   ListSize[i]:=0; ListSet[i]:=0;
   if GroupNum>0 then
    for j:=1 to GroupNum do
     begin
      st:=StPointer[j];
      if StudFreeinBlock(st,i) then inc(ListSize[i]);
     end;
  end;  {for i}
end;

Procedure GeneralListContents(i,size,myset:integer;var Contents: array of integer);
var
 j,st,count: integer;
begin
 count:=0;
 if Size=0 then exit;
 for j:=1 to GroupNum do
  begin
   st:=StPointer[j];
   if StudFreeinBlock(st,i) then
    begin inc(count); Contents[count]:=st; end;
  end;
end;



procedure TStudFreeWin.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TStudFreeWin.PaintHead;
begin
 fcolor(cpNormal);
 printWl('Students Free in Blocks for student group: '+groupname+' sorted by '+groupsortname[groupsort]);
 newline;
end;

procedure TStudFreeWin.ListHead(i:integer);
var
 astr: string;
begin
 astr:='Students free in block '+inttostr(i);
 fcolor(cpNormal);
 printwl(astr);
end;


procedure TStudFreeWin.StudentTimetable1Click(Sender: TObject);
begin
 ShowStudTt;
end;

procedure TStudFreeWin.PopupMenu1Popup(Sender: TObject);
begin
 StudentTimetable1.visible:=(selcode>0);
 ChangeStudent1.visible:=(selcode>0);
end;

procedure TStudFreeWin.ChangeStudent1Click(Sender: TObject);
begin
 mainform.ChangeStudent1Click(Self);
end;

{---------------------        print procs follow         --------------------}


procedure TPrintStudFree.head;
begin
 UnderlineOn;
 printWl('Students Free in Blocks for student group: '+groupname+' sorted by '+groupsortname[groupsort]);
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(cpNormal);
end;

procedure TPrintStudFree.ListHead(i:integer);
var
 astr: string;
begin
 astr:='Students free in block '+inttostr(i);
 fcolor(cpNormal);
 printwl(astr);
end;


procedure TPrintStudFree.GetLists;
var
 i: integer;
begin
 NumOfLists:=StudFreeWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=StudFreeWin.ListSize[i];
    ListSet[i]:=StudFreeWin.ListSet[i];
   end;
end;

procedure TPrintStudFree.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintStudFree.SetTabs;
begin
 studentPointerSet;
 ListType:=1;
 {1 - student list  2- numbers}
 codeColor:=cpStList; EnrolFlag:=false;
 ShowZeroList:=true;
 GetLists;
 CalcHeights;
end;



procedure StudFreePrint;
begin   {start of main paint proc}
 PrintStudFree:=TPrintStudFree.Create;
 with PrintStudFree do
  try
   SetTabs;
   ShowLists;
  finally
   PrintStudFree.free;
  end;
end;


{---------------------        Text File Out procs follow         --------------------}


procedure TOutStudFree.head;
begin
 printW('Students Free in Blocks for student group: '+groupname+' sorted by '+groupsortname[groupsort]);
 newline;
end;

procedure TOutStudFree.ListHead(i:integer);
var
 astr: string;
begin
 astr:='Students free in block '+inttostr(i);
 printw(astr);
 newline;
end;


procedure TOutStudFree.GetLists;
var
 i: integer;
begin
 NumOfLists:=StudFreeWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=StudFreeWin.ListSize[i];
    ListSet[i]:=StudFreeWin.ListSet[i];
   end;
end;

procedure TOutStudFree.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TOutStudFree.SetTabs;
begin
 studentPointerSet;
 ListType:=1;  {1 - student list  2- numbers}
 EnrolFlag:=false;
 ShowZeroList:=true;
 GetLists;
 CalcTotalCount;
end;



procedure StudFreeOut;
begin   {start of main paint proc}
 OutStudFree:=TOutStudFree.Create;
 with OutStudFree do
  try
   SetTabs;
   ShowLists;
  finally
   OutStudFree.free;
  end;
end;

end.
