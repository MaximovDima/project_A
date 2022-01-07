unit Scene;

interface

uses
  Types, Math, Generics.Collections, Generics.Defaults, DrwShapeClasses, Painter,
  SysUtils, Physics, Graphics;

type

  TScene = class;

  // �������� ����� ������� �����
  TSceneObject = class
  strict private
    FID: Integer;
    FLayer: TLayerType;
    FDrwObjList: TObjectList<TDrwShape>;
    FScale: Double;
    FVisible: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    property ID: Integer read FID write FID;
    property Layer: TLayerType read FLayer write FLayer;
    // ��������� ��������� ��� ���������
    property DrwObjList: TObjectList<TDrwShape> read FDrwObjList write FDrwObjList;
    property Scale: Double read FScale write FScale;
    property Visible: Boolean read FVisible write FVisible;

    // ���������� �� ����������
    procedure Build; virtual; abstract;
  end;

  // ���������� ������ � ����������
  TDrawingManager = class
  strict private
    FScene: TScene;
    FPainter: TfrmPainter;
  public
    property Painter: TfrmPainter read FPainter write FPainter;
    property Scene: TScene read FScene write FScene;

    procedure DrawLayer(ALayerType: TLayerType);
    procedure ClearFrontLayer;
    procedure LoadObjectFromScene(ASceneObj: TSceneObject; ALayerType: TLayerType);
  end;

  // ����� ������������� �������
  TDynamicSceneObj = class(TSceneObject)
  strict private
    FX: Double;
    FY: Double;
    FAmove: Double;
    FBmove: Double;
    FdX: Integer;
    FSpeed: Double;
  public
    constructor Create;
    // ����������
    property X: Double read FX write FX;
    property Y: Double read FY write FY;
    // ������������� �������� Y = A*X + B / A � B - ����������� ��������
    property Amove: Double read FAmove write FAmove;
    property Bmove: Double read FBmove write FBmove;
    //�������� �� (����������� �� ��� �)
    property dX: Integer read FdX write FdX;
    //��������
    property Speed: Double read FSpeed write FSpeed;
  end;

  TScene = class
  strict private
    FXSceneBegin: Double;
    FXSceneEnd: Double;
    FYSceneBegin: Double;
    FYSceneEnd: Double;
    FPxl_m: Double;
    FObjectList: TObjectList<TSceneObject>;
  public
    constructor Create;
    destructor Destroy; override;

    // ��������� ����� � ��������
    property XSceneBegin: Double read FXSceneBegin write FXSceneBegin;
    property XSceneEnd: Double read FXSceneEnd write FXSceneEnd;
    property YSceneBegin: Double read FYSceneBegin write FYSceneBegin;
    property YSceneEnd: Double read FYSceneEnd write FYSceneEnd;
    //������� �����
    property ObjectList: TObjectList<TSceneObject> read FObjectList write FObjectList;
    //������� (������� � ����� �����)
    property Pxl_m: Double read FPxl_m write FPxl_m;

    // ������������� �������� �����
    procedure InitCoordParams(AXSceneEnd, AYSceneEnd: Double);

    // ��������� ������������ ����� � ��������� �������
    // ��������� �������� (�������� � 1�)
    procedure SetScale; virtual; abstract;
    // ��������� ��������  ������ ����� (�����������, ��������� �������...)
    procedure BuildUp; virtual; abstract;
    // ������ ���������� ��������� �����
    function CalcNextFrame: Boolean; virtual; abstract;
  end;

implementation

{ TScene }

constructor TScene.Create;
begin
  ObjectList := TObjectList<TSceneObject>.Create;
end;


destructor TScene.Destroy;
begin
  ObjectList.Free;
end;

procedure TScene.InitCoordParams(AXSceneEnd, AYSceneEnd: Double);
begin
  XSceneBegin := 0;
  XSceneEnd := AXSceneEnd;
  YSceneBegin := 0;
  YSceneEnd := AYSceneEnd;
end;

constructor TSceneObject.Create;
begin
  Layer := ltBack;
  Visible := True;
  DrwObjList := TObjectList<TDrwShape>.Create(False);
end;

destructor TSceneObject.Destroy;
begin
  DrwObjList.Free;
  inherited;
end;

procedure TDrawingManager.ClearFrontLayer;
begin
  Painter.FLDrwShapeList.Clear;
end;

procedure TDrawingManager.DrawLayer(ALayerType: TLayerType);
begin
  with Painter do
    begin
      if ALayerType = ltBack then
      begin
        BackLayer.Canvas.FillRect(BackLayer.Canvas.ClipRect);
        DrawBackShapes;
      end
      else if ALayerType = ltFront then
      begin
        FrontLayer.Canvas.Draw(0,0, BackLayer);
        DrawFrontShapes;
      end;
    end;
end;

procedure TDrawingManager.LoadObjectFromScene(ASceneObj: TSceneObject; ALayerType: TLayerType);
var
  vShape: TDrwShape;
begin
  ASceneObj.DrwObjList.Clear;
  ASceneObj.Build;
  for vShape in ASceneObj.DrwObjList do
    Painter.AddShape(vShape, ALayerType);
end;

{ TDynamicSceneObj }

constructor TDynamicSceneObj.Create;
begin
  inherited;
  Layer := ltFront;
end;

end.
