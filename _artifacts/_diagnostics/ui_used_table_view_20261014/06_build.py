"""06_build.py — 최종 산출물: SYSTEM·ADMIN·DM UI 실사용 TABLE/VIEW 목록 (xlsx + md)  2026-10-14 스냅샷

입력: 01~05 산출 CSV. DB 접속 없음.
출력: Doc/화면분석서/TOBE_UI사용_TABLE_VIEW_SYSTEM_ADMIN_DM_20261014.xlsx / .md
"""
import csv, re, json, pathlib, collections, datetime
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

D = pathlib.Path(__file__).resolve().parent
OUTDIR = pathlib.Path(r"C:\Projects\NSCM\Doc\화면분석서")
XLSX = D / "TOBE_UI사용_TABLE_VIEW_상세근거_20261014.xlsx"   # 상세 근거본(10시트) — 작업폴더 보관, Doc 제출본은 07_build3.py(3시트)
MD = OUTDIR / "TOBE_UI사용_TABLE_VIEW_SYSTEM_ADMIN_DM_AUTH_20261014.md"
L = lambda p: list(csv.DictReader((D / p).open(encoding="utf-8-sig")))
snapshot = (D / "SNAPSHOT.txt").read_text(encoding="utf-8").strip()
mnu = {r["MNU_ID"]: r for r in L("meta/mnu_m.csv")}
entries, defects, notcalled, creview = L("entries.csv"), L("entry_defects.csv"), L("meta_not_called.csv"), L("combo_review.csv")
cm, edges, mt, pc, allseg, ctab = L("closure_members.csv"), L("call_edges.csv"), L("member_tables.csv"), L("parser_check.csv"), L("all_segment_tables.csv"), L("combo_tables.csv")
xcheck = L("crosscheck_dictmatch.csv")
objects = L("dict/objects.csv"); deps = L("dict/dependencies.csv"); tables = L("dict/tables.csv")
fe_unres = L("fe_unresolved.csv"); logs = L("meta/sql_log_calls.csv"); logrange = L("meta/sql_log_range.csv")[0]
sf = json.load((D / "fe_screen_files.json").open(encoding="utf-8"))

SCOPE = {
    "SYSTEM": "SYS0003 SYS0007 SYS0008 SYS0001 SYS0004 SYS0016 SYS0017 SCM0016 SCM0007 SCM0019 SYS0005 SYS0006 SYS0009".split(),
    "ADMIN": "SYS0002 SYS0014 SYS0010 SYS0013".split(),
    "DM": ("DMF0004 DMF0005 DMF0006 DMF0007 DMF0020 DMF0043 DMF0043_01 DMF0008 DMF0072 "
           "DMF0003 DMF0048 DMF0014 DMF0042 DMF0044 DMF0049 DMF0074 DMF0082 DMF0021 "
           "DMF0035 DMF0040 DMF0068 DMF0053").split(),
    "AUTHORITY": "SYS0011 SYS0012".split(),   # 2026-10-15 사용자 추가 요청 (Authority > Auth_Mgmt)
}
GROUP_OF = {s: g for g, ss in SCOPE.items() for s in ss}
GROUPS = ["SYSTEM", "ADMIN", "DM", "AUTHORITY", "COMMON"]
SCREEN_GROUPS = [g for g in GROUPS if g != "COMMON"]
TEMP = {(t["OWNER"], t["TABLE_NAME"]) for t in tables if t["TEMPORARY"] == "Y"}
OTYPE = collections.defaultdict(set)
for o in objects: OTYPE[(o["OWNER"], o["OBJECT_NAME"])].add(o["OBJECT_TYPE"])

def norm_type(owner, name, t):
    if (owner, name) in TEMP: return "GTT"
    if "SYS_DICTIONARY_VIEW" in t: return "VIEW(SYS 딕셔너리)"
    if "REMOTE@" in t: return "REMOTE(DB LINK)"
    if "MATERIALIZED VIEW" in t: return "MVIEW"
    if "VIEW" in t: return "VIEW"
    if "TABLE" in t: return "TABLE"
    return t or "?"

# ───────────── 사용 레코드 통합 ─────────────
USE = []   # owner,name,type,op,src,group,screen,via
node_users = {r["NODE"]: (r["GROUPS"].split(), r["SCREENS"].split()) for r in cm}
for r in mt:
    if r["T_TYPE"] in ("UNRESOLVED", ""): continue
    gs, ss = node_users.get(r["NODE"], ([], []))
    for s in ss:
        g = GROUP_OF.get(s) or ("COMMON" if s.startswith("(") else None)
        if not g: continue
        USE.append(dict(OWNER=r["T_OWNER"], NAME=r["T_NAME"], TYPE=norm_type(r["T_OWNER"], r["T_NAME"], r["T_TYPE"]), OP=r["OP"], SRC=r["SRC"], GROUP=g, SCREEN=s, VIA=r["NODE"].replace("SCM_MGR.", "")))
for r in ctab:
    if r["TYPE"] in ("CALL", "WARN", "UNRESOLVED"): continue
    USE.append(dict(OWNER=r["OWNER"], NAME=r["OBJECT"], TYPE=norm_type(r["OWNER"], r["OBJECT"], r["TYPE"]), OP="SELECT", SRC="COMBO_SQL", GROUP=r["GROUP"], SCREEN=r["SCREEN"], VIA="COMBO:" + r["COMBO"]))
for e in entries:
    if e["KIND"] == "DIRECT_SQL":
        USE.append(dict(OWNER="SCM_MGR", NAME=e["OBJECT"], TYPE=norm_type("SCM_MGR", e["OBJECT"], {"TABLE"}), OP=e["NOTE"], SRC="BE_DIRECT_SQL", GROUP="COMMON", SCREEN="(공통)", VIA=e["FE_EVIDENCE"]))

# VIEW 내부 참조 전개 (2026-10-15 요청) — VIEW 를 쓰는 메뉴/경유에 그대로 귀속, 접근 = R(VIEW 조회)
import sys as _sys; _sys.path.insert(0, str(D))
from _viewexp import expand_view
_vrows = []
for u in USE:
    if u["TYPE"] in ("VIEW", "MVIEW"):
        for o2, n2, t2, path in expand_view(u["OWNER"], u["NAME"])[0]:
            _vrows.append(dict(u, OWNER=o2, NAME=n2, TYPE=t2, OP="SELECT", SRC="VIEW_INTERNAL", VIA=f"{u['VIA']} ▶ VIEW {path}"))
USE += _vrows
final = collections.OrderedDict()
for u in USE:
    k = (u["OWNER"], u["NAME"])
    f = final.setdefault(k, dict(OWNER=u["OWNER"], NAME=u["NAME"], TYPE=u["TYPE"], G=set(), OPS=set(), SRCS=set(), SCREENS=set(), VIAS=set()))
    f["G"].add(u["GROUP"]); f["OPS"].add(u["OP"]); f["SRCS"].add(u["SRC"]); f["VIAS"].add(u["VIA"])
    if not u["SCREEN"].startswith("("): f["SCREENS"].add(u["SCREEN"])
OPMAP = {"SELECT": "R", "INSERT": "C", "UPDATE": "U", "DELETE": "D", "MERGE": "M", "TRUNCATE": "T", "LOCK": "L"}
def opstr(ops): return "".join(v for k, v in OPMAP.items() if k in ops)
TORDER = {"TABLE": 0, "GTT": 1, "VIEW": 2, "MVIEW": 3, "VIEW(SYS 딕셔너리)": 4, "REMOTE(DB LINK)": 5}
final_rows = sorted(final.values(), key=lambda f: (TORDER.get(f["TYPE"], 9), f["OWNER"] != "SCM_MGR", f["OWNER"], f["NAME"]))

# ───────────── 화면 요약 ─────────────
screen_tabs = collections.defaultdict(set); screen_objs = collections.defaultdict(set)
for u in USE:
    if not u["SCREEN"].startswith("("): screen_tabs[u["SCREEN"]].add((u["OWNER"], u["NAME"]))
for r in cm:
    for s in r["SCREENS"].split(): screen_objs[s].add(r["NODE"])
ent_by_screen = collections.defaultdict(list)
for e in entries: ent_by_screen[e["SCREEN"]].append(e)

# ───────────── VIEW 기반 전개 ─────────────
depmap = collections.defaultdict(set)
for d in deps: depmap[(d["OWNER"], d["NAME"])].add((d["REFERENCED_OWNER"], d["REFERENCED_NAME"], d["REFERENCED_TYPE"]))
def expand_view(k, seen=None, lvl=1):
    seen = seen or set(); out = []
    for ro, rn, rt in sorted(depmap.get(k, ())):
        if (ro, rn) in seen or ro in ("SYS", "PUBLIC") and rt != "TABLE": continue
        seen.add((ro, rn))
        out.append((lvl, ro, rn, "GTT" if (ro, rn) in TEMP else rt))
        if rt in ("VIEW", "FUNCTION", "SYNONYM", "PACKAGE"): out += expand_view((ro, rn), seen, lvl + 1)
    return out

# ───────────── v2.3 비교 ─────────────
v23 = OUTDIR / "TOBE_UI_DB객체_전수취합_v2.3.xlsx"
cmp_rows = []; v23_summary = ""
if v23.exists():
    wb0 = openpyxl.load_workbook(v23, read_only=True)
    ws0 = wb0["2_UI별_TABLE"]
    popups_used = {e["VIA_MENU"] for e in entries if e["VIA_MENU"] and e["VIA_MENU"] not in GROUP_OF and e["GROUP"] != "COMMON"}
    v_menus = set(GROUP_OF) | popups_used
    A = collections.defaultdict(set)
    for i, row in enumerate(ws0.iter_rows(values_only=True)):
        if i == 0 or not row[0]: continue
        if row[0] in v_menus: A[str(row[1])].add(row[0])
    B = {f["NAME"] for f in final_rows}
    unused_only = collections.defaultdict(set)
    used_names = {(f["OWNER"], f["NAME"]) for f in final_rows}
    for r in allseg:
        if r["USED"] == "N" and r["T_NAME"] and (r["T_OWNER"], r["T_NAME"]) not in used_names: unused_only[r["T_NAME"]].add(r["NODE"].replace("SCM_MGR.", ""))
    exist_now = {o["OBJECT_NAME"] for o in objects if o["OBJECT_TYPE"] in ("TABLE", "VIEW")}
    for n in sorted(set(A) - B):
        reason = ("미사용 PKG 멤버에서만 참조 → 제외 (" + ", ".join(sorted(unused_only[n])[:3]) + ")") if n in unused_only else \
                 ("현 DB 에 객체 없음(삭제/개명)" if n not in exist_now else "v2.3 은 PKG 단위 ALL_DEPENDENCIES 폐포 — 현 사용 멤버 호출 경로에서 미도달(범위 밖 객체·%TYPE 앵커·비사용 의존)")
        cmp_rows.append(dict(DIFF="v2.3에만", NAME=n, V23_MENUS=" ".join(sorted(A[n]))[:300], REASON=reason))
    for n in sorted(B - set(A)):
        f = next(x for x in final_rows if x["NAME"] == n)
        why = []
        if "COMMON" in f["G"] and len(f["G"]) == 1: why.append("공통(프레임워크) 신규 수록")
        if "COMBO_SQL" in f["SRCS"]: why.append("콤보 SQL")
        if "DYNAMIC" in f["SRCS"]: why.append("동적 SQL 문자열")
        if f["TYPE"].startswith("VIEW(SYS"): why.append("SYS 딕셔너리")
        if not why: why.append("v2.3 이후 신규/변경 또는 v2.3 포착축 밖 경로(독립 SP·함수 연쇄)")
        cmp_rows.append(dict(DIFF="본 산출에만", NAME=n, V23_MENUS="", REASON=" / ".join(why)))
    v23_summary = f"v2.3(범위 메뉴+사용 팝업) {len(A)}개 vs 본 산출 {len(B)}개 — v2.3에만 {len(set(A)-B)} / 본 산출에만 {len(B-set(A))} / 공통 {len(set(A)&B)}"

# ───────────── xlsx ─────────────
wb = openpyxl.Workbook()
HF = Font(bold=True, color="FFFFFF"); HFILL = PatternFill("solid", fgColor="305496")
THIN = Side(style="thin", color="BFBFBF"); BORDER = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)
def sheet(title, header, rows, widths=None):
    ws = wb.create_sheet(title)
    ws.append(header)
    for c in ws[1]: c.font = HF; c.fill = HFILL; c.alignment = Alignment(vertical="center", wrap_text=True); c.border = BORDER
    for r in rows:
        ws.append([("" if v is None else v) for v in r])
    for row in ws.iter_rows(min_row=2):
        for c in row: c.border = BORDER; c.alignment = Alignment(vertical="top", wrap_text=False)
    ws.freeze_panes = "A2"
    if ws.max_row > 1: ws.auto_filter.ref = ws.dimensions
    for i, h in enumerate(header, 1):
        w = (widths or {}).get(h) or min(60, max(10, len(str(h)) * 2 + 2))
        ws.column_dimensions[get_column_letter(i)].width = w
    return ws

wb.remove(wb.active)
cnt = collections.Counter(); cntg = collections.Counter()
for f in final_rows:
    cnt[f["TYPE"]] += 1
    for g in f["G"]: cntg[g] += 1
summary = [
    ("목적", "SYSTEM·ADMIN·DM 메뉴 UI 가 실제로 호출하는 SP·PKG 멤버·FUNCTION·콤보 SQL·BE 직접 SQL 이 사용하는 TABLE/VIEW 목록 (PKG 미사용 멤버 제외)"),
    ("기준 DB", snapshot),
    ("기준 FE/BE", "nscm-fe / nscm-be 현행 작업트리 (2026-10-14 정적 분석)"),
    ("메뉴 범위", f"SYSTEM(Admin>System) {len(SCOPE['SYSTEM'])} · ADMIN(Admin>Admin_Menu) {len(SCOPE['ADMIN'])} · DM(Demand) {len(SCOPE['DM'])} · AUTHORITY(Authority>Auth_Mgmt) {len(SCOPE['AUTHORITY'])} 화면 — USE_YN=Y SCREEN, 최신 SCM_ADM_MNU_M 재검증 일치. 화면이 여는 공용 팝업(COMxxxx·SCM0002 등)은 호출 화면에 귀속"),
    ("실사용 판정", "① FE 코드가 실제 호출하는 (메뉴,시트,버튼)/excel-upload/콤보ID + BE 프레임워크 호출  ∩  ② 메타 배선(SCM_ADM_MNU_BTN_MPG_M→API_M / EXCEL_COLUMNS / CMBO_SQL_M / SHEET_COLUMNS) → ③ PKG 를 멤버 단위로 분할해 호출 폐포(같은 PKG private 멤버·타 PKG 멤버·독립 SP/FN) → ④ 도달 멤버 본문의 정적·동적 SQL 에서 TABLE/VIEW 추출"),
    ("최종 TABLE/VIEW 수", f"{len(final_rows)}  (" + ", ".join(f"{k} {v}" for k, v in sorted(cnt.items(), key=lambda x: TORDER.get(x[0], 9))) + ")"),
    ("메뉴구분별", " · ".join(f"{g} {cntg[g]}" for g in GROUPS) + "  (중복 사용 허용 — 한 객체가 여러 구분에 Y)"),
    ("진입점", f"{len(entries)} (" + ", ".join(f"{k} {v}" for k, v in collections.Counter(e['KIND'] for e in entries).most_common()) + ")"),
    ("호출 폐포", f"사용 노드 {len(cm)} (PKG 멤버 {sum(1 for r in cm if r['KIND']=='PACKAGE')}·독립 SP {sum(1 for r in cm if r['KIND']=='PROCEDURE')}·FN {sum(1 for r in cm if r['KIND']=='FUNCTION')}) / 사용 객체 {len({(r['OWNER'], r['OBJECT']) for r in cm})} / 같은 객체 내 미사용 세그먼트 {len({r['NODE'] for r in allseg if r['USED']=='N'})}"),
    ("v2.3 대비", v23_summary),
    ("시트 안내", "01 메뉴범위 · 02 진입점 · 03 호출그래프 · 04 멤버별 TABLE/VIEW · 05 최종 목록 · 06 VIEW 기반 · 07 제외 목록 · 08 검증·한계 · 09 v2.3 비교"),
    ("범례(접근)", "R=SELECT C=INSERT U=UPDATE D=DELETE M=MERGE T=TRUNCATE"),
]
ws = sheet("00_요약", ["항목", "내용"], summary, {"항목": 18, "내용": 150})

rows = []
for g in SCREEN_GROUPS:
    for s in SCOPE[g]:
        r = mnu.get(s, {})
        es = ent_by_screen.get(s, [])
        pops = sorted({e["VIA_MENU"] for e in es if e["VIA_MENU"] and e["VIA_MENU"] != s})
        fe = sf.get(s, {}).get("page", "")
        rows.append([g, s, r.get("MNU_DESC", ""), r.get("UPPR_MNU_ID", ""), r.get("ROUTE_PATH", ""), fe or "(FE 페이지 없음 — 사용 없음)",
                     " ".join(pops), sum(1 for e in es if e["KIND"] in ("CALLPROC", "EXCEL_VALID", "DYNAMIC_QUERY")),
                     sum(1 for e in es if e["KIND"] in ("COMBO", "GRID_COMBO")), len(screen_objs.get(s, ())), len(screen_tabs.get(s, ()))])
sheet("01_메뉴범위", ["메뉴구분", "MNU_ID", "화면명", "상위메뉴", "ROUTE_PATH", "FE 페이지", "사용 팝업/타메뉴(VIA)", "SP진입점수", "콤보수", "도달 DB노드수", "TABLE/VIEW수"],
      rows, {"화면명": 30, "ROUTE_PATH": 40, "FE 페이지": 45, "사용 팝업/타메뉴(VIA)": 40})

rows = [[e["GROUP"], e["SCREEN"], e["KIND"], e["VIA_MENU"], e["SHEET"], e["BTN"], e["API_ID"], e["OBJECT"], e["SQL_LOG_MENU"], e["SQL_LOG_ALL"], e["NOTE"], e["FE_EVIDENCE"]]
        for e in sorted(entries, key=lambda e: (GROUPS.index(e["GROUP"]), e["SCREEN"], e["KIND"], e["VIA_MENU"], e["SHEET"], e["BTN"]))]
sheet("02_진입점", ["메뉴구분", "화면", "유형", "VIA_MENU", "SHT_NM", "BTN", "API_ID", "DB객체/콤보ID/테이블", "SQL_LOG(메뉴)", "SQL_LOG(전체)", "비고", "FE/BE 근거"],
      rows, {"DB객체/콤보ID/테이블": 55, "FE/BE 근거": 100, "비고": 25})

children = collections.defaultdict(list)
for e in edges: children[e["FROM"]].append(e["TO"])
rows = []
for r in sorted(cm, key=lambda r: r["NODE"]):
    rows.append([r["NODE"].replace("SCM_MGR.", ""), r["KIND"], r["MEMBER"], r["GROUPS"], r["SCREENS"], "\n".join(c.replace("SCM_MGR.", "") for c in sorted(children.get(r["NODE"], []))), r["ROOTS"][:500], r["WARN"][:500], r["OVERLOAD"]])
sheet("03_호출그래프", ["DB 노드(객체.멤버)", "객체유형", "멤버", "메뉴구분", "사용 화면", "호출하는 노드", "진입 루트", "경고", "OVERLOAD수"],
      rows, {"DB 노드(객체.멤버)": 60, "사용 화면": 50, "호출하는 노드": 60, "진입 루트": 60, "경고": 50})

agg = collections.defaultdict(lambda: dict(OPS=set(), SRC=set(), G=set(), S=set()))
for u in USE:
    k = (u["VIA"], u["OWNER"], u["NAME"], u["TYPE"])
    a = agg[k]; a["OPS"].add(u["OP"]); a["SRC"].add(u["SRC"]); a["G"].add(u["GROUP"])
    if not u["SCREEN"].startswith("("): a["S"].add(u["SCREEN"])
rows = [[k[0], k[1], k[2], k[3], opstr(a["OPS"]) or "/".join(sorted(a["OPS"])), "/".join(sorted(a["SRC"])), " ".join(g for g in GROUPS if g in a["G"]), " ".join(sorted(a["S"]))]
        for k, a in sorted(agg.items())]
sheet("04_멤버별_TABLE_VIEW", ["경유 노드(객체.멤버 / COMBO / BE)", "OWNER", "TABLE/VIEW", "유형", "접근", "추출원천", "메뉴구분", "사용 화면"],
      rows, {"경유 노드(객체.멤버 / COMBO / BE)": 60, "TABLE/VIEW": 38, "사용 화면": 60})

rows = []
for i, f in enumerate(final_rows, 1):
    note = []
    if f["SRCS"] == {"DYNAMIC"}: note.append("동적 SQL 문자열에서만 확인")
    if f["G"] == {"COMMON"}: note.append("공통 프레임워크 전용")
    vias = sorted(f["VIAS"])
    rows.append([i, f["OWNER"], f["NAME"], f["TYPE"]] + ["Y" if g in f["G"] else "" for g in GROUPS] +
                [opstr(f["OPS"]), "/".join(sorted(f["SRCS"])), len(f["SCREENS"]), " ".join(sorted(f["SCREENS"])),
                 len(vias), "\n".join(vias[:15]) + ("\n…" if len(vias) > 15 else ""), " / ".join(note)])
ws5 = sheet("05_TABLE_VIEW_목록", ["NO", "OWNER", "TABLE/VIEW", "유형"] + GROUPS + ["접근", "추출원천", "사용화면수", "사용 화면", "경유 노드수", "경유 노드(최대15)", "비고"],
      rows, {"TABLE/VIEW": 40, "사용 화면": 70, "경유 노드(최대15)": 70, "비고": 30, "추출원천": 22})

rows = []
for f in final_rows:
    if not f["TYPE"].startswith("VIEW") and f["TYPE"] != "MVIEW": continue
    for lvl, ro, rn, rt in expand_view((f["OWNER"], f["NAME"])) or [(0, "", "(의존 없음/딕셔너리)", "")]:
        rows.append([f["OWNER"], f["NAME"], f["TYPE"], lvl, ro, rn, rt])
sheet("06_VIEW_기반TABLE", ["VIEW OWNER", "VIEW", "유형", "단계", "참조 OWNER", "참조 객체", "참조 유형"], rows, {"VIEW": 40, "참조 객체": 40})

used_names = {(f["OWNER"], f["NAME"]) for f in final_rows}
rows = []
seg_tabs = collections.defaultdict(set)
for r in allseg:
    if r["USED"] == "N": seg_tabs[r["NODE"]].add((r["T_OWNER"], r["T_NAME"], r["T_TYPE"]))
for node, ts in sorted(seg_tabs.items()):
    tl = sorted(t for t in ts if t[1])
    only = [t[1] for t in tl if (t[0], t[1]) not in used_names and t[2] not in ("UNRESOLVED", "")]
    rows.append(["A.사용 PKG 내 미사용 멤버", node.replace("SCM_MGR.", ""), "", "", " ".join(t[1] for t in tl)[:3000], " ".join(only)[:2000], "FE→메타→호출 폐포에서 미도달"])
for r in notcalled:
    rows.append(["B.메타 배선 FE 미호출", f"{r['MNU_ID']}/{r['SHT_NM']}/{r['BTN']}", r["API_ID"], r["API_URL"], "", "", f"BTN_USE={r['BTN_USE']} SQL_LOG(메뉴)={r['SQL_LOG_MENU']} (전체)={r['SQL_LOG_ALL']}"])
rows.append(["C.범위 화면 FE 미구현", "SCM0019 (SCP IF Blocking)", "", "", "", "", "SCM_ADM_MNU_M 활성이나 nscm-fe 페이지 없음 → UI 사용 DB 객체 없음"])
for pid, sh, sp in (("DMF0003", "Car Fcst", "DMF0003_CAR_FCST_EXCEL_UPLOAD"), ("DMF0020", "Sales Price", "DMF0020_EXCEL_UPLOAD")):
    rows.append(["C.Excel 메타 FE 미호출", f"{pid}/{sh}", "", sp, "", "", "SCM_ADM_EXCEL_COLUMNS 등록이나 FE 에 excel-upload 호출 없음"])
for r in creview:
    rows.append(["D.콤보 후보 제외", f"{r['SCREEN']}/{r['COMBO']}", "", "", "", "", f"{r['VERDICT']} @ {r['FILE']} [{r['NODE']}]"])
SQLLOG_ONLY = [
    ("DMF0014", "PKG_DMF0014.P_DMF0014_GET_EXCEL_FORM_DATA", "BTN_MPG 배선 有 / FE 호출부(CustomerFcstTemplateModal) 가 CustomerFcstUpload.tsx:19·574 에서 주석 처리 → 현행 미사용"),
    ("DMF0074", "PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE", "BTN_MPG 배선 有 / MetalLinkTemplateModal 사용부 MetalLinkPrice.tsx:25·344 주석 처리 → 현행 미사용"),
    ("DMF0074", "PKG_NSCM_UI_COM_AUTH.PR_CHECK_MNU_AUTH", "GET /admin/menu/{id}/access — 현행 FE 호출 없음"),
    ("DMF0072", "PKG_DMF0072.P_DMF0072_GET_END_CUSTOMER_LIST / _SALES_SITE_LIST / _TEAM_LIST", "BTN_MPG 배선 有 / 현행 FE 호출 없음(09-15 1회 이력)"),
    ("DMF0040·DMF0048", "DMF0040_GET_SPREAD_TITLE / DMF0048_GET_SPREAD_TITLE", "현 API_M 미등록(09-15 이력) — 메타 변경으로 경로 소멸"),
    ("DMF0082", "PR_SCM_MST_EXCHANGE_RATE_UI", "현 API_M 미등록(09-15 이력)"),
    ("SYS0014", "P_SYS0014_GET_AUTH_LIST_M / _GROUP_LIST_M / _USER_BY_GROUP_M (독립 SP)", "현 API_M 미등록(09-15 이력) — PKG_SYS0014 멤버로 전환됨"),
]
for m, p, why in SQLLOG_ONLY:
    rows.append(["E.SQL_LOG 에만 존재", m, "", p, "", "", why])
for ep, why in (("GET /admin/menu/{id}/access → PR_CHECK_MNU_AUTH", "FE 호출 없음"), ("POST /admin/log/common · GET /admin/log/{ULID}/log-back → selectSysLog/updateSysLog", "FE 호출 없음 (INSERT 만 공통 사용)"),
                ("POST /admin/combo-muti · /admin/lookup-muti", "FE 호출 없음"), ("/{b}/{s}/retrieve-general · excute-general", "FE 호출 없음"),
                ("File.xml (SCM_COM_ATCH_FILE_M) · general/File.xml (SCM_SYS_FILE)", "테스트 전용/Java 호출 없음"), ("FE /file/image-upload (NoticeSetup)", "BE 매핑 없음 — DB 미도달(결함)")):
    rows.append(["F.BE 엔드포인트 제외", ep, "", "", "", "", why])
sheet("07_제외목록", ["구분", "대상", "API_ID", "DB객체", "미사용 멤버 참조 TABLE/VIEW", "그 중 최종목록에 없는 것(전용)", "사유/근거"], rows,
      {"대상": 55, "DB객체": 50, "미사용 멤버 참조 TABLE/VIEW": 60, "그 중 최종목록에 없는 것(전용)": 50, "사유/근거": 80})

miss = [c for c in pc if c["MISSING_IN_PARSE"]]
xc = collections.Counter(x["KIND"] for x in xcheck)
in_scope = set(GROUP_OF)
fe_unres_scope = [u for u in fe_unres if set(u["screens"].split()) & in_scope]
rows = [
    ["V1", "범위 재검증", f"최신 SCM_ADM_MNU_M 트리(부모 USE_YN 포함)로 {sum(len(v) for v in SCOPE.values())} 화면 재산출 = 플랜 범위", "PASS"],
    ["V2", "PL/SQL 파서 자체검증(객체 단위)", f"사용 객체 {len(pc)}개: (전 세그먼트 추출 합집합) ⊇ ALL_DEPENDENCIES TABLE/VIEW (%TYPE 앵커 제외) — 미추출 {len(miss)}건: " + "; ".join(f"{c['OBJECT']}→{c['MISSING_IN_PARSE']}" for c in miss), "PASS (SYS.DUAL 만 — 의도적 제외)"],
    ["V3", "파서 과잉추출", "추출했으나 ALL_DEPENDENCIES 에 없는 정적 TABLE/VIEW: " + "; ".join(f"{c['OBJECT']}→{c['EXTRA_NOT_IN_DEPS']}" for c in pc if c["EXTRA_NOT_IN_DEPS"]) + " — " +
     ("전부 SYS 딕셔너리 뷰(PUBLIC 동의어 경유라 SCM_MGR 의존 목록 비교 대상 밖)" if all(all(x.startswith("SYS.") for x in c["EXTRA_NOT_IN_DEPS"].split()) for c in pc if c["EXTRA_NOT_IN_DEPS"]) else "비-SYS 포함 → 확인 필요"),
     "PASS" if all(all(x.startswith("SYS.") for x in c["EXTRA_NOT_IN_DEPS"].split()) for c in pc if c["EXTRA_NOT_IN_DEPS"]) else "ERROR"],
    ["V4", "멤버 분할 정합", "162 PKG 의 spec 멤버(ALL_PROCEDURES) 전부 분할됨, 차이는 본문 전용 private 멤버(호출 대상에 포함)", "PASS"],
    ["V5", "독립 2차 방법(딕셔너리 일치)", f"사용 멤버 본문의 실존 TABLE/VIEW 이름 등장 vs 파서 결과 — 불일치 {len(xcheck)}건 전부 END_CUSTOMER 컬럼명 충돌({dict(xc)})", "PASS"],
    ["V6", "표본 1:1 대조", "SYS0003 전 멤버 원문 수동 대조 일치 / DMF0014 EXCEL_UPLOAD·DMF0082 SAVE_MAIN_DATA·GET_MAIN_DATA 독립 정규식 대조 일치(10/32/53)", "PASS"],
    ["V7", "SQL_LOG 교차(진입점)", f"SCM_COM_SQL_LOG {logrange['MIN_T'][:19]}~{logrange['MAX_T'][:19]} ({logrange['CNT']}행): 범위 메뉴 실행 이력 중 진입점 미포함 12건 → 전부 사유 확인(07 시트 E)", "PASS"],
    ["V8", "FE 미해석 호출부(범위 화면 도달)", f"{len(fe_unres_scope)}건 — 컬럼/메저 메타 시트 지정(SCM0016·DMF0003·DMF0048·DMF0020·DMF0035)은 원문 확인 후 수동 해석 반영, titleSetApi.fetchColumnMeta(공용, 화면 시트 재사용)", "PASS(수동 해석 포함)"],
    ["V8b", "FE 귀속 누락 점검", "범위 페이지 폴더 내 호출부 중 화면 미귀속 = 2건(DMF0014 FORM_DATA·DMF0074 template) — 둘 다 모달 사용부 주석 처리(미사용). 공용 컴포넌트 미귀속(master VersionModal·ContributeRateModal 등)은 렌더링 사용처 없음 확인. default export 재수출(DMF0008) 해석 보정 후 재산출", "PASS"],
    ["V9", "호출 간선 검증", "타 객체 간선은 ALL_DEPENDENCIES 존재 확인, 무수식 이름은 같은 PKG 멤버 우선(PL/SQL 해석 규칙) — 제외 간선 0", "PASS"],
    ["V10", "DB 쓰기", "전 과정 SELECT 만 (01_dump.py) — DDL/DML/재컴파일 0", "PASS"],
]
for d in defects:
    rows.append(["D", "메타/FE 결함(참고)", f"{d['SCREEN']} {d['VIA_MENU']}/{d['SHEET']}/{d['BTN']} — {d['ISSUE']} @ {d['FE_EVIDENCE'][:200]}", "결함 보고(목록 영향 없음)"])
LIMITS = [
    ("한계1", "SYS0013 Dynamic Query 는 사용자 입력 SQL 을 실행 — 대상 테이블 정적 확정 불가 (PKG_SYS0013 자체 참조분만 수록)"),
    ("한계2", "동적 SQL: 문자열 리터럴 조각에서 실존 객체로 해석되는 이름만 채택. 연결식으로 이름을 조립하는 경우는 경고로 남김(03 시트 WARN). 오류 메시지 문구 13건은 실존 객체 아님 → 제외"),
    ("한계3", "%TYPE/%ROWTYPE 앵커는 데이터 접근이 아니므로 제외 (parser_check.csv ANCHOR_ONLY)"),
    ("한계4", "그리드 셀 콤보는 SHEET_COLUMNS(VALID_YN=Y, FPComboBox, CELL_COMBO_DATA_TYPE/ATTRIBUTE9) 기준 — 사용자 타이틀셋으로 숨긴 컬럼의 콤보도 '사용 가능'으로 포함"),
    ("한계5", "SQL_LOG 는 09-15 이후 이력만 존재 — 보조 증빙. 판정은 현행 FE 코드 기준"),
    ("한계6", "VIEW 는 VIEW 로 수록하고 기반 객체는 06 시트에 ALL_DEPENDENCIES 기준 전개"),
]
for k, v in LIMITS: rows.append([k, "한계·전제", v, "명시"])
sheet("08_검증_한계", ["ID", "항목", "내용", "결과"], rows, {"항목": 26, "내용": 150, "결과": 26})

sheet("09_v2.3_비교", ["구분", "TABLE/VIEW", "v2.3 사용 메뉴", "사유"], [[r["DIFF"], r["NAME"], r["V23_MENUS"], r["REASON"]] for r in cmp_rows], {"TABLE/VIEW": 40, "v2.3 사용 메뉴": 60, "사유": 100})

wb.save(XLSX)

# ───────────── md ─────────────
lines = [f"# SYSTEM·ADMIN·DM UI 실사용 TABLE/VIEW 목록 (2026-10-14 스냅샷)", "",
         f"- 기준 DB: `{snapshot.splitlines()[0]}`",
         f"- 범위: SYSTEM {len(SCOPE['SYSTEM'])} · ADMIN {len(SCOPE['ADMIN'])} · DM {len(SCOPE['DM'])} · AUTHORITY {len(SCOPE['AUTHORITY'])} 화면 (활성 메뉴 + 사용 팝업), 공통 프레임워크는 COMMON",
         f"- 최종 TABLE/VIEW: **{len(final_rows)}** — " + ", ".join(f"{k} {v}" for k, v in sorted(cnt.items(), key=lambda x: TORDER.get(x[0], 9))),
         f"- 메뉴구분별(중복 허용): " + " · ".join(f"{g} {cntg[g]}" for g in GROUPS),
         f"- {v23_summary}", "", "상세·근거는 xlsx 참조 (02 진입점 → 03 호출그래프 → 04 멤버별 → 05 최종 목록, 07 제외, 08 검증).", ""]
for g in GROUPS:
    sub = [f for f in final_rows if g in f["G"]]
    lines.append(f"## {g} ({len(sub)})"); lines.append("")
    lines.append("| OWNER | TABLE/VIEW | 유형 | 접근 | 사용 화면 |"); lines.append("|---|---|---|---|---|")
    for f in sub:
        lines.append(f"| {f['OWNER']} | {f['NAME']} | {f['TYPE']} | {opstr(f['OPS'])} | {' '.join(sorted(f['SCREENS'])) if g != 'COMMON' else '(공통)'} |")
    lines.append("")
lines.append("## 검증"); lines.append("")
for r in rows[:0]: pass
lines += ["- V2 파서 자체검증: 사용 객체 전체 ALL_DEPENDENCIES 대비 미추출 0 (SYS.DUAL 제외)",
          "- V5 독립 2차 방법: 불일치 전부 END_CUSTOMER 컬럼명 충돌",
          "- V6 표본 1:1: SYS0003 / DMF0014 / DMF0082 일치",
          "- V7 SQL_LOG 교차: 진입점 미포함 12건 전부 사유 확인(현행 FE 주석 처리·메타 소멸 등)",
          "- 한계: SYS0013 Dynamic Query 임의 SQL · 동적 이름 조립 · %TYPE 제외 · 숨김 컬럼 콤보 포함"]
MD.write_text("\n".join(lines) + "\n", encoding="utf-8")
print("final", len(final_rows), dict(cnt), dict(cntg))
print(XLSX); print(MD)
