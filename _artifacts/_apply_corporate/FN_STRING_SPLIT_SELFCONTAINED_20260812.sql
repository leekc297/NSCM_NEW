-- FN_STRING_SPLIT_SELFCONTAINED_20260812.sql — 클라우드 자급 (TeambyDivision 등 콤보/SP 가 사용)
-- 사내 라이브 원문 덤프. 기존재 시 CREATE OR REPLACE 라 무해(멱등).

CREATE OR REPLACE TYPE "SCM_MGR"."T_TOKEN_ROW" AS OBJECT (
    token VARCHAR2(4000)
)
/
CREATE OR REPLACE TYPE "SCM_MGR"."T_TOKEN_TAB" AS TABLE OF t_token_row
/
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

-- VERIFY (기대: FUNCTION VALID + 3행 분리)
SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='FN_STRING_SPLIT';
SELECT TOKEN FROM TABLE(SCM_MGR.FN_STRING_SPLIT('A,B,C', ','));
