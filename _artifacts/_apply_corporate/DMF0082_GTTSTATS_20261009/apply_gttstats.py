"""[E20261009-DMF0082GTTSTATS] DMF0082 조회 GTT 대표 통계 고정 — 파싱 시점 GTT 상태와 무관하게 계획 안정 (힌트 없음 · SP 무변경 · DELETE_TABLE_STATS 로 완전 원복)

배경: 클라우드 QA 10-09 12:08 PKG_DMF0082 재컴파일(SLASHOBJ 패키지) 직후 커서 재파싱 → GTT(TEMP_SITE_ITEM 등) 1행 추정 →
  c3bg6q8n39195(81/82 수요) MERGE JOIN CARTESIAN×2+NL 20~47s · d019r0hbb0muh(판가) PHV 3633386171 3,711s(BG 3억) · 6bucw2kzuc0nt(40 수요) 10~11s.
  같은 현상 10-01 에도(6bucw 130~407s). 사내 같은 문장 = HASH JOIN 0.05~1s. 재컴파일마다 재발하는 구조 결함(07-31 DMF0003 유형).
방식(07-31 DMF0003 검증 방식): GLOBAL_TEMP_TABLE_STATS=SHARED + SET_TABLE_STATS/SET_COLUMN_STATS(NO_INVALIDATE=>FALSE). LOCK 없음.
  대상 GTT 는 PKG_DMF0082 가 GATHER 하지 않음(09-30 QRYPERF 제거) · 타 패키지 GATHER 0 → ORA-20005 위험 없음.
사용: python apply_gttstats.py measure   # 사내 GTT 실적재 행수·NDV 측정만(division 40/81/82)
      python apply_gttstats.py apply     # 전(前) 캡처 → 통계 설정 → 후(後) 캡처 → 결과 동등성·계획·시간 비교 → _result.json
      python apply_gttstats.py rollback  # DELETE_TABLE_STATS + PREF SESSION 복원
"""
import sys, os, json, time, hashlib, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
MARK = "[E20261009-DMF0082GTTSTATS]"
GTTS = {   # 테이블: (대표 NUM_ROWS, 컬럼 NDV 기본값 — measure 단계에서 실측으로 갱신)
    "GT_DMF0082_TEMP_SITE_ITEM":        dict(rows=30000, cols={"DIVISION_ID":1, "PROJECT_CODE":1500, "SCM_SITE_ID":80, "ITEM_ID":4000, "ITEM_VALID_YN":2, "PLANT_SITE_ID":20}),
    "GT_DMF0082_TEMP_SELECT_MEASURE":   dict(rows=8,     cols={"MEASURE":8, "USER_ID":2, "MEASURE_GROUP":3}),
    "GT_DMF0082_T_WS_FCST":             dict(rows=14,    cols={"FCST_TYPE":14}),
    "GT_DMF0082_TEMP_FCST_N_PRICE":     dict(rows=100000,cols={"DIVISION_ID":1, "MEASURE":8, "YYYYMMDD":40, "PROJECT_CODE":1500, "SCM_SITE_ID":80, "ITEM_ID":4000, "MEASURE_GROUP":3, "PLANT_SITE_ID":20}),
    "GT_DMF0082_T_LAST_DATA_SETUP_FCST":dict(rows=2000,  cols={"DIVISION_ID":1, "PROJECT_CODE":500, "ITEM_ID":1000, "MEASURE":5}),
    "GT_DMF0082_MF_SP":                 dict(rows=50000, cols={"DIVISION_ID":1, "MEASURE":8, "PROJECT_CODE":1500, "SCM_SITE_ID":80, "ITEM_ID":4000}),
}
KEY_SQL = ["d019r0hbb0muh","c3bg6q8n39195","6bucw2kzuc0nt","18xg1y5298qgq","4svg4dhnqxh8f","631pzfvq8r0ut","20xrvz802rfsy","fk3tvpkzsq2vx","56fkh52zfndm7","19mfxqb34sbky"]
DIVS = ["40","81","82"]
USERS = [("minyonglee1","ADMIN"), ("k0101","ADMIN")]


def connect():
    u, p, d = conn_info(); return oracledb.connect(user=u, password=p, dsn=d)


def call_get(cur, div, user, grp):
    cur.execute("SELECT TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'), TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6)-1,'YYYYMMDD') FROM DUAL"); f, t = cur.fetchone()
    rcs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    t0 = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", [div, "ALL", "ALL", "ALL", f, t, "ALL", None, "Current", "N", user, grp, "ALL", "ALL", "ALL", "ALL"] + rcs)
    el = time.time() - t0
    out = []
    for v in rcs:
        c = v.getvalue(); rows = c.fetchall()
        # RC3 는 시각 포함(가변) → 행수만
        out.append(dict(rows=len(rows), md5=hashlib.md5(repr(sorted(map(repr, rows))).encode()).hexdigest()))
    return el, out


def gtt_measure(cur):
    """호출 직후(ROLLBACK 전) 같은 세션 GTT 실적재 — NUM_ROWS/NDV 실측"""
    m = {}
    for t, spec in GTTS.items():
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{t}"); n = cur.fetchone()[0]
        nd = {}
        for c in spec["cols"]:
            try:
                cur.execute(f"SELECT COUNT(DISTINCT {c}) FROM SCM_MGR.{t}"); nd[c] = cur.fetchone()[0]
            except oracledb.Error as e:
                nd[c] = f"ERR {str(e)[:40]}"
        m[t] = dict(rows=n, ndv=nd)
    return m


def key_plans(cur):
    cur.execute("""SELECT S.SQL_ID, S.CHILD_NUMBER, S.PLAN_HASH_VALUE, S.EXECUTIONS, ROUND(S.ELAPSED_TIME/1e6/GREATEST(S.EXECUTIONS,1),2), S.PROGRAM_LINE#, TO_CHAR(S.LAST_LOAD_TIME)
                     FROM V$SQL S WHERE S.SQL_ID IN (%s) ORDER BY 1,2""" % ",".join(f"'{x}'" for x in KEY_SQL))
    return [list(r) for r in cur.fetchall()]


def plan_lines(cur, sql_id):
    cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(:s, NULL, 'BASIC ROWS +NOTE'))", s=sql_id)
    return [r[0] for r in cur.fetchall() if r[0] and (r[0].startswith("|") or "dynamic" in r[0])]


def set_stats(cur, spec_rows):
    stmts = []
    for t, spec in GTTS.items():
        rows = spec_rows.get(t, spec["rows"]); blocks = max(8, int(rows * (0.6 if "SITE_ITEM" in t or "FCST_N_PRICE" in t or "MF_SP" in t else 0.1) * 1024 / 8192))
        cur.callproc("DBMS_STATS.SET_TABLE_PREFS", keyword_parameters=dict(ownname="SCM_MGR", tabname=t, pname="GLOBAL_TEMP_TABLE_STATS", pvalue="SHARED"))
        cur.callproc("DBMS_STATS.SET_TABLE_STATS", keyword_parameters=dict(ownname="SCM_MGR", tabname=t, numrows=rows, numblks=blocks, avgrlen=600 if ("SITE_ITEM" in t or "FCST_N_PRICE" in t or "MF_SP" in t) else 80, no_invalidate=False))
        stmts.append(f"EXEC DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','{t}','GLOBAL_TEMP_TABLE_STATS','SHARED');")
        stmts.append(f"EXEC DBMS_STATS.SET_TABLE_STATS('SCM_MGR','{t}', numrows=>{rows}, numblks=>{blocks}, no_invalidate=>FALSE);")
        for c, ndv in spec["cols"].items():
            ndv = max(1, int(ndv)); dens = 1.0 / ndv
            cur.callproc("DBMS_STATS.SET_COLUMN_STATS", keyword_parameters=dict(ownname="SCM_MGR", tabname=t, colname=c, distcnt=ndv, density=dens, nullcnt=0, no_invalidate=False))
            stmts.append(f"EXEC DBMS_STATS.SET_COLUMN_STATS('SCM_MGR','{t}','{c}', distcnt=>{ndv}, density=>{dens:.8f}, nullcnt=>0, no_invalidate=>FALSE);")
    return stmts


def rollback_stats(cur):
    for t in GTTS:
        cur.callproc("DBMS_STATS.DELETE_TABLE_STATS", keyword_parameters=dict(ownname="SCM_MGR", tabname=t, no_invalidate=False))
        cur.callproc("DBMS_STATS.SET_TABLE_PREFS", keyword_parameters=dict(ownname="SCM_MGR", tabname=t, pname="GLOBAL_TEMP_TABLE_STATS", pvalue="SESSION"))


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "measure"
    con = connect(); cur = con.cursor(); con.call_timeout = 3600000
    R = dict(started=str(datetime.datetime.now()), cmd=cmd)
    if cmd == "rollback":
        rollback_stats(cur); con.commit(); print("ROLLBACK done — stats deleted, pref SESSION"); return
    # 1) 전 캡처 (+ GTT 실측)
    R["before"] = {}; R["gtt_measure"] = {}
    for user, grp in USERS:
        for div in DIVS:
            if user == "k0101" and div != "82": continue
            el, out = call_get(cur, div, user, grp)
            if user == "minyonglee1": R["gtt_measure"][div] = gtt_measure(cur)
            con.rollback()
            R["before"][f"{div}/{user}"] = dict(sec=round(el, 2), cursors=out)
            print(f"BEFORE {div}/{user}: {el:6.2f}s rows={[c['rows'] for c in out]}")
    R["before_plans"] = key_plans(cur)
    for t, m in R["gtt_measure"].get("81", {}).items(): print("  GTT 81 실측", t, m)
    if cmd == "measure":
        json.dump(R, open(os.path.join(HERE, "_measure.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str); return
    # 2) 대표값 = 3 division 실측 최대치 (0 이면 기본값)
    spec_rows = {}
    for t, spec in GTTS.items():
        mx = max([R["gtt_measure"][d][t]["rows"] for d in DIVS] + [0])
        spec_rows[t] = mx if mx > 0 else spec["rows"]
        for c in list(spec["cols"]):
            vals = [R["gtt_measure"][d][t]["ndv"].get(c) for d in DIVS]
            vals = [v for v in vals if isinstance(v, int) and v > 0]
            if vals: spec["cols"][c] = max(vals)
    R["applied_spec"] = {t: dict(rows=spec_rows[t], cols=GTTS[t]["cols"]) for t in GTTS}
    stmts = set_stats(cur, spec_rows); con.commit()
    open(os.path.join(HERE, "01_GTTSTATS_applied_stmts.txt"), "w", encoding="utf-8").write("\n".join(stmts))
    R["applied_at"] = str(datetime.datetime.now()); print("STATS SET", R["applied_at"])
    # 3) 후 캡처 2회 (1회차 = 재파싱, 2회차 = 재사용)
    R["after"] = {}
    for rnd in (1, 2):
        for user, grp in USERS:
            for div in DIVS:
                if user == "k0101" and div != "82": continue
                el, out = call_get(cur, div, user, grp); con.rollback()
                k = f"{div}/{user}"
                R["after"][f"{k}#{rnd}"] = dict(sec=round(el, 2), cursors=out)
                same = all(a["rows"] == b["rows"] and (i == 2 or a["md5"] == b["md5"]) for i, (a, b) in enumerate(zip(R["before"][k]["cursors"], out)))
                print(f"AFTER#{rnd} {k}: {el:6.2f}s rows={[c['rows'] for c in out]} 결과동일(RC3 제외)={same}")
                R["after"][f"{k}#{rnd}"]["same_as_before"] = same
    R["after_plans"] = key_plans(cur)
    R["after_plan_text"] = {s: plan_lines(cur, s) for s in ("c3bg6q8n39195", "d019r0hbb0muh", "6bucw2kzuc0nt", "18xg1y5298qgq")}
    for s, L in R["after_plan_text"].items():
        print(f"--- plan {s}")
        for l in L[:40]: print("   ", l[:140])
    json.dump(R, open(os.path.join(HERE, "_result.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
    print("DONE")


if __name__ == "__main__":
    main()
