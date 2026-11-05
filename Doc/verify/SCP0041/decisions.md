# 결정표 — SCP0041 · 2026-10-29 14:08

> 기계가 PASS/FAIL 을 정하지 못한 22건. 각 행의 **실측**을 보고 answer 에 P(같다)/F(결함)/N(해당없음·사유) 를 적은 뒤 `python tools/Harness/verify/decisions.py SCP0041 --apply` → 원장에 수동 판정으로 반영(재실행이 덮지 않음).

> **근거 등급(2026-10-26)**: `by` 열에 답한 사람을 적는다(비우면 반영 안 함). AI(claude 등)가 답한 P·N 은 `evidence_ref`(경로:줄) + `evidence_quote`(그 줄 원문 인용)가 기계로 확인될 때만 반영하고, 확인되지 않으면 판정필요로 남는다. AI 의 F 는 보수적으로 반영한다.


| 그룹 | 건수 | 어떻게 결정하나 |
|---|---|---|
| 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정) | 20 | 실측과 AS-IS 원문 대조 |
| 기타 | 2 | 실측과 AS-IS 원문 대조 |

## 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정)

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0041-003 | A1 | COMMON:UC-06 · Key-in 조회조건 = 콤마 구분 다중 입력 | 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP |  |
| DC-SCP0041-004 | A1 | D00-1-008 · §1 btnItemId / UsrButton | 행 집계 — 대조표 D00-1-008 '§1 btnItemId / UsrButton' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PAC |  |
| DC-SCP0041-005 | A1 | D00-2-001 · §2 ActiveSheet / CellChanged | 행 집계 — 대조표 D00-2-001 '§2 ActiveSheet / CellChanged' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET |  |
| DC-SCP0041-006 | A1 | D00-2-003 · §2 btnItemId / Click | 행 집계 — 대조표 D00-2-003 '§2 btnItemId / Click' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PACK_HO |  |
| DC-SCP0041-007 | A1 | D00-3-013 · §3 Query / (ds) — FindData_M | 행 집계 — 대조표 D00-3-013 '§3 Query / (ds) — FindData_Main 결과 바인딩' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/S |  |
| DC-SCP0041-008 | A1 | D00-3-015 · §3 Query / (ds) — FindData_P | 행 집계 — 대조표 D00-3-015 '§3 Query / (ds) — FindData_Pack 결과 바인딩' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/S |  |
| DC-SCP0041-009 | A1 | MODAL:ItemByDivisionModal · AS-IS txtIte | 행 집계 — 대조표 MODAL:ItemByDivisionModal 'AS-IS txtItemId/btnItemId Item 조회 팝업 (COM0008, des' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO- |  |
| DC-SCP0041-010 | A1 | [R10] · 탭 전환 시 조건세트/기간 재계산 | 행 집계 — 대조표 [R10] '탭 전환 시 조건세트/기간 재계산' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PACK_HOLD_STO |  |
| DC-SCP0041-011 | A1 | [R12/R13] · 조회 후 전열 LockColumn (조회모드) | 행 집계 — 대조표 [R12/R13] '조회 후 전열 LockColumn (조회모드)' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PA |  |
| DC-SCP0041-012 | A1 | [R1] · dtDivision 0건 → SetDivisionAuthCh | 행 집계 — 대조표 [R1] 'dtDivision 0건 → SetDivisionAuthCheck 조회영역 잠금' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/ |  |
| DC-SCP0041-013 | A1 | [R2] · FindButton 탭분기 조회 | 행 집계 — 대조표 [R2] 'FindButton 탭분기 조회' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PACK_HOLD_STOC; |  |
| DC-SCP0041-014 | A1 | `sheet[0] shtMain "Osp Stock"` · `<OspSt | 행 집계 — 대조표 `sheet[0] shtMain "Osp Stock"` '`<OspStockGrid>` (조회 전용 14컬럼)' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/gold |  |
| DC-SCP0041-015 | A1 | cboDivision (필수) · `GetDivisionWithoutEE | 행 집계 — 대조표 cboDivision (필수) '`GetDivisionWithoutEE(false,"")` cs:48' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SC |  |
| DC-SCP0041-016 | A1 | cboStatus (Pack) · PACKER_HOLD_STATUS | 행 집계 — 대조표 cboStatus (Pack) 'PACKER_HOLD_STATUS' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PA |  |
| DC-SCP0041-017 | A1 | clbPlantSite (Osp) · `CommonAll(...OSP1) | 행 집계 — 대조표 clbPlantSite (Osp) '`CommonAll(...OSP1)` cs:50 + `SaleSiteByDivision1`' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: |  |
| DC-SCP0041-018 | A1 | clbPlantSite (Pack) · `CommonAll(...Pack | 행 집계 — 대조표 clbPlantSite (Pack) '`CommonAll(...PackerHoldStock1)` cs:51' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden |  |
| DC-SCP0041-019 | A1 | dCalendar (필수) · 기간 | 행 집계 — 대조표 dCalendar (필수) '기간' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PACK_HOLD_STOC; PKG_ |  |
| DC-SCP0041-020 | A1 | dCalendarCutoff (Pack) · 기간 | 행 집계 — 대조표 dCalendarCutoff (Pack) '기간' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PACK_HOLD_ST |  |
| DC-SCP0041-021 | A1 | txtInspection (Pack) · 텍스트 | 행 집계 — 대조표 txtInspection (Pack) '텍스트' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PACK_HOLD_STO |  |
| DC-SCP0041-022 | A1 | txtItemId + btnItemId · Item 팝업 | 행 집계 — 대조표 txtItemId + btnItemId 'Item 팝업' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PACK_HOL |  |

## 기타

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0041-001 | A1 | PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOC | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PACK_HOLD_STOCK.md — 파라미터 미정 |  |
| DC-SCP0041-002 | A1 | PKG_SCP0041.P_SCP0041_GET_STOCK_OSP | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_STOCK_OSP.md — 파라미터 미정 |  |
