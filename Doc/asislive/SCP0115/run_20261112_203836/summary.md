# AS-IS 실측 요약 — SCP0115

- 실행: 2026-11-12 20:38:36.620 ~ 2026-11-12 20:39:26.516 · 계정 jaeuk.shin · 상태 OK
- 화면: Policy-based Inv. Mgmt. (GSCM.SCP.Report.UIL.SCP0115_PolicyInvMgmt)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:38:36.985 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 60 | 4.96 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:38:36.993 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 60 | 4.58 | Code=Company, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:38:37.018 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.2 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:38:37.098 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 28 | 76.14 | Code=PlantByGroup1, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:38:37.152 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.96 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0115 |
| 20:38:37.175 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.5 | USER_ID= |
| 20:38:37.460 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_COMBOBOX_DATA | 2 | 194.72 | p_lookup_type=SCM_LGTM_PCY_INV_PLAN_TYPE, p_valid_yn=Y |
| 20:38:37.470 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_COMBOBOX_DATA | 12 | 3.31 | p_lookup_type=SCM_LGTM_PCY_INV_OCCR_RSN_CD, p_valid_yn=Y |
| 20:38:37.477 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_COMBOBOX_DATA | 9 | 3.12 | p_lookup_type=SCM_LGTM_PCY_EXHT_TP_CD, p_valid_yn=Y |
| 20:38:37.869 | load | GSCM.SCP.Analysis.WSL | SCP0115_GET_POLICY_INV_MGMT_PLAN_DATE | 0 | 376.45 |  |
| 20:38:37.972 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 4.95 | p_division_id=ALL, p_plan_cycle=WEEKLY, p_from_date=20261112, p_offset_month=12, p_timezone=AS054 |
| 20:38:37.997 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_MONTH_PERIOD | 1 | 4.86 | p_division_id=, p_plan_cycle=WEEKLY, p_from_date=20261112, p_offset_month=12, p_timezone=AS054 |
| 20:38:38.105 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 22 | 94.36 | p_program_id=SCP0115, p_user_id=jaeuk.shin, p_sheet_name=Policy Inv Management |
| 20:38:38.787 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 622.09 | MenuID=Policy-based Inv. Mgmt., CnntCode=0104001, UserID=jaeuk.shin |
| 20:38:38.871 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.66 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0115 |
| 20:39:06.776 | find | GSCM.SCP.Master.WSL | SCP0107_GET_CAPA_TEEP_ELTR | 3429 | 519197.94 | p_version=202609, p_version_seq=1, p_division_id=, p_site_id=A001,A002,A003,A004,A007,A009, p_plant_id=G676,GM00,GM01,HD00,HG00,HM00,HQ06,HQ07,HQ10,MI00,MI01,MI02,NA00,NB01,NJ01,ST00,WA00,WA01, p_factory_id=E3,E4,E6,E7,E9,EA,EB,EC,ED,EE,EF,EH,EI,EJ,EK,EN,EO,EP,EQ,ER,ES,ET,EU,EV,EW,EX, p_line_id=DUM_ |
| 20:39:25.830 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 8.15 | MenuID=Policy-based Inv. Mgmt., CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 20:38:47.549 [GSCM] Plant Date* 값은 필수 입력입니다 → default_button(id=1)
