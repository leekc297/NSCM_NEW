
/*
 * Program ID   : PR_DM_DNM_SALES_RESULT
 * Description  : 매출 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.08   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.10   Kim Jaejung    Plant_site_id '-' 인 데이터 공백으로 업데이트 20180410 DM 요청
 * 2018.04.18   Kim Jaejung    project_code가 'N' 인 데이터 추가적으로 mapping 후 업데이트 DM 요청 , 변경 전 project_code attribute1 컬럼에 저장
 * 2018.04.26-1 Kim Jaejung    Item 이 Pack원부자재일 경우 Plant_site_id mapping 로직 추가
 * 2018.04.26-2 Kim Jaejung    사내 매출 거래 로직 반영
 * 2018.05.03   Kim Jaejung    soldto_code, shipto_code length 가 둘다 4자리인 건들은 제외(법인간 거래)
 * 2018.05.14   Kim Jihye      soldto-shipto : sales_site_id 1:다 케이스 발생 대응 로직 수정 
 * 2018.05.15   Kim Jaejung    Fcst_type mapping 로직 변경
 * 2018.05.18   Kim jaejung    transfer_flag update 로직 위치 변경
 * 2018.06.01   Kim jaejung    history 데이터 join 조건 qty 추가
 * 2018.06.01   Kim Jihye      주석 정리
 * 2018.06.26   Kim Jihye      fcst_type mapping 로직 수정
 * 2018.07.02   Kim jaejung    Mat_group_desc 컬럼 추가 , 소형 대표 ITEM_ID 로 실적 생성 로직 추가 (소형)
 * 2018.07.04   Kim jaejung    Group by 로직 수정(qty 제거)
 * 2018.07.12   Kim Jihye      비물동 매출(item_id = 'ETC') Delete 제외
 * 2018.07.23   Kim jaejung    I/F , 본 테이블 JOIN 시 기존 ITEM_ID -> ORIGIN_ITEM_ID 로 조건 변경
 * 2018.07.26   Kim Jihye      소수점 잘리는 버그 수정 (Decimal -> Decimal(30,10))
 * 2018.07.26   Kim Jihye      SALES_RESULT currency 로직 수정 ( '-' -> currency)
 * 2018.07.31   Kim Jihye      scm_dnm_sales_result 로직 추가
 * 2018.08.31-1 Kim Jihye      SALES_RESULT_AMOUNT_KRW Currency Local 통화로 변경
 * 2018.08.31-2 Kim Jihye      Soldto Code 가 법인인 경우 scm_site_id 법인코드로 Mapping
 * 2018.08.31-3 Kim Jihye      소형의 경우 자재그룹을 참조로 한 End Customer 정보로 Project Code 설정
 * 2018.08.31-4 Kim Jihye      소형의 경우 soldto, shipto 기준으로만 sales_site_id Mapping
 * 2018.09.11   ytchoi         소형요청 로직 반영 1. 유상사급 수출공통 제외  2. 제품국내매출:사내 인 경우에는 오창 전력저장 전지 는 포함하고, 전지사업본부 공통 은 수량은 0 으로 하고 금액만 ETC로 포함. 3. G450을 SCM_SITE_ID를 N 으로 해서 연결 매출로 조회될 수 있도록 함..

 */

CREATE PROCEDURE [dbo].[PR_DM_DNM_SALES_RESULT]
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- LOG 용 변수 설정
  DECLARE @v_batch_user    NVARCHAR(150) = 'scm_batch';
  DECLARE @v_program_name  NVARCHAR(150) = 'PR_DM_DNM_SALES_RESULT';
  DECLARE @v_log_type      NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count     INTEGER = 0;
  DECLARE @v_log_message   NVARCHAR(1000);
  DECLARE @v_description   NVARCHAR(500);
  DECLARE @d_event_date    DATETIME;
  DECLARE @v_ifseqno       NVARCHAR(30);
  DECLARE @v_yyyymmdd_from NVARCHAR(8); -- 2018.08.31
  DECLARE @v_yyyymmdd_to   NVARCHAR(8); -- 2018.08.31
  DECLARE @n_history_seq   BIGINT;

  -- 시작 LOG
  SET @v_log_type    = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  BEGIN TRY
    BEGIN
      -- 인터페이스 테이블 처리 ROW UPDATE
      UPDATE xif_erp_sales_result_r_sn 
      SET    transfer_flag             = 'P'
      WHERE  ISNULL(transfer_flag,'N') = 'N';
    
      -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
      DECLARE CUR_SALES CURSOR FOR
        SELECT ifseqno, CONCAT(MIN(result_yyyymm), '01') result_yyyymm_from, CONCAT(MAX(result_yyyymm), '31') result_yyyymm_to -- 2018.08.31 
        FROM   xif_erp_sales_result_r_sn WITH(NOLOCK)
        WHERE  transfer_flag = 'P'
        GROUP BY ifseqno
        ORDER BY ifseqno ASC;

    
      -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
      IF OBJECT_ID('dbo.dm_dnm_sales_result_temp$') IS NOT NULL 
        DROP TABLE dm_dnm_sales_result_temp$;
    
      -- 데이터가 누적 되기 때문에, history 비교 시 변경 대상이 되는 row 로만 temp table 생성(변경 전 데이터 포함)
      SELECT * 
      INTO   dbo.dm_dnm_sales_result_temp$
      FROM   dbo.dm_dnm_sales_result WITH(NOLOCK)
      WHERE  yyyymmdd BETWEEN (SELECT MIN(result_yyyymm)+'01' FROM   xif_erp_sales_result_r_sn WITH(NOLOCK) WHERE  transfer_flag = 'P') 
                      AND     (SELECT MAX(result_yyyymm)+'31' FROM   xif_erp_sales_result_r_sn WITH(NOLOCK) WHERE  transfer_flag = 'P');
	  
	  -- 2018.08.31-3, 소형의 경우 자재그룹을 참조로 한 End Customer 정보로 Project Code 설정
	  UPDATE xif_erp_sales_result_r_sn
      SET    project_code     = md.attribute1
      FROM   xif_erp_sales_result_r_sn sr WITH(NOLOCK)
      JOIN   scm_adm_lookup_master_detail md WITH(NOLOCK)
      ON     sr.mat_group     = md.segment3
      AND    sr.company_id    = md.segment2
      AND    sr.division_id   = md.segment1
      WHERE  sr.transfer_flag = 'P'
      AND    sr.division_id   = '40'
      AND    md.lookup_type   = 'MTRL_GRP3_MAPPING'
      AND    md.valid_yn      = 'Y';

      /*  2018.08.31-3
	  -- Project Code 가 없는 경우 N으로 UPDATE
      UPDATE xif_erp_sales_result_r_sn 
      SET    project_code = 'N'
      WHERE  transfer_flag = 'P'
      AND    ISNULL(project_code,'') = '';*/

      OPEN CUR_SALES;
      FETCH NEXT FROM CUR_SALES INTO @v_ifseqno, @v_yyyymmdd_from, @v_yyyymmdd_to; -- 2018.08.31
     
      WHILE (@@FETCH_STATUS = 0)
        BEGIN
        -- 실적이 지난달 1일부터 어제 날짜까지 데이터가 인터페이스 되므로, 해당 데이터는 삭제후 다시 처리   
          DELETE 
          FROM   dm_dnm_sales_result
		  WHERE  yyyymmdd BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to; -- 2018.08.31
          /*WHERE  yyyymmdd BETWEEN (SELECT MIN(result_yyyymm)+'00' FROM   [xif_erp_sales_result_r_sn] WITH(NOLOCK) WHERE  transfer_flag = 'P' AND  ifseqno = @v_ifseqno) 
                          AND     (SELECT MAX(result_yyyymm)+'31' FROM   [xif_erp_sales_result_r_sn] WITH(NOLOCK) WHERE  transfer_flag = 'P' AND  ifseqno = @v_ifseqno);*/
          
		  -- 2018.07.31 scm_dnm_sales_result 로직 추가
		  DELETE 
          FROM   scm_dnm_sales_result
		  WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to; -- 2018.08.31
          /*WHERE  sales_posting_date BETWEEN (SELECT MIN(result_yyyymm)+'00' FROM   [xif_erp_sales_result_r_sn] WITH(NOLOCK) WHERE  transfer_flag = 'P' AND  ifseqno = @v_ifseqno) 
                                    AND     (SELECT MAX(result_yyyymm)+'31' FROM   [xif_erp_sales_result_r_sn] WITH(NOLOCK) WHERE  transfer_flag = 'P' AND  ifseqno = @v_ifseqno);*/
		   
          INSERT INTO dm_dnm_sales_result(  
                  division_id
                 ,project_code
                 ,sales_site_id
                 ,plant_site_id
                 --,site_item_mapping_yn
                 ,item_id --2018.07.02
				 ,origin_item_id --2018.07.02
				 ,mat_group_desc --2018.07.02
                 ,dom_exp
                 ,fcst_type
                 ,incoterms
                 ,measure
                 ,currency
                 ,yyyymmdd
                 ,qty
                 ,soldto_code
                 ,shipto_code
                 ,valid_yn
                 ,created_by
                 ,creation_date
                 ,last_updated_by
                 ,last_update_date
                 ,attribute1)  --2018.04.18
          SELECT  A.division_id
                 ,A.project_code
                 ,'X'
                 ,A.plant_site_id
                 --,'N' AS site_item_mapping_yn
                 ,A.item_id --2018.07.02
				 ,A.origin_item_id --2018.07.02
				 ,MAX(A.mat_group_desc) mat_group_desc --2018.07.02
                 ,A.distribution_channel
                 ,sales_type_2
                 ,A.incoterms 
                 ,A.measure
                 ,currency
                 ,A.sales_posting_date
                 ,SUM(ISNULL(qty,0)) qty
                 ,A.customer_code soldto_code
                 ,A.shipto_code
                 ,'Y'
                 ,@v_batch_user
                 ,GETDATE()
                 ,@v_batch_user
                 ,GETDATE()
                 ,attribute1       --2018.04.18    
          FROM (SELECT  /* PR_DM_DNM_SALES_RESULT */ 
                        A.division_id 
						-- 2018.09.11
                       --,CASE A.division_id WHEN '81' THEN dbo.FN_SCM_SYS_NVL(
                       --                                   dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id, A.item_id))
                       --                                  ,A.plant_id)
                       --                    ELSE ''  
                       --                    END  plant_site_id
                       ,MAX(CASE A.division_id WHEN '81' THEN dbo.FN_SCM_SYS_NVL(
                                                          dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id, A.item_id))
                                                         ,A.plant_id)
                                           ELSE ''  
                                           END)  plant_site_id

                       ,A.sales_posting_date
                       ,dbo.FN_SCM_SYS_NVL(A.project_code, '-') project_code
                       ,A.customer_code
                       ,A.shipto_code
                       ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', A.distribution_channel), 'E') distribution_channel
                       ,dbo.FN_GET_FCST_TYPE(a.sales_type_2) sales_type_2
                       ,'SALES_RESULT_AMOUNT_KRW' AS measure
                       ,dbo.FN_SCM_SYS_NVL(A.currency,'N') AS currency -- 2018.08.31-1, SALES_RESULT_AMOUNT_KRW Currency Local 통화로 변경
                       ,SUM(CONVERT(Decimal(30,10), dbo.FN_SCM_SYS_NVL(A.sales_amount_sum, 0))) AS qty -- 2018.07.26

					   -- 2018.09.11 소형 제품국내매출:사내 인 경우에는 오창 전력저장 전지 는 포함하고, 전지사업본부 공통 은 수량은 0 으로 하고 금액만 ETC에 포함시킴
                       -- ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id), 'ETC') item_id --2018.07.02
					   ,CASE WHEN division_id = '40' AND COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 'ETC'
					         ELSE dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id), 'ETC') END item_id 

					   ,dbo.FN_SCM_SYS_NVL(A.item_id, 'ETC') origin_item_id --2018.07.02
                       ,A.incoterms
                       ,A.project_code attribute1 --2018.04.18
					   ,MAX(mat_group_desc) mat_group_desc --2018.07.02
                FROM  xif_erp_sales_result_r_sn A WITH(NOLOCK) 
                WHERE ifseqno       = @v_ifseqno
                AND   customer_code > char(0)  
                AND   transfer_flag = 'P'
                --AND   item_id > char(0)          
                --AND   project_code > char(0)
				AND   CASE WHEN division_id = '40' AND SALES_GROUP = 'A10' THEN 'N' ELSE 'Y' END = 'Y'  -- 2018.09.11 소형 유상사급 수출공통 제외
                GROUP BY A.division_id
                        ,A.plant_id
                        ,A.sales_posting_date
                        ,A.customer_code
                        ,A.shipto_code
                        ,A.project_code
                        ,A.distribution_channel
                        ,A.sales_type_2
                        ,A.currency
						-- 2018.09.11 소형 제품국내매출:사내 인 경우에는 오창 전력저장 전지 는 포함하고, 전지사업본부 공통 은 수량은 0 으로 하고 금액만 ETC에 포함시킴
                        --,A.item_id
						,CASE WHEN division_id = '40' AND COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 'ETC'
					         ELSE dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id), 'ETC') END

                        ,incoterms
						-- 2018.09.11
						,dbo.FN_SCM_SYS_NVL(A.item_id, 'ETC')
                UNION ALL
                SELECT  /* PR_DM_DNM_SALES_RESULT */ 
                        A.division_id
						-- 2018.09.11 
                       --,CASE A.division_id WHEN '81' THEN dbo.FN_SCM_SYS_NVL(
                       --                                   dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id, A.item_id))
                       --                                  ,A.plant_id)
                       --                    ELSE '' 
                       --                    END  plant_site_id
                       ,MAX(CASE A.division_id WHEN '81' THEN dbo.FN_SCM_SYS_NVL(
                                                          dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id, A.item_id))
                                                         ,A.plant_id)
                                           ELSE '' 
                                           END ) plant_site_id

                       ,A.sales_posting_date
                       ,dbo.FN_SCM_SYS_NVL(A.project_code, '-') project_code
                       ,A.customer_code
                       ,A.shipto_code
                       ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', A.distribution_channel), 'E') distribution_channel
                       ,dbo.FN_GET_FCST_TYPE(a.sales_type_2) sales_type_2
                       ,'SALES_RESULT_AMOUNT' AS measure
                       ,dbo.FN_SCM_SYS_NVL(A.currency,'N') currency
                       ,SUM(CONVERT(Decimal(30,10), dbo.FN_SCM_SYS_NVL(A.sales_amount_for, 0))) AS qty -- 2018.07.26

					   -- 2018.09.11 소형 제품국내매출:사내 인 경우에는 오창 전력저장 전지 는 포함하고, 전지사업본부 공통 은 수량은 0 으로 하고 금액만 ETC에 포함시킴
                       -- ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id), 'ETC') item_id --2018.07.02
					   ,CASE WHEN division_id = '40' AND COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 'ETC'
					         ELSE dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id), 'ETC') END item_id 
                       
					   ,dbo.FN_SCM_SYS_NVL(A.item_id, 'ETC') origin_item_id --2018.07.02
                       ,A.incoterms
                       ,A.project_code attribute1  --2018.04.18					   
					   ,MAX(mat_group_desc) mat_group_desc --2018.07.02
                FROM   xif_erp_sales_result_r_sn A WITH(NOLOCK) 
                WHERE  ifseqno       = @v_ifseqno
                AND    transfer_flag = 'P'
                AND    customer_code > char(0)
                --AND   item_id > char(0)
                --AND   project_code > char(0)
				AND    CASE WHEN division_id = '40' AND SALES_GROUP = 'A10' THEN 'N' ELSE 'Y' END = 'Y'  -- 2018.09.11 소형 유상사급 수출공통 제외
                GROUP BY A.division_id
                        ,A.plant_id
                        ,A.sales_posting_date
                        ,A.customer_code
                        ,A.shipto_code
                        ,A.project_code
                        ,A.distribution_channel
                        ,A.sales_type_2
                        ,A.currency
						-- 2018.09.11 소형 제품국내매출:사내 인 경우에는 오창 전력저장 전지 는 포함하고, 전지사업본부 공통 은 수량은 0 으로 하고 금액만 ETC에 포함시킴
                        -- ,A.item_id
						,CASE WHEN division_id = '40' AND COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 'ETC'
					         ELSE dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id), 'ETC') END

                        ,incoterms
						-- 2018.09.11
						,dbo.FN_SCM_SYS_NVL(A.item_id, 'ETC')
                UNION ALL
                SELECT  /* PR_DM_DNM_SALES_RESULT */ 
                        A.division_id
						-- 2018.09.11 
                       --,CASE A.division_id WHEN '81' THEN dbo.FN_SCM_SYS_NVL(
                       --                                   dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id, A.item_id))
                       --                                  ,A.plant_id)
                       --                    ELSE '' 
                       --                    END  plant_site_id
                       ,MAX(CASE A.division_id WHEN '81' THEN dbo.FN_SCM_SYS_NVL(
                                                          dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id, A.item_id))
                                                         ,A.plant_id)
                                           ELSE '' 
                                           END ) plant_site_id
                       ,A.sales_posting_date
                       ,dbo.FN_SCM_SYS_NVL(A.project_code, '-') project_code
                       ,A.customer_code
                       ,A.shipto_code
                       ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', A.distribution_channel), 'E') distribution_channel
                       ,dbo.FN_GET_FCST_TYPE(a.sales_type_2) sales_type_2
                       ,'SALES_RESULT' AS measure
                       ,dbo.FN_SCM_SYS_NVL(A.currency,'N') AS currency -- 2018.07.26

					   -- 2018.09.11 소형 제품국내매출:사내 인 경우에는 오창 전력저장 전지 는 포함하고, 전지사업본부 공통 은 수량은 0 으로 하고 금액만 ETC에 포함시킴
                       -- ,SUM(CONVERT(Decimal(30,10), [dbo].[FN_SCM_SYS_NVL](A.sales_qty, 0))) END AS qty -- 2018.07.26
					   -- ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id), 'ETC') item_id 
					   ,SUM(CASE WHEN division_id = '40' AND COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 0
					         ELSE CONVERT(Decimal(30,10), [dbo].[FN_SCM_SYS_NVL](A.sales_qty, 0)) END ) AS qty -- 2018.07.26
					   ,CASE WHEN division_id = '40' AND COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 'ETC'
					         ELSE dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id), 'ETC') END item_id 

					   ,dbo.FN_SCM_SYS_NVL(A.item_id, 'ETC') origin_item_id --2018.07.02
                       ,A.incoterms
                       ,A.project_code attribute1  --2018.04.18
					   ,MAX(mat_group_desc) mat_group_desc --2018.07.02					   
                FROM   dbo.xif_erp_sales_result_r_sn A WITH(NOLOCK)
                WHERE  ifseqno       = @v_ifseqno
                AND    transfer_flag = 'P'
                AND    customer_code > char(0)
                --AND   item_id > char(0)
                --AND   project_code > char(0)          
				AND    CASE WHEN division_id = '40' AND SALES_GROUP = 'A10' THEN 'N' ELSE 'Y' END = 'Y'  -- 2018.09.11 소형 유상사급 수출공통 제외
                GROUP BY A.division_id
                        ,A.plant_id
                        ,A.sales_posting_date
                        ,A.customer_code
                        ,A.shipto_code
                        ,A.project_code
                        ,A.distribution_channel
                        ,A.sales_type_2
                        ,A.currency
						-- 2018.09.11 소형 제품국내매출:사내 인 경우에는 오창 전력저장 전지 는 포함하고, 전지사업본부 공통 은 수량은 0 으로 하고 금액만 ETC에 포함시킴
                        --,A.item_id
						,CASE WHEN division_id = '40' AND COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 'ETC'
					         ELSE dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id), 'ETC') END

                        ,A.incoterms	
						-- 2018.09.11
						,dbo.FN_SCM_SYS_NVL(A.item_id, 'ETC')
						) A
          GROUP BY A.division_id
                  ,A.plant_site_id
                  ,A.sales_posting_date
                  ,A.customer_code
                  ,A.shipto_code
                  ,A.project_code
                  ,A.distribution_channel
                  ,A.sales_type_2
                  ,A.currency
                  ,A.item_id
                  ,A.incoterms
                  ,A.measure
                  ,A.attribute1    --2018.04.18
				  ,A.origin_item_id --2018.07.02
          ;
  
  
          -- 2018.04.26-2 사내 매출 거래 로직 반영 시작
          INSERT INTO dm_dnm_sales_result(  
                  division_id
                 ,project_code
                 ,sales_site_id
                 ,plant_site_id
                 --,site_item_mapping_yn
                 ,item_id --2018.07.02
				 ,origin_item_id --2018.07.02
				 ,mat_group_desc --2018.07.02
                 ,dom_exp
                 ,fcst_type
                 ,incoterms
                 ,measure
                 ,currency
                 ,yyyymmdd
                 ,qty
                 ,soldto_code
                 ,shipto_code
                 ,valid_yn
                 ,created_by
                 ,creation_date
                ,last_updated_by
                ,last_update_date
                ,attribute1) 
          SELECT  A.division_id
                 ,si.project_code
                 ,si.scm_site_id
                 ,A.plant_site_id
                 ,A.item_id --2018.07.02 
				 ,A.origin_item_id --2018.07.02
				 ,A.mat_group_desc mat_group_desc --2018.07.02
                 ,A.distribution_channel
                 ,A.sales_type_2
                 ,A.incoterms
                 ,A.measure
                 ,A.currency
                 ,A.sales_posting_date
                 ,A.qty
                 ,A.customer_code
                 ,A.shipto_code
                 ,'Y'
                 ,@v_batch_user
                 ,GETDATE()
                 ,@v_batch_user
                 ,GETDATE()   
                 ,A.project_code
          FROM  (SELECT  rs.company_id
                        ,rs.division_id 
                        ,CASE rs.division_id WHEN '81' THEN dbo.FN_SCM_SYS_NVL(
                                                            dbo.FN_GET_SCM_SITE_ID_PLANT(rs.plant_id,dbo.FN_GET_ITEM_OPERATION_GROUP(rs.division_id, rs.item_id))
                                                           ,rs.plant_id)
                                             ELSE ''  
                                             END  plant_site_id
                        ,rs.sales_posting_date
                        -- ,si.project_code
                        -- ,si.scm_site_id
                        ,rs.customer_code
                        ,rs.shipto_code
                        ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', rs.distribution_channel), 'E') distribution_channel
                        ,dbo.FN_GET_FCST_TYPE(rs.sales_type_2) sales_type_2
                        ,'SALES_RESULT_AMOUNT_KRW' AS measure
                        ,dbo.FN_SCM_SYS_NVL(rs.currency,'N') AS currency -- 2018.08.31-1, SALES_RESULT_AMOUNT_KRW Currency Local 통화로 변경
                        ,SUM(CONVERT(Decimal(30,10), dbo.FN_SCM_SYS_NVL(rs.sales_amount_sum, 0))) AS qty -- 2018.07.26
                        ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(rs.division_id, rs.item_id), 'ETC') item_id --2018.07.02
					    ,dbo.FN_SCM_SYS_NVL(rs.item_id, 'ETC') origin_item_id --2018.07.02
                        ,rs.incoterms
                        ,rs.project_code
						,MAX(mat_group_desc) mat_group_desc --2018.07.02
                 FROM   xif_erp_sales_result_r_sn rs WITH(NOLOCK)
                 WHERE  rs.ifseqno                  = @v_ifseqno
                 AND    rs.transfer_flag            = 'P'
                 AND    rs.profit_center_id         = 'A40012'
                 AND    rs.partner_profit_center_id = 'A50101'
                 GROUP BY rs.company_id, rs.division_id
                         ,rs.plant_id
                         ,rs.sales_posting_date
                         ,rs.customer_code
                         ,rs.shipto_code
                         ,rs.project_code
                         ,rs.distribution_channel
                         ,rs.sales_type_2
                         ,rs.currency
                         ,rs.item_id
                         ,rs.incoterms
                 UNION ALL
                 SELECT  rs.company_id
                        ,rs.division_id 
                        ,CASE rs.division_id WHEN '81' THEN dbo.FN_SCM_SYS_NVL(
                                                            dbo.FN_GET_SCM_SITE_ID_PLANT(rs.plant_id,dbo.FN_GET_ITEM_OPERATION_GROUP(rs.division_id,rs.item_id))
                                                           ,rs.plant_id)
                                             ELSE ''  
                                             END  plant_site_id
                        ,rs.sales_posting_date
                        -- ,si.project_code
                        -- ,si.scm_site_id
                        ,rs.customer_code
                        ,rs.shipto_code
                        ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', rs.distribution_channel), 'E') distribution_channel
                        ,dbo.FN_GET_FCST_TYPE(rs.sales_type_2) sales_type_2
                        ,'SALES_RESULT_AMOUNT' AS measure
                        ,dbo.FN_SCM_SYS_NVL(rs.currency,'N') currency
                        ,SUM(CONVERT(Decimal(30,10), dbo.FN_SCM_SYS_NVL(rs.sales_amount_for, 0))) AS qty -- 2018.07.26
                        ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(rs.division_id, rs.item_id), 'ETC') item_id --2018.07.02
					    ,dbo.FN_SCM_SYS_NVL(rs.item_id, 'ETC') origin_item_id --2018.07.02
                        ,rs.incoterms
                        ,rs.project_code
						,MAX(mat_group_desc) mat_group_desc --2018.07.02
                 FROM   xif_erp_sales_result_r_sn rs WITH(NOLOCK)
                 WHERE  rs.ifseqno                  = @v_ifseqno
                 AND    rs.transfer_flag            = 'P'
                 AND    rs.profit_center_id         = 'A40012'
                 AND    rs.partner_profit_center_id = 'A50101'
                 GROUP BY rs.company_id, rs.division_id
                         ,rs.plant_id
                         ,rs.sales_posting_date
                         ,rs.customer_code
                         ,rs.shipto_code
                         ,rs.project_code
                         ,rs.distribution_channel
                         ,rs.sales_type_2
                         ,rs.currency
                         ,rs.item_id
                         ,rs.incoterms
                 UNION ALL
                 SELECT  rs.company_id
                        ,rs.division_id 
                        ,CASE rs.division_id WHEN '81' THEN dbo.FN_SCM_SYS_NVL(
                                                            dbo.FN_GET_SCM_SITE_ID_PLANT(rs.plant_id, dbo.FN_GET_ITEM_OPERATION_GROUP(rs.division_id, rs.item_id))
                                                           ,rs.plant_id)
                                             ELSE ''  
                                             END  plant_site_id
                        ,rs.sales_posting_date
                        -- ,si.project_code
                        -- ,si.scm_site_id
                        ,rs.customer_code
                        ,rs.shipto_code
                        ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', rs.distribution_channel), 'E') distribution_channel
                        ,dbo.FN_GET_FCST_TYPE(rs.sales_type_2) sales_type_2
                        ,'SALES_RESULT' AS measure
                        ,dbo.FN_SCM_SYS_NVL(rs.currency,'N') AS currency --2018.07.26
                        ,SUM(CONVERT(Decimal(30,10), dbo.FN_SCM_SYS_NVL(rs.sales_qty, 0))) AS qty -- 2018.07.26
                        ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_PACKER_PLAN_ITEM_ID(rs.division_id, rs.item_id), 'ETC') item_id --2018.07.02
					    ,dbo.FN_SCM_SYS_NVL(rs.item_id, 'ETC') origin_item_id --2018.07.02
                        ,rs.incoterms
                        ,rs.project_code
						,MAX(mat_group_desc) mat_group_desc --2018.07.02
                 FROM   xif_erp_sales_result_r_sn rs WITH(NOLOCK)
                 WHERE  rs.ifseqno                  = @v_ifseqno
                 AND    rs.transfer_flag            = 'P'
                 AND    rs.profit_center_id         = 'A40012'
                 AND    rs.partner_profit_center_id = 'A50101'
                 GROUP BY rs.company_id, rs.division_id
                         ,rs.plant_id
                         ,rs.sales_posting_date
                         ,rs.customer_code
                         ,rs.shipto_code
                         ,rs.project_code
                         ,rs.distribution_channel
                         ,rs.sales_type_2
                         ,rs.currency
                         ,rs.item_id
                         ,rs.incoterms
                 ) A
          JOIN  (SELECT  si.division_id
                        ,md.segment2 company_id
                        ,si.project_code
                        ,si.scm_site_id
                        ,si.item_id
                 FROM   scm_mst_site_item si WITH(NOLOCK)
                 JOIN   scm_adm_lookup_master_detail md WITH(NOLOCK)
                 ON     si.division_id = md.segment1
                 AND    si.scm_site_id = md.segment3
                 WHERE  md.lookup_type = 'INTERNAL_BIZ_SITE'
                 AND    si.valid_yn    = 'Y'
                 AND    md.valid_yn    = 'Y') si
          ON     a.company_id  = si.company_id
          AND    a.division_id = si.division_id
          AND    a.item_id     = si.item_id
  
          -- 2018.04.26-2 사내 매출 거래 로직 반영 종료

		  -- 2018.07.31 scm_dnm_sales_result 로직 추가
          INSERT INTO scm_dnm_sales_result(  
                   company_id
				  ,division_id
				  ,sales_posting_date
				  ,system_input_date
				  ,system_input_time
				  ,soldto_code
				  ,shipto_code
				  ,project_code
				  ,item_id
				  ,origin_item_id
				  ,mat_group -- 2018.08.31-3
				  ,mat_group_desc
				  ,incoterms
				  ,sales_price
				  ,currency
				  ,sales_amount_for
				  ,sales_amount_sum
				  ,uom
				  ,sales_qty
				  ,distribution_channel
				  ,lgs_route_name
				  ,plant_id
				  ,sales_user
				  ,sales_user_name
				  ,profit_center_id
				  ,profit_center_name
				  ,partner_profit_center_id
				  ,partner_profit_center_name
				  ,valid_yn
				  ,created_by
				  ,creation_date
				  ,last_updated_by
				  ,last_update_date
				  ) 
          SELECT   company_id
				  ,division_id
				  ,sales_posting_date
				  ,system_input_date
				  ,system_input_time
				  ,customer_code
				  ,shipto_code
				  ,project_code
				  ,dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id)
				  ,item_id origin_item_id
				  ,mat_group -- 2018.08.31-3
				  ,mat_group_desc
				  ,incoterms
				  ,sales_price
				  ,currency
				  ,sales_amount_for
				  ,sales_amount_sum
				  ,uom
				  ,sales_qty
				  ,distribution_channel
				  ,lgs_route_name
				  ,plant_id
				  ,sales_user
				  ,sales_user_name
				  ,profit_center_id
				  ,profit_center_name
				  ,partner_profit_center_id
				  ,partner_profit_center_name
                  ,'Y'
                  ,@v_batch_user
                  ,GETDATE()
                  ,@v_batch_user
                  ,GETDATE()  
          FROM    xif_erp_sales_result_r_sn A WITH(NOLOCK) 
          WHERE   ifseqno       = @v_ifseqno 
          AND     transfer_flag = 'P';
      
          -----------------------------------------------------------
          -- INSERT LOG
          -----------------------------------------------------------
          SET @v_log_type = 'APPEND';
          SET @v_log_message = 'INSERT INTO dm_dnm_sales_result';
          SET @v_description = 'ifseqno = ' + @v_ifseqno;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------

        FETCH NEXT FROM CUR_SALES INTO @v_ifseqno, @v_yyyymmdd_from, @v_yyyymmdd_to; -- 2018.08.31
      END
        
      CLOSE CUR_SALES;
      DEALLOCATE CUR_SALES;

      -- project_code가 'N' 인 데이터 추가적으로 mapping 후 업데이트 2018.04.18 
      UPDATE dm_dnm_sales_result
      SET    project_code     = B.new_project_code 
            ,last_update_date = GETDATE()
      FROM   dm_dnm_sales_result A
      INNER JOIN (SELECT  CASE WHEN ( -- MKT FCST를 입력한 Project가 하나인 경우
                                     SELECT COUNT(DISTINCT x.project_code)
                                     FROM   dm_pln_mkt_fcst x WITH(NOLOCK)
                                     WHERE  x.division_id = a.division_id
                                     AND    x.scm_site_id = a.sales_site_id
                                     AND    x.item_id     = a.item_id
                                     AND    x.measure     = 'MKT_FCST'
                                     ) = 1 THEN (SELECT DISTINCT x.project_code
                                                 FROM   dm_pln_mkt_fcst x WITH(NOLOCK)
                                                 WHERE  x.division_id = a.division_id
                                                 AND    x.scm_site_id = a.sales_site_id
                                                 AND    x.item_id     = a.item_id
                                                 AND    x.measure     = 'MKT_FCST') 
                               WHEN (  -- SITE_ITEM에 동일 SITE로 하나의 Project만 연결된 경우
                                     SELECT COUNT(DISTINCT w.project_code)
                                     FROM   scm_mst_site_item w WITH(NOLOCK)
                                     WHERE  w.division_id		= a.division_id
                                     AND    w.scm_site_id		= a.sales_site_id
                                     AND    a.item_id		    = w.item_id 
                                     AND    w.valid_yn			= 'Y'
                                     ) = 1  THEN (SELECT DISTINCT w.project_code
                                                  FROM   scm_mst_site_item w WITH(NOLOCK)
                                                  WHERE  w.division_id      = a.division_id
                                                  AND    w.scm_site_id		= a.sales_site_id
                                                  AND    a.item_id   = w.item_id
                                                  AND    w.valid_yn    = 'Y')
                               WHEN (  -- SITE_ITEM에 ITEM이 하나만 연결된 경우
                                     SELECT COUNT(DISTINCT w.project_code)
                                     FROM   scm_mst_site_item w WITH(NOLOCK)
                                     WHERE  w.division_id		= a.division_id
                                     AND    a.item_id		    = w.item_id
                                     AND    w.valid_yn			= 'Y'
                                     ) = 1  THEN (SELECT DISTINCT w.project_code
                                                  FROM   scm_mst_site_item w WITH(NOLOCK)
                                                  WHERE  w.division_id		= a.division_id
                                                  AND    a.item_id		    = w.item_id
                                                  AND    w.valid_yn			= 'Y')
                               ELSE '-' -- 2018.08.31
                               END  new_project_code
                         ,division_id
                         ,project_code
                         ,sales_site_id
                         ,plant_site_id
                         ,item_id 
                         ,dom_exp
                         ,incoterms
                         ,measure
                         ,currency
                         ,yyyymmdd
                         ,fcst_type
                         ,qty
                         ,soldto_code
                         ,shipto_code
                  FROM  dm_dnm_sales_result a WITH(NOLOCK)
                  WHERE project_code = '-' -- 2018.08.31
                  AND   item_id     <> 'ETC'
                 ) B
      ON    A.division_id   = B.division_id
      AND   A.project_code  = B.project_code
      AND   A.sales_site_id = B.sales_site_id
      AND   A.plant_site_id = B.plant_site_id
      AND   A.item_id		= B.item_id 
      AND   A.dom_exp       = B.dom_exp
      AND   A.incoterms     = B.incoterms
      AND   A.measure       = B.measure
      AND   A.currency      = B.currency
      AND   A.yyyymmdd      = B.yyyymmdd
      AND   A.fcst_type     = B.fcst_type
      AND   A.qty           = B.qty
      AND   A.soldto_code   = B.soldto_code
      AND   A.soldto_code   = B.soldto_code
      WHERE B.new_project_code != '-' -- 2018.08.31
    

      /*===== Sales Site Mapping Start =======================================================================*/
    
	  -- 0. Soldto Code 가 법인인 경우 scm_site_id 법인코드로 Mapping - 2018.08.31-2
	  UPDATE dm_dnm_sales_result
      SET    sales_site_id = sr.soldto_code
      FROM   dm_dnm_sales_result sr WITH(NOLOCK)
      WHERE  sales_site_id = 'X'
	  AND    LEN(sr.soldto_code) = 4;

      -- 1. Sales Site Mapping : Soldto, Shipto 가 동일한 경우 Mapping
      UPDATE dbo.dm_dnm_sales_result
      SET    sales_site_id   =  B.scm_site_id
      FROM   dbo.dm_dnm_sales_result A WITH(NOLOCK)
      INNER JOIN (SELECT  division_id
                         ,soldto_code
                         ,shipto_code
                         ,MAX(scm_site_id) scm_site_id 
                  FROM   scm_mst_site_customer WITH(NOLOCK) 
                  WHERE  valid_yn = 'Y'  
                  GROUP BY division_id, soldto_code, shipto_code
                  HAVING count(distinct scm_site_id) = 1 -- 2018.05.14   Kim Jihye
                 ) B
      ON     B.division_id =  A.division_id
      AND    B.soldto_code =  A.soldto_code
      AND    B.shipto_code =  A.shipto_code
      WHERE  A.sales_site_id = 'X'
      AND    LEN(A.soldto_code) != 4   --2018.05.03
      AND    LEN(A.shipto_code) != 4;
        
      -- 2. Sales Site Mapping : project code 기준으로 하나의 site 만 등록된 경우 Mapping
      UPDATE dm_dnm_sales_result
      SET    sales_site_id = b.scm_site_id
      FROM   dm_dnm_sales_result sr WITH(NOLOCK) 
      JOIN   (SELECT  item.division_id
                     ,item.project_code
                     ,MAX(item.scm_site_id) scm_site_id
              FROM   scm_mst_site site WITH(NOLOCK) 
              JOIN   scm_mst_site_item item WITH(NOLOCK) 
              ON     site.division_id = item.division_id
              AND    site.scm_site_id = item.scm_site_id
              WHERE  site.valid_yn    = 'Y'
              AND    item.valid_yn    = 'Y'
              AND    site.site_type   = 'SALES'
              GROUP BY item.division_id, item.project_code
              HAVING count(distinct item.scm_site_id) = 1
             ) b
      ON     sr.division_id      = b.division_id
      AND    sr.project_code     = b.project_code
      WHERE  sr.sales_site_id    = 'X'
	  AND    sr.division_id      != '40' -- 2018.08.31-4, 소형 제외
      AND    LEN(sr.soldto_code) != 4 --2018.05.03
      AND    LEN(sr.shipto_code) != 4;

      -- 3. Sales Site Mapping : project code-Item 기준으로 하나의 site 만 등록된 경우 Mapping - 2018.05.14   Kim Jihye 
      UPDATE dm_dnm_sales_result
      SET    sales_site_id = b.scm_site_id
      FROM   dm_dnm_sales_result sr WITH(NOLOCK) 
      JOIN   (SELECT  item.division_id
                     ,item.project_code
                     ,item_id
                     ,MAX(item.scm_site_id) scm_site_id
              FROM   scm_mst_site site WITH(NOLOCK) 
              JOIN   scm_mst_site_item item WITH(NOLOCK) 
              ON     site.division_id = item.division_id
              AND    site.scm_site_id = item.scm_site_id
              WHERE  site.valid_yn    = 'Y'
              AND    item.valid_yn    = 'Y'
              AND    site.site_type   = 'SALES'
              GROUP BY item.division_id, item.project_code, item.item_id
              HAVING count(distinct item.scm_site_id) = 1
             ) b
      ON     sr.division_id      = b.division_id
      AND    sr.project_code     = b.project_code
      AND    sr.item_id			 = b.item_id
      WHERE  sr.sales_site_id    = 'X'
	  AND    sr.division_id      != '40' -- 2018.08.31-4, 소형 제외
      AND    LEN(sr.soldto_code) != 4 
      AND    LEN(sr.shipto_code) != 4;

      -- 4. Sales Site Mapping : project-item-customer 기준으로 하나의 site 만 등록된 경우 Mapping - 2018.05.14   Kim Jihye 
      UPDATE dm_dnm_sales_result
      SET    sales_site_id = b.scm_site_id
      FROM   dm_dnm_sales_result sr WITH(NOLOCK) 
      JOIN   (SELECT  item.division_id
                     ,item.project_code
                     ,item_id
                     ,cus.soldto_code
                     ,cus.shipto_code
                     ,MAX(item.scm_site_id) scm_site_id
              FROM   scm_mst_site site WITH(NOLOCK) 
              JOIN   scm_mst_site_item item WITH(NOLOCK) 
              ON     site.division_id = item.division_id
              AND    site.scm_site_id = item.scm_site_id
              JOIN   scm_mst_site_customer cus WITH(NOLOCK)
              ON     site.division_id = cus.division_id
              AND    site.scm_site_id = cus.scm_site_id
              WHERE  site.valid_yn    = 'Y'
              AND    item.valid_yn    = 'Y'
              AND    site.site_type = 'SALES'
              GROUP BY item.division_id, item.project_code, item.item_id, cus.soldto_code, cus.shipto_code
              HAVING count(distinct item.scm_site_id) = 1
             ) b
      ON     sr.division_id      = b.division_id
      AND    sr.project_code     = b.project_code
      AND    sr.item_id			 = b.item_id
      AND    sr.soldto_code      = b.soldto_code
      AND    sr.shipto_code      = b.shipto_code
      WHERE  sr.sales_site_id    = 'X'
	  AND    sr.division_id      != '40' -- 2018.08.31-4, 소형 제외
      AND    LEN(sr.soldto_code) != 4 
      AND    LEN(sr.shipto_code) != 4; 


      -- 5. Sales Site Mapping : shipto code 기준으로  sales site id가 한건만 있는 경우 mapping
      UPDATE dm_dnm_sales_result
      SET    sales_site_id = cus.scm_site_id
      FROM   dm_dnm_sales_result sr WITH(NOLOCK) 
      JOIN   (SELECT  cus.division_id
                     ,cus.shipto_code
                     ,MAX(cus.scm_site_id) scm_site_id
              FROM   scm_mst_site_customer cus WITH(NOLOCK) 
              WHERE  cus.valid_yn = 'Y'
              GROUP BY cus.division_id, cus.shipto_code
              HAVING count(distinct cus.scm_site_id) = 1) cus
      ON     sr.division_id = cus.division_id
      AND    sr.shipto_code      = cus.shipto_code
      WHERE  sr.sales_site_id    = 'X'
	  AND    sr.division_id      != '40' -- 2018.08.31-4, 소형 제외
      AND    LEN(sr.soldto_code) != 4 --2018.05.03
      AND    LEN(sr.shipto_code) != 4;


      -- 6. Sales Site Mapping : soldto code 기준으로 sales site id가 한건만 있는 경우 mapping
      UPDATE dm_dnm_sales_result
      SET    sales_site_id = cus.scm_site_id
      FROM   dm_dnm_sales_result sr WITH(NOLOCK) 
      JOIN   (SELECT  cus.division_id
                     ,cus.soldto_code
                     ,MAX(cus.scm_site_id) scm_site_id
              FROM   scm_mst_site_customer cus WITH(NOLOCK) 
              WHERE  cus.valid_yn = 'Y'
              GROUP BY cus.division_id, cus.soldto_code
              HAVING count(distinct cus.scm_site_id) = 1) cus
      ON     sr.division_id      = cus.division_id
      AND    sr.soldto_code      = cus.soldto_code
      WHERE  sr.sales_site_id    = 'X'
	  AND    sr.division_id      != '40' -- 2018.08.31-4, 소형 제외
      AND    LEN(sr.soldto_code) != 4 --2018.05.03
      AND    LEN(sr.shipto_code) != 4;	  

      /*===== Sales Site Mapping End =========================================================================*/

      
      -- Item 이 Pack원부자재일 경우 Plant_site_id mapping 로직 추가 2018.04.26
      UPDATE dm_dnm_sales_result
      SET    plant_site_id = ms.scm_site_id
      FROM   dm_dnm_sales_result sr WITH(NOLOCK)
      JOIN   scm_mst_item_sn mi WITH(NOLOCK)
      ON     sr.division_id = mi.division_id
      AND    sr.item_id     = mi.item_id
      JOIN   (SELECT  scm_site_id
                     ,plant_id
              FROM scm_mst_site WITH(NOLOCK)
              WHERE valid_yn      = 'Y'
              AND   site_type     = 'PLANT'
              AND operation_group = 'P') ms
      ON     sr.plant_site_id = ms.plant_id
      WHERE  sr.division_id        = 81
      AND    LEN(sr.plant_site_id) = 4
      AND    mi.material_class     = 'BC15';

      -- salse_site mapping 후 한번더 project_code mapping 2018.04.18
      UPDATE dm_dnm_sales_result
      SET    project_code     = B.new_project_code 
            ,last_update_date = GETDATE()
      FROM   dm_dnm_sales_result A
      INNER JOIN (SELECT  CASE WHEN ( -- MKT FCST를 입력한 Project가 하나인 경우
                                     SELECT COUNT(DISTINCT x.project_code)
                                     FROM   dm_pln_mkt_fcst x WITH(NOLOCK)
                                     WHERE  x.division_id = a.division_id
                                     AND    x.scm_site_id = a.sales_site_id
                                     AND    x.item_id     = a.item_id
                                     AND    x.measure     = 'MKT_FCST'
                                     ) = 1 THEN (SELECT DISTINCT x.project_code
                                                 FROM   dm_pln_mkt_fcst x WITH(NOLOCK)
                                                 WHERE  x.division_id = a.division_id
                                                 AND    x.scm_site_id = a.sales_site_id
                                                 AND    x.item_id     = a.item_id
                                                 AND    x.measure     = 'MKT_FCST') 
                               WHEN (  -- SITE_ITEM에 동일 SITE로 하나의 Project만 연결된 경우
                                     SELECT COUNT(DISTINCT w.project_code)
                                     FROM   scm_mst_site_item w WITH(NOLOCK)
                                     WHERE  w.division_id = a.division_id
                                     AND    w.scm_site_id = a.sales_site_id
                                     AND    a.item_id     = w.item_id
                                     AND    w.valid_yn    = 'Y'
                                     ) = 1  THEN (SELECT DISTINCT w.project_code
                                                  FROM   scm_mst_site_item w WITH(NOLOCK)
                                                  WHERE  w.division_id = a.division_id
                                                  AND    w.scm_site_id = a.sales_site_id
                                                  AND    a.item_id     = w.item_id
                                                  AND    w.valid_yn    = 'Y')
                               WHEN (  -- SITE_ITEM에 ITEM이 하나만 연결된 경우
                                     SELECT COUNT(DISTINCT w.project_code)
                                     FROM   scm_mst_site_item w WITH(NOLOCK)
                                     WHERE  w.division_id = a.division_id
                                     AND    a.item_id     = w.item_id
                                     AND    w.valid_yn    = 'Y'
                                     ) = 1  THEN (SELECT DISTINCT w.project_code
                                                  FROM   scm_mst_site_item w WITH(NOLOCK)
                                                  WHERE  w.division_id = a.division_id
                                                  AND    a.item_id     = w.item_id
                                                  AND    w.valid_yn    = 'Y')
                               ELSE '-' -- 2018.08.31
                               END  new_project_code
                         ,division_id
                         ,project_code
                         ,sales_site_id
                         ,plant_site_id
                         ,item_id
                         ,dom_exp
                         ,incoterms
                         ,measure
                         ,currency
                         ,yyyymmdd
                         ,fcst_type
                         ,qty
                         ,soldto_code
                         ,shipto_code
                  FROM  dm_dnm_sales_result a WITH(NOLOCK)
                  WHERE project_code = '-' -- 2018.08.31
                  AND   item_id    <> 'ETC'
                 ) B
      ON    A.division_id   = B.division_id
      AND   A.project_code  = B.project_code
      AND   A.sales_site_id = B.sales_site_id
      AND   A.plant_site_id = B.plant_site_id
      AND   A.item_id		= B.item_id
      AND   A.dom_exp       = B.dom_exp
      AND   A.incoterms     = B.incoterms
      AND   A.measure       = B.measure
      AND   A.currency      = B.currency
      AND   A.yyyymmdd      = B.yyyymmdd
      AND   A.fcst_type     = B.fcst_type
      AND   A.qty           = B.qty
      AND   A.soldto_code   = B.soldto_code
      AND   A.soldto_code   = B.soldto_code
      WHERE B.new_project_code != '-' -- 2018.08.31

      -- Fcst_type mapping 로직 변경 2018.05.15
      UPDATE dm_dnm_sales_result
      SET    fcst_type = B.fcst_type
      FROM   dm_dnm_sales_result A WITH(NOLOCK)
      JOIN  (SELECT  mf.division_id
                    ,mf.project_code
                    ,sr.sales_site_id
                    ,mf.item_id
                    ,MAX(mf.fcst_type) fcst_type
             FROM  dm_pln_mkt_fcst mf WITH(NOLOCK)
             INNER JOIN dm_dnm_sales_result sr WITH(NOLOCK)
             ON    mf.division_id  = sr.division_id
             AND   mf.project_code = sr.project_code
             AND   mf.scm_site_id  = sr.sales_site_id
             AND   mf.item_id      = sr.item_id
             WHERE sr.fcst_type    = '-'
             AND   sr.yyyymmdd     >= DATEADD(mm, DATEDIFF(mm,0,getdate()) - 1, 0)
             AND   mf.measure      = 'MKT_FCST'  -- 2018.06.26   Kim Jihye
             AND   mf.qty > 0                    -- 2018.06.26   Kim Jihye
             GROUP BY mf.division_id,mf.project_code,sr.sales_site_id,mf.item_id
             HAVING count(distinct mf.fcst_type) = 1) B
      ON    A.division_id   = B.division_id
      AND   A.project_code  = B.project_code
      AND   A.sales_site_id = B.sales_site_id
      AND   A.item_id		= B.item_id
      WHERE A.fcst_type     = '-'

      -- Fcst_type mapping 로직 변경 2018.05.15
      UPDATE dm_dnm_sales_result
      SET    fcst_type   = 'SMC'
      WHERE  fcst_type   = '-'
      AND    division_id = '81';

      UPDATE dm_dnm_sales_result
      SET    fcst_type = 'MPS'
      WHERE  fcst_type = '-';

	  -- 2018.07.12 비물동 매출(item_id = 'ETC') Delete 제외
	  UPDATE dm_dnm_sales_result
	  SET    sales_site_id = '-'
	        ,project_code  = '-' -- 2018.08.31
	  WHERE  sales_site_id = 'X'
      AND    item_id       = 'ETC'

      -- Sales_site_id 매핑이 안됐지만, project_code , item_id 가 있을경우 'N' 값으로 처리 후 나머지는 삭제
      UPDATE dm_dnm_sales_result
      SET    sales_site_id = 'N'
      WHERE  sales_site_id = 'X'
      AND    project_code != '-'
      AND    item_id       > char(0);


	  -- 2018.09.11 소형 G450은 연결로 조회되어야 함 .
      UPDATE dm_dnm_sales_result
      SET    sales_site_id = 'N'
      WHERE  sales_site_id = 'G450'
	  AND    DIVISION_ID   = '40';
	  
	  	  
      DELETE FROM dm_dnm_sales_result WHERE sales_site_id = 'X';


      -- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
      SET @n_history_seq = NEXT VALUE FOR seq1_dm_dnm_sales_result_h
     
      INSERT INTO dm_dnm_sales_result_h (
              history_seq
             ,division_id
             ,project_code
             ,sales_site_id
             ,plant_site_id
             ,item_id --2018.07.02
			 ,origin_item_id --2018.07.02
			 ,mat_group_desc --2018.07.02
             ,dom_exp
             ,fcst_type
             ,incoterms
             ,measure
             ,currency
             ,yyyymmdd
             ,qty
             ,soldto_code
             ,shipto_code
             ,valid_yn  
             ,creation_date
             ,last_update_date
             ,created_by          
             ,last_updated_by  
             ,history_creation_date)
      SELECT  @n_history_seq
             ,A.*
             ,@v_batch_user
             ,@v_batch_user
             ,GETDATE()
      FROM   (SELECT  A.*
                     ,B.creation_date
                     ,B.last_update_date 
              FROM   (SELECT  /* dm_dnm_sales_result_h */
                              division_id
                             ,project_code
                             ,sales_site_id
                             ,plant_site_id
                             ,item_id --2018.07.02
							 ,origin_item_id --2018.07.02
							 ,mat_group_desc --2018.07.02
                             ,dom_exp
                             ,fcst_type
                             ,incoterms
                             ,measure
                             ,currency
                             ,yyyymmdd
                             ,qty
                             ,soldto_code
                             ,shipto_code
                             ,valid_yn
                      FROM   dm_dnm_sales_result_temp$ WITH(NOLOCK)
                      EXCEPT
                      SELECT  /* dm_dnm_sales_result_h */
                              division_id
                             ,project_code
                             ,sales_site_id
                             ,plant_site_id
                             ,item_id --2018.07.02
							 ,origin_item_id --2018.07.02
							 ,mat_group_desc --2018.07.02
                             ,dom_exp
                             ,fcst_type
                             ,incoterms
                             ,measure
                             ,currency
                             ,yyyymmdd
                             ,qty
                             ,soldto_code
                             ,shipto_code
                             ,valid_yn
                      FROM   dm_dnm_sales_result WITH(NOLOCK)
                      WHERE  yyyymmdd BETWEEN (SELECT MIN(result_yyyymm)+'01' FROM xif_erp_sales_result_r_sn WITH(NOLOCK) WHERE transfer_flag = 'P') 
                                      AND     (SELECT MAX(result_yyyymm)+'31' FROM xif_erp_sales_result_r_sn WITH(NOLOCK) WHERE transfer_flag = 'P')) A 
              INNER JOIN dm_dnm_sales_result_temp$ B WITH(NOLOCK)
              ON     A.division_id		=  B.division_id
              AND    A.project_code		=  B.project_code
              AND    A.sales_site_id	=  B.sales_site_id
              AND    A.plant_site_id	=  B.plant_site_id
              AND    A.item_id		    =  B.item_id 
              AND    A.dom_exp          =  B.dom_exp 
              AND    A.fcst_type		=  B.fcst_type
              AND    A.incoterms		=  B.incoterms
              AND    A.measure			=  B.measure
              AND    A.yyyymmdd			=  B.yyyymmdd
              AND    A.currency			=  B.currency
              AND    A.soldto_code		=  B.soldto_code
              AND    A.shipto_code		=  B.shipto_code
              AND    A.qty				=  B.qty) A --2018.06.01

      -- HISTORY LOG  
      SET @v_log_type    = 'HISTORY';
      SET @n_log_count   = @@ROWCOUNT;
      SET @v_log_message = 'INSERT INTO dm_dnm_sales_result_h';
      SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
      SET @d_event_date  = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;    

      -- 2018. 05.18 transfer_flag update 로직 위치 변경
      -- 처리 row 마킹
      UPDATE xif_erp_sales_result_r_sn
      SET    transfer_flag   =  'Y'
      FROM   xif_erp_sales_result_r_sn A WITH(NOLOCK) 
      INNER JOIN dm_dnm_sales_result B WITH(NOLOCK)
      ON     A.division_id                         =  B.division_id
      AND    A.project_code                        =  B.attribute1 --2018.04.18
      AND    dbo.FN_SCM_SYS_NVL(A.item_id, 'ETC')  =  B.origin_item_id --2018.07.23
      AND    A.sales_posting_date                  =  B.yyyymmdd  
      --AND    A.incoterms      =  B.incoterms
      --AND   A.distribution_channel=  B.dom_exp
      AND    A.customer_code                       =  B.soldto_code 
      AND    A.shipto_code                         =  B.shipto_code
      WHERE  transfer_flag = 'P';

      -- 2018.04.26-2 사내 매출 거래 로직 반영 (처리 로우 transfer_flag update)
      UPDATE xif_erp_sales_result_r_sn
      SET    transfer_flag   =  'Y'
      FROM   xif_erp_sales_result_r_sn rs WITH(NOLOCK)
      JOIN  (SELECT  si.division_id
                    ,md.segment2 company_id
                    ,si.project_code
                    ,si.scm_site_id
                    ,si.item_id
             FROM   scm_mst_site_item si WITH(NOLOCK)
             JOIN   scm_adm_lookup_master_detail md WITH(NOLOCK)
             ON     si.division_id = md.segment1
             AND    si.scm_site_id = md.segment3
             WHERE  md.lookup_type = 'INTERNAL_BIZ_SITE'
             AND    si.valid_yn    = 'Y'
             AND    md.valid_yn    = 'Y') si
      ON     rs.company_id												= si.company_id
      AND    rs.division_id												= si.division_id
      AND    dbo.FN_GET_PACKER_PLAN_ITEM_ID(rs.division_id, rs.item_id) = si.item_id  --2018.07.23
      WHERE  rs.profit_center_id										= 'A40012'
      AND    rs.partner_profit_center_id								= 'A50101'
      AND    rs.transfer_flag											= 'P';

      -- 처리가 안된 row 마킹 , 처리가 안된 row : transfer_flag=X
      UPDATE xif_erp_sales_result_r_sn
      SET    transfer_flag = 'X' 
      WHERE  transfer_flag = 'P';

	  -- 2018.08.31-3, 소형의 경우 자재그룹을 참조로 한 End Customer 정보로 Project Code 설정
	  UPDATE xif_erp_sales_result_r_sn
	  SET    project_code = ''
	  FROM   xif_erp_sales_result_r_sn sr WITH(NOLOCK)		  
	  WHERE  sr.transfer_flag = 'P'
	  AND    sr.division_id   = '40';
  
      DROP TABLE dbo.dm_dnm_sales_result_temp$;
    
      EXEC PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING @p_division_id = NULL;

      IF @@TRANCOUNT > 0
        BEGIN
          COMMIT WORK;
        END;
      
    END -- BEGIN
    --  COMMIT TRANSACTION
  END TRY

  BEGIN CATCH
    -- ERROR LOG
    SET @v_log_type    = 'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END CATCH;

  -- 종료 LOG
  SET @v_log_type    = 'END';
  SET @v_log_message = '########## END of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;
