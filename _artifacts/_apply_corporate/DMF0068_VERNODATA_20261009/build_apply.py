"""[E20261009-VERNODATA] PKG_DMF0068.P_DMF0068_GET_ORDERLIST — 버전 미존재 시 ORA-01403(no data found) → NULL (AS-IS `SELECT TOP 1` 동일)

증상(클라우드 2026-10-09, 사내 재현 동일): DMF0068 조회 시
  ORA-20001: [PKG_DMF0068.P_DMF0068_GET_ORDERLIST] SQLCODE=100 / SQLERRM=ORA-01403: no data found / BACKTRACE=... line 429
  PARAMS={"P_DIVISION_ID":"40","P_VERSION_NO":"R_S_20260902_V005",...}
원인: L429 `SELECT ORI_CUTOFF_VERSION_NO INTO V_ORI_VERSION_NO FROM (... DM_MDF_VERSION WHERE DIVISION_ID=... AND VERSION_NO=... FETCH FIRST 1 ROWS ONLY)`
  — DM_MDF_VERSION 에 그 버전이 없으면 Oracle SELECT INTO 는 NO_DATA_FOUND 를 던진다.
  AS-IS(MSSQL LGCE_SCMDEV, sys.sql_modules 2026-10-09 14:17 조회) L69:
      SET @V_ORI_VERSION_NO = (SELECT TOP 1 ORI_CUTOFF_VERSION_NO FROM DM_MDF_VERSION ... )   → 행이 없으면 NULL, 오류 없음.
  FE(useDemandManagerStore.restoreSearchConditions) 도 "없는 버전이면 SP 가 0건을 돌려줄 뿐" 을 전제로 F6 저장조건의 versionNo 를 그대로 복원한다.
방식: 지금 DB 원문(ALL_SOURCE) 위의 외과적 치환 (고유 매칭 assert) — hook sp-body-minimal-change / #152 db-source-refresh-before-work
  ① L429~437 SELECT INTO 를 BEGIN … EXCEPTION WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL; END; 로 감싼다 (SELECT 9줄은 무변경)
  ② 사유 주석 2줄 + 헤더 History 1줄
  = +7줄 (1476 → 1483). 조회 결과: 있는 버전 = 동일 / 없는 버전 = 오류 대신 PLAN 구간 0건(AS-IS 동일)
사용:
  python build_apply.py build   # 01 생성만 (적용 없음)
  python build_apply.py apply   # 기준 캡처 → 클라우드 05(백업) 사내 리허설 → FRESH-GATE → 적용 → 검증 → 클라우드 00/13/90 리허설
                                #   → 98(롤백) 리허설 → 원문 복원 확인 → 10 재적용 → 재검증 → 클라우드 패키지 파일 생성
"""
import sys, os, re, json, hashlib, datetime, difflib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CLOUD = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0068_VERNODATA_CLOUD_20261009\A_DB"
NAME, TYP = "PKG_DMF0068", "PACKAGE BODY"
MARK = "[E20261009-VERNODATA]"
BAK_TABLE = "BAK_SRC_DMF0068_VERNODATA"
BASE_MD5 = "61c8ea8fa713158eb0b5e12650241ce3"   # 사내 2026-10-08 16:02 원문 (1476줄, SUM(LENGTH)=68313) — 착수 시 조회값
MISSING_VER = "R_S_20260902_V005"                 # 클라우드 오류 파라미터 (사내에도 없음)
TEST_VERS = [MISSING_VER, "R_S_20260903_V001_C", "R_B_20260814_V001", "R_S_00000000_V000"]
CALL_ARGS = ["40", None, "202501", "202712", "minyonglee1", "DMF0068"]

OLD_SELECT = (
    "    SELECT ORI_CUTOFF_VERSION_NO\n"
    "    INTO V_ORI_VERSION_NO\n"
    "    FROM (\n"
    "        SELECT ORI_CUTOFF_VERSION_NO\n"
    "        FROM SCM_MGR.DM_MDF_VERSION\n"
    "        WHERE DIVISION_ID = P_DIVISION_ID\n"
    "          AND VERSION_NO  = P_VERSION_NO\n"
    "        FETCH FIRST 1 ROWS ONLY\n"
    "    );\n"
)
NEW_SELECT = (
    "    /* " + MARK + " AS-IS `SET @V_ORI_VERSION_NO = (SELECT TOP 1 ...)` 는 버전이 없으면 NULL 로 넘어갔으나 Oracle SELECT INTO 는 ORA-01403 → 화면 SQL ERROR.\n"
    "       F6 저장조건 복원 등으로 DM_MDF_VERSION 에 없는 버전이 오면 NULL 로 두어 계획(PLAN) 구간만 0건 (AS-IS 동일 결과) */\n"
    "    BEGIN\n"
    + OLD_SELECT +
    "    EXCEPTION\n"
    "        WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL;   /* " + MARK + " */\n"
    "    END;\n"
)
HIST_ANCHOR_TEXT = "소형수주 로직 전체수정 요청으로 로직 전체수정진행"
HIST_ADD = " * 2026-10-09   ZIONEX      " + MARK + " 버전 미존재 시 ORA-01403 → NULL (AS-IS SELECT TOP 1 동일, 클라우드 SQL ERROR 보완)\n"


def connect():
    u, p, d = conn_info(); return oracledb.connect(user=u, password=p, dsn=d)


def fetch(cur):
    """DB 원문 새로 조회 (ALL_SOURCE + ALL_OBJECTS) — 유일한 기준본"""
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
    ddl, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=NAME, t=TYP)
    body = "".join(t for (t,) in cur)
    return ddl, st, body, hashlib.md5(body.encode("utf-8")).hexdigest()


def errors(cur):
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=NAME, t=TYP)
    return cur.fetchall()


def invalid_dependents(cur):
    cur.execute("""SELECT o.OBJECT_NAME, o.OBJECT_TYPE FROM ALL_OBJECTS o WHERE o.OWNER='SCM_MGR' AND o.STATUS='INVALID'
                   AND o.OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES WHERE REFERENCED_OWNER='SCM_MGR' AND REFERENCED_NAME=:n)""", n=NAME)
    return cur.fetchall()


def patch(body):
    assert MARK not in body, "이미 적용됨"
    assert body.startswith("PACKAGE BODY"), body[:40]
    assert body.count(OLD_SELECT) == 1, f"L429 SELECT INTO 고유 매칭 실패 ({body.count(OLD_SELECT)})"
    hist_lines = [l for l in body.splitlines(keepends=True) if HIST_ANCHOR_TEXT in l]
    assert len(hist_lines) == 1, f"헤더 History 앵커 고유 매칭 실패 ({len(hist_lines)})"
    out = body.replace(OLD_SELECT, NEW_SELECT, 1)
    out = out.replace(hist_lines[0], hist_lines[0] + HIST_ADD, 1)
    assert out.count(MARK) == 3, out.count(MARK)
    assert out.count("\n") - body.count("\n") == 7, out.count("\n") - body.count("\n")
    assert out.count(OLD_SELECT) == 1 and out.count("WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL;") == 1
    return out


def ddl_text(body):
    return "CREATE OR REPLACE " + body + ("" if body.endswith("\n") else "\n") + "/\n"


def call(cur, ver):
    """GET_ORDERLIST 호출 — O_RC1 전행 md5 / 건수 / 결과커서. GTT 만 쓰므로 호출 후 ROLLBACK"""
    rc1 = cur.var(oracledb.DB_TYPE_CURSOR); rc2 = cur.var(oracledb.DB_TYPE_CURSOR); rr = cur.var(oracledb.DB_TYPE_CURSOR)
    args = list(CALL_ARGS); args[1] = ver
    try:
        cur.callproc("SCM_MGR.PKG_DMF0068.P_DMF0068_GET_ORDERLIST", args + [rc1, rc2, rr])
        rows = rc1.getvalue().fetchall(); res = rr.getvalue().fetchall()
        r = dict(ok=True, rows=len(rows), md5=hashlib.md5(repr(rows).encode()).hexdigest(), result=[list(map(str, x)) for x in res])
    except Exception as e:
        r = dict(ok=False, error=str(e).splitlines()[0][:220])
    cur.connection.rollback()
    return r


# ─────────────────────────── SQL*Plus 식 스크립트 리허설 (클라우드 파일을 사내에서 그대로 실행) ───────────────────────────
def run_script(cur, path, label):
    text = open(path, encoding="utf-8").read()
    lines = text.splitlines()
    stmts, buf, in_block, in_cmt = [], [], False, False
    for l in lines:
        s = l.strip()
        if not in_block and not buf:
            if in_cmt:
                if "*/" in s: in_cmt = False
                continue
            if s.startswith("/*"):
                if "*/" not in s: in_cmt = True
                continue
            if not s or s.startswith("--") or s.upper().startswith("SET "): continue
            in_block = bool(re.match(r"(?i)^(DECLARE|BEGIN|CREATE\s+OR\s+REPLACE)\b", s))
        if in_block:
            if s == "/":
                stmts.append(("BLOCK", "\n".join(buf))); buf, in_block = [], False
            else: buf.append(l)
        else:
            buf.append(l)
            if s.endswith(";"):
                stmts.append(("SQL", "\n".join(buf).rstrip().rstrip(";"))); buf = []
    assert not buf, f"{label}: 미종결 문장 잔존 — {buf[:2]}"
    out = []
    for kind, st in stmts:
        head = re.sub(r"\s+", " ", st)[:90]
        try:
            cur.execute(st)
            if cur.description:
                rows = cur.fetchall(); out.append(dict(kind=kind, ok=True, head=head, rows=[[str(v)[:120] if v is not None else None for v in r] for r in rows]))
            else:
                out.append(dict(kind=kind, ok=True, head=head))
        except Exception as e:
            out.append(dict(kind=kind, ok=False, head=head, error=str(e).splitlines()[0][:200]))
    cur.connection.commit()
    nerr = sum(1 for o in out if not o["ok"])
    print(f"  [{label}] {len(out)} stmts, errors={nerr}")
    for o in out:
        if not o["ok"]: print("     ERROR", o["head"], "::", o["error"])
        elif o.get("rows") is not None: print("     ", o["head"][:60], "→", o["rows"][:6])
    return out


# ─────────────────────────── 클라우드 패키지 파일 생성 ───────────────────────────
def write_cloud(base_body, new_body, ddl_after, fetched):
    os.makedirs(CLOUD, exist_ok=True)
    base_lines, new_lines = len(base_body.splitlines()), len(new_body.splitlines())   # ALL_SOURCE MAX(line) 과 같은 셈법
    base_len = sum(len(l) for l in base_body.splitlines(keepends=True))
    W = lambda n, s: open(os.path.join(CLOUD, n), "w", encoding="utf-8", newline="\n").write(s)
    tgt = "SELECT ORI_CUTOFF_VERSION_NO"
    W("00_PRECHECK_CLOUD.sql", f"""/* 00_PRECHECK — 조회 전용. 클라우드 PKG_DMF0068 PACKAGE BODY 판본 판정 ({MARK})
 * [H-APPLIED] 마커 수 >0 → SKIP (이미 적용)
 * [H-LINES]/[H-LEN] 줄 수 {base_lines} · 총 길이 {base_len} 가 사내 변경 직전 판(2026-10-08 16:02, md5 {BASE_MD5})과 같으면 10 전체본 적용 가능
 * [H-TARGET] L429 `SELECT ORI_CUTOFF_VERSION_NO` + `FETCH FIRST 1 ROWS ONLY` 가 BEGIN 없이 노출되어 있으면 결함 판 → 10(전체본) 또는 12(수동 반영)
 * [H-GUARD]  NO_DATA_FOUND 가드 수 = 0 이면 미적용 */
SELECT 'H-APPLIED' AS chk, COUNT(*) AS cnt, CASE WHEN COUNT(*) > 0 THEN 'SKIP — 이미 적용됨' ELSE '미적용' END AS judge
  FROM all_source WHERE owner = 'SCM_MGR' AND name = '{NAME}' AND type = '{TYP}' AND text LIKE '%E20261009-VERNODATA%'
UNION ALL
SELECT 'H-LINES', MAX(line), CASE WHEN MAX(line) = {base_lines} THEN '사내 판과 줄 수 일치 → 10 전체본 가능' ELSE '⚠ 줄 수 다름 → 10 전체본 금지, 12 수동 반영' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = '{NAME}' AND type = '{TYP}'
UNION ALL
SELECT 'H-LEN', SUM(LENGTH(text)), CASE WHEN SUM(LENGTH(text)) = {base_len} THEN '사내 판과 길이 일치' ELSE '⚠ 길이 다름 → 12 수동 반영' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = '{NAME}' AND type = '{TYP}'
UNION ALL
SELECT 'H-TARGET', COUNT(*), CASE WHEN COUNT(*) = 1 THEN 'L429 SELECT INTO 실존 (결함 판)' ELSE '⚠ 대상 문장 수 ' || COUNT(*) || ' — 원문 확인' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = '{NAME}' AND type = '{TYP}' AND line = 429 AND text LIKE '%{tgt}%'
UNION ALL
SELECT 'H-GUARD', COUNT(*), CASE WHEN COUNT(*) = 0 THEN '가드 없음 (미적용)' ELSE '가드 있음' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = '{NAME}' AND type = '{TYP}' AND text LIKE '%WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL%'
UNION ALL
SELECT 'H-DDL', NULL, '현재 LAST_DDL = ' || TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || status
  FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = '{NAME}' AND object_type = '{TYP}';
""")
    W("05_BACKUP_CLOUD_SOURCE.sql", f"""/* 05_BACKUP — 클라우드 현재 PKG_DMF0068 BODY 원문 보관 (있으면 건너뜀). 롤백 98 이 읽는다 */
DECLARE n NUMBER; BEGIN
  SELECT COUNT(*) INTO n FROM all_tables WHERE owner = 'SCM_MGR' AND table_name = '{BAK_TABLE}';
  IF n = 0 THEN EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.{BAK_TABLE} AS SELECT name, type, line, text, SYSDATE AS bak_dt FROM all_source WHERE owner = ''SCM_MGR'' AND name = ''{NAME}'' AND type = ''{TYP}'''; END IF;
END;
/
SELECT COUNT(*) AS backed_lines, MAX(bak_dt) AS bak_dt FROM SCM_MGR.{BAK_TABLE};
""")
    W("10_PKG_DMF0068_BODY.sql",
      f"-- 10 전체본 — 00_PRECHECK [H-LINES]={base_lines} · [H-LEN]={base_len} · [H-APPLIED]=0 일 때만 실행. 다르면 12_CHANGE_BLOCK 수동 반영.\n"
      f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl_after} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 md5 {hashlib.md5(new_body.encode('utf-8')).hexdigest()}, {new_lines}줄, 마커 3)\n"
      + ddl_text(new_body))
    diff = difflib.unified_diff(base_body.splitlines(keepends=True), new_body.splitlines(keepends=True), "cloud_before", "after", n=3)
    W("12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt",
      f"{MARK} 변경 블록 — 판본이 다르면 이 diff 를 클라우드 원문에 수동 반영. '-' 줄을 '+' 줄로. @@ 줄번호는 사내 기준.\n"
      "규칙: ① 헤더 History 에 1줄 추가(선택) ② L429~437 `SELECT ORI_CUTOFF_VERSION_NO INTO V_ORI_VERSION_NO ... FETCH FIRST 1 ROWS ONLY );` 9줄을 그대로 둔 채\n"
      "      앞에 주석 2줄 + `BEGIN`, 뒤에 `EXCEPTION / WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL; / END;` 를 넣는다 (+7줄)\n"
      "주의: P_DMF0068_GET_LOOKUPPROJECT 주석 블록 안의 MSSQL 원문(L268 `SET @V_ORI_VERSION_NO = (SELECT TOP 1 ...)`)은 대상 아님.\n\n"
      + "".join(diff))
    W("13_RECOMPILE_DEPENDENTS.sql", f"""/* 13 — 본체 컴파일 확인 + 의존 객체 재컴파일 (사내 의존 = 없음) */
ALTER PACKAGE SCM_MGR.{NAME} COMPILE BODY;
SELECT object_name, object_type, status FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = '{NAME}';
SELECT line, position, text FROM all_errors WHERE owner = 'SCM_MGR' AND name = '{NAME}' ORDER BY sequence;
BEGIN
  FOR r IN (SELECT owner, name, type FROM all_dependencies WHERE referenced_owner = 'SCM_MGR' AND referenced_name = '{NAME}' AND owner = 'SCM_MGR' AND name <> '{NAME}') LOOP
    BEGIN EXECUTE IMMEDIATE 'ALTER ' || CASE r.type WHEN 'PACKAGE BODY' THEN 'PACKAGE' ELSE r.type END || ' SCM_MGR.' || r.name || ' COMPILE' || CASE r.type WHEN 'PACKAGE BODY' THEN ' BODY' END; EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
END;
/
""")
    W("90_VERIFY.sql", f"""/* 90 VERIFY — V1~V5 조회 전용 · V6 은 없는 버전으로 GET 1회 호출(GTT 만 사용, 커밋 없음) — 오류 없이 끝나야 한다 */
SELECT 'V1 VALID' AS chk, status AS val FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = '{NAME}' AND object_type = '{TYP}'
UNION ALL SELECT 'V2 마커 3', TO_CHAR(COUNT(*)) FROM all_source WHERE owner = 'SCM_MGR' AND name = '{NAME}' AND type = '{TYP}' AND text LIKE '%E20261009-VERNODATA%'
UNION ALL SELECT 'V3 NO_DATA_FOUND 가드 1', TO_CHAR(COUNT(*)) FROM all_source WHERE owner = 'SCM_MGR' AND name = '{NAME}' AND type = '{TYP}' AND text LIKE '%WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL%'
UNION ALL SELECT 'V4 줄 수 {new_lines}', TO_CHAR(MAX(line)) FROM all_source WHERE owner = 'SCM_MGR' AND name = '{NAME}' AND type = '{TYP}'
UNION ALL SELECT 'V5 의존 INVALID 0', TO_CHAR(COUNT(*)) FROM all_objects o WHERE o.owner = 'SCM_MGR' AND o.status = 'INVALID'
                 AND o.object_name IN (SELECT name FROM all_dependencies WHERE referenced_owner = 'SCM_MGR' AND referenced_name = '{NAME}');
/* V6 — 클라우드 오류 파라미터 그대로 호출 (없는 버전). 적용 전이면 ORA-20001/ORA-01403, 적용 후면 정상 종료 */
DECLARE
  rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rr SYS_REFCURSOR; v_code VARCHAR2(10); v_msg VARCHAR2(4000); v_evt VARCHAR2(100);
BEGIN
  SCM_MGR.PKG_DMF0068.P_DMF0068_GET_ORDERLIST('40', '{MISSING_VER}', '202501', '202712', 'minyonglee1', 'DMF0068', rc1, rc2, rr);
  FETCH rr INTO v_code, v_msg, v_evt;
  CLOSE rc1; CLOSE rc2; CLOSE rr;
  DBMS_OUTPUT.PUT_LINE('V6 없는 버전 호출 OK — RESULT CODE=' || v_code || ' MSG=' || v_msg);
  ROLLBACK;
END;
/
""")
    W("98_ROLLBACK_FROM_CLOUD_BACKUP.sql", f"""/* 98 ROLLBACK — 05 가 보관한 클라우드 원문으로 복원 (적용 전 판으로 되돌림) */
DECLARE v CLOB; BEGIN
  DBMS_LOB.CREATETEMPORARY(v, TRUE);
  FOR r IN (SELECT text FROM SCM_MGR.{BAK_TABLE} WHERE type = '{TYP}' ORDER BY line) LOOP DBMS_LOB.WRITEAPPEND(v, LENGTH(r.text), r.text); END LOOP;
  EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;
END;
/
SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = '{NAME}' AND object_type = '{TYP}';
""")


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "build"
    con = connect(); cur = con.cursor()
    ddl, st, body, md5 = fetch(cur)
    print("FRESH", ddl, st, "md5", md5, "lines", body.count("\n"))
    R = dict(fresh=dict(last_ddl=ddl, status=st, md5=md5, lines=body.count("\n")))
    if md5 != BASE_MD5:
        print("⚠ 원문이 착수 기준(BASE_MD5)과 다름 — 다른 작업자 변경 가능. 치환 assert 로 계속하되 diff 확인 필요")
    bak = os.path.join(HERE, "00_BACKUP_PKG_DMF0068_BODY.sql")
    if not os.path.exists(bak):                       # 백업은 적용 전 1회 생성 후 불변 (덮어쓰기 금지)
        open(bak, "w", encoding="utf-8", newline="\n").write(
            f"-- 00_BACKUP (사내 ZIOUI1 적용 전 원문) SCM_MGR.{NAME} {TYP} LAST_DDL={ddl} md5={md5} FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M}\n" + ddl_text(body))
        json.dump(R["fresh"], open(os.path.join(HERE, "_fresh_state.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    new = patch(body)
    fetched = f"{datetime.datetime.now():%Y-%m-%d %H:%M}"
    open(os.path.join(HERE, "01_PKG_DMF0068_BODY.sql"), "w", encoding="utf-8", newline="\n").write(
        f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl} FETCHED={fetched} DB=ZIOUI1 (기준 md5 {md5} → 패치본 +7줄, 마커 3)\n" + ddl_text(new))
    print("build OK: 줄수", body.count("\n"), "→", new.count("\n"), "(+%d)" % (new.count("\n") - body.count("\n")))
    if cmd != "apply":
        return

    # 1) 적용 전 기준 출력 캡처 (없는 버전 = 오류 재현 / 있는 버전 = 행 md5)
    R["before"] = {v: call(cur, v) for v in TEST_VERS}
    for v, r in R["before"].items(): print("  BEFORE", v, r)
    assert not R["before"][MISSING_VER]["ok"] and "ORA-01403" in R["before"][MISSING_VER]["error"], "적용 전 재현 실패 — 전제 불일치"

    # 2) 클라우드 패키지 파일 생성(적용 전 판 기준 지문) → 05 리허설 (원문 백업 테이블 — 98 롤백 리허설용)
    write_cloud(body, new, ddl, fetched)
    R["rehearsal_05"] = run_script(cur, os.path.join(CLOUD, "05_BACKUP_CLOUD_SOURCE.sql"), "05_BACKUP")
    assert all(o["ok"] for o in R["rehearsal_05"])

    # 3) FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
    ddl_g, st_g, body_g, md5_g = fetch(cur)
    assert body_g == body, f"FRESH-GATE 실패: 착수 후 DB 원문 변경 ({md5} → {md5_g}) — 중단·재조회·재병합"
    stmt = ddl_text(new); stmt = stmt[: stmt.rstrip().rfind("/")].rstrip()
    cur.execute(stmt); con.commit()
    ddl2, st2, body2, md52 = fetch(cur); errs = errors(cur)
    print("APPLIED", st2, ddl2, "errors", len(errs), "markers", body2.count(MARK), "md5", md52, "lines", body2.count("\n"))
    for e in errs: print("  ERR", e)
    assert st2 == "VALID" and not errs and body2 == new, "적용 후 원문 불일치 또는 INVALID"
    R["applied"] = dict(last_ddl=ddl2, status=st2, md5=md52, lines=body2.count("\n"), markers=body2.count(MARK), invalid_dependents=invalid_dependents(cur))

    # 4) 적용 후 출력 비교
    R["after"] = {v: call(cur, v) for v in TEST_VERS}
    for v, r in R["after"].items(): print("  AFTER ", v, r)
    assert R["after"][MISSING_VER]["ok"], "적용 후에도 없는 버전 호출 실패"
    for v in TEST_VERS:
        b, a = R["before"][v], R["after"][v]
        if b["ok"]:
            assert a["ok"] and a["md5"] == b["md5"] and a["rows"] == b["rows"], f"회귀: {v} 적용 전후 결과 다름"

    # 5) 클라우드 00/13/90 리허설 (적용 후 상태 — 00 은 'SKIP 이미 적용' 판정이 정상)
    for f in ("00_PRECHECK_CLOUD.sql", "13_RECOMPILE_DEPENDENTS.sql", "90_VERIFY.sql"):
        R["rehearsal_" + f[:2]] = run_script(cur, os.path.join(CLOUD, f), f)
        assert all(o["ok"] for o in R["rehearsal_" + f[:2]]), f"{f} 리허설 오류"

    # 6) 98 롤백 리허설 → 원문 복원 확인(md5 == 기준) → 없는 버전 오류 재발 확인 → 10 재적용 → 재검증
    R["rehearsal_98"] = run_script(cur, os.path.join(CLOUD, "98_ROLLBACK_FROM_CLOUD_BACKUP.sql"), "98_ROLLBACK")
    assert all(o["ok"] for o in R["rehearsal_98"])
    ddl3, st3, body3, md53 = fetch(cur)
    assert body3 == body and st3 == "VALID", "98 롤백 후 원문이 기준본과 다름"
    R["rollback_check"] = dict(md5=md53, status=st3, missing_call=call(cur, MISSING_VER))
    assert not R["rollback_check"]["missing_call"]["ok"], "롤백 후에도 오류가 나지 않음 — 롤백 무효"
    print("  ROLLBACK 리허설 OK (원문 복원, 오류 재발 확인)")
    R["rehearsal_10"] = run_script(cur, os.path.join(CLOUD, "10_PKG_DMF0068_BODY.sql"), "10_BODY")
    assert all(o["ok"] for o in R["rehearsal_10"])
    ddl4, st4, body4, md54 = fetch(cur); errs4 = errors(cur)
    assert st4 == "VALID" and not errs4 and body4 == new, "10 재적용 후 불일치"
    R["final"] = dict(last_ddl=ddl4, status=st4, md5=md54, lines=body4.count("\n"), markers=body4.count(MARK),
                      invalid_dependents=invalid_dependents(cur), calls={v: call(cur, v) for v in TEST_VERS})
    for v in TEST_VERS:
        b, a = R["before"][v], R["final"]["calls"][v]
        assert a["ok"] and (not b["ok"] or (a["md5"] == b["md5"] and a["rows"] == b["rows"]))
    # 10 파일 SOURCE-FRESH 스탬프를 최종 LAST_DDL 로 갱신 (내용 동일)
    p10 = os.path.join(CLOUD, "10_PKG_DMF0068_BODY.sql"); t10 = open(p10, encoding="utf-8").read()
    open(p10, "w", encoding="utf-8", newline="\n").write(re.sub(r"LAST_DDL=\S+ \S+", f"LAST_DDL={ddl4}", t10, count=1))
    # 사내 리허설용 백업 테이블 정리 (클라우드에서는 05 가 만든 테이블을 남겨 둔다)
    cur.execute(f"DROP TABLE SCM_MGR.{BAK_TABLE} PURGE"); con.commit()
    R["bak_table_dropped_inhouse"] = True
    R["applied_at"] = str(datetime.datetime.now())
    json.dump(R, open(os.path.join(HERE, "_apply_result.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
    print("DONE — final", R["final"]["status"], R["final"]["last_ddl"], "lines", R["final"]["lines"], "markers", R["final"]["markers"])


if __name__ == "__main__":
    main()
