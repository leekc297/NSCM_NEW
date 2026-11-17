# AS-IS 실측 요약 — GSCM_USERINFO

- 실행: 2026-11-12 21:05:36.984 ~ 2026-11-12 21:06:19.815 · 계정 jaeuk.shin · 상태 OK
- 화면: User (GSCM.SystemMgmt.UIL.UserInfo)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:05:37.353 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 4.03 | Code=Language, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:05:37.362 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.51 | Code=TimeZone, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:05:37.375 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 19 | 4.34 | Code=GroupID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:05:37.428 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.37 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0103 |
| 21:05:37.454 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.25 | USER_ID= |
| 21:05:37.549 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 19 | 3.69 | Code=GroupID, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:05:38.990 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1354.26 | MenuID=User, CnntCode=0104001, UserID=jaeuk.shin |
| 21:05:39.176 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0103 |
| 21:05:48.689 | find | GSCM.SystemMgmt.WSL | UP_FX_GetUserInfoSearchList | 7281 | 1032.11 | Search=None, DeptName=None, GroupID=None, UseYN=Y |
| 21:06:18.932 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.93 | MenuID=User, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| User ID(Name) | txtSearch |  |
| Dept ID (Name) | txtDept |  |
| User Group | cmbGroup |  |
| Use YN | cmbUseYN |  |

## 그리드

- spdMain / UserInfo: 행 7281 · 컬럼 33(보임 30) · 헤더 2단 · 고정 컬럼 3

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
