unit Edstud;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Mask, TimeChartGlobals,ClassDefs,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;



type
  Tedstuddlg = class(TForm)
    GroupBox1: TGroupBox;
    lblStudentNo: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblID: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edtSurname: TEdit;
    Edit2: TEdit;
    Edit6: TEdit;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    previous: TBitBtn;
    next: TBitBtn;
    btnFind: TBitBtn;
    Label16: TLabel;
    NameFindBtn: TRadioButton;
    SexFindBtn: TRadioButton;
    ClassFindBtn: TRadioButton;
    HouseFindBtn: TRadioButton;
    TutorFindBtn: TRadioButton;
    HomeFindBtn: TRadioButton;
    IDfindBtn: TRadioButton;
    FirstFindBtn: TRadioButton;
    Edit10: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    btnAllocate: TBitBtn;
    lblTags: TLabel;
    CheckBox2: TCheckBox;
    SpeedButton1: TSpeedButton;
    ComboBox1: TComboBox;
    Label4: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    YrFindBtn: TRadioButton;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label15: TLabel;
    Edit3: TEdit;
    lblPrintTimeTable: TLabel;
    ScrollBox1: TScrollBox;
    Label9: TLabel;
    txtEmail: TEdit;
    lblNoAccess: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure nextClick(Sender: TObject);
    procedure previousClick(Sender: TObject);
    procedure updateClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);

    procedure MyEdit9Change(Sender: TObject);   {assigned to onchange for dynamically created edit boxes}
    procedure MyEdit9Enter(Sender: TObject);   { "   " }
    procedure MyEdit9Exit(Sender: TObject);
    procedure MyEdit9KeyPress(Sender: TObject; var Key: Char);

    procedure btnAllocateClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure edtSurnameChange(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure edtSurnameEnter(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit6Enter(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox5KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox5Exit(Sender: TObject);
    procedure ComboBox5Enter(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox2Exit(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox3Exit(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox4Exit(Sender: TObject);
    procedure ComboBox4Enter(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure ComboBox6Enter(Sender: TObject);
    procedure ComboBox6Exit(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure NameFindBtnClick(Sender: TObject);
    procedure FirstFindBtnClick(Sender: TObject);
    procedure SexFindBtnClick(Sender: TObject);
    procedure IDfindBtnClick(Sender: TObject);
    procedure ClassFindBtnClick(Sender: TObject);
    procedure HouseFindBtnClick(Sender: TObject);
    procedure TutorFindBtnClick(Sender: TObject);
    procedure HomeFindBtnClick(Sender: TObject);
    procedure YrFindBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function ValidEdStud: boolean;
    function sepUpdateCheck: integer;
    function ShowStud: Boolean;
    procedure findStudentPrc;
    procedure updateFindEnabledStatus;
    procedure updateSearchHighlight;
    function TextForFind:string;
    procedure NextBtnStatus(k: integer);
    procedure CheckYearAccess;
  end;

var
  edstuddlg: Tedstuddlg;

implementation

uses
  tcommon,DlgCommon, stcommon, studlist,block1,main,tcommon2,findstud,tcommon5,
  customoutput, uAMGFamily, uAMGTeacher;

{$R *.DFM}

var
 edit9:  tpEdit9;
 needUpdate:                    bool;
 usingResources:                bool;
 tagbox:                        array[1..nmbrTags] of Tcheckbox;
 sTfindStr:                     string;
 sTpos1,sTpoint,start,sTfound:   integer;
 oopsNameFlag:                   wordbool;
 comDatFocus:                 integer;
 CUPAcnt,ToYear:     smallint;
 MyStud: tpStudRec;
 StN: integer;
// MyStudID2: string[szID];
 MyStudID2: string[50];
 MyEmail: string[100];

function Tedstuddlg.ValidEdStud: boolean;
var
 i,j,k:       integer;
 tmpStr:  string;
 fsubnm:    integer;
 dup:           bool;
begin
 result:=false;
 ClearMyStud(MyStud);

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  MyStudID2:='';
  MyEmail:='';
 end;

 label3.caption:='';  k:=0;
 if (finish.tag=1) or (not(checkbox1.checked) and (finish.tag=2)) then
  if (StN=0) then
   begin
    ShowMsg('No student selected.'+endline+
      'Please select a student to edit.'+endline,edtSurname);
    exit;
   end;

 for i:=1 to nmbrChoices do
  begin
   tmpStr:=trim(edit9[i].text);
   if tmpStr>'' then
    begin
     if ChoiceNotFound(fsubnm,i,tmpStr,edit9[i]) then exit;
     if NAused(fsubnm,i,edit9[i]) then exit;
     if (GsubXref[fsubnm]>0) then
       if finish.tag=1 then
        if XML_DISPLAY.editBlockCheck and checkbox1.enabled then   {block check}
        if NotInBlock(fsubnm,i,edit9[i]) then exit;
     MyStud.Choices[i]:=fsubnm;
    end; {if tmpStr>''}
  end; {for i}

 MyStud.ID:=trim(edit6.text);

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  MyStudID2:=trim(edit3.Text);
  MyEmail := trim(txtEmail.Text);
 end;

 if ((finish.tag=1) or ((finish.tag=2) and (checkbox1.checked=false))) then
  begin
   MyStud.stname:=trim(edtSurname.text);
   MyStud.first:=trim(edit2.text);
   if MyStud.stname='' then
    begin
     ShowMsg('Please enter a name for this student.',edtSurname);
     exit;
    end;
  end; {only for ed stud not com dat}

 MyStud.Sex:=uppercase(trim(combobox5.text));
 if finish.tag=1 then {change student check only not for common data}
  if ((MyStud.Sex<>genderShort[1]{'F'}) and (MyStud.Sex<>genderShort[0]{'M'}) and (MyStud.Sex<>genderShort[2]{'X'}) ) then   //---- mantis- 1566
   begin
    ComboMsg('Please check the sex, enter '+genderShort[0]+' for '+
     genderLong[0]+' or '+genderShort[1]+' for '+genderLong[1]+'.',Combobox5);
    exit; {return to editing}
   end;

 tmpStr:=trim(combobox1.text);
 if ((tmpStr='') and (finish.Tag=1)) then
  begin
   ComboMsg('Please enter year of student.',combobox1);
   exit; {return to editing}
  end;

 if tmpStr>'' then
  if BadComboYear(MyStud.TcYear,combobox1) then exit;

 tmpStr:=trim(combobox6.text);
 if tmpStr>'' then
  begin
   MyStud.tcClass:=findclass2(tmpStr);
   if MyStud.tcClass=0 then
    begin
     ComboMsg('The Roll Class code entered could not be found.',combobox6);
     exit;
    end;
   end;  {if tmpStr>''}

 tmpStr:=trim(combobox2.text);
 if tmpStr>'' then
  begin
   MyStud.House:=findhouse2(tmpStr);
   if MyStud.House=0 then
    begin
     ComboMsg('The House entered could not be found.',combobox2);
     exit; {return to editing}
    end;
   end; {if tmpStr>''}

 tmpStr:=uppercase(trim(combobox3.text));
 if tmpStr>'' then
  begin
   MyStud.tutor:=findTe(tmpStr,label3);
   if MyStud.tutor=0 then
    begin
     ComboMsg('The Tutor code entered could not be found.',combobox3);
     exit; {return to editing}
    end;
   end; {if tmpStr>''}

 tmpStr:=uppercase(trim(combobox4.text));
 if tmpStr>'' then
  begin
   MyStud.home:=findroom(tmpStr,label3);
   if MyStud.home=0 then
    begin
     ComboMsg('The Home Room code entered could not be found.',combobox4);
     exit; {return to editing}
    end;
   end; {if tmpStr>''}

 dup:=false;
 for i:=1 to (nmbrChoices-1) do
  begin
   for j:=(i+1) to nmbrChoices do
    if (MyStud.Choices[i]<>0) then
     if MyStud.Choices[i]=MyStud.Choices[j] then
      begin
       dup:=true;
       k:=j;
       break;
      end;
    if dup then break;
  end;
 if dup then
  begin
   ShowMsg('Student subject choice code number '+inttostr(k)+
    ' is a DUPLICATE entry.'+endline+'Please enter a different subject code.',edit9[k]);
   exit; {return to editing}
  end;

 // do student duplicate prevention check;
 if (finish.tag=1) then if DupStudent(StN,MyStud,edit2) then exit;
 result:=true;
end;

function Tedstuddlg.sepUpdateCheck: integer;
var
 i:   integer;
 i2: word;
begin
 result:=0;
 if not(ValidEdStud) then exit;
 label3.caption:='';
 if finish.tag=1 then
  begin   {assign to vars}
   XML_STUDENTS.Stud[StN]:=MyStud;
   i2:=0;
   for i:=1 to nmbrTags do
     if tagbox[i].checked then i2:=(i2 or (1 shl (i-1)));
   XML_STUDENTS.Stud[StN].tctag:=i2;
   CountChmax;
   getStudentFontWidths;
   result:=StN;
  end;
  if checkbox4.checked then   {id scan}
  begin
    if Edit6.Visible and Edit6.Enabled then
    begin
      Edit6.SetFocus;
      Edit6.SelectAll;
    end;
  end
  else
  begin
    if Edit9[1].Visible and Edit9[1].Enabled then
     Edit9[1].SetFocus;
  end;
end;

function GotYearAccess(MyYear: smallint): boolean;
begin
 result:=false;
 if CheckUserYearPassAccess(MyYear) then result:=true
  else if (usrPassYear=-1) or ((usrPassYear and (1 shl MyYear))=(1 shl MyYear)) then {user has access to year}
   result:=CheckPriorYearAccess4(MyYear,true);
end;

procedure Tedstuddlg.CheckYearAccess;
var
 CanChange,ComGroup: boolean;
 StudYear:  smallint;
 astr: string;
begin
 CanChange:=true; StudYear:=0;
 ComGroup:=checkbox1.checked and (finish.tag=2);
 astr:='';
 if StN>0 then
  begin
   StudYear:=XML_STUDENTS.Stud[StN].tcYear;
   if not(ComGroup) then  {only for individual stud edits}
    CanChange:=GotYearAccess(StudYear);
   astr:='NO ACCESS to change student in '+YearShort+' '+yearname[StudYear];
  end;
 if CanChange then
  if ToYear>=0 then
   if (ToYear<>StudYear) or ComGroup then
    begin
     CanChange:=GotYearAccess(ToYear);
     if not(CanChange) then
      astr:='NO ACCESS to change student TO '+YearShort+' '+yearname[ToYear];
    end;
 if CanChange then
  begin
   lblNoAccess.Text:='';
   lblNoAccess.Hide;
   update.Enabled:=true;
  end
 else
  begin
   lblNoAccess.Left := GroupBox1.Left+1;
   lblNoAccess.Width := GroupBox1.Width-2; 
   lblNoAccess.Text:=astr;
   lblNoAccess.Show;
   update.Enabled:=false;
  end;
end;

function Tedstuddlg.ShowStud: Boolean;
var
  i: integer;
begin
  Result := True;
  case finish.tag of
   1:
   begin     {CHANGE STUDENT}
     if ((StN>0) and (StN<=XML_STUDENTS.numstud)) then
     begin
       edit10.Text:=inttostr(StN);
       combobox1.ItemIndex := ComboBox1.Items.IndexOf(yearname[XML_STUDENTS.Stud[StN].tcYear]);
       combobox1change(self);
       edtSurname.text:=trim(XML_STUDENTS.Stud[StN].StName);
       edit2.text:=trim(XML_STUDENTS.Stud[StN].First);
       combobox5.ItemIndex := combobox5.Items.IndexOf(Trim(XML_STUDENTS.Stud[StN].Sex));
       combobox6.ItemIndex :=combobox6.Items.IndexOf(ClassCode[XML_STUDENTS.Stud[StN].TcClass]);
       combobox2.ItemIndex := combobox2.Items.IndexOf(HouseName[XML_STUDENTS.Stud[StN].House]);
       edit6.text:=trim(XML_STUDENTS.Stud[StN].ID);

       //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
       begin
         edit3.Text:=trim(studID2[StN]);
         txtEmail.Text:=trim(studEmail[StN]);
       end;


       ComboBox3.ItemIndex := ComboBox3.Items.IndexOf(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[StN].Tutor,0]);
       combobox4.ItemIndex := combobox4.Items.IndexOf(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[StN].Home,1]);
       for i:=1 to nmbrChoices do
        if ((XML_STUDENTS.Stud[StN].Choices[i]>0) and (XML_STUDENTS.Stud[StN].Choices[i]<=numCodes[0])) then
          edit9[i].Text :=trim(SubCode[XML_STUDENTS.Stud[StN].Choices[i]])
        else
          edit9[i].text:='';
       label3.caption:='';   {no error msg}
       for i:=1 to nmbrTags do
         if bool((1 shl (i-1)) and XML_STUDENTS.Stud[StN].tctag) then tagbox[i].checked:=true else tagbox[i].checked:=false;
       if Edit9[1].Visible and Edit9[1].Enabled then
         Edit9[1].SetFocus;
      end
     else
      begin
       combobox1.text:='';  edit10.Text:='';
       edtSurname.text:='';      edit2.text:='';
       combobox5.text:='';  combobox6.text:='';
       combobox2.text:='';  edit6.text:='';
       combobox3.text:='';  combobox4.text:='';
       for i:=1 to nmbrChoices do edit9[i].text:='';
       label3.caption:='Student not found !';
       label3.visible:=true;
       for i:=1 to nmbrTags do tagbox[i].checked:=false;
      end;
    end; {case 1}
   2:
   begin        {COMMON DATA}
     if ((StN>0) and (StN<=XML_STUDENTS.numstud)) then
     begin
        edit10.Text:=inttostr(StN);
        edtSurname.text:=trim(XML_STUDENTS.Stud[StN].StName);
        edit2.text:=trim(XML_STUDENTS.Stud[StN].First);
        label3.caption:='';   {no error msg}
     end
     else
     begin
        edtSurname.text:='';   edit10.Text:='';
        edit2.text:='';
        label3.caption:='Student not found !';
        label3.visible:=true;
     end;
   end; {case 2}
  end; {case }
  CheckYearAccess;
  Result := StN <> 0;
end;

procedure restoreComDatFocus;
var
 i: integer;
begin
 with edstuddlg do
  case comDatFocus of
   1:
   begin
     if edtSurname.Visible and edtSurname.Enabled then
     begin
       edtSurname.SetFocus;
       edtSurname.SelectAll;
     end;
   end;
   2:
   begin
     if Edit2.Visible and Edit2.Enabled then
     begin
       Edit2.SetFocus;
       Edit2.SelectAll;
     end;
   end;
   3: begin combobox5.setfocus; combobox5.selectall; end;
   4: begin combobox6.setfocus; combobox6.selectall; end;
   5: begin combobox2.setfocus; combobox2.selectall; end;
   6: begin edit6.setfocus; edit6.selectall; end;
   7: begin combobox3.setfocus; combobox3.selectall; end;
   8: begin combobox4.setfocus; combobox4.selectall; end;
   10: begin combobox1.setfocus; combobox1.selectall; end;
   91..(90+nmbrChoices):
   begin
     i:=comDatFocus-90;

     if Edit9[i].Visible and Edit9[i].Enabled then
     begin
       Edit9[i].SetFocus;
       Edit9[i].SelectAll;
     end;
   end;
  end; {case}
end;

procedure updateShowClashes;
var
 i,k:       integer;
  function GetStudentHasFamilyClashOnSubject(const pSubjectCode: string): Boolean;
  begin
    if CustomerIDnum = cnBrisbaneDistEd then
      Result := FamilyClashes.HasFamilyClashOnSubject(XML_STUDENTS.Stud[StN].ID, pSubjectCode);
  end;

begin
 if not(XML_DISPLAY.listShowClashes) then exit;
 for i:=1 to nmbrChoices do
  XML_STUDENTS.Stud[0].choices[i]:=findChoice(edit9[i].text,edstuddlg.label3,false);
 for i:=1 to nmbrChoices do
 begin
  k:=XML_STUDENTS.Stud[0].choices[i];
  if StN>0 then
  begin
   if CheckStudChoiceForClash(0,k) then edit9[i].color:=clRed
   else
     if (CustomerIDnum = cnBrisbaneDistEd) and (GetStudentHasFamilyClashOnSubject(edit9[i].Text)) then
       edit9[i].Color := clMoneyGreen
     else
       edit9[i].color:=clWindow;
  end;
 end;
end;

function Tedstuddlg.TextForFind:string;
var
 s: string;
begin
 s:='';
 case XML_DISPLAY.sTfind of
  1: s:=edtSurname.text;
  2: s:=edit2.text;
  3: s:=combobox5.text;
  4: s:=edit6.text;
  5: s:=combobox6.text;
  6: s:=combobox2.text;
  7: s:=combobox3.text;
  8: s:=combobox4.text;
  9: s:=combobox1.text;
 end; {case}
 result:=trim(s);
end;

procedure Tedstuddlg.updateFindEnabledStatus;
begin
  btnFind.Enabled := TextForFind <> '';
end;

procedure Tedstuddlg.MyEdit9KeyPress(Sender: TObject; var Key: Char);
begin
 if key=chr(0) then key := chr(9);
end;

procedure Tedstuddlg.MyEdit9Change(Sender: TObject);
var
 cntrli,i,k:    integer;
 s:          string;
begin
 try
  CountGroupSubs;
  cntrli:=activecontrol.tag;
  if ((cntrli<1) or (cntrli>nmbrChoices)) then exit;  {during load causes problems otherwise}
  i:=findChoice(edit9[cntrli].text,label3,true);
  if i>0 then
   begin
    if i=subNA then
     label3.caption:='Enter Choice code'
    else
     begin
      for k:=1 to nmbrChoices do   {on edits not saved choices}
       if ((k<>cntrli) and (findchoice(edit9[k].text,label3,false)=i)) then
        begin
         label3.caption:='DUPLICATE student subject choice';
         break;
        end;
     end;
   end;
  if finish.tag=1 then
   if XML_DISPLAY.editBlockCheck then   {block check}
    if checkbox1.enabled then
     if cntrli<=XML_DISPLAY.blocknum then
      if (i<>0) and not(subISAlreadyinBlock(i,cntrli)) then
        label3.caption:='Not in Block!';

  updateShowClashes;
  {handle step-on for barcode use}
  if checkbox3.checked then
   begin
    s:=edit9[cntrli].text;
    if length(s)=lencodes[0] then
     if cntrli<nmbrchoices then
     begin
       if Edit9[cntrli+1].Visible and Edit9[cntrli+1].Enabled then
         Edit9[cntrli+1].SetFocus;
     end;
   end;

 except
   dbgi:=99;
 end;
end;

procedure Tedstuddlg.MyEdit9Enter(Sender: TObject);
var
  i:  Integer;
  cntrli,k: Integer;
  lTeacherName: string;
begin
 i:=activecontrol.tag;
 comDatFocus:=90+i;
 label3.visible:=true;
 if Edit9[i].Visible and Edit9[i].Enabled then
 begin
   Edit9[i].SetFocus;
   Edit9[i].SelectAll;
 end;

 {don't force change - update label here - don't want barcode auto step to happen on entry}
 CountGroupSubs;
 cntrli:=activecontrol.tag;
 if ((cntrli<1) or (cntrli>nmbrChoices)) then exit;  {during load causes problems otherwise}
 i:=findChoice(edit9[cntrli].text,label3,true);
 if i>0 then
  begin
   if i=subNA then
    label3.caption:='Enter Choice code'
   else
    begin
     lTeacherName := Teachers.GetTeacherNameBySubject(Edit9[cntrli].Text);
     if Trim(lTeacherName) <> '' then
       label3.Caption := label3.Caption + ' - ' + lTeacherName;
     for k:=1 to nmbrChoices do   {on edits not saved choices}
      if ((k<>cntrli) and (findchoice(edit9[k].text,label3,false)=i)) then
       begin
        label3.caption:='DUPLICATE student subject choice';
        break;
       end;
    end;
 end;
 if finish.tag=1 then
  if XML_DISPLAY.editBlockCheck then   {block check}
   if checkbox1.enabled then
    if cntrli<=XML_DISPLAY.blocknum then
     if (i<>0) and not(subISAlreadyinBlock(i,cntrli)) then
      begin
       label3.caption:='Not in Block!';
       label3.visible:=true;
      end;

 updateShowClashes;
end;

procedure Tedstuddlg.MyEdit9Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Tedstuddlg.updateSearchHighlight;
begin
 edtSurname.color:=clWindow;   edit2.color:=clWindow;   combobox5.color:=clWindow;
 combobox6.color:=clWindow; combobox2.color:=clWindow; edit6.color:=clWindow;
 combobox3.color:=clWindow; combobox4.color:=clWindow;
 combobox1.color:=clWindow;
 case XML_DISPLAY.sTfind of
  1: HiLiteEdit(edtSurname); {surname}
  2: HiLiteEdit(edit2); {first name}
  3: HiLiteCombo1(comboBox5);  {sex}
  4: HiLiteEdit(edit6); {ID}
  5: HiLiteCombo1(comboBox6);  {roll class}
  6: HiLiteCombo1(comboBox2);  {house}
  7: HiLiteCombo1(comboBox3);  {tutor}
  8: HiLiteCombo1(comboBox4);  {home room}
  9: HiLiteCombo1(comboBox1);  {year}
 end;
 updateFindEnabledStatus;
end;

function SearchTarget(i,aLen:integer):string;
var
 bStr: string;
begin
 bStr:='';
 case XML_DISPLAY.sTfind of
  1: bStr:=copy(XML_STUDENTS.Stud[i].StName,1,aLen); {surname}
  2: bStr:=copy(XML_STUDENTS.Stud[i].First,1,aLen); {first name}
  3: bStr:=XML_STUDENTS.Stud[i].Sex; {sex}
  4: bStr:=copy(XML_STUDENTS.Stud[i].ID,1,aLen);  {id}
  5: bStr:=copy(ClassCode[XML_STUDENTS.Stud[i].TcClass],1,aLen); {class}
  6: bStr:=copy(HouseName[XML_STUDENTS.Stud[i].House],1,aLen); {house}
  7: bStr:=copy(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].tutor,0],1,aLen); {tutor}
  8: bStr:=copy(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].home,1],1,aLen); {home}
  9: bStr:=copy(yearname[XML_STUDENTS.Stud[i].TcYear],1,aLen); {year}
 end; {case}
 result:=UpperCase(bStr);
end;

procedure Tedstuddlg.findStudentPrc;
var
 aStr,bStr:    string;
 i:      integer;
 aLen:           integer;
 oldNum:         integer;
 startNum:       integer;
begin
 oldnum:=StN;  startNum:=1;
 sTfound:=0; sTpoint:=0;
 aStr:=UpperCase(TextForFind);
 aLen:=Length(aStr);
 if aStr='' then
 begin
  StN:=0; ShowStud;
  exit;
 end;

 if XML_DISPLAY.sTfind=1 then
  begin  //binary search on surname searches only
   i:=findStudBIN(astr);
   if (i>0) then {found him}
    begin
     sTpoint:=i;
     sTfound:=i;
    end;
  end
 else
  begin  {sTfind<>1}
   if aStr=SearchTarget(oldnum,aLen) then {search for next match instead of first match}
   for i:=1 to groupnum do    {get new start pos}
    if oldnum<StGroup[i] then
     begin
      startNum:=StGroup[i];
      break;
     end;

   if aStr=sTfindStr then start:=stpos1+1 else start:=startNum;
   if checkbox4.checked then start:=1; {for id scan search want first NOT next}
   for i:=start to XML_STUDENTS.numstud do
    begin
     bStr:=SearchTarget(i,aLen);
     if aStr=bStr then {found him}
      begin
       sTpoint:=i;
       sTfound:=i;
       break;
      end;
    end; {for i}
  end; { sTfind<>1 }

 if bool(sTfound) then
 begin
  sTfindStr:=aStr;
  sTpos1:=sTpoint;
 end;
end;

procedure Tedstuddlg.FormCreate(Sender: TObject);
var
 i:       integer;
 ssx,ssy: integer;
const
 xgap=5;
 ygap=5;
begin
 oopsNameFlag:=false; StN:=0;   ToYear:=-1;
// ssx:=(groupbox1.clientwidth-label5.left-(6*xgap)) div 5;
 ssx:=(scrollbox1.clientwidth-label5.left-(6*xgap)) div 5;
 ssy:=edit6.height;
 comDatFocus:=1;
 sTfindStr:='';

 {if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  label15.visible:=true;
  edit3.visible:=true;
 end;}

 for i:=1 to nmbrChoices do
 begin
  edit9[i]:= TEdit.Create(Self);  //application
  edit9[i].tag:=i;
  edit9[i].maxlength:=lencodes[0];
  edit9[i].width:=ssx; edit9[i].height:=ssy;
  edit9[i].parent:=scrollbox1; //edit9[i].parent:=groupbox1;
//  edit9[i].left:=label13.left+(((i-1) mod 5)*(ssx+xgap));
  edit9[i].left:=label13.left-8+(((i-1) mod 5)*(ssx+xgap));
//  edit9[i].top:=label13.top+label13.height+ygap+(((i-1) div 5)*(ssy+ygap));
  edit9[i].top:=(((i-1) div 5)*(ssy+ygap));
   edit9[i].onChange:=MyEdit9Change;  {atach dynamic method links}
  edit9[i].onEnter:=MyEdit9Enter;
  edit9[i].onExit:=MyEdit9Exit;
  edit9[i].onKeyPress:=MyEdit9KeyPress;
 end; {for i}
 for i:=1 to nmbrtags do
  begin
   tagbox[i]:=tcheckbox.create(application);
   tagbox[i].parent:=groupbox1;
   tagbox[i].Alignment:=taLeftJustify;
   tagbox[i].caption:=TagCode[i];
   tagbox[i].width:=30;
   tagbox[i].top:=(((i-1)div 9)*(tagbox[i].Height+(ygap div 2)))+lblTags.top-2;   //was 8  mantis 0727
   if i<10 then                                                                   //was9 ,,
     tagbox[i].left:=lblTags.width+lblTags.left+((i-1)*(tagbox[i].width+xgap*3))+xgap
    else tagbox[i].left:=tagbox[i-9].left;
   tagbox[i].ShowHint:=true;
   tagbox[i].Hint:=TagName[i];
  end;
 {init combobos}
 combobox1.clear; for i:=years_minus_1 downto 0 do combobox1.items.add(yearname[i]);
 combobox2.clear; for i:=1 to housecount do combobox2.items.add(housename[i]);
 combobox3.clear; for i:=1 to codeCount[1] do combobox3.items.add(XML_TEACHERS.Tecode[codepoint[i,1],0]);
 combobox4.clear; for i:=1 to codeCount[2] do combobox4.items.add(XML_TEACHERS.Tecode[codepoint[i,2],1]);
 combobox5.clear; combobox5.items.add('M'); combobox5.items.add('F');   combobox5.items.add('X');  //---- mantis-1566
 combobox6.clear; for i:=1 to RollClassPoint[0] do combobox6.items.add(ClassCode[RollClassPoint[i]]);
 speedbutton1.enabled:=(StN>0);
 usingResources:=true;
 if needClashMatrixRecalc then CalculateClashmatrix;
end;

procedure Tedstuddlg.FormShow(Sender: TObject);
begin
  {dlg used for both change stud and common data}
  case finish.tag of
  1: begin
      Caption := 'Change Student';
      CheckBox1.Caption := 'Block Check';
      label2.Caption := 'Students: ' + IntToStr(XML_STUDENTS.numstud);
      checkbox1.Hint := 'Ensures choices are aligned with blocks';
      checkbox1.Checked := XML_DISPLAY.editBlockCheck;

     end;
  2: begin
      Caption := 'Common Data';
      CheckBox1.Caption := 'All Students';
      label2.Caption := 'Students selected: '+IntToStr(groupnum);
      btnAllocate.Visible := False;
      checkbox1.Hint := 'Check to add common data to all students in group';
      checkbox1.Checked:=XML_DISPLAY.commonDataAll;
      checkbox2.Visible := True;
      //lblID.Visible := False;
      //Edit6.Visible := False;
      Edit3.Enabled := False;
      Edit3.ReadOnly := True;
      Edit6.Enabled := False;
      Edit6.ReadOnly := True;
      Label12.Left := lblID.Left;
      Label12.Top := lblID.Top;
      lblID.Visible := False;
      Edit3.Visible := False;
      Label15.Visible := False;
      Edit6.Visible := False;
      ComboBox4.Left := Edit6.Left;
      ComboBox4.Top := Edit6.Top;
     end;
  end; {case}

  caption:=caption+GroupCaption;
  edtSurname.maxlength:=szStName;  edit2.maxlength:=szStFirst;
  combobox5.maxlength:=1;   combobox6.maxlength:=szClassName;
  combobox2.maxlength:=szHousename;
  Edit6.MaxLength := szID;
  Edit3.MaxLength := 10;
  combobox3.maxlength:=lencodes[1];  combobox4.maxlength:=lencodes[2];
  combobox1.maxlength:=szYearname;
  needupdate:=false;

  if ((MySelStud>0) and (MySelStud<=XML_STUDENTS.numstud)) then StN:=MySelStud;
  previous.enabled:=(StN>1);
  next.enabled:=(StN<StGroup[groupnum]);

  if bool(blockload) then  countSubsInBlock;
  if ((bool(blockload)) and (subsinblock>0)) then
  begin
    btnAllocate.enabled:=true;
    checkbox1.enabled:=true;
  end
  else
   begin
     btnAllocate.enabled:=false;
     if (finish.tag = 1)  then
       checkbox1.Enabled := False
     else
       checkbox1.Enabled := True;
   end;

  label3.caption:=''; {initially no error msg}
  case XML_DISPLAY.sTfind of
    1: NameFindBtn.checked:=true;
    2: FirstFindBtn.checked:=true;
    3: SexFindBtn.checked:=true;
    4: IDfindBtn.checked:=true;
    5: ClassFindBtn.checked:=true;
    6: HouseFindBtn.checked:=true;
    7: TutorFindBtn.checked:=true;
    8: HomeFindBtn.checked:=true;
    9: YrFindBtn.Checked:=true;
  end;
  if btnAllocate.Visible then
    btnFind.Left := 4
  else
    btnFind.Left := btnAllocate.Left;

  updateSearchHighlight;
  updateShowClashes;

  if edtSurname.Visible and edtSurname.Enabled then
    edtSurname.SetFocus;
  if StN > 0 then
    if Edit9[1].Visible and Edit9[1].Enabled then
      Edit9[1].SetFocus;
  if ShowStud then
    MyEdit9Enter(Self);
end;

procedure Tedstuddlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
 i:      integer;
begin
 action:=caFree;
 try
  screen.cursor:=crHourglass;
  if needupdate then
  begin
   SaveAllStudentYears;
   dumpOldClassFiles;
  end;
 finally
  if SaveStudFlag=false then CheckAccessRights(utStud,36,false);
  screen.cursor:=crDefault;
 end; {try}
 if usingResources then
 begin
  usingResources:=false; {sometimes called more than once, prevent attempted release if already released}
  edstuddlg.hide; {prevent seeing controls beeing removed -slows things down a lot}
  for i:=1 to nmbrChoices do edit9[i].free;
  for i:=1 to nmbrtags do tagbox[i].free;
 end;
end;

procedure Tedstuddlg.NextBtnStatus(k: integer);
begin
 previous.enabled:=(k>1);
 next.enabled:=(k<groupnum);
 if (StN=0) then
  begin
   next.enabled:=false;  previous.enabled:=false;
  end;
end;

procedure Tedstuddlg.nextClick(Sender: TObject);
var
 i,j:     integer;
begin
 oopsNameFlag:=false;
 label3.caption:='';
 j:=0;
 for i:=1 to groupnum do
  if StN=StGroup[i] then
  begin
   j:=i;
   break;
  end;
 if j=0 then
 begin
  j:=1;
   while ((StGroup[j]<StN) and (j<groupnum)) do inc(j);
 end
 else
  begin
   inc(j);
   if j>groupnum then j:=groupnum;
  end;
 StN:=StGroup[j]; ShowStud;
 NextBtnStatus(j);
 updateShowClashes;
 if finish.tag=2 then restoreComDatFocus; {common data}
end;

procedure Tedstuddlg.previousClick(Sender: TObject);
var
 i,j:     integer;
 msg:     string;
begin
 oopsNameFlag:=false;
 label3.caption:='';
 j:=0;
 for i:=1 to groupnum do
  if StN=StGroup[i] then
  begin
   j:=i;
   break;
  end;
 if j=0 then
 begin
  j:=groupnum;
  while ((StGroup[j]>StN) and (j>1)) do dec(j);
 end
 else
  begin
   dec(j);
   if j<1 then
   begin
    j:=1;
    msg:='At start of student list in group '+groupname+'.'+endline;
    messagedlg(msg,mtError,[mbOK],0);
   end;
  end;

 StN:=StGroup[j]; ShowStud;
 NextBtnStatus(j);

 updateShowClashes;
 if finish.tag=2 then restoreComDatFocus; {common data}
end;

procedure Tedstuddlg.updateClick(Sender: TObject);
var
 i,j,k:       integer;
 msg:         string;
 i2:          word;

   function CommonDataAdd(k:integer):boolean;
   var
    i,m,n: integer;
   begin
     result:=false;
     StudYearFlag[XML_STUDENTS.Stud[k].TcYear]:=true;
     if MyStud.Sex>'' then XML_STUDENTS.Stud[k].Sex:=MyStud.Sex;
     if MyStud.tcClass>0 then XML_STUDENTS.Stud[k].TcClass:=MyStud.tcClass;
     if MyStud.House>0 then XML_STUDENTS.Stud[k].House:=MyStud.House;
     if MyStud.ID>'' then XML_STUDENTS.Stud[k].ID:=MyStud.ID;
     if MyStud.tutor>0 then XML_STUDENTS.Stud[k].Tutor:=MyStud.tutor;
     if MyStud.home>0 then XML_STUDENTS.Stud[k].Home:=MyStud.home;
     if MyStud.TcYear>=0 then XML_STUDENTS.Stud[k].TcYear:=MyStud.TcYear;
     StudYearFlag[XML_STUDENTS.Stud[k].TcYear]:=true;
     SaveStudFlag:=true; needUpdate:=true;
     for i:=1 to nmbrChoices do
      begin
         m:=0;
         if MyStud.Choices[i]>0 then
         begin
          for n:=1 to nmbrChoices do
           if XML_STUDENTS.Stud[k].Choices[n]=MyStud.Choices[i] then
           begin
            m:=n;  break;
           end;
          if m=0 then {not found}
          begin
           for n:=1 to nmbrChoices do
            if XML_STUDENTS.Stud[k].Choices[n]=0 then
            begin
             m:=n;  break;
            end;
           if m>0 then
              begin
               XML_STUDENTS.Stud[k].Choices[m]:=MyStud.Choices[i];
               if m>chmax then chmax:=m;
              end
           else
            begin
             msg:='Cannot add <'+SubCode[MyStud.Choices[i]]+' '+subname[MyStud.Choices[i]]+'> to'+endline;
             msg:=msg+XML_STUDENTS.Stud[k].stname+' '+XML_STUDENTS.Stud[k].first+','+endline;
             msg:=msg+', as the maximum number of student choices ('
                  +inttostr(nmbrChoices)+') has been reached.';
             result:=true;
            end;
          end;  {if m=0}
         end; {if MyStud.Choices[i]>0}
      end; {for i}
      needUpdate:=true;
   end;  {CommonDataAdd function}

begin

 if not(ValidEdStud) then exit;
 label3.caption:='';
 case finish.tag of
  1: begin
      if oopsNameFlag then
       begin
        msg:='Are you sure you want to change'+endline;
        msg:=msg+XML_STUDENTS.Stud[StN].First+' '+XML_STUDENTS.Stud[StN].Stname+' to'+endline;
        msg:=msg+MyStud.first+' '+MyStud.stname+'?'+endline;
        if messagedlg(msg,mtWarning,[mbYes,mbNo],0)<>mrYes then
        begin
          if edtSurname.Visible and edtSurname.Enabled then
          begin
            edtSurname.SetFocus;
            edtSurname.SelectAll;
          end;
         Exit;
        end;
       end;
      if MyStud.TcYear>=0 then StudYearFlag[MyStud.TcYear]:=true;
      StudYearFlag[XML_STUDENTS.Stud[StN].TcYear]:=true;

      needUpdate:=true;
      XML_STUDENTS.Stud[StN]:=MyStud;

      studID2[StN]:=MyStudID2;
      studEmail[StN]:=MyEmail;

      for i:=1 to nmbrChoices do
        if MyStud.Choices[i]>0 then if i>chmax then chmax:=i;
      i2:=0;
      for i:=1 to nmbrTags do
        if tagbox[i].checked then i2:=(i2 or (1 shl (i-1)));
      XML_STUDENTS.Stud[StN].tctag:=i2;
      SaveStudFlag:=true;
      resetstudentorder(StN);
     end;

  2: begin
      if checkbox1.checked then {all students}
      begin
       CUPAcnt:=0;
       for j:=1 to groupnum do
       begin
        k:=StGroup[j];

/// implement year access rights check here and set flag for error message if any skipped

        if not(CheckUserYearPassAccess(XML_STUDENTS.Stud[k].TcYear)) then
        begin
         inc(CUPAcnt);
         continue;
        end;

        if checkbox2.checked then i2:=65535 else i2:=0;  {do tags first}
        for i:=1 to nmbrtags do
        begin
         if checkbox2.checked then
         begin
          if tagbox[i].checked then i2:=(i2 xor (1 shl (i-1)));
         end
         else
          begin
           if tagbox[i].checked then i2:=(i2 or (1 shl (i-1)));
          end;
        end; {for i}
        if checkbox2.checked then
         XML_STUDENTS.Stud[k].tctag:=(XML_STUDENTS.Stud[k].tctag and i2)
        else
         XML_STUDENTS.Stud[k].tctag:=(XML_STUDENTS.Stud[k].tctag or i2);
        if CommonDataAdd(k) then   {true if error}
         begin
          messagedlg(msg,mtWarning,[mbOK],0);
          exit;
         end;
        resetstudentorder(j);
       end; {for j}
       if (CUPAcnt>0) then
       begin
        msg:=inttostr(CUPAcnt)+' students were skipped'+endline;
        msg:=msg+'as you do NOT currently have access to change'+endline;
        msg:=msg+'the student data for the relevant '+yeartitle+'(s)';
        messagedlg(msg,mtWarning,[mbOK],0);
       end;
      end
      else        {update single student only}
       begin
        i2:=0;
        for i:=1 to nmbrTags do
        begin
          if tagbox[i].checked then i2:=(i2 or (1 shl (i-1)));
        end;
        XML_STUDENTS.Stud[StN].tctag:=i2;

        if CommonDataAdd(StN) then   {true if error}
         begin
          messagedlg(msg,mtWarning,[mbOK],0);
          exit;
         end;
        resetstudentorder(StN);
       end;  {update single student}
     end;  {common data update}
 end; {case}
 UpdateStudCalcs;
 nextClick(self);   {go to next}
 needUpdate:=true;
 if checkbox4.checked then   {id scan}
 begin
   if Edit6.Visible and Edit6.Enabled then
   begin
     Edit6.SetFocus;
     Edit6.SelectAll;
   end;
   Exit;
 end;

 if finish.tag=2 then
 begin
   restoreComDatFocus {common data}
 end
 else
 begin
   if Edit9[1].Visible and Edit9[1].Enabled then
     Edit9[1].SetFocus;
 end;

end;

procedure Tedstuddlg.btnFindClick(Sender: TObject);
var
 msg:     string;
 j,i:  integer;
 aStr: string;
begin
 label3.caption:='';
 aStr:=trim(edtSurname.text);
 findStudentPrc;
 if ((XML_DISPLAY.sTfind=1) and (not(bool(sTfound))) and (trim(XML_STUDENTS.Stud[StN].StName)<>aStr)) then
  oopsNameFlag:=true;
 if bool(sTfound) then
  begin
   StN:=sTfound; ShowStud;
  end
 else
 begin
  msg:='No more matching students found in group '+groupname+'.'+endline;
  messagedlg(msg,mtError,[mbOK],0);
 end;
 j:=0;
 for i:=1 to groupnum do
  if StN=StGroup[i] then
  begin
   j:=i;
   break;
  end;
 NextBtnStatus(j);
 updateShowClashes;
 restoreComDatFocus;
end;

procedure Tedstuddlg.btnAllocateClick(Sender: TObject);
begin
 allocateStudChoices(edit9,label3);
 updateShowClashes;
end;

procedure Tedstuddlg.CheckBox1Click(Sender: TObject);
begin
 case finish.tag of
  1: XML_DISPLAY.editBlockCheck:=checkbox1.checked;
  2: XML_DISPLAY.commonDataAll:=checkbox1.checked;
 end;
 CheckYearAccess;
end;

procedure Tedstuddlg.edtSurnameChange(Sender: TObject);
begin
 oopsNameFlag:=false;
 updateFindEnabledStatus;
 speedbutton1.enabled:=(StN>0);
end;

procedure Tedstuddlg.Edit2Change(Sender: TObject);
begin
 updateFindEnabledStatus;
end;

procedure Tedstuddlg.Edit6Change(Sender: TObject);
var
 s:     string;
 IDlen: smallint;
begin
 updateFindEnabledStatus;
 {handle step-on for barcode use}
 if checkbox4.checked then
 begin
  s:=edit6.text;
  idlen:=calcIDlen;
  if length(s)=idlen then btnFindClick(self);
 end;
end;

procedure Tedstuddlg.edtSurnameEnter(Sender: TObject);
begin
 comDatFocus:=1;
end;

procedure Tedstuddlg.Edit2Enter(Sender: TObject);
begin
 comDatFocus:=2;
end;

procedure Tedstuddlg.Edit6Enter(Sender: TObject);
begin
 comDatFocus:=6;
end;

procedure Tedstuddlg.SpeedButton1Click(Sender: TObject);
var
 msg: string;
 tmpint: smallint;
 tmpStud:      tpStudRec;
begin
 tmpint:=StN;
 try
  if tmpint>0 then
   begin
    studfindnum:=tmpint;
    tmpStud:=XML_STUDENTS.Stud[tmpint];  {back up stud first}
    if sepUpdateCheck>0 then
     begin
    if not(wnFlag[wnFindStud]) then
     findstudentwinselect;
      UpdateWindow(wnFindStud);
      printOurWindow(wnFindStud);
     end;
   end
  else
   begin  {none selected}
    msg:='No Student selected';
    messagedlg(msg,mtError,[mbOK],0);
   end;

 finally  //restore student
  XML_STUDENTS.Stud[tmpint]:=tmpStud;
 end;
end;

procedure Tedstuddlg.ComboBox1Enter(Sender: TObject);
begin
 comDatFocus:=10;
 label3.visible:=true;
 combobox1change(self);
 combobox1.selectall;
end;

procedure Tedstuddlg.ComboBox1Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Tedstuddlg.ComboBox1Change(Sender: TObject);
begin
 ToYear:=findyearname(combobox1.text,label3);
 CheckYearAccess;
 updateFindEnabledStatus;
end;

procedure Tedstuddlg.ComboBox5KeyPress(Sender: TObject; var Key: Char);
var
 tmpstr: string;
begin
 tmpstr:=uppercase(key);
 key:=tmpstr[1];
 if ((key<>genderShort[0]{'M'}) and (key<>genderShort[1]{'F'})) then if ord(key)>32 then key:=chr(0);
end;

procedure Tedstuddlg.ComboBox5Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Tedstuddlg.ComboBox5Enter(Sender: TObject);
begin
 comDatFocus:=3;
 label3.visible:=true;
 combobox5Change(self);
 combobox5.selectall;
end;

procedure Tedstuddlg.ComboBox5Change(Sender: TObject);
var
 a:       string[1];
begin
 a:=Uppercase(trim(combobox5.text));
 if a=genderShort[0]{'M'} then label3.caption:=genderLong[0]  {'Male'}
  else if a=genderShort[1]{'F'} then label3.caption:=genderLong[1]  {'Female'}
  else if a=genderShort[2]{'X'} then label3.caption:=genderLong[2]  {'Unspecified'}     //---- mantis-1566

   else label3.caption:='Enter Sex';
 updateFindEnabledStatus;
end;

procedure Tedstuddlg.ComboBox2Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Tedstuddlg.ComboBox2Enter(Sender: TObject);
begin
 comDatFocus:=5;
 label3.visible:=true;
 ComboBox2change(self);
 ComboBox2.selectall;
end;

procedure Tedstuddlg.ComboBox2Change(Sender: TObject);
begin
 findhouse(ComboBox2.text,label3);
 updateFindEnabledStatus;
end;

procedure Tedstuddlg.ComboBox3KeyPress(Sender: TObject; var Key: Char);
var
 tmpstr: string;
begin
 tmpstr:=uppercase(key);
 key:=tmpstr[1];
end;

procedure Tedstuddlg.ComboBox3Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Tedstuddlg.ComboBox3Enter(Sender: TObject);
begin
 comDatFocus:=7;
 label3.visible:=true;
 ComboBox3change(self);
 ComboBox3.selectall;
end;

procedure Tedstuddlg.ComboBox3Change(Sender: TObject);
begin
 findTe(ComboBox3.text,label3);
 updateFindEnabledStatus;
end;

procedure Tedstuddlg.ComboBox4KeyPress(Sender: TObject; var Key: Char);
var
 tmpstr: string;
begin
 tmpstr:=uppercase(key);
 key:=tmpstr[1];
end;

procedure Tedstuddlg.ComboBox4Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Tedstuddlg.ComboBox4Enter(Sender: TObject);
begin
 comDatFocus:=8;
 label3.visible:=true;
 ComboBox4change(self);
 ComboBox4.selectall;
end;

procedure Tedstuddlg.ComboBox4Change(Sender: TObject);
begin
 findroom(ComboBox4.text,label3);
 updateFindEnabledStatus;
end;

procedure Tedstuddlg.ComboBox6Change(Sender: TObject);
begin
 findclass(combobox6.text,label3);
 updateFindEnabledStatus;
end;

procedure Tedstuddlg.ComboBox6Enter(Sender: TObject);
begin
 comDatFocus:=4;
 label3.visible:=true;
 ComboBox6change(self);
 ComboBox6.selectall;
end;

procedure Tedstuddlg.ComboBox6Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Tedstuddlg.CheckBox4Click(Sender: TObject);
begin
 if checkbox4.checked then IDfindBtn.checked:=true;
 updateSearchHighlight;
end;

procedure Tedstuddlg.NameFindBtnClick(Sender: TObject);
begin
 XML_DISPLAY.sTfind:=1;
 updateSearchHighlight;
end;

procedure Tedstuddlg.FirstFindBtnClick(Sender: TObject);
begin
 XML_DISPLAY.sTfind:=2;
 updateSearchHighlight;
end;

procedure Tedstuddlg.SexFindBtnClick(Sender: TObject);
begin
 XML_DISPLAY.sTfind:=3;
 updateSearchHighlight;
end;

procedure Tedstuddlg.IDfindBtnClick(Sender: TObject);
begin
 XML_DISPLAY.sTfind:=4;
 updateSearchHighlight;
end;

procedure Tedstuddlg.ClassFindBtnClick(Sender: TObject);
begin
 XML_DISPLAY.sTfind:=5;
 updateSearchHighlight;
end;

procedure Tedstuddlg.HouseFindBtnClick(Sender: TObject);
begin
 XML_DISPLAY.sTfind:=6;
 updateSearchHighlight;
end;

procedure Tedstuddlg.TutorFindBtnClick(Sender: TObject);
begin
 XML_DISPLAY.sTfind:=7;
 updateSearchHighlight;
end;

procedure Tedstuddlg.HomeFindBtnClick(Sender: TObject);
begin
 XML_DISPLAY.sTfind:=8;
 updateSearchHighlight;
end;

procedure Tedstuddlg.YrFindBtnClick(Sender: TObject);
begin
 XML_DISPLAY.sTfind:=9;
 updateSearchHighlight;
end;


initialization
oopsNameFlag:=false;

end.

