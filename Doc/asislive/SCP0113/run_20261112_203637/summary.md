# AS-IS 실측 요약 — SCP0113

- 실행: 2026-11-12 20:36:37.055 ~ 2026-11-12 20:37:32.628 · 계정 jaeuk.shin · 상태 OK
- 화면: Long-term stock MGMT (GSCM.SCP.Report.UIL.SCP0113_LongTermStockMgmt)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:36:37.461 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 27.67 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:36:37.591 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 28 | 122.41 | Code=PlantByGroup1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:36:37.710 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.09 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0113 |
| 20:36:37.736 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.84 | USER_ID= |
| 20:36:38.271 | load | GSCM.BizService.WSL | SCP0084_GET_COMBOBOX_DATA | 15 | 384.4 | p_lookup_type=SCM_LGTM_OCCR_RSN_CD, p_valid_yn=Y |
| 20:36:38.431 | load | GSCM.BizService.WSL | SCP0084_GET_COMBOBOX_DATA | 13 | 139.98 | p_lookup_type=SCM_LGTM_EXHT_TP_CD, p_valid_yn=Y |
| 20:36:38.829 | load | GSCM.BizService.WSL | SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | 8 | 380.38 |  |
| 20:36:39.039 | load | GSCM.BizService.WSL | SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA | 15 | 116.95 | p_lookup_type=SCM_LGTM_CODE_NAME_FOR_REPORT, p_segment1=SRCE_TP_CD, p_segment2=EOH |
| 20:36:45.017 | load | GSCM.BizService.WSL | SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE | 11 | 5942.04 |  |
| 20:36:46.249 | load | GSCM.BizService.WSL | SCP0113_GET_BASE_MONTH | 1 | 1186.57 | p_plan_date=20260914 |
| 20:36:46.778 | load | GSCM.SCP.Analysis.WSL | SCP0101_GET_INVENTORY_TREND | 33469 | 807898.26 | p_yyyymm=202609, p_division_id=81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG, p_plant_id=, p_item_id=, debug_mode=F |
| 20:36:46.969 | load | GSCM.BizService.WSL | SCP0113_GET_LGTM_MONTHLY_QTY_INPUT_PERIOD | 1 | 704.47 |  |
| 20:36:47.266 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 282.6 | p_program_id=SCP0113, p_user_id=jaeuk.shin, p_sheet_name=Long Term Stock Management |
| 20:36:47.313 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 5.56 | p_program_id=SCP0113, p_user_id=jaeuk.shin, p_sheet_name=Long Term Stock Management |
| 20:36:47.364 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 68 | 6.06 | p_program_id=SCP0113, p_user_id=jaeuk.shin, p_sheet_name=BOH Ending Inventory |
| 20:36:47.403 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 5.1 | p_program_id=SCP0113, p_user_id=jaeuk.shin, p_sheet_name=PSI Detail |
| 20:36:47.414 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 4.28 | p_program_id=SCP0113, p_user_id=jaeuk.shin, p_sheet_name=PSI Detail |
| 20:36:47.431 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 59 | 7.5 | p_program_id=SCP0113, p_user_id=jaeuk.shin, p_sheet_name=BOH Long-Term Stock |
| 20:36:48.964 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 1492.19 | MenuID=Long-term stock MGMT, CnntCode=0104001, UserID=jaeuk.shin |
| 20:36:49.306 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0113 |
| 20:36:55.492 | load | GSCM.SCM.Master.WSL | SCP0080_GET_GROUP_CODE_MANAGEMENT | 4526 | 1517058.72 | p_division_id=81, p_operation_id=A3000,A7000,A8000,A8200,A8210,A9000,F5300,F6000,F6200,F7000,F7100,F7200,F7300,P5000,P5500,P9500,PL500, p_model_id=, p_nickname=, p_check_fcst=N, p_check_production=N, p_check_active=N, p_check_bom=N, p_user_id=jaeuk.shin, debug_mode=F |
| 20:37:01.045 | find | GSCM.BizService.WSL | SCP0113_GET_BASE_MONTH | 1 | 15.16 | p_plan_date=20260914 |
| 20:37:01.062 | find | GSCM.BizService.WSL | SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | 8 | 2.93 |  |
| 20:37:01.071 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 4.8 | p_program_id=SCP0113, p_user_id=jaeuk.shin, p_sheet_name=Long Term Stock Management |
| 20:37:01.101 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 46 | 4.5 | p_program_id=SCP0113, p_user_id=jaeuk.shin, p_sheet_name=Long Term Stock Management |
| 20:37:01.164 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 32.76 | p_program_id=SCP0113, p_user_id=jaeuk.shin, p_sheet_name=PSI Detail |
| 20:37:01.179 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 13 | 3.74 | p_program_id=SCP0113, p_user_id=jaeuk.shin, p_sheet_name=PSI Detail |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plan date* | cboPlanDate | Y |
| Material | txtItemId |  |
| 발생유형 | cboCreationType |  |
| Upload | btnImport |  |
| layoutControlItem10 | btnColumn |  |
| EOH Month | monthPicker |  |
| Item Type | clbItemType |  |
| Div | cboDivision |  |
| Plant | clbPlant |  |
| layoutControlItem13 | usrLayoutControl4 |  |
| Group Code | txtGroupCode |  |
| layoutControlItem8 | lblBaseMonth |  |
| PSI Export | btnDownloadExcel |  |
| Process LongTerm | btnProcessLongTerm |  |

## 그리드

- spdMain / Long Term Stock Management: 행 0 · 컬럼 52(보임 51) · 헤더 2단 · 고정 컬럼 24
- spdSub / BOH Ending Inventory: 행 0 · 컬럼 69(보임 51) · 헤더 1단 · 고정 컬럼 10
- spdSub / PSI Detail: 행 0 · 컬럼 28(보임 27) · 헤더 1단 · 고정 컬럼 0
- spdSub / BOH Long-Term Stock: 행 0 · 컬럼 60(보임 49) · 헤더 1단 · 고정 컬럼 8

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
