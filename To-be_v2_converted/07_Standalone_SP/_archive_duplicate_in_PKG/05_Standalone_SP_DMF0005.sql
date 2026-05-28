-- ============================================================================
-- ARCHIVED: 다음 SP들은 PKG_DMF0005 에 이미 등록되어 있어 standalone에서 제거됨
--          PKG 호출 권장: SCM_MGR.PKG_DMF0005.P_{SP_NAME}
-- ============================================================================


-- DMF0005_GET_SALES_SITE_MODEL_PRODUCTION → PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0005_GET_SALES_SITE_MODEL_PRODUCTION
(
	p_division_id			VARCHAR2,	--Division
	p_dept_id				VARCHAR2,	--Department
	p_end_customer			VARCHAR2,	--Endcustomer
	p_scm_site_id			VARCHAR2,	--FCST Type
	p_project_code			VARCHAR2,
	p_item_id				VARCHAR2,
	p_valid_yn				VARCHAR2,
	p_created_by			VARCHAR2,
	p_userinfo				VARCHAR2,
	p_owner				VARCHAR2,
	p_user_dept_id			VARCHAR2,   -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
	p_end_cust_report_yn 	VARCHAR2,
	p_project_info_yn 		VARCHAR2		--[E20240826-000165]_PROJECT NULL YN 추가
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:07
 * 파일: dbo.DMF0005_GET_SALES_SITE_MODEL_PRODUCTION.sql
 * ----------------------------------------
 * ⚠ IF: IF:5  END IF:4  차이:+1
 * ----------------------------------------
 * BEGIN 위치: L86, L374, L497, L1385
 * END;  위치: L450, L499, L1600
 * ----------------------------------------
 * 힌트: BEGIN이 1개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    v_group_id VARCHAR2(50 CHAR) := NULL;
    V_EXCEPT_SW VARCHAR2(2 CHAR);
    v_cnt_1  INTEGER := 0;
BEGIN


		--IF p_userinfo = 'ADMIN' OR p_userinfo = 'DM ADMIN'   OR p_userinfo = 'SCM PI ADMIN'
		--	v_group_id := 'ADMIN'

	--[E20240411-001030]_TEMP 생성 후 DROP 구간이 없어 해당 부분 추가생성
	--[E20240731-000852]_ENERGE메져 KWH/WH계산하기 전 데이터 INSERT INTO 하기위해 추가 START
	--[E20240731-000852]_ENERGE메져 KWH/WH계산하기 전 데이터 INSERT INTO 하기위해 추가END
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END

	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 START
	/*
	--[E20240904-001037]_81% 사업부인 경우에는 CELL/MODULE컬럼에 해당 데이터를 보여달라는 요청사항으로 TEMP테이블 신규생성 START
	--[E20240904-001037]_81% 사업부인 경우에는 CELL/MODULE컬럼에 해당 데이터를 보여달라는 요청사항으로 TEMP테이블 신규생성 END

	--[E20241028-000049]_TEMP 테이블을 추가한다. START
	--[E20241028-000049]_TEMP 테이블을 추가한다. */
	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 END

	-- ------------------------------------------------------------------------------
	--      20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
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

		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_SINGLE';

		-- ------------------------------------------------------------------------------
		--      20230328 heesan91 속도개선
		-- ------------------------------------------------------------------------------
		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_SCM_MST_SITE_ITEM';

		-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 START
		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_INVENTORY_SITE';

DBMS_OUTPUT.PUT_LINE('A--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START

	/* 원소스 주석처리
		-- -------------------------------------------------------------------------------------------------------------
		-- [E20240411-001030]_Sales Site Project Model 화면 하단 저장 로직 오류 수정_SINGLE_VIEW 변경작업 진행
		-- -------------------------------------------------------------------------------------------------------------
		/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V_B-->GT_DMF0_DM_MST_ITEM_SINGLE_V_B */
		INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V_B
		SELECT	T1.DIVISION_ID,
				T1.ITEM_ID,
				MAX(T1.ITEM_NAME)					AS ITEM_NAME,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
				MAX(T1.ITEM_CLASS)					AS ITEM_CLASS,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
				MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME,		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
				MAX(T1.NICK_NAME)						AS NICK_NAME,			--닉네임이 NULL인 경우가 있으므로 하나로 통일
				case  min( case when T1.item_type = 'P' then 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
								when T1.item_type = 'H' then 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
								when T1.item_type = 'Q' then 3
								else 4 end )
												when 1 then 'P'
												when 2 then 'H'
												when 3 then 'Q'
												else 'R' end	AS ITEM_TYPE,
				MAX(T1.MATERIAL_CLASS_NAME				)		AS MATERIAL_CLASS_NAME,
				MAX(T1.ITEM_UOM							)		AS ITEM_UOM,
				MAX(T1.SPEC								)		AS SPEC,
				MAX(T1.MDM_PROJECT_NAME					)		AS MDM_PROJECT_NAME,
				MAX(T1.MIN_CAPACITY						)		AS MIN_CAPACITY,
				MAX(T2.FORECAST_INFO_BIZ_TYPE			)		AS FORECAST_INFO_BIZ_TYPE,
				MAX(T2.FORECAST_INFO_PRODUCT_GROUP		)		AS FORECAST_INFO_PRODUCT_GROUP,
				MAX(T2.FORECAST_INFO_CELL_MODEL			)		AS FORECAST_INFO_CELL_MODEL,
				MAX(T2.FORECAST_INFO_CELL_PACK_COUNT	)		AS FORECAST_INFO_CELL_PACK_COUNT,
				MAX(T2.FORECAST_INFO_SPEC				)		AS FORECAST_INFO_SPEC,
				MAX(T2.FORECAST_INFOR_VERSION			)		AS FORECAST_INFOR_VERSION,
				MAX(T1.ACTIVE_FLAG						)		AS ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
				MAX(T2.CELL_TYPE						)		AS CELL_TYPE,  -- 20180911 ADD cell_type
				MAX(T1.ENERGE							)  	    AS ENERGE,			-- 20200116 khsong ADD ENERGE
				MAX(T1.CELL_QUANTITY					)	    AS CELL_QUANTITY,	-- 20200116 khsong ADD CELL_QUANTITY
				MAX(T1.SCP_EXTRA_SPEC)						    AS SCP_EXTRA_SPEC		-- [20210428 SJHAN / CSR ID:C20210323-000420]
			FROM SCM_MST_ITEM_SN T1
			INNER JOIN ( SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
							, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
							, MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
							, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
							, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
							, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
							, MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
							, MAX(CELL_TYPE) AS CELL_TYPE
						FROM  SCM_MST_ITEM_SN T2
						GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
					) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
						AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
			WHERE 1=1
			AND T1.DIVISION_ID = P_DIVISION_ID
			GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

	*/

	--> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_ORI-->GT_DMF0_DM_MST_ITEM_SINGLE_ORI */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_ORI
	SELECT *
	FROM SCM_MST_ITEM_SN
	--FROM [10.34.221.78,7433].FP_MGR.SCM_ITEM_M
	WHERE DIVISION_ID = p_division_id;

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_A_V-->GT_DMF0_DM_MST_ITEM_SINGLE_A_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_A_V
	SELECT T1.DIVISION_ID
		 , T1.ITEM_ID
		 , MAX(T1.ITEM_NAME)						AS ITEM_NAME
		 , MAX(T1.ITEM_CLASS)						AS ITEM_CLASS
		 , MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME
		 , MAX(T1.NICK_NAME)						AS NICK_NAME
		 , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
						  WHEN T1.ITEM_TYPE = 'H' THEN 2
						  WHEN T1.ITEM_TYPE = 'Q' THEN 3
					 ELSE 4 END )
									WHEN 1 THEN 'P'
									WHEN 2 THEN 'H'
									WHEN 3 THEN 'Q'
									ELSE 'R' END	AS ITEM_TYPE
		 , MAX(T1.MATERIAL_CLASS_NAME)				AS MATERIAL_CLASS_NAME
		 , MAX(T1.ITEM_UOM)							AS ITEM_UOM
		 , MAX(T1.SPEC)								AS SPEC
		 , MAX(T1.MDM_PROJECT_NAME)					AS MDM_PROJECT_NAME
		 , MAX(T1.MIN_CAPACITY)						AS MIN_CAPACITY
		 , MAX(T1.ACTIVE_FLAG)						AS ACTIVE_FLAG
		 , MAX(T1.ENERGE)							AS ENERGE
		 , MAX(T1.CELL_QUANTITY)					AS CELL_QUANTITY
		 , MAX(T1.SCP_EXTRA_SPEC)					AS SCP_EXTRA_SPEC
	FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI T1
	WHERE 1=1
	GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_B_V-->GT_DMF0_DM_MST_ITEM_SINGLE_B_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_B_V
	SELECT DIVISION_ID
		 , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
		 , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
		 , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
		 , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
		 , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
		 , MAX(CELL_TYPE) AS CELL_TYPE
	FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI T2
	GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

	--TEMP 테이블에 넣은 데이터를 JOIN 한다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V_B-->GT_DMF0_DM_MST_ITEM_SINGLE_V_B */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V_B
	SELECT DIVISION_ID
		 , ITEM_ID
		 , ITEM_NAME
		 , ITEM_CLASS
		 , ITEM_CLASS_NAME
		 , NICK_NAME
		 , ITEM_TYPE
		 , MATERIAL_CLASS_NAME
		 , ITEM_UOM
		 , SPEC
		 , MDM_PROJECT_NAME
		 , MIN_CAPACITY
		 , FORECAST_INFO_BIZ_TYPE
		 , FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL
		 , FORECAST_INFO_CELL_PACK_COUNT
		 , FORECAST_INFO_SPEC
		 , FORECAST_INFOR_VERSION
		 , ACTIVE_FLAG
		 , CELL_TYPE
		 , ENERGE
		 , CELL_QUANTITY
		 , SCP_EXTRA_SPEC
	FROM
	(
		SELECT T1.DIVISION_ID
			 , T1.ITEM_ID
			 , T1.ITEM_NAME							AS ITEM_NAME
			 , T1.ITEM_CLASS						AS ITEM_CLASS
			 , T1.ITEM_CLASS_NAME					AS ITEM_CLASS_NAME
			 , T1.NICK_NAME							AS NICK_NAME
			 , T1.ITEM_TYPE							AS ITEM_TYPE
			 , T1.MATERIAL_CLASS_NAME				AS MATERIAL_CLASS_NAME
			 , T1.ITEM_UOM							AS ITEM_UOM
			 , T1.SPEC								AS SPEC
			 , T1.MDM_PROJECT_NAME					AS MDM_PROJECT_NAME
			 , T1.MIN_CAPACITY						AS MIN_CAPACITY
			 , T2.FORECAST_INFO_BIZ_TYPE			AS FORECAST_INFO_BIZ_TYPE
			 , T2.FORECAST_INFO_PRODUCT_GROUP		AS FORECAST_INFO_PRODUCT_GROUP
			 , T2.FORECAST_INFO_CELL_MODEL			AS FORECAST_INFO_CELL_MODEL
			 , T2.FORECAST_INFO_CELL_PACK_COUNT		AS FORECAST_INFO_CELL_PACK_COUNT
			 , T2.FORECAST_INFO_SPEC				AS FORECAST_INFO_SPEC
			 , T2.FORECAST_INFOR_VERSION			AS FORECAST_INFOR_VERSION
			 , T1.ACTIVE_FLAG						AS ACTIVE_FLAG
			 , T2.CELL_TYPE							AS CELL_TYPE
			 , T1.ENERGE							AS ENERGE
			 , T1.CELL_QUANTITY						AS CELL_QUANTITY
			 , T1.SCP_EXTRA_SPEC					AS SCP_EXTRA_SPEC
		FROM GT_DMF0_DM_MST_ITEM_SINGLE_A_V T1
		INNER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_B_V T2
				ON T1.DIVISION_ID = T2.DIVISION_ID
			   AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
		WHERE 1=1
	) T2;
	WHERE DIVISION_ID = p_division_id
	GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		   , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		   , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 JSSBAE END
DBMS_OUTPUT.PUT_LINE('B--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

			--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 START
			/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
			INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
			SELECT A.DIVISION_ID, A.ITEM_ID, A.ITEM_NAME, A.ITEM_CLASS,	A.ITEM_CLASS_NAME, A.NICK_NAME,
				   A.ITEM_TYPE, A.MATERIAL_CLASS_NAME, A.ITEM_UOM, A.SPEC,A.MDM_PROJECT_NAME,
				   A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_PRODUCT_GROUP, A.FORECAST_INFO_CELL_MODEL,
				   A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION,
				   A.ACTIVE_FLAG, A.CELL_TYPE, A.ENERGE, A.ENERGE AS ENERGE_WH,
				   CASE WHEN ISNUMERIC(A.ENERGE) > 0 THEN (TO_NUMBER(ROUND((TO_NUMBER(A.ENERGE))/1000, 7))) ELSE NULL END AS ENERGE_KWH,
				   A.CELL_QUANTITY, A.SCP_EXTRA_SPEC
			FROM GT_DMF0_DM_MST_ITEM_SINGLE_V_B A;
			--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 END

		IF ( P_DIVISION_ID = '82' ) THEN
			INSERT INTO GT_DMF0_INVENTORY_SITE ( DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CONSENSUS_MKT, CONSENSUS_ESS, CONSENSUS_SCM, INVENTORY_DAY, CHANGE_REASON )
			SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CONSENSUS_MKT, CONSENSUS_ESS, CONSENSUS_SCM, INVENTORY_DAY, CHANGE_REASON FROM SCM_MST_SITE_ITEM
			WHERE 1=1 AND DIVISION_ID = P_DIVISION_ID AND SCM_SITE_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WHERE LOOKUP_TYPE = 'INVENTORY_DAYS_SETUP_SITE');
		END IF;

DBMS_OUTPUT.PUT_LINE('C--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 END
		IF ( P_DIVISION_ID = '81' ) THEN
			INSERT INTO GT_DMF0_SINGLE ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_CLASS_NAME, NICK_NAME )
			SELECT	T1.DIVISION_ID
				, T1.ITEM_ID
				, MAX(T1.ITEM_NAME)					AS ITEM_NAME
				, case  min( case when T1.item_type = 'P' then 1
								when T1.item_type = 'H' then 2
								when T1.item_type = 'Q' then 3
								else 4 end )
												when 1 then 'P'
												when 2 then 'H'
												when 3 then 'Q'
												else 'R' end	AS ITEM_TYPE
				, MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME
				, MAX(T1.NICK_NAME)						AS NICK_NAME
				--MAX(T1.ACTIVE_FLAG						)		AS ACTIVE_FLAG
			--FROM SCM_MST_ITEM_SN T1  --속도개선 작업 20240912 JSSBAE
			FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI T1
			where 1=1
				AND T1.DIVISION_ID = P_DIVISION_ID
				AND T1.ITEM_TYPE IN ( 'H', 'P' )
			group by T1.DIVISION_ID, T1.ITEM_ID;

		END IF;

DBMS_OUTPUT.PUT_LINE('D--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		INSERT INTO GT_DMF0_SCM_MST_SITE_ITEM (DIVISION_ID, SCM_SITE_ID,  PROJECT_CODE, CNT)
		SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, SUM(CASE WHEN B.ITEM_TYPE IN ( 'H', 'P' ) THEN 1 ELSE 0 END )
		FROM SCM_MST_SITE_ITEM A
		LEFT OUTER JOIN GT_DMF0_SINGLE B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
		WHERE A.DIVISION_ID = P_DIVISION_ID
		GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE;

		--[E20260123-001715]_[E20240904-001037] 소스 주석처리하고, 원소스로 복원 START
		--[E20241028-000049]_쿼리문 전체 변경 진행 START
		--[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건 START
		--해당 쿼리 제공자: 업무혁신.SCM／품질PI.SCM분석팀 김도원선임
		/*
		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_W_CELL_CF_DATA';

		--조회시에 속도가 느려지는 부분이 있으므로, 81번 사업부가 아니라면 굳이 태우지 않는다.
		IF ( P_DIVISION_ID LIKE '81%' )
		BEGIN
			/* TODO:GTT:GT_DMF0_CELL_CF-->GT_DMF0_CELL_CF */
			INSERT INTO GT_DMF0_CELL_CF
			SELECT CT.COMPANY_ID
					, MAX(CT.DIVISION_ID) AS DIVISION_ID
					, CT.SITE_ID
					, CT.PLANT_ID
					, CT.MODEL_ID
					, CT.CHILD_ITEM_ID
					, SUM(CT.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
					, MAX(CT.CHILD_UOM) AS CHILD_UOM
			FROM  (	SELECT CT.COMPANY_ID
							, CT.DIVISION_ID
							, CT.SITE_ID
							, CT.PARENT_ITEM_ID
							, CT.MODEL_ID
							, CT.CHILD_ITEM_ID
							, CT.PLANT_ID
							, CT.ACCUMULATED_CHILD_QTY
							, CT.CHILD_UOM
							, ALT_PRIORITY
				FROM (  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID,;
								PARENT_ITEM_ID, CHILD_ITEM_ID, CHILD_QTY, CHILD_UOM,
								ACCUMULATED_CHILD_QTY, ALT_PRIORITY
						FROM SCM_MODEL_COMP_TEMP_SN
						GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID,;
								PARENT_ITEM_ID, CHILD_ITEM_ID, CHILD_QTY, CHILD_UOM,
								ACCUMULATED_CHILD_QTY, ALT_PRIORITY
						) CT;
					,( SELECT SIM.DIVISION_ID, SIM.COMPANY_ID, SIM.SITE_ID, SIM.ITEM_ID, SIM.FLOW_ID
						FROM SCM_MST_ITEM_SN SIM
						INNER JOIN SCM_MST_ITEM_CLASS_SN ICM
								ON ICM.CLASS_ID = SIM.ITEM_CLASS
						INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
								ON B.LOOKUP_TYPE = 'DM_CELL_ITEM_LEVEL_ID'
								AND ICM.LEVEL_1_ID = B.SEGMENT1
						GROUP BY SIM.DIVISION_ID, SIM.COMPANY_ID, SIM.SITE_ID, SIM.ITEM_ID, SIM.FLOW_ID
						) CL;
				WHERE  CT.COMPANY_ID  = CL.COMPANY_ID
				AND    CT.DIVISION_ID = CL.DIVISION_ID
				AND    CT.SITE_ID     = CL.SITE_ID
				AND    CT.CHILD_ITEM_ID = CL.ITEM_ID
				AND ((CL.FLOW_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WHERE LOOKUP_TYPE = 'DM_CELL_FLOW_ID')/*('P5500', 'P9500')*/
						AND CT.PARENT_ITEM_ID <>  '*')
						OR CL.FLOW_ID NOT IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WHERE LOOKUP_TYPE = 'DM_CELL_FLOW_ID'))
				AND    CT.ALT_PRIORITY      = 'Y'
			)  CT;
			GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID;

			INSERT INTO GT_DMF0_W_CELL_CF_DATA
			( DIVISION_ID, ITEM_ID, ACCUMULATED_CHILD_QTY )
			SELECT T.DIVISION_ID, T.ITEM_ID, T.ACCUMULATED_CHILD_QTY
			FROM
			(  SELECT C.DIVISION_ID, C.ITEM_ID
						, CASE WHEN D.ACCUMULATED_CHILD_QTY IS NULL THEN ( SELECT MAX(B.ACCUMULATED_CHILD_QTY)
																		FROM GT_DMF0_CELL_CF B
																		WHERE B.MODEL_ID LIKE (SUBSTR(C.ITEM_ID,1,10) || '%'));
							ELSE D.ACCUMULATED_CHILD_QTY END AS ACCUMULATED_CHILD_QTY
				FROM (  SELECT	A.ITEM_ID, A.DIVISION_ID
						FROM	SCM_MST_SITE_ITEM A ,
								(   SELECT	DIVISION_ID, ITEM_ID
									FROM	SCM_MST_ITEM_SN
									GROUP BY DIVISION_ID, ITEM_ID
								) B;
						WHERE	 1=1
						AND		 A.DIVISION_ID = B.DIVISION_ID
						AND		 A.ITEM_ID = B.ITEM_ID
						GROUP BY A.ITEM_ID, A.DIVISION_ID
				) C;
				LEFT OUTER JOIN ( SELECT MODEL_ID, MAX(ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
									FROM GT_DMF0_CELL_CF
									GROUP BY MODEL_ID
									) D;
								ON D.MODEL_ID = C.ITEM_ID
			) T;
			GROUP BY T.DIVISION_ID, T.ITEM_ID, T.ACCUMULATED_CHILD_QTY;
		END;

		/* TODO:GTT:GT_DMF0_SCM_MST_SITE_ITEM_CELL-->GT_DMF0_SCM_MST_SITE_ITEM_CELL */
		INSERT INTO GT_DMF0_SCM_MST_SITE_ITEM_CELL
		SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, CELL.ACCUMULATED_CHILD_QTY
		FROM SCM_MST_SITE_ITEM A
		LEFT OUTER JOIN ( SELECT DIVISION_ID, ITEM_ID, ACCUMULATED_CHILD_QTY
							FROM GT_DMF0_W_CELL_CF_DATA
							GROUP BY DIVISION_ID, ITEM_ID, ACCUMULATED_CHILD_QTY
						) CELL;
						ON A.DIVISION_ID	= CELL.DIVISION_ID
					AND A.ITEM_ID		= CELL.ITEM_ID
		WHERE A.DIVISION_ID = P_DIVISION_ID
		GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, CELL.ACCUMULATED_CHILD_QTY;
		--[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건 END
		--[E20241028-000049]_쿼리문 전체 변경 진행 */
		--[E20260123-001715]_[E20240904-001037] 소스 주석처리하고, 원소스로 복원 END


		/* [E20231019-001234] MDM중지여부 정보 수집------------------------------------------------------------------------*/

		V_EXCEPT_SW := ''; --Default : N

		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_ITEM_ACTIVE_FLAG_INFO';

		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_81_UC_EXCEPTION';


DBMS_OUTPUT.PUT_LINE('E--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		--SSPM에 매칭되는 정보로만 처리
		--모든사업부 LEFT OUTER JOIN 으로 공통화
		INSERT INTO GT_DMF0_ITEM_ACTIVE_FLAG_INFO (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, ITEM_TYPE, ACTIVE_FLAG)
		SELECT V.DIVISION_ID, M.SCM_SITE_ID , M.PROJECT_CODE, V.ITEM_ID, V.ITEM_TYPE, V.ACTIVE_FLAG
		-- [E20240411-001030]_Sales Site Project Model 화면 하단 저장 로직 오류 수정_SINGLE_VIEW 테이블명 변경작업 진행
		--FROM DM_MST_ITEM_SINGLE_V V
		FROM GT_DMF0_DM_MST_ITEM_SINGLE_V V
		INNER JOIN SCM_MST_SITE_ITEM M   ON M.DIVISION_ID = V.DIVISION_ID AND M.ITEM_ID = V.ITEM_ID
		WHERE V.DIVISION_ID = P_DIVISION_ID
		GROUP BY V.DIVISION_ID, M.SCM_SITE_ID , M.PROJECT_CODE, V.ITEM_ID, V.ITEM_TYPE, V.ACTIVE_FLAG;

		--		--DROP TABLE GT_DMF0_81_UC_EXCEPTION;

DBMS_OUTPUT.PUT_LINE('F--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		--81_UC의 MDM중지여부 데이터가 없는 경우 --> 81의 MDM중지여부 데이터와 동일하게 반영하기를 요청 (오윤종PI님)
		IF ( P_DIVISION_ID = '81_UC' )
			BEGIN
				V_EXCEPT_SW := 'Y';
			END


			/* DMF0005_GET_SALES_SITE_MODEL_PRODUCTION p_division_id='81_UC',p_dept_id='ALL',p_end_customer='ALL',p_scm_site_id='ALL',p_project_code=''
				    ,p_item_id='',p_valid_yn='ALL',p_created_by='hmyong',p_userinfo='ADMIN',p_owner='',p_user_dept_id='HD',p_end_cust_report_yn=''

				DMF0005_GET_SALES_SITE_MODEL_PRODUCTION p_division_id='81_HM',p_dept_id='ALL',p_end_customer='ALL',p_scm_site_id='ALL',p_project_code=''
				    ,p_item_id='',p_valid_yn='ALL',p_created_by='hmyong',p_userinfo='ADMIN',p_owner='',p_user_dept_id='HD',p_end_cust_report_yn=''

					--ACEN4101I-A1-C01  81_UC MDM정보에 없음 ,  81번 MDM정보로 처리
			*/


		INSERT INTO GT_DMF0_81_UC_EXCEPTION (DIVISION_ID, ITEM_ID, ACTIVE_FLAG)
		SELECT P_DIVISION_ID AS DIVISION_ID, V.ITEM_ID, V.ACTIVE_FLAG
		FROM
		(
			SELECT P_DIVISION_ID AS DIVISION_ID,  V.ITEM_ID,  V.ACTIVE_FLAG
			-- [E20240411-001030]_Sales Site Project Model 화면 하단 저장 로직 오류 수정_SINGLE_VIEW 테이블명 변경작업 진행
			--FROM DM_MST_ITEM_SINGLE_V V
			FROM GT_DMF0_DM_MST_ITEM_SINGLE_V V
			WHERE V.DIVISION_ID = '81'  --고정값사용 (81_UC의 경우 81번 값으로 대체 처리 , ACTIVE_FLAG 가 NULL인경우에 한함.)
			GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
		) V;
		--LEFT OUTER JOIN
		INNER JOIN
		(
			SELECT S.DIVISION_ID, S.ITEM_ID
			FROM SCM_MST_SITE_ITEM S
			WHERE S.DIVISION_ID = P_DIVISION_ID
			AND NVL(S.ITEM_ID, NULL) IS NOT NULL
			GROUP BY S.DIVISION_ID, S.ITEM_ID
		)  S ON S.DIVISION_ID = V.DIVISION_ID AND S.ITEM_ID = V.ITEM_ID
		WHERE 1=1
		--AND NVL(S.ITEM_ID , NULL) IS NOT NULL
		GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
		HAVING CASE WHEN NVL(V_EXCEPT_SW,'')  = V_EXCEPT_SW THEN V_EXCEPT_SW ELSE 'X' END = CASE WHEN NVL(V_EXCEPT_SW,'')  = 'Y' THEN V_EXCEPT_SW ELSE 'XX' END;

DBMS_OUTPUT.PUT_LINE('G--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

--SELECT * FROM GT_DMF0_81_UC_EXCEPTION
--SELECT V_EXCEPT_SW
--SELECT CASE WHEN NVL(V_EXCEPT_SW,'')  = V_EXCEPT_SW THEN V_EXCEPT_SW ELSE 'X' END , CASE WHEN NVL(V_EXCEPT_SW,'')  = 'Y' THEN V_EXCEPT_SW ELSE 'XX' END RETURN;

		/*--------------------------------------------------------------------------------------------------------------*/
--select * from GT_DMF0_SCM_MST_SITE_ITEM RETURN;
--SELECT * FROM GT_DMF0_ITEM_ACTIVE_FLAG_INFO RETURN;

	-- ------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	-- ------------------------------------------------------------------------------
		IF p_division_id = '40'

			-- ---------------------------------------------------------------------------------------------------------------
			-- 소형
			-- ---------------------------------------------------------------------------------------------------------------
			SELECT *

				, CASE WHEN ((FN_GET_DEPT_LIST(p_created_by, DEPT_ID) = 'Y') OR v_group_id ='ADMIN')
					THEN 'Y' ELSE '' END AS EDIT_FLAG
				--, CASE WHEN (p_userinfo ='DM ADMIN') OR (p_userinfo ='ADMIN') THEN 'Y' ELSE '' END AS EDIT_FLAG2
				, CASE WHEN ((FN_GET_DEPT_LIST(p_created_by, DEPT_ID) = 'Y') AND (p_userinfo ='DM Planner')) THEN 'Y' ELSE '' END AS EDIT_FLAG3
				/* DM Planner 수정 요청건이 들어와서 해당 부분으로 수정처리 진행했으나, DM Planner는 수정하면 안됨, 임광표 책임이 절대 수정하면 안된다고함. 20250609
				--[E20250526-000252]_EDIT_FLAG 수정
				, CASE WHEN v_group_id ='ADMIN' THEN ''
					   ELSE CASE WHEN ((FN_GET_DEPT_LIST(p_created_by, DEPT_ID) = 'Y') AND (p_userinfo ='DM Planner')) THEN ''
								 ELSE 'Y'
							END END AS EDIT_FLAG3
				*/
			FROM (SELECT	SITE_PROJECT.DIVISION_ID,;
						   --DEPT.DEPT_ID,
						   --DEPT.DEPT_NAME_KO,
						   SITE_PROJECT.CRGE_ORG_NM, -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
						   TEAM.DEPT_ID,
						   TEAM.DEPT_ID AS DEPT_ID2,
						   TEAM.DEPT_NAME_KO AS TEAM_NAME_KO,
						   --SITE.END_CUSTOMER,
						   --SITE_ITEM.PROJECT_CODE AS END_CUSTOMER
						   SITE_ITEM.PROJECT_CODE AS END_CUSTOMER,
						   SITE_ITEM.PROJECT_CODE AS END_CUSTOMER40,
				           SITE_PROJECT.CUST_ENG_NM, -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
						   SITE_CUST.SOLDTO_CODE,
	     				   CUST.SOLDTO_DESCRIPTION, --화면상에서는 일단 숨김처리
						   SITE_CUST.SHIPTO_CODE,
						   CUST.SHIPTO_DESCRIPTION, --화면상에서는 일단 숨김처리
						   SITE_PROJECT.SCM_SITE_ID,
						   SITE_PROJECT.SCM_SITE_ID AS SCM_SITE_ID40,
						   SITE_PROJECT.PROJECT_CODE,
						   PJT.PROJECT_NAME,
						   PJT.PROJECT_STATUS,
						   PJT.PROJECT_OWNER, -- 'SYSTEM' AS PROJECT_OWNER, --PJT.PROJECT_OWNWER      현재 컬럼이 없음.
						   --SSO_USER.USER_ID,
						   SITE_PROJECT.owner AS USER_ID,	--20180806
						   SITE_ITEM.SALES_PLAN_ADJUST_YN,
						   SITE_ITEM.ITEM_TYPE,
						   SITE_ITEM.ITEM_CLASS_NAME,
						   SITE_ITEM.ITEM_ID,
						   SITE_ITEM.ITEM_NAME,
						   SITE_ITEM.CELL_PER_CAR,
						   SITE_ITEM.CELL_PER_MODULE,
						   SITE_ITEM.CELL_PER_CAR / SITE_ITEM.CELL_PER_MODULE AS MODULE_PER_CAR,

						   CUST_ITEM.CUSTOMER_MODEL,
						   SITE_ITEM.NICK_NAME,
						   --[C20200513-000276] Sales_Company, Sales_Plant 컬럼 추가
						   SITE_ITEM.SALES_COMPANY,
						   SITE_ITEM.SALES_PLANT,

						   SITE_ITEM.BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
						   SITE_ITEM.LIABILITY_PERIOD,
						   SITE_ITEM.CURRENCY,
						   --  Modified by ytchoi 180517
						   -- NVL(SITE_PROJECT.VALID_YN,SITE_ITEM.VALID_YN) AS VALID_YN,
						   CASE WHEN SITE_ITEM.ITEM_ID IS NULL THEN NVL(SITE_PROJECT.VALID_YN,SITE_ITEM.VALID_YN) ELSE SITE_ITEM.VALID_YN END AS VALID_YN,

						   SITE_ITEM.LAST_UPDATE_DATE,
						   SITE_ITEM.LAST_UPDATED_BY
						   --20180601, LSH------------------
						   ,SITE_ITEM.CUST_GROUP
						   ,SITE_ITEM.CUST_GROUP_DTL
						   --,SITE_ITEM.OWNER
						   --,SSO_USER.USER_NAME_EN OWNER
						   , FN_GET_MULTI_OWNER_NAME (SITE_ITEM.OWNER, ',', '1') AS OWNER  -- 20180803
						   ,SITE_ITEM.APPLICATION
						   ,SITE_ITEM.ROUTE

						   ,SITE_ITEM.EDI		-- C20200827-000257 테슬라 EDI
						   ,SITE_ITEM.EDI_LT	-- C20200827-000257 테슬라 EDI

						   ,SITE_ITEM.ATTRIBUTE1
						   ,SITE_ITEM.ATTRIBUTE2
						   ,SITE_ITEM.ATTRIBUTE4  --20180726
						   ,SITE_ITEM.ATTRIBUTE5  --[C20211112-000213]
						   ,SITE_ITEM.ATTRIBUTE9  AS PRODUCTION_PROCESS--[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
						   -- -----------------------------
						   ,SITE.SOLDTO_CUSTOMER
						   -- 20190402
						   ,REPORT_GROUP1
						   ,REPORT_GROUP2
						   ,REPORT_GROUP3
						   ,REPORT_GROUP4
						   --,REPORT_GROUP5
						   ,REPORT_GROUP6
						   ,REPORT_GROUP7
						   ,REPORT_GROUP8
						   ,SITE_ITEM.CELL_TYPE		-- 20190919
						   , NVL(SITE_PROJECT.VMI_LT,0) AS VMI_LT
						   , SITE_ITEM.ALT_SIM_YN			--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
						   , SITE_ITEM.DESCRIPTION			--20230817 설명(DESCRIPTION) 컬럼 추가
						   , SITE_ITEM.PROJECT_INFO			--20230821 PROJECT_INF0(소형프로젝트) 추가
						   , Z.ACTIVE_FLAG					--[E20231019-001234] MDM중지여부 추가 DM_MST_ITEM_SINGLE_V.ACTIVE_FLAG
						   , SITE_ITEM.ENERGE_WH			--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
						   , SITE_ITEM.ENERGE_KWH			--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
						   , SITE_ITEM.CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
			FROM		   (SELECT	DISTINCT;
									A.DIVISION_ID,
									SCM_SITE_ID,
									PROJECT_CODE,
									NVL(MAX(VALID_YN),'Y') AS VALID_YN,
									'' owner,
									'' ITEM_ID
						--  Modified by ytchoi 180517
						--	FROM	SCM_MST_SITE_ITEM
						--	WHERE NVL(VALID_YN,'Y')	='Y'
									-- 20190402
									,REPORT_GROUP1
									,REPORT_GROUP2
									,REPORT_GROUP3
									,REPORT_GROUP4
									--,REPORT_GROUP5
									,REPORT_GROUP6
									,REPORT_GROUP7
									,REPORT_GROUP8
									, MAX(A.SCP_VMI_LT) AS VMI_LT
									,A.CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
									,A.CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
							FROM	SCM_MST_SITE_ITEM A
								   --,SCM_MST_ITEM_SN B  --속도개선 작업 20240912 JSSBAE 원소스주석처리
								   , GT_DMF0_DM_MST_ITEM_SINGLE_ORI B 	--속도개선 작업 20240912 JSSBAE
						--	WHERE NVL(VALID_YN,'Y')	='Y'
							WHERE   A.ITEM_ID = B.ITEM_ID
							  and   A.division_id <> '40'
							GROUP BY A.DIVISION_ID,;
									 SCM_SITE_ID,
									 PROJECT_CODE
									,A.ATTRIBUTE1
									,A.ATTRIBUTE2
									-- 20190402
									,REPORT_GROUP1
									,REPORT_GROUP2
									,REPORT_GROUP3
									,REPORT_GROUP4
									--,REPORT_GROUP5
									,REPORT_GROUP6
									,REPORT_GROUP7
									,REPORT_GROUP8
									,A.CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
									,A.CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
							 UNION
							 SELECT	DISTINCT
									A.DIVISION_ID,
									SCM_SITE_ID,
									PROJECT_CODE,
									VALID_YN,
									a.owner,
									ITEM_ID
									-- 20190402
									,REPORT_GROUP1
									,REPORT_GROUP2
									,REPORT_GROUP3
									,REPORT_GROUP4
									--,REPORT_GROUP5
									,REPORT_GROUP6
									,REPORT_GROUP7
									,REPORT_GROUP8
									,A.SCP_VMI_LT
									,A.CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
									,A.CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
						--  Modified by ytchoi 180517
						--	FROM	SCM_MST_SITE_ITEM
						--	WHERE NVL(VALID_YN,'Y')	='Y'
							FROM	SCM_MST_SITE_ITEM A
						--	WHERE NVL(VALID_YN,'Y')	='Y'
							WHERE    A.division_id = '40'
														)					AS SITE_PROJECT

			LEFT JOIN SCM_MST_PROJECT PJT
			ON				SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
			AND				SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID

			LEFT JOIN SCM_MST_SITE SITE
			ON				SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID
			AND				SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
			AND             SITE.SITE_TYPE  = 'SALES'

			-- 20180803 추가
			LEFT JOIN (
				SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
				FROM SCM_MST_SSO_USER_INFO B
				INNER JOIN SCM_MST_SSO_DEPT_INFO C
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
			ON              TEAM.USER_ID   IN (SELECTtoken FROM TABLE(fn_string_split(SITE_PROJECT.owner, ',')))

			/* 20180803 주석 처리
			LEFT JOIN SCM_MST_SSO_USER_INFO SSO_USER
			ON              SSO_USER.USER_ID   = SITE_PROJECT.owner
			LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
			--ON				SITE.DEPT_ID = TEAM.DEPT_ID
			ON				TEAM.DEPT_ID  = SSO_USER.DEPT_ID
			*/
			/*
			LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
			--ON				SITE.DEPT_ID = TEAM.DEPT_ID
			ON				TEAM.DEPT_ID  = CASE WHEN SITE.DIVISION_ID <> '40' THEN SITE.DEPT_ID
										   ELSE (
FETCH FIRST 1 ROWS ONLY
												   SELECT su.DEPT_ID
													 FROM SCM_MST_SSO_USER_INFO su
													WHERE su.user_id = SITE_PROJECT.owner
												 )
										   */
			LEFT JOIN		(SELECT T1.DIVISION_ID,
									T1.SCM_SITE_ID,
									T1.PROJECT_CODE,
									T1.ITEM_ID,
									T1.CELL_PER_CAR,
									T1.CELL_PER_MODULE,
									T2.ITEM_NAME,
									T2.ITEM_TYPE,
									T2.ITEM_CLASS_NAME,
									T1.SALES_PLAN_ADJUST_YN,
									T2.NICK_NAME,
									T1.BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
									T1.LIABILITY_PERIOD,
									T1.CURRENCY,
									T1.VALID_YN,
									T1.LAST_UPDATE_DATE,
									T1.LAST_UPDATED_BY
									--20180601, LSH---------
									,T1.CUST_GROUP
									,T1.CUST_GROUP_DTL
									,T1.OWNER
									,T1.APPLICATION
									,T1.ROUTE
									,T1.ATTRIBUTE6 AS EDI	--	C20200827-000257 테슬라 EDI
									,T1.EDI_LT				--	C20200827-000257 테슬라 EDI
									,T1.ATTRIBUTE1
									,T1.ATTRIBUTE2
									,T1.ATTRIBUTE5			--	[C20211112-000213]
									--,T1.ATTRIBUTE4  --20180726  -> [CSR ID:3997942] 20190612 주석처리
									,CO.COUNTRY_NAME AS ATTRIBUTE4 -- [CSR ID:3997942] 20190612 추가
									,T1.ATTRIBUTE9    --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
									,(SELECT LMD.SEGMENT2  AS NAME
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD
										WHERE LOOKUP_TYPE = 'CELL_TYPE' AND T2.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE		-- 20190919
									--[C20200513-000276] Sales_Company, Sales_Plant 컬럼 추가
									,T1.SALES_COMPANY
									,T1.SALES_PLANT
									-- --------------------
									,T1.ALT_SIM_YN	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
									,T1.DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
									,T1.PROJECT_INFO --20230821 PROJECT_INF0(소형프로젝트) 추가
									,T2.ENERGE_WH	--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
									,T2.ENERGE_KWH	--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
									,T1.CELL_S_OP_REPORT --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
							  FROM	SCM_MST_SITE_ITEM		T1
							  -- [E20240411-001030]_Sales Site Project Model 화면 하단 저장 로직 오류 수정_SINGLE_VIEW 테이블명 변경작업 진행
							  --JOIN 	DM_MST_ITEM_SINGLE_V	T2
							  JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V	T2
							  ON	T1.DIVISION_ID = T2.DIVISION_ID
							  AND	T1.ITEM_ID   = T2.ITEM_ID

								-- [CSR ID:3997942] 20190612 추가 (BEGIN)
								INNER JOIN 	SCM_MST_SITE	T3
								ON	T1.DIVISION_ID = T3.DIVISION_ID
								AND	T1.SCM_SITE_ID   = T3.SCM_SITE_ID

								LEFT JOIN SCM_MST_COUNTRY CO
								ON T3.COUNTRY = CO.COUNTRY
								-- [CSR ID:3997942] 20190612 추가 (END)

							  -- 소형인 경우에는 상품도 하나의 Grid에 다 보여야 함.
							  WHERE (T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'H' END
							  OR	 T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'P' END)
														)					AS SITE_ITEM
			ON				SITE_PROJECT.DIVISION_ID = SITE_ITEM.DIVISION_ID
			AND				SITE_PROJECT.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
			AND				SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
			AND             CASE WHEN SITE_PROJECT.DIVISION_ID = '40' THEN SITE_PROJECT.ITEM_ID ELSE  SITE_ITEM.ITEM_ID END = SITE_ITEM.ITEM_ID

			LEFT JOIN SCM_MST_SITE_CUSTOMER SITE_CUST
			ON				SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
			AND				SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
			AND				SITE_CUST.REP_YN      = 'Y'

			LEFT JOIN SCM_MST_CUSTOMER CUST
			ON				SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
			AND				SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
			AND				SITE_CUST.DIVISION_ID = CUST.DIVISION_ID
			-------------------[E20231019-001234] MDM중지여부 추가 DM_MST_ITEM_SINGLE_V.ACTIVE_FLAG-------------------
			LEFT OUTER JOIN GT_DMF0_ITEM_ACTIVE_FLAG_INFO Z ON Z.DIVISION_ID = SITE_ITEM.DIVISION_ID AND Z.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID AND Z.PROJECT_CODE = SITE_ITEM.PROJECT_CODE AND Z.ITEM_ID = SITE_ITEM.ITEM_ID
			-- -----------------------------------------------------------------------------------------------------
			LEFT JOIN		(SELECT DIVISION_ID,
									 MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL,
									 SCM_SITE_ID,
									 PROJECT_CODE,
									 ITEM_ID
							  FROM   DM_MST_CUSTOMER_MODEL
							  WHERE  VALID_YN = 'Y'
							  GROUP BY DIVISION_ID,;
									   SCM_SITE_ID,
									   PROJECT_CODE,
										ITEM_ID			)					AS CUST_ITEM
			ON				SITE_ITEM.ITEM_ID      = CUST_ITEM.ITEM_ID
			AND				SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
			AND				SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
			AND				SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID

	        -------------------------- Model/Item --------2018/07/30  Son Young Suk------------------------
			  INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,',')) ) b
				ON      CASE WHEN p_item_id IS NULL THEN p_item_id
						ELSE SITE_ITEM.ITEM_ID  END like  b.tst
				OR      CASE WHEN p_item_id IS NULL THEN p_item_id
						ELSE SITE_ITEM.NICK_NAME  END like  b.tst
			-- --------------------------------------------------------------------------------------------
			------------  20180806  -------------------------------------------------------------------
			INNER JOIN (
			               SELECT DISTINCT X.OWNER
						      FROM SCM_MST_SITE_ITEM X
							  LEFT JOIN SCM_MST_SSO_USER_INFO UI
							  ON X.PROJECT_CODE = UI.USER_ID
							  INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_owner,',')) ) c
									ON    (
											CASE WHEN p_owner IS NULL THEN p_owner
											ELSE FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') END like  c.tst
											OR
											CASE WHEN p_owner IS NULL THEN p_owner
											ELSE X.OWNER END like  c.tst
											OR
											CASE WHEN p_owner IS NULL THEN p_owner
											ELSE FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') END like  c.tst
											)
							where X.DIVISION_ID = p_division_id
							  AND p_owner IS NOT NULL
							 UNION all
							 select '11'
							   where p_owner IS NULL
                 ) X;
            ON  NVL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN p_owner IS NULL THEN  NVL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner  END
			-- --------------------------------------------------------------------------------------------
			WHERE  1 = 1 -- R- RAW MATERIAL, H- HALF PRODUCT,  P- PRODUCT 제품만 조회함(RHP 모두 제품임).
			AND    CASE WHEN p_division_id = 'ALL' THEN p_division_id
						ELSE SITE_PROJECT.DIVISION_ID
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_division_id,',')) )
			AND    CASE WHEN p_dept_id = 'ALL' THEN p_dept_id
						ELSE TEAM.DEPT_ID
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_dept_id,',')) )

			AND    CASE WHEN p_end_customer = 'ALL' THEN p_end_customer
						ELSE SITE_ITEM.PROJECT_CODE
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_end_customer,',')) )
			AND    CASE WHEN p_scm_site_id = 'ALL' THEN p_scm_site_id
						ELSE SITE_ITEM.SCM_SITE_ID
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_scm_site_id,',')) )

			--AND    CASE WHEN p_item_id IS NULL THEN p_item_id
			--			ELSE SITE_ITEM.ITEM_ID
 		--		   END  IN ( SELECT token FROM TABLE(fn_string_split(p_item_id,',')) )

			AND    CASE WHEN p_project_code IS NULL THEN p_project_code
						ELSE SITE_PROJECT.PROJECT_CODE
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_project_code,',')) )
			AND    SITE.SITE_TYPE <> 'PLANT'
			--AND

			--      CASE WHEN p_owner IS NULL THEN p_owner
			--			ELSE ( SELECT count(token) cnt FROM TABLE(fn_string_split(TEAM.USER_ID,','))
 		--					WHERE token IN ( SELECT token FROM TABLE(fn_string_split(p_owner,',')) ) )
			--		END <> CASE WHEN p_owner IS NULL THEN p_owner ELSE 0 END
				  -- OR
			   --   CASE WHEN p_owner IS NULL THEN p_owner
						--ELSE TEAM.USER_NAME
 				 --  END  IN ( SELECT token FROM TABLE(fn_string_split(p_owner,',')) )
				  -- OR
			   --   CASE WHEN p_owner IS NULL THEN p_owner
						--ELSE TEAM.USER_NAME_EN
 				 --  END  IN ( SELECT token FROM TABLE(fn_string_split(p_owner,',')) )
				   --)

			) T1;

			WHERE  1 = 1
			AND    CASE WHEN p_valid_yn = 'ALL' THEN p_valid_yn
						ELSE T1.VALID_YN
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_valid_yn,',')) )
			-- [C20220905-000187]Sales Site Project Model 조회조건 추가의 건
			AND	(	(;
						NVL(T1.ATTRIBUTE2, NULL) NOT IN (  SELECT SEGMENT1
												FROM SCM_ADM_LOOKUP_MASTER_DETAIL
												WHERE LOOKUP_TYPE= 'END_CUST_REPORT'
												AND VALID_YN = 'Y' )
						AND p_end_cust_report_yn =  'Y'
					)
					OR
					(
						1=1 AND p_end_cust_report_yn = ''
					)
				)
			--[E20240826-000165]_SSPM 체크박스 추가 검토 요청의 건 START
			AND	(
					( NVL(T1.PROJECT_INFO, NULL) IS NULL AND p_project_info_yn =  'Y' )
					OR
					( 1=1 AND p_project_info_yn = '' )
				)
			--[E20240826-000165]_SSPM 체크박스 추가 검토 요청의 건 END
			ORDER BY DIVISION_ID,;
						   TEAM_NAME_KO,
						   END_CUSTOMER,
						   END_CUSTOMER40,
						   SOLDTO_CODE,
						   SHIPTO_CODE,
						   SCM_SITE_ID,
						   SCM_SITE_ID40,
						   PROJECT_CODE,
						   PROJECT_NAME,
						   PROJECT_STATUS,
						   PROJECT_OWNER, -- 'SYSTEM' AS PROJECT_OWNER, --PJT.PROJECT_OWNWER      현재 컬럼이 없음.
						   SALES_PLAN_ADJUST_YN,
						   ITEM_TYPE,
						   ITEM_CLASS_NAME,
						   ITEM_ID,
						   ITEM_NAME,
						   CUSTOMER_MODEL,
						   --[C20200513-000276] Sales_Company, Sales_Plant 컬럼 추가
						   SALES_COMPANY,
						   SALES_PLANT,
						   NICK_NAME,
						   BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
						   LIABILITY_PERIOD,
						   CURRENCY,
							-- 20190402
							REPORT_GROUP1
							,REPORT_GROUP2
							,REPORT_GROUP3
							,REPORT_GROUP4
							--,REPORT_GROUP5
							,REPORT_GROUP6
							,REPORT_GROUP7
							,REPORT_GROUP8


		-- ---------------------------------------------------------------------------------------------------------------
		-- 자동차, ESS
		-- ---------------------------------------------------------------------------------------------------------------
		ELSIF p_division_id = '82' THEN

			SELECT *
				, CASE WHEN ((FN_GET_DEPT_LIST(p_created_by, DEPT_ID) = 'Y') OR v_group_id ='ADMIN')
					THEN 'Y' ELSE '' END AS EDIT_FLAG
			FROM (SELECT		   SITE_PROJECT.DIVISION_ID,;
							SITE_ITEM.CRGE_ORG_NM, -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
			--[PJ2024-50461]===============================================================================
						   --DEPT.DEPT_ID,
						   --DEPT.DEPT_NAME_KO,

						   --[E20241120-000817]_82사업부 SSPM 수정 요청
						   --TEAM MAPPING시 변경된 값으로 보여지는데, DEPT_ID 두개를 동일한 데이터를 보내고 있어서,
						   --하나만 추가함
						   TEAM.DEPT_ID,
						   --[E20241120-000817]_82사업부 SSPM 수정 요청 원소시 주석 처리 START
						   --TEAM.DEPT_ID AS DEPT_ID2,
						   TEAM.DEPT_ID AS DEPT_ID_82,
						   --[E20241120-000817]_82사업부 SSPM 수정 요청 원소시 주석 처리 END
						   TEAM.DEPT_NAME_KO AS TEAM_NAME_KO,
			/*
			===============================================================================
			*/

						   SITE.END_CUSTOMER,
						   SITE.END_CUSTOMER AS END_CUSTOMER40,
						   SITE_ITEM.CUST_ENG_NM, -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
						   SITE_CUST.SOLDTO_CODE,
	     				   CUST.SOLDTO_DESCRIPTION, --화면상에서는 일단 숨김처리
						   SITE_CUST.SHIPTO_CODE,
						   CUST.SHIPTO_DESCRIPTION, --화면상에서는 일단 숨김처리
						   SITE_PROJECT.SCM_SITE_ID,
						   SITE_PROJECT.SCM_SITE_ID AS SCM_SITE_ID40,
						   SITE_PROJECT.PROJECT_CODE,
						   PJT.PROJECT_NAME,
						   PJT.PROJECT_STATUS,
						   PJT.PROJECT_OWNER, -- 'SYSTEM' AS PROJECT_OWNER, --PJT.PROJECT_OWNWER      현재 컬럼이 없음.
						   --SU.USER_ID,
						   --[E20241120-000817]_82만 다른 명칭으로 사용하는것으로 요청하여, UI CATEGORY에 동일한 COLUM이 들어가지 않아, 조회시 이름변경 STAT
						   --SITE_ITEM.OWNER AS USER_ID,	--20180806
						   SITE_ITEM.OWNER AS USER_ID_82,	--20180806
						   SITE_ITEM.PRJ_OWNR_ID,			--[E20241120-000817]_신규 추가 컬럼
						   --[E20241120-000817]_82만 다른 명칭으로 사용하는것으로 요청하여, UI CATEGORY에 동일한 COLUM이 들어가지 않아, 조회시 이름변경 END
						   SITE_ITEM.SALES_PLAN_ADJUST_YN,
						   SITE_ITEM.ITEM_TYPE,
						   SITE_ITEM.ITEM_CLASS_NAME,
						   SITE_ITEM.ITEM_ID,
						   SITE_ITEM.ITEM_NAME,
						   SITE_ITEM.ATTRIBUTE10 AS CELL_TYPE_81,	-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
						   SITE_ITEM.ATTRIBUTE10 AS CELL_TYPE_82,	-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
						   SITE_ITEM.ATTRIBUTE8 AS KWH,				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가 - 20210527 SJHAN
						   SITE_ITEM.CELL_PER_CAR,
						   SITE_ITEM.CELL_PER_MODULE,
						   SITE_ITEM.CELL_PER_CAR / SITE_ITEM.CELL_PER_MODULE AS MODULE_PER_CAR,

						   CUST_ITEM.CUSTOMER_MODEL,

						   --[C20200513-000276] Sales_Company, Sales_Plant 컬럼 추가
						   SITE_ITEM.SALES_COMPANY,
						   SITE_ITEM.SALES_PLANT,

						   SITE_ITEM.NICK_NAME,
						   SITE_ITEM.BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
						   SITE_ITEM.LIABILITY_PERIOD,
						   SITE_ITEM.CURRENCY,
						   --  Modified by ytchoi 180517
						   -- NVL(SITE_PROJECT.VALID_YN,SITE_ITEM.VALID_YN) AS VALID_YN,
						   CASE WHEN SITE_ITEM.ITEM_ID IS NULL THEN NVL(SITE_PROJECT.VALID_YN,SITE_ITEM.VALID_YN) ELSE SITE_ITEM.VALID_YN END AS VALID_YN,

						   SITE_ITEM.LAST_UPDATE_DATE,
						   SITE_ITEM.LAST_UPDATED_BY
						   --20180601, LSH------------------
						   ,SITE_ITEM.CUST_GROUP
						   ,SITE_ITEM.CUST_GROUP_DTL
						   --,SITE_ITEM.OWNER  --2018.07.20
						   --,SU.USER_NAME_EN OWNER  --2018.07.20 add son young suk
						   , FN_GET_MULTI_OWNER_NAME (SITE_ITEM.OWNER, ',', '1') AS OWNER  -- 20180806
						   --, SITE_ITEM.OWNER
						   ,SITE_ITEM.APPLICATION
						   ,SITE_ITEM.ROUTE
						   ,SITE_ITEM.ATTRIBUTE6 AS EDI  --20181031
						   ,SITE_ITEM.EDI_LT  --20191011
						   ,NVL(SITE_ITEM.VMI_LT, 0) AS VMI_LT
						   ,SITE_ITEM.CELL_NAME --PJ20200138 Cell Name 추가
						   ,SITE_ITEM.PARTIAL_PLAN_YN --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
						   -- -----------------------------
						   -- [C20220210-000268]Sales site project model에 '양극재, Module Variant' 컬럼 추가
						   	,SITE_ITEM.ATTRIBUTE1  -- 양극재
							,SITE_ITEM.ATTRIBUTE2 AS MODULE_VARIANT -- MODULE_VARIANT

							-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 START
							,(SELECT CONSENSUS_MKT FROM GT_DMF0_INVENTORY_SITE WHERE SCM_SITE_ID = SITE_PROJECT.SCM_SITE_ID AND PROJECT_CODE = SITE_PROJECT.PROJECT_CODE AND ITEM_ID = SITE_ITEM.ITEM_ID) AS CONSENSUS_MKT
							,(SELECT CONSENSUS_ESS FROM GT_DMF0_INVENTORY_SITE WHERE SCM_SITE_ID = SITE_PROJECT.SCM_SITE_ID AND PROJECT_CODE = SITE_PROJECT.PROJECT_CODE AND ITEM_ID = SITE_ITEM.ITEM_ID) AS CONSENSUS_ESS
							,(SELECT CONSENSUS_SCM FROM GT_DMF0_INVENTORY_SITE WHERE SCM_SITE_ID = SITE_PROJECT.SCM_SITE_ID AND PROJECT_CODE = SITE_PROJECT.PROJECT_CODE AND ITEM_ID = SITE_ITEM.ITEM_ID) AS CONSENSUS_SCM
							--,(SELECT NVL(INVENTORY_DAY, 0) FROM GT_DMF0_INVENTORY_SITE WHERE SCM_SITE_ID = SITE_PROJECT.SCM_SITE_ID AND PROJECT_CODE = SITE_PROJECT.PROJECT_CODE AND ITEM_ID = SITE_ITEM.ITEM_ID) AS INVENTORY_DAY
							--20230829 : ISNULL 처리 (SSPM에서 룩업에설정되지않은 SCM_SITE_ID 대상을 수정할경우에 NULL값으로 인식해서 강제로 오류 표출되어있음)
							,NVL((SELECT NVL(INVENTORY_DAY, 0) FROM GT_DMF0_INVENTORY_SITE WHERE SCM_SITE_ID = SITE_PROJECT.SCM_SITE_ID AND PROJECT_CODE = SITE_PROJECT.PROJECT_CODE AND ITEM_ID = SITE_ITEM.ITEM_ID),0) AS INVENTORY_DAY
							,(SELECT CHANGE_REASON FROM GT_DMF0_INVENTORY_SITE WHERE SCM_SITE_ID = SITE_PROJECT.SCM_SITE_ID AND PROJECT_CODE = SITE_PROJECT.PROJECT_CODE AND ITEM_ID = SITE_ITEM.ITEM_ID) AS CHANGE_REASON
							-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 END
							, SITE_ITEM.ALT_SIM_YN	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
							, SITE_ITEM.DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
						   -- 과제 JV Planner
						   , Z.ACTIVE_FLAG --[E20231019-001234] MDM중지여부 추가 DM_MST_ITEM_SINGLE_V.ACTIVE_FLAG
						   , SITE_ITEM.ENERGE_WH			--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
						   , SITE_ITEM.ENERGE_KWH			--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
			FROM		   (SELECT	DISTINCT;
									A.DIVISION_ID,
									SCM_SITE_ID,
									PROJECT_CODE,
									NVL(MAX(VALID_YN),'Y') AS VALID_YN
									-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 START
									--,CONSENSUS_MKT
									--,CONSENSUS_ESS
									--,CONSENSUS_SCM
									--,INVENTORY_DAY
									--,CHANGE_REASON
									--20230829 : ISNULL 처리
									,NVL(CONSENSUS_MKT, NULL) AS CONSENSUS_MKT
									,NVL(CONSENSUS_ESS, NULL) AS CONSENSUS_ESS
									,NVL(CONSENSUS_SCM, NULL) AS CONSENSUS_SCM
									,NVL(INVENTORY_DAY, 0 ) AS INVENTORY_DAY
									,NVL(CHANGE_REASON, NULL) AS CHANGE_REASON
									-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 END
							FROM	SCM_MST_SITE_ITEM A
							--속도개선 작업 20240912 JSSBAE END
							--INNER JOIN SCM_MST_ITEM_SN B  --속도개선 작업 20240912 JSSBAE 원소스주석처리
							INNER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_ORI B  --속도개선 작업 20240912 JSSBAE
									ON   A.ITEM_ID = B.ITEM_ID
							LEFT OUTER JOIN (SELECT SEGMENT1 AS SITE_ID , '1' AS NUM FROM SCM_ADM_LOOKUP_MASTER_DETAIL   WHERE LOOKUP_TYPE = 'GM_JV_SITE' AND VALID_YN = 'Y'
										UNION ALL SELECT SCM_SITE_ID AS SITE_ID , '1' AS NUM FROM SCM_MST_SITE   WHERE DEPT_ID = p_user_dept_id) AS C
							ON	 A.SCM_SITE_ID = C.SITE_ID
							WHERE NVL(C.NUM, NULL) = CASE WHEN '81' = p_division_id AND p_userinfo = 'JV Planner' THEN 1 ELSE NVL(C.NUM, NULL) END
							AND A.DIVISION_ID = p_division_id
							GROUP BY A.DIVISION_ID,;
										SCM_SITE_ID,
										PROJECT_CODE
										-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 START
										,CONSENSUS_MKT, CONSENSUS_ESS, CONSENSUS_SCM, INVENTORY_DAY, CHANGE_REASON
										-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 END
														)					AS SITE_PROJECT

			LEFT JOIN SCM_MST_PROJECT PJT
			ON				SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
			AND				SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID

			LEFT JOIN SCM_MST_SITE SITE
			ON				SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID
			AND				SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID;

			--[PJ2024-50461] Team Mapping
			/*
			[PJ2024-50461] Team Mapping
			*/
			/*LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
			ON				SITE.DEPT_ID = TEAM.DEPT_ID
			*/

			LEFT JOIN		(SELECT T1.DIVISION_ID,
									T1.CRGE_ORG_NM, -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
									T1.CUST_ENG_NM, -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
									T1.SCM_SITE_ID,
									T1.PROJECT_CODE,
									T1.ITEM_ID,
									T1.CELL_PER_CAR,
									T1.CELL_PER_MODULE,
									T2.ITEM_NAME,
									T2.ITEM_TYPE,
									T2.ITEM_CLASS_NAME,
									T1.SALES_PLAN_ADJUST_YN,
									T2.NICK_NAME,
									T1.BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
									T1.LIABILITY_PERIOD,
									T1.CURRENCY,
									T1.VALID_YN,
									T1.LAST_UPDATE_DATE,
									T1.LAST_UPDATED_BY
									--20180601, LSH---------
									,T1.CUST_GROUP
									,T1.CUST_GROUP_DTL
									,T1.OWNER
									,T1.APPLICATION
									,T1.ROUTE
									,T1.ATTRIBUTE6		--20181031
									,T1.EDI_LT		--20191011
									,T1.SCP_VMI_LT AS VMI_LT
									,T1.ATTRIBUTE9 AS CELL_NAME --PJ20200138 Cell Name 추가
									--[C20200513-000276] Sales_Company, Sales_Plant 컬럼 추가
									,T1.SALES_COMPANY
									,T1.SALES_PLANT
									,T1.PARTIAL_PLAN_YN --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
									,T1.ATTRIBUTE10		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
									,T1.ATTRIBUTE8		-- [C20210525-000374] 셀용량 및 팩 당 용량 추가 - 20210527 SJHAN
									-- --------------------
									-- [C20220210-000268]Sales site project model에 '양극재, Module Variant' 컬럼 추가
									,NVL(T1.ATTRIBUTE1, NULL)  ATTRIBUTE1 -- 양극재
									,NVL(T1.ATTRIBUTE2, NULL)  ATTRIBUTE2 -- MODULE VARIANT

									-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 START
									,T1.CONSENSUS_MKT
									,T1.CONSENSUS_ESS
									,T1.CONSENSUS_SCM
									,NVL(T1.INVENTORY_DAY,0) AS INVENTORY_DAY
									,T1.CHANGE_REASON
									-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 END
									,T1.ALT_SIM_YN	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
									,T1.DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
									,T2.ENERGE_WH	--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
									,T2.ENERGE_KWH	--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
									,T1.PRJ_OWNR_ID	--[E20241120-000817]_신규 추가 컬럼
							  FROM	SCM_MST_SITE_ITEM		T1
							  -- [E20240411-001030]_Sales Site Project Model 화면 하단 저장 로직 오류 수정_SINGLE_VIEW 테이블명 변경작업 진행
							  --JOIN 	DM_MST_ITEM_SINGLE_V	T2
							  JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V	T2
							  ON	T1.DIVISION_ID = T2.DIVISION_ID
							  AND	T1.ITEM_ID   = T2.ITEM_ID

							  -- 20200422 KHSONG C20200422-000123 소형사업부와과 같이 상품도 하나의 Grid에 다 보이도록함
							  WHERE (T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'H' END
							  OR	 T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'P' END)
														)					AS SITE_ITEM

							  --WHERE (T2.ITEM_TYPE  = 'H'  OR  T2.ITEM_TYPE  = 'P'))	AS SITE_ITEM --20180720 KHSONG 주석처리  --20200422 KHSONG C20200422-000123 주석처리


			ON				SITE_PROJECT.DIVISION_ID = SITE_ITEM.DIVISION_ID
			AND				SITE_PROJECT.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
			AND				SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE

			--[PJ2024-50461] Team Mapping
			LEFT JOIN (
				SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
				FROM SCM_MST_SSO_USER_INFO B
				INNER JOIN SCM_MST_SSO_DEPT_INFO C
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
			ON              TEAM.USER_ID   IN (SELECTtoken FROM TABLE(fn_string_split(SITE_ITEM.owner, ',')))

			-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 START -- 연결하지 않으면 2개이상 나오는 현상이 있음
			AND             NVL(SITE_PROJECT.CONSENSUS_MKT, NULL) = NVL(SITE_ITEM.CONSENSUS_MKT, NULL)
			AND             NVL(SITE_PROJECT.CONSENSUS_ESS, NULL) = NVL(SITE_ITEM.CONSENSUS_ESS, NULL)
			AND             NVL(SITE_PROJECT.CONSENSUS_SCM, NULL) = NVL(SITE_ITEM.CONSENSUS_SCM, NULL)
			AND             NVL(SITE_PROJECT.INVENTORY_DAY, 0) = NVL(SITE_ITEM.INVENTORY_DAY, 0)
			AND             NVL(SITE_PROJECT.CHANGE_REASON, NULL) = NVL(SITE_ITEM.CHANGE_REASON, NULL)
			-- [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선 END

			LEFT JOIN SCM_MST_SITE_CUSTOMER SITE_CUST
			ON				SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
			AND				SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
			AND				SITE_CUST.REP_YN      = 'Y'

			LEFT JOIN SCM_MST_CUSTOMER CUST
			ON				SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
			AND				SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
			AND				SITE_CUST.DIVISION_ID = CUST.DIVISION_ID

			LEFT JOIN		(SELECT DIVISION_ID,
									 MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL,
									 SCM_SITE_ID,
									 PROJECT_CODE,
									 ITEM_ID
							  FROM   DM_MST_CUSTOMER_MODEL
							  WHERE  VALID_YN = 'Y'
							  GROUP BY DIVISION_ID,;
									   SCM_SITE_ID,
									   PROJECT_CODE,
										ITEM_ID			)					AS CUST_ITEM
			ON				SITE_ITEM.ITEM_ID      = CUST_ITEM.ITEM_ID
			AND				SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
			AND				SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
			AND				SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID

			LEFT JOIN SCM_MST_SSO_USER_INFO SU
			--2018.07.20 ON PJT.PROJECT_OWNER = SU.USER_ID		--LSH, 20180628
			ON SITE_ITEM.owner = SU.USER_ID -- 2018.07.20 add son young suk
			-------------------[E20231019-001234] MDM중지여부 추가 DM_MST_ITEM_SINGLE_V.ACTIVE_FLAG-------------------
			LEFT OUTER JOIN GT_DMF0_ITEM_ACTIVE_FLAG_INFO Z ON Z.DIVISION_ID = SITE_ITEM.DIVISION_ID AND Z.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID AND Z.PROJECT_CODE = SITE_ITEM.PROJECT_CODE AND Z.ITEM_ID = SITE_ITEM.ITEM_ID
			-- -----------------------------------------------------------------------------------------------------
			-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
			  INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,',')) ) b
				ON      CASE WHEN p_item_id IS NULL THEN p_item_id
						ELSE SITE_ITEM.ITEM_ID  END like  b.tst
				OR      CASE WHEN p_item_id IS NULL THEN p_item_id
						ELSE SITE_ITEM.NICK_NAME  END like  b.tst
			-- --------------------------------------------------------------------------------------------
			-------------------------- Project ---------------2018/07/30  Son Young Suk--------------------
			  INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_project_code,',')) ) b1
				ON      CASE WHEN p_project_code IS NULL THEN p_project_code
						ELSE PJT.PROJECT_CODE  END like  b1.tst
				OR      CASE WHEN p_project_code IS NULL THEN p_project_code
						ELSE PJT.PROJECT_NAME  END like  b1.tst
			-- --------------------------------------------------------------------------------------------
			------------  20180806  -------------------------------------------------------------------
			INNER JOIN (
FETCH FIRST 1 ROWS ONLY
			               SELECT DISTINCT X.OWNER
						      FROM SCM_MST_SITE_ITEM X
							  LEFT JOIN SCM_MST_SSO_USER_INFO UI
							  ON X.PROJECT_CODE = UI.USER_ID
							  INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_owner,',')) ) c
									ON    (
											CASE WHEN p_owner IS NULL THEN p_owner
											ELSE FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') END like  c.tst
											OR
											CASE WHEN p_owner IS NULL THEN p_owner
											ELSE X.OWNER END like  c.tst
											OR
											CASE WHEN p_owner IS NULL THEN p_owner
											ELSE FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') END like  c.tst
											)
							where X.DIVISION_ID = p_division_id
							  AND p_owner IS NOT NULL
							 UNION all
							 select '11'
							   where p_owner IS NULL
                 ) X;
            ON  NVL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN p_owner IS NULL THEN  NVL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner  END

			-- --------------------------------------------------------------------------------------------
			WHERE  1 = 1 -- R- RAW MATERIAL, H- HALF PRODUCT,  P- PRODUCT 제품만 조회함(RHP 모두 제품임).
			AND    CASE WHEN p_division_id = 'ALL' THEN p_division_id
						ELSE SITE_PROJECT.DIVISION_ID
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_division_id,',')) )
			AND    CASE WHEN p_dept_id = 'ALL' THEN p_dept_id
						ELSE TEAM.DEPT_ID
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_dept_id,',')) )
			AND    CASE WHEN p_end_customer = 'ALL' THEN p_end_customer
						ELSE SITE.END_CUSTOMER
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_end_customer,',')) )
			AND    CASE WHEN p_scm_site_id = 'ALL' THEN p_scm_site_id
						--ELSE SITE_ITEM.SCM_SITE_ID
						ELSE SITE_PROJECT.SCM_SITE_ID  -- 20181220 KHSONG modify SITE_ITEM.SCM_SITE_ID -> SITE_PROJECT.SCM_SITE_ID
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_scm_site_id,',')) )
			--AND    CASE WHEN p_item_id IS NULL THEN p_item_id
			--			ELSE SITE_ITEM.ITEM_ID
 		--		   END  IN ( SELECT token FROM TABLE(fn_string_split(p_item_id,',')) )
			--AND    CASE WHEN p_project_code IS NULL THEN p_project_code
			--			ELSE SITE_PROJECT.PROJECT_CODE
 		--		   END  IN ( SELECT token FROM TABLE(fn_string_split(p_project_code,',')) )
			AND   SITE.SITE_TYPE <> 'PLANT'
			--AND    (
			--		CASE WHEN p_owner IS NULL THEN p_owner
			--			ELSE SU.USER_ID
			--		END  IN ( SELECT token FROM TABLE(fn_string_split(p_owner,',')) )
			--		OR
			--			CASE WHEN p_owner IS NULL THEN p_owner
			--			ELSE SU.USER_NAME
			--		END  IN ( SELECT token FROM TABLE(fn_string_split(p_owner,',')) )
			--		OR
			--			CASE WHEN p_owner IS NULL THEN p_owner
			--			ELSE SU.USER_NAME_EN
			--		END  IN ( SELECT token FROM TABLE(fn_string_split(p_owner,',')) )
			--   )

			----AND    EXISTS (SELECT * FROM UF_FX_STRING_SPLIT (p_owner,',') AS P WHERE PJT.PROJECT_OWNER LIKE '%' + P.token +'%')

			) T1;
			WHERE  1 = 1
			AND    CASE WHEN p_valid_yn = 'ALL' THEN p_valid_yn
						ELSE T1.VALID_YN
 				   END  IN ( SELECT token FROM TABLE(fn_string_split(p_valid_yn,',')) )
			ORDER BY DIVISION_ID,;
						   TEAM_NAME_KO,
						   END_CUSTOMER,
						   END_CUSTOMER40,
						   SOLDTO_CODE,
						   SHIPTO_CODE,
						   SCM_SITE_ID,
						   SCM_SITE_ID40,
						   PROJECT_CODE,
						   PROJECT_NAME,
						   PROJECT_STATUS,
						   PROJECT_OWNER, -- 'SYSTEM' AS PROJECT_OWNER, --PJT.PROJECT_OWNWER      현재 컬럼이 없음.
						   SALES_PLAN_ADJUST_YN,
						   ITEM_TYPE,
						   ITEM_CLASS_NAME,
						   ITEM_ID,
						   ITEM_NAME,
						   CELL_TYPE_81,		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
						   CELL_TYPE_82,		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
						   KWH,					-- [C20210525-000374] 셀용량 및 팩 당 용량 추가 - 20210527 SJHAN
						   CUSTOMER_MODEL,
						   --[C20200513-000276] Sales_Company, Sales_Plant 컬럼 추가
						   SALES_COMPANY,
						   SALES_PLANT,
						   NICK_NAME,
						   BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
						   LIABILITY_PERIOD,
						   CURRENCY;
        ELSE
		--select p_division_id; return;
		-- 81 번의 경우
		BEGIN
			--[E20231019-001234] MDM중지여부 추가 DM_MST_ITEM_SINGLE_V.ACTIVE_FLAG
            SELECT DISTINCT A.DIVISION_ID
			    ,A.CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
			--[PJ2024-50461] Team Mapping
			/*
			, B.DEPT_ID
			, B.DEPT_ID AS DEPT_ID2
			, C.DEPT_NAME_KO AS TEAM_NAME_KO
			*/
						   ,TEAM.DEPT_ID
						   ,TEAM.DEPT_ID AS DEPT_ID2
						   ,TEAM.DEPT_NAME_KO AS TEAM_NAME_KO
			/*
			===============================================================================
			*/
				, B.END_CUSTOMER, B.END_CUSTOMER AS END_CUSTOMER40
				, A.CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
				, D.SOLDTO_CODE, E.SOLDTO_DESCRIPTION
				, D.SHIPTO_CODE, E.SHIPTO_DESCRIPTION
				, A.SCM_SITE_ID, A.SCM_SITE_ID AS SCM_SITE_ID40
				, A.PROJECT_CODE
				, F.PROJECT_NAME, F.PROJECT_STATUS, F.PROJECT_OWNER
				, A.OWNER AS USER_ID
				, A.SALES_PLAN_ADJUST_YN
				, G.ITEM_TYPE, G.ITEM_CLASS_NAME
				, A.ITEM_ID, G.ITEM_NAME
				, A.ATTRIBUTE10 AS CELL_TYPE_81
				, A.ATTRIBUTE10 AS CELL_TYPE_82
				, A.ATTRIBUTE8 AS KWH
				, A.CELL_PER_CAR
				--[E20260123-001715]_[E20240904-001037] 소스 주석처리하고, 원소스로 복원 START
				/*
				--[E20240904-001037]_81% 사업부인 경우에는 CELL/MODULE컬럼에 TEMP에 적재한 데이터를 보여준다 START
				--원소스 주석처리
				--, A.CELL_PER_MODULE
				, B2A.ACCUMULATED_CHILD_QTY AS CELL_PER_MODULE
				--[E20240904-001037]_81% 사업부인 경우에는 CELL/MODULE컬럼에 TEMP에 적재한 데이터를 보여준다 */
				, A.CELL_PER_MODULE
				--[E20260123-001715]_[E20240904-001037] 소스 주석처리하고, 원소스로 복원 END
				/* 2023.07.12   HMIN  [E20230706-001434] 81 자동차사업부 조회오류 개선 (CELL_PER_MODULE 값 0으로 들어오는 경우  MODULE_PER_CAR 연산 강제 NULL 처리) */
				--, A.CELL_PER_CAR / A.CELL_PER_MODULE AS MODULE_PER_CAR
				, CASE WHEN NVL(A.CELL_PER_MODULE, 0) = 0 THEN  NULL  ELSE  A.CELL_PER_CAR / A.CELL_PER_MODULE  END  AS MODULE_PER_CAR  /* E20230706-001434  */
				, H.CUSTOMER_MODEL
				, A.SALES_COMPANY, A.SALES_PLANT
				, G.NICK_NAME
				, A.BPMS_EXIST
				, A.LIABILITY_PERIOD, A.CURRENCY
				, A.VALID_YN
				, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY
				, A.CUST_GROUP, A.CUST_GROUP_DTL
				, FN_GET_MULTI_OWNER_NAME (A.OWNER, ',', '1') AS OWNER
				, A.APPLICATION, A.ROUTE
				, A.ATTRIBUTE6 AS EDI, A.EDI_LT
				, NVL(A.SCP_VMI_LT, 0) AS VMI_LT
				, A.ATTRIBUTE9 AS CELL_NAME, A.PARTIAL_PLAN_YN
				, A.ATTRIBUTE1 AS CATHODE_MATERIALS
				, A.ATTRIBUTE2 AS MODULE_VARIANT
				--[PJ2024-50461] Team Mapping------------------------------------
				/*, CASE WHEN ((FN_GET_DEPT_LIST(p_created_by, B.DEPT_ID) = 'Y') OR v_group_id ='ADMIN')
								THEN 'Y' ELSE '' END AS EDIT_FLAG*/
				, CASE WHEN ((FN_GET_DEPT_LIST(p_created_by, TEAM.DEPT_ID) = 'Y') OR v_group_id ='ADMIN')
								THEN 'Y' ELSE '' END AS EDIT_FLAG
				--[PJ2024-50461] Team Mapping------------------------------------
				, A.ALT_SIM_YN	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
				, A.DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
				--향후 예외처리 필요한 경우에 플래그로 구분하기 위해서 처리
				--, Z.ACTIVE_FLAG AS ACTIVE_FLAG
				, CASE WHEN V_EXCEPT_SW = 'Y'
					   THEN CASE WHEN NVL(Z.ACTIVE_FLAG , NULL) IS NULL
					             THEN ZZ.ACTIVE_FLAG ELSE Z.ACTIVE_FLAG END
				       ELSE Z.ACTIVE_FLAG END AS ACTIVE_FLAG --[E20231019-001234] MDM중지여부 추가 DM_MST_ITEM_SINGLE_V.ACTIVE_FLAG
				, A.PROJECT_S_OP_REPORT	--[E20240904-001037]_입력이 가능한 컬럼으로 추가 요청건으로 추가진행한다.
			FROM SCM_MST_SITE_ITEM A
			JOIN SCM_MST_SITE B  ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
			JOIN GT_DMF0_SCM_MST_SITE_ITEM B2 ON A.DIVISION_ID = B2.DIVISION_ID AND A.SCM_SITE_ID = B2.SCM_SITE_ID AND A.PROJECT_CODE = B2.PROJECT_CODE --20230328 속도개선
			--[E20260123-001715]_[E20240904-001037]_소스 주석처리 START
			/*
			JOIN GT_DMF0_SCM_MST_SITE_ITEM_CELL B2A --[E20240904-001037]_TEMP에 담은 테이블의 데이터를 추가한다.
			  ON A.DIVISION_ID = B2A.DIVISION_ID AND A.SCM_SITE_ID = B2A.SCM_SITE_ID AND A.PROJECT_CODE = B2A.PROJECT_CODE AND A.ITEM_ID = B2A.ITEM_ID
			*/
			--[E20260123-001715]_[E20240904-001037]_소스 주석처리 END
			   --AND A.ITEM_ID = B2.ITEM_ID
			 --AND A.SALES_COMPANY = B2.SALES_COMPANY AND A.SALES_PLANT = B2.SALES_PLANT
			LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO C  ON B.DEPT_ID = C.DEPT_ID
			LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER D  ON B.DIVISION_ID = D.DIVISION_ID AND B.SCM_SITE_ID = D.SCM_SITE_ID AND D.REP_YN = 'Y'
			LEFT OUTER JOIN SCM_MST_CUSTOMER E  ON D.DIVISION_ID = E.DIVISION_ID AND D.SOLDTO_CODE = E.SOLDTO_CODE AND D.SHIPTO_CODE = E.SHIPTO_CODE
			LEFT OUTER JOIN SCM_MST_PROJECT F  ON A.DIVISION_ID = F.DIVISION_ID AND A.PROJECT_CODE = F.PROJECT_CODE
			LEFT OUTER JOIN GT_DMF0_SINGLE G (NOLOCK) ON A.DIVISION_ID = G.DIVISION_ID AND A.ITEM_ID = G.ITEM_ID
			-------------------[E20231019-001234] MDM중지여부 추가 DM_MST_ITEM_SINGLE_V.ACTIVE_FLAG-------------------
			LEFT OUTER JOIN GT_DMF0_ITEM_ACTIVE_FLAG_INFO Z ON Z.DIVISION_ID = A.DIVISION_ID AND Z.SCM_SITE_ID = A.SCM_SITE_ID AND Z.PROJECT_CODE = A.PROJECT_CODE AND Z.ITEM_ID = A.ITEM_ID --AND Z.ITEM_TYPE = B2.ITEM_TYPE
			LEFT OUTER JOIN (
							SELECT EX.DIVISION_ID, EX.ITEM_ID, EX.ACTIVE_FLAG
							FROM GT_DMF0_81_UC_EXCEPTION EX
							WHERE 1=1
							AND EX.DIVISION_ID = P_DIVISION_ID			  --'81_UC'  V_EXCEPT_SW 로 처리해서 하드코딩 안해두댐
							GROUP BY EX.DIVISION_ID, EX.ITEM_ID, EX.ACTIVE_FLAG ) ZZ ON ZZ.DIVISION_ID = A.DIVISION_ID AND ZZ.ITEM_ID = A.ITEM_ID
			-- -----------------------------------------------------------------------------------------------------
			--[PJ2024-50461] Team Mapping
			LEFT JOIN (
				SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
				FROM SCM_MST_SSO_USER_INFO B
				--FROM [10.34.221.78,7433]SCM_MST_SSO_USER_INFO B
				INNER JOIN SCM_MST_SSO_DEPT_INFO C
				--INNER JOIN [10.34.221.78,7433].LGCE_SCMPROD.SCM_MST_SSO_DEPT_INFO C
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
			ON              TEAM.USER_ID   IN (SELECTtoken FROM TABLE(fn_string_split(A.owner, ',')))
-- ----------------------------------------------------------------------------------------------------------------------
			LEFT OUTER JOIN	( SELECT DIVISION_ID
									, MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL
									, SCM_SITE_ID
									, PROJECT_CODE
									, ITEM_ID
							FROM   DM_MST_CUSTOMER_MODEL
							--FROM [10.34.221.78,7433].LGCE_SCMPROD.DM_MST_CUSTOMER_MODEL UI
							WHERE  VALID_YN = 'Y'
								AND DIVISION_ID = P_DIVISION_ID
							GROUP BY DIVISION_ID
									, SCM_SITE_ID
									, PROJECT_CODE
									, ITEM_ID
							) AS H
						ON	A.ITEM_ID      = H.ITEM_ID
						AND	A.PROJECT_CODE = H.PROJECT_CODE
						AND	A.DIVISION_ID  = H.DIVISION_ID
						AND	A.SCM_SITE_ID  = H.SCM_SITE_ID
			-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
			  INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,',')) ) X1
				ON      CASE WHEN p_item_id IS NULL THEN p_item_id
						ELSE A.ITEM_ID  END like  X1.tst
				OR      CASE WHEN p_item_id IS NULL THEN p_item_id
						ELSE NVL(G.NICK_NAME, NULL)  END like  X1.tst
			-- --------------------------------------------------------------------------------------------
			-------------------------- Project ---------------2018/07/30  Son Young Suk--------------------
			  INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_project_code,',')) ) b1
				ON      CASE WHEN p_project_code IS NULL THEN p_project_code
						ELSE A.PROJECT_CODE  END like  b1.tst
				OR      CASE WHEN p_project_code IS NULL THEN p_project_code
						ELSE NVL(F.PROJECT_NAME, NULL)  END like  b1.tst
			-- --------------------------------------------------------------------------------------------
			INNER JOIN (
FETCH FIRST 1 ROWS ONLY
			               SELECT DISTINCT X.OWNER
						      FROM SCM_MST_SITE_ITEM X
							  LEFT JOIN SCM_MST_SSO_USER_INFO UI
							  --LEFT JOIN [10.34.221.78,7433].LGCE_SCMPROD.SCM_MST_SSO_USER_INFO UI
							  ON X.PROJECT_CODE = UI.USER_ID
							  INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_owner,',')) ) c
									ON    (
											CASE WHEN p_owner IS NULL THEN p_owner
											ELSE FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') END like  c.tst
											OR
											CASE WHEN p_owner IS NULL THEN p_owner
											ELSE X.OWNER END like  c.tst
											OR
											CASE WHEN p_owner IS NULL THEN p_owner
											ELSE FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') END like  c.tst
											)
							where X.DIVISION_ID = p_division_id
							  AND p_owner IS NOT NULL
							 UNION all
							 select '11'
							   where p_owner IS NULL
                 ) X;
            ON  NVL(A.OWNER,'xxxx') = CASE WHEN p_owner IS NULL THEN  NVL(A.OWNER,'xxxx') ELSE X.owner  END
			WHERE A.DIVISION_ID = P_DIVISION_ID
				-- H,P 가 없는 프로젝트도 한 줄은 나오도록 한다.
				AND ( G.ITEM_TYPE IN ( 'H', 'P' )
					OR B2.CNT = 0 )
				AND    CASE WHEN p_division_id = 'ALL' THEN p_division_id
						ELSE A.DIVISION_ID
 					   END  IN ( SELECT token FROM TABLE(fn_string_split(p_division_id,',')) )
				AND    CASE WHEN p_dept_id = 'ALL' THEN p_dept_id
							--ELSE B.DEPT_ID
							ELSE TEAM.DEPT_ID--[PJ2024-50461] Team Mapping
 					   END  IN ( SELECT token FROM TABLE(fn_string_split(p_dept_id,',')) )
				AND    CASE WHEN p_end_customer = 'ALL' THEN p_end_customer
							ELSE B.END_CUSTOMER
 					   END  IN ( SELECT token FROM TABLE(fn_string_split(p_end_customer,',')) )
				AND    CASE WHEN p_scm_site_id = 'ALL' THEN p_scm_site_id
							ELSE A.SCM_SITE_ID
 					   END  IN ( SELECT token FROM TABLE(fn_string_split(p_scm_site_id,',')) )
				AND    B.SITE_TYPE <> 'PLANT'
				AND		CASE WHEN p_valid_yn = 'ALL' THEN p_valid_yn
							ELSE A.VALID_YN
 					   END  IN ( SELECT token FROM TABLE(fn_string_split(p_valid_yn,',')) )
			ORDER BY DIVISION_ID,;
					TEAM_NAME_KO,
					END_CUSTOMER,
					END_CUSTOMER40,
					SOLDTO_CODE,
					SHIPTO_CODE,
					SCM_SITE_ID,
					SCM_SITE_ID40,
					PROJECT_CODE,
					PROJECT_NAME,
					PROJECT_STATUS,
					PROJECT_OWNER, -- 'SYSTEM' AS PROJECT_OWNER, --PJT.PROJECT_OWNWER      현재 컬럼이 없음.
					SALES_PLAN_ADJUST_YN,
					ITEM_TYPE,
					ITEM_CLASS_NAME,
					ITEM_ID,
					ITEM_NAME,
					CELL_TYPE_81,		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					CELL_TYPE_82,		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					KWH,					-- [C20210525-000374] 셀용량 및 팩 당 용량 추가 - 20210527 SJHAN
					CUSTOMER_MODEL,
					--[C20200513-000276] Sales_Company, Sales_Plant 컬럼 추가
					SALES_COMPANY,
					SALES_PLANT,
					NICK_NAME,
					BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
					LIABILITY_PERIOD,
					CURRENCY;
		END;

DBMS_OUTPUT.PUT_LINE('H--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
END IF;
/

-- DMF0005_GET_SALES_SITE_MODEL_PURCHASE → PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PURCHASE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0005_GET_SALES_SITE_MODEL_PURCHASE
(
	  p_project_code	VARCHAR2
	, p_active_flag	VARCHAR2
	, p_created_by		VARCHAR2
	, p_userinfo		VARCHAR2
	, p_division		VARCHAR2
	, p_site_id		VARCHAR2
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:07
 * 파일: dbo.DMF0005_GET_SALES_SITE_MODEL_PURCHASE.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:1  END:2  차이:-1
 * ----------------------------------------
 * BEGIN 위치: L41, L235
 * END;  위치: L311, L466
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_group_id VARCHAR2(50 CHAR) := NULL;
    v_cnt_1  INTEGER := 0;
BEGIN


	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END

	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 START
	/*
	--[E20240904-001037]_81% 사업부인 경우에는 CELL/MODULE컬럼에 해당 데이터를 보여달라는 요청사항으로 TEMP테이블 신규생성 START
	--[E20240904-001037]_81% 사업부인 경우에는 CELL/MODULE컬럼에 해당 데이터를 보여달라는 요청사항으로 TEMP테이블 신규생성 */
	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 END

		-- modified 181116 SCM PI ADMIN을 ADMIN으로 변경
		--IF p_userinfo = 'ADMIN' OR p_userinfo = 'DM ADMIN' OR p_userinfo = 'SCM PI ADMIN'
		--	v_group_id := 'ADMIN'

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	/* 원소스 주석처리한다.
	-- -------------------------------------------------------------------------------------------------------------
	-- [E20240411-001030]_Sales Site Project Model 화면 하단 저장 로직 오류 수정_SINGLE_VIEW 변경작업 진행
	-- -------------------------------------------------------------------------------------------------------------
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
	SELECT	T1.DIVISION_ID,
			T1.ITEM_ID,
			MAX(T1.ITEM_NAME)					AS ITEM_NAME,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
			MAX(T1.ITEM_CLASS)					AS ITEM_CLASS,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
			MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME,		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
			MAX(T1.NICK_NAME)						AS NICK_NAME,			--닉네임이 NULL인 경우가 있으므로 하나로 통일
			case  min( case when T1.item_type = 'P' then 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
							when T1.item_type = 'H' then 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
							when T1.item_type = 'Q' then 3
							else 4 end )
											when 1 then 'P'
											when 2 then 'H'
											when 3 then 'Q'
											else 'R' end	AS ITEM_TYPE,
			MAX(T1.MATERIAL_CLASS_NAME				)		AS MATERIAL_CLASS_NAME,
			MAX(T1.ITEM_UOM							)		AS ITEM_UOM,
			MAX(T1.SPEC								)		AS SPEC,
			MAX(T1.MDM_PROJECT_NAME					)		AS MDM_PROJECT_NAME,
			MAX(T1.MIN_CAPACITY						)		AS MIN_CAPACITY,
			MAX(T2.FORECAST_INFO_BIZ_TYPE			)		AS FORECAST_INFO_BIZ_TYPE,
			MAX(T2.FORECAST_INFO_PRODUCT_GROUP		)		AS FORECAST_INFO_PRODUCT_GROUP,
			MAX(T2.FORECAST_INFO_CELL_MODEL			)		AS FORECAST_INFO_CELL_MODEL,
			MAX(T2.FORECAST_INFO_CELL_PACK_COUNT	)		AS FORECAST_INFO_CELL_PACK_COUNT,
			MAX(T2.FORECAST_INFO_SPEC				)		AS FORECAST_INFO_SPEC,
			MAX(T2.FORECAST_INFOR_VERSION			)		AS FORECAST_INFOR_VERSION,
			MAX(T1.ACTIVE_FLAG						)		AS ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
			MAX(T2.CELL_TYPE						)		AS CELL_TYPE,  -- 20180911 ADD cell_type
			MAX(T1.ENERGE							)  	    AS ENERGE,			-- 20200116 khsong ADD ENERGE
			MAX(T1.CELL_QUANTITY					)	    AS CELL_QUANTITY,	-- 20200116 khsong ADD CELL_QUANTITY
			MAX(T1.SCP_EXTRA_SPEC)						  AS SCP_EXTRA_SPEC		-- [20210428 SJHAN / CSR ID:C20210323-000420]
		FROM SCM_MST_ITEM_SN T1
		INNER JOIN ( SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
						, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
						, MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
						, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
						, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
						, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
						, MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
						, MAX(CELL_TYPE) AS CELL_TYPE
					FROM  SCM_MST_ITEM_SN T2
					GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
				) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
					AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
		WHERE 1=1
		AND T1.DIVISION_ID = p_division
		GROUP BY T1.DIVISION_ID, T1.ITEM_ID;
	*/
		--> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_ORI-->GT_DMF0_DM_MST_ITEM_SINGLE_ORI */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_ORI
	SELECT *
	FROM SCM_MST_ITEM_SN
	WHERE DIVISION_ID = p_division;

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_A_V-->GT_DMF0_DM_MST_ITEM_SINGLE_A_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_A_V
	SELECT T1.DIVISION_ID
		 , T1.ITEM_ID
		 , MAX(T1.ITEM_NAME)						AS ITEM_NAME
		 , MAX(T1.ITEM_CLASS)						AS ITEM_CLASS
		 , MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME
		 , MAX(T1.NICK_NAME)						AS NICK_NAME
		 , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
						  WHEN T1.ITEM_TYPE = 'H' THEN 2
						  WHEN T1.ITEM_TYPE = 'Q' THEN 3
					 ELSE 4 END )
									WHEN 1 THEN 'P'
									WHEN 2 THEN 'H'
									WHEN 3 THEN 'Q'
									ELSE 'R' END	AS ITEM_TYPE
		 , MAX(T1.MATERIAL_CLASS_NAME)				AS MATERIAL_CLASS_NAME
		 , MAX(T1.ITEM_UOM)							AS ITEM_UOM
		 , MAX(T1.SPEC)								AS SPEC
		 , MAX(T1.MDM_PROJECT_NAME)					AS MDM_PROJECT_NAME
		 , MAX(T1.MIN_CAPACITY)						AS MIN_CAPACITY
		 , MAX(T1.ACTIVE_FLAG)						AS ACTIVE_FLAG
		 , MAX(T1.ENERGE)							AS ENERGE
		 , MAX(T1.CELL_QUANTITY)					AS CELL_QUANTITY
		 , MAX(T1.SCP_EXTRA_SPEC)					AS SCP_EXTRA_SPEC
	FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI T1
	WHERE 1=1
	GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_B_V-->GT_DMF0_DM_MST_ITEM_SINGLE_B_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_B_V
	SELECT DIVISION_ID
		 , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
		 , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
		 , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
		 , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
		 , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
		 , MAX(CELL_TYPE) AS CELL_TYPE
	FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI T2
	GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

	--TEMP 테이블에 넣은 데이터를 JOIN 한다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
	SELECT DIVISION_ID
		 , ITEM_ID
		 , ITEM_NAME
		 , ITEM_CLASS
		 , ITEM_CLASS_NAME
		 , NICK_NAME
		 , ITEM_TYPE
		 , MATERIAL_CLASS_NAME
		 , ITEM_UOM
		 , SPEC
		 , MDM_PROJECT_NAME
		 , MIN_CAPACITY
		 , FORECAST_INFO_BIZ_TYPE
		 , FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL
		 , FORECAST_INFO_CELL_PACK_COUNT
		 , FORECAST_INFO_SPEC
		 , FORECAST_INFOR_VERSION
		 , ACTIVE_FLAG
		 , CELL_TYPE
		 , ENERGE
		 , CELL_QUANTITY
		 , SCP_EXTRA_SPEC
	FROM
	(
		SELECT T1.DIVISION_ID
			 , T1.ITEM_ID
			 , T1.ITEM_NAME							AS ITEM_NAME
			 , T1.ITEM_CLASS						AS ITEM_CLASS
			 , T1.ITEM_CLASS_NAME					AS ITEM_CLASS_NAME
			 , T1.NICK_NAME							AS NICK_NAME
			 , T1.ITEM_TYPE							AS ITEM_TYPE
			 , T1.MATERIAL_CLASS_NAME				AS MATERIAL_CLASS_NAME
			 , T1.ITEM_UOM							AS ITEM_UOM
			 , T1.SPEC								AS SPEC
			 , T1.MDM_PROJECT_NAME					AS MDM_PROJECT_NAME
			 , T1.MIN_CAPACITY						AS MIN_CAPACITY
			 , T2.FORECAST_INFO_BIZ_TYPE			AS FORECAST_INFO_BIZ_TYPE
			 , T2.FORECAST_INFO_PRODUCT_GROUP		AS FORECAST_INFO_PRODUCT_GROUP
			 , T2.FORECAST_INFO_CELL_MODEL			AS FORECAST_INFO_CELL_MODEL
			 , T2.FORECAST_INFO_CELL_PACK_COUNT		AS FORECAST_INFO_CELL_PACK_COUNT
			 , T2.FORECAST_INFO_SPEC				AS FORECAST_INFO_SPEC
			 , T2.FORECAST_INFOR_VERSION			AS FORECAST_INFOR_VERSION
			 , T1.ACTIVE_FLAG						AS ACTIVE_FLAG
			 , T2.CELL_TYPE							AS CELL_TYPE
			 , T1.ENERGE							AS ENERGE
			 , T1.CELL_QUANTITY						AS CELL_QUANTITY
			 , T1.SCP_EXTRA_SPEC					AS SCP_EXTRA_SPEC
		FROM GT_DMF0_DM_MST_ITEM_SINGLE_A_V T1
		INNER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_B_V T2
				ON T1.DIVISION_ID = T2.DIVISION_ID
			   AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
		WHERE 1=1
	) T2;
	GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		   , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		   , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END

	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 START
	/*
	--[E20241028-000049]_쿼리문 전체 변경 진행 START
	--[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건 START
	--해당 쿼리 제공자: 업무혁신.SCM／품질PI.SCM분석팀 김도원선임
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_W_CELL_CF_DATA';

	--조회시에 속도가 느려지는 부분이 있으므로, 81번 사업부가 아니라면 굳이 태우지 않는다.
	IF ( p_division LIKE '81%' )
	BEGIN
		/* TODO:GTT:GT_DMF0_CELL_CF-->GT_DMF0_CELL_CF */
		INSERT INTO GT_DMF0_CELL_CF
		SELECT CT.COMPANY_ID
				, MAX(CT.DIVISION_ID) AS DIVISION_ID
				, CT.SITE_ID
				, CT.PLANT_ID
				, CT.MODEL_ID
				, CT.CHILD_ITEM_ID
				, SUM(CT.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
				, MAX(CT.CHILD_UOM) AS CHILD_UOM
		FROM  (	SELECT CT.COMPANY_ID
						, CT.DIVISION_ID
						, CT.SITE_ID
						, CT.PARENT_ITEM_ID
						, CT.MODEL_ID
						, CT.CHILD_ITEM_ID
						, CT.PLANT_ID
						, CT.ACCUMULATED_CHILD_QTY
						, CT.CHILD_UOM
						, ALT_PRIORITY
			FROM (  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID,;
							PARENT_ITEM_ID, CHILD_ITEM_ID, CHILD_QTY, CHILD_UOM,
							ACCUMULATED_CHILD_QTY, ALT_PRIORITY
					FROM SCM_MODEL_COMP_TEMP_SN
					GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID,;
							PARENT_ITEM_ID, CHILD_ITEM_ID, CHILD_QTY, CHILD_UOM,
							ACCUMULATED_CHILD_QTY, ALT_PRIORITY
					) CT;
				,( SELECT SIM.DIVISION_ID, SIM.COMPANY_ID, SIM.SITE_ID, SIM.ITEM_ID, SIM.FLOW_ID
					FROM SCM_MST_ITEM_SN SIM
					INNER JOIN SCM_MST_ITEM_CLASS_SN ICM
							ON ICM.CLASS_ID = SIM.ITEM_CLASS
					INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
							ON B.LOOKUP_TYPE = 'DM_CELL_ITEM_LEVEL_ID'
							AND ICM.LEVEL_1_ID = B.SEGMENT1
					GROUP BY SIM.DIVISION_ID, SIM.COMPANY_ID, SIM.SITE_ID, SIM.ITEM_ID, SIM.FLOW_ID
					) CL;
			WHERE  CT.COMPANY_ID  = CL.COMPANY_ID
			AND    CT.DIVISION_ID = CL.DIVISION_ID
			AND    CT.SITE_ID     = CL.SITE_ID
			AND    CT.CHILD_ITEM_ID = CL.ITEM_ID
			AND ((CL.FLOW_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WHERE LOOKUP_TYPE = 'DM_CELL_FLOW_ID')/*('P5500', 'P9500')*/
					AND CT.PARENT_ITEM_ID <>  '*')
					OR CL.FLOW_ID NOT IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WHERE LOOKUP_TYPE = 'DM_CELL_FLOW_ID'))
			AND    CT.ALT_PRIORITY      = 'Y'
		)  CT;
		GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID;

		INSERT INTO GT_DMF0_W_CELL_CF_DATA
		( DIVISION_ID, ITEM_ID, ACCUMULATED_CHILD_QTY )
		SELECT T.DIVISION_ID, T.ITEM_ID, T.ACCUMULATED_CHILD_QTY
		FROM
		(  SELECT C.DIVISION_ID, C.ITEM_ID
					, CASE WHEN D.ACCUMULATED_CHILD_QTY IS NULL THEN ( SELECT MAX(B.ACCUMULATED_CHILD_QTY)
																	FROM GT_DMF0_CELL_CF B
																	WHERE B.MODEL_ID LIKE (SUBSTR(C.ITEM_ID,1,10) || '%'));
						ELSE D.ACCUMULATED_CHILD_QTY END AS ACCUMULATED_CHILD_QTY
			FROM (  SELECT	A.ITEM_ID, A.DIVISION_ID
					FROM	SCM_MST_SITE_ITEM A ,
							(   SELECT	DIVISION_ID, ITEM_ID
								FROM	SCM_MST_ITEM_SN
								GROUP BY DIVISION_ID, ITEM_ID
							) B;
					WHERE	 1=1
					AND		 A.DIVISION_ID = B.DIVISION_ID
					AND		 A.ITEM_ID = B.ITEM_ID
					GROUP BY A.ITEM_ID, A.DIVISION_ID
			) C;
			LEFT OUTER JOIN ( SELECT MODEL_ID, MAX(ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
								FROM GT_DMF0_CELL_CF
								GROUP BY MODEL_ID
								) D;
							ON D.MODEL_ID = C.ITEM_ID
		) T;
		GROUP BY T.DIVISION_ID, T.ITEM_ID, T.ACCUMULATED_CHILD_QTY;
	END;

	/* TODO:GTT:GT_DMF0_SCM_MST_SITE_ITEM_CELL-->GT_DMF0_SCM_MST_SITE_ITEM_CELL */
	INSERT INTO GT_DMF0_SCM_MST_SITE_ITEM_CELL
	SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, CELL.ACCUMULATED_CHILD_QTY
	FROM SCM_MST_SITE_ITEM A
	LEFT OUTER JOIN ( SELECT DIVISION_ID, ITEM_ID, ACCUMULATED_CHILD_QTY
						FROM GT_DMF0_W_CELL_CF_DATA
						GROUP BY DIVISION_ID, ITEM_ID, ACCUMULATED_CHILD_QTY
					) CELL;
					ON A.DIVISION_ID	= CELL.DIVISION_ID
				AND A.ITEM_ID		= CELL.ITEM_ID
	WHERE A.DIVISION_ID = p_division
	GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, CELL.ACCUMULATED_CHILD_QTY;
	*/
	--[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건 END
	--[E20241028-000049]_쿼리문 전체 변경 진행 END
	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 END

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
		SELECT distinct SITE_ITEM.DIVISION_ID,
		   SITE_ITEM.SCM_SITE_ID,
		   SITE_ITEM.PROJECT_CODE,
		   PJT.PROJECT_NAME,
		   PJT.PROJECT_STATUS,
		   SITE_ITEM.SALES_PLAN_ADJUST_YN,
		  -- ITEM.ITEM_TYPE,
		   SITE_ITEM2.ITEM_TYPE,
		   SITE_ITEM2.ITEM_CLASS_NAME,
		   SITE_ITEM.ITEM_ID,
		   SITE_ITEM.ATTRIBUTE10 AS CELL_TYPE_81, 	-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
		   SITE_ITEM.ATTRIBUTE10 AS CELL_TYPE_82,	-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
		   SITE_ITEM.ATTRIBUTE8 AS KWH,				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가 - 20210527 SJHAN
		   CUST_ITEM.CUSTOMER_MODEL,
		   SITE_ITEM2.NICK_NAME,
		   SITE_ITEM.BPMS_EXIST AS BPMS_EXIST,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
		   SITE_ITEM.OWNER AS USER_ID,	--20180911 add son young suk
		   FN_GET_MULTI_OWNER_NAME (SITE_ITEM.OWNER, ',', '1') AS OWNER,  -- 20180911 add son young suk
		   SITE_ITEM.LIABILITY_PERIOD,
		   SITE_ITEM.CURRENCY,
		   SITE_ITEM.VALID_YN,
			--Start [C20200707-000149] 자동차 사업부-환산정보(Cell/Car, Cell/Module, Module/Car), Sales Company, Plant Columns 추가
			SITE_ITEM.CELL_PER_CAR,
			--[E20260123-001715]_[E20240904-001037] 소스 주석처리하고, 원소스로 복원 START
			/*
			--[E20240904-001037]_81% 사업부인 경우에는 CELL/MODULE컬럼에 TEMP에 적재한 데이터를 보여준다 START
			--원소스 주석처리
			--SITE_ITEM.CELL_PER_MODULE,
			CASE WHEN p_division LIKE '81%' THEN B2A.ACCUMULATED_CHILD_QTY ELSE SITE_ITEM.CELL_PER_MODULE END AS CELL_PER_MODULE,
			--[E20240904-001037]_81% 사업부인 경우에는 CELL/MODULE컬럼에 TEMP에 적재한 데이터를 보여준다 */
			SITE_ITEM.CELL_PER_MODULE,
			--[E20260123-001715]_[E20240904-001037] 소스 주석처리하고, 원소스로 복원 END
			--[E20230706-001434]Sales Site Project Model CELL_PER_MODULE값 0,NULL 일경우 MODULE_PER_CAR 값 NULL처리
			--SITE_ITEM.CELL_PER_CAR / SITE_ITEM.CELL_PER_MODULE AS MODULE_PER_CAR,
			CASE WHEN NVL(SITE_ITEM.CELL_PER_MODULE,0)  = 0 THEN NULL ELSE  SITE_ITEM.CELL_PER_CAR / SITE_ITEM.CELL_PER_MODULE END AS MODULE_PER_CAR,
			SITE_ITEM.SALES_COMPANY,
			SITE_ITEM.SALES_PLANT,
			--End [C20200707-000149] 자동차 사업부-환산정보(Cell/Car, Cell/Module, Module/Car), Sales Company, Plant Columns 추가
		   SITE_ITEM.LAST_UPDATE_DATE,
           SITE_ITEM.LAST_UPDATED_BY
		   , CASE WHEN ((FN_GET_DEPT_LIST(p_created_by, SITE.DEPT_ID) = 'Y') OR v_group_id ='ADMIN')
			THEN 'Y' ELSE '' END AS EDIT_FLAG
			, SITE_ITEM.ATTRIBUTE6 AS EDI	--20181116
			,SITE_ITEM.EDI_LT --20191017
			-- [C20220210-000268]Sales site project model에 '양극재, Module Variant' 컬럼 추가
			,NVL(SITE_ITEM.ATTRIBUTE1, NULL) AS ATTRIBUTE1
			,NVL(SITE_ITEM.ATTRIBUTE2, NULL) AS MODULE_VARIANT
		FROM SCM_MST_SITE_ITEM SITE_ITEM
		--[E20260123-001715]_[E20240904-001037] 소스 주석처리 START
		/*
		--------------------------[E20240904-001037]_81% 사업부인 경우에는 CELL/MODULE컬럼에 TEMP에 적재한 데이터를 보여준다 START -------------------
		JOIN GT_DMF0_SCM_MST_SITE_ITEM_CELL B2A
			ON SITE_ITEM.DIVISION_ID = B2A.DIVISION_ID AND SITE_ITEM.SCM_SITE_ID = B2A.SCM_SITE_ID
		   AND SITE_ITEM.PROJECT_CODE = B2A.PROJECT_CODE AND SITE_ITEM.ITEM_ID = B2A.ITEM_ID;
		-- ------------------------------------------------------------------------------------------------------------------------------------
		*/
		--[E20260123-001715]_[E20240904-001037] 소스 주석처리 END
		LEFT JOIN SCM_MST_PROJECT PJT
		ON   SITE_ITEM.PROJECT_CODE = PJT.PROJECT_CODE

		LEFT JOIN SCM_MST_SITE SITE
		ON				SITE_ITEM.DIVISION_ID = SITE.DIVISION_ID
		AND				SITE_ITEM.SCM_SITE_ID = SITE.SCM_SITE_ID
		AND   SITE_ITEM.DIVISION_ID  = PJT.DIVISION_ID
		LEFT JOIN		(SELECT T1.DIVISION_ID,
								T1.SCM_SITE_ID,
								T1.PROJECT_CODE,
								T1.ITEM_ID,
								T2.ITEM_TYPE,
								T2.ITEM_CLASS_NAME,
								T1.SALES_PLAN_ADJUST_YN,
								T2.NICK_NAME,
								T1.BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
								T1.LIABILITY_PERIOD,
								T1.CURRENCY,
								T1.VALID_YN,
								T1.LAST_UPDATE_DATE,
								T1.LAST_UPDATED_BY,
								T1.EDI_LT
						  FROM	SCM_MST_SITE_ITEM		T1
						  -- [E20240411-001030]_Sales Site Project Model 화면 하단 저장 로직 오류 수정_SINGLE_VIEW 테이블명 변경작업 진행
						  --FROM DM_MST_ITEM_SINGLE_V T2
						  JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V T2
						  ON	T1.DIVISION_ID = T2.DIVISION_ID
						  AND	T1.ITEM_ID   = T2.ITEM_ID
						  /*
						  WHERE (T2.ITEM_TYPE  = 'H'
						  OR	T2.ITEM_TYPE  = 'P');
						  */
													)					AS SITE_ITEM2
		ON				SITE_ITEM.DIVISION_ID = SITE_ITEM2.DIVISION_ID
		AND				SITE_ITEM.SCM_SITE_ID = SITE_ITEM2.SCM_SITE_ID
		and             SITE_ITEM.ITEM_ID     = SITE_ITEM2.ITEM_ID
		AND				SITE_ITEM.PROJECT_CODE = SITE_ITEM2.PROJECT_CODE
		--LEFT JOIN SCM_MST_ITEM_SN ITEM
		--ON   SITE_ITEM.ITEM_ID    = ITEM.ITEM_ID
		--AND   SITE_ITEM.DIVISION_ID  = ITEM.DIVISION_ID  --특정 사업부에서 사용하는 아이템이 다른 사업부에서 사용할 경우 주석처리.
		LEFT JOIN (SELECT  DIVISION_ID,
			  MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL,
			  SCM_SITE_ID,
			  PROJECT_CODE,
			  ITEM_ID
			FROM  DM_MST_CUSTOMER_MODEL
			GROUP BY  DIVISION_ID,;
			  SCM_SITE_ID,
			  PROJECT_CODE,
			  ITEM_ID    )    AS CUST_ITEM
		ON   SITE_ITEM.ITEM_ID  = CUST_ITEM.ITEM_ID
		AND   SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
		AND   SITE_ITEM.DIVISION_ID = CUST_ITEM.DIVISION_ID
		AND   SITE_ITEM.SCM_SITE_ID   = CUST_ITEM.SCM_SITE_ID
		-- WHERE  ITEM.ITEM_TYPE IN ('R','Q') -- Q-상품
		WHERE  SITE_ITEM2.ITEM_TYPE IN ('R','Q') -- Q-상품
		AND    SITE_ITEM.DIVISION_ID = p_division
		AND    SITE_ITEM.PROJECT_CODE = p_project_code
		AND    SITE_ITEM.SCM_SITE_ID = p_site_id
		AND    CASE WHEN p_active_flag = 'ALL' OR p_active_flag IS NULL THEN p_active_flag
                    ELSE SITE_ITEM.VALID_YN
 	           END  =  p_active_flag;

END;
/

-- DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION → PKG_DMF0005.P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION
(
	p_active_flag			VARCHAR2,	-- I:SCM_MST_PROJECT_ITEM를 찾아서 PROJECT_CODE의 PROJECT_VER_SEQ의 MAX를 찾아서 그들을 SELECT
	p_division_id			VARCHAR2,
	p_project_code			VARCHAR2,
	p_scm_site_id			VARCHAR2,
	p_item_id				VARCHAR2,	-- p_active_flag  DEFAULT 'I'일 경우 p_item_id 값이 공백이므로 SCM_MST_PROJECT_ITEM 에서 착아서 INSERT INTO 함
	p_currency				VARCHAR2,
	p_cell_per_car	 	    VARCHAR2,  -- 20180417 add skh
	p_cell_per_module		VARCHAR2,  -- 20180417 add skh
	p_liability_period		VARCHAR2,
	p_sales_plan_adjust_yn	VARCHAR2,
	p_item_hrcy_id			VARCHAR2,
	p_bpms_exist			VARCHAR2,
	p_valid_yn		 		VARCHAR2,
	--20180601 khsong 소형관련 신규 컬럼추가
	p_cust_group			VARCHAR2,
	p_cust_group_dtl		VARCHAR2,
	p_owner				VARCHAR2,
	p_application			VARCHAR2,
	p_route				VARCHAR2,
	--20180601 khsong 소형관련 신규 컬럼추가
	p_created_by			VARCHAR2,
	--p_success_yn			OUT VARCHAR2
	p_attribute1			VARCHAR2,
	p_attribute2			VARCHAR2,
	p_attribute4			VARCHAR2,  -- 20180727
	p_attribute6			VARCHAR2,  -- 20181031 EDI Incoterms용 컬럼추가
	p_edi_lt				VARCHAR2,  -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
	-- 20190402 KHSONG 소형 Report 컬럼 추가
	v_report_group1			VARCHAR2,
	v_report_group2			VARCHAR2,
	v_report_group3			VARCHAR2,
	v_report_group4			VARCHAR2,
	--v_report_group5			VARCHAR2,
	v_report_group6			VARCHAR2,
	v_report_group7			VARCHAR2,
	v_report_group8			VARCHAR2,
	p_vmi_LT				VARCHAR2,
	p_cell_name			VARCHAR2, --PJ20200138 Cell Name 추가
	p_sales_company		VARCHAR2, --[C20200513-000276] Sales Company, Sales Plant 추가
	p_sales_plant			VARCHAR2,
	p_partial_plan_yn		VARCHAR2, --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
	p_kwh					VARCHAR2, --[C20210525-000374] 셀용량 및 팩 당 용량 추가
	p_celltypeCD			VARCHAR2, --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
	p_production_process	VARCHAR2, --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
	p_consensus_Mkt        VARCHAR2,
	p_consensus_Ess        VARCHAR2,
	p_consensus_Scm        VARCHAR2,
	p_inventory_Day        VARCHAR2,
	p_change_Reason        VARCHAR2,
	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
    p_alt_sim_yn		    VARCHAR2,   --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
	p_description		    VARCHAR2,   --20230817 설명(DESCRIPTION) 컬럼 추가
	p_projectinfo		    VARCHAR2,   --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
	p_project_s_op_report  VARCHAR2,   --[E20240904-001037]_DM > Master > Sales Site Project Model
	p_cell_s_op_report		VARCHAR2,   --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
	p_prj_ownr_id			VARCHAR2,   --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
	p_crge_org_nm		    VARCHAR2,  -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
	p_cust_eng_nm		    VARCHAR2   -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:09
 * 파일: dbo.DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION.sql
 * ----------------------------------------
 * ⚠ IF: IF:28  END IF:17  차이:+11
 * ⚠ BEGIN: BEGIN:24  END:23  차이:+1
 * ----------------------------------------
 * BEGIN 위치: L291, L530, L535, L654, L843, L858, L875, L880, L885, L1012 ...
 * END;  위치: L865, L866, L877, L882, L887, L1010, L1086, L1091, L1096, L1212 ...
 * ----------------------------------------
 * 힌트: BEGIN이 2개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    v_recv_active_flag VARCHAR2(4000 CHAR);
    s_active_flag VARCHAR2(4000 CHAR);
    s_division_id VARCHAR2(4000 CHAR);
    s_project_code VARCHAR2(4000 CHAR);
    s_scm_site_id VARCHAR2(4000 CHAR);
    s_item_id VARCHAR2(4000 CHAR);
    s_currency VARCHAR2(4000 CHAR);
    s_cell_per_car VARCHAR2(4000 CHAR);
    s_cell_per_module VARCHAR2(4000 CHAR);
    s_liability_period VARCHAR2(4000 CHAR);
    s_sales_plan_adjust_yn VARCHAR2(4000 CHAR);
    s_item_hrcy_id VARCHAR2(4000 CHAR);
    s_bpms_exist VARCHAR2(4000 CHAR);
    s_valid_yn VARCHAR2(4000 CHAR);
    s_cust_group VARCHAR2(4000 CHAR);
    s_cust_group_dtl VARCHAR2(4000 CHAR);
    s_owner VARCHAR2(4000 CHAR);
    s_application VARCHAR2(4000 CHAR);
    s_route VARCHAR2(4000 CHAR);
    s_created_by VARCHAR2(4000 CHAR);
    s_attribute1 VARCHAR2(4000 CHAR);
    s_attribute2 VARCHAR2(4000 CHAR);
    s_attribute4 VARCHAR2(4000 CHAR);
    s_attribute6 VARCHAR2(4000 CHAR);
    s_edi_lt VARCHAR2(4000 CHAR);
    s_report_group1 VARCHAR2(4000 CHAR);
    s_report_group2 VARCHAR2(4000 CHAR);
    s_report_group3 VARCHAR2(4000 CHAR);
    s_report_group4 VARCHAR2(4000 CHAR);
    s_report_group6 VARCHAR2(4000 CHAR);
    s_report_group7 VARCHAR2(4000 CHAR);
    s_report_group8 VARCHAR2(4000 CHAR);
    s_vmi_lt VARCHAR2(4000 CHAR);
    s_cell_name VARCHAR2(4000 CHAR);
    s_sales_company VARCHAR2(4000 CHAR);
    s_sales_plant VARCHAR2(4000 CHAR);
    s_partial_plan_yn VARCHAR2(4000 CHAR);
    s_kwh VARCHAR2(4000 CHAR);
    s_celltypeCD VARCHAR2(4000 CHAR);
    s_production_process VARCHAR2(4000 CHAR);
    s_consensus_Mkt VARCHAR2(4000 CHAR);
    s_consensus_Ess VARCHAR2(4000 CHAR);
    s_consensus_Scm VARCHAR2(4000 CHAR);
    s_inventory_Day VARCHAR2(4000 CHAR);
    s_change_Reason VARCHAR2(4000 CHAR);
    s_alt_sim_yn VARCHAR2(4000 CHAR);
    s_description VARCHAR2(4000 CHAR);
    s_project_info VARCHAR2(4000 CHAR);
    s_project_s_op_report VARCHAR2(4000 CHAR);
    s_cell_s_op_report VARCHAR2(4000 CHAR);
    s_prj_ownr_id VARCHAR2(4000 CHAR);
    s_crge_org_nm VARCHAR2(4000 CHAR);
    s_cust_eng_nm VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := 'DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description2 VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_insert_count INTEGER := 0;
    n_logo_count INTEGER := 0;
    v_0week_monday VARCHAR2(08 CHAR);
    v_index_active_flag INTEGER;
    v_index_division_id INTEGER;
    v_index_project_code INTEGER;
    v_index_scm_site_id INTEGER;
    v_index_item_id INTEGER;
    v_index_currency INTEGER;
    v_index_cell_per_car INTEGER;
    v_index_cell_per_module INTEGER;
    v_index_liability_period INTEGER;
    v_index_sales_plan_adjust_yn INTEGER;
    v_index_item_hrcy_id INTEGER;
    v_index_bpms_exist INTEGER;
    v_index_valid_yn INTEGER;
    v_index_cust_group INTEGER;
    v_index_cust_group_dtl INTEGER;
    v_index_owner INTEGER;
    v_index_application INTEGER;
    v_index_route INTEGER;
    v_index_created_by INTEGER;
    v_index_attribute1 INTEGER;
    v_index_attribute2 INTEGER;
    v_index_attribute4 INTEGER;
    v_index_attribute6 INTEGER;
    v_index_edi_lt INTEGER;
    v_index_report_group1 INTEGER;
    v_index_report_group2 INTEGER;
    v_index_report_group3 INTEGER;
    v_index_report_group4 INTEGER;
    v_index_report_group6 INTEGER;
    v_index_report_group7 INTEGER;
    v_index_report_group8 INTEGER;
    v_index_vmi_lt INTEGER;
    v_index_sales_plant INTEGER;
    v_index_consensus_Mkt INTEGER;
    v_index_consensus_Ess INTEGER;
    v_index_consensus_Scm INTEGER;
    v_index_inventory_Day INTEGER;
    v_index_change_Reason INTEGER;
    s_modify VARCHAR2(4000 CHAR);
    s_count INTEGER;
    v_active_flag VARCHAR2(01 CHAR);
    v_division_id VARCHAR2(30 CHAR);
    v_project_code VARCHAR2(50 CHAR);
    v_scm_site_id VARCHAR2(30 CHAR);
    v_item_id VARCHAR2(50 CHAR);
    v_currency VARCHAR2(10 CHAR);
    v_liability_period INTEGER;
    v_sales_plan_adjust_yn VARCHAR2(01 CHAR);
    v_item_hrcy_id VARCHAR2(50 CHAR);
    v_bpms_exist VARCHAR2(01 CHAR);
    v_valid_yn VARCHAR2(01 CHAR);
    v_cust_group VARCHAR2(100 CHAR);
    v_cust_group_dtl VARCHAR2(100 CHAR);
    v_owner VARCHAR2(100 CHAR);
    v_application VARCHAR2(100 CHAR);
    v_route VARCHAR2(40 CHAR);
    v_created_by VARCHAR2(150 CHAR);
    v_LAST_UPDATED_BY VARCHAR2(150 CHAR);
    v_LAST_UPDATE_DATE VARCHAR2(150 CHAR);
    v_attribute1 VARCHAR2(150 CHAR);
    v_attribute2 VARCHAR2(150 CHAR);
    v_attribute4 VARCHAR2(150 CHAR);
    v_attribute6 VARCHAR2(150 CHAR);
    v_edi_lt INTEGER;
    v_report_group1 VARCHAR2(300 CHAR);
    v_report_group2 VARCHAR2(300 CHAR);
    v_report_group3 VARCHAR2(300 CHAR);
    v_report_group4 VARCHAR2(300 CHAR);
    v_report_group6 VARCHAR2(300 CHAR);
    v_report_group7 VARCHAR2(300 CHAR);
    v_report_group8 VARCHAR2(300 CHAR);
    v_vmi_lt VARCHAR2(300 CHAR);
    v_cell_name VARCHAR2(300 CHAR);
    v_sales_company VARCHAR2(300 CHAR);
    v_sales_plant VARCHAR2(300 CHAR);
    v_partial_plan_yn VARCHAR2(300 CHAR);
    v_kwh VARCHAR2(300 CHAR);
    v_celltypeCD VARCHAR2(300 CHAR);
    v_production_process VARCHAR2(150 CHAR);
    v_consensus_Mkt VARCHAR2(2 CHAR);
    v_consensus_Ess VARCHAR2(2 CHAR);
    v_consensus_Scm VARCHAR2(2 CHAR);
    v_inventory_Day VARCHAR2(5 CHAR);
    v_change_Reason VARCHAR2(500 CHAR);
    v_alt_sim_yn VARCHAR2(1 CHAR);
    v_description VARCHAR2(100 CHAR);
    v_project_info VARCHAR2(200 CHAR);
    v_project_s_op_report VARCHAR2(200 CHAR);
    v_cell_s_op_report VARCHAR2(200 CHAR);
    v_prj_ownr_id VARCHAR2(200 CHAR);
    v_crge_org_nm VARCHAR2(100 CHAR);
    v_cust_eng_nm VARCHAR2(300 CHAR);
    V_DUP_ITEM_ID VARCHAR2(4000 CHAR);
    v_cnt_1  INTEGER := 0;
    v_cnt_2  INTEGER := 0;
    v_cnt_3  INTEGER := 0;
    v_cnt_4  INTEGER := 0;
    v_cnt_5  INTEGER := 0;
    v_cnt_6  INTEGER := 0;
BEGIN
	DBMS_OUTPUT.PUT_LINE(p_change_Reason);

	v_recv_active_flag := NULL;
	v_recv_active_flag := p_active_flag;

	-- 스플릿관련 변수
























	--    v_project_item_cnt INTEGER;
	--    v_project_item_cnt_40 INTEGER;
	--    v_project_item_cnt_41 INTEGER;

	-- 20190402 KHSONG 소형 Report 컬럼 추가

















	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선















	s_active_flag := NULL;
	s_division_id := NULL;
	s_project_code := NULL;
	s_scm_site_id := NULL;
	s_item_id := NULL;
	s_currency := NULL;
	s_cell_per_car := NULL;
	s_cell_per_module := NULL;
	s_liability_period := NULL;
	s_sales_plan_adjust_yn := NULL;
	s_item_hrcy_id := NULL;
	s_bpms_exist := NULL;
	s_valid_yn := NULL;
	s_created_by := NULL;
	s_attribute1 := NULL;
	s_attribute2 := NULL;
	s_attribute4 := NULL; -- 20180727
	s_attribute6 := NULL; -- 20181031
	s_edi_lt := NULL; -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
	--v_project_item_cnt := 1;
	--v_project_item_cnt_40 := 0;
	--v_project_item_cnt_41 := 0;

	-- 20190402 KHSONG 소형 Report 컬럼 추가
	s_report_group1 := NULL;
	s_report_group2 := NULL;
	s_report_group3 := NULL;
	s_report_group4 := NULL;
	--v_report_group5 := NULL
	s_report_group6 := NULL;
	s_report_group7 := NULL;
	s_report_group8 := NULL;
	s_vmi_lt := NULL;
	s_cell_name := NULL; --PJ20200138 Cell Name 추가
	s_sales_company := NULL; --[C20200513-000276] Sales Company, Sales Plant 추가
	s_sales_plant := NULL;
	s_partial_plan_yn := NULL; --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
	s_kwh := NULL; --[C20210525-000374] 셀용량 및 팩 당 용량 추가
	s_celltypeCD := NULL; --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
	s_production_process := NULL; --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
	s_consensus_Mkt := NULL;
	s_consensus_Ess := NULL;
	s_consensus_Scm := NULL;
	s_inventory_Day := NULL;
	s_change_Reason := NULL;
	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
	s_alt_sim_yn := NULL; --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
	s_description := NULL; --20230817 설명(DESCRIPTION) 컬럼 추가
	s_project_info := NULL; --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
	s_project_s_op_report := NULL; --[E20240904-001037]_DM > Master > Sales Site Project Model
	s_cell_s_op_report := NULL; --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
	s_prj_ownr_id := NULL; --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건

	s_crge_org_nm := NULL; -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
	s_cust_eng_nm := NULL; -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)

	-- 마지막 데이터 처리를 위한 구분자 추가
	p_active_flag := RTRIM(p_active_flag						)  ||  '^';
	p_division_id := RTRIM(p_division_id						)  ||  '^';
	p_project_code := RTRIM(p_project_code						)  ||  '^';
	p_scm_site_id := RTRIM(p_scm_site_id						)  ||  '^';
	p_item_id := RTRIM(p_item_id							)  ||  '^';
	p_currency := RTRIM(p_currency							)  ||  '^';
	p_cell_per_car := RTRIM(p_cell_per_car	 	    			)  ||  '^';
	p_cell_per_module := RTRIM(p_cell_per_module					)  ||  '^';
	p_liability_period := RTRIM(p_liability_period					)  ||  '^';
	p_sales_plan_adjust_yn := RTRIM(p_sales_plan_adjust_yn				)  ||  '^';
	p_item_hrcy_id := RTRIM(p_item_hrcy_id						)  ||  '^';
	p_bpms_exist := RTRIM(p_bpms_exist						)  ||  '^';
	p_valid_yn := RTRIM(p_valid_yn		 					)  ||  '^';
	p_cust_group := RTRIM(p_cust_group						)  ||  '^';
	p_cust_group_dtl := RTRIM(p_cust_group_dtl					)  ||  '^';
	p_owner := RTRIM(p_owner							)  ||  '^';
	p_application := RTRIM(p_application						)  ||  '^';
	p_route := RTRIM(p_route							)  ||  '^';
	p_created_by := RTRIM(p_created_by						)  ||  '^';
	p_attribute1 := RTRIM(p_attribute1						)  ||  '^';
	p_attribute2 := RTRIM(p_attribute2						)  ||  '^';
	p_attribute4 := RTRIM(p_attribute4						)  ||  '^';
	p_attribute6 := RTRIM(p_attribute6						)  ||  '^';
	p_edi_lt := RTRIM(p_edi_lt							)  ||  '^';

	v_report_group1 := RTRIM(v_report_group1					)  ||  '^';
	v_report_group2 := RTRIM(v_report_group2					)  ||  '^';
	v_report_group3 := RTRIM(v_report_group3					)  ||  '^';
	v_report_group4 := RTRIM(v_report_group4					)  ||  '^';
	--v_report_group5 := RTRIM(v_report_group5					) + '^';
	v_report_group6 := RTRIM(v_report_group6					)  ||  '^';
	v_report_group7 := RTRIM(v_report_group7					)  ||  '^';
	v_report_group8 := RTRIM(v_report_group8					)  ||  '^';
	p_vmi_lt := RTRIM(p_vmi_lt						)  ||  '^';
	p_cell_name := RTRIM(p_cell_name					)  ||  '^'; --PJ20200138 Cell Name 추가

	p_sales_company := RTRIM(p_sales_company				)  ||  '^'; --[C20200513-000276] Sales Company, Sales Plant 추가
	p_sales_plant := RTRIM(p_sales_plant					)  ||  '^';
	p_partial_plan_yn := RTRIM(p_partial_plan_yn				)  ||  '^'; --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
	p_kwh := RTRIM(p_kwh							)  ||  '^'; --[C20210525-000374] 셀용량 및 팩 당 용량 추가
	p_celltypeCD := RTRIM(p_celltypeCD					)  ||  '^'; --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
	p_production_process := RTRIM(p_production_process			)  ||  '^'; --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
	p_consensus_Mkt := RTRIM(p_consensus_Mkt				)  ||  '^';
	p_consensus_Ess := RTRIM(p_consensus_Ess				)  ||  '^';
	p_consensus_Scm := RTRIM(p_consensus_Scm				)  ||  '^';
	p_inventory_Day := RTRIM(p_inventory_Day				)  ||  '^';
	p_change_Reason := RTRIM(p_change_Reason				)  ||  '^';
	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
	p_alt_sim_yn := RTRIM(p_alt_sim_yn					)  ||  '^'; --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
	p_description := RTRIM(p_description					)  ||  '^'; --20230817 설명(DESCRIPTION) 컬럼 추가
	p_projectinfo := RTRIM(p_projectinfo					)  ||  '^'; --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
	p_project_s_op_report := RTRIM(p_project_s_op_report			)  ||  '^'; --[E20240904-001037]_DM > Master > Sales Site Project Model
	p_cell_s_op_report := RTRIM(p_cell_s_op_report				)  ||  '^'; --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
	p_prj_ownr_id := RTRIM(p_prj_ownr_id					)  ||  '^'; --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건

	p_crge_org_nm := RTRIM(p_crge_org_nm				    )  ||  '^'; -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
	p_cust_eng_nm := RTRIM(p_cust_eng_nm				    )  ||  '^'; -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)

	-- GT_DMF0_results_MST TEMP TABLE
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_results_MST';

	-- PJ20228272 NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) START

	-- GT_DMF0_RESULT_MST TEMP TABLE
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_RESULT_MST';

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_XIF_ERP_SITE_ITEM';
	-- PJ20228272 NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) END


	-- LOG 용 변수 설정









	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description2 := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description2, d_event_date);

	-- 시작 LOG  (END)
	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/

	-- ---------------------------------------------------------------------------------------
	-- 20191118 KHSONG [CSR:C20191031-000137] EDI_LT 데이터 판단용 TEMP TABLE 생성 (BEGIN)
	-- ---------------------------------------------------------------------------------------
	SELECTDIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,EDI_LT
	/* TODO:GTT:GT_DMF0_EDI_LT-->GT_DMF0_EDI_LT */
	INSERT INTO GT_DMF0_EDI_LT
		FROM SCM_MST_SITE_ITEM;

	-- 월요일 변수 셋팅

	v_0week_monday := TO_CHAR(FN_NEXT_DAY(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'MON')  ||  (-7), 'YYYYMMDD'); --W0월요일

	-- ---------------------------------------------------------------------------------------
	-- 20191118 KHSONG [CSR:C20191031-000137] EDI_LT 데이터 판단용 TEMP TABLE 생성 (END)
	-- ---------------------------------------------------------------------------------------
	BEGIN TRY

	--------------------------------------------------------------------------------------------◇◇◇◇
	--          GT_DMF0_results_MST 테이블에 split후 insert (BEGIN)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN  --split

		WHILE LENGTH(p_DIVISION_ID) > 0

		---------------------------(2)
		BEGIN  -- WHILE
		---------------------------(2)
































			DECLARE v_index_cell_name			INTEGER --PJ20200138 Cell Name 추가
			DECLARE v_index_sales_company		INTEGER --[C20200513-000276] Sales Company, Sales Plant 추가

			DECLARE v_index_partial_plan_yn		INTEGER --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
			DECLARE v_index_kwh					INTEGER --[C20210525-000374] 셀용량 및 팩 당 용량 추가
			DECLARE v_index_celltypeCD			INTEGER --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
			DECLARE v_index_production_process	INTEGER --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START





			DECLARE v_index_alt_sim_yn   	    INTEGER --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
			DECLARE v_index_description   	    INTEGER --20230817 설명(DESCRIPTION) 컬럼 추가
			DECLARE v_index_project_info   	    INTEGER --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
			DECLARE v_index_project_s_op_report  INTEGER --[E20240904-001037]_DM > Master > Sales Site Project Model
			DECLARE v_index_cell_s_op_report		INTEGER --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
			DECLARE v_index_prj_ownr_id		    INTEGER --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건

			DECLARE v_index_crge_org_nm			INTEGER -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
			DECLARE v_index_cust_eng_nm			INTEGER -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)

			v_index_active_flag := PATINDEX('%'  ||  '^'  ||  '%', p_active_flag			);
			v_index_division_id := PATINDEX('%'  ||  '^'  ||  '%', p_division_id			);
			v_index_project_code := PATINDEX('%'  ||  '^'  ||  '%', p_project_code			);
			v_index_scm_site_id := PATINDEX('%'  ||  '^'  ||  '%', p_scm_site_id			);
			v_index_item_id := PATINDEX('%'  ||  '^'  ||  '%', p_item_id				);
			v_index_currency := PATINDEX('%'  ||  '^'  ||  '%', p_currency				);
			v_index_cell_per_car := PATINDEX('%'  ||  '^'  ||  '%', p_cell_per_car	 		);
			v_index_cell_per_module := PATINDEX('%'  ||  '^'  ||  '%', p_cell_per_module		);
			v_index_liability_period := PATINDEX('%'  ||  '^'  ||  '%', p_liability_period		);
			v_index_sales_plan_adjust_yn := PATINDEX('%'  ||  '^'  ||  '%', p_sales_plan_adjust_yn	);
			v_index_item_hrcy_id := PATINDEX('%'  ||  '^'  ||  '%', p_item_hrcy_id			);
			v_index_bpms_exist := PATINDEX('%'  ||  '^'  ||  '%', p_bpms_exist			    );
			v_index_valid_yn := PATINDEX('%'  ||  '^'  ||  '%', p_valid_yn		 		);
			v_index_cust_group := PATINDEX('%'  ||  '^'  ||  '%', p_cust_group			    );
			v_index_cust_group_dtl := PATINDEX('%'  ||  '^'  ||  '%', p_cust_group_dtl		    );
			v_index_owner := PATINDEX('%'  ||  '^'  ||  '%', p_owner				    );
			v_index_application := PATINDEX('%'  ||  '^'  ||  '%', p_application			);
			v_index_route := PATINDEX('%'  ||  '^'  ||  '%', p_route				    );
			v_index_created_by := PATINDEX('%'  ||  '^'  ||  '%', p_created_by			    );
			v_index_attribute1 := PATINDEX('%'  ||  '^'  ||  '%', p_attribute1			    );
			v_index_attribute2 := PATINDEX('%'  ||  '^'  ||  '%', p_attribute2			    );
			v_index_attribute4 := PATINDEX('%'  ||  '^'  ||  '%', p_attribute4			    );
			v_index_attribute6 := PATINDEX('%'  ||  '^'  ||  '%', p_attribute6			    );
			v_index_edi_lt := PATINDEX('%'  ||  '^'  ||  '%', p_edi_lt				    );
			v_index_report_group1 := PATINDEX('%'  ||  '^'  ||  '%', v_report_group1		    );
			v_index_report_group2 := PATINDEX('%'  ||  '^'  ||  '%', v_report_group2		    );
			v_index_report_group3 := PATINDEX('%'  ||  '^'  ||  '%', v_report_group3		    );
			v_index_report_group4 := PATINDEX('%'  ||  '^'  ||  '%', v_report_group4		    );
			--v_index_report_group5 := PATINDEX('%' + '^' + '%', v_report_group5		    )
			v_index_report_group6 := PATINDEX('%'  ||  '^'  ||  '%', v_report_group6		    );
			v_index_report_group7 := PATINDEX('%'  ||  '^'  ||  '%', v_report_group7		    );
			v_index_report_group8 := PATINDEX('%'  ||  '^'  ||  '%', v_report_group8		    );
			v_index_vmi_lt := PATINDEX('%'  ||  '^'  ||  '%', p_vmi_lt		            );
			v_index_cell_name := PATINDEX('%'  ||  '^'  ||  '%', p_cell_name		        ); --PJ20200138 Cell Name 추가
			v_index_sales_company := PATINDEX('%'  ||  '^'  ||  '%', p_sales_company          ); --[C20200513-000276] Sales Company, Sales Plant 추가
			v_index_sales_plant := PATINDEX('%'  ||  '^'  ||  '%', p_sales_plant            );
			v_index_partial_plan_yn := PATINDEX('%'  ||  '^'  ||  '%', p_partial_plan_yn        ); --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
			v_index_kwh := PATINDEX('%'  ||  '^'  ||  '%', p_kwh					); --[C20210525-000374] 셀용량 및 팩 당 용량 추가
			v_index_celltypeCD := PATINDEX('%'  ||  '^'  ||  '%', p_celltypeCD				); --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
			v_index_production_process := PATINDEX('%'  ||  '^'  ||  '%', p_production_process		); --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
			v_index_consensus_Mkt := PATINDEX('%'  ||  '^'  ||  '%', p_consensus_Mkt			);
			v_index_consensus_Ess := PATINDEX('%'  ||  '^'  ||  '%', p_consensus_Ess			);
			v_index_consensus_Scm := PATINDEX('%'  ||  '^'  ||  '%', p_consensus_Scm			);
			v_index_inventory_Day := PATINDEX('%'  ||  '^'  ||  '%', p_inventory_Day			);
			v_index_change_Reason := PATINDEX('%'  ||  '^'  ||  '%', p_change_Reason			);
			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
			v_index_alt_sim_yn := PATINDEX('%'  ||  '^'  ||  '%', p_alt_sim_yn				); --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
			v_index_description := PATINDEX('%'  ||  '^'  ||  '%', p_description			); --20230817 설명(DESCRIPTION) 컬럼 추가
			v_index_project_info := PATINDEX('%'  ||  '^'  ||  '%', p_projectinfo			); --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
			v_index_project_s_op_report := PATINDEX('%'  ||  '^'  ||  '%', p_project_s_op_report	); --[E20240904-001037]_DM > Master > Sales Site Project Model
			v_index_cell_s_op_report := PATINDEX('%'  ||  '^'  ||  '%', p_cell_s_op_report		); --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
			v_index_prj_ownr_id := PATINDEX('%'  ||  '^'  ||  '%', p_prj_ownr_id			); --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건

			v_index_crge_org_nm := PATINDEX('%'  ||  '^'  ||  '%', p_crge_org_nm		    ); -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
			v_index_cust_eng_nm := PATINDEX('%'  ||  '^'  ||  '%', p_cust_eng_nm		    ); -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)

			---------------------------(1)
			IF v_index_DIVISION_ID > 0
			---------------------------(1)
				BEGIN
					s_active_flag := SUBSTR(p_active_flag				, 0, v_index_active_flag			);
					s_division_id := SUBSTR(p_division_id				, 0, v_index_division_id			);
					s_project_code := SUBSTR(p_project_code				, 0, v_index_project_code			);
					s_scm_site_id := SUBSTR(p_scm_site_id				, 0, v_index_scm_site_id			);
					s_item_id := SUBSTR(p_item_id					, 0, v_index_item_id				);
					s_currency := SUBSTR(p_currency					, 0, v_index_currency				);
					s_cell_per_car := SUBSTR(p_cell_per_car	 			, 0, v_index_cell_per_car	 		);
					s_cell_per_module := SUBSTR(p_cell_per_module			, 0, v_index_cell_per_module		);
					s_liability_period := SUBSTR(p_liability_period			, 0, v_index_liability_period		);
					s_sales_plan_adjust_yn := SUBSTR(p_sales_plan_adjust_yn		, 0, v_index_sales_plan_adjust_yn	);
					s_item_hrcy_id := SUBSTR(p_item_hrcy_id				, 0, v_index_item_hrcy_id			);
					s_bpms_exist := SUBSTR(p_bpms_exist				, 0, v_index_bpms_exist			    );
					s_valid_yn := SUBSTR(p_valid_yn					, 0, v_index_valid_yn		 		);
					s_cust_group := SUBSTR(p_cust_group				, 0, v_index_cust_group			    );
					s_cust_group_dtl := SUBSTR(p_cust_group_dtl			, 0, v_index_cust_group_dtl		    );
					s_owner := SUBSTR(p_owner					, 0, v_index_owner				    );
					s_application := SUBSTR(p_application				, 0, v_index_application			);
					s_route := SUBSTR(p_route					, 0, v_index_route				    );
					s_created_by := SUBSTR(p_created_by				, 0, v_index_created_by			    );
					s_attribute1 := SUBSTR(p_attribute1				, 0, v_index_attribute1			    );
					s_attribute2 := SUBSTR(p_attribute2				, 0, v_index_attribute2			    );
					s_attribute4 := SUBSTR(p_attribute4				, 0, v_index_attribute4			    );
					s_attribute6 := SUBSTR(p_attribute6				, 0, v_index_attribute6			    );
					s_edi_lt := SUBSTR(p_edi_lt					, 0, v_index_edi_lt				    );
					s_report_group1 := SUBSTR(v_report_group1				, 0, v_index_report_group1		    );
					s_report_group2 := SUBSTR(v_report_group2				, 0, v_index_report_group2		    );
					s_report_group3 := SUBSTR(v_report_group3				, 0, v_index_report_group3		    );
					s_report_group4 := SUBSTR(v_report_group4				, 0, v_index_report_group4		    );
					--v_report_group5 := SUBSTR(v_report_group5				, 0, v_index_report_group5		    )
					s_report_group6 := SUBSTR(v_report_group6				, 0, v_index_report_group6		    );
					s_report_group7 := SUBSTR(v_report_group7				, 0, v_index_report_group7		    );
					s_report_group8 := SUBSTR(v_report_group8				, 0, v_index_report_group8		    );
					s_vmi_lt := SUBSTR(p_vmi_lt					, 0, v_index_vmi_lt					);
					s_cell_name := SUBSTR(p_cell_name				, 0, v_index_cell_name				); --PJ20200138 Cell Name 추가
					s_sales_company := SUBSTR(p_sales_company			, 0, v_index_sales_company			); --[C20200513-000276] Sales Company, Sales Plant 추가
					s_sales_plant := SUBSTR(p_sales_plant				, 0, v_index_sales_plant				);
					s_partial_plan_yn := SUBSTR(p_partial_plan_yn			, 0, v_index_partial_plan_yn			); --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					s_kwh := SUBSTR(p_kwh						, 0, v_index_kwh						); --[C20210525-000374] 셀용량 및 팩 당 용량 추가
					s_celltypeCD := SUBSTR(p_celltypeCD				, 0, v_index_celltypeCD				); --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					s_production_process := SUBSTR(p_production_process		, 0, v_index_production_process		); --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					s_consensus_Mkt := SUBSTR(p_consensus_Mkt		    , 0, v_index_consensus_Mkt			);
					s_consensus_Ess := SUBSTR(p_consensus_Ess		    , 0, v_index_consensus_Ess			);
					s_consensus_Scm := SUBSTR(p_consensus_Scm		    , 0, v_index_consensus_Scm			);
					s_inventory_Day := SUBSTR(p_inventory_Day		    , 0, v_index_inventory_Day			);
					s_change_Reason := SUBSTR(p_change_Reason		    , 0, v_index_change_Reason			);
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					s_alt_sim_yn := SUBSTR(p_alt_sim_yn		        , 0, v_index_alt_sim_yn				); --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					s_description := SUBSTR(p_description		        , 0, v_index_description				); --20230817 설명(DESCRIPTION) 컬럼 추가
					s_project_info := SUBSTR(p_projectinfo		        , 0, v_index_project_info			); --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					s_project_s_op_report := SUBSTR(p_project_s_op_report      , 0, v_index_project_s_op_report	    ); --[E20240904-001037]_DM > Master > Sales Site Project Model
					s_cell_s_op_report := SUBSTR(p_cell_s_op_report			, 0, v_index_cell_s_op_report	    ); --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
					s_prj_ownr_id := SUBSTR(p_prj_ownr_id				, 0, v_index_prj_ownr_id				); --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건


					s_crge_org_nm := SUBSTR(p_crge_org_nm			    , 0, v_index_crge_org_nm	            ); -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					s_cust_eng_nm := SUBSTR(p_cust_eng_nm			    , 0, v_index_cust_eng_nm	            ); -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)

					p_active_flag := SUBSTR(p_active_flag				, LENGTH(s_active_flag			  ||  '^') || 1, LENGTH(p_active_flag				));
					p_division_id := SUBSTR(p_division_id				, LENGTH(s_division_id			  ||  '^') || 1, LENGTH(p_division_id				));
					p_project_code := SUBSTR(p_project_code				, LENGTH(s_project_code			  ||  '^') || 1, LENGTH(p_project_code			));
					p_scm_site_id := SUBSTR(p_scm_site_id				, LENGTH(s_scm_site_id			  ||  '^') || 1, LENGTH(p_scm_site_id				));
					p_item_id := SUBSTR(p_item_id					, LENGTH(s_item_id				  ||  '^') || 1, LENGTH(p_item_id					));
					p_currency := SUBSTR(p_currency					, LENGTH(s_currency				  ||  '^') || 1, LENGTH(p_currency				));
					p_cell_per_car := SUBSTR(p_cell_per_car	 			, LENGTH(s_cell_per_car	 		  ||  '^') || 1, LENGTH(p_cell_per_car	 		));
					p_cell_per_module := SUBSTR(p_cell_per_module			, LENGTH(s_cell_per_module		  ||  '^') || 1, LENGTH(p_cell_per_module			));
					p_liability_period := SUBSTR(p_liability_period			, LENGTH(s_liability_period		  ||  '^') || 1, LENGTH(p_liability_period		));
					p_sales_plan_adjust_yn := SUBSTR(p_sales_plan_adjust_yn		, LENGTH(s_sales_plan_adjust_yn	  ||  '^') || 1, LENGTH(p_sales_plan_adjust_yn	));
					p_item_hrcy_id := SUBSTR(p_item_hrcy_id				, LENGTH(s_item_hrcy_id			  ||  '^') || 1, LENGTH(p_item_hrcy_id			));
					p_bpms_exist := SUBSTR(p_bpms_exist				, LENGTH(s_bpms_exist				  ||  '^') || 1, LENGTH(p_bpms_exist				));
					p_valid_yn := SUBSTR(p_valid_yn		 			, LENGTH(s_valid_yn		 		  ||  '^') || 1, LENGTH(p_valid_yn		 		));
					p_cust_group := SUBSTR(p_cust_group				, LENGTH(s_cust_group				  ||  '^') || 1, LENGTH(p_cust_group				));
					p_cust_group_dtl := SUBSTR(p_cust_group_dtl			, LENGTH(s_cust_group_dtl			  ||  '^') || 1, LENGTH(p_cust_group_dtl			));
					p_owner := SUBSTR(p_owner					, LENGTH(s_owner					  ||  '^') || 1, LENGTH(p_owner					));
					p_application := SUBSTR(p_application				, LENGTH(s_application			  ||  '^') || 1, LENGTH(p_application				));
					p_route := SUBSTR(p_route					, LENGTH(s_route					  ||  '^') || 1, LENGTH(p_route					));
					p_created_by := SUBSTR(p_created_by				, LENGTH(s_created_by				  ||  '^') || 1, LENGTH(p_created_by				));
					p_attribute1 := SUBSTR(p_attribute1				, LENGTH(s_attribute1				 + '^') || 1, LENGTH(p_attribute1				));
					p_attribute2 := SUBSTR(p_attribute2				, LENGTH(s_attribute2				 + '^') || 1, LENGTH(p_attribute2				));
					p_attribute4 := SUBSTR(p_attribute4				, LENGTH(s_attribute4				 + '^') || 1, LENGTH(p_attribute4				));
					p_attribute6 := SUBSTR(p_attribute6				, LENGTH(s_attribute6				 + '^') || 1, LENGTH(p_attribute6				));
					p_edi_lt := SUBSTR(p_edi_lt					, LENGTH(s_edi_lt					  ||  '^') || 1, LENGTH(p_edi_lt					));
					v_report_group1 := SUBSTR(v_report_group1				, LENGTH(s_report_group1			 + '^') || 1, LENGTH(v_report_group1				));
					v_report_group2 := SUBSTR(v_report_group2				, LENGTH(s_report_group2			 + '^') || 1, LENGTH(v_report_group2				));
					v_report_group3 := SUBSTR(v_report_group3				, LENGTH(s_report_group3			 + '^') || 1, LENGTH(v_report_group3				));
					v_report_group4 := SUBSTR(v_report_group4				, LENGTH(s_report_group4			 + '^') || 1, LENGTH(v_report_group4				));
					--v_report_group5 := SUBSTR(v_report_group5				, LENGTH(v_report_group5			 + '^') + 1, LENGTH(v_report_group5		))
					v_report_group6 := SUBSTR(v_report_group6				, LENGTH(s_report_group6			 + '^') || 1, LENGTH(v_report_group6				));
					v_report_group7 := SUBSTR(v_report_group7				, LENGTH(s_report_group7			 + '^') || 1, LENGTH(v_report_group7				));
					v_report_group8 := SUBSTR(v_report_group8				, LENGTH(s_report_group8			 + '^') || 1, LENGTH(v_report_group8				));
					p_vmi_lt := SUBSTR(p_vmi_lt					, LENGTH(s_vmi_lt					  ||  '^') || 1, LENGTH(p_vmi_lt					));
					p_cell_name := SUBSTR(p_cell_name				, LENGTH(s_cell_name				  ||  '^') || 1, LENGTH(p_cell_name				)); --PJ20200138 Cell Name 추가
					p_sales_company := SUBSTR(p_sales_company			, LENGTH(s_sales_company			  ||  '^') || 1, LENGTH(p_sales_company			)); --[C20200513-000276] Sales Company, Sales Plant 추가
					p_sales_plant := SUBSTR(p_sales_plant				, LENGTH(s_sales_plant			  ||  '^') || 1, LENGTH(p_sales_plant				));
					p_partial_plan_yn := SUBSTR(p_partial_plan_yn			, LENGTH(s_partial_plan_yn		  ||  '^') || 1, LENGTH(p_partial_plan_yn			)); --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					p_kwh := SUBSTR(p_kwh						, LENGTH(s_kwh					  ||  '^') || 1, LENGTH(p_kwh						)); --[C20210525-000374] 셀용량 및 팩 당 용량 추가
					p_celltypeCD := SUBSTR(p_celltypeCD				, LENGTH(s_celltypeCD				  ||  '^') || 1, LENGTH(p_celltypeCD				)); --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					p_production_process := SUBSTR(p_production_process		, LENGTH(s_production_process		  ||  '^') || 1, LENGTH(p_production_process		)); --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

					DBMS_OUTPUT.PUT_LINE(s_consensus_Mkt);
FETCH FIRST 0 ROWS ONLY;
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					p_consensus_Mkt := SUBSTR(p_consensus_Mkt		, LENGTH(s_consensus_Mkt		  ||  '^') || 1, LENGTH(p_consensus_Mkt		));
					p_consensus_Ess := SUBSTR(p_consensus_Ess		, LENGTH(s_consensus_Ess		  ||  '^') || 1, LENGTH(p_consensus_Ess		));
					p_consensus_Scm := SUBSTR(p_consensus_Scm		, LENGTH(s_consensus_Scm		  ||  '^') || 1, LENGTH(p_consensus_Scm		));
					p_inventory_Day := SUBSTR(p_inventory_Day		, LENGTH(s_inventory_Day		  ||  '^') || 1, LENGTH(p_inventory_Day		));
					p_change_Reason := SUBSTR(p_change_Reason		, LENGTH(s_change_Reason		  ||  '^') || 1, LENGTH(p_change_Reason		));
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					DBMS_OUTPUT.PUT_LINE(p_consensus_Mkt);
					p_alt_sim_yn := SUBSTR(p_alt_sim_yn		, LENGTH(s_alt_sim_yn		  ||  '^') || 1, LENGTH(p_alt_sim_yn		)); --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					p_description := SUBSTR(p_description	, LENGTH(s_description	  ||  '^') || 1, LENGTH(p_description		)); --20230817 설명(DESCRIPTION) 컬럼 추가
					p_projectinfo := SUBSTR(p_projectinfo	, LENGTH(s_project_info	  ||  '^') || 1, LENGTH(p_projectinfo	)); --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					p_project_s_op_report := SUBSTR(p_project_s_op_report	, LENGTH(s_project_s_op_report	  ||  '^') || 1, LENGTH(p_project_s_op_report	)); --[E20240904-001037]_DM > Master > Sales Site Project Model
					p_cell_s_op_report := SUBSTR(p_cell_s_op_report	, LENGTH(s_cell_s_op_report	  ||  '^') || 1, LENGTH(p_cell_s_op_report	)); --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
					p_prj_ownr_id := SUBSTR(p_prj_ownr_id		, LENGTH(s_prj_ownr_id		  ||  '^') || 1, LENGTH(p_prj_ownr_id		)); --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건

					p_crge_org_nm := SUBSTR(p_crge_org_nm	, LENGTH(s_crge_org_nm	  ||  '^') || 1, LENGTH(p_crge_org_nm	)); -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					p_cust_eng_nm := SUBSTR(p_cust_eng_nm	, LENGTH(s_cust_eng_nm	  ||  '^') || 1, LENGTH(p_cust_eng_nm	)); -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)

					-- 공백제거(START)
					s_active_flag := rtrim(ltrim(s_active_flag			));
					s_division_id := rtrim(ltrim(s_division_id			));
					s_project_code := rtrim(ltrim(s_project_code			));
					s_scm_site_id := rtrim(ltrim(s_scm_site_id			));
					-- -----------------------------------------------------------------------------------------------
					-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)
					--1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
					--s_item_id := rtrim(ltrim(s_item_id				))
					s_item_id := REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(s_item_id)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '');
					-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (END)
					-- -----------------------------------------------------------------------------------------------
					s_currency := rtrim(ltrim(s_currency				));
					s_cell_per_car := rtrim(ltrim(s_cell_per_car	 		));
					s_cell_per_module := rtrim(ltrim(s_cell_per_module		));
					s_liability_period := rtrim(ltrim(s_liability_period		));
					s_sales_plan_adjust_yn := rtrim(ltrim(s_sales_plan_adjust_yn	));
					s_item_hrcy_id := rtrim(ltrim(s_item_hrcy_id			));
					s_bpms_exist := rtrim(ltrim(s_bpms_exist			    ));
					s_valid_yn := rtrim(ltrim(s_valid_yn		 		));
					s_cust_group := rtrim(ltrim(s_cust_group			    ));
					s_cust_group_dtl := rtrim(ltrim(s_cust_group_dtl		    ));
					s_owner := rtrim(ltrim(s_owner				    ));
					s_application := rtrim(ltrim(s_application			));
					s_route := rtrim(ltrim(s_route				    ));
					s_created_by := rtrim(ltrim(s_created_by			    ));
					s_attribute1 := rtrim(ltrim(s_attribute1			    ));
					s_attribute2 := rtrim(ltrim(s_attribute2			    ));
					s_attribute4 := rtrim(ltrim(s_attribute4			    ));
					s_attribute6 := rtrim(ltrim(s_attribute6			    ));
					s_edi_lt := rtrim(ltrim(s_edi_lt				    ));
					s_report_group1 := rtrim(ltrim(s_report_group1		    ));
					s_report_group2 := rtrim(ltrim(s_report_group2		    ));
					s_report_group3 := rtrim(ltrim(s_report_group3		    ));
					s_report_group4 := rtrim(ltrim(s_report_group4		    ));
					--v_report_group5 := rtrim(ltrim(v_report_group5		    ))
					s_report_group6 := rtrim(ltrim(s_report_group6		    ));
					s_report_group7 := rtrim(ltrim(s_report_group7		    ));
					s_report_group8 := rtrim(ltrim(s_report_group8		    ));
					s_vmi_lt := rtrim(ltrim(s_vmi_lt					));
					s_cell_name := rtrim(ltrim(s_cell_name				)); --PJ20200138 Cell Name 추가
					s_sales_company := rtrim(ltrim(s_sales_company			)); --[C20200513-000276] Sales Company, Sales Plant 추가
					s_sales_plant := rtrim(ltrim(s_sales_plant			));
					s_partial_plan_yn := rtrim(ltrim(s_partial_plan_yn  		)); --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					s_kwh := rtrim(ltrim(s_kwh					)); --[C20210525-000374] 셀용량 및 팩 당 용량 추가
					s_celltypeCD := rtrim(ltrim(s_celltypeCD				)); --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					s_production_process := rtrim(ltrim(s_production_process		)); --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					s_consensus_Mkt := rtrim(ltrim(s_consensus_Mkt				));
					s_consensus_Ess := rtrim(ltrim(s_consensus_Ess				));
					s_consensus_Scm := rtrim(ltrim(s_consensus_Scm				));
					s_inventory_Day := rtrim(ltrim(s_inventory_Day				));
					s_change_Reason := rtrim(ltrim(s_change_Reason				));
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					s_alt_sim_yn := rtrim(ltrim(s_alt_sim_yn					)); --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					s_description := rtrim(ltrim(s_description					)); --20230817 설명(DESCRIPTION) 컬럼 추가
					s_project_info := rtrim(ltrim(s_project_info					)); --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					s_project_s_op_report := rtrim(ltrim(s_project_s_op_report		    )); --[E20240904-001037]_DM > Master > Sales Site Project Model
					s_cell_s_op_report := rtrim(ltrim(s_cell_s_op_report				)); --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
					s_prj_ownr_id := rtrim(ltrim(s_prj_ownr_id					)); --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건

					s_crge_org_nm := rtrim(ltrim(s_crge_org_nm)); --[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					s_cust_eng_nm := rtrim(ltrim(s_cust_eng_nm)); --[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)



					IF (s_division_id = '82')
					BEGIN
						s_modify := NULL;
						--s_count := 0
						--SELECT s_count = COUNT(*)
						--FROM SCM_MST_SITE_ITEM  WHERE 1=1
						--AND DIVISION_ID = s_division_id
						--AND PROJECT_CODE = s_project_code
						--AND SCM_SITE_ID = s_scm_site_id
						--AND ITEM_ID = s_item_id

						--IF s_count = 0
						--BEGIN
						--	s_modify := NULL
						--END
						--ELSE
						BEGIN
							SELECT s_modify = (NVL(CONSENSUS_MKT, '')  ||  NVL(CONSENSUS_ESS, '')   ||  NVL(CONSENSUS_SCM, '')  ||  TO_CHAR(INVENTORY_DAY)  ||  NVL(CHANGE_REASON, ''))
							FROM SCM_MST_SITE_ITEM  WHERE 1=1
							AND DIVISION_ID = s_division_id
							AND PROJECT_CODE = s_project_code
							AND SCM_SITE_ID = s_scm_site_id
							AND ITEM_ID = s_item_id;
						END
					END


					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END

					-- 공백제거(END)

					-- 컬럼값 컨버젼 오류 방지
					IF s_cell_per_car = ''
						  BEGIN
							s_cell_per_car := NULL;
						  END

					IF s_cell_per_module = ''
						  BEGIN
							s_cell_per_module := NULL;
						  END
					--[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag  Default ''추가
					IF (s_partial_plan_yn = '' OR s_partial_plan_yn IS NULL)
						  BEGIN
							s_partial_plan_yn := '';
						  END

					INSERT INTO GT_DMF0_results_MST (;
											 active_flag
											,division_id
											,project_code
											,scm_site_id
											,item_id
											,currency
											,cell_per_car
											,cell_per_module
											,liability_period
											,sales_plan_adjust_yn
											,item_hrcy_id
											,bpms_exist
											,valid_yn
											,cust_group
											,cust_group_dtl
											,owner
											,application
											,route
											,created_by
											,attribute1
											,attribute2
											,attribute4
											,attribute6
											,edi_lt
											,report_group1
											,report_group2
											,report_group3
											,report_group4
											--,report_group5
											,report_group6
											,report_group7
											,report_group8
											,vmi_lt
											,cell_name  --PJ20200138 Cell Name 추가
											,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
											,sales_plant
											,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,kwh				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
											,celltypeCD			-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
											,production_process  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,consensus_Mkt
											,consensus_Ess
											,consensus_Scm
											,inventory_Day
											,change_Reason
											,Change_String
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,description	--20230817 설명(DESCRIPTION) 컬럼 추가
											,project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model
											,cell_s_op_report		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
											,prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
											,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					) VALUES (
											 s_active_flag
											,s_division_id
											,s_project_code
											,s_scm_site_id
											,s_item_id
											,s_currency
											,s_cell_per_car
											,s_cell_per_module
											,s_liability_period
											,s_sales_plan_adjust_yn
											,s_item_hrcy_id
											,s_bpms_exist
											,s_valid_yn
											,s_cust_group
											,s_cust_group_dtl
											,s_owner
											,s_application
											,s_route
											,s_created_by
											,s_attribute1
											,s_attribute2
											,s_attribute4
											,s_attribute6
											,s_edi_lt
											,s_report_group1
											,s_report_group2
											,s_report_group3
											,s_report_group4
											--,v_report_group5
											,s_report_group6
											,s_report_group7
											,s_report_group8
											,s_vmi_lt
											,s_cell_name  --PJ20200138 Cell Name 추가
											,s_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
											,s_sales_plant
											,s_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,s_kwh				--[C20210525-000374] 셀용량 및 팩 당 용량 추가
											,s_celltypeCD		--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
											,s_production_process  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,s_consensus_Mkt
											,s_consensus_Ess
											,s_consensus_Scm
											,s_inventory_Day
											,s_change_Reason
											-- 이전 데이터를 입력한다.
											,(SELECT NVL(CONSENSUS_MKT, '')  ||  NVL(CONSENSUS_ESS, '')   ||  NVL(CONSENSUS_SCM, '')  ||  TO_CHAR(INVENTORY_DAY)  ||  NVL(CHANGE_REASON, '')
												FROM SCM_MST_SITE_ITEM  WHERE 1=1
												AND DIVISION_ID = s_division_id
												AND PROJECT_CODE = s_project_code
												AND SCM_SITE_ID = s_scm_site_id
												AND ITEM_ID = s_item_id)
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,s_alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,s_description		--20230817 설명(DESCRIPTION) 컬럼 추가
											,s_project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,s_project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model
											,s_cell_s_op_report	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
											,s_prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,s_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
											,s_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					)
				END
			ELSE
				BEGIN
					s_DIVISION_ID := p_DIVISION_ID;
					p_DIVISION_ID := NULL;

					-- 공백제거(START)
					s_active_flag := rtrim(ltrim(s_active_flag			));
					s_division_id := rtrim(ltrim(s_division_id			));
					s_project_code := rtrim(ltrim(s_project_code			));
					s_scm_site_id := rtrim(ltrim(s_scm_site_id			));
					-- -----------------------------------------------------------------------------------------------
					-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)
					--1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
					--s_item_id := rtrim(ltrim(s_item_id				))
					s_item_id := REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(s_item_id)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '');
					-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (END)
					-- -----------------------------------------------------------------------------------------------
					s_currency := rtrim(ltrim(s_currency				));
					s_cell_per_car := rtrim(ltrim(s_cell_per_car	 		));
					s_cell_per_module := rtrim(ltrim(s_cell_per_module		));
					s_liability_period := rtrim(ltrim(s_liability_period		));
					s_sales_plan_adjust_yn := rtrim(ltrim(s_sales_plan_adjust_yn	));
					s_item_hrcy_id := rtrim(ltrim(s_item_hrcy_id			));
					s_bpms_exist := rtrim(ltrim(s_bpms_exist			    ));
					s_valid_yn := rtrim(ltrim(s_valid_yn		 		));
					s_cust_group := rtrim(ltrim(s_cust_group			    ));
					s_cust_group_dtl := rtrim(ltrim(s_cust_group_dtl		    ));
					s_owner := rtrim(ltrim(s_owner				    ));
					s_application := rtrim(ltrim(s_application			));
					s_route := rtrim(ltrim(s_route				    ));
					s_created_by := rtrim(ltrim(s_created_by			    ));
					s_attribute1 := rtrim(ltrim(s_attribute1			    ));
					s_attribute2 := rtrim(ltrim(s_attribute2			    ));
					s_attribute4 := rtrim(ltrim(s_attribute4			    ));
					s_attribute6 := rtrim(ltrim(s_attribute6			    ));
					s_edi_lt := rtrim(ltrim(s_edi_lt				    ));
					s_report_group1 := rtrim(ltrim(s_report_group1		    ));
					s_report_group2 := rtrim(ltrim(s_report_group2		    ));
					s_report_group3 := rtrim(ltrim(s_report_group3		    ));
					s_report_group4 := rtrim(ltrim(s_report_group4		    ));
					--v_report_group5 := rtrim(ltrim(v_report_group5		    ))
					s_report_group6 := rtrim(ltrim(s_report_group6		    ));
					s_report_group7 := rtrim(ltrim(s_report_group7		    ));
					s_report_group8 := rtrim(ltrim(s_report_group8		    ));
					s_vmi_lt := rtrim(ltrim(s_vmi_lt					));
					s_cell_name := rtrim(ltrim(s_cell_name				)); --PJ20200138 Cell Name 추가
					s_sales_company := rtrim(ltrim(s_sales_company			)); --[C20200513-000276] Sales Company, Sales Plant 추가
					s_sales_plant := rtrim(ltrim(s_sales_plant			));
					s_partial_plan_yn := rtrim(ltrim(s_partial_plan_yn		)); --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					s_kwh := rtrim(ltrim(s_kwh					)); --[C20210525-000374] 셀용량 및 팩 당 용량 추가
					s_celltypeCD := rtrim(ltrim(s_celltypeCD				)); --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					s_production_process := rtrim(ltrim(s_production_process		)); --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					s_consensus_Mkt := rtrim(ltrim(s_consensus_Mkt				));
					s_consensus_Ess := rtrim(ltrim(s_consensus_Ess				));
					s_consensus_Scm := rtrim(ltrim(s_consensus_Scm				));
					s_inventory_Day := rtrim(ltrim(s_inventory_Day				));
					s_change_Reason := rtrim(ltrim(s_change_Reason				));
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					s_alt_sim_yn := rtrim(ltrim(s_alt_sim_yn					)); --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					s_description := rtrim(ltrim(s_description					)); --20230817 설명(DESCRIPTION) 컬럼 추가
					s_project_info := rtrim(ltrim(s_project_info					)); --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					s_project_s_op_report := rtrim(ltrim(s_project_s_op_report		    )); --[E20240904-001037]_DM > Master > Sales Site Project Model
					s_cell_s_op_report := rtrim(ltrim(s_cell_s_op_report				)); --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
					s_prj_ownr_id := rtrim(ltrim(s_prj_ownr_id					)); --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건

					s_crge_org_nm := rtrim(ltrim(s_crge_org_nm)); -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					s_cust_eng_nm := rtrim(ltrim(s_cust_eng_nm)); -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					-- 공백제거(END)

					-- 컬럼값 컨버젼 오류 방지
					IF s_cell_per_car = ''
						  BEGIN
							s_cell_per_car := NULL;
						  END

					IF s_cell_per_module = ''
						  BEGIN
							s_cell_per_module := NULL;
						  END
					--[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag  Default ''추가
					IF (s_partial_plan_yn = '' OR s_partial_plan_yn IS NULL)
						  BEGIN
							s_partial_plan_yn := '';
						  END

					INSERT INTO GT_DMF0_results_MST (;
											 active_flag
											,division_id
											,project_code
											,scm_site_id
											,item_id
											,currency
											,cell_per_car
											,cell_per_module
											,liability_period
											,sales_plan_adjust_yn
											,item_hrcy_id
											,bpms_exist
											,valid_yn
											,cust_group
											,cust_group_dtl
											,owner
											,application
											,route
											,created_by
											,attribute1
											,attribute2
											,attribute4
											,attribute6
											,edi_lt
											,report_group1
											,report_group2
											,report_group3
											,report_group4
											--,report_group5
											,report_group6
											,report_group7
											,report_group8
											,vmi_lt
											,cell_name  --PJ20200138 Cell Name 추가
											,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
											,sales_plant
											,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,kwh			--[C20210525-000374] 셀용량 및 팩 당 용량 추가
											,celltypeCD		--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
											,production_process  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,consensus_Mkt
											,consensus_Ess
											,consensus_Scm
											,inventory_Day
											,change_Reason
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,description	--20230817 설명(DESCRIPTION) 컬럼 추가
											,project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model
											,cell_s_op_report		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
											,prj_ownr_id	        --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,CRGE_ORG_NM --[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
											,CUST_ENG_NM --[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					) VALUES (
											 s_active_flag
											,s_division_id
											,s_project_code
											,s_scm_site_id
											,s_item_id
											,s_currency
											,s_cell_per_car
											,s_cell_per_module
											,s_liability_period
											,s_sales_plan_adjust_yn
											,s_item_hrcy_id
											,s_bpms_exist
											,s_valid_yn
											,s_cust_group
											,s_cust_group_dtl
											,s_owner
											,s_application
											,s_route
											,s_created_by
											,s_attribute1
											,s_attribute2
											,s_attribute4
											,s_attribute6
											,s_edi_lt
											,s_report_group1
											,s_report_group2
											,s_report_group3
											,s_report_group4
											--,v_report_group5
											,s_report_group6
											,s_report_group7
											,s_report_group8
											,s_vmi_lt
											,s_cell_name  --PJ20200138 Cell Name 추가
											,s_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
											,s_sales_plant
											,s_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,s_kwh				--[C20210525-000374] 셀용량 및 팩 당 용량 추가
											,s_celltypeCD		--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
											,s_production_process  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,s_consensus_Mkt
											,s_consensus_Ess
											,s_consensus_Scm
											,s_inventory_Day
											,s_change_Reason
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,s_alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,s_description		--20230817 설명(DESCRIPTION) 컬럼 추가
											,s_project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,s_project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model
											,s_cell_s_op_report	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
											,s_prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,s_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
											,s_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					)
			---------------------------(1)
				END
			---------------------------(1)

		---------------------------(2)
		END  -- WHILE
		---------------------------(2)







		    v_cell_per_car NUMERIC(20, 10);
		    v_cell_per_module NUMERIC(20, 10);


































		--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선















		SELECT COUNT(1)
		INTO v_cnt_1
		FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR_m1_MST';
		IF v_cnt_1 > 0
			BEGIN
				CLOSE CURSOR_m1_MST
				DEALLOCATE CURSOR_m1_MST
			END;
		-- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- CURSOR_m1_MST CURSOR FAST_FORWARD FOR
		SELECT
			 active_flag
			,division_id
			,project_code
			,scm_site_id
			,item_id
			,currency
			,cell_per_car
			,cell_per_module
			,liability_period
			,sales_plan_adjust_yn
			,item_hrcy_id
			,bpms_exist
			,valid_yn
			,cust_group
			,cust_group_dtl
			,owner
			,application
			,route
			,created_by
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,attribute1
			,attribute2
			,attribute4
			,attribute6
			,edi_lt
			,report_group1
			,report_group2
			,report_group3
			,report_group4
			,report_group6
			,report_group7
			,report_group8
			,CASE WHEN vmi_lt = '' THEN 0 ELSE vmi_lt END
			,cell_name --PJ20200138 Cell Name 추가
			,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
			,sales_plant
			,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
			,kwh				--[C20210525-000374] 셀용량 및 팩 당 용량 추가
			,celltypeCD			-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
			,production_process --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

		--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
			,consensus_Mkt
			,consensus_Ess
			,consensus_Scm
			,inventory_Day
			,change_Reason
		--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
		    ,alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
			,description	--20230817 설명(DESCRIPTION) 컬럼 추가
			,project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
			,project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model
			,cell_s_op_report		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
			,prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
			,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
			,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
		FROM GT_DMF0_results_MST WHERE 1=1;

		BEGIN
			OPEN CURSOR_m1_MST;
			FETCH CURSOR_m1_MST INTO;
										 v_active_flag
										,v_division_id
										,v_project_code
										,v_scm_site_id
										,v_item_id
										,v_currency
										,v_cell_per_car
										,v_cell_per_module
										,v_liability_period
										,v_sales_plan_adjust_yn
										,v_item_hrcy_id
										,v_bpms_exist
										,v_valid_yn
										,v_cust_group
										,v_cust_group_dtl
										,v_owner
										,v_application
										,v_route
										,v_created_by
										,v_LAST_UPDATED_BY
										,v_LAST_UPDATE_DATE
										,v_attribute1
										,v_attribute2
										,v_attribute4
										,v_attribute6
										,v_edi_lt
										,v_report_group1
										,v_report_group2
										,v_report_group3
										,v_report_group4
										,v_report_group6
										,v_report_group7
										,v_report_group8
										,v_vmi_lt
										,v_cell_name --PJ20200138 Cell Name 추가
										,v_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
										,v_sales_plant
										,v_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
										,v_kwh				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
										,v_celltypeCD		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
										,v_production_process --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
										,v_consensus_Mkt
										,v_consensus_Ess
										,v_consensus_Scm
										,v_inventory_Day
										,v_change_Reason
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
										,v_alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
										,v_description		--20230817 설명(DESCRIPTION) 컬럼 추가
										,v_project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
										,v_project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model
										,v_cell_s_op_report	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
										,v_prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
										,v_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
										,v_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)

		END
		---------------------------------------------------------------------------------------- WHILE_m1 LOOP START
		WHILE v_fetch_status = 0
		-- -------------------------------------------------------------------------------------
		BEGIN


				----------◎◎◎◎ 20181121 KHSONG VALID_YN='' 처리시 DM_PLN_SALES_PLAN,DM_PLN_SALES_PLAN_RESULT 테이블의 정보를 확인후 alert창을 띄움 (START)
				----------◎◎◎◎ [C20200812-000104] 당주 월요일 이후의 Sales Plan 이 있을 경우로 제한함.
				IF v_valid_yn = '' and v_division_id = '40'
					BEGIN
						--IF (
						--	SELECT NVL(COUNT(1),0) FROM
						--									(SELECTDIVISION_ID
						--										FROM  DM_PLN_SALES_PLAN
						--											WHERE 1=1
						--											  AND DIVISION_ID		=	v_DIVISION_ID
						--											  AND PROJECT_CODE		=	v_PROJECT_CODE
						--											  AND SCM_SITE_ID		=	v_SCM_SITE_ID
						--											  AND ITEM_ID			=	v_ITEM_ID
						--											  AND QTY <> 0
						--									UNION
						--									SELECT /*__FETCH_1__*/DIVISION_ID
						--										FROM  DM_PLN_SALES_PLAN_RESULT
						--											WHERE 1=1
						--											  AND DIVISION_ID		=	v_DIVISION_ID
						--											  AND PROJECT_CODE		=	v_PROJECT_CODE
						--											  AND SCM_SITE_ID		=	v_SCM_SITE_ID
						--											  AND ITEM_ID			=	v_ITEM_ID
						--											  AND QTY <> 0
						--										) A
						--   ) > 0
							SELECT COUNT(1) DIVISION_ID
							INTO v_cnt_2
							FROM DM_PLN_MKT_FCST
							WHERE YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7*1), 'YYYYMMDD')
							AND DIVISION_ID		=	v_DIVISION_ID
							AND PROJECT_CODE	=	v_PROJECT_CODE
							AND SCM_SITE_ID		=	v_SCM_SITE_ID
							AND ITEM_ID			=	v_ITEM_ID
							AND QTY <> 0
							AND MEASURE IN  ('MKT_FCST', 'RTF_SCP', 'RTF', 'VMI_In_Req', 'VMI_In_Plan','AS_In_Req');
							IF v_cnt_2 > 0 THEN
								v_description2 := '당주 월요일 이후의 MKT FCST 정보가 존재하므로 Active='''' 처리가 불가합니다.' || char(10)  ||  'Sales Site : '  ||  v_SCM_SITE_ID  || char(10)  ||  'Model : '  ||  v_ITEM_ID
FETCH FIRST 1 ROWS ONLY
								select v_description2
								v_log_type := 'INVALID';
								GOTO ERR_RTN
								FROM DUAL;
							END IF;

							SELECT COUNT(1) DIVISION_ID
							INTO v_cnt_3
							FROM DM_PLN_BP_FCST
							WHERE YYYYMM >= TO_CHAR(SYSDATE, 'YYYYMMDD')
							AND DIVISION_ID		=	v_DIVISION_ID
							AND PROJECT_CODE	=	v_PROJECT_CODE
							AND SCM_SITE_ID		=	v_SCM_SITE_ID
							AND ITEM_ID			=	v_ITEM_ID
							AND QTY <> 0;
							IF v_cnt_3 > 0 THEN
								v_description2 := '계획구간의 Business Plan 정보가 존재하므로 Active='''' 처리가 불가합니다.' || char(10)  ||  'Sales Site : '  ||  v_SCM_SITE_ID  || char(10)  ||  'Model : '  ||  v_ITEM_ID
								select v_description2
								v_log_type := 'INVALID';
								GOTO ERR_RTN
								FROM DUAL;
							END IF;
					END;
				----------◎◎◎◎ 20181121 KHSONG VALID_YN='' 처리시 DM_PLN_SALES_PLAN,DM_PLN_SALES_PLAN_RESULT 테이블의 정보를 확인후 alert창을 띄움 (END)

				----------◎◎◎◎ 20181005 KHSONG owner정보가 Key-In 되는경우 정상여부 확인후 비정상이면 Reject 시킴 (START)
				BEGIN
					SELECT COUNT(1)
					INTO v_cnt_4
					FROM  (SELECT token FROM TABLE(fn_string_split(v_owner ,',')))  new_user
					LEFT JOIN TB_FX_User u
					ON   new_user.token = u.UserID
					AND  u.UseYN = 'Y'
					WHERE u.UserID is null;
					IF v_cnt_4 > 0 THEN
							SELECT 'Owner정보가 존재하지 않습니다.'  || char(10)  ||  '● Owner : '  ||  v_owner
							v_log_type := 'INVALID';
							GOTO ERR_RTN
							FROM DUAL;
						END IF;
				END;
				----------◎◎◎◎ 20181005 KHSONG owner정보가 Key-In 되는경우 정상여부 확인후 비정상이면 Reject 시킴 (END)

				----------◎◎◎◎ 20200113 KHSONG 해당 Sales Site의 소속팀의 아닌경우 Reject 시킴 (START)
				--[PJ2024-50461] Team Mapping------------------------------------
				--OWNER 체크 주석처리
				/*    v_invalid_owner VARCHAR2(50 CHAR);
				IF v_DIVISION_ID <> '40'
				BEGIN
					v_invalid_owner := -- 20200514 KHSONG C20200409-000351 신규로직(BEGIN)
						(
						SELECTTOKEN FROM
								(
FETCH FIRST 1 ROWS ONLY
								SELECT new_user.TOKEN
									,CASE WHEN SITE.DEPT_ID IS NOT NULL
											THEN SITE.DEPT_ID
										  ELSE LOOKUP.SEGMENT3
									END AS DEPT_ID
									,FXU.UserID  -- 20200604 KHSONG C20200422-000403 FXU.UserID추가
									--,LOOKUP.SEGMENT1,LOOKUP.SEGMENT3
									FROM  (SELECT token FROM TABLE(fn_string_split(v_owner ,',')))  new_user
									LEFT JOIN SCM_MST_SSO_USER_INFO u
										ON 	u.USER_ID = new_user.token
										AND	u.ACTIVE_FLAG <> 'D' -- 퇴사정보는 제외
									LEFT JOIN SCM_MST_SITE SITE
										ON  SITE.DIVISION_ID	= v_DIVISION_ID
										AND SITE.SCM_SITE_ID	= v_SCM_SITE_ID
										AND SITE.DEPT_ID		= u.DEPT_ID

									LEFT JOIN SCM_MST_SITE SITE2
										ON  SITE2.DIVISION_ID	= v_DIVISION_ID
										AND SITE2.SCM_SITE_ID	= v_SCM_SITE_ID

									LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP
										ON 	LOOKUP.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
										AND LOOKUP.VALID_YN = 'Y'
										AND LOOKUP.SEGMENT1 = u.DEPT_ID       --[C20200506-000277] Owner 의 site 확인 시 Lookup PM_TEAM_MAPPING 의 PM Team도 대상에 포함
										AND LOOKUP.SEGMENT3 = SITE2.DEPT_ID

										--AND LOOKUP.SEGMENT3 = u.DEPT_ID
										--AND LOOKUP.SEGMENT1 = SITE2.DEPT_ID

									-- 20200604 KHSONG C20200422-000403 GSCM USER정보 추가 (BEGIN)
									LEFT JOIN TB_FX_UserGroupAuthExtention FXU
										ON 	FXU.GroupID = 'DM Planner (W/S)'
										AND FXU.UserID = new_user.token
									-- 20200604 KHSONG C20200422-000403 GSCM USER정보 추가 (END)

									WHERE 1=1
								GROUP BY new_user.TOKEN,SITE.DEPT_ID,LOOKUP.SEGMENT3,FXU.UserID  -- 20200604 KHSONG C20200422-000403 FXU.UserID추가
								) Z;
						WHERE DEPT_ID IS NULL -- 소속팀이 아닌경우
						  AND UserID  IS NULL -- 20200604 KHSONG C20200422-000403 FXU.UserID 가 WS Owner인경우는 아이디값이 조회됨. NULL인경우만 Validation 조건대상으로 포함.
						)
						-- 20200514 KHSONG C20200409-000351 신규로직(END)

																									-- 20200514 KHSONG C20200409-000351 주석처리(BEGIN)
																									/*
																									(SELECTTOKEN FROM
																											(SELECT new_user.TOKEN,SITE.DEPT_ID
																												FROM  (SELECT token FROM TABLE(fn_string_split(v_owner ,',')))  new_user
																												LEFT JOIN SCM_MST_SSO_USER_INFO u
																													ON 	u.USER_ID = new_user.token
																													AND	u.ACTIVE_FLAG <> 'D' -- 퇴사정보는 제외
																												LEFT JOIN SCM_MST_SITE SITE
																													ON  SITE.DIVISION_ID	= v_DIVISION_ID
																													AND SITE.SCM_SITE_ID	= v_SCM_SITE_ID
																													AND SITE.DEPT_ID		= u.DEPT_ID
																												WHERE 1=1
																											GROUP BY new_user.TOKEN,SITE.DEPT_ID
																											) Z;
																									WHERE DEPT_ID IS NULL -- 소속팀이 아닌경우
																									)
																									*/
																									-- 20200514 KHSONG C20200409-000351 주석처리(END)
					IF v_invalid_owner IS NOT NULL THEN
FETCH FIRST 1 ROWS ONLY
							SELECT '● Owner : '  ||  v_invalid_owner  ||  ' 은(는) '  ||  '[ '  ||  v_SCM_SITE_ID  ||  ' ]'  ||  ' Sales Site의 소속팀이 아닙니다.'
							v_log_type := 'INVALID';
							GOTO ERR_RTN
							FROM DUAL;
						END IF;
				END;
				*/
				----------◎◎◎◎ 20200113 KHSONG 해당 Sales Site의 소속팀의 아닌경우 Reject 시킴 (END)
				--[PJ2024-50461] Team Mapping------------------------------------
				-------------------------------------------------------------------◎◎◎◎ PRODUCT DETAILS. Validation (Start )

				IF NOT EXISTS (
					SELECT 1
					FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
					WHERE  LOOKUP_TYPE = 'REPORT_GROUP4'
					AND VALID_YN = 'Y'
					AND SEGMENT3 = v_report_group3
					AND SEGMENT1 = v_report_group4
					) AND v_report_group3 <> '' AND v_report_group4 <> '' THEN
					BEGIN
						SELECT v_report_group4 + '는 '  ||  v_report_group3 + '과 같이 사용될 수 없습니다.'  || char(10)  ||  '다른 Product Details.를 사용하시기 바랍니다. '
						v_log_type := 'INVALID';
						GOTO ERR_RTN
						FROM DUAL;
					END;
				END IF;
				-------------------------------------------------------------------◎◎◎◎ PRODUCT DETAILS. Validation ( END )

				BEGIN

					IF v_active_flag = 'I' THEN
							DBMS_OUTPUT.PUT_LINE('I적용');
							IF v_division_id = '40' THEN

								-------------------------------------------------------------------◎◎◎◎ Site Item ID 존재여부 Validation
								IF (SELECT COUNT(1)
									FROM DM_MST_ITEM_SINGLE_V SN
									where 1=1
 										and SN.division_id   = v_division_id
										and SN.ITEM_ID       = v_item_id
										and SN.ACTIVE_FLAG	   = 'Y'
								) = 0 THEN
										SELECT '[' ||  v_item_id  || ']' ||  ' Invalid Item ID !'
										v_description2 := '[' ||  v_item_id  || ']' ||  ' Invalid Item ID !';
										v_log_type := 'INVALID';
										GOTO ERR_RTN
										FROM DUAL;
									END IF;
								-------------------------------------------------------------------◎◎◎◎
								-------------------------------------------------------------------◎◎◎◎ 11자리 모델 코드 중복여부 Validation

								V_DUP_ITEM_ID := NULL;

								-- 20180716 KHSONG 11자리 코드중복건 validation 추가 (START) 20180906 수정함
								V_DUP_ITEM_ID := (SELECTA.ITEM_ID
														FROM   SCM_MST_SITE_ITEM A
														JOIN SCM_MST_SITE B  ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.SITE_TYPE = 'SALES'
															WHERE   A.DIVISION_ID					     = v_division_id
																AND SUBSTR(UPPER(v_ITEM_ID),1,2) = 'MP'
																AND SUBSTR(A.ITEM_ID,1,11)			 = SUBSTR(v_ITEM_ID,1,11)
																AND A.ITEM_ID							 <> v_ITEM_ID

																AND	A.VALID_YN		= 'Y'	-- [C20200916-000412 ]
																--AND VALID_YN     = 'Y'  -- 20180813 KHSONG PK값 기준으로 Validation 될수있도록 주석처리
										           )


								IF  V_DUP_ITEM_ID IS NOT NULL THEN
FETCH FIRST 1 ROWS ONLY
										SELECT '동일 Pack Model이 존재합니다.' || char(10)  ||  '11자리 모델 코드에 대하여 중복저장이 불가합니다.'  || char(10)  ||  '아래 Model을 사용하시기 바랍니다. '  || char(10)  ||  '● Model : '  ||  V_DUP_ITEM_ID
										v_log_type := 'INVALID';
										GOTO ERR_RTN
										FROM DUAL;
									END IF;

								-- 20180716 KHSONG 11자리 코드중복건 validation 추가 (END) 20180906 수정함
								-------------------------------------------------------------------◎◎◎◎
								-------------------------------------------------------------------◎◎◎◎ ITEM_ID 중복여부 Validation
								SELECT COUNT(1)
								INTO v_cnt_5
								FROM   SCM_MST_SITE_ITEM
								WHERE   DIVISION_ID					= v_division_id
								AND PROJECT_CODE				= v_project_code
								AND SCM_SITE_ID					= v_scm_site_id
								AND ITEM_ID						= v_ITEM_ID;
								IF v_cnt_5 > 0 THEN
										SELECT 'MSG00210'
										-- 동일한 EndCustomer, SalesSite, Model에 대하여 중복저장이 불가합니다.
										v_log_type := 'INVALID';
										GOTO ERR_RTN
										FROM DUAL;
									END IF;


								-------------------------------------------------------------------◎◎◎◎
										INSERT SCM_MST_SITE_ITEM
										(
											 DIVISION_ID
											,PROJECT_CODE
											,SCM_SITE_ID
											,ITEM_ID
											,CURRENCY
											,CELL_PER_CAR     --20180417 add skh
											,CELL_PER_MODULE  --20180417 add skh
											,LIABILITY_PERIOD
											,SALES_PLAN_ADJUST_YN
											,ITEM_HRCY_ID
											,VALID_YN
											,BPMS_EXIST
											--20180601 khsong 소형관련 신규 컬럼추가(START)
											,cust_group
											,cust_group_dtl
											,owner
											,application
											,route
											--20180601 khsong 소형관련 신규 컬럼추가(END)
											,CREATED_BY
											,CREATION_DATE
											,LAST_UPDATED_BY
											,LAST_UPDATE_DATE
											,ATTRIBUTE1
											,ATTRIBUTE2
											,ATTRIBUTE4  -- 20180727
											,ATTRIBUTE6  -- 20181031
											,edi_lt	   -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
											-- 20190402 KHSONG 소형 Report 컬럼 추가
											,REPORT_GROUP1
											,REPORT_GROUP2
											,REPORT_GROUP3
											,REPORT_GROUP4
											--,REPORT_GROUP5
											,REPORT_GROUP6
											,REPORT_GROUP7
											,REPORT_GROUP8
											,SCP_VMI_LT
											,ATTRIBUTE9 --PJ20200138 Cell Name 추가
											,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
											,sales_plant
											,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,CONSENSUS_MKT
											,CONSENSUS_ESS
											,CONSENSUS_SCM
											,INVENTORY_DAY
											,CHANGE_REASON
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
											,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model
											,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
											,PRJ_OWNR_ID            --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
											,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
										)
										SELECT
											 v_division_id				AS	DIVISION_ID
											,v_project_code			AS	PROJECT_CODE
											,v_scm_site_id				AS	SCM_SITE_ID
											,v_item_id					AS  ITEM_ID
											,v_currency				AS	CURRENCY
											,v_cell_per_car			AS	CELL_PER_CAR
											,v_cell_per_module			AS	CELL_PER_MODULE
											,v_liability_period		AS	LIABILITY_PERIOD
											,v_sales_plan_adjust_yn	AS	SALES_PLAN_ADJUST_YN
											,v_item_hrcy_id			AS	ITEM_HRCY_ID
											,'Y'						AS	VALID_YN
											,v_bpms_exist				AS	BPMS_EXIST

											--20180601 khsong 소형관련 신규 컬럼추가(START)
											,v_cust_group				AS	cust_group
											,v_cust_group_dtl			AS	cust_group_dtl
											,v_owner--(SELECT MAX(USER_ID) FROM SCM_MST_SSO_USER_INFO  WHERE USER_ID = v_owner OR USER_NAME = v_owner OR USER_NAME_EN = v_owner) AS owner  --20180704 KHSONG owner조회조건수정
											--,v_owner					AS	owner
											,v_application				AS	application
											,v_route					AS	route
											--20180601 khsong 소형관련 신규 컬럼추가(END)

											,v_created_by				AS	CREATED_BY
											,SYSTIMESTAMP				AS	CREATION_DATE
											,v_created_by				AS	LAST_UPDATED_BY
											,SYSTIMESTAMP				AS	LAST_UPDATE_DATE
											,v_attribute1				AS	ATTRIBUTE1
											,v_attribute2				AS	ATTRIBUTE2
											,v_attribute4				AS	ATTRIBUTE4  -- 20180727
											,v_attribute6				AS	ATTRIBUTE6  -- 20181031
											,v_edi_lt					AS	edi_lt      -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
											-- 20190402 KHSONG 소형 Report 컬럼 추가
											,v_report_group1			AS	REPORT_GROUP1
											,v_report_group2			AS	REPORT_GROUP2
											,v_report_group3			AS	REPORT_GROUP3
											,v_report_group4			AS	REPORT_GROUP4
											--,v_report_group5			AS	REPORT_GROUP5
											,v_report_group6			AS	REPORT_GROUP6
											,v_report_group7			AS	REPORT_GROUP7
											,v_report_group8			AS	REPORT_GROUP8
											,v_vmi_lt					AS  SCP_VMI_LT
											,v_production_process		AS  PRODUCTION_PROCESS --PJ20200138 Cell Name 추가 --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											,v_sales_company			AS SALES_COMPANY --[C20200513-000276] Sales Company, Sales Plant 추가
											,v_sales_plant				AS SALES_PLANT
											,v_partial_plan_yn			AS PARTIAL_PLAN_YN --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,v_consensus_Mkt           AS CONSENSUS_MKT
											,v_consensus_Ess           AS CONSENSUS_ESS
											,v_consensus_Scm           AS CONSENSUS_SCM
											,v_inventory_Day           AS INVENTORY_DAY
											,v_change_Reason           AS CHANGE_REASON
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
										    ,v_alt_sim_yn              AS ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,v_description             AS DESCRIPTION		--20230817 설명(DESCRIPTION) 컬럼 추가
											,v_project_info            AS PROJECT_INFO		--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,v_project_s_op_report     AS PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model
											,v_cell_s_op_report		AS CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
											,v_prj_ownr_id				AS PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,v_crge_org_nm             AS CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
											,v_cust_eng_nm             AS CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
							-- 20180619 khsong 소형관련 Validation 조건추가 (END)
							ELSE

									DBMS_OUTPUT.PUT_LINE('82사업부 시작');
									-------------------------------------------------------------------◎◎◎◎ project_code 존재여부 Validation
									IF v_division_id LIKE '81%' OR v_division_id = '82' THEN
											IF (SELECT COUNT(1)
												FROM   SCM_MST_PROJECT_ITEM
														WHERE  DIVISION_ID  = v_division_id
														AND	   PROJECT_CODE = v_project_code
														AND    VALID_YN     = 'Y'
											) = 0 THEN
													SELECT 'MSG00156';
													-- 해당프로젝트에 연결된 모델이 없습니다.  프로젝트 모델 연결 정보를 확인해주세요.
													v_log_type := 'INVALID';
													GOTO ERR_RTN
													FROM DUAL;
												END IF;
												-------------------------------------------------------------------◎◎◎◎ 20180903 KHSONG 81,82 중복값 INSERT INTO VALIDATION 추가 (START)
												SELECT COUNT(1)
												INTO v_cnt_6
												FROM SCM_MST_SITE_ITEM
												WHERE 1=1
												AND DIVISION_ID	    = v_division_id
												AND	PROJECT_CODE	= v_project_code
												AND scm_site_id     = v_scm_site_id
												AND EXISTS
												(
												SELECT
												DIVISION_ID
												FROM SCM_MST_PROJECT_ITEM
												WHERE	DIVISION_ID	= v_division_id
												AND	PROJECT_CODE	= v_project_code
												and VALID_YN		= 'Y'
												GROUP BY;
												DIVISION_ID
												,PROJECT_CODE
												,ITEM_ID
												,ITEM_TYPE
												)
												IF v_cnt_6 > 0 THEN
													SELECT '동일한 Sales Site, Project Code 가 이미 존재합니다..'
													v_log_type := 'INVALID';
													GOTO ERR_RTN
													FROM DUAL;
												END IF;
												-------------------------------------------------------------------◎◎◎◎ 20180903 KHSONG 81,82 중복값 INSERT INTO VALIDATION 추가 (END)

												DELETE FROM GT_DMF0_RESULT_MST;

												-- PJ20228272 NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) START
												-- GT_DMF0_RESULT_MST 에 Input 데이터 생성

												--INSERT SCM_MST_SITE_ITEM
												INSERT INTO GT_DMF0_RESULT_MST
												(
													 DIVISION_ID
													,PROJECT_CODE
													,SCM_SITE_ID
													,ITEM_ID
													,CURRENCY
													,CELL_PER_CAR  --20180417 add skh
													,CELL_PER_MODULE  --20180417 add skh
													,LIABILITY_PERIOD
													,SALES_PLAN_ADJUST_YN
													,ITEM_HRCY_ID
													,VALID_YN
													,BPMS_EXIST
													,owner  --20180721 add sonyoungsuk
													,CREATED_BY
													,CREATION_DATE
													,LAST_UPDATED_BY
													,LAST_UPDATE_DATE
													,ATTRIBUTE1
													,ATTRIBUTE2
													,ATTRIBUTE4  -- 20180727
													,ATTRIBUTE6  -- 20181031
													,edi_lt      -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가
													,REPORT_GROUP1
													,REPORT_GROUP2
													,REPORT_GROUP3
													,REPORT_GROUP4
													--,REPORT_GROUP5
													,REPORT_GROUP6
													,REPORT_GROUP7
													,REPORT_GROUP8
													,VMI_LT
													,CELL_NAME --PJ20200138 Cell Name 추가
													,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
													,sales_plant
													,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,KWH --[C20210525-000374] 셀용량 및 팩 당 용량 추가
													,CellTypeCD	--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
													,CONSENSUS_MKT
													,CONSENSUS_ESS
													,CONSENSUS_SCM
													,INVENTORY_DAY
													,CHANGE_REASON
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
													,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
													,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
													,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
													,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model
													,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
													,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
													,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
													,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
												)
												SELECT
													 v_division_id			AS DIVISION_ID
													,v_project_code		AS PROJECT_CODE
													,v_scm_site_id			AS SCM_SITE_ID
													,A.ITEM_ID			AS ITEM_ID
													,v_currency			AS CURRENCY
													,v_cell_per_car		AS CELL_PER_CAR
													--, CASE WHEN  v_division_id	 LIKE '81%' and v_cell_per_module IS NULL THEN A.CELL_CF
													--	   ELSE v_cell_per_module	END	AS CELL_PER_MODULE -- 20230323 [E20230322-001672] 셀환산자
													,v_cell_per_module		AS CELL_PER_MODULE
													,v_liability_period	AS LIABILITY_PERIOD
													,v_sales_plan_adjust_yn AS SALES_PLAN_ADJUST_YN
													,v_item_hrcy_id		AS ITEM_HRCY_ID
													,'Y'					AS VALID_YN
													,v_bpms_exist			AS BPMS_EXIST
													,v_owner--((SELECT MAX(USER_ID) FROM SCM_MST_SSO_USER_INFO  WHERE USER_ID = v_owner OR USER_NAME = v_owner OR USER_NAME_EN = v_owner) AS owner  --20180721 sonyoungsuk 저장항목추가
													,v_created_by			AS CREATED_BY
													,SYSTIMESTAMP			AS CREATION_DATE
													,v_created_by			AS LAST_UPDATED_BY
													,SYSTIMESTAMP			AS LAST_UPDATE_DATE
													,v_attribute1			AS ATTRIBUTE1
													,v_attribute2			AS ATTRIBUTE2
													,v_attribute4			AS ATTRIBUTE4  -- 20180727
													,v_attribute6			AS ATTRIBUTE6  -- 20181031
													,v_edi_lt				AS [edi_lt    ]  -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가
													,v_report_group1		AS	REPORT_GROUP1
													,v_report_group2		AS	REPORT_GROUP2
													,v_report_group3		AS	REPORT_GROUP3
													,v_report_group4		AS	REPORT_GROUP4
													--,v_report_group5		AS	REPORT_GROUP5
													,v_report_group6		AS	REPORT_GROUP6
													,v_report_group7		AS	REPORT_GROUP7
													,v_report_group8		AS	REPORT_GROUP8
													,v_vmi_lt				AS  SCP_VMI_LT
													,NVL(A.CELL_NAME,v_cell_name) AS  CELL_NAME --PJ20200138 Cell Name 추가
													,v_sales_company			AS SALES_COMPANY --[C20200513-000276] Sales Company, Sales Plant 추가
													,v_sales_plant				AS SALES_PLANT
													,v_partial_plan_yn			AS PARTIAL_PLAN_YN --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,v_kwh						AS KWH				--[C20210525-000374] 셀용량 및 팩 당 용량 추가
													,v_celltypeCD				AS CELL_TYPE_CD		--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
													,v_consensus_Mkt           AS CONSENSUS_MKT
													,v_consensus_Ess           AS CONSENSUS_ESS
													,v_consensus_Scm           AS CONSENSUS_SCM
													,v_inventory_Day           AS INVENTORY_DAY
													,v_change_Reason           AS CHANGE_REASON
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
													,v_alt_sim_yn              AS ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
													,v_description             AS DESCRIPTION		--20230817 설명(DESCRIPTION) 컬럼 추가
													,v_project_info	        AS PROJECT_INFO		--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
													,v_project_s_op_report     AS PROJECT_S_OP_REPORT		--[E20240904-001037]_DM > Master > Sales Site Project Model
													,v_cell_s_op_report		AS CELL_S_OP_REPORT			--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
													,v_prj_ownr_id				AS PRJ_OWNR_ID				--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
													,v_crge_org_nm             AS CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
													,v_cust_eng_nm             AS CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
												FROM
												(
													SELECT
															P.DIVISION_ID
														,P.PROJECT_CODE
														,max(P.PROJECT_VER_SEQ) AS PROJECT_VER_SEQ
														,P.ITEM_ID
														,P.ITEM_TYPE
														,MAX(S.ATTRIBUTE9) AS CELL_NAME --PJ20200138 Cell Name 추가
														--,MAX(F.CELL_CF) AS CELL_CF -- 20230323 [E20230322-001672] 셀환산자
													FROM SCM_MST_PROJECT_ITEM P
													LEFT OUTER JOIN SCM_MST_SITE_ITEM S
													ON ( P.DIVISION_ID		= S.DIVISION_ID
														AND P.ITEM_ID		= S.ITEM_ID )
													--LEFT OUTER JOIN SCP_MST_FINAL_ITEM F  -- 20230323 [E20230322-001672] 셀환산자
													--ON ( P.DIVISION_ID		= F.DIVISION_ID
													--	AND P.ITEM_ID		= F.ITEM_ID )
													WHERE	P.DIVISION_ID		= v_division_id
														AND	P.PROJECT_CODE	= v_project_code
														and P.VALID_YN		= 'Y'
													GROUP BY;
															P.DIVISION_ID
														,P.PROJECT_CODE
														,P.ITEM_ID
														,P.ITEM_TYPE
												) A;


												-- SCM_MST_SITE_ITEM 에 Input
												INSERT SCM_MST_SITE_ITEM
												(
													 DIVISION_ID
													,PROJECT_CODE
													,SCM_SITE_ID
													,ITEM_ID
													,CURRENCY
													,CELL_PER_CAR  --20180417 add skh
													,CELL_PER_MODULE  --20180417 add skh
													,LIABILITY_PERIOD
													,SALES_PLAN_ADJUST_YN
													,ITEM_HRCY_ID
													,VALID_YN
													,BPMS_EXIST
													,owner  --20180721 add sonyoungsuk
													,CREATED_BY
													,CREATION_DATE
													,LAST_UPDATED_BY
													,LAST_UPDATE_DATE
													,ATTRIBUTE1
													,ATTRIBUTE2
													,ATTRIBUTE4  -- 20180727
													,ATTRIBUTE6  -- 20181031
													,edi_lt      -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가
													,REPORT_GROUP1
													,REPORT_GROUP2
													,REPORT_GROUP3
													,REPORT_GROUP4
													--,REPORT_GROUP5
													,REPORT_GROUP6
													,REPORT_GROUP7
													,REPORT_GROUP8
													,SCP_VMI_LT
													,ATTRIBUTE9 --PJ20200138 Cell Name 추가
													,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
													,sales_plant
													,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,ATTRIBUTE8		--[C20210525-000374] 셀용량 및 팩 당 용량 추가
													,ATTRIBUTE10	--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
													,CONSENSUS_MKT
													,CONSENSUS_ESS
													,CONSENSUS_SCM
													,INVENTORY_DAY
													,CHANGE_REASON
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
													,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
													,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
													,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
													,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model
													,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
													,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
													,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
													,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
												)
												SELECT
													 DIVISION_ID
													,PROJECT_CODE
													,SCM_SITE_ID
													,ITEM_ID
													,CURRENCY
													,CELL_PER_CAR  --20180417 add skh
													,CELL_PER_MODULE  --20180417 add skh
													,LIABILITY_PERIOD
													,SALES_PLAN_ADJUST_YN
													,ITEM_HRCY_ID
													,VALID_YN
													,BPMS_EXIST
													,owner  --20180721 add sonyoungsuk
													,CREATED_BY
													,CREATION_DATE
													,LAST_UPDATED_BY
													,LAST_UPDATE_DATE
													,ATTRIBUTE1
													,ATTRIBUTE2
													,ATTRIBUTE4  -- 20180727
													,ATTRIBUTE6  -- 20181031
													,edi_lt      -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가
													,REPORT_GROUP1
													,REPORT_GROUP2
													,REPORT_GROUP3
													,REPORT_GROUP4
													--,REPORT_GROUP5
													,REPORT_GROUP6
													,REPORT_GROUP7
													,REPORT_GROUP8
													,VMI_LT
													,CELL_NAME --PJ20200138 Cell Name 추가
													,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
													,sales_plant
													,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,KWH --[C20210525-000374] 셀용량 및 팩 당 용량 추가
													,CellTypeCD	--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
													,CONSENSUS_MKT
													,CONSENSUS_ESS
													,CONSENSUS_SCM
													,INVENTORY_DAY
													,CHANGE_REASON
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
													,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
													,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
													,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
													,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model
													,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
													,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
													,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
													,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
												FROM GT_DMF0_RESULT_MST;


												IF v_division_id LIKE '81%' THEN

													-- GT_DMF0_XIF_ERP_SITE_ITEM 에 Input
													INSERT INTO GT_DMF0_XIF_ERP_SITE_ITEM
													(		DIVISION_ID
														  , SCM_SITE_ID
														  , PROJECT_CODE
														  , ITEM_ID
														  , CREATED_BY
														  , CREATION_DATE
														  , LAST_UPDATED_BY
														  , LAST_UPDATE_DATE
													)
													SELECT DIVISION_ID
														 , SCM_SITE_ID
														 , PROJECT_CODE
														 , ITEM_ID
														 , CREATED_BY
														 , CREATION_DATE
														 , LAST_UPDATED_BY
														 , LAST_UPDATE_DATE
													FROM GT_DMF0_RESULT_MST
													WHERE  DIVISION_ID LIKE '81%';

												END IF;
												-- PJ20228272 NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) END

									-- ---------
									ELSE
									-- ---------
										-- 재료 데이터 INSERT시 타는 로직
										BEGIN
												INSERT SCM_MST_SITE_ITEM
												(
													 DIVISION_ID
													,PROJECT_CODE
													,SCM_SITE_ID
													,ITEM_ID
													,CURRENCY
													,CELL_PER_CAR  --20180417 add skh
													,CELL_PER_MODULE  --20180417 add skh
													,LIABILITY_PERIOD
													,SALES_PLAN_ADJUST_YN
													,ITEM_HRCY_ID
													,VALID_YN
													,BPMS_EXIST
													,owner  --20180721 add sonyoungsuk
													,CREATED_BY
													,CREATION_DATE
													,LAST_UPDATED_BY
													,LAST_UPDATE_DATE
													,ATTRIBUTE1
													,ATTRIBUTE2
													,ATTRIBUTE4  -- 20180727
													,ATTRIBUTE6  -- 20181031
													,edi_lt	   -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가
													,REPORT_GROUP1
													,REPORT_GROUP2
													,REPORT_GROUP3
													,REPORT_GROUP4
													--,REPORT_GROUP5
													,REPORT_GROUP6
													,REPORT_GROUP7
													,REPORT_GROUP8
													,SCP_VMI_LT
													,ATTRIBUTE9 --PJ20200138 Cell Name 추가
													,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
													,sales_plant
													,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,ATTRIBUTE8		--[C20210525-000374] 셀용량 및 팩 당 용량 추가
													,ATTRIBUTE10		--[C20210525-000374] 셀용량 및 팩 당 용량 추가

												)
												SELECT
													 v_division_id			AS DIVISION_ID
													,v_project_code		AS PROJECT_CODE
													,v_scm_site_id			AS SCM_SITE_ID
													,v_item_id				AS ITEM_ID
													,v_currency			AS CURRENCY
													,v_cell_per_car		AS CELL_PER_CAR
													,v_cell_per_module		AS CELL_PER_MODULE
													,v_liability_period	AS LIABILITY_PERIOD
													,v_sales_plan_adjust_yn AS SALES_PLAN_ADJUST_YN
													,v_item_hrcy_id		AS ITEM_HRCY_ID
													,'Y'					AS VALID_YN
													,v_bpms_exist			AS BPMS_EXIST
													,v_owner--((SELECT MAX(USER_ID) FROM SCM_MST_SSO_USER_INFO  WHERE USER_ID = v_owner OR USER_NAME = v_owner OR USER_NAME_EN = v_owner) AS owner  --20180721 sonyoungsuk 저장항목추가
													,v_created_by			AS CREATED_BY
													,SYSTIMESTAMP			AS CREATION_DATE
													,v_created_by			AS LAST_UPDATED_BY
													,SYSTIMESTAMP			AS LAST_UPDATE_DATE
													,v_attribute1			AS ATTRIBUTE1
													,v_attribute2			AS ATTRIBUTE2
													,v_attribute4			AS ATTRIBUTE4  -- 20180727
													,v_attribute6			AS ATTRIBUTE6  -- 20181031
													,v_edi_lt				AS edi_lt		 -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가
													,v_report_group1		AS	REPORT_GROUP1
													,v_report_group2		AS	REPORT_GROUP2
													,v_report_group3		AS	REPORT_GROUP3
													,v_report_group4		AS	REPORT_GROUP4
													--,v_report_group5		AS	REPORT_GROUP5
													,v_report_group6		AS	REPORT_GROUP6
													,v_report_group7		AS	REPORT_GROUP7
													,v_report_group8		AS	REPORT_GROUP8
													,v_vmi_lt				AS  SCP_VMI_LT

													,v_cell_name			AS  CELL_NAME --PJ20200138 Cell Name 추가
													,v_sales_company		AS SALES_COMPANY --[C20200513-000276] Sales Company, Sales Plant 추가
													,v_sales_plant			AS SALES_PLANT
													,v_partial_plan_yn		AS PARTIAL_PLAN_YN --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,v_kwh					AS KWH				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
													,v_celltypeCD			AS CELL_TYPE_CD		--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가

										END;
									-------------------------------------------------------------------◎◎◎◎

								END IF;


					ELSE
						--PRINT 'M적용'
						--PRINT v_consensus_Mkt
						BEGIN

							MERGE INTO SCM_MST_SITE_ITEM A;
							USING (
									SELECT
										v_division_id	as division_id,
										v_project_code	as project_code,
										v_scm_site_id	as scm_site_id,
										v_item_id		as item_id
								  ) B;
							ON(
										A.division_id  = B.division_id
									AND A.project_code = B.project_code
									AND A.scm_site_id  = B.scm_site_id
									AND A.item_id	   = B.item_id
							  )
							WHEN MATCHED THEN
								 UPDATE SET;
										 division_id			= v_division_id
										,v_project_code AS project_code
										,v_scm_site_id AS scm_site_id
										,v_item_id AS item_id
										,v_currency AS currency
										,v_cell_per_car AS cell_per_car
										,v_cell_per_module AS cell_per_module
										,v_liability_period AS liability_period
										,v_sales_plan_adjust_yn AS sales_plan_adjust_yn
										,v_item_hrcy_id AS item_hrcy_id
										,v_bpms_exist AS bpms_exist
										,v_valid_yn AS valid_yn
										--20180601 khsong 소형관련 신규 컬럼추가
										,v_cust_group AS cust_group
										,v_cust_group_dtl AS cust_group_dtl
										,v_owner--(SELECT MAX(USER_ID) FROM SCM_MST_SSO_USER_INFO  WHERE USER_ID = v_owner OR USER_NAME = v_owner OR USER_NAME_EN = v_owner)  --20180704 KHSONG owner조회조건수정 AS owner
										--,v_owner AS owner
										,v_application AS application
										,v_route AS route
										--20180601 khsong 소형관련 신규 컬럼추가
										,v_created_by AS last_updated_by
										,SYSTIMESTAMP AS last_update_date
										,v_attribute1 AS attribute1
										,v_attribute2 AS attribute2
										,v_attribute4  -- 20180727 AS attribute4
										,v_attribute6  -- 20181031 AS attribute6
										,v_edi_lt		 -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가 AS edi_lt

										-- 20190402 KHSONG 소형 Report 컬럼 추가
										,v_report_group1 AS REPORT_GROUP1
										,v_report_group2 AS REPORT_GROUP2
										,v_report_group3 AS REPORT_GROUP3
										,v_report_group4 AS REPORT_GROUP4
										--,v_report_group5 AS REPORT_GROUP5
										,v_report_group6 AS REPORT_GROUP6
										,v_report_group7 AS REPORT_GROUP7
										,v_report_group8 AS REPORT_GROUP8
										,v_vmi_lt AS SCP_VMI_LT
										,CASE WHEN A.division_id = '40' AS ATTRIBUTE9
																	THEN v_production_process --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
																  ELSE v_cell_name END --PJ20200138 Cell Name 추가
										,v_sales_company --[C20200513-000276] Sales Company AS SALES_COMPANY, Sales Plant 추가
										,v_sales_plant AS SALES_PLANT
										,v_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가 AS PARTIAL_PLAN_YN
										,v_kwh			-- [C20210525-000374] 셀용량 및 팩 당 용량 추가 AS ATTRIBUTE8
										,v_celltypeCD		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가 AS ATTRIBUTE10
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
										,v_consensus_Mkt AS CONSENSUS_MKT
										,v_consensus_Ess AS CONSENSUS_ESS
										,v_consensus_Scm AS CONSENSUS_SCM
										,v_inventory_Day AS INVENTORY_DAY
										,v_change_Reason AS CHANGE_REASON
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
										,v_alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가 AS ALT_SIM_YN
										,v_description	--20230817 설명(DESCRIPTION) 컬럼 추가 AS DESCRIPTION
										,v_project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가 AS PROJECT_INFO
										,v_project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model AS PROJECT_S_OP_REPORT
										,v_cell_s_op_report		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건 AS CELL_S_OP_REPORT
										,v_prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 AS PRJ_OWNR_ID
										,v_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM AS CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
										,v_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM AS CUST_ENG_NM,CUST_ENG_NM 2개 컬럼 추가)
							WHEN NOT MATCHED THEN

								 INSERT (;
											division_id
										   ,project_code
										   ,scm_site_id
										   ,item_id
										   ,currency
										   ,cell_per_car
										   ,cell_per_module
										   ,liability_period
										   ,sales_plan_adjust_yn
										   ,item_hrcy_id
										   ,bpms_exist
										   ,valid_yn
										   --20180601 khsong 소형관련 신규 컬럼추가
										   ,cust_group
										   ,cust_group_dtl
										   ,owner
										   ,application
										   ,route
										   --20180601 khsong 소형관련 신규 컬럼추가
										   ,created_by
										   ,creation_date
										   ,last_updated_by
										   ,last_update_date
										   ,attribute1
										   ,attribute2
										   ,attribute4  -- 20180727
										   ,attribute6  -- 20181031
										   ,edi_lt		-- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가

											-- 20190402 KHSONG 소형 Report 컬럼 추가
										   ,REPORT_GROUP1
										   ,REPORT_GROUP2
										   ,REPORT_GROUP3
										   ,REPORT_GROUP4
										   --,REPORT_GROUP5
										   ,REPORT_GROUP6
										   ,REPORT_GROUP7
										   ,REPORT_GROUP8
										   ,SCP_VMI_LT
										   ,ATTRIBUTE9 --PJ20200138 Cell Name 추가
											,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
											,sales_plant
											,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,ATTRIBUTE8		-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
											,ATTRIBUTE10	-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,CONSENSUS_MKT
											,CONSENSUS_ESS
											,CONSENSUS_SCM
											,INVENTORY_DAY
											,CHANGE_REASON
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
											,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model
											,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
											,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
											,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
										)
								 VALUES (
											v_division_id
										   ,v_project_code
										   ,v_scm_site_id
										   ,v_item_id
										   ,v_currency
										   ,v_cell_per_car
										   ,v_cell_per_module
										   ,v_liability_period
										   ,v_sales_plan_adjust_yn
										   ,v_item_hrcy_id
										   ,v_bpms_exist
										   ,v_valid_yn
										   --20180601 khsong 소형관련 신규 컬럼추가
										   ,v_cust_group
										   ,v_cust_group_dtl
										   ,v_owner--(SELECT MAX(USER_ID) FROM SCM_MST_SSO_USER_INFO  WHERE USER_ID = v_owner OR USER_NAME = v_owner OR USER_NAME_EN = v_owner)  --20180704 KHSONG owner조회조건수정
										    --,v_owner
										   ,v_application
										   ,v_route
										   --20180601 khsong 소형관련 신규 컬럼추가
										   ,v_created_by
										   ,SYSTIMESTAMP
										   ,v_created_by
										   ,SYSTIMESTAMP
										   ,v_attribute1
										   ,v_attribute2
										   ,v_attribute4  -- 20180727
										   ,v_attribute6  -- 20181031
										   ,v_edi_lt	   -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가

											-- 20190402 KHSONG 소형 Report 컬럼 추가
											,v_report_group1
											,v_report_group2
											,v_report_group3
											,v_report_group4
											--,v_report_group5
											,v_report_group6
											,v_report_group7
											,v_report_group8
											,v_vmi_lt
											,CASE WHEN v_division_id = '40'
												THEN v_production_process --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											 ELSE v_cell_name END --PJ20200138 Cell Name 추가
											,v_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
											,v_sales_plant
											,v_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,v_kwh				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
											,v_celltypeCD		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
										    ,v_consensus_Mkt
										    ,v_consensus_Ess
										    ,v_consensus_Scm
										    ,v_inventory_Day
										    ,v_change_Reason
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
										    ,v_alt_sim_yn	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,v_description	--20230817 설명(DESCRIPTION) 컬럼 추가
											,v_project_info --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,v_project_s_op_report --[E20240904-001037]_DM > Master > Sales Site Project Model
											,v_cell_s_op_report	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
											,v_prj_ownr_id		--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,v_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
											,v_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
										);

						END;

						-- 2020.3.17 division_id, scm_site_ite, item_id 기준으로 동일한 모델에는 동일한 SCP_VMI_LT 를 적용한다. ( Project Code 는 무시 )-----------------------------
						UPDATE SCM_MST_SITE_ITEM
						SET SCP_VMI_LT = NVL(V_VMI_LT,0)
						WHERE DIVISION_ID = v_division_id
							AND SCM_SITE_ID = v_scm_site_id
							AND ITEM_ID = v_item_id;
						-- 2020.3.17 SCP_VMI_LT update 끝	----------------------------------------------------------------------------------------------------------------------



				END IF;


			FETCH CURSOR_m1_MST INTO;
										 v_active_flag
										,v_division_id
										,v_project_code
										,v_scm_site_id
										,v_item_id
										,v_currency
										,v_cell_per_car
										,v_cell_per_module
										,v_liability_period
										,v_sales_plan_adjust_yn
										,v_item_hrcy_id
										,v_bpms_exist
										,v_valid_yn
										,v_cust_group
										,v_cust_group_dtl
										,v_owner
										,v_application
										,v_route
										,v_created_by
										,v_LAST_UPDATED_BY
										,v_LAST_UPDATE_DATE
										,v_attribute1
										,v_attribute2
										,v_attribute4
										,v_attribute6
										,v_edi_lt
										,v_report_group1
										,v_report_group2
										,v_report_group3
										,v_report_group4
										,v_report_group6
										,v_report_group7
										,v_report_group8
										,v_vmi_lt
										,v_cell_name --PJ20200138 Cell Name 추가
										,v_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
										,v_sales_plant
										,v_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
										,v_kwh				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
										,v_celltypeCD		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
										,v_production_process --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
										,v_consensus_Mkt
										,v_consensus_Ess
										,v_consensus_Scm
										,v_inventory_Day
										,v_change_Reason
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
										,v_alt_sim_yn	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
										,v_description	--20230817 설명(DESCRIPTION) 컬럼 추가
										,v_project_info --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
										,v_project_s_op_report --[E20240904-001037]_DM > Master > Sales Site Project Model
										,v_cell_s_op_report	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
										,v_prj_ownr_id		--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
										,v_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
										,v_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)

		-- -------------------------------------------------------------------------------------
		END IF;
		---------------------------------------------------------------------------------------- WHILE_m1 LOOP END

		CLOSE CURSOR_m1_MST;
		DEALLOCATE CURSOR_m1_MST;

		-- --------------------------------------------------------------------------------------------------
		END;
		-- --------------------------------------------------------------------------------------------------
		-- -----------------------------------------------------------------------------------------------------------
		-- history insert (begin)
		-- -----------------------------------------------------------------------------------------------------------
		INSERT	INTO  SCM_MST_SITE_ITEM_H
				(
					DIVISION_ID ,HISTORY_SEQ, PROJECT_CODE ,SCM_SITE_ID
					,ITEM_ID ,CURRENCY ,CELL_PER_CAR, CELL_PER_MODULE, LIABILITY_PERIOD ,SALES_PLAN_ADJUST_YN ,ITEM_HRCY_ID ,VALID_YN ,BPMS_EXIST
					,cust_group,cust_group_dtl,owner,application,route  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
					,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4, ATTRIBUTE6 -- 20180727 KHSONG attribute4 추가
					,edi_lt  -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
					,report_group1,report_group2,report_group3,report_group4
					-- ,report_group5								-- 20191021 kyh report_group4, 5 통합
					,report_group6,report_group7,report_group8  -- 20190408 KHSONG 신규컬럼추가
					--,os_corp,contribution_type
					,SCP_VMI_LT
					,ATTRIBUTE9 --PJ20200138 Cell Name 추가
					,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
					,sales_plant
					,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					,ATTRIBUTE8		-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
					,ATTRIBUTE10	-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					,CONSENSUS_MKT
					,CONSENSUS_ESS
					,CONSENSUS_SCM
					,INVENTORY_DAY
					,CHANGE_REASON
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
					,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					,ATTRIBUTE3
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model
					,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
					,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
					,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
				)
				select
					 DIVISION_ID
					,NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_H  -- History Seqno
					,PROJECT_CODE ,SCM_SITE_ID
					,ITEM_ID ,CURRENCY ,CELL_PER_CAR, CELL_PER_MODULE, LIABILITY_PERIOD ,SALES_PLAN_ADJUST_YN ,ITEM_HRCY_ID ,VALID_YN ,BPMS_EXIST
					,cust_group,cust_group_dtl,owner,application,route  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
					,CREATED_BY,SYSTIMESTAMP,CREATED_BY,SYSTIMESTAMP,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4, ATTRIBUTE6
					,edi_lt,report_group1,report_group2,report_group3,report_group4
					,report_group6,report_group7,report_group8
					,vmi_lt
					,CASE WHEN division_id = '40'
						THEN production_process  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
					 ELSE cell_name END --PJ20200138 Cell Name 추가
					,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가
					,sales_plant
					,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					,kwh
					,celltypeCD		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					,consensus_Mkt
					,consensus_Ess
					,consensus_Scm
					,inventory_Day
					,change_Reason
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
					,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					,CASE WHEN NVL(Change_String, '') != NVL(CONSENSUS_MKT, '')  ||  NVL(CONSENSUS_ESS, '')   ||  NVL(CONSENSUS_SCM, '')  ||  TO_CHAR(INVENTORY_DAY)  ||  NVL(CHANGE_REASON, '') THEN 'Y' END
					--,CASE WHEN s_modify != (consensus_Mkt +  consensus_Ess + consensus_Scm + TO_CHAR(inventory_Day) + change_Reason)  THEN 'Y' END
					,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model
					,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
					,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
					,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
					,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)
				FROM GT_DMF0_results_MST  WHERE 1=1;

--SELECT CASE WHEN NVL(Change_String, '') != NVL(CONSENSUS_MKT, '') + NVL(CONSENSUS_ESS, '')  + NVL(CONSENSUS_SCM, '') + TO_CHAR(INVENTORY_DAY) + NVL(CHANGE_REASON, '') THEN 'Y' END
--FROM GT_DMF0_results_MST  WHERE 1=1
		-- -----------------------------------------------------------------------------------------------------------
		-- history insert (end)
		-- -----------------------------------------------------------------------------------------------------------
		IF (SELECT COUNT(1) FROM GT_DMF0_results_MST WHERE DIVISION_ID LIKE '81%')
			> 0 THEN
			-- -----------------------------------------------------------------------------------------------------------
				INSERT INTO GT_DMF0_EDI_LT
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,EDI_LT)
				SELECT 	 division_id
						,project_code
						,scm_site_id
						,item_id
						,edi_lt
					 FROM GT_DMF0_results_MST  WHERE DIVISION_ID LIKE '81%';

				-- PJ20228272 NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S)
				PR_DM_XIF_ERP_SITE_ITEM_S;

			-- -----------------------------------------------------------------------------------------------------------
			END IF;
			-- -----------------------------------------------------------------------------------------------------------
		-- --------------------------------------------------------------------------------------------------------------------
		BEGIN        --20191118 KHSONG [CSR:C20191031-000137] TEMP 테이블에서 EDI_LT 값이 변경된 데이터 찾아서 업데이트(BEGIN)
		-- --------------------------------------------------------------------------------------------------------------------
			------------------ 변경대상이 존재할경우 기준정보 저장
			/* TODO:GTT:GT_DMF0_EDI_TRGT-->GT_DMF0_EDI_TRGT */
			INSERT INTO GT_DMF0_EDI_TRGT
			SELECT DISTINCT A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,B.EDI_LT
				FROM  DM_PLN_MKT_FCST A
					INNER JOIN GT_DMF0_EDI_LT B
					ON (A.division_id	=	B.division_id
					AND A.project_code	=	B.project_code
					AND A.scm_site_id	=	B.scm_site_id
					AND A.item_id		=	B.item_id
					AND A.ATTRIBUTE8	<>	B.edi_lt
						)
				WHERE 1=1
				AND A.DIVISION_ID LIKE '81%'
				--AND A.MEASURE in ('CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement')
				AND A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
				AND A.YYYYMMDD >= v_0week_monday; -- 당주 월요일 이후 데이터

			-- ---------------
			IF
			-- ---------------
				(SELECT COUNT(1) FROM GT_DMF0_EDI_TRGT  ) > 0  -- EDI_LT 값이 기존과 달라진 기준정보가 존재하는경우
				-- ---------------
				BEGIN
				-- ---------------
					/* TODO:GTT:GT_DMF0_EDI_FCST_TABLE-->GT_DMF0_EDI_FCST_TABLE */
					INSERT INTO GT_DMF0_EDI_FCST_TABLE
					SELECT
						  A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.MEASURE,A.PLANT_SITE_ID
						-- Original YYYYMMDD 값에서 재계산
						 ,A.YYYYMMDD AS YYYYMMDD_ASIS
						 ,TO_CHAR(FN_NEXT_WORK_DAY(NVL(MAX(ATTRIBUTE7),MAX(A.YYYYMMDD)), MAX(B.EDI_LT) * -1), 'YYYYMMDD') AS YYYYMMDD_TOBE -- 날짜값과 EDI_LT 값을 음수로 입력함
						 ,MAX(A.QTY) AS QTY
						 ,MAX(A.CREATED_BY) AS CREATED_BY
						 ,MAX(A.CREATION_DATE) AS CREATION_DATE
						 ,v_created_by AS LAST_UPDATED_BY -- UPDATE 수행자 기록
						 ,SYSDATE AS LAST_UPDATE_DATE
						 ,MAX(A.ATTRIBUTE1) AS ATTRIBUTE1
						 ,MAX(A.ATTRIBUTE2)	AS ATTRIBUTE2
						 ,MAX(A.ATTRIBUTE3)	AS ATTRIBUTE3
						 ,MAX(A.ATTRIBUTE4)	AS ATTRIBUTE4
						 ,MAX(A.ATTRIBUTE5)	AS ATTRIBUTE5
						 ,MAX(A.ATTRIBUTE6)	AS ATTRIBUTE6
						 ,MAX(A.ATTRIBUTE7)	AS ATTRIBUTE7
						 ,MAX(B.EDI_LT) AS ATTRIBUTE8 -- EDI_LT 값을 변경된 값으로 업데이트함
						 --,'Edi Leadtime User Update' AS ATTRIBUTE9
						 ,MAX(A.ATTRIBUTE9) AS ATTRIBUTE9
						 ,MAX(A.ATTRIBUTE10) AS ATTRIBUTE10
					FROM DM_PLN_MKT_FCST A
						INNER JOIN GT_DMF0_EDI_TRGT B
							ON (A.DIVISION_ID			=   B.DIVISION_ID
							AND A.PROJECT_CODE			=   B.PROJECT_CODE
							AND A.SCM_SITE_ID			=   B.SCM_SITE_ID
							AND A.ITEM_ID				=   B.ITEM_ID
							)
					  where 1=1
						--AND A.MEASURE in ('CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement')
						AND A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
						AND A.YYYYMMDD >= v_0week_monday  -- 당주 월요일 이후 데이터
					GROUP BY  A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,B.EDI_LT;

					-- 111 확인용
					--SELECT * FROM GT_DMF0_EDI_FCST_TABLE

					-- PK 오류발생하므로 기존데이터 삭제
					--(1) AS-IS 날짜를 삭제
					DELETE FROM DM_PLN_MKT_FCST
					  where 1=1
					  and exists (select division_id from GT_DMF0_EDI_FCST_TABLE C  WHERE 1=1
									AND DM_PLN_MKT_FCST.DIVISION_ID			=   C.DIVISION_ID
									AND DM_PLN_MKT_FCST.PROJECT_CODE		=   C.PROJECT_CODE
									AND DM_PLN_MKT_FCST.SCM_SITE_ID			=   C.SCM_SITE_ID
									AND DM_PLN_MKT_FCST.ITEM_ID				=   C.ITEM_ID
									AND DM_PLN_MKT_FCST.DOM_EXP				=   C.DOM_EXP
									AND DM_PLN_MKT_FCST.FCST_TYPE			=   C.FCST_TYPE
									AND DM_PLN_MKT_FCST.INCOTERMS			=   C.INCOTERMS
									AND DM_PLN_MKT_FCST.PLANT_SITE_ID		=   C.PLANT_SITE_ID
									AND DM_PLN_MKT_FCST.YYYYMMDD			=   C.YYYYMMDD_ASIS  -- AS-IS 날짜
									)
						--AND MEASURE in ('CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement')
						AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder');

					--(2) TO-BE 날짜를 삭제
					DELETE FROM DM_PLN_MKT_FCST
					  where 1=1
					  and exists (select division_id from GT_DMF0_EDI_FCST_TABLE C  WHERE 1=1
									AND DM_PLN_MKT_FCST.DIVISION_ID			=   C.DIVISION_ID
									AND DM_PLN_MKT_FCST.PROJECT_CODE		=   C.PROJECT_CODE
									AND DM_PLN_MKT_FCST.SCM_SITE_ID			=   C.SCM_SITE_ID
									AND DM_PLN_MKT_FCST.ITEM_ID				=   C.ITEM_ID
									AND DM_PLN_MKT_FCST.DOM_EXP				=   C.DOM_EXP
									AND DM_PLN_MKT_FCST.FCST_TYPE			=   C.FCST_TYPE
									AND DM_PLN_MKT_FCST.INCOTERMS			=   C.INCOTERMS
									AND DM_PLN_MKT_FCST.PLANT_SITE_ID		=   C.PLANT_SITE_ID
									AND DM_PLN_MKT_FCST.YYYYMMDD			=   C.YYYYMMDD_TOBE  -- TO-BE 날짜
									)
						--AND MEASURE in ('CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement')
						AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder');

					-- MKT_FCST DATA INSERT INTO INSERT INTO DM_PLN_MKT_FCST
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
					SELECT  DIVISION_ID
							,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
							,YYYYMMDD_TOBE  -- TO-BE 날짜
							,SUM(QTY) as qty
							,max(CREATED_BY) as CREATED_BY,max(CREATION_DATE) as CREATION_DATE,max(LAST_UPDATED_BY) as LAST_UPDATED_BY,max(LAST_UPDATE_DATE) as LAST_UPDATE_DATE
							,MAX(ATTRIBUTE1),MAX(ATTRIBUTE2),MAX(ATTRIBUTE3),MAX(ATTRIBUTE4),MAX(ATTRIBUTE5),MAX(ATTRIBUTE6),MAX(ATTRIBUTE7),MAX(ATTRIBUTE8),MAX(ATTRIBUTE9),MAX(ATTRIBUTE10)
						FROM GT_DMF0_EDI_FCST_TABLE  WHERE 1=1
						GROUP BY DIVISION_ID  -- GROUP이 필요함, 토,일요일 데이터가 평일로 편성되는경우 PK중복오류 발생함
							,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
							,YYYYMMDD_TOBE

					-- History INSERT INTO INSERT INTO DM_PLN_MKT_FCST_H
					(DIVISION_ID,HISTORY_SEQ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
					SELECT  DIVISION_ID
							,NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_H -- History Seqno
							,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
							,YYYYMMDD_TOBE  -- TO-BE 날짜
							,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						FROM GT_DMF0_EDI_FCST_TABLE  WHERE 1=1;

				-- ---------------
				END;
				-- ---------------
		-- --------------------------------------------------------------------------------------------------------------------
		END;
		-- --------------------------------------------------------------------------------------------------------------------
		-- END TRY

	EXCEPTION
	    WHEN OTHERS THEN


		-- ERROR LOG
		v_log_type := 'ERROR';
		v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
		v_description2 := 'ERROR_LINE : '  ||  STR(NULL);
		d_event_date := SYSTIMESTAMP;

		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description2, d_event_date);
		SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM
		FROM DUAL;

    -- END CATCH


	IF  v_log_type not in ('INVALID','ERROR') THEN
			-- 종료 LOG
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description2, d_event_date);
		END IF;

	-- INVALID 인경우 ROLLBACK 처리
	ERR_RTN:
		IF  v_log_type = 'INVALID' THEN
				SELECT 'INVALID'
								-- 종료 LOG
				v_log_message := '########## END of procedure ##########';
				d_event_date := SYSTIMESTAMP;
				PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description2, d_event_date);
				-- [C20210323-000363]
				PR_SCM_SYS_LOG_BATCH(v_program_name, 'END', n_log_count, v_log_message, v_description2, d_event_date);
				FROM DUAL;
			END IF;

        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
  END;
/
