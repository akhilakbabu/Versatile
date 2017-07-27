unit Groupsel;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, TimeChartGlobals, XML.DISPLAY,
  XML.TEACHERS, XML.STUDENTS;

type
  Tgroupseldlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    save: TBitBtn;
    BitBtn3: TBitBtn;
    Label3: TLabel;
    Edit2: TEdit;
    Cancel: TBitBtn;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    RadioGroup2: TRadioGroup;
    Label5: TLabel;
    ComboBox1: TComboBox;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn1: TBitBtn;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure saveClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
  private
    procedure FillGOScombo;
    procedure RestoreGOScombo;
  end;

var
  groupseldlg: Tgroupseldlg;

implementation
uses tcommon,StCommon,DlgCommon, main,studlist,tcommon2, cfggrpmn, Block1,tcommon5;
{$R *.DFM}


function GroupRadioGet: smallint;
var
 radioGroupINDEX: smallint;
begin
  with groupseldlg do
  begin
    radioGroupINDEX:=0; {init it}
    if radiobutton1.checked then radioGroupINDEX:=0
    else if radiobutton2.checked then radioGroupINDEX:=1
    else if radiobutton3.checked then radioGroupINDEX:=2
    else if radiobutton4.checked then radioGroupINDEX:=3
    //else if radiobutton5.checked then radioGroupINDEX:=4
    else if radiobutton6.checked then radioGroupINDEX:=5
    else if radiobutton7.checked then radioGroupINDEX:=6
    else if radiobutton8.checked then radioGroupINDEX:=7
    else if radiobutton9.checked then radioGroupINDEX:=8
    else if radiobutton10.checked then radioGroupINDEX:=9
    else if radiobutton11.checked then radioGroupINDEX:=10;
    Result := radioGroupINDEX;
  end;
end;

procedure updateThisDLG;
var
 radioGroupINDEX: smallint;
begin
 with groupseldlg do
 begin
   radioGroupINDEX:=GroupRadioGet;
   label4.caption:='';
   radiogroup2.enabled:=(radioGroupINDEX<>0);
  if radiogroup2.itemindex<>3 then
   case radioGroupINDEX of
    0,9: begin
          edit1.visible:=false; label1.visible:=false;
          edit2.visible:=false; label3.visible:=false;
          checkbox1.visible:=false; label4.visible:=false;
          label2.visible:=false;
         end;
    1..3,5..8,10:
         begin
          edit1.visible:=true; label1.visible:=true;
          edit2.visible:=false; label3.visible:=false;
          checkbox1.visible:=false; label4.visible:=true;
          label2.visible:=true;
         end;
    {4:   begin
          edit1.visible:=true; label1.visible:=true;
          edit2.visible:=true; label3.visible:=true;
          checkbox1.visible:=true; label4.visible:=true;
          label2.visible:=true;
         end;}
   end; {case}

   edit1.text:=''; edit2.text:='';
   if edit1.visible then //cannot focus invisible control
    if radioGroupINDEX>0 then edit1.setfocus;
   label6.caption:=inttostr(GroupNum)+'/'+inttostr(XML_STUDENTS.numstud)+' '+GroupName;

   case radioGroupINDEX of
    1: begin   {year}
        label1.caption:='&Year Code ';
        edit1.hint:='Enter year code for selection';
        label2.visible:=false;
        HelpContext:=34;
       end;
    2: begin   {class}
        label1.caption:='&Class Code ';
        edit1.hint:='Enter class code for selection';
        label2.caption:='(* for All Classes)';
        edit1.text:='*'; edit1.selectall;
        HelpContext:=34;
       end;
    3: begin   {house}
        label1.caption:='&House Code ';
        edit1.hint:='Enter house code for selection';
        label2.caption:='(* for All Houses)';
        edit1.text:='*'; edit1.selectall;
        HelpContext:=35;
       end;
    4: begin   {id}
        label1.caption:='&From ';
        edit1.hint:='Enter lowest student ID';
        label2.caption:='';
        edit2.hint:='Enter highest student ID';
        HelpContext:=36;
       end;
    5: begin   {tutor}
        label1.caption:='&Teacher Code ';
        edit1.hint:='Enter tutor for selection';
        label2.visible:=false;
        HelpContext:=37;
       end;
    6: begin   {room}
        label1.caption:='&Room Code ';
        edit1.hint:='Enter home room for selection';
        label2.visible:=false;
        HelpContext:=38;
       end;
    7: begin   {tag}
        label1.caption:='&Tag code ';
        edit1.hint:='Enter tag code for selection';
        label2.caption:='(* for All Tags)';
        edit1.text:='*'; edit1.selectall;
        HelpContext:=39;
       end;
    8: begin   {subject}
        label1.caption:='&Subject Code ';
        edit1.hint:='Enter subject choice for selection';
        label2.visible:=false;
        HelpContext:=40;
       end;
    10: begin   {free block}
        label1.caption:='&Block Number ';
        edit1.hint:='Enter block number to select student free';
        label2.visible:=false;
        HelpContext:=42;
        end;
   end; {case}
  countsubsinblock;
  radiobutton10.enabled:=not(subsinblock=0);
  radiobutton11.enabled:=not(subsinblock=0);

  if radiogroup2.itemindex=3 then
  begin
   edit1.visible:=false; edit2.visible:=false;
   label1.visible:=false; label2.visible:=false;
   label3.visible:=false; label4.visible:=false;
   checkbox1.visible:=false;
  end;
 end;
end;

procedure Tgroupseldlg.FormActivate(Sender: TObject);
begin
  if grouptype=0 then radiobutton1.checked:=true
  else if grouptype=1 then radiobutton2.checked:=true
  else if grouptype=2 then radiobutton3.checked:=true
  else if grouptype=3 then radiobutton4.checked:=true
  //else if (grouptype=4) or (grouptype=11) then radiobutton5.checked:=true
  else if grouptype=5 then radiobutton6.checked:=true
  else if grouptype=6 then radiobutton7.checked:=true
  else if grouptype=7 then radiobutton8.checked:=true
  else if grouptype=8 then radiobutton9.checked:=true
  else if grouptype=9 then radiobutton10.checked:=true
  else if grouptype=10 then radiobutton11.checked:=true;
 edit1.text:='';  edit2.text:='';
 label6.caption:=inttostr(GroupNum)+'/'+inttostr(XML_STUDENTS.numstud)+' '+GroupName;
 if grouptype=11 then checkbox1.Checked:=true;
 updateThisDLG;
end;

procedure Tgroupseldlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;


procedure GroupRecipeUpdate(xs,xm: smallint; xe1,xe2: string);
var
 i: smallint;
begin
 i:=GOSrecipe.NumSteps;
 if xm=0 then {new}
 begin
  GOSrecipe.NumSteps:=1; i:=1;
  setlength(GOSrecipe.steps,2+1); {re-dim}
 end
 else
  begin
   inc(i); GOSrecipe.NumSteps:=i;
   setlength(GOSrecipe.steps,i+1); {re-dim}
  end;
 GOSrecipe.steps[i].slct:=xs; GOSrecipe.steps[i].meth:=xm;
 GOSrecipe.steps[i].e1:=xe1; GOSrecipe.steps[i].e2:=xe2;
end;


procedure Tgroupseldlg.saveClick(Sender: TObject);
var
 codeStr,CodeType,tagStr:      string;
 i,j,k,tmpNum,m,a:     smallint;
 tmpGroup:     integer;
 wcPos,num:        integer;
 oldStudSelcode:      integer;
 methodSel:           integer;
 matchArr:         array of integer;
 radioGroupINDEX: smallint;

    function NoCodes(num:integer):boolean;
    begin
     result:=false;
     if num<=0 then
      begin
       messagedlg('No '+CodeType+' codes',mtError,[mbOK],0);
       result:=true;
      end;
    end;

    function NoEntry:boolean;
    begin
     result:=false;
     if codeStr='' then
      begin
       ShowMsg('No '+CodeType+' entered.',edit1);
       result:=true;
      end;
    end;

    function BadEntry(Num:integer):boolean;
    begin
     result:=false;
     if Num=0 then
      begin
       ShowMsg('Check '+CodeType+' entered.',edit1);
       result:=true;
      end;
    end;

begin
 XML_DISPLAY.StudListType := 2;  //Group
 setlength(matchArr,nmbrSubjects+1);
 setlength(StGroup,XML_STUDENTS.numStud+1);
 setlength(StudGrpFlg,(XML_STUDENTS.numStud+1)); {zero based so +1}
 radioGroupINDEX:=GroupRadioGet;

 oldStudSelcode:=-1;   tmpNum:=0;
 if wnFlag[wnStudentList] then
 begin
 if studentlistwin.selcode>0 then
  oldStudSelcode:=StPointer[studentlistwin.selcode];  {protect stud selcode}
 end;
 GroupType:=radioGroupINDEX;
 methodSel:=radiogroup2.itemindex;
 groupSelStr[1]:=edit1.text; groupselstr[2]:=edit2.text;
 tagStr:=trim(groupSelStr[1]);
 codeStr:=uppercase(tagStr);
 if GroupType=4 then if checkbox1.checked then GroupType:=11;

case GroupType of
 0: begin  {all}
     for i:=1 to XML_STUDENTS.numstud do StudGrpFlg[i]:=1;
     GroupName:='All';
    end;
 1: begin  {year}
     CodeType:=yeartitle;
     if methodSel<>3 then
      begin
       if NoEntry then exit;
       tmpNum:=findyear(codeStr);
       if BadEntry(tmpNum+1) then exit;
      end; {methodsel<>3}
     SetYearGroup(methodSel);
     if methodSel=0 then groupname:='Year '+yearname[tmpnum]
        else groupname:='Custom';
    end;
 2: begin  {class}
     CodeType:='class';
     if NoCodes(classnum) then exit;
     tmpNum:=findClass2(codeStr);tmpGroup:=0;
     if codeStr='*' then tmpNum:=-1;
     wcPos:=pos('*',codeStr);
     if wcPos>1 then
       begin
        codeStr:=copy(codeStr,1,wcPos-1);
        tmpGroup:= findClass2(codeStr);
       end;
     if methodSel<>3 then
      begin
       if NoEntry then exit;
       if ((tmpNum=0) and (tmpGroup=0)) then
        begin
         ShowMsg('Check class entered.',edit1);
         exit;  {return to editing}
        end;
      end;  {if methodSel<>3}
     SetClassGroup(methodSel);
     if methodSel<>0 then groupname:='Custom'
      else
       begin
         if tmpNum<0 then GroupName:='All classes'
          else if tmpGroup=0 then
            GroupName:='Class '+ClassCode[tmpnum]
             else GroupName:='Class '+codeStr+'*';
       end;
    end;
 3: begin  {house}
     CodeType:='house';
     if NoCodes(HouseCount) then exit;
     tmpNum:=findHouse2(codeStr);
     if codeStr='*' then tmpNum:=-1;
     if methodSel<>3 then
      begin
       if NoEntry then exit;
       if BadEntry(tmpNum) then exit;
      end;
     SetHouseGroup(methodSel);
     if methodSel<>0 then groupname:='Custom'
      else
       begin
         if tmpNum<0 then GroupName:='All houses'
          else GroupName:='House '+Housename[tmpnum];
       end;
    end;
 4,11: SetIDGroup(GroupType,methodSel);
 5: begin  {tutor}
     CodeType:='teacher';
     if NoCodes(Numcodes[1]) then exit;
     if methodSel<>3 then
      begin
       if NoEntry then exit;
       tmpNum:=findTe(codeStr,label4);
       if BadEntry(tmpNum) then exit;
      end;{methodsel<>3}
     SetTutorGroup(methodSel);
     if methodSel=0 then groupname:='Tutor '+XML_TEACHERS.TeCode[tmpnum,0]
        else groupname:='Custom';
    end;
 6:begin  {room}
    CodeType:='room';
    if NoCodes(Numcodes[2]) then exit;
    if methodSel<>3 then
     begin
      if NoEntry then exit;
       tmpNum:=findroom(codeStr,label4);
       if BadEntry(tmpNum) then exit;
     end;
    SetRoomGroup(methodSel);
    if methodSel=0 then groupname:='Room '+XML_TEACHERS.TeCode[tmpnum,1]
        else groupname:='Custom';
   end; {room}
 7: begin  {tag}
     CodeType:='tag code';  label4.Visible:=true;
     tmpNum:=findTag(tagStr,label4);
     if tagStr='*' then tmpNum:=-1;
     if BadEntry(tmpNum) then exit;
     SetTagGroup(methodSel);
     if methodSel<>0 then groupname:='Custom'
      else
       begin
         if tmpNum<1 then GroupName:='All tags'
          else GroupName:='Tag '+tagName[tmpNum];
       end;
    end;  {tag}
 8: begin  {subject}
     CodeType:='subject';
     if NoCodes(Numcodes[0]) then exit;
     if methodSel<>3 then
      begin
       if NoEntry then exit;
       tmpNum:=checkWildSub(codeStr);
       if BadEntry(tmpNum) then exit;
      end; {methodSel<>3}
     SetSubGroup(methodSel);
     if methodSel=0 then groupname:='Subject '+codestr
        else groupname:='Custom';
    end;
 9: begin {block clashes}
      if blockload=0 then
        begin
         messagedlg('No blocks loaded.',mtError,[mbOK],0); exit;
        end;
      SetBclashesGroup(methodSel);
      if methodSel=0 then groupname:='Block clashes'
        else groupname:='Custom';
    end; {block clashes}
  10: begin    {free in block}
       countsubsinblock;
       if blockload=0 then  {no blocks loaded}
        begin
         messagedlg('No blocks loaded.',mtError,[mbOK],0); exit;
        end;
       if InvalidEntry(a,1,XML_DISPLAY.blocknum,'block number',edit1) then exit;
       SetBfreeGroup(methodSel);
       if methodSel=0 then groupname:='Free Block '+inttostr(a)
        else groupname:='Custom';
      end; {free in block}
   end; {case}

 num:=0;
 for i:=1 to XML_STUDENTS.numstud do
 begin
  j:=StudSort[i];
  if StudGrpFlg[j]>0 then
  begin
   inc(num); StGroup[num]:=j;
  end;
 end; {for i}
 groupnum:=num;

 if wnFlag[wnStudentList] then
 begin
  if ((XML_DISPLAY.StudListType<>7) and (studentlistwin.selcode>0)) then   {restore stud selcode}
  begin
   studentpointerset;
   m:=0;
   for k:=1 to groupnum do
   begin
    if StPointer[k]=oldStudSelcode then
    begin
     m:=k;
     break;
    end;
   end; {for k}
   studentlistwin.selcode:=m;
  end;
 end;  {if wnFlag[wnStudentList]}

 updateGroupSubs;
 needClashMatrixRecalc:=true;
 GroupRecipeUpdate(grouptype,radiogroup2.itemindex,edit1.text,edit2.text);
 studentpointerset;
 UpdateStudWins;

 if radiogroup2.itemindex=0 then  {set to new if new group - so can press save straight away}
  combobox1.itemindex:=0;

 label6.caption:=inttostr(GroupNum)+'/'+inttostr(XML_STUDENTS.numstud)+' '+GroupName;
end;

procedure Tgroupseldlg.Edit1Change(Sender: TObject);
var
 s: string;
 radioGroupINDEX: smallint;
begin
 radioGroupINDEX:=GroupRadioGet;

 case radioGroupINDEX of
  1: findYearname(edit1.text,label4);
  2: findclass(edit1.text,label4);
  3: findhouse(edit1.text,label4);
  5: findTe(edit1.text,label4);
  6: findroom(edit1.text,label4);
  7: findTag(edit1.text,label4);
  8: begin  {subject}
      s:=trim(edit1.text);
      CheckWildYearSub(s,label4,true);
     end;
 end; {case}
end;

procedure Tgroupseldlg.Edit1Enter(Sender: TObject);
var
 ot: string;
 radioGroupINDEX: smallint;
begin
 radioGroupINDEX:=GroupRadioGet;

 case radioGroupINDEX of
  2,3,5,6,8:
   begin
    ot:=edit1.text;    {just to trigger change and update label}
    edit1.text:=edit1.text+'  ';
    edit1.text:=ot;
    label4.visible:=true;
    edit1.selectall;
   end;
 end;
end;

procedure Tgroupseldlg.Edit1Exit(Sender: TObject);
begin
 label4.visible:=false;
end;

procedure Tgroupseldlg.RestoreGOScombo;
var
 ii: integer;
begin
 ii:=combobox1.itemindex;
 FillGOScombo;
 combobox1.itemindex:=ii;
end;

procedure Tgroupseldlg.FillGOScombo;
var
 i: smallint;
begin
 combobox1.clear;
 combobox1.items.add('(new)');
 if GOSnum>0 then
  for i:=1 to GOSnum do
   combobox1.items.add(GOSname[i]);
end;


procedure Tgroupseldlg.FormCreate(Sender: TObject);
begin
 FillGOScombo;
 combobox1.itemindex:=0;    {new}
end;

procedure Tgroupseldlg.ComboBox1Change(Sender: TObject);
begin
 bitbtn4.enabled:=(combobox1.itemindex>1);
 bitbtn5.enabled:=(combobox1.itemindex>1);  {prevent delete and rename of ALL}
 bitbtn6.enabled:=(combobox1.itemindex<>1);
 if combobox1.itemindex>0 then
 begin
  setRecipeFromGOS(combobox1.itemindex);
  REselectgroup;
  UpdateStudWins;
  GroupName:=GOSname[combobox1.itemindex];
  label6.caption:=inttostr(GroupNum)+'/'+inttostr(XML_STUDENTS.numstud)+' '+GroupName;
 end;
end;

procedure Tgroupseldlg.BitBtn4Click(Sender: TObject);
var
 ss,msg: string;
begin
 if (usrPassLevel=utGen) then
  begin
   showRestrictedMsg;
   exit;
  end;

 if combobox1.itemindex<2 then
  begin
   msg:='You need to select a custom group from the drop down list'+endline;
   msg:=msg+'before you can alter its name.';
   messagedlg(msg,mtError,[mbOK],0);
   exit;
  end;
 ss:=InputBox('Edit custom group name','Enter the new name for the selected group','');
 ss:=trim(ss);
 if ss>'' then
  begin
   GOSname[combobox1.itemindex]:=ss;
   saveGroups;
   RestoreGOScombo;
   GroupName:=ss;
   label6.caption:=inttostr(GroupNum)+'/'+inttostr(XML_STUDENTS.numstud)+' '+GroupName;
  end;
end;

function groupExistsAlready(ss:string):wordbool;
var
 i: smallint;
 s1,s2: string;
begin
 result:=false;
 for i:=1 to GOSnum do
 begin
  s1:=uppercase(trim(ss));
  s2:=uppercase(trim(GOSname[i]));
  if s1=s2 then begin result:=true; break; end;
 end; {for i}
end;

procedure AddRecipeToGOS(nm: integer);
var
 cnt,GmenuCnt,i: smallint;
begin
 cnt:=GOSrecipe.NumSteps;
 GmenuCnt:=GOSnum;
 if nm>GOSnum then GmenuCnt:=nm;
   setlength(GOS,GmenuCnt+1);
   setlength(GOS[nm].steps,cnt+1);
 GOS[nm].NumSteps:=cnt;
 for i:=1 to cnt do GOS[nm].steps[i]:=GOSrecipe.steps[i];
 GOS[nm].SubOfferName:=GOSrecipe.SubOfferName;
 saveGroups;
end;

procedure Tgroupseldlg.BitBtn6Click(Sender: TObject);
var
 ii: smallint;
 ss,msg: string;
begin
 if (usrPassLevel=utGen) then
  begin
   showRestrictedMsg;
   exit;
  end;

 ii:=combobox1.itemindex;
 if ii<1 then
  begin
   ss:=InputBox('New custom group','Enter the name for the new group','');
   ss:=trim(ss);
   if groupExistsAlready(ss) then
    begin
     msg:='Group has NOT been saved as a group already exists with that name.'+endline;
     msg:=msg+'Please select a different name.';
     messagedlg(msg,mtWarning,[mbOK],0);
     exit;
    end;
   if ss='' then
    begin
     msg:='Group has NOT been saved as no name was provided.'+endline;
     messagedlg(msg,mtWarning,[mbOK],0);
     exit;
    end;
  end;

 if ii>0 then {warn before replacing saved group}
  begin
   msg:='Replace saved group - '+GOSname[ii]+' ?';
   if messagedlg(msg,mtWarning,[mbYes,mbNo],0)<>mryes then
   exit;
  end;

 if ii<1 then
  begin
   ii:=GOSnum+1;
   setlength(GOS,ii+1);
   setlength(GOSname,ii+1);
   GOSnum:=ii;
   GOSname[ii]:=ss;
  end;

 GroupName:=ss;   //for panel on status bar update
 label6.caption:=inttostr(GroupNum)+'/'+inttostr(XML_STUDENTS.numstud)+' '+GroupName;
 AddRecipeToGOS(ii);
 FillGOScombo;
 combobox1.itemindex:=ii;    {new}
 bitbtn4.enabled:=(combobox1.itemindex>1);
 bitbtn5.enabled:=(combobox1.itemindex>1);
end;

procedure removeGroupFromGOS(nm: integer);
var
 i,j,k,m,tmpNum: smallint;
begin
 if GOSnum>nm then
  for i:=nm to GOSnum-1 do
   begin
    GOSname[i]:=GOSname[i+1];
    GOS[i].SubOfferName:=GOS[i+1].SubOfferName;
    tmpNum:=GOS[i+1].NumSteps;
    if GOS[i].NumSteps<tmpNum then setlength(GOS[i].steps,tmpNum+1);
    GOS[i].NumSteps:=GOS[i+1].NumSteps;
    for m:=1 to tmpNum do GOS[i].steps[m]:=GOS[i+1].steps[m];
   end;
 GOSnum:=GOSnum-1;
  k:=GOSmenu[0]; j:=0;
  if k>0 then
   for i:=1 to k do
   begin
    if (GOSmenu[i]<>nm) then
    begin
     inc(j);
     if (GOSmenu[i]>nm) then
      GOSmenu[j]:=(GOSmenu[i]-1)
     else
      GOSmenu[j]:=GOSmenu[i];
    end;
   end; {for i}
  GOSmenu[0]:=j;
  updateCustomMenus;
end;

procedure Tgroupseldlg.BitBtn5Click(Sender: TObject);
var
 ii: smallint;
 msg: string;
begin
 if (usrPassLevel=utGen) then
 begin
  showRestrictedMsg;
  exit;
 end;

 ii:=combobox1.itemindex;
 if ii<2 then
 begin
  msg:='You need to select a custom group from the drop down list'+endline;
  msg:=msg+'before you can delete it.';
  messagedlg(msg,mtError,[mbOK],0);
  exit;
 end;
 removeGroupFromGOS(ii);
 saveGroups;
 RestoreGOScombo;
end;

procedure Tgroupseldlg.BitBtn1Click(Sender: TObject);
begin
 if (usrPassLevel=utGen) then
 begin
  showRestrictedMsg;
  exit;
 end;

 ConfigureGroupMenudlg:=TConfigureGroupMenudlg.create(self);   {allocate dlg}
 ConfigureGroupMenudlg.showmodal;
 ConfigureGroupMenudlg.free;    {release dlg}
end;

procedure Tgroupseldlg.RadioButton1Click(Sender: TObject);
begin
 updateThisDLG;
end;

procedure Tgroupseldlg.RadioGroup2Click(Sender: TObject);
var
 a,b: string;
begin
  a:=edit1.text; b:=edit2.text;
  updateThisDLG;
  edit1.text:=a; edit2.text:=b;
end;

end.


