unit Tettdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,TimeChartGlobals, Spin,
  XML.DISPLAY, XML.TEACHERS;

type
  TTeacherTTdlg = class(TForm)
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    ComboBox3: TComboBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    YearClass: TRadioGroup;
    DayOrWeek: TRadioGroup;
    CheckBox1: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    SelectDaysChkBox: TCheckBox;
    ttStartChkBox: TCheckBox;
    grbTeachers: TGroupBox;
    RadioButton6: TRadioButton;
    RadioButton5: TRadioButton;
    lblPrintPerPage: TLabel;
    spePrintPerPage: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelbuttonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure SaveSelection(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure DayOrWeekClick(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
  private
    procedure CheckRadioButtons;
  end;

var
  TeacherTTdlg: TTeacherTTdlg;

implementation
uses
 tcommon,DlgCommon,tcommon2, Teachtt;
var
 tmpsel:  tpTeData;
 duringload:    boolean;


{$R *.DFM}
procedure TTeacherTTdlg.CheckRadioButtons;
begin
 checkbox1.Enabled:=DayOrWeek.ItemIndex=1;
 combobox1.color:=clWindow;  combobox1.enabled:=false;
 combobox2.color:=clWindow;  combobox2.enabled:=false;
 listbox1.color:=clwindow; listbox2.color:=clwindow;
 listbox1.enabled:=false;  listbox2.enabled:=false;
 bitbtn1.enabled:=false; bitbtn2.enabled:=false;
 bitbtn3.enabled:=false; bitbtn4.enabled:=false;
 SelectDaysChkBox.enabled:=true;  ttStartChkBox.Enabled:=true;
 if DayOrWeek.ItemIndex=0 then  {daily}
  begin
   HiLiteCombo(combobox1);  HiLiteCombo(combobox2);
   SelectDaysChkBox.enabled:=false; ttStartChkBox.Enabled:=false;
  end;
 if radiobutton5.checked then
  begin
   HiLiteList(listbox1); HiLiteList(listbox2);
   bitbtn1.enabled:=true; bitbtn2.enabled:=true;
   bitbtn3.enabled:=true; bitbtn4.enabled:=true;
  end;
end;

procedure TTeacherTTdlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
 TeTtable.UpdateWin;
end;

procedure TTeacherTTdlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure TTeacherTTdlg.FormActivate(Sender: TObject);
begin
 case XML_DISPLAY.tettseltype of
  1: radiobutton6.checked:=true;
  2: radiobutton5.checked:=true;
 end;
 yearclass.ItemIndex:=XML_DISPLAY.tyr;
 DayOrWeek.ItemIndex:=winView[wnTeacherTt];
 checkRadiobuttons;
end;

procedure TTeacherTTdlg.RadioButton7Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeacherTTdlg.RadioButton8Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeacherTTdlg.SaveSelection(Sender: TObject);
var
  i: Integer;
  Old_ttWeekDaysFlg, Old_ttClockShowFlg: Boolean;
begin
  Old_ttWeekDaysFlg:=XML_DISPLAY.ttWeekDaysFlg;
  Old_ttClockShowFlg:=XML_DISPLAY.ttClockShowFlg;
  XML_DISPLAY.tyr:=yearclass.ItemIndex;
  winView[wnTeacherTt]:=DayOrWeek.ItemIndex;
  XML_DISPLAY.tettLoads:=checkbox1.Checked;
  if winView[wnTeacherTt]=0 then {daily}
  begin
    if BadDayCombo(XML_DISPLAY.tettlistvals[4],combobox1) then exit;
    if BadDayCombo(XML_DISPLAY.tettlistvals[5],combobox2) then exit;
    if XML_DISPLAY.tettlistvals[5] < XML_DISPLAY.tettlistvals[4] then swapint(XML_DISPLAY.tettlistvals[5],XML_DISPLAY.tettlistvals[4]);
  end
  else
  begin
    XML_DISPLAY.ttWeekDaysFlg := SelectDaysChkBox.Checked;
    XML_DISPLAY.ttClockShowFlg := ttStartChkBox.Checked;
    XML_DISPLAY.PWeek := spePrintPerPage.Value;
  end;
  for i := 0 to nmbrteachers do XML_DISPLAY.tettselection[i]:=tmpsel[i];
  Close;
  if (Old_ttWeekDaysFlg <> XML_DISPLAY.ttWeekDaysFlg) or (Old_ttClockShowFlg<>XML_DISPLAY.ttClockShowFlg) then
    updateAllwins
  else
    TeTtable.UpdateWin;
end;

procedure TTeacherTTdlg.ComboBox3Change(Sender: TObject);
begin
 if duringload then exit;
 XML_DISPLAY.tettlistvals[3]:=findFaculty(combobox3.text,label12);
end;

procedure TTeacherTTdlg.ComboBox3Enter(Sender: TObject);
begin
 TeacherTTdlg.ComboBox3Change(Sender);
 combobox3.selectall;
end;

procedure TTeacherTTdlg.ComboBox1Change(Sender: TObject);
begin
 if duringload then exit;
 XML_DISPLAY.tettlistvals[4]:=finddayMsg(combobox1.text,label12);
end;

procedure TTeacherTTdlg.ComboBox1Enter(Sender: TObject);
begin
 TeacherTTdlg.ComboBox1Change(Sender);
 ComboBox1.selectall;
end;

procedure TTeacherTTdlg.ComboBox2Change(Sender: TObject);
begin
 if duringload then exit;
 XML_DISPLAY.tettlistvals[5]:=finddayMsg(combobox2.text,label12);
end;

procedure TTeacherTTdlg.ComboBox2Enter(Sender: TObject);
begin
 TeacherTTdlg.ComboBox2Change(Sender);
 ComboBox2.selectall;
end;

procedure TTeacherTTdlg.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  duringload := True;
  fillchar(tmpsel,sizeof(tmpsel),chr(0));
  checkbox1.Checked:=XML_DISPLAY.tettLoads;
  FillComboDays(false,ComboBox1);
  if XML_DISPLAY.tettlistvals[4]>-1 then
   ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(day[XML_DISPLAY.tettlistvals[4]])
  else
   ComboBox1.ItemIndex := -1;
  FillComboDays(false,ComboBox2);
  if XML_DISPLAY.tettlistvals[5]>-1 then
   ComboBox2.ItemIndex := ComboBox2.Items.IndexOf(day[XML_DISPLAY.tettlistvals[5]])
  else
    ComboBox2.ItemIndex := -1;
  FillComboFaculty(False, combobox3);
  if XML_DISPLAY.tettlistvals[3]>0 then
    ComboBox3.ItemIndex := ComboBox3.Items.IndexOf(facName[XML_DISPLAY.tettlistvals[3]])
  else
    ComboBox3.ItemIndex := -1;
  SelectDaysChkBox.Checked := XML_DISPLAY.ttWeekDaysFlg;
  ttStartChkBox.Checked := XML_DISPLAY.ttClockShowFlg;
  spePrintPerPage.Value := XML_DISPLAY.PWeek;
  listbox1.clear;
  for i:=1 to codeCount[1] do
  listbox1.items.add(XML_TEACHERS.tecode[codepoint[i,1],0]);
  label3.caption:=inttostr(listbox1.items.count);

  listbox2.Clear;
  {add saved selection here}

  rangeCheckCodeSels(XML_DISPLAY.tettselection,1);
  if XML_DISPLAY.tettselection[0] > 0 then
    for i := 0 to XML_DISPLAY.tettselection[0] do
    begin
      tmpsel[i] := XML_DISPLAY.tettselection[i];
      if i>0 then listbox2.items.Add(XML_TEACHERS.tecode[tmpsel[i],0]);
    end;
  label8.Caption := IntToStr(listbox2.Items.Count);

  duringload := False;
end;

procedure TTeacherTTdlg.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpSel,listbox2,label8);
end;

procedure TTeacherTTdlg.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpSel,listbox2,label8);
end;

procedure TTeacherTTdlg.BitBtn3Click(Sender: TObject);
begin
 MoveOnSubList(tmpSel,listbox1,listbox2,label8,1);
end;

procedure TTeacherTTdlg.BitBtn4Click(Sender: TObject);
begin
 FillSubList(tmpSel,listbox1,listbox2,label8,1);
end;

procedure TTeacherTTdlg.RadioButton6Click(Sender: TObject);
begin
 XML_DISPLAY.tettseltype:=1;
 checkRadiobuttons;
end;

procedure TTeacherTTdlg.RadioButton5Click(Sender: TObject);
begin
 XML_DISPLAY.tettseltype:=2;
 checkRadiobuttons;
end;

procedure TTeacherTTdlg.DayOrWeekClick(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeacherTTdlg.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpSel,ListBox2);
end;

procedure TTeacherTTdlg.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpSel,ListBox2);
end;

end.
