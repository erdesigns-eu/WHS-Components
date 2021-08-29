{
  untDashboardLoadProgress v1.0.0 -
  a Windows Server 2011 Dashboard styled Component

  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}


unit untDashboardLoadProgress;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, VCL.Themes;

type
  TDashboardLoadProgress = class(TCustomControl)
  private
    { Private declarations }
    FBarHeight        : Integer;
    FBarInActiveColor : TColor;
    FBarActiveColor   : TColor;
    FTitle            : TCaption;
    FFooter           : TCaption;
    FPaddingX         : Integer;
    FPaddingY         : Integer;
    FMin              : Integer;
    FMax              : Integer;
    FPosition         : Integer;

    { Buffer - Avoid flickering }
    FBuffer       : TBitmap;
    FUpdateRect   : TRect;
    FRedraw       : Boolean;
    FRecalculate  : Boolean;

    { Bar Rects }
    FBarRects : array [0..1] of array of TRect;

    procedure SetBarHeight(const I: Integer);
    procedure SetBarInActiveColor(const C: TColor);
    procedure SetBarActiveColor(const C: TColor);
    procedure SetTitle(const S: TCaption);
    procedure SetFooter(const S: TCaption);
    procedure SetPaddingX(const I: Integer);
    procedure SetPaddingY(const I: Integer);
    procedure SetMin(const I: Integer);
    procedure SetMax(const I: Integer);
    procedure SetPosition(const I: Integer);

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure CMParentFontChanged(var Message: TCMParentFontChanged); message CM_PARENTFONTCHANGED;
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure Resize; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;

    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property RedrawPanel: Boolean read FRedraw write FRedraw;
    property Recalculate: Boolean read FRecalculate write FRecalculate;
    property UpdateRect: TRect read FUpdateRect write FUpdateRect;
  published
    { Published declarations }
    property BarHeight: Integer read FBarHeight write SetBarHeight default 2;
    property BarInActiveColor: TColor read FBarInActiveColor write SetBarInactiveColor default $00F5EDDE;
    property BarActiveColor: TColor read FBarActiveColor write SetBarActiveColor default $00C08F33;
    property Title: TCaption read FTitle write SetTitle;
    property Footer: TCaption read FFooter write SetFooter;
    property PaddingX: Integer read FPaddingX write SetPaddingX default 8;
    property PaddingY: Integer read FPaddingY write SetPaddingY default 30;
    property Min: Integer read FMin write SetMin default 0;
    property Max: Integer read FMax write SetMax default 100;
    property Position: Integer read FPosition write SetPosition default 0;

    property Align;
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

uses System.Math;

(******************************************************************************)
(*
(*  Dashboard Load Progress (TDashboardLoadProgress)
(*
(******************************************************************************)
constructor TDashboardLoadProgress.Create(AOwner: TComponent);
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

  { Width / Height }
  Width  := 89;
  Height := 273;

  { Defaults }
  FBarHeight := 2;
  FPaddingX  := 8;
  FPaddingY  := 30;
  FMin       := 0;
  FMax       := 100;
  FPosition  := 0;
  FTitle     := 'Title';
  FFooter    := 'Footer';

  Color             := clWhite;
  Font.Color        := $00C08F33;
  FBarInActiveColor := $00F5EDDE;
  FBarActiveColor   := $00C08F33;

  { Initial Draw }
  RedrawPanel := True;
  Recalculate := True;
end;

destructor TDashboardLoadProgress.Destroy;
begin
  { Free Buffer }
  FBuffer.Free;

  inherited Destroy;
end;

procedure TDashboardLoadProgress.SetBarHeight(const I: Integer);
begin
  if BarHeight <> I then
  begin
    FBarHeight  := I;
    Recalculate := True;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoadProgress.SetBarInActiveColor(const C: TColor);
begin
  if BarInactiveColor <> C then
  begin
    FBarInActiveColor := C;
    Recalculate       := True;
    RedrawPanel       := True;
    Invalidate;
  end;
end;

procedure TDashboardLoadProgress.SetBarActiveColor(const C: TColor);
begin
  if BarActiveColor <> C then
  begin
    FBarActiveColor := C;
    RedrawPanel     := True;
    Invalidate;
  end;
end;

procedure TDashboardLoadProgress.SetTitle(const S: TCaption);
begin
  if Title <> S then
  begin
    FTitle      := S;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoadProgress.SetFooter(const S: TCaption);
begin
  if Footer <> S then
  begin
    FFooter     := S;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoadProgress.SetPaddingX(const I: Integer);
begin
  if PaddingX <> I then
  begin
    FPaddingX   := I;
    Recalculate := True;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoadProgress.SetPaddingY(const I: Integer);
begin
  if PaddingY <> I then
  begin
    FPaddingY   := I;
    Recalculate := True;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoadProgress.SetMin(const I: Integer);
begin
  if Min <> I then
  begin
    FMin := I;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoadProgress.SetMax(const I: Integer);
begin
  if Max <> I then
  begin
    FMax := I;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoadProgress.SetPosition(const I: Integer);
begin
  if Position <> I then
  begin
    FPosition   := I;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoadProgress.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TDashboardLoadProgress.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TDashboardLoadProgress.CMParentFontChanged(var Message: TCMParentFontChanged);
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

procedure TDashboardLoadProgress.Paint;
var
  WorkRect: TRect;

  procedure DrawBackground;
  begin
    with FBuffer.Canvas do
    begin
      Brush.Color := Color;
      FillRect(WorkRect);
    end;
  end;

  procedure CalculateRects;
  var
    BarWidth, C, I, Y, XL, XR : Integer;
  begin
    BarWidth := Floor((WorkRect.Width - (PaddingX * 2) - 1) / 2);
    C := Floor((WorkRect.Height - (PaddingY * 2)) / (BarHeight +1));
    SetLength(FBarRects[0], C);
    SetLength(FBarRects[1], C);
    Y  := WorkRect.Top + PaddingY;
    XL := WorkRect.Left + PaddingX;
    XR := XL + BarWidth + 1;
    for I := 0 to C do
    begin
      FBarRects[0][I] := Rect(XL, Y, XL + BarWidth, Y + BarHeight);
      FBarRects[1][I] := Rect(XR, Y, XR + BarWidth, Y + BarHeight);
      Inc(Y, BarHeight +1);
    end;
  end;
  
  procedure DrawProgress;
  var
    I, L, A : Integer;
  begin
    L := Length(FBarRects[0]);
    A := Ceil(L / ((Max - Min)) * Position);
    with FBuffer.Canvas do
    begin
      Brush.Color := BarInActiveColor;
      for I := Low(FBarRects[0]) to High(FBarRects[0]) do
      begin
        if I = (L - A) then Brush.Color := BarActiveColor;
        FillRect(FBarRects[0][I]);
        FillRect(FBarRects[1][I]);
      end;
    end;
  end;

  procedure DrawCaptions;
  var
    TitleRect, FooterRect: TRect;
  begin
    with FBuffer.Canvas do
    begin
      Brush.Style := bsClear;
      Font.Assign(Self.Font);
      TitleRect := Rect(
        WorkRect.Left,
        WorkRect.Top,
        WorkRect.Right,
        WorkRect.Top + PaddingY
      );
      DrawText(FBuffer.Canvas.Handle, PChar(Title), Length(Title), TitleRect, DT_VCENTER or DT_SINGLELINE or DT_CENTER or DT_END_ELLIPSIS);
      FooterRect := Rect(
        WorkRect.Left,
        WorkRect.Bottom - PaddingY,
        WorkRect.Right,
        WorkRect.Bottom
      );
      DrawText(FBuffer.Canvas.Handle, PChar(Footer), Length(Footer), FooterRect, DT_VCENTER or DT_SINGLELINE or DT_CENTER or DT_END_ELLIPSIS);
      Brush.Style := bsSolid;
    end;
  end;

var
  X, Y, W, H : Integer;
begin
  WorkRect := ClientRect;

  { Recalculate Bar Rects }
  if Recalculate then
  begin
    Recalculate := False;
    CalculateRects;
  end;

  { Draw the panel to the buffer }
  if RedrawPanel then
  begin
    RedrawPanel := False;

    { Set Buffer size }
    FBuffer.SetSize(ClientWidth, ClientHeight);

    { Draw to buffer }
    DrawBackground;
    DrawProgress;
    DrawCaptions;
  end;

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

procedure TDashboardLoadProgress.Resize;
begin
  Recalculate := True;
  RedrawPanel := True;
  inherited;
end;

procedure TDashboardLoadProgress.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TDashboardLoadProgress.WndProc(var Message: TMessage);
var
  SI : TScrollInfo;
begin
  inherited;
  case Message.Msg of

    { Font Changed }
    CM_FONTCHANGED:
    begin
      RedrawPanel := True;
      Invalidate;
    end;

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

  end;
end;

procedure TDashboardLoadProgress.SettingsChanged(Sender: TObject);
begin
  RedrawPanel := True;
  Invalidate;
end;

(******************************************************************************)
(*
(*  Register Dashboard Load Progress (TDashboardLoadProgress)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardLoadProgress]);
end;

end.
