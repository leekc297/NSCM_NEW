# AS-IS 실측 요약 — SCP0050

- 실행: 2026-11-13 00:18:50.158 ~ 2026-11-13 00:19:29.739 · 계정 jaeuk.shin · 상태 OK
- 화면: CAPA PIC (GSCM.SCP.Master.UIL.SCP0050_CAPA_PIC)
- 조회 결과: Total : 39,547 · DB : 19.145s, UI : 0.935s · 완료 판단 status
- 조건: 시나리오 {"rule": "recent", "set": []}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 00:18:50.496 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.53 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:50.503 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 4.96 | Code=MDMCategoryId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:50.510 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 3.83 | Code=MDMKeyIdByCategory, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:18:50.517 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.42 | Code=SiteFP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:50.523 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 2.91 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:50.559 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0050 |
| 00:18:50.583 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.85 | USER_ID= |
| 00:18:50.864 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 169.44 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 00:18:50.869 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.53 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 00:18:50, END_TIME=2026-11-13 00:18:50, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113001850_693, PA |
| 00:18:51.294 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 5 | 372.6 | Code=ShopGroupId, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:18:51.637 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 8 | 337.86 | Code=PlantByGroup, Param1=81, Param2=A,E,F,B,P, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:18:51.650 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 44 | 4.59 | Code=BuildingByShopGroupId, Param1=81, Param2=, Param3=A,E,F,B,P, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 00:18:52.198 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 406 | 536.59 | Code=LineByOperationPlantId, Param1=81, Param2=, Param3=, Param4=A,E,F,B,P, Param5=, Param6=, TimeZone=AS054 |
| 00:18:54.815 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21 | 2527.27 | Code=OperationByLine, Param1=81, Param2=, Param3=, Param4=A1A02,A1A02-1,A1A02-2,A1A03,A1A04,A1A05,A1A06,A1A07,A1A08,A1AP1,A1AP2,A1AP3,A1AV1,A1AZ1,A1J04,A1J05,A1J06,A1J07,A1J08,A1J2A,A2A10,A2A11,A2A13,A2A14,A2AP1,A2AP3,A2AP4,A2AP5,A2AP5,A2AV1,A2AZ1,A2J10,A2J11,A2J13,A2J14,A2JP1,A3A01,A3A02,A3A03,A3A0 |
| 00:18:54.864 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 35 | 30.95 | p_program_id=SCP0050, p_user_id=jaeuk.shin, p_sheet_name=MDM Auth Management |
| 00:18:54.873 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.72 | Code=SiteFP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:18:55.065 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 170.36 | MenuID=CAPA PIC, CnntCode=0104001, UserID=jaeuk.shin |
| 00:18:55.129 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.64 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0050 |
| 00:19:03.167 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 35 | 4.32 | p_program_id=SCP0050, p_user_id=jaeuk.shin, p_sheet_name=MDM Auth Management |
| 00:19:03.177 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.25 | Code=SiteFP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 00:19:21.409 | find | GSCM.SCP.Master.WSL | SCP0050_GET_CAPA_PIC | 39547 | 18215.32 | p_division_id=81, p_plant_id=, p_group_id=A,E,F,B,P, p_factory_id=, p_line_id=A1A02,A1A02-1,A1A02-2,A1A03,A1A04,A1A05,A1A06,A1A07,A1A08,A1AP1,A1AP2,A1AP3,A1AV1,A1AZ1,A1J04,A1J05,A1J06,A1J07,A1J08,A1J2A,A2A10,A2A11,A2A13,A2A14,A2AP1,A2AP3,A2AP4,A2AP5,A2AP5,A2AV1,A2AZ1,A2J10,A2J11,A2J13,A2J14,A2JP1,A3 |
| 00:19:23.305 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 28.32 | p_menu_id=SCP0050, p_log_type=FIND, p_log_cnt=39547, p_db_time=19.145, p_ui_time=0.935, p_user_id=jaeuk.shin |
| 00:19:28.470 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.26 | MenuID=CAPA PIC, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Div | cboDivision |  |
| Category | cboCategoryId |  |
| Manager | txtManager |  |
| Key | cboKeyId |  |
| Group | clbGroup |  |
| Plant | clbPlant |  |
| Building | clbBuilding |  |
| Line | clbLine |  |
| Operation | clbOperation |  |
| Excel | btnExcelImport |  |

## 그리드

- spdMain / MDM Auth Management: 행 39547 · 컬럼 37(보임 32) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
