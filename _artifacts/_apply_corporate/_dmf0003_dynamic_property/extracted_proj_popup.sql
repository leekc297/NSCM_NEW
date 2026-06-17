  401| PROCEDURE P_COM0005_GET_PROJECT_BY_DIVISION_POPUP(
  402|   	p_division_id   IN 	VARCHAR2,
  403|   	p_dept_id       IN 	VARCHAR2,
  404|   	p_end_customer  IN 	VARCHAR2,
  405|   	p_scm_site_id  	IN 	VARCHAR2,
  406|   	p_project_code  IN 	VARCHAR2,
  407|   	p_etc		   	IN 	VARCHAR2,
  408|   	o_rc1 			OUT SYS_REFCURSOR,
  409| 	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
  410| )
  411| /*
  412|  * Program ID   : PKG_COM0000
  413|  * Description  : P_COM0005_GET_PROJECT_BY_DIVISION_POPUP
  414|  * Program History
  415|  *===========================================================================================================
  416|  *   Date       In Charge      Description
  417|  *===========================================================================================================
  418|  * 2026.03.16   park.choyi     [PJ20264226] NextSCM Pilot 설계 및 개발
  419|  */
  420| AS
  421| BEGIN
  422|   IF p_etc = 'N' THEN
  423|     OPEN o_rc1 FOR
  424|       SELECT A.DIVISION_ID
  425|            , D.DIVISION_NAME                      AS DIVISION_NAME
  426|            , A.PROJECT_CODE
  427|            , A.PROJECT_NAME
  428|            , A.PROJECT_STATUS
  429|            , BIZ.CODE                             AS BIZ_TYPE
  430|            , BIZ.NAME                             AS BIZ_TYPE_NAME
  431|            , A.CURRENCY
  432|            , MAX(A.PROJECT_VER_SEQ)               AS PROJECT_VER_SEQ
  433|            , A.PROJECT_OWNER
  434|            , TEAM.DEPT_ID
  435|            , TEAM.DEPT_NAME_KO
  436|            , C.END_CUSTOMER
  437|       FROM SCM_MST_PROJECT A
  438|       LEFT JOIN (SELECT * FROM SCM_MST_DIVISION WHERE VALID_YN = 'Y') D
  439|         ON A.DROP_YN = 'N'
  440|        AND A.DIVISION_ID = D.DIVISION_ID
  441|       LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM WHERE VALID_YN = 'Y') B
  442|         ON A.DIVISION_ID = B.DIVISION_ID
  443|        AND A.PROJECT_CODE = B.PROJECT_CODE
  444|       LEFT JOIN (
  445|           SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER
  446|           FROM SCM_MST_SITE
  447|           WHERE VALID_YN = 'Y'
  448|       ) C
  449|         ON B.DIVISION_ID = C.DIVISION_ID
  450|        AND B.SCM_SITE_ID = C.SCM_SITE_ID
  451|       LEFT JOIN SCM_MST_SSO_USER_INFO SU
  452|         ON SU.USER_ID = B.OWNER
  453| --        	(
  454| --
  455| --             SELECT COLUMN_VALUE
  456| --             FROM TABLE(String_Split(B.OWNER, ','))
  457| --             FETCH FIRST 1 ROWS ONLY
  458| --           )
  459|       LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y') TEAM
  460|         ON SU.DEPT_ID = TEAM.DEPT_ID
  461|       LEFT JOIN (
  462|           SELECT SEGMENT1 AS CODE
  463|                , SEGMENT2 AS NAME
  464|           FROM SCM_ADM_LOOKUP_MASTER_DETAIL
  465|           WHERE LOOKUP_TYPE = 'BIZ_TYPE_BPMS'
  466|       ) BIZ
  467|         ON BIZ.CODE = A.BIZ_TYPE
  468|       WHERE TEAM.DEPT_ID IS NOT NULL
  469|         AND (p_division_id = 'ALL' OR A.DIVISION_ID IN (
  470|               SELECT P.COLUMN_VALUE
  471|               FROM TABLE(UF_FX_String_SplitForIN(p_division_id, ',')) P
  472|             ))
  473|     	AND (p_dept_id = 'ALL' OR SU.DEPT_ID IN (
  474|               SELECT P.COLUMN_VALUE
  475|               FROM TABLE(UF_FX_String_SplitForIN(p_dept_id, ',')) P
  476|             ))
  477|         AND (p_end_customer = 'ALL' OR NVL(C.END_CUSTOMER, '') IN (
  478|               SELECT P.COLUMN_VALUE
  479|               FROM TABLE(UF_FX_String_SplitForIN(p_end_customer, ',')) P
  480|             ))
  481|         AND (p_scm_site_id = 'ALL' OR C.SCM_SITE_ID IN (
  482|               SELECT P.COLUMN_VALUE
  483|               FROM TABLE(UF_FX_String_SplitForIN(p_scm_site_id, ',')) P
  484|             ))
  485|         AND (
  486|         	  p_project_code = '' OR p_project_code IS NULL
  487|         	  OR
  488|               EXISTS (
  489|                 SELECT 1
  490|                 FROM TABLE(UF_FX_String_Split(p_project_code, ',')) P
  491|                 WHERE A.PROJECT_CODE LIKE P.TOKEN || '%'
  492|               )
  493|               OR
  494|               EXISTS (
  495|                 SELECT 1
  496|                 FROM TABLE(UF_FX_String_Split(p_project_code, ',')) P
  497|                 WHERE A.PROJECT_NAME LIKE P.TOKEN || '%'
  498|               )
  499|             )
  500|       GROUP BY A.DIVISION_ID
  501|              , D.DIVISION_NAME
  502|              , A.PROJECT_CODE
  503|              , A.PROJECT_NAME
  504|              , A.PROJECT_STATUS
  505|              , A.BIZ_TYPE
  506|              , A.BIZ_TYPE_NAME
  507|              , BIZ.CODE
  508|              , BIZ.NAME
  509|              , A.CURRENCY
  510|              , A.PROJECT_OWNER
  511|              , TEAM.DEPT_ID
  512|              , TEAM.DEPT_NAME_KO
  513|              , C.END_CUSTOMER
  514|       ORDER BY A.PROJECT_NAME
  515|              , A.PROJECT_CODE;
  516|   ELSE
  517|     OPEN o_rc1 FOR
  518|       SELECT A.SEGMENT1 AS DIVISION_ID
  519|            , A.SEGMENT1 AS DIVISION_NAME
  520|            , A.SEGMENT2 AS PROJECT_CODE
  521|            , A.SEGMENT3 AS PROJECT_NAME
  522|            , ''         AS PROJECT_STATUS
  523|            , ''         AS BIZ_TYPE
  524|            , ''         AS BIZ_TYPE_NAME
  525|            , ''         AS CURRENCY
  526|            , ''         AS PROJECT_VER_SEQ
  527|            , ''         AS PROJECT_OWNER
  528|            , ''         AS DEPT_ID
  529|            , ''         AS DEPT_NAME_KO
  530|            , ''         AS END_CUSTOMER
  531|       FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
  532|       WHERE A.LOOKUP_TYPE = 'DM_ETC_Project'
  533|         AND A.VALID_YN = 'Y'
  534|         AND A.SEGMENT1 = p_division_id
  535|         AND EXISTS (
  536|               SELECT 1
  537|               FROM TABLE(UF_FX_String_Split(p_project_code, ',')) P
  538|               WHERE A.SEGMENT2 LIKE P.TOKEN || '%'
  539|             );
  540|   END IF;
  541| 
  542| 	OPEN O_RESULT_CURSOR FOR
  543| 		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;
  544| 
  545| 	EXCEPTION
  546| 	    WHEN OTHERS THEN
  547| 	        RAISE_APPLICATION_ERROR(-20001,
  548| 	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
  549| 	        ' / SQLERRM=' || SQLERRM ||
  550| 	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
  551| 	        ' / PARAMS=' || '-' );
  552| 
  553| END P_COM0005_GET_PROJECT_BY_DIVISION_POPUP;
