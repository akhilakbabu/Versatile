unit Findstud;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, TimeChartGlobals,ClassDefs, XML.DISPLAY, XML.TEACHERS,
  XML.STUDENTS;

type
  TFindStudent = class(TListTtWin)
    PopupMenu1: TPopupMenu;
    Selection2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    Exportastextfile1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Selection2Click(Sender: TObject);
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
  FindStudent: TFindStudent;

procedure findstudentprint;
procedure findstudenttext;

implementation
uses tcommon,fndstdlg,main,printers,tcommon2,stcommon;

type TPrintStudTtWin=class(TPrintListTtWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i,d:integer); override;
   procedure ShowName(i:integer);  override;
   procedure WeeklyFooter(i: Integer); override;
   procedure ShowTtItems(i,d,p,x1: integer); override;
 end;

 type TOutStudTtWin=class(TOutListTtWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i,d:integer); override;
   procedure ShowName(i:integer);  override;
   procedure WeeklyFooter(i:integer); override;
   procedure ShowTtItems(i,d,p: integer); override;
 end;

var
 PrintStudTtWin: TPrintStudTtWin;
 OutStudTtWin: TOutStudTtWin;

{$R *.DFM}

procedure TFindStudent.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnFindStud);
end;

procedure TFindStudent.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;


procedure TFindStudent.SetTabs;
var
 A1: integer;
begin
 listtype:=2; {weekly}
 CodeColor:=cpStList; {student}
 yFooter:=0; FooterWidth:=0;
 dx:=8+fwCode[1]+fwCode[2]+(blankwidth div 2);
 A1:=8+fwCode[0];
 if A1>dx then dx:=A1;
 case listtype of
   1: {daily}
   begin
    A1:=8+fwperiodname;
    if A1>dx then dx:=A1;
    tab1:=fwstname+blankwidth;
    CalcTabStField;
    inc(tab1,TabStField);
   end;
   2: {weekly}
   begin
     A1:=8+fwDayname;
     if A1>dx then dx:=A1;
     tab1:=fwPeriodname+blankwidth;
     if XML_DISPLAY.ttClockShowFlg then
       if tab1<fwClockStartEnd then tab1:=fwClockStartEnd;
     if XML_DISPLAY.stuttEnrolment then
     begin
       yFooter:=(chmax+2)*txtHeight;
       FooterWidth:=Hmargin+fwCode[0]+fwCodename[0]+fwCode[1]+fwCodename[1]  +blankwidth*10;
       if XML_DISPLAY.TrackEnrolFlag then
       begin
         if Length(Tabs) > 0 then
         begin
           Tabs[1]:=fwCode[0]+fwcodename[0]+fwcode[1]+blankwidth*5;
           if HasStudTrackData and (Length(Tabs) > 2) then
             yFooter:=yFooter + Tabs[3];
         end;
       end;
     end;
   end;
 end;
 GetLists;
 CalcArrayTops;
end;

procedure TFindStudent.GetLists;
begin
 NumOfLists:=1; SetArraySizes;
 ListSize[1]:=1;
end;

Procedure GeneralListContents(i,size,myset:integer;var Contents: array of integer);
begin
 Contents[1]:=studfindnum;
end;


procedure TFindStudent.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;


procedure TFindStudent.ShowName(i:integer);
begin
 if listtype=1 then showstudentname(i)
  else printw(GetStudentName(i));
end;

procedure TFindStudent.WeeklyFooter(i:integer);
begin
  if XML_DISPLAY.stuttEnrolment then {weekly}
  begin
    fcolor(cpNormal);
    printwl('Legend:');
    StudEnrolment(i, False, False);

    if OberonShow and XML_DISPLAY.TrackEnrolFlag and HasStudTrackData then
    begin
      //fcolor(cpNormal);
      //printwl('History:');
      //StudTrackEnrolment(i);
    end;
  end;
end;

procedure TFindStudent.ListHead(i,d:integer);
var
 s:string;
begin
 s:=yeartitle+' '+yearname[XML_STUDENTS.Stud[studfindnum].tcyear]+' student';
 printw(s);   newline;
end;


procedure TFindStudent.ShowTtItems(i,d,p,x1: integer);
var
 te,sc,ro,gotyear,lev,offset: integer;
 itemTt1,itemTt2,itemTt3: string;
begin
 sc:=0;
 GetStudentTtItem(te,sc,ro,gotyear,lev,i,d,p);
 if sc>0 then
  begin
   itemTt1:=trim(SubCode[sc]);
   itemTt2:=trim(XML_TEACHERS.tecode[te,0]);
   itemTt3:=trim(XML_TEACHERS.tecode[ro,1]);
   offset:=(dx-3-canvas.textwidth(ItemTt1)) div 2;
   x:=x1+offset; fcolor(cpSub); printw(ItemTt1); {subject}
   inc(y,txtHeight);
   offset:=(dx-3-canvas.textwidth(ItemTt2+' '+ItemTt3)) div 2;
   x:=x1+offset;
   fcolor(cpTeach);  printwl(ItemTt2+' '); {teacher}
   fcolor(cpRoom);  printw(ItemTt3);  {room}
   dec(y,txtHeight);
  end;
end;


procedure TFindStudent.Selection2Click(Sender: TObject);
begin
 findstudentdlg:=Tfindstudentdlg.create(self);   {allocate dlg}
 findstudentdlg.showmodal;
 findstudentdlg.free;
end;


{-------------- printing procs follow -------------------------}

procedure TPrintStudTtWin.head;
begin
 UnderlineOn;
 printwl('Student Timetable ');
 if winView[wnStudentTt]=0 then printwl(GroupCaption);
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;

procedure TPrintStudTtWin.WeeklyFooter(i: Integer);
begin
 case ListType of
  1: PrintW('Students: ' + IntToStr(ListSize[i])); {daily}
  2: if XML_DISPLAY.stuttEnrolment then {weekly}
     begin
       PrintWl('Legend:');
       StudEnrolment(i, false);
       //if OberonShow and TrackEnrolFlag and HasStudTrackData then
       //begin
         //fcolor(cpNormal);
         //printwl('History:');
         //StudTrackEnrolment(i);
       //end;
     end;
 end;
end;

procedure TPrintStudTtWin.SetTabs;
var
 A1: integer;
begin
 listtype:=2;
 CodeColor:=cpStList; {student}
 yFooter:=0;
 dx:=8+fwPrntCode[1]+fwPrntCode[2]+Prntblankwidth;
 A1:=8+fwPrntCode[0];
 if A1>dx then dx:=A1;
 case listtype of
   1: {daily}
     begin
      A1:=8+fwPrntperiodname;
      if A1>dx then dx:=A1;
      tab1:=fwPrntstname+Prntblankwidth;
      CalcTabStField;
      inc(tab1,TabStField);
     end;
   2: {weekly}
     begin
      A1:=8+fwPrntDayname;
      if A1>dx then dx:=A1;
     end;
 end;
 GetLists;
end;


procedure TPrintStudTtWin.GetLists;
begin
 NumOfLists:=1;
 SetArraySizes;
 ListSize[1]:=1;
end;


procedure TPrintStudTtWin.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintStudTtWin.ShowName(i:integer);
begin
  if listtype=1 then showstudentname(i)
  else printw(GetStudentName(i));
end;


procedure TPrintStudTtWin.ListHead(i,d:integer);
var
 s:string;
begin
 s:=yeartitle+' '+yearname[XML_STUDENTS.Stud[studfindnum].tcyear]+' student';
 printw(s);   newline;
end;

procedure TPrintStudTtWin.ShowTtItems(i,d,p,x1: integer);
var
 te,sc,ro,gotyear,lev,offset: integer;
 itemTt1,itemTt2,itemTt3: string;
begin
 sc:=0;
 GetStudentTtItem(te,sc,ro,gotyear,lev,i,d,p);
 if sc>0 then
  begin
   itemTt1:=trim(SubCode[sc]);
   itemTt2:=trim(XML_TEACHERS.tecode[te,0]);
   itemTt3:=trim(XML_TEACHERS.tecode[ro,1]);
   offset:=(dx-3-PrintCanvas.textwidth(ItemTt1)) div 2;
   x:=x1+offset; fcolor(cpSub); printw(ItemTt1); {subject}
   inc(y,PrntTxtHeight);
   offset:=(dx-3-PrintCanvas.textwidth(ItemTt2+' '+ItemTt3)) div 2;
   x:=x1+offset;
   fcolor(cpTeach);  printwl(ItemTt2+' '); {teacher}
   fcolor(cpRoom);  printw(ItemTt3);  {room}
   dec(y,PrntTxtHeight);
  end;
end;


procedure findstudentprint;
begin
 PrintStudTtWin:=TPrintStudTtWin.Create;
 with PrintStudTtWin do
  try
   PaintOnPrinter;
  finally
   PrintStudTtWin.free;
  end;
end;






procedure TFindStudent.FormDblClick(Sender: TObject);
begin
 findstudentdlg:=Tfindstudentdlg.create(self);   {allocate dlg}
 findstudentdlg.showmodal;
 findstudentdlg.free;
end;



{-------=======-------- Text Output procs follow -------=======--------=========}


procedure TOutStudTtWin.head;
begin
 printw('Student Timetable ');
 newline;
end;

procedure TOutStudTtWin.WeeklyFooter(i:integer);
begin
 case ListType of
  1: begin    {daily}
       printLine(['Students: ', IntToStr(ListSize[i])]);
       newline;
     end;
  2: if XML_DISPLAY.stuttEnrolment then
     begin
       PrintW('Legend:');
       StudEnrolment(i, False);
       //if OberonShow and TrackEnrolFlag and HasStudTrackData then
       //begin
         //printw('History');
         //StudTrackEnrolment(i);
       //end;
     end;{weekly}
 end;
end;

procedure TOutStudTtWin.SetTabs;
begin
 listtype:=2;
 GetLists;
 TabCount:=0;
 if listtype=1 then CalcTabCount;
end;


procedure TOutStudTtWin.GetLists;
begin
 NumOfLists:=1;
 SetArraySizes;
 ListSize[1]:=1;
end;


procedure TOutStudTtWin.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TOutStudTtWin.ShowName(i:integer);
begin
  if listtype=1 then showstudentname(i)
  else printw(GetStudentName(i));
end;


procedure TOutStudTtWin.ListHead(i,d:integer);
var
 s:string;
begin
 s:=yeartitle+' '+yearname[XML_STUDENTS.Stud[studfindnum].tcyear]+' student';
 printw(s);   newline;
end;

procedure TOutStudTtWin.ShowTtItems(i,d,p: integer);
var
 te,sc,ro,gotyear,lev: integer;
 itemTt1,itemTt2,itemTt3: string;
begin
 sc:=0;
 GetStudentTtItem(te,sc,ro,gotyear,lev,i,d,p);
 if sc>0 then
  begin
   itemTt1:=trim(SubCode[sc]);
   itemTt2:=trim(XML_TEACHERS.tecode[te,0]);
   itemTt3:=trim(XML_TEACHERS.tecode[ro,1]);
   printc(ItemTt1); {subject}
   printc(ItemTt2); {teacher}
   printc(ItemTt3);  {room}
  end
 else
  begin
   printc(''); printc(''); printc('');
  end;
end;


procedure findstudenttext;
begin
 OutStudTtWin:=TOutStudTtWin.Create;
 with OutStudTtWin do
  try
   PaintOnOutput;
  finally
   OutStudTtWin.free;
  end;
end;



end.

