/* 20 (선택·DBA) — 대상 테이블 통계 갱신. 클라우드 10-07 기준 DM_PLN_CFM_MKT_DEMAND_PLAN stale 150%, DM_PLN_MKT_FCST 19%.
 * 매일 DELETE+INSERT 전량 재작성 뒤 야간 자동 통계가 돌기 전에 배치가 먼저 도는 구조라, 배치 직전 시점 갱신이 가장 효과적.
 * 사내 소요: DM_PLN_MKT_FCST 285s · DM_PLN_CFM_MKT_DEMAND_PLAN 161s (degree 4) */
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'DM_PLN_MKT_FCST', cascade => TRUE, degree => 4);
  DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'DM_PLN_CFM_MKT_DEMAND_PLAN', cascade => TRUE, degree => 4);
END;
/
SELECT table_name, num_rows, TO_CHAR(last_analyzed, 'YYYY-MM-DD HH24:MI:SS') FROM all_tables WHERE owner = 'SCM_MGR' AND table_name IN ('DM_PLN_MKT_FCST', 'DM_PLN_CFM_MKT_DEMAND_PLAN');
