"""[E20261013-DMF0082DEFFLAGN] C_TITLE 컬럼 목록 전후 비교 (읽기 전용 — 메타 값 전환은 미커밋 후 ROLLBACK)

조회 SP 의 동적 SQL 은 C_TITLE 커서가 돌려준 컬럼 목록(순서 포함)으로만 달라진다.
따라서 "종전 문장 × 빈값 표기('/')" 의 컬럼 목록과 "보완 문장 × 'N'" 의 컬럼 목록이 같으면 조회 결과도 같다.

비교 4조합 (사용자별 · 프로시저 2종별):
  A = 종전 문장 × DEFAULT_FLAG '/'   ← 기준 (오류 나기 전 상태)
  B = 보완 문장 × DEFAULT_FLAG '/'
  C = 보완 문장 × DEFAULT_FLAG 'N'
  D = 종전 문장 × DEFAULT_FLAG 'N'   ← 오류 재현 (SORT_KEY 빠짐)
  기대: A == B == C, D 는 SORT_KEY 없음.
"""
import sys, os, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
SYS_COLS = ['GROUP_ID', 'VERSION_NO', 'MEASURE_GROUP', 'BUCKET', 'EDIT_FLAG',
            'SORT_KEY', 'NEW_FLAG', 'ATTR1', 'VMI_STD_DIO', 'AS_YN']


def body(fname):
    t = open(os.path.join(HERE, fname), encoding="utf-8").read()
    return t


def cursors(src):
    """C_TITLE 커서 SELECT 문 2개(GET_MAIN_DATA · GET_MAIN_DATA_CURRENT)를 원문에서 그대로 잘라 바인드로 바꾼다."""
    out = []
    for m in re.finditer(r"CURSOR C_TITLE IS\n(.*?ORDER BY TO_NUMBER\(SORT_ORDER_NO\));", src, re.S):
        q = m.group(1)
        q = q.replace("VA_PROGRAM_ID", "'DMF0082'").replace("VA_SHEET_NAME", "'FcstNPrice'")
        q = re.sub(r"\bp_created_by\b", ":u", q)
        out.append(q)
    assert len(out) == 2, f"C_TITLE 커서 {len(out)}개 (2개여야 함)"
    return out


def cols(cur, q, user):
    cur.execute(q, {"u": user})
    return [r[2] for r in cur.fetchall()]


def set_flag(cur, v):
    cur.execute("UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET DEFAULT_FLAG = :v "
                "WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND COLUMN_NAME IN ("
                + ",".join(f"'{c}'" for c in SYS_COLS) + ")", v=v)
    assert cur.rowcount == 10, f"시스템 컬럼 {cur.rowcount}행 (10행이어야 함)"


def main():
    old_q = cursors(body("00_BACKUP_PKG_DMF0082_BODY.sql"))
    new_q = cursors(body("01_PKG_DMF0082_BODY.sql"))
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone())
    cur.execute("SELECT DEFAULT_FLAG, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' "
                "AND COLUMN_NAME IN (" + ",".join(f"'{c}'" for c in SYS_COLS) + ") GROUP BY DEFAULT_FLAG")
    print("현재 시스템 컬럼 DEFAULT_FLAG 분포(커밋 상태):", cur.fetchall())
    cur.execute("SELECT DISTINCT USER_ID FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' "
                "AND USER_INQUIRY_COLUMN_TYPE_CODE='C' ORDER BY 1")
    users = [r[0] for r in cur.fetchall()] + ["__NO_SUCH_USER__"]
    print("대상 사용자", len(users), "명 (Column Set 저장 사용자 전원 + 저장 내역 없는 사용자 1)")
    fail = 0
    try:
        # 잠금 대기 없이 실패하도록 먼저 NOWAIT 로 잡는다 (다른 세션이 수정 중이면 즉시 중단)
        cur.execute("SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' "
                    "AND COLUMN_NAME IN (" + ",".join(f"'{c}'" for c in SYS_COLS) + ") FOR UPDATE NOWAIT")
        res = {}
        for flag in ("/", "N", "Y", "-", " "):
            set_flag(cur, flag)   # 미커밋 — 이 세션에서만 보인다
            for pi in (0, 1):
                for usr in users:
                    res[(flag, "old", pi, usr)] = cols(cur, old_q[pi], usr)
                    res[(flag, "new", pi, usr)] = cols(cur, new_q[pi], usr)
        pname = ["GET_MAIN_DATA", "GET_MAIN_DATA_CURRENT"]
        for pi in (0, 1):
            nA = nB = nC = nD = nY = nS = 0
            for usr in users:
                A = res[("/", "old", pi, usr)]
                B = res[("/", "new", pi, usr)]
                C = res[("N", "new", pi, usr)]
                D = res[("N", "old", pi, usr)]
                Y = res[("Y", "new", pi, usr)]
                S1, S2 = res[("-", "new", pi, usr)], res[(" ", "new", pi, usr)]
                assert "SORT_KEY" in A, "기준 A 에 SORT_KEY 없음"
                nA += 1
                nB += (A == B); nC += (A == C); nY += (A == Y); nS += (A == S1 and A == S2)
                nD += ("SORT_KEY" not in D)
                if not (A == B == C == Y == S1 == S2):
                    fail += 1
                    print("  DIFF", pname[pi], usr, "A", len(A), "B", len(B), "C", len(C), "Y", len(Y),
                          "A-C", sorted(set(A) - set(C)), "C-A", sorted(set(C) - set(A)))
            print(f"{pname[pi]}: 사용자 {nA} | 보완×'/' == 기준 {nB} | 보완×'N' == 기준 {nC} | 보완×'Y' == 기준 {nY} "
                  f"| 보완×'-'·' ' == 기준 {nS} | 종전×'N' SORT_KEY 빠짐(오류 재현) {nD}")
        smp = "minyonglee1" if "minyonglee1" in users else users[0]
        print("예시", smp, "GET_MAIN_DATA 기준 컬럼", len(res[("/", "old", 0, smp)]), "개 /",
              "종전×'N'", len(res[("N", "old", 0, smp)]), "개 / 빠진 컬럼",
              sorted(set(res[("/", "old", 0, smp)]) - set(res[("N", "old", 0, smp)])))
    finally:
        con.rollback()   # 메타 값 전환은 어떤 경우에도 되돌린다
    cur.execute("SELECT DEFAULT_FLAG, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' "
                "AND COLUMN_NAME IN (" + ",".join(f"'{c}'" for c in SYS_COLS) + ") GROUP BY DEFAULT_FLAG")
    print("ROLLBACK 후 분포(변경 없음 확인):", cur.fetchall())
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
