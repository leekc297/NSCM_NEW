"""[E20261013-DMF0082DEFFLAGN] 조회 SP 실호출 확인 (읽기 전용 — 메타 값은 건드리지 않는다)

현재 커밋된 메타 상태 그대로(시스템 컬럼 DEFAULT_FLAG 분포를 먼저 출력) 조회 SP 2종을 호출해
결과 커서 6개를 끝까지 읽는다. 오류 없이 읽히고 첫 커서에 SORT_KEY 가 있으면 통과.
"""
import sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

CASES = [
    # (설명, 프로시저, 인자 16개) — 첫 줄은 10-13 11:48:34 실패 호출(LOG_SEQ 2087801) 그대로
    ("40 acer 실패 호출 그대로", "P_DMF0082_GET_MAIN_DATA",
     ['40', 'ALL', 'acer', 'ALL', '20261001', '20270331', 'acer_CN_CKG', '', 'Current', 'N', 'minyonglee1', 'ADMIN', 'ALL', 'ALL', 'ALL', 'ALL']),
    ("40 acer 품목 지정(11:48:22 실패 호출)", "P_DMF0082_GET_MAIN_DATA",
     ['40', 'ALL', 'acer', 'ALL', '20261001', '20270331', 'acer_CN_CKG', 'MPPACERX481C', 'Current', 'N', 'minyonglee1', 'ADMIN', 'ALL', 'ALL', 'ALL', 'ALL']),
    ("40 acer CURRENT 프로시저", "P_DMF0082_GET_MAIN_DATA_CURRENT",
     ['40', 'ALL', 'acer', 'ALL', '20261001', '20270331', 'acer_CN_CKG', '', 'Current', 'N', 'minyonglee1', 'ADMIN', 'ALL', 'ALL', 'ALL', 'ALL']),
    ("40 acer k0101", "P_DMF0082_GET_MAIN_DATA",
     ['40', 'ALL', 'acer', 'ALL', '20261001', '20270331', 'acer_CN_CKG', '', 'Current', 'N', 'k0101', 'ADMIN', 'ALL', 'ALL', 'ALL', 'ALL']),
]


def main():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone())
    cur.execute("SELECT DEFAULT_FLAG, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' "
                "AND COLUMN_NAME IN ('GROUP_ID','VERSION_NO','MEASURE_GROUP','BUCKET','EDIT_FLAG','SORT_KEY','NEW_FLAG','ATTR1','VMI_STD_DIO','AS_YN') "
                "GROUP BY DEFAULT_FLAG")
    print("시스템 컬럼 DEFAULT_FLAG 분포(커밋 상태):", cur.fetchall())
    extra = sys.argv[1:]
    cases = list(CASES)
    for div in extra:   # 추가 division: python test_call.py 81 82
        cases.append((f"{div} 전체", "P_DMF0082_GET_MAIN_DATA",
                      [div, 'ALL', 'ALL', 'ALL', '20261001', '20261231', 'ALL', '', 'Current', 'N', 'minyonglee1', 'ADMIN', 'ALL', 'ALL', 'ALL', 'ALL']))
    fail = 0
    for desc, proc, args in cases:
        outs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
        try:
            cur.callproc("SCM_MGR.PKG_DMF0082." + proc, args + outs)
            info = []
            sort_key = None
            for i, o in enumerate(outs):
                c = o.getvalue()
                if c is None:
                    info.append(f"rc{i+1}=없음")
                    continue
                rows = c.fetchall()
                names = [x[0] for x in c.description]
                if i == 0:
                    sort_key = "SORT_KEY" in names
                    info.append(f"rc1={len(rows)}행/{len(names)}컬럼")
                elif i == 5:
                    info.append(f"result={rows[:1]}")
                else:
                    info.append(f"rc{i+1}={len(rows)}행")
            ok = bool(sort_key)
            fail += (not ok)
            print("PASS" if ok else "FAIL", "|", desc, "|", proc, "|", " ".join(info), "| SORT_KEY", sort_key)
        except Exception as e:
            fail += 1
            print("FAIL |", desc, "|", proc, "|", str(e).replace("\n", " / ")[:300])
        con.rollback()
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
