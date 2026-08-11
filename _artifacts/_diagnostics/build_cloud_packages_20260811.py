#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""build_cloud_packages_20260811.py — 클라우드 이관 패키지 생성기 (DMF0044 / DMF0049 / UPFX_COMBO)

사용자 요청(2026-08-11):
  · DMF0044·DMF0049 **각각 폴더** 생성 + 클라우드 이관 취합
  · "UI 에 사용을 위하여 **추가한 COMBO** 와 필요한 내용이 모두 담길 것"
  · UP_FX SP → COMBO 전환 작업분을 **별도 폴더**로 일괄 이관
  · ⭐ **UI Category Setup(SHEET_COLUMNS) 는 MERGE INTO 로 UPDATE 가능하게** 생성

## 설계 원칙
1. **live 실측만** — 사내 Oracle 현재 상태를 그대로 뜬다(문서·기억 기반 추정 금지).
2. **DELETE 절 없는 MERGE** — 값 갱신이 필요한 메타(SHEET_COLUMNS/MEASURE/CMBO/MSG)는 MERGE INTO
   `WHEN MATCHED THEN UPDATE` + `WHEN NOT MATCHED THEN INSERT`. **DELETE 절은 쓰지 않는다**
   (2026-08-07 "시트 메타 MERGE 금지" 는 DELETE 동반 사고가 원인 — 값 갱신 자체가 목적인 본 이관은
    사용자 지시로 MERGE 채택. 삭제가 없으므로 클라우드 고유 행이 지워지지 않는다).
3. **CLOB 안전** — `SQL_DTL_CTN` 등 긴 텍스트는 PL/SQL 블록에서 청크 연결(SQL*Plus 4000자 한계 회피).
4. **감사컬럼 'admin'** — 사내 규약(claude ID 금지).
5. **자급(self-contained)** — TYPE/GTT DDL 을 동봉해 "이미 있겠지" 가정을 하지 않는다.

사용: python build_cloud_packages_20260811.py --build
"""
import argparse
import datetime
import json
import pathlib
import re
import shutil
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

import oracledb

ROOT = pathlib.Path(__file__).resolve().parents[2]
PKGROOT = ROOT / "_artifacts" / "_deploy_packages"
FE = ROOT / "nscm-fe"
LOCALES = FE / "public" / "locales"

TS = None  # 런타임 시각 (하드코딩 금지 — 룰 22 §2.1)

UIS = {
    "DMF0044": {"page": FE / "features/demand/src/pages/sales-reports",
                "pkg": "PKG_DMF0044", "sheet": "MDF Reports"},
    "DMF0049": {"page": FE / "features/demand/src/pages/etc-sales-reports",
                "pkg": "PKG_DMF0049", "sheet": "MDF Reports"},
}
SHARED_FE = FE / "features/demand/src/components/versionModal"
RE_I18N = re.compile(r"\bt\(\s*['\"]((?:LBL|MSG)\d{5})['\"]")
RE_UPPER = re.compile(r"['\"]([A-Z][A-Za-z0-9_]{3,60})['\"]")


# ────────────────────────────── SQL 리터럴 helper ──────────────────────────────
def lit(v):
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(v)
    if isinstance(v, datetime.datetime):
        return "TO_DATE('%s','YYYY-MM-DD HH24:MI:SS')" % v.strftime("%Y-%m-%d %H:%M:%S")
    s = str(v).replace("'", "''")
    return "'%s'" % s


def clob_assign(var, text, chunk=1800):
    """긴 텍스트를 PL/SQL 변수에 청크 연결로 대입 (SQL*Plus 리터럴 길이 한계 회피)."""
    if text is None:
        return ["  %s := NULL;" % var]
    s = str(text)
    out = ["  %s := NULL;" % var]
    for i in range(0, len(s), chunk):
        out.append("  %s := %s || %s;" % (var, var, lit(s[i:i + chunk])))
    return out


def rows_of(cur, sql, **binds):
    cur.execute(sql, **binds)
    cols = [c[0] for c in cur.description]
    return cols, [dict(zip(cols, r)) for r in cur.fetchall()]


def read_lob(v):
    return v.read() if hasattr(v, "read") else v


# ────────────────────────────── MERGE 생성기 ──────────────────────────────
def merge_sql(table, keys, rows, cols, audit=True, clob_cols=()):
    """DELETE 절 없는 MERGE INTO — WHEN MATCHED UPDATE / WHEN NOT MATCHED INSERT."""
    out = []
    upd_cols = [c for c in cols if c not in keys and c not in
                ("CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE")]
    for r in rows:
        if clob_cols:
            decl = ["DECLARE"]
            for i, c in enumerate(clob_cols):
                decl.append("  v%d CLOB;" % i)
            decl.append("BEGIN")
            for i, c in enumerate(clob_cols):
                decl += clob_assign("v%d" % i, read_lob(r.get(c)))
            body_val = {c: "v%d" % i for i, c in enumerate(clob_cols)}
            out += decl
        else:
            body_val = {}
            out.append("BEGIN")

        src = ", ".join("%s AS %s" % (body_val.get(c, lit(r.get(c))), c) for c in cols)
        on = " AND ".join("T.%s = S.%s" % (k, k) for k in keys)
        setc = ", ".join("T.%s = S.%s" % (c, c) for c in upd_cols)
        ins_cols = list(cols)
        ins_vals = ["S.%s" % c for c in cols]
        if audit:
            setc += ", T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE"
        out.append("  MERGE INTO %s T" % table)
        out.append("  USING ( SELECT %s FROM DUAL ) S" % src)
        out.append("     ON ( %s )" % on)
        if upd_cols:
            out.append("   WHEN MATCHED THEN UPDATE SET %s" % setc)
        out.append("   WHEN NOT MATCHED THEN INSERT (%s) VALUES (%s);"
                   % (", ".join(ins_cols), ", ".join(ins_vals)))
        out.append("END;")
        out.append("/")
        out.append("")
    return out


def guarded_insert(table, keys, rows, cols):
    """INSERT-only + NOT EXISTS 가드 (권한·배선처럼 값 갱신이 불필요한 메타)."""
    out = []
    for r in rows:
        where = " AND ".join("%s = %s" % (k, lit(r.get(k))) for k in keys)
        out.append("INSERT INTO %s (%s)" % (table, ", ".join(cols)))
        out.append("SELECT %s FROM DUAL" % ", ".join(lit(r.get(c)) for c in cols))
        out.append(" WHERE NOT EXISTS ( SELECT 1 FROM %s WHERE %s );" % (table, where))
        out.append("")
    return out


HDR = """-- ============================================================================
-- {title}
--   생성: {ts} (build_cloud_packages_20260811.py — 사내 live 실측)
--   대상: 클라우드 QA·DEV **2DB 동시 적용** 의무
--   ⚠ MERGE 는 DELETE 절이 없다 — 클라우드 고유 행은 삭제되지 않는다.
-- ============================================================================
SET DEFINE OFF
"""


def write(path, title, lines):
    path.write_text(HDR.format(title=title, ts=TS) + "\n" + "\n".join(lines) +
                    "\nCOMMIT;\n", encoding="utf-8")
    return path


# ────────────────────────────── 추출 ──────────────────────────────
def pkg_ddl(cur, name, typ):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE=:t ORDER BY LINE""", n=name, t=typ)
    rows = cur.fetchall()
    if not rows:
        return None
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def gtt_ddl(cur, body_text):
    """BODY 가 참조하는 GT_* / TYPE 을 실측 수집해 DDL 자급."""
    names = sorted(set(re.findall(r"\b(GT_[A-Z0-9_]+)\b", body_text or "")))
    out = []
    for n in names:
        cur.execute("""SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE
                         FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t
                        ORDER BY COLUMN_ID""", t=n)
        cols = cur.fetchall()
        if not cols:
            continue
        defs = []
        for c, dt, dl, dp, ds in cols:
            if dt in ("VARCHAR2", "CHAR"):
                defs.append("  %s %s(%d)" % (c, dt, dl))
            elif dt == "NUMBER":
                defs.append("  %s NUMBER%s" % (c, "(%d,%d)" % (dp, ds) if dp else ""))
            else:
                defs.append("  %s %s" % (c, dt))
        out.append("-- %s (GTT — 세션 스코프)" % n)
        out.append("DECLARE n NUMBER; BEGIN")
        out.append("  SELECT COUNT(*) INTO n FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME='%s';" % n)
        out.append("  IF n = 0 THEN EXECUTE IMMEDIATE q'[")
        out.append("CREATE GLOBAL TEMPORARY TABLE SCM_MGR.%s (" % n)
        out.append(",\n".join(defs))
        out.append(") ON COMMIT PRESERVE ROWS]';")
        out.append("  END IF;")
        out.append("END;")
        out.append("/")
        out.append("")
    return names, out


def build_ui(cur, menu, cfg, folder):
    cfgsheet = cfg["sheet"]
    made = []

    # 1) PKG SPEC / BODY -------------------------------------------------------
    spec = pkg_ddl(cur, cfg["pkg"], "PACKAGE")
    body = pkg_ddl(cur, cfg["pkg"], "PACKAGE BODY")
    (folder / "02_PKG_SPEC.sql").write_text(
        HDR.format(title="%s — PACKAGE SPEC (live)" % cfg["pkg"], ts=TS) + "\n" + spec + "\n/\n",
        encoding="utf-8")
    (folder / "03_PKG_BODY.sql").write_text(
        HDR.format(title="%s — PACKAGE BODY (live)" % cfg["pkg"], ts=TS) + "\n" + body + "\n/\n",
        encoding="utf-8")
    made += ["02_PKG_SPEC.sql", "03_PKG_BODY.sql"]

    # 2) GTT DDL 자급 ---------------------------------------------------------
    gtts, gl = gtt_ddl(cur, body)
    write(folder / "01_GTT_DDL.sql", "%s 의존 GTT 자급 DDL (%d종)" % (menu, len(gtts)), gl)
    made.append("01_GTT_DDL.sql")

    # 3) SHEET_COLUMNS — ⭐ MERGE INTO (사용자 지시) ---------------------------
    cols, rows = rows_of(cur, """SELECT * FROM SCM_MST_SHEET_COLUMNS
                                  WHERE PROGRAM_ID = :m ORDER BY SHEET_NAME, SORT_ORDER_NO""", m=menu)
    write(folder / "11_META_SHEET_COLUMNS.sql",
          "UI Category Setup — SCM_MST_SHEET_COLUMNS %d행 (MERGE INTO, DELETE 절 없음)" % len(rows),
          merge_sql("SCM_MST_SHEET_COLUMNS",
                    ["PROGRAM_ID", "SHEET_NAME", "COLUMN_NAME"], rows, cols))
    made.append("11_META_SHEET_COLUMNS.sql")
    n_col = len(rows)

    # 4) SHEET_MEASURE --------------------------------------------------------
    cols, rows = rows_of(cur, """SELECT * FROM SCM_MST_SHEET_MEASURE
                                  WHERE PROGRAM_ID = :m ORDER BY SHEET_NAME, SORT_ORDER_NO""", m=menu)
    write(folder / "12_META_SHEET_MEASURE.sql",
          "SCM_MST_SHEET_MEASURE %d행 (MERGE INTO)" % len(rows),
          merge_sql("SCM_MST_SHEET_MEASURE",
                    ["PROGRAM_ID", "SHEET_NAME", "COLUMN_NAME"], rows, cols))
    made.append("12_META_SHEET_MEASURE.sql")
    n_msr = len(rows)

    # 5) 배선 메타 (MNU / API / BTN / PROC) ------------------------------------
    lines = []
    cols, rows = rows_of(cur, "SELECT * FROM SCM_ADM_MNU_M WHERE MNU_ID = :m", m=menu)
    lines += ["-- SCM_ADM_MNU_M (%d행)" % len(rows)] + merge_sql("SCM_ADM_MNU_M", ["MNU_ID"], rows, cols)
    # ⚠ 실제 스키마: API_M 에 MNU_ID 가 없다. 연결은 MNU_BTN_MPG_M.API_ID 를 통한다.
    #   그리고 PROC_M.PROC_NM = API_M.API_URL (예 'PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C')
    cols, rows = rows_of(cur, """SELECT * FROM SCM_ADM_API_M WHERE API_ID IN
                                 (SELECT API_ID FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = :m)
                                 ORDER BY API_ID""", m=menu)
    n_api = len(rows)
    lines += ["-- SCM_ADM_API_M (%d행)" % n_api] + merge_sql("SCM_ADM_API_M", ["API_ID"], rows, cols)
    cols, rows = rows_of(cur, """SELECT * FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = :m
                                  ORDER BY SHT_NM, MNU_BTN_CD""", m=menu)
    n_btn = len(rows)
    lines += ["-- SCM_ADM_MNU_BTN_MPG_M (%d행)" % n_btn] + \
             merge_sql("SCM_ADM_MNU_BTN_MPG_M", ["MNU_ID", "SHT_NM", "MNU_BTN_CD"], rows, cols)
    cols, rows = rows_of(cur, """SELECT * FROM SCM_ADM_PROC_M WHERE PROC_NM IN
                                 ( SELECT DISTINCT A.API_URL FROM SCM_ADM_API_M A
                                     JOIN SCM_ADM_MNU_BTN_MPG_M B ON B.API_ID = A.API_ID
                                    WHERE B.MNU_ID = :m )
                                 ORDER BY PROC_NM, SORT_ORD""", m=menu)
    n_proc = len(rows)
    lines += ["-- SCM_ADM_PROC_M (%d행 — API_URL 로 연결된 SP 파라미터 계약)" % n_proc] + \
             merge_sql("SCM_ADM_PROC_M", ["PROC_NM", "SORT_ORD"], rows, cols)
    write(folder / "10_META_WIRING.sql", "%s 배선 메타 (MNU/API/BTN/PROC)" % menu, lines)
    made.append("10_META_WIRING.sql")

    # 6) 콤보 — ⭐ 사용자 강조: 화면이 쓰는 COMBO 전수 ---------------------------
    cur.execute("""SELECT DISTINCT CELL_COMBO_DATA_TYPE FROM SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID = :m AND CELL_COMBO_DATA_TYPE IS NOT NULL
                      AND TRIM(CELL_COMBO_DATA_TYPE) IS NOT NULL""", m=menu)
    cell = {r[0] for r in cur.fetchall()}
    cur.execute("SELECT SQL_ID FROM SCM_ADM_CMBO_SQL_M")
    registered = {r[0] for r in cur.fetchall()}
    fe_ids = set()
    for f in list(cfg["page"].rglob("*.ts")) + list(cfg["page"].rglob("*.tsx")) + \
             list(SHARED_FE.rglob("*.ts")) + list(SHARED_FE.rglob("*.tsx")):
        if ".test." in f.name:
            continue
        for m in RE_UPPER.finditer(f.read_text(encoding="utf-8", errors="ignore")):
            if m.group(1) in registered:
                fe_ids.add(m.group(1))
    combo_ids = sorted(cell | fe_ids)
    cols, rows = rows_of(cur, """SELECT * FROM SCM_ADM_CMBO_SQL_M
                                  WHERE SQL_ID IN (SELECT COLUMN_VALUE FROM TABLE(
                                        SYS.ODCIVARCHAR2LIST(%s))) ORDER BY SQL_ID"""
                         % ",".join(lit(c) for c in combo_ids))
    write(folder / "13_META_CMBO_SQL.sql",
          "%s 사용 COMBO %d종 (셀 %d + FE %d 합집합) — MERGE INTO, SQL_DTL_CTN CLOB 청크"
          % (menu, len(rows), len(cell), len(fe_ids)),
          merge_sql("SCM_ADM_CMBO_SQL_M", ["SQL_ID"], rows, cols, clob_cols=("SQL_DTL_CTN",)))
    made.append("13_META_CMBO_SQL.sql")

    # 7) MSG / LBL — FE 실사용 코드 기준 ----------------------------------------
    ids = set()
    for f in list(cfg["page"].rglob("*.ts")) + list(cfg["page"].rglob("*.tsx")) + \
             list(SHARED_FE.rglob("*.ts")) + list(SHARED_FE.rglob("*.tsx")):
        if ".test." in f.name:
            continue
        ids |= {m.group(1) for m in RE_I18N.finditer(f.read_text(encoding="utf-8", errors="ignore"))}
    cols, rows = rows_of(cur, """SELECT * FROM SCM_ADM_MSG_M WHERE MSG_ID IN
                                 (SELECT COLUMN_VALUE FROM TABLE(SYS.ODCIVARCHAR2LIST(%s)))
                                 ORDER BY MSG_ID, LANG_CD""" % ",".join(lit(i) for i in sorted(ids)))
    write(folder / "14_META_MSG_LBL.sql",
          "%s 사용 MSG/LBL %d코드 → %d행 (KO/EN/CN)" % (menu, len(ids), len(rows)),
          merge_sql("SCM_ADM_MSG_M", ["MSG_ID", "LANG_CD"], rows, cols))
    made.append("14_META_MSG_LBL.sql")

    # 7-1) locales PATCH (런타임 원천 — DB 만 넣으면 fallback 표시. hook #114 §5)
    patch = {}
    for lg in ("KO", "EN", "CN"):
        j = json.loads((LOCALES / ("%s.json" % lg)).read_text(encoding="utf-8"))
        patch[lg] = {i: j[i] for i in sorted(ids) if i in j}
    miss = sorted(i for i in ids if i not in patch["KO"])
    (folder / "locales_PATCH.json").write_text(
        json.dumps({"_note": "public/locales/{KO,EN,CN}.json 에 병합. 미등록 코드는 _missing 참조",
                    "_missing": miss, **patch}, ensure_ascii=False, indent=1), encoding="utf-8")
    made.append("locales_PATCH.json")

    # 8) 권한 (버튼/메뉴) — 값 갱신 불요 → 가드 INSERT ---------------------------
    lines = []
    cols, rows = rows_of(cur, "SELECT * FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = :m", m=menu)
    lines += ["-- SCM_ADM_USER_GR_MNU_MPG_M (%d행)" % len(rows)] + \
             guarded_insert("SCM_ADM_USER_GR_MNU_MPG_M", ["USER_GR_ID", "MNU_ID"], rows, cols)
    n_auth = len(rows)
    cols, rows = rows_of(cur, "SELECT * FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = :m", m=menu)
    lines += ["-- SCM_ADM_USER_GR_MNU_BTN_MPG_M (%d행)" % len(rows)] + \
             guarded_insert("SCM_ADM_USER_GR_MNU_BTN_MPG_M",
                            ["USER_GR_ID", "MNU_ID", "SHT_NM", "MNU_BTN_CD"], rows, cols)
    n_auth_btn = len(rows)
    write(folder / "15_META_AUTH.sql", "%s 권한 (메뉴/버튼) — 가드 INSERT" % menu, lines)
    made.append("15_META_AUTH.sql")

    # 9) FE ------------------------------------------------------------------
    fedir = folder / "fe"
    shutil.copytree(cfg["page"], fedir / cfg["page"].name,
                    ignore=shutil.ignore_patterns("*.test.ts", "*.test.tsx"))
    # ⛔ versionModal 만 복사 금지 (2026-08-11 클라우드 실사고) — 화면은 **barrel(components/index.ts)**
    #   경유로 import 하므로 barrel 없는 구본 환경에서 "does not provide an export named 'VersionModal'".
    #   barrel 은 fcst-upload-modal 도 export 하므로 **components/ 폴더 전체**가 이관 단위다.
    shutil.copytree(SHARED_FE.parent, fedir / "components", dirs_exist_ok=True,
                    ignore=shutil.ignore_patterns("*.test.ts", "*.test.tsx"))
    # ⭐ procedures.d.ts — DMF0044/0049 블록 포함본. 누락 시 클라우드 tsc 실패 (2026-08-11 사용자 지적).
    #   viewRegistry/Router 는 **이관 대상 아님** — glob 자동 수집 + DB ROUTE_PATH(10_META_WIRING 의
    #   MNU_M MERGE 에 포함)로 해석되므로 프론트 코드 수정이 없다(viewRegistry.tsx L11·L24 실측).
    (fedir / "configs" / "types").mkdir(parents=True, exist_ok=True)
    shutil.copy2(FE / "configs" / "types" / "procedures.d.ts",
                 fedir / "configs" / "types" / "procedures.d.ts")
    # ⭐ 2026-08-11 클라우드 type-check 8오류 실증 — 화면이 의존하는 **공용 코드 2세트**도 세대가 밀리면
    #   demand tsc 가 깨진다. 로컬 모노레포 판(11패키지 전부 통과)으로 동봉한다.
    #   · master components: DivisionFieldProps.disabled / VersionFieldProps.label·emptyText (SearchFields.tsx)
    #   · shared hooks: useTabProcQuery 반환 타입 세대 (useCustomQueryClient.ts)
    shutil.copytree(FE / "features/master/src/components", fedir / "master-components",
                    dirs_exist_ok=True, ignore=shutil.ignore_patterns("*.test.ts", "*.test.tsx"))
    shutil.copytree(FE / "packages/shared/src/hooks", fedir / "shared-hooks", dirs_exist_ok=True)
    made.append("fe/ (+configs/types/procedures.d.ts, master-components/, shared-hooks/)")

    return {"columns": n_col, "measures": n_msr, "api": n_api, "btn": n_btn, "proc": n_proc,
            "combos": len(combo_ids), "msg": len(ids), "msg_rows": len(rows),
            "auth_mnu": n_auth, "auth_btn": n_auth_btn, "gtt": len(gtts),
            "combo_ids": combo_ids, "locale_missing": miss, "files": made}


def build_upfx(cur, folder):
    """UP_FX SP → COMBO 전환분 일괄 이관 (등록 + 배선 + 소비 화면 인벤토리)."""
    cols, rows = rows_of(cur, """SELECT * FROM SCM_ADM_CMBO_SQL_M
                                  WHERE UPPER(SQL_NM) LIKE '%UP\\_FX%' ESCAPE '\\'
                                  ORDER BY CREATION_DATE, SQL_ID""")
    ids = [r["SQL_ID"] for r in rows]
    write(folder / "01_CMBO_UPFX.sql",
          "UP_FX SP → COMBO 전환분 %d종 — MERGE INTO (SQL_DTL_CTN CLOB 청크)" % len(rows),
          merge_sql("SCM_ADM_CMBO_SQL_M", ["SQL_ID"], rows, cols, clob_cols=("SQL_DTL_CTN",)))

    # 배선 — 이 콤보들을 셀 콤보로 쓰는 SHEET_COLUMNS 행 (등록만 가면 화면은 그대로 빈 콤보)
    cols2, rows2 = rows_of(cur, """SELECT * FROM SCM_MST_SHEET_COLUMNS
                                    WHERE CELL_COMBO_DATA_TYPE IN (SELECT COLUMN_VALUE FROM
                                          TABLE(SYS.ODCIVARCHAR2LIST(%s)))
                                    ORDER BY PROGRAM_ID, SHEET_NAME, SORT_ORDER_NO"""
                           % ",".join(lit(i) for i in ids))
    write(folder / "02_WIRING_SHEET_COLUMNS.sql",
          "UP_FX 콤보 **배선** — 소비 SHEET_COLUMNS %d행 (MERGE INTO — UI Category Setup 갱신)" % len(rows2),
          merge_sql("SCM_MST_SHEET_COLUMNS",
                    ["PROGRAM_ID", "SHEET_NAME", "COLUMN_NAME"], rows2, cols2))

    # 소비 화면 인벤토리 (검증용)
    inv = {}
    for r in rows2:
        inv.setdefault(r["PROGRAM_ID"], []).append(
            "%s.%s → %s" % (r["SHEET_NAME"], r["COLUMN_NAME"], r["CELL_COMBO_DATA_TYPE"]))
    return {"combos": len(rows), "ids": ids, "wiring": len(rows2), "screens": inv}


def main():
    global TS
    ap = argparse.ArgumentParser()
    ap.add_argument("--build", action="store_true")
    a = ap.parse_args()
    if not a.build:
        ap.error("--build 필요")

    now = datetime.datetime.now()
    TS = now.strftime("%Y-%m-%d %H:%M:%S")
    stamp = now.strftime("%Y%m%d_%H%M")

    u, p, d = conn_info()
    summary = {}
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for menu, cfg in UIS.items():
            folder = PKGROOT / ("%s_%s" % (menu, stamp))
            if folder.exists():
                shutil.rmtree(folder)
            folder.mkdir(parents=True)
            print("\n== %s → %s" % (menu, folder.name))
            summary[menu] = build_ui(cur, menu, cfg, folder)
            for k, v in summary[menu].items():
                if k not in ("combo_ids", "files", "locale_missing"):
                    print("   %-12s %s" % (k, v))
            print("   콤보 %d종: %s" % (len(summary[menu]["combo_ids"]),
                                     ", ".join(summary[menu]["combo_ids"])))
            if summary[menu]["locale_missing"]:
                print("   ⚠ locales 미등록 %d코드: %s"
                      % (len(summary[menu]["locale_missing"]), summary[menu]["locale_missing"]))

        folder = PKGROOT / ("UPFX_COMBO_%s" % stamp)
        if folder.exists():
            shutil.rmtree(folder)
        folder.mkdir(parents=True)
        print("\n== UPFX_COMBO → %s" % folder.name)
        summary["UPFX"] = build_upfx(cur, folder)
        print("   콤보 %d종 / 배선 SHEET_COLUMNS %d행 / 소비 화면 %d개"
              % (summary["UPFX"]["combos"], summary["UPFX"]["wiring"],
                 len(summary["UPFX"]["screens"])))
        for k, v in summary["UPFX"]["screens"].items():
            print("     %-10s %d컬럼" % (k, len(v)))

    (PKGROOT / ("_BUILD_SUMMARY_%s.json" % stamp)).write_text(
        json.dumps(summary, ensure_ascii=False, indent=1, default=str), encoding="utf-8")
    print("\n[done] stamp=%s" % stamp)


if __name__ == "__main__":
    main()
