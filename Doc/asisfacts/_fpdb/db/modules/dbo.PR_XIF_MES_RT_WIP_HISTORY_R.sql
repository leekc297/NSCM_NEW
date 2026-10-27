

CREATE PROCEDURE [dbo].[PR_XIF_MES_RT_WIP_HISTORY_R]

-- ================================================================================================
-- Program ID          : FP00840
-- Program Name        : PR_XIF_MES_RT_WIP_HISTORY_R
-- Param               :
-- Batch Period        : 1HOUR
-- Description         : 
--                       
--                       
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_WIXIF_MES_RT_WIP_HISTORY_R
-- Destination Table   : SCM_MES_RT_WIP_HISTORY_H
--
-- Create Date		   : 2017.08.11
-- Update Date         : 2017-09-06 kimcd 1.2
--						 2018-10-18 PIYONG 1.3
--						 2019-07-09 PIYONG 1.4
--						 2019-07-15 PIYONG 1.5
--                       2019-08-16 kimcd  1.6
--			             
-- Author              : PIYONG
-- Version             : 1.0
--						 1.1   SCM_MES_WIP_HISTORY_H 의 WIP_TYPE_CODE 조건에  PROD 추가
--						 1.2   kimcd row_number 구하는 조건 transfer_date에서 if_rcv_date로 변경. wo detail id는 항상 wo id와 같도록 수정
--                             wo detail id는 항상 wo id와 같도록 수정. 조립에서 잘못된 detail wo id 할당으로 인한 보정
--						 1.3 2018-10-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
--												ISNULL(U.DIVISION_CODE, (CASE WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ('A','E') AND U.EQSGID = 'E7D01' THEN '81' 
--																			 WHEN  ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN '40' 
--																			  ELSE L.DIVISION_ID END ))
--												(case when U.DIVISION_CODE = '81' and U.EQSGID = 'E7D01' then 
--															'E8' 
--													  when ( select top 1 substring(a.ITEM_NAME,1,1) from scm_item_m a where a.item_id = u.PRODID ) IN ( 'A', 'E') and U.EQSGID = 'E7D01' then 
--															'E8' 
--													  when ( select distinct substring(a.ITEM_NAME,1,1) from scm_item_m a where a.item_id = u.PRODID ) = 'M'  and U.EQSGID = 'E7D01' then 
--															'E7'
--													  else substring(u.EQSGID,1,2) end )  =  L.FACTORY_ID
--						 1.4  2019-07-09 PIYONG 데이터 생성 JOIN  테이블 변경 SCM_EQUIPMENT_M -> SCM_LINE_M
--						 1.5  2019-07-15 PIYONG SCM_EQUIPMENT_M, SCM_LINE_M  조인시 컬럼 정렬
--                       1.6  2019-08-16 kimcd [SCM_MES_RT_WIP_HISTORY_H] key 구조 변경. PROCID, FACTORY_ID 추가
--                       3.7 2021-07-12 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                                      AREA_ID (FACTORY ID) 기준으로 SITE ID 찾는것으로 변경
-- ================================================================================================


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_RT_WIP_HISTORY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @v_table     NVARCHAR(1000)


	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @IF_ID        NVARCHAR(50)
	DECLARE @ACCUM_DATE   NVARCHAR(50)
	DECLARE @SITE_ID      NVARCHAR(50)
	DECLARE @v_seqcount   INTEGER	   = 0
	DECLARE @BASE_HOUR    NVARCHAR(2)

	DECLARE CUR_IF_MES_WIPHIST CURSOR FOR
		--2021-07-12 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : AREA_ID (FACTORY ID) 기준으로 SITE ID 찾는것으로 변경
		--SELECT IF_ID, ACCUM_DATE, ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE MES_SOURCE_GROUP = SUBSTRING(IF_ID,1,4) ) SITE_ID
		SELECT IF_ID, ACCUM_DATE, ( SELECT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE Z.FACTORY_ID = MAX(AREA_ID) ) SITE_ID
		  FROM [SY_XIF_MES_RT_WIP_HISTORY_R]
		 WHERE 1=1
		   AND PROC_FLAG = 'N'
		 GROUP BY IF_ID, ACCUM_DATE
		HAVING ( COUNT(1) = MAX(ACCUM_COUNT)  OR ( COUNT(1) = 1 AND MAX(ACCUM_COUNT) = 0 ) )  -- 전체를 수신받지 못한 경우에는 처리하지 않음.
		 ORDER BY IF_ID, ACCUM_DATE


	-- ================================================
    -- Declare end
	-- ================================================
	--Violation of PRIMARY KEY constraint 'PK_FP_MES_WORK_ORDER_STATUS_H'. Cannot insert duplicate key in object 'dbo.FP_MES_WORK_ORDER_STATUS_H'. The duplicate key value is (C100, 81, A001, A040, A1, Nov 19 2016 12:00AM, WK116B03LM00N#1).

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		  
		  set @v_seqcount = 0

		  -- SITE 정보 추가
		  OPEN CUR_IF_MES_WIPHIST;
		  FETCH NEXT FROM CUR_IF_MES_WIPHIST INTO  @IF_ID        
												  ,@ACCUM_DATE
												  ,@SITE_ID
												  ;
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
	
	            set @v_seqcount = @v_seqcount + 10000


				MERGE INTO [dbo].[SCM_MES_RT_WIP_HISTORY_H] A
				USING ( SELECT ISNULL(ISNULL(L.FACTORY_ID, C.FACTORY_ID),SUBSTRING(U.EQSGID,1,2)) AS FACTORY_ID  -- 2019-08-16 kimcd factory id 없는 경우 대비 SUBSTRING(U.EQSGID,1,2) 처리
								,U.LOTID            
								,U.WIPSEQ           
								,U.CALDATE          
								,U.SHIFT            
								,U.PRODID           
								,U.BOMREV           
								,U.ROUTID           
								,U.FLOWID           
								,U.PCSGID           
								,U.PROCID           
								,U.EQSGID           
								,U.EQPTID    
								,U.WIPDTTM_ST
								,U.WIPDTTM_ED
								,U.WIPQTY_ED				        
								,U.WOID             
								,U.WIPQTY2_IN       
								,U.WIPQTY2_ST       
								,U.WIPQTY2_ED       
								,U.WIPQTY2_OT       
								,U.WIP_TYPE_CODE    
								,U.CNFM_DFCT_QTY    
								,U.CNFM_LOSS_QTY    
								,U.CNFM_PRDT_REQ_QTY
								,U.CNFM_DFCT_QTY2
								,U.CNFM_LOSS_QTY2
								,U.CNFM_PRDT_REQ_QTY2
								,U.WIP_NOTE         
								,U.ERP_TRNF_FLAG    
								,U.WO_DETL_ID       
								,U.SCRAP_QTY
								,U.COATING_SIDE_TYPE_CODE
								,U.WIPQTY2_ENGINE
								,@SITE_ID AS SITE_ID
								,U.ADD_QTY
						  FROM (
								SELECT A.LOTID            
									,ISNULL(A.WIPSEQ, '1') WIPSEQ
									, CONVERT(datetime, 
														SUBSTRING( ACCUM_DATE, 1,4)+'-'+
														SUBSTRING( ACCUM_DATE, 5,2)+'-'+
														SUBSTRING( ACCUM_DATE, 7,2)+' '+
														SUBSTRING( ACCUM_DATE, 9,2)+':'+
														SUBSTRING( ACCUM_DATE, 11,2)+':00'
													, 120) AS  CALDATE
									,A.SHIFT            
									,A.PRODID           
									,A.BOMREV           
									,A.ROUTID           
									,A.FLOWID           
									,A.PCSGID           
									,A.PROCID           
									,A.EQSGID           
									,A.EQPTID
									,convert( varchar, A.WIPDTTM_ST ,120) WIPDTTM_ST
									,convert( varchar, A.WIPDTTM_ED ,120) WIPDTTM_ED
									,A.WIPQTY_ED				           
									,A.WOID             
									,A.WIPQTY2_IN       
									,A.WIPQTY2_ST       
									,A.WIPQTY2_ED
									,A.COATING_SIDE_TYPE_CODE
									-- 양면 coating을 하는 경우에 Top과 Back의 LOT ID가 다르게 채번됨.
									-- 양품 수량은 Back 기준으로 하면되나 Loss나 Dfct 같은 경우에는 top back을 더해야 함.
									-- 단면 모델인 경우에는 top 수량을 생산실적으로 넣어야 함. 
									,ISNULL(CASE WHEN COATING_SIDE_TYPE_CODE = 'T' AND (select count(1) from scm_item_m w, scm_item_class_m x  where w.item_id = A.PRODID  and w.item_class = x.class_id and x.level_3_code = 'APCCS') = 0 THEN NULL ELSE WIPQTY2_ED END, 0) 
											AS WIPQTY2_ENGINE
									,A.WIPQTY2_OT       
									,A.WIP_TYPE_CODE    
									,A.CNFM_DFCT_QTY
									,A.CNFM_LOSS_QTY
									,A.CNFM_PRDT_REQ_QTY
									,A.CNFM_DFCT_QTY2
									,A.CNFM_LOSS_QTY2
									,A.CNFM_PRDT_REQ_QTY2
									,A.WIP_NOTE         
									,A.ERP_TRNF_FLAG    
									,CASE WHEN A.WOID != A.WO_DETL_ID THEN A.WOID ELSE ISNULL(A.WO_DETL_ID, A.WOID) END  AS WO_DETL_ID  -- KIMCD 2017-08-04 ADD ISNULL() KIMCD 2017-09-06 ADD CASE
									,A.SCRAP_QTY
									,A.ADD_QTY
									,(SELECT TOP 1 F.DIVISION_ID                                                                                                                       
											FROM [DBO].[FP_PRODUCTION_PLAN_R] F with(nolock)                                                                                                  
											WHERE F.WORK_ORDER_ID = A.WOID
												AND F.PRODUCTION_TYPE IS NOT NULL
												ORDER BY FP_PLAN_ID DESC  ) DIVISION_CODE
									,ROW_NUMBER() over ( partition by lotid,ISNULL(A.WIPSEQ, '1'), A.PROCID, ISNULL(A.AREA_ID, SUBSTRING(A.EQSGID,1,2)) order by if_rcv_date desc) ROWUMBER   -- 2019-08-16 kimcd 분할 조건에 PROCID, ISNULL(AREA_ID, SUBSTRING(A.EQSGID,1,2)) 추가  -- kimcd 2017-09-05 transfer_date에서 if_rcv_date로 변경
								FROM [dbo].[SY_XIF_MES_RT_WIP_HISTORY_R] A with(nolock)
								WHERE A.WIP_TYPE_CODE IN ( 'INOUT','OUT','PACKED', 'PROD') -- PACKED 는 Pack 포장용	-- PIYONG 2017-08-25 PROD 추가
								   AND IF_ID       = @IF_ID
								   AND ACCUM_DATE  = @ACCUM_DATE
							) U                                                                                                                                                     
							LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] L WITH(NOLOCK)
									-----------------------------------------------------------------------------
									--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
									ON L.DIVISION_ID =  ISNULL(U.DIVISION_CODE, L.DIVISION_ID)
								-- MODIFY 2017.05.15 설비는 다 E7 이나 자동차는 E8 이고 소형은 E7 임 
								--2018-10-18 PIYOND DEL
								--AND  (CASE WHEN U.DIVISION_CODE = '81' AND U.EQSGID = 'E7D01' THEN 'E8' WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ( 'A', 'E') AND U.EQSGID = 'E7D01' THEN 'E8' WHEN  ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN 'E7' ELSE SUBSTRING(U.EQSGID,1,2) END )  =  L.FACTORY_ID
								   AND L.FACTORY_ID = SUBSTRING(U.EQSGID,1,2)
								   AND L.MES_LINE_ID = U.EQSGID
								--2018-10-18 PIYOND DEL
								--AND L.DIVISION_ID =  ISNULL(U.DIVISION_CODE, (CASE WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ('A','E') AND U.EQSGID = 'E7D01' THEN '81' WHEN  ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN '40' ELSE L.DIVISION_ID END ))
								   AND L.OPERATION_ID = U.PROCID  -- 하나의 설비가 여러 공정에 속할 수 있다고 함.
								   AND L.EQUIPMENT_ID  = U.EQPTID
									--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
									-----------------------------------------------------------------------------
							-- 설비가 우리쪽에 없는 CASE에 대해서 COMPANY,DIVISION을 찾기 위함.
							LEFT OUTER JOIN (SELECT A.COMPANY_ID
													, A.DIVISION_ID
													, A.SITE_ID
													, A.PLANT_ID
													, A.FACTORY_ID
													, A.OPERATION_ID
													, A.LINE_ID			--MAX( A.LINE_ID ) AS LINE_ID	-- 2019-07-09 PIYONG DEL MAX 삭제
													, MAX(A.LOCATION) AS LOCATION						-- 2019-07-09 PIYONG ADD
											   FROM [DBO].SCM_LINE_M A WITH(NOLOCK)						-- 2019-07-09 PIYONG CHANGE SCM_EQUIPMENT_M -> SCM_LINE_M
											  WHERE A.SITE_ID = @SITE_ID								-- 2019-07-09 PIYONG ADD
											  GROUP BY A.COMPANY_ID
													, A.DIVISION_ID
													, A.SITE_ID
													, A.PLANT_ID
													, A.FACTORY_ID
													, A.OPERATION_ID
													, A.LINE_ID			-- 2019-07-09 PIYONG ADD
												) C
								-----------------------------------------------------------------------------
								--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
								 ON C.DIVISION_ID =  ISNULL(U.DIVISION_CODE, C.DIVISION_ID )				-- 2019-07-09 PIYONG CHANGE MES_LINE_ID -> LINE_ID
								AND C.FACTORY_ID  =  SUBSTRING(U.EQSGID,1,2)
								AND C.LINE_ID = U.EQSGID
								AND C.OPERATION_ID = U.PROCID
								--2018-10-18 PIYOND DELL
								--AND C.DIVISION_ID =  ISNULL(U.DIVISION_CODE, (CASE WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ( 'A','E') AND U.EQSGID = 'E7D01' THEN '81' WHEN  ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN '40' ELSE C.DIVISION_ID END ))
								--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
								-----------------------------------------------------------------------------
								
						WHERE U.ROWUMBER = 1
						) B
				 ON (    A.LOTID  = B.LOTID
					 AND A.WIPSEQ = B.WIPSEQ 
					 AND A.PROCID = B.PROCID  -- 2019-08-16 kimcd 공정 추가
					 AND A.FACTORY_ID = B.FACTORY_ID ) -- 2019-08-16 kimcd 공장 동 추가
				WHEN MATCHED THEN
					UPDATE SET   A.CALDATE           = B.CALDATE          
								,A.SHIFT             = B.SHIFT
								--,A.FACTORY_ID		 = B.FACTORY_ID  -- 2019-08-16 kimcd 공장 동 갱신 제한      
								,A.PRODID            = B.PRODID           
								,A.BOMREV            = B.BOMREV           
								,A.ROUTID            = B.ROUTID           
								,A.FLOWID            = B.FLOWID           
								,A.PCSGID            = B.PCSGID           
								--,A.PROCID            = B.PROCID    -- 2019-08-16 kimcd 공정 갱신 제한
								,A.EQSGID            = B.EQSGID           
								,A.EQPTID            = B.EQPTID         
								,A.WIPDTTM_ST		 = B.WIPDTTM_ST
								,A.WIPDTTM_ED		 = B.WIPDTTM_ED
								,A.WIPQTY_ED		 = B.WIPQTY_ED						  
								,A.WOID              = B.WOID             
								,A.WIPQTY2_IN        = B.WIPQTY2_IN       
								,A.WIPQTY2_ST        = B.WIPQTY2_ST       
								,A.WIPQTY2_ED        = B.WIPQTY2_ED       
								,A.WIPQTY2_OT        = B.WIPQTY2_OT       
								,A.WIP_TYPE_CODE     = B.WIP_TYPE_CODE    
								,A.CNFM_DFCT_QTY     = B.CNFM_DFCT_QTY    
								,A.CNFM_LOSS_QTY     = B.CNFM_LOSS_QTY    
								,A.CNFM_PRDT_REQ_QTY = B.CNFM_PRDT_REQ_QTY
								,A.CNFM_DFCT_QTY2     = B.CNFM_DFCT_QTY2    
								,A.CNFM_LOSS_QTY2     = B.CNFM_LOSS_QTY2   
								,A.CNFM_PRDT_REQ_QTY2 = B.CNFM_PRDT_REQ_QTY2
								,A.WIP_NOTE               = B.WIP_NOTE         
								,A.ERP_TRNF_FLAG          = B.ERP_TRNF_FLAG    
								,A.WO_DETL_ID             = B.WO_DETL_ID       
								,A.SCRAP_QTY              = B.SCRAP_QTY 
								,A.MODIFY_USER_ID         = 'PR_XIF_MES_RT_WIP_HISTORY_R'
								,A.MODIFY_DATE            = GETDATE()
								,A.COATING_SIDE_TYPE_CODE = B.COATING_SIDE_TYPE_CODE
								,A.WIPQTY2_ENGINE         = B.WIPQTY2_ENGINE
								,A.attribute1             = B.SITE_ID
								,A.ADD_QTY				  = B.ADD_QTY
					                
				WHEN NOT MATCHED THEN
					INSERT (  LOTID            
							 ,WIPSEQ           
							 ,CALDATE          
							 ,SHIFT
							 ,FACTORY_ID            
							 ,PRODID           
							 ,BOMREV           
							 ,ROUTID           
							 ,FLOWID           
							 ,PCSGID           
							 ,PROCID           
							 ,EQSGID           
							 ,EQPTID    
							 ,WIPDTTM_ST
							 ,WIPDTTM_ED
							 ,WIPQTY_ED				        
							 ,WOID             
							 ,WIPQTY2_IN       
							 ,WIPQTY2_ST       
							 ,WIPQTY2_ED       
							 ,WIPQTY2_OT       
							 ,WIP_TYPE_CODE    
							 ,CNFM_DFCT_QTY    
							 ,CNFM_LOSS_QTY    
							 ,CNFM_PRDT_REQ_QTY
							 ,CNFM_DFCT_QTY2
							 ,CNFM_LOSS_QTY2
							 ,CNFM_PRDT_REQ_QTY2
							 ,WIP_NOTE         
							 ,ERP_TRNF_FLAG    
							 ,WO_DETL_ID       
							 ,SCRAP_QTY
							 ,CREATE_USER_ID
							 ,CREATE_DATE
							 ,MODIFY_USER_ID
							 ,MODIFY_DATE
							 ,COATING_SIDE_TYPE_CODE
							 ,WIPQTY2_ENGINE
							 ,ATTRIBUTE1
							 ,ADD_QTY
							)
					VALUES ( B.LOTID            
							,B.WIPSEQ           
							,B.CALDATE          
							,B.SHIFT
							,B.FACTORY_ID            
							,B.PRODID           
							,B.BOMREV           
							,B.ROUTID           
							,B.FLOWID           
							,B.PCSGID           
							,B.PROCID           
							,B.EQSGID           
							,B.EQPTID    
							,B.WIPDTTM_ST
							,B.WIPDTTM_ED
							,B.WIPQTY_ED					       
							,B.WOID             
							,B.WIPQTY2_IN       
							,B.WIPQTY2_ST       
							,B.WIPQTY2_ED       
							,B.WIPQTY2_OT       
							,B.WIP_TYPE_CODE    
							,B.CNFM_DFCT_QTY    
							,B.CNFM_LOSS_QTY    
							,B.CNFM_PRDT_REQ_QTY
							,B.CNFM_DFCT_QTY2
							,B.CNFM_LOSS_QTY2
							,B.CNFM_PRDT_REQ_QTY2
							,B.WIP_NOTE         
							,B.ERP_TRNF_FLAG    
							,B.WO_DETL_ID       
							,B.SCRAP_QTY
							,'PR_XIF_MES_RT_WIP_HISTORY_R'
							,GETDATE()
							,'PR_XIF_MES_RT_WIP_HISTORY_R'
							,GETDATE()
							,B.COATING_SIDE_TYPE_CODE
							,B.WIPQTY2_ENGINE
							,B.SITE_ID
							,B.ADD_QTY
							)
				;

			

			UPDATE [dbo].[SY_XIF_MES_RT_WIP_HISTORY_R]
			   SET PROC_FLAG    = 'Y'
				   ,PROC_DATE    = GETDATE()
			 WHERE IF_ID        = @IF_ID  
			   AND ACCUM_DATE   = @ACCUM_DATE
			;


		  FETCH NEXT FROM CUR_IF_MES_WIPHIST INTO  @IF_ID        
												  ,@ACCUM_DATE
												  ,@SITE_ID
												  ;


		  END;
		  CLOSE CUR_IF_MES_WIPHIST;
		  DEALLOCATE CUR_IF_MES_WIPHIST;


		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, @v_table, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, @v_table, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
