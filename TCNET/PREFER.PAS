unit Prefer;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls, Tabs,
  Buttons, ExtCtrls, Dialogs, TabNotBk, TimeChartGlobals,sysutils, Mask, ComCtrls,
  GlobalToTcAndTcextra, XML.DISPLAY;

type
  Tprefdlg = class(TForm)
    ButtonPanel: TPanel;
    TabSet: TTabSet;
    Notebook: TNotebook;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox26: TCheckBox;
    CheckBox27: TCheckBox;
    CheckBox29: TCheckBox;
    ColourChkBox: TCheckBox;
    MatchAllChkBox: TCheckBox;
    GroupBox7: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox4: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    Label7: TLabel;
    Edit1: TEdit;
    Label8: TLabel;
    Edit2: TEdit;
    Label9: TLabel;
    Edit7: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label10: TLabel;
    RadioGroup1: TRadioGroup;
    Label12: TLabel;
    Label13: TLabel;
    ListStyle1: TRadioGroup;
    Label4: TLabel;
    YearClass1: TRadioGroup;
    Label6: TLabel;
    ComboBox2: TComboBox;
    DayLabel1: TLabel;
    GenderOrder1: TRadioGroup;
    Button2: TButton;
    Button1: TButton;
    Button5: TButton;
    Button6: TButton;
    Button3: TButton;
    Button4: TButton;
    Button7: TButton;
    Button8: TButton;
    GroupBox3: TGroupBox;
    MaskEdit1: TMaskEdit;
    Label5: TLabel;
    SelectDaysChkBox: TCheckBox;
    ttStartChkBox: TCheckBox;
    CheckBox28: TCheckBox;
    btnDefaultSettings: TBitBtn;
    rgpFileExtention: TRadioGroup;
    chkEmail: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure TabSetClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SavePreferences(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure myEditsKeyPress(Sender: TObject; var Key: Char);
    procedure MaskEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure SetPreferencesToDefault(Sender: TObject);
  private
    procedure ShowTsNames;
    procedure periodCheckBoxClick(Sender: TObject);
    procedure RefreshDynamicControls;
    procedure RefreshStaticControls;
  end;

var
  prefdlg: Tprefdlg;

implementation

uses
  tcinfo, tcommon, DlgCommon, StCommon, main, studlist, customOutput, FileCtrl,
  uAMGConst, TCLoad;

{$R *.DFM}
var
 periodCheckBox:  array[1..nmbrPeriods] of TCheckBox;
 dayCheckBox:     array[1..nmbrDays] of TCheckBox;
 yearCheckBox:    array[1..nmbrYears] of TCheckBox;
 usingResources:  bool;
 actcheckboxsz:         integer;
 MyDayGroup:   smallint;
 tmpTsOn: array  [0..nmbrDays,0..nmbrPeriods] of boolean;  {base on daygroup}


procedure Tprefdlg.SetPreferencesToDefault(Sender: TObject);
var
  lCurrentDir: string;
begin
  if MessageDlg(AMG_RESET_DEFAULT_MSG, mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    lCurrentDir := GetCurrentDir;
    try
      SetCurrentDir(UsrPassDir);
      if FileExists(AMG_DISPLAY_FILE) then
      begin
        DeleteFile(AMG_DISPLAY_FILE);
        Application.ProcessMessages;
      end;
      FirstLoad;
      CustomerSetup;
      WinShow;
      //if EntrySelectionLink then checkLinkedWins; //update linked wins if necessary
      RefreshDynamicControls;
      RefreshStaticControls;
      SavePreferences(Self);
    finally
      SetCurrentDir(lCurrentDir);
    end;
  end;
end;

procedure Tprefdlg.ShowTsNames;
var
 str: string;
 i,j,num,dayuse: integer;
begin
 str:=''; dayuse:=dg[MyDayGroup,1];
 num:=dg[MyDayGroup,0];
 if num>1 then   {align all time slots with first day}
  for j:=2 to num do
   for i:=0 to periods do
    tmpTsOn[dg[MyDayGroup,j],i]:=tmpTsOn[dg[MyDayGroup,1],i];
 if (numDayGroups>1) and (numDayGroups<days) then
  begin
   for i:=1 to dg[MyDayGroup,0] do str:=str+dayname[dg[MyDayGroup,i]]+' ';
  end;
 DayLabel1.Caption:=str;
 for i:=1 to periods do
  begin
   periodCheckBox[i].Hint:='Check to show '+TimeSlotName[dayuse,i-1];
   if i<=Tlimit[dayuse] then
    begin
     periodCheckBox[i].caption:=TimeSlotName[dayuse,i-1];
     periodCheckBox[i].Visible:=true;
     periodCheckBox[i].checked:=tmpTsOn[dayuse,i-1];
    end
   else
    begin
     periodCheckBox[i].caption:='';
     periodCheckBox[i].Visible:=false;
    end;
  end;
end;

procedure Tprefdlg.myEditsKeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure Tprefdlg.FormCreate(Sender: TObject);
begin
  RefreshDynamicControls;
end;

procedure Tprefdlg.TabSetClick(Sender: TObject);
begin
  { set visible Page to which Tab was clicked }
  Notebook.PageIndex := TabSet.TabIndex;
end;

procedure Tprefdlg.FormActivate(Sender: TObject);
begin
  btnDefaultSettings.Visible := usrPassLevel <> utGen;
  if not btnDefaultSettings.Visible then
  begin
    HelpBtn.Top := CancelBtn.Top;
    CancelBtn.Top := btnDefaultSettings.Top;
  end;
  RefreshStaticControls;
end;

procedure Tprefdlg.SavePreferences(Sender: TObject);
var
 i,j,k,m:       integer;
 msg,t:       string;
 oldStudSelcode:   integer;
begin
 {validate data first}
 oldStudSelcode:=0;

 j:=strtointdef(trim(maskedit1.text),1);
 if ((j<1) or (j>9)) then
  begin
   notebook.pageindex:=1; {return to relevant page}
   maskedit1.setfocus;
   msg:='Weekly Timetables per page has an invalid entry.'+endline;
   msg:=msg+'Please enter a number between 1 and 9.';
   messagedlg(msg,mtError,[mbOK],0);
   exit;
  end;

 screen.cursor:=crHourglass;
 try
  {proceed}
  prefdlg.hide;

  XML_DISPLAY.OberonOutputType:=radiogroup1.itemindex;
  XML_DISPLAY.StHeadShow:=checkbox29.checked;
  XML_DISPLAY.colorPrinterFlag:=ColourChkBox.checked;
  XML_DISPLAY.MatchAllYears:=MatchAllChkBox.Checked;
  XML_DISPLAY.styear:=checkbox24.checked;
  XML_DISPLAY.FAfirst:=checkbox17.checked;
  XML_DISPLAY.FAsex:=checkbox22.checked;
  XML_DISPLAY.FAid:=checkbox23.checked;
  XML_DISPLAY.FAyear:=checkbox25.checked;
  XML_DISPLAY.FAclass:=checkbox18.checked;
  XML_DISPLAY.FAhouse:=checkbox20.checked;
  XML_DISPLAY.FAtutor:=checkbox19.checked;
  XML_DISPLAY.FAhome:=checkbox21.checked;
  XML_DISPLAY.FAsubnum:=IntFromEdit(edit7);
  XML_DISPLAY.FAreplace:=checkbox16.checked;
  t:=trim(edit1.text);
  XML_DISPLAY.txtsep:=strtointdef(t,-99);
  if XML_DISPLAY.txtsep=-99 then XML_DISPLAY.txtsep:=ord(t[1]);
  if t='' then XML_DISPLAY.txtsep:=0;
  t:=trim(edit2.text);
  XML_DISPLAY.txtlim:=strtointdef(t,-99);
  if XML_DISPLAY.txtlim=-99 then XML_DISPLAY.txtlim:=ord(t[1]);
  if t='' then XML_DISPLAY.txtlim:=0;
  XML_DISPLAY.GenericTtableFlag:=radiobutton2.checked;
  XML_DISPLAY.FExportFileIdx := rgpFileExtention.ItemIndex;

  {student section}
  XML_DISPLAY.stSex:=checkbox1.checked;
  XML_DISPLAY.stClass:=checkbox2.checked;
  XML_DISPLAY.stHouse:=checkbox3.checked;
  XML_DISPLAY.stID:=checkbox4.checked;
  XML_DISPLAY.stTutor:=checkbox5.checked;
  XML_DISPLAY.stHome:=checkbox6.checked;
  XML_DISPLAY.stTag:=checkbox11.Checked;

  XML_DISPLAY.stID2:=checkbox28.checked;
  XML_DISPLAY.stEmail:=chkEmail.Checked;

  XML_DISPLAY.globalHints:=checkbox14.checked;
  application.showhint:=XML_DISPLAY.globalHints;
  XML_DISPLAY.OKbackup:=checkbox15.checked;
  XML_DISPLAY.OKquitcheck:=checkbox26.checked;
  XML_DISPLAY.customFileLoadFlag:=checkbox27.checked;
  //OnlineUpdateCheck:=combobox1.ItemIndex;
  XML_DISPLAY.blockshow:=checkbox7.checked;
  XML_DISPLAY.double_space:=checkbox8.checked;
  XML_DISPLAY.double_print:=1;
  if XML_DISPLAY.double_space then
      XML_DISPLAY.double_print:=2;
  XML_DISPLAY.listshowClashes:=checkbox12.checked;
  XML_DISPLAY.Formfeed:=checkbox13.checked;
  if wnFlag[wnStudentList] then
   begin
    if studentlistwin.selcode>0 then
     oldStudSelcode:=StPointer[studentlistwin.selcode];   {protect stud selection}
   end;    {if studentlistwinflag}
  XML_DISPLAY.SexSelect:=GenderOrder1.ItemIndex;
  XML_DISPLAY.sTselect:=liststyle1.ItemIndex;
  studentpointerset;

  if wnFlag[wnStudentList] then
   if ((XML_DISPLAY.StudListType<>7) and (studentlistwin.selcode>0)) then   {restore stud selcode}
    begin
     m:=0;
     for k:=1 to groupnum do
      if StPointer[k]=oldStudSelcode then
       begin
        m:=k;
        break;
       end;
     studentlistwin.selcode:=m;
    end;

  {timetable section}
  for i:=0 to days-1 do
   for j:=0 to periods do XML_DISPLAY.TsOn[i,j]:=tmpTsOn[i,j];
  for i:=1 to years do XML_DISPLAY.Pyear[i-1]:=yearCheckBox[i].checked;
  SetPshowMax;
  for i:=1 to days do XML_DISPLAY.Dprint[i]:=dayCheckBox[i].checked;
  XML_DISPLAY.ttWeekDaysFlg:=SelectDaysChkBox.Checked;
  XML_DISPLAY.ttClockShowFlg:=ttStartChkBox.Checked;
  XML_DISPLAY.Tfreeshow:=checkbox9.checked;
  XML_DISPLAY.Rfreeshow:=checkbox10.checked;
  XML_DISPLAY.Pweek:=strtointdef(trim(maskedit1.text),1);
  XML_DISPLAY.Tyr:=YearClass1.ItemIndex;

  prefdlg.modalresult:=mrOK;   {without this it freezes and with modal result
                       set at design time it closes the dialog along with any error msg}

  updateAllwins;

 finally
  screen.cursor:=crDefault;
 end; {try}

end;

procedure Tprefdlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
 i: integer;
begin
 action:=caFree;
 XML_DISPLAY.prefNotebookPageIndex:=NoteBook.pageIndex;
 if usingResources then   {can call close even after closeed it seems}
  begin
   usingResources:=false;
   prefdlg.hide; {prevent seeing controls beeing removed -slows things down a lot}
   for i:=1 to periods do periodCheckBox[i].free;
   for i:=1 to days do dayCheckBox[i].free;
   for i:=1 to years do yearCheckBox[i].free;
  end;
end;

procedure Tprefdlg.MaskEdit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure Tprefdlg.periodCheckBoxClick(Sender: TObject);
var
 i,j: integer;
begin
 i:=activecontrol.tag;
 if ((i<1) or (i>periods)) then exit;  {during load causes problems otherwise}
 for j:=1 to dg[MyDayGroup,0] do
  tmpTsOn[dg[MyDayGroup,j],i-1]:=periodCheckBox[i].Checked;
end;

procedure Tprefdlg.RefreshDynamicControls;
var
  i,j,d:       integer;
  v1,v2:   integer;
  maxtab,curtab,mintab:   integer;
  mxdayname,mxyearname,mxperiodname:    integer;
  msg:                                  string;
const
  xgap=20; ygap=4;   ygapTop=6;
begin
 DayGroupCalc;
 for j:=0 to days-1 do
  for i:=0 to periods do tmpTsOn[j,i]:=XML_DISPLAY.tsOn[j,i];

 radiogroup1.visible:=OberonShow;
 MatchAllChkBox.Checked:=XML_DISPLAY.MatchAllYears;
 checkbox24.hint:='Check to show students'' '+yeartitle;
 checkbox24.caption:='&'+yeartitle;
 checkbox17.checked:=XML_DISPLAY.FAfirst;
 checkbox22.checked:=XML_DISPLAY.FAsex;
 checkbox23.checked:=XML_DISPLAY.FAid;
 checkbox25.checked:=XML_DISPLAY.FAyear;
 checkbox18.checked:=XML_DISPLAY.FAclass;
 checkbox20.checked:=XML_DISPLAY.FAhouse;
 checkbox19.checked:=XML_DISPLAY.FAtutor;
 checkbox21.checked:=XML_DISPLAY.FAhome;

 if XML_DISPLAY.FASubNum < nmbrchoices then
   edit7.text:=inttostr(nmbrchoices)
 else
   edit7.text:=inttostr(XML_DISPLAY.FAsubnum);

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  checkbox28.visible:=true;
  chkEmail.Visible:=true;
 end;

 checkbox16.checked:=XML_DISPLAY.FAreplace;
 groupbox10.hint:='Number of subjects is used both in text in and text out.'+endline;
 msg:='Used for text in only, for text out use preferences/student.';

 checkbox17.hint:=msg; checkbox23.hint:=msg; checkbox20.hint:=msg;
 checkbox18.hint:=msg; checkbox21.hint:=msg;
 checkbox22.hint:=msg; checkbox19.hint:=msg;
 edit1.text:=inttostr(XML_DISPLAY.txtsep); edit2.text:=inttostr(XML_DISPLAY.txtlim);
 if XML_DISPLAY.GenericTtableFlag then radiobutton2.checked:=true
 else radiobutton1.checked:=true;
 rgpFileExtention.ItemIndex := XML_DISPLAY.FExportFileIdx;

 msg:='Ascii character number, i.e. 9 for Tab , 44 for comma.';
 msg:=msg+endline+'For text out only, text in expects comma delimited fields.';
 edit1.hint:=msg;
 msg:='Ascii character number, i.e. 34 for double quotes, 39 for single quotes';
 msg:=msg+endline+'For text out only, text in expects comma delimited fields.';
 edit2.hint:=msg;

 checkbox14.checked:=XML_DISPLAY.globalHints;
 checkbox15.checked:=XML_DISPLAY.OKbackup;
 checkbox15.Visible:=usrPassBKUP;
 checkbox26.checked:=XML_DISPLAY.OKquitcheck;
 checkbox27.checked:=XML_DISPLAY.customFileLoadFlag;
// if ((usrPassLevel=utTime) or (usrPassLevel=utSuper)) then
//  begin
//   combobox1.Clear;
//   combobox1.items.add('None');  combobox1.items.add('7 days');
//   combobox1.items.add('14 days');combobox1.items.add('1 month');
//   combobox1.items.add('2 months');
//   combobox1.ItemIndex:=OnlineUpdateCheck;
//   label14.Visible:=true;
//   combobox1.Visible:=True;
//  end;
 ColourChkBox.checked:=XML_DISPLAY.colorPrinterFlag;

 maxTab:=0; mintab:=canvas.textwidth('Minstr ');
 for i:=1 to years do
 begin
  curTab:=canvas.textwidth(Yearname[i-1]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 mxyearname:=maxTab;
 if mxyearname<mintab then mxyearname:=mintab;

 maxTab:=0;
 for d:=0 to days-1 do
  for i:=0 to Tlimit[d]-1 do
   begin
    curTab:=canvas.textwidth(TimeSlotName[d,i]+'  ');
    if (curTab>maxTab) then maxTab:=curTab;
   end;
 mxperiodname:=maxTab;
 if mxperiodname<mintab then mxperiodname:=mintab;

 maxTab:=0;
 for i:=1 to days do
 begin
  curTab:=self.canvas.textwidth(Dayname[i-1]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;
 mxdayname:=maxTab;
 if mxdayname<mintab then mxdayname:=mintab;

 actcheckboxsz:=self.canvas.textwidth('WW'); {width includes size of actual box}

 combobox2.clear; MyDayGroup:=1;
 if numDayGroups=1 then
  begin
   label6.Visible:=false; combobox2.Visible:=false; Daylabel1.Visible:=false;
  end
 else
  begin {set day groups}
   if (numDayGroups>1) and (numDayGroups<days) then
    for i:=1 to numDayGroups do combobox2.Items.add('Day Group '+inttostr(i));
   if (numDayGroups=days) then
    begin
     for i:=1 to numDayGroups do combobox2.Items.add(dayname[i-1]);
     Daylabel1.Visible:=false;
    end;
   combobox2.itemindex:=MyDayGroup-1;
  end;

 for i:=1 to periods do
  begin
   periodCheckBox[i]:=tCheckBox.create(application);
   periodCheckBox[i].parent:=label4.parent;
   periodCheckBox[i].OnClick:=periodCheckBoxClick;
   periodCheckBox[i].Tag:=i;
   v1:=(i-1) div 5;  v2:=(i) mod 5;
   if v2=0 then v2:=4 else v2:=v2-1;
   periodCheckbox[i].width:=mxperiodname+actcheckboxsz;
   periodCheckBox[i].left:=label4.left+v1*(mxperiodname+xgap);
   periodCheckBox[i].top:=label4.top+label4.height+ygapTop+v2*(periodCheckBox[1].height+ygap);
  end;

 for i:=1 to days do
  begin
   dayCheckBox[i]:=tCheckBox.create(application);
   dayCheckBox[i].parent:=label2.parent;
   dayCheckBox[i].hint:='Check to print '+dayname[i-1];
   dayCheckBox[i].caption:=dayname[i-1];
   dayCheckBox[i].enabled:=true;
   v2:=(i-1) div 3;  v1:=(i) mod 3;
   if v1=0 then v1:=2 else v1:=v1-1;
   dayCheckBox[i].width:=mxdayname+actcheckboxsz;
   dayCheckBox[i].left:=label2.left+v1*(mxdayname+xgap);
   dayCheckBox[i].top:=label2.top+label2.height+ygapTop+v2*(dayCheckBox[1].height+ygap);
  end;

 for i:=1 to years do
  begin
   yearCheckBox[i]:=tCheckBox.create(application);
   yearCheckBox[i].parent:=label3.parent;
   yearCheckBox[i].hint:='Check to print '+yeartitle+' '+yearname[i-1];
   yearCheckBox[i].caption:=yearname[i-1];
   yearCheckBox[i].enabled:=true;
   v2:=(i-1) div 5;  v1:=(i) mod 5;     // 3, 3 mantis-1304
   if v1=0 then v1:=4 else v1:=v1-1;   //2 
   yearCheckBox[i].width:=mxyearname+actcheckboxsz;
   yearCheckBox[i].left:=label3.left+v1*(mxyearname+xgap);
   yearCheckBox[i].top:=label3.top+label3.height+ygapTop+v2*(yearCheckBox[1].height+ygap);
  end;

 usingResources:=true;
  { make the number of Tabs = number of Pages, and have the same names }
  TabSet.Tabs := Notebook.Pages;
end;

procedure Tprefdlg.RefreshStaticControls;
var
  i: Integer;
begin
  {general}
  NoteBook.pageindex:=XML_DISPLAY.prefNotebookPageIndex;
  tabset.tabindex:=XML_DISPLAY.prefNotebookPageIndex;
  {student section}
  checkbox1.checked:=XML_DISPLAY.stSex;
  checkbox2.checked:=XML_DISPLAY.stClass;
  checkbox3.checked:=XML_DISPLAY.stHouse;
  checkbox4.checked:=XML_DISPLAY.stID;
  checkbox5.checked:=XML_DISPLAY.stTutor;
  checkbox6.checked:=XML_DISPLAY.stHome;
  checkbox11.Checked:=XML_DISPLAY.sTtag;
  checkbox24.checked:=XML_DISPLAY.stYear;

  //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
  begin
  checkbox28.checked:=XML_DISPLAY.stID2;
  chkEmail.Checked:=XML_DISPLAY.stEmail;
  end;

  checkbox7.checked:=XML_DISPLAY.blockshow;
  checkbox8.checked:=XML_DISPLAY.double_space;

  radiogroup1.itemindex:=XML_DISPLAY.OberonOutputType;
  checkbox29.checked:=XML_DISPLAY.StHeadShow;
  GenderOrder1.ItemIndex:=XML_DISPLAY.SexSelect;
  liststyle1.ItemIndex:=XML_DISPLAY.sTselect;

  {timetable section}
  ShowTsNames;
  for i:=1 to years do yearCheckBox[i].checked:=XML_DISPLAY.Pyear[i-1];
  for i:=1 to days do dayCheckBox[i].checked:=XML_DISPLAY.Dprint[i];
  checkbox9.checked:=XML_DISPLAY.Tfreeshow;
  checkbox10.checked:=XML_DISPLAY.Rfreeshow;
  SelectDaysChkBox.Checked:=XML_DISPLAY.ttWeekDaysFlg;
  ttStartChkBox.Checked:=XML_DISPLAY.ttClockShowFlg;
  maskedit1.text:=inttostr(XML_DISPLAY.Pweek);
  YearClass1.ItemIndex:=XML_DISPLAY.Tyr;

  checkbox12.checked:=XML_DISPLAY.listshowClashes;
  checkbox13.checked:=XML_DISPLAY.Formfeed;
end;

procedure Tprefdlg.ComboBox2Change(Sender: TObject);
var
 oldDayGroup: integer;
begin
 oldDayGroup:=MyDayGroup;
 MyDayGroup:=ComboBox2.ItemIndex+1;
 if (oldDayGroup<>MyDayGroup) and (MyDayGroup>0) then ShowTsNames;
end;

procedure Tprefdlg.Button1Click(Sender: TObject);
begin
  checkbox1.checked := True;
  checkbox2.checked := True;
  checkbox3.checked := True;
  checkbox4.checked := True;
  checkbox5.checked := True;
  checkbox6.checked := True;
  checkbox11.Checked := True;
  checkbox24.checked := True;
  CheckBox28.Checked := True;
  chkEmail.Checked   := True;
end;

procedure Tprefdlg.Button2Click(Sender: TObject);
begin
  checkbox1.checked := False;
  checkbox2.checked := False;
  checkbox3.checked := False;
  checkbox4.checked := False;
  checkbox5.checked := False;
  checkbox6.checked := False;
  checkbox11.Checked := False;
  checkbox24.checked := False;
  CheckBox28.Checked := False;
  chkEmail.Checked   := False;
end;

procedure Tprefdlg.Button5Click(Sender: TObject);
var
 i: integer;
begin
 for i:=1 to days do dayCheckBox[i].Checked:=true;
end;

procedure Tprefdlg.Button6Click(Sender: TObject);
var
 i: integer;
begin
 for i:=1 to days do dayCheckBox[i].Checked:=false;
end;

procedure Tprefdlg.Button3Click(Sender: TObject);
var
 i: integer;
begin
 for i:=1 to years do yearCheckBox[i].Checked:=true;
end;

procedure Tprefdlg.Button4Click(Sender: TObject);
var
 i: integer;
begin
 for i:=1 to years do yearCheckBox[i].Checked:=false;
end;

procedure Tprefdlg.Button7Click(Sender: TObject);
var
 i,j: integer;
begin
 for i:=1 to periods do if periodCheckBox[i].Visible then
   periodCheckBox[i].Checked:=true;
 for j:=1 to dg[MyDayGroup,0] do
  for i:=1 to periods do if periodCheckBox[i].Visible then
   tmpTsOn[dg[MyDayGroup,j],i-1]:=true;
end;

procedure Tprefdlg.Button8Click(Sender: TObject);
var
 i,j: integer;
begin
 for i:=1 to periods do if periodCheckBox[i].Visible then
   periodCheckBox[i].Checked:=false;
 for j:=1 to dg[MyDayGroup,0] do
  for i:=1 to periods do if periodCheckBox[i].Visible then
   tmpTsOn[dg[MyDayGroup,j],i-1]:=false;
end;

end.
