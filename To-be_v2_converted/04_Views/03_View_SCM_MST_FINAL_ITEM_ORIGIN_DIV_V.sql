/*=============================================================================================
 * File         : 03_View_SCM_MST_FINAL_ITEM_ORIGIN_DIV_V.sql
 * Description  : View — SCM_MST_FINAL_ITEM_ORIGIN_DIV_V
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : ANSI OUTER JOIN → (+) 변환은 자동변환 위험으로 수동 검토 필요.
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 04_Views 단계 (Tables 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN ... ON → WHERE A.x = B.x(+) 변환 (사내 표준 §7.1.6)
 *===========================================================================================*/

-- SCM_MGR.SCM_MST_FINAL_ITEM_ORIGIN_DIV_V source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "SCM_MGR"."SCM_MST_FINAL_ITEM_ORIGIN_DIV_V" ("DIVISION_ID", "ITEM_ID", "OPERATION_GROUP_ID", "NICK_NAME", "ITEM_CLASS", "ITEM_CLASS_NAME", "ELECTRODE_TYPE", "TCO_CELL_YN", "RACK_YN", "DC_YN", "IS_YN", "CELL_TYPE") AS 
  SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       /* E:ELECTRODE, A:CELL, P:PACK */
       CASE WHEN CM.SCP_OPERATION_GROUP IS NOT NULL         THEN CM.SCP_OPERATION_GROUP    -- [PJ20257329] 2025.08.01 1순위로 class master 참조
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('AP','AM')       THEN 'P'
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('AC','EC')       THEN 'A'   -- Cell Product
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('AA','EA')       THEN 'A'   -- Cell Assy
            ELSE ''
       END AS OPERATION_GROUP_ID,
       NVL(I.NICK_NAME,'')  AS NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'
                         WHEN 'ES0302' THEN 'CATHODE'
                         WHEN 'ES0303' THEN 'ONESIDE'
                         WHEN 'ES0305' THEN 'ONESIDE'    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
                         ELSE ''
       END AS ELECTRODE_TYPE,
       NVL(CM.TCO_CELL_YN, '')    AS TCO_CELL_YN,    -- [PJ20257329] 2025.08.01 class master 참조
       '' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       '' AS DC_YN,
       '' AS IS_YN,       -- 20220602 PJ20216891 ISUZU Item 구분
       NVL(CM.CELL_TYPE, '')        AS CELL_TYPE       -- [PJ20257329] 2025.08.01 class master 참조
       -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       -- [PJ20257329] 2025.08.01  변경전 CASE WHEN SUBSTR(I.ITEM_ID,1,2) IN ('AC','EC') THEN 'CP'  -- Cell Product
       -- [PJ20257329] 2025.08.01  변경전      WHEN SUBSTR(I.ITEM_ID,1,2) IN ('AA','EA') THEN 'CA1'  -- Cell Assy
       -- [PJ20257329] 2025.08.01  변경전      ELSE ''
       -- [PJ20257329] 2025.08.01  변경전 END AS CELL_TYPE
  FROM SCM_MST_ITEM_SN             I
       INNER JOIN SCM_MST_DIVISION D  -- PJ20230691R HM JV 가상 사업부 추가 대응
               ON D.DIVISION_ID = I.DIVISION_ID
              AND D.ATTRIBUTE3  = '81'
              AND D.VALID_YN    = 'Y'
       -- [PJ20257329] 2025.08.01 class master 참조 - Start
       LEFT  JOIN SCM_MST_ITEM_CLASS_M CM
               ON CM.CLASS_ID = I.ITEM_CLASS
       -- [PJ20257329] 2025.08.01 class master 참조 - End
 WHERE 1=1
-- HM JV AND    I.DIVISION_ID IN ( '81', '81_UC') -- 20220323 PJ20216891 GM JV 가상 Division 추가
-- AND    NVL(I.ITEM_TYPE,'')  IN ('P') --제품
 AND    NVL(I.ITEM_TYPE,'*')   NOT IN ('Q','R') --상품,원자재제외  2026.03.09 kimcd ''에서 '*'로 변경
 AND    SUBSTR(I.ITEM_ID,1,2) IN ('AP','AM','AC','EC'   --'EC'자동차에서 ESS CELL생산하는 모델존재
                                 , 'AA','EA'             -- 20230601 PJ20230691 활성화 대응 Cell Assy 구분자 추가
                                  )
-- PJ20257329 2025.09.25 변경전  AND    SUBSTR(I.ITEM_ID,1,5) NOT IN ('APCCA','APCAN','APCCS')   --전극제외
 AND    NVL(I.ITEM_CLASS,'') NOT IN ('ES0301', 'ES0302', 'ES0303', 'ES0305')    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가 (전극제외)
 AND    I.ITEM_CLASS IS NOT NULL
 AND    (SUBSTR(I.ITEM_CLASS,1,2) = 'EM'
      OR SUBSTR(I.ITEM_CLASS,1,4) IN ('ES19', 'ES20')  -- 20230601 PJ20230691 활성화 대응 Cell Assy일반 : Cell Assy :  ES19 / TCO 등 후공정 관련 Cell Assy : ES20
        )
 AND    NVL(CM.SCP_EXC_YN, '') != 'Y'    -- PJ20257329 2025.09.01 SCP Exclude Class 품목 제외

UNION

SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       NVL(CM.SCP_OPERATION_GROUP, 'E') AS OPERATION_GROUP_ID,  /* E:ELECTRODE, A:CELL, P:PACK */  -- [PJ20257329] 2025.08.01 class master 참조
       NVL(I.NICK_NAME,'')  AS NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'
                         WHEN 'ES0302' THEN 'CATHODE'
                         WHEN 'ES0303' THEN 'ONESIDE'
                         WHEN 'ES0305' THEN 'ONESIDE'    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
                         ELSE ''
       END AS ELECTRODE_TYPE,
       NVL(CM.TCO_CELL_YN, '')    AS TCO_CELL_YN,    -- [PJ20257329] 2025.08.01 class master 참조
       '' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       '' AS DC_YN,
       '' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       NVL(CM.CELL_TYPE, '')        AS CELL_TYPE       -- [PJ20257329] 2025.08.01 class master 참조
       -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
  FROM SCM_MST_ITEM_SN             I
       INNER JOIN SCM_MST_DIVISION D  -- PJ20230691R HM JV 가상 사업부 추가 대응
               ON D.DIVISION_ID = I.DIVISION_ID
              AND D.ATTRIBUTE3  = '81'
              AND D.VALID_YN    = 'Y'
       -- [PJ20257329] 2025.08.01 class master 참조 - Start
       LEFT  JOIN SCM_MST_ITEM_CLASS_M CM
               ON CM.CLASS_ID = I.ITEM_CLASS
       -- [PJ20257329] 2025.08.01 class master 참조 - End
 WHERE 1=1
-- HM JV AND    I.DIVISION_ID IN ( '81', '81_UC') -- 20220323 PJ20216891 GM JV 가상 Division 추가
-- PJ20257329 2025.09.25 변경전 AND    SUBSTR(I.ITEM_ID,1,5) IN ('APCCA','APCAN','APCCS')
-- PJ20257329 2025.09.25 변경전 AND    NVL(I.ITEM_CLASS,'') <> ''
 AND    NVL(I.ITEM_CLASS,'') IN ('ES0301', 'ES0302', 'ES0303', 'ES0305')    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
 AND    NVL(I.ITEM_TYPE,'*') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P') 2026.03.09 kimcd ''에서 '*'로 변경
 AND    NVL(CM.SCP_EXC_YN, '') != 'Y'    -- PJ20257329 2025.09.01 SCP Exclude Class 품목 제외

UNION
-- 20210913 PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : MEB(P5200) 추가
                             --> 2021.12.13 PI 요청으로 원복함
--SELECT DISTINCT
--       i.DIVISION_ID,
--       i.ITEM_ID,
--       'P' AS OPERATION_GROUP_ID,  /* E:ELECTRODE, A:CELL, P:PACK */
--       NVL(I.NICK_NAME,'') AS NICK_NAME,
--       I.ITEM_CLASS,
--       I.ITEM_CLASS_NAME,
--       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'
--                         WHEN 'ES0302' THEN 'CATHODE'
--                         WHEN 'ES0303' THEN 'ONESIDE'
--                         ELSE ''
--       END AS ELECTRODE_TYPE,
--       '' AS TCO_CELL_YN,
--       '' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
--       '' AS DC_YN,
--       '' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       --''  AS CELL_TYPE
--FROM   SCM_MST_ITEM_SN             I
--WHERE  1=1
--AND    I.DIVISION_ID IN ( '81', '81_UC') -- 20220323 PJ20216891 GM JV 가상 Division 추가
--AND    NVL(I.FLOW_ID,'') = 'P5200'
--AND    NVL(I.ITEM_TYPE,'') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P')

--UNION

/*********************************************
-- 2. 소형 : 40
*********************************************/
SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       /* E:ELECTRODE, A:CELL, P:PACK */
       /* MM'-MODULE , 'MT' -TCO CELL, 'MI' - TAPED CELL,  'MD' - DSF CELL  */
       CASE WHEN CM.SCP_OPERATION_GROUP IS NOT NULL                             THEN CM.SCP_OPERATION_GROUP    -- [PJ20257329] 2025.08.01 1순위로 class master 참조
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MP','MM')                           THEN 'P'
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MT','MI','MD','MC','EC')            THEN 'A'   -- Cell Product
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MA','EA')                           THEN 'A'   -- Cell Assy
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MU','MJ','ME','MF')                 THEN 'A'   -- TCO 용 Cell Assy2
            ELSE ''
       END AS OPERATION_GROUP_ID,
       NVL(I.NICK_NAME,'')  AS NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'
                         WHEN 'ES0302' THEN 'CATHODE'
                         WHEN 'ES0303' THEN 'ONESIDE'
                         WHEN 'ES0305' THEN 'ONESIDE'    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
               ELSE ''
       END AS ELECTRODE_TYPE,
       CASE WHEN CM.CLASS_ID IS NOT NULL                              THEN NVL(CM.TCO_CELL_YN,'')   -- [PJ20257329] 2025.08.01 class master 참조
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MT', 'MU')               THEN 'Y' --TCO   CELL
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MI', 'MJ')               THEN 'Y' --TAPED CELL
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MD', 'ME')               THEN 'Y' --DSF CELL
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MF')                     THEN 'Y' --FT CELL  : MC 중 일부는 TCO 로 MF와 연결됨
            WHEN (I.SCP_OPERATION_GROUP = 'A'
                 AND (CASE WHEN FLOW_ID IS NULL THEN SUBSTR(I.SCP_FLOW_ID,1,5)
                           ELSE SUBSTR(FLOW_ID,1,5)
                      END) IN ('F6200','F7000','F7100','F7200','F7300')
                 ) THEN 'Y'
            ELSE ''
       END AS TCO_CELL_YN,
       '' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       '' AS DC_YN,
       -- 20220602 PJ20216891 ISUZU Item 구분
       CASE WHEN NVL(I.NICK_NAME,'') LIKE '%ISUZU%' THEN 'Y'
            ELSE ''
       END AS IS_YN,
       NVL(CM.CELL_TYPE, '')        AS CELL_TYPE       -- [PJ20257329] 2025.08.01 class master 참조
       -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       -- [PJ20257329] 2025.08.01  변경전 CASE WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MT','MI','MD','MC','EC') THEN 'CP'  -- Cell Product
       -- [PJ20257329] 2025.08.01  변경전      WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MA','EA')                THEN 'CA1' -- Cell Assy : MC -> MA/MF 존재
       -- [PJ20257329] 2025.08.01  변경전      WHEN SUBSTR(I.ITEM_ID,1,2) IN ('MU','MJ','ME','MF')      THEN 'CA2' -- TCO 용 Cell Assy2
       -- [PJ20257329] 2025.08.01  변경전      ELSE ''
       -- [PJ20257329] 2025.08.01  변경전 END AS CELL_TYPE
  FROM SCM_MST_ITEM_SN             I
       -- [PJ20257329] 2025.08.01 class master 참조 - Start
       LEFT  JOIN SCM_MST_ITEM_CLASS_M CM
               ON CM.CLASS_ID = I.ITEM_CLASS
       -- [PJ20257329] 2025.08.01 class master 참조 - End
 WHERE 1=1
 AND    I.DIVISION_ID = '40'
-- AND    NVL(I.ITEM_TYPE,'')  IN ('P') --제품
 AND    NVL(I.ITEM_TYPE,'*') NOT IN ('Q','R') --상품,원자재제외
 AND    SUBSTR(I.ITEM_ID,1,2) IN ('MP','MM'            -- Pack
                                 , 'MC','EC'            -- 20190703 'EC' 소형에서 ESS CELL생산하는 모델존재
                                 , 'MT','MI','MD'       -- TCO : MC 중 일부는 TCO
                                 , 'MA','EA'            -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 : Cell Assy
                                 , 'MU','MJ','ME','MF'  -- 20230601 PJ20230691 활성화 대응 Cell Assy 구분자 : TCO 용 Cell Assy2 : T/D/I/C -> U/E/J/F
                                  )
 AND    I.ITEM_CLASS IS NOT NULL
 AND    (SUBSTR(I.ITEM_CLASS,1,2) = 'EM'
      OR SUBSTR(I.ITEM_CLASS,1,4) IN ('ES19', 'ES20')  -- 20230601 PJ20230691 활성화 대응 Cell Assy일반 : Cell Assy :  ES19 / TCO 등 후공정 관련 Cell Assy : ES20
        )
 AND    NVL(CM.SCP_EXC_YN, '') != 'Y'    -- PJ20257329 2025.09.01 SCP Exclude Class 품목 제외

UNION

SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       NVL(CM.SCP_OPERATION_GROUP, 'E') AS OPERATION_GROUP_ID,  /* E:ELECTRODE,A:CELL,P:PACK */  -- [PJ20257329] 2025.08.01 class master 참조
       NVL(I.NICK_NAME,'')  AS NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'
                         WHEN 'ES0302' THEN 'CATHODE'
                         WHEN 'ES0303' THEN 'ONESIDE'
                         WHEN 'ES0305' THEN 'ONESIDE'    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
                         ELSE ''
       END AS ELECTRODE_TYPE,
       NVL(CM.TCO_CELL_YN, '')        AS TCO_CELL_YN,        -- [PJ20257329] 2025.08.01 class master 참조
       '' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       '' AS DC_YN,
       '' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분 : 전극은 N
       -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       NVL(CM.CELL_TYPE, '')            AS CELL_TYPE            -- [PJ20257329] 2025.08.01 class master 참조
  FROM SCM_MST_ITEM_SN             I
       -- [PJ20257329] 2025.08.01 class master 참조 - Start
       LEFT  JOIN SCM_MST_ITEM_CLASS_M CM
               ON CM.CLASS_ID = I.ITEM_CLASS
       -- [PJ20257329] 2025.08.01 class master 참조 - End
 WHERE 1=1
 AND    I.DIVISION_ID = '40'
-- PJ20257329 2025.09.25 변경전 AND    SUBSTR(I.ITEM_ID,1,5) IN ('APCCA','APCAN','APCCS')
-- PJ20257329 2025.09.25 변경전 AND    NVL(I.ITEM_CLASS,'') <> ''
 AND    NVL(I.ITEM_CLASS,'') IN ('ES0301', 'ES0302', 'ES0303', 'ES0305')    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
 AND    NVL(I.ITEM_TYPE,'*') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P') 2026.03.09 kimcd ''에서 '*'로 변경
 AND    NVL(CM.SCP_EXC_YN, '') != 'Y'    -- PJ20257329 2025.09.01 SCP Exclude Class 품목 제외

UNION

-- 20220602 PJ20216891 ISUZU Item 구분
SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       NVL(CM.SCP_OPERATION_GROUP, 'P') AS OPERATION_GROUP_ID,  /* E:ELECTRODE,A:CELL,P:PACK */  -- [PJ20257329] 2025.08.01 class master 참조
       NVL(I.NICK_NAME,'')  AS NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'
                         WHEN 'ES0302' THEN 'CATHODE'
                         WHEN 'ES0303' THEN 'ONESIDE'
                         WHEN 'ES0305' THEN 'ONESIDE'    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
                         ELSE ''
       END AS ELECTRODE_TYPE,
       NVL(CM.TCO_CELL_YN, '')        AS TCO_CELL_YN,    -- [PJ20257329] 2025.08.01 class master 참조
       '' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       '' AS DC_YN,
       'Y' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       NVL(CM.CELL_TYPE, '')            AS CELL_TYPE        -- [PJ20257329] 2025.08.01 class master 참조
  FROM SCM_MST_ITEM_SN             I
       -- [PJ20257329] 2025.08.01 class master 참조 - Start
       LEFT  JOIN SCM_MST_ITEM_CLASS_M CM
               ON CM.CLASS_ID = I.ITEM_CLASS
       -- [PJ20257329] 2025.08.01 class master 참조 - End
 WHERE 1=1
 AND    I.DIVISION_ID = '40'
 AND    I.ITEM_CLASS  IS NOT NULL
 AND    NVL(I.ITEM_TYPE,'*') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P') 2026.03.09 kimcd ''에서 '*'로 변경
 AND    NVL(I.SCP_FLOW_ID, I.FLOW_ID) = 'P5000'
 AND    I.NICK_NAME       LIKE '%ISUZU%'
 AND    NVL(CM.SCP_EXC_YN, '') != 'Y'        -- PJ20257329 2025.09.01 SCP Exclude Class 품목 제외

UNION

/*********************************************
-- 3. ESS : 82
*********************************************/
SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       -- 20240405 E20240328-001468 'EA' Item 중 EM0310 class 는 Cell 이 아니라 Pack 으로 판정
       CASE WHEN CM.SCP_OPERATION_GROUP IS NOT NULL              THEN CM.SCP_OPERATION_GROUP    -- [PJ20257329] 2025.08.01 class master 참조
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('EM','EH')            THEN 'P'
            WHEN I.ITEM_CLASS             IN ('EM0310')           THEN 'P'   -- 특정 EA Item 이 pack임
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('EC')                 THEN 'A'   -- Cell Product
            WHEN SUBSTR(I.ITEM_ID,1,2) IN ('EA')                 THEN 'A'   -- Cell Assy
            ELSE ''
       END AS OPERATION_GROUP_ID,  /* E:ELECTRODE, A:CELL, P:PACK */
       NVL(I.NICK_NAME,'')  AS NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'
                         WHEN 'ES0302' THEN 'CATHODE'
                         WHEN 'ES0303' THEN 'ONESIDE'
                         WHEN 'ES0305' THEN 'ONESIDE'    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
                         ELSE ''
       END AS ELECTRODE_TYPE,
       NVL(CM.TCO_CELL_YN, '')        AS TCO_CELL_YN,        -- [PJ20257329] 2025.08.01 class master 참조
       '' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       '' AS DC_YN,
       '' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       -- [PJ20257329] 2025.08.01  변경전 CASE WHEN SUBSTR(I.ITEM_ID,1,2) IN ('EC') THEN 'CP'  -- Cell Product
       -- [PJ20257329] 2025.08.01  변경전      WHEN SUBSTR(I.ITEM_ID,1,2) IN ('EA') AND I.ITEM_CLASS NOT IN ('EM0310') -- 20240405 E20240328-001468 : 특정 EA Item 이 pack임
       -- [PJ20257329] 2025.08.01  변경전                                              THEN 'CA1'  -- Cell Assy
       -- [PJ20257329] 2025.08.01  변경전      ELSE ''
       -- [PJ20257329] 2025.08.01  변경전 END AS CELL_TYPE
       NVL(CM.CELL_TYPE, '')            AS CELL_TYPE            -- [PJ20257329] 2025.08.01 class master 참조
  FROM SCM_MST_ITEM_SN             I
       -- [PJ20257329] 2025.08.01 class master 참조 - Start
       LEFT  JOIN SCM_MST_ITEM_CLASS_M CM
               ON CM.CLASS_ID = I.ITEM_CLASS
       -- [PJ20257329] 2025.08.01 class master 참조 - End
 WHERE 1=1
 AND    I.DIVISION_ID = '82'
 AND    SUBSTR(I.ITEM_ID,1,2) IN ('EC','EM','EH' -- 20180321 ksg EH 추가
                                 , 'EA'           -- 20230601 PJ20230691 활성화 대응 Cell Assy 구분자 추가
                                  )
 AND    I.ITEM_CLASS IS NOT NULL
 AND    (SUBSTR(I.ITEM_CLASS,1,2) = 'EM'
      OR SUBSTR(I.ITEM_CLASS,1,4) IN ('ES19', 'ES20')  -- 20230601 PJ20230691 활성화 대응 Cell Assy일반 : Cell Assy :  ES19 / TCO 등 후공정 관련 Cell Assy : ES20
        )
--AND    NVL(I.ITEM_TYPE,'')  IN ('P') --제품
 AND    NVL(I.ITEM_TYPE,'*') NOT IN ('Q','R') --상품,원자재제외 2026.03.09 kimcd ''에서 '*'로 변경
 AND    NVL(CM.SCP_EXC_YN, '') != 'Y'        -- PJ20257329 2025.09.01 SCP Exclude Class 품목 제외

-- 20211215 PJ20214907 ESS EP Final Item 추가 : item_class = 'EM0308'
-- 20221220 Trust BCU Item 구분 : item_class = 'EM0306'
UNION
SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       NVL(CM.SCP_OPERATION_GROUP, 'P')  AS OPERATION_GROUP_ID,  /* E:ELECTRODE, A:CELL, P:PACK */  -- [PJ20257329] 2025.08.01 class master 참조
       NVL(I.NICK_NAME,'')  AS NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'
                         WHEN 'ES0302' THEN 'CATHODE'
                         WHEN 'ES0303' THEN 'ONESIDE'
                         WHEN 'ES0305' THEN 'ONESIDE'    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
                         ELSE ''
       END AS ELECTRODE_TYPE,
       NVL(CM.TCO_CELL_YN, '')            AS TCO_CELL_YN,    -- [PJ20257329] 2025.08.01 class master 참조
       '' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       '' AS DC_YN,
       '' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       NVL(CM.CELL_TYPE, '')                AS CELL_TYPE        -- [PJ20257329] 2025.08.01 class master 참조
  FROM SCM_MST_ITEM_SN             I
       -- [PJ20257329] 2025.08.01 class master 참조 - Start
       LEFT  JOIN SCM_MST_ITEM_CLASS_M CM
               ON CM.CLASS_ID = I.ITEM_CLASS
       -- [PJ20257329] 2025.08.01 class master 참조 - End
 WHERE 1=1
 AND    I.DIVISION_ID = '82'
 AND    I.ITEM_CLASS IN ( 'EM0306', 'EM0308' )
 AND    NVL(I.ITEM_TYPE,'*') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P') 2026.03.09 kimcd ''에서 '*'로 변경
 AND    NVL(CM.SCP_EXC_YN, '') != 'Y'        -- PJ20257329 2025.09.01 SCP Exclude Class 품목 제외


-- 20201014 PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK Item 추가
UNION

SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       NVL(CM.SCP_OPERATION_GROUP, 'P')  AS OPERATION_GROUP_ID,  -- [PJ20257329] 2025.08.01 class master 참조
       NVL(I.NICK_NAME,'')   AS NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       NULL AS ELECTRODE_TYPE,
       NVL(CM.TCO_CELL_YN, '')            AS TCO_CELL_YN,        -- [PJ20257329] 2025.08.01 class master 참조
       'Y'  AS RACK_YN,
       ''  AS DC_YN,
       ''  AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       NVL(CM.CELL_TYPE, '')                AS CELL_TYPE            -- [PJ20257329] 2025.08.01 class master 참조
  FROM SCM_MST_ITEM_SN I
       -- [PJ20257329] 2025.08.01 class master 참조 - Start
       LEFT  JOIN SCM_MST_ITEM_CLASS_M CM
               ON CM.CLASS_ID = I.ITEM_CLASS
       -- [PJ20257329] 2025.08.01 class master 참조 - End
 WHERE 1=1
 AND    I.DIVISION_ID = '82'
 AND    NVL(I.ITEM_TYPE,'*') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE  IN ('H','P')
 AND    I.ITEM_CLASS IN ('EM0304')
 AND    NVL(CM.SCP_EXC_YN, '') != 'Y'    -- PJ20257329 2025.09.01 SCP Exclude Class 품목 제외

-- 20220107 DC Item 구분 : item_class = 'EM0307'
UNION
SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       NVL(CM.SCP_OPERATION_GROUP, 'P')              AS OPERATION_GROUP_ID,  -- [PJ20257329] 2025.08.01 class master 참조
       NVL(I.NICK_NAME,'')   AS NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       NULL AS ELECTRODE_TYPE,
       NVL(CM.TCO_CELL_YN, '')                        AS TCO_CELL_YN,            -- [PJ20257329] 2025.08.01 class master 참조
       ''  AS RACK_YN,
       'Y'  AS DC_YN,
       ''  AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       NVL(CM.CELL_TYPE, '')                            AS CELL_TYPE                -- [PJ20257329] 2025.08.01 class master 참조
  FROM SCM_MST_ITEM_SN I
       -- [PJ20257329] 2025.08.01 class master 참조 - Start
       LEFT  JOIN SCM_MST_ITEM_CLASS_M CM
               ON CM.CLASS_ID = I.ITEM_CLASS
       -- [PJ20257329] 2025.08.01 class master 참조 - End
 WHERE 1=1
 AND    I.DIVISION_ID = '82'
 AND    NVL(I.ITEM_TYPE,'*') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE  IN ('H','P')
 AND    I.ITEM_CLASS IN ('EM0307')
 AND    NVL(CM.SCP_EXC_YN, '') != 'Y'        -- PJ20257329 2025.09.01 SCP Exclude Class 품목 제외

UNION

SELECT DISTINCT
       I.DIVISION_ID,
       I.ITEM_ID,
       NVL(CM.SCP_OPERATION_GROUP, 'E') AS OPERATION_GROUP_ID,  /* E:ELECTRODE, A:CELL, P:PACK */  -- [PJ20257329] 2025.08.01 class master 참조
       NVL(I.NICK_NAME,'')  AS NICK_NAME,
       I.ITEM_CLASS,
       I.ITEM_CLASS_NAME,
       CASE I.ITEM_CLASS WHEN 'ES0301' THEN 'ANODE'
                         WHEN 'ES0302' THEN 'CATHODE'
                         WHEN 'ES0303' THEN 'ONESIDE'
                         WHEN 'ES0305' THEN 'ONESIDE'    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
                         ELSE ''
       END AS ELECTRODE_TYPE,
       NVL(CM.TCO_CELL_YN, '')        AS TCO_CELL_YN,        -- [PJ20257329] 2025.08.01 class master 참조
       '' AS RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       '' AS DC_YN,
       '' AS IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
       -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
       NVL(CM.CELL_TYPE, '')            AS CELL_TYPE            -- [PJ20257329] 2025.08.01 class master 참조
  FROM SCM_MST_ITEM_SN             I
       -- [PJ20257329] 2025.08.01 class master 참조 - Start
       LEFT  JOIN SCM_MST_ITEM_CLASS_M CM
               ON CM.CLASS_ID = I.ITEM_CLASS
       -- [PJ20257329] 2025.08.01 class master 참조 - End
 WHERE 1=1
 AND    I.DIVISION_ID = '82'
-- PJ20257329 2025.09.25 변경전 AND    SUBSTR(I.ITEM_ID,1,5) IN ('APCCA','APCAN','APCCS')
-- PJ20257329 2025.09.25 변경전 AND    NVL(I.ITEM_CLASS,'') <> ''
 AND    I.ITEM_CLASS IN ('ES0301', 'ES0302', 'ES0303', 'ES0305')    -- PJ20257329 2025.09.25 전극 ES0305 APCAS Anode(One Side)Panake class 추가
 AND    NVL(I.ITEM_TYPE,'*') NOT IN ('Q','R') --상품,원자재제외 -- I.ITEM_TYPE IN ('H','P')
 AND    NVL(CM.SCP_EXC_YN, '') != 'Y'    -- PJ20257329 2025.09.01 SCP Exclude Class 품목 제외
;

GRANT SELECT ON "SCM_MGR"."SCM_MST_FINAL_ITEM_ORIGIN_DIV_V" TO "SCMD_APP";


-- SCM_MGR.SCM_MST_FINAL_ITEM_V source
