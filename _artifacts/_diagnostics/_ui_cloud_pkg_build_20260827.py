# -*- coding: utf-8 -*-
"""4 UI 클라우드 이관 패키지 생성기 (2026-08-27) — DMF0014 / DMF0035 / DMF0040 / DMF0053

  python _ui_cloud_pkg_build_20260827.py DMF0035   (또는 ALL)

원칙 (hook #140 deploy-axis-sweep-mandatory · #98 §9 시트 메타 SHEET_NAME 단위 재적재 · MERGE ON=PK 실측 · GTT DDL 자급)
  A_DB : 사내 라이브 **현재 기준** 신선 덤프 — SELECT 만 수행 (DDL/DML 실행 없음)
         01 GTT DDL(DBMS_METADATA, -955 멱등) / 10~ PKG SPEC+BODY(ALL_SOURCE) + 의존 PKG·PROC·FUNCTION
         20 메뉴·배선·권한 MERGE(PK 실측) / 21 CMBO / 22 SHEET_COLUMNS·MEASURE(PROGRAM_ID+SHEET_NAME 단위 DELETE+INSERT)
         23 MSG/LBL/MNU(FE·PKG·API_MSG·MNU 코드 추출 → 실존 행) / 24 PROC_M(DELETE+INSERT) / 25 EXCEL_COLUMNS / 26 LOOKUP(SEGMENT1=MENU)
         90 VERIFY
  B_FE : 실경로 구조 보존(hook §1.8) — 화면 폴더 전체 + 지정 공통 수정분
  C_DATA : 기존 패키지 데이터 파일 승계(DMF0053 CREATE_DATE)
"""
import io, os, re, sys, json, shutil, pathlib, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb
from ora import conn_info

ROOT = pathlib.Path(r"C:\Projects\NSCM"); FE = ROOT / "nscm-fe"; PKGDIR = ROOT / "_artifacts" / "_deploy_packages"
STAMP = "20260827"

CFG = {
    "DMF0014": dict(pkgs=["PKG_DMF0014"], gtt_prefix=["GT_DM14", "GT_DPCF"],
                    fe_dirs=[], fe_files=["features/demand/src/pages/customer-fcst-upload/components/CustomerFcstTemplateModal.tsx"],
                    fe_scan=["features/demand/src/pages/customer-fcst-upload"], data_from=None,
                    note="FE 는 오늘 수정 파일 1본만(사용자 지시). DB 는 현재 기준 전량."),
    "DMF0035": dict(pkgs=["PKG_DMF0035", "PKG_DMF0022", "PKG_DMF0051", "PKG_SCM0002"], gtt_prefix=["GT_DM35"],
                    fe_dirs=["features/report/src/pages/demand-plan-waterfall"],
                    fe_files=["packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx",
                              "configs/types/procedures.d.ts",
                              "features/report/package.json", "features/report/tsconfig.json", "features/report/src/index.ts"],
                    fe_scan=["features/report/src/pages/demand-plan-waterfall"], data_from=None,
                    note="화면 폴더는 features/**report**/src/pages (report 도메인). 공통 수정분 = OlapPivotGrid(FITONCE 폭 보존) + procedures.d.ts + report 피처 스캐폴드(클라우드에 report 피처 부재 시)."),
    "DMF0040": dict(pkgs=["PKG_DMF0040"], gtt_prefix=["GT_DM40"],
                    fe_dirs=["features/demand/src/pages/mkt-fcst-comparison"], fe_files=["configs/types/procedures.d.ts"],
                    fe_scan=["features/demand/src/pages/mkt-fcst-comparison"], data_from=None,
                    note="공통 수정분 = procedures.d.ts(DMF0040 계약 블록)."),
    "DMF0053": dict(pkgs=["PKG_DMF0053"], gtt_prefix=["GT_DM53", "GT_DMF0053"],
                    fe_dirs=["features/demand/src/pages/cust-fcst-waterfall"], fe_files=["configs/types/procedures.d.ts"],
                    fe_scan=["features/demand/src/pages/cust-fcst-waterfall"],
                    data_from=ROOT / "_artifacts" / "_diagnostics" / "dmf0053_build_20260827" / "C_DATA",
                    note="공통 수정분 = procedures.d.ts(DMF0053 계약 블록). C_DATA = CREATE_DATE 채움(2026-08-27 패키지 승계)."),
}
# 메뉴 문자열 축 대상 (백업/스테이징/사용자데이터 제외 — 정규 테이블만)
META_TABLES = ["SCM_ADM_PROGRAM", "SCM_ADM_MNU_M", "SCM_ADM_USER_GR_MNU_MPG_M", "SCM_ADM_MNU_BTN_MPG_M",
               "SCM_ADM_USER_GR_MNU_BTN_MPG_M", "SCM_ADM_API_M"]
EXCLUDE_TABLES_NOTE = "SCM_MST_TITLESET_USER / SCM_ADM_USER_MNU_SRCH_COND_M / SCM_ADM_EXCEL_UPLOAD(스테이징) / *_BAK* 는 사용자·임시 데이터라 이관 제외"

u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()

def q(sql, **b):
    cur.execute(sql, b); return cur.fetchall()
def cols_of(table):
    return [r[0] for r in q("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t ORDER BY COLUMN_ID", t=table)]
def pk_of(table):
    r = q("""SELECT CC.COLUMN_NAME FROM ALL_CONSTRAINTS C JOIN ALL_CONS_COLUMNS CC ON CC.OWNER=C.OWNER AND CC.CONSTRAINT_NAME=C.CONSTRAINT_NAME
             WHERE C.OWNER='SCM_MGR' AND C.TABLE_NAME=:t AND C.CONSTRAINT_TYPE='P' ORDER BY CC.POSITION""", t=table)
    if r: return [x[0] for x in r]
    r = q("""SELECT CC.COLUMN_NAME FROM ALL_CONSTRAINTS C JOIN ALL_CONS_COLUMNS CC ON CC.OWNER=C.OWNER AND CC.CONSTRAINT_NAME=C.CONSTRAINT_NAME
             WHERE C.OWNER='SCM_MGR' AND C.TABLE_NAME=:t AND C.CONSTRAINT_TYPE='U' ORDER BY C.CONSTRAINT_NAME, CC.POSITION""", t=table)
    return [x[0] for x in r]
def lit(v):
    if v is None: return "NULL"
    if isinstance(v, datetime.datetime): return f"TO_DATE('{v:%Y-%m-%d %H:%M:%S}','YYYY-MM-DD HH24:MI:SS')"
    if isinstance(v, (int, float)): return str(v)
    s = str(v).replace("'", "''")
    if "\n" in s or "\r" in s:
        parts = s.replace("\r\n", "\n").split("\n"); return "||CHR(10)||".join(f"'{x}'" for x in parts)
    return f"'{s}'"
AUDIT = {"CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE"}

def merge_sql(table, rows, cols, pk, tag):
    if not rows: return f"-- {table}: 0행\n"
    out = [f"-- ── {table} {len(rows)}행 MERGE (ON = PK 실측 {pk}) [{tag}] ──"]
    nonkey = [c for c in cols if c not in pk]
    for r in rows:
        v = dict(zip(cols, r))
        src = ", ".join(f"{lit(v[c])} AS {c}" for c in cols)
        on = " AND ".join(f"T.{c}=S.{c}" for c in pk)
        upd = ", ".join(f"T.{c}=S.{c}" for c in nonkey if c not in {"CREATED_BY", "CREATION_DATE"})
        ins_cols = ", ".join(cols); ins_vals = ", ".join(f"S.{c}" for c in cols)
        out.append(f"MERGE INTO SCM_MGR.{table} T USING (SELECT {src} FROM DUAL) S ON ({on})\n"
                   f"WHEN MATCHED THEN UPDATE SET {upd}\nWHEN NOT MATCHED THEN INSERT ({ins_cols}) VALUES ({ins_vals});")
    return "\n".join(out) + "\n"

def insert_sql(table, rows, cols):
    return "\n".join(f"INSERT INTO SCM_MGR.{table} ({', '.join(cols)}) VALUES ({', '.join(lit(x) for x in r)});" for r in rows) + "\n"

def src_of(name, typ):
    return "".join(r[0] for r in q("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ))

def build(menu):
    cfg = CFG[menu]; out = PKGDIR / f"{menu}_CLOUD_{STAMP}"
    if out.exists(): shutil.rmtree(out)
    (out / "A_DB").mkdir(parents=True); (out / "B_FE").mkdir()
    report = {"menu": menu, "stamp": STAMP, "db": {}, "fe": {"merge": []}, "notes": [cfg["note"], EXCLUDE_TABLES_NOTE]}
    A = out / "A_DB"
    def w(name, text, note=""):
        (A / name).write_text(text, encoding="utf-8"); report["db"][name] = note
    # ── 객체 축: PKG + 의존 객체 ──
    pkgs = list(cfg["pkgs"]); deps_std = []; gtts = set()
    for pk in cfg["pkgs"]:
        for (rn, rt) in q("""SELECT DISTINCT REFERENCED_NAME, REFERENCED_TYPE FROM ALL_DEPENDENCIES
                             WHERE OWNER='SCM_MGR' AND NAME=:n AND REFERENCED_OWNER='SCM_MGR' AND REFERENCED_TYPE IN ('PACKAGE','PROCEDURE','FUNCTION','TABLE','TYPE')""", n=pk):
            if rt == "PACKAGE" and rn not in pkgs and rn.startswith("PKG_DMF"): pkgs.append(rn)
            elif rt in ("PROCEDURE", "FUNCTION") and (rn, rt) not in deps_std: deps_std.append((rn, rt))
            elif rt == "TABLE" and rn.startswith("GT_"): gtts.add(rn)
    for pre in cfg["gtt_prefix"]:
        for (n,) in q("SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y' AND TABLE_NAME LIKE :p", p=pre + "%"): gtts.add(n)
    # 01 GTT DDL (멱등)
    cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',FALSE); DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',FALSE); END;")
    ddl = [f"-- 01_DDL_GTT.sql — {menu} GTT {len(gtts)}본 (DBMS_METADATA 신선 덤프, ORA-955 기존재 skip = 멱등) [{STAMP}]"]
    for g in sorted(gtts):
        cur.execute("SELECT DBMS_METADATA.GET_DDL('TABLE', :n, 'SCM_MGR') FROM DUAL", n=g); t = cur.fetchone()[0].read().strip()
        ddl.append(f"BEGIN EXECUTE IMMEDIATE q'[{t}]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE = -955 THEN NULL; ELSE RAISE; END IF; END;\n/")
        for (idx,) in q("SELECT INDEX_NAME FROM ALL_INDEXES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND INDEX_TYPE='NORMAL' AND UNIQUENESS='NONUNIQUE'", t=g):
            cur.execute("SELECT DBMS_METADATA.GET_DDL('INDEX', :n, 'SCM_MGR') FROM DUAL", n=idx); it = cur.fetchone()[0].read().strip()
            ddl.append(f"BEGIN EXECUTE IMMEDIATE q'[{it}]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE IN (-955,-1408) THEN NULL; ELSE RAISE; END IF; END;\n/")
    w("01_DDL_GTT.sql", "\n".join(ddl) + "\n", f"GTT {len(gtts)}본 (접두 {cfg['gtt_prefix']} + ALL_DEPENDENCIES)")
    # 10~ PKG (SPEC+BODY) + 의존 standalone
    n = 10
    for pk in pkgs:
        st = q("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n", n=pk)
        w(f"{n}_{pk}_SPEC.sql", "CREATE OR REPLACE " + src_of(pk, "PACKAGE") + "\n/\n", f"SPEC {st}")
        w(f"{n+1}_{pk}_BODY.sql", "CREATE OR REPLACE " + src_of(pk, "PACKAGE BODY") + "\n/\n", f"BODY {st}")
        n += 2
    for (rn, rt) in deps_std:
        s = src_of(rn, rt)
        if s: w(f"{n}_{rt}_{rn}.sql", "CREATE OR REPLACE " + s + "\n/\n", f"의존 {rt} (기이관이면 skip 가능)"); n += 1
    # 20 메뉴·배선·권한 (문자열 축 MERGE, PK 실측)
    parts = [f"-- 20_MENU_WIRING_AUTH.sql — {menu} 메뉴/배선/권한 현재 기준 MERGE [{STAMP}]"]
    for t in META_TABLES:
        cols = cols_of(t); pk = pk_of(t)
        keycol = "PROGRAM_ID" if "PROGRAM_ID" in cols else ("MNU_ID" if "MNU_ID" in cols else "API_ID")
        rows = q(f"SELECT {', '.join(cols)} FROM SCM_MGR.{t} WHERE {keycol} LIKE :m ORDER BY {', '.join(pk or cols[:1])}", m=menu + "%")
        parts.append(merge_sql(t, rows, cols, pk, f"{keycol} LIKE '{menu}%'")); report["db"][f"20:{t}"] = len(rows)
    parts.append("COMMIT;"); w("20_MENU_WIRING_AUTH.sql", "\n".join(parts) + "\n", "MERGE ON PK 실측")
    # 24 PROC_M (API_URL 기준 DELETE+INSERT)
    procs = sorted({r[0] for r in q("SELECT DISTINCT API_URL FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE :m AND API_TP_CD LIKE 'PROC%'", m=menu + "%")})
    pc = cols_of("SCM_ADM_PROC_M"); pl = [f"-- 24_PROC_M.sql — {menu} PROC_M (API_URL 기준 {len(procs)} SP, DELETE+INSERT — 이관 규약) [{STAMP}]"]
    for pn in procs:
        rows = q(f"SELECT {', '.join(pc)} FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:p ORDER BY SORT_ORD", p=pn)
        pl.append(f"DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='{pn}';"); pl.append(insert_sql("SCM_ADM_PROC_M", rows, pc)); report["db"][f"24:{pn}"] = len(rows)
    pl.append("COMMIT;"); w("24_PROC_M.sql", "\n".join(pl) + "\n", f"{len(procs)} SP")
    # 22 SHEET_COLUMNS / SHEET_MEASURE — (PROGRAM_ID, SHEET_NAME) 단위 DELETE+INSERT
    sl = [f"-- 22_SHEET_META.sql — {menu} SHEET_COLUMNS/MEASURE (PROGRAM_ID+SHEET_NAME 단위 DELETE 후 전체 재적재 — hook #98 §9) [{STAMP}]"]
    for t in ("SCM_MST_SHEET_COLUMNS", "SCM_MST_SHEET_MEASURE"):
        cols = cols_of(t)
        for (sh,) in q(f"SELECT DISTINCT SHEET_NAME FROM SCM_MGR.{t} WHERE PROGRAM_ID=:m", m=menu):
            rows = q(f"SELECT {', '.join(cols)} FROM SCM_MGR.{t} WHERE PROGRAM_ID=:m AND SHEET_NAME=:s ORDER BY SORT_ORDER_NO, COLUMN_NAME", m=menu, s=sh)
            sl.append(f"DELETE FROM SCM_MGR.{t} WHERE PROGRAM_ID='{menu}' AND SHEET_NAME={lit(sh)};"); sl.append(insert_sql(t, rows, cols))
            report["db"][f"22:{t}:{sh}"] = len(rows)
    sl.append("COMMIT;"); w("22_SHEET_META.sql", "\n".join(sl) + "\n", "시트 단위 재적재")
    # 25 EXCEL_COLUMNS / 26 LOOKUP(SEGMENT1=MENU)
    ec = cols_of("SCM_ADM_EXCEL_COLUMNS"); rows = q(f"SELECT {', '.join(ec)} FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID LIKE :m", m=menu + "%")
    w("25_EXCEL_COLUMNS.sql", f"-- 25 EXCEL_COLUMNS {len(rows)}행 [{STAMP}]\n" + merge_sql("SCM_ADM_EXCEL_COLUMNS", rows, ec, pk_of("SCM_ADM_EXCEL_COLUMNS"), "PROGRAM_ID LIKE") + "COMMIT;\n", f"{len(rows)}행")
    lc = cols_of("SCM_ADM_LOOKUP_MASTER_DETAIL"); rows = q(f"SELECT {', '.join(lc)} FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE SEGMENT1 LIKE :m OR LOOKUP_TYPE LIKE :m", m=menu + "%")
    w("26_LOOKUP_DETAIL.sql", f"-- 26 LOOKUP_MASTER_DETAIL SEGMENT1/LOOKUP_TYPE LIKE '{menu}%' {len(rows)}행 [{STAMP}]\n" + merge_sql("SCM_ADM_LOOKUP_MASTER_DETAIL", rows, lc, pk_of("SCM_ADM_LOOKUP_MASTER_DETAIL"), "SEGMENT1") + "COMMIT;\n", f"{len(rows)}행")
    # 21 CMBO — FE 소비 콤보명 + SHEET_COLUMNS 셀콤보
    combo_ids = set()
    for sdir in cfg["fe_scan"]:
        for f in (FE / sdir).rglob("*.ts*"):
            txt = f.read_text(encoding="utf-8", errors="ignore")
            for m in re.finditer(r"filters:\s*\[([^\]]*)\]", txt): combo_ids.update(re.findall(r"'([^']+)'", m.group(1)))
            combo_ids.update(re.findall(r"cellCboDataTp:\s*'([^']+)'", txt))
    for (c,) in q("SELECT DISTINCT CELL_COMBO_DATA_TYPE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:m AND CELL_COMBO_DATA_TYPE IS NOT NULL", m=menu): combo_ids.add(c)
    cc = cols_of("SCM_ADM_CMBO_SQL_M"); crow = []
    for cid in sorted(combo_ids):
        crow += q(f"SELECT {', '.join(cc)} FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:s", s=cid)
    shared = {r[0]: len(q("SELECT DISTINCT PROGRAM_ID FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE CELL_COMBO_DATA_TYPE=:s", s=r[0])) for r in crow}
    w("21_CMBO_SQL.sql", f"-- 21 CMBO_SQL_M — FE 소비(useTabComboQueries filters / cellCboDataTp) + SHEET_COLUMNS 셀콤보 {len(crow)}본 [{STAMP}]\n"
      f"-- ⚠ 공유 콤보(타 화면 소비)는 덮어쓰기 전 클라우드판 diff 확인: {json.dumps(shared, ensure_ascii=False)}\n"
      + merge_sql("SCM_ADM_CMBO_SQL_M", crow, cc, pk_of("SCM_ADM_CMBO_SQL_M"), "SQL_ID") + "COMMIT;\n", f"{len(crow)}본 (FE 요청 {len(combo_ids)}: 미등재 {sorted(combo_ids - {r[0] for r in crow})})")
    # 23 MSG/LBL/MNU — FE 소스 + PKG BODY + API_MSG_ID + MNU
    codes = set()
    for sdir in cfg["fe_scan"]:
        for f in (FE / sdir).rglob("*.ts*"): codes.update(re.findall(r"\b(?:MSG|LBL)\d{5}\b", f.read_text(encoding="utf-8", errors="ignore")))
    for pk in pkgs: codes.update(re.findall(r"\b(?:MSG|LBL)\d{5}\b", src_of(pk, "PACKAGE BODY")))
    for (aid,) in q("SELECT API_MSG_ID FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE :m", m=menu + "%"):
        if aid and aid != "-": codes.add(aid)
    for (mid,) in q("SELECT MSG_ID FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_TP_CD='MNU' AND (MSG_ID LIKE :m OR MSG_ID IN (SELECT MNU_MSG_ID FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID=:x))", m="%" + menu + "%", x=menu): codes.add(mid)
    mc = cols_of("SCM_ADM_MSG_M"); mrows = []
    for c in sorted(codes): mrows += q(f"SELECT {', '.join(mc)} FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID=:c ORDER BY LANG_CD", c=c)
    missing = sorted(codes - {r[0] for r in mrows})
    w("23_MSG_LBL_MNU.sql", f"-- 23 SCM_ADM_MSG_M {len(mrows)}행 ({len(codes)}코드 × 언어) — FE·PKG·API_MSG·MNU 기계 추출 [{STAMP}]\n-- 메타 미존재 코드(FE 참조하나 사내 MSG_M 없음): {missing}\n"
      + merge_sql("SCM_ADM_MSG_M", mrows, mc, pk_of("SCM_ADM_MSG_M"), "MSG_ID,LANG_CD") + "COMMIT;\n", f"{len(mrows)}행 / 미존재 {missing}")
    # 90 VERIFY
    v = [f"-- 90_VERIFY.sql — {menu} 적용 확인 [{STAMP}]",
         f"SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ({', '.join(lit(x) for x in pkgs)});",
         f"SELECT COUNT(*) AS INVALID_CNT FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID' AND OBJECT_NAME IN ({', '.join(lit(x) for x in pkgs)});"]
    for t in META_TABLES:
        keycol = "PROGRAM_ID" if "PROGRAM_ID" in cols_of(t) else ("MNU_ID" if "MNU_ID" in cols_of(t) else "API_ID")
        v.append(f"SELECT '{t}' T, COUNT(*) CNT FROM SCM_MGR.{t} WHERE {keycol} LIKE '{menu}%';  -- 기대 {report['db'].get('20:'+t)}")
    for k, cnt in report["db"].items():
        if k.startswith("22:"):
            _, t, sh = k.split(":", 2); v.append(f"SELECT '{t}/{sh}' T, COUNT(*) CNT FROM SCM_MGR.{t} WHERE PROGRAM_ID='{menu}' AND SHEET_NAME={lit(sh)};  -- 기대 {cnt}")
    v.append(f"SELECT COUNT(*) AS GTT_CNT FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y' AND TABLE_NAME IN ({', '.join(lit(x) for x in sorted(gtts)) or 'NULL'});  -- 기대 {len(gtts)}")
    w("90_VERIFY.sql", "\n".join(v) + "\n", "기대 카운트 실측")
    # ── B_FE ──
    copied = []
    for rel in cfg["fe_dirs"]:
        for f in (FE / rel).rglob("*"):
            if f.is_file():
                dst = out / "B_FE" / f.relative_to(FE); dst.parent.mkdir(parents=True, exist_ok=True); shutil.copy2(f, dst); copied.append(str(f.relative_to(FE)).replace("\\", "/"))
    # FE_MERGE — 그대로 덮어쓰면 안 되는 공통/전체교체 파일 (클라우드판과 diff 병합 대상). 사용자 지시 2026-08-27.
    merged = []
    for rel in cfg["fe_files"]:
        f = FE / rel
        if not f.exists(): report["notes"].append(f"⚠ FE 공통 파일 부재: {rel}"); continue
        dst = out / "FE_MERGE" / rel; dst.parent.mkdir(parents=True, exist_ok=True); shutil.copy2(f, dst); merged.append(rel)
        if rel.endswith("procedures.d.ts"):
            # 화면 계약 블록만 별도 추출 — MENU 문자열이 처음 나오는 줄 ~ 마지막 나오는 줄 (병합 시 이 블록만 이식)
            lines = f.read_text(encoding="utf-8", errors="ignore").splitlines()
            hits = [i for i, l in enumerate(lines) if menu in l]
            if hits:
                blk = "\n".join(lines[hits[0]:hits[-1] + 1])
                (out / "FE_MERGE" / f"procedures.d.ts.{menu}_BLOCK.txt").write_text(
                    f"// procedures.d.ts 중 {menu} 계약 블록 (L{hits[0]+1}~L{hits[-1]+1}) — 클라우드판에 이 블록만 병합\n" + blk + "\n", encoding="utf-8")
                merged.append(f"procedures.d.ts.{menu}_BLOCK.txt (추출 L{hits[0]+1}~L{hits[-1]+1})")
    report["fe"]["merge"] = merged
    # 화면 폴더가 import 하는 페이지 밖 로컬(features 내) 의존 — 배포자 확인용 기계 추출
    ext_imports = set()
    for sdir in cfg["fe_scan"]:
        for f in (FE / sdir).rglob("*.ts*"):
            for m in re.finditer(r"from\s+'((?:features/|@(?:master|demand|report|admin)/)[^']+)'", f.read_text(encoding="utf-8", errors="ignore")): ext_imports.add(m.group(1))
    report["fe"].update({"files": copied, "external_feature_imports": sorted(ext_imports)})
    # ── C_DATA ──
    if cfg["data_from"] and cfg["data_from"].exists():
        shutil.copytree(cfg["data_from"], out / "C_DATA"); report["notes"].append(f"C_DATA 승계: {cfg['data_from']}")
    # ── README / FILELIST ──
    files = sorted(str(f.relative_to(out)).replace("\\", "/") for f in out.rglob("*") if f.is_file())
    (out / "_FILELIST.md").write_text("\n".join(files) + "\n", encoding="utf-8")
    (out / "_survey.json").write_text(json.dumps(report, ensure_ascii=False, indent=1, default=str), encoding="utf-8")
    db_rows = "\n".join(f"| {k} | {v} |" for k, v in report["db"].items() if not k[0].isdigit() or ":" not in k)
    axes = "\n".join(f"| {k} | {v} |" for k, v in report["db"].items() if ":" in k)
    readme = f"""# {menu}_CLOUD_{STAMP} — 클라우드 이관 패키지 (사내 DB 현재 기준 신선 덤프 · FE 실경로 구조)

생성 {datetime.datetime.now():%Y-%m-%d %H:%M} · 생성기 `_artifacts/_diagnostics/_ui_cloud_pkg_build_20260827.py {menu}` (SELECT 만 — DDL/DML 실행 없음)
{cfg['note']}
{EXCLUDE_TABLES_NOTE}

## 적용 순서 (A_DB)
`01_DDL_GTT` → `10~ PKG SPEC/BODY`(의존 PKG·PROC 포함 — 기이관이면 diff 후 skip) → `20_MENU_WIRING_AUTH` → `24_PROC_M` → `22_SHEET_META` → `21_CMBO_SQL`(⚠ 공유 콤보 diff) → `23_MSG_LBL_MNU` → `25_EXCEL_COLUMNS` → `26_LOOKUP_DETAIL` → (B_FE 배포) → `90_VERIFY`
DBeaver Execute Script(Ctrl+Alt+X) / SQLcl `@file`. PKG 파일은 `/` 종결.

## A_DB 파일
| 파일 | 내용 |
|---|---|
{db_rows}

## 메타 축 행수 (사내 현재 기준 = VERIFY 기대값)
| 축 | 행수 |
|---|---|
{axes}

## B_FE ({len(copied)} 파일 — **그대로 복사**: 화면 폴더 전체, 실경로 `nscm-fe/` 기준 구조 보존)
""" + "\n".join(f"- `{f}`" for f in copied) + f"""

## FE_MERGE ({len(report['fe']['merge'])} — **그대로 덮어쓰기 금지**: 클라우드판과 diff 병합)
""" + "\n".join(f"- `{f}`" for f in report["fe"]["merge"]) + f"""
- `configs/types/procedures.d.ts` → 전체 파일이 아니라 동봉한 `procedures.d.ts.{menu}_BLOCK.txt` 의 화면 블록만 이식(다른 화면 블록은 클라우드판 유지).
- `packages/shared/**` 공용 컴포넌트 → 클라우드 공통소스판과 3-way diff 후 마커 구간만 반영.
- 피처 스캐폴드(`features/report/package.json` 등) → 클라우드에 해당 피처가 이미 있으면 skip.

화면 폴더가 참조하는 **페이지 밖 피처 모듈**(클라우드에 기존재해야 함 — 부재 시 별도 이관): {sorted(ext_imports) or '없음'}
"""
    (out / "README.md").write_text(readme, encoding="utf-8")
    print(f"[{menu}] → {out}  A_DB {len(list(A.iterdir()))}파일 / B_FE {len(copied)}파일 / GTT {len(gtts)} / PKG {pkgs} / 의존 {deps_std}")
    for k, vv in report["db"].items():
        if ":" in k: print(f"    {k} = {vv}")
    print("    FE 외부 import:", sorted(ext_imports))

targets = sys.argv[1:] or ["ALL"]
for m in (list(CFG) if targets == ["ALL"] else targets): build(m)
