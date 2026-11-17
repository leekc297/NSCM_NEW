# AS-IS 실측 요약 — SCP0020

- 실행: 2026-11-12 19:54:12.360 ~ 2026-11-12 19:54:29.085 · 계정 jaeuk.shin · 상태 OK
- 화면: Tact Time(OSP) (GSCM.SCP.Master.UIL.SCP0020_TactTime)
- 조회 결과:  · DB : 0.238s, UI : 0s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:54:12.750 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.74 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:54:12.760 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 5.12 | Code=PlantByDivisionOperNonOsp12, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:54:12.821 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1724 | 56.32 | Code=LineByOperation2, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:54:12.906 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1724 | 52.88 | Code=LineByOperation2, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:54:12.944 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 33 | 4.43 | Code=LineByPlantPacker, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:54:12.981 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.39 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0020 |
| 19:54:13.004 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.71 | USER_ID= |
| 19:54:13.118 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1724 | 51.76 | Code=LineByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:54:13.155 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 10 | 10.72 | Code=PlantByDivisionOperOsp3, Param1=40,81,82, Param2=P, Param3=Y, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:54:13.165 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 33 | 5.39 | Code=LineByPlantPacker, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 19:54:13.176 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.18 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:54:13.282 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 29 | 80.16 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Plant |
| 19:54:13.361 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1724 | 64.6 | Code=LineByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:54:13.410 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.66 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Packer |
| 19:54:13.421 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 33 | 3.96 | Code=LineByOperationOsp, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:54:13.449 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 4.41 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Tact Time Except |
| 19:54:13.510 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1724 | 51.92 | Code=LineByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:54:14.028 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 470.87 | MenuID=Tact Time(OSP), CnntCode=0104001, UserID=jaeuk.shin |
| 19:54:14.181 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.05 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0020 |
| 19:54:22.303 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.84 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Packer |
| 19:54:22.310 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 33 | 3.53 | Code=LineByOperationOsp, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:54:22.565 | find | GSCM.SystemMgmt.WSL | DMF0027_GET_DM_DYNAMIC_QUERYS | 1 | 202.22 | v_sql_text=SELECT MAX(tact_time) * 1.5 AS tact_time_max
                           FROM   SCP_MST_TACT_TIME_OSP with(nolock)
                           WHERE  division_id     = '82' |
| 19:54:22.712 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 131.98 | p_menu_id=SCP0020, p_log_type=FIND, p_log_cnt=, p_db_time=0.238, p_ui_time=0, p_user_id=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Plant Site | clbPlantSite |  |
| Div* | cboDivision | Y |
| Line | clbLine |  |
| Model | txtItemId |  |
| layoutControlItem4 | btnItemId |  |
| Valid | cboValid |  |
| Operation Group* | cboOperationGroup | Y |

## 그리드

- spdMain / Plant: 행 0 · 컬럼 30(보임 23) · 헤더 1단 · 고정 컬럼 7
- spdMain / Packer: 행 0 · 컬럼 19(보임 14) · 헤더 1단 · 고정 컬럼 5
- spdExcept / Tact Time Except: 행 0 · 컬럼 28(보임 16) · 헤더 1단 · 고정 컬럼 7

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
