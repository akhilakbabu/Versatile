unit SubReportLen;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals;

type
  TSubReportLendlg = class(TForm)
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    procedure updateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox1Click(Sender: TObject);
  end;

var
  SubReportLendlg: TSubReportLendlg;

implementation

uses tcommon,DlgCommon,SuWnd, TeWnd, RoWnd;

{$R *.DFM}

var
 AllowLenChange: boolean;




procedure TSubReportLendlg.updateClick(Sender: TObject);
var
 clen,namelen: smallint;
 HasRepCodes: boolean;
begin
 HasRepCodes:=checkbox1.Checked;
 clen:=IntFromEdit(edit1);
 namelen:=IntFromEdit(edit2);
 if ((NumSubRepCodes>0) and HasRepCodes and (clen=LenSubRepCode) and (namelen=LenSubRepName))
    or ((not(HasRepCodes)) and (NumSubRepCodes=0)) then
  begin {no change}
   close;
   exit;
  end;
 if HasRepCodes then
  begin
   if BadLength(clen,2,szSubCode,edit1) then exit;
   if BadLength(namelen,szSubnameDefault,szSubnameMax,edit2) then exit;
  end;
 LenSubRepCode:=clen;
 LenSubRepName:=namelen;
 if HasRepCodes then NumSubRepCodes:=NumCodes[0] else NumSubRepCodes:=0;
 CalcSubReportCodes;
 getCodeFontWidths(0);
 if wnflag[wnSucode] then SuWindow.UpdateWin;
 close;
 UpdateSubReportFile;
end;

procedure TSubReportLendlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
 AllowLenChange:=(NumSubRepCodes>0);
 checkbox1.Checked:=AllowLenChange;
 edit1.Text:=inttostr(LenSubRepCode);
 edit1.Enabled:=AllowLenChange;
 edit2.Text:=inttostr(LenSubRepName);
 edit2.Enabled:=AllowLenChange;
end;

procedure TSubReportLendlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;



procedure TSubReportLendlg.CheckBox1Click(Sender: TObject);
begin
 AllowLenChange:=CheckBox1.Checked;
 edit1.Enabled:=AllowLenChange;
 edit2.Enabled:=AllowLenChange;
end;

end.
