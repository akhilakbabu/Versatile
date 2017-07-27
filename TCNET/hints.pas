unit hints;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, TimeChartGlobals, XML.DISPLAY;

type
  THintsdlg = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  Hintsdlg: THintsdlg;

implementation
uses
 tcommon,tcommon2;
var
 hintI: smallint;

{$R *.DFM}

procedure THintsdlg.FormCreate(Sender: TObject);
begin
 checkbox1.checked:=XML_DISPLAY.showHintsDlg;
 randomize;
 hintI:=random(nmbrScrollHints)+1;
 memo1.clear;
 memo1.lines[0]:=scrollhinttxt[hintI];
 memo1.repaint;
end;

procedure THintsdlg.BitBtn1Click(Sender: TObject);
begin
 inc(hintI);
 if hintI>nmbrScrollhints then hintI:=1;
 memo1.clear;
 memo1.lines[0]:=scrollhinttxt[hintI];
 memo1.repaint; 
end;

procedure THintsdlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 XML_DISPLAY.showHintsDlg:=checkbox1.checked;
end;

end.
