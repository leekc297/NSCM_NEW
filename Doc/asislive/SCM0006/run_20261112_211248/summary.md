# AS-IS 실측 요약 — SCM0006

- 실행: 2026-11-12 21:12:48.412 ~ 2026-11-12 21:13:30.437 · 계정 jaeuk.shin · 상태 OK
- 화면: Mail Setup (GSCM.SCM.Master.UIL.SCM0006_Mail_Setup)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:12:48.772 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 101.83 | Code=Module, Param1=SMS_MAIL_SEND_SYSTEM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:12:48.781 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.53 | Code=SubModule, Param1=SMS_MAIL_SEND_SYSTEM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:12:48.861 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 71.8 | Code=Cycle, Param1=MAIL_SEND_CYCLE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:12:48.925 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 69 | 59.41 | Code=CycleSub1, Param1=MAIL_SEND_CYCLE_DETAIL, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:12:48.933 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 30 | 3.67 | Code=CycleSub2_v2, Param1=MAIL_SEND_CYCLE_DETAIL, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:12:48.941 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 6 | 3.51 | Code=CycleSub3, Param1=MAIL_SEND_CYCLE_DETAIL, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:12:48.949 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.62 | Code=LookupCommon, Param1=LANGUAGE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:12:49.119 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.96 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0206 |
| 21:12:49.144 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.02 | USER_ID= |
| 21:12:49.271 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 7.45 | Code=Module, Param1=SMS_MAIL_SEND_SYSTEM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:12:49.289 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.22 | Code=SubModule, Param1=SMS_MAIL_SEND_SYSTEM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:12:49.940 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 568.18 | MenuID=Mail Setup, CnntCode=0104001, UserID=jaeuk.shin |
| 21:12:50.014 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.66 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0206 |
| 21:12:59.059 | find | GSCM.SCM.Master.WSL | SCM0006_GET_RECIPIENT_MASTER | 44 | 460.9 | p_use_type=MAIL, p_module=None, p_submodule=None, p_active=Y |
| 21:13:29.522 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.93 | MenuID=Mail Setup, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Module | cboModule |  |
| Sub Module | cboSubModule |  |
| Active | cboActive |  |
| Department | txtDept |  |
| User ID(Name) | txtUser |  |

## 그리드

- Category / Category: 행 44 · 컬럼 12(보임 9) · 헤더 2단 · 고정 컬럼 0
- Message / Message: 행 0 · 컬럼 7(보임 4) · 헤더 1단 · 고정 컬럼 0
- All_Receiver / All_Receiver: 행 0 · 컬럼 7(보임 3) · 헤더 1단 · 고정 컬럼 0
- Sel_Receiver / Sel_Receiver: 행 0 · 컬럼 10(보임 3) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
