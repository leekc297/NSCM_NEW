/*
 *  출하 가능일자 반환 (입력된 일자 기준으로 Backward 검색)
 */
CREATE FUNCTION [dbo].[FN_TEST_ROUTE_DUE_BW]
(
   @p_master_id    NVARCHAR(100),
   @p_plan_id      NVARCHAR(100), 
   @p_bod_id       NVARCHAR(100),
   @p_start_date   DATETIME
) 
RETURNS DATETIME
AS 
BEGIN   

      DECLARE @v_master_id    NVARCHAR(100) = @p_master_id, 
		      @v_plan_id      NVARCHAR(100) = @p_plan_id, 		      
              @v_bod_id       NVARCHAR(100) = @p_bod_id,
              @d_start_date   DATETIME      = @p_start_date, 
              @d_pst          DATETIME, 
			  @d_fixed_date   DATETIME,   
		      @d_return_date  DATETIME

	--. 예외1. PST보다 작은 날짜는 PST 날짜로 RETURN
    SELECT @d_pst	= A.PLAN_START_DTTM
	  FROM TH_ENG_PLAN_INFO_SN A(NOLOCK)
	 WHERE A.MASTER_ID	= @v_master_id
	   AND A.PLAN_ID	= @v_plan_id
    ;

    IF @d_start_date < @d_pst
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
    
        IF @d_start_date <= @d_fixed_date
        BEGIN    
            RETURN @d_start_date;
        END

    END

	-- 3. B/W기준 ROUTE DUE 날짜
    SELECT @d_return_date = 
           CASE WHEN A.MAX_BUCKET_TYPE = 'DAY' THEN A.START_DTTM
                ELSE                              
                     @d_start_date
            END
      FROM
        (
        SELECT A.START_DTTM
             , A.BUCKET_TYPE
             , MAX(A.BUCKET_TYPE) OVER() AS MAX_BUCKET_TYPE
             , ROW_NUMBER() OVER(ORDER BY A.BUCKET_TYPE DESC, A.START_DTTM DESC) AS SEQ
          FROM
            (
            SELECT A.BUCKET_SEQ
                , A.BUCKET_TYPE
                , A.START_DTTM
                -- , B.START_DTTM
                , CASE WHEN B.START_DTTM IS NOT NULL THEN 'N' 
                       ELSE 'Y'
                   END WORKING_DAY_YN
            FROM TH_ENG_BUCKET_INFO_SN A WITH(NOLOCK)
            LEFT OUTER JOIN 
                (
                SELECT B.*
                    FROM TH_ENG_ITEM_BOD_CAL_SN B WITH(NOLOCK)
                    WHERE B.MASTER_ID = @v_master_id
                    AND B.PLAN_ID     = @v_plan_id
                    AND B.BOD_ID      = @v_bod_id
                    AND B.IS_USE      = 'N'
                ) B
              ON A.START_DTTM >= B.START_DTTM
             AND A.START_DTTM <  B.END_DTTM
            WHERE A.MASTER_ID = @v_master_id
            AND A.PLAN_ID     =  @v_plan_id
            ) A
        WHERE A.WORKING_DAY_YN = 'Y'
          AND A.START_DTTM    <=  @d_start_date
        ) A
    WHERE A.SEQ = 1
    ;
	
    IF @d_return_date IS NULL
    BEGIN
    	SET @d_return_date = @d_start_date;
    END

	RETURN @d_return_date;

END

