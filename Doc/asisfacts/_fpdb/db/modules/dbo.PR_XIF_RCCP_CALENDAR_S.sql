CREATE PROCEDURE [dbo].[PR_XIF_RCCP_CALENDAR_S]
--ALTER PROCEDURE [dbo].[PR_XIF_RCCP_CALENDAR_S]
    @P_SITE_ID  NVARCHAR(50) = NULL
AS
/***********************************************************************************************/
/** 프로그램 ID   : FP01740										                              **/
/** 프로그램 명   :	Send Line Calendar to RCCP				                                  **/
/** 설 명         :	FP Planning Line 기준으로 입력된 Line Calendar 정보를 RCCP로 전송         **/
/**					라인 기준으로 관리되는 Calendar만 취합하여 전송함						  **/
/**					Equipment 기준으로 관리되는 Off Calendar는 전송 제외			          **/
/** Version       : 1.0.0                                                                     **/
/**                 			                                                              **/
/** Argument     	P_SITE_ID -- 생산자 ID를 매개변수로 함        						      **/
/**                 			                                                              **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자		작 성 자			사	   유											  **/
/**===========================================================================================**/
/** 2016.11.06		KIMCD				최초 작성											  **/
/***********************************************************************************************/
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
	SET XACT_ABORT ON;

    -- 필수 칼럼
	DECLARE @v_company		  NVARCHAR(30)   
	DECLARE @v_division		  NVARCHAR(30)
	DECLARE @v_corporation    NVARCHAR(30)
	DECLARE @v_plant   		  NVARCHAR(30)
    DECLARE @start_time       DATETIME
	DECLARE @end_time         DATETIME
    DECLARE @v_daydiff        Integer

  -- LOG 용 변수 설정
	DECLARE @v_proc_name	  NVARCHAR(100) = 'PR_XIF_RCCP_CALENDAR_S'
	DECLARE @v_table_name     NVARCHAR(100)
    DECLARE @v_message        NVARCHAR(250)
	DECLARE @v_descr		  NVARCHAR(250)
	DECLARE @n_row_count	  Integer	= 0
	DECLARE @n_log_count  	  Integer	= 0
	DECLARE @v_log_code		  NVARCHAR(10)

	DECLARE @sysdate		  DATETIME2 = GETDATE()
    DECLARE @v_insert_dttm    DATE

	DECLARE @v_temp1		  NVARCHAR(1000)
	DECLARE @v_temp2		  NVARCHAR(1000)

	-- ================================================
    -- MQ IF Declare start
	-- ================================================
	DECLARE @if_id_code             NVARCHAR(50)  = 'OFP0_ORCP_FP_CALENDAR'
	DECLARE @send_if_seq            NVARCHAR(50)
	DECLARE @send_date              NVARCHAR(50)
	DECLARE @if_seq_next            BIGINT

  -------------------------------------------------------------------------------------------
  -- LINE 인지 EQUIPMENT 인지 설정하는 변수... 아주 중요
  -------------------------------------------------------------------------------------------
 	DECLARE @res_category		 NVARCHAR(10)
  -------------------------------------------------------------------------------------------

  -- TEMP TABLE Variable Define
  DECLARE @T_LINE_OFF_DAY TABLE   (
                                	LINE_ID         NVARCHAR(150)
                                , OPERATION_ID    NVARCHAR(150)
                                , OFF_DATE        date
                                , OFF_START_TIME  datetime
                                , OFF_END_TIME    datetime
                                )

  DECLARE @T_LINE_OFF_TIME TABLE  (
                                	LINE_ID         NVARCHAR(150)
                                , OPERATION_ID    NVARCHAR(150)
                                , OFF_DATE        date
                                , OFF_START_TIME  datetime
                                , OFF_END_TIME    datetime
                                )

  DECLARE @T_EQUIPMENT_OFF_TIME TABLE  (
                                	LINE_ID         NVARCHAR(150)
                                , OPERATION_ID    NVARCHAR(150)
                                ,	EQUIPMENT_ID    NVARCHAR(150)
                                , OFF_DATE        date
                                , OFF_START_TIME  datetime
                                , OFF_END_TIME    datetime
                                )
  
	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))                                                                                                                                                
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))  
	SET @send_date = 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  -- Start 로그는 무조건 남김                                                                                                                                                                                                                                              
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate       

  BEGIN TRY
    BEGIN TRAN
    BEGIN
      SET @v_temp1 = 'SET START DATE'
	  SELECT @start_time = DATEADD(dd, 1 - DATEPART(dw, DATEADD(d, 0, DATEDIFF(d, 0, @sysdate))), DATEADD(d, 0, DATEDIFF(d, 0, @sysdate)))
	  SELECT @v_daydiff  = DATEDIFF(MINUTE,CONVERT(DATE,@start_time), DATEADD(HH, 8, CONVERT(DATETIME, @start_time)) ) -- 보완 필요
	  SELECT @end_time   = DATEADD(d, 186, @start_time)
    END;
    
    BEGIN
    
      SET @v_table_name = '@T_LINE_OFF_DAY-FACTORY'
      SET @n_row_count = 0
      
      DELETE FROM @T_LINE_OFF_DAY
      
      /*
        테이블변수 @T_LINE_OFF_DAY에 Factory Calendar의 휴일을 각 Line에 설정
      */
      
      INSERT INTO @T_LINE_OFF_DAY
              ( LINE_ID
              , OPERATION_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT    A.LINE_ID
              , A.OPERATION_ID
              , B.WORK_DATE
              , DATEADD( minute, @v_daydiff,        CONVERT(DATETIME, WORK_DATE) ) AS START_DATE
              , DATEADD( minute, @v_daydiff + 1440, CONVERT(DATETIME, WORK_DATE) ) AS END_DATE
      FROM   (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID
              FROM   LGCE_FP_TR.DBO.SCM_LINE_M A WITH(NOLOCK)
			  WHERE  ( @P_SITE_ID IS NULL OR A.SITE_ID = @P_SITE_ID )
			  AND    A.OPERATION_ID IN (SELECT L.SEGMENT1
			                            FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
										WHERE  L.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
										AND    L.ACTIVE_FLAG      = 'Y')
			  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID
             ) A,
             (
              SELECT A.* 
              FROM   LGCE_FP_TR.DBO.SCM_FACTORY_CALENDAR_M A WITH(NOLOCK)
              WHERE  1=1
              AND    A.WORK_DATE >= CONVERT(DATE,@start_time)
			  AND    A.WORK_DATE  < CONVERT(DATE,@end_time)
             ) B       
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID = B.FACTORY_ID

      SET @n_row_count += @@ROWCOUNT

      SET @v_table_name = '@T_LINE_OFF_DAY-LINE'
      
      /*
        테이블변수 @T_LINE_OFF_DAY에 LINE Calendar에서 Line Off 일자를 Factory Off 일자와 겹치지 않은 데이터를 저장
      */
      
      INSERT INTO @T_LINE_OFF_DAY
              ( LINE_ID
              , OPERATION_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT    A.LINE_ID
              , A.OPERATION_ID
              , B.WORK_DATE
              , DATEADD( minute, @v_daydiff,        CONVERT(DATETIME, WORK_DATE) ) AS START_DATE
              , DATEADD( minute, @v_daydiff + 1440, CONVERT(DATETIME, WORK_DATE) ) AS END_DATE
      FROM   (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID
              FROM   LGCE_FP_TR.DBO.SCM_LINE_M A WITH(NOLOCK)
			  WHERE  ( @P_SITE_ID IS NULL OR A.SITE_ID = @P_SITE_ID )
			  AND    A.OPERATION_ID IN (SELECT L.SEGMENT1
			                            FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
										WHERE  L.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
										AND    L.ACTIVE_FLAG      = 'Y')
              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID ) A,
             (
              SELECT A.* 
              FROM   LGCE_FP_TR.DBO.SCM_LINE_CALENDAR_M A WITH(NOLOCK)
              WHERE  1=1
              AND    A.WORK_DATE >= CONVERT(DATE,@start_time)
			  AND    A.WORK_DATE  < CONVERT(DATE,@end_time)
              AND    OFF_FLAG = 'Y'
             ) B       
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID = B.FACTORY_ID
	  AND    A.LINE_ID    = B.LINE_ID
	  AND    A.OPERATION_ID = B.OPERATION_ID
      AND    NOT EXISTS ( SELECT 1
                          FROM   @T_LINE_OFF_DAY X
                          WHERE  A.LINE_ID = X.LINE_ID
                          AND    A.OPERATION_ID = X.OPERATION_ID
                          AND    B.WORK_DATE = X.OFF_DATE )
      ;
      
      SET @n_row_count += @@ROWCOUNT
   
    END

    BEGIN

      SET @v_table_name = '@T_LINE_OFF_TIME'
      
      DELETE FROM @T_LINE_OFF_TIME
      
      /*
        테이블변수 @T_LINE_OFF_TIME에 Line Calendar 와 Line에 Work Type 을 적용한 데이터 중에서
        @T_LINE_OFF_DAY 에 없는 데이터 저장
      */
            
      INSERT INTO @T_LINE_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT    LINE_ID
              , OPERATION_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME
      FROM   (
                SELECT A.LINE_ID,
                       A.OPERATION_ID,
                       A.OFF_DATE,
                       CASE WHEN R = 1                           THEN DATE_START_TIME
                            WHEN WORK_START_TIME > WORK_END_TIME THEN DATEADD(DAY, 1, WORK_END_TIME)
                                                                 ELSE WORK_END_TIME
                       END  AS OFF_START_TIME,
                       CASE WHEN R = 1 THEN WORK_START_TIME
                                       ELSE DATE_END_TIME
                       END  AS OFF_END_TIME
                FROM   (
                        SELECT C.LINE_ID,
                               C.OPERATION_ID,
                               A.WORK_DATE AS OFF_DATE,
                               DATEADD( MINUTE, @v_daydiff,        CONVERT(DATETIME, WORK_DATE)) AS DATE_START_TIME,
                               DATEADD( MINUTE, @v_daydiff + 1440, CONVERT(DATETIME, WORK_DATE)) AS DATE_END_TIME,
                               CONVERT(DATETIME, WORK_DATE) + CONVERT(DATETIME, START_TIMESET) AS WORK_START_TIME,
                               CONVERT(DATETIME, WORK_DATE) + CONVERT(DATETIME, END_TIMESET)   AS WORK_END_TIME
                        FROM   LGCE_FP_TR.DBO.SCM_LINE_CALENDAR_M A WITH(NOLOCK),
                               LGCE_FP_TR.DBO.SCM_WORK_TYPE_M B WITH(NOLOCK),
                               ( SELECT L.COMPANY_ID, L.DIVISION_ID, L.SITE_ID, L.PLANT_ID, L.FACTORY_ID, L.LINE_ID, L.OPERATION_ID
							     FROM   LGCE_FP_TR.DBO.SCM_LINE_M L WITH(NOLOCK)
								 WHERE  ( @P_SITE_ID IS NULL OR L.SITE_ID = @P_SITE_ID )
								 AND    L.OPERATION_ID IN (SELECT V.SEGMENT1
														   FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE V WITH(NOLOCK)
														   WHERE  V.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
														   AND    V.ACTIVE_FLAG      = 'Y')
								 GROUP  BY L.COMPANY_ID, L.DIVISION_ID, L.SITE_ID, L.PLANT_ID, L.FACTORY_ID, L.LINE_ID, L.OPERATION_ID ) C
                        WHERE  1=1
                        AND    A.WORK_DATE >= CONVERT(DATE,@start_time)
					    AND    A.WORK_DATE  < CONVERT(DATE,@end_time)
                        AND    A.COMPANY_ID = B.COMPANY_ID
                        AND    A.DIVISION_ID = B.DIVISION_ID
                        AND    A.SITE_ID = B.SITE_ID
                        AND    A.PLANT_ID = B.PLANT_ID
                        AND    A.WORK_TYPE_ID = B.WORK_TYPE_ID
                        AND    A.COMPANY_ID = C.COMPANY_ID
                        AND    A.DIVISION_ID = C.DIVISION_ID
                        AND    A.SITE_ID = C.SITE_ID
                        AND    A.PLANT_ID = C.PLANT_ID
                        AND    A.FACTORY_ID = C.FACTORY_ID
                        --AND    A.SHOP_ID = C.SHOP_ID  2016.0929.LJH. SHOP_ID DELETE
                        AND    A.LINE_ID = C.LINE_ID
                        AND    A.OPERATION_ID = C.OPERATION_ID
						AND    A.OPERATION_ID IN (SELECT L.SEGMENT1
								                  FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
												  WHERE  L.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
												  AND    L.ACTIVE_FLAG      = 'Y')
                        AND    A.OFF_FLAG = 'N'
						AND    ( @P_SITE_ID IS NULL OR C.SITE_ID = @P_SITE_ID )
                       ) A,
                       ( SELECT 1 R UNION ALL
                         SELECT 2 R ) B
                WHERE  1=1
                AND    NOT EXISTS ( SELECT 1
                                    FROM   @T_LINE_OFF_DAY X 
                                    WHERE  A.LINE_ID = X.LINE_ID
                                    AND    A.OPERATION_ID = X.OPERATION_ID
                                    AND    A.OFF_DATE = X.OFF_DATE )
               ) A
      WHERE   OFF_START_TIME < OFF_END_TIME
      
      SET @n_row_count += @@ROWCOUNT
      
      /*
        테이블변수 @T_LINE_OFF_TIME에 Line Calendar 와 Line에 Work Type 을 적용한 데이터 중에서
        @T_LINE_OFF_DAY 에 없는 데이터 저장
      */
      SET @v_table_name = '@T_LINE_OFF_TIME-WORK_TYPE_OFF'
      -- OFF TIME
      INSERT INTO @T_LINE_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT    A.LINE_ID
              , A.OPERATION_ID
              , A.OFF_DATE
              , CASE WHEN CHECK_TIMESET > START_TIMESET THEN DATEADD(DAY, 1, OFF_START)
                                                        ELSE OFF_START
                END  AS OFF_START_TIME
              , CASE WHEN CHECK_TIMESET > END_TIMESET   THEN DATEADD(DAY, 1, OFF_END)
                                                        ELSE OFF_END
                END  AS OFF_END_TIME
      FROM   (
                SELECT C.LINE_ID,
                       C.OPERATION_ID,
                       A.WORK_DATE AS OFF_DATE,
                       CONVERT(TIME, START_TIMESET) AS START_TIMESET,
                       CONVERT(TIME, END_TIMESET)   AS END_TIMESET,
                       CONVERT(TIME, @start_time)   AS CHECK_TIMESET,
                       CONVERT(DATETIME, WORK_DATE) + CONVERT(DATETIME, START_TIMESET) AS OFF_START,
                       CONVERT(DATETIME, WORK_DATE) + CONVERT(DATETIME, END_TIMESET)   AS OFF_END
                FROM   LGCE_FP_TR.DBO.SCM_LINE_CALENDAR_M A WITH(NOLOCK),
                       LGCE_FP_TR.DBO.SCM_WORK_TYPE_OFF_M B WITH(NOLOCK),
                       ( SELECT L.COMPANY_ID, L.DIVISION_ID, L.SITE_ID, L.PLANT_ID, L.FACTORY_ID, L.LINE_ID, L.OPERATION_ID
						 FROM   LGCE_FP_TR.DBO.SCM_LINE_M L WITH(NOLOCK)
						 WHERE  ( @P_SITE_ID IS NULL OR L.SITE_ID = @P_SITE_ID )
						 AND    L.OPERATION_ID IN ( SELECT V.SEGMENT1
													FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE V WITH(NOLOCK)
													WHERE  V.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
													AND    V.ACTIVE_FLAG      = 'Y')
						 GROUP  BY L.COMPANY_ID, L.DIVISION_ID, L.SITE_ID, L.PLANT_ID, L.FACTORY_ID, L.LINE_ID, L.OPERATION_ID ) C
                WHERE  1=1
                AND    A.WORK_DATE >= CONVERT(DATE,@start_time)
			    AND    A.WORK_DATE  < CONVERT(DATE,@end_time)
                AND    A.COMPANY_ID = B.COMPANY_ID
                AND    A.DIVISION_ID = B.DIVISION_ID
                AND    A.SITE_ID = B.SITE_ID
                AND    A.PLANT_ID = B.PLANT_ID
                AND    A.WORK_TYPE_ID = B.WORK_TYPE_ID
                AND    A.COMPANY_ID = C.COMPANY_ID
                AND    A.DIVISION_ID = C.DIVISION_ID
                AND    A.SITE_ID = C.SITE_ID
                AND    A.PLANT_ID = C.PLANT_ID
                AND    A.FACTORY_ID = C.FACTORY_ID
                --AND    A.SHOP_ID = C.SHOP_ID  2016.0929.LJH. SHOP_ID DELETE
                AND    A.LINE_ID = C.LINE_ID
                AND    A.OPERATION_ID = C.OPERATION_ID
                AND    A.OFF_FLAG = 'N'
			    AND    A.OPERATION_ID IN (SELECT L.SEGMENT1
			                              FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
										  WHERE  L.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
										  AND    L.ACTIVE_FLAG      = 'Y')
				AND    ( @P_SITE_ID IS NULL OR C.SITE_ID = @P_SITE_ID )
             ) A
      WHERE  NOT EXISTS ( SELECT 1
                          FROM   @T_LINE_OFF_DAY X
                          WHERE  A.LINE_ID = X.LINE_ID
                          AND    A.OPERATION_ID = X.OPERATION_ID
                          AND    A.OFF_DATE = X.OFF_DATE )

      SET @n_row_count += @@ROWCOUNT
    END

    BEGIN
    
      SET @v_table_name = '@T_LINE_OFF_TIME += @T_LINE_OFF_DAY'

      /*
        테이블변수 @T_LINE_OFF_DAY에서 조회한 데이터를 테이블 변수 @T_LINE_OFF_TIME 저장
      */
      
      INSERT INTO @T_LINE_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT 
                LINE_ID
              , OPERATION_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME 
      FROM      @T_LINE_OFF_DAY

      SET @n_row_count += @@ROWCOUNT

          --LOG 생성
      SET @sysdate = GETDATE()

    END

    BEGIN
    
      SET @v_table_name = '@T_EQUIPMENT_OFF_TIME'
      SET @n_row_count = 0

      --DELETE FROM TH_BUF_SCM_EQ_OFF_TIME
      
      /*
        Off Calendar, Equipment, Instance Flow 에서 조회한 Equipment 별 Off time 데이터를 테이블 변수 @T_EQUIPMENT_OFF_TIME에 저장
      */

      INSERT INTO @T_EQUIPMENT_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , EQUIPMENT_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT    A.LINE_ID
              , A.OPERATION_ID
              , A.EQUIPMENT_ID
              , CONVERT(DATE, DATEADD( DD, (B.INT - 1), CONVERT(DATETIME, OFF_START_DATE))) AS WORK_DATE
              , CASE WHEN B.INT = 1 THEN OFF_START_TIME
                     ELSE DATEADD( MINUTE, @v_daydiff + (B.INT - 1) * 1440, CONVERT(DATETIME, OFF_START_DATE))
                END  OFF_START_TIME
              , CASE WHEN B.INT = A.DAYDIFF THEN OFF_END_TIME
                     ELSE DATEADD( MINUTE, @v_daydiff + (B.INT - 0) * 1440, CONVERT(DATETIME, OFF_START_DATE))
                END  OFF_END_TIME
      FROM   (
                SELECT A.*,
                       DATEDIFF( DD, OFF_START_DATE, OFF_END_DATE ) + 1 DAYDIFF
                FROM   (
                        SELECT B.LINE_ID,
                               B.OPERATION_ID,
                               A.EQUIPMENT_ID,
                               A.OFF_START_TIME,
                               A.OFF_END_TIME,
                               CONVERT(DATE, DATEADD( MINUTE, -1 *   @v_daydiff,           CONVERT(DATETIME, OFF_START_TIME))) OFF_START_DATE,
                               CONVERT(DATE, DATEADD( SECOND, -1 * ( @v_daydiff * 60 + 1), CONVERT(DATETIME, OFF_END_TIME)))   OFF_END_DATE
                        FROM   LGCE_FP_TR.DBO.SCM_OFF_CALENDAR_M A WITH(NOLOCK),
                               LGCE_FP_TR.DBO.SCM_EQUIPMENT_M B WITH(NOLOCK)
                        WHERE  1=1
                        AND    A.COMPANY_ID = B.COMPANY_ID
                        AND    A.DIVISION_ID = B.DIVISION_ID
                        AND    A.SITE_ID = B.SITE_ID
                        AND    A.PLANT_ID = B.PLANT_ID
                        AND    A.FACTORY_ID = B.FACTORY_ID
                        --AND    A.SHOP_ID = B.SHOP_ID  2016.0929.LJH. SHOP_ID DELETE
                        AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID
						AND    B.EQUIPMENT_TYPE = 'M'
						AND    B.ACTIVE_FLAG  = 'Y'
		                AND    A.OFF_START_TIME >= CONVERT(DATE,@start_time)
						AND    A.OFF_START_TIME  < CONVERT(DATE,@end_time)
						AND    ( @P_SITE_ID IS NULL OR B.SITE_ID = @P_SITE_ID )
						AND    B.OPERATION_ID IN (SELECT L.SEGMENT1
									              FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
												  WHERE  L.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
												  AND    L.ACTIVE_FLAG      = 'Y')
                       ) A
             ) A,
             COPYT B
      WHERE  DAYDIFF >= B.INT

      SET @n_row_count += @@ROWCOUNT
      
      /*
        테이블 변수 @T_LINE_OFF_TIM, @T_EQUIPMENT_OFF_TIME 에서 조회한 데이터를 테이블 변수 @T_EQUIPMENT_OFF_TIME에 저장
      */

      INSERT INTO @T_EQUIPMENT_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , EQUIPMENT_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT    A.LINE_ID,
                A.OPERATION_ID,
                B.EQUIPMENT_ID,
                A.OFF_DATE,
                A.OFF_START_TIME,
                A.OFF_END_TIME
      FROM      @T_LINE_OFF_TIME A,
               (SELECT LINE_ID, OPERATION_ID, EQUIPMENT_ID
                FROM   LGCE_FP_TR.DBO.SCM_EQUIPMENT_M WITH(NOLOCK)
                GROUP  BY LINE_ID, OPERATION_ID, EQUIPMENT_ID ) B
      WHERE     A.LINE_ID = B.LINE_ID
      AND       A.OPERATION_ID = B.OPERATION_ID

      SET @n_row_count += @@ROWCOUNT
      
    END;

    BEGIN

      SET @v_table_name = '@LINE_OFF_CALENDAR'
      SET @n_row_count = 0

      DECLARE OFF_LINE CURSOR FOR SELECT  LD.DATE_ID
										 ,LD.COMPANY_ID
										 ,LD.DIVISION_ID
										 ,LD.SITE_ID
										 ,LD.PLANT_ID
										 ,LD.FACTORY_ID
										 ,LD.LINE_ID
										 ,LD.LINE_NAME
										 ,LD.OPERATION_ID
										 ,LD.EQP_COUNT
										 ,ISNULL( ( SELECT SUM(DATEDIFF(MI, B.OFF_START_TIME, B.OFF_END_TIME))
										            FROM   @T_EQUIPMENT_OFF_TIME  B 
										            WHERE  LD.LINE_ID      = B.LINE_ID
								                    AND    LD.OPERATION_ID = B.OPERATION_ID
                                                    AND    LD.DATE_ID      = B.OFF_DATE ) , 0 )  AS OFF_SUM
								  FROM   ( SELECT A.DATE_ID, C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FACTORY_ID, C.LINE_ID, C.OPERATION_ID, C.LINE_NAME, C.EQP_COUNT
										   FROM   LGCE_FP_TR.DBO.SCM_SYS_CALENDAR_M A WITH(NOLOCK)
												 ,( SELECT L.COMPANY_ID, L.DIVISION_ID, L.SITE_ID, L.PLANT_ID, L.FACTORY_ID, L.LINE_ID, L.OPERATION_ID, MAX(LINE_NAME)  AS LINE_NAME
														  ,( SELECT COUNT(*)
															 FROM   LGCE_FP_TR.DBO.SCM_EQUIPMENT_M M WITH(NOLOCK)
															 WHERE  M.COMPANY_ID  = L.COMPANY_ID
															 AND    M.DIVISION_ID  = L.DIVISION_ID
															 AND    M.SITE_ID      = L.SITE_ID
															 AND    M.PLANT_ID     = L.PLANT_ID
															 AND    M.FACTORY_ID   = L.FACTORY_ID
															 AND    M.LINE_ID      = L.LINE_ID
															 AND    M.OPERATION_ID = L.OPERATION_ID
															 AND    M.EQUIPMENT_TYPE =  'M'
															 AND    M.ACTIVE_FLAG  = 'Y' )  AS EQP_COUNT
													FROM   LGCE_FP_TR.DBO.SCM_LINE_M L WITH(NOLOCK)
													WHERE  ( @P_SITE_ID IS NULL OR L.SITE_ID = @P_SITE_ID )
													AND    L.OPERATION_ID IN ( SELECT V.SEGMENT1
											 								   FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE V WITH(NOLOCK)
																			   WHERE  V.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
																			   AND    V.ACTIVE_FLAG      = 'Y')
													GROUP  BY L.COMPANY_ID, L.DIVISION_ID, L.SITE_ID, L.PLANT_ID, L.FACTORY_ID, L.LINE_ID, L.OPERATION_ID ) C
										   WHERE  A.DATE_ID >= CONVERT(DATE,@start_time)
										   AND    A.DATE_ID  < CONVERT(DATE,@end_time)  ) LD ;
      

      
      DECLARE @DATE_ID         DATE;
      DECLARE @COMPANY_ID      NVARCHAR(30);
      DECLARE @DIVISION_ID     NVARCHAR(30);
      DECLARE @SITE_ID         NVARCHAR(30);
      DECLARE @PLANT_ID        NVARCHAR(30);
      DECLARE @FACTORY_ID      NVARCHAR(30);
      DECLARE @LINE_ID         NVARCHAR(30);
	  DECLARE @LINE_NAME       NVARCHAR(100);
      DECLARE @OPERATION_ID    NVARCHAR(30);
      DECLARE @EQP_COUNT       INT;
      DECLARE @OFF_SUM         NUMERIC(13,3);
	  DECLARE @WORKING_HOUR    NUMERIC(18,3);
	  DECLARE @HOLIDAY_YN      NVARCHAR(1);

      SET @v_table_name = 'OPEN OFF_LINE'
      OPEN OFF_LINE
	  FETCH NEXT FROM OFF_LINE INTO @DATE_ID
	                              , @COMPANY_ID
	                              , @DIVISION_ID
	                              , @SITE_ID
	                              , @PLANT_ID
	                              , @FACTORY_ID
	                              , @LINE_ID
								  , @LINE_NAME
	                              , @OPERATION_ID
	                              , @EQP_COUNT
	                              , @OFF_SUM;
      
      WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
      BEGIN
          IF @EQP_COUNT <= 0
		      BEGIN
			      IF @OFF_SUM > 1440
				      BEGIN
					      SET @WORKING_HOUR = 0;
						  SET @HOLIDAY_YN   = 'Y';
					  END;
				  ELSE
				      BEGIN
					      SET @WORKING_HOUR = 24 - @OFF_SUM/60;
						  SET @HOLIDAY_YN   = 'N';
					  END;
			  END;
		  ELSE
		      BEGIN
			      IF @OFF_SUM > 1440 * @EQP_COUNT
				      BEGIN
					      SET @WORKING_HOUR = 0;
						  SET @HOLIDAY_YN   = 'Y';
					  END;
				  ELSE
				      BEGIN
					      SET @WORKING_HOUR = 24 - @OFF_SUM/(@EQP_COUNT*60);
						  SET @HOLIDAY_YN   = 'N';
					  END;
			  END;

          SET @v_table_name = 'XIF_RCCP_CALENDAR_S'
          INSERT INTO [dbo].[SY_XIF_RCCP_CALENDAR_S] 		
			  ([IF_SEQ]
			  ,[IF_TYPE]
			  ,[IF_ID]
			  ,[IF_INS_DATE]
			  ,[IF_FLAG]
			  ,[DIVISION_CODE]
			  ,[SITE_CODE]
			  ,[PLANT_CODE]
			  ,[RESOURCE_CODE]
			  ,[RESOURCE_NAME]
			  ,[YYYYMMDD]
			  ,[WORKING_TIME]
			  ,[HOLIDAY_YN]
			  ,[CREATE_USER_ID]
			  ,[CREATE_DATE]
			  ,[MODIFY_USER_ID]
			  ,[MODIFY_DATE])
          VALUES('OFP0' + @send_date + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
				,'S'                -- IF_TYPE
				,@if_id_code        -- IF_ID
				,GETDATE()          -- IF_INS_DATE
				,'N'                -- IF_FLAG
				,@DIVISION_ID       -- DIVISION_CODE
				,@SITE_ID           -- SITE_CODE
				,@PLANT_ID          -- PLANT_CODE
				,@LINE_ID           -- RESOURCE_CODE
				,@LINE_NAME         -- RESOURCE_NAME
				,CONVERT(NVARCHAR(12), @DATE_ID, 112)   -- YYYYMMDD
				,@WORKING_HOUR      -- WORKING_HOUR
				,@HOLIDAY_YN        -- HOLIDAY_YN
				,@v_proc_name       -- CREATE_USER_ID
				,GETDATE()          -- CREATE_DATE
				,@v_proc_name       -- MODIFY_USER_ID
				,GETDATE()          -- MODIFY_DATE
				);
		  SET @n_row_count += 1;

		  FETCH NEXT FROM OFF_LINE INTO @DATE_ID
									  , @COMPANY_ID
									  , @DIVISION_ID
									  , @SITE_ID
									  , @PLANT_ID
									  , @FACTORY_ID
									  , @LINE_ID
									  , @LINE_NAME
									  , @OPERATION_ID
									  , @EQP_COUNT
									  , @OFF_SUM;            
      END;   -- WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0

	  CLOSE OFF_LINE
	  DEALLOCATE OFF_LINE        

    END;

    COMMIT TRANSACTION;

    SET @v_temp1 = 'STEP END PROCEDURE'
	SET @sysdate = GETDATE()
    EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   @n_row_count, @v_temp1, '############### End of procedure ###############', NULL, @sysdate    

END TRY

	BEGIN CATCH
		SET @v_descr = ERROR_MESSAGE()
		ROLLBACK

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, @v_temp1, @v_descr, @sysdate

	END CATCH

END
