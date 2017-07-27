unit Autoload;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type
  Tautoloaddlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    procedure OKbuttonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  end;

var
  autoloaddlg: Tautoloaddlg;

implementation
uses tcload,tcommon,DlgCommon,tcommon2,main,tcommon5,TimeChartGlobals;
{$R *.DFM}

procedure Tautoloaddlg.OKbuttonClick(Sender: TObject);
var
 i:       smallint;
begin
 if invalidEntry(i,1,600,'autoload time {minutes)',edit2) then exit;
 MouldyDataCheckTime:=i;
 mainform.timer1.interval:=(60*1000);
 saveUsers;
 close;
end;

procedure Tautoloaddlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure Tautoloaddlg.FormCreate(Sender: TObject);
begin
 edit2.text:=inttostr(MouldyDataCheckTime);
end;

end.
