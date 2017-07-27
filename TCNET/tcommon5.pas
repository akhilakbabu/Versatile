unit Tcommon5;
{$WARN UNIT_PLATFORM OFF}
interface
uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ExtCtrls, Dialogs, SysUtils,Messages,FileCtrl, grids, TCload, Ttable, TimeChartGlobals,
  logondlg, uAMGCommon, XML.TTABLE, XML.USERS, XML.UTILS, GlobalToTcAndTcextra, XML.DISPLAY,
  XML.STUDENTS;

  function Checkpassword(const pIsStart: Boolean = False): TLoginStat;
  function FNencrypt(astr:shortstring):shortstring;
  function FNencryptDIR(astr:shortstring):shortstring;
  procedure idle(s: longint);  {pause for s milliseconds}
  procedure NETreadINT(var f: file; var a: smallint);
  procedure NETreadstring(var f: file; var astr: shortstring; alen: smallint);
  procedure NETwritestring(var f: file; var astr: shortstring; alen: smallint);
  procedure NETwriteINT(var f: file; var a: smallint);
  procedure showPassLevel;
  function NewPassword: Boolean;
  function GetPassword(const pIsStart: Boolean): TLoginStat;
  procedure saveUsers;
  procedure checkCount;
  procedure loadUsers;
  procedure CheckAccessFile;
  function CheckPriorAccess(dataSection: smallint;
                             lockingData: bool):bool;
  function CheckAccessRights(accessLevelNeeded,
                             dataSection: smallint;
                             lockingData: bool):bool;

  function SilentCheckAccessRights(accessLevelNeeded,   //don't want any messages popping up
                             dataSection: smallint; {index into access file tcp1}
                             lockingData: bool     {true to try and lock else release}
                             ):bool;

  procedure CheckForMouldyData(dataSection: smallint);
  procedure CheckForMouldyData2;

  procedure showRestrictedMsg;
  procedure RemoveDormantLocks;

  function SafelyStreamToFile(tmpFileName, actFileName: shortstring):smallint;
  function CheckUserYearPassAccess(yearToEdit:smallint): wordbool;
  function CheckTTAccess(dataSection: smallint; lockingData: bool):bool;
  function verifyUserDirectory(a: string):smallint;
  function CheckUserYearPassRights(yearToEdit:smallint): wordbool;
  function CheckPriorYearAccess4(DyearDataSection: smallint;
                             lockingData: bool):bool;
  procedure showInvalidDirectoryMsg(cc:integer;cstr:string);
  function ShowPassYears(MyPassYear: smallint): string;
  function GetDefaultUserDir(UserNum,UserLevel: smallint): string;
  procedure LogMeOff(const pUserDir, pUserID: string);
  procedure LogMeOn;
  function UsrTypeDesc(usrType: integer): string;
  function GetUserAccessDetails: string;
  function UserIsGeneric: Boolean;
  procedure ReloadStudentYear(yy: Smallint);


implementation

uses
  tcommon, tcommon2, gtsprpss, main, showuser, TeWnd, TimesWnd, stcommon, block1,
  studlist, StrUtils, customOutput;

type tpAccessFileRec=record
                       date: tdatetime; {8 bytes}
                       time: string[8];
                       userID: string[szPassID];
                       exname: string[8];
                       reserved: string[4];
                      end;
const
  szTCWP51rec=sizeof(tpAccessFileRec);
  szIdleDelay=2000; {number of milliseconds}
  szIdleRetries=5; {number of times to retry}
  UserAccessFile='TCWP51.DAT';
var
 AccessRec: tpAccessFileRec;
 faccess: file;

function UsrTypeDesc(usrType: integer): string;
var
 s: string;
begin
 s:='';
 case usrType of
  utTime: s:='can change all data';
  utStud: s:='can change student data only for set years';
  utBlock: s:='can build blocks and change students for set years';
  utSuper: s:='can change all data and supervise users';
 end;
 result:=s;
end;

procedure LogMeOn;
var
 fname: string;
 myAccessFile: textfile;
 i: integer;
 usrLocksStr: string;
begin
 if (usrPassLevel=utGen) then exit;
 usrAccessTime:=FormatDateTime('d" "mmm" "yy h":"nn"', now);
 if not(directoryexists(usrPassDir)) then exit;
 chdir(usrPassDir);
 fname:=usrPassID+myLogOnFileExt;    //filename based on username
 doAssignFile(myAccessFile,fname);
  try
   Rewrite(myAccessFile);
   try
    Writeln(myAccessFile,'ON');      //as opposed to 'OFF'
    Writeln(myAccessFile,Directories.datadir);
    Writeln(myAccessFile,FileNames.LoadedTimeTable);
    Writeln(myAccessFile,usrAccessTime);
    usrLocksStr:='';
    for i:=1 to accessCountMax do
     if usrDataSectionLocked[i] then
      begin
       if usrLocksStr='' then usrLocksStr:=trim(inttostr(i))
        else usrLocksStr:=usrLocksStr+', '+trim(inttostr(i));
      end;
    Writeln(myAccessFile,usrLocksStr);
    Flush(myAccessFile);  {ensures that the text was actually written to file}
   except
   end;
  finally
   Closefile(myAccessFile);
  end;
 chdir(Directories.datadir);
 UpdateWindow(wnShowUsers);
end;

procedure LogMeOff(const pUserDir, pUserID: string);
var
 fname: string;
 myAccessFile: textfile;
begin
 if (usrPassLevel=utGen) then exit;
 if not(directoryexists(pUserDir)) then Exit;     //usrPassDir
 SetCurrentDir(pUserDir);
 //chdir(usrPassDir);
 fname := pUserID + myLogOnFileExt;    //filename based on username   usrPassID
 doAssignFile(myAccessFile,fname);
 try
  Rewrite(myAccessFile);
  try
   Writeln(myAccessFile,'OFF');      //as opposed to 'ON'
   Writeln(myAccessFile,Directories.datadir);
   Writeln(myAccessFile,FileNames.LoadedTimeTable);
   Writeln(myAccessFile,FormatDateTime('d" "mmm" "yy h":"nn"', now));
   Writeln(myAccessFile,'');
   Flush(myAccessFile);  {ensures that the text was actually written to file}
  except
  end;
 finally
  Closefile(myAccessFile);
 end;
 chdir(Directories.datadir);
end;

function UserHaveDatalockOnThisSection
                (userToCheck: integer;
                 DataSectionToCheck: integer): bool;
var
 astr: string;
 fname: string;
 mydir,userDataDir: string;
 userTTfile: string;
 userDataLocks: string;
 myAccessFile: textfile;
 userDataLocksRAW,tmpDataLocksStr,tmpStrA: string;
 i,k: integer;
 usrLocksStr: string;
begin
 result:=false;
 myDir:=passUserDir[userToCheck];
 fname:=passID[userToCheck]+myLogOnFileExt;    //filename based on username
 if myDir<>Directories.datadir then
  begin
   chdir(Directories.datadir);
   if fileexists(fname) then myDir:=Directories.datadir;
  end;
 if not(directoryexists(myDir)) then exit; {can't access directory}
 chdir(myDir);
 if not(fileexists(fname)) then exit; {no file}
 usrLocksStr:='';
 doAssignFile(myAccessFile,fname);
 try
  Reset(myAccessFile);
  Readln(myAccessFile,astr);
  astr:=trim(astr);
  if (astr<>'ON') then exit;  {user not logged on}
  try
   Readln(myAccessFile,userDataDir);
   if userDataDir<>Directories.datadir then exit; {different data directory}
   Readln(myAccessFile,userTTfile);
   if (DataSectionToCheck=16) or(DataSectionToCheck>=61) then
    if (userTTfile<>FileNames.LoadedTimeTable) then exit; {different timetable}
   Readln(myAccessFile,usrAccessTime);
   Readln(myAccessFile,userDataLocksRAW);
   tmpDataLocksStr:=trim(userDataLocksRAW);
   k:=pos(',',tmpDataLocksStr); i:=-1;
   userDataLocks:='';
   while(k>0) and (i<=DataSectionToCheck) do
   begin
    tmpStrA:=trim(copy(tmpDataLocksStr,1,k-1));
    tmpDataLocksStr:=copy(tmpDataLocksStr,k+1,length(tmpDataLocksStr));
    i:=strtointdef(tmpStrA,0);
    if ((i>0) and (i<=accessCountMax)) then
     if (i=DataSectionToCheck) then
      begin
       result:=true;
       break;
      end;
    k:=pos(',',tmpDataLocksStr);
   end;
   i:=strtointdef(trim(tmpDataLocksStr),0);
   if ((i>0) and (i<=accessCountMax)) then
    if (i=DataSectionToCheck) then result:=true;
  except
  end;
 finally
  Closefile(myAccessFile);
 end;
end;

function GetDefaultUserDir(UserNum,UserLevel: smallint): string;
var
 s,s1,firstpart,lastpart: string;
 addendPos,i,dirlen,addendVal: integer;
 addendUsed: array of boolean;
begin
 s:=Directories.UsersDir;
 case UserLevel of
  utTime: s:=s+'\Timetabler';
  utStud: s:=s+'\Student';
  utBlock: s:=s+'\Blocks';
  utSuper: s:=s+'\Supervisor';
 end;
 dirLen:=Length(s);
 addendPos:=0;
 if (UserRecordsCount>0) and (UserLevel<>utSuper) then
   begin
    setlength(addendUsed,UserRecordsCount+2);
    for i:=1 to UserRecordsCount do addendUsed[i]:=false;
    for i:=1 to UserRecordsCount do
     if (passlevel[i]=UserLevel) and (i<>UserNum) then
      begin
       s1:=passUserDir[i];
       if Length(s1)<=dirLen then continue;
       firstpart:=leftstr(s1,dirLen);
       lastpart:=copy(s1,1+dirLen,Length(s1));
       addendVal:=strtointdef(lastpart,0);
       if (uppercase(firstpart)=uppercase(s)) and (addendVal>0) and
          (addendVal<=UserRecordsCount) then addendUsed[addendVal]:=true;
      end;
    for i:=1 to UserRecordsCount do
     if addendUsed[i]=false then begin addendPos:=i; break; end;
   end;
 if addendPos=0 then addendPos:=1;
 if (UserLevel<>utSuper) then s:=s+inttostr(addendPos);
 result:=s;
end;

function ShowPassYears(MyPassYear: smallint): string;
var
 k: integer;
 a: string;
begin
 a:=yeartitle+' ';
 if MyPassYear=-1 then a:='all years'
 else
  for k:=1 to years do
   if (MyPassYear and (1 shl (k-1)))<>0 then a:=a+yearname[k-1]+' ';
 result:=a;
end;

procedure showInvalidDirectoryMsg(cc:integer;cstr:string);
var
 msg: string;
begin
  if cc=3 then
   msg:='The directory'+endline+cstr+endline+'does not exist.'
  else
   msg:='You do not have read/write access to the directory'+endline+cstr;
  messagedlg(msg,mtInformation,[mbOK],232);
end;

function verifyUserDirectory(a: string):smallint;
var
 b,m,tmpName: string;
 f: textfile;
begin
 result:=0;
 tmpName:='_TC_52.TMP';
 b:=trim(uppercase(a));
 if (trim(uppercase(Directories.progdir))=b) then
 begin  //check not same as program directory
  result:=1; exit;
 end;
 if (trim(uppercase(Directories.datadir))=b) then
 begin  //check not same as data directory
  result:=2; exit;
 end;
 {$I-}
 chdir(b);
 {$I+}
 if IOResult<>0 then
 begin   //check directory exists
  result:=3; exit;
 end;

 try   // check for read/write access
  try
    doAssignFile(F,tmpName);
    rewrite(F);
    m:='TC52 test file';
    Writeln(F,m);
    m:='1234567890';
  finally
   closefile(F);
  end;
  try
   reset(F);
   Readln(F,m);
  finally
   closefile(F);
   if fileexists(tmpName) then deletefile(tmpName);
  end;
  if (m<>'TC52 test file') then
  begin
   result:=4; exit;
  end;
 except
  result:=4; exit;
 end;
end;

function SafelyStreamToFile(tmpFileName, actFileName: shortstring):smallint;
var
 ourSafetyFileStream: TFileStream;
 ourVerifyFileStream: TFileStream;
 ourVerifyStream: Tstream;
 ourCompStr1: TStringStream;
 ourCompStr2: TStringStream;
 ourErr: smallint;
 ourStr1: string;
 ourStr2: string;
begin
 ourErr:=0;  //no probs
{fmCreate	Create a file with the given name. If a file with the given name exists, open the file in write mode.
}
 {save the file }
 ourSafetyFileStream:=TFileStream.Create(tmpFileName,fmCreate);
 try
  ourSafetyFileStream.CopyFrom(tmemorystream(ourSafetyMemStream),0);
 finally
  ourSafetyFileStream.Free
 end;

 ourVerifyStream:=TMemoryStream.Create;
 ourVerifyFileStream:=TFileStream.Create(tmpFileName,fmOpenRead);
  try
   ourVerifyStream.CopyFrom(ourVerifyFileStream,0);
  finally
   ourVerifyFileStream.Free
  end;

 ourStr1:=''; ourCompStr1:=TStringStream.Create(ourStr1);
 ourStr2:=''; ourCompStr2:=TStringStream.Create(ourStr2);
 try
  ourCompStr1.CopyFrom(ourSafetyMemStream,0);
  ourCompStr2.CopyFrom(ourVerifyStream,0);
  if (ourCompStr1.DataString<>ourCompStr2.DataString) then ourErr:=1;
  if (ourCompStr1.Size<>ourCompStr2.Size) then ourErr:=2;
  if (ourSafetyMemStream.Size<>ourVerifyStream.Size) then ourErr:=3;

 finally
  ourVerifyStream.Free;
  ourCompStr2.Free;
  ourCompStr1.Free;
 end;

 if (ourErr=0) then
 begin
  if fileexists(tmpFileName) then    //only if tmp file was written out - else no point trying to switch
  begin
   if fileexists(actFileName) then  //getting error trying to delete what isn't there initially!
    if not(DeleteFile(actFileName)) then ourErr:=4;
   if not(RenameFile(tmpFileName,actFileName)) then ourErr:=5;
  end;
 end;

 case ourErr of
  1: showmessage('File Save Error 1 - Write Validation Failed');
  2: showmessage('File Save Error 2 - Write Validation Failed');
  3: showmessage('File Save Error 3 - Write Validation Failed');
  4: showmessage('File Save Error 4 - Unable to delete '+actFileName+' prior to update');
  5: showmessage('File Save Error 5 - Unable to rename '+tmpFileName+' prior to update');
 end;
 result:=ourErr;
end;

function openAccessFile: integer;
var
 tries,temp: smallint;
begin
 {$I-}
 doAssignFile(faccess,UserAccessfile);
 filemode:=fmOpenReadWrite+fmShareDenyWrite;
 reset(faccess,1);
 tries:=0;temp:=ioresult;
 while ((temp<>0) and (tries<szIdleRetries)) do
   begin
    idle(szIdleDelay);
    reset(faccess,1);  temp:=ioresult;
    inc(tries);
   end;     {should be open now}
 result:=temp;
  {$I+}
end;

function checkIDlock(data: smallint): bool;
var
 oktp,dblChk: bool;
 i:integer;
 accessID:string;
 lAmtTransferred: Integer;
begin
 oktp:=true;
 try
  seek(faccess,data*(szTCWP51rec));
  BlockRead(faccess, AccessRec, sizeof(AccessRec), lAmtTransferred);
  accessID:=uppercase(trim(AccessRec.UserID));
  if ((accessID>'') and (accessID<>uppercase(trim(usrPassID)))) then
     oktp:=false;
 except
 end;

 dblChk:=false;
 if not(oktp) then   //locked but not by current user - verify it's a legit lock by a legit user
  if UserRecordsCount>0 then
   for i:=1 to UserRecordsCount do
    if ((accessID=uppercase(trim(passID[i])))) then
     begin
      dblChk:=true;
      break;
     end;

 if ((not(oktp)) and (not(dblChk))) then    //locked, but not a valid user
 // check individual access files to see if anyone has that data section locked
  if UserRecordsCount>0 then
   for i:=1 to UserRecordsCount do
    if UserHaveDatalockOnThisSection(i,data) then
     begin
      dblChk:=true;        //somebody DOES have a lock on this data section
      break;
     end;

 if (not(dblChk)) then oktp:=true;    //nobody has a lock on this data section so let the user proceed
 result:=oktp;
end;

function setIDaccess(i1:smallint):bool;
begin
 result:=false;
 if ((i1>0) and (i1<=accessCountMax)) then usrDataSectionLocked[i1]:=true;
 if i1>accessCountMax then usrDataSectionLocked[accessCountMax]:=true;
 LogMeOn;
 try
   AccessRec.UserID:=usrPassID; AccessRec.Date:=now;
   seek(faccess,(i1*szTCWP51rec));
   blockwrite(faccess,AccessRec,sizeof(AccessRec));
   result:=true;
 except
 end;
end;

function clearIDaccess(i1:smallint):bool;
begin
 result:=false;
 if ((i1>0) and (i1<=accessCountMax)) then usrDataSectionLocked[i1]:=false;
 if i1>accessCountMax then usrDataSectionLocked[accessCountMax]:=false;
 LogMeOn;
 try
   seek(faccess,(i1)*(szTCWP51rec));
   blockread(faccess,AccessRec,sizeof(AccessRec));
   if (uppercase(trim(AccessRec.UserID))=uppercase(trim(usrPassID))) then
     begin
      AccessRec.UserID:=space(szPassID);
      seek(faccess,(i1)*(szTCWP51rec));
      blockwrite(faccess,AccessRec,sizeof(AccessRec));
     end;
    result:=true;
 except
 end;
end;

procedure ReloadStudentYear(yy: Smallint);
var
 i,j: smallint;
begin
 j:=XML_STUDENTS.numstud;

 for i:=j downto 1 do
  if XML_STUDENTS.Stud[i].TcYear=yy then
   removeStudent(i);  //remove those in that year first.
//reload the year
 StudentQuickStreamLoad(yy);
 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  StudentID2Load(yy);
  StudentID2LoadNew(yy);
 end;
end;

procedure checkMouldOnEntry(dataSection: smallint);
var
 fileStr:       string;
 needrefreshFLG:      wordbool;
 tmpNeedrefreshFLG:   wordbool;
 oldnd,oldnp,oldny,oldnl: byte;

   procedure CheckMyStudents;
   var
    i:   smallint;
    myFileAge: TDateTime;
   begin
    tmpNeedrefreshFLG:=false;
       for i:=0 to years_minus_1 do
       begin
        filestr:='CHOICE'+inttostr(i+1)+'.ST';
        if fileexists(filestr) then
         if FileAge(filestr,myFileAge) then
          if (NEW_DateChecks[17+i]<myFileAge) then
           begin
            reloadStudentYear(i);
            tmpNeedrefreshFLG:=true;
           end;
       end;  {for i}
       if tmpNeedrefreshFLG then
       begin
        needrefreshFLG:=true;
        CountChmax;
        sortStudents;
        UpdateStudCalcs;
        rangeCheckStudSels(liststudentselection);
        rangeCheckStudSels(XML_DISPLAY.studentinputselection);
        rangeCheckStudSels(XML_DISPLAY.studentttselection);
       end;
   end;

   procedure CheckMyBlocks;
   var
    myFileAge: TDateTime;
   begin
     chdir(Directories.blockdir);
     filestr:=blockFile+'.BLK';
     if fileexists(filestr) then
      begin
       if FileAge(filestr,myFileAge) then
        if (NEW_DateChecks[40]<myFileAge) then
         begin
          loadBlock2; //no msgs
          if ((grouptype=9) or (grouptype=10)) then REselectgroup;{block clashes & free in block}
          needrefreshFLG:=true;
         end;
       chdir(Directories.datadir);
      end;
   end;

   function HasNewerFile(fileName: string;myDataSect: integer):boolean;
   var
    myFileAge: TDateTime;
   begin
    result:=false;
    if fileexists(fileName) then
      if FileAge(fileName,myFileAge) then
        if (NEW_DateChecks[myDataSect]<myFileAge) then
         begin
          result:=true;
          needrefreshFLG:=true;
         end;
   end;

begin
 needrefreshFLG:=false;
 chdir(Directories.datadir);
 case dataSection of
  6:  begin  {subjects}
       if (fileexists('SUBCODE.DAT') and fileexists('SUBNAME.DAT')) then
        if HasNewerFile('SUBCODE.DAT',6) then
          begin
           getSubjectCodes;
           sortcodes(0);
          end;
      end;
  1:  begin  {teachers}
       if (fileexists('TECODE.DAT') and fileexists('TENAME.DAT')
         and fileexists('TELOAD.DAT')) then
        if HasNewerFile('TECODE.DAT',1) then
          begin
           getTeacherCodes;
           sortcodes(1);
          end;
      end;
  2:  begin  {rooms}
       if (fileexists('ROOMS.DAT') and fileexists('ROOMNAME.DAT')
         and fileexists('ROLOAD.DAT')) then
        if HasNewerFile('ROOMS.DAT',2) then
          begin
           getRoomCodes;
           sortcodes(2);
          end;
      end;
  3:  begin  {houses}
       if HasNewerFile('HOUSE.DAT',3) then Houseload;
      end;
  4:  begin  {classes}
       if HasNewerFile('CLASS.DAT',4) then LoadRollClasses;
      end;
  5: begin  {group file}
      if (usrPasslevel=utGen) then  // only check for general access
       if HasNewerFile('GROUP.DAT',5) then loadGroups;
      end;

  14: begin  {faculties}
       if HasNewerFile('FACULTY.DAT',14) then getFaculty;
      end;
//15: {was times from allot.dat - now loaded as part of timetable}
  16: begin   {ttable}
       chdir(Directories.timedir);
       if UseNewTTWTimetable then fileStr:= XMLHelper.getTTW_EXTENSION(FileNames.LoadedTimeTable, ToCopy)    
        else fileStr:=FileNames.LoadedTimeTable+'.TT';
       if HasNewerFile(fileStr,16) then
        begin
         oldnd:=nd; oldnp:=np; oldny:=ny; oldnl:=nl;
         getTTable;
           nd:=oldnd; np:=oldnp; ny:=oldny; nl:=oldnl;
         SetTimeCell;
         SetDays;
        end;
        chdir(Directories.datadir);
      end;
  35,36,37: CheckMyStudents;{load any changed student data}

  40: CheckMyBlocks;{blocks}

  41: {blocks with student data}
      begin
       CheckMyBlocks;
       CheckMyStudents;
      end;
 end; {case}
 if needrefreshFLG then UpdateAllWins;
end;

procedure CheckForMouldyData(dataSection: smallint);
begin
 if not(loadFinished) then exit; //NOT during load
 if CheckForMouldyDataFlag then exit;  {prevent re entry}
 CheckForMouldyDataFlag:=true;
 MouldAge:=0; {reset timer}
 chdir(Directories.datadir);

 case dataSection of
  1: checkMouldOnEntry(1); {te}
  2: checkMouldOnEntry(2); {ro}
  3: checkMouldOnEntry(3); {house}
  4: checkMouldOnEntry(4); {class}
  6: checkMouldOnEntry(6);  {subs}
  14: checkMouldOnEntry(14); {fac}
  15: checkMouldOnEntry(15); {times}
  16: checkMouldOnEntry(16); {ttable}
  35,36,37: checkMouldOnEntry(35); {students - not just in group}
  40,41: checkMouldOnEntry(41); {blocks}
 end;
 CheckForMouldyDataFlag:=false;
end;

procedure CheckForMouldyData2;
begin
 if not(loadFinished) then exit; //NOT during load
 if CheckForMouldyDataFlag then exit;  {prevent re entry}
 CheckForMouldyDataFlag:=true;
 MouldAge:=0; {reset timer}
 chdir(Directories.datadir);

 checkMouldOnEntry(1); {te}
 checkMouldOnEntry(2); {ro}
 checkMouldOnEntry(3); {house}
 checkMouldOnEntry(4); {class}
 if usrPassLevel=utGen then //general users only
  checkMouldOnEntry(5); {groups}
 checkMouldOnEntry(14); {fac}
 checkMouldOnEntry(15); {times}
 checkMouldOnEntry(16); {ttable}
 checkMouldOnEntry(35); {students - not just in group}
//need to add check for blocks
 checkMouldOnEntry(41); {choice}
 checkMouldOnEntry(6);  {subs}
 CheckForMouldyDataFlag:=false;
end;

function CheckUserYearPassRights(yearToEdit:smallint): wordbool;
begin
 result:=(usrPassYear=-1) or
  ((usrPassYear and (1 shl yearToEdit))=(1 shl yearToEdit));
end;

function CheckUserYearPassAccess(yearToEdit:smallint): wordbool;
begin
 result:=(usrPassYearLock and (1 shl yearToEdit))=(1 shl yearToEdit);
end;

function CheckPriorYearAccess4(DyearDataSection: smallint;
                           lockingData: bool):bool;
var
 msg:   ansistring;
 okTOpass: bool;

begin
 result:=true; exit;
 if (usrPasslevel=utGen) then begin result:=false; exit; end;
 okTOpass:=false;
 chdir(Directories.datadir);
 try
  try
   if openAccessFile<>0 then
    begin
     msg:='Cannot open access file, try again later.';
     if lockingdata then messagedlg(msg,mtError,[mbOK],250);
     result:=false;
     exit;
    end;


   if lockingdata then
     begin
        if (usrPassYear=-1) or ((usrPassYear and (1 shl DyearDataSection))=(1 shl DyearDataSection)) then {user has access to year}
         if not(checkIDlock(DyearDataSection+17)) then
           begin
              msg:='The User '+AccessRec.UserID
              +' is already altering the '+yeartitle+' '+yearname[DyearDataSection]
              +' student data part of Time Chart.'+endline;
              try
               msg:=msg+'    ('+FormatDateTime('h:n:sam/pm "on" dddd"," mmmm d',AccessRec.Date)+')'+endline;
               msg:=msg+'No changes can be made to this data until this user has finished.';
              except

              end;
           end;

        if msg='' then {lockingdata, and ID is clear so set ID's}
         begin
           okTOpass:=setIDaccess(DyearDataSection+17);
           if okTOpass then usrPassYearLock:=(usrPassYearLock or (1 shl DyearDataSection));
         end;
     end {lockingdata}
      else
        okTOpass:=clearIDaccess(DyearDataSection+17);  {clearing ID}


    if lockingdata then if msg>'' then messagedlg(msg,mtWarning,[mbOK],250);

  finally
   try
    closefile(faccess);
   except
   end;
  end;
 except

 end;
 result:=okTOpass;
end;

function CheckStBlockAccess(dataSection: smallint; lockingData: bool):bool;
var
 msg:   ansistring;
 okTOpass,needlocks: bool;
 a,i: smallint;
 groupYrFlg,myYrFlg: array[0..nmbrYears] of wordbool;
begin
 if (usrPasslevel=utGen) then begin result:=false; exit; end;
 okTOpass:=false;    msg:='';
 usrPassYearLock:=0;  needlocks:=false;
 chdir(Directories.datadir);
 try
  for i:=0 to years_minus_1 do
   begin
    groupYrFlg[i]:=false;
    myYrFlg[i]:=(usrPassYear=-1) or ((usrPassYear and (1 shl i))=(1 shl i));
   end;

  for i:=1 to groupnum do
   begin
    a:=XML_STUDENTS.Stud[StGroup[i]].TcYear;
    if (a>=0) and (a<years) then groupYrFlg[a]:=true;
   end;

  for i:=0 to years_minus_1 do
   begin
    if groupYrFlg[i] then
     if not(myYrFlg[i]) then
       msg:=msg+endline+'You do NOT have access to block '+yeartitle+' '+yearname[i];
   end;

  if lockingdata then if msg<>'' then
   begin
    messagedlg(msg,mtWarning,[mbOK],250);
    result:=false;
    exit;
   end;

  if lockingData then   {check if need to lock}
    for i:=0 to years_minus_1 do
      if groupYrFlg[i] then
        if (not(blockaccess[i])) or (not(yearAccess[i])) then needlocks:=true;

  if not(lockingData) then  {check if need to unlock}
    for i:=0 to years_minus_1 do
      if groupYrFlg[i] then
        if (blockaccess[i] or yearAccess[i]) then needlocks:=true;

  if not(needlocks) then begin okTOpass:=true; result:=true; exit; end;  {already have locks}

  try
   if openAccessFile<>0 then
    begin
     msg:='Cannot open access file, try again later.';
     if lockingdata then messagedlg(msg,mtError,[mbOK],250);
     result:=false;
     exit;
    end;
   msg:='';


   if lockingdata then
     begin
       for i:=0 to years_minus_1 do
        if myYrFlg[i] and groupYrFlg[i] then  {user has access to year}
          begin
           if checkIDlock(17+i) and checkIDlock(43+i) then usrPassYearLock:=(usrPassYearLock or (1 shl i))
           else
            begin
              msg:=msg+endline+'The User '+AccessRec.UserID
              +' is already using '+yeartitle+' '+yearname[i]+endline;
              try
               msg:=msg+'    ('+FormatDateTime('h:n:sam/pm "on" dddd"," mmmm d',AccessRec.Date)+')'+endline;
               msg:=msg+'No changes can be made to this data until this user has finished.';
              except

              end;
            end;
          end;
        if msg='' then {lockingdata, have locks and ID is clear so set ID's}
         begin
           for i:=0 to years_minus_1 do
            if ((usrPassYearLock and (1 shl i))=(1 shl i)) then
             begin
               setIDaccess(17+i); yearAccess[i]:=true;
               setIDaccess(43+i); blockAccess[i]:=true;
             end;
           okTOpass:=true;
         end;
     end {lockingdata}
     else
       begin {clearing ID}
        okTOpass:=true;
        for i:=0 to years_minus_1 do
         begin
          clearIDaccess(43+i);  blockAccess[i]:=false;
          clearIDaccess(17+i);  yearAccess[i]:=false;
         end;
       end;

   if lockingdata then if msg>'' then messagedlg(msg,mtWarning,[mbOK],250);

  finally
   closefile(faccess);
  end;
 except

 end;
 result:=okTOpass;
end;

function CheckAccessAll(dataSection: smallint; lockingData: bool):bool;
var
 msg:                ansistring;
 accessCount:        smallint;
 okTOpass:           bool;
 i:                  smallint;

  procedure CheckIDmessage(i:smallint);
  begin
   if not(checkIDlock(i)) then
     begin
       msg:=msg+endline+'The User '+AccessRec.UserID
          +' is already altering part of Time Chart.'+endline;
       try
          msg:=msg+'    ('+FormatDateTime('h:n:sam/pm "on" dddd"," mmmm d',AccessRec.Date)+')'+endline;
          msg:=msg+'No changes can be made to this data until this user has finished.';
       except
       end;
     end;
  end;

begin
 if (usrPasslevel=utGen) then begin result:=false; exit; end;
 okTOpass:=false;
 chdir(Directories.datadir);
 try
  try
   if openAccessFile<>0 then
    begin
     msg:='Cannot open access file, try again later.';
     if lockingdata then messagedlg(msg,mtError,[mbOK],250);
     result:=false;
     exit;
    end;
   msg:='';

     seek(faccess,0);blockread(faccess,accessCount,2);
     if lockingdata then
      begin      {check for ID and set if all clear}
       for i:=1 to 6 do CheckIDmessage(i);  {codes}
       for i:=14 to 15 do CheckIDmessage(i);  {faculties, times}
       for i:=0 to years_minus_1 do CheckIDmessage(i+17);  {students}
       for i:=0 to years_minus_1 do CheckIDmessage(i+43);  {blocking}
       CheckIDmessage(38); {supervisor}
       CheckIDmessage(16); {timetable}
       if accessCount>60 then for i:=61 to accessCount do CheckIDmessage(i);  {other timetables}
       if msg='' then {lockingdata, have locks and ID is clear so set ID's}
         begin
          for i:=1 to 6 do setIDaccess(i);  {codes}
          for i:=14 to 15 do setIDaccess(i);  {faculties, times}
          for i:=0 to years_minus_1 do setIDaccess(i+17);  {students}
          for i:=0 to years_minus_1 do setIDaccess(i+43);  {blocking}
          setIDaccess(38); {supervisor}
          setIDaccess(16); {timetable}
          if accessCount>60 then for i:=61 to accessCount do setIDaccess(i);
          okTOpass:=true;
         end;
      end   {lockingdata}
     else  {not lockingdata}
      begin
       okTOpass:=true;
        for i:=1 to 6 do clearIDaccess(i);  {codes}
        for i:=14 to 15 do clearIDaccess(i);  {faculties, times}
        for i:=0 to years_minus_1 do clearIDaccess(i+17);  {students}
        for i:=0 to years_minus_1 do clearIDaccess(i+43);  {blocking}
        clearIDaccess(38); {supervisor}
        clearIDaccess(16); {timetable}
        if accessCount>60 then for i:=61 to accessCount do clearIDaccess(i);
      end;

   if lockingdata then if msg>'' then messagedlg(msg,mtWarning,[mbOK],250);

  finally
   try
    closefile(faccess);
   except
   end;
  end;
 except

 end;
 result:=okTOpass;
end;

function CheckBlockAccess(dataSection: smallint; lockingData: bool):bool;
var
 msg:   ansistring;
 okTOpass,needlocks: bool;
 a,i: smallint;
 groupYrFlg,myYrFlg: array[0..nmbrYears] of wordbool;
begin
 if (usrPasslevel=utGen) then begin result:=false; exit; end;
 okTOpass:=false;    msg:='';
 usrPassYearLock:=0;  needlocks:=false;
 chdir(Directories.datadir);
 try
  for i:=0 to years_minus_1 do
   begin
    groupYrFlg[i]:=false;
    myYrFlg[i]:=(usrPassYear=-1) or ((usrPassYear and (1 shl i))=(1 shl i));
   end;

  for i:=1 to groupnum do
   begin
    a:=XML_STUDENTS.Stud[StGroup[i]].TcYear;
    if (a>=0) and (a<years) then groupYrFlg[a]:=true;
   end;

  for i:=0 to years_minus_1 do
   begin
    if groupYrFlg[i] then
     if not(myYrFlg[i]) then
       msg:=msg+endline+'You do NOT have access to block '+yeartitle+' '+yearname[i];
   end;

  if lockingdata then if msg<>'' then
    begin
     messagedlg(msg,mtWarning,[mbOK],250);
     result:=false;
     exit;
    end;

  if lockingData then     {check if need to lock}
    for i:=0 to years_minus_1 do
      if groupYrFlg[i] then
        if not(blockaccess[i]) then needlocks:=true;

  if not(lockingData) then   {check if need to unlock}
    for i:=0 to years_minus_1 do
      if groupYrFlg[i] then
        if blockaccess[i] then needlocks:=true;

  if not(needlocks) then begin result:=true;okTOpass:=true; exit; end;  {already have locks}

  try
   if openAccessFile<>0 then
    begin
     msg:='Cannot open access file, try again later.';
     if lockingdata then messagedlg(msg,mtError,[mbOK],250);
     result:=false;
     exit;
    end;
   msg:='';

   if lockingdata then
     begin
       for i:=0 to years_minus_1 do
        if myYrFlg[i] and groupYrFlg[i] then  {user has access to year}
          begin
           if checkIDlock(43+i) then usrPassYearLock:=(usrPassYearLock or (1 shl i))
           else
            begin
              msg:=msg+endline+'The User '+AccessRec.UserID
              +' is already blocking in '+yeartitle+' '+yearname[i]+endline;
              try
               msg:=msg+'    ('+FormatDateTime('h:n:sam/pm "on" dddd"," mmmm d',AccessRec.Date)+')'+endline;
               msg:=msg+'No changes can be made to this data until this user has finished.';
              except

              end;
            end;
          end;
        if msg='' then {lockingdata, have locks and ID is clear so set ID's}
         begin
           for i:=0 to years_minus_1 do
            if ((usrPassYearLock and (1 shl i))=(1 shl i)) then
               begin setIDaccess(43+i); blockaccess[i]:=true; end;
           okTOpass:=true;
         end;
     end {lockingdata}
      else
       begin {clearing ID}
        okTOpass:=true;
        for i:=0 to years_minus_1 do begin clearIDaccess(43+i); blockaccess[i]:=false; end;
       end;


   if lockingdata then if msg>'' then messagedlg(msg,mtWarning,[mbOK],250);

  finally
    closefile(faccess);
  end;
 except

 end;
 result:=okTOpass;
end;

function CheckStGroupAccess(dataSection: smallint; lockingData: bool):bool;
var
 msg:   ansistring;
 okTOpass: bool;
 grpYEARmap,i,i2: smallint;

begin
 if (usrPasslevel=utGen) then begin result:=false; exit; end;
 okTOpass:=false;
 usrPassYearLock:=0;
 chdir(Directories.datadir);
 try
  try
   if openAccessFile<>0 then
    begin
     msg:='Cannot open access file, try again later.';
     if lockingdata then messagedlg(msg,mtError,[mbOK],250);
     result:=false;
     exit;
    end;
   msg:='';

   grpYEARmap:=0;
   for i:=1 to groupnum do
   begin
    i2:=StGroup[i];
    grpYEARmap:=(grpYEARmap or (1 shl XML_STUDENTS.Stud[i2].TcYear));
   end;

   if lockingdata then
     begin
       for i:=0 to years_minus_1 do
        if ((usrPassYear=-1) or ((usrPassYear and (1 shl i))=(1 shl i)))
         and ((grpYEARmap and (1 shl i))=(1 shl i)) then  {user has access to year}
          begin
           if checkIDlock(17+i) then usrPassYearLock:=(usrPassYearLock or (1 shl i))
           else
            begin
              msg:=msg+endline+'The User '+AccessRec.UserID
              +' is already altering the '+yeartitle+' '+yearname[i]
              +' student data part of Time Chart.'+endline;
              try
               msg:=msg+'    ('+FormatDateTime('h:n:sam/pm "on" dddd"," mmmm d',AccessRec.Date)+')'+endline;
               msg:=msg+'No changes can be made to this data until this user has finished.';
              except

              end;
            end;
          end;
        if msg='' then {lockingdata, have locks and ID is clear so set ID's}
         begin
           for i:=0 to years_minus_1 do
            if ((usrPassYearLock and (1 shl i))=(1 shl i)) then
               setIDaccess(17+i);
           okTOpass:=true;
         end;
     end {lockingdata}
     else
       begin {clearing ID}
        okTOpass:=true;
        for i:=0 to years_minus_1 do begin clearIDaccess(17+i); yearAccess[i]:=false; end;
       end;

   if lockingdata then if msg>'' then messagedlg(msg,mtWarning,[mbOK],250);

  finally
   try
    closefile(faccess);
   except
   end;
  end;
 except

 end;
 result:=okTOpass;
end;

function CheckStAccess(dataSection: smallint; lockingData: bool):bool;
var
 msg:   ansistring;
 okTOpass: bool;
 i: smallint;

begin
 if (usrPasslevel=utGen) then begin result:=false; exit; end;
 okTOpass:=false;
 usrPassYearLock:=0;
 chdir(Directories.datadir);
 try
  try
   if openAccessFile<>0 then
    begin
     msg:='Cannot open access file, try again later.';
     if lockingdata then messagedlg(msg,mtError,[mbOK],250);
     result:=false;
     exit;
    end;
   msg:='';


   if lockingdata then
     begin
       for i:=0 to years_minus_1 do
        if (usrPassYear=-1) or ((usrPassYear and (1 shl i))=(1 shl i)) then {user has access to year}
          begin
           if checkIDlock(17+i) then usrPassYearLock:=(usrPassYearLock or (1 shl i))
           else
            begin
              msg:=msg+endline+'The User '+AccessRec.UserID
              +' is already altering the '+yeartitle+' '+yearname[i]
              +' student data part of Time Chart.'+endline;
              try
               msg:=msg+'    ('+FormatDateTime('h:n:sam/pm "on" dddd"," mmmm d',AccessRec.Date)+')'+endline;
               msg:=msg+'No changes can be made to this data until this user has finished.';
              except

              end;
            end;
          end;
        if msg='' then {lockingdata, have locks and ID is clear so set ID's}
         begin
           for i:=0 to years_minus_1 do
            if ((usrPassYearLock and (1 shl i))=(1 shl i)) then
              setIDaccess(17+i);
          okTOpass:=true;
         end;
     end {lockingdata}
     else
       begin {clearing ID}
        okTOpass:=true;
        for i:=0 to years_minus_1 do begin clearIDaccess(17+i); yearAccess[i]:=false; end;
       end;

   if lockingdata then if msg>'' then messagedlg(msg,mtWarning,[mbOK],250);

  finally
   try
    closefile(faccess);
   except
   end;
  end;
 except

 end;
 result:=okTOpass;
end;

function CheckPriorAccess(dataSection: smallint;
                           lockingData: bool):bool;
var
 msg:            string;
 okTOpass:       bool;
 accessCount:    smallint;
begin
 if (usrPasslevel=utGen) then begin result:=false; exit; end;
 okTOpass:=false;
 chdir(Directories.datadir);
 try
  try
   if openAccessFile<>0 then
    begin
     msg:='Cannot open access file, try again later.';
     if lockingdata then messagedlg(msg,mtError,[mbOK],250);
     result:=false;
     exit;
    end;
   msg:='';


   if lockingdata then
     begin
        if not(checkIDlock(dataSection)) then
           begin
              msg:='The User '+AccessRec.UserID
              +' is already altering this part of Time Chart.'+endline;
              try
               msg:=msg+'    ('+FormatDateTime('h:n:sam/pm "on" dddd"," mmmm d',AccessRec.Date)+')'+endline;
               msg:=msg+'No changes can be made to this data until this user has finished.';
              except

              end;
           end;

        if msg='' then {lockingdata, have locks and ID is clear so set ID's}
         okTOpass:=setIDaccess(datasection);
     end {lockingdata}
     else
        okTOpass:=clearIDaccess(dataSection);  {clearing ID}

   if dataSection>60 then
    begin {timetable other than TTABLE}
     seek(faccess,0); blockread(faccess,accessCount,2);
     if dataSection>accessCount then
      begin
       accessCount:=dataSection;
       seek(faccess,0); blockwrite(faccess,accessCount,2);
      end;
    end;

   if lockingdata then if msg>'' then messagedlg(msg,mtWarning,[mbOK],250);

  finally
   try
    closefile(faccess);
   except
   end;
  end;
 except

 end;
 result:=okTOpass;
end;

procedure showRestrictedMsg;
var
 msg: shortstring;
begin
  msg:='Your User Access Level does not permit you to alter the data ';
  msg:=msg+'for this part of Time Chart.';
  messagedlg(msg,mtInformation,[mbOK],232);
end;

function getNameAccess(ftype,fname:string):smallint;
var
 f:                    file;
 foundpos,blankpos:    integer;
 astr,bstr:            string;
 tries,num,temp:            smallint;

   procedure SearchNameFile;
   var
    i:   integer;
   begin
    foundpos:=0;blankpos:=0;
    seek(f,0);
    blockread(f,num,2);
    if num>0 then
     for i:=1 to num do
      begin
       seek(f,256*i);
       astr:=space(1);
       blockread(f,astr[1],1);
       bstr:=space(255);
       blockread(f,bstr[1],255);
       bstr:=trim(bstr);
       if (bstr='') and (blankpos=0) then blankpos:=i;
       if (bstr=trim(fname)) and (astr=ftype) and (bstr>'') and (foundpos=0) then foundpos:=i;
      end;
   end;

begin
 astr:=' ';setlength(bstr,255);
 result:=0;
 chdir(Directories.datadir);
  {$I-}
 try
   try
     doAssignFile(f,namefile);
     filemode:=fmOpenReadWrite+fmShareDenyWrite;
     reset(f,1); temp:=ioresult;
     tries:=0;
     while ((temp<>0) and (tries<szIdleRetries)) do
       begin
         idle(szIdleDelay);
         reset(f,1); temp:=ioresult;
         inc(tries);
       end;     {should be open now}
     if temp=0 then {file is open}
      begin
       SearchNameFile;
       if foundpos>0 then result:=foundpos
        else
         begin {not found, so add it}
           astr:=ftype; bstr:=RPadString(fname,255);
           if blankpos=0 then begin inc(num);blankpos:=num; end;
           seek(f,256*blankpos);
           blockwrite(f,astr[1],1);
           blockwrite(f,bstr[1],255);
           seek(f,0); blockwrite(f,num,2);
           if ioresult=0 then result:=blankpos;
         end;
      end; {file opened}
   finally
    closefile(f);
   end;

 except

 end;

 {$I+}
end;

function CheckTTAccess(dataSection: smallint;
                           lockingData: bool):bool;
var
 msg:   string;
 okTOpass: bool;
begin
 if (usrPasslevel=utGen) then begin result:=false; exit; end;
 okTOpass:=false; msg:='';
 if lockingData and ttAccess then begin result:=true; exit; end;  {already has access}

 if uppercase(trim(FileNames.LoadedTimeTable))='TTABLE' then
     okTOpass:=CheckPriorAccess(dataSection,lockingData)
  else  {check additional tt's}
   begin
     if ttAccessPos=0 then ttAccessPos:=getNameAccess('T',FileNames.LoadedTimeTable);
     if ttAccessPos=0 then msg:='Can''t lock file, try again later'
       else okTOpass:=CheckPriorAccess(ttAccessPos+60,lockingData);
   end;
 if lockingdata then if msg>'' then messagedlg(msg,mtWarning,[mbOK],250);

 if okTOpass then
  begin
   if lockingData then ttAccess:=true else ttAccess:=false;
  end;

 result:=okTOpass;
end;

function CheckAccessRights(accessLevelNeeded,
                           dataSection: smallint; {index into access file tcp1}
                           lockingData: bool     {true to try and lock else release}
                           ):bool;
var
 okTOpass: bool;
 i,j:        smallint;
begin
 okTOpass:=false;
 case usrPassLevel of
  utGen: if accessLevelNeeded>0 then okTOpass:=false;  {general access}
  utTime: if accessLevelNeeded<>6 then okTOpass:=true; {timetabler access}
  utStud: if accessLevelNeeded=2 then okTOpass:=true;  {student access}
  utBlock: if (accessLevelNeeded=2) or (accessLevelNeeded=3) then
       okTOpass:=true;    {blocking access}
  utSuper: okTOpass:=true; {supervisor access}
 end; {case}
 if not(okTOpass) then
 begin
  showRestrictedMsg;
  result:=false;
  exit;
 end;
 {okTOpass=true}
 if lockingData then HaveDataLock:=true;
  case datasection of
   37: begin  {promote}
    j:=0;
    for i:=17 to 31 do   //need lock on all years
    begin
     okTOpass:=CheckPriorAccess(i,lockingData);
     if not(okTOpass) then
      begin j:=i-1; break; end;
    end; {for i}
    if (not(okTOpass) and (j>=17)) then    {release partial locks}
     for i:=j downto 17 do CheckPriorAccess(i,false);  {can only fail on lock}
   end;  {dataSection=37}

   16: okTOpass:=CheckTTAccess(dataSection,lockingData); {timetable}
   40: okTOpass:=CheckBlockAccess(dataSection,lockingData); {blocks}
   41: okTOpass:=CheckStBlockAccess(dataSection,lockingData); {blocks - with stud data}
   42: okTOpass:=CheckAccessAll(dataSection,lockingData); {the works - lock everything - for restore from backup}
   36: okTOpass:=CheckStGroupAccess(dataSection,lockingData);  {studs - in group}
   35: okTOpass:=CheckStAccess(dataSection,lockingData);  {studs - not just in group}
   else
     okTOpass:=CheckPriorAccess(dataSection,lockingData);
  end; {case}
  if not(lockingData) then HaveDataLock:=false;
 if lockingData then CheckForMouldyData(dataSection);
 result:=okTOpass;
end;

function SilentCheckPriorAccess(dataSection: smallint;  //don't want any popup msgs
                           lockingData: bool):bool;
var
 noMsg: boolean;
 okTOpass:       bool;
begin
 if (usrPasslevel=utGen) then begin result:=false; exit; end;
 okTOpass:=false;
 chdir(Directories.datadir);
 try
  try
   if openAccessFile<>0 then
    begin
     result:=false;
     exit;
    end;
   NoMsg:=True;
   if lockingdata then
     begin
        if not(checkIDlock(dataSection)) then NoMsg:=False;
        if NoMsg then {lockingdata, have locks and ID is clear so set ID's}
         okTOpass:=setIDaccess(datasection);
     end {lockingdata}
    else okTOpass:=clearIDaccess(dataSection);  {clearing ID}

  finally
   try
    closefile(faccess);
   except
   end;
  end;
 except

 end;
 result:=okTOpass;
end;

function SilentCheckAccessRights(accessLevelNeeded,   //don't want any messages popping up
                           dataSection: smallint; {index into access file tcp1}
                           lockingData: bool     {true to try and lock else release}
                           ):bool;
var
 okTOpass: bool;
begin
 okTOpass:=false;
 case usrPassLevel of
  utGen: if accessLevelNeeded>0 then okTOpass:=false;  {general access}
  utTime: if accessLevelNeeded<>6 then okTOpass:=true; {timetabler access}
  utStud: if accessLevelNeeded=2 then okTOpass:=true;  {student access}
  utBlock: if (accessLevelNeeded=2) or (accessLevelNeeded=3) then
       okTOpass:=true;    {blocking access}
  utSuper: okTOpass:=true; {supervisor access}
 end; {case}
 if not(okTOpass) then
 begin
  result:=false;
  exit;
 end;
 {okTOpass=true}
 if lockingData then HaveDataLock:=true;
 okTOpass:=SilentCheckPriorAccess(dataSection,lockingData);
 if not(lockingData) then HaveDataLock:=false;
 if lockingData then CheckForMouldyData(dataSection);
 result:=okTOpass;
end;

procedure RemoveDormantLocks;
var
  i,accesscount: Smallint;
  tmpDate: TDateTime;
  lAmtTransferred: Integer;
begin
  if (usrPasslevel=utGen) then exit;
  fillchar(AccessRec,sizeof(AccessRec),chr(0));
  chdir(Directories.DataDir);
  if not(fileexists(UserAccessfile)) then exit;
  try
    try
      if openAccessFile<>0 then Exit;
      blockread(faccess, accesscount, 2);
      tmpDate := Now;
      IntRange(accesscount,60,32000); {must be atleast 50 if exists}
      for i:=1 to accesscount do
      begin
        Seek(faccess,i*(sztcwp51rec));
        BlockRead(faccess, AccessRec, sizeof(AccessRec), lAmtTransferred);
        if ((uppercase(trim(AccessRec.UserID)) = UpperCase(Trim(usrPassID)))
        or (Double(tmpdate)-double(AccessRec.Date)>7)) then
        begin   {clear if own lock found or if lock older than 7 days}
          AccessRec.UserID:=space(szPassID);
          Seek(faccess,i*(sztcwp51rec));
          BlockWrite(faccess,AccessRec,sizeof(AccessRec));
        end;
      end;   {for i}
    finally
      CloseFile(faccess);
    end;
  except

  end;
end;

procedure CheckAccessFile;
var
 f:               file;
 i:               smallint;
 signature:    string[4];
begin
 if (usrPassLevel=utGen) then exit;
 signature:='TC52';
 chdir(Directories.DataDir);
 if fileexists(UserAccessFile) then
  try
   try
    if openAccessFile=0 then
     begin
      blockread(faccess,i,2);
      blockread(faccess,signature[1],4);
     end;
   finally
    closefile(faccess)
   end;
   if signature<>'TC52' then deletefile(UserAccessFile);
  except
  end;

 if not(fileexists(UserAccessFile)) then
 begin       {not there - create it}
  try
   try
    doAssignFile(f,UserAccessFile);
    rewrite(f,1);
    AccessRec.date:=0; AccessRec.time:='tttttttt'; AccessRec.userid:='        ';
    AccessRec.exname:=space(8); AccessRec.reserved:='xxxx';
    for i:=0 to 70 do
    begin
     seek(f,i*(sztcwp51rec));
     blockwrite(f,AccessRec,sizeof(AccessRec));
    end;

    seek(f,0);  i:=60;
    blockwrite(f,i,2);
    signature:='TC52';
    blockwrite(f,signature[1],4);
   finally
    closefile(f);
   end;
  except

  end;
 end
 else {exists}
  begin   {clear dormant locks}
   removeDormantLocks;
  end;

 if not(fileexists(namefile)) then
  try
   try
    doAssignFile(f,namefile);
    rewrite(f,1);
    i:=0;
    blockwrite(f,i,2);
   finally
    closefile(f);
   end;
  except

  end;
end;

procedure checkCount;
var
 Jc:      smallint;
begin
 for Jc:=0 to 10 do passCount[Jc]:=0;
 if UserRecordsCount=0 then exit;
 for Jc:=1 to UserRecordsCount do
  inc(passCount[passLevel[Jc]]);
end;

procedure NETreadINT(var f: file; var a: smallint);
var
 tries: smallint;
begin
{$I-}
 try
  blockread(f,a,2);
  tries:=0;
  while (not(eof(f)) and (ioresult<>0) and (tries<szIdleRetries)) do
  begin
   idle(szIdleDelay);
   blockread(f,a,2);
   inc(tries);
  end;
 except

 end;
{$I+}
end;

procedure NETwriteINT(var f: file; var a: smallint);
var
 tries: smallint;
begin
 if (usrPasslevel=utGen) then exit;
{$I-}
 blockwrite(f,a,2);
 tries:=0;
 while ((ioresult<>0) and (tries<szIdleRetries)) do
 begin
  idle(szIdleDelay);
  blockwrite(f,a,2);
  inc(tries);
 end;
{$I+}
end;

procedure NETreadstring(var f: file; var astr: shortstring; alen: smallint);
var
 tries: smallint;
begin
{$I-}
 try
  setlength(astr,alen);
  blockread(f,astr[1],alen);
  tries:=0;
  while (not(eof(f)) and (ioresult<>0) and (tries<szIdleRetries)) do
  begin
   idle(szIdleDelay);
   blockread(f,astr[1],alen);
   inc(tries);
  end;
 except

 end;
 setlength(astr,alen);
{$I+}
end;

procedure NETwritestring(var f: file; var astr: shortstring; alen: smallint);
var
 tries: smallint;
begin
 if (usrPasslevel=utGen) then exit;
{$I-}
 blockwrite(f,astr[1],alen);
 tries:=0;
 while ((ioresult<>0) and (tries<szIdleRetries)) do
 begin
  idle(szIdleDelay);
  blockwrite(f,astr[1],alen);
  inc(tries);
 end;
 setlength(astr,alen);
{$I+}
end;

procedure idle(s: longint); {pause for s milliseconds}
var
 f,f2,f3,f4:       real;
const
 ff:double=24*60*60*1000;
begin
 f:=time; f3:=f*ff;
 f2:=f; f4:=f2*ff;
 while s>(f4-f3) do
 begin
  f2:=time; f4:=f2*ff;
 end;
end;

function FNencryptDIR(astr:shortstring):shortstring;
var
 j1,len: smallint;
 b1,b2,b3: byte;
 bstr,es: shortstring;
begin
 es:='';
 len:=length(astr);
 for j1:=1 to len do
 begin
  bstr:=copy(astr,j1,1); b1:=ord(bstr[1]);
  bstr:=copy(encryptStrDIR,j1,1); b2:=ord(bstr[1]);
  b3:=b1 xor b2; bstr:=chr(b3);
  es:=es+bstr;
 end;
 result:=es;
end;

function FNencrypt(astr:shortstring):shortstring;
var
 j1,len: smallint;
 b1,b2,b3: byte;
 bstr,es: shortstring;
begin
 es:='';
 len:=length(astr);
 for j1:=1 to len do
 begin
  bstr:=copy(astr,j1,1); b1:=ord(bstr[1]);
  bstr:=copy(encryptStr,j1,1); b2:=ord(bstr[1]);
  b3:=b1 xor b2; bstr:=chr(b3);
  es:=es+bstr;
 end;
 result:=es;
end;

function NewPassword: Boolean;
begin
  getSuperPasswordDlg := TgetSuperPasswordDlg.Create(Application);
  try
    Result := GetSuperPasswordDlg.ShowModal = mrOK;
  finally
    FreeAndNil(GetSuperPasswordDlg);
  end;
end;

function GetPassword(const pIsStart: Boolean): TLoginStat;
begin
  LoggingonDlg := TLoggingonDlg.Create(application);
  try
    LoggingonDlg.IsStart := pIsStart;
    LoggingonDlg.ShowModal;
    Result := LoggingonDlg.LoginStat;
  finally
    FreeAndNil(LoggingonDlg);
  end;
end;

procedure showPassLevel;
var
  msg: shortstring;
begin
  msg:='Access level: '+accessType[usrPasslevel]+'  ';
  case usrPasslevel of
   utStud,utBlock: msg:=msg+ShowPassYears(usrPassyear);
  end;
  if usrPasslevel>utGen then
  begin
   msg:=msg+endline;
   msg:=msg+'User ID: '+usrPassID;
  end;

  messagedlg(msg,mtInformation,[mbOK],235);
  exit;
end;

procedure saveUsers;
begin
 if (usrPassLevel=utGen) then exit;
 chdir(Directories.progdir);
 XML_USERS.saveUserPasswords_xml(Directories.progdir);
end;

procedure loadUsers;
var
 f:               file;
 i:             smallint;
 astr,bstr,cstr,dstr:       shortstring;
 s: string;
begin
 try
   chdir(Directories.progdir);
   if (fileexists(OldUserPasswordFilename)) then
   try
       doAssignFile(f,OldUserPasswordFilename);
       filemode:=fmOpenRead+fmShareDenyNone;
       reset(f,1);
       NETreadINT(f,UserRecordsCount);
        IntRange(UserRecordsCount,1,nmbrUsers);
       NETreadINT(f,MouldyDataCheckTime);
        IntRange(MouldyDataCheckTime,1,600);
       if UserRecordsCount>0 then
        for i:=1 to UserRecordsCount do
        begin
           seek(f,szTC52PassRec*longint(i));
           NETreadINT(f,passlevel[i]);
            IntRange(passlevel[i],1,6);
           NETreadINT(f,passyear[i]);

           NETreadstring(f,astr,szPassword);
           NETreadstring(f,bstr,szPassID);
           NETreadstring(f,cstr,szUserDirName);
           NETreadstring(f,dstr,1);

           passWord[i]:=trim(FNencrypt(astr));
           passID[i]:=trim(FNencrypt(bstr));
           passUserDir[i]:=trim(FNencryptDIR(cstr));
           passBKUP[i]:=(dstr='*');
           s:= 'Password: '+passWord[i]+' passID: '+ passID[i]+ ' passUserDir: '+  passUserDir[i];
           ShowMessage('Loaded from original TCWP52.DAT FILE ' +#13+#13+S );
        end;
   finally
      closefile(f);
      XML_USERS.saveUserPasswords_xml(Directories.progdir);
      deletefile(OldUserPasswordFilename);
   end;
   XML_USERS.getUserPasswords_xml(Directories.progdir);
 except
 end;
end;


function Checkpassword(const pIsStart: Boolean): TLoginStat;
begin
 Result := lsUnknown;
 if not(loadFinished) then {init on load only, later for log on as diff - stay same if cancel}
 begin   {general mode during load if cancel}
  usrPasslevel:=utGen; usrPassyear:=0; usrPassuse:=0;
  usrPasstime:=timetostr(time); usrPassdate:=datetostr(date);
  usrPassDir:=Directories.datadir;
 end;
 chdir(Directories.progdir);
 loadUsers;
 if fileexists(XML_USERS.DataFile) then
   Result := GetPassword(pIsStart)
 else
   if NewPassword then
     Result := lsLogin;

 if (usrPasslevel>utGen) then loadUsers; {need it for duplicate checks also}
 if usrPasslevel<>utSuper then
  if wnFlag[wnShowUsers] then
  begin
   ShowUsersWin.close;    {hide it if no longer the super}
   ShowUsersWin.free;    {without this explicict statement, it stays and tries repaints}
  end;
 //showPassLevel;
  MainForm.stbTimeChart.Panels[3].Text := GetUserAccessDetails;
end;

function GetUserAccessDetails: string;
var
   msg : string;
begin
  msg := 'Access level: ' + accessType[usrPasslevel]+'  ';
  case usrPasslevel of
     utStud, utBlock: msg := msg + ShowPassYears(usrPassyear);
  end;
  if usrPasslevel > utGen then
  begin
    msg := msg +'  User ID: ' + usrPassID;
  end;
  Result := msg;
end;

function UserIsGeneric: Boolean;
begin
  Result := False;
  if usrPassLevel = utGen then
  begin
    showRestrictedMsg;
    Result := True;
  end;
end;

end.

