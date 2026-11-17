"""DMF0021 [E20261111-DIVCOL] — 81 계열 조회 시 사업부 제외 컬럼을 행 키(v_ColList)에서 치환/제외

원인 (2026-11-11 사내 ZIOUI1 실측):
  P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX 는 사용자 'C' 개인화로 GROUP BY 키(v_ColList)를 만들지만
  SCM_MST_SHEET_COLUMNS.DIVISION_ID 사업부 필터가 없다(AS-IS 도 동일 필터가 '20190125 일단 주석처리 KHSONG').
  화면 컬럼(P_DMF0021_GET_SPREAD_TITLE)은 사업부 필터로 숨겨지므로, 숨은 40 전용 컬럼(CELL_PROD_SITE_ID 등)이
  81 조회의 행 키에만 남아 같은 품목·메저가 2 Row 로 분리된다 (jaehun_cho · Unit Price(LOC)).

보완 (81 계열 한정 · 순수 추가 블록 · 기존 줄 무변경):
  - 사업부 제외 컬럼 중 81 대응 컬럼이 있는 3종은 대응 컬럼으로 치환:
      CELL_PROD_SITE_ID → FROM_SITE_ID / END_CUSTOMER40 → PROJECT_CODE / TEXT4082 → TEXT
    (대응 컬럼이 이미 키에 있으면 제외만 — 정렬 위치 보존)
  - 대응 없는 사업부 제외 컬럼은 제외.
  - 치환 사유: 40 사용자 개인화는 PROJECT_CODE 없이 END_CUSTOMER40 만 가진 경우가 있어(사내 dodae 등)
    단순 제외 시 프로젝트 구분이 사라져 행이 합산(값 손상)된다.
  - 40·82 미적용: FE 저장이 행 데이터의 PLANT_SITE_ID(메타 81 전용)·CELL_PROD_SITE_ID(메타 40 전용, 82 저장 사용)를 읽는다
    (nscm-fe/.../sales-plan/utils/sales-plan.save.ts:78·90). SAVE SP 는 PLANT_SITE_ID 로 행 매칭(BODY L2548).

절차 = hook #152: ALL_SOURCE 재조회 기준본 → 고유 매칭 assert → .ASIS 백업 → FRESH-GATE → CREATE OR REPLACE → VALID/ALL_ERRORS 0
사용: python apply_divcol.py            (dry-run: 기준본·변경본 파일만 생성)
      python apply_divcol.py --apply    (FRESH-GATE 후 적용)
"""
import sys, pathlib, datetime
import oracledb

sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info  # noqa: E402

OWNER, NAME, TYP = "SCM_MGR", "PKG_DMF0021", "PACKAGE BODY"
HERE = pathlib.Path(__file__).resolve().parent

ANCHOR = "    v_OrderList := SUBSTR(v_OrderList, 1, LENGTH(v_OrderList) - 1);\n"
MARK = "[E20261111-DIVCOL]"
BLOCK = """    --[E20261111-DIVCOL] 2026-11-11 81 계열 조회 — 개인화/기본 컬럼 중 해당 사업부 제외 컬럼(SHEET_COLUMNS.DIVISION_ID 미포함) 정리
    --  화면 컬럼(GET_SPREAD_TITLE)은 사업부 필터로 숨는데 행 키(v_ColList GROUP BY)에는 남아 같은 품목·메저가 2 Row 로 분리됨
    --  (jaehun_cho 81 Unit Price(LOC) — 숨은 40 전용 CELL_PROD_SITE_ID '-' / 실제 생산지). AS-IS 동일 필터는 '20190125 일단 주석처리'.
    --  · 81 대응 컬럼이 있는 3종은 치환(대응 컬럼이 이미 있으면 제외만): CELL_PROD_SITE_ID→FROM_SITE_ID, END_CUSTOMER40→PROJECT_CODE, TEXT4082→TEXT
    --    (단순 제외 시 END_CUSTOMER40 만 가진 개인화는 프로젝트 구분이 사라져 행이 합산됨)
    --  · 대응 없는 사업부 제외 컬럼은 제외
    --  · 40·82 미적용: FE 저장이 행 데이터 PLANT_SITE_ID(81 전용 메타)·CELL_PROD_SITE_ID(40 전용 메타, 82 저장 사용)를 읽음
    IF p_division_id = '81' OR p_division_id LIKE '81\\_%' ESCAPE '\\' THEN
        DECLARE
            v_dc_col   CLOB;
            v_dc_ord   CLOB;
            v_dc_seen  VARCHAR2(32767) := ',';
            v_dc_all   VARCHAR2(32767);
            v_dc_n     PLS_INTEGER;
            v_dc_ctok  VARCHAR2(4000);
            v_dc_otok  VARCHAR2(4000);
            v_dc_name  VARCHAR2(200);
            v_dc_new   VARCHAR2(200);
            v_dc_div   VARCHAR2(4000);
            v_dc_hit   PLS_INTEGER;
        BEGIN
            v_dc_all := ',' || REPLACE(REPLACE(TO_CHAR(v_ColList), '[', ''), ']', '') || ',';
            v_dc_n   := REGEXP_COUNT(v_ColList, ',') + 1;
            FOR i IN 1 .. v_dc_n LOOP
                v_dc_ctok := REGEXP_SUBSTR(v_ColList,   '[^,]+', 1, i);
                v_dc_otok := REGEXP_SUBSTR(v_OrderList, '[^,]+', 1, i);
                v_dc_name := REPLACE(REPLACE(v_dc_ctok, '[', ''), ']', '');
                SELECT COUNT(*), MAX(REPLACE(C.DIVISION_ID, ' ', ''))
                  INTO v_dc_hit, v_dc_div
                  FROM SCM_MST_SHEET_COLUMNS C
                 WHERE C.PROGRAM_ID  = v_p_program_id
                   AND C.SHEET_NAME  = v_p_sheet_name
                   AND C.COLUMN_NAME = v_dc_name;
                v_dc_new := v_dc_name;
                IF v_dc_hit > 0 AND v_dc_div IS NOT NULL
                   AND ',' || v_dc_div || ',' NOT LIKE '%,' || p_division_id || ',%' THEN
                    v_dc_new := CASE v_dc_name WHEN 'CELL_PROD_SITE_ID' THEN 'FROM_SITE_ID'
                                               WHEN 'END_CUSTOMER40'    THEN 'PROJECT_CODE'
                                               WHEN 'TEXT4082'          THEN 'TEXT'
                                               ELSE NULL END;
                    IF v_dc_new IS NOT NULL AND INSTR(v_dc_all, ',' || v_dc_new || ',') > 0 THEN
                        v_dc_new := NULL;   -- 대응 컬럼이 원래 키에 있음 → 제외만 (정렬 위치 보존)
                    END IF;
                END IF;
                IF v_dc_new IS NOT NULL AND INSTR(v_dc_seen, ',' || v_dc_new || ',') = 0 THEN
                    v_dc_seen := v_dc_seen || v_dc_new || ',';
                    v_dc_col  := CASE WHEN v_dc_col IS NULL THEN '' ELSE v_dc_col || ',' END || '[' || v_dc_new || ']';
                    v_dc_ord  := CASE WHEN v_dc_ord IS NULL THEN '' ELSE v_dc_ord || ',' END
                                 || REPLACE(v_dc_otok, '[' || v_dc_name || ']', '[' || v_dc_new || ']');
                END IF;
            END LOOP;
            v_ColList   := v_dc_col;
            v_OrderList := v_dc_ord;
        END;
    END IF;
"""


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    ddl, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=TYP)
    return "".join(r[0] for r in cur.fetchall()), ddl, st


def to_ddl(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


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
        tobe = base.replace(ANCHOR, ANCHOR + BLOCK)
        if not asis.exists():
            asis.write_text(f"-- SOURCE-FRESH: {OWNER}.{NAME} {TYP} LAST_DDL={ddl} FETCHED={stamp} DB=ZIOUI1 (원복용 백업)\n"
                            + to_ddl(base) + "/\n", encoding="utf-8")
        (HERE / f"{NAME}_BODY.TOBE.sql").write_text(
            f"-- SOURCE-FRESH: {OWNER}.{NAME} {TYP} LAST_DDL={ddl} FETCHED={stamp} DB=ZIOUI1\n" + to_ddl(tobe) + "/\n",
            encoding="utf-8")
        print("변경 = 순수 추가", tobe.count("\n") - base.count("\n"), "줄")
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


if __name__ == "__main__":
    main()
