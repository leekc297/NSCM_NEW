# 결정표 — SCP0020 · 2026-10-29 14:52

> 기계가 PASS/FAIL 을 정하지 못한 17건. 각 행의 **실측**을 보고 answer 에 P(같다)/F(결함)/N(해당없음·사유) 를 적은 뒤 `python tools/Harness/verify/decisions.py SCP0020 --apply` → 원장에 수동 판정으로 반영(재실행이 덮지 않음).

> **근거 등급(2026-10-26)**: `by` 열에 답한 사람을 적는다(비우면 반영 안 함). AI(claude 등)가 답한 P·N 은 `evidence_ref`(경로:줄) + `evidence_quote`(그 줄 원문 인용)가 기계로 확인될 때만 반영하고, 확인되지 않으면 판정필요로 남는다. AI 의 F 는 보수적으로 반영한다.


| 그룹 | 건수 | 어떻게 결정하나 |
|---|---|---|
| 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정) | 13 | 실측과 AS-IS 원문 대조 |
| 기타 | 4 | 실측과 AS-IS 원문 대조 |

## 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정)

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0020-005 | A1 | 2 조회 · btnItemId / txtItemId | 행 집계 — 대조표 2 조회 'btnItemId / txtItemId' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME.m |  |
| DC-SCP0020-006 | A1 | COMMON:UC-02 · 데이터 수정 중 다른 데이터 조회 시도 = c | 행 집계 — 대조표 COMMON:UC-02 '데이터 수정 중 다른 데이터 조회 시도 = confirm 프롬프트' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/ |  |
| DC-SCP0020-007 | A1 | COMMON:UC-07 · 필터가 걸린 상태에서 재조회해도 조회되고 필터 | 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP |  |
| DC-SCP0020-008 | A1 | SCM0002 Item 팝업 · `itemSearch` SEARCH (확 | 행 집계 — 대조표 SCM0002 Item 팝업 '`itemSearch` SEARCH (확인 필요 — 별도 화면 SP)' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP |  |
| DC-SCP0020-009 | A1 | SCP0020_TactTime.FindData_Main_MaxValue | 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Main_MaxValue 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GE |  |
| DC-SCP0020-010 | A1 | SCP0020_TactTime.FindData_Packer_MaxValu | 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Packer_MaxValue 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_ |  |
| DC-SCP0020-011 | A1 | btnItemId_Click · 2541 | 행 집계 — 대조표 btnItemId_Click '2541' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME.md —; P |  |
| DC-SCP0020-012 | A6 | SCM0002 Item 팝업 · `itemSearch` SEARCH (확 | 행 집계 — 대조표 SCM0002 Item 팝업 '`itemSearch` SEARCH (확인 필요 — 별도 화면 SP)' 의 A6 4요소: PASS:3 · REVIEW:1 · FAIL 요소: SCP0020_GET_TACT_TIME_EXCEPT — 원장 V-4cc685ab SP / 정렬대조 REVIEW TO-BE 프로시저  |  |
| DC-SCP0020-013 | A6 | SCP0020_TactTime.FindData_Main_MaxValue | 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Main_MaxValue 의 A6 4요소: PASS:3 · REVIEW:1 · FAIL 요소: SCP0020_GET_TACT_TIME_EXCEPT — 원장 V-4cc685ab SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — |  |
| DC-SCP0020-014 | A6 | SCP0020_TactTime.FindData_Packer_MaxValu | 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Packer_MaxValue 의 A6 4요소: PASS:3 · REVIEW:1 · FAIL 요소: SCP0020_GET_TACT_TIME_EXCEPT — 원장 V-4cc685ab SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 |  |
| DC-SCP0020-015 | X-ROW | SCP0020_TactTime.FindButton | 진입점 집계 6검사 — PASS:3 · REVIEW:2 · NA:1 |  |
| DC-SCP0020-016 | X-ROW | SCP0020_TactTime.FindData_Except_Packer | 진입점 집계 8검사 — PASS:5 · NA:2 · REVIEW:1 |  |
| DC-SCP0020-017 | X-ROW | SCP0020_TactTime.Find_Packer | 진입점 집계 8검사 — PASS:5 · NA:2 · REVIEW:1 |  |

## 기타

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0020-001 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME.md — 파라미터 미정 |  |
| DC-SCP0020-002 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCE | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME_EXCEPT_OSP.md — 파라미터 미정 |  |
| DC-SCP0020-003 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME_OSP.md — 파라미터 미정 |  |
| DC-SCP0020-004 | A1 | SCP0020_GET_TACT_TIME_EXCEPT | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME_EXCEPT.md — 파라미터 미정 |  |
