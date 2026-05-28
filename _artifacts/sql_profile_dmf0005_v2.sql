-- SQL Profile v2 — simple hints (outline 형식 X)
ALTER SESSION SET CONTAINER=FREEPDB1;

DECLARE
    l_sql_text CLOB;
    l_hints    SYS.SQLPROF_ATTR;
BEGIN
    SELECT sql_fulltext INTO l_sql_text FROM v$sqlarea WHERE sql_id='6t6b1fdujgrhc' AND ROWNUM=1;

    l_hints := SYS.SQLPROF_ATTR(
        q'[LEADING(SI ST DI PRJ ISV SC CM IA CT)]',
        q'[USE_NL(ST DI PRJ SC CM IA CT)]',
        q'[USE_HASH(ISV)]',
        q'[INDEX(SI)]',
        q'[INDEX(ST)]',
        q'[INDEX(DI)]',
        q'[INDEX(PRJ)]',
        q'[INDEX(SC)]'
    );

    BEGIN DBMS_SQLTUNE.DROP_SQL_PROFILE(name=>'PRF_DMF0005_PRODUCTION_NL'); EXCEPTION WHEN OTHERS THEN NULL; END;

    DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
        sql_text     => l_sql_text,
        profile      => l_hints,
        name         => 'PRF_DMF0005_PRODUCTION_NL',
        force_match  => TRUE,
        replace      => TRUE
    );
END;
/

ALTER SYSTEM FLUSH SHARED_POOL;

EXIT
