FUNCTION           "FN_GET_ITEM_PROD_OP" 
      (
       P_DIVISION_ID      VARCHAR2
     , P_OPERATION_GROUP  VARCHAR2
     , P_ITEM_ID          VARCHAR2
       )
       RETURN VARCHAR2
AS
/****************************************************************************
  * FUNCTION NAME : FN_GET_ITEM_PROD_OP
  * DESCRIPTION   : ITEM_ID_ASSY 로 ITEM_PROD 찾기
  * INPUT         : P_DIVISION_ID,P_ITEM_ID
  * OUTPUT        : ITEM_PROD
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2023-08-02   vadabi3        INITIAL
  * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
  ****************************************************************************/

   V_X_ITEM_ID_PROD VARCHAR2(150 CHAR);

BEGIN

   /* CELL, PaCK, 전극 중 CELL일 경우만 체크 */
   IF (P_OPERATION_GROUP != 'A') THEN
      RETURN P_ITEM_ID;
   END IF;

   /* VALID_YN 이 조건에 없어 Multi row 리턴 될 수 있어 Top 1 Return */
   /* 20230804 값이 Null 인 경우 입력 받은 값 리턴 */
   BEGIN
      SELECT ITEM_ID_PROD
        INTO V_X_ITEM_ID_PROD
        FROM (SELECT NVL(ITEM_ID_PROD, P_ITEM_ID) AS ITEM_ID_PROD
                FROM SCP_MST_CELL_PROD_ASSY_MAP
               WHERE 1 = 1
                 AND DIVISION_ID  = P_DIVISION_ID
                 AND ITEM_ID_ASSY = P_ITEM_ID
               ORDER BY NVL(ITEM_ID_PROD, P_ITEM_ID) DESC)
       WHERE ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         V_X_ITEM_ID_PROD := NULL;
   END;

   IF (V_X_ITEM_ID_PROD IS NULL) THEN
      V_X_ITEM_ID_PROD := P_ITEM_ID;
   END IF;

   RETURN V_X_ITEM_ID_PROD;

END;