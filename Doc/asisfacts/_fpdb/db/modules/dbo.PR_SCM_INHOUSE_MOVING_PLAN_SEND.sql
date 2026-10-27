CREATE PROCEDURE [dbo].[PR_SCM_INHOUSE_MOVING_PLAN_SEND]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_INHOUSE_MOVING_PLAN_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : RELEASE 정보  Mailing
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : FP_CELL_DELIVERY_PLAN_H
-- Destination Table   : 
--
-- Create Date		   : 2018.12.19 PIYONG
-- Update Date		   : 

-- Author              : 
-- Version             : 1.0

-- ================================================================================================
-- PARAMETER
@instance_id	NVARCHAR(100) = 'KR_FORM_A',
@plan_id		NVARCHAR(MAX) =  '-'


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_INHOUSE_MOVING_PLAN_SEND'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @TABLE_BODY            NVARCHAR(MAX)
	DECLARE @TABLE_CONTENTS        NVARCHAR(MAX)	 = ''
	DECLARE @TABLE_HEAD_CONTENT    NVARCHAR(MAX)
	DECLARE @MAIL_CONTENT          NVARCHAR(MAX)
	DECLARE @MAIL_TITLE            NVARCHAR(MAX)

	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(MAX)
	DECLARE @ADDR_LIST			   NVARCHAR(4000)

	DECLARE @MAIL_WIDTH			   NUMERIC = 1450;		-- 메일 화면 넓이
	DECLARE @DATEDIFF_CNT		   INT = 0;				-- 최소 와 마지막 날짜의 차
	DECLARE @MAIL_CNT			   INT = 0;	
	DECLARE @DATEMIN			   NVARCHAR(50);		-- 최소 날짜
	DECLARE @DATEMAX			   NVARCHAR(50);		-- 마지막 날짜
	DECLARE @LIMIT_DATEMIN		   NVARCHAR(50);		-- 최소 기준 날짜
	DECLARE @LIMIT_DATEMAX		   NVARCHAR(50);		-- 15일 기준 마지막 날짜
	DECLARE @DATE_ID			   NVARCHAR(10);		-- 날짜 목록
	DECLARE @PIVOT_TD_DATE         NVARCHAR(MAX) = ''	-- MAIL 제목 날짜
	DECLARE @PIVOT_CON_DATE        NVARCHAR(MAX) = ''	-- MAIL 내용 날짜
	DECLARE @PIVOT_DATE            NVARCHAR(MAX)		-- PIVOT 조건 날짜
	DECLARE @PIVOT_SEL_DATE        NVARCHAR(MAX)		-- PIVOT 조회 날짜

	DECLARE @ParmStr			   NVARCHAR(256)		-- 동적 쿼리 변수
	DECLARE @DATA_QUERY            NVARCHAR(MAX) = ''	-- 동적 쿼리

	DECLARE @InstanceName			NVARCHAR(4000)	
	DECLARE @BEFOR_InstanceName		NVARCHAR(4000) = ''
	DECLARE @CellCode				NVARCHAR(150)
	DECLARE @NickName				NVARCHAR(50)
	DECLARE @ERP_Sloc				NVARCHAR(30)
	DECLARE @Transport				NVARCHAR(30)
	DECLARE @Market					NVARCHAR(10)
	DECLARE @COL1					NVARCHAR(31)
	DECLARE @COL2					NVARCHAR(31)
	DECLARE @COL3					NVARCHAR(31)
	DECLARE @COL4					NVARCHAR(31)
	DECLARE @COL5					NVARCHAR(31)
	DECLARE @COL6					NVARCHAR(31)
	DECLARE @COL7					NVARCHAR(31)
	DECLARE @COL8					NVARCHAR(31)
	DECLARE @COL9					NVARCHAR(31)
	DECLARE @COL10					NVARCHAR(31)
	DECLARE @COL11					NVARCHAR(31)
	DECLARE @COL12					NVARCHAR(31)
	DECLARE @COL13					NVARCHAR(31)
	DECLARE @COL14					NVARCHAR(31)
	DECLARE @COL15					NVARCHAR(31)
	DECLARE @InstanceName_CNT		INT

	DECLARE @TAMP_TABLE7 TABLE (
		InstanceName	NVARCHAR(4000)	
		,CellCode		NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ERP_Sloc		NVARCHAR(30)
		,Transport		NVARCHAR(30)
		,Market			NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE8 TABLE (
		InstanceName	NVARCHAR(4000)	
		,CellCode		NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ERP_Sloc		NVARCHAR(30)
		,Transport		NVARCHAR(30)
		,Market			NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE9 TABLE (
		InstanceName	NVARCHAR(4000)	
		,CellCode		NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ERP_Sloc		NVARCHAR(30)
		,Transport		NVARCHAR(30)
		,Market			NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE10 TABLE (
		InstanceName	NVARCHAR(4000)	
		,CellCode		NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ERP_Sloc		NVARCHAR(30)
		,Transport		NVARCHAR(30)
		,Market			NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
		,COL11			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE11 TABLE (
		InstanceName	NVARCHAR(4000)	
		,CellCode		NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ERP_Sloc		NVARCHAR(30)
		,Transport		NVARCHAR(30)
		,Market			NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
		,COL11			NVARCHAR(31)
		,COL12			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE12 TABLE (
		InstanceName	NVARCHAR(4000)	
		,CellCode		NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ERP_Sloc		NVARCHAR(30)
		,Transport		NVARCHAR(30)
		,Market			NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
		,COL11			NVARCHAR(31)
		,COL12			NVARCHAR(31)
		,COL13			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE13 TABLE (
		InstanceName	NVARCHAR(4000)	
		,CellCode		NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ERP_Sloc		NVARCHAR(30)
		,Transport		NVARCHAR(30)
		,Market			NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
		,COL11			NVARCHAR(31)
		,COL12			NVARCHAR(31)
		,COL13			NVARCHAR(31)
		,COL14			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE14 TABLE (
		InstanceName	NVARCHAR(4000)	
		,CellCode		NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ERP_Sloc		NVARCHAR(30)
		,Transport		NVARCHAR(30)
		,Market			NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
		,COL11			NVARCHAR(31)
		,COL12			NVARCHAR(31)
		,COL13			NVARCHAR(31)
		,COL14			NVARCHAR(31)
		,COL15			NVARCHAR(31)
	)	
	

	DECLARE @instance_name		   NVARCHAR(300)




	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================

		--	XIF_MES_DAILY_PP_S 테이블에서 PLAN_ID 의 날짜를 조회 한다	
		SELECT @DATEDIFF_CNT = DATEDIFF(DD, MIN(DELIVERY_DATE), MAX(DELIVERY_DATE) )
			   ,@DATEMIN = CONVERT(VARCHAR,MIN(DELIVERY_DATE),120)
			   ,@DATEMAX = CONVERT(VARCHAR,MAX(DELIVERY_DATE),120)
			   ,@LIMIT_DATEMIN = CAST(DATEADD(DD, 7, MIN(DELIVERY_DATE)) AS date )
			   ,@LIMIT_DATEMAX = CAST(DATEADD(DD, 14, MIN(DELIVERY_DATE)) AS date )
		  FROM DBO.FP_CELL_DELIVERY_PLAN_H
		 WHERE PLAN_ID  = @plan_id
		   AND INSTANCE_ID = @instance_id
		   AND CAST(DELIVERY_QTY AS NUMERIC) > 0


		IF @DATEDIFF_CNT > 21
			SET @DATEDIFF_CNT = 21


		SET @instance_name = (
							 SELECT SEGMENT2
							   FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
							  WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
								AND SEGMENT1 = @instance_id
						   ) 


		SET @MAIL_WIDTH = @MAIL_WIDTH + (  (@DATEDIFF_CNT - 7) * 125 ) + ( SELECT CASE WHEN LEN(SEGMENT2) > 30 THEN
																						  400
																					   WHEN LEN(SEGMENT2) > 20 THEN
																					      200
																					   ELSE
																						  0
																				   END
																			 FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																		    WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
																			  AND SEGMENT1 = @instance_id
																		  ) 

		IF @DATEDIFF_CNT > 14							--배포일자와 계획 마지막 날짜의 차이가 14일 이상이면 15일 까지만 적용
			BEGIN
				SET @DATEMAX = @LIMIT_DATEMAX
				SET @DATEDIFF_CNT = 14
			END
		ELSE IF @DATEDIFF_CNT < 7						--배포일자와 계획 마지막 날짜의 차이가 7일 이하이면 7일 까지 적용
			BEGIN
				SET @DATEMAX = @LIMIT_DATEMIN
				SET @DATEDIFF_CNT = 7
			END

		DECLARE CUR_DATE_LIST CURSOR FOR				--배포기간 날짜 조회
			SELECT DATE_ID
			  FROM SCM_SYS_CALENDAR_M
			 WHERE DATE_ID >= @DATEMIN
			   AND DATE_ID <= @DATEMAX

		OPEN CUR_DATE_LIST;
		
		FETCH NEXT FROM CUR_DATE_LIST INTO @DATE_ID
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF @PIVOT_DATE = '' OR @PIVOT_DATE IS NULL	--첫 번째 일 경우
					BEGIN
						SET @PIVOT_SEL_DATE = 'ISNULL( CONVERT(NVARCHAR(50),['+@DATE_ID+']), '''') AS ['+@DATE_ID+']'		--NULL를 하지 않으면  값이 원하는 날짜에 값이 들어 가지 않는다.
						SET @PIVOT_DATE = '['+@DATE_ID+']'
					END
				ELSE										-- 첫 번째가 아닐 경우
					BEGIN
						SET @PIVOT_SEL_DATE = @PIVOT_SEL_DATE + ', ISNULL( CONVERT(NVARCHAR(50),['+@DATE_ID+']), '''') AS ['+@DATE_ID+']'
						SET @PIVOT_DATE = @PIVOT_DATE + ', ['+@DATE_ID+']'
					END

				SET @PIVOT_TD_DATE = @PIVOT_TD_DATE +', td = ['+@DATE_ID+']'

				SET @PIVOT_CON_DATE = @PIVOT_CON_DATE +', '''+@DATE_ID+''' as td'

				FETCH NEXT FROM CUR_DATE_LIST INTO @DATE_ID
				;
			END;
			
		CLOSE CUR_DATE_LIST;
		DEALLOCATE CUR_DATE_LIST;

		-- LOOP 끝나고 생성 되는 변수의 값 모양
		--	@PIVOT_SEL_DATE		=	ISNULL( CONVERT(NVARCHAR(50),['2017-12-21']), '''') AS [2017-12-21'],ISNULL( CONVERT(NVARCHAR(50),['2017-12-22']), '''') AS [2017-12-22]
		--	@PIVOT_DATE			=	['2017-12-21'],['2017-12-22'],['2017-12-23']
		--	@PIVOT_TD_DATE		=	, td = ['2017-12-21'], td = ['2017-12-22'], td = ['2017-12-23']
		--	@PIVOT_CON_DATE		=	, '2017-12-21' as td, '2017-12-22' as td, '2017-12-23' as td



		SET @DATA_QUERY =								'	SELECT InstanceName										'
								+						'		   , CellCode											'
								+						'		   , NickName											'
								+						'		   , ERP_Sloc											'
								+						'		   , Transport											'
								+						'		   , Market												'
								+						'		   , '+ @PIVOT_SEL_DATE
								+						'	  FROM ('
								+						'			SELECT (SELECT TOP 1 SLV.SEGMENT2					'
								+						'					  FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)	'
								+									'		 WHERE SLV.LOOKUP_TYPE_CODE = ''INSTANCE_ID''	'
								+									'		   AND SLV.SEGMENT1         = '''+@instance_id+''' ) AS InstanceName	'
								+									'	    , A.PLAN_ID AS PlanID							'
								+									'	    , A.ITEM_ID AS CellCode						'
								+									'	    , B.Nick_Name	AS NickName					'
								+									'	    , A.STORAGE_ID AS ERP_Sloc					'
								+									'	    , A.SOC_ID AS Transport						'
								+									'	    , A.Market									'
								+									'	    , CONVERT(NVARCHAR(10), A.DELIVERY_DATE, 120) AS DELIVERY_DATE 	'
								+									'	    , SUM( CONVERT(NUMERIC(13), A.DELIVERY_QTY ) ) AS DELIVERY_QTY 	'
								+									'   FROM FP_CELL_DELIVERY_PLAN_H A				'
								+									'  INNER JOIN SCM_ITEM_M B WITH(NOLOCK)				'
								+									'		  ON A.COMPANY_ID  = B.COMPANY_ID			'
								+									'		 AND A.DIVISION_ID = B.DIVISION_ID			'
								+									'		 AND A.SITE_ID     = B.SITE_ID				'
								+									'		 AND A.ITEM_ID     = B.ITEM_ID			'
								+									'		 AND B.ACTIVE_FLAG = ''Y''					'
								+									'  WHERE A.INSTANCE_ID      = '''+@instance_id+'''	'
								+									'    AND A.PLAN_ID		  = '''+@plan_id+'''		'
								+									'    AND A.DELIVERY_DATE  >= '''+@DATEMIN+'''		'
								+									'    AND A.DELIVERY_DATE  <= '''+@DATEMAX+'''		'
								+									'    AND DELIVERY_QTY > 0							'
								+									'  GROUP BY A.PLAN_ID  								'
								+									'	    , A.ITEM_ID							'
								+									'	    , B.NICK_NAME								'
								+									'	    , A.STORAGE_ID								'
								+									'	    , A.SOC_ID									'
								+									'	    , A.Market									'
								+									'	    , CONVERT(NVARCHAR(10), A.DELIVERY_DATE, 120)	'
								+							'	   ) A				'
								+							'	   PIVOT			'
								+							'	( SUM(DELIVERY_QTY) FOR DELIVERY_DATE IN ('+@PIVOT_DATE+') ) PV	'


			IF @DATEDIFF_CNT = 7 
				BEGIN
					INSERT INTO @TAMP_TABLE7
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, CellCode, NickName, ERP_Sloc, Transport, Market
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8
					)
					SELECT *
					 FROM @TAMP_TABLE7

				END
			ELSE IF @DATEDIFF_CNT = 8
				BEGIN
					INSERT INTO @TAMP_TABLE8
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, CellCode, NickName, ERP_Sloc, Transport, Market
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9
					)
					SELECT *
					 FROM @TAMP_TABLE8
				END
			ELSE IF @DATEDIFF_CNT = 9 
				BEGIN
					INSERT INTO @TAMP_TABLE9
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, CellCode, NickName, ERP_Sloc, Transport, Market
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10
					)
					SELECT *
					 FROM @TAMP_TABLE9
				END
			ELSE IF @DATEDIFF_CNT = 10 
				BEGIN
					INSERT INTO @TAMP_TABLE10
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, CellCode, NickName, ERP_Sloc, Transport, Market
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10,COL11
					)
					SELECT *
					 FROM @TAMP_TABLE10
				END
			ELSE IF @DATEDIFF_CNT = 11 
				BEGIN
					INSERT INTO @TAMP_TABLE11
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, CellCode, NickName, ERP_Sloc, Transport, Market
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10,COL11, COL12
					)
					SELECT *
					 FROM @TAMP_TABLE11
				END
			ELSE IF @DATEDIFF_CNT = 12
				BEGIN
					INSERT INTO @TAMP_TABLE12
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, CellCode, NickName, ERP_Sloc, Transport, Market
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10,COL11, COL12, COL13
					)
					SELECT *
					 FROM @TAMP_TABLE12
				END
			ELSE IF @DATEDIFF_CNT = 13
				BEGIN
					INSERT INTO @TAMP_TABLE13
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, CellCode, NickName, ERP_Sloc, Transport, Market
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10,COL11, COL12, COL13, COL14
					)
					SELECT *
					 FROM @TAMP_TABLE13
				END
			ELSE IF @DATEDIFF_CNT = 14
				BEGIN

					INSERT INTO @TAMP_TABLE14
					EXEC sp_executesql @DATA_QUERY
				END




			DECLARE CUR_DATA_LIST CURSOR FOR
				SELECT InstanceName
						,CellCode
						,ISNULL(NickName, '') AS NickName
						,ERP_Sloc
						,Transport
						,Market
						,COL1
						,COL2
						,COL3
						,COL4
						,COL5
						,COL6
						,COL7
						,COL8
						,COL9
						,COL10
						,COL11
						,COL12
						,COL13
						,COL14
						,COL15
						,COUNT(InstanceName) OVER( PARTITION BY InstanceName ) AS InstanceName_CNT
				 FROM @TAMP_TABLE14

			OPEN CUR_DATA_LIST;
		
				FETCH NEXT FROM CUR_DATA_LIST INTO @InstanceName
													,@CellCode
													,@NickName
													,@ERP_Sloc
													,@Transport
													,@Market
													,@COL1
													,@COL2
													,@COL3
													,@COL4
													,@COL5
													,@COL6
													,@COL7
													,@COL8
													,@COL9
													,@COL10
													,@COL11
													,@COL12
													,@COL13
													,@COL14
													,@COL15
													,@InstanceName_CNT

				WHILE (@@FETCH_STATUS = 0)
					BEGIN
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<tr>'

						IF @BEFOR_InstanceName != @InstanceName
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@InstanceName_CNT AS nvarchar)+'''>'+@InstanceName+'</td>'
								SET @BEFOR_InstanceName = @InstanceName
							END



						SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@CellCode+'</td>'
																+'<td>'+@NickName+'</td>'
																+'<td>'+@ERP_Sloc+'</td>'
																+'<td>'+@Transport+'</td>'
																+'<td>'+@Market+'</td>'
																+'<td>'+@COL1+'</td>'
																+'<td>'+@COL2+'</td>'
																+'<td>'+@COL3+'</td>'
																+'<td>'+@COL4+'</td>'
																+'<td>'+@COL5+'</td>'
																+'<td>'+@COL6+'</td>'
																+'<td>'+@COL7+'</td>'
																+'<td>'+@COL8+'</td>'

						IF @DATEDIFF_CNT IN ( 8, 9, 10, 11, 12, 13, 14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL9+'</td>'
						IF @DATEDIFF_CNT IN ( 9, 10, 11, 12, 13, 14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL10+'</td>'
						IF @DATEDIFF_CNT IN ( 10, 11, 12, 13, 14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL11+'</td>'
						IF @DATEDIFF_CNT IN ( 11, 12, 13, 14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL12+'</td>'
						IF @DATEDIFF_CNT IN ( 12,13,14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL13+'</td>'
						IF @DATEDIFF_CNT IN ( 13,14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL14+'</td>'
						IF @DATEDIFF_CNT = 14 
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL15+'</td>'

						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'</tr>'										


						FETCH NEXT FROM CUR_DATA_LIST INTO @InstanceName
													,@CellCode
													,@NickName
													,@ERP_Sloc
													,@Transport
													,@Market
													,@COL1
													,@COL2
													,@COL3
													,@COL4
													,@COL5
													,@COL6
													,@COL7
													,@COL8
													,@COL9
													,@COL10
													,@COL11
													,@COL12
													,@COL13
													,@COL14
													,@COL15
													,@InstanceName_CNT
													
					;
					END;
			
				CLOSE CUR_DATA_LIST;
				DEALLOCATE CUR_DATA_LIST;

			SET @DATA_QUERY ='SET @TABLE_HEAD_CONTENT = (	'
													+'	 SELECT ''InstanceName'' as td '
												--	+'		    ,''PlanID'' as td		'
													+'		    ,''CellCode'' as td	'
													+'		    ,''NickName'' as td	'
													+'		    ,''ERP_Sloc'' as td		'
													+'		    ,''Transport'' as td	'
													+'		    ,''Market'' as td '+@PIVOT_CON_DATE
													+'		FOR XML RAW(''tr''), ELEMENTS	'
													+'	)	'

			SET @ParmStr =  N'@TABLE_HEAD_CONTENT NVARCHAR(MAX) output'										--리턴 변수 선언 

			EXEC sp_executesql @DATA_QUERY, @ParmStr, @TABLE_HEAD_CONTENT=@TABLE_HEAD_CONTENT OUTPUT		--사용되는QUERY, 리턴값, OUTPUT 값 셋팅


			--SET @MAIL_TITLE = 'TEST ['+@plan_id+'] ['+@instance_id+']  FP System In_house Moving Pack Release Plan'
			SET @MAIL_TITLE = 'TEST ['+@instance_name+']  FP System In_house Moving Pack Release Plan'

 
			SET @TABLE_BODY = '	<html>
									<head>
										<title>Untitled Document</title>
										<style>
   											* {margin:0;padding:0;}
   											body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
   											table {border-collapse:collapse;width:100%;}
   											table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
   											table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
   											table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;}
   											table tbody td {text-align:left;padding:6px 8px;}
   											table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;}
											.hori-table table thead td {text-align:center;padding:3px;}  
   											.hori-table table tbody td {text-align:center;padding:3px;}
   											.vertical-table, .hori-table {margin-bottom:20px;}
										</style>
									</head>
									<body>
   										<div class=''wrap''>
       										<div class=''hori-table''>
           										<table style=''border-top:2px solid #c8294b; width:'+CAST(@MAIL_WIDTH AS nvarchar)+'px''>
               										<thead>' + @TABLE_HEAD_CONTENT + '</thead>
               										<tbody>' + ISNULL(@TABLE_CONTENTS, '') + '</tbody>
												</table>
       										</div>
   										</div>
									</body>
								</html>'


			SET @MAIL_RECEIVER_LIST = 'piyong@lgchem.com;'

	        EXEC  msdb.dbo.sp_send_dbmail @profile_name			  = 'FP_MAIL_TEST'
										  , @recipients             = @MAIL_RECEIVER_LIST
										  , @query_result_separator = ';'
										  , @subject                = @MAIL_TITLE
										  , @body                   = @TABLE_BODY
										  , @body_format            = 'html'

/*		
			DECLARE CUR_MAIL_ADDR_LIST CURSOR FOR							--instance별 MAIL 수신자  조회
				SELECT ATTRIBUTE3	
				FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
				WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
					AND SEGMENT1 = 'IN_HOUSE_PLAN_MOVING'
					AND ATTRIBUTE4 = 'Y'
					AND ATTRIBUTE3 IS NOT NULL
					AND ATTRIBUTE2 = @instance_id

			OPEN CUR_MAIL_ADDR_LIST;
		
			FETCH NEXT FROM CUR_MAIL_ADDR_LIST INTO @ADDR_LIST
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @MAIL_RECEIVER_LIST = @ADDR_LIST
					EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL_TEST'
										  , @recipients             = @MAIL_RECEIVER_LIST
										  , @query_result_separator = ';'
										  , @subject                = @MAIL_TITLE
										  , @body                   = @TABLE_BODY
										  , @body_format            = 'html'

				FETCH NEXT FROM CUR_MAIL_ADDR_LIST INTO @ADDR_LIST
				;
			END;
			
		CLOSE CUR_MAIL_ADDR_LIST;
		DEALLOCATE CUR_MAIL_ADDR_LIST;
*/
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

		EXEC PR_SCM_IN_HOUSE_SMS_SEND @instance_id, @plan_id, 'MOVING'
		
	END TRY

	BEGIN CATCH
	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
