unit Cnfgday;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, GlobalToTcAndTcextra, XML.DISPLAY;

type
  Tconfigdaydlg = class(TForm)
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    edtNoOfDays: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure updateClick(Sender: TObject);
    procedure edtNoOfDaysKeyPress(Sender: TObject; var Key: Char);
    procedure UpdateNoOfDays(Sender: TObject);
  private
    function ValidateData: Boolean;
  end;

var
  configdaydlg: Tconfigdaydlg;

implementation

uses
  tcommon, DlgCommon, TTundo, tcommon2, Main, uAMGConst;

{$R *.DFM}
var
 edit2:   array[1..nmbrDays] of tedit;
 label9:  array[1..nmbrDays] of tlabel;
 usingResources:                bool;

procedure Tconfigdaydlg.FormCreate(Sender: TObject);
var
 i:       integer;
 v1,v2:   integer;
const
 xgap=20;
 ygap=5;
begin
 for i:=1 to nmbrDays do
 begin
  edit2[i]:=tedit.create(application);
  edit2[i].maxlength:=szDayname;
  label9[i]:=tlabel.create(application);
  edit2[i].width:=125;   edit2[i].height:=20;
  edit2[i].parent:=groupbox1;
  label9[i].parent:=groupbox1;
  edit2[i].text:=inttostr(i);
  edit2[i].hint:='Enter name for day '+inttostr(i);
  edit2[i].showhint:=true;
  edit2[i].OnChange := UpdateNoOfDays;
  label9[i].caption:='&'+inttostr(i);
  label9[i].FocusControl:=edit2[i];
  if i=1 then
  begin
   edit2[1].left:=label3.left+xgap;
   edit2[1].top:=label3.top+label3.height+ygap;
  end
  else
   begin
    v1:=i mod 4;  v2:=(i-1) div 4;
    if v1=0 then v1:=3 else v1:=v1-1;

    edit2[i].left:=edit2[1].left+v1*(edit2[1].width+xgap);
    edit2[i].top:=edit2[1].top+v2*(edit2[1].height+ygap);
   end;
  label9[i].top:=edit2[i].top+(edit2[i].height div 2)-(label9[i].height div 2); {vert. centres. aligned}
  label9[i].left:=edit2[i].left-(label9[i].width+(label9[1].width div 2));

 end;
 usingResources:=true;
end;

procedure Tconfigdaydlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
 i:       integer;
begin
 action:=caFree;
 if usingResources then   {can call close even after closeed it seems}
 begin
  usingResources:=false;
  configdaydlg.hide; {prevent seeing controls beeing removed -slows things down a lot}
  for i:=1 to nmbrDays do
  begin
   edit2[i].free;
   label9[i].free;
  end;
 end;

end;

procedure Tconfigdaydlg.FormActivate(Sender: TObject);
var
  i: Integer;
begin
  edtNoOfDays.MaxLength := 2;   {10}
  edtNoOfDays.Text := IntToStr(days);
  for i:=1 to NmbrDays do
  if i<=days then
   edit2[i].Text := Trim(dayname[i-1])
  else
   edit2[i].Text := '';

  if edtNoOfDays.Visible and edtNoOfDays.Enabled then
    edtNoOfDays.SetFocus;
end;

procedure Tconfigdaydlg.updateClick(Sender: TObject);
var
 newdays,i,d,p,dcopy:       smallint;
 msg: string;
begin
  if ValidateData then
  begin
    if InvalidEntry(newdays, 2, nmbrDays,'number of days', edtNoOfDays) then Exit;
    for i:=1 to newdays do if BlankEntry('Day',edit2[i]) then Exit;
    if newdays<days then
    begin
      Msg:='Reducing days will lose entries after the current '
       + dayname[newdays-1]+'.'+cr+
       'There is no Undo from this operation.  Continue?';
      if MessageDlg(Msg, mtWarning, [mbyes,mbno], 0) <> mrYes then Exit;
    end;

    if newdays>days then
    for d:=days to newdays-1 do
    begin
      if newdays=(2*days) then dcopy:=d-days {copy first half into second}
      else dcopy:=days-1; {copy last day}
      tlimit[d]:=tlimit[dcopy];
      for p:=0 to tlimit[d]-1 do {copy values}
      begin
        TimeSlotName[d,p]:=TimeSlotName[dcopy,p];
        tsCode[d,p]:=tsCode[dcopy,p];
        tsAllot[d,p]:=tsAllot[dcopy,p];
        tsStart[d,p]:=tsStart[dcopy,p];
        tsStart[d,p]:=tsStart[dcopy,p];
        XML_DISPLAY.tsOn[d,p]:=XML_DISPLAY.tsOn[dcopy,p];
      end;
    end; {for d}

    CheckResize(years,newdays,periods);
    saveTimeFlag := True;
    for i:=1 to newdays do DayName[i-1] := Trim(edit2[i].Text);
    ConfigureTimetable(newdays, periods, years, ttmainformat);
    initTtUndoStack;
    fwDayname := getDaynameFontWidths(MainForm.Canvas);
    UpdateAllWins;
    Close;
  end;
end;

procedure Tconfigdaydlg.UpdateNoOfDays(Sender: TObject);
var
  lCount: Integer;
  i: Integer;
begin
  lCount := 0;
  for i := 1 to nmbrDays do
    if Trim(edit2[i].Text) <> ''  then
      Inc(lCount);
  edtNoOfDays.Text := IntToStr(lCount);
  Application.ProcessMessages
end;

function Tconfigdaydlg.ValidateData: Boolean;
var
  i: Integer;
  j: Integer;
  lDay: string;
  lDayCount: Integer;
begin
  Result := True;
  lDayCount := 0;
  for i := nmbrDays downto 1 do
  begin
    lDay := Trim(Edit2[i].Text);
    if lDay <> '' then
    begin
      Inc(lDayCount);
      for j:= i - 1 downto 1 do
        if lDay = Trim(Edit2[j].Text) then
        begin
          MessageDlg('Day ' + lDay + ' is duplicate. Try another code.', mtError, [mbOK], 0);
          Edit2[i].SelectAll;
          Edit2[i].SetFocus;
          Result := False;
          Exit;
        end;
    end;
  end;   //for
  if lDayCount <> StrToInt(Trim(edtNoOfDays.Text)) then
  begin
    MessageDlg(Format(AMG_INVALID_NUMOF, [YearTitle]), mtError, [mbOK], 0);
    edtNoOfDays.SelectAll;
    edtNoOfDays.SetFocus;
    Result := False;
    Exit;
  end;
end;

procedure Tconfigdaydlg.edtNoOfDaysKeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

end.
