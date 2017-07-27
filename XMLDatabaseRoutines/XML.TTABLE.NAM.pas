unit XML.TTABLE.NAM;


interface
uses  OXmlPDOM, clipBrd, OXmlUtils, DIALOGS, TimeChartGlobals, WinTypes, WinProcs, Classes,
      SysUtils, XML.UTILS, GlobalToTcAndTcextra;


procedure do_saveNAMfile_xml;
function do_getNAMfile_xml: boolean;
procedure do_readNameFile_OldFormat(_fileName: string);

implementation
uses XML.TTABLE.TTW;

CONST ROOT_NODE_NAME = 'TIMETABLE_NAMES';


(*
WRITE OLD FORMAT
procedure saveNAMfile;
var
 fname: string;
 f    : textfile;
 i,MaxDay    : integer;
begin
 if usrPassLevel=utGen then exit;
 try
  try
   maxDay:=CalcMaxDay;
   fname:= XMLHelper.getNAM_EXTENSION(FileNames.LoadedTimeTable,toWrite);
   doAssignFile(f, fname);
   rewrite(f);
   for i:= 0 to yr do writeln(f,Yearname[i]);
   for i:= 0 to periods-1 do
    begin
     PeriodName[i]:=TimeSlotName[MaxDay,i];
     writeln(f, PeriodName[i]);
    end;
   for i:= 0 to days-1 do writeln(f,Dayname[i]);
   writeln(f, yearTitle);
   writeln(f, yearShort)
  finally
   closefile(f)
  end;
 except
 end;
end
*)

procedure do_readNameFile_OldFormat(_fileName: string);
var
 i: smallint;
 f    : textfile;

function ReadNext: string;
var
  s: string;
begin
  readln(f,s); s:=trim(s); result:=s
end;

begin
 AssignFile(f,_fileName);
 filemode:=fmOpenRead+fmShareDenyNone;
 reset(f);
 for i:=0 to years_minus_1 do Yearname[i]:=ReadNext;
 for i:=0 to periods-1 do PeriodName[i]:=ReadNext;
 for i:= 0 to days-1 do Dayname[i]:=ReadNext;
 yearTitle:=ReadNext;
 yearShort:=ReadNext;
 closefile(f);
end;

function do_getNAMfile_xml: boolean;
var
  _XML: IXMLDocument;
  _Root, _AbsenceNode, _Attribute, _Node: PXMLNode;
  _fileName: string;
  tmpD: integer;
  _X, _Y, _VALUE, _INDEX: INTEGER;
  _VALUE_STRING: string;
  _VALUE_FLOAT: double;
begin
    Result:= False;
    _fileName:=FileNames.LoadedTimeTable+'.NAM';
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
       if _Node.NodeName ='YEAR_NAME' then  begin
          _INDEX:= StrToIntDef(_Node.GetAttribute('INDEX'),0);
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          Yearname[_INDEX]:= _VALUE_STRING;
       end;

       if _Node.NodeName ='PERIOD_NAME' then  begin
          _INDEX:= StrToIntDef(_Node.GetAttribute('INDEX'),0);
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          PeriodName[_INDEX]:= _VALUE_STRING;
       end;

       if _Node.NodeName ='DAY_NAME' then  begin
          _INDEX:= StrToIntDef(_Node.GetAttribute('INDEX'),0);
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          Dayname[_INDEX]:= _VALUE_STRING;
       end;

       if _Node.NodeName ='YEAR_TITLE' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          yearTitle := _VALUE_STRING;
       end;

       if _Node.NodeName ='YEAR_SHORT' then  begin
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          yearShort := _VALUE_STRING;
       end;

    end;  // while _Root.GetNextChild(_Node) do
end;


function CalcMaxDay: integer;
var
 i,maxDay,maxLimit:       integer;
begin
 maxDay:=0; maxLimit:=1;
 for i:=0 to days-1 do
  if Tlimit[i]>maxLimit then
   begin
    maxLimit:=Tlimit[i]; maxDay:=i;
   end;
 result:=maxDay;
end;



procedure do_saveNAMfile_xml;
var
  _XML: IXMLDocument;
  _Root, _Attribute, _Node: PXMLNode;
  x,y, i, MaxDay: integer;
  _file: string;
begin
    //exit;
    maxDay:=CalcMaxDay;
    _file:=FileNames.LoadedTimeTable+'.NAM';
    chdir(Directories.datadir);
    _XML := CreateXMLDoc(ROOT_NODE_NAME, True);
    _XML.WriterSettings.IndentType := itIndent;
    _Root := _XML.DocumentElement;
    for i:= 0 to years_minus_1 do
    begin
       _Node := _Root.AddChild('YEAR_NAME');
       _Node.SetAttribute('INDEX', IntToStr(i));
       _Node.SetAttribute('VALUE', Yearname[i]);
    end;
    for i:= 0 to periods-1 do
    begin
       PeriodName[i]:=TimeSlotName[MaxDay,i];
      _Node := _Root.AddChild('PERIOD_NAME');
      _Node.SetAttribute('INDEX', IntToStr(i));
      _Node.SetAttribute('VALUE', PeriodName[I]);
    END;

    for i:= 0 to days-1 do
    BEGIN
       _Node := _Root.AddChild('DAY_NAME');
       _Node.SetAttribute('INDEX', IntToStr(i));
       _Node.SetAttribute('VALUE', Dayname[I]);
    END;
    _Node := _Root.AddChild('YEAR_TITLE');
    _Node.SetAttribute('VALUE', yearTitle);
    _Node := _Root.AddChild('YEAR_SHORT');
    _Node.SetAttribute('VALUE', yearShort);

    _XML.SaveToFile(_file);
end;


end.

