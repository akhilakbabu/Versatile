unit Delyrsub;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, XML.STUDENTS;

type
  Tdelyrsubdlg = class(TForm)
    Label12: TLabel;
    Label13: TLabel;
    finish: TBitBtn;
    delete: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure deleteClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure finishClick(Sender: TObject);
  end;

var
  delyrsubdlg: Tdelyrsubdlg;

implementation
uses tcommon,stcommon,subyr,block1,tcommon2,tcommon5,DlgCommon;
{$R *.DFM}

var
 needUpdate:   bool;


procedure Tdelyrsubdlg.FormActivate(Sender: TObject);
var
 dataNum:       integer;
begin
 {init here}
 edit1.maxlength:=lencodes[0];
 needUpdate:=false;

 label13.caption:=inttostr(subyearwin.TotalCodes);
 if (subyearwin.selCode>0) then
 begin
  dataNum:=SubYearDisp[subyearwin.selcode];  {year subjects}
  edit1.text:=trim(SubCode[GroupSubs[dataNum]]);
  label3.caption:=subname[GroupSubs[dataNum]];
  label5.caption:=inttostr(GroupSubCount[dataNum]);
 end
 else
  begin
   edit1.text:='';
   label3.caption:='';
   label5.caption:='';
  end;
 edit1.setfocus;

end;

procedure Tdelyrsubdlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;  fRemSubyrDlgUp:=false;
 if needUpdate then SaveAllStudentYears;
 CheckAccessRights(utStud,36,false);
end;

procedure Tdelyrsubdlg.deleteClick(Sender: TObject);
var
 foundpos:      integer;
 foundyearpos:  integer;
 i,j,k:        integer;
 tmpStr:        string;
 fromblock,sublevel:  integer;
begin
 if NoCodesAvail(GroupSubs[0],'Group Subject codes') then exit;
 if NoCode(tmpStr,edit1) then exit;
 if CodeNotFound(foundpos,0,edit1) then exit;
 foundyearpos:=findsubyear(foundpos);
 if foundyearpos=0 then exit; {no students in this subject from current group}
 for i:=1 to groupnum do
  begin
   k:=StGroup[i];
// check to ensure user has rights to change year data
   if not(CheckUserYearPassAccess(XML_STUDENTS.Stud[k].tcYear)) then continue;
   for j:=1 to chmax do
    if XML_STUDENTS.Stud[k].Choices[j]=foundpos then
     begin
      SaveStudFlag:=true;
      StudYearFlag[XML_STUDENTS.Stud[k].tcYear]:=true;
      XML_STUDENTS.Stud[k].Choices[j]:=0; {remove stud choices from group}
      dec(GroupSubCount[foundyearpos]);
     end;
  end; {for i}

 if GroupSubCount[foundyearpos]=0 then
  begin
   fromblock:=findblock(GroupSubs[foundyearpos],sublevel);
   if fromblock>0 then blockchange(GroupSubs[foundyearpos],0);
   dec(GroupSubs[0]);
   if foundyearpos<=GroupSubs[0] then
    for i:=foundyearpos to GroupSubs[0] do
     begin
      GroupSubs[i]:=GroupSubs[i+1];
      Blocktop[i]:=Blocktop[i+1];
      GroupSubCount[i]:=GroupSubCount[i+1];
     end; {for i}
   GroupSubs[GroupSubs[0]+1]:=0;
   Blocktop[GroupSubs[0]+1]:=0;
   GroupSubCount[GroupSubs[0]+1]:=0;
   XrefGroupSubs;
  end;

 if subyearwin.selcode=foundyearpos then subyearwin.selcode:=0; {cancel selection if necessary}
 UpdateStudCalcs;
 needUpdate:=true;
 Label13.Caption:=inttoStr(GroupSubs[0]);
 edit1.text:='';   label3.caption:=''; label5.caption:='';
 edit1.setfocus;
end;

procedure Tdelyrsubdlg.Edit1Change(Sender: TObject);
var
 codeStr:       string;
 codePlace:     integer;
 foundyearpos:  integer;
begin
 codeStr:=trim(edit1.text);
 codePlace:=checkCode(0,codestr);
 label3.caption:='';   label5.caption:='';
 if codePlace>0 then
 begin
  foundyearpos:=findsubyear(codePlace);
  if foundyearpos>0 then
    begin
     label3.caption:=FNsubname(GroupSubs[foundyearpos],0);
     label5.caption:=inttostr(GroupSubCount[foundyearpos]);
    end;
 end;
end;

procedure Tdelyrsubdlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
 edit1.hint:='Enter subject code to remove from group';
 delete.hint:='Remove subject from group';
end;

procedure Tdelyrsubdlg.finishClick(Sender: TObject);
begin
 close;
end;

end.
