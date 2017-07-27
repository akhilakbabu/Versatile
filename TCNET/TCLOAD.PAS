unit tcload;

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ExtCtrls, Dialogs, SysUtils, Messages, TimeChartGlobals, XML.TTABLE, XML.UTILS, GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

type
  TAbout = class(TForm)
    Panel1     : TPanel;
    ProductName: TLabel;
    VersionLabel: TLabel;
    Copyright  : TLabel;
    loadLabel  : TLabel;
    SchoolName : TLabel;
    Timer1     : TTimer;
    Image1     : TImage;
    lblExpiry: TLabel;
    OKbutton: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKbuttonOLDClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    procedure SetTitle;
    procedure GetDirectories;
  public
    function RefreshObjects: Boolean;
    function RefreshStudents: Boolean;
    function RefreshSubjects: Boolean;
    function RefreshTags: Boolean;
    procedure DEETdumpOut(const pExcludeNonTtabled: Boolean = False; const pCases21Spec: Boolean = true);
    procedure SetupApp;
  end;

procedure getTTable;
procedure firstLoad;
procedure saveTTable;
procedure initBlockdata;
procedure getTeacherCodes;
procedure AllotLoad;
procedure getSubjectCodes;
procedure getRoomCodes;
procedure HouseLoad;
procedure LoadRollClasses;
procedure getFaculty;
procedure LoadDisplayFile(displayFile:string);
procedure winShow;
procedure StudentID2Load(year:smallint);
procedure StudentID2LoadNew(year:smallint);
procedure getCodes;
procedure LoadWinDisplay;
procedure BuildSTUDNew;

var
  About: TAbout;


implementation

uses
  tcommon,tcommon2, main, tcinfo, Ttable, Tcgetdir, hints, stcommon, tttoolbarwin,
  gentool,tcommon5,CustomOutput, uAMGTeacher, uAMGSubject, WebUpdate, dateutils,
  TTundo,ehshhapi,Worksheet, uAMGConst, uAMGCommon, uAMGClassSubject, uAMGStudent,
  SplitSubjectsConvertor, LoadProgress, MRUList, XML.TTABLE.TTW;

{$R *.DFM}

var
  i         : smallint;
  timerCount: smallint;

const
  timerDelay = 4; {seconds}


// introducing new keyfile encryptstr since keygen was mistakenly sent out early in 2009 (at least since beginning of feb, no exact idea how long it had been going out.
//
// will perform dual check for about 12 months, then turn off the old keyfile check and we will be sending out the new keyfiles from now (April 14 2009)
//
// from about the end of april 2010 we will REMOVE the OLDkeyfilecheck routine code and any keyfiles generated with the mistakenly sent out keygens will no longer work


function KeyFileValidationCheck:wordbool;
var
 AppReadStr:        shortstring;
 VersionReadStr:     shortstring;
 SupportExpiry,ExpiryYear:  shortstring;
 ExpiryMonth,ExpiryDay: shortstring;
 Source: shortstring;
 i: integer;
 zz,yy: integer;
 ExpiredSupportMsg: string;
 tmpStr,tmpstr2: string;
 Failed: boolean;
begin
 Result:=false;
 Source:=GetEncryptStr('TCNET.DAT','©Ncevy 2009ª¹°¿ NZVT FLFGRZF¶@±GP6.0 Argjbex¾´·ºß');
 if Source='' then
  begin
   School := 'Application Validation - FAILED!' + #10#13 + 'Re-install Time Chart from your Setup.exe file.';
   exit;
  end;
 i:=pos(endline,Source);   {get school name}
 School:=copy(Source,1,i-1);

 //#118 Check the school name for a possible trial licence and exit if found
 //     The assumption here is that this routine is not called by the TRIAL version of the exe
 //     also skip this for the DEBUG version and make sure DEBUG versions stay internal
 //     ie. RELEASE version only
 Failed := false;
 {$IfDef RELEASE}
 if (Pos('AMIG', School)>0) or (Pos('Trial',School)>0) then begin
   ExpiredSupportMsg := 'Your Trial Licence does not allow upgrades.' + endline;
//   ExpiredSupportMsg := ExpiredSupportMsg+'This update of Time Chart is more recent ' + endline;
//   ExpiredSupportMsg := ExpiredSupportMsg+'Please try to re-install Time Chart from the latest CD you received from AMIG SYSTEMS.' + endline + 'If the issue persists please contact AMIG SYSTEMS to renew the Time Chart Support Plan';
   messagedlg(ExpiredSupportMsg, mtError, [mbOK], 0);
   Failed := true;
 end;
 {$EndIf}

//check application & version
 AppReadStr:=copy(Source,i+2,23);
 VersionReadStr:=copy(Source,i+27,2);
 SupportExpiry:=copy(Source,i+31,length(Source));
 TmpStr:=SupportExpiry;

 ExpiryYear:=copy(TmpStr,1,4);
 TmpStr:=copy(TmpStr,6,length(TmpStr));
 zz:=pos('/',TmpStr);
 ExpiryMonth:=copy(TmpStr,1,zz-1);
 yy:=pos('\',TmpStr);
 ExpiryDay:=copy(TmpStr,zz+1,(yy-(zz+1)));
 yy:=pos('\',SupportExpiry);
 SupportExpiry:=copy(SupportExpiry,1,yy-1);
 SupportExpiryKeyCheckDate:=EncodeDate(strtointdef(ExpiryYear,2004),
     strtointdef(ExpiryMonth,2),strtointdef(ExpiryDay,27));

 if (UpdateReleaseDate>SupportExpiryKeyCheckDate) then
  begin
   ExpiredSupportMsg := 'This update file requires a current Support Plan for TimeChart.  Your TimeChart Support Plan expired on ' + ExpiryDay+'/'+ExpiryMonth+'/'+ExpiryYear +  ' in the current installation.' + endline;
//   ExpiredSupportMsg := ExpiredSupportMsg+'This update of TimeChart is more recent ' + endline;
   ExpiredSupportMsg := ExpiredSupportmsg + endline;
   ExpiredSupportMsg := ExpiredSupportMsg+'Please try to re-install TimeChart from the latest download link provided to you via email on your most recent Support Plan renewal date.' + endline + 'If you are unable to find this link or would like to renew your Support Plan, please contact AMIG SYSTEMS on 1300 554 516 or www.timechart.com.au';
   messagedlg(ExpiredSupportMsg, mtError, [mbOK], 0);
  end;

 if ((AppReadStr<>'Network Time Chart 2000') and (AppReadStr<>'Network Time Chart 6'))
     or (UpdateReleaseDate>SupportExpiryKeyCheckDate) or (Failed) then
  begin
   School:='Application Validation - FAILED!';  //one of our keyfiles, but not for Time Chart version 5
   exit;
  end;
 result:=true;

 Source:=GetEncryptStr('TCCNET.DAT','©Ncevy 2009ª¹°¿ NZVT FLFGRZF¶@±GP6.0 Argjbex¾´·ºß');
 if Source <> '' then
  begin
   i:=pos(endline,Source);
   tmpStr:=copy(Source,i+2,length(Source));
   zz:=pos('\',tmpStr);
   tmpStr2:=copy(tmpStr,1,zz-1);
   CustomerIDnum:=strtointdef(tmpstr2,0);
   tmpStr:=copy(tmpStr,zz+3,length(tmpStr));
   zz:=pos('\',tmpStr);
   tmpStr2:=copy(tmpStr,1,zz-1);
   if (tmpStr2='YES2CASES21') then Cases21Flag := True;
  end;
 chdir(Directories.datadir);
end;

function OLDKeyFileValidationCheck:wordbool;
var
 AppReadStr:        shortstring;
 VersionReadStr:     shortstring;
 SupportExpiry,ExpiryYear:  shortstring;
 ExpiryMonth,ExpiryDay: shortstring;
 Source: shortstring;
 i: integer;
 zz,yy: integer;
 ExpiredSupportMsg: string;
 tmpStr,tmpstr2: string;
begin
 Result:=false;
 Source:=GetEncryptStr('TCNET.DAT','©Ncevy 2004ª¹°¿ NZVT FLFGRZF¶@±GP5.2 Argjbex¾´·ºß');
 if Source='' then
  begin
   School := 'Application Validation - FAILED!' + #10#13 + 'Re-install Time Chart from your Setup.exe file.';
   exit;
  end;
 i:=pos(endline,Source);   {get school name}
 School:=copy(Source,1,i-1);
//check application & version
 AppReadStr:=copy(Source,i+2,23);
 VersionReadStr:=copy(Source,i+27,2);
 SupportExpiry:=copy(Source,i+31,length(Source));
 TmpStr:=SupportExpiry;

 ExpiryYear:=copy(TmpStr,1,4);
 TmpStr:=copy(TmpStr,6,length(TmpStr));
 zz:=pos('/',TmpStr);
 ExpiryMonth:=copy(TmpStr,1,zz-1);
 yy:=pos('\',TmpStr);
 ExpiryDay:=copy(TmpStr,zz+1,(yy-(zz+1)));
 yy:=pos('\',SupportExpiry);
 SupportExpiry:=copy(SupportExpiry,1,yy-1);
 SupportExpiryKeyCheckDate:=EncodeDate(strtointdef(ExpiryYear,2004),
     strtointdef(ExpiryMonth,2),strtointdef(ExpiryDay,27));

 if (UpdateReleaseDate>SupportExpiryKeyCheckDate) then
  begin
//   ExpiredSupportMsg := 'Time Chart Support Plan expired on ' + SupportExpiry +  ' in the current installation.' + endline;
//   ExpiredSupportMsg := ExpiredSupportMsg+'This update of Time Chart is more recent ' + endline;
//   ExpiredSupportMsg := ExpiredSupportMsg+'Please try to re-install Time Chart from the latest CD you received from AMIG SYSTEMS.' + endline + 'If the issue persists please contact AMIG SYSTEMS to renew the Time Chart Support Plan';
   ExpiredSupportMsg := 'This update file requires a current Support Plan for TimeChart.  Your TimeChart Support Plan expired on ' + ExpiryDay+'/'+ExpiryMonth+'/'+ExpiryYear +  ' in the current installation.' + endline;
   ExpiredSupportMsg := ExpiredSupportmsg + endline;
   ExpiredSupportMsg := ExpiredSupportMsg+'Please try to re-install TimeChart from the latest download link provided to you via email on your most recent Support Plan renewal date.' + endline + 'If you are unable to find this link or would like to renew your Support Plan, please contact AMIG SYSTEMS on 1300 554 516 or www.timechart.com.au';
   messagedlg(ExpiredSupportMsg, mtError, [mbOK], 0);
  end;

 if ((AppReadStr<>'Network Time Chart 2000') and (AppReadStr<>'Network Time Chart 6'))
     or (UpdateReleaseDate>SupportExpiryKeyCheckDate) then
  begin
   School:='Application Validation - FAILED!';  //one of our keyfiles, but not for Time Chart version 5
   exit;
  end;
 result:=true;

 Source:=GetEncryptStr('TCCNET.DAT','©Ncevy 2004ª¹°¿ NZVT FLFGRZF¶@±GP5.2 Argjbex¾´·ºß');
 if Source <> '' then
  begin
   i:=pos(endline,Source);
   tmpStr:=copy(Source,i+2,length(Source));
   zz:=pos('\',tmpStr);
   tmpStr2:=copy(tmpStr,1,zz-1);
   CustomerIDnum:=strtointdef(tmpstr2,0);
   tmpStr:=copy(tmpStr,zz+3,length(tmpStr));
   zz:=pos('\',tmpStr);
   tmpStr2:=copy(tmpStr,1,zz-1);
   if (tmpStr2='YES2CASES21') then Cases21Flag := True;
  end;
 chdir(Directories.datadir);
end;

procedure initFontColorPairs;
begin
 FontColorPair[0,1]:=clBlack;  FontColorPair[0,2]:=clWhite;
 FontColorPair[cpNormal,1]:=clBlack;  FontColorPair[cpNormal,2]:=clWhite; {normal colour}
 FontColorPair[cpSub,1]:=clFuchsia;  FontColorPair[cpSub,2]:=clWhite;      {subject codes}
 FontColorPair[cpTeach,1]:=clBlue;  FontColorPair[cpTeach,2]:=clWhite;     {teacher codes}
 FontColorPair[cpRoom,1]:=clTeal;  FontColorPair[cpRoom,2]:=clWhite;   {room codes}
 FontColorPair[cpClass,1]:=cldkgray;  FontColorPair[cpClass,2]:=clWhite;    {class codes}
 FontColorPair[cpFac,1]:=clNavy;  FontColorPair[cpFac,2]:=clWhite; {Faculty}
 FontColorPair[cpHouse,1]:=clNavy;  FontColorPair[cpHouse,2]:=clWhite; {House}

 {Info window - clBtnFace background}
 FontColorPair[cpInfoHead,1]:=clBlack;  FontColorPair[cpInfoHead,2]:=clBtnFace;  {info win headers}
 FontColorPair[cpInfo,1]:=clMaroon;  FontColorPair[cpInfo,2]:=clBtnFace;             {info win info}
{Timetable colours}
 FontColorPair[cpTclash,1]:=clNavy;  FontColorPair[cpTclash,2]:=clAqua;    {teacher clash}
 FontColorPair[cpRclash,1]:=clRed;  FontColorPair[cpRclash,2]:=clLime;      {room clash}
 FontColorPair[cpTTblock,1]:=clBlack;  FontColorPair[cpTTblock,2]:=clBtnFace;    {blocks}
 FontColorPair[cpDouble,1]:=clRed;  FontColorPair[cpDouble,2]:=clWhite;     {double}
 FontColorPair[cpDoubleBlock,1]:=clRed;  FontColorPair[cpDoubleBlock,2]:=clBtnFace;        {block double}
{student list}
 FontColorPair[cpStList,1]:=clMaroon;  FontColorPair[cpStList,2]:=clWhite;    {student list}
 FontColorPair[cpBlockClash,1]:=clRed;  FontColorPair[cpBlockClash,2]:=clWhite;
  {worksheet}
 FontColorPair[cpWorksheet,1]:=clBlack;  FontColorPair[cpWorksheet,2]:=$00FAD1C0;
 // previous brush colours $00FCE2D8; clSkyBlue;

//  HiLite colours

 FontColorHiLitePair[0,1]:=clBlack;  FontColorHiLitePair[0,2]:=clWhite;
 FontColorHiLitePair[cpNormal,1]:=clBlack;  FontColorHiLitePair[cpNormal,2]:=clWhite;            {main}
 FontColorHiLitePair[cpSub,1]:=clred;  FontColorHiLitePair[cpSub,2]:=clAqua;  {subject codes}
 FontColorHiLitePair[cpTeach,1]:=clnavy;  FontColorHiLitePair[cpTeach,2]:=clAqua; {teacher codes}
 FontColorHiLitePair[cpRoom,1]:=clblue;  FontColorHiLitePair[cpRoom,2]:=clAqua;   {room codes}
 FontColorHiLitePair[cpClass,1]:=cldkgray;  FontColorHiLitePair[cpClass,2]:=clAqua; {class codes}
 FontColorHiLitePair[cpFac,1]:=clNavy;  FontColorHiLitePair[cpFac,2]:=claqua;   {Faculty}
 FontColorHiLitePair[cpHouse,1]:=clNavy;  FontColorHiLitePair[cpHouse,2]:=claqua;  {House}
 FontColorHiLitePair[cpStList,1]:=clMaroon;  FontColorHiLitePair[cpStList,2]:=claqua; {student list}
 FontColorHiLitePair[cpWorkSheet,1]:=$00FFD6D6; FontColorHiLitePair[cpWorksheet,2]:=$00FFEEEE;
 FontColorHiLitePair[cpBlocks,1]:=$0096F5C4; FontColorHiLitePair[cpBlocks,2]:=$00DAFCEA;
 FontColorHiLitePair[cpTtable,1]:=$00B5DAF4; FontColorHiLitePair[cpTtable,2]:=$00EDF5FC;

 XML_DISPLAY.tcfont:=Tfont.Create;
 XML_DISPLAY.tcfont.Name:='Ariel';
 XML_DISPLAY.tcfont.Size:=8;
 XML_DISPLAY.tcfont.style:=[fsbold];
 XML_DISPLAY.tcfont.pitch:=fpvariable
end;

function CalcMaxDay: integer;
var
 i,maxDay,maxLimit:       integer;
begin
 maxDay:=0; maxLimit:=1;
 for i:=0 to days-1 do
  if Tlimit[i]>maxLimit then
   begin
    maxLimit:=Tlimit[i]; maxDay:=i;
   end;
 result:=maxDay;
end;

procedure saveNAMfile;
var
 fname: string;
 f    : textfile;
 i,MaxDay    : integer;
begin
 if usrPassLevel=utGen then
    exit;
 XMLHelper.getNAM_EXTENSION(FileNames.LoadedTimeTable,toWrite);
end;

procedure SaveBaseAllot;
var
 i,maxDay:       integer;
 f:         file;
begin
 try
  try
   maxDay:=CalcMaxDay;
   doAssignFile(f,'ALLOT.DAT');
   rewrite(f,1);
   TC4fileHeader:='TCV4';
   blockwrite(f,TC4fileHeader[1],4);
   for i:=0 to Tlimit[maxDay]-1 do
    begin
     BaseAllot[i]:=tsAllot[maxDay,i];
     blockwrite(f,BaseAllot[i],8);
    end;
  finally
   closefile(f);
   FileAge('ALLOT.DAT',NEW_DateChecks[15]);
  end;
 except
 end;
end;

procedure saveCLSfile;
var
  fname: string;
  f    : file;
  i,j    : smallint;
  tmpD,k:       smallint;
begin
  if usrPassLevel=utGen then exit;
  try
      chdir(Directories.datadir);
      fname:=XMLHelper.getCLS_EXTENSION(FileNames.LoadedTimeTable,toWrite);
      if UpperCase(FileNames.LoadedTimeTable)='TTABLE' then
        SaveBaseAllot; {for Qld schools}
      XMLHelper.getNAM_EXTENSION(FileNames.LoadedTimeTable,toWrite);
      Application.ProcessMessages;
  except
  end;
end;

procedure saveWSfile;
var
  fname: string;
  f: file;
  i,j: integer;
  wstNum,wstDays: smallint;
begin
  try
    wsMainSize:=szWScell*years*(levelprint+2);
    fname:=FileNames.LoadedTimeTable+'.TWS';  {timetable work sheet}
    doAssignFile(f, fname);
    try
      rewrite(f,1);
      blockwrite(f,wsMultNum,2);  {write multiples}
      for i:=0 to wsMultNum do
      begin
        blockwrite(f,wsOne[i],2);
        blockwrite(f,wsTwo[i],2);
        blockwrite(f,wsThree[i],2);
      end;

      wstNum:=years+nmbrWSTspecials-1; wstDays:=days-1;  {write targets}
      blockwrite(f,wstNum,2); blockwrite(f,wstDays,2);
      for i:=-1 to wstNum do
        for j:=0 to wstDays do
        begin
          blockwrite(f,wstSingle[i,j],4);   blockwrite(f,wstDouble[i,j],4);
          blockwrite(f,wstTriple[i,j],4);
        end;
      blockwrite(f,wsBlocks,2);  {write worksheet}
      blockwrite(f,wsMainSize,2);
      for i:=1 to wsBlocks do
        blockwrite(f,WSMain[i][0],wsMainSize);
    finally;
      CloseFile(f);
      Application.ProcessMessages;
    end;
  except
  end;
end;

procedure saveNewTTable;
var
  f           : file;
  i,j,d       : smallint;
  dummyByte   : byte;
  tempPointer2: pointer;
begin
  try
    try
      dummyByte:=0;
      newtimefile:= XMLHelper.getTTW_EXTENSION(FileNames.LoadedTimeTable ,toWrite); {new}
    finally
      CloseFile(f);
      Application.ProcessMessages;
    end;
  except
  end;
end;


function byterangecheck(var i: byte; j,k: smallint):boolean;
begin
 result:=true;   {now used as function in getttparams to flag a rangecheck correction}
 if i<j then   {previous references can just ignore result}
  begin
   i:=j;
   result:=false;
  end
 else
  if i>k then
   begin
    i:=k;
    result:=false;
   end;
end;

procedure getTTParameters;
var
 i,j,ttformatTemp: byte;
 tempPointer : pointer;
 tempIntPoint: ^ smallint;
 Msg         : string;
begin
 Msg:='';
 days:=ttParameters^[0];
 if not(byterangecheck(days,1,nmbrDays)) then
    Msg:='Number of Days failed Range Check and was adjusted';
 periods:=ttParameters^[1];
 if not(byterangecheck(periods,1,nmbrPeriods)) then
    Msg:='Number of Periods failed Range Check and was adjusted';
 years:=ttParameters^[2];
 if not(byterangecheck(years,1,nmbrYears)) then
    Msg:='Number of Years failed Range Check and was adjusted';
 if Msg>'' then messagedlg(Msg,mtWarning,[mbOK],0);
 years_minus_1:=years-1;
 Version:=' ';
 j:=ttParameters^[50];
 if j>0 then
  begin
   Version[0]:=chr(j);
   for i:=1 to j do Version[i]:=chr(ttParameters^[50+i]);
  end;
 for i:=0 to (years-1) do
  begin
   Blocks[i]:=ttParameters^[20+i];
   level[i]:=ttParameters^[5+i]
  end;
 ttformatTemp:=ttMainFormat mod 10;
 LevelMax:=CalcLevelMax(ttformatTemp,years,days,periods);
 ttMemorySetting1.Value:=8*LevelMax;
 ttMemSetting2.Value:=years*ttMemorySetting1.Value;
 ttMemSetting3.Value:=64000 div days;
 tempPointer:=ttParameters;
 for i:= 0 to days-1 do
  for j:= 0 to periods-1 do
   begin
    tempIntPoint:=tempPointer;
    inc(tempIntPoint,50+(15*i)+j);
    Tclash[i,j]:=tempIntPoint^;
    tempIntPoint:=tempPointer;
    inc(tempIntPoint,200+(15*i)+j);
    Rclash[i,j]:=tempIntPoint^;
    Fclash[i,j]:=ttParameters^[700+(15*i)+j]
   end;
  {d1,p1 etc}
 dl:=ttParameters^[900];  pl:=ttParameters^[901];
 yl:=ttParameters^[902];  ll:=ttParameters^[903];
 hd:=ttParameters^[904];  hp:=ttParameters^[905];
 hy:=ttParameters^[906];  hl:=ttParameters^[907];
  {skipped pos=0}
 nd:=ttParameters^[908];  np:=ttParameters^[909];
 ny:=ttParameters^[910];  nl:=ttParameters^[911];
 WSeWarn:=bytebool(ttParameters^[912]);
 WSmWarn:=bytebool(ttParameters^[913]);
 warn:=bytebool(ttParameters^[914]);
 arrow:=ttParameters^[915]; if (arrow>4) then arrow:=0;
 box:=ttParameters^[916];  if box>6 then box:=bxCell;
end;

procedure makefile(fn: String);
var
 tmpF       : file;
 tmpStr     : string;
 i,j        : smallint;
 Lnumstud,Lchmax,LsizeRecord,LIDlen: smallint;
begin
 if usrPassLevel=utGen then exit;
 try
  try
   tmpStr:=copy(fn,1,6);
   doAssignFile(tmpF,fn);
   rewrite(tmpF,1);
   if tmpStr='CHOICE' then
    begin
     Lnumstud:=0; Lchmax:=20; LIDlen:=6; LsizeRecord:=98;
     tmpStr:='TCV4';
     blockwrite(tmpF,tmpStr[1],4);
     blockwrite(tmpF,Lnumstud,2);
     blockwrite(tmpF,Lchmax,2);
     blockwrite(tmpF,LIDlen,2);
     blockwrite(tmpF,LsizeRecord,2)
    end
   else
    begin
     i:=0; j:=3;
     if fn = 'SUBCODE.DAT' then
       j := 6
     else if (fn = 'TECODE.DAT') or (fn = 'ROOMS.DAT') then
       j := 4
     else if (fn = 'SubWillCount.DAT')  then
       j := 2;
     blockwrite(tmpF,i,2);
     blockwrite(tmpF,j,2)
    end;

  finally
   closefile(tmpF)
  end;

 except
 end;
end;

Procedure DefaultDayNames;
var
 i: smallint;
begin
 yearTitle:='Year'; yearShort:='Yr';
 for i:=1 to years do Yearname[i-1]:=IntToStr(6+i);
 for i:=1 to periods do PeriodName[i-1]:='p.'+IntToStr(i);
 if days=5 then
  begin
   Dayname[0]:='MON.';
   Dayname[1]:='TUE.';
   Dayname[2]:='WED.';
   Dayname[3]:='THU.';
   Dayname[4]:='FRI.';
  end
 else for i:=1 to days do Dayname[i-1]:='DAY'+IntToStr(i);
end;

procedure newSchool(fname: String);
var
  f: textfile;
  i: smallint;
begin
 DefaultDayNames;
 if usrPassLevel=utGen then exit;
 try
  try
   doAssignFile(f,fname);
   rewrite(f);
   for i:=1 to years do writeln(f,Yearname[i-1]);
   for i:=1 to periods do writeln(f,PeriodName[i-1]);
   for i:=1 to days do writeln(f,Dayname[i-1]);
  finally
   closefile(f)
  end;
 except
 end;
end;

procedure AllotLoad;
var
  tmpDouble2: double;
  i: smallint;
  f: file;
  lAmtTransferred: Integer;
begin
 chdir(Directories.datadir);
  {init Allot first}
 for i:= 0 to nmbrPeriods do BaseAllot[i]:=1.0; {default}
 if fileexists('ALLOT.DAT') then
  begin
   try
    try
     doAssignFile(f, 'ALLOT.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(f, 1);
     FileAge('ALLOT.DAT',NEW_DateChecks[15]);
     TC4fileHeader[0]:=chr(4);
     blockread(f,TC4fileHeader[1],4);
     if TC4fileHeader = 'TCV4' then
      for i:=0 to periods-1 do BlockRead(f, BaseAllot[i], 8, lAmtTransferred)

    finally
     closefile(f)
    end;

   except
   end;
   for i:= 0 to periods-1 do
    begin
     tmpDouble2:=1.0+BaseAllot[i];
     if (tmpDouble2<1.0) then BaseAllot[i]:=1.0;
     if (tmpDouble2>5001.0) then BaseAllot[i]:=1.0;
    end;
  end;
end;

procedure CheckWSmultiplesUsed;
var
 i,y,b,l: smallint;
 wsCheck: array of boolean;
begin
 if wsMultNum<=0 then exit;
 setLength(wsCheck,wsMultNum+2);
 for i:=1 to wsMultNum do wsCheck[i]:=false;
 for b:=1 to wsBlocks do
  for y:=0 to years_minus_1 do
   for l:=1 to level[y] do
    begin
     i:=FNws(b,y,l,8)^;
     if (i>0) and (i<=wsMultNum) then wsCheck[i]:=true;
    end;
 for i:=1 to wsMultNum do
  if not(wsCheck[i]) then {multiple not used}
   begin
    wsOne[i]:=0; wsTwo[i]:=0; wsThree[i]:=0;
   end;
end;

procedure getWSfile;
var
 fname: string;
 f: file;
 i,j: integer;
 wstNum,wstDays: smallint;
begin
 try
  wsb:=1; wsb1:=1; wsy1:=years_minus_1; wsy:=years_minus_1; wsl:=1; wsl1:=1;
  wsMultNum:=0; SetWSmultArrays;
  for i:=0 to years_minus_1 do if (Blocks[i]>wsBlocks) and (Blocks[i]<=nmbrBlocks)
    then wsBlocks:=Blocks[i];
  wsOne[0]:=1; wsTwo[0]:=0; wsThree[0]:=0;
  for i:=-1 to nmbrYears+nmbrWSTspecials do
   for j:=0 to nmbrDays do
    begin
     wstSingle[i,j]:=-1; wstDouble[i,j]:=-1; wstTriple[i,j]:=-1;
    end;
  fname:=FileNames.LoadedTimeTable+'.TWS';  {timetable work sheet}
  if not(fileexists(fname)) then
   begin
    ClearWorksheet;
    exit;
   end;
  doAssignFile(f, fname);
  try
   filemode:=fmOpenRead+fmShareDenyNone;
   reset(f, 1);
   blockread(f,wsMultNum,2);  SetWSmultArrays; {read multiples}
   for i:=0 to wsMultNum do
    begin
     blockread(f,wsOne[i],2);  IntRange(wsOne[i],0,periods*days);
     blockread(f,wsTwo[i],2);  IntRange(wsTwo[i],0,periods*days);
     blockread(f,wsThree[i],2);  IntRange(wsThree[i],0,periods*days);
    end;
   blockread(f,wstNum,2);  IntRange(wstNum,0,years+nmbrWSTspecials);
   blockread(f,wstDays,2); IntRange(wstDays,0,days);
   for i:=-1 to wstNum do     {read targets}
    for j:=0 to wstDays do
     begin
      blockread(f,wstSingle[i,j],4);   blockread(f,wstDouble[i,j],4);
      blockread(f,wstTriple[i,j],4);
     end;
   blockread(f,wsBlocks,2);  IntRange(wsBlocks,2,nmbrBlocks);
   ClearWorkSheet;
   blockread(f,wsMainSize,2);
   for i:=1 to wsBlocks do
     blockread(f,WSMain[i][0],wsMainSize);
  finally;
   closefile(f);
  end;
  CheckWSmultiplesUsed;
  for i:=1 to wsBlocks do WSFclash[i]:=1; WSclash;
 except
 end;
end;

procedure getCLSfile;
var
  fname: string;
  f    : file;
  i,j,k,tmpD  : smallint;
  lAmtTransferred: Integer;
begin
 yeartitle:='Year'; yearshort:='Yr';
 XMLHelper.getNAM_EXTENSION(FileNames.LoadedTimeTable,toRead); {read in names, including old periodnames}
 if (yearTitle<>'Form') and (yearTitle<>'Year') then
  begin
   yearTitle:='Year';  yearShort:='Yr'
  end;
 AllotLoad; {get base allotments - old allot storage}
 try
  {initialise all values}
  TimeSeparator:=':';  NumDayGroups:=1;
  TslotUnit:=2; SlotUnitDec:=2; SlotUnitMain:=6;
  for i:=-1 to nmbrDays do DayGroup[i]:=1;
  for i:=0 to nmbrDays do Tlimit[i]:=periods;
  for j:=0 to days-1 do
   for k:=0 to periods-1 do
    begin
     TimeSlotName[j,k]:=periodname[k];
     if k<9 then tsCode[j,k]:=inttostr(k+1) else tsCode[j,k]:=chr(56+k);
     tsAllot[j,k]:=BaseAllot[k];
     if (k=0) then
      begin tsStart[j,k]:=StrToTime('9:00'); tsEnd[j,k]:=StrToTime('10:00'); end
       else begin
             tsStart[j,k]:=tsStart[j,k-1]+StrToTime('1:00');
             tsEnd[j,k]:=tsEnd[j,k-1]+StrToTime('1:00');
            end;
    end;
  chdir(Directories.datadir);
  fname:=XMLHelper.getCLS_EXTENSION(FileNames.LoadedTimeTable,toRead);
  DayGroupCount;
 except
 end;
end;

procedure makeLabelFile(fname: String);
var
 f: file;
begin
 Lnum:=0;
 if usrPassLevel=utGen then exit;
 try
  try
   doAssignFile(f,fname);
   rewrite(f,1);
   blockwrite(f,Lnum,2)
  finally
   closefile(f)
  end;
 except
 end;
end;

procedure get2000TTable(var f: file);
var
 i: smallint;
begin
 ttMainFormat:=2;
 try
  try
   blockread(f,ttParameters^,sz2000Params);
   getTTParameters;
   for i:=0 to days-1 do blockread(f,ttMain[i]^,sz2000DayBlock);
  finally
   closefile(f)
  end;
 except
 end;
end;

(*
procedure getNewTTable(var f: file);
var
 i,j,d: smallint;
 tempPointer2: pointer;
 dummyByte: byte;
begin
 ttNewFormat := true;
 try
  try
   blockread(f,ttMainFormat,1);
   blockread(f,days,1);  byterangecheck(days,1,nmbrDays);
   blockread(f,periods,1);  byterangecheck(periods,1,nmbrPeriods);
   blockread(f,years,1);  byterangecheck(years,1,nmbrYears);
   yr:=years-1;
   blockread(f,LevelMax,2);
   for i:=0 to yr do blockread(f,level[i],1);
   for i := 0 to yr do
    begin
     blockread(f,Blocks[i],1);  IntRange(Blocks[i],0,nmbrBlocks);
    end;
   blockread(f,ttVersion[0],1);
   blockread(f,ttVersion[1],ord(ttVersion[0]));
   ttVersion:=trim(ttVersion);
   for i:=0 to days-1 do
    for j:=0 to periods-1 do blockread(f,Tclash[i,j],2);
   for i:=0 to days-1 do
    for j:=0 to periods-1 do blockread(f,Rclash[i,j],2);
   for i:=0 to days-1 do
    for j:=0 to periods-1 do blockread(f,Fclash[i,j],1);
      {d1,p1 etc. 900+ params from standard}
   blockread(f,dl,1);  blockread(f,pl,1);
   blockread(f,yl,1);  blockread(f,ll,1);
   blockread(f,hd,1);  blockread(f,hp,1);
   blockread(f,hy,1);  blockread(f,hl,1);
      {skipped pos=0}
   blockread(f,nd,1);  blockread(f,np,1);
   blockread(f,ny,1);  blockread(f,nl,1);
   blockread(f,WSeWarn,1); blockread(f,WSmWarn,1);
   blockread(f,warn,1);
   blockread(f,arrow,1);  if arrow>4 then arrow:=0;
   blockread(f,box,1);   if box>6 then box:= bxCell;
   blockread(f,dummyByte,1);  blockread(f,dummyByte,1);
   blockread(f,dummyByte,1);  blockread(f,dummyByte,1);
   setTTParameters;
   {main timetable data}
   for d:=0 to days-1 do
    begin
     tempPointer2:=FNT(d,0,0,1,0);
     blockread(f,tempPointer2^,8*word(LevelMax)*word(periods)*word(years));
    end;
  finally
   closefile(f)
  end;
 except
 end;
end;
*)

procedure getStandardTTable(var f: file);
const
 tmpBufSize = 64000;
type
 tptmpBuf = array [0..tmpBufSize] of byte;
var
 d: longint;
 tmpBuf: ^ tptmpBuf;
begin
 tmpBuf:=nil;
 try
  try
   new(tmpBuf);
   fillchar(tmpBuf^,tmpBufSize,chr(0));
   ttMainFormat:=1;
   ttFileHeader[0]:=chr(7);
   blockread(f,ttFileHeader[1],7);
   blockread(f,ttParameters^,sz8000Params);
   getTTParameters;
   blockread(f,tmpBuf^,tmpBufSize);
   for d:= 0 to days-1 do
     move(tmpBuf^[ttMemSetting3.Value*d],ttMain[d]^,8*word(LevelMax)*word(periods)*word(years)+8);
  finally
   closefile(f);
   dispose(tmpBuf)
  end;
 except
 end;
end;

procedure ConvertLabels;
var
 d,p,y,L,su: smallint;
 a : tpIntPoint;
begin
 if (ttMainFormat>10) or (LabelBase=LabelBaseOld) then exit;
 inc(ttMainFormat,10);
 for d:=0 to days-1 do
  for p:=0 to periods-1 do
   for y:=0 to years-1 do
    begin
     a:=FNT(d,p,y,0,0);
     for L:=1 to LevelMax do
      begin
       inc(a,4);
       su:=a^;
       if (su>LabelBaseOld) then
        begin
         if su>(LabelBase+nmbrLabels) then
          begin //clear invalid entry
           su:=0;
           a^:=su
          end
         else
          begin
           su:=su-LabelBaseOld+LabelBase;
           a^:=su;
          end;
        end;
      end; {l}
    end; {y}
end;

procedure makeNewTtable;
var
 i: integer;
begin
 days:=5; periods:=6; years:=6;  years_minus_1:=5;
 // 16 - produces the bigger initial file (was set to 11)
 ttMainFormat:=16; {default to standard 64000 format}
 dl:=0; pl:=0; yl:=years_minus_1; ll:=1;
 nd:=0; np:=0; ny:=years_minus_1; nl:=1;
 hd:=0; hp:=0; hy:=years_minus_1; hl:=1;

 getCLSfile;
 for i:=0 to years_minus_1 do
  begin
   level[i]:=6;
   Blocks[i]:=6
  end;
 setTTParameters;
 getTTParameters;
end;

procedure getTTable;
var
 f               : file;
 fname           : string;
 i               : smallint;
 fs              : longint;
 dd              : byte;
 forceNEWTTupdate: wordbool;
begin
 forceNEWTTupdate:=false;
 for i:=0 to nmbrDays-1 do fillchar(ttMain[i]^,szTTDayBlock,chr(0));
  {set default ttFileHeader}
 ttFileHeader[0]:=chr(7);   ttFileHeader[1]:=chr($FD);
 ttFileHeader[2]:= chr($B1); {default seg $35B1}
 ttFileHeader[3]:= chr($35); ttFileHeader[4]:=chr($00); {default ofs $0000}
 ttFileHeader[5]:= chr($00); ttFileHeader[6]:=chr($E8); {default size $FDE8}
 ttFileHeader[7]:=chr($FD);

 newtimefile:=XMLHelper.getTTW_EXTENSION(FileNames.LoadedTimeTable, checkExists);
 ttNewFormat:=false;
 if (fileexists(newtimefile) and UseNewTTWTimetable) then
  begin
   try
    FileAge(newtimefile,NEW_DateChecks[16]);
    XMLHelper.getTTW_EXTENSION(FileNames.LoadedTimeTable, toRead);
   except
   end;
  end
 else {no new sequential format file found}
 begin
   timefile:=FileNames.LoadedTimeTable+'.TT';
   if not(fileexists(timefile)) then
      makeNewTtable;
   if (fileexists(timefile)) then
    try
     doAssignFile(f,timefile);
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(f,1);
     FileAge(timefile,NEW_DateChecks[16]);
     blockread(f,dd,1);  filemode:=fmOpenRead+fmShareDenyNone;
     reset(f,1);
     fs:=fileSize(f);
     if ((fs=65007) or (((fs >= 65000) and (fs <= 66000))
      and (dd <> 4))) then getStandardTTable(f)
     else get2000TTable(f);
    except
    end;
   forceNEWTTupdate := true
 end;
  LevelPrint:=LevelMax;
  if LevelPrint>nmbrLevels then LevelPrint:=nmbrLevels;
  getCLSfile;
  getWSfile;
  for i:=0 to nmbrLabels do TcLabel[i]:='';
  fname:=XMLHelper.getLAB_EXTENSION(FileNames.LoadedTimeTable, toRead);
 ConvertLabels;
 RebuildLabels;
  // #1118 - Check timetable size and upgrade if it is not the latest (ttMainFormat=16)
  if (ttMainFormat <> 16) then
  begin
   ConfigureTimetable(days,periods,years,16);
   initTtUndoStack;
   UpdateAllWins;
   forceNEWTTupdate := true;
  end;
 if forceNEWTTupdate then saveTTable; //only now, AFTER read in rest like NAM file
 SetTimeCell;
 SetDays;
 DoAllTtClashes; //force recalc of clashes once initially
 initTtUndoStack;
 SaveTimeFlag := false
end;

procedure ReLoadCustom;
var
 s: string;
begin
 try
  if not (XML_DISPLAY.customFileLoadFlag) then exit;
  chdir(Directories.datadir);
  s:=Extractfilename(XML_DISPLAY.customFileLoad);
  custom:=RemoveExtension(s);
  ReadCustom;
 except
 end;
end;

procedure TAbout.SetTitle;
begin
 SchoolName.caption:=School;
 TCvers := 'Windows Version ' + GetVersion;
 VersionLabel.caption:=TCvers;
 Copyright.caption:='© AMIG SYSTEMS '+FormatDateTime('YYYY',now);
end;

procedure TAbout.SetupApp;
var
  tmpstr,s: string;
  i:smallint;
  UpdateDays: Integer;
  lDate: TDateTime;
  lPassChecked: TLoginStat;
begin
  setlength(GroupSubs,nmbrSubYear+1);
  setlength(GroupSubCount,nmbrSubYear+1);
  setlength(GsubXref,nmbrSubYear+1);
  loadFinished:=false;
  timerCount:=0;
  DateStr:=FormatDateTime('d mmmm yyyy', date);

  for i:=1 to 41 do NEW_DateChecks[i]:=now;

  screen.cursor:=crDefault;
  tmpstr:=Paramstr(0);
  Directories.progdir:=GetDirName(tmpstr);
  s:='Users';
  if (Directories.progdir[length(Directories.progdir)]<>'\') then s:='\'+s;
  Directories.UsersDir:=Directories.progdir+s;
  lPassChecked := Checkpassword(True);
  if lPassChecked = lsQuit then
  begin
    Application.Terminate;
    Exit;
  end
  else
  begin
    about.refresh;   //prevent gurey box from showing after password check
    screen.cursor:=crHourglass;

    getDirectories;
    if (trim(usrPassDir)='') then usrPassDir:=Directories.datadir;
    screen.cursor := crHourglass;
    Timer1.enabled := true; {done here incase getdirdlg comes up, don't want about restored too soon.}

    //
    //remove OLDkeyfilecheck near end of April 2010
    //

    lblExpiry.Caption := '';
    {$IfDef TRIAL}
    // Start of Trial Setup
    //lDate := StrToDateTime('01/12/2011');
    lDate := EncodeDate(2013,06,01);
    KeyFileOK := lDate >= Today;
    School := 'AMIG SYSTEMS - Trial Version';
    lblExpiry.Caption := 'Expiry date: ' + DateTimeToStr(lDate);
    if not KeyFileOK then
    begin
      School := 'Time Limited Trial has expired!';
      about.timer1.enabled:=false;
      //reset about to use as about box
      setTitle;
      about.SchoolName.caption := School;
      about.borderstyle := bsNone;
      about.bordericons:=[biSystemMenu];
      About.OKbutton.Visible := True;
      //About.Panel2.Visible := True;
      About.loadLabel.Visible := False;
      About.Caption := 'About';
      Screen.Cursor :=crDefault;
      About.ShowModal;
    end
    else
    begin
      SupportExpiryKeyCheckDate := lDate;
      // End of Trial Setup
    {$ENDIF}

    KeyFileOK:=(KeyFileValidationCheck or OLDKeyFileValidationCheck);
    if not(KeyFileOK) then Timer1Timer(Self);

    SetTitle;
    if KeyFileOK then
    begin
     about.show;
     about.refresh;
     mainform.caption:='Network TimeChart - '+school;
     firstLoad;
     CustomerSetup;
     Winshow;    {restores previously open windows}
     if XML_DISPLAY.EntrySelectionLink then checkLinkedWins; //update linked wins if necessary
    {restore gen toolbar if necessary}
     if fgGenToolbar then
      case XML_DISPLAY.fgGenToolbarDock of  {restore docked toolbar}
        1:  gentoolbarwin.manualdock(mainform.Panel4);
        2:  gentoolbarwin.manualdock(mainform.panel6);
      end;  {case}
     if XML_DISPLAY.showHintsDlg then
      begin
       Hintsdlg := THintsdlg.Create(Self); {allocate dlg}
       Hintsdlg.ShowModal;
       Hintsdlg.Free{release dlg}
      end;
     updateStatusPanel;
     loadFinished:=true;  {flag to allow timer to reset about box}
     case XML_DISPLAY.OnlineUpdateCheck of
      1: UpdateDays:=7;
      2: UpdateDays:=14;
      3: UpdateDays:=31;
      4: UpdateDays:=62;
      else UpdateDays:=0;
     end;

     if ((usrPassLevel=utTime) or (usrPassLevel=utSuper)) then  //online check only for timetabler and supervisor
     if ((UpdateDays>0) and (DaysBetween(NOW,LastUpdateCheck)>=UpdateDays)) then
      begin
        // Disable the auto checking
       //WebUpdateDlg:=TWebUpdateDlg.create(self);   {allocate dlg}
       //WebUpdateDlg.CheckForOnlineUpdate;
       //WebUpdateDlg.free;      -
      end;
    end
    else about.showmodal;

    {$IfDef TRIAL}
    end;
    {$EndIf}

    if lPassChecked = lsLogin then
      MainForm.SetupUserMenus;
  end;
end;

procedure initRoomLoad;
var
 i,j: smallint;
 f: file;
 a: smallint;
begin
 for i:= 1 to nmbrRooms do
  begin
   XML_TEACHERS.RoSize[i]:=30;
   XML_TEACHERS.Rfaculty[i,1]:=-1;
   Rotype[i]:=0;   Rassign[i]:=0;
  end;
 if fileexists('RoLoad.DAT') then
  begin
   try
    try
     doAssignFile(f,'RoLoad.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(f,1);
     blockread(f,a,2);  IntRange(a,0,nmbrRooms);
     if a>0 then
      for i:= 1 to a do
       begin
        blockread(f,XML_TEACHERS.RoSize[i],2);
        for j:=1 to 3 do blockread(f,XML_TEACHERS.Rfaculty[i,j],2);
       end;
    finally
     closefile(f)
    end;
   except
   end;
  end
 else makefile('RoLoad.DAT');

 if fileexists('RoAssign.DAT') then
  try
   try
    doAssignFile(f,'RoAssign.DAT');
    reset(f,1);
    blockread(f,a,2); IntRange(a,0,nmbrRooms);
    if a>0 then
     for i:=1 to a do
     begin
      blockread(f,Rotype[i],2); IntRange(Rotype[i],0,4);
      blockread(f,Rassign[i],2);
     end;
   finally
    closefile(f);
   end;
  except
  end;
end;

procedure initTeacherLoad;
var
 i,j,k: smallint;
 f: file;
 a: smallint;
begin
 for i:= 1 to nmbrteachers do
  begin
   XML_TEACHERS.Load[i]:=WeekMaxLoad;
   XML_TEACHERS.Tfaculty[i,1]:=-1;
   for k:=2 to nmbrTeFacs do XML_TEACHERS.Tfaculty[i,k]:=0;
   for k:=0 to 2 do
    begin
     XML_TEACHERS.DutyCode[i,k]:='';
     XML_TEACHERS.DutyLoad[i,k]:= 0
    end;
  end;
 if fileexists('TELOAD.DAT') then
  begin
   try
    try
     doAssignFile(f, 'TELOAD.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(f, 1);
     a:= NumCodes[1];
     if a>0 then
      begin
       TC4fileHeader[0]:=chr(4);
       blockread(f,TC4fileHeader[1],4);
       if TC4fileHeader='TCV4' then
        for i:= 1 to a do
         begin
          blockread(f,XML_TEACHERS.Load[i], 2);
          for j:= 1 to 3 do blockread(f,XML_TEACHERS.Tfaculty[i,j],2);
          for k:= 0 to 2 do
           begin
            XML_TEACHERS.DutyCode[i,k][0]:=chr(szDutyCode);          // set length of DutyCode
            blockread(f,XML_TEACHERS.DutyCode[i,k][1],szDutyCode);   // read
            XML_TEACHERS.DutyCode[i,k]:= trim(XML_TEACHERS.DutyCode[i,k]);
            blockread(f,XML_TEACHERS.DutyLoad[i,k],8)
           end;
         end
        else
         begin
          seek(f,0);
          for i:= 1 to a do
           begin
            blockread(f,XML_TEACHERS.Load[i],2);
            for j:= 1 to 3 do blockread(f,XML_TEACHERS.Tfaculty[i,j],2);
            for k := 0 to 2 do
             begin
              XML_TEACHERS.DutyCode[i,k]:= '';
              XML_TEACHERS.DutyLoad[i,k]:= 0{init}
             end;
           end;
         end;
        for i:=1 to a do if XML_TEACHERS.load[i]=-1 then XML_TEACHERS.load[i]:=WeekMaxLoad;
       end;

    finally
      closefile(f)
    end;
   except
   end;
  end
 else makefile('TELOAD.DAT');
 if fileexists('TeFac.DAT') then  {read in 4th faculty}
  try
   try
    doAssignFile(f,'TeFac.DAT');
    filemode:=fmOpenRead+fmShareDenyNone;
    reset(f, 1);
    blockread(f,a,2);
    blockread(f,k,2);
    if a>NumCodes[1] then a:=NumCodes[1];
    if a>0 then
     for i:= 1 to a do blockread(f,XML_TEACHERS.Tfaculty[i,4],2);
   finally
    closefile(f)
   end;
  except
  end;
end;

procedure DEETsubFill;
var
 a,j,i,k: integer;
 tmpStr,tmpstr2: string;
begin
 a:=NumCodes[0];
 for i:=1 to a do
  begin
   tmpStr:=trim(SubCode[i]);
   tmpstr2:=Subname[i];
   if length(tmpStr)<lencodes[0] then
    for j:=1 to 9 do
     begin
      tmpStr:=trim(SubCode[i])+Space(30);
      tmpStr:=copy(tmpStr,1,lencodes[0]-1)+chr(64+j);
      k:=checkCode(0,tmpStr);
      if k=0 then
       begin
        inc(NumCodes[0]);
        SubCode[NumCodes[0]]:=tmpStr;
        Subname[NumCodes[0]]:=tmpstr2;
        link[NumCodes[0]]:=0;
       end;
     end;
  end;
end;

procedure getSubjectCodes;
var
 codeFile: file;
 i,NumSubNames,CodePlace ,nosubwillcount: smallint;  //mantis-1295
 tempstr : string;
 lAmtTransferred: Integer;
begin
 for i:= 0 to nmbrSubjects do SubCode[i]:=Space(szSubCode);
 subNA:=0; NumCodes[0]:=0; lencodes[0]:= 6;
 if fileexists('SUBCODE.DAT') then
  begin
   try
    try
     doAssignFile(codeFile,'SUBCODE.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(codeFile,1);
     FileAge('SUBCODE.DAT',NEW_DateChecks[6]);
     blockread(codeFile,NumCodes[0],2);
     blockread(codeFile,lencodes[0],2);
     if NumCodes[0]>0 then
      begin
       for i := 1 to NumCodes[0] do
        begin
         SubCode[i][0]:=chr(lencodes[0]);
         blockread(codeFile,SubCode[i][1],lencodes[0]);
         tempstr:=uppercase(trim(SubCode[i]));
         //SubCode[i] := tempstr;
         if tempstr='NA' then subNA:=i;
        end;
       while (copy(SubCode[NumCodes[0]],1,2)='00') and (NumCodes[0]>0) do
          dec(NumCodes[0])
      end;
    finally
     closefile(codeFile)
    end;
   except
   end;
  end
 else makefile('SUBCODE.DAT');
  { load subject names }
 for i:=0 to nmbrSubjects do Subname[i]:='';
 snsize:=szSubnameDefault; NumSubNames:=NumCodes[0];
 if fileexists('SUBNAME.DAT') then
  begin
   try
    try
     doAssignFile(codeFile,'SUBNAME.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(codeFile,1);
     SetLength(tempstr,4);
     blockread(codeFile,tempstr[1],4);
     if tempstr='TC4W' then
      begin
       blockread(codeFile,NumSubNames,2);
       blockread(codeFile,snsize,2);
      end
     else
      begin
       seek(codeFile, 0);
       blockread(codeFile,NumSubNames,2)
      end;
     if NumSubNames>NumCodes[0] then NumSubNames:=NumCodes[0];
     if NumSubNames>0 then
      for i := 1 to NumSubNames do
       begin
        SetLength(Subname[i],snsize);
        blockread(codeFile,Subname[i][1],snsize);
        Subname[i]:=trim(Subname[i])
       end;
    finally
     closefile(codeFile)
    end;
   except
   end;
  end
 else makefile('SUBNAME.DAT');

 // --------------mantis-1295-----------------------



    for i:=0 to nmbrSubjects do Subwillcount[i]:=Space(szSubWillCountMax); //1
 Subwillcountsize:=szSubWillCountMax; nosubwillcount:=NumCodes[0];
 if fileexists('SubWillCount.DAT') then
  begin
   try
    try
     doAssignFile(codeFile,'SubWillCount.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(codeFile,1);
     SetLength(tempstr,4);
     blockread(codeFile,tempstr[1],4);
     if tempstr='TC4W' then
      begin
       blockread(codeFile,nosubwillcount,2);
       blockread(codeFile,Subwillcountsize,2);
      end
     else
      begin
       seek(codeFile, 0);
       blockread(codeFile,nosubwillcount,2)
      end;
     if nosubwillcount>NumCodes[0] then nosubwillcount:=NumCodes[0];
     if nosubwillcount>0 then
      for i := 1 to nosubwillcount do
       begin
        SetLength(Subwillcount[i],Subwillcountsize);
        blockread(codeFile,Subwillcount[i][1],Subwillcountsize);
        Subwillcount[i]:=trim(Subwillcount[i])
       end;
    finally
     closefile(codeFile)
    end;
   except
   end;
  end
 else makefile('SubWillCount.DAT');

     // --------------mantis-1295-----------------------

  {load subject report codes}
 for i := 0 to nmbrSubjects do
    begin SubReportCode[i]:=''; SubReportName[i]:=''; end;
 NumSubRepCodes:=0; LenSubRepCode:=lencodes[0]; LenSubRepName:=snsize;
 if fileexists('SUBREP.DAT') then
  try
   try
    doAssignFile(codeFile,'SUBREP.DAT');
    filemode:=fmOpenRead+fmShareDenyNone;
    reset(codeFile,1);
    blockread(codeFile,NumSubRepCodes,2);
    blockread(codeFile,LenSubRepCode,2);
    blockread(codeFile,LenSubRepName,2);
    if NumSubRepCodes>NumCodes[0] then NumSubRepCodes:=NumCodes[0];
    if NumSubRepCodes>0 then
     for i:=1 to NumCodes[0] do
      begin
       SetLength(SubReportCode[i],LenSubRepCode);
       BlockRead(codeFile, SubReportCode[i][1], LenSubRepCode, lAmtTransferred);
       SubReportCode[i]:=trim(SubReportCode[i]);
       SetLength(SubReportName[i],LenSubRepName);
       blockread(codeFile,SubReportName[i][1],LenSubRepName);
       SubReportName[i]:=trim(SubReportName[i]);
      end;
   finally
    closefile(codeFile)
   end;
  except
  end;

 if subNA=0 then
  if NumCodes[0]<nmbrSubjects then
   begin
    codePlace:=FindNextCode(0);
    tempstr:='NA'; Subname[codePlace]:='Not Available';
    validateCode(0,tempstr);  SubCode[codePlace]:=tempstr;
    subNA:=codePlace;
  end;

 CalcSubReportCodes;
 if DEETcasesImportExport then DEETsubFill
end;

procedure getRoomCodes;
var
 codeFile: file;
 i: smallint;
begin
 for i:=0 to nmbrRooms do XML_TEACHERS.tecode[i,0]:=Space(szTeCode);
 NumCodes[2]:=0; lencodes[2]:= 4;
 if fileexists('ROOMS.DAT') then
  begin
   try
    try
     doAssignFile(codeFile,'ROOMS.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(codeFile,1);
     blockread(codeFile,NumCodes[2],2);
     blockread(codeFile,lencodes[2],2);
     if NumCodes[2]>0 then
      for i:=1 to NumCodes[2] do
       begin
        XML_TEACHERS.tecode[i,1][0]:=chr(lencodes[2]);
        blockread(codeFile,XML_TEACHERS.tecode[i,1][1],lencodes[2])
       end;
    finally
     closefile(codeFile)
    end;
   except
   end;
  end
 else
  begin
   makefile('ROOMS.DAT');
   NumCodes[2]:=0;
   lencodes[2]:= 4;
  end;
 for i:=0 to nmbrRooms do XML_TEACHERS.TeName[i,1]:='';
 if fileexists('ROOMNAME.DAT') then
  begin
   try
    try
     doAssignFile(codeFile,'ROOMNAME.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(codeFile,1);
     FileAge('ROOMS.DAT',NEW_DateChecks[2]);
     blockread(codeFile,NumCodes[2],2);
     if NumCodes[2]>0 then
      for i:= 1 to NumCodes[2] do
       begin
        XML_TEACHERS.TeName[i,1][0]:=chr(szTeName);
        blockread(codeFile,XML_TEACHERS.TeName[i,1][1],szTeName);
        XML_TEACHERS.TeName[i,1]:=trim(XML_TEACHERS.TeName[i,1])
       end;
    finally
     closefile(codeFile)
    end;
   except
   end;
  end
 else makefile('ROOMNAME.DAT');
 initRoomLoad
end;

procedure getTeacherCodes;
var
 codeFile: file;
 i       : smallint;
begin
 for i:=0 to nmbrteachers do XML_TEACHERS.tecode[i,0]:=Space(szTeCode);
 NumCodes[1]:=0; lencodes[1]:= 4;
 CalcWeekMaxLoad;

 if fileexists('TECODE.DAT') then
  begin
   try
    try
     doAssignFile(codeFile,'TECODE.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(codeFile,1);
     FileAge('TECODE.DAT',NEW_DateChecks[1]);
     // How many codes in file
     blockread(codeFile,NumCodes[1],2);
     // the length of these codes MetaData
     blockread(codeFile,lencodes[1],2);
     if NumCodes[1]>0 then
      for i:=1 to NumCodes[1] do
       begin
       // set length of string
        XML_TEACHERS.tecode[i,0][0]:=chr(lencodes[1]);
        // read the data
        blockread(codeFile,XML_TEACHERS.tecode[i,0][1],lencodes[1])
       end;
    finally
     closefile(codeFile)
    end;
   except
   end;
  end
 else
  begin
   makefile('TECODE.DAT');
   NumCodes[1]:=0;
   lencodes[1]:= 4
  end;
 for i:=0 to nmbrteachers do XML_TEACHERS.TeName[i,0]:='';
 if fileexists('TENAME.DAT') then
  begin
   try
    try
     doAssignFile(codeFile,'TENAME.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(codeFile,1);
     blockread(codeFile,NumCodes[1],2);
     if NumCodes[1]>0 then
      for i:=1 to NumCodes[1] do
       begin
        XML_TEACHERS.TeName[i,0][0]:=chr(szTeName);
        blockread(codeFile,XML_TEACHERS.TeName[i,0][1],szTeName);
        XML_TEACHERS.TeName[i,0]:=trim(XML_TEACHERS.TeName[i,0])
       end;
    finally
     closefile(codeFile)
    end;
   except
   end;
  end
 else makefile('TENAME.DAT');
 initTeacherLoad
end;

procedure TAbout.GetDirectories;
var
 f       : textfile;
 backup  : file;
 s,tmpStr  : string;
 backup_drive: string[3];
 i,StrLen,backup_action  : smallint;
  strOriginalHelp, strLocalHelp: string;
  bLocal: boolean;


  function GetTempDir: string;
  var
    TmpPath: pchar;
  begin
   TmpPath:=nil;
    try
      GetMem(TmpPath, MAX_PATH);
      FillChar(TmpPath^, MAX_PATH, #0);
      GetTempPath(MAX_PATH, TmpPath);
      Result := ExpandFileName(String(TmpPath));
    finally
      FreeMem(TmpPath, MAX_PATH);
    end;
  end;

  function GetFileSize(const FileName: string): Integer; //Int64;
  var
    FileStream: TFileStream;
  begin
    FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    try
      try
        Result := FileStream.Size;
      except
        Result := 0;
      end;
    finally
      FileStream.Free;
    end;
  end;


begin
  //Read the main data directory
  ChDir(Directories.progdir);
  doAssignFile(f,'DIR.SYS');
  try
    try
      FileMode := fmOpenRead + fmShareDenyNone;
      Reset(f);
      Readln(f,s);
      Readln(f,s);
      MainDataDir := s;
    finally
      CloseFile(f)
    end;
  except
  end;

  //Read users data directory or main
 tmpStr:=Directories.progdir;
 if usrPassLevel>utGen then
  try
   if (trim(usrPassDir)>'') then
    begin
    //presence of a file called RollMarker.txt in progdir activates RollMarker custom exports
     RollMarkerFlg:=FileExists('Rollmarker.TXT');
     chdir(usrPassDir);
     if FileExists('DIR.SYS') then tmpstr:=usrPassDir;
    end
   else tmpstr:=Directories.progdir;
  except
  end;

 chdir(tmpstr);
 {read in DIR.SYS}
 doAssignFile(f,'DIR.SYS');
 if fileexists('DIR.SYS') then
  begin
   try
    try
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(f);
     readln(f,s);
     readln(f,s);
     Directories.datadir:=s;
     readln(f,s);
     DOSscreenmem:=s;
     Readln(F, Directories.RMExportDir);
    finally
     closefile(f)
    end;
   except
   end;
    {remove last '\'   from progdir now}
   if ((Directories.progdir[length(Directories.progdir)]= '\') and (Directories.progdir[length(Directories.progdir)-1]<>':')) then
       Directories.progdir := Copy(Directories.progdir,1,length(Directories.progdir)-1);
   if not(directoryexists(Directories.datadir)) then getdirdlg.ShowModal
  end
 else
  begin
   s:='DATA';
   if (Directories.progdir[length(Directories.progdir)]<>'\') then s:='\DATA';
   Directories.datadir:=Directories.progdir+s;
   DOSscreenmem:=chr(0);
   {remove last '\' from progdir now}
   if ((Directories.progdir[length(Directories.progdir)]= '\') and (Directories.progdir[length(Directories.progdir)-1]<>':')) then
      Directories.progdir := Copy(Directories.progdir,1,length(Directories.progdir)-1);
   getdirdlg.ShowModal
  end;

 {$I-}
 chdir(Directories.datadir);
 {$I+}
 if IOResult<>0 then
  begin
   messagedlg('Invalid data directory - Exit Time Chart',mtError,[mbOK],0);
   Application.Terminate
  end;
 Directories.blockdir:=Directories.datadir;
 Directories.textdir:=Directories.datadir;
 Directories.timedir:=Directories.datadir;
 getdirdlg.CancelBtn.caption:= 'Cancel';
  {ASSIGN Help file}
 s:=Directories.progdir;
 if s[length(s)] <> '\' then s:=s+'\';
 MainForm.HelpRouter1.helpfile:=s+'TC6.CHM';  {Assign Help file}
 Application.helpfile:=s+'TC6.CHM';  {Assign Help file}
// Get local copy of help file
 if (not HHLoaded) and ((copy(application.exename, 1, 2) = '\\') or (GetDriveType(PChar(extractFilePath(application.exename))) = DRIVE_REMOTE)) then
  begin
          { Here we go, we need a local copy of HELPMAN.CHM ... First check if a
            copy of the help file is already there (we do not delete this file)
            and if it is, check if it's up-to-date. We go by the file SIZE here.
            This is not 100% perfect but sufficient for our own help file. }
   strOriginalHelp := Application.Helpfile;
   if FileExists(strOriginalHelp) then
    begin
     strLocalHelp := GetTempDir;
     if copy(strLocalHelp,length(strLocalHelp),1)<>'\' then strLocalHelp:=strLocalHelp +  '\';  //only add slash if not already there
      strLocalHelp := strLocalHelp + extractFileName(Application.Helpfile);
     bLocal := FileExists(strLocalHelp) and (GetFileSize(strOriginalHelp) = GetFileSize(strLocalHelp));
     if not bLocal then
        bLocal := CopyFile(PChar(strOriginalHelp), PChar(strLocalHelp), False);
     if bLocal then
      begin
       Application.Helpfile := strLocalHelp;  //assign local help file
       MainForm.HelpRouter1.helpfile := strLocalHelp;
      end;
    end;
  end;

  {read in BACK.DAT - init first}
 backup_number:=1;
 backup_drive:='C';
 for i:=1 to nmbrBackupDisks do backupPath[i]:='C:\';
 LastUpdateCheck:=EncodeDate(2004,1,1);
 chdir(Directories.progdir);
 doAssignFile(backup,'BACK.DAT');
 if fileexists('BACK.DAT') then
  begin
   try
    try
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(backup,1);
     if filesize(backup)<10 then
      begin  {old format}
       blockread(backup,backup_action,2);
       setlength(backup_drive,1);
       blockread(backup,backup_drive[1],1);
       blockread(backup,backup_number,2);
       for i:=1 to nmbrBackupDisks do backupPath[i]:=backup_drive+':\';
      end
     else  {new format}
      begin
       blockread(backup,backup_number,sizeof(smallint));
       for i:=1 to nmbrBackupDisks do
        begin
         blockread(backup,StrLen,sizeof(smallint));
         SetLength(BackupPath[i],StrLen);
         blockread(backup,BackupPath[i][1],StrLen);
        end;
       blockread(backup,LastUpdateCheck,sizeof(tdatetime));
      end;
     IntRange(backup_number,1,nmbrBackupDisks);
    finally
     closefile(backup)
    end;
   except
   end;
  end
 else if (usrPassLevel>utGen) then updatebackupfile;
end;

function readFileLine(var f:file): string;
var
 s: string;
 ch:  char;
begin
 s:='';
 try
  while not eof(f) do
   begin
    blockread(f,ch,1);
    s:=s+ch;
    if copy(s,Length(s)-1,2)=endline then break;
   end;
  if copy(s,Length(s)-1,2)=endline then SetLength(s,Length(s)-2);
 except

 end;
 result:=trim(s);
end;

procedure getFaculty;
var
 i,j,k,m     : smallint;
 f     : file;
 tmpStr: string;
begin
 FacNum:=0;
 for i:=1 to nmbrFaculty do
  begin
   facCount[i]:=0; facName[i]:='';
   for j:=1 to nmbrSubsInFaculty do facSubs[i,j]:=0;
  end;
 if fileexists('FACULTY.DAT') then
  begin
   try
    try
     doAssignFile(f,'FACULTY.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(f,1);
     FileAge('FACULTY.DAT',NEW_DateChecks[14]);
     blockread(f,FacNum,2);
     IntRange(FacNum,0,nmbrFaculty);
     if FacNum>0 then
      for i := 1 to FacNum do
       begin
        facName[i]:=readFileLine(f);
        tmpStr:=readFileLine(f);
        facCount[i]:=strtointdef(tmpStr,0);
        if facCount[i]>0 then
         begin
          k:=0;
          for j:=1 to facCount[i] do
           begin
            tmpStr:=readFileLine(f);
            m:=strtointdef(tmpStr,0);
            if (m<>0) and (copy(SubCode[abs(m)],1,2)<>'00')
               and (abs(m)<=NumCodes[0]) and (abs(m)<>subNA)
               and (k<nmbrSubsInFaculty) then
             begin
              inc(k);
              facSubs[i,k]:=m;
             end;  {facCount[i]>0}
           end; {for j}
          facCount[i]:=k;
         end;
      end; {for i}
    finally
     closefile(f)
    end;
   except
   end;
  end {file exists}
 else
  begin
   makefile('FACULTY.DAT');
   FacNum:=0;
  end;
end;

function checkIfNeedClassConversion: wordbool;
var
 i,cL,y,cNold,a,k,j:              smallint;
 tmpfileSize: integer;
 f:              file;
 tmpFileName,h,y1,tmpS:    string;
 NewClassNames:  array of string[szClassName];

    function checkStudsforClassCode(j,y:smallint): wordbool;
    var
     k:      smallint;
    begin
     result:=false;
     for k:=1 to XML_STUDENTS.numstud do
      begin
       if XML_STUDENTS.Stud[k].TcYear<>y then continue;
       if XML_STUDENTS.Stud[k].TcClass=j then
        begin
         result:=true; break;
        end;
       end; {for k}
    end;

begin
 chdir(Directories.datadir);  result:=false;
 if not(fgConvertClassFlag) then exit;  //return false and don't force update
 try
  tmpFileName:='CLASS.DAT';
  if not(fileexists(tmpFileName)) then
   begin
    result:=true;
    exit;
   end
  else
   try
    doAssignFile(f,tmpFileName);
    filemode:=fmOpenRead+fmShareDenyNone;
    reset(f,1);
    blockread(f,cL,2);
    if cL>4 then result:=false;
   finally
    closefile(f);
   end;
  if cL>4 then exit;
  if cL=4 then
   begin //compare classn.dat codes to those in class.dat
  // get new ones
    try
     tmpFileName:='CLASS.DAT';
     try
      doAssignFile(f,tmpFileName);
      filemode:=fmOpenRead+fmShareDenyNone;
      reset(f,1);
      blockread(f,i,2);  //allready know it's 4 if we're here
      blockread(f,cNold,2);
      if cNold>0 then
       begin
        setlength(NewClassNames,cNold+1);
        for i:=1 to cNold do
         begin
          setlength(h,4); blockread(f,h[1],4);
          NewClassNames[i]:=trim(h);
         end; {for i}
       end;
     finally
      closefile(f);
     end;
    except
    end;

  // now loop through years and compare
    for y:=0 to (years-1) do
     begin
      y1:=inttostr(y+1); y1:=trim(y1);
      tmpFileName:='CLASS'+y1+'.DAT';
      if fileexists(tmpFileName) then
       try
        try
         doAssignFile(f,tmpFileName);
         filemode:=fmOpenRead+fmShareDenyNone;
         reset(f,1);
         tmpfileSize:=filesize(f);
         if (tmpfileSize=0) then continue;
         blockread(f,A,2);     IntRange(A,0,nmbrClass);
         k:=4;
         if A>0 then
          begin
           if A>cNold then
             begin result:=true; break; end;
           for j:=1 to A do
            begin
             SetLength(tmpS,k);
             blockread(f,tmpS[1],k);
             if trim(tmpS)>'' then
              if (trim(NewClassNames[j])<>trim(tmpS)) then
               if checkStudsforClassCode(j,y) then
                begin
                 result:=true;
                 break;
                end;
            end;  {for j}
          end; {if A>0}
        finally
         closefile(f);
        end;
       except
       end;

      if result=true then break; //only need one mismatch
     end; {for y}
   end; {if cL=4 then}
 except
 end;
end;

function getNewClasses: wordbool;
var
 i:     smallint;
 f:         file;
 tmpFileName,h:      string;
begin
 chdir(Directories.datadir); result:=false;
 try
  tmpFileName:='CLASS.DAT';
  if not(fileexists(tmpFileName)) then exit;
  try
   result:=true;
   doAssignFile(f,tmpFileName);
   filemode:=fmOpenRead+fmShareDenyNone;
   reset(f,1);
   FileAge('CLASS.DAT',NEW_DateChecks[4]);
   blockread(f,LenClassCodes,2);
   IntRange(LenClassCodes,1,szClassName);
   blockread(f,classnum,2);
   if classnum>0 then
    for i:=1 to classnum do
     begin
      setlength(h,LenClassCodes{+1});
      blockread(f,h[1],LenClassCodes);
      ClassCode[i]:=trim(h);
     end; {for y}
   finally
    closefile(f);
   end;
  except
  end;
 updateRollClassPoint;
end;

procedure tenderNewClass(ss: string; ii: smallint; yy:smallint);
var
 i,j,sci,scy:     smallint;
 a:     string;
begin
 if trim(ss)='' then exit;
 j:=0;
 a:=uppercase(trim(ss));
 if classnum>0 then
  for i:=1 to classnum do
   if a=uppercase(trim(ClassCode[i])) then
    begin j:=i; break; end;

 if j=0 then {not there - so add it}
 begin
  inc(classnum); j:=classnum;
  ClassCode[classnum]:=trim(ss);
 end;
 if ii<=level[yy] then ClassShown[ii,yy]:=j; {init show for old class file}

 if j>0 then  {class code already there - need to alter stud data to match existing code}
 begin
  if XML_STUDENTS.numstud>0 then
   for sci:=1 to XML_STUDENTS.numstud do
   begin
    scy:=XML_STUDENTS.Stud[sci].Tcyear;
    if scy<>yy then continue;
    if XML_STUDENTS.Stud[sci].TcClass=ii then
    begin
      XML_STUDENTS.Stud[sci].TcClass:=-j;
      StudYearFlag[yy]:=true;
     end;
   end; {for ssci}
 end;
end;


procedure LoadRollClasses;
var
 i,j,k       : smallint;
 f           : file;
 a           : smallint;
 y1,tmpS     : string;
 tmpFileName : string;
 tmpfileSize : longint;
begin
 setlength(RollClassPoint,nmbrClass+1);
 setlength(ClassCode,nmbrClass+1);
 LenClassCodes:=4; //default value if nothing else set

 if not(checkIfNeedClassConversion) then
  if getNewClasses then exit;  {check for new classes.dat file}

 classnum:=0;
 for j:=0 to nmbrClass do ClassCode[j]:=Space(szClassName);
 for i:=0 to (years-1) do
  begin
   y1:=IntToStr(i+1); y1:=trim(y1);
   tmpFileName:='CHOICE'+y1+'.ST';
   if not (fileexists(tmpFileName)) then makefile(tmpFileName);
     tmpFileName:='CLASS'+y1+'.DAT';
     if fileexists(tmpFileName) then
      try
       try
        doAssignFile(f,tmpFileName);
        filemode:=fmOpenRead+fmShareDenyNone;
        reset(f,1);
        tmpfileSize:=fileSize(f);
        if (tmpfileSize=0) then continue;
        blockread(f,a,2);
        IntRange(a,0,nmbrClass);
        k:=4; LenClassCodes:=k;
        if a>0 then
         for j:=1 to a do
          begin
           SetLength(tmpS,k);
           blockread(f,tmpS[1],k);
           tenderNewClass(tmpS,j,i)
          end; {for j}
       finally
        closefile(f)
       end;
      except
      end;
  end; {for i}
 for i:=1 to XML_STUDENTS.numstud do
  begin
   XML_STUDENTS.Stud[i].tcClass:=abs(XML_STUDENTS.Stud[i].tcClass);
   StudYearFlag[XML_STUDENTS.Stud[i].TcYear]:=true;
  end;
 updateClass; {save new format}
 saveCLSfile; //force save of new cls file for classes on ttable etc.
 CountGroupSubs;
 SaveAllStudentYears;
 updateRollClassPoint;
end;


procedure HouseLoad;
var
 i: smallint;
 f: file;
begin
 housecount:=0;
 for i:=0 to nmbrHouse do HouseName[i]:='';
 if fileexists('HOUSE.DAT') then
  begin
   try
    try
     doAssignFile(f,'HOUSE.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(f,1);
     FileAge('HOUSE.DAT',NEW_DateChecks[3]);
     blockread(f,housecount,2);
     IntRange(housecount,0,nmbrHouse);
     if housecount>0 then
      for i:=1 to housecount do
       begin
        SetLength(HouseName[i],szHouseName);
        blockread(f,HouseName[i][1],szHouseName);
        HouseName[i]:=trim(HouseName[i])
       end;
    finally
     closefile(f)
    end;
   except
   end;
  end
 else
  begin
   makefile('HOUSE.DAT');
   housecount:=0;
  end;
end;

procedure LoadTagNames;
var
 tagFile:  file;
 i,j,StrLen: smallint;
 StrA: string;
begin
 for i:=1 to nmbrTags do
  begin
   TagName[i]:='No. '+inttostr(i);
   if i>9 then TagCode[i]:=chr(87+i) else TagCode[i]:=chr(48+i);
  end;
 try
  if fileexists('TAG.DAT') then
   try
    assignfile(tagFile,'TAG.DAT');
    filemode:=fmOpenRead+fmShareDenyNone;
    reset(tagFile,1);
    blockread(tagFile,j,2);
    IntRange(j,0,nmbrTags);
    if j>0 then
     for i:=1 to j do
      begin
       TagCode[i]:=' ';
       blockread(tagFile,TagCode[i][1],1);
       blockread(tagFile,StrLen,2);
       if StrLen>0 then
        begin
         IntRange(StrLen,1,szTagname);
         StrA:=space(StrLen);
         blockread(tagFile,StrA[1],StrLen);
         TagName[i]:=trim(StrA);
        end;
      end;
   finally
    CloseFile(tagFile);
   end;
 except
 end;
end;

procedure getCodes;
begin
 getSubjectCodes;
 getRoomCodes;
 getTeacherCodes;
 getFaculty;
 HouseLoad;
 LoadTagNames;
end;

procedure rangecheckwinpos(i: smallint);
var
 j: smallint;
begin
 j:=smallint(XML_DISPLAY.winpos[i].state);
 IntRange(j,0,2);
 XML_DISPLAY.winpos[i].state:=Twindowstate(j);
 IntRange(XML_DISPLAY.winpos[i].width,0,mainform.clientwidth);
 IntRange(XML_DISPLAY.winpos[i].height,0,mainform.clientheight);
  // don't force anything on toolbar positions
 if ((i=wnGenTool) or (i=wnTtTool) or (i=wnBlTool)) then exit;
 IntRange(XML_DISPLAY.winpos[i].top,0,mainform.clientheight);
 IntRange(XML_DISPLAY.winpos[i].left,0,mainform.clientwidth)
end;

procedure InitWinDisplay;
var
 i,j: smallint;
begin
 {codes}
 for i:=0 to 2 do XML_DISPLAY.sortType[i]:=1;
 {time format}
 longtimeformat:='h:mmam/pm';
 {stud list}
 XML_DISPLAY.StudListType:=2;
 XML_DISPLAY.listnumbertype:=1;
 XML_DISPLAY.listEnrolment:=false;
 for i:=1 to 4 do
  for j:=1 to 2 do XML_DISPLAY.listRanges[i,j]:=0;
 ListStudentSelection[0]:=0;

 {edit student}
 XML_DISPLAY.sTfind:=1;
 XML_DISPLAY.commonDataAll:=true;
 XML_DISPLAY.editBlockCheck:=true;

   {sub list win}
 XML_DISPLAY.sublistfacnum:=0;  XML_DISPLAY.fgsubBySubListZeroSkip:=false;
 for i:=-2 to nmbrOfGroupSubjects do XML_DISPLAY.sublistRanges[i]:=0;
 XML_DISPLAY.SubListType:=1;  XML_DISPLAY.SubListGroupType:=1;
 XML_DISPLAY.sublistfree:=0; {0,1,2 - in subs, not in subs, not in timeslot}
 XML_DISPLAY.sublistday:=0;
 XML_DISPLAY.sublisttime1:=0;
 XML_DISPLAY.sublisttime2:=0;

 {student tt}
 XML_DISPLAY.stuttEnrolment:=false;
 XML_DISPLAY.StudentTtSelection[0]:=0;
 XML_DISPLAY.StudTtListType:=2;
 for i:=1 to 8 do XML_DISPLAY.stuttlistVals[i]:=0;

 {teacher tt}
 XML_DISPLAY.tettLoads:=false;
 XML_DISPLAY.TeTtSelection[0]:=0;
 XML_DISPLAY.tettseltype:=1; {all}
 for i:=1 to 3 do
    XML_DISPLAY.tettlistVals[i]:= 1;
 for i:=4 to 5 do
    XML_DISPLAY.tettlistVals[i]:=0; {day from/to}
 XML_DISPLAY.tettlistVals[3]:=0; {no fac}

  {room tt}
 XML_DISPLAY.RoTtSelection[0]:=0;
 XML_DISPLAY.rottseltype:=1; {all}
 for i:=1 to 3 do XML_DISPLAY.rottlistVals[i]:=1;
 for i := 4 to 5 do XML_DISPLAY.rottlistVals[i]:=0; {day from/to}
 XML_DISPLAY.rottlistVals[3]:=0; {no fac}

 {sub tt}
 XML_DISPLAY.subttlistSelection:=3; {level}
 for i:= 1 to 4 do XML_DISPLAY.stuttlistVals[i]:=1;
 subttGroupCnt:=0;
 XML_DISPLAY.subttWide:=false;

 {timetable entry dialog}
 XML_DISPLAY.trackflag:=true;

 {tt prnt sel}
 XML_DISPLAY.ttPrntSelSubg[0]:=0;
 XML_DISPLAY.ttPrntSelTeachg[0]:=0;
 XML_DISPLAY.ttprntselroomg[0]:=0;
 XML_DISPLAY.ttprntseltype:=0;
 XML_DISPLAY.ttPrntFac:=0;
 XML_DISPLAY.ttprntselday:=0;
 XML_DISPLAY.ttprntselyear:=0;
 XML_DISPLAY.ttPrntType:=0;

 {group of teachers}
 XML_DISPLAY.GrpOfTeSelSubg[0]:=0;
 XML_DISPLAY.grpofteyear:=0;
 XML_DISPLAY.grpofteclass:=0;
 XML_DISPLAY.grpoftelevel:=1;
 XML_DISPLAY.grpoftefac:=0;
 XML_DISPLAY.grpofteday:=0;
 XML_DISPLAY.grpoftetimes:=1;

 {clash matrix sel dlg}
 XML_DISPLAY.ClashMatrixSelection[0]:=-1;

 {teachers free dlg}
 XML_DISPLAY.TeFreeSelect[0]:=0; {zero index is count}
 XML_DISPLAY.teachersfreeday:=-1; {0-days, if =days means all days, -1 not selected}
 XML_DISPLAY.TeFreePeriod:=-1;
 XML_DISPLAY.teachersfreefac:=-1;
 XML_DISPLAY.teachersfreeshow1:=1;
 XML_DISPLAY.teachersfreeshow2:=1;

 {rooms free dlg}
 XML_DISPLAY.RoomsFreeSelection[0]:=0; {zero index is count}
 XML_DISPLAY.roomsfreeday:=-1; {all days}
 XML_DISPLAY.roomsfreePeriod:=-1;
 XML_DISPLAY.roomsfreefac:=-1;
 XML_DISPLAY.roomsfreeshow1:=1;
 XML_DISPLAY.roomsfreeshow2:=1;

 {teacher times dlg}
 XML_DISPLAY.TeTimesSelect[0]:=0;
 XML_DISPLAY.teachertimesyear:=0; {0-days, if =days means all days}
 XML_DISPLAY.teachertimesfac:=0;
 XML_DISPLAY.teachertimesshow1:=1;
 XML_DISPLAY.teachertimesshow2:=1;

 {telist dlg}
 XML_DISPLAY.TeListSelection[0]:=0;
 XML_DISPLAY.TeListFac:=0;   {no selection}
 XML_DISPLAY.TeListShow:=1; {all teachers}

 {subject times dlg}
 XML_DISPLAY.subjecttimesyear:=0;
 XML_DISPLAY.subjecttimesfac:=0;
 XML_DISPLAY.subjecttimesshow2:=1;

 {student input}
 XML_DISPLAY.StudentInputSelection[0]:=0;
 XML_DISPLAY.StInputPref1:=6;
 XML_DISPLAY.StInputPref2:=0;
 XML_DISPLAY.StInputClass:=0;
 XML_DISPLAY.StInputHouse:=0; {all}
 XML_DISPLAY.StInputTutor:=0; {all}
 XML_DISPLAY.StInputRoom:=0; {all}
 XML_DISPLAY.studentinputshow1:=3; {full name for subs}
 XML_DISPLAY.studentinputshow2:=2; {group}
 XML_DISPLAY.StInputDlgPageIndex:=0;
 OfferFile:='';  OfferBlocks:='';  OfferSections:=1;  OfferBlockFlag:=false;
 OfferSubMax:=10;  SetSubOfferArrays;
 OfferTitle[1]:=''; OfferDesc[1]:=''; OfferSubs[1,0]:=0;

 {promote students}
 XML_DISPLAY.clearstudentchoicesflag:=false;

 {teacher clashes}
 XML_DISPLAY.tcCurPeriodOnly:=false;

 {room clashes}
 XML_DISPLAY.rcCurPeriodOnly := false; {not for cur period only}

 {blocks window}
 XML_DISPLAY.blocknum:=6;
 XML_DISPLAY.blocklevel:=6;

 {margins etc}
 XML_DISPLAY.prntLeftMargin:=0;
 XML_DISPLAY.prntTopMargin:=0;
 XML_DISPLAY.datestamp:=true;

 {preferences - general}
 XML_DISPLAY.prefNotebookPageIndex:=0;
 XML_DISPLAY.Formfeed:=true;
 XML_DISPLAY.colorPrinterFlag:=false;

 {preferences - student section}
 XML_DISPLAY.sTsex:=true;
 XML_DISPLAY.sTclass:=true;
 XML_DISPLAY.sThouse:=true;
 XML_DISPLAY.sTID:=true;
 XML_DISPLAY.sTyear:=true;
 XML_DISPLAY.sTtutor:=true;
 XML_DISPLAY.sThome:=true;
 XML_DISPLAY.sTtag:=true;
 XML_DISPLAY.double_space:=false;
 XML_DISPLAY.double_print:=1;
 XML_DISPLAY.blockshow:=false;
 XML_DISPLAY.sTselect := 1; //1=other subs      {0-3}
 XML_DISPLAY.sexselect:=0;
 XML_DISPLAY.listShowClashes:=true;
 XML_DISPLAY.MatchAllYears:=false;

 {preferences - timetable section}
 for i:=0 to nmbrDays do
  for j:=0 to nmbrPeriods do XML_DISPLAY.tsOn[i,j]:=true;
 for i:=0 to nmbrYears do XML_DISPLAY.Pyear[i]:=true;
 for i:=1 to nmbrDays do XML_DISPLAY.Dprint[i]:=true;
 XML_DISPLAY.Tfreeshow:=false;
 XML_DISPLAY.Rfreeshow:=false;
 XML_DISPLAY.ttWeekDaysFlg:=false;
 XML_DISPLAY.ttClockShowFlg:=false;
 XML_DISPLAY.fsDoRoomCap:=true;
 XML_DISPLAY.Pweek:=1; {weekly tt's per page}
 XML_DISPLAY.Tyr:= 1; //year

 {preferences - general page}
 XML_DISPLAY.globalHints:=true;
 XML_DISPLAY.OKbackup:=true;
 XML_DISPLAY.OKquitcheck:=true;
 XML_DISPLAY.Txtlim:=0;
 XML_DISPLAY.Txtsep:=44; {comma}
 XML_DISPLAY.showHintsDlg:=true;
 XML_DISPLAY.GenericTtableFlag:=true;
 XML_DISPLAY.customFileLoadFlag:=false;
 XML_DISPLAY.OnlineUpdateCheck:=1;
 XML_DISPLAY.FAfirst:=true;
 XML_DISPLAY.FAyear:=true;
 XML_DISPLAY.FAsex:=true;
 XML_DISPLAY.FAID:=true;
 XML_DISPLAY.FAclass:=true;
 XML_DISPLAY.FAhouse:=true;
 XML_DISPLAY.FAtutor:=false;
 XML_DISPLAY.FAhome:=false;
 XML_DISPLAY.FAsubnum:=0;
 XML_DISPLAY.FAreplace:=true;
 XML_DISPLAY.customFileLoad:='';
 XML_DISPLAY.FExportFileIdx := 0;

 {block dialogues}
 XML_DISPLAY.MaxClassSize:=25;
 XML_DISPLAY.BLsolution:=5;
 XML_DISPLAY.BLtries:=50;
 XML_DISPLAY.ExcludeClassSize:=26;
 XML_DISPLAY.SplitDiff:=true;
 sexbalance:=0;
 XML_DISPLAY.autobalance:=1;
 XML_DISPLAY.balanceflag:=1;

 {build dialogue}
 XML_DISPLAY.abOverwrite:=false;

 {alter dialogues}
 XML_DISPLAY.AlterBox:=0;
 XML_DISPLAY.wsAlterBox:=0;

 {search and replace}
 XML_DISPLAY.SearchBox:=0;

 {clash help}
 XML_DISPLAY.chScope:=0;
 XML_DISPLAY.chType:=2;

 {edit faculty dialogue}
 XML_DISPLAY.EdfacSubType:=0;

 {timetable window}
 XML_DISPLAY.EntrySelectionLink:=false;

 {students in time slot}
 XML_DISPLAY.sublistYear:=0;

 {print preview}
 XML_DISPLAY.PreviewLastZoom:=9; {whole page}

 {custom versions}
 XML_DISPLAY.OberonOutputType:=0; {use separator}

 {find student}
 XML_DISPLAY.UseGroupFindStud:=true;
end;

procedure singlerangecheck(var i: single; j,k: single);
begin
 try
  if i<=j then i:=j
   else if i>k then i:=k;
 except
  on EInvalidOp do i:=j;
 end; {try}
end;


procedure loadDisplayFile(displayFile:string);
var
 winfile: file;
 i,j      : smallint;
 tmpInt,dummy: smallint;

  lAmtTransferred: Integer;

  function BlockReadInt2(a,b: smallint): smallint;
  var
   c: smallint;
  begin
   blockread(winfile,c,2);
   IntRange(c,a,b);
   result:=c;
  end;

begin
 if fileexists(displayFile) then
  try
   try
    doAssignFile(winfile,displayFile);
    filemode:=fmOpenRead+fmShareDenyNone;
    reset(winfile,1);
 {signature}
    XML_DISPLAY.DisplayHeader[0]:=chr(4); // setting the length of the string
    blockread(winfile,XML_DISPLAY.DisplayHeader[1],4); // reading fixed width 4 characters as the DisplayHeader
    if XML_DISPLAY.DisplayHeader <> 'TC52' then exit;
    try  {time chart's font}
     blockread(winfile,XML_DISPLAY.fontlen,1);
     SetLength(XML_DISPLAY.tmpStr,XML_DISPLAY.fontlen);
     blockread(winfile,XML_DISPLAY.tmpStr[1],XML_DISPLAY.fontlen);
     XML_DISPLAY.tcfont.Name:=trim(XML_DISPLAY.tmpStr);
     blockread(winfile,XML_DISPLAY.tmpFs,sizeof(tFontStyles));
    {ensure no underline OR EVEN STRIKEOUT gets turned on on corrupt file (1byte file will do it)}
     XML_DISPLAY.tcfont.style:=[fsbold,fsItalic]*XML_DISPLAY.tmpFs;
     blockread(winfile,i,2);  if (i<4) or (i>99) then i:=12;
     XML_DISPLAY.tcfont.Size:=i
    except
     XML_DISPLAY.tcfont.Name:='Ariel';
     XML_DISPLAY.tcfont.Size:=8;
     XML_DISPLAY.tcfont.style:=[fsbold];
    end;
 {window pos}
    XML_DISPLAY.winOrderNum:=BlockReadInt2(0,nmbrWindows); // reads counter from next position and checks no bigger than nmbrWindows
    if XML_DISPLAY.winOrderNum>0 then
     for i:= 1 to XML_DISPLAY.winOrderNum do
      XML_DISPLAY.winOrder[i]:=BlockReadInt2(0,nmbrWindows);
    tmpInt:=BlockReadInt2(0,nmbrWindows);
    if tmpInt>0 then
     for i:= 0 to tmpInt do
      begin
       blockread(winfile,XML_DISPLAY.winpos[i],sizeof(XML_DISPLAY.winpos[i]));
       rangecheckwinpos(i)
      end;  {for i}
 {codes sort order}
    for i:=0 to 2 do XML_DISPLAY.sortType[i]:=BlockReadInt2(0,2);
 {student list}
    XML_DISPLAY.StudListType:=BlockReadInt2(1,7);
    XML_DISPLAY.listnumbertype:=BlockReadInt2(1,6);
    XML_DISPLAY.sTfind:=BlockReadInt2(1,9);
    for i:=1 to 4 do
      for j := 1 to 2 do
        blockread(winfile,XML_DISPLAY.listRanges[i,j],2);
    for j:=1 to 2 do
      IntRange(XML_DISPLAY.listRanges[1,j],0,classnum);
    for j:=1 to 2 do
      IntRange(XML_DISPLAY.listRanges[2,j],0,housecount);
    for j:=1 to 2 do
      IntRange(XML_DISPLAY.listRanges[3,j],0,NumCodes[1]);
    for j:=1 to 2 do
      IntRange(XML_DISPLAY.listRanges[4,j],0,NumCodes[2]);
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrstudents);
    ListStudentSelection[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
        blockread(winfile,ListStudentSelection[i],2);
    rangeCheckStudSels(ListStudentSelection);
 {edit student}
    blockread(winfile,XML_DISPLAY.commonDataAll,2);
    blockread(winfile,XML_DISPLAY.editBlockCheck,2);
 {sub list dialog}
    XML_DISPLAY.SubListType:=BlockReadInt2(1,5);
    XML_DISPLAY.SubListGroupType:=BlockReadInt2(1,3);

    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrOfGroupSubjects);
    for i:=-2 to -1 do
      XML_DISPLAY.sublistRanges[i]:=BlockReadInt2(0,NumCodes[0]); {range subs}
    XML_DISPLAY.sublistRanges[0]:=BlockReadInt2(0,nmbrOfGroupSubjects); {count}
    for i:=1 to XML_DISPLAY._cI do
      XML_DISPLAY.sublistRanges[i]:=BlockReadInt2(-NumCodes[0],NumCodes[0]); {actual subs list}

    XML_DISPLAY.sublistfacnum:=BlockReadInt2(0,FacNum);
 {students in time slot}
    XML_DISPLAY.sublistday:=BlockReadInt2(0,days-1);
    XML_DISPLAY.sublisttime1:=BlockReadInt2(0,periods-1);
    XML_DISPLAY.sublisttime2:=BlockReadInt2(0,periods-1);
    XML_DISPLAY.sublistfree:=BlockReadInt2(0,2);
 {stud ttable}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrstudents);
      XML_DISPLAY.StudentTtSelection[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
      for i:=1 to XML_DISPLAY._cI do
        blockread(winfile,XML_DISPLAY.StudentTtSelection[i],2);
    rangeCheckStudSels(XML_DISPLAY.StudentTtSelection);
    XML_DISPLAY.StudTtListType:=BlockReadInt2(1,6);
    blockread(winfile,XML_DISPLAY.stuttEnrolment,2);
    for i:=1 to 8 do
      blockread(winfile,XML_DISPLAY.stuttlistVals[i],2);
    for i:=1 to 2 do
      IntRange(XML_DISPLAY.stuttlistVals[i],0,XML_STUDENTS.numstud);
    IntRange(XML_DISPLAY.stuttlistVals[3],0,classnum);
    IntRange(XML_DISPLAY.stuttlistVals[4],0,housecount);
    IntRange(XML_DISPLAY.stuttlistVals[5],0,NumCodes[1]);
    IntRange(XML_DISPLAY.stuttlistVals[6],0,NumCodes[2]);
    for i:=7 to 8 do IntRange(XML_DISPLAY.stuttlistVals[i],0,days-1);
 {teach ttable}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrteachers);
    XML_DISPLAY.TeTtSelection[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
      XML_DISPLAY.TeTtSelection[i]:=BlockReadInt2(0,NumCodes[1]);

    XML_DISPLAY.tettseltype:=BlockReadInt2(1,2);
    blockread(winfile,XML_DISPLAY.tettLoads,2);
    for i:=1 to 2 do
      XML_DISPLAY.tettlistVals[i]:=BlockReadInt2(1,NumCodes[1]);
    XML_DISPLAY.tettlistVals[3]:=BlockReadInt2(0,FacNum);
    for i:=4 to 5 do
      XML_DISPLAY.tettlistVals[i]:=BlockReadInt2(0,days-1);
 {room ttable}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrteachers);
    XML_DISPLAY.RoTtSelection[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
      XML_DISPLAY.RoTtSelection[i]:=BlockReadInt2(0,NumCodes[2]);
    XML_DISPLAY.rottseltype:=BlockReadInt2(1,2);
    blockread(winfile,XML_DISPLAY.OnlineUpdateCheck,2);
    if ((XML_DISPLAY.OnlineUpdateCheck<0) or (XML_DISPLAY.OnlineUpdateCheck>4))
          then XML_DISPLAY.OnlineUpdateCheck:=1;
    for i:=1 to 2 do
        XML_DISPLAY.rottlistVals[i]:=BlockReadInt2(1,NumCodes[2]);
    XML_DISPLAY.rottlistVals[3]:=BlockReadInt2(0,FacNum);
    for i:=4 to 5 do
        XML_DISPLAY.rottlistVals[i]:=BlockReadInt2(0,days-1);
 {sub ttable}

    XML_DISPLAY.subttlistSelection:=BlockReadInt2(1,3);
    XML_DISPLAY.subttlistVals[1]:=BlockReadInt2(0,years-1);
    XML_DISPLAY.subttlistVals[2]:=BlockReadInt2(0,level[XML_DISPLAY.subttlistVals[1]]);
    XML_DISPLAY.subttlistVals[3]:=BlockReadInt2(0,days-1);
    XML_DISPLAY.subttlistVals[4]:=BlockReadInt2(0,periods-1);
    XML_DISPLAY._cI:=BlockReadInt2(0,NumCodes[0]);
    subttGroupCnt:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i := 1 to XML_DISPLAY._cI do
      XML_DISPLAY.SubTtGroup[i]:=BlockReadInt2(0,NumCodes[0]);
 {tt prnt seldlg}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrSubjects);

    XML_DISPLAY.ttPrntSelSubg[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
        XML_DISPLAY.ttPrntSelSubg[i]:=BlockReadInt2(0,NumCodes[0]);
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrteachers);
    XML_DISPLAY.ttPrntSelTeachg[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
      XML_DISPLAY.ttPrntSelTeachg[i]:=BlockReadInt2(0,NumCodes[1]);
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrRooms);
    XML_DISPLAY.ttprntselroomg[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
      XML_DISPLAY.ttprntselroomg[i]:=BlockReadInt2(0,NumCodes[2]);
    XML_DISPLAY.ttprntseltype:=BlockReadInt2(0,4);
    XML_DISPLAY.ttPrntFac:=BlockReadInt2(0,FacNum);
    XML_DISPLAY.ttprntselday:=BlockReadInt2(-1,days-1); {-1 all days}
    XML_DISPLAY.ttprntselyear:=BlockReadInt2(-1,years-1);
    XML_DISPLAY.ttPrntType:=BlockReadInt2(0,1); {0- main, 1- year tt}
 {group of teachers}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrteachers);
    XML_DISPLAY.GrpOfTeSelSubg[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
     XML_DISPLAY.GrpOfTeSelSubg[i]:=BlockReadInt2(0,NumCodes[1]);
    blockread(winfile,dummy,2);    {was grpofteshow}
    XML_DISPLAY.grpofteyear:=BlockReadInt2(0,years);
    XML_DISPLAY.grpofteclass:=BlockReadInt2(0,nmbrClass);
    XML_DISPLAY.grpoftelevel:=BlockReadInt2(1,LevelMax);
    XML_DISPLAY.grpoftefac:=BlockReadInt2(0,FacNum);
    XML_DISPLAY.grpofteday:=BlockReadInt2(0,days);
    XML_DISPLAY.grpoftetimes:=BlockReadInt2(0,periods);
 {clash matrix sel dlg}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrSubYear);
    XML_DISPLAY.ClashMatrixSelection[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
      XML_DISPLAY.ClashMatrixSelection[i]:=BlockReadInt2(0,NumCodes[0]);
    blockread(winfile,dummy,2);
 {teachers free dlg}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrteachers);
    XML_DISPLAY.TeFreeSelect[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
      XML_DISPLAY.TeFreeSelect[i]:=BlockReadInt2(0,NumCodes[1]);
    XML_DISPLAY.teachersfreeday:=BlockReadInt2(-1,days-1);
    XML_DISPLAY.TeFreePeriod:=BlockReadInt2(-1,periods+1);
    XML_DISPLAY.teachersfreefac:=BlockReadInt2(-1,FacNum);
    XML_DISPLAY.teachersfreeshow1:=BlockReadInt2(1,3);
    XML_DISPLAY.teachersfreeshow2:=BlockReadInt2(1,3);
    XML_DISPLAY.teFreeYear:=BlockReadInt2(-1,years_minus_1-1);
 {rooms free dlg}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrteachers);
    XML_DISPLAY.RoomsFreeSelection[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
        XML_DISPLAY.RoomsFreeSelection[i]:=BlockReadInt2(0,NumCodes[2]);
    XML_DISPLAY.roomsfreeday:=BlockReadInt2(-1,days-1);
    XML_DISPLAY.roomsfreePeriod:=BlockReadInt2(-1,periods);
    XML_DISPLAY.roomsfreefac:=BlockReadInt2(-1,FacNum);
    XML_DISPLAY.roomsfreeshow1:=BlockReadInt2(1,3);
    XML_DISPLAY.roomsfreeshow2:=BlockReadInt2(1,2);
 {teachers times dlg}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrteachers);
    XML_DISPLAY.TeTimesSelect[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
        XML_DISPLAY.TeTimesSelect[i]:=BlockReadInt2(0,NumCodes[1]);
    XML_DISPLAY.teachertimesyear:=BlockReadInt2(0,years);
    XML_DISPLAY.teachertimesfac:=BlockReadInt2(0,FacNum);
    XML_DISPLAY.teachertimesshow1:=BlockReadInt2(1,3);
    XML_DISPLAY.teachertimesshow2:=BlockReadInt2(1,3);
 {teacher list dlg}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrteachers);
    XML_DISPLAY.TeListSelection[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
        XML_DISPLAY.TeListSelection[i]:=BlockReadInt2(0,NumCodes[1]);
    XML_DISPLAY.teListFac:=BlockReadInt2(0,FacNum);
    XML_DISPLAY.teListShow:=BlockReadInt2(1,2);
 {subject times dlg}
    XML_DISPLAY.subjecttimesyear:=BlockReadInt2(0,years);
    blockread(winfile,XML_DISPLAY.subjecttimesfac,2);
    if XML_DISPLAY.subjectTimesFac=FacNum+1 then
          XML_DISPLAY.SubjectTimesFac:=0;
    IntRange(XML_DISPLAY.subjecttimesfac,0,FacNum); {0 all faculties}
    XML_DISPLAY.subjecttimesshow2:=BlockReadInt2(1,3);
 {student input}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrstudents);
    XML_DISPLAY.StudentInputSelection[0]:=XML_DISPLAY._cI;
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
        blockread(winfile,XML_DISPLAY.StudentInputSelection[i],2);
    rangeCheckStudSels(XML_DISPLAY.StudentInputSelection);
    XML_DISPLAY.StInputPref1:=BlockReadInt2(1,nmbrchoices);
    XML_DISPLAY.StInputPref2:=BlockReadInt2(0,nmbrchoices);
    XML_DISPLAY.StInputClass:=BlockReadInt2(0,classnum);
    XML_DISPLAY.StInputHouse:=BlockReadInt2(0,housecount);
    XML_DISPLAY.StInputTutor:=BlockReadInt2(0,NumCodes[1]);
    XML_DISPLAY.StInputRoom:=BlockReadInt2(0,NumCodes[2]);
    XML_DISPLAY.studentinputshow1:=BlockReadInt2(0,4);
    XML_DISPLAY.studentinputshow2:=BlockReadInt2(1,6);

 {promote students}
    blockread(winfile,XML_DISPLAY.clearstudentchoicesflag,2);
 {teaacher clashes}
    blockread(winfile,XML_DISPLAY.tcCurPeriodOnly,2);
 {room clashes}
    blockread(winfile,XML_DISPLAY.rcCurPeriodOnly,2);
 {block defaults}
    XML_DISPLAY.blocknum:=BlockReadInt2(2,nmbrBlocks);
     blockread(winfile,XML_DISPLAY.blocklevel,2);
 {margins etc}
    blockread(winfile,XML_DISPLAY.prntLeftMargin,4);
    singlerangecheck(XML_DISPLAY.prntLeftMargin,0,99);
    blockread(winfile,XML_DISPLAY.prntTopMargin,4);
    singlerangecheck(XML_DISPLAY.prntTopMargin,0,99);
    blockread(winfile,XML_DISPLAY.datestamp,2);
 {preferences - general section }
    XML_DISPLAY.prefNotebookPageIndex:=BlockReadInt2(0,3);
    blockread(winfile,XML_DISPLAY.sTtag,2);
    blockread(winfile,XML_DISPLAY.colorPrinterFlag,sizeof(XML_DISPLAY.colorPrinterFlag));
 {preferences - student section}
    blockread(winfile,XML_DISPLAY.sTsex,2);
    blockread(winfile,XML_DISPLAY.sTclass,2);
    blockread(winfile,XML_DISPLAY.sThouse,2);
    blockread(winfile,XML_DISPLAY.sTID,2);
    blockread(winfile,XML_DISPLAY.sTtutor,2);
    blockread(winfile,XML_DISPLAY.sThome,2);
    blockread(winfile,XML_DISPLAY.double_space,2);
    XML_DISPLAY.double_print:=1;
    if XML_DISPLAY.double_space then
      XML_DISPLAY.double_print:=2;
    blockread(winfile,XML_DISPLAY.blockshow,2);
    XML_DISPLAY.sTselect:=BlockReadInt2(0,3);
    XML_DISPLAY.sexselect:=BlockReadInt2(0,2);
    XML_DISPLAY.PreviewLastZoom:=BlockReadInt2(0,9);
    blockread(winfile,XML_DISPLAY.listEnrolment,2);
    blockread(winfile,XML_DISPLAY.listShowClashes,2);
 {preferences - timetable section}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrPeriods);
    if XML_DISPLAY._cI>0 then
     for i:=0 to XML_DISPLAY._cI-1 do
        blockread(winfile,XML_DISPLAY.tsOn[0,i],sizeof(boolean));
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrYears);
    if XML_DISPLAY._cI>0 then
     for i:=0 to XML_DISPLAY._cI do
        blockread(winfile,XML_DISPLAY.Pyear[i],sizeof(boolean));
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrDays);
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
        blockread(winfile,XML_DISPLAY.Dprint[i],sizeof(boolean));
    blockread(winfile,XML_DISPLAY.Tfreeshow,2);
    blockread(winfile,XML_DISPLAY.Rfreeshow,2);
    XML_DISPLAY.Pweek:=BlockReadInt2(1,9); {weekly tt per page}
    XML_DISPLAY.Tyr:=BlockReadInt2(0,3);
    blockread(winfile,XML_DISPLAY.ttWeekDaysFlg,2);
    blockread(winfile,XML_DISPLAY.ttClockShowFlg,2);
 {StripRooms dialogue}
    blockread(winfile,XML_DISPLAY.fsDoRoomCap,2);
 {Alter Worksheet dialogue}
    XML_DISPLAY.wsAlterBox:=BlockReadInt2(0,1);

 {block dialogues}
    XML_DISPLAY.MaxClassSize:=BlockReadInt2(1,nmbrstudents);
    XML_DISPLAY.BLsolution:=BlockReadInt2(1,100);
    XML_DISPLAY.BLtries:=BlockReadInt2(XML_DISPLAY.BLsolution,1000);
    XML_DISPLAY.ExcludeClassSize:=BlockReadInt2(1,nmbrstudents);
    blockread(winfile,XML_DISPLAY.SplitDiff, 2);
    XML_DISPLAY.autobalance:=BlockReadInt2(0,1);
    XML_DISPLAY.balanceflag:=BlockReadInt2(0,1);
 {timetable dialogues - entry dialogue}
    blockread(winfile,XML_DISPLAY.trackflag,2);
 {Student Paset dialogue}
    XML_DISPLAY.StudPasteID:=BlockReadInt2(0,2);  {was abSingle}
    XML_DISPLAY.StudPasteSub:=BlockReadInt2(0,1); {was abDouble}
    XML_DISPLAY.StudPasteFields:=BlockReadInt2(0,1);  {was abTriple}
    blockread(winfile,XML_DISPLAY.StudPasteAddSub,2);  {was abperiod}

 {Build dialogue}
    blockread(winfile,XML_DISPLAY.abOverwrite,2);
 {Alter}
    XML_DISPLAY.AlterBox:=BlockReadInt2(0,2);
 {Search and Replace}
    XML_DISPLAY.SearchBox:=BlockReadInt2(0,6);
 {Clash Help}
    XML_DISPLAY.chScope:=BlockReadInt2(0,3);
    XML_DISPLAY.chType:=BlockReadInt2(0,2);
 {Edit Faculty}
    XML_DISPLAY.EdfacSubType:=BlockReadInt2(0,1);
 {Preferences - general section}
    blockread(winfile,XML_DISPLAY.Formfeed,2);
    BlockRead(winfile, XML_DISPLAY.GroupIndexDisplay, 2, lAmtTransferred);   //blockread(winfile,dummy,2);
    blockread(winfile,XML_DISPLAY.globalHints,2);
    blockread(winfile,XML_DISPLAY.OKbackup,2);
    blockread(winfile,XML_DISPLAY.OKquitcheck,2);
    //Txtsep:=GetInt2(0,255); {used as char}  Txtlim:=GetInt2(0,255);
    blockread(winfile,XML_DISPLAY.txtsep,2);
    blockread(winfile,XML_DISPLAY.txtlim,2);
    blockread(winfile,XML_DISPLAY.sTyear,2);
    blockread(winfile,XML_DISPLAY.showHintsDlg,2);
  {toolbars}
    blockread(winfile,XML_DISPLAY.fgReshowWStoolbar,2);
    blockread(winfile,XML_DISPLAY.fgReshowTTtoolbar,2);
    blockread(winfile,XML_DISPLAY.fgReshowBlockToolbar,2);
    XML_DISPLAY.fgTTtoolbarDock:=BlockReadInt2(0,2);
    XML_DISPLAY.fgBlockToolbarDock:=BlockReadInt2(0,2);
    XML_DISPLAY.fgGenToolbarDock:=BlockReadInt2(0,2);
 {studentinputmsg no longer used input kept for display file integrity}
    i:=BlockReadInt2(0,250); {size of studentinputmsg}
    XML_DISPLAY.tmpStr:=Space(i);
    SetLength(XML_DISPLAY.tmpStr,i);
    if i>0 then blockread(winfile,XML_DISPLAY.tmpStr[1],i);
 {timetable}
 //      !! done up  TO HERE JIM
    blockread(winfile,XML_DISPLAY.EntrySelectionLink,2);
 {students in time slot}
    XML_DISPLAY.sublistYear:=BlockReadInt2(0,years-1);
 {Preferences - General page}
    blockread(winfile,XML_DISPLAY.FAfirst,2);
    blockread(winfile,XML_DISPLAY.FAyear,2);
    blockread(winfile,XML_DISPLAY.FAsex,2);
    blockread(winfile,XML_DISPLAY.FAID,2);
    blockread(winfile,XML_DISPLAY.FAclass,2);
    blockread(winfile,XML_DISPLAY.FAhouse,2);
    blockread(winfile,XML_DISPLAY.FAtutor,2);
    blockread(winfile,XML_DISPLAY.FAhome,2);
    XML_DISPLAY.FAsubnum:=BlockReadInt2(0,nmbrchoices);
    blockread(winfile,XML_DISPLAY.FAreplace,2);
    blockread(winfile,XML_DISPLAY.GenericTtableFlag,2);
    blockread(winfile,XML_DISPLAY.MatchAllYears,2);
    blockread(winfile, XML_DISPLAY.customFileLoadFlag, 2);
    if XML_DISPLAY.customFileLoadFlag then
     begin
      i:=BlockReadInt2(0,250);
      SetLength(XML_DISPLAY.customFileLoad,i);
      blockread(winfile,XML_DISPLAY.customFileLoad[1],i)
     end;
    XML_DISPLAY.OberonOutputType:=BlockReadInt2(0,2);
 {subject list}
    blockread(winfile,XML_DISPLAY.fgsubBySubListZeroSkip,2);
 {worksheet toolbar docking}
    XML_DISPLAY.fgWStoolbarDock:=BlockReadInt2(0,2);
 {find student}
    blockread(winfile,XML_DISPLAY.UseGroupFindStud,2);
 {student input dialogue}
    XML_DISPLAY.StInputDlgPageIndex:=BlockReadInt2(0,1);
 {subject timetable}
    blockread(winfile,XML_DISPLAY.subttWide,2);
 {entry dialogue}
    blockread(winfile,XML_DISPLAY.TrackEnrolFlag,2);
 {preferences - student page}
    blockread(winfile,XML_DISPLAY.StHeadShow,2);
 {student list}
    blockread(winfile,XML_DISPLAY.EnrolBarcodeFlg,2);
 {window views}
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrWindows);
    if XML_DISPLAY._cI>0 then
     for i:=1 to XML_DISPLAY._cI do
      winView[i]:=BlockReadInt2(0,XML_DISPLAY.winViewMax[i]);
 {preferences - timetable page}
    tmpInt:=BlockReadInt2(0,nmbrDays);
    XML_DISPLAY._cI:=BlockReadInt2(0,nmbrPeriods);
    if tmpInt>1 then
     for i:=1 to tmpInt do
      for j:=0 to XML_DISPLAY._cI-1 do
          blockread(winfile,XML_DISPLAY.tsOn[i,j],sizeof(boolean));

    //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
    begin
      try
        BlockRead(winfile, XML_DISPLAY.sTID2, 2, lAmtTransferred);
      except
      end;
    end;
    BlockRead(winfile, XML_DISPLAY.FExportFileIdx, 2, lAmtTransferred);
    BlockRead(winfile, XML_DISPLAY.FIsLandscape, 2, lAmtTransferred);
      try
        BlockRead(winfile, XML_DISPLAY.stEmail, 2, lAmtTransferred);
      except
      end;
   finally
     CloseFile(winfile);
     ChDir(Directories.datadir);
   end;
  except
  end;
end;

procedure LoadWinDisplay;
var
  dispDir,dispFile: string;
begin
  InitWinDisplay;
  dispDir := usrPassDir;
  dispFile := OLD_DISPLAY_FILE;
  if usrPassLevel = utGen then
    dispDir := Directories.datadir;
  chdir(dispDir);
  if fileexists(OLD_DISPLAY_FILE) then begin
    loadDisplayFile(OLD_DISPLAY_FILE);
    XML_DISPLAY.saveDisplayFile(dispDir);
  end
  else begin
    XML_DISPLAY.fgReshowTTtoolbar := True;
    XML_DISPLAY.fgReshowBlockToolbar := True;
    fgReshowGenToolbar := True;
    XML_DISPLAY.fgReshowWStoolbar := True;
  end;
end;


procedure initBlockdata;
var
  i: smallint;
begin
  Blockfile := '';
  blockday := '';
  blockload := 0;
  wipeBlocks;
  SaveBlockFlag := False;
  saveStudFlag := False;
  for i:=0 to years_minus_1 do
    StudYearFlag[i] := False; //clear all
  Lblock := 1;
  Hblock := XML_DISPLAY.blocknum;
  Linknum := 0;
  Excludenum := 0;
  for i:=0 to nmbrSubjects do
  begin
    Blocktop[i] := 0;
    link[i] := 0;
    Exclude[i] := 0
  end;
  XrefGroupSubs;
  for i:=1 to GroupSubs[0] do
    Blocktop[i] := GroupSubs[i];
end;

procedure GroupSetAll;
var
 i: smallint;
begin
 setlength(StGroup,(XML_STUDENTS.numstud+1)); {zero based so +1}
 for i:=1 to XML_STUDENTS.numstud do StGroup[i]:=i;
 GroupName:='All';    GroupType:= 0;
 GroupSort:=1;
 GroupNum:=XML_STUDENTS.numstud;
 setlength(GOSrecipe.steps,2+1);
 GOSrecipe.NumSteps:=1; {using zero rec for count only}
 GOSrecipe.steps[0].meth:=0;
 GOSrecipe.steps[0].e1:='';
 GOSrecipe.steps[0].e2:='';
 GOSrecipe.steps[1].slct:=0; {all}
 GOSrecipe.steps[1].meth:=0; {new}
 GOSrecipe.steps[1].e1:='';
 GOSrecipe.steps[1].e2:=''; {don't care}
 currentYear := -1
end;

procedure TAbout.DEETdumpOut(const pExcludeNonTtabled: Boolean; const pCases21Spec: Boolean);
{ Subject Selection
    Student ID              Mandatory       Varchar(7) Student ID, must be a valid student Id in CASES21
    Subject ID              Mandatory       Varchar(5) Subject ID, must be a valid subject ID in CASES21
    Numeric class number    Mandatory       Smallint Numeric class identifier

  Quilt
    Subject ID              Mandatory       Varchar(5) Subject ID, must be a valid subject ID in CASES21
    Numeric class id        Mandatory       Smallint Numeric class identifier
    Teacher ID              Mandatory       Varchar(4) Teacher ID, must be a valid staff ID in CASES21
    Room ID                 Mandatory       Varchar(4) Room ID, must be a valid room ID in CASES21
    Numeric period number   Mandatory       SmallInt Numeric period identifier
    Numeric day number      Mandatory       SmallInt Numeric day identifier
}

var
  //aStr,bStr: string;
  i,j,n,m: integer;
  lMsg: string;
  lList: TStringList;
  lStr: string;
  lSubject: string;
  lClassNo: Integer;
  lTeacher: string;
  lClassSubject: TAMGClassSubject;
  //lFrmSplitSubjectConv: TFrmSplitSubjectConv;
  lFrmLoadProgress: TFrmLoadProgress;
  lProgress: Integer;
  lPrevProgress: Integer;
  lTtabledSubjects: TStringList;
  lStudDataFound: Boolean;

  function GetSubject(var pSubject: string; var pClassNo: Integer): Boolean;
  var
    aClass:   string[1];
    aSubject: string;
    ClassPos : integer;
  begin
    Result := False;
    aSubject := pSubject;
    // Hide these for #274
//    lClassSubject := ClassSubjects.GetClassSubjectByID(pSubject);
//    if Assigned(lClassSubject) then
//    begin
//     pSubject := Trim(lClassSubject.SubjectCode);
//      pClassNo := lClassSubject.ClassNo;
//    end
//    else
    begin
      // #274 - need to allow for variable subject length  BUT CASES21 has char. length of 5
      if (pCases21Spec) then
      begin
        ClassPos:=6;
      end else begin
        ClassPos:=lencodes[0];
      end;

      if (pCases21Spec) then begin
        pSubject := Trim(Copy(pSubject, 1, ClassPos-1));
      end else begin
        pSubject := Trim(pSubject);
      end;
      // #70 - fix for the Exporting of Class Number
      aClass   := Trim(Copy(aSubject, ClassPos, 1));
      if (aClass>'') then begin
        pClassNo := Ord(aClass[1])-64;
        if pClassNo<1 then pClassNo:=1;
      end else begin
        pClassNo := 1;
      end;
    end;
    Result := True;
  end;

  procedure RefreshTimetabledSubjects;
  var
    StrtYear, FinDay: Integer;
    YYear, d, p, L, a1: Integer;
    aFnt, bFnt: tpIntPoint;
  begin
      StrtYear := years - 1;
      FinDay := days - 1;
      for YYear := StrtYear downto 0 do
      begin
        for d := 0 to finday do
         for p := 1 to Tlimit[d] do
          for L := 1 to level[yyear] do
          begin
            aFnt := FNT(d, p-1, yyear, L, 0);
            bFnt := aFnt;
            a1 := bFnt^;
            if ((a1 > 0) and (a1 <= LabelBase)) then
            begin
              lSubject := Trim(SubCode[a1]);              ///Trim(FNsub(a1, 0));
              lSubject := Copy(lSubject, 1, lencodes[0]);
              GetSubject(lSubject, lClassNo);
              lTtabledSubjects.Add(lSubject);
            end;
          end; {for L}
      end;
  end;

  function DEETdumpTTableOut: Boolean;
  var
    StrtYear, FinYear, StrtDay, FinDay: Integer;
    YYear,d,p,L,a1: integer;
    aFnt,bFnt: tpIntPoint;
    tmpStr: string;
    lDataFound: Boolean;
  begin
    lDataFound := False;
    try
      lList.Clear;
      StrtYear := years - 1;
      FinYear := 0;
      StrtDay := 0;
      FinDay := days - 1;
      for YYear := StrtYear downto FinYear do
      begin
        for d := strtday to finday do
         for p := 1 to Tlimit[d] do
          for L := 1 to level[yyear] do
          begin
            lStr := '';
            aFnt := FNT(d,p-1,yyear,L,0);
            bFnt := aFnt;
            a1 := bFnt^;
            if ((a1>0) and (a1<=LabelBase)) then
            begin
              lSubject := Trim(FNsub(a1,0));
              lSubject := Copy(lSubject, 1, lencodes[0]);     //Copy(lSubject,1,lencodes[0] - 1);

              //1. Get Teacher
              bFnt := aFnt;
              Inc(bFnt,1);
              a1 := bFnt^;
              tmpStr := FNsub(a1,1);
              if (pCases21Spec) then begin
                lTeacher := Copy(Trim(tmpStr), 1, 4);
              end else begin
                lTeacher := Trim(tmpStr);
              end;

              //2. Get Class number
              GetSubject(lSubject, lClassNo);

              //3. now add them both
              lStr := lSubject + ',' + IntToStr(lClassNo) + ',' +lTeacher;    //te

              bFnt := aFnt;
              inc(bFnt,2);
              a1 := bFnt^;
              tmpStr := FNsub(a1,2);
              if (pCases21Spec) then begin
                lStr := lStr + ',' + Copy(Trim(tmpStr), 1, 4);   //ro
              end else begin
                lStr := lStr + ',' + Trim(tmpStr);
              end;
              lStr := lStr + ',' + Trim(IntToStr(p));  //qrow - {period}
              lStr := lStr + ',' + Trim(IntToStr(d+1));   //qcol - {day}
              lList.Add(lStr);
              lDataFound := True;
            end;
          end; {for L}
      end;  // for Year
      if lDataFound then
      begin
        lFrmLoadProgress.UpdateProgress(25, Format(AMG_EXPORTING_YEAR_TTABLE_MSG, ['group', GOSname[GOSmenu[XML_DISPLAY.GroupIndexDisplay]]]), 900);
        lFrmLoadProgress.UpdateProgress(25, AMG_TIMETABLE_EXPORT_COMPLETE, 2500);
      end;
    finally
      lList.SaveToFile('Quilt.Txt');
      Application.ProcessMessages;
      Result := lDataFound;
    end;
  end;

begin
  lList := TStringList.Create;
  lFrmLoadProgress := TFrmLoadProgress.Create(Application);
  lTtabledSubjects := TStringList.Create;
  //lFrmSplitSubjectConv := TFrmSplitSubjectConv.Create(Application);     // Afterwards conversion
  try
    //lFrmSplitSubjectConv.ClassSubjects := ClassSubjects;
    //lFrmSplitSubjectConv.RefreshClassSubjects;
    lFrmLoadProgress.Title := 'Export CASES21 (Maze) Data';
    lFrmLoadProgress.Show;
    lProgress := 0;
    lPrevProgress := 0;
    ChDir(Directories.datadir);
    delim :=chr(XML_DISPLAY.Txtsep);
    delim2 :=chr(XML_DISPLAY.Txtlim);
    if XML_DISPLAY.Txtlim = 0 then delim2:='';
    lStudDataFound := False;
    RefreshTimetabledSubjects;
    for j := 1 to GroupNum do
    begin
      i := StGroup[j];
      for n := 1 to chmax do
      begin
        lstr := '';
        m := XML_STUDENTS.Stud[i].Choices[n];
        if m <= 0 then continue;
        if (pCases21Spec) then begin
          lStr := Copy(Trim(XML_STUDENTS.Stud[i].ID), 1, 7);  //skey   10 Char
        end else begin
          lStr := Trim(XML_STUDENTS.Stud[i].ID);
        end;
        lSubject := Trim(SubCode[m]);
        GetSubject(lSubject, lClassNo);
        if not (pExcludeNonTtabled and (lTtabledSubjects.IndexOf(lSubject) = -1)) then
        begin
          lStr := lStr + ',' + lSubject + ',' + IntToStr(lClassNo);
          lList.Add(lStr);
          lStudDataFound := True;
        end;
      end;
      if lStudDataFound then
      begin
        if j > 0 then
          lProgress := Round((50 * j) / GroupNum);
        lFrmLoadProgress.UpdateProgress(lProgress - lPrevProgress, Format(AMG_EXPORTING_SUBJECT_SELECTION_MSG, [XML_STUDENTS.Stud[i].ID]), 3);
        lPrevProgress := lProgress;
      end;
    end;
    lList.SaveToFile('Subject_Selections.txt');
    Application.ProcessMessages;
    if lStudDataFound then
    begin
      lMsg := Format(AMG_STUDENT_SUBJECTS_EXPORT_MSG, [lList.Count]);
      if lProgress < 50 then
      begin
        if lProgress = 0 then
        begin
          lProgress := 50;
          lMsg := AMG_NO_STUDENTS_TO_EXOPORT_MSG;
        end;
      end;
      lFrmLoadProgress.UpdateProgress(0, lMsg, 3000);
      lFrmLoadProgress.UpdateProgress(lProgress - lPrevProgress, lMsg, 10);
      lPrevProgress := lProgress;
    end;  // if
    if not DEETdumpTTableOut and not lStudDataFound then
      lMsg := AMG_NO_DATA_FOUND_MSG
    else
      lMsg := Format(AMG_DATA_EXPORTED_TO_CASES21_MSG, [QuotedStr(Directories.DataDir)]);
    MessageDlg(lMsg, mtInformation, [mbOK], 0);
  finally
    //FreeAndNil(lFrmSplitSubjectConv);
    FreeAndNil(lTtabledSubjects);
    FreeAndNil(lFrmLoadProgress);
    FreeAndNil(lList);
  end;
end;

function checkforwinorder(x: smallint):wordbool;
var
 i,j:       smallint;
begin
 result:=false;
 if XML_DISPLAY.winOrderNum>0 then
  for i:=XML_DISPLAY.winOrderNum downto 1 do
   begin
    j:=XML_DISPLAY.winOrder[i];
    if j=x then
     begin result:=true; break; end;
   end; {for i}
end;

procedure winShow;
var
 i,j:       integer;
begin
 if XML_DISPLAY.winOrderNum>0 then
  for i:=XML_DISPLAY.winOrderNum downto 1 do
   begin
    j:=XML_DISPLAY.winOrder[i];   {windows tag value}
    if XML_DISPLAY.winpos[j].height>0 then {only if its been saved once and array initialized}
     case j of
      wnInfo: infowinselect;
      wnSucode: SuCodeWinSelect;
      wnTecode: TeCodeWinSelect;
      wnRocode: RoCodeWinSelect;
      wnRClassCode: RollClassWinSelect;
      wnFac: FacWinSelect;
      wnHouse: HouseWinSelect;
      wnTimes: TimesWinSelect;
      wnGroupSub:  subyearwinselect;
      wnTtable:  Ttablewinselect;
      wnBlock: blockwinselect;
      wnSubjectList: SubListWinSelect;
      wnTimeList: SubjectbyTimeSlotwinSelect;
      wnStudentList: StudentListwinSelect;
      wnCmatrix: clashmatrixWinSelect;
      wnStInput: StudentInputWinSelect;
      wnCHelp: ClashHelpwinSelect;
      wnBlockClashes: BlockClasheswinSelect;
      wnTeClash: TeacherClasheswinSelect;
      wnRoClash: RoomClasheswinSelect;
      wnTeFree: TeachersFreewinSelect;
      wnRoFree: RoomsFreewinSelect;
      wnTeTimes: TeacherTimeswinSelect;
      wnSuTimes: SubjectTimeswinSelect;
      wnGroupTe: GroupofTeacherswinSelect;
      wnTeacherTt: teachTtablewinSelect;
      wnRoomTt: roomTtablewinSelect;
      wnSubjectTt: subjectTtablewinSelect;
      wnStudentTt: studentTtablewinSelect;
      wnTeList:  TeacherListwinSelect;
      wnStBlClash: StBlockClashWinSelect;
      wnStFRee: StudFreeWinSelect;
      wnWorksheet: WorksheetWinSelect;
      wnGenTool: gentoolbarSelect;
      wnStudentTag:StudentTagsSelect;    //mantis-0727
      wnTtTool: if (checkforwinorder(wnTtable) or (XML_DISPLAY.fgTTtoolbarDock=0)) then  {don't restore docked alone}
           tttoolbarSelect;
      wnBlTool: if (checkforwinorder(wnBlock) or (XML_DISPLAY.fgBlockToolbarDock=0)) then {don't restore docked alone}
           blocktoolbarSelect;

     end; {case j of}
  end; {for i}
 //if fgReshowGenToolbar and not(fgGenToolbar) then
  //begin {only if display file is missing}
   gentoolbarSelect;
   fgReshowGenToolbar:=false;
  //end;
end;

procedure ReadTTinUse;
var
 f: file;
 astr: string;
 k: smallint;
begin
 FileNames.CurentTimeTable:='Ttable';
// TtInUseName:='2012 V3 ttable';
 if FileExists(FileNames.CurentTimeTableConfiguration) then
  try
   try
    filemode:=fmOpenRead+fmShareDenyNone;
    doAssignFile(f,FileNames.CurentTimeTableConfiguration);
    reset(f,1);
    blockread(f,TtInUseNum,2);
    astr:='';
    blockread(f,k,2);
    if k>0 then
     begin
      astr:=space(k);
      blockread(f,astr[1],k);
     end;
    FileNames.CurentTimeTable:=astr;
   finally
    closefile(f);
   end;
  except
  end;
end;

procedure CheckAllSelections;
begin
 {validate selections for listboxes here to reduce errors due to corrupt file}
 rangeCheckSubyrSels(XML_DISPLAY.ClashMatrixSelection);
 rangeCheckSubSels(XML_DISPLAY.ttPrntSelSubg);
 rangeCheckCodeSels(XML_DISPLAY.ttPrntSelTeachg, 1);
 rangeCheckCodeSels(XML_DISPLAY.ttprntselroomg, 2);
 rangeCheckCodeSels(XML_DISPLAY.RoTtSelection, 2);
 rangeCheckCodeSels(XML_DISPLAY.RoomsFreeSelection, 2);
 rangeCheckCodeSels(XML_DISPLAY.TeTtSelection, 1);
 rangeCheckSubSels(XML_DISPLAY.GrpOfTeSelSubg);
 rangeCheckCodeSels(XML_DISPLAY.TeFreeSelect, 1);
 rangeCheckCodeSels(XML_DISPLAY.TeTimesSelect, 1);
 MySelStud:=0; {no student selected}
end;

procedure CheckDeleteUsrPassDir;
var
 fname: string;
begin
 fname:=usrPassID+myLogOnFileExt;
 if fileexists(fname) then deletefile(fname);
end;

procedure StudentID2Load(year:smallint);
var
 StudID2file:               file;
 i:                  smallint;
 k:             smallint;
 tmpStr:                 string;
 tmpStr2:           string;
 YearDigit:     string[2];
 fname: string;
begin
 try
  chdir(Directories.Datadir);
  YearDigit:=inttostr(year+1);
  YearDigit:=trim(YearDigit);
  fname:='STUID'+YearDigit+'.DAT';
  for i:= 0 to nmbrstudents do
  begin
   if i<=XML_STUDENTS.numstud then
   begin
    if XML_STUDENTS.Stud[i].TcYear=year then
    begin
     studID2[i]:='';      //clear array
    end
   end
   else
    studID2[i]:='';      //clear array
  end;
  if fileexists(fname) then
  begin
   try
    try
     doAssignFile(StudID2file,fname);
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(StudID2file,1);
//     if numstud>0 then
//     begin
//      for i:=1 to numstud do
//       if Stud[i].TcYear=year then

       while not(eof(StudID2file)) do
       begin
        tmpStr:= Space(10);
        tmpStr2:= Space(10);
        blockread(StudID2file, tmpStr[1], 10);
        blockread(StudID2file, tmpStr2[1], 10);
        k:=findStudentByID(trim(tmpstr));
        if k>0 then studID2[k]:=trim(tmpStr2);
       end;
//     end;
    finally
     closefile(StudID2file);
    end;
   except
   end;
  end;
 except
 end;
end;

procedure StudentID2LoadNew(year:smallint);
var
 StudID2file:               file;
 i:          smallint;
 k:          smallint;
 tmpStr:     string;
 tmpStr2:    string;
 tmpStr3:    string;
 YearDigit:  string[2];
 fname: string;
begin
 try
  chdir(Directories.Datadir);
  YearDigit:=inttostr(year+1);
  YearDigit:=trim(YearDigit);
  fname:='STUIDNew'+YearDigit+'.DAT';
  for i:= 0 to nmbrstudents do
  begin
   if i<=XML_STUDENTS.numstud then
   begin
    if XML_STUDENTS.Stud[i].TcYear=year then
    begin
     studID2[i]:='';      //clear array
     studEmail[i]:='';
    end
   end else begin
    studID2[i]:='';      //clear array
    studEmail[i]:='';
   end;
  end;
  if fileexists(fname) then
  begin
   try
    try
     doAssignFile(StudID2file,fname);
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(StudID2file,1);
//     if numstud>0 then
//     begin
//      for i:=1 to numstud do
//       if Stud[i].TcYear=year then

       while not(eof(StudID2file)) do
       begin
        tmpStr:= Space(10);
        tmpStr2:= Space(50);
        tmpStr3:= Space(100);
        blockread(StudID2file, tmpStr[1], 10);
        blockread(StudID2file, tmpStr2[1], 50);
        blockread(StudID2file, tmpStr3[1], 100);
        k:=findStudentByID(trim(tmpstr));
        if k>0 then
        begin
           studID2[k]:=trim(tmpStr2);
           studEmail[k]:=trim(tmpStr3);
//           if trim(tmpStr3)<>'' then
//           begin
//               ShowMessAGE('HERE');
//           end;
        end;
       end;
//     end;
    finally
     closefile(StudID2file);
    end;
   except
   end;
  end;
 except
 end;
end;

procedure BuildSTUDNew;
var
  i: integer;
  YearDigit:  string[2];
  fname: string;
begin
  chdir(Directories.datadir);
  for i:=0 to years_minus_1 do
  begin
    YearDigit:=inttostr(i+1);
    YearDigit:=trim(YearDigit);
    fname:='STUIDNew'+YearDigit+'.DAT';

    if not(FileExists(fname)) then
    begin
      UpdateStudID2FileNew(i);
    end;
  end;
end;

procedure firstLoad;
var
 i,code: smallint;
begin
  {$I-}
  chdir(Directories.datadir);
  {$I+}
  if IOResult = 0 then
  begin
    chdir(Directories.datadir);
    CheckAccessFile;
    ttAccessPos:=0; blAccessPos:=0;  ttAccess:=false;
    for i:=0 to nmbryears do
    begin
      blockAccess[i]:=false;
      yearAccess[i]:=false;
    end;
    ReadTTinUse;
    FileNames.LoadedTimeTable:=FileNames.CurentTimeTable;
    if (usrPassLevel<>utGen) then
    begin
      if usrPassDir<>Directories.datadir then CheckDeleteUsrPassDir;
      LogMeOn;
      chdir(Directories.datadir);
    end;
    getTTable;
    getCodes;
    screen.cursor := crHourglass;
    XML_STUDENTS.numstud:=0;
    for i:=0 to years_minus_1 do
      StudentQuickStreamLoad(i);
    XML_STUDENTS.saveToFile('');
    //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
    if Length(XML_STUDENTS.Stud) > 0 then
    begin
      for i:=0 to nmbrstudents do
      begin
        studID2[i]:='';      //clear array
        studEmail[i]:='';
      end;
      for i:=0 to years_minus_1 do StudentID2Load(i);
      BuildSTUDNew;
      for i := 0 to years_minus_1 do StudentID2LoadNew(i);
        
    end;

    loadGroups;
    SubSexCountFlg:=true;
    sortStudents; {maintain sort after sep. years}
    CountChmax;
    loadWinDisplay;
    if XML_DISPLAY.FAsubnum=0 then
      XML_DISPLAY.FAsubnum:=chmax;

    InitClassSizes;
    for code := 0 to 2 do sortCodes(code);
    getYearStats;
    LoadRollClasses;  CheckClassInStuds; CheckClassOnTt;
    GroupNum := 0;
    if XML_DISPLAY.GroupIndexDisplay = 0 then
    begin
      GroupSetAll;
    end
    else if XML_DISPLAY.GroupIndexDisplay > 0 then
    begin
      CookCustomGroup(XML_DISPLAY.GroupIndexDisplay);
      for i := 0 to MainForm.Group1.Count - 1 do
      begin
        if MainForm.Group1.Items[i].Tag = XML_DISPLAY.GroupIndexDisplay then
          MainForm.Group1.Items[i].Checked := True
        else
          MainForm.Group1.Items[i].Checked := False;
      end;
    end;
    updateGroupSubs;
    initBlockdata;

    needClashMatrixRecalc := true;
    ReLoadCustom;
    CheckAllSelections;
    saveSubsFlag:=false;   SaveTimeFlag:=false;
    AlterTimeFlag:=true;   AlterWSflag:=true;
    chd:=nd; chp:=np; chy:=ny; chl:=nl; {init clash help pos to current tt pos}
    yearFormToggle;
    studentPointerSet;
    getFontWidths; {get max for commons such as teacher name, faculty name etc}
    if RollMarkerFlg then CheckRollMarkerExport;
    screen.cursor := crDefault;
    if DEETcasesImportExport then About.DEETdumpOut;
  end;
  About.RefreshObjects;
end;

procedure TAbout.FormCreate(Sender: TObject);
{var
 lDriveLetter: Char;
 lDriveNo: Integer;
 lFreeBytes: Int64;}
begin
  SetupApp;
  {if usrPassLevel <> utGen then
  begin
    lDriveLetter := UpperCase(ExtractFileDrive(GetCurrentDir))[1];
    lDriveNo := 1 + Ord(lDriveLetter) - Ord('A') ;
    if lDriveNo > 0 then
    begin
      lFreeBytes := DiskFree(lDriveNo);
      if Round(lFreeBytes / 1048576) < 1 then
        MessageDlg(AMG_DISK_SPACE_MSG, mtInformation, [mbOK], 0);
    end;
  end;}
end;

procedure TAbout.FormDestroy(Sender: TObject);
var
  i: smallint;
begin
 try
  XML_DISPLAY.tcfont.Free;
  for i:=0 to nmbrDays - 1 do dispose(ttMain[i]);
  dispose(ttParameters);
 except
 end;
end;

procedure saveTTable;
var
  f: file;
  fname, TempLabel: string;
  i: Smallint;
begin
  if usrPassLevel = utGen then
    Exit;
  try
    ChDir(Directories.datadir); // was timedir, now only allowing save to datadir
    saveNewTTable;
    setTTParameters;
  except
  end;
  // no longer saving old .tt file
  saveCLSfile;
  saveWSfile;
  fname := XMLHelper.getLAB_EXTENSION(FileNames.LoadedTimeTable,toWrite);
  
  SaveTimeFlag := False;
  if ttAccess and (not(fEntryDlgUp or fSearchReplaceDlgUp)) then
    CheckAccessRights(utTime,16,false);
end;

procedure TAbout.Timer1Timer(Sender: TObject);
begin
 About.Timer1.enabled:=false;
  {reset about to use as about box}
 About.hide;
 About.loadLabel.visible:=false;
 About.OKbutton.visible:=true;
 //About.Panel2.visible:=true;
 About.caption:='About';
 screen.cursor:=crDefault
end;

procedure TAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caHide
end;

procedure TAbout.OKbuttonOLDClick(Sender: TObject);
begin
 About.hide
end;

function TAbout.RefreshObjects: Boolean;
var
  d, p, Sub, Te: Integer;
  aFnt: tpintpoint;
  YearY: Integer;
  lTempList: TStringList;
  lCount: Integer;
  lTeacher: TAMGTeacher;
  lSubject: TAMGSubject;
  l: Integer;
  i: Integer;
  j: Integer;
  lCurrentDir: string;
  lStr: string;
  lSepPos: Integer;
  lCustomOutWin: TCustomOutWin;
begin
  //Teachers and Subjects
  lCurrentDir := GetCurrentDir;
  RefreshSubjects;
  try
    Teachers.Clear;

    for i := 1 to NumCodes[1] do
    begin
      lTeacher := TAMGTeacher.Create;
      lTeacher.ID := i;
      lTeacher.Code := XML_TEACHERS.TeCode[i, 0];
      lTeacher.TeacherName := XML_TEACHERS.TeName[i, 0];
      Teachers.Add(lTeacher);
    end;
    lCount := 0;
    lTempList := TStringList.Create;
    try
      for YearY := 0 to years_minus_1 do
      begin
        for d := 0 to days - 1 do
          for p := 1 to tlimit[d] do
          begin
            for l := 0 to Level[YearY] do
            begin
              aFnt := FNT(d,p-1, YearY, l, 2);
              te := aFnt ^;
              if te > 0 then
              begin
                Dec(aFnt);
                sub := aFnt^;
                if (sub <> subNA) then
                begin
                  lTempList.Add(IntToStr(Te) + '=' + IntToStr(Sub));
                  Inc(lCount);
                end;
              end; {if (te>0)}
            end;
          end; {for p}
      end;
      RemoveDuplicateItems(lTempList);

      for i := 0 to Teachers.Count -1 do
      begin
        lTeacher := TAMGTEacher(Teachers.Items[i]);
        for j := 0 to lTempList.Count - 1 do
        begin
          lStr := lTempList.Strings[j];
          lSepPos := Pos('=', lStr);
          if Copy(lStr, 1, lSepPos -1) = IntToStr(lTeacher.ID) then
          begin
            lSubject := TAMGSubject.Create;
            lSubject.ID := StrToInt(Copy(lStr, lSepPos + 1, Length(lStr))); //StrToInt(lTempList.Values[IntToStr(lTeacher.ID)]);
            lSubject.Code := SubCode[lSubject.ID];
            lSubject.SubjectFullName := SubName[lSubject.ID, 1];
            lTeacher.Subjects.Add(lSubject);
          end;
        end;
      end;
    finally
      FreeAndNil(lTempList);
    end;

    RefreshStudents;
    //Class Subject for CASES21
  if usrPassLevel <> utGen then      // #323
  begin
    if Cases21Flag then
    begin
      ClassSubjects.RefreshFromFile;
      ClassSubjects.SaveToFile;
    end;
  end;
  
    if CustomerIDnum = cnBrisbaneDistEd then
    begin
      lCustomOutWin := TCustomOutWin.Create;
      try
        lCustomOutWin.BrisbaneDistEdCustomExport(True);
      finally
        FreeAndNil(lCustomOutWin);
      end;
    end;

    RefreshTags;
    if Assigned(FMRU) then
    begin
      SetCurrentDir(usrPassDir);
      try
        FMRU.RefreshFromFile;
      finally
        SetCurrentDir(lCurrentDir);
      end;
    end;
  finally
    ChDir(lCurrentDir);
  end;
  Result := True;
end;

function TAbout.RefreshStudents: Boolean;
var
  lStudent: TAMGStudent;
  lChoice: TAMGChoice;
  lParentIdx: Integer;
  j: Integer;
  i: Integer;
begin
  Students.Clear;
  for i := 1 to XML_STUDENTS.numstud do
  begin
    lStudent := TAMGStudent.Create;
    lStudent.ID := i;
    lStudent.StName := XML_STUDENTS.Stud[i].StName;
    lStudent.First := XML_STUDENTS.Stud[i].First;
    lStudent.Code := XML_STUDENTS.Stud[i].ID;
    lStudent.Code2 := StudID2[i];
    lStudent.Sex := XML_STUDENTS.Stud[i].Sex;
    lStudent.StudYear := XML_STUDENTS.Stud[i].TcYear;
    lStudent.tcClass := XML_STUDENTS.Stud[i].tcClass;
    lStudent.House := XML_STUDENTS.Stud[i].House;
    lStudent.Tutor:= XML_STUDENTS.Stud[i].Tutor;
    lStudent.Home := XML_STUDENTS.Stud[i].Home;
    lStudent.Tag := XML_STUDENTS.Stud[i].TcTag;
    for j  := 1 to nmbrChoices do
    begin
      lChoice := TAMGChoice.Create;
      lChoice.Sub := XML_STUDENTS.Stud[i].Choices[j];
      lStudent.Choices.Add(lChoice);
    end;
    lParentIdx := Parents.IndexOf(lStudent.Code);
    if lParentIdx <> -1 then
    begin
      lStudent.FathersFirstName := TAMGParent(Parents.Items[lParentIdx]).FathersName;
      lStudent.FathersEmail := TAMGParent(Parents.Items[lParentIdx]).FathersEmail;
      lStudent.MothersFirstName := TAMGParent(Parents.Items[lParentIdx]).MothersName;
      lStudent.MothersEmail := TAMGParent(Parents.Items[lParentIdx]).MothersEmail;
    end;
    Students.Add(lStudent);
  end; //for i
  Result := True;
end;

function TAbout.RefreshSubjects: Boolean;
var
  i: Integer;
  k: Integer;
  lSubject: TAMGSubject;
begin
  for i := 1 to CodeCount[0] do
  begin
    k := CodePoint[i, 0];
    if SubCode[k] <> '' then
    begin
      lSubject := TAMGSubject.Create;
      lSubject.Code := SubCode[k];
      if SubName[k] <> '' then
        lSubject.SubjectFullName := SubName[k]
      else
        lSubject.SubjectFullName := lSubject.Code;
      Subjects.Add(lSubject);
    end;
  end;
  Result := True;
end;

function TAbout.RefreshTags: Boolean;
var
  lTag: TAMGTag;
  i: Integer;
begin
  CalcTagsUsed;
  for i := 1 to nmbrTags do
  begin
    lTag := TAMGTag.Create;
    lTag.Code := TagCode[i];
    lTag.TagName := TagName[i];
    lTag.IsUsed := TagsUsed[i];
    lTag.TagOrder := TagOrder[i];
    Tags.Add(lTag);
    //TagOrderNum: smallint;
  end;
  Result := True;
end;

procedure TAbout.FormDeactivate(Sender: TObject);
begin
 if not(KeyFileOK) then application.Terminate;
end;

initialization
 screen.cursor := crHourglass;
 
// #992 - Auto build this line so that we dont forget
{$Include UpdateReleaseDate.inc}
 //UpdateReleaseDate:=EncodeDate(2014,04,15); // EncodeDate(Year, Month, Day: Word)

 namefile:='TCWP53.DAT';

 {School:='PROPERTY OF AMIG SYSTEMS   (EVALUATION COPY ONLY)';}
 {School:='UNIVERSITY OF N.S.W. - Dept. CIVIL AND ENVIRONMENTAL ENGINEERING';}
 {School:='UNIVERSITY OF N.S.W. - Dept. CIVIL + ENVIRO. ENGIN.';}
 {School:='QUEENSLAND DEPARTMENT OF EDUCATION - EVALUATION COPY';}
 {School:='ADELAIDE COLLEGE OF TAFE - DEPT. OF OFFICE STUDIES';}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 ///           School:='HEATLEY STATE HIGH SCHOOL - EVALUATION COPY ONLY';
 //             School:='POLLACK PARTNERS - EVALUATION COPY';
 //  School:='AUSTRALIAN CATHOLIC UNIVERSITY - SCHOOL OF ARTS AND SCIENCES';
 //  School:='IT AND T EDUCATION - EVALUATION COPY'; //barbie hartman
 School:='AMIG SYSTEMS';

 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 {********************  T I M E  C H A R T  2 0 0 0  *************************}
 initFontColorPairs;
 Fsub:=-1; Fteach:=-1; Froom:=-1; Fblock:=-1; Fshare:=-1; Fdouble:=-1; Ffix:=-1;
 Rsub:=-1; Rteach:=-1; Rroom:=-1; Rblock:=-1; Rshare:=-1; Rdouble:=-1; Rfix:=-1;
 fillchar(chTeGroup, sizeof(chTeGroup), chr(0));
 fillchar(chRoGroup, sizeof(chRoGroup), chr(0));

 {dynamic vars :- initialize memory for pointers}
  for i:=0 to nmbrDays-1 do
   begin
    new(ttMain[i]);
    {initialize blocks to zero}
    fillchar(ttMain[i]^, sizeof(ttMain[i]^), chr(0))
    (*dbgi:=sizeof(ttmain[i]);
    dbgj:=sizeof(ttmain[i]^); *)
   end;
 new(ttParameters);
 Yearname[-1]:='All years';  level[-1]:=6; Blocks[-1]:=6;
 usrPassYearLock:=0;
 for i:=0 to years_minus_1 do StudYearFlag[i]:=false;
 for i:=1 to accessCountMax do usrDataSectionLocked[i]:=false;   //init to no locks in place
end.

