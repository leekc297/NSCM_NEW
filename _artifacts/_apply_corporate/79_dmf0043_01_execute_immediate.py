#!/usr/bin/env python3
"""
F1 — V2 SP body 의 INSERT GT_SALES_LIST_C 를 EXECUTE IMMEDIATE 로 변환

배경:
  같은 INSERT SELECT 가
    - direct cur.execute(SQL) → 1385 row OK
    - PL/SQL anonymous block 안 → 0 row (silent)
    - V2 SP body 안 PL/SQL → 0 row (silent)
  → PL/SQL parser 의 '' literal 또는 GROUP BY NULL key 처리 차이.
  Fix: PL/SQL INSERT 를 EXECUTE IMMEDIATE 로 wrap → SQL session 동등 동작.

수정 위치:
  V2 SP body L327~L442 의 `INSERT INTO GT_DMF0043_SALES_LIST_C ... SELECT * FROM (...) A;`
  변수 4개 (p_division_id, p_version_no, p_ver_seq, p_million_yn) → bind :1..:4 + USING

검증:
  V2 SP 호출 → main rows + non_zero cell 확인
"""
import datetime, re
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")
SP = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V2"
BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== F1: EXECUTE IMMEDIATE 변환 ({ts}) ==="]
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 5")
    try:
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SP)
        src = "".join((r[0] or "") for r in cur.fetchall())
        (BACKUP_DIR / f"{SP}_F1_before_{ts}.sql").write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log.append(f"  [BACKUP] {len(src)} chars")

        # INSERT block 추출 — 'INSERT INTO GT_DMF0043_SALES_LIST_C' 부터 첫 ') A;' (closing) 까지
        start_pat = "    INSERT INTO GT_DMF0043_SALES_LIST_C\n"
        start_idx = src.find(start_pat)
        if start_idx < 0:
            log.append("  [FAIL] INSERT block not found")
            return 2
        # 끝: '\t     ) A;\n' 첫 occurrence
        end_pat = "\t     ) A;\n"
        end_idx = src.find(end_pat, start_idx)
        if end_idx < 0:
            log.append("  [FAIL] INSERT block end not found")
            return 3
        end_idx += len(end_pat)
        original_block = src[start_idx:end_idx]
        log.append(f"  [BLOCK] start={start_idx} end={end_idx} size={len(original_block)} chars")

        # bind 변환: PL/SQL 변수 → :1, :2, :3, :4
        sql_body = original_block
        sql_body = sql_body.replace("INSERT INTO GT_DMF0043_SALES_LIST_C\n    ", "INSERT INTO GT_DMF0043_SALES_LIST_C\n", 1).rstrip(";\n")
        # 변수 치환 — PL/SQL var → bind
        sql_body = sql_body.replace("NVL(p_million_yn,'N')", ":4")
        sql_body = sql_body.replace("p_division_id", ":1")
        sql_body = sql_body.replace("p_version_no", ":2")
        # WHERE B.VER_SEQ = p_ver_seq 형태 (TO_NUMBER 안)
        sql_body = sql_body.replace("TO_NUMBER(p_ver_seq)", "TO_NUMBER(:3)")
        # 최종 SQL string 내부의 single quote escape — Q-quote 사용해 회피
        # q'[...]' 안에서는 ']' 만 escape 필요. SQL body 안에 ']' 가 없으므로 안전.

        # EXECUTE IMMEDIATE block 생성
        ei_block = (
            "    EXECUTE IMMEDIATE q'[\n"
            + sql_body
            + "\n    ]' USING :1, :2, :3, :4;\n"
        )
        # USING 의 위치 변수 — :1..:4 의 ordering 와 일치하도록 작성
        ei_block = (
            "    EXECUTE IMMEDIATE q'[\n"
            + sql_body
            + "\n    ]' USING p_division_id, p_version_no, p_ver_seq, p_million_yn;\n"
        )

        # SP body 의 INSERT block 을 EXECUTE IMMEDIATE block 으로 교체
        patched_src = src[:start_idx] + ei_block + src[end_idx:]
        log.append(f"  [PATCHED] new size={len(patched_src)} (delta {len(patched_src)-len(src)})")

        # CREATE OR REPLACE
        try:
            cur.execute("CREATE OR REPLACE " + patched_src)
            conn.commit()
            log.append("  [CREATE OR REPLACE] OK")
        except oracledb.DatabaseError as e:
            log.append(f"  [ERR] {str(e)[:200]}")
            cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n ORDER BY SEQUENCE", n=SP)
            for ln, pos, text in cur.fetchall()[:10]:
                log.append(f"    L{ln}:{pos} {text}")
            return 5

        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=SP)
        status = cur.fetchone()[0]
        log.append(f"  [STATUS] {status}")
        if status != 'VALID':
            cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY", n=SP)
            for ln, pos, text in cur.fetchall():
                log.append(f"    L{ln}:{pos} {text}")
            return 6

        # Sanity 호출
        for vs, vno in [('9','R_S_20251126_V002_C'), ('9','R_B_20260223_V001'), ('9','R_B_20250206_V003'), ('12','R_S_20260128_V002_C')]:
            rc_m = cur.var(oracledb.CURSOR); rc_s = cur.var(oracledb.CURSOR); rc_c = cur.var(oracledb.CURSOR)
            try:
                cur.callproc(SP, ['40', vs, vno, '', 'ALL', 'ALL', 'N', 'N', 'minyonglee1', rc_m, rc_s, rc_c])
                mrows = rc_m.getvalue().fetchall()
                if mrows:
                    cs = [d[0] for d in rc_m.getvalue().description]
                    r0 = dict(zip(cs, mrows[0]))
                    nz = sum(1 for v in r0.values() if isinstance(v,(int,float)) and v != 0)
                    log.append(f"  [SANITY] verSeq={vs} VER={vno:<26} rows={len(mrows)} non_zero={nz}")
                    if nz > 0:
                        sample = {k: v for k, v in r0.items() if isinstance(v,(int,float)) and v != 0}
                        log.append(f"    sample: {dict(list(sample.items())[:3])}")
            except Exception as e:
                log.append(f"  [SANITY ERR] verSeq={vs}: {str(e)[:100]}")

        log.append("  [DONE]")
        print("[OK] F1 apply 완료")
    finally:
        (LOG_DIR / f"{ts}_F1.log").write_text("\n".join(log), encoding="utf-8")
        conn.close()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
