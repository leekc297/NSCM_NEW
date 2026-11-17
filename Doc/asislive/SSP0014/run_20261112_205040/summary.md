# AS-IS 실측 요약 — SSP0014

- 실행: 2026-11-12 20:50:40.302 ~ 2026-11-12 20:50:59.993 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Model PIC (GSCM.SSP.Plan.UIL.SSP0014_ShipmentModelPIC)
- 조회 결과: Total : 7,667 · DB : 2.548s, UI : 1.071s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:50:40.578 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0014 |
| 20:50:40.600 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.4 | USER_ID= |
| 20:50:40.698 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 26.17 | LOGTYPE=SpeedUp, NOTE=SSP0014
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:50:40.756 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 58.42 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:50:41.677 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 900.52 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 20:50:41.813 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.61 | LOGTYPE=SpeedUp, NOTE=SSP0014
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:50:41.819 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.73 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:50:41.861 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 4.62 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:50:41.904 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 28.08 | p_program_id=SSP0014, p_user_id=jaeuk.shin, p_sheet_name=Shipment Model PIC |
| 20:50:41.915 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.21 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:41.923 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.84 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:42.048 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 87.61 | MenuID=Shipment Model PIC, CnntCode=0104001, UserID=jaeuk.shin |
| 20:50:42.083 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.59 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0014 |
| 20:50:50.149 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 15.03 | p_program_id=SSP0014, p_user_id=jaeuk.shin, p_sheet_name=Shipment Model PIC |
| 20:50:50.157 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.4 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:50.164 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.74 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:50:52.652 | find | GSCM.SSP.Plan.WSL | SSP0014_GET_SHIPMENT_MODEL_PIC | 7667 | 2469.68 | p_division_id=40, p_operation_group=, p_from_site=, p_valid_yn=, p_item_id=, p_user_id=, p_language=KO |
| 20:50:53.805 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.3 | p_menu_id=SSP0014, p_log_type=FIND, p_log_cnt=7667, p_db_time=2.548, p_ui_time=1.071, p_user_id=jaeuk.shin |
| 20:50:59.276 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 4.95 | MenuID=Shipment Model PIC, CnntCode=0104002, UserID=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
