unit Addclass;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals;

type
  TAddclassDlg = class(TForm)
    Label7: TLabel;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Edit2: TEdit;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure updateClick(Sender: TObject);
  end;

var
  AddclassDlg: TAddclassDlg;

implementation
uses tcommon,DlgCommon,RollClassWnd,tcommon2,main;
{$R *.DFM}
var
  updateflag:               bool;



procedure TAddclassDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
 if updateflag then
  begin
   updateclass; AlterTimeFlag:=True;
   AlterWSflag:=true;
  end;
end;

procedure TAddclassDlg.FormCreate(Sender: TObject);
begin
TopCentre(self);
end;

procedure TAddclassDlg.FormActivate(Sender: TObject);
begin
 edit2.maxlength:=LenClassCodes;
 updateflag:=false;
 label8.caption:=inttostr(RollClassPoint[0]);
 edit2.text:='';
 edit2.setfocus;
end;

function getFreeRollClassPos: integer;
var
 j,i: integer;
begin
 j:=0;
 {check if earlier one free}
 for i:=1 to classnum do
  begin
   if (trim(ClassCode[i])='') then
    begin j:=i; break; end;
  end;
 if j=0 then
  begin
   inc(classnum); j:=classnum;
  end;
 result:=j;
end;

procedure TAddclassDlg.updateClick(Sender: TObject);
var
 s:  string;
 nm,j:      integer;
begin
 if NoCode(s,edit2) then exit;
 if CodeZero(s,edit2) then exit;
 j:=FindRollClasscode(s);
 if j>0 then
 begin
  ShowMsg('The Roll Class code '+edit2.text+' already exists.'+endline+
    'Duplicate Roll Class codes are not allowed.',edit2);
  exit;
 end;

 nm:=getFreeRollClassPos;
 if TooMany('roll class codes',nm+1,nmbrClass) then exit;

 ClassCode[nm]:=uppercase(trim(edit2.text)+space(szclassname));
 ClassCode[nm]:=trim(ClassCode[nm]);

 updateRollClassPoint;
 label8.caption:=inttostr(RollClassPoint[0]);
 updateflag:=true;
 fwClass:=getClassFontWidths(mainform.canvas);
 RollClassWindow.UpdateWin;
 edit2.text:='';
 edit2.setfocus;
end;

end.
