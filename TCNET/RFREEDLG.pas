unit Rfreedlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, TimeChartGlobals,GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  TRoomsfreedlg = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure CancelbuttonClick(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
  private
    procedure FillTimeSlots;
    procedure CheckRadioButtons;
  end;

var
  Roomsfreedlg: TRoomsfreedlg;

implementation
uses tcommon,DlgCommon,tcommon2;
{$R *.DFM}

var
 tmpsel:  tpTeData;
 duringload: bool;
 UseDay: smallint;


procedure TRoomsfreedlg.CheckRadioButtons;
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
end;

procedure TRoomsfreedlg.FillTimeSlots;
var
 j:     integer;
begin
 if NumDayGroups=1 then j:=0 else j:=Combobox1.ItemIndex-1;
 if j<0 then j:=0;
 FillComboTimeSlots(true,j,combobox3);
end;


procedure TRoomsfreedlg.FormCreate(Sender: TObject);
var
 i:     integer;
begin
 duringload:=true;   label12.caption:='';
 UseDay:=XML_DISPLAY.RoomsFreeDay;
 If UseDay<0 then UseDay:=0;
 XML_DISPLAY.Roomsfreeshow1:=winView[wnRoFree]+1;
 FillComboDays(true,ComboBox1);
 ComboBox3.DropDownCount:=periods+1;
 FillComboFaculty(false,combobox2);
 listbox1.clear;
 for i:=1 to codeCount[2] do listbox1.items.add(XML_TEACHERS.tecode[codepoint[i,2],1]);
 listbox2.clear;
 {add saved selection here}

 rangeCheckCodeSels(XML_DISPLAY.RoomsFreeSelection,2);
 for i:=0 to nmbrteachers do
      tmpSel[i]:=XML_DISPLAY.RoomsFreeSelection[i];

 case XML_DISPLAY.roomsfreeshow1 of
  1: radiobutton1.checked:=true;
  2: radiobutton2.checked:=true;
  3: radiobutton3.checked:=true;
 end;

 case XML_DISPLAY.roomsfreeshow2 of
  1: radiobutton6.checked:=true;
  2: radiobutton7.checked:=true;
 end;

 duringload:=false;
end;

procedure TRoomsfreedlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure TRoomsfreedlg.OKbuttonClick(Sender: TObject);
var
i:  integer;
begin
 if combobox1.enabled then
  if XML_DISPLAY.roomsfreeday=-2 then
  begin
   ComboMsg('Check day selected',ComboBox1);
   exit;
  end;
 if combobox3.enabled then
  if XML_DISPLAY.roomsfreePeriod<0 then
  begin
   ComboMsg('Check time slot selected',ComboBox3);
   exit;
  end;

 for i:=0 to nmbrteachers do
    XML_DISPLAY.RoomsFreeSelection[i]:=tmpSel[i];

 if radiobutton1.checked then
    XML_DISPLAY.roomsfreeshow1:=1
  else if radiobutton2.checked then
      XML_DISPLAY.roomsfreeshow1:=2
   else if radiobutton3.checked then
      XML_DISPLAY.roomsfreeshow1:=3;
 if radiobutton6.checked then
    XML_DISPLAY.roomsfreeshow2:=1
  else if radiobutton7.checked then
      XML_DISPLAY.roomsfreeshow2:=2;
 winView[wnRoFree]:=XML_DISPLAY.roomsfreeshow1-1;
 close;
 UpdateWindow(wnRoFree);
end;

procedure TRoomsfreedlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TRoomsfreedlg.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpSel,listbox2,label7);
end;

procedure TRoomsfreedlg.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpSel,listbox2,label7);
end;

procedure TRoomsfreedlg.BitBtn3Click(Sender: TObject);
begin
 MoveOnSubList(tmpSel,listbox1,listbox2,label7,2);
end;

procedure TRoomsfreedlg.BitBtn4Click(Sender: TObject);
begin
 FillSubList(tmpSel,listbox1,listbox2,label7,2);
end;

procedure TRoomsfreedlg.FormActivate(Sender: TObject);
var
 i: integer;
begin
 listbox1.clear; listbox2.clear;
 for i:=1 to codeCount[2] do
   listbox1.items.add(XML_TEACHERS.tecode[codepoint[i,2],1]);
 if tmpSel[0]>0 then
   for i:=1 to tmpSel[0] do
    listbox2.items.add(XML_TEACHERS.tecode[tmpSel[i],1]);
 label6.caption:=inttostr(listbox1.items.count);
 label7.caption:=inttostr(listbox2.items.count);
 if XML_DISPLAY.roomsfreeday=-1 then combobox1.itemindex:=0
   else combobox1.itemindex:=XML_DISPLAY.roomsfreeday+1;
 fillTimeSlots;
 if XML_DISPLAY.roomsfreePeriod=-1 then combobox3.itemindex:=0
   else combobox3.itemindex:=XML_DISPLAY.roomsfreeperiod;
 combobox2.itemindex:=XML_DISPLAY.roomsfreefac-1;
 checkRadiobuttons;
end;

procedure TRoomsfreedlg.ComboBox1Change(Sender: TObject);
var
 tmpstr:  string;
 olddayGroup: smallint;
begin
 if duringload then exit;
 olddayGroup:=DayGroup[XML_DISPLAY.roomsfreeday];
 XML_DISPLAY.roomsfreeday:=findday(combobox1.text);
 if XML_DISPLAY.roomsfreeday>=0
  then
   begin
    UseDay:=XML_DISPLAY.RoomsFreeDay;
    label12.caption:=day[XML_DISPLAY.roomsfreeday];
   end
 else
  begin
   UseDay:=0;
   tmpstr:=uppercase(trim(combobox1.text));
   if ((tmpstr='*') or (tmpstr=uppercase(combobox1.items[0]))) then
     label12.caption:='All days'  {roomsfreeday=-1}
   else
    begin
     XML_DISPLAY.roomsfreeday:=-2;
     label12.caption:='Enter Day';
    end;
  end;
 if DayGroup[UseDay]<>olddayGroup then
  begin
   fillTimeSlots;
   ComboBox3Change(Sender);
  end;
end;

procedure TRoomsfreedlg.ComboBox1Enter(Sender: TObject);
begin
 ComboBox1Change(Sender);
 ComboBox1.selectall;
end;

procedure TRoomsfreedlg.ComboBox2Change(Sender: TObject);
begin
 if duringload then exit;
 if trim(combobox2.text)='' then XML_DISPLAY.roomsfreefac:=-1  {none selected}
  else XML_DISPLAY.roomsfreefac:=findfaculty(ComboBox2.text,label12); {0 if not found and -1 for not selected}
end;

procedure TRoomsfreedlg.ComboBox2Enter(Sender: TObject);
begin
 ComboBox2Change(Sender);
 ComboBox2.selectall;
end;

procedure TRoomsfreedlg.RadioButton1Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TRoomsfreedlg.ComboBox3Change(Sender: TObject);
begin
 if duringload then exit;
 XML_DISPLAY.roomsfreeperiod:=Combobox3.ItemIndex;
 if XML_DISPLAY.roomsfreeperiod>0 then label8.caption:=TimeSlotName[UseDay,XML_DISPLAY.roomsfreeperiod-1]
  else if XML_DISPLAY.roomsfreeperiod=0 then label8.caption:='All time slots'
   else label8.caption:='Select time slot';
end;

procedure TRoomsfreedlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3Change(Sender);
 ComboBox3.selectall;
end;

procedure TRoomsfreedlg.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpSel,ListBox2);
end;

procedure TRoomsfreedlg.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpSel,ListBox2);
end;

end.
