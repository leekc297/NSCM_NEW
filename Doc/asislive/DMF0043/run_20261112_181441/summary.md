# AS-IS 실측 요약 — DMF0043

- 실행: 2026-11-12 18:14:41.325 ~ 2026-11-12 18:15:22.500 · 계정 jaeuk.shin · 상태 OK
- 화면: 해외법인 기여율 등록 (GSCM.DM.Master.UIL.DMF0043_Contribute_Main)
- 조회 결과:  · DB : 24.435s, UI : 0.101s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:14:42.054 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.35 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0043 |
| 18:14:42.080 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.44 | USER_ID= |
| 18:14:42.759 | load | GSCM.DM.Master.WSL | DMF0043_GET_MAIN_VARSION_DATA | 8 | 575.23 |  |
| 18:14:43.089 | load | GSCM.DM.Master.WSL | DMF0043_GET_MAIN_SPREAD_TITLE | 125 | 290.81 | p_division_id=40, p_yyyy=2026, p_created_by=jaeuk.shin |
| 18:14:43.116 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 12.12 | Code=DMF0043_UPPER_DEPT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:43.184 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 77 | 63.25 | Code=TeambyDivision2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:43.448 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 865 | 258.41 | Code=DMF0043_END_CUST_REPORT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:43.472 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 717 | 14.63 | Code=DMF0043_CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:43.485 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.16 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:43.493 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.48 | Code=DM_BIZ_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:43.995 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 345.63 | MenuID=해외법인 기여율 등록, CnntCode=0104001, UserID=jaeuk.shin |
| 18:14:44.087 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.66 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0043 |
| 18:14:51.523 | find | GSCM.DM.Master.WSL | DMF0043_GET_MAIN_SPREAD_TITLE | 125 | 7.81 | p_division_id=40, p_yyyy=2026, p_created_by=jaeuk.shin |
| 18:14:51.544 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 12.59 | Code=DMF0043_UPPER_DEPT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:51.614 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 77 | 64.47 | Code=TeambyDivision2, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:51.634 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 865 | 14.87 | Code=DMF0043_END_CUST_REPORT, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:51.657 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 717 | 16.02 | Code=DMF0043_CUST_GROUP_DTL, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:51.667 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.82 | Code=DMF0005_REPORT_GROUP3, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:14:51.675 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.56 | Code=DM_BIZ_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:15:16.037 | find | GSCM.DM.Master.WSL | DMF0043_GET_CONTRIBUTE_MAIN_DATA | 1527 | 24218.85 | p_yyyy=2026, p_ver_seq=15, p_dis=ALL, p_his=N, p_created_by=jaeuk.shin, p_user_group=ADMIN |
| 18:15:16.369 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 16.28 | p_menu_id=DMF0043, p_log_type=FIND, p_log_cnt=, p_db_time=24.435, p_ui_time=0.101, p_user_id=jaeuk.shin |
| 18:15:21.809 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.71 | MenuID=해외법인 기여율 등록, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Year | usrYear |  |
| layoutControlItem5 | chkYear |  |
| layoutControlItem5 | usrDiscard |  |
| 기여율버전관리 | btnCutOff |  |
| layoutControlItem5 | usrHis |  |

## 그리드

- spdMain / ContributeMain: 행 1527 · 컬럼 127(보임 116) · 헤더 2단 · 고정 컬럼 10

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
