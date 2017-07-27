unit Segregat;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs,TimeChartGlobals, XML.STUDENTS;

type
  TSegregateDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Finish: TBitBtn;
    SegregateBtn: TBitBtn;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure SegregateBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure restore;
  end;

var
  SegregateDlg: TSegregateDlg;

implementation

{$R *.DFM}
uses tcommon,stcommon,DlgCommon,block1,subyr;
var
 Sub1,yearpos1,sub2,yearpos2:  integer;

procedure TSegregateDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
end;

procedure TSegregateDlg.restore;
begin
 Sub1:=0; yearpos1:=0;
 Sub2:=0; yearpos2:=0;
 Edit1.text:=''; Label3.caption:='(Enter Subject)';
 Edit2.text:=''; Label4.caption:='(Enter Subject)';
end;

procedure TSegregateDlg.FormActivate(Sender: TObject);
begin
 restore;
end;

procedure TSegregateDlg.Edit1Change(Sender: TObject);
var
 codeStr:       string;
 codePlace:     integer;
begin
 {change check here}
 codeStr:=trim(edit1.text);
 codePlace:=checkCode(0,codestr);
 yearpos1:=findsubyear(codePlace);
 if yearpos1>0 then
  begin
   Sub1:=codePlace;
   label3.caption:=Subname[Sub1]+'  '+inttostr(GroupSubCount[yearpos1]);
  end
 else
  begin
   Sub1:=0;
   label3.caption:='(Enter Subject)';
  end;
end;

procedure TSegregateDlg.Edit2Change(Sender: TObject);
var
 codeStr:       string;
 codePlace:     integer;
begin
 {change check here}
 codeStr:=trim(edit2.text);
 codePlace:=checkCode(0,codestr);
 yearpos2:=findsubyear(codePlace);
 if yearpos2>0 then
  begin
   Sub2:=codePlace;
   label4.caption:=Subname[Sub2]+'  '+inttostr(GroupSubCount[yearpos2]);
  end
 else
  begin
   Sub2:=0;
   label4.caption:='(Enter Subject)';
  end;

end;

procedure TSegregateDlg.SegregateBtnClick(Sender: TObject);
var
 i,i1,j:  integer;
 doneswap:  bool;
begin
 doneswap:=false;
 if Sub1=0 then
  begin
   ShowMsg('Enter subject for '+genderLong[0]{Males'},edit1);
   exit;
  end;
 if Sub2=0 then
  begin
   ShowMsg('Enter subject for '+genderLong[1]{Females'},edit2);
   exit;
  end;
 if Sub1=Sub2 then
  begin
   ShowMsg('Both subject codes are the same',edit1);
   exit;
  end;
 for i1:=1 to groupnum do
  begin
   i:=StGroup[i1];
   for j:=1 to chmax do
    begin
     if (XML_STUDENTS.Stud[i].sex=genderShort[1]{'F'}) and (XML_STUDENTS.Stud[i].choices[j]=Sub1) then
      begin
       XML_STUDENTS.Stud[i].choices[j]:=Sub2;
       SaveStudFlag:=true;  SaveBlockFlag:=true;
       StudYearFlag[XML_STUDENTS.Stud[i].tcYear]:=true;
       SaveStudFlag:=True; SaveBlockFlag:=True; doneswap:=true;
       dec(GroupSubCount[yearpos1]);
       inc(GroupSubCount[yearpos2]);
      end;
     if (XML_STUDENTS.Stud[i].sex=genderShort[0]{'M'}) and (XML_STUDENTS.Stud[i].choices[j]=Sub2) then
      begin
       XML_STUDENTS.Stud[i].choices[j]:=Sub1;
       SaveStudFlag:=True; SaveBlockFlag:=True; doneswap:=true;
       StudYearFlag[XML_STUDENTS.Stud[i].tcYear]:=true;
       dec(GroupSubCount[yearpos2]);
       inc(GroupSubCount[yearpos1]);
      end;
    end;  {j}
  end; {i1}
 if doneswap then
  begin
   CalculateClashmatrix;
   UpdateStudWins;
   BlockLoad:=3;
  end;
 restore;
end;

procedure TSegregateDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 CountGroupSubs;
end;

end.

