unit XML.TTABLE;

interface
uses  OXmlPDOM, clipBrd, OXmlUtils, DIALOGS, TimeChartGlobals, WinTypes, WinProcs, Classes,
      SysUtils, XML.TTABLE.CLS, XML.TTABLE.NAM, XML.TTABLE.LAB, XML.TTABLE.TTW,Controls, XML.UTILS;

type

TWhy = (ToRead,ToWrite,ToCopy, JustTheExtension, checkExists);

TXMLHelper = class
    public
      function  getNAM_EXTENSION(_FileName: string; Why: TWhy): string;   //XMLHelper.getNAM_EXTENSION
      function  getTTW_EXTENSION(_FileName: string; Why: TWhy): string;
      function  getCLS_EXTENSION(_FileName: string; Why: TWhy): string;
      function  getLAB_EXTENSION(_FileName: string; Why: TWhy): string;
    constructor create;
end;


// assignfile


var XMLHelper: TXMLHelper;

implementation


function AlreadyContainsXML(_fileName: string): boolean;
var
 f    : TextFile;
 _firstLine: string;
begin
 // clipBoard.AsText := getCurrentDir;
  result:= false;
  AssignFile(f,_fileName);
  filemode:=fmOpenRead+fmShareDenyNone;
  reset(f);
  //<?xml version="1.0" encoding="utf-8" standalone="yes"?>
  try
    readLn(f,_firstLine);
  except
    result := False;
    closefile(f);
    exit;
  end;
  closefile(f);
  if pos('?xml',_firstLine) > 0 then
    result := true;
end;



{ TXMLHelper }

constructor TXMLHelper.create;
begin
end;

function TXMLHelper.getCLS_EXTENSION(_FileName: string; Why: TWhy): string;
const _EXT = '.CLS';
var _ClsDataFileName: string;
begin
   if Why = JustTheExtension then begin
     Result:=   _EXT;
     exit;
   end;

  if (Why = toCopy) or (Why = checkExists) then begin
    Result:=  _FileName+ _EXT;
    exit;
  end;

  if Why = toRead then begin
    _ClsDataFileName := _FileName+ _EXT;
    if (fileexists(_ClsDataFileName)) then
    begin
       Result:=  _ClsDataFileName;
       if not AlreadyContainsXML(_ClsDataFileName) then
       begin
          getCLSfile_oldFormat;
          do_saveCLSfile_xml;
          do_getCLSfile_xml(true and JimsDevMode);
          exit;
       end;
       do_getCLSfile_xml(False);
       exit;
    end;
    exit;
  end; //if Why = toRead then begin
  if Why = toWrite then
    do_saveCLSfile_xml;

end;

function TXMLHelper.getLAB_EXTENSION(_FileName: string; Why: TWhy): string;
const _EXT = '.LAB';
var _LabDataFileName: string;
begin
    if (Why = toCopy) or (Why = checkExists) then begin
      Result:=  _FileName+ _EXT;
      exit;
    end;

    if Why = JustTheExtension then begin
       Result:=   _EXT;
       exit;
     end;

    if Why = toRead then begin
      _LabDataFileName := _FileName+ _EXT;
      if (fileexists(_LabDataFileName)) then
      begin
         Result:=  _LabDataFileName;
         if not AlreadyContainsXML(_LabDataFileName) then
         begin
            getLabfile_oldFormat;
            do_saveLABfile_xml;
            exit;
         end;
         do_getLABfile_xml;
         exit;
      end;
      // nothing must be a new school
      // just write an empty file
      do_saveLABfile_xml;
      exit;
    end; //if Why = toRead then begin

    if Why = toWrite then
      do_saveLABfile_xml;
end;

function TXMLHelper.getNAM_EXTENSION(_FileName: string; Why: TWhy): string;
const _EXT = '.NAM';
var _NamDataFileName, _oldFileName: string;
begin

  if  (Why = toCopy) or (Why = checkExists) then begin
    Result:=  _FileName+ _EXT;
    exit;
  end;

  if Why = JustTheExtension then begin
     Result:=   _EXT;
     exit;
   end;

  if Why = toRead then begin
    _NamDataFileName := _FileName+ _EXT;
    if (fileexists(_NamDataFileName)) then
    begin
       Result:=  _NamDataFileName;
       if not AlreadyContainsXML(_NamDataFileName) then
       begin
          do_readNameFile_OldFormat(_NamDataFileName);
          do_saveNAMfile_xml;
          exit;
       end;
       do_getNAMfile_xml;
       exit;
    end;
    //'SDATA.DAT' is some old format probably not needed but try anywya
    _oldFileName := 'SDATA.DAT';
    if (fileexists(_oldFileName)) then
    begin
      do_readNameFile_OldFormat(_oldFileName);
      do_saveNAMfile_xml;
      Result:=  _NamDataFileName;
      exit;
    end;
    // nothing must be a new school
    // just write an empty file
    do_saveNAMfile_xml;
    exit;
  end; //if Why = toRead then begin
  if Why = toWrite then
    do_saveNAMfile_xml;
end;

function TXMLHelper.getTTW_EXTENSION(_FileName: string; Why: TWhy): string;
const _EXT = '.TTW';
var _TtwDataFileName, _oldFileName: string;
begin

  if  (Why = toCopy) or (Why = checkExists)then begin
    Result:=  _FileName+ _EXT;
    exit;
  end;

  if Why = JustTheExtension then begin
     Result:=   _EXT;
     exit;
   end;

   if Why = toRead then begin
    _TtwDataFileName := _FileName+ _EXT;
    if (fileexists(_TtwDataFileName)) then
    begin
       Result:=  _TtwDataFileName;
       //getNewTTable_oldFormat;
       //getNewTTable_oldFormat_TCE;
       //exit;
       if not AlreadyContainsXML(_TtwDataFileName) then
       begin
          getNewTTable_oldFormat;
          do_saveTTWfile_xml;
          do_getTTWfile_xml;
          exit;
       end;
       do_getTTWfile_xml;
       exit;
    end;
    exit;
  end; //if Why = toRead then begin

  if Why = toWrite then
     do_saveTTWfile_xml;
end;

initialization
  XMLHelper:= TXMLHelper.create;
  //ShowMessage('TXMLConversionHelper.create');

Finalization
  XMLHelper.Free;
  //ShowMessage('TXMLConversionHelper.Free');

end.
