object frmPainter: TfrmPainter
  Left = 0
  Top = 0
  Caption = 'frmPainter'
  ClientHeight = 297
  ClientWidth = 399
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox: TPaintBox
    Left = 0
    Top = 0
    Width = 399
    Height = 297
    Align = alClient
    Color = clWhite
    ParentColor = False
    OnPaint = PaintBoxPaint
    ExplicitWidth = 584
    ExplicitHeight = 300
  end
end
