
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_CUTOFF]
(
      @p_division_id          NVARCHAR(30) = NULL
)

AS

/*
 * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_CUTOFF
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.16   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.02   byunghunjung      전극컬럼 추가
 * 2019.02.11   YYDOK             일요일 야간에 일자변경으로 데이타 미생성조치
 *                                ( V_PLAN_START_YYYYMMDD변수추가 )
 * 2022.02.08   KSG               PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : 사업부별 수행
 */

BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

  DECLARE @V_PLAN_START_YYYYMMDD NVARCHAR(8);
  DECLARE @D_CUTOFF_DATE         DATETIME;  
  
  SET @V_PLAN_START_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);	-- 금주 월요일
  SET @D_CUTOFF_DATE         = GETDATE(); --DATEADD(DD, 6, CONVERT(DATETIME,@V_PLAN_START_YYYYMMDD,112));
  
  DECLARE @n_seq    INTEGER;
  -- LOG 용 변수 설정
  DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_PRODUCTION_PLAN_CUTOFF';
  DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;

  -- 시작 LOG  (START)
  SET @v_log_type = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
  -- 시작 LOG  (END)

  -- 트랜잭션 (START)
  BEGIN TRANSACTION PR_SCP_PRODUCTION_PLAN_CUTOFF;

    --------------------------------------------------------------------------------------------  
    BEGIN TRY
    --------------------------------------------------------------------------------------------  
	-------------------------------------------
	-- 1. Division별 MAX(plan_seq)
	-------------------------------------------
	IF OBJECT_ID('tempdb..#plan_seq') IS NOT NULL
	BEGIN 
		DROP TABLE #plan_seq          
	END 

	-- 20220208  PJ20216891  사업부별 수행
	SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, MAX(PLAN_SEQ) AS seq
	INTO   #plan_seq
	FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
	WHERE  DIVISION_ID         = ISNULL(@p_division_id, DIVISION_ID)
	AND    PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD	-- 금주 월요일
	AND    PLAN_TYPE           = 'FN'   --FN만 대상
	AND    CONFIRM_FLAG        = 'Y'
	GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE;

    BEGIN
      /* CUTOFF DATA DELETE */  
      -- 수동으로 생성시 cutoff date도 plan start yyyymmdd 와 동일시 해줘야 삭제가 되지 않는다.
      DELETE SCP_ANL_PRODUCTION_PLAN_C
      WHERE 1=1
	  AND   DIVISION_ID         = ISNULL(@p_division_id, DIVISION_ID) -- 20220208  PJ20216891  사업부별 수행
	  AND   PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
      --AND   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CONVERT(CHAR(8),CUTOFF_DATE , 112), 'MON')), 112)  = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  
  
	  /* CUTOFF DATA INSERT */  
	  INSERT INTO SCP_ANL_PRODUCTION_PLAN_C
	  SELECT   -- SCP_ANL_PRODUCTION_PLAN 데이터 insert
		   a.DIVISION_ID
		  ,'PP_W_'+ a.PLAN_START_YYYYMMDD  AS VERSION_NO --VERSION_NO
		  ,@D_CUTOFF_DATE AS CUTOFF_DATE 
		  --,CONVERT(DATETIME, '20180930' + ' ' + STUFF(STUFF('210000', 3, 0, ':'), 6, 0, ':'), 120)  AS CUTOFF_DATE
		  ,a.PLAN_START_YYYYMMDD
		  ,a.PLAN_TYPE
		  ,a.SEQ
		  ,OPERATION_GROUP
		  ,a.SCM_SITE_ID
		  ,ITEM_ID
		  ,LINE_ID
		  ,OPERATION_ID
		  ,MEASURE
		  ,YYYYMMDD
		  ,(CASE WHEN MEASURE ='FORMATION_YIELD' THEN ROUND(QTY* 100, 2)  ELSE QTY END) AS QTY  -- FORMATION_YIELD %로 화면에서 표기
		  ,DBO.FN_GET_DIVISION_NAME(a.DIVISION_ID) AS DIVISION_NAME 
		  ,DBO.FN_GET_LOOKUP_CODE_DESC('OPERATION_GROUP',OPERATION_GROUP) OPERATION_GROUP_NAME
		  --,DBO.FN_GET_SCM_SITE_DESCRIPTION(a.DIVISION_ID, SCM_SITE_ID) AS SCM_SITE_DESCRIPTION
		  ,C.SITE_DESCRIPTION AS SCM_SITE_DESCRIPTION
		  ,DBO.FN_GET_ITEM_NICKNAME (a.DIVISION_ID, ITEM_ID ) AS NICK_NAME
		  ,a.ORIGIN_DIVISION_ID
		  ,a.ELECTRODE_TYPE
		  ,a.CREATED_BY
		  ,a.CREATION_DATE
		  ,a.LAST_UPDATED_BY
		  ,a.LAST_UPDATE_DATE
		  ,a.ATTRIBUTE1
		  ,a.ATTRIBUTE2
		  ,a.ATTRIBUTE3
		  ,a.ATTRIBUTE4
		  ,a.ATTRIBUTE5
		  ,a.ATTRIBUTE6
		  ,a.ATTRIBUTE7
		  ,a.ATTRIBUTE8
		  ,a.ATTRIBUTE9
		  ,a.ATTRIBUTE10
	  FROM  SCP_ANL_PRODUCTION_PLAN a (NOLOCK)
      INNER JOIN #plan_seq B  -- 20220208  PJ20216891  사업부별 수행
	    ON  a.DIVISION_ID         = b.DIVISION_ID
        AND a.PLAN_START_YYYYMMDD = b.PLAN_START_YYYYMMDD
        AND a.PLAN_TYPE           = b.PLAN_TYPE
        AND a.SEQ                 = b.seq		

      LEFT JOIN (SELECT DIVISION_ID, SCM_SITE_ID, MAX(SITE_DESCRIPTION) AS SITE_DESCRIPTION
                   FROM SCM_MST_SITE WITH(NOLOCK)
                  WHERE 1=1 
                 GROUP BY DIVISION_ID, SCM_SITE_ID
                ) C
        ON  a.DIVISION_ID         = c.DIVISION_ID
        AND a.SCM_SITE_ID         = c.SCM_SITE_ID	

      WHERE 1=1
                         
    END

    IF OBJECT_ID('tempdb..#plan_seq') IS NOT NULL
    BEGIN 
       DROP TABLE #plan_seq          
    END 

    -- 트랜잭션 (COMMIT)
    COMMIT WORK;

    --------------------------------------------------------------------------------------------  
    END TRY
    --------------------------------------------------------------------------------------------  

  --------------------------------------------------------------  
    BEGIN CATCH
  --------------------------------------------------------------  
    -- ROLLBACK
    -- ERROR LOG VALUE SAVE
    SET @v_log_type    = 'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
    SET @d_event_date  = SYSDATETIME();

    SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

    -- 트랜잭션 (END)
    ROLLBACK TRANSACTION PR_SCP_PRODUCTION_PLAN_CUTOFF;

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  
  --------------------------------------------------------------  
    END CATCH;
  --------------------------------------------------------------  

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


  END;
