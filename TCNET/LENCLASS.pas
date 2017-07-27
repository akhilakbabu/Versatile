unit Lenclass;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals;

type
  TlenClassDlg = class(TForm)
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure updateClick(Sender: TObject);
  private
    function CodeLengths:bool;
  end;

var
  lenClassDlg: TlenClassDlg;

implementation
uses tcommon,tcommon2,RollClassWnd,DlgCommon;

{$R *.DFM}

procedure TlenClassDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
end;

procedure TlenClassDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TlenClassDlg.FormActivate(Sender: TObject);
begin
 edit1.text:=inttostr(LenClassCodes);
 label2.caption:=inttostr(LenClassCodes);
 edit1.setfocus;
end;

function checkforDupsonRed(n:integer): bool;
var
 i,j,k: integer;
 a,b: string;
begin
 k:=0;
 if Classnum>1 then
  for i:=1 to Classnum-1 do
   for j:=i+1 to Classnum do
   begin
    a:=copy(ClassCode[i],1,n);
    b:=copy(ClassCode[j],1,n);
    if ((a=b) and (a>'')) then begin k:=j; break; end;
   end;
 if k=0 then result:=false else result:=true;
end;

function TlenClassDlg.CodeLengths:bool;
var
 cl,i: smallint;
begin
 result:=false;
 if BadLength(cl,2,szClassName,edit1) then exit;
 {check reduction of codelength doesnt create duplicates - do not allow this}
 if checkforDupsonRed(cl) then
  begin
   ReductionMsg('roll class',edit1);
   result:=false;
   exit;
  end;

 LenClassCodes:=cl;
 {change codes and save}
 for i:=1 to RollClassPoint[0] do
  ClassCode[i]:=copy(RpadString(ClassCode[i],LenClassCodes),
                          1,LenClassCodes);
 updateclass;
 result:=true;
end;

procedure TlenClassDlg.updateClick(Sender: TObject);
begin
 if codelengths then
  begin
   AlterTimeFlag:=True;
   AlterWSflag:=true;
   UpdateAllWins;
  end;
 close;
end;

end.
