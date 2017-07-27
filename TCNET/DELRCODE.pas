unit Delrcode;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, XML.DISPLAY, XML.TEACHERS;

type
  Tdelrcodedlg = class(TForm)
    delete: TBitBtn;
    finish: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnNextRo: TButton;
    btnPreviousRo: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure deleteClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GoNext(Sender: TObject);
    procedure GoPrevious(Sender: TObject);
  private
    myRo: Integer;
    NeedUpdate: Boolean;
    FSelRoom: Integer;
    procedure ShowRoom;
    procedure Restore;
    procedure Restore1;
    procedure SetButtons;
  end;

var
  delrcodedlg: Tdelrcodedlg;

implementation

uses
  tcommon, tcommon2, DlgCommon, RoWnd;

{$R *.DFM}

procedure Tdelrcodedlg.FormClose(Sender: TObject;  var Action: TCloseAction);
begin
 action:=caFree;
 if needUpdate then updateSub(2); {update room data files}
end;

procedure Tdelrcodedlg.Restore;
begin
  label5.caption:=inttostr(codeCount[2]);

  myRo := CodePoint[FSelRoom, 2];

  if FSelRoom > 0 then
  begin
    Edit1.Text := Trim(XML_TEACHERS.TeCode[MyRo, 1]);
    Label3.Caption := XML_TEACHERS.TeName[MyRo, 1];
  end
  else
  begin
    Edit1.Text :='';
    Label3.Caption :='';
  end;
  SetButtons;
  Edit1.SetFocus;
end;

procedure Tdelrcodedlg.restore1;
begin
 label3.caption:='';
 label7.caption:=''; label9.caption:='';  label11.caption:='';
 label13.caption:='';
end;

procedure Tdelrcodedlg.SetButtons;
begin
  btnNextRo.Enabled := FSelRoom < CodeCount[2];
  btnPreviousRo.Enabled := FSelRoom > 1;
  Delete.Enabled := myRo > 0;
end;

procedure Tdelrcodedlg.showroom;
begin
 label3.caption:=XML_TEACHERS.TeName[myRo,1];
 checkRoFaculty(XML_TEACHERS.Rfaculty[myRo,1],XML_TEACHERS.Rfaculty[myRo,2],XML_TEACHERS.Rfaculty[myRo,3]);
 if XML_TEACHERS.Rfaculty[myRo,1]=-1 then label9.caption:='*' else label9.caption:=facName[XML_TEACHERS.Rfaculty[myRo,1]];
 label11.caption:=facName[XML_TEACHERS.Rfaculty[myRo,2]];
 label13.caption:=facName[XML_TEACHERS.Rfaculty[myRo,3]];
 label7.caption:=inttostr(XML_TEACHERS.Rosize[myRo]);
end;

procedure Tdelrcodedlg.FormActivate(Sender: TObject);
begin
  edit1.maxlength:=lencodes[2];
  needUpdate:=false;
  label5.caption:=inttostr(codeCount[2]);
  if (RoWindow.selcode > 0) then
    FSelRoom := RoWindow.selcode
  else
    FSelRoom := 0;
  if FSelRoom > 0 then
  begin
    myRo := codepoint[FSelRoom,2];
    Edit1.Text := TrimRight(XML_TEACHERS.tecode[myRo,1]);
    ShowRoom;
  end
  else
    Restore;
  edit1.setfocus;
end;

procedure Tdelrcodedlg.deleteClick(Sender: TObject);
var
  codeStr: string;
begin
  if NoCodesAvail(codeCount[2],'Room Codes') then exit;
  if NoCode(codeStr,edit1) then exit;
  if CodeNotFound(myRo,2,edit1) then exit;
  needUpdate:=true;
  XML_TEACHERS.TeCode[myRo,1]:=StringPad(lenCodes[2],48);
  XML_TEACHERS.TeName[myRo,1]:='';
  if (RoWindow.selcode=myRo) then RoWindow.selcode:=-1; {cancel selection}
  XML_TEACHERS.Rosize[myRo]:=0;
  XML_TEACHERS.Rfaculty[myRo,1]:=-1;  XML_TEACHERS.Rfaculty[myRo,2]:=0;
  XML_TEACHERS.Rfaculty[myRo,3]:=0;

  sortCodes(2);

  {update font widths if necessary}
  getCodeFontWidths(2);
  RoWindow.UpdateWin;
  UpdateWindow(wnInfo);

  rangeCheckCodeSels(XML_DISPLAY.RoTtSelection,2);
  rangeCheckCodeSels(XML_DISPLAY.ttprntselroomg,2);
  rangeCheckCodeSels(XML_DISPLAY.RoomsFreeSelection,2);
  if winView[wnFac]>0 then UpdateWindow(wnFac);
  UpdateTimeTableWins;
  if FSelRoom > CodeCount[2] then
    Dec(FSelRoom);
 Restore;
end;

procedure Tdelrcodedlg.Edit1Change(Sender: TObject);
var
 codeStr:       string;
begin
 codeStr:=TrimRight(edit1.text);
 myRo:=checkCode(2,codeStr);
 if myRo>0 then showroom else restore1;
end;

procedure Tdelrcodedlg.FormCreate(Sender: TObject);
begin
 TopCentre(self);
end;

procedure Tdelrcodedlg.GoNext(Sender: TObject);
begin
  if FSelRoom <= codeCount[2] then
  begin
    Inc(FSelRoom);
    Restore;
  end;
end;

procedure Tdelrcodedlg.GoPrevious(Sender: TObject);
begin
  Dec(FSelRoom);
  if FSelRoom < 1 then
    FSelRoom := 1;
  Restore;
end;

end.
