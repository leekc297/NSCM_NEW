FUNCTION FN_SCP0104_GET_CAPA_VERSION
(
    P_DIVISION_ID   IN VARCHAR2
  , P_YYYYMM        IN VARCHAR2
)
RETURN T_FN_SCP0104_CAPA_VERSION_TAB PIPELINED
/* ============================================================
 * Program ID   : FN_SCP0104_GET_CAPA_VERSION
 * Description  : CAPA 해당 월의 버전 리턴
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2023/10/12    chaan          V1.1.1  PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2  - Initial Release
 * 2026.09.27    ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
 * ============================================================ */
IS

BEGIN

    FOR R IN (SELECT DIVISION_ID
                   , VER_ID
                   , MAX(VER_SEQ)       AS VER_SEQ
                   , MAX(PROG_STAT)     AS PROG_STAT
                FROM SCP_MST_CAPA_VERSION
               WHERE DIVISION_ID = P_DIVISION_ID
                 AND VER_ID      = P_YYYYMM
               GROUP BY DIVISION_ID
                      , VER_ID)
    LOOP

        PIPE ROW (T_FN_SCP0104_CAPA_VERSION_ROW(R.DIVISION_ID, R.VER_ID, R.VER_SEQ, R.PROG_STAT));

    END LOOP;

    RETURN;

END FN_SCP0104_GET_CAPA_VERSION;