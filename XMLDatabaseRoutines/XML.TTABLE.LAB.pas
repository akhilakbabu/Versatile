unit XML.TTABLE.LAB;

interface
uses  OXmlPDOM, clipBrd, OXmlUtils, DIALOGS, TimeChartGlobals, WinTypes, WinProcs, Classes,
      SysUtils, forms, XML.UTILS;


procedure do_saveLABfile_xml;
function do_getLABfile_xml: boolean;
procedure getLabfile_oldFormat;


implementation
uses XML.TTABLE;

CONST ROOT_NODE_NAME =  'TIMETABLE_LABELS';

function do_getLABfile_xml: boolean;
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
    _fileName:=FileNames.LoadedTimeTable+'.LAB';
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
       if _Node.NodeName ='LABEL' then  begin
          _INDEX:= StrToIntDef(_Node.GetAttribute('INDEX'),0);
          _VALUE_STRING:= _Node.GetAttribute('VALUE');
          TcLabel[_INDEX]:= _VALUE_STRING;
       end;

    end;  // while _Root.GetNextChild(_Node) do
end;


procedure do_saveLABfile_xml;
var
  _XML: IXMLDocument;
  _Root, _Attribute, _Node: PXMLNode;
  x,y, i, MaxDay: integer;
  _fileName, _TempLabel: string;
begin
    //exit;
    _fileName:=FileNames.LoadedTimeTable+'.LAB';
    chdir(Directories.datadir);
    _XML := CreateXMLDoc(ROOT_NODE_NAME, True);
    _XML.WriterSettings.IndentType := itIndent;
    _Root := _XML.DocumentElement;
    if Lnum > 0 then
        for i:=1 to Lnum do
        begin
          _Node := _Root.AddChild('LABEL');
          _Node.SetAttribute('INDEX', IntToStr(i));
          _TempLabel:=RpadString(TcLabel[i],szTcLabel);
          _Node.SetAttribute('VALUE', _TempLabel);
        end;
    _XML.SaveToFile(_fileName);
end;

procedure getLabfile_oldFormat;
var
  fname: string;
  f    : file;
  i: integer;
begin
  fname:=XMLHelper.getLAB_EXTENSION(FileNames.LoadedTimeTable, toCopy);
  if fileexists(fname) then
   begin
    try
     try
      assignfile(f,fname);
      filemode:=fmOpenRead+fmShareDenyNone;
      reset(f,1);
      Application.ProcessMessages;
      blockread(f,Lnum,2);
      if Lnum>0 then
       for i:=1 to Lnum do
        begin
         TcLabel[i][0]:=chr(szTcLabel);
         blockread(f,TcLabel[i][1],szTcLabel);
         TcLabel[i]:=TrimRight(TcLabel[i])
        end;
     finally
      closefile(f)
     end;
    except
    end;
  end
end;

end.
