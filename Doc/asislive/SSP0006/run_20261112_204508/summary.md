# AS-IS 실측 요약 — SSP0006

- 실행: 2026-11-12 20:45:08.146 ~ 2026-11-12 20:45:59.369 · 계정 jaeuk.shin · 상태 OK
- 화면: Plan Problem (SSP) (GSCM.SSP.Plan.UIL.SSP0006_Plan_Problem)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:45:08.501 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 12 | 3.4 | Code=MyDivisionInEE, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:45:08.607 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 101.85 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:45:08.662 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.16 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0006 |
| 20:45:08.686 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.2 | USER_ID= |
| 20:45:08.869 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 4.93 |  |
| 20:45:08.953 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 73.2 | Code=LookupCommon, Param1=PROBLEM_LIST, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:45:08.966 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 4.13 | Code=PlantSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:45:08.983 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1294 | 13.2 | Code=SaleSiteByDivision, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:45:10.786 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 1651.94 | Code=PlanDateShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:45:10.929 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 137.41 | Code=PlanTypeShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:45:11.074 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 139.67 | Code=PlanSeqShip, Param1=40, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:45:11.087 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 3.05 | p_from_date=, p_offset_day=112, p_timezone=AS054 |
| 20:45:11.125 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 19 | 24.43 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Demand |
| 20:45:11.149 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 137 | 11.06 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270304 |
| 20:45:11.205 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 16 | 3.84 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Pegging Info |
| 20:45:11.218 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 6 | 3.63 | p_program_id=SSP0006, p_user_id=jaeuk.shin, p_sheet_name=Plan Problem |
| 20:45:11.486 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 249.3 | MenuID=Plan Problem (SSP), CnntCode=0104001, UserID=jaeuk.shin |
| 20:45:11.568 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.79 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0006 |
| 20:45:58.662 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.65 | MenuID=Plan Problem (SSP), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div* | cboDivision | Y |
| Seq* | cboPlanSeq | Y |
| Plant Site | clbPlantSite |  |
| Sales Site | clbSalesSite |  |
| Problem | clbProblem |  |
| Plan date* | cboPlanDate | Y |
| Project | txtProject |  |
| Model | txtItemId |  |
| layoutControlItem2 | btnItem_Id |  |
| Plan type* | cboPlanType | Y |
| layoutControlItem4 | btnProject |  |
| Bucket | cboBucketType |  |
| Period* | drpPeriod | Y |
| Electrode | clbElectrode |  |
| layoutControlItem8 | chkSum |  |

## 그리드

- spdMain / Demand: 행 0 · 컬럼 157(보임 121) · 헤더 3단 · 고정 컬럼 20
- spdPeggingInfo / Pegging Info: 행 0 · 컬럼 17(보임 11) · 헤더 1단 · 고정 컬럼 0
- spdPlanProblem / Plan Problem: 행 0 · 컬럼 7(보임 6) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 20:45:20.528 [GSCM] Seq* 값은 필수 입력입니다 → default_button(id=1)
