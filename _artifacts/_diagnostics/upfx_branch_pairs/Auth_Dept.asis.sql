	IF 	@Code = 'Auth_Dept'



	    BEGIN

			DECLARE @v_admin  NVARCHAR(50);

			SET @v_admin = @Param2;



			---------------------------------------------------------------------------------

			--            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)

			---------------------------------------------------------------------------------

			DECLARE @v_admin_group_id  NVARCHAR(50);

			IF ISNULL((

						SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

							where LOOKUP_TYPE = 'GET_ADMIN_GROUP'

								AND VALID_YN = 'Y'

								AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)

								AND SEGMENT1 = @v_admin

					  ),0) > 0

				BEGIN

					SET @v_admin_group_id = 'ADMIN'

				END

			---------------------------------------------------------------------------------

			--            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)

			---------------------------------------------------------------------------------



			SELECT CASE WHEN @v_admin_group_id = 'ADMIN' THEN 'ADMIN'

			            ELSE @v_dept_id END AS CODE

				 , CASE WHEN @v_admin_group_id = 'ADMIN' THEN 'ADMIN'

			            ELSE @v_dept_id END AS NAME

	        FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

	        WHERE  U.USERID = @Param1

	    END;



	    /*

		-- 20200313 KHSONG 기존로직 주석처리

		BEGIN

			DECLARE @v_admin  NVARCHAR(10);



			SET @v_admin = @Param2;



			SELECT CASE WHEN @v_admin = 'ADMIN' OR @v_admin =  'DM ADMIN' THEN 'ADMIN'

			            ELSE @v_dept_id END AS CODE

				 , CASE WHEN @v_admin = 'ADMIN' OR @v_admin = 'DM ADMIN' THEN 'ADMIN'

			            ELSE @v_dept_id END AS NAME

	        FROM   [dbo].[TB_FX_User] U

	        WHERE  U.USERID = @Param1

	    END;

		*/



	/*===============================================

		용		 도:  FCST TYPE LOOKUP COMBO BOX

		사 용 화 면:  DM0003_DM_PLN_MKT_FCST	-	FCST_TYPE컬럼

		변       수:  -

		최 초 작 성:  2018. 04	.04

		개  발  자 :  Songdh70

		최 종 작 성:  -

		수  정  자 :  -

		수 정 사 항:

		===============================================*/
