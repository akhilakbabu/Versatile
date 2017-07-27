unit wsTarget;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, TabNotBk, Dialogs, ComCtrls, TimeChartGlobals, GlobalToTcAndTcextra;

type
  TwsTargetDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Finish: TBitBtn;
    AttachBtn: TBitBtn;
    Label17: TLabel;
    Label18: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ActionSet: TRadioGroup;
    AllBtn: TButton;
    NoneBtn: TButton;
    Label2: TLabel;
    MapSet: TRadioGroup;
    lblAvailableTSMsg: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure AttachBtnClick(Sender: TObject);
    procedure ActionSetClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure AllBtnClick(Sender: TObject);
    procedure NoneBtnClick(Sender: TObject);
    procedure MapSetClick(Sender: TObject);
  private
    procedure Restore;
    procedure DrawTime(d,p: integer);
    procedure ShowCount;
    procedure SetButtons;
  end;

var
  wsTargetDlg: TwsTargetDlg;

implementation


{$R *.DFM}
uses tcommon,DlgCommon,ttable,tcommon2,TTundo;
var
 wstAction: integer;
 wstMapType: integer;
 wstYr: integer=-1;
 wstMap: integer;
 ptab:    tpPeriodData;
 firstStart: bool;
 Navail: integer;
 CheckPer:  array [0..nmbrDays, 0..nmbrPeriods] of boolean;
 CopyRect:   TRect;
 wstHiCol,wstLoCol: Tcolor;

procedure TwsTargetDlg.DrawTime(d,p: integer);
var
  MyColour: Tcolor;
  Srect: Trect;
begin
  Srect.left:=ptab[p]-1; Srect.right:= ptab[p+1]-2;
  Srect.top:= 3+15*d; Srect.bottom:=Srect.top+15;
  image1.Canvas.fillrect(Srect);
  if CheckPer[d,p] then
  begin
    MyColour := wstHiCol;
    image1.canvas.font.style := (image1.canvas.font.style+[fsBold]);
  end
  else
  begin
    MyColour := wstLoCol;
    image1.canvas.font.style := (image1.canvas.font.style-[fsBold]);
  end;
  image1.canvas.font.color:=MyColour;
  image1.canvas.textout(ptab[p],2+15*d,tsCode[d,p]);
end;

procedure TwsTargetDlg.Restore;
var
 d,p:  integer;
begin
 Navail:=0;
 image1.canvas.fillrect(CopyRect); wstMap:=0;
 if wstAction=0 then exit;
 for d:=0 to days-1 do
  begin
   case wstMapType of
    0: wstMap:=wstSingle[wstYr,d];
    1: wstMap:=wstDouble[wstYr,d];
    2: wstMap:=wstTriple[wstYr,d];
   end;
   for p:=0 to Tlimit[d]-1 do
    begin
     CheckPer[d,p]:=false;
     if (wstMap and (1 shl p))<>0 then
      begin
       CheckPer[d,p]:=true; inc(Navail);
      end;
     DrawTime(d,p)
    end; {p}
   end; {for d}
 ShowCount;
end;

procedure TwsTargetDlg.ShowCount;
begin
 label18.Caption:=inttostr(Navail);
end;

procedure TwsTargetDlg.FormCreate(Sender: TObject);
begin
 firstStart:=true;
 FillComboTarget(ComboBox1);
 ComboBox1.ItemIndex:=0;
 ActionSet.ItemIndex:=0;  wstYr:=-1;   wstAction:=0;
 MapSet.ItemIndex:=0;    wstMapType:=0;
 wstHiCol:=clBlack; wstLoCol:=clGray;
 SetPtabs(ptab,image1.Canvas);
 copyrect.left:=ptab[0]-1; copyrect.right:=image1.width;
 copyrect.top:=0; copyrect.bottom:=3+15*days;
 fillchar(CheckPer,sizeof(CheckPer),chr(0));
end;

procedure TwsTargetDlg.FormActivate(Sender: TObject);
begin
 firstStart:=true;
 Restore;
 firstStart:=false;
end;



procedure TwsTargetDlg.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
 d,p,i:  integer;
begin
 if wstAction=0 then exit;
 if (x<(ptab[0]-1)) or (x>ptab[periods]) or (y>(3+15*days)) then exit;
 d:= (y-3) div 15;
 p:=0;
 for i:=0 to periods-1 do
  if x>(ptab[i]-1) then p:=i;
 if p<0 then p:=0; if p>=periods then p:=periods-1;
 if d<0 then d:=0; if d>=days then d:=days-1;
 CheckPer[d,p]:=not(CheckPer[d,p]);
 if CheckPer[d,p] then inc(Navail) else dec(Navail);
 DrawTime(d,p);
 ShowCount;
end;



procedure TwsTargetDlg.MapSetClick(Sender: TObject);
begin
 wstMapType:=MapSet.ItemIndex;
 SetButtons;
end;

procedure TwsTargetDlg.AttachBtnClick(Sender: TObject);
var
 d,p,y: integer;
begin
 for d:=0 to days-1 do
  begin
   wstMap:=0;
   for p:= 0 to Tlimit[d]-1 do
    if CheckPer[d,p] then wstMap:=wstMap or (1 shl p);
   case wstMapType of
    0: begin  {singles}
        wstSingle[wstYr,d]:=wstMap;
        if wstYr=-1 then for y:=0 to years_minus_1 do wstSingle[y,d]:=wstMap;
       end;
    1: begin  {doubles}
        wstDouble[wstYr,d]:=wstMap;
        if wstYr=-1 then for y:=0 to years_minus_1 do wstDouble[y,d]:=wstMap;
       end;
    2: begin  {triples}
        wstTriple[wstYr,d]:=wstMap;
        if wstYr=-1 then for y:=0 to years_minus_1 do wstTriple[y,d]:=wstMap;
       end;
   end;
  end;
 SaveTimeFlag:=True;
end;

procedure TwsTargetDlg.SetButtons;
begin
  lblAvailableTSMsg.Visible := True;
  case wstAction of
    0:
    begin
      label17.Caption:='';
      label18.Caption:='';
      lblAvailableTSMsg.Visible := False;
    end;
    1:
    case wstMapType of
      0:
      begin
        wstHiCol:=clBlack;
        label17.Caption:='Available times:';
      end;
      1:
      begin
        wstHiCol:=clBlue;
        label17.Caption:='Doubles starting times:';
      end;
      2:
      begin
        wstHiCol:=clRed;
        label17.Caption:='Triples starting times:';
      end;
    end;
  end;
  label17.Font.Color:=wstHiCol;
  label18.Font.Color:=wstHiCol;
  AllBtn.Enabled:=wstAction>0;
  AttachBtn.Enabled:=wstAction>0;
  NoneBtn.Enabled:=wstAction>0;
  if wstAction=0 then
    label2.Caption:='Select target from -'
  else
    label2.Caption:='Attach target to -';
  Restore;
end;

procedure TwsTargetDlg.ActionSetClick(Sender: TObject);
begin
 wstAction:=ActionSet.ItemIndex;
 SetButtons;
end;

procedure TwsTargetDlg.ComboBox1Change(Sender: TObject);
begin
 wstYr:=ComboBox1.ItemIndex-1;
end;

procedure TwsTargetDlg.AllBtnClick(Sender: TObject);
var
 d,p:  integer;
begin
 Navail:=0;
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
    begin
     CheckPer[d,p]:=true;
     DrawTime(d,p);
     inc(Navail);
    end;
 ShowCount;
end;

procedure TwsTargetDlg.NoneBtnClick(Sender: TObject);
var
 d,p:  integer;
begin
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
    begin
     CheckPer[d,p]:=false;
     DrawTime(d,p);
    end;
 Navail:=0; ShowCount;
end;

end.
