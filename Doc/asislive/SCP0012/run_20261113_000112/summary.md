# AS-IS 실측 요약 — SCP0012

- 실행: 2026-11-13 00:01:12.414 ~ 2026-11-13 00:11:48.950 · 계정 jaeuk.shin · 상태 OK
- 화면: PSI (GSCM.SCP.Analysis.UIL.SCP0012_PSI)
- 조회 결과: Total :  · DB : 620.144s, UI : 0.129s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:01:12.844 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 23.08 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:01:12.987 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 609 | 136.34 | Code=PlanType1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:01:13.028 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 63 | 30.27 | Code=FromSite_PSI1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:01:13.040 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 5.91 | Code=PlantByDivisionOperation1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:01:13.226 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 197 | 179.6 | Code=DATE_WEEKLY1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:01:13.369 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 613 | 137.65 | Code=PlanSeq1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:01:13.394 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 3 | 15.21 | Code=CellTypeGr, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:01:13.450 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0012 |
| 00:01:13.475 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.37 | USER_ID= |
| 00:01:13.704 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.1 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:01:13.731 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.3 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:01:13.873 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.12 |  |
| 00:01:13.929 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 7.99 | p_division_id=81, p_plan_cycle=DAILY, p_from_date=20260824, p_offset_month=12, p_timezone=AS054 |
| 00:01:13.952 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.07 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 00:01:14.008 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 22.92 | p_program_id=SCP0012, p_user_id=jaeuk.shin, p_sheet_name=PSI |
| 00:01:14.280 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 113.4 | MenuID=PSI, CnntCode=0104001, UserID=jaeuk.shin |
| 00:01:14.339 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.15 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0012 |
| 00:01:22.537 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 439 | 13.13 | p_start_yyyymmdd=20260824, p_end_yyyymmdd=20270822 |
| 00:01:22.552 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 5.61 | p_program_id=SCP0012, p_user_id=jaeuk.shin, p_sheet_name=PSI |
| 00:11:42.874 | find | GSCM.SCP.Analysis.WSL | SCP0012_GET_PSI | 0 | 620047.2 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=81, p_operation_group=P, p_From_Site=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, p_item_id=, p_electype=, p_program_id=None, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_user_id=None, p_cell_type_gr= |
| 00:11:43.068 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 34.15 | p_menu_id=SCP0012, p_log_type=FIND, p_log_cnt=, p_db_time=620.144, p_ui_time=0.129, p_user_id=jaeuk.shin |
| 00:11:48.034 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 73.69 | MenuID=PSI, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan date* | cboPlanDate | Y |
| Operation Group | cboOperGroup |  |
| Material | txtItemId |  |
| layoutControlItem2 | btnItemId |  |
| From Site | clbFromSite |  |
| Div* | cboDivision | Y |
| Plan type* | cboPlanType | Y |
| Seq* | cboPlanSeq | Y |
| Electrode | clbElecType |  |
| Bucket | cboBucketType |  |
| Cell Type Gr | cboCellTypeGr |  |
| layoutControlItem1 | chkSum |  |
| Period* | dCalendar | Y |

## 그리드

- spdMain / PSI: 행 0 · 컬럼 459(보임 322) · 헤더 3단 · 고정 컬럼 12

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
