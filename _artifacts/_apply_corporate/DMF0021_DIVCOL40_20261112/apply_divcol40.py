"""DMF0021 [E20261112-DIVCOL40] — 40 조회 시 81 전용 키 컬럼을 40 대응 컬럼으로 치환 (2026-11-12)

증상 (사용자 minyonglee1 · Div 40 · 11-12 10:53): RTF[R+P] 입력 후 저장하면 SUCCESS 인데 재조회 시 값이 사라진다.
원인 (사내 ZIOUI1 실측 11-12 10:55~10:56):
  - 사용자 'C' 컬럼 개인화(11-02 16:16 저장)가 81 형 구성이다: PROJECT_CODE · TEXT · FROM_SITE_ID · PLANT_SITE_ID 는 있고
    40 전용 END_CUSTOMER40 · CELL_PROD_SITE_ID · TEXT4082 는 없다.
  - P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX 는 개인화 컬럼으로 행 키(v_ColList)를 만든다. 사업부 필터가 없어 40 조회 행에
    81 전용 컬럼만 실리고 40 전용 키는 실리지 않는다(화면 컬럼은 GET_SPREAD_TITLE 사업부 필터로 숨는다).
  - FE 저장(40)은 행 데이터의 END_CUSTOMER40(프로젝트 슬롯) · CELL_PROD_SITE_ID 를 읽는다(sales-plan.save.ts:76·90) → 빈 값 전송
    → 저장 SP 가 '/' · '-' 로 바꿔 저장 → 실제 데이터 키(PROJECT_CODE 'IM' · CELL_PROD_SITE_ID 'NJ01-A')와 다른 키에 들어가 재조회 행에 보이지 않는다.
  - 11-11 [E20261111-DIVCOL](81 계열에서 40 전용 컬럼 치환)의 반대 방향이다.

보완 (40 한정 · 순수 추가 블록 · 기존 줄 무변경):
  - 40 대상이 아닌 컬럼(SHEET_COLUMNS.DIVISION_ID 에 40 없음) 중 40 대응 컬럼이 있는 3종을 치환:
      PROJECT_CODE → END_CUSTOMER40 (SP 정의 = A.PROJECT_CODE AS END_CUSTOMER40 — 값 동일) / FROM_SITE_ID → CELL_PROD_SITE_ID / TEXT → TEXT4082
  - 40 대응 컬럼이 이미 키에 있으면 치환하지 않고 그대로 둔다(행 구성 무변경).
  - 그 밖의 컬럼(PLANT_SITE_ID 등)은 건드리지 않는다 — FE 저장이 PLANT_SITE_ID 를 읽는다.

절차 = hook #152: ALL_SOURCE 재조회 기준본 → 고유 매칭 assert → .ASIS 백업 → FRESH-GATE → CREATE OR REPLACE → VALID/ALL_ERRORS 0
사용: python apply_divcol40.py            (dry-run: 기준본·변경본 파일 + 적용 전 조회 결과)
      python apply_divcol40.py --apply    (FRESH-GATE 후 적용 + 적용 후 조회 결과 대조)
"""
import sys, pathlib, datetime, json
import oracledb

sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info  # noqa: E402

OWNER, NAME, TYP = "SCM_MGR", "PKG_DMF0021", "PACKAGE BODY"
HERE = pathlib.Path(__file__).resolve().parent

ANCHOR = "    --[E20231128-000738]숫자표기형태 구분 컬럼(NOTATION) 추가\n"
MARK = "[E20261112-DIVCOL40]"
BLOCK = """    --[E20261112-DIVCOL40] 2026-11-12 40 조회 — 개인화에 81 전용 컬럼만 있고 40 대응 컬럼이 없으면 40 컬럼으로 치환
    --  FE 저장(40)은 행 데이터의 END_CUSTOMER40(= PROJECT_CODE 값) · CELL_PROD_SITE_ID · TEXT4082 를 읽는다. 81 형 개인화(PROJECT_CODE · FROM_SITE_ID · TEXT)로
    --  40 을 조회하면 이 키가 행에 없어 빈 값으로 저장 → 저장 SP 가 '/' · '-' 로 바꿔 다른 키에 넣고, 재조회 시 입력값이 사라진다(minyonglee1 RTF 2026-11-12).
    --  · 40 대상이 아닌 컬럼(SHEET_COLUMNS.DIVISION_ID 에 40 없음) 3종 치환: PROJECT_CODE→END_CUSTOMER40, FROM_SITE_ID→CELL_PROD_SITE_ID, TEXT→TEXT4082
    --  · 40 대응 컬럼이 이미 키에 있으면 그대로 둔다(치환·제외 없음) · 그 밖의 컬럼(PLANT_SITE_ID 등)은 건드리지 않는다
    IF p_division_id = '40' THEN
        DECLARE
            v_d4_col   CLOB;
            v_d4_ord   CLOB;
            v_d4_seen  VARCHAR2(32767) := ',';
            v_d4_all   VARCHAR2(32767);
            v_d4_n     PLS_INTEGER;
            v_d4_ctok  VARCHAR2(4000);
            v_d4_otok  VARCHAR2(4000);
            v_d4_name  VARCHAR2(200);
            v_d4_new   VARCHAR2(200);
            v_d4_div   VARCHAR2(4000);
            v_d4_hit   PLS_INTEGER;
        BEGIN
            v_d4_all := ',' || REPLACE(REPLACE(TO_CHAR(v_ColList), '[', ''), ']', '') || ',';
            v_d4_n   := REGEXP_COUNT(v_ColList, ',') + 1;
            FOR i IN 1 .. v_d4_n LOOP
                v_d4_ctok := REGEXP_SUBSTR(v_ColList,   '[^,]+', 1, i);
                v_d4_otok := REGEXP_SUBSTR(v_OrderList, '[^,]+', 1, i);
                v_d4_name := REPLACE(REPLACE(v_d4_ctok, '[', ''), ']', '');
                v_d4_new  := CASE v_d4_name WHEN 'PROJECT_CODE' THEN 'END_CUSTOMER40'
                                            WHEN 'FROM_SITE_ID' THEN 'CELL_PROD_SITE_ID'
                                            WHEN 'TEXT'         THEN 'TEXT4082'
                                            ELSE NULL END;
                IF v_d4_new IS NOT NULL THEN
                    SELECT COUNT(*), MAX(REPLACE(C.DIVISION_ID, ' ', ''))
                      INTO v_d4_hit, v_d4_div
                      FROM SCM_MST_SHEET_COLUMNS C
                     WHERE C.PROGRAM_ID  = v_p_program_id
                       AND C.SHEET_NAME  = v_p_sheet_name
                       AND C.COLUMN_NAME = v_d4_name;
                    IF NOT ( v_d4_hit > 0 AND v_d4_div IS NOT NULL
                             AND ',' || v_d4_div || ',' NOT LIKE '%,40,%' ) THEN
                        v_d4_new := NULL;   -- 원 컬럼이 40 대상 → 치환하지 않음
                    ELSIF INSTR(v_d4_all, ',' || v_d4_new || ',') > 0 THEN
                        v_d4_new := NULL;   -- 40 대응 컬럼이 이미 키에 있음 → 그대로 둠
                    END IF;
                END IF;
                v_d4_new := NVL(v_d4_new, v_d4_name);
                IF INSTR(v_d4_seen, ',' || v_d4_new || ',') = 0 THEN
                    v_d4_seen := v_d4_seen || v_d4_new || ',';
                    v_d4_col  := CASE WHEN v_d4_col IS NULL THEN '' ELSE v_d4_col || ',' END || '[' || v_d4_new || ']';
                    v_d4_ord  := CASE WHEN v_d4_ord IS NULL THEN '' ELSE v_d4_ord || ',' END
                                 || REPLACE(v_d4_otok, '[' || v_d4_name || ']', '[' || v_d4_new || ']');
                END IF;
            END LOOP;
            v_ColList   := v_d4_col;
            v_OrderList := v_d4_ord;
        END;
    END IF;
"""

# 사용자 화면이 실제로 보낸 조회 인자(BE 로그 11-12 10:5x · minyonglee1 · Div 40 · MONTHLY)
GET_ARGS = ['40', 'ALL', 'ALL', 'ALL', '', '', 'ALL', '20261101', '20261109', '20270531', 'minyonglee1', 'ALL', 'ALL', '', 'N', 'ADMIN', 'MONTHLY', '']
ITEM = 'MCCM349215A1-111'


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    ddl, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=TYP)
    return "".join(r[0] for r in cur.fetchall()), ddl, st


def to_ddl(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def snapshot(con, label):
    """조회 SP 를 사용자 인자로 호출 → 컬럼 목록 · 행 수 · 대상 품목 행"""
    cur = con.cursor()
    rc, c2, c3 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("SCM_MGR.PKG_DMF0021.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX", GET_ARGS + [rc, c2, c3])
    r = rc.getvalue(); cols = [d[0] for d in r.description]; rows = r.fetchall()
    con.rollback()
    fixed = [c for c in cols if not (c[:2] in ('M_', 'W_', 'D_'))]
    it = [dict(zip(cols, x)) for x in rows if ITEM in [str(v) for v in x]]
    keys = ('END_CUSTOMER40', 'PROJECT_CODE', 'CELL_PROD_SITE_ID', 'FROM_SITE_ID', 'TEXT4082', 'TEXT', 'PLANT_SITE_ID')
    res = {'label': label, 'rows': len(rows), 'cols': len(cols), 'fixed_cols': fixed,
           'key_cols_present': [k for k in keys if k in cols],
           'item_rows': len(it),
           'item_rtf': [{k: v for k, v in d.items() if k in keys or k in ('MEASURE', 'M_202612', 'M_202701', 'M_202702', 'M_202703', 'M_202704')}
                        for d in it if str(d.get('MEASURE', '')).startswith('RTF')],
           # 동적 값 전체 합(행 구성이 바뀌어도 값 총량은 같아야 한다)
           'num_sum': round(sum(float(v) for x in rows for c, v in zip(cols, x) if c[:2] in ('M_', 'W_', 'D_') and isinstance(v, (int, float))), 3)}
    (HERE / f"GET_{label}.json").write_text(json.dumps(res, ensure_ascii=False, indent=1, default=str), encoding="utf-8")
    print(f"[조회 {label}] 행 {res['rows']} · 컬럼 {res['cols']} · 키 컬럼 {res['key_cols_present']} · 품목 행 {res['item_rows']} · 값 합 {res['num_sum']}")
    for d in res['item_rtf']: print("   ", d)
    return res


def main():
    apply = "--apply" in sys.argv
    u, p, d = conn_info()
    stamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','SERVICE_NAME') FROM DUAL")
        print("DB", cur.fetchone())
        base, ddl, st = fetch(cur)
        print(f"기준본 LAST_DDL={ddl} STATUS={st} FETCHED={stamp} chars={len(base)}")
        asis = HERE / f"{NAME}_BODY.ASIS.sql"
        if MARK in base:
            sys.exit("이미 반영됨 — 마커 존재. 중단")
        assert base.count(ANCHOR) == 1, f"ANCHOR 매칭 {base.count(ANCHOR)} != 1 — 원문 변경 · 중단"
        tobe = base.replace(ANCHOR, BLOCK + ANCHOR)
        if not asis.exists():
            asis.write_text(f"-- SOURCE-FRESH: {OWNER}.{NAME} {TYP} LAST_DDL={ddl} FETCHED={stamp} DB=ZIOUI1 (원복용 백업)\n"
                            + to_ddl(base) + "/\n", encoding="utf-8")
        (HERE / f"{NAME}_BODY.TOBE.sql").write_text(
            f"-- SOURCE-FRESH: {OWNER}.{NAME} {TYP} LAST_DDL={ddl} FETCHED={stamp} DB=ZIOUI1\n" + to_ddl(tobe) + "/\n",
            encoding="utf-8")
        print("변경 = 순수 추가", tobe.count("\n") - base.count("\n"), "줄")
        before = snapshot(con, "BEFORE")
        if not apply:
            print("dry-run 종료")
            return
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본(.ASIS)
        now, ddl2, _ = fetch(cur)
        saved = asis.read_text(encoding="utf-8").split("\n", 1)[1]
        assert to_ddl(now) + "/\n" == saved, "FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합"
        assert ddl2 == ddl, "FRESH-GATE 실패: LAST_DDL 변경"
        cur.execute(to_ddl(tobe))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE",
                    o=OWNER, n=NAME, t=TYP)
        errs = cur.fetchall()
        after, ddl3, st3 = fetch(cur)
        print(f"적용 후 LAST_DDL={ddl3} STATUS={st3} ALL_ERRORS={len(errs)} 적용본==DB원문 {after == tobe}")
        for e in errs:
            print("  ERR", e)
        cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER=:o AND STATUS<>'VALID' AND OBJECT_NAME LIKE '%DMF0021%'", o=OWNER)
        print("DMF0021 INVALID", cur.fetchall())
        aft = snapshot(con, "AFTER")
        print("대조: 행", before['rows'], "→", aft['rows'], "· 값 합", before['num_sum'], "→", aft['num_sum'],
              "· 사라진 고정 컬럼", [c for c in before['fixed_cols'] if c not in aft['fixed_cols']],
              "· 새 고정 컬럼", [c for c in aft['fixed_cols'] if c not in before['fixed_cols']])


if __name__ == "__main__":
    main()
