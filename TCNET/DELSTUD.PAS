unit Delstud;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, XML.DISPLAY, XML.TEACHERS,
  XML.STUDENTS;

type
  Tdelstuddlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit1: TEdit;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    Label14: TLabel;
    Label15: TLabel;
    previous: TBitBtn;
    next: TBitBtn;
    find: TBitBtn;
    Label2: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Edit10: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Label10: TLabel;
    Label16: TLabel;
    Label42: TLabel;
    Label24: TLabel;
    Label23: TLabel;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure Edit10Change(Sender: TObject);
    procedure nextClick(Sender: TObject);
    procedure previousClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure updateClick(Sender: TObject);
    procedure findClick(Sender: TObject);
  end;

var
  delstuddlg: Tdelstuddlg;

implementation
uses tcommon,studlist,main,tcommon2,stcommon,tcommon5,DlgCommon, customOutput;

{$R *.DFM}
var
 label22:   array[1..nmbrChoices] of tlabel;
 needUpdate:                    bool;
 usingResources:                bool;
 stfound:                       integer;



procedure findStudent;
var
 i:      integer;
 tmpStr1,tmpStr2:        string;
begin
 sTfound:=0;
 tmpStr1:=Uppercase(trim(delstuddlg.edit1.text));
 tmpStr2:=Uppercase(trim(delstuddlg.edit2.text));
 i:=findStudBIN(tmpstr1+' '+tmpstr2);
 if (i>0) then sTfound:=i; {found him}
end;


procedure Tdelstuddlg.FormCreate(Sender: TObject);
var
 i:       integer;
 w,h:       integer;
const
 xgap=5;
 ygap=5;
begin
 w:=self.canvas.textwidth('WWWWWWWW ');
 h:=self.canvas.textheight('Wj');

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  label24.Visible:=true;
  label23.Visible:=true;
 end;


 for i:=1 to nmbrChoices do
 begin
  label22[i]:=tlabel.create(application);
  label22[i].width:=w;    label22[i].height:=13;
  label22[i].parent:=scrollbox1; //groupbox1;
  label22[i].caption:=inttostr(i);
//  label22[i].left:=label13.left+(((i-1) mod 5)*(w+xgap));
//  label22[i].top:=label13.top+label13.height+ygap+(((i-1) div 5)*(h+ygap));
  label22[i].left:=label13.left-8+(((i-1) mod 5)*(w+xgap));
  label22[i].top:=(((i-1) div 5)*(h+ygap));
 end; {for i}
 usingResources:=true;
end;

procedure Tdelstuddlg.Edit10Change(Sender: TObject);
var
 nm,i:      integer;
begin
 nm:=IntFromEdit(edit10);
 if CheckUserYearPassAccess(XML_STUDENTS.Stud[nm].tcYear) then
 begin
  update.enabled:=true;
  label42.visible:=false;
 end
 else
 begin

//----------------
  if CheckUserYearPassRights(XML_STUDENTS.Stud[nm].tcYear) then  //has got rights to change year
  begin  //attempt to dynamically add lock to year
  if nm>0 then
   if not(CheckPriorYearAccess4(XML_STUDENTS.Stud[nm].tcYear,true)) then
   begin  //could NOT dynamically get lock for year
    update.enabled:=false; //allocate.enabled:=false;
    if nm>0 then  //do NOT show on init if no stud selected
     label42.visible:=true;
    // no need to clear dynamicaly added year locks, normal routine will clear all active year locks on release
   end
    else
     begin
      update.enabled:=true; //allocate.enabled:=true;
      label42.visible:=false;
     end;
  end
  else
   begin
    update.enabled:=false; //allocate.enabled:=false;
    if nm>0 then  //do NOT show on init if no stud selected
     label42.visible:=true;
   end;
//----------------
  end;


 if ((nm>0) and (nm<=XML_STUDENTS.numstud)) then
 begin
  edit1.text:=trim(XML_STUDENTS.Stud[nm].StName);
  edit2.text:=trim(XML_STUDENTS.Stud[nm].First);
  label2.caption:=trim(XML_STUDENTS.Stud[nm].Sex);
  label18.caption:=trim(ClassCode[XML_STUDENTS.Stud[nm].TcClass]);
  label20.caption:=trim(Housename[XML_STUDENTS.Stud[nm].House]);
  label17.caption:=trim(XML_STUDENTS.Stud[nm].ID);

  //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
  begin
   label23.caption:=trim(studID2[nm]);
  end;

  label21.caption:=trim(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[nm].Tutor,0]);
  label19.caption:=trim(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[nm].Home,1]);
  label16.caption:=trim(yearname[XML_STUDENTS.Stud[nm].TcYear]);
  for i:=1 to nmbrChoices do
   if ((XML_STUDENTS.Stud[nm].Choices[i]>0) and (XML_STUDENTS.Stud[nm].Choices[i]<=numCodes[0])) then
    label22[i].caption:=trim(SubCode[XML_STUDENTS.Stud[nm].Choices[i]])
   else
    label22[i].caption:='';
 end
 else
  begin
   edit1.text:='';
   edit2.text:='';
   label2.caption:='';
   label17.caption:='';
   label18.caption:='';
   label19.caption:='';
   label16.caption:='';
   label20.caption:='';
   label21.caption:='';
   for i:=1 to nmbrChoices do
    label22[i].caption:='';
   label3.caption:='Student not found !';
  end;
end;

procedure Tdelstuddlg.nextClick(Sender: TObject);
var
 nm:      integer;
 i,j:     integer;
 msg:     string;
begin
 label3.caption:='';
 nm:=IntFromEdit(edit10);

 j:=0;
 for i:=1 to groupnum do
  if nm=StGroup[i] then
  begin
   j:=i;
   break;
  end;
 if j=0 then
 begin
  j:=1;
  while ((StGroup[j]<nm) and (j<groupnum)) do inc(j);
 end
 else
  begin
   inc(j);
   if j>groupnum then
   begin
    j:=groupnum;
    msg:='At end of student list in group '+groupname+'.'+endline;
    messagedlg(msg,mtError,[mbOK],0);
   end;
  end;
 edit10.text:=inttostr(StGroup[j]);
 if j>1 then previous.enabled:=true else previous.enabled:=false;
 if j<groupnum then next.enabled:=true else next.enabled:=false;
 if (nm=0) then
  previous.enabled:=false;
end;

procedure Tdelstuddlg.previousClick(Sender: TObject);
var
 nm:      integer;
 i,j:     integer;
 msg:     string;
begin
 label3.caption:='';
 nm:=IntFromEdit(edit10);

 j:=0;
 for i:=1 to groupnum do
  if nm=StGroup[i] then
  begin
   j:=i;
   break;
  end;
 if j=0 then
 begin
  j:=groupnum;
  while ((StGroup[j]>nm) and (j>1)) do dec(j);
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
 edit10.text:=inttostr(StGroup[j]);

 if j>1 then previous.enabled:=true else previous.enabled:=false;
 if j<groupnum then next.enabled:=true else next.enabled:=false;
 if (nm=0) then
  previous.enabled:=false;
end;

procedure Tdelstuddlg.FormActivate(Sender: TObject);
var
 i:      integer;
begin
 edit10.maxlength:=4; {9999}
 edit1.maxlength:=szStName;  edit2.maxlength:=szStFirst;
 needupdate:=false;
 label15.caption:=inttostr(XML_STUDENTS.numstud);
 edit10.text:='';
 if wnFlag[wnStudentList] then
 if ((MySelStud>0) and (MySelStud<=XML_STUDENTS.numstud)) then
  edit10.text:=inttostr(MySelStud);

 i:=IntFromEdit(edit10);
 if i>1 then previous.enabled:=true else previous.enabled:=false;
 if i<StGroup[groupnum] then next.enabled:=true else next.enabled:=false;
 delstuddlg.caption:='Delete Student'+GroupCaption;
 label3.caption:=''; {initially no error msg}
 if i=0 then label3.caption:='Enter Student name';

end;

procedure Tdelstuddlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
 i:       integer;
begin
 action:=caFree;
 try
  screen.cursor:=crHourglass;
  if needupdate then
  begin
   SaveAllStudentYears;
  end;
 finally
  if SaveStudFlag=false then CheckAccessRights(utStud,36,false); 
  screen.cursor:=crDefault;
 end; {try}
 if usingResources then
 begin
  usingResources:=false; {sometimes called more than once, prevent attempted release if already released}
  delstuddlg.hide; {prevent seeing controls beeing removed -slows things down a lot}
  for i:=1 to nmbrChoices do
   label22[i].free;
 end;
end;

procedure Tdelstuddlg.updateClick(Sender: TObject);
var
 tmpFirst,tmpName:     string;
 snm:                  integer;
begin
 if NoCodesAvail(XML_STUDENTS.numstud,'Students') then exit;
 tmpName:=trim(edit1.text);
 tmpFirst:=trim(edit2.text);
 if ((tmpFirst='') and (tmpName='')) then
 begin
  ShowMsg('No Student selected.',edit1);
  exit; {return to editing}
 end;

 snm:=IntFromEdit(edit10);
 if snm=0 then
  begin
   ShowMsg('Student entered could not be found.',edit1);
   exit; {return to editing}
  end;


 {archive student here }
 removeStudent(snm);
 if wnFlag[wnStudentList] then
   if snm=studentlistwin.selcode then studentlistwin.selcode:=0;
 UpdateStudCalcs;
 rangeCheckStudSels(liststudentselection);
 rangeCheckStudSels(XML_DISPLAY.StudentInputSelection);
 rangeCheckStudSels(XML_DISPLAY.studentttselection);
 if next.enabled then
  begin
   if snm>0 then edit10.text:=inttostr(snm-1);
   nextClick(self);   {go to next}
  end
 else edit10.text:=' '; {clear it all}
 needupdate:=true;
 label15.caption:=inttostr(XML_STUDENTS.numstud);
end;

procedure Tdelstuddlg.findClick(Sender: TObject);
var
 msg:     string;
 oldNum:  integer;
begin
 label3.caption:='';
 findStudent;
 if bool(sTfound) then
  begin
   edit10.text:=inttostr(sTfound);
   edit1.text:=XML_STUDENTS.Stud[sTfound].stname;
   edit2.text:=XML_STUDENTS.Stud[sTfound].First;
  end
 else
 begin
  msg:='No more matching students found in group '+groupname+'.'+endline;
  messagedlg(msg, mtInformation, [mbOK], 0);
 end;
 oldNum:=IntFromEdit(edit10);
 if oldnum>1 then previous.enabled:=true else previous.enabled:=false;
 if oldnum<XML_STUDENTS.numstud then
        next.enabled:=true else next.enabled:=false;
end;

end.
