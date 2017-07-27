unit Edpasswd;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, XML.USERS, GlobalToTcAndTcextra;

type
  Tedpassworddlg = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Label18: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    update: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure updateClick(Sender: TObject);
  end;

var
  edpassworddlg: Tedpassworddlg;

implementation
uses tcload,tcommon,DlgCommon,tcommon2,tcommon5,TimeChartGlobals;
{$R *.DFM}

procedure Tedpassworddlg.FormCreate(Sender: TObject);
begin
 label1.caption:=passID[CurrentUserRecordIndex];
end;

procedure Tedpassworddlg.updateClick(Sender: TObject);
var
 msg,a,b: shortstring;
 i,j:     smallint;
begin
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
 {prevent duplicate ID/Password combination}
 a:=passId[CurrentUserRecordIndex];
 b:=uppercase(trim(edit1.text));
 j:=0;
 for i:=1 to UserRecordsCount do
  if ((passId[i]=a) and (password[i]=b)) then
   if i<>CurrentUserRecordIndex then {looking for other besides current one}
    begin
     j:=i; break;
    end;
 if j>0 then
  begin
   msg:='Password/User ID combination already used for'
        +endline+'access type '+accessType[passlevel[j]]+' ';
   if ((passlevel[j]=2) or (passlevel[j]=3)) then
     msg:=msg+ShowPassYears(passyear[j]);
   messagedlg(msg,mtError,[mbOK],0);
   edit1.text:=''; edit2.text:='';
   edit1.selectall; edit1.setfocus; exit;
  end;
 {update user password}
 password[CurrentUserRecordIndex]:=RpadString(uppercase(trim(edit1.text)),szPassword);
 SaveUsers;
 close;
end;

end.
