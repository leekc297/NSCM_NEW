







CREATE VIEW [dbo].[SCP_PLN_RTF_ALLOCATION_ALL_V] AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCP_PLN_RTF_ALLOCATION_ALL_V
  * DESCRIPTION   : WEEKLY SCP FINAL PLAN CONFIRMED ALLOCATION
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-05-03   YYDOK        INITIAL
  * 2018-05-23   LTW          DUE_DATE DATA TYPE 수정
  * 2018-07-02   YYDOK        수량ROUND처리
  * 2018-09-03   YYDOK        40,EE 20181001이전에 BLOCKING
  * 2018-09-14   YYDOK        VMI인경우,계획반영시점의 CUTOFF FCST의 INCOTERMS반영
  * 2018-10-05   YYDOK        소형(40) 조회가능 division에 추가
  * 2020-08-11   KSG          C20200730-000482 전극(EE) 정보 추가
  * 2022-01-13   KSG          Plan 구간 내 정보만 조회
  * 2022-03-23   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
  * 2023-04-04   HRK		  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
  * 2024.05.28   KSG          PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : From Item 정보 추가
  * 2024.08.12   KSG          PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 
  *                               Final Plan 만 조회에서 전체 조회용으로 신규 생성 : 기존 Final Plan 조회용 SCP_PLN_RTF_ALLOCATION_V 에서는 SCP_PLN_RTF_ALLOCATION_ALL_V 사용하도록 수정
  * 2024.11.14   JJG          PJ20249346 LGES SCP 개선과제 이행 : From SITE ID 정보 추가
  * 2025.03.18   park.p.s     DM_PLN_NET_DEMAND KEY 생성에 따른 속도저하 개선
  * 2025.03.31   kimcd        PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
  ****************************************************************************/
WITH DEMAND_VER AS (SELECT  V.DIVISION_ID, MAX(V.VERSION_NO) AS VERSION_NO
                    FROM    DM_MST_VERSION V WITH(NOLOCK)
                            INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                                ON  V.YYYYMMDD      = CM.BASIS_YYYYMMDD
                    WHERE   V.VERSION_TYPE  = 'MF_W'
                    GROUP   BY V.DIVISION_ID, CM.ISO_YYYYWW
                    )  -- 2025.03.18   park.p.s DM_PLN_NET_DEMAND KEY 생성에 따른 속도저하 개선
SELECT a.master_id
      ,a.plan_id
      ,a.out_version_id
      ,a.division_id
      ,a.origin_to_division_id AS origin_division_id -- 20200811 C20200730-000482 추가
      ,a.plan_start_yyyymmdd
      ,a.plan_type
      ,a.seq
      ,a.operation_group
      ,a.eng_demand_id
      ,a.item_id
      ,a.project_code
      ,a.sales_site_id
			--   ,a.incoterms
      ,CASE WHEN ISNULL(S.VMI_YN, 'N') = 'N' THEN A.INCOTERMS
            ELSE (  SELECT  TOP 1 DMD.INCOTERMS
                    FROM    DM_PLN_NET_DEMAND DMD
                    INNER JOIN DEMAND_VER VER
                        ON  DMD.DIVISION_ID = VER.DIVISION_ID
                        AND DMD.VERSION_NO  = VER.VERSION_NO
                    -- 20200811 C20200730-000482 DIVISION_ID 에서 origin_to_division_id으로 변경
                    WHERE A.origin_to_division_id = DMD.DIVISION_ID -- Net Demand 에 EE 없음
                    --WHERE A.DIVISION_ID       = DMD.DIVISION_ID
                    AND A.SALES_SITE_ID     = DMD.SCM_SITE_ID
                    AND A.PROJECT_CODE      = DMD.PROJECT_CODE
                    AND A.ITEM_ID           = DMD.ITEM_ID
                    AND A.FCST_TYPE         = DMD.FCST_TYPE
                    AND A.DOM_EXP           = DMD.DOM_EXP
                    ) 
            END AS INCOTERMS   -- 2025.03.18   park.p.s DM_PLN_NET_DEMAND KEY 생성에 따른 속도저하 개선
      ,a.dom_exp
      ,a.fcst_type
      ,a.demand_type
      ,convert(VARCHAR(8),a.due_date,112) as due_date
      ,a.plant_site_id
      ,a.yyyymmdd
      ,ROUND(a.allocation_qty,0) AS ALLOCATION_QTY
      ,a.delivery_order_id
      ,a.from_site
      -- 20240528 PJ20244573 From Item / scp Incoterms 정보 추가
      ,a.attribute1 AS FROM_ITEM_ID
      ,a.incoterms  AS SCP_INCOTERMS
	  --,ISNULL(a.attribute2,'') AS FROM_SITE_ID
	  -- 2025.03.31 KJJ 오형선 책임님 요청에 의한 attribute2가 없는 경우 plant_site_id 를 FROM_SITE_ID로 구성
	  ,CASE WHEN LEN(ISNULL(a.attribute2,'')) < 6 
	        THEN a.plant_site_id
	        ELSE ISNULL(a.attribute2,'')
	   END AS FROM_SITE_ID
	  ,D.CONFIRM_FLAG AS CONFIRM_FLAG
	  ,PND.CELL_PLANT_SITE_ID   AS CELL_PROD_SITE_ID -- 2025.03.31 kimcd 수요에 존재하는 Cell 생산지 제약 정보
  FROM SCP_PLN_ALLOCATION  A WITH(NOLOCK)
       INNER JOIN SCP_PLN_NET_DEMAND_V  PND
	       ON  PND.[MASTER_ID]      = A.[MASTER_ID]
           AND PND.[OUT_VERSION_ID] = A.[OUT_VERSION_ID]
           AND PND.[ENG_DEMAND_ID]  = A.[ENG_DEMAND_ID]  -- 2025.03.31 kimcd 수요에 존재하는 Cell 생산지 제약 정보
	   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK) -- PJ20230691R HM JV 가상 사업부 추가 대응
			   ON DM.DIVISION_ID = A.DIVISION_ID
			  AND DM.VALID_YN	 = 'Y'
        LEFT OUTER JOIN SCM_MST_SITE S WITH(NOLOCK)
            ON  A.ORIGIN_TO_DIVISION_ID = S.DIVISION_ID
            AND A.SALES_SITE_ID         = S.SCM_SITE_ID
      ,SCM_MST_PLAN        P WITH(NOLOCK)
      ,SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
 WHERE 1=1
 --  AND ( (a.division_id IN ('81','82') ) OR (( a.division_id IN ( 'EE','40' ) ) AND CONVERT(VARCHAR,GETDATE(),112) > '20181001' ) )
   -- 20200811 C20200730-000482 EE 포함
   -- 전극인 경우 전극 Sales 만 대상, 가상 Cell Site는 제외해야 함
   -- HM JV 대응 AND (    a.division_id IN ('81','82','40','81_UC')                    -- 20220323 PJ20216891 GM JV 추가
   -- HM JV 대응      OR (a.division_id IN ('EE','EE_UC') AND a.operation_group = 'E') -- 20220323 PJ20216891 GM JV 추가
   -- HM JV 대응     )
   --AND (    a.division_id IN ('81','82','40') 
   --     OR (a.division_id = 'EE' AND a.operation_group = 'E')
       --)
   --AND a.division_id IN ('81','82','40') 

   AND (DM.ATTRIBUTE3 != 'EE'								-- PJ20230691R HM JV 가상 사업부 추가 대응
   	    OR 
   	   (DM.ATTRIBUTE3  = 'EE' AND A.OPERATION_GROUP = 'E')	-- PJ20230691R HM JV 가상 사업부 추가 대응
	   )  
	
   -- 20240812 PJ20244573 : Final Plan 만 조회에서 전체 조회용으로 신규 생성 : 기존 Final Plan 조회용 SCP_PLN_RTF_ALLOCATION_V 에서는 SCP_PLN_RTF_ALLOCATION_ALL_V 사용하도록 수정 
   --AND A.PLAN_TYPE    = 'FN'

   AND P.DIVISION_ID  = A.DIVISION_ID -- EE 존재
   AND P.PLAN_NAME    = A.PLAN_START_YYYYMMDD
   AND P.PLAN_CYCLE   = 'WEEKLY'
   AND A.YYYYMMDD    <= P.HORIZON_END_DATE  -- 20220113 Plan 구간 내 정보만 조회

   AND D.DIVISION_ID  = A.DIVISION_ID -- EE 존재
   AND D.PLAN_ID      = P.PLAN_ID
   AND D.PLAN_TYPE    = A.PLAN_TYPE
   AND D.PLAN_SEQ     = A.SEQ
   AND D.PLAN_STATUS = '1'
   --AND D.CONFIRM_FLAG = 'Y'
;

