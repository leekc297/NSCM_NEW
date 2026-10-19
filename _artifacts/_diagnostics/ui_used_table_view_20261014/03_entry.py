"""03_entry.py — 화면별 DB 진입점 확정: '메타 배선 ∩ FE 실호출' (2026-10-14)

입력: meta/*.csv (01_dump), fe_calls.csv / fe_combos.csv / fe_unresolved.csv (02_fe_scan)
출력:
  entries.csv          GROUP, SCREEN, VIA_MENU, SHEET, BTN, KIND, API_ID, OBJECT, FE_EVIDENCE, SQL_LOG_MENU, SQL_LOG_ALL, NOTE
  entry_defects.csv    FE 호출인데 메타 미등록 / API_URL 공란 등
  meta_not_called.csv  범위 메뉴의 BTN_MPG 배선 중 FE 호출이 확인되지 않은 행 (제외 목록)
  combo_review.csv     콤보 리터럴 중 문맥이 약한 후보 (수동 판정 결과 포함)
"""
import csv, re, json, pathlib, collections

D = pathlib.Path(__file__).resolve().parent
FE = pathlib.Path(r"C:\Projects\NSCM\nscm-fe")
L = lambda p: list(csv.DictReader((D / p).open(encoding="utf-8-sig")))
mnu, btn, api, excel, shcol, cmbo, logs = (L(f"meta/{n}.csv") for n in ("mnu_m", "btn_mpg", "api_m", "excel_columns", "sheet_columns", "cmbo_sql", "sql_log_calls"))
calls, combos, unres = L("fe_calls.csv"), L("fe_combos.csv"), L("fe_unresolved.csv")

SCOPE = {
    "SYSTEM": "SYS0003 SYS0007 SYS0008 SYS0001 SYS0004 SYS0016 SYS0017 SCM0016 SCM0007 SCM0019 SYS0005 SYS0006 SYS0009".split(),
    "ADMIN": "SYS0002 SYS0014 SYS0010 SYS0013".split(),
    "DM": ("DMF0004 DMF0005 DMF0006 DMF0007 DMF0020 DMF0043 DMF0043_01 DMF0008 DMF0072 "
           "DMF0003 DMF0048 DMF0014 DMF0042 DMF0044 DMF0049 DMF0074 DMF0082 DMF0021 "
           "DMF0035 DMF0040 DMF0068 DMF0053").split(),
    "AUTHORITY": "SYS0011 SYS0012".split(),   # 2026-10-15 사용자 추가 요청 (Authority > Auth_Mgmt)
}
GROUP_OF = {s: g for g, ss in SCOPE.items() for s in ss}
mnu_by = {r["MNU_ID"]: r for r in mnu}
# 범위 재확인 (최신 덤프 기준: 부모 폴더 + USE_YN=Y + SCREEN)
def parent_chain(m):
    out = []
    while m in mnu_by and mnu_by[m]["UPPR_MNU_ID"]:
        m = mnu_by[m]["UPPR_MNU_ID"]; out.append(m)
    return out
for g, folder in (("SYSTEM", "System"), ("ADMIN", "Admin_Menu"), ("DM", "Demand"), ("AUTHORITY", "Authority")):
    live = sorted(r["MNU_ID"] for r in mnu if r["MNU_TP_CD"] == "SCREEN" and r["USE_YN"] == "Y"
                  and folder in parent_chain(r["MNU_ID"]) and all(mnu_by[p]["USE_YN"] == "Y" for p in parent_chain(r["MNU_ID"]) if p in mnu_by))
    assert sorted(SCOPE[g]) == live, (g, sorted(set(live) ^ set(SCOPE[g])))
print("scope verified against fresh SCM_ADM_MNU_M:", {g: len(v) for g, v in SCOPE.items()})

api_by = {r["API_ID"]: r for r in api}
btn_idx = collections.defaultdict(list)
for b in btn: btn_idx[(b["MNU_ID"], b["SHT_NM"], b["MNU_BTN_CD"])].append(b)
log_menu = collections.Counter(); log_all = collections.Counter()
for r in logs:
    p = (r["PROC"] or "").upper().replace("SCM_MGR.", "")
    log_menu[(r["MNU_ID"], p)] += int(r["CNT"]); log_all[p] += int(r["CNT"])

entries = []; defects = []
def ev(rows): return "; ".join(sorted({f"{r['file']}:{r['line']}" for r in rows}))[:2000]
def add_entry(**k):
    k.setdefault("NOTE", ""); k.setdefault("API_ID", ""); entries.append(k)

# ── 1. call-proc / excel-upload / column-meta 수집 ──
CALL_PATS = {"useTabProcQuery", "useProcMutation", "apiClient.callProc", "apiClient.callMutationProc", "path-call-proc"}
col_sheets = collections.defaultdict(set)   # screen -> {(menu, sheet)}
for s, g in GROUP_OF.items():
    rows = [r for r in calls if s in r["screens"].split()]
    tup = collections.defaultdict(list)
    for r in rows:
        tup[(r["pattern"] in CALL_PATS and "CALLPROC" or r["pattern"], r["menu"], r["sheet"], r["btn"])].append(r)
    for (kind, m, sh, b), rs in sorted(tup.items()):
        if kind == "CALLPROC":
            hits = btn_idx.get((m, sh, b), [])
            if not hits:
                defects.append(dict(GROUP=g, SCREEN=s, VIA_MENU=m, SHEET=sh, BTN=b, ISSUE="FE 호출 (MNU_ID,SHT_NM,BTN) 이 SCM_ADM_MNU_BTN_MPG_M 에 없음 → 런타임 NO_DATA_FOUND(호출 불가)", FE_EVIDENCE=ev(rs)))
                continue
            for h in hits:
                a = api_by.get(h["API_ID"])
                url = (a["API_URL"] if a else "").strip()
                if not a or not url:
                    defects.append(dict(GROUP=g, SCREEN=s, VIA_MENU=m, SHEET=sh, BTN=b, ISSUE=f"API_M 미존재/API_URL 공란 (API_ID={h['API_ID']})", FE_EVIDENCE=ev(rs)))
                    continue
                key = url.upper().replace("SCM_MGR.", "")
                add_entry(GROUP=g, SCREEN=s, VIA_MENU=m, SHEET=sh, BTN=b, KIND="CALLPROC", API_ID=h["API_ID"], OBJECT=key,
                          FE_EVIDENCE=ev(rs), SQL_LOG_MENU=log_menu.get((m, key), 0), SQL_LOG_ALL=log_all.get(key, 0),
                          NOTE=("BTN_USE=N " if h["USE_YN"] != "Y" else "") + ("API_USE=N" if a["USE_YN"] != "Y" else ""))
        elif kind == "path-excel-upload":
            ex = [e for e in excel if e["PROGRAM_ID"] == m and e["SHEET_NAME"] == sh]
            if not ex:
                defects.append(dict(GROUP=g, SCREEN=s, VIA_MENU=m, SHEET=sh, BTN=b, ISSUE="excel-upload 대상 SCM_ADM_EXCEL_COLUMNS 행 없음", FE_EVIDENCE=ev(rs))); continue
            for e in ex:
                key = (e["STORAGE_SQL_ID"] or "").strip().upper().replace("SCM_MGR.", "")
                add_entry(GROUP=g, SCREEN=s, VIA_MENU=m, SHEET=sh, BTN=b, KIND="EXCEL_VALID", OBJECT=key, FE_EVIDENCE=ev(rs),
                          SQL_LOG_MENU=log_menu.get((m, key), 0), SQL_LOG_ALL=log_all.get(key, 0), NOTE=f"VALID_YN={e['VALID_YN']}")
        elif kind in ("meta-column", "meta-measure"):
            if m and sh: col_sheets[s].add((m, sh))
# 수동 해석 (02 미해석 6지점 — 원문 확인 근거는 08 시트에 기재)
MANUAL_SHEETS = {
    "SCM0016": [("SCM0016", "batchLog"), ("SCM0016", "stepInfo"), ("SCM0016", "batchLogHist")],   # useBatchLogStore.ts:102 SHEETS 배열
    "DMF0003": [("DMF0003", "Mkt Fcst")],                                                         # useMktFcstStore.ts:342 [SHEETS.MAIN]
    "DMF0048": [("DMF0048", "Sales Monitoring")],                                                 # useSalesMonitoringStore.ts:359 [SHEETS.MAIN]
    "DMF0020": [("DMF0020", "Sales Price"), ("DMF0020", "Sales Price Save All")],                 # useSalesFuturePriceStore.ts:266/298 ADMIN_SHEET_NAME
    "DMF0035": [("DMF0035", "Mkt Fcst Waterfall"), ("DMF0035", "Sales Plan Waterfall"), ("DMF0035", "Biz Plan Waterfall")],  # GUBUN_META
}
for s, lst in MANUAL_SHEETS.items(): col_sheets[s] |= set(lst)

# ── 2. 그리드 셀 콤보 (SHEET_COLUMNS: VALID_YN='Y' & FPComboBox & CELL_COMBO_DATA_TYPE / ATTRIBUTE9) ──
DIV_SUFFIX = re.compile(r"^[0-9A-Z]{2,5}$")
grid_combo = collections.defaultdict(lambda: collections.defaultdict(set))   # screen -> combo -> {menu/sheet.col}
for s, pairs in col_sheets.items():
    for m, sh in pairs:
        for c in shcol:
            if c["PROGRAM_ID"] != m or c["VALID_YN"] != "Y": continue
            sn = c["SHEET_NAME"]
            if not (sn == sh or (sn.startswith(sh + "_") and DIV_SUFFIX.match(sn[len(sh) + 1:]))): continue
            if (c["CELL_CONTROL_OBJECT_TYPE_CODE"] or "").strip() != "FPComboBox": continue
            for cid in ((c["CELL_COMBO_DATA_TYPE"] or "").strip(), (c["ATTRIBUTE9"] or "").strip()):
                if cid: grid_combo[s][cid].add(f"{m}/{sn}.{c['COLUMN_NAME']}")

# ── 3. 콤보 리터럴 (FE) ──
cmbo_by = {r["SQL_ID"]: r for r in cmbo}
review = []
page_text_cache = {}
def screen_text(s):
    if s in page_text_cache: return page_text_cache[s]
    files = json.load((D / "fe_screen_files.json").open(encoding="utf-8")).get(s, {}).get("files", [])
    page_text_cache[s] = "\n".join((FE / f).read_text(encoding="utf-8", errors="ignore") for f in files)
    return page_text_cache[s]
def jsx_props(t, comp):
    """<comp ...> 태그의 prop 구간 목록 — {} 깊이·따옴표 추적 (prop 안 '=>' 의 '>' 오인 방지)"""
    out = []
    for m in re.finditer(r"<\s*" + re.escape(comp) + r"(?=[\s/>])", t):
        j, depth, q = m.end(), 0, None
        while j < len(t):
            ch = t[j]
            if q:
                if ch == q: q = None
            elif ch in "'\"`" and depth == 0: q = ch
            elif ch == "{": depth += 1
            elif ch == "}": depth -= 1
            elif ch == ">" and depth == 0: break
            j += 1
        out.append(t[m.end():j])
    return out
lit_combo = collections.defaultdict(lambda: collections.defaultdict(list))
for s, g in GROUP_OF.items():
    for r in combos:
        if s not in r["screens"].split(): continue
        k = r["kind"]
        if k == "NONE":
            review.append(dict(SCREEN=s, COMBO=r["combo"], VERDICT="제외(콤보 문맥 아님 — 컬럼키/라벨/미참조 상수 등)", FILE=f"{r['lit_file']}:{r['lit_line']}", NODE=r["via"], CTX=r["ctx"]))
            continue
        if k == "LOOKUP":
            review.append(dict(SCREEN=s, COMBO=r["combo"], VERDICT="제외(lookupType — PR_GET_LOOKUP_INFO_LIST 경로, COMMON)", FILE=f"{r['lit_file']}:{r['lit_line']}", NODE="", CTX=r["ctx"]))
            continue
        if r["default_of"]:
            # comboId 기본값 — 화면이 해당 컴포넌트에 comboId 를 명시 전달하면 기본값은 미사용
            comp = r["node"]
            t = screen_text(s)
            uses = jsx_props(t, comp)
            if uses and all(re.search(r"\bcomboId\s*=", u) for u in uses):
                review.append(dict(SCREEN=s, COMBO=r["combo"], VERDICT="제외(기본값 — 화면이 comboId 명시 전달)", FILE=f"{r['file']}:{r['line']}", NODE=comp, CTX=r["ctx"]))
                continue
        lit_combo[s][r["combo"]].append(r)

for s, g in GROUP_OF.items():
    for cid, rs in sorted(lit_combo[s].items()):
        add_entry(GROUP=g, SCREEN=s, VIA_MENU=s, SHEET="", BTN="", KIND="COMBO", OBJECT=cid, FE_EVIDENCE=ev(rs),
                  SQL_LOG_MENU="", SQL_LOG_ALL="", NOTE="" if cid in cmbo_by and cmbo_by[cid]["USE_YN"] == "Y" else "CMBO USE_YN<>Y")
    for cid, cols in sorted(grid_combo[s].items()):
        if cid not in cmbo_by:
            defects.append(dict(GROUP=g, SCREEN=s, VIA_MENU="", SHEET="", BTN="", ISSUE=f"그리드 콤보 SQL_ID '{cid}' 가 SCM_ADM_CMBO_SQL_M 에 없음", FE_EVIDENCE="; ".join(sorted(cols))[:1000]))
            continue
        add_entry(GROUP=g, SCREEN=s, VIA_MENU="", SHEET="", BTN="", KIND="GRID_COMBO", OBJECT=cid, FE_EVIDENCE="SHEET_COLUMNS: " + "; ".join(sorted(cols))[:1500],
                  SQL_LOG_MENU="", SQL_LOG_ALL="")

# ── 4. 특수 경로 ──
dq = [r for r in calls if "SYS0013" in r["screens"].split()]
add_entry(GROUP="ADMIN", SCREEN="SYS0013", VIA_MENU="SYS0013", SHEET="result", BTN="EXECUTE", KIND="DYNAMIC_QUERY", OBJECT="PKG_SYS0013.P_SYS0013_EXECUTE_QUERY",
          FE_EVIDENCE="packages/foundation/src/apis/axios.ts:189 (/admin/dynamic-query/execute) · DynamicQueryController", SQL_LOG_MENU="", SQL_LOG_ALL=log_all.get("PKG_SYS0013.P_SYS0013_EXECUTE_QUERY", 0),
          NOTE="사용자 입력 SQL 을 실행 — 대상 테이블 정적 확정 불가")
add_entry(GROUP="ADMIN", SCREEN="SYS0013", VIA_MENU="SYS0013", SHEET="result", BTN="EXECUTE", KIND="DYNAMIC_QUERY", OBJECT="PKG_SYS0013.P_SYS0013_VALIDATE_QUERY",
          FE_EVIDENCE="packages/foundation/src/apis/axios.ts:198 (/admin/dynamic-query/validate)", SQL_LOG_MENU="", SQL_LOG_ALL=log_all.get("PKG_SYS0013.P_SYS0013_VALIDATE_QUERY", 0))

# ── 5. COMMON 프레임워크 (BE 매퍼 + FE 실사용 엔드포인트) ──
COMMON = [
    ("PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST", "call-proc 공통 (GeneralServiceImpl.execBtn) — 모든 화면 버튼"),
    ("PKG_NSCM_UI_COM_AUTH.PR_CHECK_MNU_BTN_AUTH", "CustomAuthorizationManager — 모든 call-proc/excel-upload 권한 검사"),
    ("PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH", "GET /admin/menu/{id}/auth ← shared/hooks/useTabBtnPermissions.ts:42"),
    ("PKG_NSCM_UI_COM_AUTH.PR_GET_UNIT_AUTH", "GET /admin/menu/{id}/auth (동일 엔드포인트에서 함께 호출)"),
    ("PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST", "POST /admin/menu/{id}/column ← 화면 store fetchStaticColumns·titleSetApi"),
    ("PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_MEASURE_LIST", "POST /admin/menu/{id}/measure ← PIVOT 화면 store"),
    ("PKG_NSCM_UI_COM_MENU.PR_ADD_USER_BMK", "POST /admin/menu/favorite ← shared/stores/useSessionStore.ts:121"),
    ("PKG_NSCM_UI_COM_MENU.PR_REMOVE_USER_BMK", "POST /admin/menu/favorite (favorite=false)"),
    ("PKG_SCM0000.P_SCM0000_GET_SRCH_COND", "GET /admin/menu/{id}/search-conditions ← 화면 store"),
    ("PKG_SCM0000.P_SCM0000_SAVE_SRCH_COND", "POST /admin/menu/{id}/search-conditions"),
    ("PKG_SCM0000.P_SCM0000_RESET_SRCH_COND", "POST /admin/menu/{id}/search-conditions/reset ← foundation/utils/gridAction.ts:959"),
    ("DMF0002_GET_TITLESET_POPUP", "POST /admin/menu/{id}/titleset/search ← shared/.../titleSetApi.ts:41"),
    ("SCM0002_SET_TITLESET_POPUP", "POST /admin/menu/{id}/titleset ← shared/.../titleSetApi.ts:85"),
    ("PR_GET_MENU_LIST_V2", "로그인/세션 (CustomUserDetailsService.retrieveMenus) ← /user/login·/user/session"),
    ("PKG_NSCM_UI_COM_USER.PR_GET_NSCM_USER", "로그인/세션 사용자 조회 ← /user/login·/user/session"),
    ("PKG_NSCM_UI_COM_USER.PR_UPDATE_LANG_CD", "POST /user/session/lang-cd ← useSessionStore.ts:116"),
    ("PKG_NSCM_UI_COM_LOOKUP.PR_GET_LOOKUP_INFO_LIST", "POST /admin/lookup ← foundation/apis/axios.ts:184 getLookup"),
    ("PKG_NSCM_UI_EXCEL.PR_SAVE_EXCEL_UPLOAD", "POST /{m}/{s}/{b}/excel-upload 1단계 (FileServiceImpl)"),
    ("PKG_NSCM_UI_EXCEL.PR_GET_EXCEL_UPLOAD_RESULT", "excel-upload 3단계 결과 조회"),
]
for obj, why in COMMON:
    add_entry(GROUP="COMMON", SCREEN="(공통)", VIA_MENU="", SHEET="", BTN="", KIND="FRAMEWORK", OBJECT=obj, FE_EVIDENCE=why,
              SQL_LOG_MENU="", SQL_LOG_ALL=log_all.get(obj, 0))
# 홈 공지 (apps/web/src/pages/useHomeNotices.ts:115 → /notice/home → execBtn(SYS0016/main/SEARCH))
for h in btn_idx.get(("SYS0016", "main", "SEARCH"), []):
    a = api_by.get(h["API_ID"]); key = a["API_URL"].strip().upper().replace("SCM_MGR.", "")
    add_entry(GROUP="COMMON", SCREEN="(공통-홈 공지)", VIA_MENU="SYS0016", SHEET="main", BTN="SEARCH", KIND="CALLPROC", API_ID=h["API_ID"], OBJECT=key,
              FE_EVIDENCE="apps/web/src/pages/useHomeNotices.ts:115 → NoticeController /notice/home", SQL_LOG_MENU=log_menu.get(("SYS0016", key), 0), SQL_LOG_ALL=log_all.get(key, 0))
# 직접 SQL 테이블 (매퍼 XML / JDBC)
DIRECT = [
    ("SCM_ADM_MSG_M", "SELECT", "GET /admin/message (Message.xml retrieveMessage) ← foundation/lib/i18n.ts:79"),
    ("SCM_ADM_CMBO_SQL_M", "SELECT", "POST /admin/combo (Lookup.xml getQuery) — 콤보 SQL 본문 조회"),
    ("SCM_ADM_EXCEL_COLUMNS", "SELECT", "excel-upload (Excel.xml selectExcelInfo)"),
    ("SCM_COM_SYS_LOG", "INSERT", "LogInterceptor/SystemLogAspect insertSysLog (모든 요청 로그)"),
    ("SCM_COM_SQL_LOG", "INSERT", "QueryLogInterceptor JDBC INSERT (application.yml logging-enabled: true)"),
]
for t, op, why in DIRECT:
    add_entry(GROUP="COMMON", SCREEN="(공통)", VIA_MENU="", SHEET="", BTN="", KIND="DIRECT_SQL", OBJECT=t, FE_EVIDENCE=why, SQL_LOG_MENU="", SQL_LOG_ALL="", NOTE=op)

# ── 6. 메타 배선 중 FE 미호출 (제외 목록) ──
used_keys = {(e["VIA_MENU"], e["SHEET"], e["BTN"]) for e in entries if e["KIND"] == "CALLPROC"}
called_menus = {e["VIA_MENU"] for e in entries if e["KIND"] in ("CALLPROC", "EXCEL_VALID")} | set(GROUP_OF)
not_called = []
for b in btn:
    if b["MNU_ID"] in called_menus and (b["MNU_ID"], b["SHT_NM"], b["MNU_BTN_CD"]) not in used_keys:
        a = api_by.get(b["API_ID"]); url = (a["API_URL"] if a else "").strip().upper().replace("SCM_MGR.", "")
        not_called.append(dict(MNU_ID=b["MNU_ID"], GROUP=GROUP_OF.get(b["MNU_ID"], "POPUP/공용"), SHT_NM=b["SHT_NM"], BTN=b["MNU_BTN_CD"],
                               API_ID=b["API_ID"], API_URL=url, BTN_USE=b["USE_YN"], SQL_LOG_MENU=log_menu.get((b["MNU_ID"], url), 0), SQL_LOG_ALL=log_all.get(url, 0)))

def w(name, rows, cols):
    with (D / name).open("w", encoding="utf-8-sig", newline="") as fh:
        wr = csv.DictWriter(fh, fieldnames=cols, extrasaction="ignore"); wr.writeheader()
        for r in rows: wr.writerow(r)
w("entries.csv", entries, ["GROUP", "SCREEN", "VIA_MENU", "SHEET", "BTN", "KIND", "API_ID", "OBJECT", "FE_EVIDENCE", "SQL_LOG_MENU", "SQL_LOG_ALL", "NOTE"])
w("entry_defects.csv", defects, ["GROUP", "SCREEN", "VIA_MENU", "SHEET", "BTN", "ISSUE", "FE_EVIDENCE"])
w("meta_not_called.csv", not_called, ["MNU_ID", "GROUP", "SHT_NM", "BTN", "API_ID", "API_URL", "BTN_USE", "SQL_LOG_MENU", "SQL_LOG_ALL"])
w("combo_review.csv", review, ["SCREEN", "COMBO", "VERDICT", "FILE", "NODE", "CTX"])
print("entries", len(entries), collections.Counter(e["KIND"] for e in entries))
print("defects", len(defects), "meta_not_called", len(not_called), "combo_review", len(review))
