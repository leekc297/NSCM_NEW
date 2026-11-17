# AS-IS 실측 요약 — SCP0007

- 실행: 2026-11-13 05:40:55.355 ~ 2026-11-13 05:41:30.091 · 계정 jaeuk.shin · 상태 OK
- 화면: BOD (GSCM.SCP.Master.UIL.SCP0007_BOD)
- 조회 결과: Total : 15,317 · DB : 12.71s, UI : 1.507s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 05:40:55.783 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.65 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:40:56.120 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 16751 | 331.98 | Code=Customer1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:40:56.246 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 21.69 | Code=FromSiteByDivision1Ex, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:40:56.359 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 108.13 | Code=ToSiteBOD1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:40:56.404 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 22.73 | Code=FromSiteByDivision1, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:40:56.438 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 28.34 | Code=ToSiteBOD1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:40:56.473 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 26 | 17.32 | Code=ToSiteByDivisionPlant1, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:40:56.520 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 43.24 | Code=ToSiteByDivision1, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 05:40:56.549 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.87 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:40:56.558 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 4.17 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:40:56.567 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.43 | Code=incotermsEdit, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:40:56.884 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.16 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0007 |
| 05:40:56.917 | load | GSCM.BizService.WSL | SELECT * | 874 | 24.0 | USER_ID= |
| 05:40:59.106 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 8.53 | p_program_id=SCP0007, p_user_id=jaeuk.shin, p_sheet_name=BOD |
| 05:40:59.129 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 14.04 | Code=FromSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:40:59.255 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 121.6 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:40:59.281 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.2 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:40:59.289 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.13 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:40:59.541 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 137.32 | MenuID=BOD, CnntCode=0104001, UserID=jaeuk.shin |
| 05:40:59.610 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.04 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0007 |
| 05:41:09.141 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 7.61 | p_program_id=SCP0007, p_user_id=jaeuk.shin, p_sheet_name=BOD |
| 05:41:09.163 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 14.61 | Code=FromSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:41:09.247 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 81.05 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:41:09.270 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.5 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:41:09.277 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.7 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 05:41:09.462 | find | GSCM.SCP.Master.WSL | SCP0007_GET_COUNTRY_CITY | 3034 | 38.97 | p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_scm_site_id=, debug_mode=F |
| 05:41:21.525 | find | GSCM.SCP.Master.WSL | SCP0007_GET_BOD | 15317 | 12080.47 | p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_from_site=ST00-A,ST00-E,ST00-P,EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,HD0 |
| 05:41:23.594 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 60.0 | p_menu_id=SCP0007, p_log_type=FIND, p_log_cnt=15317, p_db_time=12.71, p_ui_time=1.507, p_user_id=jaeuk.shin |
| 05:41:29.436 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.88 | MenuID=BOD, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Input Status | cboInputStatus |  |
| Valid | cboValidYN |  |
| From Site | clbFromSite |  |
| To Site | clbToSite |  |
| Incoterms | clbIncoterms |  |
| Trans Mode | clbTransMode |  |
| SSP Incoterms | clbIncotermsSSP |  |
| Div | clbDivision |  |

## 그리드

- spdMain / BOD: 행 15317 · 컬럼 41(보임 34) · 헤더 2단 · 고정 컬럼 11

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
