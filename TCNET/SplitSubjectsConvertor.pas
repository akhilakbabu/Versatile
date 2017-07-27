unit SplitSubjectsConvertor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TimeChartGlobals, ComCtrls, uAMGClassSubject, ExtCtrls;

type
  TFrmSplitSubjectConv = class(TForm)
    lsbSubject: TListBox;
    lsvSplit: TListView;
    pnlButtons: TPanel;
    btnClose: TButton;
    pnlPrompt: TPanel;
    lblSubjectCode: TLabel;
    lblSubjectSplits: TLabel;
    procedure FormShow(Sender: TObject);
    procedure DisplaySpliSubjects(Sender: TObject);
  private
    SplitList:   array [0..nmbrSubjects] of smallint;
    FClassSubjects: TAMGClassSubjects;
    procedure RefreshSubjects;
    procedure SplitListSet;
  public
    function RefreshClassSubjects: Boolean;
    property ClassSubjects: TAMGClassSubjects read FClassSubjects write FClassSubjects;
  end;

var
  FrmSplitSubjectConv: TFrmSplitSubjectConv;

implementation

uses
  TCommon;

{$R *.dfm}

{ TForm1 }

procedure TFrmSplitSubjectConv.SplitListSet;
//This routine is also in EdFac2
var
  i, j, count: Integer;
  a: string;
begin
 for i := 1 to CodeCount[0] do
  if Codepoint[i, 0] > 0 then
    SplitList[i] := Codepoint[i, 0];
 SplitList[0] := CodeCount[0];
 if CodeCount[0] = 0 then Exit;
 for i:=1 to CodeCount[0] - 1 do
 begin
   count := 0;
   if splitlist[i] = 0 then Continue;
   a := Copy(SubCode[splitlist[i]], 1, lencodes[0] - 1);
   for j := i + 1 to CodeCount[0] do
     if SplitList[j] > 0 then
       if a = Copy(SubCode[splitlist[j]], 1, lencodes[0] - 1) then
       begin
         Inc(count);
         SplitList[j]:=0;
       end; {if}
     if count > 0 then
       splitlist[i] := -splitlist[i]
     else
       splitlist[i] := 0;
 end; {i}
  j := 0;
  for i := 1 to codeCount[0] do
    if SplitList[i]<0 then
    begin
      Inc(j);
      SplitList[j] := SplitList[i];
    end;
  if j < codeCount[0] then
   for i := j + 1 to CodeCount[0] do SplitList[i]:=0;
  SplitList[0] := j;
end;

procedure TFrmSplitSubjectConv.DisplaySpliSubjects(Sender: TObject);
var
  lParentSub: string;
  i: Integer;
  lListItem: TListItem;
  lClassNum: Integer;
begin
  lsvSplit.Clear;
  lParentSub := Trim(StringReplace(lsbSubject.Items[lsbSubject.ItemIndex], '*', '', [rfReplaceAll, rfIgnoreCase]));
  lClassNum := 0;
  for i := 1 to CodeCount[0] do
    if lParentSub = Trim(Copy(SubCode[CodePoint[i, 0]], 1, LenCodes[0] -1))  then
    begin
      if lParentSub <> Trim(SubCode[CodePoint[i, 0]]) then
      begin
        Inc(lClassNum);
        lListItem := lsvSplit.Items.Add;
        lListItem.Caption := SubCode[CodePoint[i, 0]];
        lListItem.SubItems.Add(SubName[CodePoint[i, 0]]);
        lListItem.SubItems.Add(IntToStr(lClassNum));
      end;
    end;
end;

procedure TFrmSplitSubjectConv.FormShow(Sender: TObject);
begin
  RefreshSubjects;
  if lsbSubject.Count > 0 then
  begin
    lsbSubject.ItemIndex := 0;
    DisplaySpliSubjects(Self);
  end;
end;

function TFrmSplitSubjectConv.RefreshClassSubjects: Boolean;
var
  lClassSubject: TAMGClassSubject;
  lParentSub: string;
  i: Integer;
  j: Integer;
  lListItem: TListItem;
  lClassNum: Integer;
begin
  RefreshSubjects;
  FClassSubjects.Clear;
  for j := 0 to lsbSubject.Count - 1 do
  begin
    lParentSub := Trim(StringReplace(lsbSubject.Items[j], '*', '', [rfReplaceAll, rfIgnoreCase]));
    lClassNum := 0;
    for i := 1 to CodeCount[0] do
      if lParentSub = Trim(Copy(SubCode[CodePoint[i, 0]], 1, Length(lParentSub)) )then
      begin
        if lParentSub <> Trim(SubCode[CodePoint[i, 0]]) then
        begin
          lClassSubject := TAMGClassSubject.Create;
          Inc(lClassNum);
          lClassSubject.SubjectCode := lParentSub;
          lClassSubject.SplitSubjectCode := SubCode[CodePoint[i, 0]];
          lClassSubject.ClassNo := lClassNum;
          FClassSubjects.Add(lClassSubject);
        end;
      end;
  end;
end;

procedure TFrmSplitSubjectConv.RefreshSubjects;
var
  i: Integer;
begin
  SplitListSet;
  lsbSubject.Clear;
  for i := 1 to CodeCount[0] do
  begin
    //lsbSubject.Items.Add(WildSub(SplitList[i]));
    lsbSubject.Items.Add(subcode[codepoint[i,0]]);
  end;
end;

end.
