unit TrackChoices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, XML.UTILS, GlobalToTcAndTcextra,
  XML.STUDENTS;

type
  TTrackChoicesDlg = class(TForm)
    DateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    procedure SaveYearTrackingFile(year:smallint);
  end;
                                            
var
  TrackChoicesDlg: TTrackChoicesDlg;

implementation
uses tcload,TimeChartGlobals,dateutils,ClassDefs,tcommon,tcommon5,CustomOutput;

var
 yearCheckBox:    array[1..nmbrYears] of TCheckBox;

{$R *.dfm}


procedure TTrackChoicesDlg.FormCreate(Sender: TObject);
const
 xgap=20;
 ygap=5;          
var
 mxyearname,i,v1,v2:    integer;
 maxtab,curtab:   integer;
 actcheckboxsz:         integer;
begin
 actcheckboxsz:=self.canvas.textwidth('WW'); {width includes size of actual box}
 maxTab:=0;
 for i:=1 to years do
 begin                   
  curTab:=self.canvas.textwidth(Yearname[i-1]);
  if (curTab>maxTab) then maxTab:=curTab;
 end;                                             
 mxyearname:=maxTab;
 curtab:=self.canvas.textwidth('Minstr ');
 if mxyearname<curtab then mxyearname:=curtab;
                                    
 for i:=1 to years do
 begin
  yearCheckBox[i]:=tCheckBox.create(application);
  yearCheckBox[i].parent:=label3.parent;
  yearCheckBox[i].hint:='Check to create Enrolment Tracking File for '+yeartitle+' '+yearname[i-1];
  yearCheckBox[i].caption:=yearname[i-1];
  yearCheckBox[i].enabled:=true;

  v2:=(i-1) div 3;  v1:=(i) mod 3;
  if v1=0 then v1:=2 else v1:=v1-1;
  yearCheckBox[i].width:=mxyearname+actcheckboxsz;
  yearCheckBox[i].left:=label3.left+v1*(mxyearname+xgap);
  yearCheckBox[i].top:=label3.top+label3.height+ygap+v2*(yearCheckBox[1].height+ygap);
  yearCheckBox[i].Checked:=false;   //always start cleared
 end;

 if MonthOfTheYear(now)>6 then radiogroup1.ItemIndex:=1 else radiogroup1.ItemIndex:=0;
 datetimepicker1.DateTime:=now;
end;


procedure TTrackChoicesDlg.SaveYearTrackingFile(year:smallint);
var
 i,j:   integer;
 a,c:    string;
 fname,tname: string;
 MyIDlen: smallint;
 TrckRecordSize: smallint;
 tmpint,tmpint2: smallint;
begin
 chdir(Directories.datadir);
 try
  try
   MyIDlen:=yearStat[year].IDlen;
   fname:=trim(inttostr(yearof(datetimepicker1.datetime)));
   fname:=fname+trim(yearname[year{-1}]);
   fname:=fname+trim(inttostr(radiogroup1.itemindex+1));
   tname:=fname+'.TMP';
   fname:=fname+'.ST';
   ourSafetyMemStreamStr:='';
   ourSafetyMemStream:=TStringStream.Create(ourSafetyMemStreamStr);
   with ourSafetyMemStream do
    begin
     TC4fileHeader:='TCV4'; Write(Pchar(@TC4fileHeader[1])^,4);
     write(yearStat[year].numstud,2);
     write(yearStat[year].chmax,2);
     write(yearStat[year].IDlen,2);
     TrckRecordSize:=yearStat[year].IDlen+yearStat[year].chmax*4;
     a:=space(TrckRecordSize-10);
     Write(Pchar(@a[1])^,length(a));
     if XML_STUDENTS.numstud>0 then
      for i:=1 to XML_STUDENTS.numstud do
       if XML_STUDENTS.Stud[i].TcYear=year then
       begin
        c:=RpadString(XML_STUDENTS.Stud[i].ID,MyIDlen);
        if MyIDlen>0 then Write(Pchar(@c[1])^,MyIDlen);
        for j:=1 to yearStat[year].chmax do
        begin
         write(XML_STUDENTS.Stud[i].choices[j],2);
         CustomOutput.OberonFindteacher2(i,j,tmpint,tmpint2);
         write(tmpint,2);
        end;
       end;
    end;
   SafelyStreamToFile(tname,fname);
  finally
   ourSafetyMemStream.Free;
  end;
 except
 end;
end;

procedure TTrackChoicesDlg.BitBtn1Click(Sender: TObject);
var
 y: smallint;
begin
 screen.cursor:=crHourglass;
 for y:=1 to years do
  if yearCheckBox[y].Checked then SaveYearTrackingFile(y-1);
 screen.cursor:=crDefault;
end;

end.

