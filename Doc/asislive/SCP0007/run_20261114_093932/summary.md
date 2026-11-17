# AS-IS 실측 요약 — SCP0007

- 실행: 2026-11-14 09:39:32.248 ~ 2026-11-14 09:40:27.912 · 계정 jaeuk.shin · 상태 OK
- 화면: BOD (GSCM.SCP.Master.UIL.SCP0007_BOD)
- 조회 결과: Total : 15,317 · DB : 10.636s, UI : 1.883s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 09:39:47.687 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.38 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 09:39:47.905 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 16751 | 208.31 | Code=Customer1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 09:39:48.193 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 121.32 | Code=FromSiteByDivision1Ex, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 09:39:48.250 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 29.23 | Code=ToSiteBOD1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 09:39:48.306 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 97 | 22.73 | Code=FromSiteByDivision1, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 09:39:48.341 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 28.57 | Code=ToSiteBOD1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 09:39:48.386 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 26 | 17.0 | Code=ToSiteByDivisionPlant1, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 09:39:48.434 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 42.37 | Code=ToSiteByDivision1, Param1=, Param2=ADMIN, Param3=jaeuk.shin, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 09:39:48.500 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 29.29 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:39:48.603 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 98.47 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:39:48.617 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 10 | 3.79 | Code=incotermsEdit, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:39:49.348 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0007 |
| 09:39:49.380 | load | GSCM.BizService.WSL | SELECT * | 874 | 17.94 | USER_ID= |
| 09:39:54.824 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 28.1 | p_program_id=SCP0007, p_user_id=jaeuk.shin, p_sheet_name=BOD |
| 09:39:54.854 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 13.32 | Code=FromSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:39:54.996 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 134.72 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:39:55.035 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.68 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:39:55.046 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.37 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:39:55.438 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 142.12 | MenuID=BOD, CnntCode=0104001, UserID=jaeuk.shin |
| 09:39:55.587 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0007 |
| 09:40:08.829 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 39 | 5.82 | p_program_id=SCP0007, p_user_id=jaeuk.shin, p_sheet_name=BOD |
| 09:40:08.851 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 13.24 | Code=FromSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:40:08.939 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 81.38 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:40:08.994 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.3 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:40:09.004 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.29 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 09:40:09.226 | find | GSCM.SCP.Master.WSL | SCP0007_GET_COUNTRY_CITY | 3034 | 29.48 | p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_scm_site_id=, debug_mode=F |
| 09:40:19.086 | find | GSCM.SCP.Master.WSL | SCP0007_GET_BOD | 15317 | 9869.98 | p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_from_site=ST00-A,ST00-E,ST00-P,EG01_81-W,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,WA00-A,WA00-E,WA00-P,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,HQ11-E,HQ11-P,KR02239900_81-P,MI00_81-W,MI00-A,MI00-E,HD0 |
| 09:40:21.611 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 8.1 | p_menu_id=SCP0007, p_log_type=FIND, p_log_cnt=15317, p_db_time=10.636, p_ui_time=1.883, p_user_id=jaeuk.shin |

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
