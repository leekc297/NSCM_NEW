# SSP0014 미검증 행별 조치 (2026-11-20 라운드 4)

- 원천: `unverified_triage.csv`(2026-11-20 09:53:06). 원장 `verify_ledger.csv`(09:48:20) ERROR 42행 + AI 판정 검토 1행(V-3809bf77, 원장 FAIL) = 43행
- 이 표 = 집계 아닌 13행 + 집계 30행. 원장 ERROR 42 = 집계 30 + 처리 대상 12
- 재측정은 VM 의 CheckList 재수행으로 함. 이번 라운드에서 run_verify, 개별 검사기 재실행 안 함

## 묶음(행 수 많은 순)

| 묶음 | 행 | 고칠 곳 |
|---|---|---|
| J 결정 | 4 | 결정 D2·D6 / 결정 D7(팝업 교체 확정 룰 없음) |
| S 저장 시험 행 선택 | 4 | saveprobe.ts 막힌 사용자 값 기록·행 고르기(editableValueRow) · _verify.spec.ts 저장 세부 다른 행 재시도 · crud.ts 후보 행 |
| B 콤보 후보 대조 | 2 | combo_oracle.py 이름 → 코드 환산(같은 이름 여러 코드) · 하드코딩 항목 철자 차이는 결정 D3 |
| H 사람 | 2 | 결정 D1(snap_validate)·D8(계정) |
| G G9 단일 비교 | 1 | judge.py G9 AS-IS 원문 String_Split 확인(T381 미적용 원인) |
| 집계 | 30 | 하위 행을 따라감 |

## 행별 목록

| 행 ID | 출처 | 규칙 | 대상 | 유형 | 담당 | 묶음 | 조치 |
|---|---|---|---|---|---|---|---|
| V-0db2d553 | SEARCH | B4 | 조회조건 From Site | 데이터전제 | 엔진 | B | combo_oracle.py 이름 → 코드 환산(같은 이름 여러 코드) · 하드코딩 항목 철자 차이는 결정 D3 |
| V-62f2170d | SEARCH | B4 | 조회조건 Operation group | 데이터전제 | 엔진 | B | combo_oracle.py 이름 → 코드 환산(같은 이름 여러 코드) · 하드코딩 항목 철자 차이는 결정 D3 |
| V-3809bf77 | SEARCH | G9 | 조회조건 User ID(Name) | AI검토:검사기오판 | 엔진 | G | judge.py G9 AS-IS 원문 String_Split 확인(T381 미적용 원인) |
| EG-29c0f2b6 | RULE_SCREEN | A1 | SSP0014 실전송 건수 main/같은 사용자 | 계정 | 사람 | H | 결정 D1(snap_validate)·D8(계정) |
| V-3bb51520 | RULE_SCREEN | K4 | SSP0014 스냅샷 버튼 Div 40 | 스냅샷승인 | 사람 | H | 결정 D1(snap_validate)·D8(계정) |
| EG-942cf54f | RULE_SCREEN | N1 | SSP0014 기준정보 키 존재 SCM_MST_SITE_ITEM | 판단 | 판단 | J | 결정 D2·D6 |
| T-bab6f023 | TRACE | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | 검사기공백 | 엔진 | J | 결정 D7(팝업 교체 확정 룰 없음) |
| T-d1bd8978 | TRACE | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | 검사기공백 | 엔진 | J | 결정 D7(팝업 교체 확정 룰 없음) |
| V-16ab0403 | RULE_SCREEN | A2 | SSP0014 콤보 칸 이름 표시 | 판단 | 판단 | J | 결정 D2·D6 |
| V-504dee98 | RULE_SCREEN | F1 | SSP0014 2행 동시 저장 | 검사기공백 | 엔진 | S | saveprobe.ts 막힌 사용자 값 기록·행 고르기(editableValueRow) · _verify.spec.ts 저장 세부 다른 행 재시도 · crud.ts 후보 행 |
| V-5473aa5a | RULE_SCREEN | F1 | SSP0014 저장 실패 처리 | 검사기공백 | 엔진 | S | saveprobe.ts 막힌 사용자 값 기록·행 고르기(editableValueRow) · _verify.spec.ts 저장 세부 다른 행 재시도 · crud.ts 후보 행 |
| V-9041b5eb | RULE_SCREEN | L1 | SSP0014 저장 응답 시간 | 검사기공백 | 엔진 | S | saveprobe.ts 막힌 사용자 값 기록·행 고르기(editableValueRow) · _verify.spec.ts 저장 세부 다른 행 재시도 · crud.ts 후보 행 |
| V-9bcbf1f5 | RULE_SCREEN | F1 | SSP0014 컬럼별 저장 왕복 | 미분류 | 엔진 | S | saveprobe.ts 막힌 사용자 값 기록·행 고르기(editableValueRow) · _verify.spec.ts 저장 세부 다른 행 재시도 · crud.ts 후보 행 |

## 집계 행

| 행 ID | 규칙 | 대상 |
|---|---|---|
| V-effdd7ff | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea |
| V-cc87e246 | B4 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom |
| V-a597cfb4 | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ |
| V-4357d45f | B4 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 |
| V-648cd5dc | B4 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site |
| V-2706fcf0 | B4 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer |
| V-c5df375e | B4 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 |
| V-81abf761 | B5 | [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 |
| V-855bbce3 | N1 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 |
| V-9fb98d50 | N1 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 |
| V-748c1535 | B4 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 |
| V-a188b35d | B4 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 |
| V-fb724ddb | B5 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit |
| V-5c379423 | B4 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit |
| V-d568b36b | N1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site I |
| V-27adb9e0 | B5 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 |
| V-d5f17c5c | B4 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 |
| V-ab4a5428 | B5 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 |
| V-62e28995 | B5 | [SYS0012 결함 유형] 권한 신청 가능 Group 목록 |
| V-1f760440 | B4 | [SCP0007 결함 유형] To Site 조회조건 콤보 |
| V-710f745f | B4 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City |
| V-16ec539a | B4 | [결함 유형 묶음 B4-G01 · 3건] 저장 · Sales Site 조회조건 콤보 |
| V-98497859 | B5 | [결함 유형 묶음 B5-G01 · 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) |
| V-e80b9f38 | N1 | [결함 유형 묶음 N1-G01 · 2건] 공란 데이터 표기(단일 센티널) |
| V-31bac514 | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea |
| V-f4554768 | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ |
| T-f5883fbb | F4 | ProgressForm(FindData/SaveData) · 2 |
| T-ee384c11 | A6 | ProgressForm(FindData/SaveData) · 2 |
| T-3487b794 | X-ROW | SSP0014_ShipmentModelPIC.SaveData |
| T-52ac04a0 | X-ROW | SSP0014_ShipmentModelPIC.btnItemId_Click |
