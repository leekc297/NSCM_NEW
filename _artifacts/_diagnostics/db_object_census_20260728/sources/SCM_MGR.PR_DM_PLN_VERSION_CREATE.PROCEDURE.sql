PROCEDURE         PR_DM_PLN_VERSION_CREATE

(
	P_DIVISION_ID		IN  CLOB,
	P_VER_DESCRIPTION   IN  CLOB,
	P_VER_TYPE			IN  CLOB,
	P_CREATED_BY		IN  CLOB,
	P_VER_RETURN_NO		OUT VARCHAR2,		-- 생성요청 버전넘버
	P_OK_DESCRIPTION	OUT VARCHAR2		-- 생성요청 버전넘버
)
/****************************************************************************************************/
/* Program ID  : [PR_DM_PLN_VERSION_CREATE]                                                   */
/* Description : PR_DM_PLN_VERSION_CREATE INSERT	                                                  */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/12/09  DWOK/DWPARK  Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용                                      */
/* 2026.06.02     ZIONEX		[PJ202650304] NextSCM Migration                                        */
/*                                                                                                  */
/****************************************************************************************************/
AS
	-- SET XACT_ABORT ON; SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- MSSQL 세션설정, Oracle 불필요

	N_VERSION_NO		INTEGER;
	V_VERSION_SEQ		VARCHAR2(40 CHAR);

	-- LOG 용 변수 설정
	V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'PR_DM_PLN_VERSION_CREATE';
	V_LOG_TYPE     VARCHAR2(30 CHAR);  -- START/END/ERROR/...
	N_LOG_COUNT    INTEGER := 0;
	V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
	V_DESCRIPTION  VARCHAR2(500 CHAR);
	D_EVENT_DATE   DATE;

	-- CLOB 파라미터를 SQL 비교/INSERT(VARCHAR2 컬럼)에 쓰기 위한 로컬 (CLOB=VARCHAR2 비교 ORA-00932 회피)
	L_DIVISION_ID      VARCHAR2(120 CHAR);
	L_VER_DESCRIPTION  VARCHAR2(4000 CHAR);
	L_VER_TYPE         VARCHAR2(200 CHAR);
	L_CREATED_BY       VARCHAR2(600 CHAR);
BEGIN

	L_DIVISION_ID     := P_DIVISION_ID;
	L_VER_DESCRIPTION := P_VER_DESCRIPTION;
	L_VER_TYPE        := P_VER_TYPE;
	L_CREATED_BY      := P_CREATED_BY;

	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	V_LOG_TYPE    := 'START';
	V_LOG_MESSAGE := '########## Start of procedure ##########';
	V_DESCRIPTION := '';
	D_EVENT_DATE  := SYSDATE;
	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


	-- 트랜잭션 (START)
	SAVEPOINT PR_DM_PLN_VERSION_CREATE;

	BEGIN


			BEGIN

				SELECT
						CASE
						WHEN	MAX(A.VERSION_NEXT) IS NULL THEN  1
						ELSE	MAX(A.VERSION_NEXT)+1
						END  AS VERSION_NEXT
					INTO N_VERSION_NO
					FROM
					(
						SELECT DIVISION_ID
							  ,VERSION_TYPE
							  ,YYYYMMDD
							  ,MAX(VER_CRE_SEQ) AS VERSION_NEXT
						FROM DM_MST_VERSION
						WHERE
								DIVISION_ID = L_DIVISION_ID	AND
								VERSION_TYPE = L_VER_TYPE	AND
								YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
						GROUP BY
								DIVISION_ID,
								VERSION_TYPE,
								YYYYMMDD
					) A
					;

				V_VERSION_SEQ :=
						L_VER_TYPE
						|| '_' ||
						TO_CHAR(SYSDATE, 'YYYYMMDD')
						|| '_V' ||
						LPAD(TO_CHAR(N_VERSION_NO), 3, '0')
					;
				   BEGIN

						INSERT	INTO  DM_MST_VERSION
						(
									DIVISION_ID,
									VERSION_NO,
									VERSION_DESCRIPTION,
									VERSION_TYPE,
									YYYYMMDD,
									VER_CRE_SEQ,
									CREATED_BY,
									CREATION_DATE,
									LAST_UPDATED_BY,
									LAST_UPDATE_DATE
						)
						VALUES
						(
									 L_DIVISION_ID,
									 V_VERSION_SEQ,
									 L_VER_DESCRIPTION,
									 L_VER_TYPE,
									 TO_CHAR(SYSDATE, 'YYYYMMDD'),
									 N_VERSION_NO,
									 L_CREATED_BY,
									 SYSDATE,
									 L_CREATED_BY,
									 SYSDATE
						);

				   END;


				   --SELECT @n_version_seq	Output;


				   -- 정상채번 경우
					P_VER_RETURN_NO := V_VERSION_SEQ;

					P_OK_DESCRIPTION := 'OK';

					COMMIT;

					--RETURN;


			END;


	--[C20200909-000203] LOG 표준화 적용
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO SAVEPOINT PR_DM_PLN_VERSION_CREATE;   /* ROLLBACK TRANSACTION PR_DM_PLN_VERSION_CREATE; */

		V_LOG_TYPE    := 'ERROR';
		V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);                                       -- ERROR_MESSAGE()
		V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);  -- STR(ERROR_LINE())
		D_EVENT_DATE  := SYSDATE;
		-- 원본: SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  (내부 proc → DBMS_OUTPUT 표시)
		DBMS_OUTPUT.PUT_LINE('[' || TO_CHAR(SQLCODE) || ']' || SQLERRM);

		--[C20200909-000203] LOG 표준화 적용
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
							, P_SQL_ERR_CODE  => TO_CHAR(SQLCODE)
							, P_SQL_ERR_MSG   => SQLERRM
							, P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

	END;

	-- 종료 LOG
	V_LOG_TYPE    := 'END';
	V_LOG_MESSAGE := '########## END of procedure ##########';
	V_DESCRIPTION := '';
	D_EVENT_DATE  := SYSDATE;
	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END;