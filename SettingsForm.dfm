object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Einstellungen'
  ClientHeight = 234
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblTheme: TLabel
    Left = 70
    Top = 19
    Width = 36
    Height = 13
    Alignment = taRightJustify
    Caption = 'Theme:'
  end
  object lblLength: TLabel
    Left = 23
    Top = 46
    Width = 83
    Height = 13
    Alignment = taRightJustify
    Caption = 'PasswordLength:'
  end
  object lblSym: TLabel
    Left = 24
    Top = 71
    Width = 82
    Height = 13
    Alignment = taRightJustify
    Caption = 'Include Symbols?'
  end
  object cmbThemes: TComboBox
    Left = 112
    Top = 16
    Width = 145
    Height = 21
    AutoComplete = False
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 0
    Text = 'Carbon'
    TextHint = 'Theme'
    Items.Strings = (
      'Carbon'
      'Sky'
      'Smokey Quartz Kamri'
      'Tablet Light'
      'TabletDark'
      'Iceberg Classico'
      'Windows'
      'Windows10'
      'Windows10 SlateGray'
      'Windows10 Blue'
      'Windows10 Dark'
      'Windows10 Green'
      'Windows10 Purple')
  end
  object btnOk: TButton
    Left = 182
    Top = 186
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = btnOkClick
  end
  object chkSym: TCheckBox
    Left = 112
    Top = 70
    Width = 17
    Height = 17
    TabOrder = 2
  end
  object edtLength: TEdit
    Left = 112
    Top = 43
    Width = 145
    Height = 21
    NumbersOnly = True
    TabOrder = 3
    TextHint = 'Length'
  end
end
