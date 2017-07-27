unit Splitsub;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs, ExtCtrls,TimeChartGlobals, GlobalToTcAndTcextra, XML.DISPLAY, XML.STUDENTS;

type
  TSplitSubDlg = class(TForm)
    SplitBtn: TBitBtn;
    HelpBtn: TBitBtn;
    CombineBtn: TBitBtn;
    Finish: TBitBtn;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    AllSubsCheck: TCheckBox;
    ResplitBtn: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure RadioButton1Click(Sender: TObject);
    procedure SplitBtnClick(Sender: TObject);
    procedure AllSubsCheckClick(Sender: TObject);
    procedure CombineBtnClick(Sender: TObject);
    procedure ResplitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure Restore;
    procedure GetSplits(splitpos: integer);
    procedure Join;
  end;

var
  SplitSubDlg: TSplitSubDlg;

implementation

{$R *.DFM}
uses
  tcommon,DlgCommon,stcommon,block1,subyr, uAMGClassSubject;

var
 Sub1:                 integer; {Sub1 - user input }
 splitSu,splitSuMaxSize:              integer;  {split subject}
 SpClassnum,clsize:      integer;  {number of splits and size of each split}
 split:  array[0..30] of integer;   {array of split subjects}
 joinflag,keepsub:    bool;
 vertblock:      integer;  {block number for vertical split}


procedure TSplitSubDlg.Restore;
begin
 Sub1:=0;
 if allsubscheck.checked=false then
  begin
   Edit1.Text:='';
   Label5.Caption:='';
   Edit2.Text:='';
  end
 else
  begin
   Label5.Caption:='all subjects selected';
   Edit2.Text:=inttostr(XML_DISPLAY.MaxClassSize);
  end;
 Edit1.SetFocus;
end;

procedure TSplitSubDlg.FormActivate(Sender: TObject);
begin
 if XML_DISPLAY.SplitDiff then RadioButton1.Checked:=True else RadioButton2.Checked:=True;
 Edit3.Text:=inttostr(Lblock);
 Edit4.Text:=inttostr(Hblock);
 Label7.Caption:=inttostr(Linknum);
 AllSubsCheck.Checked:=False;
 Restore;
end;


procedure TSplitSubDlg.Edit1Change(Sender: TObject);
var
 codeStr:       string;
 codePlace:     integer;
 splitpos:      integer;
begin
 if allsubscheck.checked then exit;
 codeStr:=trim(edit1.text);
 codePlace:=checkCode(0,codestr);
 splitpos:=findsubyear(codePlace);
 if splitpos>0 then
  begin
   Sub1:=codePlace;
   label5.caption:=Subname[Sub1]+'  '+inttostr(GroupSubCount[splitpos]);
   Edit2.Text:=inttostr(GetClassMax(Sub1));
  end
 else
  begin
   Sub1:=0;
   label5.caption:='';
   Edit2.Text:='';
  end;
end;

procedure TSplitSubDlg.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;


procedure TSplitSubDlg.RadioButton1Click(Sender: TObject);
begin
 XML_DISPLAY.SplitDiff:=RadioButton1.Checked;
end;


procedure vertsplit;
var
 k,i,i2,j,snum,fromblock,sublevel: integer;
 vcount:  integer;
begin
 k:=1;
 if not(keepsub) then
  for i:=1 to SpClassnum do
   begin
    snum:=GroupSubs[split[i]];
    fromblock:=findblock(snum,sublevel);
    if fromblock>0 then blockchange(snum,0);
   end;
 for i2:=1 to groupnum do
  begin
   i:=StGroup[i2];
   for j:=1 to chmax do
    if XML_STUDENTS.Stud[i].Choices[j]=splitSu then
     begin
      vcount:=0;
      while (GroupSubCount[split[k]]>=splitSuMaxSize) and (vcount<=SpClassnum) do
       begin
        inc(vcount);
        inc(k);
        if k>SpClassnum then k:=1;
       end;
      XML_STUDENTS.Stud[i].Choices[j]:=GroupSubs[split[k]];
      inc(GroupSubCount[split[k]]);
      SaveStudFlag:=true; saveBlockFlag:=true;
      StudYearFlag[XML_STUDENTS.Stud[i].tcYear]:=true;
      inc(k);  if k>SpClassnum then k:=1;
     end {if}
  end; {i2}
 if (vertblock>0) and not(keepsub) then
   if (levelprint-sheet[vertblock,0])>=SpClassnum then
     for i:=1 to SpClassnum do
       blockchange(GroupSubs[split[i]],vertblock);
end;

procedure TSplitSubDlg.GetSplits(splitpos: integer);
var
  splitnum:  integer; {number of students in split subject}
  count,i:         integer;
  Sub2:            string;
  place:           integer;
  changeflag:      bool;
  fromblock,sublevel:        integer;
  lSubjectCode: string;
label
 labela;
begin
 changeflag:=false;
 splitnum:=GroupSubCount[splitpos];
 SpClassnum:=(splitnum+splitSuMaxSize-1) div splitSuMaxSize;
 clsize:=1+(splitnum-1) div SpClassnum;
 if SpClassnum>20 then
  begin
   ShowMsg('Splitting '+SubCode[splitSu]+' will need '+inttostr(SpClassnum)+
          ' classes.'+endline+'The maximum number is 20',edit2);
   exit;
  end;
 count:=1;
 for i:=1 to SpClassnum do
  begin
   labela:
    Sub2:=SubCode[splitSu];
    lSubjectCode := Trim(Sub2);
    SetLength(Sub2,Length(Sub2)-1);
    Sub2:=Sub2+chr(64+count); inc(count);
    place:=checkGrSub(Sub2);
    if place=0 then
     begin
      newsub(Sub2,splitSu);
      changeflag:=true;
     end;
    if toomanysubs then break;
    // Add the split to class subject list
    if (place = 0) and Cases21Flag then
      PendingClassSubjects.AddClassSubject(lSubjectCode, Sub2);
    place:=checkGrSub(Sub2);
    split[i]:=place;
    if GroupSubCount[place]>0 then goto labela;
    blocktop[place]:=0;
  end; {for i}
 if toomanysubs then
  begin
   ShowMsg('Cannot create extra subject codes needed.',edit1);
   exit;
  end;
  if Cases21Flag then
  begin
    PendingClassSubjects.RemoveClassSubject(lSubjectCode);
  end;
 fromblock:=findblock(splitSu,sublevel);
 vertblock:=fromblock;
 if fromblock>0 then blockchange(splitSu,0);
 XrefGroupSubs;
 place:=GsubXref[SplitSu];
 GroupSubCount[place]:=0;
 blocktop[place]:=splitSu;
 if changeflag then CalculateClashmatrix;
end;


procedure TSplitSubDlg.SplitBtnClick(Sender: TObject);
var
 s:       String;
 splitall:     bool;
 startsub,endsub:  integer;
 a: smallint;
 SplitNeeded: boolean;
 splitpos:       integer;
begin
 toomanysubs:=false; keepsub:=false;
 splitall:=allsubscheck.checked;
 if (Sub1=0) and (splitall=false) then
  begin
   ShowMsg('Enter subject to split',edit1);
   exit;
  end;
 if InvalidEntry(a,1,nmbrStudents,'maximum class size',edit2) then exit;
 if not(blockrange(edit3,edit4)) then exit;
 if splitall then SetDefaultClassSize(a) else SubStMax[Sub1]:=a;
 clsize:=a; {just to initialise it}
 if splitall then
  begin
   startsub:=1; endsub:=GroupSubs[0];
  end
 else
  begin
   splitpos:=GsubXref[Sub1];
   startsub:=splitpos; endsub:=splitpos;
  end;
 SplitNeeded:=false;
 for splitpos:=startsub to endsub do
  if GroupSubCount[splitpos]>GetClassMax(GroupSubs[splitpos])
   then SplitNeeded:=true;
 if not(SplitNeeded) then
  begin
   ShowMsg('No split is needed for '+label5.caption,edit1);
   exit;
  end;
 //Do the splitting
 s:=label5.caption;
 splitpos:=startsub; BlFull:=false;
 while (splitpos<=endsub) and not(BlFull) do
  begin
   splitSu:=GroupSubs[splitpos];  splitSuMaxSize:=GetClassMax(splitSu);
   if GroupSubCount[splitpos]>splitSuMaxSize then
    begin
     getsplits(splitpos);
     if (SpClassnum>20) or toomanysubs then break;
     label5.caption:='Splitting '+SubCode[splitSu]+'...';
     label5.refresh;
     splitLinks(SplitSu,SpClassnum,split);
     if RadioButton1.Checked then horsplit(Splitsu,clsize,SpClassnum,split)
       else vertsplit;
      CalculateClashmatrix;
    end;
   inc(splitpos); if splitall then endsub:=GroupSubs[0];
  end; {while splitpos}
  // End splitting
 settop;
 UpdateAllWins; //want update of sub wins too!!!
 if (SpClassnum<=20) and not(toomanysubs) then restore else label5.caption:=s;
 if BlFull then messagedlg('Blocks are full',mtError,[mbOK],0);
 SaveStudFlag:=True; {or set during split}
 SaveBlockFlag:=True;
 BlockLoad:=3;
end;



procedure TSplitSubDlg.AllSubsCheckClick(Sender: TObject);
begin
 if allsubscheck.checked then
  begin
   label5.caption:= 'all subjects selected';
   Edit2.Text:=inttostr(XML_DISPLAY.MaxClassSize);
  end
 else Edit1Change(Self);
end;

procedure TSplitSubDlg.Join;
var
 i,i2,j,k,place:  integer;
 sub,sub2:       string;
 fromblock,sublevel,subnum: integer;
begin
 SpClassnum:=0;
 sub:=SubCode[splitSu];
 SetLength(sub,Length(sub)-1);
 for i:=1 to 26 do
  begin
   Sub2:=Sub+chr(64+i);
   place:=checkGrSub(Sub2);
   if (place>0) and (GroupSubCount[place]>0) then
    begin
     inc(SpClassnum);
     split[SpClassnum]:=place;
    end;
   if SpClassnum>=20 then break;
  end;
 if SpClassnum=0 then exit;
 joinflag:=true;
 label5.caption:='Combining '+ SubCode[GroupSubs[split[1]]]+ ' to '+
                  SubCode[GroupSubs[split[SpClassnum]]]+' ...';
 label5.refresh;
 for k:=1 to SpClassnum do
  begin
   GroupSubCount[split[k]]:=0;
   subnum:=GroupSubs[split[k]];
   if not(keepsub) then
    begin
     fromblock:=findblock(subnum,sublevel);
     if (fromblock>0) and (sublevel>fix[fromblock]) then blockchange(subnum,0);
    end;
  end; {k}
 for i2:=1 to groupnum do
  begin
   i:=StGroup[i2];
   for j:=1 to chmax do
    for k:=1 to SpClassnum do
     if XML_STUDENTS.Stud[i].Choices[j]=GroupSubs[split[k]] then
      begin
       XML_STUDENTS.Stud[i].Choices[j]:=splitSu;
       inc(GroupSubCount[GsubXref[splitSu]]);
       SaveStudFlag:=true; saveBlockFlag:=true;
       StudYearFlag[XML_STUDENTS.Stud[i].tcYear]:=true;       
       break;
      end;
  end;
end;

procedure TSplitSubDlg.CombineBtnClick(Sender: TObject);
var
 s1:       String;
 splitall:     bool;
 splitpos:     integer;

begin
 joinflag:=false; keepsub:=false;
 splitall:=allsubscheck.checked;
 if (Sub1=0) and (splitall=false) then
  begin
   ShowMsg('Enter subject to combine',edit1);
   exit;
  end;

 if splitall then
  for splitpos:=1 to GroupSubs[0] do
   begin
    splitSu:=GroupSubs[splitpos];
    s1:=SubCode[splitSu];
    s1:=s1[length(s1)];
    if (s1=' ') and (GroupSubCount[splitpos]=0) then join;
   end
 else
  begin
   splitSu:=Sub1;
   join;
  end;
 if joinflag then
  begin
   settop;
   CalculateClashmatrix;
   UpdateStudWins;
   restore;
   SaveStudFlag:=True;
   SaveBlockFlag:=True;
   BlockLoad:=3;
  end
 else
  begin
   ShowMsg('No split subjects to join',edit1);
   exit;
  end;
end;

procedure TSplitSubDlg.ResplitBtnClick(Sender: TObject);
var
 s1:       String;
 a:           smallint;
 splitall:     bool;
 splitpos:       integer;

 function sameblock: bool;
 var
  startblock,i,sublevel:  integer;
  same:          bool;
 begin
  same:=true;
  startblock:=findblock(GroupSubs[split[1]],sublevel);
  for i:=1 to SpClassnum do
   if startblock<>findblock(GroupSubs[split[i]],sublevel) then
    same:=false;
  result:=same;
 end;

begin
 joinflag:=false; keepsub:=true; BlFull:=false;
 splitall:=allsubscheck.checked;
 if (Sub1=0) and (splitall=false) then
  begin
   ShowMsg('Enter subject to re-split',edit1);
   exit;
  end;
 if InvalidEntry(a,1,nmbrStudents,'maximum class size',edit2) then exit;
 if splitall then SetDefaultClassSize(a) else SubStMax[Sub1]:=a;
 clsize:=1; {just to initialise it}
 if splitall then
  for splitpos:=1 to GroupSubs[0] do
   begin
    if BlFull then
     begin
      messagedlg('Blocks are full',mtError,[mbOK],0);
      exit;
     end;
    splitSu:=GroupSubs[splitpos];
    s1:=SubCode[splitSu];
    s1:=s1[length(s1)];
    if (s1=' ') and (GroupSubCount[splitpos]=0) then
     begin
      join;
      if SpClassnum>0 then
       begin
        label5.caption:='Splitting '+SubCode[splitSu]+'...';
        label5.refresh;
        CalculateClashmatrix;
        clsize:=1+(GroupSubCount[splitpos]-1) div SpClassnum;
        GroupSubCount[splitpos]:=0;
        splitLinks(SplitSu,SpClassnum,split);
        if sameblock then vertsplit else horsplit(Splitsu,clsize,SpClassnum,split);
        CalculateClashmatrix;
       end;
     end;
   end
 else
  begin
   splitpos:=GsubXref[Sub1];
   splitSu:=Sub1;
   join;
   if SpClassnum>0 then
    begin
     label5.caption:='Splitting '+SubCode[splitSu]+'...';
     label5.refresh;
     CalculateClashmatrix;
     clsize:=1+(GroupSubCount[splitpos]-1) div SpClassnum;
     GroupSubCount[splitpos]:=0;
     splitLinks(SplitSu,SpClassnum,split);
     if sameblock then vertsplit else horsplit(Splitsu,clsize,SpClassnum,split);
     CalculateClashmatrix;
     if BlFull then messagedlg('Blocks are full',mtError,[mbOK],0);
    end;
  end;
 if joinflag then
  begin
   settop;
   UpdateAllWins;
   restore;
   SaveStudFlag:=True;
   SaveBlockFlag:=True;
   BlockLoad:=3;
  end
 else ShowMsg('No split subjects to re-split',edit1);
end;

procedure TSplitSubDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 CountGroupSubs;
end;

procedure TSplitSubDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
 if needClashMatrixRecalc then CalculateClashmatrix;
end;

end.

