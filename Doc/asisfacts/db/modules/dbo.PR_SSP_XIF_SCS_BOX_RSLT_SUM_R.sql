

/*
 * Program ID   : PR_SSP_XIF_SCS_BOX_RSLT_SUM_R
 * Description  : 포장 생산실적 I/F (DIVISION_ID = '82')
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.19   LWY            Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - ESS 팩(82) 생산실적 조립 → 포장 기준 변경
                               - division_id = '82' and BOXING_DATE >= '20220517'
 * 2022.08.10   LWY            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 실적집계 0 인것도 포함 (주석처리)
 * 2022.08.24   LWY            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 소형 외주 생산실적 기준 변경
                               - lookUp (조립실적 생산기준 Packer) 기준 변경
 * 2024.10.01   KHJ            NERP_SSP                               
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_SCS_BOX_RSLT_SUM_R]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_XIF_SCS_BOX_RSLT_SUM_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_if_seq     NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;

	DECLARE @v_division_id NVARCHAR(2);
	DECLARE @v_boxing_date NVARCHAR(8);

	set  @v_division_id = '82'
	set  @v_boxing_date = '20220517';

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

	    -- 인터페이스 테이블 처리 ROW UPDATE
        UPDATE XIF_SCM_SCS_BOX_RESULT_R_SN
	    SET    proc_flag = 'P'
	    WHERE  ISNULL(proc_flag,'N') = 'N'
		AND    BOXING_DATE >= @v_boxing_date   -- LINE_ID 가 정상 IF 되는 일자 (by 장현석C)
		--AND    DIVISION_ID = @v_division_id  --2022.08.24
		--AND    PACK_QTY > 0                  -- 2022.08.10		
		;
	  
	    -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	 --   declare cur_scs_box_prod_result cursor for
		--select if_seq 
		--from   xif_scm_scs_box_result_r_sn a with(nolock)
		--where  1 = 1
		--and    a.proc_flag = 'P'
		--and    a.division_id = @v_division_id
		--and    a.boxing_date >= @v_boxing_date
		----and    pack_qty > 0  -- 2022.08.10
		--group by a.if_seq
		--order by a.if_seq asc;


/* INF-R 적용 이전 
		declare cur_scs_box_prod_result cursor for
		select if_seq 
		from   xif_scm_scs_box_result_r_sn a with(nolock)
		where  1 = 1
		and not exists (select 1
		                  from scm_adm_lookup_master_detail b (nolock)
						 where a.division_id = b.segment1
		                   and a.packer_code = b.segment2
						   and b.lookup_type = 'SCS_ASSY_PACKER'
		               )
		and    a.proc_flag = 'P'
		--and    a.division_id = @v_division_id
		and    a.boxing_date >= @v_boxing_date
		--and    pack_qty > 0  -- 2022.08.10
		group by a.if_seq
		order by a.if_seq asc;
*/

/* INF-R 적용 이후 */
		declare cur_scs_box_prod_result cursor for
		select if_seq 
		from    (
					SELECT if_seq, division_id
						 , ISNULL (X1.NEW_VALUE1, packer_code)  AS packer_code
						 , proc_flag, boxing_date
					FROM xif_scm_scs_box_result_r_sn A with(nolock)
					LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
					ON  X1.CODETYPE = 'SCP_SITE_ID'
					AND A.PACKER_CODE = X1.OLD_VALUE1
					AND X1.ATTRIBUTE5 = '1ST'
				) a
		where  1 = 1
		and not exists (select 1
		                  from scm_adm_lookup_master_detail b (nolock)
						 where a.division_id = b.segment1
		                   and a.packer_code = b.segment2
						   and b.lookup_type = 'SCS_ASSY_PACKER'
		               )
		and    a.proc_flag = 'P'
		--and    a.division_id = @v_division_id
		and    a.boxing_date >= @v_boxing_date
		--and    pack_qty > 0  -- 2022.08.10
		group by a.if_seq
		order by a.if_seq asc;



	  
		OPEN CUR_SCS_BOX_PROD_RESULT;
		FETCH NEXT FROM CUR_SCS_BOX_PROD_RESULT INTO @v_if_seq ; 
		 
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			
/* INF-R 적용 이전 
            MERGE INTO scm_dnm_scs_prod_result a
			USING (
                   SELECT /* PR_SSP_XIF_SCS_BOX_RSLT_SUM_R */ 
                          v.division_id
                        , v.cutoff_date
                        , v.scm_site_id
                        , dbo.FN_GET_PACKER_PLAN_ITEM_ID(v.division_id, v.pack_model_code) AS item_id
                        , v.packer_code
                        , v.pack_model_code
                        , v.line_id
                        , v.prod_date
                        , v.prod_qty    
                        , v.defect_qty             
                   FROM  (
                          SELECT --spart AS division_id
                                 ISNULL(division_id, '')             AS division_id
                               , CONVERT(CHAR(8), GETDATE()-1, 112)  AS cutoff_date -- 실제로는 의미 없음
                               , ISNULL(packer_code, '')             AS scm_site_id
                               , ISNULL(packer_code, '')             AS packer_code
                               , ISNULL(pack_model_code, '')         AS pack_model_code
                               , ISNULL(attr_01, '')                 AS line_id           -- attr_1 (Line_ID)
                               , ISNULL(boxing_date, '')             AS prod_date
                               , ISNULL(pack_qty, '0')               AS prod_qty
                               , '0'                                 AS defect_qty
                          FROM   XIF_SCM_SCS_BOX_RESULT_R_SN  WITH(NOLOCK)
                          WHERE  if_seq    = @v_if_seq
                          AND    proc_flag = 'P'
						  --AND    DIVISION_ID = @v_division_id
						  AND    BOXING_DATE >= @v_boxing_date
                         ) v              
                   WHERE  division_id                 <> ''
                   AND    ISNULL(scm_site_id, '')     <> ''
                   AND    ISNULL(pack_model_code, '') <> ''
		          ) b
			ON (	   a.division_id     =  b.division_id
				   --AND a.cutoff_date	 =  b.cutoff_date
				   AND a.scm_site_id	 =  b.scm_site_id
				   AND a.pack_model_code =  b.pack_model_code -- Origin Item Id
				   AND ISNULL(a.line_id, '') =  ISNULL(b.line_id, '')
				   AND a.prod_date	     =  b.prod_date
			   )
			WHEN MATCHED THEN
				 UPDATE SET 			
				             a.cutoff_date	    =  b.cutoff_date
							,a.prod_qty			=  b.prod_qty
							,a.defect_qty       =  b.defect_qty
							,a.item_id          =  b.item_id
							,a.packer_code      =  b.packer_code
							,a.last_updated_by	=  'BOX_U'--@v_batch_user
							,a.last_update_date	=  GETDATE()
					                
			WHEN NOT MATCHED THEN
			INSERT (  
                    division_id
                  , cutoff_date
                  , scm_site_id
                  , item_id
                  , packer_code
                  , pack_model_code
                  , line_id
                  , prod_date
                  , prod_qty
                  , defect_qty
                  , created_by
                  , creation_date
                  , last_updated_by
                  , last_update_date						  								
                   )
			VALUES (   
                    b.division_id
                  , b.cutoff_date
                  , b.scm_site_id
                  , b.item_id
                  , b.packer_code
                  , b.pack_model_code
                  , b.line_id
                  , b.prod_date
                  , b.prod_qty
                  , b.defect_qty
				  , @v_batch_user
				  , GETDATE()
				  , 'BOX_I'--@v_batch_user
				  , GETDATE()
			       )
			;
*/


/* INF-R 적용 이후 */ 
            MERGE INTO scm_dnm_scs_prod_result a
			USING (
                   SELECT /* PR_SSP_XIF_SCS_BOX_RSLT_SUM_R */ 
                          v.division_id
                        , v.cutoff_date
                        , v.scm_site_id
                        , dbo.FN_GET_PACKER_PLAN_ITEM_ID(v.division_id, v.pack_model_code) AS item_id
                        , v.packer_code
                        , v.pack_model_code
                        , v.line_id
                        , v.prod_date
                        , v.prod_qty    
                        , v.defect_qty             
                   FROM  (
                          SELECT --spart AS division_id
                                 ISNULL(division_id, '')             AS division_id
                               , CONVERT(CHAR(8), GETDATE()-1, 112)  AS cutoff_date -- 실제로는 의미 없음
                               , ISNULL(ISNULL (X1.NEW_VALUE1, packer_code), '')             AS scm_site_id
                               , ISNULL(ISNULL (X1.NEW_VALUE1, packer_code), '')             AS packer_code
                               , ISNULL(pack_model_code, '')         AS pack_model_code
                               , ISNULL(attr_01, '')                 AS line_id           -- attr_1 (Line_ID)
                               , ISNULL(boxing_date, '')             AS prod_date
                               , ISNULL(pack_qty, '0')               AS prod_qty
                               , '0'                                 AS defect_qty
                          FROM   XIF_SCM_SCS_BOX_RESULT_R_SN  A WITH(NOLOCK)
							LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
							ON  X1.CODETYPE = 'SCP_SITE_ID'
							AND A.PACKER_CODE = X1.OLD_VALUE1
							AND X1.ATTRIBUTE5 = '1ST'
                          WHERE  if_seq    = @v_if_seq
                          AND    proc_flag = 'P'
						  --AND    DIVISION_ID = @v_division_id
						  AND    BOXING_DATE >= @v_boxing_date
                         ) v              
                   WHERE  division_id                 <> ''
                   AND    ISNULL(scm_site_id, '')     <> ''
                   AND    ISNULL(pack_model_code, '') <> ''
		          ) b
			ON (	   a.division_id     =  b.division_id
				   --AND a.cutoff_date	 =  b.cutoff_date
				   AND a.scm_site_id	 =  b.scm_site_id
				   AND a.pack_model_code =  b.pack_model_code -- Origin Item Id
				   AND ISNULL(a.line_id, '') =  ISNULL(b.line_id, '')
				   AND a.prod_date	     =  b.prod_date
			   )
			WHEN MATCHED THEN
				 UPDATE SET 			
				             a.cutoff_date	    =  b.cutoff_date
							,a.prod_qty			=  b.prod_qty
							,a.defect_qty       =  b.defect_qty
							,a.item_id          =  b.item_id
							,a.packer_code      =  b.packer_code
							,a.last_updated_by	=  'BOX_U'--@v_batch_user
							,a.last_update_date	=  GETDATE()
					                
			WHEN NOT MATCHED THEN
			INSERT (  
                    division_id
                  , cutoff_date
                  , scm_site_id
                  , item_id
                  , packer_code
                  , pack_model_code
                  , line_id
                  , prod_date
                  , prod_qty
                  , defect_qty
                  , created_by
                  , creation_date
                  , last_updated_by
                  , last_update_date						  								
                   )
			VALUES (   
                    b.division_id
                  , b.cutoff_date
                  , b.scm_site_id
                  , b.item_id
                  , b.packer_code
                  , b.pack_model_code
                  , b.line_id
                  , b.prod_date
                  , b.prod_qty
                  , b.defect_qty
				  , @v_batch_user
				  , GETDATE()
				  , 'BOX_I'--@v_batch_user
				  , GETDATE()
			       )
			;

			SET @n_log_count = @n_log_count + @@ROWCOUNT;

			FETCH NEXT FROM CUR_SCS_BOX_PROD_RESULT INTO  @v_if_seq
		
		END
		
		CLOSE CUR_SCS_BOX_PROD_RESULT;
		DEALLOCATE CUR_SCS_BOX_PROD_RESULT; 

		-----------------------------------------------------------
        -- INSERT LOG
        -----------------------------------------------------------
        --SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'APPEND';
        SET @v_log_message = 'INSERT INTO scm_dnm_scs_prod_result';
        SET @v_description = 'if_seq = ' + @v_if_seq;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------
		
		-- 처리된 row 마킹
		UPDATE XIF_SCM_SCS_BOX_RESULT_R_SN 
		SET    proc_flag = 'Y' 
		WHERE  proc_flag = 'P';

		-- IF data  삭제 (90일 이전 데이터 삭제) 
		DELETE 
		  FROM XIF_SCM_SCS_BOX_RESULT_R_SN 
		 WHERE IF_RCV_DATE < GETDATE() - 90

        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END
    END TRY

    BEGIN CATCH
	  IF @@TRANCOUNT > 0
		  BEGIN
            ROLLBACK;
		  END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
