"""GAP 476 E2E — 사업부 권한 삭제 시 그 아래 하위 권한도 지워지는지 (사내 ZIOUI1, 저장 SP 직접 호출).

원장에 없는 시험 키만 사용: USER_ID = 'ZZ_GAP476_T1', 그룹 'DM Planner'.
  1) 생성: UserInfo I · D 81 · D 82 · P ZZP81(UPPR 81) · P ZZP82(UPPR 82)  ← 저장 SP
  2) Division D (D 81) 삭제
     기대(보완 후): D 81 · P ZZP81 삭제 / D 82 · P ZZP82 유지
  대조군: 시험 키 외 UNIT_AUTH 행수 불변. 마지막에 시험 키 잔여 전부 삭제.
사용: python e2e_gap476.py <label>
"""
import json, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

U, G, SES = "ZZ_GAP476_T1", "DM Planner", "minyonglee1"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
print("DB", d, cur.fetchone(), "label", sys.argv[1])


def units():
    return [f"{r[0]}:{r[1]}<{r[2]}" for r in cur.execute(
        "SELECT UNIT_TP_CD, UNIT_ID, UPPR_UNIT_ID FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE USER_ID=:u ORDER BY 1, 2", u=U)]


def others():
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE USER_ID<>:u", u=U)
    return cur.fetchone()[0]


def save(rows):
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("PKG_SYS0014.P_SYS0014_SAVE_GROUP_USER_M", [SES, json.dumps(rows), rc])
    return rc.getvalue().fetchall()


def cleanup():
    cur.execute("DELETE FROM SCM_MGR.SCM_MST_AUTH_REQUEST WHERE USER_ID=:u", u=U)
    cur.execute("DELETE FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE USER_ID=:u", u=U)
    cur.execute("DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID=:u", u=U)
    con.commit()


cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID=:u", u=U)
assert cur.fetchone()[0] == 0 and units() == [], "시험 키가 이미 존재 — 중단"
base = others()
print("others before", base)
try:
    row = lambda crud, tp, unit, uppr: {"SHT_NM": "Division", "CRUD_TYPE": crud, "USER_GR_ID": G, "USER_ID": U,
                                        "UNIT_TP_CD": tp, "UNIT_ID": unit, "UPPR_UNIT_ID": uppr, "EDIT_YN": "Y", "USE_YN": "Y"}
    usr = {"SHT_NM": "UserInfo", "CRUD_TYPE": "I", "USER_GR_ID": G, "USER_ID": U, "USE_YN": "Y"}
    print("1 create ", save([usr, row("I", "D", "81", ""), row("I", "D", "82", ""),
                             row("I", "P", "ZZP81", "81"), row("I", "P", "ZZP82", "82")]), units())
    print("2 D 81 del", save([row("D", "D", "81", "")]), s2 := units())
    after = others()
    print("others after", after, "UNCHANGED" if after == base else "CHANGED!")
    ok = [x.split("<")[0] for x in s2] == ["D:82", "P:ZZP82"] and after == base
    print("RESULT", "PASS (하위 권한 함께 삭제, 다른 사업부 유지)" if ok else "FAIL (하위 권한 잔존 또는 과삭제)")
finally:
    cleanup()
    print("cleanup", units(), "others", others())
