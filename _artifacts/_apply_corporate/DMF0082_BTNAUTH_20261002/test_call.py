"""[E20261002-BTNAUTH] 검증 — P_DMF0082_GET_BUTTON_AUTH (읽기 전용: 세션 GTT 만 쓰고 끝에 ROLLBACK)

  python test_call.py parity          # DB 배포본에서 신규 SP 의 권한 블록 == GET_MAIN_DATA 의 권한 블록 (원문 동일)
  python test_call.py matrix          # 그룹별 대표 사용자 × division 호출 결과표
  python test_call.py main <DIV> <USER>   # 같은 인자로 GET_MAIN_DATA 를 실제 호출해 O_RC4 와 O_RC2 행 단위 비교
"""
import sys, os, datetime
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B
import oracledb

DIVS = ["40", "81", "81_UC", "82", ""]
GROUPS = ["ADMIN", "DM ADMIN", "DM Planner", "DM Planner (W/S)", "SCP Planner", "DM Viewer"]


def call_auth(cur, div, user, group):
    rc1, rc2, rs = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
    cur.callproc(f"SCM_MGR.{B.PKG}.{B.SP}", [div, user, group, rc1, rc2, rs])
    c1 = rc1.getvalue()
    cols = [d[0] for d in c1.description]
    btn = dict(zip(cols, c1.fetchone()))
    meas = rc2.getvalue().fetchall()
    res = rs.getvalue().fetchall()
    return btn, meas, res


def parity():
    with B.connect() as con:
        cur = con.cursor()
        body = B.read_source(cur, "PACKAGE BODY")
        main_block = B.auth_block(body["src"], "P_DMF0082_GET_MAIN_DATA")
        new_block = B.auth_block(body["src"], B.SP)
        print("BODY LAST_DDL", body["last_ddl"], "| MAIN 블록", main_block.count("\n"), "줄 | 신규 SP 블록", new_block.count("\n"), "줄")
        print("원문 동일:", main_block == new_block)


def pick_users(cur):
    """그룹별 대표 사용자 — 그 그룹 '하나만' 가진 사용자 우선 (겸직이면 합집합 판정이라 그룹 효과가 섞인다)."""
    out = {}
    for g in GROUPS:
        cur.execute("""
            SELECT M.USER_ID, (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M X WHERE X.USER_ID = M.USER_ID AND X.USE_YN = 'Y') N
              FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M M
             WHERE M.USER_GR_ID = :g AND M.USE_YN = 'Y'
             ORDER BY 2, 1 FETCH FIRST 1 ROWS ONLY""", g=g)
        r = cur.fetchone()
        if r:
            out[g] = r
    return out


def matrix():
    with B.connect() as con:
        cur = con.cursor()
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI DY','NLS_DATE_LANGUAGE=ENGLISH') FROM dual")
        print("DB 시각", cur.fetchone()[0], "(요일·시간창 룩업이 결과에 반영된다)")
        users = pick_users(cur)
        print("대표 사용자(그룹 수):", {g: f"{u}({n})" for g, (u, n) in users.items()})
        hdr = ["INSERT_YN", "DELETE_YN", "SAVE_YN", "PRICE_BATCH_YN", "EXCEL_FORM_YN", "EXCEL_UPLOAD_YN", "EDIT_AUTH_YN"]
        print(f"{'GROUP':18} {'DIV':6} " + " ".join(h.replace('_YN', '')[:7].ljust(7) for h in hdr) + " | 메저별 EDIT_AUTH_YN")
        for g, (u, _) in users.items():
            for d in DIVS:
                btn, meas, res = call_auth(cur, d, u, u)
                assert res[0][0] == '0', res
                print(f"{g:18} {d or '(빈값)':6} " + " ".join(str(btn[h]).ljust(7) for h in hdr)
                      + " | " + " ".join(f"{m[0]}={m[1]}" for m in meas))
        con.rollback()


def main_compare(div, user):
    with B.connect() as con:
        cur = con.cursor()
        today = datetime.date.today()
        frm = today.replace(day=1).strftime("%Y%m%d")
        to = (today.replace(day=28) + datetime.timedelta(days=4)).replace(day=28).strftime("%Y%m%d")
        outs = [cur.var(oracledb.CURSOR) for _ in range(6)]
        t0 = datetime.datetime.now()
        cur.callproc(f"SCM_MGR.{B.PKG}.P_DMF0082_GET_MAIN_DATA",
                     [div, "ALL", "ALL", "ALL", frm, to, "ALL", "", "Current", "N", user, user, "ALL", "ALL", "ALL", "ALL"] + outs)
        main_rc4 = outs[3].getvalue().fetchall()
        print("GET_MAIN_DATA", div, user, (datetime.datetime.now() - t0).total_seconds(), "s / O_RC4", len(main_rc4), "행")
        btn, meas, _ = call_auth(cur, div, user, user)
        print("BUTTON_AUTH   O_RC2", len(meas), "행 / 행 단위 동일:", sorted(map(tuple, main_rc4)) == sorted(map(tuple, meas)))
        if sorted(map(tuple, main_rc4)) != sorted(map(tuple, meas)):
            print("  MAIN", main_rc4)
            print("  AUTH", meas)
        print("  버튼", btn)
        con.rollback()


if __name__ == "__main__":
    a = sys.argv[1]
    if a == "parity":
        parity()
    elif a == "matrix":
        matrix()
    else:
        main_compare(sys.argv[2], sys.argv[3])
