
/*
 * Program ID   : PR_SCP_MST_BOD_ITEM
 * Description  : BOD ITEM Create 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.09.10   Kim SungGi     Initial Release 전지본부 GSCM(소형) 구축 프로젝트
 * 2020.03.19   KSG            'W' 는 Sales 처럼 양 쪽애 등록되어야 BOD Item 생성
 * 2021.07.23   khj79          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 Phase2 - BOD LT 2단계 개발(FROM_YYYYMMDD, TO_YYYYMMDD 추가) 및 BOD ITEM 동기화를 위한 BOD_ID 추가
 * 2023.06.15   hrkim          PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : n-ERP 활성화 코드 분리 대응
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_BOD_ITEM]
	@p_bod_id  NVARCHAR(MAX) = NULL
  --@p_division_id  NVARCHAR(150) = '81'
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_BOD_ITEM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @v_division_id       NVARCHAR(30);

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

    -- 시작 LOG
    SET @v_log_type    = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '[PR_SCP_MST_BOD_ITEM]';
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
    
      --SET @v_division_id = @p_division_id;
		
      -----------------------------------------------------------
      -- 실행 Logic START --
      -----------------------------------------------------------
      BEGIN
		  
        -----------------------------------------------------------
        -- 0. 참조 대상 site item 정보 
		-- PJ20230691 활성화코드 분리 대응 - Cell Assy 제외 
        -----------------------------------------------------------
         IF OBJECT_ID('tempdb..#tmp_scm_mst_site_item') IS NOT NULL                        
             DROP TABLE #tmp_scm_mst_site_item ;
		 SELECT si.*
		  INTO #tmp_scm_mst_site_item
		  FROM scm_mst_site_item si WITH (NOLOCK)
			   left join SCP_MST_FINAL_ITEM_V fi WITH(NOLOCK)
					  on fi.item_id = si.item_id
					 and fi.cell_type like 'CA%' -- Cell Assy
		 WHERE si.valid_yn    = 'Y' 
		   AND fi.item_id is null -- Cell Assy 제외 
		 ;

        -----------------------------------------------------------
        -- 1. PLANT -> SALES 생성
        -----------------------------------------------------------
        INSERT INTO scp_mst_bod_item
		           (seq, division_id, bod_id, item_id
                  , priority
                  , from_yyyymmdd, to_yyyymmdd, valid_yn
                  , created_by, creation_date, last_updated_by, last_update_date
                   )
        SELECT NEXT VALUE FOR SEQ1_SCP_MST_BOD_ITEM AS seq   --row_number() OVER ( order by a.division_id, a.bod_id, a.item_id)  AS seq
		     , a.division_id, a.bod_id, a.item_id
			 , 99 AS priority
			 -- BOD LT 2단계 개발
			 , CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) AS FROM_YYYYMMDD -- 전주 월요일
			 , '21001226' AS TO_YYYYMMDD                                                                    -- 미래 일요일
			 , 'Y' AS valid_yn
             , 'scp_batch', GETDATE(), 'scp_batch', GETDATE()
        FROM  (
		       SELECT DISTINCT b.division_id, b.bod_id, fsi.item_id
               FROM  (SELECT *
                      FROM  scp_mst_bod WITH (NOLOCK) 
		              WHERE valid_yn    = 'Y'
					    AND (( @p_bod_id IS NULL OR @p_bod_id ='') OR BOD_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_bod_id , @v_delimiter)))
					  --WHERE division_id = '81'
		              --AND   valid_yn    = 'Y'           
		             ) b 
                    ,(SELECT *
		              FROM  scm_mst_site WITH (NOLOCK) 
		              WHERE valid_yn    = 'Y'
		             ) fs 
                    ,(SELECT *
		              FROM  scm_mst_site WITH (NOLOCK) 
		              WHERE valid_yn    = 'Y'  
		             ) ts 
                    ,(SELECT *
					  FROM #tmp_scm_mst_site_item	-- PJ20230691 활성화코드 분리 대응 - Cell Assy 제외
		              -- FROM  scm_mst_site_item WITH (NOLOCK) 
		              -- WHERE valid_yn    = 'Y'
		             ) fsi 
                    ,(SELECT *
					  FROM #tmp_scm_mst_site_item	-- PJ20230691 활성화코드 분리 대응 - Cell Assy 제외
		              -- FROM  scm_mst_site_item WITH (NOLOCK) 
		              -- WHERE valid_yn    = 'Y'
		             ) tsi 
               WHERE  b.division_id   = fs.division_id
               AND    b.division_id   = ts.division_id
               AND    b.division_id   = fsi.division_id
               AND    b.division_id   = tsi.division_id
               AND    b.from_site     = fs.scm_site_id
               AND    b.to_site       = ts.scm_site_id
               AND    b.from_site     = fsi.scm_site_id
               AND    b.to_site       = tsi.scm_site_id
               AND    fsi.item_id     = tsi.item_id
			   -- 기존재하는 정보는 제외
			   EXCEPT
			   SELECT division_id, bod_id, item_id
               FROM   scp_mst_bod_item WITH (NOLOCK) 
              ) a
        ;
        
		-----------------------------------------------------------
        -- Insert LOG
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = '1. INSERT INTO SCP_MST_BOD_ITEM : PLANT -> SALES';
        SET @v_description = 'PLANT -> SALES';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
		  
        -----------------------------------------------------------
        -- 2. PLANT -> PLANT 생성
		--    To Site 가 PLANT 인 경우 From에 Assign된 모든 모델에 대하여 BOD Item 생성
		--      => Cell/전극은 To Site 인 Pacl/Cell Plant에 Assign되지 않았기 때문
        -----------------------------------------------------------
        INSERT INTO scp_mst_bod_item
		           (seq, division_id, bod_id, item_id
                  , priority
                  , from_yyyymmdd, to_yyyymmdd, valid_yn
                  , created_by, creation_date, last_updated_by, last_update_date
                   )
        SELECT NEXT VALUE FOR SEQ1_SCP_MST_BOD_ITEM AS seq --row_number() OVER ( order by a.division_id, a.bod_id, a.item_id)  AS seq
		     , a.division_id, a.bod_id, a.item_id
			 , 99 AS priority
			 -- BOD LT 2단계 개발
			 , CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) AS FROM_YYYYMMDD -- 전주 월요일
			 , '21001226' AS TO_YYYYMMDD                                                                    -- 미래 일요일
			 , 'Y' AS valid_yn
             , 'scp_batch', GETDATE(), 'scp_batch', GETDATE()
        FROM  (
		       SELECT DISTINCT b.division_id, b.bod_id, fsi.item_id
               FROM  (SELECT *
                      FROM  scp_mst_bod WITH (NOLOCK) 
		              WHERE valid_yn    = 'Y'
					  AND (( @p_bod_id IS NULL OR @p_bod_id ='') OR BOD_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_bod_id , @v_delimiter)))
		              --WHERE division_id = '81'
		              --AND   valid_yn    = 'Y' 
		             ) b 
                    ,(SELECT *
		              FROM  scm_mst_site WITH (NOLOCK) 
		              WHERE valid_yn    = 'Y' 
		             ) fs 
                    ,(SELECT *
		              FROM  scm_mst_site WITH (NOLOCK) 
		              WHERE valid_yn         = 'Y'
		              AND   site_type        = 'PLANT' 
					  AND   operation_group <> 'W' -- 20200319 'W' 는 Sales 처럼 양 쪽애 등록되어야 BOD Item 생성
		             ) ts 
                    ,(SELECT *
					  FROM #tmp_scm_mst_site_item	-- PJ20230691 활성화코드 분리 대응 - Cell Assy 제외
		              -- FROM  scm_mst_site_item WITH (NOLOCK) 
		              -- WHERE valid_yn    = 'Y'
		             ) fsi 
               WHERE  1=1
			   -- 전극때문에 사업부가 다른 From/To가 연결되므로 division_id 조건 제거
			   --AND    b.division_id   = fs.division_id
      --         AND    b.division_id   = ts.division_id
      --         AND    b.division_id   = fsi.division_id
               AND    b.from_site     = fs.scm_site_id
               AND    b.to_site       = ts.scm_site_id
               AND    b.from_site     = fsi.scm_site_id
			   -- 기존재하는 정보는 제외
			   EXCEPT
			   SELECT division_id, bod_id, item_id
               FROM   scp_mst_bod_item WITH (NOLOCK) 
              ) a
         ;
			  
        -----------------------------------------------------------
        -- Insert LOG
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = '2. INSERT INTO SCP_MST_BOD_ITEM : PLANT -> PLANT';
        SET @v_description = 'PLANT -> PLANT';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
		
        -----------------------------------------------------------
        -- 3. From / To YYYYMMDD update : BOD LT 2단계 개발
		--    BOD의 From/To로 BOD Item Update
        -----------------------------------------------------------
		UPDATE x
		SET    x.from_yyyymmdd = ISNULL(b.attribute2, x.from_yyyymmdd)
		     , x.to_yyyymmdd   = ISNULL(b.attribute3, x.to_yyyymmdd)
			 --, x.last_updated_by  = 'yyyymmdd update'
			 --, x.last_update_date = GETDATE()
		FROM   scp_mst_bod_item x WITH(NOLOCK)
		     , scp_mst_bod b WITH (NOLOCK) 
		WHERE  x.division_id = b.division_id
		AND    x.bod_id      = b.bod_id
	    AND (( @p_bod_id IS NULL OR @p_bod_id ='') OR x.bod_id IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_bod_id , @v_delimiter)))
		;
			  
        -----------------------------------------------------------
        -- Insert LOG
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = '3. From / To YYYYMMDD update';
        SET @v_description = '';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'SCP_MST_BOD_ITEM';
        SET @v_description = 'Process Complete.' ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
        BEGIN
          COMMIT WORK;
        END;

      END;
    
    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR LINE ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '[PR_SCP_MST_BOD_ITEM]' ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
