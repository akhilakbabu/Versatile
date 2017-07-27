unit Deluser;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, XML.USERS, GlobalToTcAndTcextra;

type
  TDeleteUserDlg = class(TForm)
    GroupBox1: TGroupBox;
    Bevel1: TBevel;
    Label4: TLabel;
    ComboBox2: TComboBox;
    delete: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
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
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure deleteClick(Sender: TObject);
  private
    procedure UpdateCounts;  
  end;

var
  DeleteUserDlg: TDeleteUserDlg;

implementation
uses tcload,tcommon,tcommon2,DlgCommon,tcommon5,showuser,TimeChartGlobals;
{$R *.DFM}

procedure TDeleteUserDlg.updateCounts;
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

procedure TDeleteUserDlg.FormCreate(Sender: TObject);
var
 i:       integer;
begin
 combobox2.clear;
 label16.caption:=''; label14.caption:='';
 for i:=1 to UserRecordsCount do
  combobox2.items.add(passID[i]);

 if wnFlag[wnShowUsers] then
  if ShowUsersWin.selcode>0 then
   begin
    combobox2.itemindex:=ShowUsersWin.selcode-1;
    ComboBox2Change(self);
   end;
end;

procedure TDeleteUserDlg.FormActivate(Sender: TObject);
begin
 updateCounts;
end;

procedure TDeleteUserDlg.ComboBox2Change(Sender: TObject);
var
 i:       integer;
begin
 i:=combobox2.itemindex+1;
 if i<1 then exit;
 if passLevel[i]=6 then
  begin
   delete.enabled:=false;
   label16.font.color:=clred;
  end
 else
  begin
   delete.enabled:=true;
   label16.font.color:=clWindowText;
  end;

 label16.caption:=accessType[passLevel[i]];
 if ((passlevel[i]=1) or (passlevel[i]=6)) then label14.caption:=''
  else label14.caption:=ShowPassYears(passyear[i]);
end;

procedure TDeleteUserDlg.deleteClick(Sender: TObject);
var
 i,j: integer;
 msg: string;
begin
 i:=combobox2.itemindex+1;
 if i<1 then
  begin
   ComboMsg('No user selected.',combobox2);
   exit;
  end;
 if passLevel[i]=6 then
  begin
   ComboMsg('Supervisor deletion not allowed',combobox2);
   exit;
  end;

 msg:='Delete'+endline+'User ID: '+passID[i]+
  endline+'Access level: '+accessType[passLevel[i]];
 if passlevel[i]>1 then msg:=msg+ShowPassYears(passyear[i]);
 if messagedlg(msg,mtConfirmation,[mbYes,mbNo],0)<>mryes then exit;
 {delete user}
 dec(UserRecordsCount);

 if UserRecordsCount+1>i then {exit; }
  for j:=i to UserRecordsCount do
   begin
    passID[j]:=passID[j+1];
    password[j]:=password[j+1];
    passlevel[j]:=passlevel[j+1];
    passyear[j]:=passyear[j+1];
    passBKUP[j]:=passBKUP[j+1];
    if CurrentUserRecordIndex=(i+1) then dec(CurrentUserRecordIndex);
    passUserDir[j]:=passUserDir[j+1];
   end;
 updateCounts;
 saveUsers;

 if wnFlag[wnShowUsers] then
  begin
   if ShowUsersWin.selCode=i then ShowUsersWin.selcode:=0;
   if ShowUsersWin.selCode>i then dec(ShowUsersWin.selCode);
   ShowUsersWin.ResetUsers;
  end;

 combobox2.clear;  j:=i;
 for i:=1 to UserRecordsCount do
  begin
   combobox2.items.add(passID[i]);
  end;
 combobox2.itemindex:=j-2;
 ComboBox2Change(self);
 combobox2.setfocus;
end;


end.
