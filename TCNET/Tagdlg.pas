unit Tagdlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, XML.UTILS, XML.STUDENTS;

type
  TTagDialog = class(TForm)
    GroupBox1: TGroupBox;
    Finish: TBitBtn;
    EnterBtn: TBitBtn;
    HelpBtn: TBitBtn;
    TagEdit1: TLabeledEdit;
    UpDown1: TUpDown;
    CodeEdit1: TLabeledEdit;
    NameEdit1: TLabeledEdit;
    Label3: TLabel;
    Label4: TLabel;
    ListBox2: TListBox;
    ListBox1: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    Label7: TLabel;
    Label6: TLabel;
    btnEditTag: TButton;
    procedure FormCreate(Sender: TObject);
    procedure EnterBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure RefreshTag(Sender: TObject; Button: TUDBtnType);
    procedure RenameTag(Sender: TObject);
  private
    NeedUpdate: wordbool;
    procedure FillDlg;
  end;

var
  TagDialog: TTagDialog;

implementation

uses
  tcommon,TimeChartGlobals,dlgcommon,stcommon, EditTag;

var
 needStudUpdate: wordbool=false;
 tmpStug:       tpstudentdata;
 tmpOldTag: array [0..nmbrstudents] of word;
 myTag: smallint;

{$R *.dfm}

procedure updateTagfile;
var
 tagFile:  file;
 i,StrLen: smallint;
begin
 try
  try
   chdir(Directories.datadir);
   doAssignFile(tagFile,'TAG.DAT');
   rewrite(tagFile,1);
   i:=nmbrTags;
   blockwrite(tagFile,i,2);
   for i:=1 to nmbrTags do
    begin
     blockwrite(tagFile,TagCode[i][1],1);
     StrLen:=length(Tagname[i]);
     blockwrite(tagFile,StrLen,2);
     blockwrite(tagFile,Tagname[i][1],StrLen);
    end;
  finally
   CloseFile(tagFile);
  end;
 except
 end;
end;

procedure TTagDialog.FormCreate(Sender: TObject);
var
 i,j: smallint;
begin
 caption:='Set Tags for '+groupname;
 NeedUpdate := False;

 updown1.Max:=nmbrTags;
 CodeEdit1.MaxLength:=1;
 NameEdit1.MaxLength:=szTagname;
 Mytag:=1;
 listbox1.Clear; listbox2.clear;
 for i:=1 to groupnum do
  begin
   j:=StGroup[i];
   listbox1.items.add(XML_STUDENTS.Stud[j].stname+' '+XML_STUDENTS.Stud[j].first);
   tmpOldTag[j]:=XML_STUDENTS.Stud[j].tctag
  end;
 label6.Caption:=inttostr(listbox1.Count);
 FillDlg;
end;

procedure TTagDialog.RenameTag(Sender: TObject);
var
  lFrmEditTag: TFrmEditTag;
begin
  lFrmEditTag := TFrmEditTag.Create(Application);
  try
    lFrmEditTag.SelectedTag := myTag;
    lFrmEditTag.ShowModal;
    if not needupdate then
      NeedUpdate := lFrmEditTag.IsChanged;
      if NeedUpdate then
        FillDlg;
  finally
    FreeAndNil(lFrmEditTag);
  end;
end;

procedure TTagDialog.EnterBtnClick(Sender: TObject);
var
 strA: string;
 i,j: smallint;

  function SameTagCode: boolean;
  var
   j: integer;
  begin
   result:=false;
   for j:=1 to nmbrTags do
    if (strA=tagCode[j]) and (j<>myTag) then result:=true;
  end;

begin
 if myTag<=0 then exit;
 strA:=trim(Codeedit1.text);
 if strA>'' then
  begin   //update tag label
   if SameTagCode then
    begin
     messagedlg('This tag code is already used.',mtError,[mbOK],0);
     codeEdit1.setfocus; codeEdit1.SelectAll;
     exit;
    end;
   TagCode[myTag]:=strA;
   needupdate:=true;
  end;

 strA:=trim(NameEdit1.text);
 if strA>'' then
  begin   //update tag label
   Tagname[myTag]:=strA;
   needupdate:=true;
  end;

 for i:=1 to groupnum do
  begin
   j:=StGroup[i];
   if StudHasTag(j,myTag) then
    XML_STUDENTS.Stud[j].tctag:=(XML_STUDENTS.Stud[j].tctag xor (1 shl (myTag-1)));
  end;

 if listbox2.Count>0 then
  for i:=1 to listbox2.Count do
   begin
    j:=tmpstug[i];
    XML_STUDENTS.Stud[j].tctag:=(XML_STUDENTS.Stud[j].tctag or (1 shl (myTag-1)));
   end;

 for i:=1 to groupnum do
  begin
   j:=StGroup[i];
   if XML_STUDENTS.Stud[j].tctag<>tmpOldTag[j] then
    begin
     needStudUpdate:=true;
     StudYearFlag[XML_STUDENTS.Stud[j].TcYear]:=true;
     break;
    end;
  end;
 UpdateStudCalcs;
end;

procedure TTagDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if needupdate then updateTagfile;
 if needStudUpdate then
  try
   screen.cursor:=crHourglass;
   SaveAllStudentYears;
  finally
   screen.cursor:=crDefault;
  end; {try}
end;

procedure TTagDialog.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpStug,ListBox2);
end;

procedure TTagDialog.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpStug,ListBox2);
end;

procedure TTagDialog.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpStug,listbox2,label7);
end;

procedure TTagDialog.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpStug,listbox2,label7);
end;

procedure TTagDialog.BitBtn3Click(Sender: TObject);
begin
 MoveOnStudList(tmpStug,listbox1,listbox2,label7,true);
end;

procedure TTagDialog.BitBtn4Click(Sender: TObject);
begin
 FillStudList(tmpStug,listbox1,listbox2,label7,true);
end;

procedure TTagDialog.FillDlg;
var
 i,j: smallint;
begin
 listbox2.clear;
 if myTag<=0 then
  begin
   codeEdit1.Text:='';    codeEdit1.Hint:='';
   nameEdit1.Text:='';    nameEdit1.Hint:='';
   exit;
  end;
 codeEdit1.Text:=TagCode[myTag];
 codeEdit1.Hint:='Set code for tag '+inttostr(myTag);
 nameEdit1.Text:=TagName[myTag];
 nameEdit1.Hint:='Set name for tag '+inttostr(myTag);
 tmpStug[0]:=0;
 for i:=1 to groupnum do
  begin
   j:=StGroup[i];
   if StudHasTag(j,myTag) then
    begin
     listbox2.items.add(XML_STUDENTS.Stud[j].stname+' '+XML_STUDENTS.Stud[j].first);
     inc(tmpStug[0]); tmpStug[tmpStug[0]]:=j;
    end;
  end;
 label7.Caption:=inttostr(listbox2.Count);
end;

procedure TTagDialog.RefreshTag(Sender: TObject; Button: TUDBtnType);
var
 i: smallint;
begin
 i:=updown1.Position;
 if i=myTag then exit;
 myTag:=i;
 FillDlg;
end;

end.
