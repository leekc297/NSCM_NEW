FUNCTION FN_GET_NORMAL_STRING2
(
    P_ORI  IN CLOB
)
RETURN CLOB
/* ============================================================
 * Program ID   : FN_GET_NORMAL_STRING
 * Description  : 문자열을 일반 텍스트 문자열로 치환
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2019.04.25    JYE            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026-07-03    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS

    V_RET CLOB;

BEGIN

    V_RET := REPLACE(P_ORI, 'IFNFTEVDVCA=',      ' SELECT ');
    V_RET := REPLACE(V_RET, 'IFNFTEVDVA==',      ' SELECT');
    V_RET := REPLACE(V_RET, 'U0VMRUNUIA==',      'SELECT ');
    V_RET := REPLACE(V_RET, 'IEZST00g',          ' FROM ');
    V_RET := REPLACE(V_RET, 'lJPTSA=',           'FROM ');
    V_RET := REPLACE(V_RET, 'IEZST00=',          ' FROM');
    V_RET := REPLACE(V_RET, 'IFdIRVJFIA==',      ' WHERE ');
    V_RET := REPLACE(V_RET, 'V0hFUkUg',          'WHERE  ');
    V_RET := REPLACE(V_RET, 'IFdIRVJF',          ' WHERE');
    V_RET := REPLACE(V_RET, 'IFVQREFURSA=',      ' UPDATE ');
    V_RET := REPLACE(V_RET, 'VVBEQVRFIA==',      'UPDATE ');
    V_RET := REPLACE(V_RET, 'IFVQREFURQ==',      ' UPDATE');
    V_RET := REPLACE(V_RET, 'IEpPSU4g',          ' JOIN ');
    V_RET := REPLACE(V_RET, 'IEFORCA=',          ' AND ');
    V_RET := REPLACE(V_RET, 'IEdST1VQIEJZIA==',  ' GROUP BY ');
    V_RET := REPLACE(V_RET, 'R1JPVVAgQlkg',      'GROUP BY ');
    V_RET := REPLACE(V_RET, 'IFVOSU9OIEFMTCA=',  ' UNION ALL ');
    V_RET := REPLACE(V_RET, 'VU5JT04gQUxMIA==',  'UNION ALL ');
    V_RET := REPLACE(V_RET, 'IFVOSU9OIEFMTA==',  ' UNION ALL');
    V_RET := REPLACE(V_RET, 'IFVOSU9OIA==',      ' UNION ');
    V_RET := REPLACE(V_RET, 'VU5JT04g',          'UNION ');
    V_RET := REPLACE(V_RET, 'IFVOSU9O',          ' UNION');
    V_RET := REPLACE(V_RET, 'IE9SREVSIEJZIA==',  ' ORDER BY ');
    V_RET := REPLACE(V_RET, 'T1JERVIgQlkg',      'ORDER BY ');
    V_RET := REPLACE(V_RET, 'IE9SREVSIEJZ',      ' ORDER BY');

    RETURN V_RET;

END;