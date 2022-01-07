unit FootBallObjects;

interface

uses
  Scene, DrwShapeClasses, Painter, SysUtils, Graphics, Physics;

const
  cDBall = 0.33;
  cDPlayer = 1.1; //радиус владения с учетом шага

type

  // Класс футбольного поля (статичный объект - внутренний слой)
  TField = class(TSceneObject)
  strict private
    FBottom: Double;
    FTop: Double;
    FLeft: Double;
    FRight: Double;
  public
    // Расположение на сцене
    property Bottom: Double read FBottom write FBottom;
    property Top: Double read FTop write FTop;
    property Left: Double read FLeft write FLeft;
    property Right: Double read FRight write FRight;

    // Возвращает координату в пискелях части поля слева направо
    function GetXByPart(APart: Double): Double;
    // Возвращает координату в пикселях части поля снизу вверх
    function GetYByPart(APart: Double): Double;
    procedure Build; override;
  end;

  // Класс мяча
  TBall = class(TDynamicSceneObj)
  strict private
    FRadius: Double;
    FWithPlayer: Boolean;
  public
    constructor Create;
    property Radius: Double read FRadius write FRadius;
    property WithPlayer: Boolean read FWithPlayer write FWithPlayer;
    procedure Build; override;
  end;

  //Базовый класс игрока
  TPlayer = class(TDynamicSceneObj)
  private
    FDefaultRole: String;
    FCurrentRole: String;
    FColor: TColor;
    FRadius: Double;
    FWithBall: Boolean;
  public
    property Radius: Double read FRadius write FRadius;
    property CurrentRole: String read FCurrentRole write FCurrentRole;
    property DefaultRole: String read FDefaultRole write FDefaultRole;
    property Color: TColor read FColor write FColor;
    property WithBall: Boolean read FWithBall write FWithBall;

    procedure Build; override;
  end;

implementation

procedure TField.Build;
var
  vDrwFrame, vDrwBR1, vDrwBR2, vDrwBR3,
  vDrwTR1, vDrwTR2, vDrwTR3: TDrwRect;
  vDrwMiddleLine: TDrwLine;
  vDrwMiddleCircle, vDrwCenter,
  vDrwTPoint, vDrwBPoint: TDrwCircle;
  vDrwTArc, vDrwBArc, vDrwTLArc, vDrwTRArc,
  vDrwBLArc, vDrwBRArc: TDrwSector;
  v0, v1: Double;
begin
  DrwObjList.Clear;

  //Границы поля
  vDrwFrame := TDrwRect.Create;
  vDrwFrame.Center.X := GetXByPart(0.5);
  vDrwFrame.Center.Y := GetYByPart(0.5);
  vDrwFrame.Height := Top - Bottom;
  vDrwFrame.Width := Right - Left;
  vDrwFrame.BrushColor := clGreen;
  vDrwFrame.Color := clWhite;
  DrwObjList.Add(vDrwFrame);

  // Середина поля
  vDrwMiddleLine := TDrwLine.Create;
  vDrwMiddleLine.StartPoint.Y := GetYByPart(0.5);
  vDrwMiddleLine.StartPoint.X := Left;
  vDrwMiddleLine.EndPoint := TDrwPoint.Create;
  vDrwMiddleLine.EndPoint.Y := GetYByPart(0.5);
  vDrwMiddleLine.EndPoint.X := Right;
  vDrwMiddleLine.Color := clWhite;
  DrwObjList.Add(vDrwMiddleLine);

  vDrwMiddleCircle := TDrwCircle.Create;
  vDrwMiddleCircle.Center.X := GetXByPart(0.5);
  vDrwMiddleCircle.Center.Y := GetYByPart(0.5);
  vDrwMiddleCircle.Radius := 9.15 * Scale;
  vDrwMiddleCircle.IsGlass := True;
  vDrwMiddleCircle.Color := clWhite;
  DrwObjList.Add(vDrwMiddleCircle);

  vDrwCenter := TDrwCircle.Create;
  vDrwCenter.Center.X := GetXByPart(0.5);
  vDrwCenter.Center.Y := GetYByPart(0.5);
  vDrwCenter.Radius := cDBall * Scale;
  vDrwCenter.BrushColor := clWhite;
  vDrwCenter.Color := clWhite;
  DrwObjList.Add(vDrwCenter);

  //Верхняя половина
  vDrwTR1 := TDrwRect.Create;
  vDrwTR1.Center.X := GetXByPart(0.5);
  vDrwTR1.Center.Y := Top - 8.25 * Scale;
  vDrwTR1.Width := 40.32 * Scale;
  vDrwTR1.Height := 16.50 * Scale;
  vDrwTR1.BrushColor := clGreen;
  vDrwTR1.Color := clWhite;
  DrwObjList.Add(vDrwTR1);

  vDrwTR2 := TDrwRect.Create;
  vDrwTR2.Center.X := GetXByPart(0.5);
  vDrwTR2.Center.Y := Top - 2.75 * Scale;
  vDrwTR2.Width := 18.32 * Scale;
  vDrwTR2.Height := 5.50 * Scale;
  vDrwTR2.BrushColor := clGreen;
  vDrwTR2.Color := clWhite;
  DrwObjList.Add(vDrwTR2);

  vDrwTR3 := TDrwRect.Create;
  vDrwTR3.Center.X := GetXByPart(0.5);
  vDrwTR3.Center.Y := Top - 0.2 * Scale;
  vDrwTR3.Width := 7.32 * Scale;
  vDrwTR3.Height := 0.4 * Scale;
  vDrwTR3.PenWidth := 2;
  vDrwTR3.Color := clWhite;
  DrwObjList.Add(vDrwTR3);

  vDrwTPoint := TDrwCircle.Create;
  vDrwTPoint.Center.X := GetXByPart(0.5);
  vDrwTPoint.Center.Y := Top - 11 * Scale;
  vDrwTPoint.Radius := vDrwCenter.Radius;
  vDrwTPoint.BrushColor := clWhite;
  vDrwTPoint.Color := clWhite;
  DrwObjList.Add(vDrwTPoint);

  vDrwTArc := TDrwSector.Create;
  vDrwTArc.Center.X := GetXByPart(0.5);
  vDrwTArc.Center.Y := Top - 11 * Scale;
  vDrwTArc.Radius := 9.15 * Scale;
  vDrwTArc.BeginPoint.Y := Top - 16.50 * Scale;
  vDrwTArc.EndPoint.Y := vDrwTArc.BeginPoint.Y;
  GetXValuesByCircle(vDrwTArc.Center.X, vDrwTArc.Center.Y, vDrwTArc.Radius,
    vDrwTArc.EndPoint.Y, v0, v1);
  vDrwTArc.BeginPoint.X := v0;
  vDrwTArc.EndPoint.X := v1;
  vDrwTArc.IsGlass := True;
  vDrwTArc.Color := clWhite;
  DrwObjList.Add(vDrwTArc);

  vDrwTLArc := TDrwSector.Create;
  vDrwTLArc.Center.X := Left;
  vDrwTLArc.Center.Y := Top;
  vDrwTLArc.Radius := Scale;
  vDrwTLArc.BeginPoint.X := Left + 1;
  vDrwTLArc.BeginPoint.Y := Top - Scale;
  vDrwTLArc.EndPoint.X := Left + Scale;
  vDrwTLArc.EndPoint.Y := Top;
  vDrwTLArc.IsGlass := True;
  vDrwTLArc.Color := clWhite;
  DrwObjList.Add(vDrwTLArc);

  vDrwTRArc := TDrwSector.Create;
  vDrwTRArc.Center.X := Right;
  vDrwTRArc.Center.Y := Top;
  vDrwTRArc.Radius := Scale;
  vDrwTRArc.EndPoint.X := Right - 1;
  vDrwTRArc.EndPoint.Y := Top - Scale;
  vDrwTRArc.BeginPoint.X := Right - Scale;
  vDrwTRArc.BeginPoint.Y := Top;
  vDrwTRArc.IsGlass := True;
  vDrwTRArc.Color := clWhite;
  DrwObjList.Add(vDrwTRArc);

  //Нижняя половина
  vDrwBR1 := TDrwRect.Create;
  vDrwBR1.Center.X := GetXByPart(0.5);
  vDrwBR1.Center.Y := Bottom + 8.25 * Scale;
  vDrwBR1.Width := 40.32 * Scale;
  vDrwBR1.Height := 16.50 * Scale;
  vDrwBR1.BrushColor := clGreen;
  vDrwBR1.Color := clWhite;
  DrwObjList.Add(vDrwBR1);

  vDrwBR2 := TDrwRect.Create;
  vDrwBR2.Center.X := GetXByPart(0.5);
  vDrwBR2.Center.Y := Bottom + 2.75 * Scale;
  vDrwBR2.Width := 18.32 * Scale;
  vDrwBR2.Height := 5.50 * Scale;
  vDrwBR2.BrushColor := clGreen;
  vDrwBR2.Color := clWhite;
  DrwObjList.Add(vDrwBR2);

  vDrwBR3 := TDrwRect.Create;
  vDrwBR3.Center.X := GetXByPart(0.5);
  vDrwBR3.Center.Y := Bottom + 0.2 * Scale;
  vDrwBR3.Width := 7.32 * Scale;
  vDrwBR3.Height := 0.4 * Scale;
  vDrwBR3.PenWidth := 2;
  vDrwBR3.BrushColor := clGreen;
  vDrwBR3.Color := clWhite;
  DrwObjList.Add(vDrwBR3);

  vDrwBPoint := TDrwCircle.Create;
  vDrwBPoint.Center.X := GetXByPart(0.5);
  vDrwBPoint.Center.Y := Bottom + 11 * Scale;
  vDrwBPoint.Radius := vDrwCenter.Radius;
  vDrwBPoint.BrushColor := clWhite;
  vDrwBPoint.Color := clWhite;
  DrwObjList.Add(vDrwBPoint);

  vDrwBArc := TDrwSector.Create;
  vDrwBArc.Center.X := GetXByPart(0.5);
  vDrwBArc.Center.Y := Bottom + 11 * Scale;
  vDrwBArc.Radius := 9.15 * Scale;
  vDrwBArc.BeginPoint.Y := Bottom + 16.50 * Scale;
  vDrwBArc.EndPoint.Y := vDrwBArc.BeginPoint.Y;
  GetXValuesByCircle(vDrwBArc.Center.X, vDrwBArc.Center.Y, vDrwBArc.Radius,
    vDrwBArc.EndPoint.Y, v0, v1);
  vDrwBArc.EndPoint.X := v0;
  vDrwBArc.BeginPoint.X := v1;
  vDrwBArc.IsGlass := True;
  vDrwBArc.Color := clWhite;
  DrwObjList.Add(vDrwBArc);

  vDrwBLArc := TDrwSector.Create;
  vDrwBLArc.Center.X := Left;
  vDrwBLArc.Center.Y := Bottom;
  vDrwBLArc.Radius := Scale;
  vDrwBLArc.EndPoint.X := Left + 1;
  vDrwBLArc.EndPoint.Y := Bottom + Scale;
  vDrwBLArc.BeginPoint.X := Left + Scale;
  vDrwBLArc.BeginPoint.Y := Bottom;
  vDrwBLArc.IsGlass := True;
  vDrwBLArc.Color := clWhite;
  DrwObjList.Add(vDrwBLArc);

  vDrwBRArc := TDrwSector.Create;
  vDrwBRArc.Center.X := Right;
  vDrwBRArc.Center.Y := Bottom;
  vDrwBRArc.Radius := Scale;
  vDrwBRArc.BeginPoint.X := Right - 1;
  vDrwBRArc.BeginPoint.Y := Bottom + Scale;
  vDrwBRArc.EndPoint.X := Right - Scale;
  vDrwBRArc.EndPoint.Y := Bottom;
  vDrwBRArc.IsGlass := True;
  vDrwBRArc.Color := clWhite;
  DrwObjList.Add(vDrwBRArc);
end;

{ TBall }

procedure TBall.Build;
var
  vDrwCircle: TDrwCircle;
begin
  DrwObjList.Clear;
  if WithPlayer then
    Exit;

  vDrwCircle := TDrwCircle.Create;
  vDrwCircle.Center.X := X;
  vDrwCircle.Center.Y := Y;
  vDrwCircle.Radius := Radius;
  vDrwCircle.Color := clWhite;
  vDrwCircle.BrushColor := clRed;

  DrwObjList.Add(vDrwCircle);
end;

constructor TBall.Create;
begin
  inherited;
  WithPlayer := True;
end;

{ TPlayer }

procedure TPlayer.Build;
var
  vDrwCircle, vDrwBall: TDrwCircle;
begin
  DrwObjList.Clear;
  vDrwCircle := TDrwCircle.Create;
  vDrwCircle.Center.X := X;
  vDrwCircle.Center.Y := Y;
  vDrwCircle.Radius := Radius;
  vDrwCircle.Color := clWhite;
  vDrwCircle.BrushColor := Color;
  DrwObjList.Add(vDrwCircle);

  if WithBall then
  begin
    vDrwBall := TDrwCircle.Create;
    vDrwBall.Center.X := X;
    vDrwBall.Center.Y := Y;
    vDrwBall.Radius := Radius/2.2;
    vDrwBall.Color := clWhite;
    vDrwBall.BrushColor := clRed;
    DrwObjList.Add(vDrwBall);
  end;
end;

function TField.GetXByPart(APart: Double): Double;
begin
  Result := Left + (Right - Left) * APart;
end;

function TField.GetYByPart(APart: Double): Double;
begin
  Result := Bottom + (Top - Bottom) * APart;
end;

end.
