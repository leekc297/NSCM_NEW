# -*- coding: utf-8 -*-
"""
PKG_SSP0046 생성기 (2026-11-26)
- 기준본 = 사내 ZIOUI1 SCM_MGR.PKG_DMF0045 (ALL_SOURCE 로 실행 시점에 새로 조회, hook #152)
- 화면ID 치환(DMF0045 -> SSP0046) + AS-IS SSP0046 운영 원문 차이 7곳 외과 치환(매칭 건수 assert)
- 산출: out/01_GT_SSP0046.sql, out/02_PKG_SSP0046.sql, out/03_GRANT_SYNONYM.sql, out/04_PROC_M.sql
- --apply : FRESH-GATE(착수 기준본 == 적용 직전 DB 원문) 통과 후 사내 DB 적용
"""
import oracledb, sys, os, datetime, re

BASE = 'PKG_DMF0045'
NEW = 'PKG_SSP0046'
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'out')
os.makedirs(OUT, exist_ok=True)

env = dict(l.strip().split('=', 1) for l in open(r'c:\Projects\NSCM\.env.asis', encoding='utf-8')
           if '=' in l and not l.startswith('#'))
con = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                       dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur = con.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")


def fetch(name, typ):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE",
                n=name, t=typ)
    return meta, ''.join(r[0] for r in cur.fetchall())


def rep(src, old, new, cnt=1, label=''):
    n = src.count(old)
    assert n == cnt, f'[{label}] 매칭 {n}건 (기대 {cnt}) - 원문이 바뀌었거나 이미 반영됨'
    return src.replace(old, new)


FETCHED = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
spec_meta, spec = fetch(BASE, 'PACKAGE')
body_meta, body = fetch(BASE, 'PACKAGE BODY')
assert spec and body, '기준본 조회 실패'
new_meta, _ = fetch(NEW, 'PACKAGE')

# 착수 기준본 보관(원복·FRESH-GATE 비교용)
open(os.path.join(OUT, f'{BASE}.ASIS.spec.sql'), 'w', encoding='utf-8', newline='').write(spec)
open(os.path.join(OUT, f'{BASE}.ASIS.body.sql'), 'w', encoding='utf-8', newline='').write(body)

HIST_OLD = "/* 2026.09.24  ZIONEX       [PJ202650304] MSSQL -> Oracle 전환                                      */\n"
HIST_NEW = HIST_OLD + \
    "/* 2026.11.26  ZIONEX       [SSP0046] PKG_DMF0045 기준 신규 + AS-IS SSP0046 차이 반영               */\n"

# ---------------------------------------------------------------- SPEC
CRLF, LF = chr(13) + chr(10), chr(10)
s = spec.replace(CRLF, LF).replace('DMF0045', 'SSP0046')   # 원문 CRLF -> LF (변환용 사본)
s = rep(s, HIST_OLD, HIST_NEW, 1, 'spec 이력')

# ---------------------------------------------------------------- BODY
b = body.replace(CRLF, LF).replace('DMF0045', 'SSP0046')   # 원문 CRLF -> LF (변환용 사본)
b = rep(b, HIST_OLD, HIST_NEW, 1, 'body 이력')

# [1] 선언부 : 출하확정 함수 구분, 오늘, 어제 (AS-IS @v_app_type, @v_cutoff_next_date, @v_cutoff_date_)
b = rep(b,
"""    V_CREATED_BY                VARCHAR2(50 CHAR)   := P_CREATED_BY;
""",
"""    V_CREATED_BY                VARCHAR2(50 CHAR)   := P_CREATED_BY;

    /* [SSP0046] 출하 확정구간 = FN_GET_ANL_SHIP_FROZEN_DAY_CNT('SSP') (AS-IS @v_app_type)       */
    V_APP_TYPE                  VARCHAR2(8 CHAR)    := 'SSP';
    V_CUTOFF_NEXT_DATE          VARCHAR2(8 CHAR)    := TO_CHAR(SYSDATE, 'YYYYMMDD');       /* 오늘 */
    V_CUTOFF_DATE_PREV          VARCHAR2(8 CHAR)    := TO_CHAR(SYSDATE - 1, 'YYYYMMDD');   /* 어제 */
""", 1, '선언부')

# [2] Ship Plan(Ship Req 기반) 확정구간 필터 : 오늘 + SHIP_FROZEN -> 어제 + FN('SSP')
b = rep(b,
"""       AND A.YYYYMMDD     >= TO_CHAR(SYSDATE + NVL(B.SHIP_FROZEN, 0), 'YYYYMMDD');   /* 확정구간의 다음날짜가 나오므로 >= 로 처리함 */
""",
"""       /* 확정구간의 다음날짜가 나오므로 >= 로 처리함                                                 */
       /* [SSP0046] 기준 = 어제 + FN_GET_ANL_SHIP_FROZEN_DAY_CNT('SSP', 사업부, FROM_SITE, 오늘)      */
       AND A.YYYYMMDD     >= TO_CHAR(TO_DATE(V_CUTOFF_DATE_PREV, 'YYYYMMDD')
                                     + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(V_APP_TYPE, V_DIVISION_ID, A.FROM_SITE, V_CUTOFF_NEXT_DATE), 'YYYYMMDD');
""", 1, 'Ship Plan 확정구간')

# [3] 재고 적재 : STOCK_TYPE 조건 없음 (최근 재고일 산정 쿼리의 STOCK_TYPE 은 AS-IS 도 유지)
b = rep(b,
"""     WHERE DIVISION_ID  = V_DIVISION_ID
       AND STOCK_TYPE  IN ('INVENTORY', 'WIP')
       AND CUTOFF_DATE  = TO_DATE(V_CUTOFF_DATE, 'YYYYMMDD');
""",
"""     WHERE DIVISION_ID  = V_DIVISION_ID
       /* [SSP0046] STOCK_TYPE 조건 없음 (AS-IS SSP0046) */
       AND CUTOFF_DATE  = TO_DATE(V_CUTOFF_DATE, 'YYYYMMDD');
""", 1, '재고 STOCK_TYPE')

# [4] BOH 창고 : SSP_AS_DIV_SLOC (AS 창고) UNION ALL 없음
m = re.search(r"\n                     UNION ALL\n                    SELECT DISTINCT A\.SEGMENT4 .*?AND A\.SEGMENT1    = V_DIVISION_ID\n", b, re.S)
assert m and b.count(m.group(0)) == 1 and 'SSP_AS_DIV_SLOC' in m.group(0), '[AS 창고 UNION] 매칭 실패'
b = b.replace(m.group(0), "\n                    /* [SSP0046] SSP_AS_DIV_SLOC(AS 창고) UNION 없음 (AS-IS SSP0046) */\n")

# [5] BOH 사이트·품목 : Biz Type 만 (W 제외) - 81 구간 2곳, 82 구간 2곳
b = rep(b, "OPERATION_GROUP IN (V_BIZ_TYPE, 'W')", "OPERATION_GROUP  = V_BIZ_TYPE                /* [SSP0046] W 제외 */", 4, 'BOH W 제외')

# [6] 결과 SHIP_FROZEN 컬럼 : FN('SSP', 사업부, FROM_SITE, 조회 시작일)
b = rep(b,
"""           || '     , NVL(E.SHIP_FROZEN, 0) AS SHIP_FROZEN' || CHR(10)
""",
"""           /* [SSP0046] SHIP_FROZEN = FN_GET_ANL_SHIP_FROZEN_DAY_CNT('SSP', 사업부, FROM_SITE, 조회 시작일) */
           || '     , FN_GET_ANL_SHIP_FROZEN_DAY_CNT(''' || V_APP_TYPE || ''', A.DIVISION_ID, A.FROM_SITE, ''' || V_FROM_YYYYMMDD || ''') AS SHIP_FROZEN' || CHR(10)
""", 1, 'SHIP_FROZEN 컬럼')

# [7] 머리글 : 시작일 = 오늘 (AS-IS set @p_start_dt = GETDATE)
b = rep(b,
"""    V_PROGRAM_ID    VARCHAR2(50 CHAR) := 'SSP0046';

BEGIN
""",
"""    V_PROGRAM_ID    VARCHAR2(50 CHAR) := 'SSP0046';
    V_START_DT      VARCHAR2(8 CHAR)  := TO_CHAR(SYSDATE, 'YYYYMMDD');    /* [SSP0046] 시작일 = 오늘 (AS-IS) */

BEGIN
""", 1, '머리글 선언')
b = rep(b, "WHERE A.BASIS_YYYYMMDD >= P_START_DT", "WHERE A.BASIS_YYYYMMDD >= V_START_DT", 3, '머리글 시작일')

# [8] 저장 BOD_ID : SCP_MST_BOD_N_V 우선순위 1순위, 못 찾으면 기존 값 유지 (220810 jilee)
m = re.search(r"    /\* BOD ID Update .*?AND IA\.RNUM          = 1\);\n(?=\n    /\* BOD CHECK \*/)", b, re.S)
assert m and b.count(m.group(0)) == 1, '[BOD ID Update] 매칭 실패'
b = b.replace(m.group(0),
"""    /* BOD ID Update                                                                    */
    /* Active Flag가 M이여도 로직 상 Insert 대상인 건들이 있음                           */
    /* [SSP0046] 220810 jilee 우선순위가 높은 BOD 업데이트 : SCP_MST_BOD_N_V PRIORITY 1순위 */
    /*           전 행 대상, 못 찾으면 기존 BOD_ID 유지 (AS-IS ISNULL(TOP 1 ..., BOD_ID))  */
    UPDATE GT_SSP0046_SAVE A
       SET A.BOD_ID = NVL((SELECT MIN(B.BOD_ID) KEEP (DENSE_RANK FIRST ORDER BY B.PRIORITY NULLS FIRST)
                             FROM SCP_MST_BOD_N_V B
                            WHERE A.DIVISION_ID    = B.DIVISION_ID
                              AND A.FROM_SITE      = B.FROM_SITE
                              AND A.TO_SITE        = B.TO_SITE
                              AND A.INCOTERMS      = B.SSP_INCOTERMS
                              AND A.TRANSPORT_MODE = B.TRANSPORT_MODE
                              AND B.FROM_YYYYMMDD <= A.YYYYMMDD
                              AND B.TO_YYYYMMDD   >= A.YYYYMMDD
                              AND B.BOD_VALID_YN   = 'Y'), A.BOD_ID);
""")

# [9] BOD CHECK : AS-IS isnull(BOD_ID,'') = '' -> 빈값 센티널 포함 (#119)
b = rep(b,
"""     WHERE ACTIVE_FLAG = 'M'
       AND BOD_ID     IS NULL;
""",
"""     WHERE ACTIVE_FLAG = 'M'
       AND NVL(BOD_ID, '/') IN ('-', '/');                                     /* AS-IS isnull(BOD_ID,'') = '' */
""", 1, 'BOD CHECK 건수')
b = rep(b,
"""                 WHERE ACTIVE_FLAG = 'M'
                   AND BOD_ID     IS NULL
""",
"""                 WHERE ACTIVE_FLAG = 'M'
                   AND NVL(BOD_ID, '/') IN ('-', '/')
""", 1, 'BOD CHECK 문구')

# [10] 수정·입력 판정 키 : BOD_ID 제외 (Park Tae Hak 20220801)
b = rep(b,
"""                   AND A.BOD_ID         = B.BOD_ID                              /* 20200624 KIMYONGHO 저장 문제로 해당 조건 추가 */
""",
"""                   /* AND A.BOD_ID      = B.BOD_ID  [SSP0046] 키 제외 (AS-IS Park Tae Hak 20220801 저장 문제로 주석처리) */
""", 1, 'UPDATE SET 키')
b = rep(b,
"""                      AND A.BOD_ID         = B.BOD_ID
""",
"""                      /* AND A.BOD_ID      = B.BOD_ID  [SSP0046] 키 제외 */
""", 1, 'UPDATE EXISTS 키')
b = rep(b,
"""                          AND A.BOD_ID         = B.BOD_ID                       /* 20200624 KIMYONGHO 저장 문제로 해당 조건 추가 */
""",
"""                          /* AND A.BOD_ID      = B.BOD_ID  [SSP0046] 키 제외 (AS-IS Park Tae Hak 20220801 저장 문제로 주석처리) */
""", 1, 'INSERT NOT EXISTS 키')

assert 'DMF0045' not in (s + b).replace(HIST_NEW, ''), '화면ID 치환 누락'
STAMP_NEW = f"-- SOURCE-FRESH: NEW-OBJECT SCM_MGR.{NEW} PACKAGE/BODY FETCHED={FETCHED} DB=ZIOUI1 (기준 SCM_MGR.{BASE} BODY LAST_DDL={body_meta[0]} SPEC LAST_DDL={spec_meta[0]})\n"
pkg_sql = (STAMP_NEW + f"-- 사내 {NEW} 존재 여부(조회 시각 기준): {'있음 ' + str(new_meta) if new_meta else '없음'}\n\n"
           "CREATE OR REPLACE " + s.rstrip() + "\n/\n\nCREATE OR REPLACE " + b.rstrip() + "\n/\n")
open(os.path.join(OUT, '02_PKG_SSP0046.sql'), 'w', encoding='utf-8', newline='').write(pkg_sql)

# ---------------------------------------------------------------- GT (DBMS_METADATA)
cur.execute("SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME LIKE 'GT\\_DMF0045\\_%' ESCAPE '\\' ORDER BY 1")
gts = [r[0] for r in cur.fetchall()]
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',FALSE);"
            " DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',FALSE);"
            " DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',FALSE); END;")
gt_stmts = []
for t in gts:
    cur.execute("SELECT DBMS_METADATA.GET_DDL('TABLE', :t, 'SCM_MGR') FROM DUAL", t=t)
    gt_stmts.append(cur.fetchone()[0].read().strip().replace('DMF0045', 'SSP0046'))
    cur.execute("SELECT INDEX_NAME FROM ALL_INDEXES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=t)
    for (ix,) in cur.fetchall():
        cur.execute("SELECT DBMS_METADATA.GET_DDL('INDEX', :i, 'SCM_MGR') FROM DUAL", i=ix)
        gt_stmts.append(cur.fetchone()[0].read().strip().replace('DMF0045', 'SSP0046'))
open(os.path.join(OUT, '01_GT_SSP0046.sql'), 'w', encoding='utf-8', newline='').write(
    f"-- GT_SSP0046_* {len(gts)}개 = GT_DMF0045_* 구조 복제 (DBMS_METADATA {FETCHED})\n\n" +
    "\n".join(x + "\n/\n" for x in gt_stmts))

grant_stmts = [f'GRANT SELECT ON SCM_MGR.{t.replace("DMF0045", "SSP0046")} TO RL_SCM_SEL' for t in gts] + [
    'GRANT EXECUTE ON SCM_MGR.PKG_SSP0046 TO RL_SCM_SEL',
    'GRANT EXECUTE ON SCM_MGR.PKG_SSP0046 TO SCMP_APP',
    'CREATE OR REPLACE SYNONYM SCMP_APP.PKG_SSP0046 FOR SCM_MGR.PKG_SSP0046']
open(os.path.join(OUT, '03_GRANT_SYNONYM.sql'), 'w', encoding='utf-8', newline='').write(
    "\n".join(x + ";" for x in grant_stmts) + "\n")

# ---------------------------------------------------------------- PROC_M (PKG_DMF0045 행 복제)
cur.execute("SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M "
            "WHERE PROC_NM LIKE 'PKG_DMF0045.%' ORDER BY PROC_NM, SORT_ORD")
pm = cur.fetchall()
pm_stmts = []
for pn, cn, dt, ct, so in pm:
    npn = pn.replace('DMF0045', 'SSP0046')
    pm_stmts.append(
        "INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) "
        f"SELECT '{npn}', '{cn}', '{dt}', '{ct}', {so}, 'ZIONEX', SYSDATE, 'ZIONEX', SYSDATE FROM DUAL "
        f"WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M WHERE PROC_NM = '{npn}' AND COL_NM = '{cn}')")
open(os.path.join(OUT, '04_PROC_M.sql'), 'w', encoding='utf-8', newline='').write(
    f"-- SCM_ADM_PROC_M : PKG_DMF0045 {len(pm)}행 복제 (조회 {FETCHED})\n" + "\n".join(x + ";" for x in pm_stmts) + "\nCOMMIT;\n")

print('FETCHED', FETCHED, 'BASE', spec_meta, body_meta, 'NEW exists', new_meta)
print('GT', len(gts), 'PROC_M', len(pm), 'spec lines', s.count('\n'), 'body lines', b.count('\n'))

if '--apply' in sys.argv:
    # FRESH-GATE : 적용 직전 DB 원문 재조회 == 착수 기준본
    m2s, now_spec = fetch(BASE, 'PACKAGE')
    m2b, now_body = fetch(BASE, 'PACKAGE BODY')
    assert now_spec == spec and now_body == body and m2b == body_meta, 'FRESH-GATE 실패: 착수 후 기준 원문 변경 - 중단'
    nm, _ = fetch(NEW, 'PACKAGE')
    assert nm is None, f'FRESH-GATE 실패: {NEW} 가 그 사이 생성됨 {nm} - 중단'
    for st in gt_stmts:
        try:
            cur.execute(st)
        except oracledb.DatabaseError as e:
            if 'ORA-00955' in str(e):
                print('이미 있음(건너뜀):', st.split('\n')[0][:80])
            else:
                raise
    cur.execute("CREATE OR REPLACE " + s.rstrip())
    cur.execute("CREATE OR REPLACE " + b.rstrip())
    for st in grant_stmts:
        cur.execute(st)
    for st in pm_stmts:
        cur.execute(st)
    con.commit()
    cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n", n=NEW)
    print('APPLIED', cur.fetchall())
    cur.execute("SELECT TYPE, LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n ORDER BY SEQUENCE", n=NEW)
    print('ERRORS', cur.fetchall())
