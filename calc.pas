unit calc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids;

type
  s2a = array of array of single;

  { tMatrix }

  tMatrix = class
  private
    fCol: word;
    fRow: word;
    M: s2a;
    function getM(i, j: integer): single;
    procedure SetCol(AValue: word);
    procedure setM(i, j: integer; AValue: single);
    procedure SetRow(AValue: word);
    procedure Print;
  public
    property pM[i, j: integer]: single read getM write setM; default;
    property Col: word read fCol write SetCol;
    property Row: word read fRow write SetRow;

    procedure SwapRow(r1, r2: integer);
    procedure PasteToGrid(G: tStringGrid);

    constructor Create(G: tStringGrid);
    constructor Create(R, C: word);
    destructor Destroy; override;
  end;

function MultMatrix(a, b: tMatrix): tMatrix;
function SumMatrix(a, b: tMatrix): tMatrix;
function DetMatrix(a: tMatrix): single;
function InvertMatrix(a: tMatrix): tMatrix;
function TransponMatrix(a: tMatrix): tMatrix;

implementation

uses
  util, dialogs, unit1;

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
  i, j: word;
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

procedure LUDecompose(a: tMatrix; out u, l: tMatrix);
var
  i, j, k: integer;
  s, t: single;
begin
  u:= tMatrix.Create(a.Row, a.Col);
  l:= tMatrix.Create(a.Row, a.Col);

  for i:= 0 to l.Row - 1 do
  begin
    u[0,i]:= a[0,i];
    l[i,i]:= 1;
  end;

  for i:= 0 to u.Row - 1 do
  begin
    for j:= i to u.Row - 1 do
    begin
      s:= 0;
      for k:= 0 to i-1 do
        s+= l[i,k] * u[k,j];
      u[i,j]:= a[i,j] - s;
    end;

    for j:= i + 1 to u.Row - 1 do
    begin
      s:= 0;
      for k:= 0 to i-1 do
        s+= l[j,k] * u[k,i];

      writeln('u');
      u.Print;
      writeln('l');
      l.Print;
      writeln(i,' ',j);

      if u[i,i] <> 0 then
        l[j,i]:= (a[j,i] - s)/u[i,i]
      else
        l[j,i]:= 1; //???
    end;
  end;

 { mainform.m1.ColCount:= u.Col;
  mainform.m1.RowCount:= u.Col;
  mainform.m2.ColCount:= u.Col;
  mainform.m2.RowCount:= u.Col;
  u.PasteToGrid(MainForm.M1);
  l.PasteToGrid(MainForm.M2);}
end;

function DetMatrix(a: tMatrix): single;
var
  i, j, k: integer;
  s: single;
begin
  for i:= 0 to a.Row - 1 do
  begin
    for j:= i to a.Row - 1 do
    begin
      s:= 0;
      for k:= 0 to i-1 do
        s+= a[i,k] * a[k,j];
      a[i,j]:= a[i,j] - s;
    end;

    for j:= i + 1 to a.Row - 1 do
    begin
      s:= 0;
      for k:= 0 to i-1 do
        s+= a[j,k] * a[k,i];

      if a[i,i] <> 0 then
        a[j,i]:= (a[j,i] - s)/a[i,i]
      else
        exit(0);
    end;
  end;

  Result:= 1;

  for i:= 0 to a.Col - 1 do
    Result*= a.M[i,i];
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

procedure tMatrix.setM(i, j: integer; AValue: single);
begin
  M[i,j]:= AValue;
end;

function tMatrix.getM(i, j: integer): single;
begin
  Result:= M[i,j];
end;

procedure tMatrix.SetRow(AValue: word);
begin
  if fRow=AValue then Exit;
  fRow:=AValue;
  setlength(M, fRow, fCol);
end;

procedure tMatrix.Print;
var
  i, j: integer;
begin
  writeln(Row, ' ', Col);
  for i:= 0 to Row - 1 do
  begin
    for j:= 0 to Col - 1 do
      write(M[i, j]:0:2,  ' ');

    writeln;
  end;

  writeln;
end;

procedure tMatrix.SwapRow(r1, r2: integer);
var
  a: array of single;
  i: integer;
begin
  writeln('swap start');
  Print;

  a:= M[r2];
  M[r2]:= M[r1];
  M[r1]:= a;
  for i:= 0 to Col - 1 do
  M[r1, i]*= -1; //change sign so to not change det

  writeln('swap stop');
  Print;
end;

procedure tMatrix.PasteToGrid(G: tStringGrid);
var
  i, j: integer;
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

