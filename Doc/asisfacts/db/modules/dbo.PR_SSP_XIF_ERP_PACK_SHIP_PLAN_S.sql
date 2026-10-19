



/*
 * Program ID   : PR_SSP_XIF_ERP_PACK_SHIP_PLAN_S
 * Description  : 소형 PACKER 외주출하계획 ERP 전송 (ERP_PACK_SHIP_PLAN)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/10/08   SMS			   최초 작성
 *
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_ERP_PACK_SHIP_PLAN_S]
	@ASYNC_YN      NVARCHAR(50) = 'N'  
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE  @IFSEQNO				nvarchar(50 );

	-- 전송대상 IFSEQNO
	 SELECT TOP 1 @IFSEQNO=IFSEQNO
	   FROM dbo.XIF_ERP_PACK_SHIP_PLAN_S_SN A  with(nolock)
	  WHERE A.IF_FLAG	='N'
     GROUP BY IFSEQNO
	 ORDER BY IFSEQNO

	DECLARE @XIF_ERP_PACK_SHIP_PLAN_S TABLE
	(
		 IF_SEQ					nvarchar(50) 
		,IF_TYPE				nvarchar(1)
		,IF_ID				    nvarchar(50)
		,IF_INS_DATE			nvarchar(50)	--date
		,IF_FLAG				nvarchar(1)
		,IF_SND_DATE			nvarchar(50)	--date
		,IFSEQNO				nvarchar(50)
		,SSP_CNFM				nvarchar(20)
		,PACKER_CODE			nvarchar(30)
		,DIVISION_ID			nvarchar(10)
		,PACK_MODEL_CODE		nvarchar(50)
		,NICK_NAME				nvarchar(150)
		,SALES_SITE				nvarchar(50)
		,SOLD_TO				nvarchar(10)
		,SHIP_TO				nvarchar(10)
		,TRANSPORT_MODE			nvarchar(10)
		,INCOTERMS				nvarchar(10)
		,SHIP_PLAN_DATE			nvarchar(8)
		,SHIP_PLAN_QTY			numeric(11,3)

		,COMMENT				nvarchar(4000)	
		,ORDER_TYPE_DETAIL		nvarchar(4000)

		,ATTRIBUTE1				nvarchar(200)
		,ATTRIBUTE2				nvarchar(200)
		,ATTRIBUTE3				nvarchar(200)
		,ATTRIBUTE4				nvarchar(200)
		,ATTRIBUTE5				nvarchar(200)
		,ATTRIBUTE6				nvarchar(200)
		,ATTRIBUTE7				nvarchar(200)
		,ATTRIBUTE8				nvarchar(200)
		,ATTRIBUTE9				nvarchar(200)
		,ATTRIBUTE10			nvarchar(200)
	);

	INSERT INTO @XIF_ERP_PACK_SHIP_PLAN_S
	(    
		 IF_SEQ					
		,IF_TYPE					
		,IF_ID				    
		,IF_INS_DATE				
		,IF_FLAG					
		,IF_SND_DATE				
		,IFSEQNO				
		,SSP_CNFM				
		,PACKER_CODE				
		,DIVISION_ID				
		,PACK_MODEL_CODE			
		,NICK_NAME				
		,SALES_SITE				
		,SOLD_TO					
		,SHIP_TO					
		,TRANSPORT_MODE			
		,INCOTERMS				
		,SHIP_PLAN_DATE			
		,SHIP_PLAN_QTY			
		,COMMENT				
		,ORDER_TYPE_DETAIL		
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
	SELECT 
		 IF_SEQ					
		,IF_TYPE					
		,IF_ID				    
		,convert(varchar(50), IF_INS_DATE, 21) -- IF_INS_DATE				
		,IF_FLAG					
		,convert(varchar(50), IF_SND_DATE, 21)  --IF_SND_DATE				
		,IFSEQNO				
		,SSP_CNFM				
		,PACKER_CODE				
		,DIVISION_ID				
		,PACK_MODEL_CODE			
		,NICK_NAME				
		,SALES_SITE				
		,SOLD_TO					
		,SHIP_TO					
		,TRANSPORT_MODE			
		,INCOTERMS				
		,SHIP_PLAN_DATE			
		,SHIP_PLAN_QTY			
		,COMMENT				
		,ORDER_TYPE_DETAIL		
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
	  FROM dbo.XIF_ERP_PACK_SHIP_PLAN_S_SN A WITH(NOLOCK)
	 WHERE A.IF_FLAG	    = 'N'
	   AND A.IFSEQNO = @IFSEQNO
	 ORDER BY IF_SEQ
	 ;

	 -- 전송대상 PK목록  
	 SELECT IF_SEQ, SSP_CNFM, IFSEQNO
	 FROM @XIF_ERP_PACK_SHIP_PLAN_S

	 -- 전송대상
	SELECT 
		 IF_SEQ					
		,IF_TYPE					
		,IF_ID				    
		,IF_INS_DATE				
		,IF_FLAG					
		,IF_SND_DATE				
		,IFSEQNO				
		,SSP_CNFM				
		,PACKER_CODE				
		,DIVISION_ID				
		,PACK_MODEL_CODE			
		,NICK_NAME				
		,SALES_SITE				
		,SOLD_TO					
		,SHIP_TO					
		,TRANSPORT_MODE			
		,INCOTERMS				
		,SHIP_PLAN_DATE			
		,SHIP_PLAN_QTY			
		,COMMENT				
		,ORDER_TYPE_DETAIL		
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
    FROM @XIF_ERP_PACK_SHIP_PLAN_S
	;

/*  -- 사용하지 않는것 같음 테스트시 필요하면 살린다.
	    --ASYNC일 경우 IF_FLAG = 'P' 상태 변경 -- 사용하지 않는것 같음
	IF @ASYNC_YN = 'Y'  
	BEGIN
		UPDATE dbo.XIF_ERP_PACK_SHIP_PLAN_S_SN
		   SET IF_FLAG		= 'P'  
		  FROM dbo.XIF_ERP_PACK_SHIP_PLAN_S_SN	    AS A WITH(NOLOCK) 
		       INNER JOIN @XIF_ERP_PACK_SHIP_PLAN_S	AS B
			ON A.IF_SEQ    = B.IF_SEQ  
		   AND A.SSP_CNFM   = B.SSP_CNFM
	END
*/
END




