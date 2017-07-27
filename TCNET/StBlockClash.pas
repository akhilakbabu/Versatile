unit StBlockClash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ClassDefs, TimeChartGlobals, Menus, XML.DISPLAY, XML.STUDENTS;

type
  TStClashWin = class(TStudListWin)
    PopupMenu1: TPopupMenu;
    ChangeStudent1: TMenuItem;
    StudentTimetable1: TMenuItem;
    N2: TMenuItem;
    Print1: TMenuItem;
    PrintSetup1: TMenuItem;
    Copy2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChangeStudent1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure StudentTimetable1Click(Sender: TObject);
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure PaintHead;  override;
    procedure ListHead(i:integer);  override;
  end;

var
  StClashWin: TStClashWin;

procedure StBlockClashPrint;
procedure StBlockClashOut;

implementation
uses tcommon,StCommon, Main;

{$R *.dfm}

type TPrintStBclash=class(TPrintStudListWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;

type TOutStBclash=class(TOutStudListWin)
  public
   procedure head; override;
   procedure SetTabs;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;

var
 PrintStBclash: TPrintStBclash;
 OutStBclash:   TOutStBclash;


function StudClashinMyBlock(st,myblock:integer):boolean;
 var
  j,a,k:   integer;
  count:     integer;
begin
 result:=false;
 count:=0;
 for j:=1 to chmax do
  begin
   a:=XML_STUDENTS.Stud[st].choices[j];
    if (a<>0) then
     if Sheet[myblock,0]>0 then
      for k:=1 to Sheet[myblock,0] do
       if a=Sheet[myblock,k] then
        begin
         inc(count);
         if count>1 then
          begin
           result:=true;
           break;
          end;
        end;
   if count>1 then break;
  end; {for j}
end;


procedure TStClashWin.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnStBlClash);
end;

procedure TStClashWin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=cafree;
end;

procedure TStClashWin.SetTabs;
begin
 studentPointerSet;
 caption:='Student Block Clashes - '+groupname;
 ListType:=1;  {1 - student list}
 ShowZeroList:=true;
 codeColor:=cpStList; EnrolFlag:=false; 
 ListHeadLines:=1;
 GetLists;
 CalcArrayTops;
 RedoSelection;
end;

procedure TStClashWin.GetLists;
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
      if StudClashinMyBlock(st,i) then inc(ListSize[i]);
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
   if StudClashinMyBlock(st,i) then
    begin inc(count); Contents[count]:=st; end;
  end;
end;



procedure TStClashWin.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TStClashWin.PaintHead;
begin
 fcolor(cpNormal);
 printWl('Block Clashes for students in Group: '+groupname+' sorted by '+groupsortname[groupsort]);
 newline;
end;

procedure TStClashWin.ListHead(i:integer);
var
 astr: string;
begin
 astr:='Students with clashes in block '+inttostr(i);
 fcolor(cpNormal);
 printwl(astr);
end;


procedure TStClashWin.ChangeStudent1Click(Sender: TObject);
begin
 mainform.ChangeStudent1Click(Self);
end;

procedure TStClashWin.PopupMenu1Popup(Sender: TObject);
begin
 StudentTimetable1.visible:=(selcode>0);
 ChangeStudent1.visible:=(selcode>0);
end;

procedure TStClashWin.StudentTimetable1Click(Sender: TObject);
begin
 ShowStudTt;
end;

{---------------------        print procs follow         --------------------}


procedure TPrintStBclash.head;
begin
 UnderlineOn;
 printWl('Block Clashes for students in Group: '+groupname+' sorted by '+groupsortname[groupsort]);
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(cpNormal);
end;

procedure TPrintStBclash.ListHead(i:integer);
var
 astr: string;
begin
 astr:='Students with clashes in block '+inttostr(i);
 fcolor(cpNormal);
 printwl(astr);
end;


procedure TPrintStBclash.GetLists;
var
 i: integer;
begin
 NumOfLists:=StClashWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=StClashWin.ListSize[i];
    ListSet[i]:=StClashWin.ListSet[i];
   end;
end;

procedure TPrintStBclash.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintStBclash.SetTabs;
begin
 studentPointerSet;
 ListType:=1;
 {1 - student list  2- numbers}
 codeColor:=cpStList; EnrolFlag:=false;
 ShowZeroList:=true;
 GetLists;
 CalcHeights;
end;



procedure StBlockClashPrint;
begin   {start of main paint proc}
 PrintStBclash:=TPrintStBclash.Create;
 with PrintStBclash do
  try
   SetTabs;
   ShowLists;
  finally
   PrintStBclash.free;
  end;
end;


{---------------------        Text File Out procs follow         --------------------}


procedure TOutStBclash.head;
begin
 printW('Block Clashes for students in Group: '+groupname+' sorted by '+groupsortname[groupsort]);
 newline;
end;

procedure TOutStBclash.ListHead(i:integer);
var
 astr: string;
begin
 astr:='Students with clashes in block '+inttostr(i);
 printw(astr);
 newline;
end;


procedure TOutStBclash.GetLists;
var
 i: integer;
begin
 NumOfLists:=StClashWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=StClashWin.ListSize[i];
    ListSet[i]:=StClashWin.ListSet[i];
   end;
end;

procedure TOutStBclash.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TOutStBclash.SetTabs;
begin
 studentPointerSet;
 ListType:=1;  {1 - student list  2- numbers}
 EnrolFlag:=false;
 ShowZeroList:=true;
 GetLists;
 CalcTotalCount;
end;



procedure StBlockClashOut;
begin   {start of main paint proc}
 OutStBclash:=TOutStBclash.Create;
 with OutStBclash do
  try
   SetTabs;
   ShowLists;
  finally
   OutStBclash.free;
  end;
end;



end.
