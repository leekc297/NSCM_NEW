"""[E20261007-DATEVAR] PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING — 술어 안 FN_NEXT_DAY(SYSDATE) 날짜 경계를 변수로 (배치 속도개선 방법 2)

배경(클라우드 AWR 10-05 실측): L384 INSERT DM_PLN_MKT_FCST_C(sql_id dfrascwsp66jy) 가 40 사업부 45만 행을
  IDX_DM_PLN_MKT_FCST_N1 범위탐색 + ROWID 단일블록 읽기로 처리(65초). 술어 YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,…) 의
  함수 때문에 선택도 추정이 2,618행(실제 423,068)으로 빗나가고, 81/82 로 파싱된 인덱스 계획을 40 이 공유한다.
  리터럴 날짜로 EXPLAIN 하면 추정 362K·풀스캔. 변수(바인드)로 바꾸면 피킹된 실제 값으로 계획을 세운다. 결과 행은 동일.
방식: 지금 DB 원문(ALL_SOURCE) 위의 외과적 치환 (고유 매칭 assert) — hook sp-body-minimal-change
  ① 선언 2줄 추가 (V_FROM_1W / V_FROM_54W)      ② 시작부 대입 2줄 추가
  ③ TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7*54, 'YYYYMMDD') → V_FROM_54W  (2곳)
  ④ TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7,    'YYYYMMDD') → V_FROM_1W   (9곳)
  주석 블록(MSSQL 원문 dbo.FN_NEXT_DAY(GETDATE()…)은 패턴이 달라 영향 없음.
  python build_apply.py build   # 01 생성만
  python build_apply.py apply   # FRESH-GATE 후 사내 적용 + 검증
"""
import sys, os, re, hashlib, json, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
NAME, TYP = "PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING", "PROCEDURE"
MARK = "[E20261007-DATEVAR]"
BASE_MD5 = "e5f7388498f8846a9b09cfa8c37f8cf1"   # 사내 10-06 15:38:38 원문 (_fresh_state.json)
OLD_54 = "TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7*54, 'YYYYMMDD')"
OLD_1 = "TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')"
NEW_54 = "V_FROM_54W /* " + MARK + " */"
NEW_1 = "V_FROM_1W /* " + MARK + " */"
DECL_ANCHOR = "    V_DUMMY_CUR          SYS_REFCURSOR;\n"
DECL_ADD = DECL_ANCHOR + """
    /* """ + MARK + """ 날짜 경계를 시작 때 1회 계산해 바인드로 쓴다 — 술어 안 FN_NEXT_DAY(SYSDATE) 는 옵티마이저가 선택도를 못 보아
       (추정 2,618행 vs 실제 423,068행, 클라우드 AWR 2026-10-05) 인덱스 ROWID 경로를 고르고, 81/82 로 파싱된 계획을 40 이 공유했다. 결과 행 동일 */
    V_FROM_1W            VARCHAR2(8 CHAR);   /* 당주 월요일 = FN_NEXT_DAY(SYSDATE,'MON') - 7 */
    V_FROM_54W           VARCHAR2(8 CHAR);   /* 54주 전 월요일 (최근 1년치) */
"""
ASSIGN_ANCHOR = "    V_DELIMITER       := '^';\n"
ASSIGN_ADD = ASSIGN_ANCHOR + """    V_FROM_1W         := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7,    'YYYYMMDD');  /* """ + MARK + """ */
    V_FROM_54W        := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7*54, 'YYYYMMDD');  /* """ + MARK + """ */
"""


def connect():
    u, p, d = conn_info(); return oracledb.connect(user=u, password=p, dsn=d)


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
    ddl, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=NAME, t=TYP)
    body = "".join(t for (t,) in cur)
    return ddl, st, body, hashlib.md5(body.encode("utf-8")).hexdigest()


def patch(body):
    assert MARK not in body, "이미 적용됨"
    assert body.count(DECL_ANCHOR) == 1 and body.count(ASSIGN_ANCHOR) == 1, "앵커 고유 매칭 실패"
    n54, n1 = body.count(OLD_54), body.count(OLD_1)
    assert (n54, n1) == (2, 9), f"치환 대상 수 불일치 54w={n54} 1w={n1} (기대 2/9)"
    out = body.replace(OLD_54, NEW_54).replace(OLD_1, NEW_1)          # 술어 치환 먼저 (대입문 자체는 그 뒤에 넣어야 치환에 안 걸림)
    assert out.count(OLD_1) == 0 and out.count(OLD_54) == 0
    out = out.replace(DECL_ANCHOR, DECL_ADD, 1).replace(ASSIGN_ANCHOR, ASSIGN_ADD, 1)
    assert out.count(MARK) == 1 + 2 + 2 + 9, out.count(MARK)
    assert out.count(OLD_1.replace("- 7,", "- 7,   ")) == 1 and out.count(OLD_54) == 1, "대입문 2줄 확인"
    return out


def build(body):
    new = patch(body)
    sql = "CREATE OR REPLACE " + new + ("\n" if not new.endswith("\n") else "") + "/\n"
    open(os.path.join(HERE, "01_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING.sql"), "w", encoding="utf-8").write(sql)
    return new


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "build"
    con = connect(); cur = con.cursor()
    ddl, st, body, md5 = fetch(cur)
    print("FRESH", ddl, st, "md5", md5, "lines", body.count("\n"))
    if md5 != BASE_MD5:
        print("⚠ 원문이 기준(BASE_MD5)과 다름 — 다른 작업자가 손댔을 수 있음. 치환 assert 로 계속 진행하되 diff 확인 필요")
    new = build(body)
    print("build OK: 줄수", body.count("\n"), "→", new.count("\n"), "(+%d)" % (new.count("\n") - body.count("\n")))
    if cmd != "apply": return
    sql = open(os.path.join(HERE, "01_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING.sql"), encoding="utf-8").read()
    stmt = sql[: sql.rstrip().rfind("/")].rstrip()
    cur.execute(stmt)
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
    st2, ddl2 = cur.fetchone()
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=NAME, t=TYP)
    errs = cur.fetchall()
    ddl3, st3, body3, md53 = fetch(cur)
    print("APPLIED", st2, ddl2, "errors", len(errs), "markers", body3.count(MARK), "md5", md53)
    for e in errs: print("  ERR", e)
    assert st2 == "VALID" and not errs and body3 == new, "적용 후 원문 불일치 또는 INVALID"
    json.dump(dict(applied=str(datetime.datetime.now()), last_ddl=ddl2, md5_before=md5, md5_after=md53, markers=body3.count(MARK)),
              open(os.path.join(HERE, "_apply_result.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)


if __name__ == "__main__":
    main()
