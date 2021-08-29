{
  untDashboardClock v1.0.0 - a Windows style Analog Clock
  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}

unit untDashboardClock;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, Vcl.ExtCtrls;

type
  TDashboardClockOnTime = procedure(Sender: TObject; Hours: Integer; Minutes: Integer; Seconds: Integer) of object;

  TDashboardClock = class(TCustomControl)
  private
    { Private declarations }
    FBorderWidth : Integer;
    FBorderColor : TColor;
    FFaceFrom    : TColor;
    FFaceTo      : TColor;
    FFaceAngle   : Integer;

    FHourTickColor    : TColor;
    FMinuteTickColor  : TColor;
    FHourTickLength   : Integer;
    FMinuteTickLength : Integer;
    FHourTickWidth    : Integer;
    FMinuteTickWidth  : Integer;

    FHourHandColor    : TColor;
    FMinuteHandColor  : TColor;
    FSecondHandColor  : TColor;
    FHourHandWidth    : Integer;
    FMinuteHandWidth  : Integer;
    FSecondHandWidth  : Integer;
    FCenterColor      : TColor;
    FCenterWidth      : Integer;

    FHour             : Double;
    FMinute           : Double;
    FSecond           : Double;

    FClockTimer       : TTimer;
    FOnClockTime      : TDashboardClockOnTime;

    { Buffer - Avoid flickering }
    FBuffer      : TBitmap;
    FUpdateRect  : TRect;
    FRedraw      : Boolean;

    procedure SetBorderWidth(const I: Integer);
    procedure SetBorderColor(const C: TColor);
    procedure SetFaceFrom(const C: TColor);
    procedure SetFaceTo(const C: TColor);
    procedure SetFaceAngle(const I: Integer);

    procedure SetHourTickColor(const C: TColor);
    procedure SetMinuteTickColor(const C: TColor);
    procedure SetHourTickLength(const I: Integer);
    procedure SetMinuteTickLength(const I: Integer);
    procedure SetHourTickWidth(const I: Integer);
    procedure SetMinuteTickWidth(const I: Integer);

    procedure SetHourHandColor(const C: TColor);
    procedure SetMinuteHandColor(const C: TColor);
    procedure SetSecondHandColor(const C: TColor);
    procedure SetHourHandWidth(const I: Integer);
    procedure SetMinuteHandWidth(const I: Integer);
    procedure SetSecondHandWidth(const I: Integer);
    procedure SetCenterColor(const C: TColor);
    procedure SetCenterWidth(const I: Integer);

    procedure SetHour(const D: Double);
    procedure SetMinute(const D: Double);
    procedure SetSecond(const D: Double);

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure Resize; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
    procedure OnClockTimer(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property UpdateRect: TRect read FUpdateRect write FUpdateRect;
    property NeedsRedrawing: Boolean read FRedraw write FRedraw;
  published
    { Published declarations }
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth default 3;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clMedGray;
    property FaceFrom: TColor read FFaceFrom write SetFaceFrom default clWhite;
    property FaceTo: TColor read FFaceTo write SetFaceTo default clSilver;
    property FaceAngle: Integer read FFaceAngle write SetFaceAngle default 45;

    property HourTickColor: TColor read FHourTickColor write SetHourTickColor default clMedGray;
    property MinuteTickColor: TColor read FMinuteTickColor write SetMinuteTickColor default clMedGray;
    property HourTickLength: Integer read FHourTickLength write SetHourTickLength default 8;
    property MinuteTickLength: Integer read FMinuteTickLength write SetMinuteTickLength default 4;
    property HourTickWidth: Integer read FHourTickWidth write SetHourTickWidth default 2;
    property MinuteTickWidth: Integer read FMinuteTickWidth write SetMinuteTickWidth default 1;

    property HourHandColor: TColor read FHourHandColor write SetHourHandColor default clGray;
    property MinuteHandColor: TColor read FMinuteHandColor write SetMinuteHandColor default clGray;
    property SecondHandColor: TColor read FSecondHandColor write SetSecondHandColor default $005353FF;
    property HourHandWidth: Integer read FHourHandWidth write SetHourHandWidth default 2;
    property MinuteHandWidth: Integer read FMinuteHandWidth write SetMinuteHandWidth default 2;
    property SecondHandWidth: Integer read FSecondHandWidth write SetSecondHandWidth default 1;
    property CenterColor: TColor read FCenterColor write SetCenterColor default clGray;
    property CenterWidth: Integer read FCenterWidth write SetCenterWidth default 6;

    property Hour: Double read FHour write SetHour;
    property Minute: Double read FMinute write SetMinute;
    property Second: Double read FSecond write SetSecond;

    property OnClockTime: TDashboardClockOnTime read FOnClockTime write FOnClockTime;

    property Align;
    property Anchors;
    property Color;
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
(*  Dashboard (Analog) Clock (TDashboardClock)
(*
(******************************************************************************)

constructor TDashboardClock.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { If the ControlStyle property includes csOpaque, the control paints itself
    directly. We dont want the control to accept controls - but this might
    change in the future so we leave it here commented out. offcourse we
    like to get click, double click and mouse events. }
  ControlStyle := ControlStyle + [csOpaque, csCaptureMouse, csClickEvents, csDoubleClicks];

  { We dont want to get focus }
  TabStop := False;

  { Create Buffers }
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf32bit;

  { Width / Height }
  Width  := 128;
  Height := 128;

  { Defaults }
  Enabled      := False;
  FBorderWidth := 3;
  FBorderColor := clMedGray;
  FFaceFrom    := clWhite;
  FFaceTo      := clSilver;
  FFaceAngle   := 45;

  FHourTickColor    := clMedGray;
  FMinuteTickColor  := clMedGray;
  FHourTickLength   := 8;
  FMinuteTickLength := 4;
  FHourTickWidth    := 2;
  FMinuteTickWidth  := 1;
  FCenterColor      := clGray;
  FCenterWidth      := 6;

  FHourHandColor   := clGray;
  FMinuteHandColor := clGray;
  FSecondHandColor := $005353FF;
  FHourHandWidth   := 2;
  FMinuteHandWidth := 2;
  FSecondHandWidth := 1;

  FClockTimer := TTimer.Create(Self);
  FClockTimer.Enabled  := False;
  FClockTimer.Interval := 1000;
  FClockTimer.OnTimer  := OnClockTimer;

  FHour   := 0;
  FMinute := 0;
  FSecond := 0;

  { Draw for the first time }
  NeedsRedrawing := True;
end;

destructor TDashboardClock.Destroy;
begin
  { Free Buffer }
  FBuffer.Free;

  { Free Clock Timer }
  FClockTimer.Free;

  inherited Destroy;
end;

procedure TDashboardClock.SetBorderWidth(const I: Integer);
begin
  if BorderWidth <> I then
  begin
    if I < 0 then
      FBorderWidth := 0
    else
      FBorderWidth := I;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetBorderColor(const C: TColor);
begin
  if BorderColor <> C then
  begin
    FBorderColor := C;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetFaceFrom(const C: TColor);
begin
  if FaceFrom <> C then
  begin
    FFaceFrom := C;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetFaceTo(const C: TColor);
begin
  if FaceTo <> C then
  begin
    FFaceTo := C;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetFaceAngle(const I: Integer);
begin
  if FaceAngle <> I then
  begin
    FFaceAngle := I;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetHourTickColor(const C: TColor);
begin
  if HourTickColor <> C then
  begin
    FHourTickColor := C;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetMinuteTickColor(const C: TColor);
begin
  if MinuteTickColor <> C then
  begin
    FMinuteTickColor := C;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetHourTickLength(const I: Integer);
begin
  if HourTickLength <> I then
  begin
    FHourTickLength := I;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetMinuteTickLength(const I: Integer);
begin
  if MinuteTickLength <> I then
  begin
    FMinuteTickLength := I;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetHourTickWidth(const I: Integer);
begin
  if HourTickWidth <> I then
  begin
    FHourTickWidth := I;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetMinuteTickWidth(const I: Integer);
begin
  if MinuteTickWidth <> I then
  begin
    FMinuteTickWidth := I;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetHourHandColor(const C: TColor);
begin
  if HourHandColor <> C then
  begin
    FHourHandColor := C;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetMinuteHandColor(const C: TColor);
begin
  if MinuteHandColor <> C then
  begin
    FMinuteHandColor := C;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetSecondHandColor(const C: TColor);
begin
  if SecondHandColor <> C then
  begin
    FSecondHandColor := C;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetHourHandWidth(const I: Integer);
begin
  if HourHandWidth <> I then
  begin
    FHourHandWidth := I;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetMinuteHandWidth(const I: Integer);
begin
  if MinuteHandWidth <> I then
  begin
    FMinuteHandWidth := I;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetSecondHandWidth(const I: Integer);
begin
  if SecondHandWidth <> I then
  begin
    FSecondHandWidth := I;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetCenterColor(const C: TColor);
begin
  if CenterColor <> C then
  begin
    FCenterColor := C;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetCenterWidth(const I: Integer);
begin
  if CenterWidth <> I then
  begin
    FCenterWidth := I;
    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetHour(const D: Double);
begin
  if Hour <> D then
  begin
    if (D <= 0) or (D >= 24) then
      FHour := 0
    else
      FHour := D;

    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetMinute(const D: Double);
begin
  if Minute <> D then
  begin
    if (D <= 0) or (D >= 60) then
      FMinute := 0
    else
      FMinute := D;

    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.SetSecond(const D: Double);
begin
  if Second <> D then
  begin
    if (D <= 0) or (D >= 60) then
      FSecond := 0
    else
      FSecond := D;

    NeedsRedrawing := True;
    Invalidate;
  end;
end;

procedure TDashboardClock.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TDashboardClock.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TDashboardClock.Paint;
const
  MaxFactor = 100;
var
  WorkRect: TRect;
const
  TAU = PI * 2;
var
  TickOffset   : Double;
  Radius       : Integer;
  HourRadius   : Integer;
  MinuteRadius : Integer;
  OuterRadius  : Integer;

  // Factor 0..MaxFactor
  function Brighten(Color: TColor; Factor: Integer): TColor;
  begin
    Color := ColorToRGB(Color);
    if 0 < Factor then             // 0 = no changes
    begin
      if Factor > MaxFactor then
        Factor := MaxFactor;
      Result := (          (((255 - ((Color shr 16) and $FF)) * Factor)
  div MaxFactor)) shl 8;
      Result := (Result or (((255 - ((Color shr  8) and $FF)) * Factor)
  div MaxFactor)) shl 8;
      Result := (Result or (((255 - ( Color         and $FF)) * Factor)
  div MaxFactor));
      Result := Color + Result;
    end
    else
      Result := Color;
  end;

  // Factor 0..MaxFactor
  function Darken(Color: TColor; Factor: Integer): TColor;
  begin
    Color := ColorToRGB(Color);
    if 0 < Factor then             // 0 = no changes
    begin
      if Factor > MaxFactor then
        Factor := MaxFactor;
      Result := (          ((((Color shr 16) and $FF) * Factor) div
  MaxFactor)) shl 8;
      Result := (Result or ((((Color shr  8) and $FF) * Factor) div
  MaxFactor)) shl 8;
      Result := (Result or ((( Color         and $FF) * Factor) div
  MaxFactor));
      Result := Color - Result;
    end
    else
      Result := Color;
  end;

  procedure DrawBackground;
  begin
    with FBuffer.Canvas do
    begin
      Brush.Color := Color;
      FillRect(ClipRect);
    end;
  end;

  procedure DrawClock(var FGraphics: IGPGraphics);
  var
    R             : TRect;
    BorderPen     : IGPPen;
    BorderBrush   : IGPLinearGradientBrush;
    FaceBrush     : IGPLinearGradientBrush;
    HourTickPen   : IGPPen;
    MinuteTickPen : IGPPen;

    A : Double;
    I, X1, Y1, X2, Y2 : Integer;
  begin
    { Draw Border background first }
    R := WorkRect;
    BorderBrush := TGPLinearGradientBrush.Create(TGPRect.Create(R), TGPColor.CreateFromColorRef(Brighten(FBorderColor, 80)), TGPColor.CreateFromColorRef(Brighten(FBorderColor, 60)), 0);
    FGraphics.FillEllipse(BorderBrush, TGPRect.Create(R));
    { Create Border 1 }
    BorderPen := TGPPen.Create(TGPColor.CreateFromColorRef(FBorderColor));
    BorderPen.Alignment := PenAlignmentInset;
    FGraphics.DrawEllipse(BorderPen, TGPRect.Create(R));
    { Draw Face background first }
    InflateRect(R, -Abs(BorderWidth), -Abs(BorderWidth));
    FaceBrush := TGPLinearGradientBrush.Create(TGPRect.Create(R), TGPColor.CreateFromColorRef(FaceFrom), TGPColor.CreateFromColorRef(FaceTo), FaceAngle);
    FGraphics.FillEllipse(FaceBrush, TGPRect.Create(R));
    { Create Second Border 1 }
    FGraphics.DrawEllipse(BorderPen, TGPRect.Create(R));
    { Draw Hour Ticks }
    HourTickPen := TGPPen.Create(TGPColor.CreateFromColorRef(HourTickColor), HourTickWidth);
    HourTickPen.Alignment := PenAlignmentInset;
    TickOffset  := 0;
    for I := 0 to 12 -1 do
    begin
      A  := TAU * I / 12;
      X1 := Radius + Ceil(Cos(A - TickOffset) * OuterRadius);
      Y1 := Radius + Ceil(Sin(A - TickOffset) * OuterRadius);
      X2 := Radius + Ceil(Cos(A - TickOffset) * HourRadius);
      Y2 := Radius + Ceil(Sin(A - TickOffset) * HourRadius);
      FGraphics.DrawLine(HourTickPen, X1, Y1, X2, Y2);
    end;
    { Draw Minute Ticks }
    MinuteTickPen := TGPPen.Create(TGPColor.CreateFromColorRef(MinuteTickColor), MinuteTickWidth);
    MinuteTickPen.Alignment := PenAlignmentInset;
    for I := 0 to 60 -1 do
    begin
      A  := TAU * I / 60;
      X1 := Radius + Ceil(Cos(A - TickOffset) * OuterRadius);
      Y1 := Radius + Ceil(Sin(A - TickOffset) * OuterRadius);
      X2 := Radius + Ceil(Cos(A - TickOffset) * MinuteRadius);
      Y2 := Radius + Ceil(Sin(A - TickOffset) * MinuteRadius);
      if (I <> 0) and (I <> 15) and (I <> 30) and (I <> 45) then
      FGraphics.DrawLine(MinuteTickPen, X1, Y1, X2, Y2);
    end;
  end;

  procedure DrawClockHands(var FGraphics: IGPGraphics);
  var
    HourPen        : IGPPen;
    MinutePen      : IGPPen;
    SecondPen      : IGPPen;
    CenterBrush    : IGPSolidBrush;
    A              : Double;
    X1, Y1, X2, Y2 : Integer;
    CX, CY, CH     : Integer;
  begin
    { Centers }
    CX := Floor(WorkRect.Width / 2);
    CY := Floor(WorkRect.Height / 2);
    { Create Hour Pen }
    HourPen := TGPPen.Create(TGPColor.CreateFromColorRef(HourHandColor), HourHandWidth);
    HourPen.Alignment := PenAlignmentInset;
    { Draw Hour Hand }
    A  := TAU * (Hour -3) / 12;
    X1 := WorkRect.Left + CX;
    Y1 := WorkRect.Top + CY;
    X2 := Radius + Ceil(Cos(A - TickOffset) * (OuterRadius * 0.65));
    Y2 := Radius + Ceil(Sin(A - TickOffset) * (OuterRadius * 0.65));
    FGraphics.DrawLine(HourPen, X1, Y1, X2, Y2);

    { Create Minute Pen }
    MinutePen := TGPPen.Create(TGPColor.CreateFromColorRef(MinuteHandColor), MinuteHandWidth);
    MinutePen.Alignment := PenAlignmentInset;
    { Draw Hour Hand }
    A  := TAU * (Minute -15) / 60;
    X1 := WorkRect.Left + CX;
    Y1 := WorkRect.Top + CY;
    X2 := Radius + Ceil(Cos(A - TickOffset) * (OuterRadius * 0.85));
    Y2 := Radius + Ceil(Sin(A - TickOffset) * (OuterRadius * 0.85));
    FGraphics.DrawLine(MinutePen, X1, Y1, X2, Y2);

    { Create Second Pen }
    SecondPen := TGPPen.Create(TGPColor.CreateFromColorRef(SecondHandColor), SecondHandWidth);
    SecondPen.Alignment := PenAlignmentInset;
    { Draw Hour Hand }
    A  := TAU * (Second -15) / 60;
    X1 := WorkRect.Left + CX;
    Y1 := WorkRect.Top + CY;
    X2 := Radius + Ceil(Cos(A - TickOffset) * (OuterRadius * 0.85));
    Y2 := Radius + Ceil(Sin(A - TickOffset) * (OuterRadius * 0.85));
    FGraphics.DrawLine(SecondPen, X1, Y1, X2, Y2);

    { Draw Center }
    CH := Round(CenterWidth / 2);
    CenterBrush := TGPSolidBrush.Create(TGPColor.CreateFromColorRef(CenterColor));
    FGraphics.FillEllipse(CenterBrush, TGPRect.Create(CX - CH, CY - CH, CenterWidth, CenterWidth));
  end;

var
  FGraphics : IGPGraphics;
var
  X, Y, W, H : Integer;
begin
  { Maintain width / height -ratio }
  if (csdesigning in componentstate) then
  if Height < Width then Height := Width else Width := Height;

  { Set Buffer size }
  FBuffer.SetSize(ClientWidth, ClientHeight);

  { Create GDI+ Graphic }
  FGraphics := TGPGraphics.Create(FBuffer.Canvas.Handle);
  FGraphics.SmoothingMode := SmoothingModeAntiAlias;
  FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;

  { Redraw Buffer }
  if NeedsRedrawing then
  begin
    TickOffset := 0;

    WorkRect := ClientRect;
    WorkRect.Right := WorkRect.Right -1;
    WorkRect.Bottom := WorkRect.Bottom -1;

    { Set Radius }
    Radius       := Round(WorkRect.Width / 2);
    OuterRadius  := Radius - BorderWidth;
    HourRadius   := OuterRadius - HourTickLength;
    MinuteRadius := OuterRadius - MinuteTickLength;

    NeedsRedrawing := False;
    DrawBackground;
    DrawClock(FGraphics);
    DrawClockHands(FGraphics);
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

procedure TDashboardClock.Resize;
begin
  NeedsRedrawing := True;
  inherited;
end;

procedure TDashboardClock.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TDashboardClock.WndProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    // Capture Keystrokes
    WM_GETDLGCODE:
      Message.Result := Message.Result or DLGC_WANTARROWS or DLGC_WANTALLKEYS;

    { Enabled/Disabled - Redraw }
    CM_ENABLEDCHANGED:
      begin
        if Assigned(FClockTimer) then
        FClockTimer.Enabled := Enabled;
        Invalidate;
      end;

    { The color changed }
    CM_COLORCHANGED:
      begin
        NeedsRedrawing := True;
        Invalidate;
      end;

    { The Parent color changed }
    CM_PARENTCOLORCHANGED:
      begin
        NeedsRedrawing := True;
        Invalidate;
      end;

  end;
end;

procedure TDashboardClock.OnClockTimer(Sender: TObject);
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Hour   := SystemTime.wHour + (((SystemTime.wMinute * 100) / 60) * 0.01);
  Minute := SystemTime.wMinute;
  Second := SystemTime.wSecond;
  if Assigned(FOnClockTime) then FOnClockTime(Self, SystemTime.wHour, SystemTime.wMinute, SystemTime.wSecond);
end;

(******************************************************************************)
(*
(*  Register Dashboard (Analog) Clock (TDashboardClock)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardClock]);
end;

end.
