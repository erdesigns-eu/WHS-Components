{
  untDashboardTaskPanel v1.0.0 -
  a Windows Server 2011 Dashboard style Tasks Panel

  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}


unit untDashboardTaskPanel;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, VCL.Themes;

type
  TDashboardTaskListClickEvent = procedure(Sender: TObject; const CategoryIndex: Integer; const TaskIndex: Integer) of object;

  TDashboardTaskListCategoryHeader = class(TPersistent)
  private
    { Private declarations }
    FFrom   : TColor;
    FTo     : TColor;
    FBorder : TColor;
    FFont   : TFont;
    FHeight : Integer;

    FOnChange  : TNotifyEvent;

    procedure SetFrom(const C: TColor);
    procedure SetTo(const C: TColor);
    procedure SetBorder(const C: TColor);
    procedure SetFont(const F: TFont);
    procedure SetHeight(const I: Integer);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure SettingsChanged(Sender: TObject);
  published
    { Published declarations }
    property FromColor: TColor read FFrom write SetFrom default clWhite;
    property ToColor: TColor read FTo write SetTo default $00FDF1E5;
    property Border: TColor read FBorder write SetBorder default $00C08F33;
    property Font: TFont read FFont write SetFont;
    property Height: Integer read FHeight write SetHeight default 24;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardTaskListTask = class(TPersistent)
  private
    { Private declarations }
    FFont        : TFont;
    FHotFont     : TFont;
    FItemHeight  : Integer;
    FIconSize    : Integer;
    FItemPadding : Integer;
    FCursor      : TCursor;

    FOnChange  : TNotifyEvent;

    procedure SetFont(const F: TFont);
    procedure SetHotFont(const F: TFont);
    procedure SetItemHeight(const I: Integer);
    procedure SetIconSize(const I: Integer);
    procedure SetItemPadding(const I: Integer);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure SettingsChanged(Sender: TObject);
  published
    { Published declarations }
    property Font: TFont read FFont write SetFont;
    property HoverFont: TFont read FHotFont write SetHotFont;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 24;
    property IconSize: Integer read FIconSize write SetIconSize default 16;
    property ItemPadding: Integer read FItemPadding write SetItemPadding default 8;
    property Cursor: TCursor read FCursor write FCursor default crHandpoint;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TDashboardTaskItem = class(TCollectionItem)
  private
    FIcon    : TPicture;
    FText    : TCaption;
    FOnClick : TNotifyEvent;

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

    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TDashboardTaskItemCollection = class(TOwnedCollection)
  private
    FOnChange : TNotifyEvent;

    procedure ItemChanged(Sender: TObject);

    function GetItem(Index: Integer): TDashboardTaskItem;
    procedure SetItem(Index: Integer; const Value: TDashboardTaskItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDashboardTaskItem;
    procedure Assign(Source: TPersistent); override;

    property Items[Index: Integer]: TDashboardTaskItem read GetItem write SetItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TDashboardTaskCategory = class(TCollectionItem)
  private
    FText  : TCaption;
    FTasks : TDashboardTaskItemCollection;

    FRect  : TRect;

    procedure SetText(const C: TCaption);
    procedure SetTasks(const T: TDashboardTaskItemCollection);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(AOWner: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure SettingsChanged(Sender: TObject);

    property ItemRect: TRect read FRect write FRect;
  published
    property Text: TCaption read FText write SetText;
    property Tasks: TDashboardTaskItemCollection read FTasks write SetTasks;
  end;

  TDashboardTaskCategoryCollection = class(TOwnedCollection)
  private
    FOnChange : TNotifyEvent;

    procedure ItemChanged(Sender: TObject);

    function GetItem(Index: Integer): TDashboardTaskCategory;
    procedure SetItem(Index: Integer; const Value: TDashboardTaskCategory);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDashboardTaskCategory;
    procedure Assign(Source: TPersistent); override;

    property Items[Index: Integer]: TDashboardTaskCategory read GetItem write SetItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TDashboardTaskPanel = class(TCustomControl)
  private
    { Private declarations }
    FHeader : TDashboardTaskListCategoryHeader;
    FTask   : TDashboardTaskListTask;
    FItems  : TDashboardTaskCategoryCollection;

    { Buffer - Avoid flickering }
    FBuffer       : TBitmap;
    FUpdateRect   : TRect;
    FRedraw       : Boolean;
    FRecalc       : Boolean;

    FScrollPosY   : Integer;  // Scrollbar Position
    FOldScrollY   : Integer;
    FScrollMaxY   : Integer;

    FHotTaskIndex : Array [0..1] of Integer;
    FOnTaskClick  : TDashboardTaskListClickEvent;

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
    procedure SetScrollPosY(Y: Integer);
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;

    procedure SettingsChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property RedrawPanel: Boolean read FRedraw write FRedraw;
    property Recalculate: Boolean read FRecalc write FRecalc;
    property UpdateRect: TRect read FUpdateRect write FUpdateRect;
  published
    { Published declarations }
    property Header: TDashboardTaskListCategoryHeader read FHeader write FHeader;
    property Task: TDashboardTaskListTask read FTask write FTask;
    property Items: TDashboardTaskCategoryCollection read FItems write FItems;

    property OnTaskClick: TDashboardTaskListClickEvent read FOnTaskClick write FOnTaskClick;

    property Align default alRight;
    property Anchors;
    property Color default $00FFFCF9;
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
(*  Dashboard Task List Category Header (TDashboardTaskListCategoryHeader)
(*
(******************************************************************************)
constructor TDashboardTaskListCategoryHeader.Create;
begin
  inherited Create;

  { Create Font }
  FFont := TFont.Create;
  FFont.OnChange := SettingsChanged;
  FFont.Style := [fsBold];

  { Defaults }
  FFrom   := clWhite;
  FTo     := $00FDF1E5;
  FBorder := $00C08F33;
  FHeight := 24;
end;

destructor TDashboardTaskListCategoryHeader.Destroy;
begin
  { Free Font }
  FFont.Free;

  inherited Destroy;
end;

procedure TDashboardTaskListCategoryHeader.SetFrom(const C: TColor);
begin
  if FromColor <> C then
  begin
    FFrom := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardTaskListCategoryHeader.SetTo(const C: TColor);
begin
  if ToColor <> C then
  begin
    FTo := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardTaskListCategoryHeader.SetBorder(const C: TColor);
begin
  if Border <> C then
  begin
    FBorder := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardTaskListCategoryHeader.SetFont(const F: TFont);
begin
  FFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardTaskListCategoryHeader.SetHeight(const I: Integer);
begin
  if Height <> I then
  begin
    FHeight := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardTaskListCategoryHeader.Assign(Source: TPersistent);
begin
  if Source is TDashboardTaskListCategoryHeader then
  begin
    FFrom   := TDashboardTaskListCategoryHeader(Source).FromColor;
    FTo     := TDashboardTaskListCategoryHeader(Source).ToColor;
    FBorder := TDashboardTaskListCategoryHeader(Source).Border;
  end else
    inherited;
end;

procedure TDashboardTaskListCategoryHeader.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

(******************************************************************************)
(*
(*  Dashboard Task List Task (TDashboardTaskListTask)
(*
(******************************************************************************)
constructor TDashboardTaskListTask.Create;
begin
  inherited Create;

  { Create Fonts }
  FFont := TFont.Create;
  FFont.OnChange := SettingsChanged;
  FHotFont := TFont.Create;
  FHotFont.OnChange := SettingsChanged;
  FHotFont.Style := [fsUnderline];

  { Defaults }
  FItemHeight  := 24;
  FIconSize    := 16;
  FItemPadding := 8;
  FCursor      := crHandpoint;
end;

destructor TDashboardTaskListTask.Destroy;
begin
  { Free Fonts }
  FFont.Free;
  FHotFont.Free;

  inherited Destroy;
end;

procedure TDashboardTaskListTask.SetFont(const F: TFont);
begin
  FFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardTaskListTask.SetHotFont(const F: TFont);
begin
  FHotFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardTaskListTask.SetItemHeight(const I: Integer);
begin
  if ItemHeight <> I then
  begin
    FItemHeight := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardTaskListTask.SetIconSize(const I: Integer);
begin
  if IconSize <> I then
  begin
    FIconSize := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardTaskListTask.SetItemPadding(const I: Integer);
begin
  if ItemPadding <> I then
  begin
    FItemPadding := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TDashboardTaskListTask.Assign(Source: TPersistent);
begin
  if Source is TDashboardTaskListTask then
  begin
    FFont.Assign(TDashboardTaskListTask(Source).Font);
    FHotFont.Assign(TDashboardTaskListTask(Source).HoverFont);
    FItemHeight  := TDashboardTaskListTask(Source).ItemHeight;
    FIconSize    := TDashboardTaskListTask(Source).IconSize;
    FItemPadding := TDashboardTaskListTask(Source).ItemPadding;
  end else
    inherited;
end;

procedure TDashboardTaskListTask.SettingsChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

(******************************************************************************)
(*
(*  Dashboard TaskPanel Task Item (TDashboardTaskItem)
(*
(******************************************************************************)
constructor TDashboardTaskItem.Create(AOWner: TCollection);
begin
  inherited Create(AOwner);

  { Create Picture }
  FIcon := TPicture.Create;
  FIcon.OnChange := SettingsChanged;

  { Defaults }
  FText := Format('Task %d', [Index]);
end;

destructor TDashboardTaskItem.Destroy;
begin
  { Free Picture }
  FIcon.Free;

  inherited Destroy;
end;

function TDashboardTaskItem.GetDisplayName : String;
begin
  Result := Text;
end;

procedure TDashboardTaskItem.SetIcon(const P: TPicture);
begin
  FIcon.Assign(P);
  Changed(False);
end;

procedure TDashboardTaskItem.SetText(const C: TCaption);
begin
  if Text <> C then
  begin
    FText := C;
    Changed(False);
  end;
end;

procedure TDashboardTaskItem.Assign(Source: TPersistent);
begin
  if Source is TDashboardTaskItem then
  begin
    Text := TDashboardTaskItem(Source).Text;
    FIcon.Assign(TDashboardTaskItem(Source).Icon);
    Changed(False);
  end else Inherited;
end;

procedure TDashboardTaskItem.SettingsChanged(Sender: TObject);
begin
  Changed(False);
end;

(******************************************************************************)
(*
(*  Dashboard TaskPanel Task Item Collection (TDashboardTaskItemCollection)
(*
(******************************************************************************)
constructor TDashboardTaskItemCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TDashboardTaskItem);
end;

function TDashboardTaskItemCollection.GetItem(Index: Integer) : TDashboardTaskItem;
begin
  Result := inherited GetItem(Index) as TDashboardTaskItem;
end;

function TDashboardTaskItemCollection.Add : TDashboardTaskItem;
begin
  Result := TDashboardTaskItem(inherited Add);
end;

procedure TDashboardTaskItemCollection.ItemChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self)
end;

procedure TDashboardTaskItemCollection.SetItem(Index: Integer; const Value: TDashboardTaskItem);
begin
  inherited SetItem(Index, Value);
  ItemChanged(Self);
end;

procedure TDashboardTaskItemCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardTaskItemCollection.Assign(Source: TPersistent);
var
  LI   : TDashboardTaskItemCollection;
  Loop : Integer;
begin
  if (Source is TDashboardTaskItemCollection)  then
  begin
    LI := TDashboardTaskItemCollection(Source);
    Clear;
    for Loop := 0 to LI.Count - 1 do
        Add.Assign(LI.Items[Loop]);
  end else inherited;
end;

(******************************************************************************)
(*
(*  Dashboard TaskPanel Task Category (TDashboardTaskCategory)
(*
(******************************************************************************)
constructor TDashboardTaskCategory.Create(AOWner: TCollection);
begin
  inherited Create(AOwner);

  { Create Tasks }
  FTasks := TDashboardTaskItemCollection.Create(Self);
  FTasks.OnChange := SettingsChanged;

  { Defaults }
  FText := Format('Category %d', [Index]);
end;

destructor TDashboardTaskCategory.Destroy;
begin
  { Free Tasks }
  FTasks.Free;

  inherited Destroy;
end;

function TDashboardTaskCategory.GetDisplayName : String;
begin
  Result := Text;
end;

procedure TDashboardTaskCategory.SetText(const C: TCaption);
begin
  if Text <> C then
  begin
    FText := C;
    Changed(False);
  end;
end;

procedure TDashboardTaskCategory.SetTasks(const T: TDashboardTaskItemCollection);
begin
  FTasks.Assign(T);
  Changed(False);
end;

procedure TDashboardTaskCategory.Assign(Source: TPersistent);
begin
  if Source is TDashboardTaskCategory then
  begin
    FText := TDashboardTaskCategory(Source).Text;
    FTasks.Assign(TDashboardTaskCategory(Source).Tasks);
    Changed(False);
  end else Inherited;
end;

procedure TDashboardTaskCategory.SettingsChanged(Sender: TObject);
begin
  Changed(False);
end;

(******************************************************************************)
(*
(*  Dashboard TaskPanel Task Category Collection (TDashboardTaskCategoryCollection)
(*
(******************************************************************************)
constructor TDashboardTaskCategoryCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TDashboardTaskCategory);
end;

function TDashboardTaskCategoryCollection.GetItem(Index: Integer) : TDashboardTaskCategory;
begin
  Result := inherited GetItem(Index) as TDashboardTaskCategory;
end;

function TDashboardTaskCategoryCollection.Add : TDashboardTaskCategory;
begin
  Result := TDashboardTaskCategory(inherited Add);
end;

procedure TDashboardTaskCategoryCollection.ItemChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self)
end;

procedure TDashboardTaskCategoryCollection.SetItem(Index: Integer; const Value: TDashboardTaskCategory);
begin
  inherited SetItem(Index, Value);
  ItemChanged(Self);
end;

procedure TDashboardTaskCategoryCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDashboardTaskCategoryCollection.Assign(Source: TPersistent);
var
  LI   : TDashboardTaskCategoryCollection;
  Loop : Integer;
begin
  if (Source is TDashboardTaskCategoryCollection)  then
  begin
    LI := TDashboardTaskCategoryCollection(Source);
    Clear;
    for Loop := 0 to LI.Count - 1 do
        Add.Assign(LI.Items[Loop]);
  end else inherited;
end;

(******************************************************************************)
(*
(*  Dashboard Task Panel (TDashboardTaskPanel)
(*
(******************************************************************************)
constructor TDashboardTaskPanel.Create(AOwner: TComponent);
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

  { Header }
  FHeader := TDashboardTaskListCategoryHeader.Create;
  FHeader.OnChange := SettingsChanged;

  { Task }
  FTask := TDashboardTaskListTask.Create;
  FTask.OnChange := SettingsChanged;

  { Create Items }
  FItems := TDashboardTaskCategoryCollection.Create(Self);
  FItems.OnChange := SettingsChanged;

  { Width / Height }
  Width  := 321;
  Height := 185;

  { Defaults }
  Align        := alRight;
  TabStop      := False;
  Color        := $00FFFCF9;

  { Initial Draw }
  RedrawPanel := True;
  Recalculate := True;
  FHotTaskIndex[0] := -1;
  FHotTaskIndex[1] := -1;
  FScrollPosY := 0;
end;

destructor TDashboardTaskPanel.Destroy;
begin
  { Free Buffer }
  FBuffer.Free;

  { Free Header }
  FHeader.Free;

  { Free Task }
  FTask.Free;

  { Free Items }
  FItems.Free;

  inherited Destroy;
end;

procedure TDashboardTaskPanel.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TDashboardTaskPanel.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TDashboardTaskPanel.CMMouseEnter(var Msg: TMessage);
begin
  if (FHotTaskIndex[0] <> -1) or (FHotTaskIndex[1] <> -1) then
  begin
    FHotTaskIndex[0] := -1;
    FHotTaskIndex[1] := -1;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardTaskPanel.CMMouseLeave(var Msg: TMessage);
begin
  if (FHotTaskIndex[0] <> -1) or (FHotTaskIndex[1] <> -1) then
  begin
    FHotTaskIndex[0] := -1;
    FHotTaskIndex[1] := -1;
    RedrawPanel := True;
    Invalidate;
  end;
end;

procedure TDashboardTaskPanel.CMParentFontChanged(var Message: TCMParentFontChanged);
begin
  if ParentFont then
  begin
    if Message.WParam <> 0 then
    begin
      Header.Font.Name    := Message.Font.Name;
      Task.Font.Name      := Message.Font.Name;
      Task.HoverFont.Name := Message.Font.Name;
    end;
  end;
end;

procedure TDashboardTaskPanel.Paint;
var
  WorkRect: TRect;

  procedure DrawBackground;
  begin
    FBuffer.Canvas.Brush.Color := Color;
    FBuffer.Canvas.FillRect(ClientRect);
  end;

  procedure DrawCategoryHeader(var FGraphics: IGPGraphics; const CategoryIndex: Integer);
  var
    GradientBrush      : IGPLinearGradientBrush;
    FromColor, ToColor : TGPColor;
    FBorderColor       : TGPColor;
    FBorderPen         : IGPPen;
    CaptionRect        : TRect;
  begin
    FBorderColor   := TGPColor.CreateFromColorRef(Header.Border);
    FBorderPen     := TGPPen.Create(FBorderColor);
    FromColor      := TGPColor.CreateFromColorRef(Header.FromColor);
    ToColor        := TGPColor.CreateFromColorRef(Header.ToColor);
    GradientBrush  := TGPLinearGradientBrush.Create(TGPRect.Create(Items.Items[CategoryIndex].ItemRect), FromColor, ToColor, 90);
    FGraphics.FillRectangle(GradientBrush, TGPRect.Create(Items.Items[CategoryIndex].ItemRect));
    FGraphics.DrawRectangle(FBorderPen, TGPRect.Create(Items.Items[CategoryIndex].ItemRect));
    FBuffer.Canvas.Font.Assign(Header.Font);
    FBuffer.Canvas.Brush.Style := bsClear;
    CaptionRect := Rect(
      Items.Items[CategoryIndex].ItemRect.Left + 8,
      Items.Items[CategoryIndex].ItemRect.Top,
      Items.Items[CategoryIndex].ItemRect.Right - 8,
      Items.Items[CategoryIndex].ItemRect.Bottom
    );
    DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[CategoryIndex].Text), Length(Items.Items[CategoryIndex].Text), CaptionRect, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
  end;

  procedure DrawItem(const CategoryIndex: Integer; const TaskIndex: Integer);
  var
    IconRect, CaptionRect : TRect;
  begin
    with FBuffer.Canvas do
    begin
      { Icon }
      IconRect := Rect(
        Items.Items[CategoryIndex].Tasks.Items[TaskIndex].ItemRect.Left + Task.ItemPadding,
        (Items.Items[CategoryIndex].Tasks.Items[TaskIndex].ItemRect.Top + (Task.ItemHeight div 2)) - (Task.IconSize div 2),
        Items.Items[CategoryIndex].Tasks.Items[TaskIndex].ItemRect.Left + Task.ItemPadding + Task.IconSize,
        (Items.Items[CategoryIndex].Tasks.Items[TaskIndex].ItemRect.Top + (Task.ItemHeight div 2)) + (Task.IconSize div 2)
      );
      if Assigned(Items.Items[CategoryIndex].Tasks.Items[TaskIndex].Icon.Graphic) then
      StretchDraw(IconRect, Items.Items[CategoryIndex].Tasks.Items[TaskIndex].Icon.Graphic);
      { Caption }
      CaptionRect := Rect(
         Items.Items[CategoryIndex].Tasks.Items[TaskIndex].ItemRect.Left + Task.ItemPadding + Task.IconSize + Task.ItemPadding,
         Items.Items[CategoryIndex].Tasks.Items[TaskIndex].ItemRect.Top,
         Items.Items[CategoryIndex].Tasks.Items[TaskIndex].ItemRect.Right - Task.ItemPadding,
         Items.Items[CategoryIndex].Tasks.Items[TaskIndex].ItemRect.Bottom
      );
      if (FHotTaskIndex[0] = CategoryIndex) and (FHotTaskIndex[1] = TaskIndex) then
        FBuffer.Canvas.Font.Assign(Task.HoverFont)
      else
        FBuffer.Canvas.Font.Assign(Task.Font);
      FBuffer.Canvas.Brush.Style := bsClear;
      DrawText(FBuffer.Canvas.Handle, PChar(Items.Items[CategoryIndex].Tasks.Items[TaskIndex].Text), Length(Items.Items[CategoryIndex].Tasks.Items[TaskIndex].Text), CaptionRect, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
    end;
  end;

  procedure UpdateRects;
  var
    Y, H, T : Integer;
  begin
    Y := WorkRect.Top - FScrollPosY;
    for H := 0 to Items.Count -1 do
    begin
      Items.Items[H].ItemRect := Rect(
        WorkRect.Left,
        Y,
        WorkRect.Right -1,
        Y + Header.Height
      );
      Inc(Y, Header.Height);
      for T := 0 to Items.Items[H].Tasks.Count -1 do
      begin
        Items.Items[H].Tasks.Items[T].ItemRect := Rect(
          WorkRect.Left,
          Y,
          WorkRect.Right,
          Y + Task.ItemHeight
        );
        Inc(Y, Task.ItemHeight);
      end;
    end;
  end;

  procedure DrawItems(var FGraphics: IGPGraphics);
  var
    H, T : Integer;
  begin
    if Recalculate then
    begin
      Recalculate := False;
      UpdateRects;
    end;
    for H := 0 to Items.Count -1 do
    begin
      DrawCategoryHeader(FGraphics, H);
      for T := 0 to Items.Items[H].Tasks.Count -1 do
      DrawItem(H, T);
    end;
  end;

  function ScrollMax : Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to Items.Count -1 do
    begin
      Inc(Result, Header.Height);
      Inc(Result, Items.Items[I].Tasks.Count * Task.ItemHeight);
    end;
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
    FScrollMaxY := ScrollMax;

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

procedure TDashboardTaskPanel.Resize;
begin
  if (FScrollMaxY > ClientHeight) and (FScrollPosY >= (FScrollMaxY - ClientHeight)) then FScrollPosY := (FScrollMaxY - ClientHeight);
  RedrawPanel := True;
  Recalculate := True;
  inherited;
end;

procedure TDashboardTaskPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  Style := Style or WS_VSCROLL and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TDashboardTaskPanel.WndProc(var Message: TMessage);
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

procedure TDashboardTaskPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
var
  H, T : Integer;
begin
  if Enabled then
  begin
    for H := 0 to Items.Count -1 do
    for T := 0 to Items.Items[H].Tasks.Count -1 do
    if PTInRect(Items.Items[H].Tasks.Items[T].ItemRect, Point(X, Y)) then
    begin
      if Assigned(Items.Items[H].Tasks.Items[T].OnClick) then Items.Items[H].Tasks.Items[T].OnClick(Items.Items[H].Tasks.Items[T]);
      if Assigned(OnTaskClick) then OnTaskClick(Self, H, T);
      break;
    end;
  end;
  inherited;
end;

procedure TDashboardTaskPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  inherited
end;

procedure TDashboardTaskPanel.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
var
  H, T : Integer;
begin
  if Enabled then
  begin
    if (FHotTaskIndex[0] <> -1) or (FHotTaskIndex[1] <> -1) then
    begin
      FHotTaskIndex[0] := -1;
      FHotTaskIndex[1] := -1;
      RedrawPanel := True;
      Invalidate;
    end;
    for H := 0 to Items.Count -1 do
    for T := 0 to Items.Items[H].Tasks.Count -1 do
    if PTInRect(Items.Items[H].Tasks.Items[T].ItemRect, Point(X, Y)) then
    begin
      FHotTaskIndex[0] := H;
      FHotTaskIndex[1] := T;
      RedrawPanel := True;
      Invalidate;
      break;
    end;
  end;
  if (FHotTaskIndex[0] <> -1) and (FHotTaskIndex[1] <> -1) then
  begin
    if Cursor <> Task.Cursor then Cursor := Task.Cursor;
  end else
  begin
    if Cursor <> crDefault then Cursor := crDefault;
  end;
  inherited;
end;

procedure TDashboardTaskPanel.SetScrollPosY(Y: Integer);
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
    Recalculate := True;
    if FOldScrollY <> FScrollPosY then Invalidate;
    FOldScrollY := FScrollPosY;
  end;
end;

function TDashboardTaskPanel.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  if Enabled then
  begin
    SetScrollPosY(FScrollPosY - (WheelDelta div 10));
  end;
  Result := True;
end;

procedure TDashboardTaskPanel.SettingsChanged(Sender: TObject);
begin
  RedrawPanel := True;
  Recalculate := True;
  Invalidate;
end;

(******************************************************************************)
(*
(*  Register Dashboard Task Panel (TDashboardTaskPanel)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardTaskPanel]);
end;

end.
