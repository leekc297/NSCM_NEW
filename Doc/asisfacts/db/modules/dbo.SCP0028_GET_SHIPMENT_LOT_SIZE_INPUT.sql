/*
 * Program ID   : SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT
 * Description  : Shipment Lot Size Input 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/09/07   ygkim		   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/12/17	hwyoon			Split Yn 항목 추가
 * 2020/10/06   KSW            'END' 로그추가 - 장기수행프로그램으로 SMS 송신되지 않도록 오류수정
 * ex)
	EXEC SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT @p_division_id = '40,40', @p_operation_group = 'A,A'
	     , @p_from_site = 'A010-A,A010-A', @p_to_site = 'Akku_DE_SDF,LGCEG_DE_WIN', @p_item_id = 'MCCE121501A2, MCCE125001A4', @p_user_id='hwwoonins'
 */
CREATE PROCEDURE [dbo].[SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT]
  @p_division_id			NVARCHAR(max),
  @p_operation_group		NVARCHAR(max),
  @p_from_site				NVARCHAR(max),
  @p_to_site				NVARCHAR(max),
  @p_item_id				NVARCHAR(max),
  @p_user_id				NVARCHAR(max)

AS  
  
BEGIN

		DECLARE @v_created_by        NVARCHAR(MAX);
		DECLARE @v_creation_date     datetime	;
		DECLARE @v_last_updated_by   NVARCHAR(MAX);
		DECLARE @v_last_update_date  datetime	;
	
		SET @v_created_by       = @p_user_id;
		SET @v_creation_date    = sysdatetime();
		SET @v_last_updated_by  = @p_user_id;
		SET @v_last_update_date = sysdatetime();

		-- LOG 용 변수 설정
		DECLARE @v_program_name NVARCHAR(150) = 'SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT';
		DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @n_log_count    INTEGER = 0;
		DECLARE @v_log_message  NVARCHAR(1000);
		DECLARE @v_description  NVARCHAR(500);
		DECLARE @d_event_date   DATETIME;


		DECLARE @v_data_dup_cnt  INT=0;
		DECLARE @v_data_dup_priority_cnt  INT=0;
	
		-- 예외처리 변수 설정
		DECLARE @v_err_code  INTEGER;
		DECLARE @v_err_message  NVARCHAR(4000)='';

		-- 트렌젝션 시작
		BEGIN TRAN;

		BEGIN TRY

			-- 시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			/********************************************************************************
			* 임시테이블만들기
			********************************************************************************/
			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_DIV') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_DIV

			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_OPER') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_OPER

			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_FROM') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_FROM

			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_TO') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_TO

			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_ITEM') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_ITEM

			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_INPUT') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_INPUT


			Select nr AS SEQ, token DIVISION_ID 
			INTO #TblDynamic_SCP0028IN_DIV
			from dbo.UF_FX_String_Split (@p_division_id,',')

			Select nr AS SEQ, token OPERATION_GROUP 
			INTO #TblDynamic_SCP0028IN_OPER
			from dbo.UF_FX_String_Split (@p_operation_group,',')

			Select nr AS SEQ, token FROM_SITE 
			INTO #TblDynamic_SCP0028IN_FROM
			from dbo.UF_FX_String_Split (@p_from_site,',')

			Select nr AS SEQ, token TO_SITE 
			INTO #TblDynamic_SCP0028IN_TO
			from dbo.UF_FX_String_Split (@p_to_site,',')

			Select nr AS SEQ, token ITEM_ID 
			INTO #TblDynamic_SCP0028IN_ITEM
			from dbo.UF_FX_String_Split (@p_item_id,',')


			SELECT	A.SEQ
					, A.DIVISION_ID
					, B.OPERATION_GROUP as OPERATION_GROUP_ID
					, dbo.fn_get_lookup_code_desc('OPERATION_GROUP',B.OPERATION_GROUP) operation_group_name
					, C.FROM_SITE
					,ISNULL(dbo.fn_get_scm_site_description (a.division_id, C.FROM_SITE) , '-') AS from_site_description
					, D.TO_SITE
					,ISNULL(dbo.fn_get_scm_site_description (a.division_id, D.TO_SITE) , '-') AS to_site_description
					, E.ITEM_ID
					, F.NICK_NAME
					, G.trans_mode_code
					, G.trans_mode_name
					,null LOT_SIZE
					,null INCREMENT
					,'Y' VALID_YN
					,'N' SPLIT_YN
					,'' CREATED_BY
					,null CREATION_DATE
					,'' LAST_UPDATED_BY
					,null LAST_UPDATE_DATE  
			INTO #TblDynamic_SCP0028IN_INPUT
			FROM #TblDynamic_SCP0028IN_DIV A
			JOIN #TblDynamic_SCP0028IN_OPER B ON A.SEQ=B.SEQ
			JOIN #TblDynamic_SCP0028IN_FROM C ON A.SEQ=C.SEQ
			JOIN #TblDynamic_SCP0028IN_TO D ON A.SEQ=D.SEQ
			JOIN #TblDynamic_SCP0028IN_ITEM E ON A.SEQ=E.SEQ
			inner join scm_mst_final_item_v F on a.DIVISION_ID = F.DIVISION_ID and E.ITEM_ID = F.ITEM_ID
			cross join (select segment2 trans_mode_name, SEGMENT1 trans_mode_code from SCM_ADM_LOOKUP_MASTER_DETAIL where LOOKUP_TYPE = 'TRANSPORT_MODE_CODE' and VALID_YN = 'Y') G
			inner join (select distinct DIVISION_ID, FROM_SITE, TO_SITE
									from SCP_MST_BOD
									where VALID_YN = 'Y') H on H.DIVISION_ID = A.DIVISION_ID and H.FROM_SITE = C.FROM_SITE AND H.TO_SITE=D.TO_SITE




			-- 이력저장
			/*
			INSERT INTO SCP_MST_SHIPMENT_LOT_SIZE_H
			(history_seq,
						division_id,
						operation_group,
						from_site,
						to_site,
						item_id,
						transport_mode,
						lot_size,
						increment,
						valid_yn,
						created_by,
						creation_date,
						last_updated_by,
						last_update_date,
						history_creation_date)
			SELECT	NEXT VALUE FOR SEQ1_SCP_MST_SHIPMENT_LOT_SIZE_H
					, DIVISION_ID
					, OPERATION_GROUP_ID
					, FROM_SITE
					, TO_SITE
					, ITEM_ID
					, trans_mode_code
					,null LOT_SIZE
					,null INCREMENT
					,'Y' VALID_YN
					,@v_created_by
					,@v_creation_date
					,@v_last_updated_by
					,@v_last_update_date
					,@v_last_update_date  
			FROM #TblDynamic_SCP0028IN_INPUT


			--데이터 저장
			BEGIN		
				MERGE INTO SCP_MST_SHIPMENT_LOT_SIZE A
						USING (
								SELECT DIVISION_ID
										, OPERATION_GROUP_ID
										, FROM_SITE
										, TO_SITE
										, ITEM_ID
										, trans_mode_code as transport_mode  
								FROM #TblDynamic_SCP0028IN_INPUT
								) B
						ON(
									a.division_id = b.division_id
								and a.operation_group = b.OPERATION_GROUP_ID
								and a.from_site = b.from_site
								and a.to_site = b.to_site
								and a.item_id = b.item_id
								and a.transport_mode = b.transport_mode
							)
						WHEN MATCHED THEN
							UPDATE 
								SET  last_updated_by  = @v_last_updated_by  
									,last_update_date = @v_last_update_date 
					                
						WHEN NOT MATCHED THEN							                                             
							INSERT 
									(division_id
									,operation_group
									,from_site
									,to_site
									,item_id
									,transport_mode
									,lot_size
									,increment
									,valid_yn
									,created_by
									,creation_date
									,last_updated_by
									,last_update_date
									)
								VALUES
									( b.division_id                
									,b.OPERATION_GROUP_ID
									,b.FROM_SITE
									,b.TO_SITE         
									,b.ITEM_ID    
									,b.transport_mode               
									,null             
									,null
									,'Y'              
									,@v_created_by
									,@v_creation_date         
									,@v_last_updated_by       
									,@v_last_update_date      
									); 
			END
			 */
			COMMIT TRAN;

			-- 조회
			SELECT * FROM #TblDynamic_SCP0028IN_INPUT

			-- 임시테이블 삭제
			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_DIV') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_DIV

			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_OPER') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_OPER

			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_FROM') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_FROM

			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_TO') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_TO

			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_ITEM') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_ITEM

			IF OBJECT_ID('tempdb..#TblDynamic_SCP0028IN_INPUT') IS NOT NULL
			DROP TABLE #TblDynamic_SCP0028IN_INPUT


			-- 종료 LOG 추가
			-- 2020/10/06   KSW :: 'END' 로그추가 - 장기수행프로그램으로 SMS 송신되지 않도록 오류수정
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
		END TRY

		BEGIN CATCH 
			BEGIN
				if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
				INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
				VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

				--IF @@TRANCOUNT > 0
				--  COMMIT WORK;
					  

				-- error코드, errror 메시지 반환
				SELECT 'F' AS result_code;

			END;
		END CATCH;						
								  
END

