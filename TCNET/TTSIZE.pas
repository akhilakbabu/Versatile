unit Ttsize;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Dialogs, Controls, Buttons,
  StdCtrls, ExtCtrls, TimeChartGlobals,GlobalToTcAndTcextra;

type
  Tttsizedlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    RadioGroup1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  end;

var
  ttsizedlg: Tttsizedlg;

implementation

uses tcommon,TTundo, tcommon2;

{$R *.DFM}

var
 ttformat:  integer;


procedure Tttsizedlg.FormCreate(Sender: TObject);
var
 i:  integer;
begin
 ttformat:=ttmainformat mod 10;
 i:=0;
 case ttformat of
  1: i:=0;
  2: i:=1;
  4: i:=2;
  6: i:=3;
 end; {case}
 radiogroup1.itemindex:=i;
end;

procedure Tttsizedlg.OKBtnClick(Sender: TObject);
var
 newLevelMax,LevelsData: integer;
 msg: string;
begin
 case radiogroup1.itemindex of
  0: ttformat:=1;
  1: ttformat:=2;
  2: ttformat:=4;
  3: ttformat:=6;
 end; {case}
 if ttmainformat>10 then inc(ttformat,10);
 if ttformat<ttmainformat then
  begin
   LevelsData:=CalcLevelsOfData;
   newLevelMax:=CalcLevelMax(ttformat,years,days,periods);
   if newLevelMax<LevelsData then
    begin
     Msg:='Reducing the timetable size will lose some timetable entries.'
      +cr+'There is no Undo from this operation.  Continue?';
     if messagedlg(Msg,mtWarning,[mbyes,mbno],0)<>mrYes then exit;
    end;
  end;
 if ttformat<>ttmainformat then
  begin
   ConfigureTimetable(days,periods,years,ttformat);
   initTtUndoStack;
   UpdateAllWins;
  end;
 close;
end;

end.
