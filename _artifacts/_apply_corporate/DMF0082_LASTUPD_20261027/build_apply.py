"""DMF0082 조회 — Last Updated By · Last Update Date 는 행 키가 아닌 참고값 [E20261027-DMF0082LASTUPD] (사내 ZIOUI1)

사용자 요청(2026-10-27): Column Set 에서 LAST UPDATED BY · LAST UPDATE DATE 를 고르면 이 두 컬럼이 GROUP BY 대상이 되어
  줄이 갈리고 메저 값이 달라진다. 두 컬럼은 참고값이므로, 선택한 컬럼의 키 기준으로 LAST UPDATE DATE 가 가장 큰 행의
  수정자 · 수정일 한 쌍만 보여 주고, 메저 표기는 선택 여부와 무관하게 같아야 한다. 선택하지 않으면 로직 자체가 돌지 않는다.

원인: 최종 피벗은 결과 컬럼 목록(V_COLUMN) 전체로 묶는다. 피벗 원천 임시 테이블은 일자(버킷) 행 단위이고 행마다 수정일·수정자가
  달라서, 두 컬럼이 목록에 들어가면 같은 키가 수정일·수정자 조합 수만큼 여러 줄로 나뉜다.

보완: 두 프로시저의 최종 동적 SQL 직전에, 두 컬럼 중 하나라도 V_COLUMN 에 있을 때만 실행되는 블록 1개씩.
  - 행 키 = 최종 피벗이 묶는 컬럼(V_COLUMN + SORT_ORDER_NO) 에서 LAST_UPDATED_BY · LAST_UPDATE_DATE(· 원천 CREATE_DATE) 제외
  - 키마다 수정일이 가장 큰 행의 수정일 · 수정자로 그 키의 모든 행을 맞춘다 (수정일 동률이면 수정자 MAX)
  - 대상 행 = 최종 피벗에 실제로 들어가는 행 (각 프로시저의 피벗 원천 WHERE 와 같은 조건)
  - 조회용 임시 테이블의 표시값만 변경 — 원장 · 저장 무변경
  대상 2곳: P_DMF0082_GET_MAIN_DATA(GT_DMF0082_MF_SP · CREATE_DATE DATE) · P_DMF0082_GET_MAIN_DATA_CURRENT(GTT_MF_SP · LAST_UPDATE_DATE 'YYYYMMDD').
  기존 문장 무변경(삽입만).

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
MARK = "[E20261027-DMF0082LASTUPD]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"

# GET_MAIN_DATA 앵커 = [E20260918-KEYCOLGRAIN2] MERGE 끝 (그 뒤가 최종 동적 SQL) — 1회
ANCHOR_GET = (
    "        WHEN MATCHED THEN UPDATE SET T.PLANT_SITE_ID = S.REP_PLANT_SITE\n"
    "        WHERE  NVL(T.PLANT_SITE_ID, '~') <> S.REP_PLANT_SITE;\n"
    "    END IF;\n"
)
# GET_MAIN_DATA_CURRENT 앵커 = [E20260825-CURRNORM] UPDATE 끝 (그 뒤가 DEFECT_GUARD → 최종 동적 SQL) — 2회 중 2번째
ANCHOR_CUR = "    AND    (   CURRENCY IS NULL OR TRIM(CURRENCY) IS NULL OR TRIM(CURRENCY) = '/');\n"

HEAD = (
    "\n"
    f"    /* {MARK} Last Updated By · Last Update Date 는 행을 가르는 키가 아니라 참고값 (사용자 요청 2026-10-27).\n"
    "       Column Set 에서 두 컬럼을 고르면 최종 피벗이 이 값까지 묶어, 수정일 · 수정자가 다른 일자 행이 별도 줄로 갈라졌다\n"
    "       (두 컬럼 선택 여부에 따라 줄 수 · 메저 값이 달라짐).\n"
    "       보완: 두 컬럼 중 하나라도 결과 컬럼에 있을 때만, 행 키(최종 피벗이 묶는 컬럼 = V_COLUMN + SORT_ORDER_NO 에서 두 컬럼 제외)마다\n"
    "       수정일이 가장 큰 행의 수정일 · 수정자 한 쌍으로 그 키의 모든 행을 맞춘다 → 줄 수 · 메저 값은 선택하지 않았을 때와 같다.\n"
    "       대상 행 = 최종 피벗에 실제로 들어가는 행(아래 동적 SQL 의 WHERE 와 같은 조건). 수정일이 같은 행이 여럿이면 수정자 MAX.\n"
    "       두 컬럼을 고르지 않으면 실행하지 않는다. 조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 무변경. */\n"
    "    IF INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',LAST_UPDATED_BY,') > 0\n"
    "    OR INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',LAST_UPDATE_DATE,') > 0 THEN\n"
    "        DECLARE\n"
    "            V_LU_SRC  VARCHAR2(4100 CHAR) := REPLACE(V_COLUMN, ' ', '') || ',SORT_ORDER_NO';\n"
    "            V_LU_COL  VARCHAR2(200 CHAR);\n"
    "            V_LU_KEYS VARCHAR2(4100 CHAR);\n"
    "        BEGIN\n"
    "            FOR I IN 1 .. REGEXP_COUNT(V_LU_SRC, '[^,]+') LOOP\n"
    "                V_LU_COL := REGEXP_SUBSTR(V_LU_SRC, '[^,]+', 1, I);\n"
    "                IF V_LU_COL NOT IN ('LAST_UPDATED_BY', 'LAST_UPDATE_DATE', 'CREATE_DATE')\n"
    "                AND INSTR(',' || V_LU_KEYS || ',', ',' || V_LU_COL || ',') = 0 THEN\n"
    "                    V_LU_KEYS := CASE WHEN V_LU_KEYS IS NULL THEN V_LU_COL ELSE V_LU_KEYS || ', ' || V_LU_COL END;\n"
    "                END IF;\n"
    "            END LOOP;\n"
)
TAIL = (
    "        END;\n"
    "    END IF;\n"
)

# GET_MAIN_DATA — 피벗 원천 = [@SRC0] 투영(MSP.* + 별칭 컬럼). 키가 별칭 컬럼(TEAM_ID 등)을 쓸 수 있어 같은 별칭을 만든다.
#   수정일 원천 = CREATE_DATE(DATE, 화면 LAST_UPDATE_DATE 는 이것의 TO_CHAR). WHERE = 동적 SQL 5개 분기 공통 조건.
BODY_GET = (
    "            EXECUTE IMMEDIATE\n"
    "               'MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T\n"
    "                USING ( SELECT RID_\n"
    "                             , MAX(CREATE_DATE) OVER (PARTITION BY ' || V_LU_KEYS || ') AS LU_DATE\n"
    "                             , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE NULLS FIRST) OVER (PARTITION BY ' || V_LU_KEYS || ') AS LU_BY\n"
    "                        FROM ( SELECT MSP.ROWID AS RID_, MSP.*, MSP.DEPT_ID AS TEAM_ID, MSP.DEPT_NAME_KO AS TEAM_NAME_KO, MSP.CELL_MODEL AS FORECAST_INFO_CELL_MODEL\n"
    "                                    , NVL(TO_CHAR(MSP.SUN),''0'')||NVL(TO_CHAR(MSP.MON),''0'')||NVL(TO_CHAR(MSP.TUE),''0'')||NVL(TO_CHAR(MSP.WED),''0'')||NVL(TO_CHAR(MSP.THU),''0'')||NVL(TO_CHAR(MSP.FRI),''0'')||NVL(TO_CHAR(MSP.SAT),''0'') AS BUCKET\n"
    "                               FROM SCM_MGR.GT_DMF0082_MF_SP MSP ) F\n"
    "                        WHERE ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP'')) ) S\n"
    "                ON (T.ROWID = S.RID_)\n"
    "                WHEN MATCHED THEN UPDATE SET T.CREATE_DATE = S.LU_DATE, T.LAST_UPDATED_BY = S.LU_BY\n"
    "                WHERE DECODE(T.CREATE_DATE, S.LU_DATE, 0, 1) = 1 OR DECODE(T.LAST_UPDATED_BY, S.LU_BY, 0, 1) = 1';\n"
)

# GET_MAIN_DATA_CURRENT — 피벗 원천 = GTT_MF_SP 직접. 수정일 = LAST_UPDATE_DATE('YYYYMMDD', 빈값 ' ').
#   WHERE = 동적 SQL 분기 합집합 (수량 0 제외 조건 OR 단가 KRW·USD·LOC 평균 분기는 조건 없음).
BODY_CUR = (
    "            EXECUTE IMMEDIATE\n"
    "               'MERGE INTO SCM_MGR.GTT_MF_SP T\n"
    "                USING ( SELECT F.ROWID AS RID_\n"
    "                             , MAX(LAST_UPDATE_DATE) KEEP (DENSE_RANK LAST ORDER BY TRIM(LAST_UPDATE_DATE) NULLS FIRST) OVER (PARTITION BY ' || V_LU_KEYS || ') AS LU_DATE\n"
    "                             , MAX(LAST_UPDATED_BY)  KEEP (DENSE_RANK LAST ORDER BY TRIM(LAST_UPDATE_DATE) NULLS FIRST) OVER (PARTITION BY ' || V_LU_KEYS || ') AS LU_BY\n"
    "                        FROM SCM_MGR.GTT_MF_SP F\n"
    "                        WHERE (   (F.MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND F.QTY <> 0)\n"
    "                               OR F.MEASURE IN (''SCM_FCST'',''FCST_GAP'')\n"
    "                               OR F.MEASURE IN (''KRW'',''USD'',''LOC'') ) ) S\n"
    "                ON (T.ROWID = S.RID_)\n"
    "                WHEN MATCHED THEN UPDATE SET T.LAST_UPDATE_DATE = S.LU_DATE, T.LAST_UPDATED_BY = S.LU_BY\n"
    "                WHERE DECODE(T.LAST_UPDATE_DATE, S.LU_DATE, 0, 1) = 1 OR DECODE(T.LAST_UPDATED_BY, S.LU_BY, 0, 1) = 1';\n"
)


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
    get_s = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA\n") if "\nPROCEDURE P_DMF0082_GET_MAIN_DATA\n" in body else 0
    get_e = body.index("\nPROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO")
    cur_s = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT")
    cur_e = body.index("\nPROCEDURE P_DMF0082_GET_SPREAD_TITLE")
    if body.count(ANCHOR_GET) != 1:
        sys.exit(f"ABORT: GET 앵커 일치 {body.count(ANCHOR_GET)}회 (1회여야 함)")
    if body.count(ANCHOR_CUR) != 2:
        sys.exit(f"ABORT: CURRENT 앵커 일치 {body.count(ANCHOR_CUR)}회 (2회여야 함)")
    pg = body.index(ANCHOR_GET)
    pc1 = body.index(ANCHOR_CUR)
    pc = body.index(ANCHOR_CUR, pc1 + 1)
    if not (get_s <= pg < get_e and get_s <= pc1 < get_e and cur_s < pc < cur_e):
        sys.exit("ABORT: 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 범위와 다름")
    # 앵커 직후가 최종 동적 SQL 로 이어지는지 (사이에 V_COLUMN/GTT 를 바꾸는 문장이 없는지)
    if "[FIX 2026-07-22] 최종 동적 SQL" not in body[pg:pg + 600]:
        sys.exit("ABORT: GET 앵커 뒤가 최종 동적 SQL 이 아님")
    if "[DEFECT_GUARD] PIVOT IN 리스트 비어있음 방어" not in body[pc:pc + 600]:
        sys.exit("ABORT: CURRENT 앵커 뒤가 DEFECT_GUARD 가 아님")
    eg = pg + len(ANCHOR_GET)
    ec = pc + len(ANCHOR_CUR)
    return (body[:eg] + HEAD + BODY_GET + TAIL
            + body[eg:ec] + HEAD + BODY_CUR + TAIL
            + body[ec:])


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


def apply(which=F_NEW):
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
        tobe = strip(open(os.path.join(HERE, which), encoding="utf-8").read())
        cur.execute(tobe)
        after = read_source(cur)
        print("APPLIED", which, "DB==TOBE", after["src"].rstrip() == tobe[len("CREATE OR REPLACE "):].rstrip(),
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
