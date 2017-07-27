unit XML.TTABLE.TTW;
interface
uses  OXmlPDOM, clipBrd, OXmlUtils, DIALOGS, TimeChartGlobals, WinTypes, WinProcs, Classes,
      SysUtils, XML.UTILS, GlobalToTcAndTcextra;

procedure do_saveTTWfile_xml;
function do_getTTWfile_xml: boolean;
procedure getNewTTable_oldFormat;
procedure setTTParameters;
procedure getNewTTable_oldFormat_TCE;
function TTWDataDumpToFile2(_comment,_directory, _fileName: string): string;

implementation
uses XML.TTABLE;

CONST ROOT_NODE_NAME =  'TTW_DATA';


procedure setTTParameters;
var
 i,j,dummyByte: byte;
 tempPointer : pointer;
 tempIntPoint: ^ smallint;
begin
 dummyByte:=0;
 if ttParameters = nil then
  Exit;
 
 fillchar(ttParameters^, sz2000Params, chr(0));
 ttParameters^[0]:=days;
 ttParameters^[1]:=periods;
 ttParameters^[2]:=years;
 years_minus_1:=years-1;
 ttParameters^[50]:=ord(Version[0]);
 if ttParameters^[50]>0 then
  for i:=1 to ttParameters^[50] do ttParameters^[50+i]:=ord(Version[i]);
 for i:=0 to (years-1) do
  begin
   ttParameters^[20+i]:= Blocks[i];
   ttParameters^[5+i]:= level[i]
  end;
 ttMemorySetting1.Value:=8*LevelMax;
 ttMemSetting2.Value:=years*ttMemorySetting1.Value;
 ttMemSetting3.Value:=64000 div days;

 tempPointer:=ttParameters;
 for i:=0 to days-1 do
  for j:=0 to periods-1 do
   begin
    tempIntPoint:=tempPointer;
    inc(tempIntPoint,50+(15*i)+j);
    tempIntPoint^:=Tclash[i,j];
    tempIntPoint:=tempPointer;
    inc(tempIntPoint,200+(15*i)+j);
    tempIntPoint^:=Rclash[i,j];
    ttParameters^[700+(15*i)+j]:=byte(Fclash[i,j])
   end;

  {d1,p1 etc}
 ttParameters^[900]:=dl;  ttParameters^[901]:=pl;
 ttParameters^[902]:=yl;  ttParameters^[903]:=ll;
 ttParameters^[904]:=hd;  ttParameters^[905]:=hp;
 ttParameters^[906]:=hy;  ttParameters^[907]:=hl;
 ttParameters^[908]:=nd;  ttParameters^[909]:=np;
 ttParameters^[910]:=ny;  ttParameters^[911]:=nl;
 ttParameters^[912]:=byte(WSeWarn);  ttParameters^[913]:=byte(WSmWarn);
 ttParameters^[914]:=byte(warn);
 ttParameters^[915]:=arrow;
 ttParameters^[916]:=box;
 ttParameters^[917]:=dummyByte;  ttParameters^[918]:=dummyByte;
 ttParameters^[919]:=dummyByte;  ttParameters^[920]:=dummyByte;
end;



function do_getTTWfile_xml: boolean;
var
  _XML: IXMLDocument;
  _Root, _AbsenceNode, _Attribute, _Node: PXMLNode;
  _fileName: string;
  tmpD: integer;
  _X, _Y, _VALUE, _INDEX, D: INTEGER;
  _VALUE_STRING: string;
  _VALUE_FLOAT: double;
  _checkForDifferences: string;
  f: file;
  tempPointer2: pointer;
begin
    Result:= False;
    _fileName:=FileNames.LoadedTimeTable+'.TTW';
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
       if _Node.NodeName ='ttMainFormat' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          ttMainFormat:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='DAYS' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          days:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='PERIODS' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          periods:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='YEARS' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          years:=     StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='LEVEL_MAX' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          LevelMax:= StrTointDef(_VALUE_STRING,0);
       end;

       if _Node.NodeName ='LEVEL' then  begin
          _INDEX:= StrToIntDef(_Node.GetAttribute('INDEX'),0);
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          level[_INDEX]:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='BLOCK' then  begin
          _INDEX:= StrToIntDef(_Node.GetAttribute('INDEX'),0);
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          Blocks[_INDEX]:= StrTointDef(_VALUE_STRING,0);
       end;

       if _Node.NodeName ='VERSION' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          Version:= _VALUE_STRING;
       end;

       if _Node.NodeName ='TEACHER_CLASH' then  begin
          _X:= StrToIntDef(_Node.GetAttribute('X'),0);
          _Y:= StrToIntDef(_Node.GetAttribute('Y'),0);
          _VALUE:= StrToIntDef(_Node.GetAttribute('VALUE'),0);
          Tclash[_X,_Y]:= _VALUE;
       end;
       if _Node.NodeName ='ROOM_CLASH' then  begin
          _X:= StrToIntDef(_Node.GetAttribute('X'),0);
          _Y:= StrToIntDef(_Node.GetAttribute('Y'),0);
          _VALUE:= StrToIntDef(_Node.GetAttribute('VALUE'),0);
          Rclash[_X,_Y]:= _VALUE;
       end;
       if _Node.NodeName ='F_CLASH' then  begin
          _X:= StrToIntDef(_Node.GetAttribute('X'),0);
          _Y:= StrToIntDef(_Node.GetAttribute('Y'),0);
          _VALUE:= StrToIntDef(_Node.GetAttribute('VALUE'),0);
          Fclash[_X,_Y]:= _VALUE;
       end;

       if _Node.NodeName ='DL' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          dl:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='PL' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          pl:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='YL' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          yl:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='LL' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          LL:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='HD' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          hd:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='HP' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          HP:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='HY' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          HY:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='HL' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          HL:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='ND' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          ND:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='NP' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          NP:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='NY' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          NY:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='NL' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          NL:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='WSeWarn' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          Byte(WSeWarn):= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='WSmWarn' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          Byte(WSmWarn):= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='warn' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          Byte(warn):= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='arrow' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          arrow:= StrTointDef(_VALUE_STRING,0);
       end;
       if _Node.NodeName ='box' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          box:= StrTointDef(_VALUE_STRING,0);
       end;
    end;  // while _Root.GetNextChild(_Node) do

    ttMemorySetting1.Value:=8*LevelMax;
    ttMemSetting2.Value:=years*ttMemorySetting1.Value;
    ttMemSetting3.Value:=64000 div days;
    years_minus_1 :=  years - 1;
    setTTParameters;

    _fileName:=FileNames.LoadedTimeTable+'.TTW2';
    doAssignFile(f,_fileName);
    reset(f,1);
    for d:=0 to days-1 do
    begin
     tempPointer2:=FNT(d,0,0,1,0);
     blockread(f,tempPointer2^,8*word(LevelMax)*word(periods)*word(years));
    end;
    CloseFile(f);

end;

procedure do_saveTTWfile_xml;
var
  _XML: IXMLDocument;
  _Root, _Attribute, _Node: PXMLNode;
  x,y, MaxDay, d: integer;
  _fileName, _TempLabel: string;
  _WideString: WideString;
  tempPointer2: pointer;
  f: file;
begin
    //exit;
    _fileName:=FileNames.LoadedTimeTable+'.TTW';
    chdir(Directories.datadir);
    _XML := CreateXMLDoc(ROOT_NODE_NAME, True);
    _XML.WriterSettings.IndentType := itIndent;
    _Root := _XML.DocumentElement;
    _Node := _Root.AddChild('ttMainFormat');
    _Node.SetAttribute('VALUE', IntToStr(ttMainFormat));

    _Node := _Root.AddChild('DAYS');
    _Node.SetAttribute('VALUE', IntToStr(days));
    _Node := _Root.AddChild('PERIODS');
    _Node.SetAttribute('VALUE', IntToStr(periods));
    _Node := _Root.AddChild('YEARS');
    _Node.SetAttribute('VALUE', IntToStr(years));
    _Node := _Root.AddChild('LEVEL_MAX');
    _Node.SetAttribute('VALUE', IntToStr(LevelMax));

    for x:=0 to years_minus_1 do begin
      _Node := _Root.AddChild('BLOCK');
      _Node.SetAttribute('INDEX', IntToStr(x));
      _Node.SetAttribute('VALUE', IntToStr(Blocks[x]));
    end;
    for x:=0 to years_minus_1 do begin
      _Node := _Root.AddChild('LEVEL');
      _Node.SetAttribute('INDEX', IntToStr(x));
      _Node.SetAttribute('VALUE', IntToStr(level[x]));
    end;
    _Node := _Root.AddChild('VERSION');
    _Node.SetAttribute('VALUE', Version);
    for x:=0 to days-1 do
        for y:=0 to periods-1 do begin
          _Node := _Root.AddChild('TEACHER_CLASH');
          _Node.SetAttribute('X', IntToStr(x));
          _Node.SetAttribute('Y', IntToStr(y));
          _Node.SetAttribute('VALUE', IntToStr(Tclash[x,y]));
        end;
    for x:=0 to days-1 do
        for y:=0 to periods-1 do begin
          _Node := _Root.AddChild('ROOM_CLASH');
          _Node.SetAttribute('X', IntToStr(x));
          _Node.SetAttribute('Y', IntToStr(y));
          _Node.SetAttribute('VALUE', IntToStr(Rclash[x,y]));
        end;
    for x:=0 to days-1 do
        for y:=0 to periods-1 do begin
          _Node := _Root.AddChild('F_CLASH');
          _Node.SetAttribute('X', IntToStr(x));
          _Node.SetAttribute('Y', IntToStr(y));
          _Node.SetAttribute('VALUE', IntToStr(Fclash[x,y]));
        end;



    _Node := _Root.AddChild('DL');
    _Node.SetAttribute('VALUE', IntToStr(dl));
    _Node := _Root.AddChild('PL');
    _Node.SetAttribute('VALUE', IntToStr(pl));
    _Node := _Root.AddChild('YL');
    _Node.SetAttribute('VALUE', IntToStr(yl));
    _Node := _Root.AddChild('LL');
    _Node.SetAttribute('VALUE', IntToStr(ll));
    _Node := _Root.AddChild('HD');
    _Node.SetAttribute('VALUE', IntToStr(hd));
    _Node := _Root.AddChild('HP');
    _Node.SetAttribute('VALUE', IntToStr(hp));
    _Node := _Root.AddChild('HY');
    _Node.SetAttribute('VALUE', IntToStr(hy));
    _Node := _Root.AddChild('HL');
    _Node.SetAttribute('VALUE', IntToStr(hl));
    _Node := _Root.AddChild('ND');
    _Node.SetAttribute('VALUE', IntToStr(nd));
    _Node := _Root.AddChild('NP');
    _Node.SetAttribute('VALUE', IntToStr(np));
    _Node := _Root.AddChild('NY');
    _Node.SetAttribute('VALUE', IntToStr(ny));
    _Node := _Root.AddChild('NL');
    _Node.SetAttribute('VALUE', IntToStr(nl));
    _Node := _Root.AddChild('WSeWarn');
    _Node.SetAttribute('VALUE', IntToStr(Byte(WSeWarn)));
    _Node := _Root.AddChild('WSmWarn');
    _Node.SetAttribute('warn', IntToStr(Byte(WSmWarn)));
    _Node := _Root.AddChild('warn');
    _Node.SetAttribute('VALUE', IntToStr(Byte(warn)));
    _Node := _Root.AddChild('arrow');
    _Node.SetAttribute('VALUE', IntToStr(arrow));
    _Node := _Root.AddChild('box');
    _Node.SetAttribute('VALUE', IntToStr(box));


    _XML.SaveToXML(_WideString);
    //Clipboard.AsText :=  _WideString;
    _XML.SaveToFile(_fileName);
    //this works from TC but not TCENet probably has no dataa
    _fileName:=FileNames.LoadedTimeTable+'.TTW2';
    doAssignFile(f,_fileName);
    rewrite(f,1);
    for d:=0 to days-1 do
    begin
      tempPointer2:=FNT(d,0,0,1,0);
      blockwrite(f,tempPointer2^,8*word(LevelMax)*word(periods)*word(years))
    end;
    CloseFile(f);
end;

function byterangecheck(var i: byte; j,k: integer):integer ;
begin
 result:=0;
 if i<j then begin i:=j; result:=1; end
  else if i>k then begin i:=k; result:=2; end;
end;

function TTWDataDumpToFile2(_comment, _directory, _fileName: string): string;
var
 i,j,d:             integer;
 dummyByte: byte;
 tempPointer2:         pointer;
 f: file;
 _StringList: TStringList;
begin
  try
   _StringList:= TStringList.Create;
   _StringList.Add(_comment);
   _StringList.Add('=========================================');
   _StringList.Add(_directory);
   _StringList.Add(_fileName);
   _StringList.Add('=========================================');
   Result :=  Format('ttMainFormat: %d',[ttMainFormat]) +#13;
   _StringList.Add(Result);
   //blockread(f,ttMainFormat,1);
   Result :=  Format('days: %d',[days]) +#13;
   _StringList.Add(Result);
   //blockread(f,days,1);        byterangecheck(days,1,nmbrdays);
   Result :=  Format('periods: %d',[periods]) +#13;
   _StringList.Add(Result);
   //blockread(f,periods,1);       byterangecheck(periods,1,nmbrperiods);
   Result :=  Format('years: %d',[years]) +#13;
   _StringList.Add(Result);
   //blockread(f,years,1);  byterangecheck(years,1,nmbryears);  yr:=years-1;
   Result :=  Format('levelmax: %d',[levelmax]) +#13;
   _StringList.Add(Result);
   //blockread(f,levelmax,2);
   for i:=0 to years_minus_1 do begin
     Result :=  Format('Level: %d',[Level[i]]) +#13;
     _StringList.Add(Result);
   end;
    //blockread(f,Level[i],1);
   for i:=0 to years_minus_1 do begin
     Result :=  Format('Blocks: %d',[Blocks[i]]) +#13;
     _StringList.Add(Result);
   end;
    //blockread(f,Blocks[i],1);

   //blockread(f,ttVersion[0],1);
   //blockread(f,ttVersion[1],ord(ttVersion[0]));
   //ttVersion:=trim(ttVersion);
  Result :=  Format('ttVersion: %S',[Version]) +#13;
  _StringList.Add(Result);

   for i:=0 to days-1 do
    for j:=0 to periods-1 do begin
      Result :=  Format('Tclash: %d',[Tclash[i,j]]) +#13;
      _StringList.Add(Result);
    end;
     //blockread(f,Tclash[i,j],2);
   for i:=0 to days-1 do
    for j:=0 to periods-1 do begin
      Result :=  Format('Rclash: %d',[Rclash[i,j]]) +#13;
      _StringList.Add(Result);
    end;
     //blockread(f,Rclash[i,j],2);
   for i:=0 to days-1 do
    for j:=0 to periods-1 do begin
      Result :=  Format('fclash: %d',[fclash[i,j]]) +#13;
      _StringList.Add(Result);
    end;
     //blockread(f,fclash[i,j],1);
   {d1,p1 etc. 900+ params from standard}
   Result :=  Format('dl: %s',[IntToSTr(dl)]) +#13;
   _StringList.Add(Result);
   Result :=  Format('pl: %d',[pl]) +#13;
   _StringList.Add(Result);
   //blockread(f,dl,1);  blockread(f,pl,1);
   Result :=  Format('yl: %d',[yl]) +#13;
   _StringList.Add(Result);
   Result :=  Format('ll: %d',[ll]) +#13;
   _StringList.Add(Result);
   //blockread(f,yl,1);  blockread(f,ll,1);
   Result :=  Format('hd: %d',[hd]) +#13;
   _StringList.Add(Result);
   Result :=  Format('hp: %d',[hp]) +#13;
   _StringList.Add(Result);
   //blockread(f,hd,1);  blockread(f,hp,1);
   Result :=  Format('hy: %d',[hy]) +#13;
   _StringList.Add(Result);
   Result :=  Format('hl: %d',[hl]) +#13;
   _StringList.Add(Result);
   //blockread(f,hy,1);  blockread(f,hl,1);
    {skipped pos=0}
   Result :=  Format('nd: %d',[nd]) +#13;
   _StringList.Add(Result);
   Result :=  Format('np: %d',[np]) +#13;
   _StringList.Add(Result);
   Result :=  Format('ny: %d',[ny]) +#13;
   _StringList.Add(Result);
   Result :=  Format('nl: %d',[nl]) +#13;
   _StringList.Add(Result);
   //blockread(f,nd,1);  blockread(f,np,1);
   //blockread(f,ny,1);  blockread(f,nl,1);
   //blockread(f,dummyByte,1);  blockread(f,dummyByte,1);
   Result :=  Format('warn: %s',[IntToSTr(byte(warn))]) +#13;
   _StringList.Add(Result);
   //blockread(f,warn,1);
   Result :=  Format('arrow: %d',[arrow]) +#13;
   _StringList.Add(Result);
   //blockread(f,arrow,1);
   if arrow>4 then arrow:=0;
   Result :=  Format('box: %d',[box]) +#13;
   _StringList.Add(Result);
  // blockread(f,box,1);
   if box>6 then box:=bxCell;
   //blockread(f,dummyByte,1);  blockread(f,dummyByte,1);
   //blockread(f,dummyByte,1);  blockread(f,dummyByte,1);

   //ttmem1:=8*levelmax;
   //ttmem2:=years*ttmem1;
   //ttmem3:=64000 div days;

   {main timetable data}
   ////for d:=0 to days-1 do
   ////begin
   //// tempPointer2:=FNT(d,0,0,1,0);
   //// blockread(f,tempPointer2^,8*word(levelmax)*word(periods)*word(years));
   ////end;
   //About.UpdateComparisonLevels;
  finally
  //// closefile(f);
     _StringList.SaveToFile('C:\aaa\TTWDataDumpToFile_'+IntToStr(GetTickCount)+'.txt');
     _StringList.free;

  end;
end;

procedure getNewTTable_oldFormat_TCE;
var
 i,j,d:             integer;
 dummyByte: byte;
 tempPointer2:         pointer;
 f: file;
 _fileName : string;
begin
  try
   chdir(Directories.datadir);
  _fileName := XMLHelper.getTTW_EXTENSION(FileNames.LoadedTimeTable, checkExists);
   doAssignFile(f,_fileName);
   filemode:=fmOpenRead+fmShareDenyNone;
   reset(f,1);
   blockread(f,ttMainFormat,1);
   blockread(f,days,1);        byterangecheck(days,1,nmbrdays);
   blockread(f,periods,1);       byterangecheck(periods,1,nmbrperiods);
   blockread(f,years,1);  byterangecheck(years,1,nmbryears);  years_minus_1:=years-1;
   blockread(f,levelmax,2);
   for i:=0 to years_minus_1 do
    blockread(f,Level[i],1);
   for i:=0 to years_minus_1 do
    blockread(f,Blocks[i],1);

   blockread(f,Version[0],1);
   blockread(f,Version[1],ord(Version[0]));
   Version:=trim(Version);

   for i:=0 to days-1 do
    for j:=0 to periods-1 do
     blockread(f,Tclash[i,j],2);
   for i:=0 to days-1 do
    for j:=0 to periods-1 do
     blockread(f,Rclash[i,j],2);
   for i:=0 to days-1 do
    for j:=0 to periods-1 do
     blockread(f,fclash[i,j],1);
   {d1,p1 etc. 900+ params from standard}
   blockread(f,dl,1);  blockread(f,pl,1);
   blockread(f,yl,1);  blockread(f,ll,1);
   blockread(f,hd,1);  blockread(f,hp,1);
   blockread(f,hy,1);  blockread(f,hl,1);
    {skipped pos=0}
   blockread(f,nd,1);  blockread(f,np,1);
   blockread(f,ny,1);  blockread(f,nl,1);
   blockread(f,dummyByte,1);  blockread(f,dummyByte,1);
   blockread(f,warn,1);
   blockread(f,arrow,1);
   if arrow>4 then arrow:=0;
   blockread(f,box,1);
   if box>6 then box:=bxCell;
   blockread(f,dummyByte,1);  blockread(f,dummyByte,1);
   blockread(f,dummyByte,1);  blockread(f,dummyByte,1);

   ttMemorySetting1.Value:=8*levelmax;
   ttMemSetting2.Value:=years*ttMemorySetting1.Value;
   ttMemSetting3.Value:=64000 div days;

   {main timetable data}
   for d:=0 to days-1 do
   begin
    tempPointer2:=FNT(d,0,0,1,0);
    blockread(f,tempPointer2^,8*word(levelmax)*word(periods)*word(years));
   end;
   //About.UpdateComparisonLevels;
  finally
   closefile(f);
  end;
end;


procedure getNewTTable_oldFormat;
var
 i,j,d: smallint;
 tempPointer2: pointer;
 dummyByte: byte;
 _fileName: string;
 f: file;
begin
  if ttParameters = nil then begin
    getNewTTable_oldFormat_TCE;
    exit;
  end;
 _fileName := XMLHelper.getTTW_EXTENSION(FileNames.LoadedTimeTable, checkExists);
 chdir(Directories.datadir);
 doAssignFile(f,_fileName);
 filemode:=fmOpenRead+fmShareDenyNone;
 reset(f,1);
 ttNewFormat := true;
 try
  try
   blockread(f,ttMainFormat,1);
   blockread(f,days,1);  ByteRangeCheck(days,1,nmbrDays);
   blockread(f,periods,1);  ByteRangeCheck(periods,1,nmbrPeriods);
   blockread(f,years,1);  ByteRangeCheck(years,1,nmbrYears);
   years_minus_1:=years-1;
   blockread(f,LevelMax,2);
   for i:=0 to years_minus_1 do begin
    blockread(f,level[i],1);
   end;
   for i := 0 to years_minus_1 do
    begin
     blockread(f,Blocks[i],1);  IntRange(Blocks[i],0,nmbrBlocks);
    end;
   blockread(f,Version[0],1);
  // _debug_view := _debug_view + format('ttVersion : %d  ',[ttVersion]) +#13;
   blockread(f,Version[1],ord(Version[0]));
  // _debug_view := _debug_view + format('ttVersion : %d  ',[ttVersion]) +#13;
   Version:=trim(Version);
   for i:=0 to days-1 do
    for j:=0 to periods-1 do begin
      blockread(f,Tclash[i,j],2);
    end;
   for i:=0 to days-1 do
    for j:=0 to periods-1 do begin
      blockread(f,Rclash[i,j],2);
    end;
   for i:=0 to days-1 do
    for j:=0 to periods-1 do begin
      blockread(f,Fclash[i,j],1);
    end;
      {d1,p1 etc. 900+ params from standard}
   blockread(f,dl,1);
   blockread(f,pl,1);
   blockread(f,yl,1);
   blockread(f,ll,1);
   blockread(f,hd,1);
   blockread(f,hp,1);
   blockread(f,hy,1);
   blockread(f,hl,1);
      {skipped pos=0}
   blockread(f,nd,1);
   blockread(f,np,1);
   blockread(f,ny,1);
   blockread(f,nl,1);
   blockread(f,WSeWarn,1);
   blockread(f,WSmWarn,1);
   blockread(f,warn,1);
   blockread(f,arrow,1);  if arrow>4 then arrow:=0;
   blockread(f,box,1);   if box>6 then box:= bxCell;
   blockread(f,dummyByte,1);
   blockread(f,dummyByte,1);
   blockread(f,dummyByte,1);
   blockread(f,dummyByte,1);
   setTTParameters;
   {main timetable data}
   for d:=0 to days-1 do
    begin
     tempPointer2:=FNT(d,0,0,1,0);
     blockread(f,tempPointer2^,8*word(LevelMax)*word(periods)*word(years));
    end;
  finally
   closefile(f)
  end;
 except
 end;
// clipBoard.AsText := _debug_view;
// showMessage(_debug_view);
end;

end.
