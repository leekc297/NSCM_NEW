# AS-IS 실측 요약 — SCP0007

- 실행: 2026-11-12 19:36:37.098 ~ 2026-11-12 19:37:18.445 · 계정 jaeuk.shin · 상태 OK
- 화면: BOD (GSCM.SCP.Master.UIL.SCP0007_BOD)
- 조회 결과: Total : 15,317 · DB : 16.015s, UI : 1.488s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:36:37.523 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.54 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:36:38.652 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 16751 | 1115.65 | Code=Customer1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:36:38.923 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 126.59 | Code=FromSiteByDivision1Ex, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:36:38.984 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 30.21 | Code=ToSiteBOD1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:36:39.044 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 24.64 | Code=FromSiteByDivision1, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:36:39.079 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 28.17 | Code=ToSiteBOD1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:36:39.126 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 26 | 17.63 | Code=ToSiteByDivisionPlant1, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:36:39.178 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 43.5 | Code=ToSiteByDivision1, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:36:39.220 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.92 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:39.228 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.96 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:39.241 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.87 | Code=incotermsEdit, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:39.747 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.25 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0007 |
| 19:36:39.774 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.99 | USER_ID= |
| 19:36:42.111 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 232.99 | p_program_id=SCP0007, p_user_id=jaeuk.shin, p_sheet_name=BOD |
| 19:36:42.132 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 13.34 | Code=FromSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:42.383 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 245.65 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:42.412 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 4.6 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:42.420 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.32 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:44.015 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1465.47 | MenuID=BOD, CnntCode=0104001, UserID=jaeuk.shin |
| 19:36:44.344 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0007 |
| 19:36:54.296 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 6.96 | p_program_id=SCP0007, p_user_id=jaeuk.shin, p_sheet_name=BOD |
| 19:36:54.314 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 14.19 | Code=FromSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:54.386 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 66.85 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:54.426 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.88 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:54.434 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 4.16 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:36:54.584 | find | GSCM.SCP.Master.WSL | SCP0007_GET_COUNTRY_CITY | 3034 | 23.0 | p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_scm_site_id=, debug_mode=F |
| 19:37:09.918 | find | GSCM.SCP.Master.WSL | SCP0007_GET_BOD | 15317 | 15355.61 | p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_from_site=ST00-A,ST00-E,ST00-P,EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,HD0 |
| 19:37:12.164 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 192.84 | p_menu_id=SCP0007, p_log_type=FIND, p_log_cnt=15317, p_db_time=16.015, p_ui_time=1.488, p_user_id=jaeuk.shin |
| 19:37:17.574 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.07 | MenuID=BOD, CnntCode=0104002, UserID=jaeuk.shin |

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
