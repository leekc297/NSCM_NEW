CREATE FUNCTION [dbo].[FN_SCM_SYS_NVL](
    @COL_VALUE      VARCHAR(4000), 
    @REPLACE_ARG    VARCHAR(4000)
) RETURNS VARCHAR(4000)

/*
 * Program ID   : FN_SCM_SYS_NVL
 * Description  : 오라클의 NVL과 같은 기능을 한다. 
*        컬럼 값이 NULL인경우 다음 지정 한 값으로 대체 한다.
*        공백도 NULL로 간주하여 처리한다.
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.22   Kim jaejung     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

BEGIN
    DECLARE @RET_VALUE VARCHAR(4000)

    IF (ISNULL(@COL_VALUE, '') = '')
        SET @RET_VALUE = @REPLACE_ARG;
    ELSE
        SET @RET_VALUE = @COL_VALUE;

    RETURN @RET_VALUE;
END
