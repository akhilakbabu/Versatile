unit Eduser;

interface
{$WARN UNIT_PLATFORM OFF}
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, FileCtrl, XML.USERS, XML.UTILS,GlobalToTcAndTcextra;

type
  TEditUserDlg = class(TForm)
    GroupBox1: TGroupBox;
    Bevel1: TBevel;
    Label2: TLabel;
    Label4: TLabel;
    Label18: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    RadioGroup1: TRadioGroup;
    update: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    ComboBox2: TComboBox;
    Label14: TLabel;
    Edit3: TEdit;
    Label15: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label3: TLabel;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Bevel2: TBevel;
    Label17: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    SetPath1: TRadioGroup;
    Label21: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure updateClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SetPath1Click(Sender: TObject);
  end;

var
  EditUserDlg: TEditUserDlg;

implementation
uses tcload,tcommon,tcommon2,DlgCommon,tcommon5,showuser,TimeChartGlobals;
{$R *.DFM}

type
 tpCheck9 = array[1..nmbryears] of tCheckbox;
 tpLabel9 = array[1..nmbryears] of tLabel;

var
 check9: tpCheck9;
 label91: tpLabel9;
 label92: tpLabel9;
 defaultdir: String[szDirName];
 PathType,EditUsrType,MyUser: integer;

 
procedure updateCounts;
var
 i,j:       integer;
begin
 checkcount;
 with EditUserDlg do
 begin
  j:=0;
  for i:=1 to 6 do
   inc(j,passCount[i]);
  label5.caption:=inttostr(j);
  label7.caption:=inttostr(passCount[6]);
  label9.caption:=inttostr(passCount[1]);
  label11.caption:=inttostr(passCount[2]);
  label13.caption:=inttostr(passCount[3]);
 end;
end;



procedure TEditUserDlg.FormCreate(Sender: TObject);
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

 combobox2.clear;
 for i:=1 to UserRecordsCount do
  combobox2.items.add(passID[i]);

 directoryListBox1.directory:=Directories.progdir;
 PathType:=1; EditUsrType:=1;
 defaultDir:=GetDefaultUserDir(UserRecordsCount+1,EditUsrType);
 label20.Caption:=Directories.progdir;
 SetPath1.ItemIndex:=1;
 radiogroup1.ItemIndex:=0;
 label21.Caption:=UsrTypeDesc(utTime);

 {init to selection if needed}
 if wnFlag[wnShowUsers] then
  if ShowUsersWin.selcode>0 then
   begin
    combobox2.itemindex:=ShowUsersWin.selcode-1;
    ComboBox2Change(self);
   end;

end;



procedure TEditUserDlg.FormActivate(Sender: TObject);
var
 i: smallint;
begin
 updateCounts;
 button1.enabled:=(radiogroup1.itemindex<>0);
 button2.enabled:=(radiogroup1.itemindex<>0);
 for i:=1 to years do
  check9[i].enabled:=(radiogroup1.itemindex<>0);
end;

procedure TEditUserDlg.updateClick(Sender: TObject);
var
 msg,a,b,s: string;
 i,k,m,n:  integer;
begin

 if uppercase(trim(edit1.text))<>uppercase(trim(edit2.text)) then
 begin
  msg:='Confirm word doesn''t match'+endline+'Please Re-enter';
  messagedlg(msg,mtError,[mbOK],0);
  edit1.text:=''; edit2.text:='';
  edit1.selectall; edit1.setfocus; exit;
 end;

 MyUser:=combobox2.itemindex+1;

 if MyUser<1 then
 begin
  ComboMsg('No user selected',combobox2);
  exit;
 end;

 {prevent duplicate ID/Password combination}
 a:=uppercase(trim(edit3.text));
 if a='' then a:=passId[MyUser];
 b:=uppercase(trim(edit1.text));
 if b='' then b:=password[MyUser]; {allowing password to be unchanged while changing id etc.}
 k:=0;
 for i:=1 to UserRecordsCount do
 begin
  if ((uppercase(trim(passId[i]))=a)) then
  begin
   if i<>MyUser then {looking for other besides current one}
   begin
    k:=i; break;
   end;
  end;
 end;
 if k>0 then
 begin
  msg:='This User ID is already used for'
        +endline+'access type '+accessType[passlevel[k]]+' ';
  if ((passlevel[k]=2) or (passlevel[k]=3)) then
   msg:=msg+ShowPassYears(passyear[k]);
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
  if (i<>MyUser) then if (uppercase(passUserDir[i])=uppercase(s)) then
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

 {update user}
 if MyUser<>1 then {no alteration for super}
 begin
  passlevel[MyUser]:=radiogroup1.itemindex+1;
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
  if ((passlevel[MyUser]=6) or (passlevel[MyUser]=1)) then m:=-1;

  passyear[MyUser]:=m;
 end;

 passUserDir[MyUser]:=s;
 passID[MyUser]:=a;
 passBKUP[MyUser]:=checkbox1.checked;

 if passlevel[MyUser]=6 then  //update if super
  begin
   usrPassDir:=passUserDir[MyUser];
   UsrPassBKUP:=passBKUP[MyUser];
  end;
 if trim(edit1.text)>'' then
  password[MyUser]:=uppercase(trim(edit1.text));
 updateCounts;
 saveUsers;
 if wnFlag[wnShowUsers] then ShowUsersWin.ResetUsers;

 edit1.text:=''; edit2.text:='';

 combobox2.clear;
 for i:=1 to UserRecordsCount do
  combobox2.items.add(passID[i]);
 combobox2.itemindex:=MyUser-1;
 ComboBox2Change(Self);
 combobox2.setfocus;
end;

procedure TEditUserDlg.ComboBox2Change(Sender: TObject);
var
 k:       integer;
 s: string;
begin
 MyUser:=combobox2.itemindex+1;
 if (MyUser<1) or (MyUser>UserRecordsCount) then exit;
 edit3.text:=trim(combobox2.text);
// if valid directory then set to user defined and listboxes, else set to default
 s:=passUserDir[MyUser];
 EditUsrType:=passLevel[MyUser];
 defaultDir:=GetDefaultUserDir(MyUser,EditUsrType);
 if directoryexists(s) then
  begin
   directoryListBox1.directory:=s;
   PathType:=1;
   label20.Caption:=s;
   SetPath1.ItemIndex:=1;
  end
 else
  begin
   PathType:=0;
   label20.Caption:=defaultDir;
   SetPath1.ItemIndex:=0;
  end;
 checkbox1.checked:=passBKUP[MyUser];
 if EditUsrType=utSuper then
 begin
  label15.visible:=true;
  label21.Caption:=UsrTypeDesc(utSuper);
  radiogroup1.enabled:=false;
  exit;
 end
 else
  begin
   label15.visible:=false;
   radiogroup1.enabled:=true;
   radiogroup1.itemindex:=EditUsrType-1;
   label21.Caption:=UsrTypeDesc(EditUsrType);
   if passYear[MyUser]=-1 then
   begin
    for k:=1 to years do
     check9[k].checked:=true;
   end
   else
    begin
     for k:=1 to years do
     begin
      if (passYear[MyUser] and (1 shl (k-1)))>0 then
       check9[k].checked:=true
      else
       check9[k].checked:=false;
     end;
    end;
  end;
end;

procedure TEditUserDlg.Edit3Enter(Sender: TObject);
begin
 edit3.selectall;
end;

procedure TEditUserDlg.RadioGroup1Click(Sender: TObject);
var
 i: smallint;
begin
 EditUsrType:=radiogroup1.itemindex+1;
 defaultDir:=GetDefaultUserDir(MyUser,EditUsrType);
 if (PathType=0) then label20.Caption:=defaultDir;
 button1.enabled:=(radiogroup1.itemindex<>0);
 button2.enabled:=(radiogroup1.itemindex<>0);
 for i:=1 to years do
  check9[i].enabled:=(radiogroup1.itemindex<>0);
 label21.Caption:=UsrTypeDesc(EditUsrType);
end;

procedure TEditUserDlg.Button1Click(Sender: TObject);
var
 i: smallint;
begin
 for i:=1 to years do
  check9[i].checked:=false;
end;

procedure TEditUserDlg.Button2Click(Sender: TObject);
var
 i: smallint;
begin
 for i:=1 to years do
  check9[i].checked:=true;
end;

procedure TEditUserDlg.SetPath1Click(Sender: TObject);
begin
 PathType:=SetPath1.ItemIndex;
 DriveCombobox1.Enabled:=(PathType=1);
 DirectoryListBox1.Enabled:=(PathType=1);
 if PathType=0 then label20.Caption:=defaultDir
  else label20.Caption:=directoryListBox1.Directory;
end;

end.
