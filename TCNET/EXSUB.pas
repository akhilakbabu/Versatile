unit Exsub;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs, ExtCtrls,TimeChartGlobals, XML.DISPLAY;
type
  TExcludeSubDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    ScrollBox1: TScrollBox;
    image1: TImage;
    Finish: TBitBtn;
    AddBtn: TBitBtn;
    RemoveBtn: TBitBtn;
    ClearBtn: TBitBtn;
    SetBtn: TBitBtn;
    cboExcludeSubjectsSubject: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FindSubYearCode(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure AddBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure SetBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure SetExcludeTabs;
    procedure Restore;
  end;

var
  ExcludeSubDlg: TExcludeSubDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,block1,subyr;
var
 Sub1,Ncols:  integer;
 Hmargin1,txtheight1:  integer;
 subwidth:    integer;
 Bitmap1:     Tbitmap;

procedure TExcludeSubDlg.SetExcludeTabs;
var
 maxH:           integer;
begin
 Ncols:=(scrollbox1.width-2*Hmargin1) div subwidth;
 if Ncols<1 then Ncols:=1;
 maxH:=txtheight1*((excludenum div Ncols)+3);
 Bitmap1.width:= image1.width;
 Bitmap1.height:=maxH;
 Bitmap1.canvas.brush.color:=clSilver;
 Bitmap1.canvas.floodfill(0,0,clSilver,fsBorder);
 image1.Picture.Graphic:=Bitmap1;
 image1.canvas.brush.color:=clSilver;
 image1.canvas.pen.color:=clBlack;
 scrollbox1.VertScrollbar.Range:=maxH;
end;

procedure showExclude;
var
 i:    integer;
 x,y:        integer;
begin
 if excludenum=0 then exit;
 x:=0;  y:=txtHeight1;
 for i:=1 to excludenum do
   begin
    excludesubdlg.image1.canvas.textout(x+Hmargin1,y,SubCode[exclude[i]]);
    x:=x+subwidth;
    if (i mod Ncols)=0 then begin x:=0; y:=y+txtHeight1; end;
   end;
end;


procedure TExcludeSubDlg.Restore;
var
  j: Integer;
begin
  Sub1:=0;
  setexcludetabs;
  showexclude;
  if excludenum=0 then
  begin
    RemoveBtn.Enabled:=false;
    ClearBtn.Enabled:=False;
  end
  else
  begin
    RemoveBtn.Enabled:=true;
    ClearBtn.Enabled:=true;
  end;
  //Edit1.text:='';
  cboExcludeSubjectsSubject.Clear;
  Label5.caption:=inttostr(excludenum);
  //Edit1.setfocus;
  if cboExcludeSubjectsSubject.Visible and cboExcludeSubjectsSubject.Enabled then
    cboExcludeSubjectsSubject.SetFocus;
  for j := 1 to codeCount[0] do
    cboExcludeSubjectsSubject.Items.Add(subcode[codepoint[j, 0]]);
end;

procedure TExcludeSubDlg.FormCreate(Sender: TObject);
begin
 Bitmap1:=Tbitmap.Create;
 Hmargin1:=self.canvas.textwidth('AA');
 txtHeight1:=self.canvas.textheight('A');
end;

procedure TExcludeSubDlg.FormShow(Sender: TObject);
var
  j,curTab: Integer;
begin
  //Edit1.Maxlength := lencodes[0];
  Edit2.Maxlength := 4;
  subwidth := 0;
  ExcludeSubDlg.image1.canvas.font:=ExcludeSubDlg.font;
  for j := 1 to GroupSubs[0] do
  begin
  curTab := ExcludeSubDlg.canvas.textwidth(trim(SubCode[GroupSubs[j]]));
  if (curTab > subwidth) then
    subwidth := curTab;
  end;
  subwidth := subwidth + ExcludeSubDlg.canvas.textwidth('  ');
  excludeSubDlg.Edit2.text := IntToStr(XML_DISPLAY.ExcludeClassSize);
  restore;
end;

procedure TExcludeSubDlg.FindSubYearCode(Sender: TObject);
var
  codeStr: string;
  codePlace,yearpos: Integer;
begin
  {change check here}
  //codeStr := Trim(edit1.text);
  codeStr := Trim(cboExcludeSubjectsSubject.Text);
  codePlace:=checkCode(0, codestr);
  yearpos:=findSubyear(codePlace);
  if yearpos > 0 then
  begin
    Sub1 := codePlace;
    label3.caption := Subname[Sub1] + '  ' + IntToStr(GroupSubCount[yearpos]);
  end
  else
  begin
    Sub1 := 0;
    label3.caption := '';
  end;
end;

procedure TExcludeSubDlg.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TExcludeSubDlg.AddBtnClick(Sender: TObject);
var
 j:   integer;
 alreadyGot:   bool;
begin
  if Sub1=0 then
  begin
    //ShowMsg('Enter subject to exclude',edit1);
    MessageDlg('Enter subject to exclude', mtError, [mbOK], 0);
    if cboExcludeSubjectsSubject.Visible and cboExcludeSubjectsSubject.Enabled then
    begin
      cboExcludeSubjectsSubject.SetFocus;
      cboExcludeSubjectsSubject.SelectAll;
    end;
    Exit;
  end;
  alreadyGot:=false;
  if excludenum>0 then
    for j:=1 to excludenum do
      if exclude[j]=Sub1 then alreadyGot:=true;
  if alreadyGot then
  begin
    //ShowMsg(SubCode[Sub1]+' is already excluded',edit1);
    MessageDlg(SubCode[Sub1] + ' is already excluded', mtError, [mbOK], 0);
    if cboExcludeSubjectsSubject.Visible and cboExcludeSubjectsSubject.Enabled then
    begin
      cboExcludeSubjectsSubject.SetFocus;
      cboExcludeSubjectsSubject.SelectAll;
    end;
    Exit;
  end;
  Inc(Excludenum);
  Exclude[excludenum] := Sub1;
  Restore;
end;

procedure TExcludeSubDlg.RemoveBtnClick(Sender: TObject);
var
  locate,j: Integer;
  alreadyGot: bool;
begin
  if Sub1 = 0 then
  begin
    //ShowMsg('Enter subject to remove',edit1);
    MessageDlg('Enter subject to remove', mtError, [mbOK], 0);
    if cboExcludeSubjectsSubject.Visible and cboExcludeSubjectsSubject.Enabled then
    begin
      cboExcludeSubjectsSubject.SetFocus;
      cboExcludeSubjectsSubject.SelectAll;
    end;
    Exit;
  end;
  alreadyGot := false;
  locate := 0;
  if excludenum > 0 then
    for j := 1 to excludenum do
      if exclude[j] = Sub1 then
      begin
        alreadyGot := True;
        locate := j;
        Break;
      end;
  if not(alreadyGot) then
  begin
    //ShowMsg(SubCode[Sub1]+' is not excluded',edit1);
    MessageDlg(SubCode[Sub1] + ' is not excluded', mtError, [mbOK], 0);
    if cboExcludeSubjectsSubject.Visible and cboExcludeSubjectsSubject.Enabled then
    begin
      cboExcludeSubjectsSubject.SetFocus;
      cboExcludeSubjectsSubject.SelectAll;
    end;
    Exit;
  end;
  Exclude[locate] := 0;
  if locate < excludenum then
    for j:=locate to excludenum-1 do
      swapint(exclude[j],exclude[j + 1]);
  Dec(Excludenum);
  Restore;
end;

procedure TExcludeSubDlg.ClearBtnClick(Sender: TObject);
var
 j: integer;
begin
 for j:=1 to excludenum do
  exclude[j]:=0;
 excludenum:=0;
 restore;
end;

procedure TExcludeSubDlg.SetBtnClick(Sender: TObject);
var
 j,a:       integer;
begin
 a:=IntFromEdit(edit2);
 if (a<1) or (a>nmbrStudents) then
  begin
   ShowMsg('Minimum Class size is outside range (1-'+inttostr(nmbrStudents)+')',edit2);
   exit;
  end;
 XML_DISPLAY.ExcludeClassSize:=a;
 for j:=1 to nmbrSubYear do
  exclude[j]:=0;
 excludenum:=0;
 for j:=1 to GroupSubs[0] do
  if GroupSubCount[j]>=XML_DISPLAY.ExcludeClassSize then
   begin
    inc(excludenum);
    exclude[excludenum]:=GroupSubs[j];
   end;
 restore;
end;

procedure TExcludeSubDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Bitmap1.Free;
 action:=cafree;
end;

end.


