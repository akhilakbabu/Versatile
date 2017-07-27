unit Edrcode;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, ExtCtrls, XML.TEACHERS;

type
  Tedrcodedlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtRoomCode: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    FacEdit1: TEdit;
    FacEdit2: TEdit;
    FacEdit3: TEdit;
    Edit7: TEdit;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    Label11: TLabel;
    Label3: TLabel;
    Label10: TLabel;
    RadioGroup1: TRadioGroup;
    Edit4: TEdit;
    Label12: TLabel;
    btnNextRoom: TButton;
    btnPreviousRoom: TButton;
    edtRoomName: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpdateRoom(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtRoomCodeChange(Sender: TObject);
    procedure FacEdit1Change(Sender: TObject);
    procedure FacEdit2Change(Sender: TObject);
    procedure FacEdit3Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure GoNext(Sender: TObject);
    procedure GoPrevious(Sender: TObject);
  private
    myRo: Integer;
    needUpdate: Boolean;
    FRoomNo: Integer;
    procedure Restore;
    procedure Restore1;
    procedure ShowRoom;
    procedure ChangeRoom(const pStatus: Integer);
  end;

var
  edrcodedlg: Tedrcodedlg;

implementation

uses
  tcommon,DlgCommon,main,RoWnd;

{$R *.DFM}

var
  tmpType: Integer;

procedure Tedrcodedlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
 if needUpdate then updateSub(2); {update room data files}
end;

procedure Tedrcodedlg.Restore;
begin
  edtRoomCode.Text := '';
  Restore1;
  if edtRoomCode.Visible and edtRoomCode.Enabled then
    edtRoomCode.SetFocus;
end;

procedure Tedrcodedlg.restore1;
begin
  edtRoomName.Clear;
  edit2.text:=''; edit3.text:=''; FacEdit1.text:='';
  FacEdit2.text:=''; FacEdit3.text:=''; edit7.text:='';
  edit4.Text:='';   radiogroup1.ItemIndex:=0;  tmpType:=0;
end;

procedure Tedrcodedlg.UpdateRoom(Sender: TObject);
var
 codeStr:       string;
 codeStrNEW:    string;
 msg:   string;
 tmpStr:        string;
 i:             integer;
 tmpFacName:    array[1..3] of string[szFacName];
 tmpFac:        array[1..3] of smallint;
 tmpInt,tmpCode:        integer;
begin
 msg:='';   tmpCode:=0;
 if NoCode(codeStr, edtRoomCode) then exit;
 if CodeNotFound(myRo,2, edtRoomCode) then exit;
 if NoNewCode(codeStrNew,edit7) then exit;
 if CodeAlreadyUsed(CodeStrNew,myRo,2,edit7) then exit;
 if CodeZero(codeStrNew,edit7) then exit;
 tmpInt:=radiogroup1.ItemIndex;
 if tmpInt=1 then if WildSubNotFound(tmpCode,Edit4,Label12) then exit;
 if tmpInt=2 then if CodeNotFound(tmpCode,1,Edit4) then exit;;
 if tmpInt=3 then if FacNotFound(tmpCode,Edit4) then exit;;

 tmpInt:=IntFromEdit(edit3);
 if tmpInt<0 then
  begin
   ShowMsg('Room capacity cannot be less than 0.',edit3);
   exit;
  end;

 tmpFacName[1]:=trim(FacEdit1.text);
 tmpFacName[2]:=trim(FacEdit2.text);
 tmpFacName[3]:=trim(FacEdit3.text);
 for i:=1 to 3 do
  begin
   tmpFac[i]:=CheckFaculty(tmpFacName[i]);
   if ((tmpFac[i]=0) and (tmpFacName[i]<>'')) then
    begin
     msg:='Check the faculty name entered for the '+nth[i]+' faculty.';
     messagedlg(msg,mtError,[mbOK],0);
     case i of
      1:FacEdit1.setfocus;
      2:FacEdit2.setfocus;
      3:FacEdit3.setfocus;
     end;
     exit;
    end;
  end;
 checkRoFaculty(tmpFac[1],tmpFac[2],tmpFac[3]);

 {still here? then assign the new room to vars.}
 XML_TEACHERS.Tecode[myRo,1]:=codestrNEW ;  {new code}
 tmpstr:=TrimRight(edit2.text);
 XML_TEACHERS.TeName[myRo,1]:=tmpStr;   {update name}
 for i:=1 to 3 do XML_TEACHERS.Rfaculty[myRo,i]:=tmpFac[i];
 XML_TEACHERS.Rosize[myRo]:=tmpInt;
 Rotype[myRo]:=tmpType;  Rassign[myRo]:=tmpCode;
 needUpdate:=true;
 sortCodes(2);

 getCodeFontWidths(2);
 RoWindow.UpdateWin;
 if winView[wnFac]>0 then UpdateWindow(wnFac);
 UpdateTimeTableWins;
  GoNext(nil);
end;

procedure Tedrcodedlg.ShowRoom;
var
 s:  string;
begin
 edtRoomName.Text := XML_TEACHERS.TeName[myRo,1];
 s:=XML_TEACHERS.tecode[myRo,1];
 edit7.text:=TrimRight(s);
 edit2.text:=trim(XML_TEACHERS.TeName[myRo,1]);
 checkRoFaculty(XML_TEACHERS.Rfaculty[myRo,1],XML_TEACHERS.Rfaculty[myRo,2],XML_TEACHERS.Rfaculty[myRo,3]);
 if XML_TEACHERS.Rfaculty[myRo,1]=-1 then FacEdit1.text:='*' else FacEdit1.text:=facName[XML_TEACHERS.Rfaculty[myRo,1]];
 FacEdit2.text:=facName[XML_TEACHERS.Rfaculty[myRo,2]];
 FacEdit3.text:=facName[XML_TEACHERS.Rfaculty[myRo,3]];
 str(XML_TEACHERS.Rosize[myRo],s);  edit3.text:=s;

 radiogroup1.ItemIndex:=Rotype[myRo]; edit4.Text:='';
 case Rotype[myRo] of
  1: edit4.text:=wildSub(Rassign[myRo]);
  2: edit4.text:=XML_TEACHERS.TeCode[Rassign[myRo],0];
  3: edit4.text:=FacName[Rassign[myRo]];
 end;
end;

procedure Tedrcodedlg.FormActivate(Sender: TObject);
var
 s:       string;
begin
 //init here
 edtRoomCode.MaxLength := lencodes[2]; edit7.maxlength:=lencodes[2];
 edit2.maxlength:=szTeName;
 edit3.maxlength:=5; FacEdit1.maxlength:=szFacName;
 FacEdit2.maxlength:=szFacName; FacEdit3.maxlength:=szFacName;
 needUpdate:=false;
 label10.caption:=inttostr(codeCount[2]);
 if RoWindow.selcode>0 then
 begin
  myRo:=codepoint[RoWindow.selcode,2];
  s:=XML_TEACHERS.tecode[myRo,1];
  FRoomNo := RoWindow.SelCode;
  edtRoomCode.Text := Trim(s);
  ShowRoom;
 end
 else Restore;
 if edtRoomCode.Visible and edtRoomCode.Enabled then
   edtRoomCode.SetFocus;
end;

procedure Tedrcodedlg.ChangeRoom(const pStatus: Integer);
var
  lCode: string;
begin
  case pStatus of
    1:        //  Next
    begin
      if FRoomNo < CodeCount[2] then
      begin
        Inc(FRoomNo);
        lCode := Trim(XML_TEACHERS.TeCode[CodePoint[FRoomNo, 2], 1]);
        //lCode := TeCode[myRo, 1];
        edtRoomCode.Text := lCode;
      end
      else
        Dec(FRoomNo);
    end;
    -1:  // Previous
    begin
      if myRo > 1 then
      begin
        Dec(FRoomNo);
        lCode := Trim(XML_TEACHERS.TeCode[CodePoint[FRoomNo, 2], 1]);
        //lCode := TeCode[myRo, 1];
        edtRoomCode.Text := lCode;
      end
      else
        Inc(FRoomNo);
    end;
  end;  // case
end;

procedure Tedrcodedlg.edtRoomCodeChange(Sender: TObject);
var
  codeStr: string;
begin
  codeStr := Trim(edtRoomCode.Text);
  myRo := checkcode(2, codeStr);
  if Trim(codeStr) <> '' then
  begin
    ShowRoom;
    btnNextRoom.Enabled := FRoomNo < CodeCount[2];
    btnPreviousRoom.Enabled := FRoomNo > 1;         //myRo > 1;
  end
  else
    restore1;
end;

procedure Tedrcodedlg.FacEdit1Change(Sender: TObject);
begin
 insertfaculty(FacEdit1);
end;

procedure Tedrcodedlg.FacEdit2Change(Sender: TObject);
begin
  insertfaculty(FacEdit2);
end;

procedure Tedrcodedlg.FacEdit3Change(Sender: TObject);
begin
  insertfaculty(FacEdit3);
end;

procedure Tedrcodedlg.FormCreate(Sender: TObject);
begin
  TopCentre(self);
end;

procedure Tedrcodedlg.GoNext(Sender: TObject);
begin
  ChangeRoom(1);
end;

procedure Tedrcodedlg.GoPrevious(Sender: TObject);
begin
  ChangeRoom(-1);
end;

procedure Tedrcodedlg.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  allowNumericInputOnly(key);
end;

procedure Tedrcodedlg.RadioGroup1Click(Sender: TObject);
begin
 if (RadioGroup1.ItemIndex=3) and (XML_TEACHERS.Rfaculty[myRo,1]>0) then   //use first set fac
  edit4.text:=FacName[XML_TEACHERS.Rfaculty[myRo,1]] else edit4.text:='';
 tmpType:=radiogroup1.ItemIndex;
end;

procedure Tedrcodedlg.Edit4Change(Sender: TObject);
var
 codeStr: string;
begin
 codeStr:=Edit4.Text;
 case tmpType of
  1: checkWildCode(codeStr,label12,true);
  2: findTe(codeStr,label12);
  3: insertfaculty(Edit4);
 end;
end;

end.
