{
  untDashboardNotificationList v1.0.0 -
  a Windows Server 2011 Dashboard style Notification List

  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}


unit untDashboardNotificationList;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, VCL.Themes;

type
  TDashboardNotificationListItemType    = (itError, itWarning, itInfo);
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

  TDashboardNotificationListItem = class(TCollectionItem)
  private
    FType     : TDashboardNotificationListItemType;
    FTitle    : TCaption;
    FSubtitle : TCaption;

    FRect     : TRect;

    procedure SetType(const T: TDashboardNotificationListItemType);
    procedure SetTitle(const C: TCaption);
    procedure SetSubtitle(const C: TCaption);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(AOWner: TCollection); override;

    procedure Assign(Source: TPersistent); override;
    property ItemRect: TRect read FRect write FRect;
  published
    property NotificationType: TDashboardNotificationListItemType read FType write SetType default itError;
    property Title: TCaption read FTitle write SetTitle;
    property Subtitle: TCaption read FSubtitle write SetSubtitle;
  end;

  TDashboardNotificationListCollection = class(TOwnedCollection)
  private
    FOnChange : TNotifyEvent;

    procedure ItemChanged(Sender: TObject);

    function GetItem(Index: Integer): TDashboardNotificationListItem;
    procedure SetItem(Index: Integer; const Value: TDashboardNotificationListItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDashboardNotificationListItem;
    procedure Assign(Source: TPersistent); override;

    property Items[Index: Integer]: TDashboardNotificationListItem read GetItem write SetItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TDashboardNotificationList = class(TCustomControl)
  private
    { Private declarations }
    FError        : TPicture;
    FWarning      : TPicture;
    FInfo         : TPicture;

    FTitleFont    : TFont;
    FSubtitleFont : TFont;

    FItemHeight   : Integer;
    FItemIndex    : Integer;
    FItemPadding  : Integer;

    FItems        : TDashboardNotificationListCollection;

    FSelected     : TDashboardNotificationListSelection;
    FHover        : TDashboardNotificationListSelection;
    FBorder       : Boolean;

    { Buffer - Avoid flickering }
    FBuffer       : TBitmap;
    FUpdateRect   : TRect;
    FRedraw       : Boolean;

    FScrollPosY   : Integer;  // Scrollbar Position
    FOldScrollY   : Integer;
    FScrollMaxY   : Integer;

    FHotItemIndex : Integer;

    FOnSelect     : TDashboardNotificationListSelectEvent;

    procedure SetError(const P: TPicture);
    procedure SetWarning(const P: TPicture);
    procedure SetInfo(const P: TPicture);

    procedure SetTitleFont(const F: TFont);
    procedure SetSubtitleFont(const F: TFont);

    procedure SetItemHeight(const I: Integer);
    procedure SetItemIndex(const I: Integer);
    procedure SetItemPadding(const I: Integer);
    procedure SetBorder(const B: Boolean);

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
    property Error: TPicture read FError write SetError;
    property Warning: TPicture read FWarning write SetWarning;
    property Info: TPicture read FInfo write SetInfo;

    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property SubtitleFont: TFont read FSubtitleFont write SetSubtitleFont;

    property ItemHeight: Integer read FItemHeight write SetItemHeight default 38;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TDashboardNotificationListCollection read FItems write FItems;
    property ItemPadding: Integer read FItemPadding write SetItemPadding default 8;

    property Selected: TDashboardNotificationListSelection read FSelected write FSelected;
    property Hover: TDashboardNotificationListSelection read FHover write FHover;
    property Border: Boolean read FBorder write SetBorder default False;

    property OnSelect: TDashboardNotificationListSelectEvent read FOnSelect write FOnSelect;

    property Align default alLeft;
    property Anchors;
    property Color default clWhite;
    property Constraints;
    property Enabled;
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
(*  Dashboard Notification List Item (TDashboardNotificationListItem)
(*
(******************************************************************************)
constructor TDashboardNotificationListItem.Create(AOWner: TCollection);
begin
  inherited Create(AOwner);

  { Defaults }
  FTitle    := Format('Item %d', [Index]);
  FSubTitle := Format('Subtitle %d', [Index]);
end;

function TDashboardNotificationListItem.GetDisplayName : String;
begin
  Result := Format('%s - %s', [Title, Subtitle]);
end;

procedure TDashboardNotificationListItem.SetType(const T: TDashboardNotificationListItemType);
begin
  if NotificationType <> T then
  begin
    FType := T;
    Changed(False);
  end;
end;

procedure TDashboardNotificationListItem.SetTitle(const C: TCaption);
begin
  if Title <> C then
  begin
    FTitle := C;
    Changed(False);
  end;
end;

procedure TDashboardNotificationListItem.SetSubtitle(const C: TCaption);
begin
  if SubTitle <> C then
  begin
    FSubTitle := C;
    Changed(False);
  end;
end;

procedure TDashboardNotificationListItem.Assign(Source: TPersistent);
begin
  if Source is TDashboardNotificationListItem then
  begin
    Title            := TDashboardNotificationListItem(Source).Title;
    SubTitle         := TDashboardNotificationListItem(Source).Subtitle;
    NotificationType := TDashboardNotificationListItem(Source).NotificationType;
    Changed(False);
  end else Inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Notification List Item Collection (TDashboardNotificationListCollection)
(*
(******************************************************************************)
constructor TDashboardNotificationListCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TDashboardNotificationListItem);
end;

function TDashboardNotificationListCollection.GetItem(Index: Integer) : TDashboardNotificationListItem;
begin
  Result := inherited GetItem(Index) as TDashboardNotificationListItem;
end;

function TDashboardNotificationListCollection.Add : TDashboardNotificationListItem;
begin
  Result := TDashboardNotificationListItem(inherited Add);
end;

procedure TDashboardNotificationListCollection.ItemChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self)
end;

procedure TDashboardNotificationListCollection.SetItem(Index: Integer; const Value: TDashboardNotificationListItem);
begin
  inherited SetItem(Index, Value);
  ItemChanged(Self);
end;

procedure TDashboardNotificationListCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardNotificationListCollection.Assign(Source: TPersistent);
var
  LI   : TDashboardNotificationListCollection;
  Loop : Integer;
begin
  if (Source is TDashboardNotificationListCollection)  then
  begin
    LI := TDashboardNotificationListCollection(Source);
    Clear;
    for Loop := 0 to LI.Count - 1 do
        Add.Assign(LI.Items[Loop]);
  end else inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Notification List (TDashboardNotificationList)
(*
(******************************************************************************)
constructor TDashboardNotificationList.Create(AOwner: TComponent);
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
  FItems := TDashboardNotificationListCollection.Create(Self);
  FItems.OnChange := SettingsChanged;

  { Create Pictures }
  FError := TPicture.Create;
  FError.OnChange := SettingsChanged;
  FWarning := TPicture.Create;
  FWarning.OnChange := SettingsChanged;
  FInfo := TPicture.Create;
  FInfo.OnChange := SettingsChanged;

  { Create Fonts }
  FTitleFont := TFont.Create;
  FTitleFont.OnChange := SettingsChanged;
  FSubtitleFont := TFont.Create;
  FSubtitleFont.OnChange := SettingsChanged;
  FSubtitleFont.Color := clGrayText;

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
  FItemHeight  := 38;
  FItemIndex   := -1;
  FItemPadding := 8;
  TabStop      := True;
  Color        := clWhite;
  FBorder      := False;

  { Initial Draw }
  RedrawPanel   := True;
  FHotItemIndex := -1;
  FScrollPosY   := 0;
end;

destructor TDashboardNotificationList.Destroy;
begin
  { Free Buffer }
  FBuffer.Free;

  { Free Items }
  FItems.Free;

  { Free Pictures }
  FError.Free;
  FWarning.Free;
  FInfo.Free;

  { Free Fonts }
  FTitleFont.Free;
  FSubtitleFont.Free;

  { Free Colors }
  FSelected.Free;
  FHover.Free;

  inherited Destroy;
end;

procedure TDashboardNotificationList.SetError(const P: TPicture);
begin
  FError.Assign(P);
  SettingsChanged(Self);
end;

procedure TDashboardNotificationList.SetWarning(const P: TPicture);
begin
  FWarning.Assign(P);
  SettingsChanged(Self);
end;

procedure TDashboardNotificationList.SetInfo(const P: TPicture);
begin
  FInfo.Assign(P);
  SettingsChanged(Self);
end;

procedure TDashboardNotificationList.SetTitleFont(const F: TFont);
begin
  FTitleFont.Assign(F);
  SettingsChanged(Self);
end;

procedure TDashboardNotificationList.SetSubtitleFont(const F: TFont);
begin
  FSubtitleFont.Assign(F);
  SettingsChanged(Self);
end;

procedure TDashboardNotificationList.SetItemHeight(const I: Integer);
begin
  if ItemHeight <> I then
  begin
    FItemHeight := I;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardNotificationList.SetItemIndex(const I: Integer);
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

procedure TDashboardNotificationList.SetItemPadding(const I: Integer);
begin
  if ItemPadding <> I then
  begin
    FItemPadding := I;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardNotificationList.SetBorder(const B: Boolean);
begin
  if Border <> B then
  begin
    FBorder := B;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardNotificationList.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TDashboardNotificationList.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TDashboardNotificationList.CMMouseEnter(var Msg: TMessage);
begin
  if (FHotItemIndex <> -1) then
  begin
    FHotItemIndex := -1;
    RedrawPanel   := True;
    Invalidate;
  end;
end;

procedure TDashboardNotificationList.CMMouseLeave(var Msg: TMessage);
begin
  if (FHotItemIndex <> -1) then
  begin
    FHotItemIndex := -1;
    RedrawPanel   := True;
    Invalidate;
  end;
end;

procedure TDashboardNotificationList.CMParentFontChanged(var Message: TCMParentFontChanged);
begin
  if ParentFont then
  begin
    if Message.WParam <> 0 then
    begin
      TitleFont.Name     := Message.Font.Name;
      TitleFont.Style    := Message.Font.Style;
      SubtitleFont.Name  := Message.Font.Name;
      SubtitleFont.Style := Message.Font.Style;
    end;
  end;
end;

procedure TDashboardNotificationList.Paint;
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
    ItemRect, R        : TRect;
    X, Y, W            : Integer;

    GradientBrush      : IGPLinearGradientBrush;
    FromColor, ToColor : TGPColor;
    FBorderColor       : TGPColor;
    FBorderPen         : IGPPen;
    FSelectionPath     : IGPGraphicsPath;
  begin
    W := 0;
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
      { Notification Icon }
      case Items.Items[Index].NotificationType of
        itError:
        if Assigned(Error.Graphic) then
        begin
          X := ItemRect.Left + ItemPadding;
          Y := (ItemRect.Top + (ItemHeight div 2)) - (Error.Graphic.Height div 2);
          W := Error.Graphic.Width;
          Draw(X, Y, Error.Graphic);
        end;

        itWarning:
        if Assigned(Warning.Graphic) then
        begin
          X := ItemRect.Left + ItemPadding;
          Y := (ItemRect.Top + (ItemHeight div 2)) - (Warning.Graphic.Height div 2);
          W := Warning.Graphic.Width;
          Draw(X, Y, Warning.Graphic);
        end;

        itInfo:
        if Assigned(Info.Graphic) then
        begin
          X := ItemRect.Left + ItemPadding;
          Y := (ItemRect.Top + (ItemHeight div 2)) - (Info.Graphic.Height div 2);
          W := Info.Graphic.Width;
          Draw(X, Y, Info.Graphic);
        end;
      end;
      { Title }
      Brush.Style := bsClear;
      Font.Assign(TitleFont);
      R := Rect(
        ItemRect.Left + ItemPadding + W + ItemPadding,
        ItemRect.Top,
        ItemRect.Right - ItemPadding,
        ItemRect.Top + (ItemHeight div 2)
      );
      DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[Index].Title), Length(Items.Items[Index].Title), R, DT_BOTTOM or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
      { Subtitle }
      Font.Assign(SubtitleFont);
      R := Rect(
        ItemRect.Left + ItemPadding + W + ItemPadding,
        ItemRect.Top + (ItemHeight div 2),
        ItemRect.Right - ItemPadding,
        ItemRect.Bottom
      );
      DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[Index].SubTitle), Length(Items.Items[Index].SubTitle), R, DT_TOP or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
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

procedure TDashboardNotificationList.Resize;
begin
  if (FScrollMaxY > ClientHeight) and (FScrollPosY >= (FScrollMaxY - ClientHeight)) then FScrollPosY := (FScrollMaxY - ClientHeight);
  RedrawPanel := True;
  inherited;
end;

procedure TDashboardNotificationList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  Style := Style or WS_VSCROLL and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TDashboardNotificationList.WndProc(var Message: TMessage);
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

procedure TDashboardNotificationList.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
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

procedure TDashboardNotificationList.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  inherited
end;

procedure TDashboardNotificationList.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
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

procedure TDashboardNotificationList.KeyDown(var Key: Word; Shift: TShiftState);
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

procedure TDashboardNotificationList.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;

procedure TDashboardNotificationList.SetScrollPosY(Y: Integer);
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

function TDashboardNotificationList.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  if Enabled then
  begin
    SetScrollPosY(FScrollPosY - (WheelDelta div 10));
  end;
  Result := True;
end;

procedure TDashboardNotificationList.SettingsChanged(Sender: TObject);
begin
  RedrawPanel := True;
  Invalidate;
end;

(******************************************************************************)
(*
(*  Register Dashboard Notification List (TDashboardNotificationList)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardNotificationList]);
end;

end.
