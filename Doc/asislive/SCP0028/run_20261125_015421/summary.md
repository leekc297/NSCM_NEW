# AS-IS 실측 요약 — SCP0028

- 실행: 2026-11-25 01:54:21.267 ~ 2026-11-25 01:56:35.830 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Lot Size (GSCM.SCP.Master.UIL.SCP0028_Shipment_Lot_Size)
- 조회 결과: Total : 1,735 · DB : 4.064s, UI : 0.088s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 01:56:00.448 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 98578.84 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 01:56:00.465 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.19 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:56:04.631 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3388.93 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 01:56:04.800 | load | GSCM.BizService.WSL | SELECT * | 874 | 147.17 | USER_ID= |
| 01:56:05.114 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.53 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:56:05.436 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 280.1 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 01:56:05.568 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 117.32 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 01:56:08.389 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 1223.79 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 01:56:08.414 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.15 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:56:11.827 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 3245.97 | MenuID=Shipment Lot Size, CnntCode=0104001, UserID=jaeuk.shin |
| 01:56:13.901 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 1882.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 01:56:22.649 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 6.1 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 01:56:22.657 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.26 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 01:56:26.688 | find | GSCM.SCP.Master.WSL | SCP0028_GET_SHIPMENT_LOT_SIZE | 1735 | 3044.96 | p_division_id=81, p_operation_group=P,A,E, p_from_site=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E, p_to_site=EG00,EG01_81-W,HQ05-W,HQ |
| 01:56:27.505 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 670.7 | p_menu_id=SCP0028, p_log_type=FIND, p_log_cnt=1735, p_db_time=4.064, p_ui_time=0.088, p_user_id=jaeuk.shin |
| 01:56:33.889 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.11 | MenuID=Shipment Lot Size, CnntCode=0104002, UserID=jaeuk.shin |

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
