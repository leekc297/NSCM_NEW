# SCP0111 ADMIN 저장 'M' 분기 = AS-IS UPDATE 1문 복원 (2026-11-17 사용자 지시)
#   AS-IS: dbo.SCP0111_SAVE_INTEGRATION_PSI_ADMIN L191~214 (MEASURE 구분 없이 BOH_QTY·QTY 대입)
#   전제: FE buildAdminPayload 가 AS-IS 처럼 월별 BOH·QTY 절대값을 보낸다(Doc/verify/SCP0111/FE_GUIDE_*.md)
#   대상: 2026.11.03 SCP0111 BOH DB-ONLY (START)~(END) 마커 구간 1곳만 치환. 그 밖의 원문은 그대로 둔다.
#   사용:
#     python apply_admin_m_asis.py fetch          착수 기준본(ALL_SOURCE) → PKG_SCP0111_BODY.ASIS.sql
#     python apply_admin_m_asis.py apply          FRESH-GATE(DB 원문 == 착수 기준본) 통과 시 CREATE OR REPLACE
#     python apply_admin_m_asis.py rollback       PKG_SCP0111_BODY.ASIS.sql 로 원복(FRESH-GATE: DB == 적용본)
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / '_artifacts' / '_diagnostics'))
import ora  # noqa: E402
import oracledb  # noqa: E402

HERE = pathlib.Path(__file__).parent
ASIS = HERE / 'PKG_SCP0111_BODY.ASIS.sql'
TOBE = HERE / 'PKG_SCP0111_BODY.TOBE.sql'

OLD_START = '/* 2026.11.03 SCP0111 BOH DB-ONLY (START)'
OLD_END = '/* 2026.11.03 SCP0111 BOH DB-ONLY (END) */'
NEW_MARK = '2026.11.17 SCP0111 ADMIN-M ASIS'

IND = ' ' * 20
NEW_BLOCK = (
    f"/* {NEW_MARK} (START) AS-IS SCP0111_SAVE_INTEGRATION_PSI_ADMIN 과 같은 UPDATE 1문 - MEASURE 구분 없음\n"
    f"{IND}   FE 가 월별 BOH_QTY·QTY 절대값을 보내는 전제(2026.11.03 BOH DB-ONLY 분기 대체) */\n"
    f"{IND}/* 변경된 수량으로 BOH_QTY, QTY 를 수정 */\n"
    f"{IND}UPDATE SCP_ANL_PSI_INTEGRATION\n"
    f"{IND}   SET BOH_QTY          = ROUND(V_BOH_QTY_N, 0)\n"
    f"{IND}     , QTY              = ROUND(V_MODI_QTY, 0)\n"
    f"{IND}     , LAST_UPDATED_BY  = V_LAST_UPDATED_BY\n"
    f"{IND}     , LAST_UPDATE_DATE = SYSDATE\n"
    f"{IND} WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)\n"
    f"{IND}   AND COMPANY_ID          = UPPER(V_COMPANY_ID)\n"
    f"{IND}   AND PLANT_ID            = UPPER(V_PLANT_ID)\n"
    f"{IND}   AND PLAN_START_YYYYMMDD = V_PLAN_START\n"
    f"{IND}   AND OPERATION_GROUP     = UPPER(V_OPERATION_GROUP)\n"
    f"{IND}   AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)\n"
    f"{IND}   AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)\n"
    f"{IND}   AND MEASURE             = UPPER(V_MEASURE)\n"
    f"{IND}   AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)\n"
    f"{IND}   AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)\n"
    f"{IND}   AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)\n"
    f"{IND}   AND UPPER(TO_SITE)      = UPPER(V_TO_SITE)\n"
    f"{IND}   AND INCOTERMS           = UPPER(V_INCOTERMS)\n"
    f"{IND}   AND YYYYMM              = UPPER(V_YYYYMM)\n"
    f"{IND}   AND ATTRIBUTE2          = UPPER(V_PLAN_TYPE);\n"
    f"{IND}/* {NEW_MARK} (END) */"
)


def connect():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute('ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR')
    print('DB', cur.execute(
        "SELECT SYS_CONTEXT('USERENV','SERVER_HOST'),SYS_CONTEXT('USERENV','SERVICE_NAME'),"
        "TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL").fetchone())
    return con, cur


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


def build(base):
    eol = '\r\n' if '\r\n' in base else '\n'
    assert base.count(OLD_START) == 1, 'START 마커 != 1'
    assert base.count(OLD_END) == 1, 'END 마커 != 1'
    assert NEW_MARK not in base, '이미 반영됨'
    i = base.index(OLD_START)
    j = base.index(OLD_END) + len(OLD_END)
    seg = base[i:j]
    # 치환 구간이 'M' 분기 안의 INV/ELSE 2문인지 확인
    assert "IF UPPER(V_MEASURE) = 'INV'" in seg and 'ROUND(NVL(QTY, 0) + V_MODI_QTY, 0)' in seg, '구간 내용 불일치'
    head = base[:i]
    assert head.rstrip().endswith('THEN') and "IF V_ACTIVE_FLAG = 'M'" in head[-200:], 'M 분기 앵커 불일치'
    return base[:i] + NEW_BLOCK.replace('\n', eol) + base[j:]


def compile_body(cur, text):
    try:
        cur.execute('CREATE OR REPLACE ' + text)
    except oracledb.DatabaseError as e:
        if e.args[0].code != 24344:
            raise


def errors(cur):
    cur.execute("SELECT LINE,POSITION,TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0111' ORDER BY SEQUENCE")
    return cur.fetchall()


def main():
    mode = sys.argv[1]
    con, cur = connect()
    print('status', status(cur))
    if mode == 'fetch':
        base = fetch(cur)
        ASIS.write_text(base, encoding='utf-8', newline='')
        TOBE.write_text(build(base), encoding='utf-8', newline='')
        print('saved', ASIS.name, len(base.splitlines()), 'lines /', TOBE.name)
        return
    if mode == 'apply':
        started = ASIS.read_bytes().decode('utf-8')
        now = fetch(cur)
        # FRESH-GATE: 적용 직전 DB 원문 == 착수 기준본
        assert now.replace('\r', '') == started.replace('\r', ''), 'FRESH-GATE 실패: 착수 후 DB 원문 변경 - 중단'
        tobe = build(now)
        assert tobe.replace('\r', '') == TOBE.read_bytes().decode('utf-8').replace('\r', ''), '적용본 파일 != 재생성본'
        compile_body(cur, tobe)
        st = status(cur)
        print('after', st)
        if st[0] != 'VALID':
            print('errors', errors(cur))
            compile_body(cur, now)
            print('restored', status(cur))
            sys.exit(1)
        assert fetch(cur).replace('\r', '') == tobe.replace('\r', ''), '적용본 != DB 원문'
        print('errors', len(errors(cur)), 'marker', fetch(cur).count(NEW_MARK))
        return
    if mode == 'rollback':
        now = fetch(cur)
        assert now.replace('\r', '') == TOBE.read_bytes().decode('utf-8').replace('\r', ''), 'FRESH-GATE 실패: DB != 적용본 - 원복 중단'
        compile_body(cur, ASIS.read_bytes().decode('utf-8'))
        print('rollback', status(cur), 'errors', len(errors(cur)))
        return
    raise SystemExit('mode = fetch | apply | rollback')


main()
