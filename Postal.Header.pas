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
unit postal.Header;

interface

const
  LIBPOSTAL_TOKEN_TYPE_END = 0; // Null byte
  // Word types
  LIBPOSTAL_TOKEN_TYPE_WORD = 1;
  // Any letter-only word (includes all unicode letters)
  LIBPOSTAL_TOKEN_TYPE_ABBREVIATION = 2;
  // Loose abbreviations (roughly anything containing a "." as we don't care about sentences in addresses)
  LIBPOSTAL_TOKEN_TYPE_IDEOGRAPHIC_CHAR = 3;
  // For languages that don't separate on whitespace (e.g. Chinese; Japanese; Korean); separate by character
  LIBPOSTAL_TOKEN_TYPE_HANGUL_SYLLABLE = 4;
  // Hangul syllable sequences which contain more than one codepoint
  LIBPOSTAL_TOKEN_TYPE_ACRONYM = 5;
  // Specifically things like U.N. where we may delete internal periods

  LIBPOSTAL_TOKEN_TYPE_PHRASE = 10;
  // Not part of the first stage tokenizer; but may be used after phrase parsing

  // Special tokens
  LIBPOSTAL_TOKEN_TYPE_EMAIL = 20; // Make sure emails are tokenized altogether
  LIBPOSTAL_TOKEN_TYPE_URL = 21; // Make sure urls are tokenized altogether
  LIBPOSTAL_TOKEN_TYPE_US_PHONE = 22;
  // US phone number (with or without country code)
  LIBPOSTAL_TOKEN_TYPE_INTL_PHONE = 23;
  // A non-US phone number (must have country code)

  // Numbers and numeric types
  LIBPOSTAL_TOKEN_TYPE_NUMERIC = 50; // Any sequence containing a digit
  LIBPOSTAL_TOKEN_TYPE_ORDINAL = 51; // 1st; 2nd; 1er; 1 etc.
  LIBPOSTAL_TOKEN_TYPE_ROMAN_NUMERAL = 52; // II; III; VI; etc.
  LIBPOSTAL_TOKEN_TYPE_IDEOGRAPHIC_NUMBER = 53;
  // All numeric ideographic characters; includes e.g. Han numbers and chars like "²"

  // Punctuation types; may separate a phrase
  LIBPOSTAL_TOKEN_TYPE_PERIOD = 100;
  LIBPOSTAL_TOKEN_TYPE_EXCLAMATION = 101;
  LIBPOSTAL_TOKEN_TYPE_QUESTION_MARK = 102;
  LIBPOSTAL_TOKEN_TYPE_COMMA = 103;
  LIBPOSTAL_TOKEN_TYPE_COLON = 104;
  LIBPOSTAL_TOKEN_TYPE_SEMICOLON = 105;
  LIBPOSTAL_TOKEN_TYPE_PLUS = 106;
  LIBPOSTAL_TOKEN_TYPE_AMPERSAND = 107;
  LIBPOSTAL_TOKEN_TYPE_AT_SIGN = 108;
  LIBPOSTAL_TOKEN_TYPE_POUND = 109;
  LIBPOSTAL_TOKEN_TYPE_ELLIPSIS = 110;
  LIBPOSTAL_TOKEN_TYPE_DASH = 111;
  LIBPOSTAL_TOKEN_TYPE_BREAKING_DASH = 112;
  LIBPOSTAL_TOKEN_TYPE_HYPHEN = 113;
  LIBPOSTAL_TOKEN_TYPE_PUNCT_OPEN = 114;
  LIBPOSTAL_TOKEN_TYPE_PUNCT_CLOSE = 115;
  LIBPOSTAL_TOKEN_TYPE_DOUBLE_QUOTE = 119;
  LIBPOSTAL_TOKEN_TYPE_SINGLE_QUOTE = 120;
  LIBPOSTAL_TOKEN_TYPE_OPEN_QUOTE = 121;
  LIBPOSTAL_TOKEN_TYPE_CLOSE_QUOTE = 122;
  LIBPOSTAL_TOKEN_TYPE_SLASH = 124;
  LIBPOSTAL_TOKEN_TYPE_BACKSLASH = 125;
  LIBPOSTAL_TOKEN_TYPE_GREATER_THAN = 126;
  LIBPOSTAL_TOKEN_TYPE_LESS_THAN = 127;

  // Non-letters and whitespace
  LIBPOSTAL_TOKEN_TYPE_OTHER = 200;
  LIBPOSTAL_TOKEN_TYPE_WHITESPACE = 300;
  LIBPOSTAL_TOKEN_TYPE_NEWLINE = 301;

  LIBPOSTAL_TOKEN_TYPE_INVALID_CHAR = 500;

  { LIBPOSTAL_NULL_DUPLICATE_STATUS = -1;
    LIBPOSTAL_NON_DUPLICATE = 0;
    LIBPOSTAL_POSSIBLE_DUPLICATE_NEEDS_REVIEW = 3;
    LIBPOSTAL_LIKELY_DUPLICATE = 6;
    LIBPOSTAL_EXACT_DUPLICATE = 9; }
  // libpostal_duplicate_status_t

  // Bit set, should be able to keep it at a short (uint16_t)
  // #define LIBPOSTAL_ADDRESS_NONE 0
  // #define LIBPOSTAL_ADDRESS_ANY (1 << 0)
  // #define LIBPOSTAL_ADDRESS_NAME (1 << 1)
  // #define LIBPOSTAL_ADDRESS_HOUSE_NUMBER (1 << 2)
  // #define LIBPOSTAL_ADDRESS_STREET (1 << 3)
  // #define LIBPOSTAL_ADDRESS_UNIT (1 << 4)
  // #define LIBPOSTAL_ADDRESS_LEVEL (1 << 5)
  // #define LIBPOSTAL_ADDRESS_STAIRCASE (1 << 6)
  // #define LIBPOSTAL_ADDRESS_ENTRANCE (1 << 7)

  // #define LIBPOSTAL_ADDRESS_CATEGORY (1 << 8)
  // #define LIBPOSTAL_ADDRESS_NEAR (1 << 9)

  // #define LIBPOSTAL_ADDRESS_TOPONYM (1 << 13)
  // #define LIBPOSTAL_ADDRESS_POSTAL_CODE (1 << 14)
  // #define LIBPOSTAL_ADDRESS_PO_BOX (1 << 15)
  // #define LIBPOSTAL_ADDRESS_ALL ((1 << 16) - 1)

type

  libpostal_duplicate_status_t = (LIBPOSTAL_NULL_DUPLICATE_STATUS = -1,
    LIBPOSTAL_NON_DUPLICATE = 0, LIBPOSTAL_POSSIBLE_DUPLICATE_NEEDS_REVIEW = 3,
    LIBPOSTAL_LIKELY_DUPLICATE = 6, LIBPOSTAL_EXACT_DUPLICATE = 9);

  bool = ByteBool;
  size_t = NativeUInt;
  uint64_t = UInt64;

  PPChar = ^PAnsiChar;

  TStrArray = array [0 .. 1000] of PAnsiChar;
  PStrArray = ^TStrArray;

  libpostal_normalize_options_t = packed record
    // List of language codes
    languages: PStrArray;
    num_languages: NativeUInt; // size_t
    address_components: Word; // uint16_t;

    // String options
    latin_ascii: bool;
    transliterate: bool;
    strip_accents: bool;
    decompose: bool;
    lowercase: bool;
    trim_string: bool;
    drop_parentheticals: bool;
    replace_numeric_hyphens: bool;
    delete_numeric_hyphens: bool;
    split_alpha_from_numeric: bool;
    replace_word_hyphens: bool;
    delete_word_hyphens: bool;
    delete_final_periods: bool;
    delete_acronym_periods: bool;
    drop_english_possessives: bool;
    delete_apostrophes: bool;
    expand_numex: bool;
    roman_numerals: bool;
  end;

  // Address parser

  libpostal_address_parser_response_t = packed record
    num_components: NativeUInt;
    components: PStrArray; // PStrArray;
    labels: PStrArray; // PStrArray;
  end;


  // typedef libpostal_address_parser_response_t
  // libpostal_parsed_address_components_t;

  libpostal_address_parser_options_t = packed record
    language: PAnsiChar;
    country: PAnsiChar;
  end;

  libpostal_language_classifier_response_t = packed record
    num_languages: NativeUInt;
    languages: PStrArray;
    probs: pDouble;
  end;

  // Near-dupe hashing methods
  libpostal_near_dupe_hash_options_t = packed record
    with_name: bool;
    with_address: bool;
    with_unit: bool;
    with_city_or_equivalent: bool;
    with_small_containing_boundaries: bool;
    with_postal_code: bool;
    with_latlon: bool;
    latitude: double;
    longitude: double;
    geohash_precision: LongWord; // uint32_t
    name_and_address_keys: bool;
    name_only_keys: bool;
    address_only_keys: bool;
  end;

  libpostal_duplicate_options_t = packed record
    num_languages: NativeUInt;
    languages: PStrArray;
  end;

  libpostal_fuzzy_duplicate_options_t = packed record
    num_languages: NativeUInt;
    languages: PStrArray;
    needs_review_threshold: double;
    likely_dupe_threshold: double;
  end;

  libpostal_fuzzy_duplicate_status_t = packed record
    status: libpostal_duplicate_status_t;
    similarity: double;
  end;

  libpostal_token_t = packed record
    offset: NativeUInt;
    len: NativeUInt;
    tpe: Word; // uint16_t
  end;

  libpostal_normalized_token_t = packed record
    str: PStrArray;
    token: libpostal_token_t;
  end;

  Plibpostal_address_parser_response_t = ^libpostal_address_parser_response_t;
  Plibpostal_language_classifier_response_t = ^
    libpostal_language_classifier_response_t;
  Plibpostal_token_t = ^libpostal_token_t;
  Plibpostal_normalized_token_t = ^libpostal_normalized_token_t;

  (* // Normalize string options
    #define LIBPOSTAL_NORMALIZE_STRING_LATIN_ASCII 1 << 0
    #define LIBPOSTAL_NORMALIZE_STRING_TRANSLITERATE 1 << 1
    #define LIBPOSTAL_NORMALIZE_STRING_STRIP_ACCENTS 1 << 2
    #define LIBPOSTAL_NORMALIZE_STRING_DECOMPOSE 1 << 3
    #define LIBPOSTAL_NORMALIZE_STRING_LOWERCASE 1 << 4
    #define LIBPOSTAL_NORMALIZE_STRING_TRIM 1 << 5
    #define LIBPOSTAL_NORMALIZE_STRING_REPLACE_HYPHENS 1 << 6
    #define LIBPOSTAL_NORMALIZE_STRING_COMPOSE 1 << 7
    #define LIBPOSTAL_NORMALIZE_STRING_SIMPLE_LATIN_ASCII 1 << 8
    #define LIBPOSTAL_NORMALIZE_STRING_REPLACE_NUMEX 1 << 9

    // Normalize token options
    #define LIBPOSTAL_NORMALIZE_TOKEN_REPLACE_HYPHENS 1 << 0
    #define LIBPOSTAL_NORMALIZE_TOKEN_DELETE_HYPHENS 1 << 1
    #define LIBPOSTAL_NORMALIZE_TOKEN_DELETE_FINAL_PERIOD 1 << 2
    #define LIBPOSTAL_NORMALIZE_TOKEN_DELETE_ACRONYM_PERIODS 1 << 3
    #define LIBPOSTAL_NORMALIZE_TOKEN_DROP_ENGLISH_POSSESSIVES 1 << 4
    #define LIBPOSTAL_NORMALIZE_TOKEN_DELETE_OTHER_APOSTROPHE 1 << 5
    #define LIBPOSTAL_NORMALIZE_TOKEN_SPLIT_ALPHA_FROM_NUMERIC 1 << 6
    #define LIBPOSTAL_NORMALIZE_TOKEN_REPLACE_DIGITS 1 << 7
    #define LIBPOSTAL_NORMALIZE_TOKEN_REPLACE_NUMERIC_TOKEN_LETTERS 1 << 8
    #define LIBPOSTAL_NORMALIZE_TOKEN_REPLACE_NUMERIC_HYPHENS 1 << 9

    #define LIBPOSTAL_NORMALIZE_DEFAULT_STRING_OPTIONS (LIBPOSTAL_NORMALIZE_STRING_LATIN_ASCII | LIBPOSTAL_NORMALIZE_STRING_COMPOSE | LIBPOSTAL_NORMALIZE_STRING_TRIM | LIBPOSTAL_NORMALIZE_STRING_REPLACE_HYPHENS | LIBPOSTAL_NORMALIZE_STRING_STRIP_ACCENTS | LIBPOSTAL_NORMALIZE_STRING_LOWERCASE)
    #define LIBPOSTAL_NORMALIZE_DEFAULT_TOKEN_OPTIONS (LIBPOSTAL_NORMALIZE_TOKEN_REPLACE_HYPHENS | LIBPOSTAL_NORMALIZE_TOKEN_DELETE_FINAL_PERIOD | LIBPOSTAL_NORMALIZE_TOKEN_DELETE_ACRONYM_PERIODS | LIBPOSTAL_NORMALIZE_TOKEN_DROP_ENGLISH_POSSESSIVES | LIBPOSTAL_NORMALIZE_TOKEN_DELETE_OTHER_APOSTROPHE)
    #define LIBPOSTAL_NORMALIZE_TOKEN_OPTIONS_DROP_PERIODS (LIBPOSTAL_NORMALIZE_TOKEN_DELETE_FINAL_PERIOD | LIBPOSTAL_NORMALIZE_TOKEN_DELETE_ACRONYM_PERIODS)
    #define LIBPOSTAL_NORMALIZE_DEFAULT_TOKEN_OPTIONS_NUMERIC (LIBPOSTAL_NORMALIZE_DEFAULT_TOKEN_OPTIONS | LIBPOSTAL_NORMALIZE_TOKEN_SPLIT_ALPHA_FROM_NUMERIC) *)

var
  libpostal_get_default_options: function()
    : libpostal_normalize_options_t; cdecl;

  libpostal_expand_address: function(input: PAnsiChar;
    options: libpostal_normalize_options_t; var n: size_t): PStrArray; cdecl;
  libpostal_expand_address_root: function(input: PAnsiChar;
    options: libpostal_normalize_options_t; var n: size_t): PStrArray; cdecl;

  libpostal_expansion_array_destroy: procedure(expansions: PStrArray;
    n: size_t); cdecl;
  libpostal_address_parser_response_destroy
    : procedure(self: Plibpostal_address_parser_response_t); cdecl;
  libpostal_get_address_parser_default_options: function()
    : libpostal_address_parser_options_t; cdecl;

  libpostal_parse_address: function(address: PAnsiChar;
    options: libpostal_address_parser_options_t)
    : Plibpostal_address_parser_response_t; cdecl;

  libpostal_parser_print_features: function(print_features: bool): bool; cdecl;

  /// Language classification

  libpostal_classify_language: function(address: PAnsiChar)
    : Plibpostal_language_classifier_response_t; cdecl;
  libpostal_language_classifier_response_destroy
    : procedure(self: Plibpostal_language_classifier_response_t); cdecl;

  // Deduping
  libpostal_get_near_dupe_hash_default_options: function( { void } )
    : libpostal_near_dupe_hash_options_t; cdecl;
  libpostal_near_dupe_hashes: function(num_components: size_t;
    labels, values: PStrArray; options: libpostal_near_dupe_hash_options_t;
    var num_hashes: size_t): PStrArray; cdecl;

  libpostal_near_dupe_hashes_languages: function(num_components: size_t;
    labels, values: PStrArray; options: libpostal_near_dupe_hash_options_t;
    num_languages: size_t; languages: PStrArray; var num_hashes: size_t)
    : PStrArray; cdecl;

  // Dupe language classification
  libpostal_place_languages: function(num_components: size_t;
    labels, values: PStrArray; var num_languages: size_t): PStrArray; cdecl;

  // Pairwise dupe methods
  // libpostal_get_default_duplicate_options : function (options : libpostal_duplicate_options_t; cdecl;
  libpostal_get_duplicate_options_with_languages
    : function(num_languages: size_t; languages: PStrArray)
    : libpostal_duplicate_options_t; cdecl;

  libpostal_is_name_duplicate: function(value1, value2: PAnsiChar;
    options: libpostal_duplicate_options_t)
    : libpostal_duplicate_status_t; cdecl;
  libpostal_is_street_duplicate: function(value1, value2: PAnsiChar;
    options: libpostal_duplicate_options_t)
    : libpostal_duplicate_status_t; cdecl;
  libpostal_is_house_number_duplicate: function(value1, value2: PAnsiChar;
    options: libpostal_duplicate_options_t)
    : libpostal_duplicate_status_t; cdecl;

  libpostal_is_po_box_duplicate: function(value1, value2: PAnsiChar;
    options: libpostal_duplicate_options_t)
    : libpostal_duplicate_status_t; cdecl;
  libpostal_is_unit_duplicate: function(value1, value2: PAnsiChar;
    options: libpostal_duplicate_options_t)
    : libpostal_duplicate_status_t; cdecl;
  libpostal_is_floor_duplicate: function(value1, value2: PAnsiChar;
    options: libpostal_duplicate_options_t)
    : libpostal_duplicate_status_t; cdecl;
  libpostal_is_postal_code_duplicate: function(value1, value2: PAnsiChar;
    options: libpostal_duplicate_options_t)
    : libpostal_duplicate_status_t; cdecl;
  libpostal_is_toponym_duplicate: function(num_components1: size_t;
    labels1, values1: PStrArray; num_components2: size_t;
    labels2, values2: PStrArray; options: libpostal_duplicate_options_t)
    : libpostal_duplicate_status_t; cdecl;

  // Pairwise fuzzy dupe methods, return status & similarity
  libpostal_get_default_fuzzy_duplicate_options: function( { void } )
    : libpostal_fuzzy_duplicate_options_t; cdecl;
  libpostal_get_default_fuzzy_duplicate_options_with_languages
    : function(num_languages: size_t; languages: PStrArray)
    : libpostal_fuzzy_duplicate_options_t; cdecl;

  libpostal_is_name_duplicate_fuzzy: function(num_tokens1: size_t;
    tokens1: PStrArray; var token_scores1: double; num_tokens2: size_t;
    tokens2: PStrArray; var token_scores2: double;
    options: libpostal_fuzzy_duplicate_options_t)
    : libpostal_fuzzy_duplicate_status_t; cdecl;

  libpostal_is_street_duplicate_fuzzy: function(num_tokens1: size_t;
    tokens1: PStrArray; var token_scores1: double; num_tokens2: size_t;
    tokens2: PStrArray; var token_scores2: double;
    options: libpostal_fuzzy_duplicate_options_t)
    : libpostal_fuzzy_duplicate_status_t; cdecl;

  // Setup/teardown methods
  libpostal_setup: function( { void } ): bool; cdecl;
  libpostal_setup_datadir: function(datadir: PAnsiChar): bool; cdecl;
  libpostal_teardown: procedure( { void } ); cdecl;

  libpostal_setup_parser: function( { void } ): bool; cdecl;
  libpostal_setup_parser_datadir: function(datadir: PAnsiChar): bool; cdecl;
  libpostal_teardown_parser: procedure( { void } ); cdecl;

  libpostal_setup_language_classifier: function( { void } ): bool; cdecl;
  libpostal_setup_language_classifier_datadir: function(datadir: PAnsiChar)
    : bool; cdecl;
  libpostal_teardown_language_classifier: procedure( { void } ); cdecl;

  // Tokenization and token normalization APIs
  libpostal_tokenize: function(input: PAnsiChar; whitespace: bool;
    var n: size_t): Plibpostal_token_t; cdecl;

  libpostal_normalize_string_languages: function(input: PAnsiChar;
    options: uint64_t; num_languages: size_t; languages: PStrArray)
    : PAnsiChar; cdecl;

  libpostal_normalize_string: function(input: PAnsiChar; options: uint64_t)
    : PAnsiChar; cdecl;

  libpostal_normalized_tokens: function(input: PAnsiChar;
    string_options: uint64_t; token_options: uint64_t; whitespace: bool;
    var n: size_t): Plibpostal_normalized_token_t; cdecl;
  libpostal_normalized_tokens_languages: function(input: PAnsiChar;
    string_options: uint64_t; token_options: uint64_t; whitespace: bool;
    num_languages: size_t; languages: PStrArray; var n: size_t)
    : Plibpostal_normalized_token_t; cdecl;

procedure LoadLibPostal(const P: String; raiseError : Boolean = True);

implementation

uses SysUtils,
  Windows;

var
  Handle: HModule = 0;
  module: String = '';

function ProcAddress(h: HModule; lpProcName: LPCWSTR): FarProc;
begin
  result := GetProcAddress(h, lpProcName);
  if result = nil then
    raise Exception.Create(lpProcName + ' not in module' + module);
end;

procedure LoadLibPostal(const P: String; raiseError : Boolean = True);
var
  ret: Integer;
  err: String;
begin
  // Laden nur wenn noch nicht geladen
  if Handle <> 0 then
    exit;

  module := P;
  Handle := SafeLoadLibrary(P);
  if Handle = 0 then
  begin
    ret := GetLastError();
    err := SysErrorMessage(ret);
    if raiseError then
       raise Exception.Create(err)
    else
       Writeln(err);
  end; // ...


  libpostal_get_default_options :=
    ProcAddress(Handle, 'libpostal_get_default_options');
  libpostal_expand_address := ProcAddress(Handle, 'libpostal_expand_address');
  libpostal_expand_address_root :=
    ProcAddress(Handle, 'libpostal_expand_address_root');
  libpostal_expansion_array_destroy :=
    ProcAddress(Handle, 'libpostal_expansion_array_destroy');
  libpostal_address_parser_response_destroy :=
    ProcAddress(Handle, 'libpostal_address_parser_response_destroy');
  libpostal_get_address_parser_default_options :=
    ProcAddress(Handle, 'libpostal_get_address_parser_default_options');
  libpostal_parse_address := ProcAddress(Handle, 'libpostal_parse_address');
  libpostal_parser_print_features :=
    ProcAddress(Handle, 'libpostal_parser_print_features');
  libpostal_classify_language := ProcAddress(Handle,
    'libpostal_classify_language');
  libpostal_language_classifier_response_destroy :=
    ProcAddress(Handle, 'libpostal_language_classifier_response_destroy');
  libpostal_get_near_dupe_hash_default_options :=
    ProcAddress(Handle, 'libpostal_get_near_dupe_hash_default_options');
  libpostal_near_dupe_hashes := ProcAddress(Handle,
    'libpostal_near_dupe_hashes');
  libpostal_near_dupe_hashes_languages :=
    ProcAddress(Handle, 'libpostal_near_dupe_hashes_languages');
  libpostal_place_languages := ProcAddress(Handle, 'libpostal_place_languages');
  // libpostal_get_default_duplicate_options:= ProcAddress(Handle, 'libpostal_get_default_duplicate_options');
  libpostal_get_duplicate_options_with_languages :=
    ProcAddress(Handle, 'libpostal_get_duplicate_options_with_languages');

  libpostal_is_name_duplicate := ProcAddress(Handle,
    'libpostal_is_name_duplicate');
  libpostal_is_street_duplicate :=
    ProcAddress(Handle, 'libpostal_is_street_duplicate');
  libpostal_is_house_number_duplicate :=
    ProcAddress(Handle, 'libpostal_is_house_number_duplicate');
  libpostal_is_po_box_duplicate :=
    ProcAddress(Handle, 'libpostal_is_po_box_duplicate');
  libpostal_is_unit_duplicate := ProcAddress(Handle,
    'libpostal_is_unit_duplicate');
  libpostal_is_floor_duplicate := ProcAddress(Handle,
    'libpostal_is_floor_duplicate');
  libpostal_is_postal_code_duplicate :=
    ProcAddress(Handle, 'libpostal_is_postal_code_duplicate');
  libpostal_is_toponym_duplicate :=
    ProcAddress(Handle, 'libpostal_is_toponym_duplicate');
  libpostal_get_default_fuzzy_duplicate_options :=
    ProcAddress(Handle, 'libpostal_get_default_fuzzy_duplicate_options');
  libpostal_get_default_fuzzy_duplicate_options_with_languages :=
    ProcAddress(Handle,
    'libpostal_get_default_fuzzy_duplicate_options_with_languages');
  libpostal_is_name_duplicate_fuzzy :=
    ProcAddress(Handle, 'libpostal_is_name_duplicate_fuzzy');
  libpostal_is_street_duplicate_fuzzy :=
    ProcAddress(Handle, 'libpostal_is_street_duplicate_fuzzy');
  libpostal_setup := ProcAddress(Handle, 'libpostal_setup');
  libpostal_setup_datadir := ProcAddress(Handle, 'libpostal_setup_datadir');
  libpostal_teardown := ProcAddress(Handle, 'libpostal_teardown');
  libpostal_setup_parser := ProcAddress(Handle, 'libpostal_setup_parser');
  libpostal_setup_parser_datadir :=
    ProcAddress(Handle, 'libpostal_setup_parser_datadir');
  libpostal_teardown_parser := ProcAddress(Handle, 'libpostal_teardown_parser');
  libpostal_setup_language_classifier :=
    ProcAddress(Handle, 'libpostal_setup_language_classifier');
  libpostal_setup_language_classifier_datadir :=
    ProcAddress(Handle, 'libpostal_setup_language_classifier_datadir');
  libpostal_teardown_language_classifier :=
    ProcAddress(Handle, 'libpostal_teardown_language_classifier');
  libpostal_tokenize := ProcAddress(Handle, 'libpostal_tokenize');
  libpostal_normalize_string_languages :=
    ProcAddress(Handle, 'libpostal_normalize_string_languages');
  libpostal_normalize_string := ProcAddress(Handle,
    'libpostal_normalize_string');
  libpostal_normalized_tokens := ProcAddress(Handle,
    'libpostal_normalized_tokens');
  libpostal_normalized_tokens_languages :=
    ProcAddress(Handle, 'libpostal_normalized_tokens_languages');
end;

end.
