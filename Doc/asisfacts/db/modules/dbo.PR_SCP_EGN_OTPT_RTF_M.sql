/* ============================================================================
 * PR_SCP_EGN_OTPT_RTF_M  ITEM_ID NULL 오류 수정안  (2026-08-24)
 * ----------------------------------------------------------------------------
 * [증상]
 *   EXEC PR_SCP_EGN_OTPT_RTF_M '20260819_81_FN'
 *   -> Cannot insert the value NULL into column 'ITEM_ID' ... ERROR_LINE : 81
 *      (81행 = 첫 번째 INSERT(RTF). MKT_FCST 쪽은 정상)
 *
 * [원인 — 실측]
 *   Demand Group 페깅 680건 중 527건에서 아래 조인이 실패하여 DP.ITEM_ID = NULL.
 *       LEFT JOIN ..._OUT_ORDER_SHIPPING_SN OS
 *              ON OS.SHIPPING_ORDER_ID = BP.PROD_ORDER_ID
 *             AND OS.TO_BUFFER_ID      = BP.BUFFER_ID     <-- 여기서 탈락
 *
 *   TO_BUFFER_ID 와 BUFFER_ID 는 "같은 버퍼"인데 한글 부분의 인코딩이 다르다.
 *   nvarchar(UTF-16LE) 바이트 비교:
 *       BP.BUFFER_ID    ... 5F00 | EF00 BF00 BD00 (x3) | 3A00  len=58
 *                            -> U+00EF U+00BF U+00BD  (U+FFFD의 UTF-8 바이트가
 *                               Latin-1로 재해석된 '이중 모지바케')
 *       OS.TO_BUFFER_ID ... 5F00 | FDFF (x3)           | 3A00  len=52
 *                            -> U+FFFD (치환문자)
 *
 *   * 미매칭 527건 == BUFFER_ID에 non-ASCII가 있는 행 527건 (정확히 일치)
 *   * 모지바케를 정규화하면 680/680 매칭 (raw 153 -> norm 680)
 *   * 깨지는 문자는 Demand Group '그룹명'이며, 복원 대상인 실품목은 ASCII라 안전
 *
 * [수정 2곳]
 *   (1) OS 조인을 OUTER APPLY TOP 1 로 변경
 *       - TO_BUFFER_ID 정확일치를 '우선순위'로 강등(ORDER BY). 인코딩이 성하면
 *         종전과 동일한 행을 고르고, 깨지면 같은 출하지시의 행으로 폴백한다.
 *       - TOP 1 이므로 출하지시 하나가 여러 TO_BUFFER를 갖더라도 fan-out 불가.
 *         (전극 EE 계획에 그런 데이터가 존재. 단 EE는 Demand Group 미사용이라
 *          현재 데이터의 위험 노출은 0건 — 향후 대비용 구조적 방어)
 *   (2) ITEM_ID 의 Demand Group 분기에 ISNULL(...,'-') 안전망 추가
 *       - 종전에는 'Y' 분기에만 방어가 없어 배치 전체가 죽었다.
 *       - '-' 로 들어간 건수는 반드시 04_VALIDATE 로 감시할 것 (0건이어야 정상).
 *
 * [검증 — PLAN_ID = '20260819_81_FN']
 *   ITEM_ID NULL   527건 -> 0건
 *   행수           1792(N) + 680(Y) = 2472 = 페깅 행수 (부풀림 없음)
 *   총량 폐합      14,811,008.46 + 32,826,714.50 = 47,637,722.96
 *                  = 페깅 FLOW_QTY 합계 = 출하지시 DELIVERY_QTY 합계 (완전일치)
 *   복원 품목      5종, 전부 SCM_MST_ITEM 존재 (OPERATION_GROUP='A')
 *
 * [기각한 대안]
 *   MKT_FCST 처럼 SCP_MST_ITEM_GROUP + DEMAND_ID 패턴으로 품목을 복원하는 방식
 *   -> 요청품목과 실제공급품목이 680건 중 140건(20.6%) 다름.
 *      RTF는 '실제 공급된 품목'이어야 하므로 부적합.
 *
 * [근본원인 — 별도 과제]
 *   엔진 출력 적재 단계에서 BUFFER_ID 한글이 이미 손상되어 있고, 테이블마다
 *   손상 형태가 다르다. 이 수정은 증상 회피이며 인코딩 자체는 고치지 못한다.
 * ==========================================================================*/

CREATE PROCEDURE [dbo].[PR_SCP_EGN_OTPT_RTF_M]
	@P_PLAN_ID	NVARCHAR(100)	= NULL
AS

BEGIN

-- procedure body -- start
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON;

	DECLARE @V_PLAN_ID				NVARCHAR(100)	= @P_PLAN_ID;
	DECLARE @V_DIVISION_ID			NVARCHAR(50)	= '';
	DECLARE @V_PLAN_START_YYYYMMDD	NVARCHAR(8)		= '';
	DECLARE @V_PLAN_END_YYYYMMDD	NVARCHAR(8)		= '';
	DECLARE @V_PLAN_GROUP			NVARCHAR(100)	= ''

	-- 실행시간 확인용
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_EGN_OTPT_RTF_M';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch';

	BEGIN TRY
	  BEGIN

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';
		SET @v_description = CONCAT('[plan_id=', ISNULL(@V_PLAN_ID,''),  ']')
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL

	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작

			-----------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Plan Master 정보 '
			-----------------------------------------------------------------------------------
		    SELECT @V_DIVISION_ID			= PM.ATTRIBUTE1
				  ,@V_PLAN_START_YYYYMMDD	= PM.PLAN_START_DATE
				  ,@V_PLAN_END_YYYYMMDD	= PM.PLAN_END_DATE
				  ,@V_PLAN_GROUP			= PM.ATTRIBUTE2
			 FROM SCP_OPT_ENG_PLAN_MASTER_SN  PM WITH(NOLOCK)
			WHERE PM.PLAN_ID = @V_PLAN_ID

			-----------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' DELETE RTF/MKT_FCST'
			-----------------------------------------------------------------------
			DELETE TG
			  FROM SCP_EGN_OTPT_RTF_M TG
			 WHERE TG.PLAN_ID = @V_PLAN_ID

			-----------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' INSERT RTF'
			-----------------------------------------------------------------------
			;WITH DBP_DELIVERY AS (
				/* Demand Buffer Pegging Deivery Order 정보
				  -- Demand Group 적용된 DO이면 From Buffer 기준의 품목 정보를 참조
				*/
				SELECT BP.CONSUME_ORDER_ID
					 , BP.BUFFER_ID
					 , BP.FLOW_QTY
					 , CONVERT(INTEGER, BP.ATTRIBUTE14)	AS PEGGING_SEQ
					 , SI.ITEM_ID						-- From Buffer 기준의 품목 정보
					 , CASE WHEN ED.ATTRIBUTE12	= 'DEMAND_GROUP'
							THEN 'Y'
							ELSE 'N'
						END				AS DEMAND_GROUP_YN
					 , ED.ATTRIBUTE1	AS DEMAND_SITE_ID
					 , ED.ATTRIBUTE2	AS DEMAND_ITEM_ID
					 , ED.ATTRIBUTE3	AS STAGE
					 , ED.ATTRIBUTE4	AS DEMAND_INCOTERMS
					 , ED.ATTRIBUTE5	AS PROJECT_CODE
					 , ED.ATTRIBUTE8	AS FCST_TYPE
					 , ED.DEMAND_ID 	AS DEMAND_ID
				 FROM SCP_OPT_ENG_OUT_DEMAND_BUFFER_PEGGING_SN BP WITH(NOLOCK)
					  LEFT JOIN SCP_OPT_ENG_DEMAND_SN ED WITH(NOLOCK)
							  ON ED.PLAN_ID		= BP.PLAN_ID
							 AND ED.DEMAND_ID	= BP.DEMAND_NAME
					  /* ---------------------------------------------------------------
					   * [수정 1] 2026-08-24
					   *   종전 : LEFT JOIN OS ON ... AND OS.TO_BUFFER_ID = BP.BUFFER_ID
					   *   문제 : BUFFER_ID 한글의 인코딩 손상 형태가 두 테이블에서 달라
					   *          문자열 = 비교가 실패 -> ITEM_ID NULL (527/680건)
					   *   변경 : 정확일치를 ORDER BY 우선순위로 강등하고 TOP 1 로 고정.
					   *          인코딩이 성한 행은 종전과 동일한 결과, 깨진 행은 같은
					   *          출하지시로 폴백. TOP 1 이라 fan-out 구조적 불가.
					   * -------------------------------------------------------------*/
					  OUTER APPLY (
							SELECT TOP 1 OSX.FROM_BUFFER_ID
							  FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN OSX WITH(NOLOCK)
							 WHERE OSX.PLAN_ID			= BP.PLAN_ID
							   AND OSX.SHIPPING_ORDER_ID	= BP.PROD_ORDER_ID
							   AND ED.ATTRIBUTE12		= 'DEMAND_GROUP'
							 ORDER BY CASE WHEN OSX.TO_BUFFER_ID = BP.BUFFER_ID THEN 0 ELSE 1 END
									 , OSX.TO_BUFFER_ID
									 , OSX.FROM_BUFFER_ID
					  ) OS
					  LEFT  JOIN SCP_OPT_ENG_ITEM_SITE_SN SI WITH(NOLOCK)
							  ON SI.PLAN_ID				= BP.PLAN_ID
							 AND SI.BUFFER_ID			= OS.FROM_BUFFER_ID
				WHERE 1=1
				  AND BP.PLAN_ID			= @V_plan_id
				  AND BP.CONSUME_ORDER_TYPE	= 'DeliveryOrder'
			), ITEM_MASTER AS (
				SELECT ITEM_ID
					  ,MAX(ITEM_CLASS)				AS ITEM_CLASS
					  ,MAX(SCP_OPERATION_GROUP)		AS OPERATION_GROUP
					  ,MAX(LEFT(SCP_FLOW_ID, 5))	AS OPERATION_ID
					  ,CASE WHEN MAX(ITEM_CLASS) = 'ES0301' THEN 'ANODE'
							WHEN MAX(ITEM_CLASS) = 'ES0302' THEN 'CATHODE'
							WHEN MAX(ITEM_CLASS) = 'ES0303' THEN 'ONESIDE'
							WHEN MAX(ITEM_CLASS) = 'ES0305' THEN 'ONESIDE'
							ELSE '-'
						END AS ELECTRODE_TYPE
				 FROM SCM_MST_ITEM_SN IM WITH(NOLOCK)
				WHERE IM.ACTIVE_FLAG = 'Y'
				  AND IM.SCP_OPERATION_GROUP IS NOT NULL
				GROUP BY ITEM_ID
			)
			INSERT INTO SCP_EGN_OTPT_RTF_M /* SCP_EGN_OTPT_RTF_M */
					( PLAN_ID
					, PLAN_START_YYYYMMDD
					, DIVISION_ID
					, SCM_SITE_ID
					, ITEM_ID
					, STAGE
					, OPERATION_GROUP
					, OPERATION_ID
					, MEASURE
					, DELIVERY_DATE
					, DELIVERY_QTY
					, DEMAND_GROUP_YN
					, DEMAND_SITE_ID
					, DEMAND_ITEM_ID
					, DEMAND_INCOTERMS
					, PROJECT_CODE
					, FCST_TYPE
					, DEMAND_ID
					, ORDER_ID
					, PEGGING_SEQ
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
					, ATTRIBUTE1 )
			SELECT @V_PLAN_ID								AS PLAN_ID
				  ,@V_PLAN_START_YYYYMMDD					AS PLAN_START_YYYYMMDD
				  ,@V_DIVISION_ID							AS DIVISION_ID
			      ,DO.SITE_ID								AS SCM_SITE_ID
				  /* -------------------------------------------------------------
				   * [수정 2] 2026-08-24
				   *   종전 : CASE WHEN DP.DEMAND_GROUP_YN='Y' THEN DP.ITEM_ID  <-- 방어 없음
				   *               ELSE ISNULL(ISNULL(DO.ITEM_ID, DP.ITEM_ID),'-') END
				   *   변경 : CASE 전체를 ISNULL(...,'-') 로 감싸 'Y' 분기도 방어.
				   *          ELSE 분기의 의미는 종전과 완전히 동일하다.
				   *   주의 : '-' 로 들어간 건수는 정상이면 0건. 04_VALIDATE 로 감시할 것.
				   * -----------------------------------------------------------*/
				  ,ISNULL(
					   CASE WHEN DP.DEMAND_GROUP_YN = 'Y'
							THEN DP.ITEM_ID		-- From Buffer 기준의 품목 정보  (DO의 item_id는 Demand Group명)
							ELSE ISNULL(DO.ITEM_ID, DP.ITEM_ID)
						END
				   , '-')									AS ITEM_ID
				  ,ISNULL(DP.STAGE
						, ISNULL(ED.ATTRIBUTE3,'-'))		AS STAGE
				  ,IM.OPERATION_GROUP
				  ,IM.OPERATION_ID
				  ,'RTF'									AS MEASURE
				  ,DO.DELIVERY_DATE
				  ,CONVERT(FLOAT, ISNULL(DP.FLOW_QTY
										,DO.DELIVERY_QTY))	AS DELIVERY_QTY
				  ,DP.DEMAND_GROUP_YN
				  ,DP.DEMAND_SITE_ID
				  ,DP.DEMAND_ITEM_ID		-- Demand Group이 적용되었으면 demand group명임
				  ,DP.DEMAND_INCOTERMS
				  ,DP.PROJECT_CODE
				  ,DP.FCST_TYPE
				  ,ISNULL(DP.DEMAND_ID, DO.DEMAND_ID)		AS DEMAND_ID
				  ,DO.DELIVERY_ID							AS ORDER_ID
				  ,DP.PEGGING_SEQ
				  ,@v_program_name							AS CREATED_BY
				  ,GETDATE()								AS CREATION_DATE
				  ,@v_program_name							AS LAST_UPDATED_BY
				  ,GETDATE()								AS LAST_UPDATE_DATE
				  ,@V_PLAN_GROUP							AS PLAN_GROUP		-- attribute1 (SHIP_REQ 구분용)
			 FROM SCP_OPT_ENG_OUT_ORDER_DEMAND_DELIVERY_SN DO WITH(NOLOCK)
				  LEFT JOIN SCP_OPT_ENG_DEMAND_SN ED WITH(NOLOCK)
						  ON ED.PLAN_ID				= DO.PLAN_ID
						 AND ED.DEMAND_ID			= DO.DEMAND_ID
				  LEFT	JOIN DBP_DELIVERY DP
						  ON DP.CONSUME_ORDER_ID	= DO.DELIVERY_ID
				  LEFT  JOIN ITEM_MASTER IM
						  ON IM.ITEM_ID				= CASE WHEN DP.DEMAND_GROUP_YN = 'Y'
														   THEN DP.ITEM_ID
														   ELSE DO.ITEM_ID
													   END
			WHERE DO.PLAN_ID = @v_plan_id

		    SET @n_log_count = @@ROWCOUNT;

			-----------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' INSERT MKT_FCST '
			-- 최적화 Input Demand정보를 Main으로 참조
			-- Demand Group이면 Demand_Id (Site/Item/Project 정보 포함)와 Item group정보를 join참조하여 품목 매핑
			-----------------------------------------------------------------------
			;WITH ITEM_GROUP AS (
				SELECT DISTINCT
					   IG.DIVISION_ID
					  ,IG.GROUP_NAME
					  ,GD.PROJECT_CODE
					  ,GD.ITEM_ID
				 FROM SCP_MST_ITEM_GROUP IG WITH(NOLOCK)
					  INNER JOIN SCP_MST_ITEM_GROUP_DETAIL GD WITH(NOLOCK)
							  ON GD.GROUP_ID = IG.GROUP_ID
				WHERE 1=1
				  AND IG.VALID_YN		= 'Y'
				  AND IG.DIVISION_ID	= @V_DIVISION_ID
			), ITEM_MASTER AS (
				SELECT ITEM_ID
					  ,MAX(ITEM_CLASS)				AS ITEM_CLASS
					  ,MAX(SCP_OPERATION_GROUP)		AS OPERATION_GROUP
					  ,MAX(LEFT(SCP_FLOW_ID, 5))	AS OPERATION_ID
					  ,CASE WHEN MAX(ITEM_CLASS) = 'ES0301' THEN 'ANODE'
							WHEN MAX(ITEM_CLASS) = 'ES0302' THEN 'CATHODE'
							WHEN MAX(ITEM_CLASS) = 'ES0303' THEN 'ONESIDE'
							WHEN MAX(ITEM_CLASS) = 'ES0305' THEN 'ONESIDE'
							ELSE '-'
						END AS ELECTRODE_TYPE
				 FROM SCM_MST_ITEM_SN IM WITH(NOLOCK)
				WHERE IM.ACTIVE_FLAG = 'Y'
				  AND IM.SCP_OPERATION_GROUP IS NOT NULL
				GROUP BY ITEM_ID
			)
			INSERT INTO SCP_EGN_OTPT_RTF_M /* SCP_EGN_OTPT_RTF_M */
					( PLAN_ID
					, PLAN_START_YYYYMMDD
					, DIVISION_ID
					, SCM_SITE_ID
					, ITEM_ID
					, STAGE
					, OPERATION_GROUP
					, OPERATION_ID
					, MEASURE
					, DELIVERY_DATE
					, DELIVERY_QTY
					, DEMAND_GROUP_YN
					, DEMAND_SITE_ID
					, DEMAND_ITEM_ID
					, DEMAND_INCOTERMS
					, PROJECT_CODE
					, FCST_TYPE
					, DEMAND_ID
					, ORDER_ID
					, PEGGING_SEQ
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
					, ATTRIBUTE1 )
			SELECT @V_PLAN_ID								AS PLAN_ID
				  ,@V_PLAN_START_YYYYMMDD					AS PLAN_START_YYYYMMDD
				  ,@V_DIVISION_ID							AS DIVISION_ID
			      ,SI.SITE_ID								AS SCM_SITE_ID
				  ,ISNULL(ISNULL(IG.ITEM_ID, SI.ITEM_ID),'-')			AS ITEM_ID
				  ,SI.STAGE
				  ,IM.OPERATION_GROUP
				  ,IM.OPERATION_ID
				  ,'MKT_FCST'								AS MEASURE
				  ,DM.DUE_DATE
				  ,DM.QUANTITY
				  ,CASE WHEN DM.ATTRIBUTE12	= 'DEMAND_GROUP'
					   THEN 'Y'
					   ELSE 'N'
				   END										AS DEMAND_GROUP_YN
				  ,DM.ATTRIBUTE1							AS DEMAND_SITE_ID
				  ,DM.ATTRIBUTE2							AS DEMAND_ITEM_ID
				  ,DM.ATTRIBUTE4							AS DEMAND_INCOTERMS
				  ,DM.ATTRIBUTE5							AS PROJECT_CODE
				  ,DM.ATTRIBUTE8							AS FCST_TYPE
				  ,DM.DEMAND_ID 							AS DEMAND_ID
				  ,NULL										AS ORDER_ID
				  ,0										AS PEGGING_SEQ
				  ,@v_program_name							AS CREATED_BY
				  ,GETDATE()								AS CREATION_DATE
				  ,@v_program_name							AS LAST_UPDATED_BY
				  ,GETDATE()								AS LAST_UPDATE_DATE
				  ,@V_PLAN_GROUP							AS PLAN_GROUP		-- attribute1 (SHIP_REQ 구분용)
			 FROM SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
				  INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SI WITH(NOLOCK)
						  ON SI.PLAN_ID		= DM.PLAN_ID
						 AND SI.BUFFER_ID	= DM.BUFFER_ID
				  LEFT  JOIN ITEM_GROUP IG
						  ON DM.ATTRIBUTE12	= 'DEMAND_GROUP'
						 AND DM.ATTRIBUTE2	= IG.GROUP_NAME
						 AND DM.DEMAND_ID LIKE CONCAT(SI.SITE_ID, '::',IG.ITEM_ID,'::%@',IG.PROJECT_CODE, '::%')
				  LEFT  JOIN ITEM_MASTER IM
						  ON IM.ITEM_ID		= ISNULL(IG.ITEM_ID, SI.ITEM_ID)
			WHERE 1=1
			  AND DM.PLAN_ID = @V_PLAN_ID ;

		    SET @n_log_count = @n_log_count + @@ROWCOUNT;

			-------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' DELETE 전극 Routing Resource정보가 없는 MKT_FCST 정보 삭제'
			/* 전극 Anode 최적화 계획은 아래와 같은 내용이 반영되어 있어 해당 로직을 추가함.
				1. resource에서 _C 라인을 추출하고
				2. routing_resoure에서 해당 라인에 대한 item만 뽑아내고
				3. item_site에서 그 아이템만 남긴다
			*/
			-------------------------------------------------------------------------------------------------------------
			IF EXISTS (SELECT TOP 1 'X'
						FROM SCM_MST_DIVISION DM WITH(NOLOCK)
					   WHERE DM.DIVISION_ID = @V_DIVISION_ID
					     AND DM.ATTRIBUTE3  = 'EE'	) -- 전극
				BEGIN

					DELETE TG
					  FROM SCP_EGN_OTPT_RTF_M TG
					 WHERE 1=1
					   AND NOT EXISTS (SELECT 'X'
										 FROM SCP_OPT_ENG_ROUTING_RESOURCE_SN RR WITH(NOLOCK)
										WHERE 1=1
										  AND RR.PLAN_ID	= TG.PLAN_ID
										  AND RR.ATTRIBUTE2	= TG.ITEM_ID)
					SET @n_log_count = @n_log_count - @@ROWCOUNT;
			  END;



	  COMMIT TRAN ;  --- transaction 종료
	------- End Tran : ==========================================================================================================

	  END
	END TRY

	BEGIN CATCH
		if (xact_state() <> 0) ROLLBACK TRAN;

		-- ERROR LOG
		SET @v_log_type = N'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
		                          ,@p_log_type      = @v_log_type
		                          ,@p_log_count     = @n_log_count
		                          ,@p_log_message   = @v_log_message
		                          ,@p_description   = @v_description
		                          ,@p_event_date    = @d_event_date
		                          ,@p_user_id       = @v_batch_user
		                          ;
		PRINT @v_log_message      + ' : ' + @v_description ;
		RETURN -1;

    END CATCH;

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))
    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'##### END of procedure #####';
    SET @v_description = CONCAT('[plan_id=', ISNULL(@V_PLAN_ID,''),  ']['  + @v_exec_time + ']') ;
    SET @d_event_date  = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count
                              ,@p_log_message   =@v_log_message
                              ,@p_description   =@v_description
                              ,@p_event_date    =@d_event_date
                              ,@p_user_id       =@v_batch_user
                              ;
	PRINT @v_log_message      + ' : ' + @v_description ;
	RETURN 1;

END
