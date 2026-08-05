FUNCTION FN_SPLITSTRING
(
    P_STRING     IN VARCHAR2
  , P_DELIMITER  IN VARCHAR2
)
RETURN T_FN_SPLITSTRING_TAB PIPELINED
/*
 * Program ID   : FN_SplitString
 * Description  : 기존 fn_scm_split 함수 속도 문제 때문에 TABLE 변수 FN_SplitString 생성함.
 * 실행 예제    : SELECT * FROM dbo.FN_SplitString('AJRJR0101A::acer::acer_TW_BAL~A01::E::MPS::NF::20180824::NOPLANT','::')
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.08.22  KTH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020.03.12  KTH       @Stringing 타입 변경 NVARCHAR(4000) --> NVARCHAR(MAX)
 * 2024.08.02  KSK       MAXRECUSION 횟수제한(최대 100건)을 해제하기 위하여 로직 변경
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
*/
AS

    V_IDX        PLS_INTEGER;
    V_FOUND_IDX  PLS_INTEGER;
    V_STRING     VARCHAR2(32767) := P_STRING;
    V_ID         PLS_INTEGER := 0;

BEGIN

    V_IDX       := 1;
    V_FOUND_IDX := INSTR(V_STRING, P_DELIMITER);

    WHILE (V_FOUND_IDX > 0) LOOP

        V_ID := V_ID + 1;
        PIPE ROW (T_FN_SPLITSTRING_ROW(V_ID, TRIM(SUBSTR(V_STRING, 1, V_FOUND_IDX - 1))));

        V_STRING    := SUBSTR(V_STRING, V_FOUND_IDX + LENGTH(P_DELIMITER));
        V_IDX       := V_IDX + 1;
        V_FOUND_IDX := INSTR(V_STRING, P_DELIMITER);

    END LOOP;

    V_ID := V_ID + 1;
    PIPE ROW (T_FN_SPLITSTRING_ROW(V_ID, TRIM(V_STRING)));

    RETURN;

END;