unit Ttvers;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,sysutils, TimeChartGlobals, GlobalToTcAndTcextra;

type
  TVersionDlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    Edit1: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  end;

var
  VersionDlg: TVersionDlg;

implementation

{$R *.DFM}
uses Tcommon,Tcommon2, Ttable,TTundo, Worksheet;

procedure TVersionDlg.FormActivate(Sender: TObject);
begin
 Edit1.MaxLength:=szVersion;
 Edit1.Text:=Version;
 Edit1.SelectAll;
 Edit1.Setfocus;
end;

procedure TVersionDlg.OKBtnClick(Sender: TObject);
begin
 pushVersion;
 Version:=trim(edit1.text);
 SetTTtitle;
 saveTimeFlag:=true;
 UpdateWindow(wnInfo);
 UpdateTtableWindow;
 updateWSwindow;
end;

end.
