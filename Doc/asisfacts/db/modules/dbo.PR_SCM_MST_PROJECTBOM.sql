---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*  
 * Program ID   : PR_SCM_MST_PROJECTBOM  
 * Description  : MDM 수신정보 적재처리 Procedure
 * PARAMETER    : N/A
 * DESCRIPTION  : BPMS으로부터 수신된 정보(자재/Project/ProjectBOM)를 SCM_MST의 관련 테이블에 적재처리 함
 *                지정한 간격마다 자동으로 실행 됨
 * I/F Table    : [dbo].[XIF_BPMS_PROJECTBOM_AUTO_R_SN],[dbo].[XIF_BPMS_PROJECTBOM_ESS_R_SN]
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================
 * 2021.03.17	P.C.I		   [C20210312-000195] 'BPMS -> DMS -> GSCM' I/F를 'BPMS -> GSCM'으로 변경
 * 2021.06.08	P.C.I		   [C20210312-000399] BPMS -> GSCM I/F 시 VALID 'N'은 Sales Site Project Model 적용
 * 2021.10.20	hwi1993		   [PJ20209643] 성능개선] -  COLLATE KOREAN_WANSUNG_CI_AS 제거 
 * 2024.04.24	JSSBAE		   [E20240424-000960]_BPMS - SCM IF 시 SSPM의 Inactive 처리는 Site Type = “Sales”인 대상으로 한정되어 RTF 생성에 영향이 없도록 기능변경요청(05_03)
 */  

CREATE PROCEDURE [dbo].[PR_SCM_MST_PROJECTBOM]
AS
--------------------------------------------------------------------------------
BEGIN
	   SET NOCOUNT ON;
	   SET ANSI_WARNINGS OFF;
	   ----------------------------------------------------------------------------
    DECLARE @IF_UID            VARCHAR(40);   --IF ID
    DECLARE @MAT_CD            VARCHAR(100);  --자재코드
    DECLARE @MAT_NM            VARCHAR(1000); --자재명
    DECLARE @PROJECT_CD        VARCHAR(20);   --PJT Code
    DECLARE @MDM_CUST_CD       VARCHAR(32);   --MDM고객코드
    DECLARE @MDM_CUST_NM       VARCHAR(200);  --MDM고객명
    DECLARE @MDM_CUSTTEAM_NM   VARCHAR(200);  --MDM고객지원팀명
    DECLARE @APP               VARCHAR(100);  --xEV
    DECLARE @APP_NM            VARCHAR(100);  --xEV명
    DECLARE @BIZTYPE           VARCHAR(100);  --Biz Type
    DECLARE @BIZTYPE_NM        VARCHAR(100);  --Biz Type명
	DECLARE @IF_TOTAL_CNT      NUMERIC(16,0); --IF총건수
	DECLARE @IF_SEQ_BY_PJT     NUMERIC(16,0); --IF순번(프로젝트별)
	DECLARE @RECEIVE_CNT       NUMERIC(16,0); --수신적재처리건수
	DECLARE @TXN_FLAG          VARCHAR(10);   -- BPMS 개편으로 인한 TRANSACTION 플래그 추가 2017-02-07 진준희
	   ----------------------------------------------------------------------------
	   
    -- LOG 용 변수 설정
    DECLARE @v_batch_user		NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name		NVARCHAR(150) = 'PR_SCM_MST_PROJECTBOM';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
	DECLARE @n_history_seq		BIGINT;
	DECLARE @v_ifseqno			NVARCHAR(30); -- 누락된 전체 데이터 insert

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	--[E20240424-000960] TEMP 생성 후 DROP 구간이 없어 해당 부분 추가생성
	IF OBJECT_ID('TEMPDB..#TEMP_PROJECTBOM') IS NOT NULL
		DROP TABLE #TEMP_PROJECTBOM;
	IF OBJECT_ID('TEMPDB..#DM_MST_ITEM_SINGLE_V') IS NOT NULL
		DROP TABLE #DM_MST_ITEM_SINGLE_V;
		
	--[E20240424-000960] DM_MST_ITEM_SINGLE_V에 문제가 있어서, VIEW 내용 TEMP로 담아서 해당 부분으로 사용
	SELECT	T1.DIVISION_ID,
			T1.ITEM_ID, 
			MAX(T1.ITEM_NAME)					AS ITEM_NAME,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
			MAX(T1.ITEM_CLASS)					AS ITEM_CLASS,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
			MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME,		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
			MAX(T1.NICK_NAME)						AS NICK_NAME,			--닉네임이 NULL인 경우가 있으므로 하나로 통일
			case  min( case when T1.item_type = 'P' then 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
							when T1.item_type = 'H' then 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
							when T1.item_type = 'Q' then 3
							else 4 end )  
											when 1 then 'P' 
											when 2 then 'H'
											when 3 then 'Q'
											else 'R' end	AS ITEM_TYPE,
			MAX(T1.MATERIAL_CLASS_NAME				)		AS MATERIAL_CLASS_NAME,
			MAX(T1.ITEM_UOM							)		AS ITEM_UOM,
			MAX(T1.SPEC								)		AS SPEC,
			MAX(T1.MDM_PROJECT_NAME					)		AS MDM_PROJECT_NAME,
			MAX(T1.MIN_CAPACITY						)		AS MIN_CAPACITY,
			MAX(T2.FORECAST_INFO_BIZ_TYPE			)		AS FORECAST_INFO_BIZ_TYPE,
			MAX(T2.FORECAST_INFO_PRODUCT_GROUP		)		AS FORECAST_INFO_PRODUCT_GROUP,
			MAX(T2.FORECAST_INFO_CELL_MODEL			)		AS FORECAST_INFO_CELL_MODEL,
			MAX(T2.FORECAST_INFO_CELL_PACK_COUNT	)		AS FORECAST_INFO_CELL_PACK_COUNT,
			MAX(T2.FORECAST_INFO_SPEC				)		AS FORECAST_INFO_SPEC,
			MAX(T2.FORECAST_INFOR_VERSION			)		AS FORECAST_INFOR_VERSION,
			MAX(T1.ACTIVE_FLAG						)		AS ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
			MAX(T2.CELL_TYPE						)		AS CELL_TYPE,  -- 20180911 ADD cell_type
			MAX(T1.ENERGE							)  	    AS ENERGE,			-- 20200116 khsong ADD ENERGE
			MAX(T1.CELL_QUANTITY					)	    AS CELL_QUANTITY,	-- 20200116 khsong ADD CELL_QUANTITY
			MAX(T1.SCP_EXTRA_SPEC)						  AS SCP_EXTRA_SPEC		-- [20210428 SJHAN / CSR ID:C20210323-000420]
		INTO #DM_MST_ITEM_SINGLE_V
		FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)					
		INNER JOIN ( SELECT DIVISION_ID, LEFT(ITEM_ID, 12) AS ITEM_ID
						, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
						, MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
						, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
						, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
						, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
						, MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
						, MAX(CELL_TYPE) AS CELL_TYPE
					FROM  SCM_MST_ITEM_SN T2 WITH(NOLOCK) 
					GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
				) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
			AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
		WHERE 1=1
		GROUP BY T1.DIVISION_ID, T1.ITEM_ID

	--CURSOR 자동차 프로젝트BOM정보수신
    DECLARE CUR_PJTBOM_81 CURSOR FOR
	select IF_UID, PROJECT_CD, MAT_CD, IF_TOTAL_CNT, IF_SEQ_BY_PJT, TXN_FLAG
	from ( select MPBARI.IF_UID
				, MPBARI.PROJECT_CD
				, MPBARI.MAT_CD
				, MPBARI.IF_TOTAL_CNT
				, ROW_NUMBER() OVER (PARTITION BY MPBARI.PROJECT_CD
													, MPBARI.MAT_CD
										ORDER BY receive_date asc, case when TXN_FLAG = 'D' then 99 else 1 end desc ) AS IF_SEQ_BY_PJT
				, MPBARI.TXN_FLAG
			from  [dbo].[XIF_BPMS_PROJECTBOM_AUTO_R_SN] AS MPBARI WITH(NOLOCK)
			where  ISNULL(MPBARI.TRANSFER_FLAG,'N') = 'N' ) x
	ORDER BY PROJECT_CD,MAT_CD ,IF_SEQ_BY_PJT
	
	
	--CURSOR ESS 프로젝트BOM정보수신
    DECLARE CUR_PJTBOM_82 CURSOR FOR
    SELECT MPBERI.IF_UID
         , MPBERI.PROJECT_CD
         , MPBERI.MAT_CD
	     , MPBERI.IF_TOTAL_CNT
		 , ROW_NUMBER() OVER (PARTITION BY MPBERI.PROJECT_CD
		                                 , MPBERI.IF_UID
	                          ORDER BY MPBERI.PROJECT_CD
							         , MPBERI.IF_UID
	                                 , MPBERI.MAT_CD) AS IF_SEQ_BY_PJT
		 , MPBERI.TXN_FLAG
    FROM   [dbo].[XIF_BPMS_PROJECTBOM_ESS_R_SN] AS MPBERI WITH(NOLOCK)
    WHERE  ISNULL(MPBERI.TRANSFER_FLAG,'N') = 'N'
	AND    MPBERI.IF_UID IN (SELECT X.IF_UID
                             FROM   [dbo].[XIF_BPMS_PROJECTBOM_ESS_R_SN] AS X WITH(NOLOCK)
                             WHERE  ISNULL(X.TRANSFER_FLAG,'N') = 'N'
                             GROUP BY X.IF_UID
							        , X.IF_TOTAL_CNT
                             HAVING COUNT(*) = X.IF_TOTAL_CNT)
	ORDER BY MPBERI.PROJECT_CD
	       , MPBERI.IF_UID
		   , MPBERI.MAT_CD;

	----------------------------------------------------------------------------
	BEGIN TRY
	BEGIN TRANSACTION;
	------------------------------------------------------------------------
	
PRINT ( 'A--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
	
		--------------------------------------------------------------------
		--Start  81 PROJECTBOM
		--------------------------------------------------------------------

		SET @RECEIVE_CNT = 0;
		OPEN CUR_PJTBOM_81;
        FETCH NEXT FROM CUR_PJTBOM_81
		           INTO @IF_UID
					  , @PROJECT_CD
					  , @MAT_CD
					  , @IF_TOTAL_CNT
					  , @IF_SEQ_BY_PJT
					  , @TXN_FLAG;
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
		
PRINT ( 'B--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
		    --------------------------------------------------------------------
		    MERGE INTO SCM_MST_PROJECTBOM SMP
            USING ( SELECT DIVISION_ID AS DIVISION_ID
						 , @PROJECT_CD    AS PROJECT_CD
						 , @MAT_CD        AS MAT_CD
						 , @v_batch_user  AS CREATED_BY
                         , GETDATE()      AS CREATION_DATE
                         , @v_batch_user  AS LAST_UPDATED_BY
                         , GETDATE()      AS LAST_UPDATE_DATE
					FROM SCM_MST_DIVISION WITH(NOLOCK)
					WHERE ATTRIBUTE3 = '81'
                  ) XXX
            ON (     SMP.DIVISION_ID  = XXX.DIVISION_ID
				 AND SMP.PROJECT_CODE = XXX.PROJECT_CD
				 AND SMP.ITEM_ID      = XXX.MAT_CD
               )
            WHEN MATCHED THEN
                UPDATE SET SMP.VALID_YN         = CASE WHEN @TXN_FLAG = 'D' THEN 'N' ELSE 'Y' END
                         , SMP.LAST_UPDATED_BY  = XXX.LAST_UPDATED_BY
                         , SMP.LAST_UPDATE_DATE = XXX.LAST_UPDATE_DATE
            WHEN NOT MATCHED THEN
                INSERT ( DIVISION_ID
					   , PROJECT_CODE
					   , ITEM_ID
					   , REP_YN
                       , VALID_YN
					   , CREATED_BY
                       , CREATION_DATE
					   , LAST_UPDATED_BY
                       , LAST_UPDATE_DATE
                       )
                VALUES ( XXX.DIVISION_ID
					   , XXX.PROJECT_CD
					   , XXX.MAT_CD
					   , 'N' --REP_YN
                       , 'Y' --VALID_YN
					   , XXX.CREATED_BY
                       , XXX.CREATION_DATE
					   , XXX.LAST_UPDATED_BY
                       , XXX.LAST_UPDATE_DATE
                       );
            --------------------------------------------------------------------
            UPDATE [dbo].[XIF_BPMS_PROJECTBOM_AUTO_R_SN]
            SET    TRANSFER_FLAG    = 'Y'
                 , TRANSFER_DATE    = GETDATE()
                 , LAST_UPDATED_BY  = @v_batch_user
                 , LAST_UPDATE_DATE = GETDATE()
            WHERE  IF_UID           = @IF_UID
			AND    PROJECT_CD       = @PROJECT_CD
			AND    MAT_CD           = @MAT_CD;
			SET @RECEIVE_CNT        = @RECEIVE_CNT + 1;
			--------------------------------------------------------------------
            FETCH NEXT FROM CUR_PJTBOM_81
					   INTO @IF_UID
						  , @PROJECT_CD
					      , @MAT_CD
					      , @IF_TOTAL_CNT
					      , @IF_SEQ_BY_PJT
						  , @TXN_FLAG;
        END;
        CLOSE CUR_PJTBOM_81;
        DEALLOCATE CUR_PJTBOM_81;

		--------------------------------------------------------------------
		--End  81 PROJECTBOM
		--------------------------------------------------------------------
		
		
PRINT ( 'C--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
		
		--------------------------------------------------------------------
		--Start  82 PROJECTBOM
		--------------------------------------------------------------------

		SET @RECEIVE_CNT = 0;
		OPEN CUR_PJTBOM_82;
        FETCH NEXT FROM CUR_PJTBOM_82
		           INTO @IF_UID
					  , @PROJECT_CD
					  , @MAT_CD
					  , @IF_TOTAL_CNT
					  , @IF_SEQ_BY_PJT
					  , @TXN_FLAG;
        WHILE (@@FETCH_STATUS = 0)
        BEGIN

PRINT ( 'D--' + CONVERT(NVARCHAR(30), GETDATE(), 121))		
		
		    --------------------------------------------------------------------
		    MERGE INTO SCM_MST_PROJECTBOM MPBM
            USING ( SELECT '82' AS DIVISION_ID
						 , @PROJECT_CD    AS PROJECT_CD
						 , @MAT_CD        AS MAT_CD
						 , @v_batch_user  AS CREATED_BY
                         , GETDATE()      AS CREATION_DATE
                         , @v_batch_user  AS LAST_UPDATED_BY
                         , GETDATE()      AS LAST_UPDATE_DATE
                  ) XXX
            ON (     MPBM.DIVISION_ID  = XXX.DIVISION_ID
				 AND MPBM.PROJECT_CODE = XXX.PROJECT_CD
			     AND MPBM.ITEM_ID      = XXX.MAT_CD
               )
            WHEN MATCHED THEN
                UPDATE SET MPBM.VALID_YN         = CASE WHEN @TXN_FLAG = 'D' THEN 'N' ELSE 'Y' END
                         , MPBM.LAST_UPDATED_BY  = XXX.LAST_UPDATED_BY
                         , MPBM.LAST_UPDATE_DATE = XXX.LAST_UPDATE_DATE
            WHEN NOT MATCHED THEN
                INSERT ( DIVISION_ID
					   , PROJECT_CODE
				       , ITEM_ID
					   , REP_YN
                       , VALID_YN
					   , CREATED_BY
                       , CREATION_DATE
					   , LAST_UPDATED_BY
                       , LAST_UPDATE_DATE
                       )
                VALUES ( XXX.DIVISION_ID
					   , XXX.PROJECT_CD
					   , XXX.MAT_CD
					   , 'N' --REP_YN
                       , 'Y' --VALID_YN
					   , XXX.CREATED_BY
                       , XXX.CREATION_DATE
					   , XXX.LAST_UPDATED_BY
                       , XXX.LAST_UPDATE_DATE
                       );
            --------------------------------------------------------------------
            UPDATE [dbo].[XIF_BPMS_PROJECTBOM_ESS_R_SN]
            SET    TRANSFER_FLAG    = 'Y'
                 , TRANSFER_DATE    = GETDATE()
                 , LAST_UPDATED_BY  = @v_batch_user
                 , LAST_UPDATE_DATE = GETDATE()
            WHERE  IF_UID           = @IF_UID
			AND    PROJECT_CD       = @PROJECT_CD
			AND    MAT_CD           = @MAT_CD;
			SET @RECEIVE_CNT        = @RECEIVE_CNT + 1;

			--------------------------------------------------------------------
            FETCH NEXT FROM CUR_PJTBOM_82
					   INTO @IF_UID
						  , @PROJECT_CD
					      , @MAT_CD
					      , @IF_TOTAL_CNT
					      , @IF_SEQ_BY_PJT
						  , @TXN_FLAG;
        END;
        CLOSE CUR_PJTBOM_82;
        DEALLOCATE CUR_PJTBOM_82;

		--------------------------------------------------------------------
		--End  82 PROJECTBOM
		--------------------------------------------------------------------
		
PRINT ( 'E--' + CONVERT(NVARCHAR(30), GETDATE(), 121))		
		
		--------------------------------------------------------------------
		--Start  SCM Project 데이터 적용
		--------------------------------------------------------------------
		SELECT  B.DIVISION_ID, 
				B.PROJECT_CODE, 
				B.PROJECT_VER_SEQ,  
				C.ITEM_ID, 
				MAX(CASE WHEN VALID_YN = 'Y' 
						THEN 'Y' 
						ELSE 'N' 
						END ) VALID_YN
	    INTO  #TEMP_PROJECTBOM
		FROM  SCM_MST_PROJECTBOM A WITH(NOLOCK)
			 ,SCM_MST_PROJECT B WITH(NOLOCK)
			 ,SCM_MST_ITEM_SN C WITH(NOLOCK)
		WHERE  A.PROJECT_CODE = B.PROJECT_CODE
		AND  A.ITEM_ID    <> '-'
		AND  A.ITEM_ID     = C.ITEM_ID
		and  ( B.DIVISION_ID  = '82'
			OR B.DIVISION_ID LIKE '81%' )
        group by B.DIVISION_ID, 
				B.PROJECT_CODE, 
				B.PROJECT_VER_SEQ,  
				C.ITEM_ID
		;

PRINT ( 'F--' + CONVERT(NVARCHAR(30), GETDATE(), 121))		
		
		-- scm_mst_project_item 에 존재하지 않는건 insert 함.
		INSERT INTO SCM_MST_PROJECT_ITEM
		(
			DIVISION_ID, 
			PROJECT_CODE, 
			PROJECT_VER_SEQ, 
			ITEM_ID, 
			ITEM_TYPE, 
			VALID_YN, 
			CREATION_DATE, 
			CREATED_BY, 
			LAST_UPDATE_DATE, 
			LAST_UPDATED_BY
		)
		SELECT	DIVISION_ID, 
				PROJECT_CODE, 
				PROJECT_VER_SEQ, 
				ITEM_ID, 
				(
				SELECT V.ITEM_TYPE
				  FROM #DM_MST_ITEM_SINGLE_V V
				 WHERE V.DIVISION_ID = A.DIVISION_ID
				   AND V.ITEM_ID     = A.ITEM_ID
				) ITEM_TYPE, 
				VALID_YN, 
				GETDATE(), 
				'SYSTEM_BATCH_BOM', 
				GETDATE(), 
				'SYSTEM_BATCH_BOM'
		  FROM	#TEMP_PROJECTBOM A
		 WHERE (
				  SELECT COUNT(1)
					FROM SCM_MST_PROJECT_ITEM X WITH(NOLOCK)
				   WHERE A.DIVISION_ID  = X.DIVISION_ID
			         AND A.ITEM_ID      = X.ITEM_ID
			         AND A.PROJECT_CODE = X.PROJECT_CODE
			   ) = 0
		;

PRINT ( 'G--' + CONVERT(NVARCHAR(30), GETDATE(), 121))	

		-- VALID_YN이 변경된 것에 대해서 update 처리
		 UPDATE T1
		    SET T1.VALID_YN			= T2.VALID_YN
			   ,T1.LAST_UPDATE_DATE = GETDATE()
		       ,T1.LAST_UPDATED_BY  = 'SYSTEM_BATCH_BOM'
		   FROM SCM_MST_PROJECT_ITEM T1 INNER JOIN (	SELECT  DIVISION_ID, 
																PROJECT_CODE, 
																PROJECT_VER_SEQ, 
																ITEM_ID, 
																VALID_YN
														FROM    #TEMP_PROJECTBOM A
													   WHERE (
															   SELECT COUNT(1)
																 FROM SCM_MST_PROJECT_ITEM X WITH(NOLOCK)
																WHERE A.DIVISION_ID  = X.DIVISION_ID
																  AND A.ITEM_ID		 = X.ITEM_ID
																  AND A.PROJECT_CODE = X.PROJECT_CODE
																  AND A.VALID_YN		<> X.VALID_YN
															) > 0
													) T2 ON T1.PROJECT_CODE = T2.PROJECT_CODE
														AND T1.DIVISION_ID	= T2.DIVISION_ID
														AND T1.ITEM_ID		= T2.ITEM_ID
		;
		
PRINT ( 'H--' + CONVERT(NVARCHAR(30), GETDATE(), 121))	

		-- SCM_MST_SITE_ITEM에 BPMS_EXIST 변경
		 UPDATE T1
		    SET T1.BPMS_EXIST		= T2.VALID_YN
			   ,T1.LAST_UPDATE_DATE = GETDATE()
		       ,T1.LAST_UPDATED_BY  = 'SYSTEM_BATCH_BOM'
		  FROM  SCM_MST_SITE_ITEM T1 INNER JOIN (  SELECT DIVISION_ID, 
														  PROJECT_CODE, 
														  PROJECT_VER_SEQ, 
														  ITEM_ID, 
														  VALID_YN
													 FROM SCM_MST_PROJECT_ITEM A WITH(NOLOCK)
													WHERE (
														   SELECT COUNT(1)
														     FROM SCM_MST_SITE_ITEM X WITH(NOLOCK)
															WHERE A.DIVISION_ID		= X.DIVISION_ID
														      AND A.ITEM_ID			= X.ITEM_ID
														      AND A.PROJECT_CODE	= X.PROJECT_CODE
														      AND A.VALID_YN	   <> X.BPMS_EXIST
														  ) > 0
												 ) T2 ON T1.PROJECT_CODE = T2.PROJECT_CODE
													 AND T1.DIVISION_ID = T2.DIVISION_ID
													 AND T1.ITEM_ID = T2.ITEM_ID
		;
		
PRINT ( 'I--' + CONVERT(NVARCHAR(30), GETDATE(), 121))	
		--[C20210312-000399] BPMS -> GSCM I/F 시 VALID 'N'은 SCM_MST_SITE_ITEM에 VALID_YN 변경
		 UPDATE T1
		    SET T1.VALID_YN		= T2.VALID_YN
			   ,T1.LAST_UPDATE_DATE = GETDATE()
		       ,T1.LAST_UPDATED_BY  = 'SYSTEM_BATCH_BOM_VALID_N'
		  FROM  SCM_MST_SITE_ITEM T1 INNER JOIN (  SELECT DIVISION_ID, 
														  PROJECT_CODE, 
														  PROJECT_VER_SEQ, 
														  ITEM_ID, 
														  VALID_YN
													FROM  SCM_MST_PROJECT_ITEM A WITH(NOLOCK)
													WHERE (
														   SELECT COUNT(1)
														     FROM SCM_MST_SITE_ITEM X WITH(NOLOCK)
															WHERE A.DIVISION_ID		= X.DIVISION_ID
														      AND A.ITEM_ID			= X.ITEM_ID
														      AND A.PROJECT_CODE	= X.PROJECT_CODE
														      AND A.VALID_YN	   <> X.VALID_YN
														  ) > 0
													AND   A.VALID_YN		 = 'N'
													AND   A.LAST_UPDATED_BY  = 'SYSTEM_BATCH_BOM' --[C20210312-000399] BPMS 에서 변경 된 VALID 'N'만 적용
													AND   A.LAST_UPDATE_DATE > GETDATE() - 0.01
												 ) T2 ON T1.PROJECT_CODE = T2.PROJECT_CODE
													 AND T1.DIVISION_ID = T2.DIVISION_ID
													 AND T1.ITEM_ID = T2.ITEM_ID
	
		--[E20240424-000960]_BPMS - SCM IF 시 SSPM의 Inactive 처리는 Site Type = “Sales”인 대상으로 한정되어 RTF 생성에 영향이 없도록 기능변경요청 START
		INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON T1.DIVISION_ID = B.DIVISION_ID
			   AND T1.SCM_SITE_ID = B.SCM_SITE_ID
	           AND B.SITE_TYPE   = 'SALES'
		--[E20240424-000960]_BPMS - SCM IF 시 SSPM의 Inactive 처리는 Site Type = “Sales”인 대상으로 한정되어 RTF 생성에 영향이 없도록 기능변경요청 END
		  WHERE T1.VALID_YN = 'Y'
		;
		
PRINT ( 'J--' + CONVERT(NVARCHAR(30), GETDATE(), 121))	
		--------------------------------------------------------------------
		--End  SCM 데이터 적용
		--------------------------------------------------------------------
		--[C20210312-000399] BPMS VALID 'N' Mail 전송
		EXEC PR_DM_DNM_BPMS_MAIL_SEND

		------------------------------------------------------------------------
		-- 트랜잭션 종료
		COMMIT;
			  
		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	   END TRY
	   ----------------------------------------------------------------------------
	   BEGIN CATCH
		      ROLLBACK;
		      
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	   END CATCH
	   ----------------------------------------------------------------------------
END

