# AS-IS 실측 요약 — SCP0115

- 실행: 2026-11-12 22:55:06.919 ~ 2026-11-12 22:56:10.358 · 계정 jaeuk.shin · 상태 OK
- 화면: Policy-based Inv. Mgmt. (GSCM.SCP.Report.UIL.SCP0115_PolicyInvMgmt)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:55:07.334 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 60 | 4.38 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:55:07.349 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 60 | 4.91 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:55:07.384 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 22.47 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:55:09.610 | load | GSCM.SCP.Analysis.WSL | SCP0111_GET_INTEGRATION_PSI | 1712 | 53864.05 | p_division_id=81, p_plan_start_yyyymmdd=20260817, p_plan_type=, p_seq=, p_from_yyyymm=202608, p_to_yyyymm=202701, p_nick_name=, p_cellitem_id=, p_item_id=, p_qty_yn=N |
| 22:55:16.277 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 28 | 8877.18 | Code=PlantByGroup1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:55:17.099 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 6.1 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0115 |
| 22:55:17.141 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.13 | USER_ID= |
| 22:55:17.967 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_COMBOBOX_DATA | 2 | 531.35 | p_lookup_type=SCM_LGTM_PCY_INV_PLAN_TYPE, p_valid_yn=Y |
| 22:55:17.979 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_COMBOBOX_DATA | 12 | 4.63 | p_lookup_type=SCM_LGTM_PCY_INV_OCCR_RSN_CD, p_valid_yn=Y |
| 22:55:17.991 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_COMBOBOX_DATA | 9 | 3.39 | p_lookup_type=SCM_LGTM_PCY_EXHT_TP_CD, p_valid_yn=Y |
| 22:55:18.212 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_POLICY_INV_MGMT_PLAN_DATE | 0 | 204.77 |  |
| 22:55:18.319 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 4.92 | p_division_id=ALL, p_plan_cycle=WEEKLY, p_from_date=20261112, p_offset_month=12, p_timezone=AS054 |
| 22:55:18.346 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 4.83 | p_division_id=, p_plan_cycle=WEEKLY, p_from_date=20261112, p_offset_month=12, p_timezone=AS054 |
| 22:55:18.499 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 137.2 | p_program_id=SCP0115, p_user_id=jaeuk.shin, p_sheet_name=Policy Inv Management |
| 22:55:18.962 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 259.02 | MenuID=Policy-based Inv. Mgmt., CnntCode=0104001, UserID=jaeuk.shin |
| 22:55:19.178 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.8 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0115 |
| 22:56:09.328 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.39 | MenuID=Policy-based Inv. Mgmt., CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Plant | clbPlant |  |
| layoutControlItem3 | usrLayoutControl1 |  |
| layoutControlItem4 | usrLayoutControl3 |  |
| Upload | btnImport |  |
| layoutControlItem2 | btnColumn |  |
| Plant Date* | cboPlanDate | Y |
| Material | txtItemId |  |
| Period* | dCalendar | Y |
| layoutControlItem8 | usrLayoutControl4 |  |
| Category | cboCategory |  |

## 그리드

- spdMain / Policy Inv Management: 행 0 · 컬럼 23(보임 22) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 22:55:29.803 [GSCM] Plant Date* 값은 필수 입력입니다 → default_button(id=1)
