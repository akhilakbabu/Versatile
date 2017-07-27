unit Addrcode;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, ExtCtrls, XML.TEACHERS;

type
  Taddrcodedlg = class(TForm)
    Finish: TBitBtn;
    Add: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    FacEdit1: TEdit;
    FacEdit2: TEdit;
    FacEdit3: TEdit;
    Label8: TLabel;
    Label3: TLabel;
    RadioGroup1: TRadioGroup;
    Edit4: TEdit;
    Label12: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FacEdit1Change(Sender: TObject);
    procedure FacEdit2Change(Sender: TObject);
    procedure FacEdit3Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
  private
    procedure Restore;
  end;

var
  addrcodedlg: Taddrcodedlg;

implementation
uses tcommon,DlgCommon, main,RoWnd;
{$R *.DFM}

var
 needUpdate:   bool;
 tmpType: integer;

procedure Taddrcodedlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if needUpdate then updateSub(2); {update room data files}
end;

procedure Taddrcodedlg.restore;
begin
 label8.caption:=inttostr(codeCount[2]);
 edit1.text:=''; edit2.text:='';
 edit3.text:='';  edit4.text:='';
 FacEdit1.text:='';
 FacEdit2.text:=''; FacEdit3.text:='';
 radiogroup1.ItemIndex:=0;  tmpType:=0;
 edit1.setfocus;
end;

procedure Taddrcodedlg.AddClick(Sender: TObject);
var
 codeStr:       string;
 codePlace:     integer;
 msg:   string;
 tmpStr:        string;
 i:             integer;
 tmpFacName:    array[1..3] of string[szFacName];
 tmpFac:        array[1..3] of smallint;
 tmpInt,tmpCode:        integer;
begin
 msg:=''; tmpCode:=0;
 if TooMany('room codes',codeCount[2],nmbrRooms) then exit;
 if NoCode(codeStr,edit1) then exit;
 if CodeUsed(codePlace,2,codeStr,edit1) then exit;
 if CodeZero(codeStr,edit1) then exit;
 tmpInt:=radiogroup1.ItemIndex;
 if tmpInt=1 then if WildSubNotFound(tmpCode,Edit4,Label12) then exit;
 if tmpInt=2 then if CodeNotFound(tmpCode,1,Edit4) then exit;
 if tmpInt=3 then if FacNotFound(tmpCode,Edit4) then exit;;

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
  end; {if}
 end;
 checkRoFaculty(tmpFac[1],tmpFac[2],tmpFac[3]);
 tmpInt:=IntFromEdit(edit3);
 if tmpInt<0 then
 begin
  ShowMsg('Room Capacity cannot be less than 0.',edit3);
  exit;
 end;
 {still here? then assign the new room to vars.}
 codePlace:=FindNextCode(2);
 XML_TEACHERS.tecode[codePlace,1]:=codestr;
 XML_TEACHERS.TeName[codePlace,1]:=trim(edit2.text);
 for i:=1 to 3 do XML_TEACHERS.Rfaculty[codePlace,i]:=tmpFac[i];
 XML_TEACHERS.Rosize[codePlace]:=tmpInt;
 Rotype[codePlace]:=tmpType;  Rassign[codePlace]:=tmpCode;
 needUpdate:=true;
 InsertCode(2,codePlace);

 tmpint:=mainform.canvas.textwidth(codestr);
 if tmpint>fwCode[2] then fwCode[2]:=tmpint;
 tmpstr:=trim(edit2.text);
 tmpint:=mainform.canvas.textwidth(tmpStr);
 if tmpint>fwCodename[2] then fwCodename[2]:=tmpint;

 RoWindow.UpdateWin;
 UpdateWindow(wnInfo);
 if winView[wnFac]>0 then UpdateWindow(wnFac);
 AlterTimeFlag:=True;  AlterWSflag:=true;
 UpdateTimeTableWins;
 restore;
end;

procedure Taddrcodedlg.FormActivate(Sender: TObject);
begin
 {init here}
 edit1.maxlength:=lencodes[2];
 edit2.maxlength:=szTeName; edit3.maxlength:=4; {9999 ???}
 FacEdit1.maxlength:=szFacName; FacEdit2.maxlength:=szFacName; FacEdit3.maxlength:=szFacName;
 needUpdate:=false;
 restore;
end;


procedure Taddrcodedlg.FacEdit1Change(Sender: TObject);
begin
 insertfaculty(FacEdit1);
end;

procedure Taddrcodedlg.FacEdit2Change(Sender: TObject);
begin
 insertfaculty(FacEdit2);
end;

procedure Taddrcodedlg.FacEdit3Change(Sender: TObject);
begin
 insertfaculty(FacEdit3);
end;


procedure Taddrcodedlg.FormCreate(Sender: TObject);
begin
 TopCentre(self);
end;

procedure Taddrcodedlg.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure Taddrcodedlg.RadioGroup1Click(Sender: TObject);
begin
 if (RadioGroup1.ItemIndex=3) then Edit4.Text:=FacEdit1.Text;
 tmpType:=radiogroup1.ItemIndex;
end;

procedure Taddrcodedlg.Edit4Change(Sender: TObject);
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
