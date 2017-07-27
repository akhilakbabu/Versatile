unit Stindlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ComCtrls, Tabnotbk,TimeChartGlobals, ExtCtrls,
  XML.UTILS, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

type
  Tstudentinputdlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    TabbedNotebook1: TTabbedNotebook;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox3: TGroupBox;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    GroupBox4: TGroupBox;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Label15: TLabel;
    Label13: TLabel;
    BitBtn9: TBitBtn;
    CheckBox1: TCheckBox;
    OfferName: TLabel;
    CheckBox2: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    SectionsEdit1: TLabeledEdit;
    UpDown2: TUpDown;
    SectionEdit1: TLabeledEdit;
    UpDown1: TUpDown;
    SaveBtn1: TBitBtn;
    OpenBtn1: TBitBtn;
    Label18: TLabel;
    ComboBox5: TComboBox;
    LabeledEdit2: TLabeledEdit;
    ShowSubs1: TRadioGroup;
    Edit5: TEdit;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
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
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure RadioButton9Click(Sender: TObject);
    procedure RadioButton10Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure ShowSubs1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure OpenBtn1Click(Sender: TObject);
    procedure SaveBtn1Click(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
   private
    procedure UpdateMyOffer;
    procedure InitMyOffer;
    procedure ReshowSection;
    procedure UpdateThisDlg;
  end;

var
  studentinputdlg: Tstudentinputdlg;

implementation
uses tcommon,DlgCommon,tcommon2,tcommon5, Main;
{$R *.DFM}

var
 tmpStug:       tpstudentdata;
 tmpSubg:       tpSubData;
 tmppref1,tmppref2:            smallint;
 tmpshow1,tmpshow2:            smallint;
 tmpclass,tmphouse:            smallint;
 tmptutor,tmproom:             smallint;
 MyOfferFile,MyOfferBlocks         : string;
 MyOfferGOSname             : string;
 MySections,UseSection      : smallint;
 MyBlockFlag                : wordbool;
 MyTitle,MyOfferDesc        : array of string;
 MySubMax                   : smallint;
 MyOfferSubs                : array of array of smallint;
 OfferGOSindex              : smallint;
 OKflag: boolean;

procedure SetMyOfferArrays;
begin
 SetLength(MyTitle,MySections+1); SetLength(MyOfferDesc,MySections+1);
 SetLength(MyOfferSubs,MySections+1,MySubMax+1);
end;



procedure Tstudentinputdlg.UpdateThisDlg;
begin
 combobox1.color:=clWindow; listbox1.color:=clwindow; listbox2.color:=clwindow;
 combobox1.enabled:=false;  listbox1.enabled:=false;  listbox2.enabled:=false;
 combobox2.color:=clwindow; combobox2.enabled:=false;
 combobox3.color:=clwindow; combobox3.enabled:=false;
 combobox4.color:=clwindow; combobox4.enabled:=false;
 bitbtn1.enabled:=false; bitbtn2.enabled:=false;
 bitbtn3.enabled:=false; bitbtn4.enabled:=false;
 ShowSubs1.ItemIndex:=tmpShow1;

 case tmpshow2 of
  1: begin  {selection}
      radiobutton5.checked:=true;
      HiLiteList(listbox1); HiLiteList(listbox2);
      bitbtn1.enabled:=true; bitbtn2.enabled:=true;
      bitbtn3.enabled:=true; bitbtn4.enabled:=true;
     end;
  2: begin  {group}
      radiobutton6.checked:=true;
     end;
  3: begin  {class}
      radiobutton7.checked:=true;
      HiLiteCombo(combobox1);
     end;
  4: begin  {house}
      radiobutton8.checked:=true;
      HiLiteCombo(combobox2);
     end;
  5: begin  {tutor}
      radiobutton9.checked:=true;
      HiLiteCombo(combobox3);
     end;
  6: begin   {home room}
      radiobutton10.checked:=true;
      HiLiteCombo(combobox4);
     end;
 end; {case}
 label17.caption:=inttostr(listbox4.items.count);
end;



procedure Tstudentinputdlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
 i,j: integer;
begin
 if OKflag=false then
  begin
   OfferFile:=MyOfferFile;
   OfferBlocks:=MyOfferBlocks;
   OfferSections :=MySections;
   OfferBlockFlag:=MyBlockFlag;
   OfferSubMax:=MySubMax;
   OfferGOSname:=MyOfferGOSname;
   SetSubOfferArrays;
   for i:=1 to MySections do
    begin
     OfferTitle[i]:=MyTitle[i];
     OfferDesc[i]:=MyOfferDesc[i];
     OfferSubs[i,0]:=MyOfferSubs[i,0];
     if OfferSubs[i,0]>0 then
      for j:=1 to OfferSubs[i,0] do OfferSubs[i,j]:=MyOfferSubs[i,j];
    end;
  end;
 action:=cafree;
end;

procedure Tstudentinputdlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure Tstudentinputdlg.FormCreate(Sender: TObject);
var
 i,j:       integer;
begin
 OKflag:=false;
 XML_DISPLAY.StudentInputShow1:=winView[wnStInput];
 fillchar(tmpStug,sizeof(tmpStug),chr(0));
 fillchar(tmpSubg,sizeof(tmpSubg),chr(0));

 for i:=0 to nmbrstudents do
    tmpStug[i]:=XML_DISPLAY.StudentInputSelection[i];

 MyOfferFile:=OfferFile;
 MyOfferBlocks:=OfferBlocks;
 MySections:=OfferSections;
 MyBlockFlag:=OfferBlockFlag;
 MySubMax:=OfferSubMax;
 MyOfferGOSname:=OfferGOSname;
 SetMyOfferArrays;
 for i:=1 to OfferSections do
  begin
   MyTitle[i]:=OfferTitle[i];
   MyOfferDesc[i]:=OfferDesc[i];
   MyOfferSubs[i,0]:=OfferSubs[i,0];
   if OfferSubs[i,0]>0 then
    for j:=1 to OfferSubs[i,0] do MyOfferSubs[i,j]:=OfferSubs[i,j];
  end;
 InitMyOffer;

 tmppref1:=XML_DISPLAY.StInputPref1;
 tmppref2:=XML_DISPLAY.StInputPref2;
 tmpclass:=XML_DISPLAY.StInputClass;
 tmphouse:=XML_DISPLAY.StInputHouse;
 tmptutor:=XML_DISPLAY.StInputTutor;
 tmproom:=XML_DISPLAY.StInputRoom;
 tmpshow1:=XML_DISPLAY.studentinputshow1;
 tmpshow2:=XML_DISPLAY.studentinputshow2;
 edit1.enabled:=(tmpShow1<>1) and (tmpShow1<>4);
 edit2.enabled:=(tmpShow1<>1) and (tmpShow1<>4);
 SaveBtn1.Enabled:=(usrPassLevel>utGen);
end;

procedure Tstudentinputdlg.ComboBox1Change(Sender: TObject);
begin
 tmpclass:=findclass2(combobox1.text);
end;

procedure Tstudentinputdlg.ComboBox3Change(Sender: TObject);
begin
 if combobox3.text='All tutors' then
  tmptutor:=0
 else
  tmptutor:=findtutor2(copy(combobox3.text,1,lencodes[1]));
end;

procedure Tstudentinputdlg.ComboBox2Change(Sender: TObject);
begin
 tmphouse:=findhouse2(combobox2.text);
end;

procedure Tstudentinputdlg.ComboBox4Change(Sender: TObject);
begin
 if combobox4.text='All home rooms' then
  tmproom:=0
 else
  tmproom:=findroom2(copy(combobox4.text,1,lencodes[2]));
end;

procedure Tstudentinputdlg.RadioButton5Click(Sender: TObject);
begin
 tmpshow2:=1;
 updatethisdlg;
end;

procedure Tstudentinputdlg.RadioButton6Click(Sender: TObject);
begin
 tmpshow2:=2;
 updatethisdlg;
end;

procedure Tstudentinputdlg.RadioButton7Click(Sender: TObject);
begin
 tmpshow2:=3;
 updatethisdlg;
end;

procedure Tstudentinputdlg.RadioButton8Click(Sender: TObject);
begin
 tmpshow2:=4;
 updatethisdlg;
end;

procedure Tstudentinputdlg.RadioButton9Click(Sender: TObject);
begin
 tmpshow2:=5;
 updatethisdlg;
end;

procedure Tstudentinputdlg.RadioButton10Click(Sender: TObject);
begin
 tmpshow2:=6;
 updatethisdlg;
end;


procedure Tstudentinputdlg.InitMyOffer;
var
 i,j: integer;
begin
 if OfferFile>'' then OfferName.Caption:=OfferFile
  else OfferName.Caption:='(not saved)';
 UseSection:=1;
 j:=OfferSubs[UseSection,0];
 tmpSubg[0]:=j;
 if j>0 then for i:=0 to j do tmpSubg[i]:=OfferSubs[UseSection,i];
 listbox4.clear;
 if tmpSubg[0]>0 then
  try
   for i:=1 to tmpSubg[0] do
    listbox4.items.add(SubCode[tmpSubg[i]]);
  except
  end;
 LabeledEdit2.Text:=OfferTitle[UseSection];
 Edit5.Text:=OfferDesc[UseSection];
 CheckBox2.Checked:=OfferBlockFlag;
 Label12.Caption:=OfferBlocks;
 UpDown2.Position:=OfferSections;
 UpDown1.Position:=UseSection;
 UpDown1.Max:=OfferSections;
 i:=combobox5.Items.IndexOf(OfferGOSname);
 if i<0 then i:=0;
 if i<>OfferGOSindex then
  begin
   OfferGOSindex:=i;
   combobox5.ItemIndex:=i;
  end;
end;

procedure Tstudentinputdlg.ReshowSection;
var
 i,j: integer;
begin
 j:=OfferSubs[UseSection,0];
 tmpSubg[0]:=j;
 if j>0 then for i:=1 to j do tmpSubg[i]:=OfferSubs[UseSection,i];
 listbox4.clear;
 if tmpSubg[0]>0 then
   try
    for i:=1 to tmpSubg[0] do
     listbox4.items.add(SubCode[tmpSubg[i]]);
   except
   end;
 LabeledEdit2.Text:=OfferTitle[UseSection];
 Edit5.Text:=OfferDesc[UseSection];
end;


procedure Tstudentinputdlg.UpdateMyOffer;
var
 i,j: integer;
begin
 j:=tmpSubg[0];
 if j>OfferSubMax then begin OfferSubMax:=j; SetSubOfferArrays; end;
 OfferSubs[UseSection,0]:=j;
 if j>0 then for i:=1 to j do OfferSubs[UseSection,i]:=tmpSubg[i];
 OfferTitle[UseSection]:=LabeledEdit2.Text;
 OfferDesc[UseSection]:=Edit5.Text;
 if UpDown1.Position<>UseSection then
  begin
   UseSection:=UpDown1.Position;
   ReshowSection;
  end;
end;

procedure Tstudentinputdlg.FormActivate(Sender: TObject);
var
 i,j,k:integer;
 i2:     integer;
 tmpList:       tpTeData;
begin
 Tabbednotebook1.pageindex:=XML_DISPLAY.StInputDlgPageIndex;
 listbox1.clear;  
 combobox2.clear;  combobox3.clear;  combobox4.clear;
 for i:=1 to XML_STUDENTS.numstud do listbox1.items.add(XML_STUDENTS.Stud[i].stname+' '+XML_STUDENTS.Stud[i].first);
 label6.caption:=inttostr(listbox1.items.count);
 listbox3.clear; 
 for i:=1 to codeCount[0] do listbox3.items.add(SubCode[codepoint[i,0]]);
 label16.caption:=inttostr(listbox3.items.count);

 FillComboRollClass(combobox1,tmpclass,radiobutton7);

 combobox2.items.add('All houses');
 j:=0;
  for i:=1 to housecount do
   if trim(housename[i])>'' then
   begin
    combobox2.items.add(housename[i]);
    inc(j);
   end;
  if bool(j) then
  begin
   combobox2.itemindex:=tmphouse;
   combobox2.update;
  end
  else
   radiobutton8.enabled:=false;

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
     combobox3.items.add(XML_TEACHERS.tecode[k,0]+'   '
     +XML_TEACHERS.TeName[k,0]);
     inc(i2);
    end;
    if k=tmptutor then j:=i2;
   end;
   if tmptutor=0 then combobox3.itemindex:=0
    else combobox3.itemindex:=j;
   combobox3.update;
  end
  else
   radiobutton9.enabled:=false;

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
     combobox4.items.add(XML_TEACHERS.tecode[k,1]+'   '
     +XML_TEACHERS.TeName[k,1]);
     inc(i2);
    end;
    if k=tmproom then j:=i2;
   end;

   if tmproom=0 then combobox4.itemindex:=0
    else combobox4.itemindex:=j;
   combobox4.update;
  end
  else
   radiobutton10.enabled:=false;

 combobox5.Clear;
 combobox5.items.add('(None)');
 OfferGOSindex:=0;  OfferGOSname:='';
 if GOSnum>0 then
  for i:=1 to GOSnum do
   begin
    combobox5.items.add(GOSname[i]);
    if GOSname[i]=groupname then
     begin
      OfferGOSindex:=i;
      OfferGOSname:=groupname;
     end;
   end;
 combobox5.itemindex:=OfferGOSindex;

 edit1.text:=inttostr(tmppref1);
 edit2.text:=inttostr(tmppref2);

 listbox2.clear;
  if tmpStug[0]>0 then
   try
    for i:=1 to tmpStug[0] do
     listbox2.items.add(XML_STUDENTS.Stud[tmpStug[i]].stname+' '+XML_STUDENTS.Stud[tmpStug[i]].first);
   except
   end;
  label7.caption:=inttostr(listbox2.items.count);

 updatethisdlg;
end;

procedure Tstudentinputdlg.OKBtnClick(Sender: TObject);
var
 i:       integer;
begin
 XML_DISPLAY.StInputDlgPageIndex:=Tabbednotebook1.pageindex;
 {validate if necess.}
 if (tmpShow1<>1) and (tmpShow1<>4) then
  begin
   IntRange(tmppref1,1,nmbrchoices);
   IntRange(tmppref2,0,nmbrchoices);
  end; 
 if InvalidEntry(tmpPref1,1,nmbrchoices,'number for first preferences',edit1) then exit;
 if InvalidEntry(tmpPref2,0,nmbrchoices,'number for second preferences',edit2) then exit;
 {ok}
 UpdateMyOffer;
 for i:=0 to nmbrstudents do
  XML_DISPLAY.StudentInputSelection[i]:=tmpStug[i];

 tmpclass:=findclass2(combobox1.text);
 if combobox3.text='All tutors' then
  tmptutor:=0
 else
  tmptutor:=findtutor2(copy(combobox3.text,1,lencodes[1]));
 tmphouse:=findhouse2(combobox2.text);
 if combobox4.text='All home rooms' then
  tmproom:=0
 else
  tmproom:=findroom2(copy(combobox4.text,1,lencodes[2]));
 XML_DISPLAY.StInputPref1:=tmppref1;
 XML_DISPLAY.StInputPref2:=tmppref2;
 XML_DISPLAY.StInputClass:=tmpclass;
 XML_DISPLAY.StInputHouse:=tmphouse;
 XML_DISPLAY.StInputTutor:=tmptutor;
 XML_DISPLAY.StInputRoom:=tmproom;
 XML_DISPLAY.studentinputshow1:=tmpshow1;
 XML_DISPLAY.studentinputshow2:=tmpshow2;
 winView[wnStInput]:=XML_DISPLAY.StudentInputShow1;
 OKflag:=true;
 close;
 UpdateWindow(wnStInput);
end;

procedure Tstudentinputdlg.CancelBtnClick(Sender: TObject);
begin
 close;
end;

procedure Tstudentinputdlg.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpStug,listbox2,label7);
end;

procedure Tstudentinputdlg.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpStug,listbox2,label7);
end;

procedure Tstudentinputdlg.BitBtn3Click(Sender: TObject);
begin
 MoveOnStudList(tmpStug,listbox1,listbox2,label7,false);
end;

procedure Tstudentinputdlg.BitBtn4Click(Sender: TObject);
begin
 FillStudList(tmpStug,listbox1,listbox2,label7,false);
end;

procedure Tstudentinputdlg.Edit1Change(Sender: TObject);
begin
 tmppref1:=strtointdef(edit1.text,1);
end;

procedure Tstudentinputdlg.Edit2Change(Sender: TObject);
begin
 tmppref2:=strtointdef(edit2.text,1);
end;

procedure Tstudentinputdlg.BitBtn5Click(Sender: TObject);
begin
 MoveOffList(tmpSubg,listbox4,label17);
end;

procedure Tstudentinputdlg.BitBtn6Click(Sender: TObject);
begin
 ClearList(tmpSubg,listbox4,label17);
end;

procedure Tstudentinputdlg.BitBtn7Click(Sender: TObject);
begin
 MoveOnSubList(tmpSubg,listbox3,listbox4,label17,0);
end;

procedure Tstudentinputdlg.BitBtn8Click(Sender: TObject);
begin
 FillSubList(tmpSubg,listbox3,listbox4,label17,0);
end;

procedure Tstudentinputdlg.BitBtn9Click(Sender: TObject);
var
 i,j,k:     integer;
 tmpAr:   array[0..nmbrsubjects] of string[10];
 astr:    string;


     function usedITalready(aa: string):integer;
     var
      i: integer;
      astr,bstr: string;
     begin
      aStr:=trim(copy(aa,1,(lencodes[0]-1)));
      result:=0;
      if j>0 then
       for i:=1 to j do
       begin
        bStr:=trim(copy(tmpar[i],1,(lencodes[0]-1)));
        if astr=bstr then
        begin
         result:=i;
         tmpar[i]:=bstr;
         break;
        end;
       end; {for i}
     end;

begin
  for i:=1 to codeCount[0] do tmpAr[i]:=space(10);
  listbox4.clear; j:=0;     tmpSubg[0]:=0;
  for i:=1 to GroupSubs[0] do
  begin
   k:=GroupSubs[i];
   aStr:=trim(SubCode[k]);
   if usedITalready(aStr)=0 then
   begin
    inc(j);
    tmpar[j]:=astr;
    inc(tmpSubg[0]);
    tmpSubg[j]:=k;
   end;
  end; {for i}
  for i:=1 to j do
   listbox4.items.add(tmpar[i]);

  label17.caption:=inttostr(listbox4.items.count);
end;

procedure Tstudentinputdlg.ShowSubs1Click(Sender: TObject);
begin
 tmpshow1:=ShowSubs1.ItemIndex;
 edit1.enabled:=(tmpShow1<>1) and (tmpShow1<>4);
 edit2.enabled:=(tmpShow1<>1) and (tmpShow1<>4);
end;

procedure Tstudentinputdlg.CheckBox1Click(Sender: TObject);
begin
 Listbox4.Sorted:=CheckBox1.Checked;
 UpBtn.Enabled:=not(CheckBox1.Checked);
 DnBtn.Enabled:=not(CheckBox1.Checked);
end;

procedure Tstudentinputdlg.CheckBox2Click(Sender: TObject);
begin
 OfferBlockFlag:=CheckBox2.Checked;
 listbox3.Enabled:=not(OfferBlockFlag);
 listbox4.Enabled:=not(OfferBlockFlag);
 BitBtn5.Enabled:=not(OfferBlockFlag);
 BitBtn6.Enabled:=not(OfferBlockFlag);
 BitBtn7.Enabled:=not(OfferBlockFlag);
 BitBtn8.Enabled:=not(OfferBlockFlag);
 BitBtn9.Enabled:=not(OfferBlockFlag);
 UpBtn.Enabled:=not(OfferBlockFlag);
 DnBtn.Enabled:=not(OfferBlockFlag);
 checkbox1.Enabled:=not(OfferBlockFlag);
end;

procedure Tstudentinputdlg.UpDown2Click(Sender: TObject;
  Button: TUDBtnType);
var
 i,oldSections: smallint;
begin
 oldSections:=OfferSections;
 OfferSections:=UpDown2.Position;
 SetSubOfferArrays;
 if OfferSections>oldSections then
  for i:=oldSections+1 to OfferSections do
 OfferSubs[i,0]:=0;
 if UpDown1.Position>OfferSections then
 if UpDown1.Position>OfferSections then 
  begin
   UpDown1.Position:=OfferSections;
   UseSection:=OfferSections;
   ReshowSection;
  end;
 UpDown1.Max:=OfferSections;
end;

procedure Tstudentinputdlg.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpSubg,ListBox4);
end;

procedure Tstudentinputdlg.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpSubg,ListBox4);
end;

procedure Tstudentinputdlg.UpDown1Click(Sender: TObject;
  Button: TUDBtnType);
begin
 UpdateMyOffer;
end;

procedure ReadBlockOfferFile;
var
 f:       file;
 fn,strA: string;
 i,j,b,m,count:       smallint;
 tmpFix,blockyear:     smallint;
begin
 if (OfferBlocks='') then exit;
 chdir(Directories.datadir);
 fn:=OfferBlocks+'.BLK';
 if not(fileexists(fn)) then exit;
 try
  try
   assign(f,fn);
   filemode:=fmOpenRead+fmShareDenyNone;
   reset(f,1);
   blockread(f,blockyear,2);
   blockread(f,OfferSections,2);
   IntRange(OfferSections,2,nmbrBlocks);
   blockread(f,OfferSubMax,2);
   SetSubOfferArrays;
   for i:=1 to OfferSections do
    begin
     blockread(f,m,2);
     blockread(f,tmpFix,2);
     OfferTitle[i]:='Block '+inttostr(i);
     OfferDesc[i]:='Select one subject from block '+inttostr(i);
     if m>0 then
      begin
       count:=0;
       for j:=1 to m do
        begin
         blockread(f,b,2);
         strA:=copy(SubCode[b],1,2);
         if ((strA<>'00') and (b>0) and (b<=NumCodes[0])) then
         begin
          inc(count);
          OfferSubs[i,count]:=b;
         end;
        end;  {for j}
       OfferSubs[i,0]:=count;
      end; {if m>0}
    end; {for i}
  finally
   closefile(f);
  end;
 except
 end;
end;


procedure Tstudentinputdlg.OpenBtn1Click(Sender: TObject);
var
 msg:     string;
 strA,tmpDir,tmpFile:    string;
begin
 mainForm.opendialog.defaultext:='SBO';
 mainForm.opendialog.filename:='';
 if OfferBlockFlag then
  begin
   mainForm.opendialog.filter:='Block Files|*.BLK';
   mainForm.opendialog.title:='Open Blocks for Subjects Offered';
  end
 else
  begin
   mainForm.opendialog.filter:='Subject Offer Files|*.SBO';
   mainForm.opendialog.title:='Open Subject Offer File';
  end;
 mainform.OpenDialog.HelpContext:=363;
 mainForm.opendialog.initialdir:=Directories.datadir;
 mainForm.opendialog.options:=[ofFileMustExist,ofHideReadOnly,ofPathMustExist];
 if mainForm.opendialog.Execute then
  begin
    tmpFile:=ExtractFilename(mainForm.opendialog.FileName);
    strA:= mainForm.opendialog.FileName;
    tmpDir:=GetDirName(strA);
    if uppercase(tmpDir)<>uppercase(Directories.Datadir) then
     begin
       msg:='Subjects offered must be opened from'+endline;
       msg:=msg+'current data folder.';
       messagedlg(msg,mtError,[mbOK],0);
       exit;
      end;
    tmpFile:=RemoveExtension(tmpFile);
    if OfferBlockFlag then
     begin
      OfferBlocks:=tmpFile;
      ReadBlockOfferFile;
     end
    else
     begin
      OfferFile:=tmpFile;
      ReadSubOfferFile;
     end;
    InitMyOffer;
    UpdateMyOffer;
  end;
end;

procedure WriteSubOfferFile;
var
 fname,tname: string;
 i,j,a,m,SubMax1:       smallint;
begin
 if (OfferFile='') or ((OfferBlocks='') and OfferBlockFlag) then exit;
 SubMax1:=1;
 for i:= 1 to OfferSections do
  if OfferSubs[i,0]>SubMax1 then SubMax1:=OfferSubs[i,0];
 chdir(Directories.datadir);
 try
  try
   fname:=OfferFile+'.SBO';
   tname:=OfferFile+'.TMP';
   ourSafetyMemStreamStr:='';
   ourSafetyMemStream:=TStringStream.Create(ourSafetyMemStreamStr);
   with ourSafetyMemStream do
    begin
     write(OfferBlockFlag,sizeof(OfferBlockFlag));
     write(OfferSections,sizeof(OfferSections));
     write(SubMax1,sizeof(SubMax1));
     a:=length(OfferGOSname);
     write(a,sizeof(a));
     if a>0 then write(Pchar(@OfferGOSname[1])^,a);
     if OfferBlockFlag then {using blockfile}
      begin
       a:=length(OfferBlocks);
       write(a,sizeof(a));
       write(Pchar(@OfferBlocks[1])^,a);
      end
     else
       for i:=1 to OfferSections do
        begin
         m:=OfferSubs[i,0];
         write(m,2);
         if m>0 then for j:=1 to m do write(OfferSubs[i,j],2);
        end;
     for i:=1 to OfferSections do
      begin
       a:=length(OfferTitle[i]);
       write(a,sizeof(a));
       if a>0 then write(Pchar(@OfferTitle[i][1])^,a);
       a:=length(OfferDesc[i]);
       write(a,sizeof(a));
       if a>0 then write(Pchar(@OfferDesc[i][1])^,a);
      end;

    end;
   SafelyStreamToFile(tname,fname);
  finally
   ourSafetyMemStream.Free;
  end;
 except
 end;
end;


procedure Tstudentinputdlg.SaveBtn1Click(Sender: TObject);
var
 tmpStr,tmpDir,tmpFile,msg:  string;
 i,SubMax1:       integer;
begin
 UpdateMyOffer;
 SubMax1:=0;
 for i:=1 to OfferSections do
  if OfferSubs[i,0]>SubMax1 then SubMax1:=OfferSubs[i,0];
 if SubMax1<1 then
  begin
   msg:='No subjects offered.';
   messagedlg(msg,mtError,[mbOK],0);
   exit;
  end;
 Mainform.SaveDialog.Title:='Save Subject Offer File';
 Mainform.SaveDialog.HelpContext:=362;
 Mainform.SaveDialog.Filter:='Subject Offer|*.SBO';
 Mainform.SaveDialog.InitialDir:=Directories.datadir;
 tmpStr:=OfferFile;
 if tmpStr='' then tmpStr:=OfferGOSname;
 Mainform.SaveDialog.Filename:=tmpStr;
 Mainform.SaveDialog.DefaultExt:='SBO';
 if Mainform.SaveDialog.Execute then
  begin
   tmpFile:=ExtractFileName(Mainform.SaveDialog.Filename);
   tmpFile:=RemoveExtension(tmpFile);
   tmpStr:=mainForm.Savedialog.FileName;
   tmpDir:=GetDirName(tmpStr);
    if uppercase(tmpDir)<>uppercase(Directories.Datadir) then
     begin
       msg:='Subjects offered must be saved to '+endline;
       msg:=msg+'current data folder.';
       messagedlg(msg,mtError,[mbOK],0);
       exit;
      end;
   OfferFile:=tmpFile;
   WriteSubOfferFile;
   if (OfferGOSindex>0) and (OfferGOSindex<=GOSnum) and (OfferFile>'') then
    begin
     GOS[OfferGOSindex].SubOfferName:=OfferFile;
     savegroups;
    end;
   OfferName.Caption:=OfferFile;
  end;
end;

procedure Tstudentinputdlg.ComboBox5Change(Sender: TObject);
begin
 OfferGOSindex:=comboBox5.ItemIndex;
 if  OfferGOSindex>0 then OfferGOSname:=comboBox5.Text;
end;

procedure Tstudentinputdlg.BitBtn10Click(Sender: TObject);
begin
 MoveUpList(tmpStug,ListBox2);
end;

procedure Tstudentinputdlg.BitBtn11Click(Sender: TObject);
begin
 MoveDownList(tmpStug,ListBox2);
end;

end.
