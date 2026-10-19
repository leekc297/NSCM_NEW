# DMF0005 조회 미종료 보완 — 클라우드 패치 [E20261014-DMF0005NOPUSH]

## 무엇을 고치나
10-14 PKG_DMF0005 BODY 교체 뒤 클라우드 QA 에서 DMF0005 조회가 끝나지 않는 문제(40 = 18분, 82 · 81 은 그 이상).
조회 문장이 사이트 · 프로젝트 · 팀별 H · P 건수(SITE_CNT)를 결과 행마다 다시 계산하는 계획을 골랐기 때문이다.
조회 프로시저 1줄에 힌트 `/*+ NO_PUSH_PRED(SC) */` 를 넣어 SITE_CNT 를 한 번만 계산하게 한다. 결과 값은 바뀌지 않는다.

## 방식
**패치형** — 클라우드의 현재 BODY 원문(USER_SOURCE)을 읽어 그 1줄만 바꾼다. 사내 전체본으로 덮어쓰지 않는다.
앵커가 정확히 1곳이 아니면 아무것도 바꾸지 않고 멈춘다. 컴파일 오류가 나면 원문으로 자동 복원한다.

## 실행 순서 (계정 SCM_MGR · 각 파일 전체 F5 · 값 입력 없음)

| 순서 | 파일 | 확인할 것 |
|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | [L1] `PASS → 10 적용 가능` · [L2] 마커 0 · [L4] 실행 중 세션 (있으면 끝나거나 멈춘 뒤 진행) |
| 2 | `A_DB/10_APPLY_NOPUSH_PATCH.sql` | `APPLIED — PKG_DMF0005 BODY VALID · 마커 1곳` |
| 3 | 화면에서 DMF0005 다시 조회 | 이미 돌고 있던 조회는 옛 계획으로 계속 돈다 — 새로 조회해야 새 계획 |
| 4 | `A_DB/90_VERIFY.sql` | [V1] VALID · 오류 0 · 마커 1 · [V3] 82 · 81 · 40 각 몇 초 안에 끝남 · [V4] PATCHED_TXT = Y 줄의 SEC_PER_EX 몇 초 |
| 원복 | `A_DB/99_ROLLBACK_NOPUSH_PATCH.sql` | `ROLLED BACK` |

## 사내 기준 (ZIOUI1, 2026-10-14)
- 사내 적용 11:34:33 · 리허설 순서 00 → 99 → 00 → 10 → 10(재실행 SKIP) → 90 전부 오류 0 (`_rehearsal_out/`)
- 결과 동등성: 시나리오 96개 × 674,518행 행 · 값 · 순서 동일
- QA 조건 모사(조회조건 값을 보지 않고 계획 생성 · 실행 중 계획 보정 끔): 적용 전 40 · 82 · 81 모두 2분 초과 → 적용 뒤 0.2 ~ 2.5초
- 90_VERIFY [V3] 사내: 82 1.12s · 81 1.28s · 40 1.06s

## 참고
- QA 에 Partial Plan YN 메타(`SCM_MST_SHEET_COLUMNS` production_82 행)를 넣었는지는 별도 확인 필요 —
  `_artifacts/_apply_corporate/DMF0005_PARTIALPLAN82_20261014/01_MERGE_SHEET_COLUMNS_PARTIAL_PLAN_YN.sql` (멱등)
- 원인 진단 근거: `_artifacts/_diagnostics/DMF0005_CLOUD_PERF_CHECK_20261014/` (QA C01 · C02 · C00B · C05 결과, 사내 재현 출력)
