-- ================================================================================================                                                                                                                                                              
-- Program ID          :                                                                                                                                                                                                                                         
-- Program Name        : TMP_BOM_EXPLOSION                                                                                                                                                                                                                      
-- Param               :                                                                                                                                                                                                                                         
-- Batch Period        : realtime                                                                                                                                                                                                                                
-- Description         :                                                                                                                                                                                                                                         
--                                                                                                                                                                                                                                                               
-- Source                                                                                                                                                                                                                                                        
-- Destina                                                                                                                                                                                                                                                       
-- Source                                                                                                                                                                                                                                                        
-- Destina                                                                                                                                                                                                                                                       
--                                                                                                                                                                                                                                                               
-- Create(Update) Date : 2017.02.14                                                                                                                                                                                                                              
-- Author              :                                                                                                                                                                                                                                         
-- Version             : 1.1   Initial Creation                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                 
-- =============================================================================                                                                                                                                                                                 
CREATE PROCEDURE [dbo].[TMP_BOM_EXPLOSION]                                                                                                                                                                                                                       
AS                                                                                                                                                                                                                                                               
--------------------------------------------------------------------------------                                                                                                                                                                                 
BEGIN                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                                                                                                                                                                                                 
    SET NOCOUNT ON                                                                                                                                                                                                                                               
	SET XACT_ABORT ON                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                 
	-- LOG 용 변수 설정                                                                                                                                                                                                                                            
	DECLARE @v_proc_name NVARCHAR(100) = 'TMP_BOM_EXPLOSION'                                                                                                                                                                                                      
	DECLARE @v_descr     NVARCHAR(250)                                                                                                                                                                                                                             
	DECLARE @v_count     INTEGER	   = 0                                                                                                                                                                                                                           
	DECLARE @sysdate     DATETIME      = GETDATE()                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                 
	DECLARE @MAIL_CONTENTS_COUNT    NVARCHAR(4000)	                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                 
	-- ERROR_LINE                                                                                                                                                                                                                                                  
	DECLARE @v_temp1     NVARCHAR(1000)                                                                                                                                                                                                                            
	DECLARE @v_temp2     NVARCHAR(1000)                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                 
		DECLARE @MAIL_PKEY             NVARCHAR(100)                                                                                                                                                                                                                 
		DECLARE @MAIL_DESCRIPTION      NVARCHAR(500)                                                                                                                                                                                                                 
		DECLARE @MAIL_SUBJECT          NVARCHAR(500)                                                                                                                                                                                                                 
		DECLARE @MAIL_BODY             NVARCHAR(4000)                                                                                                                                                                                                                
		DECLARE @MAIL_CHECK_QUERY      NVARCHAR(4000)                                                                                                                                                                                                                
		DECLARE @MAIL_QUERY            NVARCHAR(4000)                                                                                                                                                                                                                
		DECLARE @ATTACH_FILE_NAME      NVARCHAR(4000)                                                                                                                                                                                                                
		DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)                                                                                                                                                                                                                
		DECLARE @MAIL_ERR_INTERVAL     NVARCHAR(500)	                                                                                                                                                                                                               
		DECLARE @MAIL_INTERVAL_PERIOD  NVARCHAR(500)                                                                                                                                                                                                                 
		DECLARE @MAIL_INTERVAL_TIME    NVARCHAR(500)                                                                                                                                                                                                                 
		DECLARE @MAIL_INTERVAL_DAYOFWK  NVARCHAR(500)                                                                                                                                                                                                                
		DECLARE @MAIL_QUERY2           NVARCHAR(4000)		                                                                                                                                                                                                             
		DECLARE @vTBL_COUNTS           INTEGER                                                                                                                                                                                                                       
		DECLARE @ROWCOUNT              INTEGER                                                                                                                                                                                                                       
		DECLARE @SQL                   NVARCHAR(4000)	                                                                                                                                                                                                               
		                                                      
		DECLARE @ITEM_ID             NVARCHAR(100)    
		
		                                                                                                                                                                                                                                                             
		DECLARE @vTBL_MAIL_CONTENTS TABLE                                                                                                                                                                                                                            
		(                                                                                                                                                                                                                                                            
       ROOT          NVARCHAR(300)
      ,RNUM          NVARCHAR(300)
      ,NICK_NAME     NVARCHAR(300)
      ,bLEVEL1_A     NVARCHAR(300)
      ,bLEVEL1       NVARCHAR(300)
      ,bLEVEL1_P     NVARCHAR(300)
      ,bLEVEL2_A     NVARCHAR(300)
      ,bLEVEL2       NVARCHAR(300)
      ,bLEVEL2_P     NVARCHAR(300)
      ,bLEVEL3_A     NVARCHAR(300)
      ,bLEVEL3       NVARCHAR(300)
      ,bLEVEL3_P     NVARCHAR(300)
      ,bLEVEL4_A     NVARCHAR(300)
      ,bLEVEL4       NVARCHAR(300)
      ,bLEVEL4_P     NVARCHAR(300)
      ,bLEVEL5_A     NVARCHAR(300)
      ,bLEVEL5       NVARCHAR(300)
      ,bLEVEL5_P     NVARCHAR(300)
      ,bLEVEL6_A     NVARCHAR(300)
      ,bLEVEL6       NVARCHAR(300)
      ,bLEVEL6_P     NVARCHAR(300)
      ,bLEVEL7_A     NVARCHAR(300)
      ,bLEVEL7       NVARCHAR(300)
      ,bLEVEL7_P     NVARCHAR(300)
      ,bLEVEL8_A     NVARCHAR(300)
      ,bLEVEL8       NVARCHAR(300)
      ,bLEVEL8_P     NVARCHAR(300)
      ,bLEVEL9_A     NVARCHAR(300)
      ,bLEVEL9       NVARCHAR(300)
      ,bLEVEL9_P     NVARCHAR(300)
      ,bLEVEL10_A    NVARCHAR(300)
      ,bLEVEL10      NVARCHAR(300)
      ,bLEVEL10_P    NVARCHAR(300)
      ,bLEVEL11_A    NVARCHAR(300)
      ,bLEVEL11      NVARCHAR(300)
      ,bLEVEL11_P    NVARCHAR(300)                                                                                                                                                                                                                         
		)                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                 
    --CURSOR 메일링대상정보                                                                                                                                                                                                                                      
    DECLARE CUR_MAIL CURSOR FOR                                                                                                                                                                                                                                  
     SELECT a.ITEM_ID
		  from dbo.scm_item_m a
		 where a.ITEM_TYPE = 'P'
		   and a.DIVISION_ID = '81'
		   and a.ITEM_CLASS_NAME like '%Cell%'
		   and a.ACTIVE_FLAG = 'Y'                                                                                                                                                                                                 
    ;                                                                                                                                                                                                                                                            
	   ----------------------------------------------------------------------------                                                                                                                                                                                
	                                                                                                                                                                                                                                                               
	-- ================================================                                                                                                                                                                                                            
    -- Declare end                                                                                                                                                                                                                                               
	-- ================================================                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                 
	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))                                                                                                                                            
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))                                                                                                                                            
                                                                                                                                                                                                                                                                 
	-- Start 로그는 무조건 남김                                                                                                                                                                                                                                    
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate                                                                                                                              
	                                                                                                                                                                                                                                                               
	   BEGIN TRY                                                                                                                                                                                                                                                   
		      BEGIN TRANSACTION;                                                                                                                                                                                                                                     
		      ------------------------------------------------------------------------                                                                                                                                                                               
		      OPEN CUR_MAIL;                                                                                                                                                                                                                                         
        FETCH NEXT FROM CUR_MAIL                                                                                                                                                                                                                                 
		            INTO  @ITEM_ID                                                                                                                                                                                                                   
        WHILE (@@FETCH_STATUS = 0)                                                                                                                                                                                                                               
        BEGIN                                                                                                                                                                                                                                                    
		                                                                                                                                                                                                                                                             
		    WITH CTE_NODE(COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,KEY_DATE,EFF_START_DATE,EFF_END_DATE,PARENT_QTY,PARENT_UOM,CHILD_QTY,CHILD_UOM,PARENT_ITEM_TYPE,PARENT_ITEM_CLASS,PARENT_LEVEL_2_CODE,PARENT_LEVEL_3_NAME,PARENT_LEVEL_23_CODE,CHILD_ITEM_TYPE,CHILD_ITEM_CLASS,CHILD_LEVEL_2_CODE,CHILD_LEVEL_3_NAME,CHILD_LEVEL_23_CODE,ALT_ID,ALT_PRIORITY,NLEVEL,NPATH,ROOT,ROOT_NICK_NAME)
					AS 
					(
						SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID,A.KEY_DATE,A.EFF_START_DATE,A.EFF_END_DATE,A.PARENT_QTY,A.PARENT_UOM,A.CHILD_QTY,A.CHILD_UOM
							,PD1.ITEM_TYPE AS PARENT_ITEM_TYPE
							,PD1.ITEM_CLASS AS PARENT_ITEM_CLASS
							,PDC1.LEVEL_2_CODE AS PARENT_LEVEL_2_CODE
							,PDC1.LEVEL_3_NAME AS PARENT_LEVEL_3_NAME
							,PDC1.LEVEL_2_CODE + PDC1.LEVEL_3_CODE AS PARENT_LEVEL_23_CODE
							,PD2.ITEM_TYPE AS CHILD_ITEM_TYPE
							,PD2.ITEM_CLASS AS CHILD_ITEM_CLASS
							,PDC2.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE
							,PDC2.LEVEL_3_NAME AS CHILD_LEVEL_3_NAME
							,PDC2.LEVEL_2_CODE + PDC2.LEVEL_3_CODE AS CHILD_LEVEL_23_CODE
							,A.ALT_ID,A.ALT_PRIORITY
							,1 AS NLEVEL,CONVERT(VARCHAR(100),PARENT_ITEM_ID+'/'+CHILD_ITEM_ID) AS NPATH,PARENT_ITEM_ID AS ROOT 
							,PD1.NICK_NAME AS ROOT_NICK_NAME
						FROM SCM_BOM_M A(NOLOCK)
						INNER MERGE JOIN SCM_ITEM_M PD1(NOLOCK)
						ON A.COMPANY_ID=PD1.COMPANY_ID
						AND A.DIVISION_ID=PD1.DIVISION_ID
						AND A.SITE_ID=PD1.SITE_ID
						AND A.PARENT_ITEM_ID=PD1.ITEM_ID
						INNER MERGE JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)
						ON PD1.ITEM_CLASS=PDC1.CLASS_ID
						INNER MERGE JOIN SCM_ITEM_M PD2(NOLOCK)
						ON A.COMPANY_ID=PD2.COMPANY_ID
						AND A.DIVISION_ID=PD2.DIVISION_ID
						AND A.SITE_ID=PD2.SITE_ID
						AND A.CHILD_ITEM_ID=PD2.ITEM_ID
						INNER MERGE JOIN SCM_ITEM_CLASS_M PDC2(NOLOCK)
						ON PD2.ITEM_CLASS=PDC2.CLASS_ID
						WHERE A.EFF_START_DATE <= DBO.SYSDATE1()
						AND A.EFF_END_DATE >= DBO.SYSDATE1()
						AND A.PARENT_ITEM_ID = @ITEM_ID
						AND A.ACTIVE_FLAG='Y'
						AND PD1.ITEM_TYPE <> 'R'
						AND PD1.ACTIVE_FLAG='Y'
						AND PDC1.USE_FLAG='Y'
						AND PD2.ACTIVE_FLAG='Y'
						--AND PD2.ITEM_TYPE <> 'R'
						AND PDC2.USE_FLAG='Y'
						AND (PD2.ITEM_TYPE <> 'R' OR (PD2.ITEM_TYPE = 'R' AND PDC2.LEVEL_2_CODE='APC'))
						UNION ALL
						SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID,A.KEY_DATE,A.EFF_START_DATE,A.EFF_END_DATE,A.PARENT_QTY,A.PARENT_UOM,A.CHILD_QTY,A.CHILD_UOM
							,PD1.ITEM_TYPE AS PARENT_ITEM_TYPE
							,PD1.ITEM_CLASS AS PARENT_ITEM_CLASS
							,PDC1.LEVEL_2_CODE AS PARENT_LEVEL_2_CODE
							,PDC1.LEVEL_3_NAME AS PARENT_LEVEL_3_NAME
							,PDC1.LEVEL_2_CODE + PDC1.LEVEL_2_CODE AS PARENT_LEVEL_23_CODE
							,PD2.ITEM_TYPE AS CHILD_ITEM_TYPE
							,PD2.ITEM_CLASS AS CHILD_ITEM_CLASS
							,PDC2.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE
							,PDC2.LEVEL_3_NAME AS CHILD_LEVEL_3_NAME
							,PDC2.LEVEL_2_CODE + PDC2.LEVEL_2_CODE AS CHILD_LEVEL_23_CODE
							,A.ALT_ID,A.ALT_PRIORITY
							,NLEVEL+1 AS NLEVEL ,CONVERT(VARCHAR(100),NPATH+'/'+A.CHILD_ITEM_ID) AS NPATH,ROOT
							,ROOT_NICK_NAME
						FROM SCM_BOM_M A(NOLOCK)
						INNER MERGE JOIN CTE_NODE B
						ON A.PARENT_ITEM_ID=B.CHILD_ITEM_ID
						INNER MERGE JOIN SCM_ITEM_M PD1(NOLOCK)
						ON A.COMPANY_ID=PD1.COMPANY_ID
						AND A.DIVISION_ID=PD1.DIVISION_ID
						AND A.SITE_ID=PD1.SITE_ID
						AND A.PARENT_ITEM_ID=PD1.ITEM_ID
						INNER MERGE JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)
						ON PD1.ITEM_CLASS=PDC1.CLASS_ID
						INNER MERGE JOIN SCM_ITEM_M PD2(NOLOCK)
						ON A.COMPANY_ID=PD2.COMPANY_ID
						AND A.DIVISION_ID=PD2.DIVISION_ID
						AND A.SITE_ID=PD2.SITE_ID
						AND A.CHILD_ITEM_ID=PD2.ITEM_ID
						INNER MERGE JOIN SCM_ITEM_CLASS_M PDC2(NOLOCK)
						ON PD2.ITEM_CLASS=PDC2.CLASS_ID
						WHERE A.EFF_START_DATE <= DBO.SYSDATE1()
						AND A.EFF_END_DATE >= DBO.SYSDATE1()
						AND PD1.ITEM_TYPE <> 'R'
						AND PD1.ACTIVE_FLAG='Y'
						AND PDC1.USE_FLAG='Y'
						AND PD2.ACTIVE_FLAG='Y'
						--AND PD2.ITEM_TYPE <> 'R'
						AND PDC2.USE_FLAG='Y'
						AND (PD2.ITEM_TYPE <> 'R' OR (PD2.ITEM_TYPE = 'R' AND PDC2.LEVEL_2_CODE='APC'))
					)
					, BOM_NODE(COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,KEY_DATE,EFF_START_DATE,EFF_END_DATE,PARENT_QTY,PARENT_UOM,CHILD_QTY,CHILD_UOM,PARENT_ITEM_TYPE,PARENT_ITEM_CLASS,PARENT_LEVEL_2_CODE,PARENT_LEVEL_3_NAME,CHILD_ITEM_TYPE,CHILD_ITEM_CLASS,CHILD_LEVEL_2_CODE,CHILD_LEVEL_3_NAME,ALT_ID,ALT_PRIORITY,NLEVEL,NPATH,ROOT,ROOT_NICK_NAME,CNUM,FACTORY_ID)
					AS
					(
						SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,KEY_DATE,EFF_START_DATE,EFF_END_DATE,PARENT_QTY,PARENT_UOM,CHILD_QTY,CHILD_UOM,PARENT_ITEM_TYPE,PARENT_ITEM_CLASS,PARENT_LEVEL_2_CODE,PARENT_LEVEL_3_NAME,CHILD_ITEM_TYPE,CHILD_ITEM_CLASS,CHILD_LEVEL_2_CODE,CHILD_LEVEL_3_NAME,CASE WHEN ALT_ID IS NOT NULL THEN PARENT_ITEM_ID+ALT_ID ELSE ALT_ID END AS ALT_ID,ALT_PRIORITY,NLEVEL,NPATH,ROOT,ROOT_NICK_NAME,CNUM,FACTORY_ID FROM (
							SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,KEY_DATE,EFF_START_DATE,EFF_END_DATE,PARENT_QTY,PARENT_UOM,CHILD_QTY,CHILD_UOM,PARENT_ITEM_TYPE,PARENT_ITEM_CLASS,PARENT_LEVEL_2_CODE,PARENT_LEVEL_3_NAME,CHILD_ITEM_TYPE,CHILD_ITEM_CLASS,CHILD_LEVEL_2_CODE,CHILD_LEVEL_3_NAME,ALT_ID,ALT_PRIORITY,NLEVEL,NPATH,ROOT,ROOT_NICK_NAME
								,ROW_NUMBER() OVER(PARTITION BY PARENT_ITEM_ID,CHILD_ITEM_ID,FACTORY_ID ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,KEY_DATE DESC,ALT_PRIORITY DESC,FACTORY_ID) AS RNUM
								,CNUM,FACTORY_ID
							FROM (
								SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,KEY_DATE,EFF_START_DATE,EFF_END_DATE,PARENT_QTY,PARENT_UOM,CHILD_QTY,CHILD_UOM,PARENT_ITEM_TYPE,PARENT_ITEM_CLASS,PARENT_LEVEL_2_CODE,PARENT_LEVEL_3_NAME,CHILD_ITEM_TYPE,CHILD_ITEM_CLASS,CHILD_LEVEL_2_CODE,CHILD_LEVEL_3_NAME,ALT_ID,ALT_PRIORITY,NLEVEL,NPATH,ROOT,ROOT_NICK_NAME
								--,ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,NPATH ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,KEY_DATE DESC) AS RNUM
								,CASE WHEN CHILD_LEVEL_23_CODE='AAP' OR CHILD_LEVEL_23_CODE='EEP' OR CHILD_LEVEL_23_CODE='MMP' THEN 1
									WHEN CHILD_LEVEL_2_CODE='AMD' OR CHILD_LEVEL_23_CODE='AAM' OR CHILD_LEVEL_23_CODE='EEM' OR CHILD_LEVEL_23_CODE='MMT' THEN 2
									WHEN CHILD_LEVEL_23_CODE='AAC' OR CHILD_LEVEL_23_CODE='EEC' OR CHILD_LEVEL_23_CODE='MMC' THEN 3
									WHEN CHILD_LEVEL_2_CODE='AFC' OR CHILD_LEVEL_2_CODE='ASC' OR CHILD_LEVEL_2_CODE='AJR' THEN 4
									WHEN CHILD_LEVEL_2_CODE='ABC' OR CHILD_LEVEL_2_CODE='AMC' OR CHILD_LEVEL_2_CODE='AHC' THEN 5
									WHEN CHILD_LEVEL_2_CODE='ANR' OR CHILD_LEVEL_2_CODE='ANP' THEN 6
									WHEN CHILD_LEVEL_23_CODE='AEAAEAAP' THEN 7
									WHEN CHILD_LEVEL_2_CODE='APC' OR CHILD_LEVEL_23_CODE='AEAAEACJ' THEN 8
									WHEN CHILD_LEVEL_2_CODE='ASL' THEN 9
									ELSE 11
								 END AS CNUM
								 ,B.FACTORY_ID
								FROM CTE_NODE A
								LEFT OUTER JOIN (SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,ITEM_ID FROM SCM_ITEM_LINE_ASSIGN_M(NOLOCK)
												WHERE MONTH=SUBSTRING(CONVERT(VARCHAR, dbo.SYSDATE1(), 112), 1, 6) AND ACTIVE_FLAG = 'Y'
												GROUP BY COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,ITEM_ID 
												) B
								ON A.COMPANY_ID=B.COMPANY_ID
								AND A.DIVISION_ID=B.DIVISION_ID
								AND A.SITE_ID=B.SITE_ID
								AND A.PLANT_ID=B.PLANT_ID
								AND A.CHILD_ITEM_ID=B.ITEM_ID
								UNION ALL
								SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,PARENT_ITEM_ID,PARENT_ITEM_ID AS CHILD_ITEM_ID,KEY_DATE,EFF_START_DATE,EFF_END_DATE,PARENT_QTY,PARENT_UOM,CHILD_QTY,CHILD_UOM,PARENT_ITEM_TYPE,PARENT_ITEM_CLASS,PARENT_LEVEL_2_CODE,PARENT_LEVEL_3_NAME,PARENT_ITEM_TYPE AS CHILD_ITEM_TYPE,PARENT_ITEM_CLASS AS CHILD_ITEM_CLASS,PARENT_LEVEL_2_CODE AS CHILD_LEVEL_2_CODE,PARENT_LEVEL_3_NAME AS CHILD_LEVEL_3_NAME,NULL AS ALT_ID,NULL AS ALT_PRIORITY,0 AS NLEVEL,NPATH,ROOT,ROOT_NICK_NAME
								,CASE WHEN PARENT_LEVEL_23_CODE='AAP' OR PARENT_LEVEL_23_CODE='EEP' OR PARENT_LEVEL_23_CODE='MMP' THEN 1
									WHEN PARENT_LEVEL_2_CODE='AMD' OR PARENT_LEVEL_23_CODE='AAM' OR PARENT_LEVEL_23_CODE='EEM' OR PARENT_LEVEL_23_CODE='MMT' THEN 2
									WHEN PARENT_LEVEL_23_CODE='AAC' OR PARENT_LEVEL_23_CODE='EEC' OR PARENT_LEVEL_23_CODE='MMC' THEN 3
									WHEN PARENT_LEVEL_2_CODE='AFC' OR PARENT_LEVEL_2_CODE='ASC' OR PARENT_LEVEL_2_CODE='AJR' THEN 4
									WHEN PARENT_LEVEL_2_CODE='ABC' OR PARENT_LEVEL_2_CODE='AMC' OR PARENT_LEVEL_2_CODE='AHC' THEN 5
									WHEN PARENT_LEVEL_2_CODE='ANR' OR CHILD_LEVEL_2_CODE='ANP' THEN 6
									WHEN PARENT_LEVEL_23_CODE='AEAAEAAP' THEN 7
									WHEN PARENT_LEVEL_2_CODE='APC' OR PARENT_LEVEL_23_CODE='AEAAEACJ' THEN 8
									WHEN PARENT_LEVEL_2_CODE='ASL' THEN 9
									ELSE 11
								 END AS CNUM
								 ,B.FACTORY_ID
								FROM CTE_NODE A
								LEFT OUTER JOIN (SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,ITEM_ID FROM SCM_ITEM_LINE_ASSIGN_M(NOLOCK)
												WHERE MONTH=SUBSTRING(CONVERT(VARCHAR, dbo.SYSDATE1(), 112), 1, 6) AND ACTIVE_FLAG = 'Y'
												GROUP BY COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,ITEM_ID 
												) B
								ON A.COMPANY_ID=B.COMPANY_ID
								AND A.DIVISION_ID=B.DIVISION_ID
								AND A.SITE_ID=B.SITE_ID
								AND A.PLANT_ID=B.PLANT_ID
								AND A.PARENT_ITEM_ID=B.ITEM_ID
								WHERE A.PARENT_ITEM_ID  = @ITEM_ID
							) A
						) A
						WHERE RNUM=1
					)
					, BOM_DIST(COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,CHILD_ITEM_ID,CHILD_LEVEL_2_CODE,CHILD_LEVEL_3_NAME,ALT_ID,ALT_PRIORITY,ROOT,CNUM,RNUM,FACTORY_ID,NICK_NAME)
					AS
					(
						SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,CHILD_ITEM_ID,CHILD_LEVEL_2_CODE,CHILD_LEVEL_3_NAME,ALT_ID,ALT_PRIORITY,ROOT,CNUM,RNUM,FACTORY_ID,NICK_NAME
					  FROM 
					  (
							SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.CHILD_ITEM_ID,A.CHILD_LEVEL_2_CODE,A.CHILD_LEVEL_3_NAME,A.ALT_ID,A.ALT_PRIORITY,A.ROOT,A.CNUM
					      		,ROW_NUMBER() OVER(PARTITION BY A.CNUM ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ALT_ID,A.ALT_PRIORITY ASC) AS RNUM
					      		,A.FACTORY_ID, A.ROOT_NICK_NAME AS NICK_NAME
							FROM  BOM_NODE A
							WHERE A.DIVISION_ID IN ('40','81','82')
						  AND   A.PLANT_ID IN ('3050','A010','A011','A040','A041','A050','G182','G183','G382','G383','G451','G452')
							GROUP BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.CHILD_ITEM_ID,A.CHILD_LEVEL_2_CODE,A.CHILD_LEVEL_3_NAME,A.ALT_ID,A.ALT_PRIORITY,A.ROOT,CNUM,A.FACTORY_ID,A.ROOT_NICK_NAME
						) A
					)                                                                                                                                                                                                                                                                 
			  INSERT INTO @vTBL_MAIL_CONTENTS        
			  (
					   ROOT          
					  ,RNUM          
					  ,NICK_NAME     
					  ,bLEVEL1_A     
					  ,bLEVEL1       
					  ,bLEVEL1_P     
					  ,bLEVEL2_A     
					  ,bLEVEL2       
					  ,bLEVEL2_P     
					  ,bLEVEL3_A     
					  ,bLEVEL3       
					  ,bLEVEL3_P     
					  ,bLEVEL4_A     
					  ,bLEVEL4       
					  ,bLEVEL4_P     
					  ,bLEVEL5_A     
					  ,bLEVEL5       
					  ,bLEVEL5_P     
					  ,bLEVEL6_A     
					  ,bLEVEL6       
					  ,bLEVEL6_P     
					  ,bLEVEL7_A     
					  ,bLEVEL7       
					  ,bLEVEL7_P     
					  ,bLEVEL8_A     
					  ,bLEVEL8       
					  ,bLEVEL8_P     
					  ,bLEVEL9_A     
					  ,bLEVEL9       
					  ,bLEVEL9_P     
					  ,bLEVEL10_A    
					  ,bLEVEL10      
					  ,bLEVEL10_P    
					  ,bLEVEL11_A    
					  ,bLEVEL11      
					  ,bLEVEL11_P       
			  )                                                                                                                                                                                                                    
					select ROOT,RNUM,NICK_NAME
					      ,MAX(CASE WHEN CNUM=1 THEN ALT_PRIORITY END) AS bLEVEL1_A
					      ,MAX(CASE WHEN CNUM=1 THEN CHILD_ITEM_ID END) AS bLEVEL1
					      ,MAX(CASE WHEN CNUM=1 THEN FACTORY_ID END) AS bLEVEL1_P
					      ,MAX(CASE WHEN CNUM=2 THEN ALT_PRIORITY END) AS bLEVEL2_A
					      ,MAX(CASE WHEN CNUM=2 THEN CHILD_ITEM_ID END) AS bLEVEL2
					      ,MAX(CASE WHEN CNUM=2 THEN FACTORY_ID END) AS bLEVEL2_P
					      ,MAX(CASE WHEN CNUM=3 THEN ALT_PRIORITY END) AS bLEVEL3_A
					      ,MAX(CASE WHEN CNUM=3 THEN CHILD_ITEM_ID END) AS bLEVEL3
					      ,MAX(CASE WHEN CNUM=3 THEN FACTORY_ID END) AS bLEVEL3_P
					      ,MAX(CASE WHEN CNUM=4 THEN ALT_PRIORITY END) AS bLEVEL4_A
					      ,MAX(CASE WHEN CNUM=4 THEN CHILD_ITEM_ID END) AS bLEVEL4
					      ,MAX(CASE WHEN CNUM=4 THEN FACTORY_ID END) AS bLEVEL4_P
					      ,MAX(CASE WHEN CNUM=5 THEN ALT_PRIORITY END) AS bLEVEL5_A
					      ,MAX(CASE WHEN CNUM=5 THEN CHILD_ITEM_ID END) AS bLEVEL5
					      ,MAX(CASE WHEN CNUM=5 THEN FACTORY_ID END) AS bLEVEL5_P
					      ,MAX(CASE WHEN CNUM=6 THEN ALT_PRIORITY END) AS bLEVEL6_A
					      ,MAX(CASE WHEN CNUM=6 THEN CHILD_ITEM_ID END) AS bLEVEL6
					      ,MAX(CASE WHEN CNUM=6 THEN FACTORY_ID END) AS bLEVEL6_P
					      ,MAX(CASE WHEN CNUM=7 THEN ALT_PRIORITY END) AS bLEVEL7_A
					      ,MAX(CASE WHEN CNUM=7 THEN CHILD_ITEM_ID END) AS bLEVEL7
					      ,MAX(CASE WHEN CNUM=7 THEN FACTORY_ID END) AS bLEVEL7_P
					      ,MAX(CASE WHEN CNUM=8 THEN ALT_PRIORITY END) AS bLEVEL8_A
					      ,MAX(CASE WHEN CNUM=8 THEN CHILD_ITEM_ID END) AS bLEVEL8
					      ,MAX(CASE WHEN CNUM=8 THEN FACTORY_ID END) AS bLEVEL8_P
					      ,MAX(CASE WHEN CNUM=9 THEN ALT_PRIORITY END) AS bLEVEL9_A
					      ,MAX(CASE WHEN CNUM=9 THEN CHILD_ITEM_ID END) AS bLEVEL9
					      ,MAX(CASE WHEN CNUM=9 THEN FACTORY_ID END) AS bLEVEL9_P
					      ,MAX(CASE WHEN CNUM=10 THEN ALT_PRIORITY END) AS bLEVEL10_A
					      ,MAX(CASE WHEN CNUM=10 THEN CHILD_ITEM_ID END) AS bLEVEL10
					      ,MAX(CASE WHEN CNUM=10 THEN FACTORY_ID END) AS bLEVEL10_P
					      ,MAX(CASE WHEN CNUM=11 THEN ALT_PRIORITY END) AS bLEVEL11_A
					      ,MAX(CASE WHEN CNUM=11 THEN CHILD_ITEM_ID END) AS bLEVEL11
					      ,MAX(CASE WHEN CNUM=11 THEN FACTORY_ID END) AS bLEVEL11_P
					FROM BOM_DIST
					GROUP BY ROOT,RNUM,NICK_NAME
					;
                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                 
            FETCH NEXT FROM CUR_MAIL                                                                                                                                                                                                                             
		                INTO  @ITEM_ID                                                                                                                                                                                                                     
        END;                                                                                                                                                                                                                                                     
        CLOSE CUR_MAIL;                                                                                                                                                                                                                                          
        DEALLOCATE CUR_MAIL;                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                 
		-- ================================================                                                                                                                                                                                                          
		-- 로직 추가 end                                                                                                                                                                                                                                             
		-- ================================================                                                                                                                                                                                                          
		    COMMIT TRAN                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                 
	 	    EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate                                                                                                                       
	                                                                                                                                                                                                                                                               
   	END TRY                                                                                                                                                                                                                                                      
	   ----------------------------------------------------------------------------                                                                                                                                                                                
			BEGIN CATCH                                                                                                                                                                                                                                                
				CLOSE CUR_MAIL;                                                                                                                                                                                                                                          
				DEALLOCATE CUR_MAIL;                                                                                                                                                                                                                                     
		                                                                                                                                                                                                                                                             
			    ROLLBACK TRAN                                                                                                                                                                                                                                          
				-- 에러나도 로그는 인서트                                                                                                                                                                                                                                
				SET @v_descr = ERROR_MESSAGE()                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                 
				EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate                                                                                                                                                                    
                                                                                                                                                                                                                                                                 
	   END CATCH                                                                                                                                                                                                                                                   
	   ----------------------------------------------------------------------------                                                                                                                                                                                
END                                                                                                                                                                                                                                                              
--******************************************************************************                                                                                                                                                                                 
--PROGRAM END                                                                                                                                                                                                                                                    
--******************************************************************************                                                                                                                                                                                 
                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                 
