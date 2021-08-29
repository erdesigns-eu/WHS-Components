{
  untDashboardHeader v1.0.0 - a Windows Server 2011 Dashboard style Header
  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}

unit untDashboardHeader;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Menus;

type
  TDashboardHeaderItem = class;

  TDashboardHeaderGradientDirection = (gdHorizontal, gdVertical);
  TDashboardHeaderSelectItemEvent   = procedure(Sender: TObject; const Index: Integer; const Item: TDashboardHeaderItem) of object;

  TDashboardHeaderBackgroundSettings = class(TPersistent)
  private
    { Private declarations }
    FFromColor : TColor;
    FToColor   : TColor;
    FGradient  : Boolean;
    FDirection : TDashboardHeaderGradientDirection;
    FOverlay   : TPicture;

    FOnChange  : TNotifyEvent;

    procedure SetFromColor(const C: TColor);
    procedure SetToColor(const C: TColor);
    procedure SetGradient(const B: Boolean);
    procedure SetDirection(const D: TDashboardHeaderGradientDirection);
    procedure SetOverlay(const P: TPicture);
  protected
    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property FromColor: TColor read FFromColor write SetFromColor default $00C08F33;
    property ToColor: TColor read FToColor write SetToColor default clWhite;
    property Gradient: Boolean read FGradient write SetGradient default true;
    property Direction: TDashboardHeaderGradientDirection read FDirection write SetDirection default gdVertical;
    property Overlay: TPicture read FOverlay write SetOverlay;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardHeaderLogoSettings = class(TPersistent)
  private
    { Private declarations }
    FLogo      : TPicture;
    FMarginX   : Integer;
    FMarginY   : Integer;

    FOnChange  : TNotifyEvent;

    procedure SetLogo(const P: TPicture);
    procedure SetMarginX(const I: Integer);
    procedure SetMarginY(const I: Integer);
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
    property MarginX: Integer read FMarginX write SetMarginX default 8;
    property MarginY: Integer read FMarginY write SetMarginY default 0;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardHeaderItemSettings = class(TPersistent)
  private
    { Private declarations }
    FSelectionOverlay  : TPicture;
    FSelectionOverIcon : Boolean;
    FItemWidth         : Integer;
    FIconWidth         : Integer;
    FIconHeight        : Integer;
    FIconMarginX       : Integer;
    FIconMarginY       : Integer;
    FStretchIcon       : Boolean;
    FMarginX           : Integer;
    FMarginY           : Integer;
    FHoverFont         : TFont;
    FSelectedFont      : TFont;
    FCursor            : TCursor;
    FOffsetX           : Integer;
    FOffsetY           : Integer;

    FOnChange : TNotifyEvent;

    procedure SetSelectionOverlay(const P: TPicture);
    procedure SetSelectionOverIcon(const B: Boolean);
    procedure SetItemWidth(const I: Integer);
    procedure SetIconWidth(const I: Integer);
    procedure SetIconHeight(const I: Integer);
    procedure SetIconMarginX(const I: Integer);
    procedure SetIconMarginY(const I: Integer);
    procedure SetStretchIcon(const B: Boolean);
    procedure SetMarginX(const I: Integer);
    procedure SetMarginY(const I: Integer);
    procedure SetHoverFont(const F: TFont);
    procedure SetSelectedFont(const F: TFont);
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
    property SelectionOverlay: TPicture read FSelectionOverlay write SetSelectionOverlay;
    property SelectionOverIcon: Boolean read FSelectionOverIcon write SetSelectionOverIcon default False;
    property ItemWidth: Integer read FItemWidth write SetItemWidth default 100;
    property IconWidth: Integer read FIconWidth write SetIconWidth default 48;
    property IconHeight: Integer read FIconHeight write SetIconHeight default 48;
    property IconMarginX: Integer read FIconMarginX write SetIconMarginX default 0;
    property IconMarginY: Integer read FIconMarginY write SetIconMarginY default 8;
    property StretchIcon: Boolean read FStretchIcon write SetStretchIcon default True;
    property MarginX: Integer read FMarginX write SetMarginX default 10;
    property MarginY: Integer read FMarginY write SetMarginY default 16;
    property HoverFont: TFont read FHoverFont write SetHoverFont;
    property SelectedFont: TFont read FSelectedFont write SetSelectedFont;
    property Cursor: TCursor read FCursor write FCursor default crHandpoint;
    property OffsetX: Integer read FOffsetX write SetOffsetX default 44;
    property OffsetY: Integer read FOffsetY write SetOffsetY default 8;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardHeaderMenuItemSettings = class(TPersistent)
  private
    { Private declarations }
    FMenuHeight   : Integer;
    FMarginX      : Integer;
    FMarginY      : Integer;
    FHoverFont    : TFont;
    FSelectedFont : TFont;
    FCursor       : TCursor;
    FHoverBorder  : TColor;
    FActiveBorder : TColor;
    FHoverBack    : TColor;
    FActiveBack   : TColor;

    FOnChange : TNotifyEvent;

    procedure SetMenuHeight(const I: Integer);
    procedure SetMarginX(const I: Integer);
    procedure SetMarginY(const I: Integer);
    procedure SetHoverFont(const F: TFont);
    procedure SetSelectedFont(const F: TFont);
    procedure SetHoverBorder(const C: TColor);
    procedure SetActiveBorder(const C: TColor);
    procedure SetHoverBack(const C: TColor);
    procedure SetActiveBack(const C: TColor);
  protected
    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property MenuHeight: Integer read FMenuHeight write SetMenuHeight default 29;
    property MarginX: Integer read FMarginX write SetMarginX default 8;
    property MarginY: Integer read FMarginY write SetMarginY default 0;
    property HoverFont: TFont read FHoverFont write SetHoverFont;
    property ActiveFont: TFont read FSelectedFont write SetSelectedFont;
    property Cursor: TCursor read FCursor write FCursor default crDefault;
    property HoverBorder: TColor read FHoverBorder write SetHoverBorder default $00D5AC62;
    property ActiveBorder: TColor read FActiveBorder write SetActiveBorder default $00D5AC62;
    property HoverBack: TColor read FHoverBack write SetHoverBack default $00F5EDDC;
    property ActiveBack: TColor read FActiveBack write SetActiveBack default $00F0E2C8;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardHeaderNavigationSettings = class(TPersistent)
  private
    { Private declarations }
    FPreviousNormal  : TPicture;
    FPreviousHot     : TPicture;
    FPreviousPressed : TPicture;
    FNextNormal      : TPicture;
    FNextHot         : TPicture;
    FNextPressed     : TPicture;
    FCursor          : TCursor;

    FPreviousRect    : TRect;
    FNextRect        : TRect;

    FOnChange  : TNotifyEvent;

    procedure SetPreviousNormal(const P: TPicture);
    procedure SetPreviousHot(const P: TPicture);
    procedure SetPreviousPressed(const P: TPicture);
    procedure SetNextNormal(const P: TPicture);
    procedure SetNextHot(const P: TPicture);
    procedure SetNextPressed(const P: TPicture);
  protected
    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property PreviousRect: TRect read FPreviousRect write FPreviousRect;
    property NextRect: TRect read FNextRect write FNextRect;
  published
    { Published declarations }
    property PreviousNormal: TPicture read FPreviousNormal write SetPreviousNormal;
    property PreviousHot: TPicture read FPreviousHot write SetPreviousHot;
    property PreviousPressed: TPicture read FPreviousPressed write SetPreviousPressed;
    property NextNormal: TPicture read FNextNormal write SetNextNormal;
    property NextHot: TPicture read FNextHot write SetNextHot;
    property NextPressed: TPicture read FNextPressed write SetNextPressed;
    property Cursor: TCursor read FCursor write FCursor default crHandpoint;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardHeaderTabSettings = class(TPersistent)
  private
    { Private declarations }
    FActiveFrom   : TColor;
    FActiveTo     : TColor;
    FHoverFrom    : TColor;
    FHoverTo      : TColor;
    FFrom         : TColor;
    FTo           : TColor;
    FBorder       : TColor;
    FCursor       : TCursor;
    FActiveFont   : TFont;
    FHoverFont    : TFont;
    FOffsetX      : Integer;
    FHeight       : Integer;
    FActiveHeight : Integer;
    FTextMargin   : Integer;

    FOnChange     : TNotifyEvent;

    procedure SetActiveFrom(const C: TColor);
    procedure SetActiveTo(const C: TColor);
    procedure SetHoverFrom(const C: TColor);
    procedure SetHoverTo(const C: TColor);
    procedure SetFromColor(const C: TColor);
    procedure SetToColor(const C: TColor);
    procedure SetBorder(const C: TColor);
    procedure SetActiveFont(const F: TFont);
    procedure SetHoverFont(const F: TFont);
    procedure SetOffsetX(const I: Integer);
    procedure SetHeight(const I: Integer);
    procedure SetActiveHeight(const I: Integer);
    procedure SetTextMargin(const I: Integer);
  protected
    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property ActiveFrom: TColor read FActiveFrom write SetActiveFrom default $00E3CA99;
    property ActiveTo: TColor read FActiveTo write SetActiveTo default$00FEFAF5;
    property HoverFrom: TColor read FHoverFrom write SetHoverFrom default $00EAD9B5;
    property HoverTo: TColor read FHoverTo write SetHoverTo default $00FEFAF5;
    property FromColor: TColor read FFrom write SetFromColor default $00FDF1E5;
    property ToColor: TColor read FTo write SetToColor default $00FEFAF5;
    property Border: TColor read FBorder write SetBorder default $00E3CA99;
    property Cursor: TCursor read FCursor write FCursor default crHandpoint;
    property ActiveFont: TFont read FActiveFont write SetActiveFont;
    property HoverFont: TFont read FHoverFont write SetHoverFont;
    property OffsetX: Integer read FOffsetX write SetOffsetX default 8;
    property Height: Integer read FHeight write SetHeight default 22;
    property ActiveHeight: Integer read FActiveHeight write SetActiveHeight default 25;
    property TextMargin: Integer read FTextMargin write SetTextMargin default 16;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardHeaderItem = class(TCollectionItem)
  private
    FIcon       : TPicture;
    FCaption    : TCaption;
    FTabs       : TStringList;
    FRect       : TRect;
    FInViewPort : Boolean;

    procedure SetIcon(const P: TPicture);
    procedure SetCaption(const C: TCaption);
    procedure SetTabs(const S: TStringlist);
  protected
    procedure SettingsChanged(Sender: TObject);
    function GetDisplayName: string; override;
  public
    constructor Create(AOWner: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    property ItemRect: TRect read FRect write FRect;
    property InViewPort: Boolean read FInViewPort write FInViewPort;
  published
    property Icon: TPicture read FIcon write SetIcon;
    property Caption: TCaption read FCaption write SetCaption;
    property Tabs: TStringlist read FTabs write SetTabs;
  end;

  TDashboardHeaderItemCollection = class(TOwnedCollection)
  private
    FOnChange : TNotifyEvent;

    procedure ItemChanged(Sender: TObject);

    function GetItem(Index: Integer): TDashboardHeaderItem;
    procedure SetItem(Index: Integer; const Value: TDashboardHeaderItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDashboardHeaderItem;
    procedure Assign(Source: TPersistent); override;

    property Items[Index: Integer]: TDashboardHeaderItem read GetItem write SetItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TDashboardHeaderMenuItem = class(TCollectionItem)
  private
    FIcon       : TPicture;
    FCaption    : TCaption;
    FMenu       : TPopupMenu;
    FOnClick    : TNotifyEvent;
    FRect       : TRect;

    procedure SetIcon(const P: TPicture);
    procedure SetCaption(const C: TCaption);
    procedure SetMenu(const M: TPopupMenu);
  protected
    procedure SettingsChanged(Sender: TObject);
    function GetDisplayName: string; override;
  public
    constructor Create(AOWner: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    property ItemRect: TRect read FRect write FRect;
  published
    property Icon: TPicture read FIcon write SetIcon;
    property Caption: TCaption read FCaption write SetCaption;
    property Menu: TPopupMenu read FMenu write SetMenu;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TDashboardHeaderMenuItemCollection = class(TOwnedCollection)
  private
    FOnChange : TNotifyEvent;

    procedure ItemChanged(Sender: TObject);

    function GetItem(Index: Integer): TDashboardHeaderMenuItem;
    procedure SetItem(Index: Integer; const Value: TDashboardHeaderMenuItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDashboardHeaderMenuItem;
    procedure Assign(Source: TPersistent); override;

    property Items[Index: Integer]: TDashboardHeaderMenuItem read GetItem write SetItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TDashboardHeader = class(TCustomControl)
  private
    { Private declarations }
    FBackground : TDashboardHeaderBackgroundSettings;
    FLogo       : TDashboardHeaderLogoSettings;
    FItem       : TDashboardHeaderItemSettings;
    FItems      : TDashboardHeaderItemCollection;
    FMenu       : TDashboardHeaderMenuItemSettings;
    FMenuItems  : TDashboardHeaderMenuItemCollection;
    FNavigation : TDashboardHeaderNavigationSettings;
    FTabs       : TDashboardHeaderTabSettings;

    FOnSelect      : TDashboardHeaderSelectItemEvent;
    FOnItemIndex   : TNotifyEvent;
    FOnTabIndex    : TNotifyEvent;
    FShowFocusRect : Boolean;

    { Buffer - Avoid flickering }
    FBuffer                : TBitmap;
    FUpdateRect            : TRect;
    FRedraw                : Boolean;
    FUpdateItemRects       : Boolean;
    FUpdateMenuItemRects   : Boolean;
    FUpdateNavigationRects : Boolean;
    FUpdateTabRects        : Boolean;
    FTabRects              : Array of TRect;

    { Selected }
    FItemIndex : Integer;
    { Menu Selected }
    FMenuItemIndex : Integer;
    { Hover }
    FHoverIndex : Integer;
    { Menu Hover }
    FMenuHoverIndex : Integer;
    { Navigation Hover }
    FNavigationHoverIndex : Integer;
    { Navigation Selected }
    FNavigationIndex : Integer;
    { Tab Hover }
    FTabHoverIndex : Integer;
    { Tab Index }
    FTabIndex : Integer;

    { Items start index }
    FItemsStartIndex : Integer;

    procedure SetItemIndex(const I: Integer);
    procedure SetShowFocusRect(const B: Boolean);
    procedure SetTabIndex(const I: Integer);

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;

    function ShowNavigationLeft : Boolean;
    function ShowNavigationRight : Boolean;
    function MaxVisibleItems : Integer;
  protected
    { Protected declarations }
    procedure ItemsChanged(Sender: TObject);
    procedure SettingsChanged(Sender: TObject);
    
    procedure Paint; override;
    procedure Resize; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property RedrawPanel: Boolean read FRedraw write FRedraw;
    property UpdateRect: TRect read FUpdateRect write FUpdateRect;
    property UpdateItemRects: Boolean read FUpdateItemRects write FUpdateItemRects;
    property UpdateMenuItemRects: Boolean read FUpdateMenuItemRects write FUpdateMenuItemRects;
    property UpdateNavigationRects: Boolean read FUpdateNavigationRects write FUpdateNavigationRects;
    property UpdateTabRects: Boolean read FUpdateTabRects write FUpdateTabRects;
    property MenuItemIndex: Integer read FMenuItemIndex write FMenuItemIndex;
  published
    { Published declarations }
    property Background: TDashboardHeaderBackgroundSettings read FBackground write FBackground;
    property Logo: TDashboardHeaderLogoSettings read FLogo write FLogo;
    property Item: TDashboardHeaderItemSettings read FItem write FItem;
    property Items: TDashboardHeaderItemCollection read FItems write FItems;
    property Menu: TDashboardHeaderMenuItemSettings read FMenu write FMenu;
    property MenuItems: TDashboardHeaderMenuItemCollection read FMenuItems write FMenuItems;
    property Navigation: TDashboardHeaderNavigationSettings read FNavigation write FNavigation;
    property Tabs: TDashboardHeaderTabSettings read FTabs write FTabs;

    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect default false;
    property TabIndex: Integer read FTabIndex write SetTabIndex default -1;

    property OnSelect: TDashboardHeaderSelectItemEvent read FOnSelect write FOnSelect;
    property OnItemIndex: TNotifyEvent read FOnItemIndex write FOnItemIndex;
    property OnTabIndex: TNotifyEvent read FOnTabIndex write FOnTabIndex;

    property Align default alTop;
    property Anchors;
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
(*  Dashboard Header Background Settings (TDashboardHeaderBackgroundSettings)
(*
(******************************************************************************)
constructor TDashboardHeaderBackgroundSettings.Create;
begin
  inherited Create;

  { Create Picture }
  FOverlay          := TPicture.Create;
  FOverlay.OnChange := SettingsChanged;

  { Defaults }
  FFromColor := $00C08F33;
  FToColor   := clWhite;
  FGradient  := True;
  FDirection := gdVertical;
end;

destructor TDashboardHeaderBackgroundSettings.Destroy;
begin
  { Free Picture }
  FOverlay.Free;

  inherited Destroy;
end;

procedure TDashboardHeaderBackgroundSettings.SetFromColor(const C: TColor);
begin
  if FromColor <> C then
  begin
    FFromColor := C;
    if Assigned(FOnChange) then FOnChange(Self);    
  end;
end;

procedure TDashboardHeaderBackgroundSettings.SetToColor(const C: TColor);
begin
  if ToColor <> C then
  begin
    FToColor := C;
    if Assigned(FOnChange) then FOnChange(Self);    
  end;
end;

procedure TDashboardHeaderBackgroundSettings.SetGradient(const B: Boolean);
begin
  if Gradient <> B then
  begin
    FGradient := B;
    if Assigned(FOnChange) then FOnChange(Self);    
  end;
end;

procedure TDashboardHeaderBackgroundSettings.SetDirection(const D: TDashboardHeaderGradientDirection);
begin
  if Direction <> D then
  begin
    FDirection := D;
    if Assigned(FOnChange) then FOnChange(Self);    
  end;
end;

procedure TDashboardHeaderBackgroundSettings.SetOverlay(const P: TPicture);
begin
  Overlay.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderBackgroundSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderBackgroundSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardHeaderBackgroundSettings then
  begin
    FFromColor := TDashboardHeaderBackgroundSettings(Source).FromColor;
    FToColor   := TDashboardHeaderBackgroundSettings(Source).ToColor;
    FGradient  := TDashboardHeaderBackgroundSettings(Source).Gradient;
    FDirection := TDashboardHeaderBackgroundSettings(Source).Direction; 
    FOverlay.Assign(TDashboardHeaderBackgroundSettings(Source).Overlay);
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Header Logo Settings (TDashboardHeaderLogoSettings)
(*
(******************************************************************************)
constructor TDashboardHeaderLogoSettings.Create;
begin
  inherited Create;

  { Create Picture }
  FLogo          := TPicture.Create;
  Flogo.OnChange := SettingsChanged;

  { Defaults }
  FMarginX   := 8;
  FMarginY   := 0;
end;

destructor TDashboardHeaderLogoSettings.Destroy;
begin
  { Free Picture }
  FLogo.Free;

  inherited Destroy;
end;

procedure TDashboardHeaderLogoSettings.SetLogo(const P: TPicture);
begin
  FLogo.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderLogoSettings.SetMarginX(const I: Integer);
begin
  if MarginX <> I then
  begin
    FMarginX := I;
    if Assigned(FOnChange) then FOnChange(Self);    
  end;
end;

procedure TDashboardHeaderLogoSettings.SetMarginY(const I: Integer);
begin
  if MarginY <> I then
  begin
    FMarginY := I;
    if Assigned(FOnChange) then FOnChange(Self);    
  end;
end;

procedure TDashboardHeaderLogoSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderLogoSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardHeaderLogoSettings then
  begin
    FMarginX   := TDashboardHeaderLogoSettings(Source).MarginX;
    FMarginY   := TDashboardHeaderLogoSettings(Source).MarginY;
    FLogo.Assign(TDashboardHeaderLogoSettings(Source).Logo);
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Header Item Settings (TDashboardHeaderItemSettings)
(*
(******************************************************************************)
constructor TDashboardHeaderItemSettings.Create;
begin
  inherited Create;

  { Create Picture }
  FSelectionOverlay          := TPicture.Create;
  FSelectionOverlay.OnChange := SettingsChanged;

  { Create Fonts }
  FHoverFont             := TFont.Create;
  FHoverFont.Style       := [fsUnderline];
  FHoverFont.OnChange    := SettingsChanged;
  FSelectedFont          := TFont.Create;
  FSelectedFont.Style    := [fsBold];
  FSelectedFont.OnChange := SettingsChanged;

  { Defaults }
  
  FSelectionOverIcon := False;
  FItemWidth         := 100;
  FIconWidth         := 48;
  FIconHeight        := 48;
  FIconMarginX       := 0;
  FIconMarginY       := 8;
  FStretchIcon       := True;
  FMarginX           := 10;
  FMarginY           := 16;
  FCursor            := crHandpoint;
  FOffsetX           := 44;
  FOffsetY           := 8;
end;

destructor TDashboardHeaderItemSettings.Destroy;
begin
  { Free Picture }
  FSelectionOverlay.Free;
  
  { Free Fonts }
  FHoverFont.Free;
  FSelectedFont.Free;
  
  inherited Destroy;
end;

procedure TDashboardHeaderItemSettings.SetSelectionOverlay(const P: TPicture);
begin
  FSelectionOverlay.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderItemSettings.SetSelectionOverIcon(const B: Boolean);
begin
  if SelectionOverIcon <> B then
  begin
    FSelectionOverIcon := B;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SetItemWidth(const I: Integer);
begin
  if ItemWidth <> I then
  begin
    FItemWidth := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SetIconWidth(const I: Integer);
begin
  if IconWidth <> I then
  begin
    FIconWidth := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SetIconHeight(const I: Integer);
begin
  if IconHeight <> I then
  begin
    FIconHeight := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SetIconMarginX(const I: Integer);
begin
  if IconMarginX <> I then
  begin
    FIconMarginX := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SetIconMarginY(const I: Integer);
begin
  if IconMarginY <> I then
  begin
    FIconMarginY := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SetStretchIcon(const B: Boolean);
begin
  if StretchIcon <> B then
  begin
    FStretchIcon := B;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SetMarginX(const I: Integer);
begin
  if MarginX <> I then
  begin
    FMarginX := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SetMarginY(const I: Integer);
begin
  if MarginY <> I then
  begin
    FMarginY := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SetHoverFont(const F: TFont);
begin
  FHoverFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderItemSettings.SetSelectedFont(const F: TFont);
begin
  FSelectedFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderItemSettings.SetOffsetX(const I: Integer);
begin
  if OffsetX <> I then
  begin
    FOffsetX := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SetOffsetY(const I: Integer);
begin
  if OffsetY <> I then
  begin
    FOffsetY := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderItemSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderItemSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardHeaderItemSettings then
  begin
    FSelectionOverIcon := TDashboardHeaderItemSettings(Source).SelectionOverIcon;
    FItemWidth         := TDashboardHeaderItemSettings(Source).ItemWidth;
    FIconWidth         := TDashboardHeaderItemSettings(Source).IconWidth;
    FIconHeight        := TDashboardHeaderItemSettings(Source).IconHeight;
    FMarginX           := TDashboardHeaderItemSettings(Source).MarginX;
    FMarginY           := TDashboardHeaderItemSettings(Source).MarginY;
    FSelectionOverlay.Assign(TDashboardHeaderItemSettings(Source).SelectionOverlay);
    FHoverFont.Assign(TDashboardHeaderItemSettings(Source).HoverFont);
    FSelectedFont.Assign(TDashboardHeaderItemSettings(Source).SelectedFont);
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Header Menu Item Settings (TDashboardHeaderMenuItemSettings)
(*
(******************************************************************************)
constructor TDashboardHeaderMenuItemSettings.Create;
begin
  inherited Create;

  { Create Fonts }
  FHoverFont             := TFont.Create;
  FHoverFont.Style       := [];
  FHoverFont.OnChange    := SettingsChanged;
  FSelectedFont          := TFont.Create;
  FSelectedFont.Style    := [];
  FSelectedFont.OnChange := SettingsChanged;

  { Defaults }
  FMenuHeight   := 29;
  FMarginX      := 8;
  FMarginY      := 0;
  FCursor       := crDefault;
  FHoverBorder  := $00D5AC62;
  FActiveBorder := $00D5AC62;
  FHoverBack    := $00F5EDDC;
  FActiveBack   := $00F0E2C8;
end;

destructor TDashboardHeaderMenuItemSettings.Destroy;
begin
  { Free Fonts }
  FHoverFont.Free;
  FSelectedFont.Free;

  inherited Destroy;
end;

procedure TDashboardHeaderMenuItemSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderMenuItemSettings.SetMenuHeight(const I: Integer);
begin
  if MenuHeight <> I then
  begin
    FMenuHeight := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderMenuItemSettings.SetMarginX(const I: Integer);
begin
  if MarginX <> I then
  begin
    FMarginX := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderMenuItemSettings.SetMarginY(const I: Integer);
begin
  if MarginY <> I then
  begin
    FMarginY := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderMenuItemSettings.SetHoverFont(const F: TFont);
begin
  FHoverFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderMenuItemSettings.SetSelectedFont(const F: TFont);
begin
  FSelectedFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderMenuItemSettings.SetHoverBorder(const C: TColor);
begin
  if HoverBorder <> C then
  begin
    FHoverBorder := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderMenuItemSettings.SetActiveBorder(const C: TColor);
begin
  if ActiveBorder <> C then
  begin
    FActiveBorder := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderMenuItemSettings.SetHoverBack(const C: TColor);
begin
  if HoverBack <> C then
  begin
    FHoverBack := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderMenuItemSettings.SetActiveBack(const C: TColor);
begin
  if ActiveBack <> C then
  begin
    FActiveBack := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderMenuItemSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardHeaderMenuItemSettings then
  begin
    FMenuHeight := TDashboardHeaderMenuItemSettings(Source).MenuHeight;
    FMarginX    := TDashboardHeaderMenuItemSettings(Source).MarginX;
    FMarginY    := TDashboardHeaderMenuItemSettings(Source).MarginY;
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Header Navigation Settings (TDashboardHeaderNavigationSettings)
(*
(******************************************************************************)
constructor TDashboardHeaderNavigationSettings.Create;
begin
  inherited Create;

  { Create Pictures }
  FPreviousNormal := TPicture.Create;
  FPreviousNormal.OnChange := SettingsChanged;
  FPreviousHot := TPicture.Create;
  FPreviousHot.OnChange := SettingsChanged;
  FPreviousPressed := TPicture.Create;
  FPreviousPressed.OnChange := SettingsChanged;
  FNextNormal := TPicture.Create;
  FNextNormal.OnChange := SettingsChanged;
  FNextHot := TPicture.Create;
  FNextHot.OnChange := SettingsChanged;
  FNextPressed := TPicture.Create;
  FNextPressed.OnChange := SettingsChanged;

  { Defaults }
  FCursor := crHandpoint;
end;

destructor TDashboardHeaderNavigationSettings.Destroy;
begin
  { Free Pictures }
  FPreviousNormal.Free;
  FPreviousHot.Free;
  FPreviousPressed.Free;
  FNextNormal.Free;
  FNextHot.Free;
  FNextPressed.Free;

  inherited Destroy;
end;

procedure TDashboardHeaderNavigationSettings.SetPreviousNormal(const P: TPicture);
begin
  FPreviousNormal.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderNavigationSettings.SetPreviousHot(const P: TPicture);
begin
  FPreviousHot.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderNavigationSettings.SetPreviousPressed(const P: TPicture);
begin
  FPreviousPressed.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderNavigationSettings.SetNextNormal(const P: TPicture);
begin
  FNextNormal.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderNavigationSettings.SetNextHot(const P: TPicture);
begin
  FNextHot.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderNavigationSettings.SetNextPressed(const P: TPicture);
begin
  FNextPressed.Assign(P);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderNavigationSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderNavigationSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardHeaderNavigationSettings then
  begin
    FPreviousNormal.Assign(TDashboardHeaderNavigationSettings(Source).PreviousNormal);
    FPreviousHot.Assign(TDashboardHeaderNavigationSettings(Source).PreviousHot);
    FPreviousPressed.Assign(TDashboardHeaderNavigationSettings(Source).PreviousPressed);
    FNextNormal.Assign(TDashboardHeaderNavigationSettings(Source).NextNormal);
    FNextHot.Assign(TDashboardHeaderNavigationSettings(Source).NextHot);
    FNextPressed.Assign(TDashboardHeaderNavigationSettings(Source).NextPressed);
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Header Tab Settings (TDashboardHeaderTabSettings)
(*
(******************************************************************************)
constructor TDashboardHeaderTabSettings.Create;
begin
  inherited Create;

  { Create Fonts }
  FActiveFont := TFont.Create;
  FActiveFont.OnChange := SettingsChanged;
  FActiveFont.Style    := [fsBold];
  FHoverFont := TFont.Create;
  FHoverFont.OnChange := SettingsChanged;

  { Defaults }
  FActiveFrom   := $00E3CA99;
  FActiveTo     := $00FEFAF5;
  FHoverFrom    := $00EAD9B5;
  FHoverTo      := $00FEFAF5;
  FFrom         := $00FDF1E5;
  FTo           := $00FEFAF5;
  FBorder       := $00E3CA99;
  FCursor       := crHandpoint;
  FOffsetX      := 8;
  FHeight       := 22;
  FActiveHeight := 25;
  FTextMargin   := 16;
end;

destructor TDashboardHeaderTabSettings.Destroy;
begin
  { Free Fonts }
  FActiveFont.Free;
  FHoverFont.Free;

  inherited Destroy;
end;

procedure TDashboardHeaderTabSettings.SetActiveFrom(const C: TColor);
begin
  if ActiveFrom <> C then
  begin
    FActiveFrom := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SetActiveTo(const C: TColor);
begin
  if ActiveTo <> C then
  begin
    FActiveTo := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SetHoverFrom(const C: TColor);
begin
  if HoverFrom <> C then
  begin
    FHoverFrom := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SetHoverTo(const C: TColor);
begin
  if HoverTo <> C then
  begin
    FHoverTo := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SetFromColor(const C: TColor);
begin
  if FromColor <> C then
  begin
    FFrom := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SetToColor(const C: TColor);
begin
  if ToColor <> C then
  begin
    FTo := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SetBorder(const C: TColor);
begin
  if Border <> C then
  begin
    FBorder := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SetActiveFont(const F: TFont);
begin
  FActiveFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderTabSettings.SetHoverFont(const F: TFont);
begin
  FHoverFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderTabSettings.SetOffsetX(const I: Integer);
begin
  if OffsetX <> I then
  begin
    FOffsetX := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SetHeight(const I: Integer);
begin
  if Height <> I then
  begin
    FHeight := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SetActiveHeight(const I: Integer);
begin
  if ActiveHeight <> I then
  begin
    FActiveHeight := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SetTextMargin(const I: Integer);
begin
  if TextMargin <> I then
  begin
    FTextMargin := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardHeaderTabSettings.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderTabSettings.Assign(Source: TPersistent);
begin
  if Source is TDashboardHeaderTabSettings then
  begin
    FActiveFrom := TDashboardHeaderTabSettings(Source).ActiveFrom;
    FActiveTo   := TDashboardHeaderTabSettings(Source).ActiveTo;
    FHoverFrom  := TDashboardHeaderTabSettings(Source).HoverFrom;
    FHoverTo    := TDashboardHeaderTabSettings(Source).HoverTo;
    FFrom       := TDashboardHeaderTabSettings(Source).FromColor;
    FTo         := TDashboardHeaderTabSettings(Source).ToColor;
    FBorder     := TDashboardHeaderTabSettings(Source).Border;
    FCursor     := TDashboardHeaderTabSettings(Source).Cursor;
    FActiveFont.Assign(TDashboardHeaderTabSettings(Source).ActiveFont);
    FHoverFont.Assign(TDashboardHeaderTabSettings(Source).HoverFont);
  end else
    inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Header Item (TDashboardHeaderItem)
(*
(******************************************************************************)
constructor TDashboardHeaderItem.Create(AOWner: TCollection);
begin
  inherited Create(AOwner);

  { Create Picture }
  FIcon := TPicture.Create;
  FIcon.OnChange := SettingsChanged;

  { Create Tabs }
  FTabs := TStringList.Create;
  FTabs.OnChange := SettingsChanged;

  { Default }
  FCaption := Format('Item %d', [Index]);
end;

destructor TDashboardHeaderItem.Destroy;
begin
  { Free Picture }
  FIcon.Free;

  { Free Tabs }
  FTabs.Free;

  inherited Destroy;
end;

function TDashboardHeaderItem.GetDisplayName : string;
begin
  if (Caption <> '') then
    Result := Caption
  else
    Result := Format('Item %d', [Index]);
end;

procedure TDashboardHeaderItem.SetIcon(const P: TPicture);
begin
  FIcon.Assign(P);
  Changed(False);
end;

procedure TDashboardHeaderItem.SetCaption(const C: TCaption);
begin
  if Caption <> C then
  begin
    FCaption := C;
    Changed(False);
  end;
end;

procedure TDashboardHeaderItem.SetTabs(const S: TStringlist);
begin
  if Tabs <> S then
  begin
    FTabs.Assign(S);
    Changed(False);
  end;
end;

procedure TDashboardHeaderItem.SettingsChanged(Sender: TObject);
begin
  Changed(False);
end;

procedure TDashboardHeaderItem.Assign(Source: TPersistent);
begin
  if Source is TDashboardHeaderItem then
  begin
    Caption := TDashboardHeaderItem(Source).Caption;
    Icon.Assign(TDashboardHeaderItem(Source).Icon);
    Changed(False);
  end else Inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Header Item Collection (TDashboardHeaderItemCollection)
(*
(******************************************************************************)
constructor TDashboardHeaderItemCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TDashboardHeaderItem);
end;

function TDashboardHeaderItemCollection.GetItem(Index: Integer) : TDashboardHeaderItem;
begin
  Result := inherited GetItem(Index) as TDashboardHeaderItem;
end;

function TDashboardHeaderItemCollection.Add : TDashboardHeaderItem;
begin
  Result := TDashboardHeaderItem(inherited Add);
end;

procedure TDashboardHeaderItemCollection.ItemChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self)
end;

procedure TDashboardHeaderItemCollection.SetItem(Index: Integer; const Value: TDashboardHeaderItem);
begin
  inherited SetItem(Index, Value);
  ItemChanged(Self);
end;

procedure TDashboardHeaderItemCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderItemCollection.Assign(Source: TPersistent);
var
  LI   : TDashboardHeaderItemCollection;
  Loop : Integer;
begin
  if (Source is TDashboardHeaderItemCollection)  then
  begin
    LI := TDashboardHeaderItemCollection(Source);
    Clear;
    for Loop := 0 to LI.Count - 1 do
        Add.Assign(LI.Items[Loop]);
  end else inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Header Menu Item (TDashboardHeaderMenuItem)
(*
(******************************************************************************)
constructor TDashboardHeaderMenuItem.Create(AOWner: TCollection);
begin
  inherited Create(AOwner);

  { Create Picture }
  FIcon := TPicture.Create;
  FIcon.OnChange := SettingsChanged;

  { Default }
  FCaption := Format('Item %d', [Index]);
end;

destructor TDashboardHeaderMenuItem.Destroy;
begin
  { Free Picture }
  FIcon.Free;

  inherited Destroy;
end;

function TDashboardHeaderMenuItem.GetDisplayName : string;
begin
  if (Caption <> '') then
    Result := Caption
  else
    Result := Format('Item %d', [Index]);
end;

procedure TDashboardHeaderMenuItem.SetIcon(const P: TPicture);
begin
  FIcon.Assign(P);
  Changed(False);
end;

procedure TDashboardHeaderMenuItem.SetCaption(const C: TCaption);
begin
  if Caption <> C then
  begin
    FCaption := C;
    Changed(False);
  end;
end;

procedure TDashboardHeaderMenuItem.SetMenu(const M: TPopupMenu);
begin
  FMenu := M;
  Changed(False);
end;

procedure TDashboardHeaderMenuItem.SettingsChanged(Sender: TObject);
begin
  Changed(False);
end;

procedure TDashboardHeaderMenuItem.Assign(Source: TPersistent);
begin
  if Source is TDashboardHeaderMenuItem then
  begin
    Caption := TDashboardHeaderMenuItem(Source).Caption;
    Menu    := TDashboardHeaderMenuItem(Source).Menu;
    Icon.Assign(TDashboardHeaderMenuItem(Source).Icon);
    Changed(False);
  end else Inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Header Menu Item Collection (TDashboardHeaderMenuItemCollection)
(*
(******************************************************************************)
constructor TDashboardHeaderMenuItemCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TDashboardHeaderMenuItem);
end;

function TDashboardHeaderMenuItemCollection.GetItem(Index: Integer) : TDashboardHeaderMenuItem;
begin
  Result := inherited GetItem(Index) as TDashboardHeaderMenuItem;
end;

function TDashboardHeaderMenuItemCollection.Add : TDashboardHeaderMenuItem;
begin
  Result := TDashboardHeaderMenuItem(inherited Add);
end;

procedure TDashboardHeaderMenuItemCollection.ItemChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self)
end;

procedure TDashboardHeaderMenuItemCollection.SetItem(Index: Integer; const Value: TDashboardHeaderMenuItem);
begin
  inherited SetItem(Index, Value);
  ItemChanged(Self);
end;

procedure TDashboardHeaderMenuItemCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardHeaderMenuItemCollection.Assign(Source: TPersistent);
var
  LI   : TDashboardHeaderItemCollection;
  Loop : Integer;
begin
  if (Source is TDashboardHeaderItemCollection)  then
  begin
    LI := TDashboardHeaderItemCollection(Source);
    Clear;
    for Loop := 0 to LI.Count - 1 do
        Add.Assign(LI.Items[Loop]);
  end else inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Header (TDashboardHeader)
(*
(******************************************************************************)
constructor TDashboardHeader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { If the ControlStyle property includes csOpaque, the control paints itself
    directly. We do not want the control to accept controls - because this is
    a header and not a container }
  ControlStyle := ControlStyle + [csOpaque, csCaptureMouse, csClickEvents, csDoubleClicks];

  { We do want to be able to get focus, this is a header that can handle input }
  TabStop := True;

  { Create Buffers }
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf32bit;

  { Align }
  Align := alTop;

  { Settings }
  FBackground := TDashboardHeaderBackgroundSettings.Create;
  FBackground.OnChange := SettingsChanged;
  FLogo := TDashboardHeaderLogoSettings.Create;
  FLogo.OnChange := SettingsChanged;
  FItem := TDashboardHeaderItemSettings.Create;
  FItem.OnChange := ItemsChanged;
  FMenu := TDashboardHeaderMenuItemSettings.Create;
  FMenu.OnChange := ItemsChanged;
  FNavigation := TDashboardHeaderNavigationSettings.Create;
  FNavigation.OnChange := SettingsChanged;
  FTabs := TDashboardHeaderTabSettings.Create;
  FTabs.OnChange := ItemsChanged;

  { Items }
  FItems := TDashboardHeaderItemCollection.Create(Self);
  FItems.OnChange := ItemsChanged;

  { Menu Items }
  FMenuItems := TDashboardHeaderMenuItemCollection.Create(Self);
  FMenuItems.OnChange := ItemsChanged;

  { Defaults }
  Height                := 177;
  FItemIndex            := -1;
  FHoverIndex           := -1;
  FMenuItemIndex        := -1;
  FMenuHoverIndex       := -1;
  FNavigationHoverIndex := -1;
  FNavigationIndex      := -1;
  FShowFocusRect        := False;
  FTabHoverIndex        := -1;
  FTabIndex             := -1;
  TabStop               := True;

  { Start Index }
  FItemsStartIndex := 0;

  { Initial Draw }
  RedrawPanel            := True;
  UpdateItemRects        := True;
  UpdateMenuItemRects    := True;
  FUpdateNavigationRects := True;
  FUpdateTabRects        := True;
end;

destructor TDashboardHeader.Destroy;
begin
  { Free Settings }
  FBackground.Free;
  FLogo.Free;
  FItem.Free;
  FMenu.Free;
  FNavigation.Free;
  FTabs.Free;

  { Free Items }
  FItems.Free;

  { Free Menu Items }
  FMenuItems.Free;
  
  { Free Buffer }
  FBuffer.Free;

  inherited Destroy;
end;

procedure TDashboardHeader.SetItemIndex(const I: Integer);
begin
  if (ItemIndex <> I) and (I >= -1) and (I < Items.Count) then
  begin
    FItemIndex := I;
    UpdateTabRects := True;
    if Items.Items[I].Tabs.Count = 0 then
      TabIndex := -1
    else
      TabIndex := 0;
    SettingsChanged(Self);
    if Assigned(FOnSelect) then FOnSelect(Self, I, Items.Items[I]);
    if Assigned(FOnItemIndex) then FOnItemIndex(Self);
  end;
end;

procedure TDashboardHeader.SetShowFocusRect(const B: Boolean);
begin
  if ShowFocusRect <> B then
  begin
    FShowFocusRect := B;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardHeader.SetTabIndex(const I: Integer);
begin
  if TabIndex <> I then
  begin
    FTabIndex := I;
    if Assigned(FOnTabIndex) then FOnTabIndex(Self);
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardHeader.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TDashboardHeader.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TDashboardHeader.CMMouseEnter(var Msg: TMessage);
var
  R : Boolean;
begin
  R := False;
  if (MenuItemIndex > -1) then
  begin
    R := True;
    MenuItemIndex := -1;
  end;
  if R then
  begin
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardHeader.CMMouseLeave(var Msg: TMessage);
var
  R : Boolean;
begin
  R := False;
  if (FHoverIndex > -1) then
  begin
    R := True;
    FHoverIndex := -1;
  end;
  if (FMenuHoverIndex > -1) then
  begin
    R := True;
    FMenuHoverIndex := -1;
  end;
  if (FNavigationHoverIndex > -1) then
  begin
    R := True;
    FNavigationHoverIndex := -1;
  end;
  if (FTabHoverIndex > -1) then
  begin
    R := True;
    FTabHoverIndex := -1;
  end;
  if R then
  begin
    RedrawPanel := True;
    Invalidate;
  end;
end;

function TDashboardHeader.ShowNavigationLeft : Boolean;
begin
  Result := (FItemsStartIndex > 0);
end;

function TDashboardHeader.ShowNavigationRight : Boolean;
begin
  Result := (MaxVisibleItems < Items.Count) and ((FItemsStartIndex + MaxVisibleItems) < Items.Count);
end;

function TDashboardHeader.MaxVisibleItems : Integer;
var
  L : Integer;
begin
  { Logo }
  if Assigned(Logo.Logo.Graphic) then
    L := Logo.Logo.Graphic.Width + Logo.MarginX
  else
    L := 0;
  { Max Visible Items }
  Result := Floor(((ClientWidth - L) - Item.OffsetX) / (Item.ItemWidth + (Item.MarginX * 2)));
end;

procedure TDashboardHeader.ItemsChanged(Sender: TObject);
begin
  if ItemIndex > Items.Count then FItemIndex := Items.Count -1;
  if (Items.Count > 0) and (ItemIndex = -1) then ItemIndex := 0;
  RedrawPanel         := True;
  UpdateItemRects     := True;
  UpdateMenuItemRects := True;
  UpdateTabRects      := True;
  Invalidate;
end;

procedure TDashboardHeader.SettingsChanged(Sender: TObject);
begin
  RedrawPanel := True;
  Invalidate;
end;

procedure TDashboardHeader.Paint;
var
  WorkRect: TRect;

  procedure DrawBackground(var FGraphics: IGPGraphics);
  const
    Angle : Array [TDashboardHeaderGradientDirection] of Integer = (0, 90); 
  var
    GradientBrush : IGPLinearGradientBrush;
    SolidBrush    : IGPSolidBrush;
    FromColor,
    ToColor,
    SolidColor    : TGPColor;
  begin
    if Background.Gradient then
    begin
      FromColor     := TGPColor.CreateFromColorRef(Background.FromColor);
      ToColor       := TGPColor.CreateFromColorRef(Background.ToColor);
      GradientBrush := TGPLinearGradientBrush.Create(TGPRect.Create(WorkRect), FromColor, ToColor, Angle[Background.Direction]);
      FGraphics.FillRectangle(GradientBrush, TGPRect.Create(WorkRect));
    end else
    begin
      SolidColor := TGPColor.CreateFromColorRef(Background.FromColor);
      SolidBrush := TGPSolidBrush.Create(SolidColor);
      FGraphics.FillRectangle(SolidBrush, TGPRect.Create(WorkRect));
    end;
    if Assigned(Background.Overlay.Graphic) then
    FBuffer.Canvas.Draw(0, 0, Background.Overlay.Graphic);
    with FBuffer.Canvas do
    begin
      if Background.Gradient then
        SolidColor := TGPColor.CreateFromColorRef(Background.ToColor)
      else
        SolidColor := TGPColor.CreateFromColorRef(Background.FromColor);
      SolidBrush := TGPSolidBrush.Create(SolidColor);
      FGraphics.FillRectangle(SolidBrush, TGPRect.Create(
        WorkRect.Left,
        WorkRect.Bottom -1,
        WorkRect.Right,
        ClientRect.Bottom
      ));
    end;
  end;

  procedure DrawLogo;
  var
    LogoX, LogoY : Integer;
  begin
    if Assigned(Logo.Logo.Graphic) then
    with FBuffer.Canvas do
    begin
      LogoX := WorkRect.Right - (Logo.MarginX + Logo.Logo.Graphic.Width);
      LogoY := Logo.MarginY + (WorkRect.Height div 2) - (Logo.Logo.Graphic.Height div 2);
      Draw(LogoX, LogoY, Logo.Logo.Graphic);
    end;
  end;

  procedure DrawItemOverlay(const Index: Integer);
  var
    OX, OY : Integer;
  begin
    if (Index = ItemIndex) and Items.Items[Index].InViewPort then
    begin
      OX := Items.Items[Index].ItemRect.Left + ((Item.ItemWidth div 2) - (Item.SelectionOverlay.Width div 2));
      OY := Item.OffsetY;
      FBuffer.Canvas.Draw(OX, OY, Item.SelectionOverlay.Graphic);
    end;
  end;
  
  procedure DrawItem(var FGraphics: IGPGraphics; const Start: Integer; const Index: Integer);
  var
    IconX, IconY, I : Integer;
    CaptionRect, R  : TRect;
  begin
    { Update Item Rects }
    I := Index - Start;
    if UpdateItemRects then
    begin
      Items.Items[Index].ItemRect := Rect(
        Item.OffsetX + ((I * Item.ItemWidth) + (I * Item.MarginX)),
        Item.OffsetY + Item.MarginY,
        Item.OffsetX + ((I * Item.ItemWidth) + (I * Item.MarginX)) + Item.ItemWidth,
        (WorkRect.Height - Item.OffsetY) - Item.MarginY
      );
    end;

    { Draw Selection Overlay }
    if not Item.SelectionOverIcon then DrawItemOverlay(Index);

    { Draw Item Icon }
    if Assigned(Items.Items[Index].Icon.Graphic) then
    begin
      IconX := Items.Items[Index].ItemRect.Left + ((Item.ItemWidth div 2) - (Items.Items[Index].Icon.Graphic.Width div 2)) + Item.IconMarginX;
      IconY := Items.Items[Index].ItemRect.Top + Item.IconMarginY;
      if Item.StretchIcon then
      begin
        FBuffer.Canvas.StretchDraw(Rect(
          Items.Items[Index].ItemRect.Left + ((Item.ItemWidth div 2) - (Item.IconWidth div 2)) + Item.IconMarginX,
          Items.Items[Index].ItemRect.Top + Item.IconMarginY,
          Items.Items[Index].ItemRect.Left + ((Item.ItemWidth div 2) + (Item.IconWidth div 2)),
          Items.Items[Index].ItemRect.Top + Item.IconMarginY + Item.IconHeight
        ), Items.Items[Index].Icon.Graphic);
      end else
        FBuffer.Canvas.Draw(IconX, IconY, Items.Items[Index].Icon.Graphic);
    end;
    { Draw Item Caption }
    FBuffer.Canvas.Brush.Style := bsClear;
    FBuffer.Canvas.Font.Assign(Font);
    if Index = FHoverIndex then FBuffer.Canvas.Font.Assign(Item.HoverFont);
    if Index = ItemIndex   then FBuffer.Canvas.Font.Assign(Item.SelectedFont);
    CaptionRect := Rect(
      Items.Items[Index].ItemRect.Left,
      Items.Items[Index].ItemRect.Top + Item.IconHeight + (Item.FIconMarginY * 2),
      Items.Items[Index].ItemRect.Right,
      Items.Items[Index].ItemRect.Bottom
    );
    DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[Index].Caption), Length(Items.Items[Index].Caption), CaptionRect, DT_CENTER or DT_VCENTER or DT_WORDBREAK or DT_END_ELLIPSIS);

    { Draw Selection Overlay }
    if Item.SelectionOverIcon then DrawItemOverlay(Index);

    { Focus Rect }
    if Focused and (Index = ItemIndex) and ShowFocusRect then
    begin
      R := Items.Items[Index].ItemRect;
      R.Left   := R.Left + 8;
      R.Top    := R.Top + 4;
      R.Right  := R.Right - 8;
      R.Bottom := R.Bottom - 4;
      FBuffer.Canvas.DrawFocusRect(R);
    end;
  end;
  
  procedure DrawItems(var FGraphics: IGPGraphics);
  var
    I, M : Integer;
  begin
    for I := 0 to Items.Count -1 do Items.Items[I].InViewPort := False;
    if (FItemsStartIndex + MaxVisibleItems) < Items.Count then
      M := FItemsStartIndex + MaxVisibleItems
    else
      M := Items.Count;
    for I := FItemsStartIndex to M -1 do
    begin
      Items.Items[I].InViewPort := True;
      DrawItem(FGraphics, FItemsStartIndex, I);
    end;
    UpdateItemRects := False;
  end;

  function MenuItemWidth(const Index: Integer) : Integer;
  var
    I, M : Integer;
  begin
    if Assigned(MenuItems.Items[Index].Icon.Graphic) then I := 20 else I := 0;
    if Assigned(MenuItems.Items[Index].Menu) then M := 13 else M := 0;
    Result := 4 + I + FBuffer.Canvas.TextWidth(MenuItems.Items[Index].Caption) + 4 + M
  end;

  function MenuItemCaretPath(const Rect: TRect) : IGPGraphicsPath;
  var
    Y : Integer;
    Path : IGPGraphicsPath;
  begin
    Path := TGPGraphicsPath.Create;
    Y := (Rect.Top + (Menu.MenuHeight div 2)) -1;
    Path.AddPolygon([
      TGPPoint.Create(Rect.Left + 5, Y),
      TGPPoint.Create(Rect.Right - 6, Y),
      TGPPoint.Create(Rect.Left + 8, Y + 3)
    ]);
    Path.CloseFigure;
    Result := Path;
  end;

  procedure DrawMenuItemCaret(var FGraphics: IGPGraphics; const Rect: TRect);
  var
    FCaretColor : TGPColor;
    FCaretBrush : IGPSolidBrush;
  begin
    FCaretColor := TGPColor.CreateFromColorRef(clBlack);
    FCaretBrush := TGPSolidBrush.Create(FCaretColor);
    FGraphics.FillPath(FCaretBrush, MenuItemCaretPath(Rect));
  end;

  procedure DrawMenuItems(var FGraphics: IGPGraphics);
  var
    I, X, W     : Integer;
    CaptionRect : TRect;
  begin
    X := WorkRect.Right - Menu.MarginX;
    for I := 0 to MenuItems.Count -1 do
    begin
      { Update Menu Item Rects }
      if UpdateMenuItemRects then
      begin
        W := MenuItemWidth(I);
        MenuItems.Items[I].ItemRect := Rect(
          X - W,
          WorkRect.Bottom,
          X,
          ClientRect.Bottom - 1
        );
        Dec(X, W);
      end;
    end;
    { Draw Menu Item }
    for I := 0 to MenuItems.Count -1 do
    begin
      FBuffer.Canvas.Font.Assign(Font);
      { Selected }
      if I = MenuItemIndex then
      with FBuffer.Canvas do
      begin
        FBuffer.Canvas.Font.Assign(Menu.ActiveFont);
        Brush.Color := Menu.ActiveBack;
        Brush.Style := bsSolid;
        Pen.Color   := Menu.ActiveBorder;
        Rectangle(MenuItems.Items[I].ItemRect);
      end else
      { Hover }
      if I = FMenuHoverIndex then
      with FBuffer.Canvas do
      begin
        Font.Assign(Menu.HoverFont);
        Brush.Color := Menu.HoverBack;
        Brush.Style := bsSolid;
        Pen.Color   := Menu.HoverBorder;
        Rectangle(MenuItems.Items[I].ItemRect);
      end;
      { Draw Icon }
      if Assigned(MenuItems.Items[I].Icon.Graphic) then
      begin
        FBuffer.Canvas.StretchDraw(Rect(
          MenuItems.Items[I].ItemRect.Left + 4,
          MenuItems.Items[I].ItemRect.Top + ((Menu.MenuHeight div 2) - 8),
          MenuItems.Items[I].ItemRect.Left + 20,
          MenuItems.Items[I].ItemRect.Top + ((Menu.MenuHeight div 2) + 8)
        ), MenuItems.Items[I].Icon.Graphic);
        X := 24;
      end else
        X := 4;
      FBuffer.Canvas.Brush.Style := bsClear;
      { Draw Caption }
      CaptionRect := Rect(
        MenuItems.Items[I].ItemRect.Left + X,
        MenuItems.Items[I].ItemRect.Top,
        MenuItems.Items[I].ItemRect.Right,
        MenuItems.Items[I].ItemRect.Bottom
      );
      DrawText(FBuffer.Canvas.Handle, PChar(MenuItems.Items[I].Caption), Length(MenuItems.Items[I].Caption), CaptionRect, DT_VCENTER or DT_SINGLELINE or DT_LEFT);
      { Draw Dropdown caret }
      if Assigned(MenuItems.Items[I].Menu) then
      DrawMenuItemCaret(FGraphics, Rect(
        MenuItems.Items[I].ItemRect.Right - 17,
        MenuItems.Items[I].ItemRect.Top,
        MenuItems.Items[I].ItemRect.Right,
        MenuItems.Items[I].ItemRect.Bottom
      ));
    end;
    UpdateMenuItemRects := False;
  end;

  procedure DrawNavigation;
  var
    X : Integer;
  begin
    if Assigned(Navigation.PreviousNormal.Graphic) and Assigned(Navigation.NextNormal.Graphic) then
    begin
      { Update Rects }
      if UpdateNavigationRects then
      begin
        Navigation.PreviousRect := Rect(
          ClientRect.Left + 8,
          ClientRect.Top + Item.OffsetY,
          ClientRect.Left + 8 + Navigation.PreviousNormal.Graphic.Width,
          ClientRect.Top + Item.OffsetY + Navigation.PreviousNormal.Graphic.Height
        );
        X := ClientRect.Left + 24 + Navigation.PreviousNormal.Graphic.Width;
        X := X + (MaxVisibleItems * (Item.ItemWidth + Item.MarginX));
        Navigation.NextRect := Rect(
          X + 8,
          ClientRect.Top + Item.OffsetY,
          X + 8 + Navigation.NextNormal.Graphic.Width,
          ClientRect.Top + Item.OffsetY + Navigation.NextNormal.Graphic.Height
        );
      end;
      with FBuffer.Canvas do
      begin
        { Draw Left navigation }
        if ShowNavigationLeft then
        begin
          if FNavigationIndex = 1 then
            Draw(Navigation.PreviousRect.Left, Navigation.PreviousRect.Top, Navigation.PreviousPressed.Graphic)
          else
          if FNavigationHoverIndex = 1 then
            Draw(Navigation.PreviousRect.Left, Navigation.PreviousRect.Top, Navigation.PreviousHot.Graphic)
          else
            Draw(Navigation.PreviousRect.Left, Navigation.PreviousRect.Top, Navigation.PreviousNormal.Graphic);
        end;

        { Draw Right navigation }
        if ShowNavigationRight then
        begin
          if FNavigationIndex = 2 then
            Draw(Navigation.NextRect.Left, Navigation.NextRect.Top, Navigation.NextPressed.Graphic)
          else
          if FNavigationHoverIndex = 2 then
            Draw(Navigation.NextRect.Left, Navigation.NextRect.Top, Navigation.NextHot.Graphic)
          else
            Draw(Navigation.NextRect.Left, Navigation.NextRect.Top, Navigation.NextNormal.Graphic);
        end;
      end;
    end;
  end;

  function MaxTabSpace : Integer;
  begin
    Result := 0;
    if (MenuItems.Count > 0) and (ItemIndex > -1) then
    Result := (MenuItems.Items[MenuItems.Count -1].ItemRect.Left - (Tabs.OffsetX * 2));
  end;

  function TotalTabSpace : Integer;
  var
    I : Integer;
  begin
    Result := 0;
    if (Items.Count > 0) and (ItemIndex > -1) then
    for I := 0 to Items.Items[ItemIndex].Tabs.Count -1 do
    begin
      if I = TabIndex then
        FBuffer.Canvas.Font.Assign(Tabs.ActiveFont)
      else
      if I = FTabHoverIndex then
        FBuffer.Canvas.Font.Assign(Tabs.HoverFont)
      else
        FBuffer.Canvas.Font.Assign(Font);

      Inc(Result, FBuffer.Canvas.TextWidth(Items.Items[ItemIndex].Tabs[I]) + 16);
    end;
  end;

  procedure DrawTab(var FGraphics: IGPGraphics; const Index: Integer);
  const
    Corner = 4;
  var
    GradientBrush      : IGPLinearGradientBrush;
    FromColor, ToColor : TGPColor;
    FBorderColor       : TGPColor;
    FBorderPen         : IGPPen;
    FTabPath           : IGPGraphicsPath;
    FTabRect           : TRect;
  begin
    FTabRect := FTabRects[Index];
    FBorderColor := TGPColor.CreateFromColorRef(Tabs.Border);
    FBorderPen   := TGPPen.Create(FBorderColor);
    if Index = TabIndex then
    begin
      FromColor     := TGPColor.CreateFromColorRef(Tabs.ActiveFrom);
      ToColor       := TGPColor.CreateFromColorRef(Tabs.ActiveTo);
      FBuffer.Canvas.Font.Assign(Tabs.ActiveFont);
    end else
    if Index = FTabHoverIndex then
    begin
      FromColor := TGPColor.CreateFromColorRef(Tabs.HoverFrom);
      ToColor   := TGPColor.CreateFromColorRef(Tabs.HoverTo);
      FBuffer.Canvas.Font.Assign(Tabs.HoverFont);
    end else
    begin
      FromColor := TGPColor.CreateFromColorRef(Tabs.FromColor);
      ToColor   := TGPColor.CreateFromColorRef(Tabs.ToColor);
      FBuffer.Canvas.Font.Assign(Font);
    end;
    GradientBrush := TGPLinearGradientBrush.Create(TGPRect.Create(FTabRect), FromColor, ToColor, 90);
    FTabPath := TGPGraphicsPath.Create;
    FTabPath.AddArc(FTabRect.Left, FTabRect.Top, Corner, Corner, 180, 90);
    FTabPath.AddArc(FTabRect.Right - Corner, FTabRect.Top, Corner, Corner, 270, 90);
    FTabPath.AddArc(FTabRect.Right, FTabRect.Bottom, 1, 1, 0, 90);
    FTabPath.AddArc(FTabRect.Left, FTabRect.Bottom, 1, 1, 90, 90);
    FTabPath.CloseFigure;
    FGraphics.FillPath(GradientBrush, FTabPath);
    FGraphics.DrawPath(FBorderPen, FTabPath);
    DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[ItemIndex].Tabs[Index]), Length(Items.Items[ItemIndex].Tabs[Index]), FTabRect, DT_VCENTER or DT_SINGLELINE or DT_CENTER or DT_END_ELLIPSIS);
  end;

  procedure DrawTabs(var FGraphics: IGPGraphics);
  var
    I, X, W      : Integer;
    FBorderColor : TGPColor;
    FBorderPen   : IGPPen;
    FBorderPath  : IGPGraphicsPath;
  begin
    if UpdateTabRects and (Items.Count > 0) then
    begin
      UpdateTabRects := False;
      SetLength(FTabRects, Items.Items[ItemIndex].Tabs.Count);
      X := ClientRect.Left + Tabs.OffsetX;

      { Fixed width }
      if TotalTabSpace > MaxTabSpace then
      begin
        W := Floor(MaxTabSpace / Items.Items[ItemIndex].Tabs.Count);
        if W < 4 then W := 4;
        for I := 0 to Items.Items[ItemIndex].Tabs.Count -1 do
        begin
          if TabIndex = I then 
          begin
            FBuffer.Canvas.Font.Assign(Tabs.ActiveFont);
            FTabRects[I] := Rect(
              X,
              ClientRect.Bottom - Tabs.ActiveHeight,
              X + W,
              ClientRect.Bottom
            );
          end else
          begin
            FTabRects[I] := Rect(
              X,
              ClientRect.Bottom - Tabs.Height,
              X + W,
              ClientRect.Bottom
            );
          end;
          Inc(X, W);
        end;
      end else
      { Variable Width }
      begin
        for I := 0 to Items.Items[ItemIndex].Tabs.Count -1 do
        begin
          FBuffer.Canvas.Font.Assign(Font);
          if FTabHoverIndex = I then FBuffer.Canvas.Font.Assign(Tabs.HoverFont);
          if TabIndex = I then 
          begin
            FBuffer.Canvas.Font.Assign(Tabs.ActiveFont);
            FTabRects[I] := Rect(
              X,
              ClientRect.Bottom - Tabs.ActiveHeight,
              X + (Tabs.TextMargin * 2) + FBuffer.Canvas.TextWidth(Items.Items[ItemIndex].Tabs[I]),
              ClientRect.Bottom
            );
          end else
          if FTabHoverIndex = I then 
          begin
            FBuffer.Canvas.Font.Assign(Tabs.HoverFont);
            FTabRects[I] := Rect(
              X,
              ClientRect.Bottom - Tabs.ActiveHeight,
              X + (Tabs.TextMargin * 2) + FBuffer.Canvas.TextWidth(Items.Items[ItemIndex].Tabs[I]),
              ClientRect.Bottom
            );
          end else
          begin
            FTabRects[I] := Rect(
              X,
              ClientRect.Bottom - Tabs.Height,
              X + (Tabs.TextMargin * 2) + FBuffer.Canvas.TextWidth(Items.Items[ItemIndex].Tabs[I]),
              ClientRect.Bottom
            );
          end;
          Inc(X, (Tabs.TextMargin * 2) + FBuffer.Canvas.TextWidth(Items.Items[ItemIndex].Tabs[I]));
        end;
      end;
    end;
    { Draw Border }
    FBorderColor := TGPColor.CreateFromColorRef(Tabs.Border);
    FBorderPen   := TGPPen.Create(FBorderColor);
    FBorderPath  := TGPGraphicsPath.Create;
    FBorderPath.AddLines([
      TGPPoint.Create(ClientRect.Left, ClientRect.Bottom -1),
      TGPPoint.Create(ClientRect.Right, ClientRect.Bottom -1)
    ]);
    FGraphics.DrawPath(FBorderPen, FBorderPath);
    { Draw Tabs }
    if (Items.Count > 0) and (ItemIndex > -1) then
    for I := 0 to Items.Items[ItemIndex].Tabs.Count -1 do DrawTab(FGraphics, I);
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
    WorkRect.Bottom := WorkRect.Bottom - Menu.MenuHeight;

    { Set Buffer size }
    FBuffer.SetSize(ClientWidth, ClientHeight);

    { Create GDI+ Graphic }
    FGraphics := TGPGraphics.Create(FBuffer.Canvas.Handle);
    FGraphics.SmoothingMode := SmoothingModeAntiAlias;
    FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;

    { Draw to buffer }
    DrawBackground(FGraphics);
    DrawLogo;
    DrawItems(FGraphics);
    DrawMenuItems(FGraphics);
    DrawNavigation;
    DrawTabs(FGraphics);
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

procedure TDashboardHeader.Resize;

  function ItemsInViewPort : Integer;
  var
    I : Integer;
  begin
    Result := 0;
    for I := 0 to Items.Count -1 do
    if Items.Items[I].InViewPort then Inc(Result);
  end;

begin
  RedrawPanel           := True;
  UpdateItemRects       := True;
  UpdateMenuItemRects   := True;
  UpdateNavigationRects := True;
  UpdateTabRects        := True;

  if (FItemsStartIndex > 0) and (ItemsInViewPort < MaxVisibleItems) then
  FItemsStartIndex := FItemsStartIndex -1;
  if (ItemsInViewPort > MaxVisibleItems) and (FItemsStartIndex >= Items.Count -1) then
  FItemsStartIndex := FItemsStartIndex +1;
  if (MaxVisibleItems >= Items.Count) then
  FItemsStartIndex := 0;

  inherited;
end;

procedure TDashboardHeader.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TDashboardHeader.WndProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    // Capture Keystrokes
    WM_GETDLGCODE:
      Message.Result := Message.Result or DLGC_WANTARROWS or DLGC_WANTALLKEYS;

    { Enabled/Disabled - Redraw }
    CM_ENABLEDCHANGED,
    CM_FOCUSCHANGED:
      begin
        FHoverIndex           := -1;
        FMenuHoverIndex       := -1;
        FNavigationHoverIndex := -1;
        FTabHoverIndex        := -1;
        FMenuItemIndex        := -1;
        RedrawPanel           := True;
        Invalidate;
      end;

    { Font Changed }
    CM_FONTCHANGED:
      begin
        Item.HoverFont.Name    := Font.Name;
        Item.HoverFont.Size    := Font.Size;
        Item.SelectedFont.Name := Font.Name;
        Item.SelectedFont.Size := Font.Size;

        Menu.HoverFont.Name    := Font.Name;
        Menu.HoverFont.Size    := Font.Size;
        Menu.ActiveFont.Name   := Font.Name;
        Menu.ActiveFont.Size   := Font.Size;

        Tabs.ActiveFont.Name   := Font.Name;
        Tabs.ActiveFont.Size   := Font.Size;
        Tabs.HoverFont.Name    := Font.Name;
        Tabs.HoverFont.Size    := Font.Size;

        RedrawPanel := True;
        Invalidate;
      end;
  end;
end;

procedure TDashboardHeader.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
var
  I : Integer;
  P : TPoint;
begin
  if Enabled then
  begin
    { Focus }
    if (not Focused) and CanFocus then SetFocus;
    { Header Items }
    for I := 0 to Items.Count -1 do
    if PtInRect(Items.Items[I].ItemRect, Point(X, Y)) and Items.Items[I].InViewPort then
    begin
      ItemIndex := I;
    end;
    { Header Menu Items }
    for I := 0 to MenuItems.Count -1 do
    if PtInRect(MenuItems.Items[I].ItemRect, Point(X, Y)) then
    begin
      MenuItemIndex := I;
      RedrawPanel := True;
      Invalidate;
      if Assigned(MenuItems.Items[I].OnClick) then MenuItems.Items[I].OnClick(MenuItems.Items[I]);
      if Assigned(MenuItems.Items[I].Menu) then
      begin
        MenuItems.Items[I].Menu.Alignment := paRight;
        P := ClientToScreen(Point(MenuItems.Items[I].ItemRect.Right, MenuItems.Items[I].ItemRect.Bottom));
        MenuItems.Items[I].Menu.Popup(P.X, P.Y);
      end;
      MenuItemIndex := -1;
      RedrawPanel := True;
      Invalidate;
    end;
    { Navigation }
    if ShowNavigationLeft and PtInRect(Navigation.PreviousRect, Point(X, Y)) and (FItemsStartIndex > 0) then
    begin
      FNavigationIndex := 1;
      FItemsStartIndex := FItemsStartIndex -1;
      UpdateItemRects := True;
      RedrawPanel     := True;
      Invalidate;
    end;
    if ShowNavigationRight and PtInRect(Navigation.NextRect, Point(X, Y)) then
    begin
      FNavigationIndex := 2;
      FItemsStartIndex := FItemsStartIndex +1;
      UpdateItemRects := True;
      RedrawPanel     := True;
      Invalidate;
    end;
    { Tabs }
    for I := 0 to Items.Items[ItemIndex].Tabs.Count -1 do
    if (Length(FTabRects) >= Items.Items[ItemIndex].Tabs.Count) and PtInRect(FTabRects[I], Point(X, Y)) then
    begin
      FTabIndex      := I;
      UpdateTabRects := True;
      RedrawPanel    := True;
      Invalidate;
      if Assigned(FOnTabIndex) then FOnTabIndex(Self);
    end;
    if (MenuItemIndex > -1) and Assigned(MenuItems.Items[I].Menu) then
    begin
      MenuItemIndex := -1;
      RedrawPanel := True;
      Invalidate;
    end;
  end;
  inherited;
end;

procedure TDashboardHeader.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
var
  R : Boolean;
begin
  R := False;
  if Enabled then
  begin
    if (MenuItemIndex > -1) then
    begin
      MenuItemIndex := -1;
      R := True;
    end;
    if (FNavigationIndex > -1) then
    begin
      FNavigationIndex := -1;
      R := True;
    end;
  end;
  if R then
  begin
    RedrawPanel := True;
    Invalidate;
  end;
  inherited;
end;

procedure TDashboardHeader.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
var
  R : Boolean;
  I : Integer;
  C : TCursor;
begin
  R := False;
  C := crDefault;
  if Enabled then
  begin
    if (FHoverIndex > -1) then
    begin
      FHoverIndex := -1;
      R := True;
    end;
    { Navigation }
    if (FNavigationHoverIndex > -1) then
    begin
      FNavigationHoverIndex := -1;
      R := True;
    end;
    if ShowNavigationLeft and PtInRect(Navigation.PreviousRect, Point(X, Y)) then
    begin
      C := Navigation.Cursor;
      FNavigationHoverIndex := 1;
      R := True
    end;
    if ShowNavigationRight and PtInRect(Navigation.NextRect, Point(X, Y)) then
    begin
      C := Navigation.Cursor;
      FNavigationHoverIndex := 2;
      R := True
    end;
    { Header Items }
    for I := 0 to Items.Count -1 do
    if PtInRect(Items.Items[I].ItemRect, Point(X, Y)) and Items.Items[I].InViewPort and (FHoverIndex <> I)  then
    begin
      FHoverIndex := I;
      C := Item.Cursor;
      R := True;
    end;
    if (FMenuHoverIndex > -1) then
    begin
      FMenuHoverIndex := -1;
      R := True;
    end;
    { Header Menu Items }
    for I := 0 to MenuItems.Count -1 do
    if PtInRect(MenuItems.Items[I].ItemRect, Point(X, Y)) and (FMenuHoverIndex <> I) then
    begin
      FMenuHoverIndex := I;
      C := Menu.Cursor;
      R := True;
    end;
    if (FTabHoverIndex > -1) then
    begin
      FTabHoverIndex := -1;
      R := True;
    end;
    { Tabs }
    for I := 0 to Items.Items[ItemIndex].Tabs.Count -1 do
    if (Length(FTabRects) >= Items.Items[ItemIndex].Tabs.Count) and PtInRect(FTabRects[I], Point(X, Y)) and (FTabHoverIndex <> I) then
    begin
      FTabHoverIndex := I;
      C := Tabs.Cursor;
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

procedure TDashboardHeader.KeyDown(var Key: Word; Shift: TShiftState);

  procedure Previous;
  begin
    if (ItemIndex > 0) then
    begin
      if (FItemsStartIndex = ItemIndex) and (MaxVisibleItems < Items.Count) then
      begin
        FItemsStartIndex := FItemsStartIndex -1;
        UpdateItemRects := True;
      end;
      ItemIndex := ItemIndex -1
    end;
  end;

  procedure Next;
  begin
    if (ItemIndex > (FItemsStartIndex + MaxVisibleItems)) and (Items.Count > ItemIndex) then
    begin
      FItemsStartIndex := FItemsStartIndex +1;
      UpdateItemRects := True;
    end;
    ItemIndex := ItemIndex +1;
  end;

begin
  {case Key of
    VK_LEFT  : Previous;
    VK_UP    : Next;
    VK_RIGHT : Next;
    VK_DOWN  : Previous;
  end;}
  case Key of
    VK_LEFT  : if (ItemIndex > 0) then ItemIndex := ItemIndex -1;
    VK_UP    : ItemIndex := ItemIndex +1;
    VK_RIGHT : ItemIndex := ItemIndex +1;
    VK_DOWN  : if (ItemIndex > 0) then ItemIndex := ItemIndex -1;
  end;
  inherited;
end;

procedure TDashboardHeader.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;

(******************************************************************************)
(*
(*  Register Dashboard Header (TDashboardHeader)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardHeader]);
end;

end.
