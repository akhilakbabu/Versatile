
unit tcommon;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils,Messages,grids
  ,TimeChartGlobals,StrUtils,Clipbrd,menus,ClassDefs, SHFolder,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;


  function getTextWidthOnLabel(_Text: string; _Font: TFont): integer;
  procedure updatesub(code: smallint);
  Procedure UpdateSubReportFile;
  function FindNextCode(code: smallint): smallint;
  procedure InsertCode(code,place:integer);
  function FNsub(A9,code9: smallint):string;
  function FNsubname(A9,code9: smallint):string;
  function FNsubwillcount(A9,code9: smallint):string; // mantis-1295

  function checkCode(code: smallint; var codeStr: string): smallint;
  procedure validateCode(code: smallint; var codeStr: string);
  function checkCode2(var codeStr: string): smallint;
  function checkWildSub(var codeStr: string): smallint;
  function checkfaculty(codeStr: string): smallint;
  function GetDirName(var a:String):String;



  procedure XrefGroupSubs;
  procedure swapint(var a:smallint; var b: smallint);
  procedure swapstr(var a:string; var b: string);

  function findHouse2(enteredTxt: string): smallint;
  function findClass2(enteredTxt: string): smallint;
  function findTutor2(enteredTxt: string): smallint;
  function findRoom2(enteredTxt: string): smallint;
  function findChoice3(enteredTxt: string): smallint;

  procedure topcentre(fm: Tform);
  function findDay(s: string): smallint;
  function FindYear(s: string): smallint;
  function findPeriod(sday:integer; s: string): smallint;
  function FindRollClasscode(s:string): smallint;

  procedure yearFormToggle;

  procedure clashmatrixWinSelect;
  procedure SuCodeWinSelect;
  procedure TeCodeWinSelect;
  procedure RoCodeWinSelect;
  procedure RollClassWinSelect;
  procedure FacWinSelect;
  procedure HouseWinSelect;
  procedure TimesWinSelect;
  procedure StudentInputWinSelect;
  procedure studentTtablewinSelect;
  procedure ClashHelpwinSelect;
  procedure BlockClasheswinSelect;
  procedure TeacherClasheswinSelect;
  procedure RoomClasheswinSelect;
  procedure TeachersFreewinSelect;
  procedure RoomsFreewinSelect;
  procedure TeacherTimeswinSelect;
  procedure SubjectTimeswinSelect;
  procedure GroupofTeacherswinSelect;
  procedure teachTtablewinSelect;
  procedure roomTtablewinSelect;
  procedure subjectTtablewinSelect;
  procedure gentoolbarSelect;
  procedure tttoolbarSelect;
  procedure WStoolbarSelect;
  procedure blocktoolbarSelect;
  procedure WorksheetWinSelect;
  procedure infoWinSelect;
  procedure SubListWinSelect;
  procedure SubjectbyTimeSlotwinSelect;
  procedure StudentListwinSelect;
  procedure TeacherListwinSelect;
  procedure StBlockClashWinSelect;
  procedure StudFreeWinSelect;
  procedure StudentTagsSelect;    //mantis-0727

  procedure sortCodes(code: smallint);

  procedure getPrntFontWidths(mycanvas:Tcanvas);
  procedure printOurWindowDetail(winNum: integer);

  procedure findTeacher(i,j: smallint; var ftc,frc: smallint);
  procedure findSubTeacher(var ftc,frc: integer;snu: integer);
  function FindSubTeachers(var pFTc, pSTc, pFRc: Integer; pSubJectNo: Integer): Boolean;

  function GetLevelTtClass(MyYear,MyrollClass:integer):integer;

  procedure getFontWidths;
  procedure getCodeFontWidths(code: smallint);
  procedure getStudentFontWidths;
  function getHouseFontWidths(mycanvas:Tcanvas):smallint;
  function getFacultyFontWidths(mycanvas:Tcanvas):smallint;
  function getClassFontWidths(mycanvas:Tcanvas):smallint;
  function getTagFontWidths(mycanvas:Tcanvas):smallint;
  function getYearnameFontWidths(mycanvas:Tcanvas):smallint;
  procedure getTsNameFontWidths;
  function getDaynameFontWidths(mycanvas:Tcanvas):smallint;
  procedure getTeDutyCodeFontWidths;

  procedure ensureSizeForFont(var frm :tform);
  function findSubyear(place: smallint): smallint;
  procedure subyearwinSelect;
  procedure BlockwinSelect;
  procedure updateBlockWindow;
  function SaveBlocksAs: boolean;
  procedure SaveBlocksAsShow;

  procedure setWindowDefaults(aForm: Tform; aVal: smallint);

  procedure updateTtableWindow;
  procedure updateWSwindow;

  procedure TtableWinSelect;
  procedure wipeBlocks;
  procedure SetDays;

  procedure updateStatusPanel;
  procedure UpdateAllWins; {call on code changes}
  procedure UpdateStudWins; {call on student data change}
  procedure UpdateTimeTableWins; {call on timetable change}
  procedure UpdateWSwins; {call on worksheet change}
  procedure UpdateBlockWins; {call on block changes}
  procedure printOurWindow(winNum: smallint);
  procedure saveWinpos(tf: Tform);
  procedure SetTimeCell;
  procedure SetPshowMax;

  procedure TextExportWindow(winNum: smallint);
  procedure CopyExportWindow(winNum: smallint);
  function findStudBIN(astr: string): smallint;
  procedure TickCodeSubMenu(mitem:TMenuItem);
  procedure parseCustomInfo;
  function getfacname(a:integer): string;
  procedure UpdateWindow(wn:smallint);
  procedure checkRoFaculty(var fac1,fac2,fac3: smallint);
  procedure checkTeFaculty(var fac1,fac2,fac3,fac4: smallint);
  Procedure CheckSelections;
  Function CheckStudInSub(st,sub: integer): boolean;
  function GetStudentName(st:integer):string;
  procedure SetStArrays;
  function setprintertitle(winNum: smallint):string;
  function GetEncryptStr(KeyFileName,KeyStr: shortstring):string;
  procedure updatebackupfile;
  procedure CalcSubReportCodes;
  Function TeachInAnyFac(j,MyFac:smallint):boolean;
  Function RoomInAnyFac(j,MyFac:smallint):boolean;
  procedure DayGroupCalc;
  procedure CalcWeekMaxLoad;
  procedure ReadCustom;
  function clearcustom: wordbool;
  function RemoveExtension(s: string): string;
  function findsubinfac(fnum,snum: integer): boolean;
  function TooMany(myKind: string; myCount,myMax:integer):boolean;
  Function SaveTTCancel: boolean;
  Function NoStuds: boolean;
  Function SaveBlocksCancel: boolean;
  Procedure DoAllTtClashes;
  procedure CheckClassOnTt;
  procedure CheckClassInStuds;
  function FNws(b,y,l,offset: smallint): tpIntPoint;
  function FNwsByte(b,y,l,offset: smallint): tpBytePoint;
  function WildSub(su: integer):string;
  function StartEndTime(d,p:integer):string;
  procedure RenewFont(MyCanvas: Tcanvas);
  function findStudentByID(fStudID: string): smallint;
  Procedure UpdateStudID2File(year:smallint);
  Procedure UpdateStudID2FileNew(year:smallint);
  function GetNoOfStudentsInClass(const pYear, PSubCode: Integer; var pTeach, pRoom, pDay, pPeriod: Integer): Integer;
  procedure LoadSubjectsFromFile(const pFileName: string);
  procedure RemoveDuplicateItems(var pList: TStringList);
  function GetLongestLength: Integer;
  function GetSpacesToAlign(const pCode: string; pTotalLength: Integer): string;
  function GetTeacherSubjects(const pTeacherNo: Integer): TStringList;
  function GetAverageSubjectLoad(const pAM: Boolean; lSubjectCode: string): Integer;
  function GetAllSubjectsAverageLoad(const pAM: Boolean): Integer;
  function GetStudentHomeRoom(const pStudNo: Integer): string;
  function GetSubjectFaculties(const pSubNo: Integer): string;
  function GetSpecialFolderPath(folder : integer) : string;

implementation

uses
  Tcgetdir,StCommon,tcload, main,SuWnd,TeWnd,RoWnd,RollClassWnd,FacWnd,HouseWnd,
  TimesWnd, CodeView,subyr,tcinfo,ttable, worksheet, block1,subbysub,subbyslt,
  studlist,telist,StBlockClash,StudFree, printers,studttab,teachtt,roomtt,subjcttt,ListTagNames,//mantis-0727
  clashhlp,blkclash,teclash,roclash,tefree,rofree, tetimes,subtimes,grpofte,clmatrix,
  clmatsel,edcustom, stinput,findstud,tcommon2,showuser,wsToolbarwin, tttoolbarwin,
  gentool,blcktool,tcommon5,CustomOutput, DCPrijndael,DCPsha256,DCPsha1, uAMGClassSubject,
  uAMGTeacher, uAMGSubject, uAMGCommon, XML.UTILS;



function GetSpecialFolderPath(folder : integer) : string;
const   SHGFP_TYPE_CURRENT = 0;
var   path: array [0..MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0,folder,0,SHGFP_TYPE_CURRENT,@path[0])) then
    Result := path
  else
    Result := '';
end;


function getTextWidthOnLabel(_Text: string; _Font: TFont): integer;
begin
  with TLabel.Create(Nil) do
  try
    AutoSize := True;
    Font.Assign(_Font);
    Caption :=  _Text;
    Result := Width;
  finally
    free;
  end;

end;  

function findStudentByID(fStudID: string): smallint;
var
 i:  integer;
 astr: string;
begin
 result:=0;  astr:=Uppercase(trim(fStudID));
 for i:=1 to XML_STUDENTS.numstud do
  if astr=Uppercase(trim(XML_STUDENTS.Stud[i].ID)) then
   begin
    result:=i; break;
   end;
end;

procedure RenewFont(MyCanvas: Tcanvas);
begin
 if MyCanvas.Font<>XML_DISPLAY.tcFont then MyCanvas.Font.Assign(XML_DISPLAY.tcFont);
end;

function StartEndTime(d,p:integer):string;
var
  aStr, bstr: string;
begin
  longtimeformat:='h:mmam/pm';
  if tsStart[d,p] >= 0 then
   astr := TimeToStr(tsStart[d,p])
  else
   aStr := TimeToStr(0);

  astr:=leftstr(astr,length(astr)-2);
  bstr:=TimeToStr(tsEnd[d,p]);
  Result:=astr+'-'+bstr;
end;

function WildSub(su: integer):string;
var
 s: string;
begin
 s:='';
 if su<0 then s:=copy(SubCode[abs(su)],1,lencodes[0]-1)+'*';
 if su>0 then s:=SubCode[su];
 result:=trim(s);
end;

function FNws(b,y,l,offset: smallint): tpIntPoint;
var
 Ad:            word;
 TempPointer:   pointer;
 IntPoint:      tpIntPoint;
begin
 tempPointer:=WSMain[b];
 Ad:=(word(wsmem1)*word(Y))+(szWScell*word(L))+word(offset);
 IntPoint:=tempPointer;
 inc(IntPoint,(Ad div 2));
 result:=IntPoint;
end;

function FNWSbyte(b,y,l,offset: smallint): tpBytePoint;
var
 Ad:            word;
 TempPointer:   pointer;
 BytePoint:      tpBytePoint;
begin
 tempPointer:=WSMain[b];
 Ad:=(word(wsmem1)*word(Y))+(szWScell*word(L))+word(offset);
 BytePoint:=tempPointer;
 inc(BytePoint,Ad);
 result:=BytePoint;
end;

procedure CheckClassOnTt;
var
 i,j,a: integer;
begin
 for i:=0 to years_minus_1 do
  for j:=1 to level[i] do
   begin
    a:=ClassShown[j,i];
    if (a<0) or (a>classnum) or (ClassCode[a]='') then ClassShown[j,i]:=0;
   end;
end;

procedure CheckClassInStuds;
var
 i,a: integer;
begin
 for i:=1 to XML_STUDENTS.numstud do
  begin
   a:=XML_STUDENTS.Stud[i].TcClass;
   if (a<0) or (a>classnum) or (ClassCode[a]='') then XML_STUDENTS.Stud[i].TcClass:=0;
  end;
end;

function TooMany(myKind: string; myCount,myMax:integer):boolean;
var
 msg: string;
begin
 result:=false;
 if myCount>=myMax then
  begin
   msg:='The maximum number of '+myKind+' is '+inttostr(myMax)+'.'+endline;
   msg:=msg+'You cannot add more '+myKind+'.';
   messagedlg(msg,mtError,[mbOK],0);
   result:=true;
  end;
end;

Procedure DoAllTtClashes;
var
 d,p: integer;
begin
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do Fclash[d,p]:=1;
 ttclash;
end;

Function NoStuds: boolean;
var
 msg: string;
begin
 result:=false;
 if XML_STUDENTS.numstud=0 then
  begin
   msg:='No Students entered.';
   messagedlg(msg,mtError,[mbOK],0);
   result:=true;
  end;
end;

Function SaveBlocksCancel: boolean;
var
 msg:     string;
 msgret:  word;
begin
 result:=false;
 countSubsInBlock;
 if saveBlockFlag and (subsinblock>0) and (usrpasslevel>utGen) and (usrpasslevel<>utStud) then
  begin
   msg:='The Blocks have been altered.'+endline;
   msg:=msg+'Save the Blocks ?';
   msgret:=messagedlg(msg,mtWarning,[mbYes,mbNo,mbCancel],0);
   if msgret=mrCancel then
   begin
     Result := True;
     PendingClassSubjects.Clear;
   end;
   if msgret=mrYes then
    begin
     if blockfile>'' then saveBlock else SaveBlocksAs; {get block filename}
    end;
  end;
end;

Function SaveTTCancel: boolean;
var
 msg:     string;
 msgret:  word;
begin
 result:=false;
 if saveTimeFlag and ((usrPassLevel=utTime) or (usrPassLevel=utSuper))then
  begin
   msg:='The Timetable has been altered.'+endline;
   msg:=msg+'Save the Timetable ?'+endline+'(Press Cancel to continue working with current Timetable)';
   msgret:=messagedlg(msg,mtWarning,[mbYes,mbNo,mbCancel],0);
   if msgret=mrYes then saveTTable;
   if msgret=mrCancel then result:=true;
  end;
end;

function findsubinfac(fnum,snum: integer): boolean;
var
 i,sn1:       integer;
 a1Str,a2Str: string;
begin
 result:=false;
 if fnum=0 then begin result:=true; exit; end;
 if fnum<1 then exit;
 for i:=1 to faccount[fnum] do
  if (facSubs[fnum,i]=snum) then
   begin
    result:=true; break;
   end;
 if result then exit;
 a1Str:=copy(SubCode[snum],1,lencodes[0]-1);
 for i:=1 to faccount[fnum] do
  begin
   sn1:=ABS(facSubs[fnum,i]);
   if (facSubs[fnum,i]<0) then
    begin
     a2str:=copy(SubCode[sn1],1,lencodes[0]-1);
     if a2Str=a1Str then
      begin
       result:=true; break;
      end;
    end;
  end; {for i}
end;

function RemoveExtension(s: string): string;
var
 i: integer;
begin
 i:=pos('.',s);
 if i>0 then s:=copy(s,1,i-1);
 result:=s;
end;

function clearcustom: wordbool;
var
 i  : smallint;
 Msg: string;
begin
 clearcustom:=false;
 Msg:='Are you sure you want to clear the current Custom Information?';
 if ((AddNum=0) or (messagedlg(Msg,mtWarning,[mbyes,mbno],0)=mrYes)) then
  begin
   clearcustom:=true;
   AddNum:=0;
   for i:=0 to nmbrCustom do
    begin
     customTab[i]:=0;
     Add[i]:=''
    end;
   UpdateWindow(wnInfo);
  end;
end;

procedure ReadCustom;
var
 f    : textfile;
 fname: string;
 s    : string;
 i    : smallint;
begin
 gotCustom:=false;
 if (custom>'') then
  begin
   fname:= custom+'.CUS';
   doAssignFile(f,fname);
   if fileexists(fname) then
    try
     try
      filemode:=fmOpenRead+fmShareDenyNone;
      reset(f);
      readln(f,s);
      s:=trim(s);
      AddNum:=strToInt(s);
      if (AddNum>0) then
       for i:=1 to AddNum do
        begin
         readln(f,s);
         s:=trim(s);
         customTab[i]:=strToInt(s);
         readln(f,Add[i])
        end;
      gotCustom:=true;
     finally
      closefile(f)
     end;

    except
    end;
  end;
end;

procedure CalcWeekMaxLoad;
var
 d,p: integer;
 MaxLoad: double;
begin
 MaxLoad:=0;
  for d:=0 to days-1 do
   for p:=0 to Tlimit[d]-1 do
    MaxLoad:=MaxLoad+tsAllot[d,p];
 try
  WeekMaxLoad:=Round(MaxLoad);
 except
  WeekMaxLoad:=days*periods;
 end;
end;


procedure DayGroupCalc;
var
 i,j,k: integer;
begin
 daygroupcount;
// Calculate array
//dg[a,0] holds count of days in group a
//dg[a,1] first day in group a
 for i:=0 to nmbrdays do
  for j:=0 to nmbrdays do dg[i,j]:=0;

 for i:=1 to days do
  begin
   j:=DayGroup[i-1];
   inc(dg[j,0]);
   dg[j,dg[j,0]]:=i-1;
  end;

 k:=0; {pack array into lower part of dg array}
 for i:=1 to days do
  if dg[i,0]>0 then
   begin
    inc(k);
    for j:=0 to days do dg[k,j]:=dg[i,j];
   end;

end;

function TeachInAnyFac(j,MyFac:smallint):boolean;
begin
result:=((MyFac<=0) or (XML_TEACHERS.Tfaculty[j,1]=MyFac) or (XML_TEACHERS.Tfaculty[j,1]=-1)
  or (XML_TEACHERS.Tfaculty[j,2]=MyFac) or (XML_TEACHERS.Tfaculty[j,3]=MyFac) or (XML_TEACHERS.Tfaculty[j,4]=MyFac))
end;

Function RoomInAnyFac(j,MyFac:smallint):boolean;
begin
result:=((MyFac<=0) or (XML_TEACHERS.Rfaculty[j,1]=MyFac) or (XML_TEACHERS.Rfaculty[j,1]=-1)
  or (XML_TEACHERS.Rfaculty[j,2]=MyFac) or (XML_TEACHERS.Rfaculty[j,3]=MyFac))
end;

procedure CalcSubReportCodes;
var
 i: integer;
begin
 if NumSubRepCodes=0 then
  begin
   LenSubRepCode:=lencodes[0]; LenSubRepName:=snsize;
  end;
 if NumSubRepCodes>0 then
  for i:= 1 to NumSubRepCodes do
   begin
    if (SubReportCode[i]='') then SubReportCode[i]:=SubCode[i];
    SubReportCode[i]:=LeftStr(SubReportCode[i],LenSubRepCode);
    if (SubReportName[i]='') then SubReportName[i]:=SubName[i];
    SubReportName[i]:=LeftStr(SubReportName[i],LenSubRepName);
   end;
 if NumSubRepCodes<NumCodes[0] then
  for i:= NumSubRepCodes+1 to NumCodes[0] do
   begin
    SubReportCode[i]:=LeftStr(SubCode[i],LenSubRepCode);
    SubReportName[i]:=LeftStr(SubName[i],LenSubRepName);
   end;
end;

procedure updatebackupfile;
var
 backup:  file;
 i,StrLen: smallint;
begin
 try
  try
   chdir(Directories.progdir);
   doAssignFile(backup,'BACK.DAT');
   rewrite(backup,1);
   blockwrite(backup,backup_number,sizeof(smallint));
    for i:=1 to nmbrBackupDisks do
     begin
      StrLen:=Length(BackupPath[i]);
      blockwrite(backup,StrLen,sizeof(smallint));
      blockwrite(backup,BackupPath[i][1],StrLen);
     end;
    blockwrite(backup,LastUpdateCheck,sizeof(tdatetime));
  finally
   CloseFile(backup);
  end;
 except
 end;
end;

function rotit(lin:string):string;
 var
  i:integer;
 begin
  try
   result:=lin;
   for i:=1 to length(result) do
   begin
    if (upcase(result[i]) in ['A'..'Z']) then
    begin
     if upcase(result[i])>='N' then
      result[i]:=chr(ord(result[i])-13)
     else
      result[i]:=chr(ord(result[i])+13)
    end;
   end;
  except
  end;
 end;

function GetEncryptStr(KeyFileName,KeyStr: shortstring):string;
var  {read file, decrypt and check hash}
 ReadInStr,DecryptStr,CRCstr: shortstring;
 Source: shortstring;
 Cipher: TDCP_Rijndael;
 Hash: TDCP_sha256;
 Digest: array[0..50] of byte;  // RipeMD-160 produces a 160bit digest (20bytes)
 i,FLen: integer;
 s: shortstring;
 f: file;
begin
 result:='';
 KeyStr:=rotit(KeyStr);
 ReadInStr:='';

 chdir(Directories.progdir);
 if fileexists(KeyFileName) then
  begin
   assign(f,KeyFileName);
   filemode:=fmOpenRead+fmShareDenyNone;
   reset(f,1);
   FLen:=filesize(f);
   setlength(ReadInStr,FLen);
   blockread(f,ReadInStr[1],FLen);
   closefile(f);
  end
 else exit; // no file

 Cipher:= TDCP_Rijndael.Create(nil);
 Cipher.InitStr(KeyStr,TDCP_sha1);         // initialize the cipher with a hash of the passphrase
 DecryptStr:= Cipher.DecryptString(ReadInStr);
 Cipher.Burn;
 Cipher.Free;

 Source:='';
 Source:=copy(DecryptStr,1,length(DecryptStr)-40);
 CRCstr:='';
 CRCstr:=copy(DecryptStr,length(DecryptStr)-39,length(DecryptStr));

 fillchar(Digest,sizeof(Digest),0);

 if Source <> '' then
  begin
   Hash:= TDCP_sha256.Create(nil);          // create the hash
   Hash.Burn;
   Hash.Init;                                   // initialize it
   Hash.Update(Source,length(Source));
   Hash.Final(Digest);                          // produce the digest
   Hash.Free;
   s:= '';
   for i:= 0 to 19 do
     s:= s + IntToHex(Digest[i],2);

   if CRCstr=s then result:=Source;
 end;
end;

procedure checkTeFaculty(var fac1,fac2,fac3,fac4: smallint);
begin
 if fac1<0 then fac1:=-1;
 if ((fac1=-1) or (fac2=-1) or (fac3=-1)or (fac4=-1)) then
 begin
  fac1:=-1; fac2:=0; fac3:=0; fac4:=0;
 end;
 if (fac1>FacNum) then fac1:=0;
 if (fac2<0) or (fac2>FacNum) then fac2:=0;
 if (fac3<0) or (fac3>FacNum) then fac3:=0;
 if (fac4<0) or (fac4>FacNum) then fac4:=0;
end;

procedure checkRoFaculty(var fac1,fac2,fac3: smallint);
begin
 if fac1<0 then fac1:=-1;
 if ((fac1=-1) or (fac2=-1) or (fac3=-1)) then
 begin
  fac1:=-1; fac2:=0; fac3:=0;
 end;
 if (fac1>FacNum) then fac1:=0;
 if (fac2<0) or (fac2>FacNum) then fac2:=0;
 if (fac3<0) or (fac3>FacNum) then fac3:=0;
end;

procedure SetStArrays;
begin
 setlength(StGroup,(XML_STUDENTS.numStud+1)); {zero based so +1}
 setlength(StPointer,(XML_STUDENTS.numStud+1)); {zero based so +1}
 setlength(StudSort,(XML_STUDENTS.numStud+2)); {zero based so +1}
 setlength(XML_STUDENTS.Stud,(XML_STUDENTS.numStud+1)); {zero based so +1}
end;

function GetStudentName(st:integer):string;
var
 s:string;
 j,k: smallint;
begin
 with XML_STUDENTS.Stud[st] do
  begin
   s:=stname+' '+first+'   ';
   if XML_DISPLAY.sTyear then s:=s+YearShort+' '+yearname[TcYear]+' ';
   if XML_DISPLAY.stSex then s:=s+Sex+' ';
   if XML_DISPLAY.stID then s:=s+ID+' ';

   //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
   begin
    if XML_DISPLAY.stID2 then s:=s+studID2[st]+' ';
    if XML_DISPLAY.stEmail then s:=s+studemail[st]+' ';

   end;

   if XML_DISPLAY.stClass then s:=s+ClassCode[Tcclass]+' ';
   if XML_DISPLAY.stHouse then s:=s+Housename[house]+' ';
   if XML_DISPLAY.stTutor then s:=s+XML_TEACHERS.Tecode[tutor,0]+' ';
   if XML_DISPLAY.stHome then s:=s+XML_TEACHERS.Tecode[home,1]+' ';
   if XML_DISPLAY.stTag and (TagOrderNum>0) then
    for j:=1 to TagOrderNum do
    begin
      k:=TagOrder[j];
      if StudHasTag(st,k) then s:=s+TagName[k]+'/';
    end;
    if RightStr(s, 1) = '/' then
      s := Copy(s, 1, Length(s) -1);
  end;
 result:=s;
end;

Procedure CheckSelections;
begin
 if wnFlag[wnSuCode] then if (SuWindow.selcode>Numcodes[0]) then SuWindow.selcode:=0;
 if wnFlag[wnTeCode] then if (TeWindow.selcode>Numcodes[1]) then TeWindow.selcode:=0;
 if wnFlag[wnRoCode] then if (RoWindow.selcode>Numcodes[2]) then RoWindow.selcode:=0;
 if wnFlag[wnRClassCode] then if (RollClassWindow.selcode>Classnum) then RollClassWindow.selcode:=0;
 if wnFlag[wnFac] then if (FacultyWindow.selcode>facNum) then FacultyWindow.selcode:=0;
 if wnFlag[wnHouse] then if (HouseWindow.selcode>HouseCount) then HouseWindow.selcode:=0;
 if wnFlag[wnGroupSub] then if subyearwin.selcode>GroupSubs[0]
            then subyearwin.selcode:=0;
end;

procedure parseCustomInfo;
var
 i,j,k: smallint;
 a: string;
begin
 for i:=0 to nmbrCustom do CustomArr[i]:='';
 j:=1;  a:=''; CustomCnt:=0;
 if AddNum=0 then exit;
 for i:= 1 to AddNum do
  begin
   if customTab[i] = 1000 then
    begin {continue from previous line}
      CustomArr[j]:=CustomArr[j]+Add[i]
    end
    else
     if customTab[i]<0 then
      begin {no of blank lines}
       for k:=1 to abs(customTab[i]) do inc(j){next line}
      end
     else
      begin {chars in from left}
       if ((j>1) and (length(CustomArr[j-1])<customTab[i])) then
        begin {continue on after line}
         a:=copy(stringpadchr(250,' '),1,(customTab[i]-length(CustomArr[j-1])));
         CustomArr[j-1]:=CustomArr[j-1]+a+Add[i]
        end
       else {new line}
        begin
         a:=stringpadchr(customTab[i],' ');
         a:=a+Add[i];
         CustomArr[j]:=a;
         inc(j){next line}
        end;
      end;
      CustomArr[i]:=TrimRight(CustomArr[i])
  end; {for i}
 CustomCnt:=j-1
end;

function CheckStudInSub(st,sub: integer): boolean;
var
 j,a: integer;
 found: boolean;
begin
 found:=false;
 for j:=1 to chmax do
   begin
    a:=XML_STUDENTS.Stud[st].choices[j];
    if a<>0 then
     if (a=sub) and ((sexbalance=0) or ((sexbalance=1) and (XML_STUDENTS.Stud[st].Sex=genderShort[1]))
      or ((sexbalance=2) and (XML_STUDENTS.Stud[st].Sex=genderShort[0]))) then
     begin
      found:=true;
      break;
     end;
   end; {for j}
 result:=found;
end;

function GetWindow(wn:smallint): TDrawWin;
var
 mywin:TDrawWin;
begin
 mywin:=nil;
 case wn of
  wnInfo: mywin:=InfoWin;
  wnSucode: mywin:=SuWindow;
  wnTecode: mywin:=TeWindow;
  wnRocode: mywin:=RoWindow;
  wnRClassCode: mywin:=RollClassWindow;
  wnFac: mywin:=FacultyWindow;
  wnHouse: mywin:=HouseWindow;
  wnTimes: mywin:=TimesWindow;
  wnGroupSub: mywin:=SubYearWin;
  wnCmatrix: mywin:=cmatWin;
  wnStInput: mywin:=Stuinput;
  wnCHelp: mywin:=ClashHelp;
  wnBlockClashes: mywin:=BlockClashesWin;
  wnTeClash: mywin:=TeacherClashes;
  wnRoClash: mywin:=RoomClashes;
  wnTeFree: mywin:=TeachersFree;
  wnRoFree: mywin:=RoomsFree;
  wnTeTimes: mywin:=TeacherTimes;
  wnSuTimes: mywin:=SubjectTimes;
  wnGroupTe: mywin:=GroupofTeachers;
  wnFindStud: mywin:=FindStudent;
  wnStudentTt: mywin:=STtable;
  wnRoomTt: mywin:=RoTtable;
  wnTeacherTt: mywin:=TeTtable;
  wnStudentList: mywin:=StudentListWin;
  wnSubjectList: mywin:=SubBySubjectWin;
  wnTimeList: mywin:=SubByTimeSlotWin;
  wnSubjectTt: mywin:=SuTtable;
  wnTeList: mywin:=TeListWin;
  wnStBlClash: mywin:=StClashWin;
  wnStFRee: mywin:=StudFreeWin;
  wnShowUsers: mywin:=ShowUsersWin;
  wnStudentTag :mywin:=FrmListTagNames;//mantis-0727
 end;
 result:=mywin;
end;

procedure UpdateWindow(wn:smallint);
var
 mywin: TDrawWin;
begin
 if wnFlag[wn] then
  begin
   mywin:=GetWindow(wn);
   if (mywin is TdrawWin) then mywin.UpdateWin;
  end;
end;

function getfacname(a:integer): string;
begin
  result:='';
  if a=-1 then result:='All Faculties'
          else if (a>0) and (a<=FacNum)
          then result:=facName[a];
end;

procedure TickCodeSubMenu(mitem:TMenuItem);
begin
 if mitem.count>0 then
  begin
//   original order of items
//   mitem.items[0].Checked:=wnFlag[wnSuCode];
//   mitem.items[1].Checked:=wnFlag[wnTeCode];
//   mitem.items[2].Checked:=wnFlag[wnRoCode];
//   mitem.items[3].Checked:=wnFlag[wnRClassCode];
//   mitem.items[4].Checked:=wnFlag[wnFac];
//   mitem.items[5].Checked:=wnFlag[wnHouse];
//   mitem.items[6].Checked:=wnFlag[wnTimes];

   mitem.items[0].Checked:=wnFlag[wnHouse];
   mitem.items[1].Checked:=wnFlag[wnSuCode];
   mitem.items[2].Checked:=wnFlag[wnFac];
   mitem.items[3].Checked:=wnFlag[wnTeCode];
   mitem.items[4].Checked:=wnFlag[wnRoCode];
   mitem.items[5].Checked:=wnFlag[wnRClassCode];
  end;
end;

procedure calcSelectDays;
var
 dI,dI2,dI3:      integer;
begin
 if XML_DISPLAY.ttWeekDaysFlg then
  begin
   SelDays:=0;
   for dI:=0 to days-1 do
    if XML_DISPLAY.Dprint[dI+1] then
     begin Xday[SelDays]:=dI; inc(SelDays); end;
  end
 else
  begin
   SelDays:=days;
   for dI:=0 to days-1 do Xday[dI]:=dI;
  end;
 ShowTnames[0]:=true;  {show time slots for first day}
 if SelDays>1 then
  for dI:=1 to SelDays-1 do
   begin
    dI2:=Xday[dI];   dI3:=Xday[dI-1];
    ShowTnames[dI]:=(DayGroup[dI2]<>DayGroup[dI3]);
   end;
end;

procedure SetPshowMax;
var
 d,p,tmax:      smallint;
begin
 tsShowMax:=0;  DayOfMaxPeriods:=0;
 for d:=0 to nmbrdays-1 do
  begin
   tsShowMaxDay[d]:=0;
   if ((Tlimit[d]>periods) or (Tlimit[d]<1)) then Tlimit[d]:=periods;
   for p:=0 to periods do tsShow[d,p]:=0;
  end;
 for d:=0 to days-1 do
  begin
   tmax:=0;
   for p:=0 to tlimit[d]-1 do
    if XML_DISPLAY.tsOn[d,p] then begin inc(tmax); tsShow[d,tmax]:=p; end;
   tsShowMaxDay[d]:=tmax;
   if tmax>tsShowMax then
    begin
     DayOfMaxPeriods:=d;
     tsShowMax:=tmax;
    end;
  end;
 calcSelectDays;
end;

function findStudBIN(astr: string): smallint;
var
 a,b,aLen,fI,z: smallint;
 fStr:string;
 found,fin: boolean;

  function nameLess(cc:smallint):smallint;
  var
   tmpstr: string;
  begin
   tmpstr:=XML_STUDENTS.Stud[cc].StName+' '+XML_STUDENTS.Stud[cc].First;
   tmpstr:=uppercase(trim(tmpstr));
   tmpstr:=copy(tmpstr,1,aLen);
   //break out if found
   if tmpstr=fstr then
   begin
    found:=true; fI:=cc; result:=2;
    exit;
   end;
   if tmpstr<fstr then result:=1 else result:=3;
  end;

  procedure halfCheck;
  var
   c: smallint;
  begin
   c:=((b-a) div 2) + a;
   if ((c=a) or (c=b)) then fin:=true;  //cannot split anymore
   if (nameLess(c)=1) then a:=c else b:=c;
  end;

begin
 fstr:=uppercase(trim(astr)); aLen:=length(fstr); result:=0;
 a:=1; b:=XML_STUDENTS.numstud; found:=false; fin:=false;
 nameLess(a); nameLess(b);
 while ((not(found)) and (not(fin))) do halfCheck;

 z:=fI;
 if found then
 begin
//have match but need to ensure it's the first match
  while ((z>1) and (nameLess(z-1)<>1)) do
   dec(z);
  result:=z;   //nameLess changes fI on us, hence use z
 end; {if found}
end;

procedure WinOutput(winNum: smallint);
begin
 try
  screen.cursor:=crHourglass;
  case winNum of
    wnInfo:   tcinfo.infoTextExp;
    wnSucode: SuWnd.SuCodeOut;
    wnTecode: TeCodeOut;
    wnRocode: RoCodeOut;
    wnRClassCode: RollCodeOut;
    wnFac: FaCodeOut;
    wnHouse: HoCodeOut;
    wnTimes: TimesOut;  {Times window}
    wnGroupSub: SubyearOut;
    wnBlock: blockswintext;
    wnSubjectList: subbysubOut;
    wnTimeList: subbytimeslotOut; {subjects by time slot}
    wnStudentList: StudentlistOut;
    wnStudentTt: studTtableOut;
    wnTtable:  ttable.maintimetabletext; {main timetable}
    wnCmatrix: clmatrixtext;
    wnStInput: Stuinputtext;
    wnCHelp: ClashHelptext;
    wnBlockClashes: BlockClashestext;
    wnTeClash: TeacherClashestext;
    wnRoClash: RoomClashestext;
    wnTeFree: TeachersFreetext;
    wnRoFree: RoomsFreetext;
    wnTeTimes: TeacherTimestext;
    wnSuTimes: SubjectTimesText;
    wnGroupTe: groupofteacherstext;
    wnTeacherTt: teacherTtableOut;
    wnRoomTt: roomTtableOut;
    wnSubjectTt: subjectTtabletext;
    wnFindStud: findstudenttext;
    wnTeList: TeListOut;
    wnStBlClash: StBlockClashOut;
    wnStFRee: StudFreeOut;
    wnShowUsers: ShowUsersWinOut;
    wnWorksheet: workSheetText;
    wnStudentTag: ListTagNames.SuTagOut;    //mantis-0727

    wnUserExport1: Transfer1TextExport;  {custom for Transfer 1}
    wnUserExport2: Transfer2TextExport;  {custom for Transfer 2}
    wnUserExport3: Transfer3TextExport;  {custom for Transfer 3}
    wnUserExportStud: TransferTextExport;  {custom for Transfer 4}
  end; {case}
 finally
  screen.cursor:=crDefault;
 end;
end;

function findDay(s: string): smallint;
var
 i:  smallint;
begin
 result:=-1;
 s:=trim(s);
 if s='' then exit;
 for i:=0 to days-1 do
   if pos(UpperCase(s),UpperCase(Day[i]))>0 then
     begin
       result:=i;
       break;
     end;
end;

function FindYear(s: string): smallint;
var
 aStr,bStr:   string;
 i,j,aLen,bLen,mLen:       smallint;
begin
 aStr:=UpperCase(trim(s));
 aLen:=Length(aStr);   j:=-1;   mLen:=99;
 if aLen>0 then
  for i:=0 to years-1 do
  begin
   bStr:=UpperCase(trim(yearname[i]));
   bLen:=length(bStr);
   bStr:=copy(bStr,1,aLen);
   if aStr=bStr then
   begin
    if bLen<=mLen then
    begin
     mLen:=bLen;  //keep only minimum match
     j:=i;
     if aLen=bLen then break;  //continue search unless perfect match found
    end;
   end;
  end; {for i}
 result:=j;
end;

function findPeriod(sday:integer; s: string): smallint;
var
 i:  smallint;
begin
 result:=-2;
 s:=trim(s);
 if s='' then exit;
 for i:=0 to Tlimit[sday]-1 do
  if pos(UpperCase(s),UpperCase(TimeSlotName[sday,i]))>0 then
   begin
    result:=i;
    break;
   end;
end;

function FindRollClasscode(s:string): smallint;
var
 i,j: smallint;
begin
 j:=0; s:=uppercase(s);
 if classnum>0 then
  for i:=1 to classnum do
   if (s>'') and (uppercase(trim(ClassCode[i]))=s) then
    begin
     j:=i; break;
    end;
 result:=j
end;

procedure topcentre(fm: Tform);
begin
 fm.top:=0;
 fm.left:=(screen.width-fm.width) div 2;
end;

procedure setdays;
var
 i: smallint;
begin

 for i := 0 to 10 do
   Day[i] := Dayname[i];
 {if days=5 then
  begin
   for i:=0 to 10 do Day[i]:=BaseDay[i];
  end
 else
  for i:=0 to 10 do Day[i]:='DAY'+inttostr(i+1);}
end;

procedure SetTimeCell;

 procedure SetCell(var d,p,y,l: byte);
 begin
  try
   if d>=days then d:=days-1;
   if p>=Tlimit[d] then p:=Tlimit[d]-1;
   if y>=years then y:=years-1;
   if l<1 then l:=1;
   if l>level[y] then l:=level[y];
  except
   d:=0; p:=0; y:=years-1; l:=1;
  end;
 end;

begin
 SetCell(dl,pl,yl,ll);
 SetCell(nd,np,ny,nl);
 SetCell(hd,hp,hy,hl);
end;


procedure saveWinpos(tf: Tform);
begin
 XML_DISPLAY.winpos[tf.tag].state:=tf.windowstate;
 // tf.windowstate:=wsNormal;         {avoiding having max'd wins on restore}
 XML_DISPLAY.winpos[tf.tag].top:=tf.top;       {doesn't look good-  lots of flashing}
 XML_DISPLAY.winpos[tf.tag].left:=tf.left;
 XML_DISPLAY.winpos[tf.tag].width:=tf.width;
 XML_DISPLAY.winpos[tf.tag].height:=tf.height;
end;

procedure CopyExportWindow(winNum: smallint);
begin
 try
  ClipBoard.Open;
  CopyOut:=True;
  WinOutput(winNum);
  ClipBoard.SetTextBuf(Pchar(myCopyString));
 finally
  Clipboard.Close;
  CopyOut:=False;
 end;
end;

procedure InsertCode(code,place:integer);
var
 i,pos: integer;
 tmpStr1,tmpStr2: string;  //tmpStr2  mantis-1295
begin
 pos:=codeCount[code]+1;
 case XML_DISPLAY.sorttype[code] of
  0: begin
      for i:=1 to codeCount[code] do
       if place<codepoint[i,code] then
        begin pos:=i; break; end;
     end;
  1: begin
      tmpStr1:=uppercase(FNsub(place,code));
    for i:=1 to codeCount[code] do
     if tmpStr1<uppercase(FNsub(codepoint[i,code],code)) then
      begin pos:=i; break; end;
     end;
  2: begin
      tmpStr1:=uppercase(FNsubname(place,code));
    for i:=1 to codeCount[code] do
     if tmpStr1<uppercase(FNsubname(codepoint[i,code],code)) then
      begin pos:=i; break; end;
     end;


 end; {case}
 if pos<=codeCount[code] then
  for i:= codeCount[code] downto pos do
   codepoint[i+1,code]:=codepoint[i,code];
 inc(codeCount[code]);
 codepoint[pos,code]:=place;
end;

function FindNextCode(code: smallint): smallint;
var
 codeplace,i: smallint;
begin
 codePlace:=NumCodes[code]+1;
 for i:=1 to numCodes[code] do {search for available deleted code}
  if (copy(FNsub(i,code),1,2)='00') then
   begin
    codePlace:=i;
    break;
   end;
 if codePlace>numCodes[code] then numCodes[code]:=codePlace;
 result:=codePlace;
end;

Procedure UpdateStudID2File(year:smallint);
var
 StudID2file:               file;
 i:                  smallint;
 tmpStr:                 string;
 YearDigit:     string[2];
 fname: string;
begin
 try
  try
   chdir(Directories.Datadir);
   YearDigit:=inttostr(year+1);
   YearDigit:=trim(YearDigit);
   fname:='STUID'+YearDigit+'.DAT';
//   doAssignFile(codefile,'STUID.DAT');
   doAssignFile(StudID2file,fname);
   rewrite(StudID2file,1);

   if XML_STUDENTS.numstud>0 then
   begin
    for i:=1 to XML_STUDENTS.numstud do
    begin
     if XML_STUDENTS.Stud[i].TcYear=year then
     begin
      tmpStr:=RPadString(XML_STUDENTS.Stud[i].ID,10);
      blockwrite(StudID2file,tmpStr[1],10);
      tmpStr:=RPadString(studID2[i],10);
      blockwrite(StudID2file,tmpStr[1],10);
     end;
    end; {for i}
   end;

  finally
   closefile(StudID2file);
  end;
 except
 end;
end;

Procedure UpdateStudID2FileNew(year:smallint);
var
 StudID2file:               file;
 i:                  smallint;
 tmpStr:                 string;
 YearDigit:     string[2];
 fname: string;
begin
 try
  try
   chdir(Directories.Datadir);
   YearDigit:=inttostr(year+1);
   YearDigit:=trim(YearDigit);
   fname:='STUIDNew'+YearDigit+'.DAT';
//   doAssignFile(codefile,'STUID.DAT');
   doAssignFile(StudID2file,fname);
   rewrite(StudID2file,1);

   if XML_STUDENTS.numstud>0 then
   begin
    for i:=1 to XML_STUDENTS.numstud do
    begin
     if XML_STUDENTS.Stud[i].TcYear=year then
     begin
      tmpStr:=RPadString(XML_STUDENTS.Stud[i].ID,10);
      blockwrite(StudID2file,tmpStr[1],10);
      tmpStr:=RPadString(studID2[i],50);
      blockwrite(StudID2file,tmpStr[1],50);
      tmpStr:=RPadString(studEmail[i],100);
      blockwrite(StudID2file,tmpStr[1],100);
     end;
    end; {for i}
   end;

  finally
   closefile(StudID2file);
  end;
 except
 end;
end;

Procedure UpdateSubReportFile;
var
 codefile:               file;
 i:                  smallint;
 tmpStr:                 string;
begin
 try
  try
   CalcSubReportCodes;
   chdir(Directories.Datadir);
   doAssignFile(codefile,'SUBREP.DAT');
   rewrite(codefile,1);
   blockwrite(codefile,NumSubRepCodes,2);
   blockwrite(codefile,LenSubRepCode,2);
   blockwrite(codefile,LenSubRepName,2);
   if NumSubRepCodes>0 then
    for i:=1 to NumCodes[code] do
      begin
       tmpStr:=RPadString(SubReportCode[i],LenSubRepCode);
       blockwrite(codefile,tmpStr[1],LenSubRepCode);
       tmpStr:=RPadString(SubReportName[i],LenSubRepName);
       blockwrite(codefile,tmpStr[1],LenSubRepName);
      end;
  finally
   closefile(codefile);
  end;
 except
 end;
end;

procedure updatesub(code: smallint);
var
codefile:               file;
file1,file2,file3  :          string;      //file3 // mantis-1295
i,j,v,datasection:                  smallint;
sub2:                   string;
name2:                  string;
subwillcount2:            string;     //// mantis-1295
tmpStr:                 string;
begin
 if usrPassLevel=utGen then exit;
 chdir(Directories.datadir);
 datasection:=0;
 case code of
  0:begin
     needClashMatrixRecalc:=true; datasection:=6;
     file1:='SUBCODE.DAT';  file2:='SUBNAME.DAT'; file3:='SubWillCount.DAT' ;
    end;
  1:begin
     file1:='TECODE.DAT';  file2:='TENAME.DAT'; datasection:=1;
    end;
  2:begin
     file1:='ROOMS.DAT';  file2:='ROOMNAME.DAT'; datasection:=2;
    end;
 end; {case}
 try
  try
   doAssignFile(codefile,file1);
   rewrite(codefile,1);
   blockwrite(codefile,NumCodes[code],2);
   blockwrite(codefile,LenCodes[code],2);
   if NumCodes[code]>0 then
    for i:=1 to NumCodes[code] do
    begin
     sub2:=RPadString(FNsub(i,code),LenCodes[code]);
     blockwrite(codefile,sub2[1],LenCodes[code]);
    end;
  finally
   closefile(codefile);
   FileAge(file1,NEW_DateChecks[datasection]);
   if code=0 then SaveSubsFlag:=false;
  end;
 except
 end;
 try
  try
   doAssignFile(codefile,file2);
   rewrite(codefile,1);
   if (code=0) and (snSize<>szSubnameDefault) then
    begin
     tmpstr:='TC4W';
     blockwrite(codefile,tmpstr[1],4);
     blockwrite(codefile,NumCodes[code],2);
     blockwrite(codefile,snsize,2);
    end
   else blockwrite(codefile,NumCodes[code],2);
   if NumCodes[code]>0 then
    for i:=1 to NumCodes[code] do
    begin
     if code=0 then
     begin
      name2:=RPadString(Subname[i],snsize);
      blockwrite(codefile,name2[1],snsize);
     end
     else
      begin
       name2:=RPadString(XML_TEACHERS.TeName[i,code-1],szTeName);
       blockwrite(codefile,name2[1],szTeName);
      end;
    end;
  finally
   closefile(codefile);
  end;
 except
 end;
 //----------------------// mantis-1295-------------------------------------


 try
  try
   doAssignFile(codefile,file3);
   rewrite(codefile,1);
   if (code=0) and (Subwillcountsize<>szSubWillCountMax) then
    begin
     tmpstr:='TC4W';
     blockwrite(codefile,tmpstr[1],4);
     blockwrite(codefile,NumCodes[code],2);
     blockwrite(codefile,Subwillcountsize,2);
    end
   else blockwrite(codefile,NumCodes[code],2);
   if NumCodes[code]>0 then
    for i:=1 to NumCodes[code] do
    begin
     if code=0 then
     begin
      if (Subwillcount[i] ='  ' ) or (Subwillcount[i] ='') then
         Subwillcount[i] :='Y'
      else
      Subwillcount2:=RPadString(Subwillcount[i],Subwillcountsize);

      blockwrite(codefile,Subwillcount2[1],Subwillcountsize);
     end ;

    end;
  finally
   closefile(codefile);
  end;
 except
 end;

 // ---------------------------// mantis-1295--------------------------------
 

 if code=0 then UpdateSubReportFile;
 if code=2 then
 begin
  try
   try
    doAssignFile(codefile,'RoLoad.DAT');
    rewrite(codefile,1);
    blockwrite(codefile,NumCodes[code],2);
    if NumCodes[code]>0 then
     for i:=1 to NumCodes[code] do
     begin
      blockwrite(codefile,XML_TEACHERS.RoSize[i],2);
      for j:=1 to 3 do
       blockwrite(codefile,XML_TEACHERS.Rfaculty[i,j],2);
     end;
   finally
    closefile(codefile);
   end;
  except
  end;

  try
   try
    doAssignFile(codefile,'RoAssign.DAT');
    rewrite(codefile,1);
    blockwrite(codefile,NumCodes[code],2);
    if NumCodes[code]>0 then
     for i:=1 to NumCodes[code] do
     begin
      blockwrite(codefile,Rotype[i],2);
      blockwrite(codefile,Rassign[i],2);
     end;
   finally
    closefile(codefile);
   end;
  except
  end;

 end;  {if code=2}
 if code<>1 then exit;
 try
  try
   doAssignFile(codefile,'TELOAD.DAT');
   rewrite(codefile,1);
   TC4fileHeader:='TCV4';
   if NumCodes[code]>0 then
   begin
    blockwrite(codefile,TC4fileHeader[1],4);
    for i:=1 to NumCodes[code] do
    begin
     blockwrite(codefile,XML_TEACHERS.Load[i],2);
     for v:=1 to 3 do
      blockwrite(codefile,XML_TEACHERS.Tfaculty[i,v],2);
     for j:=0 to 2 do
     begin
      tmpStr:=RPadString(XML_TEACHERS.DutyCode[i,j],szdutycode);
      blockwrite(codefile,tmpStr[1],szdutycode);
      blockwrite(codefile,XML_TEACHERS.dutyload[i,j],8); {double}
     end;
    end;
   end;
  finally
   closefile(codefile);
  end;
 except
 end;
 try {write out 4th faculty}
  try
   doAssignFile(codefile,'TeFac.DAT');
   rewrite(codefile,1);
   v:=1; {one faculty stored at the moment}
   blockwrite(codefile,NumCodes[code],2);
   blockwrite(codefile,v,2);
   if NumCodes[code]>0 then
    for i:=1 to NumCodes[code] do
      blockwrite(codefile,XML_TEACHERS.Tfaculty[i,4],2);
  finally
   closefile(codefile);
  end;
 except
 end;

end;

function setprintertitle(winNum: smallint):string;
var
 tmpStr:  string;
begin
 tmpStr:='Time Chart ';    {default, only there incase i miss one}
 case winNum of
  wnInfo: tmpStr:=tmpStr+'Information';   {info win}
  wnSucode: tmpStr:=tmpStr+'Subject Codes';
  wnTecode: tmpStr:=tmpStr+'Teacher Codes';
  wnRocode: tmpStr:=tmpStr+'Room Codes';
  wnRClassCode: tmpStr:=tmpStr+'Class List';
  wnFac: tmpStr:=tmpStr+'Faculty List';
  wnHouse: tmpStr:=tmpStr+'House List';
  wnTimes: tmpStr:=tmpStr+'Times List';

  wnGroupSub: tmpStr:=tmpStr+' Group Subjects';
  wnTtable: tmpStr:=tmpStr+' Main Timetable';
  wnBlock:tmpStr:=tmpStr+' Blocks';
  wnSubjectList: tmpStr:=tmpStr+'Subject List';
  wnTimeList: tmpStr:=tmpStr+'Students in Time Slot';
  wnStudentList: tmpStr:=tmpStr+'Student List';
  wnCmatrix: tmpStr:=tmpStr+'Clash Matrix';
  wnStInput: tmpStr:=tmpStr+'Student Selection Sheet';
  wnCHelp: tmpStr:=tmpStr+'Clash Help';
  wnBlockClashes: tmpStr:=tmpStr+'Block Clashes';
  wnTeClash: tmpStr:=tmpStr+'Teacher Clashes';
  wnRoClash: tmpStr:=tmpStr+'Room Clashes';
  wnTeFree: tmpStr:=tmpStr+'Teacher Frees';
  wnRoFree: tmpStr:=tmpStr+'Room Frees';
  wnTeTimes: tmpStr:=tmpStr+'Teacher Times';
  wnSuTimes: tmpStr:=tmpStr+'Subject Times';
  wnGroupTe: tmpStr:=tmpStr+'Group of Teachers';
  wnTeacherTt: tmpStr:=tmpStr+'Teacher Timetable';
  wnRoomTt: tmpStr:=tmpStr+'Room Timetable';
  wnSubjectTt: tmpStr:=tmpStr+'Subject Timetable';
  wnStudentTt: tmpStr:=tmpStr+'Student Timetable';
  wnTeList: tmpStr:=tmpStr+'Teacher Subject List';
  wnStBlClash: tmpStr:=tmpStr+'Students with Block Clashes';
  wnStFRee: tmpStr:=tmpStr+'Students Free in Blocks';
  wnFindStud: tmpStr:=tmpStr+'Student Find';
  wnStudentTag:tmpStr:=tmpStr+'Student Tag';    //mantis-0727
 end; {case}
 result:=tmpStr;
end;

procedure printOurWindowDetail(winNum: integer);
begin
 PweekCount:=0;
 case winNum of
  wnInfo:   tcinfo.infoprint;
  wnSucode: SuWnd.SuCodePrint;
  wnTecode: TeWnd.TeCodePrint;
  wnRocode:  RoWnd.RoCodePrint;
  wnRClassCode: RollClassWnd.RollCodePrint;
  wnFac:  FacWnd.FaCodePrint;
  wnHouse:  HouseWnd.HoCodePrint;
  wnTimes: TimesWnd.TimesPrint;
  wnGroupSub:   subyr.Subyearprint;  {subyear win}

  wnTtable:  ttable.maintimetableprint; {main timetable}
  wnBlock:  block1.blockswinprint;  {blocks window}
  wnSubjectList:  subbysub.subbysubprint; {subject list by subject}
  wnTimeList:  subbyslt.subbytimeslotprint; {subject list by time slot}
  wnStudentList:  studlist.Studentlistprint; {student list}
  wnCmatrix:  clmatrix.clmatrixprint; {clash matrix}
  wnStInput:  stinput.Stuinputprint; {student input}
  wnCHelp:  clashhlp.ClashHelpPrint; {clash help}
  wnBlockClashes:  blkclash.BlockClashesprint; {block clashes}
  wnTeClash:  teclash.TeacherClashesprint; {teacher clashes}
  wnRoClash:  roclash.RoomClashesprint; {room clashes}
  wnTeFree:  tefree.teachersfreeprint; {teachers free}
  wnRoFree:  rofree.roomsfreeprint; {rooms free}
  wnTeTimes:  tetimes.teachertimesprint; {teacher times}
  wnSuTimes:  subtimes.subjecttimesprint; {subject times}
  wnGroupTe:  grpofte.groupofteachersprint; {group of teachers}
  wnTeacherTt:  teachtt.teacherTtableprint; {teacher ttable}
  wnRoomTt:  roomtt.roomTtableprint; {room ttable}
  wnSubjectTt:  subjcttt.subjectTtableprint; {subject ttable}
  wnStudentTt:  studTtableprint; {student ttable}
  wnTeList: TeListPrint;
  wnStBlClash: StBlockClashPrint;
  wnStFRee: StudFreePrint;
  wnFindStud:  findstud.findstudentprint; {student find (tt)}
  wnShowUsers: ShowUsersWinPrint;
  wnWorksheet: worksheetPrint;
  wnStudentTag: ListTagNames.SuTagPrint;   //mantis-0727
 end; {case}

end;

procedure getprinterDPI(mycanvas:Tcanvas);
var
 dpix,dpiy:       integer;
 tmpHdc:  Hdc;
 t1,t2:   single;
begin
  tmpHdc:=mycanvas.handle;
  dpix:=getdevicecaps(tmpHdc,88);
  dpiy:=getdevicecaps(tmpHdc,90);
  t1:=dpix;
  t2:=dpiy;
  t1:=(XML_DISPLAY.prntLeftMargin/2.54)*t1;  {(cm/(cm/inch))*DPI=no. of pixels}
  prntHmargin:=integer(trunc(t1));
  t2:=(XML_DISPLAY.prntTopMargin/2.54)*t2;
  prntVmargin:=integer(trunc(t2));
end;

procedure printOurWindow(winNum: smallint);
begin
 if printer.printing then exit;
 if mainform.printdialog.execute then
  try
   screen.cursor:=crHourglass;
   printer.title:=setprintertitle(winNum);
   printer.begindoc;
   printer.canvas.font.assign(XML_DISPLAY.tcfont);
   getPrntFontWidths(Printer.canvas);
   getprinterDPI(Printer.canvas);
   PrinterOn:=true;
   printOurWindowDetail(winNum);
   printer.enddoc;
  finally
   printer.title:='';
   printerOn:=false;
   screen.cursor:=crDefault;
  end;
end;

procedure TextExportWindow(winNum: smallint);
var
 tmpStr,tmpDir:  string;
 txtDirtest:       smallint;
 customTitle: string;
 lFilter: string;
begin
 try
   case winNum of         //identify which custom output it is on the dialog
    wnUserExport1: customTitle:=Transfer1Caption;
    wnUserExport2: customTitle:=Transfer2Caption;
    wnUserExportStud: customTitle:='Student Transfer';
     else customTitle:=setprintertitle(winNum);
   end;
   if customTitle>'' then customTitle:=' - '+customTitle;

   if XML_DISPLAY.FExportFileIdx = 0 then
   begin
     MainForm.SaveDialog.Title := 'Text file out' + customTitle;
     lFilter := 'Text file|*.';
     textExportExtension := 'TXT';
   end
   else
   begin
     MainForm.SaveDialog.Title := 'CSV Comma delimited file out' + customTitle;
     lFilter := 'CSV (Comma Delimited)|*.';
     textExportExtension := 'CSV';
   end;
   MainForm.SaveDialog.Filter := lFilter + textExportExtension;
   MainForm.SaveDialog.InitialDir := Directories.datadir;
   MainForm.SaveDialog.DefaultExt := textExportExtension;
   MainForm.SaveDialog.HelpContext := 232;
   if winNum=wnUserExportStud then mainform.SaveDialog.HelpContext:=353;
   if mainform.SaveDialog.Execute then
   begin
    tmpStr:=ExtractFileName(mainform.SaveDialog.Filename);
    tmpStr:=RemoveExtension(tmpStr);
    TextFileName:=tmpStr+'.'+textExportExtension;
    tmpStr:=mainform.SaveDialog.Filename;
    tmpdir:=GetDirName(tmpStr);

    txtDirtest:=verifyUserDirectory(tmpdir);
    if txtDirtest>2 then //doesn't exist or no read/write access
    begin
     showInvalidDirectoryMsg(txtDirtest,tmpdir);
     exit;
    end;

    screen.cursor:=crHourglass;
    try
     TextFileOut:=true;
     chdir(tmpdir);
     PweekCount:=0;
     WinOutput(winNum);
    finally
     TextFileOut:=false;
     chdir(Directories.datadir);
     screen.cursor:=crDefault;
    end;
   end;

 except

 end;
end;

procedure UpdateAllWins; {call on code changes}
var
 i:       smallint;
begin
 if not(loadFinished) then exit;
 try
  screen.cursor:=crHourglass;
  updateStatusPanel;
  for i:=wnInfo to wnFindStud do UpdateWindow(i);
  updateBlockWindow;
  updateTtableWindow;
  updateWSwindow;
 finally
  screen.cursor:=crDefault;
 end;
end;

procedure UpdateStudWins; {call on student data change}
begin
 if not(loadFinished) then exit;
 try
  screen.cursor:=crHourglass;
  updateStatusPanel;
  UpdateWindow(wnStInput);
  UpdateWindow(wnStudentTt);
  updateBlockWindow;
  UpdateWindow(wnStudentList);
  UpdateWindow(wnTimeList);
  UpdateWindow(wnSubjectList);
  UpdateWindow(wnTeList);
  UpdateWindow(wnStBlClash);
  UpdateWindow(wnStFRee);
  UpdateWindow(wnFindStud);
  UpdateWindow(wnTeTimes);
  UpdateWindow(wnTeacherTt);
 finally
  screen.cursor:=crDefault;
 end;
end;

procedure UpdateWSwins; {call on worksheet change}
begin
 if not(loadFinished) then exit;
 try
  screen.cursor:=crHourglass;
  updateWSwindow;
  UpdateWindow(wnBlockClashes);
 finally
  screen.cursor:=crDefault;
 end;
end;

procedure UpdateTimeTableWins; {call on timetable change}
begin
 if not(loadFinished) then exit;
 try
  screen.cursor:=crHourglass;
  updateStatusPanel;
  UpdateWindow(wnCmatrix);
  UpdateWindow(wnStudentList);
  UpdateWindow(wnStudentTt);
  UpdateWindow(wnTeacherTt);
  UpdateWindow(wnRoomTt);
  UpdateWindow(wnSubjectTt);
  UpdateWindow(wnTimeList);
  UpdateWindow(wnSubjectList);
  UpdateWindow(wnCHelp);
  updateTtableWindow;
  updateWSwindow;
  UpdateWindow(wnBlockClashes);
  UpdateWindow(wnStInput);
  UpdateWindow(wnTeClash);
  UpdateWindow(wnRoClash);
  UpdateWindow(wnTeFree);
  UpdateWindow(wnRoFree);
  UpdateWindow(wnTeTimes);
  UpdateWindow(wnSuTimes);
  UpdateWindow(wnGroupTe);
  UpdateWindow(wnFindStud);
 finally
  screen.cursor:=crDefault;
 end;
end;

procedure UpdateBlockWins; {call on block changes}
begin
 if not(loadFinished) then exit;
 try
  screen.cursor:=crHourglass;
  UpdateWindow(wnCmatrix);
  updateStatusPanel;
  updateBlockWindow;
  UpdateWindow(wnCHelp);
  UpdateWindow(wnStInput);
  UpdateWindow(wnStBlClash);
  UpdateWindow(wnStFRee);
 finally
  screen.cursor:=crDefault;
 end;
end;

function GetLevelTtClass(MyYear,MyrollClass:integer):integer;
var
 L,Mylevel: integer;
begin
 Mylevel:=0;
 for L:=1 to level[MyYear] do
  if ClassShown[L,MyYear]=MyrollClass then
   if trim(ClassCode[MyrollClass])<>'' then
    begin Mylevel:=L; break; end;
 result:=Mylevel;
end;

procedure findSubTeacher(var ftc,frc: integer;snu: integer);
var
 i,p,L,d,y,max: integer;
 yrUsed:    array[0..nmbryears] of boolean; //only check year if true
 tc,rc,sc:       smallint;
 found:boolean;
 FirstTe,FirstRo:      smallint;
 multTeCount,multRoCount: array of smallint; //count for each teacher and room

 procedure SubOnTt(d,p,y,l:smallint);
 var
  fntA:    tpintpoint;
 begin
  fntA:=FNT(D,P,y,L,0);
  sc:=word(fntA^);
  if sc=snu then
    begin
     inc(fntA); tc:=word(fntA^);
     inc(fntA); rc:=word(fntA^);
     if ((tc>0) and (tc<=NumCodes[1]))  then
      begin
       if firstTe=0 then FirstTe:=tc;
       inc(multTeCount[tc]);
       found:=true;
      end;
     if ((rc>0) and (rc<=NumCodes[2])) then
      begin
       if firstRo=0 then FirstRo:=rc;
       inc(multRoCount[rc]);
      end;
    end;
 end;

begin
 for i:=0 to nmbryears do yrUsed[i]:=false;
 tc:=0;  rc:=0;   FirstTe:=0;  FirstRo:=0; found:=false;
 SetLength(multTeCount,2+NumCodes[1]);  SetLength(multRoCount,2+NumCodes[2]);
 for i:=0 to NumCodes[1] do multTeCount[i]:=0;
 for i:=0 to NumCodes[2] do multRoCount[i]:=0;

 for i:=1 to groupnum do yrUsed[XML_STUDENTS.Stud[StGroup[i]].TcYear]:=true;

 for d:=0 to days-1 do
  for p:=0 to tlimit[d]-1 do
   for y:=years_minus_1 downto 0 do
    if yrUsed[y] then
     for l:=1 to level[y] do SubOnTt(d,p,y,l);

 if not(found) and XML_DISPLAY.MatchAllYears then {check for match on all years}
  for y:=years_minus_1 downto 0 do
   for d:=0 to days-1 do
    for p:=0 to tlimit[d]-1 do
     for l:=1 to level[y] do SubOnTt(d,p,y,l);

 ftc:=FirstTe; max:=multTeCount[FirstTe];
 for i:=1 to NumCodes[1] do
  if multTeCount[i]>max then
   begin ftc:=i; max:=multTeCount[i]; end;

 frc:=FirstRo; max:=multRoCount[FirstRo];
 for i:=1 to NumCodes[2] do
  if multRoCount[i]>max then
   begin frc:=i; max:=multRoCount[i]; end;

end; {end of local proc}

function FindSubTeachers(var pFTc, pSTc, pFRc: Integer; pSubJectNo: Integer): Boolean;
var
  i, p, L, d, y, max: Integer;
  yrUsed:    array[0..nmbryears] of boolean; //only check year if true
  tc,rc,sc:       smallint;
  Found : Boolean;
  FirstTe,FirstRo: Smallint;
  lTe: Smallint;
  SecondTe: smallint;
  multTeCount,multRoCount: array of smallint; //count for each teacher and room

 procedure SubOnTt(d, p, y, l: Smallint; var pTe: Smallint);
 var
  fntA: TPintPoint;
 begin
  pTe := 0;
  fntA := FNT(D,P,y,L,0);
  sc := word(fntA^);
  if sc = pSubjectNo then
    begin
     inc(fntA); tc:=word(fntA^);
     inc(fntA); rc:=word(fntA^);
     if ((tc>0) and (tc<=NumCodes[1]))  then
      begin
       if pTe = 0 then
       begin
         pTe := tc;
         Inc(multTeCount[tc]);
       end;
      end;
      Found := pTe <> 0;
     if ((rc > 0) and (rc <= NumCodes[2])) then
      begin
       if firstRo=0 then
         FirstRo := rc;
       Inc(multRoCount[rc]);
      end;
    end;
 end;

begin
  for i:=0 to nmbryears do
    yrUsed[i] := False;
  tc:=0;
  rc:=0;
  FirstTe:=0;
  SecondTe := 0;
  FirstRo:=0;
  found := False;
  SetLength(multTeCount,2+NumCodes[1]);
  SetLength(multRoCount,2+NumCodes[2]);
  for i:=0 to NumCodes[1] do
    multTeCount[i]:=0;
  for i:=0 to NumCodes[2] do
    multRoCount[i]:=0;

  for i:=1 to groupnum do
    yrUsed[XML_STUDENTS.Stud[StGroup[i]].TcYear]:=true;

  for d:=0 to days-1 do
    for p:=0 to tlimit[d]-1 do
      for y:=years_minus_1 downto 0 do
        if yrUsed[y] then
          for l:=1 to level[y] do
          begin
            if (FirstTe <> 0) and (SecondTe <> 0) then
             Break;
            SubOnTt(d,p,y,l, lTe);
            if lTe <> 0 then
              if FirstTe = 0 then
                FirstTe := lTe
              else if (SecondTe = 0) and (lTe <> FirstTe) then
                SecondTe := lTe;
          end;

  if not(found) and XML_DISPLAY.MatchAllYears then {check for match on all years}
    for y:=years_minus_1 downto 0 do
     for d:=0 to days-1 do
      for p:=0 to tlimit[d]-1 do
       for l:=1 to level[y] do
       begin
         if (FirstTe <> 0) and (SecondTe <> 0) then
           Break;
         SubOnTt(d,p,y,l, lTe);
         if Found then
           if FirstTe = 0 then
             FirstTe := lTe
           else
             SecondTe := lTe;
       end;

  pFTc := FirstTe;
  pSTc := SecondTe;
  max := multTeCount[FirstTe];
  for i:=1 to NumCodes[1] do
    if multTeCount[i] > max then
    begin
      pFTc := i;
      max := multTeCount[i];
    end;

  pFRc := FirstRo;
  max := multRoCount[FirstRo];
  for i:=1 to NumCodes[2] do
    if multRoCount[i] > max then
    begin
      pFRc := i;
      max := multRoCount[i];
    end;
end;

procedure findTeacher(i,j: smallint; var ftc,frc: smallint);
var
 found:          bool;
 tc,rc,sc:       smallint;
 p,y,l,d,k:        smallint;
 max: integer;
 class1,lowClass,snu,FirstTe,FirstRo:         smallint;
 multTeCount,multRoCount: array of smallint; //count for each teacher and room

 procedure SubOnTt(d,p,y,l:smallint);
 begin
  sc:=word((FNT(d,p,y,l,0))^);
  if sc=snu then
    begin
     tc:=word((FNT(d,p,y,l,2))^);
     rc:=word((FNT(d,p,y,l,4))^);
     if ((tc>0) and (tc<=NumCodes[1]))  then
      begin
       if firstTe=0 then FirstTe:=tc;
       inc(multTeCount[tc]);
       found:=true;
      end;
     if ((rc>0) and (rc<=NumCodes[2])) then
      begin
       if firstRo=0 then FirstRo:=rc;
       inc(multRoCount[rc]);
      end;
    end;
 end;

begin
 found:=false;  ftc:=0; frc:=0; FirstTe:=0;  FirstRo:=0;
 Y:=XML_STUDENTS.Stud[i].TcYear;
 snu:=XML_STUDENTS.Stud[i].Choices[j];
 class1:=XML_STUDENTS.Stud[i].TcClass;
 SetLength(multTeCount,2+NumCodes[1]);  SetLength(multRoCount,2+NumCodes[2]);
 for k:=0 to NumCodes[1] do multTeCount[k]:=0;
 for k:=0 to NumCodes[2] do multRoCount[k]:=0;
 lowclass:=GetLevelTtClass(Y,class1);

 if lowclass>0 then   {check for match on this level}
  for d:=0 to days-1 do
   for p:=0 to tlimit[d]-1 do SubOnTt(d,p,y,lowclass);

 if not(found) then {check for match on year}
  for d:=0 to days-1 do
   for p:=0 to tlimit[d]-1 do
    for l:=1 to level[y] do SubOnTt(d,p,y,l);

 if not(found) and XML_DISPLAY.MatchAllYears then {check for match on all years}
  for y:=years_minus_1 downto 0 do
   for d:=0 to days-1 do
   for p:=0 to tlimit[d]-1 do
    for l:=1 to level[y] do SubOnTt(d,p,y,l);

 ftc:=FirstTe; max:=multTeCount[FirstTe];
 for k:=1 to NumCodes[1] do
  if multTeCount[k]>max then
   begin ftc:=k; max:=multTeCount[k]; end;

 frc:=FirstRo; max:=multRoCount[FirstRo];
 for k:=1 to NumCodes[2] do
  if multRoCount[k]>max then
   begin frc:=k; max:=multRoCount[k]; end;

end;

function GetDirName(var a:String):String;
begin
 result:=ExtractFilePath(a);
 if ((result[length(result)]='\') and (result[length(result)-1]<>':')) then
  SetLength(result,Length(result)-1);
end;

procedure wipeBlocks;
var
 i,j:     smallint;
begin
 for i:=0 to nmbrBlocks do
  begin
   fix[i]:=0;
   for j:=0 to nmbrLevels do
     Sheet[i,j]:=0;
  end;
  subsinblock:=0;
  Fixcount:=0;
  BlockLoad:=0;
end;

procedure updateStatusPanel;
var _DataDirText: string;
    _DataDirTextWidth: integer;
begin
 _DataDirText :=  'Current data directory is: ' + Directories.datadir+'  ';

 _DataDirTextWidth := getTextWidthOnLabel(_DataDirText,mainform.stbTimeChart.Font);
 if _DataDirTextWidth > mainform.stbTimeChart.Panels[0].Width then
    _DataDirText := 'Data directory is: ' + Directories.datadir+'  ';

 _DataDirTextWidth := getTextWidthOnLabel(_DataDirText,mainform.stbTimeChart.Font);
 if _DataDirTextWidth > mainform.stbTimeChart.Panels[0].Width then
    _DataDirText := 'Data directory: ' + Directories.datadir+'  ';

 _DataDirTextWidth := getTextWidthOnLabel(_DataDirText,mainform.stbTimeChart.Font);
 if _DataDirTextWidth > mainform.stbTimeChart.Panels[0].Width then
    _DataDirText := 'Data: ' + Directories.datadir+'  ';

 _DataDirTextWidth := getTextWidthOnLabel(_DataDirText,mainform.stbTimeChart.Font);
 if _DataDirTextWidth > mainform.stbTimeChart.Panels[0].Width then
    mainform.stbTimeChart.Panels[0].Alignment:= taRightJustify
  else
    mainform.stbTimeChart.Panels[0].Alignment:= taLeftJustify;
 mainform.stbTimeChart.Panels[0].Text := _DataDirText;
 mainform.stbTimeChart.Panels[1].Text := ' File: '+FileNames.LoadedTimeTable+'   '
           +'  '+inttostr(GroupNum)+'/'+inttostr(XML_STUDENTS.numstud)+' '+GroupName
           +' ('+groupsortname[groupsort]+')';
 mainform.stbTimeChart.Panels[2].Text := ' Days:' + inttostr(days) + '    Time slots:'
                        + inttostr(periods) + '    ' + yeartitle+'s:' + inttostr(years);

 if fgGenToolbar then
   gentoolbarwin.NewDataBtn.hint:='Current data directory is: '+ Directories.datadir;
end;

function findChoice3(enteredTxt: string): smallint;
var
 aStr:   string;
 found,aLen:       smallint;
begin
 aStr:=trim(enteredTxt);
 aLen:=Length(aStr);
 found:=0;
 if aLen>0 then
 begin
  found:=checkCode2(aStr);
 end;
 result:=found;
end;

function findClass2(enteredTxt: string): smallint;
var
 aStr,bStr:   string;
 i,j,aLen,bLen,mLen:       smallint;
begin
 aStr:=UpperCase(trim(enteredTxt));
 aLen:=length(aStr);   j:=0;  mLen:=99;
 if classnum>0 then
  if aLen>0 then
   for i:=classnum downto 1 do
   begin
    bStr:=UpperCase(trim(ClassCode[i]));
    bLen:=length(bStr);
    bStr:=copy(bStr,1,aLen);
    if aStr=bStr then
    begin
     if bLen<=mLen then
     begin
      mLen:=bLen;  //keep only minimum match
      j:=i;
      if aLen=bLen then break;  //continue search unless perfect match found
     end;
    end;
   end; {for i}
 result:=j;
end;

function findTutor2(enteredTxt: string): smallint;
var
 aStr:   string;
 j,aLen:       smallint;
begin
 aStr:=UpperCase(trim(enteredTxt));
 aLen:=Length(aStr);   j:=0;
 if ((aLen>0) and (aLen<=lencodes[1])) then j:=checkCode(1,aStr);
 result:=j;
end;

function findRoom2(enteredTxt: string): smallint;
var
 aStr:   string;
 j,aLen:       smallint;
begin
 aStr:=UpperCase(trim(enteredTxt));
 aLen:=Length(aStr);   j:=0;
 if ((aLen>0) and (aLen<=lencodes[2])) then j:=CheckCode(2,aStr);
 result:=j;
end;

function findHouse2(enteredTxt: string): smallint;
var
 aStr,bStr:   string;
 i,j,aLen:       smallint;
begin
 aStr:=UpperCase(trim(enteredTxt));
 aLen:=length(aStr);   j:=0;
 if aLen>0 then
  for i:=1 to housecount do
  begin
   bStr:=UpperCase(copy(HouseName[i],1,aLen));
   if aStr=bStr then
   begin
    j:=i;
    break;
   end;
  end; {for i}
 result:=j;
end;

procedure yearFormToggle;
begin
 updateStatusPanel;
 mainform.years1.caption:='&'+yeartitle+'s ...';
end;

procedure setWindowDefaults(aForm: Tform; aVal: smallint);
begin
 Application.ProcessMessages;
 if XML_DISPLAY.winpos[aVal].height>0 then
  try
    aForm.top:=XML_DISPLAY.winpos[aVal].top;
    aForm.left:=XML_DISPLAY.winpos[aVal].left;
    aForm.width:=XML_DISPLAY.winpos[aVal].width;
    aForm.height:=XML_DISPLAY.winpos[aVal].height;
    aForm.windowstate:=XML_DISPLAY.winpos[aVal].state;
   except
   end;
 aForm.Tag:=aVal;
 if (aForm is TdrawWin) then
  begin
   TdrawWin(aForm).TabsDo:=true;
   wnFlag[aVal]:=true;
  end;
end;

function SaveBlocksAs: boolean;
var
 tmpStr:  string;
begin
 result:=false;
 with Mainform do
  begin
   SaveDialog.Title:='Save Blocks';
   SaveDialog.HelpContext:=60;
   SaveDialog.Filter:='Block|*.blk';
   SaveDialog.InitialDir:=Directories.blockdir;
   SaveDialog.Filename:=blockfile;
   SaveDialog.DefaultExt:='blk';
   if SaveDialog.Execute then
    begin
     tmpStr:=ExtractFileName(SaveDialog.Filename);
     blockfile:=RemoveExtension(tmpStr);
     tmpStr:=mainForm.Savedialog.FileName;
     Directories.blockdir:=GetDirName(tmpStr);
     saveBlock;
     result:=true;
     blockload:=1;
    end;
   end; {with mainform}
end;

procedure SaveBlocksAsShow;
begin
 if SaveBlocksAs then updateBlockWindow;
end;

procedure updateBlockWindow;
var
 s:       string;
begin
 if not(loadFinished) then exit;
 updateGroupSubs;
 if wnFlag[wnBlock] then
  with BlockWin do
   begin
    RenewFont(Blockwin.Canvas);
    RenewFont(stringgrid1.canvas);
    tabsdo:=true;
    caption:='Block'+GroupCaption;
    Case BlockLoad of
     0: s:='';
     1: s:='File: '+Blockfile;
     2: s:='Copied from '+Blockday;
     3: s:='New Blocks'
    end;
    caption:=caption+'   '+s;
    repaint;
    stringgrid1.repaint;
    UpdateClashStatusBar;
   end;
 UpdateWindow(wnGroupSub);
 UpdateWindow(wnInfo);
 UpdateWindow(wnStBlClash);
 UpdateWindow(wnStFRee);
 if XML_DISPLAY.listShowClashes then UpdateWindow(wnStudentList);
end;

procedure updateWSwindow;
begin
 if not(loadFinished) then exit;
 if wnFlag[wnWorksheet] then
  with Worksheetwin do
   begin
    RenewFont(Worksheetwin.Canvas);
    RenewFont(stringgrid1.Canvas);
    RenewFont(image1.canvas);
    if alterWSflag then InitWSwin;
    UpdateWSclashBar;
    repaint; stringgrid1.repaint;
    restoreWSselection;
   end;
end;

procedure updateTtableWindow;
begin
 if not(loadFinished) then exit;
 if wnFlag[wnTtable] then
  with Ttablewin do
   begin
    RenewFont(Ttablewin.Canvas);
    RenewFont(stringgrid1.Canvas);
    RenewFont(image1.canvas);
    if alterTimeFlag then InitTTWin;
    UpdateTTclashBar;
    repaint;
    stringgrid1.repaint;
    restoreTTselection; {repaint removes it!}
   end;
end;

procedure infoWinSelect;
begin
 if wnFlag[wnInfo] then infowin.show
  else infowin:=tinfowin.create(application);
end;

procedure SuCodeWinSelect;
begin
 if wnFlag[wnSucode] then SuWindow.show
  else SuWindow:=TSuWindow.create(application);
end;

procedure TeCodeWinSelect;
begin
 if wnFlag[wnTecode] then TeWindow.show
  else TeWindow:=TTeWindow.create(application);
end;

procedure RoCodeWinSelect;
begin
 if wnFlag[wnRocode] then RoWindow.show
  else RoWindow:=TRoWindow.create(application);
end;

procedure RollClassWinSelect;
begin
 if wnFlag[wnRClassCode] then RollClassWindow.show
  else RollClassWindow:=TRollClassWindow.create(application);
end;

procedure FacWinSelect;
begin
 if wnFlag[wnFac] then FacultyWindow.show
  else FacultyWindow:=TFacultyWindow.create(application);
end;

procedure HouseWinSelect;
begin
 if wnFlag[wnHouse] then HouseWindow.show
  else HouseWindow:=THouseWindow.create(application);
end;

procedure TimesWinSelect;
begin
 if wnFlag[wnTimes] then TimesWindow.show
  else TimesWindow:=TTimesWindow.create(application);
end;

procedure gentoolbarSelect;
begin
 if not(fgGenToolbar) then
  begin
   gentoolbarwin:=tgentoolbarwin.create(application);
  end
 else gentoolbarwin.show;
  gentoolbarwin.tag:=wnGenTool;
  fgGenToolbar:=true;
end;

procedure tttoolbarSelect;
begin
 if not(fgTTtoolbar) then
  begin
   TtableToolbarWin:=tTtableToolbarWin.create(application);
  end
 else TtableToolbarWin.show;
 TtableToolbarWin.tag:=wnTtTool;
 fgTTtoolbar:=true;
end;

procedure WStoolbarSelect;
begin
 if not(fgWStoolbar) then
  begin
   WorkSheetToolbar:=TWorkSheetToolbar.create(application);
  end
 else WorkSheetToolbar.show;
 WorkSheetToolbar.tag:=wnWsTool;
 fgWStoolbar:=true;
end;

procedure blocktoolbarSelect;
begin
  if not(fgBlockToolbar) then
  begin
   blocktoolbarwin:=tblocktoolbarwin.create(application);
  end
  else blocktoolbarwin.show;
  blocktoolbarwin.tag:=wnBlTool;
  fgBlockToolbar:=true;
end;

procedure clashmatrixWinSelect;
begin
if wnFlag[wnCmatrix] then cmatwin.show
 else cmatwin:=tcmatwin.create(application);
end;

procedure StudentInputWinSelect;
begin
if wnFlag[wnStInput] then Stuinput.show
 else Stuinput:=tStuinput.create(application);
end;

function findSubyear(place: smallint): smallint;
var
 i:      smallint;
begin
 result:=0;  {not found}
 for i:=1 to GroupSubs[0] do
 if GroupSubs[i]=place then
 begin
  result:=i;
  exit;
 end;
end;

procedure ensureSizeForFont(var frm :tform);
var
 i,a,b:       smallint;
 need:        bool;
 r:           single;
begin
 need:=false;     a:=0; b:=0;
 for i:=0 to (frm.controlcount-1) do
 begin
  if (frm.controls[i] is tlabel) then
  begin
   a:=frm.controls[i].height;  b:=tlabel(frm.controls[i]).canvas.textheight('ABcdgy');
   if a<b then
   begin
    need:=true; break;
   end;
  end; {if (frm.controls[i] is tlabel)}
 end; {for i}
 if need then
 begin
  r:=b/a;
  for i:=0 to (frm.controlcount-1) do
  if ((frm.controls[i] is tlabel) or (frm.controls[i] is tedit)) then
  begin
   frm.controls[i].height:=round(frm.controls[i].height*r);
   frm.controls[i].width:=round(frm.controls[i].width*r);
  end;
 end; {if need}
end;

function CodeFontWidth(mycanvas:Tcanvas; code: integer): smallint;
var
 j:             integer;
 maxTab,curTab:   integer;
begin
 maxTab:=1; curTab:=0;
 for j:=1 to NumCodes[code] do
 begin
  case code of
   0: curTab:=mycanvas.textwidth(trim(SubCode[j]));
   1: curTab:=mycanvas.textwidth(trim(XML_TEACHERS.Tecode[j,0]));
   2: curTab:=mycanvas.textwidth(trim(XML_TEACHERS.Tecode[j,1]));
  end;
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function SubReportCodeFontWidth(mycanvas: Tcanvas):smallint;
var
 maxTab,curTab,j:   smallint;
begin
 maxTab:=1;
 for j:=1 to NumCodes[0] do
  begin
   curTab:=mycanvas.textwidth(trim(SubReportCode[j]));
   if (curTab>maxTab) then maxTab:=curTab;
  end;
 result:=maxTab;
end;

function SubReportNameFontWidth(mycanvas: Tcanvas):smallint;
var
 maxTab,curTab,j:   smallint;
begin
 maxTab:=1;
 for j:=1 to NumCodes[0] do
  begin
   curTab:=mycanvas.textwidth(trim(SubReportName[j]));
   if (curTab>maxTab) then maxTab:=curTab;
  end;
 result:=maxTab;
end;

function BlankCodeFontWidth(mycanvas:Tcanvas; code: integer): smallint;
var
 maxTab:   integer;
begin
 maxTab:=0;
 case code of
  0: maxTab:=mycanvas.textwidth(copy('__________',1,lencodes[code]));
  1: maxTab:=mycanvas.textwidth(copy('----------',1,lencodes[code]));
  2: maxTab:=mycanvas.textwidth(copy('..........',1,lencodes[code]));
 end;
 result:=maxTab;
end;

function CodeNameFontWidth(mycanvas:Tcanvas; code: integer): smallint;
var
 j:             integer;
 maxTab,curTab:   integer;
begin
 maxTab:=1; curTab:=0;
 for j:=1 to NumCodes[code] do
 begin
  case code of
   0: curTab:=mycanvas.textwidth(trim(SubName[j]));
   1: curTab:=mycanvas.textwidth(trim(XML_TEACHERS.TeName[j,0]));
   2: curTab:=mycanvas.textwidth(trim(XML_TEACHERS.TeName[j,1]));
  end;
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

procedure getCodeFontWidths(code: smallint);
begin
 fwCode[code]:=CodeFontWidth(mainform.Canvas,code);
 fwCodeBlank[code]:=BlankCodeFontWidth(mainform.Canvas,code);
 if fwCodeBlank[code]<fwCode[code] then fwCodeBlank[code]:=fwCode[code];
 fwCodename[code]:=CodeNameFontWidth(mainform.Canvas,code);
 if code=0 then
  begin
   fwReportCode:=SubReportCodeFontWidth(mainform.Canvas);
   fwReportName:=SubReportNameFontWidth(mainform.Canvas);
  end;
end;

function getHouseFontWidths(mycanvas:Tcanvas):smallint;
var
 i:             integer;
 maxTab,curTab:   integer;
begin
 maxTab:=1;
 for i:=1 to Housecount do
 begin
  curTab:=mycanvas.textwidth(HouseName[i]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function getFacultyFontWidths(mycanvas:Tcanvas):smallint;
var
 i:             integer;
 maxTab,curTab:   integer;
begin
 maxTab:=mycanvas.textwidth('All faculties');
 for i:=1 to facNum do
 begin
  curTab:=mycanvas.textwidth(facName[i]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 if maxTab=0 then maxTab:=1;
 result:=maxTab;
end;

function getClassFontWidths(mycanvas:Tcanvas):smallint;
var
 i:             smallint;
 maxTab,curTab:   smallint;
begin
 maxTab:=1;
 for i:=1 to Classnum do
 begin
  curTab:=mycanvas.textwidth(trim(ClassCode[i]));
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function getTagFontWidths(mycanvas:Tcanvas):smallint;
var
 i:             smallint;
 maxTab,curTab:   smallint;
begin
 if TagCalcFlag then CalcTagsUsed;
 maxTab:=1;
 if TagOrderNum>0 then
  for i:=1 to TagOrderNum do
   begin
    curTab:=mycanvas.textwidth(trim(TagCode[TagOrder[i]])+' ');
    if (curTab>maxTab) then maxTab:=curTab;
   end;
 result:=maxTab;
end;

function getYearnameFontWidths(mycanvas:Tcanvas):smallint;
var
 i:             integer;
 maxTab,curTab:   integer;
begin
 maxTab:=1;
 for i:=0 to years-1 do
 begin
  curTab:=mycanvas.textwidth(Yearname[i]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function getTsNameDayFontWidths(myDay:smallint; mycanvas:Tcanvas):smallint;
var
 i:             integer;
 maxTab,curTab:   integer;
begin
 maxTab:=1;
 for i:=0 to tlimit[myDay]-1 do
 begin
  curTab:=mycanvas.textwidth(TimeSlotName[myDay,i]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function getTsCodeDayFontWidths(myDay:smallint; mycanvas:Tcanvas):smallint;
var
 i:             integer;
 maxTab,curTab:   integer;
begin
 maxTab:=1;
 for i:=0 to periods-1 do
 begin
  curTab:=mycanvas.textwidth(tscode[myDay,i]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

procedure getTsNameFontWidths;
var
 d,tmp:    integer;
begin
 fwPeriodname:=1;  fwTsCode:=1;
 for d:=0 to days-1 do
 begin
  fwTsName[d]:=getTsNameDayFontWidths(d,mainform.canvas);
  if (fwTsName[d]>fwPeriodname) then fwPeriodname:=fwTsName[d];
  tmp:=getTsCodeDayFontWidths(d,mainform.canvas);
  if tmp>fwTsCode then fwTsCode:=tmp;
 end;
end;

procedure getPrntTsNameFontWidths(Mycanvas:Tcanvas);
var
 d,tmp:    integer;
begin
 fwPrntPeriodname:=1;    fwprntTsCode:=1;
 for d:=0 to days-1 do
 begin
  fwPrntTsName[d]:=getTsNameDayFontWidths(d,Mycanvas);
  if (fwPrntTsName[d]>fwPrntPeriodname) then fwPrntPeriodname:=fwPrntTsName[d];
  tmp:=getTsCodeDayFontWidths(d,Mycanvas);
  if tmp>fwprntTsCode then fwprntTsCode:=tmp;
 end;
end;

function getDaynameFontWidths(mycanvas:Tcanvas):smallint;
var
 i:             integer;
 maxTab,curTab:   integer;
begin
 maxTab:=1;
 for i:=0 to days-1 do
 begin
  curTab:=mycanvas.textwidth(Dayname[i]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function getDayFontWidths(mycanvas:Tcanvas):smallint;
var
 i:             integer;
 maxTab,curTab:   integer;
begin
 maxTab:=1;
 for i:=0 to days-1 do
 begin
  curTab:=mycanvas.textwidth(Day[i]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function TeDutyCodeFontWidths(mycanvas:Tcanvas):smallint;
var
 i,j:             integer;
 maxTab,curTab:   integer;
begin
 maxTab:=1;
 for i:=1 to numcodes[1] do
  for j:=0 to 2 do
  begin
   curTab:=mycanvas.textwidth(XML_TEACHERS.dutycode[i,j]);
   if (curTab>maxTab) then maxTab:=curTab;
  end;
 result:=maxTab;
end;

function TeDutyLoadFontWidths(mycanvas:Tcanvas):smallint;
var
 i,j:             integer;
 maxTab,curTab:   integer;
 s: string;
begin
 maxTab:=1;
 for i:=1 to numcodes[1] do
  for j:=0 to 2 do
  begin
   str(XML_TEACHERS.dutyload[i,j]:4:1,s);
   curTab:=mycanvas.textwidth(s);
   if (curTab>maxTab) then maxTab:=curTab;
  end;
 result:=maxTab;
end;

procedure getTeDutyCodeFontWidths;
begin
 fwTeDutyCode:=TeDutyCodeFontWidths(mainform.Canvas);
 fwTeDutyLoad:=TeDutyLoadFontWidths(mainform.Canvas);
end;

function GetBoxFontWidth(mycanvas:Tcanvas):smallint;
var
 a,i,j: integer;
begin
 a:=0;
 for i:=0 to 9 do
  begin
   j:=mycanvas.textwidth(inttostr(i));
   if j>a then a:=j;
  end; {for i}
 result:=a*4;
end;

procedure getFontWidths;
var
 i:       integer;
begin
 mainform.Canvas.Font.Assign(XML_DISPLAY.tcfont);
 for i:=0 to 2 do getCodeFontWidths(i);
 getStudentFontWidths;
 boxWidth:=getBoxFontWidth(mainform.canvas);
 fwHouse:=getHouseFontWidths(mainform.canvas);
 fwFaculty:=getFacultyFontWidths(mainform.canvas);
 fwClass:=getClassFontWidths(mainform.canvas);
 fwTag:=getTagFontWidths(mainform.canvas);
 fwYearname:=getYearnameFontWidths(mainform.canvas);
 getTsNameFontWidths;
 fwTimeUnit:=mainform.canvas.textwidth('9999.99');
 fwClockStartEnd:=mainform.canvas.textwidth(' 12:28-12:43pm ');
 fwDayname:=getDaynameFontWidths(mainform.canvas);
 fwDay:=getDayFontWidths(mainform.canvas);
 getTeDutyCodeFontWidths;
 Hmargin:=mainform.canvas.textwidth('AA');
 txtHeight:=mainform.canvas.textheight('Ay');
 blankwidth:=mainform.canvas.textwidth('  '); {2 spaces}
end;


function FNsub(A9,code9: smallint):string;
begin
 if code9=0 then FNsub:=SubCode[A9] else FNsub:=XML_TEACHERS.TeCode[A9,code9-1];
end;

function FNsubname(A9,code9: smallint):string;
begin
 if code9=0 then
  FNsubname:=Subname[A9]
 else
  FNsubname:=XML_TEACHERS.TeName[A9,code9-1];
end;

//---------// mantis-1295-----------------
function FNsubwillcount(A9,code9: smallint):string;
begin
 if code9=0 then
    if trim(subwillcount[A9])='' then
        FNsubwillcount:= 'Y'
    else
        FNsubwillcount:=subwillcount[A9]
 else
  FNsubwillcount:='Y';
end;


procedure swapint(var a:smallint; var b: smallint);
var
tmp:      smallint;
begin
 tmp:=a;
 a:=b;
 b:=tmp;
end;

procedure swapstr(var a:string; var b: string);
var
tmp:      string;
begin
 tmp:=a;
 a:=b;
 b:=tmp;
end;

procedure XrefGroupSubs;
var
 i:     smallint;
begin
 for i:=0 to nmbrSubjects do
   GsubXref[i] := 0;
 for i:=1 to GroupSubs[0] do
   GsubXref[GroupSubs[i]] := i;
end;

procedure sortCodes(code: smallint);
  var
    D,H,i,pos:         smallint;
    J,L,A,B:           smallint;
    aStr,tmpStr1,tmpStr2: string;
  label label1,label2;

begin
 pos:=0;
 for i:=1 to NumCodes[code] do
   begin
    aStr:=FNsub(i,code);
    aStr:=copy(aStr,1,2);
    if (aStr<>'00') then
     begin
      inc(pos);
      codepoint[pos,code]:=i;
     end;
   end;
 codeCount[code]:=pos;
 if XML_DISPLAY.sorttype[code]=0 then exit;
 D:=1;
 while D<codeCount[code] do D:=D+D;
 label1:
 D:=(D-1) div 2;
 if D=0 then exit;
 H:=codeCount[code]-D;
 for i:=1 to H do
   begin
    J:=i;
    Label2:
    L:=J+D;
    A:=codepoint[L,code];
    B:=codepoint[J,code];
    if XML_DISPLAY.sorttype[code]=1 then
      begin
	tmpStr1:=uppercase(FNsub(A,code));
	tmpStr2:=uppercase(FNsub(B,code));
      end
    else
      begin
	tmpStr1:=uppercase(FNsubname(A,code));
	tmpStr2:=uppercase(FNsubname(B,code));
      end;
    if tmpStr1<tmpStr2 then
      begin
       codepoint[J,code]:=A;
       codepoint[L,code]:=B;
       dec(J,D);
      end;
    if (tmpStr1<tmpStr2) and (J>0) then goto Label2;
  end; {for}
  goto label1;
end;

procedure TtableWinSelect;
begin
 if wnFlag[wnTtable] then Ttablewin.show
 else
  begin
   Ttablewin:=TTtablewin.create(application);
   wnFlag[wnTtable]:=true;
   Ttablewin.tag:=wnTtable;
   Ttablewin.InitTTWin;
  end;
end;

procedure WorksheetWinSelect;
begin
  if wnFlag[wnWorksheet] then
    Worksheetwin.show
  else
  begin
    Worksheetwin := TWorksheetwin.create(application);
    wnFlag[wnWorksheet] := true;
    Worksheetwin.tag := wnWorksheet;
    Worksheetwin.InitWSwin;
  end;
end;

procedure studentTtablewinSelect;
begin
  if wnFlag[wnStudentTt] then
    STtable.show
  else
    STtable := TSTtable.create(application);
end;

procedure teachTtablewinSelect;
begin
 if wnFlag[wnTeacherTt] then TeTtable.show
  else TeTtable:=TTeTtable.create(application);
end;

procedure ClashHelpwinSelect;
begin
 if wnFlag[wnCHelp] then ClashHelp.show
  else ClashHelp:=TClashHelp.create(application);
end;

procedure BlockClasheswinSelect;
begin
 if wnFlag[wnBlockClashes] then  BlockClashesWin.show
  else BlockClashesWin:=TBlockClashesWin.create(application);
end;

procedure TeacherClasheswinSelect;
begin
 if wnFlag[wnTeClash] then TeacherClashes.show
  else TeacherClashes:=TTeacherClashes.create(application);
end;

procedure RoomClasheswinSelect;
begin
 if wnFlag[wnRoClash] then RoomClashes.show
  else RoomClashes:=TRoomClashes.create(application);
end;

procedure TeachersFreewinSelect;
begin
 if wnFlag[wnTeFree] then TeachersFree.show
  else TeachersFree:=TTeachersFree.create(application);
end;

procedure RoomsFreewinSelect;
begin
 if wnFlag[wnRoFree] then RoomsFree.show
  else RoomsFree:=TRoomsFree.create(application);
end;

procedure TeacherTimeswinSelect;
begin
 if wnFlag[wnTeTimes] then TeacherTimes.show
  else TeacherTimes:=TTeacherTimes.create(application);
end;

procedure SubjectTimeswinSelect;
begin
 if wnflag[wnSuTimes] then SubjectTimes.show
  else SubjectTimes:=TSubjectTimes.create(application);
end;

procedure GroupofTeacherswinSelect;
begin
 if wnFlag[wnGroupTe] then GroupofTeachers.show
  else GroupofTeachers:=TGroupofTeachers.create(application);
end;

procedure roomTtablewinSelect;
begin
 if wnFlag[wnRoomTt] then RoTtable.show
  else RoTtable:=TRoTtable.create(application);
end;

procedure subjectTtablewinSelect;
begin
 if wnFlag[wnSubjectTt] then SuTtable.show
  else SuTtable:=TSuTtable.create(application);
end;

procedure subyearwinSelect;
begin
 if wnFlag[wnGroupSub] then Subyearwin.show
  else Subyearwin:=TSubyearwin.create(application);
end;

procedure SubListWinSelect;
begin
 if wnFlag[wnSubjectList] then SubBySubjectwin.show
  else SubBySubjectwin:=TSubBySubjectwin.create(application);
end;

procedure SubjectbyTimeSlotwinSelect;
begin
 if wnFlag[wnTimeList] then SubByTimeSlotwin.show
  else SubByTimeSlotwin:=TSubByTimeSlotwin.create(application);
end;

procedure StudentListwinSelect;
begin
 if wnFlag[wnStudentList] then StudentListWin.show
  else StudentListWin:=TStudentListWin.create(application);
 updateCustomMenus;   //else not called on load - flag not set yet and would have to be called as "self" rather then as is
end;

procedure TeacherListwinSelect;
begin
 if wnFlag[wnTeList] then TeListWin.show
  else TeListWin:=TTeListWin.create(application);
end;

procedure StBlockClashWinSelect;
begin
 if wnFlag[wnStBlClash] then StClashWin.show
  else StClashWin:=TStClashWin.create(application);
end;

procedure StudFreeWinSelect;
begin
 if wnFlag[wnStFRee] then StudFreeWin.show
  else StudFreeWin:=TStudFreeWin.create(application);
end;

procedure StudentTagsSelect;   //mantis-0727
begin
 if wnFlag[wnStudentTag]
  then FrmListTagNames.show
  else
   FrmListTagNames:=TFrmListTagNames.create(application);



end;


procedure BlockwinSelect;
var
 s:  String;
begin
 if wnFlag[wnBlock] then
 begin
  Blockwin.show;
 end
 else
 begin
  Blockwin:=TBlockwin.create(application);
  Blockwin.tabsDo:=true;
  wnFlag[wnBlock]:=true;
  Case BlockLoad of
   0: s:='';
   1: s:='File: '+Blockfile;
   2: s:='Copied from '+Blockday;
   3: s:='New Blocks'
  end;
  Blockwin.caption:='Blocks'+GroupCaption+'   '+s;
  RenewFont(Blockwin.Canvas);
  RenewFont(Blockwin.stringgrid1.Canvas);
  RenewFont(Blockwin.image1.canvas);
  Blockwin.refresh;
 end;
end;

procedure validateCode(code: smallint; var codeStr: string);
begin
 codeStr:=uppercase(copy(RpadString(codeStr,lenCodes[code]),1,lenCodes[code]));
end;

function checkCode2(var codeStr: string): smallint;
var
 bsLower,bsUpper,bsMiddle:   smallint;
 bsFind:                     smallint;
 aStr,bStr,tmpStr:                  string;
begin
 result:=0; {not found}
 tmpStr:=Copy(codeStr,1,2);
 if tmpStr='00' then exit; {not found for deleted codes - flagged later}
 if codeCount[0]=0 then exit;
 bsLower:=1; bsUpper:=codeCount[0];
 bsFind:=0;
 while (bsLower<=bsUpper) do
 begin
  bsMiddle:=(bsLower+bsUpper) div 2;
  aStr:=trim(uppercase(SubCode[codepoint[bsMiddle,0]]));
  bStr:=trim(uppercase(codeStr));
  if (bStr>aStr) then
  begin
   bsLower:=bsMiddle+1;
  end
  else
   begin
    if (bStr<aStr) then
     bsUpper:=bsMiddle-1
    else
     begin
      bsFind:=codepoint[bsMiddle,0];
      break;
     end;
   end;
 end;
 result:=bsFind;
end;

function checkCode(code: smallint; var codeStr: string): smallint;
var
 i:     smallint;
 tmpStr: string;
begin
  Result := 0; {not found}
  tmpStr := Copy(codeStr,1,2);
  if tmpStr='00' then exit; {not found for deleted codes - flagged later}
  validateCode(code,codeStr);   //upercase etc regardless
  if numCodes[code]=0 then exit;
  for i:=1 to numCodes[code] do
  begin
    tmpStr:=uppercase(FNsub(i,code));
    if Trim(tmpStr) = Trim(UpperCase(codeStr)) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function checkWildSub(var codeStr: string): smallint;
var
 i,j:     smallint;
 tmpStr,tmpStr2: string;
begin
 result:=0; j:=0;{not found}
 tmpStr:=Copy(codeStr,1,2);
 if tmpStr='00' then exit; {not found for deleted codes - flagged later}
 if numCodes[0]=0 then exit;
 tmpStr:=trim(codeStr);
 if copy(tmpStr,lencodes[0],1)='*' then
 begin
  tmpStr2:=uppercase(copy(codeStr,1,lencodes[0]-1));
  for i:=1 to numCodes[0] do
  begin
   tmpStr:=copy(uppercase(SubCode[i]),1,lencodes[0]-1);
   if tmpStr=tmpStr2 then
   begin
    j:=-i;
    break;
   end;
  end;
 end
 else   { not     copy(tmpStr,lencodes[code],1)='*'}
  j:=checkcode(0,codeStr);
 result:=j;
end;

function checkfaculty(codeStr: string): smallint;
var
 i,j:     smallint;
 tmpStr: string;
begin
 result:=0; {not found}
 codeStr:=uppercase(trim(codestr));
 if codeStr='*' then
 begin
  result:=-1;
  exit;
 end;
 j:=length(codestr);
 if j=0 then exit;
 tmpStr:=Copy(codeStr,1,2);
 if tmpStr='00' then exit; {not found for deleted codes - flagged later}
 if facnum=0 then exit;
 for i:=1 to facnum do
 begin
  tmpStr:=uppercase(copy(facname[i],1,j));
  if tmpStr=codeStr then
  begin
   result:=i;
   break;
  end;
 end;
end;


{--printing font widths ---}


function StudentNameFontWidth(mycanvas: Tcanvas):smallint;
var
 i:             smallint;
 maxTab,curTab:   smallint;
begin
 maxTab:=1;
 for i:=1 to XML_STUDENTS.numstud do
 begin
  curTab:=mycanvas.textwidth(XML_STUDENTS.Stud[i].StName+' '+XML_STUDENTS.Stud[i].First);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function StudentIDfontWidth(mycanvas: Tcanvas):smallint;
var
 i:             smallint;
 maxTab,curTab:   smallint;
begin
 maxTab:=1;
 for i:=1 to XML_STUDENTS.numstud do
 begin
  curTab:=mycanvas.textwidth(XML_STUDENTS.Stud[i].ID);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function StudentID2fontWidth(mycanvas: Tcanvas):smallint;
var
 i:             smallint;
 maxTab,curTab:   smallint;
begin
 maxTab:=1;
 for i:=1 to XML_STUDENTS.numstud do
 begin
  curTab:=mycanvas.textwidth(studID2[i]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function StudentEmailfontWidth(mycanvas: Tcanvas):smallint;
var
 i:             smallint;
 maxTab,curTab:   smallint;
begin
 maxTab:=1;
 for i:=1 to XML_STUDENTS.numstud do
 begin
  curTab:=mycanvas.textwidth(studEmail[i]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 result:=maxTab;
end;

function StudentSexFontWidth(mycanvas: Tcanvas):smallint;
var
 maxTab,curTab:   smallint;
begin
 maxTab:=mycanvas.textwidth(genderShort[0]{'M'});
 curTab:=mycanvas.textwidth(genderShort[1]{'F'});
 if (curTab>maxTab) then maxTab:=curTab;
 result:=maxTab;
end;

procedure getStudentFontWidths;
begin
 fwStname:=StudentNameFontWidth(mainForm.canvas);
 fwID:=StudentIDfontWidth(mainForm.canvas);

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  fwID2:=StudentID2fontWidth(mainForm.canvas);
  fwEmail:=StudentEmailfontWidth(mainForm.Canvas);
 end;

 fwSex:=StudentSexFontWidth(mainForm.canvas);
end;

procedure getPrntFontWidths(mycanvas:Tcanvas);
var
 i:       integer;
begin
 for i:=0 to 2 do
  begin
   fwPrntCode[i]:=CodeFontWidth(mycanvas,i);
   fwPrntCodeBlank[i]:=BlankCodeFontWidth(mycanvas,i);
   if fwPrntCodeBlank[i]<fwPrntCode[i] then fwPrntCodeBlank[i]:=fwPrntCode[i];
   fwPrntCodename[i]:=CodeNameFontWidth(mycanvas,i);
  end;
 fwPrntReportCode:=SubReportCodeFontWidth(mycanvas);
 fwPrntReportName:=SubReportNameFontWidth(mycanvas);
 fwPrntStname:=StudentNameFontWidth(mycanvas);
 fwPrntID:=StudentIDfontWidth(mycanvas);

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  fwPrntID2:=StudentID2fontWidth(mycanvas);
  fwPrntEmail:=StudentEmailFontWidth(mycanvas);
 end;

 fwPrntSex:=StudentSexFontWidth(mycanvas);
 PrntBoxWidth:=getBoxFontWidth(mycanvas);
 fwPrntHouse:=getHouseFontWidths(mycanvas);
 fwPrntFaculty:=getFacultyFontWidths(mycanvas);
 fwPrntClass:=getClassFontWidths(mycanvas);
 fwPrntTag:=getTagFontWidths(mycanvas);
 fwPrntYearname:=getYearnameFontWidths(mycanvas);
 getPrntTsNameFontWidths(Mycanvas);
 fwprntClockStartEnd:=Mycanvas.textwidth(' 12:28-12:43pm ');
 fwPrntDayname:=getDaynameFontWidths(mycanvas);
 fwPrntDay:=getDayFontWidths(mycanvas);
 fwPrntTeDutyCode:=TeDutyCodeFontWidths(myCanvas);
 fwPrntTeDutyLoad:=TeDutyLoadFontWidths(myCanvas);
 PrnttxtHeight:=trunc(mycanvas.textheight('Ay')*1.02);
 Prntblankwidth:=mycanvas.textwidth('  '); {2 spaces}
end;

function GetNoOfStudentsInClass(const pYear, PSubCode: Integer; var pTeach, pRoom, pDay, pPeriod: Integer): Integer;
var
  lNoOfStud: Integer;
  lSub: Integer;
  lRoom: Integer;
  lSttYear: Integer;
  lSttlevel: Integer;
  lStud: Integer;
begin
  lNoOfStud := 0;
  try
    for lStud := 1 to XML_STUDENTS.numstud do
    begin
      //if Stud[lStud].TcYear = pYear then
      if SubCode[PSubCode] <> '' then
        if GetStudentTtItem(pTeach, lSub, lRoom, lSttYear, lSttlevel, lStud, pDay, pPeriod) then
          if (lRoom = pRoom) and (lSub = pSubCode) then
          begin
            Inc(lNoOfStud);
          end;
    end;
  finally
    Result := lNoOfStud;
  end;
end;

procedure LoadSubjectsFromFile(const pFileName: string);
var
  codefile: file;
  file1,file2: string;
  i,j,v: Smallint;
  sub2: string;
  name2: string;
  tmpStr: string;
  lTempList: TStringList;
  datasection: Integer;
  lStr: string;
  lCount: Integer;
begin
  //To be used when an import function is required
  //To do the import of subject it is required to create a comma delimited file
  //with two columns one for code and aother one for Subject name
  chdir(Directories.datadir);
  datasection := 6;
  file1 := 'SUBCODE.DAT';
  file2 := 'SUBNAME.DAT';
  lTempList := TStringList.Create;
  try
    try
      try
        lTempList.LoadFromFile(pFileName);

        doAssignFile(codefile, file1);
        Rewrite(codefile, 1);
        lCount := lTempList.Count;
        BlockWrite(codefile, lCount, 2);
        BlockWrite(codefile, LenCodes[0], 2);
        if lTempList.Count > 0 then
          for i := 0 to lTempList.Count - 1 do
          begin
            lStr := GetSubStr(lTempList.Strings[i], 1);
            sub2 := RPadString(lStr, LenCodes[0]);
            BlockWrite(codefile, sub2[1], LenCodes[0]);
          end;
      finally
        CloseFile(codefile);
        FileAge(file1, NEW_DateChecks[datasection]);
      end;
    except
    end;

    try
      try
        doAssignFile(codefile, file2);
        Rewrite(codefile, 1);
        if snSize <> szSubnameDefault then
        begin
          tmpstr := 'TC4W';
          BlockWrite(codefile, tmpstr[1], 4);
          lCount := lTempList.Count;
          BlockWrite(codefile, lCount, 2);
          BlockWrite(codefile, snsize,2);
        end
        else
          BlockWrite(codefile, lCount, 2);
        if lTempList.Count > 0 then
          for i := 0 to lTempList.Count - 1 do
          begin
            lStr := GetSubStr(lTempList.Strings[i], 2);
            name2 := RPadString(lStr, snsize);
            BlockWrite(codefile, name2[1], snsize);
          end;
      finally
        CloseFile(codefile);
      end;
    except
    end;
  finally
    FreeAndNil(lTempList);
  end;
end;

procedure RemoveDuplicateItems(var pList: TStringList) ;
var
  lList: TStringList;
  i: Integer;
  lStr: string;
  lPrevStr: string;
begin
  Plist.Sorted := True;
  lList := TStringList.Create;
  try
    lList.Text := Plist.Text;
    pList.Clear;
    lPrevStr := '';
    for i := 0 to lList.Count - 1 do
    begin
      lStr := lList.Strings[i];
      if lStr <> lPrevStr then
        pList.Add(lStr);
      lPrevStr := lStr;
    end;
  finally
    FreeAndNil(lList);
  end;
end;

function GetLongestLength: Integer;
var
  lLength: Integer;
begin
  lLength := 0;
  lLength := LenCodes[0];

  if lLength < LenCodes[1] then
    lLength := LenCodes[1];

  if lLength < LenCodes[2] then
    lLength := LenCodes[2];

  Result := lLength;
end;

function GetSpacesToAlign(const pCode: string; pTotalLength: Integer): string;
var
  lSpacesToAdd: Integer;
  i: Integer;
begin
  Result := '';
  lSpacesToAdd := pTotalLength - Length(pCode);
  if lSpacesToAdd > 0 then
  begin
    for i := 1 to lSpacesToAdd do
    begin
      Result := Result + ' ';
    end;
  end;
end;

function GetTeacherSubjects(const pTeacherNo: Integer): TStringList;
var
  d, p, y, l: Integer;
  Su, Te, Ro: Integer;
  aFnt: TPIntPoint;
  lSubjects: string;
  lSubFound: string;
  lLongestLength: Integer;
  lTempList: TStringList;
begin
  lTempList := TStringList.Create;
  lLongestLength := GetLongestLength;
  lSubjects := '';
  for y := 0 to years_minus_1 do
    for l:= 1 to level[y] do
    begin
      for d := 0 to Days -1  do
      begin
        for p := 0 to tlimit[d] - 1 do
        begin
          aFnt := FNT(d, p, y, l, 0);
          Su := aFnt^;
          Inc(aFnt);
          Te := aFnt^;
          Inc(aFnt);
          Ro := aFnt^;
          if (Su <> 0) then
          begin
            lSubFound := Trim(SubCode[Su]);
            if (Te = pTeacherNo) and (Copy(lSubFound, 1, 2) <> '00')then
              if Pos(lSubFound, lSubjects ) = 0 then
              begin
                lSubjects := lSubjects + lSubFound;
                lTempList.Add(lSubFound + GetSpacesToAlign(Trim(lSubFound), lLongestLength));
              end;
          end;
        end; // for
      end;  // for
    end;  // for
  Result := lTempList;
end;

function GetAverageSubjectLoad(const pAM: Boolean; lSubjectCode: string): Integer;
var
  d, p, y, l: Integer;
  Su, Te, Ro: Integer;
  aFnt: TPIntPoint;
  lSubFound: string;
  lCount: Integer;
  lSubCount: Integer;
begin
  lCount := 0;
  lSubCount := 0;
  try
    for y := 0 to years_minus_1 do
      for l:= 1 to level[y] do
      begin
        for d := 0 to Days -1  do
        begin
          for p := 0 to TLimit[d] - 1 do
          begin
            aFnt := FNT(d, p, y, l, 0);
            Su := aFnt^;
            Inc(aFnt);
            Te := aFnt^;
            Inc(aFnt);
            Ro := aFnt^;
            if (Su <> 0) then
            begin
              lSubFound := Trim(SubCode[Su]);
              //lSubCount  count should be for unique subjects only
              if (Copy(lSubFound, 1, 2) <> '00') and (Trim(lSubjectCode) = lSubFound) then
              begin
                if pAM and (tsStart[D, P] < StrToDateTime('12:00:00 PM')) then
                  Inc(lCount)
                else if not pAM and (tsStart[D, P] >= StrToDateTime('12:00:00 PM')) then
                  Inc(lCount);
              end;  // if
            end;
          end;
        end; // for
      end;  // for
  finally
    Result := lCount;
  end;
end;

function GetAllSubjectsAverageLoad(const pAM: Boolean): Integer;
var
  d, p, y, l: Integer;
  Su, Te, Ro: Integer;
  aFnt: TPIntPoint;
  lSubFound: string;
  lCount: Integer;
  lSubCount: Integer;
  lTempList: TStringList;
begin
  lCount := 0;
  lSubCount := 0;
  lTempList := TStringList.Create;
  try
    for y := 0 to years_minus_1 do
      for l:= 1 to level[y] do
      begin
        for d := 0 to Days -1  do
        begin
          for p := 0 to TLimit[d] - 1 do
          begin
            aFnt := FNT(d, p, y, l, 0);
            Su := aFnt^;
            Inc(aFnt);
            Te := aFnt^;
            Inc(aFnt);
            Ro := aFnt^;
            if (Su <> 0) then
            begin
              lSubFound := Trim(SubCode[Su]);
              //lSubCount  count should be for unique subjects only
              if Copy(lSubFound, 1, 2) <> '00' then
              begin
                if lTempList.IndexOf(lSubFound) = -1 then
                  lTempList.Add(lSubFound);
                if pAM and (tsStart[D, P] < StrToDateTime('12:00:00 PM')) then
                  Inc(lCount)
                else if not pAM and (tsStart[D, P] >= StrToDateTime('12:00:00 PM')) then
                  Inc(lCount);
              end;  // if
            end;
          end;
        end; // for
      end;  // for
  finally
    if lTempList.Count = 0 then
      Result := 0
    else
      Result := Round(lCount / lTempList.Count);
    FreeAndNil(lTempList);
  end;
end;

function GetStudentHomeRoom(const pStudNo: Integer): string;
var
  lStr: string;
  lCode: string;
begin
   lstr := '';
   try
     lStr := Trim(XML_TEACHERS.TeName[XML_STUDENTS.Stud[pStudNo].Home, 1]);
     lCode := Trim(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[pStudNo].Home, 1]);
     if lStr = '' then
       lStr := lCode
     else
       lStr := lCode +  ' (' + lStr + ')';
   finally
     Result := lStr;
   end;
end;

function GetSubjectFaculties(const pSubNo: Integer): string;
var
  lFN: Integer;
  lStr: string;
begin
  lStr := '';
  try
    for lFN := 0 to FacNum do
      if FindSubInFac(lFN, pSubNo) then
        lStr := lStr + FacName[lFN] + '  ';
  finally
    Result := lStr;
  end;
end;

end.
