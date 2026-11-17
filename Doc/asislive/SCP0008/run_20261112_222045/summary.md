# AS-IS 실측 요약 — SCP0008

- 실행: 2026-11-12 22:20:45.860 ~ 2026-11-12 22:21:46.636 · 계정 jaeuk.shin · 상태 OK
- 화면: Item Master (GSCM.SCP.Master.UIL.SCP0008_ItemMaster)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:20:46.203 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.78 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:20:52.934 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 6726.13 | Code=ITEM_MASTER_CLASS1, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:20:53.179 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 186 | 237.76 | Code=ITEM_MASTER_CLASS21, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 22:20:55.147 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 5 | 1957.01 | Code=ITEM_MASTER_ITEM_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 22:20:55.564 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.1 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0008 |
| 22:20:55.590 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.51 | USER_ID= |
| 22:20:56.225 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 50 | 418.56 | p_program_id=SCP0008, p_user_id=jaeuk.shin, p_sheet_name=Item Master |
| 22:20:56.985 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 645.19 | MenuID=Item Master, CnntCode=0104001, UserID=jaeuk.shin |
| 22:20:57.290 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.71 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0008 |
| 22:21:45.922 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.85 | MenuID=Item Master, CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 22:21:06.842 [GSCM] Material ID/Name 값은 필수 입력입니다 → default_button(id=1)
