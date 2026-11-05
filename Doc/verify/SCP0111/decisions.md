# 결정표 — SCP0111 · 2026-10-29 14:01

> 기계가 PASS/FAIL 을 정하지 못한 6건. 각 행의 **실측**을 보고 answer 에 P(같다)/F(결함)/N(해당없음·사유) 를 적은 뒤 `python tools/Harness/verify/decisions.py SCP0111 --apply` → 원장에 수동 판정으로 반영(재실행이 덮지 않음).

> **근거 등급(2026-10-26)**: `by` 열에 답한 사람을 적는다(비우면 반영 안 함). AI(claude 등)가 답한 P·N 은 `evidence_ref`(경로:줄) + `evidence_quote`(그 줄 원문 인용)가 기계로 확인될 때만 반영하고, 확인되지 않으면 판정필요로 남는다. AI 의 F 는 보수적으로 반영한다.


| 그룹 | 건수 | 어떻게 결정하나 |
|---|---|---|
| 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정) | 3 | 실측과 AS-IS 원문 대조 |
| 기타 | 2 | 실측과 AS-IS 원문 대조 |
| 조회 결과(A1) — AS-IS dev DB 와 데이터 차이 해석 | 1 | 실측과 AS-IS 원문 대조 |

## 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정)

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0111-004 | A1 | FindButton · search=handleSearch | 행 집계 — 대조표 FindButton 'search=handleSearch' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_SCP0111.P_SCP0111_GET_INTE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0111/SCP0111_GET_INTEGRA |  |
| DC-SCP0111-005 | A1 | 조회기간 from>to 금지 · Form 조회 전 | 행 집계 — 대조표 조회기간 from>to 금지 'Form 조회 전' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_SCP0111.P_SCP0111_GET_INTE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0111/SCP0111_GET_INTEGRATION_ |  |
| DC-SCP0111-006 | X-ROW | SCP0111_IntegrationPSI._defaultDataModel | 진입점 집계 6검사 — NA:5 · WARN:1 |  |

## 기타

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0111-001 | A1 | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0111/SCP0111_GET_ESS_PACK_LINE.md — 파라미터 미정 |  |
| DC-SCP0111-002 | A1 | PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PS | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0111/SCP0111_GET_INTEGRATION_PSI.md — 파라미터 미정 |  |

## 조회 결과(A1) — AS-IS dev DB 와 데이터 차이 해석

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0111-003 | A1 | P_SCP0111_GET | 골든 비교 케이스 없음(P_SCP0111_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  |
