unit Addscode;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals;

type
  Taddscodedlg = class(TForm)
    Add: TBitBtn;
    Finish: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label4: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    CheckBox1: TCheckBox;
    procedure AddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Restore;
  end;

var
  addscodedlg: Taddscodedlg;

implementation
uses SuWnd,tcommon,DlgCommon,main;

{$R *.DFM}

var
 needUpdate:   bool;


procedure Taddscodedlg.Restore;
begin
 Label4.Caption:=inttoStr(codeCount[0]);
 edit2.text:=''; edit3.text:=''; edit4.text:='';
 edit1.text:='';
 edit1.setfocus;
end;

procedure Taddscodedlg.AddClick(Sender: TObject);
var
 codeStr:       string;
 codePlace:     integer;
 tmpint:        integer;
begin
 if TooMany('subject codes',codeCount[0],nmbrSubjects) then exit;
 if NoCode(codeStr,edit1) then exit;
 if CodeUsed(codePlace,0,codeStr,edit1) then exit;
 if CodeZero(codeStr,edit1) then exit;
 codePlace:=FindNextCode(0);
 if uppercase(trim(codeStr))='NA' then subNA:=codeplace;

 Subcode[codePlace]:=codeStr;
 Subname[codePlace]:=trim(edit2.text);
 //---- mantis-1295
 if CheckBox1.Checked =true then
   SubWillCount[codePlace]:='Y'
 else
   SubWillCount[codePlace]:='N' ;
 //---- mantis-1295
 if NumSubRepCodes>0 then
  begin
   SubReportCode[codePlace]:=trim(edit3.text);
   SubReportName[codePlace]:=trim(edit4.text);
  end
 else
  begin
   SubReportCode[codePlace]:=Subcode[codePlace];
   SubReportName[codePlace]:=Subname[codePlace];
 //  SubReportWillCount[codePlace]:=SubWillCount[codePlace];
  end;

 link[codePlace]:=0;
 {update font widths if necessary}
 tmpint:=mainform.canvas.textwidth(codestr);
 if tmpint>fwCode[0] then fwCode[0]:=tmpint;
 if tmpint>fwCodeBlank[0]then fwCodeBlank[0]:=tmpint;
 tmpint:=mainform.canvas.textwidth(Subname[codePlace]);
 if tmpint>fwCodename[0] then fwCodename[0]:=tmpint;
 tmpint:=mainform.canvas.textwidth(SubReportCode[codePlace]);
 if tmpint>fwReportCode then fwReportCode:=tmpint;
 tmpint:=mainform.canvas.textwidth(SubReportName[codePlace]);
 if tmpint>fwReportName then fwReportName:=tmpint;

 if NumSubRepCodes>0 then NumSubRepCodes:=NumCodes[0];
 needUpdate:=true;
 InsertCode(0,codePlace);
 SuWindow.UpdateWin;
 UpdateWindow(wnInfo);
 AlterTimeFlag:=True;  AlterWSflag:=true;
 UpdateTimeTableWins;
 restore;

end;


procedure Taddscodedlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if needUpdate then updatesub(0);
end;

procedure Taddscodedlg.FormActivate(Sender: TObject);
begin
 edit1.maxlength:=lencodes[0];  edit2.maxlength:=snSize;
 edit3.maxlength:=LenSubRepCode;  edit4.maxlength:=LenSubRepName;
 needUpdate:=false;
 restore;
end;

procedure Taddscodedlg.Edit1Change(Sender: TObject);
var
s :string;
begin
 {change check here}
 s:=TrimRight(uppercase(edit1.text));
 if s='NA' then
 begin
  edit2.text:='Not Available';
  edit2.enabled:=false;
 end
 else
   edit2.enabled:=true;
end;

procedure Taddscodedlg.FormCreate(Sender: TObject);
begin
 TopCentre(self);
 if (NumSubRepCodes>0) then
  begin
   label5.visible:=true;
   label6.visible:=true;
   label7.visible:=true;
   edit3.visible:=true;
   edit4.visible:=true;
  end
 else
  begin
   label1.top:=label1.top+20;
   label2.top:=label2.top+20;
   edit1.top:=edit1.top+20;
   edit2.top:=edit2.top+20;
  end
end;

end.
