# AS-IS 실측 요약 — SCP0050

- 실행: 2026-11-12 20:06:51.294 ~ 2026-11-12 20:07:44.145 · 계정 jaeuk.shin · 상태 OK
- 화면: CAPA PIC (GSCM.SCP.Master.UIL.SCP0050_CAPA_PIC)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:06:51.637 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 3.68 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:06:51.734 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 8 | 93.32 | Code=MDMCategoryId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:06:51.746 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 30 | 5.55 | Code=MDMKeyIdByCategory, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:06:51.756 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.61 | Code=SiteFP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:06:51.766 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 3 | 3.95 | Code=LookupCommon, Param1=ELECTRODE_TYPE, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:06:51.809 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 2.89 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0050 |
| 20:06:51.832 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.66 | USER_ID= |
| 20:06:54.885 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 2932.18 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 20:06:54.892 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 6.35 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 20:06:51, END_TIME=2026-11-12 20:06:54, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112200651_95, PAR |
| 20:06:55.523 | load | GSCM.FP_Common | SELECT * | 351 | 13.2 | USER_ID= |
| 20:06:55.770 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 247.06 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 20:06:57.708 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 5 | 1886.33 | Code=ShopGroupId, Param1=81, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:06:58.051 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 8 | 332.93 | Code=PlantByGroup, Param1=81, Param2=A,E,F,B,P, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:06:58.068 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 44 | 6.76 | Code=BuildingByShopGroupId, Param1=81, Param2=, Param3=A,E,F,B,P, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:06:59.813 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 406 | 1724.72 | Code=LineByOperationPlantId, Param1=81, Param2=, Param3=, Param4=A,E,F,B,P, Param5=, Param6=, TimeZone=AS054 |
| 20:07:03.561 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 21 | 3683.13 | Code=OperationByLine, Param1=81, Param2=, Param3=, Param4=A1A02,A1A02-1,A1A02-2,A1A03,A1A04,A1A05,A1A06,A1A07,A1A08,A1AP1,A1AP2,A1AP3,A1AV1,A1AZ1,A1J04,A1J05,A1J06,A1J07,A1J08,A1J2A,A2A10,A2A11,A2A13,A2A14,A2AP1,A2AP3,A2AP4,A2AP5,A2AP5,A2AV1,A2AZ1,A2J10,A2J11,A2J13,A2J14,A2JP1,A3A01,A3A02,A3A03,A3A0 |
| 20:07:04.416 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 35 | 824.15 | p_program_id=SCP0050, p_user_id=jaeuk.shin, p_sheet_name=MDM Auth Management |
| 20:07:04.431 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.85 | Code=SiteFP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:07:04.900 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 442.59 | MenuID=CAPA PIC, CnntCode=0104001, UserID=jaeuk.shin |
| 20:07:04.962 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.91 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SCP0050 |
| 20:07:12.893 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 35 | 4.47 | p_program_id=SCP0050, p_user_id=jaeuk.shin, p_sheet_name=MDM Auth Management |
| 20:07:12.902 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 9 | 3.81 | Code=SiteFP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |

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

- spdMain / MDM Auth Management: 행 0 · 컬럼 36(보임 32) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
