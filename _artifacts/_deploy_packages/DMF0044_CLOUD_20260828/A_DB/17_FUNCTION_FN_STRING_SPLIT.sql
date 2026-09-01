CREATE OR REPLACE FUNCTION           "FN_STRING_SPLIT"
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
    IF P_STR IS NULL THEN
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
/
