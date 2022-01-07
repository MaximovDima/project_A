unit Painter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Generics.Defaults, Generics.Collections, DrwShapeClasses,
  Math, Physics;

type

  TLayerType = (ltBack, ltFront);

  TfrmPainter = class(TForm)
    PaintBox: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  strict private
    FScene: TCanvas;
    FFrontLayer: TBitmap;
    FBackLayer: TBitmap;
    FX: Double;
    FY: Double;
    FBLDrwShapeList: TDrwShapeList;
    FFLDrwShapeList: TDrwShapeList;
  published
    property Scene: TCanvas read FScene write FScene;
    property FrontLayer: TBitmap read FFrontLayer write FFrontLayer;
    property BackLayer: TBitmap read FBackLayer write FBackLayer;
    property X: Double read FX write FX;
    property Y: Double read FY write FY;
    property BLDrwShapeList: TDrwShapeList read FBLDrwShapeList write FBLDrwShapeList;
    property FLDrwShapeList: TDrwShapeList read FFLDrwShapeList write FFLDrwShapeList;

    procedure Init(APanel: TPanel);
    procedure InitLayers;

    procedure DrawBackShapes;
    procedure DrawFrontShapes;
    procedure AddShape(AShape: TDrwShape; ALayerType: TLayerType = ltFront);
  end;

implementation

{$R *.dfm}

uses
  frmMain, Scene;

procedure TfrmPainter.AddShape(AShape: TDrwShape; ALayerType: TLayerType = ltFront);
begin
  AShape.ReCalcY(BackLayer.Height);
  if ALayerType = ltBack then
    BLDrwShapeList.AddShape(AShape)
  else
    FLDrwShapeList.AddShape(AShape);
end;

procedure TfrmPainter.DrawBackShapes;
var
  vDrwShape: TDrwShape;
begin
  for vDrwShape in BLDrwShapeList do
    vDrwShape.Draw(BackLayer);
end;

procedure TfrmPainter.DrawFrontShapes;
var
  vDrwShape: TDrwShape;
begin
  for vDrwShape in FLDrwShapeList do
    vDrwShape.Draw(FrontLayer);
end;

procedure TfrmPainter.FormCreate(Sender: TObject);
begin
  FrontLayer := TBitmap.Create;
  BackLayer := TBitmap.Create;
  BLDrwShapeList := TDrwShapeList.Create;
  FLDrwShapeList := TDrwShapeList.Create;
end;

procedure TfrmPainter.FormDestroy(Sender: TObject);
begin
  FrontLayer.Free;
  BackLayer.Free;
  BLDrwShapeList.Free;
  FLDrwShapeList.Free;
end;

procedure TfrmPainter.Init(APanel: TPanel);
begin
  Scene := PaintBox.Canvas;
  BorderStyle := bsNone;
  Parent := APanel;
  Align := alClient;
  DoubleBuffered := True;
  Show;
  X := APanel.Width;
  Y := APanel.Height;
  InitLayers;
end;

procedure TfrmPainter.InitLayers;
begin
  FrontLayer.Width := Parent.Width;
  FrontLayer.Height := Parent.Height;
  BackLayer.Width := Parent.Width;
  BackLayer.Height := Parent.Height;
end;

procedure TfrmPainter.PaintBoxPaint(Sender: TObject);
begin
  Scene.Draw(0,0, FrontLayer);
end;

end.

