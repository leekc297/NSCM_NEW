# DMF0042 · DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA ↔ PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA

- 실행: 2026-11-26 18:28:32
- 파라미터: `{"p_division_id": "40", "p_dept_id": "", "p_end_customer": "", "p_scm_site_id": "Fabricators_CN_QIN", "p_project_code": "Inventus Power", "p_item_id": "MCCM134010A1", "p_item_type": "", "p_from_yyyymmdd": "20260101", "p_now_yyyymmdd": "", "p_to_yyyymmdd": "20261231", "p_created_by": "bpark416", "p_plant_site_id": "", "p_biztype": "", "p_userinfo": "", "p_owner": "", "p_qty_yn": ""}`
- 종류: GET
- 입력 인자 미정: p_dept_id=clbTeam.ControlValues · p_end_customer=clbCustomer.ControlValues · p_item_type=clbItemType.ControlValues · p_now_yyyymmdd=sNowDate · p_plant_site_id=clbPlantSite.ControlValues · p_biztype=clbBizType.ControlValues · p_userinfo=UserInfoContext.Current["NowGroupID"].ToString() · p_qty_yn=(cboQty.Checked == true) ? "Y" : "N" · 실행 기록은 있으나 빈 인자를 못 채움(TO-BE 호출 0 · 차등 검증 0 · AS-IS 실측 파일 8)
- 파라미터 값 미정 — param_defaults.json 또는 golden_cases.csv params 보완 (manual=Y 면 빈값도 의도된 값으로 실행)
