# 검사기 회귀 대조 SCP0084 — 기준 2026-11-07 15:20 (1629행) ↔ 현재 2026-11-14 13:41 (1652행)

- 악화(기준 비FAIL → 현재 FAIL): **0** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 4 · 그 외 변경: 115 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 18 · 새 행 41
- 승격 대기(received): Doc\verify\_checker_golden\SCP0084.received.csv — 확인 뒤 `checker_regress.py SCP0084 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-c9d3bd14 | F1 | SCP0084 화면 | FAIL | PASS | 저장 후 재조회에 수정값 반영 — DB 반영 확인 · 원복 저장·복원 확인(정리 완료) · 수정 저장 경로 강제(edit-save) · 편집 표시 셀이 화면 밖 → 편집 개시되는  |  |
| V-bc91a37c | K3 | SCP0084 화면 | FAIL | PASS | copy PASS: 선택 0,12,0,12 · 0행 MDM_NICK_NAME 표시값 'N32S2' · Ctrl+C 클립보드 'N32S2'(일치) · 우클릭 Copy 'N32S2'( |  |
| V-4e36063c | K3 | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | FAIL | ERROR | copy PASS: 선택 0,12,0,12 · 0행 MDM_NICK_NAME 표시값 'N32S2' · Ctrl+C 클립보드 'N32S2'(일치) · 우클릭 Copy 'N32S2'( |  |
| T-65ada0a9 | X-ROW | SCP0084_LongTermStock.SaveData_Memo | FAIL | ERROR | 진입점 집계 15검사 — NA:6 · PASS:5 · ERROR:4 |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-922eb524 | F6 | SCP0084 화면 | NA | PASS | 수정값·원복값 모두 재조회에 그대로(변형 없음) · 수정 저장 경로 강제(edit-save) · 편집 표시 셀이 화면 밖 → 편집 개시되는 첫 칸 MEMO 로 스크롤 후 후보 40 |  |
| V-b8863463 | J2 | SCP0084 화면 | NA | ERROR |  ／ [미검증] 검사기(auth·authcrud spec)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(auth·authcrud sp |  |
| V-f11bf4aa | F8 | SCP0084 저장 감사 필드 | NA | ERROR |  ／ [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-e5737030 | F7 | SCP0084 저장 연계 테이블 | NA | ERROR |  ／ [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-f8ae66ab | F5 | SCP0084 원값 복원 상태 해제 | PASS | NA | 값 있는 편집 가능 칸 없음 — 수정 기능 없는 화면 |  |
| V-eb8bf778 | I1 | SCP0084 시나리오 [자동] KO 언어 · 변경 없이 저장 → KO 수정사항 없음 알림 | PASS | ERROR | [측정 경로 없음] [자동] KO 언어 · 변경 없이 저장 → KO 수정사항 없음 알림: [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0041) — 계정 언어 전환 생략( |  |
| V-43818378 | A6 | SCP0084_GET_MONTH_RANGE | NA | ERROR | AS-IS ORDER BY [] ↔ TO-BE  [] — TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7 |  |
| V-8f70edcd | A6 | PR_SCM_SYS_LOG_BATCH | NA | ERROR | AS-IS ORDER BY [] ↔ TO-BE  [] — TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7 |  |
| V-1bbc884d | A7 | SCP0084_GET_LONG_TERM_STOCK | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-482de8db | A7 | SCP0084_GET_MONTH_RANGE | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-db5fe226 | A7 | PR_SCM_SYS_LOG_BATCH | NA | ERROR |  ／ [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 |  |
| V-72b0e444 | G8 | 조회조건 Month | NA | ERROR | 'Month' 과 같은 이름의 결과 컬럼 없음(후보 Month · Month Code · Month Name · Month ID) — 결과 대조 불가(조건 ↔ 컬럼 대응 확인) → |  |
| V-373ec674 | G4 | 조회조건 Div | PASS | NA | 조회조건 순서는 판정 대상 제외(CR-098 · 사용자 지시 2026-11-09 — Excel 대조는 사용여부·EDIT 형태까지만) · 참고 원 판정: 조회조건 순서가 기준표(CR |  |
| V-2b4317f2 | B4 | 조회조건 Plant | 판정필요 | ERROR | [화면 초기(선택 없음=ALL)] [CR-002 확정 규칙 대상 — Team(DEPT) 콤보·cascade 의 원천은 모든 화면에서 SCM_MST_SITE_ITEM(SSPM).DE |  |
| V-4c066d71 | G7 | 조회조건 Plant | NA | ERROR | [화면 초기(선택 없음=ALL)] CODE≠NAME 후보 8건이 TO-BE 표시 문구와 한 건도 안 맞음(데이터 차이 또는 다른 형식) · AS-IS 표시 NAME · 원천 UP_ |  |
| V-2501070e | B4 | 조회조건 Long Term Type | 판정필요 | ERROR | [화면 초기(선택 없음=ALL)] AS-IS 8건 vs TO-BE 3건 · 차이 11건 설명 불가: 81: 설명 불가(원천 마스터 테이블 해석 실패); 40: 설명 불가(원천 마스 |  |
| V-c0614104 | G7 | 조회조건 Long Term Type | NA | ERROR | [화면 초기(선택 없음=ALL)] CODE≠NAME 후보 8건이 TO-BE 표시 문구와 한 건도 안 맞음(데이터 차이 또는 다른 형식) · AS-IS 표시 NAME · 원천 UP_ |  |
| V-bde7b7d3 | B1 | Long Term Stock.OCCR_RSN_CD (발생사유 유형) | NA | ERROR | Insert 버튼 비노출 — 신규행 조건 행은 이 화면에 측정 대상 없음(입력 검증·연쇄·표시 검사는 기존행으로 계속) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-a40ca601 | B2 | Long Term Stock.OCCR_RSN_CD (발생사유 유형) | NA | ERROR | Insert 버튼 비노출 — 신규행 조건 행은 이 화면에 측정 대상 없음(입력 검증·연쇄·표시 검사는 기존행으로 계속) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-00556d19 | B3 | Long Term Stock.OCCR_RSN_CD (발생사유 유형) | NA | ERROR | Insert 버튼 비노출 — 신규행 조건 행은 이 화면에 측정 대상 없음(입력 검증·연쇄·표시 검사는 기존행으로 계속) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-322968e8 | B4 | Long Term Stock.OCCR_RSN_CD (발생사유 유형) | NA | ERROR | Insert 버튼 비노출 — 신규행 조건 행은 이 화면에 측정 대상 없음(입력 검증·연쇄·표시 검사는 기존행으로 계속) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-c7658336 | A2 | Long Term Stock.OCCR_RSN_CD (발생사유 유형) | NA | ERROR | OCCR_RSN_CD 기존행 값 공란 — 다른 행으로 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-bebe5b41 | H2 | Long Term Stock.OCCR_RSN_CD (발생사유 유형) | PASS | NA | OCCR_RSN_CD 현재 그리드에 없음 |  |
| V-da1d0a71 | B1 | Long Term Stock.EXHT_TP_CD (소진방안 유형) | NA | ERROR | Insert 버튼 비노출 — 신규행 조건 행은 이 화면에 측정 대상 없음(입력 검증·연쇄·표시 검사는 기존행으로 계속) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-2368b723 | B2 | Long Term Stock.EXHT_TP_CD (소진방안 유형) | NA | ERROR | Insert 버튼 비노출 — 신규행 조건 행은 이 화면에 측정 대상 없음(입력 검증·연쇄·표시 검사는 기존행으로 계속) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-76d0225e | B3 | Long Term Stock.EXHT_TP_CD (소진방안 유형) | NA | ERROR | Insert 버튼 비노출 — 신규행 조건 행은 이 화면에 측정 대상 없음(입력 검증·연쇄·표시 검사는 기존행으로 계속) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-6ac94f60 | B4 | Long Term Stock.EXHT_TP_CD (소진방안 유형) | NA | ERROR | Insert 버튼 비노출 — 신규행 조건 행은 이 화면에 측정 대상 없음(입력 검증·연쇄·표시 검사는 기존행으로 계속) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-2232d8d0 | A2 | Long Term Stock.EXHT_TP_CD (소진방안 유형) | NA | ERROR | EXHT_TP_CD 기존행 값 공란 — 다른 행으로 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| V-a766bf57 | H2 | Long Term Stock.EXHT_TP_CTN (소진방안 상) | PASS | NA | EXHT_TP_CTN 현재 그리드에 없음 |  |
| V-1dd32755 | H2 | Long Term Stock.QTY_5 (QTY_5) | PASS | NA | QTY_5 현재 그리드에 없음 |  |
| V-b2e85cc8 | H2 | Long Term Stock.QTY_8 (QTY_8) | PASS | NA | QTY_8 현재 그리드에 없음 |  |
| V-6a8d66c9 | G1 | SCP0084 텍스트 부분일치 Month | NA | ERROR |  ／ [미검증] 검사기(smoke 조회조건 동작·_verify)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(smoke 조회조건 동작 |  |
| V-a91c9b1c | D1 | siMain.SwitchLock | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect))가 이 대상을 실행하지 못함 — 검증 엔진 확장  |  |
| V-8a056ad0 | E4 | MSG00100 | NA | ERROR | MSG00100 — ExcelButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ExcelButton)에서 판정 → 기계 판정  |  |
| V-17e9559b | G5 | saveFileDialog.ShowDialog() | NA | ERROR |  ／ [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [ |  |
| V-05a7b55d | H6 | saveFileDialog.ShowDialog() | NA | ERROR |  ／ [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) ／ [미검증] 검사기(_ |  |
| V-03391c60 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | PASS | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-2b4317f2] 조회조건 Plant: [화면 초기(선택 없음=ALL)] [CR-002 확정 규칙 대상 |  |
| V-0b4ed52b | C1 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | PASS | ERROR | 규칙 C1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-7ebd4390] SCP0084 연쇄 후보 Plant: [CR-069 확정 규칙 대상 — SCM_MS |  |
| V-775b061b | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | NA | ERROR | f5 PASS: F5 → 조회 호출 1건(SEARCH) · 페이지 이동 0회 · 미포함: 팝업 그리드(이 시험은 메인 그리드만), Sort/Filter·정렬 후 동작(K1 smok |  |
| V-a99c0a00 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(MDM_NICK_NAME) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포 |  |
| V-c5d206d9 | K3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,12 |  |
| V-413c2484 | B5 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | NA | ERROR | 규칙 B5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-2501070e] 조회조건 Long Term Type: [화면 초기(선택 없음=ALL)] AS-IS 8 |  |
| V-4c44ce96 | A5 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | NA | PASS | 규칙 A5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-c8533f53] PLANT_DESCRIPTION / Plant Site: PLANT_DESCRIPTI |  |
| V-0898bc44 | G7 | [DMF0042 결함 일반화] 조회조건 Item Type | NA | ERROR | 규칙 G7 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-c0614104] 조회조건 Long Term Type: [화면 초기(선택 없음=ALL)] CODE≠NA |  |
| V-44a22597 | K3 | [DMF0020 결함 일반화] 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | NA | ERROR | hide PASS: 헤더(MDM_NICK_NAME) 우클릭 → Hide Column → 컬럼 비표시 · Unhide All 복원 · 미포함: Sort/Filter·정렬 후 동작(K |  |
| V-9072167d | K3 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | NA | ERROR | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,12 |  |
| V-1680a55a | B5 | [DMF0003 결함 유형] FCST Type 후보 | NA | ERROR | 규칙 B5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-2501070e] 조회조건 Long Term Type: [화면 초기(선택 없음=ALL)] AS-IS 8 |  |
| V-cb9fe5b4 | B4 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | PASS | ERROR | 규칙 B4 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-2b4317f2] 조회조건 Plant: [화면 초기(선택 없음=ALL)] [CR-002 확정 규칙 대상 |  |
| V-84e812a5 | B5 | [DMF0082 결함 유형] FCST Type 후보 | NA | ERROR | 규칙 B5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-2501070e] 조회조건 Long Term Type: [화면 초기(선택 없음=ALL)] AS-IS 8 |  |
| V-85bae753 | B4 | [DMF0082 결함 유형] FCST Type 후보 | NA | ERROR | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-2501070e] 조회조건 Long Term Type: [화면 초기(선택 없음=ALL)] AS-IS 8 |  |
| V-14b747b8 | B4 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | PASS | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-2b4317f2] 조회조건 Plant: [화면 초기(선택 없음=ALL)] [CR-002 확정 규칙 대상 |  |
| V-b096f084 | B4 | [SYS0006 결함 유형] API Type 조회조건 | NA | ERROR | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-2501070e] 조회조건 Long Term Type: [화면 초기(선택 없음=ALL)] AS-IS 8 |  |
| V-54eda20f | A5 | [DMF0005 결함 유형] Cell Prod. Site (S&OP Report) 컬럼 | NA | ERROR | 규칙 A5 판정 8행 중 FAIL 0 · 판정필요 0 · 미검증 7 — [AD-d962bad7] SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 컬럼 집합(A |  |
| V-db8ad4a6 | B4 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | PASS | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-2b4317f2] 조회조건 Plant: [화면 초기(선택 없음=ALL)] [CR-002 확정 규칙 대상 |  |
| V-a84e65bc | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | PASS | ERROR | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-2b4317f2] 조회조건 Plant: [화면 초기(선택 없음=ALL)] [CR-002 확정 규칙 대상 |  |
| V-44673a10 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NA | ERROR | ctrl PASS: Ctrl+클릭 0행·2행(MDM_NICK_NAME) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포 |  |
| V-9ae98bab | G4 | SCP0084 스냅샷 조회조건 Div 40 | NA | ERROR | [재실측 스냅샷 조회조건] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0084\snap\received\조회조건_Div_40.aria.yml 를 sna |  |
| V-55a9b9b6 | K4 | SCP0084 스냅샷 버튼 Div 40 | NA | ERROR | [재실측 스냅샷 버튼] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0084\snap\received\버튼_Div_40.aria.yml 를 snap_va |  |
| V-899f2a1c | A5 | SCP0084 스냅샷 헤더 Long Term Stock | NA | ERROR | [재실측 스냅샷 헤더] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0084\snap\received\헤더_Long_Term_Stock.txt 를 sna |  |
| V-e3db601d | H4 | SCP0084 스냅샷 화면샷 1920 | NA | ERROR | [재실측 스냅샷 화면샷] 골든 없음(승인 전) · 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 차이 — Error: [2mexpect([22m[31mpage[3 |  |
| V-e59b135d | H4 | SCP0084 스냅샷 화면샷 1366 | NA | ERROR | [재실측 스냅샷 화면샷] 골든 없음(승인 전) · 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 차이 — Error: [2mexpect([22m[31mpage[3 |  |
| AD-a6f982c0 | A1 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 행·키 집합(공통 4716 · AS-I | 판정필요 | PASS | [KEYSET] [차등 검증 #1] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-b4448e59 | A7 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통행 컬럼 값(공통 4716행 · 불일치  | PASS | ERROR | [VALUES] [차등 검증 #1] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-d962bad7 | A5 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 컬럼 집합(AS-IS 전용  · TO- | NA | ERROR | [COLSET] [차등 검증 #1] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-f05da7f8 | A6 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #1] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_L |  |
| AD-70feee5d | A1 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 행·키 집합(공통 718 · AS-IS | 판정필요 | PASS | [KEYSET] [차등 검증 #2] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-e015ed31 | A7 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통행 컬럼 값(공통 718행 · 불일치 셀 | PASS | ERROR | [VALUES] [차등 검증 #2] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-625506e3 | A5 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 컬럼 집합(AS-IS 전용  · TO- | NA | ERROR | [COLSET] [차등 검증 #2] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-52b4165b | A6 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #2] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_L |  |
| AD-155803c8 | A1 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 행·키 집합(공통 516 · AS-IS | 판정필요 | PASS | [KEYSET] [차등 검증 #3] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-5a9e004c | A7 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통행 컬럼 값(공통 516행 · 불일치 셀 | PASS | ERROR | [VALUES] [차등 검증 #3] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-0bc5cd4f | A5 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 컬럼 집합(AS-IS 전용  · TO- | NA | ERROR | [COLSET] [차등 검증 #3] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-83f47484 | A6 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #3] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_L |  |
| AD-d66f580e | A1 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 행·키 집합(공통 4716 · AS-I | 판정필요 | PASS | [KEYSET] [차등 검증 #4] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-85c32a59 | A7 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통행 컬럼 값(공통 4716행 · 불일치  | PASS | ERROR | [VALUES] [차등 검증 #4] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-e494a4b8 | A5 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 컬럼 집합(AS-IS 전용  · TO- | NA | ERROR | [COLSET] [차등 검증 #4] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-89b38a83 | A6 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #4] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_L |  |
| AD-0f5af338 | A5 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 컬럼 집합(AS-IS 전용  · TO- | NA | ERROR | [COLSET] [차등 검증 #5] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-22a3df1a | A6 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #5] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_L |  |
| AD-330186c6 | A5 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 컬럼 집합(AS-IS 전용  · TO- | NA | ERROR | [COLSET] [차등 검증 #6] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-3e1457e6 | A6 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #6] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_L |  |
| AD-15fca2e9 | A1 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 행·키 집합(공통 1825 · AS-I | 판정필요 | PASS | [KEYSET] [차등 검증 #7] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-43b0637a | A7 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통행 컬럼 값(공통 1825행 · 불일치  | PASS | ERROR | [VALUES] [차등 검증 #7] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-f2bc32a2 | A5 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 결과 컬럼 집합(AS-IS 전용  · TO- | NA | ERROR | [COLSET] [차등 검증 #7] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_ |  |
| AD-c6d72fb2 | A6 | SCP0084 SCP0084_GET_LONG_TERM_STOCK 공통·유일 행 상대 순서 | NA | ERROR | [ORDER] [차등 검증 #7] main/SEARCH AS-IS SCP0084_GET_LONG_TERM_STOCK ↔ TO-BE PKG_SCP0084.P_SCP0084_GET_L |  |
| T-d475b28f | A6 | SCP0084_GET_MONTH_RANGE | NA | ERROR | SCP0084_GET_MONTH_RANGE: 화면 진입·조회 경로에서 이 SP 가 결과를 반환하지 않음(팝업·셀 이벤트 SP) — 해당 시나리오에서 실측 → 기계 판정 불가 — 수 |  |
| T-9b139994 | DB-SYN | SCP0084_GET_MONTH_RANGE | NA | ERROR | 실측[T-9b139994]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 le |  |
| T-86047efb | D4 | checkRequiredOfSearch · 285 | NA | ERROR | 행 집계 — 대조표 checkRequiredOfSearch '285' 의 D4 3요소: ERROR:3 |  |
| T-0956f22e | E3 | checkRequiredOfSearch · 285 | PASS | ERROR | 행 집계 — 대조표 checkRequiredOfSearch '285' 의 E3 6요소: PASS:5 · ERROR:1 |  |
| T-b01341fe | D1 | 조회 후 전 컬럼 Lock (R2, W4) · 327 | PASS | ERROR | 행 집계 — 대조표 조회 후 전 컬럼 Lock (R2, W4) '327' 의 D1 5요소: ERROR:4 · PASS:1 |  |
| T-46151210 | D1 | **EditButton 노출** · 227 | PASS | ERROR | 행 집계 — 대조표 **EditButton 노출** '227' 의 D1 5요소: ERROR:4 · PASS:1 |  |
| T-015cfc25 | D1 | Edit 가드 fps==null (R4) · 229 | PASS | ERROR | 행 집계 — 대조표 Edit 가드 fps==null (R4) '229' 의 D1 5요소: ERROR:4 · PASS:1 |  |
| T-f51c5d6f | D1 | Edit 가드 RowCount==0 (R5) · 231 | PASS | ERROR | 행 집계 — 대조표 Edit 가드 RowCount==0 (R5) '231' 의 D1 5요소: ERROR:4 · PASS:1 |  |
| T-d5f56e6b | D1 | Edit 가드 Action(String) 컬럼 hidden (R6) · 244 | PASS | ERROR | 행 집계 — 대조표 Edit 가드 Action(String) 컬럼 hidden (R6) '244' 의 D1 5요소: ERROR:4 · PASS:1 |  |
| T-6bf7aa09 | F3 | SCP0084 화면 | NA | ERROR | 붙여넣기 프로브 전제 부족(기존행 true · 신규행 false) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  |
| T-a7658431 | C3 | cellclipboardPast=false (R7) · 237~240 | NA | ERROR | 행 집계 — 대조표 cellclipboardPast=false (R7) '237~240' 의 C3 4요소: ERROR:4 |  |
| T-64c21b39 | D1 | cellclipboardPast=false (R7) · 237~240 | PASS | ERROR | 행 집계 — 대조표 cellclipboardPast=false (R7) '237~240' 의 D1 5요소: ERROR:4 · PASS:1 |  |
| T-9b933639 | DB-SYN | SaveData_Memo (I/M/D 행, 6키+MEMO) · 405~420 | PASS | ERROR | 행 집계 — 대조표 SaveData_Memo (I/M/D 행, 6키+MEMO) '405~420' 의 DB-SYN 3요소: PASS:2 · ERROR:1 |  |
| T-5eb7ae09 | E4 | MSG00100 | NA | ERROR | MSG00100 — ExcelButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ExcelButton)에서 판정 → 기계 판정  |  |
| T-86236145 | E3 | ExcelButton + MSG00100 confirm (R9) · 258~274/263~270 | PASS | ERROR | 행 집계 — 대조표 ExcelButton + MSG00100 confirm (R9) '258~274/263~270' 의 E3 6요소: PASS:5 · ERROR:1 |  |
| T-7d57ff71 | G03-WIRE | SCP0084 화면 | NA | ERROR | 실측[T-7d57ff71]: 검사기(check.js G03)는 있으나 이 대상(SCREEN)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 |  |
| T-3ca8d6f7 | C3 | SCP0084_LongTermStock.CboDivision_SelectedIndexChanged | NA | ERROR | 진입점 집계 — 대조표 SCP0084_LongTermStock.CboDivision_SelectedIndexChanged 의 C3 4요소: ERROR:4 |  |
| T-4a0d3125 | E4 | MSG00100 | NA | ERROR | MSG00100 — ExcelButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(ExcelButton)에서 판정 → 기계 판정  |  |
| T-8e31879e | X-ROW | SCP0084_LongTermStock.GetMonthRange | NA | ERROR | 진입점 집계 5검사 — PASS:2 · NOPATH:2 · ERROR:1 |  |
| T-0623ca3c | B4 | SCP0084_LongTermStock.GetMonthRange | 판정필요 | ERROR | 진입점 집계 — 대조표 SCP0084_LongTermStock.GetMonthRange 의 B4 4요소: ERROR:3 · NA:1 |  |
| T-8182bdc8 | B3 | SCP0084_LongTermStock.GetMonthRange | PASS | ERROR | 진입점 집계 — 대조표 SCP0084_LongTermStock.GetMonthRange 의 B3 4요소: ERROR:2 · PASS:1 · NA:1 |  |
| T-51482d7a | DB-SYN | SCP0084_LongTermStock.SCM_SYS_LOG_BATCH | PASS | ERROR | 진입점 집계 — 대조표 SCP0084_LongTermStock.SCM_SYS_LOG_BATCH 의 DB-SYN 3요소: PASS:2 · ERROR:1 |  |
| T-efcc7455 | C3 | SCP0084_LongTermStock.SetChangedControl | NA | ERROR | 진입점 집계 — 대조표 SCP0084_LongTermStock.SetChangedControl 의 C3 4요소: ERROR:4 |  |
| T-03f27eb2 | C3 | SCP0084_LongTermStock.SetColumnFooterData | NA | ERROR | 진입점 집계 — 대조표 SCP0084_LongTermStock.SetColumnFooterData 의 C3 4요소: ERROR:4 |  |
| T-e64d0a1a | C3 | SCP0084_LongTermStock.SetMonthRange | NA | ERROR | 진입점 집계 — 대조표 SCP0084_LongTermStock.SetMonthRange 의 C3 4요소: ERROR:4 |  |
| T-8508f24a | C3 | SCP0084_LongTermStock.SetSpreadInit | NA | ERROR | 진입점 집계 — 대조표 SCP0084_LongTermStock.SetSpreadInit 의 C3 4요소: ERROR:4 |  |
| EG-9a6166a7 | A1 | SCP0084 실전송 건수 main | PASS | 판정필요 | AS-IS 10274행 · TO-BE 10274행 · 키 ['PLANT_DESCRIPTION', 'PLANT_ID', 'ITEM_ID', 'ITEM_NAME', 'ITEM_UOM' |  |
| EG-22d0352e | I2 | SCP0084 언어 전환 KO | PASS | ERROR | [측정 경로 없음] [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0041) — 계정 언어 전환이 그 화면 측정을 오염시켜 전환 생략(T200) |  |
| EG-e1cd432e | I2 | SCP0084 언어 전환 EN | NA | ERROR | [측정 경로 없음] [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0041) — 계정 언어 전환이 그 화면 측정을 오염시켜 전환 생략(T200) |  |
| EG-7ebd4390 | C1 | SCP0084 연쇄 후보 Plant | NA | ERROR | [CR-069 확정 규칙 대상 — SCM_MST_PLANT Active Flag=Y 인 Plant 만 후보 표시] AS-IS 와의 차이가 이 규칙에 따른 변경인지 확인 · [CR- |  |
