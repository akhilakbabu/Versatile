unit Cnfglev;

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals,GlobalToTcAndTcextra;

type
  TConfigureLevels = class(TForm)
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    update: TBitBtn;
    GroupBox1: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure updateClick(Sender: TObject);
    procedure MyKeyPress(Sender: TObject; var Key: Char);
  end;

var
  ConfigureLevels: TConfigureLevels;

implementation

uses tcommon,tcommon2,DlgCommon,TTundo, ttable;
{$R *.DFM}
var
 edit2:   array[1..nmbrYears] of tedit;
 label9:  array[1..nmbrYears] of tlabel;
 usingResources:                bool;

procedure TConfigureLevels.MyKeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TConfigureLevels.FormCreate(Sender: TObject);
var
 i:       integer;
begin
 for i:=1 to years do
 begin
  edit2[i]:=tedit.create(application);
  edit2[i].onkeypress:=MyKeypress;
  edit2[i].maxlength:=3;
  edit2[i].width:=31; edit2[i].height:=20;
  edit2[i].text:=inttostr(level[i-1]);
  edit2[i].parent:=groupbox1;
  edit2[i].hint:='Enter number of levels for '+yearname[i-1];
  edit2[i].showhint:=true;
  label9[i]:=tlabel.create(application);
  label9[i].Alignment:=taRightJustify;
  label9[i].Autosize:=false;
  label9[i].width:=118; label9[i].height:=13;
  label9[i].caption:=yearname[i-1];
  label9[i].parent:=groupbox1;

  label9[i].left:=14+((i-1) mod 3)*170;
  label9[i].top:=22+((i-1) div 3)*27;
  edit2[i].left:=label9[i].left+124;
  edit2[i].top:=label9[i].top-2;

 end; {i}
 usingResources:=true;
end;

procedure TConfigureLevels.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 i:       integer;
begin
 action:=caFree;

 if usingResources then   {can call close even after closeed it seems}
 begin
  usingResources:=false;
  Configurelevels.hide; {prevent seeing controls beeing removed -slows things down a lot}
  for i:=1 to Years do
  begin
   edit2[i].free;
   label9[i].free;
  end;
 end;
end;

procedure TConfigureLevels.FormActivate(Sender: TObject);
begin
 ConfigureLevels.GroupBox1.caption:=
     'Set Levels (1-'+inttostr(levelprint)+') for each '+yeartitle;
end;

procedure TConfigureLevels.updateClick(Sender: TObject);
var
 tmpInt,i,errpos:       integer;
 msg:     string;
begin
 errpos:=0;
 for i:=1 to years do
  begin
   tmpInt:=IntFromEdit(edit2[i]);
   if (tmpint<1) or (tmpint>levelprint) then
    begin
     errpos:=i;
     break;
    end;
  end;
 if errpos>0 then
 begin
  msg:='Enter levels between 1 and '+inttostr(levelprint)+' for '+yearshort+' '+yearname[i-1];
  messagedlg(msg,mtError,[mbOK],0);
  edit2[errpos].setfocus;
  edit2[errpos].selectAll;
  exit;
 end;
 pushLevels;
 for i:=1 to years do
  level[i-1]:= IntFromEdit(edit2[i]);
 DoAllTtClashes;
 CalcLevelsUsed;
 SaveTimeFlag:=True; AlterTimeFlag:=True;  AlterWSflag:=true;
 SetTimeCell;
 UpdateAllWins;
 close;
end;



end.
