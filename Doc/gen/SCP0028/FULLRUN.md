# FULLRUN SCP0028 — 2026-11-19 17:27 ⚠ 경고 포함 완료

체인: 🔎 CheckList (테스트: E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList) · 총 13007s

| # | 단계 | 결과 | exit | 소요 |
|---|---|---|---|---|
| 1 | 1. CheckList 수행 (E2E 4종 포함 · AS-IS vs TO-BE → CheckList·ActionItemList → 미검증 분류) | OK | 0 | 9901s |
| 2 | 2. 검증 보완 (미검증 처리 대상 전체 목록 → 검사엔진 일괄 신설·보완 · 처리 대상이 있을 때만) (선택) | OK | 0 | 2181s |
| 3 | 3. CheckList 재수행 (미검증 행만 다시 잴 수 있으면 그 규칙만 · 아니면 처음부터 → 재분류) (선택) — 원인: [FAIL] Playwright exit code 1 - log tail: | WARN | 1 | 797s |
| 4 | 2-2. 검증 보완 2회차 (직전 재수행 뒤 처리 대상이 남고 줄었을 때만) (선택) | WARN | 1 | 14s |
| 5 | 3-2. CheckList 재수행 2회차 (선택) — 원인: [INFO] CheckList 재수행 = 처음부터 전체 — 처리 대상 141행 중 10행이 --only 로 다시 잴 수 없는 단계(E2E 4종, 팝업·권한 검사기) | WARN | 1 | 7s |
| 6 | 2-3. 검증 보완 3회차 (직전 재수행 뒤 처리 대상이 남고 줄었을 때만) (선택) | WARN | 1 | 5s |
| 7 | 3-3. CheckList 재수행 3회차 (선택) — 원인: [세부 9/10] E2E 스펙(Doc/e2e/specs/<ID>.*) — OK | WARN | 4294967295 | 101s |

다음 할 일: Status 탭의 단계·E2E 타일과 Doc/gen/SCP0028/PIPELINE.md · Doc/e2e/results/_summary.md 확인
