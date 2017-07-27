Unit Tcinfo;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, StdCtrls,ClassDefs,TimeChartGlobals, ExtCtrls, NiceGrid, XML.UTILS,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.STUDENTS;

type
  TInfoWin = class(TDrawWin)
    PopupMenu1: TPopupMenu;
    Print1: TMenuItem;
    PrintSetup1: TMenuItem;
    Copy1: TMenuItem;
    lblFile: TLabel;
    lblVersion: TLabel;
    lblDateStamp: TLabel;
    lblTotalStudents: TLabel;
    lblDays: TLabel;
    lblTimeSlots: TLabel;
    lblYears: TLabel;
    edtFile: TEdit;
    edtVersion: TEdit;
    edtDateStamp: TEdit;
    edtTotalStudents: TEdit;
    edtDays: TEdit;
    edtCustom: TEdit;
    edtYears: TEdit;
    lblTodayDate: TLabel;
    lblSubjects: TLabel;
    lblHouses: TLabel;
    lblFaculties: TLabel;
    edtSubjects: TEdit;
    edtHouses: TEdit;
    edtFaculties: TEdit;
    lblWorksheetBlocks: TLabel;
    edtWorksheetBlocks: TEdit;
    lblBlocks: TLabel;
    edtBlocks: TEdit;
    lblCustom: TLabel;
    edtTimeSlots: TEdit;
    lblDataDirectory: TLabel;
    edtDataDirectory: TEdit;
    edtSupportExpiry: TEdit;
    lblSupportExpiry: TLabel;
    lblTeachers: TLabel;
    lblRooms: TLabel;
    lblClasses: TLabel;
    edtTeachers: TEdit;
    edtRooms: TEdit;
    edtClasses: TEdit;
    grdInfo: TNiceGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  protected
    procedure SetTabs; override;
  private
    numtab:   array[0..nmbrYears] of smallint;
    procedure RefreshDetails;
  end;

procedure infoPrint;
procedure infoTextExp;

var
  InfoWin: TInfoWin;

implementation
 Uses tcommon,StCommon,printers,main,tcommon2;
{$R *.DFM}

 type TPrintInfoWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
  private
   prntNumtab:   array[0..nmbrYears] of smallint;
 end;

 type TOutInfoWin=class(TOutputwin)
  public
   procedure head; override;
 end;

var
 PrintInfoWin:    TPrintInfoWin;
 OutInfoWin:      TOutInfoWin;
 TotalStudents:        integer;

procedure TInfoWin.SetTabs;
//var
 //temp,i,j:      integer;
begin
 {caption:='Info - '+School;
 SetLength(Tabs,6);
 MaxTab(1,canvas.textwidth('FormFeed: OFF  '),DateStr+'  ');
 MaxTab(2,0,'Date Stamp: YES    ');
 Tabs[3]:=canvas.textwidth('Levels ( 1-66 ) 00000  ');

 Tabs[4]:=canvas.textwidth('000000');
 i:=fwYearname+2*blankwidth; if i>Tabs[4] then Tabs[4]:=i;
 numtab[0]:=Tabs[3];
 for i:=1 to yr do numtab[i]:=numtab[i-1] + Tabs[4];

 getYearStats;
 totalstudents:=0;
 for i:=0 to yr do inc(totalstudents,yearstat[i].numstud);
 temp:= Tabs[2]+canvas.textwidth('Total Students: 999');
 if numtab[yr]>temp then temp:=numtab[yr];
 i:=canvas.textwidth('Blocks (none)   '+blockfile);
 j:=canvas.textwidth('Blocks (none)   '+blockday);
 if j>i then i:=j;
 j:=canvas.textwidth('    Custom File: '+custom+'   (99 entries)');
 inc(i,j);
 if i>temp then temp:=i;
 MaxW:=temp+Hmargin*2;
 MaxH:=20*txtHeight;}
end;

procedure TInfoWin.FormCreate(Sender: TObject);
begin
  setWindowDefaults(self,wnInfo);
end;

procedure TInfoWin.FormPaint(Sender: TObject);
var
 temp:          integer;
 s:            string;
 i:            integer;

{procedure print2(a,b:string);
begin
  fcolor(cpInfoHead);
  printwl(a);
  fcolor(cpInfo);
  printwl(b);
end;}

begin
  RefreshDetails;
 (*fcolor(cpInfo);
 printw(DateStr);
 x:=Tabs[1]; print2('File: ',ttfile);
 x:=Tabs[2]; print2('Version: ',ttVersion);
 newline;
 if datestamp then s:='ON' else s:='OFF';
 x:=Tabs[1]; print2('Date Stamp: ',s);
 x:=Tabs[2]; print2('Total Students: ',inttostr(TotalStudents));
 newline; newline;
 print2('Days=',inttostr(days));
 x:=Tabs[1]; print2('Time Slots=',inttostr(periods));
 x:=Tabs[2]; print2(yeartitle+'s=',inttostr(years));
 newline; newline;
 print2('Subjects: ',inttostr(codeCount[0]));
 x:=Tabs[1]; print2('Houses: ',inttostr(HouseCount));
 x:=Tabs[2]; print2('Faculties: ',inttostr(facNum));
 newline;
 print2('Teachers: ',inttostr(codeCount[1]));
 x:=Tabs[1]; print2('Rooms: ',inttostr(codeCount[2]));
 x:=Tabs[2]; print2('Classes: ',inttostr(Classnum));
 newline;
 print2('Worksheet Blocks: ',inttostr(wsBlocks));
 newline; newline;

 fcolor(cpInfoHead); printw(yearTitle);
 for i:=0 to yr do
 begin
  temp:=canvas.textwidth(yearname[i]);
  x:=numtab[i]-temp;
  printw(yearname[i]);
 end;
 newline; fcolor(cpInfoHead);
 printw('Levels (1-66)');  fcolor(cpInfo);
 for i:=0 to yr do
 begin
  s:=inttostr(Level[i]);
  x:=numtab[i]-canvas.textwidth(s);
  printw(s);
 end;
 newline; fcolor(cpInfoHead);
 printw('Blocks');  fcolor(cpInfo);
 for i:=0 to yr do
 begin
  s:=inttostr(Blocks[i]);
  x:=numtab[i]-canvas.textwidth(s);
  printw(s);
 end;
{studs}
 newline;  fcolor(cpInfoHead);
 printw('Students');  fcolor(cpDoubleBlock);
 for i:=0 to yr do
 begin
  s:=inttostr(yearstat[i].numstud);
  x:=numtab[i]-canvas.textwidth(s);
  printw(s);
 end;
 newline;  fcolor(cpInfoHead);
// printw('Males');
 printw(genderLong[0]); fcolor(cpInfo);
 for i:=0 to yr do
 begin
  s:=inttostr(yearstat[i].malenum);
  x:=numtab[i]-canvas.textwidth(s);
  printw(s);
 end;
 newline;  fcolor(cpInfoHead);
// printw('Females');
 printw(genderLong[1]); fcolor(cpInfo);
 for i:=0 to yr do
 begin
  s:=inttostr(yearstat[i].femalenum);
  x:=numtab[i]-canvas.textwidth(s);
  printw(s);
 end;
 newline; newline;  fcolor(cpInfoHead);
 x:=Tabs[1];
 Case BlockLoad of
   0: s:='(None)';
   1: s:='File: '+Blockfile;
   2: s:='from '+Blockday;
   3: s:='(New)'
 end;
 print2('Blocks ',s);
 if gotcustom then
 begin
  if trim(custom)='' then s:='(New)' else s:=custom;
  print2('    Custom ',s+'   ('+inttostr(addnum)+' entries)')
 end
 else
  print2('    Custom ','(None)');
 newline;
 print2('Data: ',datadir);
 s:=FormatDateTime(' d mmmm yyyy  ', SupportExpiryKeyCheckDate);
 newline;print2('Support expiry: ',s);*)
end;

procedure TInfoWin.RefreshDetails;
var
  lStr: string;
  i: Integer;
  lWidth: Integer;
  lNewWidth: Integer;
begin
  lblTodayDate.Caption := DateStr;
  edtFile.Text := FileNames.LoadedTimeTable;
  edtVersion.Text := Version;
  if XML_DISPLAY.datestamp then lStr := 'ON' else lStr := 'OFF';
  edtDateStamp.Text := lStr;
  TotalStudents := 0;
  for i := 0 to years_minus_1 do
    Inc(TotalStudents, YearStat[i].numstud);
  edtTotalStudents.Text := IntToStr(TotalStudents);
  edtDays.Text := IntToStr(days);
  edtTimeSlots.Text := IntToStr(periods);
  edtYears.Text := IntToStr(years);
  edtSubjects.Text := IntToStr(CodeCount[0]);
  edtHouses.Text := IntToStr(HouseCount);
  edtFaculties.Text := IntToStr(facNum);
  edtTeachers.Text := IntToStr(CodeCount[1]);
  edtRooms.Text := IntToStr(CodeCount[2]);
  edtClasses.Text := IntToStr(Classnum);
  edtWorksheetBlocks.Text := IntToStr(wsBlocks);

  grdInfo.Clear;
  grdInfo.ColCount := years_minus_1 + 1;
  grdInfo.RowCount := 6;
  grdInfo.Font.Color := FontColorPair[cpInfo, 1];
  grdInfo[0, 0] := YearTitle;
  lWidth := 0;
  for i := 0 to years_minus_1 do
  begin
    grdInfo[i, 0] := YearName[i];
    grdInfo[i, 1] := IntToStr(Level[i]);
    grdInfo[i, 2] := IntToStr(Blocks[i]);
    grdInfo[i, 3] := IntToStr(YearStat[i].NumStud);
    grdInfo[i, 4] := IntToStr(yearstat[i].MaleNum);
    grdInfo[i, 5] := IntToStr(YearStat[i].FemaleNum);
    lNewWidth := Canvas.TextWidth(YearName[i]);
    if lNewWidth > lWidth then
      lWidth := lNewWidth;
  end;
  grdInfo.DefColWidth := lWidth;

  case BlockLoad of
   0: lStr := '(None)';
   1: lStr := 'File: '+Blockfile;
   2: lStr := 'from '+Blockday;
   3: lStr := '(New)'
  end;
  edtBlocks.Text := lStr;
  if gotcustom then
  begin
    if Trim(custom) = '' then lStr :='(New)' else lStr := custom;
    edtCustom.Text := lStr + '   (' + IntToStr(addnum) + ' entries)';
  end
  else
  edtCustom.Text := '(None)';
  edtDataDirectory.Text := Directories.DataDir;
  lStr := FormatDateTime(' d mmmm yyyy  ', SupportExpiryKeyCheckDate);
  edtSupportExpiry.Text := lStr;
end;

procedure TInfoWin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
end;

{-------============-----------  P R I N T I N G      ROUTINES -=-=-=-=-===============------------------------------}

procedure TPrintInfoWin.head;
begin
 UnderlineOn;
 printwl('Information');
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;

procedure TPrintInfoWin.SetTabs;
var
 i:      integer;
begin
 SetLength(PrntTabs,6);
 MaxTab(1,PrintCanvas.textwidth('FormFeed: OFF  '),DateStr+'  ');
 MaxTab(2,0,'Date Stamp: YES    ');
 PrntTabs[3]:=PrintCanvas.textwidth('Levels ( 1-66 ) 00000  ');
 PrntTabs[4]:=PrintCanvas.textwidth('000000');
 i:=fwYearname+2*blankwidth; if i>PrntTabs[4] then PrntTabs[4]:=i;
 Prntnumtab[0]:=PrntTabs[3];
 for i:=1 to years_minus_1 do Prntnumtab[i]:=Prntnumtab[i-1] + PrntTabs[4];
end;

procedure infoPrint;
var
 i,temp:        integer;
 s:            string;

  procedure print2(a,b:string);
  begin
    PrintInfoWin.fcolor(cpNormal);     {was cpInfoHead }
    PrintInfoWin.printwl(a);
    PrintInfoWin.fcolor(cpNormal);     {was cpInfo }
    PrintInfoWin.printwl(b);
  end;

begin
 PrintInfoWin:=TPrintInfoWin.create;
 with PrintInfoWin do
  try
   PrintHead;
   fcolor(cpnormal); {was cpInfo}
   x:=PrntTabs[1]; print2('File: ',FileNames.LoadedTimeTable);
   x:=PrntTabs[2]; print2('Version: ',Version);
   newline;
   if XML_DISPLAY.datestamp then s:='ON' else s:='OFF';
   x:=PrntTabs[1]; print2('Date Stamp: ',s);
   x:=PrntTabs[2]; print2('Total Students: ',inttostr(TotalStudents));
   newline; newline;
   print2('Days=',inttostr(days));
   x:=PrntTabs[1]; print2('Time Slots=',inttostr(periods));
   x:=PrntTabs[2]; print2(yeartitle+'s=',inttostr(years));
   newline; newline;
   print2('Subjects: ',inttostr(codeCount[0]));
   x:=PrntTabs[1]; print2('Houses: ',inttostr(HouseCount));
   x:=PrntTabs[2]; print2('Faculties: ',inttostr(facNum));
   newline;
   print2('Teachers: ',inttostr(codeCount[1]));
   x:=PrntTabs[1]; print2('Rooms: ',inttostr(codeCount[2]));
   x:=PrntTabs[2]; print2('Classes: ',inttostr(Classnum));
   newline;
   print2('Worksheet Blocks: ',inttostr(wsBlocks));
   newline; newline;

   (*old code
   printw(yearTitle);
   for i:=0 to yr do
   begin
    temp:=Printcanvas.textwidth(yearname[i]);
    x:=PrntNumtab[i]-temp+PrntHmargin;
    printw(yearname[i]);
   end;
   newline;
   printw('Levels (1-66)');
   for i:=0 to yr do
   begin
    s:=inttostr(Level[i]);
    x:=PrntNumtab[i]-Printcanvas.textwidth(s)+PrntHmargin;
    printw(s);
   end;
   newline;
   printw('Blocks');
   for i:=0 to yr do
   begin
    s:=inttostr(Blocks[i]);
    x:=PrntNumtab[i]-Printcanvas.textwidth(s)+PrntHmargin;
    printw(s);
   end;

  {studs}
   newline;
   printw('Students');
   for i:=0 to yr do
   begin
    s:=inttostr(yearstat[i].numstud);
    x:=PrntNumtab[i]-Printcanvas.textwidth(s)+PrntHmargin;
    printw(s);
   end;
   newline;
   printw(genderLong[0]);   //printw('Males');
   for i:=0 to yr do
   begin
    s:=inttostr(yearstat[i].malenum);
    x:=PrntNumtab[i]-Printcanvas.textwidth(s)+PrntHmargin;
    printw(s);
   end;
   newline;
   printw(genderLong[1]);  //printw('Females');
   for i:=0 to yr do
   begin
    s:=inttostr(yearstat[i].femalenum);
    x:=PrntNumtab[i]-Printcanvas.textwidth(s)+PrntHmargin;
    printw(s);
   end;*)





    //New Code
   printw(yearTitle);
   for i:=0 to years_minus_1 do
   begin
    temp:=Printcanvas.textwidth(yearname[i]);
    x:=PrntNumtab[i]-temp+PrntHmargin;
    printw(yearname[i]);
   end;
   newline;
   printw('Levels (1-66)');
   for i:=0 to years_minus_1 do
   begin
    s:=inttostr(Level[i]);
    x:=PrntNumtab[i]-Printcanvas.textwidth(s)+PrntHmargin;
    printw(s);
   end;
   newline;
   printw('Blocks');
   for i:=0 to years_minus_1 do
   begin
    s:=inttostr(Blocks[i]);
    x:=PrntNumtab[i]-Printcanvas.textwidth(s)+PrntHmargin;
    printw(s);
   end;

  {studs}
   newline;
   printw('Students');
   for i:=0 to years_minus_1 do
   begin
    s:=inttostr(yearstat[i].numstud);
    x:=PrntNumtab[i]-Printcanvas.textwidth(s)+PrntHmargin;
    printw(s);
   end;
   newline;
   printw(genderLong[0]);   //printw('Males');
   for i:=0 to years_minus_1 do
   begin
    s:=inttostr(yearstat[i].malenum);
    x:=PrntNumtab[i]-Printcanvas.textwidth(s)+PrntHmargin;
    printw(s);
   end;
   newline;
   printw(genderLong[1]);  //printw('Females');
   for i:=0 to years_minus_1 do
   begin
    s:=inttostr(yearstat[i].femalenum);
    x:=PrntNumtab[i]-Printcanvas.textwidth(s)+PrntHmargin;
    printw(s);
   end;
    //New code end



   newline; newline;
   x:=PrntTabs[1];
   Case BlockLoad of
     0: s:='(None)';
     1: s:='File: '+Blockfile;
     2: s:='from '+Blockday;
     3: s:='(New)'
   end;
   print2('Blocks ',s);
   if gotcustom then
   begin
    if trim(custom)='' then s:='(New)' else s:=custom;
    print2('    Custom ',s+'   ('+inttostr(addnum)+' entries)')
   end
   else
    print2('    Custom ','(None)');
   newline;
   print2('Data: ',Directories.datadir);
   s:=FormatDateTime(' d mmmm yyyy  ', SupportExpiryKeyCheckDate);
   newline;print2('Support expiry: ',s);
   newline;
   printCustomAddon;
  finally
   PrintInfoWin.Free;
  end;
end;

// Text File Output


procedure TOutInfoWin.head;
begin
 printw('Information');
 newline; newline;
end;


procedure infoTextExp;
var
 i:        integer;
 s:            string;
begin
 OutInfoWin:=TOutInfoWin.create;
 with OutInfoWin do
  try
   Header;
   printw(DateStr);
   printc('File:'); printc(FileNames.LoadedTimeTable);
   printc('Version:'); printc(Version);
   newline;
   if XML_DISPLAY.datestamp then s:='ON' else s:='OFF';
   printc('Date Stamp:'); printc(s);
   printc('Total Students:'); printc(inttostr(TotalStudents));
   newline; newline;
   printw('Days='); printc(inttostr(days));
   printc('Time Slots='); printc(inttostr(periods));
   printc(yeartitle+'s='); printc(inttostr(years));
   newline; newline;
   printw('Subjects:'); printc(inttostr(codeCount[0]));
   printc('Houses:'); printc(inttostr(HouseCount));
   printc('Faculties:'); printc(inttostr(facNum));
   newline;
   printw('Teachers:'); printc(inttostr(codeCount[1]));
   printc('Rooms:'); printc(inttostr(codeCount[2]));
   printc('Classes:'); printc(inttostr(classnum));
   newline;
   printw('Worksheet Blocks:'); printc(inttostr(wsBlocks));
   newline; newline;

   printw(yearTitle);
   for i:=0 to years_minus_1 do printc(yearname[i]);
   newline;
   printw('Levels (1-66)');
   for i:=0 to years_minus_1 do begin s:=inttostr(Level[i]); printc(s); end;
   newline;
   printw('Blocks');
   for i:=0 to years_minus_1 do begin s:=inttostr(Blocks[i]); printc(s); end;

  {studs}
   newline;
   printw('Students');
   for i:=0 to years_minus_1 do begin s:=inttostr(yearstat[i].numstud); printc(s); end;
   newline;
   printw(genderLong[0]);   //printw('Males');
   for i:=0 to years_minus_1 do begin s:=inttostr(yearstat[i].malenum); printc(s); end;
   newline;
   printw(genderLong[1]);   //printw('Females');
   for i:=0 to years_minus_1 do begin s:=inttostr(yearstat[i].femalenum); printc(s); end;
   newline; newline;
   Case BlockLoad of
     0: s:='(None)';
     1: s:='File: '+Blockfile;
     2: s:='from '+Blockday;
     3: s:='(New)'
   end;
   printc('Blocks'); printc(s);
   if gotcustom then
    begin
     if trim(custom)='' then s:='(New)' else s:=custom;
     printc('Custom'); printc(s+'   ('+inttostr(addnum)+' entries)');
    end
   else
    printc('Custom'); printc('(None)');
   newline;
   printw('Data:'); printc(Directories.datadir);
   s:=FormatDateTime(' d mmmm yyyy  ', SupportExpiryKeyCheckDate);
   newline;printw('Support expiry:'); printc(s);
   printCustomAddon;
  finally
   OutInfoWin.Free;
  end;

end;



end.
