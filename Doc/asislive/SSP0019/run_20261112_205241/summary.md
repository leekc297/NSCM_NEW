# AS-IS 실측 요약 — SSP0019

- 실행: 2026-11-12 20:52:41.375 ~ 2026-11-12 20:53:01.407 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Change History (GSCM.SSP.Plan.UIL.SSP0019_ShipmentChangeHistory)
- 조회 결과: Total :  · DB : 2.004s, UI : 0.004s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:52:41.732 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.36 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0019 |
| 20:52:41.754 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.51 | USER_ID= |
| 20:52:41.890 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.53 | LOGTYPE=SpeedUp, NOTE=SSP0019
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:52:41.894 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.68 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:52:41.905 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.47 | LOGTYPE=SpeedUp, NOTE=SSP0019
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:52:41.909 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.62 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:52:41.925 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 99 | 6.6 | Code=ShipmentPlanPlantSite, Param1=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:52:42.129 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2620 | 200.69 | Code=ShipmentPlanToSite, Param1=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:52:43.011 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 16 | 863.91 | Code=ssp0019_Incoterms, Param1=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:52:43.607 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 5 | 591.94 | Code=ssp0019_TransportMode, Param1=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:52:43.871 | load | GSCM.SCP.Master.WSL | SELECT | 1 | 3.16 |  |
| 20:52:43.883 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 47 | 4.89 | p_program_id=SSP0019, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change History |
| 20:52:43.897 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.37 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:52:43.910 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 5.59 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:52:43.919 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.74 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:52:43.994 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 56.21 | MenuID=Shipment Change History, CnntCode=0104001, UserID=jaeuk.shin |
| 20:52:44.055 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.46 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0019 |
| 20:52:53.109 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 47 | 4.47 | p_program_id=SSP0019, p_user_id=jaeuk.shin, p_sheet_name=Shipment Change History |
| 20:52:53.118 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.35 | Code=Division, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:52:53.129 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 3.22 | Code=CHANGE_REASON_CODE_ALL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:52:53.140 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.96 | Code=LookupCommon, Param1=SALES_TYPE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:52:55.148 | find | GSCM.SSP.Plan.WSL | SSP0019_GET_SHIPMENT_CHANGE_HISTORY | 0 | 1998.3 | p_division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE_HD,EE_HG,EE_HM,EE_UC, p_from_site=, p_to_site=, p_incoterms=, p_from_yyyymmdd=20261112, p_to_yyyymmdd=20261212, p_item_id=, p_sono=, p_trans_mode=, p_confirm_id=, p_language=KO, debug_mode=F |
| 20:52:55.185 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 26.32 | p_menu_id=SSP0019, p_log_type=FIND, p_log_cnt=, p_db_time=2.004, p_ui_time=0.004, p_user_id=jaeuk.shin |
| 20:53:00.692 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.22 | MenuID=Shipment Change History, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| From Site | clbFromSite |  |
| Shipment Date | drpPeriod |  |
| layoutControlItem2 | btnItemId |  |
| SO No | txtSoNo |  |
| To Site | clbToSite |  |
| Incoterms | clbIncomterms |  |
| Model | txtItemId |  |
| layoutControlItem1 | chkCurrent |  |
| Div | clbDivision |  |
| TransportMode | clbTransportMode |  |
| Confirm ID | txtConfirmId |  |

## 그리드

- spdMain / Shipment Change History: 행 0 · 컬럼 48(보임 46) · 헤더 1단 · 고정 컬럼 8

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
