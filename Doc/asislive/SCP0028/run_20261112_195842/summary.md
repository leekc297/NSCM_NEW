# AS-IS 실측 요약 — SCP0028

- 실행: 2026-11-12 19:58:42.094 ~ 2026-11-12 19:59:02.662 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Lot Size (GSCM.SCP.Master.UIL.SCP0028_Shipment_Lot_Size)
- 조회 결과: Total : 1,735 · DB : 3.479s, UI : 0.099s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:58:42.462 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.93 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:58:42.470 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.3 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:58:42.793 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.17 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 19:58:42.821 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.94 | USER_ID= |
| 19:58:42.995 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.98 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:58:43.041 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 21.91 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 19:58:43.082 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 28.96 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 19:58:43.152 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.79 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 19:58:43.163 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.51 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:58:44.227 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 964.16 | MenuID=Shipment Lot Size, CnntCode=0104001, UserID=jaeuk.shin |
| 19:58:44.363 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.1 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 19:58:46.721 | load | GSCM.SCP.Analysis.WSL | SCP0022_GET_FORMATION | 1361 | 231287.13 | p_division_id=81, p_plant_site_id=HQ07-A,HQ11-A,MI00-A,MI02-A,NA00-A,NB01-A,WA00-A, p_item_id= |
| 19:58:52.809 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.7 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 19:58:52.818 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.31 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:58:56.283 | find | GSCM.SCP.Master.WSL | SCP0028_GET_SHIPMENT_LOT_SIZE | 1735 | 3440.19 | p_division_id=81, p_operation_group=P,A,E, p_from_site=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E, p_to_site=EG00,EG01_81-W,HQ05-W,HQ |
| 19:58:56.435 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 9.09 | p_menu_id=SCP0028, p_log_type=FIND, p_log_cnt=1735, p_db_time=3.479, p_ui_time=0.099, p_user_id=jaeuk.shin |
| 19:59:01.822 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.3 | MenuID=Shipment Lot Size, CnntCode=0104002, UserID=jaeuk.shin |

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

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
