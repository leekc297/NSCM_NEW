"""[E20261014-DMF0005SITECNT] 조회 결과 동등성 · QA 조건 시간 (읽기 전용 — 조회 프로시저만 호출)

  python test_equiv.py equiv <A 패키지> <B 패키지>     # 같은 시나리오를 두 패키지로 호출해 결과(행 · 값 · 순서 · 컬럼) 비교
  python test_equiv.py snap  <패키지>                  # 시나리오 결과를 _snap.pkl 로 저장 (적용 전)
  python test_equiv.py cmp   <패키지>                  # _snap.pkl 과 비교 (적용 후)
  python test_equiv.py qa    <패키지>                  # QA 조건 모사(바인드 엿보기 끔 · adaptive plans 끔)로 새 파싱 뒤 시간 측정

시나리오: 사업부 8개 전체 조회 + 81 · 82 · 40 의 조회조건(팀 · 고객 · 사이트 · 프로젝트 · 모델 · Active · Owner) 조합.
조건 값은 원장에서 행 수가 많은 값을 뽑아 쓴다(0행 시나리오로 통과하지 않게 — 0행은 표시).
"""
import sys, os, time, pickle
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
SNAP = os.path.join(HERE, "_snap.pkl")
USERS = ("minyonglee1", "k0101")


def connect():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone())
    return con, cur


def scenarios(cur):
    s = []
    cur.execute("SELECT division_id FROM scm_mst_site_item GROUP BY division_id ORDER BY COUNT(*) DESC")
    divs = [r[0] for r in cur]
    for d in divs:
        s.append((f"{d} 전체", d, "ALL", "ALL", "ALL", None, None, "ALL", None))

    def top(sql, d):
        cur.execute(f"SELECT v FROM ({sql}) WHERE ROWNUM <= 2", d=d)
        return [r[0] for r in cur]
    for d in ("81", "82", "40", "81_UC"):
        # SALES 사이트 중 원장 행이 많은 사이트 2개 / 팀 2개 / 프로젝트 1개 / 모델 접두 / Owner
        sites = top("SELECT si.scm_site_id v FROM scm_mst_site_item si JOIN scm_mst_site st ON st.division_id=si.division_id AND st.scm_site_id=si.scm_site_id AND st.site_type='SALES' WHERE si.division_id=:d GROUP BY si.scm_site_id ORDER BY COUNT(*) DESC", d)
        depts = top("SELECT dept_id v FROM scm_mst_site_item WHERE division_id=:d AND dept_id IS NOT NULL GROUP BY dept_id ORDER BY COUNT(*) DESC", d)
        pjts = top("SELECT project_code v FROM scm_mst_site_item WHERE division_id=:d GROUP BY project_code ORDER BY COUNT(*) DESC", d)
        owners = top("SELECT owner v FROM scm_mst_site_item WHERE division_id=:d AND owner IS NOT NULL AND INSTR(owner, ',') = 0 GROUP BY owner ORDER BY COUNT(*) DESC", d)
        items = top("SELECT SUBSTR(item_id,1,4) v FROM scm_mst_site_item WHERE division_id=:d GROUP BY SUBSTR(item_id,1,4) ORDER BY COUNT(*) DESC", d)
        custs = top("SELECT st.end_customer v FROM scm_mst_site_item si JOIN scm_mst_site st ON st.division_id=si.division_id AND st.scm_site_id=si.scm_site_id AND st.site_type='SALES' WHERE si.division_id=:d AND st.end_customer IS NOT NULL GROUP BY st.end_customer ORDER BY COUNT(*) DESC", d)
        if sites:
            s.append((f"{d} site 1", d, "ALL", "ALL", sites[0], None, None, "ALL", None))
            s.append((f"{d} site 2개", d, "ALL", "ALL", ",".join(sites), None, None, "ALL", None))
        if depts:
            s.append((f"{d} 팀", d, depts[0], "ALL", "ALL", None, None, "ALL", None))
            s.append((f"{d} 팀 2개 + Active Y", d, ",".join(depts), "ALL", "ALL", None, None, "Y", None))
        if custs:
            s.append((f"{d} 고객", d, "ALL", custs[0], "ALL", None, None, "ALL", None))
        if pjts:
            s.append((f"{d} 프로젝트", d, "ALL", "ALL", "ALL", pjts[0], None, "ALL", None))
        if items:
            s.append((f"{d} 모델 접두", d, "ALL", "ALL", "ALL", None, items[0].lower(), "ALL", None))
        if owners:
            s.append((f"{d} Owner", d, "ALL", "ALL", "ALL", None, None, "ALL", owners[0]))
        s.append((f"{d} Active N", d, "ALL", "ALL", "ALL", None, None, "N", None))
        s.append((f"{d} Active Y", d, "ALL", "ALL", "ALL", None, None, "Y", None))
    return s


def call(con, cur, pkg, s, user):
    o1, o2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    t = time.time()
    cur.callproc(f"SCM_MGR.{pkg}.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION", list(s[1:]) + [user, o1, o2])
    c = o1.getvalue(); c.arraysize = 5000
    cols = [x[0] for x in c.description]
    rows = c.fetchall()
    con.rollback()
    return cols, rows, time.time() - t


def run_all(con, cur, pkg):
    out = {}
    for s in scenarios(cur):
        for user in USERS:
            out[(s[0], user)] = call(con, cur, pkg, s, user)[:2]
    return out


def compare(a, b, la, lb):
    fail = zero = 0
    edit_y = 0
    for k in a:
        ca, ra = a[k]; cb, rb = b[k]
        ok = ca == cb and ra == rb
        fail += (not ok)
        zero += (len(ra) == 0)
        if "EDIT_FLAG" in ca:
            edit_y += sum(1 for r in ra if r[ca.index("EDIT_FLAG")] == "Y")
        print("PASS" if ok else "FAIL", f"| {k[0]:<24} | {k[1]:<12} | {la} {len(ra):>6}행 {len(ca)}칸 | {lb} {len(rb):>6}행 {len(cb)}칸"
              + ("" if ok else f" | 컬럼 동일 {ca == cb} · 순서 무시 동일 {sorted(map(repr, ra)) == sorted(map(repr, rb))}") + ("  (0행)" if len(ra) == 0 else ""))
    print(f"RESULT {'PASS' if fail == 0 else 'FAIL ' + str(fail)} — 시나리오 {len(a)} · 0행 {zero} · 총 {sum(len(v[1]) for v in a.values())}행 · EDIT_FLAG Y {edit_y}행")
    return fail


def main():
    mode = sys.argv[1]
    con, cur = connect()
    if mode == "equiv":
        a, b = run_all(con, cur, sys.argv[2]), run_all(con, cur, sys.argv[3])
        sys.exit(1 if compare(a, b, sys.argv[2][-7:], sys.argv[3][-7:]) else 0)
    if mode == "snap":
        pickle.dump(run_all(con, cur, sys.argv[2]), open(SNAP, "wb")); print("SAVED", SNAP); return
    if mode == "cmp":
        sys.exit(1 if compare(pickle.load(open(SNAP, "rb")), run_all(con, cur, sys.argv[2]), "적용전", "적용후") else 0)
    if mode == "qa":
        pkg = sys.argv[2]
        con.call_timeout = 180000
        cur.execute('ALTER SESSION SET "_optim_peek_user_binds" = FALSE')
        cur.execute("ALTER SESSION SET optimizer_adaptive_plans = FALSE")
        cur.execute("SELECT object_id FROM user_objects WHERE object_name = :n AND object_type = 'PACKAGE BODY'", n=pkg)
        body_id = cur.fetchone()[0]
        sc = [s for s in scenarios(cur) if s[0] in ("40 전체", "82 전체", "81 전체", "81_UC 전체", "40 site 1", "82 팀", "81 모델 접두", "81 Active Y")]
        shown = set()
        for s in sc:
            try:
                cols, rows, el = call(con, cur, pkg, s, USERS[0])
                msg = f"{el:7.2f}s | {len(rows):>6}행"
            except oracledb.Error as e:
                msg = "❌ " + str(e).split("\n")[0][:60]
                try:
                    con.rollback()
                except oracledb.Error:
                    pass
            cur.execute("""SELECT sql_id, child_number, plan_hash_value FROM (SELECT sql_id, child_number, plan_hash_value FROM v$sql
                            WHERE program_id = :b AND sql_text LIKE 'WITH ITEM_AGG AS%' ORDER BY last_active_time DESC, last_load_time DESC) WHERE ROWNUM = 1""", b=body_id)
            lc = cur.fetchone() or ("-", "-", "-")
            print(f"QA조건 | {s[0]:<14} | {msg} | {lc[0]}/{lc[1]} PHV {lc[2]}")
            if lc[0] != "-" and lc[2] not in shown:
                shown.add(lc[2])
                cur.execute("SELECT plan_table_output FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(:s, :c, 'BASIC +ROWS +NOTE'))", s=lc[0], c=lc[1])
                on = False
                for (l,) in cur:
                    on = on or bool(l and l.startswith("Plan hash value"))
                    if on:
                        print("    ", l)


if __name__ == "__main__":
    main()
