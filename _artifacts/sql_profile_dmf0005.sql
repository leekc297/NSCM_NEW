-- =====================================================================
-- SQL Profile — DMF0005 PRODUCTION inner SELECT 강제 plan
--   SQL_ID: 6t6b1fdujgrhc
--   Hints: LEADING / USE_NL / INDEX
--   force_match=>TRUE 로 bind 무관 적용
-- =====================================================================
ALTER SESSION SET CONTAINER=FREEPDB1;

DECLARE
    l_sql_text CLOB;
    l_hints    SYS.SQLPROF_ATTR;
BEGIN
    -- 대상 SQL_TEXT 추출
    SELECT sql_fulltext INTO l_sql_text FROM v$sqlarea WHERE sql_id='6t6b1fdujgrhc' AND ROWNUM=1;

    -- Hint set
    l_hints := SYS.SQLPROF_ATTR(
        q'[BEGIN_OUTLINE_DATA]',
        q'[LEADING(@"SEL$E27E5C90" "SI"@"SEL$3" "ST"@"SEL$3" "DI"@"SEL$3" "PRJ"@"SEL$3" "ISV"@"SEL$3" "SC"@"SEL$3" "CM"@"SEL$3" "IA"@"SEL$3" "CT"@"SEL$3")]',
        q'[USE_NL(@"SEL$E27E5C90" "ST"@"SEL$3")]',
        q'[USE_NL(@"SEL$E27E5C90" "DI"@"SEL$3")]',
        q'[USE_NL(@"SEL$E27E5C90" "PRJ"@"SEL$3")]',
        q'[USE_NL(@"SEL$E27E5C90" "ISV"@"SEL$3")]',
        q'[USE_NL(@"SEL$E27E5C90" "SC"@"SEL$3")]',
        q'[USE_NL(@"SEL$E27E5C90" "CM"@"SEL$3")]',
        q'[USE_NL(@"SEL$E27E5C90" "IA"@"SEL$3")]',
        q'[USE_NL(@"SEL$E27E5C90" "CT"@"SEL$3")]',
        q'[INDEX(@"SEL$E27E5C90" "SI"@"SEL$3" ("SCM_MST_SITE_ITEM"."DIVISION_ID"))]',
        q'[END_OUTLINE_DATA]'
    );

    -- 기존 profile 제거 (있으면)
    BEGIN
        DBMS_SQLTUNE.DROP_SQL_PROFILE(name=>'PRF_DMF0005_PRODUCTION_NL');
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    -- 새 profile 등록
    DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
        sql_text     => l_sql_text,
        profile      => l_hints,
        name         => 'PRF_DMF0005_PRODUCTION_NL',
        force_match  => TRUE,
        replace      => TRUE,
        category     => 'DEFAULT'
    );

    DBMS_OUTPUT.PUT_LINE('Profile PRF_DMF0005_PRODUCTION_NL imported.');
END;
/

-- 적용 확인
SELECT name, category, status, force_matching FROM dba_sql_profiles WHERE name='PRF_DMF0005_PRODUCTION_NL';

-- shared pool flush 로 stale plan 제거
ALTER SYSTEM FLUSH SHARED_POOL;

EXIT
