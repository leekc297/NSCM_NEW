"""SYS0013 SAVE_COLUMNS + SAVE_PARAMETERS SP 신규 작성 (Stage 2 + 3).

설계:
  - SAVE_COLUMNS:    P_DATA JSON [{crudType, dqId, columnName, valueYn, valueType, validYn, seqno}]
                     PK = (DQ_ID, COLUMN_NAME) — SEQNO 는 ATTRIBUTE1 매핑
  - SAVE_PARAMETERS: P_DATA JSON [{crudType, dqId, parameterId, parameterType, operationId, validYn, repYn, seqno, defaultValue}]
                     PK = (DQ_ID, PARAMETER_ID) — SEQNO ATTRIBUTE1, DEFAULT_VALUE ATTRIBUTE2

패턴: SAVE_QUERY_LIST 와 동일 (JSON_TABLE '$[*]' + cursor FOR LOOP + CRUD_TYPE 분기).
"""
import os, sys, oracledb

sys.stdout.reconfigure(line_buffering=True)
u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

SPEC_PROCS = """
  PROCEDURE P_SYS0013_SAVE_COLUMNS
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  );

  PROCEDURE P_SYS0013_SAVE_PARAMETERS
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  );
"""

BODY_PROCS = """
  PROCEDURE P_SYS0013_SAVE_COLUMNS
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  )
  AS
    V_SQL_CODE    VARCHAR2(100 CHAR);
    V_SQL_ERRMSG  VARCHAR2(1000 CHAR);
    V_BACKTRACE   VARCHAR2(4000 CHAR);
    V_AFFECTED    NUMBER := 0;
    V_USER        VARCHAR2(600 CHAR) := NVL(P_USER_ID, 'admin');
  BEGIN
    FOR rec IN (
      SELECT *
        FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
            CRUD_TYPE       VARCHAR2(10)   PATH '$.crudType',
            DQ_ID           NUMBER         PATH '$.dqId',
            COLUMN_NAME     VARCHAR2(200)  PATH '$.columnName',
            VALUE_YN        VARCHAR2(4)    PATH '$.valueYn',
            VALUE_TYPE      VARCHAR2(200)  PATH '$.valueType',
            VALID_YN        VARCHAR2(4)    PATH '$.validYn',
            SEQNO           VARCHAR2(20)   PATH '$.seqno'
        ))
    ) LOOP
      IF rec.CRUD_TYPE = 'I' THEN
        INSERT INTO SCM_ADM_DQ_COLUMN (
          DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
        ) VALUES (
          rec.DQ_ID, rec.COLUMN_NAME,
          NVL(rec.VALUE_YN, 'Y'), NVL(rec.VALUE_TYPE, 'System.String'), NVL(rec.VALID_YN, 'Y'),
          V_USER, SYSDATE, V_USER, SYSDATE, NVL(rec.SEQNO, '0')
        );
        V_AFFECTED := V_AFFECTED + 1;
      ELSIF rec.CRUD_TYPE = 'M' THEN
        UPDATE SCM_ADM_DQ_COLUMN
           SET VALUE_YN         = NVL(rec.VALUE_YN, VALUE_YN),
               VALUE_TYPE       = NVL(rec.VALUE_TYPE, VALUE_TYPE),
               VALID_YN         = NVL(rec.VALID_YN, VALID_YN),
               ATTRIBUTE1       = NVL(rec.SEQNO, ATTRIBUTE1),
               LAST_UPDATED_BY  = V_USER,
               LAST_UPDATE_DATE = SYSDATE
         WHERE DQ_ID = rec.DQ_ID AND COLUMN_NAME = rec.COLUMN_NAME;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      ELSIF rec.CRUD_TYPE = 'D' THEN
        DELETE FROM SCM_ADM_DQ_COLUMN WHERE DQ_ID = rec.DQ_ID AND COLUMN_NAME = rec.COLUMN_NAME;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      END IF;
    END LOOP;

    OPEN O_RC1 FOR SELECT V_AFFECTED AS AFFECTED FROM DUAL;
    OPEN O_RESULT_CURSOR FOR
      SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1=2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      V_SQL_CODE   := TO_CHAR(SQLCODE);
      V_SQL_ERRMSG := SQLERRM;
      V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_SQL_ERRMSG ||
        ' / BACKTRACE=' || V_BACKTRACE);
  END P_SYS0013_SAVE_COLUMNS;

  PROCEDURE P_SYS0013_SAVE_PARAMETERS
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  )
  AS
    V_SQL_CODE    VARCHAR2(100 CHAR);
    V_SQL_ERRMSG  VARCHAR2(1000 CHAR);
    V_BACKTRACE   VARCHAR2(4000 CHAR);
    V_AFFECTED    NUMBER := 0;
    V_USER        VARCHAR2(600 CHAR) := NVL(P_USER_ID, 'admin');
  BEGIN
    FOR rec IN (
      SELECT *
        FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
            CRUD_TYPE       VARCHAR2(10)   PATH '$.crudType',
            DQ_ID           NUMBER         PATH '$.dqId',
            PARAMETER_ID    VARCHAR2(200)  PATH '$.parameterId',
            PARAMETER_TYPE  VARCHAR2(50)   PATH '$.parameterType',
            OPERATION_ID    VARCHAR2(10)   PATH '$.operationId',
            VALID_YN        VARCHAR2(4)    PATH '$.validYn',
            REP_YN          VARCHAR2(4)    PATH '$.repYn',
            SEQNO           VARCHAR2(20)   PATH '$.seqno',
            DEFAULT_VALUE   VARCHAR2(600)  PATH '$.defaultValue'
        ))
    ) LOOP
      IF rec.CRUD_TYPE = 'I' THEN
        INSERT INTO SCM_ADM_DQ_PARAMETER (
          DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID,
          VALID_YN, REP_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2
        ) VALUES (
          rec.DQ_ID, rec.PARAMETER_ID,
          NVL(rec.PARAMETER_TYPE, 'Parameter'),
          NVL(rec.OPERATION_ID, '-'),
          NVL(rec.VALID_YN, 'Y'),
          NVL(rec.REP_YN, 'N'),
          V_USER, SYSDATE, V_USER, SYSDATE,
          NVL(rec.SEQNO, '0'),
          rec.DEFAULT_VALUE
        );
        V_AFFECTED := V_AFFECTED + 1;
      ELSIF rec.CRUD_TYPE = 'M' THEN
        UPDATE SCM_ADM_DQ_PARAMETER
           SET PARAMETER_TYPE   = NVL(rec.PARAMETER_TYPE, PARAMETER_TYPE),
               OPERATION_ID     = NVL(rec.OPERATION_ID, OPERATION_ID),
               VALID_YN         = NVL(rec.VALID_YN, VALID_YN),
               REP_YN           = NVL(rec.REP_YN, REP_YN),
               ATTRIBUTE1       = NVL(rec.SEQNO, ATTRIBUTE1),
               ATTRIBUTE2       = NVL(rec.DEFAULT_VALUE, ATTRIBUTE2),
               LAST_UPDATED_BY  = V_USER,
               LAST_UPDATE_DATE = SYSDATE
         WHERE DQ_ID = rec.DQ_ID AND PARAMETER_ID = rec.PARAMETER_ID;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      ELSIF rec.CRUD_TYPE = 'D' THEN
        DELETE FROM SCM_ADM_DQ_PARAMETER
         WHERE DQ_ID = rec.DQ_ID AND PARAMETER_ID = rec.PARAMETER_ID;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      END IF;
    END LOOP;

    OPEN O_RC1 FOR SELECT V_AFFECTED AS AFFECTED FROM DUAL;
    OPEN O_RESULT_CURSOR FOR
      SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1=2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      V_SQL_CODE   := TO_CHAR(SQLCODE);
      V_SQL_ERRMSG := SQLERRM;
      V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_SQL_ERRMSG ||
        ' / BACKTRACE=' || V_BACKTRACE);
  END P_SYS0013_SAVE_PARAMETERS;
"""

# -- SPEC --
print('\n[ STEP 1 ] SPEC 에 2 procedure 선언 추가')
cur.execute("SELECT DBMS_METADATA.GET_DDL('PACKAGE_SPEC', 'PKG_SYS0013', 'SCM_MGR') FROM DUAL")
spec = cur.fetchone()[0].read()

added = False
if 'P_SYS0013_SAVE_COLUMNS' in spec and 'P_SYS0013_SAVE_PARAMETERS' in spec:
    print('  이미 추가됨 — skip')
else:
    if 'END PKG_SYS0013' in spec:
        new_spec = spec.replace('END PKG_SYS0013', SPEC_PROCS + '\nEND PKG_SYS0013', 1)
    else:
        idx = spec.rfind('END;')
        new_spec = spec[:idx] + SPEC_PROCS + '\n' + spec[idx:]
    new_spec = new_spec.rstrip().rstrip('/').rstrip()
    cur.execute(new_spec)
    print('  SPEC RECOMPILE OK')
    added = True

# -- BODY --
print('\n[ STEP 2 ] BODY 에 2 procedure 본문 추가')
cur.execute("SELECT DBMS_METADATA.GET_DDL('PACKAGE_BODY', 'PKG_SYS0013', 'SCM_MGR') FROM DUAL")
body = cur.fetchone()[0].read()

if 'P_SYS0013_SAVE_COLUMNS' in body and 'P_SYS0013_SAVE_PARAMETERS' in body:
    print('  이미 추가됨 — skip')
else:
    if 'END PKG_SYS0013' in body:
        new_body = body.replace('END PKG_SYS0013', BODY_PROCS + '\nEND PKG_SYS0013', 1)
    else:
        idx = body.rfind('END;')
        new_body = body[:idx] + BODY_PROCS + '\n' + body[idx:]
    new_body = new_body.rstrip().rstrip('/').rstrip()
    cur.execute(new_body)
    print('  BODY RECOMPILE OK')

# -- STATUS --
print('\n[ STEP 3 ] STATUS:')
cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SYS0013' ORDER BY OBJECT_TYPE")
for r in cur.fetchall(): print(f'  {r}')

# -- 호출 검증 --
print('\n[ STEP 4 ] SAVE_COLUMNS test (DQ_ID=1, COLUMN=TEST_DELETE_AFTER):')
rc1 = conn.cursor(); rs = conn.cursor()
test_col = '[{"crudType":"I","dqId":1,"columnName":"TEST_DELETE_AFTER","valueYn":"Y","valueType":"System.String","validYn":"Y","seqno":"99"}]'
try:
    cur.callproc('SCM_MGR.PKG_SYS0013.P_SYS0013_SAVE_COLUMNS', [test_col, 'minyonglee1', rc1, rs])
    print(f'  RC1: {rc1.fetchall()}  RESULT: {rs.fetchall()}')
    conn.commit()
    cur.execute("DELETE FROM SCM_ADM_DQ_COLUMN WHERE DQ_ID=1 AND COLUMN_NAME='TEST_DELETE_AFTER'")
    print(f'  cleanup: {cur.rowcount}')
    conn.commit()
except Exception as e:
    print(f'  ❌ {e}')

print('\n[ STEP 5 ] SAVE_PARAMETERS test (DQ_ID=1, PARAM=TEST_DELETE_AFTER):')
rc1 = conn.cursor(); rs = conn.cursor()
test_param = '[{"crudType":"I","dqId":1,"parameterId":"@TEST_DELETE","parameterType":"Parameter","operationId":"-","validYn":"Y","repYn":"N","seqno":"99","defaultValue":"DEFAULT_VAL"}]'
try:
    cur.callproc('SCM_MGR.PKG_SYS0013.P_SYS0013_SAVE_PARAMETERS', [test_param, 'minyonglee1', rc1, rs])
    print(f'  RC1: {rc1.fetchall()}  RESULT: {rs.fetchall()}')
    conn.commit()
    cur.execute("DELETE FROM SCM_ADM_DQ_PARAMETER WHERE DQ_ID=1 AND PARAMETER_ID='@TEST_DELETE'")
    print(f'  cleanup: {cur.rowcount}')
    conn.commit()
except Exception as e:
    print(f'  ❌ {e}')

conn.close()
print('\n[ done ] Stage 2+3 SP 작성 완료.')
