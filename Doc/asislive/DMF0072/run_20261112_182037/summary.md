# AS-IS 실측 요약 — DMF0072

- 실행: 2026-11-12 18:20:37.862 ~ 2026-11-12 18:21:20.346 · 계정 jaeuk.shin · 상태 OK
- 화면: N: N Master Mapping (GSCM.DM.Master.UIL.DMF0072_NNMasterMapping)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:20:38.316 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 4.39 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0072 |
| 18:20:38.338 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.88 | USER_ID= |
| 18:20:38.493 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.67 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:20:39.237 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 692.46 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:20:40.028 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 689.08 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:20:40.789 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 696.87 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:20:40.899 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 19 | 3.5 | Code=SALES_PLAN_ITEM_ID, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:20:40.946 | load | GSCM.SCP.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 2 | 25.82 | p_lookup_type=DM_EDI_DATA_TYPE_CODE |
| 18:20:40.984 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 1 | 25.52 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0072, p_sheet_name=NNMasterMapping, p_division_id=81 |
| 18:20:41.111 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 83.82 | MenuID=N: N Master Mapping, CnntCode=0104001, UserID=jaeuk.shin |
| 18:20:41.226 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.76 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0072 |
| 18:20:49.342 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 1 | 4.0 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0072, p_sheet_name=NNMasterMapping, p_division_id=81 |
| 18:20:49.818 | find | GSCM.DM.Master.WSL | DMF0072_GET_NNMASTER_MAPPING | 766 | 282.06 | p_data_type_code=ALL, p_division_id=81, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_project_code=, p_item_id= |
| 18:21:19.663 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.09 | MenuID=N: N Master Mapping, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | clbDivisions |  |
| Project | umltProject |  |
| Team | clbTeam |  |
| layoutControlItem6 | btnProject |  |
| Model / Nickname | umltModel |  |
| End Customer | clbEndCustomer |  |
| layoutControlItem5 | btnModelType |  |
| Sales Site | clbSalesSite |  |
| DataType | clbDataTypeCode |  |

## 그리드

- spdMain / NNMasterMapping: 행 766 · 컬럼 2(보임 1) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
