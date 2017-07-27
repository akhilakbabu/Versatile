unit Gtsprpss;

interface
{$WARN UNIT_PLATFORM OFF}
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, FileCtrl, TimeChartGlobals, XML.USERS,
  XML.UTILS, GlobalToTcAndTcextra;

type
  TgetSuperPasswordDlg = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    Label1: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Bevel2: TBevel;
    SetPath1: TRadioGroup;
    Label4: TLabel;
    Edit3: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure SetPath1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    defaultdir: String[szDirName];
    PathType: Integer;
  end;

var
  getSuperPasswordDlg: TgetSuperPasswordDlg;

implementation

uses
  tcload, tcommon, tcommon2, DlgCommon, tcommon5, uAMGCommon, uAMGConst;

{$R *.DFM}

procedure TgetSuperPasswordDlg.FormCreate(Sender: TObject);
begin
 edit1.maxlength:=szPassword;
 edit2.maxlength:=szPassword;
 edit3.maxlength:=szPassID;
 directoryListBox1.directory:=Directories.progdir;
 defaultDir:=Directories.UsersDir+'\Supervisor';
 MouldyDataCheckTime:=30;
 SetPath1.ItemIndex:=0; PathType:=0;
 DriveCombobox1.Enabled:=false;
 DirectoryListBox1.Enabled:=false;
end;

procedure TgetSuperPasswordDlg.OKbuttonClick(Sender: TObject);
var
  m: smallint;
  msg:  shortstring;
  s: string;
  pass1,passID2: shortstring;
begin
  if trim(edit3.text)='' then
  begin
   ShowMsg('Supervisor ID is required!',edit3);
   exit;
  end;
  if trim(edit1.text)='' then
  begin
   ShowMsg('Password is required!',edit1);
   exit;
  end;
  if trim(uppercase(edit1.text))<>trim(uppercase(edit2.text)) then
  begin
    msg:='Confirm word does not match password.';
    msg:=msg+endline+'Please Re-enter';
    messagedlg(msg,mtError,[mbOK],0);
    edit1.text:=''; edit2.text:='';
    edit1.selectall;
    edit1.setfocus;
    Exit;
  end;
  ModalResult := mrNone;

  if PathType=0 then //default path
  begin
    if not(directoryexists(Directories.UsersDir)) then CreateDir(Directories.UsersDir);
    if not(directoryexists(DefaultDir)) then
    begin
      ForceDirectories(DefaultDir);
      DirectoryListBox1.Update;
    end;
    if not(directoryexists(DefaultDir)) then
    begin
      if not IsDirectoryWriteable(Directories.ProgDir) then
      begin
        msg := Format(AMG_ACCESS_PERMISSIONS_MSG, [Directories.ProgDir]);
        MessageDlg(msg, mtError, [mbOK], 0);
      end;
      if DirectoryListBox1.Enabled and DirectoryListBox1.Visible then
        DirectoryListBox1.SetFocus;
      Exit;
    end;
  end;

  if PathType=1 then s:=directoryListBox1.directory else s:=DefaultDir;

  m:=verifyUserDirectory(s);
  if (m<>0) then
  begin
   msg:='Directory for storing display file'+endline;
   case m of
    1: msg:=msg+'should NOT be the same as the program directory.';
    2: msg:=msg+'should NOT be the same as the data directory.';
    3: msg:=msg+'must ALREADY exist.';
    4: msg:=msg+'must be set to allow read and write access.';
   end; {case}
   msg:=msg+endline+'Please Re-select the directory.';
   messagedlg(msg,mtError,[mbOK],0);
   directoryListBox1.setfocus;
   exit;
  end;

  usrPasslevel:=utSuper; {supervisor}
  usrPassyear:=-1; {all years}
  usrPassID:=trim(uppercase(edit3.text));
  usrPassuse:=1;
  usrPassword:=trim(uppercase(edit1.text));
  pass1:=FNencrypt(RpadString(usrPassword,szPassword));
  passID2:=FNencrypt(RpadString(usrPassID,szPassID));
  usrPassDir:=s;
  CurrentUserRecordIndex:=1;
  UserRecordsCount:=1;
  usrPassBKUP:=true;
  passBKUP[1]:=true;
  passLevel[1]:=usrPasslevel;
  passYear[1]:=usrPassyear;
  passID[1]:=usrPassID;
  password[1]:=usrPassword;

  passUserDir[1]:=usrPassDir;
  {for convenience, check for old TCP2.DAT and load if there}
  ChDir(Directories.progdir);
  saveUsers;
  ModalResult := mrOK;
end;

procedure TgetSuperPasswordDlg.SetPath1Click(Sender: TObject);
begin
 PathType:=SetPath1.ItemIndex;
 DriveCombobox1.Enabled:=(PathType=1);
 DirectoryListBox1.Enabled:=(PathType=1);
 if PathType=0 then label20.Caption:=defaultDir
  else label20.Caption:=directoryListBox1.Directory;
end;

procedure TgetSuperPasswordDlg.FormActivate(Sender: TObject);
begin
 edit3.SetFocus;
end;

end.


