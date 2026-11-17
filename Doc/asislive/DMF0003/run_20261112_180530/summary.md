# AS-IS 실측 요약 — DMF0003

- 실행: 2026-11-12 18:05:30.321 ~ 2026-11-12 18:06:07.244 · 계정 jaeuk.shin · 상태 OK
- 화면: MKT FCST (GSCM.DM.Plan.UIL.DMF0003_MktFcst)
- 조회 결과: Total : 1,476 · DB : 13.355s, UI : 0.643s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:05:31.571 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.82 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0003 |
| 18:05:31.606 | load | GSCM.BizService.WSL | SELECT * | 874 | 18.99 | USER_ID= |
| 18:05:32.898 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 762.06 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:05:33.640 | load | GSCM.DM.Master.WSL | DMF0003_GET_BUCKET_TYPE_CODE | 3 | 2.99 |  |
| 18:05:33.753 | load | GSCM.DM.Master.WSL | PR_GET_DAY_RANGE | 1 | 78.97 | p_created_by=jaeuk.shin, p_month=6 |
| 18:05:33.762 | load | GSCM.SCM.Master.WSL | SCM0001_GET_LOOKUP_VALUES | 4 | 2.72 | p_lookup_type=ITEM_TYPE_CODE |
| 18:05:33.888 | load | GSCM.DM.Master.WSL | UP_FX_GETCOMMONDATALIST_DM | 1294 | 72.31 | CODE=SiteByEndCustomer40, PARAM1=ALL, PARAM2=ALL, PARAM3=ADMIN, PARAM4=jaeuk.shin, PARAM5=N |
| 18:05:33.934 | load | GSCM.DM.Master.WSL | DMF0003_GET_SPREAD_TITLE | 237 | 14.89 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_user_group=ADMIN, p_type=LOAD |
| 18:05:34.068 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 102.4 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:34.164 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 75.0 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:34.198 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 5.4 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:34.208 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 5.42 | Code=FCST_TYPE_NOT_ETC, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:34.219 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 5.1 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:34.264 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 40.15 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:34.292 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 46 | 13.69 | Code=Measure, Param1=DMF0003, Param2=Mkt Fcst, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:34.879 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 53.86 | MenuID=MKT FCST, CnntCode=0104001, UserID=jaeuk.shin |
| 18:05:35.102 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.75 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0003 |
| 18:05:43.521 | find | GSCM.DM.Master.WSL | DMF0003_GET_SPREAD_TITLE | 237 | 14.47 | p_start_yyyymmdd=20261101, p_end_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_division_id=40, p_user_group=ADMIN, p_type= |
| 18:05:43.640 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1098 | 94.33 | Code=EndCustomerByDivision40, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:43.727 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2494 | 76.92 | Code=SiteByEndCustomer, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:43.747 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 16 | 3.25 | Code=Incoterms, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:43.755 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 13 | 3.04 | Code=FCST_TYPE_NOT_ETC, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:43.762 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 2 | 3.46 | Code=DOM_EXP, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:43.809 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 227 | 39.65 | Code=DeptId, Param1=, Param2=, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:43.826 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 46 | 10.18 | Code=Measure, Param1=DMF0003, Param2=Mkt Fcst, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:05:57.178 | find | GSCM.DM.Master.WSL | DMF0003_GET_MKT_FCST_DATA | 1476 | 13207.53 | p_division_id=40, p_scm_site_id=ALL, p_plant_site_id=ALL, p_team_id=ALL, p_customer=ALL, p_biz_type=ALL, p_project_code=, p_item_id=, p_from_yyyymmdd=20261101, p_to_yyyymmdd=20270430, p_created_by=jaeuk.shin, p_user_group=ADMIN, p_item_type=ALL, p_owner=, p_qty_yn=N, p_cell_yn=N, p_invalid_exec=N, p |
| 18:05:57.949 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.76 | p_menu_id=DMF0003, p_log_type=FIND, p_log_cnt=1476, p_db_time=13.355, p_ui_time=0.643, p_user_id=jaeuk.shin |
| 18:05:57.976 | find | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 1 | 22.34 | Code=DefaultBucketDay, Param1=40, Param2=WEEKLY, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:06:06.239 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.61 | MenuID=MKT FCST, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Team | clbTeam |  |
| End Customer | clbCustomer |  |
| Biz Type | clbBizType |  |
| Period | drpPeriod |  |
| Sales Site | clbSalesSite |  |
| Model / Nickname | txtItemId |  |
| Project | txtProject |  |
| layoutControlItem3 | btnProject |  |
| layoutControlItem1 | btnItemId |  |
| Bucket | cboBucketType |  |
| layoutControlItem2 | btnColumn |  |
| layoutControlItem4 | btnMeasure |  |
| Plant Site | clbPlantSite |  |
| layoutControlItem5 | chkSum |  |
| Item Type | clbItemType |  |
| Div | clbDivision |  |
| Owner | txtOwner |  |
| layoutControlItem8 | btnOwner |  |
| . | cboQty |  |
| Master Chg | btnIncotermsChg |  |
| . | cboCellQty |  |
| layoutControlItem11 | checkInvalidExec |  |
| lciASCheck | cboAS |  |
| layoutControlItem6 | chkColor |  |
| Sender Code | clbEDISender |  |

## 그리드

- spdMain / Mkt Fcst: 행 1476 · 컬럼 239(보임 50) · 헤더 3단 · 고정 컬럼 22

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
