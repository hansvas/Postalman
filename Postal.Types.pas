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
unit Postal.Types;
interface
uses System.Generics.Collections,
  Classes;

type
  /// <summary>The address parser can technically use any string labels that are
  /// defined in the training data, but these are the ones currently defined,
  /// based on the fields defined in OpenCage's address-formatting library,
  /// as well as a few added by libpostal to handle specific patterns</summary>
  TPostalManFields = (
    /// <summary>house: venue name e.g. "Brooklyn Academy of Music",
    /// building names e.g. "Empire State Building". If you parse
    /// Addresses with the householder in it, the householder could be
    /// indentified as house </summary>
    house,
    /// <summary>category: for category queries like "restaurants", etc</summary>
    category,
    /// <summary>near: phrases like "in", "near", etc. used after a category
    /// phrase to help with parsing queries like "restaurants in Brooklyn"</summary>
    near,
    /// <summary>usually refers to the external (street-facing) building
    /// number. In some countries this may be a compount, hyphenated number
    /// which also includes an apartment number, or a block number
    /// (a la Japan), but libpostal will just call it the house_number
    /// for simplicity.</summary>
    house_number,
    /// <summary>road: street name(s)</summary>
    road,
    /// <summary> unit: an apartment, unit, office, lot, or other
    /// secondary unit designator </summary>
    unt,
    /// <summary>level: expressions indicating a floor number e.g.
    /// "3rd Floor", "Ground Floor", etc.</summary>
    level,
    /// <summary>staircase: numbered/lettered staircase</summary>
    staircase,
    /// <summary>entrance: numbered/lettered entrance</summary>
    entrance,
    /// <summary>po_box: post office box: typically found in
    /// non-physical (mail-only) addresses</summary>
    po_box,
    /// <summary>postcode: postal codes used for mail sorting</summary>
    postcode,
    /// <summary>suburb: usually an unofficial neighborhood
    /// name like "Harlem", "South Bronx", or "Crown Heights" </summary>
    suburb,
    /// <summary>city_district: these are usually boroughs or districts within a city
    /// that serve some official purpose e.g. "Brooklyn" or
    /// "Hackney" or "Bratislava IV"</summary>
    city_district,
    /// <summary>city: any human settlement including cities, towns, villages,
    /// hamlets, localities, etc.</summary>
    city,
    /// <summary>island: named islands e.g. "Maui"</summary>
    island,
    /// <summary>usually a second-level administrative division or county.</summary>
    state_district,
    /// <summary>a first-level administrative division. Scotland,
    /// Northern Ireland, Wales, and England in the UK are mapped
    /// to "state" as well (convention used in OSM, GeoPlanet, etc.)</summary>
    state,
    /// <summary>informal subdivision of a country without any political status</summary>
    country_region,
    /// <summary>sovereign nations and their dependent territories,
    /// anything with an ISO-3166 code.</summary>
    country,
    /// <summary>currently only used for appending “West Indies” after
    /// the country name, a pattern frequently used in the English-speaking
    /// Caribbean e.g. “Jamaica, West Indies”</summary>
    world_region,

    ///<summary>normally not in the fieldlist of libpostal. Altitude </summary>
    alt,
    ///<summary>normally not in the fieldlist of libpostal. Latitude </summary>
    lat,
    ///<summary>normally not in the fieldlist of libpostal. Longitude </summary>
    lon,
    ///<summary>normally not in the fieldlist of libpostal. Indicates the field
    /// is a name or a part of a name</summary>
    name,
    ///<summary>normally not in the fieldlist of libpostal. Indicates the field
    /// is a first name or a part of</summary>
    first_name,
    ///<summary>normally not in the fieldlist of libpostal. Indicates the field
    /// is a last name or a part of a last name</summary>
    last_name,
    ///<summary>normally not in the fieldlist of libpostal. Indicates the field
    /// is the gender of the address/person</summary>
    gender,
    ///<summary>normally not in the fieldlist of libpostal. Indicates the field
    /// is the age of the address/person</summary>
    age,
    ///<summary>used for unidentified parts of the address</summary>
    anything_else);

  TPostalManValues   = TDictionary<TPostalManFields, string>;
  TPostalManMappings = TDictionary<TPostalManFields, TPostalManFields>;

  TPostalManLanguages = Array of String;

implementation

end.
