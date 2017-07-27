unit Addstud;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, GlobalToTcAndTcextra, XML.DISPLAY,
  XML.TEACHERS, XML.STUDENTS;

type
  Taddstuddlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Label6: TLabel;
    Edit2: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit6: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    allocate: TBitBtn;
    Label14: TLabel;
    Label15: TLabel;
    Edit10: TEdit;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    Label17: TLabel;
    SpeedButton1: TSpeedButton;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    cboSex: TComboBox;
    ComboBox6: TComboBox;
    ComboBox1: TComboBox;
    Label4: TLabel;
    CheckBox3: TCheckBox;
    Label2: TLabel;
    Edit3: TEdit;
    ScrollBox1: TScrollBox;
    Label16: TLabel;
    txtEmail: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure updateClick(Sender: TObject);
    procedure allocateClick(Sender: TObject);

    procedure MyEdit9Change(Sender: TObject);   {assigned to onchange for dynamically created edit boxes}
    procedure MyEdit9Enter(Sender: TObject);   { "   " }
    procedure MyEdit9Exit(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure cboSexEnter(Sender: TObject);
    procedure cboSexExit(Sender: TObject);
    procedure cboSexKeyPress(Sender: TObject; var Key: Char);
    procedure cboSexChange(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure ComboBox6Enter(Sender: TObject);
    procedure ComboBox6Exit(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
    procedure ComboBox2Exit(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
    procedure ComboBox3Exit(Sender: TObject);
    procedure ComboBox3KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox4Enter(Sender: TObject);
    procedure ComboBox4Exit(Sender: TObject);
    procedure ComboBox4KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    function ValidAddStud: boolean;
    function sepAddStudCheck: integer;
  end;

var
  addstuddlg: Taddstuddlg;



implementation
uses tcommon,DlgCommon, main, block1,tcommon2,stcommon,tcommon5, customOutput;

{$R *.DFM}

var
 edit9:   tpEdit9;
 needUpdate:                    bool;
 usingResources:                bool;
 tagbox:                        array[1..nmbrTags] of Tcheckbox;
 MyStud:  tpStudRec;
 StN: integer;
// MyStudID2: string[szID];
 MyStudID2: string[50];
 MyEmail: string[100];

function Taddstuddlg.ValidAddStud: boolean;
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
  MyEmail  :='';
 end;

 label3.caption:=''; label3.visible:=false;  k:=0;
 if TooMany('students',StN+1,nmbrStudents) then exit;
 

 for i:=1 to nmbrChoices do
  begin
   tmpStr:=trim(edit9[i].text);
   if tmpStr>'' then
    begin
     if ChoiceNotFound(fsubnm,i,tmpStr,edit9[i]) then exit;
     if NAused(fsubnm,i,edit9[i]) then exit;
     if (GsubXref[fsubnm]>0) then
        if XML_DISPLAY.editBlockCheck and checkbox1.enabled then   {block check}
       if NotInBlock(fsubnm,i,edit9[i]) then exit;
     MyStud.Choices[i]:=fsubnm;
          end;
  end; {for i}

 MyStud.stname:=trim(edit1.text);
 MyStud.first:=trim(edit2.text);
 MyStud.ID:=trim(edit6.text);
                   
 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  MyStudID2:=trim(edit3.text);
  MyEmail  :=trim(txtEmail.Text);
 end;
                                    
 if MyStud.stname='' then
  begin
   ShowMsg('Please enter a name for this student.',edit1);
   exit;
  end;

 MyStud.Sex:=uppercase(trim(cboSex.text));
 if not MyStud.ValidSexHasBeenSelected then
 begin
   ComboMsg(getGenderPrompt,cboSex);
   exit; {return to editing}
  end;

 tmpStr:=trim(combobox1.text);
 if tmpStr='' then
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

  // do duplicate prevention check;
 if DupStudent(StN,MyStud,edit2) then exit;
 result:=true;
end;


function Taddstuddlg.sepAddStudCheck: integer;
var
 i,i2:    integer;
begin
 result:=0;
 if not(ValidAddStud) then exit;
 label3.caption:=''; label3.visible:=false;
 XML_STUDENTS.numstud:=StN;
 setlength(XML_STUDENTS.Stud,(StN+1)); {zero based so +1}
 XML_STUDENTS.Stud[StN]:=MyStud;
 i2:=0;
 for i:=1 to nmbrTags do
   if tagbox[i].checked then i2:=(i2 or (1 shl (i-1)));
 XML_STUDENTS.Stud[StN].tctag:=i2;
 CountChmax;
 getStudentFontWidths;
 result:=StN;
end;


procedure updateShowClashes;
var
 i,k:       integer;
begin
 if not(XML_DISPLAY.listShowClashes) then exit;
 for i:=1 to nmbrChoices do
  XML_STUDENTS.Stud[0].choices[i]:=findChoice(edit9[i].text,addstuddlg.label3,false);
 for i:=1 to nmbrChoices do
 begin
  k:=XML_STUDENTS.Stud[0].choices[i];
  if CheckStudChoiceForClash(0,k) then edit9[i].color:=clRed
   else edit9[i].color:=clWindow;
 end;
end;

procedure restore;
var
 i: integer;
begin
 with addstuddlg do
  begin
   edit1.text:=''; edit2.text:='';
   cboSex.text:=''; combobox6.text:='';
   combobox2.text:=''; edit6.text:=''; combobox3.text:=''; combobox4.text:='';
   combobox1.text:='';
   for i:=1 to nmbrChoices do edit9[i].text:='';
   for i:=1 to nmbrTags do tagbox[i].checked:=false;
   label15.caption:=inttostr(XML_STUDENTS.numstud);
   StN:=XML_STUDENTS.numstud+1;  edit10.text:=inttostr(StN);
   updateShowClashes;
   edit1.setfocus;
  end;
end;

procedure Taddstuddlg.MyEdit9Change(Sender: TObject);
var
 i:           integer;
 cntrli,k:    integer;
 s:           string;
begin
 CountGroupSubs;
 cntrli:=activecontrol.tag;
 if ((cntrli<1) or (cntrli>nmbrChoices)) then exit;  {during load causes problems otherwise}
 i:=findChoice(edit9[cntrli].text,label3,true);
 if i>0 then
  if i=subNA then label3.caption:='Enter Choice code'
   else
  for k:=1 to nmbrChoices do  {on edits not saved choices}
   begin
    if ((k<>cntrli) and (findchoice(edit9[k].text,label3,false)=i)) then
     begin
      label3.caption:='DUPLICATE student subject choice';
      break;
     end;
   end;

 if XML_DISPLAY.editBlockCheck and checkbox1.enabled then   {block check}
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
    edit9[cntrli+1].setfocus;
 end;

end;

procedure Taddstuddlg.MyEdit9Enter(Sender: TObject);
var
 i,cntrli,k:  integer;
begin
 i:=activecontrol.tag;
 label3.visible:=true;
 edit9[i].selectall;

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
    for k:=1 to nmbrChoices do   {on edits not saved choices}
     if ((k<>cntrli) and (findchoice(edit9[k].text,label3,false)=i)) then
      begin
       label3.caption:='DUPLICATE student subject choice';
       break;
      end;
   end;
 end;
  if XML_DISPLAY.editBlockCheck then   {block check}
   if checkbox1.enabled then
    if cntrli<=XML_DISPLAY.blocknum then
     if (i<>0) and not(subISAlreadyinBlock(i,cntrli)) then
      label3.caption:='Not in Block!';

 updateShowClashes;
end;

procedure Taddstuddlg.MyEdit9Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Taddstuddlg.FormCreate(Sender: TObject);
var
 i:       integer;
 idxSex: integer;
 ssx,ssy: integer;
const
 xgap=5;
 ygap=5;
begin
// ssx:=(groupbox1.clientwidth-label5.left-(6*xgap)) div 5;
 ssx:=(scrollbox1.clientwidth-label5.left-(6*xgap)) div 5;
 ssy:=edit6.height;

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  label2.Visible:=true;
  edit3.Visible:=true;
 end;

 for i:=1 to nmbrChoices do
 begin
  edit9[i]:=tedit.create(application);
  edit9[i].tag:=i;
  edit9[i].taborder:=7+i;
  edit9[i].maxlength:=lencodes[0];
  edit9[i].width:=ssx;  edit9[i].height:=ssy;
  edit9[i].parent:=scrollbox1; //groupbox1;
//  edit9[i].left:=label13.left+(((i-1) mod 5)*(ssx+xgap));
//  edit9[i].top:=label13.top+label13.height+ygap+(((i-1) div 5)*(ssy+ygap));
  edit9[i].left:=label13.left-8+(((i-1) mod 5)*(ssx+xgap));
  edit9[i].top:=(((i-1) div 5)*(ssy+ygap));
  {attach dynamic method links}
  edit9[i].onChange:=MyEdit9Change;
  edit9[i].onEnter:=MyEdit9Enter;
  edit9[i].onExit:=MyEdit9Exit;

 end; {for i}
 for i:=1 to nmbrtags do
 begin
  tagbox[i]:=tcheckbox.create(application);
  tagbox[i].parent:=groupbox1;
  tagbox[i].Alignment:=taLeftJustify;
  tagbox[i].caption:=TagCode[i];
  tagbox[i].width:=30;
  tagbox[i].top:=(((i-1)div 8)*(tagbox[i].Height+(ygap div 2)))+label17.top-2;
  if i<9 then
    tagbox[i].left:=label17.width+label17.left+((i)*(tagbox[i].width+xgap*3))-xgap*2
   else tagbox[i].left:=tagbox[i-8].left;
  tagbox[i].ShowHint:=true; 
  tagbox[i].Hint:=TagName[i];
 end;
 {init combobos}
 combobox1.clear; for i:=years_minus_1 downto 0 do combobox1.items.add(yearname[i]);
 combobox2.clear; for i:=1 to housecount do combobox2.items.add(housename[i]);
 combobox3.clear; for i:=1 to codeCount[1] do combobox3.items.add(XML_TEACHERS.Tecode[codepoint[i,1],0]);
 combobox4.clear; for i:=1 to codeCount[2] do combobox4.items.add(XML_TEACHERS.Tecode[codepoint[i,2],1]);
 cboSex.clear;
 for idxSex :=low(genderShort)to High(genderShort)do
    cboSex.items.add(genderShort[idxSex]);

 combobox6.clear; for i:=1 to RollClassPoint[0] do combobox6.items.add(ClassCode[RollClassPoint[i]]);
 speedbutton1.enabled:=(trim(edit1.text)>'');
 usingResources:=true;
 if needClashMatrixRecalc then CalculateClashmatrix;
end;

procedure Taddstuddlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
 i:       integer;
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
  if SaveStudFlag=false then CheckAccessRights(utStud,35,false);
  screen.cursor:=crDefault;
 end; {try}
 if usingResources then
 begin
  usingResources:=false; {sometimes called more than once, prevent attempted release if already released}
  addstuddlg.hide; {prevent seeing controls beeing removed -slows things down a lot}
  for i:=1 to nmbrChoices do edit9[i].free;
  for i:=1 to nmbrtags do tagbox[i].free;
 end;
end;

procedure Taddstuddlg.FormActivate(Sender: TObject);
begin
 edit1.maxlength:=szStName;  edit2.maxlength:=szStFirst;
 cboSex.maxlength:=1;   combobox6.maxlength:=szClassName;
 combobox2.maxlength:=szHousename;  edit6.maxlength:=szID;
 combobox3.maxlength:=lencodes[1];  combobox4.maxlength:=lencodes[2];
 needupdate:=false;
 caption:='Add Student ';
 allocate.enabled:=(bool(blockLoad) and (XML_DISPLAY.blocknum>0));
 checkbox1.enabled:=allocate.enabled;
 checkbox1.checked:=XML_DISPLAY.editBlockCheck;
 restore;
end;

procedure Taddstuddlg.updateClick(Sender: TObject);
var
 i,i2:       integer;
 myInt:    integer;
 msg: string;
begin
 if not(ValidAddStud) then exit;
 label3.caption:=''; label3.visible:=false;
 myInt:=findYearname(combobox1.text,label3);
 if not(CheckUserYearPassAccess(myInt)) then
  begin
   if CheckUserYearPassRights(myInt) then
    msg:=yeartitle+' '+yearname[myInt]+' student data is already in use by another user'
   else
    msg:='You do NOT have access to add '+yeartitle+' '+yearname[myInt]+' students';
   messagedlg(msg,mtError,[mbOK],0);
   combobox1.setfocus;
   exit; {return to editing}
  end;

 {assign to vars & update }
 XML_STUDENTS.NumStud:=StN;
 SetStArrays;
 StudSort[StN]:=StN;

 XML_STUDENTS.Stud[StN]:=MyStud;

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  studID2[StN]:=MyStudID2;
  studEmail[StN]:=MyEmail;
 end;

 for i:=1 to nmbrChoices do
        if MyStud.Choices[i]>0 then if i>chmax then chmax:=i;
 i2:=0;
 for i:=1 to nmbrTags do
   if tagbox[i].checked then i2:=(i2 or (1 shl (i-1)));
 XML_STUDENTS.Stud[StN].tctag:=i2;

 SaveStudFlag:=true;
 StudYearFlag[XML_STUDENTS.Stud[StN].tcYear]:=true;

 resetstudentorder(StN);
 restore;
 UpdateStudCalcs;
 needUpdate:=true;
end;

procedure Taddstuddlg.allocateClick(Sender: TObject);
begin
 BlockwinSelect;  //force block win open if it's been closed to avoid access error
 allocateStudChoices(edit9,label3);
 updateShowClashes;
end;

procedure Taddstuddlg.CheckBox1Click(Sender: TObject);
begin
 XML_DISPLAY.editBlockCheck:=checkbox1.checked;
end;

procedure Taddstuddlg.SpeedButton1Click(Sender: TObject);
var
 msg: string;
 snm: smallint;
begin
 snm:=0;
 try
  snm:=sepAddStudCheck;
  if snm>0 then
   begin
    studfindnum:=snm;
    if not(wnFlag[wnFindStud]) then findstudentwinselect;
    UpdateWindow(wnFindStud);
    printOurWindow(wnFindStud);
   end
  else
   begin  {none selected}
    msg:='No Student added';
    messagedlg(msg,mtError,[mbOK],0);
   end;

//remove temp stud again
 finally
    if snm>0 then removeStudent(snm);
 end;
end;

procedure Taddstuddlg.cboSexEnter(Sender: TObject);
begin
 label3.visible:=true;
 cboSexChange(self);
 cboSex.selectall;
end;

procedure Taddstuddlg.cboSexExit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Taddstuddlg.cboSexKeyPress(Sender: TObject; var Key: Char);
var
 tmpstr: string;
begin
 tmpstr:=uppercase(key);
 key:=tmpstr[1];
 if not keyIsInGenderShort(Key) then if ord(key)>32 then key:=chr(0);
end;

procedure Taddstuddlg.cboSexChange(Sender: TObject);
var
 a:       string[1];
begin
 a:=Uppercase(trim(cboSex.text));
 label3.caption  :=  genderGetLongNameFromShort(a);
 if label3.caption = '' then
     label3.caption:='Enter Sex';
end;

procedure Taddstuddlg.ComboBox6Change(Sender: TObject);
begin
 findclass(combobox6.text,label3);
end;

procedure Taddstuddlg.ComboBox6Enter(Sender: TObject);
begin
 label3.visible:=true;
 combobox6Change(self);
 combobox6.selectall;
end;

procedure Taddstuddlg.ComboBox6Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Taddstuddlg.ComboBox2Change(Sender: TObject);
begin
 findhouse(combobox2.text,label3);
end;

procedure Taddstuddlg.ComboBox2Enter(Sender: TObject);
begin
 label3.visible:=true;
 combobox2Change(self);
 combobox2.selectall;
end;

procedure Taddstuddlg.ComboBox2Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Taddstuddlg.ComboBox3Change(Sender: TObject);
begin
 findTe(combobox3.text,label3);
end;

procedure Taddstuddlg.ComboBox3Enter(Sender: TObject);
begin
 label3.visible:=true;
 combobox3Change(self);
 combobox3.selectall;
end;

procedure Taddstuddlg.ComboBox3Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Taddstuddlg.ComboBox3KeyPress(Sender: TObject; var Key: Char);
var
 tmpstr: string;
begin
 tmpstr:=uppercase(key);
 key:=tmpstr[1]; 
end;

procedure Taddstuddlg.ComboBox4Change(Sender: TObject);
begin
 findroom(combobox4.text,label3);
end;

procedure Taddstuddlg.ComboBox4Enter(Sender: TObject);
begin
 label3.visible:=true;
 combobox4Change(self);
 combobox4.selectall;
end;

procedure Taddstuddlg.ComboBox4Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Taddstuddlg.ComboBox4KeyPress(Sender: TObject; var Key: Char);
var
 tmpstr: string;
begin
 tmpstr:=uppercase(key);
 key:=tmpstr[1];
end;

procedure Taddstuddlg.ComboBox1Change(Sender: TObject);
var
 s:  string;
 i: smallint;
begin
 findyearname(combobox1.text,label3);
 s:=combobox6.text;
 combobox6.clear;
 if classnum>0 then
  for i:=1 to RollClassPoint[0] do
   combobox6.items.add(ClassCode[RollClassPoint[i]]);
 combobox6.text:=s;
end;

procedure Taddstuddlg.ComboBox1Enter(Sender: TObject);
begin
 label3.visible:=true;
 combobox1change(self);
 combobox1.selectall;
end;

procedure Taddstuddlg.ComboBox1Exit(Sender: TObject);
begin
 label3.visible:=false;
end;

procedure Taddstuddlg.Edit1Change(Sender: TObject);
begin
 speedbutton1.enabled:=(trim(edit1.text)>'');
end;

end.
