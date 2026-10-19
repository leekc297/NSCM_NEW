

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_SR_EE_INPUT_ITEM_SITE]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.11 TAEHYUN Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  


	------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_SR_EE_INPUT_ITEM_SITE';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @P_PLAN_NAME         NVARCHAR(8);
    DECLARE @D_PLAN_NAME         DATETIME;


    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	BEGIN TRY
        ------------------------------------------------------------------------
        -- SET Param
        ------------------------------------------------------------------------
        SELECT @P_PLAN_NAME = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;

		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

		SELECT DIVISION_ID 
		INTO #DIVISION
		FROM SCM_MST_DIVISION WITH(NOLOCK)
		WHERE  VALID_YN = 'Y'
		AND    ATTRIBUTE3 <> 'EE'
		AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
		;

        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
            -- DEMAND INSERT
            ------------------------------------------------------------------------
            INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID	
                                              ,BUFFER_ID	
                                              ,SITE_ID	
                                              ,ITEM_ID	
                                              ,GRADE	
                                              ,SITE_TYPE	
                                              ,ITEM_CLASS_ID	
                                              ,INCH	
                                              ,FAB	
                                              ,STAGE	
                                              ,IS_INFINITE	
                                              ,IS_PURCHASED	
                                              ,PURCHASE_PERIOD	
                                              ,IS_NO_CARRY	
                                              ,STORAGE_ID	
                                              ,STORAGE_PER	
                                              ,SETUP_ID	
                                              ,SETUP_GROUP_ID	
                                              ,ITEM_GROUP_ID
                                              ,ATTRIBUTE1
                                              ,ATTRIBUTE2
                                              ,ATTRIBUTE3
                                             )
            SELECT   A.PLAN_ID                       AS PLAN_ID
                    ,A.BUFFER_ID                     AS BUFFER_ID
                    ,A.ATTRIBUTE1                    AS SITE_ID
                    ,A.ATTRIBUTE2                    AS ITEM_ID
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') +IIF(A.ATTRIBUTE4 IS NULL,'','@'+A.ATTRIBUTE4)+IIF(A.ATTRIBUTE5 IS NULL,'','@'+A.ATTRIBUTE5) AS GRADE
                    ,NULL                            AS SITE_TYPE
                    ,'DEMAND'                        AS ITEM_CLASS_ID
                    ,NULL                            AS INCH
                    ,NULL                            AS FAB
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') AS STAGE
                    ,NULL                            AS IS_INFINITE
                    ,NULL                            AS IS_PURCHASED
                    ,NULL                            AS PURCHASE_PERIOD
                    ,NULL                            AS IS_NO_CARRY
                    ,NULL                            AS STORAGE_ID
                    ,NULL                            AS STORAGE_PER
                    ,NULL                            AS SETUP_ID
                    ,B.NICK_NAME                     AS SETUP_GROUP_ID
                    ,NULL                            AS ITEM_GROUP_ID
                    ,A.ATTRIBUTE4                    AS INCOTERMS
                    ,A.ATTRIBUTE5                    AS PROJECT_CODE
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') AS STAGE
            FROM    SCP_OPT_ENG_DEMAND_SN A WITH(NOLOCK)

            INNER JOIN (SELECT ITEM_ID, MAX(NICK_NAME) AS NICK_NAME 
			            FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK)

						INNER JOIN #DIVISION D WITH(NOLOCK)
						ON B.DIVISION_ID = D.DIVISION_ID

						GROUP BY ITEM_ID
					   ) B 
			ON  A.ATTRIBUTE2 = B.ITEM_ID
            AND A.PLAN_ID    = @V_PLAN_ID

            WHERE 1=1
            GROUP BY A.PLAN_ID, A.BUFFER_ID, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, B.NICK_NAME

            ------------------------------------------------------------------------
            -- ADD DEMAND GROUP 
            ------------------------------------------------------------------------
            UNION ALL
            SELECT   A.PLAN_ID                       AS PLAN_ID
                    ,A.BUFFER_ID                     AS BUFFER_ID
                    ,A.ATTRIBUTE1                    AS SITE_ID
                    ,A.ATTRIBUTE2                    AS ITEM_ID
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') +IIF(A.ATTRIBUTE4 IS NULL,'','@'+A.ATTRIBUTE4)+IIF(A.ATTRIBUTE5 IS NULL,'','@'+A.ATTRIBUTE5) AS GRADE
                    ,NULL                            AS SITE_TYPE
                    ,'DEMAND'                        AS ITEM_CLASS_ID
                    ,NULL                            AS INCH
                    ,NULL                            AS FAB
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') AS STAGE
                    ,NULL                            AS IS_INFINITE
                    ,NULL                            AS IS_PURCHASED
                    ,NULL                            AS PURCHASE_PERIOD
                    ,NULL                            AS IS_NO_CARRY
                    ,NULL                            AS STORAGE_ID
                    ,NULL                            AS STORAGE_PER
                    ,NULL                            AS SETUP_ID
                    ,NULL                            AS SETUP_GROUP_ID
                    ,NULL                            AS ITEM_GROUP_ID
                    ,A.ATTRIBUTE4                    AS INCOTERMS
                    ,A.ATTRIBUTE5                    AS PROJECT_CODE
                    ,REPLACE(A.ATTRIBUTE3,' BIZ','') AS ATTRIBUTE3
            FROM    SCP_OPT_ENG_DEMAND_SN A WITH(NOLOCK)
            WHERE   PLAN_ID = @V_PLAN_ID
            AND     ATTRIBUTE12 = 'DEMAND_GROUP'
            GROUP BY A.PLAN_ID, A.BUFFER_ID, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
            ------------------------------------------------------------------------
            -- PRODUCTION INSERT
            -- 2025.07.08 Philsu Park: Storage Per값을 룩업 기반으로 반영
            ------------------------------------------------------------------------
            UNION ALL
            SELECT @V_PLAN_ID                            AS PLAN_ID
                  ,A.SITE_ID+'::'+A.ITEM_ID+'::'+A.STAGE AS BUFFER_ID
                  ,A.SITE_ID                             AS SITE_ID
                  ,A.ITEM_ID                             AS ITEM_ID
                  ,STAGE                                 AS GRADE
                  ,NULL                                  AS SITE_TYPE
                  ,'PRODUCTION'                          AS ITEM_CLASS_ID
                  ,NULL                                  AS INCH
                  ,NULL                                  AS FAB
                  ,STAGE                                 AS STAGE
                  ,NULL                                  AS IS_INFINITE
                  ,NULL                                  AS IS_PURCHASED
                  ,NULL                                  AS PURCHASE_PERIOD
                  ,NULL                                  AS IS_NO_CARRY
                  ,LU.SEGMENT3+'::'+LU.ATTRIBUTE1		 AS STORAGE_ID
                  ,IIF(LU.ATTRIBUTE1 IS NULL,NULL,ISNULL(LU.ATTRIBUTE2, 1)) AS STORAGE_PER
                --   ,LU.ATTRIBUTE1                         AS STORAGE_ID
                --   ,IIF(LU.ATTRIBUTE1 IS NULL,NULL,1)     AS STORAGE_PER
                  ,NULL                                  AS SETUP_ID
                  ,A.NICK_NAME                           AS SETUP_GROUP_ID
                  ,NULL                                  AS ITEM_GROUP_ID
                  ,NULL                                  AS INCOTERMS
                  ,NULL                                  AS PROJECT_CODE
                  ,STAGE                                 AS ATTRIBUTE3
            FROM(
					SELECT DISTINCT A.PLANT_SITE_ID AS SITE_ID
								   ,A.ITEM_ID       AS ITEM_ID
								   ,'PRODUCTION'    AS ITEM_CLASS_ID
								   ,CASE WHEN CO.COPY_NO = '1' THEN 'ELEC_POST'
										 WHEN CO.COPY_NO = '2' THEN 'COATING'
									END AS STAGE
								   ,B.NICK_NAME AS NICK_NAME
					FROM   SCM_MST_SITE_ITEM_PRIORITY A WITH (NOLOCK) 

					INNER JOIN #DIVISION D WITH(NOLOCK)
					ON A.DIVISION_ID = D.DIVISION_ID

					INNER JOIN SCM_MST_SITE S WITH (NOLOCK) 
					ON  A.DIVISION_ID    = S.DIVISION_ID
					AND A.PLANT_SITE_ID  = S.SCM_SITE_ID
					AND S.SITE_TYPE      = 'PLANT'
					AND S.VALID_YN       = 'Y'
					AND S.OPERATION_GROUP IN ('E') 
					AND A.VALID_YN       = 'Y'  
					AND A.TO_YYYYMMDD   >= @P_PLAN_NAME

					LEFT JOIN (SELECT B.DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME 
								FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK)

								INNER JOIN #DIVISION D WITH(NOLOCK)
								ON B.DIVISION_ID = D.DIVISION_ID

								GROUP BY B.DIVISION_ID, ITEM_ID
							   ) B
					ON    A.ITEM_ID    = B.ITEM_ID
					AND   A.DIVISION_ID = B.DIVISION_ID 
					
					LEFT JOIN (SELECT '1' AS COPY_NO UNION ALL SELECT '2' AS COPY_NO ) CO
					ON COPY_NO <= '2'

					WHERE 1=1
					/************************* 
					대상 프로젝트 ITEM 필터링 
					*************************/
					AND CONCAT(A.PLANT_SITE_ID, A.ITEM_ID) 
						IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
							FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
							WHERE  PLAN_ID = @V_PLAN_ID
						   ) 

                ) AS A
            /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SL_ITEM_MAP'
            AND LU.SEGMENT2    = @V_DIVISION_ID
            AND LU.VALID_YN    = 'Y'
            AND A.SITE_ID      = LU.SEGMENT3
            AND A.ITEM_ID      = LU.SEGMENT4
            AND A.STAGE        = LU.SEGMENT5*/-- BLOCKED 2025.12.05 jongykim2: Warehouse Capacity
            -- ADDED 2025.12.05 jongykim2: Warehouse Capacity
            LEFT OUTER JOIN (
                SELECT T.DIVISION_ID AS SEGMENT2
                     , T.SCM_SITE_ID AS SEGMENT3
                     , T.ITEM_ID     AS SEGMENT4
                     , T.STAGE       AS SEGMENT5
                     , T.WH_NM       AS ATTRIBUTE1
                     , T.STOR_PER    AS ATTRIBUTE2
                     , T.STOR_LOC    AS ATTRIBUTE4
                FROM   SCP_OPMZ_WAREHOUSE_ITEM_MAPPING T WITH(NOLOCK)
                INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                ON     T.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                WHERE  T.DIVISION_ID     = @V_DIVISION_ID
                AND    PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                AND    T.VALID_YN        = 'Y'
                AND    PG.VALID_YN       = 'Y'
                AND    CONCAT(T.SCM_SITE_ID,T.ITEM_ID) ----> 전극만 추가하면 됨!!!!
                         IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID)
                             FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                             WHERE  PLAN_ID = @V_PLAN_ID
                            )
               ) LU
                ON  1 = 1
                AND A.SITE_ID           = LU.SEGMENT3
                AND A.ITEM_ID           = LU.SEGMENT4
                AND A.STAGE             = LU.SEGMENT5
            WHERE 1=1
			

            ------------------------------------------------------------------------
            -- Item SIte 가 없는 INCOMING STOCK 은 ITEM_CLASS_ID = 'STOCK' 으로 추가
            --> ITEM_SITE를 만들어두고 없는애를 찾아야하기 때문에 INSERT를 끊어서 진행
            ------------------------------------------------------------------------ 
            INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID	
                                              ,BUFFER_ID	
                                              ,SITE_ID	
                                              ,ITEM_ID	
                                              ,GRADE	
                                              ,SITE_TYPE	
                                              ,ITEM_CLASS_ID	
                                              ,INCH	
                                              ,FAB	
                                              ,STAGE	
                                              ,IS_INFINITE	
                                              ,IS_PURCHASED	
                                              ,PURCHASE_PERIOD	
                                              ,IS_NO_CARRY	
                                              ,STORAGE_ID	
                                              ,STORAGE_PER	
                                              ,SETUP_ID	
                                              ,SETUP_GROUP_ID	
                                              ,ITEM_GROUP_ID
                                              ,ATTRIBUTE1
                                              ,ATTRIBUTE2
                                              ,ATTRIBUTE3
                                             )
            SELECT @V_PLAN_ID                            AS PLAN_ID
                  ,A.BUFFER_ID                           AS BUFFER_ID
                  ,A.ATTRIBUTE1                          AS SITE_ID
                  ,A.ATTRIBUTE2                          AS ITEM_ID
                  ,CASE WHEN A.ATTRIBUTE3 LIKE '%BIZ%' THEN SUBSTRING(BUFFER_ID, dbo.FN_CHARINDEX_REV(BUFFER_ID, '::', 0) + 2, 1000)
				        ELSE A.ATTRIBUTE3			  
				   END                                   AS GRADE
                  ,NULL                                  AS SITE_TYPE
                  ,'STOCK'                               AS ITEM_CLASS_ID
                  ,NULL                                  AS INCH
                  ,NULL                                  AS FAB
                  ,A.ATTRIBUTE3                          AS STAGE
                  ,NULL                                  AS IS_INFINITE
                  ,NULL                                  AS IS_PURCHASED
                  ,NULL                                  AS PURCHASE_PERIOD
                  ,NULL                                  AS IS_NO_CARRY
                  ,NULL                                  AS STORAGE_ID
                  ,NULL                                  AS STORAGE_PER
                  ,NULL                                  AS SETUP_ID
                  ,B.NICK_NAME                           AS SETUP_GROUP_ID
                  ,NULL                                  AS ITEM_GROUP_ID
                  ,A.ATTRIBUTE4                          AS INCOTERMS
                  ,A.ATTRIBUTE5                          AS PROJECT_CODE
                  ,A.ATTRIBUTE3                          AS ATTRIBUTE3
			FROM   SCP_OPT_ENG_INCOMING_STOCK_SN    A        WITH(NOLOCK)
            INNER JOIN SCP_MST_FINAL_ITEM B WITH(NOLOCK) ON  A.ATTRIBUTE2 = B.ITEM_ID
                                                         --AND B.DIVISION_ID= @V_DIVISION_ID

			INNER JOIN #DIVISION D WITH(NOLOCK)
			ON B.DIVISION_ID = D.DIVISION_ID

			WHERE  1=1
			AND    A.PLAN_ID = @V_PLAN_ID
			AND    A.BUFFER_ID IN (
								SELECT BUFFER_ID FROM SCP_OPT_ENG_INCOMING_STOCK_SN WITH(NOLOCK) WHERE PLAN_ID = @V_PLAN_ID
								EXCEPT
								SELECT BUFFER_ID FROM SCP_OPT_ENG_ITEM_SITE_SN      WITH(NOLOCK) WHERE PLAN_ID = @V_PLAN_ID
							   )
            GROUP BY A.BUFFER_ID,A.ATTRIBUTE1,A.ATTRIBUTE2,A.ATTRIBUTE3,B.NICK_NAME,A.ATTRIBUTE4,A.ATTRIBUTE5 --MEB 테스트하면 KEY 중복에러 발생해서 추가하였음, KTH
			
            ------------------------------------------------------------------------
            -- SCHEDULED_MOVE에 있지만 ITEM_SITE에 없는 데이터 등록
            --> ITEM_SITE + INCOMMING STOCK에 없는 BUFFER를 만들어두고 없는 애를 찾아야하기 때문에 INSERT를 끊어서 진행
            ------------------------------------------------------------------------ 
            INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID	
                                              ,BUFFER_ID	
                                              ,SITE_ID	
                                              ,ITEM_ID	
                                              ,GRADE	
                                              ,SITE_TYPE	
                                              ,ITEM_CLASS_ID	
                                              ,INCH	
                                              ,FAB	
                                              ,STAGE	
                                              ,IS_INFINITE	
                                              ,IS_PURCHASED	
                                              ,PURCHASE_PERIOD	
                                              ,IS_NO_CARRY	
                                              ,STORAGE_ID	
                                              ,STORAGE_PER	
                                              ,SETUP_ID	
                                              ,SETUP_GROUP_ID	
                                              ,ITEM_GROUP_ID
                                              ,ATTRIBUTE1
                                              ,ATTRIBUTE2
                                              ,ATTRIBUTE3
                                             )
            SELECT SM.PLAN_ID                      AS PLAN_ID
                  ,SM.FROM_BUFFER_ID               AS BUFFER_ID
                  ,SM.ATTRIBUTE1                   AS SITE_ID
                  ,SM.ATTRIBUTE2                   AS ITEM_ID
                  ,SM.ATTRIBUTE3                   AS GRADE
                  ,NULL                            AS SITE_TYPE
                  ,'SCHEDULED'                     AS ITEM_CLASS_ID
                  ,NULL                            AS INCH
                  ,NULL                            AS FAB
                  ,SM.ATTRIBUTE3                   AS STAGE
                  ,NULL                            AS IS_INFINITE
                  ,NULL                            AS IS_PURCHASED
                  ,NULL                            AS PURCHASE_PERIOD
                  ,NULL                            AS IS_NO_CARRY
                  ,NULL                            AS STORAGE_ID
                  ,NULL                            AS STORAGE_PER
                  ,NULL                            AS SETUP_ID
                  ,FI.NICK_NAME                    AS SETUP_GROUP_ID
                  ,NULL                            AS ITEM_GROUP_ID
                  ,NULL                            AS INCOTERMS
                  ,NULL                            AS PROJECT_CODE
                  ,SM.ATTRIBUTE3                   AS ATTRIBUTE3
            FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM WITH(NOLOCK)
                LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS  WITH(NOLOCK) 
                    ON  ITS.PLAN_ID   = SM.PLAN_ID
                    AND ITS.BUFFER_ID = SM.FROM_BUFFER_ID
                INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) ON  SM.ATTRIBUTE2 = FI.ITEM_ID
                                                              --AND FI.DIVISION_ID= @V_DIVISION_ID

			INNER JOIN #DIVISION D WITH(NOLOCK)
			ON FI.DIVISION_ID = D.DIVISION_ID

            WHERE   SM.PLAN_ID = @V_PLAN_ID
            AND     ITS.PLAN_ID IS NULL
            GROUP BY SM.PLAN_ID, SM.FROM_BUFFER_ID, SM.ATTRIBUTE1, SM.ATTRIBUTE2, SM.ATTRIBUTE3, FI.NICK_NAME
            UNION ALL
            SELECT SM.PLAN_ID                      AS PLAN_ID
                  ,SM.TO_BUFFER_ID                 AS BUFFER_ID
                  ,SM.ATTRIBUTE4                   AS SITE_ID
                  ,SM.ATTRIBUTE2                   AS ITEM_ID
                  ,SM.ATTRIBUTE5+'@'+SM.ATTRIBUTE9+'@'+SM.ATTRIBUTE10 AS GRADE
                  ,NULL                            AS SITE_TYPE
                  ,'SCHEDULED'                     AS ITEM_CLASS_ID
                  ,NULL                            AS INCH
                  ,NULL                            AS FAB
                  ,SM.ATTRIBUTE5                   AS STAGE
                  ,NULL                            AS IS_INFINITE
                  ,NULL                            AS IS_PURCHASED
                  ,NULL                            AS PURCHASE_PERIOD
                  ,NULL                            AS IS_NO_CARRY
                  ,NULL                            AS STORAGE_ID
                  ,NULL                            AS STORAGE_PER
                  ,NULL                            AS SETUP_ID
                  ,FI.NICK_NAME                    AS SETUP_GROUP_ID
                  ,NULL                            AS ITEM_GROUP_ID
                  ,SM.ATTRIBUTE9                   AS INCOTERMS
                  ,SM.ATTRIBUTE10                  AS PROJECT_CODE
                  ,SM.ATTRIBUTE5                   AS ATTRIBUTE3
            FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM WITH(NOLOCK)
                LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS  WITH(NOLOCK) 
                    ON  ITS.PLAN_ID   = SM.PLAN_ID
                    AND ITS.BUFFER_ID = SM.TO_BUFFER_ID
                INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                    ON  SM.ATTRIBUTE2 = FI.ITEM_ID
                    --AND FI.DIVISION_ID= @V_DIVISION_ID

				INNER JOIN #DIVISION D WITH(NOLOCK)
				ON FI.DIVISION_ID = D.DIVISION_ID

            WHERE   SM.PLAN_ID = @V_PLAN_ID
            AND     ITS.PLAN_ID IS NULL
            GROUP BY SM.PLAN_ID, SM.TO_BUFFER_ID, SM.ATTRIBUTE4, SM.ATTRIBUTE2, SM.ATTRIBUTE5, SM.ATTRIBUTE9, FI.NICK_NAME, SM.ATTRIBUTE10

        ------------------------------------------------------------------------
        -- 형 교환 NICK NAME UPDATE -> LOOKUP DATA 기준
        ------------------------------------------------------------------------ 
        UPDATE  SCP_OPT_ENG_ITEM_SITE_SN
                SET SETUP_GROUP_ID = LU.SEGMENT5
        FROM    SCP_OPT_ENG_ITEM_SITE_SN EIS WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_NICK_FOR_SETUP'
                AND LU.SEGMENT1 = @V_DIVISION_ID
                AND LU.SEGMENT2 = @V_GROUP_ID
                AND EIS.SITE_ID = LU.SEGMENT3
                AND EIS.ITEM_ID = LU.SEGMENT4
        WHERE   1=1
        AND     EIS.PLAN_ID = @V_PLAN_ID
        AND     EIS.ITEM_CLASS_ID = 'PRODUCTION'

        ------------------------------------------------------------------------
        -- LINE FULL LOADING 제약이 있으면 DINAMIC RAMP UP 적용을 위해 IDLE 데이터 추가 
        -- 2025-07-29 THK
        ------------------------------------------------------------------------ 
        INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN(PLAN_ID
                                            ,BUFFER_ID
                                            ,SITE_ID
                                            ,ITEM_ID
                                            ,GRADE
                                            ,ITEM_CLASS_ID
                                            ,STAGE
                                            ,ATTRIBUTE3
                                            )
        SELECT  @V_PLAN_ID              AS PLAN_ID
               ,SEGMENT3+'::IDLE::IDLE' AS BUFFER_ID
               ,SEGMENT3                AS SITE_ID
               ,'IDLE'                  AS ITEM_ID
               ,'IDLE'                  AS GRADE
               ,'PRODUCTION'            AS ITEM_CLASS_ID
               ,'IDLE'                  AS STAGE
               ,'IDLE'                  AS ATTRIBUTE3
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK) 
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_LINE'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_GROUP_ID
        AND     VALID_YN    = 'Y'


        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------
	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------
      -- ERROR LOG
	------------------------------------------------------------------------
        SET @V_MESSAGE_TEXT = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'ERROR',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
        ------------------------------------------------------------------------
        SELECT @V_DETAIL_DATE = GETDATE()
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_DATE,NULL,@V_MESSAGE_TEXT,'ERROR'
        ------------------------------------------------------------------------
        RAISERROR(@V_PROGRAM_NAME, 16,1)
        ------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

	------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    IF @V_MESSAGE_TEXT IS NULL 
    ------------------------------------------------------------------------
    BEGIN
	    EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'END',NULL,NULL,NULL,@V_PLAN_ID
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL
    END
    ------------------------------------------------------------------------
  END;
