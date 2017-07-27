unit Teclash;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, TimeChartGlobals,ClassDefs,GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  TTeacherClashes = class(TDrawWin)
    PopupMenu1: TPopupMenu;
    Selection2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    Exportastextfile1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Selection2Click(Sender: TObject);
  protected
    procedure SetTabs; override;
  private
    procedure highlightClash;
  end;

procedure TeacherClashesprint;
procedure TeacherClashestext;


var
  TeacherClashes: TTeacherClashes;


implementation
uses tcommon,main,tecldlg,printers,tcommon2;
{$R *.DFM}

type TPrintTclashWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
  private
    procedure highlightClash;
 end;

 type TOutTclashWin=class(TOutputwin)
  public
   procedure head; override;
 end;

var
  PrintTclashWin:     TPrintTclashWin;
  OutTclashWin:      TOutTclashWin;
  lcount:              integer;

procedure TTeacherClashes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TTeacherClashes.SetTabs;
var
 D,P,y1,l: integer;
 cbFnt:         tpbytepoint;
begin
 lcount:=0;
 SetLength(Tabs,8);
 MaxTab(1,fwcode[1],'Teacher');
 if XML_DISPLAY.tcCurPeriodOnly then
  begin
   headwidth:=canvas.textwidth('Teacher Clashes - for '+day[nd]+':'+inttostr(np+1));
   MaxTab(2,fwyearname,yearTitle);
   MaxTab(3,fwcode[0],'Subject');
   MaxTab(4,fwcode[2],'Room');
   MaxTab(5,0,'Level/Class');
   MaxW:=Tabs[5]+Hmargin*2;
   for y1:=0 to years_minus_1 do
    for l:=1 to level[y1] do
     begin
      cbFnt:=FNTbyte(nd,np,y1,l,7);
      if ((cbFnt^ and 8)=8) then inc(lcount);
     end;
  end
 else
  begin
   headwidth:=canvas.textwidth('Teacher Clashes ');
   MaxTab(2,fwcode[0],'Subject');
   MaxTab(3,fwcode[2],'Room');
   MaxTab(4,fwdayname,'Day');
   MaxTab(5,fwperiodname,'Time');
   MaxTab(6,fwyearname,yearTitle);
   MaxTab(7,0,'Level/Class');
   MaxW:=Tabs[7]+Hmargin*2;
   for D:=0 to (days-1) do
    for P:=0 to (tlimit[D]-1) do
     if Tclash[D,P]<>0 then
      for y1:=0 to years_minus_1 do
       for L:=1 to level[y1] do
        begin
         cbFnt:=FNTbyte(D,P,y1,L,7);
         if ((cbFnt^ and 8)=8) then inc(lcount);
        end; {for L}
  end;
 MaxH:=(5+lcount)*txtheight;
end;

procedure TTeacherClashes.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnTeClash);
end;


procedure TTeacherClashes.highlightClash;
var
 aRect:               Trect;
begin
 fcolor(cpTclash); {te clash}
 aRect.left:=hmargin-hscroll; aRect.right:=aRect.left+fwcode[1];
 aRect.top:=y;             aRect.bottom:=arect.top+txtheight;
 canvas.fillrect(aRect);
end;

procedure TTeacherClashes.FormPaint(Sender: TObject);
var
 i,j,k:            integer;
 D,P,y1,L: integer;
 aStr:    string;
 aFnt,cFnt:      tpintpoint;
 abFnt,cbFnt:         tpbytepoint;

procedure showteacherperiod;
var
 y1,l: integer;
 astr:        string;
begin
 fcolor(cpNormal);
 printw('Teacher Clashes - for '+day[nd]+':'+inttostr(np+1));
 newline; newline;
 if Tclash[nd,np]=0 then
 begin
  printw(' No clashes. ');
  newline;
  exit;
 end;
 printw('Teacher');
 x:=Tabs[1]; printw(yeartitle);
 x:=Tabs[2]; printw('Subject');
 x:=Tabs[3]; printw('Room');
 x:=Tabs[4]; printw('Level/Class');
 newline;
 for y1:=0 to years_minus_1 do
  for l:=1 to level[y1] do
  begin
   cFnt:=FNT(nd,np,y1,l,0);
   cbFnt:=FNTbyte(nd,np,y1,l,7);
   if ((cbFnt^ and 8)=8) then
   begin
    i:=cFnt^; inc(cFnt); j:=cFnt^; inc(cFnt); k:=cFnt^;
    highlightClash;
    printw(XML_TEACHERS.tecode[j,0]);
    x:=Tabs[1]; fcolor(cpFac); printw(yearname[y1]);
    x:=Tabs[2]; fcolor(cpSub); printw(SubCode[i]);
    x:=Tabs[3]; fcolor(cpRoom); printw(XML_TEACHERS.tecode[k,1]);
    x:=Tabs[4]; fcolor(cpFac);
    aStr:=trim(ClassCode[ClassShown[L,y1]]);
    if (aStr<>'') then printw(aStr)
     else printw('Level '+inttostr(L));
    newline;
   end;
  end; {for l}
end;


begin
 fcolor(cpNormal);
 if XML_DISPLAY.tcCurPeriodOnly then
  begin
   showteacherperiod;
   exit;
  end;

 if (lcount>0) then
 begin
  printw('Teacher Clashes ');
  newline; newline;
  fcolor(cpNormal);
  printw('Teacher');
  x:=Tabs[1]; printw('Subject');
  x:=Tabs[2]; printw('Room');
  x:=Tabs[3]; printw('Day');
  x:=Tabs[4]; printw('Time');
  x:=Tabs[5]; printw(yeartitle);
  x:=Tabs[6]; printw('Level/Class');
  newline;

 end
 else
  begin
   printw('No Teacher Clashes ');
   newline; newline;
   exit;  {finished}
  end;
  {clashes so continue}
 for D:=0 to (days-1) do
  for P:=0 to (tlimit[D]-1) do
   if Tclash[D,P]<>0 then
    for y1:=0 to years_minus_1 do
     for L:=1 to level[y1] do
      begin
       aFnt:=FNT(D,P,y1,L,0);
       abFnt:=FNTbyte(D,P,y1,L,7);
       if ((abFnt^ and 8)=8) then
        begin
         i:=aFnt^; inc(aFnt); j:=aFnt^; inc(aFnt); k:=aFnt^;
         highlightClash;
         printw(XML_TEACHERS.tecode[j,0]);
         x:=Tabs[1]; fcolor(cpSub); printw(SubCode[i]);
         x:=Tabs[2]; fcolor(cpRoom); printw(XML_TEACHERS.tecode[k,1]);
         x:=Tabs[3]; fcolor(cpFac); printw(dayname[D]);
         x:=Tabs[4]; printw(TimeSlotName[D,P]);
         x:=Tabs[5]; printw(yearname[y1]);
         x:=Tabs[6];
         aStr:=trim(ClassCode[ClassShown[L,y1]]);
         if (aStr<>'') then printw(aStr)
          else printw('Level '+inttostr(L));
         newline;
        end; {if ((abFnt^ and B)=B)}
     end; {for L}

end;

procedure TTeacherClashes.Selection2Click(Sender: TObject);
begin
 teacherclashdlg:=Tteacherclashdlg.create(self);   {allocate dlg}
 teacherclashdlg.showmodal;
 teacherclashdlg.free;
end;

{----------------     print procs follow    ----------------=======-------=-=-=-=-=-=-=----}


procedure TPrintTclashWin.head;
begin
 fcolor(cpNormal);
 UnderlineOn;
 printwl('Teacher Clashes');
 if XML_DISPLAY.tcCurPeriodOnly then printw(' - for '+day[nd]+':'+inttostr(np+1));
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;
 if lcount=0 then
 begin
  printw(' No clashes. ');
  x:=0; y:=y+PrnttxtHeight;
  exit;
 end;
 if XML_DISPLAY.tcCurPeriodOnly then
  begin
   printw('Teacher');
   x:=PrntTabs[1]; printw(yeartitle);
   x:=PrntTabs[2]; printw('Subject');
   x:=PrntTabs[3]; printw('Room');
   x:=PrntTabs[4]; printw('Level/Class');
  end
 else
  begin
   printw('Teacher');
   x:=PrntTabs[1]; printw('Subject');
   x:=PrntTabs[2]; printw('Room');
   x:=PrntTabs[3]; printw('Day');
   x:=PrntTabs[4]; printw('Time');
   x:=PrntTabs[5]; printw(yeartitle);
   x:=PrntTabs[6]; printw('Level/Class');
  end;
 x:=0; y:=y+PrnttxtHeight;
end;


procedure TPrintTclashWin.highlightClash;
var
 aRect:               Trect;
begin
 fcolor(cpTclash); {te clash}
 aRect.left:=prnthmargin; aRect.right:=aRect.left+fwprntcode[1];
 aRect.top:=y;             aRect.bottom:=arect.top+PrnttxtHeight;
 PrintCanvas.fillrect(aRect);
end;

procedure TPrintTclashWin.SetTabs;
begin
 SetLength(PrntTabs,8);
 MaxTab(1,fwprntcode[1],'Teacher');
 if XML_DISPLAY.tcCurPeriodOnly then
  begin
   MaxTab(2,fwprntyearname,yearTitle);
   MaxTab(3,fwprntcode[0],'Subject');
   MaxTab(4,fwprntcode[2],'Room');
   MaxTab(5,0,'Level/Class');
  end
 else
  begin
   MaxTab(2,fwprntcode[0],'Subject');
   MaxTab(3,fwprntcode[2],'Room');
   MaxTab(4,fwprntdayname,'Day');
   MaxTab(5,fwprntperiodname,'Time');
   MaxTab(6,fwprntyearname,yearTitle);
   MaxTab(7,0,'Level/Class');
  end;
end;


procedure TeacherClashesprint;
var
 D,P,y1,l:  integer;
 i,j,k:        integer;
 astr:            string;
 aFnt,cFnt:      tpintpoint;
 abFnt,cbFnt:         tpbytepoint;
begin
 PrintTclashWin:=TPrintTclashWin.create;
 with PrintTclashWin do
  try
   PrintHead;
   if Lcount=0 then exit;
   if XML_DISPLAY.tcCurPeriodOnly then
    begin    {current period only}
     for y1:=0 to years_minus_1 do
      for l:=1 to level[y1] do
       begin
        cFnt:=FNT(nd,np,y1,l,0);
        cbFnt:=FNTbyte(nd,np,y1,l,7);
        if ((cbFnt^ and 8)=8) then
         begin
          i:=cFnt^; inc(cFnt); j:=cFnt^; inc(cFnt); k:=cFnt^;
          highlightClash;
          printw(XML_TEACHERS.tecode[j,0]);
          x:=PrntTabs[1]; fcolor(cpFac); printw(yearname[y1]);
          x:=PrntTabs[2]; fcolor(cpSub); printw(SubCode[i]);
          x:=PrntTabs[3]; fcolor(cpRoom); printw(XML_TEACHERS.tecode[k,1]);
          x:=PrntTabs[4]; fcolor(cpFac);
          aStr:=trim(ClassCode[ClassShown[L,y1]]);
          if (aStr<>'') then printw(aStr)
           else printw('Level '+inttostr(L));
          newline;
         end;
        end; {for l}
    end {current period}
   else
    begin {all times}
     for D:=0 to (days-1) do
      for P:=0 to (tlimit[D]-1) do
       if Tclash[D,P]<>0 then
        for y1:=0 to years_minus_1 do
         for L:=1 to level[y1] do
          begin
           aFnt:=FNT(D,P,y1,L,0);
           abFnt:=FNTbyte(D,P,y1,L,7);
           if ((abFnt^ and 8)=8) then
            begin
             i:=aFnt^; inc(aFnt); j:=aFnt^; inc(aFnt); k:=aFnt^;
             highlightClash;
             printw(XML_TEACHERS.tecode[j,0]);
             x:=PrntTabs[1]; fcolor(cpSub); printw(SubCode[i]);
             x:=PrntTabs[2]; fcolor(cpRoom); printw(XML_TEACHERS.tecode[k,1]);
             x:=PrntTabs[3]; fcolor(cpFac); printw(dayname[D]);
             x:=PrntTabs[4]; printw(TimeSlotName[D,P]);
             x:=PrntTabs[5]; printw(yearname[y1]);
             x:=PrntTabs[6];
             aStr:=trim(ClassCode[ClassShown[L,y1]]);
             if (aStr<>'') then printw(aStr)
              else printw('Level '+inttostr(L));
             newline;
            end; {if ((abFnt^ and B)=B)}
         end; {for L}
    end; {all times}
   newline;
   printCustomAddon;
  finally
   PrintTclashWin.Free;
  end;
end;

procedure TOutTclashWin.head;
begin
 printw('Teacher Clashes');
 if XML_DISPLAY.tcCurPeriodOnly then printw(' - for '+day[nd]+':'+inttostr(np+1));
 newline; newline;
 if lcount=0 then
 begin
  printw(' No clashes. ');
  newline;
  exit;
 end;
 if XML_DISPLAY.tcCurPeriodOnly then
   printLine(['Teacher',yeartitle,'Subject','Room','Level/Class'])
 else
  printLine(['Teacher','Subject','Room','Day','Time',yeartitle,'Level/Class']);
end;

procedure TeacherClashestext;
var
 D,P,y1,l:  integer;
 i,j,k:        integer;
 astr:            string;
 aFnt,cFnt:      tpintpoint;
 abFnt,cbFnt:         tpbytepoint;
begin
 OutTclashWin:=TOutTclashWin.create;
 with OutTclashWin do
  try
   Header;
   if Lcount=0 then exit;
   if XML_DISPLAY.tcCurPeriodOnly then
    begin    {current period only}
     for y1:=0 to years_minus_1 do
      for l:=1 to level[y1] do
       begin
        cFnt:=FNT(nd,np,y1,l,0);
        cbFnt:=FNTbyte(nd,np,y1,l,7);
        if ((cbFnt^ and 8)=8) then
         begin
          i:=cFnt^; inc(cFnt); j:=cFnt^; inc(cFnt); k:=cFnt^;
          aStr:=trim(ClassCode[ClassShown[L,y1]]);
          if (aStr='') then astr:='Level '+inttostr(L);
          printLine([XML_TEACHERS.tecode[j,0],yearname[y1],SubCode[i],XML_TEACHERS.tecode[k,1],aStr]);
         end;
        end; {for l}
    end {current period}
   else
    begin {all times}
     for D:=0 to (days-1) do
      for P:=0 to (tlimit[D]-1) do
       if Tclash[D,P]<>0 then
        for y1:=0 to years_minus_1 do
         for L:=1 to level[y1] do
          begin
           aFnt:=FNT(D,P,y1,L,0);
           abFnt:=FNTbyte(D,P,y1,L,7);
           if ((abFnt^ and 8)=8) then
            begin
             i:=aFnt^; inc(aFnt); j:=aFnt^; inc(aFnt); k:=aFnt^;
             aStr:=trim(ClassCode[ClassShown[L,y1]]);
             if (aStr='') then astr:='Level '+inttostr(L);
             printLine([XML_TEACHERS.tecode[j,0],SubCode[i],XML_TEACHERS.tecode[k,1],dayname[D],
                 TimeSlotName[D,P],yearname[y1],astr]);
            end; {if ((abFnt^ and B)=B)}
         end; {for L}
    end; {all times}
   newline;
   printCustomAddon;
  finally
   OutTclashWin.Free;
  end;

end;



end.
