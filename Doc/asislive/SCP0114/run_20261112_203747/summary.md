# AS-IS 실측 요약 — SCP0114

- 실행: 2026-11-12 20:37:47.832 ~ 2026-11-12 20:38:36.506 · 계정 jaeuk.shin · 상태 OK
- 화면: CAPA LineMaster (GSCM.SCP.Master.UIL.SCP0114_CAPA_LineMaster)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:37:48.198 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 28.25 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:37:49.721 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 26 | 1510.36 | Code=CapaSite, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:37:50.608 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 17 | 884.42 | Code=CapaCompany, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:37:51.344 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 84 | 731.62 | Code=CapaPlant, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:37:52.109 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 247 | 759.89 | Code=CapaFactory, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:37:53.196 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1290 | 1074.51 | Code=CapaLine, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:37:53.551 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.99 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0114 |
| 20:37:53.580 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.31 | USER_ID= |
| 20:37:54.353 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 517.89 | MenuID=CAPA LineMaster, CnntCode=0104001, UserID=jaeuk.shin |
| 20:37:54.411 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0114 |
| 20:37:59.821 | load | GSCM.SCP.Master.WSL | SCP0106_GET_CAPA_LOSS_PLAN_CURRENT_ELTR | 1224 | 516759.59 | p_version=202610, p_version_seq=1, p_prog_stat=0, p_division_id=81, p_site_id=A001,A002,A003,A004, p_plant_id=HQ07,MI00,MI02,NA00,NB01,WA00, p_factory_id=E6,E9,EA,EB,EC,ED,EF,EJ,ES,ET, p_line_id=DUM_MI2_E3_A,DUM_MI2_E3_C,FP_E6M02_A,FP_E6M02_C,FP_E9M01_A,FP_E9M01_C,FP_E9M02_C,FP_EAM01_A,FP_EAM01_C,FP |
| 20:38:05.111 | find | GSCM.SCP.Master.WSL | SCP0114_GET_CAPA_LINE_MASTER | 4 | 542.61 | p_menu_level=1, p_division_id=81, p_site_id=, p_company_id=, p_plant_id=, p_factory_id=, p_line_id=, p_shop_group_id=E |
| 20:38:35.805 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.85 | MenuID=CAPA LineMaster, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |

## 그리드

- spdLevel3 / Level3: 행 0 · 컬럼 10(보임 3) · 헤더 1단 · 고정 컬럼 5
- spdLevel2 / Level2: 행 0 · 컬럼 8(보임 3) · 헤더 1단 · 고정 컬럼 3
- spdLevel1 / Level1: 행 4 · 컬럼 6(보임 4) · 헤더 1단 · 고정 컬럼 1
- spdLevel5 / Level5: 행 0 · 컬럼 16(보임 5) · 헤더 1단 · 고정 컬럼 9
- spdLevel4 / Level4: 행 0 · 컬럼 12(보임 3) · 헤더 1단 · 고정 컬럼 7

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
