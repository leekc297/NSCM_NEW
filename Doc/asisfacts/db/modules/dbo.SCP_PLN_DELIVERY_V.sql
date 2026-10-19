





      
CREATE VIEW [dbo].[SCP_PLN_DELIVERY_V]      
AS      
/****************************************************************************      
  * PROJECT       : LG CHEM SCP PRJ.      
  * VIEW NAME     : SCP_PLN_DELIVERY_V      
  * DESCRIPTION   : 출하계획, 출하요청 
  *       
  *    S(출하) 조건은 
  *           셀   TO_SITE_ID 가   A_003 제외
  *           전극 TO_SITE_ID 가   E_003 제외
  *           팩   TO_SITE_ID 가 모두 고객이므로, S
  *    P(계획) 조건은 
  *           셀   TO_SITE_ID 가 A_001/A_002만
  *           전극  X
  *           팩    X 
  *-------------------------------------------------------------- 
  *    A_001 : 활성화후
  *    A_002 : 특성검사후
  *-------------------------------------------------------------- 
  *      
  * PROGRAM HISTORY      
  *--------------------------------------------------------------      
  *  DATE      IN CHARGE           DESCRIPTION      
  *--------------------------------------------------------------      
  * 2018.02.02   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트   
  * 2018.04.09   YYDOK       전극,셀에 대하여 003사이트 신규추가로 고려사항 반영
  *                          (제외대상): TO-SITE A-003,E-003인 출하계획은 사용하지 않음.
  * 2018.04.17   KTH         E~***->E~002, E~002->E~003으로 delivery가 발생하는 것은 출하계획 및 생산계획 둘다 제외
  * 2018.07.05   KTH         FROM_SITE_ID,TO_SITE_ID INCOTERMS 부분 제거,ORG_FROM_DIVISION_ID,ORG_TO_DIVISION_ID,ELECTRODE_TYPE 추가
  * 2018.07.10   KTH         SCM_MST_SITE에서 '-S' REPLACE 추가
  * 2018.07.17   KTH         FROM_SITE_ID LIKE '____-P%' 주석처리
  * 2018.07.19   KTH         SCP_ENG_DELIVERY_O_TEMP_SN 사용으로 현재 사용하지 않음.
  ****************************************************************************/      
  
  SELECT
         A.MASTER_ID      
        ,A.PLAN_ID        
        ,A.OUT_VERSION_ID 
        ,A.PLAN_NAME 
        ,A.DEMAND_ID
        ,A.ORG_DEMAND_ID
        ,A.DIVISION_ID                      
        ,A.PLAN_TYPE                     
        ,A.SEQ                         
        ,A.FROM_SITE_ID    AS FROM_SITE_ID
        ,A.TO_SITE_ID      AS TO_SITE_ID
        ,(CASE  WHEN FROM_SITE_ID LIKE '%-S%' THEN SUBSTRING(A.FROM_SITE_ID,1,CHARINDEX('~', FROM_SITE_ID)-1 ) ELSE FROM_SITE_ID END ) AS SCM_FROM_SITE_ID
        ,(CASE  WHEN TO_SITE_ID LIKE '%-S%' THEN SUBSTRING(A.TO_SITE_ID,1,CHARINDEX('~', TO_SITE_ID)-1 ) ELSE TO_SITE_ID END )  AS SCM_TO_SITE_ID
        ,SUBSTRING(TO_SITE_ID,CHARINDEX('~', TO_SITE_ID)-1,6) AS P_Flag
        ,(CASE  WHEN SUBSTRING(TO_SITE_ID,CHARINDEX('~', TO_SITE_ID)+1,3) NOT IN ('001','002','003')    THEN 'S'  -- 출하
--                WHEN (FROM_SITE_ID LIKE '____-P%')                                                      THEN 'S'  -- 팩일 경우 무조건 출하
                WHEN SUBSTRING(TO_SITE_ID,CHARINDEX('~', TO_SITE_ID)-1 ,6) IN ('A~001','A~002')         THEN 'P'  -- 생산 
           ELSE '-' END) AS SP_Flag     -- 출하계획/생산계획구분           
        ,A.ITEM_ID                           
        ,A.START_TIME       -- 출하계획시작일자 
        ,A.ORDER_ID                          
        ,A.COMPLETE_QTY     -- 출하완료수량 
        ,A.ALLOCATION_QTY   -- 출하요청수량   
        ,A.OPERATION_QTY    -- 출하계획수량   
        ,A.END_TIME               -- 출하계획종료일자
        ,(CASE WHEN dbo.FN_SCM_SPLIT(A.BOD_ID, 2,'::') = 'x' THEN NULL ELSE dbo.FN_SCM_SPLIT(A.BOD_ID, 2,'::') END) AS BOD_ID
        ,A.BOD_ID AS BOD_ID2
        ,A.FIX_TYPE             
        ,A.LPST                   -- 출하요청일
        ,A.EPST             
        ,Y.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID
        ,Z.DIVISION_ID AS ORIGIN_TO_DIVISION_ID
        ,C.ELECTRODE_TYPE
        ,C.OPERATION_GROUP
        ,A.CREATION_DATE        
        ,A.CREATED_BY        
        ,A.LAST_UPDATE_DATE        
        ,A.LAST_UPDATED_BY  
--        SELECT *          
          --FROM TH_EXP_DELIVERY_SN
    FROM SCP_ENG_DELIVERY_O_SN A WITH (NOLOCK)   
    INNER JOIN DBO.SCP_MST_FINAL_ITEM_V C  WITH (NOLOCK)      
            ON A.ITEM_ID          = C.ITEM_ID  
    LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   FROM_SITE_ID   -- SCM_MST_SITE_ENG
                 ON 0 = 0
--                AND Y.SITE_TYPE   = 'PLANT'    
                AND Y.SCM_SITE_ID  = REPLACE(SUBSTRING(A.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.FROM_SITE_ID) = 0  THEN LEN(A.FROM_SITE_ID) ELSE CHARINDEX('~', A.FROM_SITE_ID)  -1 END)),'-S','') 
                AND Y.VALID_YN ='Y'   
    LEFT OUTER JOIN DBO.SCM_MST_SITE Z  WITH (NOLOCK)       -- TO   TO_SITE_ID
                 ON 0 = 0
  --              AND Z.SITE_TYPE   = 'PLANT'    
                AND Z.SCM_SITE_ID  = REPLACE(SUBSTRING(A.TO_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.TO_SITE_ID) = 0  THEN LEN(A.TO_SITE_ID) ELSE CHARINDEX('~', A.TO_SITE_ID)  -1 END)),'-S','')
                AND Z.VALID_YN ='Y'    
                AND Y.DIVISION_ID  = Z.DIVISION_ID   -- EE 이면
   WHERE 1=1
     AND TO_SITE_ID NOT LIKE '%-003'   
     AND TO_SITE_ID NOT LIKE 'E-002'   


