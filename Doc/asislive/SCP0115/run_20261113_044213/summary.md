# AS-IS 실측 요약 — SCP0115

- 실행: 2026-11-13 04:42:13.945 ~ 2026-11-13 04:43:25.366 · 계정 jaeuk.shin · 상태 OK
- 화면: Policy-based Inv. Mgmt. (GSCM.SCP.Report.UIL.SCP0115_PolicyInvMgmt)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "cboDivision", "check": "0", "only": "1"}, {"name": "cboDivision", "check": "1", "only": "1"}, {"name": "cboDivision", "check": "2", "only": "1"}, {"name": "cboDivision", "check": "3", "only": "1"}, {"name": "cboDivision", "check": "4", "only": "1"}, {"name": "cboDivision", "check": "5", "only": "1"}, {"name": "cboDivision", "check": "6", "only": "1"}, {"name": "cboDivision", "check": "7", "only": "1"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:42:14.428 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 60 | 48.08 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:42:14.437 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 60 | 3.57 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:42:14.463 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 20.92 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:42:15.023 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 28 | 553.0 | Code=PlantByGroup1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 04:42:15.078 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.22 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0115 |
| 04:42:15.119 | load | GSCM.BizService.WSL | SELECT * | 874 | 35.78 | USER_ID= |
| 04:42:15.265 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_COMBOBOX_DATA | 2 | 26.07 | p_lookup_type=SCM_LGTM_PCY_INV_PLAN_TYPE, p_valid_yn=Y |
| 04:42:15.274 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_COMBOBOX_DATA | 12 | 5.29 | p_lookup_type=SCM_LGTM_PCY_INV_OCCR_RSN_CD, p_valid_yn=Y |
| 04:42:15.284 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_COMBOBOX_DATA | 9 | 6.11 | p_lookup_type=SCM_LGTM_PCY_EXHT_TP_CD, p_valid_yn=Y |
| 04:42:15.293 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_POLICY_INV_MGMT_PLAN_DATE | 0 | 4.97 |  |
| 04:42:15.419 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 87.08 | p_division_id=ALL, p_plan_cycle=WEEKLY, p_from_date=20261113, p_offset_month=12, p_timezone=AS054 |
| 04:42:15.441 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 6.05 | p_division_id=, p_plan_cycle=WEEKLY, p_from_date=20261113, p_offset_month=12, p_timezone=AS054 |
| 04:42:15.478 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 23.8 | p_program_id=SCP0115, p_user_id=jaeuk.shin, p_sheet_name=Policy Inv Management |
| 04:42:15.612 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 86.42 | MenuID=Policy-based Inv. Mgmt., CnntCode=0104001, UserID=jaeuk.shin |
| 04:42:15.698 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 26.63 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0115 |
| 04:43:24.684 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.92 | MenuID=Policy-based Inv. Mgmt., CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-13 04:42:46.715 [GSCM] Plant Date* 값은 필수 입력입니다 → default_button(id=1)
