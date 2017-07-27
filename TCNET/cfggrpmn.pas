unit cfggrpmn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, TimeChartGlobals;

type
  TConfigureGroupMenudlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    lsbCustomGroupsOnMenu: TListBox;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    lblPrompt: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure AddCustomGroupToMenu(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure DisplayPrompt;
  end;

var
  ConfigureGroupMenudlg: TConfigureGroupMenudlg;

implementation

uses
  tcommon, tcommon2, studlist;

{$R *.DFM}

procedure TConfigureGroupMenudlg.FormCreate(Sender: TObject);
var
 i: smallint;
begin
 listbox1.clear;
 lsbCustomGroupsOnMenu.Clear;
 if GOSnum>0 then
  for i:=1 to GOSnum do
   listbox1.items.add(GOSname[i]);

 if GOSmenu[0]>0 then
  for i:=1 to GOSmenu[0] do
   lsbCustomGroupsOnMenu.Items.Add(GOSname[GOSmenu[i]]);

 label4.caption:=inttostr(listbox1.items.count);
 label5.caption:=inttostr(lsbCustomGroupsOnMenu.Items.Count);
end;

procedure TConfigureGroupMenudlg.FormShow(Sender: TObject);
begin
  lblPrompt.Caption := '';
  DisplayPrompt;
end;

function findCustomGroupNameIndex(ss: string):smallint;
var
 i: smallint;
begin
 result:=0;
 if GOSnum=0 then exit;

 for i:=1 to GOSnum do
  if ss=GOSname[i] then
  begin
   result:=i; break;
  end;
end;

procedure TConfigureGroupMenudlg.OKbuttonClick(Sender: TObject);
var
 i,j: smallint;
begin
 j:= lsbCustomGroupsOnMenu.Items.Count;
 if j>nmbrCustomGroupMenus then j:=nmbrCustomGroupMenus;
 if j>0 then
  for i:=1 to j do
   GOSmenu[i]:=findCustomGroupNameIndex(lsbCustomGroupsOnMenu.Items[i-1]);
 GOSmenu[0]:=j;
 {update menu}
 updateCustomMenus;

 saveGroups;
end;

procedure TConfigureGroupMenudlg.BitBtn1Click(Sender: TObject);
var
 i:       integer;
begin
 if lsbCustomGroupsOnMenu.Items.Count > 0 then
 begin
  for i:=(lsbCustomGroupsOnMenu.Items.Count - 1) downto 0 do
    if lsbCustomGroupsOnMenu.Selected[i] then lsbCustomGroupsOnMenu.Items.Delete(i);
 end;
  label5.caption:=inttostr(lsbCustomGroupsOnMenu.Items.Count);
  DisplayPrompt;
end;

procedure TConfigureGroupMenudlg.BitBtn2Click(Sender: TObject);
begin
  lsbCustomGroupsOnMenu.Clear;
  label5.Caption := IntToStr(lsbCustomGroupsOnMenu.Items.Count);
  DisplayPrompt;
end;

procedure TConfigureGroupMenudlg.AddCustomGroupToMenu(Sender: TObject);
var
  i: Integer;
begin
  if listbox1.Items.Count > 0 then
  begin
    for i:=0 to (listbox1.Items.Count-1) do
    begin
      if listbox1.selected[i] then
        if lsbCustomGroupsOnMenu.Items.IndexOf(listbox1.Items[i])=-1 then
           lsbCustomGroupsOnMenu.Items.Add(listbox1.Items[i]);
    end;  {for i}
  end;
  label5.Caption := IntToStr(lsbCustomGroupsOnMenu.Items.Count);
  DisplayPrompt;
end;

procedure TConfigureGroupMenudlg.BitBtn4Click(Sender: TObject);
begin
  lsbCustomGroupsOnMenu.Clear;
  lsbCustomGroupsOnMenu.Items := listbox1.Items;
  label5.Caption := IntToStr(lsbCustomGroupsOnMenu.Items.Count);
  DisplayPrompt;
end;

procedure TConfigureGroupMenudlg.UpBtnClick(Sender: TObject);
var
  i: integer;
begin
  if lsbCustomGroupsOnMenu.Count > 1 then
    for i:=1 to lsbCustomGroupsOnMenu.Count - 1 do
      if (lsbCustomGroupsOnMenu.Selected[i] and not(lsbCustomGroupsOnMenu.Selected[i-1])) then
      begin
        lsbCustomGroupsOnMenu.Items.Move(i,i-1);
        lsbCustomGroupsOnMenu.Selected[i-1]:=true;
      end;
end;

procedure TConfigureGroupMenudlg.DisplayPrompt;
begin
  if lsbCustomGroupsOnMenu.Items.Count = nmbrCustomGroupMenus then
    lblPrompt.Caption := Format('Maximum number of groups to show on menu is %d.', [nmbrCustomGroupMenus])
  else if lsbCustomGroupsOnMenu.Items.Count > nmbrCustomGroupMenus then
    lblPrompt.Caption := 'You exceeded the maximum number of groups to show on menu. Some of the groups will not show on the Group menu.'
  else
    lblPrompt.Caption := '';
end;

procedure TConfigureGroupMenudlg.DnBtnClick(Sender: TObject);
var
  i: integer;
begin
  if lsbCustomGroupsOnMenu.Count > 1 then
    for i := lsbCustomGroupsOnMenu.Count-2 downto 0 do
      if (lsbCustomGroupsOnMenu.Selected[i] and not(lsbCustomGroupsOnMenu.Selected[i+1])) then
      begin
        lsbCustomGroupsOnMenu.Items.Move(i, i + 1);
        lsbCustomGroupsOnMenu.Selected[i + 1] := True;
      end;
end;

end.
