"""[E20261013-DMF0082ADJYNALL] 검증 — 단가 검증(#10) 문장을 수정 전(백업본)·후(DB 적용본)에서 그대로 추출해 같은 가상 입력으로 실행

 세션 GTT 만 사용 (GT_PRDM1_T_MAIN 가상 입력행 · GT_PRDM1_T_PRICE 판가 · GT_PRDM1_MSHYCHU1/2 = SP 와 같은 룩업 적재). 끝에 ROLLBACK.
 케이스 (40 · MKT_FCST · 수량 1 · 다음 주 화요일):
   A  조정 제외(N) 품목 + 그 주 판가 없음   → 전: 통과(제외) / 후: 차단   ← 이번 변경
   B  조정 제외(N) 품목 + 그 주 판가 있음   → 전: 통과 / 후: 통과
   C  일반 품목 + 그 주 판가 없음           → 전: 차단 / 후: 차단 (불변)
   D  일반 품목 + 그 주 판가 있음           → 전: 통과 / 후: 통과 (불변)
   E  조정 제외(N) 품목 + 검증 제외 Fcst Type(SPF) + 판가 없음 → 전: 통과 / 후: 통과 (다른 제외 규칙은 그대로)

  python test_stmt_before_after.py
"""
import sys, io, os, re
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
MARK = "[E20261013-DMF0082ADJYNALL]"


def extract(body):
    i = body.index("INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU1 (SEGMENT2)")
    # 문장 끝 = 세미콜론이 붙은 FETCH FIRST (그 앞의 Fcst Type 명칭 스칼라 서브쿼리에도 FETCH FIRST 가 있다)
    m = re.search(r"SELECT 'End Customer : '.*?FETCH FIRST 1 ROWS ONLY(?=;)", body[i:], re.S)
    return re.sub(r"INTO s_unit_price_valid\s+", "", m.group(0))


def main():
    u, p, d = conn_info()
    cn = oracledb.connect(user=u, password=p, dsn=d)
    cn.call_timeout = 600000
    cur = cn.cursor()
    cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
    now = "".join(r[0] for r in cur)
    bak = open(os.path.join(HERE, "00_BACKUP_PKG_DMF0082_BODY.sql"), encoding="utf-8").read()
    s_before, s_after = extract(bak), extract(now)
    print("추출: 전", len(s_before), "자 (제외조건 실행문", "있음" if re.search(r"^\s+AND NOT EXISTS \(SELECT 1\s*$", s_before, re.M) else "없음", ") / 후", len(s_after),
          "자 (마커", s_after.count(MARK), ")")

    cur.execute("""SELECT division_id, project_code, scm_site_id, item_id FROM SCM_MST_SITE_ITEM
                    WHERE division_id='40' AND valid_yn='Y' AND sales_plan_adjust_yn='N' ORDER BY 2,3,4 FETCH FIRST 1 ROWS ONLY""")
    n_key = cur.fetchone()
    cur.execute("""SELECT division_id, project_code, scm_site_id, item_id FROM SCM_MST_SITE_ITEM S
                    WHERE division_id='40' AND valid_yn='Y' AND sales_plan_adjust_yn IS NULL AND project_code NOT IN ('-','/')
                    ORDER BY 2,3,4 FETCH FIRST 1 ROWS ONLY""")
    g_key = cur.fetchone()
    cur.execute("SELECT TO_CHAR(TRUNC(SYSDATE,'IW')+8,'YYYYMMDD') FROM dual")
    ymd = cur.fetchone()[0]
    cur.execute("SELECT basis_start_date FROM SCM_SYS_CALENDAR_M WHERE basis_yyyymmdd = :y", y=ymd)
    wk = cur.fetchone()[0]
    print("조정 제외(N) 키", n_key, "/ 일반 키", g_key, "/ 입력일", ymd, "주 시작일", wk)

    def setup(key, fcst, with_price):
        for t in ("GT_PRDM1_T_MAIN", "GT_PRDM1_T_PRICE", "GT_PRDM1_MSHYCHU1", "GT_PRDM1_MSHYCHU2"):
            cur.execute(f"DELETE FROM SCM_MGR.{t}")
        cur.execute("""INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN (ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
                           INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY_PRICE, CREATED_BY)
                       VALUES ('I', :d, :p, :p, :s, :i, 'E', :f, 'CPT', 'MKT_FCST', '-', 'HQ06-A', :y, 1, 'test')""",
                    d=key[0], p=key[1], s=key[2], i=key[3], f=fcst, y=ymd)
        if with_price:
            cur.execute("""INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID,
                               YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE)
                           VALUES (:d, :p, :p, :s, '-', 'HQ06-A', :i, :w, 'USD', 'LOC', 'E', :f, 'CPT', 10)""",
                        d=key[0], p=key[1], s=key[2], i=key[3], f=fcst, w=wk)
        # SP 와 같은 룩업 적재 (검증 대상 메저 · 검증 제외 Fcst Type)
        cur.execute("""INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU1 (SEGMENT2) SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' AND SEGMENT1='MEASURE' AND VALID_YN='Y'""")
        cur.execute("""INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU2 (SEGMENT2) SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' AND SEGMENT1='FCST_TYPE' AND VALID_YN='Y'""")

    def blocked(stmt):
        cur.execute(stmt)
        return cur.fetchone() is not None

    cases = [
        ("A 조정 제외(N) + 판가 없음", n_key, "MPS", False, False, True),
        ("B 조정 제외(N) + 판가 있음", n_key, "MPS", True, False, False),
        ("C 일반 + 판가 없음",         g_key, "MPS", False, True, True),
        ("D 일반 + 판가 있음",         g_key, "MPS", True, False, False),
        ("E 조정 제외(N) + 제외 유형 SPF + 판가 없음", n_key, "SPF", False, False, False),
    ]
    ok = True
    for name, key, fcst, price, exp_b, exp_a in cases:
        setup(key, fcst, price)
        b, a = blocked(s_before), blocked(s_after)
        good = (b, a) == (exp_b, exp_a)
        ok &= good
        print(f"   {name:42s} 전 {'차단' if b else '통과'} → 후 {'차단' if a else '통과'}  {'OK' if good else 'FAIL'}")
    cn.rollback()
    print("RESULT", "PASS" if ok else "FAIL")


if __name__ == "__main__":
    main()
