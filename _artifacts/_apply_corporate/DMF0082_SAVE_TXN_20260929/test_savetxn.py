"""[E20260929-DMF0082SAVETXN] 검증
  big     : 32,767B 초과 페이로드(40 행 N개 + 마지막 1행 81) → 파싱 완주 후 V81-00 '복수 Division' 검증(F)으로 종료.
            영구 DML 이전 종료라 데이터 무변경. 적용 전 = 바인드 단계 ORA-06502 기대 / 적용 후 = RESULT_CODE 'F' 기대.
  replay  : 실저장 1건 재저장 (40 / LOC 판가 / 현재값 그대로 = 멱등) → RESULT_CODE '0' 기대. 전후 값 출력.
usage: python test_savetxn.py big [N] | replay
"""
import pathlib, sys, time

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

KEYS = ["p_active_flag", "p_division_id", "p_project_code", "p_end_customer", "p_scm_site_id", "p_item_id", "p_dom_exp",
        "p_fcst_type", "p_incoterms", "p_measure", "p_plant_site_id", "p_cell_prod_site_id", "p_yyyymmdd", "p_currency",
        "p_qty", "p_created_by", "p_as_from_site"]
ROW = {"p_active_flag": "M", "p_division_id": "40", "p_project_code": "NT", "p_end_customer": "NT",
       "p_scm_site_id": "Sunwoda_CN_SZX", "p_item_id": "MIF489266C11", "p_dom_exp": "E", "p_fcst_type": "MPS",
       "p_incoterms": "DDP", "p_measure": "LOC", "p_plant_site_id": "-", "p_cell_prod_site_id": "NJ01-A",
       "p_yyyymmdd": "20270215", "p_currency": "USD", "p_qty": "9.12", "p_created_by": "minyonglee1", "p_as_from_site": ""}
PRICE_SQL = ("SELECT MEASURE, CURRENCY, PRICE, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'MM-DD HH24:MI:SS') "
             "FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE WHERE DIVISION_ID='40' AND PROJECT_CODE='NT' AND END_CUSTOMER='NT' "
             "AND SCM_SITE_ID='Sunwoda_CN_SZX' AND ITEM_ID='MIF489266C11' AND YYYYMMDD='20270215' ORDER BY MEASURE")


def call(cur, rows, clob=True):
    vals = {k: "^".join(r[k] for r in rows) for k in KEYS}
    if clob:
        cur.setinputsizes(**{k: oracledb.DB_TYPE_CLOB for k in KEYS})
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    t = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA", keyword_parameters={**vals, "O_RESULT_CURSOR": rc})
    el = time.time() - t
    c = rc.getvalue()
    cols = [x[0] for x in c.description]
    return el, max(len(v.encode()) for v in vals.values()), [dict(zip(cols, r)) for r in c.fetchall()]


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL"); assert cur.fetchone()[0].upper() == "ZIOUI1"
    cur.execute("SELECT DATA_TYPE FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0082' "
                "AND OBJECT_NAME='P_DMF0082_SAVE_MAIN_DATA' AND ARGUMENT_NAME='P_ACTIVE_FLAG'")
    is_clob = cur.fetchone()[0] == "CLOB"
    print("SP P_ACTIVE_FLAG =", "CLOB" if is_clob else "VARCHAR2")
    if mode == "big":
        n = int(sys.argv[2]) if len(sys.argv) > 2 else 3000
        rows = [dict(ROW, p_yyyymmdd=f"2027{(i % 12) + 1:02d}{(i % 28) + 1:02d}") for i in range(n)] + [dict(ROW, p_division_id="81")]
        try:
            el, mx, res = call(cur, rows, clob=is_clob)
            print(f"rows={len(rows)} maxParamBytes={mx} elapsed={el:.1f}s result={res}")
        except oracledb.Error as e:
            print(f"rows={len(rows)} FAIL: {str(e).splitlines()[0]}")
    elif mode == "replay":
        cur.execute(PRICE_SQL); print("BEFORE"); [print("  ", r) for r in cur.fetchall()]
        el, mx, res = call(cur, [ROW], clob=is_clob)
        print(f"elapsed={el:.1f}s result={res}")
        cur.execute(PRICE_SQL); print("AFTER"); [print("  ", r) for r in cur.fetchall()]
    con.close()


if __name__ == "__main__":
    main()
