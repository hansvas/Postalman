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
unit Postal.Strings;
interface

function PrepareStrForSim ( const s : String ) : String ;

///<summary>The Hamming distance between two strings of equal length is the
/// number of positions at which the corresponding symbols are different.
/// In other words, it is the number of substitutions required to transform
/// one string into another. Given two strings of equal length, compute the
/// Hamming distance.</summary>
function HammingDist     ( const str1,str2 : String ) : Integer;

function NearestDist     ( const str1,str2 : String ) : Integer;

implementation

function PrepareStrForSim ( const s : String ) : String ;
var i : Integer ;
begin
 result := '';
 for i := 1 to length(s)  do
 begin
   if not ( s[i] in [',',';','-','+',' ','&','(',')','/'] ) then
   case s[i] of
    'Ä' : result := result + 'Ae';
    'Ö' : result := result + 'Oe';
    'Ü' : result := result + 'Ue';
    'ä' : result := result + 'ae';
    'ü' : result := result + 'ue';
    'ö' : result := result + 'oe';
    'ß' : result := result + 'ss';
    else result := result + s[i];
   end;
 end;
end;

function HammingDist ( const str1,str2 : String ) : Integer;
var i : Integer;
begin
 if ( Length ( str1 ) <> Length ( str2 ) ) then result := -1 else
  begin
    result := 0;
    for i := 1 to Length ( str1 ) do
     if ( str1[i] <> str2[i] ) then inc ( result );
  end;
end;

function NearestDist ( const str1,str2 : String ) : Integer;
var r,l1,l2,i : Integer;
begin
 l1 := Length ( Str1 );
 l2 := Length ( Str2 );
 if ( l1 = l2 ) then result := HammingDist ( str1, str2 ) else
  begin
   // wir suchen nach Wortbereichen und nicht nach Worten
   if ( l1 > l2 ) then begin r := l2; result := l1 - l2 end
                  else begin r := l1; result := l2 - l1 end;
   for i := 1 to r do
    if ( str1[i] <> str2[i] ) then inc ( result );
  end;
end;


end.
