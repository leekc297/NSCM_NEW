# AS-IS 실측 요약 — SCM0007

- 실행: 2026-11-12 21:14:12.275 ~ 2026-11-12 21:14:53.642 · 계정 jaeuk.shin · 상태 OK
- 화면: SMS Setup (GSCM.SCM.Master.UIL.SCM0007_SMS_Setup)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:14:12.631 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.27 | Code=Module, Param1=SMS_MAIL_SEND_SYSTEM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:14:12.638 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.3 | Code=SubModule, Param1=SMS_MAIL_SEND_SYSTEM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:14:12.650 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 4 | 3.47 | Code=Cycle, Param1=MAIL_SEND_CYCLE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:14:12.659 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 69 | 3.78 | Code=CycleSub1, Param1=MAIL_SEND_CYCLE_DETAIL, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:14:12.687 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 24 | 23.51 | Code=CycleSub2, Param1=MAIL_SEND_CYCLE_DETAIL, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:14:12.696 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.74 | Code=LookupCommon, Param1=LANGUAGE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:14:12.852 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0208 |
| 21:14:12.876 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.86 | USER_ID= |
| 21:14:13.004 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.26 | Code=Module, Param1=SMS_MAIL_SEND_SYSTEM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:14:13.020 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.54 | Code=SubModule, Param1=SMS_MAIL_SEND_SYSTEM, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:14:13.391 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 291.23 | MenuID=SMS Setup, CnntCode=0104001, UserID=jaeuk.shin |
| 21:14:13.471 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0208 |
| 21:14:21.980 | find | GSCM.SCM.Master.WSL | SCM0006_GET_RECIPIENT_MASTER | 34 | 4.46 | p_use_type=SMS, p_module=None, p_submodule=None, p_active=Y |
| 21:14:52.678 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.78 | MenuID=SMS Setup, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Module | cboModule |  |
| Sub Module | cboSubModule |  |
| Active | cboActive |  |
| Group Name | txtGroup |  |
| Cell Phone | txtPhone |  |

## 그리드

- Category / Category: 행 34 · 컬럼 10(보임 7) · 헤더 2단 · 고정 컬럼 0
- Message / Message: 행 0 · 컬럼 6(보임 3) · 헤더 1단 · 고정 컬럼 0
- All_Receiver / All_Receiver: 행 0 · 컬럼 3(보임 2) · 헤더 1단 · 고정 컬럼 0
- Sel_Receiver / Sel_Receiver: 행 0 · 컬럼 4(보임 2) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
