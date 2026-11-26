# AS-IS 실측 요약 — SCP0028

- 실행: 2026-11-20 16:26:24.607 ~ 2026-11-20 16:26:59.199 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Lot Size (GSCM.SCP.Master.UIL.SCP0028_Shipment_Lot_Size)
- 조회 결과: Total : 1,735 · DB : 3.185s, UI : 0.088s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 16:26:38.782 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.37 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:26:38.802 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.61 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:26:39.109 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 16:26:39.145 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.35 | USER_ID= |
| 16:26:39.376 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 5.67 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:26:39.428 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 22.88 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 16:26:39.473 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 29.93 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 16:26:39.558 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 6.29 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 16:26:39.569 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.27 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:26:39.703 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.47 | MenuID=Shipment Lot Size, CnntCode=0104001, UserID=jaeuk.shin |
| 16:26:39.780 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 16:26:47.463 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 8.71 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 16:26:47.481 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 6.46 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:26:50.643 | find | GSCM.SCP.Master.WSL | SCP0028_GET_SHIPMENT_LOT_SIZE | 1735 | 3102.46 | p_division_id=81, p_operation_group=P,A,E, p_from_site=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E, p_to_site=EG00,EG01_81-W,HQ05-W,HQ |
| 16:26:50.810 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 27.23 | p_menu_id=SCP0028, p_log_type=FIND, p_log_cnt=1735, p_db_time=3.185, p_ui_time=0.088, p_user_id=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Operation Group | cboOperationGroup |  |
| From Site | clbFromSite |  |
| Model | txtItemId |  |
| layoutControlItem11 | btnItemId |  |
| Valid | cboValid |  |
| Input | btnInput |  |
| Delete | btnDelete |  |
| To Site | clbToSite |  |
| Trans Mode | clbTransMode |  |

## 그리드

- spdMain / Shipment Lot Size: 행 1735 · 컬럼 20(보임 15) · 헤더 1단 · 고정 컬럼 1
