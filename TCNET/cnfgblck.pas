unit cnfgblck;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, TimeChartGlobals, ExtCtrls,GlobalToTcAndTcextra;

type
  TConfigureblocks = class(TForm)
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MyEdit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure updateClick(Sender: TObject);
  end;

var
  Configureblocks: TConfigureblocks;

implementation
uses tcommon,DlgCommon,TTundo, ttable, block1,tcommon2;

{$R *.DFM}
var
 edit2:   array[1..nmbrYears] of tedit;
 label9:  array[1..nmbrYears] of tlabel;
 usingResources:                bool;



procedure TConfigureblocks.FormCreate(Sender: TObject);
var
 i:       integer;
const
 xgap=20;
 ygap=5;
begin
 for i:=1 to years do
  begin
   edit2[i]:=tedit.create(application);
   edit2[i].maxlength:=2;
   edit2[i].onkeypress:=MyEdit2Keypress;
   label9[i]:=tlabel.create(application);
   label9[i].width:=118; label9[i].height:=13;
   label9[i].Alignment:=taRightJustify;
   label9[i].Autosize:=false;
   edit2[i].width:=49; edit2[i].height:=20;
   edit2[i].parent:=groupbox1;
   edit2[i].hint:='Enter number of blocks for '+yeartitle+' '+yearname[i-1];
   edit2[i].showhint:=true;
   label9[i].parent:=groupbox1;
   edit2[i].text:=inttostr(i);
   label9[i].caption:=yearname[i-1];

   label9[i].left:=14+((i-1) mod 3)*170;
   label9[i].top:=22+((i-1) div 3)*27+label3.top+label3.height;
   edit2[i].left:=label9[i].left+124;
   edit2[i].top:=label9[i].top-2;
  end;
 edit1.Text:=inttostr(wsBlocks); 
 usingResources:=true;
end;

procedure TConfigureblocks.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 i:       integer;
begin
 action:=caFree;

 if usingResources then   {can call close even after closeed it seems}
 begin
  usingResources:=false;
  Configureblocks.hide; {prevent seeing controls beeing removed -slows things down a lot}
  for i:=1 to nmbrYears do
  begin
   edit2[i].free;
   label9[i].free;
  end;
 end;
end;

procedure TConfigureblocks.MyEdit2KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TConfigureblocks.FormActivate(Sender: TObject);
var
 i: smallint;
begin
 for i:=1 to nmbryears do
  if i<=years then
   edit2[i].text:=trim(inttostr(blocks[i-1]))
  else
   edit2[i].text:='';
end;

procedure TConfigureblocks.updateClick(Sender: TObject);
var
 Nblock,yy,maxBlock:        smallint;
begin
 maxBlock:=0;
 for yy:=0 to years_minus_1 do
  begin
   if InvalidEntry(Nblock,2,nmbrBlocks,
    'number of blocks for '+yeartitle+' '+yearname[yy],edit2[yy+1]) then exit;
   if Nblock>maxBlock then maxBlock:=Nblock;
  end;

 if InvalidEntry(Nblock,maxBlock,nmbrBlocks,
    'number of worksheet blocks',Edit1) then exit;
 pushBlocks;
 wsBlocks:=Nblock;
 for yy:=0 to years_minus_1 do
  begin
   if InvalidEntry(Nblock,2,nmbrBlocks,
    'number of blocks for '+yeartitle+' '+yearname[yy],edit2[yy+1]) then exit;
   blocks[yy]:=Nblock;
  end; {for yy}
 SetWSarrays;
 SaveTimeFlag:=True; AlterTimeFlag:=True; AlterWSflag:=true;
 UpdateWindow(wnBlockClashes);
 updateWSwindow;
 close;
end;

end.
