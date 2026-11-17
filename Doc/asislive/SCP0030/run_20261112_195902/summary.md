# AS-IS 실측 요약 — SCP0030

- 실행: 2026-11-12 19:59:02.788 ~ 2026-11-12 20:00:09.260 · 계정 jaeuk.shin · 상태 OK
- 화면: BOD ITEM (GSCM.SCP.Master.UIL.SCP0030_BOD_ITEM)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:59:03.127 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.73 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:59:03.517 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 16751 | 384.25 | Code=Customer1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:59:03.679 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 30.68 | Code=ToSiteBOD1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:59:03.732 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 2662 | 28.07 | Code=ToSiteBOD1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:59:03.759 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.16 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:59:03.766 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 3.26 | Code=LookupCommon, Param1=TRANSPORT_MODE_CODE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:59:05.481 | load | GSCM.SCP.Master.WSL | SCP0130_GET_SEARCH_INFO | 46 | 1710.21 | p_division_id=81, p_site_id= |
| 19:59:05.816 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.17 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0030 |
| 19:59:05.839 | load | GSCM.BizService.WSL | SELECT * | 874 | 17.93 | USER_ID= |
| 19:59:08.375 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 37 | 52.76 | p_program_id=SCP0030, p_user_id=jaeuk.shin, p_sheet_name=BOD ITEM |
| 19:59:08.408 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 15.33 | Code=FromSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:59:08.500 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 78.41 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:59:08.523 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.21 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:59:08.560 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 14 | 5.12 | p_program_id=SCP0030, p_user_id=jaeuk.shin, p_sheet_name=Excluded Item |
| 19:59:09.549 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 959.0 | MenuID=BOD ITEM, CnntCode=0104001, UserID=jaeuk.shin |
| 19:59:09.618 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.45 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0030 |
| 19:59:11.424 | load | GSCM.SCP.Analysis.WSL | SCP0013_GET_PRODUCTION_PLAN_LINEBY | 0 | 809037.26 | p_division_id=81, p_operation_group=P, p_scm_site_id=, p_line_id=, p_model_id=, p_item_id=, p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_program_id=SCP0013, p_sheet_name=LINE, p_user_id=jaeuk.shin, p_electrode_type=None, p_nick_name=, d |
| 19:59:20.190 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 37 | 4.94 | p_program_id=SCP0030, p_user_id=jaeuk.shin, p_sheet_name=BOD ITEM |
| 19:59:20.208 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 97 | 13.47 | Code=FromSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:59:20.270 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 55.91 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:59:20.291 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.35 | Code=LookupCommon, Param1=INCOTERMS, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:59:37.054 | find | GSCM.SCP.Analysis.WSL | SCP0012_GET_PSI | 0 | 900007.81 | p_from_yyyymmdd=20260824, p_to_yyyymmdd=20270822, p_division_id=81, p_operation_group=P, p_From_Site=HQ07-P,HQ11-P,KR02239900_81-P,MI00-P,MI03-P,NA00-P,NB01-P,WA00-P, p_item_id=, p_electype=, p_program_id=None, p_plan_start_yyyymmdd=20260824, p_plan_type=MA, p_seq=3, p_user_id=None, p_cell_type_gr= |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| From Site | clbFromSite |  |
| To Site | clbToSite |  |
| Trans Mode | clbTransMode |  |
| Incoterms | clbIncoterms |  |
| Model | txtItemId |  |
| layoutControlItem5 | btnItemId |  |
| Nick Name | txtNickName |  |
| BOD Item Valid | cboValidYN |  |
| Div | clbDivision |  |
| Plan Group | clbPlanGroup |  |

## 그리드

- spdMain / BOD ITEM: 행 0 · 컬럼 38(보임 32) · 헤더 1단 · 고정 컬럼 12
- spdMain / Excluded Item: 행 0 · 컬럼 15(보임 14) · 헤더 2단 · 고정 컬럼 4

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
