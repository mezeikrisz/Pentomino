object frmMain: TfrmMain
  Left = 758
  Top = 102
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Kirak'#243
  ClientHeight = 262
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblTalalatokSzama: TLabel
    Left = 8
    Top = 69
    Width = 80
    Height = 13
    Caption = 'Tal'#225'latok sz'#225'ma:'
  end
  object lblSebesseg: TLabel
    Left = 8
    Top = 93
    Width = 72
    Height = 13
    Caption = 'Kirak'#225'sok/sec:'
  end
  object lblElkeszult: TLabel
    Left = 8
    Top = 117
    Width = 56
    Height = 13
    Caption = 'Elk'#233'sz'#252'lt %:'
  end
  object btnKeres: TButton
    Left = 8
    Top = 8
    Width = 153
    Height = 49
    Caption = 'Keres!'
    TabOrder = 0
    OnClick = btnKeresClick
  end
  object dwgdLenyeg: TDrawGrid
    Left = 168
    Top = 8
    Width = 401
    Height = 245
    ColCount = 10
    DefaultColWidth = 38
    DefaultRowHeight = 38
    DefaultDrawing = False
    Enabled = False
    FixedCols = 0
    RowCount = 6
    FixedRows = 0
    TabOrder = 1
    OnDrawCell = dwgdLenyegDrawCell
  end
  object rgrpTempo: TRadioGroup
    Left = 8
    Top = 144
    Width = 153
    Height = 109
    Caption = 'Gyorsas'#225'g'
    ItemIndex = 1
    Items.Strings = (
      'l'#225'thatatlan'
      'l'#225'that'#243' gyors'
      'l'#225'that'#243' lass'#250)
    TabOrder = 2
  end
  object edtTalalatokSzama: TEdit
    Left = 96
    Top = 66
    Width = 65
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = '0'
  end
  object edtSebesseg: TEdit
    Left = 96
    Top = 90
    Width = 65
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = '0'
  end
  object edtElkeszult: TEdit
    Left = 96
    Top = 114
    Width = 65
    Height = 21
    ReadOnly = True
    TabOrder = 5
    Text = '0'
  end
  object tmrTimer: TTimer
    OnTimer = tmrTimerTimer
    Left = 16
    Top = 16
  end
end
