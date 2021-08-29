{
  untDashboardBevelLabel v1.0.0 - a label with a bevel line
  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}

unit untDashboardBevelLabel;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, Vcl.Themes;

type
  TDashboardBevelLabel = class(TGraphicControl)
  private
    { Private declarations }
    FAutoHeight     : Boolean;
    FTransparentSet : Boolean;
    FBevelOffset    : Integer;

    procedure SetAutoHeight(const B: Boolean);
    procedure SetTransparent(const B: Boolean);
    function GetTransparent: Boolean;
    procedure SetBevelOffset(const I: Integer);

    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    { Protected declarations }
    procedure AdjustBounds;
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property AutoHeight: Boolean read FAutoHeight write SetAutoHeight default True;
    property Transparent: Boolean read GetTransparent write SetTransparent stored FTransparentSet;
    property BevelOffset: Integer read FBevelOffset write SetBevelOffset default 8;

    property Align;
    property Anchors;
    property Caption;
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
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

(******************************************************************************)
(*
(*  Dashboard Bevel Label (TDashboardBevelLabel)
(*
(******************************************************************************)

constructor TDashboardBevelLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 296;
  Height := 17;
  if StyleServices.Enabled then
    ControlStyle := ControlStyle - [csOpaque]
  else
    ControlStyle := ControlStyle + [csOpaque];
  FAutoHeight  := True;
  FBevelOffset := 8;
end;

destructor TDashboardBevelLabel.Destroy;
begin
  inherited Destroy;
end;

function TDashboardBevelLabel.GetTransparent: Boolean;
begin
  Result := not (csOpaque in ControlStyle);
end;

procedure TDashboardBevelLabel.SetAutoHeight(const B: Boolean);
begin
  if AutoHeight <> B then
  begin
    FAutoHeight := B;
    AdjustBounds;
  end;
end;

procedure TDashboardBevelLabel.SetTransparent(const B: Boolean);
begin
  if Transparent <> B then
  begin
    if B then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
  FTransparentSet := True;
end;

procedure TDashboardBevelLabel.SetBevelOffset(const I: Integer);
begin
  if BevelOffset <> I then
  begin
    FBevelOffset := I;
    Invalidate;
  end;
end;

procedure TDashboardBevelLabel.CMFontChanged(var Message: TMessage);
begin
  AdjustBounds;
  Invalidate;
  inherited;
end;

procedure TDashboardBevelLabel.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
  inherited;
end;

procedure TDashboardBevelLabel.AdjustBounds;
var
  TH : Integer;
begin
  if not (csReading in ComponentState) and FAutoHeight then
  with Canvas do
  begin
    Font.Assign(Self.Font);
    TH := TextHeight(Caption);
    SetBounds(Left, Top, Width, TH);
  end;
end;

procedure TDashboardBevelLabel.Paint;

  procedure BevelLine(C: TColor; X1, Y1, X2, Y2: Integer);
  begin
    with Canvas do
    begin
      Pen.Color := C;
      MoveTo(X1, Y1);
      LineTo(X2, Y2);
    end;
  end;

var
  R      : TRect;
  TW, HC : Integer;
  C1, C2 : TColor;
begin
  with Canvas do
  begin
    R := ClientRect;
    if not Transparent then
    begin
      Brush.Color := Self.Color;
      Brush.Style := bsSolid;
      FillRect(R);
    end;
    Brush.Style := bsClear;
    Font.Assign(Self.Font);
    TW := TextWidth(Caption);
    if Enabled then
    begin
      DrawText(Canvas.Handle, PChar(Caption), Length(Caption), R, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
    end else
    begin
      OffsetRect(R, 1, 1);
      Canvas.Font.Color := clBtnHighlight;
      DrawText(Canvas.Handle, PChar(Caption), Length(Caption), R, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
      OffsetRect(R, -1, -1);
      Canvas.Font.Color := clBtnShadow;
      DrawText(Canvas.Handle, PChar(Caption), Length(Caption), R, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
    end;
    if (ClientWidth > TW) then
    begin
      C1 := StyleServices.GetSystemColor(clBtnShadow);
      C2 := StyleServices.GetSystemColor(clBtnHighlight);
      HC := ClientHeight div 2;
      BevelLine(C1, TW + BevelOffset, HC, ClientWidth, HC);
      BevelLine(C2, TW + BevelOffset, HC +1, ClientWidth, HC + 1);
    end;
  end;
end;

(******************************************************************************)
(*
(*  Register Dashboard Bevel Label (TDashboardBevelLabel)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardBevelLabel]);
end;

end.
