#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ui_http_e2e.py — BE HTTP 셀프 E2E 러너 (hook #125 ui-selfcheck-runtime-mandatory §2, 2026-08-07)

FE 와 동일 경로(세션 쿠키 + call-proc/메타/콤보 API)로 화면 전 기능 축을 실행·판정한다.
브라우저 없이 클로드코드가 "전체 기능 구현 완료"를 실증하는 도구 — 사용자는 시각 확인만.

사용:
  python ui_http_e2e.py --menu DMF0082 [--users minyonglee1,bpark416,DM_V_TEST] [--base http://localhost:8080] [--no-save]

축: A 로그인(isGuest 단언) / B 메뉴 접근·버튼 권한 / C 컬럼·메저 메타(division별) / D 콤보 전 키(0행 검출)
    / E SEARCH·SEARCH_CURRENT(division별 행수·키 컬럼·EDIT_FLAG) / F SAVE 왕복(M +1→재조회→원복 — primary 계정만)
      ⛔ F축 안전장치 2종 (실데이터 훼손 실사고 후 신설 — 시나리오별 명시):
         `insert_delete_safe: False` = I/D 왕복 차단 (2026-08-10, 'D' 가 기존 행 삭제)
         `modify_safe: False`        = **M 왕복 차단** (2026-08-11, 원복해도 원상태 아님)
         둘 다 조용히 넘기지 않고 사유를 리포트에 WARN 으로 남긴다. 차단된 축은 화면 육안 확인 대상.
    / G 모달 시트 API 전수 / H 다계정 권한 매트릭스(auth 목록 ↔ 403 실측 대조)

함정 3종(실측 2026-08-07): ①로그인 Content-Type 은 정확히 'application/json'(requests json= 안전)
  ②미등록 ID 도 로그인 200 — isGuest 단언 의무 ③/sso/dev-login 은 302 — 본 러너는 /user/login 사용.
산출: _artifacts/_gate_reports/{MENU}_http_e2e_{ts}.md (ui_gate_runner 섹션 6 소비)
"""
import argparse, datetime, json, pathlib, sys

try:
    import requests
except ImportError:
    sys.exit("ERROR: pip install requests 필요")

# ====================================================================================
# Division별 공식 테스트 계정 (2026-08-07 사용자 지정 — 권한 매트릭스 표준 로스터)
# ====================================================================================
ROSTER = {
    "hongjae.kim":  ("40", "DM Admin"),        "eunah.koo":   ("40", "DM Planner"),
    "yooah.chung":  ("40", "DM Viewer"),       "dodae":       ("40", "SCP Planner"),
    "jiwon.park":   ("81", "DM Admin"),        "bpark416":    ("81", "DM Planner"),
    "jaehyeok":     ("81", "DM Planner (W/S)"),"park6151":    ("81", "DM Viewer"),
    "bottle":       ("81", "SCP Planner"),
    "wonqthanq":    ("82", "DM Admin"),        "ys_cho":      ("82", "DM Planner"),
    "miyeong.lee":  ("82", "DM Planner (W/S)"),"yeonjusung":  ("82", "DM Viewer"),
    "coeogus":      ("82", "SCP Planner"),
}
DEFAULT_USERS = "minyonglee1," + ",".join(ROSTER.keys())

# ====================================================================================
# 화면별 시나리오 레지스트리 — 신규 화면은 여기에 등록 (hook #125 §2)
# ====================================================================================
SCENARIOS = {
    "DMF0082": {
        "main_sheet": "FcstNPrice",
        "divisions": ["40", "81", "82"],
        "readonly_divisions": ["82"],  # 저장 차단 기대 (V82-00)
        "key_columns": ["DIVISION_ID", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID"],
        # division 별 추가 필수 키 — AS-IS 파리티로 노출 자체가 갈리는 컬럼은 여기서 분기한다.
        #   CELL_PROD_SITE_ID: 통합테스트 No.39 "81/81_JV 는 Cell Prod Site 제외" → SHEET_COLUMNS
        #   DIVISION_ID='40,82' (2026-08-11 보완). 전 division 공통 기대로 두면 81 이 오탐 FAIL 이 된다.
        "key_columns_by_division": {"40": ["CELL_PROD_SITE_ID"], "82": ["CELL_PROD_SITE_ID"]},
        "combos": ["MyDivision", "BucketType", "EndCustomer", "SenderCode",
                   "FcstPriceUserAuthGroup", "SalesBucket", "CurrencyList",
                   "FcstTypeByUserGroupDMF0082"],
        # D2 축 — FE 가 <DataGrid comboParams> 로 전 셀 콤보에 일괄 전달하는 값과 동일하게 유지.
        #   ⚠ BE makeComboQuery 는 raw 치환이므로 문자열은 작은따옴표를 포함한다.
        #   divisionId 는 의도적으로 넣지 않는다(행 단위 종속 — GRID_EDIT_COMBO 경로가 담당).
        "cell_combo_params": {"mnuId": "'DMF0082'"},
        # 페이지 단위로 전달하지 않는 토큰의 **처리 경로**를 명시한다(hook #117 §5.6 '미전달 사유' 칸).
        #   근거 없는 WARN 이 쌓이면 게이트가 무시되므로, 각 항목은 코드 위치나 판정 사유를 가진다.
        "cell_combo_notes": {
            "CELL_PROD_SITE_ID": "행 단위 재조회 — ForecastPriceGrid.applyCellProdSites (ITEM_ID 변경 트리거)",
            "SiteByEndCustomer": "행 단위 재조회 — ForecastPriceGrid.applySalesSites (END_CUSTOMER 변경 트리거)",
            "PlantByDivisionCompany": "편집 진입 스왑 — GRID_EDIT_COMBO(divisionParam). @companyId 는 화면에 컨텍스트 없음(AS-IS 도 미전달)",
            "BizTypeByDivision": "모달 'Sales Price Save All' 표시 전용(INPUT_TP_CD=S) — 저장 대상 아님",
            "Division": "모달 'Sales Price Save All' 표시 전용(INPUT_TP_CD=S)",
            "EndCustomerByDivisionDept": "모달 'Sales Price Save All' 표시 전용(INPUT_TP_CD=S)",
            "FromSiteByDivision": "모달 'Sales Price Save All' 표시 전용(INPUT_TP_CD=S)",
        },
        # [WS 2026-08-07] 그룹별 FCST_TYPE 화이트리스트 — AS-IS UP_FX_GetCommonDataList_DM:72 1:1
        #   W/S 그룹 = SALES_TYPE_CODE2 4종 한정 / 그 외 = SALES_TYPE_CODE − ETC − WS/WSF = 11종
        "group_combo_expect": {
            "combo": "FcstTypeByUserGroupDMF0082",
            "ws_group": "DM Planner (W/S)",
            "ws_codes": {"WS", "WSF", "AS", "ASF"},
            "other_excluded": {"WS", "WSF", "ETC"},
        },
        # SEARCH filters (FE useForecastPriceStore.setFilters 규약 — itemId 는 ''=전체)
        "search_filters": lambda div, user, group: {
            "divisionId": div, "deptId": "ALL", "endCustomer": "ALL", "bizType": "ALL",
            "fromYyyymmdd": "20260801", "toYyyymmdd": "20270201", "salesSite": "ALL",
            "itemId": "", "versionType": "Current", "qtyYn": "N",
            "sesUserId": user, "userGroup": group,
            "plantSiteId": "ALL", "projectCode": "ALL", "owner": "ALL", "senderCode": "ALL",
        },
        # FE 실사용 = SEARCH 단일(versionType 으로 Current/버전 분기). SEARCH_CURRENT 는 BTN_MPG 배선만 존재
        # (FE 미호출) + PROC_M COL_NM 이 GET 과 상이(team/startDate/endDate/version) → 별도 키로 검증.
        "search_buttons": ["SEARCH"],
        "aux_buttons": [
            {"btn": "SEARCH_CURRENT", "cursor": "o_rc1", "note": "FE 미사용 배선 — PROC_M COL_NM 상이",
             "filters": lambda div, user, group: {
                 "divisionId": div, "team": "ALL", "endCustomer": "ALL", "bizType": "ALL",
                 "startDate": "20260801", "endDate": "20270201", "salesSite": "ALL",
                 "itemId": "", "version": "Current", "qtyYn": "N",
                 "sesUserId": user, "userGroup": group,
                 "plantSiteId": "ALL", "projectCode": "ALL", "owner": "ALL", "senderCode": "ALL"}},
        ],
        "result_cursor": "fcstNPrice",          # SEARCH 응답 메인 커서 키
        # 모달 시트 API (procedures.d.ts 실측 — 조회 전용 호출만; 저장류 모달은 R 만 검증)
        "modal_sheets": [
            {"sheet": "version", "btn": "SEARCH", "filters": lambda div, user, group: {
                "startYyyymmdd": "20240101", "endYyyymmdd": "20270201", "createdBy": user,
                "divisionId": div, "versionType": "", "description": ""}},
            {"sheet": "futurePriceInfo", "btn": "SEARCH", "filters": lambda div, user, group: {
                "startYyyymmdd": "20260801", "endYyyymmdd": "20260930"}},
            {"sheet": "spreadTitle", "btn": "SEARCH", "filters": lambda div, user, group: {
                "startYyyymmdd": "20260801", "endYyyymmdd": "20270201",
                "sesUserId": user, "divisionId": div}},
        ],
        # SAVE 왕복 (primary 계정 + 편집 가능 division 만): FE buildSavePayload 단일행 규약
        "save_roundtrip": {
            "division": "81",
            "row_filter": lambda r: r.get("MEASURE") == "MKT_FCST" and str(r.get("EDIT_FLAG")) == "Y",
            # 편집 가능 창(금주 월요일 이후) — M 후보(값>0)와 I 후보(빈 셀) 모두 확보되도록 넓게
            "date_window": ([f"202608{d:02d}" for d in range(12, 32)]
                            + [f"202609{d:02d}" for d in range(1, 31)]
                            + [f"202610{d:02d}" for d in range(1, 32)]),
            "payload": lambda row, ymd, qty, user: {
                "activeFlag": "M", "divisionId": s(row, "DIVISION_ID"),
                "projectCode": s(row, "PROJECT_CODE") or s(row, "END_CUSTOMER"),
                "endCustomer": s(row, "END_CUSTOMER"), "scmSiteId": s(row, "SCM_SITE_ID"),
                "itemId": s(row, "ITEM_ID"), "domExp": s(row, "DOM_EXP"),
                "fcstType": s(row, "FCST_TYPE"), "incoterms": s(row, "INCOTERMS"),
                "measure": s(row, "MEASURE"), "plantSite": s(row, "PLANT_SITE_ID"),
                "cellProdSiteId": s(row, "CELL_PROD_SITE_ID"), "yyyymmdd": ymd,
                "currency": s(row, "CURRENCY"), "qty": str(qty), "createdBy": user,
            },
        },
    },
    # ================================================================================
    # DMF0042 Business Plan (2026-08-09 등록) — PROC_M 실측 계약 기준
    #   조회 = PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA (16 IN / 커서 2: data·calendar)
    #   저장 = PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST (21키 '^' bulk — 감사 2키 FE 필수)
    #   동적 셀 = **M_yyyymm** (DMF0082 의 D_yyyymmdd 와 다름 → cell_prefix 로 분기)
    # ================================================================================
    "DMF0042": {
        "main_sheet": "Biz Plan",
        "divisions": ["40", "81", "82"],
        # 3 division 전부에 등록된 컬럼만 필수키로 둔다(SHEET_COLUMNS.DIVISION_ID 실측 —
        #   나머지 59컬럼은 division 스코프라 전 division 필수로 걸면 오탐).
        "key_columns": ["DIVISION_ID", "MEASURE", "EDIT_FLAG", "CURRENCY"],
        "combos": ["MyDivision", "UserTeamByDivision", "EndCustomer", "EndCustomerByDivision40",
                   "BizTypeByDivision", "DmBizType", "ItemType", "BucketType2",
                   "PlantSitebyEndCustomer", "UserSiteByEndCustomer", "CurrencyList",
                   "DMF0042CellProdSiteValid", "BizPlanUserAuthGroup"],
        # D2 축 — FE BusinessPlanGrid 가 메타 셀 콤보에 넘기는 값과 동일 (2026-08-09 배선).
        #   AS-IS SpreadInfo.cs L1975~1981 + DMF0042_GET_SPREAD_TITLE(ATTRIBUTE1=division /
        #   ATTRIBUTE2=컬럼 ATTRIBUTE1) 계약 1:1.
        "cell_combo_params": {"divisionId": "'81'", "param1": "'81'", "param2": "'BP_FCST_TYPE'"},
        # userGroup(P_USERINFO) 원천 = FE useBusinessPlanStore.authGroup 과 동일 CMBO (1행)
        "auth_group_combo": "BizPlanUserAuthGroup",
        # EDIT_FLAG 결정 축 (AS-IS L425~426 ↔ TO-BE PKG_DMF0042 BODY L2050~2051, 1:1)
        "edit_flag_axes": "행 DEPT_ID = 로그인 사용자 부서(TB_FX_User, p_created_by 조회) OR 권한그룹 ADMIN",
        # 전 행 'N' 이 **AS-IS 파리티로 검증된** 계정 — 사유를 남기고 통과시킨다(cell_combo_notes 와 동일 규약).
        #   2026-08-09 AS-IS 직접 대조: TB_FX_User 부서·PM_TEAM_MAPPING 매핑 결과가 AS-IS 와 **완전 동일**.
        #   ⚠ 부서 축이 안 걸리는 근본 원인 = `PM_TEAM_MAPPING` 이 SEGMENT1 1개에 SEGMENT3 를 **다중 매핑**
        #     (예: 30263706 → 15건)하는데 SP 는 TOP 1 / FETCH FIRST 1 ROWS ONLY 로 **첫 1건만** 취한다.
        #     그 1건이 원장 DEPT_ID 에 없으면 부서 축은 무력화된다 — AS-IS 도 동일 동작(설계 계승).
        "edit_flag_all_n_ok": {
            "jaehyeok": "그룹 'DM Planner (W/S)' 는 GET_ADMIN_GROUP/ALL 미등재(AS-IS lookup 동일) + "
                        "부서 70000342 → PM_TEAM_MAPPING TOP1 = 58570422 (원장 81 에 없음). AS-IS 동일값 확인",
            "miyeong.lee": "동상 — 부서 70084594(매핑 없음)가 원장 82 에 없음. AS-IS 동일값 확인",
        },
        "cell_combo_notes": {
            "EndCustomerByDivisionDept": "행 스코프 @deptId — GRID_CASCADE_FILTERS.END_CUSTOMER "
                                          "(DIVISION_ID+DEPT_ID) beginningEdit dataMap 스왑이 담당",
            "SiteByEndCustomer": "행 스코프 @endCustomer — GRID_CASCADE_FILTERS.SCM_SITE_ID40 "
                                  "(DIVISION_ID+END_CUSTOMER40) beginningEdit dataMap 스왑이 담당",
        },
        # SEARCH filters — useBusinessPlanStore.setFilter 규약 1:1 (PROC_M SORT_ORD 1~16,
        #   11=sesUserId 는 BE 주입). projectCode/itemId/owner 는 텍스트 필드라 ''=전체.
        #   ⚠ 기간은 **division 별 원장 실데이터 구간**을 쓴다(2026-08-09 실측:
        #     DM_PLN_BP_FCST 40=201808~203112 / 81=202001~202412 / 82=202001~202512).
        #     전 division 에 같은 미래 구간을 쓰면 81·82 가 0행이 되어 조회 축이 무력해진다.
        "search_filters": lambda div, user, group: {
            "divisionId": div, "deptId": "ALL", "endCustomer": "ALL", "scmSiteId": "ALL",
            "projectCode": "", "itemId": "", "itemType": "ALL",
            "fromYyyymmdd": _BP_PERIOD.get(div, _BP_PERIOD["40"])[0],
            "nowYyyymmdd": _this_week_monday(),
            "toYyyymmdd": _BP_PERIOD.get(div, _BP_PERIOD["40"])[1],
            "sesUserId": user, "plantSiteId": "ALL", "bizType": "ALL",
            "userGroup": group, "owner": "", "qtyYn": "N",
        },
        "search_buttons": ["SEARCH"],
        "aux_buttons": [],
        "result_cursor": "data",              # PROC_M SORT_ORD 17 (커서 18 = calendar)
        "modal_sheets": [
            {"sheet": "spreadTitle", "btn": "SEARCH", "filters": lambda div, user, group: {
                "startYyyymmdd": "20260801", "endYyyymmdd": "20270331",
                "sesUserId": user, "divisionId": div, "userId": user, "mnuId": "DMF0042"}},
            {"sheet": "dayRange", "btn": "SEARCH", "filters": lambda div, user, group: {
                "createdBy": user, "month": "7"}},
            {"sheet": "exchangeRate", "btn": "SEARCH", "filters": lambda div, user, group: {
                "startYyyymmdd": "20260801", "endYyyymmdd": "20270331",
                "userId": user, "mnuId": "DMF0042"}},
            {"sheet": "futurePriceData", "btn": "SEARCH", "filters": lambda div, user, group: {
                "divisionId": div, "fromYyyymmdd": "20260801", "toYyyymmdd": "20270331",
                "sesUserId": user, "cate": "BP", "userId": user, "mnuId": "DMF0042"}},
            {"sheet": "cutoffVersion", "btn": "SEARCH", "filters": lambda div, user, group: {
                "divisionId": div, "yyyymmFrom": "202401", "yyyymmTo": "202703",
                "versionType": "BP_M", "userId": user, "mnuId": "DMF0042"}},
            {"sheet": "mdfVersion", "btn": "SEARCH", "filters": lambda div, user, group: {
                "divisionId": div, "versionDescription": "", "versionType": "BP_M",
                "fromYyyymmdd": "20240101", "toYyyymmdd": "20270331",
                "sesUserId": user, "userId": user, "mnuId": "DMF0042"}},
            {"sheet": "titleSet", "btn": "SEARCH", "filters": lambda div, user, group: {
                "programId": "DMF0042", "sheetName": "Biz Plan", "columnType": "C",
                "sesUserId": user, "divisionId": div, "mnuId": "DMF0042"}},
        ],
        "save_roundtrip": {
            # 40 = 원장이 203112 까지 있어 **편집 가능 구간(R3 금주 이후 × R4 유효구간)** 에 후보가 있는
            #   유일한 division (81=202412 / 82=202512 종료 — 미래 편집셀 없음).
            "division": "40",
            # 편집 대상 measure(Business_Plan) × 조회 SP 가 세팅한 EDIT_FLAG='Y' (R1 규칙)
            "row_filter": lambda r: str(r.get("MEASURE")) == "Business_Plan"
                                     and str(r.get("EDIT_FLAG")) == "Y",
            "cell_prefix": "M_",
            "date_window": [f"2026{m:02d}" for m in range(9, 13)] + [f"2027{m:02d}" for m in range(1, 4)],
            # 중복키 검증(business-plan.save.ts L148~159) 축 — division 별 컬럼 명명(40 접미) 모두 포함.
            #   존재하지 않는 키는 양변 모두 '' 이라 비교에 무해하다.
            "identity_keys": ("DIVISION_ID", "PROJECT_CODE", "ITEM_ID", "ITEM_ID40",
                              "SCM_SITE_ID81", "SCM_SITE_ID40", "END_CUSTOMER", "END_CUSTOMER40",
                              "DEPT_ID", "DEPT_ID40", "MEASURE", "CURRENCY"),
            # buildSavePayload 21키 1:1 (감사 2키 = FE 필수 — BE 주입 대상 아님).
            #   ⚠ division 슬롯은 business-plan.division.ts `read*Slot` 과 **동일 규약**이어야 한다
            #     (AS-IS SaveData L897~1057 3분기). 40 에서 PROJECT_CODE 를 그대로 읽으면 키가 빈 값이 되어
            #     SP 가 매칭할 원장 행을 못 찾고 **HTTP 200 인데 미반영**이 된다(2026-08-09 실측).
            "payload": lambda row, ymd, qty, user: _bp_payload(row, ymd, qty, user),
        },
    },
}


# DMF0042 division 별 조회 기간 (DM_PLN_BP_FCST 원장 실측 구간 — 2026-08-09)
_BP_PERIOD = {"40": ("20260801", "20270331"),
              "81": ("20240101", "20241231"),
              "82": ("20250101", "20251231")}


# ================================================================================
# DMF0044 Sales Reports / MDF Reports (2026-08-10 등록) — PROC_M 실측 계약 기준
#   조회 = PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA (9 IN / OUT data·result)
#   저장 = ETC(DataType=2) `SAVE_SALES_PLAN_REPORT_C` / Cutoff(=1) `..._C_CF` **이원화**
#   ⚠ 조회에 **버전 필수**(V-5 MSG00283) — 시나리오는 원장 실측 버전을 쓴다.
# ================================================================================
# ====================================================================================
# DMF0003 MKT FCST (2026-08-12 신설 — 정본 재대사 3축의 §6 실행 증명)
# ====================================================================================
SCENARIOS["DMF0003"] = {
    "main_sheet": "Mkt Fcst",
    "divisions": ["40", "81", "82"],
    # 키 컬럼 — AS-IS 40 계열은 *40 접미 별도 컬럼(.cs DefColumns Division40/Customer40/…, 메타 실측
    #   DIVISION_ID div='82,81*' vs DIVISION_ID40 div='40'). MEASURE 만 전 division 공통.
    "key_columns": ["MEASURE", "DOM_EXP", "FCST_TYPE", "INCOTERMS"],
    "key_columns_by_division": {
        "40": ["DIVISION_ID40", "END_CUSTOMER40", "SCM_SITE_ID40", "ITEM_ID40"],
        "81": ["DIVISION_ID", "SCM_SITE_ID", "ITEM_ID", "PLANT_SITE_ID", "PROJECT_CODE"],
        "82": ["DIVISION_ID", "SCM_SITE_ID", "ITEM_ID", "PROJECT_CODE"],
    },
    # 파라미터 없는 콤보만 등재 (파라미터 필요분 — AS_FROM_SITE/AsIncotermsEdit/MktFcstEditMeasure/
    #   PlantSiteByItem — 은 D2 셀 콤보 축 + 게이트 섹션7 이 대사).
    "combos": ["MktFcstEditableDivision", "MktFcstUserEditDivision", "MktFcstWsPlannerYn",
               "MktFcstUserGroups", "FcstTypeWs", "FcstTypeEditMode", "IncotermsEdit",
               "CustomsHandbook"],
    # ⚠ Dmf0003ScpPlannerEditFlag / Dmf0003DmPlannerEditFlag 는 시간 게이트 lookup — 운영값 미협의로
    #   0행이 **정상 상태**(0행=차단/미차단 각 게이트 보수 동작). 0행 FAIL 축(combos)에 넣지 않는다.
    "cell_combo_params": {"mnuId": "'DMF0003'"},
    "cell_combo_notes": {
        "AS_FROM_SITE": "페이지 단위 param1=division 전달(MktFcst.tsx L190) + Grid W/S 판정용 재조회",
        "AsIncotermsEdit": "AS(비축)향 사이트 행 한정 스왑 — divisionId 는 Grid useTabComboQueries 가 전달",
        "MktFcstEditMeasure": "GRID_EDIT_COMBO divisionParam=true — 편집 진입 스왑 전용",
        "PlantSiteByItem": "행 단위 재조회(applyPlantSites — PROJECT_CODE/ITEM_ID 변경 트리거, 81* 전용)",
        "SalesBucket": "타 화면(DMF0082) 전용 — DMF0003 은 BUCKET 을 GET 이 산출",
        "PlantByDivisionCompany":
            "@companyId 는 화면에 컨텍스트 없음(AS-IS 도 미전달 — DMF0082 동일 판정). 표시용 전체 목록이며 "
            "편집 후보는 행 단위 PlantSiteByItem(project·item) 재조회가 좁힌다(CD-10)",
        "SiteByEndCustomer": "@endCustomer 는 행 단위 cascade(GRID_CASCADE_FILTERS SCM_SITE_ID←END_CUSTOMER)가 "
            "편집 진입 시 행 값으로 필터 — 페이지 일괄 전달 대상 아님",
    },
    "edit_flag_axes": "EDIT_FLAG(GET 산출, 행×measure) × 버킷/시점 잠금(editLock buildEditCutoff) × "
                      "division 편집허용(DM_UI_EDITABLE_DIVISION — 현행 82만) × 그룹 게이트"
                      "(SCP 82·40 차단 / SCP 81 시간창 / DM류 시간창 / W-S AS 축)",
    # DMF0003_GET_MKT_FCST_DATA 22 IN (PROC_M SORT_ORD 순 — useMktFcstStore.ts:271~299 1:1)
    "search_filters": lambda div, user, group: {
        "divisionId": div,
        "scmSiteId": "ALL", "plantSiteId": "ALL", "teamId": "ALL", "customer": "ALL",
        "bizType": "ALL", "projectCode": "ALL", "itemId": "ALL",
        "fromYyyymmdd": "20250801", "toYyyymmdd": "20260801",
        "createdBy": user, "userGroup": group or user,
        "itemType": "ALL", "owner": "ALL",
        "qtyYn": "N", "cellYn": "N", "invalidExec": "Y" if div == "82" else "N",
        "asYn": "N", "userDeptId": "", "senderCode": "ALL",
        "sesUserId": user, "mnuId": "DMF0003",
    },
    "search_buttons": ["SEARCH"],
    "aux_buttons": [],
    "result_cursor": "o_rc1",
    "modal_sheets": [
        {"sheet": "spreadTitle", "btn": "SEARCH", "filters": lambda div, user, group: {
            "startYyyymmdd": "20250801", "endYyyymmdd": "20260801", "createdBy": user,
            "divisionId": div, "userGroup": group or user, "type": "LOAD",
            "sesUserId": user, "mnuId": "DMF0003"}},
        {"sheet": "dayRange", "btn": "SEARCH", "filters": lambda div, user, group: {
            "createdBy": user, "month": "6", "sesUserId": user, "mnuId": "DMF0003"}},
        # PR 팝업 GET 계열 — 존재하지 않는 키로도 HTTP 200/code 0 (0행) 이 정상 계약.
        {"sheet": "prPopup", "btn": "SEARCH", "filters": lambda div, user, group: {
            "popupType": "View_PR", "divisionId": div, "requestNo": "", "projectCode": "ALL",
            "scmSiteId": "ALL", "itemId": "ALL", "domExp": "", "fcstType": "", "incoterms": "",
            "plantSiteId": "", "yyyymmdd": "20260801", "planQty": "0", "createdBy": user,
            "sesUserId": user, "mnuId": "DMF0003"}},
        {"sheet": "prHistory", "btn": "SEARCH", "filters": lambda div, user, group: {
            "popupType": "View_History", "divisionId": div, "requestNo": "", "projectCode": "ALL",
            "scmSiteId": "ALL", "itemId": "ALL", "domExp": "", "fcstType": "", "incoterms": "",
            "plantSiteId": "", "yyyymmdd": "20260801", "planQty": "0", "createdBy": user,
            "sesUserId": user, "mnuId": "DMF0003"}},
        {"sheet": "sspCompare", "btn": "SEARCH", "filters": lambda div, user, group: {
            "divisionId": div, "scmSiteId": "", "projectCode": "", "itemId": "",
            "domExp": "", "fcstType": "", "incoterms": "", "yyyymmdd": "20260801",
            "sesUserId": user, "mnuId": "DMF0003"}},
        {"sheet": "titleSet", "btn": "SEARCH", "filters": lambda div, user, group: {
            "programId": "DMF0003", "sheetName": "Mkt Fcst", "columnType": "C",
            "sesUserId": user, "divisionId": div, "mnuId": "DMF0003"}},
    ],
    "save_roundtrip": {
        "division": "82",
        "row_filter": lambda r: str(r.get("MEASURE") or "").strip() != "",
        "cell_prefix": "D_",
        "date_window": [],
        "identity_keys": ("DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "ITEM_ID", "MEASURE"),
        # ⛔ I/D 왕복 금지 — DMF0003 저장 SP 는 원장 DELETE 액션이 없고(신규행 삭제 = 화면 I 행 제거뿐),
        #   'I' 로 넣은 행을 SP 로 되지울 방법이 없다. 남기면 실원장 오염(MF 버전 원장), 지우려면 직접
        #   DML = hook #131/#104 위반. C 축은 화면 육안 확인 대상.
        "insert_delete_safe": False,
        "insert_delete_note":
            "DMF0003 SAVE 는 MERGE(I/M 동일 경로) 뿐 — 원장 삭제 경로가 없어 I 왕복 후 원복 불가. "
            "신규행 검증은 화면 Insert→Save→육안 + 단위테스트(buildUnfoldRows/validate)로 대체",
        # ⛔ M 왕복 금지 — 조회가 주/월 롤업(합계) 표시라 러너가 읽는 셀값을 되쓰면 배분 로직(요일비트)을
        #   거치지 않은 원장 직접 갱신이 되고, 저장 SP 가 이력(H)까지 남긴다. DMF0049 선례(hook #131).
        "modify_safe": False,
        "modify_note":
            "MKT FCST 원장(DM_PLN_MKT_FCST — MF 버전 실데이터)은 W_/M_ 표시값이 D_ 합계라 되쓰기 "
            "왕복이 원상 보존을 깨뜨린다. 일반 행 M 축은 전용 키 probe 가 대체(아래)",
        # ⭐ M 왕복 전용 키 (2026-08-12 실 CRUD 권한 검증에서 생성한 테스트 소유 행 — QTY 0 잔존형).
        #   division 82 / 실 CRUD 왕복 5회(생성·수정·차단2·원복)로 안전성 검증 완료된 키.
        "modify_probe": {
            "user": "ys_cho",
            "note": "전용 키 82/C-25-017/DeltaX_KR_SEL/EP077170PCB1/MPS/DDP/D_20261123 — 실데이터 무접촉",
            "probe_qty": 7,
            "payload": lambda qty, user: {
                "activeFlag": "M", "divisionId": "82", "projectCode": "C-25-017",
                "scmSiteId": "DeltaX_KR_SEL", "itemId": "EP077170PCB1", "domExp": "E",
                "fcstType": "MPS", "incoterms": "DDP", "measure": "MKT_FCST",
                "plantSiteId": "--", "yyyymmdd": "20261123", "qty": str(qty),
                "createdBy": user, "asFromSite": "", "bucket": "WEEKLY",
                "authority": "DM Planner", "sesUserId": user, "mnuId": "DMF0003"},
            "verify_filters": lambda user: {
                "divisionId": "82", "scmSiteId": "ALL", "plantSiteId": "ALL", "teamId": "ALL",
                "customer": "ALL", "bizType": "ALL", "projectCode": "C-25-017",
                "itemId": "EP077170PCB1", "fromYyyymmdd": "20261101", "toYyyymmdd": "20261231",
                "createdBy": user, "userGroup": user, "itemType": "ALL", "owner": "ALL",
                "qtyYn": "N", "cellYn": "N", "invalidExec": "N", "asYn": "N",
                "userDeptId": "", "senderCode": "ALL", "sesUserId": user, "mnuId": "DMF0003"},
            # ⚠ 저장 measure 는 MKT_FCST 지만 GET 표시 measure 는 MKT_FCST_RP(롤업 표시명) — 실측.
            "row_match": lambda r: (str(r.get("PROJECT_CODE") or "") == "C-25-017"
                                    and str(r.get("ITEM_ID") or "") == "EP077170PCB1"
                                    and str(r.get("MEASURE") or "").startswith("MKT_FCST")
                                    and str(r.get("FCST_TYPE") or "") == "MPS"),
            "cell": "D_20261123",
        },
        "payload": lambda row, ymd, qty, user: {},
    },
}

# DMF0021 Sales Plan (2026-08-12 신설 — 전체 보완 3축의 §6 실행 증명)
#   원장 = DM_PLN_SALES_PLAN(+ETC 별도 DM_PLN_SALES_ETC_PLAN — 저장 대상표≠조회 원천표 주의).
#   SEARCH 성능: PERFHINT(2026-08-12) 후 81 데이터 경로 17s 실측 — 기간은 2개월로 제한.
SCENARIOS["DMF0021"] = {
    "main_sheet": "Sales Plan",  # 공백 quoted 키 (SP 리터럴·SHEET_COLUMNS 일치 — rename 불가)
    "divisions": ["40", "81", "82"],
    "key_columns": ["DIVISION_ID", "SCM_SITE_ID", "ITEM_ID", "MEASURE", "CURRENCY"],
    "key_columns_by_division": {
        "40": ["END_CUSTOMER40", "DEPT_ID", "CELL_PROD_SITE_ID", "COMPANY_ID"],
        "81": ["PROJECT_CODE", "END_CUSTOMER", "TEXT", "FROM_SITE_ID", "PLANT_SITE_ID"],
        "82": ["PROJECT_CODE", "END_CUSTOMER"],
    },
    "auth_group_combo": "SalesPlanUserAuthGroup",
    "combos": ["CurrencyList", "ItemType", "DmBizType", "SalesPlanUserAuthGroup"],
    "cell_combo_params": {"mnuId": "'DMF0021'"},
    "cell_combo_notes": {
        "SalesPlanItemId": "Insert Model = SALES_PLAN_ITEM_ID lookup (No.61-③ 신설) — @divisionId quoting 필수",
        "FromSiteByDivision": "81 셀 PLANT_SITE_ID/FROM_SITE_ID — AS-IS UserPlantSiteByDivision 대응",
        "CELL_PROD_SITE_ID": "@itemId 는 행 컨텍스트(comboContext itemId — ITEM 선택 후 재조회)로 전달. "
                             "메타 자동 수집 시점엔 행 미확정이라 미전달이 정상 (AS-IS 도 ITEM 선택 후 재바인딩 L4806)",
        "EndCustomerByDivisionDept": "@deptId 는 행 컨텍스트(comboContext deptId)로 전달 — 메타 수집 시점 "
                                     "미전달 = division 전체 후보(폴백 계약과 동일). AS-IS InsertRow 권한판 선바인딩 대응",
    },
    # W/S 그룹은 DMF0021 편집 lookup(GET_ADMIN_GROUP_MEASURE) 미등재 → EDIT_AUTH 'N' → 후보 0행 = AS-IS 파리티.
    #   (권한 명세 주석 AS-IS L931~935: ADMIN/SCM PI/SCP Planner/DM Planner/DM ADMIN 만 등재)
    "edit_flag_all_n_ok": {
        "miyeong.lee": "DM Planner (W/S) — SalesAmt_LOC·RTF lookup 미등재 그룹 (unitAuth true 는 메뉴 단위 합집합)",
        "jaehyeok": "DM Planner (W/S) — 동일 (81 데이터에 후보 행이 있으면 PASS 로 대체됨)",
    },
    # 행 게이트 컬럼 — DMF0021 은 EDIT_FLAG 가 아니라 SALES_PLAN_ADJUST_YN('N_Y'=편집 후보, AS-IS L963).
    "edit_flag_column": "SALES_PLAN_ADJUST_YN",
    "edit_flag_editable_value": "N_Y",
    "edit_flag_axes": "EDIT_AUTH 2종(MAIN 커서 3 — GET_ADMIN_GROUP_MEASURE AUTHUNION) × "
                      "행 SALES_PLAN_ADJUST_YN='N_Y' × measure 3종(SalesAmt_LOC=ETC 한정/Catch_Up=40 M+3/"
                      "RTF_SYS_RP=40·81+RTFGATE 시간창) × 버킷 상호배제 × 기간 cutoff(커서 2)",
    # P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX 17 IN (PROC_M SORT_ORD 순 — useSalesPlanStore.ts:238~257 1:1)
    "search_filters": lambda div, user, group: {
        "divisionId": div,
        "deptId": "ALL", "endCustomer": "ALL", "scmSiteId": "ALL",
        "projectCode": "", "itemId": "", "itemType": "ALL",
        "fromYyyymmdd": "20260701", "nowYyyymmdd": "20260701", "toYyyymmdd": "20260831",
        "plantSiteId": "ALL", "bizType": "ALL", "owner": "", "internalYn": "N",
        "userGroup": group or user, "bucket": "Weekly", "userDeptId": "",
        "sesUserId": user, "mnuId": "DMF0021",
    },
    "search_buttons": ["SEARCH"],
    "aux_buttons": [],
    "result_cursor": "data",
    "modal_sheets": [
        {"sheet": "spreadTitle", "btn": "SEARCH", "filters": lambda div, user, group: {
            "startYyyymmdd": "20260701", "endYyyymmdd": "20260831",
            "divisionId": div, "bucket": "Weekly", "sesUserId": user, "mnuId": "DMF0021"}},
        {"sheet": "measureInfo", "btn": "SEARCH", "filters": lambda div, user, group: {
            "sesUserId": user, "mnuId": "DMF0021"}},
        {"sheet": "dayRange", "btn": "SEARCH", "filters": lambda div, user, group: {
            "createdBy": user, "month": "6", "sesUserId": user, "mnuId": "DMF0021"}},
    ],
    "save_roundtrip": {
        "division": "81",
        "row_filter": lambda r: str(r.get("MEASURE") or "").strip() != "",
        "cell_prefix": "W_",
        "date_window": [],
        "identity_keys": ("DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "ITEM_ID", "MEASURE"),
        # ⛔ I/D 왕복 금지 — 신규 I 는 SP 내장 검증(판가 존재·중복)·division 필수값을 실데이터로
        #   통과해야 하고, 0값 저장은 'D' 로 행 삭제되므로 임의 왕복이 원장 구성을 바꾼다.
        "insert_delete_safe": False,
        "insert_delete_note":
            "DMF0021 SAVE 는 qty 0 = 'D'(행 삭제) 전환 — I→0 왕복은 가능해 보이나 SP 내장 검증"
            "(판가/중복)을 실데이터 키로 통과해야 해 원장 오염 위험. 2026-08-12 실 CRUD 직접 검증으로 대체: "
            "SalesAmt_LOC 실키 M(원값) SUCCESS + 원장 불변식(건수·QTY합) 동일 실측",
        # ⛔ M 왕복 금지 — 표시값이 실데이터 원장. 대신 RTFGATE 부정 검증을 실 CRUD 로 수행(2026-08-12):
        #   81 RTF 실키 M → CODE -1 'MSG00704^'(시간창 밖 차단) + 원장 불변 실측. GET 도 EDIT_AUTH 시간창 반영.
        "modify_safe": False,
        "modify_note":
            "Sales Plan 원장(DM_PLN_SALES_PLAN 실데이터) — M 왕복은 이력·감사컬럼을 바꾼다. "
            "2026-08-12 실 CRUD 직접 검증 완료(RTFGATE 차단 재현 + SalesAmt_LOC 통과 회귀 + 불변식)",
        "payload": lambda row, ymd, qty, user: {},
    },
}

# DMF0074 Metal Link Price (2026-08-18 신설 — 4축 점검 대사표→기능검증→테스트→권한별)
#   조회 전용 화면 (Insert/Delete/Edit/Save = AS-IS 빈 override → 버튼 미노출) → F축 SAVE 왕복 없음.
#   저장 유일 경로 = Excel Upload 2-Step (별도 실측: _dmf0074_test_b/c — 원장 왕복 검증 완료 2026-08-16).
#   행 접근통제 = SP 의 SCM_ADM_USER_MNU_EDIT_AUTH_V INNER JOIN 하드필터(PKG L452/L837) →
#     무권한 division 은 rows=0 이 정상(EDIT_FLAG 컬럼 없음 — EDIT_YN 프로젝션만).
SCENARIOS["DMF0074"] = {
    "main_sheet": "Metal Link Price",
    "divisions": ["40", "81", "82"],
    # ⚠ METAL_KIND_CODE 는 컬럼이 아니다 — 광물 7종이 메탈 42열(Key_/PeriodFr_/…)로 PIVOT 되어
    #   행 키에서 소멸한다(SHEET_COLUMNS BASE 16 실측). 2026-08-18 초기 시나리오 오탐 정정.
    "key_columns": ["DIVISION_ID", "PLAN_YYYYMM", "ITEM_ID", "SCM_SITE_ID", "CURRENCY"],
    "combos": ["MyDivision", "EndCustomer", "SalesSite"],
    "cell_combo_params": {},
    "cell_combo_notes": {},
    # 행 게이트 컬럼 — 이 화면은 EDIT_FLAG 가 아니라 EDIT_YN(권한 뷰 프로젝션)
    "edit_flag_column": "EDIT_YN",
    "edit_flag_editable_value": "Y",
    "edit_flag_axes": "단일 division-gate — SP INNER JOIN SCM_ADM_USER_MNU_EDIT_AUTH_V(USER×MNU×UNIT) "
                      "행 하드필터 + EDIT_YN 프로젝션. 행별 EDIT_FLAG·measure·시간락 게이트 부재(AS-IS 파리티)",
    # P_DMF0074_GET_METAL_LINK_PRICE 10 IN + 세션 2 (useMetalLinkPriceStore.ts:80~95 와 1:1)
    "search_filters": lambda div, user, group: {
        "divisionId": div, "deptId": "ALL", "endCustomer": "ALL", "scmSiteId": "ALL",
        "plantSiteId": "ALL", "projectCode": "", "itemId": "",
        # ⚠ 기간은 원장 실데이터를 덮어야 한다 — DM_BPS_METAL_LINK_PRICE 최신 PLAN_YYYYMM 실측:
        #   40=202607 / 81 계열=202601 / 82=202512 (202608 이후는 전 division 0행).
        #   미래 구간만 주면 rows=0 이 나와 "조회 경로 정상"과 "데이터 없음"이 구분되지 않는다.
        "fromYyyymmdd": "202501", "toYyyymmdd": "202702",
        "versionType": "Current", "sesUserId": user, "mnuId": "DMF0074",
    },
    "search_buttons": ["SEARCH"],
    "aux_buttons": [],
    "result_cursor": "o_rc1",
    "modal_sheets": [
        # Excel Form(템플릿) — P_DMF0074_GET_METAL_LINK_TEMPLATE (division 단일 param + 세션 2)
        {"sheet": "template", "btn": "SEARCH", "filters": lambda div, user, group: {
            "divisionId": div, "sesUserId": user, "mnuId": "DMF0074"}},
    ],
    # F축 없음 — 그리드 직접 SAVE 경로가 존재하지 않는 화면 (--no-save 로 실행)
}

SCENARIOS["DMF0044"] = {
        "main_sheet": "MDF Reports",
        # AS-IS 제약매트릭스 §1 실측 — 이 화면 division 비교는 40/82 2종뿐(81 분기 없음)
        "divisions": ["40", "82"],
        "key_columns": ["DIVISION_ID", "MEASURE", "DEPARTMENT_ID", "DEPT_ID"],
        "combos": ["MyDivision", "CALENDAR_YYYY", "DMF0044_MDF_MEASURE",
                   "DMF0044_DEPARTMENT_TEAM2", "DMF0044_DEPARTMENT_TEAM",
                   "DMF0044_ETC_SALE_RESULT_TYPE_40", "DMF0005_REPORT_GROUP2",
                   "DMF0005_REPORT_GROUP3", "END_CUST_REPORT", "SOLD_TO_CUST_REPORT"],
        # D2 축 — 파라미터는 **컬럼 메타에서 자동 산출**(meta_cell_params). 전역 보충값 불필요.
        "cell_combo_params": {},
        # ⭐ 0행이 AS-IS 파리티임을 **직접 대조로 실증한** 컬럼만 등재한다(일반 note 로는 통과 못 함).
        "cell_combo_zero_ok": {
            "DM_LOOKUP_DIV@BIZ_TYPE":
                "AS-IS DB 직접 대조(2026-08-10): SCM_MST_SHEET_COLUMNS 의 ATTRIBUTE1='40'·DIVISION_ID='40' 이 "
                "AS-IS·TO-BE 동일 → LOOKUP_TYPE='40' 조회가 되는데 SCM_ADM_LOOKUP_MASTER 에 '40' 은 "
                "AS-IS 0건·TO-BE 0건. 게다가 P_DMF0044_GET_SALES_REPORTS_DATA 는 BIZ_TYPE 컬럼 자체를 "
                "반환하지 않는다(반환은 BIZ_TYPE_NAME40 ← CMBO 'DmBizType' 3행). = legacy 잔존 메타, 파리티 유지.",
        },
        # ⚠ DMF0044 는 authGroup CMBO 가 없다 — FE 가 sesUserId 직전달(useSalesReportsStore.ts:133).
        #   SP 는 2026-08-09 AUTHUNION 적용으로 USER_ID 가 와도 보유그룹으로 해석된다.
        # EDIT_FLAG 결정 축 — SP 원문 실측(BODY L1361 / L1492) ↔ AS-IS 문자열 동일 확인(2026-08-10)
        "edit_flag_axes": "Cutoff 조회(DataType≠2) = V_GROUP_ID='ADMIN' **AND 행 DATA_TYPE='2'** / "
                          "ETC 조회(DataType≠1) = V_GROUP_ID='ADMIN'. "
                          "V_GROUP_ID 는 GET_ADMIN_GROUP(SEGMENT2='ALL') ∩ 보유그룹 합집합(AUTHUNION 2026-08-09)",
        "edit_flag_all_n_ok": {
            "wonqthanq": "div82 는 원장에 DATA_TYPE='2' 행이 0건이라 시나리오가 DataType=1(Cutoff)로 조회한다. "
                         "Cutoff 분기의 EDIT_FLAG 는 `(V_GROUP_ID='ADMIN') AND (DATA_TYPE='2')` 이므로 "
                         "DATA_TYPE='1' 행은 **정의상 전부 'N'** — AS-IS `DMF0044_GET_SALES_REPORTS_DATA` "
                         "동일 문자열 확인(2026-08-10 AS-IS DB 직접 대조). 계정 권한 문제 아님.",
        },
        # 조회 = 원장 실측 버전(division 별 상이). yyyy 는 데이터가 가장 두꺼운 해.
        "search_filters": lambda div, user, group: {
            "divisionId": div,
            "mdfType": "REPORT_SP_W",
            "yyyy": "2025",
            "spVersionNo": "R_S_20260128_V002_C" if div == "40" else "R_S_20260317_V001",
            "dataType": "2" if div == "40" else "1",   # 82 는 DATA_TYPE=2 데이터가 없음(실측)
            "userGroup": user,                          # FE 규약 1:1 (CMBO 없음)
            "sesUserId": user, "userId": user, "mnuId": "DMF0044",
        },
        "search_buttons": ["SEARCH"],
        "aux_buttons": [],
        "result_cursor": "data",
        "modal_sheets": [
            {"sheet": "spreadTitle", "btn": "SEARCH", "filters": lambda div, user, group: {
                "divisionId": div, "sesUserId": user, "startDt": "20250101", "endDt": "20251231"}},
            {"sheet": "measure", "btn": "SEARCH", "filters": lambda div, user, group: {
                "dataType": "2", "userId": user, "mnuId": "DMF0044"}},
            {"sheet": "unitedVersion", "btn": "SEARCH", "filters": lambda div, user, group: {
                "divisionId": div, "sdt": "20240101", "edt": "20271231",
                "versionType": "REPORT_SP_W", "description": "", "userId": user, "mnuId": "DMF0044"}},
            {"sheet": "exchangeRate", "btn": "SEARCH", "filters": lambda div, user, group: {
                "divisionId": div, "year": "2025", "sesUserId": user,
                "versionNo": "R_S_20260128_V002_C" if div == "40" else "R_S_20260317_V001",
                "userId": user, "mnuId": "DMF0044"}},
            {"sheet": "textbox", "btn": "SEARCH", "filters": lambda div, user, group: {
                "versionNo": "R_S_20260128_V002_C" if div == "40" else "R_S_20260317_V001",
                "userId": user, "mnuId": "DMF0044"}},
            {"sheet": "titleSet", "btn": "SEARCH", "filters": lambda div, user, group: {
                "programId": "DMF0044", "sheetName": "MDF Reports", "columnType": "C",
                "sesUserId": user, "divisionId": div, "mnuId": "DMF0044"}},
        ],
        # SAVE 왕복 — ETC SAVE(20키, 'SAVE') 를 **Cutoff 조회 화면(DataType=1)** 에서 관찰한다.
        #   ⚠ 왜 조회 조건을 바꾸는가 (2026-08-10 SP 원문 실측):
        #     · ETC 조회(P_DATA_TYPE<>'1', BODY L1459~) FROM `DM_PLN_SALES_ETC_REPORT_C`
        #     · ETC 저장(P_DMF0044_SAVE_SALES_PLAN_REPORT_C) MERGE 대상 `DM_PLN_SALES_PLAN_REPORT_C`
        #     ⇒ **읽는 표와 쓰는 표가 다르다** — ETC 조건 그대로 재조회하면 반영이 구조적으로 안 보인다.
        #     · Cutoff 조회(P_DATA_TYPE<>'2', L1327~) 는 `DM_PLN_SALES_PLAN_REPORT_C` 를
        #       **DATA_TYPE 필터 없이** 읽고(L1415~1418) `NVL(R.FORECAST_INFO_CELL_MODEL,'')`
        #       를 CELL_MODEL_INFO 로 준다(L1368) ⇒ MERGE ON 3키(2026-08-09 복원)와 정확히 맞는다.
        #   AS-IS 도 동일 구조(ON 절 19키에 FORECAST_INFO_CELL_MODEL 포함 — AS-IS DB 원문 확인).
        "save_roundtrip": {
            "division": "40",
            "save_mode": "insert_first",
            "row_filter": lambda r: str(r.get("EDIT_FLAG")) == "Y",
            "cell_prefix": "M_",
            "date_window": [f"2025{m:02d}" for m in range(1, 13)],
            "identity_keys": ("DIVISION_ID", "DEPARTMENT_ID", "DEPT_ID", "END_CUST_REPORT",
                              "CUST_REPORT", "PRODUCT_GROUP", "ITEM_ID", "MEASURE", "CURRENCY"),
            "ledger_note": "DM_PLN_SALES_PLAN_REPORT_C (DATA_TYPE='2')",
            "ledger_probe": {
                "sql": """SELECT NVL(SUM(QTY),0) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                           WHERE VERSION_NO=:v AND DIVISION_ID=:d AND DATA_TYPE='2'
                             AND DEPARTMENT_ID=:dep AND DEPT_ID=:dpt AND END_CUST_REPORT=:ecr
                             AND CUST_REPORT=:cr AND PRODUCT_GROUP=:pg AND ITEM_ID=:itm
                             AND MEASURE=:mea AND CURRENCY=:cur AND COMPANY_ID=:com
                             AND YYYYMMDD LIKE :ym || '%'""",
                "binds": lambda row, ymd: dict(
                    v=s(row, "VERSION_NO"), d=s(row, "DIVISION_ID"),
                    dep=s(row, "DEPARTMENT_ID"), dpt=s(row, "DEPT_ID"),
                    ecr=s(row, "END_CUST_REPORT"), cr=s(row, "CUST_REPORT"),
                    pg=s(row, "PRODUCT_GROUP"), itm=s(row, "ITEM_ID"),
                    mea=s(row, "MEASURE"), cur=s(row, "CURRENCY"),
                    com=s(row, "COMPANY_ID"), ym=ymd),
            },
            "cleanup": {
                "sql": """DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                           WHERE VERSION_NO=:v AND DIVISION_ID=:d AND DATA_TYPE='2'
                             AND DEPARTMENT_ID=:dep AND DEPT_ID=:dpt AND END_CUST_REPORT=:ecr
                             AND CUST_REPORT=:cr AND PRODUCT_GROUP=:pg AND ITEM_ID=:itm
                             AND MEASURE=:mea AND CURRENCY=:cur AND COMPANY_ID=:com
                             AND YYYYMMDD LIKE :ym || '%'
                             AND NVL(QTY,0)=0 AND LAST_UPDATED_BY=:u""",
                "binds": lambda row, ymd, user: dict(
                    v=s(row, "VERSION_NO"), d=s(row, "DIVISION_ID"),
                    dep=s(row, "DEPARTMENT_ID"), dpt=s(row, "DEPT_ID"),
                    ecr=s(row, "END_CUST_REPORT"), cr=s(row, "CUST_REPORT"),
                    pg=s(row, "PRODUCT_GROUP"), itm=s(row, "ITEM_ID"),
                    mea=s(row, "MEASURE"), cur=s(row, "CURRENCY"),
                    com=s(row, "COMPANY_ID"), ym=ymd, u=user),
            },
            # buildEtcSaveRows 20키 1:1 (PROC_M 21 IN − sesUserId(BE 주입)). 키가 하나라도
            #   남거나 모자라면 generic call-proc 이 -9994 "Sql Error" 로 떨어진다(2026-08-10 실측).
            #   ⚠ cellModelInfo/cellModel = **행 자신의 컬럼값** — MERGE ON 3키(2026-08-09 복원)라
            #     빈 값을 넣으면 UPDATE 가 아니라 중복 INSERT 가 되어 왕복이 성립하지 않는다.
            "payload": lambda row, ymd, qty, user: {
                "activeFlag": "M",
                "divisionId": s(row, "DIVISION_ID"),
                "versionNo": s(row, "VERSION_NO"),
                "cutoffType": s(row, "CUTOFF_TYPE"),
                "cutoffYyyymmdd": s(row, "CUTOFF_YYYYMMDD"),
                "departmentId": s(row, "DEPARTMENT_ID"), "departmentName": s(row, "DEPARTMENT_NAME"),
                "deptId": s(row, "DEPT_ID"), "deptName": s(row, "DEPT_NAME"),
                "endCustReport": s(row, "END_CUST_REPORT"), "custReport": s(row, "CUST_REPORT"),
                "productGroup": s(row, "PRODUCT_GROUP"), "itemId": s(row, "ITEM_ID"),
                "measure": s(row, "MEASURE"),
                "yyyymmdd": ymd,
                "currency": s(row, "CURRENCY"), "companyId": s(row, "COMPANY_ID"),
                "qty": str(qty),
                "cellModelInfo": s(row, "CELL_MODEL_INFO"), "cellModel": s(row, "CELL_MODEL"),
            },
        },
}


# ================================================================================
# DMF0049 Etc Sales Reports / MDF Reports (2026-08-10 등록) — PROC_M 실측 계약 기준
#   조회 = PKG_DMF0049.P_DMF0049_GET_SALES_ETC_REPORTS_DATA (8 IN / OUT data·result)
#   저장 = PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C (**단일 SP 36 IN** — FE 35키 + sesUserId)
#   ⭐ DMF0044 와 달리 **조회 원천표 = 저장 대상표**(둘 다 `DM_PLN_SALES_ETC_REPORT_C`)라
#     화면 재조회로 저장 반영을 그대로 관찰할 수 있다(insert_first 경로 불요).
#   ⚠ 조회에 **버전 필수**(MSG00283).
# ================================================================================
_DMF0049_VERSION = "R_S_20260128_V002_C"

SCENARIOS["DMF0049"] = {
    "main_sheet": "MDF Reports",
    # ⚠ 원장 실측(2026-08-10): `DM_PLN_SALES_ETC_REPORT_C` 는 **division 40 · CUTOFF_TYPE='REPORT_SP_W'
    #   단일**(157,842행 / 18 버전). 81·82 는 0행 = **데이터 전제**이지 결함이 아니다.
    #   그래도 메타에는 81 계열·82 전용 컬럼이 있으므로 컬럼 메타 축(C)은 3 division 을 모두 돈다.
    "divisions": ["40", "81", "82"],
    "key_columns": ["DIVISION_ID", "DATA_SEQ", "MEASURE", "DEPARTMENT_ID", "DEPT_ID"],
    "combos": ["MDF_TYPE", "CALENDAR_YYYY", "DMF0044_MDF_MEASURE",
               "DMF0044_MDF_DEPARTMENT", "DMF0044_DEPARTMENT_TEAM2", "DMF0044_DEPARTMENT_TEAM",
               "DMF0005_REPORT_GROUP2", "ReportGroup3", "END_CUST_REPORT", "SOLD_TO_CUST_REPORT"],
    # D2 축 — 파라미터는 **컬럼 메타에서 자동 산출**(meta_cell_params).
    "cell_combo_params": {},
    "cell_combo_notes": {
        "EndCustomerByDivisionDept@END_CUSTOMER":
            "END_CUSTOMER 컬럼은 AS-IS·TO-BE 메타 모두 VISIBLE_FLAG='N'(숨김) — 셀이 렌더되지 않아 "
            "행 스코프 토큰(@deptId)을 넘길 지점이 없다(2026-08-10 AS-IS DB 직접 대조)",
    },
    # EDIT_FLAG 결정 축 — ⚠ DMF0044 와 **정반대**: DMF0049 는 동적 셀 판정에 EDIT_FLAG 를 쓰지 않는다.
    "edit_flag_axes": "그룹 게이트(DM Planner && div≠82 전면 차단) × Plan/Result 시점 × baseYm × "
                      "sEditMeasure(DM_SR_ETC_CURRENCY — 82='SalesAmt_KRW' 뿐) × division(40 완화). "
                      "행 EDIT_FLAG 는 동적 셀 규칙에서 미사용(제약매트릭스 §2.3 이중 게이트 비대칭)",
    "search_filters": lambda div, user, group: {
        "divisionId": div,
        "mdfType": "REPORT_SP_W",
        "yyyy": "2025",
        "spVersionNo": _DMF0049_VERSION,
        # FE 규약 1:1 — `EtcSalesReports.tsx` 는 session.userId 를 userGroup 으로 넘긴다(CMBO 없음).
        #   SP 는 2026-08-09 AUTHUNION 적용으로 USER_ID 가 와도 보유그룹으로 해석된다.
        "userGroup": user,
        "sesUserId": user, "userId": user, "mnuId": "DMF0049",
    },
    "search_buttons": ["SEARCH"],
    "aux_buttons": [],
    "result_cursor": "data",
    "modal_sheets": [
        {"sheet": "spreadTitle", "btn": "SEARCH", "filters": lambda div, user, group: {
            "divisionId": div, "sesUserId": user, "startDt": "20250101", "endDt": "20251231",
            "userId": user, "mnuId": "DMF0049"}},
        {"sheet": "measure", "btn": "SEARCH", "filters": lambda div, user, group: {
            "divisionId": div, "userId": user, "mnuId": "DMF0049"}},
        # unitedVersion / titleSet 은 PKG_DMF0044·공통 SP 를 API_ID 만 DMF0049_ 로 재배선한 것
        {"sheet": "unitedVersion", "btn": "SEARCH", "filters": lambda div, user, group: {
            "divisionId": div, "sdt": "20240101", "edt": "20271231",
            "versionType": "REPORT_SP_W", "description": "", "userId": user, "mnuId": "DMF0049"}},
        {"sheet": "titleSet", "btn": "SEARCH", "filters": lambda div, user, group: {
            "programId": "DMF0049", "sheetName": "MDF Reports", "columnType": "C",
            "sesUserId": user, "divisionId": div, "mnuId": "DMF0049"}},
    ],
    "save_roundtrip": {
        "division": "40",
        # DATA_SEQ 가 행 유일키 — SAVE SP 도 이 키로 DELETE→INSERT 한다(BODY L1062~1066).
        "row_filter": lambda r: str(r.get("DATA_SEQ") or "").strip() != "",
        "cell_prefix": "M_",
        "date_window": [f"2025{m:02d}" for m in range(1, 13)],
        "identity_keys": ("DIVISION_ID", "DATA_SEQ", "MEASURE"),
        # ⛔ I/D 왕복 금지 — 2026-08-10 실사고. `activeFlag='I'` 여도 payload 의 dataSeq 가 기존 값이면
        #   SP 가 "DATA_SEQ 존재" 분기(BODY L1058~1066 DELETE→INSERT)를 타고, 이어지는 'D' 가
        #   **원래 있던 행을 삭제**한다(DATA_SEQ=126 / SalesAmt_LOC / 20250101 소실 → 수동 복원).
        #   진짜 신규행은 `dataSeq=''` + 새 식별자여야 하는데, 그러면 SP 가 MAX(DATA_SEQ) 로 채번해
        #   재조회 키(DATA_SEQ)가 사전에 확정되지 않는다. 안전한 설계가 나오기 전까지 **생략**한다.
        "insert_delete_safe": False,
        "insert_delete_note":
            "DMF0049 SAVE SP 는 dataSeq 존재 시 DELETE→INSERT 경로를 타므로 'D' 가 실데이터를 지운다"
            "(2026-08-10 실사고·복원 완료). C 축은 화면 Insert/Delete 버튼으로 육안 확인 필요",
        # ⛔ 2026-08-11 — M(수정) 왕복도 차단. 08-10 에는 I/D 만 막았는데 M 도 같은 위험임이 실증됐다.
        "modify_safe": False,
        "modify_note":
            "조회가 Oracle PIVOT 이라 러너가 읽는 셀은 **표시값(SUM)** 이고, 그 값을 payload 로 되쓰면 "
            "단일 원장 행에 내려앉는다. 게다가 저장 SP 가 payload 에 없는 DEPT_NAME 을 마스터값으로 "
            "갱신하므로(BODY L1059~1060 — AS-IS 파리티) **원복해도 원상태가 아니다**. "
            "2026-08-11 실사고: DATA_SEQ=120/SalesAmt_KRW/20250701 의 QTY·NICK_NAME·"
            "FORECAST_INFO_SPEC 훼손(복원 완료). M 축은 화면 육안 확인 대상",
        # buildEtcReportSaveRows 35키 1:1 (PROC_M 36 IN − sesUserId(BE 주입)).
        #   키가 하나라도 남거나 모자라면 generic call-proc 이 -9994 로 떨어진다.
        "payload": lambda row, ymd, qty, user: {
            "activeFlag": "M",
            "resultMonth": "",
            "divisionId": s(row, "DIVISION_ID"),
            "versionNo": s(row, "VERSION_NO") or _DMF0049_VERSION,
            "dataSeq": s(row, "DATA_SEQ"),
            "departmentId": s(row, "DEPARTMENT_ID"),
            "departmentEditFlag": "false",
            "departmentName": s(row, "T_DEPARTMENT_NAME") or s(row, "DEPARTMENT_NAME"),
            "deptId": s(row, "DEPT_ID"),
            "custReport": s(row, "CUST_REPORT"),
            "endCustReport": s(row, "END_CUST_REPORT"),
            "soldtoCode": s(row, "SOLDTO_CODE"),
            "soldtoCustReport": s(row, "SOLDTO_CUST_REPORT"),
            "productGroup": s(row, "PRODUCT_GROUP"),
            "itemId": s(row, "ITEM_ID"),
            "productDetails": s(row, "PRODUCT_DETAILS"),
            "currency": s(row, "CURRENCY"),
            "companyId": s(row, "COMPANY_ID"),
            "bizType": s(row, "BIZ_TYPE"),
            "applicationGr": s(row, "APPLICATION_GR"),
            "application": s(row, "APPLICATION"),
            "countryCode": s(row, "COUNTRY_CODE"),
            "projectCode": s(row, "PROJECT_CODE"),
            "scmSiteId": s(row, "SCM_SITE_ID"),
            "fcstType": s(row, "FCST_TYPE"),
            "itemUse": s(row, "ITEM_USE"),
            "soldtoCountry": s(row, "SOLDTO_COUNTRY"),
            "shiptoCountry": s(row, "SHIPTO_COUNTRY"),
            "endCustomer": s(row, "END_CUSTOMER"),
            "etcDescr": s(row, "ETC_DESCR"),
            "cellModelInfo": s(row, "CELL_MODEL_INFO"),
            "cellModel": s(row, "CELL_MODEL"),
            "measure": s(row, "MEASURE"),
            "yyyymmdd": ymd,
            "qty": str(qty),
        },
    },
}

# ---------------------------------------------------------------------------
# SDM1010 Project Registration (2026-08-13 등록) — AS-IS 부재 순수 신규 (hook #134)
#   조회 = PKG_SDM1010.P_SDM1010_GET_TAB1_PJT_REG (9 IN / OUT data·result)
#   저장 = P_SDM1010_SAVE_TAB1_PJT_REG (sesUserId + data CLOB[JSON rows])
#   ⚠ SAVE/REQ/CANCEL/POP SAVE 왕복은 `crud_roundtrip_sdm1010.py` 가 SP 직접으로 전담
#     (2026-08-13 PASS 18/FAIL 0 — CLOB JSON 계약은 러너 F축 스칼라 모델과 불일치라 여기선 생략)
SCENARIOS["SDM1010"] = {
    "main_sheet": "TAB1",
    "divisions": ["81"],
    "key_columns": ["DPJT_KEY", "DIVISION_ID", "DPJT_NAME", "DPJT_REG_STATUS"],
    "combos": ["MyDivision", "EndCustomerByDivision", "DpjtClass", "StackMethod",
               "CellTypeByDivision", "BizTypeByDivision", "PlantByDivisionCompany", "EndCustomer"],
    "cell_combo_params": {},
    "cell_combo_notes": {
        "PlantByDivisionCompany":
            "SDM1010 은 company 조회조건이 없는 화면 — 설계서 콤보 지정이 'PlantByDivisionCompany' 뿐이고 "
            "파라미터 명세 부재. @divisionId 만 전달(공유 콤보 SQL 은 @companyId 빈값=전체 허용 설계)이 의도 동작",
    },
    "edit_flag_axes": "행 상태 단일 축 — 신규(C) 또는 DPJT_REG_STATUS='DRAFT' 만 편집(제약 P-15/P-17). "
                      "EDIT_FLAG 컬럼 없음(INPUT_TP_CD IM/IO × 상태 가드)",
    "search_filters": lambda div, user, group: {
        "divisionId": div, "endCustomer": "ALL", "dpjtAuthType": "ALL", "dpjtRegStatus": "ALL",
        "regCompDateFr": "20260701", "regCompDateTo": "20260930",
        "userGroup": group or user, "sesUserId": user, "mnuId": "SDM1010",
    },
    "search_buttons": ["SEARCH"],
    "aux_buttons": [],
    "result_cursor": "data",
    "modal_sheets": [
        {"sheet": "TAB2", "btn": "SEARCH", "filters": lambda div, user, group: {
            "divisionId": div, "endCustomer": "ALL", "dpjtAuthType": "ALL", "dpjtRegStatus": "ALL",
            "regCompDateFr": "20260701", "regCompDateTo": "20260930",
            "sesUserId": user, "mnuId": "SDM1010"}},
        {"sheet": "POP1_TREE", "btn": "SEARCH", "filters": lambda div, user, group: {
            "sesUserId": user, "mnuId": "SDM1010"}},
        {"sheet": "POP1_GRID1", "btn": "SEARCH", "filters": lambda div, user, group: {
            "deptId": "30083990", "sesUserId": user, "mnuId": "SDM1010"}},
        {"sheet": "POP1_GRID2", "btn": "SEARCH", "filters": lambda div, user, group: {
            "dpjtKey": "-", "sesUserId": user, "mnuId": "SDM1010"}},
        {"sheet": "POP1_GRID4", "btn": "SEARCH", "filters": lambda div, user, group: {
            "dpjtKey": "-", "sesUserId": user, "mnuId": "SDM1010"}},
        {"sheet": "POP2_GRID5", "btn": "SEARCH", "filters": lambda div, user, group: {
            "dpjtKey": "-", "sesUserId": user, "mnuId": "SDM1010"}},
    ],
}


def _this_week_monday():
    """금주 월요일 yyyymmdd — FE thisWeekMonday() 와 동일 원천(조회 P_NOW_YYYYMMDD)."""
    d = datetime.date.today()
    return (d - datetime.timedelta(days=d.weekday())).strftime("%Y%m%d")


def _bp_payload(row, ymd, qty, user):
    """DMF0042 SAVE 21키 — `business-plan.save.ts identityOf` + `division.ts read*Slot` 1:1."""
    div = s(row, "DIVISION_ID")
    is40 = div.startswith("40")
    is82 = div.startswith("82")
    project = (s(row, "END_CUSTOMER40") if is40
               else (s(row, "PROJECT_CODE82") or s(row, "PROJECT_CODE")) if is82
               else s(row, "PROJECT_CODE"))
    site = (s(row, "SCM_SITE_ID40") if is40
            else (s(row, "SCM_SITE_ID82") or s(row, "SCM_SITE_ID81")) if is82
            else s(row, "SCM_SITE_ID81"))
    inco = ((s(row, "INCOTERMS82") or s(row, "INCOTERMS")) if is82 else s(row, "INCOTERMS"))
    biz = (s(row, "BIZ_TYPE_NAME40") if is40
           else (s(row, "BIZ_TYPE_NAME82") or s(row, "BIZ_TYPE_NAME81")))
    return {
        "createdBy": user, "lastUpdatedBy": user, "activeFlag": "M",
        "divisionId": div, "projectCode": project, "projectName": s(row, "PROJECT_NAME"),
        "scmSiteId": site, "plantSiteId": s(row, "PLANT_SITE_ID"),
        "itemId": s(row, "ITEM_ID40") if is40 else s(row, "ITEM_ID"),
        "fcstType": s(row, "FCST_TYPE") or " ",       # 공란 ' ' (ParameterString L3148)
        "incoterms": inco or " ",
        "itemUse": s(row, "ITEM_USE"), "unitEnergy": s(row, "UNIT_ENERGY") or "0",
        "measure": s(row, "MEASURE"), "yyyymm": ymd, "qty": str(qty),
        "currency": s(row, "CURRENCY"),
        "deptId": s(row, "DEPT_ID40") if is40 else s(row, "DEPT_ID"),
        "endCustomer": s(row, "END_CUSTOMER40") if is40 else s(row, "END_CUSTOMER"),
        "bizType": biz, "cellProdSite": s(row, "CELL_PROD_SITE"),
    }


def s(row, k):
    v = row.get(k)
    return "" if v is None else str(v)


def fetch_cell_combos(menu):
    """화면의 셀 콤보를 **컬럼 단위**로 수집 — [(sheet, column, cid, 토큰집합, meta)].

    ui_gate_runner 섹션 7 과 동일 기준: TRIM 공백 센티널 제외 + FPComboBox 만
    (FPModal 은 모달 검색 API 로 해소 — CMBO 대상 아님).

    ⭐ 2026-08-10 — 종전에는 `DISTINCT CELL_COMBO_DATA_TYPE` 으로 **CMBO 단위**만 모았다.
      그러면 같은 CMBO 를 쓰는 컬럼들이 서로 다른 파라미터를 갖는 경우(DMF0044 `DM_LOOKUP_DIV` =
      BIZ_TYPE(div40/ATTR1='40') · ITEM_USE(div82/ATTR1='DM_ITEM_USE'))를 **한 번의 전역 파라미터로
      뭉뚱그려** 판정하게 되어, 정상 컬럼이 비정상으로(또는 그 반대로) 뒤집힌다.
      AS-IS 공급 계약(SpreadInfo.cs L1975~1981 ← {화면}_GET_SPREAD_TITLE)이 애초에 **컬럼 스코프**다.
    """
    import re as _re

    sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
    import oracledb
    from ora import conn_info

    u, p, d = conn_info()
    out, tok_cache = [], {}
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            """SELECT C.SHEET_NAME, C.COLUMN_NAME, C.CELL_COMBO_DATA_TYPE,
                      C.DIVISION_ID, C.ATTRIBUTE1, C.ATTRIBUTE3
                 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE C.PROGRAM_ID = :m
                  AND TRIM(C.CELL_COMBO_DATA_TYPE) IS NOT NULL
                  AND C.CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox'
                  AND NVL(C.VALID_YN,'Y') = 'Y'
                ORDER BY C.CELL_COMBO_DATA_TYPE, C.SHEET_NAME, C.COLUMN_NAME""",
            {"m": menu},
        )
        rows = cur.fetchall()
        for sheet, col, cid, div, a1, a3 in rows:
            if cid not in tok_cache:
                cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s",
                            {"s": cid})
                row = cur.fetchone()
                sql = (row[0].read() if hasattr(row[0], "read") else str(row[0])) if row else ""
                tok_cache[cid] = set(_re.findall(r"@(\w+)", sql))
            out.append((sheet, col, cid, tok_cache[cid],
                        {"division": (div or "").strip(), "attr1": (a1 or "").strip(),
                         "attr3": (a3 or "").strip()}))
    return out


def meta_cell_params(cid, meta, toks, fallback_div):
    """AS-IS 공급 계약 1:1 로 컬럼의 셀 콤보 파라미터를 산출 (FE 배선과 동일 규약).

    `{화면}_GET_SPREAD_TITLE` 이 커서에 채워 SpreadInfo.cs 가 sParam1~5 로 넘기는 값:
      ATTRIBUTE1 = @p_division_id                                       → param1
      CASE WHEN CELL_COMBO_DATA_TYPE='DM_LOOKUP_DIV' THEN C.ATTRIBUTE1  → param2
      C.ATTRIBUTE3                                                      → param3
    값은 FE 와 동일하게 따옴표로 감싼다(bind-combo quoting 규약).
    """
    # ⚠ SHEET_COLUMNS.DIVISION_ID 는 **다중 값**일 수 있다('40,81,81_UC,…' — 그 컬럼이 보이는 division 목록).
    #   그대로 파라미터에 넣으면 SEGMENT1 매칭이 깨져 조용히 0행이 된다(2026-08-10 DMF0042 FCST_TYPE 실측).
    #   런타임에 실제로 넘어가는 값은 **선택된 division 하나**이므로, 목록에 시나리오 기준 division 이
    #   있으면 그것을, 없으면 목록의 첫 값을 쓴다.
    divs = [x.strip() for x in (meta["division"] or "").split(",") if x.strip()]
    div = fallback_div if (not divs or fallback_div in divs) else divs[0]
    cand = {"divisionId": div, "param1": div,
            "param2": meta["attr1"] if cid == "DM_LOOKUP_DIV" else "",
            "param3": meta["attr3"]}
    return {k: f"'{v}'" for k, v in cand.items() if k in toks and v}

class R:
    def __init__(self):
        self.lines, self.fails, self.warns = [], 0, 0
    def h(self, t):
        self.lines.append(f"\n## {t}")
        print(f"\n## {t}")
    def ok(self, t):
        self.lines.append(f"- PASS | {t}"); print(f"  PASS | {t}")
    def warn(self, t):
        self.warns += 1; self.lines.append(f"- ⚠ WARN | {t}"); print(f"  WARN | {t}")
    def fail(self, t):
        self.fails += 1; self.lines.append(f"- ⛔ FAIL | {t}"); print(f"  FAIL | {t}")
    def note(self, t):
        self.lines.append(f"- {t}"); print(f"  {t}")

# ⭐ 2026-08-15 — 클라우드 BE 교체분 로그인 계약 변화 대응.
#   구 BE: 미등록 ID 도 200 + `guest:true` 세션 → 'guest is not False' 단언이 유일한 방어였다.
#   신 BE(Spring Security JsonLoginFilter): 미등록 ID = **HTTP 401 `-9998 Authentication Error`**
#     (실측 2026-08-15), 성공 응답에 `guest`/`groups`/`div` 키가 **아예 없다**.
#   → 구 단언을 그대로 두면 전 계정이 FAIL(무력화). 단언을 **약화하지 않고 원천을 옮긴다**:
#     ① 401/비200 = 실패 ② result.userId 가 요청 ID 와 일치 ③ menus 비어 있지 않음(진짜 세션)
#     ④ 구 BE 호환 — `guest:true` 가 오면 여전히 FAIL
#     ⑤ groups/div 는 **DB 권위 원천**에서 채운다(SCM_ADM_USER_GR_MPG_M / USER_GR_UNIT_AUTH_MPG_M).
#        로그인 응답의 표시명보다 정확하다(resolve_group 의 CMBO 우선 규약은 그대로).
_GROUP_CACHE = {}

def _db_user_context(user):
    """USER_GR_MPG_M 보유 그룹 + UNIT_AUTH division — 권한 판정의 권위 원천."""
    if user in _GROUP_CACHE:
        return _GROUP_CACHE[user]
    import oracledb
    from ora import conn_info as _ci
    u, pw, d = _ci()
    with oracledb.connect(user=u, password=pw, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
                        WHERE USER_ID = :1 AND USE_YN = 'Y' ORDER BY USER_GR_ID""", [user])
        groups = [r[0] for r in cur.fetchall()]
        cur.execute("""SELECT DISTINCT UNIT_ID FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
                        WHERE USER_ID = :1 AND UNIT_TP_CD = 'D' ORDER BY UNIT_ID""", [user])
        divs = [r[0] for r in cur.fetchall()]
    _GROUP_CACHE[user] = (groups, divs)
    return groups, divs


def login(base, user, rep):
    sess = requests.Session()
    r = sess.post(f"{base}/user/login", json={"userId": user}, timeout=30)
    if r.status_code != 200:
        body = (r.text or "")[:120]
        rep.fail(f"[{user}] 로그인 HTTP {r.status_code} — {body}"); return None, None
    info = (r.json() or {}).get("result") or {}
    if info.get("guest") is True:  # 구 BE 호환 가드
        rep.fail(f"[{user}] 게스트 폴백(guest=True) — 권한 검증 무의미"); return None, None
    if str(info.get("userId") or "") != user:
        rep.fail(f"[{user}] 세션 userId 불일치({info.get('userId')}) — 로그인 무효"); return None, None
    if not (info.get("menus") or []):
        rep.fail(f"[{user}] 메뉴 0건 — 미등록/권한 없음 계정(권한 검증 무의미)"); return None, None
    groups, divs = _db_user_context(user)
    if not groups:
        rep.fail(f"[{user}] 보유 그룹 0건(SCM_ADM_USER_GR_MPG_M) — 권한 판정 불가"); return None, None
    info["groups"], info["div"] = groups, ",".join(divs)
    rep.ok(f"[{user}] 로그인 세션 획득 — groups={groups} div={info['div'][:40]}")
    return sess, info

def call_proc(sess, base, menu, sheet, btn, filters):
    return sess.post(f"{base}/{menu}/{sheet}/{btn}/call-proc", json=filters, timeout=300)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--menu", required=True)
    ap.add_argument("--base", default="http://localhost:8080")
    ap.add_argument("--users", default=DEFAULT_USERS,
                    help="기본 = minyonglee1(primary 실왕복) + Division별 공식 테스트 계정 14종(사용자 지정 로스터)")
    ap.add_argument("--no-save", action="store_true", help="SAVE 왕복 생략")
    a = ap.parse_args()
    sc = SCENARIOS.get(a.menu)
    if not sc:
        sys.exit(f"ERROR: 시나리오 미등록 메뉴 {a.menu} — SCENARIOS 에 추가(hook #125 §2)")
    users = [u.strip() for u in a.users.split(",") if u.strip()]
    primary = users[0]
    rep = R()
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M")
    rep.lines.append(f"# {a.menu} BE HTTP 셀프 E2E 리포트 — {ts}")
    rep.lines.append(f"> 러너: ui_http_e2e.py (hook #125 §2) · base={a.base} · users={users} · primary={primary}")

    sessions = {}
    rep.h("A. 로그인 (세션 실재 단언 — userId·menus + DB 그룹)")
    for u in users:
        sess, info = login(a.base, u, rep)
        if sess:
            sessions[u] = (sess, info)
    if primary not in sessions:
        rep.fail("primary 계정 세션 실패 — 중단")
        finish(rep, a.menu, ts); sys.exit(1)
    psess, pinfo = sessions[primary]

    def resolve_group(sess, info, uid):
        """조회 SP 의 `userGroup`(P_USERINFO) 원천 — **FE 와 동일 경로**로 해석한다.

        ⚠️ 2026-08-09 실측 — 로그인 응답의 `groups[0]`('DM Administrator' 등 표시명)을 그대로 쓰면
          AS-IS `GET_ADMIN_GROUP` lookup(USER_GR_ID 코드값)과 매칭되지 않아 **EDIT_FLAG 가 전 행 'N'**
          이 되고, SAVE 왕복이 "편집가능 후보 없음"으로 조용히 생략된다(무력 검증).
          FE(useBusinessPlanStore.authGroup)는 화면 전용 CMBO 1행을 쓴다 — 그 경로를 그대로 따른다.
        """
        cid = sc.get("auth_group_combo")
        if cid:
            r = sess.post(f"{a.base}/admin/combo", json={"comboId": cid}, timeout=60)
            if r.status_code == 200:
                rows = (r.json() or {}).get("result") or []
                if rows:
                    return str(rows[0].get("CODE") or rows[0].get("code") or uid)
        return (info.get("groups") or [uid])[0]

    pgroup = resolve_group(psess, pinfo, primary)
    rep.note(f"userGroup(P_USERINFO) 해석 = '{pgroup}'"
             + (f" (CMBO '{sc['auth_group_combo']}')" if sc.get("auth_group_combo") else " (groups[0])"))

    rep.h("B. 메뉴 접근·버튼 권한·단위(Division) 편집권한 (/access, /auth)")
    auth_by_user, unit_by_user = {}, {}
    for u, (sess, _info) in sessions.items():
        acc = sess.get(f"{a.base}/admin/menu/{a.menu}/access", timeout=30)
        au = sess.get(f"{a.base}/admin/menu/{a.menu}/auth", timeout=30)
        btns, units = [], {}
        if au.status_code == 200:
            res = (au.json() or {}).get("result") or {}
            # 실측 스키마(2026-08-07): {"mnuBtnAuth": ["SEARCH","SAVE",...], "unitAuth":[{unitTpCd,unitId,editYn,editable}]}
            raw = res.get("mnuBtnAuth") if isinstance(res, dict) else None
            if isinstance(raw, list):
                btns = [str(x) if not isinstance(x, dict) else
                        str(x.get("mnuBtnCd") or x.get("MNU_BTN_CD") or "") for x in raw]
                btns = [b for b in btns if b]
            for ua in (res.get("unitAuth") or []) if isinstance(res, dict) else []:
                if isinstance(ua, dict) and ua.get("unitId"):
                    units[str(ua["unitId"])] = bool(ua.get("editable"))
        auth_by_user[u] = set(btns)
        unit_by_user[u] = units
        rep.note(f"[{u}] access={acc.status_code} auth={au.status_code} "
                 f"buttons={sorted(set(btns))} unitAuth(editable)={units}")
    if not auth_by_user.get(primary):
        rep.fail(f"[{primary}] 버튼 권한 목록 0건 — /auth 스키마 변경 또는 권한 미배선(권한 검증 불가)")

    rep.h("C. 컬럼·메저 메타 (division별)")
    for div in sc["divisions"]:
        c = psess.post(f"{a.base}/admin/menu/{a.menu}/column",
                       json={"sheetNm": sc["main_sheet"], "divisionId": div}, timeout=60)
        m = psess.post(f"{a.base}/admin/menu/{a.menu}/measure",
                       json={"sheetNm": sc["main_sheet"], "divisionId": div}, timeout=60)
        cols = (c.json() or {}).get("result") or [] if c.status_code == 200 else []
        meas = (m.json() or {}).get("result") or [] if m.status_code == 200 else []
        names = {str(x.get("colNm") or x.get("COLUMN_NAME") or "") for x in cols if isinstance(x, dict)}
        req = list(sc["key_columns"]) + list((sc.get("key_columns_by_division") or {}).get(div, []))
        missing = [k for k in req if k not in names]
        if c.status_code != 200 or not cols:
            rep.fail(f"div={div} column 메타 {c.status_code} rows={len(cols)}")
        elif missing:
            rep.fail(f"div={div} 필수 키 컬럼 부재: {missing} (컬럼 {len(cols)}개)")
        else:
            rep.ok(f"div={div} column={len(cols)} / measure={len(meas)} / 필수 키 {len(req)}종 전부 존재")

    rep.h("D. 콤보 전 키 (0행 = 조용한 빈콤보 검출)")
    # ⭐ 2026-08-15 — **FE 와 같은 엔드포인트로 부른다**(`/admin/combo` 단건).
    #   구현: `useTabComboQueries` → `apiClient.getCombo` → POST /admin/combo (콤보 1건당 1회).
    #   ⚠ 종전 러너는 `/admin/combo-muti` 를 썼는데, BE `retrieveComboMuti` 는 세션 값을
    #     `userId`/`langCd` 로 넣고 `retrieveCombo`(단건)만 `sesUserId`/`sesLangCd` 로 넣는다
    #     (LookupServiceImpl L78·L100 실측). CMBO SQL 은 `@sesUserId` 를 쓰므로 muti 경로에서는
    #     '' 치환 → **0행**. 화면은 멀쩡한데 러너만 WARN 을 뱉는 오탐이었다
    #     (실측 2026-08-15: MktFcstUserGroups / MktFcstUserEditDivision — 단건 호출은 각각 6·8행).
    for k in sc["combos"]:
        r = psess.post(f"{a.base}/admin/combo", json={"comboId": k}, timeout=60)
        if r.status_code != 200:
            rep.fail(f"combo '{k}' HTTP {r.status_code}"); continue
        body = r.json() or {}
        if str(body.get("code")) != "0":
            rep.fail(f"combo '{k}' code={body.get('code')} {body.get('message')}"); continue
        res = body.get("result")
        v = res.get(k) if isinstance(res, dict) else res
        n = len(v) if isinstance(v, list) else -1
        # 조회조건 콤보의 0행은 데이터 미적재 가능성이 있어 WARN 유지 (셀 콤보는 D2 에서 FAIL 승격)
        (rep.warn if n <= 0 else rep.ok)(f"combo '{k}' rows={n}")

    rep.h("D2. 셀 콤보 — 메타 자동 수집 + FE 실전달 파라미터 (0행 = FAIL, hook #117 §5.6)")
    # 하드코딩 금지: 화면의 셀 콤보는 SHEET_COLUMNS 실측에서 수집한다(누락 원천 차단).
    #   AS-IS UP_FX 계통의 핵심은 "@CODE + PARAM" 이므로 파라미터를 실제로 넘겨 호출하고,
    #   무전달 호출과 행수를 비교해 "파라미터가 실제로 먹었다"를 증명한다.
    cell_params = sc.get("cell_combo_params", {})
    try:
        cell_combos = fetch_cell_combos(a.menu)
    except Exception as e:  # noqa: BLE001 — DB 미가용은 판정이 아니라 환경 사유
        cell_combos = None
        rep.warn(f"셀 콤보 메타 수집 불가(DB) — {e}")
    if cell_combos is not None:
        if not cell_combos:
            rep.warn(f"PROGRAM_ID='{a.menu}' 셀 콤보 0종 — 그리드 콤보 미사용 화면이면 정상")
        zero_ok = sc.get("cell_combo_zero_ok", {})
        seen_probe = {}
        for sheet, col, cid, toks, meta in cell_combos:
            need = sorted(t for t in toks if t not in ("sesUserId", "sesLangCd"))
            # 메타(컬럼 스코프) 우선 → 시나리오 전역값은 메타가 못 채우는 토큰만 보충
            sent = meta_cell_params(cid, meta, need, sc["divisions"][0])
            sent.update({k: v for k, v in cell_params.items() if k in need and k not in sent})
            probe_key = (cid, tuple(sorted(sent.items())))
            where = f"{sheet}.{col}"
            if probe_key in seen_probe:          # 동일 CMBO·동일 파라미터 = 이미 실증됨
                seen_probe[probe_key].append(where)
                continue
            seen_probe[probe_key] = [where]
            rw = psess.post(f"{a.base}/admin/combo", json={"comboId": cid, **sent}, timeout=60)
            n_with = len(rw.json().get("result") or []) if rw.status_code == 200 else -1
            n_wo = n_with
            if sent:
                rb = psess.post(f"{a.base}/admin/combo", json={"comboId": cid}, timeout=60)
                n_wo = len(rb.json().get("result") or []) if rb.status_code == 200 else -1
            miss = [t for t in need if t not in sent]
            notes = sc.get("cell_combo_notes", {})
            note = notes.get(f"{cid}@{col}") or notes.get(cid)
            tag = f"combo '{cid}' [{where}] rows={n_with}" + (f" (무전달 {n_wo})" if sent else "")
            tag += f" 필요토큰={need or '-'} 전달={sorted(sent) or '-'}"
            if n_with <= 0:
                # 0행이 **AS-IS 파리티로 실증된** 컬럼만 사유와 함께 통과 (일반 note 로는 못 가린다)
                z = zero_ok.get(f"{cid}@{col}")
                (rep.ok if z else rep.fail)(
                    tag + (f" — 0행 파리티: {z}" if z else " — 셀 콤보 0행 = 그리드가 CODE 를 raw 로 표시"))
            elif miss and note:
                # 미전달이지만 처리 경로가 문서화된 경우 = 판정 통과(사유를 함께 남긴다)
                rep.ok(tag + f" — 미전달 {miss}: {note}")
            elif miss:
                rep.warn(tag + f" — 미전달 {miss} (사유 미기재 — cell_combo_notes 에 처리 경로를 명시할 것)")
            else:
                rep.ok(tag)

    rep.h("E. 조회 (FE 실사용 버튼 + 부가 배선)")
    main_rows_by_div = {}
    for div in sc["divisions"]:
        for btn in sc["search_buttons"]:
            f = sc["search_filters"](div, primary, pgroup)
            r = call_proc(psess, a.base, a.menu, sc["main_sheet"], btn, f)
            if r.status_code != 200:
                rep.fail(f"div={div} {btn} HTTP {r.status_code} — {r.text[:120]}"); continue
            body = (r.json() or {}).get("result") or {}
            rows = body.get(sc["result_cursor"]) or body.get("o_rc1") or []
            ef = sorted({str(x.get("EDIT_FLAG")) for x in rows if isinstance(x, dict)}) if rows else []
            rep.ok(f"div={div} {btn} rows={len(rows)} EDIT_FLAG={ef}")
            main_rows_by_div[div] = rows
        for aux in sc.get("aux_buttons", []):
            f = aux["filters"](div, primary, pgroup)
            r = call_proc(psess, a.base, a.menu, sc["main_sheet"], aux["btn"], f)
            if r.status_code != 200:
                rep.fail(f"div={div} {aux['btn']} HTTP {r.status_code} ({aux['note']}) — {r.text[:120]}")
            else:
                body = (r.json() or {}).get("result") or {}
                rows = body.get(aux["cursor"]) or []
                rep.ok(f"div={div} {aux['btn']} rows={len(rows)} ({aux['note']})")
        if div in sc.get("readonly_divisions", []):
            rows = main_rows_by_div.get(div) or []
            bad = [1 for x in rows if isinstance(x, dict) and str(x.get("EDIT_FLAG")) != "N"]
            if rows and bad:
                rep.fail(f"div={div} 조회 전용인데 EDIT_FLAG!='N' {len(bad)}행")
            elif rows:
                rep.ok(f"div={div} 조회 전용 — 전행 EDIT_FLAG='N' 확인({len(rows)}행)")

    rep.h("G. 모달 시트 API 전수")
    for ms in sc["modal_sheets"]:
        f = ms["filters"](sc["divisions"][0], primary, pgroup)
        r = call_proc(psess, a.base, a.menu, ms["sheet"], ms["btn"], f)
        if r.status_code != 200:
            rep.fail(f"modal '{ms['sheet']}' {ms['btn']} HTTP {r.status_code} — {r.text[:120]}")
        else:
            body = (r.json() or {}).get("result") or {}
            total = sum(len(v) for v in body.values() if isinstance(v, list))
            rep.ok(f"modal '{ms['sheet']}' {ms['btn']} 커서 {list(body.keys())} rows={total}")

    if not a.no_save and "save_roundtrip" in sc:
        rep.h("F. SAVE 왕복 (primary — M +1 → 재조회 → 원복 → 재조회)")
        sr = sc["save_roundtrip"]
        # ⭐ 2026-08-09 — 화면마다 동적 셀 컬럼 접두와 행 식별키가 다르다(DMF0082 `D_yyyymmdd` /
        #   DMF0042 `M_yyyymm`). 하드코딩하면 신규 화면에서 후보를 못 찾고 조용히 WARN 으로 빠진다.
        pfx = sr.get("cell_prefix", "D_")
        idkeys = sr.get(
            "identity_keys",
            ("PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
             "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE"),
        )
        # ⭐ 2026-08-10 — 조회 조건과 **저장 관찰 조건이 다른** 화면이 있다(DMF0044: ETC(DataType=2)
        #   그리드는 DM_PLN_SALES_ETC_REPORT_C 를 읽는데 ETC SAVE 는 DM_PLN_SALES_PLAN_REPORT_C 에 쓴다.
        #   같은 조건으로 재조회하면 반영이 **구조적으로 보이지 않는다**). 시나리오가 관찰 조건을 지정할 수 있게 한다.
        save_filters = sr.get("search_filters") or sc["search_filters"]
        if sr.get("search_filters"):
            rr = call_proc(psess, a.base, a.menu, sc["main_sheet"], sc["search_buttons"][0],
                           save_filters(sr["division"], primary, pgroup))
            rows = ((rr.json() or {}).get("result") or {}).get(sc["result_cursor"]) or []
            rep.note(f"SAVE 관찰용 별도 조회(div={sr['division']}) rows={len(rows)} — {sr.get('search_note','')}")
        else:
            rows = main_rows_by_div.get(sr["division"]) or []
        cand = None
        for row in rows:
            if not sr["row_filter"](row):
                continue
            for ymd in sr["date_window"]:
                v = row.get(pfx + ymd)
                if v is not None and float(v or 0) > 0:
                    cand = (row, ymd, float(v)); break
            if cand:
                break
        if sr.get("save_mode") == "insert_first":
            # ⭐ 화면 재조회로는 저장 반영을 관찰할 수 없는 화면 전용 경로 (원장 직접 검증).
            #   I(신규) → M(수정) → D(삭제) 를 **우리가 만든 행 위에서** 돌린다.
            #   기존 행을 건드리지 않으므로 원장 오염 위험이 없고, MERGE 의 INSERT/UPDATE/DELETE
            #   3분기를 모두 실증한다.
            probe, cleanup = sr["ledger_probe"], sr.get("cleanup")
            import oracledb
            from ora import conn_info
            u2, p2, d2 = conn_info()

            def ledger(row, ymd):
                with oracledb.connect(user=u2, password=p2, dsn=d2) as c:
                    cur2 = c.cursor()
                    cur2.execute(probe["sql"], probe["binds"](row, ymd))
                    r = cur2.fetchone()
                return None if r is None else float(r[0] or 0)

            target, tdate = None, None
            for cr in rows:
                if not sr["row_filter"](cr):
                    continue
                for d in sr["date_window"]:
                    if ledger(cr, d) == 0:      # 원장에 아직 없는 (행 × 월)
                        target, tdate = cr, d
                        break
                if tdate:
                    break
            if not tdate:
                rep.warn(f"div={sr['division']} 원장 미존재 (행×월) 후보 없음 — SAVE 왕복 생략 "
                         "(데이터 전제조건 §3 확인)")
            else:
                def send(flag, qty):
                    p = sr["payload"](target, tdate, qty, primary)
                    p["activeFlag"] = flag
                    return call_proc(psess, a.base, a.menu, sc["main_sheet"],
                                     sr.get("save_button", "SAVE"), p)

                desc = f"{s(target,'ITEM_ID')}/{s(target,'MEASURE')} {pfx}{tdate}"
                rep.note(f"관찰 = 원장 직접 조회({sr.get('ledger_note','')}) · 대상 {desc}")
                for flag, qty, expect, label in (("I", 7, 7, "INSERT(MERGE NOT MATCHED)"),
                                                 ("M", 9, 9, "UPDATE(MERGE MATCHED)"),
                                                 ("D", 0, 0, "DELETE")):
                    r = send(flag, qty)
                    got = ledger(target, tdate)
                    ok = (got == expect) and r.status_code == 200
                    (rep.ok if ok else rep.fail)(
                        f"{label} activeFlag='{flag}' HTTP {r.status_code} → 원장 QTY = {got} (기대 {expect})")
                if cleanup:
                    try:
                        with oracledb.connect(user=u2, password=p2, dsn=d2) as c:
                            cur2 = c.cursor()
                            cur2.execute(cleanup["sql"],
                                         cleanup["binds"](target, tdate, primary))
                            n = cur2.rowcount
                            c.commit()
                        rep.ok(f"테스트 잔존 정리 {n}건 (정확 키 · 본인 갱신분 한정)")
                    except Exception as e:  # noqa: BLE001
                        rep.warn(f"잔존 정리 실패(수동 확인 필요): {str(e)[:160]}")
        # ⛔ 2026-08-11 안전장치 (M 축) — I/D 뿐 아니라 **M(수정) 왕복도 실데이터를 훼손**할 수 있다.
        #   DMF0049 실사고: 조회가 Oracle PIVOT(암묵 GROUP BY = SELECT 목록 전 컬럼)이라 러너가 읽는
        #   셀 값은 **표시값(SUM)** 이고, 그걸 payload 로 되쓰면 단일 원장 행에 내려앉는다. 게다가 저장 SP 가
        #   payload 에 없는 컬럼(DEPT_NAME 등)을 마스터값으로 갱신하므로 **원복해도 원상태가 아니다**.
        #   실측 피해: (DATA_SEQ=120/SalesAmt_KRW/20250701) QTY 0.0→655826 / NICK_NAME NULL→'M53F1A'
        #             / FORECAST_INFO_SPEC NULL→'21700' (형제 11개월 + VERSION_NO 포함 이력으로 기준선
        #             확정 후 복원 — `dmf0049_e2e_save_damage_restore.py`).
        #   ⚠ 이 분기는 M 뿐 아니라 **그 안에 중첩된 I/D 블록까지** 건너뛴다(I/D 는 M 후보 행을 기반으로
        #     동작하므로 분리 불가). 그래서 아래에서 `insert_delete_safe` 와의 정합을 함께 확인한다.
        elif sr.get("modify_safe") is False:
            # ⭐ 2026-08-12 — `modify_probe` 가 정의된 화면은 생략 대신 **전용 테스트 키 M 왕복**을 실행한다.
            #   실데이터 행을 건드리는 일반 왕복과 달리, 실 CRUD 검증(권한별)에서 만들어 둔
            #   테스트 소유 키(QTY 0 잔존형) 위에서만 쓰고-확인하고-0 으로 되돌린다.
            probe = sr.get("modify_probe")
            if probe:
                pu = probe["user"]
                psess2 = sessions.get(pu, (None, None))[0]
                if psess2 is None:
                    psess2 = requests.Session()
                    psess2.post(f"{a.base}/user/login", json={"userId": pu}, timeout=30)
                def probe_save(qty):
                    return call_proc(psess2, a.base, a.menu, sc["main_sheet"], "SAVE",
                                     probe["payload"](qty, pu))
                def probe_cursor(r):
                    body = (r.json() or {}).get("result") or {} if r.status_code == 200 else {}
                    rc = body.get("O_RESULT_CURSOR") or []
                    return (rc[0] if rc else {"CODE": "0", "MSG": "(빈 결과커서=성공)"})
                def probe_read():
                    # 매칭 행이 버킷/표시축으로 다행일 수 있어 셀값 **집합**으로 판정한다.
                    f = probe["verify_filters"](pu)
                    rr = call_proc(psess2, a.base, a.menu, sc["main_sheet"], "SEARCH", f)
                    rs = ((rr.json() or {}).get("result") or {}).get(sc["result_cursor"]) or []
                    vals = []
                    for x in rs:
                        if probe["row_match"](x):
                            v = x.get(probe["cell"])
                            if v not in (None, ""):
                                vals.append(float(v))
                    return vals
                qv = probe.get("probe_qty", 7)
                rep.note("M 왕복(전용 키) — %s" % probe.get("note", ""))
                # ⭐ 2026-08-15 — 판정 기준 = **MAX** (사용자 확정).
                #   이 probe 는 "내가 쓴 값이 그 셀에 그대로 보이는가" 를 본다. 표시 셀이 중복행
                #   합산으로 부풀면 max 가 쓴 값보다 커진다 → 그건 **제품 결함**이지 판정 오류가 아니다.
                #   (증분 방식은 채택하지 않는다 — 합산 자체를 정상으로 인정해 버려 부풀림을 못 잡는다.)
                a0 = probe_read()
                r1 = probe_cursor(probe_save(qv))
                (rep.ok if str(r1.get("CODE")) == "0" else rep.fail)(
                    f"M 저장(qty={qv}) 결과커서 CODE={r1.get('CODE')} {str(r1.get('MSG'))[:60]}")
                a1 = probe_read()
                mx = max(a1) if a1 else None
                (rep.ok if mx is not None and abs(mx - float(qv)) < 1e-6 else rep.fail)(
                    f"재조회 반영 — cell {probe['cell']} max={mx} (기대 {qv}) 값 {a1}"
                    + ("" if mx is None or mx <= float(qv) else
                       f" ⚠ 부풀림 {mx/float(qv):.3g}배 — 표시 컬럼이 같은 행이 합산되고 있다"))
                r2 = probe_cursor(probe_save(0))
                (rep.ok if str(r2.get("CODE")) == "0" else rep.fail)(
                    f"원복 저장(qty=0) 결과커서 CODE={r2.get('CODE')}")
                a2 = probe_read()
                # 원복 판정도 MAX 기준 — 쓴 값이 사라졌는지 본다(기준선 a0 로 복귀).
                mx2 = max(a2) if a2 else None
                base_mx = max(a0) if a0 else None
                (rep.ok if (mx2 is None or abs(mx2 - float(qv)) > 1e-6) else rep.fail)(
                    f"재조회 원복 — cell {probe['cell']} max={mx2} (기준선 {base_mx} 복귀, {qv} 소거) 값 {a2}")
                rep.note("실데이터 무접촉 — 테스트 소유 키 한정. 일반 행 M/I/D 는 계속 차단(사유 아래)")
            rep.warn("일반 행 M 왕복 생략(파괴 위험) — %s" % sr.get(
                "modify_note", "이 화면의 SAVE 왕복은 원복해도 원상태로 돌아가지 않는다"))
            if sr.get("insert_delete_safe") is not False:
                rep.warn("I/D 왕복도 함께 생략됨 — M 후보 행에 종속된 경로다. "
                         "의도한 것이면 `insert_delete_safe: False` 도 명시할 것(계약 정합)")
            if not probe:
                rep.note("⇒ M/I/D 축은 화면 육안 확인 대상. 원장 직접 검증이 필요하면 "
                         "`save_mode: 'insert_first'`(우리가 만든 행 위에서만 왕복) 설계로 전환할 것")
        elif not cand:
            rep.warn(f"div={sr['division']} 편집가능 행/일자 후보 없음 — SAVE 왕복 생략(데이터 전제조건 §3 확인)")
        else:
            row, ymd, v0 = cand
            key_desc = f"{s(row,'ITEM_ID')}@{s(row,'SCM_SITE_ID')} D_{ymd}"
            def do_save(qty):
                return call_proc(psess, a.base, a.menu, sc["main_sheet"], "SAVE",
                                 sr["payload"](row, ymd, qty, primary))
            def re_read():
                f = save_filters(sr["division"], primary, pgroup)
                r = call_proc(psess, a.base, a.menu, sc["main_sheet"], "SEARCH", f)
                body = (r.json() or {}).get("result") or {}
                rs = body.get(sc["result_cursor"]) or []
                for x in rs:
                    if all(s(x, k) == s(row, k) for k in idkeys):
                        return float(x.get(pfx + ymd) or 0)
                return None
            r1 = do_save(v0 + 1)
            rep.note(f"SAVE +1 HTTP {r1.status_code} — {key_desc}")
            a1 = re_read()
            (rep.ok if a1 == v0 + 1 else rep.fail)(f"재조회 +1 반영 = {a1} (기대 {v0+1})")
            r2 = do_save(v0)
            a2 = re_read()
            (rep.ok if a2 == v0 else rep.fail)(f"재조회 원복 = {a2} (기대 {v0})")

            # ── INSERT(신규 행) → 저장 → 재조회 → D(삭제) → 정리 (hook #125 §1 — C 축 HTTP 경유 실증)
            #   ⚠️ M 후보 행이 전 일자에 값을 가질 수 있어 I 후보(빈 셀)는 **독립 탐색**한다.
            #   ⛔ 2026-08-10 안전장치 — 화면에 따라 이 경로는 **기존 행을 파괴**한다.
            #     DMF0049 실측: `activeFlag='I'` 여도 payload 의 dataSeq 가 기존 값이면 SP 가 UPDATE 경로
            #     (DELETE→INSERT)를 타고, 뒤이은 'D' 가 **원래 있던 행을 지운다**(DATA_SEQ=126 실사고).
            #     그런 화면은 `insert_delete_safe: False` 로 명시하고 사유와 함께 생략한다 —
            #     조용한 생략이 아니라 리포트에 남긴다.
            irow, idate = None, None
            if sr.get("insert_delete_safe") is False:
                rep.warn(
                    "I/D 왕복 생략(파괴 위험) — %s" % sr.get(
                        "insert_delete_note",
                        "이 화면의 SAVE SP 는 'D' 가 기존 행을 삭제할 수 있다"))
            else:
                for cr in rows:
                    if not sr["row_filter"](cr):
                        continue
                    for d in sr["date_window"]:
                        v = cr.get(pfx + d)
                        if v is None or float(v or 0) == 0:
                            irow, idate = cr, d
                            break
                    if idate:
                        break
            if idate:
                row = irow  # payload/재조회 키를 I 후보 행으로 전환
            if sr.get("insert_delete_safe") is False:
                pass
            elif not idate:
                rep.warn("INSERT 대상 빈 일자 없음 — I 왕복 생략(데이터 전제조건 §3)")
            else:
                def do_flag(flag, qty, ymd):
                    p = sr["payload"](row, ymd, qty, primary)
                    p["activeFlag"] = flag
                    return call_proc(psess, a.base, a.menu, sc["main_sheet"], "SAVE", p)

                def read_at(ymd):
                    f = save_filters(sr["division"], primary, pgroup)
                    rr = call_proc(psess, a.base, a.menu, sc["main_sheet"], "SEARCH", f)
                    rs = ((rr.json() or {}).get("result") or {}).get(sc["result_cursor"]) or []
                    for x in rs:
                        if all(s(x, k) == s(row, k) for k in
                               ("PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
                                "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE")):
                            return float(x.get(pfx + ymd) or 0)
                    return None

                ri = do_flag("I", 7, idate)
                rep.note(f"INSERT(activeFlag='I', qty=7) HTTP {ri.status_code} — D_{idate}")
                ai = read_at(idate)
                (rep.ok if ai == 7 else rep.fail)(f"INSERT 후 재조회 = {ai} (기대 7)")
                rd = do_flag("D", 0, idate)
                ad = read_at(idate)
                (rep.ok if ad in (0, None) else rep.fail)(f"DELETE 후 재조회 = {ad} (기대 0)")
                # 원장 잔존(QTY 0 물리 저장분) 정리 — 정확 키 한정, 사전 부재분만
                try:
                    import oracledb
                    from ora import conn_info
                    u2, p2, d2 = conn_info()
                    with oracledb.connect(user=u2, password=p2, dsn=d2) as con2:
                        c2 = con2.cursor()
                        c2.execute("""DELETE FROM SCM_MGR.DM_PLN_MKT_FCST WHERE DIVISION_ID=:d
                            AND PROJECT_CODE=:pc AND SCM_SITE_ID=:s AND ITEM_ID=:i AND DOM_EXP=:de
                            AND FCST_TYPE=:ft AND INCOTERMS=:ic AND MEASURE=:m AND YYYYMMDD=:y
                            AND NVL(QTY,0)=0 AND LAST_UPDATED_BY=:u""",
                            dict(d=s(row, "DIVISION_ID"), pc=s(row, "PROJECT_CODE"), s=s(row, "SCM_SITE_ID"),
                                 i=s(row, "ITEM_ID"), de=s(row, "DOM_EXP"), ft=s(row, "FCST_TYPE"),
                                 ic=s(row, "INCOTERMS"), m=s(row, "MEASURE"), y=idate, u=primary))
                        n = c2.rowcount
                        con2.commit()
                    rep.ok(f"테스트 잔존 정리 {n}건 (원장 복원 — 정확 키·QTY 0·본인 갱신분 한정)")
                except Exception as e:
                    rep.warn(f"잔존 정리 실패(수동 확인 필요): {str(e)[:120]}")
        # 조회 전용 division SAVE 거부 확인 (거부 기대 — 부작용 없음)
        for div in sc.get("readonly_divisions", []):
            rows = main_rows_by_div.get(div) or []
            if not rows:
                continue
            row = rows[0]
            r = call_proc(psess, a.base, a.menu, sc["main_sheet"], "SAVE",
                          sr["payload"](row, sr["date_window"][0], 1, primary))
            body = (r.json() or {}).get("result") or {} if r.status_code == 200 else {}
            txt = json.dumps(body, ensure_ascii=False)[:300]
            blocked = (r.status_code != 200) or ("조회 전용" in txt) or ("'F'" in txt) or ('"F"' in txt)
            (rep.ok if blocked else rep.fail)(f"div={div} SAVE 거부 확인 — HTTP {r.status_code} {txt[:120]}")

    rep.h("H. 다계정 권한 매트릭스 (auth 목록 ↔ 실호출 대조 — Division별 공식 로스터)")
    for u, (sess, info) in sessions.items():
        grp = resolve_group(sess, info, u)
        rdiv, rrole = ROSTER.get(u, (sc["divisions"][0], "primary"))
        f = sc["search_filters"](rdiv, u, grp)
        r = call_proc(sess, a.base, a.menu, sc["main_sheet"], "SEARCH", f)
        has_search = "SEARCH" in auth_by_user.get(u, set())
        status_ok = (r.status_code == 200) if has_search else (r.status_code in (200, 403))
        rows = []
        if r.status_code == 200:
            rows = ((r.json() or {}).get("result") or {}).get(sc["result_cursor"]) or []
        (rep.ok if status_ok else rep.fail)(
            f"[{u} · div{rdiv} {rrole}] SEARCH(div={rdiv}) HTTP {r.status_code} rows={len(rows)} "
            f"(auth SEARCH={'Y' if has_search else 'N'})")

        # 단위(Division) 편집권한 ↔ 행 EDIT_FLAG 정합 (hook #125 §5)
        #
        # ⚠️ 2026-08-09 정정 — `unitAuth.editable` 과 `EDIT_FLAG` 는 **서로 다른 축**이라 1:1 로 기대하면 안 된다.
        #   unitAuth = division 단위 편집권(PKG_NSCM_UI_COM_AUTH), EDIT_FLAG = 조회 SP 가 **행마다** 계산한 값.
        #   DMF0042 실측(AS-IS `DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA` L425~426 ↔ TO-BE L2050~2051, 1:1):
        #       CASE WHEN (행의 DEPT_ID) = v_dept_id THEN 'Y'      -- 내 부서 행
        #            WHEN v_group_id = 'ADMIN'       THEN 'Y'      -- ADMIN 그룹
        #            ELSE 'N' END
        #   ⇒ 비-ADMIN 계정이 **본인 부서 행에서만 'Y'** 를 받는 N/Y 혼재는 **정상**이다.
        #     구 문구("measure 권한 축 병존")는 틀린 라벨이었다 — 실제는 **부서(DEPT_ID) 축**.
        #   따라서 판정은 "혼재 여부"가 아니라 **전 행 N 인데 편집권이 있다(=아무것도 못 고침)** 같은
        #   명백한 모순만 본다. 축 대응표(edit_flag_axes)를 준 화면은 그 설명을 함께 남긴다.
        editable = unit_by_user.get(u, {}).get(rdiv)
        axes = sc.get("edit_flag_axes", "부서(DEPT_ID) 일치 OR 권한그룹 ADMIN")
        # ⭐ 2026-08-12 — 행 게이트 컬럼은 화면마다 다르다 (DMF0021 = SALES_PLAN_ADJUST_YN 'N_Y').
        #   시나리오 edit_flag_column/edit_flag_editable_value 로 오버라이드 (기본 EDIT_FLAG/'Y').
        ef_col = sc.get("edit_flag_column", "EDIT_FLAG")
        ef_yes = sc.get("edit_flag_editable_value", "Y")
        if rows and editable is not None:
            ef = {str(x.get(ef_col)) for x in rows if isinstance(x, dict)}
            if rdiv in sc.get("readonly_divisions", []):
                (rep.ok if ef_yes not in ef else rep.fail)(
                    f"[{u}] div{rdiv} 조회전용 — {ef_col}={sorted(ef)} (기대 {ef_yes} 부재)")
            elif editable is False:
                rep.ok(f"[{u}] unitAuth editable=false · {ef_col}={sorted(ef)} "
                       f"— 행 단위 축({axes})으로 결정. 혼재 정상")
            elif ef_yes in ef:
                rep.ok(f"[{u}] unitAuth editable=true · {ef_col}={sorted(ef)} (편집 가능 행 존재)")
            else:
                note = sc.get("edit_flag_all_n_ok", {}).get(u)
                if note:
                    # 편집 후보 0행이지만 **AS-IS 파리티로 검증된** 케이스 — 사유를 남기고 통과
                    rep.ok(f"[{u}] {ef_col} 편집 후보 0행 — AS-IS 파리티 확인됨: {note}")
                else:
                    rep.warn(f"[{u}] unitAuth editable=true 인데 {ef_col} 편집 후보('{ef_yes}') 0행 "
                             f"— 축({axes}) 어디에도 걸리지 않음. 데이터/권한 전제 확인")

        # [WS 2026-08-07] 그룹별 FCST_TYPE 콤보 화이트리스트 실증 (AS-IS 파리티)
        gce = sc.get("group_combo_expect")
        if gce:
            cr = sess.post(f"{a.base}/admin/combo", json={"comboId": gce["combo"]}, timeout=60)
            codes = set()
            if cr.status_code == 200:
                rr = (cr.json() or {}).get("result") or []
                codes = {str(x.get("CODE")) for x in rr if isinstance(x, dict)}
            is_ws = gce["ws_group"] in (info.get("groups") or [])
            if is_ws:
                (rep.ok if codes == gce["ws_codes"] else rep.fail)(
                    f"[{u}] W/S 그룹 FCST_TYPE 콤보 = {sorted(codes)} (기대 {sorted(gce['ws_codes'])} 한정)")
            else:
                bad = codes & gce["other_excluded"]
                (rep.ok if codes and not bad else rep.fail)(
                    f"[{u}] 일반 그룹 FCST_TYPE 콤보 {len(codes)}종 — 배제 대상 유입 {sorted(bad) or '없음'}")

        # SAVE 버튼 권한 없는 계정 = 403 기대 (SP 도달 전 차단 — 부작용 없음)
        if u != primary and auth_by_user.get(u) and "SAVE" not in auth_by_user[u]:
            rs = call_proc(sess, a.base, a.menu, sc["main_sheet"], "SAVE", {"activeFlag": ""})
            (rep.ok if rs.status_code == 403 else rep.fail)(
                f"[{u}] SAVE(버튼권한 없음) HTTP {rs.status_code} (기대 403)")

    finish(rep, a.menu, ts)
    sys.exit(1 if rep.fails else 0)

def finish(rep, menu, ts):
    verdict = "FAIL" if rep.fails else ("WARN" if rep.warns else "PASS")
    rep.lines.insert(2, f"\n## 종합: **{verdict}** (FAIL {rep.fails} / WARN {rep.warns})")
    out = pathlib.Path(__file__).resolve().parents[1] / "_gate_reports" / f"{menu}_http_e2e_{ts}.md"
    out.parent.mkdir(exist_ok=True)
    out.write_text("\n".join(rep.lines) + "\n", encoding="utf-8", newline="\n")
    print(f"\n== 종합 {verdict} — 리포트: {out}")

if __name__ == "__main__":
    main()
