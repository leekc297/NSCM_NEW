/*
 * Program ID   : PR_SCM_DNM_DELIVERY_TRACKING
 * Description  : Delivery Tracking 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.26   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.22   Kim Jihye      shipment_no, container_no 기준 중복 데이타 처리
 * 2018.12.04   KSG            company_id 추가
 * 2021.09.29   KSG            C20210928-000189 운송중 재고(Trucking) ETA 정보 반영 관련 : 컬럼 추가
 * 2022.07.20   SSP Pjt.       ZFCY2ATA, ZFCY2ATD 추가
 * 2022.08.10   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ETA 정보 반영 관련 컬럼 추가
                               ZFCY1,ZFCY1ETA,ZFCY1ATA,ZFCY1ETD,ZFCY1ATD,
                               ZFCY2,ZFCY2ETA,ZFCY2ETD,
                               ZFCY3,ZFCY3ETA,ZFCY3ATA,
                               ZFCY3ETD,ZFCY3ATD,ZLANDETD,
                               ZLANDETA,ZLANDATD,ZLANDATA
 * 2024.06.09   vadabi3        NERP - 특정 Company 별도 처리 개선
 * 2024.10.28   vadabi3        NERP - 개발 DB 적용 
 * 2025.10.24	ymh			   [E20251016-001549] INTRANSIT_INVENTORY 중복재고 건(NERP) 대응 임시조치.
 ----------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_SCM_DNM_DELIVERY_TRACKING]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_DELIVERY_TRACKING';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno     NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;

	-- NERP 매핑코드
    DECLARE @v_ESOC NVARCHAR(8);
	SELECT @v_ESOC = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_DELIVERY_TRACKING','ESOC');

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
	--BEGIN TRANSACTION
      BEGIN

	  -- 20251016 YMH [E20251016-001549] INTRANSIT_INVENTORY 중복재고 건(NERP) 대응 임시조치.
		UPDATE XIF_ERP_DELIVERY_TRACKING_R_SN 
			SET ATTRIBUTE1 = (SELECT NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' AND OLD_VALUE1 = XIF_ERP_DELIVERY_TRACKING_R_SN.ATTRIBUTE1)
		WHERE ATTRIBUTE1 IN
		(
			SELECT OLD_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID'
		) 
		and (SELECT NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' AND OLD_VALUE1 = XIF_ERP_DELIVERY_TRACKING_R_SN.ATTRIBUTE1) <> ''
		AND TRANSFER_DATE >= '20251003'
		AND TRANSFER_FLAG = 'N'


	  -- 인터페이스 테이블 처리 ROW UPDATE
		UPDATE [dbo].[XIF_ERP_DELIVERY_TRACKING_R_SN]
		SET    TRANSFER_FLAG = 'P'
		WHERE  dbo.FN_SCM_SYS_NVL(TRANSFER_FLAG,'N') = 'N';
	  
	  -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	  DECLARE CUR_TRACKING CURSOR FOR
	    SELECT IFSEQNO 
	    FROM   [dbo].[XIF_ERP_DELIVERY_TRACKING_R_SN] WITH(NOLOCK)
	    WHERE  TRANSFER_FLAG = 'P'
	    GROUP BY IFSEQNO
	    ORDER BY IFSEQNO ASC;

	  -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
	  IF OBJECT_ID('dbo.scm_dnm_delivery_tracking_temp$') IS NOT NULL DROP TABLE scm_dnm_delivery_tracking_temp$

	  -- 데이터가 누적 되기 때문에, history 비교 시 변경 대상이 되는 row 로만 temp table 생성
	   
	  SELECT * 
	  INTO   dbo.scm_dnm_delivery_tracking_temp$
	  FROM   dbo.scm_dnm_delivery_tracking WITH(NOLOCK)
	  -- 20181204 company_id 추가
	  WHERE  company_id+shipment_no+container_no 
	                                  IN (SELECT dbo.FN_SCM_SYS_NVL(attribute1, @v_ESOC)+shipment_no+container_no 
	                                      FROM   xif_erp_delivery_tracking_r_sn WITH(NOLOCK) 
										  WHERE  transfer_flag = 'P');
	  --WHERE  shipment_no+container_no IN (SELECT shipment_no+container_no 
	  --                                    FROM   xif_erp_delivery_tracking_r_sn WITH(NOLOCK) 
			--							  WHERE  transfer_flag = 'P');

	  OPEN CUR_TRACKING;
	  FETCH NEXT FROM CUR_TRACKING INTO @v_ifseqno ;
		 
		WHILE (@@FETCH_STATUS = 0)
		  BEGIN
		   
			MERGE INTO [dbo].[scm_dnm_delivery_tracking] A
			USING (SELECT /* PR_SCM_DNM_DELIVERY_TRACKING */ 
	                      -- 20181204 company_id 추가
						   dbo.FN_SCM_SYS_NVL(attribute1, @v_ESOC) AS company_id
			              ,shipment_no
						  ,dbo.FN_SCM_SYS_NVL(container_no,'-') AS container_no
						  ,route
						  ,incoterms
						  ,carrier
						  ,pol_port
						  ,shipping_date
						  ,pol_atd_date
						  ,ts1_port
						  ,ts1_eta_date
						  ,ts1_ata_date
						  ,ts1_etd_date
						  ,ts1_atd_date
						  ,ts2_port
						  ,ts2_eta_date
						  ,ts2_ata_date
						  ,ts2_etd_date
						  ,ts2_atd_date
						  ,ts3_port
						  ,ts3_eta_date
						  ,ts3_ata_date
						  ,ts3_etd_date
						  ,ts3_atd_date
						  ,pod_port
						  ,pod_eta_date
						  ,pod_ata_date
						  ,pod_etd_date
						  ,pod_atd_date
						  ,f_dest_port
						  ,f_dest_eta_date
						  ,f_dest_ata_date
						  ,attribute2  -- 20210929 C20210928-000189  내륙운송 ATD
						  ,attribute3  -- 20210929 C20210928-000189  내륙운송 ATA
						  ,REPLACE(IIF(ZFCY2ATA = '0000-00-00','',ZFCY2ATA), '-', '') AS ZFCY2ATA    --CY2 도착일(Actual)
						  ,REPLACE(IIF(ZFCY2ATD = '0000-00-00','',ZFCY2ATD), '-', '') AS ZFCY2ATD    --CY2 출발일(Actual)
						  
                          -- PJ20216994
                          ,ZFCY1                                                                     -- CY1
                          ,REPLACE(IIF(ZFCY1ETA = '0000-00-00','',ZFCY1ETA), '-', '') ZFCY1ETA       -- CY1 도착일(Estimate)
                          ,REPLACE(IIF(ZFCY1ATA = '0000-00-00','',ZFCY1ATA), '-', '') ZFCY1ATA       -- CY1 도착일(Actual)
                          ,REPLACE(IIF(ZFCY1ETD = '0000-00-00','',ZFCY1ETD), '-', '') ZFCY1ETD       -- CY1 출발일(Estimate)
                          ,REPLACE(IIF(ZFCY1ATD = '0000-00-00','',ZFCY1ATD), '-', '') ZFCY1ATD       -- CY1 출발일(Actual)
                          ,ZFCY2                                                                     -- CY2
                          ,REPLACE(IIF(ZFCY2ETA = '0000-00-00','',ZFCY2ETA), '-', '') ZFCY2ETA       -- CY2 도착일(Estimate)                          
                          ,REPLACE(IIF(ZFCY2ETD = '0000-00-00','',ZFCY2ETD), '-', '') ZFCY2ETD       -- CY2 출발일(Estimate)
                          ,ZFCY3                                                                     -- CY3
                          ,REPLACE(IIF(ZFCY3ETA = '0000-00-00','',ZFCY3ETA), '-', '') ZFCY3ETA       -- CY3 도착일(Estimate)
                          ,REPLACE(IIF(ZFCY3ATA = '0000-00-00','',ZFCY3ATA), '-', '') ZFCY3ATA       -- CY3 도착일(Actual)
                          ,REPLACE(IIF(ZFCY3ETD = '0000-00-00','',ZFCY3ETD), '-', '') ZFCY3ETD       -- CY3 출발일(Estimate)
                          ,REPLACE(IIF(ZFCY3ATD = '0000-00-00','',ZFCY3ATD), '-', '') ZFCY3ATD       -- CY3 출발일(Actual)
                          ,REPLACE(IIF(ZLANDETD = '0000-00-00','',ZLANDETD), '-', '') ZLANDETD       -- 내륙운송 도착일(Estimate)
                          ,REPLACE(IIF(ZLANDETA = '0000-00-00','',ZLANDETA), '-', '') ZLANDETA       -- 내륙운송 출발일(Estimate)
                          ,REPLACE(IIF(ZLANDATD = '0000-00-00','',ZLANDATD), '-', '') ZLANDATD       -- 내륙운송 출발일(Actual)
                          ,REPLACE(IIF(ZLANDATA = '0000-00-00','',ZLANDATA), '-', '') ZLANDATA       -- 내륙운송 도착일(Actual)
				   FROM  ( SELECT *
						         ,ROW_NUMBER() OVER(PARTITION BY shipment_no, container_no ORDER BY shipping_date DESC) num -- 2018.05.22   Kim Jihye
						   FROM [dbo].[XIF_ERP_DELIVERY_TRACKING_R_SN]A WITH(NOLOCK)
						   WHERE ifseqno = @v_ifseqno
						   AND transfer_flag = 'P') T
				   WHERE   num=1) B
	                      
			ON (          A.company_id		=	  B.company_id  -- 20181204 company_id 추가
				      AND A.shipment_no		=	  B.shipment_no
				      AND A.container_no	=	  B.container_no
			   )
			WHEN MATCHED THEN
				 UPDATE SET 
							 A.route			=  B.route
							,A.incoterms	    =  B.incoterms
							,A.carrier			=  B.carrier
							,A.pol				=  B.pol_port
							,A.shipping_date	=  B.shipping_date
							,A.pol_atd_date		=  B.pol_atd_date
							,A.ts1_port			=  B.ts1_port
							,A.ts1_eta_date		=  B.ts1_eta_date
							,A.ts1_ata_date		=  B.ts1_ata_date
							,A.ts1_etd_date		=  B.ts1_etd_date
							,A.ts1_atd_date		=  B.ts1_atd_date
							,A.ts2_port			=  B.ts2_port
							,A.ts2_eta_date		=  B.ts2_eta_date
							,A.ts2_ata_date		=  B.ts2_ata_date
							,A.ts2_etd_date		=  B.ts2_etd_date
							,A.ts2_atd_date		=  B.ts2_atd_date
							,A.ts3_port			=  B.ts3_port
							,A.ts3_eta_date		=  B.ts3_eta_date
							,A.ts3_ata_date		=  B.ts3_ata_date
							,A.ts3_etd_date		=  B.ts3_etd_date
							,A.ts3_atd_date		=  B.ts3_atd_date
							,A.pod				=  B.pod_port
							,A.pod_eta_date		=  B.pod_eta_date
							,A.pod_ata_date		=  B.pod_ata_date
							,A.pod_etd_date		=  B.pod_etd_date
							,A.pod_atd_date		=  B.pod_atd_date
							,A.f_dest_port_code	=  B.f_dest_port
							,A.f_dest_eta_date	=  B.f_dest_eta_date
							,A.f_dest_ata_date	=  B.f_dest_ata_date
							,A.attribute2   	=  B.attribute2  -- 20210929 C20210928-000189  내륙운송 ATD
							,A.attribute3   	=  B.attribute3  -- 20210929 C20210928-000189  내륙운송 ATA							
							,A.last_updated_by	=  @v_batch_user
							,A.last_update_date	=  GETDATE()
							,A.ZFCY2ATA			=  B.ZFCY2ATA
							,A.ZFCY2ATD			=  B.ZFCY2ATD
							
                             -- PJ20216994
                            ,A.ZFCY1   =  B.ZFCY1
                            ,A.ZFCY1ETA   =  B.ZFCY1ETA
                            ,A.ZFCY1ATA   =  B.ZFCY1ATA
                            ,A.ZFCY1ETD   =  B.ZFCY1ETD
                            ,A.ZFCY1ATD   =  B.ZFCY1ATD
                            ,A.ZFCY2   =  B.ZFCY2
                            ,A.ZFCY2ETA   =  B.ZFCY2ETA
                            ,A.ZFCY2ETD   =  B.ZFCY2ETD
                            ,A.ZFCY3   =  B.ZFCY3
                            ,A.ZFCY3ETA   =  B.ZFCY3ETA
                            ,A.ZFCY3ATA   =  B.ZFCY3ATA
                            ,A.ZFCY3ETD   =  B.ZFCY3ETD
                            ,A.ZFCY3ATD   =  B.ZFCY3ATD
                            ,A.ZLANDETD   =  B.ZLANDETD
                            ,A.ZLANDETA   =  B.ZLANDETA
                            ,A.ZLANDATD   =  B.ZLANDATD
                            ,A.ZLANDATA   =  B.ZLANDATA
			WHEN NOT MATCHED THEN
				 INSERT (  
				           company_id  -- 20181204 company_id 추가
						  ,shipment_no
						  ,container_no
						  ,route
						  ,incoterms
						  ,carrier
						  ,pol
						  ,shipping_date
						  ,pol_atd_date
						  ,ts1_port
						  ,ts1_eta_date
						  ,ts1_ata_date
						  ,ts1_etd_date
						  ,ts1_atd_date
						  ,ts2_port
						  ,ts2_eta_date
						  ,ts2_ata_date
						  ,ts2_etd_date
						  ,ts2_atd_date
						  ,ts3_port
						  ,ts3_eta_date
						  ,ts3_ata_date
						  ,ts3_etd_date
						  ,ts3_atd_date
						  ,pod
						  ,pod_eta_date
						  ,pod_ata_date
						  ,pod_etd_date
						  ,pod_atd_date
						  ,f_dest_port_code
						  ,f_dest_eta_date
						  ,f_dest_ata_date
						  ,attribute2  -- 20210929 C20210928-000189  내륙운송 ATD
						  ,attribute3  -- 20210929 C20210928-000189  내륙운송 ATA
						  ,valid_yn
					      ,created_by
						  ,creation_date
						  ,last_updated_by
						  ,last_update_date
						  ,ZFCY2ATA
						  ,ZFCY2ATD
						  
                          -- PJ20216994
                          ,ZFCY1
                          ,ZFCY1ETA
                          ,ZFCY1ATA
                          ,ZFCY1ETD
                          ,ZFCY1ATD
                          ,ZFCY2
                          ,ZFCY2ETA
                          ,ZFCY2ETD
                          ,ZFCY3
                          ,ZFCY3ETA
                          ,ZFCY3ATA
                          ,ZFCY3ETD
                          ,ZFCY3ATD
                          ,ZLANDETD
                          ,ZLANDETA
                          ,ZLANDATD
                          ,ZLANDATA
						)
				 VALUES (   
							B.company_id  -- 20181204 company_id 추가
						   ,B.shipment_no
						   ,B.container_no
						   ,B.route
						   ,B.incoterms
						   ,B.carrier
					 	   ,B.pol_port
						   ,B.shipping_date
					 	   ,B.pol_atd_date
						   ,B.ts1_port
						   ,B.ts1_eta_date
						   ,B.ts1_ata_date
						   ,B.ts1_etd_date
						   ,B.ts1_atd_date
						   ,B.ts2_port
						   ,B.ts2_eta_date
						   ,B.ts2_ata_date
						   ,B.ts2_etd_date
						   ,B.ts2_atd_date
						   ,B.ts3_port
						   ,B.ts3_eta_date
						   ,B.ts3_ata_date
						   ,B.ts3_etd_date
						   ,B.ts3_atd_date
						   ,B.pod_port
						   ,B.pod_eta_date
						   ,B.pod_ata_date
						   ,B.pod_etd_date
						   ,B.pod_atd_date
						   ,B.f_dest_port
						   ,B.f_dest_eta_date
						   ,B.f_dest_ata_date
						   ,B.attribute2  -- 20210929 C20210928-000189  내륙운송 ATD
						   ,B.attribute3  -- 20210929 C20210928-000189  내륙운송 ATA
						   ,'Y'
						   ,@v_batch_user
						   ,GETDATE()
						   ,@v_batch_user
						   ,GETDATE() 
						   ,B.ZFCY2ATA
						   ,B.ZFCY2ATD
						   
                           -- PJ20216994
                           ,B.ZFCY1
                           ,B.ZFCY1ETA
                           ,B.ZFCY1ATA
                           ,B.ZFCY1ETD
                           ,B.ZFCY1ATD
                           ,B.ZFCY2
                           ,B.ZFCY2ETA
                           ,B.ZFCY2ETD
                           ,B.ZFCY3
                           ,B.ZFCY3ETA
                           ,B.ZFCY3ATA
                           ,B.ZFCY3ETD
                           ,B.ZFCY3ATD
                           ,B.ZLANDETD
                           ,B.ZLANDETA
                           ,B.ZLANDATD
                           ,B.ZLANDATA
						)
			;

			 -----------------------------------------------------------
              -- Merge LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'MERGE INTO scm_dnm_delivery_tracking';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------

			FETCH NEXT FROM CUR_TRACKING INTO  @v_ifseqno
			END
		
		CLOSE CUR_TRACKING;
		DEALLOCATE CUR_TRACKING; 
		
		
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		 SET @n_history_seq = NEXT VALUE FOR seq1_scm_dnm_delivery_tracking_h
		 INSERT INTO [dbo].[scm_dnm_delivery_tracking_h] WITH (TABLOCK) (
						   history_seq
	                      -- 20181204 company_id 추가
						  ,company_id
						  ,shipment_no
						  ,container_no
						  ,route
						  ,incoterms
						  ,carrier
						  ,pol
						  ,shipping_date
						  ,pol_atd_date
						  ,ts1_port
						  ,ts1_eta_date
						  ,ts1_ata_date
						  ,ts1_etd_date
						  ,ts1_atd_date
						  ,ts2_port
						  ,ts2_eta_date
						  ,ts2_ata_date
						  ,ts2_etd_date
						  ,ts2_atd_date
						  ,ts3_port
						  ,ts3_eta_date
						  ,ts3_ata_date
						  ,ts3_etd_date
						  ,ts3_atd_date
						  ,pod
						  ,pod_eta_date
						  ,pod_ata_date
						  ,pod_etd_date
						  ,pod_atd_date
						  ,f_dest_port_code
						  ,f_dest_eta_date
						  ,f_dest_ata_date
						  ,attribute2  -- 20210929 C20210928-000189  내륙운송 ATD
						  ,attribute3  -- 20210929 C20210928-000189  내륙운송 ATA
						  ,valid_yn	
						  ,ZFCY2ATA
						  ,ZFCY2ATD
						  
                          -- PJ20216994
                          ,ZFCY1
                          ,ZFCY1ETA
                          ,ZFCY1ATA
                          ,ZFCY1ETD
                          ,ZFCY1ATD
                          ,ZFCY2
                          ,ZFCY2ETA
                          ,ZFCY2ETD
                          ,ZFCY3
                          ,ZFCY3ETA
                          ,ZFCY3ATA
                          ,ZFCY3ETD
                          ,ZFCY3ATD
                          ,ZLANDETD
                          ,ZLANDETA
                          ,ZLANDATD
                          ,ZLANDATA
						  
						  ,creation_date
						  ,last_update_date
						  ,created_by					
						  ,last_updated_by	
						  ,history_creation_date
					  )
				 SELECT @n_history_seq
			       ,A.*
				   ,@v_batch_user
				   ,@v_batch_user
				   ,GETDATE()
	        FROM (
					SELECT A.*,B.creation_date,B.last_update_date 
					FROM (SELECT /* scm_dnm_delivery_tracking_h */
	                      -- 20181204 company_id 추가
						   company_id
						  ,shipment_no
						  ,container_no
						  ,route
						  ,incoterms
						  ,carrier
						  ,pol
						  ,shipping_date
						  ,pol_atd_date
						  ,ts1_port
						  ,ts1_eta_date
						  ,ts1_ata_date
						  ,ts1_etd_date
						  ,ts1_atd_date
						  ,ts2_port
						  ,ts2_eta_date
						  ,ts2_ata_date
						  ,ts2_etd_date
						  ,ts2_atd_date
						  ,ts3_port
						  ,ts3_eta_date
						  ,ts3_ata_date
						  ,ts3_etd_date
						  ,ts3_atd_date
						  ,pod
						  ,pod_eta_date
						  ,pod_ata_date
						  ,pod_etd_date
						  ,pod_atd_date
						  ,f_dest_port_code
						  ,f_dest_eta_date
						  ,f_dest_ata_date
						  ,attribute2  -- 20210929 C20210928-000189  내륙운송 ATD
						  ,attribute3  -- 20210929 C20210928-000189  내륙운송 ATA
						  ,valid_yn
						  ,ZFCY2ATA
						  ,ZFCY2ATD
						  
                          -- PJ20216994
                          ,ZFCY1
                          ,ZFCY1ETA
                          ,ZFCY1ATA
                          ,ZFCY1ETD
                          ,ZFCY1ATD
                          ,ZFCY2
                          ,ZFCY2ETA
                          ,ZFCY2ETD
                          ,ZFCY3
                          ,ZFCY3ETA
                          ,ZFCY3ATA
                          ,ZFCY3ETD
                          ,ZFCY3ATD
                          ,ZLANDETD
                          ,ZLANDETA
                          ,ZLANDATD
                          ,ZLANDATA
					FROM [dbo].[scm_dnm_delivery_tracking_temp$] WITH(NOLOCK)
					EXCEPT
					SELECT /* scm_dnm_delivery_tracking_h */
	                      -- 20181204 company_id 추가
						   company_id
						  ,shipment_no
						  ,container_no
						  ,route
						  ,incoterms
						  ,carrier
						  ,pol
						  ,shipping_date
						  ,pol_atd_date
						  ,ts1_port
						  ,ts1_eta_date
						  ,ts1_ata_date
						  ,ts1_etd_date
						  ,ts1_atd_date
						  ,ts2_port
						  ,ts2_eta_date
						  ,ts2_ata_date
						  ,ts2_etd_date
						  ,ts2_atd_date
						  ,ts3_port
						  ,ts3_eta_date
						  ,ts3_ata_date
						  ,ts3_etd_date
						  ,ts3_atd_date
						  ,pod
						  ,pod_eta_date
						  ,pod_ata_date
						  ,pod_etd_date
						  ,pod_atd_date
						  ,f_dest_port_code
						  ,f_dest_eta_date
						  ,f_dest_ata_date
						  ,attribute2  -- 20210929 C20210928-000189  내륙운송 ATD
						  ,attribute3  -- 20210929 C20210928-000189  내륙운송 ATA
						  ,valid_yn
						  ,ZFCY2ATA
						  ,ZFCY2ATD
						  
                          -- PJ20216994
                          ,ZFCY1
                          ,ZFCY1ETA
                          ,ZFCY1ATA
                          ,ZFCY1ETD
                          ,ZFCY1ATD
                          ,ZFCY2
                          ,ZFCY2ETA
                          ,ZFCY2ETD
                          ,ZFCY3
                          ,ZFCY3ETA
                          ,ZFCY3ATA
                          ,ZFCY3ETD
                          ,ZFCY3ATD
                          ,ZLANDETD
                          ,ZLANDETA
                          ,ZLANDATD
                          ,ZLANDATA
				    FROM [dbo].[scm_dnm_delivery_tracking] WITH(NOLOCK)
					-- 20181204 company_id 추가
					WHERE company_id+shipment_no+container_no in
					         (SELECT dbo.FN_SCM_SYS_NVL(attribute1, @v_ESOC)+shipment_no+container_no FROM xif_erp_delivery_tracking_r_sn WITH(NOLOCK) WHERE transfer_flag = 'P')) A 
					--WHERE shipment_no+container_no in(SELECT shipment_no+container_no FROM xif_erp_delivery_tracking_r_sn WITH(NOLOCK) WHERE transfer_flag = 'P')) A 
					INNER JOIN [dbo].[scm_dnm_delivery_tracking_temp$] B WITH(NOLOCK)
					ON	A.company_id			=	  B.company_id  -- 20181204 company_id 추가
					AND A.shipment_no			=	  B.shipment_no
				    AND A.container_no			=	  B.container_no ) A
		
		-- 처리 한 row 마킹
		UPDATE [dbo].[XIF_ERP_DELIVERY_TRACKING_R_SN]
		SET    transfer_flag = 'Y' 
		WHERE  transfer_flag = 'P'
		
		DROP TABLE dbo.scm_dnm_delivery_tracking_temp$;
		
        -- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_dnm_delivery_tracking_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 순차적 호출을 위함
		EXEC PR_SCM_DNM_INTRANSIT_CUTOFF
		
        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END
    --COMMIT TRANSACTION
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
