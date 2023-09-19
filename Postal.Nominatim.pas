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
unit Postal.Nominatim;
interface
uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope,
  Postal.Types,
  Postal.PostalMan;

type ///<summary>TNominatimValidator is a validator who checks the existence
     /// of a address in a nominatim instance. This is done by reverse
     /// gecoding and can add longitude, latitude to a address.</summary>
     TNominatimValidator = class(TPostalManAbstractValidator)
     private
       FResultIfFailed : TPostalManValidationResult;
     public
      Constructor Create (aPostalMan : TPostalMan);                    override;
      function ValidateAddress
            (address : TPostalManValues) : TPostalManValidationResult; override;
     /// <summary>The Validator is a very weak validator. A negative result
     /// did not ment that you can rely on this negative result, but a postive
     /// result is a good indicator that your address existis
     ///
     /// To take count of this fact, you can change the result of a failed
     /// validtion process. </<summary>
     property
      ResultIfFailed : TPostalManValidationResult
       read FResultIfFailed write FResultIfFailed;
     end;


///<summary>This function is exactly what you can expect from the name. It
/// answered the question, if an address is exists in nominatim.
/// Since there are many possibilities why the result can be
/// false (address did not exists, connection problems etc.) it is a
/// method for address validation, and a negative result did not ment that
/// you can rely that a address is false. But a positive result is a good
/// indicator that the address can be used</summary>
function NominatimHasAddress
      (FieldsAndValues : TPostalManValues; var lat, lon : String) : Boolean;

///<summary>In a commercial application, you can host your own instance of
///  nominatim. The url given here is only for testing and should be
///  changed</summary>
var NominatimBaseURL : String = 'https://nominatim.openstreetmap.org';

implementation
uses System.JSON;

function NominatimHasAddress
      (FieldsAndValues : TPostalManValues; var lat, lon : String) : Boolean;
var client : TRestClient;
    request : TRestRequest;
    JSonArray : TJSonArray;
begin

  client := TRestClient.Create(NominatimBaseURL);
  Request := TRestRequest.Create(nil);
  Request.Client := Client;
  Request.Method := rmGet;
  Request.resource := 'search';

  Request.AddParameter('format','json', pkGETorPOST);
  for var f in FieldsAndValues do
   begin
    if f.Value <> '' then
    case f.key of
      house_number  : Request.AddParameter('number', f.Value, pkGETorPOST);
      road          : Request.AddParameter('street', f.Value, pkGETorPOST);
      postcode      : Request.AddParameter('postalcode', f.Value, pkGETorPOST);
      city          : Request.AddParameter('city', f.Value, pkGETorPOST);
      state         : Request.AddParameter('state', f.Value, pkGETorPOST);
      country       : Request.AddParameter('country', f.value, pkGETorPOST);
    end;
   end;
   Request.Execute;
   if not Request.Response.Status.Success then
      begin
        result := False;
        exit;
      end;
   if not Assigned(Request.Response.JSONValue) then
       begin
         result := False;
         exit;
       end;
   // An dieser Stelle hat eine Verbindung zum Nomanitim Server stattgefunden.
   // Wenn kein Ergebnis vorliegt ist die Addresse zumindest dort nicht vorhanden
   try
    JSONArray := TJSONObject.ParseJSONValue(Request.Response.JSOnText) as TJSONArray;
    if JSONArray.Count > 0 then
     begin
      try
        //lat :=  JSOnArray.Items[0].GetValue<double>('lat');
        //lon :=  JSOnArray.Items[0].GetValue<double>('lon');
        lat :=  JSOnArray.Items[0].GetValue<string>('lat');
        lon :=  JSOnArray.Items[0].GetValue<string>('lon');
        result := True;
      except
        result := False;
      end;
     end else
     result := False;
   except
    try
     //lat :=  Request.Response.JSONValue.GetValue<double>('"lat"');
     //lon :=  Request.Response.JSONValue.GetValue<double>('"lon"');
     lat :=  Request.Response.JSONValue.GetValue<string>('"lat"');
     lon :=  Request.Response.JSONValue.GetValue<string>('"lon"');
     result := True;
    except
     result := False;
    end;
   end;
   Request.Free;
   Client.Free;
end;

// -----------------------------------------------------------------------------

Constructor TNominatimValidator.Create (aPostalMan : TPostalMan);
begin
  inherited Create(aPostalMan);
  FResultIfFailed := not_sure_if_valid;
end;

function TNominatimValidator.ValidateAddress
            (address : TPostalManValues) : TPostalManValidationResult;
var nlat, nlon : String;
   oLat, oLon : String;
begin
 ExtendedParts.Clear;
 ChangedParts.Clear;

 if NominatimHasAddress(address, nlat, nlon) then
  begin
   result := valid_address;
   if ExtensionsAllowed or ChangesAllowed then
    begin
     // check if lat and/or lon already exists
     if address.containsKey(lat) and
        address.containsKey(lon) then
        result := valid_adress_but_parts_changed
     else
        result := valid_adress_but_parts_extended;

     if ((extensionsAllowed) and (result = valid_adress_but_parts_extended)) or
        ((ChangesAllowed) and (result = valid_adress_but_parts_changed)) then
          begin
           address.AddOrSetValue(lat,nLat);
           address.AddOrSetValue(lon,nLon);
           case result of
            valid_adress_but_parts_extended : begin
                  ExtendedParts.Add(lat,nLat);
                  ExtendedParts.Add(lon,nLon);
            end;
            valid_adress_but_parts_changed : begin
                  ChangedParts.Add(lat,nLat);
                  ChangedParts.Add(lon,nLon);
            end;
           end;
          end;
    end;
  end else
    result := ResultIfFailed;
end;

end.
