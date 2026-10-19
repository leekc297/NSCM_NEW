
/*
 * Program ID   : PR_SSP_XIF_ERP_UI_SHIP_PLAN_CONFIRM_REQUEST
 * Description  : UI에서 SHIP PLAN ERP전송데이타 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/21   ygkim	      Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/06/06   ygkim		  @p_request_no 파라미터 추가
 * 2018/07/10   ygkim		  @p_change_type, @p_shipment_status 파라미터 추가
 * 2019/04/04	ayj			  [PJ20189106] 전지.GSCM 고도화 이행- 소형 컬럼추가
 * 2021/03/09	KIMYONGHO     임시 조치 IFSEQNO ORDER BY 변경
 * 2025/11/20   chkim.68        E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_ERP_UI_SHIP_PLAN_CONFIRM_REQUEST] 
	@p_request_no			NVARCHAR(MAX)
	,@p_change_type			NVARCHAR(MAX) = 'C'
	,@p_shipment_status		NVARCHAR(MAX) = 'D'
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE  @IFSEQNO				nvarchar(14 );
	DECLARE  @LAST_CONFIRM_DATE      nvarchar(8 );
	DECLARE  @SHIPMENT_STATUS        nvarchar(1 );

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	DECLARE @XIF_ERP_SHIP_PLAN_CONFIRM_S TABLE
		(
			 IFSEQNO				nvarchar(100) 
			,LAST_CONFIRM_DATE      nvarchar(100)
			,SHIPMENT_STATUS        nvarchar(100)
			,CONFIRM_ID             nvarchar(100)
			,VERSION_TYPE           nvarchar(100)
			,SALES_COMPANY_ID       nvarchar(30)
			,DIVISION_ID            nvarchar(30)
			,ITEM_ID                nvarchar(50)
			,FROM_SITE              nvarchar(30)
			,TO_SITE                nvarchar(30)
			,YYYYMMDD               nvarchar(8 )
			,QTY                    decimal(30,3)
			,OPERATION_GROUP        nvarchar(10)
			,BIZ_TYPE               nvarchar(30)
			,PROJECT_CODE           nvarchar(50)
			,FCST_TYPE              nvarchar(20)
			,FCST_ETD_DATE          nvarchar(8 )
			,FCST_ETA_DATE          nvarchar(8 )
			,ETD_DATE               nvarchar(8 )
			,ETA_DATE               nvarchar(8 )
			,INCOTERMS              nvarchar(10)
			,INCOTERMS2             nvarchar(10)
			,TRANSPORT_MODE         nvarchar(50)
			,D_COUNTRY              nvarchar(3 )
			,D_PORT_CODE            nvarchar(10)
			,A_COUNTRY              nvarchar(3 )
			,A_PORT_CODE            nvarchar(10)
			,CUSTOMER_LT            INT
			,TO_COUNTRY             nvarchar(3 )
			,TO_CITY                nvarchar(5 ) --길이확인
			,FROM_SITE_TYPE         nvarchar(1 )
			,FROM_SITE_PLANT_ID     nvarchar(30)
			,FROM_SITE_VENDOR_ID    nvarchar(30)
			,FROM_SITE_SOLDTO_CODE  nvarchar(10)
			,FROM_SITE_SHIPTO_CODE  nvarchar(10)
			,FROM_SITE_COMPANY_ID   nvarchar(30)
			,TO_SITE_TYPE           nvarchar(1 )
			,TO_SITE_PLANT_ID       nvarchar(30)
			,TO_SITE_VENDOR_ID      nvarchar(30)
			,TO_SITE_SOLDTO_CODE    nvarchar(10)
			,TO_SITE_SHIPTO_CODE    nvarchar(10)
			,TO_SITE_COMPANY_ID     nvarchar(30)
			,BUILDING				nvarchar(255)
			,REMARK					nvarchar(255)
			,CUSTOMER_REQ			nvarchar(255)
			,CHANGE_CODE			nvarchar(3)
			,CHANGE_CODE_NAME		nvarchar(100)
			,REQUESTOR				nvarchar(100)
			/*----------------------------------------------------------------------------------------
				2020.06.30 : KBK
				I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
			------------------------------------------------------------------------------------------*/
			,PACKAGE_TYPE	        nvarchar(30)
			,FACTORY_ID	            nvarchar(30)
			,PACKAGE_QTY	        numeric(30,3)
			,DOM_EXP	            nvarchar(30)
			,ERP_ATTR1	            nvarchar(150)
			,ERP_ATTR2	            nvarchar(150)
			,ERP_ATTR3	            nvarchar(150)
			,ERP_ATTR4	            nvarchar(150)
			,ERP_ATTR5	            nvarchar(150)

		);



	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_request_no, @v_delimiter);
	WHILE LEN(@p_request_no) > 0 AND @mst_loop_cnt < @max_loop_cnt
	BEGIN
		SET @mst_loop_cnt = @mst_loop_cnt + 1;			

		-- 각 컬럼들에 대한 스플릿처리로직 스타트
		BEGIN
				
			SET @p_request_no						= dbo.SCM_ARR_SPL_VAL( @p_request_no,					@v_delimiter, @mst_loop_cnt );
		END;
	


		IF @p_change_type = 'P' and @p_shipment_status = 'A'
			BEGIN
				-- 전송대상 IFSEQNO, LAST_CONFIRM_DATE, SHIPMENT_STATUS 조회
				 SELECT TOP 1 @IFSEQNO=IFSEQNO,   @LAST_CONFIRM_DATE=LAST_CONFIRM_DATE  ,@SHIPMENT_STATUS=SHIPMENT_STATUS                                
				   FROM dbo.XIF_ERP_SHIP_PLAN_CONFIRM_S_SN A with(nolock)
				  WHERE A.TRANSFER_FLAG	IN ('P','N')
					AND A.SHIPMENT_STATUS = 'A'
					AND A.ATTRIBUTE1 = @p_request_no
				 GROUP BY IFSEQNO, LAST_CONFIRM_DATE, SHIPMENT_STATUS
				 ORDER BY IFSEQNO DESC, LAST_CONFIRM_DATE, SHIPMENT_STATUS
			END
		ELSE IF @p_change_type = 'C'
			BEGIN
				-- 전송대상 IFSEQNO, LAST_CONFIRM_DATE, SHIPMENT_STATUS 조회
				 SELECT TOP 1 @IFSEQNO=IFSEQNO,   @LAST_CONFIRM_DATE=LAST_CONFIRM_DATE  ,@SHIPMENT_STATUS=SHIPMENT_STATUS                                
				   FROM dbo.XIF_ERP_SHIP_PLAN_CONFIRM_S_SN A with(nolock)
				   WHERE A.TRANSFER_FLAG	IN ('P','N')
					--AND A.SHIPMENT_STATUS != 'A'
					AND A.ATTRIBUTE1 = @p_request_no
				 GROUP BY IFSEQNO, LAST_CONFIRM_DATE, SHIPMENT_STATUS
			 
				 /*임시 조치 KIMYONGHO . 2021-03-09
				 동일한 @p_request_no 이면서 TRANSFER_FLAG ='Y'로 변경되지 못한 IFSEQNO 경우
				 신규 IFSEQNO로 인터페이스 하여도 이전 IFSEQNO의 TRANSFER_FLAG ='Y'를 업데이트 하게됨.  
				 따라서 최신 IFSEQNO만 업데이트 하도록 ORDER BY 변경 .*/

				 ORDER BY IFSEQNO DESC, LAST_CONFIRM_DATE, SHIPMENT_STATUS
			 END



		

	
			INSERT INTO @XIF_ERP_SHIP_PLAN_CONFIRM_S
			(    IFSEQNO				       
				,LAST_CONFIRM_DATE     
				,SHIPMENT_STATUS       
				,CONFIRM_ID            
				,VERSION_TYPE          
				,SALES_COMPANY_ID      
				,DIVISION_ID           
				,ITEM_ID               
				,FROM_SITE             
				,TO_SITE               
				,YYYYMMDD              
				,QTY                   
				,OPERATION_GROUP       
				,BIZ_TYPE              
				,PROJECT_CODE          
				,FCST_TYPE             
				,FCST_ETD_DATE         
				,FCST_ETA_DATE         
				,ETD_DATE              
				,ETA_DATE              
				,INCOTERMS             
				,INCOTERMS2            
				,TRANSPORT_MODE        
				,D_COUNTRY             
				,D_PORT_CODE           
				,A_COUNTRY             
				,A_PORT_CODE           
				,CUSTOMER_LT           
				,TO_COUNTRY            
				,TO_CITY               
				,FROM_SITE_TYPE        
				,FROM_SITE_PLANT_ID    
				,FROM_SITE_VENDOR_ID   
				,FROM_SITE_SOLDTO_CODE 
				,FROM_SITE_SHIPTO_CODE 
				,FROM_SITE_COMPANY_ID  
				,TO_SITE_TYPE          
				,TO_SITE_PLANT_ID      
				,TO_SITE_VENDOR_ID     
				,TO_SITE_SOLDTO_CODE   
				,TO_SITE_SHIPTO_CODE   
				,TO_SITE_COMPANY_ID 
				,BUILDING
				,REMARK
				,CUSTOMER_REQ
				,CHANGE_CODE
				,CHANGE_CODE_NAME
				,REQUESTOR
				/*----------------------------------------------------------------------------------------
					2020.06.30 : KBK
					I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
				------------------------------------------------------------------------------------------*/
				,PACKAGE_TYPE
				,FACTORY_ID
				,PACKAGE_QTY
				,DOM_EXP
				,ERP_ATTR1
				,ERP_ATTR2
				,ERP_ATTR3
				,ERP_ATTR4
				,ERP_ATTR5
	   

			)
			SELECT   --TOP 100
				 IFSEQNO				         
				,LAST_CONFIRM_DATE        -- 확정구간 마지막 일자                                      
				,SHIPMENT_STATUS          -- Interface 구분                                            
				,CONFIRM_ID               -- CONFIRM_ID                                                
				,VERSION_TYPE             -- Old / New 구분                                            
				,SALES_COMPANY_ID         -- Sales Company                                             
				,DIVISION_ID              -- DIVISION_ID                                               
				,ITEM_ID                  -- ITEM_ID                                                   
				,FROM_SITE                -- FROM_SITE                                                 
				,TO_SITE                  -- TO_SITE                                                   
				,YYYYMMDD                 -- YYYYMMDD 출하일                                           
				,QTY                      -- QTY 확정수량                                              
				,OPERATION_GROUP          -- OPERATION_GROUP                                           
				,BIZ_TYPE                 -- BIZ_TYPE                                                  
				,PROJECT_CODE             -- PROJECT_CODE                                              
				,FCST_TYPE                -- FCST_TYPE                                                 
				,FCST_ETD_DATE            -- FCST_ETA_DATE 기준 계산된 ETD                             
				,FCST_ETA_DATE            -- MKT FCST에 입력된 ETA                                     
				,ETD_DATE                 -- 확정된 출하일자                                           
				,ETA_DATE                 -- 확정 출하일자로 계산된 ETA                                
				,INCOTERMS                -- INCOTERMS                                                 
				,INCOTERMS2               -- INCOTERMS2                                                
				,TRANSPORT_MODE           -- 운송모드                                                  
				,D_COUNTRY                -- 선적항 국가                                               
				,D_PORT_CODE              -- 선적항 코드                                               
				,A_COUNTRY                -- 도착항 국가                                               
				,A_PORT_CODE              -- 도착항 코드                                               
				,CUSTOMER_LT              -- Total Lead Time                                           
				,TO_COUNTRY               -- 도착지 국가 코드                                          
				,TO_CITY                  -- 도착지 도시 코드                                          
				,FROM_SITE_TYPE           -- FROM SITE TYPE : A: Sales Site, B: Factory Site, C: Packer
				,FROM_SITE_PLANT_ID       -- From Site ERP Plant ID                                    
				,FROM_SITE_VENDOR_ID      -- From Site ERP Vendor ID                                   
				,FROM_SITE_SOLDTO_CODE    -- From Site Sold to code                                    
				,FROM_SITE_SHIPTO_CODE    -- From Site Ship to Code                                    
				,FROM_SITE_COMPANY_ID     -- From Site Company                                         
				,TO_SITE_TYPE             -- A: Sales Site, B: Factory Site, C: Packer                 
				,TO_SITE_PLANT_ID         -- TO SITE TYPE : To Site ERP Plant ID                       
				,TO_SITE_VENDOR_ID        -- To Site ERP Vendor ID                                     
				,TO_SITE_SOLDTO_CODE      -- To Site Sold to code                                      
				,TO_SITE_SHIPTO_CODE      -- To Site Ship to Code                                      
				,TO_SITE_COMPANY_ID       -- To Site Company 
				,BUILDING
				,REMARK
				,CUSTOMER_REQ
				,CHANGE_CODE
				,CHANGE_CODE_NAME
				,REQUESTOR		                                          
				/*----------------------------------------------------------------------------------------
					2020.06.30 : KBK
					I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
				------------------------------------------------------------------------------------------*/
				,PACKAGE_TYPE
				,FACTORY_ID
				,PACKAGE_QTY
				,DOM_EXP
				,ERP_ATTR1
				,ERP_ATTR2
				,ERP_ATTR3
				,ERP_ATTR4
				,ERP_ATTR5
			  FROM dbo.XIF_ERP_SHIP_PLAN_CONFIRM_S_SN A with(nolock)
			  WHERE A.TRANSFER_FLAG	IN ('P','N')
			   AND A.IFSEQNO            = @IFSEQNO
			   --AND A.LAST_CONFIRM_DATE  = @LAST_CONFIRM_DATE
			   --AND A.SHIPMENT_STATUS    = @SHIPMENT_STATUS
			 ORDER BY IFSEQNO, LAST_CONFIRM_DATE, SHIPMENT_STATUS
			 ;

	END;

		 -- 전송대상 PK목록
		 SELECT IFSEQNO
 			   ,LAST_CONFIRM_DATE
			   ,SHIPMENT_STATUS
			   ,CONFIRM_ID
			   ,VERSION_TYPE
		 FROM @XIF_ERP_SHIP_PLAN_CONFIRM_S 

		 -- 전송대상
		SELECT --IFSEQNO				       
			 --LAST_CONFIRM_DATE     
			--,SHIPMENT_STATUS       
			 CONFIRM_ID            
			,VERSION_TYPE          
			,SALES_COMPANY_ID      
			,DIVISION_ID           
			,ITEM_ID               
			,FROM_SITE             
			,TO_SITE               
			,YYYYMMDD              
			,QTY                 
			,OPERATION_GROUP       
			,BIZ_TYPE              
			,PROJECT_CODE          
			,FCST_TYPE             
			,FCST_ETD_DATE         
			,FCST_ETA_DATE         
			,ETD_DATE              
			,ETA_DATE              
			,INCOTERMS             
			,INCOTERMS2            
			,TRANSPORT_MODE        
			,D_COUNTRY             
			,D_PORT_CODE           
			,A_COUNTRY             
			,A_PORT_CODE           
			,CUSTOMER_LT           
			,TO_COUNTRY            
			,TO_CITY               
			,FROM_SITE_TYPE        
			,FROM_SITE_PLANT_ID    
			,FROM_SITE_VENDOR_ID   
			,FROM_SITE_SOLDTO_CODE 
			,FROM_SITE_SHIPTO_CODE 
			,FROM_SITE_COMPANY_ID  
			,TO_SITE_TYPE          
			,TO_SITE_PLANT_ID      
			,TO_SITE_VENDOR_ID     
			,TO_SITE_SOLDTO_CODE   
			,TO_SITE_SHIPTO_CODE   
			,TO_SITE_COMPANY_ID  
			,BUILDING
			,REMARK
			,CUSTOMER_REQ
			,CHANGE_CODE
			,CHANGE_CODE_NAME
			,REQUESTOR		  
			/*----------------------------------------------------------------------------------------
				2020.06.30 : KBK
				I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
			------------------------------------------------------------------------------------------*/
			,PACKAGE_TYPE
			,FACTORY_ID
			,PACKAGE_QTY
			,DOM_EXP
			,ERP_ATTR1
			,ERP_ATTR2
			,ERP_ATTR3
			,ERP_ATTR4
			,ERP_ATTR5
		FROM @XIF_ERP_SHIP_PLAN_CONFIRM_S
		;

	

END

