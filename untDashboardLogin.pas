{
  untDashboardLogin v1.0.0 - a Windows Server 2011 Dashboard style Login
  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}

unit untDashboardLogin;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Menus,
  Vcl.StdCtrls, Vcl.Forms, Vcl.ComCtrls;

type
  TDashboardLoginPanelLoginClick = procedure(Sender: TObject; const Text: string) of object;
  TDashboardLoginPanelEditChange = procedure(Sender: TObject; const Text: string) of object;

  TDashboardLoginPanelView = (pvLogin, pvLoading);

  TDashboardLoginPanelEditSettings = class(TPersistent)
  private
    { Private declarations }
    FOverlay     : TPicture;
    FOffsetX     : Integer;
    FOffsetY     : Integer;
    FWidth       : Integer;
    FHeight      : Integer;
    FColor       : TColor;
    FPlaceholder : TCaption;
    FText        : TCaption;

    FOnChange  : TNotifyEvent;

    procedure SetOverlay(const P: TPicture);
    procedure SetOffsetX(const I: Integer);
    procedure SetOffsetY(const I: Integer);
    procedure SetWidth(const I: Integer);
    procedure SetHeight(const I: Integer);
    procedure SetColor(const C: TColor);
    procedure SetPlaceholder(const S: TCaption);
    procedure SetText(const S: TCaption);
  protected
    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property Overlay: TPicture read FOverlay write SetOverlay;
    property OffsetX: Integer read FOffsetX write SetOffsetX default 51;
    property OffsetY: Integer read FOffsetY write SetOffsetY default 52;
    property Width: Integer read FWidth write SetWidth default 190;
    property Height: Integer read FHeight write SetHeight default 18;
    property Color: TColor read FColor write SetColor default clWindow;
    property Placeholder: TCaption read FPlaceholder write SetPlaceholder;
    property Text: TCaption read FText write SetText;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardLoginPanelLoadingSettings = class(TPersistent)
  private
    { Private declarations }
    FOverlay     : TPicture;
    FOffsetX     : Integer;
    FOffsetY     : Integer;
    FWidth       : Integer;
    FHeight      : Integer;

    FOnChange  : TNotifyEvent;

    procedure SetOverlay(const P: TPicture);
    procedure SetOffsetX(const I: Integer);
    procedure SetOffsetY(const I: Integer);
    procedure SetWidth(const I: Integer);
    procedure SetHeight(const I: Integer);
  protected
    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property Overlay: TPicture read FOverlay write SetOverlay;
    property OffsetX: Integer read FOffsetX write SetOffsetX default 52;
    property OffsetY: Integer read FOffsetY write SetOffsetY default 50;
    property Width: Integer read FWidth write SetWidth default 245;
    property Height: Integer read FHeight write SetHeight default 18;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardLoginPanelLogoSettings = class(TPersistent)
  private
    { Private declarations }
    FLogo        : TPicture;
    FOffsetX     : Integer;
    FOffsetY     : Integer;

    FOnChange  : TNotifyEvent;

    procedure SetLogo(const P: TPicture);
    procedure SetOffsetX(const I: Integer);
    procedure SetOffsetY(const I: Integer);
  protected
    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property Logo: TPicture read FLogo write SetLogo;
    property OffsetX: Integer read FOffsetX write SetOffsetX default 16;
    property OffsetY: Integer read FOffsetY write SetOffsetY default 16;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardLoginPanelLoginButtonSettings = class(TPersistent)
  private
    { Private declarations }
    FNormal      : TPicture;
    FHot         : TPicture;
    FPressed     : TPicture;
    FOffsetX     : Integer;
    FOffsetY     : Integer;
    FCursor      : TCursor;

    FRect      : TRect;
    FOnChange  : TNotifyEvent;

    procedure SetNormal(const P: TPicture);
    procedure SetHot(const P: TPicture);
    procedure SetPressed(const P: TPicture);
    procedure SetOffsetX(const I: Integer);
    procedure SetOffsetY(const I: Integer);
  protected
    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property ButtonRect: TRect read FRect write FRect;
  published
    { Published declarations }
    property Normal: TPicture read FNormal write SetNormal;
    property Hot: TPicture read FHot write SetHot;
    property Pressed: TPicture read FPressed write SetPressed;
    property OffsetX: Integer read FOffsetX write SetOffsetX default 100;
    property OffsetY: Integer read FOffsetY write SetOffsetY default 0;
    property Cursor: TCursor read FCursor write FCursor default crHandpoint;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardLoginPanelTitleSettings = class(TPersistent)
  private
    { Private declarations }
    FTitle   : TCaption;
    FLoading : TCaption;
    FOffsetX : Integer;
    FOffsetY : Integer;
    FFont    : TFont;

    FOnChange  : TNotifyEvent;

    procedure SetTitle(const S: TCaption);
    procedure SetLoading(const S: TCaption);
    procedure SetOffsetX(const I: Integer);
    procedure SetOffsetY(const I: Integer);
    procedure SetFont(const F: TFont);
  protected
    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property Login: TCaption read FTitle write SetTitle;
    property Loading: TCaption read FLoading write SetLoading;
    property OffsetX: Integer read FOffsetX write SetOffsetX default 38;
    property OffsetY: Integer read FOffsetY write SetOffsetY default -8;
    property Font: TFont read FFont write SetFont;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;
  
  TDashboardLoginPanel = class(TCustomControl)
  private
    { Private declarations }
    FFromColor     : TColor;
    FToColor       : TColor;
    FGradientAngle : Integer;
    FGradient      : Boolean;
    FOverlay       : TPicture;
    FEdit          : TDashboardLoginPanelEditSettings;
    FLogo          : TDashboardLoginPanelLogoSettings;
    FLoginButton   : TDashboardLoginPanelLoginButtonSettings;
    FTitle         : TDashboardLoginPanelTitleSettings;
    FView          : TDashboardLoginPanelView;
    FLoader        : TDashboardLoginPanelLoadingSettings;

    FInputEdit       : TEdit;
    FLoadingProgress : TProgressbar;

    { Buffer - Avoid flickering }
    FBuffer           : TBitmap;
    FUpdateRect       : TRect;
    FRedraw           : Boolean;
    FUpdateButtonRect : Boolean;
    FLoginButtonState : Integer;

    { Events }
    FOnLoginClick : TDashboardLoginPanelLoginClick;
    FOnEditChange : TDashboardLoginPanelEditChange;

    procedure SetFromColor(const C: TColor);
    procedure SetToColor(const C: TColor);
    procedure SetGradientAngle(const I: Integer);
    procedure SetGradient(const B: Boolean);
    procedure SetOverlay(const P: TPicture);
    procedure SetView(const V: TDashboardLoginPanelView);

    procedure InputEditChange(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure Resize; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;

    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property RedrawPanel: Boolean read FRedraw write FRedraw;
    property UpdateRect: TRect read FUpdateRect write FUpdateRect;
  published
    { Published declarations }
    property FromColor: TColor read FFromColor write SetFromColor;
    property ToColor: TColor read FToColor write SetToColor;
    property GradientAngle: Integer read FGradientAngle write SetGradientAngle default 270;
    property Gradient: Boolean read FGradient write SetGradient default True;
    property Overlay: TPicture read FOverlay write SetOverlay;
    property Edit: TDashboardLoginPanelEditSettings read FEdit write FEdit;
    property Logo: TDashboardLoginPanelLogoSettings read FLogo write FLogo;
    property LoginButton: TDashboardLoginPanelLoginButtonSettings read FLoginButton write FLoginButton;
    property Title: TDashboardLoginPanelTitleSettings read FTitle write FTitle;
    property View: TDashboardLoginPanelView read FView write SetView default pvLogin;
    property Loader: TDashboardLoginPanelLoadingSettings read FLoader write FLoader;

    property OnLoginClick: TDashboardLoginPanelLoginClick read FOnLoginClick write FOnLoginClick;
    property OnEditChange: TDashboardLoginPanelEditChange read FOnEditChange write FOnEditChange;
    
    property Align default alClient;
    property Anchors;
    property Constraints;
    property Enabled;
    property Font;
    property PopupMenu;
    property TabOrder;
    property TabStop;
    property Touch;
    property Visible;
    property ParentFont;
  end;

procedure Register;

implementation

uses System.Math, GDIPlus;

(******************************************************************************)
(*
(*  Dashboard Login Panel Edit Settings (TDashboardLoginPanelEditSettings)
(*
(******************************************************************************)
constructor TDashboardLoginPanelEditSettings.Create;
begin
  inherited Create;

  { Create Picture }
  FOverlay := TPicture.Create;
  FOverlay.OnChange := SettingsChanged;

  { Defaults }
  FOffsetX     := 52;
  FOffsetY     := 51;
  FColor       := clWindow;
  FHeight      := 18;
  FWidth       := 190;
  FPlaceholder := 'Password';
end;

destructor TDashboardLoginPanelEditSettings.Destroy;
begin
  { Free Picture }
  FOverlay.Free;

  inherited Destroy;
end;

procedure TDashboardLoginPanelEditSettings.SetOverlay(const P: TPicture);
begin
  FOverlay.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelEditSettings.SetOffsetX(const I: Integer);
begin
  if OffsetX <> I then
  begin
    FOffsetX := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelEditSettings.SetOffsetY(const I: Integer);
begin
  if OffsetY <> I then
  begin
    FOffsetY := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelEditSettings.SetWidth(const I: Integer);
begin
  if Width <> I then
  begin
    FWidth := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelEditSettings.SetHeight(const I: Integer);
begin
  if Height <> I then
  begin
    FHeight := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelEditSettings.SetColor(const C: TColor);
begin
  if Color <> C then
  begin
    FColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelEditSettings.SetPlaceholder(const S: TCaption);
begin
  if Placeholder <> S then
  begin
    FPlaceholder := S;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelEditSettings.SetText(const S: TCaption);
begin
  if Text <> S then
  begin
    FText := S;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelEditSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelEditSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardLoginPanelEditSettings then
  begin
    FOffsetX     := TDashboardLoginPanelEditSettings(Source).OffsetX;
    FOffsetY     := TDashboardLoginPanelEditSettings(Source).OffsetY;
    FWidth       := TDashboardLoginPanelEditSettings(Source).Width;
    FHeight      := TDashboardLoginPanelEditSettings(Source).Height;
    FColor       := TDashboardLoginPanelEditSettings(Source).Color;
    FPlaceholder := TDashboardLoginPanelEditSettings(Source).Placeholder;
    FText        := TDashboardLoginPanelEditSettings(Source).Text;
    FOverlay.Assign(TDashboardLoginPanelEditSettings(Source).Overlay);
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Login Panel Loading Settings (TDashboardLoginPanelLoadingSettings)
(*
(******************************************************************************)
constructor TDashboardLoginPanelLoadingSettings.Create;
begin
{ Create Picture }
  FOverlay := TPicture.Create;
  FOverlay.OnChange := SettingsChanged;

  { Defaults }
  FOffsetX := 52;
  FOffsetY := 50;
  FHeight  := 18;
  FWidth   := 245;
end;

destructor TDashboardLoginPanelLoadingSettings.Destroy;
begin
  { Free Picture }
  FOverlay.Free;

  inherited Destroy;
end;

procedure TDashboardLoginPanelLoadingSettings.SetOverlay(const P: TPicture);
begin
  FOverlay.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelLoadingSettings.SetOffsetX(const I: Integer);
begin
  if OffsetX <> I then
  begin
    FOffsetX := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelLoadingSettings.SetOffsetY(const I: Integer);
begin
  if OffsetY <> I then
  begin
    FOffsetY := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelLoadingSettings.SetWidth(const I: Integer);
begin
  if Width <> I then
  begin
    FWidth := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelLoadingSettings.SetHeight(const I: Integer);
begin
  if Height <> I then
  begin
    FHeight := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelLoadingSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelLoadingSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardLoginPanelLoadingSettings then
  begin
    FOffsetX     := TDashboardLoginPanelLoadingSettings(Source).OffsetX;
    FOffsetY     := TDashboardLoginPanelLoadingSettings(Source).OffsetY;
    FWidth       := TDashboardLoginPanelLoadingSettings(Source).Width;
    FHeight      := TDashboardLoginPanelLoadingSettings(Source).Height;
    FOverlay.Assign(TDashboardLoginPanelLoadingSettings(Source).Overlay);
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Login Panel Logo Settings (TDashboardLoginPanelLogoSettings)
(*
(******************************************************************************)
constructor TDashboardLoginPanelLogoSettings.Create;
begin
  inherited Create;

  { Create Picture }
  FLogo := TPicture.Create;
  FLogo.OnChange := SettingsChanged;

  { Defaults }
  FOffsetX := 16;
  FOffsetY := 16;
end;

destructor TDashboardLoginPanelLogoSettings.Destroy;
begin
  { Free Picture }
  FLogo.Free;

  inherited Destroy;
end;

procedure TDashboardLoginPanelLogoSettings.SetLogo(const P: TPicture);
begin
  FLogo.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelLogoSettings.SetOffsetX(const I: Integer);
begin
  if OffsetX <> I then
  begin
    FOffsetX := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelLogoSettings.SetOffsetY(const I: Integer);
begin
  if OffsetY <> I then
  begin
    FOffsetY := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelLogoSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelLogoSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardLoginPanelLogoSettings then
  begin
    FOffsetX := TDashboardLoginPanelLogoSettings(Source).OffsetX;
    FOffsetY := TDashboardLoginPanelLogoSettings(Source).OffsetY;
    Flogo.Assign(TDashboardLoginPanelLogoSettings(Source).Logo);
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Login Panel Login Button Settings (TDashboardLoginPanelLoginButtonSettings)
(*
(******************************************************************************)
constructor TDashboardLoginPanelLoginButtonSettings.Create;
begin
  inherited Create;

  { Create Pictures }
  FNormal  := TPicture.Create;
  FNormal.OnChange := SettingsChanged;
  FHot     := TPicture.Create;
  FHot.OnChange := SettingsChanged;
  FPressed := TPicture.Create;
  FPressed.OnChange := SettingsChanged;

  { Defaults }
  FOffsetX  := 100;
  FOffsetY  := 0;
  FCursor   := crHandpoint;
end;

destructor TDashboardLoginPanelLoginButtonSettings.Destroy;
begin
  { Free Pictures }
  FNormal.Free;
  FHot.Free;
  FPressed.Free;

  inherited Destroy;
end;

procedure TDashboardLoginPanelLoginButtonSettings.SetNormal(const P: TPicture);
begin
  FNormal.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelLoginButtonSettings.SetHot(const P: TPicture);
begin
  FHot.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelLoginButtonSettings.SetPressed(const P: TPicture);
begin
  FPressed.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelLoginButtonSettings.SetOffsetX(const I: Integer);
begin
  if OffsetX <> I then
  begin
    FOffsetX := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelLoginButtonSettings.SetOffsetY(const I: Integer);
begin
  if OffsetY <> I then
  begin
    FOffsetY := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelLoginButtonSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelLoginButtonSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardLoginPanelLoginButtonSettings then
  begin
    FOffsetX := TDashboardLoginPanelLoginButtonSettings(Source).OffsetX;
    FOffsetY := TDashboardLoginPanelLoginButtonSettings(Source).OffsetY;
    FNormal.Assign(TDashboardLoginPanelLoginButtonSettings(Source).Normal);
    FHot.Assign(TDashboardLoginPanelLoginButtonSettings(Source).Hot);
    FPressed.Assign(TDashboardLoginPanelLoginButtonSettings(Source).Pressed);
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Login Panel Title Settings (TDashboardLoginPanelTitleSettings)
(*
(******************************************************************************)
constructor TDashboardLoginPanelTitleSettings.Create;
begin
  inherited Create;

  { Create Font }
  FFont := TFont.Create;
  FFont.OnChange := SettingsChanged;
  FFont.Color := clWhite;
  FFont.Name  := 'Segoe UI';
  FFont.Size  := 16;
  
  { Defaults }
  FOffsetX := 38;
  FOffsetY := -8;
  FTitle   := 'Login';
  FLoading := 'Loading';
end;

destructor TDashboardLoginPanelTitleSettings.Destroy;
begin
  { Free Font }
  FFont.Free;

  inherited Destroy;
end;

procedure TDashboardLoginPanelTitleSettings.SetTitle(const S: TCaption);
begin
  if Login <> S then
  begin
    FTitle := S;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelTitleSettings.SetLoading(const S: TCaption);
begin
  if Loading <> S then
  begin
    FLoading := S;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelTitleSettings.SetOffsetX(const I: Integer);
begin
  if OffsetX <> I then
  begin
    FOffsetX := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelTitleSettings.SetOffsetY(const I: Integer);
begin
  if OffsetY <> I then
  begin
    FOffsetY := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardLoginPanelTitleSettings.SetFont(const F: TFont);
begin
  FFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelTitleSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardLoginPanelTitleSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardLoginPanelTitleSettings then
  begin
    FTitle   := TDashboardLoginPanelTitleSettings(Source).Login;
    FLoading := TDashboardLoginPanelTitleSettings(Source).Loading;
    FOffsetX := TDashboardLoginPanelTitleSettings(Source).OffsetX;
    FOffsetY := TDashboardLoginPanelTitleSettings(Source).OffsetY;
    FFont.Assign(TDashboardLoginPanelTitleSettings(Source).Font);
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Login Panel (TDashboardLoginPanel)
(*
(******************************************************************************)
constructor TDashboardLoginPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { If the ControlStyle property includes csOpaque, the control paints itself
    directly. We do want the control to accept controls - because this is
    a panel afterall :) }
  ControlStyle := ControlStyle + [csOpaque, csAcceptsControls,
    csCaptureMouse, csClickEvents, csDoubleClicks];

  { We dont want to be able to get focus, this is a panel so its just a parent
    for other components to put on/in }
  TabStop := False;

  { Create Buffers }
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf32bit;
  FBuffer.Canvas.Brush.Style := bsClear;

  { Overlay }
  FOverlay := TPicture.Create;

  { Edit }
  FEdit := TDashboardLoginPanelEditSettings.Create;
  FEdit.OnChange := SettingsChanged;

  { Loader }
  FLoader := TDashboardLoginPanelLoadingSettings.Create;
  FLoader.OnChange := SettingsChanged;

  { Logo }
  FLogo := TDashboardLoginPanelLogoSettings.Create;
  FLogo.OnChange := SettingsChanged;

  { Login Button }
  FLoginButton := TDashboardLoginPanelLoginButtonSettings.Create;
  FLoginButton.OnChange := SettingsChanged;

  { Title }
  FTitle := TDashboardLoginPanelTitleSettings.Create;
  FTitle.OnChange := SettingsChanged;

  { Input Edit Component }
  FInputEdit := TEdit.Create(Self);
  FInputEdit.Parent       := Self;
  FInputEdit.BorderStyle  := bsNone;
  FInputEdit.Visible      := False;
  FInputEdit.PasswordChar := '●';
  FInputEdit.OnChange     := InputEditChange;
  FInputEdit.OnKeyPress   := InputEditKeyPress;

  { Loading Progressbar }
  FLoadingProgress := TProgressBar.Create(Self);
  FLoadingProgress.Parent  := Self;
  FLoadingProgress.Style   := pbstMarquee;
  FLoadingProgress.Visible := False;

  { Width / Height }
  Width  := 401;
  Height := 273;

  { Defaults }
  FFromColor     := $00E7CFA5;
  FToColor       := $00C08F33;
  FGradient      := True;
  FGradientAngle := 270;
  FView          := pvLogin;

  { Initial Draw }
  RedrawPanel       := True;
  FUpdateButtonRect := True;
  FLoginButtonState := 0;
end;

destructor TDashboardLoginPanel.Destroy;
begin
  { Free Buffer }
  FBuffer.Free;

  { Free Overlay }
  FOverlay.Free;

  { Free Edit }
  FEdit.Free;

  { Free Loader }
  FLoader.Free;

  { Free Logo }
  FLogo.Free;

  { Free Login Button }
  FLoginButton.Free;

  { Free Title }
  FTitle.Free;

  { Free Input Edit Component }
  FInputEdit.Free;

  { Free Loading progressbar }
  FLoadingProgress.Free;

  inherited Destroy;
end;

procedure TDashboardLoginPanel.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TDashboardLoginPanel.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TDashboardLoginPanel.CMMouseEnter(var Msg: TMessage);
begin
  RedrawPanel       := True;
  FUpdateButtonRect := True;
  FLoginButtonState := 0;
  Invalidate;
end;

procedure TDashboardLoginPanel.CMMouseLeave(var Msg: TMessage);
begin
  RedrawPanel       := True;
  FUpdateButtonRect := True;
  FLoginButtonState := 0;
  Invalidate;
end;

procedure TDashboardLoginPanel.SetFromColor(const C: TColor);
begin
  if FromColor <> C then
  begin
    FFromColor := C;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoginPanel.SetToColor(const C: TColor);
begin
  if ToColor <> C then
  begin
    FToColor := C;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoginPanel.SetGradientAngle(const I: Integer);
begin
  if GradientAngle <> I then
  begin
    FGradientAngle := I;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoginPanel.SetGradient(const B: Boolean);
begin
  if Gradient <> B then
  begin
    FGradient := B;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoginPanel.SetOverlay(const P: TPicture);
begin
  FOverlay.Assign(P);
  RedrawPanel := True;
  Invalidate;
end;

procedure TDashboardLoginPanel.SetView(const V: TDashboardLoginPanelView);
begin
  if View <> V then
  begin
    FView                    := V;
    FInputEdit.Visible       := V = pvLogin;
    FLoadingProgress.Visible := V = pvLoading;
    RedrawPanel              := True;
    Invalidate;
  end;
end;

procedure TDashboardLoginPanel.InputEditChange(Sender: TObject);
begin
  Edit.Text := (Sender as TEdit).Text;
  if Assigned(OnEditChange) then OnEditChange(Self, (Sender as TEdit).Text);
end;

procedure TDashboardLoginPanel.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if Assigned(OnLoginClick) then OnLoginClick(Self, (Sender as TEdit).Text);
    Key := #0;
  end;
end;

procedure TDashboardLoginPanel.Paint;
var
  WorkRect: TRect;

  procedure DrawBackground(var FGraphics: IGPGraphics);
  var
    GradientBrush : IGPLinearGradientBrush;
    SolidBrush    : IGPSolidBrush;
    FromColor,
    ToColor,
    SolidColor    : TGPColor;
  begin
    if Gradient then
    begin
      FromColor     := TGPColor.CreateFromColorRef(FFromColor);
      ToColor       := TGPColor.CreateFromColorRef(FToColor);
      GradientBrush := TGPLinearGradientBrush.Create(TGPRect.Create(WorkRect), FromColor, ToColor, GradientAngle);
      FGraphics.FillRectangle(GradientBrush, TGPRect.Create(WorkRect));
    end else
    begin
      SolidColor := TGPColor.CreateFromColorRef(FFromColor);
      SolidBrush := TGPSolidBrush.Create(SolidColor);
      FGraphics.FillRectangle(SolidBrush, TGPRect.Create(WorkRect));
    end;
    if Assigned(Overlay.Graphic) then
    begin
      FBuffer.Canvas.Draw(0, WorkRect.Bottom - Overlay.Graphic.Height, Overlay.Graphic);
    end;
  end;

  procedure DrawInput;
  var
    X, Y, W, H : Integer;
    R          : TRect;
  begin
    if Assigned(Edit.Overlay.Graphic) then
    with FBuffer.Canvas do
    begin
      X := Round(WorkRect.Width / 2) - Floor(Edit.Overlay.Width / 2);
      Y := Round(WorkRect.Height / 2) - Floor(Edit.Overlay.Height / 2);
      Draw(X, Y, Edit.Overlay.Graphic);
      Font.Assign(Title.Font);
      W := TextWidth(Title.Login);
      H := TextHeight(Title.Login);
      R := Rect(
        X + Title.OffsetX, 
        Y + Title.OffsetY, 
        X + W + Title.OffsetX, 
        Y + H + Title.OffsetY
      );
      DrawText(FBuffer.Canvas.Handle, PChar(Title.Login), Length(Title.Login), R, DT_LEFT or DT_SINGLELINE);
      if Assigned(FInputEdit) then
      begin
        FInputEdit.Left    := X + Edit.OffsetX;
        FInputEdit.Top     := Y + Edit.OffsetY;
        FInputEdit.Color   := Edit.Color;
        FInputEdit.Height  := Edit.Height;
        FInputEdit.Width   := Edit.Width;
        FInputEdit.Visible := True;
      end;
      if Assigned(FLoadingProgress) then
      begin
        FLoadingProgress.Left    := -10;
        FLoadingProgress.Top     := -10;
        FLoadingProgress.Height  := 0;
        FLoadingProgress.Width   := 0;
        FLoadingProgress.Visible := False;
      end;
    end;
  end;

  procedure DrawLoading;
  var
    X, Y, W, H : Integer;
    R          : TRect;
  begin
    if Assigned(Loader.Overlay.Graphic) then
    with FBuffer.Canvas do
    begin
      X := Round(WorkRect.Width / 2) - Floor(Loader.Overlay.Width / 2);
      Y := Round(WorkRect.Height / 2) - Floor(Loader.Overlay.Height / 2);
      Draw(X, Y, Loader.Overlay.Graphic);
      Font.Assign(Title.Font);
      W := TextWidth(Title.Loading);
      H := TextHeight(Title.Loading);
      R := Rect(
        X + Title.OffsetX, 
        Y + Title.OffsetY, 
        X + W + Title.OffsetX, 
        Y + H + Title.OffsetY
      );
      DrawText(FBuffer.Canvas.Handle, PChar(Title.Loading), Length(Title.Loading), R, DT_LEFT or DT_SINGLELINE);
      if Assigned(FLoadingProgress) then
      begin
        FLoadingProgress.Left    := X + Loader.OffsetX;
        FLoadingProgress.Top     := Y + Loader.OffsetY;
        FLoadingProgress.Height  := Loader.Height;
        FLoadingProgress.Width   := Loader.Width;
        FLoadingProgress.Visible := True;
      end;
      if Assigned(FInputEdit) then
      begin
        FInputEdit.Left    := -10;
        FInputEdit.Top     := -10;
        FInputEdit.Height  := 0;
        FInputEdit.Width   := 0;
        FInputEdit.Visible := False;
      end;
    end;
  end;

  procedure DrawLogo;
  begin
    if Assigned(Logo.Logo.Graphic) then
    begin
      FBuffer.Canvas.Draw(WorkRect.Right - (Logo.Logo.Width + Logo.OffsetX), WorkRect.Bottom - (Logo.Logo.Height + Logo.OffsetY), Logo.Logo.Graphic);
    end;
  end;

  procedure DrawLoginButton;
  var
    X, Y : Integer;
  begin
    if Assigned(LoginButton.Normal.Graphic) and FUpdateButtonRect then
    begin
      X := Round(ClientWidth / 2) - Round(LoginButton.Normal.Graphic.Width / 2);
      Y := Round(ClientHeight / 2) - Round(LoginButton.Normal.Graphic.Height / 2);
      LoginButton.ButtonRect := Rect(
         X + LoginButton.OffsetX,
         Y + LoginButton.OffsetY,
         X + LoginButton.OffsetX + LoginButton.Normal.Graphic.Width,
         Y + LoginButton.OffsetY + LoginButton.Normal.Graphic.Height
      );
    end;
    if (FLoginButtonState = 2) and Assigned(LoginButton.Pressed.Graphic) then
      FBuffer.Canvas.Draw(LoginButton.ButtonRect.Left, LoginButton.ButtonRect.Top, LoginButton.Pressed.Graphic)
    else
    if (FLoginButtonState = 1) and Assigned(LoginButton.Hot.Graphic) then
      FBuffer.Canvas.Draw(LoginButton.ButtonRect.Left, LoginButton.ButtonRect.Top, LoginButton.Hot.Graphic)
    else
      FBuffer.Canvas.Draw(LoginButton.ButtonRect.Left, LoginButton.ButtonRect.Top, LoginButton.Normal.Graphic);
  end;

var
  FGraphics : IGPGraphics;
var
  X, Y, W, H : Integer;
begin
  if (csLoading in ComponentState) or (csDestroying in ComponentState)  then Exit;

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
    DrawBackground(FGraphics);
    DrawLogo;

    if View = pvLogin then
    begin
      DrawInput;
      DrawLoginButton;
    end;

    if View = pvLoading then
    begin
      DrawLoading;
    end;
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

procedure TDashboardLoginPanel.Resize;
begin
  RedrawPanel       := True;
  FUpdateButtonRect := True;
  inherited;
end;

procedure TDashboardLoginPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TDashboardLoginPanel.WndProc(var Message: TMessage);
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
        FInputEdit.Enabled := Enabled;
        Invalidate;
      end;

    { The color changed }
    CM_COLORCHANGED:
      begin
        RedrawPanel := True;
        Invalidate;
      end;

    { Caption changed }
    CM_TEXTCHANGED:
      begin
        RedrawPanel := True;
        Invalidate;
      end;

    { Font Changed }
    CM_FONTCHANGED:
      begin
        FInputEdit.Font.Assign(Font);
      end;
  end;
end;

procedure TDashboardLoginPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
var
  R : Boolean;
begin
  R := False;
  if Enabled and (View = pvLogin) then
  begin
    if (FLoginButtonState > 0) then
    begin
      FLoginButtonState := 0;
      R := True;
    end;
    if PTInRect(LoginButton.ButtonRect, Point(X, Y)) then
    begin
      FLoginButtonState := 2;
      R := True;
      if Assigned(FOnLoginClick) then FOnLoginClick(Self, FInputEdit.Text);
    end;
    if R then
    begin
      RedrawPanel := True;
      Invalidate;
    end;
  end;
  inherited;
end;

procedure TDashboardLoginPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  if (FLoginButtonState > 0) then
  begin
    FLoginButtonState := 0;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardLoginPanel.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
var
  R : Boolean;
  C : TCursor;
begin
  R := False;
  C := crDefault;
  if Enabled and (View = pvLogin) then
  begin
    if (FLoginButtonState > 0) then
    begin
      FLoginButtonState := 0;
      R := True;
    end;
    if PTInRect(LoginButton.ButtonRect, Point(X, Y)) then
    begin
      FLoginButtonState := 1;
      C := LoginButton.Cursor;
      R := True;
    end;
    if R then
    begin
      RedrawPanel := True;
      Invalidate;
    end;
  end;
  Cursor := C;
  inherited;
end;

procedure TDashboardLoginPanel.SettingsChanged(Sender: TObject);
begin
  RedrawPanel := True;
  FInputEdit.TextHint := Edit.Placeholder;
  FinputEdit.Text     := Edit.Text;
  FUpdateButtonRect   := True;
  Invalidate;
end;

(******************************************************************************)
(*
(*  Register Dashboard Login Panel (TDashboardLoginPanel)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardLoginPanel]);
end;

end.
