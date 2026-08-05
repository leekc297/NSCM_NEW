FUNCTION         FN_SCM_GET_WHERE_SQL

(
    P_COLUMN_NAME           IN VARCHAR2,
    P_LOGICAL_OPERATOR_CODE IN VARCHAR2,
    P_CSV_TEXT_LIST         IN VARCHAR2
)
RETURN VARCHAR2
/*
 * Program ID   : FN_SCM_GET_WHERE_SQL
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/20  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.12   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
*/

--ALTER FUNCTION [dbo].[SCM_ARR_SPL_VAL]
--(
-- @sText		NVARCHAR(max),			-- 대상 문자열
-- @str		NVARCHAR(1) = '|',		-- 구분기호(Default '|')
-- @idx		INT                     -- 배열 인덱스
--)
--RETURNS NVARCHAR(100)
--AS

--BEGIN
-- DECLARE @word    NVARCHAR(1000);		-- 반환할 문자
-- DECLARE @sTextData  NVARCHAR(max);
-- DECLARE @num    INT;

-- ~~~~~~~~

-- RETURN(@word);
--END
--;
IS
    V_CSV_TEXT_LIST    VARCHAR2(32767 CHAR); --:= REPLACE(REPLACE(p_csv_text_list,CHR(13),''),CHR(10),',');
    V_LOGICAL_OPERATOR VARCHAR2(100 CHAR);   --:= NVL(UPPER(p_logical_operator_code),'LK');
    V_CONDTION_VALUE   VARCHAR2(100 CHAR);
    V_COLUMN_NAME      VARCHAR2(1000 CHAR);  --:= TRIM(SCM_SPLIT_FUNC(p_column_name,1,':'));
    V_SQL_TEXT         VARCHAR2(32767 CHAR);
    V_COUNT            PLS_INTEGER := 0;
    V_LIST_COUNT       PLS_INTEGER := 0;
    V_1ST_NODE         VARCHAR2(4000 CHAR);
    V_2ND_NODE         VARCHAR2(4000 CHAR);
    V_I                PLS_INTEGER := 0;
BEGIN
    V_CSV_TEXT_LIST    := REPLACE(REPLACE(P_CSV_TEXT_LIST, CHR(13), ''), CHR(10), ',');
    V_LOGICAL_OPERATOR := NVL(UPPER(P_LOGICAL_OPERATOR_CODE), 'LK');
    V_COLUMN_NAME      := TRIM(SCM_ARR_SPL_VAL(P_COLUMN_NAME, ':', 1));
    V_SQL_TEXT         := '';
    V_LIST_COUNT       := 0;

    ----------------------------------------------------------------------------
    -- CheckedListFilter : (!)value1,valu2...(:LK)
    -- MonthRangePicker, DateRangePicker : '20171201:20171231' 형식이므로 제외
    -- ComboColumn : column_name:value
    ----------------------------------------------------------------------------

    IF INSTR(V_CSV_TEXT_LIST, ':') > 0 AND V_LOGICAL_OPERATOR NOT IN ('BW','BETWEEN','BD','BETWEN DATE','BM','BETWEEN MONTH')
    THEN
        IF TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':')) = 'LK'
        THEN
            -- CheckedListFilter : Like 검색
            V_LOGICAL_OPERATOR := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':'));
            V_CSV_TEXT_LIST    := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 1, ':'));

            -- CheckedListFilter : 'end_customer_code:end_customer_name'
            IF INSTR(P_COLUMN_NAME, ':') > 0
            THEN
                V_COLUMN_NAME := TRIM(FN_SCM_SPLIT(P_COLUMN_NAME, 2, ':'));
            END IF;
        ELSE
            -- ComboColumn : column_name:value --2017.12.20
            V_COLUMN_NAME   := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 1, ':'));
            V_CSV_TEXT_LIST := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':'));
        END IF;
    END IF;

    ----------------------------------------------------------------------------
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

    --v_sql_text := '3333';

    ----------------------------------------------------------------------------
    IF NVL(V_CSV_TEXT_LIST, 'ALL') = 'ALL'
    THEN
        V_SQL_TEXT := '';
    ----------------------------------------------------------------------------
    ELSIF V_CSV_TEXT_LIST = ''
    THEN
        V_SQL_TEXT := '';
    ELSIF P_COLUMN_NAME IS NULL
    THEN
        V_SQL_TEXT := '';
    ----------------------------------------------------------------------------
    --ELSIF INSTR(p_column_name,'[') < INSTR(p_column_name,']')
    --THEN
    --    v_column_name := SUBSTR(p_column_name,INSTR(p_column_name,'[')+1,INSTR(p_column_name,']')-INSTR(p_column_name,'[')-1);
    --    v_sql_text    := REPLACE(p_column_name,'['||v_column_name||']',SCM_GET_WHERE_SQL_FUNC(v_column_name,v_logical_operator,v_csv_text_list));
    --    v_sql_text    := 'AND ' || REPLACE(v_sql_text,'*','%');
    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR IN ('LK','LIKE')
    THEN
    ----------------------------------------------------------------------------
        -- 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환
        IF P_CSV_TEXT_LIST = ''
        THEN
            RETURN '';
        END IF;

        V_SQL_TEXT   := CHR(10) || ' AND ( ';
        V_LIST_COUNT := 1;
        V_COUNT      := 0;
        --v_i := 0;
        WHILE V_LIST_COUNT <= 1000
        LOOP
            ---[dbo].[SCM_ARR_SPL_CNT]
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, V_LIST_COUNT, ','));

            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_SQL_TEXT := V_SQL_TEXT || V_COLUMN_NAME;

                IF SUBSTR(V_CONDTION_VALUE, 1, 1) = '!'
                THEN
                    V_CONDTION_VALUE := SUBSTR(V_CONDTION_VALUE, 2);
                    V_SQL_TEXT := V_SQL_TEXT || ' NOT LIKE ' || '''%' || TRIM(V_CONDTION_VALUE) || '%'' OR ';
                ELSE
                    V_SQL_TEXT := V_SQL_TEXT || ' LIKE ' || '''%' || TRIM(V_CONDTION_VALUE) || '%'' OR ';
                END IF;

                V_LIST_COUNT := V_LIST_COUNT + 1;
            END IF;
        END LOOP;

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(RTRIM(V_SQL_TEXT)) - 3) || ' ) ';

        -- 값목록이 한건밖에 없으면 바로 LIKE로만 처리
        IF V_COUNT = 1
        THEN
            IF SUBSTR(V_CSV_TEXT_LIST, 1, 1) = '!'
            THEN
                V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' NOT LIKE ' || '''%' || TRIM(SUBSTR(V_CSV_TEXT_LIST, 2)) || '%'' ';
            ELSE
                V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' LIKE ' || '''%' || TRIM(V_CSV_TEXT_LIST) || '%'' ';
            END IF;
        END IF;

        -- 사용자가 * 로 WildCard입력시 %로 변환
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, '*', '%');

    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR IN ('NL','NOT LIKE')  -- NOT LIKE
    THEN
    ----------------------------------------------------------------------------
        -- 값목록이 복수개로 입력되면 AND (  col NOT LIKE v1 OR col NOT LIKE v2 ) 로변환
        IF P_CSV_TEXT_LIST = ''
        THEN
            RETURN '';
        END IF;

        V_SQL_TEXT   := CHR(10) || ' AND ( ';
        V_LIST_COUNT := 1;
        V_COUNT      := 0;
        --v_i := 0;
        WHILE V_LIST_COUNT <= 1000
        LOOP
            ---[dbo].[SCM_ARR_SPL_CNT]
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, V_LIST_COUNT, ','));

            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_SQL_TEXT := V_SQL_TEXT || V_COLUMN_NAME;

                V_SQL_TEXT := V_SQL_TEXT || ' NOT LIKE ' || '''%' || TRIM(V_CONDTION_VALUE) || '%'' OR ';

                V_LIST_COUNT := V_LIST_COUNT + 1;
            END IF;
        END LOOP;

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(V_SQL_TEXT) - 3) || ' ) ';

        -- 값목록이 한건밖에 없으면 바로 NOT LIKE로만 처리
        IF V_COUNT = 1
        THEN
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' NOT LIKE ' || '''%' || TRIM(V_CSV_TEXT_LIST) || '%'' ';
        END IF;

        -- 사용자가 * 로 WildCard입력시 %로 변환
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, '*', '%');

    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR IN ('EQ','EQUAL','IN')
    THEN
    ----------------------------------------------------------------------------
        -- 값목록이 복수개로 입력되면 IN ( v1, v2 , v3, v4 ) 로변환
        IF SUBSTR(V_CSV_TEXT_LIST, 1, 1) = '!'
        THEN
            V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' NOT IN (';
        ELSE
            V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' IN (';
        END IF;

        V_I     := 1;
        V_COUNT := 0;
        WHILE V_I <= 1000
        LOOP
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(REPLACE(V_CSV_TEXT_LIST, '!', ''), V_I, ','));
            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_SQL_TEXT := V_SQL_TEXT || '''' || V_CONDTION_VALUE || ''',';
                V_I := V_I + 1;
            END IF;
        END LOOP;

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(V_SQL_TEXT) - 1) || ') ';
        RETURN V_SQL_TEXT;

        -- 값목록이 한건밖에 없으면 바로 EQUAL 로만 처리
        V_CSV_TEXT_LIST := TRIM(REPLACE(V_CSV_TEXT_LIST, '*', '%'));
        IF V_COUNT = 1
        THEN
            IF SUBSTR(V_CSV_TEXT_LIST, 1, 1) = '!'
            THEN
                IF SUBSTR(V_CSV_TEXT_LIST, -1, 1) = '%'
                THEN
                    V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' NOT LIKE ' || '''%' || TRIM(SUBSTR(V_CSV_TEXT_LIST, 2)) || '%'' ';
                ELSE
                    V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' != ' || '''' || TRIM(SUBSTR(V_CSV_TEXT_LIST, 2)) || ''' ';
                END IF;
            ELSE
                IF SUBSTR(V_CSV_TEXT_LIST, -1, 1) = '%'
                THEN
                    V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' LIKE ' || '''%' || TRIM(V_CSV_TEXT_LIST) || '%'' ';
                ELSE
                    V_SQL_TEXT := CHR(10) || ' AND ' || V_COLUMN_NAME || ' = ' || '''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
                END IF;
            END IF;
        END IF;

    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR IN ('NE','NOT EQUAL','NI','NOT IN')
    THEN
    ----------------------------------------------------------------------------
        -- 값목록이 복수개로 입력되면 NOT IN ( v1, v2 , v3, v4 ) 로변환
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' NOT IN (';
        V_I     := 1;
        V_COUNT := 0;
        WHILE V_I <= 1000
        LOOP
            V_CONDTION_VALUE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, V_I, ','));
            IF V_CONDTION_VALUE IS NULL
            THEN
                EXIT;
            ELSE
                V_COUNT    := V_COUNT + 1;
                V_SQL_TEXT := V_SQL_TEXT || '''' || V_CONDTION_VALUE || ''',';
                V_I := V_I + 1;
            END IF;
        END LOOP;

        -- 값목록이 한건밖에 없으면 바로 NOT EQUAL 로만 처리
        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(V_SQL_TEXT) - 1) || ') ';
        IF V_COUNT = 1
        THEN
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' != ' || '''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
        END IF;

    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR IN ('BW','BETWEEN')
    THEN
    ----------------------------------------------------------------------------
        -- 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환
        V_SQL_TEXT := CHR(10) || ' AND ( ';
        V_I     := 1;
        V_COUNT := 0;
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

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(V_SQL_TEXT) - 3) || ' ) ';

        -- 값목록이 한건밖에 없으면 바로 LIKE로만 처리
        IF V_COUNT = 1
        THEN
            V_1ST_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 1, ':'));
            V_2ND_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':'));
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' BETWEEN ''' || V_1ST_NODE
                                   || ''' AND ''' || NVL(V_2ND_NODE, V_1ST_NODE)
                                   || ''' ';
        END IF;

    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR IN ('BD','BETWEEN DATE')
    THEN
    ----------------------------------------------------------------------------
        -- 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환
        V_SQL_TEXT := CHR(10) || ' AND ( ';
        V_I     := 1;
        V_COUNT := 0;
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
                V_SQL_TEXT := V_SQL_TEXT || ' ( ' || P_COLUMN_NAME
                           || ' BETWEEN TO_DATE(''' || V_1ST_NODE || ''', ''YYYYMMDD'')'
                           || ' AND TO_DATE(''' || NVL(V_2ND_NODE, V_1ST_NODE) || ''', ''YYYYMMDD'') + 86399/86400'
                           || ' ) OR ';
                V_I := V_I + 1;
            END IF;
        END LOOP;

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(V_SQL_TEXT) - 3) || ' ) ';

        -- 값목록이 한건밖에 없으면 바로 LIKE로만 처리
        IF V_COUNT = 1
        THEN
            V_1ST_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 1, ':'));
            V_2ND_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':'));
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME
                       || ' BETWEEN TO_DATE(''' || V_1ST_NODE || ''', ''YYYYMMDD'')'
                       || ' AND TO_DATE(''' || NVL(V_2ND_NODE, V_1ST_NODE) || ''', ''YYYYMMDD'') + 86399/86400';
        END IF;

    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR IN ('BM','BETWEEN MONTH')
    THEN
    ----------------------------------------------------------------------------
        -- 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환
        V_SQL_TEXT := CHR(10) || ' AND ( ';
        V_I     := 1;
        V_COUNT := 0;
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
                V_SQL_TEXT := V_SQL_TEXT || ' ( ' || P_COLUMN_NAME
                           || ' BETWEEN TO_DATE(''' || V_1ST_NODE || ''', ''YYYYMM'')'
                           || ' AND ADD_MONTHS(TO_DATE(''' || NVL(V_2ND_NODE, V_1ST_NODE) || ''', ''YYYYMM''), 1) - 1/86400'
                           || ' ) OR ';
                V_I := V_I + 1;
            END IF;
        END LOOP;

        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, LENGTH(V_SQL_TEXT) - 3) || ' ) ';

        -- 값목록이 한건밖에 없으면 바로 LIKE로만 처리
        IF V_COUNT = 1
        THEN

            V_1ST_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 1, ':'));
            V_2ND_NODE := TRIM(FN_SCM_SPLIT(V_CSV_TEXT_LIST, 2, ':'));

            -- 03/09
            --v_1st_node := TRIM(REGEXP_SUBSTR(v_csv_text_list, '[^:]+', 1, 1));
            --v_2nd_node := TRIM(REGEXP_SUBSTR(v_csv_text_list, '[^:]+', 1, 2));

            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME
                       || ' BETWEEN TO_DATE(''' || V_1ST_NODE || ''', ''YYYYMM'')'
                       || ' AND ADD_MONTHS(TO_DATE(''' || NVL(V_2ND_NODE, V_1ST_NODE) || ''', ''YYYYMM''), 1) - 1/86400';
        END IF;

    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR = 'GT'
    THEN
    ----------------------------------------------------------------------------
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' > ''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR = 'GE'
    THEN
    ----------------------------------------------------------------------------
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' >= ''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR = 'LT'
    THEN
    ----------------------------------------------------------------------------
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' < ''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR = 'LE'
    THEN
    ----------------------------------------------------------------------------
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' <= ''' || TRIM(V_CSV_TEXT_LIST) || ''' ';
    ----------------------------------------------------------------------------
    ELSIF V_LOGICAL_OPERATOR = 'CK'   -- CheckBox for Y Only
    THEN
    ----------------------------------------------------------------------------
        IF TRIM(V_CSV_TEXT_LIST) = 'Y'
        THEN
            V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' = ''Y'' ';
        END IF;
    ----------------------------------------------------------------------------
    ELSE
    ----------------------------------------------------------------------------
        V_SQL_TEXT := CHR(10) || ' AND ' || P_COLUMN_NAME || ' LIKE ''%' || TRIM(V_CSV_TEXT_LIST) || '%'' ';
        -- 사용자가 * 로 WildCard입력시 %로 변환
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, '*', '%');
    END IF;

    ----------------------------------------------------------------------------
    RETURN V_SQL_TEXT;
    ----------------------------------------------------------------------------

END FN_SCM_GET_WHERE_SQL;