unit Tecldlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals,GlobalToTcAndTcextra, XML.DISPLAY;

type
  Tteacherclashdlg = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    procedure CancelbuttonClick(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  teacherclashdlg: Tteacherclashdlg;

implementation
uses tcommon;
{$R *.DFM}

procedure Tteacherclashdlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure Tteacherclashdlg.OKbuttonClick(Sender: TObject);
begin
 XML_DISPLAY.tcCurPeriodOnly:=checkbox1.checked;
 close;
 try
  screen.cursor:=crHourglass;
  UpdateWindow(wnTeClash);
 finally
  screen.cursor:=crDefault;
 end;
 close;
end;

procedure Tteacherclashdlg.FormCreate(Sender: TObject);
begin
 checkbox1.checked:=XML_DISPLAY.tcCurPeriodOnly;
 checkbox1.hint:='Check to show '+day[nd]+' '+inttostr(np+1)+
   ' only.  Uncheck to show all time slots.';
end;

end.
