
--CREATE PROCEDURE [dbo].[PR_XIF_RENEW_ROUTE_R]
CREATE PROCEDURE [dbo].[YMH_PR_XIF_RENEW_ROUTE_R]
-- ================================================================================================
-- Program ID          : FP02451 MMD 수신된 Route를 다시 갱신함. ECO 적용에 따른 보완 작업
--
-- Program Name        : PR_XIF_RENEW_ROUTE_R
-- Param               :
-- Batch Period        : 7.5 12.5 18.5 3회 수행
-- Description         : BOM 수신 후 일괄 갱신 작업 수행
--
-- Source System       : MMD
-- Destination System  : FP SDB
-- Source Table        : XIF_MMD_BAS_ITEM_DATA_R, SCM_BOM_M
-- Destination Table   : SCM_MMD_ITEM_ROUTE_TEMP. SCM_ITEM_M
-- Create(Update) Date : 2020.06.26
-- Author              : kim choon dong
-- Version             : 1.3
--                       2017-04-15 신규 작성
--                       2017-09-02 kimcd EM010103 cell 위에 cell 존재하는 경우 조립 route skip로직 추가
--                       2017-11-17 kimcd 남경 소형 조립 A6000 제거
--                       2017-12-09 남경 소형 활성화 후 공정 Cell 조립 Route skip 로직 보완
--                       2017-12-26 kimcd 활성화 후 공정 Route 점검을 양산 Route 아닌 것도 포함되도록 조건 변경
--                       2018-01-22 kimcd 하위 반제품이 변경된 경우도 Route 재형성 대상에 포함되도록 보완
--                       2018-06-08 kimcd F7200(Taping) 2D 모델, F7300(Side Taping) 일반 모델 공정 구분하기 위해 HARD CODING
--                       2018-10-02 kimcd 활성화 후 공정에서 DSF는 degas(F4000)만 설정되도록 보완
--                                        수작업 특성(F5600)의 경우 값 유지
--                                        불필요한 Route 수신 정보 정리 - cell 품목에 crt
--                                                                        cell에 활성화
--                       2018-12-03 kimcd 선분산 pre wetting 공정용 품목 코드 E0500 공정 추가
--                       2019-08-01 kimcd A5000A6000이 A5000 operation flow가 공장동별 설비에 따라 구분되어 사용됨.
--                                        MMD에서는 Option 형태로 등록됨. MMD 정보 수신하는 과정에서
--                                        각 법인별 Operation 사용 여부에 따라 품목에 설정되도록 수정
--                       2019-08-29 kimcd Formation Flow id 형성 lookup을 company 기준으로 변경 - G184, G664 구분용
--                       2020-01-02 kimcd Transaction commit, rollback 제거
--                       2020-01-10 kimcd 품목별 Route 수신에서 N으로 바뀌는 로직 수정(ALL이나 해당 Plant만).
--                       2020-01-21 kimcd 남경 원각 초소형의 활성화 Flow가 F5100 공정임. Route 형성 과정 수정
--                       2020-04-13 kimcd F7200 공정설정하는 로직에 ART008 라우트 추가
--                       2020-06-26 kimcd CRT 할당된 Cell 정보 정리하는 작업 수정 - C.FLOWNORM 조건 제거
--                       2023-06-23 FP Pjt. 활성화 공정 반제품 전환 / Cell Assy 일 경우 상위 Product 항목 제거
--                       2024-03-28 KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영 및 하드코딩 제거
--                       2024-09-01 FP Pjt. E20240828-000936 / 슬러리 품목에 대한 MMD Route 정보 수신 제외 (DRT006 : Dam Mixing Route 제외)
-- ================================================================================================
AS

	DECLARE C_ITEM_OP_DATA  CURSOR FOR
        SELECT [IF_SEQ]
		      ,[BAS_ITEM_ID]
              ,[DISTRB_TG_BAS_ITEM_NAME]
              ,[SRC_REPSTR_ID]
              ,[SRC_BAS_ITEM_ID]
              ,[SRC_KEY_SEQ_NO]
              ,[SRC_HIST_SEQ_NO]
              ,[BAS_KEY_ATTR1] -- [SHOPID] 플랜트아이디
              ,[BAS_KEY_ATTR2] -- [PRODID] 제품아이디
              ,[BAS_KEY_ATTR3] -- [ROUTID] 경로아이디
              ,[BAS_ATTR1]     -- [EQSGID] 설비세그먼트아이디
              ,[BAS_ATTR_MSG]
              ,[USE_FLAG]
              ,[DEL_FLAG]
			  ,( SELECT TOP 1 'Y'
			     FROM   DBO.SCM_MMD_ROUTEPATH_M  R
				 WHERE  R.[ROUTID]   = A.[BAS_KEY_ATTR3]
				 AND    R.[FLOWID]   = R.[FLOWID_TO]
				  -- AND    R.[FLOWNORM] = 'Y' 2017-12-26 kimcd block condiion - FRT005처럼 양산 ROUTE로 연결 안 되는 경우도 활성화 라우트로 포함.
				 AND    (R.[PROCID] LIKE 'F%' OR R.[PROCID_TO] LIKE 'F%') )  AS FORM_ROUTE -- kimcd 2017-09-02 add 활성화 Route 구분
        FROM  [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R] A WITH(NOLOCK)
        WHERE [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
		--AND   [PROC_FLAG] = 'P'
		AND   [BAS_KEY_ATTR3] != 'DRT006'   --E20240828-000936 / 슬러리 품목에 대한 MMD Route 정보 수신 제외 (DRT006 : Dam Mixing Route 제외)
		and [BAS_KEY_ATTR2] = 'EP096636PFBA-AA0'
		ORDER BY [IF_SEQ], [IF_RCV_DATE];

    DECLARE @IF_SEQ                   NVARCHAR(50)
    DECLARE @BAS_ITEM_ID              NVARCHAR(50)
	DECLARE @DISTRB_TG_BAS_ITEM_NAME  NVARCHAR(200)
	DECLARE @SRC_REPSTR_ID            NVARCHAR(50)
	DECLARE @SRC_BAS_ITEM_ID          NVARCHAR(50)
	DECLARE @SRC_KEY_SEQ_NO           NUMERIC(13,3)
	DECLARE @SRC_HIST_SEQ_NO          NUMERIC(13,3)
	DECLARE @BAS_KEY_ATTR1            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR2            NVARCHAR(100)
	DECLARE @BAS_KEY_ATTR3            NVARCHAR(100)
	DECLARE @BAS_ATTR1                NVARCHAR(2000)
	DECLARE @BAS_ATTR_MSG             NVARCHAR(4000)
	DECLARE @USE_FLAG                 NVARCHAR(1)
	DECLARE @DEL_FLAG                 NVARCHAR(1)

	DECLARE @COMPANY_ID               NVARCHAR(30)
	DECLARE @DIVISION_ID              NVARCHAR(30)
	DECLARE @SITE_ID                  NVARCHAR(30)
	DECLARE @PLANT_ID                 NVARCHAR(30)
	DECLARE @PROCESS_FLAG             NVARCHAR(1)
	DECLARE @OPERATION_ID_CNT		  INT = 0;
	DECLARE @MMD_ROUTEPATH_CNT        INT = 0;
	DECLARE @PROC_MSG			      NVARCHAR(2000) = 'Success';
    DECLARE @NERP_PLANT_ID            NVARCHAR(30)  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영
	
	DECLARE @OPERATION_GROUP_ID       NVARCHAR(1)
    DECLARE @FLOW_ID                  NVARCHAR(150)
	DECLARE @TOP_ITEM_ID			  NVARCHAR(150)
	DECLARE @PARENT_ITEM_ID			  NVARCHAR(150)
	DECLARE @CHILD_ITEM_ID			  NVARCHAR(150)
	DECLARE @PHANTOM				  NVARCHAR(150)
	DECLARE @MAKE_BUY                 NVARCHAR(10)
	DECLARE @LOOP_FLAG                NVARCHAR(10)
	DECLARE @LOOP_COUNT               INT
	DECLARE @MIN_LEVEL                NUMERIC(13,3)
	DECLARE @PATH_LEVEL               NUMERIC(13,3)
	DECLARE @HOLD_COMPANY_ID          NVARCHAR(30)
	DECLARE @HOLD_DIVISION_ID         NVARCHAR(30)
	DECLARE @HOLD_SITE_ID             NVARCHAR(30)
	DECLARE @R_OPERATION_GROUP_ID     NVARCHAR(1)
	DECLARE @FORM_ROUTE               NVARCHAR(1) -- kimcd 2017-09-02 add 활성화 Route 구분
	DECLARE @SKIP_ROUTE_FLAG          NVARCHAR(1) -- kimcd 2017-09-02 조립 Route 형성 예외 flag



BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

    -- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_RENEW_ROUTE_R'
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
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

    BEGIN TRY
		SET @v_temp1 = 'STEP DELETE Duplicate Route'
		DELETE A
		FROM   DBO.SY_XIF_MMD_BAS_ITEM_DATA_R A 
		WHERE  A.PROC_FLAG IN ( 'N', 'P')
		AND    A.BAS_ITEM_ID IN ('TB_MMD_SHOP_PRDT_ROUT')
		AND    A.IF_SEQ != (SELECT MAX(B.IF_SEQ)
							FROM   DBO.SY_XIF_MMD_BAS_ITEM_DATA_R B WITH(NOLOCK)
							WHERE  B.PROC_FLAG IN ( 'N', 'P')
							AND    B.BAS_ITEM_ID IN ('TB_MMD_SHOP_PRDT_ROUT')
							AND    B.BAS_KEY_ATTR1 = A.BAS_KEY_ATTR1
							AND    B.BAS_KEY_ATTR2 = A.BAS_KEY_ATTR2
							AND    B.BAS_KEY_ATTR3 = A.BAS_KEY_ATTR3);

		-- 2018-10-02 kimcd 추가 시작
		-- Cell이면서 CMA Route 수신되어 미수신으로 남는 정보 삭제
		SET @v_temp1 = 'STEP DELETE Cell with CMA Route'
		DELETE  B
		FROM 	SY_XIF_MMD_BAS_ITEM_DATA_R B
			   -- ,SCM_MMD_ROUTEPATH_M        C WITH(NOLOCK)	-- 2020-06-26 kimcd 재작업이나 다른 유형의 Route도 삭제되도록 조건 제거함		
			   ,SCM_ITEM_M                 I WITH(NOLOCK)							
		WHERE   1 = 1 -- B.BAS_KEY_ATTR3 = C.ROUTID	2020-06-26 kimcd 재작업이나 다른 유형의 Route도 삭제되도록 조건 제거함
		-- AND     C.FLOWNORM      = 'Y'  2020-06-26 kimcd 재작업이나 다른 유형의 Route도 삭제되도록 조건 제거함
		AND     B.BAS_KEY_ATTR2 = I.ITEM_ID									
		AND     B.PROC_FLAG in ( 'N', 'P')									
		and     B.BAS_ITEM_ID   = 'TB_MMD_SHOP_PRDT_ROUT'		
		AND     B.BAS_KEY_ATTR3 LIKE 'CRT%' -- CMA Route
		AND     I.ITEM_CLASS = 'EM0201' -- Cell
		AND     EXISTS ( SELECT 1
						 FROM   DBO.SCM_BOM_M BM								
						 WHERE  BM.PLANT_ID       = ( CASE WHEN B.BAS_KEY_ATTR1  = 'ALL' OR B.BAS_KEY_ATTR1 IS NULL THEN 							
														  BM.PLANT_ID							
													  ELSE 
														  ( SELECT TOP 1 F.[PLANT_ID]
			                                                FROM   [DBO].[SCM_FACTORY_M] F WITH(NOLOCK)
			                                                WHERE  F.[MES_PLANT_ID]      = B.BAS_KEY_ATTR1
			                                                AND    F.[ACTIVE_FLAG]       = 'Y' ) -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
													  END )
						 AND    BM.PARENT_ITEM_ID = B.BAS_KEY_ATTR2 )

		PRINT 1

		SET @v_temp1 = 'STEP DELETE Cell with Formation Route'
		DELETE B
		FROM 	SY_XIF_MMD_BAS_ITEM_DATA_R B
			   ,SCM_ITEM_M                 I WITH(NOLOCK)
		WHERE   B.BAS_KEY_ATTR2 = I.ITEM_ID									
		AND     B.PROC_FLAG     = 'Y'							
		and     B.BAS_ITEM_ID   = 'TB_MMD_SHOP_PRDT_ROUT'		
		AND     B.BAS_KEY_ATTR3 LIKE 'FRT%' -- 활성화 Route
		AND     I.FLOW_ID LIKE 'A%' -- 조립 공정 Route할당된 품목
		-- 2018-10-02 kimcd 추가 끝


		PRINT 2

		SET @v_temp1 = 'STEP Update IF Status to Renew'
		UPDATE A SET PROC_FLAG = 'N'
		from   DBO.SY_XIF_MMD_BAS_ITEM_DATA_R A 
			 , DBO.SCM_BOM_M C
		where  A.PROC_FLAG = 'Y'
		AND    A.BAS_ITEM_ID IN ('TB_MMD_SHOP_PRDT_ROUT')
		AND    C.PARENT_ITEM_ID = A.BAS_KEY_ATTR2
		AND    ( A.BAS_KEY_ATTR1 = 'ALL' OR C.PLANT_ID = ( SELECT TOP 1 F.[PLANT_ID]
			                                                FROM   SCM_FACTORY_M  F  WITH(NOLOCK)
			                                                WHERE  F.[MES_PLANT_ID]     = A.BAS_KEY_ATTR1
			                                                AND    F.[ACTIVE_FLAG]      = 'Y' ) )  -- 2020-01-10 kimcd PLANT별 BOM으로 대상 제한 -- 2024-03-28 NERP PLANT_ID 변경에 따른 LOOKUP 로직 반영
		AND    C.KEY_DATE       > A.IF_RCV_DATE-1
		AND    C.KEY_DATE       > GETDATE() - 2
		AND    A.IF_SEQ  = (SELECT MAX(B.IF_SEQ)
							FROM   DBO.SY_XIF_MMD_BAS_ITEM_DATA_R(NOLOCK) B
							WHERE  B.PROC_FLAG = 'Y'
							AND    B.BAS_ITEM_ID IN ('TB_MMD_SHOP_PRDT_ROUT')
							AND    B.BAS_KEY_ATTR1 = A.BAS_KEY_ATTR1
							AND    B.BAS_KEY_ATTR2 = A.BAS_KEY_ATTR2
							AND    B.BAS_KEY_ATTR3 = A.BAS_KEY_ATTR3
							);
								
		PRINT 3

		SET @v_temp1 = 'STEP Update IF Status to Renew for sub item'
		UPDATE A SET PROC_FLAG = 'N'
		from   DBO.SY_XIF_MMD_BAS_ITEM_DATA_R A
		      ,( SELECT DISTINCT T.MODEL_ID, T.PLANT_ID
				 FROM   SCM_MODEL_COMP_TEMP T WITH(NOLOCK)
				 WHERE  T.INSERT_TIME > GETDATE() - 1
				 AND    T.PLANT_ID    = T.CHILD_PLANT_ID ) B   -- 2020-01-10 kimcd 복원 대상을 Plant별로 구함
		where  A.PROC_FLAG = 'Y'
		AND    A.BAS_ITEM_ID IN ('TB_MMD_SHOP_PRDT_ROUT')
		AND    A.BAS_KEY_ATTR2 = B.MODEL_ID
		AND    ( A.BAS_KEY_ATTR1 = 'ALL' OR ( SELECT TOP 1 F.[PLANT_ID]
			                                  FROM   SCM_FACTORY_M  F  WITH(NOLOCK)
			                                  WHERE  F.[MES_PLANT_ID]     = A.BAS_KEY_ATTR1
			                                  AND    F.[ACTIVE_FLAG]      = 'Y' ) = B.PLANT_ID)  -- 2020-01-10 kimcd 복원 대상을 Plant별로 구함 -- 2024-03-28 NERP PLANT_ID 변경에 따른 LOOKUP 로직 반영
		AND    A.IF_SEQ  = (SELECT MAX(B.IF_SEQ)
							FROM   DBO.SY_XIF_MMD_BAS_ITEM_DATA_R(NOLOCK) B
							WHERE  B.PROC_FLAG = 'Y'
							AND    B.BAS_ITEM_ID IN ('TB_MMD_SHOP_PRDT_ROUT')
							AND    B.BAS_KEY_ATTR1 = A.BAS_KEY_ATTR1
							AND    B.BAS_KEY_ATTR2 = A.BAS_KEY_ATTR2
							AND    B.BAS_KEY_ATTR3 = A.BAS_KEY_ATTR3
							)

    --BEGIN TRANSACTION;  2020-01-02 kimcd Transaction commit, rollback 제거
		PRINT 4	        
    	SET @v_temp1 = 'STEP UPDATE XIF_MMD_BAS_ITEM_DATA_R'
		UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
		SET    [PROC_FLAG]   = 'P'
		      ,[UPDDTTM]     = GETDATE()
		WHERE [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
		AND   ISNULL([PROC_FLAG],'N') = 'N';


		PRINT 5

		SET @v_temp1 = 'STEP OPEN CURSOR ITEM OP'
    	OPEN C_ITEM_OP_DATA  -- ROUTE 정보가 먼저 수신되고 품목별 ROUTE 정보를 설정하기 위해 CURSOR 분리
        FETCH NEXT FROM C_ITEM_OP_DATA INTO @IF_SEQ
										  , @BAS_ITEM_ID
										  , @DISTRB_TG_BAS_ITEM_NAME
										  , @SRC_REPSTR_ID
										  , @SRC_BAS_ITEM_ID
										  , @SRC_KEY_SEQ_NO
										  , @SRC_HIST_SEQ_NO
										  , @BAS_KEY_ATTR1  -- [SHOPID] 플랜트아이디
										  , @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
										  , @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
										  , @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
										  , @BAS_ATTR_MSG
										  , @USE_FLAG
										  , @DEL_FLAG
										  , @FORM_ROUTE -- kimcd 2017-09-02 add

		PRINT 6
        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			SET @PROCESS_FLAG = 'N'  -- 기본값 설정
			SET @SKIP_ROUTE_FLAG = 'N' -- kimcd 2017-09-02 add MCSS20253-A4 MCSS20253-A2의 Cell 하위 Cell의 경우 정상 Route 적용 제외하기 위해 로직 추가

            SELECT @NERP_PLANT_ID = CASE WHEN @BAS_KEY_ATTR1 = 'ALL' THEN @BAS_KEY_ATTR1
                                                                     ELSE ISNULL( ( SELECT TOP 1 F.[PLANT_ID]
			                                                                        FROM   [DBO].[SCM_FACTORY_M] F WITH(NOLOCK)
			                                                                        WHERE  F.[MES_PLANT_ID]     = @BAS_KEY_ATTR1
			                                                                        AND    F.[ACTIVE_FLAG]      = 'Y'  ), @BAS_KEY_ATTR1 ) END;      -- 2024-02-14 NERP PLANT_ID 변경에 따른 CONVERSION 반영

                                                                   --  ELSE ( SELECT TOP 1 F.[PLANT_ID]
			                                                                --FROM   [DBO].[SCM_FACTORY_M] F WITH(NOLOCK)
			                                                                --WHERE  F.[MES_PLANT_ID]     = @BAS_KEY_ATTR1
			                                                                --AND    F.[ACTIVE_FLAG]      = 'Y'  ) END;      -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
				
			IF @USE_FLAG = 'Y'
			BEGIN
				SET @v_temp1 = 'STEP clear old data'
				DELETE [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
				WHERE  [MMD_PLANT_ID] = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
				AND    [MODEL_ID]     = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
				AND    [MMD_ROUTID]   = @BAS_KEY_ATTR3;  -- [ROUTID] 경로아이디

				PRINT CONCAT('6-1','::',@NERP_PLANT_ID,'::',@BAS_KEY_ATTR2,'::',@BAS_KEY_ATTR3)

				SET @R_OPERATION_GROUP_ID = NULL
				SELECT @R_OPERATION_GROUP_ID = SO.[OPERATION_GROUP_ID]
				FROM   [DBO].[SCM_OPERATION_M]  SO  WITH(NOLOCK)
					  ,[DBO].[SCM_LINE_M]       SL  WITH(NOLOCK)
				WHERE  SO.[COMPANY_ID]   = SL.[COMPANY_ID]
				AND    SO.[DIVISION_ID]  = SL.[DIVISION_ID]
				AND    SO.[SITE_ID]      = SL.[SITE_ID]
				AND    SO.[OPERATION_ID] = SL.[OPERATION_ID]
				AND    SL.LINE_ID = @BAS_ATTR1;


				

				IF @R_OPERATION_GROUP_ID IS NULL
					BEGIN
						SET @R_OPERATION_GROUP_ID = 'M';
					END;

				IF @BAS_ATTR1 IS NULL
					BEGIN
						SET @BAS_ATTR1 = '-';
					END;

				BEGIN

					PRINT '6-2'

					SET @v_temp1 = 'STEP insert first item - cell model'
					INSERT INTO [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
						( [MMD_PLANT_ID]
						, [MODEL_ID]
						, [MMD_ROUTID]
						, [MMD_LINE_ID]
						, [OPERATION_GROUP_ID]
						, [COMPANY_ID]
						, [DIVISION_ID]
						, [SITE_ID]
						, [PLANT_ID]
						, [PARENT_ITEM_ID]
						, [CHILD_ITEM_ID]
						, [PHANTOM]
						, [NLEVEL]
						, [CONCATENATE_ITEM]
						, [SORT_ORDER]
						, [ITEM_TYPE]
						, [CHILD_OP_GR_ID]
						, [PARENT_DIVISION_ID]
						, [PARENT_PLANT_ID]
						, [ITEM_CLASS]  -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
						, [INSERT_ID]
						, [INSERT_TIME]
						, [UPDATE_ID]
						, [UPDATE_TIME] )
					SELECT 	  @NERP_PLANT_ID  -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
							, @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
							, @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
							, @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
							, @R_OPERATION_GROUP_ID
							, BM.[COMPANY_ID]
							, BM.[DIVISION_ID]
							, BM.[SITE_ID]
							, BM.[PLANT_ID]
							, '*'                    -- [PARENT_ITEM_ID]
							, BM.[PARENT_ITEM_ID]    -- [CHILD_ITEM_ID]
							, 'N'					  -- [PHANTOM]
							, 0					  -- [NLEVEL]
							, BM.[PARENT_ITEM_ID]    -- [CONCATENATE_ITEM]
							, '0000'                 -- [SORT_ORDER]
							, MAX(IM.[ITEM_TYPE])    -- [ITEM_TYPE]
							, MAX(ICL.[OPERATION_GROUP_ID]) -- [CHILD_OP_GR_ID] CHILD_ITEM Operation Group ID
							, BM.[DIVISION_ID]       -- [PARENT_DIVISION_ID]
							, BM.[PLANT_ID]          -- [PARENT_PLANT_ID]
							, MAX(IM.[ITEM_CLASS])   -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
							, @v_proc_name			  -- [INSERT_ID]
							, GETDATE()			  -- [INSERT_TIME]
							, @v_proc_name			  -- [UPDATE_ID]
							, GETDATE()			  -- [UPDATE_TIME]
					FROM   [DBO].[SCM_ITEM_CLASS_LEVEL_M]  ICL  WITH(NOLOCK)
							, [DBO].[SCM_ITEM_CLASS_M]  ICM     WITH(NOLOCK)
							, [DBO].[SCM_BOM_M]  BM    WITH(NOLOCK)
							, [DBO].[SCM_ITEM_M] IM    WITH(NOLOCK)
					WHERE  BM.[COMPANY_ID]  = IM.[COMPANY_ID]
					AND    BM.[DIVISION_ID] = IM.[DIVISION_ID]
					AND    BM.[SITE_ID]     = IM.[SITE_ID]
					AND    BM.[PARENT_ITEM_ID] = IM.[ITEM_ID]
					AND    ICM.[CLASS_ID]   = IM.[ITEM_CLASS]
					AND    ICL.[LEVEL_ID]   = ICM.[LEVEL_3_ID]
					AND    ICL.[LEVEL_CODE] = ICM.[LEVEL_3_CODE]
					AND    ICL.[LEVEL]      = 3
					AND    IM.[ITEM_ID]     = @BAS_KEY_ATTR2 -- [PRODID] 제품아이디
					AND    (@NERP_PLANT_ID = 'ALL' OR BM.[PLANT_ID] = @NERP_PLANT_ID) -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
					GROUP BY BM.[COMPANY_ID]
							, BM.[DIVISION_ID]
							, BM.[SITE_ID]
							, BM.[PLANT_ID]
							, BM.[PARENT_ITEM_ID];
				END;

				SET @LOOP_FLAG = 'Y'
				SET @LOOP_COUNT = 0





				-- kimcd 2017-09-02 add start
				SELECT TOP 1 @SKIP_ROUTE_FLAG = 'Y'
				FROM   [DBO].[SCM_ITEM_CLASS_M]         ICM   WITH(NOLOCK)
						, [DBO].[SCM_ITEM_CLASS_M]         PCM   WITH(NOLOCK)
						, [DBO].[SCM_ITEM_M]               IM    WITH(NOLOCK)
						, [DBO].[SCM_ITEM_M]               PM    WITH(NOLOCK)
						, [DBO].[SCM_BOM_M]                BM    WITH(NOLOCK)
						, [DBO].[SCM_SYS_LOOKUP_VALUE]     SSLV  WITH(NOLOCK)
						, [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]  MIR   WITH(NOLOCK)
				WHERE  BM.[COMPANY_ID]     = IM.[COMPANY_ID]
				AND    BM.[DIVISION_ID]    = IM.[DIVISION_ID]
				AND    BM.[SITE_ID]        = IM.[SITE_ID]
				AND    BM.[CHILD_ITEM_ID]  = IM.[ITEM_ID]
				AND    SSLV.[LOOKUP_TYPE_CODE] = 'BOM_LINK_PLANT'
				AND    SSLV.[ACTIVE_FLAG]  = 'Y'
				AND    SSLV.[SEGMENT1]     = MIR.[PLANT_ID]
				AND    BM.[SITE_ID]        = MIR.[SITE_ID]
				AND    BM.[PLANT_ID]       = SSLV.[SEGMENT2]
				AND    BM.[COMPANY_ID]     = MIR.[COMPANY_ID]
				AND    BM.[PARENT_ITEM_ID] = MIR.[CHILD_ITEM_ID]
				AND    BM.[PARENT_ITEM_ID] != BM.[CHILD_ITEM_ID]
				AND    MIR.[COMPANY_ID]    = PM.[COMPANY_ID]
				AND    MIR.[DIVISION_ID]   = PM.[DIVISION_ID]
				AND    MIR.[SITE_ID]       = PM.[SITE_ID]
				AND    MIR.[CHILD_ITEM_ID] = PM.[ITEM_ID]
				AND    IM.[ITEM_CLASS]     = ICM.[CLASS_ID]
				AND    PM.[ITEM_CLASS]     = PCM.[CLASS_ID]
				-- AND    ICM.[CLASS_ID]      = PCM.[CLASS_ID] -- kimcd 2017-12-09 조건 block. 남경 소형 조립. 활성화 후공정 반영
				AND    ICM.[SKIP_ROUTE_FLAG] = 'Y'
				AND    PCM.[SKIP_ROUTE_FLAG] = 'Y'            -- kimcd 2017-12-09 남경 소형 조립. 활성화 후공정 반영. 상하위 품목이 모두 skip인 경우만 skip
				AND    MIR.[MMD_PLANT_ID]  = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
				AND    MIR.[MODEL_ID]      = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
				AND    MIR.[MMD_ROUTID]    = @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
				AND    MIR.[NLEVEL]        = @LOOP_COUNT
				--AND    BM.EFF_END_DATE    >= CAST(GETDATE() AS DATE)
				AND    BM.EFF_END_DATE    >= getdate()
				AND    BM.EFF_START_DATE  < getdate()

				PRINT CONCAT('6-3','::',@SKIP_ROUTE_FLAG)

				IF @SKIP_ROUTE_FLAG = 'Y'
					SET @LOOP_FLAG = 'N'
				-- kimcd 2017-09-02 add end


				WHILE @LOOP_FLAG = 'Y' -- BOM 전개 수행
				BEGIN
					SET @PROCESS_FLAG = 'Y'  -- 일단 진행으로
					SET @v_temp1 = 'STEP INSERT LOOP'
					INSERT INTO [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
						( [MMD_PLANT_ID]
						, [MODEL_ID]
						, [MMD_ROUTID]
						, [MMD_LINE_ID]
						, [OPERATION_GROUP_ID]
						, [COMPANY_ID]
						, [DIVISION_ID]
						, [SITE_ID]
						, [PLANT_ID]
						, [PARENT_ITEM_ID]
						, [CHILD_ITEM_ID]
						, [PHANTOM]
						, [NLEVEL]
						, [CONCATENATE_ITEM]
						, [SORT_ORDER]
						, [ITEM_TYPE]
						, [CHILD_OP_GR_ID]
						, [PARENT_DIVISION_ID]
						, [PARENT_PLANT_ID]
						, [ITEM_CLASS]  -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
						, [INSERT_ID]
						, [INSERT_TIME]
						, [UPDATE_ID]
						, [UPDATE_TIME] )
					SELECT @NERP_PLANT_ID  -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						 , @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
						 , @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
						 , @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
						 , @R_OPERATION_GROUP_ID
						 , BS.[COMPANY_ID]
						 , BS.[DIVISION_ID]
						 , BS.[SITE_ID]
						 , BS.[PLANT_ID]
						 , BS.[PARENT_ITEM_ID]
						 , BS.[CHILD_ITEM_ID]
						 , BS.[PHANTOM]
						 , BS.[NLEVEL]
						 , BS.[CONCATENATE_ITEM]
						 , BS.[SORT_ORDER] + REPLICATE('0', 4 - LEN(BS.[RANK_ORDER]) ) + CAST( BS.[RANK_ORDER] AS NVARCHAR)        -- [SORT_ORDER]
						 , BS.[ITEM_TYPE]
						 , BS.[OPERATION_GROUP_ID]   -- [CHILD_OP_GR_ID]
						 , BS.[PARENT_DIVISION_ID]
						 , BS.[PARENT_PLANT_ID]
						 , BS.[ITEM_CLASS]        -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
						 , @v_proc_name			  -- [INSERT_ID]
						 , GETDATE()			  -- [INSERT_TIME]
						 , @v_proc_name			  -- [UPDATE_ID]
						 , GETDATE()			  -- [UPDATE_TIME]
					FROM  ( SELECT BM.[COMPANY_ID]
								 , BM.[DIVISION_ID]
								 , BM.[SITE_ID]
								 , BM.[PLANT_ID]
								 , BM.[PARENT_ITEM_ID]
								 , BM.[CHILD_ITEM_ID]
								 , BM.[PHANTOM]
								 , @LOOP_COUNT+1			AS NLEVEL
								 , MAX(MIR.[SORT_ORDER])    AS SORT_ORDER
								 , RANK() OVER ( PARTITION BY BM.[COMPANY_ID]
															, BM.[DIVISION_ID]
															, BM.[SITE_ID]
															, BM.[PLANT_ID]
															, BM.[PARENT_ITEM_ID]
												 ORDER BY BM.[COMPANY_ID]
														, BM.[DIVISION_ID]
														, BM.[SITE_ID]
														, BM.[PLANT_ID]
														, BM.[PARENT_ITEM_ID]
														, BM.[CHILD_ITEM_ID] )  AS RANK_ORDER
								 , MIR.[CONCATENATE_ITEM] + '^' + BM.[CHILD_ITEM_ID]  AS CONCATENATE_ITEM
								 , MAX(IM.[ITEM_TYPE])      AS ITEM_TYPE
								 , ( SELECT ICL.[OPERATION_GROUP_ID]
									 FROM   [DBO].[SCM_ITEM_CLASS_LEVEL_M]  ICL  WITH(NOLOCK)
										  , [DBO].[SCM_ITEM_CLASS_M]  ICM   WITH(NOLOCK)
									 WHERE  ICM.[CLASS_ID]      = MAX(IM.[ITEM_CLASS])
									 AND    ICL.[LEVEL_ID]      = ICM.[LEVEL_3_ID]
									 AND    ICL.[LEVEL_CODE]    = ICM.[LEVEL_3_CODE]
									 AND    ICL.[LEVEL]         = 3
									 )                               AS OPERATION_GROUP_ID  -- [CHILD_OP_GR_ID] CHILD_ITEM Operation Group ID
								 , MIR.[DIVISION_ID]                 AS PARENT_DIVISION_ID
								 , MIR.[PLANT_ID]                    AS PARENT_PLANT_ID
								 , MAX(IM.[ITEM_CLASS])              AS ITEM_CLASS          -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
							FROM   [DBO].[SCM_BOM_M]  BM   WITH(NOLOCK)
								 , [DBO].[SCM_ITEM_M] IM   WITH(NOLOCK)
								 , [DBO].[SCM_SYS_LOOKUP_VALUE]   SSLV   WITH(NOLOCK)
								 , [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]  MIR  WITH(NOLOCK)
							WHERE  BM.[COMPANY_ID]     = IM.[COMPANY_ID]
							AND    BM.[DIVISION_ID]    = IM.[DIVISION_ID]
							AND    BM.[SITE_ID]        = IM.[SITE_ID]
							AND    BM.[CHILD_ITEM_ID]  = IM.[ITEM_ID]
							AND    SSLV.[LOOKUP_TYPE_CODE] = 'BOM_LINK_PLANT'
							AND    SSLV.[ACTIVE_FLAG]  = 'Y'
							AND    SSLV.[SEGMENT1]     = MIR.[PLANT_ID]
							AND    BM.[SITE_ID]        = MIR.[SITE_ID]
							AND    BM.[PLANT_ID]       = SSLV.[SEGMENT2]
							AND    BM.[COMPANY_ID]     = MIR.[COMPANY_ID]
							AND    BM.[PARENT_ITEM_ID] = MIR.[CHILD_ITEM_ID]
							AND    BM.[PARENT_ITEM_ID] != BM.[CHILD_ITEM_ID]
							AND    IM.[ITEM_CLASS]    != MIR.[ITEM_CLASS] -- 2020-01-10 kimcd 상하위 같은 item class 전개 방지
							AND    MIR.[MMD_PLANT_ID]  = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영
							AND    MIR.[MODEL_ID]      = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
							AND    MIR.[MMD_ROUTID]    = @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
							AND    MIR.[NLEVEL]        = @LOOP_COUNT
							--AND    BM.EFF_END_DATE    >= CAST(GETDATE() AS DATE)
							AND    BM.EFF_END_DATE    >= getdate()
							AND    BM.EFF_START_DATE  < getdate()
							-- AND    IM.ITEM_TYPE       IN ('H', 'P')   -- kimcd block 2017-06-05 item 확장이 BOM 형성보다 나중에 되는 경우 route 수신 안 됨
							GROUP BY BM.[COMPANY_ID]
								   , BM.[DIVISION_ID]
								   , BM.[SITE_ID]
								   , BM.[PLANT_ID]
								   , BM.[PARENT_ITEM_ID]
								   , BM.[CHILD_ITEM_ID]
								   , BM.[PHANTOM]
								   , MIR.[CONCATENATE_ITEM]
								   , MIR.[DIVISION_ID]
								   , MIR.[PLANT_ID]) BS
					;

					IF @@ROWCOUNT > 0
						SET @LOOP_COUNT = @LOOP_COUNT+1
					ELSE
						SET @LOOP_FLAG = 'N'

				END -- WHILE @LOOP_FLAG = 'Y'

				PRINT '6-4'

				SET @v_temp1 = 'STEP ADD ADDITIONAL CHILD FOR SUB DIVISION'
				INSERT INTO [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
					( [MMD_PLANT_ID]
					, [MODEL_ID]
					, [MMD_ROUTID]
					, [MMD_LINE_ID]
					, [OPERATION_GROUP_ID]
					, [COMPANY_ID]
					, [DIVISION_ID]
					, [SITE_ID]
					, [PLANT_ID]
					, [PARENT_ITEM_ID]
					, [CHILD_ITEM_ID]
					, [PHANTOM]
					, [NLEVEL]
					, [CONCATENATE_ITEM]
					, [SORT_ORDER]
					, [ITEM_TYPE]
					, [CHILD_OP_GR_ID]
					, [PARENT_DIVISION_ID]
					, [PARENT_PLANT_ID]
					, [INSERT_ID]
					, [INSERT_TIME]
					, [UPDATE_ID]
					, [UPDATE_TIME] )
				SELECT @NERP_PLANT_ID  -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
					 , @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
					 , @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
					 , @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
					 , @R_OPERATION_GROUP_ID
					 , BS.[COMPANY_ID]
					 , BS.[DIVISION_ID]
					 , BS.[SITE_ID]
					 , BS.[PLANT_ID]
					 , BS.[PARENT_ITEM_ID]
					 , BS.[CHILD_ITEM_ID]
					 , BS.[PHANTOM]
					 , BS.[NLEVEL]
					 , BS.[CONCATENATE_ITEM]
					 , BS.[SORT_ORDER]       -- [SORT_ORDER]
					 , BS.[ITEM_TYPE]
					 , BS.[OPERATION_GROUP_ID]   -- [CHILD_OP_GR_ID]
					 , BS.[PARENT_DIVISION_ID]
					 , BS.[PARENT_PLANT_ID]
					 , @v_proc_name			  -- [INSERT_ID]
					 , GETDATE()			  -- [INSERT_TIME]
					 , @v_proc_name			  -- [UPDATE_ID]
					 , GETDATE()			  -- [UPDATE_TIME]
				FROM  ( SELECT MIR.[COMPANY_ID]
							 , MIR.[DIVISION_ID]
							 , MIR.[SITE_ID]
							 , MIR.[PLANT_ID]
							 , MIR.[PARENT_ITEM_ID]
							 , MIR.[PARENT_ITEM_ID]     AS CHILD_ITEM_ID
							 , 'N'                      AS PHANTOM
							 , MAX(UMIR.[NLEVEL])		AS NLEVEL
							 , MAX(UMIR.[SORT_ORDER])   AS SORT_ORDER
							 , UMIR.[CONCATENATE_ITEM]  AS CONCATENATE_ITEM
							 , MAX(IM.[ITEM_TYPE])		AS ITEM_TYPE
							 , ( SELECT ICL.[OPERATION_GROUP_ID]
								 FROM   [DBO].[SCM_ITEM_CLASS_LEVEL_M]  ICL   WITH(NOLOCK)
									  , [DBO].[SCM_ITEM_CLASS_M]  ICM   WITH(NOLOCK)
								 WHERE  ICM.[CLASS_ID]       = MAX(IM.[ITEM_CLASS])
								 AND    ICL.[LEVEL_ID]       = ICM.[LEVEL_3_ID]
								 AND    ICL.[LEVEL_CODE]     = ICM.[LEVEL_3_CODE]
								 AND    ICL.[LEVEL]          = 3 )        AS OPERATION_GROUP_ID  -- [CHILD_OP_GR_ID] CHILD_ITEM Operation Group ID
							 , MIR.[DIVISION_ID]                 AS PARENT_DIVISION_ID
							 , MIR.[PLANT_ID]                    AS PARENT_PLANT_ID
						FROM   [DBO].[SCM_ITEM_M] IM  WITH(NOLOCK)
							 , [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]  UMIR  WITH(NOLOCK)
							 , [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]  MIR   WITH(NOLOCK)
						WHERE  MIR.[COMPANY_ID]     = IM.[COMPANY_ID]
						AND    MIR.[DIVISION_ID]    = IM.[DIVISION_ID]
						AND    MIR.[SITE_ID]        = IM.[SITE_ID]
						AND    MIR.[PARENT_ITEM_ID] = IM.[ITEM_ID]
						AND    MIR.[MMD_PLANT_ID]              = UMIR.[MMD_PLANT_ID]        -- [SHOPID] 플랜트아이디
						AND    MIR.[MODEL_ID]                  = UMIR.[MODEL_ID]            -- [PRODID] 제품아이디
						AND	   MIR.[MMD_ROUTID]                = UMIR.[MMD_ROUTID]          -- [ROUTID] 경로아이디
						AND	   MIR.[OPERATION_GROUP_ID]        = UMIR.[OPERATION_GROUP_ID]
						AND    MIR.[COMPANY_ID]                = UMIR.[COMPANY_ID]
						AND    MIR.[PARENT_DIVISION_ID]        = UMIR.[DIVISION_ID]
						AND    MIR.[SITE_ID]                   = UMIR.[SITE_ID]
						AND    MIR.[PARENT_PLANT_ID]           = UMIR.[PLANT_ID]
						AND    MIR.[PARENT_ITEM_ID]            = UMIR.[CHILD_ITEM_ID]
						AND    MIR.[CONCATENATE_ITEM]       LIKE UMIR.[CONCATENATE_ITEM] + '^%'
						AND    UMIR.[MMD_PLANT_ID]             = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						AND    UMIR.[MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
						AND    UMIR.[MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
						AND    MIR.[MMD_PLANT_ID]              = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영
						AND    MIR.[MODEL_ID]                  = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
						AND    MIR.[MMD_ROUTID]                = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
						AND    ( MIR.[DIVISION_ID] != MIR.[PARENT_DIVISION_ID]
								 OR MIR.[PLANT_ID] != MIR.[PARENT_PLANT_ID] ) 
					    GROUP BY MIR.[COMPANY_ID]
							   , MIR.[DIVISION_ID]
							   , MIR.[SITE_ID]
							   , MIR.[PLANT_ID]
							   , MIR.[PARENT_ITEM_ID]
							   , UMIR.[CONCATENATE_ITEM]
							   , MIR.[DIVISION_ID]
							   , MIR.[PLANT_ID] ) BS
				WHERE NOT EXISTS (  SELECT 1
									FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] CMIR  WITH(NOLOCK)
									WHERE  CMIR.[MMD_PLANT_ID]             = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
									AND    CMIR.[MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
									AND    CMIR.[MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
									AND    CMIR.[COMPANY_ID]               = BS.[COMPANY_ID]
									AND    CMIR.[DIVISION_ID]              = BS.[DIVISION_ID]
									AND    CMIR.[SITE_ID]                  = BS.[SITE_ID]
									AND    CMIR.[PLANT_ID]                 = BS.[PLANT_ID]
									AND    CMIR.[CONCATENATE_ITEM]         = BS.[CONCATENATE_ITEM]
									AND    CMIR.[PARENT_DIVISION_ID]       = BS.[PARENT_DIVISION_ID]
									AND    CMIR.[PARENT_PLANT_ID]          = BS.[PARENT_PLANT_ID]
								 );

				PRINT '6-5'

				-- 2023-06-23 FP Pjt. 활성화 공정 반제품 전환 / Cell Assy 일 경우 상위 Product 항목 제거
				DELETE T
				  FROM [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] AS T
				 WHERE 1 = 1
				   AND T.[MMD_PLANT_ID]			= @NERP_PLANT_ID -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
				   AND T.[MODEL_ID]				= @BAS_KEY_ATTR2
				   AND T.[MMD_ROUTID]			= @BAS_KEY_ATTR3
				   AND T.[MMD_LINE_ID]			= @BAS_ATTR1 
				   AND T.[MMD_ROUTID]			LIKE 'ART%'
				   AND T.NLEVEL < (
					   SELECT MIN(S.NLEVEL)
					     FROM [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] AS S WITH(NOLOCK)
					          JOIN SCM_ITEM_M AS X WITH(NOLOCK)
					      ON S.COMPANY_ID			= X.COMPANY_ID
					     AND S.DIVISION_ID			= X.DIVISION_ID
					     AND S.SITE_ID				= X.SITE_ID
					     AND S.CHILD_ITEM_ID		= X.ITEM_ID  
					     AND X.ITEM_CLASS			= 'ES1901'
					   WHERE 1 = 1
					     AND S.[MMD_PLANT_ID]		= T.[MMD_PLANT_ID]
					     AND S.[MODEL_ID]			= T.[MODEL_ID]
					     AND S.[MMD_ROUTID]			= T.[MMD_ROUTID]
					     AND S.[MMD_LINE_ID]		= T.[MMD_LINE_ID]
					   )

				--3050 제거
				DELETE T
				FROM [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] AS T
				WHERE 1 = 1
				AND T.[MMD_PLANT_ID]		= @NERP_PLANT_ID -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
				AND T.[MODEL_ID]			= @BAS_KEY_ATTR2
				AND T.[MMD_ROUTID]			= @BAS_KEY_ATTR3
				AND T.[MMD_LINE_ID]			= @BAS_ATTR1 
				AND T.COMPANY_ID            IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'COMPANY_A' AND ACTIVE_FLAG = 'Y')
				AND T.DIVISION_ID           IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'DIVISION_A' AND ACTIVE_FLAG = 'Y')
				AND T.SITE_ID               IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'SITE_A' AND ACTIVE_FLAG = 'Y')
				AND T.PLANT_ID              IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'PLANT_A' AND ACTIVE_FLAG = 'Y')  -- 2024-03-28 하드코딩 제거


			END; -- IF @USE_FLAG = 'Y'


			IF @PROCESS_FLAG = 'Y' AND ISNULL(@FORM_ROUTE,'N')  != 'Y' AND @SKIP_ROUTE_FLAG = 'N'
			-- kimcd 2017-09-02 -- 활성화 Route가 아닌 경우만 아래 과정 수행되도록 "AND ISNULL(@FORM_ROUTE,'N')  != 'Y'"조건 추가
			-- kimcd 2017-09-02 -- 활성화 후 공정 Tab Cell의 Route 제한을 위해 "AND @SKIP_ROUTE_FLAG = 'N'" 조건 추가
				BEGIN

					PRINT '7'

					SET @v_temp1 = 'STEP CURSOR  C_MMD_ROUTE'
					DECLARE C_MMD_ROUTE CURSOR FOR
						SELECT A.[COMPANY_ID]
							 , A.[DIVISION_ID]  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
							 , A.[SITE_ID]
							 , A.[FLOW_ID]
							 , MAX(A.[PATH_LEVEL])          AS PATH_LEVEL
							 , MAX(A.[OPERATION_GROUP_ID])  AS OPERATION_GROUP_ID
						FROM  ( SELECT SMR.[COMPANY_ID]
									 , SMR.[DIVISION_ID]
									 , SMR.[SITE_ID]
									 , SMR.[FIRST_FLOW_ID]     AS FLOW_ID
									 , SMR.[PATH_LEVEL]+0.5    AS PATH_LEVEL
									 , SO.[OPERATION_GROUP_ID]
								FROM   [dbo].[SCM_OPERATION_M]     SO    WITH(NOLOCK)
									 , [DBO].[SCM_MMD_ROUTEPATH_M] SMR   WITH(NOLOCK)
								WHERE  SO.[COMPANY_ID]   = SMR.[COMPANY_ID]
								AND    SO.[DIVISION_ID]  = SMR.[DIVISION_ID]
								AND    SO.[SITE_ID]      = SMR.[SITE_ID]
								AND    SO.[OPERATION_ID] = SMR.[PROCID]
								AND    SMR.[ROUTID]      = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
								AND    SMR.[FIRST_FLOW_ID] IS NOT NULL
								UNION
								SELECT SMR.[COMPANY_ID]
									 , SMR.[DIVISION_ID]
									 , SMR.[SITE_ID]
									 , SMR.[FLOW_ID]
									 , SMR.[PATH_LEVEL]
									 , SO.[OPERATION_GROUP_ID]
								FROM   [dbo].[SCM_OPERATION_M]     SO   WITH(NOLOCK)
									 , [DBO].[SCM_MMD_ROUTEPATH_M] SMR  WITH(NOLOCK)
								WHERE  SO.[COMPANY_ID]   = SMR.[COMPANY_ID]
								AND    SO.[DIVISION_ID]  = SMR.[DIVISION_ID]
								AND    SO.[SITE_ID]      = SMR.[SITE_ID]
								AND    SO.[OPERATION_ID] = SMR.[PROCID_TO]
								AND    SMR.[ROUTID]      = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
								AND    SMR.[FLOW_ID]    IS NOT NULL
								) A
						WHERE A.[FLOW_ID] != ( CASE WHEN ( @BAS_KEY_ATTR2 LIKE 'ASLPD%' OR @BAS_KEY_ATTR2 LIKE 'ASLPW%' ) THEN -- kimcd 2018-12-03 ASLPW 조건 추가
													    'E1000'
													ELSE
													    '-1'
													END  ) -- 2017-03-29. 선분산 Route가 E1000, E0500으로 구성됨. 선분산 코드 HARD CODING...
					    GROUP  BY A.[COMPANY_ID]
								, A.[DIVISION_ID]  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
								, A.[SITE_ID]
								, A.[FLOW_ID] 
						ORDER  BY A.[COMPANY_ID]
								, A.[DIVISION_ID]  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
								, A.[SITE_ID]
								, MAX(A.[PATH_LEVEL]);


					SET @v_temp1 = 'STEP OPEN CURSOR C_MMD_ROUTE'
					SET @MIN_LEVEL = -1
					OPEN C_MMD_ROUTE
					FETCH NEXT FROM C_MMD_ROUTE INTO  @COMPANY_ID
													, @DIVISION_ID   -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
													, @SITE_ID
													, @FLOW_ID
													, @PATH_LEVEL
													, @OPERATION_GROUP_ID
					SET @HOLD_COMPANY_ID  = @COMPANY_ID
					SET @HOLD_DIVISION_ID = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
					SET @HOLD_SITE_ID     = @SITE_ID

					PRINT concat('8','::',@COMPANY_ID,'::',@DIVISION_ID,'::',@SITE_ID,'::',@FLOW_ID,'::',@PATH_LEVEL,'::',@OPERATION_GROUP_ID)

					WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
					BEGIN
						IF @HOLD_COMPANY_ID  != @COMPANY_ID
						OR @HOLD_DIVISION_ID != @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
						OR @HOLD_SITE_ID     != @SITE_ID
							BEGIN
								PRINT concat('8-1','::')
								SET @MIN_LEVEL = -1
								SET @HOLD_COMPANY_ID  = @COMPANY_ID
								SET @HOLD_DIVISION_ID = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
								SET @HOLD_SITE_ID     = @SITE_ID
							END;

						/*IF @BAS_KEY_ATTR2 = 'E' -- 전극의 경우만 @BAS_KEY_ATTR3 (PRDT_CLSS_CODE) 제품 분류 코드가 의미각 있음
												-- 전극 Part No 5번째 6번째 자리가 @BAS_KEY_ATTR3 (PRDT_CLSS_CODE) 제품 분류 코드에 대응되는 자리임.
							BEGIN
								SET @v_temp1 = 'STEP UPDATE SCM_MMD_ITEM_ROUTE_TEMP AT E'
								UPDATE [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
								SET    [FLOW_ID]   = @FLOW_ID
								WHERE  [MODEL_ID]                 = @BAS_KEY_ATTR1  -- MODLID 제품모델아이디
								AND    [OPERATION_GROUP_ID]       = @BAS_KEY_ATTR2  -- PCSGID 공정세그먼트아이디 operation group
								AND    [ITEM_CLASS_LEVEL3_PREFIX] = @BAS_KEY_ATTR3  -- PRDT_CLSS_CODE 제품 분류 코드
								AND    [MMD_ROUTID]               = @BAS_KEY_ATTR4  -- ROUTID 경로아이디
								AND    [COMPANY_ID]               = @COMPANY_ID
								-- AND    [DIVISION_ID]              = @DIVISION_ID  blocked by kimcd 2016-11-03
								AND    [SITE_ID]                  = @SITE_ID
								AND    [CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
								AND    [CHILD_ITEM_ID]         LIKE '___' + @BAS_KEY_ATTR3 + '%'  -- -- PRDT_CLSS_CODE 제품 분류 코드
								AND    ISNULL([PHANTOM], 'N')    != 'Y'                 
								AND    [NLEVEL] = ( SELECT MIN(S.NLEVEL)
													FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] S  WITH(NOLOCK)
													WHERE  S.[MODEL_ID]                 = @BAS_KEY_ATTR1  -- MODLID 제품모델아이디
													AND    S.[OPERATION_GROUP_ID]       = @BAS_KEY_ATTR2  -- PCSGID 공정세그먼트아이디 operation group
													AND    S.[ITEM_CLASS_LEVEL3_PREFIX] = @BAS_KEY_ATTR3  -- PRDT_CLSS_CODE 제품 분류 코드
													AND    S.[MMD_ROUTID]               = @BAS_KEY_ATTR4  -- ROUTID 경로아이디
													AND    S.[COMPANY_ID]               = @COMPANY_ID
													-- AND    S.[DIVISION_ID]              = @DIVISION_ID  blocked by kimcd 2016-11-03
													AND    S.[SITE_ID]                  = @SITE_ID
													AND    S.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
													AND    S.[CHILD_ITEM_ID]         LIKE '___' + @BAS_KEY_ATTR3 + '%'  -- -- PRDT_CLSS_CODE 제품 분류 코드
													AND    ISNULL(S.[PHANTOM], 'N')    != 'Y'
													AND    S.[NLEVEL]                   > @MIN_LEVEL )
								AND    NOT EXISTS ( SELECT 1
													FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] C  WITH(NOLOCK)
													WHERE  C.[MODEL_ID]                 = @BAS_KEY_ATTR1  -- MODLID 제품모델아이디
													AND    C.[OPERATION_GROUP_ID]       = @BAS_KEY_ATTR2  -- PCSGID 공정세그먼트아이디 operation group
													AND    C.[ITEM_CLASS_LEVEL3_PREFIX] = @BAS_KEY_ATTR3  -- PRDT_CLSS_CODE 제품 분류 코드
													AND    C.[MMD_ROUTID]               = @BAS_KEY_ATTR4  -- ROUTID 경로아이디
													AND    C.[COMPANY_ID]               = @COMPANY_ID
													-- AND    C.[DIVISION_ID]              = @DIVISION_ID  blocked by kimcd 2016-11-03
													AND    C.[SITE_ID]                  = @SITE_ID
													AND    C.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
													AND    C.[CHILD_ITEM_ID]            = [DBO].[SCM_MMD_ITEM_ROUTE_TEMP].[CHILD_ITEM_ID]
													AND    ISNULL(C.[PHANTOM], 'N')    != 'Y'
													AND    C.[NLEVEL]                  <= @MIN_LEVEL );

								SET @v_temp1 = 'STEP GET MAX LEVEL AT E'
								SELECT @MIN_LEVEL = MAX(S.NLEVEL)
								FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] S  WITH(NOLOCK)
								WHERE  S.[MODEL_ID]                 = @BAS_KEY_ATTR1  -- MODLID 제품모델아이디
								AND    S.[OPERATION_GROUP_ID]       = @BAS_KEY_ATTR2  -- PCSGID 공정세그먼트아이디 operation group
								AND    S.[ITEM_CLASS_LEVEL3_PREFIX] = @BAS_KEY_ATTR3  -- PRDT_CLSS_CODE 제품 분류 코드
								AND    S.[MMD_ROUTID]               = @BAS_KEY_ATTR4  -- ROUTID 경로아이디
								AND    S.[COMPANY_ID]               = @COMPANY_ID
								-- AND    S.[DIVISION_ID]              = @DIVISION_ID  blocked by kimcd 2016-11-03
								AND    S.[SITE_ID]                  = @SITE_ID
								AND    S.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
								AND    S.[CHILD_ITEM_ID]         LIKE '___' + @BAS_KEY_ATTR3 + '%'  -- -- PRDT_CLSS_CODE 제품 분류 코드
								AND    S.[FLOW_ID]               IS NOT NULL;

							END
						ELSE*/
							BEGIN
								PRINT concat('8-2','::')
								SET @v_temp1 = 'STEP UPDATE SCM_MMD_ITEM_ROUTE_TEMP AT ELSE'
								UPDATE [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
								SET    [FLOW_ID]   = @FLOW_ID
								WHERE  [MMD_PLANT_ID]             = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
								AND    [MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
								AND    [MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
								AND    [COMPANY_ID]               = @COMPANY_ID
								AND    [DIVISION_ID]              = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
								AND    [SITE_ID]                  = @SITE_ID
								AND    [CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
								AND    ISNULL([PHANTOM], 'N')    != 'Y'                 
								AND    [NLEVEL] = ( SELECT MIN(S.NLEVEL)
													FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] S  WITH(NOLOCK)
													WHERE  S.[MMD_PLANT_ID]             = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
													AND    S.[MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
													AND    S.[MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
													AND    S.[COMPANY_ID]               = @COMPANY_ID
													AND    S.[DIVISION_ID]              = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
													AND    S.[SITE_ID]                  = @SITE_ID
													AND    S.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
													AND    ISNULL(S.[PHANTOM], 'N')    != 'Y'
													AND    S.[NLEVEL]                   > @MIN_LEVEL )
								AND    NOT EXISTS ( SELECT 1
													FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] C  WITH(NOLOCK)
													WHERE  C.[MMD_PLANT_ID]             = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
													AND    C.[MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
													AND    C.[MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
													AND    C.[COMPANY_ID]               = @COMPANY_ID
													AND    C.[DIVISION_ID]              = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
													AND    C.[SITE_ID]                  = @SITE_ID
													AND    C.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
													AND    C.[CHILD_ITEM_ID]            = [DBO].[SCM_MMD_ITEM_ROUTE_TEMP].[CHILD_ITEM_ID]
													AND    ISNULL(C.[PHANTOM], 'N')    != 'Y'
													AND    C.[NLEVEL]                  <= @MIN_LEVEL );


								PRINT concat('8-3','::')
								SET @v_temp1 = 'STEP GET MAX LEVEL AT ELSE'
								SELECT @MIN_LEVEL = ISNULL(MAX(S.NLEVEL),-1)
								FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP] S  WITH(NOLOCK)
								WHERE  S.[MMD_PLANT_ID]             = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영
								AND    S.[MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
								AND    S.[MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
								AND    S.[COMPANY_ID]               = @COMPANY_ID
								AND    S.[DIVISION_ID]              = @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
								AND    S.[SITE_ID]                  = @SITE_ID
								AND    S.[CHILD_OP_GR_ID]           = @OPERATION_GROUP_ID
								AND    S.[FLOW_ID]               IS NOT NULL;
							END

						FETCH NEXT FROM C_MMD_ROUTE INTO  @COMPANY_ID
														, @DIVISION_ID  -- 2017-11-17 kimcd 다시 division별로 정보 형성함. 남경 소형 조립은 A6000제거. blocked by kimcd 2016-11-03
														, @SITE_ID
														, @FLOW_ID
														, @PATH_LEVEL
														, @OPERATION_GROUP_ID

					END; -- C_MMD_ROUTE
					CLOSE C_MMD_ROUTE;
					DEALLOCATE C_MMD_ROUTE;   -- 메모리 해제


					PRINT concat('8-4','::')

					SET @PROCESS_FLAG = 'N'
	                -- OPERATION FLOW 입력용 ROUTE CURSOR
					DECLARE C_ITEM_FLOW CURSOR FOR
						SELECT COMPANY_ID
							 , DIVISION_ID
							 , SITE_ID
							 , CHILD_ITEM_ID
							 , FLOW_ID
						FROM   [DBO].[SCM_MMD_ITEM_ROUTE_TEMP]  WITH(NOLOCK)
						WHERE  [MMD_PLANT_ID]             = @NERP_PLANT_ID   -- [SHOPID] 플랜트아이디   -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						AND    [MODEL_ID]                 = @BAS_KEY_ATTR2   -- [PRODID] 제품아이디
						AND    [MMD_ROUTID]               = @BAS_KEY_ATTR3   -- [ROUTID] 경로아이디
						AND    [FLOW_ID] IS NOT NULL;
							
						PRINT concat('9','::')
						SET @v_temp1 = 'STEP OPEN CURSOR ITEM FLOW'
    					OPEN C_ITEM_FLOW
						FETCH NEXT FROM C_ITEM_FLOW INTO @COMPANY_ID
														,@DIVISION_ID
														,@SITE_ID
														,@CHILD_ITEM_ID
														,@FLOW_ID
						WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN

							PRINT concat('9-1','::',@COMPANY_ID,'::',@DIVISION_ID,'::',@SITE_ID,'::',@CHILD_ITEM_ID,'::',@FLOW_ID)

							SET @PROCESS_FLAG = 'Y'

							SET @v_temp1 = 'STEP UPDATE ITEM FLOW'
							UPDATE A
							SET    A.FLOW_ID     = CASE WHEN @FLOW_ID LIKE 'A5000%' THEN
													   (SELECT 'A5000'+ISNULL(MAX(SOM.OPERATION_ID),'')
													    FROM   SCM_OPERATION_M SOM WITH(NOLOCK)
														WHERE  SOM.COMPANY_ID   = @COMPANY_ID
														AND    SOM.DIVISION_ID  = @DIVISION_ID
														AND    SOM.SITE_ID      = @SITE_ID
														AND    SOM.OPERATION_ID = 'A6000'
														AND    SOM.ACTIVE_FLAG  = 'Y')
							                       ELSE 
												       @FLOW_ID
												   END -- 2019-08-01 kimcd A6000 공정이 Option형태로 바뀜에 따라 수정
								 , A.FORMATION_FLOW_ID =CASE WHEN A.FORMATION_FLOW_ID LIKE '%F5600' THEN
															A.FORMATION_FLOW_ID -- 2018-10-02 kimcd 수작업 특성 품목의 경우 FORMATION_FLOW_ID 값 유지
														ELSE
								 							(   SELECT CASE WHEN (SELECT TOP 1 'Y'
																				  FROM   SCM_BOM_M B WITH(NOLOCK)
																						,SCM_ITEM_M P WITH(NOLOCK)
																				  WHERE  B.COMPANY_ID     = P.COMPANY_ID
																				  AND    B.DIVISION_ID    = P.DIVISION_ID
																				  AND    B.SITE_ID        = P.SITE_ID
																				  AND    B.PARENT_ITEM_ID = P.ITEM_ID
																				  AND    P.FLOW_ID        = 'F7000' -- DSF
																				  AND    B.COMPANY_ID     = A.COMPANY_ID
																				  AND    B.DIVISION_ID    = A.DIVISION_ID
																				  AND    B.SITE_ID        = A.SITE_ID
																				  AND    B.CHILD_ITEM_ID  = A.ITEM_ID
																				  AND    B.EFF_END_DATE  >= GETDATE() ) = 'Y' THEN  SUBSTRING(SLV.ATTRIBUTE1, 1,5)
																	   ELSE CASE WHEN SLV.ATTRIBUTE4 = A.ITEM_CLASS THEN SLV.ATTRIBUTE5 ELSE SLV.ATTRIBUTE1 END END -- 2018-10-02 kimcd DSF 품목의 하위 품목은 특성만 OPERATION FLOW 형성
																	   -- 2020-01-21 kimcd 초소형 특성 공정 반영 위해 CASE WHEN SLV.ATTRIBUTE4 = A.ITEM_CLASS THEN SLV.ATTRIBUTE5 ELSE SLV.ATTRIBUTE1 END 문장으로 수정
																	   --                  SCM,SSP 전송용 View에서 'FORMATION_MMD_ROUTE_CONVERT' lookup 사용하여 SEGMENT5에 ITEM CLASS 넣지 못 하고 ATTRIBUTE4,5 사용
																	   --                  특이 사항 추가되면 LOOKUP 분리 필요
																FROM   SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
																WHERE  SLV.LOOKUP_TYPE_CODE = 'FORMATION_MMD_ROUTE_CONVERT'
																AND    SLV.SEGMENT1  = SITE_ID
																AND    SLV.SEGMENT2  = DIVISION_ID
																AND    SLV.SEGMENT3  = @FLOW_ID
																AND    SLV.SEGMENT4  = A.COMPANY_ID -- 2019-08-29 kimcd COMPANY_ID 조건 추가
																AND    SLV.ACTIVE_FLAG = 'Y' )  -- 2018-07-11 kimcd SITE, 공정 기반 LOOKUP으로 전환
														END
								 , UPDATE_ID   = 'PR_XIF_RENEW_ROUTE_R'
								 , UPDATE_TIME = GETDATE()
							FROM   [DBO].[SCM_ITEM_M] A
							WHERE  [COMPANY_ID]  = @COMPANY_ID
							AND    [DIVISION_ID] = @DIVISION_ID
							AND    [SITE_ID]     = @SITE_ID
							AND    [ITEM_ID]     = @CHILD_ITEM_ID

    						SET @v_count = @v_count + 1;

							FETCH NEXT FROM C_ITEM_FLOW INTO @COMPANY_ID
															,@DIVISION_ID
															,@SITE_ID
															,@CHILD_ITEM_ID
															,@FLOW_ID

						END -- WHILE @@FETCH_STATUS = 0  C_ITEM_FLOW
						CLOSE C_ITEM_FLOW;
						DEALLOCATE C_ITEM_FLOW;   -- 메모리 해제

						PRINT concat('10','::')

						IF @PROCESS_FLAG = 'Y'
							BEGIN

								PRINT concat('10-1','::')

								UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
								SET [PROC_FLAG] = 'Y'
								   ,[UPDDTTM]   = GETDATE()
								WHERE [PROC_FLAG] = 'P'
								AND   [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
								AND   [IF_SEQ]    = @IF_SEQ;

								-- 2018-06-08 kimcd 2D Taping Route 형성용 Update 시작
								IF @BAS_KEY_ATTR3 IN ( 'ART006','ART008', 'ART011', 'ART016') -- 2020-4-13 kimcd Taping 전환 대상 로직에 ART008 추가
									BEGIN

										PRINT concat('10-2','::')

										UPDATE IMU
										SET    IMU.FLOW_ID     = 'F7200'
											,  IMU.UPDATE_ID   = @v_proc_name
											,  IMU.UPDATE_TIME = GETDATE()
										FROM  [DBO].[SCM_ITEM_M] IMU  WITH(NOLOCK)
											, [DBO].[SCM_BOM_M]  BOM  WITH(NOLOCK)
										WHERE BOM.CHILD_ITEM_ID  = @BAS_KEY_ATTR2
										AND   BOM.PARENT_ITEM_ID = IMU.ITEM_ID
										AND   BOM.COMPANY_ID     = IMU.COMPANY_ID
										AND   BOM.DIVISION_ID    = IMU.DIVISION_ID
										AND   BOM.SITE_ID        = IMU.SITE_ID
										AND   BOM.EFF_END_DATE  >= GETDATE()
										AND   IMU.FLOW_ID        = 'F7300'
									END;
								-- 2018-06-08 kimcd 2D Taping Route 형성용 Update 끝
							END;
						ELSE
							PRINT concat('10-3','::',@IF_SEQ)
							UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
							SET [PROC_FLAG] = 'N'
								,[UPDDTTM]   = GETDATE()
							WHERE [PROC_FLAG] = 'P'
							AND   [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
							AND   [IF_SEQ]    = @IF_SEQ;
				END;
			ELSE IF @USE_FLAG = 'N'
					OR ( @SKIP_ROUTE_FLAG = 'Y' AND ISNULL(@FORM_ROUTE,'N')  != 'Y' )-- kimcd 2017-09-02 -- 활성화 후 공정 Tab Cell의 Route 제한을 위해 "AND @SKIP_ROUTE_FLAG = 'N'" 조건 추가
				BEGIN
					PRINT concat('10-4','::',@IF_SEQ)
					UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
					SET [PROC_FLAG] = 'Y'
						,[UPDDTTM]   = GETDATE()
					WHERE [PROC_FLAG] = 'P'
					AND   [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
					AND   [IF_SEQ]    = @IF_SEQ;

				END;
			ELSE -- PROCESS가 아닌 경우 N 상태로 복원 작업 수행
			    BEGIN
					PRINT concat('10-5','::',@IF_SEQ)
					UPDATE [dbo].[SY_XIF_MMD_BAS_ITEM_DATA_R]
					SET [PROC_FLAG] = 'N'
						,[UPDDTTM]   = GETDATE()
					WHERE [PROC_FLAG] = 'P'
					AND   [BAS_ITEM_ID] = 'TB_MMD_SHOP_PRDT_ROUT'
					AND   [IF_SEQ]    = @IF_SEQ;
				END;


			PRINT concat('11','::',@NERP_PLANT_ID,'::',@BAS_KEY_ATTR2,'::',@BAS_KEY_ATTR3,'::',@BAS_ATTR1)
			SET @v_temp1 = 'STEP MERGE [SCM_MMD_MODEL_ROUTE_M]'
			MERGE INTO [DBO].[SCM_MMD_MODEL_ROUTE_M] MR
			USING ( SELECT @NERP_PLANT_ID          AS MMD_PLANT_ID  -- [SHOPID] 플랜트아이디 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						 , @BAS_KEY_ATTR2          AS MODEL_ID      -- [PRODID] 제품아이디
						 , @BAS_KEY_ATTR3          AS MMD_ROUTID    -- [ROUTID] 경로아이디
					     , ISNULL(@BAS_ATTR1,'-')  AS MMD_LINE_ID   -- [EQSGID] 설비세그먼트아이디
						 , @R_OPERATION_GROUP_ID   AS OPERATION_GROUP_ID
						 , @USE_FLAG	           AS ACTIVE_FLAG ) XXX
			ON    (     MR.[MMD_PLANT_ID] = XXX.[MMD_PLANT_ID]
					AND MR.[MODEL_ID]     = XXX.[MODEL_ID]
					AND MR.[MMD_ROUTID]   = XXX.[MMD_ROUTID]
					)
			WHEN MATCHED THEN
				UPDATE SET MR.[MMD_LINE_ID] = XXX.[MMD_LINE_ID]
						 , MR.[OPERATION_GROUP_ID] = XXX.[OPERATION_GROUP_ID]
						 , MR.[ACTIVE_FLAG] = XXX.[ACTIVE_FLAG]
						 , MR.[UPDATE_ID]   = @v_proc_name
						 , MR.[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT ( [MMD_PLANT_ID]
						,[MODEL_ID]
						,[MMD_ROUTID]
						,[MMD_LINE_ID]
						,[OPERATION_GROUP_ID]
						,[ACTIVE_FLAG]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME]
					    )
				VALUES ( XXX.[MMD_PLANT_ID]
					   , XXX.[MODEL_ID]
					   , XXX.[MMD_ROUTID]
					   , XXX.[MMD_LINE_ID]
					   , XXX.[OPERATION_GROUP_ID]
					   , XXX.[ACTIVE_FLAG]
					   , @v_proc_name
					   , GETDATE()
					   , @v_proc_name
					   , GETDATE()
					   );
    		SET @v_count = @v_count + 1;


			SET @v_temp1 = 'STEP FETCH AGAIN C_ITEM_OP_DATA'
			FETCH NEXT FROM C_ITEM_OP_DATA INTO @IF_SEQ
											  , @BAS_ITEM_ID
											  , @DISTRB_TG_BAS_ITEM_NAME
											  , @SRC_REPSTR_ID
											  , @SRC_BAS_ITEM_ID
											  , @SRC_KEY_SEQ_NO
											  , @SRC_HIST_SEQ_NO
											  , @BAS_KEY_ATTR1  -- [SHOPID] 플랜트아이디
											  , @BAS_KEY_ATTR2  -- [PRODID] 제품아이디
											  , @BAS_KEY_ATTR3  -- [ROUTID] 경로아이디
											  , @BAS_ATTR1      -- [EQSGID] 설비세그먼트아이디
											  , @BAS_ATTR_MSG
											  , @USE_FLAG
											  , @DEL_FLAG
											  , @FORM_ROUTE -- kimcd 2017-09-02 add

		END -- WHILE @@FETCH_STATUS = 0  C_ITEM_OP_DATA
		CLOSE C_ITEM_OP_DATA;
		DEALLOCATE C_ITEM_OP_DATA;   -- 메모리 해제
        -- COMMIT TRANSACTION; 2020-01-02 kimcd Transaction commit, rollback 제거

		PRINT concat('12','::')
        SET @v_temp1 = 'STEP END PROCEDURE'
        EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   @v_count, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		PRINT concat('13','::')

    END TRY

	BEGIN CATCH

	   -- ROLLBACK TRANSACTION; 2020-01-02 kimcd Transaction commit, rollback 제거
		-- 에러나도 로그는 인서트
		PRINT concat('e90','::')
		SET @site_s = CURSOR_STATUS('global','C_ITEM_OP_DATA')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_ITEM_OP_DATA;
                             DEALLOCATE C_ITEM_OP_DATA;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_MMD_ROUTE')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_MMD_ROUTE;
                             DEALLOCATE C_MMD_ROUTE;   -- 메모리 해제
			             END

		SET @site_s = CURSOR_STATUS('local','C_ITEM_FLOW')
		IF @site_s IN (1,0)
						 BEGIN
		                     CLOSE C_ITEM_FLOW;
                             DEALLOCATE C_ITEM_FLOW;   -- 메모리 해제
			             END

		SET @v_descr = ERROR_MESSAGE()

		PRINT concat('e91','::',@v_proc_name,'::',@v_temp2,'::',@v_temp1,'::',@v_descr,'::',@sysdate)

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, @v_temp1, @v_descr, @sysdate

		PRINT concat('e91','::')

	END CATCH

END

