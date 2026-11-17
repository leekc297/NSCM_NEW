# AS-IS 실측 요약 — SCP0020

- 실행: 2026-11-14 10:59:44.104 ~ 2026-11-14 11:02:09.935 · 계정 jaeuk.shin · 상태 OK
- 화면: Tact Time(OSP) (GSCM.SCP.Master.UIL.SCP0020_TactTime)
- 조회 결과:  · DB : 0.013s, UI : 0s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 11:01:50.171 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 14 | 21.83 | Code=Division, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 11:01:50.191 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 68 | 5.66 | Code=PlantByDivisionOperNonOsp12, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 11:01:50.249 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1724 | 53.28 | Code=LineByOperation2, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 11:01:50.328 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP_ALL | 1724 | 54.18 | Code=LineByOperation2, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 11:01:50.370 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 33 | 3.83 | Code=LineByPlantPacker, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 11:01:51.157 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.49 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0020 |
| 11:01:51.193 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.81 | USER_ID= |
| 11:01:51.522 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1724 | 51.79 | Code=LineByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 11:01:51.552 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 10 | 4.48 | Code=PlantByDivisionOperOsp3, Param1=40,81,82, Param2=P, Param3=Y, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 11:01:51.561 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 33 | 4.2 | Code=LineByPlantPacker, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 11:01:51.598 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.86 | Code=LookupCommon, Param1=OPERATION_GROUP, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 11:01:51.702 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 29 | 4.17 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Plant |
| 11:01:51.781 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1724 | 51.11 | Code=LineByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 11:01:51.827 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 3.87 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Packer |
| 11:01:51.848 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 33 | 3.6 | Code=LineByOperationOsp, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 11:01:51.875 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 3.77 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Tact Time Except |
| 11:01:51.937 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1724 | 50.73 | Code=LineByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 11:01:52.202 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.4 | MenuID=Tact Time(OSP), CnntCode=0104001, UserID=jaeuk.shin |
| 11:01:52.343 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.61 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0020 |
| 11:02:01.694 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.76 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Packer |
| 11:02:01.705 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 33 | 4.3 | Code=LineByOperationOsp, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 11:02:01.751 | find | GSCM.SystemMgmt.WSL | DMF0027_GET_DM_DYNAMIC_QUERYS | 1 | 6.42 | v_sql_text=SELECT MAX(tact_time) * 1.5 AS tact_time_max
                           FROM   SCP_MST_TACT_TIME_OSP with(nolock)
                           WHERE  division_id     = '82' |
| 11:02:01.772 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 11.06 | p_menu_id=SCP0020, p_log_type=FIND, p_log_cnt=, p_db_time=0.013, p_ui_time=0, p_user_id=jaeuk.shin |
| 11:02:03.818 | find | GSCM.SCP.Master.WSL | SCP0020_GET_TACT_TIME_OSP | 855 | 2093.49 | p_division_id=82, p_plant_site_id=, p_line_id=, p_operation_group_id=P, p_item_id=, debug_mode=F |
| 11:02:03.979 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 27 | 3.95 | p_program_id=SCP0020, p_user_id=jaeuk.shin, p_sheet_name=Tact Time Except |
| 11:02:04.034 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1724 | 50.25 | Code=LineByOperation, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 11:02:04.096 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 23.44 | p_menu_id=SCP0020, p_log_type=FIND, p_log_cnt=855, p_db_time=2.106, p_ui_time=0.219, p_user_id=jaeuk.shin |
| 11:02:09.063 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.87 | MenuID=Tact Time(OSP), CnntCode=0104002, UserID=jaeuk.shin |

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
- spdMain / Packer: 행 855 · 컬럼 20(보임 14) · 헤더 1단 · 고정 컬럼 6
- spdExcept / Tact Time Except: 행 0 · 컬럼 28(보임 16) · 헤더 1단 · 고정 컬럼 7
