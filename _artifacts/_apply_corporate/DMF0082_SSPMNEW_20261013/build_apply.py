"""DMF0082 저장 — 신규 행은 Sales Site Project Model(SSPM) 4키 등록 필수 [E20261013-DMF0082SSPMNEW] (사내 ZIOUI1)

사용자 요청(2026-10-13): "DMF0082 의 신규 ROW 추가, 저장 시 SSPM 기준의 VALIDATION 수행" · 대상 = 신규 행만(사용자 확정).

현행: P_DMF0082_SAVE_MAIN_DATA 검증 #5·#17 은 SCM_MST_SITE_ITEM 을 Division+Sales Site+Model 3키로만 본다(Project 미검사).
  AS-IS DMF0082_SAVE_MAIN_DATA(LGCE_SCMDEV 2026-06-12본, DB 직접 조회 10-13) L871~891 · L1433~1458 도 같은 3키.
  ⇒ 다른 Project 로만 등록된 Sales Site-Model 조합도 신규 입력·저장된다.
보완: #5 바로 뒤에 5-1 신설 — 신규 행(GT_PRDM1_T_MAIN.ACTION='I')은 마스터 PK 4키
  (Division·Project·Sales Site·Model) 가 VALID_YN='Y' 로 등록돼 있어야 한다. 없으면 검증 실패(INVALID).
  기존 행 수정('M')·삭제('D')는 종전대로 #5 만 적용 = AS-IS 대비 신규 행 한정 의도적 강화.
  기존 문장은 한 글자도 바꾸지 않는다(블록 1개 삽입).

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
MARK = "[E20261013-DMF0082SSPMNEW]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"

SEP = "    --" + "=" * 122 + "\n"
ANCHOR = SEP + "    -- 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)\n" + SEP

BLOCK = (
    "\n" + SEP +
    f"    -- 5-1. 신규 행(ACTION='I') : Sales Site Project Model(SSPM) 4키 등록 여부 확인 (START)   --{MARK}\n"
    "    --   사용자 요청(2026-10-13): 신규 ROW 추가·저장 시 SSPM 기준으로 검증. 대상 = 신규 행만(사용자 확정).\n"
    "    --   위 #5 는 AS-IS 와 같이 Division+Sales Site+Model 3키만 본다(Project 미검사) — 그래서 다른 Project 로만\n"
    "    --   등록된 Sales Site-Model 조합도 신규 입력됐다. 신규 행은 마스터(SCM_MST_SITE_ITEM) PK 4키\n"
    "    --   (Division·Project·Sales Site·Model)가 유효(VALID_YN='Y')하게 등록돼 있어야 한다.\n"
    "    --   기존 행 수정('M')·삭제('D')는 종전대로 #5 만 적용 — AS-IS 대비 신규 행 한정 의도적 강화.\n"
    + SEP +
    "    DECLARE\n"
    "        v_sspm_new VARCHAR2(1000 CHAR);\n"
    "    BEGIN\n"
    "        BEGIN\n"
    "            SELECT 'Project : '               || A.PROJECT_CODE\n"
    "                || CHR(10) || 'Sales Site : ' || A.SCM_SITE_ID\n"
    "                || CHR(10) || 'Model : '      || A.ITEM_ID\n"
    "            INTO   v_sspm_new\n"
    "            FROM   SCM_MGR.GT_PRDM1_T_MAIN A\n"
    "            WHERE  A.ACTION = 'I'\n"
    "              AND  NOT EXISTS (SELECT 1\n"
    "                               FROM   SCM_MGR.SCM_MST_SITE_ITEM Z\n"
    "                               WHERE  Z.DIVISION_ID  = A.DIVISION_ID\n"
    "                                 AND  Z.SCM_SITE_ID  = A.SCM_SITE_ID\n"
    "                                 AND  Z.ITEM_ID      = A.ITEM_ID\n"
    "                                 AND  Z.VALID_YN     = 'Y'\n"
    "                                 -- Project 빈값 표기는 같은 값으로 본다: 마스터는 '-'(기존)·'/'(신규 기본값), 스테이징 기본값은 '-'.\n"
    "                                 --   표기만 다른 것을 미등록으로 막지 않기 위함 (실값끼리는 등호 그대로).\n"
    "                                 AND  (   Z.PROJECT_CODE = A.PROJECT_CODE\n"
    "                                       OR (    NVL(TRIM(Z.PROJECT_CODE), '/') IN ('-', '/')\n"
    "                                           AND NVL(TRIM(A.PROJECT_CODE), '/') IN ('-', '/'))))\n"
    "            ORDER  BY A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID\n"
    "            FETCH  FIRST 1 ROWS ONLY;\n"
    "        EXCEPTION WHEN NO_DATA_FOUND THEN v_sspm_new := NULL;\n"
    "        END;\n"
    "\n"
    "        IF v_sspm_new IS NOT NULL THEN\n"
    "            V_LOG_TYPE    := 'INVALID';\n"
    "            V_DESCRIPTION := v_sspm_new || CHR(10) || CHR(10)\n"
    "                          || 'Sales Site Project Model 에 등록되지 않은 조합입니다.' || CHR(10)\n"
    "                          || 'Sales Site Project Model 에 등록 후 입력하시기 바랍니다.';\n"
    "            RAISE e_validation_error;\n"
    "        END IF;\n"
    "    END;\n"
    + SEP +
    "    -- 5-1. 신규 행(ACTION='I') : Sales Site Project Model(SSPM) 4키 등록 여부 확인 (END)\n"
    + SEP
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
    n = body.count(ANCHOR)
    if n != 1:
        sys.exit(f"ABORT: #5 종료 앵커 일치 {n}회 (1회여야 함) — 원문이 바뀌었음")
    return body.replace(ANCHOR, ANCHOR + BLOCK)


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)   # 기준본 = 지금 ALL_SOURCE 에서 새로 조회한 원문
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM dual")
        fetched = cur.fetchone()[0]
    new = transform(s["src"])
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
    open(os.path.join(HERE, F_BAK), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(s["src"]) + "/\n")
    open(os.path.join(HERE, F_NEW), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched}, open(STATE, "w"), indent=1)
    print("BUILD OK", fetched, "LAST_DDL", s["last_ddl"], "lines", s["src"].count("\n"), "->", new.count("\n"),
          "(+", new.count("\n") - s["src"].count("\n"), ") marker", new.count(MARK))


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 시점 기준본 (다르면 중단·재빌드)
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS")
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
