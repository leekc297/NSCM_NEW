# AS-IS 실측 요약 — SCM0009

- 실행: 2026-11-12 22:18:44.886 ~ 2026-11-12 22:19:29.102 · 계정 jaeuk.shin · 상태 OK
- 화면: Auth Approval (GSCM.SystemMgmt.UIL.SCM0009_Auth_Approval)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:18:45.234 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCM0009 |
| 22:18:45.316 | load | GSCM.BizService.WSL | SELECT * | 874 | 77.75 | USER_ID= |
| 22:18:45.459 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 49.9 | Code=LookupCommon, Param1=APPROVAL_RESULT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:18:45.527 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 49.23 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:18:45.738 | load | GSCM.SCP.Analysis.WSL | SELECT | 1 | 184.82 |  |
| 22:18:45.816 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 36.44 | MenuID=Auth Approval, CnntCode=0104001, UserID=jaeuk.shin |
| 22:18:45.864 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.88 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCM0009 |
| 22:18:56.235 | find | GSCM.SystemMgmt.WSL | UP_FX_GetApprovalAuthRequest | 0 | 702.02 | p_Division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE,EE_HD,EE_HG,EE_HM,EE_UC, p_User_id=, p_Dept_Name=, p_ReqFromDate=2026-10-12, p_ReqToDate=2026-11-12, p_ApprFromDate=None, p_ApprToDate=None, p_ApprResult=REQUESTING |
| 22:19:28.400 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.76 | MenuID=Auth Approval, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| User ID(Name) | txtUser |  |
| Department | txtDept |  |
| Div | clbDivision |  |
| Request Date | drpReqPeriod |  |
| layoutControlItem5 | btnReject |  |
| Approval Result | cboApprovalResult |  |
| layoutControlItem6 | btnApproval |  |

## 그리드

- spdMain / My Authority List: 행 0 · 컬럼 20(보임 14) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
