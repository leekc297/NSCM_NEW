-- PKG_SCP0122 — 생성: tools/Harness/gen-pkg.js 2026-10-22 · 화면 SCP0122→SCP0122 PlanActivityMgmt · As-is SP 3개
-- 이식 규칙: Doc/_dev_rules(DB 변환 규칙) · To-be_v2_converted/06_Packages 선례 · ISNULL→NVL, GETDATE→SYSDATE, TOP n→FETCH FIRST n ROWS ONLY, +(문자열)→||, CONVERT→TO_CHAR/TO_DATE, 임시테이블→GTT/WITH, @@ROWCOUNT→SQL%ROWCOUNT · ⭐ 널 센티널 = '/' (ISNULL(x,'')→NVL(x,'/') · 원래 '-' 데이터 유지 · 과도기 빈값 IN ('-','/') — 사용자 2026-10-15, check-pkg P39/P40, port_pkg.md §센티널)
-- 배포 후: SCP0122_registration.sql 재실행(PROC_M 이 ALL_ARGUMENTS 로 확정) → FE pnpm gen:procedures
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCP0122
AS
    PROCEDURE P_SCP0121_GET_SEARCH_INFO (
        P_USER_ID        IN  VARCHAR2,  -- As-is @p_user_id nvarchar(600)
        O_RC1            OUT SYS_REFCURSOR,
        O_RC2            OUT SYS_REFCURSOR,
        O_RC3            OUT SYS_REFCURSOR,
        O_RC4            OUT SYS_REFCURSOR,
        O_RC5            OUT SYS_REFCURSOR,
        O_RC6            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0122_GET_PLAN_ACTIVITY_MGMT (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_PLAN_GROUP_ID  IN  VARCHAR2,  -- As-is @p_plan_group_id nvarchar(-1)
        P_PRS_CD         IN  VARCHAR2,  -- As-is @p_prs_cd nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT (
        P_DATA           IN  CLOB,            -- 그리드 변경행 JSON 배열(FE sendRows) — As-is: @p_active_flag, @p_prs_cd, @p_plan_gr_id, @p_actv_cd, @p_actv_seq, @p_pre_actv_cd, @p_user_id
        P_USER_ID        IN  VARCHAR2,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );
END PKG_SCP0122;
/

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCP0122
AS
/*
 * Program ID   : P_SCP0121_GET_SEARCH_INFO
 * Description  : SCP0122 PlanActivityMgmt — As-is SCP0121_GET_SEARCH_INFO 이식 (GET, 시트 'Plan Activity Mgmt' / 버튼 SEARCH_INFO)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.22   harness        [TobeGen] 골격 생성 — SQL 본문 이식 TODO
 */
PROCEDURE P_SCP0121_GET_SEARCH_INFO (
        P_USER_ID        IN  VARCHAR2,  -- As-is @p_user_id nvarchar(600)
        O_RC1            OUT SYS_REFCURSOR,
        O_RC2            OUT SYS_REFCURSOR,
        O_RC3            OUT SYS_REFCURSOR,
        O_RC4            OUT SYS_REFCURSOR,
        O_RC5            OUT SYS_REFCURSOR,
        O_RC6            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사(As-is 에서 NOT NULL 로 쓰이는 파라미터만 남길 것)
    IF P_USER_ID IS NULL THEN RAISE_INVALID('USER_ID IS NULL'); END IF;

    OPEN O_RC1 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0121_GET_SEARCH_INFO 결과셋 1

    OPEN O_RC2 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0121_GET_SEARCH_INFO 결과셋 2

    OPEN O_RC3 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0121_GET_SEARCH_INFO 결과셋 3

    OPEN O_RC4 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0121_GET_SEARCH_INFO 결과셋 4

    OPEN O_RC5 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0121_GET_SEARCH_INFO 결과셋 5

    OPEN O_RC6 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0121_GET_SEARCH_INFO 결과셋 6

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0121_GET_SEARCH_INFO] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_USER_ID='||P_USER_ID);
END P_SCP0121_GET_SEARCH_INFO;

/* ===== ASIS SCP0121_GET_SEARCH_INFO (dbo) — 이식 후 이 블록은 삭제 =====
/*
 * Program ID   : SCP0121_GET_SEARCH_INFO
 * Description  : 전극(EE)을 포하함한 조회 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/21   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/05   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Target 대상, Onwer 정보 추가
 * 2025/06/25   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - MKT FCST Version 정보 추가
 * 2025/09/03   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 사업부별 Operation 룩업으로부터 Operation 및 라인 표시, Plan Group 검색조건에 삭제한 Plan Group 미표시, OSP Plant 및 라인도 표시
 * 2025/10/20   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan Group 검색조건 정렬 방식 변경(Group Code → Group Name)
 *
 * /

CREATE PROCEDURE [dbo].[SCP0121_GET_SEARCH_INFO]
  
	@p_user_id				NVARCHAR(300) = ''
AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF object_id('tempdb..#division_info') IS NOT NULL DROP TABLE #division_info;
	IF object_id('tempdb..#line_master') IS NOT NULL DROP TABLE #line_master;

	select d.division_id
		 , r.division_id	as org_division_id 
		 , d.attribute3		as division_dv
	INTO #division_info
	from scm_mst_division d with(nolock)
		  inner join scm_mst_division r with(nolock)
				  on d.attribute4 = r.attribute4
				 and ( (d.attribute3 != 'EE' and d.division_id = r.division_id)
					  or
					   (d.attribute3 = 'EE'  and r.attribute3 != 'EE') 
					 ) 
	where 1=1
	  and d.valid_yn = 'Y'
	  and r.valid_yn = 'Y'
	;

	select l.company_id
		,l.division_id
		,l.site_id
		,l.plant_id
		,l.factory_id
		,f.factory_name
		,l.operation_id
		,l.line_id
		,max(l.line_name) as line_name 
	INTO #line_master
	from scm_mst_line_sn l with(nolock)
		inner join scm_mst_factory_sn f with(nolock)
				on f.company_id = l.company_id
				and f.factory_id = l.factory_id 
	where 1=1
	and exists (select *
					from scm_adm_lookup_master_detail  op with(nolock)
					where 1=1
					  and op.lookup_type = 'SCP_PLAN_OPERATION'
					  and op.valid_yn = 'Y'
					  and op.segment1 = l.operation_id
					  and op.segment4 like concat('%', l.division_id, '%')) 
	and l.active_flag =  'Y'
	group by l.company_id
			,l.division_id
			,l.site_id
			,l.plant_id
			,l.factory_id
			,f.factory_name
			,l.operation_id
			,l.line_id
		;

	--[PJ20257329] 사업부별 Operation 룩업으로부터 Operation 및 라인 표시, OSP Plant 및 라인도 표시(2025-09-03) START
	IF object_id('tempdb..#osp_plant_info') IS NOT NULL DROP TABLE #osp_plant_info;

	select site.plant_id, V.VENDOR_NAME AS plant_name, osp.*
	  into #osp_plant_info
	  from SCM_MST_LINE_OSP osp with(nolock)
      join scm_mst_site site with(nolock)
        on osp.division_id = site.division_id
       and osp.scm_site_id = site.scm_site_id
	  LEFT OUTER JOIN  SCM_MST_VENDOR V  WITH(NOLOCK) 
	    ON V.VENDOR_CODE = site.plant_id AND site.COMPANY_ID = V.COMPANY_ID
     where osp.valid_yn = 'Y' and site.valid_yn = 'Y'

	--1. Plant id 정보
	select distinct l.plant_id				AS CODE
		, l.plant_id + ' ' + p.PLANT_NAME	AS NAME
		, d.division_id
		, d.org_division_id 
		, 1 AS SEQ
	from #line_master l with(nolock)
	inner join #division_info d 
		on l.division_id = d.org_division_id
		and l.operation_id = case when d.division_dv  = 'EE'
									then 'E2000'
									else l.operation_id
								end 
		and l.operation_id != case when d.division_dv = 'EE'
									then 'Z'
									else 'E2000'
								end 
	LEFT JOIN (
				select distinct PLANT_ID, PLANT_NAME
				from SCP_MST_CAPA_LINE
				) P
		ON p.PLANT_ID = l.plant_id
	where 1=1

	UNION
	select plant_id						as CODE
		, plant_id + ' ' + plant_name	as NAME
		, division_id
		, division_id					as org_division_id 
		, 2 AS SEQ
	from #osp_plant_info
	ORDER BY SEQ, division_id, CODE
	;


	--2. Factory id 정보
	select distinct l.FACTORY_ID				AS CODE
		, l.FACTORY_ID + ' ' + l.FACTORY_NAME	AS NAME
		, d.division_id
		, d.org_division_id 
	from #line_master l with(nolock)
	inner join #division_info d 
		on l.division_id = d.org_division_id
		and l.operation_id = case when d.division_dv  = 'EE'
									then 'E2000'
									else l.operation_id
								end 
		and l.operation_id != case when d.division_dv = 'EE'
									then 'Z'
									else 'E2000'
								end 
	where 1=1

	UNION
	SELECT '-' AS CODE, '-' AS NAME, '82' as division_id, '82' as org_division_id
	;


	--3. Line id 정보
	SELECT CODE, NAME, division_id, org_division_id, operation_id, plant_id, factory_id
		, 1 AS SEQ
	FROM (
	select distinct l.LINE_ID				AS CODE
		, l.LINE_ID + '   ' + l.LINE_NAME	AS NAME
		, d.division_id
		, d.org_division_id 
		, l.operation_id
		, l.plant_id
		, l.factory_id
	from #line_master l with(nolock)
	inner join #division_info d 
		on l.division_id = d.org_division_id
		and l.operation_id = case when d.division_dv  = 'EE'
									then 'E2000'
									else l.operation_id
								end 
		and l.operation_id != case when d.division_dv = 'EE'
									then 'Z'
									else 'E2000'
								end 
	where 1=1
	) a
	JOIN scm_adm_lookup_master_detail ld WITH(NOLOCK)
	  ON ld.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION' AND ld.valid_yn = 'Y' AND ld.SEGMENT1 = a.DIVISION_ID AND ld.SEGMENT2 = a.OPERATION_ID

	UNION
	select LINE_ID						as CODE
		, LINE_ID + ' ' + LINE_NAME		as NAME
		, division_id
		, division_id					as org_division_id 
		, operation_id
		, plant_id
		, '-' AS factory_id
		, 2 AS SEQ
	from #osp_plant_info
	ORDER BY SEQ, division_id, CODE
	;
	--[PJ20257329] 사업부별 Operation 룩업으로부터 Operation 및 라인 표시, OSP Plant 및 라인도 표시(2025-09-03) END

	--4. Plan Group 정보
	select OPMZ_PLAN_GR_ID	AS CODE
		, OPMZ_PLAN_GR_NAME	AS NAME
		, DIVISION_ID
	from SCP_OPMZ_PLAN_GR_M with(nolock)
	WHERE 1=1
	AND VALID_YN = 'Y'	--[PJ20257329] Plan Group 검색조건에 삭제한 Plan Group 미표시 (2025-09-03)
	AND (( @p_user_id IS NULL OR  @p_user_id='' ) OR OWNR_LST_CTN LIKE '%' +  @p_user_id  + '%')
	ORDER BY OPMZ_PLAN_GR_NAME	--[PJ20257329] Plan Group 검색조건 정렬 방식 변경(Group Code → Group Name) (2025-10-20)

	
	--5. Prod Frozen Target 대상 정보
	SELECT SEGMENT1 AS CODE
		, DESCRIPTION AS NAME
		, SEGMENT2 AS DIVISION_ID
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
	WHERE LOOKUP_TYPE = 'OPMZ_TGT_DIVS_CD'
	AND VALID_YN = 'Y'
  
	--[PJ20257329] 사업부별 Operation 룩업으로부터 Operation 및 라인 표시(2025-09-03) START
	--6. 사업부별 Operation 정보
	SELECT DISTINCT B.SEGMENT2 AS CODE
		 , B.SEGMENT2 + ' ' + op.OPERATION_NAME AS NAME
		 , B.SEGMENT1 AS DIVISION_ID
		, 1 AS SEQ
	  FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
	 INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
	  LEFT JOIN SCM_OPERATION_M_SN op WITH(NOLOCK)
		ON B.SEGMENT2 = op.OPERATION_ID AND op.ACTIVE_FLAG = 'Y'
	 WHERE A.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION'
	   AND A.VALID_YN = 'Y'

	UNION
	select OPERATION_ID							as CODE
		, OPERATION_ID + ' ' + OPERATION_ID		as NAME
		, division_id
		, 2 AS SEQ
	from #osp_plant_info
	ORDER BY SEQ, division_id, CODE
	 --[PJ20257329] 사업부별 Operation 룩업으로부터 Operation 및 라인 표시(2025-09-03) END

END
===== END ASIS ===== */

/*
 * Program ID   : P_SCP0122_GET_PLAN_ACTIVITY_MGMT
 * Description  : SCP0122 PlanActivityMgmt — As-is SCP0122_GET_PLAN_ACTIVITY_MGMT 이식 (GET, 시트 'Plan Activity Mgmt' / 버튼 SEARCH)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.22   harness        [TobeGen] 골격 생성 — SQL 본문 이식 TODO
 */
PROCEDURE P_SCP0122_GET_PLAN_ACTIVITY_MGMT (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_PLAN_GROUP_ID  IN  VARCHAR2,  -- As-is @p_plan_group_id nvarchar(-1)
        P_PRS_CD         IN  VARCHAR2,  -- As-is @p_prs_cd nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사(As-is 에서 NOT NULL 로 쓰이는 파라미터만 남길 것)
    IF P_DIVISION_ID IS NULL THEN RAISE_INVALID('DIVISION_ID IS NULL'); END IF;

    OPEN O_RC1 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0122_GET_PLAN_ACTIVITY_MGMT 결과셋 1 (컬럼: DIVISION_ID, OPMZ_PRS_CD, OPMZ_PRS_NAME, OPMZ_PLAN_GR_ID, OPMZ_PLAN_GR_NAME, OPMZ_ACTV_SEQ, OPMZ_ACTV_CD, OPMZ_ACTV_NAME, LINK_UI_TYPE, PROGRAM_NAME, CONFIRM_YN, AUTO_YN …)

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0122_GET_PLAN_ACTIVITY_MGMT] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_DIVISION_ID='||P_DIVISION_ID||','||'P_PLAN_GROUP_ID='||P_PLAN_GROUP_ID||','||'P_PRS_CD='||P_PRS_CD);
END P_SCP0122_GET_PLAN_ACTIVITY_MGMT;

/* ===== ASIS SCP0122_GET_PLAN_ACTIVITY_MGMT (dbo) — 이식 후 이 블록은 삭제 =====
/*
 * Program ID   : SCP0122_GET_PLAN_ACTIVITY_MGMT
 * Description  : Plan Activity Mgmt 정보조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/29   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 *
 * /

CREATE PROCEDURE [dbo].[SCP0122_GET_PLAN_ACTIVITY_MGMT]
	@p_division_id			NVARCHAR(MAX)
	, @p_plan_group_id		NVARCHAR(MAX)
	, @p_prs_cd				NVARCHAR(MAX)

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT b.DIVISION_ID
		, a.OPMZ_PRS_CD
		, d.SEGMENT2 AS OPMZ_PRS_NAME
		, a.OPMZ_PLAN_GR_ID
		, b.OPMZ_PLAN_GR_NAME
		, a.OPMZ_ACTV_SEQ
		, a.OPMZ_ACTV_CD
		, a.OPMZ_ACTV_CD AS OPMZ_ACTV_NAME
		, c.ATTRIBUTE4 AS LINK_UI_TYPE
		, c.ATTRIBUTE5 AS PROGRAM_NAME
		, c.ATTRIBUTE6 AS CONFIRM_YN
		, c.ATTRIBUTE7 AS AUTO_YN
		, c.ATTRIBUTE8 AS OPTION_YN
		, a.OPMZ_ACTV_CD AS PRE_OPMZ_ACTV_CD
		, a.OPMZ_ACTV_SEQ AS PRE_OPMZ_ACTV_SEQ
	FROM SCP_OPMZ_PLAN_GR_ACTV_M a
	INNER JOIN SCP_OPMZ_PLAN_GR_M b ON b.OPMZ_PLAN_GR_ID = a.OPMZ_PLAN_GR_ID
	INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL c WITH(NOLOCK) ON c.LOOKUP_TYPE = 'OPMZ_ACTV_CD'  AND c.SEGMENT1 = a.OPMZ_ACTV_CD
	INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d WITH(NOLOCK) ON d.LOOKUP_TYPE = 'OPMZ_PRS_CD'  AND d.SEGMENT1 = a.OPMZ_PRS_CD
	WHERE b.DIVISION_ID = @p_division_id
	AND a.OPMZ_PLAN_GR_ID = @p_plan_group_id
	AND a.OPMZ_PRS_CD = @p_prs_cd
	ORDER BY a.OPMZ_ACTV_SEQ
  
END
===== END ASIS ===== */

/*
 * Program ID   : P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT
 * Description  : SCP0122 PlanActivityMgmt — As-is SCP0122_SAVE_PLAN_ACTIVITY_MGMT 이식 (SAVE, 시트 'Plan Activity Mgmt' / 버튼 SAVE)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.22   harness        [TobeGen] 골격 생성 — SQL 본문 이식 TODO
 */
PROCEDURE P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT (
        P_DATA           IN  CLOB,            -- 그리드 변경행 JSON 배열(FE sendRows) — As-is: @p_active_flag, @p_prs_cd, @p_plan_gr_id, @p_actv_cd, @p_actv_seq, @p_pre_actv_cd, @p_user_id
        P_USER_ID        IN  VARCHAR2,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    IF P_DATA IS NULL OR P_USER_ID IS NULL THEN RAISE_INVALID('Please check required input values.'); END IF;

    -- TODO 이식: P_DATA(JSON 배열) → JSON_TABLE 로 행 전개 후 As-is SCP0122_SAVE_PLAN_ACTIVITY_MGMT 의 INSERT/UPDATE/DELETE 를 MERGE/DML 로
    -- 예) FOR r IN (SELECT * FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (ROW_STATUS VARCHAR2(10) PATH '$.rowStatus', DIVISION_ID VARCHAR2(20) PATH '$.divisionId' /* … */))) LOOP … END LOOP;
    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || SUBSTR(P_DATA, 1, 200));
END P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT;

/* ===== ASIS SCP0122_SAVE_PLAN_ACTIVITY_MGMT (dbo) — 이식 후 이 블록은 삭제 =====
/*
 * Program ID   : SCP0122_SAVE_PLAN_ACTIVITY_MGMT
 * Description  : Plan Activity 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/29   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/18   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - 삭제 기능 추가
 *
 * /
CREATE PROCEDURE [dbo].[SCP0122_SAVE_PLAN_ACTIVITY_MGMT]

	-- Add the parameters for the stored procedure here
	@p_active_flag		NVARCHAR(MAX),
	@p_prs_cd			NVARCHAR(MAX), 
	@p_plan_gr_id		NVARCHAR(MAX), 
	@p_actv_cd			NVARCHAR(MAX), 
	@p_actv_seq			NVARCHAR(MAX),  
	@p_pre_actv_cd		NVARCHAR(MAX), 
	@p_user_id			NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag		NVARCHAR(MAX);
	DECLARE @v_prs_cd			NVARCHAR(MAX);
	DECLARE @v_plan_gr_id		NVARCHAR(MAX);
	DECLARE @v_actv_cd			NVARCHAR(MAX);
	DECLARE @v_actv_seq			NVARCHAR(MAX);
	DECLARE @v_pre_actv_cd		NVARCHAR(MAX);

	DECLARE @v_last_updated_by	NVARCHAR(MAX);
	
	SET @v_active_flag		= NULL;	
	SET @v_prs_cd			= NULL;
	SET @v_plan_gr_id		= NULL;	
	SET @v_actv_cd			= NULL;
	SET @v_actv_seq			= NULL;
	SET @v_pre_actv_cd		= NULL;
	SET @v_last_updated_by	= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0122_SAVE_PLAN_ACTIVITY_MGMT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;


	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	SET @v_last_updated_by  = @p_user_id

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);   

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN

			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_prs_cd = [dbo].[SCM_ARR_SPL_VAL](@p_prs_cd, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_plan_gr_id = [dbo].[SCM_ARR_SPL_VAL](@p_plan_gr_id, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_actv_cd = [dbo].[SCM_ARR_SPL_VAL](@p_actv_cd, @v_delimiter , @mst_loop_cnt) ;
				SET @v_actv_seq = [dbo].[SCM_ARR_SPL_VAL](@p_actv_seq, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_pre_actv_cd = [dbo].[SCM_ARR_SPL_VAL](@p_pre_actv_cd, @v_delimiter , @mst_loop_cnt) ; 

			END

			--HISTORY INSERT
			EXEC SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST @v_prs_cd, @v_plan_gr_id, @v_actv_cd, @v_actv_seq, 'Y', @v_last_updated_by, @d_event_date, @v_last_updated_by ;

			IF(@v_active_flag = 'I')
			BEGIN

				INSERT INTO SCP_OPMZ_PLAN_GR_ACTV_M
				(
					OPMZ_PRS_CD
					, OPMZ_PLAN_GR_ID
					, OPMZ_ACTV_CD
					, OPMZ_ACTV_SEQ
					, VALID_YN
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
				)
				VALUES
				(
					@v_prs_cd
					, @v_plan_gr_id
					, @v_actv_cd
					, @v_actv_seq
					, 'Y'
					, @v_last_updated_by
					, SYSDATETIME()
					, @v_last_updated_by
					, SYSDATETIME()
				);

			END
			ELSE IF( @v_active_flag ='M' )
			BEGIN

				UPDATE SCP_OPMZ_PLAN_GR_ACTV_M
				SET OPMZ_ACTV_CD		= @v_actv_cd
					, OPMZ_ACTV_SEQ		= CAST(@v_actv_seq AS INT)
					, LAST_UPDATED_BY	= @v_last_updated_by 
					, LAST_UPDATE_DATE	= SYSDATETIME()
				WHERE OPMZ_PRS_CD		= @v_prs_cd
				AND OPMZ_PLAN_GR_ID		= @v_plan_gr_id
				AND OPMZ_ACTV_CD		= @v_pre_actv_cd
				;

			END
			ELSE IF( @v_active_flag ='D' )
			BEGIN

				DELETE SCP_OPMZ_PLAN_GR_ACTV_M
				WHERE OPMZ_PRS_CD		= @v_prs_cd
				AND OPMZ_PLAN_GR_ID		= @v_plan_gr_id
				AND OPMZ_ACTV_CD		= @v_pre_actv_cd
				;

			END

		END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;
			
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	END TRY
	BEGIN CATCH
		BEGIN
		INSERT INTO scm_sys_log_batch (program_name
										,log_type
										,log_count
										,log_message
										,description
										,event_date
										,creation_date
										,created_by
										,last_update_date
										,last_updated_by)
		VALUES (ERROR_PROCEDURE()
				,'ERROR'
				,NULL
				,ERROR_MESSAGE()
				,NULL
				,SYSDATETIME()
				,SYSDATETIME()
				,ERROR_PROCEDURE()
				,SYSDATETIME()
				,ERROR_PROCEDURE());

		IF @@TRANCOUNT > 0
			COMMIT WORK;

		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END
===== END ASIS ===== */

END PKG_SCP0122;
/
-- 컴파일 확인: SELECT NAME, TYPE, LINE, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0122' ORDER BY TYPE, SEQUENCE;
