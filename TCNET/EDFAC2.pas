unit Edfac2;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, TimeChartGlobals, XML.UTILS,XML.DISPLAY;

type
  TEditFac2 = class(TForm)
    Label7: TLabel;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ListBox1: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    ListBox2: TListBox;
    EdFacSubSelect: TRadioGroup;
    UpBtn: TBitBtn;
    DnBtn: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure updateClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure EdFacSubSelectClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
  end;

var
  EditFac2: TEditFac2;

procedure updateFaculty;

implementation

uses
  tcommon, DlgCommon, tcommon2, FacWnd, main, SuWnd;

{$R *.DFM}

var
 tmpsel:             array [0..nmbrSubsInFaculty] of smallint;
 sublist,splitlist:  tpSubData;
 needUpdate:         bool;
 facsel:             smallint;

procedure SplitListSet;
var
 i,j,count: integer;
 a: string;
begin
 for i:=1 to codeCount[0] do
  splitlist[i]:=codepoint[i,0];
 splitlist[0]:=codeCount[0];
 if codeCount[0]=0 then exit;
 for i:=1 to codeCount[0]-1 do
  begin
   count:=0;
   if splitlist[i]=0 then continue;
   a:=copy(SubCode[splitlist[i]],1,lencodes[0]-1);
   for j:=i+1 to codeCount[0] do
    if splitlist[j]>0 then
     if a=copy(SubCode[splitlist[j]],1,lencodes[0]-1) then
      begin
       inc(count);
       splitlist[j]:=0;
      end; {if}
     if count>0 then splitlist[i]:=-splitlist[i] else splitlist[i]:=0;
  end; {i}
  j:=0;
  for i:=1 to codeCount[0] do
   if splitlist[i]<0 then
    begin
     inc(j); splitlist[j]:=splitlist[i];
    end;
  if j< codeCount[0] then
   for i:=j+1 to codeCount[0] do splitlist[i]:=0;
  splitlist[0]:=j;
end;

procedure SubListSet;
var
 i: integer;
begin
 case XML_DISPLAY.EdFacSubType of
 0: begin
     for i:=1 to codeCount[0] do
      sublist[i]:=codepoint[i,0];
     sublist[0]:=codeCount[0];
    end;
 1: begin
     for i:=1 to splitlist[0] do
      sublist[i]:=splitlist[i];
     sublist[0]:=splitlist[0];
    end;
 end; {case}
end;

procedure TEditFac2.BitBtn1Click(Sender: TObject);
begin
 MoveOffList(tmpSel,listbox2,label12);
end;

procedure TEditFac2.BitBtn2Click(Sender: TObject);
begin
 ClearList(tmpSel,listbox2,label12);
end;

procedure TEditFac2.BitBtn4Click(Sender: TObject);
var
 i:       integer;
begin
 if listbox1.items.count>0 then
  for i:=0 to (listbox1.items.count-1) do
   if listbox1.selected[i] then
    if listbox2.items.indexof(listbox1.items[i])=-1 then
     if tmpsel[0]<nmbrSubsInFaculty then
      begin
       listbox2.items.add(listbox1.items[i]);
       inc(tmpsel[0]); tmpsel[tmpsel[0]]:=sublist[i+1];
      end;
 label12.caption:=inttostr(listbox2.items.count);
end;

procedure TEditFac2.FormCreate(Sender: TObject);
var
 i:       integer;
 a:       string;
begin
 fillchar(tmpsel,sizeof(tmpsel),chr(0));
 fillchar(sublist,sizeof(sublist),chr(0));
 fillchar(splitlist,sizeof(splitlist),chr(0));
 listbox1.clear;   listbox2.clear;  label6.caption:='';
 EdFacSubSelect.ItemIndex:=XML_DISPLAY.EdFacSubType;
 SplitListSet;
 SubListSet;
 for i:=1 to sublist[0] do
  begin
   a:=wildSub(sublist[i]);
   listbox1.items.add(trim(a));
  end;
 label11.caption:=inttostr(listbox1.items.count);
end;

procedure TEditFac2.updateClick(Sender: TObject);
var
  i,j: Integer;
begin
  if InvalidEntry(FacSel,1,nmbrFaculty,'Faculty number',edit1) then exit;
  if TooMany('faculty subjects',tmpsel[0],nmbrSubsInFaculty) then exit;
  facName[FacSel]:=uppercase(trim(edit2.text));
  j:=0;
  for i:=1 to tmpsel[0] do
    if tmpsel[i]<>0 then
    begin
      Inc(j);
      facSubs[FacSel,j]:=tmpsel[i];   {get fac subs}
    end;
  for i:=j+1 to nmbrSubsInFaculty do
    facSubs[FacSel,i]:=0;     {blank out rest}
  facCount[FacSel]:=j; {update count after possible repack}
  if FacSel>facNum then facNum:=FacSel;
  j:=0;
  for i:=1 to facNum do if facName[i]>'' then j:=i;
  facNum:=j;     {update facNum}
  if (facNum=1) and (facName[1]='') then facNum:=0;
  if FacultyWindow.selcode>facNum then FacultyWindow.selcode:=0; {clear selection if necessary}
  label8.caption:=inttostr(facNum);
  needUpdate:=true;
  fwFaculty:=getFacultyFontWidths(mainform.canvas);
  FacultyWindow.UpdateWin;
  if Assigned(SuWindow) then
  begin
    SuWindow.Refresh;
    Application.ProcessMessages;
  end;

  edit1.text:=''; {clears dlg}
  edit1.setfocus;
end;

procedure TEditFac2.Edit1Change(Sender: TObject);
var
 fnm,i:     integer;
begin
 label6.caption:='';  {only do if faculty number is changed}
 fnm:=IntFromEdit(edit1);
 if fnm=FacSel then exit;
 FacSel:=fnm;
 if ((fnm<1) or (fnm>facNum)) then
  begin
   edit2.text:=''; label3.caption:='';
   listbox2.clear; tmpsel[0]:=0;
  end
 else
  begin
   edit2.text:=trim(facName[fnm]);
   label3.caption:=trim(facName[fnm]);
   listbox2.clear;
   for i:=1 to facCount[fnm] do
    begin
     tmpsel[i]:=facSubs[fnm,i];
     listbox2.items.add(WildSub(facSubs[fnm,i]));
    end;
   tmpsel[0]:=facCount[fnm];
  end;
 label12.caption:=inttostr(listbox2.items.count);
end;

procedure updateFaculty;
var
 i,j:       integer;
 f:         file;
 tmpStr:           string;
begin
 try
  try
   doAssignFile(f,'FACULTY.DAT');
   rewrite(f,1);  blockwrite(f,facNum,2);
   if facNum>0 then
    for i:=1 to facNum do
     begin
      tmpStr:=trim(facName[i])+endline;
      blockwrite(f,tmpStr[1],Length(tmpStr));
      tmpStr:=inttostr(facCount[i])+endline;
      blockwrite(f,tmpStr[1],Length(tmpStr));
      if facCount[i]>0 then
       for j:=1 to facCount[i] do
        begin
         tmpStr:=inttostr(facSubs[i,j])+endline;
         blockwrite(f,tmpStr[1],Length(tmpStr));
        end; {for j}
     end; {for i}
  finally
   closefile(f);
   FileAge('FACULTY.DAT',NEW_DateChecks[14]);
  end;
 except
 end;
end;

procedure TEditFac2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
 if needupdate then updateFaculty;
end;

procedure TEditFac2.FormActivate(Sender: TObject);
var
 i:      integer;
begin
 edit1.maxlength:=4;   {9999}
 edit2.maxlength:=szFacName;
 needupdate:=false; FacSel:=0;
 label8.caption:=inttostr(facNum);
 if FacultyWindow.selcode>0 then
  begin
   FacSel:=FacultyWindow.selcode;
   edit1.text:=inttostr(FacSel);
   label3.caption:=trim(facName[FacSel]);
   edit2.text:=trim(facName[FacSel]);
   listbox2.clear;
   for i:=1 to facCount[FacSel] do
    begin
     if facSubs[FacSel,i]>=0 then
      listbox2.items.add(trim(SubCode[facSubs[FacSel,i]]))
     else
      listbox2.items.add(copy(trim(SubCode[abs(facSubs[FacSel,i])]),1,lencodes[0]-1)+'*');
     tmpsel[i]:=facSubs[FacSel,i];
    end; {for i}
   tmpsel[0]:=facCount[FacSel];
  end
 else
  begin
   edit1.text:='';
   tmpsel[0]:=0;
   label3.caption:=''; edit2.text:='';
   listbox2.clear;
  end;
 label12.caption:=inttostr(listbox2.items.count);
 edit1.setfocus;
end;

procedure TEditFac2.ListBox1Click(Sender: TObject);
var
 tmp: string;
 i,j:   integer;
begin
 if listbox1.selcount>1 then
  label6.caption:='Multiple Selection'
 else
  begin
   j:=0;
   for i:=0 to listbox1.items.count-1 do
    if listbox1.selected[i] then begin j:=i; break; end;
   tmp:=trim(listbox1.items[j]);
   checkWildcode(tmp,label6,true);
  end;
end;

procedure TEditFac2.ListBox2Click(Sender: TObject);
var
 tmp: string;
 i,j:   integer;
begin
 if listbox2.selcount>1 then
  label6.caption:='Multiple Selection'
 else
  begin
   j:=0;
   for i:=0 to listbox2.items.count-1 do
    if listbox2.selected[i] then begin j:=i; break; end;
   tmp:=trim(listbox2.items[j]);
   checkWildcode(tmp,label6,true);
  end;
end;

procedure TEditFac2.EdFacSubSelectClick(Sender: TObject);
var
 i:   integer;
begin
 if EdFacSubSelect.ItemIndex=XML_DISPLAY.EdFacSubType then exit;
 XML_DISPLAY.EdFacSubType:=EdFacSubSelect.ItemIndex;
 SubListSet;
 listbox1.clear;
 for i:=1 to sublist[0] do listbox1.items.add(WildSub(sublist[i]));
 label11.caption:=inttostr(listbox1.items.count);
end;

procedure TEditFac2.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TEditFac2.UpBtnClick(Sender: TObject);
begin
 MoveUpList(tmpSel,ListBox2);
end;

procedure TEditFac2.DnBtnClick(Sender: TObject);
begin
 MoveDownList(tmpSel,ListBox2);
end;

end.
