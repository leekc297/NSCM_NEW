#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0021 메타 배선 사내 적용 (사용자 일괄 승인 2026-07-14)
P1(메타 배선) → P2(TITLESET 병합) → P3(CMBO) → P4(MNU_URL) → P5(검증 SELECT).
단일 커넥션. 문장 분할 = 주석 제거 후 ';' (SQL 문자열 내 ';' 없음 — 작성 시 검증).
오류 시 즉시 중단 (P2 백업 CREATE 의 ORA-00955 재실행만 허용)."""
import io, sys, re, datetime, pathlib

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
AC = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
sys.path.insert(0, str(AC.parent / "_diagnostics"))
from ora import conn_info
import oracledb

LOG = AC / "_logs" / (datetime.datetime.now().strftime("%Y%m%d_%H%M%S") + "_DMF0021_meta_apply.log")
LOG.parent.mkdir(exist_ok=True)
logf = open(LOG, "w", encoding="utf-8")

def log(m):
    print(m)
    logf.write(m + "\n")
    logf.flush()

def statements(path):
    txt = path.read_text(encoding="utf-8")
    # 라인 주석 제거 (문자열 내 '--' 없음 — 작성 시 확인)
    lines = [ln for ln in txt.split("\n") if not ln.strip().startswith("--")]
    body = "\n".join(lines)
    return [s.strip() for s in body.split(";") if s.strip()]

FILES = ["DMF0021_P1_meta_wiring.sql", "DMF0021_P2_titleset_sheetname_merge.sql",
         "DMF0021_P3_cmbo_cell_prod_site.sql", "DMF0021_P4_mnu_url.sql",
         "DMF0021_P5_verify.sql"]

u, p, d = conn_info()
log(f"[conn] {u}@{d}  {datetime.datetime.now()}")
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

ok = True
for fname in FILES:
    log(f"\n===== {fname}")
    for st in statements(AC / fname):
        head = re.sub(r"\s+", " ", st)[:100]
        kind = st.split(None, 1)[0].upper()
        try:
            if kind == "COMMIT":
                con.commit()
                log("  COMMIT")
            elif kind == "SELECT":
                cur.execute(st)
                cols = [c[0] for c in cur.description]
                rows = cur.fetchall()
                log(f"  SELECT [{head[:60]}...] -> {len(rows)}행")
                for r in rows[:30]:
                    log("    " + " | ".join(str(x)[:60] for x in r))
            else:
                cur.execute(st)
                log(f"  {kind} rows={cur.rowcount}  [{head}...]")
        except oracledb.DatabaseError as e:
            err, = e.args
            if kind == "CREATE" and getattr(err, "code", None) == 955:
                log(f"  CREATE skip (기존재 — 재실행): {head}")
                continue
            log(f"  !! FAIL [{head}] {e}")
            con.rollback()
            ok = False
            break
    if not ok:
        break

con.close()
log(f"\n[{'DONE' if ok else 'ABORTED(rollback)'}] {datetime.datetime.now()}  log={LOG.name}")
sys.exit(0 if ok else 2)
