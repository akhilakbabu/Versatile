unit Linksub;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs, ExtCtrls,TimeChartGlobals, XML.DISPLAY;

type
  TLinkSubDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    AddBtn: TBitBtn;
    RemoveBtn: TBitBtn;
    Finish: TBitBtn;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ScrollBox1: TScrollBox;
    image1: TImage;
    RemoveAll: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure restore;
    procedure setLinkTabs;
  end;

var
  LinkSubDlg: TLinkSubDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,block1,subyr;
var
 Sub1,Sub2,Linkpos1,Linkpos2,Ncols:  integer;
 Hmargin,txtheight:  integer;
 subwidth:   integer;
 Bitmap1:     Tbitmap;




procedure TLinkSubDlg.setLinkTabs;
var
 maxH:           integer;
begin
 checklink;
 Ncols:=(scrollbox1.width-2*Hmargin) div subwidth;
 if Ncols<1 then Ncols:=1;
 maxH:=txtheight*((linknum div Ncols)+2);
 Bitmap1.width:= image1.width;
 Bitmap1.height:=maxH;
 Bitmap1.canvas.brush.color:=clSilver;
 Bitmap1.canvas.floodfill(0,0,clSilver,fsBorder);
 image1.Picture.Graphic:=Bitmap1;
 image1.canvas.brush.color:=clSilver;
 image1.canvas.pen.color:=clBlack;
 scrollbox1.VertScrollbar.Range:=maxH;
end;

procedure showlinks;
var
 order:      array[0..nmbrsubjects] of bool;
 i,j,count:    integer;
 str:        string;
 x,y:        integer;

procedure newline;
 begin
   x:=0; y:=y+txtHeight;
 end;

begin
 x:=0;  y:=txtHeight;
 for i:=1 to nmbrsubjects do
   order[i]:=true;
 count:=0;  str:='';
 for i:=1 to codeCount[0] do
 begin
  j:=codepoint[i,0];
  if (link[j]<>0) and order[j] then
   begin
    str:=trim(SubCode[j])
                       +'-'+trim(SubCode[link[j]])+'  ';
    linksubdlg.image1.canvas.textout(x+Hmargin,y,str);
    order[link[j]]:=false;
    inc(count);
    x:=x+subwidth;
    if (count mod Ncols)=0 then newline;
   end;
 end; {for i}
end;


procedure TLinkSubDlg.restore;
begin
 Sub1:=0; Sub2:=0; Linkpos1:=0; Linkpos2:=0;
 setlinktabs;
 showlinks;
 if linknum=0 then
  begin
   RemoveBtn.Enabled:=false;
   RemoveAll.Enabled:=False;
  end
 else
  begin
   RemoveBtn.Enabled:=true;
   RemoveAll.Enabled:=true;
  end;
 Edit1.text:='';
 Edit2.text:='';
 Label5.caption:=inttostr(Linknum);
 Edit1.setfocus;
end;

procedure TLinkSubDlg.FormActivate(Sender: TObject);
var
 j,curTab: integer;
begin
 Edit1.Maxlength:=lencodes[0];
 Edit2.Maxlength:=lencodes[0];
 subwidth:=0;
 image1.canvas.font.Assign(XML_DISPLAY.tcfont);
 for j:=1 to GroupSubs[0] do
  begin
   curTab:=canvas.textwidth(trim(SubCode[GroupSubs[j]]));
   if (curTab>subwidth) then subwidth:=curTab;
  end;
 subwidth:=(2*subwidth)+canvas.textwidth('-   ');
 RemoveAll.Checked:=False;
 restore;
end;

procedure TLinkSubDlg.Edit1Change(Sender: TObject);
var
 codeStr:       string;
 codePlace:     integer;
begin
 codeStr:=trim(edit1.text);
 codePlace:=checkCode(0,codestr);
 if codePlace>0 then
  begin
   Sub1:=codePlace;
   codeStr:=Subname[Sub1];
   linkpos1:=link[codePlace];
   if linkpos1>0 then
    begin
     Edit2.text:=SubCode[linkpos1];
     codeStr:=CodeStr+' linked to '+SubCode[linkpos1];
    end;
   label3.caption:=codeStr;
  end
 else
  begin
   Sub1:=0; Linkpos1:=0; Sub2:=0;
   label3.caption:='';
   Edit2.text:='';
  end;

end;

procedure TLinkSubDlg.Edit2Change(Sender: TObject);
var
 codeStr:       string;
 codePlace:     integer;
begin
 {change check here}
 codeStr:=trim(edit2.text);
 codePlace:=checkCode(0,codestr);
 if codePlace>0 then
  begin
   Sub2:=codePlace;
   linkpos2:=link[codePlace];
   codeStr:=Subname[Sub2];
   if linkpos2>0 then codeStr:=CodeStr+' linked to '+SubCode[linkpos2];
   label3.caption:=codeStr;
  end
 else
  begin
   Sub2:=0; Linkpos2:=0;
   label3.caption:='';
  end;
end;

procedure removelinks(place,linkpos: integer);
var
 Csub1,Csub2,sub:       string;
 codeplace:   integer;
 i:                   integer;
 chr1,chr2:           char;
 sub3,sub4:  integer;
begin
 if link[place]=0 then exit;
 Csub1:=SubCode[linkpos];
 Csub2:=SubCode[link[linkpos]];
 link[place]:=0;
 link[linkpos]:=0;

 chr1:=Csub1[length(Csub1)];  chr2:=Csub2[length(Csub2)];
 if (chr1<>' ') or (chr2<>' ') then exit;
 SetLength(Csub1,Length(Csub1)-1);
 SetLength(Csub2,Length(Csub2)-1);
 for i:=1 to 26 do
  begin
   sub:=Csub1+chr(64+i);
   codePlace:=checkCode(0,sub);
   sub3:=codePlace;
   sub:=Csub2+chr(64+i);
   codePlace:=checkCode(0,sub);
   sub4:=codePlace;
   if (sub3>0) and (sub4>0) and (link[sub3]=Sub4)
            and (link[sub4]=Sub3) then
    begin
     link[sub3]:=0;
     link[sub4]:=0;
    end;
  end; {i}
end;

procedure addsplitlinks;
var
 Csub1,Csub2,sub:       string;
 codeplace:   integer;
 i:                   integer;
 chr1,chr2:           char;
 sub3,sub4:  integer;
begin
 Csub1:=SubCode[Sub1];
 Csub2:=SubCode[Sub2];
 chr1:=Csub1[length(Csub1)];  chr2:=Csub2[length(Csub2)];
 if (chr1<>' ') or (chr2<>' ') then exit;
 SetLength(Csub1,Length(Csub1)-1);
 SetLength(Csub2,Length(Csub2)-1);
 for i:=1 to 26 do
  begin
   sub:=Csub1+chr(64+i);
   codePlace:=checkCode(0,sub);
   sub3:=codePlace;
   sub:=Csub2+chr(64+i);
   codePlace:=checkCode(0,sub);
   sub4:=codePlace;
   if (sub3>0) and (sub4>0) then
    begin
     link[sub3]:=sub4;
     link[sub4]:=sub3;
    end;
  end; {i}
end;


procedure TLinkSubDlg.AddBtnClick(Sender: TObject);
begin
 if Sub1=0 then
  begin
   ShowMsg('Enter first subject to link',edit1);
   exit;
  end;
 if Sub2=0 then
  begin
   ShowMsg('Enter second subject to link',edit2);
   exit;
  end;
 if Sub1=Sub2 then
  begin
   ShowMsg('Can''t link '+SubCode[Sub1]+' to itself',edit2);
   exit;
  end;
 if linkpos1>0 then removelinks(Sub1,linkpos1);
 if linkpos2>0 then removelinks(Sub2,linkpos2);
 link[Sub1]:=Sub2;
 link[Sub2]:=Sub1;
 addsplitlinks;
 restore;
end;


procedure TLinkSubDlg.FormCreate(Sender: TObject);
begin
 Bitmap1:=Tbitmap.Create;
 Hmargin:=self.canvas.textwidth('AA');
 txtHeight:=self.canvas.textheight('A');
end;


procedure TLinkSubDlg.RemoveBtnClick(Sender: TObject);
var
 i: integer;
begin
 if RemoveAll.Checked then
   for i:=1 to nmbrsubjects do link[i]:=0
 else
  begin
   if Sub1=0 then
    begin
     ShowMsg('Enter subject link to remove',edit1);
     exit;
    end;
   if linkpos1=0 then
    begin
     ShowMsg('No link to remove',edit1);
     exit;
    end;
   if linkpos1>0 then removelinks(Sub1,linkpos1);
  end; {else - not remove all}
 restore;
end;


procedure TLinkSubDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Bitmap1.Free;
 action:=cafree;
end;

end.

