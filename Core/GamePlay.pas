unit GamePlay;

interface

uses
  Scene, Generics.Collections, Generics.Defaults, Painter, Classes,
  Forms, FootBallModel;

type

  //������� ����� ��� ������� ����
  TGame = class
  strict private
    FScene: TScene;
    FDrawingManager: TDrawingManager;
    FIsPlay: Boolean;
  public
    constructor Create;
    destructor Destroy;  override;
    //���������� ����� � ��������� ��� ��������
    property Scene: TScene read FScene write FScene;
    //���������� - �������������� ������� ���������� � ������������ ����
    property DrawingManager: TDrawingManager read FDrawingManager write FDrawingManager;
    //����������
    property IsPlay: Boolean read FIsPlay write FIsPlay;

    //�������� ����������� � �����
    procedure InitDrwManager(APainter: TfrmPainter);
    procedure UpdateFrame;
    procedure LoadLayer(ALayerType: TLayerType);
    // ������� ����������
    procedure DoPlay;
    procedure DoStop;
  end;

var
  Game: TGame;

  function InitGame(AXSceneEnd, AYSceneEnd: Double): TGame;

implementation

uses
  SysUtils;

  //�������������� ��������
  function InitGame(AXSceneEnd, AYSceneEnd: Double): TGame;
  begin
    Result := TGame.Create;
    Result.Scene.InitCoordParams(AXSceneEnd, AYSceneEnd);
    Result.Scene.SetScale;
    Result.Scene.BuildUp;
    Game := Result;
  end;

constructor TGame.Create;
begin
  // ��������� ������ �������
  Scene := TFBScene.Create;
  DrawingManager := TDrawingManager.Create;
end;

destructor TGame.Destroy;
begin
  Scene.Free;
  DrawingManager.Free;
end;

procedure TGame.InitDrwManager(APainter: TfrmPainter);
begin
  DrawingManager.Painter := APainter;
  DrawingManager.Scene := Scene;
end;

procedure TGame.DoPlay;
begin
  IsPlay := True;
  while IsPlay do
  begin
    Scene.CalcNextFrame;
    UpdateFrame;
    Application.ProcessMessages;
    sleep(42);
  end;
end;

procedure TGame.DoStop;
begin
  IsPlay := False;
end;

procedure TGame.LoadLayer(ALayerType: TLayerType);
var
  vSceneObj: TSceneObject;
begin
  for vSceneObj in Scene.ObjectList do
    if vSceneObj.Layer = ALayerType then
      DrawingManager.LoadObjectFromScene(vSceneObj, ALayerType);
  DrawingManager.DrawLayer(ALayerType);
end;

procedure TGame.UpdateFrame;
begin
  DrawingManager.ClearFrontLayer;
  LoadLayer(ltFront);
  DrawingManager.Painter.Invalidate;
end;

end.



