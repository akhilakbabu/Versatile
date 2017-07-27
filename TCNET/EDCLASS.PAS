unit Edclass;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals;

type
  Tedclassdlg = class(TForm)
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Edit10: TEdit;
    btnPreviousRollClass: TButton;
    btnNextRollClass: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure updateClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GoNext(Sender: TObject);
    procedure GoPrevious(Sender: TObject);
    procedure Edit10Change(Sender: TObject);
  end;

var
  edclassdlg: Tedclassdlg;


implementation
uses tcommon,DlgCommon,RollClassWnd,tcommon2,main;
{$R *.DFM}
var
  updateflag:               bool;



procedure Tedclassdlg.FormActivate(Sender: TObject);
var
 nm:      integer;
begin
 edit2.maxlength:=LenClassCodes;
 updateflag:=false;
 label8.caption:=inttostr(RollClassPoint[0]);
 nm:=RollClassWindow.selcode;
 if (nm>0) and (nm<=nmbrClass) then
 begin
  edit10.text:=inttostr(nm);
  label3.caption:=trim(ClassCode[RollClassPoint[nm]]);
  edit2.text:=trim(ClassCode[RollClassPoint[nm]]);
  edit2.setfocus;
 end
 else
  begin
   edit10.text:='';  edit2.text:='';
   label3.caption:='';
  end;

end;

procedure Tedclassdlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
 if updateflag then updateclass;
end;

procedure Tedclassdlg.updateClick(Sender: TObject);
var
 nm,j:      integer;
 s:       string;
begin
 nm:=IntFromEdit(edit10);
 if NoCode(s,edit2) then exit;
 s:=uppercase(trim(edit2.text));
 if CodeZero(s,edit2) then exit;
 j:=FindRollClasscode(s);
 if j>0 then
 begin
  ShowMsg('The Roll Class code '+edit2.text+' already exists.'+endline+
    'Duplicate Roll Class codes are not allowed.',edit2);
  exit;
 end;

 ClassCode[RollClassPoint[nm]]:=trim(s)+space(szclassname);
 ClassCode[RollClassPoint[nm]]:=trim(ClassCode[RollClassPoint[nm]]);

 updateRollClassPoint;
 label8.caption:=inttostr(RollClassPoint[0]);
 updateflag:=true;
 fwClass:=getClassFontWidths(mainform.canvas);
 RollClassWindow.UpdateWin;
 UpdateAllWins;

 edit2.text:='';  label3.caption:=''; 
end;


procedure Tedclassdlg.FormCreate(Sender: TObject);
begin
 TopCentre(self);
end;

procedure Tedclassdlg.GoNext(Sender: TObject);
var
  nm: smallint;
begin
  nm:=IntFromEdit(edit10)+1;
  if nm>RollClassPoint[0] then nm:=RollClassPoint[0];
  edit10.text:=inttostr(nm);
end;

procedure Tedclassdlg.GoPrevious(Sender: TObject);
var
  nm: smallint;
begin
  nm:=IntFromEdit(edit10)-1;
  if nm<1 then nm:=1;
  edit10.text:=inttostr(nm);
end;

procedure Tedclassdlg.Edit10Change(Sender: TObject);
var
  nm: smallint;
begin
  nm:=IntFromEdit(edit10);
  if ((nm<=RollClassPoint[0]) and (nm>0)) then
  begin
    label3.caption:=trim(ClassCode[RollClassPoint[nm]]);
    edit2.text:=trim(ClassCode[RollClassPoint[nm]]);
  end
  else
  begin
    edit2.text:='';     label3.caption:='';
  end;

  btnNextRollClass.Enabled := nm < RollClassPoint[0];
  btnPreviousRollClass.Enabled := nm > 1;
end;

end.
