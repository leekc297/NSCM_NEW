"""AS-IS DQ 5 테이블 → 사내 import (NULL 처리 + 멱등)"""
import pyodbc, oracledb
import datetime as _dt

asis = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=165.244.95.223,1433;DATABASE=LGCE_SCMDEV;UID=scp_mgr_dev;PWD=1234qwer;TrustServerCertificate=yes', timeout=20)
asis_cur = asis.cursor()
tobe = oracledb.connect(user='SCM_MGR', password='!SCMroqkf2026', dsn='121.162.245.167:2521/ESSCMD')
tobe_cur = tobe.cursor()

def nvl(v, d='-'):
    # Oracle '' = NULL — 빈 string 도 default 처리
    if v is None or v == '': return d
    return v

def sysdate(): return _dt.datetime.now()

# 1) DQ_LIST — DQ_ID 1,2 이미 존재 → skip
print('=== DQ_LIST ===')
tobe_cur.execute('SELECT DQ_ID FROM SCM_ADM_DQ_LIST')
existing = {str(r[0]) for r in tobe_cur.fetchall()}
print(f'  existing: {sorted(existing)}')

asis_cur.execute("""SELECT DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT, VALID_YN, ADMIN_ONLY_YN,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                      FROM dbo.SCM_ADM_DQ_LIST ORDER BY DQ_ID""")
ins = 0
for r in asis_cur.fetchall():
    dq_id = str(r.DQ_ID)
    if dq_id in existing: continue
    tobe_cur.execute("""INSERT INTO SCM_ADM_DQ_LIST (DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT, VALID_YN, ADMIN_ONLY_YN,
                                                     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                        VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11)""",
                       [dq_id, nvl(r.DIVISION_ID, '-'), nvl(r.DQ_NAME, '-'), nvl(r.DESCRIPTION, '-'),
                        nvl(r.DQ_TEXT, '-'), nvl(r.VALID_YN, 'Y'), nvl(r.ADMIN_ONLY_YN, 'Y'),
                        nvl(r.CREATED_BY, 'system'), r.CREATION_DATE or sysdate(),
                        nvl(r.LAST_UPDATED_BY, 'system'), r.LAST_UPDATE_DATE or sysdate()])
    ins += 1
tobe.commit()
print(f'  inserted: {ins}')

# 2) DQ_COLUMN
print('=== DQ_COLUMN ===')
tobe_cur.execute('DELETE FROM SCM_ADM_DQ_COLUMN')
asis_cur.execute("""SELECT DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN, CREATED_BY, CREATION_DATE,
                           LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
                      FROM dbo.SCM_ADM_DQ_COLUMN""")
data = []
for r in asis_cur.fetchall():
    data.append((str(r.DQ_ID), nvl(r.COLUMN_NAME, '-'), nvl(r.VALUE_YN, 'N'), nvl(r.VALUE_TYPE, 'STR'),
                 nvl(r.VALID_YN, 'Y'), nvl(r.CREATED_BY, 'system'), r.CREATION_DATE or sysdate(),
                 nvl(r.LAST_UPDATED_BY, 'system'), r.LAST_UPDATE_DATE or sysdate(), r.ATTRIBUTE1))
tobe_cur.executemany("""INSERT INTO SCM_ADM_DQ_COLUMN (DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN,
                                                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1)
                        VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10)""", data, batcherrors=True)
tobe.commit()
print(f'  inserted: {len(data)}, errors: {len(tobe_cur.getbatcherrors())}')
for e in tobe_cur.getbatcherrors()[:3]: print(f'    ERR: {e.message}')

# 3) DQ_PARAMETER
print('=== DQ_PARAMETER ===')
tobe_cur.execute('DELETE FROM SCM_ADM_DQ_PARAMETER')
asis_cur.execute("""SELECT DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID, VALID_YN, REP_YN,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
                      FROM dbo.SCM_ADM_DQ_PARAMETER""")
data = []
for r in asis_cur.fetchall():
    data.append((str(r.DQ_ID), nvl(r.PARAMETER_ID, '-'), nvl(r.PARAMETER_TYPE, 'TEXT'),
                 nvl(r.OPERATION_ID, '-'), nvl(r.VALID_YN, 'Y'), nvl(r.REP_YN, 'N'),
                 nvl(r.CREATED_BY, 'system'), r.CREATION_DATE or sysdate(),
                 nvl(r.LAST_UPDATED_BY, 'system'), r.LAST_UPDATE_DATE or sysdate(), r.ATTRIBUTE1))
tobe_cur.executemany("""INSERT INTO SCM_ADM_DQ_PARAMETER (DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID, VALID_YN, REP_YN,
                                                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1)
                        VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11)""", data, batcherrors=True)
tobe.commit()
print(f'  inserted: {len(data)}, errors: {len(tobe_cur.getbatcherrors())}')
for e in tobe_cur.getbatcherrors()[:3]: print(f'    ERR: {e.message}')

# 4) DQ_USER_GROUP
print('=== DQ_USER_GROUP ===')
tobe_cur.execute('DELETE FROM SCM_ADM_DQ_USER_GROUP')
asis_cur.execute("""SELECT DQ_ID, GROUP_ID, VALID_YN, CREATED_BY, CREATION_DATE,
                           LAST_UPDATED_BY, LAST_UPDATE_DATE
                      FROM dbo.SCM_ADM_DQ_USER_GROUP""")
data = []
for r in asis_cur.fetchall():
    data.append((str(r.DQ_ID), nvl(r.GROUP_ID, '-'), nvl(r.VALID_YN, 'Y'),
                 nvl(r.CREATED_BY, 'system'), r.CREATION_DATE or sysdate(),
                 nvl(r.LAST_UPDATED_BY, 'system'), r.LAST_UPDATE_DATE or sysdate()))
tobe_cur.executemany("""INSERT INTO SCM_ADM_DQ_USER_GROUP (DQ_ID, GROUP_ID, VALID_YN,
                                                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                        VALUES (:1,:2,:3,:4,:5,:6,:7)""", data, batcherrors=True)
tobe.commit()
print(f'  inserted: {len(data)}, errors: {len(tobe_cur.getbatcherrors())}')
for e in tobe_cur.getbatcherrors()[:3]: print(f'    ERR: {e.message}')

# 5) DQ_EXECUTE_H
print('=== DQ_EXECUTE_H ===')
tobe_cur.execute('DELETE FROM SCM_ADM_DQ_EXECUTE_H')
asis_cur.execute("""SELECT HISTORY_SEQ, DQ_ID, DQ_TEXT, CREATED_BY, CREATION_DATE,
                           LAST_UPDATED_BY, LAST_UPDATE_DATE
                      FROM dbo.SCM_ADM_DQ_EXECUTE_H""")
data = []
for r in asis_cur.fetchall():
    data.append((r.HISTORY_SEQ, str(r.DQ_ID), nvl(r.DQ_TEXT, '-'),
                 nvl(r.CREATED_BY, 'system'), r.CREATION_DATE or sysdate(),
                 nvl(r.LAST_UPDATED_BY, 'system'), r.LAST_UPDATE_DATE or sysdate()))
tobe_cur.executemany("""INSERT INTO SCM_ADM_DQ_EXECUTE_H (HISTORY_SEQ, DQ_ID, DQ_TEXT,
                                                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                        VALUES (:1,:2,:3,:4,:5,:6,:7)""", data, batcherrors=True)
tobe.commit()
print(f'  inserted: {len(data)}, errors: {len(tobe_cur.getbatcherrors())}')
for e in tobe_cur.getbatcherrors()[:3]: print(f'    ERR: {e.message}')

asis.close(); tobe.close()
print('All done.')
