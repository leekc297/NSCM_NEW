# AS-IS 실측 요약 — SCM0008

- 실행: 2026-11-12 19:32:03.256 ~ 2026-11-12 19:33:00.495 · 계정 jaeuk.shin · 상태 OK
- 화면: Auth Request (GSCM.SystemMgmt.UIL.SCM0008_Auth_Request)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:32:03.717 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.37 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCM0008 |
| 19:32:03.791 | load | GSCM.BizService.WSL | SELECT * | 874 | 62.44 | USER_ID= |
| 19:32:03.983 | load | GSCM.SystemMgmt.WSL | UP_FX_GetReqAuthCurrentUser | 1 | 3.57 | p_UserID=jaeuk.shin |
| 19:32:03.992 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 11.74 | Code=Language, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:32:04.037 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 18.47 | Code=TimeZone, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:32:04.388 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 216.42 | MenuID=Auth Request, CnntCode=0104001, UserID=jaeuk.shin |
| 19:32:04.569 | load | GSCM.SystemMgmt.WSL | UP_FX_GetReqAuthGroupInfo | 9 | 454.52 |  |
| 19:32:17.985 | load | GSCM.SystemMgmt.WSL | UP_FX_GetReqAuthMyListAdded | 71 | 11335.36 | p_UserID=jaeuk.shin |
| 19:32:18.399 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCM0008 |
| 19:32:18.780 | load | GSCM.SystemMgmt.WSL | UP_FX_GetNewUserAuthRequestList | 14 | 392.58 | GroupID=ADMIN, UserID=jaeuk.shin, AuthType=D, DivisionID= |
| 19:32:28.018 | find | GSCM.SystemMgmt.WSL | UP_FX_GetReqAuthGroupInfo | 9 | 4.4 |  |
| 19:32:28.159 | find | GSCM.SystemMgmt.WSL | UP_FX_GetReqAuthMyListAdded | 71 | 76.7 | p_UserID=jaeuk.shin |
| 19:32:28.760 | find | GSCM.SystemMgmt.WSL | UP_FX_GetNewUserAuthRequestList | 14 | 3.2 | GroupID=ADMIN, UserID=jaeuk.shin, AuthType=D, DivisionID= |
| 19:32:59.409 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.57 | MenuID=Auth Request, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| layoutControlItem1 | btnAdd |  |
| layoutControlItem10 | btnAuthDelete |  |
| layoutControlItem3 | usrLabel1 |  |
| Language* | cboLanguage | Y |
| Time Zone* | cboTimeZone | Y |
| User ID | txtUserId |  |
| User Name | txtUserName |  |
| Department | txtDeptName |  |
| Email* | txtEMail | Y |
| Cell Phone* | txtCellPhone | Y |
| layoutControlItem2 | btnRequest |  |

## 그리드

- spdMyAuthList / My Authority List: 행 71 · 컬럼 12(보임 8) · 헤더 1단 · 고정 컬럼 0
- spdDivision / Division: 행 14 · 컬럼 3(보임 2) · 헤더 1단 · 고정 컬럼 0
- spdMain / Authority: 행 9 · 컬럼 4(보임 2) · 헤더 1단 · 고정 컬럼 2

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
