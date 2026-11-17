# AS-IS 실측 요약 — SSP0045

- 실행: 2026-11-12 20:59:01.356 ~ 2026-11-12 20:59:43.796 · 계정 jaeuk.shin · 상태 OK
- 화면: Shipment Request SEMI (GSCM.SSP.Plan.UIL.SSP0045_ShipmentRequest)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 20:59:01.976 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.35 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0045 |
| 20:59:02.003 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.88 | USER_ID= |
| 20:59:02.153 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 14.68 | LOGTYPE=SpeedUp, NOTE=SSP0045
division_id_changed
start
, USER_ID=jaeuk.shin |
| 20:59:02.242 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 88.65 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:59:02.684 | load | GSCM.BizService.WSL | DECLARE @TResult TABLE( | 12 | 425.42 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin, LANGUAGE_CODE=KO |
| 20:59:02.965 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 140.92 | LOGTYPE=SpeedUp, NOTE=SSP0045
division_id_changed
end
, USER_ID=jaeuk.shin |
| 20:59:02.974 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.78 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 20:59:03.005 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList_SCP | 2 | 2.99 | Code=OperationGroup, Param1=, Param2=, Param3=, Param4=, Param5=, Param6=, TimeZone=AS054 |
| 20:59:03.019 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 18 | 4.51 | Code=PlantByDivisionOperation, Param1=40, Param2=P, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:59:03.031 | load | GSCM.DM.Master.WSL | DM0003_GET_BUCKET_TYPE_CODE | 3 | 3.18 |  |
| 20:59:03.075 | load | GSCM.SCP.Master.WSL | SCM0001_GET_SCP_DAY_PERIOD | 1 | 4.57 | p_from_date=, p_offset_day=55, p_timezone=AS054 |
| 20:59:03.092 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 83 | 4.84 | Code=PlantSiteByDivision, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:59:03.105 | load | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 9.37 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270106 |
| 20:59:03.241 | load | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 126.78 | p_program_id=SSP0045, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 20:59:03.254 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 3.83 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:59:03.369 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 110.8 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:59:03.388 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.6 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:59:03.741 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 227.81 | MenuID=Shipment Request SEMI, CnntCode=0104001, UserID=jaeuk.shin |
| 20:59:03.809 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.86 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SSP0045 |
| 20:59:11.959 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 83 | 4.36 | Code=PlantSiteByDivision, Param1=40,81,82, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:59:11.971 | find | GSCM.SCP.Analysis.WSL | SCP0009_GET_SHEET_CALENDAR_3SPAN | 70 | 8.59 | p_start_yyyymmdd=20261112, p_end_yyyymmdd=20270106 |
| 20:59:11.981 | find | GSCM.SCM.Master.WSL | SCM_SYS_GET_SPREAD_TITLE | 18 | 4.37 | p_program_id=SSP0045, p_user_id=jaeuk.shin, p_sheet_name=Shipment Request |
| 20:59:11.991 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 0 | 4.4 | Code=PlantSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:59:12.068 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2662 | 72.47 | Code=ToSiteByDivision, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 20:59:12.088 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 14 | 3.81 | Code=FCST_TYPE, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Operation Group* | cboBizType | Y |
| Div* | cboDivision | Y |
| Bucket | cboBucketType |  |
| Model | txtItem_Id |  |
| layoutControlItem4 | btnItem_Id |  |
| Period* | drpPeriod | Y |
| layoutControlItem9 | chkSum |  |
| From Site | clbFromSite |  |

## 그리드

- spdMain / Shipment Request: 행 0 · 컬럼 89(보임 68) · 헤더 3단 · 고정 컬럼 17

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
