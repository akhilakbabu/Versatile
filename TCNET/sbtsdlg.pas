unit Sbtsdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,TimeChartGlobals,
  GlobalToTcAndTcextra, XML.DISPLAY;

type
  TSubjectsByTimeSlotDlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    finish: TBitBtn;
    ok: TBitBtn;
    BitBtn3: TBitBtn;
    Label5: TLabel;
    ComboBox1: TComboBox;
    Label6: TLabel;
    ComboBox2: TComboBox;
    Label7: TLabel;
    RadioGroup1: TRadioGroup;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox4Enter(Sender: TObject);
  end;

var
  SubjectsByTimeSlotDlg: TSubjectsByTimeSlotDlg;

implementation
uses tcommon, Subbyslt,DlgCommon;
{$R *.DFM}
var
 duringload:    bool;
 MyDay: integer;

procedure TSubjectsByTimeSlotDlg.FormCreate(Sender: TObject);
begin
 duringload:=true;
 caption:='Students in Time Slot Selection - '+groupname;
 radiogroup1.itemindex:=XML_DISPLAY.sublistfree;
 IntRange(XML_DISPLAY.sublistday,0,days-1);   MyDay:=XML_DISPLAY.sublistday;
 IntRange(XML_DISPLAY.sublisttime1,0,Tlimit[MyDay]-1);
 IntRange(XML_DISPLAY.sublisttime2,0,Tlimit[MyDay]-1);
 IntRange(XML_DISPLAY.sublistYear,0,years_minus_1);
 FillComboDays(false,combobox1);
 combobox1.ItemIndex:=MyDay;
 FillComboYears(false,ComboBox2);
 combobox2.ItemIndex:=XML_DISPLAY.sublistYear;
 FillComboTimeSlots(true,MyDay,combobox3);
 combobox3.ItemIndex:=XML_DISPLAY.sublisttime1+1;
 FillComboTimeSlots(false,MyDay,combobox4);
 combobox4.ItemIndex:=XML_DISPLAY.sublisttime2;
 duringload:=false;
end;

procedure TSubjectsByTimeSlotDlg.okClick(Sender: TObject);
var
 ty,td,tt1,tt2:       smallint;
begin
 if BadComboYear(ty,ComboBox2) then exit;
 if BadDayCombo(td,ComboBox1) then exit;
 if BadTimeCombo(tt1,td,comboBox3) then exit;
 if tt1=0 then
  begin
   tt1:=0;
   tt2:=tlimit[td]-1;
  end
 else
  begin
   dec(tt1);
   tt2:=comboBox4.ItemIndex;
   if tt2=-1 then tt2:=tt1;
  end;

 if tt2<tt1 then swapint(tt1,tt2);

 {still here then assign}
 XML_DISPLAY.sublistfree:=radiogroup1.itemindex;
 XML_DISPLAY.sublistYear:=ty;
 XML_DISPLAY.sublistday:=td;
 XML_DISPLAY.sublisttime1:=tt1;
 XML_DISPLAY.sublisttime2:=tt2;
 SubByTimeSlotWin.UpdateWin;
 close;
end;

procedure TSubjectsByTimeSlotDlg.ComboBox1Enter(Sender: TObject);
begin
 combobox1.selectall;
end;

procedure TSubjectsByTimeSlotDlg.ComboBox1Change(Sender: TObject);
var
 olddayGroup:  integer;
begin
 if duringload then exit;
 olddayGroup:=1; if MyDay>=0 then olddayGroup:=DayGroup[MyDay];
 MyDay:=finddayMsg(combobox1.text,label5);
 if MyDay>=0 then
  if DayGroup[MyDay]<>olddayGroup then
   begin
    FillComboTimeSlots(true,MyDay,combobox3);
    FillComboTimeSlots(false,MyDay,combobox4);
    ComboBox4Change(Sender);
    ComboBox3Change(Sender);
   end;
end;

procedure TSubjectsByTimeSlotDlg.ComboBox2Enter(Sender: TObject);
begin
 combobox2.selectall;
end;

procedure TSubjectsByTimeSlotDlg.ComboBox2Change(Sender: TObject);
begin
 if duringload then exit;
 findYearname(ComboBox2.text,label5);
end;

procedure TSubjectsByTimeSlotDlg.ComboBox3Change(Sender: TObject);
begin
 ComboBox3.SelectAll;
end;

procedure TSubjectsByTimeSlotDlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3.SelectAll;
end;

procedure TSubjectsByTimeSlotDlg.ComboBox4Change(Sender: TObject);
begin
 ComboBox4.SelectAll;
end;

procedure TSubjectsByTimeSlotDlg.ComboBox4Enter(Sender: TObject);
begin
 ComboBox4.SelectAll;
end;

end.
