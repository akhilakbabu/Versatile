unit Bckupdlg;

interface
 {$WARN UNIT_PLATFORM OFF}
 {$WARN SYMBOL_PLATFORM OFF}
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, FileCtrl, Buttons, ComCtrls, TimeChartGlobals, XML.TTABLE, XML.UTILS,GlobalToTcAndTcextra;

type
  TBackupDataDlg = class(TForm)
    finish: TBitBtn;
    update: TBitBtn;
    help: TBitBtn;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    Animate1: TAnimate;
    Label3: TLabel;
    Label4: TLabel;
    btnSelectBackupDir: TButton;
    procedure FormCreate(Sender: TObject);
    procedure updateClick(Sender: TObject);
    procedure SelectBackupDir(Sender: TObject);
  private
   function SpaceToCopy:boolean;
   procedure CopyMyFiles;
   function DoMyCopy(FileToBkup: AnsiString): Boolean;
  end;

var
  BackupDataDlg: TBackupDataDlg;

implementation
{$WARN UNIT_PLATFORM OFF}

uses
  tcommon,tcommon2,tcload, customOutput, uAMGCommon;

{$R *.DFM}

const
 CodeNumToCopy = 21;   //20 ---- mantis-1295
 TtFileNumToCopy=5;
 CodeFilesToCopy: array[1..CodeNumToCopy] of string=('SUBCODE.DAT','SUBNAME.DAT',
    'TECODE.DAT','TENAME.DAT','TELOAD.DAT','ROOMS.DAT','ROOMNAME.DAT',
    'ROLOAD.DAT','GROUP.DAT','FACULTY.DAT','HOUSE.DAT','ALLOT.DAT',
    'CLASS.DAT','SUBREP.DAT','TTInUse.DAT','TAG.DAT', 'STHEALTH.DAT',
    'HLTHISSU.DAT','CLASSSUB.DAT','STUDTAG.DAT','SubWillCount.DAT'); //---- mantis-1295
 CodeCopyDesc: array[1..CodeNumToCopy] of string=('Subject Codes','Subject Names',
    'Teacher Codes','Teacher Names','Teacher Loads','Room Codes','Room Names',
    'Room Details','Student Groups','Faculties','Houses','Time Allotments',
    'Roll Classes','Subject Report Codes','Timetable in use','Tag codes & names', 'Student Health',
    'Health Conditions','Class Subjects','Tags Details','Sub Will Count');
 NumOfExt=4;
 ExtToCopy: array[1..NumOfExt] of string=('BLK','CUS','SBO','TCD');
 ExtDesc: array[1..NumOfExt] of string=('Block file','Custom file',
    'Offer file','Display file');

var
 DsksizeGOT,DsksizeNEED: int64;
 TOdir,FROMdir:   string;
 TOdir1,FROMdir1: string;
 msg:             string;
 CopyComplete:    boolean;
 instRslt:      bool;
 NumToCopy: integer;
 FilesToCopy,CopyDesc: array of string;
 BackupDir: string;

procedure SetFilesToCopy;
var
 y,n: integer;
begin
  NumToCopy := CodeNumToCopy + TtFileNumToCopy+ 3 * years;
  setlength(FilesToCopy, NumToCopy + 2);
  setlength(CopyDesc, NumToCopy + 2);
  FilesToCopy[1]:=XMLHelper.getTTW_EXTENSION(FileNames.LoadedTimeTable,ToCopy); CopyDesc[1]:=FileNames.LoadedTimeTable+' timetable';
  FilesToCopy[2]:=XMLHelper.getLAB_EXTENSION(FileNames.LoadedTimeTable, toCopy); CopyDesc[2]:=FileNames.LoadedTimeTable+' timetable';
  FilesToCopy[3]:=XMLHelper.getNAM_EXTENSION(FileNames.LoadedTimeTable,toCopy); CopyDesc[3]:=FileNames.LoadedTimeTable+' timetable';
  FilesToCopy[4]:=XMLHelper.getCLS_EXTENSION(FileNames.LoadedTimeTable,ToCopy); CopyDesc[4]:=FileNames.LoadedTimeTable+' timetable';
  FilesToCopy[5]:=FileNames.LoadedTimeTable+'.TWS'; CopyDesc[5]:=FileNames.LoadedTimeTable+' timetable';
  n:=6;
  for y:=1 to years do
  begin
    FilesToCopy[n]:='CHOICE'+inttostr(y)+'.ST';
    CopyDesc[n]:=yeartitle+' '+yearname[y-1]+' students';
    inc(n);
  end;

  //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
  begin
  for y:=1 to years do
  begin
    FilesToCopy[n]:='STUID'+inttostr(y)+'.DAT';
    CopyDesc[n]:=yeartitle+' '+yearname[y-1]+' students';
    inc(n);
  end;
  end;

  for y:=1 to years do
  begin
    FilesToCopy[n]:='CLASS'+inttostr(y)+'.DAT';
    CopyDesc[n]:=yeartitle+' '+yearname[y-1]+' roll classes';
    inc(n)
  end;
  for y:=1 to CodeNumToCopy do
  begin
    FilesToCopy[n]:=CodeFilesToCopy[y];
    CopyDesc[n]:=CodeCopyDesc[y];
    inc(n)
  end;
end;

procedure checkFsize(fileToChck: ansistring);
var
 ff: file;
begin
 if fileexists(fileToChck) then
  try
   try
    doAssignFile(ff,fileToChck);
    filemode:=fmOpenRead+fmShareDenyNone;
    reset(ff,1);
    inc(DsksizeNEED,filesize(ff));
   finally
    closefile(ff);
   end;
  except
  end;
end;

procedure allowForExistingFsize(fileToChck: ansistring);
var
 ff: file;
begin
 fileToChck:=TOdir1+fileToChck;
 if fileexists(fileToChck) then
  try
   try
    doAssignFile(ff,fileToChck);
    filemode:=fmOpenRead+fmShareDenyNone;
    reset(ff,1);
    dec(DsksizeNEED,filesize(ff));
   finally
    closefile(ff);
   end;
  except
  end;
end;

procedure TBackupDataDlg.CopyMyFiles;
var
  i: Integer;
  fsRec: Tsearchrec;
  kkk: LongWord;
  a: string;
begin
  animate1.commonAVI := aviCopyFiles;
  animate1.visible:=true;
  animate1.active:=true;
  if backup_action=1 then a:='Backup' else a:='Restore';
  instRslt:=true;
  chdir(FROMdir);
  SetFolderContentAS(TOdir1, FILE_ATTRIBUTE_NORMAL);
  for i:=1 to NumToCopy do
  if FileExists(FilesToCopy[i])then
  begin
    label1.Caption := 'Copying ' + CopyDesc[i]+' ...';
    Repaint;
    instRslt := DoMyCopy(FilesToCopy[i]);
    if not(instRslt) then Break;
  end;

  if instRslt then
  for i:=1 to NumOfExt do
  begin
    fsRec.name:='';
    findfirst(FROMdir1+'*.'+ExtToCopy[i],faArchive,fsRec);
    while (fsRec.name>'') do
    begin
      label1.caption:='Copying '+ExtDesc[i]+' ... ['+fsRec.name+']';
      repaint;
      instRslt := DoMyCopy(fsRec.name);
      if not(instRslt) then break;
      if findnext(fsRec)<>0 then fsrec.name:='';
    end; {while}
    SysUtils.findclose(fsRec);
    if not(instRslt) then break;
  end; // for

  if not(instRslt) then
  begin
    kkk:=GetLastError();
    animate1.visible:=false; animate1.active:=false;
    msg:=space(250);
    FormatMessage((FORMAT_MESSAGE_FROM_SYSTEM),Nil,kkk,0,pchar(msg),250,Nil);
    msg:=trim(msg);
    MessageDlg(msg,mtInformation, [mbOK], 0);

    msg:=a+' encountered errors.'+endline;
    msg:=msg+a+' of Time Chart Data is NOT COMPLETE. Please try again.';
    MessageDlg(msg, mtInformation, [mbOK], 0);
  end;

  CopyComplete:=instRslt;
end;

function TBackupDataDlg.SpaceToCopy:boolean;
var
 i: integer;
 a1,a2:         double;
 fsRec:         Tsearchrec;
begin
 result:=false;
 finish.enabled:=false; update.enabled:=false; help.enabled:=false;
 FROMdir1:=FROMdir; TOdir1:=TOdir;
 if TOdir1[length(TOdir1)]<>'\' then TOdir1:=TOdir1+'\';
 if FROMdir1[length(FROMdir1)]<>'\' then FROMdir1:=FROMdir1+'\';

 chdir(TODir);
 {$I-}
 DsksizeGOT:=diskfree(0);
 {$I+}

 if DsksizeGOT=-1 then exit; {invalid drive specified}

 if DsksizeGOT=0 then
 begin
  msg:='There is no free space available on '+TODir+endline;
  if backup_action=1 then
       msg:=msg+'Please insert another disk or select a different Drive.';
  exit;
 end; {**** disk full ****}

 {check how much disk space is needed}
 animate1.commonAVI:=aviFindFolder;
 animate1.visible:=true; animate1.active:=true;
 label1.caption:='Checking disk space required ...';
 repaint;
 chdir(FROMdir);
 DsksizeNEED:=0;
 for i:=1 to NumToCopy do
   checkFsize(FilesToCopy[i]);

 for i:=1 to NumOfExt do
  begin
   fsrec.name:='';
   findfirst(FROMdir1+'*.'+ExtToCopy[i],faArchive,fsRec);
   while (fsRec.name>'') do
    begin
     checkFsize(fsRec.name);
     allowForExistingFsize(fsRec.name);
     if findnext(fsRec)<>0 then fsrec.name:='';
    end; {while}
   SysUtils.findclose(fsRec);
  end;

 {check how much disk space we've got}
  animate1.commonAVI:=aviFindComputer;
 animate1.visible:=true; animate1.active:=true;
 label1.caption:='Checking disk space available ...';
 repaint;

 for i:=1 to NumToCopy do
   allowForExistingFsize(FilesToCopy[i]);

 if DsksizeGOT<DsksizeNEED then
   begin
    a1:=DsksizeNEED; a2:=DsksizeGOT;
    msg:='Insufficient disk space available on the destination drive.'+endline;
    msg:=msg+Format('The data requires %9.0n bytes and only %9.0n bytes are available',
               [a1,a2]);
    msg:=msg+' on '+TODir;
    exit;
   end;
 result:=true;
end;

function TBackupDataDlg.DoMyCopy(FileToBkup: AnsiString): Boolean;
begin
  Result := False;
  if CopyFile(Pchar(FROMDir1 + FileToBkup), Pchar(TODir1 + FileToBkup), False) then
    Result := FileExists(TODir1 + FileToBkup);
end;

procedure TBackupDataDlg.FormCreate(Sender: TObject);
var
 myBack: integer;
 s: string;
begin
 myBack:=backup_number;
 SetFilesToCopy;
 case backup_action of
  1: begin
      Caption:='Backup Data';
      label2.caption:='Backup Data disk number '+inttostr(backup_number);
      HelpContext:=219;
     end;
  2: begin
      Caption:='Restore Data from Backup';
      dec(myBack);
      if myBack<1 then myBack:=nmbrBackupDisks;
      label2.caption:='Last Backup disk number '+inttostr(myBack);
      HelpContext:=235;
     end;
 end;
 label1.caption:='';
 s:=backupPath[myBack];
 if directoryexists(s) and (s<>Directories.datadir) and (s<>Directories.progdir) then
  begin
   label4.Caption:=s; label4.Hint:=s;
   BackupDir:=s;
  end
 else
  begin
   update.Enabled:=false;
   label4.caption:='';  label4.Hint:='No location set';
   BackupDir:='';
  end;
end;

function NEWshowErrors(copyRslt:bool; fromt,tot,filet: ansistring): bool;
begin
 result:=copyRslt;
end;

procedure TBackupDataDlg.updateClick(Sender: TObject);
var
 nextNum: smallint;
begin
 msg:='';  CopyComplete:=false;
 nextNum:=backup_number;
 screen.cursor:=crhourglass;
 try
  case backup_action of
   1: begin
       FROMdir:=Directories.datadir; TOdir:=BackupDir;
       BackupPath[backup_number]:=BackupDir;
       inc(nextNum);
       if nextNum<1 then nextNum:=1;
       if nextNum>nmbrBackupDisks then nextNum:=1;
      end;
   2: begin
       FROMdir:=BackupDir; TOdir:=Directories.datadir;
      end;
  end;

 if SpaceToCopy then CopyMyFiles;

 if msg>'' then messagedlg(msg,mtError,[mbok],0);

 if not(CopyComplete) then
  begin
   label1.caption:='';
   BackupDataDlg.animate1.commonAVI:=aviCopyFiles;
   BackupDataDlg.animate1.active:=false; BackupDataDlg.animate1.visible:=false;
   finish.enabled:=true; update.enabled:=true; help.enabled:=true;
   exit;
  end; {**** unsuccessful ****}


 if backup_action=2 then {restore}
  begin
   saveWinDisplay;
   Directories.textdir:=Directories.datadir;
   Directories.timedir:=Directories.datadir;
   chdir(Directories.datadir);
   firstLoad;
   CheckSelections;
   UpdateAllWins;
  end;
 finally
  screen.cursor:=crDefault;
 end; {try}

 backup_number:=nextNum;
 updatebackupfile;
 close;
end;

procedure TBackupDataDlg.SelectBackupDir(Sender: TObject);
var
  s,msg: string;
begin
  msg := '';
  s := BackupDir;

  if not(SelectDirectory('Select Backup Directory','',s, [sdNewFolder, sdShowEdit, sdNewUI])) then
    exit;
  if s = Directories.datadir then
    msg := 'Cannot backup to data folder ';
  if s = Directories.progdir then
    msg := 'Cannot backup to program folder ';
  if msg > '' then
  begin
    messagedlg(msg, mtError, [mbok], 0);
    Exit;
  end;
  if DirectoryExists(s) then
  begin
    label4.Caption := s;
    label4.Hint := s;
    BackupDir := s;
    update.Enabled := True;
  end;
end;

end.
