CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0042_SAVE_DM_BP_EXCHANGE_RATE" 
(
    p_active_flag            VARCHAR2,
	p_division_id            VARCHAR2,
    p_YYYYMMDD               VARCHAR2,
    p_CURRENCY               VARCHAR2,
    p_UNIT_CURRENCY          VARCHAR2,
    p_EXCHANGE_PRICE         VARCHAR2,
    p_CREATED_BY             VARCHAR2,
    p_LAST_UPDATED_BY        VARCHAR2
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0042_SAVE_DM_BP_EXCHANGE_RATE
 * Description  : Business Plan DM_BP_EXCHANGE_RATE TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190410 KHSONG Initial Release PJ20189106 전지본부 GSCM(DM) 고도화 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026/03/15     김준규		[PJ20264226] NextSCM Pilot 설계 및 개발
 *
 *
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-13 17:03:31
 * 파일: DMF0042_SAVE_DM_BP_EXCHANGE_RATE.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:2  END:3  차이:-1
 * ----------------------------------------
 * IF 위치:     L123, L192, L313, L329
 * END IF 위치: L190, L196, L338, L340
 * BEGIN 위치:  L56, L201
 * END;  위치:  L214, L277, L342
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * LOOP 위치:     L111
 * END LOOP 위치: L197
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_recv_active_flag VARCHAR2(4000 CHAR);
    v_active_flag VARCHAR2(4000 CHAR);
    v_division_id VARCHAR2(4000 CHAR);
    v_YYYYMMDD VARCHAR2(4000 CHAR);
    v_CURRENCY VARCHAR2(4000 CHAR);
    v_UNIT_CURRENCY VARCHAR2(4000 CHAR);
    v_EXCHANGE_PRICE VARCHAR2(4000 CHAR);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_merge_count INTEGER := 0;
    v_index_active_flag INTEGER;
    v_index_division_id INTEGER;
    v_index_YYYYMMDD INTEGER;
    v_index_CURRENCY INTEGER;
    v_index_UNIT_CURRENCY INTEGER;
    v_index_EXCHANGE_PRICE INTEGER;
    v_index_CREATED_BY INTEGER;
    v_index_LAST_UPDATED_BY INTEGER;
    v_in_para_data VARCHAR2(4000);
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_active_flag' VALUE p_active_flag,
            'p_division_id' VALUE p_division_id,
            'p_YYYYMMDD' VALUE p_YYYYMMDD,
            'p_CURRENCY' VALUE p_CURRENCY,
            'p_UNIT_CURRENCY' VALUE p_UNIT_CURRENCY,
            'p_EXCHANGE_PRICE' VALUE p_EXCHANGE_PRICE,
            'p_CREATED_BY' VALUE p_CREATED_BY,
            'p_LAST_UPDATED_BY' VALUE p_LAST_UPDATED_BY
          );

	-- 스플릿관련 변수
	v_recv_active_flag := NULL;
	v_recv_active_flag := p_active_flag;

    v_active_flag := NULL;
    v_division_id := NULL;
    v_YYYYMMDD := NULL;
    v_CURRENCY := NULL;
    v_UNIT_CURRENCY := NULL;
    v_EXCHANGE_PRICE := NULL;
    v_CREATED_BY := NULL;
    v_LAST_UPDATED_BY := NULL;

	v_delimiter := '^'; -- 데이터 구분자

	v_active_flag := RTRIM(p_active_flag     )  ||  '^';
	v_division_id := RTRIM(p_division_id     )  ||  '^';
	v_YYYYMMDD := RTRIM(p_YYYYMMDD        )  ||  '^';
	v_CURRENCY := RTRIM(p_CURRENCY        )  ||  '^';
	v_UNIT_CURRENCY := RTRIM(p_UNIT_CURRENCY   )  ||  '^';
	v_EXCHANGE_PRICE := RTRIM(p_EXCHANGE_PRICE  )  ||  '^';
	v_CREATED_BY := RTRIM(p_CREATED_BY      )  ||  '^';
	v_LAST_UPDATED_BY := RTRIM(p_LAST_UPDATED_BY )  ||  '^';

	-- LOG 용 변수 설정
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDBE_RESULTS';

		-- 시작 LOG  (START)
		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
		v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)
		-- 트랜잭션 (START)
	-- -----------------------------------------------------------------------------------------
		-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
	-- -----------------------------------------------------------------------------------------
--###############################################  GT_SDBE_RESULTS 테이블에 split후 insert (START)
WHILE LENGTH(v_DIVISION_ID) > 0 LOOP

    v_index_active_flag := INSTR(v_active_flag, '^');
	v_index_division_id := INSTR(v_division_id, '^');
	v_index_YYYYMMDD := INSTR(v_YYYYMMDD, '^');
	v_index_CURRENCY := INSTR(v_CURRENCY, '^');
	v_index_UNIT_CURRENCY := INSTR(v_UNIT_CURRENCY, '^');
	v_index_EXCHANGE_PRICE := INSTR(v_EXCHANGE_PRICE, '^');
	v_index_CREATED_BY := INSTR(v_CREATED_BY, '^');
	v_index_LAST_UPDATED_BY := INSTR(v_LAST_UPDATED_BY, '^');

	--확인  select v_index_DIVISION_ID as 'v_index_DIVISION_ID';
    IF v_index_DIVISION_ID > 0 THEN
			v_active_flag := SUBSTR(v_active_flag, 1, v_index_active_flag - 1);
			v_active_flag := SUBSTR(v_active_flag, LENGTH(v_active_flag  ||  '^') + 1);

			v_DIVISION_ID := SUBSTR(v_DIVISION_ID, 1, v_index_DIVISION_ID - 1);
			v_DIVISION_ID := SUBSTR(v_DIVISION_ID, LENGTH(v_DIVISION_ID  ||  '^') + 1);

			v_YYYYMMDD := SUBSTR(v_YYYYMMDD, 1, v_index_YYYYMMDD - 1);
			v_YYYYMMDD := SUBSTR(v_YYYYMMDD, LENGTH(v_YYYYMMDD  ||  '^') + 1);

			v_CURRENCY := SUBSTR(v_CURRENCY, 1, v_index_CURRENCY - 1);
			v_CURRENCY := SUBSTR(v_CURRENCY, LENGTH(v_CURRENCY  ||  '^') + 1);

			v_UNIT_CURRENCY := SUBSTR(v_UNIT_CURRENCY, 1, v_index_UNIT_CURRENCY - 1);
			v_UNIT_CURRENCY := SUBSTR(v_UNIT_CURRENCY, LENGTH(v_UNIT_CURRENCY  ||  '^') + 1);

			v_EXCHANGE_PRICE := SUBSTR(v_EXCHANGE_PRICE, 1, v_index_EXCHANGE_PRICE - 1);
			v_EXCHANGE_PRICE := SUBSTR(v_EXCHANGE_PRICE, LENGTH(v_EXCHANGE_PRICE || '^') + 1);

			v_CREATED_BY := SUBSTR(v_CREATED_BY, 1, v_index_CREATED_BY - 1);
			v_CREATED_BY := SUBSTR(v_CREATED_BY, LENGTH(v_CREATED_BY  ||  '^') + 1);

			v_LAST_UPDATED_BY := SUBSTR(v_LAST_UPDATED_BY, 1, v_index_LAST_UPDATED_BY - 1);
			v_LAST_UPDATED_BY := SUBSTR(v_LAST_UPDATED_BY, LENGTH(v_LAST_UPDATED_BY  ||  '^') + 1);

			INSERT INTO GT_SDBE_RESULTS (
			                         active_flag
									,division_id
									,YYYYMMDD
									,CURRENCY
									,UNIT_CURRENCY
									,EXCHANGE_PRICE
									,CREATED_BY
									,LAST_UPDATED_BY
			) VALUES (
			                         v_active_flag
									,v_division_id
									,v_YYYYMMDD
									,v_CURRENCY
									,v_UNIT_CURRENCY
									,v_EXCHANGE_PRICE
									,v_CREATED_BY
									,v_LAST_UPDATED_BY
			);
    ELSE
			v_DIVISION_ID := p_DIVISION_ID;

			INSERT INTO GT_SDBE_RESULTS (
			                         active_flag
									,division_id
									,YYYYMMDD
									,CURRENCY
									,UNIT_CURRENCY
									,EXCHANGE_PRICE
									,CREATED_BY
									,LAST_UPDATED_BY
			) VALUES (
			                         v_active_flag
									,v_division_id
									,v_YYYYMMDD
									,v_CURRENCY
									,v_UNIT_CURRENCY
									,v_EXCHANGE_PRICE
									,v_CREATED_BY
									,v_LAST_UPDATED_BY
			);
		END IF;
			-- Division_id Null Validation
			SELECT COUNT(1) INTO v_max_loop_cnt FROM SCM_MST_DIVISION  WHERE 1=1
									  AND DIVISION_ID = v_DIVISION_ID;
			IF v_max_loop_cnt = 0 THEN
					v_log_type := 'INVALID';
					GOTO ERR_RTN;
				END IF;
END LOOP;

	--###############################################   GT_SDBE_RESULTS 테이블에 split후 insert (END)
--===================================================================================== DELETE FROM start
BEGIN
		   --  select * from GT_SDBE_RESULTS
		   DELETE
           FROM DM_BP_EXCHANGE_RATE
           WHERE exists(
                    SELECT DIVISION_ID
					  FROM GT_SDBE_RESULTS
					 where active_flag      = 'D'
                       and DM_BP_EXCHANGE_RATE.DIVISION_ID        =   DIVISION_ID
                       AND DM_BP_EXCHANGE_RATE.YYYYMMDD           =   YYYYMMDD
                       AND DM_BP_EXCHANGE_RATE.CURRENCY           =   CURRENCY
                       AND DM_BP_EXCHANGE_RATE.UNIT_CURRENCY      =   UNIT_CURRENCY
				  );
END;
--===================================================================================== DELETE FROM end
--===================================================================================== update, INSERT INTO start

					MERGE INTO DM_BP_EXCHANGE_RATE A
					USING (
							SELECT
								     division_id
								    ,YYYYMMDD
								    ,CURRENCY
								    ,UNIT_CURRENCY
								    ,max(EXCHANGE_PRICE) EXCHANGE_PRICE
									,max(CREATED_BY) CREATED_BY
									,max(LAST_UPDATED_BY) LAST_UPDATED_BY
                             FROM  GT_SDBE_RESULTS  WHERE active_flag <> 'D'   -- DELETE값이 아닌경우만
                          group by   division_id
								    ,YYYYMMDD
								    ,CURRENCY
								    ,UNIT_CURRENCY
						  ) B
					ON(
                                A.division_id        =   B.division_id
                            AND A.YYYYMMDD           =   B.YYYYMMDD
                            AND A.CURRENCY           =   B.CURRENCY
                            AND A.UNIT_CURRENCY      =   B.UNIT_CURRENCY
					  )
					WHEN MATCHED THEN
						 UPDATE SET
 									 EXCHANGE_PRICE      =  b.EXCHANGE_PRICE
									,CREATED_BY          =  b.CREATED_BY
									,CREATION_DATE       =  SYSTIMESTAMP	--,CREATION_DATE       =  v_CREATION_DATE
									,LAST_UPDATED_BY     =  b.LAST_UPDATED_BY
									,LAST_UPDATE_DATE    =  SYSTIMESTAMP

					WHEN NOT MATCHED THEN

					     INSERT
								  ( division_id
								   ,YYYYMMDD
								   ,CURRENCY
								   ,UNIT_CURRENCY
								   ,EXCHANGE_PRICE
								   ,CREATED_BY
								   ,CREATION_DATE
								   ,LAST_UPDATED_BY
								   ,LAST_UPDATE_DATE
								)
						 VALUES (
									b.division_id
								   ,b.YYYYMMDD
								   ,b.CURRENCY
								   ,b.UNIT_CURRENCY
								   ,b.EXCHANGE_PRICE
								   ,b.CREATED_BY
								   ,SYSTIMESTAMP
								   ,b.LAST_UPDATED_BY
								   ,SYSTIMESTAMP
								);

--
--===================================================================================== update, INSERT INTO end
     -- IF 0 > 0
  	-- 트랜잭션 (COMMIT)
        COMMIT;

	-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------

<<ERR_RTN>>
	-- 수행결과 성공여부 DISPLAY
     IF v_log_message IS NULL THEN
	  SELECT 'success'
	  INTO v_description FROM DUAL;

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
    d_event_date := SYSTIMESTAMP;

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );

	END IF;

	IF v_log_type = 'INVALID' THEN
						v_log_message := '########## END of procedure ##########';
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
			SELECT 'Division 값이 존재하지 않습니다.'
			INTO v_description FROM DUAL;
		END IF;

	-- -----------------------------------------------------------
    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
	-- -----------------------------------------------------------
	  --[C20200909-000203] LOG 표준화 적용
	  -- 트랜잭션 (END)
	        -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
      v_log_message := SUBSTR(SQLERRM, 1, 1000);
      v_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
      d_event_date := SYSTIMESTAMP;

	  v_log_message := '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		--[C20200909-000203] LOG 표준화 적용
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data  => v_in_para_data,
        p_sql_err_code  => SQLCODE,
        p_sql_err_msg   => SQLERRM,
        p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );

	-- -----------------------------------------------------------
    -- END CATCH
	-- -----------------------------------------------------------
    RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || v_in_para_data
    );
END;
/
