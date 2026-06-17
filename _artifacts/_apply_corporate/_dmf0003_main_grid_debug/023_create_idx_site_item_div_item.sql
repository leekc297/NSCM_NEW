-- DMF0003 메인 grid SP 의 GT_GGET_SITE_ITEM_ALL INSERT bottleneck (line 959, 22095초 누적) 보강.
--   SCM_MST_SITE_ITEM F (109K row) → GT_GGET_ITEM_SINGLE_V T2 JOIN 의 access path 개선.
--   JOIN ON F.DIVISION_ID=T2.DIVISION_ID AND F.ITEM_ID=T2.ITEM_ID
--   기존 IDX02 = (ITEM_ID, DIV) 역순 → 옵티마이저 leading DIV filter 활용 제한.
--
-- 신규 IDX06 = (DIVISION_ID, ITEM_ID) — SP NL/Hash join access path 최적화.
-- ONLINE 옵션: 사내 운영 환경 무중단 생성 (다른 session DML 영향 최소).

CREATE INDEX SCM_MGR.IDX06_SCM_MST_SITE_ITEM
  ON SCM_MGR.SCM_MST_SITE_ITEM (DIVISION_ID, ITEM_ID)
  ONLINE;

-- 통계 갱신 (옵티마이저가 신규 인덱스 인식)
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(
    ownname        => 'SCM_MGR',
    tabname        => 'SCM_MST_SITE_ITEM',
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
    method_opt     => 'FOR ALL INDEXED COLUMNS SIZE AUTO',
    cascade        => TRUE,
    no_invalidate  => FALSE
  );
END;
/
