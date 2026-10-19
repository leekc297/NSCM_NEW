CREATE FUNCTION [dbo].[FN_GET_BOD_LEAD_TIME]
(
 @P_DIVISION_ID        NVARCHAR(30)
,@P_FROM_SITE_CODE     NVARCHAR(30)
,@P_POL_PORT           NVARCHAR(30) --출발항구 
,@P_POD_PORT           NVARCHAR(30) --도착항구
,@P_TO_SITE_CODE       NVARCHAR(30)
,@P_INCOTERMS          NVARCHAR(10)
,@P_TRANSPORT_MODE     NVARCHAR(50)
,@P_CONDITION          NVARCHAR(30)
)

RETURNS DECIMAL(18,3)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_BOD_LEAD_TIME
  * DESCRIPTION   : 사이트간 BOD LEAD TIME(UOM: DAYS)을 리턴한다.
  *                 등록된 BOD가 없으면 -1을 리턴하여, 화면에서 예외처리하도록 할때 활용한다.
  *
  * INPUT         : BOD관리 PK
  *                 CONDITION  구간조건
  *                    - 'TOTAL'(출하~고객도착)=POL(운송)+출하항통관+POD(운송)+도착지통관+도착지운송, 
  *                    - 'POL'(출하~선적항도착),
  *                    - 'POD'(출하~도착항도착까지),
  *                    - 'FDEST'(최종목적지까지)='TOTAL'
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-01-16   YYDOK        INITIAL
  * 2018-01-18   YYDOK        POL,POD PORT 추가고려
  ****************************************************************************/
BEGIN
  
  DECLARE @X_LEAD_TIME   DECIMAL(18,3) =0
   
  SELECT @X_LEAD_TIME = 
         ( CASE @P_CONDITION WHEN 'TOTAL' THEN PERIOD1_LT + POL_CLEARANCE_LT + PERIOD2_LT + POD_CLEARANCE_LT + PERIOD3_LT
                             WHEN 'POL'   THEN PERIOD1_LT 
                             WHEN 'POD'   THEN PERIOD1_LT + POL_CLEARANCE_LT + PERIOD2_LT 
                             WHEN 'POD-POL'   THEN POL_CLEARANCE_LT + PERIOD2_LT 
                             WHEN 'FDEST' THEN PERIOD1_LT + POL_CLEARANCE_LT + PERIOD2_LT + POD_CLEARANCE_LT + PERIOD3_LT
							 WHEN 'FDEST-POD'   THEN POD_CLEARANCE_LT + PERIOD3_LT 
           END )                              
    FROM DBO.SCM_MST_BOD  B WITH(NOLOCK)
   WHERE DIVISION_ID         = @P_DIVISION_ID
     AND FROM_SITE           = @P_FROM_SITE_CODE
     AND TO_SITE             = @P_TO_SITE_CODE
     AND INCOTERMS           = @P_INCOTERMS
     AND TRANSPORT_MODE      = @P_TRANSPORT_MODE
	 AND POL                 = @P_POL_PORT
	 AND POD                 = @P_POD_PORT
	 AND VALID_YN            = 'Y'
  ;  
	
	IF @X_LEAD_TIME IS NULL 
	   BEGIN
	      SET @X_LEAD_TIME = 0
	   END
	
	
  RETURN @X_LEAD_TIME;

END
;
