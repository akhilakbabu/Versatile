unit StripRooms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, StrUtils, Grids, TimeChartGlobals, GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  TStripRoomsDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label3: TLabel;
    Finish: TBitBtn;
    FillBtn: TBitBtn;
    BitBtn3: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    CheckBox6: TCheckBox;
    find: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FillBtnClick(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure findClick(Sender: TObject);
  private
    procedure UnfilledRoomCount;
  end;

var
  StripRoomsDlg: TStripRoomsDlg;

implementation
{$R *.dfm}

uses tcload, tcommon, tcommon2, dlgcommon, ttable, ttundo, stcommon;

type
 tpRneedPos = record
    d: byte;
    p: byte;
    y: byte;
    l: byte;
  end;


var
  roFree: array[0..nmbrteachers,0..nmbrDays] of integer;
  fsYear,fsSub,fsTeach,fsFac,rmNum: integer;
  AvaRo: array[0..nmbrDays,0..nmbrPeriods,0..nmbrTeachers] of smallint;
  ReqRo: array[0..nmbrDays,0..nmbrPeriods] of smallint;
  startYear,endYear : smallint;
  fsAction: array[0..4] of boolean;   {fill or strip action}
  fsFree: array[0..nmbrTeachers] of smallint;
  StripFreeS: array[0..nmbrSubjects] of smallint;
  fsUpdate: boolean;
  rpos1,rposNext: tpRneedPos;
  HasPos1,HasPosCurrent,HasPosNext: boolean;

function noTTroom(d,p,y,l: integer):boolean;
begin
 result:= (FNT(d,p,y,l,4)^=0) and (((FNT(d,p,y,l,0)^>0) and
  (FNT(d,p,y,l,0)^<=NumCodes[0])) or (FNT(d,p,y,l,2)^>0));
end;



procedure TStripRoomsDlg.UnfilledRoomCount;
var
 d,p,y,l: integer;
 CurrentPos,GotPos: boolean;

  procedure SetPos(var myFlag:boolean; var myPos:tpRneedPos);
  begin
   myFlag:=true;
   myPos.d:=d; myPos.p:=p; myPos.y:=y; myPos.l:=l;
  end;

begin
 rmNum:=0;
 HasPos1:=false; HasPosCurrent:=false; HasPosNext:=false;
 for y:=years_minus_1 downto 0 do
  for l:=1 to level[y] do
   for d:=0 to days-1 do
    for p:=0 to Tlimit[d]-1 do
     begin
      GotPos:=noTTroom(d,p,y,l);
      CurrentPos:=((d=nd) and (p=np) and (y=ny) and (l=nl));
      if GotPos then
       begin
        inc(rmNum) ;
        if CurrentPos then
         begin
          HasPosCurrent:=true;
          continue;
         end;
        if not(HasPosCurrent) and not(HasPos1) then SetPos(HasPos1,rpos1);
        if HasPosCurrent and not(HasPosNext) then SetPos(HasPosNext,rposNext);
       end;
     end;
 label5.Caption:=inttoStr(rmNum);
 Find.Enabled:=(rmNum>1) or ((rmNum=1) and not(HasPosCurrent));
end;



function RoIsFree(ro,d,p: integer):boolean;
begin
 result:=((roFree[ro,d] AND (1 shl p))=0)
end;


procedure ClearFsFree;
var
 i: integer;
begin
 for i:=0 to nmbrTeachers do fsFree[i]:=0;
end;


procedure PutInRoom(d,p,y,l: integer; ro: smallint);
var
 su: smallint;
begin
 if XML_DISPLAY.fsDoRoomCap then
  begin
   su:=FNT(d,p,y,l,4)^;
   if (su>0) and (su<=numCodes[0]) then
    if GroupSubCount[GsubXref[su]]>XML_TEACHERS.RoSize[ro] then exit; {don't add room}
  end;
 FNT(d,p,y,l,4)^:=ro;
 fsUpdate:=true; fclash[d,p]:=1;
 roFree[ro,d]:=(roFree[ro,d] OR (1 shl p));
end;

procedure CalcTeFree;
var
 i,y,d,p,l,ro: smallint;
begin
 for i:=1 to nmbrTeachers do
  for d:=0 to days-1 do roFree[i,d]:=0;

 for d:=0 to days-1 do
  for p:=0 TO Tlimit[d]-1 do
   begin
    for y:=0 to years_minus_1 do
     for l:=1 to level[y] do
      begin
       ro:=FNT(d,p,y,l,4)^;
       if (ro>0) and (ro<=NumCodes[2]) then
          roFree[ro,D]:=roFree[ro,D] or (1 shl p);
      end;
   end;
end;





function GotMatchWildsub(gplace1, gplace2: integer): boolean;
var
 A,B: string;
 place1,place2: integer;
begin
 result:=false;
 A:=''; B:='';
 place1:=ABS(gplace1); place2:=ABS(gplace2);
 if (place1>NumCodes[0]) or (place2>NumCodes[0]) then exit;
 if (gplace1>0) then A:=Subcode[gplace1];
 if (gplace2>0) then B:=Subcode[gplace2];
 if (gplace1<0) or (gplace2<0) then
  begin
   A:=copy(Subcode[place1],1,lencodes[0]-1);
   B:=copy(Subcode[place2],1,lencodes[0]-1);
  end;
 if ((A<>'') and (B<>'') and (A=B)) then result:=true;
end;


procedure getReqRoomsForSub(su: integer);
var
 d,Y,L,P: integer;
begin
 for d:=0 TO days-1 do
  for p:=0 TO Tlimit[d]-1 do
   begin
    ReqRo[d,p]:=0;
    for y:=startyear downto endyear do
     for l:=1 TO level[y] do
      if (su>0) and (FNT(D,P,Y,L,0)^=su) and (FNT(D,P,Y,L,4)^=0)
         then ReqRo[d,p]:=ReqRo[d,p]+1;
   end; {for p}
end;


procedure getAvaRoomsForSub(su: integer);
var
  D,P,K,J: integer;
  CanFit: boolean;
begin
 for d:=0 to days-1 do
  for P:=0 to Tlimit[d]-1 do
   begin
    AvaRo[d,p,0]:=0;
    if fsFree[0]>0 then
     for k:=1 to fsFree[0] do
      begin
       J:=fsFree[K];
       CanFit:=not(XML_DISPLAY.fsDoRoomCap) or (GroupSubCount[GsubXref[su]]<=XML_TEACHERS.RoSize[J]);
       if RoIsFree(j,d,p) and Canfit then
        begin
         AvaRo[D,P,0]:=AvaRo[D,P,0]+1;
         AvaRo[D,P,AvaRo[D,P,0]]:=J;
        end;
     end;{for k}
  end;  {for p}
end;


procedure AddRoomsToSub(su: integer);
var
 j,D,P,Y,L,k,M,Q,Qi: integer;
 LMatchCnt: integer;
 LMatchD: array [0..150] of integer;
 LMatchP: array [0..150] of integer;
 Dfct,DfctPds,ActRqd,DD,MssCnt: integer;
begin
 getReqRoomsForSub(su);      // set ReqRo(D,P)
 getAvaRoomsForSub(su);                  // set AvaRo(D,P,0)
 for y:=startyear downto endyear do
  for L:=1 to level[Y] do
   begin
    LMatchCnt:=0;    //  number of matches for sub on level
    {Dfct - deficit count, DfctPds - deficit periods,  ActRqd - rooms required
     for deficit periods }
    Dfct:=0; DfctPds:=0; ActRqd:=0; //check supply & demand

    for d:=0 TO days-1 do
     for P:=0 TO Tlimit[d]-1 do
      if (FNT(d,p,y,L,0)^=su) and (FNT(d,P,Y,L,4)^=0) then
        begin
         inc(LMatchCnt); LMatchD[LMatchCnt]:=D;
         LMatchP[LMatchCnt]:=P;
         DD:=ReqRo[d,p]-AvaRo[d,p,0];
         if DD>0 then
          begin
           inc(DfctPds); Dfct:=Dfct+DD;
           ActRqd:=ActRqd+ReqRo[d,p];
          end;
        end; {if (FNT(d,p,y,L,0)^=su) and (FNT(d,P,Y,L,4)^=0)}
// LMatchCnt now has how many periods the sub occurs
//  LMatchD + LMatchP store the D,P indexes for these
     if DfctPds>0 then   //   if some deficits present
      begin
       MssCnt:=(DfctPds*Dfct) div ActRqd;   //   how many to skip
       if MssCnt>0 then          //  skip specified number
        for M:=1 TO MssCnt do
         begin
          Q:=0; Qi:=1;
          for K:=1 TO LMatchCnt do   // find greatest deficit
           begin
            DD:=ReqRo[LMatchD[K],LMatchP[K]]-AvaRo[LMatchD[K],LMatchP[K],0];
            if DD>Q then
             begin
              Q:=DD; Qi:=K;
             end;
           end; {for k}
          if Qi<LMatchCnt then        //  then shuffle down
           for K:=Qi TO LMatchCnt-1 do
            begin
             LMatchD[K]:=LMatchD[K+1]; LMatchP[K]:=LMatchP[K+1];
            end;
          LMatchCnt:=LMatchCnt-1;
         end; {for m}
      end; {if DfctPds>0}
//    now want to simply fill all remaining level matches
     if LMatchCnt>0 then
      begin
       Q:=0; Qi:=0;
       for K:=1 TO fsFree[0] do // find room that can fill most of them
        begin
         J:=fsFree[K]; DD:=0;
         for M:=1 TO LMatchCnt do
          if RoIsFree(j,LMatchD[M],LMatchP[M]) then inc(DD);
         if DD>Q then begin Q:=DD; Qi:=J; end;
        end; {for k}
     //   'now fill with room Qi where can
       if Qi>0 then
        for M:=1 TO LMatchCnt do
         if RoIsFree(Qi,LMatchD[M],LMatchP[M]) then
          begin
           PutInRoom(LMatchD[M],LMatchP[M],Y,L,Qi);
           LMatchD[M]:=-1;    //  flag for removal
          end;
     //  remove those filled
       M:=0;
       for K:=1 TO LMatchCnt do
        if LMatchD[K]<>-1 then
         begin
          inc(M);
          LMatchD[M]:=LMatchD[K];
          LMatchP[M]:=LMatchP[K];
         end;
       LMatchCnt:=M;
      //  'then fill rest with any
       if LMatchCnt>0 then
        for K:=1 TO LMatchCnt do
         for M:=1 TO fsFree[0] do
          begin
           J:=fsFree[M];
           if RoIsFree(j,LMatchD[K],LMatchP[K]) then
            begin
             PutInRoom(LMatchD[K],LMatchP[K],Y,L,J);
             break;
            end;
          end; {for m}
      //  'all done
      end;  {if LMatchCnt>0}
    end;  {for L}
end;

procedure FillSingleSubRooms;  {adds rooms with rassign positive}
var
 i,j,su,L,k: integer;
 DoneRo: array [0..nmbrTeachers] of boolean;
begin
 for k:=1 to nmbrTeachers do DoneRo[k]:=false;
 for i:=1 to codeCount[2] do
  begin
   j:=codepoint[i,2];  {step through rooms}
   su:=rassign[j];   {su is subject assigned to j}
   if not(DoneRo[J]) then    //haven't already done this one
    begin
     fsFree[0]:=0;
     if (rotype[j]=rtSub) and (su>0) then  {only if single subject assigned}
      if ((fsSub=0) or GotMatchWildsub(fsSub,su)) then
       begin
        fsFree[0]:=1; fsFree[1]:=j; DoneRo[j]:=true; //don't redo room later on
        if i<codeCount[2] then
         for k:=i+1 to codeCount[2] do
          begin
           L:=codepoint[k,2];
           if (rotype[L]=rtSub) and (rassign[L]=su) then
            begin
             inc(fsFree[0]);
             fsFree[fsFree[0]]:=L;
             DoneRo[L]:=true;
            end;
          end; {for k}
  //fsFree stores rooms available for subject su
         AddRoomsToSub(su);
       end; {if ((fsSub=0) or (fsSub=su))}
    end;  {if not(DoneRo[J])}
  end; {for i}
end;


procedure FinalSweepRestRooms;
var
 L,K: integer;
 zY,zD,zP,zL: integer;
 su:smallint;
 canFit: boolean;
begin
 for zY:=endyear TO startyear do
  for zD:=0 TO days-1 do
   for zP:=0 TO Tlimit[zd]-1 do
    for zL:=1 TO level[zY] do
     begin
      if noTTroom(zd,zp,zy,zl) then
        for K:=1 TO codeCount[2] do
         begin
          L:=codepoint[K,2];
          if rotype[L]<>rtTTable then   //not timetable ones
           if RoIsFree(L,zd,zp) then
            begin
             canFit:=true;
             su:=FNT(zD,zP,zY,zL,0)^;
             if XML_DISPLAY.fsDoRoomCap then
              if (su>0) and (su<=numCodes[0]) then
               if GroupSubCount[GsubXref[su]]>XML_TEACHERS.RoSize[L] then canFit:=false;
             if canFit then
               begin
                PutInRoom(zD,zP,zY,zL,L);
                break;
               end;
            end;
         end;  {for k}
     end;  {for zL}
end;


procedure FillMainRestRooms;
var
  su,L,K: integer;
  zY,zD,zP,zL: integer;
begin
 for zY:=endyear to startyear do
  for zD:=0 TO days-1 do
   for zP:=0 TO Tlimit[zd]-1 do
    for zL:=1 TO level[zY] do
     if noTTroom(zd,zp,zy,zl) then
      begin
       su:=FNT(zD,zP,zY,zL,0)^;
       fsFree[0]:=0;
       for K:=1 TO codeCount[2] do
        begin
         L:=codepoint[K,2];
         if rotype[L]<>rtTTable then   //not timetable type
          begin
           inc(fsFree[0]); fsFree[fsFree[0]]:=L;
          end;
        end; {for k}
       AddRoomsToSub(su);
      end;  {if noTTroom}
end;


procedure getMatchingSubs(su: integer);
var
 k,j: integer;
begin
 StripfreeS[0]:=0;
 if (fsSub>0) and (fsSub<=NumCodes[0]) then
  begin  {only match on subject code set}
   StripfreeS[0]:=1;
   StripfreeS[1]:=fsSub;
   exit;
  end;
 for k:=1 TO codeCount[0] do
  begin
   j:=codepoint[k,0];
   if GoTMatchWildsub(j,su) then
    begin
     inc(StripfreeS[0]);
     StripfreeS[StripfreeS[0]]:=j;
    end;
  end; {for k}
end;


procedure FillWildRooms;   {adds rooms with rassign negative}
var
 I,J,su,L,K:integer;
 WS: integer;
 DoneRo: array[0..nmbrTeachers] of boolean;
begin
 for K:=1 TO codeCount[2] do
  begin
   J:=codepoint[K,2];
   DoneRo[J]:=false;
  end;
 for I:=1 TO codeCount[2] do  {step through rooms}
  begin
   J:=codepoint[I,2];
   if not(DoneRo[J]) then       //haven't already done this one
    begin
     fsFree[0]:=0;
     if (rotype[J]=rtSub) and (rassign[J]<0) then  {wildcard subject}
      begin
       su:=rassign[J];
       if ((fsSub=0) or GotMatchWildsub(fsSub,su)) then
        begin
         fsFree[0]:=1; fsFree[1]:=J; DoneRo[J]:=true;  //don't redo room later on
         if I<codeCount[2] then
          for K:=I+1 TO codeCount[2] do
           begin
            L:=codepoint[K,2];
            if (rotype[L]=rtSub) and GotMatchWildsub(rassign[L],su) THEN
             begin
              inc(fsFree[0]); fsFree[fsFree[0]]:=L;
              DoneRo[L]:=true;
             end;
           end; {for k}
         getMatchingSubs(su);   //get list of subs which match wildcard
         if StripfreeS[0]>0 then
          for WS:=1 TO StripfreeS[0] do
           begin
            su:=StripfreeS[WS];
            AddRoomsToSub(su);
           end;  {for WS}
        end;  {if ((fsSub=0) OR (fsSub=su))}
      end;  {if (rotype[J]=rtSub) AND (rassign[J]<0)}
    end; {if DoneRo[J]=false}
  end; {for i}
end;



procedure getMatchingFacSubs(su: integer);
var
 K,J: integer;
begin
 StripfreeS[0]:=0;
 for K:=1 TO codeCount[0] do
  begin
   J:=codepoint[K,0];
   if FindSubInFac(su,J) then
    begin
     inc(StripfreeS[0]);
     StripfreeS[StripfreeS[0]]:=J;
    end;
  end;
end;


procedure FillFacRooms;
var
 I,J,su,myFac,L,K,WS: integer;
 DoneRo: array[0..nmbrTeachers] of boolean;
begin
 for K:=1 TO codeCount[2] do
  begin
   J:=codepoint[K,2];
   DoneRo[J]:=false;
  end;
 for I:=1 TO codeCount[2] do  {step through rooms}
  begin
   J:=codepoint[I,2];
   if not(DoneRo[J]) then        //haven't already done this one
    begin
     fsFree[0]:=0;
     if (rotype[J]=rtFac) and (rassign[J]>0) then
      begin
       myFac:=rassign[J];
       if ((fsFac=0) OR (fsFac=myFac)) then
        begin
         fsFree[0]:=1; fsFree[1]:=J; DoneRo[J]:=true;
         if I<codeCount[2] then
          for k:=I+1 TO codeCount[2] do
           begin
            L:=codepoint[K,2];
            if (rotype[L]=rtFac) and (rassign[L]=myFac) then
             begin
              inc(fsFree[0]); fsFree[fsFree[0]]:=L; DoneRo[L]:=true;
             end;
           end;
         getMatchingFacSubs(myFac);       //get list of subs which match fac
         if StripfreeS[0]>0 then
          for WS:=1 TO StripfreeS[0] do
           begin
            su:=StripfreeS[WS];
            AddRoomsToSub(su);
           end;  {for WS}
        end;  {if ((fsFac=0) OR (fsFac=su))}
      end;  {if (rotype[J]=rtFac)}
    end; {if DoneRo[J]=false}
  end; {for I}
end;


procedure FillTeachRooms;
var
 I,J,te,D,P,Y,L: integer;
begin
 ClearFsFree;
 for I:=1 TO codeCount[2] do {go through all rooms}
  begin
   J:=codepoint[I,2]; te:=rassign[J];
   if (rotype[J]=rtTeach) and (te>0) and (te<=Numcodes[1])
     and ((fsTeach=0) or (fsTeach=te)) then fsFree[rassign[J]]:=J;
  end;

 for D:=0 TO days-1 do  {search timetable once}
  for P:=0 TO Tlimit[d]-1 do
   for Y:=startyear downTO endyear do
    for L:=1 TO level[Y] do
     begin
      te:=FNT(D,P,Y,L,2)^;
      if (te>0) and (te<=Numcodes[1]) then {only if teacher code in range}
       begin
        J:=fsFree[te];
        if (J>0) then  {room assigned}
         if RoIsFree(j,d,p) then  {room is available}
          if (FNT(D,P,Y,L,4)^=0) then PutInRoom(D,P,Y,L,J); {no current room}
        end;
     end; {for L}
end;


procedure StripRoomsFromTT; 
var
 Y,D,P,L: integer;
  ro: integer;
  RemoveRoom: boolean;
begin
 for Y:=startyear downTO endyear do
  for L:=1 TO level[Y] do
   for d:=0 TO days-1 do
    for P:=0 TO Tlimit[d]-1 do
     begin
      ro:=FNT(D,P,Y,L,4)^;
      if (ro>0) then
       if fsAction[rotype[ro]] then
        begin
         RemoveRoom:=false;
         case rotype[ro] of
 {none}   0:  RemoveRoom:=true;
 {sub}    1: if GoTMatchWildsub(fsSub,rassign[ro]) OR (fsSub=0)
               then RemoveRoom:=true;
 {teach}  2: if (fsTeach=0) OR (fsTeach=rassign[ro]) THEN RemoveRoom:=true;
 {fac}    3: if (fsFac=0) OR (fsFac=rassign[ro]) then RemoveRoom:=true;
 {ttable} 4: RemoveRoom:=true;
         end;
         if RemoveRoom then
          begin
           FNT(D,P,Y,L,4)^:=0;
           fsUpdate:=true;
           fclash[D,P]:=1;
          end;
        end; {if fsAction[rotype[ro]]<>0}
     end; {for P}
end;




procedure TStripRoomsDlg.FormCreate(Sender: TObject);
begin
 FillComboYears(true,ComboBox1);
 combobox1.itemindex:=0;
 edit1.text:=''; edit2.text:=''; edit3.text:='';
 fsSub:=0; fsTeach:=0; fsFac:=0;
 UnfilledRoomCount;
 CountGroupSubs;
 case fillRoom_action of
  1: begin  {fill rooms}
      label1.caption:='Fill timetable rooms';
      groupbox1.caption:='Fill Room Selection';
      FillBtn.caption:='&Add';
      HelpContext:=379;
      caption:='Fill Rooms';
      checkbox3.Hint:='Add room assigned to teacher';
      checkbox2.Hint:='Add room assigned to subject';
      checkbox4.Hint:='Add rooms assigned to faculty';
      checkbox1.Hint:='Add available rooms unless assigned to timetable';
      checkbox5.visible:=false;
      checkbox6.visible:=true;
      find.Visible:=true;
      checkbox6.Checked:=XML_DISPLAY.fsDoRoomCap;
     end;
  2: begin  {strip rooms}
      label1.caption:='Remove timetable rooms';
      groupbox1.caption:='Strip Room Selection';
      FillBtn.caption:='&Remove';
      HelpContext:=380;
      FillBtn.Hint:='Remove rooms';
      caption:='Strip Rooms';
      checkbox3.Hint:='Remove room assigned to teacher';
      checkbox2.Hint:='Remove room assigned to subject';
      checkbox4.Hint:='Remove rooms assigned to faculty';
      checkbox1.Hint:='Remove unassigned rooms';
      checkbox5.Hint:='Remove rooms assigned to timetable';
      checkbox5.visible:=true;
      checkbox6.Visible:=false;
     end;
 end;
end;



procedure TStripRoomsDlg.FillBtnClick(Sender: TObject);
var
 codeStr:       string;
begin
 CalcTeFree;   fsUpdate:=false;
 fsAction[0]:=checkbox1.checked;
 fsAction[1]:=checkbox2.checked;
 fsAction[2]:=checkbox3.checked;
 fsAction[3]:=checkbox4.checked;
 fsAction[4]:=checkbox5.checked;
 fsYear:= combobox1.ItemIndex-1;
 if fsYear=-2 then
  begin
   ComboMsg('Check '+yeartitle,combobox1);
   exit;
  end;
 if fsAction[1] then
  begin
   codeStr:=trim(Edit1.Text);
   if CodeStr='' then fsSub:=0 else
      if WildSubNotFound(fsSub,Edit1,label3) then exit;
  end;
 if fsAction[2] then
  begin
   codeStr:=trim(Edit2.Text);
   if CodeStr='' then fsTeach:=0 else
      if CodeNotFound(fsTeach,1,Edit2)then exit;
  end;
 if fsAction[3] then
  begin
   codeStr:=trim(Edit3.Text);
   if CodeStr='' then fsFac:=0 else
      if FacNotFound(fsFac,Edit3) then exit;
  end;

 if (fsYear>=0) and (fsYear<years) then
  begin startyear:=fsYear; endyear:=fsYear; end
 else begin startYear:=years_minus_1; endYear:=0; end;

 case fillRoom_action of
  1:begin   //Fill
     pushAllTtStack(utRoomFill);
     if fsAction[2] then FillTeachRooms; {fill teachers}
     if fsAction[1] then {fill subjects}
      begin
       FillSingleSubRooms;
       FillWildRooms;
      end;
     if fsAction[3] then FillFacRooms; {fill faculties}
     if fsAction[0] then {fill all remaining}
       begin
        FillMainRestRooms;
        FinalSweepRestRooms;
       end;
    end;
  2:begin   //Strip
     pushAllTtStack(utRoomStrip);
     StripRoomsFromTT;
    end;
 end;
 if fsUpdate then
  begin
   UnfilledRoomCount;
   ttclash;  SaveTimeFlag:=True;
   UpdateTimetableWins;
  end;
end;

procedure TStripRoomsDlg.CheckBox6Click(Sender: TObject);
begin
 XML_DISPLAY.fsDoRoomCap:=CheckBox6.Checked;
end;

procedure setSelectedCell;
var
 CurRow,CurCol: integer;
 Srect: TGridRect;
begin
 CurRow:=FindRow(ny,nl);
 CurCol:=FindCol(nd,np);
 Srect.top:=CurRow; Srect.bottom:=CurRow;
 Srect.left:=CurCol; Srect.right:=CurCol;
 Ttablewin.StringGrid1.selection:=Srect;
end;


procedure TStripRoomsDlg.findClick(Sender: TObject);
begin
 if HasPosNext then
  begin
   nd:=rposNext.d; np:=rposNext.p; ny:=rposNext.y; nl:=rposNext.l;
   setSelectedCell;
   BringIntoView;
  end
 else
  if HasPos1 then
   begin
    nd:=rpos1.d; np:=rpos1.p; ny:=rpos1.y; nl:=rpos1.l;
    setSelectedCell;
    BringIntoView;
   end;
 UnfilledRoomCount;
end;

end.
