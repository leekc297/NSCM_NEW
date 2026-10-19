
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_IF
 * Description  : RTF 준수율 Weekly 조회 I/F 제공뷰에서 호출
 * Program History
 *===================================================================================================
 *  Date        In Charge       Description
*===================================================================================================
* 2022.07.12	chaan       V1.0.0  Inititialize
* 2022/08/09    chaan		V1.0.1  DM기준 biz_type => operation_group 으로 변경
* 2022/08/24    chaan		V1.1.1  INSERT, EXEC 중첩에러 회피를 위해 SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY 수정
* 2023/02/01    chaan		V1.1.2  - 집계테이블 생성으로 로직 변경후 경영정보팀 SCP_VIEW 계정 UPDATE 권한문제로 집계로직 제거
* 2023/02/14    chaan		        - 결과셋에서 seq 컬럼 제거
**************************************************************************************************
*/
--CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_IF]
CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_IF]
(
      @p_division   NVARCHAR(30)    = N''
    , @p_yyyy       NVARCHAR(4)     = N''
    , @p_ww         NVARCHAR(2)     = N''
)
AS
BEGIN
    SET NOCOUNT ON
    SET ANSI_NULLS ON
    SET ANSI_WARNINGS ON

    --DECLARE     @p_division     NVARCHAR(30)    = N'40';
    --DECLARE     @p_yyyy         NVARCHAR(6)     = N'2023';
    --DECLARE     @p_ww           NVARCHAR(6)     = N'03';
    
    DECLARE     @v_thisyear     NVARCHAR(4)     = SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 112), 1, 4);
    
    DECLARE     @v_if_yn        NVARCHAR(12)    = N'Y';
    DECLARE     @v_week         NVARCHAR(12)    = N'';
    DECLARE     @v_isoyyyymmww  NVARCHAR(8)     = N'';

    IF @p_yyyy = '' OR @p_yyyy IS NULL OR @p_ww = '' OR @p_ww IS NULL
    BEGIN
        SELECT    @v_week        = MAX(A.YYYYMMDD + '-' + B.WEEK_NAME)
        --SELECT  MAX(A.YYYYMMDD + '-' + B.WEEK_NAME)
        FROM    DM_MST_VERSION A
                JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON  
                    A.YYYYMMDD = B.BASIS_YYYYMMDD
        WHERE   1=1
                AND A.VERSION_TYPE = 'MF_W'
                AND SUBSTRING(A.YYYYMMDD, 1, 4) = @v_thisyear
                AND A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'SUN')), 112) --당해년도 조회시 현재 기준 전주까지만 조회되도록 수정
    END
    ELSE
    BEGIN
        SELECT    @v_week           = MAX(A.YYYYMMDD + '-' + B.WEEK_NAME)
        --SELECT  MAX(A.YYYYMMDD + '-' + B.WEEK_NAME)
        FROM    DM_MST_VERSION A
                JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON  
                    A.YYYYMMDD = B.BASIS_YYYYMMDD
        WHERE   1=1
                AND A.VERSION_TYPE = 'MF_W'
                AND SUBSTRING(A.YYYYMMDD, 1, 4) = @p_yyyy
                AND B.WEEK_NAME = N'W' + @p_ww
                AND A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'SUN')), 112) --당해년도 조회시 현재 기준 전주까지만 조회되도록 수정
        GROUP BY B.WEEK_NAME
    END;

    SELECT  @v_isoyyyymmww    = C.ISO_YYYYMM + @p_ww
    FROM    SCM_SYS_CALENDAR_M C
    WHERE   SUBSTRING(C.ISO_YYYYMM, 1, 4) = @p_yyyy
        AND SUBSTRING(C.ISO_YYYYWW, 5, 2) = @p_ww

    --DECLARE @T_TBL  TABLE
    --(
	   --   DIVISION_ID					NVARCHAR(30)
	   -- , YYYYMMWW					NVARCHAR(8)
	   -- , DEPT_ID						NVARCHAR(50)
	   -- , END_CUSTOMER				NVARCHAR(50)
	   -- , SCM_SITE_ID					NVARCHAR(30)
	   -- , PROJECT_CODE				NVARCHAR(50)
	   -- , PROJECT_NAME				NVARCHAR(200)
	   -- , ITEM_ID		                NVARCHAR(50)
	   -- , ITEM_NAME		            NVARCHAR(150)
	   -- , NICK_NAME					NVARCHAR(50)
	   -- , FCST_TYPE		            NVARCHAR(20)
	   -- , BASIC_NICKNAME_CELL			NVARCHAR(150)
	   -- , CELL_QUANTITY		        NVARCHAR(30)
	   -- , TEAM_NAME_KO				NVARCHAR(150)
	   -- , OPERATION_GROUP				NVARCHAR(100)
	   -- , OPERATION_GROUP_NAME		NVARCHAR(100)
	   -- , CATEGORY_CODE				NVARCHAR(100)
	   -- , CATEGORY_NAME				NVARCHAR(100)
	   -- , RTF							NUMERIC(30,10)
	   -- , RTF_CELL					NUMERIC(30,10)
	   -- , RESULT						NUMERIC(30,10)
	   -- , RESULT_CELL					NUMERIC(30,10)
	   -- , RESULT_WITH_RTF				NUMERIC(30,10)
	   -- , RESULT_WITH_RTF_CELL		NUMERIC(30,10)
	   -- , RATE						NUMERIC(30,10)
	   -- , RATE_CELL					NUMERIC(30,10)
	   -- , RTF_VS						NUMERIC(30,10)
	   -- , RTF_GAP						NUMERIC(30,10)
	   -- , VERSION_SORT				NVARCHAR(100)
	   -- , RTF_REASON					NVARCHAR(MAX)
    --)

    print '@p_division : ' + @p_division
    print '@p_yyyy : ' + @p_yyyy
    print '@p_ww : ' + @p_ww
    print '@v_isoyyyymmww : ' + @v_isoyyyymmww

    print '@v_week : ' + @v_week
--return;
    -- SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_FOR_IF  : IF 만을 위해 Default 컬럼들로 이루어진 1개의 데이터만 리턴
    -- SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY         : UI 에서 보이기 위해 정렬순서등 4개의 데이터로 이루어진 데이터셋
    -- 위 두 개 쿼리는 최종 리턴 전까지 동일한 쿼리임
    --INSERT @T_TBL 

    /* 집계로직 제거 begin
        EXEC SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_FOR_IF
              @p_division        -- @p_division          NVARCHAR(30)
            , N'ALL'             -- @p_dept_id              NVARCHAR(4000)
            , N'ALL'             -- @p_end_customer         NVARCHAR(4000)
            , N''                -- @p_project_code         NVARCHAR(4000)
            , N''                -- @p_item_id              NVARCHAR(4000)
            , N'ALL'             -- @p_item_type            NVARCHAR(4000)
            , @v_week            -- @p_week                 NVARCHAR(50)
            , N'iamarock'        -- @p_created_by           NVARCHAR(4000)
            , N'ALL'             -- @p_biz_type             NVARCHAR(4000)
            , N'ALL'             -- @p_fcst_type            NVARCHAR(4000)
            , N'T'               -- @p_is_pre_week          NVARCHAR(50)
            , N''                -- @p_owner			    NVARCHAR(4000)
            , N'ICO'             -- @p_user_dept_id			NVARCHAR(50)
            , N'ADMIN'           -- @p_group_id				NVARCHAR(50)
    집계로직 제거 end*/
    
    IF @p_division = '82'
    BEGIN
        SELECT    DIVISION_ID
                , ISO_YYYYMMWW          AS YYYYMMWW
                , DEPT_ID
                , END_CUSTOMER
                , SCM_SITE_ID
                , PROJECT_CODE
                , PROJECT_NAME
                , ITEM_ID
                , ITEM_NAME
                , NICK_NAME
                , FCST_TYPE
                , BASIC_NICKNAME_CELL
                , CELL_QUANTITY
                , TEAM_NAME_KO
                , OPERATION_GROUP_NAME  AS BIZ_TYPE
                , CATEGORY_CODE
                , CATEGORY_NAME
                , RTF
                , RTF_CELL
                , RESULT
                , RESULT_CELL
                , RESULT_WITH_RTF
                , RESULT_WITH_RTF_CELL
                , RATE
                , RATE_CELL
                , RTF_VS
                , RTF_GAP
                , VERSION_SORT
                , RTF_REASON
        FROM    SCP_RPT_RTF_ARC A
        WHERE   A.ISO_YYYYMMWW  = @v_isoyyyymmww
            AND A.IS_PRE_WEEK   = 'T'
            AND A.DIVISION_ID   = @p_division;
    END
    ELSE
    BEGIN
        SELECT    DIVISION_ID
			    , ISO_YYYYMMWW
			    , IS_PRE_WEEK
			    , ITEM_ID
			    , ITEM_NAME
			    , NICK_NAME
			    , FCST_TYPE
			    , OWNER
			    , APPLICATION
			    , CELL_TYPE
			    , BASIC_NICKNAME_CELL
			    , FORECAST_INFO_CELL_MODEL
			    , FORECAST_INFO_ALL
			    , END_CUSTOMER
			    , PACK_GROUP
			    , SCM_SITE_ID
			    , PROJECT_CODE
			    , PROJECT_NAME
			    , DEPT_ID
			    , TEAM_NAME_KO
			    , UPPER_DEPT_ID
			    , DEPT_NAME_KO
			    , OPERATION_GROUP
			    , OPERATION_GROUP_NAME
			    , CATEGORY_CODE
			    , CATEGORY_NAME
			    , CELL_QUANTITY
			    , RTF
			    , RTF_CELL
			    , RESULT
			    , RESULT_CELL
			    , RESULT_WITH_RTF
			    , RESULT_WITH_RTF_CELL
			    , RATE
			    , RATE_CELL
			    , RTF_VS
			    , RTF_GAP
			    , RTF_REASON
			    , VERSION_SORT
			    , ATTRIBUTE1
			    , ATTRIBUTE2
			    , ATTRIBUTE3
			    , ATTRIBUTE4
			    , ATTRIBUTE5
			    , ATTRIBUTE6
			    , ATTRIBUTE7
			    , ATTRIBUTE8
			    , ATTRIBUTE9
			    , ATTRIBUTE10
			    , CREATED_BY
			    , CREATION_DATE
			    , LAST_UPDATED_BY
			    , LAST_UPDATE_DATE
        FROM    SCP_RPT_RTF_ARC A
        WHERE   A.ISO_YYYYMMWW = @v_isoyyyymmww
            AND A.IS_PRE_WEEK  = 'T'
            AND ((@p_division IS NULL OR @p_division ='') OR A.DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division, ',')))
    END
END
