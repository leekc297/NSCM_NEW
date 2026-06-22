-- ============================================================
-- PR_DM_ADM_DQ_* procedures (history + create, 10)
-- 실행 계정: SCM_MGR · dev/local DDL extract 2026-06-22
-- ============================================================

-- ===== PR_DM_ADM_DQ_CREATE =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE" 
(

	-- Add the parameters for the stored procedure here
	p_active_flag              VARCHAR2,
	p_DQ_ID                    VARCHAR2,
	p_DIVISION_ID              VARCHAR2,
	p_DQ_NAME                  VARCHAR2,
	p_DESCRIPTION              VARCHAR2,
	p_DQ_TEXT                  VARCHAR2,
	p_VALID_YN                 VARCHAR2,
	p_ADMIN_ONLY_YN            VARCHAR2,
	p_CREATED_BY               VARCHAR2,
	--p_CREATION_DATE            VARCHAR2,
	p_LAST_UPDATED_BY          VARCHAR2
	--p_LAST_UPDATE_DATE         VARCHAR2

/*
 * Program ID   : PR_DM_ADM_DQ_CREATE
 * Description  : Dynamic DQ_TEXT Register Batch (INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 04    DWOK/KHSONG      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:58
 * 파일: dbo.PR_DM_ADM_DQ_CREATE.sql
 * ----------------------------------------
 * ⚠ IF: IF:4  END IF:3  차이:+1
 * ⚠ BEGIN: BEGIN:1  END:3  차이:-2
 * ----------------------------------------
 * BEGIN 위치: L40
 * END;  위치: L72, L184
 * ----------------------------------------
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    n_history_seq INTEGER;
    v_program_name VARCHAR2(150 CHAR) := 'PR_DM_ADM_DQ_CREATE';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN







		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)

	-- -----------------------------------------------------------------------------------------
		BEGIN TRY
	-- -----------------------------------------------------------------------------------------
			--HISTORY INSERT INTO BEGIN
				PR_DM_ADM_DQ_CREATE_HIST
					 p_DQ_ID
					,p_DIVISION_ID
					,p_DQ_NAME
					,p_DESCRIPTION
					,p_DQ_TEXT
					,p_VALID_YN
					,p_ADMIN_ONLY_YN
					,p_CREATED_BY
					,p_LAST_UPDATED_BY
			END

			-- (2)
            /* INSERT */
            IF p_active_flag = 'I' THEN
        	n_history_seq := NEXT VALUE FOR SEQ1_SCM_ADM_DQ_LIST;
            INSERT INTO SCM_ADM_DQ_LIST
               (
                DQ_ID
               ,DIVISION_ID
               ,DQ_NAME
               ,DESCRIPTION
               ,DQ_TEXT
               ,VALID_YN
               ,ADMIN_ONLY_YN
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               )
         VALUES
               (
    	          n_history_seq
    	         ,p_DIVISION_ID
    	         ,p_DQ_NAME
    	         ,p_DESCRIPTION
    	         ,cast (p_DQ_TEXT as VARCHAR2(4000 CHAR))
    	         ,p_VALID_YN
    	         ,p_ADMIN_ONLY_YN
    	         ,p_CREATED_BY
    	         ,SYSTIMESTAMP
    	         ,p_last_updated_by
    	         ,SYSTIMESTAMP
    	         )
			END IF;
			-- (2)

			-- (3)
            /* UPDATE */
            IF p_active_flag = 'M' THEN
				UPDATE SCM_ADM_DQ_LIST
				SET
					DQ_ID             =   p_DQ_ID
				   ,DIVISION_ID       =   p_DIVISION_ID
				   ,DQ_NAME           =   p_DQ_NAME
				   ,DESCRIPTION       =   p_DESCRIPTION
				   ,DQ_TEXT             =   cast (p_DQ_TEXT as VARCHAR2(4000 CHAR))
				   ,VALID_YN          =   p_VALID_YN
				   ,ADMIN_ONLY_YN     =   p_ADMIN_ONLY_YN
				   --,CREATED_BY        =   p_CREATED_BY
				   ,LAST_UPDATED_BY   =   p_last_updated_by
				   ,LAST_UPDATE_DATE  =   SYSTIMESTAMP

				WHERE;
					   DQ_ID             =   p_DQ_ID
			END IF;
			-- (3)

			-- (4)
           /* DELETE */
           IF p_active_flag = 'D' THEN
			   DELETE
			   FROM SCM_ADM_DQ_LIST
			   WHERE;
					   DQ_ID             =   p_DQ_ID
 		   END IF;
			-- (4)

     -- IF @V_TRANCOUNT > 0

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
	-- -----------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
	-- -----------------------------------------------------------
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)

      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
      v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
      v_description := 'ERROR_LINE : '  ||  STR(NULL);
      d_event_date := SYSTIMESTAMP;

	  SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		--[C20200909-000203] LOG 표준화 적용
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- -----------------------------------------------------------
    END CATCH;
	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
     IF v_log_message IS NULL
	  SELECT 'success' AS CODE, n_history_seq AS SEQNO

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
  END;
/

-- ===== PR_DM_ADM_DQ_CREATE_COLUMN =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_COLUMN" 
(

	-- Add the parameters for the stored procedure here
	p_active_flag            VARCHAR2,
	p_DQ_ID                  VARCHAR2,
	p_COLUMN_NAME            VARCHAR2,
	p_VALUE_YN               VARCHAR2,
	p_VALUE_TYPE             VARCHAR2,
	p_VALID_YN               VARCHAR2,
	p_SEQNO                  VARCHAR2,
	p_CREATED_BY             VARCHAR2,
	--p_CREATION_DATE          VARCHAR2,
	p_LAST_UPDATED_BY        VARCHAR2
	--p_LAST_UPDATE_DATE       VARCHAR2,

)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:58
 * 파일: dbo.PR_DM_ADM_DQ_CREATE_COLUMN.sql
 * ----------------------------------------
 * ⚠ IF: IF:4  END IF:3  차이:+1
 * ⚠ BEGIN: BEGIN:1  END:3  차이:-2
 * ----------------------------------------
 * BEGIN 위치: L28
 * END;  위치: L132, L178
 * ----------------------------------------
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    n_history_seq INTEGER;
    v_program_name VARCHAR2(150 CHAR) := 'PR_DM_ADM_DQ_CREATE_COLUMN';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN







		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)

	-- -----------------------------------------------------------------------------------------
		BEGIN TRY
	-- -----------------------------------------------------------------------------------------
			-- (2)
            /* INSERT */
            IF p_active_flag = 'I' THEN

				   DELETE
				   FROM SCM_ADM_DQ_COLUMN
				   WHERE;
						   DQ_ID             =   p_DQ_ID
					   AND COLUMN_NAME       =   p_COLUMN_NAME;

                -- INSERT INTO 수행
				INSERT INTO SCM_ADM_DQ_COLUMN
				   (
					  DQ_ID
					 ,COLUMN_NAME
					 ,VALUE_YN
					 ,VALUE_TYPE
					 ,VALID_YN
					 ,CREATED_BY
					 ,CREATION_DATE
					 ,LAST_UPDATED_BY
					 ,LAST_UPDATE_DATE
					 , ATTRIBUTE1
					   )
				 VALUES
					   (
    					  p_DQ_ID
    					 ,P_COLUMN_NAME
    					 ,P_VALUE_YN
    					 ,P_VALUE_TYPE
    					 ,P_VALID_YN
    					 ,P_CREATED_BY
    					 ,SYSTIMESTAMP
						 ,P_LAST_UPDATED_BY
						 ,SYSTIMESTAMP
						 , p_SEQNO
    					 )
					END IF;
			-- (2)

			-- (3)
            /* UPDATE */
            IF p_active_flag = 'M' THEN
					UPDATE SCM_ADM_DQ_COLUMN

					SET
						DQ_ID            =   p_DQ_ID
					   ,COLUMN_NAME      =   P_COLUMN_NAME
					   ,VALUE_YN         =   p_VALUE_YN
					   ,VALUE_TYPE       =   p_VALUE_TYPE
					   ,VALID_YN         =   p_VALID_YN
					   --,CREATED_BY       =   p_CREATED_BY
					   ,LAST_UPDATED_BY  =   p_LAST_UPDATED_BY
					   ,LAST_UPDATE_DATE =   SYSTIMESTAMP
					   , ATTRIBUTE1 = p_SEQNO

					WHERE;
						   DQ_ID             =   p_DQ_ID
					   AND COLUMN_NAME       =   p_COLUMN_NAME;
				END IF;
			-- (3)

			-- (4)
           /* DELETE */
           IF p_active_flag = 'D' THEN

				   DELETE
				   FROM SCM_ADM_DQ_COLUMN
				   WHERE;
						   DQ_ID             =   p_DQ_ID
					   AND COLUMN_NAME       =   p_COLUMN_NAME;
			   END IF;
			-- (4)

			--HISTORY INSERT INTO BEGIN
				PR_DM_ADM_DQ_CREATE_COLUMN_HIST
					 p_DQ_ID
					,p_COLUMN_NAME
					,p_VALUE_YN
					,p_VALUE_TYPE
					,p_VALID_YN
					,p_CREATED_BY
					,p_LAST_UPDATED_BY
			END;

     -- IF @V_TRANCOUNT > 0

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
	-- -----------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
	-- -----------------------------------------------------------
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)

      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
      v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
      v_description := 'ERROR_LINE : '  ||  STR(NULL);
      d_event_date := SYSTIMESTAMP;

	  SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		--[C20200909-000203] LOG 표준화 적용
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- -----------------------------------------------------------
    END CATCH;
	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
     IF v_log_message IS NULL
	  SELECT 'success'

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
  END;
/

-- ===== PR_DM_ADM_DQ_CREATE_COLUMN_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_COLUMN_HIST" 
(
    P_DQ_ID                 IN  VARCHAR2,
    P_COLUMN_NAME           IN  VARCHAR2,
    P_VALUE_YN              IN  VARCHAR2,
    P_VALUE_TYPE            IN  VARCHAR2,
    P_VALID_YN              IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_LAST_UPDATED_BY       IN  VARCHAR2
    -- ,
    -- O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_COLUMN_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 05    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026.03.24     jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS
    V_HISTORY_SEQ       PLS_INTEGER;

    -- LOG 용 변수 설정
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    --------------------------------------------------------------------------------------------
    -- (1)
    /* HISTIRY INSERT */
    --------------------------------------------------------------------------------------------
    V_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_COLUMN_H.NEXTVAL;

    INSERT INTO SCM_MGR.SCM_ADM_DQ_COLUMN_H
    (
         HISTORY_SEQ
        ,DQ_ID
        ,COLUMN_NAME
        ,VALUE_YN
        ,VALUE_TYPE
        ,VALID_YN
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE
    )
    VALUES
    (
         V_HISTORY_SEQ
        ,P_DQ_ID
        ,P_COLUMN_NAME
        ,P_VALUE_YN
        ,P_VALUE_TYPE
        ,P_VALID_YN
        ,P_CREATED_BY
        ,SYSDATE
        ,P_LAST_UPDATED_BY
        ,SYSDATE
    );
    -- (1)

    N_LOG_COUNT := SQL%ROWCOUNT;

    -- COMMIT (종료 직전 1회)
    COMMIT;

    --OPEN O_RESULT_CURSOR FOR
    --SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    DBMS_OUTPUT.PUT_LINE($$PLSQL_UNIT||' executed successfully. '||TO_CHAR(N_LOG_COUNT)||' records were processed.');

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DQ_ID'           VALUE P_DQ_ID,
            'P_COLUMN_NAME'     VALUE P_COLUMN_NAME,
            'P_VALUE_YN'        VALUE P_VALUE_YN,
            'P_VALUE_TYPE'      VALUE P_VALUE_TYPE,
            'P_VALID_YN'        VALUE P_VALID_YN,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END PR_DM_ADM_DQ_CREATE_COLUMN_HIST;
/

-- ===== PR_DM_ADM_DQ_CREATE_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_HIST" 
(
      P_DQ_ID               IN VARCHAR2
    , P_DIVISION_ID         IN VARCHAR2
    , P_DQ_NAME             IN VARCHAR2
    , P_DESCRIPTION         IN VARCHAR2
    , P_DQ_TEXT             IN VARCHAR2
    , P_VALID_YN            IN VARCHAR2
    , P_ADMIN_ONLY_YN       IN VARCHAR2
    , P_CREATED_BY          IN VARCHAR2
    , P_LAST_UPDATED_BY     IN VARCHAR2
)
AS
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History      SKH_COLUMN_NAME1
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 05    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026/03/06     jcnam      [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
    N_HISTORY_SEQ   NUMBER(10);

    N_LOG_COUNT    PLS_INTEGER := 0;
    D_EVENT_DATE   DATE := SYSDATE;
    V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE    varchar2(4000);
    V_SQL_CODE     varchar2(100);
    V_SQL_ERRMSG   varchar2(1000);
    V_PROC_INPUT   VARCHAR2(4000 CHAR);
    V_LOG_MESSAGE  VARCHAR2(4000 CHAR);
    V_LOG_TYPE     VARCHAR2(30 CHAR) := 'E';
BEGIN
    V_LOG_TYPE     := 'START';
    V_LOG_MESSAGE  := '########## Start of procedure ##########';
    V_DESCRIPTION  := '';
    D_EVENT_DATE   := SYSDATE;

    BEGIN PR_SCM_SYS_LOG_BATCH_CALL_TRAN($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    V_LOG_MESSAGE := NULL;

    V_PROC_INPUT :=
        JSON_OBJECT(
              'p_DQ_ID'            VALUE P_DQ_ID
            , 'p_DIVISION_ID'      VALUE P_DIVISION_ID
            , 'p_DQ_NAME'          VALUE P_DQ_NAME
            , 'p_DESCRIPTION'      VALUE P_DESCRIPTION
            , 'p_DQ_TEXT'          VALUE P_DQ_TEXT
            , 'p_VALID_YN'         VALUE P_VALID_YN
            , 'p_ADMIN_ONLY_YN'    VALUE P_ADMIN_ONLY_YN
            , 'p_CREATED_BY'       VALUE P_CREATED_BY
            , 'p_LAST_UPDATED_BY'  VALUE P_LAST_UPDATED_BY
        );

    SELECT SEQ1_SCM_ADM_DQ_LIST_H.NEXTVAL
      INTO N_HISTORY_SEQ
      FROM DUAL;

    INSERT INTO SCM_ADM_DQ_LIST_H
    (
          HISTORY_SEQ
        , DQ_ID
        , DIVISION_ID
        , DQ_NAME
        , DESCRIPTION
        , DQ_TEXT
        , VALID_YN
        , ADMIN_ONLY_YN
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
    )
    VALUES
    (
          N_HISTORY_SEQ
        , P_DQ_ID
        , P_DIVISION_ID
        , P_DQ_NAME
        , P_DESCRIPTION
        , P_DQ_TEXT
        , P_VALID_YN
        , P_ADMIN_ONLY_YN
        , P_CREATED_BY
        , SYSDATE
        , P_LAST_UPDATED_BY
        , SYSDATE
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('success');

    V_LOG_TYPE     := 'END';
    V_LOG_MESSAGE  := '########## END of procedure ##########';
    V_DESCRIPTION  := '';
    D_EVENT_DATE   := SYSDATE;

    BEGIN PR_SCM_SYS_LOG_BATCH_CALL_TRAN($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
            ROLLBACK;
        END IF;

        dbms_output.put_line($$plsql_unit || ' ERROR');
        dbms_output.put_line('SQLCODE : ' || sqlcode);
        dbms_output.put_line('SQLERRM : ' || sqlerrm);
        dbms_output.put_line('BACKTRACE: ' || dbms_utility.format_error_backtrace);

        V_PROC_INPUT :=
            JSON_OBJECT(
                  'p_DQ_ID'            VALUE P_DQ_ID
                , 'p_DIVISION_ID'      VALUE P_DIVISION_ID
                , 'p_DQ_NAME'          VALUE P_DQ_NAME
                , 'p_DESCRIPTION'      VALUE P_DESCRIPTION
                , 'p_DQ_TEXT'          VALUE P_DQ_TEXT
                , 'p_VALID_YN'         VALUE P_VALID_YN
                , 'p_ADMIN_ONLY_YN'    VALUE P_ADMIN_ONLY_YN
                , 'p_CREATED_BY'       VALUE P_CREATED_BY
                , 'p_LAST_UPDATED_BY'  VALUE P_LAST_UPDATED_BY
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
                            V_LOG_TYPE,
                            N_LOG_COUNT,
                            V_LOG_MESSAGE,
                            V_DESCRIPTION,
                            D_EVENT_DATE,
                            V_PROC_INPUT,
                            V_SQL_CODE,
                            V_SQL_ERRMSG,
                            V_BACKTRACE
                            );
        -- RAISE;
END PR_DM_ADM_DQ_CREATE_HIST;
/

-- ===== PR_DM_ADM_DQ_CREATE_PARAMETER =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_PARAMETER" 
(

	-- Add the parameters for the stored procedure here
	p_active_flag            VARCHAR2,

	p_DQ_ID                  VARCHAR2,
	p_PARAMETER_ID           VARCHAR2,
	p_PARAMETER_TYPE         VARCHAR2,
	p_OPERATION_ID           VARCHAR2,
	p_VALID_YN               VARCHAR2,
	p_SEQNO                  VARCHAR2,
	p_REP_YN                 VARCHAR2,
	p_CREATED_BY             VARCHAR2,
	p_LAST_UPDATED_BY        VARCHAR2
	--p_CREATION_DATE          VARCHAR2,
	--p_LAST_UPDATE_DATE       VARCHAR2,


	--  PR_DM_ADM_DQ_CREATE_PARAMETER p_active_flag='M', p_DQ_ID='27', p_PARAMETER_ID='DIVISION_ID', p_PARAMETER_TYPE='Text', p_OPERATION_ID='', p_VALID_YN='Y', p_SEQNO='3', p_REP_YN='', p_CREATED_BY='20140001', p_LAST_UPDATED_BY='20140001'


)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:58
 * 파일: dbo.PR_DM_ADM_DQ_CREATE_PARAMETER.sql
 * ----------------------------------------
 * ⚠ IF: IF:4  END IF:3  차이:+1
 * ⚠ BEGIN: BEGIN:2  END:4  차이:-2
 * ----------------------------------------
 * BEGIN 위치: L34, L55
 * END;  위치: L146, L148, L193
 * ----------------------------------------
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    n_history_seq INTEGER;
    v_program_name VARCHAR2(150 CHAR) := 'PR_DM_ADM_DQ_CREATE_PARAMETER';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN







		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)

	-- -----------------------------------------------------------------------------------------
		BEGIN TRY
	-- -----------------------------------------------------------------------------------------
	BEGIN
			-- (2)
            /* INSERT INTO 수행인경우 */
            IF p_active_flag = 'I' THEN

			   -- INSERT전 PK값 삭제
			   DELETE
			   FROM SCM_ADM_DQ_PARAMETER
			   WHERE;
					   DQ_ID             =   p_DQ_ID
				   AND PARAMETER_ID      =   p_PARAMETER_ID;

				-- INSERT INTO 수행
        		--n_history_seq := NEXT VALUE FOR SEQ1_SCM_ADM_DQ_PARAMETER
				INSERT INTO SCM_ADM_DQ_PARAMETER
				   (
					  DQ_ID
					 ,PARAMETER_ID
					 ,PARAMETER_TYPE
					 ,OPERATION_ID
					 ,VALID_YN
					 ,REP_YN
					 ,CREATED_BY
					 ,CREATION_DATE
					 ,LAST_UPDATED_BY
					 ,LAST_UPDATE_DATE
					 , ATTRIBUTE1
					   )
			 VALUES
				   (
    				  p_DQ_ID
    				 ,P_PARAMETER_ID
    				 ,P_PARAMETER_TYPE
    				 ,P_OPERATION_ID
    				 ,P_VALID_YN
    				 ,P_REP_YN
    				 ,P_CREATED_BY
    				 ,SYSTIMESTAMP
				   ,P_LAST_UPDATED_BY
				   ,SYSTIMESTAMP
				   , p_SEQNO
    				 )
				END IF;
			-- (2)

			-- (3)
            /* UPDATE */
            IF p_active_flag = 'M' THEN

            UPDATE SCM_ADM_DQ_PARAMETER

            SET
                DQ_ID            =   p_DQ_ID
               ,PARAMETER_ID     =   p_PARAMETER_ID
               ,PARAMETER_TYPE   =   p_PARAMETER_TYPE
               ,OPERATION_ID     =   p_OPERATION_ID
               ,VALID_YN         =   p_VALID_YN
               ,REP_YN           =   p_REP_YN
               --,CREATED_BY       =   p_CREATED_BY
               ,LAST_UPDATED_BY  =   p_LAST_UPDATED_BY
               ,LAST_UPDATE_DATE =   SYSTIMESTAMP
			   , ATTRIBUTE1 = p_SEQNO

            WHERE;
                   DQ_ID             =   p_DQ_ID
               AND PARAMETER_ID      =   p_PARAMETER_ID;
			END IF;
			-- (3)

			-- (4)
           /* DELETE */
           IF p_active_flag = 'D' THEN

		   DELETE
           FROM SCM_ADM_DQ_PARAMETER
           WHERE;
                   DQ_ID             =   p_DQ_ID
               AND PARAMETER_ID      =   p_PARAMETER_ID;
		   END IF;
			-- (4)

			--HISTORY INSERT INTO BEGIN
				PR_DM_ADM_DQ_CREATE_PARAMETER_HIST
					 p_DQ_ID
					,p_PARAMETER_ID
					,p_PARAMETER_TYPE
					,p_OPERATION_ID
					,p_VALID_YN
					,p_REP_YN
					,p_CREATED_BY
					,p_LAST_UPDATED_BY
			END;

	END;
     -- IF @V_TRANCOUNT > 0

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
	-- -----------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
	-- -----------------------------------------------------------
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
      v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
      v_description := 'ERROR_LINE : '  ||  STR(NULL);
      d_event_date := SYSTIMESTAMP;

	  SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		--[C20200909-000203] LOG 표준화 적용
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);


	-- -----------------------------------------------------------
    END CATCH;
	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
     IF v_log_message IS NULL
	  SELECT 'success'

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
  END;
/

-- ===== PR_DM_ADM_DQ_CREATE_PARAMETER_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_PARAMETER_HIST" 
(
    P_DQ_ID                 IN  VARCHAR2,
    P_PARAMETER_ID          IN  VARCHAR2,
    P_PARAMETER_TYPE        IN  VARCHAR2,
    P_OPERATION_ID          IN  VARCHAR2,
    P_VALID_YN              IN  VARCHAR2,
    P_REP_YN                IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_LAST_UPDATED_BY       IN  VARCHAR2
    --,
    --O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_PARAMETER_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 05    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026.03.25     jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS
    V_HISTORY_SEQ       PLS_INTEGER;

    -- LOG 용 변수 설정
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    --------------------------------------------------------------------------------------------
    -- (1)
    /* HISTIRY INSERT */
    --------------------------------------------------------------------------------------------
    V_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_PARAMETER_H.NEXTVAL;

    INSERT INTO SCM_MGR.SCM_ADM_DQ_PARAMETER_H
    (
         HISTORY_SEQ
        ,DQ_ID
        ,PARAMETER_ID
        ,PARAMETER_TYPE
        ,OPERATION_ID
        ,VALID_YN
        ,REP_YN
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE
    )
    VALUES
    (
         V_HISTORY_SEQ
        ,P_DQ_ID
        ,P_PARAMETER_ID
        ,P_PARAMETER_TYPE
        ,P_OPERATION_ID
        ,P_VALID_YN
        ,P_REP_YN
        ,P_CREATED_BY
        ,SYSDATE
        ,P_LAST_UPDATED_BY
        ,SYSDATE
    );
    -- (2)

    N_LOG_COUNT := SQL%ROWCOUNT;

    -- COMMIT (종료 직전 1회)
    COMMIT;

    --OPEN O_RESULT_CURSOR FOR
    --SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    DBMS_OUTPUT.PUT_LINE($$PLSQL_UNIT||' executed successfully. '||TO_CHAR(N_LOG_COUNT)||' records were processed.');

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DQ_ID'            VALUE P_DQ_ID,
            'P_PARAMETER_ID'     VALUE P_PARAMETER_ID,
            'P_PARAMETER_TYPE'   VALUE P_PARAMETER_TYPE,
            'P_OPERATION_ID'     VALUE P_OPERATION_ID,
            'P_VALID_YN'         VALUE P_VALID_YN,
            'P_REP_YN'           VALUE P_REP_YN,
            'P_CREATED_BY'       VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY'  VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END PR_DM_ADM_DQ_CREATE_PARAMETER_HIST;
/

-- ===== PR_DM_ADM_DQ_CREATE_USER_GROUP =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_USER_GROUP" 
(
	p_DQ_ID                  VARCHAR2,    -- 단일값 INPUT (ex : 1)
	p_GROUP_ID               VARCHAR2,    -- 다중값 INPUT (ex : A,B,C)
	p_VALID_YN               VARCHAR2,    -- 단일값 INPUT (ex : Y)
	p_CREATED_BY             VARCHAR2,    -- 단일값 INPUT (ex : Tester)
	p_LAST_UPDATED_BY        VARCHAR2     -- 단일값 INPUT (ex : Tester)
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_USER_GROUP
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_USER_GROUP' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 04    DWOK/KHSONG      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:58
 * 파일: dbo.PR_DM_ADM_DQ_CREATE_USER_GROUP.sql
 * ----------------------------------------
 * ⚠ IF: IF:3  END IF:0  차이:+3
 * ⚠ BEGIN: BEGIN:6  END:8  차이:-2
 * ----------------------------------------
 * BEGIN 위치: L36, L72, L79, L99, L103, L119
 * END;  위치: L84, L96, L112, L141, L142, L144, L184
 * ----------------------------------------
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    n_history_seq INTEGER;
    v_delete_cnt INTEGER := 0;
    v_recv_GROUP_ID VARCHAR2(4000 CHAR);
    v_GROUP_ID VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_program_name VARCHAR2(150 CHAR) := 'PR_DM_ADM_DQ_CREATE_USER_GROUP';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN



	v_recv_GROUP_ID := NULL;
	v_recv_GROUP_ID := p_GROUP_ID;



	v_delimiter := ','; -- 데이터 구분자








    v_GROUP_ID := NULL;

	-- 시작 LOG  (START)
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/


	BEGIN TRY
		-- 프로시저 LOOP 길이를 판단
		v_max_loop_cnt := SCM_ARR_SPL_CNT(p_GROUP_ID, v_delimiter);
		SELECT v_max_loop_cnt
		FROM DUAL;

		WHILE LENGTH(v_recv_GROUP_ID) > 0 AND v_mst_loop_cnt < v_max_loop_cnt
		BEGIN
			SELECT v_max_loop_cnt AS max_loop_cnt
			-- v_mst_loop_cnt 1증가
			v_mst_loop_cnt := v_mst_loop_cnt || 1
			FROM DUAL;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				v_GROUP_ID := SCM_ARR_SPL_VAL (p_GROUP_ID, v_delimiter , v_mst_loop_cnt) ;

				-- 확인용 변수값 DISPLAY
				SELECT v_GROUP_ID AS v_GROUP_ID
			END
			/*--------- MULTI & SINGLE ROW START --------*/

			/*-- max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행하도록함 --*/
			IF       v_mst_loop_cnt <= v_max_loop_cnt
			--HISTORY INSERT INTO BEGIN
				PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST
						p_DQ_ID
					,v_GROUP_ID
					,p_VALID_YN
					,p_CREATED_BY
					,p_LAST_UPDATED_BY
			END

			-- (1)
			BEGIN

				-- 첫번째 DQ_ID 값 기준으로 delete 수행
				IF  v_mst_loop_cnt = 1
				BEGIN
					DELETE
					FROM SCM_ADM_DQ_USER_GROUP
						WHERE 1=1
						AND  DQ_ID     =   p_DQ_ID;
					-- 확인용
					v_delete_cnt := v_delete_cnt || 1
					select    v_delete_cnt  as   delete_cnt
					-- 확인용
				END

			-- (2)
				/* INSERT */
        		--n_history_seq := NEXT VALUE FOR SEQ1_SCM_ADM_DQ_USER_GROUP

				-- INSERT INTO 수행
				BEGIN
					INSERT INTO SCM_ADM_DQ_USER_GROUP
							(
							DQ_ID
							,GROUP_ID
							,VALID_YN
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE

							)
					VALUES
							(
    						p_DQ_ID
    						,v_GROUP_ID
    						,p_VALID_YN
    						,p_CREATED_BY
    						,SYSTIMESTAMP
							,p_LAST_UPDATED_BY
							,SYSTIMESTAMP
    						)
				END;
			END;
			-- (1)
		END;
		-- (0)
		-- IF @V_TRANCOUNT > 0

  	-- 트랜잭션 (COMMIT)
		COMMIT WORK;

	-- END TRY

    EXCEPTION
        WHEN OTHERS THEN

		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)

		v_log_type := 'ERROR';
		v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
		v_description := 'ERROR_LINE : '  ||  STR(NULL);
		d_event_date := SYSTIMESTAMP;

		SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		--[C20200909-000203] LOG 표준화 적용
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    END CATCH;

	-- 수행결과 성공여부 DISPLAY
     IF v_log_message IS NULL
	  SELECT 'success'

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
  END;
/

-- ===== PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE" 
(
    P_DQ_ID                 IN  VARCHAR2,     -- 단일값 INPUT (ex : 1)
    P_GROUP_ID              IN  VARCHAR2,     -- 다중값 INPUT (ex : A,B,C)
    P_VALID_YN              IN  VARCHAR2,     -- 단일값 INPUT (ex : Y)
    P_CREATED_BY            IN  VARCHAR2,     -- 단일값 INPUT (ex : Tester)
    P_LAST_UPDATED_BY       IN  VARCHAR2     -- 단일값 INPUT (ex : Tester)
    -- O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_USER_GROUP' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 04    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026.03.25     jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS
    V_HISTORY_SEQ       PLS_INTEGER;
    V_DELETE_CNT        PLS_INTEGER := 0;

    -- LOG 용 변수 설정
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    --------------------------------------------------------------------------------------------
    -- MSSQL 원본은 다중값 GROUP_ID를 루프 돌면서 첫번째 루프에서만 DQ_ID 기준 DELETE 수행
    -- Oracle 변환: 루프 불필요, DQ_ID 기준 단건 DELETE로 단순화
    --------------------------------------------------------------------------------------------

    -- 첫번째 DQ_ID 값 기준으로 delete 수행
    DELETE
    FROM SCM_MGR.SCM_ADM_DQ_USER_GROUP
    WHERE DQ_ID = P_DQ_ID;

    V_DELETE_CNT := SQL%ROWCOUNT;
    N_LOG_COUNT  := V_DELETE_CNT;

    -- COMMIT (종료 직전 1회)
    COMMIT;

    --OPEN O_RESULT_CURSOR FOR
    --SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    DBMS_OUTPUT.PUT_LINE($$PLSQL_UNIT||' executed successfully. '||TO_CHAR(N_LOG_COUNT)||' records were processed.');

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DQ_ID'           VALUE P_DQ_ID,
            'P_GROUP_ID'        VALUE P_GROUP_ID,
            'P_VALID_YN'        VALUE P_VALID_YN,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE;
/

-- ===== PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST" 
(
    p_DQ_ID                IN VARCHAR2,
    p_GROUP_ID             IN VARCHAR2,
    p_VALID_YN             IN VARCHAR2,
    p_CREATED_BY           IN VARCHAR2,
    p_LAST_UPDATED_BY      IN VARCHAR2
)
AS
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 05    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026/03/06     jcnam      [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
    n_history_seq   PLS_INTEGER;
    N_LOG_COUNT    PLS_INTEGER := 0;
    D_EVENT_DATE   DATE := SYSDATE;
    V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE    varchar2(4000);
    V_SQL_CODE     varchar2(100);
    V_SQL_ERRMSG   varchar2(1000);
    V_PROC_INPUT   VARCHAR2(4000 CHAR);
    V_LOG_MESSAGE  VARCHAR2(4000 CHAR);
    V_LOG_TYPE     VARCHAR2(30 CHAR) := 'E';
BEGIN
    v_log_type     := 'START';
    v_log_message  := '########## Start of procedure ##########';
    v_description  := '';
    d_event_date   := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    v_log_message := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    BEGIN
        n_history_seq := SEQ1_SCM_ADM_DQ_USER_GROUP_H.NEXTVAL;

        INSERT INTO SCM_ADM_DQ_USER_GROUP_H
        (
            HISTORY_SEQ,
            DQ_ID,
            GROUP_ID,
            VALID_YN,
            CREATED_BY,
            CREATION_DATE,
            LAST_UPDATED_BY,
            LAST_UPDATE_DATE
        )
        VALUES
        (
            n_history_seq,
            p_DQ_ID,
            p_GROUP_ID,
            p_VALID_YN,
            p_CREATED_BY,
            SYSDATE,
            p_LAST_UPDATED_BY,
            SYSDATE
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
                ROLLBACK;
            END IF;

            dbms_output.put_line($$plsql_unit || ' ERROR');
            dbms_output.put_line('SQLCODE : ' || sqlcode);
            dbms_output.put_line('SQLERRM : ' || sqlerrm);
            dbms_output.put_line('BACKTRACE: ' || dbms_utility.format_error_backtrace);

            V_LOG_MESSAGE := 'EXCEPTION';
            V_PROC_INPUT :=
                JSON_OBJECT(
                    'p_DQ_ID'           VALUE p_DQ_ID,
                    'p_GROUP_ID'        VALUE p_GROUP_ID,
                    'p_VALID_YN'        VALUE p_VALID_YN,
                    'p_CREATED_BY'      VALUE p_CREATED_BY,
                    'p_LAST_UPDATED_BY' VALUE p_LAST_UPDATED_BY
            );
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
                                V_LOG_TYPE,
                                N_LOG_COUNT,
                                V_LOG_MESSAGE,
                                V_DESCRIPTION,
                                D_EVENT_DATE,
                                V_PROC_INPUT,
                                V_SQL_CODE,
                                V_SQL_ERRMSG,
                                V_BACKTRACE
                                );
            RAISE;
    END;

    IF v_log_message IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('success');
    END IF;

    v_log_type     := 'END';
    v_log_message  := '########## END of procedure ##########';
    v_description  := '';
    d_event_date   := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
END;
/

-- ===== PR_DM_ADM_DQ_EXECUTE_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_DM_ADM_DQ_EXECUTE_HIST" 
(
    P_DQ_ID                 IN  VARCHAR2,
    P_DQ_TEXT               IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_LAST_UPDATED_BY       IN  VARCHAR2
    -- ,
    -- O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_EXECUTE_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 05    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026.03.25     jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS
    V_HISTORY_SEQ       PLS_INTEGER;

    -- LOG 용 변수 설정
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    --------------------------------------------------------------------------------------------
    -- (1)
    /* HISTIRY INSERT */
    --------------------------------------------------------------------------------------------
    V_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_EXECUTE_H.NEXTVAL;

    INSERT INTO SCM_MGR.SCM_ADM_DQ_EXECUTE_H
    (
         HISTORY_SEQ
        ,DQ_ID
        ,DQ_TEXT
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE
    )
    VALUES
    (
         V_HISTORY_SEQ
        ,P_DQ_ID
        ,P_DQ_TEXT
        ,P_CREATED_BY
        ,SYSDATE
        ,P_LAST_UPDATED_BY
        ,SYSDATE
    );
    -- (1)

    N_LOG_COUNT := SQL%ROWCOUNT;

    -- COMMIT (종료 직전 1회)
    COMMIT;

    --OPEN O_RESULT_CURSOR FOR
    --SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    DBMS_OUTPUT.PUT_LINE($$PLSQL_UNIT||' executed successfully. '||TO_CHAR(N_LOG_COUNT)||' records were processed.');

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DQ_ID'           VALUE P_DQ_ID,
            'P_DQ_TEXT'         VALUE SUBSTR(P_DQ_TEXT, 1, 500),
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END PR_DM_ADM_DQ_EXECUTE_HIST;
/
