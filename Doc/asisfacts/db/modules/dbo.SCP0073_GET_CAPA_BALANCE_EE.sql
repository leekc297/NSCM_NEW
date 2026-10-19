
/*      
 * Program ID   : SCP0073_GET_CAPA_BALANCE_EE  
 * Description  : Capa Balance (전극) 리포트용 테이블 
 * Program History      
 *===================================================================================================      
 *   Date	    	In Charge	    Description      
 *===================================================================================================      
 * 2021/08/10  hongju.lee		Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) 
 * 2021/08/19  hongju.lee		조회조건에 scm_site_id추가 
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장

DECLARE	@return_value int

EXEC	@return_value = [dbo].[SCP0073_GET_CAPA_BALANCE_EE]
	    @p_from_yyyymmdd	        = N'20210906',
	    @p_to_yyyymmdd	            = N'20230112',
		@p_division_id = N'EE',
		@p_scm_site_id	 			    = 'G183-E',
		@p_plan_type = N'PR',
		@p_plan_start_yyyymmdd = N'20210906',
		@p_seq = N'1',
		@debug_mode = N'T'


SELECT	'Return Value' = @return_value

GO

 */      
CREATE PROCEDURE [dbo].[SCP0073_GET_CAPA_BALANCE_EE]	
	@p_from_yyyymmdd	        NVARCHAR(8),
	@p_to_yyyymmdd	            NVARCHAR(8),
--chaan	@p_division_id          NVARCHAR(2)
	@p_division_id              NVARCHAR(30),--chaan
	@p_scm_site_id	    			NVARCHAR(MAX)='',
	@p_plan_start_yyyymmdd	NVARCHAR(8),	
	@p_plan_type				    NVARCHAR(50),
	@p_seq						        NVARCHAR(50),
	@p_program_id				    NVARCHAR(MAX) = '',
	@p_sheet_name				NVARCHAR(MAX) = 'Capa Balance',
	@p_user_id					    NVARCHAR(MAX) = '',
	@debug_mode					NVARCHAR(1)   = 'F'
AS      
BEGIN      
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	PRINT 'All Start. '+CONVERT(CHAR(23), GETDATE(), 21)	
	
	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd		  AS NVARCHAR(8)='';
	DECLARE @mQry_field NVARCHAR(MAX);
	DECLARE @mQry_field_yyyymmdd NVARCHAR(MAX);
	DECLARE @MEXEC NVARCHAR(MAX);
	DECLARE @POS INT =1;
	DECLARE @LEN INT =LEN(@mEXEC);
	DECLARE @arr_scm_site_id varchar(max);
		
	SET @mQry_field = '';
	SET @mQry_field_yyyymmdd = '';
	SET @MEXEC = '';
	
	SET @v_from_yyyymmdd = @p_plan_start_yyyymmdd;
	SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(WW, 82, convert(datetime,@p_plan_start_yyyymmdd)), 112);

	SELECT @arr_scm_site_id = ISNULL(@arr_scm_site_id + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_scm_site_id,',')

	SELECT @arr_scm_site_id = @arr_scm_site_id +  ',' + '''Total''';

	PRINT '-------------RESULT SEARCH'
	print CONVERT(CHAR(23), getdate(), 21)

	SELECT TOP 130 @mQry_field = @mQry_field + ',' + COLUMN_NAME 
	         	     ,@mQry_field_yyyymmdd = @mQry_field_yyyymmdd + ',' + COLUMN_NAME + ' AS ' + YYYYMMDD
	FROM(				
			  SELECT 'Y_'+A.CALENDAR_YYYY  AS YYYYMMDD
						,'00'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '00') AS SORT_ORDER_NO   
						,'Y' + FORMAT(ROW_NUMBER()  OVER(ORDER BY (A.CALENDAR_YYYY)) -1 ,'0') AS COLUMN_NAME
				FROM [DBO].[SCM_SYS_CALENDAR_M] A       
	  		  WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd        
			  GROUP BY A.CALENDAR_YYYY 
			  UNION ALL
			  SELECT TOP 7 'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD
						,'01'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO      
						,'Q' + FORMAT(ROW_NUMBER()  OVER(ORDER BY (A.CALENDAR_YYYYQQ )) -1 ,'0') AS COLUMN_NAME
				FROM [DBO].[SCM_SYS_CALENDAR_M] A       
			  WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd      
			  GROUP BY A.CALENDAR_YYYYQQ 
			   UNION ALL
			   SELECT TOP 20 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
						  ,'02'+MIN(a.basis_start_date) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO
						  ,'M' + FORMAT(ROW_NUMBER()  OVER(ORDER BY (A.BASIS_YYYYMM)) -1 ,'0') AS COLUMN_NAME
				FROM [dbo].[scm_sys_calendar_m] a
			 WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)        
			  GROUP BY a.basis_yyyymm, a.month_name
			  UNION ALL
			   SELECT TOP 100 'W_'+A.BASIS_YYYYMM + A.ISO_WEEK AS yyyymmdd            
			     		 ,'03'+A.BASIS_START_DATE + CONVERT(CHAR(2), '03') AS SORT_ORDER_NO      
						 ,'W' + FORMAT(ROW_NUMBER()  OVER(ORDER BY (BASIS_START_DATE)) -1 ,'0') AS COLUMN_NAME
				FROM [DBO].[SCM_SYS_CALENDAR_M] A       
				WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)        
				GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE      
			) A
	ORDER BY SORT_ORDER_NO ;

	PRINT SUBSTRING(@mQry_field_yyyymmdd,1,4000);

	
	SET @MEXEC = @MEXEC+'SELECT A.DIVISION_ID,							' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.PLAN_START_YYYYMMDD,			' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.PLAN_TYPE,								' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.SEQ,										' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.SCM_SITE_ID,                         ' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.SCM_SITE_NAME,                    ' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.ELECTRODE_TYPE,   				' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.MEASURE        ,						' + CHAR(10);
	SET @MEXEC = @MEXEC+'		   	   A.MEASURE_LABEL,					' + CHAR(10); 
	SET @MEXEC = @MEXEC+'		   	   M.ATTRIBUTE3 AS MEASURE_COLOR,	' + CHAR(10); 
	SET @MEXEC = @MEXEC+'			   A.SORT_ORDER_NO,					' + CHAR(10); 
	SET @MEXEC = @MEXEC+'	 IIF(A.SCM_SITE_ID = ''Total'', ''00'', A.SCM_SITE_ID) AS SITE_ORDER ' + CHAR(10); 
	SET @MEXEC = @MEXEC+'			 '+@mQry_field_yyyymmdd		   	  + CHAR(10);
	SET @MEXEC = @MEXEC+'	FROM (                                                          ' + CHAR(10);
	SET @MEXEC = @MEXEC+'				SELECT DIVISION_ID,					    ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							PLAN_START_YYYYMMDD,       ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							PLAN_TYPE,                           ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							SEQ,										' + CHAR(10);
	SET @MEXEC = @MEXEC+'							SCM_SITE_ID,						' + CHAR(10);
	SET @MEXEC = @MEXEC+'							SCM_SITE_NAME,                  ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							ELECTRODE_TYPE,                ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							MEASURE          ,                  ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							MEASURE_LABEL,                 ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							SORT_ORDER_NO,                 ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							SUM(Y0)  Y0 ,	 SUM(Y1)  Y1,	   SUM(Y2) Y2,	                                                                                                         ' + CHAR(10);
	SET @MEXEC = @MEXEC+'						    SUM(Q0) Q0 ,	 SUM(Q1) Q1,	   SUM(Q2) Q2,     SUM(Q3) Q3,       SUM(Q4) Q4,        SUM(Q5) Q5,      SUM(Q6) Q6,    ' + CHAR(10);
	SET @MEXEC = @MEXEC+'						    SUM(M0) M0 ,	 SUM(M1) M1,	   SUM(M2) M2,     SUM(M3) M3,       SUM(M4) M4,       SUM(M5) M5,      SUM(M6) M6,    ' + CHAR(10);
	SET @MEXEC = @MEXEC+'						    SUM(M7) M7 ,	 SUM(M8) M8,	   SUM(M9) M9,     SUM(M10) M10,    SUM(M11) M11,   SUM(M12) M12,  SUM(M13) M13, ' + CHAR(10);
	SET @MEXEC = @MEXEC+'						    SUM(M14) M14 ,  SUM(M15) M15,  SUM(M16) M16,  SUM(M17) M17,   SUM(M18) M18,  SUM(M19) M19,                   								 ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W0)  W0  ,  SUM(W1)  W1 ,  SUM(W2)  W2  ,  SUM(W3)  W3 , SUM(W4)  W4  ,  SUM(W5)  W5 ,  SUM(W5)  W6 ,       ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W7)  W7  ,  SUM(W8)  W8 ,  SUM(W9)  W9  ,  SUM(W10) W10, SUM(W11) W11 ,  SUM(W12) W12,  SUM(W13) W13,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W14) W14 ,  SUM(W15) W15,  SUM(W16) W16 ,  SUM(W17) W17, SUM(W18) W18 ,  SUM(W19) W19,  SUM(W20) W20,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W21) W21 ,  SUM(W22) W22,  SUM(W23) W23 ,  SUM(W24) W24, SUM(W25) W25 ,  SUM(W26) W26,  SUM(W27) W27,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W28) W28 ,  SUM(W29) W29,  SUM(W30) W30 ,  SUM(W31) W31, SUM(W32) W32 ,  SUM(W33) W33,  SUM(W34) W34,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W35) W35 ,  SUM(W36) W36,  SUM(W37) W37 ,  SUM(W38) W38, SUM(W39) W39 ,  SUM(W40) W40,  SUM(W41) W41,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W42) W42 ,  SUM(W43) W43,  SUM(W44) W44 ,  SUM(W45) W45, SUM(W46) W46 ,  SUM(W47) W47,  SUM(W48) W48,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W49) W49 ,  SUM(W50) W50,  SUM(W51) W51 ,  SUM(W52) W52, SUM(W53) W53 ,  SUM(W54) W54,  SUM(W55) W55,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W56) W56 ,  SUM(W57) W57,  SUM(W58) W58 ,  SUM(W59) W59, SUM(W60) W60 ,  SUM(W61) W61,  SUM(W62) W62,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W63) W63 ,  SUM(W64) W64,  SUM(W65) W65 ,  SUM(W66) W66, SUM(W67) W67 ,  SUM(W68) W68,  SUM(W69) W69,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W70) W70 ,  SUM(W71) W71,  SUM(W72) W72 ,  SUM(W73) W73, SUM(W74) W74 ,  SUM(W75) W75,  SUM(W76) W76,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W77) W77 ,  SUM(W78) W78,  SUM(W79) W79 ,  SUM(W80) W80, SUM(W81) W81 ,  SUM(W82) W82,  SUM(W83) W83,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W84) W84 ,  SUM(W85) W85,  SUM(W86) W86 ,  SUM(W85) W87, SUM(W88) W88 ,  SUM(W89) W89,  SUM(W90) W90,  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'						    SUM(W91) W91 ,  SUM(W92) W92,  SUM(W93) W93 ,  SUM(W94) W94, SUM(W95) W95 ,  SUM(W96) W96,  SUM(W97) W97,  ' + CHAR(10);
	SET @MEXEC = @MEXEC+'						    SUM(W98) W98 ,  SUM(W99) W99                                                   ' + CHAR(10);
	SET @MEXEC = @MEXEC+'					FROM SCP_ANL_CAPA_BALANCE_REPORT_EE                                            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'					WHERE DIVISION_ID = ''' + @p_division_id + '''                                        ' +  CHAR(10);
	SET @MEXEC = @MEXEC+'							AND PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd  + '''  '+  CHAR(10);
	SET @MEXEC = @MEXEC+'							AND PLAN_TYPE = ''' + @p_plan_type +'''                                          ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							AND SEQ = ''' + @p_seq +'''                                                              ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							AND SCM_SITE_NAME IS NOT NULL												   ' + CHAR(10);
	IF NOT(@p_scm_site_id IS NULL	OR  @p_scm_site_id	='') BEGIN SET @mEXEC = @mEXEC+'   	AND isnull(NULLIF(SCM_SITE_ID, '''') , ''-'')     IN ('+@arr_scm_site_id+') 			'+CHAR(10); END;
    SET @MEXEC = @MEXEC+'							GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD,PLAN_TYPE, SEQ, SCM_SITE_ID, SCM_SITE_NAME, ELECTRODE_TYPE, MEASURE,MEASURE_LABEL, SORT_ORDER_NO        ' + CHAR(10);
	SET @MEXEC = @MEXEC+'	        )  A  ' + CHAR(10);
	SET @MEXEC = @MEXEC+'	       LEFT JOIN SCM_MST_SHEET_MEASURE M ON A.MEASURE = M.COLUMN_NAME AND M.PROGRAM_ID=''SCP0073'' AND M.VALID_YN=''Y''  ' + CHAR(10);
	SET @MEXEC = @MEXEC+'	     ORDER BY SITE_ORDER, SCM_SITE_NAME, ELECTRODE_TYPE, SORT_ORDER_NO  ' + CHAR(10);
	
	IF( @debug_mode ='T')
	BEGIN				
		SET @POS =1;
		SET @LEN =LEN(@MEXEC);
		WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@MEXEC,@POS,4000);
				SET @POS = @POS+4000;
			END;
	END;
	
	EXEC (@mEXEC);
	
END 
