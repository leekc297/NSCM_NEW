#!/usr/bin/env python3
"""
DMF0008 클라우드 배포 SQL 사내 Oracle 적용.

대상:
  - 01_SP_BODY/010~060 (6 SP body fix)
  - 03_META/110 (SHEET_COLUMNS NULL flag fix)

각 파일을 statement 단위 분할 → 순차 실행 → 오류 캡쳐.
"""
import re
import datetime
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))

ROOT = Path("C:/Projects/NSCM/_artifacts/_deploy_packages/DMF0008")
FILES = [
    ROOT / "01_SP_BODY/010_DMF0008_updateHistory_SP_bodies.sql",
    ROOT / "01_SP_BODY/020_DMF0008_GET_EDI_MST_SUMMARY_FIX.sql",
    ROOT / "01_SP_BODY/030_DMF0008_GET_SALES_SITE_FIX_Truncate.sql",
    ROOT / "01_SP_BODY/040_DMF0008_GET_SALES_SITE_FIX_UtlCallStack.sql",
    ROOT / "01_SP_BODY/050_DMF0008_NVL_EXCEPTION_FLAG_Fix.sql",
    ROOT / "01_SP_BODY/060_DMF0008_NVL_EXCEPTION_FLAG_Recompile.sql",
    ROOT / "03_META/110_DMF0008_SHEET_COLUMNS_null_flags_fix.sql",
]

LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)


def split_statements(sql_text):
    """SQL*Plus style split: '/' on its own line ends PL/SQL; ';' ends SQL."""
    # 주석 줄 제거 (단순 -- 라인)
    cleaned = []
    for line in sql_text.split("\n"):
        s = line.strip()
        # SQL*Plus directives skip
        if re.match(r"^(SET|SPOOL|PROMPT|WHENEVER|DEFINE|UNDEFINE|VARIABLE|EXIT|SHOW)\b", s, re.IGNORECASE):
            continue
        cleaned.append(line)
    text = "\n".join(cleaned)
    # 분할: '/' 단독 줄 (PL/SQL) 또는 ';' (SQL)
    stmts = []
    buf = []
    for line in text.split("\n"):
        if line.strip() == "/":
            stmt = "\n".join(buf).strip()
            if stmt:
                stmts.append(stmt)
            buf = []
        else:
            buf.append(line)
    # 마지막 buffer (no trailing /) — ';' 기반 분할
    tail = "\n".join(buf).strip()
    if tail:
        # ';' 단순 분할 (문자열 안의 ; 무시 안 함 — DMF0008 SQL 은 안전 가정)
        for s in re.split(r";\s*\n", tail):
            s = s.strip().rstrip(";").strip()
            if s and not s.startswith("--"):
                stmts.append(s)
    return stmts


def apply_file(conn, fpath, log_lines):
    log_lines.append(f"\n=== {fpath.name} ===")
    text = fpath.read_text(encoding="utf-8", errors="ignore")
    stmts = split_statements(text)
    log_lines.append(f"  statements: {len(stmts)}")
    ok_cnt = 0
    err_cnt = 0
    for i, stmt in enumerate(stmts, 1):
        cur = conn.cursor()
        try:
            cur.execute(stmt)
            ok_cnt += 1
        except oracledb.DatabaseError as e:
            err_cnt += 1
            try:
                msg = str(e)[:200].replace("\n", " ")
            except (UnicodeDecodeError, UnicodeError):
                msg = "(UnicodeDecodeError reading Oracle error)"
            log_lines.append(f"  [{i}] ERR: {msg}")
            log_lines.append(f"       SQL: {stmt[:120].replace(chr(10),' ')}...")
        except (UnicodeDecodeError, UnicodeError) as ue:
            err_cnt += 1
            log_lines.append(f"  [{i}] UnicodeDecodeError reading Oracle response — skip")
            log_lines.append(f"       SQL: {stmt[:120].replace(chr(10),' ')}...")
        finally:
            try:
                cur.close()
            except Exception:
                pass
    try:
        conn.commit()
    except Exception:
        pass
    log_lines.append(f"  ok={ok_cnt} err={err_cnt}")
    return ok_cnt, err_cnt


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOG_DIR / f"{ts}_DMF0008_CLOUD_APPLY.log"
    log_lines = [
        f"=== DMF0008 클라우드 SQL → 사내 적용 ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
    ]
    conn = oracledb.connect(**CONN)
    cur0 = conn.cursor()
    cur0.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
    cur0.close()
    try:
        total_ok = 0
        total_err = 0
        for f in FILES:
            if not f.exists():
                log_lines.append(f"\n=== {f.name} === [SKIP] not found")
                continue
            ok, err = apply_file(conn, f, log_lines)
            total_ok += ok
            total_err += err

        # 검증
        log_lines.append(f"\n=== POST CHECK ===")
        cur = conn.cursor()
        # SHEET_COLUMNS NULL flag count
        cur.execute("""
            SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS
             WHERE PROGRAM_ID='DMF0008'
               AND (FIXED_FLAG IS NULL OR UPPERCASE_APPLY_FLAG IS NULL
                    OR USER_SELECTABLE_FLAG IS NULL OR DEFAULT_FLAG IS NULL
                    OR VISIBLE_FLAG IS NULL)
        """)
        null_cnt = cur.fetchone()[0]
        log_lines.append(f"  SHEET_COLUMNS NULL flag count: {null_cnt} (expected 0)")

        # DMF0008 SP STATUS
        cur.execute("""
            SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS
             WHERE OBJECT_NAME LIKE 'DMF0008%' AND OBJECT_TYPE='PROCEDURE'
             ORDER BY OBJECT_NAME
        """)
        invalid_sps = []
        sp_total = 0
        for r in cur.fetchall():
            sp_total += 1
            if r[1] != "VALID":
                invalid_sps.append(f"{r[0]}({r[1]})")
        log_lines.append(f"  DMF0008 SPs: {sp_total} total / {len(invalid_sps)} INVALID")
        for inv in invalid_sps:
            log_lines.append(f"    - {inv}")
        cur.close()

        log_lines.append(f"\n=== TOTAL ok={total_ok} err={total_err} ===")
        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        print(f"[OK] DMF0008 apply 완료 — ok={total_ok} err={total_err} / NULL flags={null_cnt} / INVALID SPs={len(invalid_sps)}")
        print(f"     log: {log_file}")
        return 0 if total_err == 0 and null_cnt == 0 and not invalid_sps else 5
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
