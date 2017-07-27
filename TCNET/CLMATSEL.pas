unit Clmatsel;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals,XML.DISPLAY;

type
  Tcmatsel = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label4: TLabel;
    Label5: TLabel;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure CancelbuttonClick(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
  private
    procedure updatethisdlg;
  end;

var
  cmatsel: Tcmatsel;

implementation
uses tcommon,DlgCommon,tcommon2;
{$R *.DFM}
var
 tmpsel:  tpCmatrixSelection;


procedure  Tcmatsel.updatethisdlg;
var
 i:    integer;
begin
 listbox2.clear;
 if tmpsel[0]>0 then
  for i:=1 to tmpsel[0] do
   listbox2.items.add(subcode[tmpsel[i]]);
 label5.caption:=inttostr(listbox2.items.count);
end;

procedure Tcmatsel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure Tcmatsel.FormCreate(Sender: TObject);
var
 i,a:       integer;
begin
 for i:=0 to nmbrSubYear do tmpSel[i]:=0;
 listbox1.clear;   listbox2.clear;
 for i:=1 to GroupSubs[0] do
  if (GroupSubCount[i]>0) then
   listbox1.items.add(RpadString(subcode[GroupSubs[i]],10));
 label4.caption:=inttostr(listbox1.items.count);

 if XML_DISPLAY.ClashMatrixSelection[0]=-1 then  {all from init}
 begin
  a:=0;
  for i:=1 to GroupSubs[0] do
   if (GroupSubCount[i]>0) then
    begin
     inc(a);
     XML_DISPLAY.ClashMatrixSelection[a]:=GroupSubs[i];
    end;
  XML_DISPLAY.ClashMatrixSelection[0]:=a;
 end;

rangeCheckSubyrSels(XML_DISPLAY.ClashMatrixSelection);
 for i:=0 to nmbrSubyear do
  tmpsel[i]:=XML_DISPLAY.ClashMatrixSelection[i];

end;

procedure Tcmatsel.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpSel,listbox2,label5);
end;

procedure Tcmatsel.BitBtn4Click(Sender: TObject);
var
 i,a:       integer;
begin
 a:=0;  listbox2.clear;
 listbox2.items:=listbox1.items;
  for i:=1 to GroupSubs[0] do
   if (GroupSubCount[i]>0) then
    begin
     inc(a);
     tmpsel[a]:=GroupSubs[i];
    end;
  tmpsel[0]:=a;
  label5.caption:=inttostr(listbox2.items.count);
end;

procedure Tcmatsel.BitBtn3Click(Sender: TObject);
var
 i,sub:       integer;
 astr:    string;
begin
 if listbox1.items.count>0 then
 begin
  for i:=0 to (listbox1.items.count-1) do
  begin
   if listbox1.selected[i] then
    if listbox2.items.indexof(listbox1.items[i])=-1 then
    begin
     listbox2.items.add(listbox1.items[i]);
     astr:=trim(listbox1.items[i]);
     sub:=checkCode(0,astr);
     inc(tmpsel[0]); tmpsel[tmpsel[0]]:=sub;
    end;
  end;  {for i}
 end;
 label5.caption:=inttostr(listbox2.items.count);
end;

procedure Tcmatsel.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpSel,listbox2,label5);
end;

procedure Tcmatsel.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure Tcmatsel.OKbuttonClick(Sender: TObject);
var
i:  integer;
begin
 for i:=0 to nmbrSubyear do
  XML_DISPLAY.ClashMatrixSelection[i]:=tmpsel[i];
 close;
 UpdateWindow(wnCmatrix);
end;

procedure Tcmatsel.FormActivate(Sender: TObject);
begin
 updatethisdlg;
end;

procedure Tcmatsel.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpSel,ListBox2);
end;

procedure Tcmatsel.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpSel,ListBox2);
end;

end.
