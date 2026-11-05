# SCP0111 BOH 입력 → 동적 구간 INV QTY 반영 (2026-11-03 사용자 추가 요청)
#   AS-IS SCP0111_SAVE_INTEGRATION_PSI 의 INV 분기(BOH 변경량만큼 BOH_QTY·QTY 가감)를 ADMIN 저장 경로에 적용.
#   변경량 = 월별 (새 BOH - 그 월의 현재 BOH). 분리된 KEY 도 월마다 맞고 같은 값 재전송은 0 이 된다.
#   기준본 = ALL_SOURCE 새로 조회 + FRESH-GATE(착수 시 조회본과 비교) + 고유 앵커 치환.
#   인자: python apply_boh_inv_qty.py <착수 시 조회본 경로>
import pathlib
import sys

sys.path.insert(0, '_artifacts/_diagnostics')
import ora
import oracledb

HERE = pathlib.Path(__file__).parent
MARK = '2026.11.03 SCP0111 BOH INV-QTY'

OLD_SET = "                           SET BOH_QTY          = ROUND(V_BOH_QTY_N, 0)\n"
NEW_SET = OLD_SET + (
    "                             , QTY              = QTY + (ROUND(V_BOH_QTY_N, 0) - NVL(TRUNC(BOH_QTY), 0))"
    f"   /* {MARK} : AS-IS BOH 변경량만큼 INV QTY 가감 */\n"
)
OLD_NOTE = "INV 행 = BOH 셀(V_MODIQTY 는 BOH 가감값이라 QTY 에 쓰지 않음) : 같은 KEY 전체 월의 BOH 를 맞춘다 - 월마다 다르면 조회 PIVOT 이 2행으로 갈라짐"
NEW_NOTE = "INV 행 = BOH 셀 : 같은 KEY 전체 월의 BOH 를 맞추고(월마다 다르면 조회 PIVOT 이 2행으로 갈라짐) QTY 도 BOH 변경량만큼 가감"


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
    assert base.count(conv(OLD_SET)) == 1, 'SET 앵커 != 1'
    assert base.count(OLD_NOTE) == 1, '주석 앵커 != 1'
    tobe = base.replace(conv(OLD_SET), conv(NEW_SET)).replace(OLD_NOTE, NEW_NOTE)

    (HERE / 'PKG_SCP0111_BODY.INVQTY_ASIS.sql').write_text(base, encoding='utf-8', newline='')
    (HERE / 'PKG_SCP0111_BODY.INVQTY_TOBE.sql').write_text(tobe, encoding='utf-8', newline='')

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
    print('markers', fetch(cur).count(MARK))


main()
