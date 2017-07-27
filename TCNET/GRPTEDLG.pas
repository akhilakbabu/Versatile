unit Grptedlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, TimeChartGlobals,GlobalToTcAndTcextra,
  XML.DISPLAY;

type
  TGroupofteachersdlg = class(TForm)
    GroupBox1: TGroupBox;
    RadioGroup1: TRadioGroup;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ComboBox2: TComboBox;
    Label2: TLabel;
    ComboBox3: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ComboBox4: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    Edit1: TEdit;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelbuttonClick(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
  private
    procedure updatehighlights;
  end;

var
  Groupofteachersdlg: TGroupofteachersdlg;

implementation
uses tcommon,DlgCommon,tcommon2;
{$R *.DFM}
var
 tmpSubg:      tpSubData;
 tmpyear,tmpday,tmpclass,tmpfac,tmptimes:           integer;
 tmptype:                                              integer;



procedure TGroupofteachersdlg.updatehighlights;
begin
 edit1.color:=clwindow; edit1.enabled:=false;
 listbox1.color:=clwindow; listbox1.enabled:=false;
 listbox2.color:=clwindow; listbox2.enabled:=false;
 bitbtn1.enabled:=false; bitbtn2.enabled:=false;
 bitbtn3.enabled:=false; bitbtn4.enabled:=false;
 UpBtn.Enabled:=false; DnBtn.Enabled:=false;
 combobox2.color:=clwindow; combobox2.enabled:=false;
 combobox3.color:=clwindow; combobox3.enabled:=false;
 combobox4.color:=clwindow; combobox4.enabled:=false;
 HiLiteCombo(combobox1);
 case tmptype of
  0: begin  {class}
      HiLiteCombo(combobox2);
     end;
  1: begin  {sub group}
      HiLiteList(listbox1);  HiLiteList(listbox2);
      bitbtn1.enabled:=true; bitbtn2.enabled:=true;
      bitbtn3.enabled:=true; bitbtn4.enabled:=true;
      UpBtn.Enabled:=true; DnBtn.Enabled:=true;
     end;
  2: begin  {fac}
      HiLiteCombo(combobox3);
     end;
  3: begin  {number of times}
      HiLiteCombo(combobox4);
      combobox1.color:=clwindow; combobox1.enabled:=false;
      HiLiteEdit(edit1);
     end;
  end; {case}
end;




procedure TGroupofteachersdlg.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpSubg,listbox2,label7);
end;

procedure TGroupofteachersdlg.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpSubg,listbox2,label7);
end;

procedure TGroupofteachersdlg.BitBtn3Click(Sender: TObject);
begin
 MoveOnSubList(tmpSubg,listbox1,listbox2,label7,0);
end;

procedure TGroupofteachersdlg.BitBtn4Click(Sender: TObject);
begin
 FillSubList(tmpSubg,listbox1,listbox2,label7,0);
end;

procedure TGroupofteachersdlg.RadioGroup1Click(Sender: TObject);
var
 i,j,oldtype:       integer;
begin
 oldtype:=tmptype;
 tmptype:=RadioGroup1.itemindex;

 j:=tmpyear;
 combobox1.clear;
 if tmptype<>0 then combobox1.items.add('All years');
 for i:=1 to years do combobox1.items.add(yearname[i-1]);
 tmpyear:=j;
 if (oldtype<>0) then if (tmptype=0) then dec(tmpyear);
 if (oldtype=0) then if (tmptype<>0) then inc(tmpyear);
 combobox1.itemindex:=tmpyear;
 updatehighlights;
end;

procedure TGroupofteachersdlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=cafree;
end;

procedure TGroupofteachersdlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure TGroupofteachersdlg.OKbuttonClick(Sender: TObject);
var
 i,j:      integer;
 astr:        string;
begin
 tmpday:=findday(combobox4.text)+1;
 astr:=uppercase(trim(combobox4.text));
 if tmpday=0 then
  if ((astr<>'*') and (astr<>uppercase(combobox4.items[0]))) then
  begin
   ComboMsg('Check day selected',ComboBox4);
   exit;
  end;

 XML_DISPLAY.grpofteyear:=tmpyear;
 XML_DISPLAY.grpofteclass:=tmpclass;
 XML_DISPLAY.grpoftefac:=tmpfac;
 XML_DISPLAY.grpofteday:=tmpday;
 XML_DISPLAY.grpoftetimes:=tmptimes;
 winView[wnGroupTe]:=tmptype;
 XML_DISPLAY.GrpOfTeSelSubg[0]:=0;
 j:=tmpSubg[0];
 if j>0 then
  for i:=0 to j do
      XML_DISPLAY.GrpOfTeSelSubg[i]:=tmpSubg[i];
 close;
 UpdateWindow(wnGroupTe);
end;

procedure TGroupofteachersdlg.FormCreate(Sender: TObject);
begin
 fillchar(tmpSubg,sizeof(tmpSubg),chr(0));
 label1.caption:='&'+Yeartitle;
end;

procedure TGroupofteachersdlg.FormActivate(Sender: TObject);
var
 i,j,cc:  integer;
begin
 edit1.text:=inttostr(XML_DISPLAY.grpoftetimes);
 rangeCheckSubSels(XML_DISPLAY.GrpOfTeSelSubg);
 j:=XML_DISPLAY.GrpOfTeSelSubg[0];
 if j>0 then
  for i:=0 to j do tmpSubg[i]:=XML_DISPLAY.GrpOfTeSelSubg[i];
 radiogroup1.itemindex:=winView[wnGroupTe];

 tmpyear:=XML_DISPLAY.grpofteyear;
 tmpclass:=XML_DISPLAY.grpofteclass;
 tmpfac:=XML_DISPLAY.grpoftefac;
 tmpday:=XML_DISPLAY.grpofteday;
 tmptimes:=XML_DISPLAY.grpoftetimes;
 tmptype:=winView[wnGroupTe];

 combobox1.color:=clWindow; listbox1.color:=clwindow; listbox2.color:=clwindow;
 combobox1.enabled:=false;  listbox1.enabled:=false;  listbox2.enabled:=false;
 combobox1.hint:='Select '+yeartitle;
 combobox2.color:=clwindow; combobox2.enabled:=false;
 combobox3.color:=clwindow; combobox3.enabled:=false;
 combobox4.color:=clwindow; combobox4.enabled:=false;
 edit1.color:=clwindow; edit1.enabled:=false;

 bitbtn1.enabled:=false; bitbtn2.enabled:=false;
 bitbtn3.enabled:=false; bitbtn4.enabled:=false;
 UpBtn.Enabled:=false; DnBtn.Enabled:=false;
 listbox1.clear; listbox2.clear;  combobox1.clear;
 combobox2.clear;
 FillComboDays(true,ComboBox4);
 if tmpday=-1 then
   combobox4.itemindex:=0
  else
   combobox4.itemindex:=tmpday;
 combobox4.update;
 ComboBox1.DropDownCount:=nmbrYears+1;
 if tmptype<>0 then combobox1.items.add('All years');
 for i:=1 to years do combobox1.items.add(yearname[i-1]);
 combobox1.itemindex:=tmpyear;

 combobox2.items.add('All classes');

 for i:=1 to level[XML_DISPLAY.grpofteyear] do
  begin
   cc:=ClassShown[i,XML_DISPLAY.grpofteyear];
   if trim(ClassCode[cc])>'' then combobox2.items.add(ClassCode[cc])
    else combobox2.items.add('Level '+inttostr(i));
  end; {for i}

 combobox2.itemindex:=tmpclass;
 FillComboFaculty(true,combobox3);
 combobox3.itemindex:=tmpfac;

 for i:=1 to codeCount[0] do
  listbox1.items.add(subcode[codepoint[i,0]]);
 if tmpSubg[0]>0 then
   for i:=1 to tmpSubg[0] do
    listbox2.items.add(subcode[tmpSubg[i]]);
 label6.caption:=inttostr(listbox1.items.count);
 label7.caption:=inttostr(listbox2.items.count);
 updatehighlights;
 Groupofteachersdlg.update;
end;

procedure TGroupofteachersdlg.ComboBox1Change(Sender: TObject);
var
 i,cc:       integer;
begin
 tmpyear:=combobox1.itemindex;
 if tmptype=0 then
  begin
   combobox2.clear;
   combobox2.items.add('All classes');
   for i:=1 to level[tmpyear] do
    begin
     cc:=ClassShown[i,tmpyear];
     if trim(ClassCode[cc])>'' then combobox2.items.add(ClassCode[cc])
      else combobox2.items.add('Level '+inttostr(i));
    end; {for i}
   combobox2.itemindex:=0;
  end;
end;

procedure TGroupofteachersdlg.ComboBox2Change(Sender: TObject);
begin
 tmpclass:=combobox2.itemindex;
end;

procedure TGroupofteachersdlg.ComboBox3Change(Sender: TObject);
begin
 tmpfac:=combobox3.itemindex;
end;

procedure TGroupofteachersdlg.ComboBox4Change(Sender: TObject);
begin
 tmpday:=combobox4.itemindex;
end;

procedure TGroupofteachersdlg.Edit1Change(Sender: TObject);
begin
 tmptimes:=strtointdef(edit1.text,1);
end;

procedure TGroupofteachersdlg.Edit1KeyPress(Sender: TObject;
  var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TGroupofteachersdlg.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpSubg,ListBox2);
end;

procedure TGroupofteachersdlg.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpSubg,ListBox2);
end;

end.
