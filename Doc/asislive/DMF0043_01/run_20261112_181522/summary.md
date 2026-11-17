# AS-IS 실측 요약 — DMF0043_01

- 실행: 2026-11-12 18:15:22.638 ~ 2026-11-12 18:16:10.952 · 계정 jaeuk.shin · 상태 OK
- 화면: 해외법인 기여매출 (GSCM.DM.Master.UIL.DMF0043_Contribute_View)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:15:23.089 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.06 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0043_01 |
| 18:15:23.111 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.45 | USER_ID= |
| 18:15:23.268 | load | GSCM.DM.Master.WSL | DMF0043_GET_MAIN_VARSION_DATA | 8 | 3.01 |  |
| 18:15:23.317 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.98 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:15:23.345 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.41 | Code=DM_BIZ_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:15:23.502 | load | GSCM.DM.Master.WSL | DMF0043_GET_SALES_LIST_SPREAD_TITLE | 27 | 137.53 | p_division_id=40, p_created_by=jaeuk.shin |
| 18:15:23.978 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 428.34 | MenuID=해외법인 기여매출, CnntCode=0104001, UserID=jaeuk.shin |
| 18:15:24.047 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.72 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0043_01 |
| 18:16:10.283 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.39 | MenuID=해외법인 기여매출, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Version | txtVersion |  |
| layoutControlItem1 | btnSPVer |  |
| Year | usrYear |  |
| layoutControlItem5 | chkM |  |
| Biz | usrBiz |  |
| 고객군 | usrCust |  |
| tst | usrChk |  |
| layoutControlItem8 | btnColumn |  |
| 제품군 | usrType |  |

## 그리드

- spdMain / ContributeSalesList: 행 0 · 컬럼 28(보임 27) · 헤더 2단 · 고정 컬럼 10

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 18:15:32.408 [GSCM] Version을 선택하고 조회하세요. → default_button(id=1)
