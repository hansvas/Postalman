// Copyright (c) 2022, Hans Joerg Vasold
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
unit Postal.PostalMan;

interface
uses System.Generics.Collections,
  Postal.Types,
  Classes;


type TPostalMan = class;

  ///<summary>Will be used by TPostalManXXXValidators </summary>
  TPostalManValidationResult = (
       ///<summary>an invalid address</summary>
       invalid_address,
       ///<summary>the address can not be verified to be correct or not</summary>
       not_sure_if_valid,
       ///<summary>the address is validated and should be ok</summary>
       valid_address,
       ///<summary>the address is valid, some parts are changed, either in
       /// their meaning or in their content</summary>
       valid_adress_but_parts_changed,
       ///<summary>the address is valid but some parts are extended, for example
       /// the gender information or the age build from a first name are added
       /// to the address</summary>
       valid_adress_but_parts_extended,
       ///<summary>the address is valid, some parts are changed, either in
       /// their meaning or in their content, other parts are added for example
       /// the gender information or the age build from a first name are added
       /// to the address</summary>
       valid_adress_but_parts_changed_and_extended);


  TPostalManAdresses = array of TPostalManValues;

  ///</summary>Validators can be used to check the correctness of addresses.
  /// In addition, validators can be used to add or change fields/values in an
  /// address record. For example, longitude and/or latitude, gender and age
  /// (estimated) based on first name.</summary>
  TPostalManAbstractValidator = class(TObject)
  private
   FPostalMan         : TPostalMan;
   FChangedParts      : TPostalManValues;
   FExtendedParts     : TPostalManValues;
   FName              : String;

   FActive            : Boolean;
   FChangesAllowed    : Boolean;
   FExtensionsAllowed : Boolean;
  public
   Constructor Create (aPostalMan : TPostalMan);    virtual;
   Destructor  Destroy;                             override;
   ///<summary>Will be called inside PostalMans method ValidateAddress.</summary>
   function ValidateAddress
      (address : TPostalManValues) : TPostalManValidationResult; virtual; abstract;
  ///<summary>Is the validator allowed to change something ?
  ///  Derived classes should take care of these flas</summary>
  property
   ChangesAllowed : Boolean
    read FChangesAllowed write FChangesAllowed;
  ///<summary>The parts of a address which were changed</summary>
  property
   ChangedParts : TPostalManValues
    read FChangedParts;
  ///<summary>Is the validator allowed to extend something ?
  ///  Derived classes should take care of these flag</summary>
  property
   ExtensionsAllowed : Boolean
    read FExtensionsAllowed write FExtensionsAllowed;
  ///<summary>The parts of a address which were extended</summary>
  property
   ExtendedParts : TPostalManValues
    read FExtendedParts;
  ///<summary> Flag that indicates the use of a validator. Will not be
  ///  used inside the validator.</summary>
  property
   Active : Boolean
    read FActive write FActive;
  //<summary>the Validators name</summary>
  property
   Name : String
    read FName write FName;
  end;

  TPostalManValidatorClass = class of TPostalManAbstractValidator;

  ///<summary>TPostalMan uses libpostal to parse and normalize addresses and
  /// validators to make sure that an address is valid.
  ///</summarize>
  TPostalMan = class(TObject)
  private
    FLanguage                 : AnsiString;
    FCountry                  : AnsiString;
    FMinDistance              : Integer;
    FMappings                 : TPostalManMappings;
    FDuplicates               : TPostalManValues;
    FValidators               : TList<TPostalManAbstractValidator>;

    FDoSetupLanguageClassifier: Boolean;
    FDoSetupParser            : Boolean;
    FClearLists               : Boolean;
    FBreakOnFail              : Boolean;
    FOnlyOne                  : Boolean;

    IsSetup: Boolean;

    procedure setCountry(const Value: AnsiString);
    procedure setLanguage(const Value: AnsiString);
  protected
    function map(input : TPostalManFields) : TPostalManFields;

    function checkValue
      (aAdress, dup : TPostalManValues; equality : Integer) : Boolean;

    function CheckDuplicates
      (aAddress : TPostalManValues; cursor : Integer;
       var Addresses : TPostalManAdresses;
       OverrideAddress : Boolean = True) : Integer;
  public
    ///<summary>Creates an instance of postalman. If you do not use the default
    /// directory (data), you can specify a different directory.
    /// !!! A Call to create may take some seconds !!!</summary>
    Constructor Create
     (Const p: String=''; doSetup: Boolean = True; const dataDir : AnsiString='');
    ///<summary>Frees the memory postalman uses. !!! The teardown process
    /// will be called (if this was not happend before) and will take a while</summary>
    Destructor Destroy; override;
    ///<summary>Walk through the list of validator, and call them if they are
    ///  active. Depending from the status of BreakOnFail addresses can be
    ///  invalid on the fist fail, or valid if just one validator marks them
    ///  as valid</summary>
    function ValidateAddress
      (aAddress : TPostalManValues; var score : Integer) : TPostalManValidationResult;
    ///<summary>Classifies the language of the address, given in a.
    /// This could be a important step in normalization and
    /// parsing of an address</summary>
    function ClassifyLanguage(const a: AnsiString): AnsiString;
    ///<summary>Parse the address, given in a, results are given in
    /// FieldsAndValues. If Options (language and country) are used
    /// the results are limited to results corrosponding to the given
    /// language (and country). Libpostal normally transliterate everything
    /// to lowercase, if you use useOriginal the results will be compared
    /// with the given original string (a) and transformed back - as far
    /// as possible.
    /// Note : Validation will not be used inside this method, use
    /// ParseAddress(string, TPostalManValues... ) instead</summary>
    function ParseAddress(const a: AnsiString; FieldsAndValues: TStringList;
      useOptions: Boolean = False; useOriginal : Boolean = False) : Boolean; overload;
    ///<summary>Parse the address given in a, results are given in
    /// FieldsAndValues. If Options (language and country) are used
    /// the results are limited to results corrosponding to the given
    /// language (and country). Libpostal normally transliterate everything
    /// to lowercase, if you use useOriginal the results will be compared
    /// with the given original string (a) and transformed back if possible.
    ///
    /// This method can use mappings for the meaning of fields, also
    ///  validation is supported</summary>
    function ParseAddress(const a: AnsiString; FieldsAndValues: TPostalManValues;
      useOptions: Boolean = False; useOriginal : Boolean = False) : Boolean; overload;

    ///<summary>Takes a string and return the count of possible addresses. It is
    ///  up to the caller to find out which single address is the correct one.</summary>
    function ExpandAndParseAddress
      (const a: AnsiString; var Addresses : TPostalManAdresses;
        useOptions  : Boolean = False;
        useOriginal : Boolean = False;
        doCheckValues : Boolean = True) : Integer;

    ///<summary>Adds an validator to PostelMan with the name <param>aName</param>
    ///  Each validator must have an unique name and should work a bit different
    ///  than other validators.</summary>
    function AddValidator
      (aValidatorClass : TPostalManValidatorClass; const aName : String) : TPostalManAbstractValidator;

    procedure Setup(const dataDir: AnsiString = '');
    procedure Teardown;

    ///<summary>This is a dictionary of Key,Value pairs where parts of
    /// the current address are not uniquely identified. For each entry, a new
    /// address is constructed where the duplicate value replaces the value in
    /// the "normal" FieldsAndValues. The duplicate values here are given for
    /// information purposes</summary>
    property
     Duplicates : TPostalManValues
      read FDuplicates;
  published
    /// <summary>If ClearLists is true, any lists and dictionary given to
    /// functions ParseAddressXX or ExpandAddressXX as a paramter will
    /// be cleared before use</summary>
    property ClearLists: Boolean read FClearLists write FClearLists;
    /// <summary>You can use Postalman to classify the language of the
    /// address. Is so this property must be true (default)</summary>
    property DoSetupLanguageClassifier: Boolean read FDoSetupLanguageClassifier
      write FDoSetupLanguageClassifier;
    ///<summary>If you want to use Postalman for parsing an address,
    ///  DoSetupParser has to be true (default)</summary>
    property DoSetupParser: Boolean read FDoSetupParser write FDoSetupParser;
    ///<summary>Used for address validation. A address is normally accepted
    ///  as valid, if all validators accept the address as valid. If onlyOne is
    ///  true, a address will be accecpted as valid, even if only one
    ///  validator accept the address as valid (or is not sure)</summary>
    property OnlyOne : Boolean read FOnlyOne write FOnlyOne;
    ///<summary>Mappings can be used to map results from PostalMan to
    /// different meanings. For Example, with a "standard" libpostal,
    /// the person in a persons adress, the householder will be parsed to "house".
    /// with
    /// postalman.Mappings.Add(TPostalManFields.House,TPostalManFields.Name);
    /// you can change this.</summary>
    property Mappings : TPostalManMappings read FMappings;
    ///<summary> used to check addresses against each other, minimum distance
    /// to get recognized as different address</summary>
    property MinDistance : Integer read FMinDistance write FMinDistance;

    property Language: AnsiString read FLanguage write setLanguage;
    property Country : AnsiString read FCountry write setCountry;
  end;

function HasValidator
 (const n : String; aList : TList<TPostalManAbstractValidator>) : TPostalManAbstractValidator;

const
  PostalPath = 'C:\Workbench\libpostal\src\.libs\libpostal-1.dll';

implementation

uses   SysUtils,
  Postal.Header,
  Postal.Strings;

resourcestring

  E_NO_SETUP = 'libpostal:Postalman setup error';
  E_NO_PARSER_SETUP = 'libpostal:Postalman parser setup error';
  E_NO_LANGUAGE_CLASSIFIER_SETUP =
   'libpostal:Postalman language classifier setup failed';

  E_VALIDATOR_ALREADY_EXISTENT =
    'Postlman:Validator with name %s still exists and has a different class';

// --- Tools -------------------------------------------------------------------

{ Searches for the lowercase equivalent of v in a. If any, the result
  is the original case of v}
function ValueFromOriginal
  (const a : AnsiString; const v : String): String;

var p,l    : Integer;
    lw, AA : String;
begin
 lw := Lowercase(a);
 p := Pos(v,lw);
 if p > 0 then
   result := Copy(a,p,Length(v))
 else begin
   // It happens that libpostal changes Ä,Ö,Ü,ß to ae,oe,ue,ß
   // take care of this
   AA := PrepareStrForSim(a);
   lw := Lowercase(aa);
   p := Pos(v,lw);
   if p > 0 then
    result := Copy(aa,p,Length(v))
   else
    result := v;
 end;
end;

function HasValidator
 (const n : String; aList : TList<TPostalManAbstractValidator>) : TPostalManAbstractValidator;
begin
  result := nil;
  for var v in aList do
   if v.Name = n then
    begin
      result := v;
      exit;
    end;
end;

procedure CopyValues(Input, Output : TPostalManValues); inline;
begin
  for var pf in Input do
      Output.Add(pf.Key, pf.Value);
end;

// -----------------------------------------------------------------------------

Constructor TPostalMan.Create
     (Const p: String=''; doSetup: Boolean = True; const dataDir : AnsiString='');
begin

  if (p = '') then
    LoadLibPostal(PostalPath)
  else
    LoadLibPostal(p);

  inherited Create;
  FMappings   := TPostalManMappings.Create;
  FDuplicates := TPostalManValues.Create;

  FMinDistance := 2;
  FLanguage := 'german';
  FCountry  := 'de';

  FDoSetupParser := True;
  FDoSetupLanguageClassifier := True;
  FClearLists := True;
  FValidators :=TList<TPostalManAbstractValidator>.Create;

  IsSetup := False;
  if doSetup then
     Setup(dataDir);
end;

Destructor TPostalMan.Destroy;
begin
  for var i := 0 to FValidators.Count-1 do
      FValidators[i].Free;
  FValidators.Free;

  FDuplicates.Free;
  FMappings.Free;

  Teardown;
  inherited Destroy;
end;

function TPostalMan.map(input : TPostalManFields) : TPostalManFields;
begin
    if not Mappings.TryGetValue(input, result) then
       result := input;
end;


procedure TPostalMan.Setup(const dataDir: AnsiString = '');
begin
  if not IsSetup then
  begin
    if not libpostal_setup() then
      raise Exception.Create(E_NO_SETUP);
    if DoSetupParser and (not libpostal_setup_parser()) then
      raise Exception.Create(E_NO_PARSER_SETUP);
    if DoSetupLanguageClassifier and (not libpostal_setup_language_classifier())
    then
      raise Exception.Create(E_NO_LANGUAGE_CLASSIFIER_SETUP);
    IsSetup := True;
  end;
end;

procedure TPostalMan.Teardown;
begin
  if IsSetup then
  begin
    libpostal_teardown();
    if DoSetupParser then
      libpostal_teardown_parser();
    if DoSetupLanguageClassifier then
      libpostal_teardown_language_classifier;
    IsSetup := False;
  end;
end;

procedure TPostalMan.setCountry(const Value: AnsiString);
begin
  if FCountry <> Value then
  begin
    FCountry := Value;
  end;
end;

procedure TPostalMan.setLanguage(const Value: AnsiString);
begin
  if FLanguage <> Value then
  begin
    FLanguage := Value;
  end;
end;

function TPostalMan.ExpandAndParseAddress
      (const a: AnsiString; var Addresses : TPostalManAdresses;
        useOptions  : Boolean = False;
        useOriginal : Boolean = False;
        doCheckValues : Boolean = True) : Integer;
var options    : libpostal_normalize_options_t ;
    pOptions   : libpostal_address_parser_options_t;
    parsed     : plibpostal_address_parser_response_t;
    expansions : PStrArray;
    n: size_t;
    value, lbl : String;
    field      : TPostalManFields;
    ovrride    : Boolean;
    score      : Integer;
    flg        : array of Boolean;
    reconstruct: Boolean;
    cnt        : Integer;
begin
 options := libpostal_get_default_options();
 result  := 0;

 expansions := libpostal_expand_address(pAnsiChar(UTF8Encode(a)), options, n);

 poptions := libpostal_get_address_parser_default_options();
  if useOptions then
  begin
    poptions.Language := pAnsiChar(FLanguage);
    poptions.country := pAnsiChar(FCountry);
  end;

 SetLength(Addresses, n);
 for var j := 0 to n-1 do
  begin
    parsed := libpostal_parse_address(expansions[j], poptions);
    Duplicates.Clear;

    Addresses[result] := TPostalManValues.Create;
    for var i := 0 to parsed^.num_components - 1 do
    begin
      value := UTF8Decode(parsed^.components[i]);
      if useOriginal then
         value := ValueFromOriginal(a,value);
      lbl   := lowercase(trim(UTF8Decode(parsed^.labels[i])));
      if useOriginal then
        value := ValueFromOriginal(a,value);
      if lbl = 'house' then Field := Map(house) else
      if lbl = 'category' then  Field := Map(category) else
      if lbl = 'near' then  Field := Map(Near) else
      if lbl = 'house_number' then Field := Map(house_number) else
      if lbl = 'road' then Field := Map(road) else
      if lbl = 'unit' then Field := Map(Unt) else
      if lbl = 'level' then Field := Map(Level) else
      if lbl = 'staircase' then Field := Map(staircase)else
      if lbl = 'entrance' then Field := Map(entrance) else
      if lbl = 'po_box' then Field := Map(po_box) else
      if lbl = 'postcode' then Field := Map(postcode) else
      if lbl = 'suburb' then Field := Map(suburb) else
      if lbl = 'city_district' then Field := Map(city_district) else
      if lbl = 'city' then Field := Map(city) else
      if lbl = 'island' then Field := Map(island) else
      if lbl = 'state_district' then Field := Map(state_district) else
      if lbl = 'state' then Field := Map(state) else
      if lbl = 'country_region' then Field := Map(country_region) else
      if lbl = 'world_region' then Field := Map(world_region) else
      if lbl = 'country' then Field := Map(TPostalManFields.country)
                         else Field := Map(anything_else);
      try
        Addresses[result].Add(Field,value);
      except
        Duplicates.Add(Field,Value);
      end;
    end;

    case ValidateAddress(Addresses[result], score) of
     invalid_address   : ovrride := True;

     not_sure_if_valid,
     valid_address,
     valid_adress_but_parts_changed,
     valid_adress_but_parts_extended,
     valid_adress_but_parts_changed_and_extended : begin
       inc(result);
       ovrride := False;
     end;
    end;

    // There is more than one possibility
    if Duplicates.Count > 0 then
     if ovrride then
        result := result +
          CheckDuplicates(Addresses[result], result,  Addresses, ovrride)
     else
        result := result +
          CheckDuplicates(Addresses[result-1], result, Addresses, ovrride);

    libpostal_address_parser_response_destroy(parsed);
  end;

  if DoCheckValues and (result > 1) then
     begin
      reconstruct := False;
      SetLength(flg, result);
      for var i := 0 to result - 1  do
      begin
       flg[i] := False;
       for var j := 0 to result - 1 do
        if (i <> j) and not Flg[i] then
          flg[i] := not checkValue(Addresses[i], Addresses[j], MinDistance);
        reconstruct := reconstruct or (not flg[i]);
      end;

      cnt:= result;
      if reconstruct then
       for var i := cnt -1 downto 0 do
        begin
          if not flg[i] then
          begin
            Addresses[i].Free;
            for var j := i to cnt-2 do
            begin
              Addresses[j] := Addresses[j+1];
              Addresses[j+1] := nil;
            end;
            dec(result);
            // the last one is not a duplicate; it is the original
            if result = 1 then
               break;
          end;
        end;
     end;

  SetLength(Addresses, result);
  libpostal_expansion_array_destroy(expansions, n);
end;

function TPostalMan.ParseAddress
  (const a: AnsiString; FieldsAndValues: TStringList;
    useOptions: Boolean = False; useOriginal : Boolean = False) : Boolean;
var
  options: libpostal_address_parser_options_t;
  parsed: plibpostal_address_parser_response_t;
  value : String;
  cnt   : Integer;
begin
  if not IsSetup then    raise Exception.Create(E_NO_SETUP);

  options := libpostal_get_address_parser_default_options();
  if useOptions then
  begin
    options.Language := pAnsiChar(FLanguage);
    options.country  := pAnsiChar(FCountry);
  end;
  parsed := libpostal_parse_address(pAnsiChar(UTF8Encode(a)), options);
  if ClearLists then
    FieldsAndValues.Clear;
  cnt := FieldsAndValues.Count;
  for var i := 0 to parsed^.num_components - 1 do
  begin
    value := UTF8Decode(parsed^.components[i]);
    if useOriginal then
       value := ValueFromOriginal(a,value);
    FieldsAndValues.add(UTF8Decode(parsed^.labels[i]) + '=' + value);
  end;
  result := FieldsAndValues.Count > cnt;
  libpostal_address_parser_response_destroy(parsed);
end;

function TPostalMan.ParseAddress
 (const a: AnsiString; FieldsAndValues: TPostalManValues;
  useOptions: Boolean = False; useOriginal : Boolean = False) : Boolean;

var
  options: libpostal_address_parser_options_t;
  parsed: plibpostal_address_parser_response_t;
  lbl, value: String;
  field : TPostalManFields;
  Addresses : TPostalManAdresses;
  score : Integer;
begin
  if not IsSetup then
    raise Exception.Create(E_NO_SETUP);

  options := libpostal_get_address_parser_default_options();
  if useOptions then
  begin
    options.Language := pAnsiChar(FLanguage);
    options.country := pAnsiChar(FCountry);
  end;
  parsed := libpostal_parse_address(pAnsiChar(UTF8Encode(a)), options);
  try
   if ClearLists then
     FieldsAndValues.Clear;
   Duplicates.Clear;
   for var i := 0 to parsed^.num_components - 1 do
   begin
     lbl   := lowercase(trim(UTF8Decode(parsed^.labels[i])));
     if lbl = 'house' then Field := Map(House) else
     if lbl = 'category' then  Field := Map(Category) else
     if lbl = 'near' then  Field := Map(Near) else
     if lbl = 'house_number' then Field := Map(house_number) else
     if lbl = 'road' then Field := Map(Road) else
     if lbl = 'unit' then Field := Map(Unt) else
     if lbl = 'level' then Field := Map(Level) else
     if lbl = 'staircase' then Field := Map(staircase)else
     if lbl = 'entrance' then Field := Map(entrance) else
     if lbl = 'po_box' then Field := Map(po_box) else
     if lbl = 'postcode' then Field := Map(postcode) else
     if lbl = 'suburb' then Field := Map(suburb) else
     if lbl = 'city_district' then Field := Map(city_district) else
     if lbl = 'city' then Field := Map(city) else
     if lbl = 'island' then Field := Map(island) else
     if lbl = 'state_district' then Field := Map(state_district) else
     if lbl = 'state' then Field := Map(state) else
     if lbl = 'country_region' then Field := Map(country_region) else
     if lbl = 'world_region' then Field := Map(world_region) else
     if lbl = 'country' then Field := Map(TPostalManFields.country)
                        else Field := Map(anything_else);
     value := UTF8Decode(parsed^.components[i]);
     if useOriginal then
        value := ValueFromOriginal(a,value);
     try
       FieldsAndValues.Add(Field,value);
     except
       Duplicates.Add(Field,Value);
     end;
   end;

   result := False;
   if (ValidateAddress(FieldsAndValues, score) = invalid_address) then
   begin
    if (duplicates.Count > 0) then
    begin
     // if the address is invalid, check if there are duplicate fields,
     // replace the fields with the duplicate values and check the
     // address again, give it a try
     try
      if checkDuplicates(FieldsAndValues,0,Addresses,False) > 0 then
      begin
       FieldsAndValues.Clear;
       for var i  := 0 to Length(Addresses)-1 do
         for var fld in Addresses[0] do begin
           FieldsAndValues.Add(fld.Key,fld.Value);
           if (ValidateAddress(FieldsAndValues, score) <> invalid_address) then
            begin
              result := True;
              break;
            end;
         end;
       end;
     finally
      for var i  := 0 to Length(Addresses)-1 do
       if Assigned(Addresses[i]) then
          Addresses[i].Free;
      SetLength(Addresses,0);
      end;
     end
    end else
    result := True;

  finally
    libpostal_address_parser_response_destroy(parsed);
  end;
end;

function TPostalMan.ClassifyLanguage(const a: AnsiString): AnsiString;
var
  languages: Plibpostal_language_classifier_response_t;
  probs: pDouble;
  max: Double;
begin
  if not IsSetup then
    raise Exception.Create(E_NO_SETUP);
  result := '';
  languages := libpostal_classify_language(pAnsiChar(UTF8Encode(a)));
  if Assigned(languages) then
  begin
    max := 0;
    probs := languages.probs;
    for var i := 0 to languages.num_languages - 1 do
    begin
      if probs^ >= max then
      begin
        max := probs^;
        result := UTF8Decode(languages^.languages[i]);
      end;
      inc(probs);
    end;
    libpostal_language_classifier_response_destroy(languages);
  end;
end;

function TPostalMan.AddValidator
      (aValidatorClass : TPostalManValidatorClass; const aName : String) : TPostalManAbstractValidator;
begin
  result := HasValidator(aName, FValidators);
  if Assigned(result) then
   begin
    if result.ClassType <> aValidatorClass then
      raise Exception.Create(Format(E_VALIDATOR_ALREADY_EXISTENT, [aName]));
   end else
   begin
     result := aValidatorClass.Create(self);
     result.Name := aName;
     FValidators.Add(result);
   end;
end;

function TPostalMan.ValidateAddress
  (aAddress : TPostalManValues; var score : Integer) : TPostalManValidationResult;

var     r : TPostalManValidationResult;
 invalids : Integer;
 valids   : Integer;
 changed  : Integer;
 extended : Integer;
 valid_max: Integer;
begin
 result := valid_address;
 // nothing to test ?
 if FValidators.Count = 0 then
    exit;
 invalids := 0;
 valids   := 0;
 changed  := 0;
 extended := 0;
 valid_max:= 0;
 score    := 0;

 for var validator in FValidators do
 if validator.active then
  begin
   r := validator.ValidateAddress(aAddress);
   case r of
    invalid_address                 : begin
     if not OnlyOne then
      begin
        result := invalid_address;
        exit;
      end else
      inc(invalids);
      dec(score);
    end;

    not_sure_if_valid               : begin
      // increase valids but not the score
      inc(valid_max);
      inc(valids);
    end;
    valid_address                   : begin
      inc(valids);
      inc(score);
    end;
    valid_adress_but_parts_changed  : begin
      inc(valids);
      inc(changed);
      inc(score);
    end;
    valid_adress_but_parts_extended : begin
      inc(valids);
      inc(extended);
      inc(score);
    end;
    valid_adress_but_parts_changed_and_extended : begin
      inc(valids);
      inc(changed);
      inc(extended);
      inc(score);
    end;
   end;
  end;

 if (invalids > 0) then
  if (FValidators.Count = 1) or (not OnlyOne) then
    begin
      result := invalid_address;
      exit;
    end;

 if valids < valid_max then
    begin
      result := invalid_address;
      exit;
    end;

 if (changed>0) and (extended>0) then
     result := valid_adress_but_parts_changed_and_extended else
 if (changed>0) then
     result := valid_adress_but_parts_changed else
 if (extended>0) then
     result := valid_adress_but_parts_extended;
end;

function TPostalMan.checkValue
      (aAdress, dup : TPostalManValues; equality : Integer) : Boolean;
var sum : Integer;
    s : String;
begin
 sum    := 0;
 for var p  in aAdress do
  begin
   if dup.TryGetValue(p.Key,s) then
      sum := sum + HammingDist(p.Value,s);
  end;
 result := (sum <= equality);
end;

function TPostalMan.CheckDuplicates
      (aAddress : TPostalManValues;
      cursor : Integer;
       var Addresses : TPostalManAdresses;
       OverrideAddress : Boolean = True) : Integer;
var         tmp : TPostalManValues;
  current, best,c : Integer;
  bestValues    : TPostalManValues;
            lst : TList<TPostalManValues>;
begin
 result := 0;
 best := -9999;

 if duplicates.Count > 0 then
  begin
    tmp        := TPostalManValues.Create;
    bestValues := TPostalManValues.Create;
    lst := TList<TPostalManValues>.Create;
    try
     for var dup in Duplicates do
      begin
       tmp.Clear;
       CopyValues(aAddress, tmp);
       tmp.AddOrSetValue(dup.Key,dup.Value);
       if ValidateAddress(tmp, current) <> invalid_address then
        // aAddress should be already validated, if this is the case
        // even if tmp is valid, if the distance to aAddress is small
        // it is very likely that tmp is a duplicate
        if not checkValue(aAddress, tmp, minDistance) then
         begin
          if (best < current) then
           begin
             CopyValues(tmp, bestValues);
             best := current;
           end;
           lst.Add(tmp);
           tmp := TPostalManValues.Create;
         end;
      end;

    if OverrideAddress then
     begin
      if best >= 0 then
         Addresses[cursor] := bestValues;
      result := 1;
      // Nebeneffekt, führt zur Freigabe von p in lst
      exit;
     end;

    result := lst.count;
    SetLength(Addresses, Length(Addresses) + result);

    if Length(Addresses) = result then
       c := 0
    else
       c := cursor;

    for var p in lst do
     begin
        Addresses[c] := p;
        inc(c);
     end;
    lst.Clear;

    finally
     tmp.Free;
     for var p in lst do
      p.free;
     lst.Free;
    end;
  end;
end;

// -----------------------------------------------------------------------------

Constructor TPostalManAbstractValidator.Create (aPostalMan : TPostalMan);
begin
  inherited Create;
  FPostalMan         := aPostalMan;
  FChangedParts      := TPostalManValues.Create;
  FExtendedParts     := TPostalManValues.Create;

  FActive            := True;
  FChangesAllowed    := True;
  FExtensionsAllowed := True;
end;

Destructor  TPostalManAbstractValidator.Destroy;
begin
  FChangedParts.free;
  FExtendedParts.free;
  inherited Destroy;
end;

end.
