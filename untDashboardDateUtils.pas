{
  untDashboardDateUtils v1.0.0 - a non visual component with Date, Locale, TZ information
  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Home Server Components Pack.

  (c) Copyright 2021 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

}

unit untDashboardDateUtils;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, System.Types,
  System.Win.Registry, System.DateUtils;

type
  _REG_TZI_FORMAT = record
    Bias: Longint;
    StandardBias: Longint;
    DaylightBias: Longint;
    StandardDate: TSystemTime;
    DaylightDate: TSystemTime;
  end;

  TDashboardDateUtils = class(TComponent)
  private
    { Private declarations }
    FTimeZoneKey          : string;
    FLocalTimezoneName    : string;
    FLocalTimezoneDLT     : string;
    FLocalTimezoneStd     : string;
    FLocalCountry         : string;
    FLocalLanguage        : string;
    FEnglishLanguage      : string;
    FEnglishCountry       : string;
    FTimezoneStandard     : TDateTime;
    FTimezoneDaylight     : TDateTime;
    FTimezoneBias         : Integer;
    FTimezoneDaylightBias : Integer;
    FTimezoneStandardBias : Integer;
    FTimezoneNames        : TStringList;
    FKeyboardLayouts      : TStringList;
    FKeyboardLayout       : string;

    function GetActiveKeyboardLayout : string;
  protected
    procedure LoadTimeZoneNames;
    procedure LoadCurrentTimezone;
    procedure LoadDaylightStandardDates;
    procedure LoadRegionAndLanguage;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Timezones: TStringlist read FTimezoneNames;
    property TimezoneName: string read FLocalTimezoneName;
    property TimezoneDLTName: string read FLocalTimezoneDLT;
    property TimezoneStdName: string read FLocalTimezoneStd;
    property Country: string read FLocalCountry;
    property Language: string read FlocalLanguage;
    property CountryEn: string read FEnglishCountry;
    property LanguageEn: string read FEnglishLanguage;
    property TimezoneStandard: TDateTime read FTimezoneStandard;
    property TimezoneDailightSaving: TDateTime read FTimezoneDaylight;
    property Bias: Integer read FTimezoneBias;
    property DailightBias: Integer read FTimezoneDaylightBias;
    property StandardBias: Integer read FTimezoneStandardBias;
    property KeyboardLayouts: TStringList read FKeyboardLayouts;
    property KeyboardLayout: string read GetActiveKeyboardLayout;
  end;

procedure Register;

implementation

(******************************************************************************)
(*
(*  Dashboard Date Utils (TDashboardDateUtils)
(*
(******************************************************************************)
constructor TDashboardDateUtils.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { Create Lists }
  FTimezoneNames   := TStringList.Create;
  FKeyboardLayouts := TStringList.Create;

  { Load }
  LoadTimeZoneNames;
  LoadCurrentTimezone;
  LoadDaylightStandardDates;
  LoadRegionAndLanguage;
end;

destructor TDashboardDateUtils.Destroy;
begin
  { Free Lists }
  FTimezoneNames.Free;
  FKeyboardLayouts.Free;

  inherited Destroy;
end;

function TDashboardDateUtils.GetActiveKeyboardLayout : string;
var
  KLID   : array [0..KL_NAMELENGTH] of Char;
  KLName : array [0..255] of Char;
begin
  Result := '';
  if GetKeyboardLayoutName(KLID) then
  if GetLocaleInfo(StrToInt('$' + StrPas(KLID)), LOCALE_SLANGUAGE, KLName, SizeOf(KLName)) <> 0 then
  begin
    Result := StrPas(KLName);
  end;
end;

procedure TDashboardDateUtils.LoadTimeZoneNames;
var
  SubKeys : TStringList;
  SubKey  : string;
begin
  with TRegistry.Create(KEY_READ) do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones', False) then
    begin
      FTimezoneNames.Clear;
      SubKeys := TStringList.Create;
      try
        GetKeyNames(SubKeys);
        for SubKey in SubKeys do
        begin
          if OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\' + SubKey, False) then
          begin
            if ValueExists('Display') then
            begin
              FTimezoneNames.Add(ReadString('Display'))
            end;
            CloseKey;
          end;
        end;
      finally
        SubKeys.Free;
      end;
      CloseKey;
    end;
  finally
    Free;
  end;
end;

procedure TDashboardDateUtils.LoadCurrentTimezone;
var
  SubKeys  : TStringList;
  SubKey   : string;
  ZoneInfo : TTimeZoneInformation;
begin
  GetTimeZoneInformation(ZoneInfo);
  with TRegistry.Create(KEY_READ) do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones', False) then
    begin
      SubKeys := TStringList.Create;
      try
        GetKeyNames(SubKeys);
        for SubKey in SubKeys do
        begin
          if OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\' + SubKey, False) then
          begin
            if ValueExists('Std') and (AnsiCompareStr(ReadString('Std'), ZoneInfo.StandardName) = 0) then
            begin
              { Set Key }
              FTimeZoneKey := SubKey;
              { Timezone display name as in Windows }
              if ValueExists('Display') then FLocalTimezoneName := ReadString('Display');
              { Timezone daylight saving time name }
              if ValueExists('Dlt') then FLocalTimezoneDLT := ReadString('Dlt');
              { Timezone standard time name }
              if ValueExists('Std') then FLocalTimezoneStd := ReadString('Std');
              { Stop the loop, we found our info }
              Break;
            end;
            CloseKey;
          end;
        end;
      finally
        SubKeys.Free;
      end;
      CloseKey;
    end;
  finally
    Free;
  end;
end;

procedure TDashboardDateUtils.LoadDaylightStandardDates;

  function GetTimeZoneInfo : TTimeZoneInformation;
  var
    Tzi : _REG_TZI_FORMAT;
  begin
    ZeroMemory(@Result, SizeOf(Result));
    with TRegistry.Create(KEY_READ) do try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\' + FTimeZoneKey, False) then
      try
        ReadBinaryData('TZI', Tzi, SizeOf(Tzi));
        with Result do begin
          Bias := Tzi.Bias;
          StandardDate := Tzi.StandardDate;
          StandardBias := Tzi.StandardBias;
          DaylightDate := Tzi.DaylightDate;
          DaylightBias := Tzi.DaylightBias;
        end;
      finally
        CloseKey;
      end;
    finally
      Free;
    end;
  end;

  function GetTimeZoneDate(aTzd: TSystemTime): TDateTime;
  const
    CDayMap: array [0..6] of Word = (7, 1, 2, 3, 4, 5, 6);
  begin
    Result := 0;
    with aTzd do begin
      if TryEncodeDateMonthWeek(YearOf(Now), wMonth, wDay, CDayMap[wDayOfWeek], Result) then
      if MonthOf(Result) <> wMonth then
        Result := IncDay(Result, -7);
      Result := Result + EncodeTime(wHour, wMinute, wSecond, wMilliseconds);
    end;
  end;

var
  TM : TTimeZoneInformation;
begin
  TM := GetTimeZoneInfo;
  FTimezoneStandard     := GetTimeZoneDate(TM.StandardDate);
  FTimezoneDaylight     := GetTimeZoneDate(TM.DaylightDate);
  FTimezoneBias         := TM.Bias;
  FTimezoneDaylightBias := TM.DaylightBias;
  FTimezoneStandardBias := TM.StandardBias;
end;

procedure TDashboardDateUtils.LoadRegionAndLanguage;

  function LocaleInfo(const LCType: Cardinal) : string;
  var
    Res: Cardinal;
  begin
    Res := GetLocaleInfo(GetUserDefaultLCID, LCType, nil, 0);
    SetLength(Result, Res);
    Res := GetLocaleInfo(GetUserDefaultLCID, LCType, PChar(Result), Res);
    if Res = 0 then RaiseLastOSError;
  end;

var
  KLList : array [0..99] of HKL;
  KLName : array [0..255] of Char;
  I      : Integer;
begin
  { System languages }
  FEnglishLanguage := LocaleInfo(LOCALE_SENGLANGUAGE);
  FEnglishCountry  := LocaleInfo(LOCALE_SENGCOUNTRY);
  FLocalCountry    := LocaleInfo(LOCALE_SNATIVECTRYNAME);
  FLocalLanguage   := LocaleInfo(LOCALE_SLANGUAGE);
  { Keyboard layouts }
  FKeyboardLayouts.Clear;
  for I := 0 to GetKeyboardLayoutList(SizeOf(KLList), KLList) - 1 do
  begin
    if GetLocaleInfo(LoWord(KLList[I]), LOCALE_SLANGUAGE, KLName, SizeOf(KLName)) <> 0 then
    FKeyboardLayouts.AddObject(KLname, Pointer(KLList[I]));
  end;
end;

(******************************************************************************)
(*
(*  Register Dashboard Date Utils (TDashboardDateUtils)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns Home Server', [TDashboardDateUtils]);
end;

end.
