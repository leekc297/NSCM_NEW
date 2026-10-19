"""[E20261002-IFDEPTSSPM] 검증 — PR_DM_BPS_METAL_LINK_S 의 실제 SQL 을 읽기 전용으로 실행해 DEPT 산출 결과 비교

방식: SP 원문에서 ① GTT 적재 3문 ② XIF INSERT 의 SELECT 부를 그대로 잘라, 파라미터만 바인드로 바꿔 실행한다.
      XIF(INF_MGR) 에는 쓰지 않는다 — SELECT 결과만 집계. GTT 는 세션 전용이며 끝에 ROLLBACK.
      (SP 자체를 호출하지 않는 이유: 내부 COMMIT 으로 I/F 테이블에 신규 버전 행이 실제 적재됨)

사용:
  python test_select.py db    <DIV> <VERSION>   # 지금 DB 에 있는 원문 기준
  python test_select.py tobe  <DIV> <VERSION>   # 01_ 파일(적용 예정본) 기준
"""
import sys, os, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B


def cut(src, start, end, what):
    i = src.find(start)
    if i < 0 or src.count(start) != 1:
        sys.exit(f"ABORT: {what} 시작 위치 특정 불가")
    j = src.find(end, i)
    if j < 0:
        sys.exit(f"ABORT: {what} 끝 위치 특정 불가")
    return src[i:j + len(end)].rstrip(";")


def binds(sql):
    sql = re.sub(r"\bP_DIVISION_ID\b", ":div", sql)
    sql = re.sub(r"\bP_CUT_OFF_VERSION\b", ":ver", sql)
    sql = re.sub(r"\bV_YYYYMMDD\b", ":ymd", sql)
    return sql


def run(mode, div, ver):
    with B.connect() as con:
        cur = con.cursor()
        if mode == "db":
            s = B.read_source(cur)
            src = s["src"]
            print("SOURCE = DB", s["last_ddl"], "marker", src.count(B.MARK))
        else:
            src = B.strip(open(B.F_TOBE, encoding="utf-8").read())[len("CREATE OR REPLACE "):]
            print("SOURCE = 01 파일", "marker", src.count(B.MARK))

        g1 = cut(src, "INSERT\n          INTO GT_DBML_SCM_SYS_CALENDAR_M", "AND A.BASIS_YYYYMMDD = V_YYYYMMDD;", "GTT1")
        g2 = cut(src, "INSERT\n          INTO GT_DBML_VERSION_NO", "WHERE A.RNK = 1;", "GTT2")
        g3 = cut(src, "INSERT\n          INTO GT_DBML_VERSION_SEQ", "GROUP BY A.DIVISION_ID) A;", "GTT3")
        sel = cut(src, "SELECT '' AS IFDATE", "AND T3.VALID_YN(+) = 'Y';", "XIF SELECT")

        ymd = ver[5:13]  # SP: SUBSTR(P_CUT_OFF_VERSION, 6, 8)
        for t in ("GT_DBML_SCM_SYS_CALENDAR_M", "GT_DBML_VERSION_NO", "GT_DBML_VERSION_SEQ"):
            cur.execute(f"DELETE FROM {t}")

        def ex(sql):
            b = {k: v for k, v in (("div", div), ("ver", ver), ("ymd", ymd)) if re.search(rf":{k}\b", sql)}
            cur.execute(sql, b)
            return cur.rowcount

        print("GTT rows", ex(binds(g1)), ex(binds(g2)), ex(binds(g3)))
        cur.execute("SELECT COUNT(*) FROM DM_BPS_METAL_LINK_PRICE_C WHERE DIVISION_ID=:d AND VERSION_NO=:v", d=div, v=ver)
        n_c = cur.fetchone()[0]

        q = binds(sel)
        cur.execute(f"SELECT COUNT(*), COUNT(DEPT_ID), COUNT(DEPT_NAME_KO), "
                    f"SUM(CASE WHEN DEPT_ID = '-' THEN 1 ELSE 0 END), MIN(VERSION_NO), MAX(VERSION_NO) FROM ({q})")
        n, n_dept, n_name, n_dash, vmin, vmax = cur.fetchone()
        print(f"_C rows {n_c} / SELECT rows {n} (행 수 동일 {n == n_c}) / DEPT_ID 채움 {n_dept} / 부서명 채움 {n_name} / '-' {n_dash} / I/F VERSION {vmin}~{vmax}")
        cur.execute(f"SELECT NVL(DEPT_ID,'<NULL>'), NVL(DEPT_NAME_KO,'<NULL>'), COUNT(*) FROM ({q}) GROUP BY DEPT_ID, DEPT_NAME_KO ORDER BY 3 DESC")
        for r in cur.fetchmany(12):
            print("   ", r)

        # 기대값 대사: SSPM DEPT_ID 를 SP 와 별개 SQL 로 직접 구해 행 단위 비교
        cur.execute(f"""
            SELECT COUNT(*), SUM(CASE WHEN NVL(X.DEPT_ID,'~') = NVL(E.DEPT_ID,'~') THEN 0 ELSE 1 END)
              FROM ({q}) X
              JOIN (SELECT C.DIVISION_ID, C.PLAN_YYYYMM, C.FCST_TYPE, C.SCM_SITE_ID, C.END_CUSTOMER, C.PROJECT_CODE, C.PLANT_SITE_ID,
                           C.ITEM_ID, C.METAL_KIND_CODE, C.CURRENCY, C.DEPT_ID C_DEPT, SI.DEPT_ID
                      FROM DM_BPS_METAL_LINK_PRICE_C C
                      LEFT JOIN SCM_MST_SITE_ITEM SI
                             ON SI.DIVISION_ID = C.DIVISION_ID
                            AND SI.PROJECT_CODE = CASE WHEN C.DIVISION_ID = '40' THEN C.END_CUSTOMER ELSE C.PROJECT_CODE END
                            AND SI.SCM_SITE_ID = C.SCM_SITE_ID AND SI.ITEM_ID = C.ITEM_ID AND SI.VALID_YN = 'Y'
                     WHERE C.DIVISION_ID = :d AND C.VERSION_NO = :v) E
                ON E.DIVISION_ID = X.DIVISION_ID AND E.PLAN_YYYYMM = X.PLAN_YYYYMM AND E.FCST_TYPE = X.FCST_TYPE
               AND E.SCM_SITE_ID = X.SCM_SITE_ID AND E.END_CUSTOMER = X.END_CUSTOMER AND E.PROJECT_CODE = X.PROJECT_CODE
               AND E.PLANT_SITE_ID = X.PLANT_SITE_ID AND E.ITEM_ID = X.ITEM_ID AND E.METAL_KIND_CODE = X.METAL_KIND_CODE
               AND E.CURRENCY = X.CURRENCY""",
                    {**{k: v for k, v in (("div", div), ("ver", ver)) if re.search(rf":{k}\b", q)}, "d": div, "v": ver})
        m, bad = cur.fetchone()
        print(f"SSPM 기대값 대사: 매칭 {m} 행 / DEPT_ID 불일치 {bad}")
        con.rollback()
        print("ROLLBACK (XIF 미적재)")


if __name__ == "__main__":
    run(sys.argv[1], sys.argv[2], sys.argv[3])
