# 정적 게이트 SCP0104 — 2026-11-13 15:10

- 원장 3240행 · 정적 판정 2097행(ERROR 879 · FAIL 40 · NA 871 · PASS 304 · 판정필요 3) · 런타임(E2E) 보류 0행
- **직접 FAIL 0** · 사용자 판정 FAIL 0 · 정적 실측 규칙 35종: A1, A5, A6, B2, B3, B4, B6, C1, C2, C4, D1, D6, DB-SYN, F10, F5, G1, G2, G4, G5, G7, H1, H10, H3, H5, H7, I1, I4, J1, J4, K-SA, M3, MS1, X-LOC, X-REASON, X-ROW

## 직접 FAIL(정적)

| row_id | 규칙 | 대상 | 기대 원천 | 증거 |
|---|---|---|---|---|
| - | - | 없음 | | |

## ERROR 사유(정적)

- 159 진입점 집계 — 대조표 SCP0104
- 34  | [미검증] 검사기(_verify
- 28 진입점 집계 1검사 — ERROR:1
- 28 진입점 집계 2검사 — ERROR:1
- 18 이 표에 구현 위치 열이 없고 행에도
- 16 화면 초기(선택 Div=81)
- 13 규칙 B4 판정 3행 중 FAIL 0
- 13 원천 NICK_NAME 신규행 편집 
- 11 진입점 집계 2검사 — NOT_RUN
- 10 규칙 C2 판정 2행 중 FAIL 0
- 10 진입점 집계 4검사 — ERROR:3
- 9  | [미검증] 검사기(_trace.

## E2E 유래 FAIL(직전 실행 결과 · 이번 게이트 범위 밖 · 숨기지 않음) — 17행

- V-e44a626b A5 SCP0104 화면 — 그리드 컬럼 구성(AS-IS Div 40 기준 12컬럼 대조): 누락(AS-IS 표시인데 TO-BE 미표시) 2개 = DUMMY_YN, ELTR_LN_TP_CD · 추가 없음
- V-b9259c14 I2 SCP0104 화면 — 조회·Insert 후 '_' 폴백 노출: _Ver.
- V-6af7fe19 K3 SCP0104 화면 — copy PASS: 선택 0,0,0,0 · 0행 DIVISION_ID 표시값 '81' · Ctrl+C 클립보드 '81'(일치) · 우클릭 Copy '81'(일치) ／ ctrl PASS: Ctrl+클릭 0행·2행(DIVISION_ID) → 선택 범위 시
- V-d86a0134 D1 ELTR.NICK_NAME (Nickname) — 신규행 r0 NICK_NAME 편집=false (AS-IS 편집 가능)
- V-79b744aa K3 [DMF0020 결함 일반화] 결과 그리드 Sort/Filter(동적 주 — hide FAIL: 헤더(DIVISION_ID) 우클릭 → Hide Column → 컬럼 여전히 표시 · Unhide All 복원 · 미포함: Sort/Filter·정렬 후 동작(K1 smoke 행), 동적 Bucket 컬럼
- V-5d83a36f K3 [DMF0020 결함 유형] Exchange Rate 그리드 Copy·H — copy PASS: 선택 0,0,0,0 · 0행 DIVISION_ID 표시값 '81' · Ctrl+C 클립보드 '81'(일치) · 우클릭 Copy '81'(일치) ／ hide FAIL: 헤더(DIVISION_ID) 우클릭 → Hide Column → 
- T-6fb50552 D1 NICK_NAME / Nickname — 기존행 r0 NICK_NAME 편집=false — AS-IS 기대 미식별(edit_expect 'UNKNOWN') ／ 신규행 r0 NICK_NAME 편집=false (AS-IS 편집 가능)
- T-21b52657 C1 clbLine / Line — 'Line' → 'E5DP1 Elec Pilot #1-01' 변경 · 콤보 재요청 1건 · 하위 (없음) · 화면에서 못 찾은 AS-IS 하위 조건 clbElectrodeType,clbOperation · AS-IS 핸들러 -= clbLine_Sele
- T-dba78bc7 C2 DIVISION_ID / Div — 신규행 DIVISION_ID 콤보 후보 없음 — 내 Division 목록 콤보 미구현(D00-3-009)
- EG-00c8c971 J4 SCP0104 EG382 메뉴 트리 SCP/40/SCP Planner — 기대 그룹 1개 중 메뉴 권한 1개 → 노출 · 실제 트리에 없음 · AS-IS SCM_ADM_USER_GR_MNU_MPG_M
- EG-f9a90510 J4 SCP0104 EG382 메뉴 트리 SCP/40/SCP Tester — 기대 그룹 8개 중 메뉴 권한 3개 → 노출 · 실제 트리에 없음 · AS-IS SCM_ADM_USER_GR_MNU_MPG_M
- EG-3227f00d J4 SCP0104 EG382 메뉴 트리 SCP/40/SCM Viewer — 기대 그룹 2개 중 메뉴 권한 1개 → 노출 · 실제 트리에 없음 · AS-IS SCM_ADM_USER_GR_MNU_MPG_M
- EG-56ece477 J4 SCP0104 EG382 메뉴 트리 SCP/40/SCM PI Admin — 기대 그룹 2개 중 메뉴 권한 1개 → 노출 · 실제 트리에 없음 · AS-IS SCM_ADM_USER_GR_MNU_MPG_M
- EG-abaf6619 J4 SCP0104 EG382 메뉴 트리 SCP/81/SCP Planner — 기대 그룹 2개 중 메뉴 권한 1개 → 노출 · 실제 트리에 없음 · AS-IS SCM_ADM_USER_GR_MNU_MPG_M
- EG-597fc463 J4 SCP0104 EG382 메뉴 트리 SCP/81/SCM Viewer — 기대 그룹 2개 중 메뉴 권한 1개 → 노출 · 실제 트리에 없음 · AS-IS SCM_ADM_USER_GR_MNU_MPG_M
- EG-bde3c084 J4 SCP0104 EG382 메뉴 트리 SCP/81/SCM PI Admin — 기대 그룹 2개 중 메뉴 권한 1개 → 노출 · 실제 트리에 없음 · AS-IS SCM_ADM_USER_GR_MNU_MPG_M
- EG-5a0729e4 J4 SCP0104 EG382 메뉴 트리 SCP/82/SCM Viewer — 기대 그룹 2개 중 메뉴 권한 1개 → 노출 · 실제 트리에 없음 · AS-IS SCM_ADM_USER_GR_MNU_MPG_M

> 이 게이트는 CheckList 판을 만들지 않는다. E2E 가 필요한 행은 정규 실행(run_verify.py <ID>) 또는 부분 재판정(--only <규칙>)에서 판정한다.
