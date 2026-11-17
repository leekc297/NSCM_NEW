# AS-IS 실측 요약 — SCP0028

- 실행: 2026-11-14 05:50:30.117 ~ 2026-11-14 05:51:08.127 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Lot Size (GSCM.SCP.Master.UIL.SCP0028_Shipment_Lot_Size)
- 조회 결과: Total : 1,735 · DB : 3.021s, UI : 0.067s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:50:45.962 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.18 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:50:45.977 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.61 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:46.779 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.7 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 05:50:46.811 | load | GSCM.BizService.WSL | SELECT * | 874 | 21.6 | USER_ID= |
| 05:50:47.182 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.74 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:47.248 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 21.87 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 05:50:47.293 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 28.21 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 05:50:47.469 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 6.27 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 05:50:47.493 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.36 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:50:47.844 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 112.24 | MenuID=Shipment Lot Size, CnntCode=0104001, UserID=jaeuk.shin |
| 05:50:47.966 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.84 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 05:50:57.063 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 6.42 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 05:50:57.071 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 5.78 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:51:00.084 | find | GSCM.SCP.Master.WSL | SCP0028_GET_SHIPMENT_LOT_SIZE | 1735 | 2943.48 | p_division_id=81, p_operation_group=P,A,E, p_from_site=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E, p_to_site=EG00,EG01_81-W,HQ05-W,HQ |
| 05:51:00.188 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.45 | p_menu_id=SCP0028, p_log_type=FIND, p_log_cnt=1735, p_db_time=3.021, p_ui_time=0.067, p_user_id=jaeuk.shin |

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
