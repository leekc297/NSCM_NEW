# APPLIED_OPERATIONS — [E20261026-DMF0082-MKTAMTAUDIT] (사내 ZIOUI1)

| 시각 | 작업 | 대상 | 결과 |
|---|---|---|---|
| 2026-10-26 22:56 | 원문 조회(dry) — 기준 LAST_DDL 2026-10-21 22:47:30 · 17,758줄 | PKG_DMF0082 BODY | 치환 4지점 확인 (DB 무변경) |
| 2026-10-26 23:06~23:46 | 적용 전 실호출 기준값 수집 | GET_MAIN_DATA / _CURRENT (Div 81) | eunah.koo 금액 행 수정 정보 0/4,154 — 증상 재현 · Current+MF/SF 는 원본도 30분 초과(DPY-4024) |
| 2026-10-26 23:48 | 착수 재조회 — LAST_DDL 2026-10-26 23:46:21 · 17,844줄 (타 작업 `XLSNOTARGET` 선반영 확인) | PKG_DMF0082 BODY | 최신 원문 위에 4지점 치환 |
| 2026-10-26 23:48:51 | FRESH-GATE 통과 → CREATE OR REPLACE PACKAGE BODY | PKG_DMF0082 BODY | VALID · USER_ERRORS 0 · 적용본 == DB 원문 · DMF0082 관련 INVALID 0 · XLSNOTARGET 표식 유지 |
| 2026-10-26 23:50 | 적용 후 실호출 비교 | 동일 4케이스 | ALL PASS (0 → 4,154/4,154 · 회귀 해시 동일) |
| 2026-10-26 23:5x | MF arm 원천 집계 단독 검증 | DM_PLN_SALES_PLAN_C | 9,488/9,488 PASS |
| 2026-10-26 23:52~23:56 | 클라우드 패키지 리허설 — 복제 PKG_DMF0082_RH 생성·적용·원복·재적용 후 DROP | PKG_DMF0082_RH (임시) | 전 단계 PASS · DROP 확인 |

- 원복본: `00_BACKUP_PKG_DMF0082.ASIS.sql` (23:48 착수 시점 원문, XLSNOTARGET 포함)
- 적용본: `01_NEW_PKG_DMF0082_BODY.sql`
- 클라우드 패키지: `_artifacts/_deploy_packages/DMF0082_MKTAMT_AUDIT_CLOUD_20261026/`
