-- SOURCE-FRESH: SCM_MGR SCP_RPT_GLOBAL_PSI_MD_MM/WW 컬럼·PK + PR_SCP_RPT_GLOBAL_PSI_MD_MM/WW (ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-10-30 16:05
/* ============================================================================
 * SCP0100 클라우드 QA — PKG_SCP0100 BODY 잔여 오류 해소
 *   PL/SQL: ORA-00904 "A"."PLAN_TYPE" (BODY 1079 · 3302 행)
 * 원인 : QA 영구 테이블 SCP_RPT_GLOBAL_PSI_MD_WW / _MM 에 PLAN_TYPE 컬럼 없음
 *        (01 스크립트 확인 0 결과. DETAIL_WW/MM 은 QA 에 이미 있음)
 * 기준 : 사내 ZIOUI1 (E20260708-000926 반영본)
 *   - PLAN_TYPE VARCHAR2(50) NOT NULL, 마지막 컬럼
 *   - PK = PLAN_START_YYYYMMDD, DIVISION_ID, PLAN_TYPE, YYYYPW|YYYYMM, ITEM_ID,
 *          OPERATION_GROUP, MEASURE, FROM_SITE, TO_SITE, INCOTERMS, VARIOUS_KEY
 *   - 배치 PR_SCP_RPT_GLOBAL_PSI_MD_WW/MM 의 P_PLAN_TYPE 기본값 'FN', 실적은 'FN' 고정
 *     → 기존 행(Plan Type 도입 전 데이터) = 'FN'
 * 동작 : 멱등 (이미 맞으면 SKIP)
 *   1) PLAN_TYPE 없으면 ADD ... DEFAULT 'FN' NOT NULL  (19c 메타데이터 처리 — 기존 행 즉시 'FN')
 *   2) PK 가 사내 구성과 다르면 DROP 후 사내 구성으로 재생성 (기존 PK 컬럼 ⊂ 새 PK 인지 먼저 확인)
 *   3) QA 배치 프로시저가 PLAN_TYPE 을 넣는 버전이면 DEFAULT 제거(사내와 동일)
 *      아니면 DEFAULT 'FN' 유지 + WARN (구버전 배치가 ORA-01400 으로 깨지지 않도록)
 *   4) PKG_SCP0100 · 배치 프로시저 3종 재컴파일 → 결과 확인
 * 실행 : SCM_MGR 접속, 전체 F5. ⚠ 배치(PR_SCP_RPT_GLOBAL_PSI_MD_*) 수행 시간 피해서 실행
 *        (컬럼 추가·PK 재생성 동안 테이블 잠금. PK 재생성 시간은 QA 행수에 비례)
 * ==========================================================================*/
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

/* 사전 확인 — 실행 전 상태 (참고용) */
SELECT T.TABLE_NAME, T.NUM_ROWS,
       (SELECT COUNT(*) FROM USER_TAB_COLUMNS C WHERE C.TABLE_NAME = T.TABLE_NAME AND C.COLUMN_NAME = 'PLAN_TYPE') AS HAS_PLAN_TYPE,
       (SELECT LISTAGG(K.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY K.POSITION)
          FROM USER_CONSTRAINTS P JOIN USER_CONS_COLUMNS K ON K.CONSTRAINT_NAME = P.CONSTRAINT_NAME
         WHERE P.TABLE_NAME = T.TABLE_NAME AND P.CONSTRAINT_TYPE = 'P') AS PK_COLS
  FROM USER_TABLES T
 WHERE T.TABLE_NAME IN ('SCP_RPT_GLOBAL_PSI_MD_WW', 'SCP_RPT_GLOBAL_PSI_MD_MM')
 ORDER BY 1;

DECLARE
    PROCEDURE log(p VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(p); END;

    PROCEDURE run(p_sql VARCHAR2) IS
    BEGIN
        log('  EXEC  ' || SUBSTR(p_sql, 1, 300));
        EXECUTE IMMEDIATE p_sql;
    EXCEPTION WHEN OTHERS THEN
        log('ERROR   ' || SQLERRM || ' :: ' || SUBSTR(p_sql, 1, 300));
        RAISE;
    END;

    /* p_cols 의 모든 컬럼이 p_super 에 있으면 TRUE (콤마 구분, 공백 없음) */
    FUNCTION is_subset(p_cols VARCHAR2, p_super VARCHAR2) RETURN BOOLEAN IS
        v_rest VARCHAR2(4000) := p_cols || ',';
        v_col  VARCHAR2(200);
    BEGIN
        WHILE v_rest IS NOT NULL LOOP
            v_col  := SUBSTR(v_rest, 1, INSTR(v_rest, ',') - 1);
            v_rest := SUBSTR(v_rest, INSTR(v_rest, ',') + 1);
            IF v_col IS NOT NULL AND INSTR(',' || p_super || ',', ',' || v_col || ',') = 0 THEN
                RETURN FALSE;
            END IF;
        END LOOP;
        RETURN TRUE;
    END;

    PROCEDURE fix_table(p_tab VARCHAR2, p_pk VARCHAR2, p_pk_cols VARCHAR2, p_batch_proc VARCHAR2) IS
        n          PLS_INTEGER;
        v_null     VARCHAR2(1);
        v_old_pk   VARCHAR2(128);
        v_old_cols VARCHAR2(4000);
        v_ts       VARCHAR2(128);
        v_newproc  PLS_INTEGER;
    BEGIN
        log('== ' || p_tab);
        SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = p_tab;
        IF n = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, p_tab || ' 테이블 없음 — 이 스크립트 범위 밖');
        END IF;

        /* 1) 컬럼 */
        SELECT COUNT(*), MAX(NULLABLE) INTO n, v_null
          FROM USER_TAB_COLUMNS WHERE TABLE_NAME = p_tab AND COLUMN_NAME = 'PLAN_TYPE';
        IF n = 0 THEN
            run('ALTER TABLE ' || p_tab || ' ADD (PLAN_TYPE VARCHAR2(50) DEFAULT ''FN'' NOT NULL)');
            log('ADD     PLAN_TYPE (기존 행 = FN)');
        ELSE
            log('SKIP    PLAN_TYPE 이미 있음 (NULLABLE=' || v_null || ')');
            IF v_null = 'Y' THEN
                EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_tab || ' WHERE PLAN_TYPE IS NULL' INTO n;
                IF n > 0 THEN
                    run('UPDATE ' || p_tab || ' SET PLAN_TYPE = ''FN'' WHERE PLAN_TYPE IS NULL');
                    log('UPDATE  PLAN_TYPE NULL ' || n || '건 = FN');
                    COMMIT;
                END IF;
                run('ALTER TABLE ' || p_tab || ' MODIFY (PLAN_TYPE NOT NULL)');
            END IF;
        END IF;

        /* 2) PK */
        BEGIN
            SELECT P.CONSTRAINT_NAME,
                   (SELECT LISTAGG(K.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY K.POSITION)
                      FROM USER_CONS_COLUMNS K WHERE K.CONSTRAINT_NAME = P.CONSTRAINT_NAME),
                   (SELECT I.TABLESPACE_NAME FROM USER_INDEXES I WHERE I.INDEX_NAME = P.INDEX_NAME)
              INTO v_old_pk, v_old_cols, v_ts
              FROM USER_CONSTRAINTS P
             WHERE P.TABLE_NAME = p_tab AND P.CONSTRAINT_TYPE = 'P';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_old_pk := NULL; v_old_cols := NULL; v_ts := NULL;
        END;

        IF v_old_cols = p_pk_cols THEN
            log('SKIP    PK 사내와 동일 (' || v_old_pk || ')');
        ELSE
            log('DIFF    PK 현재=' || NVL(v_old_cols, '(없음)'));
            log('           기준=' || p_pk_cols);
            IF v_old_cols IS NOT NULL AND NOT is_subset(v_old_cols, p_pk_cols) THEN
                RAISE_APPLICATION_ERROR(-20002, p_tab || ' 기존 PK 컬럼이 새 PK 에 포함되지 않음 — 중복 위험, 수동 확인 필요: ' || v_old_cols);
            END IF;
            IF v_old_pk IS NOT NULL THEN
                run('ALTER TABLE ' || p_tab || ' DROP CONSTRAINT ' || v_old_pk || ' DROP INDEX');
            END IF;
            SELECT COUNT(*) INTO n FROM USER_INDEXES WHERE INDEX_NAME = p_pk;
            IF n > 0 THEN
                run('DROP INDEX ' || p_pk);
            END IF;
            run('CREATE UNIQUE INDEX ' || p_pk || ' ON ' || p_tab || ' (' || REPLACE(p_pk_cols, ',', ', ') || ')'
                || CASE WHEN v_ts IS NOT NULL THEN ' TABLESPACE ' || v_ts END || ' PARALLEL 4');
            run('ALTER INDEX ' || p_pk || ' NOPARALLEL');
            run('ALTER TABLE ' || p_tab || ' ADD CONSTRAINT ' || p_pk || ' PRIMARY KEY (' || REPLACE(p_pk_cols, ',', ', ') || ') USING INDEX ' || p_pk);
            log('REBUILD PK ' || p_pk);
        END IF;

        /* 3) DEFAULT — QA 배치 프로시저가 PLAN_TYPE 을 넣는 버전인지 */
        SELECT COUNT(*) INTO v_newproc
          FROM USER_SOURCE
         WHERE NAME = p_batch_proc AND TYPE = 'PROCEDURE' AND UPPER(TEXT) LIKE '%V_PLAN_TYPE%';
        IF v_newproc > 0 THEN
            run('ALTER TABLE ' || p_tab || ' MODIFY (PLAN_TYPE DEFAULT NULL)');
            log('DEFAULT 제거 (배치 ' || p_batch_proc || ' = PLAN_TYPE 버전, 사내와 동일)');
        ELSE
            log('WARN    배치 ' || p_batch_proc || ' 가 PLAN_TYPE 미반영 버전(또는 없음) — DEFAULT ''FN'' 유지. 배치 프로시저 이관 필요');
        END IF;
    END;
BEGIN
    fix_table('SCP_RPT_GLOBAL_PSI_MD_WW', 'SCP_RPT_GLOBAL_PSI_MD_WW_PK',
              'PLAN_START_YYYYMMDD,DIVISION_ID,PLAN_TYPE,YYYYPW,ITEM_ID,OPERATION_GROUP,MEASURE,FROM_SITE,TO_SITE,INCOTERMS,VARIOUS_KEY',
              'PR_SCP_RPT_GLOBAL_PSI_MD_WW');
    fix_table('SCP_RPT_GLOBAL_PSI_MD_MM', 'SCP_RPT_GLOBAL_PSI_MD_MM_PK',
              'PLAN_START_YYYYMMDD,DIVISION_ID,PLAN_TYPE,YYYYMM,ITEM_ID,OPERATION_GROUP,MEASURE,FROM_SITE,TO_SITE,INCOTERMS,VARIOUS_KEY',
              'PR_SCP_RPT_GLOBAL_PSI_MD_MM');
    log('DONE');
END;
/

/* 재컴파일 — 패키지 + 두 테이블을 쓰는 배치 프로시저 */
ALTER PACKAGE PKG_SCP0100 COMPILE;
ALTER PACKAGE PKG_SCP0100 COMPILE BODY;
ALTER PROCEDURE PR_SCP_RPT_GLOBAL_PSI_MD_WW COMPILE;
ALTER PROCEDURE PR_SCP_RPT_GLOBAL_PSI_MD_MM COMPILE;
ALTER PROCEDURE PR_SCP_RPT_GLOBAL_PSI_STD_DIO COMPILE;

/* 확인 1 — 컬럼·PK (PLAN_TYPE NULLABLE=N, PK 3번째 = PLAN_TYPE) */
SELECT T.TABLE_NAME,
       (SELECT C.DATA_TYPE || '(' || C.CHAR_LENGTH || ') NULLABLE=' || C.NULLABLE
          FROM USER_TAB_COLUMNS C WHERE C.TABLE_NAME = T.TABLE_NAME AND C.COLUMN_NAME = 'PLAN_TYPE') AS PLAN_TYPE_COL,
       (SELECT P.CONSTRAINT_NAME || ' : ' || LISTAGG(K.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY K.POSITION)
          FROM USER_CONSTRAINTS P JOIN USER_CONS_COLUMNS K ON K.CONSTRAINT_NAME = P.CONSTRAINT_NAME
         WHERE P.TABLE_NAME = T.TABLE_NAME AND P.CONSTRAINT_TYPE = 'P'
         GROUP BY P.CONSTRAINT_NAME) AS PK
  FROM USER_TABLES T
 WHERE T.TABLE_NAME IN ('SCP_RPT_GLOBAL_PSI_MD_WW', 'SCP_RPT_GLOBAL_PSI_MD_MM')
 ORDER BY 1;

/* 확인 2 — 모두 VALID */
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS
 WHERE OBJECT_NAME IN ('PKG_SCP0100', 'PR_SCP_RPT_GLOBAL_PSI_MD_WW', 'PR_SCP_RPT_GLOBAL_PSI_MD_MM', 'PR_SCP_RPT_GLOBAL_PSI_STD_DIO')
 ORDER BY 1, 2;

/* 확인 3 — 0건이어야 함 */
SELECT NAME, TYPE, LINE, POSITION, TEXT
  FROM USER_ERRORS
 WHERE NAME IN ('PKG_SCP0100', 'PR_SCP_RPT_GLOBAL_PSI_MD_WW', 'PR_SCP_RPT_GLOBAL_PSI_MD_MM', 'PR_SCP_RPT_GLOBAL_PSI_STD_DIO')
 ORDER BY NAME, TYPE, SEQUENCE;
