unit Setblock;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Dialogs, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,TimeChartGlobals, GlobalToTcAndTcextra, XML.DISPLAY;

type
  TSetBlocksDlg = class(TForm)
    SetBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetBtnClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  end;

var
  SetBlocksDlg: TSetBlocksDlg;

implementation

uses tcommon,DlgCommon,block1,subyr;

{$R *.DFM}

procedure TSetBlocksDlg.FormActivate(Sender: TObject);
begin
 label2.caption:=inttostr(XML_DISPLAY.Blocknum);
 edit1.text:=inttostr(XML_DISPLAY.Blocknum);
 label4.caption:=inttostr(XML_DISPLAY.blocklevel);
 edit2.text:=inttostr(XML_DISPLAY.blocklevel);
 label7.caption:=inttostr(levelprint)+')';
 edit1.setfocus;
end;

procedure TSetBlocksDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;


procedure TSetBlocksDlg.SetBtnClick(Sender: TObject);
var
 oldblocks,oldlevels:  integer;
 Nblock,Nlevel:        smallint;
 i,j:                  integer;
begin
 oldblocks:=XML_DISPLAY.Blocknum;
 oldlevels:=XML_DISPLAY.blocklevel;
 if InvalidEntry(Nblock,2,nmbrBlocks,'number of blocks',edit1) then exit;
 if InvalidEntry(Nlevel,1,levelprint,'number of levels',edit2) then exit;
 if (Nblock=oldblocks) and (Nlevel=oldlevels) then
  begin
   close;
   exit;
  end;
 if oldblocks<>Nblock then
   begin
     XML_DISPLAY.Blocknum:=Nblock;
     Lblock:=1; Hblock:=Nblock;
     if Nblock< nmbrBlocks then
       for i:=Nblock+1 to nmbrBlocks do
         begin
           fix[i]:=0;
           for j:=0 to nmbrLevels do
             Sheet[i,j]:=0;
         end;
   end;

 if oldlevels<>Nlevel then
   begin
     XML_DISPLAY.blocklevel:=Nlevel;
     if Nlevel< nmbrLevels then
       for i:=1 to nmbrBlocks do
         begin
          if Sheet[i,0]>XML_DISPLAY.blocklevel then
              Sheet[i,0]:=XML_DISPLAY.blocklevel;
          for j:=Nlevel+1 to nmbrLevels do
             Sheet[i,j]:=0;
         end;
   end;
 settop;
 updateBlockWindow;
 close;

end;

procedure TSetBlocksDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

end.
