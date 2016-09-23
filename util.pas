unit util;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function strf(a: integer): string;
function strf(a: double): string;

implementation

function strf(a: integer): string;
begin
  str(a, Result);
end;

function strf(a: double): string;
begin
  if frac(a) = 0 then
    str(trunc(a), Result)
  else
    str(a:0:6, Result);
end;

end.

