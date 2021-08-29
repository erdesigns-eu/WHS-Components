{
  untDashboardNotificationPanel v1.0.0 -
  a Windows Server 2011 Dashboard style Notification Panel

  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}


unit untDashboardNotificationPanel;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, VCL.Themes;

type
  TDashboardNotificationPanel = class(TCustomControl)
  private
    { Private declarations }
    FGradientColor  : TColor;
    FGradientAngle  : Integer;
    FGradientHeight : Integer;

    FTitle          : TCaption;
    FSubTitle       : TCaption;
    FTitleFont      : TFont;
    FSubTitleFont   : TFont;

    { Buffer - Avoid flickering }
    FBuffer       : TBitmap;
    FUpdateRect   : TRect;
    FRedraw       : Boolean;

    procedure SetGradientColor(const C: TColor);
    procedure SetGradientAngle(const I: Integer);
    procedure SetGradientHeight(const I: Integer);

    procedure SetTitle(const C: TCaption);
    procedure SetSubtitle(const C: TCaption);

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
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
    property UpdateRect: TRect read FUpdateRect write FUpdateRect;
  published
    { Published declarations }
    property GradientColor: TColor read FGradientColor write SetGradientColor default $00EDDCBC;
    property GradientAngle: Integer read FGradientAngle write SetGradientAngle default 90;
    property GradientHeight: Integer read FGradientHeight write SetGradientHeight default 125;

    property Title: TCaption read FTitle write SetTitle;
    property Subtitle: TCaption read FSubTitle write SetSubtitle;
    property TitleFont: TFont read FTitleFont write FTitleFont;
    property SubtitleFont: TFont read FSubtitleFont write FSubtitleFont;

    property Align;
    property Anchors;
    property Color default clWhite;
    property Constraints;
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
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
(*  Dashboard Notification Panel (TDashboardNotificationPanel)
(*
(******************************************************************************)
constructor TDashboardNotificationPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { If the ControlStyle property includes csOpaque, the control paints itself
    directly. We do want the control to accept controls because this is a panel }
  ControlStyle := ControlStyle + [csAcceptsControls, csOpaque, csCaptureMouse, csClickEvents, csDoubleClicks];

  { We do want to be able to get focus, this is a list }
  TabStop := True;

  { Create Buffers }
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf32bit;
  FBuffer.Canvas.Brush.Style := bsClear;

  { Create Fonts }
  FTitleFont := TFont.Create;
  FTitleFont.OnChange := SettingsChanged;
  FTitleFont.Color := $00C08F33;
  FTitleFont.Size  := 12;

  FSubTitleFont := TFont.Create;
  FSubTitleFont.OnChange := SettingsChanged;
  FSubTitleFont.Color := clGrayText;

  { Width / Height }
  Width  := 321;
  Height := 185;

  { Defaults }
  Align   := alNone;
  TabStop := False;
  Color   := clWhite;

  FTitle    := 'Notification Title';
  FSubTitle := 'Notification Subtitle';

  FGradientColor  := $00EDDCBC;
  FGradientAngle  := 90;
  FGradientHeight := 125;

  { Initial Draw }
  RedrawPanel := True;
end;

destructor TDashboardNotificationPanel.Destroy;
begin
  { Free Buffer }
  FBuffer.Free;

  { Free Fonts }
  FTitleFont.Free;
  FSubTitleFont.Free;

  inherited Destroy;
end;

procedure TDashboardNotificationPanel.SetGradientColor(const C: TColor);
begin
  if GradientColor <> C then
  begin
    FGradientColor := C;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardNotificationPanel.SetGradientAngle(const I: Integer);
begin
  if GradientAngle <> I then
  begin
    FGradientAngle := I;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardNotificationPanel.SetGradientHeight(const I: Integer);
begin
  if GradientHeight <> I then
  begin
    FGradientHeight := I;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardNotificationPanel.SetTitle(const C: TCaption);
begin
  if Title <> C then
  begin
    FTitle := C;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardNotificationPanel.SetSubtitle(const C: TCaption);
begin
  if SubTitle <> C then
  begin
    FSubTitle := C;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardNotificationPanel.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TDashboardNotificationPanel.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TDashboardNotificationPanel.Paint;
var
  WorkRect: TRect;

  procedure DrawBackground;
  begin
    FBuffer.Canvas.Brush.Color := Color;
    FBuffer.Canvas.FillRect(ClientRect);
  end;

  procedure DrawGradient(var FGraphics: IGPGraphics);
  var
    GradientRect, R    : TGPRect;
    GradientBrush      : IGPLinearGradientBrush;
    FromColor, ToColor : TGPColor;
  begin
    FromColor      := TGPColor.CreateFromColorRef(GradientColor);
    ToColor        := TGPColor.CreateFromColorRef(Color);
    GradientRect   := TGPRect.Create(
      WorkRect.Left,
      WorkRect.Top,
      WorkRect.Right,
      WorkRect.Top + GradientHeight + 1 // Fix to prevent a line at the bottom
    );
    GradientBrush := TGPLinearGradientBrush.Create(GradientRect, FromColor, ToColor, GradientAngle);
    R := TGPRect.Create(
      WorkRect.Left,
      WorkRect.Top,
      WorkRect.Right,
      WorkRect.Top + GradientHeight
    );
    FGraphics.FillRectangle(GradientBrush, R);
  end;

  procedure DrawTitles;
  var
    R : TRect;
  begin
    with FBuffer.Canvas do
    begin
      Brush.Style := bsClear;
      R := Rect(
        WorkRect.Left + 8,
        WorkRect.Top + 8,
        WorkRect.Right - 8,
        WorkRect.Top + 32
      );
      Font.Assign(TitleFont);
      DrawText(FBuffer.Canvas.Handle, PChar(Title), Length(Title), R, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
      R := Rect(
        WorkRect.Left + 8,
        WorkRect.Top + 32,
        WorkRect.Right - 8,
        WorkRect.Top + 64
      );
      Font.Assign(SubTitleFont);
      DrawText(FBuffer.Canvas.Handle, PChar(SubTitle), Length(SubTitle), R, DT_TOP or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
      Brush.Style := bsSolid;
    end;
  end;

var
  FGraphics : IGPGraphics;
var
  X, Y, W, H : Integer;
begin
  { Draw the panel to the buffer }
  if RedrawPanel then
  begin
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
    DrawGradient(FGraphics);
    DrawTitles;
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

procedure TDashboardNotificationPanel.Resize;
begin
  RedrawPanel := True;
  inherited;
end;

procedure TDashboardNotificationPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TDashboardNotificationPanel.WndProc(var Message: TMessage);
var
  SI : TScrollInfo;
begin
  inherited;
  case Message.Msg of

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

procedure TDashboardNotificationPanel.SettingsChanged(Sender: TObject);
begin
  RedrawPanel := True;
  Invalidate;
end;

(******************************************************************************)
(*
(*  Register Dashboard Notification Panel (TDashboardTaskPanel)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardNotificationPanel]);
end;

end.
