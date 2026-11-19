# AS-IS 실측 요약 — SSP0014

- 실행: 2026-11-19 16:07:33.912 ~ 2026-11-19 16:08:16.347 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Model PIC (GSCM.SSP.Plan.UIL.SSP0014_ShipmentModelPIC)
- 조회 결과: Total : 7,667 · DB : 1.168s, UI : 1.241s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 16:07:55.084 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 32.49 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0014 |
| 16:07:55.126 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.4 | USER_ID= |
| 16:07:56.470 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 144.15 | LOGTYPE=SpeedUp, NOTE=SSP0014
division_id_changed
start
, USER_ID=jaeuk.shin |
| 16:07:56.555 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 76.8 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 16:07:58.022 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 1388.97 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 16:07:58.397 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 26.13 | LOGTYPE=SpeedUp, NOTE=SSP0014
division_id_changed
end
, USER_ID=jaeuk.shin |
| 16:07:58.401 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.85 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 16:07:58.561 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 4.85 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:07:59.498 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 52.0 | p_program_id=SSP0014, p_user_id=jaeuk.shin, p_sheet_name=Shipment Model PIC |
| 16:07:59.538 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.94 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:07:59.551 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.87 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:07:59.895 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 138.34 | MenuID=Shipment Model PIC, CnntCode=0104001, UserID=jaeuk.shin |
| 16:08:00.061 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 69.53 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0014 |
| 16:08:08.389 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 6.74 | p_program_id=SSP0014, p_user_id=jaeuk.shin, p_sheet_name=Shipment Model PIC |
| 16:08:08.400 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.32 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:08:08.410 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.83 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:08:09.423 | find | GSCM.SSP.Plan.WSL | SSP0014_GET_SHIPMENT_MODEL_PIC | 7667 | 183.59 | p_division_id=40, p_operation_group=, p_from_site=, p_valid_yn=, p_item_id=, p_user_id=, p_language=KO |
| 16:08:10.845 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.33 | p_menu_id=SSP0014, p_log_type=FIND, p_log_cnt=7667, p_db_time=1.168, p_ui_time=1.241, p_user_id=jaeuk.shin |

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
