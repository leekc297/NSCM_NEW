# AS-IS 실측 요약 — SCP0028

- 실행: 2026-11-19 16:27:45.029 ~ 2026-11-19 16:28:23.578 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Lot Size (GSCM.SCP.Master.UIL.SCP0028_Shipment_Lot_Size)
- 조회 결과: Total : 1,735 · DB : 4.201s, UI : 0.077s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 16:28:02.654 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.04 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:28:02.671 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.81 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:28:03.260 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.25 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 16:28:03.308 | load | GSCM.BizService.WSL | SELECT * | 874 | 26.14 | USER_ID= |
| 16:28:03.681 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.57 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:28:03.777 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 43.95 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 16:28:03.873 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 77.39 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 16:28:04.014 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 32.17 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 16:28:04.029 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.85 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:28:04.410 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 220.4 | MenuID=Shipment Lot Size, CnntCode=0104001, UserID=jaeuk.shin |
| 16:28:04.547 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.95 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 16:28:13.040 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 6.55 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 16:28:13.055 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.51 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:28:17.223 | find | GSCM.SCP.Master.WSL | SCP0028_GET_SHIPMENT_LOT_SIZE | 1735 | 3129.54 | p_division_id=81, p_operation_group=P,A,E, p_from_site=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E, p_to_site=EG00,EG01_81-W,HQ05-W,HQ |
| 16:28:17.391 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 6.92 | p_menu_id=SCP0028, p_log_type=FIND, p_log_cnt=1735, p_db_time=4.201, p_ui_time=0.077, p_user_id=jaeuk.shin |

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
