# 대조표 ↔ 검증 추적표 v2 — DMF0042 (AS-IS DMF0042) · 2026-11-17T15:12:41

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 83행 (nscm-fe\features\demand\src\pages\business-plan\__asis-mapping__.md) · AS-IS 액션 9411행(진입점 + 전 문장) = **9494행** → 검사 인스턴스 **2338개**
- 행 판정: 미검증 9139 · FAIL 329 · 검증완료 26
- 인스턴스 결과: ERROR 1559 · NA 381 · NOT_RUN 241 · REVIEW 88 · NOPATH 27 · FAIL 23 · PASS 17 · WARN 2

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 8 | 0 | 17 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 17 | 6 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 29 | 0 | 9 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 9 | 0 | 14 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 44 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 1 | 11 | 0 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 52 | 5 | 2 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 16 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 6 | 0 | 0 | 39 | 0 | 15 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 12 | 1 | 5 | 293 | 11 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 8 | 1 | 0 | 4 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 8 | 1 | 0 | 4 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 15 | 3 | 0 | 1 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 20 | 4 | 0 | 4 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 0 | 0 | 0 | 0 | 6 | 0 | 8 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 74 | 0 | 11 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 37 | 114 | 18 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 180 | 0 | 7 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 45 | 47 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 358 | 0 | 13 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 2 | 0 | 3 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 9 | 0 | 17 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E2 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 13 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 113 | 3 | 19 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 30 | 121 | 0 | 3 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 149 | 0 | 4 | 1 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 58 | 0 | 2 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 3 | 0 | 49 | 0 | 0 | 0 | 팝업 선택값 반영 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 10 | 0 | 0 | 0 | 0 | 30 | 0 | 4 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 0 | 35 | 0 | 14 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 0 | 0 | 0 | 0 | 50 | 2 | 57 | 6 | 0 | 0 |
| 동적 생성·조회 | 7 | 23 | 2 | 88 | 348 | 33 | 19 | 0 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 51 | 9 | 0 | 13 | 0 | 0 |
| Cascade | 0 | 0 | 0 | 0 | 297 | 119 | 44 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 0 | 531 | 67 | 52 | 0 | 0 | 0 |
| CRUD | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 0 | 240 | 121 | 55 | 4 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 10 | 0 | 0 | 0 | 35 | 30 | 14 | 4 | 0 | 0 |

## FAIL 인스턴스

- A6|ROW:9 — 행 집계 — 대조표 9 'btnProject_Click (L2762~2782)' 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 원장 V-88a4 (대조표 1행)
- A6|ROW:20 — 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 원장 V- (대조표 1행)
- A6|ROW:25 — 행 집계 — 대조표 25 'btnSetPrice_Click (L3115~3136)' 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 원장 V-88 (대조표 1행)
- A6|ROW:Division 분기 33 (사업부분기 전수) — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_DM (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.FindButton — 진입점 집계 4검사 — ERROR:1 · REVIEW:1 · FAIL:1 · NOT_RUN:1 (대조표 2행)
- A6|SP:P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA — 원장 V-9d782ebf SP / 원장 V-88a4c378 SP / 원장 V-163776c3 SP / 원장 V-ffdd9668 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['USER_ID'] ↔ TO-BE ["' || v_Gro / 정렬대조 FAIL 1번째 키부터 다름: (대조표 192행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.FindData — 진입점 집계 29검사 — ERROR:16 · NOT_RUN:8 · NA:2 · REVIEW:1 · FAIL:1 · PASS:1 (대조표 78행)
- X-ROW|ENTRY:DMF0042_1_RTF.FindData — 진입점 집계 7검사 — NOT_RUN:2 · NA:2 · REVIEW:1 · FAIL:1 · ERROR:1 (대조표 21행)
- A6|ENTRY:DMF0042_1_RTF.FindData — 진입점 집계 — 대조표 DMF0042_1_RTF.FindData 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 원장 V-88a4c378 SP / (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_RTF.FindDataMain — 진입점 집계 4검사 — NOT_RUN:1 · REVIEW:1 · FAIL:1 · ERROR:1 (대조표 6행)
- A6|ENTRY:DMF0042_1_RTF.FindDataMain — 진입점 집계 — 대조표 DMF0042_1_RTF.FindDataMain 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 원장 V-88a4c378  (대조표 1행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.FindButton — 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 (대조표 1행)
- A6|ENTRY:DMF0042_2_BizPlan.FindButton — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindButton 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 원장 V-88a4c37 (대조표 2행)
- A6|ENTRY:DMF0042_2_BizPlan.FindData — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindData 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 원장 V-88a4c378  (대조표 34행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.FindData — 진입점 집계 30검사 — ERROR:17 · NOT_RUN:7 · NA:4 · REVIEW:1 · FAIL:1 (대조표 16행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.FindButton — 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 (대조표 2행)
- A6|ENTRY:DMF0042_3_BizPlan.FindButton — 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindButton 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 원장 V-88a4c37 (대조표 1행)
- A6|ENTRY:DMF0042_3_BizPlan.FindData — 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindData 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 원장 V-88a4c378  (대조표 1행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.FindData — 진입점 집계 29검사 — ERROR:17 · NOT_RUN:7 · NA:3 · REVIEW:1 · FAIL:1 (대조표 78행)
- X-ROW|ENTRY:DMF0042_BizPlan.FindButton — 진입점 집계 7검사 — REVIEW:2 · NOT_RUN:2 · FAIL:1 · PASS:1 · ERROR:1 (대조표 2행)
- X-ROW|ENTRY:DMF0042_BizPlan.FindData — 진입점 집계 33검사 — ERROR:16 · NOT_RUN:9 · PASS:3 · REVIEW:2 · NA:2 · FAIL:1 (대조표 78행)
- X-ROW|ENTRY:DMF0042_BizPlan_old.FindButton — 진입점 집계 8검사 — REVIEW:2 · NOT_RUN:2 · ERROR:2 · FAIL:1 · PASS:1 (대조표 2행)
- X-ROW|ENTRY:DMF0042_BizPlan_old.FindData — 진입점 집계 33검사 — ERROR:16 · NOT_RUN:9 · PASS:3 · REVIEW:2 · NA:2 · FAIL:1 (대조표 69행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- D4|COL:PROJECT_CODE82 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- D4|COL:INCOTERMS — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- D4|COL:FCST_TYPE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- E4|MSG:MSG00680 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- G4|COND:clbDivision — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:clbDivision — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbTeam — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:clbTeam — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbCustomer — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:clbCustomer — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbBizType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:clbBizType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbSalesSite — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:clbSalesSite — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbPlantSite — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:clbPlantSite — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbItemType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:clbItemType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:cboBucketType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:cboBucketType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- E4|COND:cboBucketType — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- G4|COND:drpPeriod — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:drpPeriod — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:txtProject — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:txtProject — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:txtItemId — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:txtItemId — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:txtItemId — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:txtOwner — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:txtOwner — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:chkSum — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:chkSum — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:cboQty — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:cboClosed — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:cboClosed — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- M4|BTN:btnProject — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|BTN:btnItemId — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|BTN:btnOwner — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- E4|MSG:MSG00678 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- H6|COND:txtProject — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- M4|COND:txtProject — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- H6|COND:txtItemId — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- M4|COND:txtItemId — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- H6|COND:txtOwner — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- M4|COND:txtOwner — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|BTN:btnColumn — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|BTN:btnMeasure — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- E4|MSG:MSG00679 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- M4|COL:PROJECT_CODE — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:PROJECT_CODE82 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:ITEM_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C6|COL:DEPT_ID40 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C6|COL:END_CUSTOMER40 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C6|COL:SCM_SITE_ID40 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D3|COL:DEPT_ID40 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|COL:END_CUSTOMER40 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|COL:SCM_SITE_ID40 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- E4|MSG:MSG00097 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00429 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- M4|BTN:btnExchangeRate — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|BTN:btnCutOff — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- E4|MSG:MSG00675 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- M4|BTN:btnReplace — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D3|PCOL:REPORT_GROUP8 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- H2|COL:EDIT_FLAG — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|PCOL:REPORT_GROUP8 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- E4|COND:clbTeam — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:clbCustomer — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00108 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00276 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00677 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00676 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- X-REOPEN|SCREEN — 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace
- F4|SP:P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- E4|COND:drpPeriod — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- F4|SP:SCM0001_GET_BIZ_TYPE_BY_DIVISION — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0042_GET_EXCHANGE_PRICE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:SCM0001_GET_LOOKUP_VALUES — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- C1|COND:clbTeam — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:cboClosed — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbBizType — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbCustomer — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbSalesSite — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbPlantSite — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:cboBucketType — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbItemType — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C3|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:PROJECT_CODE82 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- D5|COL:CURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:SCM_SITE_ID81 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:SCM_SITE_ID82 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:BIZ_TYPE_NAME81 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:CELL_PROD_SITE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- C3|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- D3|PCOL:BIZ_TYPE_NAME82 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|PCOL:REPORT_GROUP7 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- F4|SP:P_DMF0042_SAVE_DM_PLN_BP_FCST — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- H5|COL:MEASURE — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- E4|COND:chkSum — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- A5|COL:COLUMN_NAME — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:COLUMN_LABEL_NAME — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:SMALL_CLASS_LABEL_NAME — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:LARGE_CLASS_LABEL_NAME — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- H2|COL:COLUMN_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:COLUMN_LABEL_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:SMALL_CLASS_LABEL_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:LARGE_CLASS_LABEL_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H5|COL:COLUMN_NAME — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:COLUMN_LABEL_NAME — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:SMALL_CLASS_LABEL_NAME — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:LARGE_CLASS_LABEL_NAME — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- D5|COL:COLUMN_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:COLUMN_LABEL_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:SMALL_CLASS_LABEL_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:LARGE_CLASS_LABEL_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- C3|COL:COLUMN_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:COLUMN_LABEL_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:SMALL_CLASS_LABEL_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C3|COL:LARGE_CLASS_LABEL_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- E4|COL:COLUMN_NAME — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COL:COLUMN_LABEL_NAME — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COL:SMALL_CLASS_LABEL_NAME — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COL:LARGE_CLASS_LABEL_NAME — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- H6|COND:clbDivision — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- M3|BTN:btnSetPrice — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- F4|SP:P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- M4|COND:clbDivision — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:DEPT_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:END_CUSTOMER — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:END_CUSTOMER40 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:SCM_SITE_ID40 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:SCM_SITE_ID81 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:SCM_SITE_ID82 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:ITEM_ID40 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:ITEM_NAME — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|POPUP:DMF0042_1_BizPlan — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- A5|COL:ITEM_ID40 — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- M4|COL:DIVISION_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- A5|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- M4|COL:PROJECT_NAME — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C3|COL:PROJECT_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- M4|COL:BIZ_TYPE_NAME81 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C3|COL:BIZ_TYPE_NAME81 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- A5|COL:PROJECT_CODE82 — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- M4|PCOL:BIZ_TYPE_NAME82 — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C2|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C2|COL:UNIT_ENERGY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- M3|POPUP:DMF0042_1_RTF — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO-BE 메타 PROC 를 Div
- A5|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:EXT_INT — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- H2|COL:EXT_INT — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H5|COL:DIVISION_ID — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:PROJECT_CODE — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:ITEM_ID — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:EXT_INT — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- D5|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:EXT_INT — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- F4|SP:P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- D3|PCOL:EDI_QTY — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|PCOL:RESULT — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|PCOL:MKT_FCST — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|PCOL:GAP — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- F4|SP:P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A5|PCOL:DEMAND_OPERATION — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- A5|PCOL:VARIATION_FACTOR — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- C2|PCOL:VARIATION_FACTOR — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C2|PCOL:DEMAND_OPERATION — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C6|PCOL:VARIATION_FACTOR — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C6|PCOL:DEMAND_OPERATION — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C2|PCOL:IMPUTATION_YN — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C6|PCOL:IMPUTATION_YN — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- A5|PCOL:IMPUTATION_YN — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- D5|COL:DEPT_NAME_KO — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:SCM_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- M4|COL:INCOTERMS — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:MEASURE — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:SCM_SITE_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:COMPANY_NAME — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C3|COL:COMPANY_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- M4|COL:CELL_NICK_NAME — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:CELL_CAPA — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:CELL_PER_PACK — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C3|COL:CELL_PER_PACK — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- M4|COL:CELL_PER_MODULE — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C3|COL:CELL_PER_MODULE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- M4|COL:MODULE_PER_PACK — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C3|COL:MODULE_PER_PACK — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- M4|COL:PACK_CORP_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:CELL_CORP_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:EE_CORP_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:ITEM_NICK_NAME — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:BIZ_TYPE — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C3|COL:BIZ_TYPE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- M4|COL:BIZ_TYPE_NAME — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C3|COL:BIZ_TYPE_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- M4|COL:BIZ_UNIT — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C3|COL:BIZ_UNIT — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
