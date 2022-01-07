unit Models;

interface

uses
  Generics.Defaults, Generics.Collections;

const
  //размеры в метрах
  cFieldLength = 110;
  cFieldWidth = 75;
  cSpeed = 3; // м/с
  cDBall = 0.23;

type

  TModel = class
  strict private
    FPxl_m: Double;
    FFieldLength: Double;
    FFieldWidth: Double;
    FSpeed: Double;
    FDirectionAngle: Integer;
    FDBall: Double;
  public
    constructor Create;
    //Масштаб
    property Pxl_m: Double read FPxl_m write FPxl_m;
    //Данные
    property FieldLength: Double read FFieldLength write FFieldLength;
    property FieldWidth: Double read FFieldWidth write FFieldWidth;
    property Speed: Double read FSpeed write FSpeed;
    property DirectionAngle: Integer read FDirectionAngle write FDirectionAngle;
    property DBall: Double read FDBall write FDBall;

    //Расчет линейного движения
    procedure CalcLineMove(AX, AY: Double);
    // Корректировка координат
    procedure CorrectDir(AX, AY: Double);
    // Проверка пересеения с границами
    function IsCrossBorders(AX, AY: Double): Boolean;
  end;

implementation

uses
  SysUtils;

{ TModel }

procedure TModel.CalcLineMove(AX, AY: Double);
begin
  AX := AX + cSpeed;
  AY := AY + cSpeed;

end;

procedure TModel.CorrectDir(AX, AY: Double);
begin

end;

constructor TModel.Create;
begin
  FieldLength := cFieldLength;
  FieldWidth := cFieldWidth;
  Speed := cSpeed;
  DBall := cDBall;
end;

function TModel.IsCrossBorders(AX, AY: Double): Boolean;
begin
  Result := False;

end;

end.
