"""SYS0013 SAVE_QUERY_LIST SP 신규 작성 — DQ_LIST main CRUD (Stage 1).

배경 (사용자 결정 2026-06-21):
  B안 — NSCM 표준 SAVE SP 신규 작성 (AS-IS SP 4종 INVALID 무시).

설계:
  - SP: PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST
  - 입력: P_DATA CLOB (JSON array — [{crudType, dqId, divisionId, dqName, description, dqText, validYn, adminOnlyYn}])
  - JSON_TABLE '$[*]' + cursor FOR LOOP 표준 패턴 (메모리 룰 feedback_sp_json_table_array_cursor_loop)
  - CRUD_TYPE 'I'/'M'/'D' 분기
  - PK = DQ_ID (single) — INSERT 시 MAX(DQ_ID) + 1
  - 출력: O_RC1 (affected count) + O_RESULT_CURSOR (SUCCESS/MSG)

참조:
  - AS-IS PR_DM_ADM_DQ_CREATE (INVALID — NextSCM Pilot 변환 사고)
  - NSCM 표준 SAVE 패턴 (메모리 룰 + DMF reference)

진행:
  1. SPEC 에 PROCEDURE 선언 추가
  2. BODY 에 PROCEDURE 본문 추가
  3. recompile + STATUS=VALID
  4. 직접 호출 검증 (INSERT 1 row test)
"""
import os, sys, oracledb

sys.stdout.reconfigure(line_buffering=True)
u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

# -- SPEC 추가 --
print('\n[ STEP 1 ] SPEC 에 SAVE_QUERY_LIST 선언 추가')
cur.execute("SELECT DBMS_METADATA.GET_DDL('PACKAGE_SPEC', 'PKG_SYS0013', 'SCM_MGR') FROM DUAL")
spec_lob = cur.fetchone()[0]
spec = spec_lob.read() if isinstance(spec_lob, oracledb.LOB) else spec_lob

new_spec_proc = """
  PROCEDURE P_SYS0013_SAVE_QUERY_LIST
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  );
"""

if 'P_SYS0013_SAVE_QUERY_LIST' in spec:
    print('  SPEC 에 이미 선언 존재 — skip')
else:
    # END PKG_SYS0013; 직전에 추가
    if 'END PKG_SYS0013' in spec:
        new_spec = spec.replace('END PKG_SYS0013', new_spec_proc + '\nEND PKG_SYS0013', 1)
    elif 'END;' in spec.rstrip().rstrip('/').rstrip():
        # 마지막 END; 직전
        idx = spec.rfind('END;')
        new_spec = spec[:idx] + new_spec_proc + '\n' + spec[idx:]
    else:
        print('  ❌ SPEC END 위치 찾기 실패')
        sys.exit(1)
    # /끝 제거
    new_spec = new_spec.rstrip().rstrip('/').rstrip()
    try:
        cur.execute(new_spec)
        print('  SPEC RECOMPILE OK')
    except Exception as e:
        print(f'  ❌ SPEC RECOMPILE FAIL: {e}')
        sys.exit(1)

# -- BODY 추가 --
print('\n[ STEP 2 ] BODY 에 SAVE_QUERY_LIST 본문 추가')
cur.execute("SELECT DBMS_METADATA.GET_DDL('PACKAGE_BODY', 'PKG_SYS0013', 'SCM_MGR') FROM DUAL")
body_lob = cur.fetchone()[0]
body = body_lob.read() if isinstance(body_lob, oracledb.LOB) else body_lob

new_body_proc = """
  PROCEDURE P_SYS0013_SAVE_QUERY_LIST
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
    V_NEW_DQ_ID   NUMBER;
    V_AFFECTED    NUMBER := 0;
    V_USER        VARCHAR2(600 CHAR) := NVL(P_USER_ID, 'admin');
  BEGIN
    FOR rec IN (
      SELECT *
        FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
            CRUD_TYPE       VARCHAR2(10)   PATH '$.crudType',
            DQ_ID           NUMBER         PATH '$.dqId',
            DIVISION_ID     VARCHAR2(50)   PATH '$.divisionId',
            DQ_NAME         VARCHAR2(2000) PATH '$.dqName',
            DESCRIPTION     VARCHAR2(4000) PATH '$.description',
            DQ_TEXT         CLOB           PATH '$.dqText',
            VALID_YN        VARCHAR2(4)    PATH '$.validYn',
            ADMIN_ONLY_YN   VARCHAR2(4)    PATH '$.adminOnlyYn'
        ))
    ) LOOP
      IF rec.CRUD_TYPE = 'I' THEN
        SELECT NVL(MAX(DQ_ID), 0) + 1 INTO V_NEW_DQ_ID FROM SCM_ADM_DQ_LIST;
        INSERT INTO SCM_ADM_DQ_LIST (
          DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT,
          VALID_YN, ADMIN_ONLY_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        ) VALUES (
          V_NEW_DQ_ID,
          NVL(rec.DIVISION_ID, '-'),
          NVL(rec.DQ_NAME, ''),
          NVL(rec.DESCRIPTION, ''),
          rec.DQ_TEXT,
          NVL(rec.VALID_YN, 'Y'),
          NVL(rec.ADMIN_ONLY_YN, 'N'),
          V_USER, SYSDATE, V_USER, SYSDATE
        );
        V_AFFECTED := V_AFFECTED + 1;
      ELSIF rec.CRUD_TYPE = 'M' THEN
        UPDATE SCM_ADM_DQ_LIST
           SET DIVISION_ID      = NVL(rec.DIVISION_ID, DIVISION_ID),
               DQ_NAME          = NVL(rec.DQ_NAME, DQ_NAME),
               DESCRIPTION      = NVL(rec.DESCRIPTION, DESCRIPTION),
               DQ_TEXT          = NVL(rec.DQ_TEXT, DQ_TEXT),
               VALID_YN         = NVL(rec.VALID_YN, VALID_YN),
               ADMIN_ONLY_YN    = NVL(rec.ADMIN_ONLY_YN, ADMIN_ONLY_YN),
               LAST_UPDATED_BY  = V_USER,
               LAST_UPDATE_DATE = SYSDATE
         WHERE DQ_ID = rec.DQ_ID;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      ELSIF rec.CRUD_TYPE = 'D' THEN
        DELETE FROM SCM_ADM_DQ_LIST WHERE DQ_ID = rec.DQ_ID;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      END IF;
    END LOOP;

    OPEN O_RC1 FOR
      SELECT V_AFFECTED AS AFFECTED FROM DUAL;
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
  END P_SYS0013_SAVE_QUERY_LIST;
"""

if 'P_SYS0013_SAVE_QUERY_LIST' in body:
    print('  BODY 에 이미 선언 존재 — skip')
else:
    if 'END PKG_SYS0013' in body:
        new_body = body.replace('END PKG_SYS0013', new_body_proc + '\nEND PKG_SYS0013', 1)
    else:
        idx = body.rfind('END;')
        new_body = body[:idx] + new_body_proc + '\n' + body[idx:]
    new_body = new_body.rstrip().rstrip('/').rstrip()
    try:
        cur.execute(new_body)
        print('  BODY RECOMPILE OK')
    except Exception as e:
        print(f'  ❌ BODY RECOMPILE FAIL: {e}')
        sys.exit(1)

# -- STATUS --
print('\n[ STEP 3 ] STATUS:')
cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SYS0013' ORDER BY OBJECT_TYPE")
for r in cur.fetchall(): print(f'  {r}')

# -- 호출 검증 (INSERT 1 row) --
print('\n[ STEP 4 ] INSERT 1 row test:')
rc1 = conn.cursor()
result_cursor = conn.cursor()
test_json = """[{"crudType":"I","divisionId":"-","dqName":"TEST_NEW_QUERY_DELETE_AFTER","description":"test row","dqText":"SELECT 1 FROM DUAL","validYn":"Y","adminOnlyYn":"Y"}]"""
try:
    cur.callproc('SCM_MGR.PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST', [test_json, 'minyonglee1', rc1, result_cursor])
    print(f'  ✅ SP OK')
    print(f'  RC1: {rc1.fetchall()}')
    print(f'  RESULT: {result_cursor.fetchall()}')
    conn.commit()
    # cleanup
    cur.execute("DELETE FROM SCM_ADM_DQ_LIST WHERE DQ_NAME='TEST_NEW_QUERY_DELETE_AFTER'")
    print(f'  test row cleanup: {cur.rowcount} deleted')
    conn.commit()
except Exception as e:
    print(f'  ❌ SP ERROR: {e}')

conn.close()
print('\n[ done ] Stage 1 SAVE_QUERY_LIST SP 작성 완료.')
