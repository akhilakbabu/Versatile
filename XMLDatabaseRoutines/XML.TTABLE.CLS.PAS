unit XML.TTABLE.CLS;

interface
uses  OXmlPDOM, clipBrd, OXmlUtils, DIALOGS, TimeChartGlobals, WinTypes, WinProcs, Classes,
      SysUtils, XML.UTILS, GlobalToTcAndTcextra;


procedure do_saveCLSfile_xml;
function  do_getCLSfile_xml(_verifyConversion: boolean): boolean;
procedure getCLSfile_oldFormat;

implementation
uses XML.TTABLE.TTW, XML.TTABLE;

CONST ROOT_NODE_NAME = 'TIMETABLE_CLASSES';

function do_getCLSfile_xml(_verifyConversion: boolean): boolean;
var
  _XML: IXMLDocument;
  _Root, _AbsenceNode, _Attribute, _Node: PXMLNode;
  _fileName: string;
  tmpD: integer;
  _X, _Y, _VALUE: INTEGER;
  _VALUE_STRING: string;
  _VALUE_FLOAT: double;
  _checkForDifferences: string;
begin
    Result:= False;
    _fileName:=FileNames.LoadedTimeTable+'.CLS';
    chdir(Directories.datadir);
    if not(fileexists(_fileName)) then
        exit;
    Result := true;
    _XML := CreateXMLDoc(ROOT_NODE_NAME, True);
    _XML.LoadFromFile(_fileName);//load XML document
    _Root := _XML.DocumentElement;//save the root into local variable
    _Node := nil;
    while _Root.GetNextChild(_Node) do
    begin
       //ClassShown - 2D array
       if _Node.NodeName ='CLASS_SHOWN' then  begin
          _X:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_X),0);
          _Y:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_Y),0);
          _VALUE:= StrToIntDef(_Node.GetAttribute('VALUE'),0);
          if _verifyConversion then begin
            _checkForDifferences := compareValues(ClassShown[_X,_Y],_VALUE);
            if _checkForDifferences <> '' then
                ShowMessage(format('ClassShown[_%d,_%d]',[_X,_Y])+' <> _VALUE '+#13+_checkForDifferences);
          end;
          ClassShown[_X,_Y]:= _VALUE;
       end;
       //Tlimit
       if _Node.NodeName ='TLIMIT' then  begin
          _X:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_X),0);
          _VALUE:= StrToIntDef(_Node.GetAttribute('VALUE'),0);
          Tlimit[_X]:= _VALUE;
       end;
       //TslotUnit
       if _Node.NodeName ='TSLOTUNIT' then  begin
          _VALUE:= StrToIntDef(_Node.GetAttribute('VALUE'),0);
          TslotUnit:= _VALUE;
       end;
       //TMPD
       if _Node.NodeName ='TMPD' then  begin
          _VALUE:= StrToIntDef(_Node.GetAttribute('VALUE'),0);
          tmpD:= _VALUE;
       end;
       //DayGroup
       if _Node.NodeName ='DAY_GROUP' then  begin
          _X:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_X),0);
          _VALUE:= StrToIntDef(_Node.GetAttribute('VALUE'),0);
          DayGroup[_X]:= _VALUE;
       end;
       //TimeSlotName
       if _Node.NodeName ='TIME_SLOT_NAME' then  begin
          _X:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_X),0);
          _Y:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_Y),0);
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          if _verifyConversion then begin
            _checkForDifferences := compareValues(TimeSlotName[_X,_Y],_VALUE_STRING);
            if _checkForDifferences <> '' then
                ShowMessage(format('TimeSlotName[_%d,_%d]',[_X,_Y])+' <> _VALUE '+#13+_checkForDifferences);
          end;
          TimeSlotName[_X,_Y]:= _VALUE_STRING;
       end;
       //tsCode
       if _Node.NodeName ='TSCODE' then  begin
          _X:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_X),0);
          _Y:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_Y),0);
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          if _verifyConversion then begin
            _checkForDifferences := compareValues(tsCode[_X,_Y],_VALUE_STRING);
            if _checkForDifferences <> '' then
                ShowMessage(format('tsCode[_%d,_%d]',[_X,_Y])+' <> _VALUE '+#13+_checkForDifferences);
          end;
          tsCode[_X,_Y]:= _VALUE_STRING;
       end;
       //tsAllot
       if _Node.NodeName ='TSALLOT' then  begin
          _X:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_X),0);
          _Y:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_Y),0);
          _VALUE_FLOAT:=  StrToFloat(_Node.GetAttribute('VALUE'));
          if _verifyConversion then begin
            _checkForDifferences := compareValues(tsAllot[_X,_Y],_VALUE_FLOAT);
            if _checkForDifferences <> '' then
                ShowMessage(format('tsAllot[_%d,_%d]',[_X,_Y])+' <> _VALUE_FLOAT '+#13+_checkForDifferences);
          end;
          tsAllot[_X,_Y]:= _VALUE_FLOAT;
          if tsAllot[_X,_Y]<0.00001 then tsAllot[_X,_Y]:=0;
          if tsAllot[_X,_Y]>5000 then tsAllot[_X,_Y]:=1.0;
       end;
       //tsStart
       if _Node.NodeName ='TSSTART' then  begin
          _X:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_X),0);
          _Y:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_Y),0);
          _VALUE_FLOAT:=  StrToFloat(_Node.GetAttribute('VALUE'));
          if _verifyConversion then begin
            _checkForDifferences := compareValues(tsStart[_X,_Y],_VALUE_FLOAT);
            if _checkForDifferences <> '' then
                ShowMessage(format('tsStart[_%d,_%d]',[_X,_Y])+' <> _VALUE_FLOAT '+#13+_checkForDifferences);
          end;
          tsStart[_X,_Y]:= _VALUE_FLOAT;
       end;
       //tsEnd
       if _Node.NodeName ='TSEND' then  begin
          _X:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_X),0);
          _Y:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_Y),0);
          _VALUE_FLOAT:=  StrToFloat(_Node.GetAttribute('VALUE'));
          if _verifyConversion then begin
            _checkForDifferences := compareValues(tsEnd[_X,_Y],_VALUE_FLOAT);
            if _checkForDifferences <> '' then
                ShowMessage(format('tsEnd[_%d,_%d]',[_X,_Y])+' <> _VALUE_FLOAT '+#13+_checkForDifferences);
          end;
          tsEnd[_X,_Y]:= _VALUE_FLOAT;
       end;
       //tsType
       if _Node.NodeName ='TSTYPE' then  begin
          _X:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_X),0);
          _Y:= StrToIntDef(_Node.GetAttribute(ATTRIBUTE_Y),0);
          _VALUE:= StrToIntDef(_Node.GetAttribute('VALUE'),0);
          if _verifyConversion then begin
            _checkForDifferences := compareValues(tsType[_X,_Y],_VALUE);
            if _checkForDifferences <> '' then
                ShowMessage(format('tsType[_%d,_%d]',[_X,_Y])+' <> _VALUE '+#13+_checkForDifferences);
          end;
          tsType[_X,_Y]:= _VALUE;
       end;

    end;  // while _Root.GetNextChild(_Node) do
end;



procedure do_saveCLSfile_xml;
var
  _XML: IXMLDocument;
  _Root, _Attribute, _Node: PXMLNode;
  x,y, tmpD: integer;
  _fileName: string;
begin
    //exit;
    _fileName:=FileNames.LoadedTimeTable+'.CLS';
    chdir(Directories.datadir);
    _XML := CreateXMLDoc(ROOT_NODE_NAME, True);
    _XML.WriterSettings.IndentType := itIndent;
    _Root := _XML.DocumentElement;
    //ClassShown
    // 2D array can read back by setting all zero and then loading from found YEAR, LEVEL, VALUES
    for  x:=1 to nmbrLevels do
    begin
        for y:=years_minus_1 downto 0 do
        begin
           if ClassShown[x,y] = 0 then
             continue;
          _Node := _Root.AddChild('CLASS_SHOWN');
          _Node.SetAttribute(ATTRIBUTE_X, IntToStr(x));
          _Node.SetAttribute(ATTRIBUTE_Y, IntToStr(y));
          _Node.SetAttribute('VALUE', IntToStr(ClassShown[x,y]));
        end;
    end;
    //Tlimit
    for x:=0 to days-1 do
    begin
        if Tlimit[x] = 0 then
             continue;
        _Node := _Root.AddChild('TLIMIT');
        _Node.SetAttribute(ATTRIBUTE_X, IntToStr(x));
        _Node.SetAttribute('VALUE', IntToStr(Tlimit[x]));
    end;
    //TslotUnit
    _Node := _Root.AddChild('TSLOTUNIT');
    _Node.SetAttribute('VALUE', IntToStr(TslotUnit));
    //TMPD
    _Node := _Root.AddChild('TMPD');
    tmpD:=days-1;
    _Node.SetAttribute('VALUE', IntToStr(tmpD));
    //DayGroup
    for x:=0 to tmpD do
    begin
        if DayGroup[x] = 0 then
             continue;
        _Node := _Root.AddChild('DAY_GROUP');
        _Node.SetAttribute(ATTRIBUTE_X, IntToStr(x));
        _Node.SetAttribute('VALUE', IntToStr(DayGroup[x]));
    end;
    //TimeSlotName
    for x:=0 to tmpD do
        for y:=0 to Tlimit[x]-1 do
        begin
          if trim(TimeSlotName[x,y]) = '' then
            continue;
          _Node := _Root.AddChild('TIME_SLOT_NAME');
          _Node.SetAttribute(ATTRIBUTE_X, IntToStr(x));
          _Node.SetAttribute(ATTRIBUTE_Y, IntToStr(y));
          _Node.SetAttribute('VALUE', TimeSlotName[x,y]);
        end;
    //tsCode
    for x:=0 to tmpD do
        for y:=0 to Tlimit[x]-1 do
        begin
          if trim(tsCode[x,y]) = ''  then
            continue;
          _Node := _Root.AddChild('TSCODE');
          _Node.SetAttribute(ATTRIBUTE_X, IntToStr(x));
          _Node.SetAttribute(ATTRIBUTE_Y, IntToStr(y));
          _Node.SetAttribute('VALUE', tsCode[x,y]);
        end;
    //tsAllot
    for x:=0 to tmpD do
        for y:=0 to Tlimit[x]-1 do
        begin
          if tsAllot[x,y] = 0  then
            continue;
          _Node := _Root.AddChild('TSALLOT');
          _Node.SetAttribute(ATTRIBUTE_X, IntToStr(x));
          _Node.SetAttribute(ATTRIBUTE_Y, IntToStr(y));
          _Node.SetAttribute('VALUE', FloatToStr(tsAllot[x,y]));
        end;
    //tsStart
    for x:=0 to tmpD do
        for y:=0 to Tlimit[x]-1 do
        begin
          if tsStart[x,y] < EncodeDate(1999,01,01)  then
            continue;
          _Node := _Root.AddChild('TSSTART');
          _Node.SetAttribute(ATTRIBUTE_X, IntToStr(x));
          _Node.SetAttribute(ATTRIBUTE_Y, IntToStr(y));
          _Node.SetAttribute('VALUE', FloatToStr(tsStart[x,y]));
        end;
    //tsEnd
    for x:=0 to tmpD do
        for y:=0 to Tlimit[x]-1 do
        begin
          if tsEnd[x,y] < EncodeDate(1999,01,01)  then
            continue;
          _Node := _Root.AddChild('TSEND');
          _Node.SetAttribute(ATTRIBUTE_X, IntToStr(x));
          _Node.SetAttribute(ATTRIBUTE_Y, IntToStr(y));
          _Node.SetAttribute('VALUE', FloatToStr(tsEnd[x,y]));
        end;
    //tsType
    for x:=0 to tmpD do
        for y:=0 to Tlimit[x]-1 do
        begin
          if tsType[x,y] = 0  then
            continue;
          _Node := _Root.AddChild('TSTYPE');
          _Node.SetAttribute(ATTRIBUTE_X, IntToStr(x));
          _Node.SetAttribute(ATTRIBUTE_Y, IntToStr(y));
          _Node.SetAttribute('VALUE',IntToStr(tsType[x,y]));
        end;

    _XML.SaveToFile(_fileName);//save XML document
end;

procedure AllotLoad;
var
  tmpDouble2: double;
  i: smallint;
  f: file;
  lAmtTransferred: Integer;
begin
 chdir(Directories.datadir);
  {init Allot first}
 for i:= 0 to nmbrPeriods do BaseAllot[i]:=1.0; {default}
 if fileexists('ALLOT.DAT') then
  begin
   try
    try
     doAssignFile(f, 'ALLOT.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(f, 1);
     FileAge('ALLOT.DAT',NEW_DateChecks[15]);
     TC4fileHeader[0]:=chr(4);
     blockread(f,TC4fileHeader[1],4);
     if TC4fileHeader = 'TCV4' then
      for i:=0 to periods-1 do BlockRead(f, BaseAllot[i], 8, lAmtTransferred)

    finally
     closefile(f)
    end;

   except
   end;
   for i:= 0 to periods-1 do
    begin
     tmpDouble2:=1.0+BaseAllot[i];
     if (tmpDouble2<1.0) then BaseAllot[i]:=1.0;
     if (tmpDouble2>5001.0) then BaseAllot[i]:=1.0;
    end;
  end;
end;


procedure getCLSfile_oldFormat;
var
  fname: string;
  f    : file;
  i,j,k,tmpD  : smallint;
  lAmtTransferred: Integer;
begin
 yeartitle:='Year'; yearshort:='Yr';
 XMLHelper.getNAM_EXTENSION(FileNames.LoadedTimeTable,toRead); {read in names, including old periodnames}
 if (yearTitle<>'Form') and (yearTitle<>'Year') then
  begin
   yearTitle:='Year';  yearShort:='Yr'
  end;
 AllotLoad; {get base allotments - old allot storage}
 try
  {initialise all values}
  TimeSeparator:=':';  NumDayGroups:=1;
  TslotUnit:=2; SlotUnitDec:=2; SlotUnitMain:=6;
  for i:=-1 to nmbrDays do DayGroup[i]:=1;
  for i:=0 to nmbrDays do Tlimit[i]:=periods;
  for j:=0 to days-1 do
   for k:=0 to periods-1 do
    begin
     TimeSlotName[j,k]:=periodname[k];
     if k<9 then tsCode[j,k]:=inttostr(k+1) else tsCode[j,k]:=chr(56+k);
     tsAllot[j,k]:=BaseAllot[k];
     if (k=0) then
      begin tsStart[j,k]:=StrToTime('9:00'); tsEnd[j,k]:=StrToTime('10:00'); end
       else begin
             tsStart[j,k]:=tsStart[j,k-1]+StrToTime('1:00');
             tsEnd[j,k]:=tsEnd[j,k-1]+StrToTime('1:00');
            end;
    end;
  chdir(Directories.datadir);
  fname:=XMLHelper.getCLS_EXTENSION(FileNames.LoadedTimeTable, toCopy);
  if not(fileexists(fname)) then exit;
  doAssignFile(f, fname);
  try
   filemode:=fmOpenRead+fmShareDenyNone;
   reset(f, 1);
   for i:=years_minus_1 downto 0 do
     for j:=1 to nmbrLevels do blockread(f,ClassShown[j,i],2);
   {also store timeslots data}
   for i:=0 to days-1 do
    begin
     blockread(f,Tlimit[i],2);
     IntRange(Tlimit[i],1,periods);
    end;

   try
    blockread(f, TslotUnit, 2, lAmtTransferred);
    IntRange(TslotUnit,0,3);
    blockread(f, tmpD, 2, lAmtTransferred);
    for i:=0 to tmpD do
     begin
      blockread(f,DayGroup[i],2);
      IntRange(DayGroup[i],1,nmbrdays);
     end;
    for j:=0 to tmpD do
     for k:=0 to Tlimit[j]-1 do
      begin
       blockread(f,i,2);
       TimeSlotName[j,k]:='';
       if i>0 then
        begin
         TimeSlotName[j,k]:=space(i);
         blockread(f,TimeSlotName[j,k][1],i);
        end;

       SetLength(tsCode[j,k],1);
       blockread(f,tsCode[j,k][1],1);
       blockread(f,tsAllot[j,k],8);
       if tsAllot[j,k]<0.00001 then tsAllot[j,k]:=0;
       if tsAllot[j,k]>5000 then tsAllot[j,k]:=1.0;
       blockread(f,tsStart[j,k],sizeof(TdateTime));
       blockread(f,tsEnd[j,k],sizeof(TdateTime));
      end;

      // Now read in Timeslot Types (default to 0)
    for j:=0 to tmpD do
     for k:=0 to Tlimit[j]-1 do
      begin
       tsType[j,k]:=0;
      end;
    for j:=0 to tmpD do
     for k:=0 to Tlimit[j]-1 do
      begin
       blockread(f,tsType[j,k],Sizeof(integer));
      end;

     except
     end;

   finally;
    closefile(f);
    DayGroupCount;
   end;

 except
 end;
end;



end.
