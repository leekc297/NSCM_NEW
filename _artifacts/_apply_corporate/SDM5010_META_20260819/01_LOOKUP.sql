-- =====================================================================================
-- SDM5010 Project Master — [01] LOOKUP: SPMS_DPJT_DEVELOP_STATUS 신설 (MASTER 1 + DETAIL 3)
-- 2026-08-19 · 사내 OCGSCMD_P01 실측 기반 · 감사컬럼 'admin' · 멱등(NOT EXISTS)
--
-- [1] 신설 근거
--   - PKG_SDM5010 TAB2 GET 의 DVL 서브쿼리가 LOOKUP_TYPE='SPMS_DPJT_DEVELOP_STATUS'
--     (SEGMENT1=코드, SEGMENT2=명칭) 소비 — 현행 MASTER/DETAIL 0행 실측 (2026-08-19).
--   - SDM1020 _CONTRACT.md 보고분: "lookup 신설 후 DpjtDevelopStatus 콤보 후속 등재 필요".
--   - 시드 3행 = DEV(개발)/PROD(양산)/DROP(Drop) — 2026-08-19 사용자 확정 (임시 시드,
--     운영 확정값은 현업 수령 후 보수 — 사내 내부 보수는 MERGE).
--   - MASTER 행 구조 = 기존 SPMS_* 관례 실측 승계 (SPMS_DPJT_AUTH_STATUS: SEG1='STATUS',
--     SEG2='NAME', SEG3~5='-', LOOKUP_GROUP='SDM', VALID_YN='Y').
--   - DETAIL PK 실측 = (LOOKUP_TYPE, SEGMENT1~5) — SDM1020 08_LOOKUP 실측 승계.
--
-- [2] DPJT_REG_STATUS='MODIFIED' (PKG 원문) 대조 판정 — lookup 이 권위
--   현행 SPMS_DPJT_REG_STATUS VALID_YN='Y' 10행 실측 (2026-08-19):
--     DRAFT(작성중,10) / WRITING(작성중,11) / WAITING(승인대기,20) / COMPLETE(등록완료,30) /
--     REJECT(반려,40) / CHG_REG(변경등록,50) / MODIFYING(변경중,60) / REQ_MOD(변경요청,70) /
--     CHG_COMPLETE(등록완료(변경 후),80) / CHG_REJECT(등록반려,90)
--   → 'MODIFIED' 는 미등재. PKG CONFIRM 의 용처 = "변경요청 승인 후 원본(부모)행의 최종 상태"
--     = CHG_COMPLETE('등록완료(변경 후)') 와 의미 정확 일치 (SDM1020 08_LOOKUP 신설 당시
--     '수정후 등록 완료' 정의로 채번된 코드).
--   → 판정: 의미 중복 — lookup 권위 원칙에 따라 **PKG 쪽을 'CHG_COMPLETE' 로 정합**
--     (02_PKG_SDM5010.sql 마커 [E20260819-SDM5010-REGSTS]). 'MODIFIED' lookup 신설 안 함.
--     부수 근거: 'MODIFIED' 유지 시 TAB2 GET 의 RGS INNER JOIN(VALID='Y') 미매칭으로
--     승인 완료된 원본행이 화면에서 영구 소실된다 (INNER JOIN 소실 결함).
-- =====================================================================================

-- [1-1] MASTER 1행
INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER
  (LOOKUP_TYPE, DESCRIPTION, LOOKUP_GROUP, VALID_YN,
   SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SPMS_DPJT_DEVELOP_STATUS', 'SDM5010 개발 현황 (임시 시드 DEV/PROD/DROP — 2026-08-19 사용자 확정)', 'SDM', 'Y',
       'STATUS', 'NAME', '-', '-', '-',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER X
                    WHERE X.LOOKUP_TYPE = 'SPMS_DPJT_DEVELOP_STATUS');

-- [1-2] DETAIL 3행 (DEV 개발 / PROD 양산 / DROP Drop)
INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN,
   DESCRIPTION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT T.LT, T.S1, T.S2, '-', '-', '-', T.SEQ, 'Y',
       'SDM5010 개발 현황 임시 시드 (2026-08-19)', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'SPMS_DPJT_DEVELOP_STATUS' LT, 'DEV' S1, '개발' S2, 1 SEQ FROM DUAL
    UNION ALL
    SELECT 'SPMS_DPJT_DEVELOP_STATUS', 'PROD', '양산', 2 FROM DUAL
    UNION ALL
    SELECT 'SPMS_DPJT_DEVELOP_STATUS', 'DROP', 'Drop', 3 FROM DUAL
  ) T
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
                    WHERE X.LOOKUP_TYPE = 'SPMS_DPJT_DEVELOP_STATUS' AND X.SEGMENT1 = T.S1);

COMMIT;
