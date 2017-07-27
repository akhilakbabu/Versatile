unit Copyblck;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,Dialogs,TimeChartGlobals, GlobalToTcAndTcextra,XML.DISPLAY, XML.STUDENTS;

type
  TCopyBlockDlg = class(TForm)
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CopyTo: TBitBtn;
    ComboBox1: TComboBox;
    Label7: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure CopyToClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  end;

var
  CopyBlockDlg: TCopyBlockDlg;

implementation

uses tcommon,StCommon,block1,subyr,tcommon2,DlgCommon,TTundo;


var
 copyyear: integer;
 blocksToCopy: smallint;
{$R *.DFM}

procedure TCopyBlockDlg.FormActivate(Sender: TObject);
begin
 label7.caption:=yeartitle+' '+yearname[copyyear];
 label1.caption:='Copy to '+yeartitle;
 label4.caption:=inttostr(subsinblock);
 combobox1.ItemIndex :=combobox1.Items.IndexOf(yearname[copyyear]);
end;

procedure checkyear;
var
 found:  integer;
begin
 found:=findyear(copyblockdlg.ComboBox1.text);
 if found<>copyyear then
    if found=-1 then copyblockdlg.label7.caption:='(Enter Year)'
       else copyblockdlg.label7.caption:=yearname[found];
 copyyear:=found;
end;



procedure TCopyBlockDlg.CopyToClick(Sender: TObject);
var
 leveluse,count:   integer;
 j:        integer;
 b: byte;
begin
 if InvalidEntry(blocksToCopy,1,XML_DISPLAY.blocknum,'number of blocks to copy',edit1) then exit;
 leveluse:=0;  
 PushTtStackStart(utCopyBlocks);
 for b:=1 to blocksToCopy do
   begin
    count:=0;
    if Sheet[b,0]>0 then
     for j:=1 to Sheet[b,0] do
       if Sheet[b,j]>0 then inc(count);
    if count>leveluse then leveluse:=count;
   end;
 if leveluse>level[copyyear] then
  begin
   level[copyyear]:=leveluse;
   alterTimeFlag:=true;  AlterWSflag:=true;
  end;
 if blocksToCopy>wsBlocks then
  begin
   wsBlocks:=blocksToCopy;
   SetWSarrays;
   AlterWSflag:=true;
  end;

 for b:=1 to blocksToCopy do
  for j:=1 to leveluse do
   begin
     PushWScell(b,copyyear,j);
    (FNws(b,copyyear,j,0))^:=Sheet[b,j];
    FNputWSblockNumber(b,copyyear,j,b); //set block number as b
   end; {j}
 if SaveStudFlag then SaveAllStudentYears;

 updateWSwindow;
 SaveTimeFlag:=True;
 close;
end;

procedure TCopyBlockDlg.FormCreate(Sender: TObject);
var
 i,j,k: integer;
begin
 topcentre(self);
 edit1.text:=inttostr(XML_DISPLAY.blocknum);
 FillComboYears(false,ComboBox1);
 edit1.hint:='Enter a number (1-'+inttostr(XML_DISPLAY.blocknum)+')';
 copyYear:=0;
 for i:=1 to groupnum do
  begin
   j:=StGroup[i];
   k:=XML_STUDENTS.Stud[j].TcYear;
   if (k>copyYear) then copyYear:=k;
  end;
end;

procedure TCopyBlockDlg.ComboBox1Change(Sender: TObject);
begin
 checkyear;
end;


end.
