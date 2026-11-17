# AS-IS 실측 요약 — SCP0087

- 실행: 2026-11-12 20:13:44.232 ~ 2026-11-12 20:13:59.686 · 계정 jaeuk.shin · 상태 OK
- 화면: MDM Class Master (GSCM.SCP.Master.UIL.SCP0087_MDMClassMaster)
- 조회 결과: Total : 325 · DB : 0.637s, UI : 0.005s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:13:44.538 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.88 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0087 |
| 20:13:44.562 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.19 | USER_ID= |
| 20:13:44.665 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 50.25 | p_program_id=SCP0087, p_user_id=jaeuk.shin, p_sheet_name=MDM Class Master |
| 20:13:45.002 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 315.55 | MenuID=MDM Class Master, CnntCode=0104001, UserID=jaeuk.shin |
| 20:13:45.049 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.23 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0087 |
| 20:13:52.690 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 23 | 4.49 | p_program_id=SCP0087, p_user_id=jaeuk.shin, p_sheet_name=MDM Class Master |
| 20:13:53.322 | find | GSCM.SCP.Master.WSL | SCP0087_GET_MDM_CLASS_MASTER | 325 | 621.26 | p_class_id=, p_class_name=, p_use_flag=Y, debug_mode=F |
| 20:13:53.360 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 16.62 | p_menu_id=SCP0087, p_log_type=FIND, p_log_cnt=325, p_db_time=0.637, p_ui_time=0.005, p_user_id=jaeuk.shin |
| 20:13:58.989 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.75 | MenuID=MDM Class Master, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Class ID | txtClassId |  |
| Class Name | txtClassName |  |
| Use Flag | cboUseFlag |  |

## 그리드

- spdMain / MDM Class Master: 행 325 · 컬럼 24(보임 23) · 헤더 2단 · 고정 컬럼 7

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
