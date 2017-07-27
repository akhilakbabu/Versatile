unit Tcgetdir;

interface
{$WARN UNIT_PLATFORM OFF}
uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls,dialogs,sysutils,filectrl, TimeChartGlobals, MRUList, XML.UTILS;

type
  TGetDirDlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DataDirLabel: TLabel;
    BitBtn1: TBitBtn;
    edtProgramDir: TEdit;
    cboDataDir: TComboBox;
    procedure OKBtnClick(Sender: TObject);
    procedure DataDirLabelDblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure RefreshDataDirList;
    procedure AddDirToList(const pDir: string);
  end;

var
  GetDirDlg: TGetDirDlg;

implementation

uses
  tcommon, main, gentool;

{$R *.DFM}

procedure setDirectories;  {write out DIR.SYS }
var
  F: textfile;
  S: string;
begin
 if (usrPassLevel=utGen) then exit;
 try
  try
   chdir(usrPassDir);
   doAssignFile(F,'DIR.SYS');
   rewrite(F);
   Writeln(F,Directories.progdir);
   Writeln(F,Directories.datadir);
   Writeln(F,DOSscreenmem);
  finally
   closefile(F);
   s:='Current data directory is:'+ Directories.datadir;
   if fgGenToolbar then gentoolbarwin.NewDataBtn.hint:=s;
  end;
 except
 end;
end;

procedure TGetDirDlg.FormCreate(Sender: TObject);
var
  lCurrentDir: string;
begin
  lCurrentDir := GetCurrentDir;
  try
    SetCurrentDir(usrPassDir);
  finally
    SetCurrentDir(lCurrentDir);
  end;
end;

procedure TGetDirDlg.FormDestroy(Sender: TObject);
begin
  if Assigned(FMRU) then
    FreeAndNil(FMRU);
end;

procedure TGetDirDlg.FormShow(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    Directories.progdir := Trim(Directories.progdir);
    edtProgramDir.Text := Directories.progdir;
    if Directories.progdir[Length(Directories.progdir)] = '\' then
      datadirlabel.Caption := Directories.progdir + 'DATA'
    else
      datadirlabel.Caption := Directories.progdir + '\DATA';
    AddDirToList(Directories.DataDir);
    cboDataDir.Text := Directories.DataDir;
    if cboDataDir.Visible and cboDataDir.Enabled then
      cboDataDir.SetFocus;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TGetDirDlg.OKBtnClick(Sender: TObject);
var
 tmpStr,tempDir:  string;
 helpContext:        longint;
 ok:                 bool;
begin
  tempDir := cboDataDir.Text;
  tempDir := Trim(tempDir);
  helpContext:=0;
  {$I-}
  chdir(tempDir);
  {$I+}
  if IOResult=0 then
    ok:=true
  else
    ok:=false;

  if ok then
  begin
    Directories.datadir:=tempDir;
    modalresult:=mrOK;
    setDirectories;
    AddDirToList(Directories.DataDir);
  end
  else
  begin
    try
      ForceDirectories(tempDir);
    except
    end;
    {$I-}
    chdir(tempDir);
    {$I+}
    if (IOResult = 0) and (DirectoryExists(tempDir)) then
    begin
      Directories.datadir:=tempDir;
      modalresult:=mrOK;
      setDirectories;
    end
    else
    begin
      {message box}
      tmpStr:='Could not create the directory:'+endline;
      tmpStr:=tmpStr+'<'+tempDir+'>.' +endline;
      tmpStr:=tmpStr+'Please select a different directory.';
      messagedlg(tmpStr,mtError,[mbOK],helpContext);
      if cboDataDir.Visible and cboDataDir.Enabled then
      begin
        cboDataDir.SelectAll;
        cboDataDir.SetFocus;
      end;
    end;
  end;
end;

procedure TGetDirDlg.RefreshDataDirList;
begin
  cboDataDir.Items.Text := FMRU.Items.Text;
end;

procedure TGetDirDlg.DataDirLabelDblClick(Sender: TObject);
begin
  cboDataDir.Text := DataDirLabel.Caption;
  if cboDataDir.Visible and cboDataDir.Enabled then
  begin
    cboDataDir.SelectAll;
    cboDataDir.SetFocus;
  end;
end;

procedure TGetDirDlg.AddDirToList(const pDir: string);
var
  lCurrentDir: string;
begin
  lCurrentDir := GetCurrentDir;
  try
    SetCurrentDir(usrPassDir);
    FMRU.AddItem(Directories.DataDir);
  finally
    SetCurrentDir(lCurrentDir);
  end;
  RefreshDataDirList;
end;

procedure TGetDirDlg.BitBtn1Click(Sender: TObject);
var
  s: string;
begin
  s := Directories.datadir;
  if not(SelectDirectory('Select New Data Directory','', s, [sdNewFolder, sdShowEdit, sdNewUI])) then Exit;
  if s > '' then
    cboDataDir.Text := s;
end;

end.
