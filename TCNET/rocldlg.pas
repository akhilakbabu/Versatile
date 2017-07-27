unit Rocldlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals,GlobalToTcAndTcextra, XML.DISPLAY;

type
  TroomClashdlg = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    procedure CancelbuttonClick(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  end;

var
  roomClashdlg: TroomClashdlg;

implementation
uses tcommon;
{$R *.DFM}

procedure TroomClashdlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure TroomClashdlg.OKbuttonClick(Sender: TObject);
begin
 XML_DISPLAY.rcCurPeriodOnly:=checkbox1.checked;
 close;
 try
  screen.cursor:=crHourglass;
  UpdateWindow(wnRoClash);
 finally
  screen.cursor:=crDefault;
 end;
 close;
end;

procedure TroomClashdlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TroomClashdlg.FormCreate(Sender: TObject);
begin
 checkbox1.checked:=XML_DISPLAY.rcCurPeriodOnly;
 checkbox1.hint:='Check to show '+day[nd]+' '+inttostr(np+1)+
   ' only.  Uncheck to show all time slots.';
end;

end.
