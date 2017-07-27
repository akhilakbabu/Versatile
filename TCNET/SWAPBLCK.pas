unit Swapblck;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
     StdCtrls, Dialogs,TimeChartGlobals,XML.DISPLAY;

type
  TExchangeBlockDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Finish: TBitBtn;
    ExchangeBtn: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ExchangeBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Restore;
  end;

var
  ExchangeBlockDlg: TExchangeBlockDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,block1,subyr;
var
 fromblock,toblock:  smallint;

procedure TExchangeBlockDlg.Restore;
begin
 edit1.text:='';
 edit2.text:='';
 edit1.setfocus;
end;

procedure TExchangeBlockDlg.FormActivate(Sender: TObject);
begin
 Label3.caption:='Enter block (1-'+inttostr(XML_DISPLAY.blocknum)+')';
 restore;
end;

procedure TExchangeBlockDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TExchangeBlockDlg.ExchangeBtnClick(Sender: TObject);
var
 j:       integer;
begin
 if InvalidEntry(fromblock,1,XML_DISPLAY.blocknum,'from block',edit1) then exit;
 if InvalidEntry(toblock,1,XML_DISPLAY.blocknum,'from block',edit2) then exit;
 if (toblock=fromblock) then
  begin
   ShowMsg(' You can''t exchange a block with itself',edit1);
   exit;
  end;
 for j:=0 to XML_DISPLAY.blocklevel do swapint(Sheet[fromblock,j],Sheet[toblock,j]);
 swapint(fix[fromblock],fix[toblock]);
 restore;
 updateBlockWindow;
 SaveBlockFlag:=True;
end;


procedure TExchangeBlockDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
end;

end.
