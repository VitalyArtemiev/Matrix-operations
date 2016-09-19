unit calc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids;

type

  { tMatrix }

  tMatrix = class
  private
    fCol: word;
    fRow: word;
    M: array of array of single;
    procedure SetCol(AValue: word);
    procedure SetRow(AValue: word);
  public
    property Col: word read fCol write SetCol;
    property Row: word read fRow write SetRow;

    procedure PasteToGrid(G: tStringGrid);

    constructor Create(G: tStringGrid);
    constructor Create(R, C: word);
    destructor Destroy; override;
  end;

function MultMatrix(a, b: tMatrix): tMatrix;
function SumMatrix(a, b: tMatrix): tMatrix;
function InvertMatrix(a: tMatrix): tMatrix;
function TransponMatrix(a: tMatrix): tMatrix;

implementation

uses
  util, dialogs;

function MultMatrix(a, b: tMatrix): tMatrix;
var
  i, j, k: word;
begin
  Result:= tMatrix.Create(a.Row, b.Col);
  with Result do
  begin
  for i:= 0 to Row - 1 do
    for j:= 0 to Col - 1 do
    begin
      M[i,j]:= 0;
      for k:= 0 to a.Col - 1 do
        M[i,j]+= a.M[i,k] * b.M[k,j];
    end;
  end;
end;

function SumMatrix(a, b: tMatrix): tMatrix;
var
  i, j, k: word;
begin
  Result:= tMatrix.Create(a.Row, a.Col);
  with Result do
  begin
  for i:= 0 to Row - 1 do
    for j:= 0 to Col - 1 do
    begin
      M[i,j]:= a.M[i,j] + b.M[i,j];
    end;
  end;
end;

function InvertMatrix(a: tMatrix): tMatrix;
var
  i, j: integer;
begin
  Result:= a;
  with Result do
  begin
  for i:= 0 to Row - 1 do
    for j:= 0 to Col - 1 do
    begin
      M[i,j]:= - M[i,j];
    end;
  end;
end;

function TransponMatrix(a: tMatrix): tMatrix;
var
  i, j: integer;
begin
  Result:= tMatrix.Create(a.Col, a.Row);
  with Result do
  begin
    for i:= 0 to Row - 1 do
      for j:= 0 to Col - 1 do
        M[i,j]:= a.M[j,i];
  end;
end;

{ tMatrix }

procedure tMatrix.SetCol(AValue: word);
begin
  if fCol=AValue then Exit;
  fCol:=AValue;
  setlength(M, fRow, fCol);
end;

procedure tMatrix.SetRow(AValue: word);
begin
  if fRow=AValue then Exit;
  fRow:=AValue;
  setlength(M, fRow, fCol);
end;

procedure tMatrix.PasteToGrid(G: tStringGrid);
var
  i, j: integer;
  s: string;
begin
  if (G.RowCount < fRow) or (G.ColCount < fCol) then
    raise Exception.Create('invalid grid size');

  for i:= 0 to fRow - 1 do
    for j:= 0 to fCol - 1 do
    begin
      if frac(M[i,j]) = 0 then
        G.Cells[j,i]:= strf(integer(trunc(M[i,j]))) //tstringgrid inverted
      else
        G.Cells[j,i]:= strf(M[i,j]);
    end;
end;

constructor tMatrix.Create(G: tStringGrid);
var
  i, j, e: integer;
  s: string;
  a: single;
begin
  fRow:= G.RowCount;
  fCol:= G.ColCount;
  setlength(M, fRow, fCol);

  for i:= 0 to fRow - 1 do
    for j:= 0 to fCol - 1 do
    begin
      s:= G.Cells[j,i]; //tstringgrid inverted
      val(s, a, e);
      if e<>0 then
        raise Exception.Create('invalid value');
      M[i,j]:= a;
    end;
end;

constructor tMatrix.Create(R, C: word);
begin
  fRow:= R;
  fCol:= C;
  setlength(M, R, C);
end;

destructor tMatrix.Destroy;
begin
  inherited Destroy;
  setlength(M, 0, 0);
end;

end.

