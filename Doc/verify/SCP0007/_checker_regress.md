# 검사기 회귀 대조 SCP0007 — 기준 2026-11-06 16:22 (2430행) ↔ 현재 2026-11-14 09:56 (2759행)

- 악화(기준 비FAIL → 현재 FAIL): **36** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 66 · 그 외 변경: 1821 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 207 · 새 행 536
- 승격 대기(received): Doc\verify\_checker_golden\SCP0007.received.csv — 확인 뒤 `checker_regress.py SCP0007 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-3aea2c41 | L1 | SCP0007 저장 응답 시간 | NOT_RUN | FAIL | 저장 12회 소요 4022·4158·3976·4174·3965·4242·4087·4145·4082·4229·4655·4553ms · 최소 3965ms · 기준 3000ms |  |
| V-c7015016 | F10 | PKG_SCP0007.P_SCP0007_SAVE_BOD | NOT_RUN | FAIL | 저장 경로에 암묵 확정/파괴 문장 — 다건 저장 중 오류 시 부분 저장 가능(GAP-452·GAP-105) — PKG_SCP0007.P_SCP0007_SAVE_BOD:445 COM |  |
| V-9a934f52 | E2 | bod.FROM_YYYYMMDD (FROM*) | NOT_RUN | FAIL | 신규행 r0 FROM_YYYYMMDD: '2026-10-33' 입력 → 값 '2026-10-33' (입력 전 '2026-11-09') — 존재하지 않는 날짜가 그대로 저장 대상(A |  |
| V-cac6a100 | E2 | bod.TO_YYYYMMDD (TO*) | NOT_RUN | FAIL | 신규행 r0 TO_YYYYMMDD: '2026-10-33' 입력 → 값 '2026-10-33' (입력 전 '2099-12-27') — 존재하지 않는 날짜가 그대로 저장 대상(AS- |  |
| V-c667b133 | C6 | INCOTERMS_SSP,INCOTERMS | NOT_RUN | FAIL | To Site 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → Incoterms 'DAP'→'' · SSP Incoterms 'DAP'→'' — 값이 바뀌지 않았는데 I |  |
| V-3778a5ce | C6 | INCOTERMS_SSP,INCOTERMS | NOT_RUN | FAIL | To Site 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → Incoterms 'DAP'→'' · SSP Incoterms 'DAP'→'' — 값이 바뀌지 않았는데 I |  |
| V-f1677353 | C6 | INCOTERMS_SSP,INCOTERMS | NOT_RUN | FAIL | To Site 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → Incoterms 'DAP'→'' · SSP Incoterms 'DAP'→'' — 값이 바뀌지 않았는데 I |  |
| V-3ce5c2f4 | K3 | [DMF0020 결함 일반화] 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | NOT_RUN | FAIL | hide FAIL: 헤더(PRIORITY) 우클릭 → Hide Column → 컬럼 여전히 표시 · Unhide All 복원 · 미포함: Sort/Filter·정렬 후 동작(K1  |  |
| V-9c58202f | K3 | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | NOT_RUN | FAIL | copy PASS: 선택 0,9,0,9 · 0행 PRIORITY 표시값 '1' · Ctrl+C 클립보드 '1'(일치) · 우클릭 Copy '1'(일치) ／ hide FAIL: 헤더 |  |
| V-fff9b72e | F2 | [DMF0082 결함 일반화] Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | NOT_RUN | FAIL | 규칙 F2 판정 1행 중 FAIL 1 · 판정필요 0 · 미검증 0 — [V-db344fe6] SCP0007 시나리오 [자동] 기존행 수정 + 신규행 동시 Save 1회 → 요청에 |  |
| V-b7c5958f | C4 | [DMF0082 결함 일반화] 그리드 Measure 필터(MEASURE Filter) × Division(D | NOT_RUN | FAIL | 규칙 C4 판정 1행 중 FAIL 1 · 판정필요 0 · 미검증 0 — [T-d8e292ff] clbDivision / Div / Division / Div.: 조회 16438행  |  |
| T-48725bd0 | C6 | TO_SITE_CODE / To Site | NOT_RUN | FAIL | FROM_SITE_CODE 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → TO_SITE_CODE 'AU00'→'' — 값을 바꾸지 않았는데 TO_SITE_CODE 이  |  |
| T-395e1123 | C6 | D00-2-004 · §2 spdMain / ClipboardPasted | ERROR | FAIL | 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 C6 22요소: FAIL:8 · PASS:7 · ERROR:6 · NA:1 · FA |  |
| T-f478b82f | D1 | D00-2-004 · §2 spdMain / ClipboardPasted | ERROR | FAIL | 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 D1 33요소: ERROR:16 · NA:10 · PASS:6 · FAIL:1 ·  |  |
| T-0cfa87ef | D3 | D00-2-004 · §2 spdMain / ClipboardPasted | ERROR | FAIL | 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 D3 40요소: NA:21 · ERROR:12 · FAIL:6 · PASS:1 ·  |  |
| T-ebac0090 | C6 | D00-2-005 · §2 spdMain / ComboSelChange | ERROR | FAIL | 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 C6 22요소: FAIL:8 · PASS:7 · ERROR:6 · NA:1 · FAI |  |
| T-005d8747 | D1 | D00-2-005 · §2 spdMain / ComboSelChange | ERROR | FAIL | 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 D1 33요소: ERROR:16 · NA:10 · PASS:6 · FAIL:1 · F |  |
| T-d90a27da | D3 | D00-2-005 · §2 spdMain / ComboSelChange | ERROR | FAIL | 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 D3 40요소: NA:21 · ERROR:12 · FAIL:6 · PASS:1 · F |  |
| T-803c75b2 | D1 | ROUTE_ID / Route Id | NOT_RUN | FAIL | 기존행 r0 ROUTE_ID 편집=false (AS-IS 편집 가능) ／ 신규행 r0 ROUTE_ID 편집=false — AS-IS 조건부(행 값으로 계산 불가): RULES:[{ |  |
| T-a457e667 | D3 | INCOTERMS_SSP / Incoterms SSP | NOT_RUN | FAIL | r0 TO_SITE ''=(빈 값 → 유형 없음: AS-IS strTO_SITE_TYPE 도 빈 문자열) == PLANT(else) → INCOTERMS_SSP 편집=true (A |  |
| T-cd892e67 | D3 | INCOTERMS / Incoterms | NOT_RUN | FAIL | r1 FROM_SITE_CODE='HQ06-A' 비어있지 않음 & TO_SITE 'Alte_KR_SEL'=SALES == PLANT(else) → INCOTERMS 편집=false |  |
| T-e251b20b | D1 | D00-3-040 · §3 SmartColMerge / () | ERROR | FAIL | 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 D1 33요소: ERROR:16 · NA:10 · PASS:6 · FAIL:1 · FAIL 요소 |  |
| T-86da3f3a | D3 | D00-3-040 · §3 SmartColMerge / () | ERROR | FAIL | 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 D3 40요소: NA:21 · ERROR:12 · FAIL:6 · PASS:1 · FAIL 요소 |  |
| T-1563b72c | C6 | D00-4b-003 · §4b SpdMain_Changed / event(dsdm.Changed) / — | ERROR | FAIL | 행 집계 — 대조표 D00-4b-003 '§4b SpdMain_Changed / event(dsdm.Changed) / —' 의 C6 22요소: FAIL:8 · PASS:7 · E |  |
| T-45df5a2d | C6 | D00-4b-008 · §4b SpdMain_ComboSelChange / event / spdMain.Co | ERROR | FAIL | 행 집계 — 대조표 D00-4b-008 '§4b SpdMain_ComboSelChange / event / spdMain.Combo' 의 C6 22요소: FAIL:8 · PASS: |  |
| T-6eec79f1 | X-ROW | SCP0007_BOD.SetCityCode | ERROR | FAIL | 진입점 집계 43검사 — PASS:16 · NA:14 · FAIL:7 · ERROR:6 |  |
| T-943eabe5 | D3 | INCOTERMS,INCOTERMS | NOT_RUN | FAIL | r1 FROM_SITE_CODE='HQ06-A' 비어있지 않음 & TO_SITE 'Alte_KR_SEL'=SALES == PLANT(else) → INCOTERMS 편집=false |  |
| T-aa95f6d2 | D3 | INCOTERMS_SSP,INCOTERMS_SSP | NOT_RUN | FAIL | r0 TO_SITE ''=(빈 값 → 유형 없음: AS-IS strTO_SITE_TYPE 도 빈 문자열) == PLANT(else) → INCOTERMS_SSP 편집=true (A |  |
| T-f660d450 | D3 | INCOTERMS,INCOTERMS | NOT_RUN | FAIL | r1 FROM_SITE_CODE='HQ06-A' 비어있지 않음 & TO_SITE 'Alte_KR_SEL'=SALES == PLANT(else) → INCOTERMS 편집=false |  |
| T-0c3aaaf4 | D3 | INCOTERMS_SSP,INCOTERMS_SSP | NOT_RUN | FAIL | r0 TO_SITE ''=(빈 값 → 유형 없음: AS-IS strTO_SITE_TYPE 도 빈 문자열) == PLANT(else) → INCOTERMS_SSP 편집=true (A |  |
| T-860dfd89 | C6 | SCP0007_BOD.SpdMain_Changed | ERROR | FAIL | 진입점 집계 — 대조표 SCP0007_BOD.SpdMain_Changed 의 C6 1요소: FAIL:1 · FAIL 요소: FROM_SITE_CODE / From Site — 원장 |  |
| T-605461fe | X-ROW | SCP0007_BOD.SpdMain_Changed | ERROR | FAIL | 진입점 집계 7검사 — PASS:5 · FAIL:2 |  |
| T-7d230d18 | X-ROW | SCP0007_BOD.SpdMain_ClipboardPasted | ERROR | FAIL | 진입점 집계 39검사 — PASS:20 · NA:12 · ERROR:6 · FAIL:1 |  |
| T-a08bf57b | X-ROW | SCP0007_BOD.SpdMain_ComboSelChange | ERROR | FAIL | 진입점 집계 47검사 — PASS:31 · NA:7 · ERROR:6 · FAIL:3 |  |
| T-592fd7ff | X-ROW | SCP0007_BOD.SpdMain_EditChange | ERROR | FAIL | 진입점 집계 5검사 — PASS:2 · ERROR:2 · FAIL:1 |  |
| T-cd33df32 | C6 | SCP0007_BOD.cboDivision_SelectedIndexChanged | ERROR | FAIL | 진입점 집계 — 대조표 SCP0007_BOD.cboDivision_SelectedIndexChanged 의 C6 22요소: FAIL:8 · PASS:7 · ERROR:6 · NA: |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| T-1ec0a094 | X-NOTIMPL | D00-2-006 · §2 spdMain / EditChange | FAIL | PASS | 신규행 Route Id 셀에 키보드로 '999999' 직접 입력 → 편집기 열리지 않음 · 값 ''→'' — AS-IS 는 Route Id 직접 입력을 막고(KeyPress e.H |  |
| T-6bab36a8 | X-NOTIMPL | D00-2-007 · §2 spdMain / KeyPress | FAIL | PASS | 신규행 Route Id 셀에 키보드로 '999999' 직접 입력 → 편집기 열리지 않음 · 값 ''→'' — AS-IS 는 Route Id 직접 입력을 막고(KeyPress e.H |  |
| T-154d6ff4 | X-NOTIMPL | D00-3-009 · §3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision | FAIL | PASS | 신규행 Division 콤보 후보 8건(81, 40, 82, 81_UC, 81_HM, 81_ST) ⊆ 조회조건 Div 목록 8건 — AS-IS dtMyDivision 콤보와 동일( |  |
| T-1771c369 | G4 | D00-3-009 · §3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision | FAIL | PASS | 행 집계 — 대조표 D00-3-009 '§3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision)' 의 G4 14요소: PASS:14 |  |
| T-e91ba0f3 | G1 | D00-3-009 · §3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision | FAIL | PASS | 행 집계 — 대조표 D00-3-009 '§3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision)' 의 G1 13요소: PASS:12 · NA:1 |  |
| T-b75b16ba | G6 | D00-3-009 · §3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision | FAIL | NA | 대조표 행 D00-3-009(DIVISION_ID, dtMyDivision) 은 조회조건 칸이 아님(패널 토글·셀 콤보·SP 조회 등) — 조회조건 초기값 규칙 대상 아님(조건별  |  |
| T-aca18ced | A1 | D00-3-009 · §3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision | FAIL | PASS | 행 집계 — 대조표 D00-3-009 '§3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision)' 의 A1 5요소: PASS:4 · NA:1 |  |
| T-11ea0283 | X-NOTIMPL | D00-3-034 · §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncote | FAIL | PASS | 기존행 r8080(To Site 'HQ06-A' PLANT) SSP Incoterms: 편집 가능 · 콤보 후보 16건 — AS-IS EditButton 은 기존행도 To Site |  |
| T-4dbdc9d2 | X-NOTIMPL | D00-3-036 · §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncote | FAIL | PASS | 기존행 r8080(To Site 'HQ06-A' PLANT) SSP Incoterms: 편집 가능 · 콤보 후보 16건 — AS-IS EditButton 은 기존행도 To Site |  |
| T-bef806eb | G4 | D00-3-036 · §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncote | FAIL | PASS | 행 집계 — 대조표 D00-3-036 '§3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncoterm' 의 G4 14요소: PASS:14 |  |
| T-95711a6a | G1 | D00-3-036 · §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncote | FAIL | PASS | 행 집계 — 대조표 D00-3-036 '§3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncoterm' 의 G1 13요소: PASS:12 · NA:1 |  |
| T-33840ff9 | G6 | D00-3-036 · §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncote | FAIL | NA | 대조표 행 D00-3-036(i,INCOTERMS_SSP, dtIncoterms) 은 조회조건 칸이 아님(패널 토글·셀 콤보·SP 조회 등) — 조회조건 초기값 규칙 대상 아님(조 |  |
| T-41d68397 | A1 | D00-3-036 · §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncote | FAIL | PASS | 행 집계 — 대조표 D00-3-036 '§3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncoterm' 의 A1 5요소: PASS:4 · NA:1 |  |
| T-84fcd6aa | A6 | D00-3-040 · §3 SmartColMerge / () | FAIL | 판정필요 | [SORT 기준 차이 → 판정필요] 정렬 기준이 AS-IS 와 다름 — 결함 여부는 사람이 판정(사용자 지시 2026-10-30) · 행 집계 — 대조표 D00-3-040 '§3  |  |
| T-8f752189 | X-NOTIMPL | D00-3-043 · §3 SetBGColor / (DIVISION_ID..INCOTERMS,InvalidC | FAIL | PASS | 같은 키(기준 기존행 r0(DIVISION_ID=40, FROM_SITE_CODE=HQ06-A, TO_SITE_CODE=Alte_KR_SEL, INCOTERMS=A01, PRIOR |  |
| T-26f9c75b | E4 | DIVISION_ID / Division | FAIL | NA | DIVISION_ID: 이 대상에 연결된 AS-IS 메시지 문장 없음 — 업무 검증 메시지 대상 아님 |  |
| T-cd5119b3 | X-NOTIMPL | D00-3-044 · §3 SetBGColor / (TRANSPORT_MODE..TO_YYYYMMDD,Inv | FAIL | PASS | 같은 키(기준 기존행 r0(DIVISION_ID=40, FROM_SITE_CODE=HQ06-A, TO_SITE_CODE=Alte_KR_SEL, INCOTERMS=A01, PRIOR |  |
| T-728ec5b8 | E2 | TRANSPORT_MODE / Trans Mode | FAIL | NA | TRANSPORT_MODE 는 날짜 컬럼이 아님(AS-IS 문장의 컬럼 범위에 끼어 들어온 대상) — 날짜 입력 규칙 E2 대상 아님 |  |
| T-0839df65 | X-NOTIMPL | D00-3-045 · §3 SetBGColor / (TRANSPORT_MODE,InvalidColor) | FAIL | PASS | 같은 키(기준 기존행 r0(DIVISION_ID=40, FROM_SITE_CODE=HQ06-A, TO_SITE_CODE=Alte_KR_SEL, INCOTERMS=A01, PRIOR |  |
| T-c4b491f6 | X-NOTIMPL | D00-3-046 · §3 SetBGColor / (PRIORITY,InvalidColor) | FAIL | PASS | 같은 키(기준 기존행 r0(DIVISION_ID=40, FROM_SITE_CODE=HQ06-A, TO_SITE_CODE=Alte_KR_SEL, INCOTERMS=A01, PRIOR |  |
| T-c466f2eb | X-NOTIMPL | D00-3-065 · §3 SetActiveCell / (e.Row,e.Column) | FAIL | PASS | Route Id 더블클릭 → Distribution Route 팝업 선택·OK 후 그리드 커서(선택 셀) = r8080/c12 (더블클릭한 셀 r8080/c12) — AS-IS 는 |  |
| T-d0e4e975 | H6 | D00-3-065 · §3 SetActiveCell / (e.Row,e.Column) | FAIL | PASS | 행 집계 — 대조표 D00-3-065 '§3 SetActiveCell / (e.Row,e.Column)' 의 H6 15요소: PASS:11 · NA:4 |  |
| T-f6bb7b21 | G5 | D00-3-065 · §3 SetActiveCell / (e.Row,e.Column) | FAIL | PASS | 행 집계 — 대조표 D00-3-065 '§3 SetActiveCell / (e.Row,e.Column)' 의 G5 15요소: PASS:9 · NA:6 |  |
| T-c32845d9 | M4 | D00-3-065 · §3 SetActiveCell / (e.Row,e.Column) | FAIL | PASS | r2(ROUTE_CNT 1) ROUTE_ID 더블클릭 → Distribution Route 팝업 OK(현재 행 적용) → 대상 14개 중 채워짐 12(변경 1): BOD_VALID |  |
| T-88757671 | X-NOTIMPL | D00-3-066 · §3 ShowCell / (0,0,e.Row,e.Column,Center,Right) | FAIL | PASS | Route Id 더블클릭 → Distribution Route 팝업 선택·OK 후 그리드 커서(선택 셀) = r8080/c12 (더블클릭한 셀 r8080/c12) — AS-IS 는 |  |
| T-6f195598 | X-ROW | D00-3-066 | FAIL | NA | 검사 대상 아님 — 이 진입점에 연결된 문장·요소 검사가 없다(대조표 행만 있고 AS-IS 문장 추출 0) |  |
| T-0c6e2ae6 | X-NOTIMPL | D00-3-067 · §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSi | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-e6a975ad | X-NOTIMPL | D00-3-068 · §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSi | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-5327b6e2 | X-NOTIMPL | D00-3-069 · §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSi | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-58d205b9 | X-NOTIMPL | D00-3-074 · §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSit | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-6b502d41 | X-NOTIMPL | D00-3-075 · §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSit | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-c11f26e5 | X-NOTIMPL | D00-3-076 · §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSit | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-3e4015b5 | A6 | PKG_SCP0007.P_SCP0007_GET_BOD | FAIL | 판정필요 | [SORT 기준 차이 → 판정필요] 정렬 기준이 AS-IS 와 다름 — 결함 여부는 사람이 판정(사용자 지시 2026-10-30) · PKG_SCP0007.P_SCP0007_GET |  |
| T-7e05a316 | X-NOTIMPL | D00-4b-009 · §4b SpdMain_EditChange / event / spdMain.EditCh | FAIL | PASS | 신규행 Route Id 셀에 키보드로 '999999' 직접 입력 → 편집기 열리지 않음 · 값 ''→'' — AS-IS 는 Route Id 직접 입력을 막고(KeyPress e.H |  |
| T-ec0f1e97 | X-NOTIMPL | D00-4b-010 · §4b SpdMain_KeyPress / event / spdMain.KeyPress | FAIL | PASS | 신규행 Route Id 셀에 키보드로 '999999' 직접 입력 → 편집기 열리지 않음 · 값 ''→'' — AS-IS 는 Route Id 직접 입력을 막고(KeyPress e.H |  |
| T-b869945c | X-NOTIMPL | D00-4c-011 · §4c (없음) / GMessageBox / errCode in {99010..990 | FAIL | PASS | 같은 키(기준 기존행 r0(DIVISION_ID=40, FROM_SITE_CODE=HQ06-A, TO_SITE_CODE=Alte_KR_SEL, INCOTERMS=A01, PRIOR |  |
| T-c831d0ca | E4 | D00-4c-011 · §4c (없음) / GMessageBox / errCode in {99010..990 | FAIL | NA | D00-4c-011: 이 대상에 연결된 AS-IS 메시지 문장 없음 — 업무 검증 메시지 대상 아님 |  |
| T-f43f855f | E4 | D00-4c-013 · §4c (없음) / GMessageBoxForException | FAIL | NA | D00-4c-013: 이 대상에 연결된 AS-IS 메시지 문장 없음 — 업무 검증 메시지 대상 아님 |  |
| T-1cabd8bc | X-NOTIMPL | D00-4d-005 · §4d Data_SCP.CommonAll / FromSiteByDivision1 | FAIL | PASS | 신규행 From Site 콤보 후보 32건(CN00254300_40-P, CN00732500_40-P, CN02072800_40-P, AC00-A, AT00-A) · 후보 데이터  |  |
| T-eda05710 | G4 | D00-4d-005 · §4d Data_SCP.CommonAll / FromSiteByDivision1 | FAIL | PASS | 행 집계 — 대조표 D00-4d-005 '§4d Data_SCP.CommonAll / FromSiteByDivision1' 의 G4 14요소: PASS:14 |  |
| T-ccd7cf6b | G1 | D00-4d-005 · §4d Data_SCP.CommonAll / FromSiteByDivision1 | FAIL | PASS | 행 집계 — 대조표 D00-4d-005 '§4d Data_SCP.CommonAll / FromSiteByDivision1' 의 G1 13요소: PASS:12 · NA:1 |  |
| T-8e14869a | G6 | D00-4d-005 · §4d Data_SCP.CommonAll / FromSiteByDivision1 | FAIL | NA | 대조표 행 D00-4d-005() 은 조회조건 칸이 아님(패널 토글·셀 콤보·SP 조회 등) — 조회조건 초기값 규칙 대상 아님(조건별 G6 는 COND 요소에서 판정) |  |
| T-51d32086 | A1 | D00-4d-005 · §4d Data_SCP.CommonAll / FromSiteByDivision1 | FAIL | PASS | 행 집계 — 대조표 D00-4d-005 '§4d Data_SCP.CommonAll / FromSiteByDivision1' 의 A1 5요소: PASS:4 · NA:1 |  |
| T-83283aa0 | X-NOTIMPL | D00-4d-006 · §4d Data_SCP.CommonAll / ToSiteBOD1 | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-86f34c05 | X-NOTIMPL | D00-4d-007 · §4d Data_SCP.CommonAll / ToSiteByDivisionPlant1 | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-92a8d453 | X-NOTIMPL | D00-4d-008 · §4d Data_SCP.CommonAll / ToSiteByDivision1 | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-a673efb9 | B3 | D00-4d-010 · §4d Data.Common / LookupCommon(TRANSPORT_MODE_C | FAIL | PASS | 행 집계 — 대조표 D00-4d-010 '§4d Data.Common / LookupCommon(TRANSPORT_MODE_CODE' 의 B3 9요소: PASS:8 · NA:1 |  |
| T-5a9ef6d0 | X-NOTIMPL | D00-4e-005 · §4e dtFromSiteOfSpdAll / FindData_Main | FAIL | PASS | 신규행 From Site 콤보 후보 32건(CN00254300_40-P, CN00732500_40-P, CN02072800_40-P, AC00-A, AT00-A) · 후보 데이터  |  |
| T-c7205d8f | A5 | D00-4e-005 · §4e dtFromSiteOfSpdAll / FindData_Main | FAIL | ERROR | 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 A5 47요소: PASS:29 · ERROR:18 |  |
| T-61ce9b84 | H5 | D00-4e-005 · §4e dtFromSiteOfSpdAll / FindData_Main | FAIL | ERROR | 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 H5 47요소: PASS:25 · ERROR:18 · NA:4 |  |
| T-f9644978 | H2 | D00-4e-005 · §4e dtFromSiteOfSpdAll / FindData_Main | FAIL | ERROR | 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 H2 58요소: PASS:27 · NA:23 · ERROR:8 |  |
| T-35c97c67 | A1 | D00-4e-005 · §4e dtFromSiteOfSpdAll / FindData_Main | FAIL | PASS | 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 A1 5요소: PASS:4 · NA:1 |  |
| T-788a49eb | A6 | D00-4e-005 · §4e dtFromSiteOfSpdAll / FindData_Main | FAIL | 판정필요 | [SORT 기준 차이 → 판정필요] 정렬 기준이 AS-IS 와 다름 — 결함 여부는 사람이 판정(사용자 지시 2026-10-30) · 행 집계 — 대조표 D00-4e-005 '§4 |  |
| T-b00b7e3d | F4 | D00-4e-005 · §4e dtFromSiteOfSpdAll / FindData_Main | FAIL | PASS | 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 F4 5요소: PASS:5 |  |
| T-27e0a65e | DB-SYN | D00-4e-005 · §4e dtFromSiteOfSpdAll / FindData_Main | FAIL | PASS | 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 DB-SYN 5요소: PASS:5 |  |
| T-2e1f22f0 | X-NOTIMPL | D00-4e-006 · §4e dtToSiteOfSpdAll / FindData_Main | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-f0e8023e | A6 | D00-4e-006 · §4e dtToSiteOfSpdAll / FindData_Main | FAIL | 판정필요 | [SORT 기준 차이 → 판정필요] 정렬 기준이 AS-IS 와 다름 — 결함 여부는 사람이 판정(사용자 지시 2026-10-30) · 선행 미구현에 종속 — 대조표 D00-4e-0 |  |
| T-9155f997 | X-NOTIMPL | D00-4e-007 · §4e dtToSiteOfSpdAll / SpdMain_ComboSelChange | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-bb5e29e6 | X-NOTIMPL | D00-4e-008 · §4e dtToSiteOfSpdAll1 / SpdMain_ComboSelChange | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-0e366e1c | X-NOTIMPL | D00-4e-009 · §4e dtToSiteOfSpdAll2 / SpdMain_ComboSelChange | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-9ada0667 | X-NOTIMPL | D00-4e-010 · §4e dtToSiteOfSpdAll / SpdMain_ClipboardPasted | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-0036ec3f | X-NOTIMPL | D00-4e-011 · §4e dtToSiteOfSpdAll1 / SpdMain_ClipboardPasted | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-13bc201b | X-NOTIMPL | D00-4e-012 · §4e dtToSiteOfSpdAll2 / SpdMain_ClipboardPasted | FAIL | 판정필요 | [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] From Site 를 E형(-E) 'AZ00-E'(OSP_YN=N) / |  |
| T-1ef63e86 | X-ROW | SCP0007_DistributionRoutePopup.btnButtonList_UsrButtonList_C | FAIL | ERROR | 진입점 집계 3검사 — ERROR:2 · PASS:1 |  |
| T-1ad18cc7 | X-ROW | SCP0007_DistributionRoutePopup.btnFromSrch_Click | FAIL | ERROR | 진입점 집계 20검사 — PASS:12 · NA:6 · ERROR:2 |  |
| T-cd587e1e | X-ROW | SCP0007_DistributionRoutePopup.btnToSrch_Click | FAIL | ERROR | 진입점 집계 20검사 — PASS:12 · NA:6 · ERROR:2 |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-2740f2ff | F8 | SCP0007 저장 감사 필드 | NOT_RUN | PASS | 감사 컬럼 = 저장 계정·저장 시각 (CREATED_BY=minyonglee1 · CREATION_DATE=2026-11-14 08:08:44 · LAST_UPDATED_BY=mi |  |
| V-7cd2ac44 | F7 | SCP0007 저장 연계 테이블 | NOT_RUN | PASS | AS-IS 신규행 경로 테이블 SCP_MST_BOD 모두 기록 · UPDATE 만(신규 1건 시험 대상 아님): SCP_MST_BOD_ITEM · TO-BE 에만 기록(참고 — A |  |
| V-1b1a7484 | F6 | SCP0007 저장 행 수 불변 | NOT_RUN | ERROR | [측정 경로 누락] 비교 가능한 업무 표 없음 · {"*":"cleanup_spec 에 대상 테이블 없음"} |  |
| V-50716e04 | F8 | SCP0007 수정 감사 컬럼 | NOT_RUN | PASS | 감사 컬럼 = 저장 계정·저장 시각 (CREATED_BY=minyonglee1 · CREATION_DATE=2026-11-14 08:08:44 · LAST_UPDATED_BY=mi |  |
| V-6e39a0b6 | F7 | SCP0007 저장 연계·이력 표 | NOT_RUN | PASS | AS-IS 신규행 경로 테이블 SCP_MST_BOD 모두 기록 · UPDATE 만(신규 1건 시험 대상 아님): SCP_MST_BOD_ITEM · TO-BE 에만 기록(참고 — A |  |
| V-d4769848 | A2 | SCP0007 편집기 표시값 | NOT_RUN | PASS | 편집기 표시 1칸 코드 비노출: DIVISION_ID '81 Automotive Battery' |  |
| V-c027ab6f | F6 | SCP0007 다른 셀 편집 값 유지 | NOT_RUN | PASS | DIVISION_ID 편집 뒤 PRIORITY '7' 유지 |  |
| V-7f44d308 | D6 | SCP0007 정렬 상태 Insert | NOT_RUN | PASS | 정렬(S:DIVISION_ID) 유지 · Insert 행 편집 가능 칸 9 |  |
| V-b9844ae0 | D6 | SCP0007 필터 상태 Insert | NOT_RUN | PASS | 필터(F:DIVISION_ID) 유지 · Insert 행 편집 가능 칸 9 |  |
| V-3f1b680f | H3 | SCP0007 계층 병합 중간 미병합 | NOT_RUN | PASS | 병합 행 쌍 36건 · 중간 미병합 0 |  |
| V-4952a0f9 | D1 | SCP0007 병합 셀 입력 | NOT_RUN | NA | 병합 칸 DIVISION_ID,CUSTOMER,FROM_SITE_CODE,FROM_CITY,TO_SITE_CODE 전부 편집 불가 |  |
| V-e07c8896 | F3 | SCP0007 병합 셀 붙여넣기 | NOT_RUN | NA | 병합 칸 DIVISION_ID,CUSTOMER,FROM_SITE_CODE,FROM_CITY,TO_SITE_CODE 전부 편집 불가 |  |
| V-d3badecc | F5 | SCP0007 병합 셀 Delete 범위 | NOT_RUN | ERROR | [확인 대상] DIVISION_ID 병합 37행 Delete 뒤 D 표시 0 — 토글형·차단 여부 확인 |  |
| V-08dea842 | H3 | SCP0007 입력 중 병합 해제 | NOT_RUN | PASS | DIVISION_ID 옆 행과 같은 값이어도 입력 중 행은 병합 안 됨 |  |
| V-a01490c5 | F5 | SCP0007 원값 복원 상태 해제 | NOT_RUN | PASS | PRIORITY 수정 'M' → 원값 복원 뒤 상태 해제 |  |
| V-12b2338e | E6 | SCP0007 텍스트 부분 선택 삭제 | NOT_RUN | NA | 글자 입력되는 텍스트 조회조건 없음(입력칸 0개) |  |
| V-5f48fed2 | D1 | SCP0007 Insert 행 Div 변경 후보 | NOT_RUN | PASS | Div 81 Automotive Battery→40 Mobility & IT Battery 변경 뒤 후보 재구성 FROM_SITE_CODE · 변화 없는 칸 11개 |  |
| V-0a0fe241 | A10 | SCP0007 조회 전 합계 행 | NOT_RUN | NA | 조회 16439행 뒤에도 합계 행 없음 — 합계 없는 화면 |  |
| V-56ef3277 | N1 | SCP0007 기간 칸 이상값 | NOT_RUN | PASS | 기간 칸 5개 값 8000건 이상값 0 |  |
| V-edcb3961 | K1 | SCP0007 정렬 상태 Copy·Hide | NOT_RUN | PASS | 정렬 유지 · Copy '40 Mobility & IT Battery' · Hide 메뉴 없음(미측정) |  |
| V-b43797d2 | K3 | SCP0007 붙여넣기 코드 동반 | NOT_RUN | PASS | DIVISION_ID 이름 '81_HG Automotive Battery(HG)' 붙여넣기 → 코드 '81_HG' 동반 |  |
| V-5ae9da74 | H4 | SCP0007 헤더 높이 유지 | NOT_RUN | PASS | 헤더 높이 유지 — 조회 전 48 · 조회 뒤 48 · Div 전환 조회 뒤 48 |  |
| V-04ff42a2 | H4 | SCP0007 불필요 스크롤 | NOT_RUN | PASS | 조회 16439행 · 페이지·그리드 바깥 스크롤 없음 |  |
| V-9653e5f1 | H4 | SCP0007 헤더 글자 잘림 | NOT_RUN | PASS | 렌더된 헤더 24개 글자 잘림 0 |  |
| V-f8cfc004 | N1 | SCP0007 조건 후보 기호 일색 | NOT_RUN | PASS | 콤보 조건 8개 후보 정상 |  |
| V-352cf74e | H9 | SCP0007 칸 폭 메타 | NOT_RUN | PASS | 칸 34개 폭 = 메타 |  |
| V-06aa7874 | G1 | SCP0007 ALL 상태 조회 | NOT_RUN | PASS | ALL(Div,From Site,To Site,Incoterms) 조회 16439행 · 필수 안내 없음 |  |
| V-835d5d53 | L2 | SCP0007 조건 입력 중 재렌더 | NOT_RUN | NA | 글자 입력되는 텍스트 조건 없음 |  |
| V-51a1adfa | K1 | SCP0007 필터 편집기 항목 | NOT_RUN | PASS | BOD_ID 필터 값 항목 16439개 = 고유값 16439개 · 공란류 0개(그리드 빈 칸 없음) |  |
| V-9a17b8d7 | G6 | SCP0007 연속 조회 본문 | NOT_RUN | PASS | 조건 그대로 재조회 본문 동일 · 글자 입력 조건 없어 변경 시험 미측정 |  |
| V-ce3ec5e3 | D4 | SCP0007 시나리오 조회 전 Insert 행 To Site 후보·City 매핑 | NOT_RUN | PASS | 조회 전 Insert 행 To Site 후보·City 매핑: 기대대로 · 저장 요청 0 · 편집기 null · insert:0행·신규0·호출1·요청19 → gridcands:1행· |  |
| V-a7eaacf2 | F1 | SCP0007 시나리오 조회 전 Insert 행 저장 — 요청/차단 실측 | NOT_RUN | PASS | 조회 전 Insert 행 저장 — 요청/차단 실측: 기대대로 · 저장 요청 0 · 편집기 null · insert:0행·신규0·호출1·요청17 → type:1행·신규1·호출1·요청 |  |
| V-d8758dd4 | G6 | SCP0007 조회조건 초기값 | NOT_RUN | ERROR | [확인 대상] Division 초기값 '​' 가 후보에 없음 — 후보 81 Automotive Battery, 40 Mobility & IT Battery, 82 ESS Batte |  |
| V-f0c14209 | G6 | SCP0007 Division 변경 뒤 Version | NOT_RUN | NA | Version 조건 없음 |  |
| V-dba9cdb3 | D4 | SCP0007 Insert 행 Division | NOT_RUN | PASS | Insert 행 Division '(빈 값)' = 조건 '​' · Division 변경 뒤 신규 행 1개 유지(AS-IS 초기화 문장 없음) |  |
| V-bed61548 | K1 | SCP0007 동적 칸 정렬·필터 | NOT_RUN | NA | 동적 기간 칸 없음(정규식 ^[WMDY]?_?\d{2}[-_]?\d{0,6}$ · 뒤쪽 칸 LAST_UPDATE_DATE,LAST_UPDATED_BY,CREATION_DATE,CR |  |
| V-13c891d1 | L1 | SCP0007 방향키 누적 지연 | NOT_RUN | PASS | 방향키 40회 — 앞 10회 평균 170ms · 뒤 10회 172ms · 누적 지연 없음 |  |
| V-94501f04 | E2 | SCP0007 기간 칸 글자 입력 | NOT_RUN | NA | 기간 조회조건 없음 |  |
| V-37379f57 | E2 | SCP0007 기간 역전 조회 | NOT_RUN | NA | From·To 기간 조회조건 없음 |  |
| V-30bb6013 | F4 | SCP0007 Division별 조회 오류 | NOT_RUN | PASS | 다중 선택 Division(요청 '81,40,82,81_UC,81_HM,81_ST,81_') — 값별 순회 불가 · 전체 조회 오류 0 · 행 2430 |  |
| V-14575d25 | A2 | SCP0007 콤보 칸 이름 표시 | NOT_RUN | ERROR | [확인 대상] 콤보 칸 7개 중 후보에 없는 코드가 그대로 보이는 칸 1개: TO_SITE_CODE 6행(EVThai_TH_BKK) — 비활성 코드 여부 확인 |  |
| V-4e0f5e4a | M2 | SCP0007 전용 버튼 확인창 | NOT_RUN | NA | 화면 전용 버튼 없음(보이는 버튼 19개) |  |
| V-fb699aac | D1 | SCP0007 편집 모드 구분 | NOT_RUN | PASS | Edit 버튼 없이 조회 직후 편집 가능 칸 6개 |  |
| V-720d13da | F3 | SCP0007 붙여넣기 후보 외 값 | NOT_RUN | PASS | DIVISION_ID 후보 밖 값 거부 — '81_HG' → '' |  |
| V-729e3839 | N1 | SCP0007 센티널 표시 | NOT_RUN | PASS | 센티널 '/' 노출 0 (본 칸 10200) |  |
| V-a6211c7d | H8 | SCP0007 총 건수 천단위 | NOT_RUN | PASS | 총 건수 '총16,439'(행 16439) |  |
| V-8fc42c93 | A5 | SCP0007 컬럼 순서 | NOT_RUN | ERROR | [확인 대상] 컬럼 순서 다름 27번째 AS-IS REMARKS ↔ TO-BE TO_YYYYMMDD (시트 BOD · 공통 34개) — 관리자 메타 변경·계정 개인화일 수 있어 결 |  |
| V-8de8bc9b | J4 | SCP0007 메뉴 오픈 | NOT_RUN | PASS | 메뉴 오픈 정상 — 404·요청 실패 0 |  |
| V-7ef50041 | J4 | SCP0007 탭 이름 | NOT_RUN | PASS | 탭 'BOD' = 메뉴 등록 이름 |  |
| V-52f64711 | G4 | SCP0007 돋보기 위치 | NOT_RUN | NA | 돋보기 버튼 달린 입력칸 없음 · 좌표 [] |  |
| V-fc172166 | G2 | SCP0007 복수 선택 조회 | NOT_RUN | PASS | From Site 'WA00-P,HQ05-W' 조회 583행 · 조건 밖 0 |  |
| V-657f6e5c | B6 | SCP0007 단일 선택 조회 | NOT_RUN | PASS | Active 'N' 조회 2184행 · 조건 밖 0 |  |
| V-6302ae85 | G2 | SCP0007 전체 재선택 왕복 | NOT_RUN | PASS | Active 전체 16439→선택 2184→전체 16439 |  |
| V-12075de0 | H7 | SCP0007 Excel 컬럼 구성 | NOT_RUN | PASS | Excel 머리글 34개 = 화면 컬럼 |  |
| V-e49f5de9 | H7 | SCP0007 Excel 코드 표시 | NOT_RUN | PASS | 콤보 1칸 Excel = Name · 첫 데이터 행 기준(정렬이 같다는 전제) |  |
| V-8fdbfbe8 | H7 | SCP0007 Excel 틀 고정 | NOT_RUN | PASS | 틀 고정 J3 |  |
| V-415709da | H7 | SCP0007 Excel 숫자 서식 | NOT_RUN | PASS | 숫자 칸 800개 · General 0 · 서식 #,##0 |  |
| V-157cb3ca | H4 | SCP0007 조회조건 겹침 1920 | NOT_RUN | PASS | 폭 1920 조회조건 8칸 겹침·넘침 없음 |  |
| V-d1bdaded | H4 | SCP0007 조회조건 겹침 1366 | NOT_RUN | PASS | 폭 1366 조회조건 8칸 겹침·넘침 없음 · 가로 스크롤로 도달 Incoterms,Active(최소 폭 1460 설계) |  |
| V-4fa0a708 | A5 | SCP0007 Division 컬럼 40/BOD | NOT_RUN | PASS | BOD · 시트 확정: 메타 정의 대조 — 그리드 컬럼 34개 중 100% 가 'bod'(정의 39컬럼) · Div 40 대조 39컬럼 일치 |  |
| V-dbd8ccb5 | A5 | SCP0007 Division 컬럼 81/BOD | NOT_RUN | NA | Div 81 이 계정 Division 후보에 없음 — 계정 순회는 E03 |  |
| V-2ae6f845 | A5 | SCP0007 Division 컬럼 82/BOD | NOT_RUN | NA | Div 82 이 계정 Division 후보에 없음 — 계정 순회는 E03 |  |
| V-50cc6044 | M1 | SCP0007 Excel 양식 | NOT_RUN | NA | Excel Form 버튼 없음 · AS-IS 진입점에도 없음 |  |
| V-9b1f1085 | E3 | SCP0007 Excel 필수 칸 빈 업로드 | NOT_RUN | NA | Excel Upload 버튼 없음 · 요청 0건 [] · 응답 없음 |  |
| V-00d75fc9 | G5 | SCP0007 Excel 양식 버킷 | NOT_RUN | NA | 양식 파일 없음 |  |
| V-ed2798b2 | H7 | SCP0007 Excel 양식 2단 머리글 | NOT_RUN | NA | 문서가 2단 머리글을 정하지 않은 화면 |  |
| V-b6a3fa1e | M1 | SCP0007 Excel 2단계 차단 | NOT_RUN | NA | Excel Upload 버튼 없음 |  |
| V-d99cc7f3 | M1 | SCP0007 Excel 잘못된 업로드 | NOT_RUN | NA | Excel Upload 버튼 없음 |  |
| V-23aa986c | K1 | SCP0007 필터 유지 재조회 | NOT_RUN | PASS | TRANSPORT_MODE · 필터 16439→47행 · 재조회 47행 유지 · 건수 표시 '총47' · 해제 16439행 복원 |  |
| V-6264a210 | A3 | SCP0007 합계 값 | NOT_RUN | NA | 합계 행·합계 칸 없음(AS-IS 합계 유무 대조는 A3 원장 행) |  |
| V-b4659a1e | F1 | SCP0007 컬럼별 저장 왕복 | NOT_RUN | ERROR | 편집 가능 6컬럼 중 왕복 3 · 입력 경로 실패 1 · 변경 인식 실패 0 · 업무 검증 차단·사유 불명 0 · 값 불일치 0 — PRIORITY: 입력 경로 실패: 입력 안 됨 |  |
| V-fa7c647c | F6 | SCP0007 빈값 저장 | NOT_RUN | ERROR | PRIORITY r8247 '10'→빈값 [AS-IS 검증 근거 없음] 저장 전 화면 검증 거부 · 원복 OK · 화면 메시지 '[Priority] 값은 필수 입력 항목입니다.' |  |
| V-592e9315 | F1 | SCP0007 저장 실패 처리 | NOT_RUN | PASS | PRIORITY r8247 → 9 · 실패 문구 표시 '[저장 경로 시험] 강제 실패' |  |
| V-c7ed3d79 | H10 | SCP0007 저장 취소 요청 없음 | NOT_RUN | NA | PRIORITY r8247 → 9 · 확인창 없음 · AS-IS 저장 경로에도 확인 코드 없음 |  |
| V-ad51f87e | H11 | SCP0007 저장 중 로딩 | NOT_RUN | PASS | PRIORITY r8247 → 9 · 로딩 표시 29회 관측 · 응답 뒤 소멸 · 표본 34개·저장 구간 1508ms |  |
| V-b34c30a9 | F2 | SCP0007 붙여넣기 저장 인식 | NOT_RUN | PASS | AFTER_LEAD_TIME r8247 '1' ← 붙여넣기 '91'(이 컬럼에 없는 값) · 붙여넣은 뒤 칸 '91' · 붙여넣기 → 저장 요청 1건 · 본문에 값 있음 |  |
| V-4a4d3857 | E3 | SCP0007 필수 공란 bod.DIVISION_ID | NOT_RUN | ERROR | [대조군 실패] 시트 bod 대조군 blocked · INCOTERMS 를 채웠는데도 같은 문구(팝업 입력 실패) · 문구 '[Incoterms] 값은 필수 입력 항목입니다.' — |  |
| V-21296153 | E3 | SCP0007 필수 공란 bod.FROM_SITE_CODE | NOT_RUN | ERROR | [대조군 실패] 시트 bod 대조군 blocked · INCOTERMS 를 채웠는데도 같은 문구(팝업 입력 실패) · 문구 '[Incoterms] 값은 필수 입력 항목입니다.' — |  |
| V-6c9e72bc | E3 | SCP0007 필수 공란 bod.INCOTERMS | NOT_RUN | ERROR | [대조군 실패] 전 칸을 채워도 저장이 막힘 · 문구 '[Incoterms] 값은 필수 입력 항목입니다.' — 이 컬럼 공란이 원인인지 판정 불가 |  |
| V-d3d97fb9 | E3 | SCP0007 필수 공란 bod.TO_SITE_CODE | NOT_RUN | ERROR | [대조군 실패] 시트 bod 대조군 blocked · INCOTERMS 를 채웠는데도 같은 문구(팝업 입력 실패) · 문구 '[Incoterms] 값은 필수 입력 항목입니다.' — |  |
| V-b16abbc1 | E4 | SCP0007 키 중복 신규행 | NOT_RUN | ERROR | bod · [차단 사유 확인 필요] 중복 문구가 아님 '[Incoterms] 값은 필수 입력 항목입니다.' |  |
| V-28ec84cc | F7 | SCP0007 2회 저장 행 수 | NOT_RUN | PASS | AS-IS 신규행 경로 테이블 SCP_MST_BOD 모두 기록 · UPDATE 만(신규 1건 시험 대상 아님): SCP_MST_BOD_ITEM · TO-BE 에만 기록(참고 — A |  |
| V-0466cf7a | F8 | SCP0007 이력 행 값 | NOT_RUN | PASS | 감사 컬럼 = 저장 계정·저장 시각 (CREATED_BY=minyonglee1 · CREATION_DATE=2026-11-14 08:08:44 · LAST_UPDATED_BY=mi |  |
| V-77c15599 | E5 | SCP0007 입력검증 콤보키인 BOD_VALID | NOT_RUN | PASS | BOD_VALID r0 원값 'N' · 'ZZZ_E2E_BAD' 입력 뒤 칸 'N' · 저장 요청 없음 · 문구 '수정한 내용이 없습니다.' |  |
| V-0ff27ace | E5 | SCP0007 입력검증 콤보붙여넣기 BOD_VALID | NOT_RUN | PASS | BOD_VALID r0 원값 'N' · 'ZZZ_E2E_BAD' 입력 뒤 칸 '' · 저장 요청 없음 · 문구 '[Active] 값은 필수 입력 항목입니다.' |  |
| V-c86d727d | E2 | SCP0007 입력검증 날짜 CREATION_DATE | NOT_RUN | NA | Division 기본 순회 — CREATION_DATE 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-835dba42 | E5 | SCP0007 입력검증 콤보키인 FROM_SITE_CODE | NOT_RUN | NA | Division 기본 순회 — FROM_SITE_CODE 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-613360f6 | E5 | SCP0007 입력검증 콤보붙여넣기 FROM_SITE_CODE | NOT_RUN | NA | Division 기본 순회 — FROM_SITE_CODE 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-8c78c6cb | E2 | SCP0007 입력검증 날짜 FROM_YYYYMMDD | NOT_RUN | PASS | FROM_YYYYMMDD r0 원값 '2024-12-30' · '2026-13-45' 입력 뒤 칸 '2026-13-45' · 저장 요청 없음 · 문구 '유효한 날짜 형식이 아닙니다 |  |
| V-64753f65 | E5 | SCP0007 입력검증 콤보키인 INCOTERMS | NOT_RUN | NA | Division 기본 순회 — INCOTERMS 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-5028705c | E5 | SCP0007 입력검증 콤보붙여넣기 INCOTERMS | NOT_RUN | NA | Division 기본 순회 — INCOTERMS 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-ce11a2da | E5 | SCP0007 입력검증 콤보키인 INCOTERMS_SSP | NOT_RUN | NA | Division 기본 순회 — INCOTERMS_SSP 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-46c27e63 | E5 | SCP0007 입력검증 콤보붙여넣기 INCOTERMS_SSP | NOT_RUN | NA | Division 기본 순회 — INCOTERMS_SSP 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-e775f1e3 | E2 | SCP0007 입력검증 날짜 LAST_UPDATE_DATE | NOT_RUN | NA | Division 기본 순회 — LAST_UPDATE_DATE 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-b56f780b | E1 | SCP0007 입력검증 음수 PRIORITY | NOT_RUN | PASS | PRIORITY r0 원값 '1' · '-1' 입력 뒤 칸 '1' · 저장 요청 없음 |  |
| V-009416a3 | E1 | SCP0007 입력검증 음수 SAFETY_STOCK | NOT_RUN | NA | Division 기본 순회 — SAFETY_STOCK(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-4d23c420 | E1 | SCP0007 입력검증 소수 SAFETY_STOCK | NOT_RUN | NA | Division 기본 순회 — SAFETY_STOCK(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-f47e09b5 | E2 | SCP0007 입력검증 날짜 SHIP_DOC_PREPARATION_DATE | NOT_RUN | NA | Division 기본 순회 — SHIP_DOC_PREPARATION_DATE(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-68545fb0 | E5 | SCP0007 입력검증 콤보키인 TO_SITE_CODE | NOT_RUN | NA | Division 기본 순회 — TO_SITE_CODE 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-7a412112 | E5 | SCP0007 입력검증 콤보붙여넣기 TO_SITE_CODE | NOT_RUN | NA | Division 기본 순회 — TO_SITE_CODE 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-7a40185c | E2 | SCP0007 입력검증 날짜 TO_YYYYMMDD | NOT_RUN | PASS | TO_YYYYMMDD r0 원값 '2100-01-03' · '2026-13-45' 입력 뒤 칸 '2026-13-45' · 저장 요청 없음 · 문구 '유효한 날짜 형식이 아닙니다.  |  |
| V-7d88137f | E5 | SCP0007 입력검증 콤보키인 VMI_YN | NOT_RUN | NA | Division 기본 순회 — VMI_YN 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-b121a936 | E5 | SCP0007 입력검증 콤보붙여넣기 VMI_YN | NOT_RUN | NA | Division 기본 순회 — VMI_YN 값 있는 편집 행 없음(표시 여부는 A5·편집은 D1 행에서 판정) |  |
| V-5e768a03 | F4 | SCP0007 경계값 저장 | NOT_RUN | PASS | PRIORITY r8247 원값 '10' · 경계값 '99' 저장·재조회 '99' 일치 · 원복 OK |  |
| V-2ef52662 | F1 | SCP0007 2행 동시 저장 | NOT_RUN | PASS | PRIORITY 저장 1회 — r8247 '10'→'11' 재조회 '11' OK · r14814 '1'→'2' 재조회 '2' OK · 원복 '10' OK · 원복 '1' OK |  |
| V-73196b80 | F6 | SCP0007 0 값 저장 | NOT_RUN | PASS | PRIORITY r8247 '10'→0 재조회 '0' · 원복 OK |  |
| V-37f703a6 | H11 | SCP0007 화면 | NOT_RUN | 판정필요 | [시험 검사 CM-003 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T98 — 병렬 call-proc |  |
| V-1236254c | H12 | SCP0007 화면 | NOT_RUN | PASS | 고정 컬럼 9개 [DIVISION_ID, CUSTOMER, FROM_SITE_CODE, FROM_CITY, TO_SITE_CODE, TO_CITY, VMI_YN, INCOTERMS |  |
| V-f0bebd84 | J3 | SCP0007 화면 | NOT_RUN | NA | AS-IS 잠금 규칙에 권한 그룹(GROUP) 조건이 있는 컬럼 없음 — 권한별 편집 구간 없음 |  |
| V-1db4f99c | A6 | SCP0007_GET_BOD | NOT_RUN | PASS | AS-IS ORDER BY [DIVISION_ID,ROUTE_CNT,CUSTOMER,INCOTERMS,FROM_SITE_CODE,TO_SITE_CODE,PRIORITY,ROUTE_ |  |
| V-2fdb9660 | A6 | SCP0007_GET_BOD | NOT_RUN | 판정필요 | [SORT 기준 차이 → 판정필요] 정렬 기준이 AS-IS 와 다름 — 결함 여부는 사람이 판정(사용자 지시 2026-10-30) · AS-IS ORDER BY [DIVISION_ |  |
| V-09896524 | A6 | SCP0007_GET_COUNTRY_CITY | NOT_RUN | NA | AS-IS ORDER BY [] ↔ TO-BE PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY [] — AS-IS·TO-BE 모두 ORDER BY 없음 — 그 |  |
| V-931cc36b | A6 | SCP0007_GET_ROUTE_CNT | NOT_RUN | NA | AS-IS ORDER BY [] ↔ TO-BE PKG_SCP0007.P_SCP0007_GET_ROUTE_CNT [] — AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드  |  |
| V-94fb0a61 | A6 | SCP0005_GET_DISTRIBUTION_ROUTE | NOT_RUN | PASS | AS-IS ORDER BY [FROM_COUNTRY,FROM_CITY,TO_COUNTRY,TO_CITY,PRIORITY] ↔ TO-BE PKG_SCP0005.P_SCP0005_GE |  |
| V-96b515e6 | A7 | SCP0007_GET_BOD | NOT_RUN | ERROR | 공통 컬럼 40 중 공란 컬럼 0 · 확인 필요 9 — CUSTOMER: 같은 키(bodid) 6549행 중 16행 값 다름(0%) 예: 21109: ''↔'-' / 20923:  |  |
| V-0fd79a9e | A7 | SCP0007_GET_COUNTRY_CITY | NOT_RUN | PASS | 공통 컬럼 6 중 공란 컬럼 0 · 확인 필요 0 — 전 컬럼 채움 이상 없음 |  |
| V-785ad655 | A7 | SCP0007_GET_ROUTE_CNT | NOT_RUN | PASS | 공통 컬럼 1 중 공란 컬럼 0 · 확인 필요 0 — 전 컬럼 채움 이상 없음 |  |
| V-3f26dae2 | A7 | SCP0005_GET_DISTRIBUTION_ROUTE | NOT_RUN | PASS | 공통 컬럼 41 중 공란 컬럼 0 · 확인 필요 0 — 전 컬럼 채움 이상 없음 |  |
| V-8984752c | B1 | 조회조건 Div | NOT_RUN | PASS | 조회조건 Div 후보 8건 · 빈 항목 0 |  |
| V-6fe1b5df | B2 | 조회조건 Div | NOT_RUN | PASS | 조회조건 Div 후보 8건 · 중복 0 |  |
| V-4b761f8f | B3 | 조회조건 Div | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 원문 ORDER BY 있음·정렬 키 해석 불가 — AS-IS 반환 순서와 일치: TO-BE ['81', '40', '82', '81_UC', '8 |  |
| V-cfe8ad95 | B4 | 조회조건 Div | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 후보 8건 집합 일치 · 원천 UP_FX_GetCommonDataList_SCP Division @InitControls (SCP0007_BOD. |  |
| V-dbf21cec | B6 | 조회조건 Div | NOT_RUN | PASS | 조회조건 Div: 다중선택 기대 true/화면 true · ALL 기대 true/화면 true |  |
| V-e7c5e387 | B7 | 조회조건 Div | NOT_RUN | PASS | NA: (a) 저장 SP SCP0007_SAVE_BOD 대상 SCP_MST_BOD, SCP_MST_BOD_ITEM 와 콤보 원천 23종이 읽는 테이블이 겹치지 않음 — 이 화면 저 |  |
| V-58989d05 | G1 | 조회조건 Div | NOT_RUN | PASS | [멀티선택 Div] '40 Mobility & IT Battery' 1개 선택 조회 → 8194행 · DIVISION_ID 값 전부 일치 (기본 ALL 16438행) · 조회 요청 |  |
| V-91d279c6 | G2 | 조회조건 Div | NOT_RUN | PASS | [멀티선택 Div] ALL 선택 조회 → 16438행 (개별 8194행) |  |
| V-bbff3d7d | G4 | 조회조건 Div | NOT_RUN | PASS | 기준 순서 1번째 'Div' — 화면 1번째 (화면 순서: Div. → From Site → To Site → Incoterms → SSP Incoterms → Trans Mode |  |
| V-1803221e | G7 | 조회조건 Div | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] AS-IS 표시 NAME (UsrCheckedList2.DataSource → row[1]=NAME) = TO-BE 표시 NAME (CODE≠NA |  |
| V-9bf39709 | H5 | 조회조건 Div | NOT_RUN | PASS | 기준 명칭 'Div' — 화면 라벨 일치 nscm-fe/features/supply/src/pages/bod/components/BodForm.tsx:77 · 기준표 라벨(CR-0 |  |
| V-19913349 | C1 | 조회조건 Div | NOT_RUN | PASS | 상속(TRACE T-f01e425e): 'Div' → '81 Automotive Battery' 변경 · 콤보 재요청 6건 · 하위 clbFromSite(사전 선택 'CN00254 |  |
| V-03e9952a | J1 | 조회조건 Div | NOT_RUN | PASS | Division 후보 8건 [81 Automotive Battery, 40 Mobility & IT Battery, 82 ESS Battery, 81_UC Automotive Ba |  |
| V-5d5210dd | B1 | 조회조건 From Site | NOT_RUN | PASS | 조회조건 From Site 후보 104건 · 빈 항목 0 |  |
| V-85e323af | B2 | 조회조건 From Site | NOT_RUN | PASS | 조회조건 From Site 후보 104건 · 중복 0 |  |
| V-602bf6d8 | B3 | 조회조건 From Site | NOT_RUN | NA | [화면 초기(선택 없음=ALL)] AS-IS 원천에 정렬 근거(ORDER BY) 없음 — 순서 기준 없음 · 원천 UP_FX_GetCommonDataList_SCP_ALL From |  |
| V-776c8c10 | B4 | 조회조건 From Site | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 차이 7건 모두 데이터 차이(AS-IS DEV↔사내 시점) — 조건 동일 · AS-IS만 0 [] · TO-BE만 7 ['AC00-A', 'AT0 |  |
| V-ea0d3c71 | B6 | 조회조건 From Site | NOT_RUN | PASS | 조회조건 From Site: 다중선택 기대 true/화면 true · ALL 기대 true/화면 true |  |
| V-8884a3a7 | B7 | 조회조건 From Site | NOT_RUN | PASS | NA: (a) 저장 SP SCP0007_SAVE_BOD 대상 SCP_MST_BOD, SCP_MST_BOD_ITEM 와 콤보 원천 23종이 읽는 테이블이 겹치지 않음 — 이 화면 저 |  |
| V-234d6337 | G1 | 조회조건 From Site | NOT_RUN | PASS | [멀티선택 From Site] 'WA00-P' 1개 선택 조회 → 524행 · FROM_SITE_CODE 값 전부 일치 (기본 ALL 16438행) · 조회 요청 1건(본문에 'W |  |
| V-9066f84f | G2 | 조회조건 From Site | NOT_RUN | PASS | [멀티선택 From Site] ALL 선택 조회 → 16282행 (개별 524행) |  |
| V-28ae7dcc | G4 | 조회조건 From Site | NOT_RUN | PASS | 기준 순서 2번째 'From Site' — 화면 2번째 (화면 순서: Div. → From Site → To Site → Incoterms → SSP Incoterms → Tran |  |
| V-87f65a7a | G7 | 조회조건 From Site | NOT_RUN | NA | [화면 초기(선택 없음=ALL)] AS-IS 후보 CODE=NAME(형식 구분 불가) · AS-IS 표시 NAME (UsrCheckedList2.DataSource → row[1] |  |
| V-c0b2833e | H5 | 조회조건 From Site | NOT_RUN | PASS | 기준 명칭 'From Site' — 화면 라벨 일치 nscm-fe/features/supply/src/pages/bod/components/BodForm.tsx:94 · 기준표 라 |  |
| V-3658dbba | B1 | 조회조건 To Site | NOT_RUN | PASS | 조회조건 To Site 후보 2654건 · 빈 항목 0 |  |
| V-09841a1f | B2 | 조회조건 To Site | NOT_RUN | PASS | 조회조건 To Site 후보 2654건 · 중복 0 |  |
| V-1c62ce34 | B3 | 조회조건 To Site | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 공통 2592건이 ORDER BY ['SITE_TYPE'] 키 순서(동률 내부 순서는 기준 없음) · 원천 UP_FX_GetCommonDataLi |  |
| V-a865d23d | B4 | 조회조건 To Site | NOT_RUN | ERROR | [화면 초기(선택 없음=ALL)] AS-IS 2662건 vs TO-BE 2654건 · 차이 2건 설명 불가: 제일무역_ID_JKT: 미검사(60건 초과); 제일무역_KR_SEL:  |  |
| V-7f43cda1 | B6 | 조회조건 To Site | NOT_RUN | PASS | 조회조건 To Site: 다중선택 기대 true/화면 true · ALL 기대 true/화면 true |  |
| V-aa4e9b06 | B7 | 조회조건 To Site | NOT_RUN | PASS | NA: (a) 저장 SP SCP0007_SAVE_BOD 대상 SCP_MST_BOD, SCP_MST_BOD_ITEM 와 콤보 원천 23종이 읽는 테이블이 겹치지 않음 — 이 화면 저 |  |
| V-ef3f2f85 | G1 | 조회조건 To Site | NOT_RUN | PASS | [멀티선택 To Site] 'Bmspow_TW_TPE' 1개 선택 조회 → 1행 · TO_SITE_CODE 값 전부 일치 (기본 ALL 16438행) · 조회 요청 1건(본문에 ' |  |
| V-2ecba37b | G2 | 조회조건 To Site | NOT_RUN | PASS | [멀티선택 To Site] ALL 선택 조회 → 15541행 (개별 1행) |  |
| V-9d8baf9c | G4 | 조회조건 To Site | NOT_RUN | PASS | 기준 순서 3번째 'To Site' — 화면 3번째 (화면 순서: Div. → From Site → To Site → Incoterms → SSP Incoterms → Trans  |  |
| V-be763264 | G7 | 조회조건 To Site | NOT_RUN | NA | [화면 초기(선택 없음=ALL)] AS-IS 후보 CODE=NAME(형식 구분 불가) · AS-IS 표시 NAME (UsrCheckedList2.DataSource → row[1] |  |
| V-872c53d4 | H5 | 조회조건 To Site | NOT_RUN | PASS | 기준 명칭 'To Site' — 화면 라벨 일치 nscm-fe/features/supply/src/pages/bod/components/BodForm.tsx:110 · 기준표 라벨 |  |
| V-8403f642 | B1 | 조회조건 Incoterms | NOT_RUN | PASS | 조회조건 Incoterms 후보 16건 · 빈 항목 0 |  |
| V-96afb38e | B2 | 조회조건 Incoterms | NOT_RUN | PASS | 조회조건 Incoterms 후보 16건 · 중복 0 |  |
| V-f9b1cdbd | B3 | 조회조건 Incoterms | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 공통 16건이 ORDER BY ['DISPLAY_SEQ'] 키 순서(동률 내부 순서는 기준 없음) · 원천 UP_FX_GetCommonDataLi |  |
| V-b89d881d | B4 | 조회조건 Incoterms | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 후보 16건 집합 일치 · 원천 UP_FX_GetCommonDataList LookupCommon @InitControls (SCP0007_BOD |  |
| V-e0aae7cc | B6 | 조회조건 Incoterms | NOT_RUN | PASS | 조회조건 Incoterms: 다중선택 기대 true/화면 true · ALL 기대 true/화면 true |  |
| V-4a1639e3 | B7 | 조회조건 Incoterms | NOT_RUN | PASS | NA: (a) 저장 SP SCP0007_SAVE_BOD 대상 SCP_MST_BOD, SCP_MST_BOD_ITEM 와 콤보 원천 23종이 읽는 테이블이 겹치지 않음 — 이 화면 저 |  |
| V-b873839f | G1 | 조회조건 Incoterms | NOT_RUN | PASS | [멀티선택 Incoterms] 'CFR' 1개 선택 조회 → 50행 · INCOTERMS 값 전부 일치 (기본 ALL 16438행) · 조회 요청 1건(본문에 'CFR' 포함) |  |
| V-4cdfbad1 | G2 | 조회조건 Incoterms | NOT_RUN | PASS | [멀티선택 Incoterms] ALL 선택 조회 → 16415행 (개별 50행) |  |
| V-bdfcc790 | G4 | 조회조건 Incoterms | NOT_RUN | PASS | 기준 순서 4번째 'Incoterms' — 화면 4번째 (화면 순서: Div. → From Site → To Site → Incoterms → SSP Incoterms → Tran |  |
| V-e8b09ca5 | G7 | 조회조건 Incoterms | NOT_RUN | NA | [화면 초기(선택 없음=ALL)] AS-IS 후보 CODE=NAME(형식 구분 불가) · AS-IS 표시 NAME (UsrCheckedList2.DataSource → row[1] |  |
| V-ae69dd03 | H5 | 조회조건 Incoterms | NOT_RUN | PASS | 기준 명칭 'Incoterms' — 화면 라벨 일치 nscm-fe/features/supply/src/pages/bod/components/BodForm.tsx:126 · 기준표  |  |
| V-97a77def | B1 | 조회조건 SSP Incoterms | NOT_RUN | PASS | 조회조건 SSP Incoterms 후보 16건 · 빈 항목 0 |  |
| V-78e530b2 | B2 | 조회조건 SSP Incoterms | NOT_RUN | PASS | 조회조건 SSP Incoterms 후보 16건 · 중복 0 |  |
| V-8acad48f | B3 | 조회조건 SSP Incoterms | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 공통 16건이 ORDER BY ['DISPLAY_SEQ'] 키 순서(동률 내부 순서는 기준 없음) · 원천 UP_FX_GetCommonDataLi |  |
| V-0a7b9f83 | B4 | 조회조건 SSP Incoterms | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 후보 16건 집합 일치 · 원천 UP_FX_GetCommonDataList LookupCommon @InitControls (SCP0007_BOD |  |
| V-cbc1c037 | B6 | 조회조건 SSP Incoterms | NOT_RUN | PASS | 조회조건 SSP Incoterms: 다중선택 기대 true/화면 true · ALL 기대 true/화면 true |  |
| V-ae2270c9 | B7 | 조회조건 SSP Incoterms | NOT_RUN | PASS | NA: (a) 저장 SP SCP0007_SAVE_BOD 대상 SCP_MST_BOD, SCP_MST_BOD_ITEM 와 콤보 원천 23종이 읽는 테이블이 겹치지 않음 — 이 화면 저 |  |
| V-9cb4d91c | G1 | 조회조건 SSP Incoterms | NOT_RUN | PASS | [멀티선택 SSP Incoterms] 'CFR' 1개 선택 조회 → 50행 · INCOTERMS_SSP 값 전부 일치 (기본 ALL 16438행) · 조회 요청 1건(본문에 'CF |  |
| V-67f4b088 | G2 | 조회조건 SSP Incoterms | NOT_RUN | PASS | [멀티선택 SSP Incoterms] ALL 선택 조회 → 16414행 (개별 50행) |  |
| V-f2cdf8e9 | G4 | 조회조건 SSP Incoterms | NOT_RUN | PASS | 기준 순서 5번째 'SSP Incoterms' — 화면 5번째 (화면 순서: Div. → From Site → To Site → Incoterms → SSP Incoterms →  |  |
| V-05867795 | G7 | 조회조건 SSP Incoterms | NOT_RUN | NA | [화면 초기(선택 없음=ALL)] AS-IS 후보 CODE=NAME(형식 구분 불가) · AS-IS 표시 NAME (UsrCheckedList2.DataSource → row[1] |  |
| V-c3744437 | H5 | 조회조건 SSP Incoterms | NOT_RUN | PASS | 기준 명칭 'SSP Incoterms' — 화면 라벨 일치 nscm-fe/features/supply/src/pages/bod/components/BodForm.tsx:142 ·  |  |
| V-1d917086 | B1 | 조회조건 Trans Mode | NOT_RUN | PASS | 조회조건 Trans Mode 후보 5건 · 빈 항목 0 |  |
| V-d833b0b0 | B2 | 조회조건 Trans Mode | NOT_RUN | PASS | 조회조건 Trans Mode 후보 5건 · 중복 0 |  |
| V-1f2db59b | B3 | 조회조건 Trans Mode | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 공통 5건이 ORDER BY ['DISPLAY_SEQ'] 키 순서(동률 내부 순서는 기준 없음) · 원천 UP_FX_GetCommonDataLis |  |
| V-f9feefe5 | B4 | 조회조건 Trans Mode | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 후보 5건 집합 일치 · 원천 UP_FX_GetCommonDataList LookupCommon @InitControls (SCP0007_BOD. |  |
| V-c61dd119 | B6 | 조회조건 Trans Mode | NOT_RUN | PASS | 조회조건 Trans Mode: 다중선택 기대 true/화면 true · ALL 기대 true/화면 true · 기대 원천 AS-IS 원문 UsrCheckedList |  |
| V-63acbd67 | B7 | 조회조건 Trans Mode | NOT_RUN | PASS | NA: (a) 저장 SP SCP0007_SAVE_BOD 대상 SCP_MST_BOD, SCP_MST_BOD_ITEM 와 콤보 원천 23종이 읽는 테이블이 겹치지 않음 — 이 화면 저 |  |
| V-4b6d23bd | G1 | 조회조건 Trans Mode | NOT_RUN | PASS | [멀티선택 Trans Mode] 'RAIL' 1개 선택 조회 → 47행 · TRANSPORT_MODE 값 전부 일치 (기본 ALL 16438행) · 조회 요청 1건(본문에 'RAI |  |
| V-13c16ecc | G2 | 조회조건 Trans Mode | NOT_RUN | PASS | [멀티선택 Trans Mode] ALL 선택 조회 → 16438행 (개별 47행) |  |
| V-b3fadcf9 | G4 | 조회조건 Trans Mode | NOT_RUN | PASS | 기준 순서 6번째 'Trans Mode' — 화면 6번째 (화면 순서: Div. → From Site → To Site → Incoterms → SSP Incoterms → Tra |  |
| V-7aa14345 | G7 | 조회조건 Trans Mode | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] AS-IS 표시 NAME (UsrCheckedList2.DataSource → row[1]=NAME) = TO-BE 표시 NAME (CODE≠NA |  |
| V-207497ac | H5 | 조회조건 Trans Mode | NOT_RUN | PASS | 기준 명칭 'Trans Mode' — 화면 라벨 일치 nscm-fe/features/supply/src/pages/bod/components/BodForm.tsx:158 · 기준표 |  |
| V-00f9cb10 | B1 | 조회조건 Status | NOT_RUN | PASS | 조회조건 Status 후보 2건 · 빈 항목 0 |  |
| V-385fe9d0 | B2 | 조회조건 Status | NOT_RUN | PASS | 조회조건 Status 후보 2건 · 중복 0 |  |
| V-b9912083 | B3 | 조회조건 Status | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 고정 목록 순서 일치: TO-BE ['R', 'C'] / AS-IS ['R', 'C'] · 원천 STATIC dtInputStatus @InitC |  |
| V-7130ba95 | B4 | 조회조건 Status | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 후보 2건 집합 일치 · 원천 STATIC dtInputStatus @InitControls (SCP0007_BOD.cs:222 ← SCP0007 |  |
| V-6fd48b99 | B6 | 조회조건 Status | NOT_RUN | PASS | 조회조건 Status: 다중선택 기대 false/화면 false · ALL 기대 false/화면 false · 기대 원천 AS-IS 원문 UsrCombo |  |
| V-3908150c | B7 | 조회조건 Status | NOT_RUN | PASS | NA: (a) 저장 SP SCP0007_SAVE_BOD 대상 SCP_MST_BOD, SCP_MST_BOD_ITEM 와 콤보 원천 23종이 읽는 테이블이 겹치지 않음 — 이 화면 저 |  |
| V-80075f7b | G1 | 조회조건 Status | NOT_RUN | PASS | [단일선택 Status] 'Required' → 680행 · ROUTE_ID 빈값 500/500 OK ／ 'Completed' → 16438행 · ROUTE_ID 빈값 0/500  |  |
| V-09eb03c4 | G2 | 조회조건 Status | NOT_RUN | NA | Status 단일 선택 콤보 — ALL/다중 사양 대상 아님 |  |
| V-d1601e85 | G4 | 조회조건 Status | NOT_RUN | PASS | 기준 순서 7번째 'Status' — 화면 7번째 (화면 순서: Div. → From Site → To Site → Incoterms → SSP Incoterms → Trans M |  |
| V-78501cb7 | G7 | 조회조건 Status | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] AS-IS 표시 NAME (UsrCombo DisplayMember=NAME @SCP0007_BOD.cs:222) = TO-BE 표시 NAME ( |  |
| V-c19f9d66 | H5 | 조회조건 Status | NOT_RUN | PASS | 기준 명칭 'Status' — 화면 라벨 일치 nscm-fe/features/supply/src/pages/bod/components/BodForm.tsx:174 · AS-IS ' |  |
| V-442243f5 | B1 | 조회조건 Active | NOT_RUN | PASS | 조회조건 Active 후보 2건 · 빈 항목 0 |  |
| V-77f9bb25 | B2 | 조회조건 Active | NOT_RUN | PASS | 조회조건 Active 후보 2건 · 중복 0 |  |
| V-480f7c71 | B3 | 조회조건 Active | NOT_RUN | PASS | [화면 초기(선택 없음=ALL)] 고정 목록 순서 일치: TO-BE ['Y', 'N'] / AS-IS ['Y', 'N'] · 원천 STATIC YesOrNo @InitControl |  |
