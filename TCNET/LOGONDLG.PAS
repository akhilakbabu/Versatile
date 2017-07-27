unit Logondlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Menus, uAMGCommon, XML.TTABLE,  XML.UTILS, XML.USERS;

type

  TLoggingonDlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    Label2: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    lblExit: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure ExitApp(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FLoginStat: TLoginStat;
    FIsStart: Boolean;
  public
    property LoginStat: TLoginStat read FLoginStat write FLoginStat;
    property IsStart: Boolean read FIsStart write FIsStart;
  end;

var
  LoggingonDlg: TLoggingonDlg;

implementation

uses
  tcload, tcommon, tcommon2, DlgCommon, TimeChartGlobals, tcommon5;

{$R *.DFM}
var
 passWordTries:     smallint;

procedure TLoggingonDlg.ExitApp(Sender: TObject);
begin
  FLoginStat := lsQuit;
  Close;
end;

procedure TLoggingonDlg.FormActivate(Sender: TObject);
begin
  {$IFDEF DEBUG}
  edit1.text := 'bg';
  edit3.text := 'bg';
  {$ENDIF}
end;

procedure TLoggingonDlg.FormCreate(Sender: TObject);
begin

  passWordTries:=0;
  edit1.maxlength:=szPassword;
  edit3.maxlength:=szPassID;

  Self.LoginStat := lsGeneral;  //it is general access unless it is specified otherwise
end;

procedure TLoggingonDlg.FormShow(Sender: TObject);
begin
  lblExit.Visible := FIsStart;
end;

procedure TLoggingonDlg.OKbuttonClick(Sender: TObject);
var
  found,passfound: Bool;
  encryptedPassword,encryptedID: ShortString;
  defaultDir: string;
  f: file;
  i: Smallint;
  a,b,vcheck: Smallint;
  dbPassword,dbUserId,dbDataDirectory,dbBackUpFlag,msg: ShortString;
  _debug: string;
  _UserIndex: integer;
begin
  if ((trim(edit1.text)='') or (trim(edit3.text)='')) then
  begin
    close;
    {general mode}
    usrPasslevel:=utGen; usrPassyear:=0; usrPassuse:=0;  usrPassyearLock:=0;
    usrPasstime:=timetostr(time); usrPassdate:=datetostr(date);
    usrPassDir:=Directories.datadir;    usrPassBKUP:=false;
    exit;
  end;
  //ShowMEssage(Directories.progdir);
  chdir(Directories.progdir);
  ModalResult := mrNone;
  found:=false; passfound:=false;
  usrPassword:=trim(uppercase(edit1.text));
  usrPassID:=trim(uppercase(edit3.text));
  passfound  := XML_USERS.FindIdexPassword(usrPassword) >= 0;
  _UserIndex := XML_USERS.FindIdexUserPassword(usrPassID, usrPassword);
  if _UserIndex >=0 then
  begin
    found:=true;
    CurrentUserRecordIndex:=_UserIndex;
    usrPassLevel := passlevel[_UserIndex];
    usrPassyear  := passYear[_UserIndex];
    usrPassDir   := passUserDir[_UserIndex];
    usrpassBKUP    := passBKUP[_UserIndex];
    if (usrPassDir=Directories.datadir) or (usrPassDir=Directories.progdir)
             or (not(directoryExists(usrPassDir))) then
    begin
       DefaultDir:=GetDefaultUserDir(CurrentUserRecordIndex,usrPassLevel);
       if not(directoryexists(Directories.UsersDir)) then CreateDir(Directories.UsersDir);
       if not(directoryexists(DefaultDir)) then CreateDir(DefaultDir);
       if directoryexists(DefaultDir) then usrPassDir:=DefaultDir;
    end;
    vcheck:=verifyUserDirectory(usrPassDir);
    if (vcheck<>0) then
    begin // 1-progdir, 2-datadir, 3-dir not exist, 4-w/r access problem
       usrPassDir:=Directories.datadir; //same as general users
       msg:='Directory for storing your display file is not correct.'+endline;
       msg:=msg+'Your display preferences will not be saved on exit.'+endline+endline;
       msg:=msg+'Contact your Time Chart Supervisor to correctly set'+endline;
       msg:=msg+'your display directory with read/write access.'+endline;
       messagedlg(msg,mtWarning,[mbOK],0);
    end; {vcheck<>0}
    ModalResult := mrOK;
  end;
  if Found and PassFound then
    if (passfound and not(found)) then
    begin
      ShowMsg('User ID not found.'+endline+'Please Re-enter.',edit3);
      inc(passWordTries);
      if passWordTries>2 then
      begin
        msg:='Closing Time Chart.'+endline+'Attempted password access has failed.';
        messagedlg(msg,mtWarning,[mbOK],0);
        //application.terminate;
        FLoginStat := lsQuit;
      end;
      Exit;
    end;
  if not(passfound) then
  begin
    ShowMsg('Password not found.'+endline+'Please Re-enter.',edit1);
    inc(passWordTries);
    if passWordTries>2 then
    begin
      msg:='Closing Time Chart.'+endline+'Attempted password access has failed.';
      messagedlg(msg,mtWarning,[mbOK],0);
      //application.terminate;
      FLoginStat := lsQuit;
    end;
    Exit;
  end;
  FLoginStat := lsLogin;
  ModalResult := mrOK;
end;

end.




