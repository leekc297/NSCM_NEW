# 작업 원장 — SCP0111 · 2026-11-14 17:08

> 검사 인스턴스 325건 중 PASS·NA 178건 외 **147건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 11 | 재판정 PASS |
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 27 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 101 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 101 · 사람 판정 / AS-IS 원문 확인 → 재판정 27 · 화면 FE 9 · 하네스 7 · DB 객체 1 · FE 1 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 5건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 3 |  |  |  | 1 |  | 16 | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  |  |  |  |  |  | 20 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 17 | 연쇄 자동 채움 |
| D1 | EDIT |  |  | 4 |  |  |  |  |  | 11 | 컬럼 편집 가능 여부(신규행·기존행) |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 13 | 배경·글자색 규칙 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 11 | 그리드 셀 cascade 후보 |
| D3 | EDIT |  |  |  |  |  |  |  |  | 11 | 행 값 기반 조건부 잠금 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 10 | 무변경 편집 종료 시 연쇄 미발동 |
| DB-SYN | DB |  |  |  |  | 5 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| A1 | GEN |  |  |  |  |  |  | 4 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  |  |  |  | 4 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G4 | DESIGN |  |  |  |  | 2 | 1 |  |  |  | 조회조건 표시·라벨·활성 |
| A6 | GEN |  |  |  |  |  |  | 1 |  | 1 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| D6 | EDIT |  |  | 1 |  |  |  |  |  |  | Insert 위치·상태 유지 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| F4 | DB |  |  |  |  |  |  |  |  | 1 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0001 | F1 | SCP0111 화면 | DB 객체(PKG/SP)(적용 예정) | F1 FAIL 수정 — SCP0111 화면: 원장 V-3937cc87 RULE_SCREEN / 원장 V-bded1ccf RULE_SCREEN / 원장 V-56473196 RULE_SCREEN / 원장 V-6f8e8fd5 RULE_SC |  | 378 (일반 저장 ADMIN 저장 SaveButton InsertButton D) |
| WK-SCP0111-0002 | F5 | SCP0111 화면 | 화면 FE(범위 밖(가이드만)) | F5 FAIL 수정 — SCP0111 화면: 원장 V-02e2f75a RULE_SCREEN / 원장 V-23d0a714 RULE_SCREEN / 원장 V-271762c3 RULE_SCREEN / 원장 V-222881c4 DEFECT  |  | 1 (DeleteButton) |
| WK-SCP0111-0003 | H10 | SCP0111 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H10 FAIL 수정 — SCP0111 화면: 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 9 (조회기간 from>to 금지 필수값 공백(15건) OPERATION_GR) |
| WK-SCP0111-0004 | D1 | EditButton | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — EditButton: 행 집계 — 대조표 EditButton '(제거)' 의 D1 13요소: ERROR:11 · FAIL:1 · NA:1 · FAIL 요소: ITEM_ID / Model — 원장 V-8c320f |  | 1 (EditButton) |
| WK-SCP0111-0005 | D1 | ITEM_ID / Model | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — ITEM_ID / Model: 원장 V-8c320f28 COLUMN / 원장 V-095bc160 COLUMN / 실측[T-0fed883c]: 기존행 r0 ITEM_ID 편집=false (AS-IS 잠금) / 신 |  | 4 (ACT:SCP0111_IntegrationPSI.EditButton AC) |
| WK-SCP0111-0006 | D1 | SCP0111_IntegrationPSI.EditButton | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — SCP0111_IntegrationPSI.EditButton: 진입점 집계 — 대조표 SCP0111_IntegrationPSI.EditButton 의 D1 11요소: ERROR:10 · FAIL:1 · FAIL |  | 58 (ACT:SCP0111_IntegrationPSI.EditButton:54) |
| WK-SCP0111-0007 | D1 | 대상 행 미선택 | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — 대상 행 미선택: 행 집계 — 대조표 대상 행 미선택 '(제거 — 편집모드 없음, INSERT 는 SAVE 권한으로 게이트)' 의 D1 13요소: ERROR:11 · FAIL:1 · NA:1 · FAIL 요소: |  | 1 (대상 행 미선택) |
| WK-SCP0111-0008 | D6 | SCP0111 화면 | 화면 FE(범위 밖(가이드만)) | D6 FAIL 수정 — SCP0111 화면: 원장 V-65789ebc RULE_SCREEN / 원장 V-7b1419f1 RULE_SCREEN / 원장 V-daa3f0ba RULE_SCREEN / 원장 V-309492cc GENERAL |  | 4 (InsertButton 대상 행 미선택 ACT:SCP0111_Integr) |
| WK-SCP0111-0009 | X-ROW | SCP0111_IntegrationPSI.EditButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.EditButton: 진입점 집계 44검사 — NA:24 · ERROR:13 · PASS:5 · FAIL:2 (FX-SCP0111-050) |  | 4 (ACT:SCP0111_IntegrationPSI.EditButton:55) |
| WK-SCP0111-0010 | X-ROW | SCP0111_IntegrationPSI.InsertButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.InsertButton: 진입점 집계 1검사 — FAIL:1 (FX-SCP0111-054) |  | 1 (ACT:SCP0111_IntegrationPSI.InsertButton) |
| WK-SCP0111-0011 | X-ROW | SCP0111_IntegrationPSI.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.SaveData: 진입점 집계 29검사 — NA:17 · PASS:7 · ERROR:3 · FAIL:1 · NOPATH:1 (FX-SCP0111-055) |  | 11 (ACT:SCP0111_IntegrationPSI.SaveData:1105) |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0012 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0111_IntegrationPSI.GetBucketType) |
| WK-SCP0111-0013 | DB-SYN | P_SCP0111_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0111_GET | 없음(PROC_M 대응 없음) | 1 (메인 조회) |
| WK-SCP0111-0014 | DB-SYN | P_SCP0111_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0111_SAVE | 없음(PROC_M 대응 없음) | 1 (일반 저장) |
| WK-SCP0111-0015 | DB-SYN | P_SCP0111_SAVE_ADMIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0111_SAVE_ADMIN | 없음(PROC_M 대응 없음) | 1 (ADMIN 저장) |
| WK-SCP0111-0016 | DB-SYN | SCP0111_SAVE_INTEGRATION_PSI_ADMIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0111_SAVE_INTEGRATION_PSI_ADMIN | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0111_IntegrationPSI.SaveData:1379) |
| WK-SCP0111-0017 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0111_IntegrationPSI.InitEvent ACT) |
| WK-SCP0111-0018 | G4 | btnNickName | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNickName | 있음(FE 소스) | 2 (ACT:SCP0111_IntegrationPSI.InitEvent ACT) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0019 | G4 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |

## W7 기대값 확정 (27)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0020 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — 대조표 FindButton 'search=handleSearch' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: P_SCP0111_GET — 골든 비교 케 |  | 1 (FindButton) |
| WK-SCP0111-0021 | A1 | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0111/SCP0111_GET_ESS_PACK_LI |  | 1 (ESS Pack Line) |
| WK-SCP0111-0022 | A1 | P_SCP0111_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0111_GET: 골든 비교 케이스 없음(P_SCP0111_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (메인 조회) |
| WK-SCP0111-0023 | A1 | 조회기간 from>to 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회기간 from>to 금지: 행 집계 — 대조표 조회기간 from>to 금지 'Form 조회 전' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: P_SCP0111_GET — 골든 비교 케 |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0024 | A6 | P_SCP0111_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SCP0111_GET: 검증 엔진이 실행됐으나 이 대상(SP P_SCP0111_GET)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · |  | 1 (메인 조회) |
| WK-SCP0111-0025 | G03-WIRE | SCP0111 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0111 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 / 게이트 G03 As-is 이벤트 btnNickName.Click → BtnNickNam  |  | 14 (ACT:SCP0111_IntegrationPSI..ctor ACT:SCP) |
| WK-SCP0111-0026 | X-LOC | (공용) Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (공용) Excel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((공용) Excel) |
| WK-SCP0111-0027 | X-LOC | ADMIN 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ADMIN 저장: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ADMIN 저장) |
| WK-SCP0111-0028 | X-LOC | DeleteButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DeleteButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DeleteButton) |
| WK-SCP0111-0029 | X-LOC | ESS Pack Line | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ESS Pack Line: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ESS Pack Line) |
| WK-SCP0111-0030 | X-LOC | ESS 파생검증 D1/D2 불일치 경고 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ESS 파생검증 D1/D2 불일치 경고: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ESS 파생검증 D1/D2 불일치 경고) |
| WK-SCP0111-0031 | X-LOC | EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EditButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EditButton) |
| WK-SCP0111-0032 | X-LOC | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FindButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FindButton) |
| WK-SCP0111-0033 | X-LOC | InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertButton) |
| WK-SCP0111-0034 | X-LOC | Line 미지정("-") 저장 확인 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Line 미지정("-") 저장 확인: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Line 미지정("-") 저장 확인) |
| WK-SCP0111-0035 | X-LOC | OPERATION_GROUP NAME→CODE lookup 부재 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — OPERATION_GROUP NAME→CODE lookup 부재: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (OPERATION_GROUP NAME→CODE lookup 부재) |
| WK-SCP0111-0036 | X-LOC | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SaveButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SaveButton) |
| WK-SCP0111-0037 | X-LOC | 대상 행 미선택 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 대상 행 미선택: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (대상 행 미선택) |
| WK-SCP0111-0038 | X-LOC | 메인 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 메인 조회: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (메인 조회) |
| WK-SCP0111-0039 | X-LOC | 신규행 중복(INSERT_KEY_COLS) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 신규행 중복(INSERT_KEY_COLS): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (신규행 중복(INSERT_KEY_COLS)) |
| WK-SCP0111-0040 | X-LOC | 일반 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 일반 저장: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (일반 저장) |
| WK-SCP0111-0041 | X-LOC | 저장 대상 변경 없음 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장 대상 변경 없음: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장 대상 변경 없음) |
| WK-SCP0111-0042 | X-LOC | 저장 성공 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장 성공: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장 성공) |
| WK-SCP0111-0043 | X-LOC | 저장 실패 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장 실패: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장 실패) |
| WK-SCP0111-0044 | X-LOC | 조회기간 from>to 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회기간 from>to 금지: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0045 | X-LOC | 필수값 공백(15건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 필수값 공백(15건): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (필수값 공백(15건)) |
| WK-SCP0111-0046 | X-ROW | SCP0111_IntegrationPSI.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0111_IntegrationPSI.OnShown ACT:S) |

## W9 도구 오류 (101)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0047 | J2 | SCP0111 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-7c5a2756 RULE_SCREEN / 원장 V-23a7d751 DEFECT / 원장 V-ab60b58e GENERAL / 원장 V-1e620509 GENERAL / 원장 V-9fa0d5b0 GENERA |  | 43 (메인 조회 일반 저장 ADMIN 저장 FindButton SaveButt) |
| WK-SCP0111-0048 | C2 | CELL_CF / Cell Coversion Factor | 하네스·환경 | C2 도구 오류 — 실측[T-ac12343d]: CELL_CF 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증 |  | 3 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0049 | C2 | ITEM_ID / Model | 하네스·환경 | C2 도구 오류 — 실측[T-4d369a89]: ITEM_ID 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증 |  | 7 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0050 | C2 | LINE_ID / Line | 하네스·환경 | C2 도구 오류 — 실측[T-08368ad3]: LINE_ID 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증 |  | 1 (ACT:SCP0111_IntegrationPSI.spdMain_CellC) |
| WK-SCP0111-0051 | C2 | MEASURE | 하네스·환경 | C2 도구 오류 — 실측[T-83b56a35]: MEASURE 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증 |  | 5 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0052 | C2 | SCP0111_IntegrationPSI.CboDivision_Selec | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.CboDivision_SelectedIndexChanged 의 C2 7요소: ERROR:7 |  | 2 (ACT:SCP0111_IntegrationPSI.CboDivision_S) |
| WK-SCP0111-0053 | C2 | SCP0111_IntegrationPSI.CboPlanDate_Selec | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.CboPlanDate_SelectedIndexChanged 의 C2 7요소: ERROR:7 |  | 2 (ACT:SCP0111_IntegrationPSI.CboPlanDate_S) |
| WK-SCP0111-0054 | C2 | SCP0111_IntegrationPSI.CboPlanType_Selec | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.CboPlanType_SelectedIndexChanged 의 C2 7요소: ERROR:7 |  | 1 (ACT:SCP0111_IntegrationPSI.CboPlanType_S) |
| WK-SCP0111-0055 | C2 | SCP0111_IntegrationPSI._defaultDataModel | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI._defaultDataModel_Changed 의 C2 6요소: ERROR:6 |  | 78 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0056 | C2 | SEQ_FLAG | 하네스·환경 | C2 도구 오류 — 실측[T-568981b2]: SEQ_FLAG 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검 |  | 2 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0057 | C2 | TO_PRODUCT / To Product | 하네스·환경 | C2 도구 오류 — 실측[T-c7d2b5db]: TO_PRODUCT 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [ |  | 4 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0058 | C2 | VALUE_TYPE / Valuation Type | 하네스·환경 | C2 도구 오류 — 실측[T-d6a038ee]: VALUE_TYPE 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [ |  | 3 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0059 | C3 | CELL_CF / Cell Coversion Factor | 하네스·환경 | C3 도구 오류 — 실측[T-76abe936]: CELL_CF 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0060 | C3 | ITEM_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-bb0c91f2]: ITEM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 7 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0061 | C3 | LINE_ID / Line | 하네스·환경 | C3 도구 오류 — 실측[T-afc50972]: LINE_ID 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0111_IntegrationPSI.spdMain_CellC) |
| WK-SCP0111-0062 | C3 | MEASURE | 하네스·환경 | C3 도구 오류 — 실측[T-1c211105]: MEASURE 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 9 (ACT:SCP0111_IntegrationPSI.SetVisibleShe) |
| WK-SCP0111-0063 | C3 | PLANT_ID / Plant | 하네스·환경 | C3 도구 오류 — 실측[T-aeb4dd80]: PLANT_ID 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0111_IntegrationPSI.SetVisibleShe) |
| WK-SCP0111-0064 | C3 | SCP0111_IntegrationPSI.CboDivision_Selec | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.CboDivision_SelectedIndexChanged 의 C3 11요소: ERROR:9 · NA:2 |  | 2 (ACT:SCP0111_IntegrationPSI.CboDivision_S) |
| WK-SCP0111-0065 | C3 | SCP0111_IntegrationPSI.CboPlanDate_Selec | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.CboPlanDate_SelectedIndexChanged 의 C3 11요소: ERROR:9 · NA:2 |  | 2 (ACT:SCP0111_IntegrationPSI.CboPlanDate_S) |
| WK-SCP0111-0066 | C3 | SCP0111_IntegrationPSI.CboPlanType_Selec | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.CboPlanType_SelectedIndexChanged 의 C3 11요소: ERROR:9 · NA:2 |  | 1 (ACT:SCP0111_IntegrationPSI.CboPlanType_S) |
| WK-SCP0111-0067 | C3 | SCP0111_IntegrationPSI.SetCalendar | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.SetCalendar 의 C3 11요소: ERROR:9 · NA:2 |  | 4 (ACT:SCP0111_IntegrationPSI.SetCalendar:3) |
| WK-SCP0111-0068 | C3 | SCP0111_IntegrationPSI.SetChangedPeriod | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.SetChangedPeriod 의 C3 11요소: ERROR:9 · NA:2 |  | 16 (ACT:SCP0111_IntegrationPSI.SetChangedPer) |
| WK-SCP0111-0069 | C3 | SCP0111_IntegrationPSI.SetSpreadColumn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.SetSpreadColumn 의 C3 11요소: ERROR:9 · NA:2 |  | 4 (ACT:SCP0111_IntegrationPSI.SetSpreadColu) |
| WK-SCP0111-0070 | C3 | SCP0111_IntegrationPSI.SetVisibleSheetCo | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.SetVisibleSheetColumns 의 C3 4요소: ERROR:4 |  | 1 (ACT:SCP0111_IntegrationPSI.SetVisibleShe) |
| WK-SCP0111-0071 | C3 | SCP0111_IntegrationPSI._defaultDataModel | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI._defaultDataModel_Changed 의 C3 6요소: ERROR:6 |  | 78 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0072 | C3 | SEQ_FLAG | 하네스·환경 | C3 도구 오류 — 실측[T-2eee1f1c]: SEQ_FLAG 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SCP0111_IntegrationPSI.SetVisibleShe) |
| WK-SCP0111-0073 | C3 | TO_PRODUCT / To Product | 하네스·환경 | C3 도구 오류 — 실측[T-cbb73379]: TO_PRODUCT 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0074 | C3 | TO_SITE / To Site | 하네스·환경 | C3 도구 오류 — 실측[T-1c57e7e6]: TO_SITE 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0111_IntegrationPSI.SetVisibleShe) |
| WK-SCP0111-0075 | C3 | VALUE_TYPE / Valuation Type | 하네스·환경 | C3 도구 오류 — 실측[T-5c2b4d0d]: VALUE_TYPE 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0076 | C6 | CELL_CF / Cell Coversion Factor | 하네스·환경 | C6 도구 오류 — 실측[T-cb8992d7]: CELL_CF 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_ve |  | 3 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0077 | C6 | ITEM_ID / Model | 하네스·환경 | C6 도구 오류 — 실측[T-926a38d8]: ITEM_ID 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_ve |  | 7 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0078 | C6 | MEASURE | 하네스·환경 | C6 도구 오류 — 실측[T-81e79437]: MEASURE 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_ve |  | 5 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0079 | C6 | SCP0111_IntegrationPSI.CboDivision_Selec | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.CboDivision_SelectedIndexChanged 의 C6 6요소: ERROR:6 |  | 2 (ACT:SCP0111_IntegrationPSI.CboDivision_S) |
| WK-SCP0111-0080 | C6 | SCP0111_IntegrationPSI.CboPlanDate_Selec | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.CboPlanDate_SelectedIndexChanged 의 C6 6요소: ERROR:6 |  | 2 (ACT:SCP0111_IntegrationPSI.CboPlanDate_S) |
| WK-SCP0111-0081 | C6 | SCP0111_IntegrationPSI.CboPlanType_Selec | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.CboPlanType_SelectedIndexChanged 의 C6 6요소: ERROR:6 |  | 1 (ACT:SCP0111_IntegrationPSI.CboPlanType_S) |
| WK-SCP0111-0082 | C6 | SCP0111_IntegrationPSI._defaultDataModel | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI._defaultDataModel_Changed 의 C6 6요소: ERROR:6 |  | 78 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0083 | C6 | SEQ_FLAG | 하네스·환경 | C6 도구 오류 — 실측[T-1d3a4351]: SEQ_FLAG 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_v |  | 2 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0084 | C6 | TO_PRODUCT / To Product | 하네스·환경 | C6 도구 오류 — 실측[T-923e5358]: TO_PRODUCT 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기( |  | 4 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0085 | C6 | VALUE_TYPE / Valuation Type | 하네스·환경 | C6 도구 오류 — 실측[T-b8bd4680]: VALUE_TYPE 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기( |  | 3 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0086 | K4 | SCP0111 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-3b3010d2 GENERAL / 원장 V-97eaffab GENERAL / 원장 V-c530b2d7 GENERAL / 원장 V-38c57113 GENERAL / 원장 V-e24201f7 GENERAL / |  | 27 (ACT:SCP0111_IntegrationPSI.BtnCellItem_I) |
| WK-SCP0111-0087 | F2 | SCP0111 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-d61f5787 RULE_SCREEN / 원장 V-129ff7c5 RULE_SCREEN / 원장 V-30816eaf GENERAL / 원장 V-800b7aa0 GENERAL / 원장 V-039a88e2 G |  | 377 (일반 저장 ADMIN 저장 SaveButton InsertButton 필) |
| WK-SCP0111-0088 | F6 | SCP0111 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-64f29823 RULE_SCREEN / 원장 V-4b9aa2ea RULE_SCREEN / 원장 V-b3afa86b RULE_SCREEN / 원장 V-65accf87 RULE_SCREEN / 원장 V-e5 |  | 368 (일반 저장 ADMIN 저장 ACT:SCP0111_IntegrationPS) |
| WK-SCP0111-0089 | F4 | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE | 하네스·환경 | F4 도구 오류 — 실측[T-236699af]: PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: SCP0111/essPackLine/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — |  | 4 (ESS Pack Line ACT:SCP0111_IntegrationPSI) |
| WK-SCP0111-0090 | H2 | ESS 파생검증 D1/D2 불일치 경고 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 ESS 파생검증 D1/D2 불일치 경고 '(경고, 저장 미차단)' 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (ESS 파생검증 D1/D2 불일치 경고) |
| WK-SCP0111-0091 | H2 | Line 미지정("-") 저장 확인 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 Line 미지정("-") 저장 확인 'handleSave confirm 게이트' 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (Line 미지정("-") 저장 확인) |
| WK-SCP0111-0092 | H2 | SCP0111_IntegrationPSI.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.CreateSpread 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 4 (ACT:SCP0111_IntegrationPSI.CreateSpread:) |
| WK-SCP0111-0093 | H2 | SCP0111_IntegrationPSI.SetSpreadColumn | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0111_IntegrationPSI.SetSpreadColumn 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 4 (ACT:SCP0111_IntegrationPSI.SetSpreadColu) |
| WK-SCP0111-0094 | H2 | siMain.SetBGColor2 | 하네스·환경 | H2 도구 오류 — 원장 V-48220ccc |  | 1 (ACT:SCP0111_IntegrationPSI.EditButton:75) |
| WK-SCP0111-0095 | H2 | siMain.SetBGColor2 | 하네스·환경 | H2 도구 오류 — 원장 V-51c1bd06 |  | 1 (ACT:SCP0111_IntegrationPSI.EditButton:78) |
| WK-SCP0111-0096 | H2 | 대상 행 미선택 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 대상 행 미선택 '(제거 — 편집모드 없음, INSERT 는 SAVE 권한으로 게이트)' 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (대상 행 미선택) |
| WK-SCP0111-0097 | H2 | 신규행 중복(INSERT_KEY_COLS) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 신규행 중복(INSERT_KEY_COLS) 'isDuplicateInsertRow' 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (신규행 중복(INSERT_KEY_COLS)) |
| WK-SCP0111-0098 | H2 | 저장 대상 변경 없음 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 저장 대상 변경 없음 'cells/payload 0' 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (저장 대상 변경 없음) |
| WK-SCP0111-0099 | H2 | 저장 성공 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 저장 성공 'callSaveIntegrationPsi ok' 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (저장 성공) |
| WK-SCP0111-0100 | H2 | 저장 실패 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 저장 실패 'callSaveIntegrationPsi !ok' 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (저장 실패) |
| WK-SCP0111-0101 | H2 | 조회기간 from>to 금지 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 조회기간 from>to 금지 'Form 조회 전' 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0102 | H2 | 필수값 공백(15건) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 필수값 공백(15건) 'unfoldSaveCells / 저장 전' 의 H2 5요소: ERROR:2 · NA:2 · PASS:1 |  | 1 (필수값 공백(15건)) |
| WK-SCP0111-0103 | H4 | SCP0111 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-c119ea9a RULE_SCREEN / 원장 V-963e0867 RULE_SCREEN / 원장 V-8511f635 RULE_SCREEN / 원장 V-171648d3 RULE_SCREEN / 원장 V-e1 |  | 4 (ACT:SCP0111_IntegrationPSI.SpdMain_TopCh) |
| WK-SCP0111-0104 | I1 | SCP0111 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-5b8cf7b5 RULE_SCREEN / 원장 V-20b686a3 RULE_SCREEN / 원장 V-198950ce RULE_SCREEN / 원장 V-fc7c6b51 DEFECT / 원장 V-9f001c1 |  | 24 (조회기간 from>to 금지 필수값 공백(15건) OPERATION_GR) |
| WK-SCP0111-0105 | D1 | BOH_QTY / BOH | 하네스·환경 | D1 도구 오류 — 원장 V-08c9996f COLUMN / 원장 V-3fd855b9 COLUMN / 실측[T-77bafcf9]: 기존행 r0 BOH_QTY 편집=true — AS-IS 조건부(행 값으로 계산 불가): RULES:[{ |  | 8 (ACT:SCP0111_IntegrationPSI.EditButton AC) |
| WK-SCP0111-0106 | D1 | DIVISION_ID / Division | 하네스·환경 | D1 도구 오류 — 원장 V-3a4bc752 COLUMN / 원장 V-1e3d943f COLUMN / 실측[T-c2b25b6c]: 기존행 r0 DIVISION_ID 편집=false (AS-IS 잠금) / 신규행 r1 DIVISION_ |  | 2 (ACT:SCP0111_IntegrationPSI.EditButton:54) |
| WK-SCP0111-0107 | D1 | INCOTERMS / Incoterms | 하네스·환경 | D1 도구 오류 — 원장 V-48843285 COLUMN / 원장 V-9cbd9cd8 COLUMN / 실측[T-4297bda0]: [전제 미충족 T300] To Site 후보에서 PLANT('')/비PLANT('') 입력 실패 — 조 |  | 1 (ACT:SCP0111_IntegrationPSI.EditButton:55) |
| WK-SCP0111-0108 | D1 | MEASURE | 하네스·환경 | D1 도구 오류 — 원장 V-0183a369 COLUMN / 원장 V-4b706200 COLUMN / 실측[T-76e5a980]: 기존행 r0 MEASURE 편집=false — AS-IS 조건부(행 값으로 계산 불가): RULES:[ |  | 4 (ACT:SCP0111_IntegrationPSI.EditButton:71) |
| WK-SCP0111-0109 | D1 | PLAN_TYPE / Plan Type | 하네스·환경 | D1 도구 오류 — 원장 V-5f70c87f COLUMN / 원장 V-086773d7 COLUMN / 실측[T-097f964d]: 기존행 r0 PLAN_TYPE 편집=false (AS-IS 잠금) / 신규행 r1 PLAN_TYPE 편 |  | 3 (ACT:SCP0111_IntegrationPSI.EditButton AC) |
| WK-SCP0111-0110 | D1 | SEQ_FLAG | 하네스·환경 | D1 도구 오류 — 원장 V-66ddcf9e COLUMN / 원장 V-e9b3a6a2 COLUMN / 실측[T-0a1e6d2d]: 기존행 r0 SEQ_FLAG 편집=false — AS-IS 조건부(행 값으로 계산 불가): RULES: |  | 8 (ACT:SCP0111_IntegrationPSI.EditButton AC) |
| WK-SCP0111-0111 | D1 | TO_PRODUCT / To Product | 하네스·환경 | D1 도구 오류 — 원장 V-e71635cf COLUMN / 원장 V-0daad5ce COLUMN / 실측[T-352ace9c]: 기존행 r0 TO_PRODUCT 편집=false (AS-IS 잠금) / 신규행 r1 TO_PRODUCT |  | 1 (ACT:SCP0111_IntegrationPSI.EditButton:76) |
| WK-SCP0111-0112 | D1 | TO_SITE / To Site | 하네스·환경 | D1 도구 오류 — 원장 V-c21b9ea7 COLUMN / 원장 V-2b0351c0 COLUMN / 실측[T-3c5146b2]: 기존행 r0 TO_SITE 편집=false — AS-IS 조건부(행 값으로 계산 불가): RULES:[ |  | 3 (ACT:SCP0111_IntegrationPSI.EditButton AC) |
| WK-SCP0111-0113 | D1 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | D1 도구 오류 — 원장 V-d2113726 COLUMN / 원장 V-7855cdb9 COLUMN / 실측[T-ab5293a1]: 기존행 r0 TO_SITE_DESCRIPTION 편집=false (AS-IS 잠금) / 신규행 r1 T |  | 1 (ACT:SCP0111_IntegrationPSI.InsertRow:105) |
| WK-SCP0111-0114 | D1 | UOM | 하네스·환경 | D1 도구 오류 — 원장 V-4962487b COLUMN / 원장 V-b9176ec8 COLUMN / 실측[T-42bea9c6]: 기존행 r0 UOM 편집=false — AS-IS 조건부(행 값으로 계산 불가): RULES:[{"g" |  | 3 (ACT:SCP0111_IntegrationPSI.EditButton AC) |
| WK-SCP0111-0115 | D1 | VALUE_TYPE / Valuation Type | 하네스·환경 | D1 도구 오류 — 원장 V-a5d9e967 COLUMN / 원장 V-dea534da COLUMN / 실측[T-06dea99a]: 기존행 r0 VALUE_TYPE 편집=false (AS-IS 잠금) / 신규행 r1 VALUE_TYPE |  | 2 (ACT:SCP0111_IntegrationPSI.EditButton:72) |
| WK-SCP0111-0116 | D3 | BOH_QTY / BOH | 하네스·환경 | D3 도구 오류 — 실측[T-767918b6]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (division_id != "82" && division_id != "40") / if (meas |  | 8 (ACT:SCP0111_IntegrationPSI.EditButton AC) |
| WK-SCP0111-0117 | D3 | ESS 파생검증 D1/D2 불일치 경고 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 ESS 파생검증 D1/D2 불일치 경고 '(경고, 저장 미차단)' 의 D3 34요소: NA:28 · PASS:5 · ERROR:1 |  | 1 (ESS 파생검증 D1/D2 불일치 경고) |
| WK-SCP0111-0118 | D3 | EditButton | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 EditButton '(제거)' 의 D3 34요소: NA:28 · PASS:5 · ERROR:1 |  | 1 (EditButton) |
| WK-SCP0111-0119 | D3 | Line 미지정("-") 저장 확인 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Line 미지정("-") 저장 확인 'handleSave confirm 게이트' 의 D3 34요소: NA:28 · PASS:5 · ERROR:1 |  | 1 (Line 미지정("-") 저장 확인) |
| WK-SCP0111-0120 | D3 | 대상 행 미선택 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 대상 행 미선택 '(제거 — 편집모드 없음, INSERT 는 SAVE 권한으로 게이트)' 의 D3 34요소: NA:28 · PASS:5 · ERROR:1 |  | 1 (대상 행 미선택) |
| WK-SCP0111-0121 | D3 | 신규행 중복(INSERT_KEY_COLS) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 신규행 중복(INSERT_KEY_COLS) 'isDuplicateInsertRow' 의 D3 34요소: NA:28 · PASS:5 · ERROR:1 |  | 1 (신규행 중복(INSERT_KEY_COLS)) |
| WK-SCP0111-0122 | D3 | 저장 대상 변경 없음 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 저장 대상 변경 없음 'cells/payload 0' 의 D3 34요소: NA:28 · PASS:5 · ERROR:1 |  | 1 (저장 대상 변경 없음) |
| WK-SCP0111-0123 | D3 | 저장 성공 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 저장 성공 'callSaveIntegrationPsi ok' 의 D3 34요소: NA:28 · PASS:5 · ERROR:1 |  | 1 (저장 성공) |
| WK-SCP0111-0124 | D3 | 저장 실패 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 저장 실패 'callSaveIntegrationPsi !ok' 의 D3 34요소: NA:28 · PASS:5 · ERROR:1 |  | 1 (저장 실패) |
| WK-SCP0111-0125 | D3 | 조회기간 from>to 금지 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 조회기간 from>to 금지 'Form 조회 전' 의 D3 34요소: NA:28 · PASS:5 · ERROR:1 |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0126 | D3 | 필수값 공백(15건) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 필수값 공백(15건) 'unfoldSaveCells / 저장 전' 의 D3 34요소: NA:28 · PASS:5 · ERROR:1 |  | 1 (필수값 공백(15건)) |
| WK-SCP0111-0127 | A6 | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE | 하네스·환경 | A6 도구 오류 — 원장 V-a77f1a53 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-c2eca54f]: PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: 화면 진입·조회 경로에서 이 SP 가 |  | 1 (ESS Pack Line) |
| WK-SCP0111-0128 | G1 | FindButton | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindButton 'search=handleSearch' 의 G1 8요소: PASS:4 · NA:3 · ERROR:1 |  | 1 (FindButton) |
| WK-SCP0111-0129 | G1 | MSG00344 | 하네스·환경 | G1 도구 오류 — 원장 V-c73d3323 |  | 1 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0130 | G1 | 메인 조회 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 메인 조회 '`P_SCP0111_GET_INTEGRATION_PSI` (10 IN + O_RC[PIVO' 의 G1 8요소: PASS:4 · NA:3 · ERROR:1 |  | 1 (메인 조회) |
| WK-SCP0111-0131 | G1 | 조회기간 from>to 금지 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 조회기간 from>to 금지 'Form 조회 전' 의 G1 8요소: PASS:4 · NA:3 · ERROR:1 |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0132 | X-ROW | SCP0111_IntegrationPSI.BtnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:5 · ERROR:2 · NA:2 |  | 5 (ACT:SCP0111_IntegrationPSI.BtnItemId_Cli) |
| WK-SCP0111-0133 | X-ROW | SCP0111_IntegrationPSI.BtnNickName_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:5 · ERROR:2 · NA:2 |  | 5 (ACT:SCP0111_IntegrationPSI.BtnNickName_C) |
| WK-SCP0111-0134 | X-ROW | SCP0111_IntegrationPSI.CboDivision_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CboDivision_S) |
| WK-SCP0111-0135 | X-ROW | SCP0111_IntegrationPSI.CboPlanDate_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CboPlanDate_S) |
| WK-SCP0111-0136 | X-ROW | SCP0111_IntegrationPSI.CboPlanType_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CboPlanType_S) |
| WK-SCP0111-0137 | X-ROW | SCP0111_IntegrationPSI.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CreateSpread) |
| WK-SCP0111-0138 | X-ROW | SCP0111_IntegrationPSI.FindData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 17검사 — PASS:9 · NA:6 · ERROR:2 |  | 8 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0139 | X-ROW | SCP0111_IntegrationPSI.GetEssPackLineAll | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — PASS:2 · NOPATH:2 · ERROR:1 |  | 3 (ACT:SCP0111_IntegrationPSI.GetEssPackLin) |
| WK-SCP0111-0140 | X-ROW | SCP0111_IntegrationPSI.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:5 · NA:3 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.InitControls:) |
| WK-SCP0111-0141 | X-ROW | SCP0111_IntegrationPSI.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — NA:6 · ERROR:4 · PASS:1 |  | 60 (ACT:SCP0111_IntegrationPSI.InsertRow ACT) |
| WK-SCP0111-0142 | X-ROW | SCP0111_IntegrationPSI.SetCalendar | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0111_IntegrationPSI.SetCalendar A) |
| WK-SCP0111-0143 | X-ROW | SCP0111_IntegrationPSI.SetChangedPeriod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:3 · NOT_RUN:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0111_IntegrationPSI.SetChangedPer) |
| WK-SCP0111-0144 | X-ROW | SCP0111_IntegrationPSI.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:5 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0111_IntegrationPSI.SetSpreadColu) |
| WK-SCP0111-0145 | X-ROW | SCP0111_IntegrationPSI.SpdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SCP0111_IntegrationPSI.SpdMain_TopCh) |
| WK-SCP0111-0146 | X-ROW | SCP0111_IntegrationPSI._defaultDataModel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 24검사 — ERROR:22 · NA:2 |  | 3 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0147 | X-ROW | SCP0111_IntegrationPSI.spdMain_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 34 (ACT:SCP0111_IntegrationPSI.spdMain_CellC) |
