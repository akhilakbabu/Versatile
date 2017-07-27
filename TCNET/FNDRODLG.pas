unit Fndrodlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, XML.DISPLAY;

type
  Tfindroomdlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    ComboBox1: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  end;

var
  findroomdlg: Tfindroomdlg;

implementation
uses tcommon,DlgCommon,roomtt;
{$R *.DFM}
var
 myRo:  integer;


procedure Tfindroomdlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure Tfindroomdlg.FormCreate(Sender: TObject);
begin
 myRo:=0;
 FillComboCode(2,ComboBox1);
end;

procedure Tfindroomdlg.OKbuttonClick(Sender: TObject);
begin
 if myRo>0 then
  begin
   XML_DISPLAY.RoTtSelection[0]:=1;
   XML_DISPLAY.RoTtSelection[1]:=myRo;  {selection}
   XML_DISPLAY.rottlistvals[3]:=0;     {fac}
   XML_DISPLAY.rottseltype:=2; {selection}
   winView[wnRoomTt]:=1; {weekly}
   roomttablewinselect;
   UpdateWindow(wnRoomTt);
   close;
  end
 else ComboMsg('No Room selected',ComboBox1);
end;

procedure Tfindroomdlg.ComboBox1Change(Sender: TObject);
begin
 myRo:=findRoom(ComboBox1.Text,label2);
end;

end.
