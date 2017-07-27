unit Rottdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,TimeChartGlobals, Spin,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS;

type
  TRoomTTdlg = class(TForm)
    GroupBox3: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    YearClass: TRadioGroup;
    DayOrWeek: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    SelectDaysChkBox: TCheckBox;
    ttStartChkBox: TCheckBox;
    grbRooms: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    lblPrintPerPage: TLabel;
    spePrintPerPage: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelbuttonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SaveSelection(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure DayOrWeekClick(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
  private
    procedure checkRadiobuttons;
  end;

var
  RoomTTdlg: TRoomTTdlg;

implementation

uses
  tcommon, DlgCommon, tcommon2, Roomtt;
var
 tmpsel:  tpTeData;
 duringload:    boolean;

{$R *.DFM}

procedure TRoomTTdlg.checkRadiobuttons;
begin
 combobox1.color:=clWindow;  combobox1.enabled:=false;
 combobox2.color:=clWindow;  combobox2.enabled:=false;
 listbox1.color:=clwindow; listbox2.color:=clwindow;
 listbox1.enabled:=false;  listbox2.enabled:=false;
 bitbtn1.enabled:=false; bitbtn2.enabled:=false;
 bitbtn3.enabled:=false; bitbtn4.enabled:=false;
 SelectDaysChkBox.enabled:=true; ttStartChkBox.Enabled:=true;

 if DayOrWeek.ItemIndex=0 then  {daily}
  begin
   HiLiteCombo(combobox1);  HiLiteCombo(combobox2);
   SelectDaysChkBox.enabled:=false; ttStartChkBox.Enabled:=false;
  end;
 if RadioButton2.checked then
  begin
   HiLiteList(listbox1); HiLiteList(listbox2);
   bitbtn1.enabled:=true; bitbtn2.enabled:=true;
   bitbtn3.enabled:=true; bitbtn4.enabled:=true;
  end;
end;

procedure TRoomTTdlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TRoomTTdlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure TRoomTTdlg.FormActivate(Sender: TObject);
begin
 case XML_DISPLAY.rottseltype of
  1: RadioButton1.Checked := True;
  2: RadioButton2.Checked := True;
 end;
 yearclass.ItemIndex := XML_DISPLAY.tyr;
 DayOrWeek.ItemIndex := winView[wnRoomTt];
 checkRadiobuttons;
end;

procedure TRoomTTdlg.SaveSelection(Sender: TObject);
var
  i: Integer;
  Old_ttWeekDaysFlg, Old_ttClockShowFlg: Boolean;
begin
  Old_ttWeekDaysFlg:=XML_DISPLAY.ttWeekDaysFlg;
  Old_ttClockShowFlg:=XML_DISPLAY.ttClockShowFlg;
  XML_DISPLAY.tyr:=yearclass.ItemIndex;
  winView[wnRoomTt]:=DayOrWeek.ItemIndex;
  if winView[wnRoomTt]=0 then {daily}
  begin
    if BadDayCombo(XML_DISPLAY.rottlistvals[4],combobox1) then
        exit;
    if BadDayCombo(XML_DISPLAY.rottlistvals[5],combobox2) then
        exit;
    if XML_DISPLAY.rottlistvals[5] < XML_DISPLAY.rottlistvals[4] then
        swapint(XML_DISPLAY.rottlistvals[5],XML_DISPLAY.rottlistvals[4]);
    if XML_DISPLAY.rottlistvals[5] > days-1 then
        XML_DISPLAY.rottlistvals[5]:=days-1;
  end
  else
  begin
    XML_DISPLAY.ttWeekDaysFlg := SelectDaysChkBox.Checked;
    XML_DISPLAY.ttClockShowFlg := ttStartChkBox.Checked;
    XML_DISPLAY.PWeek := spePrintPerPage.Value;
  end;
  for i:=0 to nmbrteachers do
    XML_DISPLAY.rottselection[i]:=tmpsel[i];
  Close;
  if (Old_ttWeekDaysFlg<>XML_DISPLAY.ttWeekDaysFlg) or (Old_ttClockShowFlg<>XML_DISPLAY.ttClockShowFlg) then
    updateAllwins
  else
    RoTtable.UpdateWin;
end;

procedure TRoomTTdlg.ComboBox1Change(Sender: TObject);
begin
 if duringload then
  exit;
 XML_DISPLAY.rottlistvals[4]:=finddayMsg(combobox1.text,label12);
end;

procedure TRoomTTdlg.ComboBox2Change(Sender: TObject);
begin
 if duringload then
    exit;
 XML_DISPLAY.rottlistvals[5]:=finddayMsg(combobox2.text,label12);
end;

procedure TRoomTTdlg.ComboBox1Enter(Sender: TObject);
begin
 RoomTTdlg.ComboBox1Change(Sender);
 ComboBox1.selectall;
end;

procedure TRoomTTdlg.ComboBox2Enter(Sender: TObject);
begin
 RoomTTdlg.ComboBox2Change(Sender);
 ComboBox2.selectall;
end;

procedure TRoomTTdlg.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  duringload := True;
  fillchar(tmpsel,sizeof(tmpsel),chr(0));
  FillComboDays(false,ComboBox1);
  if XML_DISPLAY.rottlistvals[4]>-1 then
    ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(day[XML_DISPLAY.rottlistvals[4]])
  else
    ComboBox1.ItemIndex := -1;
  FillComboDays(false,ComboBox2);
  if XML_DISPLAY.rottlistvals[5]>-1 then
    ComboBox2.ItemIndex := ComboBox2.Items.IndexOf(day[XML_DISPLAY.rottlistvals[5]])
  else
    ComboBox2.ItemIndex := -1;
  FillComboFaculty(false,combobox3);
  if XML_DISPLAY.rottlistvals[3]>0 then
    ComboBox3.ItemIndex := ComboBox3.Items.IndexOf(facName[XML_DISPLAY.rottlistvals[3]])
  else
    ComboBox3.ItemIndex := -1;
  SelectDaysChkBox.Checked := XML_DISPLAY.ttWeekDaysFlg;
  ttStartChkBox.Checked := XML_DISPLAY.ttClockShowFlg;
  spePrintPerPage.Value := XML_DISPLAY.PWeek;
  listbox1.Clear;
  for i := 1 to codeCount[2] do
    listbox1.items.add(XML_TEACHERS.tecode[codepoint[i,2],1]);
  label1.caption:=inttostr(listbox1.items.count);
  listbox2.clear;
  {add saved selection here}

  rangeCheckCodeSels(XML_DISPLAY.rottselection,2);
  if XML_DISPLAY.rottselection[0] > 0 then
    for i:=0 to XML_DISPLAY.rottselection[0] do
    begin
      tmpsel[i] := XML_DISPLAY.rottselection[i];
      if i>0 then listbox2.Items.Add(XML_TEACHERS.tecode[tmpsel[i],1]);
    end;
  label3.Caption := IntToStr(listbox2.Items.Count);
  duringload := False;
end;

procedure TRoomTTdlg.ComboBox3Change(Sender: TObject);
begin
 if duringload then exit;
 XML_DISPLAY.rottlistvals[3]:=findFaculty(combobox3.text,label12);
end;

procedure TRoomTTdlg.ComboBox3Enter(Sender: TObject);
begin
 RoomTTdlg.ComboBox3Change(Sender);
 combobox3.selectall;
end;

procedure TRoomTTdlg.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpSel,listbox2,label3);
end;

procedure TRoomTTdlg.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpSel,listbox2,label3);
end;

procedure TRoomTTdlg.BitBtn3Click(Sender: TObject);
begin
 MoveOnSubList(tmpSel,listbox1,listbox2,label3,2);
end;

procedure TRoomTTdlg.BitBtn4Click(Sender: TObject);
begin
 FillSubList(tmpSel,listbox1,listbox2,label3,2);
end;

procedure TRoomTTdlg.RadioButton1Click(Sender: TObject);
begin
 XML_DISPLAY.rottseltype:=1;
 checkRadiobuttons;
end;

procedure TRoomTTdlg.DayOrWeekClick(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TRoomTTdlg.RadioButton2Click(Sender: TObject);
begin
 XML_DISPLAY.rottseltype:=2;
 checkRadiobuttons;
end;

procedure TRoomTTdlg.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpSel,ListBox2);
end;

procedure TRoomTTdlg.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpSel,ListBox2);
end;

end.
