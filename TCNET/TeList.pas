unit TeList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ClassDefs, TimeChartGlobals, Menus,GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

type
  TTeListWin = class(TStudListWin)
    PopupMenu1: TPopupMenu;
    Selection1: TMenuItem;
    StudentTimetable1: TMenuItem;
    N2: TMenuItem;
    Print1: TMenuItem;
    PrintSetup1: TMenuItem;
    Copy2: TMenuItem;
    ChangeStudent1: TMenuItem;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Selection1Click(Sender: TObject);
    procedure StudentTimetable1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ChangeStudent1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure PaintHead;  override;
    procedure ListHead(i:integer);  override;
  private
    procedure NewList(te,y:smallint);
  end;

var
  TeListWin: TTeListWin;

procedure TeListPrint;
procedure TeListOut;


implementation

uses tcommon,StCommon,TeListSelect, Main;
{$R *.dfm}

type TPrintTeList=class(TPrintStudListWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;

type TOutTeList=class(TOutStudListWin)
  public
   procedure head; override;
   procedure SetTabs;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;



var
 PrintTeList:  TPrintTeList;
 OutTeList: TOutTeList;
 TeInsub,YrInsub: array of integer;
 tefound:           tpSubData;

procedure TTeListWin.SetTabs;
begin
 studentPointerSet;
 caption:='Teacher Subject List - '+groupname;
 ListType:=1;  {1 - student list}
 ShowZeroList:=false;
 codeColor:=cpStList; EnrolFlag:=false; 
 ListHeadLines:=1;
 GetLists;
 CalcArrayTops;
 RedoSelection;
end;

procedure ClearTfree;
var
 i: integer;
begin
 for i:=0 to numcodes[0] do tefound[i]:=0;
end;


procedure tcount(te,y: smallint);
var
 d,p,l,b:         integer;
 aFnt,bFnt:   tpintpoint;
begin
 for d:=0 to days-1 do
  for p:=1 to tlimit[d] do
   for l:=1 to level[y] do
     begin
      aFnt:=FNT(d,p-1,y,L,0);
      bFnt:=aFnt; inc(bFnt);
      if (te=bFnt^) then
       begin
        b:=aFnt^;
        if (b<>subNA) and (b<labelbase) and (b>0) and (b<=numcodes[0]) then
         begin
          inc(TeFound[0]);
          inc(TeFound[b]);
         end;
       end; {if (te=bFnt^)}
     end; {for l}
end;

function CountInSub(su,y:smallint):integer;
var
 j,count,st: smallint;
begin
 count:=0;
 if GroupNum>0 then
  for j:=1 to GroupNum do
   begin
    st:=StPointer[j];
    if CheckStudInSub(St,su) then
     if (y=-1) or (XML_STUDENTS.Stud[st].TcYear=y) then inc(count);
   end;
 result:=count;
end;

procedure TTeListWin.NewList(te,y:smallint);
var
 j,su,count: smallint;
begin
 if TeFound[0]>0 then
 for j:=1 to codeCount[0] do
  begin
   su:=codepoint[j,0];
   if TeFound[su]>0 then
    begin
     count:=CountInSub(su,y);
     if count>0 then
      begin
       inc(NumOfLists); SetArraySizes;
       SetLength(TeInsub,1+NumOfLists);  SetLength(YrInsub,1+NumOfLists);
       ListSet[NumOfLists]:=su;
       TeInsub[NumOfLists]:=te;  YrInsub[NumOfLists]:=y;
       ListSize[NumOfLists]:=count;
      end;
    end;  {if TeFound[su]>0 }
  end;  {for j}
end;


procedure TTeListWin.GetLists;
var
 num,k,y,te: smallint;
 astr: string;

begin
 if XML_DISPLAY.TeListShow=2 then
    num:=XML_DISPLAY.TeListSelection[0]
 else
    num:=codeCount[1];
 NumOfLists:=0;
 for k:=1 to num do
  begin
   if XML_DISPLAY.TeListShow=1 then te:=codepoint[k,1] else te:=XML_DISPLAY.TeListSelection[k];
   if not(TeachInAnyFac(te,XML_DISPLAY.TeListfac)) then continue;
   aStr:=copy(XML_TEACHERS.tecode[te,0],1,2);
   if (te=0) or (aStr='00') then continue;
   if XML_DISPLAY.MatchAllYears then
    begin
     clearTfree;
     for y:=0 to years_minus_1 do tcount(te,y);
     NewList(te,-1);
    end
   else
    for y:=years_minus_1 downto 0 do
     begin
      clearTfree;
      tcount(te,y);
      NewList(te,y);
     end;
  end; {for k}
end;

Procedure GeneralListContents(i,size,myset:integer;var Contents: array of integer);
var
 j,count: integer;
begin
 count:=0;
 if Size=0 then exit;
 for j:=1 to GroupNum do
  if CheckStudInSub(StPointer[j],myset) then
   if (YrInsub[i]=-1) or (XML_STUDENTS.Stud[StPointer[j]].TcYear=YrInsub[i]) then
    begin inc(count); Contents[count]:=StPointer[j]; end;
end;



procedure TTeListWin.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TTeListWin.PaintHead;
begin
 fcolor(cpNormal);
 printWl('Subject list for students in Group: '+groupname+' sorted by '+groupsortname[groupsort]);
 newline;
end;

procedure TTeListWin.ListHead(i:integer);
var
 te,su: integer;
 astr,bstr: string;
begin
 astr:='Students choosing ';
 fcolor(cpNormal);
 su:=ListSet[i];  te:=TeInsub[i];
 bstr:=''; if (YrInsub[i]>=0) then bstr:=' '+yeartitle+' '+yearname[YrInsub[i]]+' '; 
 printwl(astr+subcode[su]+' '+Subname[su]+bstr+' - '+XML_TEACHERS.tename[te,0]);
end;


procedure TTeListWin.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnTeList);
end;

procedure TTeListWin.FormResize(Sender: TObject);
begin
  Self.SetTabs;
  Refresh;
end;

procedure TTeListWin.Selection1Click(Sender: TObject);
begin
 TeListSelDlg:=TTeListSelDlg.create(self);
 TeListSelDlg.showmodal;
 TeListSelDlg.free;
end;

procedure TTeListWin.StudentTimetable1Click(Sender: TObject);
begin
 ShowStudTt;
end;

procedure TTeListWin.PopupMenu1Popup(Sender: TObject);
begin
 StudentTimetable1.visible:=(selcode>0);
 ChangeStudent1.visible:=(selcode>0);
end;

procedure TTeListWin.ChangeStudent1Click(Sender: TObject);
begin
 mainform.ChangeStudent1Click(Self);
end;

procedure TTeListWin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=cafree;
end;

{---------------------        print procs follow         --------------------}


procedure TPrintTeList.head;
begin
 UnderlineOn;
 printWl('Teacher subject list for students in Group: '+groupname+' sorted by '+groupsortname[groupsort]);
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(cpNormal);
end;

procedure TPrintTeList.ListHead(i:integer);
var
 te,su: integer;
 astr,bstr: string;
begin
 astr:='Students choosing ';
 fcolor(cpNormal);
 su:=ListSet[i];  te:=TeInsub[i];
 bstr:=''; if (YrInsub[i]>=0) then bstr:=' '+yeartitle+' '+yearname[YrInsub[i]]+' ';
 printwl(astr+subcode[su]+' '+Subname[su]+bstr+' - '+XML_TEACHERS.tename[te,0]);
end;


procedure TPrintTeList.GetLists;
var
 i: integer;
begin
 NumOfLists:=TeListWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=TeListWin.ListSize[i];
    ListSet[i]:=TeListWin.ListSet[i];
   end;
end;

procedure TPrintTeList.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintTeList.SetTabs;
begin
 studentPointerSet;
 ListType:=1;
 {1 - student list  2- numbers}
 codeColor:=cpStList; EnrolFlag:=false;
 ShowZeroList:=false;
 GetLists;
 CalcHeights;
end;



procedure TeListPrint;
begin   {start of main paint proc}
 PrintTeList:=TPrintTeList.Create;
 with PrintTeList do
  try
   SetTabs;
   ShowLists;
  finally
   PrintTeList.free;
  end;
end;


{---------------------        Text File Out procs follow         --------------------}


procedure TOutTeList.head;
begin
 printW('Subject list for students in Group: '+groupname+' sorted by '+groupsortname[groupsort]);
 newline;
end;

procedure TOutTeList.ListHead(i:integer);
var
 te,su: integer;
 astr,bstr: string;
begin
 astr:='Students choosing ';
 su:=ListSet[i];  te:=TeInsub[i];
 bstr:=''; if (YrInsub[i]>=0) then bstr:=' '+yeartitle+' '+yearname[YrInsub[i]]+' ';
 printw(astr+subcode[su]+' '+Subname[su]+bstr+' - '+XML_TEACHERS.tename[te,0]);
 newline;
end;


procedure TOutTeList.GetLists;
var
 i: integer;
begin
 NumOfLists:=TeListWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=TeListWin.ListSize[i];
    ListSet[i]:=TeListWin.ListSet[i];
   end;
end;

procedure TOutTeList.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TOutTeList.SetTabs;
begin
 studentPointerSet;
 ListType:=1;  {1 - student list  2- numbers}
 EnrolFlag:=false;
 ShowZeroList:=false;
 GetLists;
 CalcTotalCount;
end;



procedure TeListOut;
begin   {start of main paint proc}
 OutTeList:=TOutTeList.Create;
 with OutTeList do
  try
   SetTabs;
   ShowLists;
  finally
   OutTeList.free;
  end;
end;



end.
