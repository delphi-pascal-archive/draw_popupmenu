unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList;

type
  TForm1 = class(TForm)
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    procedure ApplicationHintHandler(Sender: TObject);
  public
    procedure OwnerDrawPopupMenuItems(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure AdvancedDrawItems(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; State: TOwnerDrawState);
    procedure MeasureItems(Sender: TObject; ACanvas: TCanvas;
      var Width, Height: Integer);
  end;

var
  Form1:        TForm1;
  PosX:         integer;
  PosY:         integer;
  HintWindow:   THintWindow;
  SizeRect:     TRect;
  HRect:        TRect;
  GutterBitmap: TBitmap;
  
implementation

{$R *.dfm}

procedure TForm1.ApplicationHintHandler(Sender: TObject);
begin

end;

procedure TForm1.OwnerDrawPopupMenuItems(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
  Rect: TRect;
begin
  HintWindow.Canvas.FillRect(Rect);
  if Selected then
  begin
  if (Sender as TMenuItem).Hint = '' then
  begin
    HintWindow.ReleaseHandle;
  end;
  if (Sender as TMenuItem).Caption = '-' then
  begin
    HintWindow.ReleaseHandle;
  end;
    SizeRect := HintWindow.CalcHintRect(999, (Sender as TMenuItem).Hint, nil);
    SizeRect.Left := SizeRect.Left + PosX + ARect.Right div 2;
    SizeRect.Right := SizeRect.Right + PosX + ARect.Right div 2;
    SizeRect.Top := SizeRect.Top + PosY + ARect.Top + 25;
    SizeRect.Bottom := SizeRect.Bottom + PosY + ARect.Top + 25;
    HintWindow.Color:= clInfoBk;
    HintWindow.ActivateHint(SizeRect, (Sender as TMenuItem).Hint);
  end
  else
  begin
    HintWindow.ReleaseHandle;
  end;
end;

procedure TForm1.AdvancedDrawItems(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; State: TOwnerDrawState);
begin
  ACanvas.FillRect(ARect);
  CopyRect(HRect, ARect);
if odSelected in State then
begin
  ACanvas.Brush.Style:= bsSolid;
  ACanvas.Brush.Color:= RGB(198, 211, 239);
  ACanvas.Pen.Style:= psSolid;
  ACanvas.Pen.Color:= RGB(49, 105, 198);
  ACanvas.Rectangle(ARect);
  ACanvas.Font.Color:= clBlack;
  if (Sender as TMenuItem).Checked then
    begin
      ImageList1.Draw(ACanvas, ARect.Left+5, ARect.Top+4, 6);
    end;
end
else
begin
  ACanvas.Pen.Style:= psClear;
  ACanvas.StretchDraw(Rect(ARect.Left, ARect.Top , ARect.Left+ 25, ARect.Bottom ), GutterBitmap);
  if (Sender as TMenuItem).Caption='-' then
  begin
    ACanvas.Pen.Color:= clGrayText;
    ACanvas.Pen.Style:= psSolid;
    ACanvas.MoveTo(ARect.Left + 31, ARect.Top + 1);
    ACanvas.LineTo(ARect.Right, ARect.Top + 1);
    Exit;
  end;
  // Если пункт чёкнутый рисуйте какуйнить иконку из ImageList'а - ImageList1.Draw(...)
  // Если пункт Default = true пишите ACanvas.Font.Style:= fsBold
  // Ну и так далее
  if (Sender as TMenuItem).Checked then
  begin
    ImageList1.Draw(ACanvas, ARect.Left+5, ARect.Top+4, 6);
  end;
end;
  ImageList1.Draw(ACanvas, 3, ARect.Top + 3, (Sender as TMenuItem).MenuIndex, true);
  ACanvas.TextOut(27, ARect.Top + 3, (Sender as TMenuItem).Caption);
end;

procedure TForm1.MeasureItems(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
begin
  if (Sender as TMenuItem).Caption='-' then
  Height:= 3
  else
  Height:= 22;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  HintWindow:= THintWindow.Create(Self);
  Application.OnHint := ApplicationHintHandler;
  GutterBitmap:= TBitmap.Create;
  GutterBitmap.Width:= 1;
  GutterBitmap.Height:= 1;
  GutterBitmap.Canvas.Pen.Color:= clBtnFace;
  GutterBitmap.Canvas.Rectangle(0,0,31,6);
  for i:= 0 to  PopupMenu1.Items.Count - 1 do
  begin
    PopupMenu1.Items.Items[i].OnDrawItem:= OwnerDrawPopupMenuItems;
    PopupMenu1.Items.Items[i].OnMeasureItem:= MeasureItems;
    PopupMenu1.Items.Items[i].OnAdvancedDrawItem:= AdvancedDrawItems;
  end;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  PosY:= Mouse.CursorPos.Y;
  PosX:= Mouse.CursorPos.X;
end;


end.
