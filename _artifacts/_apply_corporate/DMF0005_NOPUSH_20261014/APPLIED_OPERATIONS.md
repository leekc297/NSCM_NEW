# DMF0005 조회 — SITE_CNT 행별 재실행 차단 힌트 [E20261014-DMF0005NOPUSH]

- 대상 DB : 사내 ZIOUI1 (59.19.252.148:2521, SERVER_HOST=localhost) / SCM_MGR
- 힌트 사용자 승인 : 2026-10-14 ("네..진행해주세요")
- 클라우드 : 패치형 패키지 `_artifacts/_deploy_packages/DMF0005_NOPUSH_CLOUD_20261014/` — 미적용

## 경위

| 시각 | 내용 |
|---|---|
| 10:15:49 | 사내 PKG_DMF0005 BODY 에 Partial Plan YN 조회 2줄 추가 (`DMF0005_PARTIALPLAN82_20261014`) |
| 10:17:32 | 클라우드 QA 에 사내 전체본 BODY 가 올라감 (QA C01 실측 · 사용자 작업) |
| 10:31 ~ | QA 조회가 끝나지 않음 — 40 은 18분 28초 만에 완료, 82 · 81 은 중단 |

## 원인 (QA 실측 · 사내 재현)

- QA SQL Monitor: 조회 문장 계획 262803485 에서 최종 SELECT 의 SITE_CNT(사이트 · 프로젝트 · 팀별 H · P 건수)가 결과 행마다 다시 실행됨(VIEW PUSHED PREDICATE).
  40 = 15,672회 × 품목 집계 임시 결과 17만 행 = 26억 7천만 행 읽기.
- QA 는 조회조건 값을 보지 않고 계획을 만든다(Peeked Binds 없음 · BIND_SENSITIVE N · SCM_MST_SITE_ITEM 추정 15,930 = 127,440 ÷ 8). 히스토그램은 사내와 같이 있음(C05 [S2]).
- 사내 재현: 세션에서 `_optim_peek_user_binds = FALSE` · `optimizer_adaptive_plans = FALSE` → 같은 형태 계획, 40 · 82 · 81 모두 2분 제한 초과.
- **Partial Plan YN 2줄이 없는 원문(10-14 이전 사내본)도 같은 조건에서 똑같이 2분 초과** — 2줄의 내용이 아니라 BODY 교체로 문장이 재파싱된 것이 계기.
  QA 의 교체 전 커서(2zurcv8akt27v, 7.8초)는 INVALID_UNAUTH 라 원문으로 되돌려도 재파싱이 필요 → 복구 수단 아님.

## 조치 검토 (hook #129 순서)

| 순위 | 검토 | 결과 |
|---|---|---|
| 1 · 1-b | SITE_CNT 를 BASE 의 분석함수(MAX … OVER)로 합침 (`_apply_corporate/DMF0005_SITECNT_20261014/` — 미적용) | 품목 집계(ITEM_AGG)가 대신 행마다 재실행(INDEX FULL SCAN × 3,567회)되어 사내 기본 설정에서도 611초 · **폐기** |
| 3 | SARGable | 원인 조인이 10-08 모델 대소문자 · 끝 공백 무시 연결(함수 씌운 조인) — 동작을 바꾸지 않고는 불가 |
| 4 | 인덱스 | 대상 SCM_ITEM_M 은 FP_MGR 소유 · 함수 기반 인덱스 필요 → 즉시 조치 불가 |
| - | 통계 | QA 는 바인드 값을 보지 않는 설정 → 통계로 해결 보장 없음 |
| 5 | 힌트 `NO_PUSH_PRED(SC)` 1개 | 채택 (사용자 승인) |

## 실행 작업 ↔ 파일

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 11:34:33 | PKG_DMF0005 BODY — 조회 프로시저 409행 `SELECT` → `SELECT /*+ NO_PUSH_PRED(SC) */ -- 주석` (1줄) | `01_PKG_DMF0005_BODY.sql` (`build_apply.py`) | VALID · 오류 0 · INVALID 63 → 63 |
| 2 | 11:34:57 | 클라우드 패치 리허설 — 99_ROLLBACK (원복) | 패키지 `A_DB/99_ROLLBACK_NOPUSH_PATCH.sql` | ROLLED BACK · VALID |
| 3 | 11:35:04 | 클라우드 패치 리허설 — 10_APPLY (재적용) · 재실행 SKIP | 패키지 `A_DB/10_APPLY_NOPUSH_PATCH.sql` | APPLIED · VALID · 마커 1 |
| - | - | 원복 (미실행) | `00_BACKUP_PKG_DMF0005_BODY.sql` 또는 패키지 99 | - |

검증용 복제 패키지 PKG_DMF0005_PRE · PKG_DMF0005_FIX · PKG_DMF0005_H1 은 생성 뒤 모두 DROP (남은 객체 0 확인).
권한 · 시노님 · SPEC 변경 없음. 최종 DB 원문 = `01_PKG_DMF0005_BODY.sql` (일치 확인).

## 검증

| 항목 | 결과 |
|---|---|
| 결과 동등성 (힌트 복제본 vs 적용 전 패키지, 사내 기본 설정) | **PASS** — 시나리오 96개(사업부 8 전체 + 81 · 82 · 40 · 81_UC 의 사이트 · 팀 · 고객 · 프로젝트 · 모델 · Owner · Active 조건) × 사용자 2명, 674,518행 행 · 값 · 순서 · 컬럼 동일, 0행 시나리오 0 (`_artifacts/_diagnostics/DMF0005_CLOUD_PERF_CHECK_20261014/_corp_equiv_H1_out.txt`) |
| QA 조건 모사 시간 (적용 전) | 40 · 82 · 81 모두 2분 제한 초과 |
| QA 조건 모사 시간 (적용 뒤) | 81 2.50s · 82 1.46s · 40 0.85s · 81_UC 0.19s · 81 모델 1.10s · 81 Active Y 1.24s · 82 팀 0.61s · 40 사이트 1.02s (`_qa_condition_after_out.txt`) · 힌트 문장 auf0qn8xx5388 계획에 VIEW PUSHED PREDICATE 0 |
| 사내 기본 설정 (90_VERIFY V3) | 82 1.12s · 81 1.28s · 40 1.06s |

## 남은 것

- 클라우드 QA 적용 (패치형 패키지) 및 QA 90_VERIFY 확인
- 전체 속도 개선(별건, 사용자 지시로 이후 진행): 10-08 함수 씌운 품목 연결 구조 · Owner 이름 구간 행별 재실행(QA 계획 실측 1,800만 행)
