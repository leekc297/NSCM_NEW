# AS-IS 실측 요약 — SCP0120

- 실행: 2026-11-12 20:39:26.724 ~ 2026-11-12 20:40:07.733 · 계정 jaeuk.shin · 상태 OK
- 화면: Constraint Mgmt (GSCM.SCP.Master.UIL.SCP0120_ConstraintMgmt)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:39:27.055 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 31.13 | Code=LookupCommon, Param1=SYSTEM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:39:27.742 | load | GSCM.SCP.Master.WSL | SCP0121_GET_SEARCH_INFO | 56 | 679.09 | p_user_id= |
| 20:39:27.832 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0120 |
| 20:39:27.856 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.22 | USER_ID= |
| 20:39:28.251 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 291.6 | MenuID=Constraint Mgmt, CnntCode=0104001, UserID=jaeuk.shin |
| 20:39:28.287 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.71 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0120 |
| 20:39:36.637 | find | GSCM.SCP.Master.WSL | SCP0120_GET_LOOKUP_MASTER | 82 | 401.4 | p_lookup_type=, p_valid_yn=Y, p_admin_yn=Y |
| 20:40:07.037 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.14 | MenuID=Constraint Mgmt, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Lookup Type | txtLookupType |  |
| Valid | cboValid |  |
| Plan Group | clbPlanGroup |  |

## 그리드

- spdMain / Lookup Type: 행 82 · 컬럼 35(보임 33) · 헤더 1단 · 고정 컬럼 3
- spdSub / Lookup Values: 행 0 · 컬럼 44(보임 33) · 헤더 1단 · 고정 컬럼 3

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
