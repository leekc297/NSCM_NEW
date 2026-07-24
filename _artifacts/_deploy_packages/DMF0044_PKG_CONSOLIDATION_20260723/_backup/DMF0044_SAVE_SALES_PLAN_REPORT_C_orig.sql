CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_SAVE_SALES_PLAN_REPORT_C" 
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_CUTOFF_TYPE           IN  VARCHAR2,
    P_CUTOFF_YYYYMMDD       IN  VARCHAR2,
    P_DEPARTMENT_ID         IN  VARCHAR2,
    P_DEPARTMENT_NAME       IN  VARCHAR2,
    P_DEPT_ID               IN  VARCHAR2,
    P_DEPT_NAME             IN  VARCHAR2,
    P_END_CUST_REPORT       IN  VARCHAR2,
    P_CUST_REPORT           IN  VARCHAR2,
    P_PRODUCT_GROUP         IN  VARCHAR2,
    P_ITEM_ID               IN  VARCHAR2,
    P_MEASURE               IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_COMPANY_ID            IN  VARCHAR2,
    P_QTY                   IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_CELL_MODEL_INFO       IN  VARCHAR2,   --[C20211112-000213]
    P_CELL_MODEL            IN  VARCHAR2,   --[C20211112-000213]
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SAVE_SALES_PLAN_REPORT_C
 * Description  : 'DM_PLN_SALES_PLAN_REPORT_C' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190529  KHSONG  Initial Release [PJ20189106] 전지.GSCM 고도화 이행, DM 시스템
 * 20190719  JSYOUN  사업계획리포트테이블 변경(DM_PLN_BP_FCST_C -> DM_PLN_BP_FCST_REPORT_C)
 * 20190822  JSYOUN  DM_PLN_SALES_PLAN_REPORT_C PK에서 DIVISION_ID 제외 CURRENCY 추가, DM_PLN_BP_FCST_REPORT_C PK에 CURRENCY 추가
 * 20191030  KYH	 Attribute1 에 ProductDetails 를 '기타'로 세팅
 * 20200123  hwi1993 company_id 추가
 * 20200206  hwi1993 cutoff_yyyymmdd 보완
 * 20200319  hwi1993 DeptName, DepartmentName 의 룩업화에 따라 JOIN 조건에서 사용하지 않도록 변경
 * 20200522 hwi1993	Save 이후에 Transfer 처리
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2022/01/24	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2023.09.07	jssbae		[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청
 */
IS
    /*
    ''고정
    PROJECT_CODE
    SCM_SITE_ID
    DOM_EXP
    FCST_TYPE
    INCOTERMS
    PLANT_SITE_ID
    */

    -- 스플릿관련 변수
    v_cutoff_yyyymmdd       VARCHAR2(8 CHAR);
    v_version_no            VARCHAR2(100 CHAR);
    v_division_id           VARCHAR2(50 CHAR);
    v_yyyymmdd              VARCHAR2(8 CHAR);
    v_cutoff_type           VARCHAR2(100 CHAR);

    v_exists                PLS_INTEGER;

    -- LOG 용 변수 설정
    V_LOG_TYPE              VARCHAR2(100 CHAR);
    N_LOG_COUNT             PLS_INTEGER := 0;
    V_LOG_MESSAGE           VARCHAR2(4000 CHAR);
    V_DESCRIPTION           VARCHAR2(4000 CHAR);
    D_EVENT_DATE            DATE := SYSDATE;
    n_delete_count          PLS_INTEGER := 0;
    n_merge_count           PLS_INTEGER := 0;
    n_insert_count          PLS_INTEGER := 0;
    n_input_count           PLS_INTEGER := 0;
    n_logo_count            PLS_INTEGER := 0;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);
    V_SQL_CODE              VARCHAR2(100 CHAR);
    V_SQL_ERRMSG            VARCHAR2(1000 CHAR);

BEGIN

    -- GTT 초기화 (프로시저 시작 시, 이전에 일반 테이블 DML 없으므로 TRUNCATE 허용)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_0044_RESULTS_MST';

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure @@@##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- 트랜잭션 (START)

    --===================================================================================== GT_0044_RESULTS_MST 테이블에 split후 insert start
    --###############################################  GT_0044_RESULTS_MST 테이블에 split후 insert (START)
    INSERT INTO SCM_MGR.GT_0044_RESULTS_MST
    (
        ACTIVE_FLAG,
        DIVISION_ID,
        VERSION_NO,
        CUTOFF_TYPE,
        CUTOFF_YYYYMMDD,
        DEPARTMENT_ID,
        DEPARTMENT_NAME,
        DEPT_ID,
        DEPT_NAME,
        END_CUST_REPORT,
        CUST_REPORT,
        PRODUCT_GROUP,
        PROJECT_CODE,
        SCM_SITE_ID,
        DOM_EXP,
        FCST_TYPE,
        INCOTERMS,
        CELL_MODEL_INFO,
        CELL_MODEL,
        ITEM_ID,
        MEASURE,
        YYYYMMDD,
        CURRENCY,
        COMPANY_ID,
        QTY,
        CREATED_BY
    )
    SELECT
        TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,       '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DIVISION_ID,       '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_VERSION_NO,        '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_CUTOFF_TYPE,       '[^^]+', 1, LVL)),
        NULL,  -- CUTOFF_YYYYMMDD: 후속 UPDATE에서 설정
        TRIM(REGEXP_SUBSTR(P_DEPARTMENT_ID,     '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DEPARTMENT_NAME,   '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DEPT_ID,           '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DEPT_NAME,         '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_END_CUST_REPORT,   '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_CUST_REPORT,       '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_PRODUCT_GROUP,     '[^^]+', 1, LVL)),
        '-',    --project_code   (NOT NULL, PK)
        '-',    --scm_site_id    (NOT NULL, PK)
        '-',    --dom_exp
        '-',    --fcst_type      (NOT NULL, PK)
        '-',    --incoterms      (NOT NULL, PK)
        TRIM(REGEXP_SUBSTR(P_CELL_MODEL_INFO,   '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_CELL_MODEL,        '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_ITEM_ID,           '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_MEASURE,           '[^^]+', 1, LVL)),
        -- yyyymm 값을 월별 첫 영업일(yyyymmdd)로 변환
        (SELECT MIN(C.BASIS_START_DATE)
         FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
         WHERE  SUBSTR(C.BASIS_YYYYMMDD, 1, 6) = SUBSTR(TRIM(REGEXP_SUBSTR(P_YYYYMMDD, '[^^]+', 1, LVL)), 1, 6)
         AND    C.DAYOFWEEK IN ('MON','TUE','WED','THU','FRI')
        ),
        TRIM(REGEXP_SUBSTR(P_CURRENCY,          '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_COMPANY_ID,        '[^^]+', 1, LVL)),
        NVL(NULLIF(TRIM(REGEXP_SUBSTR(P_QTY,    '[^^]+', 1, LVL)), ''), '0'),
        TRIM(REGEXP_SUBSTR(P_CREATED_BY,        '[^^]+', 1, LVL))
    FROM (
        SELECT LEVEL AS LVL
        FROM   DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^^]+', 1, LEVEL) IS NOT NULL
    );

    --###############################################  GT_0044_RESULTS_MST 테이블에 split후 insert (END)

    -- CUTOFF_YYYYMMDD 설정: DM_MDF_VERSION → DM_MST_VERSION JOIN
    UPDATE SCM_MGR.GT_0044_RESULTS_MST R
    SET    R.CUTOFF_YYYYMMDD = (
        SELECT B.YYYYMMDD
        FROM   SCM_MGR.DM_MDF_VERSION A
        JOIN   SCM_MGR.DM_MST_VERSION B
            ON A.DIVISION_ID    = B.DIVISION_ID
            AND A.ORI_VERSION_NO = B.VERSION_NO
        WHERE  A.VERSION_NO  = R.VERSION_NO
        AND    A.DIVISION_ID = R.DIVISION_ID
        AND    ROWNUM = 1
    );

    -- GTT를 다른 테이블과 JOIN 하므로 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_RESULTS_MST', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_0044_RESULTS_MST',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1'
    );

    --===================================================================================== GT_0044_RESULTS_MST 테이블에 split후 insert end

    --
    -- INPUT COUNT 확인
    SELECT COUNT(ACTIVE_FLAG)
    INTO   n_input_count
    FROM   SCM_MGR.GT_0044_RESULTS_MST;

    -- 마지막 행의 v_version_no, v_division_id, v_yyyymmdd, v_cutoff_type 가져옴
    SELECT VERSION_NO, DIVISION_ID, YYYYMMDD, CUTOFF_TYPE
    INTO   v_version_no, v_division_id, v_yyyymmdd, v_cutoff_type
    FROM   (
        SELECT VERSION_NO, DIVISION_ID, YYYYMMDD, CUTOFF_TYPE
        FROM   SCM_MGR.GT_0044_RESULTS_MST
        ORDER BY ROWID DESC
    )
    WHERE  ROWNUM = 1;

    IF v_cutoff_type = 'REPORT_SP_W' THEN
        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                                  DM_PLN_SALES_PLAN_REPORT_C 테이블 DELETE (START)
        --------------------------------------------------------------------------------------------◇◇◇◇

        -- DELETE COUNT 확인
        SELECT COUNT(DIVISION_ID)
        INTO   n_delete_count
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_0044_RESULTS_MST M
            WHERE  M.ACTIVE_FLAG = 'D'
        );

        DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        WHERE  A.DATA_TYPE = '2'
        AND    EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_0044_RESULTS_MST B
            WHERE  B.ACTIVE_FLAG                = 'D'
            AND    A.VERSION_NO                 = B.VERSION_NO
            AND    A.DIVISION_ID                = B.DIVISION_ID
            AND    A.DEPARTMENT_ID              = B.DEPARTMENT_ID
            --AND A.DEPARTMENT_NAME			= B.DEPARTMENT_NAME
            AND    A.DEPT_ID                    = B.DEPT_ID
            --AND A.DEPT_NAME					= B.DEPT_NAME
            AND    A.END_CUST_REPORT            = B.END_CUST_REPORT
            AND    A.CUST_REPORT                = B.CUST_REPORT
            AND    A.PRODUCT_GROUP              = B.PRODUCT_GROUP
            AND    NVL(NULLIF(TRIM(A.PROJECT_CODE), ''), '-') = B.PROJECT_CODE
            AND    NVL(NULLIF(TRIM(A.SCM_SITE_ID), ''), '-')  = B.SCM_SITE_ID
            AND    A.ITEM_ID                    = B.ITEM_ID
            AND    A.MEASURE                    = B.MEASURE
            AND    A.YYYYMMDD                   = B.YYYYMMDD
            AND    A.CURRENCY                   = B.CURRENCY
            AND    A.COMPANY_ID                 = B.COMPANY_ID
            AND    NVL(NULLIF(TRIM(A.FORECAST_INFO_CELL_MODEL), ''), '-') = NVL(NULLIF(TRIM(B.CELL_MODEL_INFO), ''), '-')
            AND    NVL(NULLIF(TRIM(A.ATTRIBUTE3), ''), '-') = NVL(NULLIF(TRIM(B.CELL_MODEL), ''), '-')
        );

        --select @@Rowcount
        n_delete_count := SQL%ROWCOUNT;

        --------------------------------------------------------------------------------------------◇◇◇◇
        --                          DM_PLN_SALES_PLAN_REPORT_C 테이블 DELETE (END)
        --------------------------------------------------------------------------------------------◇◇◇◇

        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                          DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (START)
        --------------------------------------------------------------------------------------------◇◇◇◇
        -- INSERT COUNT 확인
        SELECT COUNT(M.DIVISION_ID)
        INTO   n_insert_count
        FROM   SCM_MGR.GT_0044_RESULTS_MST M
        WHERE  M.ACTIVE_FLAG <> 'D';

        MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        USING (
            SELECT *
            FROM   SCM_MGR.GT_0044_RESULTS_MST M
            WHERE  M.ACTIVE_FLAG <> 'D'
        ) B
        ON (
                A.DIVISION_ID                          = B.DIVISION_ID
            AND A.VERSION_NO                           = B.VERSION_NO
            AND A.DEPARTMENT_ID                        = B.DEPARTMENT_ID
            --AND	    A.DEPARTMENT_NAME	 = B.DEPARTMENT_NAME
            AND A.DEPT_ID                              = B.DEPT_ID
            --AND	    A.DEPT_NAME			 = B.DEPT_NAME
            AND A.END_CUST_REPORT                      = B.END_CUST_REPORT
            AND A.CUST_REPORT                          = B.CUST_REPORT
            AND A.PRODUCT_GROUP                        = B.PRODUCT_GROUP
            AND NVL(NULLIF(TRIM(A.PROJECT_CODE), ''), '-')   = B.PROJECT_CODE
            AND NVL(NULLIF(TRIM(A.SCM_SITE_ID), ''), '-')    = B.SCM_SITE_ID
            AND A.ITEM_ID                              = B.ITEM_ID
            AND NVL(NULLIF(TRIM(A.FCST_TYPE), ''), '-')      = B.FCST_TYPE
            AND NVL(NULLIF(TRIM(A.INCOTERMS), ''), '-')      = B.INCOTERMS
            AND A.MEASURE                              = B.MEASURE
            AND NVL(NULLIF(TRIM(A.PLANT_SITE_ID), ''), '-')  = '-'
            AND A.YYYYMMDD                             = B.YYYYMMDD
            AND A.CURRENCY                             = B.CURRENCY       -- 20190822
            AND A.COMPANY_ID                           = B.COMPANY_ID     -- 20200123
            AND NVL(NULLIF(TRIM(A.CELL_PROD_SITE), ''), '-') = '-'
            AND A.DATA_TYPE                            = '2'
        )
        WHEN MATCHED THEN
            UPDATE SET
                A.QTY              = B.QTY,
                A.LAST_UPDATED_BY  = B.CREATED_BY,
                A.LAST_UPDATE_DATE = SYSDATE

        WHEN NOT MATCHED THEN
            INSERT (
                DATA_TYPE,
                DIVISION_ID,
                VERSION_NO,
                CUTOFF_TYPE,
                CUTOFF_YYYYMMDD,
                DEPARTMENT_ID,
                DEPARTMENT_NAME,
                DEPT_ID,
                DEPT_NAME,
                END_CUST_REPORT,
                CUST_REPORT,
                PRODUCT_GROUP,
                PROJECT_CODE,
                SCM_SITE_ID,
                DOM_EXP,
                FCST_TYPE,
                INCOTERMS,
                PLANT_SITE_ID,
                ITEM_ID,
                MEASURE,
                YYYYMMDD,
                CURRENCY,
                COMPANY_ID,
                QTY,
                CREATED_BY,
                CREATION_DATE,
                LAST_UPDATED_BY,
                LAST_UPDATE_DATE,
                ATTRIBUTE1,
                ATTRIBUTE2,
                ATTRIBUTE3,
                ATTRIBUTE4,
                ATTRIBUTE5,
                FORECAST_INFO_CELL_MODEL,
                CELL_PROD_SITE
            )
            VALUES (
                '2',
                B.DIVISION_ID,
                B.VERSION_NO,
                B.CUTOFF_TYPE,
                B.CUTOFF_YYYYMMDD,
                B.DEPARTMENT_ID,
                B.DEPARTMENT_NAME,
                B.DEPT_ID,
                B.DEPT_NAME,
                B.END_CUST_REPORT,
                B.CUST_REPORT,
                B.PRODUCT_GROUP,
                '-',   --project_code   (NOT NULL, PK)
                '-',   --scm_site_id    (NOT NULL, PK)
                '-',   --dom_exp
                '-',   --fcst_type      (NOT NULL, PK)
                '-',   --incoterms      (NOT NULL, PK)
                '-',   --plant_site_id  (NOT NULL, PK)
                B.ITEM_ID,
                B.MEASURE,
                B.YYYYMMDD,
                B.CURRENCY,
                B.COMPANY_ID,
                B.QTY,
                B.CREATED_BY,
                SYSDATE,
                B.CREATED_BY,
                SYSDATE,
                '기타',
                '-',
                B.CELL_MODEL,
                NULL,
                NULL,
                B.CELL_MODEL_INFO,
                '-'    --cell_prod_site (NOT NULL, PK)
            );

            n_merge_count := SQL%ROWCOUNT;
    END IF;
    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                   DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (END)
    --------------------------------------------------------------------------------------------◇◇◇◇

    --ELSE

    --[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 20230907
    MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING (
        SELECT LOOKA.MODEL,
               LOOKA.BIZ_TYPE,
               LOOKA.CELL_PACK_COUNT,
               LOOKA.DIVISION_ID
        FROM (
            SELECT SEGMENT2  AS MODEL,
                   SEGMENT3  AS BIZ_TYPE,
                   SEGMENT4  AS CELL_PACK_COUNT,
                   SEGMENT1  AS DIVISION_ID,
                   RANK() OVER (
                       PARTITION BY SEGMENT2
                       ORDER BY DISPLAY_SEQ DESC
                   ) AS MODEL_RANK
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
        ) LOOKA
        WHERE  LOOKA.MODEL_RANK = 1
    ) LOOKA
    ON (
            LOOKA.MODEL        = A.ITEM_ID
        AND LOOKA.DIVISION_ID  = A.DIVISION_ID
        AND A.DIVISION_ID      = '40'
        AND A.VERSION_NO       = v_version_no
        AND A.YYYYMMDD         = v_yyyymmdd
    )
    WHEN MATCHED THEN
        UPDATE SET
            A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT,
            A.FORECAST_INFO_BIZ_TYPE        = LOOKA.BIZ_TYPE;

    -- n_merge_count := SQL%ROWCOUNT;

    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                                  DM_PLN_BP_FCST_REPORT_C 테이블 DELETE (START)
    --------------------------------------------------------------------------------------------◇◇◇◇
    --BEGIN

        ---- DELETE COUNT 확인
        --SET @n_delete_count =  (SELECT COUNT(division_id)  FROM SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        --						WHERE (
        --								SELECT count(1)
        --									FROM GT_0044_RESULTS_MST M
        --									where M.active_flag		= 'D'
        --								) > 0)

        ----  select * from GT_0044_RESULTS_MST
        --DELETE
        --FROM SCM_MGR.DM_PLN_BP_FCST_REPORT_C
        --WHERE (
        --		SELECT count(1)
        --			FROM GT_0044_RESULTS_MST M
        --			where M.active_flag		= 'D'
        --				and DATA_TYPE = '2'
        --				and DM_PLN_BP_FCST_REPORT_C.division_id		= M.division_id
        --				and DM_PLN_BP_FCST_REPORT_C.version_no		= M.version_no
        --				and DM_PLN_BP_FCST_REPORT_C.department_id	= M.department_id
        --				--and DM_PLN_BP_FCST_REPORT_C.department_name	= M.department_name
        --				and DM_PLN_BP_FCST_REPORT_C.dept_id			= M.dept_id
        --				--and DM_PLN_BP_FCST_REPORT_C.dept_name		= M.dept_name
        --				and DM_PLN_BP_FCST_REPORT_C.end_cust_report	= M.end_cust_report
        --				and DM_PLN_BP_FCST_REPORT_C.cust_report		= M.cust_report
        --				and DM_PLN_BP_FCST_REPORT_C.product_group	= M.product_group

        --				and NVL(DM_PLN_BP_FCST_REPORT_C.project_code	,'')	= M.project_code
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.scm_site_id	,'')	= M.scm_site_id
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.dom_exp		,'')	= M.dom_exp
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.fcst_type	,'')	= M.fcst_type
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.incoterms	,'')	= M.incoterms
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.

        --				and DM_PLN_BP_FCST_REPORT_C.item_id			= M.item_id
        --				and DM_PLN_BP_FCST_REPORT_C.currency	    = M.currency			-- 20190822
        --				and DM_PLN_BP_FCST_REPORT_C.company_id	    = M.company_id			-- 20200123
        --				and DM_PLN_BP_FCST_REPORT_C.measure			= M.measure
        --				and DM_PLN_BP_FCST_REPORT_C.yyyymm			= SUBSTR(M.yyyymmdd,1,6)
        --		) > 0;
    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                                  DM_PLN_BP_FCST_C 테이블 DELETE (END)
    --------------------------------------------------------------------------------------------◇◇◇◇

    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                          DM_PLN_BP_FCST_C 테이블 UPDATE, INSERT (START)
    --------------------------------------------------------------------------------------------◇◇◇◇
        -- INSERT COUNT 확인
        --SET n_insert_count = ( SELECT count(M.division_id)
        --							FROM GT_0044_RESULTS_MST M
        --								where M.active_flag      <> 'D' )

        --			MERGE INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        --			USING (
        --					SELECT *
        --						FROM GT_0044_RESULTS_MST M
        --							where M.active_flag      <> 'D'
        --				  ) B
        --			ON(
        --						A.division_id		 = B.division_id
        --				AND	    A.version_no		 = B.version_no
        --				AND	    A.department_id		 = B.department_id
        --				--AND	    A.department_name	 = B.department_name
        --				AND	    A.dept_id			 = B.dept_id
        --				--AND	    A.dept_name			 = B.dept_name
        --				AND	    A.end_cust_report	 = B.end_cust_report
        --				AND	    A.cust_report		 = B.cust_report
        --				AND	    A.product_group		 = B.product_group

        --				AND	    NVL(A.project_code	,'')	 = B.project_code
        --				AND	    NVL(A.scm_site_id	,'')	 = B.scm_site_id
        --				AND	    NVL(A.dom_exp		,'')	 = B.dom_exp
        --				AND	    NVL(A.fcst_type		,'')	 = B.fcst_type
        --				AND	    NVL(A.incoterms		,'')	 = B.incoterms

        --				AND	    A.item_id			 = B.item_id
        --				AND	    A.currency			 = B.currency				-- 20190822
        --				AND	    A.company_id		 = B.company_id				-- 20200123
        --				AND	    A.measure			 = B.measure
        --				AND	    A.yyyymm			 = SUBSTR(B.yyyymmdd,1,6)
        --				AND		a.DATA_TYPE = '2'
        --			  )
        --			WHEN MATCHED THEN
        --				 UPDATE SET
        --							 A.QTY				= B.QTY
        --							,A.last_updated_by	= B.created_by
        --							,A.last_update_date	= SYSDATE
        --
        --			WHEN NOT MATCHED THEN

        --				 INSERT (
        --						   DATA_TYPE
        --						  ,division_id
        --						  ,version_no
        --						  ,cutoff_type
        --						  ,cutoff_yyyymmdd
        --						  ,department_id
        --						  ,department_name
        --						  ,dept_id
        --						  ,dept_name
        --						  ,end_cust_report
        --						  ,cust_report
        --						  ,product_group
        --						  ,project_code
        --						  ,scm_site_id
        --						  ,dom_exp
        --						  ,fcst_type
        --						  ,incoterms
        --						  ,plant_site_id

        --						  ,item_id
        --						  ,measure
        --						  ,yyyymm
        --						  ,currency
        --						  ,company_id
        --						  ,qty
        --						  ,created_by
        --						  ,CREATION_DATE
        --						  ,LAST_UPDATED_BY
        --						  ,LAST_UPDATE_DATE
        --						  ,ATTRIBUTE1
        --						  ,ATTRIBUTE2
        --						  ,ATTRIBUTE3
        --						  ,ATTRIBUTE4
        --						  ,ATTRIBUTE5
        --						)
        --				 VALUES (   '2'
        --						   ,B.division_id
        --						   ,B.version_no
        --						   ,B.cutoff_type
        --						   ,B.cutoff_yyyymmdd
        --						   ,B.department_id
        --						   ,B.department_name
        --						   ,B.dept_id
        --						   ,B.dept_name
        --						   ,B.end_cust_report
        --						   ,B.cust_report
        --						   ,B.product_group
        --							,''  --project_code
        --							,''	 --scm_site_id
        --							,''	 --dom_exp
        --							,''	 --fcst_type
        --							,''	 --incoterms
        --							,''	 --plant_site_id
        --						   ,B.item_id
        --						   ,B.measure
        --						   ,SUBSTR(B.yyyymmdd,1,6)
        --						   ,B.currency
        --						   ,B.company_id
        --						   ,B.qty
        --						   ,B.CREATED_BY
        --						   ,SYSDATE
        --						   ,B.CREATED_BY
        --						   ,SYSDATE
        --						   ,'기타','',NULL,NULL,NULL
        --						);

    --END
    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                          DM_PLN_BP_FCST_REPORT_C 테이블 UPDATE, INSERT (END)
    --------------------------------------------------------------------------------------------◇◇◇◇


    -- UPDATE 후에 전송처리를 다시 한다.
    BEGIN
        SELECT 1
        INTO   v_exists
        FROM   DUAL
        WHERE  EXISTS (
            SELECT DIVISION_ID
            FROM   SCM_MGR.DM_MDF_VERSION
            WHERE  DIVISION_ID = v_division_id
            AND    VERSION_NO  = v_version_no
            AND    SEND_YN     = 'Y'
        );
        /* TODO 26.03.23
        EXECUTE IMMEDIATE
            'BEGIN SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(:1, :2, :3, :4, :5); END;'
            USING v_division_id, v_version_no, v_cutoff_type, 'T', P_CREATED_BY;
        */

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- SEND_YN = 'Y' 데이터 없으면 전송 처리 스킵
    END;

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure @@@##########';
    V_DESCRIPTION := 'input_count: ' || TO_CHAR(n_input_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'     VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'     VALUE P_DIVISION_ID,
            'P_VERSION_NO'      VALUE P_VERSION_NO,
            'P_CUTOFF_TYPE'     VALUE P_CUTOFF_TYPE,
            'P_CUTOFF_YYYYMMDD' VALUE P_CUTOFF_YYYYMMDD,
            'P_DEPARTMENT_ID'   VALUE P_DEPARTMENT_ID,
            'P_DEPARTMENT_NAME' VALUE P_DEPARTMENT_NAME,
            'P_DEPT_ID'         VALUE P_DEPT_ID,
            'P_DEPT_NAME'       VALUE P_DEPT_NAME,
            'P_END_CUST_REPORT' VALUE P_END_CUST_REPORT,
            'P_CUST_REPORT'     VALUE P_CUST_REPORT,
            'P_PRODUCT_GROUP'   VALUE P_PRODUCT_GROUP,
            'P_ITEM_ID'         VALUE P_ITEM_ID,
            'P_MEASURE'         VALUE P_MEASURE,
            'P_YYYYMMDD'        VALUE P_YYYYMMDD,
            'P_CURRENCY'        VALUE P_CURRENCY,
            'P_COMPANY_ID'      VALUE P_COMPANY_ID,
            'P_QTY'             VALUE P_QTY,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_CELL_MODEL_INFO' VALUE P_CELL_MODEL_INFO,
            'P_CELL_MODEL'      VALUE P_CELL_MODEL
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END DMF0044_SAVE_SALES_PLAN_REPORT_C;