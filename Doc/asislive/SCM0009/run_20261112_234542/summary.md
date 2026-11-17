# AS-IS 실측 요약 — SCM0009

- 실행: 2026-11-12 23:45:42.459 ~ 2026-11-12 23:46:26.974 · 계정 jaeuk.shin · 상태 OK
- 화면: Auth Approval (GSCM.SystemMgmt.UIL.SCM0009_Auth_Approval)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 23:45:42.860 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.92 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCM0009 |
| 23:45:42.921 | load | GSCM.BizService.WSL | SELECT * | 874 | 56.37 | USER_ID= |
| 23:45:43.055 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 42.2 | Code=LookupCommon, Param1=APPROVAL_RESULT, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 23:45:43.091 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 20.59 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 23:45:43.287 | load | GSCM.SCP.Analysis.WSL | SELECT | 1 | 151.76 |  |
| 23:45:43.352 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 31.1 | MenuID=Auth Approval, CnntCode=0104001, UserID=jaeuk.shin |
| 23:45:43.399 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.83 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCM0009 |
| 23:45:53.592 | find | GSCM.SystemMgmt.WSL | UP_FX_GetApprovalAuthRequest | 0 | 708.51 | p_Division_id=40,81,81_HD,81_HG,81_HM,81_UC,82,EE,EE_HD,EE_HG,EE_HM,EE_UC, p_User_id=, p_Dept_Name=, p_ReqFromDate=2026-10-12, p_ReqToDate=2026-11-12, p_ApprFromDate=None, p_ApprToDate=None, p_ApprResult=REQUESTING |
| 23:46:26.069 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.25 | MenuID=Auth Approval, CnntCode=0104002, UserID=jaeuk.shin |

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
