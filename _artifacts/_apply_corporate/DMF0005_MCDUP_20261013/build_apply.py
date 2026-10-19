"""DMF0005 Model Code Change 팝업 저장 — 키 중복 사전 검증 추가 [E20261013-DMF0005MCDUP] (사내 ZIOUI1)

사용자 요청(2026-10-13): "검증 메세지 추가 해주세요."
  클라우드 QA 10-13 13:17 · 13:21 저장이 ORA-00001 (PK_SCM_MST_SITE_ITEM) 로 실패하고 화면에는 SQL ERROR 만 보였다.
  변경 전 Model 과 같은 키(Division·Project·Site)에 변경 후 Model 이 이미 등록돼 있으면 ITEM_ID 를 바꾸는 순간 키가 겹친다.
  AS-IS(LGCE_SCMDEV dbo.DMF0005_SAVE_MODEL_CHANGE_POPUP, 2023-08-23)도 사전 검사 없이 갱신 → 중복이면 전체 ROLLBACK 후
  '[2627]Violation of PRIMARY KEY…' 원문 반환. 저장 불가 결과는 같고, 이번 변경은 안내 문구만 더한다(의도적 추가).

보완: P_DMF0005_SAVE_MODEL_CHANGE_POPUP 에 내부 프로시저 CHECK_DUP 신설 + CHANGE_TABLE 에서 갱신 직전 호출 1줄.
  - 대상 = 그 테이블의 유일 인덱스 중 ITEM_ID 를 포함한 것 전부 (딕셔너리에서 읽는다 — 사내·클라우드 키 구성이 달라도 동작)
  - 판정 = 갱신이 끝난 뒤의 키가 겹치는가 (같은 배치의 다른 변경쌍까지 반영)
  - 겹치면 검증 메시지(CODE -1)로 차단 → 기존 INVALID 경로(전체 ROLLBACK + 로그)
  기존 문장 무변경. 추가만.

  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성
  python build_apply.py apply   # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0005"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261013-DMF0005MCDUP]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0005_BODY.sql", "01_PKG_DMF0005_BODY.sql"

# ── 앵커 1: 변경 이력 줄 (그 뒤에 1줄 추가)
A_HIST = " * 2026.10.01   Claude(Code)   [DMF0005] AS-IS DMF0005_SAVE_MODEL_CHANGE_POPUP 변환 신규\n"
N_HIST = A_HIST + f" * 2026.10.13   Claude(Code)   {MARK} 키 중복 사전 검증 추가 (ORA-00001 대신 검증 메시지)\n"

# ── 앵커 2: CHANGE_TABLE 설명 주석 첫 줄 (그 앞에 CHECK_DUP 삽입)
A_PROC = "    -- 테이블 1개 갱신\n"
N_PROC = f"""    --{MARK} 키 중복 사전 검증 (START)
    --   ITEM_ID 를 포함한 유일 인덱스가 있는 테이블은, 변경 전 Model 행의 ITEM_ID 를 바꾸면 키가 겹칠 수 있다
    --   (같은 키에 변경 후 Model 이 이미 등록된 경우). 종전에는 ORA-00001 로 실패해 화면에 SQL ERROR 만 보였다.
    --   AS-IS 도 사전 검사 없이 실패(전체 ROLLBACK)하므로 저장 불가 결과는 같다 — 안내 문구만 더한다.
    --   ① 유일 인덱스·키 컬럼은 딕셔너리에서 읽는다 (환경마다 키 구성이 달라도 동작)
    --   ② 판정 = 갱신 뒤 키가 겹치는가. 상대 행이 같은 배치에서 다른 코드로 옮겨가면 겹치지 않고,
    --      서로 다른 변경 전 Model 두 개가 같은 변경 후 Model 로 모여도 겹친다.
    PROCEDURE CHECK_DUP(P_TABLE IN VARCHAR2, P_DIV40 IN BOOLEAN) IS
        V_PAIRS   SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();   -- BEFORE(12) || AFTER(12)
        V_XF      VARCHAR2(100) := CASE WHEN P_DIV40 THEN ' AND X.DIVISION_ID = ''40''' END;
        V_YF      VARCHAR2(100) := CASE WHEN P_DIV40 THEN ' AND Y.DIVISION_ID = ''40''' END;
        V_JOIN    VARCHAR2(8000);
        V_KEYTXT  VARCHAR2(8000);
        V_B       VARCHAR2(200);
        V_A       VARCHAR2(200);
        V_KEY     VARCHAR2(4000);
        V_FOUND   BOOLEAN;
    BEGIN
        FOR I IN 1 .. V_BEF_LIST.COUNT LOOP
            V_PAIRS.EXTEND;
            V_PAIRS(I) := V_BEF_LIST(I) || V_MAP(V_BEF_LIST(I));
        END LOOP;
        FOR IX IN ( SELECT I.INDEX_NAME
                      FROM USER_INDEXES I
                     WHERE I.TABLE_NAME = P_TABLE
                       AND I.UNIQUENESS = 'UNIQUE'
                       AND EXISTS ( SELECT 1 FROM USER_IND_COLUMNS C
                                     WHERE C.INDEX_NAME = I.INDEX_NAME AND C.COLUMN_NAME = 'ITEM_ID' )
                       AND NOT EXISTS ( SELECT 1 FROM USER_IND_COLUMNS C
                                         WHERE C.INDEX_NAME = I.INDEX_NAME
                                           AND NOT EXISTS ( SELECT 1 FROM USER_TAB_COLUMNS T
                                                             WHERE T.TABLE_NAME = P_TABLE AND T.COLUMN_NAME = C.COLUMN_NAME ) )
                     ORDER BY I.INDEX_NAME ) LOOP
            V_JOIN   := NULL;
            V_KEYTXT := NULL;
            FOR C IN ( SELECT IC.COLUMN_NAME, TC.DATA_TYPE, TC.NULLABLE
                         FROM USER_IND_COLUMNS IC
                         JOIN USER_TAB_COLUMNS TC ON TC.TABLE_NAME = P_TABLE AND TC.COLUMN_NAME = IC.COLUMN_NAME
                        WHERE IC.INDEX_NAME  = IX.INDEX_NAME
                          AND IC.COLUMN_NAME <> 'ITEM_ID'
                        ORDER BY IC.COLUMN_POSITION ) LOOP
                -- NOT NULL 컬럼은 등호(인덱스 사용), NULL 허용 컬럼은 NULL 끼리도 같은 값으로 본다(유일 인덱스 규칙)
                V_JOIN := V_JOIN || CASE WHEN C.NULLABLE = 'N'
                                         THEN ' AND Y.' || C.COLUMN_NAME || ' = X.' || C.COLUMN_NAME
                                         ELSE ' AND DECODE(Y.' || C.COLUMN_NAME || ', X.' || C.COLUMN_NAME || ', 1, 0) = 1' END;
                -- 날짜는 형식을 명시해 문자로 바꾼다 (세션 날짜 형식에 기대지 않는다)
                V_KEYTXT := V_KEYTXT || CASE WHEN V_KEYTXT IS NOT NULL THEN ' || '', '' || ' END
                         || '''' || C.COLUMN_NAME || '='' || '
                         || CASE WHEN C.DATA_TYPE = 'DATE' OR C.DATA_TYPE LIKE 'TIMESTAMP%'
                                 THEN 'TO_CHAR(X.' || C.COLUMN_NAME || ', ''YYYY-MM-DD HH24:MI:SS'')'
                                 ELSE 'TO_CHAR(X.' || C.COLUMN_NAME || ')' END;
            END LOOP;
            BEGIN
                EXECUTE IMMEDIATE
                       'SELECT B, A, K FROM ('
                    || ' SELECT SUBSTR(L.COLUMN_VALUE, 1, 12) AS B, SUBSTR(L.COLUMN_VALUE, 13, 12) AS A'
                    || '      , SUBSTR(' || NVL(V_KEYTXT, '''-''') || ', 1, 500) AS K'
                    || '   FROM TABLE(:L1) L JOIN ' || P_TABLE || ' X ON X.ITEM_ID = SUBSTR(L.COLUMN_VALUE, 1, 12)'
                    || '  WHERE 1 = 1' || V_XF
                    || '    AND EXISTS ( SELECT 1 FROM ' || P_TABLE || ' Y'
                    || '                  WHERE Y.ROWID <> X.ROWID' || V_JOIN
                    || '                    AND ( ( Y.ITEM_ID = SUBSTR(L.COLUMN_VALUE, 13, 12)'
                    || '                            AND NOT ( Y.ITEM_ID IN (SELECT SUBSTR(L2.COLUMN_VALUE, 1, 12) FROM TABLE(:L2) L2)' || V_YF || ' ) )'
                    || '                       OR ( Y.ITEM_ID IN (SELECT SUBSTR(L3.COLUMN_VALUE, 1, 12) FROM TABLE(:L3) L3'
                    || '                                           WHERE SUBSTR(L3.COLUMN_VALUE, 13, 12) = SUBSTR(L.COLUMN_VALUE, 13, 12))' || V_YF || ' ) ) )'
                    || ' ) WHERE ROWNUM = 1'
                    INTO V_B, V_A, V_KEY
                    USING V_PAIRS, V_PAIRS, V_PAIRS;
                V_FOUND := TRUE;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_FOUND := FALSE;
            END;
            IF V_FOUND THEN
                RAISE_INVALID('변경 후 Model 코드가 같은 키로 이미 등록되어 있어 변경할 수 없습니다.' || CHR(10)
                           || 'MODEL : ' || V_B || ' -> ' || V_A || CHR(10)
                           || 'TABLE : ' || P_TABLE || CHR(10)
                           || 'KEY : ' || V_KEY);
            END IF;
        END LOOP;
    END CHECK_DUP;
    --{MARK} 키 중복 사전 검증 (END)
""" + A_PROC

# ── 앵커 3: CHANGE_TABLE 의 대상 0건 반환 (그 뒤에 호출 1줄 추가)
A_CALL = ("        IF V_RIDS.COUNT = 0 THEN\n"
          "            RETURN;\n"
          "        END IF;\n")
N_CALL = A_CALL + f"        CHECK_DUP(P_TABLE, P_DIV40);   --{MARK} 갱신 직전 키 중복 검증 — 겹치면 검증 메시지로 차단(전체 ROLLBACK)\n"


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
    for name, old, new in (("변경 이력", A_HIST, N_HIST), ("CHANGE_TABLE 주석", A_PROC, N_PROC), ("대상 0건 반환", A_CALL, N_CALL)):
        n = body.count(old)
        if n != 1:
            sys.exit(f"ABORT: 앵커 '{name}' 일치 {n}회 (1회여야 함) — 원문이 바뀌었음")
        body = body.replace(old, new)
    return body


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
