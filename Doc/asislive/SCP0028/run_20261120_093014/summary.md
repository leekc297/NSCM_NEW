# AS-IS 실측 요약 — SCP0028

- 실행: 2026-11-20 09:30:14.688 ~ 2026-11-20 09:30:51.008 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Lot Size (GSCM.SCP.Master.UIL.SCP0028_Shipment_Lot_Size)
- 조회 결과: Total : 1,735 · DB : 3.199s, UI : 0.133s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 09:30:31.885 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.19 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 09:30:31.905 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 7.76 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:30:32.487 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.28 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 09:30:32.523 | load | GSCM.BizService.WSL | SELECT * | 874 | 25.0 | USER_ID= |
| 09:30:32.776 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.94 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:30:32.835 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 21.91 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 09:30:32.881 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 28.5 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 09:30:32.977 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 5.7 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 09:30:32.993 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.03 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:30:33.136 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.28 | MenuID=Shipment Lot Size, CnntCode=0104001, UserID=jaeuk.shin |
| 09:30:33.253 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 09:30:41.578 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 6.15 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 09:30:41.591 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.72 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:30:44.750 | find | GSCM.SCP.Master.WSL | SCP0028_GET_SHIPMENT_LOT_SIZE | 1735 | 3108.58 | p_division_id=81, p_operation_group=P,A,E, p_from_site=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E, p_to_site=EG00,EG01_81-W,HQ05-W,HQ |
| 09:30:44.962 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 4.04 | p_menu_id=SCP0028, p_log_type=FIND, p_log_cnt=1735, p_db_time=3.199, p_ui_time=0.133, p_user_id=jaeuk.shin |

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
