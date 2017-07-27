unit Roomtt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, StdCtrls,ClassDefs,TimeChartGlobals,
  XML.DISPLAY, XML.TEACHERS;

type
  TRoTtable = class(TListTtWin)
    PopupMenu1: TPopupMenu;
    Selection2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    Copy1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Selection2Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure ShowTtItems(i,d,p,x1: integer); override;
    procedure ListHead(i,d:integer);  override;
    procedure ShowName(i:integer);  override;
    procedure WeeklyFooter(i:integer); override;
  end;

var
  RoTtable: TRoTtable;

procedure roomTtableprint;
procedure roomTtableOut;

implementation

uses
  tcommon,main,rottdlg,printers,tcommon2, Stcommon;

{$R *.DFM}

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

type TOutRoTtWin=class(TOutListTtWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i,d:integer); override;
   procedure ShowName(i:integer);  override;
   procedure WeeklyFooter(i:integer); override;
   procedure ShowTtItems(i,d,p: integer);  override;
 end;

var
 PrintRoTtWin:    TPrintRoTtWin;
 OutRoTtWin:  TOutRoTtWin;
 tscount:  integer;

Procedure GeneralListContents(i,size,myset:integer;var Contents: array of integer);
var
 j,count,t,countfrom: integer;
begin
 count:=0;
 if Size=0 then exit;
 if XML_DISPLAY.rottseltype=1 then
    countfrom:=codeCount[2]
 else
    countfrom:=XML_DISPLAY.rottselection[0];
 for j:=1 to countfrom do
  begin
   if XML_DISPLAY.rottseltype=2 then
        t:=XML_DISPLAY.rottselection[j]
   else
        t:=codepoint[j,2];
   if RoomInAnyFac(t,myset) then begin inc(count); Contents[count]:=t; end;
  end;
end;

procedure TRoTtable.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TRoTtable.GetLists;
var
 i,t,kk,count: integer;
begin
 NumOfLists:=1; SetArraySizes;
 if XML_DISPLAY.rottseltype=1 then
    count:=codeCount[2]
 else
   count:=XML_DISPLAY.rottselection[0];
 kk:=0;
 if count>0 then
  for i:=1 to count do
   begin
    if XML_DISPLAY.rottseltype=2 then
          t:=XML_DISPLAY.rottselection[i]
    else
          t:=codepoint[i,2];
    if RoomInAnyFac(t,XML_DISPLAY.rottlistvals[3]) then inc(kk);
   end;
 ListSize[1]:=kk; ListSet[1]:=XML_DISPLAY.rottlistvals[3]
end;

procedure TRoTtable.ShowName(i:integer);
begin
 tscount:=0;
 if listtype=1 then
  begin
   x:=blankwidth div 3;
   printw(XML_TEACHERS.tecode[i,1]);
   inc(y,txtHeight);
   printw(XML_TEACHERS.tename[i,1]);
   dec(y,txtHeight);
  end
  else printw(XML_TEACHERS.tecode[i,1]+' '+XML_TEACHERS.tename[i,1]);
end;

procedure TRoTtable.ListHead(i,d:integer);
var
 s:string;
 j: integer;
begin
 if listtype=1 then s:=dayname[d]+' for ' else s:='For ';
 j:=ListSet[i];
  case XML_DISPLAY.rottseltype of
   1: s:=s+'All Rooms';
   2: s:=s+'Room Selection';
  end;
  if j>0 then s:=s+' in faculty '+facname[j];
  printw(s);   newline;
end;

procedure TRoTtable.ShowTtItems(i,d,p,x1: integer);
var
  te,sc,royear,lev,offset: integer;
  itemTt1,itemTt2,itemTt3: string;
  lNoOfStud: Integer;
begin
  if GetRoomTtItem(sc,te,RoYear,Lev,i,d,p) then
  begin
    inc(tscount);
    itemTt1:=trim(SubCode[sc]);
    itemTt2:=trim(XML_TEACHERS.tecode[te,0]);
    itemTt3:=FNycSHARED(d,p,i,2);
    offset := (dx - 3 - Canvas.TextWidth(ItemTt1+' '+itemTt2)) div 2;
    x := x1 + offset; fcolor(cpSub); printwl(ItemTt1+' '); {subject}
    fcolor(cpTeach); printw(ItemTt2); {teacher}
    inc(y,txtHeight);
    if XML_DISPLAY.Tyr = 3 then
    begin
      lNoOfStud := GetNoOfStudentsInClass(RoYear, sc, Te, i, D, P);
      itemTt3 := IntToStr(lNoOfStud);
    end;
    offset := (dx - 3 - Canvas.TextWidth(itemTt3)) div 2;
    x := x1 + offset; fcolor(cpClass); printw(itemTt3 + '  '); {class}
    //fColor(cpNormal);
    //PrintW(IntToStr(lNoOfStud));
    dec(y,txtHeight);
  end;
end;

procedure TRoTtable.SetTabs;
var
 i,A1:       integer;

begin
 listtype:=winView[wnRoomTt]+1;  CodeColor:=cpRoom;
 day1:=XML_DISPLAY.rottlistvals[4];
 day2:=XML_DISPLAY.rottlistvals[5];
 yFooter:=txtHeight; FooterWidth:=0;
 dx:=8+fwCode[0]+fwCode[1]+(blankwidth div 2);
 if XML_DISPLAY.tyr>0 then
   begin
    A1:=8+fwyearname;
    if A1>dx then dx:=A1;
    A1:=8+fwClass;
    if A1>dx then dx:=A1;
   end;
 if listtype=2 then
 begin         {weekly}
  A1:=8+fwDayname;
  if A1>dx then dx:=A1;
 end
 else    {daily}
  begin
   A1:=8+fwperiodname;
   if A1>dx then dx:=A1;
   i:=fwcodename[2];
  if fwcode[2]>i then i:=fwcode[2];
  tab1:=i+blankwidth;
  end;
 GetLists;
 CalcArrayTops;
end;

procedure TRoTtable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TRoTtable.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnRoomTt)
end;

procedure TRoTtable.Selection2Click(Sender: TObject);
begin
 RoomTTdlg:=TRoomTTdlg.create(self);   {allocate dlg}
 RoomTTdlg.showmodal;
 RoomTTdlg.free;
end;

procedure TRoTtable.WeeklyFooter(i:integer);
begin
 if listtype=1 then {daily}
  begin
   printw('Rooms: '+inttostr(ListSize[i]));
  end
 else
  begin
   x:=0;  fcolor(cpNormal);
   printw('Total time slots: '+inttostr(tscount)+'   Capacity: '+inttostr(XML_TEACHERS.rosize[i]));
   newline;
  end;
end;

procedure TRoTtable.FormPaint(Sender: TObject);
begin
end;

{ -----------------         print procs follow            --------------------}

procedure TPrintRoTtWin.head;
begin
 UnderlineOn;
 printwl('Room Timetable ');
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;

procedure TPrintRoTtWin.WeeklyFooter(i:integer);
begin
 if listtype=1 then {daily}
   printw('Rooms: '+inttostr(ListSize[i]))
 else
  begin
   printw('Total time slots: '+inttostr(tscount)+'  Capacity: '+inttostr(XML_TEACHERS.rosize[i]));
   newline;
  end;
end;

procedure TPrintRoTtWin.SetTabs;
var
 A1,i: integer;
begin
 listtype:=winView[wnRoomTt]+1;  CodeColor:=cpRoom;
 day1:=XML_DISPLAY.rottlistvals[4];
 day2:=XML_DISPLAY.rottlistvals[5];
 yFooter:=PrntTxtHeight;
 dx:=8+fwPrntCode[0]+fwPrntCode[1]+Prntblankwidth;
 if XML_DISPLAY.tyr>0 then
   begin
    A1:=8+fwPrntyearname;
    if A1>dx then dx:=A1;
    A1:=8+fwPrntClass;
    if A1>dx then dx:=A1;
   end;
 if listtype=2 then
  begin         {weekly}
   A1:=8+fwPrntDayname;
   if A1>dx then dx:=A1;
   tab1:=fwPrntPeriodname+Prntblankwidth;
   if XML_DISPLAY.ttClockShowFlg then
    if tab1<fwPrntClockStartEnd then tab1:=fwPrntClockStartEnd;
  end
 else    {daily}
  begin
   A1:=8+fwPrntperiodname;
   if A1>dx then dx:=A1;
   i:=fwPrntcodename[2];
   if fwPrntcode[2]>i then i:=fwPrntcode[2];
   tab1:=i+Prntblankwidth;
  end;
 GetLists;
end;

procedure TPrintRoTtWin.GetLists;
var
 i: integer;
begin
 NumOfLists:=RoTtable.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=RoTtable.ListSize[i];
    ListSet[i]:=RoTtable.ListSet[i];
   end;
end;

procedure TPrintRoTtWin.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintRoTtWin.ShowName(i:integer);
begin
 tscount:=0;
 if listtype=1 then
  begin
   x:=PrntBlankwidth div 3;
   printw(XML_TEACHERS.tecode[i,1]);
   inc(y,PrntTxtHeight);
   printw(XML_TEACHERS.tename[i,1]);
   dec(y,PrntTxtHeight);
  end
  else printw(XML_TEACHERS.tecode[i,1]+' '+XML_TEACHERS.tename[i,1]);
end;

procedure TPrintRoTtWin.ListHead(i,d:integer);
var
 s:string;
 j: integer;
begin
 if listtype=1 then s:=dayname[d]+' for ' else s:='For ';
 j:=ListSet[i];
  case XML_DISPLAY.rottseltype of
   1: s:=s+'All Teachers';
   2: s:=s+'Room Selection';
  end;
  if j>0 then s:=s+' in faculty '+facname[j];
  printw(s);   newline;
end;

procedure TPrintRoTtWin.ShowTtItems(i,d,p,x1: integer);
var
  te,sc,royear,lev,offset: integer;
  itemTt1,itemTt2,itemTt3: string;
  lNoOfStud: Integer;
begin
  if GetRoomTtItem(sc,te,RoYear,Lev,i,d,p) then
  begin
    inc(tscount);
    itemTt1:=trim(SubCode[sc]);
    itemTt2:=trim(XML_TEACHERS.tecode[te,0]);
    itemTt3:=FNycSHARED(d,p,i,2);
    offset:=(dx-3-PrintCanvas.textwidth(ItemTt1+' '+itemTt2)) div 2;
    x:=x1+offset; fcolor(cpSub); printwl(ItemTt1+' '); {subject}
    fcolor(cpTeach); printw(ItemTt2); {teacher}
    inc(y,PrntTxtHeight);

    if XML_DISPLAY.Tyr = 3 then
    begin
      lNoOfStud := GetNoOfStudentsInClass(RoYear, sc, Te, i, D, P);
      itemTt3 := IntToStr(lNoOfStud);
    end;
    offset:=(dx-3-PrintCanvas.textwidth(itemTt3)) div 2;
    x := x1 + offset; fcolor(cpClass); printw(itemTt3); {class}
    //fColor(cpNormal);
    //PrintW(IntToStr(lNoOfStud));
    dec(y,PrntTxtHeight);
  end;
end;

procedure roomTtableprint;
begin
 PrintRoTtWin:=TPrintRoTtWin.Create;
 with PrintRoTtWin do
  try
   PaintOnPrinter;
  finally
   PrintRoTtWin.free;
  end;
end;


{ -----------------     Text Output procs follow            --------------------}

procedure TOutRoTtWin.head;
begin
 printLine(['Room Timetable']);
end;

procedure TOutRoTtWin.WeeklyFooter(i:integer);
begin
 if listtype=1 then {daily}
   printw('Rooms: '+inttostr(ListSize[i]))
 else
  begin
   printw('Total time slots: '+inttostr(tscount)+'  Capacity: '+inttostr(XML_TEACHERS.rosize[i]));
   newline;
  end;
end;

procedure TOutRoTtWin.SetTabs;
begin
 listtype:=winView[wnRoomTt]+1;
 day1:=XML_DISPLAY.rottlistvals[4];
 day2:=XML_DISPLAY.rottlistvals[5];
 GetLists;
 TabCount:=1;
end;

procedure TOutRoTtWin.GetLists;
var
 i: integer;
begin
 NumOfLists:=RoTtable.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=RoTtable.ListSize[i];
    ListSet[i]:=RoTtable.ListSet[i];
   end;
end;

procedure TOutRoTtWin.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TOutRoTtWin.ShowName(i:integer);
begin
 tscount:=0;
 if listtype=1 then
  begin
   printw(XML_TEACHERS.tecode[i,1]);
   printc(XML_TEACHERS.tename[i,1]);
  end
  else printw(XML_TEACHERS.tecode[i,1]+' '+XML_TEACHERS.tename[i,1]);
end;

procedure TOutRoTtWin.ListHead(i,d:integer);
var
 s:string;
 j: integer;
begin
 if listtype=1 then s:=dayname[d]+' for ' else s:='For ';
 j:=ListSet[i];
  case XML_DISPLAY.rottseltype of
   1: s:=s+'All Teachers';
   2: s:=s+'Room Selection';
  end;
  if j>0 then s:=s+' in faculty '+facname[j];
  printw(s);   newline;
end;

procedure TOutRoTtWin.ShowTtItems(i,d,p: integer);
var
  te,sc,royear,lev: integer;
  itemTt1,itemTt2,itemTt3: string;
  lNoOfStud: Integer;
begin
  if GetRoomTtItem(sc,te,RoYear,Lev,i,d,p) then
  begin
    inc(tscount);
    itemTt1:=trim(SubCode[sc]);
    itemTt2:=trim(XML_TEACHERS.tecode[te,0]);
    itemTt3:=FNycSHARED(d,p,i,2);
    printc(ItemTt1); {subject}
    printc(ItemTt2); {teacher}
    if XML_DISPLAY.Tyr = 3 then
    begin
      lNoOfStud := GetNoOfStudentsInClass(RoYear, sc, Te, i, D, P);
      itemTt3 := IntToStr(lNoOfStud);
    end;
    printc(itemTt3); {class}
  end
  else
  begin
    printc(''); printc(''); printc('');
  end;
end;

procedure roomTtableOut;
begin
 OutRoTtWin:=TOutRoTtWin.Create;
 with OutRoTtWin do
  try
   PaintOnOutput;
  finally
   OutRoTtWin.free;
  end;
end;

procedure TRoTtable.PopupMenu1Popup(Sender: TObject);
begin
  selection2.enabled:=(codeCount[2]>0);
end;

procedure TRoTtable.FormDblClick(Sender: TObject);
begin
 selection2click(self);
end;

end.


