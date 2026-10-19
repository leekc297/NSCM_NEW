
CREATE PROCEDURE [dbo].[PR_SCP_XIF_MMD_ALL_R]
-- ================================================================================================
-- Program ID          : 
--
-- Program Name        : PR_SCP_XIF_MMD_ALL_R
-- Param               :
-- Batch Period        : 20 minutes
-- Description         : GET MMD data from MMD
--
-- Source System       : MMD
-- Destination System  : SCP SDB
-- Source Table        : XIF_MMD_BAS_ITEM_DATA_R
-- Destination Table   : SCP_MST_MMD_KPI_EXC
--
-- Create(Update) Date : 2024.10.12
-- Author              : kim choon dong
-- Version             : 1.0
--                       2024-10-02			초기 정보 형성
-- ================================================================================================
    @P_BAS_ITEM_ID  NVARCHAR(50)
AS
	DECLARE C_DATA  CURSOR FOR
        SELECT [IF_SEQ]
			  ,SUBSTRING(IF_ID,1,4)   AS IF_SOURCE  -- 재료 구분자
			  ,[IF_RCV_DATE]          -- IF_RCV_DATE 조회추가
		      ,[BAS_ITEM_ID]
              ,[DISTRB_TG_BAS_ITEM_NAME]
              ,[SRC_REPSTR_ID]
              ,[SRC_BAS_ITEM_ID]
              ,[SRC_KEY_SEQ_NO]
              ,[SRC_HIST_SEQ_NO]
              ,[BAS_KEY_ATTR1]
              ,[BAS_KEY_ATTR2]
              ,[BAS_KEY_ATTR3]
              ,[BAS_KEY_ATTR4]
              ,[BAS_KEY_ATTR5]
              ,[BAS_KEY_ATTR6]
              ,[BAS_KEY_ATTR7]
              ,[BAS_KEY_ATTR8]
              ,[BAS_KEY_ATTR9]
              ,[BAS_KEY_ATTR10]
              ,[BAS_ATTR1]
              ,[BAS_ATTR2]
              ,[BAS_ATTR3]
              ,[BAS_ATTR4]
              ,[BAS_ATTR5]
              ,[BAS_ATTR6]
              ,[BAS_ATTR7]
              ,[BAS_ATTR8]
              ,[BAS_ATTR9]
              ,[BAS_ATTR10]
              ,[BAS_ATTR11]
              ,[BAS_ATTR12]
              ,[BAS_ATTR13]
              ,[BAS_ATTR14]
              ,[BAS_ATTR15]
			  ,[BAS_ATTR16]
			  ,[BAS_ATTR17]
			  ,[BAS_ATTR18]
			  ,[BAS_ATTR19]
			  ,[BAS_ATTR20]
			  ,[BAS_ATTR21]
			  ,[BAS_ATTR22]
			  ,[BAS_ATTR23]
			  ,[BAS_ATTR24]
			  ,[BAS_ATTR25]
			  ,[BAS_ATTR26]
			  ,[BAS_ATTR27]
			  ,[BAS_ATTR28]
			  ,[BAS_ATTR29]
			  ,[BAS_ATTR31]
              ,[BAS_ATTR32]
              ,[BAS_ATTR33]
              ,[BAS_ATTR34]
              ,[BAS_ATTR35]
              ,[BAS_ATTR36]
              ,[BAS_ATTR37]
              ,[BAS_ATTR38]
              ,[BAS_ATTR39]
              ,[BAS_ATTR40]
              ,[BAS_ATTR41]
              ,[BAS_ATTR42]
              ,[BAS_ATTR43]
              ,[BAS_ATTR44]
              ,[BAS_ATTR45]
              ,[BAS_ATTR46]
              ,[BAS_ATTR47]
              ,[BAS_ATTR48]
              ,[BAS_ATTR49]
              ,[BAS_ATTR50]
			  ,[BAS_ATTR56]
			  ,[BAS_ATTR57]
			  ,[BAS_ATTR80]
			  ,[BAS_ATTR115]
              ,[BAS_ATTR_MSG]
              ,[USE_FLAG]
              ,[DEL_FLAG]
        FROM  [dbo].[XIF_MMD_BAS_ITEM_DATA_R_SN] WITH(NOLOCK)
        WHERE ( @P_BAS_ITEM_ID IS NULL OR [BAS_ITEM_ID] = @P_BAS_ITEM_ID )
		AND   [BAS_ITEM_ID] IN ( 'TB_MMD_TRGT_KPI_EXCL_YEAR_MNTH' )
		AND   IF_ID       = 'OSC1_OFP0_BAS_ITEM_DATA'  -- 재료 사업본부 추가에 따른 조회 대상 제한
		AND   [RSLT_PROC_FLAG] = 'P'
		ORDER BY [IF_RCV_DATE];

    DECLARE @IF_SEQ                   NVARCHAR(50)
	DECLARE @IF_SOURCE                NVARCHAR(50)   -- 재료 구분자
	DECLARE @IF_RCV_DATE              DATETIME       -- IF_RCV_DATE 조회추가
    DECLARE @BAS_ITEM_ID              NVARCHAR(50)
	DECLARE @DISTRB_TG_BAS_ITEM_NAME  NVARCHAR(200)
	DECLARE @SRC_REPSTR_ID            NVARCHAR(50)
	DECLARE @SRC_BAS_ITEM_ID          NVARCHAR(50)
	DECLARE @SRC_KEY_SEQ_NO           NUMERIC(13,3)
	DECLARE @SRC_HIST_SEQ_NO          NUMERIC(13,3)
	DECLARE @BAS_KEY_ATTR1            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR2            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR3            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR4            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR5            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR6            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR7            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR8            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR9            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR10           NVARCHAR(100)
	DECLARE @BAS_ATTR1                NVARCHAR(2000)
	DECLARE @BAS_ATTR2                NVARCHAR(2000)
	DECLARE @BAS_ATTR3                NVARCHAR(2000)
	DECLARE @BAS_ATTR4                NVARCHAR(2000)
	DECLARE @BAS_ATTR5                NVARCHAR(2000)
	DECLARE @BAS_ATTR6                NVARCHAR(2000)
	DECLARE @BAS_ATTR7                NVARCHAR(2000)
	DECLARE @BAS_ATTR8                NVARCHAR(2000)
	DECLARE @BAS_ATTR9                NVARCHAR(2000)
	DECLARE @BAS_ATTR10               NVARCHAR(2000)
	DECLARE @BAS_ATTR11               NVARCHAR(2000)
	DECLARE @BAS_ATTR12               NVARCHAR(2000)
	DECLARE @BAS_ATTR13               NVARCHAR(2000)
	DECLARE @BAS_ATTR14               NVARCHAR(2000)
	DECLARE @BAS_ATTR15               NVARCHAR(2000)
	DECLARE @BAS_ATTR16               NVARCHAR(2000)
	DECLARE @BAS_ATTR17               NVARCHAR(2000)
	DECLARE @BAS_ATTR18               NVARCHAR(2000)
	DECLARE @BAS_ATTR19               NVARCHAR(2000)
	DECLARE @BAS_ATTR20               NVARCHAR(2000)
	DECLARE @BAS_ATTR21               NVARCHAR(2000)
	DECLARE @BAS_ATTR22               NVARCHAR(2000)
	DECLARE @BAS_ATTR23               NVARCHAR(2000)
	DECLARE @BAS_ATTR24               NVARCHAR(2000)
	DECLARE @BAS_ATTR25               NVARCHAR(2000)
	DECLARE @BAS_ATTR26               NVARCHAR(2000)
	DECLARE @BAS_ATTR27               NVARCHAR(2000)
	DECLARE @BAS_ATTR28               NVARCHAR(2000)
	DECLARE @BAS_ATTR29               NVARCHAR(2000)
	DECLARE @BAS_ATTR31               NVARCHAR(2000)
	DECLARE @BAS_ATTR32               NVARCHAR(2000)
	DECLARE @BAS_ATTR33               NVARCHAR(2000)
	DECLARE @BAS_ATTR34               NVARCHAR(2000)
	DECLARE @BAS_ATTR35               NVARCHAR(2000)
	DECLARE @BAS_ATTR36               NVARCHAR(2000)
	DECLARE @BAS_ATTR37               NVARCHAR(2000)
	DECLARE @BAS_ATTR38               NVARCHAR(2000)
	DECLARE @BAS_ATTR39               NVARCHAR(2000)
	DECLARE @BAS_ATTR40               NVARCHAR(2000)
	DECLARE @BAS_ATTR41               NVARCHAR(2000)
	DECLARE @BAS_ATTR42               NVARCHAR(2000)
	DECLARE @BAS_ATTR43               NVARCHAR(2000)
	DECLARE @BAS_ATTR44               NVARCHAR(2000)
	DECLARE @BAS_ATTR45               NVARCHAR(2000)
	DECLARE @BAS_ATTR46               NVARCHAR(2000)
	DECLARE @BAS_ATTR47               NVARCHAR(2000)
	DECLARE @BAS_ATTR48               NVARCHAR(2000)
	DECLARE @BAS_ATTR49               NVARCHAR(2000) -- WIDE_ROLL_ENABLE_FLAG / MMD 광폭 롤 가능 여부
	DECLARE @BAS_ATTR50               NVARCHAR(2000)
	DECLARE @BAS_ATTR56               NVARCHAR(2000) -- Interface 시스템 명 MES PROC_GR_CODE 수신 추가
	DECLARE @BAS_ATTR57               NVARCHAR(2000) -- Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
	DECLARE @BAS_ATTR80               NVARCHAR(2000) -- Interface 시스템 명 MES SOURCE GROUP 수신 추가
	DECLARE @BAS_ATTR115              NVARCHAR(2000) -- PRODUCT_LEVEL3_CODE / MMD 생산 반제품
	DECLARE @BAS_ATTR_MSG             NVARCHAR(4000)
	DECLARE @USE_FLAG                 NVARCHAR(1)
	DECLARE @DEL_FLAG                 NVARCHAR(1)
	DECLARE @LANG_TXT                 NVARCHAR(10) = 'en-US\'
	DECLARE @KR_LANG_TXT              NVARCHAR(10) = 'ko-KR\'

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

    -- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCP_XIF_MMD_ALL_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @data_s      INTEGER
	DECLARE @site_s      INTEGER

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	-- EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

    BEGIN TRY
	        
    	SET @v_temp1 = 'STEP UPDATE XIF_MMD_BAS_ITEM_DATA_R'
		UPDATE [dbo].[XIF_MMD_BAS_ITEM_DATA_R_SN]
		SET    [RSLT_PROC_FLAG] = 'P'
		      ,[UPDDTTM]     = GETDATE()
		WHERE ( @P_BAS_ITEM_ID IS NULL OR [BAS_ITEM_ID] = @P_BAS_ITEM_ID )
		AND   ISNULL([RSLT_PROC_FLAG],'N') = 'N'
		AND   [BAS_ITEM_ID] IN ( 'TB_MMD_TRGT_KPI_EXCL_YEAR_MNTH' )
		AND   IF_ID = 'OSC1_OFP0_BAS_ITEM_DATA';  --  전지 제한

        SET @v_temp1 = 'STEP OPEN CURSOR XIF_MMD_BAS_ITEM_DATA_R'
    	OPEN C_DATA
        FETCH NEXT FROM C_DATA INTO @IF_SEQ
								  , @IF_SOURCE      -- 재료 구분자
								  , @IF_RCV_DATE    -- IF_RCV_DATE 조회추가
	                              , @BAS_ITEM_ID
	                              , @DISTRB_TG_BAS_ITEM_NAME
	                              , @SRC_REPSTR_ID
	                              , @SRC_BAS_ITEM_ID
	                              , @SRC_KEY_SEQ_NO
	                              , @SRC_HIST_SEQ_NO
	                              , @BAS_KEY_ATTR1
	                              , @BAS_KEY_ATTR2
	                              , @BAS_KEY_ATTR3
	                              , @BAS_KEY_ATTR4
	                              , @BAS_KEY_ATTR5
	                              , @BAS_KEY_ATTR6
	                              , @BAS_KEY_ATTR7
	                              , @BAS_KEY_ATTR8
	                              , @BAS_KEY_ATTR9
	                              , @BAS_KEY_ATTR10
	                              , @BAS_ATTR1
	                              , @BAS_ATTR2
	                              , @BAS_ATTR3
	                              , @BAS_ATTR4
	                              , @BAS_ATTR5
	                              , @BAS_ATTR6
	                              , @BAS_ATTR7
	                              , @BAS_ATTR8
	                              , @BAS_ATTR9
	                              , @BAS_ATTR10
	                              , @BAS_ATTR11
	                              , @BAS_ATTR12
	                              , @BAS_ATTR13
	                              , @BAS_ATTR14
	                              , @BAS_ATTR15
								  , @BAS_ATTR16
								  , @BAS_ATTR17  -- 라인별 창고 수신하면서 추가
								  , @BAS_ATTR18  -- 라인별 창고 수신하면서 추가
								  , @BAS_ATTR19
								  , @BAS_ATTR20
								  , @BAS_ATTR21
								  , @BAS_ATTR22
								  , @BAS_ATTR23
								  , @BAS_ATTR24
								  , @BAS_ATTR25
								  , @BAS_ATTR26
								  , @BAS_ATTR27
								  , @BAS_ATTR28
								  , @BAS_ATTR29
	                              , @BAS_ATTR31
	                              , @BAS_ATTR32
	                              , @BAS_ATTR33
	                              , @BAS_ATTR34
	                              , @BAS_ATTR35
	                              , @BAS_ATTR36
	                              , @BAS_ATTR37
	                              , @BAS_ATTR38
	                              , @BAS_ATTR39
	                              , @BAS_ATTR40
	                              , @BAS_ATTR41
	                              , @BAS_ATTR42
	                              , @BAS_ATTR43
	                              , @BAS_ATTR44
	                              , @BAS_ATTR45
	                              , @BAS_ATTR46
	                              , @BAS_ATTR47
	                              , @BAS_ATTR48
	                              , @BAS_ATTR49  -- WIDE_ROLL_ENABLE_FLAG / MMD 광폭 롤 가능 여부
	                              , @BAS_ATTR50
								  , @BAS_ATTR56  -- Interface 시스템 명 MES PROC_GR_CODE 수신 추가
								  , @BAS_ATTR57  -- Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
								  , @BAS_ATTR80  -- Interface 시스템 명 MES SOURCE GROUP 수신 추가
								  , @BAS_ATTR115 -- PRODUCT_LEVEL3_CODE / MMD 생산 반제품
	                              , @BAS_ATTR_MSG
	                              , @USE_FLAG
	                              , @DEL_FLAG
    
        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN

            IF @BAS_ITEM_ID = 'TB_MMD_TRGT_KPI_EXCL_YEAR_MNTH'
			    BEGIN
                    -- BAS_KEY_ATTR1	AREAID	          영역아이디
                    -- BAS_KEY_ATTR2	EQSGID	          설비세그먼트아이디
                    -- BAS_KEY_ATTR3	PROCID	          공정아이디
                    -- BAS_KEY_ATTR4	EQPTID	          설비아이디
                    -- BAS_KEY_ATTR5	GDW_KPI_CODE	  GDW KPI 코드
                    -- BAS_KEY_ATTR6	FROM_DTTM	      From 일자
                    -- BAS_ATTR1	    TO_DTTM	          To 일자
                    -- BAS_ATTR2	    EXCEL_DVZN_CODE	  제외 사업부 코드
                    -- USE_FLAG	        USE_FLAG	      사용여부

					SET @v_temp1 = 'STEP SCP_MST_MMD_KPI_EXCT Merge'

					-- Model Lot 정보저장    
					MERGE INTO [DBO].[SCP_MST_MMD_KPI_EXCT] A
					USING ( SELECT @BAS_KEY_ATTR1	                 AS FACTORY_ID	-- 영역아이디
								  ,ISNULL( ( SELECT ME.LINE_ID
								             FROM 	SCM_MST_EQUIPMENT_SN ME WITH(NOLOCK)
											 WHERE  ME.FACTORY_ID   = @BAS_KEY_ATTR1
											 AND    ME.MES_LINE_ID  = @BAS_KEY_ATTR2
											 AND    ME.OPERATION_ID = @BAS_KEY_ATTR3
											 AND    ME.EQUIPMENT_ID = @BAS_KEY_ATTR4 )
										   , @BAS_KEY_ATTR2 )        AS LINE_ID	    -- 설비세그먼트아이디
								 ,@BAS_KEY_ATTR3	                 AS OPERATION_ID	-- 공정아이디
								 ,@BAS_KEY_ATTR4	                 AS EQUIPMENT_ID	-- 설비아이디
								 ,@BAS_KEY_ATTR5	                 AS KPI_TYPE	    -- GDW KPI 코드
								 ,CASE WHEN ISDATE(@BAS_KEY_ATTR6) = 1 THEN @BAS_KEY_ATTR6 ELSE '99991231' END AS FROM_DATE	-- From 일자
								 ,CASE WHEN @BAS_ATTR1 = '99999999' THEN '99991231'
								       ELSE CASE WHEN ISDATE(@BAS_ATTR1) = 1 THEN @BAS_ATTR1 ELSE '99991231' END
									   END                           AS TO_DATE	    -- To 일자
								 ,ISNULL( ( SELECT ALD.ATTRIBUTE1
                                            FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] ALD WITH(NOLOCK)
                                            WHERE  ALD.LOOKUP_TYPE = 'SCP_MST_MMD_KPI_EXCT_DIV'
                                            AND    ALD.SEGMENT1    = @BAS_ATTR2 ), 'ALL')
								 	                                 AS EXCEPTION_DIVISION_ID	-- 제외 사업부 코드
								 ,@USE_FLAG	                         AS VALID_YN	-- 사용여부
				 		  ) B
					ON (     A.FACTORY_ID	= B.FACTORY_ID    -- 영역아이디
						 AND A.LINE_ID	    = B.LINE_ID       -- 설비세그먼트아이디
						 AND A.OPERATION_ID	= B.OPERATION_ID  -- 공정아이디
						 AND A.EQUIPMENT_ID	= B.EQUIPMENT_ID  -- 설비아이디
						 AND A.KPI_TYPE	    = B.KPI_TYPE      -- GDW KPI 코드
						 AND A.FROM_DATE	= B.FROM_DATE     -- From 일자
						)
					WHEN MATCHED THEN
				 	UPDATE SET  A.[TO_DATE]               = B.[TO_DATE]
	                           ,A.[EXCEPTION_DIVISION_ID] = B.[EXCEPTION_DIVISION_ID]
	                           ,A.[VALID_YN]              = B.[VALID_YN]
	                           ,A.[LAST_UPDATED_BY]       = @V_PROC_NAME
	                           ,A.[LAST_UPDATE_DATE]      = GETDATE()
					WHEN NOT MATCHED THEN
				 	INSERT ( [FACTORY_ID]
                            ,[LINE_ID]
                            ,[OPERATION_ID]
                            ,[EQUIPMENT_ID]
                            ,[KPI_TYPE]
                            ,[FROM_DATE]
                            ,[TO_DATE]
                            ,[EXCEPTION_DIVISION_ID]
                            ,[VALID_YN]
                            ,[CREATED_BY]
                            ,[CREATION_DATE]
                            ,[LAST_UPDATED_BY]
                            ,[LAST_UPDATE_DATE]
							)
				 	VALUES (
							 B.[FACTORY_ID]
                            ,B.[LINE_ID]
                            ,B.[OPERATION_ID]
                            ,B.[EQUIPMENT_ID]
                            ,B.[KPI_TYPE]
                            ,B.[FROM_DATE]
                            ,B.[TO_DATE]
                            ,B.[EXCEPTION_DIVISION_ID]
                            ,B.[VALID_YN]
                            ,@V_PROC_NAME
				 			,GETDATE()
				 			,@V_PROC_NAME
				 			,GETDATE()
				 			);

					UPDATE [dbo].[XIF_MMD_BAS_ITEM_DATA_R_SN]
					SET [RSLT_PROC_FLAG] = 'Y'
					   ,[PROC_FLAG]      = 'Y'
					   ,[UPDDTTM]        = GETDATE()
					WHERE [RSLT_PROC_FLAG]   = 'P'
					AND   [BAS_ITEM_ID] = 'TB_MMD_TRGT_KPI_EXCL_YEAR_MNTH'
					AND   [IF_SEQ]      = @IF_SEQ;

				END; -- IF @BAS_ITEM_ID = 'TB_MMD_TRGT_KPI_EXCL_YEAR_MNTH'

			FETCH NEXT FROM C_DATA INTO @IF_SEQ
									  , @IF_SOURCE      -- 재료 구분자
									  , @IF_RCV_DATE    -- IF_RCV_DATE 조회추가
									  , @BAS_ITEM_ID
									  , @DISTRB_TG_BAS_ITEM_NAME
									  , @SRC_REPSTR_ID
									  , @SRC_BAS_ITEM_ID
									  , @SRC_KEY_SEQ_NO
									  , @SRC_HIST_SEQ_NO
									  , @BAS_KEY_ATTR1
									  , @BAS_KEY_ATTR2
									  , @BAS_KEY_ATTR3
									  , @BAS_KEY_ATTR4
									  , @BAS_KEY_ATTR5
									  , @BAS_KEY_ATTR6
									  , @BAS_KEY_ATTR7
									  , @BAS_KEY_ATTR8
									  , @BAS_KEY_ATTR9
									  , @BAS_KEY_ATTR10
									  , @BAS_ATTR1
									  , @BAS_ATTR2
									  , @BAS_ATTR3
									  , @BAS_ATTR4
									  , @BAS_ATTR5
									  , @BAS_ATTR6
									  , @BAS_ATTR7
									  , @BAS_ATTR8
									  , @BAS_ATTR9
									  , @BAS_ATTR10
									  , @BAS_ATTR11
									  , @BAS_ATTR12
									  , @BAS_ATTR13
									  , @BAS_ATTR14
									  , @BAS_ATTR15
									  , @BAS_ATTR16
									  , @BAS_ATTR17  -- 라인별 창고 수신하면서 추가
									  , @BAS_ATTR18  -- 라인별 창고 수신하면서 추가
									  , @BAS_ATTR19
									  , @BAS_ATTR20
									  , @BAS_ATTR21
									  , @BAS_ATTR22
									  , @BAS_ATTR23
									  , @BAS_ATTR24
									  , @BAS_ATTR25
									  , @BAS_ATTR26
									  , @BAS_ATTR27
									  , @BAS_ATTR28
									  , @BAS_ATTR29
									  , @BAS_ATTR31
									  , @BAS_ATTR32
									  , @BAS_ATTR33
									  , @BAS_ATTR34
									  , @BAS_ATTR35
									  , @BAS_ATTR36
									  , @BAS_ATTR37
									  , @BAS_ATTR38
									  , @BAS_ATTR39
									  , @BAS_ATTR40
									  , @BAS_ATTR41
									  , @BAS_ATTR42
									  , @BAS_ATTR43
									  , @BAS_ATTR44
									  , @BAS_ATTR45
									  , @BAS_ATTR46
									  , @BAS_ATTR47
									  , @BAS_ATTR48
									  , @BAS_ATTR49
									  , @BAS_ATTR50
									  , @BAS_ATTR56  -- Interface 시스템 명 MES PROC_GR_CODE 수신 추가
									  , @BAS_ATTR57  -- Interface 시스템 명 MES PROC_DETL_TYPE_CODE 수신 추가
									  , @BAS_ATTR80  -- Interface 시스템 명 MES SOURCE GROUP 수신 추가
                                      , @BAS_ATTR115
									  , @BAS_ATTR_MSG
									  , @USE_FLAG
									  , @DEL_FLAG

        END  -- WHILE @@FETCH_STATUS = 0  C_DATA
        CLOSE C_DATA;
        DEALLOCATE C_DATA;   -- 메모리 해제


        SET @v_temp1 = 'STEP END PROCEDURE'
        --EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   @v_count, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

    END TRY

	BEGIN CATCH

		SET @v_descr = ERROR_MESSAGE()
		--EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, @v_temp1, @v_descr, @sysdate

	END CATCH

END
