/* ============================================================================================
   PR_SCP_OPMZ_APPLY_PLAN_ROUTING  (2026-07-13 신규)
   --------------------------------------------------------------------------------------------
   [목적]
     엔진 입력 스냅샷 테이블(OPTENG_SCP)의 라우팅자원 전체상태를 @PLAN_ID(채번 엔진 계획ID) 기준으로 읽어
     GSCM 최적화 기준정보 3종을 산출/반영한다. (시나리오 JSON 패치가 아니라 '엔진 테이블 현재상태'가 소스.)
       · SCP_OPT_ENG_ROUTING_RESOURCE (+ ENG_RESOURCE, ITEM_BOM_ROUTING) → RAMP_UP / SOP_EOP / DDLY_CAPA
     (NO_WORK 는 EVERY_CALENDAR 소스로 별도이며 이 프로시저 범위 아님.)

   [키 해석]
     ROUTING_RESOURCE(rr) 를 PLAN_ID 로 필터 →
       · RESOURCE_ID  → SCP_OPT_ENG_RESOURCE : RESOURCE_NAME(=LINE)
       · LINE         → SCP_OPMZ_LINE_OPERATION 룩업(SEGMENT3=LINE, 유일키) : DIVISION_ID(SEG1)/PLANT_ID(SEG2)/OPERATION_ID(SEG4)
                        ※ SCM_MST_SITE 는 쓰지 않는다 — 전극 사이트를 DIVISION '40'으로 매핑해 룩업의 'EE'와 불일치(→OP 미해석) 하기 때문.
                          룩업이 (DIV,PLANT,OP) 의 권위. 룩업 미등록 라인은 산출 제외.
       · ROUTING_ID   → SCP_OPT_ENG_ITEM_BOM_ROUTING : BUFFER_ID → ITEM (BUFFER 가 'SITE::ITEM::GRADE' 형이면 seg2, 아니면 코드 그대로)

   [산출식]
     · RAMP_UP  : EFCY(%) = MIN(LOAD_PER) OVER(라인/품목) ÷ 각 LOAD_PER × 100   (최소 LOAD_PER=정상속도=100%)
     · SOP_EOP  : SOP = MIN(START_DATE) (라인/품목), TYPE='SOP' 만 적재 (EOP 미관리 관례)
     · DDLY_CAPA: 라인/품목/월(YYYYMM=LEFT(START,6))별 MIN(LOAD_PER) →
                  조립(40)=CAPA=86400/(lp*rt/100) · 전극(EE)=M_MIN=60/(lp*rt/100*LANE*(WIDE_YN='Y'?2:1))
                  rt/LANE/WIDE 는 기존 SCP_OPMZ_DDLY_CAPA 같은 라인 형제행에서 승계(형제 없으면 SKIP).

   [출처/이력]  ATTRIBUTE9 = @PLAN_ID.  DESC 꼬리 = 'SNRO_'+@PLAN_ID (FN_GET_SCP_OPMZ_DESC_HIST 재사용).

   [파라미터]
     @PLAN_ID          채번 엔진 계획ID(예 '20260406_40_18650_OC_001_S002'). 필수.
     @USER_ID          감사 컬럼(미지정 시 SUSER_SNAME()).
     @PREVIEW_YN       'Y'(기본)=쓰기 없이 산출결과 3개 SELECT 미리보기 / 'N'=실제 MERGE 반영.
     @RETURN_RESULT_YN 'Y' 면 반영 모드에서 요약 결과셋 반환.

   [비고] compat120 안전(JSON 미사용, 테이블 직접). 크로스DB(OPTENG↔LGCE) 문자열은 COLLATE DATABASE_DEFAULT.
   ============================================================================================ */
/*
 * Program ID   : PR_SCP_OPMZ_APPLY_PLAN_ROUTING
 * Description  : 엔진 계획(PLAN_ID) 라우팅 상태 → SCP_OPMZ_RAMP_UP/SOP_EOP/DDLY_CAPA 반영
 * Program History
 *===================================================================================================
 *   Date       In Charge        Description
 *===================================================================================================
 * 2026/07/02   park.choyi        [E20260618-001356] 시나리오 플래닝 SCP 기준정보 업데이트 - Initial Release
 *
 */
CREATE   PROCEDURE dbo.PR_SCP_OPMZ_APPLY_PLAN_ROUTING
    @PLAN_ID          NVARCHAR(120),
    @USER_ID          NVARCHAR(200) = NULL,
    @PREVIEW_YN       NCHAR(1)      = N'Y',
    @RETURN_RESULT_YN NCHAR(1)      = N'Y'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NULLIF(LTRIM(RTRIM(@PLAN_ID)), N'') IS NULL
        THROW 51100, 'PLAN_ID IS REQUIRED.', 1;

    DECLARE @uid        NVARCHAR(200) = COALESCE(@USER_ID, SUSER_SNAME());
    DECLARE @START_TRAN BIT = CASE WHEN @@TRANCOUNT = 0 THEN 1 ELSE 0 END;
    DECLARE @tail       NVARCHAR(120) = CASE WHEN @PLAN_ID LIKE N'SNRO[_]%' THEN @PLAN_ID ELSE N'SNRO_' + @PLAN_ID END;
    DECLARE @RP INT=0, @SOP INT=0, @DC_UPD INT=0, @DC_INS INT=0, @DC_SKIP INT=0;
    DECLARE @ERR_MSG NVARCHAR(2048), @LOG_DT DATETIME, @LOG_CNT INT, @LOG_DESC NVARCHAR(500);

    IF OBJECT_ID('tempdb..#res')  IS NOT NULL DROP TABLE #res;
    IF OBJECT_ID('tempdb..#rp')   IS NOT NULL DROP TABLE #rp;
    IF OBJECT_ID('tempdb..#sop')  IS NOT NULL DROP TABLE #sop;
    IF OBJECT_ID('tempdb..#dc')   IS NOT NULL DROP TABLE #dc;

    /* 1) 엔진 라우팅자원 → 라인/품목/기간/LOAD_PER 해석(#res) */
    ;WITH rr AS (
        SELECT rr.ROUTING_ID COLLATE DATABASE_DEFAULT AS ROUTING_ID,
               rr.RESOURCE_ID COLLATE DATABASE_DEFAULT AS RESOURCE_ID,
               TRY_CAST(rr.LOAD_PER AS float) AS load_per,
               rr.START_DATE COLLATE DATABASE_DEFAULT AS START_DATE,
               rr.END_DATE   COLLATE DATABASE_DEFAULT AS END_DATE
        FROM dbo.SCP_OPT_ENG_ROUTING_RESOURCE_SN rr
        WHERE rr.PLAN_ID COLLATE DATABASE_DEFAULT = @PLAN_ID
          AND TRY_CAST(rr.LOAD_PER AS float) > 0
    ),
    res AS (
        SELECT r.RESOURCE_ID COLLATE DATABASE_DEFAULT AS RESOURCE_ID,
               MAX(r.SITE_ID)       COLLATE DATABASE_DEFAULT AS SITE_ID,
               MAX(r.RESOURCE_NAME) COLLATE DATABASE_DEFAULT AS LINE_ID
        FROM dbo.SCP_OPT_ENG_RESOURCE_SN r
        WHERE r.PLAN_ID COLLATE DATABASE_DEFAULT = @PLAN_ID
        GROUP BY r.RESOURCE_ID
    ),
    ibr AS (
        SELECT i.ROUTING_ID COLLATE DATABASE_DEFAULT AS ROUTING_ID,
               MAX(i.BUFFER_ID) COLLATE DATABASE_DEFAULT AS BUFFER_ID
        FROM dbo.SCP_OPT_ENG_ITEM_BOM_ROUTING_SN i
        WHERE i.PLAN_ID COLLATE DATABASE_DEFAULT = @PLAN_ID
        GROUP BY i.ROUTING_ID
    )
    -- DIVISION/PLANT/OPERATION 은 SCP_OPMZ_LINE_OPERATION 룩업에서 LINE(=RESOURCE_NAME) 으로 직접 조회(룩업의 LINE 이 유일키).
    -- (SCM_MST_SITE.DIVISION_ID 는 전극 사이트를 '40'으로 매핑해 룩업의 'EE'와 불일치 → OP 미해석/전량 탈락하므로 룩업을 권위로 사용.)
    SELECT
        lo.SEGMENT1 COLLATE DATABASE_DEFAULT AS DIVISION_ID,
        lo.SEGMENT2 COLLATE DATABASE_DEFAULT AS PLANT_ID,
        res.LINE_ID,
        res.SITE_ID COLLATE DATABASE_DEFAULT AS SITE_ID,   -- 환산자(FN_GET_SCP_OPMZ_ITEM_CONV) 조회용 SITE(SCM_SITE_ID)
        lo.SEGMENT4 COLLATE DATABASE_DEFAULT AS OPERATION_ID,
        CASE WHEN ibr.BUFFER_ID LIKE '%::%'
             THEN dbo.FN_SPLIT_VAL_SN(ibr.BUFFER_ID,'::',2) COLLATE DATABASE_DEFAULT
             ELSE ibr.BUFFER_ID END AS ITEM_ID,
        CAST('-' AS NVARCHAR(30)) AS LINE_TYPE,
        rr.START_DATE, rr.END_DATE, rr.load_per
    INTO #res
    FROM rr
    JOIN res ON res.RESOURCE_ID = rr.RESOURCE_ID
    LEFT JOIN ibr ON ibr.ROUTING_ID = rr.ROUTING_ID
    JOIN dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL lo
      ON lo.LOOKUP_TYPE = N'SCP_OPMZ_LINE_OPERATION' AND lo.VALID_YN = 'Y'
     AND lo.SEGMENT3 = res.LINE_ID;

    -- 유효행: 라인OP·품목·기간 모두 존재
    DELETE FROM #res
    WHERE COALESCE(OPERATION_ID,N'')=N'' OR COALESCE(ITEM_ID,N'')=N''
       OR COALESCE(DIVISION_ID,N'')=N''  OR COALESCE(LINE_ID,N'')=N''
       OR COALESCE(START_DATE,N'')=N'';

    /* 2) RAMP_UP 산출(#rp) : EFCY = MIN(load_per) OVER(라인/품목) / load_per * 100 */
    SELECT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ITEM_ID, LINE_TYPE, START_DATE, END_DATE,
           CONVERT(NUMERIC(5,2), ROUND(
               MIN(load_per) OVER (PARTITION BY DIVISION_ID,PLANT_ID,LINE_ID,ITEM_ID) / load_per * 100.0, 2)) AS EFCY
    INTO #rp
    FROM #res
    WHERE COALESCE(END_DATE,N'')<>N'';
    SET @RP = (SELECT COUNT(*) FROM #rp);

    /* 3) SOP_EOP 산출(#sop) : SOP=MIN(START), TYPE='SOP' */
    SELECT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ITEM_ID, LINE_TYPE,
           N'SOP' AS TYPE, MIN(START_DATE) AS [DATE]
    INTO #sop
    FROM #res
    GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ITEM_ID, LINE_TYPE;
    SET @SOP = (SELECT COUNT(*) FROM #sop);

    /* 4) DDLY_CAPA 산출(#dc) : 라인/품목/월별 MIN(load_per) */
    SELECT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ITEM_ID,
           LEFT(START_DATE,6) AS YYYYMM, MIN(load_per) AS new_lp, MAX(SITE_ID) AS SITE_ID
    INTO #dc
    FROM #res
    GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ITEM_ID, LEFT(START_DATE,6);

    /* ========================= 미리보기 모드 ========================= */
    IF @PREVIEW_YN = N'Y'
    BEGIN
        SELECT N'RAMP_UP' AS TARGET, DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ITEM_ID, START_DATE, END_DATE, EFCY
        FROM #rp ORDER BY ITEM_ID, START_DATE;

        SELECT N'SOP_EOP' AS TARGET, DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ITEM_ID, TYPE, [DATE]
        FROM #sop ORDER BY ITEM_ID;

        -- DDLY 미리보기: 기존 SCP_OPMZ_DDLY_CAPA 같은 라인 형제(물리속성) 유무에 따라 CAPA/M_MIN 산출(형제 없으면 계산 불가 표시)
        SELECT N'DDLY_CAPA' AS TARGET, d.DIVISION_ID, d.PLANT_ID, d.LINE_ID, d.OPERATION_ID, d.ITEM_ID, d.YYYYMM,
               d.new_lp,
               sib.PRDN_OPER_RT, sib.LANE, sib.WIDE_YN,
               CASE WHEN sib.LINE_ID IS NULL THEN NULL
                    WHEN d.DIVISION_ID=N'EE'
                        THEN CONVERT(NVARCHAR(50),CONVERT(NUMERIC(20,6),
                             60.0/(d.new_lp*dbo.FN_GET_SCP_OPMZ_ITEM_CONV(d.SITE_ID,d.ITEM_ID,@PLAN_ID)*(ISNULL(NULLIF(sib.PRDN_OPER_RT,0),100)/100.0)*NULLIF(sib.LANE,0)*(CASE WHEN sib.WIDE_YN='Y' THEN 2 ELSE 1 END))))
                    ELSE CONVERT(NVARCHAR(50),CONVERT(NUMERIC(18,4),
                             86400.0/(d.new_lp*(ISNULL(NULLIF(sib.PRDN_OPER_RT,0),100)/100.0)))) END AS VALUE_EST,
               CASE WHEN sib.LINE_ID IS NULL THEN N'NO_SIBLING(물리속성 미등록→반영시 SKIP)' ELSE N'OK' END AS NOTE
        FROM #dc d
        OUTER APPLY (
            SELECT TOP 1 x.LINE_ID, x.PRDN_OPER_RT, x.LANE, x.WIDE_YN
            FROM dbo.SCP_OPMZ_DDLY_CAPA x
            WHERE x.DIVISION_ID=d.DIVISION_ID AND x.PLANT_ID=d.PLANT_ID AND x.LINE_ID=d.LINE_ID AND x.LANE>0
            ORDER BY CASE WHEN x.ITEM_ID=d.ITEM_ID THEN 0 ELSE 1 END, x.YYYYMM DESC
        ) sib
        ORDER BY d.ITEM_ID, d.YYYYMM;

        SELECT @PLAN_ID AS PLAN_ID, N'PREVIEW' AS MODE, @RP AS RAMP_UP_ROWS, @SOP AS SOP_EOP_ROWS,
               (SELECT COUNT(*) FROM #dc) AS DDLY_ROWS;
        RETURN;
    END

    /* ========================= 반영 모드 (@PREVIEW_YN='N') ========================= */
    BEGIN TRY
        IF @START_TRAN = 1 BEGIN TRAN;

        SET @LOG_DT=GETDATE();
        EXEC dbo.PR_SCM_SYS_LOG_BATCH @p_program_name=N'PR_SCP_OPMZ_APPLY_PLAN_ROUTING', @p_log_type=N'START',
             @p_log_count=0, @p_log_message=N'PLAN 라우팅 반영 시작', @p_description=@PLAN_ID, @p_event_date=@LOG_DT;

        /* 4-1) RAMP_UP MERGE(full PK) */
        MERGE dbo.SCP_OPMZ_RAMP_UP AS tgt
        USING #rp AS s
           ON tgt.DIVISION_ID=s.DIVISION_ID AND tgt.PLANT_ID=s.PLANT_ID AND tgt.LINE_ID=s.LINE_ID
          AND tgt.OPERATION_ID=s.OPERATION_ID AND tgt.LINE_TYPE=s.LINE_TYPE AND tgt.ITEM_ID=s.ITEM_ID
          AND tgt.START_DATE=s.START_DATE AND tgt.END_DATE=s.END_DATE
        WHEN MATCHED THEN UPDATE SET
             tgt.EFCY=s.EFCY, tgt.VALID_YN='Y',
             tgt.[DESC]=dbo.FN_GET_SCP_OPMZ_DESC_HIST(tgt.[DESC], N'램프업(플랜)', @tail),
             tgt.ATTRIBUTE9=@PLAN_ID, tgt.LAST_UPDATED_BY=@uid, tgt.LAST_UPDATE_DATE=GETDATE()
        WHEN NOT MATCHED THEN INSERT
             (DIVISION_ID,PLANT_ID,LINE_ID,OPERATION_ID,ITEM_ID,START_DATE,END_DATE,EFCY,[DESC],VALID_YN,
              CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,LINE_TYPE,ATTRIBUTE9)
             VALUES(s.DIVISION_ID,s.PLANT_ID,s.LINE_ID,s.OPERATION_ID,s.ITEM_ID,s.START_DATE,s.END_DATE,s.EFCY,
              CONCAT(N'램프업(플랜) (',@tail,N')'),'Y',@uid,GETDATE(),@uid,GETDATE(),s.LINE_TYPE,@PLAN_ID);
        SET @RP=@@ROWCOUNT;

        /* 4-2) SOP_EOP : 기존 (키+TYPE) 활성행 소프트삭제 + 새 SOP full-PK MERGE */
        UPDATE se SET se.VALID_YN='N',
               se.[DESC]=dbo.FN_GET_SCP_OPMZ_DESC_HIST(se.[DESC], N'양산개시(플랜)', @tail),
               se.ATTRIBUTE9=@PLAN_ID, se.LAST_UPDATED_BY=@uid, se.LAST_UPDATE_DATE=GETDATE()
        FROM dbo.SCP_OPMZ_SOP_EOP se
        JOIN (SELECT DISTINCT DIVISION_ID,PLANT_ID,LINE_ID,OPERATION_ID,LINE_TYPE,ITEM_ID,TYPE FROM #sop) k
          ON se.DIVISION_ID=k.DIVISION_ID AND se.PLANT_ID=k.PLANT_ID AND se.LINE_ID=k.LINE_ID
         AND se.OPERATION_ID=k.OPERATION_ID AND se.LINE_TYPE=k.LINE_TYPE AND se.ITEM_ID=k.ITEM_ID AND se.TYPE=k.TYPE
        WHERE se.VALID_YN<>'N';

        MERGE dbo.SCP_OPMZ_SOP_EOP AS tgt
        USING (SELECT s.*, dbo.FN_GET_SCP_OPMZ_DESC_HIST(o.OLD_DESC, N'양산개시(플랜)', @tail) AS NEW_DESC
               FROM #sop s
               OUTER APPLY (SELECT MAX(se.[DESC]) AS OLD_DESC FROM dbo.SCP_OPMZ_SOP_EOP se
                            WHERE se.DIVISION_ID=s.DIVISION_ID AND se.PLANT_ID=s.PLANT_ID AND se.LINE_ID=s.LINE_ID
                              AND se.OPERATION_ID=s.OPERATION_ID AND se.LINE_TYPE=s.LINE_TYPE AND se.ITEM_ID=s.ITEM_ID
                              AND se.TYPE=s.TYPE AND se.VALID_YN='Y') o) AS src
           ON tgt.DIVISION_ID=src.DIVISION_ID AND tgt.PLANT_ID=src.PLANT_ID AND tgt.LINE_ID=src.LINE_ID
          AND tgt.OPERATION_ID=src.OPERATION_ID AND tgt.LINE_TYPE=src.LINE_TYPE AND tgt.ITEM_ID=src.ITEM_ID
          AND tgt.TYPE=src.TYPE AND tgt.[DATE]=src.[DATE]
        WHEN MATCHED THEN UPDATE SET tgt.VALID_YN='Y', tgt.[DESC]=src.NEW_DESC, tgt.ATTRIBUTE1=NULL,
             tgt.ATTRIBUTE9=@PLAN_ID, tgt.LAST_UPDATED_BY=@uid, tgt.LAST_UPDATE_DATE=GETDATE()
        WHEN NOT MATCHED THEN INSERT
             (DIVISION_ID,PLANT_ID,LINE_ID,OPERATION_ID,ITEM_ID,TYPE,[DATE],[DESC],VALID_YN,
              CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,LINE_TYPE,ATTRIBUTE1,ATTRIBUTE9)
             VALUES(src.DIVISION_ID,src.PLANT_ID,src.LINE_ID,src.OPERATION_ID,src.ITEM_ID,src.TYPE,src.[DATE],src.NEW_DESC,'Y',
              @uid,GETDATE(),@uid,GETDATE(),src.LINE_TYPE,NULL,@PLAN_ID);
        SET @SOP=@@ROWCOUNT;

        /* 4-3) DDLY_CAPA : 기존행 UPDATE(사업부 분기) + 형제복사 INSERT(없으면 SKIP) */
        UPDATE dc SET
             dc.CAPA = CASE WHEN dc.DIVISION_ID=N'EE' THEN dc.CAPA
                            ELSE CONVERT(NUMERIC(18,4), 86400.0/(s.new_lp*(ISNULL(NULLIF(dc.PRDN_OPER_RT,0),100)/100.0))) END,
             dc.M_MIN = CASE WHEN dc.DIVISION_ID=N'EE'
                             THEN CONVERT(NVARCHAR(50),CONVERT(NUMERIC(20,6),
                                  60.0/(s.new_lp*dbo.FN_GET_SCP_OPMZ_ITEM_CONV(s.SITE_ID,s.ITEM_ID,@PLAN_ID)*(ISNULL(NULLIF(dc.PRDN_OPER_RT,0),100)/100.0)*NULLIF(dc.LANE,0)*(CASE WHEN dc.WIDE_YN='Y' THEN 2 ELSE 1 END))))
                             ELSE dc.M_MIN END,
             dc.VALID_YN='Y', dc.ATTRIBUTE9=@PLAN_ID,
             dc.ATTRIBUTE1=dbo.FN_GET_SCP_OPMZ_DESC_HIST(dc.ATTRIBUTE1, CASE WHEN dc.DIVISION_ID=N'EE' THEN N'코팅속도(플랜)' ELSE N'생산능력(플랜)' END, @tail),
             dc.LAST_UPDATED_BY=@uid, dc.LAST_UPDATE_DATE=GETDATE()
        FROM dbo.SCP_OPMZ_DDLY_CAPA dc
        JOIN #dc s ON dc.DIVISION_ID=s.DIVISION_ID AND dc.PLANT_ID=s.PLANT_ID AND dc.LINE_ID=s.LINE_ID
                  AND dc.ITEM_ID=s.ITEM_ID AND dc.YYYYMM=s.YYYYMM;
        SET @DC_UPD=@@ROWCOUNT;

        INSERT INTO dbo.SCP_OPMZ_DDLY_CAPA
            (DIVISION_ID,PLANT_ID,LINE_ID,OPERATION_ID,ITEM_ID,YYYYMM,CAPA,M_MIN,LANE,WIDE_YN,PRDN_OPER_RT,VALID_YN,
             CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE9)
        SELECT s.DIVISION_ID,s.PLANT_ID,s.LINE_ID,sib.OPERATION_ID,s.ITEM_ID,s.YYYYMM,
               CASE WHEN s.DIVISION_ID=N'EE' THEN sib.CAPA
                    ELSE CONVERT(NUMERIC(20,10),86400.0/(s.new_lp*(ISNULL(NULLIF(sib.PRDN_OPER_RT,0),100)/100.0))) END,
               CASE WHEN s.DIVISION_ID=N'EE'
                    THEN CONVERT(NVARCHAR(50),CONVERT(NUMERIC(20,6),
                         60.0/(s.new_lp*dbo.FN_GET_SCP_OPMZ_ITEM_CONV(s.SITE_ID,s.ITEM_ID,@PLAN_ID)*(ISNULL(NULLIF(sib.PRDN_OPER_RT,0),100)/100.0)*NULLIF(sib.LANE,0)*(CASE WHEN sib.WIDE_YN=N'Y' THEN 2 ELSE 1 END))))
                    ELSE sib.M_MIN END,
               sib.LANE, sib.WIDE_YN, sib.PRDN_OPER_RT, N'Y',
               @uid,GETDATE(),@uid,GETDATE(),
               CONCAT(CASE WHEN s.DIVISION_ID=N'EE' THEN N'코팅속도(플랜)' ELSE N'생산능력(플랜)' END,N' (',@tail,N')'), @PLAN_ID
        FROM #dc s
        CROSS APPLY (
            SELECT TOP 1 d.OPERATION_ID,d.LANE,d.WIDE_YN,d.PRDN_OPER_RT,d.CAPA,d.M_MIN
            FROM dbo.SCP_OPMZ_DDLY_CAPA d
            WHERE d.DIVISION_ID=s.DIVISION_ID AND d.PLANT_ID=s.PLANT_ID AND d.LINE_ID=s.LINE_ID AND d.LANE>0 AND d.WIDE_YN IS NOT NULL
            ORDER BY CASE WHEN d.ITEM_ID=s.ITEM_ID THEN 0 ELSE 1 END, d.YYYYMM DESC
        ) sib
        WHERE NOT EXISTS (SELECT 1 FROM dbo.SCP_OPMZ_DDLY_CAPA e
                          WHERE e.DIVISION_ID=s.DIVISION_ID AND e.PLANT_ID=s.PLANT_ID AND e.LINE_ID=s.LINE_ID
                            AND e.ITEM_ID=s.ITEM_ID AND e.YYYYMM=s.YYYYMM);
        SET @DC_INS=@@ROWCOUNT;
        SET @DC_SKIP=(SELECT COUNT(*) FROM #dc s WHERE NOT EXISTS (SELECT 1 FROM dbo.SCP_OPMZ_DDLY_CAPA e
                          WHERE e.DIVISION_ID=s.DIVISION_ID AND e.PLANT_ID=s.PLANT_ID AND e.LINE_ID=s.LINE_ID
                            AND e.ITEM_ID=s.ITEM_ID AND e.YYYYMM=s.YYYYMM));

        IF @START_TRAN = 1 COMMIT;

        SET @LOG_DT=GETDATE();
        SET @LOG_CNT=ISNULL(@RP,0)+ISNULL(@SOP,0)+ISNULL(@DC_UPD,0)+ISNULL(@DC_INS,0);
        SET @LOG_DESC=LEFT(CONCAT(N'PLAN_ID=',@PLAN_ID,N'; RAMP=',@RP,N' SOP=',@SOP,N' DDLY_UPD=',@DC_UPD,N' DDLY_INS=',@DC_INS,N' DDLY_SKIP=',@DC_SKIP),500);
        EXEC dbo.PR_SCM_SYS_LOG_BATCH @p_program_name=N'PR_SCP_OPMZ_APPLY_PLAN_ROUTING', @p_log_type=N'END',
             @p_log_count=@LOG_CNT, @p_log_message=N'PLAN 라우팅 반영 완료', @p_description=@LOG_DESC, @p_event_date=@LOG_DT;

        IF @RETURN_RESULT_YN=N'Y'
            SELECT @PLAN_ID AS PLAN_ID, N'APPLIED' AS MODE, @RP AS RAMP_UP_ROWS, @SOP AS SOP_EOP_ROWS,
                   @DC_UPD AS DDLY_UPD, @DC_INS AS DDLY_INS, @DC_SKIP AS DDLY_SKIP_NOSIB;
    END TRY
    BEGIN CATCH
        IF @START_TRAN=1 AND XACT_STATE()<>0 ROLLBACK;
        SET @ERR_MSG=ERROR_MESSAGE();
        IF @START_TRAN=1
        BEGIN
            SET @LOG_DT=GETDATE();
            EXEC dbo.PR_SCM_SYS_LOG_BATCH @p_program_name=N'PR_SCP_OPMZ_APPLY_PLAN_ROUTING', @p_log_type=N'ERROR',
                 @p_log_count=0, @p_log_message=@ERR_MSG, @p_description=@PLAN_ID, @p_event_date=@LOG_DT;
        END;
        THROW;
    END CATCH;
END
