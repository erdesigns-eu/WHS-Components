{
  untDashboardListBox v1.0.0 -
  a Windows Server 2011 Dashboard style ListBox

  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}


unit untDashboardListBox;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, VCL.Themes;

type
  TDashboardNotificationListSelectEvent = procedure(Sender: TObject; const Index: Integer) of object;

  TDashboardNotificationListSelection = class(TPersistent)
  private
    { Private declarations }
    FFrom   : TColor;
    FTo     : TColor;
    FBorder : TColor;

    FOnChange  : TNotifyEvent;

    procedure SetFrom(const C: TColor);
    procedure SetTo(const C: TColor);
    procedure SetBorder(const C: TColor);
  public
    { Public declarations }
    constructor Create; virtual;

    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property FromColor: TColor read FFrom write SetFrom;
    property ToColor: TColor read FTo write SetTo;
    property Border: TColor read FBorder write SetBorder;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardListBoxItem = class(TCollectionItem)
  private
    FIcon : TPicture;
    FText : TCaption;

    FRect : TRect;

    procedure SetIcon(const P: TPicture);
    procedure SetText(const C: TCaption);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(AOWner: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure SettingsChanged(Sender: TObject);

    property ItemRect: TRect read FRect write FRect;
  published
    property Icon: TPicture read FIcon write SetIcon;
    property Text: TCaption read FText write SetText;
  end;

  TDashboardListBoxItemCollection = class(TOwnedCollection)
  private
    FOnChange : TNotifyEvent;

    procedure ItemChanged(Sender: TObject);

    function GetItem(Index: Integer): TDashboardListBoxItem;
    procedure SetItem(Index: Integer; const Value: TDashboardListBoxItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDashboardListBoxItem;
    procedure Assign(Source: TPersistent); override;

    property Items[Index: Integer]: TDashboardListBoxItem read GetItem write SetItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TDashboardListBox = class(TCustomControl)
  private
    { Private declarations }
    FItemHeight   : Integer;
    FItemIndex    : Integer;
    FItemPadding  : Integer;

    FItems        : TDashboardListBoxItemCollection;

    FSelected     : TDashboardNotificationListSelection;
    FHover        : TDashboardNotificationListSelection;
    FBorder       : Boolean;
    FIconSize     : Integer;

    { Buffer - Avoid flickering }
    FBuffer       : TBitmap;
    FUpdateRect   : TRect;
    FRedraw       : Boolean;

    FScrollPosY   : Integer;  // Scrollbar Position
    FOldScrollY   : Integer;
    FScrollMaxY   : Integer;

    FHotItemIndex : Integer;

    FOnSelect     : TDashboardNotificationListSelectEvent;

    procedure SetItemHeight(const I: Integer);
    procedure SetItemIndex(const I: Integer);
    procedure SetItemPadding(const I: Integer);
    procedure SetBorder(const B: Boolean);
    procedure SetIconSize(const I: Integer);

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure CMParentFontChanged(var Message: TCMParentFontChanged); message CM_PARENTFONTCHANGED;
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure Resize; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure SetScrollPosY(Y: Integer);
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;

    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property RedrawPanel: Boolean read FRedraw write FRedraw;
    property UpdateRect: TRect read FUpdateRect write FUpdateRect;
  published
    { Published declarations }
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 32;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TDashboardListBoxItemCollection read FItems write FItems;
    property ItemPadding: Integer read FItemPadding write SetItemPadding default 8;

    property Selected: TDashboardNotificationListSelection read FSelected write FSelected;
    property Hover: TDashboardNotificationListSelection read FHover write FHover;
    property Border: Boolean read FBorder write SetBorder default False;
    property IconSize: Integer read FIconSize write SetIconSize default 16;

    property OnSelect: TDashboardNotificationListSelectEvent read FOnSelect write FOnSelect;

    property Align default alLeft;
    property Anchors;
    property Color default clWhite;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Touch;
    property Visible;
    property ParentFont;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

procedure Register;

implementation

uses System.Math, GDIPlus;

(******************************************************************************)
(*
(*  Dashboard Notification List Item Selection (TDashboardNotificationListSelection)
(*
(******************************************************************************)
constructor TDashboardNotificationListSelection.Create;
begin
  inherited Create;
end;

procedure TDashboardNotificationListSelection.SetFrom(const C: TColor);
begin
  if FromColor <> C then
  begin
    FFrom := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardNotificationListSelection.SetTo(const C: TColor);
begin
  if ToColor <> C then
  begin
    FTo := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardNotificationListSelection.SetBorder(const C: TColor);
begin
  if Border <> C then
  begin
    FBorder := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardNotificationListSelection.Assign(Source: TPersistent);
begin
  if Source is TDashboardNotificationListSelection then
  begin
    FFrom   := TDashboardNotificationListSelection(Source).FromColor;
    FTo     := TDashboardNotificationListSelection(Source).ToColor;
    FBorder := TDashboardNotificationListSelection(Source).Border;
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard ListBox Item (TDashboardListBoxItem)
(*
(******************************************************************************)
constructor TDashboardListBoxItem.Create(AOWner: TCollection);
begin
  inherited Create(AOwner);

  { Create Picture }
  FIcon := TPicture.Create;
  FIcon.OnChange := SettingsChanged;

  { Defaults }
  FText := Format('Item %d', [Index]);
end;

destructor TDashboardListBoxItem.Destroy;
begin
  { Free Picture }
  FIcon.Free;

  inherited Destroy;
end;

function TDashboardListBoxItem.GetDisplayName : String;
begin
  Result := Text;
end;

procedure TDashboardListBoxItem.SetIcon(const P: TPicture);
begin
  FIcon.Assign(P);
  Changed(False);
end;

procedure TDashboardListBoxItem.SetText(const C: TCaption);
begin
  if Text <> C then
  begin
    FText := C;
    Changed(False);
  end;
end;

procedure TDashboardListBoxItem.Assign(Source: TPersistent);
begin
  if Source is TDashboardListBoxItem then
  begin
    Text := TDashboardListBoxItem(Source).Text;
    FIcon.Assign(TDashboardListBoxItem(Source).Icon);
    Changed(False);
  end else Inherited;
end;

procedure TDashboardListBoxItem.SettingsChanged(Sender: TObject);
begin
  Changed(False);
end;

(******************************************************************************)
(*
(*  Dashboard ListBox Item Collection (TDashboardListBoxItem)
(*
(******************************************************************************)
constructor TDashboardListBoxItemCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TDashboardListBoxItem);
end;

function TDashboardListBoxItemCollection.GetItem(Index: Integer) : TDashboardListBoxItem;
begin
  Result := inherited GetItem(Index) as TDashboardListBoxItem;
end;

function TDashboardListBoxItemCollection.Add : TDashboardListBoxItem;
begin
  Result := TDashboardListBoxItem(inherited Add);
end;

procedure TDashboardListBoxItemCollection.ItemChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self)
end;

procedure TDashboardListBoxItemCollection.SetItem(Index: Integer; const Value: TDashboardListBoxItem);
begin
  inherited SetItem(Index, Value);
  ItemChanged(Self);
end;

procedure TDashboardListBoxItemCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardListBoxItemCollection.Assign(Source: TPersistent);
var
  LI   : TDashboardListBoxItemCollection;
  Loop : Integer;
begin
  if (Source is TDashboardListBoxItemCollection)  then
  begin
    LI := TDashboardListBoxItemCollection(Source);
    Clear;
    for Loop := 0 to LI.Count - 1 do
        Add.Assign(LI.Items[Loop]);
  end else inherited;
end;

(******************************************************************************)
(*
(*  Dashboard ListBox (TDashboardListBox)
(*
(******************************************************************************)
constructor TDashboardListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { If the ControlStyle property includes csOpaque, the control paints itself
    directly. We dont want the control to accept controls }
  ControlStyle := ControlStyle + [csOpaque, csCaptureMouse, csClickEvents, csDoubleClicks];

  { We do want to be able to get focus, this is a list }
  TabStop := True;

  { Create Buffers }
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf32bit;
  FBuffer.Canvas.Brush.Style := bsClear;

  { Create Items }
  FItems := TDashboardListBoxItemCollection.Create(Self);
  FItems.OnChange := SettingsChanged;

  { Colors }
  FSelected := TDashboardNotificationListSelection.Create;
  FSelected.OnChange  := SettingsChanged;
  FSelected.Border    := $00C08F33;
  FSelected.FromColor := $00F1E4CD;
  FSelected.ToColor   := $00E2C692;

  FHover := TDashboardNotificationListSelection.Create;
  FHover.OnChange  := SettingsChanged;
  FHover.Border    := $00E6CC9B;
  FHover.FromColor := $00FBF7F0;
  FHover.ToColor   := $00F5EDDE;

  { Width / Height }
  Width  := 321;
  Height := 185;

  { Defaults }
  Align        := alLeft;
  FItemHeight  := 32;
  FItemIndex   := -1;
  FItemPadding := 8;
  TabStop      := True;
  Color        := clWhite;
  FBorder      := False;
  FIconSize    := 16;

  { Initial Draw }
  RedrawPanel   := True;
  FHotItemIndex := -1;
  FScrollPosY   := 0;
end;

destructor TDashboardListBox.Destroy;
begin
  { Free Buffer }
  FBuffer.Free;

  { Free Items }
  FItems.Free;

  inherited Destroy;
end;

procedure TDashboardListBox.SetItemHeight(const I: Integer);
begin
  if ItemHeight <> I then
  begin
    FItemHeight := I;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardListBox.SetItemIndex(const I: Integer);
var
  Y, D : Integer;
begin
  if ItemIndex <> I then
  begin
    if (I < -1) then
      FItemIndex := -1
    else
    if (I > Items.Count -1) then
      FitemIndex := Items.Count -1
    else
      FItemIndex := I;

    if (FItemIndex >= 0) then
    begin
      if Items.Items[FItemIndex].ItemRect.Bottom > ClientRect.Bottom then
      begin
        Y := Ceil((FScrollPosY + ItemHeight) / ItemHeight) * ItemHeight;
        if Y <= (FScrollMaxY - ClientHeight) then
          FScrollPosY := Y
        else
          FScrollPosY := (FScrollMaxY - ClientHeight) + 4;
      end else
      if Items.Items[FItemIndex].ItemRect.Top < ClientRect.Top then
      begin
        Y := (FScrollPosY - ItemHeight);
        if Y > 0 then
          FScrollPosY := Y
        else
          FScrollPosY := 0;
      end;
    end;

    if Assigned(FOnSelect) then FOnSelect(Self, ItemIndex);
    SettingsChanged(Self);
  end;
end;

procedure TDashboardListBox.SetItemPadding(const I: Integer);
begin
  if ItemPadding <> I then
  begin
    FItemPadding := I;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardListBox.SetBorder(const B: Boolean);
begin
  if Border <> B then
  begin
    FBorder := B;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardListBox.SetIconSize(const I: Integer);
begin
  if IconSize <> I then
  begin
    FIconSize := I;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardListBox.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TDashboardListBox.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TDashboardListBox.CMMouseEnter(var Msg: TMessage);
begin
  if (FHotItemIndex <> -1) then
  begin
    FHotItemIndex := -1;
    RedrawPanel   := True;
    Invalidate;
  end;
end;

procedure TDashboardListBox.CMMouseLeave(var Msg: TMessage);
begin
  if (FHotItemIndex <> -1) then
  begin
    FHotItemIndex := -1;
    RedrawPanel   := True;
    Invalidate;
  end;
end;

procedure TDashboardListBox.CMParentFontChanged(var Message: TCMParentFontChanged);
begin
  if ParentFont then
  begin
    if Message.WParam <> 0 then
    begin
      Font.Name  := Message.Font.Name;
      Font.Style := Message.Font.Style;
    end;
  end;
end;

procedure TDashboardListBox.Paint;
var
  WorkRect: TRect;

  procedure DrawBackground;
  var
    LDetails : TThemedElementDetails;
  begin
    with FBuffer.Canvas do
    begin
      if Border then
      begin
        Brush.Color := StyleServices.GetStyleColor(scComboBox);
        if Enabled then
          LDetails := StyleServices.GetElementDetails(tcBorderNormal)
        else
          LDetails := StyleServices.GetElementDetails(tcBorderDisabled);
        StyleServices.DrawElement(FBuffer.Canvas.Handle, LDetails, ClientRect);
      end else
      begin
        Brush.Color := Color;
        FillRect(ClientRect);
      end;
    end;
  end;

  function SelectionPath(Rect: TRect; Corner: Integer) : IGPGraphicsPath;
  var
    RoundRectPath : IGPGraphicsPath;
  begin
    RoundRectPath := TGPGraphicsPath.Create;
    RoundRectPath.AddArc(Rect.Left, Rect.Top, Corner, Corner, 180, 90);
    RoundRectPath.AddArc(Rect.Right - Corner, Rect.Top, Corner, Corner, 270, 90);
    RoundRectPath.AddArc(Rect.Right - Corner, Rect.Bottom - Corner, Corner, Corner, 0, 90);
    RoundRectPath.AddArc(Rect.Left, Rect.Bottom - Corner, Corner, Corner, 90, 90);
    RoundRectPath.CloseFigure;
    Result := RoundRectPath;
  end;

  procedure DrawItem(var FGraphics: IGPGraphics; const Index: Integer);
  var
    ItemRect, R : TRect;
    X, Y        : Integer;

    GradientBrush      : IGPLinearGradientBrush;
    FromColor, ToColor : TGPColor;
    FBorderColor       : TGPColor;
    FBorderPen         : IGPPen;
    FSelectionPath     : IGPGraphicsPath;
  begin
    ItemRect := Rect(
      Items.Items[Index].ItemRect.Left + 2,
      Items.Items[Index].ItemRect.Top + 1,
      Items.Items[Index].ItemRect.Right - 2,
      Items.Items[Index].ItemRect.Bottom -1
    );
    with FBuffer.Canvas do
    begin
      { Hover }
      if FHotItemIndex = Index then
      begin
        FBorderColor   := TGPColor.CreateFromColorRef(Hover.Border);
        FBorderPen     := TGPPen.Create(FBorderColor);
        FromColor      := TGPColor.CreateFromColorRef(Hover.FromColor);
        ToColor        := TGPColor.CreateFromColorRef(Hover.ToColor);
        GradientBrush  := TGPLinearGradientBrush.Create(TGPRect.Create(Items.Items[Index].ItemRect), FromColor, ToColor, 90);
        FSelectionPath := SelectionPath(ItemRect, 4);
        FGraphics.FillPath(GradientBrush, FSelectionPath);
        FGraphics.DrawPath(FBorderPen, FSelectionPath);
      end;
      { Selected }
      if ItemIndex = Index then
      begin
        FBorderColor   := TGPColor.CreateFromColorRef(Selected.Border);
        FBorderPen     := TGPPen.Create(FBorderColor);
        FromColor      := TGPColor.CreateFromColorRef(Selected.FromColor);
        ToColor        := TGPColor.CreateFromColorRef(Selected.ToColor);
        GradientBrush  := TGPLinearGradientBrush.Create(TGPRect.Create(Items.Items[Index].ItemRect), FromColor, ToColor, 90);
        FSelectionPath := SelectionPath(ItemRect, 4);
        FGraphics.FillPath(GradientBrush, FSelectionPath);
        FGraphics.DrawPath(FBorderPen, FSelectionPath);
      end;
      { Icon }
      if Assigned(Items.Items[Index].Icon.Graphic) then
      begin
        R := Rect(
          ItemRect.Left + ItemPadding,
          (ItemRect.Top + (ItemHeight div 2)) - (IconSize div 2),
          ItemRect.Left + ItemPadding + IconSize,
          (ItemRect.Top + (ItemHeight div 2)) + (IconSize div 2)
        );
        StretchDraw(R, Items.Items[Index].Icon.Graphic);
      end;
      { Title }
      Brush.Style := bsClear;
      Font.Assign(Self.Font);
      R := ItemRect;
      R.Left := ItemRect.Left + ItemPadding + IconSize + ItemPadding;
      DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[Index].Text), Length(Items.Items[Index].Text), R, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
    end;
  end;

  procedure DrawItems(var FGraphics: IGPGraphics);
  var
    X, I : Integer;
  begin
    X := 0;
    for I := 0 to Items.Count -1 do
    begin
      Items.Items[I].ItemRect := Rect(
          WorkRect.Left,
          (WorkRect.Top - FScrollPosY) + X,
          WorkRect.Right,
          (WorkRect.Top - FScrollPosY) + ItemHeight + X
      );
      Inc(X, ItemHeight);
    end;
    for I := 0 to Items.Count -1 do DrawItem(FGraphics, I);
  end;

var
  FGraphics : IGPGraphics;
var
  X, Y, W, H : Integer;
  SI         : TScrollInfo;
begin
  { Draw the panel to the buffer }
  if RedrawPanel then
  begin
    FScrollMaxY := Items.Count * ItemHeight;

    RedrawPanel := False;
    WorkRect := ClientRect;

    { Set Buffer size }
    FBuffer.SetSize(ClientWidth, ClientHeight);

    { Create GDI+ Graphic }
    FGraphics := TGPGraphics.Create(FBuffer.Canvas.Handle);
    FGraphics.SmoothingMode := SmoothingModeAntiAlias;
    FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;

    { Draw to buffer }
    DrawBackground;
    DrawItems(FGraphics);
  end;

  { Scrollbar }
  SI.cbSize := Sizeof(SI);
  SI.fMask  := SIF_ALL;
  SI.nMin   := 0;
  SI.nMax   := FScrollMaxY;
  SI.nPage  := ClientHeight;
  SI.nPos   := FScrollPosY;
  SI.nTrackPos := SI.nPos;
  SetScrollInfo(Handle, SB_VERT, SI, True);

  { Now draw the Buffer to the components surface }
  X := UpdateRect.Left;
  Y := UpdateRect.Top;
  W := UpdateRect.Right - UpdateRect.Left;
  H := UpdateRect.Bottom - UpdateRect.Top;
  if (W <> 0) and (H <> 0) then
    { Only update part - invalidated }
    BitBlt(Canvas.Handle, X, Y, W, H, FBuffer.Canvas.Handle, X,  Y, SRCCOPY)
  else
    { Repaint the whole buffer to the surface }
    BitBlt(Canvas.Handle, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, X,  Y, SRCCOPY);

  inherited;
end;

procedure TDashboardListBox.Resize;
begin
  if (FScrollMaxY > ClientHeight) and (FScrollPosY >= (FScrollMaxY - ClientHeight)) then FScrollPosY := (FScrollMaxY - ClientHeight);
  RedrawPanel := True;
  inherited;
end;

procedure TDashboardListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  Style := Style or WS_VSCROLL and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TDashboardListBox.WndProc(var Message: TMessage);
var
  SI : TScrollInfo;
begin
  inherited;
  case Message.Msg of
    // Capture Keystrokes
    WM_GETDLGCODE:
      Message.Result := Message.Result or DLGC_WANTARROWS or DLGC_WANTALLKEYS;

    { Enabled/Disabled - Redraw }
    CM_ENABLEDCHANGED:
      begin
        RedrawPanel := True;
        Invalidate;
      end;

    { The color changed }
    CM_COLORCHANGED:
      begin
        RedrawPanel := True;
        Invalidate;
      end;

    { Vertical Scrollbar }
    WM_VSCROLL:
      begin
        case Message.WParamLo of
          SB_TOP      : SetScrollPosY(0);
          SB_BOTTOM   : SetScrollPosY(FScrollMaxY);
          SB_LINEUP   : SetScrollPosY(FScrollPosY - 10);
          SB_LINEDOWN : SetScrollPosY(FScrollPosY + 10);
          SB_PAGEUP   : SetScrollPosY(FScrollPosY - ClientHeight);
          SB_PAGEDOWN : SetScrollPosY(FScrollPosY + ClientHeight);
          SB_THUMBTRACK:
            begin
              ZeroMemory(@SI, SizeOf(SI));
              SI.cbSize := Sizeof(SI);
              SI.fMask := SIF_TRACKPOS;
              if GetScrollInfo(Handle, SB_VERT, SI) then
                SetScrollPosY(SI.nTrackPos);
            end;
        end;
        Message.Result := 0;
      end;
  end;
end;

procedure TDashboardListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
var
  I : Integer;
begin
  if Enabled then
  begin
    if not Focused and CanFocus then SetFocus;
    for I := 0 to Items.Count -1 do
    if PTInRect(Items.Items[I].ItemRect, Point(X, Y)) then
    begin
      ItemIndex := I;
      Break;
    end;
  end;
  inherited;
end;

procedure TDashboardListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  inherited
end;

procedure TDashboardListBox.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
var
  I : Integer;
  R : Boolean;
begin
  if Enabled then
  begin
    R := False;
    if (FHotItemIndex <> -1) then
    begin
      FHotItemIndex := -1;
      R := True;
    end;
    for I := 0 to Items.Count -1 do
    if PTInRect(Items.Items[I].ItemRect, Point(X, Y)) then
    begin
      FHotItemIndex := I;
      R := True;
      Break;
    end;
    if R then
    begin
      RedrawPanel := True;
      Invalidate;
    end;
  end;
  inherited;
end;

procedure TDashboardListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  FHotItemIndex := -1;
  case Key of
    VK_LEFT  : if (ItemIndex > 0) then ItemIndex := ItemIndex -1;
    VK_UP    : if (ItemIndex > 0) then ItemIndex := ItemIndex -1;
    VK_RIGHT : ItemIndex := ItemIndex +1;
    VK_DOWN  : ItemIndex := ItemIndex +1;
    VK_HOME  : ItemIndex := 0;
    VK_END   : ItemIndex := Items.Count -1;
    VK_PRIOR : ItemIndex := 0;
    VK_NEXT  : ItemIndex := Items.Count -1;
  end;
  inherited;
end;

procedure TDashboardListBox.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;

procedure TDashboardListBox.SetScrollPosY(Y: Integer);
var
  M : Integer;
begin
  if (FScrollMaxY > ClientHeight) then
  begin
    M := (FScrollMaxY - ClientHeight) + 4;
    if Y > M then Y := M;
    FScrollPosY := Y;
    FScrollPosY := EnsureRange(FScrollPosY, 0, FScrollMaxY);
    RedrawPanel := True;
    if FOldScrollY <> FScrollPosY then Invalidate;
    FOldScrollY := FScrollPosY;
  end;
end;

function TDashboardListBox.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  if Enabled then
  begin
    SetScrollPosY(FScrollPosY - (WheelDelta div 10));
  end;
  Result := True;
end;

procedure TDashboardListBox.SettingsChanged(Sender: TObject);
begin
  RedrawPanel := True;
  Invalidate;
end;

(******************************************************************************)
(*
(*  Register Dashboard ListBox (TDashboardListBox)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardListBox]);
end;

end.
