-- ▼ PR_SCP_OPMZ_APPLY_SNRO
/*
 * Program ID   : PR_SCP_OPMZ_APPLY_SNRO
 * Description  : 시나리오 기준정보 일괄 반영 오케스트레이터 (4개 APPLY 단일 트랜잭션)
 * Program History
 *===================================================================================================
 *   Date       In Charge        Description
 *===================================================================================================
 * 2026/07/02   park.choyi        [E20260618-001356] 시나리오 플래닝 SCP 기준정보 업데이트 - Initial Release
 *
 */
CREATE   PROCEDURE dbo.PR_SCP_OPMZ_APPLY_SNRO
    @SNRO_CD          NVARCHAR(50),
    @USER_ID          NVARCHAR(200) = NULL,
    @OPT_KEY_VAL_ID   NVARCHAR(200) = NULL,   -- 콤마구분 카드 목록(예 'CRD-00001,CRD-00104'=공휴일만); NULL=전체. 4개 자식에 그대로 전달
    @RETURN_RESULT_YN NCHAR(1)      = N'Y'
AS
BEGIN
    /*==================================================================================================
      프로시저 : dbo.PR_SCP_OPMZ_APPLY_SNRO
      --------------------------------------------------------------------------------------------------
      [목적/역할]
        - 시나리오 코드(@SNRO_CD) 하나를 입력받아, 해당 시나리오의 마스터 변경 4개 항목을
          '하나의 트랜잭션'으로 순차 반영하는 오케스트레이터(부모) 프로시저.
        - 4개 항목이 전부 성공하면 커밋, 하나라도 실패하면 전체 롤백(전부 성공 또는 전부 실패).

      [자식 호출 순서] (모두 @RETURN_RESULT_YN=N'N' 으로 호출 → 자식은 결과셋을 반환하지 않음)
        1) PR_SCP_OPMZ_APPLY_NO_WORK   : 비조업(NO WORK)
        2) PR_SCP_OPMZ_APPLY_DDLY_CAPA : 코팅증속(DDLY_CAPA)
        3) PR_SCP_OPMZ_APPLY_RAMP_UP   : 램프업(RAMP_UP)
        4) PR_SCP_OPMZ_APPLY_SOP_EOP   : 일정변경(SOP/EOP)

      [트랜잭션 전략]
        - @START_TRAN = CASE WHEN @@TRANCOUNT = 0 THEN 1 ELSE 0 END 으로 트랜잭션 소유권을 판정.
          · 이 프로시저가 트랜잭션을 시작(=소유)한 경우에만 BEGIN TRAN / COMMIT / ROLLBACK 수행.
          · 이미 외부 트랜잭션 안에서 호출된 경우(@@TRANCOUNT>0)에는 그 트랜잭션에 합류만 함.
        - 각 자식 프로시저도 동일 규칙(@@TRANCOUNT>0)이라 자체 BEGIN/COMMIT/ROLLBACK 을 하지 않고
          이 트랜잭션에 합류한다. 따라서 중첩 상황에서 ERROR 로그 기록과 실제 롤백은
          트랜잭션 소유자(=이 오케스트레이터)만 담당한다.
        - SET XACT_ABORT ON 으로 런타임 오류 시 트랜잭션을 즉시 무효화(전체 실패)한다.

      [반환]
        - @RETURN_RESULT_YN = N'Y' 인 경우에만, 이번 실행에서 자식들이 남긴 SUCCESS 로그를
          SCM_SYS_LOG_BATCH 에서 조회하여 '단계별 결과셋'으로 반환한다.
          (필터: EVENT_DATE >= @t0 그리고 DESCRIPTION LIKE 'SNRO=<코드>;%' → 이번 실행분만 식별)
        - 결과셋은 COMMIT 이전에 SELECT 하지만, 같은 세션 내에서는 커밋 전 데이터가 보이므로 정상 조회됨.

      [파라미터]
        - @SNRO_CD          (필수) : 반영 대상 시나리오 코드. 공백/NULL 이면 THROW 51040.
        - @USER_ID          (선택) : 수행자 ID. NULL 이면 SUSER_SNAME() 로 대체.
        - @RETURN_RESULT_YN (선택) : 결과셋 반환 여부(기본 N'Y'). 자식에게는 항상 N'N' 으로 전달.

      [단계 개요]
        1) 실행 옵션 설정(NOCOUNT / XACT_ABORT)
        2) 필수 입력값(@SNRO_CD) 검증
        3) 런타임 변수 선언(수행자, 트랜잭션 소유 판정, 실행 시각 @t0, 로그용 변수)
        4) 통합 START 로그 기록(트랜잭션 밖 → 롤백돼도 보존)
        5) [TRY] 트랜잭션 시작 후 자식 4종 순차 EXEC
        6) [TRY] 단계별 결과셋 반환(옵션)
        7) [TRY] 커밋
        8) [TRY] 통합 SUCCESS 로그 기록
        9) [CATCH] 전체 롤백 → 통합 ERROR 로그 기록 → THROW 재전파
    ==================================================================================================*/

    /* 1 시작: 기본 실행 옵션.
               - SET NOCOUNT ON  : 각 문장의 "영향받은 행 수" 메시지를 끈다(불필요한 결과 방지).
               - SET XACT_ABORT ON: 런타임 오류 발생 시 현재 트랜잭션을 즉시 전체 실패시킨다. */
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    /* 1 종료. */

    /* 2 시작: 필수 입력값(시나리오 코드) 검증.
               - LTRIM/RTRIM 후 빈 문자열이면 NULLIF 로 NULL 처리되어 필수값 누락으로 간주.
               - 누락 시 사용자 지정 오류(51040)로 즉시 중단. */
    IF NULLIF(LTRIM(RTRIM(@SNRO_CD)), N'') IS NULL
        THROW 51040, 'SNRO_CD IS REQUIRED.', 1;
    /* 2 종료. */

    /* 3 시작: 런타임 변수 선언.
               - @uid        : 수행자 ID(@USER_ID 없으면 현재 로그인명으로 대체).
               - @START_TRAN : 트랜잭션 소유 여부(1=이 proc이 시작·소유, 0=외부 트랜잭션에 합류).
               - @t0         : 실행 시작 시각. 6단계 결과 조회에서 '이번 실행분' 식별 기준.
               - @ERR_MSG / @LOG_DT / @LOG_CNT / @LOG_DESC : 통합 로그 기록용 임시 변수. */
    DECLARE @uid        NVARCHAR(200) = COALESCE(@USER_ID, SUSER_SNAME());
    DECLARE @START_TRAN BIT = CASE WHEN @@TRANCOUNT = 0 THEN 1 ELSE 0 END;
    DECLARE @t0 DATETIME = GETDATE();
    DECLARE @ERR_MSG  NVARCHAR(2048);
    DECLARE @LOG_DT   DATETIME;
    DECLARE @LOG_CNT  INT;
    DECLARE @LOG_DESC NVARCHAR(500);
    /* 3 종료. */

    /* 4 시작: 통합 시작 로그(트랜잭션 밖에서 기록 → 이후 롤백되더라도 시작 이력은 보존됨).
               - DESCRIPTION 은 'SNRO=<코드>; TARGET=ALL' 형식으로 통일(500자 제한). */
    BEGIN
        SET @LOG_DT  = GETDATE();
        SET @LOG_CNT = 0;
        SET @LOG_DESC = LEFT(CONCAT(N'SNRO=', @SNRO_CD, N'; TARGET=', N'ALL'), 500);
        EXEC dbo.PR_SCM_SYS_LOG_BATCH                                            -- 통합 START 로그 기록(공통 배치 로그 proc)
             @p_program_name = N'PR_SCP_OPMZ_APPLY_SNRO',
             @p_log_type     = N'START',
             @p_log_count    = @LOG_CNT,
             @p_log_message  = N'PR_SCP_OPMZ_APPLY_SNRO 시작',
             @p_description  = @LOG_DESC,
             @p_event_date   = @LOG_DT;
    END;
    /* 4 종료. */

    BEGIN TRY
        /* 5 시작: 하나의 트랜잭션으로 4개 항목을 묶는다(전부 성공 또는 전부 롤백).
                   각 자식 proc은 @@TRANCOUNT>0 이므로 자체 커밋/롤백하지 않고 이 트랜잭션에 합류한다.
                   호출 순서는 NO_WORK → DDLY_CAPA → RAMP_UP → SOP_EOP 로 고정이며,
                   모든 자식은 @RETURN_RESULT_YN=N'N' 으로 호출해 자식 결과셋을 억제한다. */
        IF @START_TRAN = 1 BEGIN TRAN;                                           -- 소유자일 때만 트랜잭션 시작

        /* 5-1: NO WORK (비조업)    */
        EXEC dbo.PR_SCP_OPMZ_APPLY_NO_WORK   @SNRO_CD=@SNRO_CD, @USER_ID=@uid, @OPT_KEY_VAL_ID=@OPT_KEY_VAL_ID, @RETURN_RESULT_YN=N'N';   -- 1) 비조업 반영
        /* 5-2: 코팅증속 (DDLY_CAPA) */
        EXEC dbo.PR_SCP_OPMZ_APPLY_DDLY_CAPA @SNRO_CD=@SNRO_CD, @USER_ID=@uid, @OPT_KEY_VAL_ID=@OPT_KEY_VAL_ID, @RETURN_RESULT_YN=N'N';   -- 2) 코팅증속 반영
        /* 5-3: 램프업 (RAMP_UP)     */
        EXEC dbo.PR_SCP_OPMZ_APPLY_RAMP_UP   @SNRO_CD=@SNRO_CD, @USER_ID=@uid, @OPT_KEY_VAL_ID=@OPT_KEY_VAL_ID, @RETURN_RESULT_YN=N'N';   -- 3) 램프업 반영
        /* 5-4: 일정변경 (SOP/EOP)   */
        EXEC dbo.PR_SCP_OPMZ_APPLY_SOP_EOP   @SNRO_CD=@SNRO_CD, @USER_ID=@uid, @OPT_KEY_VAL_ID=@OPT_KEY_VAL_ID, @RETURN_RESULT_YN=N'N';   -- 4) 일정변경(SOP/EOP) 반영
        /* 5 종료: 4개 항목 반영 완료. */

        /* 6 시작: 단계별 결과 반환(이 실행에서 자식들이 남긴 END(완료) 로그를 그대로 보여줌, 커밋 전 세션 내 가시).
                   - 대상 PROGRAM_NAME = 자식 4종, LOG_TYPE = 'END' 만.
                   - EVENT_DATE >= @t0 및 DESCRIPTION LIKE 'SNRO=<코드>;%' 로 '이번 실행분'만 골라낸다.
                   - EVENT_DATE, PROGRAM_NAME 순으로 정렬해 반영 순서에 가깝게 보여준다. */
        IF @RETURN_RESULT_YN = N'Y'
            SELECT PROGRAM_NAME, LOG_TYPE AS STATUS, LOG_COUNT, LOG_MESSAGE, DESCRIPTION   -- 단계별 END(완료) 로그 결과셋 반환
            FROM   dbo.SCM_SYS_LOG_BATCH
            WHERE  PROGRAM_NAME IN (N'PR_SCP_OPMZ_APPLY_NO_WORK',
                                    N'PR_SCP_OPMZ_APPLY_DDLY_CAPA',
                                    N'PR_SCP_OPMZ_APPLY_RAMP_UP',
                                    N'PR_SCP_OPMZ_APPLY_SOP_EOP')
              AND  LOG_TYPE = N'END'
              AND  EVENT_DATE >= @t0
              AND  DESCRIPTION LIKE N'SNRO=' + @SNRO_CD + N';%'
            ORDER BY EVENT_DATE, PROGRAM_NAME;
        /* 6 종료. */

        /* 7 시작: 커밋(트랜잭션 소유자일 때만). */
        IF @START_TRAN = 1 COMMIT;                                              -- 소유자일 때만 커밋(합류 호출이면 부모가 커밋)
        /* 7 종료. */

        /* 8 시작: 통합 성공 로그(4개 항목 모두 반영·커밋 완료 후 기록). */
        BEGIN
            SET @LOG_DT  = GETDATE();
            SET @LOG_CNT = 0;
            SET @LOG_DESC = LEFT(CONCAT(N'SNRO=', @SNRO_CD, N'; TARGET=', N'ALL'), 500);
            EXEC dbo.PR_SCM_SYS_LOG_BATCH                                       -- 통합 SUCCESS 로그 기록
                 @p_program_name = N'PR_SCP_OPMZ_APPLY_SNRO',
                 @p_log_type     = N'END',
                 @p_log_count    = @LOG_CNT,
                 @p_log_message  = N'PR_SCP_OPMZ_APPLY_SNRO 완료',
                 @p_description  = @LOG_DESC,
                 @p_event_date   = @LOG_DT;
        END;
        /* 8 종료. */
    END TRY
    BEGIN CATCH
        /* 9 시작: 오류 시 전체 롤백 → 통합 오류 로그 → 예외 재전파.
                   - 트랜잭션 소유자이고 트랜잭션이 유효(XACT_STATE<>0)할 때만 ROLLBACK 수행.
                   - ERROR_MESSAGE() 를 보존해 통합 ERROR 로그로 남긴 뒤 THROW 로 원 예외를 재전파.
                   - 중첩 호출(합류)인 경우 롤백은 부모(소유자)가 담당하므로 여기서는 로그·재전파만 함. */
        IF @START_TRAN = 1 AND XACT_STATE() <> 0
            ROLLBACK;                                                           -- 소유자일 때만 전체 롤백
        SET @ERR_MSG = ERROR_MESSAGE();
        BEGIN
            SET @LOG_DT  = GETDATE();
            SET @LOG_CNT = 0;
            SET @LOG_DESC = LEFT(CONCAT(N'SNRO=', @SNRO_CD, N'; TARGET=', N'ALL'), 500);
            EXEC dbo.PR_SCM_SYS_LOG_BATCH                                       -- 통합 ERROR 로그 기록(오류 메시지 보존)
                 @p_program_name = N'PR_SCP_OPMZ_APPLY_SNRO',
                 @p_log_type     = N'ERROR',
                 @p_log_count    = @LOG_CNT,
                 @p_log_message  = @ERR_MSG,
                 @p_description  = @LOG_DESC,
                 @p_event_date   = @LOG_DT;
        END;
        THROW;                                                                  -- 원 예외 재전파(호출자에게 실패 전파)
        /* 9 종료. */
    END CATCH;
END
