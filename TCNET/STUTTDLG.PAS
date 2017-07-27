unit Stuttdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,TimeChartGlobals, Spin,
  XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

type
  TStudttabledlg = class(TForm)
    GroupBox3: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    GroupBox4: TGroupBox;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    DayOrWeek: TRadioGroup;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label3: TLabel;
    ListBox1: TListBox;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Label4: TLabel;
    ListBox2: TListBox;
    Label2: TLabel;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    SelectDaysChkBox: TCheckBox;
    ttStartChkBox: TCheckBox;
    lblPrintPerPage: TLabel;
    spePrintPerPage: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelbuttonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure SaveSelection(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure RadioButton13Click(Sender: TObject);
    procedure RadioButton14Click(Sender: TObject);
    procedure RadioButton9Click(Sender: TObject);
    procedure RadioButton10Click(Sender: TObject);
    procedure RadioButton11Click(Sender: TObject);
    procedure RadioButton12Click(Sender: TObject);
    procedure DayOrWeekClick(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
  private
    procedure InitLists;
    procedure UpdateThisDlg;
  end;


var
  Studttabledlg: TStudttabledlg;

implementation
uses
 tcommon,tcommon2,DlgCommon;
var
 duringload:    boolean;
 tmpStug:       tpstudentdata;
 tmpshow1,tmpshow2:            integer;
 tmpclass,tmphouse:            integer;
 tmptutor,tmproom:             integer;
{$R *.DFM}


procedure TStudttabledlg.InitLists;
var
 i,i2,j,k:          integer;
 tmpList:       tpTeData;
begin
 label1.caption:=''; label2.caption:='';
 listbox1.clear; listbox2.clear;  combobox3.clear;
 combobox4.clear;  combobox5.clear;  combobox6.clear;
 for i:=1 to XML_STUDENTS.numstud do
   listbox1.items.add(XML_STUDENTS.Stud[i].stname+' '+XML_STUDENTS.Stud[i].first);
 FillComboRollClass(combobox3,tmpclass,radiobutton11);

 combobox4.items.add('All houses');
 j:=0;
 for i:=1 to housecount do
  if trim(HouseName[i])>'' then
   begin
    combobox4.items.add(HouseName[i]);
    inc(j);
   end;
 if bool(j) then
  begin
   combobox4.itemindex:=tmphouse;
   combobox4.update;
  end
 else
   radiobutton12.enabled:=false;

 for i:=0 to nmbrteachers do tmpList[i]:=0;
 for i:=1 to XML_STUDENTS.numstud do
   if XML_STUDENTS.Stud[i].tutor>0 then tmplist[XML_STUDENTS.Stud[i].tutor]:=1;

 combobox5.items.add('All tutors');
 if codeCount[1]>0 then
  begin
   i2:=0;
   for i:=1 to codeCount[1] do
    begin
     k:=codepoint[i,1];
     if bool(tmplist[k]) then
      begin
       combobox5.items.add(XML_TEACHERS.tecode[k,0]+'   '+XML_TEACHERS.tename[k,0]);
       inc(i2);
      end;
     if k=tmptutor then j:=i2;
    end;
   if tmptutor=0 then combobox5.itemindex:=0
    else combobox5.itemindex:=j;
   combobox5.update;
  end
 else
   radiobutton13.enabled:=false;

 for i:=0 to nmbrteachers do tmpList[i]:=0;
 for i:=1 to XML_STUDENTS.numstud do
  if XML_STUDENTS.Stud[i].home>0 then tmplist[XML_STUDENTS.Stud[i].home]:=1;

 combobox6.items.add('All home rooms');
 if codeCount[2]>0 then
  begin
   i2:=0;
   for i:=1 to codeCount[2] do
    begin
     k:=codepoint[i,2];
     if bool(tmplist[k]) then
      begin
       combobox6.items.add(XML_TEACHERS.tecode[k,1]+'   '+XML_TEACHERS.tename[k,1]);
       inc(i2);
      end;
     if k=tmproom then j:=i2;
    end;
   if tmproom=0 then combobox6.itemindex:=0
    else combobox6.itemindex:=j;
   combobox6.update;
  end
 else
   radiobutton14.enabled:=false;

 if tmpstug[0]>0 then
  for i:=1 to tmpstug[0] do
   listbox2.items.add(XML_STUDENTS.Stud[tmpstug[i]].stname+' '+XML_STUDENTS.Stud[tmpstug[i]].first);

 label1.caption:=inttostr(listbox1.items.count);
 label2.caption:=inttostr(listbox2.items.count);
end;

procedure TStudttabledlg.UpdateThisDlg;
begin
 checkbox1.Enabled:=DayOrWeek.ItemIndex=1;
 combobox1.color:=clWindow; listbox1.color:=clwindow; listbox2.color:=clwindow;
 combobox1.enabled:=false;  listbox1.enabled:=false;  listbox2.enabled:=false;
 combobox2.color:=clwindow; combobox2.enabled:=false;
 combobox3.color:=clwindow; combobox3.enabled:=false;
 combobox4.color:=clwindow; combobox4.enabled:=false;
 combobox5.color:=clwindow; combobox5.enabled:=false;
 combobox6.color:=clwindow; combobox6.enabled:=false;
 bitbtn1.enabled:=false; bitbtn2.enabled:=false;
 bitbtn3.enabled:=false; bitbtn4.enabled:=false;
 SelectDaysChkBox.enabled:=true;  ttStartChkBox.Enabled:=true;

 DayOrWeek.ItemIndex:=tmpshow1;
 if tmpshow1=0 then
  begin
   HiLiteCombo(combobox2);  HiLiteCombo(combobox1);
   SelectDaysChkBox.enabled:=false; ttStartChkBox.Enabled:=false;
  end;

 case tmpshow2 of
  1: begin  {selection}
      radiobutton9.checked:=true;
      HiLiteList(listbox1);  HiLiteList(listbox2);
      bitbtn1.enabled:=true; bitbtn2.enabled:=true;
      bitbtn3.enabled:=true; bitbtn4.enabled:=true;
     end;
  2: begin  {group}
      radiobutton10.checked:=true;
     end;
  3: begin  {class}
      radiobutton11.checked:=true;
      HiLiteCombo(combobox3);
     end;
  4: begin  {house}
      radiobutton12.checked:=true;
      HiLiteCombo(combobox4);
     end;
  5: begin  {tutor}
      radiobutton13.checked:=true;
      HiLiteCombo(combobox5);
     end;
  6: begin   {home room}
      radiobutton14.checked:=true;
      HiLiteCombo(combobox6);
     end;
 end; {case}
end;

procedure TStudttabledlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
 if ModalResult = mrOk then
   UpdateWindow(wnStudentTt);
end;

procedure TStudttabledlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure TStudttabledlg.FormActivate(Sender: TObject);
begin
 case XML_DISPLAY.StudTtListType of
  1: radiobutton9.checked:=true;
  2: radiobutton10.checked:=true;
  3: radiobutton11.checked:=true;
  4: radiobutton12.checked:=true;
  5: radiobutton13.checked:=true;
  6: radiobutton14.checked:=true;
 end; {case}

 DayOrWeek.ItemIndex:=winView[wnStudentTt];
 initlists;
 updatethisdlg;
end;

procedure TStudttabledlg.RadioButton5Click(Sender: TObject);
begin
 tmpshow2:=2;
 updatethisdlg;
end;

procedure TStudttabledlg.RadioButton6Click(Sender: TObject);
begin
 tmpshow2:=2;
 updatethisdlg;
end;

procedure TStudttabledlg.SaveSelection(Sender: TObject);
var
  i: Integer;
  Old_ttWeekDaysFlg, Old_ttClockShowFlg: Boolean;
begin
  Old_ttWeekDaysFlg:=XML_DISPLAY.ttWeekDaysFlg;
  Old_ttClockShowFlg:=XML_DISPLAY.ttClockShowFlg;
  if radiobutton9.checked then XML_DISPLAY.StudTtListType:=1
  else if radiobutton10.checked then XML_DISPLAY.StudTtListType:=2
  else if radiobutton11.checked then XML_DISPLAY.StudTtListType:=3
  else if radiobutton12.checked then XML_DISPLAY.StudTtListType:=4
  else if radiobutton13.checked then XML_DISPLAY.StudTtListType:=5
  else if radiobutton14.checked then XML_DISPLAY.StudTtListType:=6;
  winView[wnStudentTt]:=DayOrWeek.ItemIndex;
  if winView[wnStudentTt]=0 then {daily}
  begin
    if BadDayCombo(XML_DISPLAY.stuttlistvals[7],combobox1) then exit;
    if BadDayCombo(XML_DISPLAY.stuttlistvals[8],combobox2) then exit;
    if XML_DISPLAY.stuttlistvals[8]<XML_DISPLAY.stuttlistvals[7] then swapint(XML_DISPLAY.stuttlistvals[8],XML_DISPLAY.stuttlistvals[7]);
  end
  else
  begin
    XML_DISPLAY.ttWeekDaysFlg := SelectDaysChkBox.Checked;
    XML_DISPLAY.ttClockShowFlg := ttStartChkBox.Checked;
    XML_DISPLAY.PWeek := spePrintPerPage.Value;
  end;
  XML_DISPLAY.studentttselection[0] := tmpstug[0];
  if tmpstug[0] > 0 then
    for i:=1 to tmpstug[0] do
      XML_DISPLAY.studentttselection[i]:=tmpstug[i];

  tmpclass:=findclass2(combobox3.text);
  tmphouse:=findhouse2(combobox4.text);
  if combobox5.text='All tutors' then tmptutor:=0
  else tmptutor:=findtutor2(copy(combobox5.text,1,lencodes[1]));
  if combobox6.text='All home rooms' then tmproom:=0
  else tmproom:=findroom2(copy(combobox6.text,1,lencodes[2]));

  XML_DISPLAY.MatchAllYears:=CheckBox2.Checked;
  XML_DISPLAY.TrackEnrolFlag:=CheckBox3.Checked;
  XML_DISPLAY.stuttEnrolment:=checkbox1.Checked;

  XML_DISPLAY.stuttlistvals[3]:=tmpclass;
  XML_DISPLAY.stuttlistvals[4]:=tmphouse;
  XML_DISPLAY.stuttlistvals[5]:=tmptutor;
  XML_DISPLAY.stuttlistvals[6]:=tmproom;
  XML_DISPLAY.StudTtListType:=tmpshow2;
  winView[wnStudentTt]:=tmpshow1;
  Close;
  if (Old_ttWeekDaysFlg<>XML_DISPLAY.ttWeekDaysFlg) or (Old_ttClockShowFlg<>XML_DISPLAY.ttClockShowFlg) then
    updateAllwins
  else
    UpdateWindow(wnStudentTt);
end;

procedure TStudttabledlg.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  duringload := True;
  rangeCheckStudSels(XML_DISPLAY.studentttselection);
  for i := 0 to nmbrstudents do tmpStug[i] := 0;
  tmpstug[0] := XML_DISPLAY.studentttselection[0];
  if tmpstug[0] > 0 then
  for i:=1 to tmpstug[0] do
   tmpstug[i] := XML_DISPLAY.studentttselection[i];
  tmpclass := XML_DISPLAY.stuttlistvals[3];
  tmphouse := XML_DISPLAY.stuttlistvals[4];
  tmptutor := XML_DISPLAY.stuttlistvals[5];
  tmproom := XML_DISPLAY.stuttlistvals[6];
  tmpshow2 := XML_DISPLAY.StudTtListType;
  tmpshow1 := winView[wnStudentTt];
  CheckBox1.Checked := XML_DISPLAY.stuttEnrolment;
  SelectDaysChkBox.Checked := XML_DISPLAY.ttWeekDaysFlg;
  ttStartChkBox.Checked := XML_DISPLAY.ttClockShowFlg;
  spePrintPerPage.Value := XML_DISPLAY.PWeek;

  FillComboDays(False, ComboBox1);
  combobox1.itemindex := XML_DISPLAY.stuttlistvals[7];
  FillComboDays(False, ComboBox2);
  combobox2.itemindex := XML_DISPLAY.Stuttlistvals[8];
  CheckBox2.Checked := XML_DISPLAY.MatchAllYears;
  //if OberonShow then CheckBox3.Visible := True;
  CheckBox3.Checked := XML_DISPLAY.TrackEnrolFlag;
  duringload := False;
end;

procedure TStudttabledlg.ComboBox1Change(Sender: TObject);
begin
 if duringload then exit;
 XML_DISPLAY.stuttlistvals[7]:=findday(combobox1.text);
end;

procedure TStudttabledlg.ComboBox2Change(Sender: TObject);
begin
 if duringload then exit;
 XML_DISPLAY.stuttlistvals[8]:=findday(combobox2.text);
end;

procedure TStudttabledlg.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpStug,listbox2,label2);
end;

procedure TStudttabledlg.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpStug,listbox2,label2);
end;

procedure TStudttabledlg.BitBtn3Click(Sender: TObject);
begin
 MoveOnStudList(tmpStug,listbox1,listbox2,label2,false);
end;

procedure TStudttabledlg.BitBtn4Click(Sender: TObject);
begin
 FillStudList(tmpStug,listbox1,listbox2,label2,false);
end;

procedure TStudttabledlg.ComboBox3Change(Sender: TObject);
begin
 tmpclass:=findclass2(combobox3.text);
end;

procedure TStudttabledlg.ComboBox4Change(Sender: TObject);
begin
 tmphouse:=findhouse2(combobox4.text);
end;

procedure TStudttabledlg.ComboBox5Change(Sender: TObject);
begin
 if combobox5.text='All tutors' then tmptutor:=0
 else tmptutor:=findtutor2(copy(combobox5.text,1,lencodes[1]));
end;

procedure TStudttabledlg.ComboBox6Change(Sender: TObject);
begin
 if combobox6.text='All home rooms' then tmproom:=0
 else tmproom:=findroom2(copy(combobox6.text,1,lencodes[2]));
end;

procedure TStudttabledlg.RadioButton13Click(Sender: TObject);
begin
 tmpshow2:=5;
 updatethisdlg;
end;

procedure TStudttabledlg.RadioButton14Click(Sender: TObject);
begin
 tmpshow2:=6;
 updatethisdlg;
end;

procedure TStudttabledlg.RadioButton9Click(Sender: TObject);
begin
 tmpshow2:=1;
 updatethisdlg;
end;

procedure TStudttabledlg.RadioButton10Click(Sender: TObject);
begin
 tmpshow2:=2;
 updatethisdlg;
end;

procedure TStudttabledlg.RadioButton11Click(Sender: TObject);
begin
 tmpshow2:=3;
 updatethisdlg;
end;

procedure TStudttabledlg.RadioButton12Click(Sender: TObject);
begin
 tmpshow2:=4;
 updatethisdlg;
end;

procedure TStudttabledlg.DayOrWeekClick(Sender: TObject);
begin
 tmpshow1:=DayOrWeek.ItemIndex;
 updatethisdlg;
end;

procedure TStudttabledlg.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpStug,ListBox2);
end;

procedure TStudttabledlg.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpStug,ListBox2);
end;

end.
