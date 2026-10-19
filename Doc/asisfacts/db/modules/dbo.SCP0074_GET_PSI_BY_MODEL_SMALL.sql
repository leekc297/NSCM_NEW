
/*      
 * Program ID   : [SCP0074_GET_PSI_BY_MODEL_SMALL]  
 * Description  : MODEL별 PSI (SMALL) 리포트용 테이블 
 * Program History      
 *===================================================================================================      
 *   Date	    	In Charge	    Description      
 *===================================================================================================      
 * 2021/08/24   hongju.lee		Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) 
  * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장

DECLARE	@return_value int

		EXEC	@return_value = [dbo].[SCP0074_GET_PSI_BY_MODEL_SMALL]
		@p_from_yyyymmdd	        = N'20210816',
	    @p_to_yyyymmdd	            = N'20230212',
		@p_division_id = N'40',
		@p_plan_start_yyyymmdd = N'20210816',
		@p_plan_type = N'PR',
		@p_seq = N'1', 
		@p_program_id = N'SCP0071',
		@p_sheet_name = N'Capa RTF Balance',
		@p_user_id = N'leehongju',
		@debug_mode = N'T'

SELECT	'Return Value' = @return_value
GO

 */      
CREATE PROCEDURE [dbo].[SCP0074_GET_PSI_BY_MODEL_SMALL]
	@p_from_yyyymmdd			NVARCHAR(8),
	@p_to_yyyymmdd				NVARCHAR(8),
--chaan	@p_division_id          NVARCHAR(2),
	@p_division_id              NVARCHAR(30),--chaan
	--@p_item_id					    NVARCHAR(MAX) = '',
	--@p_nick_name			    NVARCHAR(MAX) = '',
	--@p_from_site				    NVARCHAR(MAX) = '',
	--@p_to_site					    NVARCHAR(MAX) = '',
	@p_plan_start_yyyymmdd	NVARCHAR(8),
	@p_plan_type				    NVARCHAR(50),
	@p_seq						        NVARCHAR(50),
	@p_program_id				    NVARCHAR(MAX) = '',
	@p_sheet_name				    NVARCHAR(MAX) = 'Capa RTF Balance',
	@p_user_id					    NVARCHAR(MAX) = '',
	@debug_mode					NVARCHAR(1)   = 'F'
AS      
BEGIN      
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	PRINT 'All Start. '+CONVERT(CHAR(23), GETDATE(), 21)
		
	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd		  AS NVARCHAR(8)='';
	DECLARE @v_from_result            AS NVARCHAR(8)='';
	DECLARE @v_to_result                AS NVARCHAR(8)='1111';
	DECLARE @mQry_field NVARCHAR(MAX);
	DECLARE @mQry_field_yyyymmdd NVARCHAR(MAX);
	DECLARE @MEXEC NVARCHAR(MAX);
	DECLARE @POS INT =1;
	DECLARE @LEN INT =LEN(@mEXEC);													
		
	SET @mQry_field = '';
	SET @mQry_field_yyyymmdd = '';
	SET @MEXEC = '';
	SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(WW, 82, convert(datetime,@p_plan_start_yyyymmdd)), 112);


	PRINT '-------------RESULT SEARCH'
	print CONVERT(CHAR(23), getdate(), 21)

	SELECT TOP 25  @mQry_field = @mQry_field + ',' + COLUMN_NAME 
		  , @mQry_field_yyyymmdd = @mQry_field_yyyymmdd + ',' + COLUMN_NAME + ' AS ' + YYYYMM
	FROM(
			SELECT 'M_'+A.BASIS_YYYYMM  AS YYYYMM
					,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
					, 'M' + FORMAT(ROW_NUMBER()  OVER(ORDER BY (basis_yyyymm)) -1 ,'0') AS COLUMN_NAME
			FROM [dbo].[scm_sys_calendar_m] a
			WHERE a.basis_yyyymmdd  BETWEEN @p_plan_start_yyyymmdd AND @v_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.month_name
			UNION
			SELECT 'Y_'+A.CALENDAR_YYYY  AS YYYYMM
			          , 'M' + FORMAT(ROW_NUMBER()  OVER(ORDER BY (CALENDAR_YYYY)) -1 ,'0') AS COLUMN_NAME
					  --, '' AS COLUMN_NAME
				      ,'99' + MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO      
		  	  FROM [DBO].[SCM_SYS_CALENDAR_M] A       
			WHERE A.BASIS_YYYYMMDD  BETWEEN @p_plan_start_yyyymmdd AND @v_to_yyyymmdd
			GROUP BY A.CALENDAR_YYYY  

		) AS A
	ORDER BY SORT_ORDER_NO  ;
	

	SET @MEXEC = @MEXEC+'SELECT A.DIVISION_ID,                      ' + CHAR(10);
	SET @MEXEC = @MEXEC+'            A.MATERIAL_CLASS_NAME,     ' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.TYPE,                                  ' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.MODEL,                               ' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.CELL_ITEM_ID,                    ' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.MEASURE,                           ' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.MEASURE_LABEL,                ' + CHAR(10);
	SET @MEXEC = @MEXEC+'		   	   A.MEASURE_COLOR,               ' + CHAR(10); 
	SET @MEXEC = @MEXEC+'			   A.SORT_ORDER_NO                ' + CHAR(10); 
	SET @MEXEC = @MEXEC+'			 '+@mQry_field_yyyymmdd          + CHAR(10);
	SET @MEXEC = @MEXEC+'	FROM (                                                            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'             SELECT DIVISION_ID,				    	   ' + CHAR(10);
	SET @MEXEC = @MEXEC+'				            MATERIAL_CLASS_NAME,          ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							TYPE,                                      ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							NICK_NAME AS MODEL,            ' + CHAR(10);		
	SET @MEXEC = @MEXEC+'							ATTRIBUTE1 AS CELL_ITEM_ID, ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							MEASURE,                                ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							MEASURE_LABEL,                     ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							MEASURE_COLOR,                    ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							CASE WHEN MEASURE = ''SHIP_PLAN'' THEN 4                 ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							         WHEN MEASURE = ''SHIP_REQ''  THEN 5                 ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							         ELSE SORT_ORDER_NO                                                                                                        ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							END AS SORT_ORDER_NO,                                                                                                            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							SUM(M0) M0 ,    SUM(M1) M1,  SUM(M2) M2,	 SUM(M3) M3,    SUM(M4) M4 ,  SUM(M5) M5 ,            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'						    SUM(M6) M6 ,    SUM(M7) M7,	  SUM(M8) M8,    SUM(M9) M9,    SUM(M10) M10,  SUM(M11) M11,      ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							SUM(M12) M12, SUM(M13) M13, SUM(M14) M14, SUM(M15) M15,SUM(M16) M16, SUM(M17) M17,     ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							SUM(M18) M18, SUM(M19) M19, SUM(M20) M20,SUM(M21) M21, SUM(M22) M22, SUM(M23) M23, SUM(M24) M24 ' + CHAR(10);
	SET @MEXEC = @MEXEC+'					FROM SCP_ANL_CAPA_BALANCE_REPORT_SMALL                                                  ' + CHAR(10);
	SET @MEXEC = @MEXEC+'					WHERE DIVISION_ID = ''' + @p_division_id + '''                                        ' +  CHAR(10);
	SET @MEXEC = @MEXEC+'							AND PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd  + '''  '+  CHAR(10);
	SET @MEXEC = @MEXEC+'							AND PLAN_TYPE = ''' + @p_plan_type +'''                                          ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							AND SEQ = ''' + @p_seq +'''                                                              ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							AND MEASURE IN (''MKT_FCST'', ''ALLOCATION'', ''BALANCE'', ''SHIP_REQ'', ''SHIP_PLAN'', ''PRODUCTION'',''INVENTORY'') ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							AND MATERIAL_CLASS_NAME IS NOT NULL     ' + CHAR(10);      
	SET @MEXEC = @MEXEC+'							AND TYPE IS NOT NULL		                            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							AND TYPE != ''Total''	     	                            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							GROUP BY DIVISION_ID, MATERIAL_CLASS_NAME, TYPE, NICK_NAME, ATTRIBUTE1, MEASURE,  MEASURE_LABEL, MEASURE_COLOR ,SORT_ORDER_NO        ' + CHAR(10);
	SET @MEXEC = @MEXEC+'	        )  A  ' + CHAR(10);
	SET @MEXEC = @MEXEC+'	     ORDER BY MATERIAL_CLASS_NAME, IIF(TYPE = ''Total'',''0'',TYPE) ,MODEL, CELL_ITEM_ID,  CONVERT(INT, SORT_ORDER_NO)  ' + CHAR(10);			
			
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
