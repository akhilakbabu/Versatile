unit Codelen;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, XML.TEACHERS;

type
  Tcodelendlg = class(TForm)
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure updateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    function CodeLengths:bool;
  end;

var
  codelendlg: Tcodelendlg;

implementation

uses
  tcommon, DlgCommon, SuWnd, TeWnd, RoWnd, StrUtils;

procedure checkCodelengths; forward;

{$R *.DFM}

var
 old_lenCodes:  integer;
 Tsub:          array[0..nmbrSubjects] of string[szSubCode];
 codeDouble:    bool;
 Code,szCode:   integer;

function Tcodelendlg.CodeLengths:bool;
var
 i: integer;
 cl: smallint;
 A:     string;
 tmpfile:       file;
 tmpfilename:   string;
begin
 result:=false;
 old_lencodes:=lencodes[code];
 if BadLength(cl,2,szCode,edit1) then exit;
 lencodes[code]:=cl;
 checkcodelengths;
 if codeDouble then lencodes[code]:=old_lencodes;
 if old_lencodes=lencodes[code] then exit;
 result:=true;
 if code=0 then tmpfilename:='SUBCODE.DAT';
 if code=1 then tmpfilename:='TECODE.DAT';
 if code=2 then tmpfilename:='ROOMS.DAT';
 if numCodes[code]>0 then
 begin
  if old_lencodes<lencodes[code] then
  begin
   A:=space(lencodes[code]-old_lencodes);
   if code=0 then
    for i:=1 to numcodes[code] do
     SubCode[i]:=SubCode[i]+A;
   if code>0 then
    for i:=1 to numcodes[code] do
     XML_TEACHERS.TeCode[i,code-1]:=XML_TEACHERS.TeCode[i,code-1]+A;
  end
   else
    begin
     if code=0 then
      for i:=1 to numcodes[code] do
       SubCode[i]:=copy(SubCode[i],1,lencodes[code]);
     if code>0 then
      for i:=1 to numcodes[code] do
       XML_TEACHERS.TeCode[i,code-1]:=copy(XML_TEACHERS.TeCode[i,code-1],1,lencodes[code]);
    end; {else}
 end; {if numcodes[code]>0}
 if usrPassLevel<>utGen then
 try
  try
   assignfile(tmpfile,tmpfilename);
   rewrite(tmpfile,1);
   blockwrite(tmpfile,numcodes[code],2);
   blockwrite(tmpfile,lencodes[code],2);
   if numcodes[code]>0 then
    for i:=1 to numcodes[code] do
    begin
     A:=FNsub(i,code);
     A:=RpadString(A,lencodes[code]);
     blockwrite(tmpfile,A[1],lencodes[code]);
    end;
  finally
   closefile(tmpfile);
  end;
 except
 end;
end;

procedure sortcodes(code: integer);
var
 D,H,I,J,L:     integer;
 tmpstr: string;
label lab1,lab2,lab3;
begin
 D:=1;
 lab1:
 D:=D+D;
 if D<codeCount[code] then goto lab1;
 lab3:
 D:=(D-1) div 2;
 if D=0 then exit;
 H:=codeCount[code]-D;
 for I:=1 to H do
 begin
  J:=I;
  lab2:
  L:=J+D;
  if (Tsub[L]<Tsub[j]) then
  begin
   tmpstr:=Tsub[L]; Tsub[L]:=Tsub[J];
   Tsub[J]:=tmpstr;
   J:=J-D;
   if J>0 then goto lab2;
  end;
 end; {next}
 goto lab3;
end;

procedure checkCodelengths;
var
  i,j:     integer;
  A:     string;
  lDuplicateCode: string;
begin
  codeDouble := False;
  if lencodes[code] >= old_lencodes then
    Exit;
  for i := 1 to codeCount[code] do
  begin
  A := FNsub(codepoint[i, code], code);
  Tsub[i] := Copy(A, 1, lencodes[code]);
  end;
  sortcodes(Code);
  for i := 1 to (codeCount[code]-1) do
    for j := (i+1) to codeCount[code] do
    begin
      if ((i<>j) and (Tsub[i] = Tsub[j])) then
      begin
        lDuplicateCode := Tsub[i];
        codedouble := True;
        Break;
      end;
      if (Tsub[j] > Tsub[i]) then
        Break;
    end; {for j}
  if codedouble then
  begin
    ReductionMsg(codename[code],codelendlg.Edit1, lDuplicateCode);
    codelendlg.Edit1.Text := IntToStr(old_LenCodes);
    Exit;
  end;
end;

procedure Tcodelendlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure Tcodelendlg.FormActivate(Sender: TObject);
begin
 code:=tag-2;
 old_lencodes:=lencodes[code];
 codeDouble:=false;
 if code=0 then
  begin
   label4.Visible:=true; Edit2.Visible:=true;
   Edit2.Text:=inttostr(snsize);
   szCode:=szSubCode
  end
 else szCode:=szTeCode;
 edit1.text:=inttostr(lencodes[code]);
 label2.caption:=inttostr(lencodes[code]);
 codelendlg.caption:=codenameCap[code]+' code lengths';
 case code of
  0: HelpContext:=135;
  1: HelpContext:=142;
  2: HelpContext:=148;
 end;
 edit1.setfocus;
end;

procedure Tcodelendlg.updateClick(Sender: TObject);
var
 i,namelen: smallint;
begin
  if (Code=0) then
  begin
    try
      namelen:=StrToInt(Edit2.Text);
    except
      namelen:=snsize; //25
    end;
  end;

 if code=0 then
  if BadLength(namelen,szSubnameDefault,szSubnameMax,edit2) then exit;
 if codelengths or ((old_lencodes <> lencodes[code]) and not(codedouble)) or ((Code=0) and (namelen <> snsize)) then
 begin
   getCodeFontWidths(code);
   case code of
    0: begin
        snsize:=namelen;
        if NumCodes[0]>0 then
         for i:=1 to NumCodes[0] do Subname[i]:=LeftStr(Subname[i],snsize);
        if wnflag[wnSucode] then SuWindow.UpdateWin;
       end;
    1: if wnflag[wnTecode] then TeWindow.updatewin;
    2: if wnflag[wnRocode] then RoWindow.UpdateWin;
   end; {case}
   AlterTimeFlag:=True;  AlterWSflag:=true;
   UpdateAllWins;
   close;
   updatesub(code);
 end; {if ok}
end;

procedure Tcodelendlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
end;

procedure Tcodelendlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

end.
