"""[E20261013-DMF0082AFSSHARE] 삽입 MERGE 문장의 동작 확인 — 조회용 임시 테이블에 모의 행을 넣고 실행 (원장 무접촉 · 끝에 ROLLBACK)

  python test_mock.py

실행하는 문장 = build_apply.merge_sql() 이 만든 문장 그대로 (BODY 에 들어가는 것과 같은 텍스트).
임시 테이블(GT_DMF0082_MF_SP · GTT_MF_SP)은 세션 전용이라 다른 사용자 조회에 영향이 없다.
"""
import sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
import build_apply as B

BASE = dict(DIVISION_ID="81", PROJECT_CODE="P1", END_CUSTOMER="P1", SCM_SITE_ID="S1", ITEM_ID="I1", DOM_EXP="E",
            FCST_TYPE="WS", INCOTERMS="FCA", PLANT_SITE_ID="/", CELL_PROD_SITE_ID="/")
# (설명, 품목, 키 덮어쓰기, [(메저, 버킷, 적용 전 값, 기대 값)])
CASES = [
    ("값 1개 → 빈칸 · '-' · '/' 행에 채움, 자기 값이 있는 행은 그대로", "K1", {}, [
        ("MKT_FCST", "W1", "X", "X"), ("MKT_FCST", "W2", "X", "X"), ("LOC", "W1", " ", "X"), ("KRW", "W1", " ", "X"),
        ("RTF_SYS_RP", "W1", "-", "X"), ("SCM_FCST", "W1", "/", "X"), ("VMI_In_Req", "W1", "Y", "Y")]),
    ("MKT_FCST 값이 2개 → 채우지 않음", "K2", {}, [
        ("MKT_FCST", "W1", "A", "A"), ("MKT_FCST", "W2", "B", "B"), ("LOC", "W1", " ", " ")]),
    ("MKT_FCST 값 없음 → 그대로", "K3", {}, [
        ("MKT_FCST", "W1", " ", " "), ("LOC", "W1", " ", " "), ("RTF_SYS_RP", "W1", "-", "-")]),
    ("MKT_FCST 일부 주차만 값 → 다른 메저는 채움, MKT_FCST 빈 주차는 그대로", "K4", {}, [
        ("MKT_FCST", "W1", "X", "X"), ("MKT_FCST", "W2", " ", " "), ("LOC", "W1", " ", "X"), ("LOC", "W2", " ", "X")]),
    ("Plant Site 가 다른 키 → 서로 섞이지 않음 (K1 과 같은 품목)", "K1", {"PLANT_SITE_ID": "PL2"}, [
        ("MKT_FCST", "W1", "Z", "Z"), ("LOC", "W1", " ", "Z")]),
    ("키 컬럼이 NULL 인 행끼리도 같은 키로 맞춤", "K6", {"CELL_PROD_SITE_ID": None, "DOM_EXP": None}, [
        ("MKT_FCST", "W1", "N", "N"), ("LOC", "W1", " ", "N")]),
    ("MKT_FCST 행이 없는 키 → 그대로", "K7", {}, [("LOC", "W1", " ", " "), ("RTF_SYS_RP", "W1", "Q", "Q")]),
]


def main():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
    print("DB", d, cur.fetchone()[0])
    fail = 0
    for gtt in B.GTT:
        cur.execute(f"DELETE FROM SCM_MGR.{gtt}")
        exp = {}
        for ci, (_, item, over, rows) in enumerate(CASES):
            k = dict(BASE, ITEM_ID=item, **over)
            for meas, bkt, before, after in rows:
                r = dict(k, MEASURE=meas, YYYYMMWW=bkt, AS_FROM_SITE=before, NICK_NAME=f"C{ci}")   # NICK_NAME = 케이스 번호 표시용
                cols = list(r)
                cur.execute(f"INSERT INTO SCM_MGR.{gtt} ({', '.join(cols)}) VALUES ({', '.join(':' + c for c in cols)})", r)
                exp[(ci, meas, bkt)] = after
        cur.execute(B.merge_sql(gtt).rstrip().rstrip(";"))
        merged = cur.rowcount
        cur.execute(f"SELECT NICK_NAME, MEASURE, YYYYMMWW, AS_FROM_SITE FROM SCM_MGR.{gtt}")
        got = {(int(n[1:]), m, b): v for n, m, b, v in cur}
        con.rollback()
        print(f"--- {gtt}: 모의 {len(exp)}행 · MERGE 갱신 {merged}행")
        for ci, (desc, *_ ) in enumerate(CASES):
            bad = [(k, exp[k], got.get(k)) for k in exp if k[0] == ci and exp[k] != got.get(k)]
            fail += bool(bad)
            print("PASS" if not bad else "FAIL", "|", desc, "" if not bad else bad)
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
