


CREATE FUNCTION [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE]
(
  @p_division_id    NVARCHAR(30),
  @p_bod_id         NVARCHAR(30),
  @p_yyyymmdd       NVARCHAR(8) -- 출하일 

)

RETURNS NVARCHAR(8)
AS
/*
 * Program ID   : FN_GET_SSP_EXPECTED_SHIP_DATE
 * Description  : 출하일 기준 항차고려한 출항예정일    
 *        
 *        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.10.29   juhlee         Initial Release [CRS?] 
 * 2021.01.19   KIMBK          FN_GET_SSP_ETA_DATE 의 전극 처리 로직과 동일하게 변경
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 */
BEGIN
  
	DECLARE @v_expected_ship_date NVARCHAR(8)
  
    DECLARE @v_check INT ;
    DECLARE @v_lt_total INT ;

    --SELECT @v_check = LT_TOTAL - SHIP_LT_TOTAL
	--,      @v_lt_total =  LT_TOTAL 
	--FROM   SCP_MST_BOD_N_V WITH(NOLOCK) 
	--WHERE  DIVISION_ID = @p_division_id 
	--AND    BOD_ID = @p_bod_id 
	--; 

    SELECT @v_check = LT_TOTAL_ORIGIN - SHIP_LT_TOTAL_ORIGIN
	,      @v_lt_total =  LT_TOTAL_SSP 
	FROM   SCP_MST_BOD_N_V WITH(NOLOCK) 
	WHERE  DIVISION_ID = @p_division_id 
	AND    BOD_ID = @p_bod_id 
	; 

	IF @v_check = 0  
	
		 BEGIN 
	    
			SET @v_expected_ship_date =  CONVERT(VARCHAR,DATEADD(D, @v_lt_total ,CONVERT(DATETIME,@p_yyyymmdd  ,112)),112) ;

		 END 
    
	ELSE

		BEGIN 

			SELECT   @v_expected_ship_date = MIN(C.BASIS_YYYYMMDD)
			FROM (
					SELECT DIVISION_ID 
					,      BOD_ID
					,      FROM_SITE
					,      TO_SITE 
					,      INCOTERMS
					,      TRANSPORT_MODE 
					,      LT_TOTAL
					,      SHIP_LT_TOTAL
					,      CASE WHEN DAYOFWEEK = 'days_mon' THEN 'MON'
								WHEN DAYOFWEEK = 'days_tue' THEN 'TUE'
								WHEN DAYOFWEEK = 'days_wed' THEN 'WED'
								WHEN DAYOFWEEK = 'days_thu' THEN 'THU'
								WHEN DAYOFWEEK = 'days_fri' THEN 'FRI'
								WHEN DAYOFWEEK = 'days_sat' THEN 'SAT'
								WHEN DAYOFWEEK = 'days_sun' THEN 'SUN'
						   ELSE ''END AS DAYOFWEEK
					,      EXIST_YN  
					FROM SCP_MST_BOD_N_V WITH(NOLOCK) 
						 UNPIVOT (EXIST_YN FOR DAYOFWEEK 
											IN (DAYS_MON,DAYS_TUE,DAYS_WED,DAYS_THU,DAYS_FRI,DAYS_SAT,DAYS_SUN)
								 ) AS UNPVT
					WHERE DIVISION_ID = @p_division_id
					AND   BOD_ID      = @p_bod_id 
				)  B 
			JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) 
			  ON B.DAYOFWEEK = C.DAYOFWEEK 
			 AND C.BASIS_YYYYMMDD >= CONVERT(VARCHAR,DATEADD(D, B.SHIP_LT_TOTAL  ,   CONVERT(DATETIME,@p_yyyymmdd ,112)),112)   -- YYYYMMDD + SHIP_LT_TOTAL 
			 AND C.BASIS_YYYYMMDD <= CONVERT(VARCHAR,DATEADD(D, B.SHIP_LT_TOTAL + 6 ,CONVERT(DATETIME,@p_yyyymmdd ,112)),112) -- YYYYMMDD + SHIP_LT_TOTAL + 7 
			 AND B.EXIST_YN ='Y'
			 ;

		 END 
  

	IF @v_expected_ship_date IS NULL 
   
		BEGIN

			SET @v_expected_ship_date = @p_yyyymmdd ;
     
		END 


	RETURN @v_expected_ship_date;


END
