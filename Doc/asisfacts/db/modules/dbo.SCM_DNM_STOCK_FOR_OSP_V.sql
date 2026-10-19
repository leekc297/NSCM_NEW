CREATE VIEW [dbo].[SCM_DNM_STOCK_FOR_OSP_V] AS   

WITH SCP_EXC_ITEM_ASSY_MAP AS (
	SELECT COMPANY_ID
	      ,DIVISION_ID
		  ,SITE_ID
		  ,PLANT_ID
		  ,SCP_EXC_ITEM_ID
		  ,CELL_ASSY_ITEM_ID
	 FROM DBO.FN_GET_SCP_EXC_ITEM_ASSY_MAP (NULL)
	WHERE 1=1 
)
SELECT   
        -- 20200406 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : Hold 재고
        --   MES, QMS Hold = 'Y' 인데, MES/QMS Hold 예상해제일이 없는 대상은 가용 재고에서 제외 함 : 내부에서 available_date 설정함
		-- 20200521 C20200520-000161 : available_date 상관없이 Site 처리함
		 STOCK.scm_site_id             AS scm_site_id
		,CASE WHEN ISNULL(STOCK.company_id, '') = '' THEN '*' ELSE STOCK.company_id END AS company_id
		,STOCK.division_id
		,CASE WHEN ISNULL(STOCK.site_id, '')    = '' THEN '*' ELSE STOCK.site_id    END AS site_id
		,CASE WHEN ISNULL(STOCK.plant_id, '')   = '' THEN '*' ELSE STOCK.plant_id   END AS plant_id
		,CASE WHEN ISNULL(STOCK.factory_id, '') = '' THEN '*' ELSE STOCK.factory_id END AS factory_id
		,CASE WHEN ISNULL(STOCK.storage_id, '') = '' THEN '*' ELSE STOCK.storage_id END AS storage_id
		,DATEADD(DAY,-1,STOCK.cutoff_date) cutoff_date -- STOCK 내에서 전부 BOH 일자 기준으로 처리되어서 EOH 기준일자로 변경함
		,STOCK.seq
		,STOCK.stock_type

		-- 20181130 소형 대표 ITEM_ID 처리 조정
		-- PJ20257329 2025.09.01 변경전,STOCK.item_id
		,ISNULL(EX.CELL_ASSY_ITEM_ID, STOCK.item_id)	AS ITEM_ID -- PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 조회
		,STOCK.origin_item_id 
		
        -- 2018.03.08 우선순위 수정
		,ISNULL(STOCK.scm_qty, 0) + ISNULL(STOCK.moving_qty, 0) + ISNULL(STOCK.defect_qty, 0) AS scm_qty
		-- 2019.11.05 출하가능재고에서 moving_qty 제외 
		,ISNULL(STOCK.scm_qty, 0) AS ssp_qty 
		,STOCK.lane
		,STOCK.production_type
		
		-- 20200521 C20200520-000161 Hold인데 해제예상일이 없는 경우 Defalut 설정함
        --   자동차/ESS : M+24 에 가용재고로 인식 -> Plan 대상 구간 이후 일자로 처리 : Plan에는 사용 안 하나, Simulator의 BOH에는 표시
        --   소형 : M+6 에 가용재고로 인식 :현재 (당)월 + 6개월 에 해당하는 1일
        --          ex) 20200511 주차 : 11월 1일 / 20200525 주차 : 11월 1일 / 20200601 주차 : 12월 1일
		--,STOCK.available_date		
       ,CASE WHEN ISNULL(STOCK.wiphold_yn, 'N') = 'Y' AND ISNULL(STOCK.available_date, '') = '' AND  STOCK.division_id = '40'
                  --THEN DATEADD(MM, 6,  STOCK.cutoff_date-DAY(STOCK.cutoff_date)+1) 
                  THEN DATEADD(MM, 6, CONVERT(DATETIME, CONVERT(CHAR(6), STOCK.cutoff_date, 112)+'01')) 
             -- HM JV WHEN ISNULL(STOCK.wiphold_yn, 'N') = 'Y' AND ISNULL(STOCK.available_date, '') = '' AND  STOCK.division_id IN ('81', '82', '81_UC') -- 20220425 PJ20216891 : GM JV 가상 Division 추가
             WHEN ISNULL(STOCK.wiphold_yn, 'N') = 'Y' AND ISNULL(STOCK.available_date, '') = '' AND  DM.ATTRIBUTE3 IN ('81', '82')  -- HM JV 가상 사업부 추가 대응
                  --THEN DATEADD(MM, 24,  STOCK.cutoff_date-DAY(STOCK.cutoff_date)+1) 
                  THEN DATEADD(MM, 24, CONVERT(DATETIME, CONVERT(CHAR(6), STOCK.cutoff_date, 112)+'01')) 
             ELSE STOCK.available_date
        END available_date  

		,STOCK.remain_lead_time
		,STOCK.holding_date      -- MES Hold 작업일
		,STOCK.qty
		,STOCK.qty_uom
		,STOCK.stock_status
		,STOCK.operation_id
		,STOCK.line_id
		,STOCK.outsourcing_flag
		,STOCK.outsourcing_factory
		,STOCK.description
		,STOCK.fp_apply_operation_id
		,STOCK.fp_apply_item_id
		,STOCK.fp_apply_wipqty
		--,[dbo].[FN_SCM_SYS_NVL](STOCK.wiphold_yn, 'N') wiphold_yn -- 20180511  Kim Jihye
		--,[dbo].[FN_SCM_SYS_NVL](STOCK.qms_hold_yn, 'N') qms_hold_yn -- 20191030  추가 QMS Hold 여부 관리
        ,CASE WHEN ISNULL(STOCK.wiphold_yn, '') = '' THEN 'N'
              ELSE STOCK.wiphold_yn
         END wiphold_yn 
        ,CASE WHEN ISNULL(STOCK.qms_hold_yn, '') = '' THEN 'N'
              ELSE STOCK.qms_hold_yn
         END qms_hold_yn 
		,STOCK.wip_type_code
		,STOCK.qty2
		,STOCK.modify_fp_apply_wipqty
		,STOCK.modify_description
		,STOCK.cal_qty
		,STOCK.formation_rework_type
		,STOCK.insert_id
		,STOCK.insert_time
		,STOCK.update_id
		,STOCK.update_time
		,STOCK.location
		,STOCK.moving_qty    -- 2018.08.07 이동중 재고(moving_qty) 추가
		,STOCK.capa_grd_code -- 2018.10.23 등급 관련 컬럼 추가
		,STOCK.vltg_grd_code -- 2018.10.23 등급 관련 컬럼 추가
		,STOCK.rsst_grd_code -- 2018.10.23 등급 관련 컬럼 추가
		,STOCK.defect_qty    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가 -- 20221222 defect_qty = defect_qty + restrict_qty
		,STOCK.unhold_exp_date -- 20191120 추가 MES Hold 해제 예정일
		,STOCK.mes_map_sloc    -- 20191120 추가 MES에 연계된 ERP 창고
		
		,STOCK.mes_hold_yn         -- 20200413 MES 내부적으로 Hold 여부 관리
		,STOCK.mes_unhold_date     -- 20200413 MES hold 실제 해제일
		,STOCK.qms_hold_date       -- 20200413 QMS Hold 일
		,STOCK.qms_unhold_exp_date -- 20200413 QMS Hold 해제 예정일
		,STOCK.qms_unhold_date     -- 20200413 QMS Hold 실제 해제일
		,STOCK.operation_id_org    -- 20210423 C20210422-000470 추가
		,STOCK.location_code       -- 20210618 C20210617-000105 : location_code 정보 추가
        -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		,STOCK.mes_item_id
		,STOCK.mes_operation_id
		,STOCK.from_sloc_id
		,STOCK.customer_id
		,STOCK.special_stock_indicator
		
FROM   ( ------------------------------
SELECT SO.SCM_SITE_ID
	,SO.QTY SCM_QTY
	,S.COMPANY_ID
	,SO.DIVISION_ID
	,S.SITE_ID
	,S.PLANT_ID
	,S.PLANT_ID FACTORY_ID
	-- 20240610 PJ20244573 STOCK OSP - 원산지 구분자 추가
	,SO.ATTRIBUTE1 STORAGE_ID
	--,S.PLANT_ID STORAGE_ID
	,DATEADD(DAY, 1, CONVERT(DATE, SO.YYYYMMDD)) CUTOFF_DATE -- OSP는 YYYYMMDD가 EOH 기준이나 VIEW 의 상단에서 -1일 처리하기 때문에 먼저 +1 함
	,NULL SEQ
	,'UPLOAD' STOCK_TYPE
	-- 20181130 소형 대표 ITEM_ID 처리 조정
	,[DBO].[FN_SCM_SYS_NVL](FI.PACKER_PLAN_ITEM_ID, SO.ITEM_ID) ITEM_ID --2018.06.29
	,SO.ITEM_ID ORIGIN_ITEM_ID --2018.06.29
	,NULL LANE
	,NULL PRODUCTION_TYPE
	,DATEADD(DAY, 1, CONVERT(DATE, SO.YYYYMMDD)) AVAILABLE_DATE -- CUTOFF_DATE 와 동일하게 처리
	,NULL REMAIN_LEAD_TIME
	,NULL HOLDING_DATE
	,NULL QTY
	,'EA' QTY_UOM
	,NULL STOCK_STATUS
	,NULL OPERATION_ID
	,NULL OPERATION_ID_ORG  -- 20210423 C20210422-000470 추가
	,NULL LINE_ID
	,'N' OUTSOURCING_FLAG
	,NULL OUTSOURCING_FACTORY
	,NULL DESCRIPTION
	,NULL FP_APPLY_OPERATION_ID
	,NULL FP_APPLY_ITEM_ID
	,NULL FP_APPLY_WIPQTY
	,'N' WIPHOLD_YN
	,'N' QMS_HOLD_YN   -- 20191030  추가
	,NULL WIP_TYPE_CODE
	,NULL QTY2
	,NULL MODIFY_FP_APPLY_WIPQTY
	,NULL MODIFY_DESCRIPTION
	,NULL CAL_QTY
	,NULL FORMATION_REWORK_TYPE
	,SO.CREATED_BY        INSERT_ID
	,SO.CREATION_DATE     INSERT_TIME
	,SO.LAST_UPDATED_BY   UPDATE_ID
	,SO.LAST_UPDATE_DATE  UPDATE_TIME
	,NULL LOCATION
	,NULL MOVING_QTY    -- 2018.08.07 이동중 재고(MOVING_QTY) 추가
	,NULL CAPA_GRD_CODE -- 2018.10.23 등급 관련 컬럼 추가
	,NULL VLTG_GRD_CODE -- 2018.10.23 등급 관련 컬럼 추가
	,NULL RSST_GRD_CODE -- 2018.10.23 등급 관련 컬럼 추가
	,NULL DEFECT_QTY    -- 2018.10.23 ERP 보류재고 수량 (DEFECT_QTY) 추가
	,NULL UNHOLD_EXP_DATE -- 20191120 추가
	,NULL MES_MAP_SLOC    -- 20191120 추가
	,'N'  MES_HOLD_YN         -- 20200413 MES 내부적으로 HOLD 여부 관리
	,NULL MES_UNHOLD_DATE     -- 20200413 MES HOLD 실제 해제일
	,NULL QMS_HOLD_DATE       -- 20200413 QMS HOLD 일
	,NULL QMS_UNHOLD_EXP_DATE -- 20200413 QMS HOLD 해제 예정일
	,NULL QMS_UNHOLD_DATE     -- 20200413 QMS HOLD 실제 해제일
	,NULL AS LOCATION_CODE   -- 20210618 C20210617-000105 : LOCATION_CODE 정보 추가 : OSP 이므로 NULL 처리
    -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
	,NULL MES_ITEM_ID
	,NULL MES_OPERATION_ID
	,NULL FROM_SLOC_ID
	,NULL CUSTOMER_ID
	,NULL SPECIAL_STOCK_INDICATOR
FROM   SCM_DNM_STOCK_OSP SO WITH(NOLOCK)

-- 20181130 소형 대표 ITEM_ID 처리 조정
LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) --2018.06.29
ON   SO.DIVISION_ID = FI.DIVISION_ID
AND  SO.ITEM_ID     = FI.ITEM_ID 

-- SITE
INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
ON   SO.DIVISION_ID = S.DIVISION_ID
AND  SO.SCM_SITE_ID = S.SCM_SITE_ID 
AND  S.VALID_YN     = 'Y'

-- 20200810 [PACKER VISIVILITY] 외주용 재고 조정
--  PACKER VISIVILITY 대상 SITE 제외
WHERE   1=1
AND    NOT EXISTS (
                    SELECT *
                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD WITH(NOLOCK) -- 2018. 04.10  KIM JIHYE
                    WHERE  MD.LOOKUP_TYPE = 'PACKER_SCS'
                    AND    MD.VALID_YN    = 'Y'  
                    AND    MD.SEGMENT1    = SO.DIVISION_ID
                    AND    MD.SEGMENT2    = SO.SCM_SITE_ID
                )
) STOCK
	-- HM JV 가상 사업부 추가 대응
	INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
			ON DM.DIVISION_ID = STOCK.DIVISION_ID
		   AND DM.VALID_YN    = 'Y'

	-- Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환
	LEFT  JOIN  SCP_EXC_ITEM_ASSY_MAP EX
			ON EX.COMPANY_ID		= STOCK.COMPANY_ID
		   AND EX.DIVISION_ID		= STOCK.DIVISION_ID
		   AND EX.SITE_ID			= STOCK.SITE_ID
		   AND EX.PLANT_ID			= STOCK.PLANT_ID
		   AND EX.SCP_EXC_ITEM_ID	= STOCK.ITEM_ID
	-- End   : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환

WHERE   1=1
------------------------------
-- 20200323  [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
-- Lookup('VMI_LT_SITE') 에 등록된 Site는'VMI_LT' 재고 외 다른 재고 사용 안 함
------------------------------
AND    (STOCK.stock_type = 'VMI_LT'
OR      NOT EXISTS (
                    SELECT *
                    FROM   scm_adm_lookup_master_detail md WITH(NOLOCK) -- 2018. 04.10  Kim Jihye
                    WHERE  md.lookup_type = 'VMI_LT_SITE'
                    AND    md.valid_yn    = 'Y'  
                    AND    md.segment1    = STOCK.division_id
                    AND    md.segment2    = ISNULL(STOCK.scm_site_id,'')
                   )
       )