object frmPwMng: TfrmPwMng
  Left = 0
  Top = 0
  Caption = 'PasswordManager'
  ClientHeight = 299
  ClientWidth = 657
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lstAccounts: TListBox
    Left = 0
    Top = 0
    Width = 241
    Height = 299
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
    OnClick = lstAccountsClick
  end
  object Panel2: TPanel
    Left = 241
    Top = 0
    Width = 416
    Height = 299
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 416
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object btnCancel: TButton
        Left = 248
        Top = 9
        Width = 75
        Height = 25
        Caption = 'Verwerfen'
        Enabled = False
        TabOrder = 0
        OnClick = btnCancelClick
      end
      object btnDelete: TButton
        Left = 329
        Top = 9
        Width = 75
        Height = 25
        Caption = 'L'#246'schen'
        Enabled = False
        TabOrder = 1
        OnClick = btnDeleteClick
      end
      object btnEdit: TButton
        Left = 86
        Top = 9
        Width = 75
        Height = 25
        Caption = #196'ndern'
        Enabled = False
        TabOrder = 2
        OnClick = btnEditClick
      end
      object btnNew: TButton
        Left = 5
        Top = 9
        Width = 75
        Height = 25
        Caption = 'Neu'
        TabOrder = 3
        OnClick = btnNewClick
      end
      object btnSave: TButton
        Left = 167
        Top = 9
        Width = 75
        Height = 25
        Caption = 'Speichern'
        Enabled = False
        TabOrder = 4
        OnClick = btnSaveClick
      end
    end
    object edProviderName: TLabeledEdit
      Left = 14
      Top = 88
      Width = 163
      Height = 21
      EditLabel.Width = 66
      EditLabel.Height = 13
      EditLabel.Caption = 'Providername'
      Enabled = False
      TabOrder = 1
    end
    object edURL: TLabeledEdit
      Left = 190
      Top = 88
      Width = 219
      Height = 21
      EditLabel.Width = 19
      EditLabel.Height = 13
      EditLabel.Caption = 'URL'
      Enabled = False
      TabOrder = 2
    end
    object edUsername: TLabeledEdit
      Left = 14
      Top = 152
      Width = 163
      Height = 21
      EditLabel.Width = 48
      EditLabel.Height = 13
      EditLabel.Caption = 'Username'
      Enabled = False
      TabOrder = 3
    end
    object edMail: TLabeledEdit
      Left = 190
      Top = 152
      Width = 219
      Height = 21
      EditLabel.Width = 18
      EditLabel.Height = 13
      EditLabel.Caption = 'Mail'
      Enabled = False
      TabOrder = 4
    end
    object edPassword: TLabeledEdit
      Left = 14
      Top = 200
      Width = 163
      Height = 21
      EditLabel.Width = 46
      EditLabel.Height = 13
      EditLabel.Caption = 'Password'
      Enabled = False
      TabOrder = 5
    end
    object chkShowPassword: TCheckBox
      Left = 102
      Top = 231
      Width = 97
      Height = 17
      Caption = 'Passwort zeigen'
      TabOrder = 6
      OnClick = chkShowPasswordClick
    end
    object btnGeneratePassword: TButton
      Left = 14
      Top = 227
      Width = 75
      Height = 25
      Caption = 'Generieren'
      Enabled = False
      TabOrder = 7
      OnClick = btnGeneratePasswordClick
    end
    object btnCopyPassword: TButton
      Left = 192
      Top = 198
      Width = 75
      Height = 25
      Caption = 'Kopieren'
      TabOrder = 8
      OnClick = btnCopyPasswordClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 200
    Top = 8
    object File1: TMenuItem
      Caption = '&Datei'
      object PfadzurSicherungffnen1: TMenuItem
        Caption = 'Pfad zur Sicherung '#246'ffnen'
        OnClick = PfadzurSicherungffnen1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = '&Beenden'
        OnClick = Exit1Click
      end
    end
  end
end
