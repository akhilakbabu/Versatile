unit Adduser;

interface
{$WARN UNIT_PLATFORM OFF}
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, FileCtrl, XML.USERS,XML.UTILS,GlobalToTcAndTcextra;

type
  TAddNewUserDlg = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit3: TEdit;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label18: TLabel;
    Edit2: TEdit;
    Bevel1: TBevel;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    Bevel2: TBevel;
    Label17: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Button1: TButton;
    Button2: TButton;
    SetPath1: TRadioGroup;
    CheckBox1: TCheckBox;
    Label14: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SetPath1Click(Sender: TObject);
  private
    procedure UpdateCounts;  
  end;

var
  AddNewUserDlg: TAddNewUserDlg;

implementation
uses tcload,tcommon,tcommon2,DlgCommon,TimeChartGlobals,tcommon5, Showuser;
{$R *.DFM}

type
 tpCheck9 = array[1..nmbryears] of tCheckbox;
 tpLabel9 = array[1..nmbryears] of tLabel;

var
 check9: tpCheck9;
 label91: tpLabel9;
 label92: tpLabel9;
 defaultdir: String[szDirName];
 PathType,AddUsrType: integer;

procedure TAddNewUserDlg.UpdateCounts;
var
 i,j:       integer;
begin
 checkcount;
 j:=0;
 for i:=1 to 6 do inc(j,passCount[i]);
 label5.caption:=inttostr(j);
 label7.caption:=inttostr(passCount[6]);
 label9.caption:=inttostr(passCount[1]);
 label11.caption:=inttostr(passCount[2]);
 label13.caption:=inttostr(passCount[3]);
end;

procedure TAddNewUserDlg.FormCreate(Sender: TObject);
var
 i:       integer;
begin
 label1.caption:=yeartitle+':';
 button1.hint:='Clear all '+yeartitle+'s';
 button2.hint:='Select all '+yeartitle+'s';

 for i:=1 to years do
  begin
   check9[i]:=tcheckbox.create(application);
   check9[i].tag:=i;
   check9[i].width:=17; check9[i].height:=17;
   check9[i].parent:=groupbox1;
   check9[i].caption:='';    check9[i].checked:=true; //init to all years
   check9[i].hint:=yeartitle+': '+yearname[i-1];
   check9[i].showhint:=true;
   check9[i].left:=label1.left+label1.width+9+((i-1)*(17+9));
   check9[i].top:=label1.top+label1.height+2;
  end;

 button2.left:=check9[years].left+check9[years].width+9;

 for i:=1 to years do
  begin
   label91[i]:=tlabel.create(application);
   label92[i]:=tlabel.create(application);
   label91[i].parent:=groupbox1;  label92[i].parent:=groupbox1;
   label91[i].caption:=inttostr(i);
   label92[i].caption:=copy(yearname[i-1],1,2);
   label91[i].hint:=yeartitle+': '+yearname[i-1];
   label91[i].showhint:=true; label91[i].enabled:=true;
   label91[i].focuscontrol:=check9[i];
   label92[i].hint:=yeartitle+': '+yearname[i-1];
   label92[i].showhint:=true; label92[i].enabled:=true;
   label92[i].focuscontrol:=check9[i];
   label91[i].left:=check9[i].left;  label92[i].left:=check9[i].left;
   label91[i].top:=label1.top;  label92[i].top:=label1.top+7+(2*label1.height);
  end;
 directoryListBox1.directory:=Directories.progdir;
 PathType:=0; AddUsrType:=1;
 defaultDir:=GetDefaultUserDir(UserRecordsCount+1,AddUsrType);
 label20.Caption:=defaultDir;
 SetPath1.ItemIndex:=0;
 radiogroup1.ItemIndex:=0;
 label14.Caption:=UsrTypeDesc(utTime);
 DriveCombobox1.Enabled:=false;
 DirectoryListBox1.Enabled:=false;
end;




procedure TAddNewUserDlg.OKbuttonClick(Sender: TObject);
var
 msg,a,b,s: string;
 i,j,k,m,n:  integer;
begin
 if trim(edit3.text)='' then
  begin
   ShowMsg('User ID is required',edit3);
   exit;
  end;
 if trim(edit1.text)='' then
  begin
   ShowMsg('Password is required!',edit1);
   exit;
  end;
 if uppercase(trim(edit1.text))<>uppercase(trim(edit2.text)) then
  begin
   msg:='Confirm word doesn''t match'+endline+'Please Re-enter';
   messagedlg(msg,mtError,[mbOK],0);
   edit1.text:=''; edit2.text:='';
   edit1.selectall; edit1.setfocus; exit;
  end;
 a:=uppercase(trim(edit3.text));
 b:=uppercase(trim(edit1.text));
 j:=0;
 for i:=1 to UserRecordsCount do
  if (uppercase(trim(passId[i]))=a) then
   begin
    j:=i; break;
   end;
 if j>0 then
  begin
   msg:='This User ID is already used for'
        +endline+'access type '+accessType[passlevel[j]]+' ';
   if ((passlevel[j]=2) or (passlevel[j]=3)) then
     msg:=msg+ShowPassYears(passyear[j]);
   messagedlg(msg,mtError,[mbOK],0);
   edit1.text:=''; edit2.text:='';
   edit1.selectall; edit1.setfocus; exit;
  end;

 if PathType=0 then {default path}
  begin
   if not(directoryexists(Directories.UsersDir)) then CreateDir(Directories.UsersDir);
   if not(directoryexists(DefaultDir)) then
    begin
     CreateDir(DefaultDir);
     directoryListBox1.Update;
    end;
   if not(directoryexists(DefaultDir)) then
    begin
     msg:='Cannot create default display directory';
     directoryListBox1.setfocus;
     exit;
    end;
  end;

 if PathType=1 then s:=directoryListBox1.directory else s:=DefaultDir;

 m:=verifyUserDirectory(s);
 if (m<>0) then
  begin
   msg:='Directory for storing display file'+endline;
   case m of
    1: msg:=msg+'should NOT be the same as the program directory.';
    2: msg:=msg+'should NOT be the same as the data directory.';
    3: msg:=msg+'must ALREADY exist.';
    4: msg:=msg+'must be set to allow read and write access.';
   end; {case}
   msg:=msg+endline+'Please Re-select the directory.';
   messagedlg(msg,mtError,[mbOK],0);
   directoryListBox1.setfocus;
   exit;
  end;

 k:=0;
 for i:=1 to UserRecordsCount do
  if (uppercase(passUserDir[i])=uppercase(s)) then
   begin
    k:=i; break;
   end;
 if k>0 then
  begin
   msg:='This display directory is already used for'
        +endline+'user ID '+passId[k];
   messagedlg(msg,mtError,[mbOK],0);
   exit;
  end;

 {add user}
 inc(UserRecordsCount);
 passlevel[UserRecordsCount]:=radiogroup1.itemindex+1;
  m:=0; n:=1;
  for k:=1 to years do
   if not(check9[k].checked) then
    begin
     n:=0; break;
    end;
  if n=1 then m:=-1 //all years
  else
   begin //find year mapping
    for k:=1 to years do
     if check9[k].checked then
      inc(m,(1 shl (k-1)));
   end;
 passyear[UserRecordsCount]:=m;
 passID[UserRecordsCount]:=uppercase(trim(edit3.text));
 password[UserRecordsCount]:=uppercase(trim(edit1.text));
 passUserDir[UserRecordsCount]:=s;
 passBKUP[UserRecordsCount]:=checkbox1.checked;

 UpdateWindow(wnShowUsers);
 updateCounts;
 saveUsers;

 edit1.text:=''; edit2.text:='';  edit3.text:='';
 PathType:=0;
 defaultDir:=GetDefaultUserDir(UserRecordsCount+1,AddUsrType);
 SetPath1.ItemIndex:=0;
 label20.Caption:=defaultDir;
 edit3.setfocus;
end;


procedure TAddNewUserDlg.FormActivate(Sender: TObject);
var
 i: smallint;
begin
 updateCounts;
 button1.enabled:=(radiogroup1.itemindex<>0);
 button2.enabled:=(radiogroup1.itemindex<>0);
 for i:=1 to years do
  check9[i].enabled:=(radiogroup1.itemindex<>0);
 edit3.SetFocus;
end;

procedure TAddNewUserDlg.RadioGroup1Click(Sender: TObject);
var
 i: smallint;
begin
 AddUsrType:=radiogroup1.itemindex+1;
 defaultDir:=GetDefaultUserDir(UserRecordsCount+1,AddUsrType);
 if (PathType=0) then label20.Caption:=defaultDir;
 button1.enabled:=(radiogroup1.itemindex<>0);
 button2.enabled:=(radiogroup1.itemindex<>0);
 for i:=1 to years do
  check9[i].enabled:=(radiogroup1.itemindex<>0);
 label14.Caption:=UsrTypeDesc(AddUsrType);
end;

procedure TAddNewUserDlg.Button1Click(Sender: TObject);
var
 i: smallint;
begin
 for i:=1 to years do check9[i].checked:=false;
end;

procedure TAddNewUserDlg.Button2Click(Sender: TObject);
var
 i: smallint;
begin
 for i:=1 to years do check9[i].checked:=true;
end;

procedure TAddNewUserDlg.SetPath1Click(Sender: TObject);
begin
 PathType:=SetPath1.ItemIndex;
 DriveCombobox1.Enabled:=(PathType=1);
 DirectoryListBox1.Enabled:=(PathType=1);
 if PathType=0 then label20.Caption:=defaultDir
  else label20.Caption:=directoryListBox1.Directory;
end;

end.
