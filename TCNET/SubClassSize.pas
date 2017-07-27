unit SubClassSize;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,TimeChartGlobals, XML.DISPLAY;

type
  TSetSubSizeDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    ScrollBox1: TScrollBox;
    image1: TImage;
    AddBtn: TBitBtn;
    RemoveBtn: TBitBtn;
    Finish: TBitBtn;
    Label6: TLabel;
    DefaultBtn1: TBitBtn;
    Label7: TLabel;
    Edit3: TEdit;
    ClearBtn: TBitBtn;
    cboMaxClassSubject: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FindChoiceDetails(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure DefaultBtn1Click(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure restore;
    procedure setTabs;
    procedure ShowMaxSubs;
  end;

var
  SetSubSizeDlg: TSetSubSizeDlg;

implementation

{$R *.dfm}

uses StCommon,DlgCommon;

var
 Sub1,Ncols:  integer;
 Hmargin,txtheight:  integer;
 subwidth:   integer;
 Bitmap1:     Tbitmap;



procedure TSetSubSizeDlg.ShowMaxSubs;
var
 i,j,count:    integer;
 str:        string;
 x,y:        integer;

  procedure newline;
  begin
   x:=0; y:=y+txtHeight;
  end;

begin
 x:=0;  y:=txtHeight; count:=0;
 if SubStMaxPoint[0]>0 then
  for i:=1 to SubStMaxPoint[0] do
   begin
    j:=SubStMaxPoint[i];
    str:=trim(SubCode[j])+'-'+inttostr(SubStMax[j]);
    image1.canvas.textout(x+Hmargin,y,str);
    inc(count);
    x:=x+subwidth;
    if (count mod Ncols)=0 then newline;
   end;
end;

procedure TSetSubSizeDlg.restore;
begin
  Sub1 := 0;
  settabs;
  showMaxSubs;
  RemoveBtn.Enabled:=false;
  AddBtn.Enabled:=false;
  ClearBtn.Enabled := SubStMaxPoint[0]>0;
  //Edit1.text:='';
  cboMaxClassSubject.ItemIndex := -1;
  Edit2.Text := '';
  Label5.Caption := IntToStr(SubStMaxPoint[0]);
  //Edit1.setfocus;
  if cboMaxClassSubject.Visible and cboMaxClassSubject.Enabled then
    cboMaxClassSubject.SetFocus;
end;

procedure TSetSubSizeDlg.setTabs;
var
 maxH:           integer;
begin
 Ncols:=(scrollbox1.width-2*Hmargin) div subwidth;
 if Ncols<1 then Ncols:=1;
 maxH:=txtheight*((linknum div Ncols)+2);
 Bitmap1.width:= image1.width;
 Bitmap1.height:=maxH;
 Bitmap1.canvas.brush.color:=clSilver;
 Bitmap1.canvas.floodfill(0,0,clSilver,fsBorder);
 image1.Picture.Graphic:=Bitmap1;
 image1.canvas.brush.color:=clSilver;
 image1.canvas.pen.color:=clBlack;
 scrollbox1.VertScrollbar.Range:=maxH;
end;

procedure TSetSubSizeDlg.FormCreate(Sender: TObject);
begin
 Bitmap1:=Tbitmap.Create;
 Hmargin:=self.canvas.textwidth('AA');
 txtHeight:=self.canvas.textheight('A');
end;

procedure TSetSubSizeDlg.FormShow(Sender: TObject);
var
  j: Integer;
  curTab: Integer;
begin
  //Edit1.Maxlength:=lencodes[0];
  Edit3.Text := IntToStr(XML_DISPLAY.MaxClassSize);
  subwidth := 0;
  image1.canvas.font.Assign(XML_DISPLAY.tcfont);
  for j:=1 to GroupSubs[0] do
  begin
   curTab := canvas.textwidth(trim(SubCode[GroupSubs[j]]));
   if (curTab > subwidth) then
     subwidth := curTab;
  end;
  subwidth := subwidth + canvas.textwidth('-99  ');
  restore;
  for j := 1 to codeCount[0] do
    cboMaxClassSubject.Items.Add(subcode[codepoint[j, 0]]);
end;

procedure TSetSubSizeDlg.FindChoiceDetails(Sender: TObject);
begin
  //Sub1 := FindChoice(Edit1.Text, label3, True);
  Sub1 := FindChoice(cboMaxClassSubject.Text, label3, True);
  RemoveBtn.Enabled := (Sub1 > 0) and (SubStMaxPoint[0] > 0) and (SubStMax[Sub1] <> XML_DISPLAY.MaxClassSize);
  AddBtn.Enabled := (Sub1 > 0);
  if Sub1 > 0 then
    edit2.Text := Inttostr(GetClassMax(Sub1))
  else
    edit2.Text := '';
end;

procedure TSetSubSizeDlg.ClearBtnClick(Sender: TObject);
begin
 InitClassSizes;
 restore;
end;

procedure TSetSubSizeDlg.AddBtnClick(Sender: TObject);
var
 size1:   smallint;
begin
  if Sub1=0 then
  begin
    //ShowMsg('Enter subject to add',edit1);
    MessageDlg('Enter subject to add', mtError, [mbOK], 0);
    if cboMaxClassSubject.Visible and cboMaxClassSubject.Enabled then
    begin
      cboMaxClassSubject.SetFocus;
      cboMaxClassSubject.SelectAll;
    end;
    Exit;
  end;
  if InvalidEntry(size1,1,nmbrStudents,'maximum class size',edit2) then
    Exit;
  if GetClassMax(Sub1)=size1 then
  begin
    //ShowMsg(SubCode[Sub1]+' is already set to '+inttostr(size1),edit1);
    MessageDlg(SubCode[Sub1]+' is already set to ', mtError, [mbOK], 0);
    if cboMaxClassSubject.Visible and cboMaxClassSubject.Enabled then
    begin
      cboMaxClassSubject.SetFocus;
      cboMaxClassSubject.SelectAll;
    end;
    Exit;
  end;
  SubStMax[Sub1]:=size1;
  SetClassSizePoint;
  restore;
end;

procedure TSetSubSizeDlg.DefaultBtn1Click(Sender: TObject);
var
 size1: smallint;
begin
 if InvalidEntry(size1,1,nmbrStudents,'maximum class size',edit3) then exit;
 if size1=XML_DISPLAY.MaxClassSize then
  begin
   ShowMsg('Default maximum class size is already set to '+inttostr(size1),edit3);
   exit;
  end;
 SetDefaultClassSize(size1);
 restore;
end;

procedure TSetSubSizeDlg.RemoveBtnClick(Sender: TObject);
begin
  if Sub1 = 0 then
  begin
    //ShowMsg('Enter subject to remove',edit1);
    MessageDlg('Enter subject to remove', mtError, [mbOK], 0);
    if cboMaxClassSubject.Visible and cboMaxClassSubject.Enabled then
    begin
      cboMaxClassSubject.SetFocus;
      cboMaxClassSubject.SelectAll;
    end;
    Exit;
  end;
  if SubStMax[Sub1]=XML_DISPLAY.MaxClassSize then
  begin
    //ShowMsg('Subject is already removed',edit1);
    MessageDlg('Subject is already removed', mtError, [mbOK], 0);
    if cboMaxClassSubject.Visible and cboMaxClassSubject.Enabled then
    begin
      cboMaxClassSubject.SetFocus;
      cboMaxClassSubject.SelectAll;
    end;
    Exit;
  end;
  SubStMax[Sub1]:=XML_DISPLAY.MaxClassSize;
  SetClassSizePoint;
  restore;
end;

end.
