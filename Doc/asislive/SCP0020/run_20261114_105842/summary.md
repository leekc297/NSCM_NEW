# AS-IS 실측 요약 — SCP0020

- 실행: 2026-11-14 10:58:42.545 ~ 2026-11-14 10:59:28.514 · 계정 jaeuk.shin · 상태 OK
- 화면: Tact Time(OSP) (GSCM.SCP.Master.UIL.SCP0020_TactTime)
- 조회 결과:  · DB : 0.078s, UI : 0s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 10:59:08.506 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.36 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 10:59:08.521 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 4.49 | Code=PlantByDivisionOperNonOsp12, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 10:59:08.582 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1724 | 55.45 | Code=LineByOperation2, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 10:59:08.660 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1724 | 53.83 | Code=LineByOperation2, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 10:59:08.713 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 33 | 3.98 | Code=LineByPlantPacker, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 10:59:09.610 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.12 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0020 |
| 10:59:09.648 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.61 | USER_ID= |
| 10:59:09.982 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1724 | 50.67 | Code=LineByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 10:59:10.009 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 10 | 4.51 | Code=PlantByDivisionOperOsp3, Param1=40,81,82, Param2=P, Param3=Y, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 10:59:10.019 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 33 | 4.01 | Code=LineByPlantPacker, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 10:59:10.059 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.47 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 10:59:10.195 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 29 | 35.12 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Plant |
| 10:59:10.261 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1724 | 51.38 | Code=LineByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 10:59:10.327 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 5.24 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Packer |
| 10:59:10.340 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 33 | 3.6 | Code=LineByOperationOsp, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 10:59:10.366 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 5.44 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Tact Time Except |
| 10:59:10.425 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1724 | 50.62 | Code=LineByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 10:59:10.806 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 130.45 | MenuID=Tact Time(OSP), CnntCode=0104001, UserID=jaeuk.shin |
| 10:59:10.957 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 27.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0020 |
| 10:59:20.162 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 5.42 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Packer |
| 10:59:20.173 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 33 | 3.65 | Code=LineByOperationOsp, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 10:59:20.284 | find | GSCM.SystemMgmt.WSL | DMF0027_GET_DM_DYNAMIC_QUERYS | 1 | 77.78 | v_sql_text=SELECT MAX(tact_time) * 1.5 AS tact_time_max
                           FROM   SCP_MST_TACT_TIME_OSP with(nolock)
                           WHERE  division_id     = '82' |
| 10:59:20.413 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 114.73 | p_menu_id=SCP0020, p_log_type=FIND, p_log_cnt=, p_db_time=0.078, p_ui_time=0, p_user_id=jaeuk.shin |

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
