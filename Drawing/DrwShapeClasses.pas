unit DrwShapeClasses;

interface

uses
  Graphics, Generics.Defaults, Generics.Collections, Types;

type

  TDrwPoint = class
  strict private
    FX: Double;
    FY: Double;
  public
    property X: Double read FX write FX;
    property Y: Double read FY write FY;
  end;

  TDrwShape = class
  strict private
    FID: Integer;
    FScObjName: String;
    FGroupCode: String;
    FCodeElement: String;
    FColor: TColor;
    FPenWidth: Integer;
    FByGroup: Boolean;
    FVisible: Boolean;
    FBrushColor: TColor;
    FIsGlass: Boolean;
  public
    constructor Create;

    property ID: Integer read FID write FID;
    property ScObjName: String read FScObjName write FScObjName;
    property GroupCode: String read FGroupCode write FGroupCode;
    property CodeElement: String read FCodeElement write FCodeElement;
    property Color: TColor read FColor write FColor;
    property BrushColor: TColor read FBrushColor write FBrushColor;
    property PenWidth: Integer read FPenWidth write FPenWidth;
    property ByGroup: Boolean read FByGroup write FByGroup;
    property Visible: Boolean read FVisible write FVisible;
    property IsGlass: Boolean read FIsGlass write FIsGlass;

    procedure ReCalcY(AHeight: Double); virtual; abstract;
    procedure Draw(ALayer: TBitmap); virtual; abstract;
  end;

  TDrwLine = class(TdrwShape)
  strict private
    FStartPoint: TDrwPoint;
    FEndPoint: TDrwPoint;
  public
    constructor Create;
    destructor Destroy; override;

    property StartPoint: TDrwPoint read FStartPoint write FStartPoint;
    property EndPoint: TDrwPoint read FEndPoint write FEndPoint;

    procedure ReCalcY(AHeight: Double); override;
    procedure Draw(ALayer: TBitmap); override;
  end;

  TDrwPolyLine = class(TdrwShape)
  strict private
    FDrwPointList: TList<TDrwPoint>;
  public
    constructor Create;
    destructor Destroy; override;

    property DrwPointList: TList<TDrwPoint> read FDrwPointList write FDrwPointList;

    function GetYByX(AX: Double): Double;

    procedure ReCalcY(AHeight: Double); override;
    procedure Draw(ALayer: TBitmap); override;
  end;

  TDrwLabel = class(TdrwShape)
  strict private
    FText: String;
    FX: Double;
    FY: Double;
  public
    property Text: String read FText write FText;
    property X: Double read FX write FX;
    property Y: Double read FY write FY;

    procedure ReCalcY(AHeight: Double); override;
    procedure Draw(ALayer: TBitmap); override;
  end;

  TDrwCircle = class(TdrwShape)
  strict private
    FCenter: TDrwPoint;
    FRadius: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property Center: TDrwPoint read FCenter write FCenter;
    property Radius: Double read FRadius write FRadius;

    procedure ReCalcY(AHeight: Double); override;
    procedure Draw(ALayer: TBitmap); override;
  end;

  TDrwSector = class(TDrwCircle)
  strict private
    // Сектор "рисуется слева направо"
    FBeginPoint: TDrwPoint;
    FEndPoint: TDrwPoint;
  public
    constructor Create;
    destructor Destroy; override;

    property BeginPoint: TDrwPoint read FBeginPoint write FBeginPoint;
    property EndPoint: TDrwPoint read FEndPoint write FEndPoint;

    procedure ReCalcY(AHeight: Double); override;
    procedure Draw(ALayer: TBitmap); override;
  end;

  TDrwRect = class(TdrwShape)
  strict private
    FCenter: TDrwPoint;
    FWidth: Double;
    FHeight: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property Center: TDrwPoint read FCenter write FCenter;
    property Width: Double read FWidth write FWidth;
    property Height: Double read FHeight write FHeight;

    procedure ReCalcY(AHeight: Double); override;
    procedure Draw(ALayer: TBitmap); override;
  end;

  TDrwShapeList = class(TObjectList<TDrwShape>)
  public
    procedure AddShape(AShape: TdrwShape);
  end;

implementation

constructor TDrwShape.Create;
begin
  ID := 0;
  PenWidth := 1;
  Color := clBlack;
  ByGroup := False;
  Visible := True;
  BrushColor := clWhite;
  IsGlass := False;
end;

{ TDrwShapeList }

procedure TDrwShapeList.AddShape(AShape: TdrwShape);
begin
  if AShape.ID <> 0 then
    AShape.ID := Self.Count + 1;
  Self.Add(AShape);
end;

{ TDrwCircle }

constructor TDrwCircle.Create;
begin
  inherited;
  Center := TDrwPoint.Create;
end;

destructor TDrwCircle.Destroy;
begin
  Center.Free;
  inherited;
end;

procedure TDrwCircle.Draw(ALayer: TBitmap);
var
  vBrushStyle: TBrushStyle;
  vBrushColor: TColor;
  vColor: TColor;
  vPenWidth: Integer;
begin
  if not Visible then
    Exit;
  vBrushStyle := ALayer.Canvas.Brush.Style;
  vBrushColor := ALayer.Canvas.Brush.Color;
  vColor := ALayer.Canvas.Pen.Color;
  vPenWidth := ALayer.Canvas.Pen.Width;
  try
    ALayer.Canvas.Pen.Width := PenWidth;
    ALayer.Canvas.Pen.Color := Color;
    ALayer.Canvas.Brush.Color := BrushColor;
    if IsGlass then
      ALayer.Canvas.Brush.Style := bsClear;
    ALayer.Canvas.Ellipse(Trunc(Center.X - Radius),
                          Trunc(Center.Y - Radius),
                          Trunc(Center.X + Radius),
                          Trunc(Center.Y + Radius));
  finally
    ALayer.Canvas.Pen.Color := vColor;
    ALayer.Canvas.Brush.Style := vBrushStyle;
    ALayer.Canvas.Brush.Color := vBrushColor;
    ALayer.Canvas.Pen.Width := vPenWidth;
  end;
end;

procedure TDrwCircle.ReCalcY(AHeight: Double);
begin
  Center.Y := AHeight - Center.Y;
end;

{ TDrwLine }

constructor TDrwLine.Create;
begin
  inherited;
  StartPoint := TDrwPoint.Create;
  EndPoint := TDrwPoint.Create;
end;

destructor TDrwLine.Destroy;
begin
  StartPoint.Free;
  EndPoint.Free;
  inherited;
end;

procedure TDrwLine.Draw(ALayer: TBitmap);
var
  vBrushStyle: TBrushStyle;
  vColor: TColor;
begin
  if not Visible then
    Exit;
  vBrushStyle := ALayer.Canvas.Brush.Style;
  vColor := ALayer.Canvas.Pen.Color;
  try
    ALayer.Canvas.Pen.Color := Color;
    ALayer.Canvas.Brush.Style := bsClear;
    ALayer.Canvas.MoveTo(Trunc(StartPoint.X), Trunc(StartPoint.Y));
    ALayer.Canvas.LineTo(Trunc(EndPoint.X), Trunc(EndPoint.Y));
  finally
    ALayer.Canvas.Pen.Color := vColor;
    ALayer.Canvas.Brush.Style := vBrushStyle;
  end;
end;

procedure TDrwLine.ReCalcY(AHeight: Double);
begin
  StartPoint.Y := AHeight - StartPoint.Y;
  EndPoint.Y := AHeight - EndPoint.Y;
end;

{ TDrwPolyLine }

constructor TDrwPolyLine.Create;
begin
  inherited;
  DrwPointList := TList<TDrwPoint>.Create;
end;

destructor TDrwPolyLine.Destroy;
begin
  DrwPointList.Free;
  inherited;
end;

procedure TDrwPolyLine.Draw(ALayer: TBitmap);
var
  vBrushStyle: TBrushStyle;
  vBrushColor: TColor;
  vColor: TColor;
  vPointArray: array of TPoint;
  I: Integer;
  vPenWidth : Integer;
begin
  if not Visible then
    Exit;
  vBrushStyle := ALayer.Canvas.Brush.Style;
  vBrushColor := ALayer.Canvas.Brush.Color;
  vColor := ALayer.Canvas.Pen.Color;
  vPenWidth := ALayer.Canvas.Pen.Width;
  try
    ALayer.Canvas.Pen.Width := PenWidth;
    ALayer.Canvas.Pen.Color := Color;
    ALayer.Canvas.Brush.Color := BrushColor;
    SetLength(vPointArray, DrwPointList.Count);
    for I := 0 to DrwPointList.Count - 1 do
    begin
      vPointArray[I].X := Trunc(DrwPointList[I].X);
      vPointArray[I].Y := Trunc(DrwPointList[I].Y);
    end;
    ALayer.Canvas.Polyline(vPointArray);
  finally
    ALayer.Canvas.Pen.Color := vColor;
    ALayer.Canvas.Brush.Color := vBrushColor;
    ALayer.Canvas.Brush.Style := vBrushStyle;
    ALayer.Canvas.Pen.Width := vPenWidth;
  end;
end;

function TDrwPolyLine.GetYByX(AX: Double): Double;
var
  I, vIndex0, vIndex1: Integer;
begin
  if AX <= DrwPointList[0].X then
    Exit(DrwPointList[0].Y);
  if AX >= DrwPointList[DrwPointList.Count - 1].X then
    Exit(DrwPointList[DrwPointList.Count - 1].Y);

  vIndex0 := 0;
  vIndex1 := 0;
  for I := 0 to DrwPointList.Count - 1 do
    if DrwPointList[I].X > AX then
    begin
      vIndex1 := I;
      vIndex0 := I - 1;
      Break;
    end;
  Result := DrwPointList[vIndex0].Y +
    (((DrwPointList[vIndex1].Y - DrwPointList[vIndex0].Y)*(AX - DrwPointList[vIndex0].X))
      /((DrwPointList[vIndex1]).X - DrwPointList[vIndex0].X));
end;

procedure TDrwPolyLine.ReCalcY(AHeight: Double);
var
  vPoint: TDrwPoint;
begin
  for vPoint in DrwPointList do
      vPoint.Y := AHeight - vPoint.Y;
end;

{ TDrwLabel }

procedure TDrwLabel.Draw(ALayer: TBitmap);
begin
  ALayer.Canvas.TextOut(Trunc(X), Trunc(Y), Text);
end;

procedure TDrwLabel.ReCalcY(AHeight: Double);
begin
  Y := AHeight - Y;
end;

{ TDrwRect }

constructor TDrwRect.Create;
begin
  inherited;
  Center := TDrwPoint.Create;
end;

destructor TDrwRect.Destroy;
begin
  Center.Free;
  inherited;
end;

procedure TDrwRect.Draw(ALayer: TBitmap);
var
  vBrushStyle: TBrushStyle;
  vBrushColor: TColor;
  vColor: TColor;
  vPenWidth: Integer;
begin
  if not Visible then
    Exit;
  vBrushStyle := ALayer.Canvas.Brush.Style;
  vBrushColor := ALayer.Canvas.Brush.Color;
  vColor := ALayer.Canvas.Pen.Color;
  vPenWidth := ALayer.Canvas.Pen.Width;
  try
    ALayer.Canvas.Pen.Width := PenWidth;
    ALayer.Canvas.Pen.Color := Color;
    ALayer.Canvas.Brush.Color := BrushColor;
    if IsGlass then
      ALayer.Canvas.Brush.Style := bsClear;
    ALayer.Canvas.Rectangle(Trunc(Center.X - Width/2),
                          Trunc(Center.Y - Height/2),
                          Trunc(Center.X + Width/2),
                          Trunc(Center.Y + Height/2));
  finally
    ALayer.Canvas.Pen.Color := vColor;
    ALayer.Canvas.Brush.Style := vBrushStyle;
    ALayer.Canvas.Brush.Color := vBrushColor;
    ALayer.Canvas.Pen.Width := vPenWidth;
  end;
end;

procedure TDrwRect.ReCalcY(AHeight: Double);
begin
  Center.Y := AHeight - Center.Y;
end;

{ TDrwSector }

constructor TDrwSector.Create;
begin
  inherited;
  BeginPoint := TDrwPoint.Create;
  EndPoint := TDrwPoint.Create;
end;

destructor TDrwSector.Destroy;
begin
  BeginPoint.Free;
  EndPoint.Free;
  inherited;
end;

procedure TDrwSector.Draw(ALayer: TBitmap);
var
  vBrushStyle: TBrushStyle;
  vBrushColor: TColor;
  vColor: TColor;
  vPenWidth: Integer;
begin
  if not Visible then
    Exit;
  vBrushStyle := ALayer.Canvas.Brush.Style;
  vBrushColor := ALayer.Canvas.Brush.Color;
  vColor := ALayer.Canvas.Pen.Color;
  vPenWidth := ALayer.Canvas.Pen.Width;
  try
    ALayer.Canvas.Pen.Width := PenWidth;
    ALayer.Canvas.Pen.Color := Color;
    ALayer.Canvas.Brush.Color := BrushColor;
    if IsGlass then
      ALayer.Canvas.Brush.Style := bsClear;
    ALayer.Canvas.Arc(Trunc(Center.X - Radius),
                      Trunc(Center.Y - Radius),
                      Trunc(Center.X + Radius),
                      Trunc(Center.Y + Radius),
                      Trunc(BeginPoint.X),
                      Trunc(BeginPoint.Y),
                      Trunc(EndPoint.X),
                      Trunc(EndPoint.Y));
  finally
    ALayer.Canvas.Pen.Color := vColor;
    ALayer.Canvas.Brush.Style := vBrushStyle;
    ALayer.Canvas.Brush.Color := vBrushColor;
    ALayer.Canvas.Pen.Width := vPenWidth;
  end;
end;

procedure TDrwSector.ReCalcY(AHeight: Double);
begin
  inherited;
  BeginPoint.Y := AHeight - BeginPoint.Y;
  EndPoint.Y := AHeight - EndPoint.Y;
end;

end.
