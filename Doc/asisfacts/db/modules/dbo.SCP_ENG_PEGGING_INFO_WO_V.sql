



CREATE VIEW [dbo].[SCP_ENG_PEGGING_INFO_WO_V] AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCP_ENG_PEGGING_INFO_WO_V
  * DESCRIPTION   : WORK ORDER DEMAND ID별 SUPPLY QTY 조회용
  *                 
  *                 
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-03-23   YYDOK        INITIAL
  * 2018-04-04   YYDOK        ENGINE OUTPUT변경에 따라 FROM ITEM기준으로
  *                           WO의 DEMAND FEEDING수량이 PEGGING INFO에 나오는 것으로 변경됨
  * 2018-04-17   LTW          ENGINE OUTPUT변경에 따라 scp_eng_unpegging_info_o_sn 추가 처리
  * 2018-05-01   yydok        LPST add
  * 2018-05-16   LTW          엔진 DEMAND ID 추가
  * 2018.06.08   LTW          PEGGING 성능개선을 위한 수정
                              scp_eng_pegging_info_o_sn->scp_eng_pegging_info_o_temp_sn
                              scp_eng_unpegging_info_o_sn->scp_eng_unpegging_info_o_temp_sn
                              scp_eng_work_order_o_sn->scp_eng_work_order_o_temp_sn
  * 2018.07.09   LTW          전극 SCP 작업(ORIGIN_FROM_DIVISION_ID ,ORIGIN_TO_DIVISION_ID ,OPERATION_GROUP ,ELECTRODE_TYPE) 추가
  * 2018.09.06   LTW          소형 SCP 작업(FROM_OSP_YN ,TO_OSP_YN ,FROM_TCO_CELL_YN ,TO_TCO_CELL_YN) 추가
  * 2020.10.28   KSW          PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응
  * 2022-03-23   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
  * 2022.07.01   sclee.lee    PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
  * 2023.04.04   HRK		  PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 ****************************************************************************/
SELECT sub.plan_id
      ,sub.modeling_id
      ,sub.seq 
      ,sub.plan_name
      ,sub.master_id
      ,sub.out_version_id
      ,sub.plan_type
      ,sub.division_id
           
      ,sub.demand_priority
      ,sub.due_date
      ,sub.delivery_order_id
      ,sub.work_order_id
      ,sub.start_dttm
      ,sub.end_dttm
      ,sub.site_id          
      ,sub.item_id          
      ,sub.demand_id                                          --ORG DEMAND ID
      ,sub.eng_demand_id                                      --엔진 DEMAND ID
      ,sub.supply_qty
      ,sub.lpst

      ,sub.operation_group                                    --전극/소형 작업 추가
      ,sub.electrode_type                                     --전극/소형 작업 추가
      ,sub.origin_division_id     AS origin_from_division_id  --전극/소형 작업 추가
      ,sub.origin_to_division_id                              --전극/소형 작업 추가

      ,SUB.FROM_OSP_YN                                        --전극/소형 작업 추가
      ,SUB.TO_OSP_YN                                          --전극/소형 작업 추가
      ,SUB.FROM_TCO_CELL_YN                                   --전극/소형 작업 추가
      ,SUB.TO_TCO_CELL_YN                                     --전극/소형 작업 추가

  FROM
  (  
     SELECT a.plan_id
           ,a.modeling_id
           ,a.seq 
           ,a.plan_name
           ,a.master_id
           ,a.out_version_id
           ,a.plan_type
           ,a.division_id
           ,a.origin_division_id                                --전극/소형 작업 추가
           
           ,MAX(a.demand_priority)    AS demand_priority
           ,MAX(a.due_date)           AS due_date
           ,NULL                      AS delivery_order_id
           ,a.work_order_id
           ,MIN(a.start_time)         AS start_dttm
           ,MAX(a.end_time)           AS end_dttm
           ,a.site_id
           ,a.item_id
           ,a.org_demand_id           AS demand_id
           ,a.demand_id               AS eng_demand_id
           ,SUM(a.qty)                AS supply_qty
           ,MIN(a.lpst)               AS lpst

           ,MAX(a.operation_group)    AS operation_group        --전극/소형 작업 추가
           ,MAX(a.electrode_type)     AS electrode_type         --전극/소형 작업 추가
           ,a.origin_to_division_id                             --전극/소형 작업 추가

           ,A.FROM_OSP_YN                                       --전극/소형 작업 추가
           ,A.TO_OSP_YN                                         --전극/소형 작업 추가
           ,A.FROM_TCO_CELL_YN                                  --전극/소형 작업 추가
           ,A.TO_TCO_CELL_YN                                    --전극/소형 작업 추가

      FROM (
            --SCP_ENG_PEGGING_INFO_O_TEMP_SN
            SELECT pi.plan_id
                  ,pi.modeling_id
                  ,pi.seq 
                  ,pi.plan_name
                  ,pi.master_id
                  ,pi.out_version_id
                  ,pi.plan_type
                  ,pi.division_id
                  ,pi.demand_priority
                  ,pi.due_date
                  ,pi.work_order_id
                  ,wo.start_time
                  ,wo.end_time
                  ,wo.site_id
                  ,wo.item_id
                  ,pi.org_demand_id
                  ,pi.demand_id
                  ,pi.qty
                  ,wo.lpst

                  ,wo.origin_division_id                        --전극/소형 작업 추가
                  ,wo.operation_group                           --전극/소형 작업 추가
                  ,wo.electrode_type                            --전극/소형 작업 추가
                  ,pi.origin_from_division_id                   --전극/소형 작업 추가
                  ,pi.origin_to_division_id                     --전극/소형 작업 추가

                  ,ISNULL(pi.ATTRIBUTE5,'') AS FROM_OSP_YN      --전극/소형 작업 추가
                  ,ISNULL(pi.ATTRIBUTE6,'') AS TO_OSP_YN        --전극/소형 작업 추가
                  ,ISNULL(pi.ATTRIBUTE7,'') AS FROM_TCO_CELL_YN --전극/소형 작업 추가
                  ,ISNULL(pi.ATTRIBUTE8,'') AS TO_TCO_CELL_YN   --전극/소형 작업 추가
                  
              --FROM SCP_ENG_PEGGING_INFO_O_SN     AS pi WITH(NOLOCK)
              --INNER JOIN SCP_ENG_WORK_ORDER_O_SN AS wo WITH(NOLOCK)
              FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN      AS pi WITH(NOLOCK)
              INNER JOIN SCP_ENG_WORK_ORDER_O_TEMP_SN  AS wo WITH(NOLOCK)
                ON 1=1
               AND pi.modeling_id    = wo.modeling_id         --N'2'            --
               AND pi.master_id      = wo.master_id           --N'81::WEEKLY'   --
               AND pi.plan_id        = wo.plan_id             --N'1033'         --
               AND pi.plan_type      = wo.plan_type           --N'PR'           --
               AND pi.plan_name      = wo.plan_name           --N'20180702'     --
               AND pi.seq            = wo.seq                 --N'6'            --
               AND pi.out_version_id = wo.out_version_id      --N'1033::PR::6'  --
               AND pi.division_id    = wo.division_id         --N'81'           --
               AND pi.work_order_id  = wo.work_order_id
               AND pi.from_item_id   = wo.item_id 
             INNER JOIN SCM_MST_DIVISION AS dm WITH(NOLOCK)  -- PJ20230691R HM JV 가상 사업부 추가 대응 
                ON 1=1
			   AND dm.division_id	 = wo.division_id
			   AND dm.valid_yn		 = 'Y'
             WHERE 1=1
               AND pi.work_order_id       IS NOT NULL
               AND pi.delivery_order_id   IS NULL
               AND pi.stock_plan_lot_id   IS NULL
               AND CONVERT(NUMERIC(20,10),wo.operation_qty) > 0.0
               AND ( LEFT(wo.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
                                                           SELECT segment1 AS operation_id
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)   
                                                            WHERE lookup_type = 'SCP_PLAN_OPERATION' )
															
                     -- PJ20216891 (sclee.lee)	
                     -- ISUZU item
                     OR (
                         wo.operation_id = 'P5000'
                         AND EXISTS (
                                     SELECT 1
                                     FROM   dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
                                     INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
                                     WHERE  A.ITEM_ID = wo.ITEM_ID
                                       AND A.IS_YN = 'Y'
                                    )
                        )
															
                     OR
					      -- 2020.10.28   KSW          PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - end
                          --wo.operation_id        IN (--외주PACKER의 업체코드						  
					     (CASE WHEN CHARINDEX('_', wo.operation_id) > 0 THEN (SUBSTRING(wo.operation_id, 1, DBO.FN_CHARINDEX_REV(wo.operation_id, '_', 0)-1)) ELSE wo.operation_id END) 
						                              IN (--외주PACKER의 업체코드
                                                           SELECT s.plant_id  AS operation_id
                                                            FROM SCM_MST_SITE s WITH(NOLOCK)      
                                                           WHERE 1=1
                                                             -- HM JV 대응 AND division_id = (CASE WHEN wo.division_id = 'EE'    THEN wo.origin_division_id 
                                                             -- HM JV 대응                         WHEN wo.division_id = 'EE_UC' THEN wo.origin_division_id -- 20220323 PJ20216891 GM JV 추가
                                                             -- HM JV 대응                         ELSE wo.division_id 
                                                             -- HM JV 대응                    END)
															 AND s.division_id = CASE	WHEN dm.attribute3 = 'EE'	-- PJ20230691R HM JV 가상 사업부 추가 대응 
																						THEN wo.origin_division_id
																						ELSE wo.division_id 
                                                                                  END
                                                             AND s.site_type   = 'PLANT'
                                                             AND s.osp_yn      = 'Y' 
                                                             AND s.valid_yn    = 'Y' 
                                                         ) 
                   )

            UNION ALL
            --SCP_ENG_UNPEGGING_INFO_O_TEMP_SN
            SELECT pi.plan_id
                  ,pi.modeling_id
                  ,pi.seq 
                  ,pi.plan_name
                  ,pi.master_id
                  ,pi.out_version_id
                  ,pi.plan_type
                  ,pi.division_id
                  ,NULL                    AS demand_priority           --demand_priority 없음
                  ,NULL                    AS due_date                  --due_date 없음
                  ,pi.work_order_id        
                  ,wo.start_time
                  ,wo.end_time
                  ,wo.site_id              
                  ,wo.item_id              
                  ,'UNPEGGING'             AS org_demand_id             --org_demand_id 없음
                  ,'UNPEGGING'             AS demand_id                 --demand_id 없음
                  ,pi.complete_qty         AS qty
                  ,NULL                    AS lpst

                  ,wo.origin_division_id                                --전극/소형 작업 추가
                  ,wo.operation_group                                   --전극/소형 작업 추가
                  ,wo.electrode_type                                    --전극/소형 작업 추가
                  ,wo.origin_division_id   AS origin_from_division_id   --전극/소형 작업 추가
                  ,wo.origin_division_id   AS origin_to_division_id     --전극/소형 작업 추가

                  ,ISNULL(wo.ATTRIBUTE5,'') AS FROM_OSP_YN              --전극/소형 작업 추가
                  ,ISNULL(pi.ATTRIBUTE6,'') AS TO_OSP_YN                --전극/소형 작업 추가
                  ,ISNULL(wo.ATTRIBUTE7,'') AS FROM_TCO_CELL_YN         --전극/소형 작업 추가
                  ,ISNULL(pi.ATTRIBUTE8,'') AS TO_TCO_CELL_YN           --전극/소형 작업 추가
                  
              --FROM SCP_ENG_UNPEGGING_INFO_O_SN  AS pi WITH(NOLOCK)
             --INNER JOIN SCP_ENG_WORK_ORDER_O_SN AS wo WITH(NOLOCK)
              FROM SCP_ENG_UNPEGGING_INFO_O_TEMP_SN  AS pi WITH(NOLOCK)
             INNER JOIN SCP_ENG_WORK_ORDER_O_TEMP_SN AS wo WITH(NOLOCK)
                ON 1=1
               AND pi.modeling_id    = wo.modeling_id         --N'2'            --
               AND pi.master_id      = wo.master_id           --N'81::WEEKLY'   --
               AND pi.plan_id        = wo.plan_id             --N'1033'         --
               AND pi.plan_type      = wo.plan_type           --N'PR'           --
               AND pi.plan_name      = wo.plan_name           --N'20180702'     --
               AND pi.seq            = wo.seq                 --N'6'            --
               AND pi.out_version_id = wo.out_version_id      --N'1033::PR::6'  --
               AND pi.division_id    = wo.division_id         --N'81'           --
               AND pi.work_order_id  = wo.work_order_id
               AND pi.item_id        = wo.item_id --UNPEGGING_INFO.from_item 없음
             INNER JOIN SCM_MST_DIVISION AS dm WITH(NOLOCK)  -- PJ20230691R HM JV 가상 사업부 추가 대응 
                ON 1=1
			   AND dm.division_id	 = wo.division_id
			   and dm.valid_yn		 = 'Y'
             WHERE 1=1
               AND pi.work_order_id       IS NOT NULL
               AND pi.work_order_id       <> ''
               AND pi.delivery_order_id    = ''
               --AND pi.stock_plan_lot_id IS NULL --stock_plan_lot_id 없음
               AND CONVERT(NUMERIC(20,10),wo.operation_qty) > 0.0
               AND ( LEFT(wo.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
                                                           SELECT segment1 AS operation_id
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)   
                                                            WHERE lookup_type = 'SCP_PLAN_OPERATION' )
															
                     -- PJ20216891 (sclee.lee)	
                     -- ISUZU item
                     OR (
                         wo.operation_id = 'P5000'
                         AND EXISTS (
                                     SELECT 1
                                     FROM   dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
                                     INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
                                     WHERE  A.ITEM_ID = wo.ITEM_ID
                                       AND A.IS_YN = 'Y'
                                    )
                        )
															
                     OR
					      -- 2020.10.28   KSW          PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - end
                          --wo.operation_id        IN (--외주PACKER의 업체코드						  
					     (CASE WHEN CHARINDEX('_', wo.operation_id) > 0 THEN (SUBSTRING(wo.operation_id, 1, DBO.FN_CHARINDEX_REV(wo.operation_id, '_', 0)-1)) ELSE wo.operation_id END) 
						                              IN (--외주PACKER의 업체코드
                                                           SELECT s.plant_id  AS operation_id
                                                            FROM SCM_MST_SITE  s WITH(NOLOCK)      
                                                           WHERE 1=1
                                                             -- HM JV 대응  AND division_id = (CASE WHEN wo.division_id = 'EE'    THEN wo.origin_division_id 
                                                             -- HM JV 대응                          WHEN wo.division_id = 'EE_UC' THEN wo.origin_division_id -- 20220323 PJ20216891 GM JV 추가
															 AND s.division_id = CASE	WHEN dm.attribute3 = 'EE'	-- PJ20230691R HM JV 가상 사업부 추가 대응 
																						THEN wo.origin_division_id
																						ELSE wo.division_id 
                                                                                  END
                                                             AND s.site_type   = 'PLANT'
                                                             AND s.osp_yn      = 'Y'  
                                                             AND s.valid_yn    = 'Y' 
                                                         ) 
                   )

            ) AS a
     GROUP BY
           a.plan_id
          ,a.modeling_id
          ,a.seq 
          ,a.plan_name
          ,a.master_id
          ,a.out_version_id
          ,a.plan_type
          ,a.division_id
          ,a.origin_division_id       --전극/소형 작업 추가
          
          ,a.work_order_id
          ,a.site_id
          ,a.item_id
          ,a.org_demand_id
          ,a.demand_id
          
          ,a.origin_to_division_id    --전극/소형 작업 추가

          ,A.FROM_OSP_YN              --전극/소형 작업 추가
          ,A.TO_OSP_YN                --전극/소형 작업 추가
          ,A.FROM_TCO_CELL_YN         --전극/소형 작업 추가
          ,A.TO_TCO_CELL_YN           --전극/소형 작업 추가

  ) SUB 
;   


