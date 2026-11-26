/* 되돌리기 : 백업 테이블의 행을 다시 넣음. 같은 행이 이미 있으면 넣지 않음 */
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;

INSERT INTO SSP_MST_DELEGATE
SELECT B.*
  FROM SSP_MST_DELEGATE_BAK20261125_SLASH B
 WHERE NOT EXISTS (SELECT 1
                     FROM SSP_MST_DELEGATE A
                    WHERE A.DIVISION_ID  = B.DIVISION_ID
                      AND A.USER_ID      = B.USER_ID
                      AND A.DELEGATEE_ID = B.DELEGATEE_ID
                      AND A.FROM_DATE    = B.FROM_DATE
                      AND A.TO_DATE      = B.TO_DATE);

COMMIT;
