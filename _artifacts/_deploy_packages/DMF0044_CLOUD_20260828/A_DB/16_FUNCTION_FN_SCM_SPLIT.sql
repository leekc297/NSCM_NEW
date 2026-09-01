CREATE OR REPLACE FUNCTION FN_SCM_SPLIT

(
    P_INPUT_DATA IN VARCHAR2
  , P_NODE_NO    IN NUMBER
  , P_DELIMITER  IN VARCHAR2 DEFAULT ','
) RETURN VARCHAR2
/*
 * Program ID   : FN_SCM_SPLIT
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.12.26  vardadbi       Initial Release NERP 구축 프로젝트
 * 2026.03.06   kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
*/
IS
    V_INPUT_LENGTH  NUMBER := 0;
    V_SPLIT_LENGTH  NUMBER := 0;
    V_START_LENGTH  NUMBER := 1;
    V_LAST_LENGTH   NUMBER := 1;
    V_RETURN        VARCHAR2(32767 CHAR);
    V_DELIMITER     VARCHAR2(100 CHAR);
    V_I             NUMBER := 1;
    V_TEMP_POS      NUMBER;
BEGIN

    IF (P_DELIMITER IS NULL OR P_DELIMITER = '') THEN
        V_DELIMITER := ',';
    ELSE
        V_DELIMITER := P_DELIMITER;
    END IF;

    V_INPUT_LENGTH := LENGTHB(P_INPUT_DATA);
    V_SPLIT_LENGTH := LENGTH(V_DELIMITER);


    IF (V_INPUT_LENGTH = 0 OR P_INPUT_DATA IS NULL) THEN
        RETURN NULL;
    END IF;


    IF (P_NODE_NO = 1) THEN
        V_START_LENGTH := 1;
    ELSE

        IF INSTR(P_INPUT_DATA, V_DELIMITER, 1) = 0 THEN
            RETURN NULL;
        END IF;

        V_START_LENGTH := 1;
        V_I := 1;


        WHILE (V_I < P_NODE_NO) LOOP
            V_TEMP_POS := INSTR(P_INPUT_DATA, V_DELIMITER, V_START_LENGTH);

            IF V_TEMP_POS = 0 THEN
                RETURN NULL;
            END IF;

            V_START_LENGTH := V_TEMP_POS + V_SPLIT_LENGTH;
            V_I := V_I + 1;
        END LOOP;
    END IF;


    V_LAST_LENGTH := INSTR(P_INPUT_DATA, V_DELIMITER, V_START_LENGTH);


    IF (V_LAST_LENGTH = 0) THEN
        V_LAST_LENGTH := V_INPUT_LENGTH + 1;
    END IF;


    V_RETURN := SUBSTR(P_INPUT_DATA, V_START_LENGTH, V_LAST_LENGTH - V_START_LENGTH);

    RETURN V_RETURN;

EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END FN_SCM_SPLIT;
/
