CREATE PROCEDURE [dbo].[PR_SCM_BOM_CHANGE_INFO_SEND]

-- ================================================================================================
-- Program ID          : FP00560
-- Program Name        : PR_SCM_BOM_CHANGE_INFO_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : BOM 변경 정보  Mailing
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SCM_MAILING_H
-- Destination Table   : 
--
-- Create Date		   : 2018.01.20
-- Update Date		   : 2018.02.23 PIYONG
--						 2020.03.31 PIYONG

-- Author              : 
-- Version             : 1.0
--					     1.1 메일 송신 INSTANCE, PLANT 별로 변경
--							 조회쿼리 변경, 메일 전송 LOOK UP 명 변경
--						 1.2 CHILD_QTY 소수점 자릿수 변경
-- ================================================================================================
-- PARAMETER


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_BOM_CHANGE_INFO_SEND'
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
	DECLARE @TABLE_CONTENTS        NVARCHAR(MAX) = ''
	DECLARE @MAIL_CONTENT          NVARCHAR(MAX)
	DECLARE @MAIL_TITLE            NVARCHAR(MAX)

	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)

	SET @ROWCOUNT = @@ROWCOUNT

	DECLARE @INSTANCE				NVARCHAR(50)
	DECLARE @PLANT					NVARCHAR(10)
    DECLARE @MAIL_ADDR				NVARCHAR(MAX)

	DECLARE @DIVISION_ID			NVARCHAR(30)
	DECLARE @BEFOR_DIVISION_ID		NVARCHAR(30) = ''
	DECLARE @PLANT_ID				NVARCHAR(30)
	DECLARE @BEFOR_PLANT_ID			NVARCHAR(30) = ''
	DECLARE @SITE_ID				NVARCHAR(50) = ''
	DECLARE @CHILD_ITEM_ID			NVARCHAR(50)
	DECLARE @PARENT_ITEM_ID			NVARCHAR(50)
	DECLARE @BEFOR_PARENT_ITEM_ID	NVARCHAR(50) = ''
	DECLARE @PARENT_QTY				NVARCHAR(50)
	DECLARE @PARENT_UOM				NVARCHAR(10)
	DECLARE @CHILD_QTY				NVARCHAR(50)
	DECLARE @CHILD_UOM				NVARCHAR(10)
	DECLARE @ALT_ID					NVARCHAR(150)
	DECLARE @ALT_PRIORITY 			NVARCHAR(50)
	DECLARE @ECO_CODE				NVARCHAR(50)
	DECLARE @EFF_START_DATE			NVARCHAR(50)
	DECLARE @EFF_END_DATE			NVARCHAR(50)
	DECLARE @PARENT_NICK_NAME		NVARCHAR(50)
	DECLARE @BEFOR_PARENT_NICK_NAME NVARCHAR(50)= ''
	DECLARE @CHILD_NICK_NAME		NVARCHAR(50)

	
	DECLARE @DIVISION_CNT			NUMERIC(18,0)
	DECLARE @PLANT_CNT				NUMERIC(18,0)
	DECLARE @PARENT_ITEM_CNT		NUMERIC(18,0)
	DECLARE @NICK_NAME_CNT			NUMERIC(18,0)

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
			-- PIYONG 2018-02-23  조회쿼리 INSTANCE 추가 OPERATION_GROUP 제거
			SELECT A.COMPANY_ID
				   ,A.DIVISION_ID
				   ,A.SITE_ID
				   ,A.PLANT_ID
				   ,F.INSTANCE_ID																													  --2018-02-23 PIYONG 추가
				   ,A.PARENT_ITEM_ID
				   ,A.CHILD_ITEM_ID
				   ,A.PARENT_QTY
				   ,A.PARENT_UOM
				   ,A.CHILD_QTY
				   ,A.CHILD_UOM
				   ,A.ALT_ID
				   ,A.ALT_PRIORITY
				   ,A.ECO_CODE
				   ,A.KEY_DATE
				   ,CONVERT(VARCHAR, A.EFF_START_DATE, 112) EFF_START_DATE
				   ,CONVERT(VARCHAR, A.EFF_END_DATE, 112) EFF_END_DATE
				   ,ISNULL(B.NICK_NAME,'-') AS PARENT_NICK_NAME
				   ,ISNULL(B2.NICK_NAME,'-') AS CHILD_NICK_NAME
--				   ,(SELECT OPERATION_GROUP_ID FROM SCM_ITEM_CLASS_LEVEL_M M WHERE M.LEVEL_ID = B.ITEM_CLASS AND M.USE_FLAG = 'Y') AS OPERATION_GROUP  --2018-02-23 PIYONG 제거
			  INTO #BOM_INFO
			  FROM SCM_BOM_M A(NOLOCK)
				   ,SCM_ITEM_M B(NOLOCK)
				   ,SCM_ITEM_M B2(NOLOCK)
				   ,SCM_ITEM_CLASS_M IC(NOLOCK)
				   ,SCM_ITEM_CLASS_LEVEL_M M(NOLOCK)
				   ,SCM_MMD_OPERATION_GROUP_M  MOG (NOLOCK)
				   ,(SELECT DISTINCT F.INSTANCE_ID, SF.PLANT_ID, F.SHOP_GROUP_ID
					   FROM SCM_FACTORY_M   SF (NOLOCK)
						    ,FP_INSTANCE_FACTORY_M F (NOLOCK)
					  WHERE SF.FACTORY_ID  = F.FACTORY_ID
					    AND SF.ACTIVE_FLAG = 'Y'
					    AND F.ACTIVE_FLAG  = 'Y' )  F
			 WHERE A.COMPANY_ID = B.COMPANY_ID
			   AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
			   AND A.PARENT_ITEM_ID = B.ITEM_ID
			   AND A.COMPANY_ID = B2.COMPANY_ID
			   AND A.DIVISION_ID = B2.DIVISION_ID
			   AND A.SITE_ID = B2.SITE_ID
			   AND A.CHILD_ITEM_ID = B2.ITEM_ID
			   AND B2.ITEM_CLASS = IC.CLASS_ID
			   AND IC.USE_FLAG = 'Y'
			   AND A.STANDARD_FLAG = 'Y'
			   AND A.ACTIVE_FLAG = 'Y'
			   AND B.ACTIVE_FLAG = 'Y'
			   AND B2.ACTIVE_FLAG = 'Y'
			   AND M.LEVEL_ID = B.ITEM_CLASS
			   AND M.USE_FLAG = 'Y'
			   AND M.OPERATION_GROUP_ID = MOG.OPERATION_GROUP_ID
			   AND F.SHOP_GROUP_ID      = ISNULL(MOG.ROUTE_TYPE, MOG.OPERATION_GROUP_ID)
			   AND F.PLANT_ID           = A.PLANT_ID
			   AND EXISTS ( SELECT TOP 1 1 
							  FROM SCM_SYS_LOOKUP_VALUE LV1 (NOLOCK)
							 WHERE LV1.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							   AND LV1.SEGMENT1         = F.INSTANCE_ID
							   AND LV1.ACTIVE_FLAG      = 'Y'
							   AND LV1.ATTRIBUTE1       = 'BUILDING'
							UNION ALL
							SELECT TOP 1 1 
							  FROM SCM_ITEM_LINE_ASSIGN_M  IIA (NOLOCK),
								   SCM_LINE_M              LM  (NOLOCK),
								   SCM_SYS_LOOKUP_VALUE    LV1 (NOLOCK),
								   SCM_SYS_LOOKUP_VALUE    LV2 (NOLOCK)
							 WHERE LV1.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							   AND LV2.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
							   AND LV1.SEGMENT1         = LV2.SEGMENT1
							   AND LV1.SEGMENT1         = F.INSTANCE_ID
							   AND LV1.ACTIVE_FLAG      = 'Y'
							   AND LV1.ATTRIBUTE1       = 'PLAN GROUP'
							   AND IIA.COMPANY_ID       = A.COMPANY_ID
							   AND IIA.DIVISION_ID      = A.DIVISION_ID
							   AND IIA.SITE_ID          = A.SITE_ID
							   AND IIA.PLANT_ID         = A.PLANT_ID
							   AND IIA.ITEM_ID          = A.PARENT_ITEM_ID
							   AND IIA.MONTH            = CONVERT(NVARCHAR(6), GETDATE(), 112)
							   AND LM.COMPANY_ID        = A.COMPANY_ID
							   AND LM.DIVISION_ID       = A.DIVISION_ID
							   AND LM.SITE_ID           = A.SITE_ID
							   AND LM.PLANT_ID          = A.PLANT_ID
							   AND LM.FACTORY_ID        = IIA.FACTORY_ID
							   AND LM.LINE_ID           = IIA.LINE_ID
							   AND LM.OPERATION_ID      = IIA.OPERATION_ID
							   AND LM.ELECTRODE_TYPE    = IIA.ELECTRODE_TYPE
							   AND LV2.SEGMENT2         = ISNULL(LM.MODEL_TYPE,LV2.SEGMENT2)
						 )
			   AND A.UPDATE_TIME > DATEADD(MINUTE, -10,DATEADD(HOUR, -1, GETDATE()))
			   AND ( ( CONVERT(VARCHAR, A.EFF_START_DATE, 112) BETWEEN  CONVERT(VARCHAR, GETDATE()-1, 112) AND CONVERT(VARCHAR, GETDATE(), 112)  
						AND CONVERT(VARCHAR, A.EFF_END_DATE, 112) > CONVERT(VARCHAR, GETDATE(), 112)
					  ) OR A.KEY_DATE = CONVERT(NVARCHAR(8), GETDATE(), 112)  
				   )




		DECLARE CUR_OPERATION_GROUP_LIST CURSOR FOR				
			 SELECT ATTRIBUTE1, SEGMENT2, SEGMENT3									--2018-02-23 PIYONG 변경  --OPERATION_GROUP 별 MAIL 수신자  조회  -> INSTANCE, PLANT
			   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
			  WHERE LOOKUP_TYPE_CODE = 'BOM_CHANGE_INFO_MAIL'						--2018-02-23 PIYONG 변경  STANDARD_INFO_MAIL  -> BOM_CHANGE_INFO_MAIL
				AND ACTIVE_FLAG = 'Y'


		OPEN CUR_OPERATION_GROUP_LIST;
		
		FETCH NEXT FROM CUR_OPERATION_GROUP_LIST INTO @MAIL_ADDR
													  ,@INSTANCE					--2018-02-23 PIYONG 변경
													  ,@PLANT						--2018-02-23 PIYONG 변경
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @MAIL_TITLE = N'[DEV] [Notification] BOM Change Info ('+ SUBSTRING(CONVERT(NVARCHAR(10),GETDATE(), 102), 3, 8)+')'
				SET @MAIL_CONTENT = N'BOM 변경 정보 '
				SET @MAIL_RECEIVER_LIST = ''
				SET @TABLE_CONTENTS = ''
				SET @BEFOR_DIVISION_ID = ''
				SET @BEFOR_PLANT_ID = ''
				SET @BEFOR_PARENT_ITEM_ID = ''
				SET @BEFOR_PARENT_NICK_NAME = ''

				DECLARE CUR_DATA_LIST CURSOR FOR
					SELECT A.DIVISION_ID
						   ,A.PLANT_ID
						   ,A.PARENT_ITEM_ID
						   ,A.CHILD_ITEM_ID
						   ,CONVERT(NUMERIC(10,3),A.PARENT_QTY) AS PARENT_QTY
						   ,A.PARENT_UOM
						   ,CONVERT(NUMERIC(10,3),A.CHILD_QTY) AS CHILD_QTY						-- 2020-03-31 PIYONG CHANGE NUMERIC(10,2) -> NUMERIC(10,3)
						   ,A.CHILD_UOM
						   ,ISNULL(A.ALT_ID, '') AS ALT_ID
						   ,ISNULL( CAST(CONVERT(NUMERIC(10,2),A.ALT_PRIORITY) AS NVARCHAR), '') AS ALT_PRIORITY
						   ,A.ECO_CODE
						   ,SUBSTRING(A.EFF_START_DATE, 1, 4)+'-'+SUBSTRING(A.EFF_START_DATE, 5, 2)+'-'+SUBSTRING(A.EFF_START_DATE, 7, 2) AS EFF_START_DATE
						   ,SUBSTRING(A.EFF_END_DATE, 1, 4)+'-'+SUBSTRING(A.EFF_END_DATE, 5, 2)+'-'+SUBSTRING(A.EFF_END_DATE, 7, 2) AS EFF_END_DATE
						   ,A.PARENT_NICK_NAME
						   ,A.CHILD_NICK_NAME
						   ,COUNT(DIVISION_ID) OVER( PARTITION BY DIVISION_ID ORDER BY DIVISION_ID  ) AS DIVISION_CNT
						   ,COUNT(PLANT_ID) OVER( PARTITION BY DIVISION_ID, PLANT_ID ORDER BY DIVISION_ID , PLANT_ID ) AS PLANT_CNT
						   ,COUNT(PARENT_ITEM_ID) OVER( PARTITION BY DIVISION_ID, PLANT_ID, PARENT_ITEM_ID ORDER BY DIVISION_ID, PLANT_ID, PARENT_ITEM_ID ) AS PARENT_ITEM_CNT
						   ,COUNT(PARENT_NICK_NAME) OVER( PARTITION BY DIVISION_ID, PLANT_ID, PARENT_NICK_NAME ORDER BY DIVISION_ID, PLANT_ID, PARENT_NICK_NAME ) AS NICK_NAME_CNT
					  FROM #BOM_INFO A
					 WHERE INSTANCE_ID = @INSTANCE						--2018-02-23 PIYONG 변경  SITE_ID = @SITE_ID  ->  INSTANCE_ID = @INSTANCE
					   AND PLANT_ID = @PLANT							--2018-02-23 PIYONG 추가  OPERATION_GROUP IN ( @OPERATION_GROUP, @OPERATION_GROUP1 )  ->  PLANT_ID = @PLANT
					 ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
						   ,CASE WHEN PARENT_NICK_NAME IS NOT NULL THEN PARENT_NICK_NAME ELSE 'ZZZZZZ' END
						   , A.PARENT_ITEM_ID, A.CHILD_ITEM_ID

				OPEN CUR_DATA_LIST;
		
				FETCH NEXT FROM CUR_DATA_LIST INTO @DIVISION_ID
													,@PLANT_ID
												    ,@PARENT_ITEM_ID
												    ,@CHILD_ITEM_ID
												    ,@PARENT_QTY
												    ,@PARENT_UOM
												    ,@CHILD_QTY
												    ,@CHILD_UOM
												    ,@ALT_ID
												    ,@ALT_PRIORITY 
												    ,@ECO_CODE
													,@EFF_START_DATE
													,@EFF_END_DATE
													,@PARENT_NICK_NAME
													,@CHILD_NICK_NAME
													,@DIVISION_CNT
													,@PLANT_CNT
													,@PARENT_ITEM_CNT
													,@NICK_NAME_CNT

				WHILE (@@FETCH_STATUS = 0)
					BEGIN


						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<tr>'

						IF @BEFOR_DIVISION_ID != @DIVISION_ID OR @DIVISION_CNT  = 1
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@DIVISION_CNT AS nvarchar)+'''>'+@DIVISION_ID+'</td>'
								SET @BEFOR_DIVISION_ID = @DIVISION_ID
							END

						IF @BEFOR_PLANT_ID != @PLANT_ID  OR @PLANT_CNT  = 1 
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@PLANT_CNT AS nvarchar)+'''>'+@PLANT_ID+'</td>'
								SET @BEFOR_PLANT_ID = @PLANT_ID
							END

						IF @BEFOR_PARENT_NICK_NAME != @PARENT_NICK_NAME OR @NICK_NAME_CNT  = 1 
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@NICK_NAME_CNT AS nvarchar)+'''>'+@PARENT_NICK_NAME+'</td>'
								SET @BEFOR_PARENT_NICK_NAME = @PARENT_NICK_NAME
							END

						IF @BEFOR_PARENT_ITEM_ID != @PARENT_ITEM_ID OR @PARENT_ITEM_CNT  = 1 
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@PARENT_ITEM_CNT AS nvarchar)+'''>'+@PARENT_ITEM_ID+'</td>'
								SET @BEFOR_PARENT_ITEM_ID = @PARENT_ITEM_ID
							END


						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@PARENT_QTY+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@PARENT_UOM+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@ALT_ID+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@ALT_PRIORITY+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@CHILD_ITEM_ID+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@CHILD_NICK_NAME+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@CHILD_QTY+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@CHILD_UOM+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@EFF_START_DATE+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@EFF_END_DATE+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+ISNULL(@ECO_CODE, '-')+'</td>'

						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'</tr>'

						FETCH NEXT FROM CUR_DATA_LIST INTO @DIVISION_ID
															,@PLANT_ID
															,@PARENT_ITEM_ID
															,@CHILD_ITEM_ID
															,@PARENT_QTY
															,@PARENT_UOM
															,@CHILD_QTY
															,@CHILD_UOM
															,@ALT_ID
															,@ALT_PRIORITY 
															,@ECO_CODE
															,@EFF_START_DATE
															,@EFF_END_DATE
															,@PARENT_NICK_NAME
															,@CHILD_NICK_NAME
															,@DIVISION_CNT
															,@PLANT_CNT
															,@PARENT_ITEM_CNT
															,@NICK_NAME_CNT
													
					;
					END;

				CLOSE CUR_DATA_LIST;
				DEALLOCATE CUR_DATA_LIST;

				SET @TABLE_BODY = '  	<html>
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
								<body>' +
								REPLACE(ISNULL(@MAIL_CONTENT, ''), CHAR(10), '<br>') + 'Report generated on : ' + CONVERT(VARCHAR(10), GETDATE(), 120) + '
   									<br>
   									<div class=''wrap''>
       									<div class=''hori-table''>
           									<table style=''border-top:2px solid #c8294b; width:2250px;''>
               									<thead>' 
													+'<tr>'
													+'	<th>Division</th>'
													+'	<th>Plant</th>'
													+'	<th>Parent PJT Code</th>'
													+'	<th>Parent Material</th>'
													+'	<th>Parent Quantity</th>'
													+'	<th>Parent UOM</th>'
													+'	<th>Alternate ID</th>'
													+'	<th>Alternate Priority</th>'
													+'	<th>Child Material</th>'
													+'	<th>Child PJT Code</th>'
													+'	<th>Child Quanitity</th>'
													+'	<th>Child UOM</th>'
													+'	<th>Effective Start Date</th>'
													+'	<th>Effective End Date</th>'
													+'	<th>ECO Code</th>'
													+'</tr>'
               									+'</thead>
               									<tbody>' + ISNULL(@TABLE_CONTENTS, '') + '</tbody>
											</table>
       									</div>
   									</div>
								</body>
								</html>'

				SET @MAIL_RECEIVER_LIST = 'kimcd@lgespartner.com;'+ISNULL( @MAIL_ADDR, '')


				IF LEN(@TABLE_CONTENTS) > 0
					BEGIN
						exec msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
													 , @recipients             = @MAIL_RECEIVER_LIST
													 , @query_result_separator = ';'
													 , @subject                = @MAIL_TITLE
													 , @body                   = @TABLE_BODY
													 , @body_format            = 'html'
					 END

				FETCH NEXT FROM CUR_OPERATION_GROUP_LIST INTO @MAIL_ADDR
															  ,@INSTANCE			--2018-02-23 PIYONG 변경
															  ,@PLANT				--2018-02-23 PIYONG 변경
													
				;
			END;
			
		CLOSE CUR_OPERATION_GROUP_LIST;
		DEALLOCATE CUR_OPERATION_GROUP_LIST;


		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
