unit Stclash;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs, ExtCtrls,TimeChartGlobals, XML.DISPLAY, XML.STUDENTS;

type
  TStClashHelpDlg = class(TForm)
    Start: TBitBtn;
    HelpBtn: TBitBtn;
    StClashType: TRadioGroup;
    StClashAction: TRadioGroup;
    StClashGender: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Finish: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure StClashTypeClick(Sender: TObject);
    procedure StClashActionClick(Sender: TObject);
    procedure StClashGenderClick(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure Restore;
    procedure GetHelp;
  end;

var
  StClashHelpDlg: TStClashHelpDlg;
  clashflag:      bool;
procedure newchoice(Sol,st: integer);


implementation

{$R *.DFM}
uses manclash,tcommon,stcommon,subyr;
var
 DoingAuto,ExitAuto: bool;

procedure TStClashHelpDlg.Restore;
begin
 Label4.Caption:=inttostr(BlockClashes[0]);
 Label5.Caption:='';
 ClashFlag:=False; DoingAuto:=False; ExitAuto:=False;
end;

procedure TStClashHelpDlg.FormActivate(Sender: TObject);
begin
 StClashGender.ItemIndex:=SexBalance;
 StClashType.ItemIndex:=XML_DISPLAY.BalanceFlag;
 StClashAction.ItemIndex:=XML_DISPLAY.AutoBalance;
 Label2.Caption:=inttostr(linknum);
 Restore;
end;

procedure TStClashHelpDlg.StClashTypeClick(Sender: TObject);
begin
  XML_DISPLAY.BalanceFlag:=StClashType.ItemIndex;
end;

procedure TStClashHelpDlg.StClashActionClick(Sender: TObject);
begin
 XML_DISPLAY.AutoBalance:=StClashAction.ItemIndex;
end;

procedure TStClashHelpDlg.StClashGenderClick(Sender: TObject);
begin
 SexBalance:=StClashGender.ItemIndex;
 CountGroupSubs;
 updateBlockWins;
end;


procedure newchoice(Sol,st: integer);
var
 j,k,a,a1: integer;
begin
 k:=ClashOrder[Sol];
 for j:=1 to chmax do
  begin
   a:=BlClash[0,j]; a1:=BlClash[k,j];
   if a<>a1 then
    begin
     dec(GroupSubCount[GsubXref[a]]);
     inc(GroupSubCount[GsubXref[a1]]);
    end;
   XML_STUDENTS.Stud[st].Choices[j]:=BlClash[k,j];
  SaveStudFlag:=true; saveBlockFlag:=true;
  StudYearFlag[XML_STUDENTS.Stud[st].tcYear]:=true;
  end;
 clashflag:=true;
end;

procedure TStClashHelpDlg.GetHelp;
var
 i2,i:  integer;
 balancedo,clashdo: bool;
begin
 CountGroupSubs;
 clashflag:=false;
 for i2:=1 to groupnum do
  begin
   i:=StGroup[i2];
   balancedo:=(XML_DISPLAY.balanceflag=1);
   if ((sexbalance=1) and (XML_STUDENTS.Stud[i].sex=genderShort[0]{'M'}))
      or ((sexbalance=2) and (XML_STUDENTS.Stud[i].sex=genderShort[1]{'F'})) then
         balancedo:=false;
   clashdo:=false;
   if XML_DISPLAY.balanceflag=0 then if hasstudentclash(i) then clashdo:=true;
   if balancedo or clashdo then
    begin                
     label5.caption:='Student '+inttostr(i2)+'..   ';
     label5.refresh;
     getStclashes(i);
     if MyBlSolution>0 then newchoice(1,i);
    end;
   Application.ProcessMessages;
   if ExitAuto then break;
  end; {i2}
 if clashflag then
  begin
   SaveStudFlag:=True;
   SaveBlockFlag:=True;
   BlockLoad:=3;
   CalculateClashmatrix;
   CountGroupSubs;
   SubSexCountFlg:=true;
   UpdateStudWins;
   restore;
  end;
end;

procedure TStClashHelpDlg.StartClick(Sender: TObject);
var
 msg:  string;
begin
 if (XML_DISPLAY.balanceflag=0) and (BlockClashes[0]=0) then
  begin
   msg:='No clashes to solve';
   messagedlg(msg,mtError,[mbOK],0);
   exit;
  end;
 if XML_DISPLAY.AutoBalance=0 then {manual clash help}
  begin
   ManClashdlg:=TManClashdlg.create(self);  {allocate dlg}
   ManClashdlg.showmodal;
   ManClashdlg.free;   {release dlg}
   restore;
   exit;
  end;
 if DoingAuto then
  begin
   ExitAuto:=true;
   exit;
  end;
 DoingAuto:=True;
 Start.caption:='Halt';
 gethelp;
 restore;
 Start.caption:='Start';
end;

procedure TStClashHelpDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 sexbalance:=0; //force both sexes
 CountGroupSubs;
 updateStudWins;
end;

procedure TStClashHelpDlg.FormCreate(Sender: TObject);
begin
 Topcentre(self);
 if needClashMatrixRecalc then CalculateClashmatrix;
end;

end.

