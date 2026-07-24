CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF" 
(
    -- Add the parameters for the stored procedure here
      p_division_id          IN  VARCHAR2      -- division_id 전달받음
    , p_version_description  IN  CLOB          -- description 전달받음
    , p_ver_type             IN  CLOB
    , p_created_by           IN  CLOB
    -- 원본 CATCH 의 에러메시지 SELECT 결과셋 반환 → SYS_REFCURSOR OUT (DBMS_SQL.RETURN_RESULT 금지)
    , p_cursor1              OUT SYS_REFCURSOR
)
/*
EXEC DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF_TOBE
*/

/*
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF
 * Description  : Business Plan DM_PLN_BP_FCST_C TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190410 KHSONG Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190617 KHSONG DM_BP_EXCHANGE_RATE => DM_BP_EXCHANGE_RATE_C (6/11 추가)
 * 2020/04/23	P.C.I    [PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/07/26	SJHAN	중장기계획 과제 관련 - SEQ 추가
 * 2022/04/12	rosia27		[과제PJ20216891R]GM_JV
 * 2022/06/10	rosia27		[C20220526-000090]Business Plan Waterfall 개발 요청의 건
 * 2022/06/21	rosia27		[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2026.06.02	ZIONEX			[PJ202650304] NextSCM Migration
 */
AS
    n_history_seq      INTEGER;
    -- LOG 용 변수 설정
    v_program_name VARCHAR2(150 CHAR) := 'DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF';
    v_log_type     VARCHAR2(30 CHAR);  -- START/END/ERROR/...
    n_log_count    INTEGER := 0;
    v_log_message  VARCHAR2(1000 CHAR);
    v_description  VARCHAR2(500 CHAR);
    d_event_date   DATE;

    --
    v_division_id          VARCHAR2(4000 CHAR);   -- 원본 NVARCHAR(MAX) (DIVISION_ID 컬럼 비교 위해 VARCHAR2 유지)
    v_ver_description      CLOB;
    v_ver_type             CLOB;
    v_created_by           CLOB;

    v_ver_return_no        VARCHAR2(100 CHAR);    -- cut off Generated Number
    v_cutoff_yyyymmdd      VARCHAR2(8 CHAR);      -- 원본 NVARCHAR(MAX) (CONVERT(CHAR(8)) 값 8자리)
    v_OK_description       VARCHAR2(1200 CHAR);   -- cut off Generated Number

    n_Seq_No               INTEGER := 0;

    v_err_display          VARCHAR2(4100 CHAR);   -- 에러메시지 DISPLAY 용 (SQLERRM 은 SQL 문 내 직접 사용 불가 → 변수로 받아 사용)
BEGIN
    -- SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET XACT_ABORT ON; -- MSSQL 세션설정, Oracle 불필요

    v_division_id       := NULL;
    v_ver_description   := NULL;
    v_ver_type          := NULL;
    v_created_by        := NULL;
    v_cutoff_yyyymmdd   := TO_CHAR(SYSDATE, 'YYYYMMDD');   -- CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)

    -- 시작 LOG  (START)
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    v_log_message := NULL;     /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- 트랜잭션 (START)
    SAVEPOINT SAVE_DM_PLN_BP_FCST_CUTOFF;

    --------------------------------------------------------------------------------------------
    BEGIN
    --------------------------------------------------------------------------------------------
        v_ver_description  := p_version_description;
        v_ver_type         := 'BP_M';
        v_created_by       := p_created_by;

        v_division_id := p_division_id;

        PR_DM_PLN_VERSION_CREATE( v_division_id
                                , v_ver_description
                                , v_ver_type
                                , v_created_by
                                , v_ver_return_no
                                , v_OK_description );

        -- [DM_PLN_BP_FCST] -> [DM_PLN_BP_FCST_C]
        SELECT MAX(NVL(SEQ_NO,0)) + 1 INTO n_Seq_No FROM DM_PLN_BP_FCST_C A;
        BEGIN

            INSERT INTO DM_PLN_BP_FCST_C
                 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                 , PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
                 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                 , PLANT_SITE_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
                 , YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY --[PJ20200138] item_use, unit_energy 추가
                 , QTY, CELL_PER_PACK
                 , CELL_PER_MODULE, MODULE_PER_PACK, CREATED_BY, CREATION_DATE
                 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
                 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
                 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, SEQ_NO, CELL_PROD_SITE )
            -- [NOT NULL 문자컬럼] 소스 NULL(=MSSQL '')은 '-' 치환(NVL). 검증 시 '' 와 '-' 동일 간주.
            SELECT NVL(A.DIVISION_ID,'-'), v_ver_return_no AS VERSION_NO, v_ver_type AS CUTOFF_TYPE, v_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
                 , NVL(A.PROJECT_CODE,'-'), A.PROJECT_NAME, NVL(A.SCM_SITE_ID,'-'), NVL(A.ITEM_ID,'-')
                 , NVL(A.DOM_EXP,'-'), NVL(A.FCST_TYPE,'-'), A.INCOTERMS, NVL(A.MEASURE,'-')
                 , NVL(A.PLANT_SITE_ID,'-'), NVL(A.DEPT_ID,'-'), NVL(A.END_CUSTOMER,'-'), NVL(A.BIZ_TYPE,'-')
                 , NVL(A.YYYYMM,'-'), NVL(A.CURRENCY,'-'), NVL(ITEM_USE,'-'), UNIT_ENERGY --[PJ20200138] item_use, unit_energy 추가
                 , A.QTY, A.CELL_PER_PACK
                 , A.CELL_PER_MODULE, A.MODULE_PER_PACK, A.CREATED_BY, A.CREATION_DATE
                 , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2
                 , A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
                 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                 , ROW_NUMBER() OVER(ORDER BY DIVISION_ID)	-- 2021/07/26 SJHAN 중장기계획 과제 관련 - SEQ 추가
                 , NVL(CELL_PROD_SITE,'-')  -- 2022/06/02 [C20220513-000327]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
              FROM DM_PLN_BP_FCST A
             WHERE 1 = 1
               AND A.DIVISION_ID = v_division_id
            ;
        END;

        /* 20190617 CUTOFF DATA INSERT (BEGIN) */
        BEGIN
            -- insert 작업
            INSERT INTO DM_BP_EXCHANGE_RATE_C
                 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                 , YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
                 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                 , ATTRIBUTE9, ATTRIBUTE10 )
            -- DM_PLN_BP_FCST_C 테이블에 생성된 동일한 version no 를 저장
            -- [NOT NULL 문자컬럼] 소스 NULL(=MSSQL '')은 '-' 치환(NVL).
            SELECT p_division_id, v_ver_return_no AS VERSION_NO, v_ver_type AS CUTOFF_TYPE, v_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
                 , NVL(YYYYMMDD,'-'), NVL(CURRENCY,'-'), NVL(UNIT_CURRENCY,'-'), EXCHANGE_PRICE
                 , NVL(CREATED_BY,'-'), CREATION_DATE, v_created_by AS LAST_UPDATED_BY, SYSDATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
                 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                 , ATTRIBUTE9, ATTRIBUTE10
              FROM DM_BP_EXCHANGE_RATE
             WHERE DIVISION_ID = p_division_id
            ;
        END;

        /* CUTOFF DATA INSERT END) */

        -- 트랜잭션 (COMMIT)
        COMMIT;

    --------------------------------------------------------------------------------------------
    EXCEPTION
    --------------------------------------------------------------
    -- ROLLBACK
    WHEN OTHERS THEN
        -- 트랜잭션 (END)
        ROLLBACK TO SAVEPOINT SAVE_DM_PLN_BP_FCST_CUTOFF;

        -- ERROR LOG VALUE SAVE
        v_log_type    := 'ERROR';
        v_log_message := SUBSTR(SQLERRM, 1, 1000);                                    -- ERROR_MESSAGE()
        v_description := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);  -- STR(ERROR_LINE())
        d_event_date  := SYSDATE;

        --[C20200909-000203] LOG 표준화 적용
        PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date
                            , P_IN_PARA_DATA  => 'p_division_id=' || p_division_id
                            , P_SQL_ERR_CODE  => TO_CHAR(SQLCODE)
                            , P_SQL_ERR_MSG   => SQLERRM
                            , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        -- 에러메시지 DISPLAY (원본: SELECT '[' + ERROR_NUMBER() + ']' + ERROR_MESSAGE())
        v_err_display := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;
        OPEN p_cursor1 FOR SELECT v_err_display AS ERROR_MESSAGE FROM DUAL;
    --------------------------------------------------------------
    END;
    --------------------------------------------------------------

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
END;
/
