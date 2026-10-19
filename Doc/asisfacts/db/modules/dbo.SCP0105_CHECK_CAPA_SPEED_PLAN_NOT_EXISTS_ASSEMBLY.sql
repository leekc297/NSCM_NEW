
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0105_CHECK_CAPA_SPEED_PLAN_NOT_EXISTS_ASSEMBLY
 * Description  : ASSIGN 테이블 구조의 데이터를 파라미터로 Speed Plan Insert/Update
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/08/03   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initilized
*/

--DROP PROCEDURE [dbo].[SCP0105_CHECK_CAPA_SPEED_PLAN_NOT_EXISTS_ASSEMBLY]
--CREATE PROCEDURE [dbo].[SCP0105_CHECK_CAPA_SPEED_PLAN_NOT_EXISTS_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0105_CHECK_CAPA_SPEED_PLAN_NOT_EXISTS_ASSEMBLY]
	  @p_program_id				NVARCHAR(100)
	, @p_sheet_name				NVARCHAR(100)
	, @p_user_id				NVARCHAR(30)
	, @debug_mode				NVARCHAR(1)
AS
BEGIN
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ASSEMBLY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER			= 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type						= 'START';
		SET @v_log_message					= '########## Start of procedure ##########';
		SET @v_description					= '';
		SET @d_event_date					= SYSDATETIME();
    
        DECLARE @test_mode          NVARCHAR(20)		= N'F';

        IF @test_mode <> 'T'
        BEGIN
		    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        ;WITH tbl_SPEED_UNIT_ALL AS
		(
            SELECT    A.SEGMENT1        AS UNIT_GROUP
                    , A.SEGMENT2        AS OPERATION_ID
                    , A.SEGMENT3        AS MSR_TP_CD
                    , A.SEGMENT4        AS LINE_TYPE
                    , A.SEGMENT5        AS UNIT_GROUP_SEQ
                    , A.DISPLAY_SEQ
            FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
            WHERE   1=1
			    --AND SEGMENT1 = 'SCP'
                AND A.LOOKUP_TYPE  = 'OPERATION_SPEED_UNIT'
                AND A.VALID_YN  = 'Y'
		)
		,
		tbl_SPEED_UNIT_GROUP_MSR AS
		(
            SELECT    A.UNIT_GROUP
                    , A.MSR_TP_CD
                    , MIN(A.DISPLAY_SEQ)      AS DISPLAY_SEQ
                    , MAX(A.UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
            FROM    tbl_SPEED_UNIT_ALL A
            GROUP BY  A.UNIT_GROUP
                    , A.MSR_TP_CD
            --ORDER BY MIN(A.DISPLAY_SEQ)
		)
        ,
		tbl_SPEED_UNIT_GROUP AS
		(
            SELECT    A.UNIT_GROUP
                    , MAX(A.UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
            FROM    tbl_SPEED_UNIT_ALL A
            GROUP BY  A.UNIT_GROUP
            --ORDER BY MIN(A.DISPLAY_SEQ)
		)
		,
		tbl_SPEED_PLAN_KEYS AS
		(
			SELECT    DIVISION_ID	
					, COMPANY_ID	
					, SITE_ID	
					, PLANT_ID	
					, FACTORY_ID	
					, LINE_ID	
					, OPERATION_ID	
					, ELTR_LN_TP_CD	
					, ITEM_ID	
					, NICK_NAME	
					, MSR_TP_CD	
					, YYYYMM
			FROM    SCP_MST_CAPA_SPEED_PLAN
		)
		,
		tbl_SPEED_PLAN_ALL_KEYS AS
		(
			SELECT    A.DIVISION_ID	
					, A.COMPANY_ID	
					, A.SITE_ID	
					, A.PLANT_ID	
					, A.FACTORY_ID	
					, A.LINE_ID	
					, A.OPERATION_ID	
					, A.ELTR_LN_TP_CD	
					, A.ITEM_ID	
					, A.NICK_NAME	
                    , G.UNIT_GROUP  AS SPEED_UNIT_GROUP
                    , G.UNIT_GROUP_SEQ
					, CASE
						WHEN G.UNIT_GROUP = 'EQP_SPED' THEN
							CASE
								WHEN (A.OPERATION_ID = 'A5000')									                                THEN 'MMS'
								WHEN (A.OPERATION_ID = 'A7000')	 OR (A.OPERATION_ID = 'A7400')	                                THEN 'CPM'
								WHEN (A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding') OR (A.OPERATION_ID = 'A8400')	THEN 'PPM_AVG'
								ELSE 'TTT'
							END
						WHEN G.UNIT_GROUP = 'PPM' THEN 'PPM'
						ELSE A.MSR_TP_CD
    			      END AS MSR_TP_CD
					, A.YYYYMM
			FROM    SCP_MST_CAPA_SPEED_PLAN A
					JOIN tbl_SPEED_UNIT_GROUP G ON 1=1
		)
        ,
        tbl_ALL_RAWS AS
        (
			SELECT    A.DIVISION_ID	
					, A.COMPANY_ID	
					, A.SITE_ID	
					, A.PLANT_ID	
					, A.FACTORY_ID	
					, A.LINE_ID	
					, A.OPERATION_ID	
					, A.ELTR_LN_TP_CD	
					, A.ITEM_ID	
					, A.NICK_NAME	
                    , A.SPEED_UNIT_GROUP
                    , A.UNIT_GROUP_SEQ
                    , A.MSR_TP_CD
					, A.YYYYMM
            FROM    tbl_SPEED_PLAN_ALL_KEYS A
                    JOIN tbl_SPEED_UNIT_GROUP_MSR M ON
                            A.MSR_TP_CD = M.MSR_TP_CD
            WHERE   1=1
			    AND ((A.SPEED_UNIT_GROUP  = 'EQP_NBU'    AND A.MSR_TP_CD IN ('EQP_NBU')) OR
					 (A.SPEED_UNIT_GROUP  = 'EQP_SPED'   AND A.MSR_TP_CD IN ('MMS', 'CPM', 'PPM_AVG', 'TTT')) OR
				  	 (A.SPEED_UNIT_GROUP  = 'PPM'        AND A.MSR_TP_CD IN ('PPM')))

                --AND YYYYMM          = '202408'
                --AND NICK_NAME       = 'LV15A'
                --AND LINE_ID         = 'DMY_313'
                --AND ELTR_LN_TP_CD   = 'Cathode'

	            --AND A.DIVISION_ID		= N'81'
	            --AND A.SITE_ID			= N'A004'
	            --AND A.PLANT_ID  		= N'G481'
	            --AND A.FACTORY_ID		= N'A5'
	            --AND A.LINE_ID			= N'A5A01'
	            --AND A.OPERATION_ID		= N'A5000'
             --   AND A.NICK_NAME		    = N'E58C'
	            --AND A.ELTR_LN_TP_CD		= N'Anode'
             --   AND A.YYYYMM			= '202408'
        GROUP BY      A.DIVISION_ID	
					, A.COMPANY_ID	
					, A.SITE_ID	
					, A.PLANT_ID	
					, A.FACTORY_ID	
					, A.LINE_ID	
					, A.OPERATION_ID	
					, A.ELTR_LN_TP_CD	
					, A.ITEM_ID	
					, A.NICK_NAME	
                    , A.SPEED_UNIT_GROUP
                    , A.UNIT_GROUP_SEQ
                    , A.MSR_TP_CD
					, A.YYYYMM
        )
        ,
		tbl_UI_UPD_ALL AS
		(
            SELECT    A.DIVISION_ID
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.PLANT_ID
				    , A.FACTORY_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
                    , A.MDL_NM            
                    , UPPER(A.EQP_SPED_UNIT_CD)     AS EQP_SPED_UNIT_CD
				    , A.UI_UPD_YN
				    , A.EQP_NBU
                    , A.EQP_SPED
            FROM    SCP_MST_MDL_EQP_SPED A WITH(NOLOCK)
            WHERE   1=1
                AND A.USE_YN = 'Y'
        )
        ,
		tbl_UI_UPD AS
		(
            SELECT    A.DIVISION_ID
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.PLANT_ID
				    , A.FACTORY_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
                    , A.MDL_NM            
                    , 'EQP_NBU'                     AS MSR_TP_CD
				    , A.EQP_NBU                     AS BASE_QTY
				    , A.UI_UPD_YN
                    , A.EQP_SPED
            FROM    tbl_UI_UPD_ALL A
            UNION ALL
            SELECT    A.DIVISION_ID
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.PLANT_ID
				    , A.FACTORY_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
                    , A.MDL_NM            
                    , EQP_SPED_UNIT_CD              AS MSR_TP_CD
				    , A.EQP_NBU                     AS BASE_QTY
				    , A.UI_UPD_YN
                    , A.EQP_SPED
            FROM    tbl_UI_UPD_ALL A
        )
        ,
        tbl_ALL_RAWS_NOT_EXISTS AS
        (
			SELECT    A.DIVISION_ID	
					, A.COMPANY_ID	
					, A.SITE_ID	
					, A.PLANT_ID	
					, A.FACTORY_ID	
					, A.LINE_ID	
					, A.OPERATION_ID	
					, A.ELTR_LN_TP_CD	
					, A.ITEM_ID	
					, A.NICK_NAME	
                    , A.SPEED_UNIT_GROUP
                    , A.UNIT_GROUP_SEQ
                    , A.MSR_TP_CD
					, A.YYYYMM
					, U.BASE_QTY
					, U.BASE_QTY                    AS QTY
                    , ISNULL(U.UI_UPD_YN, 'N')      AS UI_UPD_YN
				    , 'SYSTEM_INIT'                 AS CREATED_BY
				    , SYSDATETIME()                 AS CREATION_DATE
				    , 'SYSTEM_INIT'                 AS LAST_UPDATED_BY
				    , SYSDATETIME()                 AS LAST_UPDATE_DATE
            FROM    tbl_ALL_RAWS A
                    LEFT JOIN SCP_MST_CAPA_SPEED_PLAN B WITH(NOLOCK) ON
						    A.DIVISION_ID		 = B.DIVISION_ID
					    AND A.COMPANY_ID		 = B.COMPANY_ID
					    AND A.SITE_ID			 = B.SITE_ID
					    AND A.PLANT_ID			 = B.PLANT_ID
					    AND A.FACTORY_ID		 = B.FACTORY_ID
					    AND A.LINE_ID			 = B.LINE_ID
					    AND A.OPERATION_ID		 = B.OPERATION_ID
					    AND A.NICK_NAME          = B.NICK_NAME
					    AND A.ELTR_LN_TP_CD	     = B.ELTR_LN_TP_CD
					    AND A.MSR_TP_CD 	     = B.MSR_TP_CD
					    AND A.YYYYMM	         = B.YYYYMM
                    LEFT JOIN tbl_UI_UPD U ON
						    A.DIVISION_ID		 = U.DIVISION_ID
					    AND A.COMPANY_ID		 = U.COMPANY_ID
					    AND A.SITE_ID			 = U.SITE_ID
					    AND A.PLANT_ID			 = U.PLANT_ID
					    AND A.FACTORY_ID		 = U.FACTORY_ID
					    AND A.LINE_ID			 = U.LINE_ID
					    AND A.OPERATION_ID		 = U.OPERATION_ID
					    AND A.NICK_NAME          = U.MDL_NM
					    AND A.ELTR_LN_TP_CD	     = U.ELTR_LN_TP_CD
					    AND A.MSR_TP_CD 	     = U.MSR_TP_CD
            WHERE   1=1
                AND B.DIVISION_ID IS NULL
        )
            --SELECT  A.*
            --FROM    tbl_ALL_RAWS_NOT_EXISTS A
            --WHERE   1=1
            -- --   --AND A.YYYYMM          = '202408'
            -- --   --AND A.NICK_NAME       = 'LV15A'
            -- --   --AND A.LINE_ID         = 'DMY_313'
            -- --   --AND A.ELTR_LN_TP_CD   = 'Cathode'

	           -- --AND A.DIVISION_ID		= N'81'
	           -- --AND A.SITE_ID			= N'A004'
	           -- --AND A.PLANT_ID  		= N'G481'
	           -- --AND A.FACTORY_ID		= N'A5'
	           -- --AND A.LINE_ID			= N'A5A01'
	           -- ----AND A.OPERATION_ID		= N'A5000'
            -- --   AND A.NICK_NAME		    = N'E58C'
	           -- ----AND A.ELTR_LN_TP_CD		= N'Anode'
            -- --   AND A.YYYYMM			= '202408'


			MERGE INTO SCP_MST_CAPA_SPEED_PLAN A
			USING
			(
				SELECT	*
                FROM    tbl_ALL_RAWS_NOT_EXISTS
                WHERE   1=1
			) B ON
			(
					A.DIVISION_ID		    = B.DIVISION_ID
				AND A.COMPANY_ID		    = B.COMPANY_ID
				AND A.SITE_ID			    = B.SITE_ID
				AND A.PLANT_ID			    = B.PLANT_ID
				AND A.FACTORY_ID		    = B.FACTORY_ID
				AND A.LINE_ID			    = B.LINE_ID
				AND A.OPERATION_ID		    = B.OPERATION_ID
				AND A.ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
				AND A.ITEM_ID			    = B.ITEM_ID
				AND A.NICK_NAME			    = B.NICK_NAME
				AND A.MSR_TP_CD	            = B.MSR_TP_CD
				AND A.YYYYMM			    = B.YYYYMM
			)
			----WHEN MATCHED THEN
			----UPDATE
			----SET
			----	  BASE_QTY		        = B.BASE_QTY
			----	, UI_UPD_YN		        = B.UI_UPD_YN
			----	, QTY		            = B.QTY
			----	, LAST_UPDATED_BY		= B.LAST_UPDATED_BY
			----	, LAST_UPDATE_DATE		= B.LAST_UPDATE_DATE
			WHEN NOT MATCHED THEN
			INSERT
			(
				  DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, ITEM_ID
				, NICK_NAME
				, MSR_TP_CD
				, YYYYMM
				, BASE_QTY
				, UI_UPD_YN
				, QTY
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
			)
			VALUES
			(
				  B.DIVISION_ID
				, B.COMPANY_ID
				, B.SITE_ID
				, B.PLANT_ID
				, B.FACTORY_ID
				, B.LINE_ID
				, B.OPERATION_ID
				, B.ELTR_LN_TP_CD
				, B.ITEM_ID
				, B.NICK_NAME
				, B.MSR_TP_CD
				, B.YYYYMM
				, B.BASE_QTY
				, B.UI_UPD_YN
				, B.QTY
				, B.CREATED_BY
				, B.CREATION_DATE
				, B.LAST_UPDATED_BY
				, B.LAST_UPDATE_DATE
			);


        -- LOG end
		SET @v_log_type     = 'END'
		SET @v_log_message  = '########## END of procedure ##########'
		SET @v_description  = ''
		SET @d_event_date   = SYSDATETIME()

        IF @test_mode <> 'T'
        BEGIN
		    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		--SELECT  'S' AS result_code,  @v_all_cnt AS result_cnt;
	END TRY
	BEGIN CATCH
		  IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
		  BEGIN
			INSERT INTO SCM_SYS_LOG_BATCH
			(
				  PROGRAM_NAME
				, LOG_TYPE
				, LOG_COUNT
				, LOG_MESSAGE
				, DESCRIPTION
				, EVENT_DATE
				, CREATION_DATE
				, CREATED_BY
				, LAST_UPDATE_DATE
				, LAST_UPDATED_BY
			)
			VALUES
			(
				  ISNULL(ERROR_PROCEDURE(), 'SCP0006_SAVE_PROJECT_ROUTE_PLANT')
	 			, 'ERROR'
	 			, NULL
	 			, ERROR_MESSAGE()
	 			, NULL
	 			, SYSDATETIME()
	 			, SYSDATETIME()
	 			, ERROR_PROCEDURE()
	 			, SYSDATETIME()
				, ERROR_PROCEDURE()
			)

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;


		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;

END

