"""DMF0082 조회 — 조회조건 Project / Owner / Team 완화 선행축소 [E20261014-DMF0082RLXPRE] (사내 ZIOUI1)

사용자 승인(2026-10-14): "A. 사내에 적용해주세요." (GTT DELETE 비용 분석 → 방안 A)

현상 (클라우드 QA G01/G02 실측 2026-10-14):
  스테이징 arm 22개는 GT_DMF0082_TEMP_SITE_ITEM 과 (DIV, PROJECT, SITE, ITEM) INNER JOIN 으로 적재하는데,
  Project / Owner / Team 필터는 적재가 끝난 뒤 TEMP_FCST_N_PRICE 에서 DELETE 로만 걸린다(L3692 · L3699 · L3724).
  81 Project 지정 시 판가 INSERT 2.1s 로 18만 행 적재 → L3692 DELETE 1.4s 로 21만 행 삭제.
  45일 실사용: 81 Project 단독 중앙값 10s vs Project+SalesSite 2s (SalesSite 는 L1003 에서 이미 선행필터).

보완: TEMP_SITE_ITEM 적재 직후(#TempSiteItem 만들기 종료) 블록 1개 추가.
  선택 조건을 만족하는 행이 하나라도 있는 (DIV, SCM_SITE_ID, ITEM_ID) 는 프로젝트가 달라도 전부 남기고, 나머지만 지운다.
  - 정확 필터(프로젝트 단위)로 줄이면 안 된다: CURRENCY 3차 MERGE(L3328, 키 DIV+SITE+ITEM+DOM_EXP+FCST_TYPE)가
    다른 프로젝트의 LOC 통화를 참조한다(주석: 수요 Varta / 단가 VARTA(Vacuum)). → SITE+ITEM 단위로 완화 (#129 §11.2).
  - L3692 이전 문장 중 행을 넘나드는 계산의 최대 범위 = (DIV, SITE, ITEM) → 그룹 단위로 남기면 생존 행의 값이 같다.
  - 판정식 = 기존 필터 DELETE 의 생존 조건 그대로: `NVL(x,' ') NOT IN (토큰)` 이 참이 아닌 행 ⇔ 토큰 일치 OR 토큰에 NULL.
    게이트도 기존과 같다(`p_x IS NOT NULL AND p_x <> 'ALL'`). OWNER·DEPT_ID 는 arm 이 C.OWNER·C.DEPT_ID 를 그대로 투영.
  - 기존 L3692 / L3699 / L3724 DELETE 는 그대로 둔다 → 최종 결과 동일, 적재·삭제량만 감소.
  - 상관 NOT EXISTS 대신 집합 NOT IN (GTT 1행 추정 시 자기조인 NL 회피). NULL 키는 NOT IN 이 UNKNOWN → 남김(안전 방향).

  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성
  python build_apply.py apply   # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0082"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261014-DMF0082RLXPRE]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"

ANCHOR = ("    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;\n"
          "    -- #TempSiteItem 만들기 종료\n")

BLOCK = f"""
    /* {MARK} 조회조건 Project / Owner / Team 완화 선행축소 (사용자 승인 2026-10-14 "A. 사내에 적용")
       필터는 아래 L3692(Project) · L3699(Owner) · L3724(Team) 에서 적재 뒤 DELETE 로만 걸려, 81 Project 지정 시
       판가 18만 행을 적재했다가 91% 를 지웠다(클라우드 QA INSERT 2.1s + DELETE 1.4s).
       선택 조건을 만족하는 행이 하나라도 있는 (DIV, SCM_SITE_ID, ITEM_ID) 는 프로젝트가 달라도 전부 남기고 나머지만 지운다.
       - 프로젝트 단위로 줄이지 않는 이유: CURRENCY 3차 MERGE(키 DIV+SITE+ITEM+DOM_EXP+FCST_TYPE)가 다른 프로젝트의
         LOC 통화를 참조한다. 필터 전 계산의 최대 범위가 (DIV, SITE, ITEM) 이므로 그 단위로 남기면 생존 행 값이 같다.
       - 판정식 = 기존 필터 DELETE 의 생존 조건 그대로(NVL(x,' ') NOT IN 토큰 이 참이 아닌 행 = 토큰 일치 OR 토큰에 NULL).
         OWNER·DEPT_ID 는 적재 arm 이 C.OWNER·C.DEPT_ID 를 그대로 투영하므로 이 GTT 값으로 판정한다.
       - 아래 기존 필터 DELETE 는 그대로 둔다 → 최종 결과 동일, 적재·삭제량만 줄어든다. */
    IF (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
       OR (p_owner IS NOT NULL AND p_owner <> 'ALL')
       OR (p_team_id IS NOT NULL AND p_team_id <> 'ALL') THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        WHERE  (C.DIVISION_ID, C.SCM_SITE_ID, C.ITEM_ID) NOT IN (
                   SELECT K.DIVISION_ID, K.SCM_SITE_ID, K.ITEM_ID
                   FROM   SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM K
                   WHERE  K.DIVISION_ID IS NOT NULL
                   AND    K.SCM_SITE_ID IS NOT NULL
                   AND    K.ITEM_ID     IS NOT NULL
                   AND    (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                           OR EXISTS (SELECT 1
                                      FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                                      WHERE  T.PARAM_NM = 'p_project_code'
                                      AND    (T.TOKEN = NVL(K.PROJECT_CODE, ' ') OR T.TOKEN IS NULL)))
                   AND    (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                           OR EXISTS (SELECT 1
                                      FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                                      WHERE  T.PARAM_NM = 'p_owner'
                                      AND    (T.TOKEN = NVL(K.OWNER, ' ') OR T.TOKEN IS NULL)))
                   AND    (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                           OR EXISTS (SELECT 1
                                      FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                                      WHERE  T.PARAM_NM = 'p_team_id'
                                      AND    (T.TOKEN = NVL(K.DEPT_ID, ' ') OR T.TOKEN IS NULL))));
    END IF;
"""


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=TYP)
    ddl = cur.fetchone()[0]
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def transform(body):
    if MARK in body:
        sys.exit(f"ABORT: BODY 에 {MARK} 이미 존재 — 재적용 불필요")
    if "\r" in body:
        sys.exit("ABORT: BODY 원문에 CR 포함")
    p_main = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA\n")
    p_cur = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT")
    if body.count(ANCHOR) != 1:
        sys.exit(f"ABORT: 앵커 일치 {body.count(ANCHOR)}건(기대 1) — 원문이 바뀌었음")
    pos = body.index(ANCHOR)
    if not (p_main < pos < p_cur):
        sys.exit("ABORT: 앵커가 P_DMF0082_GET_MAIN_DATA 구간 밖")
    # 삽입 위치 단언: 앞쪽 = TEMP_SITE_ITEM 적재, 뒤쪽 첫 소비처 = T_LAST_DATA_SETUP 적재(TEMP_SITE_ITEM 조인) 이전
    nxt = body.index("GT_DMF0082_TEMP_SITE_ITEM C", pos)
    if body.index("INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST", pos) > nxt:
        sys.exit("ABORT: 삽입 지점과 첫 소비처 사이 구조가 예상과 다름")
    # 필터 DELETE 3종이 그대로 남아 있어야 한다
    for f in ("WHERE  NVL(PROJECT_CODE, ' ') NOT IN (", "WHERE  NVL(OWNER, ' ') NOT IN (", "WHERE  NVL(DEPT_ID, ' ') NOT IN ("):
        if body[p_main:p_cur].count(f) != 1:
            sys.exit(f"ABORT: 기존 필터 DELETE 앵커 불일치: {f}")
    return body.replace(ANCHOR, ANCHOR + BLOCK, 1)


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)   # 기준본 = 지금 ALL_SOURCE 에서 새로 조회한 원문
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI'), SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        fetched, host = cur.fetchone()
    new = transform(s["src"])
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
    open(os.path.join(HERE, F_BAK), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(s["src"]) + "/\n")
    open(os.path.join(HERE, F_NEW), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched, "host": host}, open(STATE, "w"), indent=1)
    print("BUILD OK", fetched, "HOST", host, "LAST_DDL", s["last_ddl"], "lines", s["src"].count("\n"), "->", new.count("\n"),
          "(+", new.count("\n") - s["src"].count("\n"), ") marker", new.count(MARK))


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        host = cur.fetchone()[0]
        if host != st["host"]:
            sys.exit(f"ABORT: 접속 DB 가 build 시점과 다름 (build {st['host']} → now {host})")
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 시점 기준본 (다르면 중단·재빌드)
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS", "HOST", host)
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        inv_before = cur.fetchone()[0]
        tobe = strip(open(os.path.join(HERE, F_NEW), encoding="utf-8").read())
        cur.execute(tobe)
        after = read_source(cur)
        print("APPLIED", F_NEW, "DB==TOBE", after["src"].rstrip() == tobe[len("CREATE OR REPLACE "):].rstrip(),
              "marker", after["src"].count(MARK))
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n ORDER BY 1", n=PKG)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY sequence", n=PKG)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        print("SCM_MGR INVALID objects", inv_before, "->", cur.fetchone()[0])


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
