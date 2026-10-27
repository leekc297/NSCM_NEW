# 작업 원장 — SDM1010 · 2026-10-26 12:55

> 검사 인스턴스 464건 중 PASS·NA 332건 외 **132건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 31 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W5 | 검사기 연결 | 1 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 24 | 실행 → PASS |
| W7 | 기대값 확정 | 75 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 75 · 대조표 31 · E2E 24 · FE 1 · 하네스 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 40 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-LOC | GEN |  | 31 |  |  |  |  | 8 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 16 | 9 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  |  |  |  |  | 18 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |

## W2 구현 위치 확인 (31)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SDM1010-0001 | X-LOC | CF-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectRegForm.tsx:128-145 > 143줄 |  | 1 (CF-04) |
| WK-SDM1010-0002 | X-LOC | CF-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectRegForm.tsx:148-154 > 143줄 |  | 1 (CF-05) |
| WK-SDM1010-0003 | X-LOC | CF-13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CF-13) |
| WK-SDM1010-0004 | X-LOC | CF-14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CF-14) |
| WK-SDM1010-0005 | X-LOC | CF-15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CF-15) |
| WK-SDM1010-0006 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (COMMON:UC-04) |
| WK-SDM1010-0007 | X-LOC | CRUD:E09:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E09:SEARCH) |
| WK-SDM1010-0008 | X-LOC | CRUD:E17:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E17:SEARCH) |
| WK-SDM1010-0009 | X-LOC | CRUD:E18:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E18:SEARCH) |
| WK-SDM1010-0010 | X-LOC | CRUD:E19:INSERT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E19:INSERT) |
| WK-SDM1010-0011 | X-LOC | CRUD:E19:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E19:SEARCH) |
| WK-SDM1010-0012 | X-LOC | CRUD:E20:INSERT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E20:INSERT) |
| WK-SDM1010-0013 | X-LOC | CRUD:E20:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E20:SAVE) |
| WK-SDM1010-0014 | X-LOC | CRUD:E21:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E21:SAVE) |
| WK-SDM1010-0015 | X-LOC | CRUD:E23:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E23:SAVE) |
| WK-SDM1010-0016 | X-LOC | CRUD:E23:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E23:SEARCH) |
| WK-SDM1010-0017 | X-LOC | CRUD:E24:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (CRUD:E24:SAVE) |
| WK-SDM1010-0018 | X-LOC | E17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (E17) |
| WK-SDM1010-0019 | X-LOC | E18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (E18) |
| WK-SDM1010-0020 | X-LOC | E19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (E19) |
| WK-SDM1010-0021 | X-LOC | E20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (E20) |
| WK-SDM1010-0022 | X-LOC | E21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (E21) |
| WK-SDM1010-0023 | X-LOC | E22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (E22) |
| WK-SDM1010-0024 | X-LOC | E23 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (E23) |
| WK-SDM1010-0025 | X-LOC | E24 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (E24) |
| WK-SDM1010-0026 | X-LOC | MODAL:ProjectAuthRegModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (MODAL:ProjectAuthRegModal) |
| WK-SDM1010-0027 | X-LOC | P-18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (P-18) |
| WK-SDM1010-0028 | X-LOC | P-19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (P-19) |
| WK-SDM1010-0029 | X-LOC | P-20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (P-20) |
| WK-SDM1010-0030 | X-LOC | P-21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (P-21) |
| WK-SDM1010-0031 | X-LOC | P-22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ProjectAuthRegModal.tsx 없음 |  | 1 (P-22) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SDM1010-0032 | H10 | SDM1010 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SDM1010 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: project-reg.constants.ts, ProjectReg.tsx |  | 24 (E23 P-01 P-02 P-03 P-04 P-05 P-06 P-07 P) |

## W5 검사기 연결 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SDM1010-0033 | F2 | SDM1010 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SDM1010 화면 | 판단불가(대상 단위 SCREEN) | 22 (E06 E20 E21 E23 E24 CF-15 P-04 P-05 P-06) |

## W6 검증 실행 (24)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SDM1010-0034 | J2 | SDM1010 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SDM1010 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 69 (E01 E01-2 E01-3 E02 E03 E04 E05 E06 E09 ) |
| WK-SDM1010-0035 | G3 | SDM1010 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SDM1010 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 5 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SDM1010-0036 | K4 | SDM1010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SDM1010 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 5 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SDM1010-0037 | F1 | SDM1010 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SDM1010 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 28 (E05 E06 E20 E21 E23 E24 CF-15 P-04 P-05 ) |
| WK-SDM1010-0038 | F5 | SDM1010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SDM1010 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 8 (E05 P-07 P-08 P-17 P-24 P-31 P-32 CRUD:E) |
| WK-SDM1010-0039 | I1 | SDM1010 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SDM1010 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 20 (E23 P-01 P-02 P-03 P-04 P-05 P-06 P-07 P) |
| WK-SDM1010-0040 | SC1 | SDM1010 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SDM1010 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (E01 E01-2 P-27 P-28 CRUD:E01:SEARCH COMM) |
| WK-SDM1010-0041 | D6 | SDM1010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SDM1010 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 13 (E04 E19 E20 CF-14 P-19 P-20 P-21 CRUD:E0) |
| WK-SDM1010-0042 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-06) |
| WK-SDM1010-0043 | E4 | MSG00043 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00043 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-05) |
| WK-SDM1010-0044 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-01) |
| WK-SDM1010-0045 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-02) |
| WK-SDM1010-0046 | E4 | MSG00113 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00113 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-04) |
| WK-SDM1010-0047 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SDM1010-0048 | E4 | MSG00706 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00706 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-07) |
| WK-SDM1010-0049 | E4 | MSG00707 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00707 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-08) |
| WK-SDM1010-0050 | E4 | MSG00708 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00708 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-09) |
| WK-SDM1010-0051 | E4 | MSG00709 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00709 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (P-10 P-13) |
| WK-SDM1010-0052 | E4 | MSG00710 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00710 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-11) |
| WK-SDM1010-0053 | E4 | MSG00713 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00713 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-12) |
| WK-SDM1010-0054 | E4 | MSG00714 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00714 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-14) |
| WK-SDM1010-0055 | E4 | MSG00715 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00715 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-03) |
| WK-SDM1010-0056 | E4 | MSG00716 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00716 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-19) |
| WK-SDM1010-0057 | E4 | MSG00717 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00717 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-20) |

## W7 기대값 확정 (75)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SDM1010-0058 | E4 | CRUD:E03:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CRUD:E03:SEARCH: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E03:SEARCH) |
| WK-SDM1010-0059 | E4 | CRUD:E06:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CRUD:E06:SAVE: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E06:SAVE) |
| WK-SDM1010-0060 | E4 | CRUD:E14:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CRUD:E14:SEARCH: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E14:SEARCH) |
| WK-SDM1010-0061 | E4 | CRUD:E23:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CRUD:E23:SAVE: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E23:SAVE) |
| WK-SDM1010-0062 | E4 | CRUD:E23:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CRUD:E23:SEARCH: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E23:SEARCH) |
| WK-SDM1010-0063 | E4 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E03: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (E03) |
| WK-SDM1010-0064 | E4 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E06: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-SDM1010-0065 | E4 | E14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E14: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (E14) |
| WK-SDM1010-0066 | E4 | E23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E23: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (E23) |
| WK-SDM1010-0067 | A1 | CF-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-14: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CF-14) |
| WK-SDM1010-0068 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-02) |
| WK-SDM1010-0069 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-06) |
| WK-SDM1010-0070 | A1 | CRUD:E01:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E01:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E01:SEARCH) |
| WK-SDM1010-0071 | A1 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E02:SEARCH) |
| WK-SDM1010-0072 | A1 | CRUD:E03:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E03:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E03:SEARCH) |
| WK-SDM1010-0073 | A1 | CRUD:E09:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E09:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E09:SEARCH) |
| WK-SDM1010-0074 | A1 | CRUD:E14:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E14:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E14:SEARCH) |
| WK-SDM1010-0075 | A1 | CRUD:E15:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E15:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E15:SEARCH) |
| WK-SDM1010-0076 | A1 | CRUD:E17:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E17:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E17:SEARCH) |
| WK-SDM1010-0077 | A1 | CRUD:E18:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E18:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E18:SEARCH) |
| WK-SDM1010-0078 | A1 | CRUD:E19:INSERT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E19:INSERT: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E19:INSERT) |
| WK-SDM1010-0079 | A1 | CRUD:E19:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E19:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E19:SEARCH) |
| WK-SDM1010-0080 | A1 | CRUD:E23:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E23:SAVE: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E23:SAVE) |
| WK-SDM1010-0081 | A1 | CRUD:E23:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E23:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:E23:SEARCH) |
| WK-SDM1010-0082 | A1 | E01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E01) |
| WK-SDM1010-0083 | A1 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-2: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E01-2) |
| WK-SDM1010-0084 | A1 | E01-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-3: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E01-3) |
| WK-SDM1010-0085 | A1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E02: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E02) |
| WK-SDM1010-0086 | A1 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E03: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E03) |
| WK-SDM1010-0087 | A1 | E09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E09: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E09) |
| WK-SDM1010-0088 | A1 | E14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E14: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E14) |
| WK-SDM1010-0089 | A1 | E15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E15: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E15) |
| WK-SDM1010-0090 | A1 | E17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E17: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E17) |
| WK-SDM1010-0091 | A1 | E18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E18: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E18) |
| WK-SDM1010-0092 | A1 | E19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E19: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E19) |
| WK-SDM1010-0093 | A1 | E23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E23: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E23) |
| WK-SDM1010-0094 | A1 | EndCustomerByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EndCustomerByDivision: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (EndCustomerByDivision) |
| WK-SDM1010-0095 | A1 | P-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-01: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (P-01) |
| WK-SDM1010-0096 | A1 | P-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-02: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (P-02) |
| WK-SDM1010-0097 | A1 | P-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-03: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (P-03) |
| WK-SDM1010-0098 | A1 | P-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-18: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (P-18) |
| WK-SDM1010-0099 | A1 | P-20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-20: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (P-20) |
| WK-SDM1010-0100 | A1 | P-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-27: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (P-27) |
| WK-SDM1010-0101 | A1 | P-28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-28: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (P-28) |
| WK-SDM1010-0102 | A1 | P-32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-32: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (P-32) |
| WK-SDM1010-0103 | A1 | P_MENU_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_MENU_ID: 골든 비교 케이스 없음(P_MENU_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (P-30) |
| WK-SDM1010-0104 | A1 | P_USER_GR_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_USER_GR_ID: 골든 비교 케이스 없음(P_USER_GR_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (P-30) |
| WK-SDM1010-0105 | A1 | P_USER_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_USER_ID: 골든 비교 케이스 없음(P_USER_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (P-30) |
| WK-SDM1010-0106 | A1 | PlantByDivisionCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PlantByDivisionCompany: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (PlantByDivisionCompany) |
| WK-SDM1010-0107 | X-LOC | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BizTypeByDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BizTypeByDivision) |
| WK-SDM1010-0108 | X-LOC | CellTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CellTypeByDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CellTypeByDivision) |
| WK-SDM1010-0109 | X-LOC | DpjtClass | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DpjtClass: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DpjtClass) |
| WK-SDM1010-0110 | X-LOC | EndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EndCustomer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EndCustomer) |
| WK-SDM1010-0111 | X-LOC | EndCustomerByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EndCustomerByDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EndCustomerByDivision) |
| WK-SDM1010-0112 | X-LOC | MyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MyDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MyDivision) |
| WK-SDM1010-0113 | X-LOC | PlantByDivisionCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PlantByDivisionCompany: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PlantByDivisionCompany) |
| WK-SDM1010-0114 | X-LOC | StackMethod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — StackMethod: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (StackMethod) |
| WK-SDM1010-0115 | X-ROW | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BizTypeByDivision: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BizTypeByDivision) |
| WK-SDM1010-0116 | X-ROW | CF-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-01) |
| WK-SDM1010-0117 | X-ROW | CF-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-07) |
| WK-SDM1010-0118 | X-ROW | CF-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-08) |
| WK-SDM1010-0119 | X-ROW | CF-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-09) |
| WK-SDM1010-0120 | X-ROW | CF-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-10) |
| WK-SDM1010-0121 | X-ROW | CF-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-11) |
| WK-SDM1010-0122 | X-ROW | CF-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-12) |
| WK-SDM1010-0123 | X-ROW | CellTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CellTypeByDivision: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CellTypeByDivision) |
| WK-SDM1010-0124 | X-ROW | E01-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E01-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E01-1) |
| WK-SDM1010-0125 | X-ROW | E01-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E01-5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E01-5) |
| WK-SDM1010-0126 | X-ROW | E07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E07) |
| WK-SDM1010-0127 | X-ROW | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E08) |
| WK-SDM1010-0128 | X-ROW | E16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E16: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E16) |
| WK-SDM1010-0129 | X-ROW | EndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EndCustomer: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (EndCustomer) |
| WK-SDM1010-0130 | X-ROW | MyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MyDivision: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MyDivision) |
| WK-SDM1010-0131 | X-ROW | P-26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — P-26: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (P-26) |
| WK-SDM1010-0132 | X-ROW | P-29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — P-29: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (P-29) |
