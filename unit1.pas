unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Spin, Grids, StdCtrls, ExtCtrls, Buttons, calc;

type

  { TMainForm }

  TMainForm = class(TForm)
    CalculateTranspon: TBitBtn;
    CalculateSum: TBitBtn;
    CalculatePow: TBitBtn;
    CalculateDet: TBitBtn;
    Clear10: TButton;
    Clear11: TButton;
    Clear4: TButton;
    Clear5: TButton;
    Clear6: TButton;
    Clear7: TButton;
    Clear8: TButton;
    Clear9: TButton;
    Copy10: TButton;
    Copy11: TButton;
    Copy4: TButton;
    Copy5: TButton;
    Copy6: TButton;
    Copy7: TButton;
    Copy8: TButton;
    Copy9: TButton;
    DeleteSelected: TButton;
    ClearGrid: TButton;
    Clear1: TButton;
    Clear2: TButton;
    Clear3: TButton;
    CalculateMult: TBitBtn;
    Copy1: TButton;
    eM11C: TSpinEdit;
    eM11R: TSpinEdit;
    eM10C: TSpinEdit;
    eM10R: TSpinEdit;
    eM7C: TSpinEdit;
    eM7R: TSpinEdit;
    eM8C: TSpinEdit;
    eM8R: TSpinEdit;
    eM9C: TSpinEdit;
    eM9R: TSpinEdit;
    eM4C: TSpinEdit;
    eM6C: TSpinEdit;
    eM4R: TSpinEdit;
    eM6R: TSpinEdit;
    eM5C: TSpinEdit;
    eM5R: TSpinEdit;
    M10: TStringGrid;
    M11: TStringGrid;
    M5: TStringGrid;
    M6: TStringGrid;
    M7: TStringGrid;
    M8: TStringGrid;
    M9: TStringGrid;
    Paste10: TButton;
    Paste11: TButton;
    Paste5: TButton;
    Paste6: TButton;
    Paste7: TButton;
    Paste8: TButton;
    Paste9: TButton;
    Power: TSpinEdit;
    M4: TStringGrid;
    Paste1: TButton;
    Copy2: TButton;
    Paste2: TButton;
    Copy3: TButton;
    Paste3: TButton;
    Pages: TPageControl;
    eM1R: TSpinEdit;
    eM1C: TSpinEdit;
    eM2R: TSpinEdit;
    eM2C: TSpinEdit;
    eM3R: TSpinEdit;
    eM3C: TSpinEdit;
    M1: TStringGrid;
    M2: TStringGrid;
    M3: TStringGrid;
    Paste4: TButton;
    OpChoice: TRadioGroup;
    StaticText1: TStaticText;
    BufferGrid: TStringGrid;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Det: TStaticText;
    StaticText4: TStaticText;
    CalcTranspon: TTabSheet;
    tMult: TTabSheet;
    tDet: TTabSheet;
    tStair: TTabSheet;
    tPow: TTabSheet;
    tSum: TTabSheet;
    procedure BufferGridValidateEntry(sender: TObject; aCol, aRow: Integer;
      const OldValue: string; var NewValue: String);
    procedure CalculateDetClick(Sender: TObject);
    procedure CalculateMultClick(Sender: TObject);
    procedure CalculatePowClick(Sender: TObject);
    procedure CalculateSumClick(Sender: TObject);
    procedure CalculateTransponClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure ClearGridClick(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure DeleteSelectedClick(Sender: TObject);
    procedure eM10CChange(Sender: TObject);
    procedure eM10RChange(Sender: TObject);

    procedure eM1CChange(Sender: TObject);
    procedure eM1RChange(Sender: TObject);
    procedure eM2CChange(Sender: TObject);
    procedure eM4RChange(Sender: TObject);
    procedure eM6RChange(Sender: TObject);
    procedure eM7CChange(Sender: TObject);
    procedure eM7RChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MValidateEntry(sender: TObject; aCol, aRow: Integer;
      const OldValue: string; var NewValue: String);
    procedure PagesChange(Sender: TObject);
    procedure PasteClick(Sender: TObject);
  private
    { private declarations }
    procedure CompleteMatrix(G: tStringGrid);
    procedure CompleteMatrices;
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  Buffer: array of tMatrix;

implementation

uses util, strutils;

const
  TabSum = 0;
  TabMult = 1;
  TabPow = 2;
  TabTranspon = 3;
  TabDet = 4;
  TabStair = 5;

  ColName = 0;
  ColRows = 1;
  ColCols = 2;

{$R *.lfm}

{ TMainForm }

procedure TMainForm.PasteClick(Sender: TObject);
begin
  if BufferGrid.Row < 1 then
  begin
    ShowMessage('Выберите матрицу из списка');
    exit;
  end;

  try
    case tButton(Sender).Name of
      'Paste1': Buffer[BufferGrid.Row - 1].PasteToGrid(M1);
      'Paste2': Buffer[BufferGrid.Row - 1].PasteToGrid(M2);
      'Paste3': Buffer[BufferGrid.Row - 1].PasteToGrid(M3);
      'Paste4': Buffer[BufferGrid.Row - 1].PasteToGrid(M4);
      'Paste5': Buffer[BufferGrid.Row - 1].PasteToGrid(M5);
      'Paste6': Buffer[BufferGrid.Row - 1].PasteToGrid(M6);
      'Paste7': Buffer[BufferGrid.Row - 1].PasteToGrid(M7);
      'Paste8': Buffer[BufferGrid.Row - 1].PasteToGrid(M8);
      'Paste9': Buffer[BufferGrid.Row - 1].PasteToGrid(M9);
      'Paste10': Buffer[BufferGrid.Row - 1].PasteToGrid(M10);
      'Paste11': Buffer[BufferGrid.Row - 1].PasteToGrid(M11);
    end;
  except
    on E: Exception do
    begin
      if E.Message = 'invalid grid size' then
        ShowMessage('Неверный размер матрицы')
      else
        ShowMessage(E.Message);
    end;
  end;
end;

procedure TMainForm.CompleteMatrix(G: tStringGrid);
var
  i, j: integer;
begin
  with G do
  begin
  for i:= 0 to RowCount - 1 do
    for j:= 0 to ColCount - 1 do
      if Cells[j, i] = '' then
        Cells[j, i]:= '0';
  end;
end;

procedure TMainForm.CompleteMatrices;
begin
  case Pages.TabIndex of
    TabSum:
      begin
        CompleteMatrix(M7);
        CompleteMatrix(M8);
        CompleteMatrix(M9);
      end;
    TabMult:
      begin
        CompleteMatrix(M1);
        CompleteMatrix(M2);
        CompleteMatrix(M3);
      end;
    TabPow:
      begin
        CompleteMatrix(M4);
        CompleteMatrix(M5);
      end;
    TabTranspon:
      begin
        CompleteMatrix(M10);
      end;
    TabDet:
      begin
        CompleteMatrix(M6);
      end;
    TabStair: ;
  end;
end;

procedure TMainForm.eM1CChange(Sender: TObject);
begin
  eM2R.Value:= eM1C.Value;
  M2.RowCount:= eM1C.Value;
  M1.ColCount:= eM1C.Value;
end;

procedure TMainForm.CopyClick(Sender: TObject);
begin
  CompleteMatrices;
  setlength(Buffer, length(Buffer) + 1);
  case tButton(Sender).Name of
    'Copy1': Buffer[high(Buffer)]:= tMatrix.Create(M1);
    'Copy2': Buffer[high(Buffer)]:= tMatrix.Create(M2);
    'Copy3': Buffer[high(Buffer)]:= tMatrix.Create(M3);
    'Copy4': Buffer[high(Buffer)]:= tMatrix.Create(M4);
    'Copy5': Buffer[high(Buffer)]:= tMatrix.Create(M5);
    'Copy6': Buffer[high(Buffer)]:= tMatrix.Create(M6);
    'Copy7': Buffer[high(Buffer)]:= tMatrix.Create(M7);
    'Copy8': Buffer[high(Buffer)]:= tMatrix.Create(M8);
    'Copy9': Buffer[high(Buffer)]:= tMatrix.Create(M9);
    'Copy10': Buffer[high(Buffer)]:= tMatrix.Create(M10);
    'Copy11': Buffer[high(Buffer)]:= tMatrix.Create(M11);
  end;
  BufferGrid.RowCount:= BufferGrid.RowCount + 1;
  BufferGrid.Cells[ColName, BufferGrid.RowCount - 1]:= 'Матрица' + strf(BufferGrid.RowCount - 1);
  BufferGrid.Cells[ColRows, BufferGrid.RowCount - 1]:= strf(Buffer[high(Buffer)].Row);
  BufferGrid.Cells[ColCols, BufferGrid.RowCount - 1]:= strf(Buffer[high(Buffer)].Col);
end;

procedure TMainForm.DeleteSelectedClick(Sender: TObject);
var
  i: Integer;
begin
  if BufferGrid.Row < 1 then
  begin
    ShowMessage('Выберите матрицу из списка');
    exit;
  end;

  BufferGrid.DeleteRow(BufferGrid.Row);
  for i:= BufferGrid.Row - 1 to high(Buffer) - 1 do
  begin
    Buffer[i]:= Buffer[i + 1];
  end;
  setlength(Buffer, length(Buffer) - 1);
end;

procedure TMainForm.eM10CChange(Sender: TObject);
begin
  eM11R.Value:= eM10C.Value;
  M10.ColCount:= eM10C.Value;
  M11.RowCount:= eM10C.Value;
end;

procedure TMainForm.eM10RChange(Sender: TObject);
begin
  eM11C.Value:= eM10R.Value;
  M10.RowCount:= eM10R.Value;
  M11.ColCount:= eM10R.Value;
end;

procedure TMainForm.ClearGridClick(Sender: TObject);
var
  i: Integer;
begin
  for i:= 0 to high(Buffer) do
    Buffer[i].Destroy;
  setlength(Buffer, 0);

  BufferGrid.RowCount:= 1;
end;

procedure TMainForm.CalculateMultClick(Sender: TObject);
var
  a, b, c: tMatrix;
begin
  CompleteMatrices;
  a:= tMatrix.Create(M1);
  b:= tMatrix.Create(M2);
  c:= MultMatrix(a, b);
  c.PasteToGrid(M3);
  a.Destroy;
  b.Destroy;
  c.Destroy;
end;

procedure TMainForm.CalculateDetClick(Sender: TObject);
var
  a: tMatrix;
  Result: single;
  d: integer;
begin
  CompleteMatrices;
  a:= tMatrix.Create(M6);

  Result:= DetMatrix(a);
  if frac(Result) = 0 then
    d:= 0
    else
      d:= 4;
  Det.Caption:= FloatToStrf(Result, ffFixed, 0, d);

  a.Destroy;
end;

procedure TMainForm.BufferGridValidateEntry(sender: TObject; aCol,
  aRow: Integer; const OldValue: string; var NewValue: String);
begin
  if aCol > 0 then
    NewValue:= OldValue;
end;

procedure TMainForm.CalculatePowClick(Sender: TObject);
var
  a, c: tMatrix;
  i: integer;
begin
  CompleteMatrices;
  a:= tMatrix.Create(M4);
  c:= MultMatrix(a, a);

  for i:= 3 to Power.Value do
    c:= MultMatrix(c, a);

  c.PasteToGrid(M5);
  a.Destroy;
  c.Destroy;
end;

procedure TMainForm.CalculateSumClick(Sender: TObject);
var
  a, b, c: tMatrix;
begin
  CompleteMatrices;
  a:= tMatrix.Create(M7);
  b:= tMatrix.Create(M8);
  if OpChoice.ItemIndex = 1 then
  b:= InvertMatrix(b);
  c:= SumMatrix(a, b);
  c.PasteToGrid(M9);
  a.Destroy;
  b.Destroy;
  c.Destroy;
end;

procedure TMainForm.CalculateTransponClick(Sender: TObject);
var
  a, c: tMatrix;
  i: integer;
begin
  CompleteMatrices;
  a:= tMatrix.Create(M10);
  c:= TransponMatrix(a);

  c.PasteToGrid(M11);
  a.Destroy;
  c.Destroy;
end;

procedure TMainForm.ClearClick(Sender: TObject);
begin
  case tButton(Sender).Name of
    'Clear1': M1.Clean;
    'Clear2': M2.Clean;
    'Clear3': M3.Clean;
    'Clear4': M4.Clean;
    'Clear5': M5.Clean;
    'Clear6': M6.Clean;
    'Clear7': M7.Clean;
    'Clear8': M8.Clean;
    'Clear9': M9.Clean;
    'Clear10': M10.Clean;
    'Clear11': M11.Clean;
  end;
end;

procedure TMainForm.eM1RChange(Sender: TObject);
begin
  eM3R.Value:= eM1R.Value;
  M1.RowCount:= eM1R.Value;
  M3.RowCount:= eM1R.Value;
end;

procedure TMainForm.eM2CChange(Sender: TObject);
begin
  eM3C.Value:= eM2C.Value;
  M2.ColCount:= eM2C.Value;
  M3.ColCount:= eM2C.Value;
end;

procedure TMainForm.eM4RChange(Sender: TObject);
begin
  eM4C.Value:= eM4R.Value;
  eM5R.Value:= eM4R.Value;
  eM5C.Value:= eM4R.Value;

  M4.RowCount:= eM4R.Value;
  M4.ColCount:= eM4R.Value;
  M5.RowCount:= eM4R.Value;
  M5.ColCount:= eM4R.Value;
end;

procedure TMainForm.eM6RChange(Sender: TObject);
begin
  eM6C.Value:= eM6R.Value;

  M6.RowCount:= eM6R.Value;
  M6.ColCount:= eM6R.Value;
end;

procedure TMainForm.eM7CChange(Sender: TObject);
begin
  eM8C.Value:= eM7C.Value;
  eM9C.Value:= eM7C.Value;

  M7.ColCount:= eM7C.Value;
  M8.ColCount:= eM7C.Value;
  M9.ColCount:= eM7C.Value;
end;

procedure TMainForm.eM7RChange(Sender: TObject);
begin
  eM8R.Value:= eM7R.Value;
  eM9R.Value:= eM7R.Value;

  M7.RowCount:= eM7R.Value;
  M8.RowCount:= eM7R.Value;
  M9.RowCount:= eM7R.Value;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i:= 0 to high(Buffer) do
    Buffer[i].Destroy;
  setlength(Buffer, 0);
end;

procedure TMainForm.MValidateEntry(sender: TObject; aCol, aRow: Integer;
  const OldValue: string; var NewValue: String);
var
  e: integer;
  a: single;
begin
  val(NewValue, a, e);
  if e <> 0 then
    NewValue:= '';
end;

procedure TMainForm.PagesChange(Sender: TObject);
begin

end;

end.

