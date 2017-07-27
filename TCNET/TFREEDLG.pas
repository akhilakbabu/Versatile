unit Tfreedlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, TimeChartGlobals,GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  TTeachersfreedlg = class(TForm)
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label12: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label1: TLabel;
    ComboBox3: TComboBox;
    Label8: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    rbYear: TRadioButton;
    cmbYear: TComboBox;
    chbMatchAllYears: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CancelbuttonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKbuttonClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
    procedure rbYearClick(Sender: TObject);
  private
    procedure FillTimeSlots;
    procedure CheckRadioButtons;
  end;

var
  Teachersfreedlg: TTeachersfreedlg;

implementation
uses tcommon,DlgCommon,tcommon2;
{$R *.DFM}

var
 tmpsel:  tpTeData;
 duringload: bool;
 UseDay: smallint;

procedure TTeachersfreedlg.CheckRadioButtons;
begin
 if duringload then exit;
 combobox1.color:=clWindow; combobox1.enabled:=false;
 combobox2.color:=clWindow; combobox2.enabled:=false;
 combobox3.color:=clWindow; combobox3.enabled:=false;
 listbox1.color:=clWindow;  listbox2.color:=clWindow;
 listbox1.enabled:=false; listbox2.enabled:=false;
 bitbtn1.enabled:=false; bitbtn2.enabled:=false;
 bitbtn3.enabled:=false; bitbtn4.enabled:=false;
 radiobutton6.enabled:=radiobutton3.checked;
 radiobutton7.enabled:=radiobutton3.checked;
 rbYear.Enabled := radiobutton3.Checked;

 if radiobutton1.checked then
  begin
   combobox3.enabled:=true;
   HiLiteCombo(combobox2);
   HiLiteCombo(combobox1);
  end;

 if radiobutton2.checked then HiLiteCombo(combobox1);

 if radiobutton3.checked then
  begin
   HiLiteCombo(combobox2);
   if radiobutton7.checked then
    begin
     HiLiteList(listbox1);
     HiLiteList(listbox2);
     bitbtn1.enabled:=true; bitbtn2.enabled:=true;
     bitbtn3.enabled:=true; bitbtn4.enabled:=true;
     listbox1.setfocus;
    end;
  end;

  cmbYear.Enabled := (rbYear.Checked) and (radiobutton3.Checked);
  chbMatchAllYears.Enabled := (rbYear.Checked) and (radiobutton3.Checked);
end;


procedure TTeachersfreedlg.FillTimeSlots;
var
 j:     integer;
begin
 if NumDayGroups=1 then j:=0 else j:=Combobox1.ItemIndex-1;
 if j<0 then j:=0;
 FillComboTimeSlots(true,j,combobox3);
end;


procedure TTeachersfreedlg.FormCreate(Sender: TObject);
var
 i: integer;

 procedure FillComboYears;
 var
   j: integer;
 begin
   cmbYear.maxlength:=szYearname;

   cmbYear.clear;
   cmbYear.items.add('All');
   for j:=0 to years_minus_1 do cmbYear.items.add(yearname[j]);
   cmbYear.ItemIndex := 0;
 end;

begin
 duringload:=true;   label12.caption:='';
 UseDay:=XML_DISPLAY.TeachersFreeDay;
 If UseDay<0 then UseDay:=0;
 XML_DISPLAY.teachersfreeshow1:=winView[wnTeFree]+1;
 FillComboDays(true,ComboBox1);

 ComboBox3.DropDownCount:=periods+1;
 FillComboFaculty(false,combobox2);
 FillComboYears;
 listbox1.clear;
 for i:=1 to codeCount[1] do listbox1.items.add(XML_TEACHERS.tecode[codepoint[i,1],0]);
 listbox2.clear;
 {add saved selection here}
 rangeCheckCodeSels(XML_DISPLAY.TeFreeSelect,1);
 for i:=0 to nmbrteachers do
    tmpSel[i]:=XML_DISPLAY.TeFreeSelect[i];
 case XML_DISPLAY.teachersfreeshow1 of
  1: radiobutton1.checked:=true;
  2: radiobutton2.checked:=true;
  3: radiobutton3.checked:=true;
 end;
 case XML_DISPLAY.teachersfreeshow2 of
  1: radiobutton6.checked:=true;
  2: radiobutton7.checked:=true;
  3: begin
       rbYear.Checked := true;
       cmbYear.ItemIndex := XML_DISPLAY.teFreeYear+1;
       chbMatchAllYears.Enabled := true;
       chbMatchAllYears.Checked := XML_DISPLAY.MatchAllYears;
     end;
 end;
 duringload:=false;
end;

procedure TTeachersfreedlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure TTeachersfreedlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TTeachersfreedlg.OKbuttonClick(Sender: TObject);
var
i:  integer;
begin
 if combobox1.enabled then
  if XML_DISPLAY.teachersfreeday=-2 then
  begin
   ComboMsg('Check day selected',ComboBox1);
   exit;
  end;
 if combobox3.enabled then
  if XML_DISPLAY.TeFreePeriod<0 then
  begin
   ComboMsg('Check time slot selected',ComboBox3);
   exit;
  end;
 for i:=0 to nmbrteachers do
    XML_DISPLAY.TeFreeSelect[i]:=tmpSel[i];
 if radiobutton1.checked then
    XML_DISPLAY.teachersfreeshow1:=1
  else if radiobutton2.checked then
      XML_DISPLAY.teachersfreeshow1:=2
   else if radiobutton3.checked then
      XML_DISPLAY.teachersfreeshow1:=3;
 if radiobutton6.checked then
    XML_DISPLAY.teachersfreeshow2:=1
  else if radiobutton7.checked then
      XML_DISPLAY.teachersfreeshow2:=2
  else if rbYear.Checked then
  begin
    XML_DISPLAY.teachersfreeshow2 := 3;
    XML_DISPLAY.teFreeYear := findyear(cmbYear.Text);
    chbMatchAllYears.Enabled := true;
    XML_DISPLAY.MatchAllYears := chbMatchAllYears.Checked;
  end;
       
 winView[wnTeFree]:=XML_DISPLAY.teachersfreeshow1-1;
 close;
 UpdateWindow(wnTeFree);
end;



procedure TTeachersfreedlg.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpSel,listbox2,label7);
end;

procedure TTeachersfreedlg.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpSel,listbox2,label7);
end;

procedure TTeachersfreedlg.BitBtn3Click(Sender: TObject);
begin
 MoveOnSubList(tmpSel,listbox1,listbox2,label7,1);
end;

procedure TTeachersfreedlg.BitBtn4Click(Sender: TObject);
begin
 FillSubList(tmpSel,listbox1,listbox2,label7,1);
end;

procedure TTeachersfreedlg.FormActivate(Sender: TObject);
var
 i: integer;
begin
 listbox1.clear; listbox2.clear;
 for i:=1 to codeCount[1] do
   listbox1.items.add(XML_TEACHERS.tecode[codepoint[i,1],0]);
 if tmpSel[0]>0 then
   for i:=1 to tmpSel[0] do
    listbox2.items.add(XML_TEACHERS.tecode[tmpSel[i],0]);

 label6.caption:=inttostr(listbox1.items.count);
 label7.caption:=inttostr(listbox2.items.count);
 if XML_DISPLAY.teachersfreeday=-1 then combobox1.itemindex:=0
   else combobox1.itemindex:=XML_DISPLAY.teachersfreeday+1;
 fillTimeSlots;

 if XML_DISPLAY.TeFreePeriod=-1 then combobox3.itemindex:=0
   else combobox3.itemindex:=XML_DISPLAY.TeFreePeriod;
 combobox2.itemindex:=XML_DISPLAY.teachersfreefac-1;
 checkRadiobuttons;
end;

procedure TTeachersfreedlg.ComboBox1Change(Sender: TObject);
var
 tmpstr:  string;
 olddayGroup: smallint;
begin
 if duringload then exit;
 olddayGroup:=DayGroup[XML_DISPLAY.teachersfreeday];
 XML_DISPLAY.teachersfreeday:=findday(combobox1.text);
 if XML_DISPLAY.teachersfreeday>=0
  then
   begin
    label12.caption:=day[XML_DISPLAY.teachersfreeday];
    UseDay:=XML_DISPLAY.TeachersFreeDay;
   end
 else
  begin
   UseDay:=0;
   tmpstr:=uppercase(trim(combobox1.text));
   if ((tmpstr='*') or (tmpstr=uppercase(combobox1.items[0]))) then
     label12.caption:='All days'
   else
    begin
     XML_DISPLAY.teachersfreeday:=-2;
     label12.caption:='Enter Day';
    end;
  end;
 if DayGroup[UseDay]<>olddayGroup then
  begin
   fillTimeSlots;
   ComboBox3Change(Sender);
  end;
end;

procedure TTeachersfreedlg.ComboBox1Enter(Sender: TObject);
begin
 ComboBox1Change(Sender);
 ComboBox1.selectall;
end;

procedure TTeachersfreedlg.ComboBox2Change(Sender: TObject);
begin
 if duringload then exit;
 if trim(combobox2.text)='' then
    XML_DISPLAY.teachersfreefac:=-1  {none selected}
  else
    XML_DISPLAY.teachersfreefac:=findfaculty(ComboBox2.text,label12); {0 if not found and -1 for not selected}
end;

procedure TTeachersfreedlg.ComboBox2Enter(Sender: TObject);
begin
 ComboBox2Change(Sender);
 ComboBox2.selectall;
end;

procedure TTeachersfreedlg.RadioButton1Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeachersfreedlg.RadioButton2Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeachersfreedlg.RadioButton3Click(Sender: TObject);
begin
  checkRadiobuttons;
end;

procedure TTeachersfreedlg.rbYearClick(Sender: TObject);
begin
  checkRadiobuttons;
end;

procedure TTeachersfreedlg.RadioButton6Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeachersfreedlg.RadioButton7Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeachersfreedlg.ComboBox3Change(Sender: TObject);
begin
 if duringload then exit;
 XML_DISPLAY.TeFreePeriod:=Combobox3.ItemIndex;
 if XML_DISPLAY.TeFreePeriod>0 then
      label8.caption:=TimeSlotName[UseDay,XML_DISPLAY.TeFreePeriod-1]
  else if XML_DISPLAY.TeFreePeriod=0 then label8.caption:='All time slots'
   else label8.caption:='Select time slot';
end;

procedure TTeachersfreedlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3Change(Sender);
 ComboBox3.selectall;
end;

procedure TTeachersfreedlg.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpSel,ListBox2);
end;

procedure TTeachersfreedlg.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpSel,ListBox2);
end;

end.
