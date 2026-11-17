# AS-IS 실측 요약 — SCP0002

- 실행: 2026-11-12 19:34:34.976 ~ 2026-11-12 19:34:51.146 · 계정 jaeuk.shin · 상태 OK
- 화면: Line Master (GSCM.SCP.Master.UIL.SCP0002_LineMaster)
- 조회 결과: Total : 288 · DB : 0.945s, UI : 0.081s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:34:35.293 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.41 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:35.304 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.99 | Code=PlantByDivisionOperNonOsp123, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:35.312 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 122 | 4.09 | Code=BuildingByDivision1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:35.426 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1724 | 110.04 | Code=LineByOperation2, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:35.451 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 10 | 4.84 | Code=PlantByDivisionOperOsp3, Param1=40,81,82, Param2=P, Param3=Y, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:35.491 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 33 | 35.86 | Code=LineByPlantPacker, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:35.546 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0002 |
| 19:34:35.569 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.08 | USER_ID= |
| 19:34:35.762 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 26.81 | Code=LocationGroupByCapa, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:34:36.003 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 5.46 | p_program_id=SCP0002, p_user_id=jaeuk.shin, p_sheet_name=Plant |
| 19:34:36.018 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 9 | 3.75 | p_program_id=SCP0002, p_user_id=jaeuk.shin, p_sheet_name=Packer |
| 19:34:36.041 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 10 | 4.94 | Code=PlantByDivisionOperOsp3, Param1=40,81,82, Param2=P, Param3=Y, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:34:36.155 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 78.97 | MenuID=Line Master, CnntCode=0104001, UserID=jaeuk.shin |
| 19:34:36.206 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.94 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0002 |
| 19:34:44.213 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 17 | 3.91 | p_program_id=SCP0002, p_user_id=jaeuk.shin, p_sheet_name=Plant |
| 19:34:45.176 | find | GSCM.SCP.Master.WSL | SCP0002_GET_LINE_MASTER | 288 | 933.63 | p_division_id=81, p_scm_site_id=EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P, p_location_code=, p_factory_id=A1,A2,A9,AF,AL,AM,E5,E6,EG,EY,EZ,P1,P2,P6, |
| 19:34:45.273 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.58 | p_menu_id=SCP0002, p_log_type=FIND, p_log_cnt=288, p_db_time=0.945, p_ui_time=0.081, p_user_id=jaeuk.shin |
| 19:34:50.469 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.9 | MenuID=Line Master, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| Line | clbLine |  |
| Valid | cboValid |  |
| Building | clbBuilding |  |
| Div | cboDivision |  |
| Operation | clbOperation |  |

## 그리드

- spdMain / Plant: 행 288 · 컬럼 18(보임 12) · 헤더 1단 · 고정 컬럼 3
- spdMain / Packer: 행 0 · 컬럼 10(보임 8) · 헤더 1단 · 고정 컬럼 3

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
