unit Swapsub;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,Dialogs,Grids,TimeChartGlobals,XML.DISPLAY;

type
  TSwapSubDlg = class(TForm)
    Swap: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Finish: TBitBtn;
    Edit2: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure SwapClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Restore;
  end;

var
  SwapSubDlg: TSwapSubDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,block1,subyr;

var
  sub1,sub2,fromblock,toblock:  integer;
  yearpos1,yearpos2:       integer;
  sublevel1,sublevel2:     integer;


procedure TSwapSubDlg.Restore;
begin
 Sub1:=0; Sub2:=0; fromblock:=0; toblock:=0;
 Edit1.Text:=''; Edit2.Text:='';
 label3.caption:=''; label4.caption:='';
 label5.caption:='';
 Edit1.SetFocus;
end;

procedure TSwapSubDlg.FormActivate(Sender: TObject);
var
  SRect: TGridRect;
  i,j:   integer;
begin
 Edit1.Maxlength:=lencodes[0];
 Edit2.Maxlength:=lencodes[0];
 sub1:=0; sub2:=0;
 SRect:=BlockWin.StringGrid1.Selection;
 i:=SRect.Left+1; j:=SRect.Top;
 Restore;
 if (i>0) and (i<=XML_DISPLAY.blocknum) then
  if (j>0) and (j<=Sheet[i,0]) then
   begin
    Sub1:=Sheet[i,j];
    Edit1.Text:=Subcode[Sub1];
    fromblock:=i;
    label3.caption:='Block '+inttostr(i);
    label5.caption:=Subname[Sub1];
    Edit2.SetFocus;
   end;
end;

procedure TSwapSubDlg.Edit1Change(Sender: TObject);
var
 codeStr:       string;
 codePlace:     integer;
begin
 codeStr:=trim(edit1.text);
 codePlace:=checkCode(0,codestr);
 yearpos1:=findsubyear(codePlace);
 if yearpos1>0 then
  begin
   Sub1:=codePlace;
   label5.caption:=Subname[Sub1];
   fromblock:=findblock(Sub1,sublevel1);
   label3.caption:='Block '+inttostr(fromblock);
  end
 else
  begin
   Sub1:=0;
   label5.caption:='';
   fromblock:=0;
   label3.caption:='';
  end;
end;

procedure TSwapSubDlg.Edit2Change(Sender: TObject);
var
 codeStr:       string;
 codePlace:     integer;
begin
 codeStr:=trim(edit2.text);
 codePlace:=checkCode(0,codestr);
 yearpos2:=findsubyear(codePlace);
 if yearpos2>0 then
  begin
   Sub2:=codePlace;
   label5.caption:=Subname[Sub2];
   toblock:=findblock(Sub2,sublevel2);
   label4.caption:='Block '+inttostr(toblock);
  end
 else
  begin
   Sub2:=0;
   label5.caption:='';
   toblock:=0;
   label4.caption:='';
  end;
end;

procedure TSwapSubDlg.SwapClick(Sender: TObject);
begin
 if Sub1=0 then
  begin
   ShowMsg('Enter subject to swap',edit1);
   exit;
  end;
 if Sub2=0 then
  begin
   ShowMsg('Enter subject to swap',edit2);
   exit;
  end;
 if (fromblock>0) or (toblock>0) then
  begin
    if fromblock=0 then
      begin
        Blocktop[yearpos2]:=Sub2;
        Blocktop[yearpos1]:=0;
      end
    else
      Sheet[fromblock,sublevel1]:=Sub2;
    if toblock=0 then
      begin
        Blocktop[yearpos1]:=Sub1;
        Blocktop[yearpos2]:=0;
      end
    else
      Sheet[toblock,sublevel2]:=Sub1;
   end;
 restore;
 settop;
 updateBlockWindow;
 SaveBlockFlag:=True;
end;


procedure TSwapSubDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
end;

end.
