








  
CREATE VIEW [dbo].[SCM_MST_FINAL_ITEM_ORIGIN_DIV_V_YMH_20250901] AS 
/****************************************************************************  
* PROJECT       : LG CHEM SCP PRJ.  
* VIEW NAME     : SCM_MST_FINAL_ITEM_ORIGIN_DIV_V  
* DESCRIPTION   : 전극,셀,팩공정그룹의 최종공정의 ITEM을 조회   
*                 (ORIGIN DIVISION ONLY)
* PROGRAM HISTORY  
*--------------------------------------------------------------  
*  DATE      IN CHARGE           DESCRIPTION  
*--------------------------------------------------------------  
* 2018-09-03   YYDOK        INITIAL  
* 2019-03-18   YYDOK        전지재료 추가(DIVISION_ID=44) => 삭제
* 2020-10-14   KSG          PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
* 2021-09-13   KSG          PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : MEB(P5200) 추가
*                             --> 2021.12.13 PI 요청으로 원복함
* 2021-12-15   KSG          PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : ESS EP Final Item 추가 : item_class = 'EM0308'
* 2022-01-08   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : DC Item 구분 : item_class = 'EM0307'
* 2022-03-23   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
* 2022-06-02   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : ISUZU Item 구분
* 2022-12-20   KSG          PJ20216894 Digital SCM 3 Level 가속화를 위한 개선 Phase2 : Trust BCU Item 구분 : item_class = 'EM0306'
* 2023-04-03   HRK			PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
* 2023-06-01   KSG          PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 대응 Cell Prod/Assy 구분자 추가
                                                                                  ==> 추가 정의 및 수정 필요
* 2024-04-05   KSG          E20240328-001468 CMA Biz의 Project route 등록을 위한 Plant site 내 PW 추가요청 
                               'EA' Item 중 EM0310 class 는 Cell 이 아니라 Pack 으로 판정
* 2025-08-01   HRK          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
*								- OPERATION_GROUP_ID(1순위), CELL_TYPE, TCO_CELL_YN 컬럼 SCM_MST_ITEM_CLASS_M 테이블 참조
****************************************************************************/  
  
/*********************************************
-- 1. 자동차 : 81
*********************************************/
SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       /* E:ELECTRODE, A:CELL, P:PACK */  
       CASE WHEN CM.SCP_OPERATION_GROUP IS NOT NULL		 THEN CM.SCP_OPERATION_GROUP	-- [PJ20257329] 2025.08.01 1순위로 class master 참조 
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('AP','AM') THEN 'P'  
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('AC','EC') THEN 'A'   -- Cell Product
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('AA','EA') THEN 'A'   -- Cell Assy
            ELSE ''  
       END AS OPERATION_GROUP_ID,  
       ISNULL(I.NICK_NAME,'') AS NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'  
                         WHEN 'ES0302' THEN 'CATHODE'  
                         WHEN 'ES0303' THEN 'ONESIDE'  
                         ELSE ''  
       END AS ELECTRODE_TYPE,
       ISNULL(CM.TCO_CELL_YN, 'N')	AS TCO_CELL_YN,	-- [PJ20257329] 2025.08.01 class master 참조 
       'N' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       'N' AS DC_YN,
       'N' AS IS_YN,       -- 20220602 PJ20216891 ISUZU Item 구분
	   ISNULL(CM.CELL_TYPE, '')		AS CELL_TYPE	-- [PJ20257329] 2025.08.01 class master 참조
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       -- [PJ20257329] 2025.08.01  변경전 CASE WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('AC','EC') THEN 'CP'  -- Cell Product
       -- [PJ20257329] 2025.08.01  변경전      WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('AA','EA') THEN 'CA1'  -- Cell Assy
       -- [PJ20257329] 2025.08.01  변경전      ELSE ''  
       -- [PJ20257329] 2025.08.01  변경전 END AS CELL_TYPE
FROM   [dbo].[SCM_MST_ITEM_SN]             I WITH(NOLOCK)  
		INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- PJ20230691R HM JV 가상 사업부 추가 대응 
			    ON D.DIVISION_ID = I.DIVISION_ID
			   AND D.ATTRIBUTE3  = '81' 
			   AND D.VALID_YN	 = 'Y'
		-- [PJ20257329] 2025.08.01 class master 참조 - Start 
		LEFT  JOIN SCM_MST_ITEM_CLASS_M CM WITH(NOLOCK)	  
				ON CM.CLASS_ID = I.ITEM_CLASS 
		-- [PJ20257329] 2025.08.01 class master 참조 - End 
WHERE  1=1  
-- HM JV AND    I.DIVISION_ID IN ( '81', '81_UC') -- 20220323 PJ20216891 GM JV 가상 Division 추가
-- AND    ISNULL(I.ITEM_TYPE,'')  IN ('P') --제품    
AND    ISNULL(I.ITEM_TYPE,'')   NOT IN ('Q','R') --상품,원자재제외  
AND    SUBSTRING(I.ITEM_ID,1,2) IN ('AP','AM','AC','EC'   --'EC'자동차에서 ESS CELL생산하는 모델존재
                                  , 'AA','EA'             -- 20230601 PJ20230691 활성화 대응 Cell Assy 구분자 추가
                                   )
AND    SUBSTRING(I.ITEM_ID,1,5) NOT IN ('APCCA','APCAN','APCCS')   --전극제외  
AND    ISNULL(I.ITEM_CLASS,'')  <> ''  
AND    (SUBSTRING(I.ITEM_CLASS,1,2) = 'EM'  
     OR SUBSTRING(I.ITEM_CLASS,1,4) IN ('ES19', 'ES20')  -- 20230601 PJ20230691 활성화 대응 Cell Assy일반 : Cell Assy :  ES19 / TCO 등 후공정 관련 Cell Assy : ES20
       )

UNION   

SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       ISNULL(CM.SCP_OPERATION_GROUP, 'E') AS OPERATION_GROUP_ID,  /* E:ELECTRODE, A:CELL, P:PACK */  -- [PJ20257329] 2025.08.01 class master 참조
       ISNULL(I.NICK_NAME,'') AS NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'  
                         WHEN 'ES0302' THEN 'CATHODE'  
                         WHEN 'ES0303' THEN 'ONESIDE'  
                         ELSE ''  
       END AS ELECTRODE_TYPE,
       ISNULL(CM.TCO_CELL_YN, 'N')	AS TCO_CELL_YN,	-- [PJ20257329] 2025.08.01 class master 참조
       'N' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       'N' AS DC_YN,
       'N' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   ISNULL(CM.CELL_TYPE, '')		AS CELL_TYPE	-- [PJ20257329] 2025.08.01 class master 참조
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
FROM   [dbo].[SCM_MST_ITEM_SN]             I WITH(NOLOCK)  
		INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- PJ20230691R HM JV 가상 사업부 추가 대응 
			    ON D.DIVISION_ID = I.DIVISION_ID
			   AND D.ATTRIBUTE3  = '81' 
			   AND D.VALID_YN	 = 'Y'
		-- [PJ20257329] 2025.08.01 class master 참조 - Start 
		LEFT  JOIN SCM_MST_ITEM_CLASS_M CM WITH(NOLOCK)	  
				ON CM.CLASS_ID = I.ITEM_CLASS 
		-- [PJ20257329] 2025.08.01 class master 참조 - End 
WHERE  1=1  
-- HM JV AND    I.DIVISION_ID IN ( '81', '81_UC') -- 20220323 PJ20216891 GM JV 가상 Division 추가
AND    SUBSTRING(I.ITEM_ID,1,5) IN ('APCCA','APCAN','APCCS')   
AND    ISNULL(I.ITEM_CLASS,'') <> ''
AND    ISNULL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P')  

UNION   
-- 20210913 PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : MEB(P5200) 추가
                             --> 2021.12.13 PI 요청으로 원복함
--SELECT DISTINCT   
--       i.DIVISION_ID,  
--       i.ITEM_ID,  
--       'P' AS OPERATION_GROUP_ID,  /* E:ELECTRODE, A:CELL, P:PACK */  
--       ISNULL(I.NICK_NAME,'') AS NICK_NAME,  
--       I.ITEM_CLASS,  
--       I.ITEM_CLASS_NAME,  
--       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'  
--                         WHEN 'ES0302' THEN 'CATHODE'  
--                         WHEN 'ES0303' THEN 'ONESIDE'  
--                         ELSE ''  
--       END AS ELECTRODE_TYPE,
--       'N' AS TCO_CELL_YN,
--       'N' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
--       'N' AS DC_YN,
--       'N' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       --''  AS CELL_TYPE
--FROM   [dbo].[SCM_MST_ITEM_SN]             I WITH(NOLOCK)  
--WHERE  1=1  
--AND    I.DIVISION_ID IN ( '81', '81_UC') -- 20220323 PJ20216891 GM JV 가상 Division 추가
--AND    ISNULL(I.FLOW_ID,'') = 'P5200'
--AND    ISNULL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P')  

--UNION   

/*********************************************
-- 2. 소형 : 40
*********************************************/
SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       /* E:ELECTRODE, A:CELL, P:PACK */  
	   /* MM'-MODULE , 'MT' -TCO CELL, 'MI' - TAPED CELL,  'MD' - DSF CELL  */
       CASE WHEN CM.SCP_OPERATION_GROUP IS NOT NULL						THEN CM.SCP_OPERATION_GROUP	-- [PJ20257329] 2025.08.01 1순위로 class master 참조
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MP','MM')                THEN 'P'  
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MT','MI','MD','MC','EC') THEN 'A'   -- Cell Product
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MA','EA')                THEN 'A'   -- Cell Assy
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MU','MJ','ME','MF')      THEN 'A'   -- TCO 용 Cell Assy2
            ELSE ''  
       END AS OPERATION_GROUP_ID,
       ISNULL(I.NICK_NAME,'') AS NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'  
                         WHEN 'ES0302' THEN 'CATHODE'  
                         WHEN 'ES0303' THEN 'ONESIDE'  
               ELSE ''  
       END AS ELECTRODE_TYPE,
       CASE WHEN CM.CLASS_ID IS NOT NULL				  THEN ISNULL(CM.TCO_CELL_YN,'N')	-- [PJ20257329] 2025.08.01 class master 참조 
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MT', 'MU') THEN 'Y' --TCO   CELL  
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MI', 'MJ') THEN 'Y' --TAPED CELL  
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MD', 'ME') THEN 'Y' --DSF CELL  
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MF')       THEN 'Y' --FT CELL  : MC 중 일부는 TCO 로 MF와 연결됨
            WHEN (I.SCP_OPERATION_GROUP = 'A' 
                 AND (CASE WHEN FLOW_ID IS NULL THEN LEFT(I.SCP_FLOW_ID,5) 
			               ELSE LEFT(FLOW_ID,5) 
			          END) IN ('F6200','F7000','F7100','F7200','F7300') 
                 ) THEN 'Y' 
            ELSE 'N'  
       END AS TCO_CELL_YN,
       'N' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       'N' AS DC_YN,
	   -- 20220602 PJ20216891 ISUZU Item 구분
	   CASE WHEN ISNULL(I.NICK_NAME,'') LIKE '%ISUZU%' THEN 'Y'
	        ELSE 'N'
	   END AS IS_YN,
	   ISNULL(CM.CELL_TYPE, '')		AS CELL_TYPE	-- [PJ20257329] 2025.08.01 class master 참조
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       -- [PJ20257329] 2025.08.01  변경전 CASE WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MT','MI','MD','MC','EC') THEN 'CP'  -- Cell Product
       -- [PJ20257329] 2025.08.01  변경전      WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MA','EA')                THEN 'CA1' -- Cell Assy : MC -> MA/MF 존재
       -- [PJ20257329] 2025.08.01  변경전      WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('MU','MJ','ME','MF')      THEN 'CA2' -- TCO 용 Cell Assy2
       -- [PJ20257329] 2025.08.01  변경전      ELSE ''  
       -- [PJ20257329] 2025.08.01  변경전 END AS CELL_TYPE
FROM   [dbo].[SCM_MST_ITEM_SN]             I WITH(NOLOCK)  
		-- [PJ20257329] 2025.08.01 class master 참조 - Start 
		LEFT  JOIN SCM_MST_ITEM_CLASS_M CM WITH(NOLOCK)	  
				ON CM.CLASS_ID = I.ITEM_CLASS 
		-- [PJ20257329] 2025.08.01 class master 참조 - End 
WHERE  1=1  
AND    I.DIVISION_ID = '40'  
-- AND    ISNULL(I.ITEM_TYPE,'')  IN ('P') --제품    
AND    ISNULL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외  
AND    SUBSTRING(I.ITEM_ID,1,2) IN ('MP','MM'            -- Pack
                                  , 'MC','EC'            -- 20190703 'EC' 소형에서 ESS CELL생산하는 모델존재
                                  , 'MT','MI','MD'       -- TCO : MC 중 일부는 TCO
                                  , 'MA','EA'            -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 : Cell Assy
                                  , 'MU','MJ','ME','MF'  -- 20230601 PJ20230691 활성화 대응 Cell Assy 구분자 : TCO 용 Cell Assy2 : T/D/I/C -> U/E/J/F
                                   )
AND    ISNULL(I.ITEM_CLASS,'') <> ''  
AND    (SUBSTRING(I.ITEM_CLASS,1,2) = 'EM'  
     OR SUBSTRING(I.ITEM_CLASS,1,4) IN ('ES19', 'ES20')  -- 20230601 PJ20230691 활성화 대응 Cell Assy일반 : Cell Assy :  ES19 / TCO 등 후공정 관련 Cell Assy : ES20
       )

UNION   

SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       ISNULL(CM.SCP_OPERATION_GROUP, 'E') AS OPERATION_GROUP_ID,  /* E:ELECTRODE,A:CELL,P:PACK */  -- [PJ20257329] 2025.08.01 class master 참조
       ISNULL(I.NICK_NAME,'') AS NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'  
                         WHEN 'ES0302' THEN 'CATHODE'  
                         WHEN 'ES0303' THEN 'ONESIDE'  
                         ELSE ''  
       END AS ELECTRODE_TYPE,
       ISNULL(CM.TCO_CELL_YN, 'N')		AS TCO_CELL_YN,		-- [PJ20257329] 2025.08.01 class master 참조
       'N' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       'N' AS DC_YN,	   
	   'N' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분 : 전극은 N
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
	   ISNULL(CM.CELL_TYPE, '')			AS CELL_TYPE	-- [PJ20257329] 2025.08.01 class master 참조
FROM   [dbo].[SCM_MST_ITEM_SN]             I WITH(NOLOCK)  
		-- [PJ20257329] 2025.08.01 class master 참조 - Start 
		LEFT  JOIN SCM_MST_ITEM_CLASS_M CM WITH(NOLOCK)	  
				ON CM.CLASS_ID = I.ITEM_CLASS 
		-- [PJ20257329] 2025.08.01 class master 참조 - End 
WHERE  1=1  
AND    I.DIVISION_ID = '40'  
AND    SUBSTRING(I.ITEM_ID,1,5) IN ('APCCA','APCAN','APCCS')   
AND    ISNULL(I.ITEM_CLASS,'') <> ''  
AND    ISNULL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P')  

UNION   
-- 20220602 PJ20216891 ISUZU Item 구분
SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       ISNULL(CM.SCP_OPERATION_GROUP, 'P') AS OPERATION_GROUP_ID,  /* E:ELECTRODE,A:CELL,P:PACK */  -- [PJ20257329] 2025.08.01 class master 참조
       ISNULL(I.NICK_NAME,'') AS NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'  
                         WHEN 'ES0302' THEN 'CATHODE'  
                         WHEN 'ES0303' THEN 'ONESIDE'  
                         ELSE ''  
       END AS ELECTRODE_TYPE,
       ISNULL(CM.TCO_CELL_YN, 'N')		AS TCO_CELL_YN,	-- [PJ20257329] 2025.08.01 class master 참조
       'N' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       'N' AS DC_YN,	   
	   'Y' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
	   ISNULL(CM.CELL_TYPE, '')			AS CELL_TYPE	-- [PJ20257329] 2025.08.01 class master 참조
FROM   [dbo].[SCM_MST_ITEM_SN]             I WITH(NOLOCK)  
		-- [PJ20257329] 2025.08.01 class master 참조 - Start 
		LEFT  JOIN SCM_MST_ITEM_CLASS_M CM WITH(NOLOCK)	  
				ON CM.CLASS_ID = I.ITEM_CLASS 
		-- [PJ20257329] 2025.08.01 class master 참조 - End 
WHERE  1=1  
AND    I.DIVISION_ID = '40'  
AND    ISNULL(I.ITEM_CLASS,'') <> ''  
AND    ISNULL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P')
AND    ISNULL(I.SCP_FLOW_ID, I.FLOW_ID) = 'P5000'
AND    ISNULL(I.NICK_NAME,'')  LIKE '%ISUZU%'

UNION   

/*********************************************
-- 3. ESS : 82
*********************************************/
SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       -- 20240405 E20240328-001468 'EA' Item 중 EM0310 class 는 Cell 이 아니라 Pack 으로 판정
       CASE WHEN CM.SCP_OPERATION_GROUP	IS NOT NULL		 THEN CM.SCP_OPERATION_GROUP	-- [PJ20257329] 2025.08.01 class master 참조
		    WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('EM','EH') THEN 'P'  
            WHEN I.ITEM_CLASS             IN ('EM0310')  THEN 'P'   -- 특정 EA Item 이 pack임
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('EC')      THEN 'A'   -- Cell Product
            WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('EA')      THEN 'A'   -- Cell Assy
            ELSE ''  
       END AS OPERATION_GROUP_ID,  /* E:ELECTRODE, A:CELL, P:PACK */  
       ISNULL(I.NICK_NAME,'') AS NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'  
                         WHEN 'ES0302' THEN 'CATHODE'  
                         WHEN 'ES0303' THEN 'ONESIDE'  
                         ELSE ''  
       END AS ELECTRODE_TYPE,
       ISNULL(CM.TCO_CELL_YN, 'N')		AS TCO_CELL_YN,		-- [PJ20257329] 2025.08.01 class master 참조
       'N' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       'N' AS DC_YN,
       'N' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       -- [PJ20257329] 2025.08.01  변경전 CASE WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('EC') THEN 'CP'  -- Cell Product
       -- [PJ20257329] 2025.08.01  변경전      WHEN SUBSTRING(I.ITEM_ID,1,2) IN ('EA') AND I.ITEM_CLASS NOT IN ('EM0310') -- 20240405 E20240328-001468 : 특정 EA Item 이 pack임
       -- [PJ20257329] 2025.08.01  변경전                                              THEN 'CA1'  -- Cell Assy
       -- [PJ20257329] 2025.08.01  변경전      ELSE ''  
       -- [PJ20257329] 2025.08.01  변경전 END AS CELL_TYPE
	   ISNULL(CM.CELL_TYPE, '')			AS CELL_TYPE	-- [PJ20257329] 2025.08.01 class master 참조
FROM   [dbo].[SCM_MST_ITEM_SN]             I WITH(NOLOCK)  
		-- [PJ20257329] 2025.08.01 class master 참조 - Start 
		LEFT  JOIN SCM_MST_ITEM_CLASS_M CM WITH(NOLOCK)	  
				ON CM.CLASS_ID = I.ITEM_CLASS 
		-- [PJ20257329] 2025.08.01 class master 참조 - End 
WHERE  1=1  
AND    I.DIVISION_ID = '82'  
AND    SUBSTRING(I.ITEM_ID,1,2) IN ('EC','EM','EH' -- 20180321 ksg EH 추가  
                                  , 'EA'           -- 20230601 PJ20230691 활성화 대응 Cell Assy 구분자 추가
                                   )
AND    ISNULL(I.ITEM_CLASS,'') <> ''  
AND    (SUBSTRING(I.ITEM_CLASS,1,2) = 'EM'  
     OR SUBSTRING(I.ITEM_CLASS,1,4) IN ('ES19', 'ES20')  -- 20230601 PJ20230691 활성화 대응 Cell Assy일반 : Cell Assy :  ES19 / TCO 등 후공정 관련 Cell Assy : ES20
       )
--AND    ISNULL(I.ITEM_TYPE,'')  IN ('P') --제품    
AND    ISNULL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외

-- 20211215 PJ20214907 ESS EP Final Item 추가 : item_class = 'EM0308'
-- 20221220 Trust BCU Item 구분 : item_class = 'EM0306'
UNION   
SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       ISNULL(CM.SCP_OPERATION_GROUP, 'P')  AS OPERATION_GROUP_ID,  /* E:ELECTRODE, A:CELL, P:PACK */  -- [PJ20257329] 2025.08.01 class master 참조
       ISNULL(I.NICK_NAME,'') AS NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'  
                         WHEN 'ES0302' THEN 'CATHODE'  
                         WHEN 'ES0303' THEN 'ONESIDE'  
                         ELSE ''  
       END AS ELECTRODE_TYPE,
       ISNULL(CM.TCO_CELL_YN, 'N')			AS TCO_CELL_YN,	-- [PJ20257329] 2025.08.01 class master 참조
       'N' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       'N' AS DC_YN,
       'N' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
	   ISNULL(CM.CELL_TYPE, '')				AS CELL_TYPE	-- [PJ20257329] 2025.08.01 class master 참조
FROM   [dbo].[SCM_MST_ITEM_SN]             I WITH(NOLOCK)  
		-- [PJ20257329] 2025.08.01 class master 참조 - Start 
		LEFT  JOIN SCM_MST_ITEM_CLASS_M CM WITH(NOLOCK)	  
				ON CM.CLASS_ID = I.ITEM_CLASS 
		-- [PJ20257329] 2025.08.01 class master 참조 - End 
WHERE  1=1  
AND    I.DIVISION_ID = '82'  
AND    ISNULL(I.ITEM_CLASS,'') IN ( 'EM0306', 'EM0308' )
AND    ISNULL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P')  


-- 20201014 PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK Item 추가
UNION 

SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       ISNULL(CM.SCP_OPERATION_GROUP, 'P')  AS OPERATION_GROUP_ID,  -- [PJ20257329] 2025.08.01 class master 참조
       ISNULL(I.NICK_NAME,'')   AS NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       NULL AS ELECTRODE_TYPE,
       ISNULL(CM.TCO_CELL_YN, 'N')			AS TCO_CELL_YN,		-- [PJ20257329] 2025.08.01 class master 참조
       'Y'  AS RACK_YN,
       'N'  AS DC_YN,
       'N'  AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
	   ISNULL(CM.CELL_TYPE, '')				AS CELL_TYPE	-- [PJ20257329] 2025.08.01 class master 참조
FROM   [dbo].[SCM_MST_ITEM_SN] I WITH(NOLOCK)  
		-- [PJ20257329] 2025.08.01 class master 참조 - Start 
		LEFT  JOIN SCM_MST_ITEM_CLASS_M CM WITH(NOLOCK)	  
				ON CM.CLASS_ID = I.ITEM_CLASS 
		-- [PJ20257329] 2025.08.01 class master 참조 - End 
WHERE  1=1  
AND    I.DIVISION_ID = '82'  
AND    ISNULL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE  IN ('H','P')  
AND    I.ITEM_CLASS IN ('EM0304')

-- 20220107 DC Item 구분 : item_class = 'EM0307'
UNION
SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       ISNULL(CM.SCP_OPERATION_GROUP, 'P')          AS OPERATION_GROUP_ID,  -- [PJ20257329] 2025.08.01 class master 참조
       ISNULL(I.NICK_NAME,'')   AS NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       NULL AS ELECTRODE_TYPE,
       ISNULL(CM.TCO_CELL_YN, 'N')					AS TCO_CELL_YN,			-- [PJ20257329] 2025.08.01 class master 참조
       'N'  AS RACK_YN,
       'Y'  AS DC_YN,
       'N'  AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
	   ISNULL(CM.CELL_TYPE, '')						AS CELL_TYPE			-- [PJ20257329] 2025.08.01 class master 참조
FROM   [dbo].[SCM_MST_ITEM_SN] I WITH(NOLOCK)  
		-- [PJ20257329] 2025.08.01 class master 참조 - Start 
		LEFT  JOIN SCM_MST_ITEM_CLASS_M CM WITH(NOLOCK)	  
				ON CM.CLASS_ID = I.ITEM_CLASS 
		-- [PJ20257329] 2025.08.01 class master 참조 - End 
WHERE  1=1  
AND    I.DIVISION_ID = '82'  
AND    ISNULL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE  IN ('H','P')  
AND    I.ITEM_CLASS IN ('EM0307')

UNION   

SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       ISNULL(CM.SCP_OPERATION_GROUP, 'E') AS OPERATION_GROUP_ID,  /* E:ELECTRODE, A:CELL, P:PACK */  -- [PJ20257329] 2025.08.01 class master 참조
       ISNULL(I.NICK_NAME,'') AS NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'  
                         WHEN 'ES0302' THEN 'CATHODE'  
                         WHEN 'ES0303' THEN 'ONESIDE'  
                         ELSE ''  
       END AS ELECTRODE_TYPE,
       ISNULL(CM.TCO_CELL_YN, 'N')			AS TCO_CELL_YN,		-- [PJ20257329] 2025.08.01 class master 참조
       'N' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       'N' AS DC_YN,
       'N' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
	   ISNULL(CM.CELL_TYPE, '')		AS CELL_TYPE	-- [PJ20257329] 2025.08.01 class master 참조
FROM   [dbo].[SCM_MST_ITEM_SN]             I WITH(NOLOCK)  
		-- [PJ20257329] 2025.08.01 class master 참조 - Start 
		LEFT  JOIN SCM_MST_ITEM_CLASS_M CM WITH(NOLOCK)	  
				ON CM.CLASS_ID = I.ITEM_CLASS 
		-- [PJ20257329] 2025.08.01 class master 참조 - End 
WHERE  1=1  
AND    I.DIVISION_ID = '82'  
AND    SUBSTRING(I.ITEM_ID,1,5) IN ('APCCA','APCAN','APCCS')   
AND    ISNULL(I.ITEM_CLASS,'') <> ''  
AND    ISNULL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P')  
;  

