unit Cnfgyear;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals,GlobalToTcAndTcextra;

type
  TConfigYeardlg = class(TForm)
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    edtNoOfYears: TEdit;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure SaveYears(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure edtNoOfYearsKeyPress(Sender: TObject; var Key: Char);
    procedure UpdateNoOfYears(Sender: TObject);
  private
    function ValidateData: Boolean;
  end;

var
  ConfigYeardlg: TConfigYeardlg;

implementation

uses
  tcommon,DlgCommon,TTundo, tcommon2, main, uAMGConst;

{$R *.DFM}
var
 edit2:   array[1..nmbrYears] of tedit;
 label9:  array[1..nmbrYears] of tlabel;
 usingResources:                bool;

procedure TConfigYeardlg.FormCreate(Sender: TObject);
var
 i,v1,v2:   integer;
const
 xgap=20;
 ygap=5;
begin
 for i:=1 to nmbrYears do
 begin
  Application.ProcessMessages;
  edit2[i]:=tedit.create(application);
  edit2[i].hint:='Enter year name';
  edit2[i].showhint:=true;
  edit2[i].maxlength:=szYearname;
  edit2[i].OnChange := UpdateNoOfYears;
  label9[i]:=tlabel.create(application);
  edit2[i].width:=125; edit2[i].height:=20;
  edit2[i].parent:=groupbox1;
  label9[i].parent:=groupbox1;
  //edit2[i].text:=inttostr(i);
  label9[i].caption:='&'+inttostr(i);
  label9[i].focuscontrol:=edit2[i];
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

function TConfigYeardlg.ValidateData: Boolean;
var
  i: Integer;
  j: Integer;
  lYear: string;
  lYearCount: Integer;
begin
  Result := True;
  lYearCount := 0;
  for i := NmbrYears downto 1 do
  begin
    lYear := UpperCase(Trim(Edit2[i].Text));
    if lYear <> '' then
    begin
      Inc(lYearCount);
      for j:= i downto 1 do
        if (j > 1) and (lYear = UpperCase(Trim(Edit2[j -1].Text))) then
        begin
          MessageDlg(YearTitle + ' ' + lYear + ' is duplicate. Try another code.', mtError, [mbOK], 0);
          Edit2[i].SelectAll;
          Edit2[i].SetFocus;
          Result := False;
          Exit;
        end;
    end;
  end;   //for
  if lYearCount <> StrToInt(Trim(edtNoOfYears.Text)) then
  begin
    MessageDlg(Format(AMG_INVALID_NUMOF, [YearTitle]), mtError, [mbOK], 0);
    edtNoOfYears.SelectAll;
    edtNoOfYears.SetFocus;
    Result := False;
    Exit;
  end;
end;

procedure TConfigYeardlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
 i:       integer;
begin
 action:=caFree;

 if usingResources then   {can call close even after closeed it seems}
 begin
  usingResources:=false;
  configyeardlg.hide; {prevent seeing controls beeing removed -slows things down a lot}
  for i:=1 to nmbrYears do
  begin
   edit2[i].free;
   label9[i].free;
  end;
 end;
end;

procedure TConfigYeardlg.FormActivate(Sender: TObject);
var
 i:      integer;
begin
  for i := 1 to nmbrYears do
    Edit2[i].Text := IntToStr(i);  // initialise them

  edtNoOfYears.MaxLength := 2;   {15}
  ConfigYeardlg.caption:='Configure '+yeartitle+'s';
  edtNoOfYears.Text := IntToStr(years);
  for i:=1 to nmbryears do
    if i<=years then edit2[i].text:=trim(yearname[i-1])
    else edit2[i].text:='';

  if yearshort='Yr' then radiobutton1.checked:=true else radiobutton2.checked:=true;
  if edtNoOfYears.Visible and edtNoOfYears.Enabled then
    edtNoOfYears.SetFocus;
end;

procedure TConfigYeardlg.SaveYears(Sender: TObject);
var
 i: Integer;
 newyears,newyr: Smallint;
 msg: string;
begin
  if ValidateData then
  begin
    if InvalidEntry(newyears,1,nmbrYears,'number of '+yeartitle+'s', edtNoOfYears) then exit;
    for i:=1 to newyears do if BlankEntry(yeartitle,edit2[i]) then exit;
    if newyears<years then
    begin
      Msg:='Reducing '+yeartitle+'s will lose entries above the current '
       + yearshort+yearname[newyears-1]+'.'+cr+
       'There is no Undo from this operation.  Continue?';
     if messagedlg(Msg,mtWarning,[mbyes,mbno],0)<>mrYes then exit;
    end;
    CheckResize(newYears,Days,periods);

    {still here, then assign}
    saveTimeFlag:=true;
    newyr:=newyears-1;
    for i:=0 to newyr do
    YearName[i]:=trim(edit2[i+1].text);
    if radiobutton1.checked and (yearshort<>'Yr') then {years}
    begin
      yeartitle:='Year';
      yearshort:='Yr';
      yearFormToggle;
    end;
    hy := Years;  // update the home position for the year
    if radiobutton2.checked and (yearshort<>'Fm') then{forms}
    begin
      yeartitle:='Form';
      yearshort:='Fm';
      yearFormToggle;
    end;
    ConfigureTimetable(days,periods,newyears,ttmainformat);
    initTtUndoStack;

    fwYearname:=getYearnameFontWidths(mainform.canvas);
    UpdateAllWins;
    Close;
  end;
end;

procedure TConfigYeardlg.UpdateNoOfYears(Sender: TObject);
var
  lCount: Integer;
  i: Integer;
begin
  lCount := 0;
  for i := 1 to NmbrYears do
    if Trim(edit2[i].Text) <> ''  then
      Inc(lCount);
  edtNoOfYears.Text := IntToStr(lCount);
  Application.ProcessMessages
end;

procedure TConfigYeardlg.RadioButton2Click(Sender: TObject);
begin
 label1.caption:='Forms:';
 label3.caption:='Form Names:';
 ConfigYeardlg.caption:='Configure Forms';
end;

procedure TConfigYeardlg.RadioButton1Click(Sender: TObject);
begin
 label1.caption:='Years:';
 label3.caption:='Year Names:';
 ConfigYeardlg.caption:='Configure Years';
end;

procedure TConfigYeardlg.edtNoOfYearsKeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

end.

