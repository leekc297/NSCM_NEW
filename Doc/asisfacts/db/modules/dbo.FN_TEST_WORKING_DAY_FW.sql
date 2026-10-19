/*
 *  WORKING_DAY 가능일자 반환 (입력된 일자 기준으로 Backward 검색)
 */
CREATE FUNCTION [dbo].[FN_TEST_WORKING_DAY_FW]
(
   @p_master_id    NVARCHAR(100),
   @p_plan_id      NVARCHAR(100), 
   @p_bod_id       NVARCHAR(100),
   @p_operation_id NVARCHAR(100),
   @p_start_date   DATETIME,
   @p_working_days INT
) 
RETURNS DATETIME
AS 
BEGIN   

      DECLARE @v_master_id    NVARCHAR(100) = @p_master_id, 
		      @v_plan_id      NVARCHAR(100) = @p_plan_id, 		      
              @v_bod_id       NVARCHAR(100) = @p_bod_id,
              @v_operation_id NVARCHAR(100) = @p_operation_id,
              @d_start_date   DATETIME      = @p_start_date, 
              @v_working_days INT           = @p_working_days,
			  @d_pst          DATETIME, 
			  @d_fixed_date   DATETIME,   
		      @d_return_date  DATETIME

	--. 예외1. PST보다 작은 날짜는 PST 날짜로 RETURN
    SELECT @d_pst	= A.PLAN_START_DTTM
	  FROM TH_ENG_PLAN_INFO_SN A(NOLOCK)
	 WHERE A.MASTER_ID	= @v_master_id
	   AND A.PLAN_ID	= @v_plan_id
    ;

    IF @d_start_date <= @d_pst
    BEGIN    
        RETURN @d_pst; 
    END

	--. 예외2. FIXED_TERM 이전 날짜는 입력받은 날짜 + WORKING DAY로 RETURN
    IF @v_bod_id IS NOT NULL
    
    BEGIN

	    SELECT @d_fixed_date = DATEADD(DAY,A.FIXED_TERM-1,@d_pst )
	      FROM TH_ENG_BOD_SN A(NOLOCK)
	     WHERE A.MASTER_ID	= @v_master_id
	       AND A.PLAN_ID	= @v_plan_id
	       AND A.BOD_ID		= @v_bod_id
	     ;
    
        IF @d_start_date < @d_fixed_date
        BEGIN    
            RETURN DATEADD(DAY, @p_working_days, @d_start_date); 
        END

    END

	-- 3. F/W기준 WORKING DAY 날짜
	SELECT @d_return_date = A.START_DTTM        
     FROM
        (
        SELECT A.START_DTTM
             , ROW_NUMBER() OVER(ORDER BY A.START_DTTM) AS SEQ
            FROM
            (
            SELECT A.BUCKET_SEQ
                 , A.START_DTTM
              -- , B.START_DTTM
                 , CASE WHEN B.START_DTTM IS NOT NULL THEN 'N' 
                        ELSE 'Y'
                    END WORKING_DAY_YN
             FROM TH_ENG_BUCKET_INFO_SN A WITH(NOLOCK)
             LEFT OUTER JOIN 
                    (
                    SELECT B.*
                      FROM TH_ENG_OFFTIME_SN B WITH(NOLOCK)
                     WHERE B.MASTER_ID = @v_master_id
                       AND B.PLAN_ID     = @v_plan_id
                       AND B.OFFTIME_SET_ID = @v_operation_id
                    ) B
               ON A.START_DTTM  = B.START_DTTM
            WHERE A.MASTER_ID   = @v_master_id
              AND A.PLAN_ID     = @v_plan_id
              AND A.START_DTTM >=  @d_start_date
            ) A
        WHERE A.WORKING_DAY_YN = 'Y'
          AND A.START_DTTM >=  @d_start_date
        ) A
    WHERE A.SEQ = @v_working_days
    --ORDER BY A.START_DTTM DESC
    ;
	
    IF @d_return_date IS NULL     
    BEGIN          
    SET @d_return_date = @d_start_date;
    END

	RETURN @d_return_date;

END

