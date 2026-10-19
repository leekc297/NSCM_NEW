


CREATE FUNCTION [dbo].[FN_GET_SSP_ETA_DATE]
(
  @p_division_id    NVARCHAR(30),
  @p_bod_id         NVARCHAR(30),
  @p_yyyymmdd       NVARCHAR(8) -- 출하일 

)

RETURNS NVARCHAR(8)
AS
/*
 * Program ID   : FN_GET_SSP_ETA_DATE
 * Description  : 출하일 기준 항차고려한 ETA DATE 산출   
 *        
 *        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.10.29   juhlee         Initial Release [PJ20189106] 전지.GSCM 고도화 이행 
 * 2020.04.17   juhlee         [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
                                            전극 SITE 출발의 경우 INCORTERMS 조건 없이 순수 ROUTE 기준으로 계산될수 있게 수정
 * 2021.01.19   KIMBK          전극 처리 로직과 동일하게 변경
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 */
BEGIN
  
	DECLARE @v_eta_date NVARCHAR(8)
	DECLARE @v_eta_date_org NVARCHAR(8)
  
    DECLARE @v_check INT ;
    DECLARE @v_lt_total INT ;
    DECLARE @v_origin_yn NVARCHAR(1) ;
    DECLARE @v_operation_group NVARCHAR(3) ;
    DECLARE @v_segment3 NVARCHAR(3) ;


	---- FROM SITE가 전극일 경우 INCORTERMS 조건 없이 순수 ROUTE 기준으로 계산  
	--SELECT @v_check   =  CASE WHEN FS.OPERATION_GROUP = 'E' THEN B.LT_TOTAL_ORIGIN
	--						ELSE  B.LT_TOTAL END 
	--					  - 
 -- 						 CASE WHEN FS.OPERATION_GROUP = 'E' THEN B.SHIP_LT_TOTAL_ORIGIN
	--						ELSE  B.SHIP_LT_TOTAL END  

	--,      @v_lt_total = CASE WHEN FS.OPERATION_GROUP = 'E' THEN B.LT_TOTAL_ORIGIN
	--					 ELSE  B.LT_TOTAL END 
 --   ,      @v_origin_yn = CASE WHEN FS.OPERATION_GROUP = 'E' THEN 'Y' ELSE 'Y' END  
	--FROM   SCP_MST_BOD_N_V B WITH(NOLOCK) 
	--   JOIN SCM_MST_SITE  FS WITH(NOLOCK) 
	--	 ON FS.DIVISION_ID = B.DIVISION_ID 
	--	AND FS.SCM_SITE_ID = B.FROM_SITE
	--WHERE  B.DIVISION_ID = @p_division_id 
	--AND    B.BOD_ID      = @p_bod_id
	--; 

	SELECT @v_check   =  CASE WHEN FS.OPERATION_GROUP = 'E' THEN B.LT_TOTAL_ORIGIN
							ELSE  B.LT_TOTAL_ORIGIN END 
						  - 
  						 CASE WHEN FS.OPERATION_GROUP = 'E' THEN B.SHIP_LT_TOTAL_ORIGIN
							ELSE  B.SHIP_LT_TOTAL_ORIGIN END  

	,      @v_lt_total = CASE WHEN FS.OPERATION_GROUP = 'E' THEN B.LT_TOTAL_ORIGIN
						 ELSE  B.LT_TOTAL END 
    ,      @v_origin_yn = CASE WHEN FS.OPERATION_GROUP = 'E' THEN 'Y' ELSE 'N' END  
	-- ETA 계산을 위한 LT CONDITION 정보 및 OPERATION GROUP 정보 추가
	,      @v_operation_group = FS.OPERATION_GROUP
	,      @v_segment3 = C.SEGMENT3
	FROM   SCP_MST_BOD_N_V B WITH(NOLOCK) 
	   JOIN SCM_MST_SITE  FS WITH(NOLOCK) 
		 ON FS.DIVISION_ID = B.DIVISION_ID 
		AND FS.SCM_SITE_ID = B.FROM_SITE

		JOIN   SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
		ON  C.LOOKUP_TYPE = 'INCOTERMS'  
		AND B.SSP_INCOTERMS = C.SEGMENT1

	WHERE  B.DIVISION_ID = @p_division_id 
	AND    B.BOD_ID      = @p_bod_id
	; 


	IF @v_check = 0  
	
		 BEGIN 
	    
			SET @v_eta_date =  CONVERT(VARCHAR,DATEADD(D, @v_lt_total ,CONVERT(DATETIME,@p_yyyymmdd  ,112)),112) ;

		 END 
    
	ELSE

		BEGIN 

			--SELECT   @v_eta_date = MIN(CONVERT(VARCHAR,DATEADD(D, B.LT_TOTAL - B.SHIP_LT_TOTAL  ,CONVERT(DATETIME,C.BASIS_YYYYMMDD  ,112)),112))
			--FROM (
			--		SELECT DIVISION_ID 
			--		,      BOD_ID
			--		,      FROM_SITE
			--		,      TO_SITE 
			--		,      INCOTERMS
			--		,      TRANSPORT_MODE 
			--		,      CASE WHEN @v_origin_yn = 'Y' THEN  LT_TOTAL_ORIGIN      ELSE  LT_TOTAL      END  AS LT_TOTAL    
			--		,      CASE WHEN @v_origin_yn = 'Y' THEN  SHIP_LT_TOTAL_ORIGIN ELSE  SHIP_LT_TOTAL END  AS SHIP_LT_TOTAL 
			--		,      CASE WHEN DAYOFWEEK = 'days_mon' THEN 'MON'
			--					WHEN DAYOFWEEK = 'days_tue' THEN 'TUE'
			--					WHEN DAYOFWEEK = 'days_wed' THEN 'WED'
			--					WHEN DAYOFWEEK = 'days_thu' THEN 'THU'
			--					WHEN DAYOFWEEK = 'days_fri' THEN 'FRI'
			--					WHEN DAYOFWEEK = 'days_sat' THEN 'SAT'
			--					WHEN DAYOFWEEK = 'days_sun' THEN 'SUN'
			--			   ELSE ''END AS DAYOFWEEK
			--		,      EXIST_YN  
			--		FROM SCP_MST_BOD_N_V WITH(NOLOCK) 
			--			 UNPIVOT (EXIST_YN FOR DAYOFWEEK 
			--								IN (DAYS_MON,DAYS_TUE,DAYS_WED,DAYS_THU,DAYS_FRI,DAYS_SAT,DAYS_SUN)
			--					 ) AS UNPVT
			--		WHERE DIVISION_ID = @p_division_id
			--		AND   BOD_ID  = @p_bod_id 
			--	)  B 
			--JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) 
			--  ON B.DAYOFWEEK = C.DAYOFWEEK 
			-- AND C.BASIS_YYYYMMDD >= CONVERT(VARCHAR,DATEADD(D, B.SHIP_LT_TOTAL  ,   CONVERT(DATETIME,@p_yyyymmdd ,112)),112)   -- YYYYMMDD + SHIP_LT_TOTAL 
			-- AND C.BASIS_YYYYMMDD <= CONVERT(VARCHAR,DATEADD(D, B.SHIP_LT_TOTAL + 6 ,CONVERT(DATETIME,@p_yyyymmdd ,112)),112) -- YYYYMMDD + SHIP_LT_TOTAL + 7 
			-- AND B.EXIST_YN ='Y'
			-- ;

			SET @v_eta_date_org =  CONVERT(VARCHAR,DATEADD(D, @v_lt_total - @v_check ,CONVERT(DATETIME,@p_yyyymmdd  ,112)),112) ;

			SELECT   @v_eta_date = CASE WHEN @v_operation_group = 'E' THEN MIN(CONVERT(VARCHAR,DATEADD(D, LT_TOTAL - SHIP_LT_TOTAL, CONVERT(DATETIME,C.BASIS_YYYYMMDD  ,112)),112))
			                       ELSE 
								        CASE WHEN @v_segment3 <> 'F' THEN MIN(CONVERT(VARCHAR,DATEADD(D, 0  ,CONVERT(DATETIME,C.BASIS_YYYYMMDD  ,112)),112)) 
										ELSE 
										     CASE WHEN @v_eta_date_org = MIN(CONVERT(VARCHAR,DATEADD(D, 0  ,CONVERT(DATETIME,C.BASIS_YYYYMMDD  ,112)),112)) THEN 
										         MIN(CONVERT(VARCHAR,DATEADD(D, ( CASE WHEN LT_TOTAL - SHIP_LT_TOTAL = 0 THEN 0 ELSE (LT_TOTAL - SHIP_LT_TOTAL) END ), CONVERT(DATETIME,C.BASIS_YYYYMMDD  ,112)),112))
											 ELSE
										         MIN(CONVERT(VARCHAR,DATEADD(D, ( CASE WHEN LT_TOTAL - SHIP_LT_TOTAL = 0 THEN 0 ELSE (LT_TOTAL - SHIP_LT_TOTAL)-1 END ), CONVERT(DATETIME,C.BASIS_YYYYMMDD  ,112)),112))
											 END
										END
								   END
			FROM (
					SELECT DIVISION_ID 
					,      BOD_ID
					,      FROM_SITE
					,      TO_SITE 
					,      INCOTERMS
					,      TRANSPORT_MODE 
					,      CASE WHEN @v_origin_yn = 'Y' THEN  LT_TOTAL_ORIGIN      ELSE  LT_TOTAL_SSP      END  AS LT_TOTAL    
					,      CASE WHEN @v_origin_yn = 'Y' THEN  SHIP_LT_TOTAL_ORIGIN ELSE  SHIP_LT_TOTAL_SSP END  AS SHIP_LT_TOTAL 
					,      CASE WHEN DAYOFWEEK = 'days_mon' THEN 'MON'
								WHEN DAYOFWEEK = 'days_tue' THEN 'TUE'
								WHEN DAYOFWEEK = 'days_wed' THEN 'WED'
								WHEN DAYOFWEEK = 'days_thu' THEN 'THU'
								WHEN DAYOFWEEK = 'days_fri' THEN 'FRI'
								WHEN DAYOFWEEK = 'days_sat' THEN 'SAT'
								WHEN DAYOFWEEK = 'days_sun' THEN 'SUN'
						   ELSE ''END AS DAYOFWEEK
					,      EXIST_YN  
					FROM SCP_MST_BOD_N_V  WITH(NOLOCK) 

						 UNPIVOT (EXIST_YN FOR DAYOFWEEK 
											IN (DAYS_MON,DAYS_TUE,DAYS_WED,DAYS_THU,DAYS_FRI,DAYS_SAT,DAYS_SUN)
								 ) AS UNPVT
					WHERE DIVISION_ID = @p_division_id
					AND   BOD_ID  = @p_bod_id 
				)  B 
			JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) 
			  ON B.DAYOFWEEK = C.DAYOFWEEK 
			 AND C.BASIS_YYYYMMDD >= CONVERT(VARCHAR,DATEADD(D, B.SHIP_LT_TOTAL  ,   CONVERT(DATETIME,@p_yyyymmdd ,112)),112)   -- YYYYMMDD + SHIP_LT_TOTAL 
			 AND C.BASIS_YYYYMMDD <= CONVERT(VARCHAR,DATEADD(D, B.SHIP_LT_TOTAL + 6 ,CONVERT(DATETIME,@p_yyyymmdd ,112)),112) -- YYYYMMDD + SHIP_LT_TOTAL + 7 
			 AND B.EXIST_YN ='Y'
		   JOIN SCM_MST_SITE  FS WITH(NOLOCK) 
			 ON FS.DIVISION_ID = B.DIVISION_ID 
			AND FS.SCM_SITE_ID = B.FROM_SITE
			GROUP BY FS.OPERATION_GROUP
			 ;


		 END 
  

	IF @v_eta_date IS NULL 
   
		BEGIN

			SET @v_eta_date = @p_yyyymmdd ;
     
		END 


	RETURN @v_eta_date;


END


