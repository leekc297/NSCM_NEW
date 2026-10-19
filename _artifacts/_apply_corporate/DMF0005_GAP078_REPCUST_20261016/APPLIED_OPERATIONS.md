# APPLIED_OPERATIONS — GAP 78 DMF0005 대표 Sold-To/Ship-To (사내 ZIOUI1, 2026-10-16)

접속: 59.19.252.148:2521/ZIOUI1 · SERVER_HOST=localhost · SCM_MGR
AS-IS 근거: 운영 추출본 `C:\TRANFILE\RECEIVE\lgce_mssql_prod_20260917\...\modules.sql`(파일, 10-02 사용자 승인 원천) L827-830 · L1235-1238 · L1466 / 개발 DB LGCE_SCMDEV 라이브(16:0x 조회) L892-895 · L1300-1303 · L1531 — 전부 REP_YN='Y' 만.

| 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|
| 16:0x | 전 스냅샷 (40/81/82 조회 SP 호출, 조회 전용) | snap.py → before.pkl | 15,569 / 42,088 / 38,621 행 |
| 16:08:33 | plan (원문 LAST_DDL 2026-10-16 15:27:41 — 타 작업 반영본, 1,999줄) | apply_corp.py plan · plan.out.txt | 마커 1 · 원복 시뮬 일치 |
| 16:08:37 | apply — FRESH-GATE 통과 → CREATE OR REPLACE PACKAGE BODY | apply_corp.py apply · apply.out.txt | VALID · 의존 INVALID 0 · 적용본==DB 원문 |
| 16:09 | 후 스냅샷 + 키 대조 | snap.py → after.pkl · diff.py · diff.out.txt | 행 수 불변 · 40 220 · 81 82 · 82 238 행의 Sold-To/Ship-To 4칸만 빈칸→값 |
| 16:11:01 | 리허설 99 원복 | 클라우드 패키지 99 | md5 4987a8c5… == 수정 전 |
| 16:11:06 | 리허설 10 재적용 (최종 상태) | 클라우드 패키지 10 | md5 59b1fbaa… == 적용본 · VALID |

백업: `PKG_DMF0005_BODY.ASIS_20261016_160837.sql`(수정 전) · `PKG_DMF0005_BODY.TOBE_20261016_160837.sql`(적용본)
원복: `python apply_corp.py rollback` 또는 클라우드 패키지 99.
