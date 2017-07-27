unit Edhouse;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, XML.UTILS;

type
  Tedhousedlg = class(TForm)
    Label7: TLabel;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure updateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  end;

var
  edhousedlg: Tedhousedlg;

procedure updateHouse;

implementation
uses tcommon,DlgCommon,HouseWnd,main;
{$R *.DFM}
var
  updateflag:               bool;

procedure updateHouse;
var
 i:       integer;
 f:         file;
begin
 try
  try
   doAssignFile(f,'HOUSE.DAT');
   rewrite(f,1);
   blockwrite(f,HouseCount,2);
   for i:=1 to HouseCount do
   begin
    HouseName[i]:=RpadString(HouseName[i],szHouseName);
    blockwrite(f,HouseName[i][1],szHouseName);
   end;
  finally
   closefile(f);
   FileAge('HOUSE.DAT',NEW_DateChecks[3]);
  end;
 except
 end;  
end;

procedure Tedhousedlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
 if updateflag then updatehouse;
end;

procedure Tedhousedlg.FormActivate(Sender: TObject);
var
 nm:      integer;
begin
 edit1.maxlength:=4;  {9999}
 edit2.maxlength:=szHouseName;
 updateflag:=false;
 label8.caption:=inttostr(HouseCount);
 nm:=HouseWindow.selcode;
 if (nm>0) and (nm<=HouseCount) then
 begin
  edit1.text:=inttostr(nm);
  label3.caption:=trim(HouseName[nm]);
  edit2.text:=trim(HouseName[nm]);
  edit2.setfocus;
 end
 else
  begin
   edit1.text:='';  edit2.text:='';
   label3.caption:='';
   edit1.setfocus;
  end;
end;

procedure Tedhousedlg.Edit1Change(Sender: TObject);
var
 nm:      integer;
begin
 nm:=IntFromEdit(edit1);
 if ((nm<=HouseCount) and (nm>0)) then
 begin
  label3.caption:=trim(HouseName[nm]);
  edit2.text:=trim(HouseName[nm]);
 end
 else
  begin
   edit2.text:='';     label3.caption:='';
  end;
end;

procedure Tedhousedlg.updateClick(Sender: TObject);
var
 i:       integer;
 a:  string;
 nm,v2:      smallint;
begin
 if InvalidEntry(nm,1,nmbrHouse,'house number',edit1) then exit;
 HouseName[nm]:=trim(edit2.text);
 v2:=0;
 if nm>HouseCount then HouseCount:=nm;
 for i:=1 to HouseCount do
 begin
  a:=uppercase(trim(HouseName[i]));
  if a>'' then v2:=i;
 end; {for i}
 HouseCount:=v2;
 if HouseWindow.selcode>HouseCount then HouseWindow.selcode:=0; {clear selection if necessary}
 label8.caption:=inttostr(HouseCount);
 updateflag:=true;
 fwHouse:=getHouseFontWidths(mainform.canvas);
 HouseWindow.UpdateWin;
 edit2.text:='';  label3.caption:=''; edit1.text:='';
 edit1.setfocus;
end;

procedure Tedhousedlg.FormCreate(Sender: TObject);
begin
 TopCentre(self);
end;

procedure Tedhousedlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

end.
