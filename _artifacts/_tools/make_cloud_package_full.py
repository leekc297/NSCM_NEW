#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""화면 1개의 클라우드 이관 대상을 **전 축 기계 스윕**으로 취합 → 패키지 폴더 생성 (재사용 도구).

손나열 금지(hook #140). 축은 딕셔너리/카탈로그에서 기계 도출한다:
  A 메타 문자열축 : SCM_ADM_%/SCM_MST_%/DM_ADM_% 전 테이블 문자열 컬럼 LIKE '%<MENU>%'
  B DB 객체축     : 이름 매칭 객체 + PKG 의존 객체 + BODY 참조 GTT
  C MSG/LBL/MNU   : FE·BODY 코드 스캔 ∪ SCM_ADM_MNU_M.MNU_MSG_ID → SCM_ADM_MSG_M (INSERT-only)
  D CMBO          : 시트 메타(표시/편집) ∪ FE 리터럴 ∩ SCM_ADM_CMBO_SQL_M
생성물: A_DB/01 PKG SPEC·BODY, 10 메타(축별), 90_VERIFY / 00_CLOUD_PRECHECK / _survey / _README 초안

사용:
  python make_cloud_package_full.py --menu DMF0014 --fe nscm-fe/features/demand/src/pages/customer-fcst-upload
  옵션 --pkg PKG_DMF0014 --out DMF0014_CLOUD_20260823 --prev DMF0014_CLOUD_20260818
"""
import argparse
import datetime
import difflib
import hashlib
import io
import json
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

ROOT = pathlib.Path(r"C:\Projects\NSCM")
PKGROOT = ROOT / "_artifacts" / "_deploy_packages"
# 이관 제외 축 (개인화·스테이징·백업) — 제외 사유는 README 에 그대로 인쇄된다
EXCLUDE = {
    "SCM_MST_TITLESET_USER": "사용자 개인화 데이터",
    "SCM_ADM_EXCEL_UPLOAD": "엑셀 업로드 스테이징(실행 데이터)",
    "SCM_ADM_LOOKUP_MASTER_DETAIL_H": "이력 테이블",
    "SCM_ADM_USER_MNU_SRCH_COND_M": "사용자별 조회조건 개인화(USER_ID 보유)",
}


def lit(v):
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(v)
    if isinstance(v, datetime.datetime):
        return f"TO_DATE('{v.strftime('%Y%m%d%H%M%S')}','YYYYMMDDHH24MISS')"
    s = str(v).replace("'", "''")
    if len(s) <= 1500 and "\n" not in s and "\r" not in s:
        return f"'{s}'"
    parts = []
    for i, ln in enumerate(s.replace("\r\n", "\n").split("\n")):
        ch = []
        while len(ln) > 1500:
            ch.append(f"'{ln[:1500]}'")
            ln = ln[1500:]
        ch.append(f"'{ln}'")
        seg = "||".join(ch)
        parts.append(seg if i == 0 else f"CHR(10)||{seg}")
    return "||".join(parts)


# 감사컬럼 정규화 — 개인/AI ID 가 운영 메타에 남지 않게 한다 (memory: meta-audit-column-admin-only)
AUDIT_COLS = ("CREATED_BY", "LAST_UPDATED_BY", "LAST_UPDATE_BY", "UPDATED_BY")
AUDIT_KEEP = {"admin", "system"}


def lit_c(col, v):
    """컬럼명을 아는 리터럴. 감사컬럼의 개인/claude ID 는 'admin' 으로 치환."""
    if col in AUDIT_COLS and isinstance(v, str) and v.strip().lower() not in AUDIT_KEEP:
        return "'admin'"
    return lit(v)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--menu", required=True)
    ap.add_argument("--pkg")
    ap.add_argument("--fe", help="FE 화면 폴더 (MSG/LBL·CMBO 스캔용)")
    ap.add_argument("--out")
    ap.add_argument("--prev", help="직전 클라우드 패키지 폴더명 (BODY delta 실측)")
    a = ap.parse_args()
    menu, pkg = a.menu, (a.pkg or f"PKG_{a.menu}")

    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    today = cur.execute("SELECT TO_CHAR(SYSDATE,'YYYYMMDD') FROM DUAL").fetchone()[0]
    out = PKGROOT / (a.out or f"{menu}_CLOUD_{today}")
    (out / "A_DB").mkdir(parents=True, exist_ok=True)
    (out / "_survey").mkdir(exist_ok=True)
    rep = {"menu": menu, "generated": today}

    def q(sql, binds=None):
        cur.execute(sql, binds or {})
        return cur.fetchall()

    def fetch(sql, binds=None):
        cur.execute(sql, binds or {})
        cols = [c[0] for c in cur.description]
        rows = [[v.read() if isinstance(v, oracledb.LOB) else v for v in r] for r in cur.fetchall()]
        return cols, rows

    # ── A. 메타 문자열 축 ──────────────────────────────────────
    print("=" * 90)
    tables = [r[0] for r in q("""SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR'
                  AND (TABLE_NAME LIKE 'SCM_ADM_%' OR TABLE_NAME LIKE 'SCM_MST_%' OR TABLE_NAME LIKE 'DM_ADM_%')
                  AND TABLE_NAME NOT LIKE '%_BAK%' AND TABLE_NAME NOT LIKE 'BAK%'
                  AND TABLE_NAME NOT LIKE '%DROP%' AND TABLE_NAME NOT LIKE '%_BK2%' ORDER BY 1""")]
    hits = []
    for t in tables:
        scols = [r[0] for r in q("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                     AND TABLE_NAME=:t AND DATA_TYPE IN ('VARCHAR2','CHAR') ORDER BY COLUMN_ID""", {"t": t})]
        if not scols:
            continue
        where = " OR ".join('"%s" LIKE \'%%%s%%\'' % (c, menu) for c in scols)
        n = q(f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE {where}")[0][0]
        if n:
            hits.append({"table": t, "rows": n, "where": where,
                         "excluded": EXCLUDE.get(t)})
            mark = f"  ⛔제외({EXCLUDE[t]})" if t in EXCLUDE else ""
            print(f"  A  {t:<38} {n:>6}행{mark}")
    rep["A_meta"] = hits
    print(f"=> A축 {len(hits)}표 (제외 {sum(1 for h in hits if h['excluded'])})")

    # ── B. DB 객체 축 ────────────────────────────────────────
    objs = q("""SELECT OBJECT_TYPE, OBJECT_NAME, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                 AND OBJECT_NAME LIKE :m AND OBJECT_NAME NOT LIKE 'BAK%' AND OBJECT_NAME NOT LIKE '%_BAK%'
                 ORDER BY 1,2""", {"m": f"%{menu}%"})
    rep["B_objects"] = [{"type": t, "name": n, "status": s} for t, n, s in objs]
    print(f"=> B축 객체 {len(objs)}종 (INVALID {sum(1 for _, _, s in objs if s != 'VALID')})")

    # ── PKG SPEC/BODY 덤프 ───────────────────────────────────
    def src(kind):
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE",
                    {"n": pkg, "t": kind})
        return "".join(x for (x,) in cur if x is not None)

    body, spec = src("PACKAGE BODY"), src("PACKAGE")
    (out / "A_DB" / f"01_{pkg}_SPEC.sql").write_text(
        f"-- {out.name} / {pkg} SPEC (사내 신선 덤프 {today})\nCREATE OR REPLACE " + spec + "\n/\n", encoding="utf-8")
    (out / "A_DB" / f"02_{pkg}_BODY.sql").write_text(
        f"-- {out.name} / {pkg} BODY (사내 신선 덤프 {today})\nCREATE OR REPLACE " + body + "\n/\n", encoding="utf-8")
    print(f"=> PKG SPEC {spec.count(chr(10)) + 1}줄 / BODY {body.count(chr(10)) + 1}줄")
    rep["pkg"] = {"spec_lines": spec.count("\n") + 1, "body_lines": body.count("\n") + 1}

    if a.prev:
        pb = next((f for f in (PKGROOT / a.prev / "A_DB").glob("*BODY*.sql")), None)
        if pb:
            prev = re.sub(r"^--[^\n]*\n", "", pb.read_text(encoding="utf-8").replace("\r\n", "\n"), count=2)
            prev = prev.replace("CREATE OR REPLACE ", "", 1).rstrip("/").strip()
            diff = list(difflib.unified_diff(prev.split("\n"), body.strip().split("\n"), lineterm="", n=0))
            adds = [l for l in diff if l.startswith("+") and not l.startswith("+++")]
            marks = sorted(set(re.findall(r"E2026\d{4}-[A-Z0-9]+", "\n".join(adds))))
            (out / "_survey" / f"delta_vs_{a.prev}.diff").write_text("\n".join(diff), encoding="utf-8")
            rep["delta"] = {"prev": a.prev, "added": len(adds), "markers": marks}
            print(f"=> BODY delta vs {a.prev}: +{len(adds)}행 / 마커 {marks}")

    # ── 메타 SQL 생성 (축별) ──────────────────────────────────
    def merge_sql(table, keys, sql, binds=None, null_safe=False):
        cols, rows = fetch(sql, binds)
        outp = []
        for r in rows:
            v = dict(zip(cols, r))
            on = " AND ".join(
                (f"NVL(T.{k}, '~NULL~') = NVL({lit(v[k])}, '~NULL~')" if null_safe else f"T.{k} = {lit(v[k])}")
                for k in keys)
            upd = ", ".join(f"T.{c} = {lit_c(c, v[c])}" for c in cols if c not in keys)
            outp.append(f"MERGE INTO SCM_MGR.{table} T\nUSING DUAL ON ({on})\n"
                        f"WHEN MATCHED THEN UPDATE SET {upd}\n"
                        f"WHEN NOT MATCHED THEN INSERT ({', '.join(cols)})\nVALUES ({', '.join(lit_c(c, v[c]) for c in cols)});")
        return outp, len(rows)

    def reload_sql(table, scope, sql, binds=None):
        cols, rows = fetch(sql, binds)
        outp = [f"DELETE FROM SCM_MGR.{table} WHERE {scope};"]
        for r in rows:
            v = dict(zip(cols, r))
            outp.append(f"INSERT INTO SCM_MGR.{table} ({', '.join(cols)})\nVALUES ({', '.join(lit_c(c, v[c]) for c in cols)});")
        return outp, len(rows)

    files, counts = [], {}

    def emit(fname, header, stmts, commit=True):
        (out / "A_DB" / fname).write_text(f"-- {header}\n\n" + "\n\n".join(stmts) + ("\nCOMMIT;\n" if commit else "\n"),
                                          encoding="utf-8")
        files.append(fname)
        print(f"     {fname:<40} {len(stmts):>4} stmt")

    # 시트 메타 (전량 재적재)
    # PROGRAM 패밀리 = MENU + MENU_40 같은 division 변형까지 (hook #140 — 손 스코프 금지)
    fam = lambda col: "(" + col + " = '" + menu + "' OR " + col + " LIKE '" + menu + "!_%' ESCAPE '!')"
    sheets = [(r[0], r[1]) for r in q(
        "SELECT DISTINCT PROGRAM_ID, SHEET_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE " + fam("PROGRAM_ID") + " ORDER BY 1,2")]
    if sheets:
        st, tot = [], 0
        for pid, sh in sheets:
            s_, n = reload_sql("SCM_MST_SHEET_COLUMNS", f"PROGRAM_ID='{pid}' AND SHEET_NAME='{sh}'",
                               "SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:m AND SHEET_NAME=:s ORDER BY SORT_ORDER_NO",
                               {"m": pid, "s": sh})
            st.append(f"-- [{pid}] 시트 [{sh}] {n}행\n" + "\n".join(s_))
            tot += n
        counts["SHEET_COLUMNS"] = tot
        emit("10_SHEET_COLUMNS.sql", f"{out.name} / SHEET_COLUMNS 시트 단위 전량 재적재 (hook #98 §9) — {tot}행", st)

    for tbl, fname, order in [
            ("SCM_MST_SHEET_MEASURE", "11_SHEET_MEASURE.sql", "PROGRAM_ID, SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME"),
            ("SCM_ADM_EXCEL_COLUMNS", "12_EXCEL_COLUMNS.sql", "PROGRAM_ID, SHEET_NAME")]:
        if q(f"SELECT COUNT(*) FROM SCM_MGR.{tbl} WHERE " + fam("PROGRAM_ID"))[0][0]:
            s_, n = reload_sql(tbl, fam("PROGRAM_ID"),
                               f"SELECT * FROM SCM_MGR.{tbl} WHERE " + fam("PROGRAM_ID") + f" ORDER BY {order}")
            counts[tbl] = n
            emit(fname, f"{out.name} / {tbl} 전량 재적재 — {n}행", ["\n".join(s_)])

    # 배선·권한 축
    wiring = [
        ("SCM_ADM_PROGRAM", ["PROGRAM_ID"], f"SELECT * FROM SCM_MGR.SCM_ADM_PROGRAM WHERE PROGRAM_ID LIKE '%{menu}%'"),
        ("SCM_ADM_MNU_M", ["MNU_ID"], f"SELECT * FROM SCM_MGR.SCM_ADM_MNU_M WHERE " + fam('MNU_ID')),
        ("SCM_ADM_API_M", ["API_ID"], f"SELECT * FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE '%{menu}%' OR API_URL LIKE '%{menu}%'"),
        ("SCM_ADM_PROC_M", ["PROC_NM", "COL_NM", "COL_TP_CD"], f"SELECT * FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE '%{menu}%' ORDER BY PROC_NM, COL_NM"),
        ("SCM_ADM_MNU_BTN_MPG_M", ["MNU_ID", "SHT_NM", "MNU_BTN_CD"], f"SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE " + fam('MNU_ID') + " ORDER BY MNU_ID, SHT_NM, MNU_BTN_CD"),
        ("SCM_ADM_USER_GR_MNU_MPG_M", ["USER_GR_ID", "MNU_ID"], f"SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE " + fam('MNU_ID') + " ORDER BY MNU_ID, USER_GR_ID"),
        ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", ["USER_GR_ID", "MNU_ID", "SHT_NM", "MNU_BTN_CD"], f"SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE " + fam('MNU_ID') + " ORDER BY MNU_ID, USER_GR_ID, SHT_NM, MNU_BTN_CD")]
    blocks = []
    for tbl, keys, sql in wiring:
        s_, n = merge_sql(tbl, keys, sql)
        counts[tbl] = n
        if n:
            blocks.append(f"-- {tbl} {n}행 (PK={'+'.join(keys)})\n" + "\n\n".join(s_))
    if blocks:
        emit("20_WIRING_AUTH.sql", f"{out.name} / 배선·권한 MERGE — " +
             " / ".join(f"{k.replace('SCM_ADM_', '')} {v}" for k, v in counts.items() if k.startswith("SCM_ADM_")), blocks)

    # LOOKUP
    s_, n = merge_sql("SCM_ADM_LOOKUP_MASTER_DETAIL",
                      ["LOOKUP_TYPE", "SEGMENT1", "SEGMENT2", "SEGMENT3", "SEGMENT4", "SEGMENT5"],
                      f"SELECT * FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE SEGMENT1 LIKE '%{menu}%' OR SEGMENT2 LIKE '%{menu}%' ORDER BY 1,2,3",
                      null_safe=True)
    counts["LOOKUP"] = n
    if n:
        emit("21_LOOKUP.sql", f"{out.name} / LOOKUP_MASTER_DETAIL {n}행 (PK=SEG1~5, NULL-safe ON)", ["\n\n".join(s_)])

    # MSG/LBL/MNU — INSERT-only (사용자 확정)
    scan = body
    if a.fe:
        fedir = ROOT / a.fe
        if fedir.exists():
            scan += "\n".join(f.read_text(encoding="utf-8", errors="ignore")
                              for f in fedir.rglob("*") if f.suffix in (".ts", ".tsx"))
    codes = sorted(set(re.findall(r"MSG\d{5}", scan))) + sorted(set(re.findall(r"LBL\d{5}", scan)))
    codes += [r[0] for r in q("SELECT DISTINCT MNU_MSG_ID FROM SCM_MGR.SCM_ADM_MNU_M WHERE " + fam('MNU_ID') + " AND MNU_MSG_ID IS NOT NULL")]
    stmts, have, missing = [], 0, []
    for c in codes:
        cols, rows = fetch("SELECT * FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID=:c ORDER BY LANG_CD", {"c": c})
        if not rows:
            missing.append(c)
            continue
        have += len(rows)
        for r in rows:
            v = dict(zip(cols, r))
            stmts.append(f"INSERT INTO SCM_MGR.SCM_ADM_MSG_M ({', '.join(cols)})\n"
                         f"SELECT {', '.join(f'{lit_c(c2, v[c2])} AS {c2}' for c2 in cols)} FROM DUAL\n"
                         f" WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = {lit(v['MSG_ID'])} AND LANG_CD = {lit(v['LANG_CD'])});")
    counts["MSG_M(rows)"] = have
    if stmts:
        emit("30_MSG_LBL_MNU.sql",
             f"{out.name} / SCM_ADM_MSG_M **INSERT-only (NOT EXISTS)** — 소비 {len(codes)}코드 중 등록 {have}행\n"
             f"-- ⚠ 기존재 문구는 덮지 않는다(코드는 화면 간 공유 자산). 사내 미등록 = {missing}", stmts)

    rep["counts"] = counts
    (out / "_survey" / "collect_report.json").write_text(json.dumps(rep, ensure_ascii=False, indent=2), encoding="utf-8")

    # 파일목록
    fl = [(str(f.relative_to(out)).replace("\\", "/"), f.stat().st_size,
           hashlib.md5(f.read_bytes()).hexdigest()[:10])
          for f in sorted(out.rglob("*")) if f.is_file() and f.name != "_FILELIST.md"]
    (out / "_FILELIST.md").write_text(
        f"# {out.name} — 파일 목록 (기계 산출 {today})\n\n총 {len(fl)} 파일 / {sum(x[1] for x in fl):,} bytes\n\n"
        "| 경로 | bytes | md5(10) |\n|---|---:|---|\n"
        + "\n".join(f"| `{p}` | {b:,} | `{h}` |" for p, b, h in fl) + "\n", encoding="utf-8")
    con.close()
    print("=" * 90)
    print(f"생성 완료 → {out}  ({len(fl)} 파일)")
    print("   남은 일: _README.md 작성(정정 계보·적용 순서·범위 밖) + 00_CLOUD_PRECHECK 보강")
    return 0


if __name__ == "__main__":
    sys.exit(main())
