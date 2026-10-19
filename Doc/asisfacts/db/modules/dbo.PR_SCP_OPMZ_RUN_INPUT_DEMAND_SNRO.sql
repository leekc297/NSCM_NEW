
/****************************************************************************************************/
/* Program ID  : PR_SCP_OPMZ_RUN_INPUT_DEMAND_SNRO                                                 */
/* Description : 사이트간 이동 실행용 신규 PLAN의 DEMAND/DEMAND_ORIGIN INPUT을 생성한다.           */
/* Source Plan : 신규 PLAN MASTER.ATTRIBUTE12의 BASE PLAN_ID로 사업부, 계획그룹, 계획기간을 찾는다. */
/* Target Plan : @P_PLAN_ID로 전달받은 신규 시나리오 EGN_PLAN_ID를 사용한다.                        */
/* Division    : 조립은 일반 DEMAND INPUT, 전극은 SCP PLAN TVP를 구성한 후 전극 DEMAND INPUT 호출  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_OPMZ_RUN_INPUT_DEMAND_SNRO]
      @P_PLAN_ID NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NULLIF(LTRIM(RTRIM(@P_PLAN_ID)), N'') IS NULL
        THROW 50400, 'P_PLAN_ID IS REQUIRED.', 1;

    DECLARE @V_PLAN_ID             NVARCHAR(50) = @P_PLAN_ID;
    DECLARE @V_BASE_PLAN_KEY       NVARCHAR(100);
    DECLARE @V_DIVISION_ID         NVARCHAR(20);
    DECLARE @V_GROUP_ID            NVARCHAR(20);
    DECLARE @V_PLAN_START_YYYYMMDD NVARCHAR(8);
    DECLARE @V_PLAN_END_YYYYMMDD   NVARCHAR(8);
    DECLARE @V_PLAN_START_DATE     DATE;
    DECLARE @V_NEXT_MONDAY         DATE;

    /* 신규 PLAN MASTER의 ATTRIBUTE12에는 CREATE_ENGINE_PLAN이 기록한 BASE PLAN_ID가 저장된다. */
    SELECT @V_BASE_PLAN_KEY = PM.ATTRIBUTE12
    FROM dbo.SCP_OPT_ENG_PLAN_MASTER_SN PM WITH (NOLOCK)
    WHERE PM.PLAN_ID = @V_PLAN_ID;

    IF NULLIF(LTRIM(RTRIM(@V_BASE_PLAN_KEY)), N'') IS NULL
        THROW 50401, 'BASE PLAN_ID NOT FOUND FOR P_PLAN_ID.', 1;

    /* INPUT 파라미터는 BASE PLAN 기준정보에서 구성하고, 생성 대상 PLAN_ID만 신규 PLAN을 사용한다. */
    SELECT
          @V_DIVISION_ID = P.DIVISION_ID
        , @V_GROUP_ID = PGM.OPMZ_PLAN_GR_NAME
        , @V_PLAN_START_YYYYMMDD = P.PLAN_START_YYYYMMDD
        --, @V_PLAN_END_YYYYMMDD = P.PLAN_END_YYYYMMDD -- blocked 2026-09-24
        , @V_PLAN_END_YYYYMMDD = CONVERT(NVARCHAR(8),DATEADD(DAY,1,P.PLAN_END_YYYYMMDD),112) -- changed 2026-09-24
    FROM dbo.SCP_OPMZ_PLAN_M P WITH (NOLOCK)
    INNER JOIN dbo.SCP_OPMZ_PLAN_GR_M PGM WITH (NOLOCK)
        ON PGM.OPMZ_PLAN_GR_ID = P.OPMZ_PLAN_GR_ID
    WHERE P.OPMZ_PLAN_ID = @V_BASE_PLAN_KEY;

    IF @V_DIVISION_ID IS NULL
       OR @V_GROUP_ID IS NULL
       OR @V_PLAN_START_YYYYMMDD IS NULL
       OR @V_PLAN_END_YYYYMMDD IS NULL
        THROW 50402, 'BASE PLAN PARAMETER DATA NOT FOUND.', 1;

    IF @V_DIVISION_ID <> N'EE'
    BEGIN
        EXEC dbo.PR_SCP_OPT_ENG_INPUT_DEMAND
               @P_PLAN_ID = @V_PLAN_ID
             , @V_DIVISION_ID = @V_DIVISION_ID
             , @V_GROUP_ID = @V_GROUP_ID
             , @V_PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
             , @V_PLAN_END_YYYYMMDD = @V_PLAN_END_YYYYMMDD;
    END
    ELSE
    BEGIN
        DECLARE @T_SCP_PLAN dbo.optTableType_SCP_PLAN;

        SET @V_PLAN_START_DATE = TRY_CONVERT(DATE, @V_PLAN_START_YYYYMMDD, 112);

        IF @V_PLAN_START_DATE IS NULL
            THROW 50403, 'INVALID PLAN_START_YYYYMMDD.', 1;

        /* FN_NEXT_DAY(date,'MON')과 동일하게 계획시작일 이후 첫 월요일을 계산한다. */
        SET @V_NEXT_MONDAY = DATEADD
        (
            DAY,
            7 - ((DATEDIFF(DAY, CONVERT(DATE, '19000101', 112), @V_PLAN_START_DATE) % 7 + 7) % 7),
            @V_PLAN_START_DATE
        );

        /* 전극과 연결된 조립사업부별 전주 최신 SCP PLAN을 전극 INPUT 프로시저에 전달한다. */
        INSERT INTO @T_SCP_PLAN
        (
              DIVISION_ID
            , PLAN_START_YYYYMMDD
            , PLAN_TYPE
            , PLAN_SEQ
        )
        SELECT
              A.DIVISION_ID
            , A.PLAN_START_YYYYMMDD
            , A.PLAN_TYPE
            , A.PLAN_SEQ
        FROM
        (
            SELECT
                  V.DIVISION_ID
                , V.PLAN_START_YYYYMMDD
                , V.PLAN_TYPE
                , V.PLAN_SEQ
                , ROW_NUMBER() OVER
                  (
                      PARTITION BY V.DIVISION_ID
                      ORDER BY V.PLAN_START_YYYYMMDD DESC, V.PLAN_TYPE_ORDER DESC, V.PLAN_SEQ DESC
                  ) AS PLAN_RANK
            FROM dbo.SCP_PLAN_VERSION_V V WITH (NOLOCK)
            WHERE V.DIVISION_ID IN
            (
                SELECT D.DIVISION_ID
                FROM dbo.SCM_MST_DIVISION D WITH (NOLOCK)
                WHERE D.VALID_YN = N'Y'
                  AND D.ATTRIBUTE3 <> N'EE'
                  AND D.ATTRIBUTE4 =
                  (
                      SELECT MAX(EE.ATTRIBUTE4)
                      FROM dbo.SCM_MST_DIVISION EE WITH (NOLOCK)
                      WHERE EE.DIVISION_ID = @V_DIVISION_ID
                  )
            )
              AND V.PLAN_START_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DAY, -14, @V_NEXT_MONDAY), 112)
              AND V.PLAN_START_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DAY,  -7, @V_NEXT_MONDAY), 112)
        ) A
        WHERE A.PLAN_RANK = 1;

        EXEC dbo.PR_SCP_OPT_ENG_EE_INPUT_DEMAND
               @P_PLAN_ID = @V_PLAN_ID
             , @V_DIVISION_ID = @V_DIVISION_ID
             , @V_GROUP_ID = @V_GROUP_ID
             , @V_PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
             , @V_PLAN_END_YYYYMMDD = @V_PLAN_END_YYYYMMDD
             , @T_SCP_PLAN = @T_SCP_PLAN;
    END;
END;
