# AS-IS 실측 요약 — SCM0005

- 실행: 2026-11-12 21:11:56.922 ~ 2026-11-12 21:12:48.285 · 계정 jaeuk.shin · 상태 OK
- 화면: Dynamic Query List (GSCM.SCM.Master.UIL.SCM0005_DynamicQueryList)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:11:57.394 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 27.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0205 |
| 21:11:57.477 | load | GSCM.BizService.WSL | SELECT * | 874 | 56.38 | USER_ID= |
| 21:11:57.804 | load | GSCM.SCM.Master.WSL | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON | 17 | 200.13 | p_nickname=ROLES |
| 21:11:57.871 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 44.86 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:11:57.944 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 67.85 | Code=SiteByEndCustomer, Param1=ALL, Param2=ALL, Param3=ADMIN, Param4=jaeuk.shin, Param5=, TimeZone=AS054 |
| 21:11:58.512 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 496.93 | MenuID=Dynamic Query List, CnntCode=0104001, UserID=jaeuk.shin |
| 21:11:58.602 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 2 | 9.33 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0205 |
| 21:12:15.394 | find | GSCM.SCM.Master.WSL | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | 142 | 7909.44 | p_dq_id=, p_dq_name=, p_role=ALL |
| 21:12:47.403 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.19 | MenuID=Dynamic Query List, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Report Name | umltReportName |  |
| Role | clbRole |  |
| Description | txtDescription |  |
| Report Name | umltReportNameResult |  |
| Role | clbRoleResult |  |
| layoutControlItem1 | lbl_DQ_ID |  |
| Description | txtDescrptionResult |  |

## 그리드

- spdMain / DynamicList: 행 142 · 컬럼 17(보임 16) · 헤더 1단 · 고정 컬럼 0
- fpGroup / DynamicGroup: 행 0 · 컬럼 7(보임 5) · 헤더 2단 · 고정 컬럼 0
- fpWhere / DynamicWhere: 행 0 · 컬럼 7(보임 5) · 헤더 2단 · 고정 컬럼 0
- fpResult / DynamicResult: 행 0 · 컬럼 5(보임 4) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
