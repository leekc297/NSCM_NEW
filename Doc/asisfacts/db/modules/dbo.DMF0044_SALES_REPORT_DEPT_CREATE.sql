---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




/*
 * Program ID   : DMF0044_SALES_REPORT_DEPT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191021 kyh    rownumber 가 group by 랑 같이있어서 중복오류, Group By 에 Data_Type 제거 - 수정함
 * 20191023 kyh    Department_Name 가져오는 로직을 Sales Report 와 동일하게 Lookup 을 보도록 수정
 * 20191113 KYH		PACK 일 경우 수량환산
 * 20191118 hwi1993 파라미터 추가 및 데이터타입 변경 및 Cancel 기능 추가
 * 20200512 hwi1993 ETC 매출 테이블 추가
 * 20200525 hwi1993 소형 1~3 담당 외에는 기타로 묶음.
 * 20200610 hwi1993	ETC Data 중 Product Detail 이 빠지는 문제 수정 
 * 20210716	HWI1993	상반기과제 ( GDW 마스터정비 ) bp 메저관련 및 기간조정
   20220616 hwi1993 [C20220608-000333] GDW 전송시 버전 종류에 따른 데이터 오류 수정 요청의 건

 */
CREATE PROCEDURE [dbo].[DMF0044_SALES_REPORT_DEPT_CREATE]
	@p_division_id            NVARCHAR(30),
	@p_version_no             NVARCHAR(50),
	@p_action_type            NVARCHAR(1),		-- T:Transfer, C:Cancel
	@p_yyyy                   NVARCHAR(4)

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[DMF0044_SALES_REPORT_PRODUCT_CREATE]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_merge_count     INTEGER = 0;

    -- local 변수선언
    DECLARE @yyyy           NVARCHAR(4);
    DECLARE @user_id        NVARCHAR(10) = 'mdf_batch';
    DECLARE @getdate        NVARCHAR(50) = GETDATE();
    DECLARE @ori_version_no NVARCHAR(50);
	DECLARE @V_SP_BP		NVARCHAR(2);
    

	
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	---------------------------------------------------------------------------------------------------------------------------	
	BEGIN TRY
	---------------------------------------------------------------------------------------------------------------------------	

		----------------------------------------------------------------------------------------------------- 
		--                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
		-----------------------------------------------------------------------------------------------------
		IF EXISTS ( SELECT 1 FROM DM_MOBILE_REPORT_DEPT WITH (NOLOCK) WHERE 1=1
									AND DIVISION_ID = @p_division_id
									AND VERSION_NO  = @p_version_no ) 
			BEGIN 
				DELETE FROM DM_MOBILE_REPORT_DEPT WHERE 1=1 
					AND DIVISION_ID = @p_division_id
					AND VERSION_NO  = @p_version_no
			END
		----------------------------------------------------------------------------------------------------- 
		--                              중복 VERSION이 있는경우 삭제후 COPY (END)
		-----------------------------------------------------------------------------------------------------

		----------------------------------------------------------------------------------------------------- 
		--                           요청VERSION COPY (BEGIN)
		-----------------------------------------------------------------------------------------------------
		IF @p_action_type = 'T' -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리
		BEGIN
           SET @ori_version_no = (SELECT ORI_VERSION_NO FROM DM_MDF_VERSION WITH (NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @p_version_no)
			--------------------------------------------------------- TEMP TABLE 확인후 초기화
			IF OBJECT_ID (N'tempdb..#TEMP_REPORT_C', N'U') IS NOT NULL 
				DROP TABLE #TEMP_REPORT_C

			-- 20210716
			IF EXISTS ( SELECT * 
						FROM DM_PLN_SALES_PLAN_REPORT_C A
						WHERE A.DIVISION_ID = @p_division_id
							AND A.VERSION_NO  = @p_version_no
							AND A.MEASURE = 'Business_Plan'
						)
			BEGIN
				SET @V_SP_BP = 'BP'
			END
			ELSE 
			BEGIN
				SET @V_SP_BP = 'SP'
			END

				
            SELECT A.DIVISION_ID, A.PRODUCT_GROUP
				, CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' 
						ELSE A.MEASURE 
						END AS MEASURE
				, A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT
				, CASE WHEN A.MEASURE IN ( 'RTF','Business_Plan','RTF_SYS_RP') AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * ISNULL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
					ELSE A.QTY 
					END AS QTY
              INTO #TEMP_REPORT_C
              FROM DM_PLN_SALES_PLAN_REPORT_C A WITH (NOLOCK)
			  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B WITH ( NOLOCK )
				    ON A.DIVISION_ID = B.DIVISION_ID 
						AND A.ITEM_ID = B.ITEM_ID
             WHERE A.DIVISION_ID = @p_division_id
               AND A.VERSION_NO  = @p_version_no
               AND A.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW')
			   AND A.DATA_TYPE = '1'
			UNION ALL
            SELECT A.DIVISION_ID, A.PRODUCT_GROUP
				, CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF'
						WHEN A.MEASURE = 'RTF_SYS_RP' THEN CASE WHEN @V_SP_BP = 'BP' THEN 'RTF' ELSE A.MEASURE  END
						ELSE A.MEASURE 
						END AS MEASURE
				, A.YYYYMMDD, A.PRODUCT_DETAILS, A.ATTRIBUTE2, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT
				, CASE WHEN A.MEASURE in ( 'RTF','Business_Plan' ) AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * ISNULL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
					ELSE A.QTY 
					END AS QTY
              FROM DM_PLN_SALES_ETC_REPORT_C A WITH (NOLOCK)
			  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B WITH ( NOLOCK )
				    ON A.DIVISION_ID = B.DIVISION_ID 
						AND A.ITEM_ID = B.ITEM_ID
             WHERE A.DIVISION_ID = @p_division_id
               AND A.VERSION_NO  = @p_version_no
               AND A.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW')
            ;
			
--SELECT * FROM #TEMP_REPORT_C WHERE MEASURE = 'Business_Plan'

			-- 2020.05.25 1~3 담당 외에는 기타로 묶는다.
			DECLARE @v_ETC_DEPARTMENT_ID NVARCHAR(30)
			SELECT @V_ETC_DEPARTMENT_ID = SEGMENT1
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
			WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
				--AND SEGMENT1 = N'기타'
				AND ATTRIBUTE1 = 'Y'

			UPDATE A
			SET DEPARTMENT_ID = @v_ETC_DEPARTMENT_ID
			FROM #TEMP_REPORT_C A
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND SEGMENT3 = 'Y'
			WHERE B.SEGMENT1 IS NULL
			
			UPDATE A
			SET DEPARTMENT_ID = @v_ETC_DEPARTMENT_ID
				, DEPT_ID = @v_ETC_DEPARTMENT_ID
			FROM DM_PLN_SALES_PLAN_REPORT_C A
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND SEGMENT3 = 'Y'
			WHERE B.SEGMENT1 IS NULL
				AND DIVISION_ID = @p_division_id
				AND VERSION_NO = @p_version_no

			UPDATE A
			SET DEPARTMENT_ID = @v_ETC_DEPARTMENT_ID
				, DEPT_ID = @v_ETC_DEPARTMENT_ID
			FROM DM_PLN_SALES_ETC_REPORT_C A
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND SEGMENT3 = 'Y'
			WHERE B.SEGMENT1 IS NULL
				AND DIVISION_ID = @p_division_id
				AND VERSION_NO = @p_version_no
				--AND DATA_TYPE = '1'

			
			--------------------------------------------------------- TEMP TABLE 확인후 초기화
			    -- 연도 커서 선언
			DECLARE yyyyList CURSOR FOR
			SELECT A.YYYY
			  FROM (
					SELECT DISTINCT LEFT(YYYYMMDD, 4) AS YYYY
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					WHERE A.DIVISION_ID = @p_division_id
						AND A.VERSION_NO  = @p_version_no
				   ) A

            OPEN yyyyList
            FETCH NEXT FROM yyyyList
            INTO @yyyy

            WHILE @@FETCH_STATUS = 0
            BEGIN

			--SELECT C.DIVISION_ID
			--	, @p_version_no AS VERSION_NO
			--	, @yyyy         AS YYYY
			--	, 'SP'          AS SP_BP_TYPE
			--	-- 20191023 kyh
			--	, CASE WHEN ISNULL((SELECT ATTRIBUTE1
			--						FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
			--						WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
			--						AND C.DEPARTMENT_ID = SEGMENT1),'N') = 'Y'
			--				THEN (SELECT ATTRIBUTE2
			--						FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
			--					WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
			--						AND C.DEPARTMENT_ID = SEGMENT1)
			--		ELSE ( SELECT Segment2
			--						FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
			--						WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
			--						AND C.DEPARTMENT_ID = SEGMENT1)
			--	END AS DEPARTMENT_NAME
			--	, CASE WHEN ISNULL((SELECT ATTRIBUTE1
			--						FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
			--						WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
			--						AND C.DEPARTMENT_ID = SEGMENT1),'N') = 'Y'
			--				THEN (SELECT ATTRIBUTE3
			--						FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
			--					WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
			--						AND C.DEPARTMENT_ID = SEGMENT1)
			--		ELSE C.DEPT_NAME
			--	END AS DEPT_NAME
			--	, ATTRIBUTE1, DEPARTMENT_ID, ATTRIBUTE2
			--	, C.CUST_REPORT
			--	, C.END_CUST_REPORT
			--	, C.PRODUCT_GROUP AS PRODUCT_NAME
			--	, C.ATTRIBUTE1 AS PRODUCT_DETAIL
			--	, C.MEASURE
			--	, SUBSTRING(C.YYYYMMDD,1,6) AS YYYYMM
			--	, C.QTY
			--FROM #TEMP_REPORT_C C WITH (NOLOCK)
			--WHERE 1 = 1
			----AND C.DIVISION_ID = @p_division_id
			----AND C.VERSION_NO  = @p_version_no
			--AND C.MEASURE IN ('RTF','SalesAmt_KRW')
			--AND C.YYYYMMDD LIKE @yyyy+'%'





 INSERT INTO DM_MOBILE_REPORT_DEPT
                     ( DIVISION_ID
                     , VERSION_NO
                     , YYYY
                     , SP_BP_TYPE
                     , UPPER_DEPT_NAME
                     , DEPT_NAME
                     , CUST_INFO
           , PRODUCT_NAME
                     , PRODUCT_DETAIL
                     , MEASURE
                     , MM01
                     , MM02
                     , MM03
                     , MM04
				     , MM05
                     , MM06
                     , MM07
                     , MM08
                     , MM09
                     , MM10
                     , MM11
                     , MM12
                     , ORI_VERSION_NO
                     , SORT_NO
                     , CREATED_BY
       , CREATION_DATE
                     , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
			   SELECT A.DIVISION_ID
                     , A.VERSION_NO
                 , A.YYYY
                     , A.SP_BP_TYPE
                     , A.DEPARTMENT_NAME
                     , A.DEPT_NAME
                     , CUST_INFO
                     , A.PRODUCT_NAME
                     , A.PRODUCT_DETAIL
                     , CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN N'RTF' ELSE A.MEASURE END AS MEASURE
                     , MM01
                     , MM02
                     , MM03
                     , MM04
         , MM05
                     , MM06
                     , MM07
 , MM08
                     , MM09
                     , MM10
                     , MM11
                     , MM12
                     , @ori_version_no AS ORI_VERSION_NO
                     , ROW_NUMBER() OVER(ORDER BY CASE WHEN A.DEPARTMENT_NAME = '' OR A.DEPARTMENT_NAME = N'기타' THEN N'힣' ELSE A.DEPARTMENT_NAME END
                                                 , CASE WHEN A.DEPT_NAME = 'MDF' THEN N'힣' ELSE A.DEPT_NAME END  
                                                 , A.DEPT_NAME
                                                 , A.DISPLAY_SEQ
                                                 , A.MEASURE) AS SORT_NO
                     , @user_id   AS CREATED_BY
                     , GETDATE()  AS CREATION_DATE
                     , @user_id   AS LAST_UPDATED_BY
               , GETDATE()  AS LAST_UPDATE_DATE
				FROM (
						SELECT A.DIVISION_ID
							 , @p_version_no AS VERSION_NO
							 , A.YYYY
							 , A.SP_BP_TYPE
							 , A.DEPARTMENT_NAME
							 , A.DEPT_NAME
							 , A.CUST_REPORT     AS CUST_INFO
							 , A.PRODUCT_NAME
							 , A.PRODUCT_DETAIL
							 , A.MEASURE
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'01' THEN QTY ELSE 0 END) AS MM01
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'02' THEN QTY ELSE 0 END) AS MM02
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'03' THEN QTY ELSE 0 END) AS MM03
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'04' THEN QTY ELSE 0 END) AS MM04
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'05' THEN QTY ELSE 0 END) AS MM05
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'06' THEN QTY ELSE 0 END) AS MM06
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'07' THEN QTY ELSE 0 END) AS MM07
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'08' THEN QTY ELSE 0 END) AS MM08
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'09' THEN QTY ELSE 0 END) AS MM09
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'10' THEN QTY ELSE 0 END) AS MM10
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'11' THEN QTY ELSE 0 END) AS MM11
							 , SUM(CASE WHEN A.YYYYMM = @yyyy+'12' THEN QTY ELSE 0 END) AS MM12
							 , B.DISPLAY_SEQ
						  FROM (SELECT C.DIVISION_ID
									 , @p_version_no AS VERSION_NO
									 , @yyyy         AS YYYY
									 , 'SP'          AS SP_BP_TYPE
									 -- 20191023 kyh
									, ISNULL((SELECT SEGMENT2
											FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
											WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
											AND C.DEPARTMENT_ID = SEGMENT1),'')
									   AS DEPARTMENT_NAME
									 ,  ISNULL((SELECT SEGMENT2
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
										WHERE LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'
										AND C.DEPT_ID = SEGMENT1), '')
										AS DEPT_NAME
									 , C.CUST_REPORT
									 , C.END_CUST_REPORT
									 , C.PRODUCT_GROUP AS PRODUCT_NAME
									 , C.ATTRIBUTE1 AS PRODUCT_DETAIL
									 , C.MEASURE
									 , SUBSTRING(C.YYYYMMDD,1,6) AS YYYYMM
									 , C.QTY
								  FROM #TEMP_REPORT_C C WITH (NOLOCK)
								 WHERE 1 = 1
								   --AND C.DIVISION_ID = @p_division_id
								   --AND C.VERSION_NO  = @p_version_no
								   AND C.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW')
								   AND C.YYYYMMDD LIKE @yyyy+'%'
								) A
								LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK)
								  ON A.CUST_REPORT = B.SEGMENT1
								 AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
						 GROUP BY 
							 A.DIVISION_ID
							 , A.VERSION_NO
							 , A.YYYY
							 , A.SP_BP_TYPE
							 , A.DEPARTMENT_NAME
							 , A.DEPT_NAME
							 , A.CUST_REPORT
							 --, CASE WHEN A.DATA_TYPE = '1' THEN A.CUST_REPORT ELSE A.END_CUST_REPORT END
							 , A.PRODUCT_NAME
							 , A.PRODUCT_DETAIL
							 , B.DISPLAY_SEQ
							 , A.MEASURE   
				) A
                ;

                FETCH NEXT FROM yyyyList
                INTO @yyyy

            END 

            CLOSE yyyyList
            DEALLOCATE yyyyList


		END

		----------------------------------------------------------------------------------------------------- 
		--                                                                           요청VERSION COPY (END)
		-----------------------------------------------------------------------------------------------------

 	---------------------------------------------------------------------------------------------------------------------------	
	END TRY
	---------------------------------------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
	BEGIN CATCH
	--------------------------------------------------------------	
		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '(DMF0044_SALES_REPORT_DEPT_CREATE)[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

	--------------------------------------------------------------	
	END CATCH;
	--------------------------------------------------------------	

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
	SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;






















