# 사내오라클(ZIOUI1) 적용 기록 — 재고 뷰 SEQ 변환 가드 (2026-11-06)

| 항목 | 값 |
|---|---|
| 대상 DB | 59.19.252.148:2521/ZIOUI1 · SERVER_HOST=localhost · 접속 system(CURRENT_SCHEMA=SCM_MGR) |
| 발견 경로 | W8-B 차등 검증(diff_verify SCP0016 · versionNo SP_W_20260615) → `PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL` fetch 시 ORA-01722/ORA-03302 값 `20260615_40_18650_004_S005` · 사용자 판정 2-c 보완대상 |
| 원인(실측) | `SCP_PLN_SALES_ONHAND_V`·`SCP_OPT_PLANT_ONHAND_V` 의 `TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$'))` — 구포맷 PLAN_ID 가드(`REGEXP_LIKE(… M.PLAN_ID …,'^[0-9]+$')`)는 M 에만 있고 A 의 TO_NUMBER 는 평가 순서에 따라 먼저 실행. `SELECT COUNT(*) FROM SCP_PLN_SALES_ONHAND_V WHERE SEQ=…` 만으로 재현(22:1x). FG_C·GT·BOD 의 BOD_ID/SEQ 타입은 원인 아님(전부 확인) |
| 변경 | `TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$'))` → `TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$') DEFAULT NULL ON CONVERSION ERROR)` + 마커 주석 · SALES 1곳 · PLANT 2곳(ID 문자열 조합 145행 · SEQ CAST 150행) |
| 절차 | hook #152: DBMS_METADATA 로 착수 기준본 조회·백업(`00_BACKUP/*.ASIS.sql` · LAST_DDL SALES 2026-10-27 13:37:07 / PLANT 2026-10-29 18:20:30) → OLD 매칭 횟수 assert → FRESH-GATE 재조회 일치 → CREATE OR REPLACE |
| 적용 시각 | SALES 2026-11-06 22:23:44 · PLANT 2026-11-06 22:23:45 (ALL_OBJECTS.LAST_DDL_TIME) |
| 검증 | STATUS VALID · ALL_ERRORS 0 · 적용본 == DB 원문 · 의존 16객체(FN_GET_SCP_ANL_* 6 · PKG_SCP0010 · PR_SCP_ANL_PSI_* 5 · PKG_SCP0016 등) ALTER COMPILE → INVALID 0 · 오류 값 질의 두 뷰 모두 오류 없음 · `golden.run_tobe` 버전 0615 → O_RC1 454행(AS-IS 454행) |
| 파일 | `apply_view_seq_guard.py`(적용·검증 스크립트) · `01_SCP_PLN_SALES_ONHAND_V.sql` · `01_SCP_OPT_PLANT_ONHAND_V.sql`(SOURCE-FRESH 스탬프) · `00_BACKUP/` 원복본 |
| 원복 | `00_BACKUP/<view>.ASIS.sql` 실행 |
| 클라우드 | `_artifacts/_deploy_packages/SCP0016_CLOUD_DB_MOD_20261106_2230/`(22:30 생성 · 사내 리허설 OK · 경고 0) — `A_DB/25_SHARED_SCP_PLN_SALES_ONHAND_V_SEQGUARD_SCP0016.sql` · `A_DB/25_SHARED_SCP_OPT_PLANT_ONHAND_V_SEQGUARD_SCP0016.sql`(SOURCE-FRESH FETCHED=2026-11-06 22:23). 원본 패치 `Doc/gen/SCP0016/*_SEQGUARD_SCP0016.sql`. 첫 빌드(…_2225)는 PKG_SCP0016 이 두 뷰를 동적 SQL 문자열 안에서만 참조해 ALL_DEPENDENCIES 에 없어 25_SHARED 누락 → 폐기 · `tools/CloudPkg/cloud_pkg.py` collect_db 에 코드 원문 식별자 토큰 ↔ ALL_OBJECTS 대조(DYN=Y) 추가 후 재빌드 |
| 부수 효과 | README '공용 객체 변경 감지 FN_GET_SCP_ANL_BOH_QTY LAST_DDL 22:23:46' = 위 의존 16객체 ALTER COMPILE 의 결과(소스 변경 없음 · 패치 불필요) |
