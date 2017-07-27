unit StudentClashes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NiceGrid, ExtCtrls,GlobalToTcAndTcextra, XML.DISPLAY, XML.STUDENTS;

type
  TFrmStudentClashes = class(TForm)
    grdStudentClashes: TNiceGrid;
    procedure FormShow(Sender: TObject);
  private
    FSubjectNo: Integer;
    function RefreshStudentCLashes: Boolean;
  public
    property SubjectNo: Integer read FSubjectNo write FSubjectNo;
  end;

var
  FrmStudentClashes: TFrmStudentClashes;

implementation

uses
  STCommon, TimeChartGlobals, TCommon;

{$R *.dfm}

procedure TFrmStudentClashes.FormShow(Sender: TObject);
var
 IntPoint:  tpIntPoint;
 lSubNo: Integer;
begin
  IntPoint := FNT(nd,np,ny,nl,0);
  lSubNo := IntPoint^;
  if lSubNo <= LabelBase then
  begin
    if ((lSubNo > 0) and (lSubNo <= nmbrsubjects)) then
    begin
      SubjectNo := lSubNo;
      RefreshStudentCLashes;
    end;
  end;
end;

function TFrmStudentClashes.RefreshStudentCLashes: Boolean;
var
 NameRect: Trect;
 x,y,j,su,p,k, l: Integer;
 invertflag: Boolean;
 lStr: string;

  i: Integer;
  lSubNo: Integer;
  lClashCount: Integer;
  lClashFound: Boolean;
begin
  lClashCount := 0;
  for i := 1 to XML_STUDENTS.NumStud do
    for j := 1 to chmax do
     if XML_STUDENTS.Stud[i].Choices[j] = FSubjectNo then
     begin
       //show name and original choices
       if HasStudentClash(i) then
       begin
         lClashFound := False;
         for l := 1 to XML_DISPLAY.BlockNum do
         begin
           lSubNo := BlClash[0, l];
           lStr := lStr + SubCode[lSubNo];// + ' ' + IntToStr(GroupSubCount[GsubXref[su]]);
           invertflag := False;
           for p := 1 to XML_DISPLAY.blocknum do
           begin
             if not(BlInvert[p]) then Continue;
             for k := 1 to Sheet[p, 0] do
               if FSubjectNo = Sheet[p, k] then
               begin
                 lClashFound := True;
                 if lClashFound then
                   Break;
               end;
           end;
         end;
         if lClashFound then
         begin
           grdStudentClashes.RowCount := lClashCount + 1;
           grdStudentClashes[0, lClashCount] := XML_STUDENTS.Stud[i].StName + ' ' + XML_STUDENTS.Stud[i].First;
           grdStudentClashes[1, lClashCount] := XML_STUDENTS.Stud[i].ID;
           grdStudentClashes[2, lClashCount] := lStr;
           Inc(lClashCount);
         end;
         Break;
       end;
     end;
end;

end.
