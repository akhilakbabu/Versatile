unit sortgrp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, TimeChartGlobals, XML.TEACHERS, XML.STUDENTS;

type
  TSortGroupDlg = class(TForm)
    GroupBox1: TGroupBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    Select: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure SelectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  SortGroupDlg: TSortGroupDlg;

implementation
uses tcommon,tcommon2,StCommon;
{$R *.DFM}

procedure TSortGroupDlg.BitBtn1Click(Sender: TObject);
begin
 close;
end;


procedure SortGroup(ascending: bool);
var
i,j,L,swaps:        smallint;
aStr,bStr:          string;
g1,g2:              smallint;
aDbl,bDbl:          double;
error:              integer;

  procedure SwapGroupStudent;
  var
   a:       smallint;
  begin
   a:=StudSort[j];
   StudSort[j]:=StudSort[L];
   StudSort[l]:=a;
   inc(swaps);
  end; {local proc}

begin
 if XML_STUDENTS.numstud<2 then exit;
 try
  screen.cursor:=crHourglass;
  for i:=1 to XML_STUDENTS.numstud do StudSort[i]:=i;
  for i:=1 to (XML_STUDENTS.numstud-1) do
  begin
   swaps:=0;
   for j:=1 to (XML_STUDENTS.numstud-1) do
   begin
    L:=j+1;
    g1:=StudSort[L];  g2:=StudSort[j];
    case groupSort of
    0: begin  {year}
        aStr:=uppercase(trim(inttostr(XML_STUDENTS.Stud[g1].TcYear)));
        bStr:=uppercase(trim(inttostr(XML_STUDENTS.Stud[g2].TcYear)));
       end;
    1: begin  {name}
        // #198 - add the space into the sort so that it matches the initial name sort
        aStr:=uppercase(trim(XML_STUDENTS.Stud[g1].Stname)+' '+trim(XML_STUDENTS.Stud[g1].first));
        bStr:=uppercase(trim(XML_STUDENTS.Stud[g2].Stname)+' '+trim(XML_STUDENTS.Stud[g2].first));
       end;
    2: begin  {class}
        aStr:=uppercase(trim(ClassCode[XML_STUDENTS.Stud[g1].tcClass]));
        bStr:=uppercase(trim(ClassCode[XML_STUDENTS.Stud[g2].tcClass]));
       end;
    3: begin  {House}
        aStr:=uppercase(trim(HouseName[XML_STUDENTS.Stud[g1].House]));
        bStr:=uppercase(trim(HouseName[XML_STUDENTS.Stud[g2].House]));
       end;
    4: begin  {ID}
        aStr:=uppercase(trim(XML_STUDENTS.Stud[g1].ID));
        bStr:=uppercase(trim(XML_STUDENTS.Stud[g2].ID));
       end;
    6: begin   {tutor}
        aStr:=uppercase(trim(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[g1].tutor,0]));
        bStr:=uppercase(trim(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[g2].tutor,0]));
       end;
    7: begin   {room}
        aStr:=uppercase(trim(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[g1].home,1]));
        bStr:=uppercase(trim(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[g2].home,1]));
       end;
    end; {case}
    if groupsort=5 then
    begin
     val(XML_STUDENTS.Stud[g1].ID,aDbl,error);
     val(XML_STUDENTS.Stud[g2].ID,bDbl,error);
     if ascending then
     begin
      if aDbl<bDbl then SwapGroupStudent;
     end
     else
      begin
       if aDbl>bDbl then SwapGroupStudent;
      end;
    end
    else {not    groupsort=5}
     begin
      if ascending then
      begin
       if aStr<bStr then SwapGroupStudent;
      end
      else
       begin
        if aStr>bStr then SwapGroupStudent;
       end;
     end; {if groupsort=5}
     end; {for j}
     if swaps=0 then break;
    end; {for i}
   finally
    screen.cursor:=crDefault;
   end;

 REselectgroup;
 studentPointerSet;
 UpdateStudWins;
end;


procedure TSortGroupDlg.SelectClick(Sender: TObject);
begin
 groupsort:=radiogroup1.itemindex;
 sortgroup((radiogroup2.itemindex=0));
 sortChangeFlag:=true;
end;

procedure TSortGroupDlg.FormCreate(Sender: TObject);
begin
 radiogroup1.ItemIndex:=GroupSort;
end;

end.
