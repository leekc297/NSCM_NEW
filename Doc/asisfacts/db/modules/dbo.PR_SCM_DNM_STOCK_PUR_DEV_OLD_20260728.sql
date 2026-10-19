






/*
 * Program ID   : PR_SCM_DNM_STOCK_PUR 
 * Description  : * 5552 창고 재고 할당 
                 1. (재고 테이블)scm_dnm_stock_sn 테이블에서 storage_id = '5552' / stock_type	= 'INVENTORY' 인 정보 대상 / cutoff_date = GETDATE() (실행일,yyyymmdd값만사용)
                 2. (FCST 테이블)dm_pln_mkt_fcst 테이블에서 Item별로 최근 MKT FCST 가 있는 Sales Site / 모델 대상 /
                 3. (우선순위 테이블) scm_mst_site_item 테이블에서 우선순위(attribute7 컬럼) 별로 수량할당, 
                                      대상 Site : scm_mst_site.site_type = 'SALES' / scm_mst_site.country = 'KR'일때 우선순위 최하위 할당 
                     
                    (참고) 우선순위 : 순위1) yyyymmdd + scm_mst_site_item.attribute7 (site 우선순위, 작은값이 우선순위임)
                                      순위2) scm_mst_site.country ('KR'은 최하위, 다른국가는 동일순위임)
                                      순위3) fcst의 item별 qty합계 (큰수량이 우선순위임)
                 --20181127 추가
                 4. 배치2일치 실행(배치실행일 20181127(@p_issue_date) 일경우 20181126, 20181127 2일치의 데이터를 생성한다.)

                 참고)  5552번 재고item_id 12자리 변경후 동일item 처리
                        1. scm_dnm_stock_sn.item_id를 dbo.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id)를 치환된 대표 item_id 생성
                        2. 치환된 대표 item_id로 서로다른 origin_item_id(scm_dnm_stock_sn.item_id)의 수량을 합계처리함
                           (origin_item_id가 치환된 item_id와 동일한 데이터의 qty2컬럼에 합계수량을 셋팅. 단, origin_item_id 와 item_id가 동일한 데이터 없을경우 동일한 item_id(12자리 치환된 item_id)를 가지는 origin_item_id((수량DESC, item이름 우선순위) 데이터에 수량합계처리함)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.11.23   KSW            Initial Release 전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.11.27   KSW            1) 테이블 변경 및 배치일자 수정 (dm_pln_mkt_fcst_c -> dm_pln_mkt_fcst변경) (참고)주석2
                               2) country = 'KR' 일때 최하위 우선순위로 설정(기존은 country = 'KR'은 조회 대상이 아니었음 ) (참고)주석2
 * 2018.11.29   KSW            5552번 재고item_id 12자리 변경후 동일item 처리(origin item id(5552에 저장된 item id)와 item id(12자리로 치환된 item_id)가 동일한 재고데이터에 수량합계처리함,  
 *                             단, origin_item_id 와 item_id가 동일한 데이터 없을경우 동일한 item_id(12자리 치환된 item_id)를 가지는 임의의 origin_item_id 데이터에 수량합계처리함)
 * 2020.05.21   KSG            C20200506-000260 소형 Pack 5552 창고 재고 RTF 반영 구간 확대
 * 2020.06.26   KSG            5552 재고 차감 로직 : 앞에 있는 수요(60일 이내)부터 차감하는 Logic 적용
 * 2021.10.06   sclee.lee      PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : RTF개선
 * 2022.11.15   KSG            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 2023.07.19   KSG            E20230717-000121 [SCM/물류 PI팀] 5552창고 특별재고 처리 로직 변경 - 특별 재고 제외
 * 2024.01.10   HRK            E20240111-001299 Ship req. 계산 시, 5552 재고 분배 로직 개선 : SCS 출하실적 기준 Sales Site 분배
 *								- SCS 출하 실적에서 SCP UPLOAD 재고 제외 (최근 출하 실적 우선 차감)
 *								- 최근 출하 실적 우선 분배, 
 *								- 날짜 역순 누적 출하 실적이 많은 사이트 우선 분배
 *								- 출하 실적이 없는 품목은 기존 MKT_FCST 기준 분배 로직 적용
 * 2024.01.19   HRK            E20240111-001299 도착예정일 늦은 순으로 우선 분배
 * 2024.01.29   HRK            SCS출하 실적 기준 사이트 분배시 to site 코드 scm master 코드 참조 사용 (IF 데이터 대소문자 문제)
 * 2024.01.31   HRK            SCP UPLOAD 재고 참조 Cutoff date 변경 
 *								- 5552창고 재고(scm_dnm_stock_pur) cutoff_date 전일로 참조
 *								- scm_dnm_stock_pur은 fp cutoff 기준
 *								- scm_dnm_stock은 fp cutoff 전일 기준 
 * 2024.10.11   vadabi3        NERP - 특정 Storage 별도 처리 개선  STORAGE = 5552
 * 2024.10.28 	vadabi5	       NERP) QA, 개발 DB 적용 
 * 2024.11.19 	HRK			   LGES2024-002655 SCP 개선과제 이행 : 소형사업부 전주 출하건 5552 가상창고 이전 전기 자동처리
 *								- 매주 월요일 I/F 된 패커사 출하건에 대해 Ship Date 가 I/F 시점 전주 출하건에 대해 To site 를 scm_site_id 로 재고 생성 (일요일 재고)
 *								- Ex) 11/04(월) I/F 된 10/28(월)~11/03(일) 까지의 출하분 전부 재고로 생성 (11/03(일요일 재고)
 *								- scm_dnm_stock_sn 기초재고 출하실적 기준 사이트 분배 처리시 중복될 수 있어 자동생성 재고 출하실적에서 차감 처리
 *								- 출하실적 차감대상 upload 재고에 포함하여 출하실적에서 차감되도록 수정 (upload재고 -> 자동생성재고됨)
 *								- upload 재고 참조 테이블 변경 (scm_dnm_stock -> scm_dnm_stock_osp) 
 ----------------------------------------------------------------------------------------------------
 INSERT INTO scm_dnm_stock_pur

 exec NERP_PR_SCM_DNM_STOCK_PUR @p_issue_date1 = ''
 exec      PR_SCM_DNM_STOCK_PUR @p_issue_date1 = ''
 */

CREATE PROCEDURE [dbo].[PR_SCM_DNM_STOCK_PUR_DEV_OLD_20260728]
(
	@p_issue_date1         NVARCHAR(8)=NULL
)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
            
            --20181123 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
            DECLARE @p_issue_date  NVARCHAR(150)    = @p_issue_date1 ;
    
            -- LOG 용 변수 설정
            DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
            DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_STOCK_PUR';
            DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
            DECLARE @n_log_count    INTEGER = 0;
            DECLARE @v_log_message  NVARCHAR(1000);
            DECLARE @v_description  NVARCHAR(500);
            DECLARE @d_event_date   DATETIME;
            DECLARE @n_history_seq	BIGINT;
            DECLARE @v_ifseqno      NVARCHAR(50);
            DECLARE @d_issue_date   DATETIME;            
            
            IF @p_issue_date IS NULL OR ISDATE(@p_issue_date) != 1
            BEGIN
		         SET @d_issue_date = CONVERT(DATETIME, CONVERT(NVARCHAR(8), GETDATE(), 112)) -- 재고처리용 당일
            END
		    ELSE
            BEGIN
		         SET @d_issue_date = CONVERT(DATETIME, @p_issue_date) 
            END
            
            DECLARE @d_last_issue_date DATETIME = @d_issue_date  -- WHILE 문 실행시 종료@d_issue_date
            
            -- @p_issue_date를 실행-1일로 셋팅 (현재일, 현재일-1일, 2일간 데이터를 생성해야 함)
            SET @d_issue_date = DATEADD(dd, -1, @d_issue_date)           
          
	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	BEGIN TRY
	  BEGIN           
           
 		  ---------------------------------------------------------------------------------------------------
		  print  convert(varchar(30), getdate(), 121) + N' 1.0 BOD LT 정보'   -- E20240111-001299
		  ---------------------------------------------------------------------------------------------------
		  IF OBJECT_ID('TEMPDB..#BOD_LT') IS NOT NULL
		  	DROP TABLE #BOD_LT
		  
		  SELECT B.DIVISION_ID
		  	  ,B.FROM_SITE
		  	  ,B.TO_SITE
		  	  ,B.INCOTERMS
		  	  ,B.TRANSPORT_MODE
		  	  ,B.FROM_YYYYMMDD
		  	  ,B.TO_YYYYMMDD
		  	  ,B.LT_TOTAL
		   INTO #BOD_LT
		   FROM SCP_MST_BOD_N_V B WITH(NOLOCK)
		  WHERE 1=1

          WHILE(@d_issue_date  <= @d_last_issue_date)
           BEGIN
               --PRINT 'd_issue_date : ' + CONVERT(NVARCHAR(8), @d_issue_date, 112)
               --DECLARE @d_issue_date DATETIME = CONVERT(NVARCHAR(10), '20181122', 23)  --(테스트용)
               --DECLARE @p_cutoff_date  NVARCHAR(8) = CONVERT(NVARCHAR(8), DATEADD(DD, -1, @d_issue_date), 112); --(테스트용)
               --------------------------------------------------------
               -- 1. 5552 재고처리 대상 데이터 임시테이블로 생성
               --------------------------------------------------------
               IF OBJECT_ID('tempdb..#scm_dnm_stock_temp') IS NOT NULL
               BEGIN 
                   DROP TABLE  #scm_dnm_stock_temp          
               END   

               -- 20181129 수정 ( 기존 item_id(origin_item_id)를 12자리 치환된 item_id로 변경)
               SELECT  company_id
                    ,  division_id                       
                    ,  site_id
                    ,  plant_id
                    ,  factory_id
                    ,  storage_id
                    ,  cutoff_date
                    ,  seq
                    ,  stock_type
                    ,  item_id            AS origin_item_id
                    ,  lane                   --NULL만존재
                    ,  production_type        --NULL만존재
                    ,  available_date
                    ,  remain_lead_time       --0.0000000000
                    ,  holding_date
                    ,  qty
                    ,  qty_uom
                    ,  stock_status           --NULL만존재
                    ,  operation_id           -- '-'
                    ,  line_id                --NULL만존재
                    ,  outsourcing_flag       -- '-'
                    ,  outsourcing_factory    --NULL만존재
                    ,  description            --NULL만존재
                    ,  fp_apply_operation_id  --NULL만존재
                    ,  fp_apply_item_id
                    ,  fp_apply_wipqty        --NULL만존재
                    ,  wiphold_yn             --NULL만존재
                    ,  wip_type_code          --NULL만존재
                    ,  qty2
                    ,  modify_fp_apply_wipqty --NULL만존재
                    ,  modify_description     --NULL만존재
                    ,  cal_qty                --NULL만존재
                    ,  formation_rework_type  --NULL만존재
                    ,  insert_id              --
                    ,  insert_time            -- 
                    ,  update_id              --
                    ,  update_time            --
                    ,  location               --NULL만존재
                    ,  release_due_date       --NULL만존재
                    ,  ship_available_date    --NULL만존재 
                    ,  long_term_qty          --NULL만존재
                    ,  moving_qty             --NULL만존재
                    ,  capa_grd_code          --NULL만존재
                    ,  vltg_grd_code          --NULL만존재
                    ,  rsst_grd_code          --NULL만존재
                    ,  defect_qty             --NULL만존재 
                    , dbo.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id) AS item_id
					, row_number() over (partition by division_id
													, dbo.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id)
											 order by seq)										as rn			-- E20240111-001299				
					, row_number() over (partition by 'a' order by division_id, item_id, seq)	as unique_seq	-- E20240111-001299

               INTO   #scm_dnm_stock_temp
               FROM   scm_dnm_stock_sn WITH (NOLOCK) --[LGCE_FPDEV_TR].[dbo].[SCM_STOCK_H] --COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, STORAGE_ID, CUTOFF_DATE, SEQ
               WHERE  storage_id = ( -- 5552
			                         SELECT SEGMENT2 
			                           FROM SCM_CODE_LOOKUP_VALUE 
									  WHERE LOOKUP_TYPE_CODE = 'PR_SCM_DNM_STOCK_PUR' 
									    AND SEGMENT1 = 'STORAGE_ID'
									   )
               AND    stock_type = 'INVENTORY'
               AND    cutoff_date = @d_issue_date
			   -- 20230719 E20230717-000121 - 특별 재고 제외
               AND    ISNULL(special_stock_indicator, '') = ''
               ;           

				/*---------------------- Begin -- E20240111-001299 Ship req. 계산 시, 5552 재고 분배 로직 개선 : SCS 출하실적 기준 Sales Site 분배 added on 2024.01.10 -----------------*/
				/*---------------------- Begin -- E20240111-001299 Ship req. 계산 시, 5552 재고 분배 로직 개선 : SCS 출하실적 기준 Sales Site 분배 added on 2024.01.10 -----------------*/

				DECLARE @V_ISSUE_DATE			NVARCHAR(8) = CONVERT(NVARCHAR(8), @d_issue_date, 112)
				DECLARE @V_UPLOAD_ISSUE_DATE	NVARCHAR(8) = CONVERT(NVARCHAR(8), DATEADD(DD, -1,  @d_issue_date), 112)	;	-- 2024.01.31 추가
				DECLARE @V_FROM_RESULT			NVARCHAR(8) = CONVERT(NVARCHAR(8), DATEADD(DD, -59, @d_issue_date), 112)	;
				DECLARE @V_TO_RESULT			NVARCHAR(8) = @V_ISSUE_DATE

				-- LGES2024-002655 SCP 개선과제 이행 : 소형사업부 전주 출하건 5552 가상창고 이전 전기 자동처리
				DECLARE @v_from_ship_for_inv NVARCHAR(8) = CONVERT(NVARCHAR(8), DATEADD(DAY, -7, @d_issue_date) ,112) 
				DECLARE @v_to_ship_for_inv	 NVARCHAR(8) = CONVERT(NVARCHAR(8), DATEADD(DAY, -1, @d_issue_date) ,112)  

				PRINT '------------------------------------------------';
				PRINT '@V_ISSUE_DATE			= ' + @V_ISSUE_DATE;
				PRINT '@V_UPLOAD_ISSUE_DATE		= ' + @V_UPLOAD_ISSUE_DATE;
				PRINT '@V_FROM_RESULT			= ' + @V_FROM_RESULT;
				PRINT '@V_TO_RESULT				= ' + @V_TO_RESULT;
				PRINT '@@v_from_ship_for_inv	= ' + @v_from_ship_for_inv;
				PRINT '@@v_to_ship_for_inv		= ' + @v_to_ship_for_inv;
				PRINT '------------------------------------------------';

				---------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' 1.1.1 SCS 출하실적 - BOD LT 반영전 ' 
				---------------------------------------------------------------------------------------------------
				IF OBJECT_ID('TEMPDB..#SCS_SHIP_RESULT_BEFORE') IS NOT NULL
					DROP TABLE #SCS_SHIP_RESULT_BEFORE

				SELECT E.DIVISION_ID				AS DIVISION_ID
					,  E.ITEM_ID					AS ITEM_ID
					,  TS.SCM_SITE_ID				AS TO_SITE	-- 2024.01.29 
					,  CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(B.LT_TOTAL,0), CONVERT(DATE, E.SHIP_DATE, 112)),112) AS YYYYMMDD	-- LT반영 SHIP_DATE 도착 기준  
					,  ISNULL(C.TRANSPORT_MODE,'-')	AS TRANSPORT_MODE	-- 20240119 
					,  ISNULL(C.INCOTERMS,'-')		AS INCOTERMS		-- 20240119 
					,  E.SHIP_DATE					
					,  B.LT_TOTAL
					,  SUM(E.SHIP_QTY)				AS SHIP_QTY
					,  CASE WHEN  E.DIVISION_ID = '40'
								 AND E.SHIP_DATE BETWEEN   @v_from_ship_for_inv		-- 전주(월요일)
													 AND   @v_to_ship_for_inv		-- 전주(일요일)
								 AND E.LAST_UPDATE_DATE >= @d_issue_date					-- 월요일 I/F데이터 변경/생성 
								 AND E.LAST_UPDATE_DATE <  dateadd(day, 1, @d_issue_date)	-- 월요일 I/F데이터 변경/생성
								 AND DATEPART ( WEEKDAY , @d_issue_date)  = 2				-- issue date가 월요일 
							THEN 'STOCK'	-- 재고 자동생성 대상 전주 출하실적
							ELSE 'ALLOC'	-- 사이트 분배대상 출하실적
						END							AS TARGET_DV			-- LGES2024-002655 SCP 개선과제 이행 : 소형사업부 전주 출하건 5552 가상창고 이전 전기 자동처리  
					,  MAX(TS.COMPANY_ID)			AS COMPANY_ID			-- LGES2024-002655 SCP 개선과제 이행 : 소형사업부 전주 출하건 5552 가상창고 이전 전기 자동처리 
				 INTO #SCS_SHIP_RESULT_BEFORE
				 FROM SCM_DNM_SCS_SHIP_RESULT E WITH(NOLOCK)
					  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
							  ON FI.ITEM_ID		= E.ITEM_ID 
							 AND FI.DIVISION_ID = E.DIVISION_ID
					  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK) -- from site 
							  ON FS.DIVISION_ID = E.DIVISION_ID
							 AND FS.SCM_SITE_ID = E.SCM_SITE_ID 
							 AND FS.OSP_YN = 'Y'
					  INNER JOIN SCM_MST_SITE TS WITH(NOLOCK) -- to site 
							  ON TS.DIVISION_ID = E.DIVISION_ID
							 AND TS.SCM_SITE_ID = E.TO_SITE 
							 AND TS.SITE_TYPE   = 'SALES'
					  LEFT  JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)	-- 20240119 
							  ON C.DIVISION_ID	= E.DIVISION_ID	
							 AND C.ITEM_ID 		= E.PACK_MODEL_CODE
							 AND C.FROM_SITE	= E.SCM_SITE_ID    
							 AND C.TO_SITE		= E.TO_SITE        
							 AND C.CONFIRM_ID	= E.ATTRIBUTE5
					  LEFT  JOIN #BOD_LT B WITH(NOLOCK)
							  ON B.DIVISION_ID	 = E.DIVISION_ID
							 AND B.FROM_SITE	 = E.SCM_SITE_ID
							 AND B.TO_SITE		 = E.TO_SITE
							 AND B.INCOTERMS	 = ISNULL(C.INCOTERMS,'-')
							 AND B.TRANSPORT_MODE= ISNULL(C.TRANSPORT_MODE,'-')
				WHERE 1=1
					AND E.SHIP_DATE BETWEEN @V_FROM_RESULT 
										AND @V_TO_RESULT
				GROUP BY 
					   E.DIVISION_ID
					,  E.ITEM_ID     
					,  TS.SCM_SITE_ID	-- 2024.01.29
					,  CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(B.LT_TOTAL,0), CONVERT(DATE, E.SHIP_DATE, 112)),112)  
					,  ISNULL(C.TRANSPORT_MODE,'-')
					,  ISNULL(C.INCOTERMS,'-')		
					,  E.SHIP_DATE					
					,  B.LT_TOTAL
					,  CASE WHEN  E.DIVISION_ID = '40'
								 AND E.SHIP_DATE BETWEEN   @v_from_ship_for_inv		-- 전주(월요일)
													 AND   @v_to_ship_for_inv		-- 전주(일요일)
								 AND E.LAST_UPDATE_DATE >= @d_issue_date					-- 월요일 I/F데이터 변경/생성 
								 AND E.LAST_UPDATE_DATE <  dateadd(day, 1, @d_issue_date)	-- 월요일 I/F데이터 변경/생성
								 AND DATEPART ( WEEKDAY , @d_issue_date)  = 2				-- issue date가 월요일 
							THEN 'STOCK'
							ELSE 'ALLOC'
						END
				HAVING SUM(E.SHIP_QTY) != 0 


				---------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' 1.1.2 SCS 출하실적 - 사이트 분배 대상 ' 
				---------------------------------------------------------------------------------------------------
				IF OBJECT_ID('TEMPDB..#SCS_SHIP_RESULT') IS NOT NULL
					DROP TABLE #SCS_SHIP_RESULT

				SELECT E.DIVISION_ID
					,  E.ITEM_ID	
					,  E.TO_SITE	
					,  E.YYYYMMDD	
					,  SUM(E.SHIP_QTY)				AS RESULT_QTY
					,  SUM(SUM(E.SHIP_QTY))	OVER (PARTITION BY E.DIVISION_ID
															  ,E.ITEM_ID
														      ,E.TO_SITE
												      ORDER BY E.YYYYMMDD DESC ) 
													AS ACC_RESULT_QTY
					,  SUM(SUM(E.SHIP_QTY))	OVER (PARTITION BY E.DIVISION_ID
														      ,E.ITEM_ID
														      ,E.TO_SITE
												      ORDER BY E.YYYYMMDD DESC ) 
					   - SUM(E.SHIP_QTY)			AS PRVS_ACC_RESULT_QTY
				 INTO #SCS_SHIP_RESULT
				 FROM #SCS_SHIP_RESULT_BEFORE E WITH(NOLOCK)
				WHERE 1=1
				  AND TARGET_DV = 'ALLOC'	-- LGES2024-002655 SCP 개선과제 이행 : 소형사업부 전주 출하건 5552 가상창고 이전 전기 자동처리
				GROUP BY 
					   E.DIVISION_ID
					,  E.ITEM_ID     
					,  E.TO_SITE     
					,  E.YYYYMMDD  
				HAVING SUM(E.SHIP_QTY) != 0 
				ORDER BY E.DIVISION_ID
					   , E.ITEM_ID
					   , E.TO_SITE
					   , E.YYYYMMDD DESC 

				-------------------------------------------------------------------------------------------------------
				-- LGES2024-002655 SCP 개선과제 이행 : 소형사업부 전주 출하건 5552 가상창고 이전 전기 자동처리
				print  convert(varchar(30), getdate(), 121) + N' 1.1.3 SCS 출하실적 재고 생성 대상- 전주 출하/월요일IF ' 
				-------------------------------------------------------------------------------------------------------
				IF OBJECT_ID('TEMPDB..#UPLOAD_STOCK_TO_CREATE') IS NOT NULL
					DROP TABLE #UPLOAD_STOCK_TO_CREATE

				SELECT E.DIVISION_ID				AS DIVISION_ID
					,  E.ITEM_ID					AS ITEM_ID
					,  E.TO_SITE					AS SCM_SITE_ID  -- to sales site 
					,  MAX(E.COMPANY_ID)			AS COMPANY_ID 
					,  SUM(E.SHIP_QTY)				AS SHIP_QTY 
					,  ROW_NUMBER()	OVER (PARTITION BY 'A' 
											  ORDER BY E.DIVISION_ID
													  ,E.TO_SITE) AS SEQ 
				 INTO #UPLOAD_STOCK_TO_CREATE
				 FROM #SCS_SHIP_RESULT_BEFORE E WITH(NOLOCK)
				WHERE 1=1
				  AND TARGET_DV = 'STOCK'
				GROUP BY 
					   E.DIVISION_ID
					,  E.ITEM_ID     
					,  E.TO_SITE
					
				---------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' 1.2.1 SCP UPLOAD 재고' 
				-- 2024.11.20 참조 테이블 변경 scm_dnm_stock -> scm_dnm_stock_osp
				-- as-is : 최종 20시에 반영된 upload 재고를 참조하게 됨 -> 23시 10분에 upload 재고가 dnm stock에 최종 반영되는데 22시 pur 수행시에는 20시 이후 업로드된 데이터 참조가 안됨.
				-- to-be : stock osp를 참조하여 22시 까지 최종 upload된 데이터가 pur 분배시 참조되도록 변경함.
				---------------------------------------------------------------------------------------------------
				IF OBJECT_ID('TEMPDB..#UPLOAD_DNM_STOCK') IS NOT NULL
					DROP TABLE #UPLOAD_DNM_STOCK 

				SELECT DS.DIVISION_ID
					  ,[dbo].[FN_SCM_SYS_NVL](FI.PACKER_PLAN_ITEM_ID, DS.ITEM_ID)	AS ITEM_ID
					  ,DS.SCM_SITE_ID
					  ,SUM(QTY)			AS UPLOAD_STOCK_QTY
				 INTO #UPLOAD_DNM_STOCK
				 FROM SCM_DNM_STOCK_OSP DS WITH(NOLOCK)
					  INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
							  ON MS.DIVISION_ID = DS.DIVISION_ID
							 AND MS.SCM_SITE_ID = DS.SCM_SITE_ID
							 AND MS.SITE_TYPE	= 'SALES'
					  LEFT  JOIN SCP_MST_FINAL_ITEM  FI WITH(NOLOCK)  -- 2024.11.26 
							  ON FI.DIVISION_ID = DS.DIVISION_ID
							 AND FI.ITEM_ID		= DS.ITEM_ID
				WHERE 1=1
				  AND DS.YYYYMMDD = @V_UPLOAD_ISSUE_DATE  -- 참조 issue_date 변경 
				GROUP BY DS.DIVISION_ID
						,[dbo].[FN_SCM_SYS_NVL](FI.PACKER_PLAN_ITEM_ID, DS.ITEM_ID)	
						,DS.SCM_SITE_ID
				HAVING SUM(QTY) != 0 

				---------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' 1.3 SCS 출하실적 조정 - SCP UPLOAD 재고 차감' 
				-- 최근 출하 실적 우선 차감
				---------------------------------------------------------------------------------------------------
				IF OBJECT_ID('TEMPDB..#SCS_SHIP_RESULT_ADJ') IS NOT NULL
					DROP TABLE #SCS_SHIP_RESULT_ADJ

				;WITH SHIP_RESULT_MINUS_UPLOAD AS (
					SELECT SR.*
						  ,ISNULL(US.UPLOAD_STOCK_QTY, 0) AS UPLOAD_STOCK_QTY
						  ,CASE WHEN ISNULL(US.UPLOAD_STOCK_QTY, 0) = 0						THEN RESULT_QTY
								WHEN PRVS_ACC_RESULT_QTY >= ISNULL(US.UPLOAD_STOCK_QTY, 0)	THEN RESULT_QTY
								WHEN ACC_RESULT_QTY		 >= ISNULL(US.UPLOAD_STOCK_QTY, 0)	THEN ACC_RESULT_QTY - ISNULL(US.UPLOAD_STOCK_QTY, 0)
								ELSE RESULT_QTY
						   END ADJ_RESULT_QTY
					 FROM #SCS_SHIP_RESULT SR WITH(NOLOCK)
						  LEFT JOIN #UPLOAD_DNM_STOCK US WITH(NOLOCK)
								 ON US.DIVISION_ID	= SR.DIVISION_ID
								AND US.ITEM_ID		= SR.ITEM_ID
								AND US.SCM_SITE_ID	= SR.TO_SITE
					WHERE 1=1
				)
				SELECT DIVISION_ID
					  ,ITEM_ID
					  ,TO_SITE
					  ,YYYYMMDD
					  ,UPLOAD_STOCK_QTY			
					  ,RESULT_QTY				AS BEFORE_RESULT_QTY
					  ,ADJ_RESULT_QTY			AS RESULT_QTY
					  ,SUM(ADJ_RESULT_QTY) OVER (PARTITION BY DIVISION_ID
															 ,ITEM_ID
															 ,TO_SITE
													 ORDER BY YYYYMMDD DESC)
												AS ACC_SITE_RESULT_QTY
				 INTO #SCS_SHIP_RESULT_ADJ
				 FROM SHIP_RESULT_MINUS_UPLOAD
				WHERE 1=1

				---------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' 1.4 SCS 출하실적 - 분배 우선순위 정보 추가' 
 				-- 최근 출하 실적 우선 분배, 
 				-- 날짜 역순 누적 출하 실적이 많은 사이트 우선 분배
				---------------------------------------------------------------------------------------------------
				IF OBJECT_ID('TEMPDB..#SCS_SHIP_RESULT_ADJ_PRIORITY') IS NOT NULL
					DROP TABLE #SCS_SHIP_RESULT_ADJ_PRIORITY

				-- 우선순위 
				;WITH SCS_SHIP_RESULT_ADJ_PRIORITY AS (
					SELECT SR.DIVISION_ID
						  ,SR.ITEM_ID
						  ,SR.TO_SITE
						  ,SR.YYYYMMDD
						  ,SR.RESULT_QTY	AS ORG_RESULT_QTY
						  ,SR.RESULT_QTY
						  ,SR.ACC_SITE_RESULT_QTY
						  ,SUM(SR.RESULT_QTY) OVER (PARTITION BY SR.DIVISION_ID
																,SR.ITEM_ID
																,SR.TO_SITE) AS SITE_RESULT_QTY
						  ,ROW_NUMBER() OVER (PARTITION BY SR.DIVISION_ID
														  ,SR.ITEM_ID
												  ORDER BY SR.YYYYMMDD DESC
														  ,SR.ACC_SITE_RESULT_QTY DESC) AS PRIORITY
					 FROM #SCS_SHIP_RESULT_ADJ SR WITH(NOLOCK)
					WHERE 1=1
					  AND SR.RESULT_QTY != 0 
				), SCS_SHIP_RESULT_ADJ_PRIORITY2 AS (
					SELECT SR.*
						  ,MAX(PRIORITY)   OVER (PARTITION BY SR.DIVISION_ID
															 ,SR.ITEM_ID)	
														AS MAX_PRIORITY
						  ,DENSE_RANK()	   OVER (PARTITION BY SR.DIVISION_ID
															 ,SR.ITEM_ID
													  ORDER BY SR.SITE_RESULT_QTY DESC)
														AS SITE_PRIORITY
					 FROM SCS_SHIP_RESULT_ADJ_PRIORITY SR WITH(NOLOCK)
					WHERE 1=1
				)
				SELECT SR.*
					  ,MAX(CASE WHEN SR.SITE_PRIORITY = 1 
								THEN SR.TO_SITE
								ELSE NULL
						   END)		   OVER (PARTITION BY SR.DIVISION_ID
														 ,SR.ITEM_ID)
													AS REMAIN_ALLOC_SITE
					  ,SUM(RESULT_QTY) OVER (PARTITION BY SR.DIVISION_ID
														 ,SR.ITEM_ID
												 ORDER BY SR.PRIORITY)
													AS ACC_RESULT_QTY
					  ,SUM(RESULT_QTY) OVER (PARTITION BY SR.DIVISION_ID
														 ,SR.ITEM_ID
												 ORDER BY SR.PRIORITY)
					   - RESULT_QTY					AS PRVS_ACC_RESULT_QTY
					  ,CONVERT(NUMERIC(20), 0)		AS PRVS_DS_RN
					  ,CONVERT(NUMERIC(20), 0)		AS DS_RN
					  ,CONVERT(NUMERIC(20), 0)		AS DS_UNIQUE_SEQ
					  ,CONVERT(NUMERIC(20,10), 0)	AS INV_QTY
					  ,CONVERT(NUMERIC(20,10), 0)	AS ALLOC_INV_QTY
					  ,CONVERT(NUMERIC(20,10), 0)	AS REMAIN_INV_QTY
					  ,'INIT-' +CONVERT(NVARCHAR, ROW_NUMBER()		OVER (PARTITION BY 'A' ORDER BY SR.DIVISION_ID, SR.ITEM_ID, SR.PRIORITY)) AS SR_KEY
				 INTO #SCS_SHIP_RESULT_ADJ_PRIORITY
				 FROM SCS_SHIP_RESULT_ADJ_PRIORITY2 SR WITH(NOLOCK)
				WHERE 1=1
				ORDER BY PRIORITY

				---------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' 1.5 SCS 출하실적 기준 재고 분배' 
 				-- 최근 출하 실적 우선 분배, 
 				-- 날짜 역순 누적 출하 실적이 많은 사이트 우선 분배
				-- 동일 품목에 대해서 여러건의 재고 데이터가 존재할 수 있음으로 반복 수행 
				---------------------------------------------------------------------------------------------------

				DECLARE @v_ds_rn		NUMERIC(20)	= 0 
				DECLARE @v_ds_rn_max	NUMERIC(20)	= 0 

				SELECT @v_ds_rn_max = ISNULL(MAX(rn),0)
				 FROM #scm_dnm_stock_temp WITH(NOLOCK)
				WHERE 1=1

				print '@v_ds_rn_max : ' + convert(nvarchar, @v_ds_rn_max) 

				WHILE (@v_ds_rn_max > 0 and @v_ds_rn  < @v_ds_rn_max)
				  BEGIN

					SET @v_ds_rn = @v_ds_rn + 1;
					print '@v_ds_rn : ' + convert(nvarchar, @v_ds_rn) 

					---------------------------------------------------------------------------------------------------
					print  convert(varchar(30), getdate(), 121) + N' 1.5.1 SCS 출하실적 기준 재고 분배 결과 UPDATE' 
					---------------------------------------------------------------------------------------------------
					UPDATE SR SET
						   SR.DS_RN				= DS.RN
						  ,SR.DS_UNIQUE_SEQ		= DS.UNIQUE_SEQ
						  ,SR.INV_QTY			= DS.QTY2
						  ,SR.REMAIN_INV_QTY	= CASE	WHEN SR.PRIORITY = MAX_PRIORITY 
														 AND SR.ACC_RESULT_QTY		<  DS.QTY2
														THEN DS.QTY2 - SR.ACC_RESULT_QTY
														ELSE 0
												  END
						  ,SR.ALLOC_INV_QTY		= CASE	WHEN SR.ACC_RESULT_QTY		<= DS.QTY2	THEN SR.RESULT_QTY
														WHEN SR.PRVS_ACC_RESULT_QTY	<  DS.QTY2	THEN DS.QTY2 - SR.PRVS_ACC_RESULT_QTY
														ELSE 0
												  END
						  ,SR.RESULT_QTY		= CASE	WHEN SR.ACC_RESULT_QTY		<= DS.QTY2	THEN 0
														WHEN SR.PRVS_ACC_RESULT_QTY	<  DS.QTY2	THEN SR.ACC_RESULT_QTY - DS.QTY2
														ELSE SR.RESULT_QTY
												  END
					  FROM #SCS_SHIP_RESULT_ADJ_PRIORITY SR WITH(NOLOCK)
						   INNER JOIN #scm_dnm_stock_temp DS with(nolock)
								   ON DS.DIVISION_ID = SR.DIVISION_ID
								  AND DS.ITEM_ID	 = SR.ITEM_ID
					 WHERE 1=1
					   AND DS.RN	= @v_ds_rn 
					   AND SR.DS_RN = 0 

					---------------------------------------------------------------------------------------------------
					print  convert(varchar(30), getdate(), 121) + N' 1.5.2 SCS 출하실적 기준 재분배 대상 Insert'
					-- 분배 후 남은 출하실적 재분배 대상으로 Insert 
					---------------------------------------------------------------------------------------------------
					INSERT INTO #SCS_SHIP_RESULT_ADJ_PRIORITY 
					SELECT SR.DIVISION_ID
						  ,SR.ITEM_ID
						  ,SR.TO_SITE
						  ,SR.YYYYMMDD
						  ,SR.RESULT_QTY	AS ORG_RESULT_QTY
						  ,SR.RESULT_QTY
						  ,SR.ACC_SITE_RESULT_QTY
						  ,SR.SITE_RESULT_QTY
						  ,SR.PRIORITY
						  ,SR.MAX_PRIORITY
						  ,SR.SITE_PRIORITY
						  ,SR.REMAIN_ALLOC_SITE
						  ,SUM(SR.RESULT_QTY) OVER (PARTITION BY SR.DIVISION_ID
															 ,SR.ITEM_ID
													 ORDER BY SR.PRIORITY)
												AS ACC_RESULT_QTY
						  ,SUM(SR.RESULT_QTY) OVER (PARTITION BY SR.DIVISION_ID
															 ,SR.ITEM_ID
													 ORDER BY SR.PRIORITY)
						   - RESULT_QTY			AS PRVS_ACC_RESULT_QTY
						  ,SR.DS_RN						AS PRVS_DS_RN
						  ,CONVERT(NUMERIC(20), 0)		AS DS_RN
						  ,CONVERT(NUMERIC(20), 0)		AS DS_UNIQUE_SEQ
						  ,CONVERT(NUMERIC(20,10), 0)	AS INV_QTY
						  ,CONVERT(NUMERIC(20,10), 0)	AS ALLOC_INV_QTY
						  ,CONVERT(NUMERIC(20,10), 0)	AS REMAIN_INV_QTY
						  ,'DSRN-' + CONVERT(NVARCHAR, DS_RN) +'-' +CONVERT(NVARCHAR, ROW_NUMBER()		OVER (PARTITION BY 'A' ORDER BY SR.DIVISION_ID, SR.ITEM_ID, SR.PRIORITY)) AS SR_KEY
					 FROM #SCS_SHIP_RESULT_ADJ_PRIORITY SR WITH(NOLOCK) 
					WHERE 1=1 
					  AND SR.DS_RN		 = @v_ds_rn 
					  AND SR.RESULT_QTY != 0 
					ORDER BY SR.DIVISION_ID
							,SR.ITEM_ID
							,SR.PRIORITY ;

				  END	--// WHILE (@v_ds_rn_max > 0 and @v_ds_rn  < @v_ds_rn_max)

				---------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' 1.6 SCS 출하실적에 의한 최종 분배 결과 ' 
				---------------------------------------------------------------------------------------------------
				IF OBJECT_ID('TEMPDB..#SCS_SHIP_RESULT_ALLOC_RESULT') IS NOT NULL
					DROP TABLE #SCS_SHIP_RESULT_ALLOC_RESULT

				SELECT *
				 INTO #SCS_SHIP_RESULT_ALLOC_RESULT
				 FROM (
						SELECT SR.DIVISION_ID
							  ,SR.ITEM_ID
							  ,SR.TO_SITE
							  ,SR.SR_KEY
							  ,SR.DS_UNIQUE_SEQ
							  ,SR.ALLOC_INV_QTY
							  ,'A'					AS ALLOC_DIV 
						 FROM #SCS_SHIP_RESULT_ADJ_PRIORITY SR WITH(NOLOCK)
						WHERE 1=1
						  AND SR.ALLOC_INV_QTY != 0 
						UNION ALL
						SELECT SR.DIVISION_ID
							  ,SR.ITEM_ID
							  ,SR.REMAIN_ALLOC_SITE AS TO_SITE
							  ,SR.SR_KEY
							  ,SR.DS_UNIQUE_SEQ
							  ,SR.REMAIN_INV_QTY	AS ALLOC_INV_QTY 
							  ,'B'					AS ALLOC_DIV 
						 FROM #SCS_SHIP_RESULT_ADJ_PRIORITY SR WITH(NOLOCK)
						WHERE 1=1
						  AND REMAIN_INV_QTY != 0 
						) RESULT
				WHERE 1=1

				/*---------------------- End -- E20240111-001299 Ship req. 계산 시, 5552 재고 분배 로직 개선 : SCS 출하실적 기준 Sales Site 분배 added on 2024.01.10 -----------------*/
				/*---------------------- End -- E20240111-001299 Ship req. 계산 시, 5552 재고 분배 로직 개선 : SCS 출하실적 기준 Sales Site 분배 added on 2024.01.10 -----------------*/

               --------------------------------------------------------
               -- 2. FCST 대상 데이터 임시테이블로 생성
               /*                    
                    - Item별로 MKT FCST 가 있는 Sales Site
                    - dm_pln_mkt_fcst.yyyymmdd 는 @p_issue_date 부터 7일이후까지( @p_issue_date : 20181101 일때 20181101 ~ 20181107)
				      20200521 C20200506-000260 : fcst 구간을 7일에서 30일로 변경					  
                      20200626 5552 재고 차감 로직 : 앞에 있는 수요(60일 이내)부터 차감하는 Logic 적용
                    (참고) 우선순위 : 순위1) yyyymmdd + scm_mst_site_item.attribute7 (site 우선순위, 작은값이 우선순위임) -- 20200626 yyyymmdd 추가
                                      순위2) scm_mst_site.country ('KR'은 최하위, 다른국가는 동일순위임)
                                      순위3) fcst의 item별 qty합계 (큰수량이 우선순위임)
               */
               --------------------------------------------------------

               IF OBJECT_ID('tempdb..#scm_mst_site_priority') IS NOT NULL
               BEGIN 
                   DROP TABLE #scm_mst_site_priority          
               END           
           
               SELECT MIN( CONVERT(NUMERIC, c.yyyymmdd) + ISNULL(CONVERT(NUMERIC, b.attribute7), 99) ) AS priority --site_item 우선순위 -- 20200626 yyyymmdd 추가
	                , dbo.FN_ZERO_LPAD(ROW_NUMBER() OVER (PARTITION BY a.division_id ORDER BY c.yyyymmdd, IIF(a.country='KR', 9, 1), SUM(c.qty) DESC), 10) fcst_sum_qty_priority -- fcst  -- 20200626 yyyymmdd 추가
                    , SUM(c.qty) AS fcst_sum_qty
                    , a.division_id
                    , a.scm_site_id
                    , b.item_id
                    , c.yyyymmdd -- 20200626 yyyymmdd 추가
                    
               INTO   #scm_mst_site_priority
               FROM   scm_mst_site a with(nolock)

	                  INNER JOIN scm_mst_site_item b with(nolock)
                      ON  a.division_id = b.division_id
	                  AND a.scm_site_id = b.scm_site_id
                      AND a.site_type   = 'SALES'
                      --AND a.country     <> 'KR' --20181127 주석처리 ( country = 'KR'일때 국가별 우선순위 최하위 할당함)
                      AND a.valid_yn    = 'Y'
                      AND b.valid_yn    = 'Y'
                  
                      INNER JOIN dm_pln_mkt_fcst c with(nolock)
                      ON  a.division_id     = c.division_id
	                  AND a.scm_site_id     = c.scm_site_id
                      AND b.item_id         = c.item_id 
	                  
					  /* PJ20214907 */
					  --20221115 PJ20216994  MKT FCST 조건 변경
					  --AND c.measure         = IIF( ISNULL(a.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
	                  --AND c.measure         = IIF(ISNULL(a.operation_group, '') = 'W', 'AS_In_Req', IIF(ISNULL(a.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST'))
					  AND c.measure = CASE WHEN ISNULL(a.operation_group, '') = 'W' THEN 'AS_In_Req' WHEN a.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(c.attribute10, '') = '' THEN 'MKT_FCST' END
			  							

                      AND c.fcst_type      <> 'RMA'  --  반품예정수량은 제외
                      AND c.yyyymmdd       >= CONVERT(CHAR(8), @d_issue_date, 112) --실행일자(@d_issue_date) 부터 
					  -- 20200521 C20200506-000260 : fcst 구간을 7일에서 30일로 변경
					  -- 20200626 5552 재고 차감 로직 : 앞에 있는 수요(60일 이내)부터 차감하는 Logic 적용
                      --AND c.yyyymmdd       <  CONVERT(CHAR(8), DATEADD(DD, 7, @d_issue_date), 112)
                      AND c.yyyymmdd       <  CONVERT(CHAR(8), DATEADD(DD, 60, @d_issue_date), 112)
                      AND c.qty            > 0         

               --WHERE 1 = 1
               GROUP BY a.division_id, a.scm_site_id, b.item_id
                      , a.country, c.yyyymmdd    ; -- 20200626 yyyymmdd 추가
        
               --------------------------------------------------------
               -- 3. 5552재고데이터를 FCST존재하는item의 scm_site에 수량분배 처리
               --------------------------------------------------------
               --------------------------------------------------------
               -- 3-1. 5552재고데이터를 FCST존재하는 데이터 조인
               --------------------------------------------------------
               IF OBJECT_ID('tempdb..#scm_dnm_stock_temp2') IS NOT NULL
               BEGIN 
                   DROP TABLE #scm_dnm_stock_temp2          
               END
            
               SELECT  a.company_id
                     , a.division_id
                     , a.site_id
                     , a.plant_id
                     , a.factory_id
                     , a.storage_id
                     , a.cutoff_date
                     , a.seq

                     , a.item_id
                     , a.Inventory_total_qty
                 
                     , b.scm_site_id 
                     , b.site_priority 
                     , b.item_sum_qty_priority

                     , b.fcst_sum_qty
                     , b.item_sum_qty
                     , b.item_row_num
					 , b.yyyymmdd -- 20200626 yyyymmdd 추가
                 
                     , SUM(b.fcst_sum_qty) OVER (PARTITION BY b.division_id, b.item_id, b.yyyymmdd ORDER BY b.item_row_num) AS row_sum_fcst_qty -- 20200626 yyyymmdd 추가
                     , IIF(a.Inventory_total_qty > b.item_sum_qty2, a.Inventory_total_qty - b.item_sum_qty2, 0) AS rem_qty -- 20200626 yyyymmdd 추가
                     , ROW_NUMBER() OVER (ORDER BY a.division_id, a.item_id, b.site_priority, b.item_sum_qty_priority, b.scm_site_id) AS row_no
                 

                INTO   #scm_dnm_stock_temp2
                FROM   ( 
                         SELECT company_id, division_id, site_id, plant_id, factory_id, storage_id, cutoff_date, seq
                              , item_id
                              , origin_item_id
                              
                              , Inventory_total_qty
                         FROM (  
                                 SELECT company_id, division_id, site_id, plant_id, factory_id, storage_id, cutoff_date, seq
                                      , item_id
                                      , origin_item_id
                                      , qty2 

                                      , SUM(qty2) OVER (PARTITION BY company_id, division_id, site_id, plant_id, factory_id, storage_id, cutoff_date, item_id) AS Inventory_total_qty
                                      , ROW_NUMBER() OVER (PARTITION BY company_id, division_id, site_id, plant_id, factory_id, storage_id, cutoff_date, item_id ORDER BY IIF(origin_item_id = item_id, 0, 9), qty2 DESC, origin_item_id) AS row_num
                                 FROM   #scm_dnm_stock_temp ds   
								 WHERE 1=1
								   AND NOT EXISTS (SELECT *  -- E20240111-001299 SCS 출하 실적에 의해 분배된 재고 제외
													 FROM #SCS_SHIP_RESULT_ALLOC_RESULT SR 
													WHERE SR.DS_UNIQUE_SEQ = ds.unique_seq) 
                              ) x
                         WHERE x.row_num = 1
                        ) a
                        INNER JOIN ( SELECT division_id
                                        ,  item_id
                                        ,  scm_site_id
										,  yyyymmdd -- 20200626 yyyymmdd 추가        
                                
                                        ,  priority AS site_priority
                                        ,  fcst_sum_qty_priority AS item_sum_qty_priority                                
                                        ,  fcst_sum_qty 
                                
                                        , SUM(fcst_sum_qty) OVER (PARTITION BY division_id, item_id, yyyymmdd) AS item_sum_qty -- 20200626 yyyymmdd 추가                                
                                        , SUM(fcst_sum_qty) OVER (PARTITION BY division_id, item_id) AS item_sum_qty2 -- 20200626 yyyymmdd 추가                                
                                        , ROW_NUMBER() OVER (PARTITION BY division_id, item_id ORDER BY priority, fcst_sum_qty_priority) AS item_row_num 

                                        --, country --20181127 추가
                                    FROM   #scm_mst_site_priority
                                 ) b
                        ON   a.division_id = b.division_id 
                        AND  a.item_id     = b.item_id 
                --WHERE 1 = 1
                ;

               --------------------------------------------------------
               -- 3-2. 수량분배처리
               --------------------------------------------------------
                DECLARE @n_cnt INT  -- LOOP대상 테이블 전체 ROW 개수
                DECLARE @n_i   INT  -- LOOP 증감변수

                DECLARE @n_final_qty             NUMERIC(20,10)  --최종 할당 수량
                DECLARE @n_allocation_after_qty  NUMERIC(20,10)  --할당후 현재 수량 

                DECLARE @n_inventory_total_qty   NUMERIC(20,10)  --FCST의 item의 합계수량
                DECLARE @n_total_qty             NUMERIC(20,10)  --FCST의 item의 합계수량(item 별 순번1의 @n_inventory_total_qty)
                DECLARE @n_rem_qty               NUMERIC(20,10)  --FCST의 item의 대상 sales site에 모두 할당후 남은 수량

                DECLARE @n_fcst_qty              NUMERIC(20,10)  --FCST의 item, sales site의 수량
                DECLARE @n_item_row_num          INT             --FCST의 item 별 priority 순번
            
                SELECT @n_cnt = COUNT(*)
                FROM   #scm_dnm_stock_temp2
            
                IF @n_cnt > 0
                BEGIN
            
                    SET @n_i = 1 --증감변수 초기화            

                    WHILE(@n_i <= @n_cnt)
                    BEGIN
               
                        SELECT  @n_inventory_total_qty = inventory_total_qty
                              , @n_rem_qty             = rem_qty 
                              , @n_fcst_qty            = fcst_sum_qty
                              , @n_item_row_num        = item_row_num
                        FROM    #scm_dnm_stock_temp2
                        WHERE   row_no = @n_i
                
                        IF  @n_item_row_num = 1 
                        BEGIN
                
                            SET @n_total_qty = @n_inventory_total_qty
                            SET @n_allocation_after_qty = @n_total_qty - @n_fcst_qty  --할당후 남은수량 셋팅
                            SET @n_final_qty = (CASE WHEN @n_total_qty <= @n_fcst_qty THEN @n_total_qty
                                                     ELSE @n_fcst_qty
                                                END) + @n_rem_qty
                                       
                        END
                        ELSE
                        BEGIN
                            -- 할당후 수량 존재시에만 처리됨
                            IF @n_allocation_after_qty > 0 
                            BEGIN
                        
                                SET @n_final_qty = (CASE WHEN @n_allocation_after_qty <= @n_fcst_qty THEN @n_allocation_after_qty
                                                         ELSE @n_fcst_qty
                                                    END) 
                                SET @n_allocation_after_qty = @n_allocation_after_qty - @n_fcst_qty  --할당후 남은수량 셋팅

                            END
                            ELSE
                            BEGIN
                                SET @n_final_qty = 0
                            END
							                
                        END    

                        ---------------------------------------------------
                        -- 수량할당 최종데이터 생성
                        ---------------------------------------------------
                        IF @n_i = 1
                        BEGIN
                    
                            IF OBJECT_ID('tempdb..#scm_dnm_stock_final') IS NOT NULL
                            BEGIN 
                                 DROP TABLE #scm_dnm_stock_final 
                            END 

                            SELECT company_id
                                 , division_id
                                 , site_id
                                 , plant_id
                                 , factory_id
                                 , storage_id
                                 , cutoff_date
                                 , seq
								 , yyyymmdd -- 20200626 yyyymmdd 추가
                                ,  item_id
                                ,  inventory_total_qty
                                ,  scm_site_id
                                ,  site_priority
                                ,  item_sum_qty_priority
                                ,  fcst_sum_qty
                                ,  item_sum_qty
                                ,  item_row_num
                                ,  row_sum_fcst_qty
                                ,  rem_qty 
                                ,  row_no 
                                ,  @n_final_qty AS final_allocation_qty
                            INTO   #scm_dnm_stock_final
                            FROM   #scm_dnm_stock_temp2
                            WHERE  row_no = @n_i 
                        END --IF @n_i = 1문 종료

                        ELSE
                        BEGIN
                                   INSERT INTO #scm_dnm_stock_final
                                   (   company_id
                                     , division_id
                                     , site_id
                                     , plant_id
                                     , factory_id
                                     , storage_id
                                     , cutoff_date
                                     , seq
								     , yyyymmdd -- 20200626 yyyymmdd 추가
                                    ,  item_id
                                    ,  inventory_total_qty
                                    ,  scm_site_id
                                    ,  site_priority
                                    ,  item_sum_qty_priority
                                    ,  fcst_sum_qty
                                    ,  item_sum_qty
                                    ,  item_row_num
                                    ,  row_sum_fcst_qty
                                    ,  rem_qty 
                                    ,  row_no 
                                    ,  final_allocation_qty
                                  ) 
                                  SELECT  company_id
                                       ,  division_id
                                       ,  site_id
                                       ,  plant_id
                                       ,  factory_id
                                       ,  storage_id
                                       ,  cutoff_date
                                       ,  seq
								       ,  yyyymmdd -- 20200626 yyyymmdd 추가
                                       ,  item_id
                                       ,  inventory_total_qty
                                       ,  scm_site_id
                                       ,  site_priority
                                       ,  item_sum_qty_priority
                                       ,  fcst_sum_qty
                                       ,  item_sum_qty
                                       ,  item_row_num
                                       ,  row_sum_fcst_qty
                                       ,  rem_qty 
                                       ,  row_no 
                                       ,  @n_final_qty AS final_allocation_qty
                                  FROM   #scm_dnm_stock_temp2
                                  WHERE  row_no = @n_i  
                                  ;
                        END --ELSE문 종료

                        SET @n_i = @n_i + 1

                    END --WHILE  종료
               END --IF @n_cnt > 0문 종료

               --------------------------------------------------------
               -- 3-3. 최종 데이터 INSERT
               --------------------------------------------------------
                DECLARE @n_select_cnt INT=0;
            
                IF OBJECT_ID('tempdb..#scm_dnm_stock_final') IS NOT NULL
                BEGIN 
                    SELECT @n_select_cnt = COUNT(*) FROM #scm_dnm_stock_final         
                END   

                SELECT @n_select_cnt = @n_select_cnt + COUNT(*) FROM #SCS_SHIP_RESULT_ALLOC_RESULT   -- E20240111-001299 SCS 출하실적 기준 분배      

                IF @n_select_cnt > 0 -- INSERT 데이터 존재시에만 처리
                BEGIN
                    --------------------------------------------------------
                    --3-3-1 DELETE (같은일자에 실행시 이전실행데이터 삭제처리)
                    --------------------------------------------------------
                    DELETE FROM scm_dnm_stock_pur
                    WHERE  insert_time = @d_issue_date
            
					IF OBJECT_ID('tempdb..#scm_dnm_stock_final') IS NOT NULL
					BEGIN 
						--------------------------------------------------------
						--3-3-2-1 INSERT
						--------------------------------------------------------
						INSERT INTO scm_dnm_stock_pur
						(   company_id
							,  division_id
							,  scm_site_id
							,  site_id
							,  plant_id
							,  factory_id
							,  storage_id
							,  cutoff_date
							,  seq
							,  stock_type
							,  item_id
							,  lane
							,  production_type
							,  available_date
							,  remain_lead_time
							,  holding_date
							,  qty
							,  qty_uom
							,  stock_status
							,  operation_id
							,  line_id
							,  outsourcing_flag
							,  outsourcing_factory
							,  description
							,  fp_apply_operation_id
							,  fp_apply_item_id
							,  fp_apply_wipqty
							,  wiphold_yn
							,  wip_type_code
							,  qty2
							,  modify_fp_apply_wipqty
							,  modify_description
							,  cal_qty
							,  formation_rework_type
							,  insert_id
							,  insert_time
							,  update_id
							,  update_time
							,  location
							,  release_due_date
							,  ship_available_date
							,  long_term_qty
							,  moving_qty
							,  capa_grd_code
							,  vltg_grd_code
							,  rsst_grd_code
							,  defect_qty

						)
						SELECT b.company_id
							,  b.division_id

							,  a.scm_site_id AS scm_site_id
                
							,  b.site_id
							,  b.plant_id
							,  b.factory_id
							,  b.storage_id
							,  b.cutoff_date
							,  b.seq
							,  MIN(b.stock_type)
							,  MIN(b.item_id)
							,  MIN(b.lane)
							,  MIN(b.production_type)
							,  MIN(b.available_date)
							,  MIN(b.remain_lead_time)
							,  MIN(b.holding_date)

							,  SUM(a.final_allocation_qty) AS qty

							,  MIN(b.qty_uom)
							,  MIN(b.stock_status)
							,  MIN(b.operation_id)
							,  MIN(b.line_id)
							,  MIN(b.outsourcing_flag)
							,  MIN(b.outsourcing_factory)
							,  MIN(b.description)
							,  MIN(b.fp_apply_operation_id)
							,  MIN(b.fp_apply_item_id)
							,  MIN(b.fp_apply_wipqty)
							,  MIN(b.wiphold_yn)
							,  MIN(b.wip_type_code)

							,  SUM(a.final_allocation_qty) AS qty2

							,  MIN(b.modify_fp_apply_wipqty)
							,  MIN(b.modify_description)
							,  MIN(b.cal_qty)
							,  MIN(b.formation_rework_type)
                
							,  'scm_batch'   AS insert_id
							,  @d_issue_date AS insert_time
							,  'scm_batch'   AS update_id
							,  GETDATE()     AS update_time
                
							,  MIN(b.location)
							,  MIN(b.release_due_date)
							,  MIN(b.ship_available_date)
							,  MIN(b.long_term_qty)
							,  MIN(b.moving_qty)
							,  MIN(b.capa_grd_code)
							,  MIN(b.vltg_grd_code)
							,  MIN(b.rsst_grd_code)
							,  MIN(b.defect_qty)
					   FROM    ( SELECT *
								 FROM   #scm_dnm_stock_final 
								 WHERE  final_allocation_qty > 0
							   ) a
							   INNER JOIN #scm_dnm_stock_temp b  --최초 5552재고 대상 데이터 --COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, STORAGE_ID, CUTOFF_DATE, SEQ
							   ON   a.company_id = b.company_id
							   AND  a.division_id  =  b.division_id
							   AND  a.site_id      = b.site_id
							   AND  a.plant_id     = b.plant_id
							   AND  a.factory_id   = b.factory_id
							   AND  a.storage_id   = b.storage_id
							   AND  a.cutoff_date  = b.cutoff_date
							   AND  a.seq          = b.seq 
						--WHERE 1 = 1
						GROUP BY b.company_id, b.division_id, a.scm_site_id, b.site_id, b.plant_id, b.factory_id, b.storage_id, b.cutoff_date, b.seq
					   ;
				   END

                    ---------------------------------------------------------------------------------
                    --3-3-2-2 E20240111-001299 SCS 출하실적에 의한 분배 결과 Insert 
                    ---------------------------------------------------------------------------------
					---------------------------------------------------------------------------------------------------
					print  convert(varchar(30), getdate(), 121) + N' ### SCS 출하실적에 의한 최종 분배 결과 INSERT' 
					---------------------------------------------------------------------------------------------------
                    INSERT INTO scm_dnm_stock_pur
                    (   company_id
                        ,  division_id
                        ,  scm_site_id
                        ,  site_id
                        ,  plant_id
                        ,  factory_id
                        ,  storage_id
                        ,  cutoff_date
                        ,  seq
                        ,  stock_type
                        ,  item_id
                        ,  lane
                        ,  production_type
                        ,  available_date
                        ,  remain_lead_time
                        ,  holding_date
                        ,  qty
                        ,  qty_uom
                        ,  stock_status
                        ,  operation_id
                        ,  line_id
                        ,  outsourcing_flag
                        ,  outsourcing_factory
                        ,  description
                        ,  fp_apply_operation_id
                        ,  fp_apply_item_id
                        ,  fp_apply_wipqty
                        ,  wiphold_yn
                        ,  wip_type_code
                        ,  qty2
                        ,  modify_fp_apply_wipqty
                        ,  modify_description
                        ,  cal_qty
                        ,  formation_rework_type
                        ,  insert_id
                        ,  insert_time
                        ,  update_id
                        ,  update_time
                        ,  location
                        ,  release_due_date
                        ,  ship_available_date
                        ,  long_term_qty
                        ,  moving_qty
                        ,  capa_grd_code
                        ,  vltg_grd_code
                        ,  rsst_grd_code
                        ,  defect_qty
                    )
					 SELECT b.company_id
						 ,  b.division_id
						 ,  a.TO_SITE AS scm_site_id
						 ,  b.site_id
						 ,  b.plant_id
						 ,  b.factory_id
						 ,  b.storage_id
						 ,  b.cutoff_date
						 ,  b.seq
						 ,  MIN(b.stock_type)				as stock_type
						 ,  MIN(b.item_id)					as item_id
						 ,  MIN(b.lane)						as lane
						 ,  MIN(b.production_type)			as production_type
						 ,  MIN(b.available_date)			as available_date
						 ,  MIN(b.remain_lead_time)			as remain_lead_time
						 ,  MIN(b.holding_date)				as holding_date
						 ,  SUM(a.ALLOC_INV_QTY)			as qty
						 ,  MIN(b.qty_uom)					as qty_uom
						 ,  MIN(b.stock_status)				as stock_status
						 ,  MIN(b.operation_id)				as operation_id
						 ,  MIN(b.line_id)					as line_id
						 ,  MIN(b.outsourcing_flag)			as outsourcing_flag
						 ,  MIN(b.outsourcing_factory)		as outsourcing_factory
						 ,  MIN(b.description)				as description
						 ,  MIN(b.fp_apply_operation_id)	as fp_apply_operation_id
						 ,  MIN(b.fp_apply_item_id)			as fp_apply_item_id
						 ,  MIN(b.fp_apply_wipqty)			as fp_apply_wipqty
						 ,  MIN(b.wiphold_yn)				as wiphold_yn
						 ,  MIN(b.wip_type_code)			as wip_type_code
						 ,  SUM(a.ALLOC_INV_QTY)			as qty2
						 ,  MIN(b.modify_fp_apply_wipqty)	as modify_fp_apply_wipqty
						 ,  MIN(b.modify_description)		as modify_description
						 ,  MIN(b.cal_qty)					as cal_qty
						 ,  MIN(b.formation_rework_type)	as formation_rework_type
						 ,  'scm_batch-scs_ship_result'		as insert_id
						 ,  @d_issue_date					as insert_time
						 ,  'scm_batch-scs_ship_result'		as update_id
						 ,  GETDATE()						as update_time
						 ,  MIN(b.location)					as location
						 ,  MIN(b.release_due_date)			as release_due_date
						 ,  MIN(b.ship_available_date)		as ship_available_date
						 ,  MIN(b.long_term_qty)			as long_term_qty
						 ,  MIN(b.moving_qty)				as moving_qty
						 ,  MIN(b.capa_grd_code)			as capa_grd_code
						 ,  MIN(b.vltg_grd_code)			as vltg_grd_code
						 ,  MIN(b.rsst_grd_code)			as rsst_grd_code
						 ,  MIN(b.defect_qty)				as defect_qty
					 FROM #SCS_SHIP_RESULT_ALLOC_RESULT a WITH(NOLOCK)
						  INNER JOIN #scm_dnm_stock_temp b 
								  ON b.unique_seq = a.ds_unique_seq 
					WHERE 1=1
					GROUP BY b.company_id
						   , b.division_id
						   , a.to_site
						   , b.site_id
						   , b.plant_id
						   , b.factory_id
						   , b.storage_id
						   , b.cutoff_date
						   , b.seq

                    ------------------------------------------------------------------------------------------------------------------
                    -- 3-3-2-3 LGES2024-002655 SCP 개선과제 이행 
					-- 2024.11.19 소형사업부 전주 출하건 가상 창고 이전 전기 자동처리 대상 Insert  
                    ------------------------------------------------------------------------------------------------------------------
                    INSERT INTO scm_dnm_stock_pur
                    (	   company_id
                        ,  division_id
                        ,  scm_site_id
                        ,  site_id
                        ,  plant_id
                        ,  factory_id
                        ,  storage_id
                        ,  cutoff_date
                        ,  seq
                        ,  stock_type
                        ,  item_id
                        ,  lane
                        ,  production_type
                        ,  available_date
                        ,  remain_lead_time
                        ,  holding_date
                        ,  qty
                        ,  qty_uom
                        ,  stock_status
                        ,  operation_id
                        ,  line_id
                        ,  outsourcing_flag
                        ,  outsourcing_factory
                        ,  description
                        ,  fp_apply_operation_id
                        ,  fp_apply_item_id
                        ,  fp_apply_wipqty
                        ,  wiphold_yn
                        ,  wip_type_code
                        ,  qty2
                        ,  modify_fp_apply_wipqty
                        ,  modify_description
                        ,  cal_qty
                        ,  formation_rework_type
                        ,  insert_id
                        ,  insert_time
                        ,  update_id
                        ,  update_time
                        ,  location
                        ,  release_due_date
                        ,  ship_available_date
                        ,  long_term_qty
                        ,  moving_qty
                        ,  capa_grd_code
                        ,  vltg_grd_code
                        ,  rsst_grd_code
                        ,  defect_qty
                    )
					SELECT company_id
                        ,  division_id
                        ,  scm_site_id
                        ,  '*'				AS site_id
                        ,  '*'				AS plant_id
                        ,  '*'				AS factory_id
                        ,  '*'				AS storage_id
                        ,  @d_issue_date	AS  cutoff_date
                        ,  9999999000+SEQ	AS seq		--- not null
                        ,  'INVENTORY'		AS stock_type
                        ,  item_id
                        ,  NULL				AS lane
                        ,  NULL				AS production_type
                        ,  @d_issue_date	AS available_date
                        ,  NULL				AS remain_lead_time
                        ,  NULL				AS holding_date
                        ,  ship_qty			AS qty		-- not null 
                        ,  'EA'				AS qty_uom
                        ,  NULL				AS stock_status
                        ,  NULL				AS operation_id
                        ,  NULL				AS line_id
                        ,  'N'				AS outsourcing_flag
                        ,  NULL				AS outsourcing_factory
                        ,  NULL				AS description
                        ,  NULL				AS fp_apply_operation_id
                        ,  NULL				AS fp_apply_item_id
                        ,  NULL				AS fp_apply_wipqty
                        ,  'N'				AS wiphold_yn
                        ,  NULL				AS wip_type_code
                        ,  ship_qty			AS qty2
                        ,  NULL				AS modify_fp_apply_wipqty
                        ,  NULL				AS modify_description
                        ,  NULL				AS cal_qty
                        ,  NULL				AS formation_rework_type
						 ,  'scm_batch-scs_ship_inventory'	AS insert_id
						 ,  @d_issue_date					AS insert_time
						 ,  'scm_batch-scs_ship_inventory'	AS update_id
						 ,  GETDATE()						AS update_time
                        ,  NULL				AS location
                        ,  NULL				AS release_due_date
                        ,  NULL				AS ship_available_date
                        ,  NULL				AS long_term_qty
                        ,  NULL				AS moving_qty
                        ,  NULL				AS capa_grd_code
                        ,  NULL				AS vltg_grd_code
                        ,  NULL				AS rsst_grd_code
                        ,  NULL				AS defect_qty
					 FROM #UPLOAD_STOCK_TO_CREATE


                END --IF @n_select_cnt > 0 문 종료
                
                ---------------------------------------------------
                -- HISTORY LOG		
                ---------------------------------------------------
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO scm_dnm_stock_pur ';
                --SET @v_description = N'issue_date : ' + CONVERT(CHAR(8), @d_issue_date, 112) + ' / Cutoff_date : ' + @p_cutoff_date + N' / 5552 재고 데이터';
                SET @v_description = N'issue_date : ' + CONVERT(CHAR(8), @d_issue_date, 112) + N' / 5552 재고 데이터';
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                SET @d_issue_date = DATEADD(dd, 1, @d_issue_date) -- 1일 증가

            END --WHILE문 종료 
               
               ------------------------------------------------------------
               -- 임시테이블 삭제
               ------------------------------------------------------------
               IF OBJECT_ID('tempdb..#scm_dnm_stock_temp') IS NOT NULL
               BEGIN 
                   DROP TABLE  #scm_dnm_stock_temp          
               END     
       
               IF OBJECT_ID('tempdb..#scm_mst_site_priority') IS NOT NULL
               BEGIN 
                   DROP TABLE #scm_mst_site_priority          
               END      
              
	           IF OBJECT_ID('tempdb..#scm_dnm_stock_temp2') IS NOT NULL
               BEGIN 
                   DROP TABLE #scm_dnm_stock_temp2          
               END
	    
			   IF OBJECT_ID('TEMPDB..#BOD_LT') IS NOT NULL
		  	   		DROP TABLE #BOD_LT
			   IF OBJECT_ID('TEMPDB..#SCS_SHIP_RESULT_BEFORE') IS NOT NULL
			   		DROP TABLE #SCS_SHIP_RESULT_BEFORE
			   IF OBJECT_ID('TEMPDB..#SCS_SHIP_RESULT') IS NOT NULL
			   		DROP TABLE #SCS_SHIP_RESULT
			   IF OBJECT_ID('TEMPDB..#UPLOAD_DNM_STOCK') IS NOT NULL
					DROP TABLE #UPLOAD_DNM_STOCK
			   IF OBJECT_ID('TEMPDB..#SCS_SHIP_RESULT_ADJ') IS NOT NULL
			   		DROP TABLE #SCS_SHIP_RESULT_ADJ
			   IF OBJECT_ID('TEMPDB..#SCS_SHIP_RESULT_ADJ_PRIORITY') IS NOT NULL
			   		DROP TABLE #SCS_SHIP_RESULT_ADJ_PRIORITY
			   IF OBJECT_ID('TEMPDB..#SCS_SHIP_RESULT_ALLOC_RESULT') IS NOT NULL
			   		DROP TABLE #SCS_SHIP_RESULT_ALLOC_RESULT
 			   IF OBJECT_ID('TEMPDB..#UPLOAD_STOCK_TO_CREATE') IS NOT NULL	-- 2024.11.19 
					DROP TABLE #UPLOAD_STOCK_TO_CREATE

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
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
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
