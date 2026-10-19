


CREATE FUNCTION [dbo].[FN_GET_SSP_ETD_DATE]
(
  @p_division_id    NVARCHAR(30),
  @p_bod_id         NVARCHAR(30),
  @p_yyyymmdd       NVARCHAR(8) -- 도착일 

)

RETURNS NVARCHAR(8)
AS
/*
 * Program ID   : FN_GET_SSP_ETD_DATE
 * Description  : 도착일 기준 항차고려한 ETD DATE 산출
 *        
 *        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.04.17   juhlee         Initial Release [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
                               전극 SITE 출발의 경우 INCORTERMS 조건 없이 순수 ROUTE 기준으로 계산  
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 */
BEGIN
  
	DECLARE @v_etd_date NVARCHAR(8)
  
    DECLARE @v_check INT ;
    DECLARE @v_lt_total INT ;
    DECLARE @v_origin_yn NVARCHAR(1) ;

	-- FROM SITE가 전극일 경우 INCORTERMS 조건 없이 순수 ROUTE 기준으로 계산  
	SELECT @v_check   =  CASE WHEN FS.OPERATION_GROUP = 'E' THEN B.LT_TOTAL_ORIGIN
							ELSE  B.LT_TOTAL END 
						  - 
  						 CASE WHEN FS.OPERATION_GROUP = 'E' THEN B.SHIP_LT_TOTAL_ORIGIN
							ELSE  B.SHIP_LT_TOTAL END  

	,      @v_lt_total = CASE WHEN FS.OPERATION_GROUP = 'E' THEN B.LT_TOTAL_ORIGIN
						 ELSE  B.LT_TOTAL END 
    ,      @v_origin_yn = CASE WHEN FS.OPERATION_GROUP = 'E' THEN 'Y' ELSE 'Y' END  
	FROM   SCP_MST_BOD_N_V B WITH(NOLOCK) 
	   JOIN SCM_MST_SITE  FS WITH(NOLOCK) 
		 ON FS.DIVISION_ID = B.DIVISION_ID 
		AND FS.SCM_SITE_ID = B.FROM_SITE
	WHERE  B.DIVISION_ID = @p_division_id 
	AND    B.BOD_ID      = @p_bod_id
	; 



	IF @v_check = 0  
	
		 BEGIN 
	    
			SET @v_etd_date =  CONVERT(VARCHAR,DATEADD(D, (@v_lt_total)*-1 ,CONVERT(DATETIME,@p_yyyymmdd  ,112)),112) ;

		 END 
    
	ELSE

		BEGIN 

			SELECT   @v_etd_date = MAX(CONVERT(VARCHAR,DATEADD(D, (B.SHIP_LT_TOTAL)*-1  ,CONVERT(DATETIME,C.BASIS_YYYYMMDD  ,112)),112))
			FROM (
					SELECT DIVISION_ID 
					,      BOD_ID
					,      FROM_SITE
					,      TO_SITE 
					,      INCOTERMS
					,      TRANSPORT_MODE 
					,      CASE WHEN @v_origin_yn = 'Y' THEN  LT_TOTAL_ORIGIN      ELSE  LT_TOTAL      END  AS LT_TOTAL    
					,      CASE WHEN @v_origin_yn = 'Y' THEN  SHIP_LT_TOTAL_ORIGIN ELSE  SHIP_LT_TOTAL END  AS SHIP_LT_TOTAL 
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
					AND   BOD_ID  = @p_bod_id 
				)  B 
			JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) 
			  ON B.DAYOFWEEK = C.DAYOFWEEK 
			 AND C.BASIS_YYYYMMDD  >= CONVERT(VARCHAR,DATEADD(D, (B.LT_TOTAL - B.SHIP_LT_TOTAL )*-1 -6 , CONVERT(DATETIME,@p_yyyymmdd ,112)),112)
			 AND C.BASIS_YYYYMMDD  <= CONVERT(VARCHAR,DATEADD(D, (B.LT_TOTAL - B.SHIP_LT_TOTAL )*-1    , CONVERT(DATETIME,@p_yyyymmdd ,112)),112)
			 AND B.EXIST_YN ='Y'
			 ;

		 END 
  

	IF @v_etd_date IS NULL 
   
		BEGIN

			SET @v_etd_date = @p_yyyymmdd ;
     
		END 


	RETURN @v_etd_date;


END



