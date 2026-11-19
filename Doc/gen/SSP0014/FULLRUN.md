# FULLRUN SSP0014 — 2026-11-19 17:27 ⚠ 경고 포함 완료

체인: 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) · 총 13036s

| # | 단계 | 결과 | exit | 소요 |
|---|---|---|---|---|
| 1 | 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) | OK | 0 | 8892s |
| 2 | 2. 검증 보완 (미검증 처리 대상 전체 목록 → 검사엔진 일괄 신설·보완 · 처리 대상이 있을 때만) (선택) | OK | 0 | 2171s |
| 3 | 3. CheckList 재수행 (미검증 행만 다시 잴 수 있으면 그 규칙만 · 아니면 처음부터 → 재분류) (선택) — 원인: [FAIL] 엔진 변경 게이트 실패 — 검증 도구를 고친 뒤 다시 실행(python tools/Harness/verify/engine_selfcheck.py) | WARN | 3 | 39s |
| 4 | 2-2. 검증 보완 2회차 (직전 재수행 뒤 처리 대상이 남고 줄었을 때만) (선택) | OK | 0 | 831s |
| 5 | 3-2. CheckList 재수행 2회차 (선택) — 원인: [FAIL] Playwright exit code 1 - log tail: | WARN | 1 | 987s |
| 6 | 2-3. 검증 보완 3회차 (직전 재수행 뒤 처리 대상이 남고 줄었을 때만) (선택) | WARN | 1 | 5s |
| 7 | 3-3. CheckList 재수행 3회차 (선택) — 원인: [세부 9/10] E2E 스펙(Doc/e2e/specs/<ID>.*) — OK | WARN | 4294967295 | 110s |

다음 할 일: Status 탭의 단계·E2E 타일과 Doc/gen/SSP0014/PIPELINE.md · Doc/e2e/results/_summary.md 확인
