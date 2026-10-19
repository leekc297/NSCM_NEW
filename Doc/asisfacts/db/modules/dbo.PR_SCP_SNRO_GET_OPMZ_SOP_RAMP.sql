
/****************************************************************************************************/
/* Program ID  : PR_SCP_SNRO_GET_OPMZ_SOP_RAMP                                                      */
/* Description : Get SOP/Ramp-up master rows for a plan's division (SOP Pull-in baseline)           */
/* Usage       : SOP Pull-in recognition target list (GitLab #20)                                   */
/* Parameter   : @p_plan_id - OPMZ_PLAN_ID (base plan id)                                           */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026/09/10  choiya2      Initial Release — GitLab #20 SOP Pull-in                                */
/* 2026/09/10  choiya2      plan 미발견을 PLAN_NOT_FOUND 마커로 구별 (0행과 뜻이 다르다)           */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_SNRO_GET_OPMZ_SOP_RAMP]
    @p_plan_id nvarchar(200)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @V_DIVISION_ID nvarchar(50);

    SELECT TOP 1 @V_DIVISION_ID = P.DIVISION_ID
    FROM   dbo.SCP_OPMZ_PLAN_M P WITH(NOLOCK)
    WHERE  P.OPMZ_PLAN_ID = @p_plan_id;

    /* plan 을 못 찾으면 **0행이 아니라 마커 한 행**을 준다.
       그냥 0행을 주면 호출자가 "이 division 에 기준선이 없다"(없음)로 읽는데,
       실제로는 "맞댈 division 자체를 모른다"(모름)라 뜻이 정반대다.
       이 계열은 모름과 없음을 가르는 것이 규칙이므로 DB 쪽에서 갈라 준다. */
    IF @V_DIVISION_ID IS NULL
    BEGIN
        SELECT  N'PLAN_NOT_FOUND'               AS RECORD_TYPE
              , CONVERT(nvarchar(50),  NULL)    AS LINE_ID
              , CONVERT(nvarchar(100), NULL)    AS ITEM_ID
              , CONVERT(nvarchar(50),  NULL)    AS OPERATION_ID
              , CONVERT(nvarchar(50),  NULL)    AS PLANT_ID
              , CONVERT(nvarchar(8),   NULL)    AS START_DATE
              , CONVERT(nvarchar(8),   NULL)    AS END_DATE
              , CONVERT(numeric(20,2), NULL)    AS EFCY;
        RETURN;
    END

    /* 결과셋 하나로 합친다. 두 개로 나누면 호출자가 커서를 두 번 돌려야 하는데,
       hyper 의 proc 계약은 positional 단일 결과셋이다(procedure.py:120). */
    SELECT  N'SOP'          AS RECORD_TYPE
          , S.LINE_ID       AS LINE_ID
          , S.ITEM_ID       AS ITEM_ID
          , S.OPERATION_ID  AS OPERATION_ID
          , S.PLANT_ID      AS PLANT_ID
          , S.[DATE]        AS START_DATE
          , CONVERT(nvarchar(8), NULL) AS END_DATE
          , CONVERT(numeric(20, 2), NULL) AS EFCY
    FROM    dbo.SCP_OPMZ_SOP_EOP S WITH(NOLOCK)
    WHERE   1 = 1
    AND     S.VALID_YN    = 'Y'
    AND     S.DIVISION_ID = @V_DIVISION_ID
    AND     S.[TYPE]      = 'SOP'     /* EOP 는 이 상황의 범위가 아니다 — 실사용 0행이고
                                         반영 프로시저도 EOP 를 "산출만, 미적재" 로 둔다 */

    UNION ALL

    SELECT  N'RAMP'         AS RECORD_TYPE
          , R.LINE_ID       AS LINE_ID
          , R.ITEM_ID       AS ITEM_ID
          , R.OPERATION_ID  AS OPERATION_ID
          , R.PLANT_ID      AS PLANT_ID
          , R.START_DATE    AS START_DATE
          , R.END_DATE      AS END_DATE
          , R.EFCY          AS EFCY
    FROM    dbo.SCP_OPMZ_RAMP_UP R WITH(NOLOCK)
    WHERE   1 = 1
    AND     R.VALID_YN    = 'Y'
    AND     R.DIVISION_ID = @V_DIVISION_ID

    /* 완료조건 — 같은 INPUT 은 같은 OUTPUT 이다. 목록의 순서까지 고정한다. */
    ORDER BY 1, 2, 3, 6;
END
