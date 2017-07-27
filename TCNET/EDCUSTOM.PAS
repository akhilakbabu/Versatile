unit Edcustom;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Menus, TimeChartGlobals;

type
  TEditCustomInfo = class(TForm)
    Memo1: TMemo;
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    Label1: TLabel;
    procedure CancelbuttonClick(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
  end;

var
  EditCustomInfo: TEditCustomInfo;

implementation
uses tcommon,tcload,tcommon5,main;
{$R *.DFM}

procedure parseCustomIN;
var
 i:   integer;
begin
 with editCustomInfo do
 begin
  memo1.clear;
  if addnum=0 then exit;
  parseCustomInfo;
  if CustomCnt=0 then exit;
  for i:=1 to CustomCnt do
   memo1.lines.add(CustomArr[i]);
 end; {with}
end;

procedure parseCustomOUT;
var
 i,j,k,m,n:   integer;
 a,b:   string;
 fin:     bool;
var
 tmpArr:  tpCustomArr;
 tmpTab:  array[0..nmbrCustom] of integer;
 tmpAdd:  tpCustomArr;
 linesUSED:            integer;

      procedure checkForTabs;
      var
       ii,jj,kk,mm,ssi:       integer;
       ss:             string;
      begin
       fillchar(tmptab,sizeof(tmptab),chr(0));
       for ii:=0 to nmbrCustom do tmpAdd[ii]:='';

       kk:=0;
       for ii:=1 to addnum do
       begin
        jj:=pos(chr(9),Add[ii]);
        if jj=0 then
        begin
         inc(kk);  if kk>22 then break;
         tmptab[kk]:=customtab[ii];
         tmpAdd[kk]:=Add[ii];
        end
        else {need to split line}
         begin
          ss:=Add[ii]; mm:=0;
          ssi:=customtab[ii];
          while (jj>0) do
          begin
           if jj>1 then {avoid blank lines for nothing before tab}
           begin
            inc(kk);    if kk>22 then break;
            tmptab[kk]:=ssi;
            tmpAdd[kk]:=copy(ss,1,jj-1);
            ssi:=(((length(tmpAdd[kk])+mm) div 8)+1)*8;
           end
            else inc(ssi,8);


           ss:=copy(ss,jj+1,length(ss));
           if jj>1 then inc(mm,jj)   {keep total offset count for ssi}
            else inc(mm,8);

           jj:=pos(chr(9),ss);
          end;
          {add leftover}
          inc(kk);   if kk>22 then break;
          tmptab[kk]:=ssi;
          tmpAdd[kk]:=ss;

         end;  {need to split line}

       end; {for ii}
       if kk>22 then kk:=22;
       addnum:=kk;  kk:=0; ii:=1;
       while ((ii<=addnum) and (kk<22)) do
       begin
        inc(kk);
        if (kk>1) then
         if tmptab[ii]>length(tmpAdd[ii-1]) then
         begin {ensure new line and not pulled back onto previous line}
          customtab[kk]:=0; Add[kk]:=''; inc(kk);
          if kk>22 then break;
         end;
        customtab[kk]:=tmptab[ii]; Add[kk]:=tmpAdd[ii];
        inc(ii);
       end; {while}

       if kk>22 then kk:=22;
       addnum:=kk;


      end;

begin
 for i:=0 to nmbrCustom do tmpAdd[i]:='';
 for i:=0 to nmbrCustom do tmpArr[i]:='';
 with editCustomInfo do
 begin
  linesUSED:=memo1.lines.count;
  if linesUSED>22 then linesUSED:=22;
  if linesUSED>0 then
  begin
   j:=1;
   for i:=1 to linesUSED do   {parse  each line}
   begin
    tmpArr[i]:=memo1.lines[i-1];
    tmpArr[i]:=TrimRight(tmpArr[i]);
    if length(trim(tmpArr[i]))<81 then
    begin
     if trim(tmpArr[i])='' then   {blank line ( negative vals )}
     begin
      tmpTab[j]:=-1; tmpAdd[j]:='';
      inc(j);
     end
     else    {normal line with tab for leading spaces}
      begin
       m:=0;
       for k:=1 to Length(tmpArr[i]) do
        if tmpArr[i][k]=' ' then inc(m)
         else break;
       tmpTab[j]:=m; tmpAdd[j]:=trim(tmpArr[i]);
       inc(j);
      end;
    end
    else  {need to make use of continue tab (1000)}
     begin
      a:=tmpArr[i];
      b:=copy(a,1,80);
      a:=copy(a,81,300);
      m:=0;
      for k:=1 to Length(tmpArr[i]) do
       if tmpArr[i][k]=' ' then inc(m)
        else break;
      tmpTab[j]:=m; tmpAdd[j]:=trim(tmpArr[i]);
      inc(j);

      while (a>'') do
      begin
       b:=copy(a,1,80);
       a:=copy(a,81,300);
       tmpTab[j]:=1000; tmpAdd[j]:=b;
       inc(j);
      end; {while}

     end;
   end; {for i}
   {repack blank lines and get count}
   m:=1;
   i:=0;  fin:=false;
   while not(fin) do
   begin
    inc(i);
    if tmpTab[i]>-1 then
    begin
     customTab[m]:=tmpTab[i]; Add[m]:=tmpAdd[i];
     inc(m);
    end
    else
     begin  {compact blank lines}
      k:=0; n:=i;
      while (tmpTab[n]<0) do
      begin
       inc(k); inc(n);
      end; {while tmptab[n]}
      customTab[m]:=-k; Add[m]:='';
      inc(m);
      inc(i,(k-1));
     end;
    if i>=(j-1) then fin:=true;
   end; {while i}
   addnum:=m-1;
   {check for embedded tabs and split}
   checkForTabs;



  end; {if linesUSED>0}
 end; {with}
end;

procedure TEditCustomInfo.CancelbuttonClick(Sender: TObject);
begin
 EditCustomInfo.close;
end;

procedure TEditCustomInfo.OKbuttonClick(Sender: TObject);
begin
 parseCustomOUT;

 EditCustomInfo.close;
end;

procedure TEditCustomInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TEditCustomInfo.FormActivate(Sender: TObject);
begin
 parseCustomIN;
end;

procedure TEditCustomInfo.Clear1Click(Sender: TObject);
begin
 if clearcustom then
  parseCustomIN;
end;

procedure TEditCustomInfo.New1Click(Sender: TObject);
begin
 if clearCustom then
 begin
  custom:='';
  UpdateWindow(wnInfo);
  parseCustomIN;
 end;
end;

procedure TEditCustomInfo.Open1Click(Sender: TObject);
begin
 MainForm.GetCustomFile;
 parseCustomIN;
end;

procedure TEditCustomInfo.Save1Click(Sender: TObject);
begin
 if usrPassLevel=utGen then
 begin
  showRestrictedMsg;  exit;
 end;
 parseCustomOUT;
 mainform.Savecustomfile1Click(self);
end;

end.
