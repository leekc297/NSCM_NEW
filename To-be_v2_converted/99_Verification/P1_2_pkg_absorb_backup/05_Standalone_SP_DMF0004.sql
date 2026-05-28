/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0004.sql
 * Description  : Standalone Procedures — DMF0004 화면 (9개)
 *              : 향후 PKG_DMF0004로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0004_GET_SALES_SITE_BUCKET_DATA (
    P_DIVISION_ID   IN VARCHAR2
   ,P_SCM_SITE_ID   IN VARCHAR2
   ,P_CREATED_BY    IN VARCHAR2
   ,P_USERINFO      IN VARCHAR2
  
	 ,O_CURSOR		    OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* PROGRAM ID  : DMF0004_GET_SALES_SITE_BUCKET_DATA                                                 */
/* DESCRIPTION : PROCEDURE 작성 가이드                                                                */
/* USAGE       : PROCEDURE 작성 시 참조하세요!                                                         */
/* PARAMETER   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* DATE        IN CHARGE    DESCRIPTION                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/11/30  DWPARK       INITIAL RELEASE [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트      */
/* 2018/05/30  JYE      복수 팀 권한 관련  수정                                                         */
/* 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리                                              */
/* 20221024   ROSIA27   [C20221024-000510]DM UI 소스 정리 요청                                         */
/* 2026-03-10  SSLEE       [PJ20264226] NEXTSCM PILOT 설계 및 개발                                    */
/****************************************************************************************************/
    V_GROUP_ID      VARCHAR2(50 CHAR) := '@#@#@#';
    
    V_ADMIN_CNT     PLS_INTEGER := 0;
    
BEGIN


    --IF P_USERINFO = 'ADMIN' OR P_USERINFO = 'DM ADMIN'
    --    V_GROUP_ID := 'ADMIN'

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    BEGIN
        V_ADMIN_CNT := 0;

        SELECT COUNT(1)
          INTO V_ADMIN_CNT
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL  
         WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
           AND VALID_YN = 'Y'
           AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM PLANNER (W/S) 제외 / 주석처리인경우 DM PLANNER (W/S) 포함 
           AND SEGMENT1 = P_USERINFO
          ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_ADMIN_CNT := 0;
    END;
            
    IF V_ADMIN_CNT > 0 THEN
        V_GROUP_ID := 'ADMIN';
    END IF;
    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    OPEN O_CURSOR FOR
    SELECT MA.DIVISION_ID 
          ,MA.SCM_SITE_ID
          ,MA.INCOTERMS
          ,MA.D_MON
          ,MA.D_TUE
          ,MA.D_WED
          ,MA.D_THU
          ,MA.D_FRI
          ,MA.D_SAT
          ,MA.D_SUN
          ,MA.LAST_UPDATE_DATE
          ,MA.LAST_UPDATED_BY
          ,CASE WHEN MA.DIVISION_ID <> '40' AND ((FN_GET_DEPT_LIST(P_CREATED_BY, ST.DEPT_ID) = 'Y') OR V_GROUP_ID = 'ADMIN')  THEN 'Y'
                WHEN MA.DIVISION_ID = '40' AND ((FN_GET_DEPT_LIST2(P_CREATED_BY, ST.SCM_SITE_ID) = 'Y') OR V_GROUP_ID = 'ADMIN'
                                                 OR P_CREATED_BY = MA.LAST_UPDATED_BY) THEN 'Y'
                ELSE ''
           END AS EDIT_FLAG
    FROM (SELECT B.DIVISION_ID
                ,B.SCM_SITE_ID
                ,B.INCOTERMS
                ,MAX(CASE WHEN B.YYYYMMDD = 'MON' THEN B.BUCKET_PER ELSE '' END) AS D_MON
                ,MAX(CASE WHEN B.YYYYMMDD = 'TUE' THEN B.BUCKET_PER ELSE '' END) AS D_TUE
                ,MAX(CASE WHEN B.YYYYMMDD = 'WED' THEN B.BUCKET_PER ELSE '' END) AS D_WED
                ,MAX(CASE WHEN B.YYYYMMDD = 'THU' THEN B.BUCKET_PER ELSE '' END) AS D_THU
                ,MAX(CASE WHEN B.YYYYMMDD = 'FRI' THEN B.BUCKET_PER ELSE '' END) AS D_FRI
                ,MAX(CASE WHEN B.YYYYMMDD = 'SAT' THEN B.BUCKET_PER ELSE '' END) AS D_SAT
                ,MAX(CASE WHEN B.YYYYMMDD = 'SUN' THEN B.BUCKET_PER ELSE '' END) AS D_SUN
                ,MAX(B.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
                ,MAX(B.LAST_UPDATED_BY)  AS LAST_UPDATED_BY
            FROM DM_MST_BUCKET_CONVERSION B  
           WHERE 1 = 1
             AND B.CONVERSION_TYPE = 'WTOD'
             AND B.DIVISION_ID     = P_DIVISION_ID
             AND B.SCM_SITE_ID     = P_SCM_SITE_ID
           GROUP BY B.DIVISION_ID
                   ,B.SCM_SITE_ID
                   ,B.INCOTERMS
         ) MA
          INNER JOIN (SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.DEPT_ID
                        FROM SCM_MGR.SCM_MST_SITE A
                             LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                                  ON A.DIVISION_ID = B.DIVISION_ID 
                                 AND A.SCM_SITE_ID = B.SCM_SITE_ID 
                       WHERE 1=1
                       GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, B.DEPT_ID) ST 
               ON ST.DIVISION_ID = MA.DIVISION_ID
              AND ST.SCM_SITE_ID = MA.SCM_SITE_ID
    ;
    



END DMF0004_GET_SALES_SITE_BUCKET_DATA;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0004_GET_SALES_SITE_CUSTOMER_DATA(
    P_DIVISION_ID     IN VARCHAR2
   ,P_SCM_SITE_ID     IN VARCHAR2  --FCST TYPE
   ,P_ACTIVE_FLAG     IN VARCHAR2
   ,P_CREATED_BY      IN VARCHAR2 
   ,P_USERINFO        IN VARCHAR2
  
	 ,O_CURSOR		      OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* PROGRAM ID  : DM0004_GET_SALES_SITE_CUSTOMER_DATA                                                         */
/* DESCRIPTION : PROCEDURE 작성 가이드                                                              */
/* USAGE       : PROCEDURE 작성 시 참조하세요!                                                      */
/* PARAMETER   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* DATE        IN CHARGE    DESCRIPTION                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/11/30  DWPARK       INITIAL RELEASE [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/05/30  JYE			복수 팀 권한 관련  수정  
** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
*/
/* 2026-03-10  SSLEE       [PJ20264226] NEXTSCM PILOT 설계 및 개발                                    */
/****************************************************************************************************/
    V_GROUP_ID        VARCHAR2(50 CHAR) := '@#@#@#';
    
    V_ADMIN_CNT       PLS_INTEGER := 0;

BEGIN

    --IF P_USERINFO = 'ADMIN' OR P_USERINFO = 'DM ADMIN'
    --    V_GROUP_ID := 'ADMIN'

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    BEGIN
        V_ADMIN_CNT := 0;

        SELECT COUNT(1)
          INTO V_ADMIN_CNT
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL  
         WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
           AND VALID_YN = 'Y'
           AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM PLANNER (W/S) 제외 / 주석처리인경우 DM PLANNER (W/S) 포함 
           AND SEGMENT1 = P_USERINFO
          ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_ADMIN_CNT := 0;
    END;
    
    IF V_ADMIN_CNT > 0 THEN
        V_GROUP_ID := 'ADMIN';
    END IF;
    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------
    
    OPEN O_CURSOR FOR
    SELECT S.DIVISION_ID
          ,S.SCM_SITE_ID
          ,S.SOLDTO_CODE
          ,C.SOLDTO_DESCRIPTION
          ,S.SHIPTO_CODE
          ,C.SHIPTO_DESCRIPTION
          ,C.SHIPTO_REGION_NAME
          ,C.SHIPTO_CITY_NAME
          ,S.REP_YN
          ,S.VALID_YN
          ,S.LAST_UPDATE_DATE
          ,S.LAST_UPDATED_BY
          ,CASE WHEN S.DIVISION_ID <> '40' AND ((FN_GET_DEPT_LIST(P_CREATED_BY, ST.DEPT_ID) = 'Y') OR V_GROUP_ID = 'ADMIN')  THEN 'Y'
                WHEN S.DIVISION_ID = '40' AND ((FN_GET_DEPT_LIST2(P_CREATED_BY, ST.SCM_SITE_ID) = 'Y') OR V_GROUP_ID = 'ADMIN'
                                                OR P_CREATED_BY = S.LAST_UPDATED_BY) THEN 'Y'
                ELSE ''
           END             AS EDIT_FLAG
      FROM SCM_MST_SITE_CUSTOMER S  
           LEFT JOIN SCM_MST_CUSTOMER C  
                ON S.DIVISION_ID = C.DIVISION_ID
               AND S.SOLDTO_CODE = C.SOLDTO_CODE
               AND S.SHIPTO_CODE = C.SHIPTO_CODE
           INNER JOIN (SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.DEPT_ID
                         FROM SCM_MGR.SCM_MST_SITE A
                              LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                                   ON A.DIVISION_ID = B.DIVISION_ID 
                                  AND A.SCM_SITE_ID = B.SCM_SITE_ID 
                        WHERE 1=1
                        GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, B.DEPT_ID) ST  
                ON ST.DIVISION_ID = S.DIVISION_ID
               AND ST.SCM_SITE_ID = S.SCM_SITE_ID
     WHERE S.DIVISION_ID = P_DIVISION_ID
       AND S.SCM_SITE_ID = P_SCM_SITE_ID
       AND CASE WHEN P_ACTIVE_FLAG = 'ALL' OR P_ACTIVE_FLAG = '' OR P_ACTIVE_FLAG IS NULL THEN P_ACTIVE_FLAG            
                ELSE S.VALID_YN
           END = P_ACTIVE_FLAG
    ;
    
END DMF0004_GET_SALES_SITE_CUSTOMER_DATA;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0004_GET_SALES_SITE_LOCATION_DATA
(
	p_division_id	VARCHAR2,
	p_scm_site_id    VARCHAR2,
	p_active_flag    VARCHAR2,
  	p_created_by	VARCHAR2,
	p_userinfo		VARCHAR2
/****************************************************************************************************/
)
AS


    v_group_id VARCHAR2(50 CHAR) := NULL;
    v_cnt_1  INTEGER := 0;
BEGIN

	--	v_group_id := 'ADMIN'

	-- ------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	-- ------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	where LOOKUP_TYPE = 'GET_ADMIN_GROUP'
	AND VALID_YN = 'Y'
	AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
	AND SEGMENT1 = p_userinfo;
	IF v_cnt_1 > 0 THEN
			v_group_id := 'ADMIN';
		END IF;
	-- ------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	-- ------------------------------------------------------------------------------
	SELECT  L.LOCATION_SEQ
	      , L.DIVISION_ID
	      , D.DIVISION_NAME
		  , L.SCM_SITE_ID
	      , L.LOCATION_CODE
		  --, L.LOCATION_DESCRIPTION
		  , (select max(STORAGE_DESCRIPTION) from scm_mst_sloc sloc  where sloc.DIVISION_ID = L.DIVISION_ID and sloc.STORAGE_ID = L.STORAGE_ID and sloc.Plant_id = L.PLANT_ID) as LOCATION_DESCRIPTION -- 20180704 임시처리. 저장 처리 후 복구
		  , STORAGE_ID
		  , L.PLANT_ID
		  , L.VALID_YN
	      , L.LAST_UPDATED_BY
	      , L.LAST_UPDATE_DATE
		 -- , CASE WHEN ((FN_GET_DEPT_LIST(p_created_by, ST.DEPT_ID) = 'Y') OR v_group_id ='ADMIN')
			--THEN 'Y' ELSE '' END AS EDIT_FLAG
		   , CASE WHEN L.DIVISION_ID <> '40' AND ((FN_GET_DEPT_LIST(p_created_by, ST.DEPT_ID) = 'Y') OR v_group_id ='ADMIN')  THEN 'Y'
	            WHEN L.DIVISION_ID = '40' AND((FN_GET_DEPT_LIST2(p_created_by, ST.SCM_SITE_ID) = 'Y') OR v_group_id ='ADMIN'
				OR p_created_by = L.LAST_UPDATED_BY)  THEN 'Y' ELSE '' END AS EDIT_FLAG
    FROM SCM_MST_LOCATION L
			INNER JOIN SCM_MST_DIVISION D
			ON L.DIVISION_ID = D.DIVISION_ID
			INNER JOIN SCM_MST_SITE ST
			ON ST.DIVISION_ID = L.DIVISION_ID and ST.SCM_SITE_ID = L.SCM_SITE_ID
    WHERE  L.DIVISION_ID = p_division_id
	AND     L.SCM_SITE_ID = p_scm_site_id
	AND     CASE WHEN p_active_flag = 'ALL' OR p_active_flag IS NULL THEN p_active_flag
                 ELSE L.VALID_YN
 	        END  =  p_active_flag


END;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0004_GET_SOLDTO_CUSTOMER_DATA
(
  p_division_id  VARCHAR2,
  p_dept_id   VARCHAR2
/****************************************************************************************************/
)
AS
BEGIN

  	IF (p_division_id = '40') THEN
		SELECT --SITE.SCM_SITE_ID,
			SITE.SOLDTO_CUSTOMER AS CODE
			, SITE.SOLDTO_CUSTOMER AS NAME
			--, STEAM.DEPT_ID
			--, SITE.END_CUSTOMER
		FROM SCM_MST_SITE SITE
		INNER JOIN (
			SELECT SI.DIVISION_ID
				,SI.SCM_SITE_ID
				,SI.ITEM_ID
				,SU.DEPT_ID
			FROM SCM_MST_SITE_ITEM SI
				,SCM_MST_SSO_USER_INFO SU
				,SCM_MST_SSO_DEPT_INFO TM
			WHERE SI.DIVISION_ID = p_division_id
			AND SI.OWNER = SU.USER_ID
			AND SU.DEPT_ID = TM.DEPT_ID
		) AS STEAM
		ON SITE.SCM_SITE_ID = STEAM.SCM_SITE_ID
		WHERE SITE.DIVISION_ID = p_division_id
			AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
					ELSE STEAM.DEPT_ID
				END IN (
					Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
						(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE STEAM.DEPT_ID END) = P.data
					)
		GROUP BY SITE.SOLDTO_CUSTOMER
		ORDER BY SITE.SOLDTO_CUSTOMER;
	ELSE
		SELECT
			SOLDTO_CUSTOMER AS CODE
			, SOLDTO_CUSTOMER AS NAME
			--, SITE.DEPT_ID
		FROM SCM_MST_SITE SITE --94
		INNER JOIN SCM_MST_SSO_DEPT_INFO DEPT_INFO
		ON SITE.DEPT_ID = DEPT_INFO.DEPT_ID
		WHERE DIVISION_ID = p_division_id
			AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
					ELSE DEPT_INFO.DEPT_ID
				END IN (
					Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
						(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE DEPT_INFO.DEPT_ID END) = P.data
					)
			AND SOLDTO_CUSTOMER IS NOT NULL
		GROUP BY SOLDTO_CUSTOMER;
	END IF;

END;
/
