# -*- coding: utf-8 -*-
"""AS-IS(MSSQL DEV) ↔ TO-BE(사내 ZIOUI1) 테이블 대조 — TO-BE 신규 테이블과 생성 시기 분류 (읽기 전용)
 기준 1 AS-IS 존재: 대응 DB 의 sys.tables 이름(대소문자 무시) 일치
 기준 2 이관시점: C:/TRANFILE/OLD/To-be/Tobe_OPTENG_SCP_Table*_DDL.sql (파일 일자 2026-05-07) 의 CREATE TABLE 목록
 기준 3 사내 생성일: ALL_OBJECTS.CREATED (사내 DB 는 2026-10-09 부터 — 그 이전 생성일은 사내에 없음)
"""
import sys, re, csv, glob, collections, datetime
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn'); sys.path.insert(0, r'C:/Projects/NSCM/_artifacts/_diagnostics')
from dbconn import connect
import oracledb
from ora import conn_info
MAP = {'SCM_MGR': 'LGCE_SCMDEV', 'FP_MGR': 'LGCE_FPDEV_TR', 'INF_MGR': 'LGCE_INFDEV', 'OPT_MGR': 'OPTENG_SCP', 'ENG_SCP': 'ENG_SCP'}
asis = {}; asis_all = collections.defaultdict(set)
with connect('asis') as cx:
    c = cx.cursor()
    c.execute("SELECT CONVERT(varchar(19), GETDATE(), 120)"); asis_now = c.fetchone()[0]
    for d in set(MAP.values()):
        c.execute(f"SELECT UPPER(t.name), s.name, CONVERT(varchar(19), t.create_date, 120) FROM [{d}].sys.tables t JOIN [{d}].sys.schemas s ON s.schema_id=t.schema_id")
        rows = c.fetchall(); asis[d] = {r[0]: (r[1], r[2]) for r in rows}
        for r in rows: asis_all[r[0]].add(d)
may = collections.defaultdict(set); may_gtt = set()
for f in glob.glob(r'C:/TRANFILE/OLD/To-be/Tobe_OPTENG_SCP_Table*_DDL.sql'):
    for m in re.finditer(r'CREATE\s+(GLOBAL\s+TEMPORARY\s+)?TABLE\s+"?(\w+)"?\."?([\w$#]+)"?', open(f, encoding='utf-8', errors='replace').read(), re.I):
        may[m.group(2).upper()].add(m.group(3).upper())
        if m.group(1): may_gtt.add((m.group(2).upper(), m.group(3).upper()))
u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); tobe_now = cur.fetchone()[0]
    cur.execute("""SELECT T.OWNER, T.TABLE_NAME, T.TEMPORARY, TO_CHAR(O.CREATED,'YYYY-MM-DD HH24:MI:SS'), TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), T.NUM_ROWS
                     FROM ALL_TABLES T JOIN ALL_OBJECTS O ON O.OWNER=T.OWNER AND O.OBJECT_NAME=T.TABLE_NAME AND O.OBJECT_TYPE='TABLE'
                    WHERE T.OWNER IN ('SCM_MGR','FP_MGR','INF_MGR','OPT_MGR','ENG_SCP') ORDER BY 1,2""")
    tobe = cur.fetchall()
BAK = re.compile(r'(^ZB_|^ZT_|^ZZ|BAK|BACKUP|_BK\d*$|_BKUP|_OLD$|_TMP$|_TEMP$|_\d{6,8}(_\d+)?$|\$|^TMP_|^TEMP_|_COPY$|^SYS_EXPORT|^BIN\$)', re.I)
rows = []
for owner, name, temp, created, lddl, nrows in tobe:
    adb = MAP[owner]; in_asis = name in asis[adb]; other = sorted(asis_all.get(name, set()) - {adb})
    kind = 'GTT' if temp == 'Y' else ('백업·임시 사본' if BAK.search(name) else '일반')
    in_may = name in may.get(owner, set())
    when = '이관시점(05-07 덤프)에 있음' if in_may else ('사내 최초 적재일(10-09·10-13) 생성' if created[:10] in ('2026-10-09', '2026-10-13') else '10-14 이후 생성')
    rows.append(dict(OWNER=owner, TABLE_NAME=name, KIND=kind, ASIS_DB=adb, IN_ASIS='Y' if in_asis else 'N', ASIS_OTHER_DB=','.join(other),
                     IN_MAY_DUMP='Y' if in_may else 'N', TOBE_CREATED=created, TOBE_LAST_DDL=lddl, NUM_ROWS=nrows if nrows is not None else '', WHEN=when,
                     ASIS_CREATED=asis[adb].get(name, ('', ''))[1] if in_asis else ''))
with open('tobe_tables_all.csv', 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
new = [r for r in rows if r['IN_ASIS'] == 'N']
with open('tobe_new_tables.csv', 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader(); w.writerows(new)
print('AS-IS 조회', asis_now, '· TO-BE 조회', tobe_now)
print('AS-IS 테이블 수', {k: len(v) for k, v in asis.items()})
print('05-07 덤프', {k: len(v) for k, v in may.items()}, 'GTT', len(may_gtt))
print('TO-BE 테이블 수', dict(collections.Counter(r['OWNER'] for r in rows)))
print('\n[TO-BE 전체] OWNER × KIND × AS-IS 존재')
for k, v in sorted(collections.Counter((r['OWNER'], r['KIND'], r['IN_ASIS']) for r in rows).items()): print('  ', k, v)
print('\n[신규(AS-IS 에 없음)] OWNER × KIND × 생성 시기')
for k, v in sorted(collections.Counter((r['OWNER'], r['KIND'], r['WHEN']) for r in new).items()): print('  ', k, v)
print('\n[신규·일반 테이블] 다른 AS-IS DB 에 같은 이름 있음:', sum(1 for r in new if r['KIND'] == '일반' and r['ASIS_OTHER_DB']))
