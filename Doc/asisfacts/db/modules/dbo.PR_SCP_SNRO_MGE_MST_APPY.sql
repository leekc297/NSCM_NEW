
/* ---- 3) 이력 프로시저 — 삭제 내역을 함께 남긴다 ------------------------------------------------ */
CREATE   PROCEDURE dbo.PR_SCP_SNRO_MGE_MST_APPY
    @p_scp_snro_id   NVARCHAR(50),
    @p_smul_plan_id  NVARCHAR(40)  = NULL,
    @p_appy_user_id  NVARCHAR(200),
    @p_tot_appy_cnt  INT,
    @p_rslt_json_ctn NVARCHAR(MAX) = NULL
AS
BEGIN
    /*  기준정보 반영 이력 한 행을 남긴다 (GitLab #11 / #27).

        호출 시점 — 앱이 PR_SCP_OPMZ_APPLY_SNRO 를 성공으로 받은 직후. 반영 프로시저가 자기
        트랜잭션을 이미 커밋한 뒤이므로 이 기록은 별개 트랜잭션이다. 여기서 실패해도 반영은
        유효하다 — 앱이 로그만 남기고 사용자에게는 반영 성공을 알린다.

        갱신하지 않는다. 반영할 때마다 새 행을 쌓는다 — 그래야 "몇 번 반영했는가" 가 남는다.

        결과셋을 돌려주지 않는다. HIS_SEQ 를 쓰는 곳이 없고, 결과셋이 있으면 호출부가
        executeUpdate 로 부를 수 없다(JDBC 가 "결과셋이 생겼다" 고 거절한다).

        2026-09-18(#27) — 변경 전 기준정보를 **물리 삭제**로 바꾸면서, 지운 내역을 여기 함께
        남긴다. 본체 DB 의 행 단위 로그는 운영에서 한 달 뒤 삭제되기 때문이다.  */
    SET NOCOUNT ON;

    IF NULLIF(LTRIM(RTRIM(@p_scp_snro_id)), N'') IS NULL
        THROW 51050, 'SCP_SNRO_ID IS REQUIRED.', 1;
    IF NULLIF(LTRIM(RTRIM(@p_appy_user_id)), N'') IS NULL
        THROW 51051, 'APPY_USER_ID IS REQUIRED.', 1;

    DECLARE @now DATETIME = GETDATE();

    /* ── 이번 반영 구간의 삭제 내역 수집 ─────────────────────────────────────────────────────────
       구간 시작 = 그 시나리오의 PR_SCP_OPMZ_APPLY_SNRO START 로그 중 최신 시각.
       로그 테이블이 없거나(시노님 미생성) 읽기에 실패해도 이력 기록 자체는 계속한다 —
       반영은 이미 끝났고, 이력이 없다고 사용자에게 실패를 알리면 안 된다. */
    DECLARE @del_cnt INT = NULL, @del_json NVARCHAR(MAX) = NULL;

    BEGIN TRY
        DECLARE @t0 DATETIME = (
            SELECT MAX(EVENT_DATE) FROM dbo.SCM_SYS_LOG_BATCH_SN
             WHERE PROGRAM_NAME = N'PR_SCP_OPMZ_APPLY_SNRO'
               AND LOG_TYPE     = N'START'
               AND DESCRIPTION LIKE N'SNRO=' + @p_scp_snro_id + N';%');

        IF @t0 IS NOT NULL
        BEGIN
            SELECT @del_cnt = COUNT(*)
              FROM dbo.SCM_SYS_LOG_BATCH_SN
             WHERE ATTRIBUTE2 = N'DELETE' AND ATTRIBUTE3 = @p_scp_snro_id
               AND CREATION_DATE >= @t0;

            IF @del_cnt > 0
                SELECT @del_json = N'[' + STUFF((
                    SELECT TOP (500) N',{"t":"' + ISNULL(x.ATTRIBUTE1, N'') +
                           N'","k":"' + REPLACE(ISNULL(x.ATTRIBUTE5, N''), N'"', N'') +
                           N'","b":"' + REPLACE(ISNULL(x.ATTRIBUTE6, N''), N'"', N'') +
                           N'","c":"' + REPLACE(ISNULL(x.ATTRIBUTE4, N''), N'"', N'') + N'"}'
                      FROM dbo.SCM_SYS_LOG_BATCH_SN x
                     WHERE x.ATTRIBUTE2 = N'DELETE' AND x.ATTRIBUTE3 = @p_scp_snro_id
                       AND x.CREATION_DATE >= @t0
                     ORDER BY x.ATTRIBUTE1, x.ATTRIBUTE5
                       FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'), 1, 1, N'') + N']';
        END
    END TRY
    BEGIN CATCH
        SET @del_cnt = NULL;   -- 수집 실패는 이력 기록을 막지 않는다
        SET @del_json = NULL;
    END CATCH

    INSERT INTO dbo.SCP_SNRO_PLAN_MST_APPY_H
        (HIS_CRT_DTM, SCP_SNRO_ID, SMUL_PLAN_ID, APPY_DTM, APPY_USER_ID,
         TOT_APPY_CNT, RSLT_JSON_CTN, DEL_CNT, DEL_JSON_CTN,
         DATA_INS_USER_ID, DATA_INS_DTM, DATA_UPD_USER_ID, DATA_UPD_DTM)
    VALUES
        (@now, @p_scp_snro_id, @p_smul_plan_id, @now, @p_appy_user_id,
         ISNULL(@p_tot_appy_cnt, 0), @p_rslt_json_ctn, @del_cnt, @del_json,
         @p_appy_user_id, @now, @p_appy_user_id, @now);
END
