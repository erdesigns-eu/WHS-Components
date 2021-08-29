{
  untDashboardSettingsPanel v1.0.0 -
  a Windows Server 2011 Dashboard style Settings Panelm

  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}


unit untDashboardSettingsPanel;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, VCL.Themes;

type
  TDashboardSettingsPanelSelectEvent = procedure(Sender: TObject; const Index: Integer) of object;

  TDashboardSettingsPanelItem = class(TCollectionItem)
  private
    FText    : TCaption;
    FEnabled : Boolean;

    FRect : TRect;

    procedure SetText(const C: TCaption);
    procedure SetEnabled(const B: Boolean);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(AOWner: TCollection); override;
    procedure Assign(Source: TPersistent); override;

    property ItemRect: TRect read FRect write FRect;
  published
    property Text: TCaption read FText write SetText;
    property Enabled: Boolean read FEnabled write SetEnabled;
  end;

  TDashboardSettingsPanelItemCollection = class(TOwnedCollection)
  private
    FOnChange : TNotifyEvent;

    procedure ItemChanged(Sender: TObject);

    function GetItem(Index: Integer): TDashboardSettingsPanelItem;
    procedure SetItem(Index: Integer; const Value: TDashboardSettingsPanelItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDashboardSettingsPanelItem;
    procedure Assign(Source: TPersistent); override;

    property Items[Index: Integer]: TDashboardSettingsPanelItem read GetItem write SetItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TDashboardSettingsPanel = class(TCustomControl)
  private
    { Private declarations }
    FItemHeight   : Integer;
    FItemIndex    : Integer;
    FItemPadding  : Integer;
    FItemColor    : TColor;
    FBorderColor  : TColor;

    FFont         : TFont;
    FSelectedFont : TFont;
    FHoverFont    : TFont;
    FDisabledFont : TFont;

    FItems        : TDashboardSettingsPanelItemCollection;

    { Buffer - Avoid flickering }
    FBuffer       : TBitmap;
    FUpdateRect   : TRect;
    FRedraw       : Boolean;

    FScrollPosY   : Integer;  // Scrollbar Position
    FOldScrollY   : Integer;
    FScrollMaxY   : Integer;

    FHotItemIndex : Integer;

    FOnSelect     : TDashboardSettingsPanelSelectEvent;

    procedure SetItemHeight(const I: Integer);
    procedure SetItemIndex(const I: Integer);
    procedure SetItemPadding(const I: Integer);
    procedure SetItemColor(const C: TColor);
    procedure SetBorderColor(const C: TColor);

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
    property Items: TDashboardSettingsPanelItemCollection read FItems write FItems;
    property ItemPadding: Integer read FItemPadding write SetItemPadding default 16;
    property ItemColor: TColor read FItemColor write SetItemColor default $00C08F33;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clSilver;

    property Font: TFont read FFont write FFont;
    property SelectedFont: TFont read FSelectedFont write FSelectedFont;
    property HoverFont: TFont read FHoverFont write FHoverFont;
    property DisabledFont: TFont read FDisabledFont write FDisabledFont;

    property OnSelect: TDashboardSettingsPanelSelectEvent read FOnSelect write FOnSelect;

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

uses System.Math;

(******************************************************************************)
(*
(*  Dashboard Settings Panel Item (TDashboardSettingsPanelItem)
(*
(******************************************************************************)
constructor TDashboardSettingsPanelItem.Create(AOWner: TCollection);
begin
  inherited Create(AOwner);

  { Defaults }
  FText := Format('Item %d', [Index]);
  FEnabled := True;
end;

function TDashboardSettingsPanelItem.GetDisplayName : String;
begin
  Result := Text;
end;

procedure TDashboardSettingsPanelItem.SetText(const C: TCaption);
begin
  if Text <> C then
  begin
    FText := C;
    Changed(False);
  end;
end;

procedure TDashboardSettingsPanelItem.SetEnabled(const B: Boolean);
begin
  if Enabled <> B then
  begin
    FEnabled := B;
    Changed(False);
  end;
end;

procedure TDashboardSettingsPanelItem.Assign(Source: TPersistent);
begin
  if Source is TDashboardSettingsPanelItem then
  begin
    Text    := TDashboardSettingsPanelItem(Source).Text;
    Enabled := TDashboardSettingsPanelItem(Source).Enabled;
    Changed(False);
  end else Inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Settings Panel Item Collection (TDashboardSettingsPanelItemCollection)
(*
(******************************************************************************)
constructor TDashboardSettingsPanelItemCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TDashboardSettingsPanelItem);
end;

function TDashboardSettingsPanelItemCollection.GetItem(Index: Integer) : TDashboardSettingsPanelItem;
begin
  Result := inherited GetItem(Index) as TDashboardSettingsPanelItem;
end;

function TDashboardSettingsPanelItemCollection.Add : TDashboardSettingsPanelItem;
begin
  Result := TDashboardSettingsPanelItem(inherited Add);
end;

procedure TDashboardSettingsPanelItemCollection.ItemChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self)
end;

procedure TDashboardSettingsPanelItemCollection.SetItem(Index: Integer; const Value: TDashboardSettingsPanelItem);
begin
  inherited SetItem(Index, Value);
  ItemChanged(Self);
end;

procedure TDashboardSettingsPanelItemCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardSettingsPanelItemCollection.Assign(Source: TPersistent);
var
  LI   : TDashboardSettingsPanelItemCollection;
  Loop : Integer;
begin
  if (Source is TDashboardSettingsPanelItemCollection)  then
  begin
    LI := TDashboardSettingsPanelItemCollection(Source);
    Clear;
    for Loop := 0 to LI.Count - 1 do
        Add.Assign(LI.Items[Loop]);
  end else inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Settings Panel (TDashboardSettingsPanel)
(*
(******************************************************************************)
constructor TDashboardSettingsPanel.Create(AOwner: TComponent);
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
  FItems := TDashboardSettingsPanelItemCollection.Create(Self);
  FItems.OnChange := SettingsChanged;

  { Create Fonts }
  FFont := TFont.Create;
  FFont.OnChange := SettingsChanged;
  FSelectedFont := TFont.Create;
  FSelectedFont.OnChange := SettingsChanged;
  FSelectedFont.Color := clWhite;
  FHoverFont := TFont.Create;
  FHoverFont.OnChange := SettingsChanged;
  FHoverFont.Color := $00C08F33;
  FDisabledFont := TFont.Create;
  FDisabledFont.OnChange := SettingsChanged;
  FDisabledFont.Color := clActiveBorder;

  { Width / Height }
  Width  := 321;
  Height := 185;

  { Defaults }
  Align        := alLeft;
  FItemHeight  := 32;
  FItemIndex   := -1;
  FItemPadding := 16;
  TabStop      := True;
  Color        := clWhite;
  FItemColor   := $00C08F33;
  FBorderColor := clSilver;

  { Initial Draw }
  RedrawPanel   := True;
  FHotItemIndex := -1;
  FScrollPosY   := 0;
end;

destructor TDashboardSettingsPanel.Destroy;
begin
  { Free Buffer }
  FBuffer.Free;

  { Free Items }
  FItems.Free;

  { Free Fonts }
  FFont.Free;
  FSelectedFont.Free;
  FHoverFont.Free;
  FDisabledFont.Free;

  inherited Destroy;
end;

procedure TDashboardSettingsPanel.SetItemHeight(const I: Integer);
begin
  if ItemHeight <> I then
  begin
    FItemHeight := I;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardSettingsPanel.SetItemIndex(const I: Integer);
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

procedure TDashboardSettingsPanel.SetItemPadding(const I: Integer);
begin
  if ItemPadding <> I then
  begin
    FItemPadding := I;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardSettingsPanel.SetItemColor(const C: TColor);
begin
  if ItemColor <> C then
  begin
    FItemColor := C;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardSettingsPanel.SetBorderColor(const C: TColor);
begin
  if BorderColor <> C then
  begin
    FBorderColor := C;
    SettingsChanged(Self);
  end;
end;

procedure TDashboardSettingsPanel.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TDashboardSettingsPanel.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TDashboardSettingsPanel.CMMouseEnter(var Msg: TMessage);
begin
  if (FHotItemIndex <> -1) then
  begin
    FHotItemIndex := -1;
    RedrawPanel   := True;
    Invalidate;
  end;
end;

procedure TDashboardSettingsPanel.CMMouseLeave(var Msg: TMessage);
begin
  if (FHotItemIndex <> -1) then
  begin
    FHotItemIndex := -1;
    RedrawPanel   := True;
    Invalidate;
  end;
end;

procedure TDashboardSettingsPanel.CMParentFontChanged(var Message: TCMParentFontChanged);
begin
  if ParentFont then
  begin
    if Message.WParam <> 0 then
    begin
      Font.Name          := Message.Font.Name;
      Font.Style         := Message.Font.Style;
      HoverFont.Name     := Message.Font.Name;
      HoverFont.Style    := Message.Font.Style;
      SelectedFont.Name  := Message.Font.Name;
      SelectedFont.Style := Message.Font.Style;
      DisabledFont.Name  := Message.Font.Name;
      DisabledFont.Style := Message.Font.Style;
    end;
  end;
end;

procedure TDashboardSettingsPanel.Paint;
var
  WorkRect: TRect;

  procedure DrawBackground;
  begin
    with FBuffer.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Color;
      FillRect(ClientRect);
      Pen.Color := BorderColor;
      MoveTo(WorkRect.Right -1, WorkRect.Top);
      LineTo(WorkRect.Right -1, WorkRect.Bottom);
    end;
  end;

  procedure DrawItem(const Index: Integer);
  var
    R : TRect;
  begin
    R := Rect(
      Items.Items[Index].ItemRect.Left + ItemPadding,
      Items.Items[Index].ItemRect.Top,
      Items.Items[Index].ItemRect.Right - ItemPadding,
      Items.Items[Index].ItemRect.Bottom
    );
    with FBuffer.Canvas do
    begin
      { Selected }
      if (ItemIndex = Index) then
      begin
        Brush.Style := bsSolid;
        Brush.Color := ItemColor;
        FillRect(Items.Items[Index].ItemRect);
        Font.Assign(SelectedFont);
        DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[Index].Text), Length(Items.Items[Index].Text), R, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
      end else

      { Hover }
      if (FHotItemIndex > -1) and (FHotItemIndex = Index) and Items.Items[FHotItemIndex].Enabled then
      begin
        Brush.Style := bsClear;
        Font.Assign(HoverFont);
        DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[Index].Text), Length(Items.Items[Index].Text), R, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
      end else

      { Disabled }
      if not Items.Items[Index].Enabled then
      begin
        Brush.Style := bsClear;
        Font.Assign(DisabledFont);
        DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[Index].Text), Length(Items.Items[Index].Text), R, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
      end else

      { Normal }
      begin
        Brush.Style := bsClear;
        Font.Assign(Self.Font);
        DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[Index].Text), Length(Items.Items[Index].Text), R, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
      end;
    end;
  end;

  procedure DrawItems;
  var
    X, I : Integer;
  begin
    X := 0;
    for I := 0 to Items.Count -1 do
    begin
      Items.Items[I].ItemRect := Rect(
          WorkRect.Left,
          (WorkRect.Top - FScrollPosY) + X,
          WorkRect.Right - 2,
          (WorkRect.Top - FScrollPosY) + ItemHeight + X
      );
      Inc(X, ItemHeight);
    end;
    for I := 0 to Items.Count -1 do DrawItem(I);
  end;

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

    { Draw to buffer }
    DrawBackground;
    DrawItems;
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

procedure TDashboardSettingsPanel.Resize;
begin
  if (FScrollMaxY > ClientHeight) and (FScrollPosY >= (FScrollMaxY - ClientHeight)) then FScrollPosY := (FScrollMaxY - ClientHeight);
  RedrawPanel := True;
  inherited;
end;

procedure TDashboardSettingsPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  Style := Style or WS_VSCROLL and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TDashboardSettingsPanel.WndProc(var Message: TMessage);
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

procedure TDashboardSettingsPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
var
  I : Integer;
begin
  if Enabled then
  begin
    if not Focused and CanFocus then SetFocus;
    for I := 0 to Items.Count -1 do
    if PTInRect(Items.Items[I].ItemRect, Point(X, Y)) and (Items.Items[I].Enabled) then
    begin
      ItemIndex := I;
      Break;
    end;
  end;
  inherited;
end;

procedure TDashboardSettingsPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  inherited
end;

procedure TDashboardSettingsPanel.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
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
    if PTInRect(Items.Items[I].ItemRect, Point(X, Y)) and (Items.Items[I].Enabled) then
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

procedure TDashboardSettingsPanel.KeyDown(var Key: Word; Shift: TShiftState);

  function PreviousIndex: Integer;
  var
    I : Integer;
  begin
    Result := ItemIndex;
    for I := ItemIndex -1 downto 0 do
    if Items.Items[I].Enabled then
    begin
      Result := I;
      Break;
    end;
  end;

  function NextIndex : Integer;
  var
    I : Integer;
  begin
    Result := ItemIndex;
    for I := ItemIndex +1 to Items.Count -1 do
    if Items.Items[I].Enabled then
    begin
      Result := I;
      Break;
    end;
  end;

  function FirstIndex : Integer;
  var
    I : Integer;
  begin
    Result := -1;
    for I := 0 to Items.Count -1 do
    if Items.Items[I].Enabled then
    begin
      Result := I;
      Break;
    end;
  end;

  function LastIndex : Integer;
  var
    I : Integer;
  begin
    Result := -1;
    for I := Items.Count -1 downto 0 do
    if Items.Items[I].Enabled then
    begin
      Result := I;
      Break;
    end;
  end;

begin
  FHotItemIndex := -1;
  case Key of
    VK_LEFT  : if (ItemIndex > 0) then ItemIndex := PreviousIndex;
    VK_UP    : if (ItemIndex > 0) then ItemIndex := PreviousIndex;
    VK_RIGHT : ItemIndex := NextIndex;
    VK_DOWN  : ItemIndex := NextIndex;
    VK_HOME  : ItemIndex := FirstIndex;
    VK_END   : ItemIndex := LastIndex;
    VK_PRIOR : ItemIndex := FirstIndex;
    VK_NEXT  : ItemIndex := LastIndex;
  end;
  inherited;
end;

procedure TDashboardSettingsPanel.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;

procedure TDashboardSettingsPanel.SetScrollPosY(Y: Integer);
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

function TDashboardSettingsPanel.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  if Enabled then
  begin
    SetScrollPosY(FScrollPosY - (WheelDelta div 10));
  end;
  Result := True;
end;

procedure TDashboardSettingsPanel.SettingsChanged(Sender: TObject);
begin
  RedrawPanel := True;
  Invalidate;
end;

(******************************************************************************)
(*
(*  Register Dashboard Settings Panel (TDashboardSettingsPanel)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardSettingsPanel]);
end;

end.
