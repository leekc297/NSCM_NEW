






CREATE VIEW [dbo].[SSP_MST_SITE_ITEM_EE_V] AS
/********************************************************************************************************************************
* VIEW NAME     : [SSP_MST_SITE_ITEM_EE_V]
* DESCRIPTION   : 전극 ITEM 정보 + 환산자 
* PROGRAM HISTORY
*--------------------------------------------------------------------------------------------------------------------------------
*  DATE      IN CHARGE           DESCRIPTION
*--------------------------------------------------------------------------------------------------------------------------------
* 2020.04.23   juhlee     Initial Release [PJ20199555]   공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 

--------------------------------------------------------------------------------------------------------------------------------
CELL_PER_METER  : METER당 CELL갯수  (1m 를 가지고 몇 Cell을 만드는지?) 
  : UOM이 EA인 경우(원각)   = SCP_MST_TACT_TIME.UOM_CONVERT_VALUE  ( SCP TACT TIME은 EA인 경우만 환산자 가지고 있음 FROM FP)  
  : UOM이  M인 경우(파우치) = SCP_MST_FINAL_ITEM.UOM_CONVERT_VALUE ( 대표적용모델의 소요량으로 계산된 값) 

METER_PER_CELL  : 1/CELL_PER_METER (1cell 만드는데 몇 m 소요되는지)

LANE            : 광폭고려된 LANE 수 ( LOOKUP_TYPE = 'ELECTRODE_LINE_WIDE_RATE') 

CONVERT_TO_PCM (Pancake m)           : Qty * METER_PER_CELL 				
CONVERT_TO_JRM (Jomboroll m)         : Qty * METER_PER_CELL / LANE


(활용) 
Pancake m   = qty * CONVERT_TO_PCM
Jomboroll m = qty * CONVERT_TO_JRM
cut         = qty * CONVERT_TO_PC_ROLL_LENGTH
cell        = qty * CONVERT_TO_CELL
********************************************************************************************************************************/
SELECT X.DIVISION_ID                        AS DIVISION_ID
,      X.COMPANY_ID                         AS COMPANY_ID
,      X.PLANT_ID                           AS PLANT_ID
,      X.SCM_SITE_ID                        AS SCM_SITE_ID
------------------------------------------------------------------  
,      X.ITEM_ID                            AS ITEM_ID
,      X.ITEM_ID_NICK_NAME                  AS ITEM_ID_NICK_NAME
,      X.ITEM_UOM                           AS ITEM_UOM 
,      X.ELECTRODE_TYPE                     AS ELECTRODE_TYPE
,      X.PACKAGE_TYPE                       AS PACKAGE_TYPE
,      X.PACKAGE_TYPE_CODE                  AS PACKAGE_TYPE_CODE 
,      X.DOM_EXP_TYPE                       AS DOM_EXP_TYPE
,      X.FACTORY_ID                         AS FACTORY_ID
,      X.FACTORY_NAME                       AS FACTORY_NAME
,      X.ELECTRODE_POST_OPER_CODE           AS ELECTRODE_POST_OPER_CODE
,      X.ELECTRODE_POST_OPER                AS ELECTRODE_POST_OPER
,      X.ELECTRODE_POST_OPER_LT             AS ELECTRODE_POST_OPER_LT
,      X.PC_ROLL_LENGTH                     AS PC_ROLL_LENGTH
    
,      X.BOX_PER_CUT                        AS BOX_PER_CUT
,      X.STEELCRATE_PER_CUT                 AS STEELCRATE_PER_CUT
,      X.STEELRACK_PER_CUT                  AS STEELRACK_PER_CUT

------------------------------------------------------------------  
,      X.MODEL_ID                           AS MODEL_ID
,      X.MODEL_ID_NICK_NAME                 AS MODEL_ID_NICK_NAME
,      X.CELL_TYPE_GROUP_CODE               AS CELL_TYPE_GROUP_CODE
,      X.CELL_TYPE                          AS CELL_TYPE 
------------------------------------------------------------------  
,      X.LANE                               AS LANE
-- UOM_CONVERT_IN_TACT_TIME : TACT TIME에 있는 실제 값 ( 전극 MASTER 컬럼의 CELL PER METER에 보여줌, 없을경우 TACT TIME등록 가이드 필요)  
,      X.UOM_CONVERT_IN_TACT_TIME           AS UOM_CONVERT_IN_TACT_TIME  
-- UOM_CONVERT: TACT TIME의 값 , CELL PER METER 와 동일 (계산오류 방지를 위해 NULL 이면 1 로 치환된 값임)
,      X.UOM_CONVERT                             AS UOM_CONVERT
,      X.CONVERT_QTY_CELL                        AS CONVERT_QTY_CELL-- CELL소요량 UOM 기준 
/*
,      X.UOM_CONVERT *  X.CONVERT_QTY_CELL       AS METER_PER_CELL --  
,      1/(X.UOM_CONVERT * X.CONVERT_QTY_CELL)    AS CELL_PER_METER 

,      X.UOM_CONVERT                             AS CONVERT_TO_PCM
,      X.UOM_CONVERT  / X.LANE                   AS CONVERT_TO_JRM
,      ISNULL(CASE WHEN X.ITEM_UOM ='M' THEN  1/ (X.UOM_CONVERT * X.CONVERT_QTY_CELL)  ELSE 1/X.CONVERT_QTY_CELL END, 1)                AS CONVERT_TO_CELL 
-- Confirm QTY(Cut) = 수량(PC) / (정권길이 * 팬케이크 cell/m *  레인수) 의 올림필요 (ex. 0.1 일경우 1개로 Cut)
,      1 / ( X.PC_ROLL_LENGTH *  1/(X.UOM_CONVERT * X.CONVERT_QTY_CELL) * X.LANE )  AS CONVERT_TO_PC_ROLL_LENGTH
,      1/(X.UOM_CONVERT * X.CONVERT_QTY_CELL)    AS METER_PER_CELL 
,      X.UOM_CONVERT *  X.CONVERT_QTY_CELL       AS CELL_PER_METER   
--,      ISNULL( CASE WHEN X.ITEM_UOM ='M' THEN 1/(X.UOM_CONVERT * X.CONVERT_QTY_CELL) ELSE   X.UOM_CONVERT END,  1)          AS METER_PER_CELL
--,      1/ISNULL( CASE WHEN X.ITEM_UOM ='M' THEN 1/(X.UOM_CONVERT * X.CONVERT_QTY_CELL) ELSE   X.UOM_CONVERT END,  1)        AS CELL_PER_METER
--,      X.UOM_CONVERT                             AS CONVERT_TO_PCM
--,      X.UOM_CONVERT  / X.LANE                   AS CONVERT_TO_JRM

*/
,      1/(X.UOM_CONVERT * X.CONVERT_QTY_CELL)    AS METER_PER_CELL 
,      X.UOM_CONVERT *  X.CONVERT_QTY_CELL       AS CELL_PER_METER   

,      1/X.UOM_CONVERT                             AS CONVERT_TO_PCM
,      1/X.UOM_CONVERT  / X.LANE                   AS CONVERT_TO_JRM

,      ISNULL(CASE WHEN X.ITEM_UOM ='M' THEN   X.UOM_CONVERT *  X.CONVERT_QTY_CELL ELSE 1/X.CONVERT_QTY_CELL END, 1)                AS CONVERT_TO_CELL 

-- Confirm QTY(Cut) POUCH = 수량(M)  / (정권길이 * 팬케이크 cell/m *  레인수) 의 올림필요 (ex. 0.1 일경우 1개로 Cut)
-- Confirm QTY(Cut) 원통  = 수량(EA) / (정권길이 * 레인수) 의 올림 값
,       ISNULL(CASE WHEN X.ITEM_UOM ='M' THEN   X.UOM_CONVERT *  X.CONVERT_QTY_CELL / X.PC_ROLL_LENGTH * ( 1/(X.UOM_CONVERT * X.CONVERT_QTY_CELL) ) /  X.LANE   
		                                 ELSE 
										        1/(X.PC_ROLL_LENGTH * X.LANE ) 
										 END ,1)                                AS CONVERT_TO_PC_ROLL_LENGTH

,      X.ASSY_DIVISION_ID
,      X.ASSY_SCM_SITE_ID
FROM ( 
		SELECT S.DIVISION_ID
		,      S.SCM_SITE_ID
		,      S.ITEM_ID

		,      MAX(MS.COMPANY_ID)             AS COMPANY_ID
		,      MAX(MS.PLANT_ID)               AS PLANT_ID

		,      MAX(U.ITEM_UOM)                AS ITEM_UOM 
		,      MAX(F.NICK_NAME)               AS ITEM_ID_NICK_NAME 
		,      MAX(F.ELECTRODE_TYPE)          AS ELECTRODE_TYPE

		,      MAX(F.CELL_ITEM_ID)            AS MODEL_ID
		,      MAX(CF.NICK_NAME)              AS MODEL_ID_NICK_NAME 
		,      MAX(CF.CELL_TYPE_GROUP_CODE )  AS CELL_TYPE_GROUP_CODE
		,      MAX(LC.SEGMENT2 )              AS CELL_TYPE 
		,      MIN(CASE WHEN T.ITEM_UOM = 'EA' THEN ISNULL(T.UOM_CONVERT_VALUE,1.0)   ELSE 1.0  END ) AS UOM_CONVERT


		,      MIN(T.UOM_CONVERT_VALUE)       AS UOM_CONVERT_IN_TACT_TIME
		,      CASE WHEN MIN(CONVERT(NUMERIC, ISNULL(T.ATTRIBUTE1,1.0)) / CONVERT(NUMERIC, ISNULL(L.ATTRIBUTE1,1.0)) ) = 0 THEN 1 
					ELSE MIN(CONVERT(NUMERIC, ISNULL(T.ATTRIBUTE1,1.0)) / CONVERT(NUMERIC, ISNULL(L.ATTRIBUTE1,1.0)) ) END           AS LANE  


		,      MIN(CASE WHEN F.CONVERT_QTY_CELL = 0 THEN 1 ELSE F.CONVERT_QTY_CELL END )                        AS CONVERT_QTY_CELL
		,      MIN(CASE WHEN ISNULL(M.PC_ROLL_LENGTH,1)= 0 THEN 1 ELSE ISNULL(M.PC_ROLL_LENGTH,1) END )         AS PC_ROLL_LENGTH 

		,      MIN(M.PC_ROLL_LENGTH)           AS PC_ROLL_LENGTH_org



		,      MAX(M.DOM_EXP_TYPE_CODE)       AS DOM_EXP_TYPE
		,      MAX(M.PACKAGE_TYPE_CODE)       AS PACKAGE_TYPE_CODE
		,      MAX(LP.SEGMENT2)               AS PACKAGE_TYPE
		,      MAX(M.FACTORY_ID)              AS FACTORY_ID
		,      MAX(B.FACTORY_NAME)            AS FACTORY_NAME

		,      MAX(M.ELECTRODE_POST_OPER_CODE) AS ELECTRODE_POST_OPER_CODE
		,      MAX(LO.SEGMENT4)                AS ELECTRODE_POST_OPER
		,      MAX(LO.SEGMENT5)                AS ELECTRODE_POST_OPER_LT
		,      MAX(M.BOX_PER_CUT)              AS BOX_PER_CUT
		,      MAX(M.STEELCRATE_PER_CUT)       AS STEELCRATE_PER_CUT
		,      MAX(M.STEELRACK_PER_CUT)        AS STEELRACK_PER_CUT
		,      MAX(LS.DIVISION_ID)             AS ASSY_DIVISION_ID 
		,      MAX(LS.SCM_SITE_ID)             AS ASSY_SCM_SITE_ID 
		FROM  SCM_MST_SITE_ITEM S WITH(NOLOCK) 

			JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
			  ON F.DIVISION_ID = S.DIVISION_ID 
			 AND F.ITEM_ID =     S.ITEM_ID 
			 AND F.OPERATION_GROUP ='E'

			JOIN ( SELECT DISTINCT DIVISION_ID , ITEM_ID , ITEM_UOM
				   FROM  SCM_MST_ITEM_SN  WITH(NOLOCK) 
				 ) U
			  ON U.DIVISION_ID = F.DIVISION_ID 
			 AND U.ITEM_ID     = F.ITEM_ID  

			JOIN SCP_MST_FINAL_ITEM CF WITH(NOLOCK)
			  ON 1=1 
			 --AND CF.DIVISION_ID = F.DIVISION_ID -- 해당사업부에 없는 모델이 있음 
			 AND CF.ITEM_ID     = F.CELL_ITEM_ID 

			JOIN SCM_MST_SITE MS WITH(NOLOCK) 
		  	  ON MS.DIVISION_ID = S.DIVISION_ID 
			 AND MS.SCM_SITE_ID = S.SCM_SITE_ID 
			 AND MS.SITE_TYPE   = 'PLANT'


			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LC WITH(NOLOCK) 
			  ON LC.LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE' 
			 AND LC.SEGMENT1    = CF.CELL_TYPE_GROUP_CODE			


			LEFT OUTER JOIN SCP_MST_TACT_TIME T WITH(NOLOCK)
			  ON T.DIVISION_ID   = S.DIVISION_ID 
			 AND T.PLANT_SITE_ID = S.SCM_SITE_ID 
			 AND T.ITEM_ID       = S.ITEM_ID 

			LEFT OUTER JOIN  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH (NOLOCK)
			  ON L.LOOKUP_TYPE = 'ELECTRODE_LINE_WIDE_RATE' -- 전극 라인 표준폭대비 광폭 배율 관리
			 AND L.SEGMENT1    = T.PLANT_SITE_ID 
			 AND L.SEGMENT4    = T.LINE_ID 

			LEFT OUTER JOIN SSP_MST_SHIP_MASTER_EE M WITH(NOLOCK) 
			  ON M.DIVISION_ID = S.DIVISION_ID 
			 AND M.SCM_SITE_ID = S.SCM_SITE_ID 
			 AND M.ITEM_ID     = S.ITEM_ID 

			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LP WITH(NOLOCK) 
			  ON LP.LOOKUP_TYPE = 'ELECTRODE_PACKAGE_TYPE' 
			 AND LP.SEGMENT1    = M.PACKAGE_TYPE_CODE

			LEFT OUTER JOIN SCM_MST_FACTORY_SN B WITH(NOLOCK) 
			 ON B.COMPANY_ID  = MS.COMPANY_ID
		    AND B.PLANT_ID    = MS.PLANT_ID
			AND B.DIVISION_ID = M.DIVISION_ID    
			AND B.FACTORY_ID  = M.FACTORY_ID 


			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LO WITH(NOLOCK) 
			  ON LO.LOOKUP_TYPE = 'ELECTRODE_POST_OPER_CODE' 
			 AND LO.SEGMENT1    = M.DIVISION_ID
			 AND LO.SEGMENT2    = M.ELECTRODE_POST_OPER_CODE


			 LEFT OUTER JOIN  SCM_ADM_LOOKUP_MASTER_DETAIL LA WITH(NOLOCK)  -- SEGMENT1:A_DIVISION_ID	,SEGMENT2 : A_PLANT_ID
				 ON LA.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
				AND LA.SEGMENT3 = MS.DIVISION_ID -- E_DIVISION_ID
				AND LA.SEGMENT4 = MS.PLANT_ID -- E_PLANT_ID
				AND LA.VALID_YN ='Y'

		    LEFT OUTER JOIN SCM_MST_SITE LS WITH(NOLOCK) 
		  	  ON LS.DIVISION_ID = LA.SEGMENT1 
			 AND LS.PLANT_ID    = LA.SEGMENT2 
			 AND LS.SITE_TYPE   = 'PLANT'
			 AND LS.OPERATION_GROUP = 'A'

		GROUP BY S.DIVISION_ID
		,        S.SCM_SITE_ID
		,        S.ITEM_ID

) X





