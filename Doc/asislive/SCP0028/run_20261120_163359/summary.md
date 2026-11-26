# AS-IS 실측 요약 — SCP0028

- 실행: 2026-11-20 16:33:59.776 ~ 2026-11-20 16:34:32.349 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Lot Size (GSCM.SCP.Master.UIL.SCP0028_Shipment_Lot_Size)
- 조회 결과: Total : 1,735 · DB : 3.16s, UI : 0.093s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 16:34:13.839 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.33 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 16:34:13.852 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.53 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:34:14.440 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 16:34:14.469 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.88 | USER_ID= |
| 16:34:14.727 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.4 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:34:14.765 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 21.52 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 16:34:14.805 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 29.8 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 16:34:14.883 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 9.82 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 16:34:14.898 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.9 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:34:15.042 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.92 | MenuID=Shipment Lot Size, CnntCode=0104001, UserID=jaeuk.shin |
| 16:34:15.137 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.03 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 16:34:22.876 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 6.92 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 16:34:22.891 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 5.73 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 16:34:26.036 | find | GSCM.SCP.Master.WSL | SCP0028_GET_SHIPMENT_LOT_SIZE | 1735 | 3085.03 | p_division_id=81, p_operation_group=P,A,E, p_from_site=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E, p_to_site=EG00,EG01_81-W,HQ05-W,HQ |
| 16:34:26.186 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.49 | p_menu_id=SCP0028, p_log_type=FIND, p_log_cnt=1735, p_db_time=3.16, p_ui_time=0.093, p_user_id=jaeuk.shin |

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
