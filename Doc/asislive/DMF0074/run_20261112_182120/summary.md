# AS-IS 실측 요약 — DMF0074

- 실행: 2026-11-12 18:21:20.427 ~ 2026-11-12 18:21:37.746 · 계정 jaeuk.shin · 상태 OK
- 화면: Metal Link Price (GSCM.DM.Plan.UIL.DMF0074_MetalLinkPrice)
- 조회 결과:  · DB : 0.423s, UI : 0.001s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:21:20.849 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.18 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0074 |
| 18:21:20.874 | load | GSCM.BizService.WSL | SELECT * | 874 | 19.55 | USER_ID= |
| 18:21:21.938 | load | GSCM.BizService.WSL | Declare @AuthTypePara varchar(100) = 'D'; | 7 | 672.0 | GROUP_ID=ADMIN, USER_ID=jaeuk.shin |
| 18:21:22.081 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 26 | 11.67 | Code=UpperDeptId, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 18:21:22.450 | load | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 53 | 18.68 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0074, p_sheet_name=Metal Link Price, p_division_id=40 |
| 18:21:22.583 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 64.0 | MenuID=Metal Link Price, CnntCode=0104001, UserID=jaeuk.shin |
| 18:21:22.717 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.77 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=DMF0074 |
| 18:21:31.357 | find | GSCM.DM.Master.WSL | DMF0000_GET_COMMON_SPREAD_TITLE | 53 | 18.95 | p_start_yyyymmdd=, p_end_yyyymmdd=, p_created_by=jaeuk.shin, p_program_id=DMF0074, p_sheet_name=Metal Link Price, p_division_id=40 |
| 18:21:31.798 | find | GSCM.DM.Master.WSL | DMF0074_GET_METAL_LINK_PRICE | 0 | 413.19 | p_division_id=40, p_dept_id=ALL, p_end_customer=ALL, p_scm_site_id=ALL, p_plant_site_id=ALL, p_project_code=, p_item_id=, p_from_yyyymmdd=202611, p_to_yyyymmdd=202705, p_version_type=Current |
| 18:21:31.821 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.65 | p_menu_id=DMF0074, p_log_type=FIND, p_log_cnt=, p_db_time=0.423, p_ui_time=0.001, p_user_id=jaeuk.shin |
| 18:21:36.997 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.8 | MenuID=Metal Link Price, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Project | txtProject |  |
| End Customer | clbEndCustomer |  |
| Sales Site | clbScmSite |  |
| Team | clbTeam |  |
| lblBtnProject | btnProject |  |
| Model / Nickname | txtItemId |  |
| lblBtnItemId | btmItem |  |
| Plant Site | clbPlantSite |  |
| Upload | btnExcelUpload |  |
| Plan Date | drpPeriodMonth |  |
| Div | clbDivisions |  |
| Version | txtVersion |  |
| layoutControlItem7 | btnSPVer |  |
| Excel Form | btnTemplate |  |

## 그리드

- spdMain / Metal Link Price: 행 0 · 컬럼 54(보임 53) · 헤더 2단 · 고정 컬럼 12

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
