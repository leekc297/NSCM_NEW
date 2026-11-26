# AS-IS 실측 요약 — SSP0014

- 실행: 2026-11-25 01:54:18.177 ~ 2026-11-25 01:59:53.471 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Model PIC (GSCM.SSP.Plan.UIL.SSP0014_ShipmentModelPIC)
- 조회 결과: Total : 7,667 · DB : 149.781s, UI : 1.237s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 01:56:53.941 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.96 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0014 |
| 01:56:53.968 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.32 | USER_ID= |
| 01:56:57.480 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 2196.48 | LOGTYPE=SpeedUp, NOTE=SSP0014
division_id_changed
start
, USER_ID=jaeuk.shin |
| 01:56:57.681 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 196.63 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 01:57:04.593 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 6857.11 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 01:57:04.865 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 60.49 | LOGTYPE=SpeedUp, NOTE=SSP0014
division_id_changed
end
, USER_ID=jaeuk.shin |
| 01:57:04.954 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 87.59 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 01:57:05.014 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 4.26 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 01:57:05.106 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 65.73 | p_program_id=SSP0014, p_user_id=jaeuk.shin, p_sheet_name=Shipment Model PIC |
| 01:57:05.118 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.29 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:57:05.128 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.75 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:57:05.673 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 425.94 | MenuID=Shipment Model PIC, CnntCode=0104001, UserID=jaeuk.shin |
| 01:57:05.832 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0014 |
| 01:57:13.414 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 4.0 | p_program_id=SSP0014, p_user_id=jaeuk.shin, p_sheet_name=Shipment Model PIC |
| 01:57:13.424 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.09 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:57:13.433 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.0 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:59:43.002 | find | GSCM.SSP.Plan.WSL | SSP0014_GET_SHIPMENT_MODEL_PIC | 7667 | 148448.48 | p_division_id=40, p_operation_group=, p_from_site=, p_valid_yn=, p_item_id=, p_user_id=, p_language=KO |
| 01:59:44.733 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 263.29 | p_menu_id=SSP0014, p_log_type=FIND, p_log_cnt=7667, p_db_time=149.781, p_ui_time=1.237, p_user_id=jaeuk.shin |

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
