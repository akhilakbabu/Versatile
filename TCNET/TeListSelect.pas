unit TeListSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,TimeChartGlobals, XML.DISPLAY, XML.TEACHERS;

type
  TTeListSelDlg = class(TForm)
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label1: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    Label4: TLabel;
    ListBox1: TListBox;
    Label6: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Label5: TLabel;
    ListBox2: TListBox;
    Label7: TLabel;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
  private
   procedure checkRadiobuttons;
  end;

var
  TeListSelDlg: TTeListSelDlg;

implementation
uses tcommon,DlgCommon,tcommon2;
{$R *.dfm}

var
 tmpsel:  tpTeData;
 tmpFac: smallint;
 duringload: bool;


procedure TTeListSelDlg.checkRadiobuttons;
begin
 if duringload then exit;
 if radiobutton7.checked then
  begin
   HiLiteList(listbox1); HiLiteList(listbox2);
   bitbtn1.enabled:=true; bitbtn2.enabled:=true;
   bitbtn3.enabled:=true; bitbtn4.enabled:=true;
  end
 else
  begin
   listbox1.color:=clWindow;  listbox2.color:=clWindow;
   listbox1.enabled:=false; listbox2.enabled:=false;
   bitbtn1.enabled:=false; bitbtn2.enabled:=false;
   bitbtn3.enabled:=false; bitbtn4.enabled:=false;
  end;
end;


procedure TTeListSelDlg.FormCreate(Sender: TObject);
var
 i: integer;
begin
 duringload:=true;
 fillchar(tmpsel,sizeof(tmpsel),chr(0));
 tmpFac:=XML_DISPLAY.TeListFac;
 FillComboFaculty(false,combobox1);
 if (XML_DISPLAY.TeListFac>0) and (XML_DISPLAY.TeListFac<=facnum) then
    combobox1.text:=facName[XML_DISPLAY.TeListFac]
   else combobox1.text:='';
 listbox1.clear;
 for i:=1 to codeCount[1] do
  listbox1.items.add(XML_TEACHERS.tecode[codepoint[i,1],0]);
 label6.caption:=inttostr(listbox1.items.count);

 listbox2.clear; {add saved selection here}

 rangeCheckCodeSels(XML_DISPLAY.teListSelection,1);
 for i:=0 to nmbrteachers do
  tmpsel[i]:=XML_DISPLAY.teListSelection[i];
 if tmpSel[0]>0 then
  for i:=1 to tmpSel[0] do listbox2.items.add(XML_TEACHERS.tecode[tmpSel[i],0]);
 label7.caption:=inttostr(listbox2.items.count);

 CheckBox1.Checked:=XML_DISPLAY.MatchAllYears;
 if XML_DISPLAY.TeListShow=1 then RadioButton6.Checked:=true else RadioButton7.Checked:=true;
 duringload:=false;
end;

procedure TTeListSelDlg.RadioButton6Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeListSelDlg.RadioButton7Click(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeListSelDlg.FormActivate(Sender: TObject);
begin
 checkRadiobuttons;
end;

procedure TTeListSelDlg.BitBtn3Click(Sender: TObject);
begin
 MoveOnSubList(tmpSel,listbox1,listbox2,label7,1);
end;

procedure TTeListSelDlg.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpSel,listbox2,label7);
end;

procedure TTeListSelDlg.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpSel,listbox2,label7);
end;

procedure TTeListSelDlg.BitBtn4Click(Sender: TObject);
begin
 FillSubList(tmpSel,listbox1,listbox2,label7,1);
end;

procedure TTeListSelDlg.ComboBox1Change(Sender: TObject);
begin
 if duringload then exit;
 if trim(combobox1.text)='' then tmpFac:=0  {all facs}
  else tmpFac:=findfaculty(ComboBox1.text,label1); {0 if not found and -1 for not selected}
end;

procedure TTeListSelDlg.ComboBox1Enter(Sender: TObject);
begin
 ComboBox1.selectall;
end;

procedure TTeListSelDlg.OKbuttonClick(Sender: TObject);
var
i:  integer;
begin
 for i:=0 to nmbrteachers do
  XML_DISPLAY.TeListSelection[i]:=tmpsel[i];
 if radiobutton6.checked then
      XML_DISPLAY.TeListShow:=1
 else
      XML_DISPLAY.TeListShow:=2;
 XML_DISPLAY.MatchAllYears:=checkbox1.checked;
 XML_DISPLAY.TeListFac:=tmpFac;
 close;
 UpdateWindow(wnTeList);
end;

procedure TTeListSelDlg.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpSel,ListBox2);
end;

procedure TTeListSelDlg.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpSel,ListBox2);
end;

end.
