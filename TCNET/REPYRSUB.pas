unit Repyrsub;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, XML.STUDENTS;

type
  Trepysdlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    finish: TBitBtn;
    replace: TBitBtn;
    BitBtn3: TBitBtn;
    Label12: TLabel;
    Label13: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Add: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure finishClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure replaceClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function CheckEntries: boolean;
    procedure Restore;
  end;

var
  repysdlg: Trepysdlg;

implementation
uses tcommon,DlgCommon, stcommon, subyr,block1,tcommon2,tcommon5;

{$R *.DFM}
var
 needUpdate:                    bool;
 GSpos1,GSpos2: integer;
 GSsub1,GSsub2: integer;


procedure Trepysdlg.Restore;
begin
 GSpos1:=0; GSpos2:=0;
 GSsub1:=0; GSsub2:=0;
 edit1.text:=''; label5.caption:=''; label8.caption:='';
 edit2.Text:=''; label3.Caption:=''; label10.Caption:='';
 edit1.SetFocus;
end;


procedure Trepysdlg.FormActivate(Sender: TObject);
begin
 restore;
 if (subyearwin.selCode>0) then
  begin
   GSpos1:=SubYearDisp[subyearwin.selcode];
   GSsub1:=GroupSubs[GSpos1];
   edit1.text:=trim(SubCode[GSsub1]);
   edit1.SelectAll;
  end;
end;

procedure Trepysdlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
 if needUpdate then SaveAllStudentYears;
end;

procedure Trepysdlg.finishClick(Sender: TObject);
begin
 close;
end;

procedure Trepysdlg.Edit1Change(Sender: TObject);
var
 codeStr:       string;
begin
 codeStr:=trim(edit1.text);
 GSpos1:=0;
 GSsub1:=checkCode(0,codestr);
 label5.caption:='';  label8.caption:='';
 if GSsub1>0 then
  begin
   GSpos1:=findsubyear(GSsub1);
   if GSpos1>0 then
    begin
     label5.caption:=Subname[GSsub1];
     label8.caption:=inttostr(GroupSubCount[GSpos1]);
    end;
  end;
end;

procedure Trepysdlg.Edit2Change(Sender: TObject);
var
 codeStr:       string;
begin
 codeStr:=trim(edit2.text);
 GSpos2:=0;
 GSsub2:=checkCode(0,codestr);
 label3.caption:='';  label10.caption:='';
 if GSsub2>0 then
  begin
   GSpos2:=findsubyear(GSsub2);
   label3.caption:=Subname[GSsub2];
   label10.caption:=inttostr(GroupSubCount[GSpos2]);
  end;
end;


function Trepysdlg.CheckEntries: boolean;
var
 codeStr1,codeStr2:       string;
 codeName1,codeName2:      string;
begin
 result:=false;
 codeName1:=trim(label5.caption);
 codeStr1:=trim(edit1.text);
 codeName2:=trim(label3.caption);
 codeStr2:=trim(edit2.text);
 if NoCode(codeStr1,edit1) then exit;
 if NoCode(codeStr2,edit2) then exit;
 if CodeNotFound(GSsub1,0,edit1) then exit;
 if CodeNotFound(GSsub2,0,edit2) then exit;
 if GroupSubCount[GSpos1]=0 then
  begin
   ShowMsg('The subject '+Subcode[GSsub1]+' ('+Subname[GSsub1]+') has no '
          +'students from the current group enrolled in it.'+endline
          +'Please enter a different code.',edit1);
   exit;  {return to editing}
  end;
 if codeName2='Not Available' then
  begin
   ShowMsg('NA is used for "Not Available".',edit2);
   exit; {return to editing}
  end;
 if GSpos2<=0 then   {add it to group subs}
  if TooMany('group subject codes',GroupSubs[0],nmbrSubYear) then exit;
 result:=true;
end;


procedure Trepysdlg.replaceClick(Sender: TObject);
var
 i,j,k,m:        integer;
begin
 if not(checkEntries) then exit;
 needUpdate:=true;
 for i:=1 to groupnum do
  begin
   k:=StGroup[i];
// check to ensure user has rights to change year data
   if not(CheckUserYearPassAccess(XML_STUDENTS.Stud[k].tcYear)) then continue;
//skip studs for whose year user does not have access
   SaveStudFlag:=true;
   for j:=1 to chmax do
    if XML_STUDENTS.Stud[k].Choices[j]=GSsub1 then
     begin
      XML_STUDENTS.Stud[k].Choices[j]:=GSsub2;
      StudYearFlag[XML_STUDENTS.Stud[k].tcYear]:=true;
     end;
   if chmax>1 then
    for j:=1 to chmax-1 do
     for m:=j+1 to chmax do
      if XML_STUDENTS.Stud[k].Choices[j]>0 then
       if XML_STUDENTS.Stud[k].Choices[j]=XML_STUDENTS.Stud[k].Choices[m] then
        begin
         XML_STUDENTS.Stud[k].Choices[m]:=0; {clear choice duplicate}
         StudYearFlag[XML_STUDENTS.Stud[k].tcYear]:=true;
        end;
  end; {for i}
 UpdateStudCalcs;
 restore;
end;

procedure Trepysdlg.AddClick(Sender: TObject);
var
 i,j,k,m,n:        integer;
 doit:                      bool;
begin
 if not(checkEntries) then exit;
 needUpdate:=true;
 for i:=1 to groupnum do
  begin
   k:=StGroup[i];
   SaveStudFlag:=true;
// check to ensure user has rights to change year data
   if not(CheckUserYearPassAccess(XML_STUDENTS.Stud[k].tcYear)) then continue;
//skip studs for whose year user does not have access
   for j:=1 to chmax do
    begin
     if XML_STUDENTS.Stud[k].Choices[j]=GSsub1 then
      begin
       StudYearFlag[XML_STUDENTS.Stud[k].tcYear]:=true;
       doit:=true; n:=-1;
       for m:=1 to nmbrChoices do {need to allow for increase in chmax and recount at end}
        begin
         if XML_STUDENTS.Stud[k].Choices[m]=GSsub2 then
          begin
           doit:=false;
           break;
          end;
         if XML_STUDENTS.Stud[k].Choices[m]=0 then n:=m;
        end;
       if (doit and (n>0)) then    {need to insert it and found empty choice pos}
        begin
         XML_STUDENTS.Stud[k].Choices[n]:=GSsub2;
         StudYearFlag[XML_STUDENTS.Stud[k].tcYear]:=true;
        end;
      end;
    end; {for j}
   for j:=1 to nmbrChoices-1 do
    for m:=j+1 to nmbrChoices do
     if XML_STUDENTS.Stud[k].Choices[j]>0 then
      if XML_STUDENTS.Stud[k].Choices[j]=XML_STUDENTS.Stud[k].Choices[m] then
       begin
        XML_STUDENTS.Stud[k].Choices[m]:=0; {clear choice duplicate}
        StudYearFlag[XML_STUDENTS.Stud[k].tcYear]:=true;
       end;
  end; {for i}
 UpdateStudCalcs;
 restore;
end;

procedure Trepysdlg.FormCreate(Sender: TObject);
begin
 TopCentre(self);
 caption:='Replace Subject'+GroupCaption;
 edit1.maxlength:=lencodes[0];   edit2.maxlength:=lencodes[0];
 needUpdate:=false;
 label13.caption:=inttostr(GroupSubs[0]);
end;

end.
