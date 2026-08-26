"""DMF0082 센티널 정리 실행 러너 (2026-08-20, 사용자 승인 — 배치 정규화 완료 후 실행)

같은 폴더의 01_BACKUP → 02_DEDUP_NORMALIZE → 03_DDL_DEFAULT_ON_NULL 을 단계별로 실행한다.
사용: python _artifacts/_apply_corporate/DMF0082_SENTINEL_20260820/run_sentinel.py <step>
      (step = backup | dedup | ddl)
접속: .env.asis 의 TOBE_DB_* (룰 32 — 평문 하드코딩 금지)
"""
import os
import re
import sys

import oracledb

BASE = os.path.dirname(os.path.abspath(__file__))
ENV_PATH = r"C:\Projects\NSCM\.env.asis"

FILES = {
    "backup": ("01_BACKUP.sql", 4),
    "dedup": ("02_DEDUP_NORMALIZE.sql", 8),
    "ddl": ("03_DDL_DEFAULT_ON_NULL.sql", 6),
}


def load_env():
    vals = {}
    with open(ENV_PATH, encoding="utf-8") as f:
        for ln in f:
            ln = ln.strip()
            if "=" in ln and not ln.startswith("#"):
                k, v = ln.split("=", 1)
                vals[k] = v
    return {
        "user": "SCM_MGR",
        "password": vals["TOBE_DB_PASS"],
        "dsn": f"{vals['TOBE_DB_HOST']}:{vals['TOBE_DB_PORT']}/{vals['TOBE_DB_PDB']}",
    }


def load_statements(path):
    with open(path, encoding="utf-8") as f:
        raw = f.read()
    lines = [ln for ln in raw.splitlines() if not ln.lstrip().startswith("--")]
    return [s.strip() for s in "\n".join(lines).split(";") if s.strip()]


def main():
    step = sys.argv[1]
    fname, expected = FILES[step]
    stmts = load_statements(os.path.join(BASE, fname))
    if len(stmts) != expected:
        sys.exit(f"ABORT: {fname} statement count {len(stmts)} != expected {expected}")

    conn = oracledb.connect(**load_env())
    cur = conn.cursor()
    for i, s in enumerate(stmts, 1):
        head = re.sub(r"\s+", " ", s)[:90]
        try:
            cur.execute(s)
        except oracledb.DatabaseError as e:
            print(f"[{i}/{len(stmts)}] ERROR {e.args[0].code}: {head}")
            raise
        if s.upper().startswith("SELECT"):
            print(f"[{i}] VERIFY {[d[0] for d in cur.description]}")
            for r in cur.fetchall():
                print("   ", r)
        elif s.upper().startswith(("DELETE", "UPDATE")):
            print(f"[{i}] {head} -> rows={cur.rowcount}")
        else:
            print(f"[{i}] OK: {head}")
    conn.commit()
    print(f"step {step} DONE")


if __name__ == "__main__":
    main()
