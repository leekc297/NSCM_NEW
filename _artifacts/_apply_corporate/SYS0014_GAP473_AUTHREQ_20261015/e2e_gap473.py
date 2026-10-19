"""GAP 473 E2E — 저장 SP 를 FE 와 같은 페이로드로 직접 호출해 AUTH_REQUEST 잔존 여부를 판정 (사내 ZIOUI1).

원장에 없는 시험 키만 사용: USER_ID = 'ZZ_GAP473_T1' (SSO·매핑·권한·요청 어디에도 없음 확인 후 진행).
  1) 시험 매핑 생성: UserInfo I + Division I 2건(81, 82)  ← 저장 SP (내부 COMMIT)
  2) 시험 권한 요청 2건 INSERT (DIVISION 81, 82 / PLANT '-')  ← AS-IS 요청 원장 형태
  3) Division D (81)  → 기대(보완 후): 요청 81 삭제, 82 유지
  4) UserInfo D       → 기대(보완 후): 요청 82 삭제, 매핑·권한 0
  대조군: 시험 키 외 AUTH_REQUEST / USER_GR_MPG / UNIT_AUTH 행수 불변
  마지막에 시험 키 잔여 전부 삭제(원상 복구).
사용: python e2e_gap473.py <label>
"""
import json, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

U = "ZZ_GAP473_T1"
SES = "minyonglee1"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
print("DB", d, cur.fetchone(), "label", sys.argv[1])
cur.execute("SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_M WHERE USER_GR_ID='DM Planner'")
G = (cur.fetchone() or [None])[0]
assert G, "시험 그룹 없음"


def one(sql, **b):
    cur.execute(sql, b)
    return cur.fetchone()[0]


def mine():
    return {
        "req": [r[0] for r in cur.execute("SELECT DIVISION_ID FROM SCM_MGR.SCM_MST_AUTH_REQUEST WHERE USER_ID=:u ORDER BY 1", u=U)],
        "map": one("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID=:u", u=U),
        "unit": [r[0] for r in cur.execute("SELECT UNIT_ID FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE USER_ID=:u ORDER BY 1", u=U)],
    }


def others():
    return (one("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_AUTH_REQUEST WHERE USER_ID<>:u", u=U),
            one("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID<>:u", u=U),
            one("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE USER_ID<>:u", u=U))


def save(rows):
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("PKG_SYS0014.P_SYS0014_SAVE_GROUP_USER_M", [SES, json.dumps(rows), rc])
    return rc.getvalue().fetchall()


def cleanup():
    cur.execute("DELETE FROM SCM_MGR.SCM_MST_AUTH_REQUEST WHERE USER_ID=:u", u=U)
    cur.execute("DELETE FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE USER_ID=:u", u=U)
    cur.execute("DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID=:u", u=U)
    con.commit()


# 사전: 시험 키는 원장에 없어야 한다
pre = mine()
assert pre == {"req": [], "map": 0, "unit": []}, f"시험 키가 이미 존재 — 중단 {pre}"
base_others = others()
print("others before", base_others)

try:
    div = lambda crud, unit: {"SHT_NM": "Division", "CRUD_TYPE": crud, "USER_GR_ID": G, "USER_ID": U,
                              "UNIT_TP_CD": "D", "UNIT_ID": unit, "UPPR_UNIT_ID": "", "EDIT_YN": "Y", "USE_YN": "Y"}
    usr = lambda crud: {"SHT_NM": "UserInfo", "CRUD_TYPE": crud, "USER_GR_ID": G, "USER_ID": U, "USE_YN": "Y"}

    print("1 create   ", save([usr("I"), div("I", "81"), div("I", "82")]), mine())
    for dv in ("81", "82"):
        cur.execute("INSERT INTO SCM_MGR.SCM_MST_AUTH_REQUEST (USER_ID, GROUP_ID, DIVISION_ID, PLANT_ID, CREATED_BY, CREATION_DATE) "
                    "VALUES (:u, :g, :d, '-', :s, SYSDATE)", u=U, g=G, d=dv, s=SES)
    con.commit()
    print("2 requests ", mine())
    print("3 div D 81 ", save([div("D", "81")]), s3 := mine())
    print("4 user D   ", save([usr("D")]), s4 := mine())
    after_others = others()
    print("others after", after_others, "UNCHANGED" if after_others == base_others else "CHANGED!")
    ok = (s3["req"] == ["82"] and s3["unit"] == ["82"] and s4 == {"req": [], "map": 0, "unit": []}
          and after_others == base_others)
    print("RESULT", "PASS (요청 기록 함께 삭제)" if ok else "FAIL (요청 기록 잔존 또는 대조군 변동)")
finally:
    cleanup()
    print("cleanup", mine(), "others", others())
