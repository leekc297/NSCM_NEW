
CREATE PROCEDURE [dbo].[PR_SCM_SYS_CALENDAR]
    ( @p_start_date VARCHAR(4000), @p_end_date VARCHAR(4000))
/*
 * Program ID   : PR_SCM_SYS_CALENDAR
 * Description  : System Calendar Creation
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.05   kjj            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022.06.15   KSG            목요일이 속한 월 기준으로 해당 주차 전체 ISO_YYYYMM 으로 처리
 *
 */
AS
BEGIN
    DECLARE @v_date DATETIME = convert(nvarchar, @p_start_date, 112);
	DECLARE @basis_yyyymm NVARCHAR(150);
	DECLARE @iso_yyyyww NVARCHAR(150);
	DECLARE @basis_start_date NVARCHAR(150);
	DECLARE @basis_end_date NVARCHAR(150);
	DECLARE @week_no NVARCHAR(150);
    SET NOCOUNT ON;
    
	WHILE 1=1 BEGIN
        INSERT INTO SCM_SYS_CALENDAR_M
             ( basis_yyyymmdd        
			 , basis_date
             , basis_yyyymm          
			 , iso_yyyyww
             , iso_week              
			 , week_name
			 , partial_week_name
			 , partial_yn
             , dayofweek
			 , dayofweek_name
             , dayofweek_no  
			 , calendar_yyyy
             , calendar_month        
			 , calendar_day
             , calendar_yyyyqq       
			 , month_code
             , month_name            
			 , english_month_name
             , month_full_name       
			 , date_full_name
             , date_short1_name      
			 , date_short2_name
             , date_short3_name
             , last_week_flag
             )
        SELECT convert(nvarchar, @v_date, 112)                   AS basis_yyyymmdd
             , @v_date                                           AS basis_date
             , LEFT(CONVERT(nvarchar, @v_date,112),6)            AS basis_yyyymm
             , LEFT(CONVERT(nvarchar, @v_date,112),4)+REPLICATE('0', 2-LEN(DATEPART(ISO_WEEK, @v_date)))+ CAST(DATEPART(ISO_WEEK, @v_date) AS VARCHAR(10))   AS iso_yyyyww
             , REPLICATE('0', 2-LEN(DATEPART(ISO_WEEK, @v_date)))+ CAST(DATEPART(ISO_WEEK, @v_date) AS VARCHAR(10)) AS iso_week
             ,'W'+REPLICATE('0', 2-LEN(DATEPART(ISO_WEEK, @v_date)))+CAST(isnull(DATEPART(ISO_WEEK, @v_date), '') AS nvarchar(10)) AS week_name
			 ,'W'+REPLICATE('0', 2-LEN(DATEPART(ISO_WEEK, @v_date)))+CAST(isnull(DATEPART(ISO_WEEK, @v_date), '') AS nvarchar(10)) AS partial_week_name
			 ,'N' partial_yn
			 , CASE WHEN DATEPART(DW,@v_date) = 1 THEN 'SUN'
			        WHEN DATEPART(DW,@v_date) = 2 THEN 'MON'
					WHEN DATEPART(DW,@v_date) = 3 THEN 'TUE'
					WHEN DATEPART(DW,@v_date) = 4 THEN 'WED'
					WHEN DATEPART(DW,@v_date) = 5 THEN 'THU'
					WHEN DATEPART(DW,@v_date) = 6 THEN 'FRI'
					WHEN DATEPART(DW,@v_date) = 7 THEN 'SAT'
			   END AS dayofweek_name
			 --, DATENAME(DW,@v_date)                AS dayofweek
             , CASE WHEN DATEPART(DW,@v_date) = 1 THEN 'Sunday'
			        WHEN DATEPART(DW,@v_date) = 2 THEN 'Monday'
					WHEN DATEPART(DW,@v_date) = 3 THEN 'Tuesday'
					WHEN DATEPART(DW,@v_date) = 4 THEN 'Wednesday'
					WHEN DATEPART(DW,@v_date) = 5 THEN 'Thursday'
					WHEN DATEPART(DW,@v_date) = 6 THEN 'Friday'
					WHEN DATEPART(DW,@v_date) = 7 THEN 'Saturday'
			   END AS dayofweek_name
			 --, DATENAME(DW,@v_date)                            AS dayofweek_name
             , DATEPART(DW,@v_date)                              AS dayofweek_no
             , LEFT(CONVERT(nvarchar, @v_date,112),4)                           AS calendar_yyyy
             , SUBSTRING(convert(nvarchar, @v_date, 112),5,2)                   AS calendar_month
             , SUBSTRING(convert(nvarchar, @v_date, 112),7,2)                   AS calendar_day
             , isnull(LEFT(CONVERT(nvarchar, @v_date,112),4), '')+'Q'+CAST(isnull(DATEPART(QUARTER, @v_date), '')AS VARCHAR(10))   AS calendar_yyyyqq
             , ISNULL(SUBSTRING(LEFT(CONVERT(nvarchar, @v_date,112),4),4,1), '') +
               isnull(case SUBSTRING(convert(nvarchar, @v_date, 112),5,2) when '10' then 'A' 
			                                                              when '11' then 'B' 
																		  when '12' then 'C'
                                                                          else SUBSTRING(SUBSTRING(convert(nvarchar, @v_date, 112),5,2),2,1) 
                      end, '')     AS month_code
             , LEFT(CONVERT(char(10), @v_date,126),7)                        AS month_name
             , CASE WHEN   DATEPART(MONTH,@v_date) = 1 THEN 'JAN'
                    WHEN   DATEPART(MONTH,@v_date) = 2 THEN 'FEB'
                    WHEN   DATEPART(MONTH,@v_date) = 3 THEN 'MAR'
					WHEN   DATEPART(MONTH,@v_date) = 4 THEN 'APR'
                    WHEN   DATEPART(MONTH,@v_date) = 5 THEN 'MAY'
                    WHEN   DATEPART(MONTH,@v_date) = 6 THEN 'JUN'
                    WHEN   DATEPART(MONTH,@v_date) = 7 THEN 'JUL'
                    WHEN   DATEPART(MONTH,@v_date) = 8 THEN 'AUG'
                    WHEN   DATEPART(MONTH,@v_date) = 9 THEN 'SEP'
                    WHEN   DATEPART(MONTH,@v_date) = 10 THEN 'OCT'
                    WHEN   DATEPART(MONTH,@v_date) = 11 THEN 'NOV'
					WHEN   DATEPART(MONTH,@v_date) = 12 THEN 'DEC'
				END AS english_month_name
			 , CASE WHEN   DATEPART(MONTH,@v_date) = 1 THEN 'January'
                    WHEN   DATEPART(MONTH,@v_date) = 2 THEN 'February'
                    WHEN   DATEPART(MONTH,@v_date) = 3 THEN 'March'
					WHEN   DATEPART(MONTH,@v_date) = 4 THEN 'April'
                    WHEN   DATEPART(MONTH,@v_date) = 5 THEN 'May'
                    WHEN   DATEPART(MONTH,@v_date) = 6 THEN 'June'
                    WHEN   DATEPART(MONTH,@v_date) = 7 THEN 'July'
                    WHEN   DATEPART(MONTH,@v_date) = 8 THEN 'August'
                    WHEN   DATEPART(MONTH,@v_date) = 9 THEN 'September'
                    WHEN   DATEPART(MONTH,@v_date) = 10 THEN 'October'
                    WHEN   DATEPART(MONTH,@v_date) = 11 THEN 'November'
					WHEN   DATEPART(MONTH,@v_date) = 12 THEN 'December'
				END AS month_full_name
			 , CONVERT(char(10), @v_date,126)                                                   AS date_full_name
             , CAST(CONVERT(CHAR(2), @v_date, 101)*10/10 AS VARCHAR)+'/'+ CAST(CONVERT(CHAR(2), @v_date, 103)*10/10 AS VARCHAR)   AS date_short1_name
             , CONVERT(CHAR(2), @v_date, 103)*10/10                                             AS date_short2_name
             , CONVERT(CHAR(5), @v_date, 10)                                                    AS date_short3_name
             , ( CASE WHEN DATEPART(DW,@v_date) = 1
                           THEN 'Y'
                           ELSE 'N'
                      END)                                      AS last_week_flag

        SET @v_date = @v_date + 1 ;
        IF  @v_date > convert(nvarchar, @p_end_date, 112)
			BREAK
		ELSE
			CONTINUE

    END;

    DECLARE r1 CURSOR FOR 
	            SELECT basis_yyyymm, iso_yyyyww
                     , MIN(basis_yyyymmdd) basis_start_date
                     , MAX(basis_yyyymmdd) basis_end_date
                     , RANK() OVER ( PARTITION BY basis_yyyymm ORDER BY iso_yyyyww) AS week_no
                FROM   SCM_SYS_CALENDAR_M
                WHERE  basis_yyyymmdd BETWEEN @p_start_date AND @p_end_date
                GROUP BY basis_yyyymm, iso_yyyyww;
    OPEN r1;
    FETCH NEXT FROM r1 INTO @basis_yyyymm , @iso_yyyyww , @basis_start_date , @basis_end_date , @week_no;

    WHILE @@FETCH_STATUS=0
    BEGIN
        UPDATE SCM_SYS_CALENDAR_M
        SET    basis_start_date = @basis_start_date
             , basis_end_date   = @basis_end_date
             , week_no        = @week_no
             , end_flag       = case basis_yyyymmdd when @basis_end_date then 'Y' else 'N' end
        WHERE  basis_yyyymm   = @basis_yyyymm
        AND    iso_yyyyww     = @iso_yyyyww ;
    FETCH NEXT FROM r1 INTO @basis_yyyymm , @iso_yyyyww , @basis_start_date , @basis_end_date , @week_no;
    END;
    CLOSE r1;
    DEALLOCATE r1;

	-- partial_week 처리 (전체 처리함)
	UPDATE scm_sys_calendar_m
    SET    partial_yn = 'Y'
    WHERE  iso_yyyyww IN (SELECT iso_yyyyww
				 		  FROM   scm_sys_calendar_m
						  GROUP BY iso_yyyyww
						  HAVING count(distinct basis_yyyymm) > 1);

	 UPDATE scm_sys_calendar_m
	 SET    partial_week_name = CASE WHEN A.rownums = '1' THEN A.week_name+'A' 
									 WHEN A.rownums = '2' THEN A.week_name+'B' END
	 FROM  scm_sys_calendar_m M
	 JOIN  (SELECT row_number() over (partition by iso_yyyyww order by basis_yyyymm) rownums
		   ,basis_yyyymm
		   ,iso_yyyyww
		   ,week_name
	  FROM (SELECT basis_yyyymm
	              ,week_name
				  ,iso_yyyyww
			FROM   scm_sys_calendar_m
			WHERE  partial_yn = 'Y'
			GROUP BY basis_yyyymm, week_name, iso_yyyyww) A) A
	 ON     M.basis_yyyymm = A.basis_yyyymm
	 AND    M.iso_yyyyww = A.iso_yyyyww;

	 -- 2022.06.15 목요일이 속한 월 기준으로 해당 주차 전체 ISO_YYYYMM 으로 처리
     UPDATE scm_sys_calendar_m
	 SET    ISO_YYYYMM = A.iso_yyyymm
	 FROM  scm_sys_calendar_m M
	 JOIN  (SELECT iso_yyyyww , basis_yyyymm as iso_yyyymm
			FROM   scm_sys_calendar_m
			WHERE  1=1
			AND    dayofweek = 'THU'
           ) A
	 ON     M.iso_yyyyww = A.iso_yyyyww;

--------------------------------------------------------------------------------
--                        E N D    O F    P R O G R A M
--------------------------------------------------------------------------------
END;
