unit FamilyClash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, uAMGFamily, StdCtrls, Buttons, ExtCtrls, XML.DISPLAY;

type
  TFrmFamilyClash = class(TForm)
    lvwFamilyClash: TListView;
    pnlFamilyClashButtons: TPanel;
    btnFamilyClashClose: TBitBtn;
    procedure FormShow(Sender: TObject);
  private
    FFamilyClashes: TAMGFamilyClashes;
  public
    property FamilyClashes: TAMGFamilyClashes read FFamilyClashes write FFamilyClashes;
  end;

var
  FrmFamilyClash: TFrmFamilyClash;

implementation

uses
  TCommon, TimeChartGlobals;

{$R *.dfm}

procedure TFrmFamilyClash.FormShow(Sender: TObject);
var
  lItem: TListItem;
  i: Integer;
  lStudID: Integer;
begin
  for i := 0 to FamilyClashes.Count - 1 do
  begin
    lItem := lvwFamilyClash.Items.Add;
    lItem.Caption := TAMGFamilyClash(FFamilyClashes.Items[i]).FamilyCode;
    lStudID := findStudentByID(TAMGFamilyClash(FFamilyClashes.Items[i]).StudentCode);
    lItem.SubItems.Add(GetStudentName(lStudID));
    lItem.SubItems.Add(TAMGFamilyClash(FFamilyClashes.Items[i]).Day);
    lItem.SubItems.Add(TAMGFamilyClash(FFamilyClashes.Items[i]).TimeSlot);
  end;
  lvwFamilyClash.Font.Assign(XML_DISPLAY.tcFont);
  lvwFamilyClash.Font.Style := [];
end;

end.
