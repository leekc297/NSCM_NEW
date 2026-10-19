    ELSE
        --[{MARK}] 81 저장 후속처리 — 구 게이트는 81 을 통째로 skip 해 아래 3종이 누락돼 있었다(사용자 확인 2026-09-30).
        --  기준: AS-IS DMF0003_SAVE_MKT_FCST(81 정본) 저장 후속 + TO-BE 가 81 에 연 SCM_FCST 는 AS-IS 40 의 Sales Plan 동기화.
        --  40 전파 PR(P_PR_DM_PLN_CFM_TO_MKT_FCST)은 내부 division '40' 고정이라 재사용 불가 → 81 전용 순서로 직접 호출.
        --  1단계(저장 본체) 원자 확정 경계 = 40 과 동일 (BALANCE_CREATE 가 내부 커밋).
        COMMIT;
        DECLARE
            v_81_bal_rc     SYS_REFCURSOR;
            v_81_start      VARCHAR2(8 CHAR) := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');  -- 당주 월요일
            n_81_cnt        NUMBER;
        BEGIN
            -- ① RMA → RTF_SYS_RP = MKT_FCST (AS-IS DMF0003 L2499~2591 / TO-BE PKG_DMF0003 L12055~12114 1:1 — 결과표 = GT_PRDM1_T_MAIN)
            DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
            WHERE  MEASURE  = 'RTF_SYS_RP'
              AND  YYYYMMDD >= v_81_start
              AND  EXISTS (
                       SELECT 1
                       FROM   SCM_MGR.GT_PRDM1_T_MAIN RSLT
                       JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                         ON   RSLT.DIVISION_ID = ITEM.DIVISION_ID
                        AND   RSLT.ITEM_ID     = ITEM.ITEM_ID
                       WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = RSLT.DIVISION_ID
                         AND  DM_PLN_MKT_FCST.PROJECT_CODE  = RSLT.PROJECT_CODE
                         AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = RSLT.SCM_SITE_ID
                         AND  DM_PLN_MKT_FCST.ITEM_ID       = RSLT.ITEM_ID
                         AND  DM_PLN_MKT_FCST.DOM_EXP       = RSLT.DOM_EXP
                         AND  DM_PLN_MKT_FCST.FCST_TYPE     = RSLT.FCST_TYPE
                         AND  DM_PLN_MKT_FCST.INCOTERMS     = RSLT.INCOTERMS
                         AND  DM_PLN_MKT_FCST.PLANT_SITE_ID = RSLT.PLANT_SITE_ID
                         AND  DM_PLN_MKT_FCST.YYYYMMDD     >= v_81_start
                         AND  ITEM.ACTIVE_FLAG  = 'Y'
                         AND  RSLT.FCST_TYPE    = 'RMA'
                   );

            INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
            , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
            , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
            , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT NVL(A.DIVISION_ID, '-'), NVL(A.PROJECT_CODE, '-'), NVL(A.SCM_SITE_ID, '-'), NVL(A.ITEM_ID, '-'), NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-')
                 , NVL(A.INCOTERMS, '-')
                 , 'RTF_SYS_RP'
                 , NVL(A.PLANT_SITE_ID, '-'), NVL(A.YYYYMMDD, '-'), A.QTY
                 , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
                 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
                 , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
            FROM   SCM_MGR.DM_PLN_MKT_FCST A
            WHERE  A.MEASURE   = 'MKT_FCST'
              AND  A.YYYYMMDD >= v_81_start
              AND  EXISTS (
                       SELECT 1
                       FROM   SCM_MGR.GT_PRDM1_T_MAIN RSLT
                       JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                         ON   RSLT.DIVISION_ID = ITEM.DIVISION_ID
                        AND   RSLT.ITEM_ID     = ITEM.ITEM_ID
                       WHERE  A.DIVISION_ID   = RSLT.DIVISION_ID
                         AND  A.PROJECT_CODE  = RSLT.PROJECT_CODE
                         AND  A.SCM_SITE_ID   = RSLT.SCM_SITE_ID
                         AND  A.ITEM_ID       = RSLT.ITEM_ID
                         AND  A.DOM_EXP       = RSLT.DOM_EXP
                         AND  A.FCST_TYPE     = RSLT.FCST_TYPE
                         AND  A.INCOTERMS     = RSLT.INCOTERMS
                         AND  A.PLANT_SITE_ID = RSLT.PLANT_SITE_ID
                         AND  ITEM.ACTIVE_FLAG = 'Y'
                         AND  RSLT.FCST_TYPE   = 'RMA'
                   );
            COMMIT;

            -- ② BALANCE_CREATE 'CALL' (AS-IS DMF0003 L2595~2634: 저장 키 전부 · CELL_PROD '-' · VMI_YN 'N' 초기값)
            --    피호출측 CALL 모드는 GT_PRDM_SEND_TARGET_DATA 를 읽는다 (PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE L1375~1380).
            DELETE FROM SCM_MGR.GT_PRDM_SEND_TARGET_DATA;
            INSERT INTO SCM_MGR.GT_PRDM_SEND_TARGET_DATA
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, VMI_YN )
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, '-', 'N'
            FROM   SCM_MGR.GT_PRDM1_T_MAIN
            GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID;
            n_81_cnt := SQL%ROWCOUNT;
            IF n_81_cnt > 0 THEN
                SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(p_division_id => V_DIVISION_ID, p_plan_id => 'CALL', o_result_cursor => v_81_bal_rc);
                IF v_81_bal_rc%ISOPEN THEN CLOSE v_81_bal_rc; END IF;
            END IF;

            -- ③ Sales Plan 동기화 — 40 전파 PR L15721~15771 동형 (81 키 = PROJECT_CODE, 81 은 END_CUSTOMER '-')
            DELETE FROM SCM_MGR.GT_PRDM_RESULTS;
            INSERT INTO SCM_MGR.GT_PRDM_RESULTS
            ( V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD, V_CREATED_BY )
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, v_created_by
            FROM   SCM_MGR.GT_PRDM1_T_MAIN
            WHERE  MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_In_Req', 'LOC', 'KRW', 'USD')
              AND  YYYYMMDD >= v_81_start
            GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD;
            n_81_cnt := SQL%ROWCOUNT;
            IF n_81_cnt > 0 THEN
                SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE;
            END IF;
            DELETE FROM SCM_MGR.GT_PRDM_RESULTS;
            DELETE FROM SCM_MGR.GT_PRDM_SEND_TARGET_DATA;
        END;
