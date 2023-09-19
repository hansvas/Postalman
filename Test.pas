unit Test;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  Postal.Types,
  Postal.Nominatim,
  Postal.PostalMan;

type

 ITempCursor = interface(IInterface)
  ['{18784949-1AEF-4C50-9E15-9483203DE7CD}']
  end;

  TTempCursor = class(TInterfacedObject, ITempCursor)
  strict private
    FCursor: TCursor;
  public
    constructor Create(const ACursor: TCursor);
    destructor Destroy; override;
    class function SetTempCursor(const ACursor: TCursor = crHourGlass): ITempCursor;
  end;


  TPostalTester = class(TForm)
    BtnParse: TButton;
    cbLanguage: TCheckBox;
    cbClearLists: TCheckBox;
    cbOneValidator: TCheckBox;
    Label1: TLabel;
    EdHouse: TEdit;
    M: TMemo;
    EdAddress: TComboBox;
    CbOriginal: TCheckBox;
    Label2: TLabel;
    EdRoad: TEdit;
    EdHouseNumber: TEdit;
    EdPostcode: TEdit;
    EdTown: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EdLanguage: TEdit;
    CbParseAddress: TCheckBox;
    CbExpandAndParseAddress: TCheckBox;
    cbUseValidator: TCheckBox;
    rbStrings: TRadioButton;
    rbValues: TRadioButton;
    EdLibpostal: TEdit;
    Label5: TLabel;
    BtnLoadLibpostal: TButton;
    Label6: TLabel;
    EdDataDir: TEdit;
    Label7: TLabel;
    CbxValidation: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnLoadLibpostalClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    Postal: TPostalMan;
    Nom: TNominatimValidator;
  public
    { Public-Deklarationen }
    IsLoaded : Boolean;

    procedure LoadPostal;
  end;

var
  PostalTester: TPostalTester;

implementation
uses TypInfo;

{$R *.dfm}

{ TTempCursor }
constructor TTempCursor.Create(const ACursor: TCursor);
begin
  inherited Create();
  FCursor := Screen.Cursor;
  Screen.Cursor := ACursor;
end;

destructor TTempCursor.Destroy;
begin
  if Assigned(Screen) then
    Screen.Cursor := FCursor;
  inherited Destroy();
end;

class function TTempCursor.SetTempCursor(const ACursor: TCursor = crHourGlass): ITempCursor;
begin
  Result := TTempCursor.Create(ACursor);
end;

type TEnumConverter = class
public
  class function EnumToInt<T>(const EnumValue: T): Integer;
  class function EnumToString<T>(EnumValue: T): string;
end;

class function TEnumConverter.EnumToInt<T>(const EnumValue: T): Integer;
begin
  Result := 0;
  Move(EnumValue, Result, sizeOf(EnumValue));
end;

class function TEnumConverter.EnumToString<T>(EnumValue: T): string;
begin
  Result := GetEnumName(TypeInfo(T), EnumToInt(EnumValue));
end;

// -----------------------------------------------------------------------------

procedure TPostalTester.LoadPostal;
begin
  Postal := TPostalMan.Create
     (EdLibPostal.Text, True, EdDataDir.Text);
  Postal.Language := 'de';
  Postal.country := 'germany';
  // Often (in german Addresses)city_district will be identified
  // as state district, which is wrong. This line corrects this

  // probalbly later i will add language specific mappings
  Postal.Mappings.Add(state_district, city_district);
end;

procedure TPostalTester.BtnLoadLibpostalClick(Sender: TObject);
begin
 TTempCursor.SetTempCursor;
 LoadPostal;
 IsLoaded := True;
 BtnParse.SetFocus;
end;

procedure TPostalTester.Button1Click(Sender: TObject);

  procedure SetEditsFromDict(d: TPostalManValues);
  var
    s: String;
  begin
    if d.TryGetValue(House, s) then
      EdHouse.Text := s
    else
      EdHouse.Text := '';
    if d.TryGetValue(Road, s) then
      EdRoad.Text := s
    else
      EdRoad.Text := '';
    if d.TryGetValue(house_number, s) then
      EdHouseNumber.Text := s
    else
      EdHouseNumber.Text := '';
    if d.TryGetValue(postcode, s) then
      EdPostcode.Text := s
    else
      EdPostcode.Text := '';
    if d.TryGetValue(city, s) then
      EdTown.Text := s
    else
      EdTown.Text := '';
  end;

  procedure SetEditsFromStrings(FieldsAndValues: TStrings);
  begin
    EdHouse.Text := FieldsAndValues.Values['house'];
    EdHouseNumber.Text := FieldsAndValues.Values['housenumber'];
    EdRoad.Text := FieldsAndValues.Values['road'];
    EdPostcode.Text := FieldsAndValues.Values['postcode'];
    EdTown.Text := Trim(FieldsAndValues.Values['city'] + ' ' +
      FieldsAndValues.Values['city_district']);
  end;

  procedure WriteDict(d: TPostalManValues);
  begin
    for var p in d do
      M.Lines.Add(TEnumConverter.EnumToString(p.Key) +':' + p.Value);
  end;

var
  FldAndVal: TStringList;
  FldDict  : TPostalManValues;
  Addresses: TPostalManAdresses;
  cnt: Integer;

  valid : Boolean;

begin

  if not IsLoaded then
  begin
   MessageDlg('load libpostal first', mtWarning, [mbOK], 0);
   exit;
  end;

  if EdAddress.Text = '' then
   begin
     MessageDlg('address is needed', mtWarning, [mbOK], 0);
     exit;
   end;

  M.Lines.Clear;

  Postal.ClearLists := cbClearLists.Checked;
  Postal.OnlyOne := cbOneValidator.Checked;

  if (cbUseValidator.Checked) then
  begin
    // defined in Postal.nomanitim
    // In a commercial application, you can host your own instance of
    // nominatim. The url given here is only for testing and should be
    // changed
    NominatimBaseURL := 'https://nominatim.openstreetmap.org';
    Nom := Postal.AddValidator(TNominatimValidator, 'Nomatest')
            as TNominatimValidator;
    Nom.ExtensionsAllowed := True;
    Nom.ChangesAllowed    := True;
    Nom.Active := True;
  end ;

 if Assigned(Nom) then
 begin
     Nom.Active := CbUseValidator.Checked;
     case CbxValidation.ItemIndex of
      0 : nom.ResultIfFailed := invalid_address;
      1 : nom.ResultIfFailed := not_sure_if_valid;
      2:  nom.ResultIfFailed := valid_address;
     end;
 end;


  if CbParseAddress.Checked then
  begin

    if rbStrings.Checked then
    begin
      fldAndVal := TStringList.Create;
      try
       valid := Postal.ParseAddress
          (edAddress.Text, fldAndVal, True, CbOriginal.Checked);
       if not valid then
           M.Lines.Add(' INVALID * INVALID * INVALID * INVALID * INVALID ');
       if cbLanguage.Checked then
        begin
          EdLanguage.Text := Postal.ClassifyLanguage( edAddress.Text);
          M.Lines.Add('Language :' + EdLanguage.Text);
        end;
        SetEditsFromStrings(FldAndVal);
        M.Lines.Add(edAddress.Text);
        M.Lines.AddStrings(FldAndVal);
      finally
        FldAndVal.Free;
      end;
    end;

    if rbValues.Checked then
    begin
      FldDict := TPostalManValues.Create;
      try
        valid := Postal.ParseAddress
          (edAddress.Text, FldDict, True, CbOriginal.Checked);
        if not valid then
           M.Lines.Add(' INVALID * INVALID * INVALID * INVALID * INVALID ');
        if cbLanguage.Checked then
        begin
          EdLanguage.Text := Postal.ClassifyLanguage(edAddress.Text);
          M.Lines.Add('Language :' + EdLanguage.Text);
        end;
        SetEditsFromDict(FldDict);
        WriteDict(FldDict);
        if (Postal.Duplicates.Count > 0) then
        begin
          M.Lines.Add('####  Duplicates ####');
          WriteDict(Postal.Duplicates);
          M.Lines.Add('#####################');
        end;
      finally
        FldDict.Free;
      end;
    end;
  end;

 if Assigned(Nom) and
    (nom.Active) then
 begin
  if nom.ExtendedParts.Count > 0 then
   begin
     M.Lines.Add('####  Extended ####');
     WriteDict(nom.ExtendedParts);
     M.Lines.Add('#####################');
   end;

  if nom.ChangedParts.Count > 0 then
   begin
     M.Lines.Add('####  Changed ####');
     WriteDict(nom.ChangedParts);
     M.Lines.Add('#####################');
   end;

 end;

  if CbExpandAndParseAddress.Checked then
  begin
    cnt := Postal.ExpandAndParseAddress(edAddress.Text, Addresses, True,
      CbOriginal.Checked, True);
    if cnt > 0 then
    begin
      M.Lines.Add('-------------------------------------------------');
      M.Lines.Add('Anzahl: ' + IntToStr(cnt));
      for var j := 0 to cnt - 1 do
      begin
        WriteDict(Addresses[j]);
        M.Lines.Add('-------------------------------------------------');
        Addresses[j].Free;
      end;
    end;
    SetLength(Addresses, 0);
  end;

end;

procedure TPostalTester.FormActivate(Sender: TObject);
begin
  BtnLoadLibpostal.SetFocus;
end;

procedure TPostalTester.FormCreate(Sender: TObject);
begin
  IsLoaded := False;
  EdAddress.ItemIndex := 1;
end;

procedure TPostalTester.FormDestroy(Sender: TObject);
begin
 if isLoaded then
    Postal.Free;
end;

end.
