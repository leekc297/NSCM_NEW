#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ui_http_e2e.py — BE HTTP 셀프 E2E 러너 (hook #125 ui-selfcheck-runtime-mandatory §2, 2026-08-07)

FE 와 동일 경로(세션 쿠키 + call-proc/메타/콤보 API)로 화면 전 기능 축을 실행·판정한다.
브라우저 없이 클로드코드가 "전체 기능 구현 완료"를 실증하는 도구 — 사용자는 시각 확인만.

사용:
  python ui_http_e2e.py --menu DMF0082 [--users minyonglee1,bpark416,DM_V_TEST] [--base http://localhost:8080] [--no-save]

축: A 로그인(isGuest 단언) / B 메뉴 접근·버튼 권한 / C 컬럼·메저 메타(division별) / D 콤보 전 키(0행 검출)
    / E SEARCH·SEARCH_CURRENT(division별 행수·키 컬럼·EDIT_FLAG) / F SAVE 왕복(M +1→재조회→원복 — primary 계정만)
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
        "key_columns": ["DIVISION_ID", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID", "CELL_PROD_SITE_ID"],
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
}

def s(row, k):
    v = row.get(k)
    return "" if v is None else str(v)


def fetch_cell_combos(menu):
    """화면의 셀 콤보 (SQL_ID, 필요 @토큰 집합) 를 SHEET_COLUMNS 실측으로 수집.

    ui_gate_runner 섹션 7 과 동일 기준: TRIM 공백 센티널 제외 + FPComboBox 만
    (FPModal 은 모달 검색 API 로 해소 — CMBO 대상 아님).
    """
    import re as _re

    sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
    import oracledb
    from ora import conn_info

    u, p, d = conn_info()
    out = []
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            """SELECT DISTINCT C.CELL_COMBO_DATA_TYPE
                 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE C.PROGRAM_ID = :m
                  AND TRIM(C.CELL_COMBO_DATA_TYPE) IS NOT NULL
                  AND C.CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox'
                  AND NVL(C.VALID_YN,'Y') = 'Y'
                ORDER BY 1""",
            {"m": menu},
        )
        for (cid,) in cur.fetchall():
            cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s", {"s": cid})
            row = cur.fetchone()
            sql = (row[0].read() if hasattr(row[0], "read") else str(row[0])) if row else ""
            out.append((cid, set(_re.findall(r"@(\w+)", sql))))
    return out

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

def login(base, user, rep):
    sess = requests.Session()
    r = sess.post(f"{base}/user/login", json={"userId": user}, timeout=30)
    if r.status_code != 200:
        rep.fail(f"[{user}] 로그인 HTTP {r.status_code}"); return None, None
    info = (r.json() or {}).get("result") or {}
    # ⚠️ 실측 2026-08-07: 응답 키는 'guest'(불리언). 'isGuest' 는 **존재하지 않음** → None(falsy) 이라
    #   isGuest 로 단언하면 미등록 ID 도 통과하는 무력 단언이 된다(실제로 겪음).
    if info.get("guest") is not False:
        rep.fail(f"[{user}] 게스트 폴백(guest={info.get('guest')}) — 미등록/GUEST 그룹 계정, 권한 검증 무의미")
        return None, None
    groups = info.get("groups") or []
    if not groups:
        rep.fail(f"[{user}] 보유 그룹 0건 — 권한 판정 불가")
        return None, None
    rep.ok(f"[{user}] 로그인 세션 획득 — groups={groups} div={info.get('div')}")
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
    rep.h("A. 로그인 (isGuest 단언)")
    for u in users:
        sess, info = login(a.base, u, rep)
        if sess:
            sessions[u] = (sess, info)
    if primary not in sessions:
        rep.fail("primary 계정 세션 실패 — 중단")
        finish(rep, a.menu, ts); sys.exit(1)
    psess, pinfo = sessions[primary]
    pgroup = (pinfo.get("groups") or [primary])[0]

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
        missing = [k for k in sc["key_columns"] if k not in names]
        if c.status_code != 200 or not cols:
            rep.fail(f"div={div} column 메타 {c.status_code} rows={len(cols)}")
        elif missing:
            rep.fail(f"div={div} 필수 키 컬럼 부재: {missing} (컬럼 {len(cols)}개)")
        else:
            rep.ok(f"div={div} column={len(cols)} / measure={len(meas)} / 필수 키 {len(sc['key_columns'])}종 전부 존재")

    rep.h("D. 콤보 전 키 (0행 = 조용한 빈콤보 검출)")
    cm = psess.post(f"{a.base}/admin/combo-muti",
                    json={"comboList": [{"comboId": k} for k in sc["combos"]]}, timeout=120)
    if cm.status_code != 200:
        rep.fail(f"combo-muti HTTP {cm.status_code}")
    else:
        res = (cm.json() or {}).get("result") or {}
        arr = res if isinstance(res, list) else [res.get(k) for k in sc["combos"]] if isinstance(res, dict) else []
        for k, v in zip(sc["combos"], arr):
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
        for cid, toks in cell_combos:
            need = sorted(t for t in toks if t not in ("sesUserId", "sesLangCd"))
            sent = {k: v for k, v in cell_params.items() if k in need}
            rw = psess.post(f"{a.base}/admin/combo", json={"comboId": cid, **sent}, timeout=60)
            n_with = len(rw.json().get("result") or []) if rw.status_code == 200 else -1
            n_wo = n_with
            if sent:
                rb = psess.post(f"{a.base}/admin/combo", json={"comboId": cid}, timeout=60)
                n_wo = len(rb.json().get("result") or []) if rb.status_code == 200 else -1
            miss = [t for t in need if t not in sent]
            note = sc.get("cell_combo_notes", {}).get(cid)
            tag = f"combo '{cid}' rows={n_with}" + (f" (무전달 {n_wo})" if sent else "")
            tag += f" 필요토큰={need or '-'} 전달={sorted(sent) or '-'}"
            if n_with <= 0:
                rep.fail(tag + " — 셀 콤보 0행 = 그리드가 CODE 를 raw 로 표시")
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
        rows = main_rows_by_div.get(sr["division"]) or []
        cand = None
        for row in rows:
            if not sr["row_filter"](row):
                continue
            for ymd in sr["date_window"]:
                v = row.get("D_" + ymd)
                if v is not None and float(v or 0) > 0:
                    cand = (row, ymd, float(v)); break
            if cand:
                break
        if not cand:
            rep.warn(f"div={sr['division']} 편집가능 행/일자 후보 없음 — SAVE 왕복 생략(데이터 전제조건 §3 확인)")
        else:
            row, ymd, v0 = cand
            key_desc = f"{s(row,'ITEM_ID')}@{s(row,'SCM_SITE_ID')} D_{ymd}"
            def do_save(qty):
                return call_proc(psess, a.base, a.menu, sc["main_sheet"], "SAVE",
                                 sr["payload"](row, ymd, qty, primary))
            def re_read():
                f = sc["search_filters"](sr["division"], primary, pgroup)
                r = call_proc(psess, a.base, a.menu, sc["main_sheet"], "SEARCH", f)
                body = (r.json() or {}).get("result") or {}
                rs = body.get(sc["result_cursor"]) or []
                for x in rs:
                    if all(s(x, k) == s(row, k) for k in
                           ("PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
                            "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE")):
                        return float(x.get("D_" + ymd) or 0)
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
            irow, idate = None, None
            for cr in rows:
                if not sr["row_filter"](cr):
                    continue
                for d in sr["date_window"]:
                    v = cr.get("D_" + d)
                    if v is None or float(v or 0) == 0:
                        irow, idate = cr, d
                        break
                if idate:
                    break
            if idate:
                row = irow  # payload/재조회 키를 I 후보 행으로 전환
            if not idate:
                rep.warn("INSERT 대상 빈 일자 없음 — I 왕복 생략(데이터 전제조건 §3)")
            else:
                def do_flag(flag, qty, ymd):
                    p = sr["payload"](row, ymd, qty, primary)
                    p["activeFlag"] = flag
                    return call_proc(psess, a.base, a.menu, sc["main_sheet"], "SAVE", p)

                def read_at(ymd):
                    f = sc["search_filters"](sr["division"], primary, pgroup)
                    rr = call_proc(psess, a.base, a.menu, sc["main_sheet"], "SEARCH", f)
                    rs = ((rr.json() or {}).get("result") or {}).get(sc["result_cursor"]) or []
                    for x in rs:
                        if all(s(x, k) == s(row, k) for k in
                               ("PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
                                "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE")):
                            return float(x.get("D_" + ymd) or 0)
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
        grp = (info.get("groups") or [u])[0]
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

        # 단위(Division) 편집권한 ↔ 행 EDIT_FLAG 정합 — 역할별 편집 가부가 실제로 갈리는지 (hook #125 §5)
        editable = unit_by_user.get(u, {}).get(rdiv)
        if rows and editable is not None:
            ef = {str(x.get("EDIT_FLAG")) for x in rows if isinstance(x, dict)}
            if rdiv in sc.get("readonly_divisions", []):
                (rep.ok if ef <= {"N"} else rep.fail)(
                    f"[{u}] div{rdiv} 조회전용 — EDIT_FLAG={sorted(ef)} (기대 N)")
            elif editable is False:
                (rep.ok if ef <= {"N"} else rep.warn)(
                    f"[{u}] unitAuth editable=false → EDIT_FLAG={sorted(ef)} (기대 N — measure 권한 축 병존)")
            else:
                (rep.ok if "Y" in ef else rep.warn)(
                    f"[{u}] unitAuth editable=true → EDIT_FLAG={sorted(ef)} (기대 Y 포함)")

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
