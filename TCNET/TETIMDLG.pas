unit Tetimdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, TimeChartGlobals, GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  TTeachertimesdlg = class(TForm)
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label12: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label8: TLabel;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    CheckBox1: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    ReportType1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
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
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
    procedure ReportType1Click(Sender: TObject);
  private
    procedure CheckRadioButtons;
  end;

var
  Teachertimesdlg: TTeachertimesdlg;

implementation
uses tcommon,DlgCommon,tcommon2;
{$R *.DFM}
var
 tmpsel:  tpTeData;
 tmpFac,tmpYear:  smallint;
 duringload: bool;

procedure TTeachertimesdlg.CheckRadioButtons;
begin
 if duringload then exit;
 combobox1.color:=clWindow;
 combobox2.color:=clWindow;
 listbox1.color:=clWindow;  listbox2.color:=clWindow;
 combobox1.enabled:=false;
 listbox1.enabled:=false; listbox2.enabled:=false;
 bitbtn1.enabled:=false; bitbtn2.enabled:=false;
 bitbtn3.enabled:=false; bitbtn4.enabled:=false;
 if ReportType1.ItemIndex=2 then HiLiteCombo(combobox1);
 if radiobutton7.checked then
  begin
   HiLiteList(listbox1); HiLiteList(listbox2);
   bitbtn1.enabled:=true; bitbtn2.enabled:=true;
   bitbtn3.enabled:=true; bitbtn4.enabled:=true;
  end;
end;



procedure TTeachertimesdlg.FormCreate(Sender: TObject);
var
 i:     integer;
begin
 label2.Caption:='&'+YearTitle; ReportType1.Items[2]:='&'+YearTitle;
 duringload:=true;   label12.caption:='';
 fillchar(tmpsel,sizeof(tmpsel),chr(0));
 FillComboYears(true,ComboBox1);
 FillComboFaculty(true,combobox2);
 listbox1.clear;
 for i:=1 to codeCount[1] do
  listbox1.items.add(XML_TEACHERS.tecode[codepoint[i,1],0]);
 listbox2.clear;
 {add saved selection here}
 rangeCheckCodeSels(XML_DISPLAY.TeTimesSelect,1);
 for i:=0 to nmbrteachers do
  tmpsel[i]:=XML_DISPLAY.TeTimesSelect[i];
 XML_DISPLAY.teachertimesshow1:=winView[wnTeTimes]+1;
 ReportType1.ItemIndex:=XML_DISPLAY.teachertimesshow1-1;

 case XML_DISPLAY.teachertimesshow2 of
  1: radiobutton6.checked:=true;
  2: radiobutton7.checked:=true;
 end;
 checkbox1.checked:=XML_DISPLAY.MatchAllYears;
 tmpFac:=XML_DISPLAY.teachertimesfac;
 duringload:=false;
end;

procedure TTeachertimesdlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TTeachertimesdlg.OKbuttonClick(Sender: TObject);
var
i:  integer;
begin
 if tmpYear=-1 then
  begin
   ComboMsg('Check '+yeartitle,combobox1);
   exit;
  end;

 for i:=0 to nmbrteachers do
    XML_DISPLAY.TeTimesSelect[i]:=tmpsel[i];

 XML_DISPLAY.teachertimesshow1:=1+ReportType1.ItemIndex;
 if radiobutton6.checked then
    XML_DISPLAY.teachertimesshow2:=1
  else if radiobutton7.checked then
      XML_DISPLAY.teachertimesshow2:=2;
 winView[wnTeTimes]:=XML_DISPLAY.teachertimesshow1-1;
 XML_DISPLAY.MatchAllYears:=checkbox1.checked;
 XML_DISPLAY.teachertimesfac:=tmpFac;
 XML_DISPLAY.teachertimesyear:=tmpYear;
 close;
 UpdateWindow(wnTeTimes);
end;

procedure TTeachertimesdlg.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpSel,listbox2,label7);
end;

procedure TTeachertimesdlg.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpSel,listbox2,label7);
end;

procedure TTeachertimesdlg.BitBtn3Click(Sender: TObject);
begin
 MoveOnSubList(tmpSel,listbox1,listbox2,label7,1);
end;

procedure TTeachertimesdlg.BitBtn4Click(Sender: TObject);
begin
 FillSubList(tmpSel,listbox1,listbox2,label7,1);
end;

procedure TTeachertimesdlg.FormActivate(Sender: TObject);
var
 i:    integer;
begin
 listbox2.clear;
 if tmpsel[0]>0 then
   for i:=1 to tmpsel[0] do
    listbox2.items.add(XML_TEACHERS.tecode[tmpsel[i],0]);

 label6.caption:=inttostr(listbox1.items.count);
 label7.caption:=inttostr(listbox2.items.count);
 if XML_DISPLAY.teachertimesyear=years then
    combobox1.itemindex:=0
   else combobox1.itemindex:=XML_DISPLAY.teachertimesyear+1;
 combobox2.itemindex:=XML_DISPLAY.teachertimesfac;
 tmpYear:=XML_DISPLAY.teachertimesyear;
 checkRadiobuttons;
end;

procedure TTeachertimesdlg.ComboBox1Change(Sender: TObject);
begin
 if duringload then exit;
 tmpYear:=FindComboAllYear(Combobox1,label12);
end;

procedure TTeachertimesdlg.ComboBox1Enter(Sender: TObject);
begin
 Teachertimesdlg.ComboBox1Change(Sender);
 ComboBox1.selectall;
end;

procedure TTeachertimesdlg.ComboBox2Change(Sender: TObject);
begin
 if duringload then exit;
 if trim(combobox2.text)='' then tmpFac:=0  {all facs}
  else tmpFac:=findfaculty(ComboBox2.text,label12); {0 if not found and -1 for not selected}
end;

procedure TTeachertimesdlg.ComboBox2Enter(Sender: TObject);
begin
 Teachertimesdlg.ComboBox2Change(Sender);
 ComboBox2.selectall;
end;

procedure TTeachertimesdlg.RadioButton6Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeachertimesdlg.RadioButton7Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeachertimesdlg.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpSel,ListBox2);
end;

procedure TTeachertimesdlg.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpSel,ListBox2);
end;

procedure TTeachertimesdlg.ReportType1Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

end.
