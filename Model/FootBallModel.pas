unit FootBallModel;

interface

uses
  Scene, Painter, SysUtils, FootBallObjects, StrUtils, Math,
  Generics.Defaults, Generics.Collections, Physics, Graphics;

const
  //размеры в метрах
  cFieldLength = 105;
  cFieldWidth = 68;
  cSpeed = 5; // м/с
  //Схемы расстановки по умолчанию
  cScheme433 = '4-3-3';

  //Роли игроков
  cGK = 'GK';
  cLD = 'LD';
  cLCD = 'LCD';
  cRCD = 'RCD';
  cRD = 'RD';
  cLM = 'LM';
  cCM = 'CM';
  cRM = 'RM';
  cLF = 'LF';
  cCF = 'CF';
  cRF = 'RF';

type

  TFBScene = class;

  TTeamPhase = (tpPosAttack, tpForceAttack, tpPress, tpTikiTaka, tpDefend);

  TTeam = class
  private
    FScene: TFBScene;
    FDefaultScheme: String;
    FCurrentScheme: String;
    FPlayerList: TObjectList<TPlayer>;
  public
    constructor Create(AScene: TFBScene);
    destructor Destroy; override;

    property Scene: TFBScene read FScene write FScene;
    //Схема расстановки по умолчанию
    property CurrentScheme: String read FCurrentScheme write FCurrentScheme;
    property DefaultScheme: String read FDefaultScheme write FDefaultScheme;
    property PlayerList: TObjectList<TPlayer> read FPlayerList write FPlayerList;

    procedure SetScheme(AScheme: String = '');
    procedure CreateLineUp(AIsHome: Boolean);
    function GetPlayer(ARole: String): TPlayer;
    function GetPlayerWithBall: TPlayer;
  end;

  TMatchModel = class
  private
    FScene: TFBScene;
    FIsFirstPass: Boolean;
    FLastRoleWithBall: String;
    FCounter: Integer;
    FCountForStart: Integer;
  public
    constructor Create(AScene: TFBScene);

    property Scene: TFBScene read FScene write FScene;
    property IsFirstPass: Boolean read FIsFirstPass write FIsFirstPass;
    property LastRoleWithBall: String read
      FLastRoleWithBall write FLastRoleWithBall;

    //Общее внешнее управление
    //Начало матча
    procedure KickOff;
    //действие до начала события (пас дошел)
    procedure Processing;

    //Внутренняя реализация обработки запросов
    function GetPlayerForPass(Player: TPlayer; ATeam: TTeam; ARisky, ACross: Boolean): TPlayer;
    procedure ReCalcMoveDirection(AObj: TDynamicSceneObj; AXTo, AYTo: Double);
    function BallMeetObject: TSceneObject;
    function CheckStateBall: Boolean;
    procedure NextPass;
    procedure DoPass(APlayerFrom: TPlayer; AToRole: String);
    procedure Update;
    function IsUpdate: Boolean;
  end;

  // Класс сцены футбольного матча
  TFBScene = class(TScene)
  strict private
    FBall: TBall;
    FField: TField;
    FMyTeam: TTeam;
    FEnemyTeam: TTeam;
    FMatchModel: TMatchModel;
  public
    constructor Create;

    //Объекты сцены
    property Field: TField read FField write FField;
    property Ball: TBall read FBall write FBall;
    property MyTeam: TTeam read FMyTeam write FMyTeam;
    property EnemyTeam: TTeam read FEnemyTeam write FEnemyTeam;
    //Интеллект поведения в матче
    property MatchModel: TMatchModel read FMatchModel write FMatchModel;

    // Интерфейс загрузки сцены и модели объектов
    procedure SetScale; override;
    procedure BuildUp; override;
    function CalcNextFrame: Boolean; override;

    // Конвертация координат
    function GetXmByPxl(AXPxlValue: Double): Double;
    function GetYmByPxl(AYPxlValue: Double): Double;
  end;

implementation

{ TMatchModel }

function TMatchModel.BallMeetObject: TSceneObject;
var
  vPlayer: TPlayer;
begin
  Result := nil;
  with Scene do
  begin
    for vPlayer in MyTeam.PlayerList do
      if PointInCircle(vPlayer.X, vPlayer.Y, vPlayer.Radius, Ball.X, Ball.Y) then
        Result := vPlayer;
    if Assigned(Result) then
      Exit;

    for vPlayer in EnemyTeam.PlayerList do
      if PointInCircle(vPlayer.X, vPlayer.Y, vPlayer.Radius, Ball.X, Ball.Y) then
        Result := vPlayer;
    if Assigned(Result) then
      Exit;

    if ((Ball.X - Ball.Radius) <= Field.Left) or
       ((Ball.X + Ball.Radius) >= Field.Right) or
       ((Ball.Y - Ball.Radius) <= Field.Bottom) or
       ((Ball.Y + Ball.Radius) >= Field.Top) then
       Result := Field;
    end;
end;

function TMatchModel.CheckStateBall: Boolean;
var
  vObj: TSceneObject;
begin
  Result := False;
  vObj := BallMeetObject;
  if (vObj is TPlayer) and
    (TPlayer(vObj).DefaultRole <> LastRoleWithBall) then
  begin
    TPlayer(vObj).WithBall := True;
    Exit(True);
  end;
end;

constructor TMatchModel.Create(AScene: TFBScene);
begin
  IsFirstPass := True;
  Scene := AScene;
  FCounter := 0;
end;

procedure TMatchModel.DoPass(APlayerFrom: TPlayer; AToRole: String);
var
  vPlayerTo: TPlayer;
begin
  vPlayerTo := Scene.MyTeam.GetPlayer(AToRole);
  ReCalcMoveDirection(Scene.Ball, vPlayerTo.X, vPlayerTo.Y);
  APlayerFrom.WithBall := False;
  Scene.Ball.WithPlayer := False;
  LastRoleWithBall := APlayerFrom.DefaultRole;
end;

function TMatchModel.GetPlayerForPass(Player: TPlayer; ATeam: TTeam; ARisky,
  ACross: Boolean): TPlayer;
var
  vPlayer: TPlayer;
begin
    (*
      поиск принимающего пас:
      1)вычисляется список игроков, которые во время t+ATime, смогут принять мяч
      если рискованный, то список игроков на уровне или выше линии мяча, может быть кросс
      если надежный, то ниже линии мяча, только низом
      2)надежный пас - выбираем из списка с минимальным отклонением по вертикали,
        рискованный, тому игроку, которого меньше опекают или он готов
        открыться на свободное пространство
      3)если первый список пуст, то надежный пас с минимальным инвертированным отклонением по горизонтали
    *)
  Result := nil;
  //ACross - пас навесом - заглушка = пас низом
  for vPlayer in ATeam.PlayerList do
  begin
    if ARisky then

  end;

end;

function TMatchModel.IsUpdate: Boolean;
begin
  Result := False;
  if FCountForStart = 0 then
    FCountForStart := 1 + Random(10);
  if FCounter = FCountForStart then
  begin
    FCounter := 0;
    FCountForStart := 0;
    Result := True;
  end;
end;

procedure TMatchModel.KickOff;
var
  vPlayerFrom, vPlayerTo: TPlayer;
begin
  //Выбор разыгрывающей команды - заглушка = моя команда
  vPlayerFrom := Scene.MyTeam.GetPlayer(cGK);
//  vPlayerTo := GetPlayerForPass(vPlayerFrom, Scene.MyTeam, False, False);
  DoPass(vPlayerFrom, cLD);
end;

procedure TMatchModel.NextPass;
var
  vPlayerWithBall: TPlayer;
  vNum: Integer;
  vStr: String;
begin
  vStr := '';
  vPlayerWithBall := Scene.MyTeam.GetPlayerWithBall;

  repeat
    vNum := Random(11);
    case vNum of
      0: vStr := cLD;
      1: vStr := cLCD;
      2: vStr := cRCD;
      3: vStr := cRD;
      4: vStr := cLM;
      5: vStr := cCM;
      6: vStr := cGK;
      7: vStr := cRD;
      8: vStr := cLF;
      9: vStr := cCF;
      10: vStr := cRF;
    end;
  until (vStr <> vPlayerWithBall.DefaultRole);

  DoPass(vPlayerWithBall, vStr);
end;

procedure TMatchModel.Processing;
var
  vPlayer: TPlayer;
  vSign: Boolean;
begin
  with Scene do
  begin
    //Движение мяча
    if not Ball.WithPlayer then
    begin
      Ball.X := Ball.X + Ball.Speed * Ball.dX;
      Ball.Y := Ball.Amove * Ball.X + Ball.Bmove;
    end;
    //Передвижение игроков
    for vPlayer in MyTeam.PlayerList do
    begin
      if vPlayer.DefaultRole = cGK then
        Continue;
      vPlayer.X := vPlayer.X + vPlayer.Speed * vPlayer.dX;
      vPlayer.Y := vPlayer.Amove * vPlayer.X + vPlayer.Bmove;
    end;
  end;
end;

procedure TMatchModel.ReCalcMoveDirection(AObj: TDynamicSceneObj; AXTo, AYTo: Double);
var
  vDeltaX, vDeltaY, vS: Double;
begin
  //Расчет коэффицинтов прямой
  AObj.Amove := (AYTo - AObj.Y) / (AXTo - AObj.X);
  AObj.Bmove := AYTo - AObj.Amove * AXTo;

  //Направление по оси Х
  if AXTo = AObj.X then
    AObj.dX := 0
  else if AXTo > AObj.X then
    AObj.dX := 1
  else if AXTo < AObj.X then
    AObj.dX := -1;

  //расчет скорости
  vDeltaX := abs(AXTo - AObj.X);
  vDeltaY := abs(AYTo - AObj.Y);
  vS := sqrt(vDeltaX*vDeltaX + vDeltaY*vDeltaY);
  AObj.Speed := (cSpeed * vDeltaX ) / vS;
end;

procedure TMatchModel.Update;
begin
  inc(FCounter);
end;

{ TFBScene }

procedure TFBScene.BuildUp;
var
  vXCenter, vYCenter: Double;
begin
  vXCenter := (XSceneEnd - XSceneBegin) / 2;
  vYCenter := (YSceneEnd - YSceneBegin) / 2;

  Field.Scale := Pxl_m;
  Field.Bottom := vYCenter - cFieldLength * Pxl_m / 2;
  Field.Top := vYCenter + cFieldLength * Pxl_m / 2;
  Field.Left := vXCenter - cFieldWidth * Pxl_m / 2;
  Field.Right := vXCenter + cFieldWidth * Pxl_m / 2;

  MyTeam.CreateLineUp(True);
  EnemyTeam.CreateLineUp(False);

  Ball.Scale := Pxl_m;
  Ball.Radius := Pxl_m * cDBall;
  Ball.X := Field.GetXByPart(0.5);
  Ball.Y := Field.GetYByPart(0.5);

end;

function TFBScene.CalcNextFrame: Boolean;
var
  vCheckStateBall: Boolean;
begin
  Result := False;
  //Kick off
  if MatchModel.IsFirstPass then
  begin
    MatchModel.KickOff;
    MatchModel.IsFirstPass := False;
  end;
  // расчет состояния моделей на сцене
  MatchModel.Processing;
  //Проверка на событие
  vCheckStateBall := MatchModel.CheckStateBall;
  if vCheckStateBall then
  begin
    Ball.WithPlayer := True;
    MatchModel.Update;
  end;
  // если произошли внутренние изменения отпасуем следующему игроку
  if vCheckStateBall and MatchModel.IsUpdate then
    MatchModel.NextPass;
end;

constructor TFBScene.Create;
var
  vPlayer: TPlayer;
begin
  inherited;
  Ball := TBall.Create;
  ObjectList.Add(Ball);
  Field := TField.Create;
  ObjectList.Add(Field);
  MyTeam := TTeam.Create(Self);
  MyTeam.SetScheme;
  for vPlayer in MyTeam.PlayerList do
    ObjectList.Add(vPlayer);
  EnemyTeam := TTeam.Create(Self);
  EnemyTeam.SetScheme;
  for vPlayer in EnemyTeam.PlayerList do
    ObjectList.Add(vPlayer);
  MatchModel := TMatchModel.Create(Self);
end;

function TFBScene.GetXmByPxl(AXPxlValue: Double): Double;
begin
  Result := (AXPxlValue - Field.Left) / Pxl_m;
end;

function TFBScene.GetYmByPxl(AYPxlValue: Double): Double;
begin
  Result := (AYPxlValue - Field.Bottom) / Pxl_m;
end;

procedure TFBScene.SetScale;
var
  vVrt: Double;
begin
  //Подбор наиболее подходящего масштаба, чтобы можно было
  //рационально расположить поле с заданными размерами

  vVrt := (YSceneEnd - 1) / cFieldLength;

  if (vVrt * cFieldWidth) <= (XSceneEnd - 1) then
    Pxl_m := vVrt
  else
    Pxl_m := (XSceneEnd - 1) / cFieldWidth;
end;

{ TTeam }

constructor TTeam.Create(AScene: TFBScene);
begin
  Scene := AScene;
  DefaultScheme := cScheme433;
  PlayerList := TObjectList<TPlayer>.Create;
end;

procedure TTeam.CreateLineUp(AIsHome: Boolean);
var
  vPlayer: TPlayer;
begin
  if AIsHome then
  begin
    for vPlayer in PlayerList do
    begin
      vPlayer.Scale := Scene.Pxl_m;
      vPlayer.Radius := vPlayer.Scale * cDPlayer;
      vPlayer.Color := clMenuHighlight;
      if vPlayer.DefaultRole = cGK then
      begin
        vPlayer.X := Scene.Field.GetXByPart(1/2);
        vPlayer.Y := Scene.Field.Bottom + 2 + vPlayer.Scale * cDPlayer / 2;
      end;
      //defs
      if vPlayer.DefaultRole = cLD then
      begin
        vPlayer.X := Scene.Field.GetXByPart(1/5);
        vPlayer.Y := Scene.Field.GetYByPart(1/6);
      end;
      if vPlayer.DefaultRole = cLCD then
      begin
        vPlayer.X := Scene.Field.GetXByPart(2/5);
        vPlayer.Y := Scene.Field.GetYByPart(1/6);
      end;
      if vPlayer.DefaultRole = cRCD then
      begin
        vPlayer.X := Scene.Field.GetXByPart(3/5);
        vPlayer.Y := Scene.Field.GetYByPart(1/6);
      end;
      if vPlayer.DefaultRole = cRD then
      begin
        vPlayer.X := Scene.Field.GetXByPart(4/5);
        vPlayer.Y := Scene.Field.GetYByPart(1/6);
      end;
      //m
      if vPlayer.DefaultRole = cLM then
      begin
        vPlayer.X := Scene.Field.GetXByPart(1/4);
        vPlayer.Y := Scene.Field.GetYByPart(2/6);
      end;
      if vPlayer.DefaultRole = cCM then
      begin
        vPlayer.X := Scene.Field.GetXByPart(2/4);
        vPlayer.Y := Scene.Field.GetYByPart(2/6);
      end;
      if vPlayer.DefaultRole = cRM then
      begin
        vPlayer.X := Scene.Field.GetXByPart(3/4);
        vPlayer.Y := Scene.Field.GetYByPart(2/6);
      end;
      //f
      if vPlayer.DefaultRole = cLF then
      begin
        vPlayer.X := Scene.Field.GetXByPart(1/4);
        vPlayer.Y := Scene.Field.GetYByPart(3/6);
      end;
      if vPlayer.DefaultRole = cCF then
      begin
        vPlayer.WithBall := True;
        vPlayer.X := Scene.Field.GetXByPart(2/4);
        vPlayer.Y := Scene.Field.GetYByPart(3/6);
      end;
      if vPlayer.DefaultRole = cRF then
      begin
        vPlayer.X := Scene.Field.GetXByPart(3/4);
        vPlayer.Y := Scene.Field.GetYByPart(3/6);
      end;
    end;
  end
  else
  begin
    for vPlayer in PlayerList do
    begin
      vPlayer.Scale := Scene.Pxl_m;
      vPlayer.Radius := vPlayer.Scale * cDPlayer;
      vPlayer.Color := clLime;
      if vPlayer.DefaultRole = cGK then
      begin
        vPlayer.X := Scene.Field.GetXByPart(1/2);
        vPlayer.Y := Scene.Field.Top - 2 - vPlayer.Scale * cDPlayer / 2;
      end;
      //defs
      if vPlayer.DefaultRole = cLD then
      begin
        vPlayer.X := Scene.Field.GetXByPart(1/5);
        vPlayer.Y := Scene.Field.GetYByPart(6/7);
      end;
      if vPlayer.DefaultRole = cLCD then
      begin
        vPlayer.X := Scene.Field.GetXByPart(2/5);
        vPlayer.Y := Scene.Field.GetYByPart(6/7);
      end;
      if vPlayer.DefaultRole = cRCD then
      begin
        vPlayer.X := Scene.Field.GetXByPart(3/5);
        vPlayer.Y := Scene.Field.GetYByPart(6/7);
      end;
      if vPlayer.DefaultRole = cRD then
      begin
        vPlayer.X := Scene.Field.GetXByPart(4/5);
        vPlayer.Y := Scene.Field.GetYByPart(6/7);
      end;
      //m
      if vPlayer.DefaultRole = cLM then
      begin
        vPlayer.X := Scene.Field.GetXByPart(1/4);
        vPlayer.Y := Scene.Field.GetYByPart(5/7);
      end;
      if vPlayer.DefaultRole = cCM then
      begin
        vPlayer.X := Scene.Field.GetXByPart(2/4);
        vPlayer.Y := Scene.Field.GetYByPart(5/7);
      end;
      if vPlayer.DefaultRole = cRM then
      begin
        vPlayer.X := Scene.Field.GetXByPart(3/4);
        vPlayer.Y := Scene.Field.GetYByPart(5/7);
      end;
      //f
      if vPlayer.DefaultRole = cLF then
      begin
        vPlayer.X := Scene.Field.GetXByPart(1/4);
        vPlayer.Y := Scene.Field.GetYByPart(4/7);
      end;
      if vPlayer.DefaultRole = cCF then
      begin
        vPlayer.X := Scene.Field.GetXByPart(2/4);
        vPlayer.Y := Scene.Field.GetYByPart(4/7);
      end;
      if vPlayer.DefaultRole = cRF then
      begin
        vPlayer.X := Scene.Field.GetXByPart(3/4);
        vPlayer.Y := Scene.Field.GetYByPart(4/7);
      end;
    end;
  end;
end;

destructor TTeam.Destroy;
begin
  PlayerList.Free;
  inherited;
end;

function TTeam.GetPlayer(ARole: String): TPlayer;
var
  vPlayer: TPlayer;
begin
  Result := nil;
  for vPlayer in PlayerList do
    if vPlayer.DefaultRole = ARole then
      Exit(vPlayer);
end;

function TTeam.GetPlayerWithBall: TPlayer;
var
  vPlayer: TPlayer;
begin
  Result := nil;
  for vPlayer in PlayerList do
    if vPlayer.WithBall then
      Exit(vPlayer);
end;

procedure TTeam.SetScheme(AScheme: String);
var
  vPlayer: TPlayer;
begin
  if AScheme = '' then
  begin
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cGK;
    PlayerList.Add(vPlayer);
    //Defs
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cLD;
    PlayerList.Add(vPlayer);
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cLCD;
    PlayerList.Add(vPlayer);
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cRCD;
    PlayerList.Add(vPlayer);
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cRD;
    PlayerList.Add(vPlayer);
    //Mildf
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cLM;
    PlayerList.Add(vPlayer);
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cCM;
    PlayerList.Add(vPlayer);
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cRM;
    PlayerList.Add(vPlayer);
    //Fw
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cLF;
    PlayerList.Add(vPlayer);
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cCF;
    PlayerList.Add(vPlayer);
    vPlayer := TPlayer.Create;
    vPlayer.DefaultRole := cRF;
    PlayerList.Add(vPlayer);
  end;
end;

end.
