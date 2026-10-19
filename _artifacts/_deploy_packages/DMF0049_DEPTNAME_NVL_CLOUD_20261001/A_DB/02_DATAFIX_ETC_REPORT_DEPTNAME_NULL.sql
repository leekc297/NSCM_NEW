-- =====================================================================================================
-- (선택) 기존 NULL 부서명 행 보정 — DM_PLN_SALES_ETC_REPORT_C (멱등 · NULL 행만 · 비파괴)
--   01 적용 이후 저장분은 NULL 이 생기지 않지만, 이미 저장된 NULL 행은 Transfer 검증에 계속 걸린다.
--   산출식 = 01 의 DMF0049 저장 로직과 동일 (DEPARTMENT_ID / DEPT_ID 기준 룩업, 40 + 담당 룩업 없음 = 기타 부서명, 없으면 '-')
--   사내 실측(2026-10-01): 40 사업부 120행 / 3버전 — 사내는 미실행(사용자 결정 대기)
--   실행: QA / DEV 각각 → 00_PRECHECK [3] 으로 사전·사후 건수 대조
-- =====================================================================================================
UPDATE DM_PLN_SALES_ETC_REPORT_C A
   SET A.DEPARTMENT_NAME = NVL(A.DEPARTMENT_NAME,
                           NVL( CASE WHEN A.DIVISION_ID = '40'
                                      AND NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1
                                                       WHERE A.DEPARTMENT_ID = LK1.SEGMENT1
                                                         AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END
                                                         AND LK1.SEGMENT3 = 'Y')
                                     THEN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                            WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT' AND SEGMENT3 = 'Y' AND ATTRIBUTE1 = 'Y' AND ROWNUM = 1)
                                     ELSE (SELECT LK1.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1
                                            WHERE A.DEPARTMENT_ID = LK1.SEGMENT1
                                              AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END
                                              AND LK1.SEGMENT3 = 'Y' AND ROWNUM = 1)
                                END, '-'))
     , A.DEPT_NAME = NVL(A.DEPT_NAME,
                     NVL( CASE WHEN A.DIVISION_ID = '40'
                                AND NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1
                                                 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1
                                                   AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END
                                                   AND LK1.SEGMENT3 = 'Y')
                               THEN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                      WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT' AND SEGMENT3 = 'Y' AND ATTRIBUTE1 = 'Y' AND ROWNUM = 1)
                               ELSE (SELECT LK2.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK2
                                      WHERE A.DEPT_ID = LK2.SEGMENT1
                                        AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END
                                        AND ROWNUM = 1)
                          END, '-'))
 WHERE A.DEPARTMENT_NAME IS NULL OR A.DEPT_NAME IS NULL;

COMMIT;
