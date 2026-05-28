/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0006.sql
 * Description  : Standalone Procedures — DMF0006 화면 (1개)
 *              : 향후 PKG_DMF0006로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA(
    p_division_id				IN VARCHAR2,
	p_dept_id					IN VARCHAR2,	--Department
    p_end_customer				IN VARCHAR2,	--Endcustomer
	p_scm_site_id				IN VARCHAR2,
    p_project_code				IN VARCHAR2,
	p_item_id					IN VARCHAR2,
	p_customer_project_code	IN VARCHAR2,
	p_customer_model			IN VARCHAR2,
	p_valid_yn					IN VARCHAR2,
	p_created_by				IN VARCHAR2,
	p_userinfo					IN VARCHAR2
)
AS
    v_err_msg   VARCHAR2(4000 CHAR);
    v_backtrace VARCHAR2(4000 CHAR);
    v_group_id  VARCHAR2(50 CHAR) := '';
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMPL_ITEMLIST'; -- TABLE VARIABLE @ItemList → GTT GT_DMPL_ITEMLIST

    --IF p_userinfo = 'ADMIN' OR p_userinfo = 'DM ADMIN'
    --	v_group_id := 'ADMIN'

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    IF NVL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL  
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = p_userinfo
			  ),0) > 0
		THEN
			v_group_id := 'ADMIN';
		END IF;
    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    --PJ2024-50461 Team Mapping(전체 수정)

    SELECT  
       A.DIVISION_ID,
       B.DIVISION_NAME,
       A.CUSTOMER_PROJECT_CODE,
       A.CUSTOMER_MODEL,
       A.SCM_SITE_ID,
       C.SITE_DESCRIPTION,
       DEPRTMENT.DEPT_ID AS UPPER_DEPT_ID,
       TEAM.DEPT_ID, 

       CASE WHEN NVL(TEAM.DEPT_ID, '') = '' OR INSTR(REVERSE(NVL(TEAM.DEPT_NAME_KO,'')), '.') = 0 THEN ''
        ELSE
       CASE WHEN NVL(TEAM.DEPT_NAME_KO,'') = '' THEN '' ELSE RIGHT(NVL(TEAM.DEPT_NAME_KO,''), INSTR(REVERSE(NVL(TEAM.DEPT_NAME_KO,'')), '.') -1) END
       END AS TEAM_INCHARGE,
       
       NVL(C.END_CUSTOMER,'') AS END_CUSTOMER,
       A.PROJECT_CODE,
       PJT.PROJECT_NAME,
       A.ITEM_ID,
       ITEM.ITEM_CLASS_NAME,
       NVL(ITEM.ITEM_NAME,'')AS ITEM_NAME,
       '0' AS CAPACITY, 
       A.CONVERT_QTY_PACK,
       A.CONVERT_QTY_MODULE,
       A.CONVERT_QTY_CELL,   
  
       A.VALID_YN,
       A.LAST_UPDATED_BY,
       A.LAST_UPDATE_DATE,
       CASE WHEN ((FN_GET_DEPT_LIST(p_created_by, TEAM.DEPT_ID) = 'Y') OR v_group_id ='ADMIN') THEN 'Y' ELSE '' END AS AUTHORITY_YN
    FROM  DM_MST_CUSTOMER_MODEL AS A 
    LEFT JOIN (SELECT * FROM SCM_MST_DIVISION  WHERE VALID_YN = 'Y') AS B 
    ON A.DIVISION_ID = B.DIVISION_ID
    INNER JOIN (SELECT * FROM SCM_MST_SITE  WHERE VALID_YN = 'Y') AS C 
    ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.SITE_TYPE = 'SALES'

    LEFT OUTER JOIN
    (
        SELECT * FROM SCM_MST_SITE_ITEM 
    ) AS SITE_ITEM
    ON A.DIVISION_ID = SITE_ITEM.DIVISION_ID
    AND A.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
    AND A.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
    AND A.ITEM_ID = SITE_ITEM.ITEM_ID
    LEFT JOIN (
        SELECT USER_ID, USER_NAME, USER_NAME_EN, DEPT_ID, DEPT_NAME_KO, UPPER_DEPT_ID 
        FROM SCM_MST_SSO_USER_INFO 
        INNER JOIN SCM_MST_SSO_DEPT_INFO 
        ON SCM_MST_SSO_USER_INFO.DEPT_ID = SCM_MST_SSO_DEPT_INFO.DEPT_ID
    ) AS TEAM
    ON      
    TEAM.USER_ID   IN (SELECT token FROM String_Split(SITE_ITEM.owner, ',') WHERE ROWNUM = 1)

    LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y') AS DEPRTMENT			       
    ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
    LEFT JOIN   
    (
      SELECT PJTS.DIVISION_ID, PJTS.PROJECT_CODE, PJTS.PROJECT_NAME, PJTS.PROJECT_VER_SEQ, PJTS.CAPACITY
      FROM SCM_MST_PROJECT PJTS 
      INNER JOIN 
      (
      SELECT DIVISION_ID, PROJECT_CODE, MAX(PROJECT_VER_SEQ) AS PROJECT_VER_SEQ
      FROM SCM_MST_PROJECT 
      GROUP BY DIVISION_ID, PROJECT_CODE
      ) PJTSG 
      ON PJTSG.DIVISION_ID = PJTS.DIVISION_ID AND PJTSG.PROJECT_CODE = PJTS.PROJECT_CODE AND PJTSG.PROJECT_VER_SEQ = PJTS.PROJECT_VER_SEQ
    )
    AS PJT 
    ON   A.DIVISION_ID = PJT.DIVISION_ID AND A.PROJECT_CODE = PJT.PROJECT_CODE
    WHERE  1=1        
            AND CASE WHEN p_division_id = 'ALL' THEN 'ALL'
           			 ELSE A.DIVISION_ID			
           		END IN (
                        Select data from UF_FX_String_SplitForIN (p_division_id,',') as P Where 
                       	(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.data
                       )
            AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
           			 ELSE TEAM.DEPT_ID			
           		END IN (
                        Select data from UF_FX_String_SplitForIN (p_dept_id,',') as P Where 
                       	(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
                       )
            AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
           			 ELSE NVL(C.END_CUSTOMER,'')			
           		END IN (
                        Select data from UF_FX_String_SplitForIN (p_end_customer,',') as P Where 
                       	(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER,'') END) = P.data
                       )				   
            AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
           			 ELSE A.SCM_SITE_ID			
           		END IN (
                        Select data from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where 
                       	(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.data
                       )	
            AND CASE WHEN p_project_code = '' THEN ''
           			 ELSE A.PROJECT_CODE			
           		END IN (
                        Select data from UF_FX_String_SplitForIN (p_project_code,',') as P Where 
                       	(CASE WHEN p_project_code = '' THEN '' ELSE A.PROJECT_CODE END) = P.data
                       )
            AND CASE WHEN p_valid_yn = 'ALL' THEN 'ALL'
                     ELSE A.VALID_YN
                END = p_valid_yn

            AND Exists (Select 1 from UF_FX_String_Split (p_item_id,',') as P Where A.ITEM_ID LIKE '%' || P.token ||'%')
            AND Exists (Select 1 from UF_FX_String_Split (p_customer_project_code,',') as P Where A.CUSTOMER_PROJECT_CODE LIKE '%' || P.token ||'%')
            AND Exists (Select 1 from UF_FX_String_Split (p_customer_model,',') as P Where A.CUSTOMER_MODEL LIKE '%' || P.token ||'%')
            ORDER BY A.DIVISION_ID, DEPRTMENT.DEPT_ID, C.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE, A.CUSTOMER_PROJECT_CODE, A.CUSTOMER_MODEL, A.ITEM_ID, ITEM.ITEM_CLASS_NAME;

    COMMIT;
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
EXCEPTION
    WHEN OTHERS THEN
        v_err_msg   := SQLERRM;
        v_backtrace := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA failed: ' || v_err_msg);
END DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA;
/
