unit Stulidlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,TimeChartGlobals, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

type
  TStudListDlg = class(TForm)
    GroupBox2: TGroupBox;
    Label5: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    rbtNumbersFor: TRadioButton;

    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    RadioButton17: TRadioButton;
    RadioButton18: TRadioButton;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    CheckBox1: TCheckBox;
    GroupBox1: TGroupBox;
    CheckBox3: TCheckBox;
    CheckBox2: TCheckBox;
    Label3: TLabel;
    ListBox1: TListBox;
    Label6: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Label4: TLabel;
    ListBox2: TListBox;
    Label7: TLabel;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    Panel1: TPanel;
    rbtClasses: TRadioButton;
    rbtHouses: TRadioButton;
    rbtSubjects: TRadioButton;
    rbtTutors: TRadioButton;
    rbtRooms: TRadioButton;
    rbtFaculties: TRadioButton;
    procedure OKbuttonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rbtNumbersForClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure RadioButton13Click(Sender: TObject);
    procedure RadioButton14Click(Sender: TObject);
    procedure RadioButton15Click(Sender: TObject);
    procedure RadioButton16Click(Sender: TObject);
    procedure RadioButton17Click(Sender: TObject);
    procedure RadioButton18Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
  private
    procedure InitLists;
    procedure UpdateThisDlg;
  end;

var
  StudListDlg: TStudListDlg;


implementation
uses tcommon,studlist,tcommon2,DlgCommon;
{$R *.DFM}

var
 tmpStug:       tpstudentdata;
 tmpshow1,tmpshow2:            integer;
 tmpclass,tmphouse:            integer;
 tmptutor,tmproom:             integer;



procedure TStudListDlg.InitLists;
var
 i,j,k:integer;
 i2:     integer;
 tmpList:       tpTeData;
begin
 label6.caption:=''; label7.caption:='';
 listbox1.clear; listbox2.clear;  combobox1.clear;
 combobox2.clear;  combobox3.clear;  combobox4.clear;

 for i:=1 to XML_STUDENTS.numstud do
  listbox1.items.add(XML_STUDENTS.Stud[i].stname+' '+XML_STUDENTS.Stud[i].first);

 FillComboRollClass(combobox1,tmpclass,radiobutton15);

 combobox2.items.add('All houses');
 j:=0;
 for i:=1 to housecount do
  if trim(HouseName[i])>'' then
   begin
    combobox2.items.add(HouseName[i]);
    inc(j);
   end;
 if bool(j) then
  begin
   combobox2.itemindex:=tmphouse;
   combobox2.update;
  end
 else
   radiobutton16.enabled:=false;

 fillchar(tmpList,sizeof(tmpList),chr(0));
 for i:=1 to XML_STUDENTS.numstud do
  if XML_STUDENTS.Stud[i].tutor>0 then tmpList[XML_STUDENTS.Stud[i].tutor]:=1;

 combobox3.items.add('All tutors');
 if codeCount[1]>0 then
  begin
   i2:=0;
   for i:=1 to codeCount[1] do
    begin
     k:=codepoint[i,1];
     if bool(tmpList[k]) then
      begin
       combobox3.items.add(XML_TEACHERS.tecode[k,0]+'   '+XML_TEACHERS.tename[k,0]);
       inc(i2);
      end;
     if k=tmptutor then j:=i2;
    end;
   if tmptutor=0 then combobox3.itemindex:=0
    else combobox3.itemindex:=j;
   combobox3.update;
  end
 else
   radiobutton17.enabled:=false;

 fillchar(tmpList,sizeof(tmpList),chr(0));
 for i:=1 to XML_STUDENTS.numstud do
  if XML_STUDENTS.Stud[i].home>0 then tmpList[XML_STUDENTS.Stud[i].home]:=1;

 combobox4.items.add('All home rooms');
 if codeCount[2]>0 then
  begin
   i2:=0;
   for i:=1 to codeCount[2] do
    begin
     k:=codepoint[i,2];
     if bool(tmpList[k]) then
      begin
       combobox4.items.add(XML_TEACHERS.tecode[k,1]+'   '+XML_TEACHERS.tename[k,1]);
       inc(i2);
      end;
     if k=tmproom then j:=i2;
    end;
   if tmproom=0 then combobox4.itemindex:=0
    else combobox4.itemindex:=j;
   combobox4.update;
  end
 else
   radiobutton18.enabled:=false;
 if tmpStug[0]>0 then
  for i:=1 to tmpStug[0] do
   listbox2.items.add(XML_STUDENTS.Stud[tmpStug[i]].stname+' '+XML_STUDENTS.Stud[tmpStug[i]].first);

 label6.caption:=inttostr(listbox1.items.count);
 label7.caption:=inttostr(listbox2.items.count);
end;

procedure TStudListDlg.UpdateThisDlg;
begin
  listbox1.color:=clwindow; listbox2.color:=clwindow;
  listbox1.enabled:=false;  listbox2.enabled:=false;
  combobox1.color:=clwindow; combobox1.enabled:=false;
  combobox2.color:=clwindow; combobox2.enabled:=false;
  combobox3.color:=clwindow; combobox3.enabled:=false;
  combobox4.color:=clwindow; combobox4.enabled:=false;
  bitbtn1.enabled:=false; bitbtn2.enabled:=false;
  bitbtn3.enabled:=false; bitbtn4.enabled:=false;
  case tmpshow2 of
  1: begin  {selection}
      radiobutton13.checked:=true;
      HiLiteList(listbox1); HiLiteList(listbox2);
      bitbtn1.enabled:=true; bitbtn2.enabled:=true;
      bitbtn3.enabled:=true; bitbtn4.enabled:=true;
     end;
  2: begin  {group}
      radiobutton14.checked:=true;
     end;
  3: begin  {class}
      radiobutton15.checked:=true;
      HiLiteCombo(combobox1);
     end;
  4: begin  {house}
      radiobutton16.checked:=true;
      HiLiteCombo(combobox2);
     end;
  5: begin  {tutor}
      radiobutton17.checked:=true;
      HiLiteCombo(combobox3);
     end;
  6: begin   {home room}
      radiobutton18.checked:=true;
      HiLiteCombo(combobox4);
     end;
  end; {case}
  rbtClasses.enabled := rbtNumbersFor.Checked;
  rbtHouses.enabled := rbtNumbersFor.Checked;
  rbtSubjects.enabled := rbtNumbersFor.Checked;
  rbtTutors.enabled := rbtNumbersFor.Checked;
  rbtRooms.Enabled := rbtNumbersFor.Checked;
  rbtFaculties.Enabled := rbtNumbersFor.Checked;
end;


procedure TStudListDlg.OKbuttonClick(Sender: TObject);
var
 i:              integer;
 lt,lnt:             integer;
begin
 lt:=1;   lnt:=1;
  if radiobutton13.checked then lt:=1
  else if radiobutton14.checked then lt:=2
  else if radiobutton15.checked then lt:=3
  else if radiobutton16.checked then lt:=4
  else if radiobutton17.checked then lt:=5
  else if radiobutton18.checked then lt:=6
  else if rbtNumbersFor.Checked then
  begin
    lt:=7;
    if rbtClasses.Checked then lnt:=1
    else if rbtHouses.Checked then lnt:=2
    else if rbtSubjects.Checked then lnt:=3
    else if rbtTutors.Checked then lnt:=4
    else if rbtRooms.Checked then lnt:=5
    else if rbtFaculties.Checked then lnt := 6;
  end;


 {ok to update vars  - only after verify}
 XML_DISPLAY.StudListType:=lt;
 XML_DISPLAY.listnumbertype:=lnt;

 XML_DISPLAY.listEnrolment:=checkbox2.checked;
 XML_DISPLAY.EnrolBarcodeFlg:=checkbox3.Checked;
 XML_DISPLAY.MatchAllYears:=checkbox1.checked;

 try
  screen.cursor:=crHourglass;
  for i:=0 to nmbrstudents do
   liststudentselection[i]:=tmpStug[i];

  tmpclass:=findclass2(combobox1.text);
  tmphouse:=findhouse2(combobox2.text);
  if combobox3.text='All tutors' then tmptutor:=0
  else tmptutor:=findtutor2(copy(combobox3.text,1,lencodes[1]));
  if combobox4.text='All home rooms' then tmproom:=0
  else tmproom:=findroom2(copy(combobox4.text,1,lencodes[2]));

  XML_DISPLAY.listRanges[1,1]:=tmpclass;
  XML_DISPLAY.listRanges[2,1]:=tmphouse;
  XML_DISPLAY.listRanges[3,1]:=tmptutor;
  XML_DISPLAY.listRanges[4,1]:=tmproom;
  UpdateStudWins;
  if RadioButton13.Checked then
    ModalResult := mrOK
  else
    ModalResult := mrCancel;
 finally
  screen.cursor:=crDefault;
 end;
end;

procedure TStudListDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=cafree;
end;

procedure TStudListDlg.FormCreate(Sender: TObject);
var
 i:       integer;
begin
  {init edit boxes}
 for i:=0 to nmbrstudents do
  tmpStug[i]:=liststudentselection[i];

 tmpclass:=XML_DISPLAY.listRanges[1,1];
 tmphouse:=XML_DISPLAY.listRanges[2,1];
 tmptutor:=XML_DISPLAY.listRanges[3,1];
 tmproom:=XML_DISPLAY.listRanges[4,1];
 tmpshow2:=XML_DISPLAY.StudListType;
 tmpshow1:=XML_DISPLAY.listnumbertype;
end;

procedure TStudListDlg.FormActivate(Sender: TObject);
begin
 case XML_DISPLAY.StudListType of
  1: radiobutton13.checked:=true;
  2: radiobutton14.checked:=true;
  3: radiobutton15.checked:=true;
  4: radiobutton16.checked:=true;
  5: radiobutton17.checked:=true;
  6: radiobutton18.checked:=true;
  7: begin
      rbtNumbersFor.Checked := True;
      case XML_DISPLAY.listnumbertype of
       1: rbtClasses.Checked := True;
       2: rbtHouses.Checked := True;
       3: rbtSubjects.Checked := True;
       4: rbtTutors.Checked := True;
       5: rbtRooms.Checked := True;
       6: rbtFaculties.Checked := True;
      end; {case}
     end;
 end; {case}
 if rbtNumbersFor.Checked then
  begin
   rbtClasses.enabled:=true;
   rbtHouses.enabled:=true;
   rbtSubjects.Enabled := True;
   rbtTutors.Enabled := True;
   rbtRooms.Enabled := true;
   rbtFaculties.Enabled := true;
  end
 else
  begin
   rbtClasses.enabled:=false;
   rbtHouses.enabled:=false;
   rbtSubjects.Enabled := False;
   rbtTutors.Enabled := False;
   rbtRooms.Enabled := False;
   rbtFaculties.Enabled := False;
  end;
 checkbox2.checked:=XML_DISPLAY.listEnrolment;
 checkbox3.Checked:=XML_DISPLAY.EnrolBarcodeFlg;
 checkbox3.Enabled:=XML_DISPLAY.listEnrolment;
 checkbox1.checked:=XML_DISPLAY.MatchAllYears;
 initlists;
 updatethisdlg;
end;

procedure TStudListDlg.rbtNumbersForClick(Sender: TObject);
begin
 tmpshow2:=7;
 updatethisdlg;
end;

procedure TStudListDlg.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpStug,listbox2,label7);
end;

procedure TStudListDlg.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpStug,listbox2,label7);
end;

procedure TStudListDlg.BitBtn3Click(Sender: TObject);
begin
 MoveOnStudList(tmpStug,listbox1,listbox2,label7,false);
end;

procedure TStudListDlg.BitBtn4Click(Sender: TObject);
begin
 FillStudList(tmpStug,listbox1,listbox2,label7,false);
end;

procedure TStudListDlg.ComboBox1Change(Sender: TObject);
begin
 tmpclass:=findclass2(combobox1.text);
end;

procedure TStudListDlg.ComboBox2Change(Sender: TObject);
begin
 tmphouse:=findhouse2(combobox2.text);
end;

procedure TStudListDlg.ComboBox3Change(Sender: TObject);
begin
 if combobox3.text='All tutors' then tmptutor:=0
 else tmptutor:=findtutor2(copy(combobox3.text,1,lencodes[1]));
end;

procedure TStudListDlg.ComboBox4Change(Sender: TObject);
begin
 if combobox4.text='All home rooms' then tmproom:=0
 else tmproom:=findroom2(copy(combobox4.text,1,lencodes[2]));
end;

procedure TStudListDlg.RadioButton13Click(Sender: TObject);
begin
 tmpshow2:=1;
 updatethisdlg;
end;

procedure TStudListDlg.RadioButton14Click(Sender: TObject);
begin
 tmpshow2:=2;
 updatethisdlg;
end;

procedure TStudListDlg.RadioButton15Click(Sender: TObject);
begin
 tmpshow2:=3;
 updatethisdlg;
end;

procedure TStudListDlg.RadioButton16Click(Sender: TObject);
begin
 tmpshow2:=4;
 updatethisdlg;
end;

procedure TStudListDlg.RadioButton17Click(Sender: TObject);
begin
 tmpshow2:=5;
 updatethisdlg;
end;

procedure TStudListDlg.RadioButton18Click(Sender: TObject);
begin
 tmpshow2:=6;
 updatethisdlg;
end;

procedure TStudListDlg.CheckBox2Click(Sender: TObject);
begin
 checkbox3.Enabled:=checkbox2.Checked;
end;

procedure TStudListDlg.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpStug,ListBox2);
end;

procedure TStudListDlg.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpStug,ListBox2);
end;

end.
