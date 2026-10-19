# [E20261015-SCP0030ITEMJOIN] PKG_SCP0030.P_SCP0030_GET_BOD_ITEM — Model/Nickname 조건 EXISTS → JOIN (사내 ZIOUI1 적용)
#   원인 : (V_ITEM_USE = 'N' OR EXISTS ...) 의 OR 때문에 옵티마이저가 OR-확장(CONCATENATION) →
#          31만 행 조인을 두 갈래로 2회 수행 (전체 조회 Buffers 129K, 한 갈래는 0행)
#   조치 : 조건 미사용 시 토큰 목록을 빈 토큰 1개(NULL → LIKE '%%' = 전건 일치, ITEM_ID NOT NULL)로 두고
#          토큰 목록을 FROM 절에 조인. 토큰이 여러 개 걸려 늘어나는 행은 바로 위 SELECT DISTINCT 가 합친다.
#   기준본 = 실행 시점 DB ALL_SOURCE 새로 조회 (hook #152). 적용 직전 FRESH-GATE 재조회.
import sys, pathlib, datetime
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora, oracledb

OWNER, NAME, TYP = 'SCM_MGR', 'PKG_SCP0030', 'PACKAGE BODY'
HERE = pathlib.Path(__file__).parent
MARK = '[E20261015-SCP0030ITEMJOIN]'

def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    ld, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=TYP)
    return "".join(r[0] for r in cur.fetchall()), ld, st

R = [
 # 1) 조건 미사용 시 빈 토큰 1개
 ("""        /* 비활성 품목 제외 범위 : N = 없음(사업부 미입력) · A = 전체 사업부('ALL') · L = 입력 사업부 */
""",
  """        /* 2026.10.15 %s Model/Nickname 조건 미사용이면 빈 토큰 1개 — 아래 조인에서 LIKE '%%%%' 로 전건 일치 (ITEM_ID NOT NULL) */
        IF V_ITEM_USE = 'N' THEN
            V_ITEM_TAB := T_STR_TAB(NULL);
        END IF;

        /* 비활성 품목 제외 범위 : N = 없음(사업부 미입력) · A = 전체 사업부('ALL') · L = 입력 사업부 */
""" % MARK),
 # 2) 토큰 목록 FROM 절 조인
 ("""                       ) XD                                            /* 리드타임 (사업부 + BOD 유일) — 행마다 뷰 재계산 방지(ROWNUM) */
""",
  """                       ) XD                                            /* 리드타임 (사업부 + BOD 유일) — 행마다 뷰 재계산 방지(ROWNUM) */
                     , TABLE(V_ITEM_TAB) SA                            /* 2026.10.15 %s Model/Nickname 토큰 (EXISTS → JOIN) */
""" % MARK),
 # 3) EXISTS 조건 → 조인 조건
 ("""                   AND (V_ITEM_USE = 'N'
                        OR EXISTS (SELECT 1
                                     FROM TABLE(V_ITEM_TAB) SA
                                    WHERE UPPER(A.ITEM_ID)   LIKE '%' || SA.COLUMN_VALUE || '%'
                                       OR UPPER(XC.NICK_NAME) LIKE '%' || SA.COLUMN_VALUE || '%'))
""",
  """--                 AND (V_ITEM_USE = 'N'
--                      OR EXISTS (SELECT 1
--                                   FROM TABLE(V_ITEM_TAB) SA
--                                  WHERE UPPER(A.ITEM_ID)   LIKE '%' || SA.COLUMN_VALUE || '%'
--                                     OR UPPER(XC.NICK_NAME) LIKE '%' || SA.COLUMN_VALUE || '%'))
                   /* 2026.10.15 """ + MARK + """ OR 확장(조인 2회 수행) 제거 — EXISTS → JOIN (START) */
                   AND (UPPER(A.ITEM_ID)   LIKE '%' || SA.COLUMN_VALUE || '%'
                        OR UPPER(XC.NICK_NAME) LIKE '%' || SA.COLUMN_VALUE || '%')
                   /* 2026.10.15 """ + MARK + """ (END) */
"""),
]

def main(apply):
    u, p, d = ora.conn_info(); c = oracledb.connect(user=u, password=p, dsn=d); cur = c.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL")
    host = cur.fetchone(); print('DB', host)
    base, ld, st = fetch(cur)
    if MARK in base:
        sys.exit('이미 반영됨 (%s) LAST_DDL=%s' % (MARK, ld))
    tobe = base
    for old, new in R:
        assert tobe.count(old) == 1, 'anchor != 1 : ' + old[:60]
        tobe = tobe.replace(old, new)
    ts = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    (HERE / ('PKG_SCP0030_BODY.ASIS_%s.sql' % ts)).write_text('CREATE OR REPLACE ' + base, encoding='utf-8')
    (HERE / ('PKG_SCP0030_BODY.TOBE_%s.sql' % ts)).write_text('CREATE OR REPLACE ' + tobe, encoding='utf-8')
    print('ASIS LAST_DDL=%s STATUS=%s lines=%d -> TOBE lines=%d' % (ld, st, base.count('\n'), tobe.count('\n')))
    if not apply:
        return
    # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
    now, ld2, _ = fetch(cur)
    assert now == base and ld2 == ld, 'FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합'
    cur.execute('CREATE OR REPLACE ' + tobe)
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n", o=OWNER, n=NAME); ne = cur.fetchone()[0]
    after, ld3, st3 = fetch(cur)
    cur.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER=:o AND STATUS='INVALID'", o=OWNER); inv = cur.fetchone()[0]
    print('APPLIED LAST_DDL=%s STATUS=%s ALL_ERRORS=%d DB==TOBE=%s SCM_MGR INVALID=%d' % (ld3, st3, ne, after == tobe, inv))

if __name__ == '__main__':
    main('--apply' in sys.argv)
