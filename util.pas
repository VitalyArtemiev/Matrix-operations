unit util;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function strf(a: integer): string;
function strf(a: single): string;

implementation

function strf(a: integer): string;
begin
  str(a, Result);
end;

function strf(a: single): string;
begin
  str(a, Result);
end;

end.

