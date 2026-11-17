# AS-IS 실측 요약 — SCM0003

- 실행: 2026-11-12 21:10:33.772 ~ 2026-11-12 21:11:15.100 · 계정 jaeuk.shin · 상태 OK
- 화면: Lookup (GSCM.SCM.Master.UIL.SCM0003_Lookup)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:10:34.109 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.75 | Code=LookupCommon, Param1=SYSTEM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:10:34.191 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.34 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0202 |
| 21:10:34.216 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.59 | USER_ID= |
| 21:10:34.330 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.91 | Code=System, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:10:34.930 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 509.38 | MenuID=Lookup, CnntCode=0104001, UserID=jaeuk.shin |
| 21:10:35.054 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.64 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0202 |
| 21:10:44.051 | find | GSCM.SCM.Master.WSL | SCM0003_GET_LOOKUP_MASTER | 506 | 493.61 | p_lookup_type=, p_lookup_group=None, p_valid_yn=Y |
| 21:11:14.373 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.69 | MenuID=Lookup, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Lookup Type | txtLookupType |  |
| Valid | cboValid |  |
| System | cboLookupGroup |  |

## 그리드

- spdMain / Lookup Type: 행 506 · 컬럼 30(보임 28) · 헤더 1단 · 고정 컬럼 3
- spdSub / Lookup Values: 행 0 · 컬럼 34(보임 28) · 헤더 1단 · 고정 컬럼 3

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
