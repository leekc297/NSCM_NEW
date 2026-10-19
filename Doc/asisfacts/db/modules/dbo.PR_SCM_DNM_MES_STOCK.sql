/*
 * Program ID   : PR_SCM_DNM_MES_STOCK
 * Description  : MES 출하대기 LOT 재고 정보 I/F 수신 반영
 * OutTable     : XIF_MES_WIP_LOT_R_SN / XIF_MES_WIP_BOXLOT_R_SN : 40/81/82
 *               --> SCM_DNM_MES_STOCK
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.07.12   KSG            Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 * 2022.07.25   KSG            수신테이블 변경에 따른 로직 전체 재수립
 * 2023.05.23   HRK			   PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

CREATE  PROCEDURE [dbo].[PR_SCM_DNM_MES_STOCK]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_NULLS ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_DNM_MES_STOCK';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_DNM_MES_STOCK'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + @v_table_id + ':' + N' INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

    BEGIN TRY
    BEGIN

				-- 인터페이스 테이블 처리 ROW UPDATE
				UPDATE A 
				SET    A.attr_10             = 'P'
				FROM   XIF_MES_WIP_LOT_R_SN  A WITH(NOLOCK)
				WHERE  ISNULL(A.attr_10,'N') = 'N'
				;  	

				IF OBJECT_ID('tempdb..#XIF_MES_WIP_LOT_R_SN') IS NOT NULL
					DROP TABLE #XIF_MES_WIP_LOT_R_SN;

				IF OBJECT_ID('tempdb..#XIF_MES_WIP_BOXLOT_R_SN') IS NOT NULL
					DROP TABLE #XIF_MES_WIP_BOXLOT_R_SN;	

				SELECT X.*
				  INTO #XIF_MES_WIP_LOT_R_SN
				  FROM dbo.XIF_MES_WIP_LOT_R_SN AS X WITH(NOLOCK) 
                       JOIN SCM_MST_FACTORY_SN AS A WITH(NOLOCK)
			        ON A.PLANT_ID   = X.SHOPID
		           AND A.FACTORY_ID = X.AREAID	
				 WHERE 1 = 1
				   AND X.attr_10		= 'P' 
				   AND X.DB_TYPE		IN ('CELL', 'FORM', 'PACK')
				   AND X.PRODID			NOT LIKE 'APC%'
				   AND A.SHOP_GROUP_ID IN ('A', 'P')
				 ORDER BY X.IF_SEQ
					   

				SELECT Y.*
				  INTO #XIF_MES_WIP_BOXLOT_R_SN
				  FROM dbo.XIF_MES_WIP_BOXLOT_R_SN AS Y WITH(NOLOCK)
				       INNER JOIN #XIF_MES_WIP_LOT_R_SN AS X
					ON Y.MASTER_IF_SEQ = X.IF_SEQ;


				------------------------------------------------------------------------------------------------------------- 
				-- 0. temp 테이블 생성 : 
				------------------------------------------------------------------------------------------------------------- 
				IF OBJECT_ID('tempdb..#tmp_SCM_DNM_MES_STOCK') IS NOT NULL
					DROP TABLE #tmp_SCM_DNM_MES_STOCK;

				CREATE TABLE #tmp_SCM_DNM_MES_STOCK (
							 DIVISION_ID        NVARCHAR(020)
							,COMPANY_ID         NVARCHAR(020)
							,FROM_SITE          NVARCHAR(020)
							,SUM_DATE           NVARCHAR(008)                                                                 
							,PLANT_ID           NVARCHAR(030)    
							,FACTORY_ID         NVARCHAR(030)                                  
							,OPERATION_ID       NVARCHAR(030)   
							,AREID              NVARCHAR(050)   
							,PRODID             NVARCHAR(050)   
							,PRJT_NAME          NVARCHAR(050)   -- NICK_NAME						 
							,LOTID              NVARCHAR(200)   
							,LOTTYPE            NVARCHAR(050)   
							,LOTQTY             NUMERIC(20,10)
							,HOLD_YN            NVARCHAR(001) 
							,MES_HOLD_YN        NVARCHAR(001) 
							,QMS_HOLD_YN        NVARCHAR(001) 
							,LONGTERM_HOLD_YN	NVARCHAR(001) 	-- [C20200303-000163] 신규추가
							,JUDG_VLD_DATE      NVARCHAR(008)
							,HOLD_DATE          NVARCHAR(008)
							,MES_HOLD_RELEASE   NVARCHAR(008)
							,QMS_HOLD_RELEASE   NVARCHAR(008)
							,ATTRIBUTE2         NVARCHAR(100)
					);

				-------------------------------------------------------------------------------------------------------------
				-- 1. temp 테이블 정보 생성
				-------------------------------------------------------------------------------------------------------------
				WITH MES AS (
				-- 1. 40 원각형
					SELECT 
						   C.DIVISION_ID				AS DIVISION_ID      --   
						  ,C.COMPANY_ID					AS COMPANY_ID       --
						  ,C.SCM_SITE_ID				AS FROM_SITE        --    
						  ,X.SUM_DATE					AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.PROD_HOLD_FLAG) = 'Y' OR MAX(X.QLTY_HOLD_FLAG) = 'Y' THEN 'Y'
						        ELSE 'N' END            AS HOLD_YN
						  ,X.SHOPID    				    AS PLANT_ID       
						  ,X.AREAID                     AS FACTORY_ID
						  ,X.PROCID                     AS OPERATION_ID
						  ,X.BOXID   					AS BOXID
						  ,X.PRODID						AS ITEM_ID          --
						  ,MAX(X.PRJT_NAME)				AS NICK_NAME           
						  ,X.LOTID_RT					AS LOT_ID           --
						  ,MAX(ISNULL(F.ATTRIBUTE1, X.LOTTYPE))               
						                                AS LOT_TYPE
						  ,SUM(X.WIPQTY2)			    AS LOT_QTY    
						  ,MAX(X.PROD_HOLD_FLAG)		AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)		AS QMS_HOLD_YN  
						  ,MAX(X.LONG_TERM_STCK_FLAG)   AS LONGTERM_HOLD_YN
						  ,MIN(X.VLD_DATE)				AS JUDG_VLD_DATE     
						  ,MAX(X.PROD_HOLD_DATE)		AS HOLD_DATE       
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE) AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE) AS QMS_HOLD_RELEASE
						  ,SUM(CASE WHEN X.CURR_WIP_QLTY_TYPE_CODE = 'N' THEN CONVERT(DECIMAL, X.WIPQTY) ELSE 0 END) AS DFCT_QTY
						  ,@v_batch_user				AS CREATED_BY          
						  ,getdate()					AS CREATION_DATE       
						  ,@v_batch_user				AS LAST_UPDATED_BY     
						  ,getdate()					AS LAST_UPDATE_DATE  
					  FROM #XIF_MES_WIP_LOT_R_SN X WITH(NOLOCK)
				           INNER JOIN SCM_MST_FACTORY_SN	AS A WITH(NOLOCK)
				        ON A.PLANT_ID		= X.SHOPID
				       AND A.FACTORY_ID		= X.AREAID 
				           INNER JOIN SCP_MST_FINAL_ITEM	AS B WITH(NOLOCK)
				        ON B.DIVISION_ID	= A.DIVISION_ID
				       AND B.ITEM_ID		= X.PRODID
                           JOIN SCM_MST_SITE				AS C WITH(NOLOCK) 
						ON C.PLANT_ID				= A.PLANT_ID 
					   AND C.SITE_TYPE				= 'PLANT'
					   AND C.OPERATION_GROUP		= A.SHOP_GROUP_ID
					       INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS D WITH(NOLOCK) 
					    ON D.SEGMENT3		<> 'P'  -- 40 원각형
					   AND D.LOOKUP_TYPE	= 'CELL_TYPE_CODE' 
					   AND D.VALID_YN		= 'Y' 
					   AND D.SEGMENT1		= B.CELL_TYPE_GROUP_CODE  --C:Cylindrical, R:Prismatic
					       LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS F WITH(NOLOCK) 
					    ON F.LOOKUP_TYPE	= 'MES_LOTTYPE' 
					   AND F.VALID_YN		= 'Y' 
					   AND F.SEGMENT1		= X.LOTTYPE					 
					 WHERE 1 = 1 
					   AND C.DIVISION_ID = '40' -- 소형
					   AND X.SUM_COUNT <> '0'
					   AND X.PROCID NOT IN (SELECT SEGMENT1 
					                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
				                             WHERE LOOKUP_TYPE = 'MES_STOCK_EXCEPT_OPERATION' 
				                               AND VALID_YN    = 'Y'
										   )
					 GROUP BY
					       C.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,C.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.SHOPID
						  ,X.AREAID
						  ,X.PROCID
						  ,X.BOXID
						  ,X.PRODID
						  ,X.LOTID_RT

				-- 40 파우치형
				UNION ALL
				
					SELECT 
						   C.DIVISION_ID				AS DIVISION_ID      --   
						  ,C.COMPANY_ID					AS COMPANY_ID       --
						  ,C.SCM_SITE_ID				AS FROM_SITE        --    
						  ,X.SUM_DATE					AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.PROD_HOLD_FLAG) = 'Y' OR MAX(X.QLTY_HOLD_FLAG) = 'Y' THEN 'Y'
						        ELSE 'N' END            AS HOLD_YN
						  ,X.SHOPID    				    AS PLANT_ID       
						  ,X.AREAID                     AS FACTORY_ID
						  ,X.PROCID                     AS OPERATION_ID
						  ,X.BOXID   					AS BOXID
						  ,X.PRODID						AS ITEM_ID          --
						  ,MAX(X.PRJT_NAME)				AS NICK_NAME           
						  ,X.LOTID_RT					AS LOT_ID           --
						  ,MAX(ISNULL(F.ATTRIBUTE1, X.LOTTYPE))               
						                                AS LOT_TYPE
						  ,SUM(X.WIPQTY2)			    AS LOT_QTY    
						  ,MAX(X.PROD_HOLD_FLAG)		AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)		AS QMS_HOLD_YN  
						  ,MAX(X.LONG_TERM_STCK_FLAG)   AS LONGTERM_HOLD_YN
						  ,MIN(X.VLD_DATE)				AS JUDG_VLD_DATE     
						  ,MAX(X.PROD_HOLD_DATE)		AS HOLD_DATE       
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE) AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE) AS QMS_HOLD_RELEASE
						  ,SUM(CASE WHEN X.CURR_WIP_QLTY_TYPE_CODE = 'N' THEN CONVERT(DECIMAL, X.WIPQTY) ELSE 0 END) AS DFCT_QTY
						  ,@v_batch_user				AS CREATED_BY          
						  ,getdate()					AS CREATION_DATE       
						  ,@v_batch_user				AS LAST_UPDATED_BY     
						  ,getdate()					AS LAST_UPDATE_DATE  
					  FROM #XIF_MES_WIP_LOT_R_SN X WITH(NOLOCK) 
				           INNER JOIN SCM_MST_FACTORY_SN		AS A WITH(NOLOCK)
				        ON A.PLANT_ID		= X.SHOPID
				       AND A.FACTORY_ID		= X.AREAID 
				           INNER JOIN SCP_MST_FINAL_ITEM		AS B WITH(NOLOCK)
				        ON B.DIVISION_ID	= A.DIVISION_ID
				       AND B.ITEM_ID		= X.PRODID
                           JOIN SCM_MST_SITE					AS C WITH(NOLOCK) 
						ON C.PLANT_ID				= A.PLANT_ID 
					   AND C.SITE_TYPE				= 'PLANT'
					   AND C.OPERATION_GROUP		= A.SHOP_GROUP_ID
					       INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS D WITH(NOLOCK) 
					    ON D.SEGMENT3		= 'P' -- 40 파우치형
					   AND D.LOOKUP_TYPE	= 'CELL_TYPE_CODE' 
					   AND D.VALID_YN		= 'Y' 
					   AND D.SEGMENT1		= B.CELL_TYPE_GROUP_CODE   --P:Pouch
					       LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS F WITH(NOLOCK) 
					    ON F.LOOKUP_TYPE	= 'MES_LOTTYPE' 
					   AND F.VALID_YN		= 'Y' 
					   AND F.SEGMENT1		= X.LOTTYPE	
					 --      INNER JOIN @XIF_MES_WIP_BOXLOT_R AS Y WITH(NOLOCK) 
						--ON X.IF_SEQ = Y.MASTER_IF_SEQ
					 WHERE 1 = 1 
					   AND C.DIVISION_ID = '40' -- 소형
					   AND X.SUM_COUNT <> '0'
					   AND X.PROCID NOT IN (SELECT SEGMENT1 
					                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
				                             WHERE LOOKUP_TYPE = 'MES_STOCK_EXCEPT_OPERATION' 
				                               AND VALID_YN    = 'Y'
										   )
                       AND EXISTS ( -- 40 파우치형
								  SELECT 1
								    FROM SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK)
								   WHERE 1 = 1
								     AND B.LOOKUP_TYPE = 'MES_POUCH_OPERATION'
								     AND B.VALID_YN    = 'Y' 
								     AND B.SEGMENT1    =  ISNULL(D.SEGMENT3, '')
								     AND B.SEGMENT2    = X.PROCID 
							      )
					 GROUP BY
					       C.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,C.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.SHOPID
						  ,X.AREAID
						  ,X.PROCID
						  ,X.BOXID
						  ,X.PRODID
						  ,X.LOTID_RT

				-- 81/82 : OPERATION_GROUP        = 'A': 조립
				UNION ALL
					SELECT 
						   C.DIVISION_ID				AS DIVISION_ID      --   
						  ,C.COMPANY_ID					AS COMPANY_ID       --
						  ,C.SCM_SITE_ID				AS FROM_SITE        --    
						  ,X.SUM_DATE					AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.PROD_HOLD_FLAG) = 'Y' OR MAX(X.QLTY_HOLD_FLAG) = 'Y' THEN 'Y'
						        ELSE 'N' END            AS HOLD_YN
						  --,CASE WHEN MAX(X.OQC_JUDG_VALUE) = 'Y' AND MAX(X.PROD_HOLD_FLAG) = 'N' AND MAX(X.QLTY_HOLD_FLAG) = 'N' THEN 'N'
						  --      ELSE 'Y' END            AS HOLD_YN
						  ,X.SHOPID    				    AS PLANT_ID       
						  ,X.AREAID                     AS FACTORY_ID
						  ,X.PROCID                     AS OPERATION_ID
						  ,X.BOXID   					AS BOXID
						  ,X.PRODID						AS ITEM_ID          --
						  ,MAX(X.PRJT_NAME)				AS NICK_NAME              
						  ,X.LOTID   					AS LOT_ID           
						  --,SUBSTRING(Y.ASSY_LOTID,1,8)	AS LOT_ID           --
						  ,MAX(X.LOTTYPE)               AS LOT_TYPE
						  ,SUM(X.WIPQTY2)			    AS LOT_QTY    
						  --,SUM(Y.LOTQTY)			    AS LOT_QTY    
						  ,MAX(X.PROD_HOLD_FLAG)		AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)		AS QMS_HOLD_YN  
						  ,MAX(X.LONG_TERM_STCK_FLAG)   AS LONGTERM_HOLD_YN
						  ,MIN(X.VLD_DATE)				AS JUDG_VLD_DATE     
						  ,MAX(X.PROD_HOLD_DATE)		AS HOLD_DATE       
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE) AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE) AS QMS_HOLD_RELEASE
						  ,0                            AS DFCT_QTY
						  ,@v_batch_user				AS CREATED_BY          
						  ,getdate()					AS CREATION_DATE       
						  ,@v_batch_user				AS LAST_UPDATED_BY     
						  ,getdate()					AS LAST_UPDATE_DATE  
					  FROM #XIF_MES_WIP_LOT_R_SN AS X WITH(NOLOCK)
				           INNER JOIN SCM_MST_FACTORY_SN		AS A WITH(NOLOCK)
								   ON A.PLANT_ID		= X.SHOPID
								  AND A.FACTORY_ID		= X.AREAID 
				           INNER JOIN SCP_MST_FINAL_ITEM		AS B WITH(NOLOCK)
								   ON B.DIVISION_ID	= A.DIVISION_ID
								  AND B.ITEM_ID		= X.PRODID
                           JOIN SCM_MST_SITE					AS C WITH(NOLOCK) 
								   ON C.PLANT_ID				= A.PLANT_ID 
								  AND C.SITE_TYPE				= 'PLANT'
								  AND C.OPERATION_GROUP		= A.SHOP_GROUP_ID	
								  AND C.OPERATION_GROUP        = 'A'
				           INNER JOIN SCM_MST_DIVISION  AS D WITH(NOLOCK) -- 2023.05.23 HM JV 가상 사업부 추가 대응
								   ON D.DIVISION_ID = C.DIVISION_ID 
								  AND D.ATTRIBUTE3 IN ('81', '82')  -- 소형 외
					 --      INNER JOIN #XIF_MES_WIP_BOXLOT_R_SN AS Y WITH(NOLOCK) 
						--ON X.IF_SEQ = Y.MASTER_IF_SEQ
					 WHERE 1 = 1 
					   -- 2023.05.23 HM JV 가상 사업부 추가 대응 AND C.DIVISION_ID IN ('81', '82', '81_UC') -- 소형 외
					   AND X.SUM_COUNT <> '0'
					 GROUP BY
					       C.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,C.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.SHOPID      
						  ,X.AREAID
						  ,X.PROCID
						  ,X.BOXID
						  ,X.PRODID
						  ,X.LOTID
						  --,SUBSTRING(Y.ASSY_LOTID,1,8)

				-- 81/82 : OPERATION_GROUP        = 'P': Pack
				UNION ALL
					SELECT 
						   C.DIVISION_ID				AS DIVISION_ID      --   
						  ,C.COMPANY_ID					AS COMPANY_ID       --
						  ,C.SCM_SITE_ID				AS FROM_SITE        --    
						  ,X.SUM_DATE					AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.PROD_HOLD_FLAG) = 'Y' OR MAX(X.QLTY_HOLD_FLAG) = 'Y' THEN 'Y'
						        ELSE 'N' END            AS HOLD_YN
						  --,CASE WHEN MAX(X.OQC_JUDG_VALUE) = 'Y' AND MAX(X.PROD_HOLD_FLAG) = 'N' AND MAX(X.QLTY_HOLD_FLAG) = 'N' THEN 'N'
						  --      ELSE 'Y' END            AS HOLD_YN
						  ,X.SHOPID    				    AS PLANT_ID       
						  ,X.AREAID                     AS FACTORY_ID
						  ,X.PROCID                     AS OPERATION_ID
						  ,ISNULL(X.BOXID, X.LOTID)		AS BOXID
						  ,X.PRODID						AS ITEM_ID          --
						  ,MAX(X.PRJT_NAME)				AS NICK_NAME           
						  ,X.LOTID   					AS LOT_ID           --
						  ,MAX(X.LOTTYPE)               AS LOT_TYPE
						  ,MAX(X.WIPQTY2)			    AS LOT_QTY    
						  ,MAX(X.PROD_HOLD_FLAG)		AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)		AS QMS_HOLD_YN  
						  ,MAX(X.LONG_TERM_STCK_FLAG)   AS LONGTERM_HOLD_YN
						  ,MIN(X.VLD_DATE)				AS JUDG_VLD_DATE     
						  ,MAX(X.PROD_HOLD_DATE)		AS HOLD_DATE       
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE) AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE) AS QMS_HOLD_RELEASE
						  ,0                            AS DFCT_QTY
						  ,@v_batch_user				AS CREATED_BY          
						  ,getdate()					AS CREATION_DATE       
						  ,@v_batch_user				AS LAST_UPDATED_BY     
						  ,getdate()					AS LAST_UPDATE_DATE  

					  FROM #XIF_MES_WIP_LOT_R_SN AS X WITH(NOLOCK)
				           INNER JOIN SCM_MST_FACTORY_SN		AS A WITH(NOLOCK)
								   ON A.PLANT_ID		= X.SHOPID
								  AND A.FACTORY_ID		= X.AREAID 
				           INNER JOIN SCP_MST_FINAL_ITEM		AS B WITH(NOLOCK)
								   ON B.DIVISION_ID	= A.DIVISION_ID
								  AND B.ITEM_ID		= X.PRODID
                           JOIN SCM_MST_SITE					AS C WITH(NOLOCK) 
								   ON C.PLANT_ID				= A.PLANT_ID 
								  AND C.SITE_TYPE				= 'PLANT'
								  AND C.OPERATION_GROUP		= A.SHOP_GROUP_ID					       
								  AND C.OPERATION_GROUP        = 'P'
				           INNER JOIN SCM_MST_DIVISION  AS D WITH(NOLOCK) -- 2023.05.23 HM JV 가상 사업부 추가 대응
								   ON D.DIVISION_ID = C.DIVISION_ID 
								  AND D.ATTRIBUTE3 IN ('81', '82')  -- 소형 외
					 WHERE 1 = 1 
					   -- 2023.05.23 HM JV 가상 사업부 추가 대응 AND C.DIVISION_ID IN ('81', '82', '81_UC') -- 소형 외
					   AND X.SUM_COUNT <> '0'
					 GROUP BY
					       C.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,C.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.SHOPID      
						  ,X.AREAID
						  ,X.PROCID
						  ,X.BOXID
						  ,X.PRODID
						  ,X.LOTID
				)

				INSERT INTO #tmp_SCM_DNM_MES_STOCK ( 
							 DIVISION_ID
							,COMPANY_ID
							,FROM_SITE  
							,SUM_DATE                 
							,PLANT_ID              
							,FACTORY_ID
							,OPERATION_ID 
							,PRODID   
							,PRJT_NAME				 
							,LOTID    
							,LOTTYPE  
							,LOTQTY  
							,HOLD_YN
							,MES_HOLD_YN         
							,QMS_HOLD_YN
							,LONGTERM_HOLD_YN  -- [C20200303-000163] 신규추가
							,JUDG_VLD_DATE 
							,HOLD_DATE     
							,MES_HOLD_RELEASE   
							,QMS_HOLD_RELEASE   
							)
				SELECT XX.DIVISION_ID
				,      XX.COMPANY_ID
				,      XX.FROM_SITE 
				,      XX.YYYYMMDD
				,      XX.PLANT_ID  
				,      XX.FACTORY_ID
				,      XX.OPERATION_ID
				,      XX.ITEM_ID
				,      XX.NICK_NAME
				,      XX.LOT_ID
				,      XX.LOT_TYPE
				--,      SUM(ISNULL(XX.LOT_QTY, 0)) - SUM(ISNULL(DFCT_QTY,0)) AS LOTQTY 
				,      SUM(ISNULL(XX.LOT_QTY, 0))  AS LOTQTY 
				,      XX.HOLD_YN
				,      XX.MES_HOLD_YN
				,      XX.QMS_HOLD_YN
				,      XX.LONGTERM_HOLD_YN -- [C20200303-000163] 신규추가				
				,      XX.JUDG_VLD_DATE
				,      XX.HOLD_DATE
				,      XX.MES_HOLD_RELEASE 
				,      XX.QMS_HOLD_RELEASE 
				FROM   MES AS XX
				GROUP BY 
					   XX.DIVISION_ID
				,      XX.COMPANY_ID
				,      XX.FROM_SITE 
				,      XX.YYYYMMDD
				,      XX.PLANT_ID 
				,      XX.FACTORY_ID
				,      XX.OPERATION_ID
				,      XX.ITEM_ID
				,      XX.NICK_NAME
				,      XX.LOT_ID
				,      XX.LOT_TYPE
				,      XX.HOLD_YN
				,      XX.MES_HOLD_YN
				,      XX.QMS_HOLD_YN
				,      XX.LONGTERM_HOLD_YN
				,      XX.JUDG_VLD_DATE
				,      XX.HOLD_DATE
				,      XX.MES_HOLD_RELEASE 
				,      XX.QMS_HOLD_RELEASE  	
				;	

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = N'TXN';    -- ▶ 로그타입
                SET @v_log_message = N'INSERT INTO #tmp_SCM_DNM_MES_STOCK';
                SET @v_description = N'Temp Insert...' ;
                SET @d_event_date = SYSDATETIME();

                EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                          ,@p_log_type      =@v_log_type
                                          ,@p_log_count     =@n_log_count 
                                          ,@p_log_message   =@v_log_message 
                                          ,@p_description   =@v_description 
                                          ,@p_event_date    =@d_event_date 
                                          ,@p_user_id       =@v_batch_user
                                          ;   

			   ------------------------------------------------------------------------------------------------------------- 
			   -- SCM_DNM_MES_STOCK 생성 
			   -------------------------------------------------------------------------------------------------------------- 
				MERGE INTO SCM_DNM_MES_STOCK M
				USING
				(
					SELECT 		 
						 T.DIVISION_ID		AS DIVISION_ID 
						,T.COMPANY_ID		AS COMPANY_ID 
						,T.FROM_SITE        AS FROM_SITE 
						,T.SUM_DATE			AS YYYYMMDD						
					    ,MAX(T.HOLD_YN)     AS HOLD_YN  
						,T.PLANT_ID     	AS PLANT_ID 
						,ISNULL(T.FACTORY_ID, '-') AS FACTORY_ID 
						,T.OPERATION_ID     AS OPERATION_ID 
						,T.PRODID			AS ITEM_ID
						,MAX(T.PRJT_NAME)		AS NICK_NAME
						,T.LOTID			AS LOTID
						,MAX(T.LOTTYPE)			AS LOTTYPE
						,SUM(T.LOTQTY)			AS LOTQTY
						,MAX(T.MES_HOLD_YN)		AS MES_HOLD_YN
						,MAX(T.QMS_HOLD_YN)      AS QMS_HOLD_YN
						,MAX(T.LONGTERM_HOLD_YN) AS LONGTERM_HOLD_YN  --[C20200303-000163] 신규추가
						,MAX(T.JUDG_VLD_DATE)    AS JUDG_VLD_DATE
						,MAX(T.HOLD_DATE)        AS HOLD_DATE

				        ,CASE WHEN MAX(T.MES_HOLD_RELEASE) > MAX(T.QMS_HOLD_RELEASE) THEN MAX(T.MES_HOLD_RELEASE)
                              ELSE ISNULL(MAX(T.QMS_HOLD_RELEASE), MAX(T.MES_HOLD_RELEASE))
                         END AS HOLD_RELEASE 

						,MAX(T.MES_HOLD_RELEASE) AS MES_HOLD_RELEASE
						,MAX(T.QMS_HOLD_RELEASE) AS QMS_HOLD_RELEASE 
						,@v_batch_user      AS CREATED_BY                       
						,GETDATE()          AS CREATION_DATE                     
						,@v_batch_user      AS LAST_UPDATED_BY                   
						,GETDATE()          AS LAST_UPDATE_DATE                  
						,NULL               AS ATTRIBUTE1                       
						,NULL               AS ATTRIBUTE2                       
						,NULL				AS ATTRIBUTE3                       
						,NULL				AS ATTRIBUTE4                       
						,NULL				AS ATTRIBUTE5                       
						,NULL				AS ATTRIBUTE6                       
						,NULL				AS ATTRIBUTE7                       
						,NULL				AS ATTRIBUTE8                       
						,NULL				AS ATTRIBUTE9                       
						,NULL				AS ATTRIBUTE10        
					FROM #tmp_SCM_DNM_MES_STOCK T WITH(NOLOCK) 
					WHERE T.FROM_SITE IS NOT NULL 
					AND   T.OPERATION_ID IS NOT NULL 
					GROUP BY T.DIVISION_ID
					,T.COMPANY_ID	
					,T.FROM_SITE	      
					,T.SUM_DATE				
					,T.PLANT_ID			
					,ISNULL(T.FACTORY_ID, '-')
					,T.OPERATION_ID  
					,T.PRODID			
					,T.LOTID
				) N
				 ON	 M.DIVISION_ID  = N.DIVISION_ID
				AND  M.COMPANY_ID   = N.COMPANY_ID 
				AND  M.PLANT_ID     = N.PLANT_ID 
				AND  M.FACTORY_ID   = N.FACTORY_ID 
				AND  M.OPERATION_ID = N.OPERATION_ID 
				AND  M.FROM_SITE    = N.FROM_SITE  
				AND  M.YYYYMMDD     = N.YYYYMMDD   
				AND  M.ITEM_ID      = N.ITEM_ID    
				AND  M.LOT_ID       = N.LOTID      
				WHEN MATCHED THEN
				UPDATE
					SET M.NICK_NAME        = N.NICK_NAME        
					,	M.LOT_TYPE         = N.LOTTYPE          
					,	M.LOT_QTY          = N.LOTQTY             
					,	M.HOLD_YN          = N.HOLD_YN   
					,	M.MES_HOLD_YN      = N.MES_HOLD_YN      
					,	M.QMS_HOLD_YN      = N.QMS_HOLD_YN      
					,	M.LONGTERM_HOLD_YN = N.LONGTERM_HOLD_YN   --[C20200303-000163] 신규추가      
					,	M.JUDG_VLD_DATE    = N.JUDG_VLD_DATE   
					,   M.HOLD_DATE        = N.HOLD_DATE 
					,	M.HOLD_RELEASE     = N.HOLD_RELEASE 
					,	M.MES_HOLD_RELEASE = N.MES_HOLD_RELEASE 
					,	M.QMS_HOLD_RELEASE = N.QMS_HOLD_RELEASE 
					,	M.LAST_UPDATED_BY  = N.LAST_UPDATED_BY  
					,	M.LAST_UPDATE_DATE = N.LAST_UPDATE_DATE   
					,	M.ATTRIBUTE1       = N.ATTRIBUTE1        
					,	M.ATTRIBUTE2       = N.ATTRIBUTE2        
					,	M.ATTRIBUTE3       = N.ATTRIBUTE3        
					,	M.ATTRIBUTE4       = N.ATTRIBUTE4        
					,	M.ATTRIBUTE5       = N.ATTRIBUTE5        
					,	M.ATTRIBUTE6       = N.ATTRIBUTE6        
					,	M.ATTRIBUTE7       = N.ATTRIBUTE7        
					,	M.ATTRIBUTE8       = N.ATTRIBUTE8        
					,	M.ATTRIBUTE9       = N.ATTRIBUTE9        
					,	M.ATTRIBUTE10      = N.ATTRIBUTE10        

				WHEN NOT MATCHED THEN
				INSERT ( 	 DIVISION_ID
							,COMPANY_ID
							,FROM_SITE
							,YYYYMMDD
							,PLANT_ID
							,FACTORY_ID
							,OPERATION_ID
							,ITEM_ID
							,NICK_NAME
							,LOT_ID
							,LOT_TYPE
							,LOT_QTY
							,HOLD_YN
							,MES_HOLD_YN
							,QMS_HOLD_YN
							,LONGTERM_HOLD_YN   --[C20200303-000163] 신규추가      
							,JUDG_VLD_DATE
							,HOLD_DATE
							,HOLD_RELEASE
							,MES_HOLD_RELEASE
							,QMS_HOLD_RELEASE
							,CREATED_BY                       
							,CREATION_DATE                     
							,LAST_UPDATED_BY                   
							,LAST_UPDATE_DATE                  
							,ATTRIBUTE1                       
							,ATTRIBUTE2                       
							,ATTRIBUTE3                       
							,ATTRIBUTE4                       
							,ATTRIBUTE5                       
							,ATTRIBUTE6                       
							,ATTRIBUTE7                       
							,ATTRIBUTE8                       
							,ATTRIBUTE9                       
							,ATTRIBUTE10      
					   )
				 VALUES (
							 N.DIVISION_ID
							,N.COMPANY_ID
							,N.FROM_SITE
							,N.YYYYMMDD
							,N.PLANT_ID
							,N.FACTORY_ID
							,N.OPERATION_ID
							,N.ITEM_ID
							,N.NICK_NAME
							,N.LOTID
							,N.LOTTYPE
							,N.LOTQTY
							,N.HOLD_YN
							,N.MES_HOLD_YN
							,N.QMS_HOLD_YN
							,N.LONGTERM_HOLD_YN   --[C20200303-000163] 신규추가      
							,N.JUDG_VLD_DATE
							,N.HOLD_DATE
							,N.HOLD_RELEASE
							,N.MES_HOLD_RELEASE
							,N.QMS_HOLD_RELEASE
							,N.CREATED_BY                       
							,N.CREATION_DATE                     
							,N.LAST_UPDATED_BY                   
							,N.LAST_UPDATE_DATE                  
							,N.ATTRIBUTE1                       
							,N.ATTRIBUTE2                       
							,N.ATTRIBUTE3                       
							,N.ATTRIBUTE4                       
							,N.ATTRIBUTE5                       
							,N.ATTRIBUTE6                       
							,N.ATTRIBUTE7                       
							,N.ATTRIBUTE8                       
							,N.ATTRIBUTE9                       
							,N.ATTRIBUTE10  
				 );

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = N'TXN';    -- ▶ 로그타입
                SET @v_log_message = N'INSERT INTO SCM_DNM_MES_STOCK';
                SET @v_description = N'Insert...' ;
                SET @d_event_date = SYSDATETIME();

                EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                          ,@p_log_type      =@v_log_type
                                          ,@p_log_count     =@n_log_count 
                                          ,@p_log_message   =@v_log_message 
                                          ,@p_description   =@v_description 
                                          ,@p_event_date    =@d_event_date 
                                          ,@p_user_id       =@v_batch_user
                                          ;

				-- 인터페이스 테이블 처리 완료 UPDATE
				UPDATE A
				SET    A.attr_10 = 'Y'
				FROM   XIF_MES_WIP_LOT_R_SN  A WITH(NOLOCK)
				WHERE  A.attr_10 = 'P'
				;  

		-- IF data  삭제 (30일 이전 데이터 삭제) : SSP에서 처리됨
		-- data  삭제 (3개월  이전 데이터 삭제) 
		DELETE 
		FROM  SCM_DNM_MES_STOCK
		WHERE YYYYMMDD < CONVERT(VARCHAR, DATEADD(M, -3, GETDATE()) ,112)
					
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        --IF @@TRANCOUNT > 0
        --  BEGIN
        --    COMMIT TRAN TX_SH;
        --  END;       

		IF OBJECT_ID('tempdb..#tmp_SCM_DNM_MES_STOCK') IS NOT NULL
			DROP TABLE #tmp_SCM_DNM_MES_STOCK

		IF OBJECT_ID('tempdb..#XIF_MES_WIP_LOT_R_SN') IS NOT NULL
			DROP TABLE #XIF_MES_WIP_LOT_R_SN;

		IF OBJECT_ID('tempdb..#XIF_MES_WIP_BOXLOT_R_SN') IS NOT NULL
			DROP TABLE #XIF_MES_WIP_BOXLOT_R_SN;

        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ; 

    END
    END TRY

    BEGIN CATCH
      --IF @@TRANCOUNT > 0
      --  BEGIN
      --    ROLLBACK TRAN TX_SH
		  
      --  END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
--      PRINT @@ERROR
      return -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['+@v_program_name+'][' + @v_exec_time + ']';  
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
    return 1  

END;
