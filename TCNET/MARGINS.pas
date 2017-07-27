unit Margins;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, XML.DISPLAY;

type
  Tpmargins = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelbuttonClick(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  end;

var
  pmargins: Tpmargins;

implementation
uses tcommon,DlgCommon;

{$R *.DFM}

procedure Tpmargins.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure Tpmargins.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure Tpmargins.OKbuttonClick(Sender: TObject);
var
 code: integer;
begin
 val(edit1.text,XML_DISPLAY.prntLeftMargin,code);
 val(edit2.text,XML_DISPLAY.prntTopMargin,code);XML_DISPLAY.
 datestamp:=checkbox1.checked;
 close;
end;

procedure Tpmargins.FormActivate(Sender: TObject);
var
 t: string;
begin
 checkbox1.checked:=XML_DISPLAY.datestamp;
 str(XML_DISPLAY.prntLeftMargin:6:2,t);
 edit1.text:=trim(t);
 str(XML_DISPLAY.prntTopMargin:6:2,t);
 edit2.text:=trim(t);
 edit1.SelectAll;
end;

procedure Tpmargins.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowdecimalInputOnly(key);
end;

end.
