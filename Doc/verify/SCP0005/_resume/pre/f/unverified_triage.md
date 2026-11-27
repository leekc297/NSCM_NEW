# SCP0005 미검증 분류 · 2026-11-26 02:40:02 · 라운드 1

- 원장 미검증(ERROR) 25 → 4행. 처리 대상(엔진·대조표·판단·미분류·자동 남음) 0 · 사람 확인 0 · 집계 4
- 집계 행 = 하위 행 판정을 따라감. 하위 행이 풀리면 같이 풀림(따로 고치지 않음).
- 자동 재측정: 없음

| 담당 | 유형 | 행 |
|---|---|---|
| 집계 | 집계 | 4 |

## 담당 집계 (4행)

### 집계 · 규칙 H6 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-ef37f9e9 [GENERAL] [SCP0007 결함 유형] Route 검색 팝업 제목 | 규칙 H6 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-0e9099ba] new GSCM.SCM.PopUp.UIL.SCP0005_DistributionRoutePopup(): 팝업이 열리지 않아 표준 확인 불가(G5 행 참고) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 집계 · 규칙 M4 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-9343bbce [TRACE] SCP0005_DistributionRoute.spdMain_CellDoubleClick | 진입점 집계 — 대조표 SCP0005_DistributionRoute.spdMain_CellDoubleClick 의 M4 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요)

### 집계 · 규칙 X-ROW · 2행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-d920ea16 [TRACE] SCP0005_DistributionRoute.FindButton | 진입점 집계 9검사 — PASS:8 · ERROR:1
- T-e71343b5 [TRACE] SCP0005_DistributionRoute.FindDataReceive | 진입점 집계 8검사 — PASS:4 · NA:2 · ERROR:1 · WARN:1

