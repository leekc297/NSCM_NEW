"""DMF0021 [E20261112-RECENTPRICE] — 단가 없는 구간의 RTF 저장 시 최근 단가로 Sales Amt 계산 (2026-11-12)

요구 (사용자 2026-11-12 · TO-BE 추가 로직 — AS-IS 에는 없음):
  DMF0021 에서 단가가 없는 구간에 RTF 를 입력하면 최근 단가를 가져와 Sales Amt 에 적용한다.
현상 (사내 ZIOUI1 실측 11-12 11:22~11:25 · minyonglee1 · 40 · SpaceX_US_XLC · MCCM348015A1-000):
  2026-12(판가 있음) RTF 111 → SalesAmt LOC 222 / KRW 297,480 / USD 222.
  2027-01 · 2027-02(판가 없음 — 시험용으로 삭제) RTF 222 · 333 → SalesAmt 3종 모두 0.
원인:
  P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL 의 금액 파생(RTF_SYS_RP → SalesAmt_KRW/LOC/USD)은 저장 일자와 같은 구간의 판가만 찾고,
  없으면 NVL(…, 0) 으로 0 을 넣는다(AS-IS 2019·2081·2144줄과 같은 식). AS-IS 는 그 앞에서 판가 없는 RTF 저장을 MSG00462 로 막았는데,
  TO-BE 는 2026-11-11 부터 82 외 사업부의 판가 확인을 하지 않는다 → 저장은 되지만 금액이 0 이 된다. 최근 단가를 찾는 로직은 DB 어디에도 없었다.

보완 (순수 추가 블록 · 기존 줄 무변경):
  금액 파생 INSERT 3개 뒤 · DM_PLN_SALES_PLAN INSERT 앞에서, 해당 구간 판가가 없는 RTF_SYS_RP 행의 SalesAmt_KRW/LOC/USD 를
  '같은 키의 그 일자 이전 가장 최근 판가 × RTF 수량' 으로 다시 계산한다.
  - 판가가 있는 구간은 건드리지 않는다. 이전 판가도 없으면 0 그대로.
  - 82 는 대상 아님(판가 확인을 통과한 행만 저장된다).
  - 판가 원장·조인 키는 기존 파생 INSERT 와 같다: 40 = DM_PLN_CFM_SELLING_PRICE(CELL_PROD_SITE_ID 포함) / 40 외 = SCM_MST_FUTURE_PRICE.
  - 판가 원장에는 쓰지 않는다(금액만 계산).

절차 = hook #152: ALL_SOURCE 재조회 기준본 → 고유 매칭 assert → .ASIS 백업 → FRESH-GATE → CREATE OR REPLACE → VALID/ALL_ERRORS 0
사용: python apply_recentprice.py            (dry-run)
      python apply_recentprice.py --apply    (FRESH-GATE 후 적용)
"""
import sys, pathlib, datetime
import oracledb

sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info  # noqa: E402

OWNER, NAME, TYP = "SCM_MGR", "PKG_DMF0021", "PACKAGE BODY"
HERE = pathlib.Path(__file__).resolve().parent

ANCHOR = "    -- DM_PLN_SALES_PLAN INSERT (RTF_SYS_RP 계열)\n"
MARK = "[E20261112-RECENTPRICE]"
KEYS = """FP.DIVISION_ID = r.V_DIVISION_ID AND FP.PROJECT_CODE = r.V_PROJECT_CODE
                       AND FP.SCM_SITE_ID = r.V_SCM_SITE_ID
                       AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL THEN '/' ELSE FP.PLANT_SITE_ID END = r.V_PLANT_SITE_ID
                       AND FP.ITEM_ID = r.V_ITEM_ID AND FP.DOM_EXP = r.V_DOM_EXP
                       AND FP.FCST_TYPE = r.V_FCST_TYPE AND FP.INCOTERMS = r.V_INCOTERMS
                       AND FP.MEASURE = m.PM"""
BLOCK = f"""    --[E20261112-RECENTPRICE] 2026-11-12 단가 없는 구간의 RTF 저장 — 최근 단가로 Sales Amt 계산 (TO-BE 추가 로직 · AS-IS 에는 없음)
    --  2026-11-11 부터 82 외 사업부는 RTF 판가 확인(MSG00462)을 하지 않는다. 그 구간에 판가가 없으면 위 파생 INSERT 3개가 금액 0 을 넣는다.
    --  → 저장 일자 구간(BASIS_START_DATE = V_YYYYMMDD)의 판가가 없는 RTF_SYS_RP 행은, 같은 키의 그 일자 이전 가장 최근 판가로
    --    SalesAmt_KRW · SalesAmt_LOC · SalesAmt_USD 를 다시 계산한다(RTF 수량 × 최근 판가).
    --  · 판가가 있는 구간은 건드리지 않는다 · 이전 판가도 없으면 0 그대로 · 82 는 판가 확인을 통과한 행만 오므로 대상 아님
    --  · 판가 원장과 조인 키는 위 파생 INSERT 와 같다 — 40 : DM_PLN_CFM_SELLING_PRICE(CELL_PROD_SITE_ID 포함) / 40 외 : SCM_MST_FUTURE_PRICE
    --  · 판가 원장에는 쓰지 않는다(금액만 계산)
    FOR r IN ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS
                    , V_YYYYMMDD, V_QTY, V_CELL_PROD_SITE_ID
                 FROM GT_F021_SALES_PLAN_RTF
                WHERE V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D' AND V_DIVISION_ID <> '82' )
    LOOP
        FOR m IN ( SELECT 'KRW' AS PM FROM DUAL UNION ALL SELECT 'LOC' FROM DUAL UNION ALL SELECT 'USD' FROM DUAL )
        LOOP
            DECLARE
                v_rp_cnt   PLS_INTEGER := 0;
                v_rp_price NUMBER      := NULL;
            BEGIN
                IF r.V_DIVISION_ID = '40' THEN
                    SELECT COUNT(*) INTO v_rp_cnt
                      FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                     WHERE {KEYS}
                       AND FP.CELL_PROD_SITE_ID = r.V_CELL_PROD_SITE_ID
                       AND CAL.BASIS_START_DATE = r.V_YYYYMMDD;
                    IF v_rp_cnt = 0 THEN
                        SELECT MAX(FP.PRICE) KEEP (DENSE_RANK LAST ORDER BY FP.YYYYMMDD) INTO v_rp_price
                          FROM DM_PLN_CFM_SELLING_PRICE FP
                         WHERE {KEYS}
                           AND FP.CELL_PROD_SITE_ID = r.V_CELL_PROD_SITE_ID
                           AND FP.YYYYMMDD < r.V_YYYYMMDD;
                    END IF;
                ELSE
                    SELECT COUNT(*) INTO v_rp_cnt
                      FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                     WHERE {KEYS}
                       AND CAL.BASIS_START_DATE = r.V_YYYYMMDD;
                    IF v_rp_cnt = 0 THEN
                        SELECT MAX(FP.PRICE) KEEP (DENSE_RANK LAST ORDER BY FP.YYYYMMDD) INTO v_rp_price
                          FROM SCM_MST_FUTURE_PRICE FP
                         WHERE {KEYS}
                           AND FP.YYYYMMDD < r.V_YYYYMMDD;
                    END IF;
                END IF;
                IF v_rp_cnt = 0 AND v_rp_price IS NOT NULL THEN
                    UPDATE GT_F021_SALES_PLAN_RTF T
                       SET T.V_QTY = r.V_QTY * v_rp_price
                     WHERE T.V_MEASURE = 'SalesAmt_' || m.PM
                       AND T.V_ACTIVE_FLAG <> 'D'
                       AND T.V_DIVISION_ID = r.V_DIVISION_ID
                       AND NVL(T.V_PROJECT_CODE, '/')  = NVL(r.V_PROJECT_CODE, '/')
                       AND NVL(T.V_SCM_SITE_ID, '/')   = NVL(r.V_SCM_SITE_ID, '/')
                       AND NVL(T.V_PLANT_SITE_ID, '/') = NVL(r.V_PLANT_SITE_ID, '/')
                       AND NVL(T.V_ITEM_ID, '/')       = NVL(r.V_ITEM_ID, '/')
                       AND NVL(T.V_DOM_EXP, '/')       = NVL(r.V_DOM_EXP, '/')
                       AND NVL(T.V_FCST_TYPE, '/')     = NVL(r.V_FCST_TYPE, '/')
                       AND NVL(T.V_INCOTERMS, '/')     = NVL(r.V_INCOTERMS, '/')
                       AND T.V_YYYYMMDD = r.V_YYYYMMDD
                       AND T.V_CELL_PROD_SITE_ID = CASE WHEN (r.V_DIVISION_ID = '40' OR SUBSTR(r.V_DIVISION_ID, 1, 2) = '81') THEN NVL(r.V_CELL_PROD_SITE_ID, '-') ELSE '-' END;
                END IF;
            END;
        END LOOP;
    END LOOP;
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
        # 블록은 헤더 주석(=== 줄 + ANCHOR 줄) 바로 앞에 넣는다
        i = base.index(ANCHOR); j = base.rfind("\n", 0, i - 1) + 1
        assert base[j:i].lstrip().startswith("--====="), "ANCHOR 앞 줄이 구분선이 아님 — 원문 변경 · 중단"
        tobe = base[:j] + BLOCK + base[j:]
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
