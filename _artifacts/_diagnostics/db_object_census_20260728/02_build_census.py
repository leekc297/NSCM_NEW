#!/usr/bin/env python3
"""
02_build_census.py — UI 축 구성 + UI×SP 매핑 + 의존성 폐포 + 콤보→UI 매핑
입력: 01_dump_meta.py 산출 CSV + nscm-fe 소스
출력: ui_axis.csv / ui_api.csv / closure.csv / recon_step1.txt / stats (stdout)
"""
import csv, json, re, sys, pathlib
from collections import defaultdict, deque

HERE = pathlib.Path(__file__).resolve().parent
FE = pathlib.Path(r"C:\Projects\NSCM\nscm-fe")
OWNERS = ("SCM_MGR", "SCMD_APP", "SCMC", "FP_MGR", "INF_MGR", "ENG_SCP", "OPT_MGR")
MENUID_RE = re.compile(r"(SYS|DMF|SCP|SCM|COM|SSP|FPC|FP)\d{4}")

def load(name):
    with (HERE / f"{name}.csv").open(encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))

# ---------- 1) FE 인벤토리 ----------
def fe_scan():
    screens = []   # (domain, folder, menu_id, has_index)
    modals = []    # (domain, folder, const, menu_id)
    id_re = re.compile(r"MENU_ID\s*[=:]\s*['\"]([A-Z]{2,3}\d{4})['\"]")
    modal_re = re.compile(r"(MODAL_[A-Z_]+|MENU_ID)\s*[=:]\s*['\"]([A-Z]{2,3}\d{4})['\"]")
    for feat in sorted((FE / "features").iterdir()):
        pages = feat / "src" / "pages"
        if pages.is_dir():
            for pg in sorted(pages.iterdir()):
                if not pg.is_dir():
                    continue
                has_index = (pg / "index.ts").exists() or (pg / "index.tsx").exists()
                mid = None
                for fp in pg.rglob("*.ts"):
                    m = id_re.search(fp.read_text(encoding="utf-8", errors="ignore"))
                    if m:
                        mid = m.group(1); break
                screens.append((feat.name, pg.name, mid, has_index))
        comps = feat / "src" / "components"
        if comps.is_dir():
            for cp in sorted(comps.iterdir()):
                if not cp.is_dir():
                    continue
                found = set()
                for fp in list(cp.rglob("*.ts")) + list(cp.rglob("*.tsx")):
                    for m in modal_re.finditer(fp.read_text(encoding="utf-8", errors="ignore")):
                        found.add((m.group(1), m.group(2)))
                for const, mid in sorted(found):
                    modals.append((feat.name, cp.name, const, mid))
    return screens, modals

# ---------- 2) 카탈로그 ----------
def build_catalog():
    objects = defaultdict(list)          # (owner,name) -> [(type,status,object_id)]
    by_id = {}                           # object_id -> (owner,name,type)
    for r in load("all_objects"):
        k = (r["OWNER"], r["OBJECT_NAME"])
        objects[k].append((r["OBJECT_TYPE"], r["STATUS"], r["OBJECT_ID"]))
        by_id[r["OBJECT_ID"]] = (r["OWNER"], r["OBJECT_NAME"], r["OBJECT_TYPE"])
    gtt = {(r["OWNER"], r["TABLE_NAME"]) for r in load("all_tables") if r["TEMPORARY"] == "Y"}
    syn = {}                             # (owner,name) -> (towner,tname); PUBLIC key = ('PUBLIC',name)
    for r in load("all_synonyms"):
        syn[(r["OWNER"], r["SYNONYM_NAME"])] = (r["TABLE_OWNER"], r["TABLE_NAME"])
    edges = defaultdict(set)             # (owner,name) -> {(rowner,rname,rtype)}
    for r in load("all_dependencies"):
        edges[(r["OWNER"], r["NAME"])].add(
            (r["REFERENCED_OWNER"], r["REFERENCED_NAME"], r["REFERENCED_TYPE"]))
    return objects, by_id, gtt, syn, edges

def primary_type(types):
    ts = {t for t, _, _ in types}
    for pick in ("PACKAGE", "PACKAGE BODY", "TYPE", "TABLE", "VIEW", "PROCEDURE", "FUNCTION",
                 "SEQUENCE", "SYNONYM", "TRIGGER", "MATERIALIZED VIEW"):
        if pick in ts:
            return "PACKAGE" if pick == "PACKAGE BODY" else pick
    return sorted(ts)[0] if ts else "?"

def worst_status(types):
    return "INVALID" if any(s == "INVALID" for _, s, _ in types) else "VALID"

# ---------- 3) API_URL → root 객체 해석 ----------
def resolve_root(url, objects, syn):
    url = (url or "").strip()
    if not url:
        return None, "EMPTY"
    name = url.split(".")
    if len(name) >= 2 and name[0] in OWNERS:      # SCM_MGR.PKG.MEMBER / SCM_MGR.PROC
        name = name[1:]
    base = name[0].strip().upper()
    for owner in OWNERS:
        k = (owner, base)
        if k in objects:
            return k, "OK"
        if k in syn:
            return syn[k], "SYNONYM"
    if ("PUBLIC", base) in syn:
        return syn[("PUBLIC", base)], "PUB_SYNONYM"
    return (None, base), "MISSING"

# ---------- 4) 폐포 ----------
def closure_from(roots, objects, syn, edges, gtt):
    """roots: {(owner,name): route_label} -> rows[(owner,name,depth,via,route)]"""
    seen, out = {}, []
    dq = deque()
    for k, route in roots.items():
        if k in seen:
            continue
        seen[k] = 0
        dq.append((k, 0, "", route))
    while dq:
        (owner, name), depth, via, route = dq.popleft()
        out.append((owner, name, depth, via, route))
        # SYNONYM 해석 대상도 폐포에 추가
        if (owner, name) in syn:
            t = syn[(owner, name)]
            if t[0] in OWNERS and t not in seen:
                seen[t] = depth + 1
                dq.append((t, depth + 1, f"{owner}.{name}(SYN)", route))
        for ro, rn, rt in sorted(edges.get((owner, name), ())):
            if ro not in OWNERS:
                continue
            k = (ro, rn)
            if k in seen:
                continue
            seen[k] = depth + 1
            dq.append((k, depth + 1, f"{owner}.{name}", route))
    return out

def main():
    screens, modals = fe_scan()
    objects, by_id, gtt, syn, edges = build_catalog()
    mnu = load("mnu_m"); api = load("api_m"); btn = load("btn_mpg")
    proc = load("proc_m"); excel = load("excel_columns"); cmbo = load("cmbo_sql")

    # --- UI 축 ---
    fe_ids = {}
    for dom, folder, mid, has_index in screens:
        if mid and has_index:
            fe_ids.setdefault(mid, []).append(f"{dom}/{folder}")
    modal_ids = {}
    for dom, folder, const, mid in modals:
        if mid not in fe_ids:
            modal_ids.setdefault(mid, []).append(f"{dom}/components/{folder}")

    # --- MNU_M 대사 ---
    mnu_by_id = {r["MNU_ID"]: r for r in mnu}
    leaf = [r for r in mnu if r["MNU_URL"]]
    recon = []
    recon.append("== Step1 recon: FE vs MNU_M ==")
    fe_not_mnu = sorted(set(fe_ids) - set(mnu_by_id))
    mnu_not_fe = sorted(r["MNU_ID"] for r in leaf if r["MNU_ID"] not in fe_ids)
    recon.append(f"FE 화면 MENU_ID: {len(fe_ids)} / MNU_M 전체 {len(mnu)} (leaf URL 보유 {len(leaf)})")
    recon.append(f"FE有-MNU_M無: {len(fe_not_mnu)} {fe_not_mnu}")
    recon.append(f"MNU_M(leaf)有-FE無: {len(mnu_not_fe)} {mnu_not_fe}")
    recon.append(f"공용모달 ID(FE): {sorted(modal_ids)}")

    # --- API 귀속 ---
    api_by_id = {r["API_ID"]: r for r in api}
    btn_ui = defaultdict(set)                       # API_ID -> {MNU_ID}
    for r in btn:
        if r["API_ID"]:
            btn_ui[r["API_ID"]].add(r["MNU_ID"])
    ui_apis = defaultdict(list)                     # ui -> [api rows]
    api_attrib = {}
    for r in api:
        aid = r["API_ID"]
        uis = set(btn_ui.get(aid, ()))
        m = MENUID_RE.search(aid)
        if m:
            uis.add(m.group(0))
        if not uis:
            uis = {"COMMON"}
        api_attrib[aid] = sorted(uis)
        for u in uis:
            ui_apis[u].append(r)

    # --- UI별 roots ---
    ui_roots = defaultdict(dict)                    # ui -> {(owner,name): route}
    ui_api_rows = []
    missing_sp = []
    for u, rows in ui_apis.items():
        for r in rows:
            k, st = resolve_root(r["API_URL"], objects, syn)
            ui_api_rows.append((u, r["API_ID"], r["API_TP_CD"], r["API_URL"], st,
                               f"{k[0]}.{k[1]}" if st != "MISSING" and k and k[0] else ""))
            if st == "MISSING":
                missing_sp.append((u, r["API_ID"], r["API_URL"]))
            elif k:
                ui_roots[u].setdefault(k, "API_M")
    # EXCEL_COLUMNS → validProc/storage SP
    for r in excel:
        pid = r["PROGRAM_ID"].split("_")[0]
        u = pid if pid in fe_ids or pid in modal_ids else None
        k, st = resolve_root(r["STORAGE_SQL_ID"], objects, syn)
        if u and st != "MISSING":
            ui_roots[u].setdefault(k, "EXCEL_UPLOAD")
        elif u and st == "MISSING":
            missing_sp.append((u, f"EXCEL:{r['PROGRAM_ID']}", r["STORAGE_SQL_ID"]))
    # COMMON 프레임워크 (BE XML 분석 확정분)
    COMMON_PKGS = ["PKG_NSCM_UI_COMM", "PKG_NSCM_UI_COM_AUTH", "PKG_NSCM_UI_COM_MENU",
                   "PKG_NSCM_UI_COM_USER", "PKG_NSCM_UI_COM_LOOKUP", "PKG_NSCM_UI_EXCEL",
                   "PKG_SCM0000", "PR_GET_MENU_LIST_V2"]
    for n in COMMON_PKGS:
        k, st = resolve_root(n, objects, syn)
        if st != "MISSING":
            ui_roots["COMMON"].setdefault(k, "BE_XML")
        else:
            missing_sp.append(("COMMON", "BE_XML", n))
    # SYS0016 notice-setup: FE 표준 훅 사용이나 API_M/BTN 배선 0 (F10) — DB 실존 NOTICE SP 를
    # 명명 기반 추정 root 로 편입 (route 라벨로 추정임을 명시)
    for n in ["SCM0010_GET_NOTICE_MASTER", "SCM0010_GET_NOTICE_CONTENT_MASTER",
              "SCM0010_SAVE_NOTICE_MASTER", "SCM0010_SAVE_NOTICE_CONTENT_MASTER",
              "SCM_ADM_SAVE_NOTICE_CONFIRM", "SCM_ADM_NOTICE_DELETE_CONFIRM"]:
        k, st = resolve_root(n, objects, syn)
        if st != "MISSING":
            ui_roots["SYS0016"].setdefault(k, "NOTICE추정(API_M미배선)")
        else:
            missing_sp.append(("SYS0016", "NOTICE추정", n))
    BE_DIRECT_TABLES = ["SCM_ADM_EXCEL_COLUMNS", "SCM_COM_ATCH_FILE_M", "SCM_COM_SYS_LOG",
                        "SCM_ADM_LOOKUP_MASTER_DETAIL", "SCM_ADM_MNU_BTN_MPG_M", "SCM_ADM_API_M",
                        "SCM_ADM_MNU_M", "SCM_ADM_MSG_M", "SCM_ADM_CMBO_SQL_M", "SCM_SYS_FILE",
                        "SCM_COM_SQL_LOG"]
    for n in BE_DIRECT_TABLES:
        k, st = resolve_root(n, objects, syn)
        if st != "MISSING":
            ui_roots["COMMON"].setdefault(k, "BE_DIRECT_SQL")
        else:
            missing_sp.append(("COMMON", "BE_DIRECT_SQL", n))

    # --- 콤보 → UI 매핑 (FE 소스 텍스트 검색) ---
    fe_files = []
    for base in [FE / "features", FE / "apps" / "web" / "src", FE / "configs"]:
        if base.is_dir():
            for fp in base.rglob("*.ts*"):
                if "node_modules" in fp.parts or "dist" in fp.parts:
                    continue
                try:
                    fe_files.append((fp, fp.read_text(encoding="utf-8", errors="ignore")))
                except OSError:
                    pass
    def path_to_ui(fp):
        parts = fp.parts
        if "pages" in parts:
            folder = parts[parts.index("pages") + 1]
            for mid, fs in fe_ids.items():
                if any(f.endswith("/" + folder) for f in fs):
                    return mid
        if "components" in parts and "features" in parts:
            folder = parts[parts.index("components") + 1] if len(parts) > parts.index("components") + 1 else ""
            for mid, fs in modal_ids.items():
                if any(f.endswith("/" + folder) for f in fs):
                    return mid
        return "COMMON"
    combo_ui = defaultdict(set)
    combo_unused = []
    for r in cmbo:
        sid = r["SQL_ID"]
        pat = re.compile(r"['\"]" + re.escape(sid) + r"['\"]")
        hits = {path_to_ui(fp) for fp, txt in fe_files if pat.search(txt)}
        if hits:
            combo_ui[sid] = hits
        else:
            combo_unused.append(sid)

    # --- 폐포 실행 ---
    closure_rows = []
    for u in sorted(ui_roots):
        for owner, name, depth, via, route in closure_from(ui_roots[u], objects, syn, edges, gtt):
            k = (owner, name)
            t = primary_type(objects.get(k, []))
            s = worst_status(objects.get(k, []))
            closure_rows.append([u, owner, name, t, s,
                                 "Y" if k in gtt else "", depth, via, route])

    # --- 출력 ---
    def wcsv(name, header, rows):
        with (HERE / name).open("w", newline="", encoding="utf-8-sig") as f:
            w = csv.writer(f); w.writerow(header); w.writerows(rows)
        print(f"{name}: {len(rows)} rows")
    wcsv("ui_axis.csv", ["UI", "KIND", "FE_PATHS", "MNU_M"], (
        [[mid, "화면", ";".join(fs), "Y" if mid in mnu_by_id else "N"] for mid, fs in sorted(fe_ids.items())]
        + [[mid, "공용모달", ";".join(fs), "Y" if mid in mnu_by_id else "N"] for mid, fs in sorted(modal_ids.items())]
        + [["COMMON", "프레임워크", "nscm-be sql/**", ""]]))
    wcsv("ui_api.csv", ["UI", "API_ID", "API_TP_CD", "API_URL", "RESOLVE", "ROOT"], ui_api_rows)
    wcsv("closure.csv", ["UI", "OWNER", "OBJECT_NAME", "TYPE", "STATUS", "GTT", "DEPTH", "VIA", "ROUTE"],
         closure_rows)
    wcsv("combo_ui.csv", ["SQL_ID", "UIS"], [[s, ";".join(sorted(us))] for s, us in sorted(combo_ui.items())])

    recon.append(f"API 총 {len(api)} / 귀속 UI 수 {len(ui_apis)} / SP 미존재 {len(missing_sp)}")
    for x in missing_sp:
        recon.append(f"  MISSING SP: {x}")
    recon.append(f"콤보 138 중 FE 미검출: {len(combo_unused)} {combo_unused}")
    dist = defaultdict(int)
    for row in closure_rows:
        dist[row[0]] += 1
    recon.append("UI별 폐포 객체 수: " + json.dumps(dict(sorted(dist.items())), ensure_ascii=False))
    (HERE / "recon_step1.txt").write_text("\n".join(recon), encoding="utf-8")
    print("\n".join(recon[:12]))
    print("... (전체는 recon_step1.txt)")

if __name__ == "__main__":
    main()
