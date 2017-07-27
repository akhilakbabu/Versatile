unit DlgCommon;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils,Messages,grids,TimeChartGlobals,classDefs,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

 procedure allowNumericInputOnly(var key: char);
 procedure allowdecimalInputOnly(var key: char);
 function findChoice(enteredTxt: string; msgLabel: Tlabel; useMsg: bool): smallint;
 procedure allocateStudChoices(myEdit9: tpEdit9; msgLabel: Tlabel);
 function findTe(enteredTxt: string; msgLabel: Tlabel): smallint;
 function findClass(enteredTxt: string; msgLabel: Tlabel): smallint;
 function findHouse(enteredTxt: string; msgLabel: Tlabel): smallint;
 function findRoom(enteredTxt: string; msgLabel: Tlabel): smallint;
 function findTag(enteredTxt: string; msgLabel: Tlabel): smallint;
 function findFaculty(enteredTxt: string; msgLabel: Tlabel): smallint;
 function findYearname(enteredTxt: string; msgLabel: Tlabel): smallint;
 function findWSblock(enteredTxt: string; msgLabel: Tlabel): smallint;
 function findDayMsg(s: string;msgLabel: Tlabel): smallint;
 function getLevel(myYear: integer; enteredTxt: string; msgLabel: Tlabel): smallint;
 function getTimeSlot(myDay: integer; enteredTxt: string; msgLabel: Tlabel): smallint;
 function IntFromEdit(myEdit: Tedit):integer;

 procedure insertfaculty(ebox: Tedit);
 function checkWildCode(var codeStr: string; msgLabel: Tlabel; useMsg: bool): smallint;
 function checkwildYearSub(codeStr: string; msgLabel: Tlabel; useMsg: bool): smallint;
 function NoCode(var codeStr: string; myEdit: Tedit):boolean;
 function BlankEntry(S: string; myEdit: Tedit):boolean;
 function NoCodesAvail(num:integer;CodeType:string):boolean;
 function NoCodesAvail1(mycode:integer):boolean;
 function CodeZero(codeStr: string;myEdit:Tedit):boolean;
 function CodeUsed(var codePlace:integer;code:smallint;var codeStr:string;myEdit:Tedit):boolean;
 function NoNewCode(var codeStr: string; myEdit: Tedit):boolean;
 function CodeNotFound(var myCode:integer;code:integer;myEdit:Tedit):boolean;
 function WildSubNotFound(var myCode:integer;myEdit:Tedit;msgLabel: Tlabel):boolean;
 function FacNotFound(var myCode:integer;myEdit:Tedit):boolean;

 function ChoiceNotFound(var su:integer;i:integer;s:string; myEdit:Tedit):boolean;
 function NAused(su,i:integer;myEdit:Tedit):boolean;
 function NotInBlock(su,i:integer;myEdit:Tedit):boolean;
 function CodeAlreadyUsed(var CodeStrNew:string;myCode,code:integer;myEdit:Tedit):boolean;
 procedure ComboMsg(msg: string;myCombo: TcomboBox);
 procedure ShowMsg(msg: string; myEdit: Tedit);
 function FindComboAllYear(myCombo: TcomboBox; msgLabel: Tlabel):smallint;
 function BadComboYear(var myYear:smallint; myCombo: TcomboBox):boolean;
 function BadLevel(var myLevel,myYear:smallint;myEdit:Tedit):boolean;
 function BadDayCombo(var myDay:smallint;myCombo:TcomboBox):boolean;
 function BadTimeCombo(var myTime,myDay:smallint;myCombo:TcomboBox):boolean;
 function BadTimeSlot(var myTime,myDay:smallint;myEdit:Tedit):boolean;
 function blockrange(e1,e2:Tedit): bool;
 function BadLength(var Mylen:smallint;min,max:integer;MyEdit:Tedit):boolean;
 function InvalidEntry(var Mylen:smallint;min,max:integer;s:string;MyEdit:Tedit):boolean;
 procedure ReductionMsg(s: string;MyEdit: Tedit; DuplcateExample: string = '');
 function OpCheck(location,target,optype:string):boolean;
 function ChangeDayCombo(d:integer; DayCombo,TimeCombo:TcomboBox): boolean;
 procedure ChangeTimeCombo(var p:smallint; TimeCombo:TcomboBox;msgLabel: Tlabel);
 procedure FillComboBlocks(myCombo:TcomboBox);
 procedure FillComboMult(myCombo:TcomboBox);
 procedure GetMultIndex(var myMult: integer; myCombo:TcomboBox);
 procedure FillComboTarget(myCombo:TcomboBox);
 procedure FillComboYears(AddAll:boolean; myCombo:TcomboBox);
 procedure FillComboTimeSlots(AddAll:boolean; myDay:smallint; myCombo:TcomboBox);
 procedure FillComboDays(AddAll:boolean; myCombo:TcomboBox);
 procedure FillComboFaculty(AddAll:boolean; myCombo:TcomboBox);
 procedure FillComboRollClass(myCombo:TcomboBox;DefClass:integer;myRadio:TRadioButton);
 procedure FillComboCode(code: integer; myCombo:TcomboBox);
 function DupStudent(StN:integer;MyStud:tpStudRec;MyEdit:Tedit):boolean;
 procedure HiLiteEdit(MyEdit:Tedit);
 procedure HiLiteCombo(MyCombo:TcomboBox);
 procedure HiLiteCombo1(MyCombo:TcomboBox);
 procedure HiLiteList(MyList:TlistBox);
 procedure MoveUpList(var TmpArr: array of smallint;MyList:TlistBox);
 procedure MoveDownList(var TmpArr: array of smallint;MyList:TlistBox);
 procedure MoveOffList(var TmpArr: array of smallint;MyList:TlistBox;Mylab:Tlabel);
 procedure ClearList(var TmpArr: array of smallint;MyList:TlistBox;Mylab:Tlabel);
 procedure MoveOnSubList(var TmpArr: array of smallint;List1,List2:TlistBox;
    Mylab:Tlabel;code:integer);
 procedure FillSubList(var TmpArr: array of smallint;List1,List2:TlistBox;
    Mylab:Tlabel;code:integer);
 procedure MoveOnStudList(var TmpArr: array of smallint;List1,List2:TlistBox;
    Mylab:Tlabel;InGroup:boolean);
 procedure FillStudList(var TmpArr: array of smallint;List1,List2:TlistBox;
    Mylab:Tlabel;InGroup:boolean);
 procedure SetPtabs(var ptab: tpPeriodData;myCanvas: Tcanvas);
 function ChangeCodeView(mywin,mycode: integer):boolean;

implementation

uses
  tcommon, tcommon2, StCommon, Ttable, CodeView;

function ChangeCodeView(mywin,mycode: integer):boolean;
var
 oldshow,oldsort: smallint;
begin
 oldshow:=winView[mywin];
 oldsort:=XML_DISPLAY.sorttype[mycode];
 ViewCodeDialog:=TViewCodeDialog.create(application); {allocate dlg}
 ViewCodeDialog.Tag:=mywin;
 viewCodeDialog.showmodal;
 viewCodeDialog.free;
 if XML_DISPLAY.sorttype[mycode]<>oldsort then sortcodes(mycode);
 result:=(XML_DISPLAY.sorttype[mycode]<>oldsort) or (oldshow<>winView[mywin]);
end;

procedure SetPtabs(var ptab: tpPeriodData;myCanvas: Tcanvas);
var
 d,p,fwtmp,fwsize,temp: integer;
begin
 ptab[0]:=0;   fwsize:=1;
 for d:=0 to (days-1) do
  begin
   myCanvas.textout(2,2+15*d,day[d]+':');
   temp:=myCanvas.textwidth(day[d]);
   if temp>ptab[0] then ptab[0]:=temp;
   for p:=0 to Tlimit[d]-1 do
    begin
     fwtmp:=myCanvas.textwidth(TsCode[d,p]+' ');
     if fwtmp>fwsize then fwsize:=fwtmp;
    end;
  end;
 ptab[0]:=ptab[0]+2+myCanvas.textwidth(': ');
 for p:=1 to periods do
  ptab[p]:=ptab[p-1]+fwsize;
end;

procedure MoveUpList(var TmpArr: array of smallint;MyList:TlistBox);
var
 i: integer;
begin
 if MyList.Count>1 then
  for i:=1 to MyList.Count-1 do
   if (MyList.Selected[i] and not(MyList.Selected[i-1])) then
    begin
     MyList.Items.Move(i,i-1);  swapint(TmpArr[i+1],TmpArr[i]);
     MyList.Selected[i-1]:=true;
    end;
end;

procedure MoveDownList(var TmpArr: array of smallint;MyList:TlistBox);
var
 i: integer;
begin
 if MyList.Count>1 then
  for i:=MyList.Count-2 downto 0 do
   if (MyList.Selected[i] and not(MyList.Selected[i+1])) then
   begin
    MyList.Items.Move(i,i+1);  swapint(TmpArr[i+1],TmpArr[i+2]);
    MyList.Selected[i+1]:=true;
   end;
end;

procedure MoveOffList(var TmpArr: array of smallint;MyList:TlistBox;Mylab:Tlabel);
var
 i,j: integer;
begin
 if MyList.items.count>0 then
  for i:=(MyList.items.count-1) downto 0 do
   if MyList.selected[i] then
   begin
    MyList.items.delete(i);
    if (i+1)<TmpArr[0] then
      for j:=i+1 to TmpArr[0]-1 do TmpArr[j]:=TmpArr[j+1];
    dec(TmpArr[0]);
   end;
 Mylab.caption:=inttostr(MyList.items.count);
end;

procedure MoveOnStudList(var TmpArr: array of smallint;List1,List2:TlistBox;
    Mylab:Tlabel;InGroup:boolean);
var
 i,j:       integer;

 function alreadyInlist(s:smallint): wordbool;
 var
  i: smallint;
 begin
  result:=false;
  if TmpArr[0]<=0 then exit;
  for i:=1 to TmpArr[0] do
   if TmpArr[i]=s then
    begin
     result:=true; break;
    end;
 end;

begin
 if List1.items.count>0 then
  for i:=0 to (List1.items.count-1) do
   if List1.selected[i] then
    if not(alreadyInlist(i+1)) then
    if List2.items.indexof(List1.items[i])=-1 then {not already in list}
     begin
      List2.items.add(List1.items[i]);
      if InGroup then j:=StGroup[i+1] else j:=i+1;
      inc(TmpArr[0]); TmpArr[TmpArr[0]]:=j;
     end;
 Mylab.caption:=inttostr(List2.items.count);
end;

procedure MoveOnSubList(var TmpArr: array of smallint;List1,List2:TlistBox;
    Mylab:Tlabel;code:integer);
var
 i:       integer;
begin
 if List1.items.count>0 then
  for i:=0 to (List1.items.count-1) do
   if List1.selected[i] then
    if List2.items.indexof(List1.items[i])=-1 then {not already in list}
     begin
      List2.items.add(List1.items[i]);
      inc(TmpArr[0]); TmpArr[TmpArr[0]]:=codepoint[i+1,code];
     end;
 Mylab.caption:=inttostr(List2.items.count);
end;

procedure FillSubList(var TmpArr: array of smallint;List1,List2:TlistBox;
    Mylab:Tlabel;code:integer);
var
 i:       integer;
begin
 List2.items:=List1.items;
 Mylab.caption:=inttostr(List2.items.count);
 for i:=1 to codeCount[code] do TmpArr[i]:=codepoint[i,code];
 TmpArr[0]:=codeCount[code];
end;

procedure FillStudList(var TmpArr: array of smallint;List1,List2:TlistBox;
    Mylab:Tlabel;InGroup:boolean);
var
 i,j:       integer;
begin
 List2.items:=List1.items;
 Mylab.caption:=inttostr(List2.items.count);
 if InGroup then
  begin
   for i:=1 to groupnum do
    begin
     j:=StGroup[i];
     TmpArr[i]:=j;
    end;
   TmpArr[0]:=groupnum;
  end
 else
  begin
   for i:=1 to XML_STUDENTS.numstud do TmpArr[i]:=i;
   TmpArr[0]:=XML_STUDENTS.numstud;
  end;
end;

procedure ClearList(var TmpArr: array of smallint;MyList:TlistBox;Mylab:Tlabel);
var
  i: Integer;
begin
  MyList.clear;
  Mylab.caption:=inttostr(MyList.items.count);
  for i := 0 to High(TmpArr) do
    TmpArr[i] := 0;                //Clear all
end;

procedure HiLiteEdit(MyEdit:Tedit);
begin
 MyEdit.Enabled:=true;
 MyEdit.color:=clRelevantControlOnDlg;
 if MyEdit.Enabled and MyEdit.Visible then
 begin
   MyEdit.setfocus;
   MyEdit.selectall;
 end;
end;

procedure HiLiteCombo(MyCombo:TcomboBox);
begin
 MyCombo.Enabled:=true;
 MyCombo.color:=clRelevantControlOnDlg;
 MyCombo.setfocus; MyCombo.selectall;
end;

procedure HiLiteCombo1(MyCombo:TcomboBox);
begin
 HiLiteCombo(MyCombo);
 MyCombo.setfocus; MyCombo.SelectAll;
end;

procedure HiLiteList(MyList:TlistBox);
begin
 MyList.Enabled:=true;
 MyList.Color:=clRelevantControlOnDlg;
end;

procedure FillComboFaculty(AddAll:boolean; myCombo:TcomboBox);
var
 i: integer;
begin
 myCombo.clear;
 myCombo.Hint:='Select Faculty';
 myCombo.Maxlength:=szFacName;
 if AddAll then myCombo.items.add('All faculties');
 if facnum>0 then
  for i:=1 to facnum do myCombo.items.add(facname[i])
 else myCombo.Enabled:=false;
end;

procedure FillComboRollClass(myCombo:TcomboBox;DefClass:integer;myRadio:TRadioButton);
var
 i,j,k,c: integer;
 VerifyClass:array of boolean;
begin
 SetLength(VerifyClass,classnum+10);
 myCombo.Clear;
 for i:=0 to classnum do VerifyClass[i]:=false;
 for i:=1 to XML_STUDENTS.numstud do
  begin
   j:=XML_STUDENTS.Stud[i].tcClass;
   if (j>0) and (j<=classnum) then VerifyClass[j]:=true;
  end;

 myCombo.items.add('All classes');
 j:=0;   k:=0;
 if classnum>0 then
  for i:=1 to classnum do
   begin
    c:=RollClasspoint[i];
    if VerifyClass[c] then
     begin
      myCombo.items.add(ClassCode[c]);
      inc(j);
      if c=DefClass then k:=j;
     end;
   end;
 if j>0 then
  begin
   MyCombo.itemindex:=k;
   MyCombo.update;
  end
 else myRadio.Enabled:=false;
end;

procedure FillComboCode(code: integer; myCombo:TcomboBox);
var
 i,k: integer;
begin
 myCombo.Clear;
 myCombo.Hint:='Select '+codeName[code];
 if codeCount[code]>0 then
  for i:=1 to codeCount[code] do
   begin
    k:=codepoint[i,code];
    myCombo.items.add(FNsub(k,code)+'  '+FNsubname(k,code));
   end;
end;

procedure FillComboDays(AddAll:boolean; myCombo:TcomboBox);
var
 i: integer;
begin
 myCombo.clear;
 myCombo.Hint:='Select Day';
 myCombo.Maxlength:=szDay;
 myCombo.DropDownCount:=days+1;
 if AddAll then myCombo.items.add('All days');
 for i:=0 to (days-1) do myCombo.items.add(day[i]);
end;

procedure FillComboMult(myCombo:TcomboBox);
var
 i,j: integer;
 MultName: array of string;
begin
 SetLength(MultName,wsMultNum+2);
 myCombo.clear;  myCombo.Sorted:=true;
 myCombo.Hint:='Select multiple';
 for i:=0 to wsMultNum do
  begin
   wsOrder[i]:=-1; wsXorder[i]:=-1;
   MultName[i]:=wsMultName(i);
   if (wsOne[i]>0) or (wsTwo[i]>0) or (wsThree[i]>0) then
     myCombo.items.add(MultName[i]);
  end;
 for i:=0 to wsMultNum do
  begin
   j:=myCombo.Items.IndexOf(MultName[i]);
   if j>=0 then
    begin
     wsOrder[i]:=j; wsXorder[j]:=i;
    end;
  end;
 wsMultChangeFlg:=false;
end;

procedure GetMultIndex(var myMult: integer; myCombo:TcomboBox);
var
 i,j: integer;
begin
 i:=myCombo.ItemIndex;
 if (i>=0) and (i<=wsMultNum) then
  begin
   j:=wsXorder[i];
   if (j>=0) and (j<=wsMultNum) then myMult:=j;
  end;
end;

procedure FillComboTarget(myCombo:TcomboBox);
var
 i: integer;
begin
 FillComboYears(true,myCombo);
 for i:=1 to nmbrWSTspecials do
   myCombo.items.add('Special '+inttostr(i));
end;

procedure FillComboYears(AddAll:boolean; myCombo:TcomboBox);
var
 i: integer;
begin
 myCombo.clear;
 myCombo.Hint:='Select '+Yeartitle;
 myCombo.Maxlength:=szYearname;
 myCombo.DropDownCount:=years+1;
 if AddAll then myCombo.items.add('All years');
 for i:=0 to years_minus_1 do myCombo.items.add(yearname[i]);
end;

procedure FillComboTimeSlots(AddAll:boolean; myDay:smallint; myCombo:TcomboBox);
var
 i: integer;
begin
 myCombo.clear;
 myCombo.Hint:='Select Time Slot';
 myCombo.Maxlength:=szPeriodName+4;
 if AddAll then myCombo.items.add('All time slots');
 for i:=0 to (Tlimit[myDay]-1) do
  myCombo.items.add(tsCode[myDay,i]+': '+TimeSlotName[myDay,i]);
end;

procedure ChangeTimeCombo(var p:smallint; TimeCombo:TcomboBox;msgLabel: Tlabel);
begin
 p:=TimeCombo.ItemIndex;
 if p<0 then msgLabel.caption:='Select Time Slot'
  else msgLabel.caption:='';
 TimeCombo.SelectAll;
end;

function ChangeDayCombo(d:integer; DayCombo,TimeCombo:TcomboBox): boolean;
var
 olddayGroup:  integer;
begin
 result:=false;
 olddayGroup:=1; if d>=0 then olddayGroup:=DayGroup[d];
 d:=FindDay(DayCombo.text);
 if d>=0 then
  if DayGroup[d]<>olddayGroup then
   begin
    FillComboTimeSlots(false,d,TimeCombo);
    result:=true;
   end;
end;

procedure FillComboBlocks(myCombo:TcomboBox);
var
 i: integer;
begin
 myCombo.clear;
 myCombo.Hint:='Select block';
 myCombo.Maxlength:=2;
 for i:=1 to wsBlocks do
   myCombo.items.add(trim(inttostr(i)));
end;

function zeromessage: string;
var
 msg: string;
begin
 msg:='Codes starting with "00" are reserved by Time Chart for'+endline;
 msg:=msg+' deleted codes and are unavailable for other uses.'+endline;
 msg:=msg+'Please enter a different code.';
 result:=msg;
end;

procedure ShowMsg(msg: string; myEdit: Tedit);
begin
  MessageDlg(msg,mtError, [mbOK], 0);
  if myEdit.Visible and myEdit.Enabled then
  begin
    myEdit.SetFocus;
    myEdit.SelectAll;
  end;
end;

function DupStudent(StN:integer;MyStud:tpStudRec;MyEdit:Tedit):boolean;
var
 i: integer;
begin
 result:=false;
 i:=findThisStudent(MyStud);
 if ((i>0) and (i<>StN)) then
  begin
    ShowMsg('Another student is already using these details.'+endline+
       'Duplicate students are not accepted.'+endline
       +'Add a middle initial if necessary.',MyEdit);
   result:=true;
  end;
end;

function BadLength(var Mylen:smallint;min,max:integer;MyEdit:Tedit):boolean;
begin
 result:=InvalidEntry(Mylen,min,max,'length',MyEdit);
end;

function InvalidEntry(var Mylen:smallint;min,max:integer;s:string;MyEdit:Tedit):boolean;
begin
 result:=false;
 Mylen:=IntFromEdit(MyEdit);
 if ((Mylen<min) or (Mylen>max)) then
  begin
   ShowMsg('Invalid '+s+'. '+chr(10)+'Enter a value in the range '
        +inttostr(min)+' to ' +inttostr(max)+'.',MyEdit);
   result:=true;
  end;
end;

procedure ReductionMsg(s: string; MyEdit: Tedit; DuplcateExample: string);
var
  lTempMsg: string;
begin
  if DuplcateExample <> '' then
    lTempMsg := #10#13#10#13 + 'Duplicate example: ' + DuplcateExample
  else
    lTempMsg := '';

  ShowMsg('Reduction of '+s+' code length would result in duplicate '+s+' codes.'
   + endline+'Duplicate '+s+' codes are not permitted.' + lTempMsg, MyEdit);
end;

function OpCheck(location,target,optype:string):boolean;
var
 msg: string;
begin
 msg:='Entry'+location+' is part of a '+target+'.'+endline+Optype+' anyway?';
 result:=(messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes);
end;

procedure ComboMsg(msg: string;myCombo: TcomboBox);
begin
 messagedlg(msg,mtError,[mbOK],0);
 myCombo.setfocus; myCombo.SelectAll;
end;

function FindComboAllYear(myCombo: TcomboBox; msgLabel: Tlabel):smallint;
var
 tmpstr:  string;
 tmpYear: smallint;
begin
 tmpYear:=findyear(myCombo.text);
 tmpstr:=uppercase(trim(myCombo.text));
 if ((tmpstr='*') or (tmpstr=uppercase(myCombo.items[0]))) then
 begin
  tmpYear:=years;
  msgLabel.caption:=myCombo.items[0];
 end
 else
  if tmpYear>-1 then msgLabel.caption:=yearname[tmpYear]
   else msgLabel.caption:='Enter '+yeartitle;
 result:=tmpYear;
end;

function BadComboYear(var myYear:smallint; myCombo: TcomboBox):boolean;
begin
 result:=false;
 myYear:=findYear(myCombo.text);
 if myYear=-1 then
  begin
   ComboMsg('Check '+yeartitle,myCombo);
   result:=true;
  end;
end;

function BadLevel(var myLevel,myYear:smallint;myEdit:Tedit):boolean;
begin
 result:=false;
 myLevel:=IntFromEdit(myEdit);
 if (myLevel<1) or (myLevel>level[myYear]) then
  begin
   ShowMsg('Check level',myEdit);
   result:=true;
  end;
end;

function BadTimeSlot(var myTime,myDay:smallint;myEdit:Tedit):boolean;
begin
 result:=false;
 myTime:=IntFromEdit(myEdit)-1;
 if (myTime<0) or (myTime>=Tlimit[myDay]) then
  begin
   ShowMsg('Check time slot',myEdit);
   result:=true;
  end;
end;

function BadBlockRange(var num:integer;desc:string;MyEdit:Tedit):boolean;
begin
 result:=false;
 num:=IntFromEdit(myEdit);
 if (num<1) or (num>XML_DISPLAY.blocknum) then
  begin
   ShowMsg('Enter '+desc+' block in the range 1 to '+inttostr(XML_DISPLAY.blocknum),myEdit);
   result:=true;
  end;
end;

function blockrange(e1,e2:Tedit): bool;
var
 low,high: integer;
begin
 result:=false;
 if BadBlockRange(low,'"from"',e1) then exit;
 if BadBlockRange(high,'"to"',e2) then exit;
 result:=true;
 if low<=high then
  begin
   Lblock:=low;
   Hblock:=high;
  end
 else
  begin
   Hblock:=low;
   Lblock:=high;
  end;
end;

function BadTimeCombo(var myTime,myDay:smallint;myCombo:TcomboBox):boolean;
begin
 result:=false;
 myTime:=myCombo.ItemIndex;
 if (myTime<0) or (myTime>myCombo.Items.Count) then
  begin
   ComboMsg('Check time slot',myCombo);
   result:=true;
  end;
end;

function BadDayCombo(var myDay:smallint;myCombo:TcomboBox):boolean;
begin
 result:=false;
 myDay:=findDay(myCombo.text);
 if myDay=-1 then
  begin
   ComboMsg('Check Day',myCombo);
   result:=true;
  end;
end;

function CodeZero(codeStr: string;myEdit:Tedit):boolean;
begin
 result:=false;
 if (copy(codeStr,1,2)='00') then
  begin
   ShowMsg(zeromessage,myEdit);
   result:=true;
  end;
end;

function NoCode(var codeStr: string; myEdit: Tedit):boolean;
begin
 result:=false;
 codeStr:=TrimRight(myEdit.text);
 if codeStr='' then
  begin
   ShowMsg('No code entered.',myEdit);
   result:=true;
  end;
end;

function BlankEntry(S: string; myEdit: Tedit):boolean;
var
 codeStr: string;
begin
 result:=false;
 codeStr:=Trim(myEdit.text);
 if codeStr='' then
  begin
   ShowMsg(s+' names cannot be left blank.',myEdit);
   result:=true;
  end;
end;

function NoCodesAvail(num:integer;CodeType:string):boolean;
begin
 result:=false;
 if num<=0 then
  begin
   messagedlg('No '+CodeType+' available for deletion',mtError,[mbOK],0);
   result:=true;
  end;
end;

function NoCodesAvail1(mycode:integer):boolean;
begin
 result:=false;
 if codeCount[mycode]<=0 then
  begin
   messagedlg('No '+CodeName[mycode]+' codes available to edit',mtError,[mbOK],0);
   result:=true;
  end;
end;

function NoNewCode(var codeStr: string; myEdit: Tedit):boolean;
begin
 result:=false;
 codeStr:=TrimRight(myEdit.text);
 if codeStr='' then
  begin
   ShowMsg('No new code entered.',myEdit);
   result:=true;
  end;
end;

function CodeNotFound(var myCode:integer;code:integer;myEdit:Tedit):boolean;
var
codeStr:string;
begin
 result:=false;
 codeStr:=TrimRight(myEdit.text);
 if code>=0 then myCode:=checkCode(code,codeStr);
 if myCode<=0 then     {code not found}
 begin
  ShowMsg('The code '+codeStr+' could not be found.'+endline+
                 'Please enter a different code.',myEdit);
  result:=true;
 end;
end;

function FacNotFound(var myCode:integer;myEdit:Tedit):boolean;
var
 codeStr: string;
begin
 result:=false;
 codeStr:=trim(myEdit.text);
 myCode:=CheckFaculty(codeStr);
 if myCode<=0 then     {code not found}
 begin
  ShowMsg('The faculty '+codeStr+' could not be found.'+endline+
                 'Please enter a different faculty.',myEdit);
  result:=true;
 end;
end;

function WildSubNotFound(var myCode:integer;myEdit:Tedit;msgLabel: Tlabel):boolean;
var
 codeStr: string;
begin
 result:=false;
 codeStr:=trim(myEdit.text);
 myCode:=checkWildCode(codeStr,msgLabel,false);
 if myCode=0 then     {code not found}
 begin
  ShowMsg('The subject code '+codeStr+' could not be found.'+endline+
                 'Please enter a different code.',myEdit);
  result:=true;
 end;
end;

function ChoiceNotFound(var su:integer;i:integer;s:string; myEdit:Tedit):boolean;
begin
 result:=false;
 su:=checkcode(0,s);
 if (su=0) then
  begin
   ShowMsg('Student subject choice code number '+inttostr(i)+endline+
     'is NOT A VALID Student Subject Choice.'+endline+
     'Please enter a different subject code.',MyEdit);
   result:=true; {return to editing}
  end;
end;

function NotInBlock(su,i:integer;myEdit:Tedit):boolean;
begin
 result:=false;
 if i<=XML_DISPLAY.blocknum then
  if not(subISAlreadyinBlock(su,i)) then
   begin
    ShowMsg(subname[su]+'  ('+SubCode[su]+')'+endline+
      'is NOT a Block '+inttostr(i)+' subject.',myEdit);
    result:=true;
   end;
end;

function NAused(su,i:integer;myEdit:Tedit):boolean;
begin
 result:=false;
 if ((su=subNA) and (subNA>0)) then
  begin
   ShowMsg('Subject choice number '+inttostr(i)+' is entered as "NA".'+endline+
    '"NA" is a reserved code for "Not Available" and is not a valid Student Choice.'
    +endline,myEdit);
   result:=true;
  end;
end;

function CodeAlreadyUsed(var CodeStrNew:string;myCode,code:integer;myEdit:Tedit):boolean;
var
 codePlaceNew: integer;
 msg,tmpStr: string;
begin
 result:=false;
 codePlaceNew:=checkCode(code,codeStrNew);
 if ((codePlaceNew>0) and (myCode<>codePlaceNew)) then  {code already in use}
  begin
   tmpStr:=FNsubname(codePlaceNEW,code);
   msg:='The code '+FNsub(codePlaceNEW,code)+' is already used';
   if tmpStr<>'' then msg:=msg+' for '+tmpStr;
   msg:=msg+'.'+endline+'Please enter a different code.';
   ShowMsg(msg,myEdit);
   result:=true;
  end;
end;

function CodeUsed(var codePlace:integer;code:smallint;var codeStr:string;myEdit:Tedit):boolean;
var
  tmpStr, msg: string;
begin
  Result := False;
  codeStr := Trim(codeStr);
  codePlace := checkCode(code, codeStr);
  if codePlace > 0 then     {code already in use}
  begin
    tmpStr := FNsubname(codePlace, code);
    msg := 'The code ' + FNsub(codePlace, code) + ' is already being used';
    if tmpStr <> '' then msg := msg + ' for '+tmpStr;
    msg := msg + '.' + endline;
    msg := msg + 'Please enter a different code.';
    ShowMsg(msg, myEdit);
    Result := True;
  end;
end;

function checkWildCode(var codeStr: string; msgLabel: Tlabel; useMsg: bool): smallint;
var
 j:     smallint;
 tmpStr: string;
begin
 j:= checkWildSub(codeStr);
 result:=j;
 if useMsg then begin
  tmpStr:='Enter Subject code';
  if j>0 then tmpStr:=SubCode[j]+' '+Subname[j];
  if j<0 then tmpStr:='All '+uppercase(copy(codeStr,1,lencodes[0]-1))+' Subjects';
  msgLabel.caption:=tmpStr;
 end;
end;

function checkwildYearSub(codeStr: string; msgLabel: Tlabel; useMsg: bool): smallint;
var
 foundpos,foundyearpos:     smallint;
begin
 foundyearpos:=0;
 codeStr:=trim(codeStr);
 validatecode(0,codestr);
 foundpos:=checkWildcode(codestr,msgLabel,useMsg);
 result:=foundpos;
 if (foundpos>0) and (GroupSubs[0]>0) then foundyearpos:=findsubyear(foundpos);
 if useMsg and (foundyearpos>0) then msgLabel.caption:=
   msgLabel.caption+' '+inttostr(GroupSubCount[foundyearpos]);
end;

procedure insertfaculty(ebox: Tedit);
var
 facStr:        string;
 facPlace,pos:  smallint;
begin
 facStr:=ebox.text;   facStr:=trim(facStr);
 if length(facStr)<3 then exit;
 facPlace:=checkFaculty(facStr);
 if facPlace>0 then
 begin
  pos:=ebox.selstart;
  ebox.text:=facName[facPlace];
  ebox.selstart:=pos;
 end;
end;

function findDayMsg(s: string;msgLabel: Tlabel): smallint;
var
 i:  smallint;
begin
 i:=FindDay(s);
 if i=-1 then msgLabel.caption:='Enter Day'
  else msgLabel.caption:=Dayname[i];
 result:=i;
end;

function findYearname(enteredTxt: string; msgLabel: Tlabel): smallint;
var
 aStr,bStr:   string;
 i,j,aLen,bLen,mLen:       smallint;
begin
 aStr:=UpperCase(trim(enteredTxt));
 aLen:=Length(aStr);   j:=-1;   mLen:=99;
 if aLen>0 then
  for i:=0 to years_minus_1 do
  begin
   bStr:=UpperCase(trim(yearname[i]));
   bLen:=length(bStr);
   bStr:=copy(bStr,1,aLen);
   if aStr=bStr then
   begin
    if bLen<=mLen then
    begin
     mLen:=bLen;  //keep only minimum match
     j:=i;
     if aLen=bLen then break;  //continue search unless perfect match found
    end;
   end;
  end; {for i}
 if j>-1 then
  msgLabel.caption:=yearname[j]
 else
  msgLabel.caption:='Enter a '+yeartitle;
 result:=j;
end;

function findFaculty(enteredTxt: string; msgLabel: Tlabel): smallint;
var
 aStr,bStr:   string;
 i,j,aLen:       smallint;
begin
 aStr:=UpperCase(trim(enteredTxt));
 aLen:=Length(aStr);   j:=0;
 if aLen>0 then
  for i:=1 to facNum do
  begin
   bStr:=UpperCase(copy(facName[i],1,aLen));
   if aStr=bStr then
   begin
    j:=i;
    break;
   end;
  end; {for i}
 if j>0 then
  msgLabel.caption:=facName[j]
 else
  msgLabel.caption:='Enter Faculty name';

 result:=j;
end;

function getLevel(myYear: integer; enteredTxt: string; msgLabel: Tlabel): smallint;
var
 aStr:   string;
 j:       smallint;
begin
 aStr:=trim(enteredTxt);
 j:=strtointdef(aStr,0);
 if (myYear<0) or (myYear>years_minus_1) then myYear:=years_minus_1;
 if (j<1) or (j>level[myYear]) then
  begin
   msgLabel.caption:='Enter Level (1-'+inttostr(level[myYear])+')';
   j:=0;
  end
   else msgLabel.caption:='Level '+aStr;
 result:=j;
end;

function IntFromEdit(myEdit: Tedit):integer;
var
 aStr:   string;
 j:       integer;
begin
 aStr:=trim(myEdit.Text);
 j:=strtointdef(aStr,0);
 result:=j;
end;

function getTimeSlot(myDay: integer; enteredTxt: string; msgLabel: Tlabel): smallint;
var
 aStr:   string;
 j:       smallint;
begin
 aStr:=trim(enteredTxt);
 j:=strtointdef(aStr,0);
 if (myDay<0) or (myDay>=days) then myDay:=0;
 if (j<1) or (j>Tlimit[myDay]) then
  begin
   msgLabel.caption:='Enter Time Slot (1-'+inttostr(Tlimit[myDay])+')';
   j:=0;
  end
   else msgLabel.caption:=TimeSlotName[myDay,j-1];
 result:=j-1;
end;

function findWSblock(enteredTxt: string; msgLabel: Tlabel): smallint;
var
 aStr:   string;
 j:       smallint;
begin
 aStr:=trim(enteredTxt);
 j:=strtointdef(aStr,0);
 if (j<1) or (j>wsBlocks) then
  begin
   j:=0;
   msgLabel.caption:='Enter Block';
  end
   else msgLabel.caption:='Block '+inttostr(j);
 result:=j;
end;

function findTag(enteredTxt: string; msgLabel: Tlabel): smallint;
var
 aStr:   string;
 i,j:       smallint;
begin
 j:=0;
 aStr:=trim(enteredTxt);
 for i:=1 to nmbrTags do
  if aStr=TagCode[i] then j:=i;
 if j>0 then
  msgLabel.caption:=TagCode[j]+' '+TagName[j]
 else
  msgLabel.caption:='Enter Tag code';
 result:=j;
end;

function findRoom(enteredTxt: string; msgLabel: Tlabel): smallint;
var
 aStr:   string;
 j,aLen:       smallint;
begin
 aStr:=UpperCase(trim(enteredTxt));
 aLen:=Length(aStr);   j:=0;
 if aLen>0 then j:=CheckCode(2,aStr);
 if j>0 then
  msgLabel.caption:=XML_TEACHERS.TeCode[j,1]+' '+XML_TEACHERS.TeName[j,1]
 else
  msgLabel.caption:='Enter room code';
 result:=j;
end;

function findHouse(enteredTxt: string; msgLabel: Tlabel): smallint;
var
 aStr,bStr:   string;
 i,j,aLen,bLen,mLen:       smallint;
begin
 aStr:=UpperCase(trim(enteredTxt));
 aLen:=Length(aStr);   j:=0;  mLen:=99;
 if aLen>0 then
  for i:=1 to housecount do
  begin
   bStr:=UpperCase(trim(HouseName[i]));
   bLen:=length(bStr);
   bStr:=copy(bStr,1,aLen);
   if aStr=bStr then
   begin
    if bLen<=mLen then
    begin
     mLen:=bLen;  //keep only minimum match
     j:=i;
     if aLen=bLen then break;  //continue search unless perfect match found
    end;
   end;
  end; {for i}
 if j>0 then
  msgLabel.caption:=HouseName[j]
 else
  msgLabel.caption:='Enter house name';

 result:=j;
end;

function findClass(enteredTxt: string; msgLabel: Tlabel): smallint;
var
 j:       smallint;
begin
 j:=findClass2(enteredTxt);
 if j>0 then
  msgLabel.caption:=ClassCode[j]
 else
  msgLabel.caption:='Enter class name';
 result:=j;
end;

function findTe(enteredTxt: string; msgLabel: Tlabel): smallint;
var
 aStr:   string;
 j,aLen:       smallint;
begin
 aStr:=UpperCase(trim(enteredTxt));
 aLen:=Length(aStr);   j:=0;
 if aLen>0 then j:=checkCode(1,aStr);
 if j>0 then
  msgLabel.caption:=XML_TEACHERS.TeCode[j,0]+' '+XML_TEACHERS.TeName[j,0]
 else
  msgLabel.caption:='Enter teacher code';
 result:=j;
end;

procedure allocateStudChoices(myEdit9: tpEdit9; msgLabel: Tlabel);
var
 error,count,code: smallint;
 g,k1,a,b:         smallint;
 gmxi:             integer;
 k,j,l,ab,aas:     smallint;
 subStr,msg:       string;
 found,pos:        smallint;
 subject:          smallint;
 HasSubInBlock,overflow: boolean;
 store:            array[0..2*nmbrChoices] of smallint;

    function checkSplitSubs: smallint;
    var
     stmin,j,a3:     smallint;
     stra,strb:              string;
    begin
     subject:=0;   stmin:=6000;
     stra:=copy(SubCode[a],1,lencodes[0]-1);
     for j:=1 to Sheet[b,0] do
     begin
      strb:=copy(SubCode[Sheet[b,j]],1,lencodes[0]-1);
      if stra=strb then
      begin
       a3:=GroupSubCount[GsubXref[Sheet[b,j]]];
       if a3<stmin then
       begin
        stmin:=a3;
        subject:=Sheet[b,j];
       end;
      end;
     end; {for j}
     result:=subject;
    end; {local proc}


begin           {start of main allocate proc}
 error:=0;  count:=0;   code:=0; HasSubInBlock:=false;  overflow:=false;
 for g:=1 to nmbrChoices do
 begin
  XML_STUDENTS.Stud[0].choices[g]:=0;
  subStr:=trim(myEdit9[g].text);
  if subStr>'' then
  begin
   found:=CheckCode(code,subStr);
   if boolean(found) then
   begin
    inc(count);
    XML_STUDENTS.Stud[0].choices[count]:=found;
   end
   else
    begin
     error:=-1;
     msgLabel.caption:='Check Subject!';
     msgLabel.visible:=true;
     myEdit9[g].setfocus;
     myEdit9[g].selectall;
     break;
    end;
  end;
 end; {for g}
 if count=0 then exit;
 if boolean(error) then
 begin
  for g:=1 to nmbrChoices do
   XML_STUDENTS.Stud[0].choices[g]:=0;
  exit;
 end;
 for g:=1 to count do
 begin
  a:=XML_STUDENTS.Stud[0].choices[g];
  pos:=GsubXref[a];
  if Blocktop[pos]=a then
  begin
   for b:=1 to XML_DISPLAY.blocknum do
   begin
    found:=checkSplitSubs;
    if boolean(found) then
    begin
     XML_STUDENTS.Stud[0].choices[g]:=found;
     break;
    end;
   end; {for b}
  end;
 end; {for g}
 GetStClashes(0);
 k1:=ClashOrder[1];
 // for g:=1 to nmbrChoices do Stud[0].choices[g]:=BlClash[k1,g];    // range check error!!!
 for g:=1 to nmbrBlocks do XML_STUDENTS.Stud[0].choices[g]:=BlClash[k1,g];
 for k:=1 to nmbrChoices do store[k]:=0;
 ab:=1;
 for j:=1 to nmbrChoices do
 begin
  aas:=XML_STUDENTS.Stud[0].choices[j];
  if aas<>0 then
  begin
   for k:=1 to XML_DISPLAY.blocknum do
   begin
    for l:=1 to XML_DISPLAY.blocklevel do
    begin
     if ((aas=Sheet[k,l]) and (store[k]=0)) then
     begin
      store[k]:=aas;
      HasSubInBlock:=true;
      aas:=0;
      break;
     end;
    end; {for l}
    if aas=0 then break;
   end; {for k}
   if (aas>0) then
   begin
    store[ab+XML_DISPLAY.blocknum]:=aas;
    if ((ab+XML_DISPLAY.blocknum)>nmbrChoices) then overflow:=true;
    inc(ab);
   end;
  end;
 end; {for j}
 if HasSubInBlock and not(overflow) then
  try
   for gmxi:=1 to nmbrchoices do
    begin
     if store[gmxi]>0 then
      myEdit9[gmxi].text:=SubCode[store[gmxi]]
     else
      myEdit9[gmxi].text:='';
    end;
  except
   dbgi:=99;
  end;
 if MyBlSolution=0 then
  begin
   msgLabel.caption:='No block allocation found!';
   msgLabel.visible:=true;
   exit;
  end;
 try
  if BlPartial then msg:='Part Allocation found' else msg:='Allocation Completed!';
  msgLabel.caption:=msg;
  msgLabel.visible:=true;
 except
  dbgi:=87;
 end;
end;

function findChoice(enteredTxt: string; msgLabel: Tlabel; useMsg: bool): smallint;
var
 aStr:   string;
 found,yearfound,aLen:       smallint;
begin
 aStr:=trim(enteredTxt);
 aLen:=Length(aStr);
 found:=0; yearfound:=0;
 if aLen>0 then
  begin
   found:=checkCode(0,aStr);
   if found>0 then yearfound:=findsubyear(found);
  end;

 if useMsg then
  begin
   if (found>0) and (found<>subNA) then
    begin
     aStr:=SubCode[found]+' '+Subname[found];
     {only give count if in groupsub}
     if yearfound<>0 then
      aStr:=aStr+' '+inttostr(GroupSubCount[GsubXref[found]])
     else aStr:=aStr+' 0';
    end
   else
    aStr:='Enter Subject code';
   msgLabel.caption:=aStr;
  end;

 result:=found;
end;

procedure allowNumericInputOnly(var key: char);
begin
 if (key<'0') or (key>'9') then if ord(key)>32 then key:=chr(0);
end;

procedure allowdecimalInputOnly(var key: char);
begin
 if ((key<>'.') and ((key<'0') or (key>'9'))) then if ord(key)>32 then key:=chr(0);
end;

end.
