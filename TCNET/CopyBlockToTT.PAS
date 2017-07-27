unit CopyBlockToTT;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,Dialogs,TimeChartGlobals, GlobalToTcAndTcextra, XML.DISPLAY;

type
  TFrmCopyBlockToTT = class(TForm)
    CopyFrom: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    CopyTo: TBitBtn;
    ComboBox2: TComboBox;
    ComboBox1: TComboBox;
    Label2: TLabel;
    edtNoOfBlockToCopy: TEdit;
    Label1: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure CopyToClick(Sender: TObject);
    procedure CopyFromClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    FCopyYear: Integer;
    FCopyDay:  Integer;
    FBlocksToCopy: Integer;
    procedure CheckYear;
    procedure CheckDay;
    function BlockMax: Integer;
  end;

var
  FrmCopyBlockToTT: TFrmCopyBlockToTT;

implementation

uses
  tcommon,block1,subyr,tcommon2, StCommon;

{$R *.DFM}

procedure TFrmCopyBlockToTT.FormActivate(Sender: TObject);
begin
  label7.caption:=yeartitle+' '+yearname[FCopyYear];
  label1.caption:='Copy '+yeartitle;
  label4.caption:=inttostr(subsinblock);
  ComboBox2.text:=Day[0];
  label6.caption:=Dayname[0];
  combobox1.text:=yearname[0];
  label7.caption:=yearname[0];
  if subsinblock=0 then CopyTo.Enabled:=False;
  ComboBox2.SetFocus;
  ComboBox2.SelectAll;
  FCopyDay := 0;
  FCopyYear := 0;
  if GOSrecipe.NumSteps=1 then {only one selection}
    if ((GOSrecipe.steps[1].slct=1) {year selection}  and (GOSrecipe.steps[1].meth=0)) then {new group}
      FCopyYear := findyear(GOSrecipe.steps[1].e1);
end;

procedure TFrmCopyBlockToTT.CheckYear;
var
  found: Integer;
begin
  found:=findyear(ComboBox1.text);
  if found <> FCopyYear then
    if found = -1 then label7.caption:='(Enter Year)'
       else label7.Caption:= yearname[found];
  FCopyYear := Found;
end;

procedure TFrmCopyBlockToTT.CheckDay;
var
  Found: Integer;
begin
  found:=findDay(ComboBox2.Text);
  if found <> FCopyDay then
    if found=-1 then FrmCopyBlockToTT.label6.caption:='(Enter Day)'
    else Label6.Caption := Dayname[found];
  FCopyDay := Found;
end;

function TFrmCopyBlockToTT.BlockMax: Integer;
var
  i,max: Integer;
begin
  max:=0;
  for i := FCopyDay to days-1 do
    Inc(max,Tlimit[i]);
  if max > FBlocksToCopy then max := FBlocksToCopy;
  Result := max;
end;

procedure TFrmCopyBlockToTT.CopyToClick(Sender: TObject);
var
  msg:        string;
  leveluse,count:   integer;
  i,j,d,p:        integer;
begin
  FBlocksToCopy := strtointdef(edtNoOfBlockToCopy.Text, XML_DISPLAY.blocknum);
  if ((FBlocksToCopy < 1) or (FBlocksToCopy > XML_DISPLAY.blocknum)) then
  begin
  msg:='Enter number of blocks to copy';
  messagedlg(msg,mtError,[mbOK],0);
  edtNoOfBlockToCopy.SetFocus;
  edtNoOfBlockToCopy.SelectAll;
  exit;
  end;
  if FCopyDay = -1 then
  begin
    msg:='Enter timetable day to copy to';
    messagedlg(msg,mtError,[mbOK],0);
    FrmCopyBlockToTT.ComboBox2.setfocus;
    FrmCopyBlockToTT.ComboBox2.SelectAll;
    Exit;
  end;
  leveluse:=0;
  for i:=1 to FBlocksToCopy do
   begin
    count:=0;
    if Sheet[i,0]>0 then
     for j:=1 to Sheet[i,0] do
       if Sheet[i,j]>0 then inc(count);
    if count>leveluse then leveluse:=count;
   end;
  if leveluse > level[FCopyYear] then level[FCopyYear] := leveluse;
  d := FCopyDay;
  p:=1;
  for i:=1 to blockmax do
   begin
     for j:=1 to leveluse do
       begin
         (FNT(d,p-1, FCopyYear, j, 0))^:=Sheet[i,j];
         FNputBlockNumber(d,p-1, FCopyYear, j, i); //set block number as i
       end; {j}
       inc(p);
       if p>Tlimit[d] then
         begin
           inc(d);
           p:=1;
         end;
   end; {i}
  if SaveStudFlag then SaveAllStudentYears;

  UpdateTimeTableWins;
  SaveTimeFlag:=True;
  Close;
end;

procedure TFrmCopyBlockToTT.CopyFromClick(Sender: TObject);
var
  msg:             string;
  leveluse,count:  integer;
  i,j,d,p:         integer;
  su:              integer;
begin
  FBlocksToCopy := StrToIntDef(edtNoOfBlockToCopy.Text, XML_DISPLAY.blocknum);
  if ((FBlocksToCopy < 1) or (FBlocksToCopy > XML_DISPLAY.blocknum)) then
  begin
    msg:='Enter number of blocks to copy';
    messagedlg(msg,mtError,[mbOK],0);
    edtNoOfBlockToCopy.SetFocus;
    edtNoOfBlockToCopy.SelectAll;
    Exit;
  end;
  if FCopyDay = -1 then
  begin
    msg:='Enter timetable day to copy from';
    messagedlg(msg,mtError,[mbOK],0);
    ComboBox2.SetFocus;
    ComboBox2.SelectAll;
    Exit;
  end;
  leveluse := 0;
  d := FCopyDay;
  p:=1;
  for i:=1 to blockmax do
  begin
    count:=0;
    for j:=1 to level[FCopyYear] do
    begin
      su:=word((FNT(d,p-1, FCopyYear, j, 0))^);
      if (su>0) and (su<=NumCodes[0]) then inc(count);
    end;
    if count>leveluse then leveluse:=count;
   end;
  if leveluse=0 then
  begin
    msg:='No subjects to copy from '+ dayname[FCopyDay];
    MessageDlg(msg,mtError,[mbOK],0);
    Close;
    Exit;
  end;
  wipeBlocks;
  if leveluse>XML_DISPLAY.blocklevel then XML_DISPLAY.blocklevel:=leveluse;
  d := FCopyDay;
  p:=1;
  for i:=1 to blockmax do
  begin
    count := 0;
    for j := 1 to level[FCopyYear] do
    begin
      su := word((FNT(d,p-1, FCopyYear, j, 0))^);
      if (su>0) and (su<=NumCodes[0]) then
  // add check to prevent duplicate subs entered into same block
        if not(subISAlreadyinBlock(su,i)) then
        begin
          Inc(count);
          Sheet[i,count]:=su;
          Inc(subsinblock);
        end;
      end; {j}
      Sheet[i,0]:=count;
      inc(p);
      if p>Tlimit[d] then
      begin
        inc(d);
        p:=1;
      end;
   end; {i}
  Lblock:=1;
  Hblock:= FBlocksToCopy;
  settop;
  BlockFile := '';
  BlockLoad := 2;
  blockday:=dayname[FCopyDay];
  /// force recalc
  updateBlockWindow;
  SaveBlockFlag:=True;
  Close;
end;

procedure TFrmCopyBlockToTT.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FCopyYear := 0;
  topcentre(self);
  edtNoOfBlockToCopy.Text := IntToStr(XML_DISPLAY.blocknum);
  combobox2.clear;
  ComboBox2.DropDownCount:=nmbrDays;
  for i := 0 to (days-1) do
   combobox2.items.add(day[i]);
  combobox1.clear;
  ComboBox1.DropDownCount:=nmbryears;
  for i := 0 to years_minus_1 do
    ComboBox1.items.add(yearname[i]);
  edtNoOfBlockToCopy.Hint := 'Enter a number (1-' + inttostr(XML_DISPLAY.blocknum)+')';
end;

procedure TFrmCopyBlockToTT.ComboBox2Change(Sender: TObject);
begin
  CheckDay;
end;

procedure TFrmCopyBlockToTT.ComboBox1Change(Sender: TObject);
begin
  CheckYear;
end;

end.
