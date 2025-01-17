unit xe_JON01Share;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, MSXML2_TLB,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, xe_JON01N, System.JSON, cxLabel, cxCheckBox, dxAlertWindow,
  cxTextEdit, cxMemo, cxButtons, cxDropDownEdit, Vcl.StdCtrls, cxRichEdit, AdvGlowButton, xe_GNL, xe_gnl3,
  cxCurrencyEdit, Vcl.Buttons, cxDateUtils, cxSpinEdit, cxTimeEdit, cxCalendar, System.StrUtils,
  Vcl.ExtCtrls, cxCustomData, cxGridCustomTableView, dxCore, ActiveX, System.SyncObjs;

  procedure pMsnExecute( vMsg : String );
  procedure ssSetMessenger( vMessage : String );

  procedure GetEnvVarRealKmValue( ATag : Integer; Var vRealKmPtr : TRealKmRecord );

  procedure SetEnvVarRealKmValue( ATag : Integer );

  function GetEnvHintValue(VarName: string; Frm_JON01N : TFrm_JON01N): string; overload;

  procedure SetEnvHintValue(VarName, VarValue: string; Frm_JON01N : TFrm_JON01N); overload;

  procedure SetEnvVarClick(VarName : string; Frm_JON01N : TFrm_JON01N); overload;

  function fGetFrmCShare(bFirst : Boolean; ATag : Integer; Frm_JON01N : TFrm_JON01N ) : String; overload;

  function fGetComNameToCode( AComName : String ) : String;
  function fGetCodeToComName( ACode : String ) : String;

  function fSet601QRate( ATag : Integer; Frm_JON01N : TFrm_JON01N ) : Boolean; overload;
  procedure pSet601QRateSend ( ATag : Integer );

  procedure pSet603QRateAnswer( vQ_Rate : TQ_Rate );

  procedure pSet606QRateSave( ATag, AIdx : Integer; Frm_JON01N : TFrm_JON01N ); overload;

  procedure pSet607QRateDel( ATag, AIdx : Integer; Frm_JON01N : TFrm_JON01N ); overload;

  procedure pSet701CShareValue( ATag : Integer; Frm_JON01N : TFrm_JON01N ); overload;
  procedure pSet701CShareSend ( ATag : Integer );

  procedure pSet703CShareClose( sGubun : String; ATag : Integer; Frm_JON01N : TFrm_JON01N ); overload;

  procedure pSet703CShareCloseSend( sGubun : String; ATag : Integer );

  procedure pSet708CShareCall(Agbup, Agb, ArKey, AjId, AjNm, ArId, ArNm : String);
  procedure pSet705CShareCancel(Agb, ArKey, AjId, ArId : String);

  procedure pSet705CShareData(bFirst:Boolean; AgbUp, Agb, ArKey, AjId, ArId : String; ATag : Integer; Frm_JON01N : TFrm_JON01N ); overload;
  procedure pSet705CShareClick(Agb, ArKey, AjId, ArId, AClickNm : String; ATag : Integer);

  procedure pSet705CShareDataClick(bFirst:Boolean; Agb, ArKey, AjId, ArId, AClickNm : String; ATag : Integer; Frm_JON01N : TFrm_JON01N ); overload;

  procedure pSet705CShareClickEvent( AEventName : String; ATag : Integer; Frm_JON01N : TFrm_JON01N ); overload;

  procedure pSet706CShareEnd( ArKey, AjId, ArId, AWcl : String);

  procedure pSet370FileUpload( AFileName : String );
  procedure pSet380ServerSetting( AType, ASsyn, ASset : String );
  procedure pGet381ServerSetting;

  procedure pSet050CCList( iTag : Integer );

  procedure pSetGridCShare( vC_Share : TC_Share );
  procedure pCP_702CShareRequest(sData: String);
  procedure pCP_704CShareClose(sData: String);
  procedure pCP_370Result(sData: String);
  procedure pCP_371Result(sData: String);
  procedure pCP_381GetServerSetting(ACid, sData: String);
  procedure pCP_501Result(sData: String);
  procedure pCP_601Result(sData: String);
  procedure pCP_801GetBrCash(sData: String);
  procedure p801SendBrCash(bError : Boolean; sCash, sDanga: String);
  procedure pCP_802SendSMS(sData: String);
  procedure p802SendSMSResult( sResult, sMsg: String);
  procedure pCP_901Result(sData: String);
  procedure p902SendResult( sResult : String);
  procedure p903SendMSNAlive;
  procedure p999UpLogOut;
  procedure pCP_903Result(sData: String);
  procedure pCP_013MemoNoticeList(sCmd, sData: String);
  procedure pCP_602ChargeRequest(sData: String);
  procedure pCP_604ChargeAnswer(sCmd, sData: String);
  procedure pSetGridQRate( vQ_Rate : TQ_Rate );
  function fFindQRForm(sHint: string): Integer;

  function fJsonEncode( sTxt : String ) : String;
  function fJsonDecode( sTxt : String ) : String;

	procedure pGetMakeHead(var jsoHd: TJSONObject; sId: String);
	//메뉴별 조회 리스트에서 선택 상담원과 채팅
	procedure p1501SetChat(FrmTag : Integer; sCd, sKey, sId, sNm, sMsg, sFCmd, sFnm, sflId, sflNm : String; bFirst : Boolean = False);
	//채팅창에서 접수번호 클릭시 조회창 오픈
	procedure pCP_711Result(sData: String);    //p711OPENJON01N
Var
	gvComShare : array[0..103] of String;  // 이전 자료 저장 비교후 틀린것만 전송 처리 위해
  gvVarShare : array[0..92] of String;
  gvHintShare : array[0..4] of String;

  gsOrderClick : String;

  fAlertWindow: TdxAlertWindow;

const
  cQUOTATION_MARK = '&quot;';  // json특수문자 사용(")변환 변수
	ComShare : array[0..103] of String = (
    'cxtCuTel',
    'cxtCallTelNum',
    'cxtWorkerNm',
    'cxtJoinNum',
    'cxtCuTel2',
    'cxBtnHoTrans',
    'cboBrOnly',
    'cboBranch',
    'cxTSearchMainTel',
    'btnBubinSch',
    'CbCuGb',
    'cboCuLevel',
    'ChkCuSmsNo',
    'cxBtnSpSave',
    'cxBtnCuUpdate',
    'cxBtnCuDel',
    'btnCMenu',
    'cxLblCuLevel',
    'cxtCuBubin',
    'edtCuName',
    'lblMoCuMile',
    'lblCuMile',
    'lblCuMileCnt',
    'lblCuMileUnit',
    'chkCenterMng',
    'lblCoCntTotal',
    'lblCuCancelR',
    'lblCuCntTotal',
    'chkViewLevel',
    'edt_CardMemo',
    'meoCuCCMemo',
    'meoCuWorMemo',
    'mmoCbMemo',

    'btnStartLocalSave',
    'cb_00',
    'cb_01',
    'cb_02',
    'cb_03',
    'cb_04',
    'cb_05',
    'cb_06',
    'cbbLicType',
    'BtnStLock',
    'meoStartArea',
    'lblStartAreaName',
    'cxtStartAreaDetail',
    'cxtStartXval',
    'cxtStartYval',
    'cxtStartGUIDEXval',
    'cxtStartGUIDEYval',

    'BtnEdLock',
    'meoEndArea',
    'cxReEndArea',
    'lblEndAreaName',
    'cxtEndAreaDetail',
    'cxtEndXval',
    'cxtEndYval',
    'cxtEndGUIDEXval',
    'cxtEndGUIDEYval',

    'BtnCenterMng',
    'BtnOptionCallMu',
    'BtnOptionSexF',
    'BtnOptionSexM',
    'BtnPlusYN',
    'BtnWkAge',
    'BtnWKJAmt',
    'cbbPayMethod',
    'cbbPostTime',
    'chkNoSet',
    'chkRangeRate',
    'curKm',
    'curRate',
    'cxDriverCharge',
    'cxLblRate1',
    'cxLblRate2',
    'cxLblSmartRate',
    'edtPostPay',
    'cxCurPathRate',
    'cxCurRevisionRate',
    'cxCurWaitTmRate',
    'cxTBubinMemo',
    'cxTmWaitTime',
    'edtWkFAge',
    'edtWkTAge',

    'BtnResD',
    'BtnResJ',
    'CbSecond',
    'cxlblState',
    'dtpResvDate',
    'dtpResvTime',

    'meoBigo',
    'meoBigo2',
    'meoBigo3',

    'Lbl_charge',
    'Lbl_Distance',
    'lbl_PlusAreaNotice',

//    'btnCmdExit',
//    'btnCmdJoin',
//    'btnCmdJoinCopy',
//    'btnCmdMultiCall',
//    'btnCmdNoSMS',
//    'btnCmdQuestion',
//    'btnCmdUpdSave',
//    'btnCmdWait',
//    'btnCmdWaitCopy',
//    'btnPickupInsert',

    'meoViaArea1',
    'cxViaAreaName1',

    'lbl_wk_1',
    'lbl_wk_2',
    'lbl_wk_3',
    'lbl_wk_4',
    'lbl_wk_5',
    'lbl_wk_6'

//    'mmoCuInfo'
 );

const
	VarShare : array[0..92] of String = (
    'gsCuTelHint',
    'sTaksong',
    'sStickCall',
    'lcsCu_seq',
    'sCust_Gubun',
    'locLogSeq',

    'wk_sabun',                         // 과거이용내역 기사정보 조회
		'sFinishCnt',
	  'sCancelCnt',
	  'sPhone_info',

    'locHDNO',
    'locBRNO',
    'locKNum',
    'locDNIS',
    'locSndTime',
    'locAutoCallYn',

//    'gsInternalNumber',               // 내선번호전역변수. 상대방내선번호로 변경됨. 불필요

    'locCardPaySeq',
    'locCardTranNo',
    'locCardPayInfo',
    'sAppCode',

    'lcsSta1',
    'lcsSta2',
    'lcsSta3',
    'lcsStaDocId',
    'lcsStaCellSel',
    'lcsStaSchWord',
    'lcsStaUrl',
    'lcsStaDebug',
    'GS_Grid_DES',
    'gJONStaChkXY.X',
    'gJONStaChkXY.Y',

    'lcsEnd1',
    'lcsEnd2',
    'lcsEnd3',
    'lcsEndDocId',
    'lcsEndCellSel',
    'lcsEndSchWord',
    'lcsEndUrl',
    'lcsEndDebug',
    'GS_Grid_DEP',

    'fCruKm',
    'fChgKm',
    'fDirKm',
    'fTotalTime',
    'fViaKm',
    'fStEdKm',

    'ABubinStateIndex',

//    'GS_JON_AutoStandBy',      // 콜링된 곳에서 저장을 하므로 전달 필요 없음
//    'gsCidVersion',            // 콜링된 곳에서 저장을 하므로 전달 필요 없음
    'GT_DISTANCE_ST',

    'FcnhDongCHK',
    'FPlusDongCHK',
    'FPlusDongName',

    'pnl_wk_list',
    'pnl_charge',
    'gbRQAList',

    'meoViaArea2',
    'meoViaArea3',
    'meoViaArea4',
    'meoViaArea5',

    'cxViaAreaName2',
    'cxViaAreaName3',
    'cxViaAreaName4',
    'cxViaAreaName5',

    'ViaNowTag',
    'ViaAddTag',

    'ViaSA1',
    'ViaSA2',
    'ViaSA3',
    'ViaAreaDetail',
    'ViaAreaName',
    'DocId',
    'CellSel',
    'SchWord',
    'XposVia',
    'YposVia',
    'GUIDE_X',
    'GUIDE_Y',

    // -- RealKmRecord
    'RKR_StartAreaName',
    'RKR_StartXVal',
    'RKR_StartYVal',
    'RKR_EndAreaName',
    'RKR_EndXVal',
    'RKR_EndYVal',
		'RKR_ViaXVal',
		'RKR_ViaYVal',

    // --- Color
    'PnlOCC',
    'cxLblCuLevel',
    'pnlMileage',

    // -- 권한
    'edt_CardMemo',
    'miCustAdd',
    'cboCuLevel',
    'BtnOptionCallMu',
    'giArea_Charge_YN',
    'btn_ChargeSave'

 );

const
	HintShare : array[0..4] of String = (
    'cxLblCIDUseFlg',
    'cxtCuBubin',
    'btnCmdJoinCopy',
    'btnCmdWaitCopy',
    'btnCmdExit'    
 );

const
	ClickShare : array[0..2] of String = (
    'BtnViaAdd',
    'BtnViaMinus1',
    'cbCardSanction'
 );

const
	Com34Share : array[0..26] of String = (
    'medCardNum',
	  'medtCashCardNum',
    'medtCouponNum',
    'medLimiteDate',
    'cxCurDRate',
   	'cxCurDecRate',
   	'cxCurDecRate_Cash',
    'cxCurDec_Coupon',
    'cxCurDec_Coupon1',
   	'cxCurDecRate_Coupon',
    'lbResultMsg',
    'cxCurTerm',
    'chk_BaRo_Card',
    'rg_charge_ser1',
    'rg_charge_ser2',

    'lblPaySeq',
	  'lblTranNo',
    'lblPaySeq_Cash',
    'lblTranNo_Cash',
  	'lblPaySeq_Coupon',
    'lblCardStatus',
    'lblCardStatus_Cash',
    'lblCouponStatus',

    'sb_ApproveReq',
    'sb_ApproveOK',
    'sb_ApproveCancle',
	  'sb_ApproveReceipt'
 );

const
	Var34Share : array[0..8] of String = (
    'lcBRNO',
    'lcMainNum',
    'lcCustTel',
    'lcCustSeq',
    'lcPaySeq',
    'lcTranNo',
    'lcPaySite',
    'Card_Gubun',
    'lcJON_IDX'
);

implementation

uses xe_gnl2, Main, xe_Func, xe_Msg, xe_JON012,
  xe_CUT011, xe_Jon015, xe_JON30S, xe_JON56, xe_JON019, xe_JON30,
  xe_SETA1, xe_JON24, xe_packet, xe_xml, xe_Query, xe_Dm, xe_JON23, xe_COM50,
  xe_UpdateBox;

// JSON명령어가 여러건이 동시에 들어올수도 있어서..분리처리
procedure pMsnExecute( vMsg : String );
Var iPos : Integer;
    sSendData : String;
    bOk : Boolean;
begin
	gsMessengerData := '';
  vMsg := StringReplace(vMsg, STX, '', [rfReplaceAll]);
  vMsg := StringReplace(vMsg, ETX, '', [rfReplaceAll]);
  SetDebugeWrite('Share.pMsnExecute Read : ' + vMsg);
//  vMsg := '{"hdr":{"seq":"41","cmd":"705"},"bdy":{"ckey":"a1a1a120170406104050","jid":"a1a1a1","rid":"sntest","ogb":"j","ogbup":"n","jtype":"2","ls":['+
//          '{"io":"TcxTextEdit","in":"cxtCuTel","ic":"010111111"},{"io":"TcxTextEdit","in":"cxtCallTelNum","ic":"010111111"},{"io":"TcxComboBox","in":"cboCuLevel","ic":"0"}'+
//          ',{"io":"TLabel","in":"lblCuMileCnt","ic":"0"},{"io":"TLabel","in":"lblCoCntTotal","ic":"3"},{"io":"TLabel","in":"lblCuCancelR","ic":"95%"}'+
//          ',{"io":"TLabel","in":"lblCuCntTotal","ic":"63"},{"io":"TcxRichEdit","in":"lblStartAreaName","ic":"  "},{"io":"TcxRichEdit","in":"cxReEndArea","ic":"   "}'+
//          ',{"io":"TcxLabel","in":"lblEndAreaName","ic":"  "},{"io":"Variables","in":"gsCuTelHint","ic":"010111111"},{"io":"Variables","in":"lcsCu_seq","ic":"39905591"}'+
//          ',{"io":"Variables","in":"PnlOCC","ic":"$00FFFF80"},{"io":"Variables","in":"pnlMileage","ic":"$00FFFF80"}]}}{"hdr":{"seq":"38","cmd":"704"}'+
//          ',"bdy":{"rkey":"hd222220170406104124","uid":"hd2222","unm":"이명재","cuhp":"01044444","clgb":"Z"}}';
  bOk := False;
  while Not bOk do
  begin
    iPos := Pos('}}{"', vMsg);
    if iPos > 0 then
		begin
      sSendData := Copy(vMsg, 1, iPos + 1);
			ssSetMessenger( sSendData );
      vMsg := Copy(vMsg, iPos + 2, ( Length(vMsg) - (iPos + 2) + 1));
    end else
    begin
			ssSetMessenger( vMsg );
      bOk := True;
    end;
  end;
end;

procedure ssSetMessenger( vMessage : String );
var
	sCmd, sTmp : String;
  jsoRlt : TJSONObject;
begin
	SetDebugeWrite('Share.ssSetMessenger Read : ' + vMessage);
	if Trim(vMessage) = '' then Exit;
  try
    try
      vMessage := StringReplace(vMessage, '\', '\\', [rfReplaceAll]);  { \(backSlash) Parse Error 처리2020.05.18 LYB }

      jsoRlt := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(vMessage), 0) as TJSONObject;
			sTmp := jsoRlt.Get('hdr').JsonValue.ToString;
			jsoRlt := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(jsoRlt.Get('hdr').JsonValue.ToString), 0) as TJSONObject;

      sCmd := jsoRlt.Get('cmd').JsonValue.Value;

      // 신규접수공유기능 사용안할경우 패스
      if ( GB_NS_NOACCEPTSHARE ) And ( (sCmd = '702') Or (sCmd = '704') ) then Exit;      

      jsoRlt := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(vMessage), 0) as TJSONObject;

      { TODO : 013.공지리스트, 503.공지 }
      if ( sCmd = '013' ) Or ( sCmd = '503' ) then pCP_013MemoNoticeList(sCmd, jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 501.상담원공지등록, 050.영업지원팀리스트 }
      if ( sCmd = '501' ) Or ( sCmd = '050' ) then pCP_501Result(jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 601.요금문의등록 }
      if ( sCmd = '601' ) then pCP_601Result(jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 602.요금문의전파 }
      if ( sCmd = '602' ) then pCP_602ChargeRequest(jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 603.요금답변, 605.자동답변 }
      if ( sCmd = '604' ) Or ( sCmd = '605' ) then pCP_604ChargeAnswer(sCmd, jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 702.신규콜링창의 접수 정보전파 }
      if ( sCmd = '702' ) then pCP_702CShareRequest(jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 704.신규콜링창의 접수완료/닫음 정보전파 }
      if ( sCmd = '704' ) then pCP_704CShareClose(jsoRlt.Get('bdy').JsonValue.ToString ) else
			{ TODO : 711.채킹창에서 조회(수정)창 클릭 오픈}
			if ( sCmd = '711' ) then pCP_711Result(jsoRlt.Get('bdy').JsonValue.ToString ) else
			{ TODO : 801.SMS 지사 캐시 잔액 조회 }
			if ( sCmd = '801' ) then pCP_801GetBrCash(jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 802.SMS 전송 }
      if ( sCmd = '802' ) then pCP_802SendSMS(jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 901.콜마너 프로그램 업데이트 여부 }
      if ( sCmd = '901' ) then pCP_901Result(jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 903.콜마너 메신저 상태 체크(y:메신저정상, n:메신저종료(업데이트만체크))  }
      if ( sCmd = '903' ) then pCP_903Result(jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 998.Heart Bit  }
      if ( sCmd = '998' ) then Exit else
      { TODO : 370.FileUpload 전송 결과 }
      if ( sCmd = '370' ) then pCP_370Result(jsoRlt.Get('bdy').JsonValue.ToString ) else
      { TODO : 380.상담원 서버 설정값 조회 }
      if ( sCmd = '380' ) Or ( sCmd = '381' ) then pCP_381GetServerSetting(sCmd, jsoRlt.Get('bdy').JsonValue.ToString );

    except on e: Exception do
      begin
        Assert(False, 'RecvData Parse Error : ' + vMessage + ' - ' + e.Message);
      end;
    end;

  finally
    FreeAndNil(jsoRlt);
  end;
end;

procedure GetEnvVarRealKmValue( ATag : Integer; Var vRealKmPtr : TRealKmRecord );
begin
  try
    if RealKmPtr_th1[ATag].UseYn then vRealKmPtr := RealKmPtr_th1[ATag];
    if RealKmPtr_th2[ATag].UseYn then vRealKmPtr := RealKmPtr_th2[ATag];
    if RealKmPtr_th3[ATag].UseYn then vRealKmPtr := RealKmPtr_th3[ATag];
    if RealKmPtr_th4[ATag].UseYn then vRealKmPtr := RealKmPtr_th4[ATag];
  except
  end;
end;

procedure SetEnvVarRealKmValue( ATag : Integer );
begin
  try
    RealKmPtr_th1[ATag].UseYn := True;
    RealKmPtr_th2[ATag].UseYn := False;
    RealKmPtr_th3[ATag].UseYn := False;
    RealKmPtr_th4[ATag].UseYn := False;
  except
  end;
end;

function GetEnvHintValue(VarName: string; Frm_JON01N : TFrm_JON01N): string;
begin
  if VarName = 'cxLblCIDUseFlg' then Result := Trim(Frm_JON01N.cxLblCIDUseFlg.Hint) else
  if VarName = 'cxtCuBubin' then Result := Trim(Frm_JON01N.cxtCuBubin.Hint);
end;

procedure SetEnvHintValue(VarName, VarValue: string; Frm_JON01N : TFrm_JON01N);
begin
  if VarName = 'cxLblCIDUseFlg' then Frm_JON01N.cxLblCIDUseFlg.Hint := Trim(VarValue) else
  if VarName = 'cxtCuBubin' then Frm_JON01N.cxtCuBubin.Hint := Trim(VarValue);
end;

procedure SetEnvVarClick(VarName : string; Frm_JON01N : TFrm_JON01N);
begin
//  if VarName = 'BtnViaAdd' then Frm_JON01N.BtnViaAdd.Click else
//  if VarName = 'BtnViaMinus1' then Frm_JON01N.BtnViaMinus1.Click else
//  if VarName = 'BtnViaMinus2' then Frm_JON01N.BtnViaMinus[2].Click else
//  if VarName = 'BtnViaMinus3' then Frm_JON01N.BtnViaMinus[3].Click else
//  if VarName = 'BtnViaMinus4' then Frm_JON01N.BtnViaMinus[4].Click else
//  if VarName = 'BtnViaMinus5' then Frm_JON01N.BtnViaMinus[5].Click else
//  if VarName = 'cbCardSanction' then Frm_JON01N.cbCardSanction.Click else
//  if VarName = 'btnCmdNoSMS' then Frm_JON01N.btnCmdNoSMS.Click else
//  if VarName = 'btnPickupInsert' then Frm_JON01N.btnPickupInsert.Click else
//  if VarName = 'btnCmdJoinCopy' then Frm_JON01N.btnCmdJoinCopy.Click else
//  if VarName = 'btnCmdWaitCopy' then Frm_JON01N.btnCmdWaitCopy.Click else
//  if VarName = 'btnCmdJoin' then Frm_JON01N.btnCmdJoin.Click else
//  if VarName = 'btnCmdWait' then Frm_JON01N.btnCmdWait.Click else
//  if VarName = 'btnCmdQuestion' then Frm_JON01N.btnCmdQuestion.Click else
//  if VarName = 'btnCmdExit' then Frm_JON01N.btnCmdExit.Click else
//  if VarName = 'BtnResvView' then Frm_JON01N.BtnResvView.Click else
//  if VarName = 'BtnResv' then Frm_JON01N.BtnResv.Click else
//  if VarName = 'BtnResvCsl' then Frm_JON01N.BtnResvCsl.Click else
//  if VarName = 'BtnResvClose' then Frm_JON01N.BtnResvClose.Click else
//  if VarName = 'btnSViewMap' then Frm_JON01N.AddSpop('출발지 지도보기', 0) else
//  if VarName = 'btnViewMap' then Frm_JON01N.btnViewMap.Click else
//  if VarName = 'BtnSR' then Frm_JON01N.BtnSR.Click else
//  if VarName = 'btnRQALExit' then Frm_JON01N.btnRQALExit.Click else
//  if VarName = 'BtnQRate' then Frm_JON01N.RQAListView.DataController.SetRecordCount(0) else
//  if VarName = 'btnDCalc' then Frm_JON01N.btnDCalc.Click else
//  if VarName = 'BtnWkAgeDown' then
//  begin
//    Frm_JON01N.BtnWkAge.Down := True;
//    Frm_JON01N.BtnWkAge.Click;
//  end else
//  if VarName = 'BtnWkAgeUp' then
//  begin
//    Frm_JON01N.BtnWkAge.Down := False;
//    Frm_JON01N.BtnWkAge.Click;
//  end else
//  if VarName = 'btnWkAgeClose' then Frm_JON01N.btnWkAgeClose.Click else
//  if VarName = 'BtnSmartRate' then Frm_JON01N.BtnSmartRate.Click else
//  if VarName = 'btnSClose' then Frm_JON01N.btnSClose.Click else
//  if VarName = 'btnEClose' then Frm_JON01N.btnEClose.Click else
//  if VarName = 'GBStartXYView' then Frm_JON01N.GBStartXYView.Visible := True else
//  if VarName = 'GBEndXYView' then Frm_JON01N.GBEndXYView.Visible := True;
end;

function fGetFrmCShare(bFirst : Boolean; ATag : Integer; Frm_JON01N : TFrm_JON01N ) : String;
Var i, j : Integer;
    sValue : String;

    subObj : TJSONObject;
    jso : TJSONObject;
    jsoAry : TJSONArray;
begin
  with Frm_JON01N do
  begin
    subObj := TJSONObject.Create;
    try
      jsoAry := TJSONArray.Create;
      for i := 0 to Length(ComShare) - 1 do
      begin
        if Not Assigned(FindComponent(ComShare[i])) then Continue;
        
        for j := 0 to ComponentCount - 1 do
        begin
          try
            if Components[j].Name = FindComponent(ComShare[i]).Name then
            begin
              if Components[j] is TPanel then
              begin
                sValue := (Components[j] as TPanel).Caption;
              end else
              if Components[j] is TLabel then
              begin
                sValue := (Components[j] as TLabel).Caption;
              end else
              if Components[j] is TEdit then
              begin
                sValue := (Components[j] as TEdit).Text;
              end else
              if Components[j] is TcxLabel then
              begin
                sValue := (Components[j] as TcxLabel).Caption;
              end else
              if Components[j] is TcxCheckBox then
              begin
                if (Components[j] as TcxCheckBox).Checked then sValue := '1'
                                                          else sValue := '0';
              end else
              if Components[j] is TcxTextEdit then
              begin
                sValue := (Components[j] as TcxTextEdit).Text;
              end else
              if Components[j] is TcxMemo then
              begin
                sValue := (Components[j] as TcxMemo).Text;
              end else
              if Components[j] is TcxRichEdit then
              begin
                sValue := (Components[j] as TcxRichEdit).Text;
              end else
              if Components[j] is TcxCurrencyEdit then
              begin
                sValue := (Components[j] as TcxCurrencyEdit).Text;
              end else
              if Components[j] is TcxDateEdit then
              begin
                sValue := (Components[j] as TcxDateEdit).Text;
              end else
              if Components[j] is TcxTimeEdit then
              begin
                sValue := (Components[j] as TcxTimeEdit).Text;
              end else
              if Components[j] is TcxSpinEdit then
              begin
                sValue := (Components[j] as TcxSpinEdit).Value;
              end else
              if Components[j] is TcxButton then
              begin
                if (Components[j] as TcxButton).Enabled then sValue := '1'
                                                        else sValue := '0';
              end else
              if Components[j] is TcxComboBox then
              begin
                sValue := IntToStr((Components[j] as TcxComboBox).ItemIndex);
              end else
              if Components[j] is TAdvGlowButton then
              begin
                if (Components[j] as TAdvGlowButton).Down then sValue := '1'
                                                          else sValue := '0';
              end else
              if Components[j] is TSpeedButton then
              begin
                if (Components[j] as TSpeedButton).Down then sValue := '1'
                                                        else sValue := '0';
              end;

              if Trim(gvComShare[i]) <> sValue then
              begin
                gvComShare[i] := sValue;
                jso := TJSONObject.Create;
                jso.AddPair(TJsonPair.Create('io', fGetComNameToCode(Components[j].ClassName)));
                jso.AddPair(TJsonPair.Create('in', Components[j].Name));
                jso.AddPair(TJsonPair.Create('ic', sValue));
                jsoAry.AddElement(jso);
              end;
              Break;
            end;
          except

          end;
        end;
      end;

      for i := 0 to Length(VarShare) - 1 do
      begin
        if ( VarShare[i] = 'ViaAddTag' ) And Not bFirst then Continue;
        
//        sValue := GetEnvVarValue(VarShare[i], ATag, Frm_JON01N);
        if Trim(gvVarShare[i]) <> sValue then
        begin
          gvVarShare[i] := sValue;
          jso := TJSONObject.Create;
          jso.AddPair(TJsonPair.Create('io', fGetComNameToCode('Variables')));
          jso.AddPair(TJsonPair.Create('in', VarShare[i]));
          jso.AddPair(TJsonPair.Create('ic', sValue));
          jsoAry.AddElement(jso);
        end;
      end;

      for i := 0 to Length(HintShare) - 1 do
      begin
        sValue := GetEnvHintValue(HintShare[i], Frm_JON01N);
        if Trim(gvHintShare[i]) <> sValue then
        begin
          gvHintShare[i] := sValue;
          jso := TJSONObject.Create;
          jso.AddPair(TJsonPair.Create('io', fGetComNameToCode('Hint')));
          jso.AddPair(TJsonPair.Create('in', HintShare[i]));
          jso.AddPair(TJsonPair.Create('ic', sValue));
          jsoAry.AddElement(jso);
        end;
      end;

      subObj.AddPair( TJSONPair.Create('ls', jsoAry));
      Result := subObj.Get('ls').JsonValue.ToString
    finally
      FreeAndNil(subObj);
    end;
  end;
end;

function fGetComNameToCode( AComName : String ) : String;    // 705전문 사이즈 줄이기 위해 코드로 정의 사용
begin
  try
    if AComName = 'TPanel'          then Result := '01' else
    if AComName = 'TLabel'          then Result := '02' else
    if AComName = 'TEdit'           then Result := '03' else
    if AComName = 'TcxLabel'        then Result := '04' else
    if AComName = 'TcxCheckBox'     then Result := '05' else
    if AComName = 'TcxTextEdit'     then Result := '06' else
    if AComName = 'TcxMemo'         then Result := '07' else
    if AComName = 'TcxRichEdit'     then Result := '08' else
    if AComName = 'TcxCurrencyEdit' then Result := '09' else
    if AComName = 'TcxDateEdit'     then Result := '10' else
    if AComName = 'TcxTimeEdit'     then Result := '11' else
    if AComName = 'TcxSpinEdit'     then Result := '12' else
    if AComName = 'TcxButton'       then Result := '13' else
    if AComName = 'TcxComboBox'     then Result := '14' else
    if AComName = 'TAdvGlowButton'  then Result := '15' else
    if AComName = 'TSpeedButton'    then Result := '16' else

    if AComName = 'Variables'       then Result := '50' else
    if AComName = 'Hint'            then Result := '51' else
    if AComName = 'ClickEvent'      then Result := '52';


  except
    Result := '99';
  end;
end;

function fGetCodeToComName( ACode : String ) : String;
begin
  try
    if ACode = '01' then Result := 'TPanel'          else
    if ACode = '02' then Result := 'TLabel'          else
    if ACode = '03' then Result := 'TEdit'           else
    if ACode = '04' then Result := 'TcxLabel'        else
    if ACode = '05' then Result := 'TcxCheckBox'     else
    if ACode = '06' then Result := 'TcxTextEdit'     else
    if ACode = '07' then Result := 'TcxMemo'         else
    if ACode = '08' then Result := 'TcxRichEdit'     else
    if ACode = '09' then Result := 'TcxCurrencyEdit' else
    if ACode = '10' then Result := 'TcxDateEdit'     else
    if ACode = '11' then Result := 'TcxTimeEdit'     else
    if ACode = '12' then Result := 'TcxSpinEdit'     else
    if ACode = '13' then Result := 'TcxButton'       else
    if ACode = '14' then Result := 'TcxComboBox'     else
    if ACode = '15' then Result := 'TAdvGlowButton'  else
    if ACode = '16' then Result := 'TSpeedButton'    else

    if ACode = '50' then Result := 'Variables'       else
    if ACode = '51' then Result := 'Hint'            else
    if ACode = '52' then Result := 'ClickEvent';
  except
    Result := '';
  end;
end;

function fSet601QRate( ATag : Integer; Frm_JON01N : TFrm_JON01N ) : Boolean;
Var sVia  : String;
    i, lRow, iRow, iSta, iStaddr, iVia, iEda, iEdaddr, irKey : Integer;
begin
  SetDebugeWrite('Frm_JON01N.pSet601QRate');
  if Frm_Main.JON01MNG[ATag].rKey = '' then
  begin
    GMessageBox('고객 검색 후 요금 문의 바랍니다.', CDMSE);
    Result := False;
    Exit;
  end;

  try
    with Frm_JON01N do
    begin
      if (cxtStartYval.Text = '') then
      begin
        GMessageBox('출발지를 검색해야 요금 문의가 가능합니다.', CDMSE);
        Result := False;
        Exit;
      end;

      if (cxtEndYval.Text = '') then
      begin
        GMessageBox('도착지를 검색해야 요금 문의가 가능합니다.', CDMSE);
        Result := False;
        Exit;
      end;

      iSta    := Frm_Main.cxGridQRate.GetColumnByFieldName('출발지').Index;
      iStaddr := Frm_Main.cxGridQRate.GetColumnByFieldName('출발지주소').Index;
      iVia    := Frm_Main.cxGridQRate.GetColumnByFieldName('경유지').Index;
      iEda    := Frm_Main.cxGridQRate.GetColumnByFieldName('도착지').Index;
      iEdaddr := Frm_Main.cxGridQRate.GetColumnByFieldName('도착지주소').Index;

      lRow := 0;
      sVia := '';
      while lRow <= 4 do
      begin
        if GT_PASS_INFO[ATag][lRow].AREA1 = '' then break;
        if sVia = '' then
          sVia := En_Coding(GT_PASS_INFO[ATag][lRow].AREA4)
        else
          sVia := sVia + '/' + En_Coding(GT_PASS_INFO[ATag][lRow].AREA4);
        inc(lRow);
      end;

      if gsrKey = '' then
      begin
        gsrKey := GT_USERIF.ID + FormatDateTime('yyyymmddhhmmss', Now);
      end else
      begin
        irKey := Frm_Main.cxGridQRate.GetColumnByFieldName('rkey').Index;
        iRow := Frm_Main.cxGridQRate.DataController.FindRecordIndexByText(0, irKey, gsrKey, False, True, True);
        if iRow < 0 then
        begin
          gsrKey := GT_USERIF.ID + FormatDateTime('yyyymmddhhmmss', Now);
        end else
        begin
          if ( Frm_Main.cxGridQRate.DataController.Values[iRow, iSta]    <> Trim(meoStartArea.Text) ) Or
             ( Frm_Main.cxGridQRate.DataController.Values[iRow, iStaddr] <> (lcsSta1 +' '+ lcsSta2 +' '+ lcsSta3) ) Or
             ( Frm_Main.cxGridQRate.DataController.Values[iRow, iVia]    <> Trim(sVia) ) Or
             ( Frm_Main.cxGridQRate.DataController.Values[iRow, iEda]    <> Trim(meoEndArea.Text) ) Or
             ( Frm_Main.cxGridQRate.DataController.Values[iRow, iEdaddr] <> (lcsEnd1 +' '+ lcsEnd2 +' '+ lcsEnd3) ) then
          begin
            gsrKey := GT_USERIF.ID + FormatDateTime('yyyymmddhhmmss', Now);
          end;
        end;
      end;

      GQ_Rate[ATag].cmd := '601';
      GQ_Rate[ATag].rkey := gsrKey;
      GQ_Rate[ATag].uid  := GT_USERIF.ID;
      GQ_Rate[ATag].unm  := GT_USERIF.NM;
      GQ_Rate[ATag].brno := Proc_BRNOSearch;           // 지사코드
      GQ_Rate[ATag].cuhp := IfThen(0 >= Pos('*', cxtCuTel.Text), cxtCallTelNum.Text, locsCuTel);  // 고객전화번호
      GQ_Rate[ATag].brKeyNum := cxTxtBrNameCaption.Text;
      GQ_Rate[ATag].corpnm := Copy(gsShortCoprNm[ATag], 1, pos('|', gsShortCoprNm[ATag])-1);
      GQ_Rate[ATag].corpdepnm := Copy(gsShortCoprNm[ATag], pos('|', gsShortCoprNm[ATag])+1, Length(gsShortCoprNm[ATag])-pos('|', gsShortCoprNm[ATag]));
      GQ_Rate[ATag].sta :=  Trim(meoStartArea.Text);
      GQ_Rate[ATag].staddr := lcsSta1 +','+ lcsSta2 +','+ lcsSta3;
      GQ_Rate[ATag].via := Trim(sVia);
      GQ_Rate[ATag].eda := Trim(meoEndArea.Text);
      GQ_Rate[ATag].edaddr := lcsEnd1 +','+ lcsEnd2 +','+ lcsEnd3;
      GQ_Rate[ATag].distance := curKm.Text;
      if fViaKm > 0 then
        GQ_Rate[ATag].ViaDist := FloatToStr(fViaKm) + 'Km';
      GQ_Rate[ATag].rate := curRate.Value;
      GQ_Rate[ATag].qtm := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now);
      GQ_Rate[ATag].aid := '';
      GQ_Rate[ATag].anm := '';
      GQ_Rate[ATag].arate := '0';
      GQ_Rate[ATag].amsg := '';
      GQ_Rate[ATag].atm := '';
      GQ_Rate[ATag].crkey := Frm_Main.JON01MNG[ATag].rKey;
      GQ_Rate[ATag].StaX := gsStartGUIDEXval;
      GQ_Rate[ATag].StaY := gsStartGUIDEYval;

      for i := 0 to 4 do
      begin
        if i = 0 then
        begin
          GQ_Rate[ATag].ViaX := GT_PASS_INFO[ATag][i].MAP_X;
          GQ_Rate[ATag].ViaY := GT_PASS_INFO[ATag][i].MAP_Y;
        end else
        begin
          GQ_Rate[ATag].ViaX := GQ_Rate[ATag].ViaX + '|' + GT_PASS_INFO[ATag][i].MAP_X;
          GQ_Rate[ATag].ViaY := GQ_Rate[ATag].ViaY + '|' + GT_PASS_INFO[ATag][i].MAP_Y;
        end;
      end;

      GQ_Rate[ATag].EndX := gsEndGUIDEXval;
      GQ_Rate[ATag].EndY := gsEndGUIDEYval;
    end;

    pSet601QRateSend(ATag);
    Result := True;
  except
    Result := False;
  end;
end;

procedure pSet601QRateSend ( ATag : Integer );
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  try
//    내역변경이 없어도 요금문의 처리 20200626  천사대리 요청
//    if ( GQ_PRate[ATag].sta    = GQ_Rate[ATag].sta ) And
//       ( GQ_PRate[ATag].staddr = GQ_Rate[ATag].staddr ) And
//       ( GQ_PRate[ATag].via    = GQ_Rate[ATag].via ) And
//       ( GQ_PRate[ATag].eda    = GQ_Rate[ATag].eda ) And
//       ( GQ_PRate[ATag].edaddr = GQ_Rate[ATag].edaddr ) And
//       ( GQ_PRate[ATag].rate   = GQ_Rate[ATag].rate ) then Exit;

    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '601'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('rkey'     , GQ_Rate[ATag].rKey));
      subObj.AddPair( TJSONPair.Create('uid'      , GQ_Rate[ATag].Uid));
      subObj.AddPair( TJSONPair.Create('unm'      , fJsonEncode(GQ_Rate[ATag].unm)));
      subObj.AddPair( TJSONPair.Create('brno'     , GQ_Rate[ATag].brno));
      subObj.AddPair( TJSONPair.Create('cuhp'     , GQ_Rate[ATag].cuhp));
      subObj.AddPair( TJSONPair.Create('brkeynum' , GQ_Rate[ATag].brKeyNum));
      subObj.AddPair( TJSONPair.Create('corpnm'   , GQ_Rate[ATag].corpnm));
      subObj.AddPair( TJSONPair.Create('corpdepnm', GQ_Rate[ATag].corpdepnm));
      subObj.AddPair( TJSONPair.Create('sta'      , fJsonEncode(GQ_Rate[ATag].sta)));
      subObj.AddPair( TJSONPair.Create('staddr'   , GQ_Rate[ATag].staddr));
      subObj.AddPair( TJSONPair.Create('via'      , fJsonEncode(GQ_Rate[ATag].via)));
      subObj.AddPair( TJSONPair.Create('eda'      , fJsonEncode(GQ_Rate[ATag].eda)));
      subObj.AddPair( TJSONPair.Create('edaddr'   , GQ_Rate[ATag].edaddr));
      subObj.AddPair( TJSONPair.Create('distance' , GQ_Rate[ATag].distance));
      subObj.AddPair( TJSONPair.Create('viadist'  , GQ_Rate[ATag].Viadist));
      subObj.AddPair( TJSONPair.Create('rate'     , GQ_Rate[ATag].rate));
      subObj.AddPair( TJSONPair.Create('qtm'      , GQ_Rate[ATag].qtm));
      subObj.AddPair( TJSONPair.Create('crkey'    , GQ_Rate[ATag].crkey));
      subObj.AddPair( TJSONPair.Create('jtype'    , GQ_Rate[ATag].jtype));

      subObj.AddPair( TJSONPair.Create('stax'     , GQ_Rate[ATag].StaX));
      subObj.AddPair( TJSONPair.Create('stay'     , GQ_Rate[ATag].StaY));
      subObj.AddPair( TJSONPair.Create('viax'     , GQ_Rate[ATag].ViaX));
      subObj.AddPair( TJSONPair.Create('viay'     , GQ_Rate[ATag].ViaY));
      subObj.AddPair( TJSONPair.Create('endx'     , GQ_Rate[ATag].EndX));
      subObj.AddPair( TJSONPair.Create('endy'     , GQ_Rate[ATag].EndY));

      jsoRlt.AddPair( TJSONPair.Create('bdy'      , subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
      GQ_PRate[ATag] := GQ_Rate[ATag];
      GS_RQ_SENDCRKEY := GQ_Rate[ATag].crkey;
    end;

    Frm_Main.cxPageControl2.ActivePageIndex := 3;
    pSetGridQRate(GQ_Rate[ATag]);
    Dm.pSendCMessenger(True, Str);
  except
  end;
end;

procedure pSet603QRateAnswer( vQ_Rate : TQ_Rate );
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '603'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('rkey', vQ_Rate.rkey));
      subObj.AddPair( TJSONPair.Create('uid' , vQ_Rate.uid));
      subObj.AddPair( TJSONPair.Create('aid' , vQ_Rate.aid));
      subObj.AddPair( TJSONPair.Create('anm' , vQ_Rate.anm));
      subObj.AddPair( TJSONPair.Create('rate', vQ_Rate.arate));
      subObj.AddPair( TJSONPair.Create('msg' , vQ_Rate.amsg));
      subObj.AddPair( TJSONPair.Create('atm' , vQ_Rate.atm));
      jsoRlt.AddPair( TJSONPair.Create('bdy' , subObj));

      Str := jsoRlt.ToString;
      SetDebugeWrite('TFrm_Main.RateAnswer : ' + Str );
    finally
      FreeAndNil(jsoRlt);
    end;

    Dm.pSendCMessenger(True, Str);
//    pSetGridQRate(vQ_Rate);
  except
  end;
end;

procedure pSet606QRateSave( ATag, AIdx : Integer; Frm_JON01N : TFrm_JON01N );
Var Str : String;
    jsoRlt, headObj, subObj : TJSONObject;
begin
  SetDebugeWrite('pSet606QRateSave');
  try
    with Frm_JON01N do
    begin
      GQ_Rate[ATag].cmd := '606';
      GQ_Rate[ATag].rkey := RQAListView.DataController.GetValue(AIdx, 06);
      GQ_Rate[ATag].uid  := RQAListView.DataController.GetValue(AIdx, 07);
      GQ_Rate[ATag].unm  := RQAListView.DataController.GetValue(AIdx, 08);
      GQ_Rate[ATag].brno := '';
      GQ_Rate[ATag].cuhp := '';
      GQ_Rate[ATag].sta :=  RQAListView.DataController.GetValue(AIdx, 09);
      GQ_Rate[ATag].staddr := StringReplace(RQAListView.DataController.GetValue(AIdx, 10),' ',',',[rfReplaceAll]);
      GQ_Rate[ATag].via := RQAListView.DataController.GetValue(AIdx, 11);
      GQ_Rate[ATag].eda := RQAListView.DataController.GetValue(AIdx, 12);
      GQ_Rate[ATag].edaddr := StringReplace(RQAListView.DataController.GetValue(AIdx, 13),' ',',',[rfReplaceAll]);
      GQ_Rate[ATag].rate := '0';
      GQ_Rate[ATag].qtm := RQAListView.DataController.GetValue(AIdx, 14);
      GQ_Rate[ATag].aid := RQAListView.DataController.GetValue(AIdx, 15);
      GQ_Rate[ATag].anm := RQAListView.DataController.GetValue(AIdx, 16);
      GQ_Rate[ATag].arate := RQAListView.DataController.GetValue(AIdx, 01);
      GQ_Rate[ATag].amsg := RQAListView.DataController.GetValue(AIdx, 03);
      GQ_Rate[ATag].atm := RQAListView.DataController.GetValue(AIdx, 17);
      GQ_Rate[ATag].crkey := '';
    end;

    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '606'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('rkey'  , GQ_Rate[ATag].rKey));
      subObj.AddPair( TJSONPair.Create('uid'   , GQ_Rate[ATag].Uid));
      subObj.AddPair( TJSONPair.Create('unm'   , fJsonEncode(GQ_Rate[ATag].unm)));
      subObj.AddPair( TJSONPair.Create('sta'   , fJsonEncode(GQ_Rate[ATag].sta)));
      subObj.AddPair( TJSONPair.Create('staddr', GQ_Rate[ATag].staddr));
      subObj.AddPair( TJSONPair.Create('via'   , fJsonEncode(GQ_Rate[ATag].via)));
      subObj.AddPair( TJSONPair.Create('eda'   , fJsonEncode(GQ_Rate[ATag].eda)));
      subObj.AddPair( TJSONPair.Create('edaddr', GQ_Rate[ATag].edaddr));
      subObj.AddPair( TJSONPair.Create('qtm'   , GQ_Rate[ATag].qtm));
      subObj.AddPair( TJSONPair.Create('aid'   , GQ_Rate[ATag].aid));
      subObj.AddPair( TJSONPair.Create('anm'   , fJsonEncode(GQ_Rate[ATag].anm)));
      subObj.AddPair( TJSONPair.Create('rate'  , GQ_Rate[ATag].arate));
      subObj.AddPair( TJSONPair.Create('msg'   , fJsonEncode(GQ_Rate[ATag].amsg)));
      subObj.AddPair( TJSONPair.Create('atm'   , GQ_Rate[ATag].atm));
      jsoRlt.AddPair( TJSONPair.Create('bdy'   , subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;
    Dm.pSendCMessenger(True, Str);
  except
  end;
end;

procedure pSet607QRateDel( ATag, AIdx : Integer; Frm_JON01N : TFrm_JON01N );
Var Str : String;
    jsoRlt, headObj, subObj : TJSONObject;
begin
  SetDebugeWrite('pSet607QRateDel');
  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '607'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('rkey'  , String(Frm_JON01N.RQAListView.DataController.GetValue(AIdx, 06))));
      subObj.AddPair( TJSONPair.Create('staddr', StringReplace(Frm_JON01N.RQAListView.DataController.GetValue(AIdx, 10),' ',',',[rfReplaceAll])));
      subObj.AddPair( TJSONPair.Create('edaddr', StringReplace(Frm_JON01N.RQAListView.DataController.GetValue(AIdx, 13),' ',',',[rfReplaceAll])));
      jsoRlt.AddPair( TJSONPair.Create('bdy'   , subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;
    Dm.pSendCMessenger(True, Str);
  except
  end;
end;

procedure pSet701CShareValue( ATag : Integer; Frm_JON01N : TFrm_JON01N );
Var sVia : String;
    lRow : Integer;
begin
  try
    if Not Frm_Main.JON01MNG[ATag].rOriginal then Exit;

    with Frm_JON01N do
    begin
      GC_Share[ATag].cmd  := '701';   // 전문코드
      GC_Share[ATag].rkey := Frm_Main.JON01MNG[ATag].rKey;

      GC_Share[ATag].uid := GT_USERIF.ID;               // 사용자아이디
      GC_Share[ATag].unm :=  GT_USERIF.NM;              // 사용자이름
      GC_Share[ATag].brno := Proc_BRNOSearch;           // 지사코드
      GC_Share[ATag].brnm := Proc_BrNameReadSearch;     // 지사명
      GC_Share[ATag].mnum := Proc_MainKeyNumberSearch;  // 대표번호
      if cxLblCIDUseFlg.Hint <> 'CID' then
        GC_Share[ATag].ost  := '신규'                    // 상태
      else
        GC_Share[ATag].ost  := '콜링';                    // 상태
      GC_Share[ATag].cuhp := IfThen(0 >= Pos('*', cxtCuTel.Text), cxtCallTelNum.Text, locsCuTel);  // 고객전화번호
      GC_Share[ATag].cunm := En_Coding(edtCuName.Text);  // 고객명
      GC_Share[ATag].sta  := Trim(meoStartArea.Text);    // 출발지명
      GC_Share[ATag].staddr := lcsSta1 +','+ lcsSta2 +','+ lcsSta3; // 출발지 주소 (시/도, 시/군/구, 읍/면/동)

      lRow := 0;
      sVia := '';
      while lRow <= 4 do
      begin
        if GT_PASS_INFO[ATag][lRow].AREA1 = '' then break;
        if sVia = '' then
          sVia := En_Coding(GT_PASS_INFO[ATag][lRow].AREA4)
        else
          sVia := sVia + '/' + En_Coding(GT_PASS_INFO[ATag][lRow].AREA4);
        inc(lRow);
      end;

      GC_Share[ATag].via := Trim(sVia);    // 경유지1/경유지2/경유지3/경유지n……(경유지 여러 개 일때 (/)슬래쉬로 구분,,,,)
      GC_Share[ATag].eda := Trim(meoEndArea.Text);    // 도착지명
      GC_Share[ATag].edaddr := lcsEnd1 +','+ lcsEnd2 +','+ lcsEnd3; // 도착지 주소 (시/도, 시/군/구, 읍/면/동)
      GC_Share[ATag].rate := curRate.Value;  // 요금
      GC_Share[ATag].bigo := meoBigo.Text;  // 적요1
      GC_Share[ATag].catm := Frm_Main.JON01MNG[ATag].rTime;  // 콜링시간(yyyy-mm-dd hh:mm:ss)
    end;

    pSet701CShareSend( ATag );
  except
  end;
end;

procedure pSet701CShareSend( ATag : Integer );
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  try
    // 전송 정보가 변경이 없으면 전송 않함
    if ( GC_PShare[ATag].brno = GC_Share[ATag].brno ) And
       ( GC_PShare[ATag].brnm = GC_Share[ATag].brnm ) And   // 지사명
       ( GC_PShare[ATag].mnum = GC_Share[ATag].mnum ) And   // 대표번호
       ( GC_PShare[ATag].cuhp = GC_Share[ATag].cuhp ) And   // 고객전화번호
       ( GC_PShare[ATag].cunm = GC_Share[ATag].cunm ) And   // 고객명
       ( GC_PShare[ATag].sta  = GC_Share[ATag].sta  ) And   // 출발지명
       ( GC_PShare[ATag].staddr = GC_Share[ATag].staddr ) And // 출발지 주소 (시/도, 시/군/구, 읍/면/동)
       ( GC_PShare[ATag].via  = GC_Share[ATag].via  ) And   // 경유지1/경유지2/경유지3/경유지n……(경유지 여러 개 일때 (/)슬래쉬로 구분,,,,)
       ( GC_PShare[ATag].eda  = GC_Share[ATag].eda  ) And   // 도착지명
       ( GC_PShare[ATag].edaddr = GC_Share[ATag].edaddr ) And // 도착지 주소 (시/도, 시/군/구, 읍/면/동)
       ( GC_PShare[ATag].rate = GC_Share[ATag].rate ) then  // 요금
    begin
      Exit;
    end;

    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', GC_Share[ATag].cmd));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('rkey'  , GC_Share[ATag].rKey));
      subObj.AddPair( TJSONPair.Create('uid'   , GC_Share[ATag].Uid));
      subObj.AddPair( TJSONPair.Create('unm'   , fJsonEncode(GC_Share[ATag].unm)));
      subObj.AddPair( TJSONPair.Create('brno'  , GC_Share[ATag].brno));
      subObj.AddPair( TJSONPair.Create('brnm'  , fJsonEncode(GC_Share[ATag].brnm)));
      subObj.AddPair( TJSONPair.Create('mnum'  , GC_Share[ATag].mnum));
      subObj.AddPair( TJSONPair.Create('ost'   , GC_Share[ATag].ost));
      subObj.AddPair( TJSONPair.Create('cuhp'  , GC_Share[ATag].cuhp));
      subObj.AddPair( TJSONPair.Create('cunm'  , fJsonEncode(GC_Share[ATag].cunm)));
      subObj.AddPair( TJSONPair.Create('sta'   , fJsonEncode(GC_Share[ATag].sta)));
      subObj.AddPair( TJSONPair.Create('staddr', GC_Share[ATag].staddr));
      subObj.AddPair( TJSONPair.Create('via'   , fJsonEncode(GC_Share[ATag].via)));
      subObj.AddPair( TJSONPair.Create('eda'   , fJsonEncode(GC_Share[ATag].eda)));
      subObj.AddPair( TJSONPair.Create('edaddr', GC_Share[ATag].edaddr));
      subObj.AddPair( TJSONPair.Create('rate'  , GC_Share[ATag].rate));
      subObj.AddPair( TJSONPair.Create('bigo'  , fJsonEncode(GC_Share[ATag].bigo)));
      subObj.AddPair( TJSONPair.Create('jtype' , GC_Share[ATag].jtype));
      subObj.AddPair( TJSONPair.Create('catm'  , GC_Share[ATag].catm));

      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
      GC_PShare[ATag] := GC_Share[ATag];
    end;

//    Frm_Main.cxPageControl2.ActivePageIndex := 6;
//    Frm_Main.pSetGridCShare( GC_Share[ATag] );
    Dm.pSendCMessenger(False, Str);
  except
  end;
end;

procedure pSet703CShareClose( sGubun : String; ATag : Integer; Frm_JON01N : TFrm_JON01N );
begin
  if Not Frm_Main.JON01MNG[ATag].rOriginal then Exit;

  try
    with Frm_JON01N do
    begin
      GC_Share[ATag].cmd  := '703';   // 전문코드
      GC_Share[ATag].rkey := Frm_Main.JON01MNG[ATag].rKey;     // 콜링 접수창 정보 고유키값(ID + datetime[yyyymmddhhmmss])
      GC_Share[ATag].uid := GT_USERIF.ID;                          // 사용자아이디
      GC_Share[ATag].unm :=  GT_USERIF.NM;                         // 사용자이름
      GC_Share[ATag].cuhp := IfThen(0 >= Pos('*', cxtCuTel.Text), cxtCallTelNum.Text, locsCuTel);  // 고객전화번호
    end;

    pSet703CShareCloseSend(sGubun, ATag);
  except
  end;
end;

procedure pSet703CShareCloseSend( sGubun : String; ATag : Integer );
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', GC_Share[ATag].cmd));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('rkey', GC_Share[ATag].rKey));
      subObj.AddPair( TJSONPair.Create('uid' , GC_Share[ATag].Uid));
      subObj.AddPair( TJSONPair.Create('unm' , GC_Share[ATag].unm));
      subObj.AddPair( TJSONPair.Create('cuhp', GC_Share[ATag].cuhp));
      subObj.AddPair( TJSONPair.Create('clgb', sGubun));

      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;

//    Frm_Main.cxPageControl2.ActivePageIndex := 6;
//    Frm_Main.pSetGridCShare( GC_Share[ATag] );  // 704로 받아서 처리하는 걸로 변경
    Dm.pSendCMessenger(False, Str);
  except
  end;
end;

procedure pSet708CShareCall(Agbup, Agb, ArKey, AjId, AjNm, ArId, ArNm : String);
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  if ArKey = '' then Exit;

  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '708'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('ckey' , ArKey));
      subObj.AddPair( TJSONPair.Create('jid'  , AjId));
      subObj.AddPair( TJSONPair.Create('jnm'  , AjNm));
      subObj.AddPair( TJSONPair.Create('rid'  , ArId));
      subObj.AddPair( TJSONPair.Create('rnm'  , ArNm));
      subObj.AddPair( TJSONPair.Create('ogb'  , Agb));
      subObj.AddPair( TJSONPair.Create('ogbup', Agbup));

      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;

    Dm.pSendCMessenger(True, Str);
  except
  end;
end;

procedure pSet705CShareCancel(Agb, ArKey, AjId, ArId : String);
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '705'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('ckey' , ArKey));
      subObj.AddPair( TJSONPair.Create('jid'  , AjId));
      subObj.AddPair( TJSONPair.Create('rid'  , ArId));
      subObj.AddPair( TJSONPair.Create('ogb'  , Agb));
      subObj.AddPair( TJSONPair.Create('ogbup', 'c'));
      subObj.AddPair( TJSONPair.Create('ls' , '[]'));
      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;

      Dm.pSendCMessenger(True, Str);
    finally
      FreeAndNil(jsoRlt);
    end;
  except
  end;
end;

procedure pSet705CShareData(bFirst:Boolean; AgbUp, Agb, ArKey, AjId, ArId : String; ATag : Integer; Frm_JON01N : TFrm_JON01N );
Var jsoRlt, headObj, subObj : TJSONObject;
    arrObj: TJSONArray;
    sls, Str : String;
begin
  if Frm_Main.JON01MNG[ATag].rKey = '' then Exit;

  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '705'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('ckey' , ArKey));
      subObj.AddPair( TJSONPair.Create('jid'  , AjId));
      subObj.AddPair( TJSONPair.Create('rid'  , ArId));
      subObj.AddPair( TJSONPair.Create('ogb'  , Agb));
      subObj.AddPair( TJSONPair.Create('ogbup', AgbUp));

      sls := fGetFrmCShare(bFirst, ATag, Frm_JON01N);
      if ( GC_PRE_CSHAREDATA <> sls ) And ( '[]' <> sls ) then
      begin
        GC_PRE_CSHAREDATA := sls;
        arrObj := TJSONObject.ParseJSONValue(sls) as TJSONArray;

        subObj.AddPair( TJSONPair.Create('ls' , arrObj));
        jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
        Str := jsoRlt.ToString;

        Dm.pSendCMessenger(True, Str);
      end;
    finally
      FreeAndNil(jsoRlt);
    end;
  except
  end;
end;

procedure pSet705CShareClick(Agb, ArKey, AjId, ArId, AClickNm : String; ATag : Integer );
Var jsoRlt, headObj, subObj : TJSONObject;
    arrObj: TJSONArray;
    jso : TJSONObject;
    Str : String;
begin
  if Frm_Main.JON01MNG[ATag].rKey = '' then Exit;

  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '705'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('ckey' , ArKey));
      subObj.AddPair( TJSONPair.Create('jid'  , AjId));
      subObj.AddPair( TJSONPair.Create('rid'  , ArId));
      subObj.AddPair( TJSONPair.Create('ogb'  , Agb));
      subObj.AddPair( TJSONPair.Create('ogbup', 'n'));

      arrObj := TJSONArray.Create;
      jso := TJSONObject.Create;
      jso.AddPair(TJsonPair.Create('io', fGetComNameToCode('ClickEvent')));
      jso.AddPair(TJsonPair.Create('in', AClickNm));
      jso.AddPair(TJsonPair.Create('ic', '1'));
      arrObj.AddElement(jso);

      subObj.AddPair( TJSONPair.Create('ls' , arrObj));
      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;

      Dm.pSendCMessenger(True, Str);
    finally
      FreeAndNil(jsoRlt);
    end;
  except
  end;
end;

procedure pSet705CShareDataClick(bFirst:Boolean; Agb, ArKey, AjId, ArId, AClickNm : String; ATag : Integer; Frm_JON01N : TFrm_JON01N );
Var jsoRlt, headObj, subObj : TJSONObject;
    arrObj: TJSONArray;
    jso : TJSONObject;    
    sls, Str : String;
begin
  if Frm_Main.JON01MNG[ATag].rKey = '' then Exit;

  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '705'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('ckey' , ArKey));
      subObj.AddPair( TJSONPair.Create('jid'  , AjId));
      subObj.AddPair( TJSONPair.Create('rid'  , ArId));
      subObj.AddPair( TJSONPair.Create('ogb'  , Agb));
      subObj.AddPair( TJSONPair.Create('ogbup', 'n'));

      sls := fGetFrmCShare(bFirst, ATag, Frm_JON01N);

      arrObj := TJSONObject.ParseJSONValue(sls) as TJSONArray;

      jso := TJSONObject.Create;
      jso.AddPair(TJsonPair.Create('io', fGetComNameToCode('ClickEvent')));
      jso.AddPair(TJsonPair.Create('in', AClickNm));
      jso.AddPair(TJsonPair.Create('ic', '1'));
      arrObj.AddElement(jso);        

      subObj.AddPair( TJSONPair.Create('ls' , arrObj));
      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;

      Dm.pSendCMessenger(True, Str);
    finally
      FreeAndNil(jsoRlt);
    end;
  except
  end;
end;

procedure pSet706CShareEnd(ArKey, AjId, ArId, AWcl : String);
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  if ArKey = '' then Exit;

  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '706'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('ckey' , ArKey));
      subObj.AddPair( TJSONPair.Create('jid'  , AjId));
      subObj.AddPair( TJSONPair.Create('rid'  , ArId));
      subObj.AddPair( TJSONPair.Create('ogb'  , 'r'));
      subObj.AddPair( TJSONPair.Create('ogbup', 'n'));
      subObj.AddPair( TJSONPair.Create('wcl'  , AWcl));

      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;

    Dm.pSendCMessenger(True, Str);
  except
  end;
end;

procedure pSet705CShareClickEvent( AEventName : String; ATag : Integer; Frm_JON01N : TFrm_JON01N );
begin
//  with Frm_JON01N do
//  begin
//    tmrCShare.Enabled := False;
//    try
//      if ( pnlRShare.Visible ) Or ( pnlRShare.Tag = 1 ) then
//      begin
//        if lblCShareJId.Hint = GT_USERIF.ID then
//        begin
//          pSet705CShareClick('j', Frm_Main.JON01MNG[ATag].rKey, lblCShareJId.Hint, lblCShareRId.Hint, AEventName, ATag);
//        end else
//        if lblCShareRId.Hint = GT_USERIF.ID then
//        begin
//          pSet705CShareClick('r', Frm_Main.JON01MNG[ATag].rKey, lblCShareJId.Hint, lblCShareRId.Hint, AEventName, ATag);
//        end;
//      end;
//    finally
//      tmrCShare.Enabled := True;
//    end;
//  end;
end;

procedure pSet370FileUpload( AFileName : String );
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  SetDebugeWrite('pSet370FileUpload');

  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '370'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('filename', StringReplace(AFileName, '\' , '&#x5c;', [rfReplaceAll]) ) );
      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;
    Dm.pSendCMessenger(True, Str);
  except
  end;
end;

procedure pSet380ServerSetting( AType, ASsyn, ASset : String );
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  SetDebugeWrite('pSet380ServerSetting');

  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '380'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('type', AType));
      subObj.AddPair( TJSONPair.Create('hdno', GT_USERIF.HD));
      subObj.AddPair( TJSONPair.Create('uid' , GT_USERIF.ID));
      subObj.AddPair( TJSONPair.Create('unm' , GT_USERIF.NM));
      subObj.AddPair( TJSONPair.Create('ssyn', ASsyn));
      subObj.AddPair( TJSONPair.Create('sset', ASset));
      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;
    Dm.pSendCMessenger(True, Str);
  except
  end;
end;

procedure pGet381ServerSetting;
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  SetDebugeWrite('pGet381ServerSetting');

  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '381'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('uid' , GT_USERIF.ID));
      subObj.AddPair( TJSONPair.Create('hdno', GT_USERIF.HD));
      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;
    Dm.pSendCMessenger(True, Str);
  except
  end;
end;

procedure pSet050CCList( iTag : Integer );
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  SetDebugeWrite('pSet050CCList');

  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      if iTag = 1415 then
        headObj.AddPair( TJSONPair.Create('cmd', '1415')) else
      if iTag = 1416 then
        headObj.AddPair( TJSONPair.Create('cmd', '1416'));

      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('uid', GT_USERIF.ID));
      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;
    Dm.pSendCMessenger(True, Str);
  except
  end;
end;

procedure pSetGridCShare( vC_Share : TC_Share );

  function GetRecordIndexByText(AView: TcxCustomGridTableView; AText: string; AColumnIndex: Integer): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to AView.DataController.RecordCount - 1 do
    begin
      if StrPos(PChar(AView.DataController.DisplayTexts[I, AColumnIndex]), PChar(AText)) <> nil then
			begin
        Result := i;
        Break;
      end;
    end;
  end;

Var iRow, i, icrKey, iStat, iGong : Integer;
    sMode : String;
    bNew  : Boolean;
begin
  SetDebugeWrite('Share.pSetGridCShare Start');
  try
    if ( vC_Share.Cmd = '701' ) Or ( vC_Share.Cmd = '703' ) then Exit;

    bNew := False;
    if Frm_Main.cxGridCShare.DataController.Filter.Active then
      iRow := GetRecordIndexByText(Frm_Main.cxGridCShare, vC_Share.rKey, 15)
    else
      iRow := Frm_Main.cxGridCShare.DataController.FindRecordIndexByText(0, 15, vC_Share.rKey, False, True, True);

    try
      Frm_Main.cxGridCShare.BeginUpdate;
      if ( vC_Share.Cmd = '702' ) then
      begin
        if ( GT_USERIF.Family = 'y' ) And ( GT_USERIF.LV = '60' ) then     // 20120629 LYB
        begin
          if scb_FamilyBrCode.IndexOf(vC_Share.brno) < 0 then Exit;
        end else
        begin
          if scb_BranchCode.IndexOf(vC_Share.brno) < 0 then Exit;
        end;

        if iRow < 0 then
        begin
          iRow := Frm_Main.cxGridCShare.DataController.AppendRecord;
          bNew := True;
        end;

        Frm_Main.cxGridCShare.DataController.Values[iRow, 00] := vC_Share.catm;                                              // 콜링시간
				Frm_Main.cxGridCShare.DataController.Values[iRow, 01] := vC_Share.unm;                                               // 접수자
        Frm_Main.cxGridCShare.DataController.Values[iRow, 02] := vC_Share.brnm;                                              // 지사명
        Frm_Main.cxGridCShare.DataController.Values[iRow, 03] := StrToCall(vC_Share.mnum);                                   // 대표번호

        if ( Frm_Main.cxGridCShare.DataController.Values[iRow, 04] ) <> '공유' then
        Frm_Main.cxGridCShare.DataController.Values[iRow, 04] := vC_Share.ost;                                               // 상태

        Frm_Main.cxGridCShare.DataController.Values[iRow, 05] := StrToCall(vC_Share.cuhp);                                   // 전화번호
        Frm_Main.cxGridCShare.DataController.Values[iRow, 06] := vC_Share.cunm;                                              // 고객명
        Frm_Main.cxGridCShare.DataController.Values[iRow, 07] := vC_Share.sta;                                               // 출발지
        Frm_Main.cxGridCShare.DataController.Values[iRow, 08] := StringReplace(vC_Share.staddr, ',', ' ', [rfReplaceAll]);   // 출발지주소
        Frm_Main.cxGridCShare.DataController.Values[iRow, 09] := vC_Share.via;                                               // 경유지
        Frm_Main.cxGridCShare.DataController.Values[iRow, 10] := vC_Share.eda;                                              //  도착지
        Frm_Main.cxGridCShare.DataController.Values[iRow, 11] := StringReplace(vC_Share.edaddr, ',', ' ', [rfReplaceAll]);  //  도착지주소
        Frm_Main.cxGridCShare.DataController.Values[iRow, 12] := StrToInt(vC_Share.rate);                                   //  요금
        Frm_Main.cxGridCShare.DataController.Values[iRow, 13] := '';                                                        //  경과(초)
        Frm_Main.cxGridCShare.DataController.Values[iRow, 14] := vC_Share.bigo;                                             //  적요
        Frm_Main.cxGridCShare.DataController.Values[iRow, 15] := vC_Share.rkey;                                             //  rKey
        Frm_Main.cxGridCShare.DataController.Values[iRow, 16] := vC_Share.uid;                                              //  uid
        Frm_Main.cxGridCShare.DataController.Values[iRow, 17] := vC_Share.brno;                                             //  brno
        Frm_Main.cxGridCShare.DataController.Values[iRow, 18] := vC_Share.jtype;                                            //  jtype
      end else
      if ( vC_Share.Cmd = '703' ) Or ( vC_Share.Cmd = '704' ) then
      begin
        SetDebugeWrite(Format('Share.pSetGridCShare %s - %d - %s', [vC_Share.Cmd, iRow, vC_Share.rKey]));
        if iRow >= 0 then
          Frm_Main.cxGridCShare.DataController.DeleteRecord(iRow);
      end;
    finally
      Frm_Main.cxGridCShare.EndUpdate;
      if Frm_Main.cxGridCShare.DataController.RecordCount > 0 then
        Frm_Main.tsBtmMenu3.Caption := Format('신규접수공유(%s)',[FormatFloat('#,##0', Frm_Main.cxGridCShare.DataController.RecordCount)])
      else
        Frm_Main.tsBtmMenu3.Caption := '신규접수공유';
    end;

    Frm_Main.cxGridCShare.Columns[0].SortIndex := 0;
    Frm_Main.cxGridCShare.Columns[0].SortOrder := soDescending;

    if ( vC_Share.Cmd = '702' ) And ( Not GB_NS_NOCHANGEMENU ) And ( bNew ) then
      Frm_Main.cxPageControl2.ActivePageIndex := 2;

    if ( vC_Share.Cmd = '707' ) Or ( vC_Share.Cmd = '709' ) then
    begin
      // 신규 접수 공유 상태 처리
      if ( vC_Share.Cmd = '707' ) then sMode := '콜링' else
      if ( vC_Share.Cmd = '709' ) then sMode := '공유';

      try
        Frm_Main.cxGridCShare.BeginUpdate;
        for i := 0 to Frm_Main.cxGridCShare.DataController.RecordCount - 1 do
        begin
          if vC_Share.rkey = Frm_Main.cxGridCShare.DataController.Values[i, 15] then
          begin
            Frm_Main.cxGridCShare.DataController.Values[i, 4] := sMode;
          end;
        end;
      finally
        Frm_Main.cxGridCShare.EndUpdate;
      end;

      // 요금문의 공유 상태 처리
      if ( vC_Share.Cmd = '707' ) then sMode := '' else
      if ( vC_Share.Cmd = '709' ) then sMode := '공유';

      try
        Frm_Main.cxGridQRate.BeginUpdate;
        icrKey := Frm_Main.cxGridQRate.GetColumnByFieldName('crkey').Index;
        iGong := Frm_Main.cxGridQRate.GetColumnByFieldName('공유여부').Index;
        for i := 0 to Frm_Main.cxGridQRate.DataController.RecordCount - 1 do
        begin
          if vC_Share.rkey = Frm_Main.cxGridQRate.DataController.Values[i, icrKey] then
          begin
            Frm_Main.cxGridQRate.DataController.Values[i, iGong] := sMode;
          end;
        end;
      finally
        Frm_Main.cxGridQRate.EndUpdate;
      end;
    end;

    if ( vC_Share.Cmd = '704' )  then
    begin
      if vC_Share.clgb = '5' then sMode := '대기' else
      if vC_Share.clgb = 'R' then sMode := '예약' else
      if vC_Share.clgb = '0' then sMode := '접수' else
      if vC_Share.clgb = 'C' then sMode := '근배' else
      if vC_Share.clgb = 'M' then sMode := '근배' else
      if vC_Share.clgb = 'B' then sMode := '배차중' else
      if vC_Share.clgb = '1' then sMode := '배차' else
      if vC_Share.clgb = '3' then sMode := '강제' else
      if vC_Share.clgb = '2' then sMode := '완료' else
      if vC_Share.clgb = '8' then sMode := '취소' else
      if vC_Share.clgb = '4' then sMode := '문의' else
      if vC_Share.clgb = 'Z' then sMode := '종료';

      try
        Frm_Main.cxGridQRate.BeginUpdate;
        icrKey := Frm_Main.cxGridQRate.GetColumnByFieldName('crkey').Index;
        iGong := Frm_Main.cxGridQRate.GetColumnByFieldName('공유여부').Index;
        iStat := Frm_Main.cxGridQRate.GetColumnByFieldName('상태').Index;
        for i := 0 to Frm_Main.cxGridQRate.DataController.RecordCount - 1 do
        begin
          if vC_Share.rkey = Frm_Main.cxGridQRate.DataController.Values[i, icrKey] then
          begin
            Frm_Main.cxGridQRate.DataController.Values[i, iStat] := sMode;
            Frm_Main.cxGridQRate.DataController.Values[i, iGong] := '';
          end;
        end;
      finally
        Frm_Main.cxGridQRate.EndUpdate;
      end;

      // 답변중인 요금에 대해 초기화 처리
      if Frm_Main.cxgrpQRHead.Hint = vC_Share.rkey then
      begin
        Frm_Main.cxgrpQRHead.Hint := '';
        Frm_Main.lblRateA.Hint := '';
        Frm_Main.lblRateA.Tag  := 0;
        Frm_Main.curRate.Value := 0;
        Frm_Main.lblRateE.Hint := '';
        Frm_Main.LbmeoBigo.Caption := '요금설명';
        Frm_Main.lbmeoBigo.Visible := True;
        Frm_Main.edtMemo.Text := '';
      end;

      // 답변 팝업창 자동 종료 - 상대방 접수창이 닫혔을 경우
      for i := 0 to 30 do
      begin
        if ( Assigned(Frm_Main.Frm_COM50[i]) ) And ( Frm_Main.COM50MNG[i].CreateYN )  then
        begin
          if vC_Share.rkey = Frm_Main.Frm_COM50[i].lblRQEnd.Hint then
          begin
            Frm_Main.Frm_COM50[i].pnlRQPopup.Enabled := False;
            Frm_Main.Frm_COM50[i].cxLabel8.Caption := '요금문의 요청한 상담원의 접수창이 종료되었으므로' + CRLF + CRLF +
                                                      '요금문의 답변 창 자동 종료합니다.';
            Frm_Main.Frm_COM50[i].pnlAutoClose.Left := (Frm_Main.Frm_COM50[i].pnlRQPopup.Width  - Frm_Main.Frm_COM50[i].pnlAutoClose.Width) div 2;
            Frm_Main.Frm_COM50[i].pnlAutoClose.Top  := (Frm_Main.Frm_COM50[i].pnlRQPopup.Height - Frm_Main.Frm_COM50[i].pnlAutoClose.Height) div 2;
            Frm_Main.Frm_COM50[i].pnlAutoClose.Visible := True;
            Frm_Main.Frm_COM50[i].Timer1.Enabled := True;
          end;
        end;
      end;

//      for i := 0 to JON_MAX_CNT - 1 do
//      begin
//        if Frm_Main.JON01MNG[i].rKey = vC_Share.rkey then
//        begin
//          Frm_Main.Frm_JON01N[i].pnlRShare.Visible := False;
//          Frm_Main.Frm_JON01N[i].pnlShare.Visible := False;
//          Frm_Main.Frm_JON01N[i].btnCmdExit.Click;
//        end;
//      end;
    end;
    Application.ProcessMessages;
    SetDebugeWrite('Share.pSetGridCShare End');
  except
    on e: exception do
    begin
      Log('Share.pSetGridCShare Error :' + E.Message, LOGDATAPATHFILE);
      Assert(False, 'Share.pSetGridCShare Error :' + E.Message);
    end;
  end;
end;

procedure pCP_702CShareRequest(sData: String);
var
  sBody : TJSONObject;
  vC_Share : TC_Share;
begin
  SetDebugeWrite('Share.pCP_702CShareRequest');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
    try
      vC_Share.cmd    := '702';
      vC_Share.rkey   := sBody.Get('rkey' ).JsonValue.Value;
      vC_Share.uid    := sBody.Get('uid' ).JsonValue.Value;
      vC_Share.unm    := fJsonDecode(sBody.Get('unm' ).JsonValue.Value);
      vC_Share.brno   := sBody.Get('brno'  ).JsonValue.Value;
      vC_Share.brnm   := fJsonDecode(sBody.Get('brnm'  ).JsonValue.Value);
      vC_Share.mnum   := sBody.Get('mnum'  ).JsonValue.Value;
      vC_Share.ost    := sBody.Get('ost'   ).JsonValue.Value;
      vC_Share.cuhp   := sBody.Get('cuhp'  ).JsonValue.Value;
      vC_Share.cunm   := fJsonDecode(sBody.Get('cunm'  ).JsonValue.Value);
      vC_Share.sta    := fJsonDecode(sBody.Get('sta'   ).JsonValue.Value);
      vC_Share.staddr := sBody.Get('staddr').JsonValue.Value;
      vC_Share.via    := fJsonDecode(sBody.Get('via'   ).JsonValue.Value);
      vC_Share.eda    := fJsonDecode(sBody.Get('eda'   ).JsonValue.Value);
      vC_Share.edaddr := sBody.Get('edaddr').JsonValue.Value;
      vC_Share.rate   := sBody.Get('rate'  ).JsonValue.Value;
      vC_Share.bigo   := fJsonDecode(sBody.Get('bigo'  ).JsonValue.Value);
      vC_Share.jtype  := sBody.Get('jtype' ).JsonValue.Value;
      vC_Share.catm   := sBody.Get('catm'  ).JsonValue.Value;
    finally
      FreeAndNil(sBody);
    end;

//    cxPageControl2.ActivePageIndex := 3;
		pSetGridCShare(vC_Share);
  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure pCP_704CShareClose(sData: String);
var
  sBody : TJSONObject;
  vC_Share : TC_Share;
begin
  SetDebugeWrite('Share.pCP_704CShareClose');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
    try
      vC_Share.cmd := '704';
      vC_Share.rkey := sBody.Get('rkey' ).JsonValue.Value;
      vC_Share.uid  := sBody.Get('uid' ).JsonValue.Value;
      vC_Share.unm :=  sBody.Get('unm' ).JsonValue.Value;
      vC_Share.cuhp :=  sBody.Get('cuhp' ).JsonValue.Value;
      vC_Share.clgb :=  sBody.Get('clgb' ).JsonValue.Value;
    finally
      FreeAndNil(sBody);
    end;

//    cxPageControl2.ActivePageIndex := 3;
		pSetGridCShare(vC_Share);
  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure pCP_370Result(sData: String);
var
  sBody : TJSONObject;
  sResult : String;
begin
  SetDebugeWrite('Share.pCP_370Result');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
    try
      sResult := sBody.Get('result').JsonValue.Value;
    finally
      FreeAndNil(sBody);
    end;

    if sResult = 'y' then
      pSet380ServerSetting(GS_IU, GS_FormSSYN, GS_FormSSET);

  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure pCP_371Result(sData: String);
var
  sBody : TJSONObject;
  sFileNm, sFileDt : String;
begin
  SetDebugeWrite('Share.pCP_371Result');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
    try
      sFileNm := sBody.Get('filename').JsonValue.Value;
      sFileDt := sBody.Get('datetime').JsonValue.Value;

    finally
      FreeAndNil(sBody);
    end;

  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure pCP_381GetServerSetting(ACid, sData: String);
begin

end;

procedure pCP_501Result(sData: String);
var
  sBody : TJSONObject;
  sResult, sMsg : String;
begin
  SetDebugeWrite('Share.pCP_501Result');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
    try
			sResult  := sBody.Get('rlt').JsonValue.Value;
      sMsg := sBody.Get('msg').JsonValue.Value;

			if sResult = 'y' then
      begin
				Application.ProcessMessages;
				case gBtnTag of
				0: GMessagebox('공지가 등록되었습니다', CDMSI);
				1: GMessagebox('공지가 수정되었습니다', CDMSI);
				2: GMessagebox('공지가 삭제되었습니다', CDMSI);
				3: GMessagebox('공지 예약이 해제되었습니다', CDMSI);
				end;

				if Assigned(Frm_JON24)  then 
				begin	 
					Frm_JON24.cxbModify.Enabled := True;
					Frm_JON24.btnClose.Click;
				end;
//				if ( not Assigned(Frm_JON23) ) Or ( Frm_JON23 = Nil ) then Frm_JON23 := TFrm_JON23.Create(nil);
//				Frm_JON23.proc_Search;
			end else
			begin
				GMessagebox(sResult + ' : ' + sMsg, CDMSE);
				if Assigned(Frm_JON24)  then 
				begin	 
					Frm_JON24.cxbModify.Enabled := True;
				end;
			end;
    finally
      FreeAndNil(sBody);
    end;

  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure pCP_601Result(sData: String);
var
  sBody : TJSONObject;
  sResult, sMsg : String;
  i : Integer;
begin
  SetDebugeWrite('Share.pCP_601Result');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
    try
      sResult  := sBody.Get('rlt').JsonValue.Value;
      sMsg := sBody.Get('msg').JsonValue.Value;

      if sResult = 'y' then
      begin
//        GMessagebox('접수창 요금 문의 완료', CDMSE);
        for i := 0 to JON_MAX_CNT - 1 do
        begin
          if Frm_Main.JON01MNG[i].rKey = GS_RQ_SENDCRKEY then
          begin
            if FPlusDongCHK = 2 then Frm_Main.Frm_JON01N[i].pnl_Charge.height := 36
                                else Frm_Main.Frm_JON01N[i].pnl_Charge.height := 21;
            Frm_Main.Frm_JON01N[i].Lbl_Charge.Caption := '접수창 요금 문의 완료';
            Frm_Main.Frm_JON01N[i].pnl_Charge.Visible := True;
            if Frm_Main.Frm_JON01N[i].curRate.CanFocus then Frm_Main.Frm_JON01N[i].curRate.SetFocus;
          end;
        end;
      end else
      begin
        GMessagebox(sResult + ' : ' + sMsg, CDMSE);
      end;
    finally
      FreeAndNil(sBody);
    end;
  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure pCP_801GetBrCash(sData: String);
var
  sBody : TJSONObject;
  sBrno : String;
  ls_TxQry, ls_TxLoad, swhere, sQueryTemp: string;
  ls_rxxml: string;
  StrList, ls_Rcrd : TStringList;
  ErrCode: integer;
  xdom: msDomDocument;
  lst_Result: IXMLDomNodeList;
  ls_ClientKey, ls_Msg_Err: string;
begin
  SetDebugeWrite('Share.pCP_801GetBrCash');

  sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
  try
    sBrno := sBody.Get('br_no').JsonValue.Value;
  finally
    FreeAndNil(sBody);
  end;

  try
    sWhere := format('WHERE BR_NO = ''%s'' ', [sBrno]);
    ls_TxLoad := GTx_UnitXmlLoad('SEL01.XML');
    fGet_BlowFish_Query(GSQ_BRANCH_SMS_CASH, sQueryTemp);
    ls_TxQry := Format(sQueryTemp, [sWhere]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'UserIDString', GT_USERIF.ID, [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'ClientVerString', VERSIONINFO, [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'ClientKeyString', 'CASH0002', [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'QueryString', ls_TxQry, [rfReplaceAll]);

    StrList := TStringList.Create;
    Screen.Cursor := crHandPoint;
    try
      if dm.SendSock(ls_TxLoad, StrList, ErrCode, False) then
      begin
        ls_rxxml := StrList[0];

        if trim(ls_rxxml) <> '' then
        begin
          Application.ProcessMessages;

          xdom := ComsDomDocument.Create;
          Screen.Cursor := crHourGlass;
          try
            ls_rxxml := ls_rxxml;
            if not xdom.loadXML(ls_rxxml) then
            begin
              Screen.Cursor := crDefault;
              Exit;
            end;

            ls_MSG_Err := GetXmlErrorCode(ls_rxxml);
            if ('0000' = ls_MSG_Err) then
            begin
              ls_ClientKey := GetXmlClientKey(ls_rxxml);

              if (0 < GetXmlRecordCount(ls_rxxml)) then
              begin
                lst_Result := xdom.documentElement.selectNodes('/cdms/Service/Data/Result');
                ls_Rcrd := TStringList.Create;
                try
                  GetTextSeperationEx('│', lst_Result.item[0].attributes.getNamedItem('Value').Text, ls_Rcrd);
                  p801SendBrCash(False, ls_Rcrd[0], ls_Rcrd[3]);
                finally
                  ls_Rcrd.Free;
                end;
              end;
            end  else
            begin
              Screen.Cursor := crDefault;
              p801SendBrCash(True, ls_MSG_Err, GetXmlErrorMsg(ls_rxxml));
            end;
          finally
            Screen.Cursor := crDefault;
            xdom := Nil;
          end;
        end;
      end;
    finally
      StrList.Free;
      Screen.Cursor := crDefault;
    end;
  except
  end;
end;

procedure p801SendBrCash(bError : Boolean; sCash, sDanga: String);
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '801'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      if bError then
      begin
        subObj.AddPair( TJSONPair.Create('rlt', 'n'));
        subObj.AddPair( TJSONPair.Create('msg' , sCash+'.'+sDanga));
        subObj.AddPair( TJSONPair.Create('cash' , '0'));
        subObj.AddPair( TJSONPair.Create('danga', '0'));
      end else
      begin
        subObj.AddPair( TJSONPair.Create('rlt', 'y'));
        subObj.AddPair( TJSONPair.Create('msg' , ''));
        subObj.AddPair( TJSONPair.Create('cash' , sCash));
        subObj.AddPair( TJSONPair.Create('danga', sDanga));
      end;

      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;

    Dm.pSendCMessenger(False, Str);
  except
  end;
end;

procedure pCP_802SendSMS(sData: String);
var
  sBody : TJSONObject;
  subjObj: TJSONObject;
  arriObj : TJSONArray;
  sSend, sRecv, sMsg, sRetime : String;
  ls_TxLoad : string;
  i : Integer;

  ls_rxxml: string;
  StrList : TStringList;
  ErrCode: integer;
  ls_Msg_Err: string;
begin
  SetDebugeWrite('Share.pCP_802SendSMS');

  sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
  try
    sRecv := '';

    arriObj := TJSONObject.ParseJSONValue(sBody.Get('r_ls').JsonValue.ToString) as TJSONArray;
    for i := 0 to arriObj.Size - 1 do
    begin
      subjObj := arriObj.Get(i) as TJSONObject;
      if i = ( arriObj.Size - 1 ) then
      begin
        sRecv := subjObj.Get('rnum').JsonValue.Value;
      end else
      begin
        sRecv := subjObj.Get('rnum').JsonValue.Value + ',';
      end;
    end;

    sSend := sBody.Get('snum').JsonValue.Value;
    sMsg  := sBody.Get('msg').JsonValue.Value;
    sRetime := sBody.Get('retime').JsonValue.Value;
  finally
    FreeAndNil(sBody);
  end;

  try
    sMsg := StringReplace(sMsg, #13#10, #10, [rfReplaceAll]);

    ls_TxLoad := GTx_UnitXmlLoad('SMS02.XML');
    ls_TxLoad := StringReplace(ls_TxLoad, 'UserIDString',     En_Coding(GT_USERIF.ID), [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'ClientVerString',  VERSIONINFO, [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'ClientKeyString',  'WSMS0001', [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'ReceiverString',   En_Coding(sRecv), [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'SenderString',     En_Coding(sSend), [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'MessageString',    En_Coding(sMsg), [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'ReservationString', sRetime, [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'MemoString', '[메신저문자전송]', [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'ConfSlipString', '', [rfReplaceAll]);
    ls_TxLoad := StringReplace(ls_TxLoad, 'WkSabunString', '', [rfReplaceAll]);

    StrList := TStringList.Create;
    Screen.Cursor := crHandPoint;
    try
      if dm.SendSock(ls_TxLoad, StrList, ErrCode, False) then
      begin
        ls_rxxml := StrList[0];

        if trim(ls_rxxml) <> '' then
        begin
          Application.ProcessMessages;

          Screen.Cursor := crHourGlass;
          try
            ls_rxxml := ls_rxxml;
            ls_Msg_Err := GetXmlErrorCode(ls_rxxml);
            if ('0000' = ls_Msg_Err) then
            begin
              p802SendSMSResult('y', '');
            end else
            begin
              p802SendSMSResult('n', ls_Msg_Err+'.'+GetXmlErrorMsg(ls_rxxml));
            end;
          finally
            Screen.Cursor := crDefault;
          end;
        end;
      end;
    finally
      StrList.Free;
      Screen.Cursor := crDefault;
    end;
  except
  end;
end;

procedure p802SendSMSResult( sResult, sMsg: String);
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '802'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('rlt', sResult));
      subObj.AddPair( TJSONPair.Create('msg', sMsg));

      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;
    Dm.pSendCMessenger(False, Str);
  except
  end;
end;

procedure pCP_901Result(sData: String);
var
  sBody : TJSONObject;
begin
  SetDebugeWrite('Share.pCP_901Result');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
    try
      GB_CUPDATE_CHK  := True;
      GS_CUPDATE_TYPE := sBody.Get('type').JsonValue.Value;
      GS_CUPDATE_VER  := sBody.Get('ver' ).JsonValue.Value;
    finally
      FreeAndNil(sBody);
    end;
  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure p902SendResult( sResult : String);
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '902'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      subObj.AddPair( TJSONPair.Create('result', sResult));
      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;
    Dm.pSendCMessenger(False, Str);
  except
  end;
end;

procedure p903SendMSNAlive;
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '903'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;
    Dm.pSendCMessenger(False, Str);
  except
  end;
end;

procedure pCP_903Result(sData: String);
var
  iHandle: THandle;
  CopyData: TCopyDataStruct;
  sBody : TJSONObject;
  sResult : String;
begin
  SetDebugeWrite('Share.pCP_903Result');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
    try
      sResult := sBody.Get('result').JsonValue.Value;

      iHandle := FindWindow('TfrmMain', PChar('콜마너 메신저 ' + GS_PRJ_AREA));
      if iHandle <> 0 then
      begin
        if sResult = 'y' then
        begin
          CopyData.cbData := Length('ACTIVE') + 1;
          CopyData.lpData := pAnsiChar('ACTIVE' + #0);
          SendMessage(iHandle, WM_COPYDATA, 0, LongInt(@CopyData));
        end else
        begin
          CopyData.cbData := Length('CLOSE') + 1;
          CopyData.lpData := pAnsiChar('CLOSE' + #0);
          SendMessage(iHandle, WM_COPYDATA, 0, LongInt(@CopyData));
          Sleep(500);
          Frm_Main.pExecMessenger(True);
        end;
      end;
    finally
      FreeAndNil(sBody);
    end;
  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure p999UpLogOut;
Var jsoRlt, headObj, subObj : TJSONObject;
    Str : String;
begin
  try
    // Make Json -----------------------------------------------------------------
    try
      jsoRlt := TJSONObject.Create;
      headObj := TJSONObject.Create;
      headObj.AddPair( TJSONPair.Create('seq', '%s'));
      headObj.AddPair( TJSONPair.Create('cmd', '999'));
      jsoRlt.AddPair( TJSONPair.Create('hdr', headObj));

      subObj := TJSONObject.Create;
      jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
      Str := jsoRlt.ToString;
    finally
      FreeAndNil(jsoRlt);
    end;
    Dm.pSendCMessenger(False, Str);
  except
  end;
end;

procedure pCP_013MemoNoticeList(sCmd, sData : String );
var
	slList: TStringList;
	i, idx : integer;
  sBody, subjObj : TJSONObject;
  arrjObj: TJSONArray;
  sKey : String;
begin
  SetDebugeWrite('Share.pCP_013MemoNoticeList');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;

    if sCmd = '013' then
    begin
      try
        arrjObj := TJSONObject.ParseJSONValue(sBody.Get('ls').JsonValue.ToString) as TJSONArray;
        sData := '';
        slGongjiList.Clear;
        slGongjiKey.Clear;
        for i := 0 to arrjObj.Size - 1 do
        begin
          subjObj := arrjObj.Get(i) as TJSONObject;

					sData := subjObj.Get('wtm' ).JsonValue.Value + Char(1) +    // 0.등록일시
									 subjObj.Get('tit' ).JsonValue.Value + Char(1) +    // 1.공지제목
									 subjObj.Get('cont').JsonValue.Value + Char(1) +    // 2.공지내용
									 subjObj.Get('wnm' ).JsonValue.Value + Char(1) +    // 3.등록자명
									 subjObj.Get('wid' ).JsonValue.Value + Char(1) +    // 4.등록자ID
									 'c' + Char(1) +                                    // 5.구분
									 subjObj.Get('nkey').JsonValue.Value + Char(1) +    // 6.키값
									 subjObj.Get('resv').JsonValue.Value;               // 7.예약일시

          if Trim(sData) <> '' then
          begin
            slGongjiList.Add(sData);
            slGongjiKey.Add(subjObj.Get('nkey').JsonValue.Value);
          end;
        end;
      finally
        arrjObj.Free;
      end;
    end else
    if sCmd = '503' then
    begin
			sData := sBody.Get('wtm' ).JsonValue.Value + Char(1) +    // 0.등록일시
							 sBody.Get('tit' ).JsonValue.Value + Char(1) +    // 1.공지제목
							 sBody.Get('cont').JsonValue.Value + Char(1) +    // 2.공지내용
							 sBody.Get('wnm' ).JsonValue.Value + Char(1) +    // 3.등록자명
							 sBody.Get('wid' ).JsonValue.Value + Char(1) +    // 4.등록자ID
							 sBody.Get('wtp' ).JsonValue.Value + Char(1) +    // 5.구분
							 sBody.Get('nkey').JsonValue.Value + Char(1) +    // 6.키값
							 sBody.Get('resv').JsonValue.Value + Char(2);     // 7.예약일시

      if Trim(sData) <> '' then
      begin
				sKey := sBody.Get('nkey').JsonValue.Value;
				if sBody.Get('wtp' ).JsonValue.Value = 'D' then
        begin
					idx := slGongjiKey.IndexOf(sBody.Get('nkey').JsonValue.Value);
					if idx >= 0 then 
					begin
						slGongjiKey.Delete(idx);
						slGongjiList.Delete(idx);
					end;
        end else
        if sBody.Get('wtp' ).JsonValue.Value = 'U' then
				begin
          idx := slGongjiKey.IndexOf(sBody.Get('nkey').JsonValue.Value);
					if idx >= 0 then slGongjiList.Strings[idx] := sData;
        end else
				if sBody.Get('wtp' ).JsonValue.Value = 'C' then
				begin
					slGongjiList.Add(sData);
          slGongjiKey.Add(sBody.Get('nkey').JsonValue.Value);
        end;
      end;
    end;

    try
      if ( not Assigned(Frm_JON23) ) Or ( Frm_JON23 = Nil ) then Frm_JON23 := TFrm_JON23.Create(nil);
			Frm_JON23.proc_AddList(slGongjiList);
    except on E: Exception do
      Assert(False, E.Message);
    end;
  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure pCP_602ChargeRequest(sData: String);
var
  sBody : TJSONObject;
  vQ_Rate : TQ_Rate;
begin
  SetDebugeWrite('Share.pCP_602ChargeRequest');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
    try
      vQ_Rate.cmd := '602';
      vQ_Rate.rkey      := sBody.Get('rkey'     ).JsonValue.Value;
      vQ_Rate.uid       := sBody.Get('uid'      ).JsonValue.Value;
      vQ_Rate.unm       := fJsonDecode(sBody.Get('unm'     ).JsonValue.Value);
      vQ_Rate.brno      := sBody.Get('brno'     ).JsonValue.Value;
      vQ_Rate.cuhp      := sBody.Get('cuhp'     ).JsonValue.Value;
      try
        vQ_Rate.brkeynum  := sBody.Get('brkeynum' ).JsonValue.Value;
      except
      end;
      vQ_Rate.corpnm    := sBody.Get('corpnm'   ).JsonValue.Value;
      vQ_Rate.corpdepnm := sBody.Get('corpdepnm').JsonValue.Value;
      vQ_Rate.sta       := fJsonDecode(sBody.Get('sta'     ).JsonValue.Value);
      vQ_Rate.staddr    := sBody.Get('staddr'  ).JsonValue.Value;
      vQ_Rate.via       := fJsonDecode(sBody.Get('via'     ).JsonValue.Value);
      vQ_Rate.eda       := fJsonDecode(sBody.Get('eda'     ).JsonValue.Value);
      vQ_Rate.edaddr    := sBody.Get('edaddr'  ).JsonValue.Value;
      vQ_Rate.distance  := sBody.Get('distance').JsonValue.Value;
      vQ_Rate.Viadist   := sBody.Get('viadist' ).JsonValue.Value;
      vQ_Rate.rate      := sBody.Get('rate'    ).JsonValue.Value;
      vQ_Rate.qtm       := sBody.Get('qtm'     ).JsonValue.Value;
      vQ_Rate.aid       := '';
      vQ_Rate.anm       := '';
      vQ_Rate.arate     := '0';
      vQ_Rate.amsg      := '';
      vQ_Rate.atm       := '';
      vQ_Rate.jtype     := sBody.Get('jtype'   ).JsonValue.Value;
      vQ_Rate.crkey     := sBody.Get('crkey'   ).JsonValue.Value;

      vQ_Rate.StaX := sBody.Get('stax' ).JsonValue.Value;
      vQ_Rate.StaY := sBody.Get('stay' ).JsonValue.Value;
			vQ_Rate.ViaX := sBody.Get('viax' ).JsonValue.Value;
      vQ_Rate.ViaY := sBody.Get('viay' ).JsonValue.Value;
      vQ_Rate.EndX := sBody.Get('endx' ).JsonValue.Value;
      vQ_Rate.EndY := sBody.Get('endy' ).JsonValue.Value;
    finally
      FreeAndNil(sBody);
    end;

    if GB_RQ_AUTOACTIVE then
    begin
      if ( Not Frm_Main.BtnFix.Down ) then
      begin
        Frm_Main.BtnFix.Down := True;
        Frm_Main.BtnFixClick(Frm_Main.BtnFix);
      end;

      Frm_Main.cxPageControl2.ActivePageIndex := 3;
    end;
    pSetGridQRate(vQ_Rate);
  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure pCP_604ChargeAnswer(sCmd, sData: String);
var
  sBody : TJSONObject;
  vQ_Rate : TQ_Rate;
begin
  SetDebugeWrite('Share.pCP_604ChargeAnswer');
  try
    sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
    try
      vQ_Rate.cmd := sCmd;
      vQ_Rate.rkey := sBody.Get('rkey' ).JsonValue.Value;
      vQ_Rate.uid  := sBody.Get('uid' ).JsonValue.Value;
      vQ_Rate.unm :=  '';
      vQ_Rate.sta :=  '';
      vQ_Rate.staddr := '';
      vQ_Rate.via := '';
      vQ_Rate.eda := '';
      vQ_Rate.edaddr := '';
      vQ_Rate.rate := '';
      vQ_Rate.qtm := '';
      vQ_Rate.aid := sBody.Get('aid').JsonValue.Value;
      vQ_Rate.anm := sBody.Get('anm').JsonValue.Value;
      vQ_Rate.arate := sBody.Get('rate').JsonValue.Value;
      vQ_Rate.amsg := sBody.Get('msg').JsonValue.Value;;
      vQ_Rate.atm := sBody.Get('atm').JsonValue.Value;;
    finally
      FreeAndNil(sBody);
    end;

//    cxPageControl2.ActivePageIndex := 3;
    pSetGridQRate(vQ_Rate);
  except on E: Exception do
    Assert(False, E.Message);
  end;
end;

procedure pSetGridQRate( vQ_Rate : TQ_Rate );
Var iRow, i, iIdx, irKey, iUse, hMsg, iCnt, icrKey : Integer;
    sType, vCRKey, sMsg : String;
    bFirst : Boolean;
begin
  try
    // 요금문의 후 서버에서 요금 전파로 온 자료를 가지고 요금 문의 등록
    if ( vQ_Rate.Cmd = '601' ) Or ( vQ_Rate.Cmd = '603' ) then Exit;
    bFirst := False;

    irkey := Frm_Main.cxGridQRate.GetColumnByFieldName('rkey').Index;
    icrKey := Frm_Main.cxGridQRate.GetColumnByFieldName('crkey').Index;
    if ( vQ_Rate.Cmd = '602' ) then
    begin
      if ( GT_USERIF.Family = 'y' ) And ( GT_USERIF.LV = '60' ) then     // 20120629 LYB
      begin
        if scb_FamilyBrCode.IndexOf(vQ_Rate.brno) < 0 then Exit;
      end else
      begin
        if scb_BranchCode.IndexOf(vQ_Rate.brno) < 0 then Exit;
      end;

      iRow := Frm_Main.cxGridQRate.DataController.FindRecordIndexByText(0, iRkey, vQ_Rate.rkey, False, True, True);
      if iRow < 0 then
        iRow := Frm_Main.cxGridQRate.DataController.AppendRecord;
      sType := '요금문의';
    end else
    if ( vQ_Rate.Cmd = '604' ) then
    begin
      iRow := Frm_Main.cxGridQRate.DataController.FindRecordIndexByText(0, iRkey, vQ_Rate.rKey, False, True, True);
      if iRow < 0 then Exit;
      vCRKey := Frm_Main.cxGridQRate.DataController.Values[iRow, icrKey];
      sType := '답변완료';
    end else
    if ( vQ_Rate.Cmd = '605' ) then
    begin
      iRow := Frm_Main.cxGridQRate.DataController.FindRecordIndexByText(0, iRkey, vQ_Rate.rKey, False, True, True);
      if iRow < 0 then Exit;
      vCRKey := Frm_Main.cxGridQRate.DataController.Values[iRow, icrKey];
      sType := '자동답변';
    end;

    if iRow < 0 then Exit;

    Frm_Main.cxGridQRate.BeginUpdate;
    try
      if ( vQ_Rate.Cmd = '602' ) then
      begin
        Frm_Main.cxGridQRate.DataController.Values[iRow, 00] := vQ_Rate.qtm;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 02] := vQ_Rate.unm;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 03] := sType;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 04] := vQ_Rate.brno;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 05] := StrToCall(vQ_Rate.cuhp);                                   // 전화번호
        Frm_Main.cxGridQRate.DataController.Values[iRow, 06] := '';
        Frm_Main.cxGridQRate.DataController.Values[iRow, 07] := vQ_Rate.brkeynum;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 08] := vQ_Rate.corpnm;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 09] := vQ_Rate.corpdepnm;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 10] := vQ_Rate.sta;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 11] := StringReplace(vQ_Rate.staddr, ',', ' ', [rfReplaceAll]);
        Frm_Main.cxGridQRate.DataController.Values[iRow, 12] := vQ_Rate.via;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 13] := vQ_Rate.eda;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 14] := StringReplace(vQ_Rate.edaddr, ',', ' ', [rfReplaceAll]);
        Frm_Main.cxGridQRate.DataController.Values[iRow, 15] := vQ_Rate.distance;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 16] := vQ_Rate.ViaDist;    // 경유거리
        Frm_Main.cxGridQRate.DataController.Values[iRow, 17] := StrToInt(vQ_Rate.rate);
        Frm_Main.cxGridQRate.DataController.Values[iRow, 18] := 0;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 19] := '';
        Frm_Main.cxGridQRate.DataController.Values[iRow, 20] := '';
        Frm_Main.cxGridQRate.DataController.Values[iRow, 21] := '';
        Frm_Main.cxGridQRate.DataController.Values[iRow, 22] := vQ_Rate.rkey;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 23] := vQ_Rate.uid;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 24] := vQ_Rate.crkey;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 25] := '';
        Frm_Main.cxGridQRate.DataController.Values[iRow, 26] := vQ_Rate.jtype;

        Frm_Main.cxGridQRate.DataController.Values[iRow, 27] := vQ_Rate.StaX;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 28] := vQ_Rate.StaY;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 29] := vQ_Rate.ViaX;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 30] := vQ_Rate.ViaY;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 31] := vQ_Rate.EndX;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 32] := vQ_Rate.EndY;
      end else
      begin
        if Trim(Frm_Main.cxGridQRate.DataController.Values[iRow, 19]) = '' then bFirst := True;

        if ( vQ_Rate.Cmd = '605' ) then
          Frm_Main.cxGridQRate.DataController.Values[iRow, 1] := '즉시';
        Frm_Main.cxGridQRate.DataController.Values[iRow, 3] := sType;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 21] := vQ_Rate.atm;
        if ( vQ_Rate.Cmd = '605' ) then
          Frm_Main.cxGridQRate.DataController.Values[iRow, 20] := 'SYSTEM'
        else
          Frm_Main.cxGridQRate.DataController.Values[iRow, 20] := vQ_Rate.anm;
        Frm_Main.cxGridQRate.DataController.Values[iRow, 18] := StrToIntDef(vQ_Rate.arate, 0);
        Frm_Main.cxGridQRate.DataController.Values[iRow, 19] := vQ_Rate.amsg;
      end;
    finally
      Frm_Main.cxGridQRate.EndUpdate;

      if Frm_Main.cxGridQRate.DataController.RecordCount > 0 then
        Frm_Main.tsBtmMenu4.Caption := Format('요금문의(%s)',[FormatFloat('#,##0', Frm_Main.cxGridQRate.DataController.RecordCount)])
      else
        Frm_Main.tsBtmMenu4.Caption := '요금문의';
    end;

    Frm_Main.cxGridQRate.Columns[0].SortIndex := 0;
    Frm_Main.cxGridQRate.Columns[0].SortOrder := soDescending;

    if ( vQ_Rate.Cmd = '602' ) then
    begin
      if vQ_Rate.uid <> GT_USERIF.ID then
      begin
        if Trim(vQ_Rate.via) = '' then
        begin
          sMsg := '출발지: ' + vQ_Rate.sta + CRLF +
                  '도착지: ' + vQ_Rate.eda + CRLF +
                  '거리: ' + vQ_Rate.distance + '      요금: ' + FormatFloat('#,', StrToFloat(vQ_Rate.rate)) + '원';
        end else
        begin
          sMsg := '출발지: ' + vQ_Rate.sta + CRLF +
                  '경유지: ' + vQ_Rate.via + CRLF +
                  '도착지: ' + vQ_Rate.eda + CRLF +
                  '거리: ' + vQ_Rate.distance + '-' + vQ_Rate.ViaDist + '      요금: ' + FormatFloat('#,', StrToFloat(vQ_Rate.rate)) + '원';
        end;


//        if GB_RQ_CLOSEPOPUP then
//        begin
//          if ( Frm_Main.BtnFix.Down ) And ( Frm_Main.cxPageControl2.ActivePageIndex = 3 ) then
//          begin
//            bPopUp := False;
//          end else
//          begin
//            bPopUp := True;
//          end;
//        end else
//        begin
//          bPopUp := True;
//        end;

        if GB_RQ_CLOSEPOPUP then
        begin
          if ( GT_USERIF.LV = '10' ) And ( TCK_USER_PER.BTM_10LVL_RQUEST <> '1' ) then Exit;

          fAlertWindow := Frm_Main.awmAlert.Show('요금문의[' + vQ_Rate.unm + ']', sMsg, 60);
          fAlertWindow.Hint := vQ_Rate.rkey;

          irKey := Frm_Main.cxGridQRate.GetColumnByFieldName('rkey').Index;
          iRow := Frm_Main.cxGridQRate.DataController.FindRecordIndexByText(0, irKey, vQ_Rate.rkey, False, True, True);

          if ( iRow >= 0 ) then
          begin
            iCnt := 0;
            for i := 0 to 30 do
            begin
              if ( Assigned(Frm_Main.Frm_COM50[i]) ) And ( Frm_Main.COM50MNG[i].CreateYN )  then
              begin
                Inc(iCnt);
              end;
            end;

            if iCnt = 0 then
            begin
              Frm_Main.iCom50Top := Screen.Height - ( Screen.Height - 100 );
              Frm_Main.iCom50Left := 5;
            end;

            if iCnt > 30 then
            begin
              hMsg := FindWindow('TMessageForm', 'CMNAGTXE');
              if hMsg <> 0 then
                SendMessage(hMsg, WM_CLOSE, 0, 0);

              GMessagebox('요금문의 팝업창 최대 생성수를 초과하였습니다. 요금문의 팝업창을 닫고 사용하세요~ @_@', CDMSE);
              Exit;
            end;

            iUse := -1;
            for i := 0 to 30 do
            begin
              if ( Assigned(Frm_Main.Frm_COM50[i]) ) And ( Frm_Main.COM50MNG[i].CreateYN )  then
              begin
                if vQ_Rate.rkey = Frm_Main.Frm_COM50[i].lblRQStart.Hint then
                begin
                  iUse := i;
                  Break;
                end;
              end;
            end;

            if iUse < 0 then
            begin
              for i := 0 to 30 do
              begin
                if ( Not Assigned(Frm_Main.Frm_COM50[i]) ) Or ( Frm_Main.COM50MNG[i].CreateYN = False )  then
                begin
                  Frm_Main.Frm_COM50[i] := TFrm_COM50.Create(Nil);
                  Frm_Main.Frm_COM50[i].Tag := i;
                  Frm_Main.COM50MNG[i].CreateYN := True;

                  Frm_Main.Frm_COM50[i].Top  := Frm_Main.iCom50Top;
                  Frm_Main.Frm_COM50[i].Left := Frm_Main.iCom50Left;

                  iUse := i;
                  Break;
                end;
              end;
            end;

            Frm_Main.iCom50Top := Frm_Main.iCom50Top + 20;
            Frm_Main.iCom50Left := Frm_Main.iCom50Left + 20;

            if Screen.Height - (Frm_Main.iCom50Top  + 130) < Frm_Main.Frm_COM50[iUse].Height  then
            begin
              Frm_Main.Frm_COM50[iUse].Left := 5;
              Frm_Main.Frm_COM50[iUse].Top := Screen.Height - ( Screen.Height - 100 );
            end;

            Frm_Main.Frm_COM50[iUse].pnlTitle.Caption := Format('  요금 문의 답변 (%d)', [iUse]);

            Frm_Main.Frm_COM50[iUse].lblRQNm.Caption := vQ_Rate.unm + '(' + vQ_Rate.uid + ')';
            Frm_Main.Frm_COM50[iUse].lblQTime.Caption := FormatDateTime('HH:NN:SS', StrToDatetime(vQ_Rate.qtm));
            Frm_Main.Frm_COM50[iUse].lblRQbrKeynum.Caption := vQ_Rate.brkeynum;
            Frm_Main.Frm_COM50[iUse].lblRQCorpNm.Caption := vQ_Rate.CorpNm;
            Frm_Main.Frm_COM50[iUse].lblRQCorpDepNm.Caption := vQ_Rate.CorpDepNm;

            Frm_Main.Frm_COM50[iUse].lblRQStart.Hint := vQ_Rate.rkey;
            Frm_Main.Frm_COM50[iUse].lblRQVia.Hint := vQ_Rate.uid;
            Frm_Main.Frm_COM50[iUse].lblRQEnd.Hint := vQ_Rate.crkey;
            Frm_Main.Frm_COM50[iUse].lblRQStart.Caption := vQ_Rate.sta;
            Frm_Main.Frm_COM50[iUse].lblRQStartAddr.Caption := StringReplace(vQ_Rate.staddr, ',', ' ', [rfReplaceAll]);
            Frm_Main.Frm_COM50[iUse].lblRQVia.Caption := vQ_Rate.via;
            if Trim(Frm_Main.Frm_COM50[iUse].lblRQVia.Caption) = '' then
            begin
              Frm_Main.Frm_COM50[iUse].pnlVia.Visible := False;
              Frm_Main.Frm_COM50[iUse].pnlRQBtm.Top := 142;
              Frm_Main.Frm_COM50[iUse].Height := 315;
            end else
            begin
              Frm_Main.Frm_COM50[iUse].pnlVia.Visible := True;
              Frm_Main.Frm_COM50[iUse].pnlRQBtm.Top := 168;
              Frm_Main.Frm_COM50[iUse].Height := 340;
            end;
            Frm_Main.Frm_COM50[iUse].lblRQEnd.Caption := vQ_Rate.eda;
            Frm_Main.Frm_COM50[iUse].lblRQEndAddr.Caption := StringReplace(vQ_Rate.edaddr, ',', ' ', [rfReplaceAll]);
            Frm_Main.Frm_COM50[iUse].lblDistance.Caption := vQ_Rate.distance;
            Frm_Main.Frm_COM50[iUse].lblVDistance.Caption := vQ_Rate.ViaDist;
            Frm_Main.Frm_COM50[iUse].lblRQRate.Caption := FormatFloat('#,', StrToFloat(vQ_Rate.rate));

            Frm_Main.Frm_COM50[iUse].curPRate.Value := StrToIntDef(vQ_Rate.rate, 0);
            fSetFont(Frm_Main.Frm_COM50[iUse], GS_FONTNAME);
            Frm_Main.Frm_COM50[iUse].Show;
          end;
        end;
      end;
    end;

    try
      if ( vQ_Rate.Cmd = '604' ) Or ( vQ_Rate.Cmd = '605' ) then
      begin
        // 답변 팝업창 자동 종료 - 요금문의에 대한 응답이 완료 됐을 경우 2021.07.01. 엔젤플러스 요청
        if ( vQ_Rate.Cmd = '604' ) then
        begin
          for i := 0 to 30 do
          begin
            if ( Assigned(Frm_Main.Frm_COM50[i]) ) And ( Frm_Main.COM50MNG[i].CreateYN )  then
            begin
              if vCRKey = Frm_Main.Frm_COM50[i].lblRQEnd.Hint then
              begin
                Frm_Main.Frm_COM50[i].pnlRQPopup.Enabled := False;
                Frm_Main.Frm_COM50[i].cxLabel8.Caption := '요금문의 요청한 상담원의 요금답변이 완료되었으므로' + CRLF + CRLF +
                                                          '요금문의 답변 창 자동 종료합니다.';
                Frm_Main.Frm_COM50[i].pnlAutoClose.Left := (Frm_Main.Frm_COM50[i].pnlRQPopup.Width  - Frm_Main.Frm_COM50[i].pnlAutoClose.Width) div 2;
                Frm_Main.Frm_COM50[i].pnlAutoClose.Top  := (Frm_Main.Frm_COM50[i].pnlRQPopup.Height - Frm_Main.Frm_COM50[i].pnlAutoClose.Height) div 2;
                Frm_Main.Frm_COM50[i].pnlAutoClose.Visible := True;
                Frm_Main.Frm_COM50[i].Timer1.Enabled := True;
              end;
            end;
          end;
        end;

        for i := 0 to JON_MAX_CNT - 1 do
        begin
          if Frm_Main.JON01MNG[i].rKey = vCRKey then
          begin
            Frm_Main.Frm_JON01N[i].Lbl_Charge.Caption := '';
            Frm_Main.Frm_JON01N[i].pnl_Charge.Visible := False;
            if ( GB_RQ_APPLYRATE ) then // 자동답변 : - 서버 자동답변 요금 자동적용
            begin
              if vQ_Rate.Cmd = '605' then
              begin
                Frm_Main.Frm_JON01N[i].curRate.Value := StrToInt(vQ_Rate.arate);
                Frm_Main.Frm_JON01N[i].Lbl_Charge.Caption := Format('System(자동답변)님의 답변요금 자동적용, 설명: %s', [vQ_Rate.amsg]);
                Frm_Main.Frm_JON01N[i].Lbl_Distance.Caption := '';
                Frm_Main.Frm_JON01N[i].pnl_Charge.height := 21;
                Frm_Main.Frm_JON01N[i].pnl_Charge.Visible := True;
                if Frm_Main.Frm_JON01N[i].curRate.CanFocus then Frm_Main.Frm_JON01N[i].curRate.SetFocus;
              end;
            end;

            try
              iRow := Frm_Main.Frm_JON01N[i].RQAListView.DataController.AppendRecord;

              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 00] := iRow+1;
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 01] := StrToIntDef(vQ_Rate.arate, 0);
              if vQ_Rate.Cmd = '605' then
              begin
                Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 02] := 'System(자동답변)';
              end else
              begin
                Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 02] := Format('%s(%s)', [vQ_Rate.anm, vQ_Rate.aid]);
              end;

              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 03] := vQ_Rate.amsg;
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 04] := FormatDateTime('HH:NN:SS', StrToDateTime(vQ_Rate.atm));
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 06] := vQ_Rate.rkey;

              irKey := Frm_Main.cxGridQRate.GetColumnByFieldName('rkey').Index;
              iIdx := Frm_Main.cxGridQRate.DataController.FindRecordIndexByText(0, irKey, vQ_Rate.rkey, False, True, True);

              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 07] := Frm_Main.cxGridQRate.DataController.GetValue(iIdx, 22);   // uid
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 08] := Frm_Main.cxGridQRate.DataController.GetValue(iIdx, 02);   // unm
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 09] := Frm_Main.cxGridQRate.DataController.GetValue(iIdx, 09);   // sta
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 10] := Frm_Main.cxGridQRate.DataController.GetValue(iIdx, 10);   // staddr
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 11] := Frm_Main.cxGridQRate.DataController.GetValue(iIdx, 11);   // via
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 12] := Frm_Main.cxGridQRate.DataController.GetValue(iIdx, 12);   // eda
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 13] := Frm_Main.cxGridQRate.DataController.GetValue(iIdx, 13);   // edaddr
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 14] := Frm_Main.cxGridQRate.DataController.GetValue(iIdx, 00);   // qtm
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 15] := vQ_Rate.aid;
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 16] := vQ_Rate.anm;
              Frm_Main.Frm_JON01N[i].RQAListView.DataController.Values[iRow, 17] := vQ_Rate.atm;
            finally
//                Frm_JON01N[i].RQAListView.Columns[1].SortIndex := 0;
//                Frm_JON01N[i].RQAListView.Columns[1].SortOrder := soDescending;
            end;
            Frm_Main.Frm_JON01N[i].gbRQAList.BringToFront;
            Frm_Main.Frm_JON01N[i].gbRQAList.Visible := True;
            Break;
          end;
        end;
      end;
      Application.ProcessMessages;
    except
    end;
  except
  end;
end;

function fFindQRForm(sHint: string): Integer;
var
   i: Integer;
begin
  Result := -1;
  for i := 0 to 30 do
  begin
    if Assigned(Frm_Main.Frm_COM50[i]) then
    begin
      if sHint = Frm_Main.Frm_COM50[i].lblRQStart.Hint then
      begin
        Result := i;
        Break;
      end;
    end;
  end;
end;

function fJsonEncode( sTxt : String ) : String;
begin
  Result := StringReplace(sTxt, '"', cQUOTATION_MARK, [rfReplaceAll]);
end;

function fJsonDecode( sTxt : String ) : String;
begin
	Result := StringReplace(sTxt, cQUOTATION_MARK, '"', [rfReplaceAll]);
end;

procedure pGetMakeHead( Var jsoHd : TJSONObject; sId : String );
Var subObj : TJSONObject;
begin
	try
		subObj := TJSONObject.Create;
		subObj.AddPair( TJSONPair.Create('seq', IntToStr(GI_SEQ)));
		subObj.AddPair( TJSONPair.Create('cmd', sId));
		jsoHd.AddPair( TJSONPair.Create('hdr', subObj));
	except
		ShowMessage('헤더 생성 오류');
	end;
end;

procedure p1501SetChat(FrmTag : Integer; sCd, sKey, sId, sNm, sMsg, sFCmd, sFnm, sflId, sflNm : String; bFirst : Boolean);
Var jsoRlt, subObj, aryObj : TJSONObject;
    jso : TJSONObject;
    jsoAry : TJSONArray;
    jsoPar : TJSONPair;
    sToCd, Str, Str2, StrRlt, StrRlt1, StrRlt2, sFont : String;
    i, j : Integer;
		slId, slNm : TStringList;
    iError, iSeq : Integer;
begin
	SetDebugeWrite('p1501SetChat - sMsg : ' + sMsg);

	// Make Json -----------------------------------------------------------------
  try
    jsoRlt := TJSONObject.Create;
		try
			Inc(GI_SEQ);
		except
			GI_SEQ := 1;
		end;
		pGetMakeHead(jsoRlt, sCd);   //1501

		subObj := TJSONObject.Create;
		subObj.AddPair( TJSONPair.Create('ckey', sKey));

//		gsKey := sKey; //GT_USERIF.ID + '_' + FormatDateTime('ddhhmmss', Now);

    slId := TStringList.Create;
    slNm := TStringList.Create;
		GetTextSeperationEx2(AnsiChar(1), sId, slId);  //'sntest'#1'rlagustn'
		GetTextSeperationEx2(AnsiChar(1), sNm, slNm);  //'콜마너1'#1'김현수'
		jsoAry := TJSONArray.Create;
    for i := 0 to slId.Count - 1 do
    begin
      jso := TJSONObject.Create;
      jso.AddPair(TJsonPair.Create('cid', slId.Strings[i]));
      jso.AddPair(TJsonPair.Create('cnm', slNm.Strings[i]));
      jsoAry.AddElement(jso);
    end;
    subObj.AddPair( TJSONPair.Create('ls', jsoAry));

    sFont := GS_EnvFile.ReadString('CM_FONT', 'FontName', '굴림') + '│' +
             IntToStr(GS_EnvFile.ReadInteger('CM_FONT', 'FontSize', 9 )) + '│' +
             GS_EnvFile.ReadString('CM_FONT', 'FontColor', ColorToString(clBlack)) + '│' +
             GS_EnvFile.ReadString('CM_FONT', 'FontStyle', '');

		subObj.AddPair( TJSONPair.Create('font', sFont));   //'굴림│9│clBlack│'
		subObj.AddPair( TJSONPair.Create('msg', sMsg));     //#$A'콜마너1<sntest>|ㅁㅁㅁ'
		subObj.AddPair( TJSONPair.Create('snum', ''{CC_SNum[FrmTag]})); // CC_SNum 채팅창서버번호 / CN_SNum 쪽지창 서버번호

    jsoRlt.AddPair( TJSONPair.Create('bdy', subObj));
		//'{"hdr":{"seq":"%s","cmd":"201"},
		//         "bdy":{"ckey":"sntest_13155053",
		//                  "ls":[{"cid":"sntest","cnm":"콜마너1"},
		//                        {"cid":"rlagustn","cnm":"김현수"}],
		//                 "font":"굴림│9│clBlack│",
		//                  "msg":"\n콜마너1<sntest>|ㅁㅁㅁ",
		//                 "snum":""}}'
		Str := jsoRlt.ToString;  

		Dm.pSendCMessenger(True, Str);
	finally
		FreeAndNil(jsoRlt);
    FreeAndNil(slId);
    FreeAndNil(slNm);
  end;

end;

procedure pCP_711Result(sData: String);
var
	sBody : TJSONObject;
	sSlip, sAccTime : String;
	iCheck : Boolean;
	i : integer;
begin
	SetDebugeWrite('Share.pCP_801GetBrCash');

	sBody := TJSONObject.ParseJSONValue(sData) as TJSONObject;
	try
		sSlip := sBody.Get('slip').JsonValue.Value;
		sAccTime := sBody.Get('acct').JsonValue.Value;
	finally
		FreeAndNil(sBody);
	end;

	try
		iCheck := False;
		for I := 0 to JON03_MAX_CNT - 1 do
		begin
			if Frm_Main.JON03MNG[i].Use then
			begin
				 iCheck := True;
			end;
		end;

		if Not iCheck then Frm_Main.procMainMenuCreateActive(200);

		Frm_Main.AcceptFromCreate(sSlip, sAccTime, '조회', GI_JON03_LastFromIdx);
	except
	end;
end;

end.
