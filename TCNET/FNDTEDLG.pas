unit Fndtedlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, XML.DISPLAY;

type
  Tfindteacherdlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    ComboBox1: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  end;

var
  findteacherdlg: Tfindteacherdlg;

implementation
uses tcommon,DlgCommon,teachtt;
{$R *.DFM}
var
 MyTe:  integer;

procedure Tfindteacherdlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure Tfindteacherdlg.OKbuttonClick(Sender: TObject);
begin
 if myTe>0 then
  begin
   XML_DISPLAY.TeTtSelection[0]:=1;
   XML_DISPLAY.TeTtSelection[1]:=myTe;  {selection}
   XML_DISPLAY.tettlistvals[3]:=0;    {fac}
   XML_DISPLAY.tettseltype:=2; {selection}
   winView[wnTeacherTt]:=1; {weekly}
   teachttablewinselect;
   UpdateWindow(wnTeacherTt);
   close;
   tettable.setfocus;
  end
 else ComboMsg('No Teacher selected',ComboBox1);
end;

procedure Tfindteacherdlg.FormCreate(Sender: TObject);
begin
 myTe:=0;
 FillComboCode(1,ComboBox1);
end;

procedure Tfindteacherdlg.ComboBox1Change(Sender: TObject);
begin
 myTe:=findTe(ComboBox1.Text,label2);
end;

end.
