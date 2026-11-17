# AS-IS 실측 요약 — SSP0014

- 실행: 2026-11-13 05:45:01.090 ~ 2026-11-13 05:45:20.592 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Model PIC (GSCM.SSP.Plan.UIL.SSP0014_ShipmentModelPIC)
- 조회 결과: Total : 7,667 · DB : 2.085s, UI : 1.041s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:45:01.386 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.96 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0014 |
| 05:45:01.409 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.98 | USER_ID= |
| 05:45:01.482 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.05 | LOGTYPE=SpeedUp, NOTE=SSP0014
division_id_changed
start
, USER_ID=jaeuk.shin |
| 05:45:01.547 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 64.44 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:45:01.993 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 433.03 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 05:45:02.208 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 36.36 | LOGTYPE=SpeedUp, NOTE=SSP0014
division_id_changed
end
, USER_ID=jaeuk.shin |
| 05:45:02.213 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.08 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 05:45:02.264 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 5.53 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:45:02.286 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 4.74 | p_program_id=SSP0014, p_user_id=jaeuk.shin, p_sheet_name=Shipment Model PIC |
| 05:45:02.296 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.1 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:02.303 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.09 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:02.423 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 98.35 | MenuID=Shipment Model PIC, CnntCode=0104001, UserID=jaeuk.shin |
| 05:45:02.461 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0014 |
| 05:45:10.941 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 21 | 4.12 | p_program_id=SSP0014, p_user_id=jaeuk.shin, p_sheet_name=Shipment Model PIC |
| 05:45:10.949 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.4 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:10.957 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.53 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:45:12.972 | find | GSCM.SSP.Plan.WSL | SSP0014_GET_SHIPMENT_MODEL_PIC | 7667 | 1998.16 | p_division_id=40, p_operation_group=, p_from_site=, p_valid_yn=, p_item_id=, p_user_id=, p_language=KO |
| 05:45:14.104 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.81 | p_menu_id=SSP0014, p_log_type=FIND, p_log_cnt=7667, p_db_time=2.085, p_ui_time=1.041, p_user_id=jaeuk.shin |
| 05:45:19.807 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 20.54 | MenuID=Shipment Model PIC, CnntCode=0104002, UserID=jaeuk.shin |

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
