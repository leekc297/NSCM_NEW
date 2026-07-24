
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0082_GET_EXCEL_UPLOAD_DATA" 
(
    p_created_by     IN  VARCHAR2
  , O_RC1            OUT SYS_REFCURSOR   /* 최종 일자별 수량 (RECORD 형식) */
  , O_RC2            OUT SYS_REFCURSOR   /* 최종 일자별 수량 (PIVOT 형식 — 동적 D 컬럼) */
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR   /* 표준 결과 커서 (RESULT_CODE/RESULT_MSG/EVENT) */
)
/*=====================================================================================================================================================
 * Program ID  : DMF0082_GET_EXCEL_UPLOAD_DATA
 * Description : Fcst&Price MGMT 화면에서 Excel Upload로 MKT FCST, LOC 메저를 월별로 업로드 한 후, Daily 로 풀어서 보여주는 프로시저
 *                추후 Main 화면을 저장하는 프로시저 (DMF0082_SAVE_MAIN_DATA)를 호출하여 저장함.
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date         In Charge    Description
 *=====================================================================================================================================================
 * 2025.05.xx   KJY          최초 작성 (MSSQL)
 * 2026-07-12   Claude       MSSQL dbo.DMF0082_GET_EXCEL_UPLOAD_DATA → Oracle 19c 1:1 변환 (파일 산출물 — DB 미적용)
 *=====================================================================================================================================================
 * [변환 노트 — 부록 C 함정 처리]
 *  - #temp 5종 → GTT 5종 (00_gtt_ddl.sql 신규: GT_DMF0082_FCST_PRICE_*). GTT 초기화 = DELETE FROM (C-2 TRUNCATE 금지 / C-5 INSERT 전 DELETE)
 *  - MSSQL 마지막 SELECT 2개(RECORD/PIVOT) → O_RC1/O_RC2, 표준 O_RESULT_CURSOR 추가 (DMF0082_SAVE_MAIN_DATA Oracle 표준 준수)
 *  - CONVERT(NVARCHAR(40), CREATION_DATE, 121) → TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3') 명시 마스크 (C-11 NLS)
 *  - FORMAT(DATEADD(MONTH,n,GETDATE()),'yyyyMM') → TO_CHAR(ADD_MONTHS(SYSDATE,n),'YYYYMM') 명시 마스크 (C-11)
 *  - UNPIVOT: MSSQL 은 ''(빈문자열) 행 유지 + IIF 로 0 처리 / Oracle 은 '' = NULL 이므로 UNPIVOT INCLUDE NULLS + NVL(QTY,'0') 로 동등화 (C-7)
 *  - IIF(ISNULL(QTY,'')='','0',QTY) → NVL(A.QTY,'0') (C-7)
 *  - CONVERT(NUMERIC(23,2), x) → CAST(TO_NUMBER(x) AS NUMBER(23,2)) — 변환 실패 시 MSSQL 과 동일하게 에러 발생(silent 무시 금지)
 *  - EOMONTH → LAST_DAY / FORMAT(...,'dd') → TO_CHAR(...,'DD') 명시 마스크
 *  - '' AS LAST_DAY_YN → NULL (C-7, Oracle 에서 '' = NULL)
 *  - 동적 PIVOT IN 리스트 = CLOB + 커서 LOOP(FETCH 직후 EXIT WHEN %NOTFOUND — C-10) (hook #106 CLOB)
 *  - SP_EXECUTESQL → OPEN O_RC2 FOR V_SQL(CLOB)
 *  - MSSQL PRINT → DBMS_OUTPUT.PUT_LINE (SQL 원문 4000자 분할 PRINT 루프 포함 1:1 유지)
 *  - WITH (NOLOCK) 제거 / [bracket] 제거 / dbo. 제거 / TOP 1 → FETCH FIRST 1 ROWS ONLY
 *  - #FCST_PRICE_DAILY 의 BC 서브쿼리 DIVISION_ID = '40' 하드코딩은 AS-IS 원문 그대로 보존 (임의 수정 금지)
 *===================================================================================================================================================*/
IS
    v_program_id     VARCHAR2(40 CHAR)  := 'DMF0082';
    v_sheet_name     VARCHAR2(40 CHAR)  := 'FcstNPrice';
    v_creation_date  VARCHAR2(40 CHAR);
    v_start_yyyymm   VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 4), 'YYYYMM');
    v_end_yyyymm     VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 16), 'YYYYMM');
    v_division       VARCHAR2(10 CHAR);
    v_defaultLocBucketDay VARCHAR2(10 CHAR);

    /* 동적 PIVOT 변수 (hook #106 — 대량 문자열 누적 = CLOB) */
    V_CONCAT_PIVOT   CLOB;              /* PIVOT IN 절: 'D20260101' AS D20260101, ... */
    V_SQL            CLOB;
    V_PIVOT_PIECE    VARCHAR2(100 CHAR);
    V_PRINT_POS      PLS_INTEGER;
    V_PRINT_LEN      PLS_INTEGER;

    /* 표준 예외/로그 변수 */
    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(20 CHAR);
    V_SQL_ERRMSG     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);

    /* C_PIVOT : 조회구간 일자별 동적 PIVOT 컬럼 커서 */
    CURSOR C_PIVOT IS
        SELECT 'D' || A.BASIS_YYYYMMDD AS PV_KEY
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  1 = 1
        AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
        ORDER BY A.BASIS_YYYYMMDD;

BEGIN

    V_PROC_INPUT := JSON_OBJECT('p_created_by' VALUE p_created_by);

    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
    INTO   v_creation_date
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = v_program_id
    AND    T.SHEET_NAME = v_sheet_name
    AND    T.CREATED_BY = p_created_by;

    IF v_creation_date IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('NO EXCEL DATA');   /* AS-IS: PRINT 'NO EXCEL DATA' (실행은 계속) */
    END IF;

    ----------------------------------------------------------------------------------------------------
    -- GTT 초기화 (AS-IS: IF OBJECT_ID ... DROP TABLE — Oracle: DELETE FROM, C-2/C-5)
    ----------------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY;

    ----------------------------------------------------------------------------------------------------
    --Excel Data
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , END_CUSTOMER_NAME, SCM_SITE_ID_NAME, FCST_TYPE_NAME, CELL_PROD_SITE_NAME, MEASURE_NAME
    , M4, M5, M6, M7, M8, M9, M10, M11, M12, M13, M14, M15, M16)
    SELECT A.ATTRIBUTE301 AS DIVISION_ID
         , A.ATTRIBUTE302 AS END_CUSTOMER
         , A.ATTRIBUTE303 AS SCM_SITE_ID
         , A.ATTRIBUTE304 AS ITEM_ID
         , A.ATTRIBUTE305 AS INCOTERMS
         , A.ATTRIBUTE306 AS FCST_TYPE
         , A.ATTRIBUTE307 AS DOM_EXP
         , A.ATTRIBUTE308 AS CELL_PROD_SITE
         , A.ATTRIBUTE309 AS CURRENCY
         , A.ATTRIBUTE310 AS MEASURE
         , A.ATTRIBUTE2   AS END_CUSTOMER_NAME
         , A.ATTRIBUTE3   AS SCM_SITE_ID_NAME
         , A.ATTRIBUTE6   AS FCST_TYPE_NAME
         , A.ATTRIBUTE8   AS CELL_PROD_SITE_NAME
         , A.ATTRIBUTE10  AS MEASURE_NAME
         , A.ATTRIBUTE11  AS M4
         , A.ATTRIBUTE12  AS M5
         , A.ATTRIBUTE13  AS M6
         , A.ATTRIBUTE14  AS M7
         , A.ATTRIBUTE15  AS M8
         , A.ATTRIBUTE16  AS M9
         , A.ATTRIBUTE17  AS M10
         , A.ATTRIBUTE18  AS M11
         , A.ATTRIBUTE19  AS M12
         , A.ATTRIBUTE20  AS M13
         , A.ATTRIBUTE21  AS M14
         , A.ATTRIBUTE22  AS M15
         , A.ATTRIBUTE23  AS M16
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
    WHERE  1 = 1
    AND    A.PROGRAM_ID = v_program_id
    AND    A.SHEET_NAME = v_sheet_name
    AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    A.UPLOAD_STATUS_CODE = 'SUCCESS';

    /* SELECT TOP 1 @v_division = DIVISION_ID FROM #FCST_PRICE_EXCEL */
    BEGIN
        SELECT DIVISION_ID
        INTO   v_division
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL
        FETCH FIRST 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_division := NULL;
    END;

    --LOC메저 기본 버킷 요일
    v_defaultLocBucketDay := 'MON';

    ----------------------------------------------------------------------------------------------------
    --Unpivot
    -- (C-7) MSSQL UNPIVOT 은 ''(빈문자열) 셀 행을 유지하고 IIF 로 0 처리.
    --       Oracle 은 '' = NULL 이므로 INCLUDE NULLS + NVL(QTY,'0') 로 동일 결과 보장.
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , END_CUSTOMER_NAME, SCM_SITE_ID_NAME, FCST_TYPE_NAME, CELL_PROD_SITE_NAME, MEASURE_NAME
    , KEY_VALUE, YYYYMM, QTY)
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.END_CUSTOMER_NAME
         , A.SCM_SITE_ID_NAME
         , A.FCST_TYPE_NAME
         , A.CELL_PROD_SITE_NAME
         , A.MEASURE_NAME
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM AS YYYYMM
         , A.QTY
    FROM  (SELECT A.DIVISION_ID
                , A.END_CUSTOMER
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.INCOTERMS
                , A.FCST_TYPE
                , A.DOM_EXP
                , A.CELL_PROD_SITE
                , A.CURRENCY
                , A.MEASURE
                , A.END_CUSTOMER_NAME
                , A.SCM_SITE_ID_NAME
                , A.FCST_TYPE_NAME
                , A.CELL_PROD_SITE_NAME
                , A.MEASURE_NAME
                , A.DIVISION_ID || A.END_CUSTOMER || A.SCM_SITE_ID || A.ITEM_ID || A.INCOTERMS
                  || A.FCST_TYPE || A.DOM_EXP || A.CELL_PROD_SITE || A.CURRENCY || A.MEASURE AS KEY_VALUE
                , A.YYYYMM
                /* CONVERT(NUMERIC(23,2), IIF(ISNULL(A.QTY,'')='', '0', A.QTY)) */
                , CAST(TO_NUMBER(NVL(A.QTY, '0')) AS NUMBER(23,2)) AS QTY
           /* Oracle UNPIVOT: 테이블과 UNPIVOT 사이 alias 불가 → alias 는 UNPIVOT 결과에 부여 */
           FROM  SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL
           UNPIVOT INCLUDE NULLS (QTY FOR YYYYMM IN
                 ( M4  AS 'M4',  M5  AS 'M5',  M6  AS 'M6',  M7  AS 'M7'
                 , M8  AS 'M8',  M9  AS 'M9',  M10 AS 'M10', M11 AS 'M11'
                 , M12 AS 'M12', M13 AS 'M13', M14 AS 'M14', M15 AS 'M15', M16 AS 'M16')) A
          ) A
    JOIN  (SELECT DISTINCT A.BASIS_YYYYMM
                , 'M' || TO_CHAR(DENSE_RANK() OVER (ORDER BY A.BASIS_YYYYMM) + 3) AS RN
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm) CM
      ON  (CM.RN = A.YYYYMM);

    ----------------------------------------------------------------------------------------------------
    --[MKT_FCST]
    --BUCKET 이 포함된 주차(=월별 수량을 나눠야할 대상 주차)
    --SCM_SITE_ID/INCOTERMS별 BUCKET 이 정해진 대상우선 INSERT
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , KEY_VALUE, BASIS_YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW)
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM
         , CM.BASIS_YYYYMMDD
         , CM.ISO_YYYYWW
    FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
    JOIN  (SELECT A.BASIS_YYYYMM
                , A.BASIS_YYYYMMDD
                , A.ISO_YYYYWW
                , A.DAYOFWEEK
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
          ) CM
      ON  (A.YYYYMM = CM.BASIS_YYYYMM)
    JOIN  (SELECT BC.DIVISION_ID
                , BC.SCM_SITE_ID
                , BC.INCOTERMS
                , BC.BUCKET_PER
                , BC.YYYYMMDD
                , COUNT(BC.BUCKET_PER) OVER (PARTITION BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS) AS BUCKET_CNT
           FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION BC
           WHERE  1 = 1
           AND    BC.DIVISION_ID = v_division) BC
      ON  (BC.DIVISION_ID = A.DIVISION_ID
     AND   BC.SCM_SITE_ID = A.SCM_SITE_ID
     AND   BC.INCOTERMS   = A.INCOTERMS
     AND   BC.YYYYMMDD    = CM.DAYOFWEEK
     AND   BC.BUCKET_PER  = 'Y')
    WHERE  1 = 1
    AND    A.MEASURE = 'MKT_FCST'

    UNION ALL

    --DEFAULT BUCKET INSERT (SCM_SITE_ID/INCOTERMS별 BUCKET 이 없는 대상 기준)
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM
         , CM.BASIS_YYYYMMDD
         , CM.ISO_YYYYWW
    FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
    JOIN  (SELECT A.BASIS_YYYYMM
                , A.BASIS_YYYYMMDD
                , A.ISO_YYYYWW
                , A.DAYOFWEEK
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
          ) CM
      ON  (A.YYYYMM = CM.BASIS_YYYYMM)
    JOIN  (SELECT L.SEGMENT3 AS DAYOFWEEK
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
           WHERE  1 = 1
           AND    L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
           AND    L.VALID_YN    = 'Y'
           AND    L.SEGMENT1    = v_division
           AND    L.SEGMENT2    = 'MONTHLY') BC
      ON  (BC.DAYOFWEEK = CM.DAYOFWEEK)
    WHERE  1 = 1
    AND    A.MEASURE = 'MKT_FCST'
    AND    NOT EXISTS (SELECT 1
                       FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION X
                       WHERE  1 = 1
                       AND    X.DIVISION_ID = A.DIVISION_ID
                       AND    X.SCM_SITE_ID = A.SCM_SITE_ID
                       AND    X.INCOTERMS   = A.INCOTERMS
                       AND    X.BUCKET_PER  = 'Y');

    ----------------------------------------------------------------------------------------------------
    --[MKT_FCST]
    --WEEK 별 수량 나누기
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , KEY_VALUE, YYYYMM, ISO_YYYYWW, WEEK_DAY_CNT, MONTHLY_QTY, WEEKLY_QTY)
    WITH W_WEEKLY AS (
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.YYYYMM
             , CM.ISO_YYYYWW
             , CM.WEEK_DAY_CNT
             , A.QTY AS MONTHLY_QTY
             , FLOOR(A.QTY / CM.EOM * CM.WEEK_DAY_CNT) AS TEMP_WEEKLY_QTY
             , SUM(FLOOR(A.QTY / CM.EOM * CM.WEEK_DAY_CNT))
                   OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM
                         ORDER BY A.KEY_VALUE, A.YYYYMM, CM.ISO_YYYYWW
                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS CUM_SUM
             , CASE WHEN LEAD(A.YYYYMM, 1)
                        OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM
                              ORDER BY A.KEY_VALUE, A.YYYYMM, CM.ISO_YYYYWW) IS NULL
                    THEN 'Y' ELSE 'N' END AS LAST_WEEK_YN
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.ISO_YYYYWW
                    , COUNT(1) AS WEEK_DAY_CNT
                    /* CONVERT(INT, FORMAT(EOMONTH(MAX(A.BASIS_DATE)),'dd')) → 명시 마스크 (C-11) */
                    , TO_NUMBER(TO_CHAR(LAST_DAY(MAX(A.BASIS_DATE)), 'DD')) AS EOM
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
               GROUP BY A.BASIS_YYYYMM
                      , A.ISO_YYYYWW
              ) CM
          ON  (A.YYYYMM = CM.BASIS_YYYYMM)
        JOIN  (SELECT DISTINCT PB.KEY_VALUE
                    , PB.BASIS_YYYYMM
                    , PB.ISO_YYYYWW
               FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET PB) PB --버켓 요일이 있는 주차만 대상으로 함.
          ON  (A.KEY_VALUE  = PB.KEY_VALUE
         AND   A.YYYYMM     = PB.BASIS_YYYYMM
         AND   CM.ISO_YYYYWW = PB.ISO_YYYYWW)
        WHERE  1 = 1
        AND    A.MEASURE = 'MKT_FCST'
    )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , A.YYYYMM
         , A.ISO_YYYYWW
         , A.WEEK_DAY_CNT
         , A.MONTHLY_QTY
         , CASE WHEN A.LAST_WEEK_YN = 'Y' THEN A.MONTHLY_QTY - A.CUM_SUM
                ELSE A.TEMP_WEEKLY_QTY END AS WEEKLY_QTY
    FROM   W_WEEKLY A
    WHERE  1 = 1
    AND    A.MEASURE = 'MKT_FCST'
    ORDER BY A.KEY_VALUE, A.YYYYMM;

    ----------------------------------------------------------------------------------------------------
    --[MKT_FCST]
    --DAILY 별 수량 나누기
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW
    , BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY)
    WITH W_DAILY AS (
        --SCM_SITE_ID별 BUCKET
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.YYYYMM
             , CM.BASIS_YYYYMMDD
             , CM.ISO_YYYYWW
             , BC.BUCKET_CNT
             , A.MONTHLY_QTY
             , A.WEEKLY_QTY
             , FLOOR(A.WEEKLY_QTY / BC.BUCKET_CNT) AS TEMP_DAILY_QTY
             , SUM(FLOOR(A.WEEKLY_QTY / BC.BUCKET_CNT))
                   OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                         ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD
                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS CUM_SUM
             , CASE WHEN LEAD(A.ISO_YYYYWW, 1)
                        OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                              ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD) IS NULL
                    THEN 'Y' ELSE 'N' END AS LAST_DAY_YN
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.BASIS_YYYYMMDD
                    , A.ISO_YYYYWW
                    , A.DAYOFWEEK
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
              ) CM
          ON  (A.YYYYMM     = CM.BASIS_YYYYMM
         AND   A.ISO_YYYYWW = CM.ISO_YYYYWW)
        JOIN  (SELECT BC.DIVISION_ID
                    , BC.SCM_SITE_ID
                    , BC.INCOTERMS
                    , BC.BUCKET_PER
                    , BC.YYYYMMDD
                    , COUNT(BC.BUCKET_PER) OVER (PARTITION BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS) AS BUCKET_CNT
               FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION BC
               WHERE  1 = 1
               AND    BC.DIVISION_ID = '40') BC   /* AS-IS 원문 하드코딩('40') 그대로 보존 */
          ON  (BC.DIVISION_ID = A.DIVISION_ID
         AND   BC.SCM_SITE_ID = A.SCM_SITE_ID
         AND   BC.INCOTERMS   = A.INCOTERMS
         AND   BC.YYYYMMDD    = CM.DAYOFWEEK
         AND   BC.BUCKET_PER  = 'Y')

        UNION ALL

        --DEFAULT BUCKET
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.YYYYMM
             , CM.BASIS_YYYYMMDD
             , CM.ISO_YYYYWW
             , 1 AS BUCKET_CNT
             , A.MONTHLY_QTY
             , A.WEEKLY_QTY
             , FLOOR(A.WEEKLY_QTY) AS TEMP_DAILY_QTY
             , SUM(FLOOR(A.WEEKLY_QTY))
                   OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                         ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD
                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS CUM_SUM
             , CASE WHEN LEAD(A.ISO_YYYYWW, 1)
                        OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                              ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD) IS NULL
                    THEN 'Y' ELSE 'N' END AS LAST_DAY_YN
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.BASIS_YYYYMMDD
                    , A.ISO_YYYYWW
                    , A.DAYOFWEEK
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
              ) CM
          ON  (A.YYYYMM     = CM.BASIS_YYYYMM
         AND   A.ISO_YYYYWW = CM.ISO_YYYYWW)
        JOIN  (SELECT L.SEGMENT3 AS DAYOFWEEK
               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
               WHERE  1 = 1
               AND    L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
               AND    L.VALID_YN    = 'Y'
               AND    L.SEGMENT1    = v_division
               AND    L.SEGMENT2    = 'MONTHLY') BC
          ON  (BC.DAYOFWEEK = CM.DAYOFWEEK)
        WHERE  1 = 1
        AND    A.MEASURE = 'MKT_FCST'
        AND    NOT EXISTS (SELECT 1
                           FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION X
                           WHERE  1 = 1
                           AND    X.DIVISION_ID = A.DIVISION_ID
                           AND    X.SCM_SITE_ID = A.SCM_SITE_ID
                           AND    X.INCOTERMS   = A.INCOTERMS
                           AND    X.BUCKET_PER  = 'Y')
    )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , A.YYYYMM
         , A.BASIS_YYYYMMDD
         , A.ISO_YYYYWW
         , A.BUCKET_CNT
         , A.MONTHLY_QTY
         , A.WEEKLY_QTY
         , A.LAST_DAY_YN
         , CASE WHEN A.LAST_DAY_YN = 'Y' THEN A.WEEKLY_QTY - NVL(A.CUM_SUM, 0)
                ELSE A.TEMP_DAILY_QTY END AS DAILY_QTY
    FROM   W_DAILY A
    WHERE  1 = 1
    ORDER BY A.KEY_VALUE, A.YYYYMM;

    ----------------------------------------------------------------------------------------------------
    --[LOC]
    --DAILY 별 PRICE생성
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
    ( DIVISION_ID
    , END_CUSTOMER
    , SCM_SITE_ID
    , ITEM_ID
    , INCOTERMS
    , FCST_TYPE
    , DOM_EXP
    , CELL_PROD_SITE
    , CURRENCY
    , MEASURE
    , KEY_VALUE
    , YYYYMM
    , BASIS_YYYYMMDD
    , ISO_YYYYWW
    , BUCKET_CNT
    , MONTHLY_QTY
    , WEEKLY_QTY
    , LAST_DAY_YN
    , DAILY_QTY
    )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM AS YYYYMM
         , CM.BASIS_YYYYMMDD
         , CM.ISO_YYYYWW
         , NULL AS BUCKET_CNT
         , NULL AS MONTHLY_QTY
         , NULL AS WEEKLY_QTY
         , NULL AS LAST_DAY_YN     /* AS-IS: '' AS LAST_DAY_YN → Oracle '' = NULL (C-7) */
         , CAST(A.QTY AS NUMBER(23,2)) AS DAILY_QTY
    FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
    JOIN  (SELECT A.BASIS_YYYYMM
                , A.BASIS_YYYYMMDD
                , A.ISO_YYYYWW
                , A.DAYOFWEEK
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
           AND    (A.DAYOFWEEK = v_defaultLocBucketDay OR A.CALENDAR_DAY = '01')
          ) CM
      ON  (A.YYYYMM = CM.BASIS_YYYYMM)
    WHERE  1 = 1
    AND    A.MEASURE = 'LOC';

    ----------------------------------------------------------------------------------------------------
    --최종 일자별 수량 Select (RECORD 형식)---------------------------
    ----------------------------------------------------------------------------------------------------
    OPEN O_RC1 FOR
        --MKT_FCST
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.BASIS_YYYYMMDD
             , CAST(A.DAILY_QTY AS NUMBER(23,2)) AS DAILY_QTY
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY A
        UNION ALL
        --LOC
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , CM.BASIS_YYYYMMDD
             , CAST(A.QTY AS NUMBER(23,2)) AS DAILY_QTY
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.BASIS_YYYYMMDD
                    , A.ISO_YYYYWW
                    , A.DAYOFWEEK
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
               AND    (A.DAYOFWEEK = v_defaultLocBucketDay OR A.CALENDAR_DAY = '01')
              ) CM
          ON  (A.YYYYMM = CM.BASIS_YYYYMM)
        WHERE  1 = 1
        AND    A.MEASURE = 'LOC'
        ORDER BY KEY_VALUE, BASIS_YYYYMMDD;
    --최종 일자별 Select (RECORD 형식) END ---------------------------

    ----------------------------------------------------------------------------------------------------
    --최종 일자별 Select (PIVOT 형식) START ---------------------------
    -- 동적 PIVOT IN 리스트 구성 (커서 LOOP — FETCH 직후 EXIT WHEN %NOTFOUND, C-10)
    ----------------------------------------------------------------------------------------------------
    DBMS_LOB.CREATETEMPORARY(V_CONCAT_PIVOT, TRUE);

    OPEN C_PIVOT;
    LOOP
        FETCH C_PIVOT INTO V_PIVOT_PIECE;
        EXIT WHEN C_PIVOT%NOTFOUND;
        IF DBMS_LOB.GETLENGTH(V_CONCAT_PIVOT) = 0 THEN
            V_CONCAT_PIVOT := '''' || V_PIVOT_PIECE || ''' AS ' || V_PIVOT_PIECE;
        ELSE
            V_CONCAT_PIVOT := V_CONCAT_PIVOT || ',''' || V_PIVOT_PIECE || ''' AS ' || V_PIVOT_PIECE;
        END IF;
    END LOOP;
    CLOSE C_PIVOT;

    /* [DEFECT_GUARD] 캘린더 미적재 등으로 PIVOT IN 리스트가 비면 ORA-00936 — 빈 커서 반환 */
    IF DBMS_LOB.GETLENGTH(V_CONCAT_PIVOT) = 0 THEN
        BEGIN DBMS_LOB.FREETEMPORARY(V_CONCAT_PIVOT); EXCEPTION WHEN OTHERS THEN NULL; END;
        OPEN O_RC2 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS RESULT_CODE, 'NO_CALENDAR_DATA' AS RESULT_MSG, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

    DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

    /* Oracle PIVOT: 서브쿼리와 PIVOT 사이 alias 불가 / PIVOT 집계 안 alias 참조 불가 → 최종 alias A 로 이동 */
    V_SQL := '
    SELECT A.*
      FROM (
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , B.END_CUSTOMER_NAME
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , B.FCST_TYPE_NAME
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , B.CELL_PROD_SITE_NAME
         , A.CURRENCY
         , A.MEASURE
         , B.MEASURE_NAME
         , ''D'' || A.BASIS_YYYYMMDD AS BASIS_YYYYMMDD
         , A.DAILY_QTY
      FROM SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY A
      JOIN SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT B
        ON (A.KEY_VALUE = B.KEY_VALUE))
      PIVOT (MAX(DAILY_QTY) FOR BASIS_YYYYMMDD IN (' || V_CONCAT_PIVOT || '
    )) A';

    OPEN O_RC2 FOR V_SQL;

    /* AS-IS: WHILE LEN(@V_SQL) > 0 ... PRINT LEFT(@V_SQL, 4000) — 4,000자씩 출력 (디버그 출력 1:1 유지) */
    V_PRINT_POS := 1;
    V_PRINT_LEN := NVL(DBMS_LOB.GETLENGTH(V_SQL), 0);
    WHILE V_PRINT_POS <= V_PRINT_LEN
    LOOP
        DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(V_SQL, 4000, V_PRINT_POS));
        V_PRINT_POS := V_PRINT_POS + 4000;
    END LOOP;

    BEGIN DBMS_LOB.FREETEMPORARY(V_SQL);          EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_LOB.FREETEMPORARY(V_CONCAT_PIVOT); EXCEPTION WHEN OTHERS THEN NULL; END;
    --최종 일자별 Select (PIVOT 형식) END ---------------------------

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, '0' AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL);          EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_CONCAT_PIVOT); EXCEPTION WHEN OTHERS THEN NULL; END;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', 0
              , '########## FAIL END of procedure ##########', ''
              , SYSDATE, p_created_by, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END DMF0082_GET_EXCEL_UPLOAD_DATA;
/