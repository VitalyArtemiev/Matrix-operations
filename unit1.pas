unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Spin, Grids, StdCtrls, ExtCtrls, Buttons, calc;

type

  { TMainForm }

  TMainForm = class(TForm)
    DeleteSelected: TButton;
    ClearGrid: TButton;
    Clear1: TButton;
    Clear2: TButton;
    Clear3: TButton;
    Calculate: TBitBtn;
    Copy1: TButton;
    Paste1: TButton;
    Copy2: TButton;
    Paste2: TButton;
    Copy3: TButton;
    Paste3: TButton;
    PageControl1: TPageControl;
    eM1R: TSpinEdit;
    eM1C: TSpinEdit;
    eM2R: TSpinEdit;
    eM2C: TSpinEdit;
    eM3R: TSpinEdit;
    eM3C: TSpinEdit;
    M1: TStringGrid;
    M2: TStringGrid;
    M3: TStringGrid;
    StaticText1: TStaticText;
    BufferGrid: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure CalculateClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure ClearGridClick(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure DeleteSelectedClick(Sender: TObject);

    procedure eM1CChange(Sender: TObject);
    procedure eM1RChange(Sender: TObject);
    procedure eM2CChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MValidateEntry(sender: TObject; aCol, aRow: Integer;
      const OldValue: string; var NewValue: String);
    procedure PageControl1Change(Sender: TObject);
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
  CompleteMatrix(M1);
  CompleteMatrix(M2);
  CompleteMatrix(M3);
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

procedure TMainForm.ClearGridClick(Sender: TObject);
var
  i: Integer;
begin
  for i:= 0 to high(Buffer) do
    Buffer[i].Destroy;
  setlength(Buffer, 0);

  BufferGrid.RowCount:= 1;
end;

procedure TMainForm.CalculateClick(Sender: TObject);
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

procedure TMainForm.ClearClick(Sender: TObject);
begin
  case tButton(Sender).Name of
    'Clear1': M1.Clean;
    'Clear2': M2.Clean;
    'Clear3': M3.Clean;
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

procedure TMainForm.PageControl1Change(Sender: TObject);
begin

end;

end.

