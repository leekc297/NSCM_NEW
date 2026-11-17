# AS-IS 실측 요약 — SCP0028

- 실행: 2026-11-13 05:41:52.460 ~ 2026-11-13 05:42:14.099 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Lot Size (GSCM.SCP.Master.UIL.SCP0028_Shipment_Lot_Size)
- 조회 결과: Total : 1,735 · DB : 5.812s, UI : 0.084s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:41:52.774 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.29 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:41:52.786 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.52 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:41:52.843 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.24 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 05:41:52.868 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.99 | USER_ID= |
| 05:41:52.964 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 5.02 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:41:53.002 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 27 | 22.16 | Code=FromSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 05:41:53.045 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 475 | 29.02 | Code=ToSiteByDivision, Param1=81, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, TimeZone=AS054 |
| 05:41:53.105 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.4 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 05:41:53.111 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.19 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:41:53.309 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 170.33 | MenuID=Shipment Lot Size, CnntCode=0104001, UserID=jaeuk.shin |
| 05:41:53.394 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 4.02 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0028 |
| 05:42:01.937 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.58 | p_program_id=SCP0028, p_user_id=jaeuk.shin, p_sheet_name=Shipment Lot Size |
| 05:42:01.951 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 4.09 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:42:07.733 | find | GSCM.SCP.Master.WSL | SCP0028_GET_SHIPMENT_LOT_SIZE | 1735 | 5743.1 | p_division_id=81, p_operation_group=P,A,E, p_from_site=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E, p_to_site=EG00,EG01_81-W,HQ05-W,HQ |
| 05:42:07.898 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 13.01 | p_menu_id=SCP0028, p_log_type=FIND, p_log_cnt=1735, p_db_time=5.812, p_ui_time=0.084, p_user_id=jaeuk.shin |
| 05:42:13.361 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.58 | MenuID=Shipment Lot Size, CnntCode=0104002, UserID=jaeuk.shin |

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
