unit OpenFile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, ExtCtrls;

type
  TFrmOpenFile = class(TForm)
    dlbOpenFile: TDirectoryListBox;
    flbOpenFile: TFileListBox;
    Panel1: TPanel;
    dcbOpenFile: TDriveComboBox;
    Panel2: TPanel;
    btnOpen: TButton;
    btnCancel: TButton;
    lblLookIn: TLabel;
    edtFileName: TEdit;
    edtFilesOfType: TEdit;
    lblFileName: TLabel;
    lblFilesOfType: TLabel;
    procedure FormShow(Sender: TObject);
    procedure UpdateDrive(Sender: TObject);
    procedure SelectFile(Sender: TObject);
    procedure SelectAndClose(Sender: TObject);
    procedure UpdateFileName(Sender: TObject);
  private
    FTitle: string;
    FInitialDir: string;
    FSelectedFile: string;
    FFileType: string;
  public
    property InitialDir: string read FInitialDir write FInitialDir;
    property Title: string read FTitle write FTitle;
    property SelectedFile: string read FSelectedFile write FSelectedFile;
    property FileType: string read FFileType write FFileType;
  end;

var
  FrmOpenFile: TFrmOpenFile;

implementation

{$R *.dfm}

procedure TFrmOpenFile.FormShow(Sender: TObject);
begin
  Self.Caption := FTitle;
  dlbOpenFile.Directory := FInitialDir;
  edtFilesOfType.Text := FFileType;
end;

procedure TFrmOpenFile.SelectAndClose(Sender: TObject);
begin
  btnOpen.Click;
end;

procedure TFrmOpenFile.SelectFile(Sender: TObject);
begin
  FSelectedFile := flbOpenFile.Directory + '\' + Trim(edtFileName.Text);
end;

procedure TFrmOpenFile.UpdateDrive(Sender: TObject);
begin
  dlbOpenFile.Drive := dcbOpenFile.Drive;
end;

procedure TFrmOpenFile.UpdateFileName(Sender: TObject);
begin
  edtFileName.Text := ExtractFileName(flbOpenFile.FileName);
end;

end.
