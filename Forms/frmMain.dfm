object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Game'
  ClientHeight = 667
  ClientWidth = 615
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 615
    Height = 667
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pcMain: TPageControl
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 609
      Height = 661
      ActivePage = tsSettings
      Align = alClient
      DoubleBuffered = False
      ParentDoubleBuffered = False
      Style = tsButtons
      TabOrder = 0
      object tsSettings: TTabSheet
        Caption = 'tsSettings'
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        object lblName: TLabel
          Left = 3
          Top = 7
          Width = 52
          Height = 13
          Caption = #1055#1088#1086#1092#1080#1083#1100': '
        end
        object PaintBox: TPaintBox
          Left = 0
          Top = 104
          Width = 601
          Height = 547
          Align = alBottom
          Color = clWhite
          ParentColor = False
        end
        object lblTeamName: TLabel
          Left = 3
          Top = 34
          Width = 48
          Height = 13
          Caption = #1050#1086#1084#1072#1085#1076#1072':'
        end
        object lblScheme: TLabel
          Left = 3
          Top = 61
          Width = 38
          Height = 13
          Caption = #1057#1093#1077#1084#1072': '
        end
        object btnEditProfile: TButton
          Left = 526
          Top = 2
          Width = 75
          Height = 25
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 0
          OnClick = btnEditProfileClick
        end
        object edtUserName: TEdit
          Left = 61
          Top = 4
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 1
        end
        object edtTeamName: TEdit
          Left = 61
          Top = 31
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
        object edtScheme: TEdit
          Left = 61
          Top = 58
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 3
        end
      end
      object tsStat: TTabSheet
        Caption = 'tsStat'
        ImageIndex = 1
        TabVisible = False
        ExplicitTop = 27
        ExplicitHeight = 630
      end
      object tsTraining: TTabSheet
        Caption = 'tsTraining'
        ImageIndex = 2
        TabVisible = False
        ExplicitTop = 27
        ExplicitHeight = 630
      end
      object tsMatch: TTabSheet
        Caption = 'tsMatch'
        ImageIndex = 3
        TabVisible = False
        ExplicitTop = 27
        ExplicitHeight = 630
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 720
    Top = 280
    object Setting: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      OnClick = actSetRegimeExecute
    end
    object Stat: TMenuItem
      Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
      OnClick = actSetRegimeExecute
    end
    object Training: TMenuItem
      Caption = #1058#1088#1077#1085#1080#1088#1086#1074#1082#1072
      OnClick = actSetRegimeExecute
    end
    object Match: TMenuItem
      Caption = #1052#1072#1090#1095'!'
      OnClick = actSetRegimeExecute
    end
  end
  object ActionList: TActionList
    Left = 536
    Top = 40
    object actSetRegime: TAction
      OnExecute = actSetRegimeExecute
    end
  end
end
