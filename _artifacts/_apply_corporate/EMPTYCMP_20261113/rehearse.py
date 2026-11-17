# -*- coding: utf-8 -*-
"""클라우드 패치 SQL 사내 리허설 — python rehearse.py <sql 파일> [dry]
  블록(/ 단독 줄 구분)마다 실행하고 DBMS_OUTPUT 을 출력한다. dry = c_dry 를 TRUE 로 바꿔 실행(적용 안 함)."""
import sys, os, re, datetime
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
path = sys.argv[1]; dry = len(sys.argv) > 2 and sys.argv[2] == 'dry'
txt = open(path, encoding='utf-8').read()
if dry:
    txt = txt.replace('c_dry   CONSTANT BOOLEAN := FALSE', 'c_dry   CONSTANT BOOLEAN := TRUE')
# 사내 접속 계정은 system(CURRENT_SCHEMA=SCM_MGR) 이라 USER_* 가 SCM_MGR 것이 아니다 → 리허설에서만 ALL_* + OWNER 조건으로 바꾼다(패키지 파일은 그대로)
for v, c in (('USER_SOURCE', 'NAME'), ('USER_OBJECTS', 'OBJECT_NAME'), ('USER_ERRORS', 'NAME')):
    txt = txt.replace('FROM %s WHERE %s = ' % (v, c), "FROM %s WHERE OWNER = 'SCM_MGR' AND %s = " % (v.replace('USER_', 'ALL_'), c))
assert 'USER_SOURCE' not in txt and 'USER_OBJECTS' not in txt and 'USER_ERRORS' not in txt
blocks = [b for b in re.split(r'\n/[ \t]*\n', txt) if 'DECLARE' in b]
con = dbconn.connect('tobe', write=True); cur = con.cursor()
print('[%s] %s %s 블록 %d' % (datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), os.path.basename(path), 'DRY' if dry else 'RUN', len(blocks)))
for b in blocks:
    b = b[b.index('DECLARE'):]
    cur.callproc('DBMS_OUTPUT.ENABLE', [None])
    try:
        cur.execute(b)
    except Exception as e:
        print('  예외:', dbconn.mask(str(e))[:300])
    ln = cur.var(str); st = cur.var(int)
    while True:
        cur.callproc('DBMS_OUTPUT.GET_LINE', [ln, st])
        if st.getvalue() != 0: break
        print(' ', ln.getvalue())
con.rollback(); con.close()
