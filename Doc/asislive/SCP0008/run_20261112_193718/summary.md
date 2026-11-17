# AS-IS 실측 요약 — SCP0008

- 실행: 2026-11-12 19:37:18.636 ~ 2026-11-12 19:38:25.228 · 계정 jaeuk.shin · 상태 OK
- 화면: Item Master (GSCM.SCP.Master.UIL.SCP0008_ItemMaster)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:37:19.027 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.43 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:37:28.557 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 9523.62 | Code=ITEM_MASTER_CLASS1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:37:28.779 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 186 | 211.36 | Code=ITEM_MASTER_CLASS21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:37:34.153 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 5368.74 | Code=ITEM_MASTER_ITEM_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:37:34.298 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.47 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0008 |
| 19:37:34.329 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.51 | USER_ID= |
| 19:37:34.833 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 50 | 283.91 | p_program_id=SCP0008, p_user_id=jaeuk.shin, p_sheet_name=Item Master |
| 19:37:37.807 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 2868.7 | MenuID=Item Master, CnntCode=0104001, UserID=jaeuk.shin |
| 19:37:38.021 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.33 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0008 |
| 19:38:24.454 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.25 | MenuID=Item Master, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Site | txtSite |  |
| SCM Site | txtScmSite |  |
| Class | txtClass |  |
| Class1 | clbClass1 |  |
| Class2 | clbClass2 |  |
| Material Type | clbMaterialType |  |
| Div | cboDivision |  |
| Material ID/Name* | txtMaterial | Y |

## 그리드

- spdMain / Item Master: 행 0 · 컬럼 51(보임 30) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-12 19:37:46.499 [GSCM] Material ID/Name 값은 필수 입력입니다 → default_button(id=1)
