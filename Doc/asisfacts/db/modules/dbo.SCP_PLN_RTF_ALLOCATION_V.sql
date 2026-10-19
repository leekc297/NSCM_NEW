
CREATE VIEW [dbo].[SCP_PLN_RTF_ALLOCATION_V] AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCP_PLN_RTF_ALLOCATION_V
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
  *                               Final Plan 만 조회 : 전체 조회용으로 신규 생성된 SCP_PLN_RTF_ALLOCATION_ALL_V 사용하도록 수정
  * 2024.10.23   P.C.I			[PJ2024-50611] 소형 매출 프로세스 개선 - DM 선개발 진행으로 CELL_RPOD_SITE 임시 추가
  * 2024.11.14   JJG          PJ20249346 LGES SCP 개선과제 이행 : From SITE ID 정보 추가
  * 2024.12.03   KSG          [PJ20249346] LGES SCP 개선과제 이행 : 소형 Semi / 전극 Main 추가
                                  Semi Plan 수행 시 SE Plan RTF 표시
                                  Final Plan 수행 시 FN Plan RTF 표시(SE Plan RTF는 표시 안함)
  * 2024.12.09   KANG.H.J     [PJ2024-50611] 소형 매출 프로세스 개선의 건
  * 2025.03.31   kimcd        PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
  * 2025.04.30   kimcd        PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 81, MA에서 조회 가능하도록 추가
  * 2025.09.25   JSSBAE       [E20250919-001699]_N-ERP 3차 Roll-in 관련 DM Incoterms 전환 대응 건
  * 2025.10.17   JSSBAE       [E20251016-001378]_SCP RTF 반영로직 원복 요청 건
  ****************************************************************************/
  SELECT a.master_id
      ,a.plan_id
      ,a.out_version_id
      ,a.division_id
      ,a.origin_division_id -- 20200811 C20200730-000482 추가
      ,a.plan_start_yyyymmdd
      ,a.plan_type
      ,a.seq
      ,a.operation_group
      ,a.eng_demand_id
      ,a.item_id
      ,a.project_code
      ,a.sales_site_id
	  -------------------------------------------------------------------------------------------------------------------------------------------------------------
	  -- [E20250919-001699]_SSPM ATTRIBUTE6을 사용하도록 수정 원소스 주석처리 후 소스 수정(START)
      ,ISNULL(a.incoterms, a.SCP_INCOTERMS) AS incoterms		-- [PJ2024-50611] 소형 매출 프로세스 개선의 건 - INCOTERMS가 NULL인 케이스를 SCP_INCOTERMS로 정의함.	  
	  -------------------------------------------------------------------------------------------------------------------------------------------------------------
	  -- [E20251016-001378]_SCP RTF 반영로직 원복 후 NERP3차 INCOTERMS 관련 임시조치 내역 주석처리 (START)
	  /*, CASE WHEN A.INCOTERMS IN ('A01', 'A02', 'DAT', 'DDU', 'FAC', 'S32', 'S33', 'Z01', 'Z02', 'Z03', 'Z04', 'ZS3') THEN ISNULL(ISNULL(C.ATTRIBUTE6, A.INCOTERMS), A.SCP_INCOTERMS)
			 ELSE ISNULL(a.incoterms, a.SCP_INCOTERMS) END AS INCOTERMS		-- [PJ2024-50611] 소형 매출 프로세스 개선의 건 - INCOTERMS가 NULL인 케이스를 SCP_INCOTERMS로 정의함.*/
	  -- [E20250919-001699]_SSPM ATTRIBUTE6을 사용하도록 수정 원소스 주석처리 후 소스 수정(END)
	  -------------------------------------------------------------------------------------------------------------------------------------------------------------
	  -- [E20251016-001378]_SCP RTF 반영로직 원복 후 NERP3차 INCOTERMS 관련 임시조치 내역 주석처리 (END)
	  -------------------------------------------------------------------------------------------------------------------------------------------------------------
      ,a.dom_exp
      ,a.fcst_type
      ,a.demand_type
      ,a.due_date
      ,a.plant_site_id
      ,a.yyyymmdd
      ,a.ALLOCATION_QTY
      ,a.delivery_order_id
      ,a.from_site
      -- 20240528 PJ20244573 From Item / scp Incoterms 정보 추가
      ,a.FROM_ITEM_ID
      ,a.SCP_INCOTERMS
	  ,a.FROM_SITE_ID
	  --,a.CELL_PROD_SITE_ID -- 2025.03.31 kimcd 수요에 존재하는 Cell 생산지 제약 정보
	  ,(CASE WHEN a.origin_division_id = '40' THEN a.CELL_PROD_SITE_ID ELSE a.FROM_SITE_ID END)  AS CELL_PROD_SITE_ID -- 2025.04.16 P.C.I 40번 사업부를 제외하고는 FROM_SITE_ID 제공
  --FROM SCP_PLN_RTF_ALLOCATION_ALL_V  A WITH(NOLOCK)
  FROM  [10.34.220.88,7433].[LGCE_SCMPROD].[dbo].[SCP_PLN_RTF_ALLOCATION_ALL_V]  A WITH(NOLOCK)
  INNER JOIN ( SELECT *
               FROM (SELECT ROW_NUMBER() OVER (PARTITION BY division_id, plan_start_yyyymmdd ORDER BY plan_type_order DESC) row_num 
		                  , *
                     --FROM   SCP_PLAN_VERSION_V with(nolock)
                     FROM   [10.34.220.88,7433].[LGCE_SCMPROD].[dbo].[SCP_PLAN_VERSION_V] with(nolock)
                     WHERE  1=1
					 AND   ((plan_type = 'FN' AND confirm_flag = 'Y')
					     OR (plan_type = 'SE' AND division_id = '40')
					     OR (plan_type = 'MA' AND division_id IN ('81','EE') ) -- 2025.04.30 kimcd PJ20249548R 81, MA에서 조회 가능하도록 추가 -- 20241210 PI 요청으로 보류 => 20250115 재반영
					       )
                   )  A
               WHERE A.row_num = 1 
            ) b
			
  ON  a.division_id         = b.division_id
  AND a.plan_start_yyyymmdd = b.plan_start_yyyymmdd
  AND a.plan_type           = b.plan_type
  AND a.seq                 = b.plan_Seq    
  -------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- [E20251016-001378]_NERP3차 INCOTERMS 관련 임시조치 내역 주석처리 (START)
  /*
  -------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- [E20250919-001699]_SSPM의 ATTRIBUTE6으로 데이터를 사용하기 위해 해당 부분 추가.(START)
  LEFT OUTER JOIN SCM_MST_SITE_ITEM C WITH(NOLOCK)
			   ON A.DIVISION_ID		= C.DIVISION_ID
			  AND A.SALES_SITE_ID	= C.SCM_SITE_ID
			  AND A.PROJECT_CODE	= C.PROJECT_CODE
			  AND A.ITEM_ID			= C.ITEM_ID
  -- [E20250919-001699]_SSPM의 ATTRIBUTE6으로 데이터를 사용하기 위해 해당 부분 추가.(END)
  -------------------------------------------------------------------------------------------------------------------------------------------------------------
  */
  -- [E20251016-001378]_NERP3차 INCOTERMS 관련 임시조치 내역 주석처리 (END)
  -------------------------------------------------------------------------------------------------------------------------------------------------------------
 --WHERE 1=1
 --  AND A.PLAN_TYPE    = 'FN'
 --  AND A.CONFIRM_FLAG = 'Y'

