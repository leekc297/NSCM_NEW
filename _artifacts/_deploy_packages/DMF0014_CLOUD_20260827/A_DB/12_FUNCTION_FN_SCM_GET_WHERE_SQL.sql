CREATE OR REPLACE FUNCTION FN_SCM_GET_WHERE_SQL
(
    P_COLUMN_NAME           IN VARCHAR2
  , P_LOGICAL_OPERATOR_CODE IN VARCHAR2
  , P_CSV_TEXT_LIST         IN VARCHAR2
)
RETURN VARCHAR2
/* ============================================================
 * Program ID   : FN_SCM_GET_WHERE_SQL
 * Description  :
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2017/12/20    SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.07.06    ZIONEX         [PJ202650304] NextSCM Migration
 * ============================================================ */
/*   ALTER FUNCTION [dbo].[SCM_ARR_SPL_VAL]
   (  @sText NVARCHAR(max),  @str NVARCHAR(1)= (파이프),  @idx INT )
   RETURNS NVARCHAR(100) AS BEGIN
     DECLARE @word NVARCHAR(1000);  DECLARE @sTextData NVARCHAR(max);  DECLARE @num INT;
     ...  RETURN(@word); END ; */
IS

    V_CSV_TEXT_LIST    VARCHAR2(32767 CHAR);
    V_LOGICAL_OPERATOR VARCHAR2(100 CHAR);
    V_CONDTION_VALUE   VARCHAR2(100 CHAR);
    V_COLUMN_NAME      VARCHAR2(1000 CHAR);
    V_SQL_TEXT         VARCHAR2(32767 CHAR);
    V_COUNT            PLS_INTEGER := 0;
    V_LIST_COUNT       PLS_INTEGER := 0;
    V_1ST_NODE         VARCHAR2(4000 CHAR);
    V_2ND_NODE         VARCHAR2(4000 CHAR);
    /* 원본 @i 는 '-' 분기 안에서만 DECLARE @i INT=0 → 다른 분기 진입시 NULL. */
    V_I                PLS_INTEGER;
BEGIN
    V_CSV_TEXT_LIST    := REPLACE(REPLACE(P_CSV_TEXT_LIST, CHR(13), ''), CHR(10), ',');
    V_LOGICAL_OPERATOR := NVL(UPPER(P_LOGICAL_OPERATOR_CODE), 'LK');
    V_COLUMN_NAME      := TRIM(SCM_ARR_SPL_VAL(P_COLUMN_NAME, ':', 1));
    V_SQL_TEXT         := '';
    V_LIST_COUNT       := 0;

    /* -------------------------------------------------------------------------- */
    /* CheckedListFilter : (!)value1,valu2...(:LK) */
    /* MonthRangePicker, DateRangePicker : '20171201:20171231' 형식이므로 제외 */
    /* ComboColumn : column_name:value */
    /* -------------------------------------------------------------------------- */
    /* 원본 CHARINDEX(@v_csv_text_list,':') = "@v_csv_text_list 를 ':' 안에서 검색"
       (find/search 인자 뒤바뀐 원본 quirk 그대로 보존) -> INSTR(':', V_CSV_TEXT_LIST). */
    IF INSTR(':', V_CSV_TEXT_LIST) > 0 AND V_LOGICAL_OPERATOR NOT IN ('BW','BETWEEN','BD','BETWEN DATE','BM','BETWEEN MONTH')
    THEN

        IF TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':')) = 'LK'
        THEN
            /* CheckedListFilter : Like 검색 */
            V_LOGICAL_OPERATOR := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':'));
        END IF;

        V_CSV_TEXT_LIST := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 1, ':'));

        /* CheckedListFilter : 'end_customer_code:end_customer_name' */
        IF INSTR(':', P_COLUMN_NAME) > 0
        THEN
            V_COLUMN_NAME := TRIM(FN_SCM_SPLIT(P_COLUMN_NAME, 2, ':'));
        ELSE
            /* ComboColumn : column_name:value --2017.12.20 */
            V_COLUMN_NAME := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 1, ':'));
        END IF;

        V_CSV_TEXT_LIST := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':'));
    END IF;

    /* -------------------------------------------------------------------------- */
    IF V_LOGICAL_OPERATOR = '-'
    THEN
        V_I := 0;
        WHILE V_I <= 1000
        LOOP
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, V_I, ','));
            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                CONTINUE;

                V_COUNT := V_COUNT + 1;

                IF V_I > 1
                THEN
                    V_SQL_TEXT := V_SQL_TEXT || ',';
                END IF;

                V_SQL_TEXT := V_SQL_TEXT || '''' || V_CONDTION_VALUE || '''';
            END IF;
        END LOOP;
        RETURN V_SQL_TEXT;
    END IF;

    /* V_SQL_TEXT := '3333'; */

    /* -------------------------------------------------------------------------- */
    IF NVL(V_CSV_TEXT_LIST, 'ALL') = 'ALL'
    THEN
        V_SQL_TEXT := '';
    /* -------------------------------------------------------------------------- */
    ELSIF V_CSV_TEXT_LIST = ''
    THEN
        V_SQL_TEXT := '';
    ELSIF P_COLUMN_NAME IS NULL
    THEN
        V_SQL_TEXT := '';
    /* -------------------------------------------------------------------------- */

    /* V_COLUMN_NAME := SUBSTR(P_COLUMN_NAME,INSTR(P_COLUMN_NAME,'[')+1,INSTR(P_COLUMN_NAME,']')-INSTR(P_COLUMN_NAME,'[')-1); */
    /* V_SQL_TEXT    := REPLACE(P_COLUMN_NAME,'['||V_COLUMN_NAME||']',SCM_GET_WHERE_SQL_FUNC(V_COLUMN_NAME,V_LOGICAL_OPERATOR,V_CSV_TEXT_LIST)); */
    /* V_SQL_TEXT    := 'AND ' || REPLACE(V_SQL_TEXT,'*','%'); */
    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR IN ('LK','LIKE')
    /* -------------------------------------------------------------------------- */
    THEN
        /* 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환 */
        IF P_CSV_TEXT_LIST = ''
        THEN
            RETURN '';
        END IF;

        V_SQL_TEXT   := CHR(10) || ' AND ( ';
        V_LIST_COUNT := 1;
        WHILE V_LIST_COUNT <= 1000
        LOOP
            /* -[dbo].[SCM_ARR_SPL_CNT] */
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, V_LIST_COUNT, ','));

            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_SQL_TEXT := V_SQL_TEXT || V_COLUMN_NAME;

                IF SUBSTR(V_CONDTION_VALUE, 1, 1) = '!'
                THEN
                    V_CONDTION_VALUE := SUBSTR(V_CONDTION_VALUE, 2, 2 * LENGTH(V_CONDTION_VALUE) - 1);
                    V_SQL_TEXT := V_SQL_TEXT || ' NOT LIKE N' || '''%' || TRIM(V_CONDTION_VALUE) || '%'' OR ';
                ELSE
                    V_CONDTION_VALUE := SUBSTR(V_CONDTION_VALUE, 1, 2 * LENGTH(V_CONDTION_VALUE));
                    V_SQL_TEXT := V_SQL_TEXT || ' LIKE N' || '''%' || TRIM(V_CONDTION_VALUE) || '%'' OR ';
                END IF;

                V_LIST_COUNT := V_LIST_COUNT + 1;
            END IF;
        END LOOP;

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(RTRIM(V_SQL_TEXT)) - 3) || ' ) ';

        /* 값목록이 한건밖에 없으면 바로 LIKE로만 처리 */
        IF V_COUNT = 1
        THEN
            IF SUBSTR(V_CSV_TEXT_LIST, 1, 1) = '!'
            THEN
                V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' NOT LIKE N' || '''%' || TRIM(SUBSTR(V_CSV_TEXT_LIST, 1, 2)) || '%'' ';
            ELSE
                V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' LIKE N' || '''%' || TRIM(V_CSV_TEXT_LIST) || '%'' ';
            END IF;
        END IF;

        /* 사용자가 * 로 WildCard입력시 %로 변환 */
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, '*', '%');

    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR IN ('NL','NOT LIKE')  /* NOT LIKE */
    /* -------------------------------------------------------------------------- */
    THEN
        /* 값목록이 복수개로 입력되면 AND (  col NOT LIKE v1 OR col NOT LIKE v2 ) 로변환 */
        IF P_CSV_TEXT_LIST = ''
        THEN
            RETURN '';
        END IF;

        V_SQL_TEXT   := CHR(10) || ' AND ( ';
        V_LIST_COUNT := 1;
        WHILE V_LIST_COUNT <= 1000
        LOOP
            /* -[dbo].[SCM_ARR_SPL_CNT] */
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, V_LIST_COUNT, ','));

            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_SQL_TEXT := V_SQL_TEXT || V_COLUMN_NAME;

                V_CONDTION_VALUE := SUBSTR(V_CONDTION_VALUE, 1, 2 * LENGTH(V_CONDTION_VALUE));
                V_SQL_TEXT := V_SQL_TEXT || ' NOT LIKE N' || '''%' || TRIM(V_CONDTION_VALUE) || '%'' OR ';

                V_LIST_COUNT := V_LIST_COUNT + 1;
            END IF;
        END LOOP;

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(RTRIM(V_SQL_TEXT)) - 3) || ' ) ';

        /* 값목록이 한건밖에 없으면 바로 NOT LIKE로만 처리 */
        IF V_COUNT = 1
        THEN
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' NOT LIKE N' || '''%' || TRIM(V_CSV_TEXT_LIST) || '%'' ';
        END IF;

        /* 사용자가 * 로 WildCard입력시 %로 변환 */
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, '*', '%');

    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR IN ('EQ','EQUAL','IN')
    /* -------------------------------------------------------------------------- */
    THEN
        /* 값목록이 복수개로 입력되면 IN ( v1, v2 , v3, v4 ) 로변환 */
        IF SUBSTR(V_CSV_TEXT_LIST, 1, 1) = '!'
        THEN
            V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' NOT IN (';
        ELSE
            V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' IN (';
        END IF;

        V_I := 1;
        WHILE V_I <= 1000
        LOOP
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(REPLACE(V_CSV_TEXT_LIST, '!', ''), V_I, ','));
            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_SQL_TEXT := V_SQL_TEXT || 'N''' || V_CONDTION_VALUE || ''',';
                V_I := V_I + 1;
            END IF;
        END LOOP;

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(RTRIM(V_SQL_TEXT)) - 1) || ') ';
        RETURN V_SQL_TEXT;
        /* 원본 quirk: 위 RETURN(원본 SCMPROD의 활성 return @v_sql_text)으로 아래 단건 EQUAL 처리 도달불가 그대로 보존 */
        /* 값목록이 한건밖에 없으면 바로 EQUAL 로만 처리 */
        V_CSV_TEXT_LIST := TRIM(REPLACE(V_CSV_TEXT_LIST, '*', '%'));
        IF V_COUNT = 1
        THEN
            IF SUBSTR(V_CSV_TEXT_LIST, 1, 1) = '!'
            THEN
                IF SUBSTR(V_CSV_TEXT_LIST, -1, 1) = '%'
                THEN
                    V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' NOT LIKE N' || '''%' || TRIM(SUBSTR(V_CSV_TEXT_LIST, 1, 2)) || '%'' ';
                ELSE
                    V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' != N' || '''' || TRIM(SUBSTR(V_CSV_TEXT_LIST, 1, 2)) || ''' ';
                END IF;
            ELSE
                IF SUBSTR(V_CSV_TEXT_LIST, -1, 1) = '%'
                THEN
                    V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' LIKE N' || '''%' || TRIM(V_CSV_TEXT_LIST) || '%'' ';
                ELSE
                    V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' = N' || '''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
                END IF;
            END IF;
        END IF;

    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR IN ('NE','NOT EQUAL','NI','NOT IN')
    /* -------------------------------------------------------------------------- */
    THEN
        /* 값목록이 복수개로 입력되면 NOT IN ( v1, v2 , v3, v4 ) 로변환 */
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' NOT IN (';
        V_I := 1;
        WHILE V_I <= 1000
        LOOP
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, V_I, ','));
            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_SQL_TEXT := V_SQL_TEXT || 'N''' || V_CONDTION_VALUE || ''',';
                V_I := V_I + 1;
            END IF;
        END LOOP;
        /* 값목록이 한건밖에 없으면 바로 NOT EQUAL 로만 처리 */
        /* 원본 DATALENGTH(@v_sql_text)-1 = 2*LENGTH-1 (NVARCHAR 바이트수) 그대로 보존 */
        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, 2 * LENGTH(V_SQL_TEXT) - 1) || ') ';
        IF V_COUNT = 1
        THEN
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' != N' || '''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
        END IF;

    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR IN ('BW','BETWEEN')
    /* -------------------------------------------------------------------------- */
    THEN
        /* 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환 */
        V_SQL_TEXT := CHR(10) || ' AND ( ';
        V_I := 1;
        WHILE V_I <= 1000
        LOOP
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, V_I, ','));
            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_1ST_NODE := TRIM(FN_SCM_SPLIT(V_CONDTION_VALUE, 1, ':'));
                V_2ND_NODE := TRIM(FN_SCM_SPLIT(V_CONDTION_VALUE, 2, ':'));
                V_SQL_TEXT := V_SQL_TEXT || ' ( ' || P_COLUMN_NAME || ' BETWEEN ''' || V_1ST_NODE
                                         || ''' AND ''' || NVL(V_2ND_NODE, V_1ST_NODE)
                                         || ''' ) OR ';
                V_I := V_I + 1;
            END IF;
        END LOOP;

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(RTRIM(V_SQL_TEXT)) - 3) || ' ) ';
        /* 값목록이 한건밖에 없으면 바로 LIKE로만 처리 */
        IF V_COUNT = 1
        THEN

            V_1ST_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, ':', 1));
            V_2ND_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, ':', 2));
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' BETWEEN ''' || V_1ST_NODE
                                   || ''' AND ''' || NVL(V_2ND_NODE, V_1ST_NODE)
                                   || ''' ';
        END IF;

    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR IN ('BD','BETWEEN DATE')
    /* -------------------------------------------------------------------------- */
    THEN
        /* 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환 */

        V_SQL_TEXT := CHR(10) || ' AND ( ';
        WHILE V_I <= 1000
        LOOP
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, ',', V_I));
            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_1ST_NODE := TRIM(FN_SCM_SPLIT(V_CONDTION_VALUE, 1, ':'));
                V_2ND_NODE := TRIM(FN_SCM_SPLIT(V_CONDTION_VALUE, 2, ':'));
                V_SQL_TEXT := V_SQL_TEXT || ' ( ' || P_COLUMN_NAME || ' BETWEEN CONVERT(CHAR(8)''' || V_1ST_NODE || ''',112) '
                                         || ' AND     CONVERT(CHAR(8)''' || NVL(V_2ND_NODE, V_1ST_NODE) || ''',112) + 86399/86400 '
                                         || ') OR ';
            END IF;
        END LOOP;
        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, 2 * LENGTH(V_SQL_TEXT) - 3) || ' ) ';
        /* 값목록이 한건밖에 없으면 바로 LIKE로만 처리 */
        IF V_COUNT = 1
        THEN
            V_1ST_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 1, ':'));
            V_2ND_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':'));
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' BETWEEN CONVERT(CHAR(8)''' || V_1ST_NODE || ''',''YYYYMMDD'') '
                                   || ' AND CONVERT(CHAR(8)''' || NVL(V_2ND_NODE, V_1ST_NODE) || ''',''YYYYMMDD'') + 86399/86400';
        END IF;

    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR IN ('BM','BETWEEN MONTH')
    /* -------------------------------------------------------------------------- */
    THEN
        /* 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환 */

        V_SQL_TEXT := CHR(10) || ' AND ( ';
        WHILE V_I <= 1000
        LOOP
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, V_I, ','));
            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_1ST_NODE := TRIM(FN_SCM_SPLIT(V_CONDTION_VALUE, 1, ':'));
                V_2ND_NODE := TRIM(FN_SCM_SPLIT(V_CONDTION_VALUE, 2, ':'));
                V_SQL_TEXT := V_SQL_TEXT || ' ( ' || P_COLUMN_NAME || ' BETWEEN CONVERT(CHAR(6)''' || V_1ST_NODE || ''',112) '
                                         || ' AND CONVERT(CHAR(6), DATEADD(MM, 1,''' || NVL(V_2ND_NODE, V_1ST_NODE) || ''',112),1) - 1/86400 '
                                         || ') OR ';
            END IF;
        END LOOP;

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, 2 * LENGTH(V_SQL_TEXT) - 3) || ' ) ';
        /* 값목록이 한건밖에 없으면 바로 LIKE로만 처리 */
        IF V_COUNT = 1
        THEN
            V_1ST_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 1, ':'));
            V_2ND_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':'));
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' BETWEEN TO_DATE(''' || V_1ST_NODE || ''',112) '
                                   || ' AND ADD_MONTHS(TO_DATE(''' || NVL(V_2ND_NODE, V_1ST_NODE) || ''',112),1) - 1/86400 ';
        END IF;

    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR = 'GT'
    /* -------------------------------------------------------------------------- */
    THEN
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' > ''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR = 'GE'
    /* -------------------------------------------------------------------------- */
    THEN
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' >= ''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR = 'LT'
    /* -------------------------------------------------------------------------- */
    THEN
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' < ''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR = 'LE'
    /* -------------------------------------------------------------------------- */
    THEN
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' <= ''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
    /* -------------------------------------------------------------------------- */
    ELSIF V_LOGICAL_OPERATOR = 'CK'   /* CheckBox for Y Only */
    /* -------------------------------------------------------------------------- */
    THEN
        IF TRIM(V_CSV_TEXT_LIST) = 'Y'
        THEN
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' = ''Y'' ';
        END IF;
    /* -------------------------------------------------------------------------- */
    ELSE
    /* -------------------------------------------------------------------------- */
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' LIKE ''%' || TRIM(V_CSV_TEXT_LIST) || '%'' ';
        /* 사용자가 * 로 WildCard입력시 %로 변환 */
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, '*', '%');
    END IF;

    /* -------------------------------------------------------------------------- */
    RETURN V_SQL_TEXT;
    /* -------------------------------------------------------------------------- */

END;
/
