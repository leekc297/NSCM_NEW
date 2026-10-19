/*
 * Program ID   : SCP0099_SAVE_LONGTERM_PLAN_RELEASE
 * Description  : 중장기 계획 릴리즈
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/03   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 중장기 계획 릴리즈
 * 2023/08/03   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 2차 개발
								=>SCP_ANL_BUSINESS_PLAN_RTF_DM 저장시 PLAN_ID 채번을 ROW별 증가가 아니라 RELESE시에만 동일값으로 저장되게
 * 2023/09/07   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PLANID 채번규칙 변경 24BP_SCP_2023_W36_V04_004
 * 2023/09/08   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Cell 반제품 코드 → 완제품 코드로 변환
 * 2023/09/12   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - MASS20253-A2 생산 계획에서 MFS* 계획 수량 차감하여 저장
 * 2023/09/18   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - MASS20253-A2 일 경우에 반제품 코드 → 완제품 코드로 변환로직 수정
 * ex)
    EXEC SCP0099_SAVE_LONGTERM_PLAN_RELEASE @p_division_id='81',@v_plan_id='20230823_001' , @p_user_id='KJJ0070'
 */

CREATE PROCEDURE [dbo].[SCP0099_SAVE_LONGTERM_PLAN_RELEASE]
	
	 @p_division_id				NVARCHAR(MAX)
	,@v_plan_id				NVARCHAR(MAX)
	,@p_user_id					NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0099_SAVE_LONGTERM_PLAN_RELEASE]';
    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	BEGIN TRY

	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	

	UPDATE SCP_ANL_BUSINESS_PLAN_INFO
	SET
	RELEASE_YN = 'Y'
	,LAST_UPDATE_DATE = GETDATE()
	,LAST_UPDATED_BY = @p_user_id
	WHERE DIVISION_ID = @p_division_id
	--AND PLAN_ID = @v_plan_id
	AND PLAN_ID IN (SELECT TOKEN  FROM DBO.STRING_SPLIT(@v_plan_id, ','))
	
	DECLARE @ROWCNT INT
	SET @ROWCNT = @@ROWCOUNT

	/*릴리즈 된 것들을 DM 연동 테이블에 밀어넣기
	1.PLAN_ID를 그냥 넣지 말고 추가로 채번하여 _001 형식으로 증가하게
	2.무조건 insert
	*/

	--NEW PLANID 채번===================================
	--형식 : 기존 PLAN_ID (24BP_SCP_2023_W36_V04) + _001
	--PLAN_ID + '_' + FORMAT(ROW_NUMBER() OVER(PARTITION BY PLAN_ID ORDER BY PLAN_ID), '000'),
	DECLARE @CUR_PLAN_ID NVARCHAR(30)

	DECLARE @TMP_PLAN_ID NVARCHAR(MAX)

	DECLARE @SEQ NVARCHAR(MAX)  
	DECLARE @MAXTMP NVARCHAR(MAX)

	DECLARE CUR CURSOR FOR
	SELECT TOKEN  FROM DBO.STRING_SPLIT(@v_plan_id, ',')


	OPEN CUR 
	FETCH NEXT FROM CUR INTO       
	@CUR_PLAN_ID

	WHILE @@FETCH_STATUS = 0
	BEGIN


		SET @MAXTMP = (SELECT MAX(PLAN_ID) FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WITH(NOLOCK) WHERE DIVISION_ID = @P_DIVISION_ID AND ATTRIBUTE1 = @CUR_PLAN_ID)

		PRINT @CUR_PLAN_ID

		IF (ISNULL(@MAXTMP, '') = '')
		BEGIN
			SET @SEQ = '_001'
		END
		ELSE
		BEGIN
			DECLARE @V_TMPSEQ  INT
			SET @V_TMPSEQ = CONVERT(INTEGER, SUBSTRING(@MAXTMP, 23,3)) + 1

			DECLARE @V_PADDINGVAL  NVARCHAR(MAX)

			SET @SEQ = '_' + FORMAT(@V_TMPSEQ,'000')
		END

		SET @TMP_PLAN_ID = @CUR_PLAN_ID + @SEQ


	INSERT INTO SCP_ANL_BUSINESS_PLAN_RTF_DM
	(	[DIVISION_ID]
     , [PLAN_ID]
      ,[SALES_SITE]
      ,[BIZ_TYPE]
      ,[CUST]
      ,[PROJECT]
      ,[PROJECT_DESC]
      ,[MODEL]
      ,[MODEL_CODE]
      ,[CELL_NICKNAME]
      ,[CELL_CODE]
      ,[ELECTRODE]
      ,[CELL]
      ,[PACK]
      ,[UNIT]
      ,[INCOTERMS]
      ,[MEASURE]
      ,[M1_QTY]
      ,[M2_QTY]
      ,[M3_QTY]
      ,[M4_QTY]
      ,[M5_QTY]
      ,[M6_QTY]
      ,[M7_QTY]
      ,[M8_QTY]
      ,[M9_QTY]
      ,[M10_QTY]
      ,[M11_QTY]
      ,[M12_QTY]
      ,[M13_QTY]
      ,[M14_QTY]
      ,[M15_QTY]
      ,[M16_QTY]
      ,[M17_QTY]
      ,[M18_QTY]
      ,[M19_QTY]
      ,[M20_QTY]
      ,[M21_QTY]
      ,[M22_QTY]
      ,[M23_QTY]
      ,[M24_QTY]
      ,[M25_QTY]
      ,[M26_QTY]
      ,[M27_QTY]
      ,[M28_QTY]
      ,[M29_QTY]
      ,[M30_QTY]
      ,[M31_QTY]
      ,[M32_QTY]
      ,[M33_QTY]
      ,[M34_QTY]
      ,[M35_QTY]
      ,[M36_QTY]
      ,[M37_QTY]
      ,[M38_QTY]
      ,[M39_QTY]
      ,[M40_QTY]
      ,[M41_QTY]
      ,[M42_QTY]
      ,[M43_QTY]
      ,[M44_QTY]
      ,[M45_QTY]
      ,[M46_QTY]
      ,[M47_QTY]
      ,[M48_QTY]
      ,[M49_QTY]
      ,[M50_QTY]
      ,[M51_QTY]
      ,[M52_QTY]
      ,[M53_QTY]
      ,[M54_QTY]
      ,[M55_QTY]
      ,[M56_QTY]
      ,[M57_QTY]
      ,[M58_QTY]
      ,[M59_QTY]
      ,[M60_QTY]
	  ,ATTRIBUTE1
	  ,CREATED_BY
	  ,CREATION_DATE
	  ,LAST_UPDATED_BY
	  ,LAST_UPDATE_DATE
		,[ATTRIBUTE2]
		,[ATTRIBUTE3]
		,[ATTRIBUTE4]
		,[ATTRIBUTE5]
		,[ATTRIBUTE6]
		,[ATTRIBUTE7]
		,[ATTRIBUTE8]
		,[ATTRIBUTE9]
		,[ATTRIBUTE10]
		,[ATTRIBUTE11]
		,[ATTRIBUTE12]
		,[ATTRIBUTE13]
		,[ATTRIBUTE14]
		,[ATTRIBUTE15]	  
	  )
	SELECT DIVISION_ID
	, @TMP_PLAN_ID
	,SALES_SITE
      ,BIZ_TYPE
      ,CUST
      ,PROJECT
      ,PROJECT_DESC
      ,MODEL
      ,MODEL_CODE
      ,CELL_NICKNAME
      ,CELL_CODE
      ,ELECTRODE
      ,CELL
      ,PACK
      ,UNIT
      ,INCOTERMS
      ,MEASURE
      ,M1_QTY
      ,M2_QTY
      ,M3_QTY
      ,M4_QTY
      ,M5_QTY
      ,M6_QTY
      ,M7_QTY
      ,M8_QTY
      ,M9_QTY
      ,M10_QTY
      ,M11_QTY
      ,M12_QTY
      ,M13_QTY
      ,M14_QTY
      ,M15_QTY
      ,M16_QTY
      ,M17_QTY
      ,M18_QTY
      ,M19_QTY
      ,M20_QTY
      ,M21_QTY
      ,M22_QTY
      ,M23_QTY
      ,M24_QTY
      ,M25_QTY
      ,M26_QTY
      ,M27_QTY
      ,M28_QTY
      ,M29_QTY
      ,M30_QTY
      ,M31_QTY
      ,M32_QTY
      ,M33_QTY
      ,M34_QTY
      ,M35_QTY
      ,M36_QTY
      ,M37_QTY
      ,M38_QTY
      ,M39_QTY
      ,M40_QTY
      ,M41_QTY
      ,M42_QTY
      ,M43_QTY
      ,M44_QTY
      ,M45_QTY
      ,M46_QTY
      ,M47_QTY
      ,M48_QTY
      ,M49_QTY
      ,M50_QTY
      ,M51_QTY
      ,M52_QTY
      ,M53_QTY
      ,M54_QTY
      ,M55_QTY
      ,M56_QTY
      ,M57_QTY
      ,M58_QTY
      ,M59_QTY
      ,M60_QTY
	  ,PLAN_ID
	  ,@p_user_id
	  ,GETDATE()
	  ,@p_user_id
	  ,GETDATE()
		,[ATTRIBUTE2]
		,[ATTRIBUTE3]
		,[ATTRIBUTE4]
		,[ATTRIBUTE5]
		,[ATTRIBUTE6]
		,[ATTRIBUTE7]
		,[ATTRIBUTE8]
		,[ATTRIBUTE9]
		,[ATTRIBUTE10]
		,[ATTRIBUTE11]
		,[ATTRIBUTE12]
		,[ATTRIBUTE13]
		,[ATTRIBUTE14]
		,[ATTRIBUTE15]
	  FROM SCP_ANL_BUSINESS_PLAN_RTF
	  WHERE DIVISION_ID = @p_division_id
	  AND PLAN_ID = @CUR_PLAN_ID

    SET @n_log_count = @n_log_count + @@ROWCOUNT;
	
	FETCH NEXT FROM CUR INTO
	@CUR_PLAN_ID
	END

	CLOSE CUR
	DEALLOCATE CUR
	
	SET @v_log_type = 'TXN';
	SET @v_log_message = 'SCP_ANL_BUSINESS_PLAN_RTF : Insert';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	/*
	PRODUCTION 연동테이블에 넣기

	1.attr1에 오리진 div
	=>EE로 시작하면 SCM_MST_PLANT_SN 에 plant_code만으로 조인걸어서 찾음
	=>나머지는 SCM_MST_DIVISION에서 attr3을 사용

	2.attr2에 우리 planid 넣음

	3.plan_id는 별도 채번
	div별로 릴리즈할때마다 증가하게

	*/

	--PLAN_ID 별도 채번===============================================================
	--형식:YYYYMMDD_001

	DECLARE @XIF_PLAN_ID NVARCHAR(MAX)

	DECLARE @XIF_YYYYMMDD NVARCHAR(MAX)
	SET @XIF_YYYYMMDD = (select convert(varchar(8), getdate(), 112))


	DECLARE @XIF_SEQ NVARCHAR(MAX)  
	DECLARE @XIF_MAXTMP NVARCHAR(MAX)

	SET @XIF_MAXTMP = (SELECT MAX(PLAN_ID) FROM XIF_BPS_PROD_PLAN_S_SN WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND PLAN_ID LIKE '%' + @XIF_YYYYMMDD + '%')


	IF (ISNULL(@XIF_MAXTMP, '') = '')
	BEGIN
		SET @XIF_SEQ = '_001'
	END
	ELSE
	BEGIN
		DECLARE @XIF_TMPSEQ  INT
		SET @XIF_TMPSEQ = CONVERT(INTEGER, SUBSTRING(@XIF_MAXTMP, 10,3)) + 1


		SET @XIF_SEQ = '_' + FORMAT(@XIF_TMPSEQ,'000')
	END

	SET @XIF_PLAN_ID = @XIF_YYYYMMDD + @XIF_SEQ
-----------------------------------------------------------------------------------

/*
MASS20253-A2 생산 계획에서 MFS* 계획 수량 차감하여 저장

1.seq 추가하여 TMEP 테이블에 저장(#TMP_PRODPLAN_INFO)
2.수정되어야 할 QTY 계산하여  TMEP 테이블에 저장(#TMP_UPDATEQTY_INFO)
3.#TMP_PRODPLAN_INFO 의 MASS20253-A2 모델의 수량을 계산된 수량(#TMP_UPDATEQTY_INFO)으로 업데이트 한다
4.MASS20253-A2 모델 중 seq가 1이 아닌 것들을 삭제한다
5. 최종데이터를 XIF_BPS_PROD_PLAN_S_SN에 insert 한다

*/
-----------------------------------------------------------------------------------

/*
0.반제품_완제품 변경
*/

IF OBJECT_ID('TEMPDB..#TMP_CHGMODEL') IS NOT NULL
	DROP TABLE #TMP_CHGMODEL;
  ;with prod_assy_map as (
	select m.division_id
		  ,m.plant_id
		  ,m.item_id_assy
		  ,m.item_id_prod 
		  ,m.cell_type 
		  ,cp.tco_cell_yn 
		  ,row_number() over (partition by m.division_id
										  ,m.plant_id
										  ,m.item_id_assy
							  order by case when m.item_id_assy = 'MASS20253-A2' and cp.tco_cell_yn = 'N' then 1
									        when cp.tco_cell_yn = 'Y' then 2
									        else 3
									    end ) as rn 
	from SCP_MST_CELL_PROD_ASSY_MAP m with(nolock)
		 inner join scp_mst_final_item cp with(nolock)
				 on cp.division_id = m.division_id
				and cp.item_id     = m.item_id_prod
				and cp.attribute8  = 'CP'
	where 1=1
)
select *
INTO #TMP_CHGMODEL
from prod_assy_map m with(nolock)
where 1=1
  and m.rn = 1


	/*
	1.seq 추가하여 TMEP 테이블에 저장(#TMP_PRODPLAN_INFO)
	*/
	IF OBJECT_ID('TEMPDB..#TMP_PRODPLAN_INFO') IS NOT NULL
		DROP TABLE #TMP_PRODPLAN_INFO;

	SELECT 
			DIVISION_ID
			,XIF_PLAN_ID
			, SCENARIO_TYPE 
			, PLN_PERIOD_YYYYMM
			,SALE_VER
			,OPERATION_GROUP
			,SITE_ID
			, SITE_ID PLANT_CODE --SITE_ID 바로 사용(실제 내용은 PLANT_ID)
			, OVSENTT_CD 
			,BUILDING
			,LINE_ID
			,NICKNAME
			,MODEL
			,CHANGE_MODEL
			,CUST
			,PROJECT
			,UNIT
			,MEASURE
			,YYYYMM
			,QTY 
			,ROW_NUMBER() OVER (PARTITION BY YYYYMM, MODEL ORDER BY YYYYMM ASC)  SEQ
			,ORIGIN_DIV --오리진 div
			,PLAN_ID --우리 planid
	INTO #TMP_PRODPLAN_INFO
	FROM
	(
		SELECT
			DIVISION_ID
			,@XIF_PLAN_ID XIF_PLAN_ID
			, 'BP' SCENARIO_TYPE 
			, PLAN_START_DATE PLN_PERIOD_YYYYMM
			,SALE_VER
			,OPERATION_GROUP
			,SITE_ID
			, SITE_ID PLANT_CODE --SITE_ID 바로 사용(실제 내용은 PLANT_ID)
			, OVSENTT_CD 
			,BUILDING
			,LINE_ID
			,NICKNAME
			,MODEL
			,CHANGE_MODEL
			,CUST
			,PROJECT
			,UNIT
			,MEASURE
			,CONVERT(VARCHAR(6), DATEADD(MONTH, (SELECT TOP 1 CONVERT(INT,REPLACE(TOKEN, 'M', '')) - 1 FROM STRING_SPLIT(QTYTMP, '_')), CONVERT(DATE, PLAN_START_DATE + '01')), 112) YYYYMM
			,QTY 
			,ORIGIN_DIV --오리진 div
			,PLAN_ID --우리 planid
		FROM
		(
			SELECT R.*, I.SALE_VER, I.PLAN_START_DATE
			--,CASE WHEN ISNULL(I.ATTRIBUTE2, '') = '' THEN CONVERT(VARCHAR(6), GETDATE(), 112) ELSE SUBSTRING(I.ATTRIBUTE2, 1, 6) END PLN_PERIOD_YYYYMM --INFO의 ATTRIBUTE2  있으면 쓰고 없으면 GETDATE()를 사용
			,  CASE WHEN R.attribute3 = 'Y' THEN (SELECT TOP 1 COMPANY_ID  FROM SCM_MST_SITE WITH(NOLOCK) WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_ID LIKE R.SITE_ID+'%') 
				   ELSE (SELECT TOP 1 COMPANY_ID  FROM SCM_MST_PLANT_SN WITH(NOLOCK) WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_ID = R.SITE_ID) 
			  END AS OVSENTT_CD
			--,S.COMPANY_ID OVSENTT_CD
			, CASE WHEN SUBSTRING(@p_division_id, 1, 2) = 'EE' THEN
					(SELECT TOP 1 DIVISION_ID FROM SCM_MST_PLANT_SN WITH(NOLOCK) WHERE PLANT_ID = R.SITE_ID)
				ELSE (SELECT TOP 1 ATTRIBUTE3 from SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id)
				END ORIGIN_DIV
				,ISNULL((SELECT MIN(ITEM_ID_PROD) FROM #TMP_CHGMODEL 
				WHERE ITEM_ID_ASSY = R.MODEL AND PLANT_ID = R.SITE_ID)
				,R.MODEL) CHANGE_MODEL	-- Cell 반제품 코드 → 완제품 코드로 변환		
			  FROM SCP_ANL_BUSINESS_PLAN_PROD R WITH(NOLOCK)
			  INNER JOIN SCP_ANL_BUSINESS_PLAN_INFO I WITH(NOLOCK)
				ON R.DIVISION_ID = I.DIVISION_ID
				AND R.PLAN_ID = I.PLAN_ID
			 -- INNER JOIN SCM_MST_PLANT_SN S
				--ON R.DIVISION_ID = S.DIVISION_ID
				--AND R.SITE_ID = S.PLANT_ID		
				WHERE R.DIVISION_ID = @p_division_id
				and r.PLAN_ID IN (SELECT TOKEN  FROM DBO.STRING_SPLIT(@v_plan_id, ','))
				and I.RELEASE_YN = 'Y' --릴리즈 된것들만 가져오기
		 
		) RAWDATA
		UNPIVOT
		(
			QTY FOR QTYTMP IN (
				M1_QTY,M2_QTY,M3_QTY,M4_QTY,M5_QTY,M6_QTY,M7_QTY,M8_QTY,M9_QTY,M10_QTY
				,M11_QTY,M12_QTY,M13_QTY,M14_QTY,M15_QTY,M16_QTY,M17_QTY,M18_QTY,M19_QTY,M20_QTY
				,M21_QTY,M22_QTY,M23_QTY,M24_QTY,M25_QTY,M26_QTY,M27_QTY,M28_QTY,M29_QTY,M30_QTY
				,M31_QTY,M32_QTY,M33_QTY,M34_QTY,M35_QTY,M36_QTY,M37_QTY,M38_QTY,M39_QTY,M40_QTY
				,M41_QTY,M42_QTY,M43_QTY,M44_QTY,M45_QTY,M46_QTY,M47_QTY,M48_QTY,M49_QTY,M50_QTY
				,M51_QTY,M52_QTY,M53_QTY,M54_QTY,M55_QTY,M56_QTY,M57_QTY,M58_QTY,M59_QTY,M60_QTY
			)
		) AS UNPIVOT_DATA
		WHERE QTY > 0 --0 이상인 것들만
	) A

	-----------------------------------------------------------------------------------

	/*
	2.수정되어야 할 QTY 계산하여  TMEP 테이블에 저장(#TMP_UPDATEQTY_INFO)
	*/
	IF OBJECT_ID('TEMPDB..#TMP_UPDATEQTY_INFO') IS NOT NULL
		DROP TABLE #TMP_UPDATEQTY_INFO;

	SELECT 
	CA1.YYYYMM, CA1_QTY - CA2_QTY QTY
	INTO #TMP_UPDATEQTY_INFO
	FROM
	(
		SELECT YYYYMM, SUM(QTY) CA1_QTY FROM #TMP_PRODPLAN_INFO S WITH(NOLOCK)
		WHERE MODEL = 'MASS20253-A2'
		GROUP BY S.YYYYMM
	) CA1
	INNER JOIN 
	(
		SELECT YYYYMM, SUM(QTY) CA2_QTY FROM #TMP_PRODPLAN_INFO WITH(NOLOCK)
		WHERE MODEL LIKE 'MFS%'
		GROUP BY YYYYMM
	) CA2
	ON CA1.YYYYMM = CA2.YYYYMM

	-----------------------------------------------------------------------------------

	/*
	3.#TMP_PRODPLAN_INFO 의 MASS20253-A2 모델의 수량을 계산된 수량(#TMP_UPDATEQTY_INFO)으로 업데이트 한다
	*/

	UPDATE #TMP_PRODPLAN_INFO
	SET
	QTY = B.QTY
	FROM #TMP_PRODPLAN_INFO A
	INNER JOIN #TMP_UPDATEQTY_INFO B
		ON A.YYYYMM = B.YYYYMM
	WHERE A.MODEL = 'MASS20253-A2'
		AND A.SEQ = 1

	-----------------------------------------------------------------------------------

	/*
	4.수량을 수정한 MASS20253-A2 모델 중 seq가 1이 아닌 것들을 삭제한다
	*/
	DELETE FROM #TMP_PRODPLAN_INFO
	FROM #TMP_PRODPLAN_INFO A
	INNER JOIN #TMP_UPDATEQTY_INFO B
		ON A.YYYYMM = B.YYYYMM
	WHERE MODEL = 'MASS20253-A2'
	AND SEQ <> 1

	-----------------------------------------------------------------------------------

	/*
	5. 최종데이터를 XIF_BPS_PROD_PLAN_S_SN에 insert 한다
	*/

	INSERT INTO XIF_BPS_PROD_PLAN_S_SN
	(
		DIVISION_ID
		,PLAN_ID
		, SCENARIO_TYPE 
		, PLN_PERIOD_YYYYMM
		,SALE_VER
		,OPERATION_GROUP
		,SITE_ID
		, PLANT_CODE
		, OVSENTT_CD 
		,BUILDING
		,LINE_ID
		,NICKNAME
		,MODEL
		,CUST
		,PROJECT
		,UNIT
		,MEASURE
		,YYYYMM
		,QTY 
		,[CREATED_BY]
		,[CREATION_DATE]
		,[LAST_UPDATED_BY]
		,[LAST_UPDATE_DATE]
		,[KEYVALUE]
		,[ATTRIBUTE1]
		,[ATTRIBUTE2]
		,[ATTRIBUTE3]
		,[ATTRIBUTE4]
		,[ATTRIBUTE5]
		,[ATTRIBUTE6]
		,[ATTRIBUTE7]
		,[ATTRIBUTE8]
		,[ATTRIBUTE9]
		,[ATTRIBUTE10]
		,[ATTRIBUTE11]
		,[ATTRIBUTE12]
		,[ATTRIBUTE13]
		,[ATTRIBUTE14]
		,[ATTRIBUTE15]
	)
	SELECT
		DIVISION_ID
		,XIF_PLAN_ID
		, SCENARIO_TYPE 
		, PLN_PERIOD_YYYYMM
		,SALE_VER
		,OPERATION_GROUP
		,SITE_ID
		, SITE_ID PLANT_CODE --SITE_ID 바로 사용(실제 내용은 PLANT_ID)
		, OVSENTT_CD 
		,BUILDING
		,LINE_ID
		,NICKNAME
		,CHANGE_MODEL
		,CUST
		,PROJECT
		,UNIT
		,MEASURE
		,YYYYMM
		,QTY 
		,@p_user_id
		,GETDATE()
		,@p_user_id
		,GETDATE()
		,SEQ
		,ORIGIN_DIV --오리진 div
		,PLAN_ID --우리 planid
		,MODEL --원래모델명		
		,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	FROM
	#TMP_PRODPLAN_INFO


/*

	INSERT INTO XIF_BPS_PROD_PLAN_S_SN
	(
		DIVISION_ID
		,PLAN_ID
		, SCENARIO_TYPE 
		, PLN_PERIOD_YYYYMM
		,SALE_VER
		,OPERATION_GROUP
		,SITE_ID
		, PLANT_CODE
		, OVSENTT_CD 
		,BUILDING
		,LINE_ID
		,NICKNAME
		,MODEL
		,CUST
		,PROJECT
		,UNIT
		,MEASURE
		,YYYYMM
		,QTY 
		,[CREATED_BY]
		,[CREATION_DATE]
		,[LAST_UPDATED_BY]
		,[LAST_UPDATE_DATE]
		,[KEYVALUE]
		,[ATTRIBUTE1]
		,[ATTRIBUTE2]
		,[ATTRIBUTE3]
		,[ATTRIBUTE4]
		,[ATTRIBUTE5]
		,[ATTRIBUTE6]
		,[ATTRIBUTE7]
		,[ATTRIBUTE8]
		,[ATTRIBUTE9]
		,[ATTRIBUTE10]
		,[ATTRIBUTE11]
		,[ATTRIBUTE12]
		,[ATTRIBUTE13]
		,[ATTRIBUTE14]
		,[ATTRIBUTE15]
	)
	SELECT
		DIVISION_ID
		,@XIF_PLAN_ID
		, 'BP' SCENARIO_TYPE 
		, PLAN_START_DATE PLN_PERIOD_YYYYMM
		,SALE_VER
		,OPERATION_GROUP
		,SITE_ID
		, SITE_ID PLANT_CODE --SITE_ID 바로 사용(실제 내용은 PLANT_ID)
		, OVSENTT_CD 
		,BUILDING
		,LINE_ID
		,NICKNAME
		--,MODEL
		,MODEL_1
		,CUST
		,PROJECT
		,UNIT
		,MEASURE
		,CONVERT(VARCHAR(6), DATEADD(MONTH, (SELECT TOP 1 CONVERT(INT,REPLACE(TOKEN, 'M', '')) - 1 FROM STRING_SPLIT(QTYTMP, '_')), CONVERT(DATE, PLAN_START_DATE + '01')), 112) YYYYMM
		,QTY 
		,@p_user_id
		,GETDATE()
		,@p_user_id
		,GETDATE()
		,NULL
		,ORIGIN_DIV --오리진 div
		,PLAN_ID --우리 planid
		,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	FROM
	(
		SELECT R.*, I.SALE_VER, I.PLAN_START_DATE
		--,CASE WHEN ISNULL(I.ATTRIBUTE2, '') = '' THEN CONVERT(VARCHAR(6), GETDATE(), 112) ELSE SUBSTRING(I.ATTRIBUTE2, 1, 6) END PLN_PERIOD_YYYYMM --INFO의 ATTRIBUTE2  있으면 쓰고 없으면 GETDATE()를 사용
		,  CASE WHEN R.attribute3 = 'Y' THEN (SELECT TOP 1 COMPANY_ID  FROM SCM_MST_SITE WITH(NOLOCK) WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_ID LIKE R.SITE_ID+'%') 
		       ELSE (SELECT TOP 1 COMPANY_ID  FROM SCM_MST_PLANT_SN WITH(NOLOCK) WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_ID = R.SITE_ID) 
		  END AS OVSENTT_CD
		--,S.COMPANY_ID OVSENTT_CD
		, CASE WHEN SUBSTRING(@p_division_id, 1, 2) = 'EE' THEN
				(SELECT TOP 1 DIVISION_ID FROM SCM_MST_PLANT_SN WITH(NOLOCK) WHERE PLANT_ID = R.SITE_ID)
			ELSE (SELECT TOP 1 ATTRIBUTE3 from SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id)
			END ORIGIN_DIV
			,ISNULL((SELECT MIN(ITEM_ID_PROD) FROM SCP_MST_CELL_PROD_ASSY_MAP 
			WHERE ITEM_ID_ASSY = R.MODEL AND PLANT_ID = R.SITE_ID)
			,R.MODEL) MODEL_1	-- Cell 반제품 코드 → 완제품 코드로 변환		
		  FROM SCP_ANL_BUSINESS_PLAN_PROD R WITH(NOLOCK)
		  INNER JOIN SCP_ANL_BUSINESS_PLAN_INFO I WITH(NOLOCK)
			ON R.DIVISION_ID = I.DIVISION_ID
			AND R.PLAN_ID = I.PLAN_ID
		 -- INNER JOIN SCM_MST_PLANT_SN S
			--ON R.DIVISION_ID = S.DIVISION_ID
			--AND R.SITE_ID = S.PLANT_ID		
			WHERE R.DIVISION_ID = @p_division_id
			and r.PLAN_ID IN (SELECT TOKEN  FROM DBO.STRING_SPLIT(@v_plan_id, ','))
			and I.RELEASE_YN = 'Y' --릴리즈 된것들만 가져오기
		 
	) RAWDATA
	UNPIVOT
	(
		QTY FOR QTYTMP IN (
			M1_QTY,M2_QTY,M3_QTY,M4_QTY,M5_QTY,M6_QTY,M7_QTY,M8_QTY,M9_QTY,M10_QTY
			,M11_QTY,M12_QTY,M13_QTY,M14_QTY,M15_QTY,M16_QTY,M17_QTY,M18_QTY,M19_QTY,M20_QTY
			,M21_QTY,M22_QTY,M23_QTY,M24_QTY,M25_QTY,M26_QTY,M27_QTY,M28_QTY,M29_QTY,M30_QTY
			,M31_QTY,M32_QTY,M33_QTY,M34_QTY,M35_QTY,M36_QTY,M37_QTY,M38_QTY,M39_QTY,M40_QTY
			,M41_QTY,M42_QTY,M43_QTY,M44_QTY,M45_QTY,M46_QTY,M47_QTY,M48_QTY,M49_QTY,M50_QTY
			,M51_QTY,M52_QTY,M53_QTY,M54_QTY,M55_QTY,M56_QTY,M57_QTY,M58_QTY,M59_QTY,M60_QTY
		)
	) AS UNPIVOT_DATA
	WHERE QTY > 0 --0 이상인 것들만
	*/


    SET @n_log_count = @@ROWCOUNT;
	SET @v_log_type = 'TXN';
	SET @v_log_message = 'XIF_BPS_PROD_PLAN_S_SN : Insert';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	----------------------------------------------------
	-- DM RTF Measure 생성 Call : 임시로 막음 : DM/SCP PI 협의 후 처리 필요
	----------------------------------------------------
	--EXEC DMF0051_1_CREATE_RTF_MEASURE @p_division_id ;

	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 결과코드, 결과 카운트 반환

	SELECT  'S' AS result_code,  @ROWCNT AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN

			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END
