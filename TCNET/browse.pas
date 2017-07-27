unit Browse;

interface
 {$WARN UNIT_PLATFORM OFF}
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, FileCtrl, TimeChartGlobals;

type
  TBrowseDlg = class(TForm)
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    Label1: TLabel;
    DriveComboBox1: TDriveComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BrowseDlg: TBrowseDlg;

implementation
uses tcommon;
{$R *.DFM}

procedure TBrowseDlg.OKBtnClick(Sender: TObject);
begin
  {mainform.OpenDialog.Title:='Set Directory';  }

{  OpenDialog.Filter:='Timetable|*.tt';}
 { mainform.OpenDialog.InitialDir:=datadir;
  mainform.OpenDialog.filename:='';
  mainform.OpenDialog.defaultext:='ttw';
  mainform.OpenDialog.options:=[ofHideReadOnly,ofPathMustExist,ofShowHelp];
  if mainform.OpenDialog.Execute then
  begin
   tmpstr:=ExtractFilePath(mainform.OpenDialog.Filename);
   datadiredit.text:=tmpstr;
  end;     }
  browsedir:=uppercase(directorylistbox1.directory);

end;

procedure TBrowseDlg.FormCreate(Sender: TObject);
begin
 browsedir:='';
end;

end.
