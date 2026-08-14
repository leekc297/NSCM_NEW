	IF @CODE = 'TeambyAll'

	BEGIN

	    IF @Param1 = ''

		    SET @Param1 = 'ALL';



		SELECT DISTINCT

               B.DEPT_ID       AS CODE

             , B.DEPT_NAME_KO  AS NAME

        FROM   [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)



	END



	/*===============================================

		용		 도:  SITE MASTER 화면 신규 ROW INSERT 시 END_CUSTOMER컬럼  조회

		사 용 화 면:  DM0004_SCM_MST_SITE		   -	MAIN SPREAD END_CUSTOMER 컬럼

		변       수:  --

		최 초 작 성:  2018. 02. 08

		개  발  자 :  진   준	희

		최 종 작 성:  2018. 02. 08

		수  정  자 :  진   준	희

		수 정 사 항:  신규 콤보 박스 추가

		===============================================*/
