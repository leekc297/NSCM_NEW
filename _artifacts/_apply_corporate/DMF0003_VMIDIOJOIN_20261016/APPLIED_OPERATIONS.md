# APPLIED_OPERATIONS — DMF0003 VMIDIOJOIN (사내 ZIOUI1, 2026-10-16)

접속: 59.19.252.148:2521/ZIOUI1 · SERVER_HOST=localhost · SCM_MGR

| 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|
| 15:12~15:16 | 진단 실행: 진단 사용자 `zz_diag_dmf0003` 에 SCM_MST_TITLESET_USER 'M' 21행 INSERT → SP 2회 호출 → V$SQL/ASH 측정 → 같은 사용자 행 전부 DELETE(SP 가 넣은 'C' 기본 17행 포함 38행) | scratchpad run40.py · var40.py | 원장 잔존 0 |
| 15:31:26 | plan (원문 조회 LAST_DDL 2026-10-15 09:25:30, 14,862줄) | apply_corp.py plan | 마커 1 · 원복 시뮬 일치 |
| 15:31:54 | apply — FRESH-GATE 통과 → CREATE OR REPLACE PACKAGE BODY | apply_corp.py apply · apply.out.txt | VALID · 의존 INVALID 0 · 적용본==DB 원문 |
| 15:33~15:36 | 검증: 진단 사용자 임시 설정 → 40 2회 · 원래 조인 SQL · 82 · 81 호출 → 38행 DELETE | verify_corp.py · verify.out.txt | 40 8.1/9.2초 · 원래 조인 결과와 3,065행 전체 동일 · 81 생성 SQL 원래 문구 |
| 15:44:58 | 리허설 99 원복 | 클라우드 패키지 `99_ROLLBACK_VMIDIOJOIN_PATCH.sql` | 원문 md5 29aaaf4d… == 수정 전 |
| 15:45:30 | 리허설 10 재적용 (최종 상태) | `10_APPLY_VMIDIOJOIN_PATCH.sql` | md5 a83c2bd7… == 적용본 · VALID |

백업: `PKG_DMF0003_BODY.ASIS_20261016_153152.sql`(수정 전) · `PKG_DMF0003_BODY.TOBE_20261016_153152.sql`(적용본)
원복: `python apply_corp.py rollback` 또는 클라우드 패키지 99.
