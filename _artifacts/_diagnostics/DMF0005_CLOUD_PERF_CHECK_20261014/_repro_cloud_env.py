# -*- coding: utf-8 -*-
"""클라우드 조건 모사 재현 (사내 ZIOUI1, 읽기 전용 — 조회 프로시저만 호출).

클라우드 C01 결과: optimizer_adaptive_plans = FALSE (사내 TRUE). BODY 교체 뒤 조회 문장은 새로 파싱되고,
BE 커넥션들은 그 커서 1개를 사업부 · 조회조건 불문 함께 쓴다(첫 호출의 바인드로 계획이 굳는다).

여기서는 세션에서 adaptive_plans 를 끄고, 계획에 영향 없는 세션 설정 조합으로 "새 파싱"을 여러 번 만들어
  (첫 호출 = 파싱 시나리오) → 같은 커서로 나머지 시나리오 실행
의 소요 시간 · 계획(PHV)을 표로 낸다. 호출 제한 90초.

  python _repro_cloud_env.py
"""
import sys, time, pathlib, itertools
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

USER = "minyonglee1"
TIMEOUT_MS = 90000
# (이름, div, dept, cust, site, pjt, item, active, owner)
SCN = [
    ("82 전체",        "82", "ALL", "ALL", "ALL", None, None, "ALL", None),
    ("81 전체",        "81", "ALL", "ALL", "ALL", None, None, "ALL", None),
    ("40 전체",        "40", "ALL", "ALL", "ALL", None, None, "ALL", None),
    ("40 site 조건",   "40", "ALL", "ALL", "{SITE40}", None, None, "ALL", None),
    ("82 site 조건",   "82", "ALL", "ALL", "{SITE82}", None, None, "ALL", None),
    ("40 item 조건",   "40", "ALL", "ALL", "ALL", None, "MP", "ALL", None),
]
# 계획에는 영향이 없고 옵티마이저 환경만 달라져 새 자식 커서(새 파싱)를 만드는 세션 설정
TOGGLES = ["optimizer_use_invisible_indexes", "optimizer_use_pending_statistics", "optimizer_ignore_parallel_hints"]


def main():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    con.call_timeout = TIMEOUT_MS
    cur = con.cursor()
    cur.arraysize = 5000
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone())
    site = {}
    for div in ("40", "82"):
        cur.execute("SELECT scm_site_id FROM (SELECT scm_site_id, COUNT(*) c FROM scm_mst_site_item WHERE division_id=:d GROUP BY scm_site_id ORDER BY c DESC) WHERE ROWNUM=1", d=div)
        site[div] = cur.fetchone()[0]
    scn = [tuple(x.replace("{SITE40}", site["40"]).replace("{SITE82}", site["82"]) if isinstance(x, str) else x for x in s) for s in SCN]
    print("site 조건 값:", site)
    cur.execute("ALTER SESSION SET optimizer_adaptive_plans = FALSE")

    def last_cursor():
        cur.execute("""SELECT sql_id, child_number, plan_hash_value FROM (
                         SELECT sql_id, child_number, plan_hash_value FROM v$sql
                          WHERE sql_text LIKE 'WITH ITEM_AGG AS%' AND sql_text LIKE '%OWNER_NM%'
                          ORDER BY last_active_time DESC, last_load_time DESC) WHERE ROWNUM = 1""")
        return cur.fetchone()

    def call(s):
        o1, o2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
        t = time.time()
        try:
            cur.callproc("SCM_MGR.PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION", list(s[1:]) + [USER, o1, o2])
            c = o1.getvalue(); c.arraysize = 5000
            n = 0
            while True:
                rows = c.fetchmany(5000)
                if not rows:
                    break
                n += len(rows)
            el = time.time() - t
            con.rollback()
            return el, n, None
        except oracledb.Error as e:
            el = time.time() - t
            try:
                con.rollback()
            except oracledb.Error:
                pass
            return el, -1, str(e).split("\n")[0][:70]

    combos = list(itertools.product(("FALSE", "TRUE"), repeat=len(TOGGLES)))
    slow = []
    for i, first in enumerate(scn):
        for name, val in zip(TOGGLES, combos[i + 1]):   # combos[0] = 전부 FALSE(기본 환경)는 쓰지 않는다 — 기존 커서와 겹침
            cur.execute(f"ALTER SESSION SET {name} = {val}")
        print(f"\n=== 새 파싱 #{i+1} — 첫 호출(계획이 굳는 호출) = [{first[0]}]")
        order = [first] + [s for s in scn if s is not first]
        for j, s in enumerate(order):
            el, n, err = call(s)
            sid, ch, phv = last_cursor() or ("-", "-", "-")
            flag = "  ❌ 제한시간" if err else ("  ⚠ 느림" if el >= 10 else "")
            print(f"   {'첫' if j == 0 else '재'} | {s[0]:<14} | {el:7.2f}s | rows {n:>6} | {sid}/{ch} PHV {phv}{flag}{' ' + err if err else ''}")
            if err or el >= 10:
                slow.append((first[0], s[0], sid, ch, phv, el))
    print("\n느린 조합:", len(slow))
    seen = set()
    for f, s, sid, ch, phv, el in slow:
        print(f"  파싱=[{f}] 실행=[{s}] {el:.1f}s {sid}/{ch} PHV {phv}")
        if (sid, ch) in seen or sid == "-":
            continue
        seen.add((sid, ch))
        cur.execute("SELECT plan_table_output FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(:s, :c, 'TYPICAL +PEEKED_BINDS +NOTE'))", s=sid, c=ch)
        for (l,) in cur:
            print("     ", l)


if __name__ == "__main__":
    main()
