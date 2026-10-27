

CREATE PROCEDURE [dbo].[PR_SCM_DECOMMISSION_AUTHORITY]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_DECOMMISSION_AUTHORITY
-- Param               :
-- Batch Period        : 24Hour
-- Description         :
--
-- Source System       : FP SDBc
-- Destination System  : FP SDB
-- Source Table        : TH_UIS_USER_LOG
-- Destination Table   : TH_UIS_USER_ROLE_RELATE, TH_UIS_USER_INSTANCE_RELATE(TH_UIS_USER_FACTORY_RELATE)
--
-- Create(Update) Date : 2019.02.19
--						 2019.07.16 PIYONG
--                       2019.08.08 kimcd
--                       2019.12.06 kimcd
--                       2020.01.02 kimcd
--						 2020.01.17 PIYONG

-- Author              : PIYONG

-- Version             : 1.0
--						 1.1 PIYONG  이지수 사원 요청으로 jeong.kd 은 제외
--                       1.2 kimcd   2019-08-08 MES 공정 PC 사용자는 권한 제거 대상에서 제외
--                       1.3 kimcd   2019-12-06 TH_UIS_USER_FACTORY_RELATE에서 TH_UIS_USER_INSTANCE_RELATE로 변경
--                       1.4 kimcd   2020-01-02 'shoon_lgc' , 'intework' 권한 정리 예외 추가
--						 1.5 PIYONG  권한 정리 예외 대상 LOOK UP 처리
--                       1.6 leejsthira2 비활성화 된 사용자 정보 삭제
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_DECOMMISSION_AUTHORITY'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================

/*
-- 미사용으로 주석처리
			UPDATE R
			   SET USE_AT_FLAG = 'N'
		      FROM TH_UIS_USER_ROLE_RELATE R
			 WHERE NOT EXISTS (
								SELECT 1
								  FROM [dbo].[TH_UIS_USER_LOG] U WITH(NOLOCK)
  								 WHERE U.USER_ID = R.USER_ID
								   AND U.INSERT_DTTM > DATEADD(MM, -3, GETDATE())
							  )							
			   AND ISNULL(R.UPDATE_DTTM,R.INSERT_DTTM) < DATEADD(MM, -3, GETDATE())
			   AND R.USE_AT_FLAG = 'Y'
			   AND NOT EXISTS ( --'jeong.kd', 'shoon_lgc' , 'intework' 
								SELECT 1 FROM SCM_SYS_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'DECOMMISSION_AUTHORITY' AND ACTIVE_FLAG= 'Y' AND SEGMENT1=  R.USER_ID
							  ) -- 2020-01-02 kimcd 'shoon_lgc' , 'intework' 권한 정리 예외 추가	--2020-01-17 PIYONG LOOKUP 처리
			   AND EXISTS ( SELECT 1
			                FROM   [dbo].[TH_UIS_USER_DETAIL] U WITH(NOLOCK)
							WHERE  U.USER_ID                 =  R.USER_ID
							AND    ISNULL(U.DEPARTMENT,'*') != 'GMES PC' )  -- kimcd   2019-08-08 MES 공정 PC 사용자는 권한 제거 대상에서 제외


			UPDATE F
			   SET USE_AT_FLAG = 'N'
  			  FROM -- TH_UIS_USER_FACTORY_RELATE F
			       TH_UIS_USER_INSTANCE_RELATE F -- 2019-12-06 kimcd 권한 체계 변경에 따른 Table 변경
			       ,TH_UIS_USER_ROLE_RELATE R
	 	     WHERE F.USER_ID = R.USER_ID
			   AND ISNULL(F.UPDATE_DTTM, F.INSERT_DTTM) < DATEADD(MM, -3, GETDATE())
			   AND F.USE_AT_FLAG = 'Y'
  			   AND R.USE_AT_FLAG = 'N'
			   AND NOT EXISTS (
							   SELECT 1
			                     FROM TH_UIS_USER_ROLE_RELATE UR
								WHERE UR.USER_ID = R.USER_ID
								  AND UR.USE_AT_FLAG = 'Y'			  
							  )
*/

			
			-- 비활성화 된 사용자 정보 삭제... 20240213
			DELETE
			FROM   FP_AMEND_USER_RESOURCES
			WHERE  USER_ID NOT IN (
				SELECT USERID
				FROM   LGCE_SCMDEV.DBO.TB_FX_USER A WITH(NOLOCK)
				WHERE  USEYN = 'Y'
			)
			;
			DELETE
			FROM   TH_UIS_USER_INSTANCE_RELATE
			WHERE  USER_ID NOT IN (
				SELECT USERID
				FROM   LGCE_SCMDEV.DBO.TB_FX_USER A WITH(NOLOCK)
				WHERE  USEYN = 'Y'
			)
			;
			DELETE
			FROM   TH_UIS_USER_AMEND_MEA_RELATE
			WHERE  USER_ID NOT IN (
				SELECT USERID
				FROM   LGCE_SCMDEV.DBO.TB_FX_USER A WITH(NOLOCK)
				WHERE  USEYN = 'Y'
			)
			;
			DELETE
			FROM   TH_UIS_USER_DETAIL
			WHERE  USER_ID NOT IN (
				SELECT USERID
				FROM   LGCE_SCMDEV.DBO.TB_FX_USER A WITH(NOLOCK)
				WHERE  USEYN = 'Y'
			)
			AND    ISNULL(DEPARTMENT,'*') != 'GMES PC'
			;


		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
