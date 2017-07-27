unit TimesWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls,TimeChartGlobals,ClassDefs,printers, GlobalToTcAndTcextra;

type
  TTimesWindow = class(TDrawWin)
    PopupMenu1: TPopupMenu;
    Change2: TMenuItem;
    N7: TMenuItem;
    Print2: TMenuItem;
    PrintSetup2: TMenuItem;
    Exportastextfile1: TMenuItem;
    MainMenu1: TMainMenu;
    Codes1: TMenuItem;
    SelectCode1: TMenuItem;
    Subject1: TMenuItem;
    Teacher1: TMenuItem;
    Room1: TMenuItem;
    Class1: TMenuItem;
    Faculty1: TMenuItem;
    House1: TMenuItem;
    Times1: TMenuItem;
    N5: TMenuItem;
    Change1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Change1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Codes1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  protected
    procedure SetTabs; override;
  end;

 procedure TimesPrint;
 procedure TimesOut;


 var
  TimesWindow: TTimesWindow;

implementation
 uses main,tcommon,tcommon2,editTime,tcommon5;
{$R *.dfm}
     
 type TPrintTimesWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
  private
   procedure PrintBody;
 end;

 type TOutTimesWin=class(TOutPutWin)
  public
   procedure head; override;
 end;


var
 PrintTimesWin:    TPrintTimesWin;
 OutTimesWin:      TOutTimesWin;

procedure TTimesWindow.setTabs;
 var
 tab1:   smallint;
begin
 SetLength(Tabs,10);
 DayGroupCalc; 
 MaxTab(1,canvas.textwidth('Time Slot '),inttostr(periods));
 MaxTab(2,fwPeriodname,'Name ');
 MaxTab(3,0,'Code ');
 MaxTab(4,fwTimeUnit,'Allotments ');
 tab1:=canvas.textwidth('12:59 PM ');
 MaxTab(5,tab1,'Start time  ');
 MaxTab(6,tab1,'End time  ');

 Tabs[7]:=Tabs[3]+canvas.TextWidth(TslotUnitName[TslotUnit]);
 Tabs[8]:=Tabs[4]+canvas.TextWidth('Start time');
 Tabs[9]:=Tabs[5]+canvas.TextWidth('End time');
 maxW:=Hmargin+Tabs[6];
 maxH:=txtheight*(2+numDayGroups*(5+periods));
end;



procedure TTimesWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure TTimesWindow.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnTimes);
end;


procedure TPrintTimesWin.SetTabs;
var
 tab1:   smallint;
begin
 SetLength(PrntTabs,10);
 MaxTab(1,Printcanvas.textwidth('Time Slot '),inttostr(periods));
 MaxTab(2,fwprntPeriodname,'Name ');
 MaxTab(3,0,'Code ');
 MaxTab(4,PrintCanvas.TextWidth('9999.99'),'Allotments ');
 tab1:=Printcanvas.textwidth('12:59 PM ');
 MaxTab(5,tab1,'Start time  ');
 MaxTab(6,tab1,'End time  ');

 PrntTabs[7]:=PrntTabs[3]+Printcanvas.TextWidth(TslotUnitName[TslotUnit]);
 PrntTabs[8]:=PrntTabs[4]+Printcanvas.TextWidth('Start time');
 PrntTabs[9]:=PrntTabs[5]+Printcanvas.TextWidth('End time');
end;


procedure TPrintTimesWin.head;
begin
 UnderlineOn;
 printwl('Time Allotments');
 printw(PageCount);
 x:=0; y:=y+prnttxtheight;
 UnderlineOff;
end;

procedure TPrintTimesWin.PrintBody;
var
 i,j,dayuse: integer;
 tmpstr:               string;

  procedure rAlign(tnum:integer);
  begin
   x:=PrntTabs[tnum]-PrintCanvas.TextWidth(tmpstr); printw(tmpstr);
  end;

begin
 codeColor:=cpClass;
 {Headings}
 tmpstr:='All '+Yeartitle+'s';
 printw2('Times for: ',tmpstr); newline;
 newline;  fcolor(cpNormal);
 for i:=1 to NumDayGroups do
  begin
   dayuse:=dg[i,1];
   if NumDayGroups=1 then printw('All Days');
   if NumDayGroups=days then printw(dayname[i-1]);
   if (NumDayGroups>1) and (NumDayGroups<days) then
    begin
     tmpstr:='';
     for j:=1 to dg[i,0] do
       begin
          tmpstr:=tmpstr+dayname[dg[i,j]];
          if (dg[i,0]>1) and (j<dg[i,0]) then tmpstr:=tmpstr+', ';
        end;
     printw2('Day Group '+inttostr(i)+': ',tmpstr);
    end;
   newline;  newline;   fcolor(cpNormal);

   printw('Time Slot');
   x:=PrntTabs[1];  printw('Name');
   x:=PrntTabs[2];  printw('Code');
   x:=PrntTabs[3];  printw(TslotUnitName[TslotUnit]);
   x:=PrntTabs[4];  printw('Start Time');
   x:=PrntTabs[5];  printw('End Time');
   newline;

   for j:=0 to Tlimit[dayuse]-1 do
    begin
     fcolor(codecolor);
     x:=PrintCanvas.textwidth(inttostr(periods))
                         -PrintCanvas.textwidth(inttostr(j));
     printw(inttostr(j+1)+':');
     x:=PrntTabs[1]; printw(TimeSlotName[dayuse,j]);
     x:=PrntTabs[2]; printw(' '+tscode[dayuse,j]);
     str(tsAllot[dayuse,j]:SlotUnitMain:SlotUnitDec,tmpstr);
     rAlign(7);
     tmpstr:=TimeToStr(tsStart[dayuse,j]); rAlign(8);
     tmpstr:=TimeToStr(tsEnd[dayuse,j]); rAlign(9);
     newline;
    end;
   newline;newline;
  end; {for i}

end;


procedure TimesPrint;
begin
 PrintTimesWin:=TPrintTimesWin.Create;
 with PrintTimesWin do
  try
   PrintHead;
   codeColor:=cpClass;   fcolor(cpNormal);
   x:=0;  y:=prntVmargin;
   header;
   newline;
   PrintBody;
   newline;
   printCustomAddon;
  finally; {with PrintTeWin}
   PrintTimesWin.Free;
  end;
end; {main print}


procedure TOutTimesWin.head;
begin
 printLine(['Time Allotments']);
end;



procedure TimesOut;
var
 i,j,dayuse: integer;
 tmpstr:               string;
begin
 OutTimesWin:=TOutTimesWin.Create;
 with OutTimesWin do
  try
   Header;
   PrintLine(['Times for: All '+Yeartitle+'s']);
   for i:=1 to NumDayGroups do
    begin
     dayuse:=dg[i,1];
     if NumDayGroups=1 then printw('All Days');
     if NumDayGroups=days then printw(dayname[i-1]);
     if (NumDayGroups>1) and (NumDayGroups<days) then
      begin
       tmpstr:='';
       for j:=1 to dg[i,0] do
         begin
            tmpstr:=tmpstr+dayname[dg[i,j]];
            if (dg[i,0]>1) and (j<dg[i,0]) then tmpstr:=tmpstr+', ';
          end;
       printLine(['Day Group '+inttostr(i)+': '+tmpstr]);
      end;
     newline;

     printLine(['Time Slot','Name','Code',TslotUnitName[TslotUnit],
         'Start Time','End Time']);

     for j:=0 to Tlimit[dayuse]-1 do
      begin
       printw(inttostr(j+1)+':');
       printc(TimeSlotName[dayuse,j]);
       printc(tscode[dayuse,j]);
       str(tsAllot[dayuse,j]:SlotUnitMain:SlotUnitDec,tmpstr);
       printc(tmpstr);
       tmpstr:=TimeToStr(tsStart[dayuse,j]); printc(tmpstr);
       tmpstr:=TimeToStr(tsEnd[dayuse,j]); printc(tmpstr);
       newline;
      end;
     newline;
    end; {for i}

   newline;
   printCustomAddon;
  finally; {with OutTeWin}
   OutTimesWin.Free;
  end;
end; {main text output}


procedure TTimesWindow.Change1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   AllotDlg:=TAllotDlg.create(self); {allocate dlg}
   AllotDlg.showmodal;
   AllotDlg.free;  {release dlg}
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TTimesWindow.PopupMenu1Popup(Sender: TObject);
begin
 change2.Visible:=(usrPasslevel>utGen);
 N7.Visible:=(usrPasslevel>utGen);
end;

procedure TTimesWindow.Codes1Click(Sender: TObject);
begin
 TickCodeSubMenu(SelectCode1);
 change1.Visible:=(usrPasslevel>utGen);
 N5.Visible:=(usrPasslevel>utGen);
end;

procedure TTimesWindow.FormPaint(Sender: TObject);
var
 i,j,dayuse: integer;
 tmpstr:               string;

  procedure rAlign(tnum:integer);
  begin
   x:=Tabs[tnum]-canvas.TextWidth(tmpstr); printw(tmpstr);
  end;

begin
 codeColor:=cpClass;
 longtimeformat:='h:mmam/pm';
 {Headings}
 tmpstr:='All '+Yeartitle+'s';
 printw2('Times for: ',tmpstr); newline;
 newline;  fcolor(cpNormal);
 for i:=1 to NumDayGroups do
  begin
   dayuse:=dg[i,1];
   if NumDayGroups=1 then printw('All Days');
   if NumDayGroups=days then printw(dayname[i-1]);
   if (NumDayGroups>1) and (NumDayGroups<days) then
    begin
     tmpstr:='';
     for j:=1 to dg[i,0] do
       begin
          tmpstr:=tmpstr+dayname[dg[i,j]];
          if (dg[i,0]>1) and (j<dg[i,0]) then tmpstr:=tmpstr+', ';
        end;
     printw2('Day Group '+inttostr(i)+': ',tmpstr);
    end;
   newline;  newline;   fcolor(cpNormal);

   printw('Time Slot');
   x:=Tabs[1];  printw('Name');
   x:=Tabs[2];  printw('Code');
   x:=Tabs[3];  printw(TslotUnitName[TslotUnit]);
   x:=Tabs[4];  printw('Start Time');
   x:=Tabs[5];  printw('End Time');
   newline;
   fcolor(codecolor);

   for j:=0 to Tlimit[dayuse]-1 do
    begin
     if y>bottomCutoff then exit; {no printing past range}
     x:=canvas.textwidth(inttostr(periods))
                         -canvas.textwidth(inttostr(j));
     printw(inttostr(j+1)+':');
     x:=Tabs[1]; printw(TimeSlotName[dayuse,j]);
     x:=Tabs[2]; printw(' '+tscode[dayuse,j]);
     str(tsAllot[dayuse,j]:SlotUnitMain:SlotUnitDec,tmpstr);
     rAlign(7);
     tmpstr:=TimeToStr(tsStart[dayuse,j]); rAlign(8);
     tmpstr:=TimeToStr(tsEnd[dayuse,j]); rAlign(9);
     newline;
    end;
   newline;newline;
  end; {for i}

end;

end.
