unit Bclshdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, TimeChartGlobals;

type
  Tblockclashesdlg = class(TForm)
    RadioGroup1: TRadioGroup;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    procedure OKbuttonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  blockclashesdlg: Tblockclashesdlg;

implementation
uses tcommon;
{$R *.DFM}

procedure Tblockclashesdlg.OKbuttonClick(Sender: TObject);
begin
 winView[wnBlockClashes]:=radiogroup1.itemindex;
 close;
 try
  screen.cursor:=crHourglass;
  UpdateWindow(wnBlockClashes);
 finally
  screen.cursor:=crDefault;
 end;
end;

procedure Tblockclashesdlg.FormCreate(Sender: TObject);
begin
 radiogroup1.itemindex:=winView[wnBlockClashes];
end;

end.
