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
  object lblNumberOfSolutions: TLabel
    Left = 8
    Top = 69
    Width = 73
    Height = 13
    Caption = 'No of solutions:'
  end
  object lblSpeedOfPuts: TLabel
    Left = 8
    Top = 93
    Width = 46
    Height = 13
    Caption = 'Puts/sec:'
  end
  object lblCompleted: TLabel
    Left = 8
    Top = 117
    Width = 64
    Height = 13
    Caption = 'Completed %:'
  end
  object btnFindSolutions: TButton
    Left = 8
    Top = 8
    Width = 153
    Height = 49
    Caption = 'Find!'
    TabOrder = 0
    OnClick = btnFindSolutionsClick
  end
  object dwgdPlayGround: TDrawGrid
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
    OnDrawCell = dwgdPlayGroundDrawCell
  end
  object rgrpTempo: TRadioGroup
    Left = 8
    Top = 144
    Width = 153
    Height = 109
    Caption = 'Tempo'
    ItemIndex = 1
    Items.Strings = (
      'invisible'
      'visible fast'
      'visible slow')
    TabOrder = 2
  end
  object edtNumberOfSolutions: TEdit
    Left = 96
    Top = 66
    Width = 65
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = '0'
  end
  object edtSpeedOfPuts: TEdit
    Left = 96
    Top = 90
    Width = 65
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = '0'
  end
  object edtCompleted: TEdit
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
