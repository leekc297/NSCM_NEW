/* 2단계 삭제 : 백업 테이블 SSP_MST_DELEGATE_BAK20261125_SLASH 에 먼저 담고 같은 건수일 때만 삭제·COMMIT.
   백업이 실패하면 삭제하지 않고 오류로 멈춤. 대상 0건이면 아무것도 바꾸지 않음. 다시 실행해도 됨. */
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;

DECLARE
    N_TARGET    NUMBER := 0;
    N_BACKUP    NUMBER := 0;
    N_DELETED   NUMBER := 0;
    N_EXIST     NUMBER := 0;
BEGIN
    SELECT COUNT(*)
      INTO N_TARGET
      FROM SSP_MST_DELEGATE
     WHERE DELEGATEE_ID = '/'
        OR USER_ID      = '/'
        OR DIVISION_ID  = '/';

    DBMS_OUTPUT.PUT_LINE('삭제 대상 : ' || N_TARGET || '건');

    IF N_TARGET = 0 THEN
        DBMS_OUTPUT.PUT_LINE('대상 없음. 변경 없음.');
        RETURN;
    END IF;

    /* 지운 행을 되살릴 수 있게 INSERT 문을 출력 */
    FOR R IN (SELECT * FROM SSP_MST_DELEGATE
               WHERE DELEGATEE_ID = '/' OR USER_ID = '/' OR DIVISION_ID = '/')
    LOOP
        DBMS_OUTPUT.PUT_LINE('INSERT INTO SSP_MST_DELEGATE (DIVISION_ID, USER_ID, DELEGATEE_ID, FROM_DATE, TO_DATE, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('''
            || R.DIVISION_ID || ''', ''' || R.USER_ID || ''', ''' || R.DELEGATEE_ID || ''', '''
            || R.FROM_DATE || ''', ''' || R.TO_DATE || ''', ''' || R.VALID_YN || ''', '''
            || R.CREATED_BY || ''', TO_DATE(''' || TO_CHAR(R.CREATION_DATE, 'YYYYMMDDHH24MISS') || ''', ''YYYYMMDDHH24MISS''), '''
            || R.LAST_UPDATED_BY || ''', TO_DATE(''' || TO_CHAR(R.LAST_UPDATE_DATE, 'YYYYMMDDHH24MISS') || ''', ''YYYYMMDDHH24MISS''));');
    END LOOP;

    SELECT COUNT(*)
      INTO N_EXIST
      FROM USER_TABLES
     WHERE TABLE_NAME = 'SSP_MST_DELEGATE_BAK20261125_SLASH';

    IF N_EXIST = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SSP_MST_DELEGATE_BAK20261125_SLASH AS SELECT * FROM SSP_MST_DELEGATE WHERE 1 = 0';
    END IF;

    EXECUTE IMMEDIATE 'INSERT INTO SSP_MST_DELEGATE_BAK20261125_SLASH '
                   || 'SELECT * FROM SSP_MST_DELEGATE '
                   || 'WHERE DELEGATEE_ID = ''/'' OR USER_ID = ''/'' OR DIVISION_ID = ''/''';
    N_BACKUP := SQL%ROWCOUNT;

    IF N_BACKUP <> N_TARGET THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, '백업 건수 불일치 : 대상 ' || N_TARGET || ' / 백업 ' || N_BACKUP || '. 삭제 안 함');
    END IF;

    DELETE FROM SSP_MST_DELEGATE
     WHERE DELEGATEE_ID = '/'
        OR USER_ID      = '/'
        OR DIVISION_ID  = '/';
    N_DELETED := SQL%ROWCOUNT;

    IF N_DELETED <> N_TARGET THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, '삭제 건수 불일치 : 대상 ' || N_TARGET || ' / 삭제 ' || N_DELETED || '. 되돌림');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('백업 ' || N_BACKUP || '건, 삭제 ' || N_DELETED || '건, COMMIT 완료');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('오류로 되돌림 : ' || SQLERRM);
        RAISE;
END;
/
