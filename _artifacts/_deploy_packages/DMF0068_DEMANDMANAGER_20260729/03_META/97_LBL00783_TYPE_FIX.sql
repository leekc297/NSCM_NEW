-- 97_LBL00783_TYPE_FIX.sql — 【SCM_MGR 세션】 LBL00783 의 MSG_TP_CD 오등록 정정 (멱등)
--
-- 결함: `01_MSG.sql` 이 LBL00783 을 `MSG_TP_CD='MSG'` 로 INSERT 했다 (라벨이므로 'LBL' 이어야 함).
--       자매 LBL00774~00782 는 모두 'LBL'. 전수 스윕 결과 접두사↔타입 불일치는 사내 전체에서
--       이 건 + 기존 MSG00018(2026-04-21) 2건뿐이다.
-- 영향: 표시에는 영향 없으나(i18n 은 locales JSON 이 원천), 메시지 관리(SYS0001) 화면의
--       타입 필터·통계에서 라벨이 메시지로 집계된다. 메타 무결성 문제.
-- 대상: 이미 'MSG' 로 적재된 환경(사내·클라우드 모두 해당). `01_MSG.sql` 은 2026-07-30 에 'LBL' 로 정정됨.

-- [백업]
SELECT MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID = 'LBL00783' ORDER BY LANG_CD;

-- [정정] 3행 (KO/EN/CN)
UPDATE SCM_MGR.SCM_ADM_MSG_M
   SET MSG_TP_CD        = 'LBL',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MSG_ID = 'LBL00783'
   AND NVL(MSG_TP_CD, '-') <> 'LBL';
COMMIT;

-- [검증] 3행 모두 'LBL'
SELECT MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID = 'LBL00783' ORDER BY LANG_CD;

-- [전수 재확인] 접두사 ↔ MSG_TP_CD 불일치 스윕 — LBL00783 이 사라져야 한다
--   (MSG_API_* 17건은 API 타입 정상, MSG00018 은 2026-04-21 기존 건으로 본 작업 범위 밖)
SELECT DISTINCT MSG_ID, MSG_TP_CD, TO_CHAR(CREATION_DATE,'YYYY-MM-DD') CRE
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE REGEXP_LIKE(MSG_ID, '^(MSG|LBL|MNU)[0-9]{5}$')
   AND MSG_TP_CD <> SUBSTR(MSG_ID, 1, 3)
 ORDER BY 1;
