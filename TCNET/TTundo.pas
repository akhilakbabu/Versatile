unit TTundo;

interface

uses SysUtils,TimeChartGlobals, GlobalToTcAndTcextra, XML.TEACHERS;

type ttCell = record
               cellD: byte;
               cellP: byte;
               cellY: byte;
               cellL: byte;
               sub: smallint;
               te: smallint;
               ro: smallint;
               flgs: smallint;
               lab: string;   //label string
              end;

type tpUndoRec = record
                  NumCells: integer;
                  Cell: array of ttCell;
                  UndoType: integer;
                 end;

var
 ttStack: array of tpUndoRec;

const
{undo types  NB ut prefix also used for user types, make sure no overlap}
 utConfigVers=0;
 utCut=1;
 utClear=2;
 utPaste=3;
 utDelete=4;
 utCopyBlocks=5;
 utEditEntry=6;
 utClearEntry=7;
 utInsertLevel=8;
 utDeleteLevel=9;
 utReplace=10;
 utSwapBlock=11;
 utSwapTeach=12;
 utSwapRoom=13;
 utNumBlock=14; // not used in TC6
 utBuildCopy=15;
 utBuildClear=16;
 utBoxClear=17;
 utBoxMove=18;
 utBoxSwap=19;
 utBoxCopy=20;
 utSolve=21;
 utConfigLev=22;
 utConfigBlk=23;
 utClassShown=24;
 utSetHome=25;
 utReplaceAll=26;
 utEditWSentry=27;
 utWSmultiple=28;
 utRoomFill=29;
 utRoomStrip=30;
 utWSclear=31;
 utWScut=32;
 utWSdelete=33;
 utWSpaste=34;
 utWSinsertLevel=35;
 utWSDeleteLevel=36;

 procedure popTtStack(IsUndo: boolean);
 procedure pushOneTtStack(sD,sP,sY,sL,UndoOpTyp:smallint);
 procedure PushCell(d,p,y,l:smallint);
 procedure pushTtStack(sD,sP,sY,sL,eD,eP,eY,eL,UndoOpTyp:smallint);
 procedure PushTtStackStart(UndoOpTyp:smallint);
 procedure pushAllTtStack(UndoOpType:smallint);
 procedure PushInsertLevel(d1,p1,d2,p2,ay,al:smallint);
 procedure initTtUndoStack;
 function UndoHint: string;
 function RedoHint: string;
 procedure PushHome;
 procedure PushVersion;
 procedure pushLevels;
 procedure pushBlocks;
 procedure PushClassShown;
 procedure PushWScell(b,y,l:smallint);
 procedure pushWSstack(sB,sY,sL,eB,eY,eL,UndoOpTyp:smallint);  //add entry to stack
 procedure pushOneWSstack(sB,sY,sL,UndoOpTyp:smallint);
 procedure pushAllWSstack(UndoOpType:smallint);
 procedure PushWSinsertLevel(b1,b2,ay,al:smallint);
 procedure ttChangeRedo;
 procedure ttChangeUndo;


implementation
uses tcommon,tttoolbarwin,ttable,tcommon2, tcommon5, worksheet;

const
 nmbrTtStack=20;
 maxUndoOps=36;
 ttUndoOps: array [0..maxUndoOps] of string[20]=('Configure version','Cut entries',
 'Clear Timetable','Paste','Delete','Copy Blocks','Edit Entry','Clear Entry',
 'Insert Level','Delete Level','Replace', 'Swap Blocks','Swap Teachers',
 'Swap Rooms','Number Blocks', 'Build Copy','Build Clear','Clear','Move','Swap',
 'Copy','Solve','Configure levels','Configure blocks','Show classes','Set Home',
 'Replace All','Change Worksheet','Worksheet Multiple','Fill Rooms','Strip Rooms',
 'Clear Worksheet','Cut entries','Delete','Paste','Insert Level','Delete Level');


procedure ttChangeRedo;
begin
 if ttUndoPtr>=ttUndoMax then exit;  //already at top of stack
 if CheckAccessRights(utTime,16,true) then
  begin
   inc(ttUndoPtr);
   popTtStack(false);
   SaveTimeFlag:=true
  end;
end;



procedure ttChangeUndo;
begin
 if ttUndoPtr=0 then exit;  //already at base of stack
 if CheckAccessRights(utTime,16,true) then
  begin
   popTtStack(true);
   dec(ttUndoPtr);
   SaveTimeFlag:=true
  end;
end;




function HintDescribe(ptr,t:integer):string;
var
 astr,bstr,cstr,dstr: string;
 su,te,ro,count,d,p,y,l: integer;
begin
 astr:=''; bstr:=''; cstr:=''; dstr:='';
 count:=ttStack[ptr].NumCells;
 if count>0 then
  begin
   su:=ttStack[ptr].Cell[0].sub;
   te:=ttStack[ptr].Cell[0].te;
   ro:=ttStack[ptr].Cell[0].ro;
   d:=ttStack[ptr].Cell[0].cellD;
   p:=ttStack[ptr].Cell[0].cellP;
   y:=ttStack[ptr].Cell[0].cellY;
   l:=ttStack[ptr].Cell[0].cellL;
   if (su>0) and (su<NumCodes[0]) then bstr:=subcode[su]+' ';
   if (su>LabelBase) then bstr:=TcLabel[su-LabelBase]+' ';
   if te>0 then bstr:=bstr+XML_TEACHERS.tecode[te,0]+' ';
   if ro>0 then bstr:=bstr+XML_TEACHERS.tecode[ro,1];
   if count>1 then bstr:=bstr+' + ...';
   if (y>=0) and (y<=years_minus_1) then
    begin
     dstr:=yearshort+' '+yearname[y];
     if (l>0) and (l<=level[y]) then dstr:=dstr+' lev:'+inttostr(l);
    end;
   if (d>=0) and (d<days) then
    begin
     cstr:=day[d];
     if (p>=0) and (p<tlimit[d]) then cstr:=cstr+' '+TimeSlotName[d,p];
    end;
  end;
 case t of
  utCut,utDelete,utEditEntry,utClearEntry,utReplace,
   utBuildClear:astr:=bstr;
  utInsertLevel,utDeleteLevel:astr:=dstr;
  utBuildCopy,utBoxClear,utBoxMove,utBoxSwap,utBoxCopy:astr:=cstr+' '+dstr;
 end;
 result:=astr;
end;

function UndoHint: string;
var
 t: integer;
 astr: string;
begin
 result:='Can''t Undo'; ;
 if ttUndoPtr>0 then
  begin
   t:=ttStack[ttUndoPtr].UndoType;
   if ((t>=0) and (t<=maxUndoOps))
    then astr:='Undo '+ttUndoOps[t]+' '+HintDescribe(ttUndoPtr,t);
  end;
 result:=astr;
end;


function RedoHint: string;
var
 t: integer;
 astr: string;
begin
 astr:='Can''t Redo';
 if (ttUndoPtr<ttUndoMax) then
  begin
   t:=ttStack[ttUndoPtr+1].UndoType;
   if ((t>=0) and (t<=maxUndoOps)) then
     astr:='Redo '+ttUndoOps[t]+' '+HintDescribe(ttUndoPtr+1,t);
  end;
 result:=astr;
end;


procedure PushWSrange(sB,sY,sL,eB,eY,eL,UndoOpTyp:smallint);  //add entry to stack
var
 B,Y,L: integer;
 fromL,toL: smallint;
begin
 try
  if sB>eB then swapint(sB,eB);
  if sY>eY then swapint(sY,eY);
  if sL>eL then swapint(sL,eL);

  for B:=sB to eB do
   for Y:=sY to eY do
    begin
     if Y>sY then fromL:=1 else fromL:=sL;
     if Y<eY then toL:=LevelsUsed else toL:=eL;
     for L:=fromL to toL do PushWScell(B,Y,L);
    end; {for Y}
 finally
 end;
end;



procedure PushTtRange(sD,sP,sY,sL,eD,eP,eY,eL,UndoOpTyp:smallint);  //add entry to stack
var
 D,P,Y,L: integer;
 fromL,toL: smallint;
begin
 try
  if sD>eD then swapint(sD,eD);
  if sP>eP then swapint(sP,eP);
  if sY>eY then swapint(sY,eY);
  if sL>eL then swapint(sL,eL);

  for D:=sD to eD do
   for P:=sP to eP do
    for Y:=sY to eY do
     begin
      if Y>sY then fromL:=1 else fromL:=sL;
      if Y<eY then toL:=LevelsUsed else toL:=eL;
      for L:=fromL to toL do PushCell(D,P,Y,L);
     end; {for Y}
 finally
 end;
end;

procedure PushTtStackStart(UndoOpTyp:smallint);
var
 i: integer;
begin
 if ttUndoPtr>=nmbrTtStack then
  begin   //don't add any more - remove oldest pieces
   ttUndoPtr:=nmbrTtStack;
   for i:=1 to ttUndoPtr do ttStack[i-1]:=ttStack[i]; //shuffle them down
  end
 else
  begin
   inc(ttUndoPtr);
   setlength(ttStack,ttUndoPtr+1);       // resize stack
  end;
 ttUndoMax:=ttUndoPtr;
 ttStack[ttUndoPtr].UndoType:=UndoOpTyp;
 ttStack[ttUndoPtr].NumCells:=0;
end;


procedure PushClassShown;
var
 dataPtr: integer;
 y,l,a: integer;
begin
 PushTtStackStart(utClassShown);
 dataPtr:=-1;
 for y:=0 to years_minus_1 do
  for l:=1 to level[y] do
   begin
    a:=classshown[l,y];
    if (a>0) and (a<=classnum) then 
     begin
      inc(dataPtr);
      inc(ttStack[ttUndoPtr].NumCells);
      setlength(ttStack[ttUndoPtr].Cell,dataPtr+1); // dim stack record data
      ttStack[ttUndoPtr].Cell[dataPtr].cellY:=y;
      ttStack[ttUndoPtr].Cell[dataPtr].cellL:=l;
      ttStack[ttUndoPtr].Cell[dataPtr].sub:=a;
     end;
   end;
end;

procedure PushInsertLevel(d1,p1,d2,p2,ay,al:smallint);
begin
 if LevelsUsed<levelprint then inc(LevelsUsed);
 pushTtStack(d1,p1,ay,al,d2,p2,aY,levelsUsed,utInsertLevel);
end;

procedure PushWSinsertLevel(b1,b2,ay,al:smallint);
begin
 if LevelsUsed<levelprint then inc(LevelsUsed);
 pushWSStack(b1,ay,al,b2,aY,levelsUsed,utWSinsertLevel);
end;



procedure pushBlocks;
var
 y,oldWSblocks: integer;
begin
 oldWSblocks:=wsBlocks;
 PushTtStackStart(utConfigBlk);
 setlength(ttStack[ttUndoPtr].Cell,years+1);
 for y:=0 to years_minus_1 do ttStack[ttUndoPtr].Cell[y].sub:=blocks[y];
 ttStack[ttUndoPtr].Cell[years].sub:=wsBlocks;
 if (oldWSblocks<>wsBlocks) then AlterWSflag:=true;
end;


procedure pushLevels;
var
 y: integer;
begin
 PushTtStackStart(utConfigLev);
 setlength(ttStack[ttUndoPtr].Cell,years);
 for y:=0 to years_minus_1 do
  ttStack[ttUndoPtr].Cell[y].sub:=level[y];
 CalcLevelsUsed;
end;


procedure PushHome;
begin
 pushOneTtStack(hd,hp,hy,hl,utSetHome);
end;


procedure PushVersion;
begin
 PushTtStackStart(utConfigVers);
 setlength(ttStack[ttUndoPtr].Cell,1);
 ttStack[ttUndoPtr].Cell[0].lab:=Version;
end;

procedure pushAllWSstack(UndoOpType:smallint);
begin
 PushTtStackStart(UndoOpType);
 PushWSRange(1,0,1,wsBlocks,years_minus_1,levelsUsed,UndoOpType);
end;


procedure pushAllTtStack(UndoOpType:smallint);
begin
 PushTtStackStart(UndoOpType);
 PushTtRange(0,0,0,1,(days-1),(periods-1),years_minus_1,levelsUsed,UndoOpType);
end;


procedure PushWScell(b,y,l:smallint);
var
 dataPtr,Enlabel: integer;
 IntPoint: tpIntPoint;
 sub1: smallint;
begin
 dataPtr:=ttStack[ttUndoPtr].NumCells;
 IntPoint:=FNws(b,Y,L,0);
 inc(ttStack[ttUndoPtr].NumCells);
 setlength(ttStack[ttUndoPtr].Cell,ttStack[ttUndoPtr].NumCells); // dim stack record data
 ttStack[ttUndoPtr].Cell[dataPtr].cellP:=b;
 ttStack[ttUndoPtr].Cell[dataPtr].cellY:=Y;
 ttStack[ttUndoPtr].Cell[dataPtr].cellL:=L;
 sub1:=IntPoint^;
 ttStack[ttUndoPtr].Cell[dataPtr].sub:=sub1; inc(IntPoint);
 ttStack[ttUndoPtr].Cell[dataPtr].te:=IntPoint^; inc(IntPoint);
 ttStack[ttUndoPtr].Cell[dataPtr].ro:=IntPoint^; inc(IntPoint);
 ttStack[ttUndoPtr].Cell[dataPtr].flgs:=IntPoint^;  inc(IntPoint);
 ttStack[ttUndoPtr].Cell[dataPtr].cellD:=IntPoint^;
 if sub1>LabelBase then
  begin
   EnLabel:=sub1-LabelBase;
   if Enlabel>0 then ttStack[ttUndoPtr].Cell[dataPtr].lab:=TcLabel[Enlabel];
  end;
end;




procedure PushCell(d,p,y,l:smallint);
var
 dataPtr,Enlabel: integer;
 IntPoint: tpIntPoint;
 sub1: smallint;
begin
 dataPtr:=ttStack[ttUndoPtr].NumCells;
 IntPoint:=FNT(D,P,Y,L,0);
 inc(ttStack[ttUndoPtr].NumCells);
 setlength(ttStack[ttUndoPtr].Cell,ttStack[ttUndoPtr].NumCells); // dim stack record data
 ttStack[ttUndoPtr].Cell[dataPtr].cellD:=D;
 ttStack[ttUndoPtr].Cell[dataPtr].cellP:=P;
 ttStack[ttUndoPtr].Cell[dataPtr].cellY:=Y;
 ttStack[ttUndoPtr].Cell[dataPtr].cellL:=L;
 sub1:=IntPoint^;
 ttStack[ttUndoPtr].Cell[dataPtr].sub:=sub1; inc(IntPoint);
 ttStack[ttUndoPtr].Cell[dataPtr].te:=IntPoint^; inc(IntPoint);
 ttStack[ttUndoPtr].Cell[dataPtr].ro:=IntPoint^; inc(IntPoint);
 ttStack[ttUndoPtr].Cell[dataPtr].flgs:=IntPoint^;
 if sub1>LabelBase then
  begin
   EnLabel:=sub1-LabelBase;
   if Enlabel>0 then ttStack[ttUndoPtr].Cell[dataPtr].lab:=TcLabel[Enlabel];
  end;
end;

procedure pushOneWSstack(sB,sY,sL,UndoOpTyp:smallint);
begin
 PushTtStackStart(UndoOpTyp);
 PushWScell(sB,sY,sL);
end;



procedure pushOneTtStack(sD,sP,sY,sL,UndoOpTyp:smallint);
begin
 PushTtStackStart(UndoOpTyp);
 PushCell(sD,sP,sY,sL);
end;


procedure pushWSstack(sB,sY,sL,eB,eY,eL,UndoOpTyp:smallint);  //add entry to stack
begin
 PushTtStackStart(UndoOpTyp);
 PushWSrange(sB,sY,sL,eB,eY,eL,UndoOpTyp);
end;


procedure pushTtStack(sD,sP,sY,sL,eD,eP,eY,eL,UndoOpTyp:smallint);  //add entry to stack
begin
 PushTtStackStart(UndoOpTyp);
 PushTtRange(sD,sP,sY,sL,eD,eP,eY,eL,UndoOpTyp);
end;





function AddPopLabel(tmpLabel:string):smallint;
var
 newlabel: smallint;
begin
 newLabel:=FindLabel;
 if newLabel>0 then
  begin
   TcLabel[newLabel]:=tmpLabel;
   inc(newLabel,LabelBase);
  end;
 result:=newLabel;
end;


procedure PopVersion;
var
 tmpVers: string;
begin
 tmpVers:=Version;
 Version:=ttStack[ttUndoPtr].Cell[0].lab;
 ttStack[ttUndoPtr].Cell[0].lab:=tmpVers;
 SetTTtitle;
end;

procedure PopBlocks;
var
 y,oldWSblocks: integer;
begin
 oldWSblocks:=wsBlocks;
 for y:=0 to years_minus_1 do swapint(blocks[y],ttStack[ttUndoPtr].Cell[y].sub);
 swapint(wsBlocks,ttStack[ttUndoPtr].Cell[years].sub);
 if (oldWSblocks<>wsBlocks) then AlterWSflag:=true;
end;

procedure PopClassShown;
var
 dataPtr,y,l,a,I: integer;
 tmpClassShown: tpClassShown;
begin
 for y:=0 to years_minus_1 do
  for l:=1 to level[y] do
   begin
    tmpClassShown[l,y]:=ClassShown[l,y];
    ClassShown[l,y]:=0;
   end;
 if ttStack[ttUndoPtr].NumCells>0 then
  for I:=0 to (ttStack[ttUndoPtr].NumCells-1) do
   begin
    Y:=ttStack[ttUndoPtr].Cell[I].cellY;
    L:=ttStack[ttUndoPtr].Cell[I].cellL;
    a:=ttStack[ttUndoPtr].Cell[I].sub;
    ClassShown[l,y]:=a;
   end;
 dataPtr:=-1; ttStack[ttUndoPtr].NumCells:=0;
 for y:=0 to years_minus_1 do
  for l:=1 to level[y] do
   begin
    a:=tmpClassShown[l,y];
    if (a>0) and (a<=classnum) then
     begin
      inc(dataPtr);
      inc(ttStack[ttUndoPtr].NumCells);
      setlength(ttStack[ttUndoPtr].Cell,dataPtr+1); // dim stack record data
      ttStack[ttUndoPtr].Cell[dataPtr].cellY:=y;
      ttStack[ttUndoPtr].Cell[dataPtr].cellL:=l;
      ttStack[ttUndoPtr].Cell[dataPtr].sub:=a;
     end;
   end;
end;

procedure PopLevels;
var
 y: integer;
begin
 for y:=0 to years_minus_1 do swapint(level[y],ttStack[ttUndoPtr].Cell[y].sub);
 CalcLevelsUsed;
end;

procedure PopHome; //restore entry from stack
var
 D,P,Y,L: integer;
begin
 d:=hd; p:=hp; y:=hy; l:=hl;
 hd:=ttStack[ttUndoPtr].Cell[0].cellD;
 hp:=ttStack[ttUndoPtr].Cell[0].cellP;
 hy:=ttStack[ttUndoPtr].Cell[0].cellY;
 hl:=ttStack[ttUndoPtr].Cell[0].cellL;

 ttStack[ttUndoPtr].Cell[0].cellD:=d;
 ttStack[ttUndoPtr].Cell[0].cellP:=p;
 ttStack[ttUndoPtr].Cell[0].cellY:=y;
 ttStack[ttUndoPtr].Cell[0].cellL:=l;
end;


procedure PopWSrange; //restore worksheet entry from stack
var
 I,B,Y,L,sI: integer;
 IntPoint: tpIntPoint;
 tmpSu,tmpTe,tmpRo,tmpFlgs,EnLabel,tmpFreq: integer;
 su: smallint;
 tmpLab: string;
begin
 try
  RebuildLabels;
  sI:=ttUndoPtr; tmpLab:='';
  if ttStack[sI].NumCells>0 then
   for I:=0 to (ttStack[sI].NumCells-1) do
   begin
    B:=ttStack[sI].Cell[I].cellP;
    Y:=ttStack[sI].Cell[I].cellY;
    L:=ttStack[sI].Cell[I].cellL;
    if (B<1) or (B>WSblocks) or (Y<0) or (Y>years_minus_1) then continue; {invalid position}
    if (L<1) or (L>levelmax) then continue;
    IntPoint:=FNws(b,Y,L,0);
//store current values
    tmpSu:=IntPoint^; inc(IntPoint);
    tmpTe:=IntPoint^; inc(IntPoint);
    tmpRo:=IntPoint^; inc(IntPoint);
    tmpFlgs:=IntPoint^; inc(IntPoint);
    tmpFreq:=IntPoint^;  tmpLab:='';
    if tmpSu>LabelBase then
     begin
      EnLabel:=tmpSu-LabelBase;
      if (EnLabel>0) and (EnLabel<=Lnum) then
       begin
        tmpLab:=TcLabel[EnLabel];
        TcLabel[EnLabel]:='';
       end;
     end;
    IntPoint:=FNws(b,Y,L,0);
//restore values from stack
    su:=ttStack[sI].Cell[I].sub;
    if su>LabelBase then su:=AddPopLabel(ttStack[sI].Cell[I].lab);
    IntPoint^:=su; inc(IntPoint);
    IntPoint^:=ttStack[sI].Cell[I].te; inc(IntPoint);
    IntPoint^:=ttStack[sI].Cell[I].ro; inc(IntPoint);
    IntPoint^:=ttStack[sI].Cell[I].flgs; inc(IntPoint);
    IntPoint^:=ttStack[sI].Cell[i].cellD;

//then replace stack entry with what were the current values for the redo function (swapping the data to the stack)
    ttStack[sI].Cell[I].sub:=tmpSu;
    ttStack[sI].Cell[I].te:=tmpTe;
    ttStack[sI].Cell[I].ro:=tmpRo;
    ttStack[sI].Cell[I].flgs:=tmpFlgs;
    ttStack[sI].Cell[i].cellD:=tmpFreq;
    ttStack[sI].Cell[I].lab:=tmpLab;
   end;
 finally
 end;
end;





procedure PopTtRange; //restore entry from stack
var
 I,D,P,Y,L,sI: integer;
 IntPoint: tpIntPoint;
 tmpSu,tmpTe,tmpRo,tmpFlgs,EnLabel: integer;
 su: smallint;
 tmpLab: string;
begin
 try
  RebuildLabels;
  sI:=ttUndoPtr; tmpLab:='';
  if ttStack[sI].NumCells>0 then
   for I:=0 to (ttStack[sI].NumCells-1) do
   begin
    D:=ttStack[sI].Cell[I].cellD;
    P:=ttStack[sI].Cell[I].cellP;
    Y:=ttStack[sI].Cell[I].cellY;
    L:=ttStack[sI].Cell[I].cellL;
    if (D<0) or (d>=days) or (Y<0) or (Y>years_minus_1) then continue; {invalid position}
    if (P<0) or (P>=periods) or (L<1) or (L>levelmax) then continue;
    IntPoint:=FNT(D,P,Y,L,0);
//store current values
    tmpSu:=IntPoint^; inc(IntPoint);
    tmpTe:=IntPoint^; inc(IntPoint);
    tmpRo:=IntPoint^; inc(IntPoint);
    tmpFlgs:=IntPoint^;  tmpLab:='';
    if tmpSu>LabelBase then
     begin
      EnLabel:=tmpSu-LabelBase;
      if (EnLabel>0) and (EnLabel<=Lnum) then
       begin
        tmpLab:=TcLabel[EnLabel];
        TcLabel[EnLabel]:='';
       end;
     end;
    IntPoint:=FNT(D,P,Y,L,0);
//restore values from stack
    su:=ttStack[sI].Cell[I].sub;
    if su>LabelBase then su:=AddPopLabel(ttStack[sI].Cell[I].lab);
    IntPoint^:=su; inc(IntPoint);
    IntPoint^:=ttStack[sI].Cell[I].te; inc(IntPoint);
    IntPoint^:=ttStack[sI].Cell[I].ro; inc(IntPoint);
    IntPoint^:=ttStack[sI].Cell[I].flgs;

//then replace stack entry with what were the current values for the redo function (swapping the data to the stack)
    ttStack[sI].Cell[I].sub:=tmpSu;
    ttStack[sI].Cell[I].te:=tmpTe;
    ttStack[sI].Cell[I].ro:=tmpRo;
    ttStack[sI].Cell[I].flgs:=tmpFlgs;
    ttStack[sI].Cell[I].lab:=tmpLab;
   end;
 finally
 end;
end;

procedure PopWSinsertLevel(IsUndo: boolean);
var
 y: integer;
begin
 if ttStack[ttUndoPtr].NumCells>0 then
  begin
   Y:=ttStack[ttUndoPtr].Cell[0].cellY;
   if IsUndo then dec(level[y]) else inc(level[y]);
   PopWSRange;
   CalcLevelsUsed;
  end;
end;



procedure PopInsertLevel(IsUndo: boolean);
var
 y: integer;
begin
 if ttStack[ttUndoPtr].NumCells>0 then
  begin
   Y:=ttStack[ttUndoPtr].Cell[0].cellY;
   if IsUndo then dec(level[y]) else inc(level[y]);
   PopTtRange;
   CalcLevelsUsed;
  end;
end;


procedure popTtStack(IsUndo: boolean); //restore entry from stack
var
 UndoOpType: smallint;
begin
 if ttUndoPtr>ttUndoMax then exit; {beyond top of stack}
 UndoOpType:=ttStack[ttUndoPtr].UndoType;
 Case UndoOpType of
  utConfigVers: PopVersion;
  utConfigLev: PopLevels;
  utConfigBlk: PopBlocks;
  utClassShown: PopClassShown;
  utSetHome: PopHome;
  utInsertLevel: PopInsertLevel(IsUndo);
  utWSinsertLevel: PopWSinsertLevel(IsUndo);
  utCopyBlocks,utEditWSentry,utWSmultiple,utWSclear,utWScut,
    utWSdelete,utWSpaste,utWSDeleteLevel,utSwapBlock,
    utSwapTeach,utSwapRoom: PopWSrange;
  else PopTtRange;
 end;
 DoAllTtClashes;
 UpdateTimetableWins;
 UpdateWindow(wnInfo);
end;


procedure initTtUndoStack;
begin
 ttUndoPtr:=0;  ttUndoMax:=0; levelsUsed:=0;
 CalcLevelsUsed;
end;



end.
