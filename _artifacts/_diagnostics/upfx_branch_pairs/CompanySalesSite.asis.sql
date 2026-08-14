	ELSE IF @Code = 'CompanySalesSite'

	BEGIN	

		IF @PARAM2 IS NULL OR LEN(@PARAM2) = 0 OR @PARAM2 = '' 	-- 조회 했을 때 실행 (아래 IF문의 결과가 조회용 콤보박스가 된다.)

		BEGIN

			SELECT A.COMPANY_ID AS CODE

				 , A.COMPANY_ID AS NAME  

			  FROM SCM_MST_COMPANY_SN A WITH(NOLOCK)

		END

		ELSE	--@PARAM2[SCM_SITE_ID]가 존재하는 경우 해당 부분 쿼리 실행

		BEGIN

			SELECT A.COMPANY_ID AS CODE

				 , A.COMPANY_ID AS NAME  

			  FROM SCM_MST_SITE A WITH(NOLOCK)

			 WHERE (( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID = @Param1 ) 

			   AND (( @Param2 IS NULL OR  @Param2='' ) OR A.SCM_SITE_ID = @Param2 )

		END

	END	

	/*===============================================================================================================

	용		 도: [E20250919-001699]_INCOTERMS 데이터 처리 VALID 처리 

	사 용 화 면: DMF0005, DMF0004

	변       수: 

	최 초 작 성: 2025.09.30

	개  발  자 : JSSBAE

	최 종 작 성:

	수  정  자 :

	수 정 사 항:

	==================================================================================================================*/
