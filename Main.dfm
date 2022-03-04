object frmMain: TfrmMain
  Left = 760
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Kirak'#243
  ClientHeight = 274
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblKirakottMennyiseg: TLabel
    Left = 8
    Top = 136
    Width = 6
    Height = 13
    Caption = '0'
  end
  object btnKeres: TButton
    Left = 8
    Top = 8
    Width = 153
    Height = 113
    Caption = 'Keres!'
    TabOrder = 0
    OnClick = btnKeresClick
  end
  object dwgdLenyeg: TDrawGrid
    Left = 168
    Top = 8
    Width = 401
    Height = 257
    ColCount = 11
    DefaultColWidth = 35
    DefaultRowHeight = 35
    DefaultDrawing = False
    Enabled = False
    FixedCols = 0
    RowCount = 7
    FixedRows = 0
    TabOrder = 1
    OnDrawCell = dwgdLenyegDrawCell
  end
  object rgrpTempo: TRadioGroup
    Left = 8
    Top = 160
    Width = 153
    Height = 105
    Caption = 'Gyorsas'#225'g'
    ItemIndex = 1
    Items.Strings = (
      'l'#225'thatatlan'
      'l'#225'that'#243' gyors'
      'l'#225'that'#243' lass'#250)
    TabOrder = 2
  end
end
