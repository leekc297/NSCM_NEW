# AS-IS 실측 요약 — SCP0028

- 실행: 2026-11-20 16:14:00.785 ~ 2026-11-20 16:14:34.056 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Lot Size (GSCM.SCP.Master.UIL.SCP0028_Shipment_Lot_Size)
- 조회 결과: Total : 1,735 · DB : 3.104s, UI : 0.084s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 16:14:15.574 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.29 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:14:15.597 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.01 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:14:16.016 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 16:14:16.048 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.64 | USER_ID= |
| 16:14:16.317 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.47 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:14:16.377 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 24.02 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 16:14:16.424 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 28.08 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 16:14:16.489 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 5.69 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 16:14:16.507 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.15 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:14:16.658 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.29 | MenuID=Shipment Lot Size, CnntCode=0104001, UserID=jaeuk.shin |
| 16:14:16.782 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 16:14:24.887 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.33 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 16:14:24.900 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 5.2 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:14:27.968 | find | GSCM.SCP.Master.WSL | SCP0028_GET_SHIPMENT_LOT_SIZE | 1735 | 3033.07 | p_division_id=81, p_operation_group=P,A,E, p_from_site=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E, p_to_site=EG00,EG01_81-W,HQ05-W,HQ |
| 16:14:28.118 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.14 | p_menu_id=SCP0028, p_log_type=FIND, p_log_cnt=1735, p_db_time=3.104, p_ui_time=0.084, p_user_id=jaeuk.shin |

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
