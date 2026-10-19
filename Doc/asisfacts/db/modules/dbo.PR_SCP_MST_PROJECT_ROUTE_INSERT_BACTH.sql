

/*
 * Program ID   : PR_SCP_MST_PROJECT_ROUTE_INSERT_BACTH
 * Description  : Division 40 일 경우 Pack Plant가 외주이고 TCO Cell이 있는 경우 TCO Cell이 아닌 Plant 정보를 TCO Cell에 데이터 Insert
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.08.24   ygkim		   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2021.03.30   PJG            대체 BOM 모델링 적용
 * ex) EXEC PR_SCP_MST_PROJECT_ROUTE_INSERT_BACTH
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_MST_PROJECT_ROUTE_INSERT_BACTH]
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

	DECLARE @v_division_id			NVARCHAR(100)
	DECLARE @v_plant_site_id		NVARCHAR(60)
	DECLARE @v_item_id				NVARCHAR(100)
	DECLARE @v_priority				NVARCHAR(MAX)
	DECLARE @v_from_yyyymmdd		NVARCHAR(16)
	DECLARE @v_to_yyyymmdd			NVARCHAR(16)
	DECLARE @v_priority_seq		    NVARCHAR(MAX);

	SET @v_division_id = NULL;
	SET @v_plant_site_id = NULL;
	SET @v_item_id = NULL;
	SET @v_priority = NULL;
	SET @v_from_yyyymmdd = NULL;
	SET @v_to_yyyymmdd = NULL;
	SET @v_priority_seq = NULL;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'scm_batch'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_MST_PROJECT_ROUTE_INSERT_BACTH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
       
    BEGIN TRY
      BEGIN
    
        BEGIN TRANSACTION; 
		DECLARE @p_division_id NVARCHAR(100) = '40'
        /********************************************************************************
		* 임시테이블만들기
		********************************************************************************/	
		IF OBJECT_ID('tempdb..#TblDynamicPivot_BaseItemList_01') IS NOT NULL
			   DROP TABLE #TblDynamicPivot_BaseItemList_01
		
		SELECT distinct
			 t.division_id
			--,t.item_id 
			,tco.tco_item 
			,tco.tco_plant_site_id
			,n_tco.n_tco_item
			,n_tco.n_tco_plant_site_id
		INTO #TblDynamicPivot_BaseItemList_01
		FROM ( SELECT distinct a.division_id
						,a.item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id
					FROM dm_pln_mkt_fcst a 
					JOIN scm_mst_item_sn b ON a.division_id = b.division_id and a.item_id= b.item_id
				WHERE 1=1 
					AND a.measure ='MKT_FCST'
					AND b.scp_operation_group_id <> 'E'
					AND a.yyyymmdd != '' and a.yyyymmdd is not null
				--UNION ALL
				--SELECT distinct a.division_id
				--		,a.item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id
				--	FROM dm_pln_mkt_fcst_result a 
				--	JOIN scm_mst_item_sn b ON a.division_id = b.division_id and a.item_id= b.item_id
				--WHERE 1=1 
				--	AND a.measure ='MKT_FCST'
				--	AND b.scp_operation_group_id <> 'E'
				--	AND a.yyyymmdd != '' and a.yyyymmdd is not null			  	
				) t  
				LEFT OUTER JOIN  (SELECT division_id							 
										,model_id
										,tot_cnt plant_per_item
										,CASE WHEN SUM(plant_cnt) = tot_cnt THEN 'Y' ELSE 'N' END cmpltd_status
								FROM (
									SELECT division_id,model_id, COUNT(*) OVER(PARTITION BY division_id,model_id) AS tot_cnt, CASE WHEN primary_plant IS NOT NULL THEN 1 ELSE 0 END AS plant_cnt
									FROM (
											SELECT DISTINCT	
														(CASE WHEN dbo.FN_GET_ITEM_OPERATION_GROUP(a.division_id, a.item_id) = 'E' THEN C.ITEM_ID
															ELSE b.model_id	
														END ) AS model_id	
													, (CASE
															-- 전극 제외 20180517
															-- WHEN d.operation_group_id = 'E' THEN 'Electrode'
															WHEN d.operation_group_id = 'A' THEN 'Cell'
															WHEN d.operation_group_id = 'P' THEN 'Pack'
														END ) AS operation_group_id
													,d.electrode_type
													,b.child_item_id AS item_id
													,(SELECT rownumber 
														FROM (		
															SELECT ROW_NUMBER() OVER (ORDER BY from_yyyymmdd) AS rownumber
												 				FROM scm_mst_site_item_priority s 
															WHERE s.division_id   = b.division_id
																AND s.item_id       = b.child_item_id 
																AND s.to_yyyymmdd  >= convert(varchar, getdate(),112) 
																AND s.valid_yn = 'Y'
																AND s.priority = '1'
	 														) a 
														WHERE rownumber =1
													) AS primary_plant
													,b.division_id
											FROM dm_pln_mkt_fcst     a 
											    -- 2021.03.30 대체 BOM 모델링
												--JOIN scm_mst_bom_sn  b   ON a.division_id   = b.division_id
												JOIN SCM_MST_BOM_SN_V  b   ON a.division_id   = b.division_id
																		AND a.item_id       = b.model_id 	
												JOIN scm_mst_item_sn c   ON b.company_id    = c.company_id 
																		AND b.division_id   = c.division_id	
																		AND b.site_id       = c.site_id 
																		AND b.child_item_id = c.item_id
												JOIN scm_mst_final_item_v d  ON b.division_id = d.division_id  and b.child_item_id = d.item_id
											WHERE 1=1
											--Alternate Part 제외로직 추가
											AND	b.alt_priority  = 'Y'
											AND c.item_type		<> 'r'
											--  실적(등록된 카운트)수량은 분기되기 이전 날짜 전체를 사용해야 카운트가 맞음
									 		AND a.measure ='MKT_FCST'
			  								AND a.qty>0	
											AND a.division_id = @p_division_id
											AND d.OPERATION_GROUP_ID <> 'E'
											--ESS 팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
											AND EXISTS (SELECT *
														FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
														WHERE DIVISION_ID = @p_division_id
															AND PARENT_ITEM_ID= b.child_item_id
															--BOM을 제거모델 조회안되도록 수정
															AND EFF_END_DATE >= GETDATE()
															AND KEY_DATE = ( SELECT MAX(KEY_DATE)
																			FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
																		WHERE PARENT_ITEM_ID= b.child_item_id --'ECE0315N1-01'
																 			AND DIVISION_ID = @p_division_id )
														)
											) m
										) n
								GROUP BY division_id 
										,model_id, tot_cnt
							) u  ON t.division_id  = u.division_id
								AND t.item_id      = u.model_id
				INNER JOIN  (SELECT division_id
		   						,item_id
		   						,nick_name
		   						,item_type
		   						,ROW_NUMBER() OVER ( PARTITION BY division_id, item_id ORDER BY  CASE item_type WHEN 'P' THEN 999 WHEN 'H' THEN 888 WHEN 'R' THEN 777  WHEN 'Q' THEN 666 ELSE 0 END  DESC ) nums
							FROM SCM_MST_ITEM_SN 
							) i   ON t.division_id  = i.division_id
								AND t.item_id      = i.item_id
								AND i.nums =1
				----Bom에 Pack일 경우 외주 인것만 가져온다.
				--INNER JOIN (SELECT a.DIVISION_ID, a.ITEM_ID
				--		FROM scm_mst_site_item_priority a
				--		JOIN scm_mst_site b ON a.division_id = b.division_id and a.PLANT_SITE_ID = b.scm_site_id
				--		WHERE 1=1
				--			and b.OSP_YN = 'Y'
				--			and b.OPERATION_GROUP = 'P') o on o.DIVISION_ID = t.DIVISION_ID and o.ITEM_ID = t.ITEM_ID
				--TCO 인 것만 가져온다.
				INNER JOIN (SELECT 
								t.MODEL_ID
							,t.CHILD_ITEM_ID tco_item
							,t.division_id
							,a.PLANT_SITE_ID tco_plant_site_id
						-- 2021.03.30 대체 BOM 모델링
						--FROM scm_mst_bom_sn t (NOLOCK)
						FROM SCM_MST_BOM_SN_V t (NOLOCK)
						JOIN scm_mst_item_sn i ON t.company_id = i.company_id and t.division_id = i.division_id	and t.site_id = i.site_id and t.child_item_id = i.item_id
						JOIN scm_mst_final_item_v v ON t.division_id = v.division_id  and t.child_item_id = v.item_id
						LEFT OUTER JOIN (SELECT DIVISION_ID, ITEM_ID, PLANT_SITE_ID
								FROM (		
										SELECT a.DIVISION_ID, a.ITEM_ID, a.PLANT_SITE_ID
											,ROW_NUMBER() OVER (PARTITION BY a.DIVISION_ID, a.ITEM_ID ORDER BY from_yyyymmdd) AS rownumber
										FROM scm_mst_site_item_priority a
										JOIN scm_mst_site b ON a.division_id = b.division_id and a.PLANT_SITE_ID = b.scm_site_id
										WHERE 1=1
										AND a.to_yyyymmdd >=  convert(varchar, getdate(),112)
										AND a.valid_yn ='Y'
										AND a.priority ='1'
									) a 
								WHERE rownumber =1) a on a.DIVISION_ID = t.DIVISION_ID and a.ITEM_ID = t.child_item_id
						WHERE 1=1
						AND t.alt_priority ='Y'
						AND i.item_type		<> 'R'
						AND t.division_id	= @p_division_id
						AND v.OPERATION_GROUP_ID  = 'A'
						AND SUBSTRING(t.child_item_id,2,1) != 'C'
						AND a.PLANT_SITE_ID IS NOT NULL
						AND EXISTS (SELECT *
								FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
								WHERE DIVISION_ID = @p_division_id --'82'
									AND PARENT_ITEM_ID= t.child_item_id 
									AND EFF_END_DATE >= GETDATE()
									AND KEY_DATE = ( SELECT MAX(KEY_DATE)
													FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
													WHERE PARENT_ITEM_ID= t.child_item_id --'ECE0315N1-01'
														AND DIVISION_ID = @p_division_id )
								)) tco ON tco.division_id = t.division_id and tco.model_id = t.item_id
			--TCO 아닌 Cell
			INNER JOIN (SELECT 
								t.MODEL_ID
							,t.CHILD_ITEM_ID n_tco_item
							,t.division_id
							,a.PLANT_SITE_ID n_tco_plant_site_id
						-- 2021.03.30 대체 BOM 모델링
						--FROM scm_mst_bom_sn t (NOLOCK)
						FROM SCM_MST_BOM_SN_V t (NOLOCK)
						JOIN scm_mst_item_sn i ON t.company_id = i.company_id and t.division_id = i.division_id	and t.site_id = i.site_id and t.child_item_id = i.item_id
						JOIN scm_mst_final_item_v v ON t.division_id = v.division_id  and t.child_item_id = v.item_id
						LEFT OUTER JOIN (SELECT DIVISION_ID, ITEM_ID, PLANT_SITE_ID
								FROM (		
										SELECT a.DIVISION_ID, a.ITEM_ID, a.PLANT_SITE_ID
											,ROW_NUMBER() OVER (PARTITION BY a.DIVISION_ID, a.ITEM_ID ORDER BY from_yyyymmdd) AS rownumber
										FROM scm_mst_site_item_priority a
										JOIN scm_mst_site b ON a.division_id = b.division_id and a.PLANT_SITE_ID = b.scm_site_id
										WHERE 1=1
										AND a.to_yyyymmdd >=  convert(varchar, getdate(),112)
										AND a.valid_yn ='Y'
										AND a.priority ='1'
									) a 
								WHERE rownumber =1) a on a.DIVISION_ID = t.DIVISION_ID and a.ITEM_ID = t.child_item_id
						WHERE 1=1
						AND t.alt_priority ='Y'
						AND i.item_type		<> 'R'
						AND t.division_id	= @p_division_id
						AND v.OPERATION_GROUP_ID  = 'A'
						AND SUBSTRING(t.child_item_id,2,1) = 'C'
						AND a.PLANT_SITE_ID IS NOT NULL
						AND EXISTS (SELECT *
								FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
								WHERE DIVISION_ID = @p_division_id --'82'
									AND PARENT_ITEM_ID= t.child_item_id 
									AND EFF_END_DATE >= GETDATE()
									AND KEY_DATE = ( SELECT MAX(KEY_DATE)
													FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
													WHERE PARENT_ITEM_ID= t.child_item_id --'ECE0315N1-01'
														AND DIVISION_ID = @p_division_id )
								)) n_tco ON n_tco.division_id = t.division_id and n_tco.model_id = t.item_id
		WHERE 1=1
			AND i.item_type NOT IN ('Q','R')	
			AND t.measure ='MKT_FCST'
			AND t.division_id=@p_division_id
			AND u.cmpltd_status = 'Y'
			AND u.plant_per_item > 2
			AND ((NOT EXISTS(SELECT 1 FROM SCM_MST_SITE_ITEM B WHERE B.DIVISION_ID = t.DIVISION_ID AND B.ITEM_ID = tco.tco_item AND B.SCM_SITE_ID = n_tco.n_tco_plant_site_id))
			  OR (NOT EXISTS(SELECT 1 FROM SCM_MST_SITE_ITEM_PRIORITY B WHERE B.DIVISION_ID = t.DIVISION_ID AND B.ITEM_ID = tco.tco_item AND B.PLANT_SITE_ID = n_tco.n_tco_plant_site_id)))

		/********************************************************************************
		* SCM_MST_SITE_ITEM_H INSERT
		********************************************************************************/	
		INSERT INTO SCM_MST_SITE_ITEM_H
				(history_seq
				,DIVISION_ID
				,PROJECT_CODE
				,SCM_SITE_ID
				,ITEM_ID
				,CURRENCY
				,LIABILITY_PERIOD
				,SALES_PLAN_ADJUST_YN
				,ITEM_HRCY_ID
				,VALID_YN
				,BPMS_EXIST
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,HISTORY_CREATION_DATE)
		SELECT NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_H history_seq
		      ,division_id
		      ,'-' project_code
			  ,a.n_tco_plant_site_id scm_site_id
			  ,a.tco_item item_id
			  ,NULL currency
			  ,NULL liability_period
			  ,NULL sales_plan_adjust_yn
			  ,NULL item_hrcy_id
			  ,'Y' valid_yn
			  ,'Y' bpms_exist
			  ,@v_batch_user created_by
			  ,SYSDATETIME() creation_date
			  ,@v_batch_user last_updated_by
			  ,SYSDATETIME() last_update_date 
			  ,SYSDATETIME() history_creation_date 
		FROM #TblDynamicPivot_BaseItemList_01 A
		WHERE 1=1
		  AND NOT EXISTS(SELECT 1 FROM SCM_MST_SITE_ITEM B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.tco_item AND B.SCM_SITE_ID = a.n_tco_plant_site_id)
		/********************************************************************************
		* SCM_MST_SITE_ITEM INSERT
		********************************************************************************/	
		INSERT INTO SCM_MST_SITE_ITEM
				(DIVISION_ID
				,PROJECT_CODE
				,SCM_SITE_ID
				,ITEM_ID
				,CURRENCY
				,LIABILITY_PERIOD
				,SALES_PLAN_ADJUST_YN
				,ITEM_HRCY_ID
				,VALID_YN
				,BPMS_EXIST
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE)
		SELECT division_id
		      ,'-' project_code
			  ,a.n_tco_plant_site_id scm_site_id
			  ,a.tco_item item_id
			  ,NULL currency
			  ,NULL liability_period
			  ,NULL sales_plan_adjust_yn
			  ,NULL item_hrcy_id
			  ,'Y' valid_yn
			  ,'Y' bpms_exist
			  ,@v_batch_user created_by
			  ,SYSDATETIME() creation_date
			  ,@v_batch_user last_updated_by
			  ,SYSDATETIME() last_update_date 
		FROM #TblDynamicPivot_BaseItemList_01 A
		WHERE 1=1
		  AND NOT EXISTS(SELECT 1 FROM SCM_MST_SITE_ITEM B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.tco_item AND B.SCM_SITE_ID = a.n_tco_plant_site_id)
		
		/********************************************************************************
		* SCM_MST_SITE_ITEM_PRIORITY INSERT
		********************************************************************************/	
		
		DECLARE CUR_PRIORITY CURSOR FOR 
		SELECT a.division_id
			  ,a.n_tco_plant_site_id PLANT_SITE_ID
			  ,a.tco_item item_id
			  ,(90 + b.PRIORITY) priority
			  ,b.FROM_YYYYMMDD from_yyyymmdd
			  ,b.TO_YYYYMMDD to_yyyymmdd
		FROM #TblDynamicPivot_BaseItemList_01 A
		INNER JOIN SCM_MST_SITE_ITEM_PRIORITY b on b.DIVISION_ID = a.DIVISION_ID and b.ITEM_ID = a.tco_item and b.PLANT_SITE_ID = a.tco_plant_site_id and b.VALID_YN = 'Y'
		WHERE 1=1
		  AND NOT EXISTS(SELECT 1 FROM SCM_MST_SITE_ITEM_PRIORITY B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.tco_item AND B.PLANT_SITE_ID = A.n_tco_plant_site_id)
		
		OPEN CUR_PRIORITY;
		FETCH NEXT FROM CUR_PRIORITY INTO @v_division_id, @v_plant_site_id, @v_item_id, @v_priority, @v_from_yyyymmdd, @v_to_yyyymmdd

		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @v_priority_seq = NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_PRIORITY;
				--이력 저장
				EXEC [PR_SCM_MST_SITE_ITEM_PRIORITY_HIST] @v_priority_seq
				                                         ,@v_division_id
														 ,'-'
														 ,'-'
														 ,@v_plant_site_id
														 ,@v_item_id 
														 ,@v_priority
														 ,@v_from_yyyymmdd
														 ,@v_to_yyyymmdd
														 ,'Y'
														 ,@v_batch_user
														 ,@d_event_date
														 ,@v_batch_user ;

				INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
						(PRIORITY_SEQ
						,DIVISION_ID
						,PLANT_SITE_ID
						,SALES_SITE_ID
						,PROJECT_CODE
						,ITEM_ID
						,PRIORITY
						,FROM_YYYYMMDD
						,TO_YYYYMMDD
						,VALID_YN
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE)
				VALUES(@v_priority_seq
				      ,@v_division_id
					  ,@v_plant_site_id
					  ,'-'
					  ,'-'
					  ,@v_item_id
					  ,@v_priority
					  ,@v_from_yyyymmdd
					  ,@v_to_yyyymmdd
					  ,'Y'
					  ,@v_batch_user
					  ,@d_event_date
					  ,@v_batch_user
					  ,@d_event_date
			    );

				FETCH NEXT FROM CUR_PRIORITY INTO @v_division_id, @v_plant_site_id, @v_item_id, @v_priority, @v_from_yyyymmdd, @v_to_yyyymmdd				
			END
		CLOSE CUR_PRIORITY;
		DEALLOCATE CUR_PRIORITY;

        ----------------------------------------------------------- 
        --  종료 처리
        -----------------------------------------------------------

        IF @@TRANCOUNT > 0 
          BEGIN
            COMMIT WORK;
          END;

        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        SET @v_log_type = 'TXN';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      END;

    END TRY

    BEGIN CATCH
        
      IF @@TRANCOUNT > 0 
        BEGIN
          ROLLBACK;
        END;

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    return 1  


  END;

