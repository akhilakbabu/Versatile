unit XML.EXTRAS;

interface
uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils,Messages,TCEglobals, Tcommon, OXmlPDOM, clipBrd, OXmlUtils, XML.UTILS;

const
   EXTRAS_XML_FILE = 'EXTRAS.XML';

procedure saveExtras_xml;
procedure getExtras_xml;

implementation


procedure getExtras_xml;
var
  _XML: IXMLDocument;
  _Root, _AbsenceNode, _Attribute, _Node: PXMLNode;
  i, _ExtraTeacherIdx, _TeacherIdx, _RoomIdx, _NoteIdx, _ChangesIdx: integer;
begin
    chdir(Directories.datadir);
    _XML := CreateXMLDoc('EXTRAS', True);
    _XML.LoadFromFile(EXTRAS_XML_FILE);
    _Root := _XML.DocumentElement;
    _Node := nil;
    _TeacherIdx := 1;
    _ExtraTeacherIdx := 1;
    _RoomIdx := 1;
    _ChangesIdx := 1;
    _NoteIdx := 1;
    while _Root.GetNextChild(_Node) do
    begin
       if _Node.NodeName ='EXTRADAY' then  begin
           exday := StrToIntDef(_Node.GetAttribute('DAY'),0);
           exmonth := StrToIntDef(_Node.GetAttribute('MONTH'),0);
           exyear := StrToIntDef(_Node.GetAttribute('YEAR'),0);
           ttday := StrToIntDef(_Node.GetAttribute('TTDAY'),0);
       end;
       if _Node.NodeName ='EXTRA_NUMBERS' then  begin
           numcodes[1]:= StrToIntDef(_Node.GetAttribute('numcodes_1'),0);
           numcodes[2] := StrToIntDef(_Node.GetAttribute('numcodes_2'),0);
           ETnum := StrToIntDef(_Node.GetAttribute('ETnum'),0);
           numchanges := StrToIntDef(_Node.GetAttribute('numchanges'),0);
           notenum := StrToIntDef(_Node.GetAttribute('notenum'),0);
       end;
       if _Node.NodeName ='TEACHER' then  begin
           teon[_TeacherIdx] :=  StrToIntDef(_Node.GetAttribute('teon'),0);
           teAbsent[_TeacherIdx] :=  StrToIntDef(_Node.GetAttribute('teAbsent'),0);
           telost[_TeacherIdx] :=  StrToIntDef(_Node.GetAttribute('telost'),0);
           tecover[_TeacherIdx] :=  StrToIntDef(_Node.GetAttribute('tecover'),0);
           tecover[_TeacherIdx] :=  StrToIntDef(_Node.GetAttribute('tecover'),0);
           telieu[_TeacherIdx] :=  StrToIntDef(_Node.GetAttribute('telieu'),0);
           teavail[_TeacherIdx] :=  StrToFloatDef(_Node.GetAttribute('teavail'),0);
           telieudbl[_TeacherIdx] :=  StrToFloatDef(_Node.GetAttribute('telieudbl'),0);
           tabsreason[_TeacherIdx] :=  StrToIntDef(_Node.GetAttribute('tabsreason'),0);
           inc(_TeacherIdx);
       end;
       if _Node.NodeName ='EXTRA_TEACHER' then  begin
          Etlink[_ExtraTeacherIdx] :=  StrToIntDef(_Node.GetAttribute('Etlink'),0);
          ETon[_ExtraTeacherIdx] :=  StrToIntDef(_Node.GetAttribute('ETon'),0);
          ETavail[_ExtraTeacherIdx] :=  StrToIntDef(_Node.GetAttribute('ETavail'),0);
          inc(_ExtraTeacherIdx);
       end;
       if _Node.NodeName ='ROOM' then  begin
          roomon[_RoomIdx] :=  StrToIntDef(_Node.GetAttribute('roomon'),0);
          roAbsent[_RoomIdx] :=  StrToIntDef(_Node.GetAttribute('roAbsent'),0);
          roswap[_RoomIdx] :=  StrToIntDef(_Node.GetAttribute('roswap'),0);
          rocover[_RoomIdx] :=  StrToIntDef(_Node.GetAttribute('rocover'),0);
          rolost[_RoomIdx] :=  StrToIntDef(_Node.GetAttribute('rolost'),0);
          inc(_RoomIdx);
       end;
       if _Node.NodeName ='CHANGES' then  begin
          with Changes[_ChangesIdx] do begin
            timeslot :=  StrToIntDef(_Node.GetAttribute('timeslot'),0);
            year :=  StrToIntDef(_Node.GetAttribute('year'),0);
            level :=  StrToIntDef(_Node.GetAttribute('level'),0);
            sub :=  StrToIntDef(_Node.GetAttribute('sub'),0);
            gen :=  StrToIntDef(_Node.GetAttribute('gen'),0);
            oldte :=  StrToIntDef(_Node.GetAttribute('oldte'),0);
            newte :=  StrToIntDef(_Node.GetAttribute('newte'),0);
            oldroom :=  StrToIntDef(_Node.GetAttribute('oldroom'),0);
            newroom :=  StrToIntDef(_Node.GetAttribute('newroom'),0);
            kind :=  StrToIntDef(_Node.GetAttribute('kind'),0);
            needte :=  StrToIntDef(_Node.GetAttribute('needte'),0);
            needroom :=  StrToIntDef(_Node.GetAttribute('needroom'),0);
            notes :=  StrToIntDef(_Node.GetAttribute('notes'),0);
            reason :=  StrToIntDef(_Node.GetAttribute('reason'),0);
          end;
          inc(_ChangesIdx);
       end;
       if _Node.NodeName ='NOTE' then  begin
         // ExNote[i] :=  _Node.GetAttribute('text');     //commented   mantis-01611
          ExNote[_NoteIdx ]  :=  _Node.GetAttribute('text'); //mantis-01611
          inc(_NoteIdx);
       end;
    end;
end;


procedure saveExtras_xml;
var
  _XML: IXMLDocument;
  _Root, _Attribute, _Node: PXMLNode;
  i: integer;

begin
    //exit;
    chdir(Directories.datadir);
    _XML := CreateXMLDoc('EXTRAS', True);//create XML doc with root node named "root"
    _XML.WriterSettings.IndentType := itIndent;
    _Root := _XML.DocumentElement;
    _Node := _Root.AddChild('EXTRADAY');
    _Node.SetAttribute('DAY', IntToStr(exday));
    _Node.SetAttribute('MONTH', IntToStr(exmonth));
    _Node.SetAttribute('YEAR', IntToStr(exyear));
    _Node.SetAttribute('TTDAY', IntToStr(ttday));

    _Node := _Root.AddChild('EXTRA_NUMBERS');
    _Node.SetAttribute('numcodes_1', IntToStr(numcodes[1]));
    _Node.SetAttribute('numcodes_2', IntToStr(numcodes[2]));
    _Node.SetAttribute('ETnum', IntToStr(ETnum));
    _Node.SetAttribute('numchanges', IntToStr(numchanges));
    _Node.SetAttribute('notenum', IntToStr(notenum));

    // <CHANGES timeslot="1" year="5" level="3" sub="220" gen="1" oldte="39" newte="0" oldroom="3" newroom="3" kind="0" needte="-1" needroom="0" notes="0" reason="6"/>
    for i:=1 to numchanges do
    begin
        with Changes[i] do
       _Node := _Root.AddChild('CHANGES');
       _Node.SetAttribute('timeslot', IntToStr(Changes[i].timeslot));
       _Node.SetAttribute('year', IntToStr(Changes[i].year));
       _Node.SetAttribute('level', IntToStr(Changes[i].level));
       _Node.SetAttribute('sub', IntToStr(Changes[i].sub));
       _Node.SetAttribute('gen', IntToStr(Changes[i].gen));
       _Node.SetAttribute('oldte', IntToStr(Changes[i].oldte));
       _Node.SetAttribute('newte', IntToStr(Changes[i].newte));
       _Node.SetAttribute('oldroom', IntToStr(Changes[i].oldroom));
       _Node.SetAttribute('newroom', IntToStr(Changes[i].newroom));
       _Node.SetAttribute('kind', IntToStr(Changes[i].kind));
       _Node.SetAttribute('needte', IntToStr(Changes[i].needte));
       _Node.SetAttribute('needroom', IntToStr(Changes[i].needroom));
       _Node.SetAttribute('notes', IntToStr(Changes[i].notes));
       _Node.SetAttribute('reason', IntToStr(Changes[i].reason));
    end;
    for i:=1 to notenum do
    begin
      _Node := _Root.AddChild('NOTE');
      _Node.SetAttribute('text', Trim(ExNote[i]));
    end;

    for i:=1 to numcodes[1] do
    begin
        _Node := _Root.AddChild('TEACHER');
        _Node.SetAttribute('teon', IntToStr(teon[i]));
        _Node.SetAttribute('teAbsent', IntToStr(teAbsent[i]));
        _Node.SetAttribute('telost', IntToStr(telost[i]));
        _Node.SetAttribute('tecover', IntToStr(tecover[i]));
        _Node.SetAttribute('tereplace', IntToStr(tereplace[i]));
        _Node.SetAttribute('telieu', IntToStr(telieu[i]));
        _Node.SetAttribute('teavail', FloatToStr(teavail[i]));
        _Node.SetAttribute('telieudbl', FloatToStr(telieudbl[i]));
        _Node.SetAttribute('tabsreason', IntToStr(tabsreason[i]));
    end;
    for i:=1 to ETnum do
    begin
        _Node := _Root.AddChild('EXTRA_TEACHER');
        _Node.SetAttribute('Etlink', IntToStr(Etlink[i]));
        _Node.SetAttribute('ETon', IntToStr(ETon[i]));
        _Node.SetAttribute('ETavail', IntToStr(ETavail[i]));
    end;
    for i:=1 to numcodes[2] do
    begin
      _Node := _Root.AddChild('ROOM');
      _Node.SetAttribute('roomon', IntToStr(roomon[i]));
      _Node.SetAttribute('roAbsent', IntToStr(roAbsent[i]));
      _Node.SetAttribute('roswap', IntToStr(roswap[i]));
      _Node.SetAttribute('rocover', IntToStr(rocover[i]));
      _Node.SetAttribute('rolost', IntToStr(rolost[i]));
    end;
    _XML.SaveToFile(EXTRAS_XML_FILE);//save XML document
    //getReasons_xml;
end;




end.
