unit Ttgoto;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls,
  Buttons, StdCtrls, ExtCtrls, Dialogs, Grids, TimeChartGlobals,GlobalToTcAndTcextra;

type
  TGotoDlg = class(TForm)
    GotoBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    HomeBox: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure GotoBtnClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
  end;

var
  GotoDlg: TGotoDlg;

implementation

{$R *.DFM}
uses tcommon,TTundo,DlgCommon,Tcommon2,ttable;

var
 fd,fp,fy,fl:       smallint;


procedure TGotoDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
 HomeBox.checked:=false;
 FillComboYears(false,ComboBox1);
 FillComboDays(false,ComboBox2);
 FillComboTimeSlots(false,nd,combobox3);
end;

procedure TGotoDlg.FormActivate(Sender: TObject);
begin
 label1.caption:='&'+Yeartitle;
 Combobox1.text:=yearname[ny];
 Edit2.text:=inttostr(nl);
 combobox2.text:=Day[nd];
 combobox3.ItemIndex:=np;
 fd:=nd; fp:=np; fy:=ny; fl:=nl;
 combobox2.Setfocus;
 combobox2.SelectAll;
end;

procedure TGotoDlg.Edit2Change(Sender: TObject);
var
 lev:  integer;
begin
 fl:=IntFromEdit(edit2);
 if fy>=0 then lev:=level[fy] else lev:=level[ny];
 if (fl<1) or (fl>lev) then
  label12.Caption:='Enter Level (1-'+inttostr(lev)+')'
 else
  label12.Caption:='Level '+inttostr(fl);
end;

procedure TGotoDlg.GotoBtnClick(Sender: TObject);
var
 CurRow,CurCol: integer;
 Srect: TGridRect;
begin
 if BadDayCombo(fd,ComboBox2) then exit;
 if BadTimeCombo(fp,fd,comboBox3) then exit;
 if BadComboYear(fy,ComboBox1) then exit;
 if BadLevel(fl,fy,edit2) then exit;
 ny:=fy; nl:=fl; nd:=fd; np:=fp;
 if Homebox.checked then
  begin
   PushHome;
   hy:=ny; hl:=nl; hd:=nd; hp:=np;
  end;
 CurRow:=FindRow(ny,nl);
 CurCol:=FindCol(nd,np);
 Srect.top:=CurRow; Srect.bottom:=CurRow;
 Srect.left:=CurCol; Srect.right:=CurCol;
 Ttablewin.StringGrid1.selection:=Srect;
 BringintoView;
 close;
end;

procedure TGotoDlg.ComboBox1Change(Sender: TObject);
begin
 fy:=findYearname(ComboBox1.text,label12);
end;

procedure TGotoDlg.ComboBox2Change(Sender: TObject);
begin
 if ChangeDayCombo(fd,Combobox2,combobox3) then ComboBox3Change(Sender);
 fd:=findDayMsg(combobox2.text,label12);
end;

procedure TGotoDlg.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TGotoDlg.ComboBox3Change(Sender: TObject);
begin
 ChangeTimeCombo(fp,combobox3,label12);
end;

procedure TGotoDlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3.SelectAll;
end;

end.
