
/*
 * Program ID   : PR_SSP_XIF_ERP_UI_SHIP_PLAN_PR_REQUEST
 * Description  : UI에서 PR 요청
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/09	KIMYONGHO      신규추가
 */

create PROCEDURE [dbo].[PR_SSP_XIF_ERP_UI_SHIP_PLAN_PR_REQUEST] 
	@p_request_no			NVARCHAR(MAX)
	,@p_change_type			NVARCHAR(MAX) = 'C'
	,@p_shipment_status		NVARCHAR(MAX) = 'D'
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE  @IFSEQNO				nvarchar(14 );

	IF @p_change_type = 'P' and @p_shipment_status = 'A'
		BEGIN
			-- 전송대상 IFSEQNO 조회
			 SELECT TOP 1 @IFSEQNO=IFSEQNO
			   FROM dbo.XIF_ERP_PR_REQ_S_SN A with(nolock)
			  WHERE A.IF_FLAG	='N'
				AND A.IFSEQNO = @p_request_no
			 GROUP BY IFSEQNO
			 ORDER BY IFSEQNO DESC
		END
	ELSE IF @p_change_type = 'C'
		BEGIN
			-- 전송대상 IFSEQNO 조회
			 SELECT TOP 1 @IFSEQNO=IFSEQNO
			   FROM dbo.XIF_ERP_PR_REQ_S_SN A with(nolock)
			  WHERE A.IF_FLAG	='N'
				AND A.IFSEQNO = @p_request_no
			 GROUP BY IFSEQNO
			 ORDER BY IFSEQNO DESC
		 END
	DECLARE @XIF_ERP_PR_REQ_S TABLE
	(
		IF_SEQ					nvarchar(50)
		,IF_TYPE				nvarchar(1)
		,IF_ID					nvarchar(50)
		,IFSEQNO				nvarchar(14) 
		,DM_REQ_NO				nvarchar(50)
		,PR_NO					nvarchar(50)
		,PR_ITEM_SEQ            int
		,PR_ITEM_ID				nvarchar(100)
		,ERP_PR_STATUS			nvarchar(2)
		,ERP_PR_MESSAGE         nvarchar(MAX)
		,SLOC_ID                nvarchar(120)
		,SLOC_PLANT_ID          nvarchar(120)
		,PR_HEADER              nvarchar(MAX)
		,PR_ITEM_DETAIL         nvarchar(MAX)
		,YYYYMMDD               nvarchar(16)  
		,PR_REQ_QTY				numeric(20,10)
		,UOM					nvarchar(16)
		,PROJECT_CODE           nvarchar(100)
		,PUCH_MGR               nvarchar(300)
		,PUCH_GROUP				nvarchar(300 )
		,DM_REQUESTED_BY        nvarchar(50)
		,PR_CONFIRM_DATE        nvarchar(8)
		,ATTRIBUTE1             nvarchar(150)
		,ATTRIBUTE2             nvarchar(150)
		,ATTRIBUTE3             nvarchar(150)
		,ATTRIBUTE4				nvarchar(150)
		,ATTRIBUTE5             nvarchar(150)
		,ATTRIBUTE6				nvarchar(150)
		,ATTRIBUTE7             nvarchar(150)
		,ATTRIBUTE8             nvarchar(150)
		,ATTRIBUTE9				nvarchar(150)
		,ATTRIBUTE10            nvarchar(150)
	);

	
	INSERT INTO @XIF_ERP_PR_REQ_S
	(   
		IF_SEQ
		,IF_TYPE
		,IF_ID
		,IFSEQNO		
		,DM_REQ_NO		
		,PR_NO			
		,PR_ITEM_SEQ    
		,PR_ITEM_ID		
		,ERP_PR_STATUS	
		,ERP_PR_MESSAGE 
		,SLOC_ID        
		,SLOC_PLANT_ID  
		,PR_HEADER      
		,PR_ITEM_DETAIL 
		,YYYYMMDD       
		,PR_REQ_QTY		
		,UOM			
		,PROJECT_CODE   
		,PUCH_MGR       
		,PUCH_GROUP		
		,DM_REQUESTED_BY
		,PR_CONFIRM_DATE
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
	SELECT   TOP 100
			 IF_SEQ
			,IF_TYPE
			,IF_ID
	-----------------------------------
			,IFSEQNO		
			,DM_REQ_NO		
			,PR_NO			
			,ATTRIBUTE1 AS PR_ITEM_SEQ    
			,PR_ITEM_ID		
			,ERP_PR_STATUS	
			,ERP_PR_MESSAGE 
			,SLOC_ID        
			,SLOC_PLANT_ID  
			,PR_HEADER      
			,PR_ITEM_DETAIL 
			,YYYYMMDD       
			,CEILING(PR_REQ_QTY)
			,UOM			
			,PROJECT_CODE   
			,PUCH_MGR       
			,PUCH_GROUP		
			,DM_REQUESTED_BY
			,PR_CONFIRM_DATE
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
	  FROM dbo.XIF_ERP_PR_REQ_S_SN A with(nolock)
	 WHERE A.IF_FLAG	 = 'N'
	   AND A.IFSEQNO     = @IFSEQNO
	 ORDER BY IFSEQNO, DM_REQ_NO, PR_ITEM_SEQ ASC
	 ;

	 -- 전송대상 PK목록
	 SELECT DISTINCT IFSEQNO
	 FROM @XIF_ERP_PR_REQ_S

	 -- 전송대상
	SELECT 
		IF_SEQ						AS IF_SEQ
		, IF_TYPE				    AS IF_TYPE
		, IF_ID						AS IF_ID
		, CONVERT(VARCHAR(8), CONVERT(DATETIME, GETDATE()), 112) AS IF_INS_DATE
		, 'Y' AS IF_FLAG
		, CONVERT(VARCHAR(8), CONVERT(DATETIME, GETDATE()), 112) AS IF_SND_DATE
		--, CONVERT(VARCHAR(8), CONVERT(DATETIME, GETDATE()), 112) AS IF_RCV_DATE
		--, '-' AS PROC_FLAG
		--, CONVERT(VARCHAR(8), CONVERT(DATETIME, GETDATE()), 112) AS PROC_DATE
		--, '-' AS PROC_MSG
	------------------------------------------------
		,IFSEQNO		
		,DM_REQ_NO		
		,PR_NO		
		,PR_ITEM_SEQ
		--,CONCAT(ROW_NUMBER() OVER(PARTITION BY DM_REQ_NO ORDER BY PR_ITEM_ID), '0') AS PR_ITEM_SEQ    
		,PR_ITEM_ID		
		,ERP_PR_STATUS	
		,ERP_PR_MESSAGE 
		,SLOC_ID        
		,SLOC_PLANT_ID  
		,PR_HEADER      
		,PR_ITEM_DETAIL 
		,YYYYMMDD       
		,PR_REQ_QTY		
		,UOM			
		,PROJECT_CODE   
		,PUCH_MGR       
		,PUCH_GROUP		
		,DM_REQUESTED_BY
		,PR_CONFIRM_DATE
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
    FROM @XIF_ERP_PR_REQ_S
	;

END

