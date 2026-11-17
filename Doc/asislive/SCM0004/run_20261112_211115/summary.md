# AS-IS 실측 요약 — SCM0004

- 실행: 2026-11-12 21:11:15.232 ~ 2026-11-12 21:11:56.744 · 계정 jaeuk.shin · 상태 OK
- 화면: UI Category Setup (GSCM.SCM.Master.UIL.SCM0004_UICategorySetup)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:11:15.611 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.39 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0203 |
| 21:11:15.638 | load | GSCM.BizService.WSL | SELECT * | 874 | 22.01 | USER_ID= |
| 21:11:15.771 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 25.84 | Code=DATA_SORT_METHOD, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:11:15.831 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 54.88 | Code=DEFAULT_FLAG, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:11:15.863 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 27.72 | Code=CELL_CONTROL_OBJECT_TYPE_CODE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:11:15.950 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 81.63 | Code=HORIZONTAL_ALIGN_CODE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 21:11:16.359 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 342.87 | MenuID=UI Category Setup, CnntCode=0104001, UserID=jaeuk.shin |
| 21:11:16.450 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0203 |
| 21:11:26.295 | find | GSCM.SCM.Master.WSL | SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | 14485 | 1217.03 | p_program_id=, p_sheet_name=, p_column_name=, p_colmum_lavel_name=, p_default_flag=, p_valid_yn=Y |
| 21:11:55.846 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.64 | MenuID=UI Category Setup, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Program ID | txtProgramID |  |
| Sheet Name | txtSheetName |  |
| Column Name | txtColumnName |  |
| Column Label Name | txtColumnLavelName |  |
| Valid | cboValid |  |

## 그리드

- spdMain / Column: 행 14485 · 컬럼 33(보임 32) · 헤더 1단 · 고정 컬럼 5
- spdMain / Measure: 행 0 · 컬럼 27(보임 26) · 헤더 1단 · 고정 컬럼 5

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
