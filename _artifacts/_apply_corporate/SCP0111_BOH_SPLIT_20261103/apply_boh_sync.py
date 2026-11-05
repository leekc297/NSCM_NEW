# SCP0111 BOH 저장 2행 분리 보완 — P_SCP0111_SAVE_PSI_ADMIN 수정(M) 분기에 BOH 동기화 추가 (2026-11-03)
#   기준본 = 실행 시 ALL_SOURCE 새로 조회 + FRESH-GATE(착수 시 조회본과 비교) + 고유 앵커 치환.
#   인자: python apply_boh_sync.py <착수 시 조회본 경로>
import pathlib
import sys

sys.path.insert(0, '_artifacts/_diagnostics')
import ora
import oracledb

HERE = pathlib.Path(__file__).parent
MARK = '2026.11.03 SCP0111 BOH'

KEY = """DIVISION_ID         = UPPER(V_DIVISION_ID)
                       AND COMPANY_ID          = UPPER(V_COMPANY_ID)
                       AND PLANT_ID            = UPPER(V_PLANT_ID)
                       AND PLAN_START_YYYYMMDD = V_PLAN_START
                       AND OPERATION_GROUP     = UPPER(V_OPERATION_GROUP)
                       AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                       AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                       AND MEASURE             = UPPER(V_MEASURE)
                       AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                       AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                       AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                       AND UPPER(TO_SITE)      = UPPER(V_TO_SITE)
                       AND INCOTERMS           = UPPER(V_INCOTERMS)
                       AND ATTRIBUTE2          = UPPER(V_PLAN_TYPE)"""

ANCHOR_VAR = "        V_BOH_QTY_N         NUMBER;\n"
NEW_VAR = ANCHOR_VAR + f"        V_BOH_CHG_CNT       PLS_INTEGER := 0;   /* {MARK} */\n"

ANCHOR_M = """                /* 데이터 수정 */
                IF V_ACTIVE_FLAG = 'M'
                THEN

"""
NEW_M = ANCHOR_M + f"""                    /* {MARK} 변경 시 같은 KEY 의 조회기간 밖 월까지 맞춤 - 월마다 다르면 조회 PIVOT 이 2행으로 갈라짐 (START) */
                    SELECT COUNT(*)
                      INTO V_BOH_CHG_CNT
                      FROM SCP_ANL_PSI_INTEGRATION
                     WHERE {KEY}
                       AND YYYYMM              = UPPER(V_YYYYMM)
                       AND LNNVL(TRUNC(BOH_QTY) = ROUND(V_BOH_QTY_N, 0));

                    IF V_BOH_CHG_CNT > 0
                    THEN
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET BOH_QTY          = ROUND(V_BOH_QTY_N, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE {KEY}
                           AND LNNVL(TRUNC(BOH_QTY) = ROUND(V_BOH_QTY_N, 0));
                    END IF;
                    /* {MARK} (END) */

"""


def fetch(cur):
    cur.execute(
        "SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0111' "
        "AND TYPE='PACKAGE BODY' ORDER BY LINE"
    )
    return ''.join(r[0] for r in cur)


def status(cur):
    cur.execute(
        "SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS "
        "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0111' AND OBJECT_TYPE='PACKAGE BODY'"
    )
    return cur.fetchone()


def main():
    started = pathlib.Path(sys.argv[1]).read_bytes().decode('utf-8').replace('\r', '')
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute('ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR')
    print('DB', cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'),SYS_CONTEXT('USERENV','SERVICE_NAME'),TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL").fetchone())
    print('before', status(cur))

    # FRESH-GATE: 적용 직전 DB 원문 == 착수 시 조회본
    base = fetch(cur)
    assert base.replace('\r', '') == started, 'FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단'
    assert MARK not in base, '이미 반영됨 — 중단'
    eol = '\r\n' if '\r\n' in base else '\n'
    conv = lambda t: t.replace('\n', eol)
    assert base.count(conv(ANCHOR_VAR)) == 1, 'V_BOH_QTY_N 앵커 != 1'
    assert base.count(conv(ANCHOR_M)) == 1, "M 분기 앵커 != 1"
    tobe = base.replace(conv(ANCHOR_VAR), conv(NEW_VAR)).replace(conv(ANCHOR_M), conv(NEW_M))

    (HERE / 'PKG_SCP0111_BODY.ASIS.sql').write_text(base, encoding='utf-8', newline='')
    (HERE / 'PKG_SCP0111_BODY.TOBE.sql').write_text(tobe, encoding='utf-8', newline='')

    try:
        cur.execute('CREATE OR REPLACE ' + tobe)
    except oracledb.DatabaseError as e:
        if e.args[0].code != 24344:
            raise
    st = status(cur)
    print('after', st)
    if st[0] != 'VALID':
        cur.execute("SELECT LINE,POSITION,TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0111' ORDER BY SEQUENCE")
        print('errors', cur.fetchall())
        try:
            cur.execute('CREATE OR REPLACE ' + base)
        except oracledb.DatabaseError as e:
            print('restore error', e)
        print('restored', status(cur))
        sys.exit(1)
    assert fetch(cur).replace('\r', '') == tobe.replace('\r', ''), '적용본 != DB 원문'
    print('errors', cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0111'").fetchone())
    print('APPLIED markers', fetch(cur).count(MARK))


main()
