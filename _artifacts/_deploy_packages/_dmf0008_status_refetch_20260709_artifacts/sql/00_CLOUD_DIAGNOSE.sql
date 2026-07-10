-- =====================================================================================
-- DMF0008 Status Update — Last Update Start 미갱신 클라우드 진단 (적용 전 실행)
-- 조회 체인: FE → DMF0008_GET_UPDATE_HISTORY → DMF0000_GET_UPDATE_HISTORY
--            → SCM_SYS_LOG_BATCH (PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS', LOG_TYPE='START'/'END')
-- =====================================================================================

-- 1. 클라우드 실행 SP 가 배치 로그를 기록하는 버전인지 (0 이면 구버전 = 원인 확정)
SELECT COUNT(*) AS LOG_CALL_CNT
  FROM ALL_SOURCE
 WHERE NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
   AND UPPER(TEXT) LIKE '%PR_SCM_SYS_LOG_BATCH%';

-- 2. 실제 로그 적재 현황 (Status Update 실행 직후 START 최신시각이 증가해야 정상)
SELECT LOG_TYPE, COUNT(*) AS CNT, TO_CHAR(MAX(LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') AS LAST_AT
  FROM SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
 GROUP BY LOG_TYPE;

-- 3. PROGRAM_NAME 변형 기록 여부 (PKG 멤버 배포 등으로 이름이 다르게 쌓이는 경우)
SELECT DISTINCT PROGRAM_NAME
  FROM SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME LIKE '%CALLOFF%';

-- 4. 조회 SP 2종 존재/버전 확인 (DMF0008_GET_UPDATE_HISTORY 는 DMF0000 위임 wrapper 여야 함)
SELECT NAME, TYPE, COUNT(*) AS SRC_LINES
  FROM ALL_SOURCE
 WHERE NAME IN ('DMF0008_GET_UPDATE_HISTORY', 'DMF0000_GET_UPDATE_HISTORY')
 GROUP BY NAME, TYPE;

-- 5. 공용 로그 SP 존재 확인 (없으면 01 적용 시 컴파일 오류 — 선행 이관 필요)
SELECT OBJECT_NAME, STATUS FROM ALL_OBJECTS WHERE OBJECT_NAME = 'PR_SCM_SYS_LOG_BATCH';
