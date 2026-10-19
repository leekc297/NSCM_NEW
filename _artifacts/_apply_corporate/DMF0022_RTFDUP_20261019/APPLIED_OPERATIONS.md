# [E20261019-000071] PKG_DMF0022 RTF 중복 — 사내 ZIOUI1 적용 기록

| 시각 (2026-10-19) | 작업 | 파일 | 결과 |
|---|---|---|---|
| 11:46 | BODY 원문 새로 조회 (LAST_DDL 2026-10-14 09:22:09, VALID, 3,792줄) | `PKG_DMF0022_BODY.ASIS.sql` | 기준본 |
| 11:51 | 40 [PJ2024-50611] 블록(3106~3529행) 주석 처리 + 블록 내 힌트 8개 `\*+ NO_PARALLEL *\` | `apply_rtfdup.py build/apply` → `PKG_DMF0022_BODY.TOBE.sql` | FRESH-GATE PASS · VALID · 오류 0 · DB==TOBE |
| 12:03 | 리허설 99 원복 | 클라우드 패키지 `99_ROLLBACK_RTFDUP_PATCH.sql` | md5 = 수정 전 |
| 12:03 | 리허설 10 재적용 | 클라우드 패키지 `10_APPLY_RTFDUP_PATCH.sql` | md5 = 11:51 적용본 (57c2de02…) |

- 치환 정의 단일 원천: `ops.py` (클라우드 생성기가 import)
- 실행 검증: `smoke.py` (SCM_COM_SQL_LOG 의 최근 FE 파라미터 + SCUD_CN_FOC/MCCM348014A3)
- 클라우드 패키지: `_artifacts/_deploy_packages/DMF0035_PKG0022_RTFDUP_CLOUD_20261019/`
