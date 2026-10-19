# -*- coding: utf-8 -*-
"""
DMF0082 #18 삭제 가드 — 주차 판정을 '대상년월별 주차' 로 정정.

결함 : PKG_DMF0082 BODY L13420(40 분기) / L13469(81 분기) 의
         `AND B.ISO_YYYYWW = D.ISO_YYYYWW`
       ISO 주차는 월경계에서 두 년월에 걸친다(실측: ISO 202636 = 202608(8/31) + 202609(9/1~6)).
       따라서 년월이 다른 같은 주차의 반대편 FCST 가 있으면 Sales Price 삭제가 오차단된다.

정정 : `AND B.BASIS_START_DATE = D.BASIS_START_DATE`
       BASIS_START_DATE 는 월경계에서 잘려 적재되어 (BASIS_YYYYMM, ISO_YYYYWW) 와 **양방향 1:1**
       (실측 2,624 조합 / 위반 0). 검증 10(등록 가드)·Excel 업로드 검증이 이미 쓰는 축과 동일.

# FRESH-GATE : 추출·적용 직전 ALL_SOURCE 재조회 후 기준본 동일성 assert (hook #152)
"""
import os, sys, pathlib, datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402

OWNER, NAME, TYPE = "SCM_MGR", "PKG_DMF0082", "PACKAGE BODY"
OUT = pathlib.Path(__file__).parent
OLD = "                      AND B.ISO_YYYYWW = D.ISO_YYYYWW"
NEW = "                      AND B.BASIS_START_DATE = D.BASIS_START_DATE"
TARGET_LINES = (13420, 13469)


def conn():
    env = {}
    p = pathlib.Path(r"C:\Projects\NSCM\.env.asis")
    for line in p.read_text(encoding="utf-8", errors="ignore").splitlines():
        if "=" in line and not line.strip().startswith("#"):
            k, v = line.split("=", 1)
            env[k.strip()] = v.strip()
    import re as _re
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    m = _re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
    if not m:
        raise SystemExit("접속정보 파싱 실패")
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


def fetch_source(cur):
    cur.execute(
        "SELECT line, text FROM all_source WHERE owner=:o AND name=:n AND type=:t ORDER BY line",
        o=OWNER, n=NAME, t=TYPE)
    return cur.fetchall()


def last_ddl(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status "
                "FROM all_objects WHERE owner=:o AND object_name=:n AND object_type=:t",
                o=OWNER, n=NAME, t=TYPE)
    return cur.fetchone()


def build(rows):
    """ALL_SOURCE → CREATE OR REPLACE 본문 + 치환."""
    by_line = {ln: (txt or "") for ln, txt in rows}
    hits = []
    for ln in TARGET_LINES:
        cur_txt = by_line.get(ln, "").rstrip("\n").rstrip("\r")
        if cur_txt != OLD:
            raise SystemExit(f"FRESH-GATE FAIL: L{ln} 기준본 불일치\n  기대=[{OLD}]\n  실제=[{cur_txt}]")
        by_line[ln] = NEW + "\n"
        hits.append(ln)
    body = "".join(by_line[ln] for ln in sorted(by_line))
    if not body.startswith("PACKAGE"):
        raise SystemExit("본문이 PACKAGE 로 시작하지 않음")
    ddl = "CREATE OR REPLACE " + body
    # 종결자: newline 보장 (SP patch 사고 1 학습)
    if not ddl.endswith("\n"):
        ddl += "\n"
    return ddl, hits


def main():
    apply_mode = "--apply" in sys.argv
    with conn() as db:
        cur = db.cursor()
        ddl_time, status = last_ddl(cur)
        rows = fetch_source(cur)
        fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        print(f"[FRESH] LAST_DDL={ddl_time} STATUS={status} LINES={len(rows)} FETCHED={fetched}")

        ddl, hits = build(rows)
        print(f"[BUILD] 치환 완료 lines={hits}  DDL {len(ddl.splitlines())} lines")

        stamp = (f"-- SOURCE-FRESH: {OWNER}.{NAME} {TYPE} LAST_DDL={ddl_time} "
                 f"FETCHED={fetched} DB=ZIOUI1\n")
        f = OUT / "01_PKG_DMF0082_BODY.sql"
        f.write_text(stamp + ddl + "/\n", encoding="utf-8")
        print(f"[FILE] {f}")

        if not apply_mode:
            print("[DRY-RUN] --apply 미지정 — 적용하지 않음")
            return

        # FRESH-GATE 재확인 (적용 직전)
        ddl_time2, _ = last_ddl(cur)
        if ddl_time2 != ddl_time:
            raise SystemExit(f"FRESH-GATE FAIL: 적용 직전 LAST_DDL 변동 {ddl_time} → {ddl_time2}")
        cur.execute(ddl)
        db.commit()
        cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') "
                    "FROM all_objects WHERE owner=:o AND object_name=:n AND object_type=:t",
                    o=OWNER, n=NAME, t=TYPE)
        st, dt = cur.fetchone()
        print(f"[APPLY] STATUS={st} LAST_DDL={dt}")
        cur.execute("SELECT line, position, text FROM all_errors "
                    "WHERE owner=:o AND name=:n AND type=:t ORDER BY sequence",
                    o=OWNER, n=NAME, t=TYPE)
        errs = cur.fetchall()
        print(f"[ERRORS] {len(errs)}건")
        for e in errs[:10]:
            print("   ", e)


if __name__ == "__main__":
    main()
