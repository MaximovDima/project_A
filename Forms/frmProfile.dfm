object ProfileForm: TProfileForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1088#1086#1092#1080#1083#1103
  ClientHeight = 194
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblName: TLabel
    Left = 24
    Top = 24
    Width = 23
    Height = 13
    Caption = #1048#1084#1103':'
  end
  object lblTeamName: TLabel
    Left = 24
    Top = 51
    Width = 48
    Height = 13
    Caption = #1050#1086#1084#1072#1085#1076#1072':'
  end
  object lblScheme: TLabel
    Left = 23
    Top = 78
    Width = 35
    Height = 13
    Caption = #1057#1093#1077#1084#1072':'
  end
  object edtName: TEdit
    Left = 80
    Top = 21
    Width = 233
    Height = 21
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 207
    Top = 161
    Width = 75
    Height = 25
    Caption = #1054#1082
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 293
    Top = 161
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object edtTeamName: TEdit
    Left = 80
    Top = 48
    Width = 233
    Height = 21
    TabOrder = 3
  end
  object edtScheme: TEdit
    Left = 80
    Top = 75
    Width = 233
    Height = 21
    TabOrder = 4
  end
end
