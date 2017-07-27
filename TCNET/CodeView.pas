unit CodeView;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,ClassDefs,TimeChartGlobals, XML.DISPLAY;

type
  TViewCodeDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Show: TRadioGroup;
    Sort: TRadioGroup;
    procedure OKBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  ViewCodeDialog: TViewCodeDialog;

implementation
{$R *.DFM}

procedure TViewCodeDialog.OKBtnClick(Sender: TObject);
begin
 winView[tag]:=show.ItemIndex;
 XML_DISPLAY.sorttype[tag-2]:=sort.ItemIndex;
end;

procedure TViewCodeDialog.FormActivate(Sender: TObject);
begin
 caption:=codeNameCap[tag-2]+' codes View';
 case tag of
  wnSucode:begin
             HelpContext:=134;
             if NumSubRepCodes>0 then Show.Items.Add('Report Codes');
           end;
  wnTecode: HelpContext:=141;
  wnRocode: HelpContext:=147;
 end;
 Show.ItemIndex:=winView[tag];
 Sort.ItemIndex:=XML_DISPLAY.sorttype[tag-2];
end;

end.
