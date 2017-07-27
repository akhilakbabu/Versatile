unit Subbsdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,TimeChartGlobals, XML.DISPLAY;

type
  TSubjectBySubjectDlg = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label5: TLabel;
    GroupBox3: TGroupBox;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox3: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    finish: TBitBtn;
    add: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure finishClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure addClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure myEdit3Change(Sender: TObject);
    procedure myEdit3Enter(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
  Private
    procedure SetRadioButtons;
  end;

  function CheckYearSub(codeStr: string): smallint;

var
  SubjectBySubjectDlg: TSubjectBySubjectDlg;

implementation

uses
  tcommon, DlgCommon, Subbysub;

var
 usingResources:                boolean;
 edit3:           array[1..nmbrOfGroupSubjects] of tedit;
 suberror: smallint;
{$R *.DFM}

procedure TSubjectBySubjectDlg.myEdit3Change(Sender: TObject);
var
 j:       integer;
 tmp:       string;
begin
 j:=activecontrol.tag;
 if j=0 then exit;
 tmp:=edit3[j].text;
 checkwildyearsub(uppercase(Trim(edit3[j].text)),label7,true);
end;

function CheckYearSub(codeStr: string): smallint;
var
 foundpos,foundyearpos:     smallint;
begin
 suberror:=2;  foundyearpos:=0;
 codeStr:=trim(codeStr); 
 foundpos:=checkcode(0,codestr);
 result:=foundpos;
 if foundpos>0 then suberror:=1;
 if (foundpos>0) and (GroupSubs[0]>0) then foundyearpos:=findsubyear(foundpos);
 if foundyearpos<>0 then suberror:=0;
end;


procedure TSubjectBySubjectDlg.myEdit3Enter(Sender: TObject);
var
 i:  integer;
begin
 i:=activecontrol.tag;
 if i=0 then exit;
 myEdit3Change(self);
 edit3[i].selectall;
end;

procedure TSubjectBySubjectDlg.SetRadioButtons;
var
 i:       integer;
 SubGroupSet: boolean;
begin
 for i:=1 to nmbrOFgroupsubjects do edit3[i].color:=clwindow;
 edit1.color:=clwindow;  edit2.color:=clwindow;
 combobox3.color:=clwindow;
 SubGroupSet:=radiobutton3.checked;
 radiobutton4.enabled:=SubGroupSet;  radiobutton5.enabled:=SubGroupSet;
 radiobutton6.enabled:=SubGroupSet;
 for i:=1 to nmbrOfgroupSubjects do
  if SubGroupSet then edit3[i].color:=clRelevantControlOnDlg;

 if radiobutton1.checked  then
  begin
   edit1.color:=clRelevantControlOnDlg;  edit2.color:=clRelevantControlOnDlg;
  end;
 if radiobutton2.checked then edit1.color:=clRelevantControlOnDlg;
 if radiobutton8.checked then combobox3.color:=clRelevantControlOnDlg;
end;

procedure TSubjectBySubjectDlg.FormCreate(Sender: TObject);
var
 i,v1,v2:       integer;
const
 xgap=6;
 ygap=5;
begin
 caption:='Subject List Selection - '+GroupName;
 label2.Caption:='';  label6.Caption:=''; label7.Caption:='';
 for i:=1 to nmbrOfGroupSubjects do
  begin
   edit3[i]:=tedit.create(application);
   edit3[i].tag:=i;
   edit3[i].maxlength:=Lencodes[0];
   edit3[i].width:=95;
   edit3[i].parent:=groupbox1;
   edit3[i].text:='';
   if i=1 then
    begin
     edit3[1].left:=label5.left+label5.width+xgap;
     edit3[1].top:=label5.top+ygap;
    end
   else
    begin
     v1:=i mod 3;  v2:=(i-1) div 3;
     if v1=0 then v1:=2 else v1:=v1-1;
     edit3[i].left:=edit3[1].left+v1*(edit3[1].width+xgap);
     edit3[i].top:=edit3[1].top+v2*(edit3[1].height+ygap);
    end;
   edit3[i].onChange:=myEdit3Change;
   edit3[i].onEnter:=myEdit3Enter;
  end;    {for i}
 usingResources:=true;
 FillComboFaculty(false,combobox3);
end;

procedure TSubjectBySubjectDlg.finishClick(Sender: TObject);
begin
 close;
end;

procedure TSubjectBySubjectDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 i:       integer;
begin
 action:=caFree;
 if usingResources then   {can call close even after closeed it seems}
  begin
   usingResources:=false;
   hide; {prevent seeing controls beeing removed -slows things down a lot}
   for i:=1 to nmbrOfGroupSubjects do edit3[i].free;
  end;
end;

procedure TSubjectBySubjectDlg.RadioButton1Click(Sender: TObject);
begin
 SetRadioButtons;
end;

procedure TSubjectBySubjectDlg.FormActivate(Sender: TObject);
var
 i:       integer;
begin
 checkbox1.checked:=XML_DISPLAY.fgsubBySubListZeroSkip;
 case XML_DISPLAY.SubListType of
  1: radiobutton7.checked:=true;
  2: radiobutton1.checked:=true;
  3: radiobutton2.checked:=true;
  4: radiobutton8.checked:=true;
  5: radiobutton3.checked:=true;
 end; {case}
 case XML_DISPLAY.SubListGroupType of
  1: radiobutton4.checked:=true;
  2: radiobutton5.checked:=true;
  3: radiobutton6.checked:=true;
 end; {case}

 if XML_DISPLAY.sublistRanges[-2]>0 then edit1.text:=trim(SubCode[XML_DISPLAY.sublistRanges[-2]])
  else edit1.text:='';
 if copy(edit1.text,1,2)='00' then edit1.text:='';
 if XML_DISPLAY.sublistRanges[-1]>0 then edit2.text:=trim(SubCode[XML_DISPLAY.sublistRanges[-1]])
  else edit2.text:='';
 if copy(edit2.text,1,2)='00' then edit2.text:='';
 for i:=1 to nmbrofgroupsubjects do edit3[i].Text:=wildSub(XML_DISPLAY.sublistRanges[i]);

 for i:=1 to nmbrofgroupsubjects do
  if copy(edit3[i].text,1,2)='00' then edit3[i].text:='';
 if XML_DISPLAY.sublistfacnum>0 then combobox3.text:=facname[XML_DISPLAY.sublistfacnum] else combobox3.text:='';

 SetRadioButtons;
end;

procedure TSubjectBySubjectDlg.addClick(Sender: TObject);
var
 i,j:        integer;
 msg:          string;
 tmpR:         array[-2..nmbrofgroupsubjects] of integer;
 tmpF,tmpT,tmpG,suberror1:         integer;
begin
 XML_DISPLAY.fgsubBySubListZeroSkip:=checkbox1.checked;
 tmpT:=1; tmpG:=1;
 if radiobutton7.checked then tmpT:=1
  else if radiobutton1.checked then tmpT:=2
   else if radiobutton2.checked then tmpT:=3
    else if radiobutton8.checked then tmpT:=4
     else if radiobutton3.checked then
       begin
        tmpT:=5;
        if radiobutton4.checked then tmpG:=1
         else if radiobutton5.checked then tmpG:=2
          else if radiobutton6.checked then tmpG:=3;
       end;
 {check sub codes entered}
 for i:=-2 to nmbrofGroupSubjects do tmpR[i]:=0;

 suberror:=0;
 if trim(edit1.text)='' then suberror:=3
  else tmpR[-2]:=checkyearsub(uppercase(trim(edit1.text)));
 suberror1:=suberror;

 if trim(edit2.text)='' then tmpR[-1]:=0
  else tmpR[-1]:=checkyearsub(uppercase(trim(edit2.text)));
 if (suberror>0) and (suberror1=0) then tmpR[-1]:=tmpR[-2];

 if trim(combobox3.text)='' then tmpF:=0
  else tmpF:=checkfaculty(uppercase(trim(combobox3.text)));
 for j:=1 to nmbrOfGroupSubjects do
  if trim(edit3[j].text)<>'' then
   tmpR[j]:=checkwildyearsub(uppercase(trim(edit3[j].text)),label7,false);

 case tmpT of
  1: ;  {none needed}
  2,3: begin
        msg:='';
        if suberror1>0 then
         begin
          case suberror1 of
           1: msg:='No students in '+subcode[tmpR[-2]];
           2: msg:='Not a valid Subject Code';
           3: msg:='Please enter a Subject Code';
          end;
          ShowMsg(msg,edit1);
          exit;
         end;
       end;
  4: begin
      if tmpF=0 then
      begin
       ComboMsg('Check Faculty.',Combobox3);
       exit;
      end;
     end;
  5: begin
      for j:=1 to nmbrOfGroupSubjects do
       if trim(edit3[j].text)<>'' then
        if tmpR[j]=0 then
         begin
          ShowMsg('Not a valid Subject Code.',edit3[j]);
          exit;
         end;
     end;

 end; {case}
 if (tmpT=5) then
 begin
  j:=0;
  for i:=1 to nmbrofGroupSubjects do
   if tmpR[i]<>0 then inc(j);
  if j=0 then
   begin
    ShowMsg('No subjects entered.',edit3[1]);
    exit;
   end;
 end;

 {still here -so entered codes ok}
 XML_DISPLAY.SubListType:=tmpT;
 XML_DISPLAY.SubListGroupType:=tmpG;
 for i:=-2 to -1 do XML_DISPLAY.sublistRanges[i]:=tmpR[i];
 if XML_DISPLAY.SubListType=2 then
 begin
  if XML_DISPLAY.sublistranges[-1]=0 then XML_DISPLAY.sublistranges[-1]:=XML_DISPLAY.sublistranges[-2];
  if GsubXref[XML_DISPLAY.sublistranges[-2]]>GsubXref[XML_DISPLAY.sublistranges[-1]] then swapint(XML_DISPLAY.sublistranges[-2],XML_DISPLAY.sublistranges[-1]);
 end;
 XML_DISPLAY.sublistRanges[0]:=0;
 for i:=1 to nmbrofGroupSubjects do
  if tmpR[i]<>0 then
   begin
    inc(XML_DISPLAY.sublistRanges[0]);
    if tmpR[i]<0 then XML_DISPLAY.sublistRanges[XML_DISPLAY.sublistRanges[0]]:=tmpR[i]
    else XML_DISPLAY.sublistRanges[XML_DISPLAY.sublistRanges[0]]:=tmpR[i];
   end;
 if XML_DISPLAY.sublistranges[0]<nmbrofGroupSubjects then
  for i:=XML_DISPLAY.sublistranges[0]+1 to nmbrofGroupSubjects do
   XML_DISPLAY.sublistranges[i]:=0;
 XML_DISPLAY.sublistfacnum:=tmpF;
 close;
 SubBySubjectWin.updatewin;
end;

procedure TSubjectBySubjectDlg.Edit1Change(Sender: TObject);
begin
 findChoice(edit1.text,label2,true);
end;

procedure TSubjectBySubjectDlg.Edit2Change(Sender: TObject);
begin
 findChoice(edit2.text,label2,true);
end;




procedure TSubjectBySubjectDlg.Edit1Enter(Sender: TObject);
begin
 Edit1Change(self);
 edit1.selectall;
end;

procedure TSubjectBySubjectDlg.Edit2Enter(Sender: TObject);
begin
 Edit2Change(self);
 edit2.selectall;
end;

procedure TSubjectBySubjectDlg.ComboBox3Change(Sender: TObject);
var
 i,j,k:       integer;
 t:         string;
begin
 i:=checkfaculty(combobox3.text);
 if i>0 then
  begin
   t:='';
   for j:=1 to facCount[i] do
    begin
     k:=facsubs[i,j];
     if k>0 then t:=t+SubCode[k]+' '
      else t:=t+copy(SubCode[abs(k)],1,lencodes[0]-1)+'* ';
    end;
   label6.caption:=t;
  end
 else
  label6.caption:='';

end;

procedure TSubjectBySubjectDlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3Change(Sender);
 combobox3.selectall;
end;

end.
