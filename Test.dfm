object PostalTester: TPostalTester
  Left = 0
  Top = 0
  Caption = 'PostalMan'
  ClientHeight = 385
  ClientWidth = 738
  Color = clBtnFace
  Constraints.MinWidth = 650
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    738
    385)
  TextHeight = 15
  object Label1: TLabel
    Left = 252
    Top = 132
    Width = 71
    Height = 15
    Caption = 'House/Name'
  end
  object Label2: TLabel
    Left = 252
    Top = 164
    Width = 116
    Height = 15
    Caption = 'Road/ House Number'
  end
  object Label3: TLabel
    Left = 252
    Top = 193
    Width = 82
    Height = 15
    Caption = 'Postcode/Town'
  end
  object Label4: TLabel
    Left = 252
    Top = 101
    Width = 52
    Height = 15
    Caption = 'Language'
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 86
    Height = 15
    Caption = 'Path to libpostal'
  end
  object Label6: TLabel
    Left = 8
    Top = 40
    Width = 74
    Height = 15
    Caption = 'Data directory'
  end
  object Label7: TLabel
    Left = 19
    Top = 299
    Width = 137
    Height = 15
    Caption = 'Validation result on failure'
  end
  object BtnParse: TButton
    Left = 4
    Top = 352
    Width = 242
    Height = 25
    Caption = 'Parse'
    TabOrder = 13
    OnClick = Button1Click
  end
  object cbLanguage: TCheckBox
    Left = 4
    Top = 170
    Width = 153
    Height = 17
    Caption = 'identify language'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object cbClearLists: TCheckBox
    Left = 4
    Top = 225
    Width = 97
    Height = 17
    Caption = 'clear lists'
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
  object cbOneValidator: TCheckBox
    Left = 19
    Top = 276
    Width = 210
    Height = 17
    Caption = 'one validator is enough to validate'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object EdHouse: TEdit
    Left = 388
    Top = 132
    Width = 336
    Height = 23
    TabStop = False
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 14
    ExplicitWidth = 332
  end
  object M: TMemo
    Left = 252
    Top = 219
    Width = 472
    Height = 158
    TabStop = False
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 15
    ExplicitWidth = 468
  end
  object EdAddress: TComboBox
    Left = 4
    Top = 69
    Width = 720
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Items.Strings = (
      'ung'#252'tlige Adresse, Am Weichert 10, 56742 Karlsruhe'
      
        'Fichtenstrasse 3 * Vasold Umweltschutz GmbH & Co. KG * 85098 Gro' +
        #223'mehring'
      'Vasold Hans J'#246'rg, Lilienstrasse 5a, 85098 Gro'#223'mehring'
      'Maximilian str. 5 M'#252'nchen'
      'M'#252'nchen DE 81929 33 Landshamer Stra'#223'e'
      
        'Alois-Wunder-Strasse 1, Peter Rubens, 81241 Muenchen Pasing, Bay' +
        'ern Deutschland'
      
        'Hans Joerg Vasold, Sch'#228'ferspforte 19, 56743 Mendig, RLP, Deutsch' +
        'land ')
    ExplicitWidth = 716
  end
  object cbOriginal: TCheckBox
    Left = 4
    Top = 147
    Width = 209
    Height = 17
    Caption = 'take care of original notation'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object EdRoad: TEdit
    Left = 388
    Top = 161
    Width = 249
    Height = 23
    TabStop = False
    ReadOnly = True
    TabOrder = 16
  end
  object EdHouseNumber: TEdit
    Left = 643
    Top = 161
    Width = 81
    Height = 23
    TabStop = False
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 17
    ExplicitWidth = 77
  end
  object EdPostcode: TEdit
    Left = 388
    Top = 190
    Width = 89
    Height = 23
    TabStop = False
    ReadOnly = True
    TabOrder = 18
  end
  object EdTown: TEdit
    Left = 483
    Top = 190
    Width = 241
    Height = 23
    TabStop = False
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 19
    ExplicitWidth = 237
  end
  object EdLanguage: TEdit
    Left = 388
    Top = 98
    Width = 169
    Height = 23
    TabStop = False
    ReadOnly = True
    TabOrder = 20
  end
  object cbParseAddress: TCheckBox
    Left = 4
    Top = 101
    Width = 97
    Height = 17
    Caption = 'Parse address'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object cbExpandAndParseAddress: TCheckBox
    Left = 4
    Top = 124
    Width = 169
    Height = 17
    Caption = 'Expand and parse address'
    TabOrder = 5
  end
  object cbUseValidator: TCheckBox
    Left = 4
    Top = 253
    Width = 217
    Height = 17
    Caption = 'use Nomanitim to validate address'
    Checked = True
    State = cbChecked
    TabOrder = 11
  end
  object rbStrings: TRadioButton
    Left = 4
    Top = 202
    Width = 57
    Height = 17
    Caption = 'Strings'
    TabOrder = 8
  end
  object rbValues: TRadioButton
    Left = 100
    Top = 202
    Width = 113
    Height = 17
    Caption = 'Values'
    Checked = True
    TabOrder = 9
    TabStop = True
  end
  object EdLibpostal: TEdit
    Left = 100
    Top = 8
    Width = 543
    Height = 23
    TabStop = False
    TabOrder = 0
    Text = 'C:\Workbench\libpostal\src\.libs\libpostal-1.dll'
  end
  object BtnLoadLibpostal: TButton
    Left = 649
    Top = 8
    Width = 75
    Height = 55
    Caption = 'Load'
    TabOrder = 2
    OnClick = BtnLoadLibpostalClick
  end
  object EdDataDir: TEdit
    Left = 100
    Top = 40
    Width = 543
    Height = 23
    TabStop = False
    TabOrder = 1
  end
  object CbxValidation: TComboBox
    Left = 96
    Top = 320
    Width = 125
    Height = 23
    Style = csDropDownList
    ItemIndex = 1
    TabOrder = 21
    Text = 'not sure if valid'
    Items.Strings = (
      'invalid address'
      'not sure if valid'
      'valid address')
  end
end
