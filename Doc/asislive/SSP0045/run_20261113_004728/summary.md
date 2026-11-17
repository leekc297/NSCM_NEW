# AS-IS 실측 요약 — SSP0045

- 실행: 2026-11-13 00:47:28.427 ~ 2026-11-13 00:53:44.478 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Request SEMI (GSCM.SSP.Plan.UIL.SSP0045_ShipmentRequest)
- 조회 결과: Total :  · DB : 359.576s, UI : 0.017s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:47:28.720 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.8 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0045 |
| 00:47:28.743 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.62 | USER_ID= |
| 00:47:28.850 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 4.05 | LOGTYPE=SpeedUp, NOTE=SSP0045
division_id_changed
start
, USER_ID=jaeuk.shin |
| 00:47:28.885 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.47 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 00:47:29.313 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 421.0 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 00:47:29.507 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 24.0 | LOGTYPE=SpeedUp, NOTE=SSP0045
division_id_changed
end
, USER_ID=jaeuk.shin |
| 00:47:29.529 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.87 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 00:47:29.557 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 3.55 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:47:29.572 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 5.13 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:47:29.582 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 2.88 |  |
| 00:47:29.600 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 2.73 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 00:47:29.613 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 83 | 5.02 | Code=PlantSiteByDivision, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:47:29.626 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.31 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20270107 |
| 00:47:29.660 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 30.72 | p_program_id=SSP0045, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 00:47:29.671 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.64 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:47:29.801 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 125.65 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:47:29.823 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.24 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:47:29.934 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 66.93 | MenuID=Shipment Request SEMI, CnntCode=0104001, UserID=jaeuk.shin |
| 00:47:29.983 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.9 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0045 |
| 00:47:38.150 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 83 | 4.73 | Code=PlantSiteByDivision, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:47:38.163 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.67 | p_start_yyyymmdd=20261113, p_end_yyyymmdd=20270107 |
| 00:47:38.170 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.6 | p_program_id=SSP0045, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 00:47:38.179 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.68 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:47:38.236 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 54.39 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:47:38.261 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.6 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:53:37.856 | find | GSCM.SSP.Plan.WSL | SSP0045_GET_SHIPMENT_REQUEST | 0 | 359546.69 | p_division_id=40, p_operation_group=P, p_scm_site_id=, p_item_id=, p_from_yyyymmdd=20261113, p_to_yyyymmdd=20270107, p_program_id=SSP0045, p_sheet_name=Shipment Request, p_user_id=jaeuk.shin, debug_mode=F |
| 00:53:37.908 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 5.78 | p_menu_id=SSP0045, p_log_type=FIND, p_log_cnt=, p_db_time=359.576, p_ui_time=0.017, p_user_id=jaeuk.shin |
| 00:53:43.177 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.06 | MenuID=Shipment Request SEMI, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Operation Group* | cboBizType | Y |
| Div* | cboDivision | Y |
| Bucket | cboBucketType |  |
| Model | txtItem_Id |  |
| layoutControlItem4 | btnItem_Id |  |
| Period* | drpPeriod | Y |
| layoutControlItem9 | chkSum |  |
| From Site | clbFromSite |  |

## 그리드

- spdMain / Shipment Request: 행 0 · 컬럼 89(보임 68) · 헤더 3단 · 고정 컬럼 17

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
