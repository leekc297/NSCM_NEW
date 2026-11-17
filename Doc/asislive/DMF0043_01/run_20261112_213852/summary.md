# AS-IS 실측 요약 — DMF0043_01

- 실행: 2026-11-12 21:38:52.672 ~ 2026-11-12 21:39:42.960 · 계정 jaeuk.shin · 상태 OK
- 화면: 해외법인 기여매출 (GSCM.DM.Master.UIL.DMF0043_Contribute_View)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:38:52.970 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.67 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0043_01 |
| 21:38:52.994 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.27 | USER_ID= |
| 21:38:53.187 | load | GSCM.DM.Master.WSL | DMF0043_GET_MAIN_VARSION_DATA | 8 | 48.44 |  |
| 21:38:53.243 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 28.71 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:38:53.269 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.61 | Code=DM_BIZ_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:38:53.824 | load | GSCM.DM.Master.WSL | DMF0043_GET_SALES_LIST_SPREAD_TITLE | 27 | 539.74 | p_division_id=40, p_created_by=jaeuk.shin |
| 21:38:54.017 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 154.95 | MenuID=해외법인 기여매출, CnntCode=0104001, UserID=jaeuk.shin |
| 21:38:54.073 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.03 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0043_01 |
| 21:39:42.238 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.59 | MenuID=해외법인 기여매출, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 21:39:03.679 [GSCM] Version을 선택하고 조회하세요. → default_button(id=1)
