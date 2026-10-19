# DMF0082_ADJYNALL — 사내 ZIOUI1 적용 기록 (2026-10-13)

마커 `[E20261013-DMF0082ADJYNALL]` · 대상 `SCM_MGR.PKG_DMF0082` PACKAGE BODY (`P_DMF0082_SAVE_MAIN_DATA` 단가 검증 #10 제외조건)

## 기준 원문
- 조회 DB ZIOUI1 · 조회 2026-10-13 09:59 · BODY LAST_DDL 2026-10-13 00:22:19 (SSPMNEW 적용본)
- 백업 `00_BACKUP_PKG_DMF0082_BODY.sql` · 적용본 `01_PKG_DMF0082_BODY.sql` (제외조건 8줄 → 줄 주석 8줄 + 설명 2줄, 그 외 무변경)
- PKG_DMF0082 안의 `SALES_PLAN_ADJUST_YN` 사용처 전수: 검증 제외는 이 한 곳(L13610~13617). 나머지 4곳은 Price Batch 팝업 조회의 컬럼 출력
- AS-IS 대조: LGCE_SCMDEV `DMF0082_SAVE_MAIN_DATA`(06-12 본) L1185~1191 — `SALES_PLAN_ADJUST_YN IN ('Y','',NULL)` 품목만 단가 검증 = 같은 예외. 이번 변경은 의도적 강화

## 실행한 작업
| 시각 | 작업 | 결과 |
|---|---|---|
| 09:59 | `build_apply.py build` · `apply` | FRESH-GATE PASS · DB==적용본 · VALID · USER_ERRORS 0 · SCM_MGR INVALID 7 → 7 |
| 10:05 | 클라우드 패키지 리허설 (99 → 00 → 90 → 10 → 10 → 90 → 00) | 왕복 PASS · 최종 상태 = 적용 (LAST_DDL 10:05:12 · 마커 1) |

권한·시노님·메타·데이터 변경 없음.

## 검증
`test_stmt_before_after.py` — 단가 검증 문장을 수정 전(백업본)·후(DB 적용본)에서 그대로 추출해 같은 가상 입력(세션 GTT)으로 실행:

| 케이스 | 전 | 후 | 판정 |
|---|---|---|---|
| A 조정 제외(N) 품목 + 그 주 판가 없음 | 통과 | 차단 | 이번 변경 |
| B 조정 제외(N) 품목 + 그 주 판가 있음 | 통과 | 통과 | 불변 |
| C 일반 품목 + 그 주 판가 없음 | 차단 | 차단 | 불변 |
| D 일반 품목 + 그 주 판가 있음 | 통과 | 통과 | 불변 |
| E 조정 제외(N) 품목 + 검증 제외 Fcst Type(SPF) + 판가 없음 | 통과 | 통과 | 불변 (다른 제외 규칙 유지) |

`test_adjynall.py` — 저장 SP 실호출: 사내 조정 제외 품목 5건(전부 Peopleworks)이 단가 검증보다 앞선 Biz Type 검증(#6)에서 먼저 차단 → **단가 검증까지 도달한 실호출 케이스 없음**. 원장 0 → 0.

## 미실행
- 저장 SP 실호출로 'Unit Price Not Found' 가 뜨는 것은 사내에서 확인하지 못했다(위 사유). 클라우드 90_VERIFY V4 또는 화면에서 확인 필요.
- 화면(브라우저) 확인 미실행. 클라우드 미적용 — 패키지 `_deploy_packages/DMF0082_ADJYNALL_CLOUD_20261013/`.
