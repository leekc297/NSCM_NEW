# AS-IS 실측 요약 — SSP0014

- 실행: 2026-11-20 07:00:59.261 ~ 2026-11-20 07:01:31.759 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Model PIC (GSCM.SSP.Plan.UIL.SSP0014_ShipmentModelPIC)
- 조회 결과: Total : 7,667 · DB : 0.505s, UI : 1.134s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 07:01:15.572 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.49 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0014 |
| 07:01:15.612 | load | GSCM.BizService.WSL | SELECT * | 874 | 24.67 | USER_ID= |
| 07:01:15.883 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 76.24 | LOGTYPE=SpeedUp, NOTE=SSP0014
division_id_changed
start
, USER_ID=jaeuk.shin |
| 07:01:15.934 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 48.85 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 07:01:16.403 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 443.01 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 07:01:16.700 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 5.3 | LOGTYPE=SpeedUp, NOTE=SSP0014
division_id_changed
end
, USER_ID=jaeuk.shin |
| 07:01:16.705 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.76 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 07:01:16.788 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 4.3 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 07:01:16.849 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 5.52 | p_program_id=SSP0014, p_user_id=jaeuk.shin, p_sheet_name=Shipment Model PIC |
| 07:01:16.867 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.08 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:01:16.879 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.75 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:01:17.050 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 56.31 | MenuID=Shipment Model PIC, CnntCode=0104001, UserID=jaeuk.shin |
| 07:01:17.133 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.39 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0014 |
| 07:01:24.655 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 5.51 | p_program_id=SSP0014, p_user_id=jaeuk.shin, p_sheet_name=Shipment Model PIC |
| 07:01:24.669 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 5.06 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:01:24.680 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 5.08 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 07:01:24.957 | find | GSCM.SSP.Plan.WSL | SSP0014_GET_SHIPMENT_MODEL_PIC | 7667 | 180.31 | p_division_id=40, p_operation_group=, p_from_site=, p_valid_yn=, p_item_id=, p_user_id=, p_language=KO |
| 07:01:26.352 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.61 | p_menu_id=SSP0014, p_log_type=FIND, p_log_cnt=7667, p_db_time=0.505, p_ui_time=1.134, p_user_id=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Operation Group | cboOperationGroup |  |
| From Site | clbFromSite |  |
| Valid | cboValidYN |  |
| User ID(Name) | txtUser |  |
| layoutControlItem4 | btnItemId |  |
| Model | txtItemId |  |

## 그리드

- spdMain / Shipment Model PIC: 행 7667 · 컬럼 23(보임 21) · 헤더 1단 · 고정 컬럼 1
