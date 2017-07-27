unit Subttdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals,GlobalToTcAndTcextra,
  XML.DISPLAY;

type
  TSubjectTTdlg = class(TForm)
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    RadioButton4: TRadioButton;
    CheckBox1: TCheckBox;
    ComboBox3: TComboBox;
    SelectDaysChkBox: TCheckBox;
    ttStartChkBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelbuttonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
  private
    procedure UpdateHighlights;
    procedure DisplaySubSelection;
  end;

var
  SubjectTTdlg: TSubjectTTdlg;

implementation
uses tcommon,DlgCommon,tcommon2;
var
 duringload:    bool;
 typeofTT:      integer;
 ttyear,ttlevel,ttday,TTtime:  smallint;

{$R *.DFM}


procedure TSubjectTTdlg.UpdateHighlights;
begin
 combobox1.color:=clwindow; combobox2.color:=clwindow;
 edit3.color:=clwindow; combobox3.color:=clwindow;
 checkbox1.enabled:=false;  SelectDaysChkBox.enabled:=false;
 ttStartChkBox.Enabled:=false;
 case typeofTT of
  1: begin
      HiLiteCombo(combobox1); HiLiteCombo(combobox2);
      HiLiteEdit(edit3);      HiLiteCombo(combobox3);
     end;
  2: begin
      HiLiteCombo(combobox1); HiLiteCombo(combobox2);
      HiLiteCombo(combobox3);     edit3.enabled:=false;
     end;
  3: begin
      HiLiteCombo(combobox1);
      HiLiteEdit(edit3);         combobox2.enabled:=false;
      combobox3.enabled:=false;      checkbox1.enabled:=true;
      SelectDaysChkBox.enabled:=true; ttStartChkBox.Enabled:=true;
     end;
  4: begin           {block}
      HiLiteCombo(combobox1); HiLiteCombo(combobox2);
      HiLiteEdit(edit3);     HiLiteCombo(combobox3);
     end;
 end; {case}
end;

procedure TSubjectTTdlg.DisplaySubSelection;
var
 tmpStr:  string;
 aStr:    string;
 i,j,l1,l2:     integer;
 aFnt:    tpIntpoint;
begin
 if typeofTT<>2 then
  begin
   label13.caption:='';
   if ((ttlevel<1) or (ttlevel>level[ttyear])) then
    begin
     label13.Caption:='Enter level in range 1-'+inttostr(level[ttyear]);
     edit3.Setfocus; Edit3.SelectAll;
     exit;
    end;
  end;
 if typeofTT<>3 then
  begin
   if ((TTtime<0) or
   ((ttday>=0) and (TTtime>tlimit[ttday]))) then
    begin
     label13.Caption:='Enter time slot in range 1-'+inttostr(Tlimit[ttday]);
     combobox3.Setfocus; combobox3.SelectAll;
     exit;
    end;
  end;

 tmpStr:='';   subttGroupcnt:=0;
 if ttyear<>-1 then {year found}
  case typeofTT of
   1: begin
       aFnt:=FNT(ttday,TTtime,ttyear,ttlevel,0);
       j:=aFnt^;
       if ((j>0) and (j<LabelBase)) then
        begin
         tmpStr:=subCode[j];
         subttGroupcnt:=1;
         XML_DISPLAY.SubTtGroup[1]:=j;
        end
       else
        begin
         tmpStr:='No subject at selection.';
         subttgroupcnt:=0;
        end;
      end;
   2: begin
       subttgroupcnt:=0;
       for i:=0 to level[ttyear] do
        begin
         aFnt:=FNT(ttday,TTtime,ttyear,i,0);
         j:=aFnt^;
         if ((j>0) and (j<LabelBase)) then
          begin
           tmpStr:=tmpStr+subCode[j]+' ';
           inc(subttgroupcnt);
           XML_DISPLAY.SubTtGroup[subttgroupcnt]:=j;
          end;
        end; {for i}
       tmpStr:=trim(tmpStr);
       if tmpStr='' then tmpStr:='No subjects at selection.';
      end;
   3: begin
       tmpStr:=yeartitle+' '+yearname[ttyear]+' ';
       aStr:=trim(ClassCode[ClassShown[ttlevel,ttyear]]);
       if aStr>'' then tmpStr:=tmpStr+aStr
        else tmpStr:=tmpStr+'Level '+inttostr(ttlevel);
      end;
   4: begin       {block}
       subttgroupcnt:=0;   l1:=0; l2:=0;
       getBlockLevels(ttday,TTtime,ttyear,ttlevel,l1,l2);
       if l1>0 then
        for i:=l1 to l2 do
         begin
          aFnt:=FNT(ttday,TTtime,ttyear,i,0);
          j:=aFnt^;
          if ((j>0) and (j<LabelBase)) then
           begin
            tmpStr:=tmpStr+subCode[j]+' ';
            inc(subttgroupcnt);
            XML_DISPLAY.SubTtGroup[subttgroupcnt]:=j;
           end;
         end; {for i}
       tmpStr:=trim(tmpStr);
       if tmpStr='' then tmpStr:='No block number at selection.';
      end;
  end; {case}
 label3.caption:=tmpStr;
end;

procedure TSubjectTTdlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TSubjectTTdlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure TSubjectTTdlg.FormActivate(Sender: TObject);
begin
 label3.caption:='';
 label13.caption:='';
 case XML_DISPLAY.subttlistselection of   {used as default}
  1: radiobutton1.checked:=true;
  2: radiobutton2.checked:=true;
  3: radiobutton3.checked:=true;
  4: radiobutton4.checked:=true;
 end; {case}
 typeofTT:=XML_DISPLAY.subttlistselection;
 FillComboYears(false,ComboBox1);
 FillComboDays(false,ComboBox2);
 FillComboTimeSlots(false,nd,combobox3);
 ttyear:=XML_DISPLAY.subttlistvals[1];
 ttlevel:=XML_DISPLAY.subttlistvals[2];
 ttday:=XML_DISPLAY.subttlistvals[3];
 TTtime:=XML_DISPLAY.subttlistvals[4];
 combobox2.itemindex:=ttday;
 combobox1.itemindex:=ttyear;
 combobox3.ItemIndex:=TTtime;
 edit3.text:=inttostr(ttlevel);
 checkbox1.checked:=not(XML_DISPLAY.subttWide);
 SelectDaysChkBox.Checked:=XML_DISPLAY.ttWeekDaysFlg;
 ttStartChkBox.Checked:=XML_DISPLAY.ttClockShowFlg;
 updatehighlights;
end;

procedure TSubjectTTdlg.OKbuttonClick(Sender: TObject);
var
 Old_ttWeekDaysFlg,Old_ttClockShowFlg:boolean;
begin
 Old_ttWeekDaysFlg:=XML_DISPLAY.ttWeekDaysFlg;
 Old_ttClockShowFlg:=XML_DISPLAY.ttClockShowFlg;
 ttLevel:=1; ttDay:=0; ttTime:=0;
 if BadComboYear(ttyear,Combobox1) then exit;
 if typeofTT<>2 then
   if InvalidEntry(ttlevel,0,level[ttyear],'Level number',edit3) then exit;
 if typeofTT<>3 then
  begin
   if BadDayCombo(ttday,ComboBox2) then exit;
   if BadTimeCombo(ttTime,ttDay,comboBox3) then exit;
  end;
 XML_DISPLAY.subttlistvals[1]:=ttyear;
 XML_DISPLAY.subttlistvals[2]:=ttlevel;
 XML_DISPLAY.subttlistvals[3]:=ttday;
 XML_DISPLAY.subttlistvals[4]:=TTtime;
 XML_DISPLAY.subttlistselection:=typeofTT;
 XML_DISPLAY.subttWide:=not(checkbox1.checked);
 XML_DISPLAY.ttWeekDaysFlg:=SelectDaysChkBox.Checked;
 XML_DISPLAY.ttClockShowFlg:=ttStartChkBox.Checked;
 close;
 if (Old_ttWeekDaysFlg<>XML_DISPLAY.ttWeekDaysFlg) or (Old_ttClockShowFlg<>XML_DISPLAY.ttClockShowFlg)
  then updateAllwins else UpdateWindow(wnSubjectTt);
end;

procedure TSubjectTTdlg.RadioButton1Click(Sender: TObject);
begin
 typeofTT:=1;
 updatehighlights;
 displaysubselection;
end;

procedure TSubjectTTdlg.RadioButton2Click(Sender: TObject);
begin
 typeofTT:=2;
 updatehighlights;
 displaysubselection;
end;

procedure TSubjectTTdlg.RadioButton3Click(Sender: TObject);
begin
 typeofTT:=3;
 updatehighlights;
 displaysubselection;
end;

procedure TSubjectTTdlg.ComboBox1Change(Sender: TObject);
begin
 if duringload then exit;
 ttyear:=findYear(ComboBox1.text);
 if ttyear<0 then ttyear:=0;
 displaysubselection;
end;

procedure TSubjectTTdlg.ComboBox2Change(Sender: TObject);
begin
 if duringload then exit;
 if ChangeDayCombo(ttday,Combobox2,combobox3) then ComboBox3Change(Sender);
 ttday:=findDay(ComboBox2.text);
 if ttday<0 then ttday:=0;
 displaysubselection;
end;

procedure TSubjectTTdlg.Edit3Change(Sender: TObject);
begin
 ttlevel:=IntFromEdit(edit3);
 displaysubselection;
end;

procedure TSubjectTTdlg.RadioButton4Click(Sender: TObject);
begin
 typeofTT:=4;
 updatehighlights;
 displaysubselection;
end;

procedure TSubjectTTdlg.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TSubjectTTdlg.ComboBox3Change(Sender: TObject);
begin
 TTtime:=combobox3.ItemIndex;
 displaysubselection;
 ComboBox3.SelectAll;
end;

procedure TSubjectTTdlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3.SelectAll;
end;

end.



