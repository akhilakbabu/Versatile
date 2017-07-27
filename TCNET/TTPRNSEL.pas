unit Ttprnsel;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, TimeChartGlobals, XML.DISPLAY, XML.TEACHERS;

type
  Tttprintselectiondlg = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ComboBox1: TComboBox;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    ComboBox3: TComboBox;
    Label6: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure CancelbuttonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
  private
    procedure UpdateThisDlg;
    procedure RestoreList2FromArray;
  end;

var
  ttprintselectiondlg: Tttprintselectiondlg;

implementation
uses tcommon,tcommon2,DlgCommon;
{$R *.DFM}
type
 tpTmpArray=array of smallint;

var
 tmpSubg,tmpTeachg,tmpRoomg,TmpArr:     tpTmpArray;
 tmptype:       integer;
 tmpfacnum:     integer;
 tmpyearnum:    integer;
 tmpmaintype:   integer;

function GetTmpArr: tpTmpArray;
begin
 result:=tmpSubg; {sub}
 case tmptype of
  3: result:=tmpTeachg; {teach}
  4: result:=tmpRoomg   {room}
 end; {case}
end;


procedure Tttprintselectiondlg.RestoreList2FromArray;
var
 i:   integer;
begin
  TmpArr:=GetTmpArr;
 if TmpArr[0]>0 then
  for i:=1 to TmpArr[0] do
   listbox2.items.add(FNsub(TmpArr[i],tmptype-2));
 label5.caption:=inttostr(listbox2.items.count);
end;



procedure Tttprintselectiondlg.UpdateThisDlg;
var
 i:    integer;
begin
 combobox1.color:=clWindow; listbox1.color:=clwindow; listbox2.color:=clwindow;
 combobox1.enabled:=false;  listbox1.enabled:=false;  listbox2.enabled:=false;
 bitbtn1.enabled:=false; bitbtn2.enabled:=false;
 bitbtn3.enabled:=false; bitbtn4.enabled:=false;
 combobox3.color:=clWindow; combobox3.enabled:=false;
 radiobutton7.caption:=yeartitle;
 label1.caption:=''; label2.caption:='';  label4.caption:=''; label5.caption:='';
 listbox1.clear; listbox2.clear;  
 FillComboYears(false,ComboBox3);
 combobox3.itemindex:=tmpyearnum;
 FillComboFaculty(true,combobox1);
 combobox1.itemindex:=tmpfacnum;

 case tmpmaintype of {main or year/form tt}
  1: HiLiteCombo(combobox3);
 end; {case}

 if (tmptype>1) and (tmptype<5) then
  begin
   HiLiteList(listbox1);  HiLiteList(listbox2);
   bitbtn1.enabled:=true; bitbtn2.enabled:=true;
   bitbtn3.enabled:=true; bitbtn4.enabled:=true;
   RestoreList2FromArray;
  end;
 case tmptype of
  2: begin  {sub group}
      label1.caption:='&Subjects'; label2.caption:='Subjects se&lected';
      for i:=1 to codeCount[0] do listbox1.items.add(subcode[codepoint[i,0]]);
      label4.caption:=inttostr(listbox1.items.count);
     end;
  3: begin  {teach group}
      label1.caption:='&Teachers'; label2.caption:='Teachers se&lected';
      for i:=1 to codeCount[1] do listbox1.items.add(XML_TEACHERS.tecode[codepoint[i,1],0]);
      label4.caption:=inttostr(listbox1.items.count);
     end;
  4: begin  {room group}
      label1.caption:='&Rooms'; label2.caption:='Rooms se&lected';
      for i:=1 to codeCount[2] do listbox1.items.add(XML_TEACHERS.tecode[codepoint[i,2],1]);
      label4.caption:=inttostr(listbox1.items.count);
     end;
  5: HiLiteCombo(combobox1);  {faculty}
 end; {case}
end;


procedure Tttprintselectiondlg.RadioButton1Click(Sender: TObject);
begin
 tmptype:=1;
 updatethisdlg;
end;

procedure Tttprintselectiondlg.RadioButton2Click(Sender: TObject);
begin
 tmptype:=2;
 updatethisdlg;
end;

procedure Tttprintselectiondlg.RadioButton3Click(Sender: TObject);
begin
 tmptype:=3;
 updatethisdlg;
end;

procedure Tttprintselectiondlg.RadioButton4Click(Sender: TObject);
begin
 tmptype:=4;
 updatethisdlg;
end;

procedure Tttprintselectiondlg.RadioButton5Click(Sender: TObject);
begin
 tmptype:=5;
 updatethisdlg;
end;

procedure Tttprintselectiondlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure Tttprintselectiondlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure Tttprintselectiondlg.OKbuttonClick(Sender: TObject);
var
i: integer;
begin
 for i:=0 to tmpSubg[0]+1 do XML_DISPLAY.ttPrntSelSubg[i]:=tmpSubg[i];
 for i:=0 to tmpTeachg[0]+1 do XML_DISPLAY.ttPrntSelTeachg[i]:=tmpTeachg[i];
 for i:=0 to tmpRoomg[0]+1 do XML_DISPLAY.ttprntselroomg[i]:=tmpRoomg[i];
 XML_DISPLAY.ttprntseltype:=tmptype;
 XML_DISPLAY.ttPrntFac:=tmpfacnum;
 XML_DISPLAY.ttPrntType:=tmpmaintype;
 XML_DISPLAY.ttprntselyear:=tmpyearnum;
 close;
end;

procedure Tttprintselectiondlg.FormActivate(Sender: TObject);
begin
 updatethisdlg;
 case XML_DISPLAY.ttPrntType of
  0: radiobutton6.checked:=true;
  1: radiobutton7.checked:=true;
 end; {case}
 case XML_DISPLAY.ttprntseltype of
  1: radiobutton1.checked:=true;
  2: radiobutton2.checked:=true;
  3: radiobutton3.checked:=true;
  4: radiobutton4.checked:=true;
  5: radiobutton5.checked:=true;
 end; {case}
 combobox1.itemindex:=XML_DISPLAY.ttPrntFac;
 combobox3.itemindex:=XML_DISPLAY.ttprntselyear;
end;

procedure Tttprintselectiondlg.BitBtn1Click(Sender: TObject);
begin
 TmpArr:=GetTmpArr;
 MoveOffList(TmpArr,listbox2,label5);
end;

procedure Tttprintselectiondlg.BitBtn2Click(Sender: TObject);
begin
 TmpArr:=GetTmpArr;
 ClearList(TmpArr,listbox2,label5);
end;

procedure Tttprintselectiondlg.BitBtn3Click(Sender: TObject);
begin
 TmpArr:=GetTmpArr;
 MoveOnSubList(TmpArr,listbox1,listbox2,label5,tmptype-2);
end;

procedure Tttprintselectiondlg.BitBtn4Click(Sender: TObject);
begin
 TmpArr:=GetTmpArr;
 FillSubList(TmpArr,listbox1,listbox2,label5,tmptype-2);
end;

procedure Tttprintselectiondlg.FormCreate(Sender: TObject);
var
 i:       integer;
begin
 SetLength(tmpSubg,10+numcodes[0]);
 rangeCheckSubSels(XML_DISPLAY.ttPrntSelSubg);
 for i:=0 to codeCount[0] do tmpSubg[i]:=XML_DISPLAY.ttPrntSelSubg[i];
 IntRange(tmpSubg[0],0,numcodes[0]);

 SetLength(tmpTeachg,10+numcodes[1]);
 rangeCheckCodeSels(XML_DISPLAY.ttPrntSelTeachg,1);
 for i:=0 to codeCount[1] do tmpTeachg[i]:=XML_DISPLAY.ttPrntSelTeachg[i];
 IntRange(tmpTeachg[0],0,numcodes[1]);

 SetLength(tmpRoomg,10+numcodes[2]);
 rangeCheckCodeSels(XML_DISPLAY.ttprntselroomg,2);
 for i:=0 to codeCount[2] do tmpRoomg[i]:=XML_DISPLAY.ttprntselroomg[i];
 IntRange(tmpRoomg[0],0,numcodes[2]);

 tmptype:=XML_DISPLAY.ttprntseltype;
 tmpfacnum:=XML_DISPLAY.ttPrntFac;

 tmpyearnum:=XML_DISPLAY.ttprntselyear;
 tmpmaintype:=XML_DISPLAY.ttPrntType;
 radiobutton7.hint:=yeartitle+' timetable';
end;

procedure Tttprintselectiondlg.ComboBox1Change(Sender: TObject);
begin
 tmpfacnum:=combobox1.itemindex;
end;

procedure Tttprintselectiondlg.ComboBox3Change(Sender: TObject);
begin
 tmpyearnum:=combobox3.itemindex;
end;

procedure Tttprintselectiondlg.RadioButton6Click(Sender: TObject);
begin
 tmpmaintype:=0;
 updatethisdlg;
end;

procedure Tttprintselectiondlg.RadioButton7Click(Sender: TObject);
begin
 tmpmaintype:=1;
 updatethisdlg;
end;


procedure Tttprintselectiondlg.UpBtnClick(Sender: TObject);
begin
 TmpArr:=GetTmpArr;
 MoveUpList(TmpArr,ListBox2);
end;

procedure Tttprintselectiondlg.DnBtnClick(Sender: TObject);
begin
 TmpArr:=GetTmpArr;
 MoveDownList(TmpArr,ListBox2);
end;

end.
