object frm_JonMsg: Tfrm_JonMsg
  Left = 0
  Top = 0
  Caption = #50545#51217#49688
  ClientHeight = 231
  ClientWidth = 430
  Color = clBtnFace
  Constraints.MaxHeight = 270
  Constraints.MaxWidth = 446
  Constraints.MinHeight = 270
  Constraints.MinWidth = 446
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_Title: TcxLabel
    Left = 0
    Top = 0
    Align = alTop
    AutoSize = False
    Caption = #44256#44061#50545#51217#49688' '#44256#44061#51077#45768#45796
    ParentColor = False
    ParentFont = False
    Style.Color = clYellow
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = #44404#47548
    Style.Font.Style = []
    Style.TextStyle = [fsBold]
    Style.IsFontAssigned = True
    Properties.Alignment.Horz = taCenter
    Properties.Alignment.Vert = taVCenter
    OnMouseDown = pnl_TitleMouseDown
    ExplicitWidth = 217
    Height = 44
    Width = 430
    AnchorX = 215
    AnchorY = 22
  end
  object pnl_Alert: TPanel
    Left = 0
    Top = 44
    Width = 430
    Height = 187
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    BorderWidth = 2
    Color = clBlack
    ParentBackground = False
    TabOrder = 1
    OnMouseDown = pnl_AlertMouseDown
    ExplicitLeft = -54
    ExplicitTop = -53
    ExplicitWidth = 407
    ExplicitHeight = 244
    object cxLabel9: TcxLabel
      Left = 10
      Top = 101
      Caption = '* '#51060#48120' '#46321#47197#46108' '#45824#44592#50724#45908#47484' '#49688#51221#54616#49884#47140#47732' '#39#50545#50724#45908#51217#49688#39#48260#53948#51012
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = #44404#47548
      Style.Font.Style = []
      Style.TextColor = clWhite
      Style.TextStyle = [fsBold]
      Style.IsFontAssigned = True
      OnMouseDown = pnl_TitleMouseDown
    end
    object cxLabel16: TcxLabel
      Left = 23
      Top = 121
      Caption = #45580#47084#51452#49464#50836
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = #44404#47548
      Style.Font.Style = []
      Style.TextColor = clWhite
      Style.TextStyle = [fsBold]
      Style.IsFontAssigned = True
      OnMouseDown = pnl_TitleMouseDown
    end
    object cxLabel17: TcxLabel
      Left = 10
      Top = 154
      Caption = '* '#54788#51116#51032' '#45236#50857#51004#47196' '#51217#49688#54616#49884#47140#47732' '#39#49888#44508#51217#49688#39#47484' '#45580#47084#51452#49464#50836
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = #44404#47548
      Style.Font.Style = []
      Style.TextColor = clWhite
      Style.TextStyle = [fsBold]
      Style.IsFontAssigned = True
      OnMouseDown = pnl_TitleMouseDown
    end
    object btn_Update: TcxButton
      Left = 50
      Top = 29
      Width = 115
      Height = 55
      Cursor = crHandPoint
      Caption = #50545#50724#45908#51217#49688
      TabOrder = 3
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btn_Join: TcxButton
      Left = 250
      Top = 29
      Width = 115
      Height = 55
      Cursor = crHandPoint
      Caption = #49888#44508#51217#49688
      TabOrder = 4
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn_JoinClick
    end
  end
end