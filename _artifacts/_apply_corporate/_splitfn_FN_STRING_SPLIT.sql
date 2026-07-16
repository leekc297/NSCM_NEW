
  CREATE OR REPLACE EDITIONABLE FUNCTION "SCM_MGR"."FN_STRING_SPLIT" 
(
    P_STR   IN VARCHAR2
   ,P_DELIM IN VARCHAR2 DEFAULT ','
)
/*=====================================================================================================================================================
     * Program ID   : FN_STRING_SPLIT
     * Description  : MS SQL의 STRING_SPLIT 대응
     * Program History
     *=====================================================================================================================================================
     *   Date       In Charge      Description
     *=====================================================================================================================================================
     * ChatGPT
     * 2026.02.12   김준규           MS SQL의 STRING_SPLIT 대응 신규생성(with ChatGPT)
    */
 RETURN T_TOKEN_TAB
    PIPELINED IS
    V_START PLS_INTEGER := 1;
    V_END   PLS_INTEGER;
BEGIN
    -- [2026-07-12] 빈/NULL 입력 = 1 빈행 보존 (Oracle ''=NULL → AS-IS MSSQL STRING_SPLIT('')=1행 대응).
    --   LIKE 조인 '%'||NULL||'%' = '%%'(Oracle || NULL 무시) → 전체 매칭. 변환룰 "빈입력 1행보존" 정합.
    IF P_STR IS NULL THEN
        PIPE ROW(T_TOKEN_ROW(NULL));
        RETURN;
    END IF;

    LOOP
        V_END := INSTR(P_STR, P_DELIM, V_START);

        IF V_END = 0 THEN
            PIPE ROW(T_TOKEN_ROW(TRIM(SUBSTR(P_STR, V_START))));
            EXIT;
        ELSE
            PIPE ROW(T_TOKEN_ROW(TRIM(SUBSTR(P_STR, V_START, V_END - V_START))));
            V_START := V_END + LENGTH(P_DELIM);
        END IF;
    END LOOP;

    RETURN;
END;