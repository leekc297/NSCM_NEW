# 대조표 ↔ 검증 추적표 v2 — DMF0082 (AS-IS DMF0082) · 2026-10-26T17:31:35

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 443행 (nscm-fe\features\demand\src\pages\forecast-price\__asis-mapping__.md) · AS-IS 액션 3311행(진입점 + 전 문장) = **3754행** → 검사 인스턴스 **1833개**
- 행 판정: 미검증 1790 · FAIL 1739 · 검증완료 175 · 해당없음 50
- 인스턴스 결과: REVIEW 918 · PASS 403 · FAIL 397 · NA 109 · WARN 6

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 13 | 12 | 0 | 15 | 0 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 19 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 2 | 19 | 0 | 17 | 0 | 16 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 8 | 0 | 0 | 26 | 0 | 4 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 50 | 0 | 0 | 16 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 53 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 1 | 10 | 0 | 9 | 0 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 1 | 53 | 0 | 15 | 0 | 2 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 2 | 7 | 0 | 2 | 0 | 6 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 244 | 52 | 0 | 30 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 5 | 24 | 5 | 121 | 0 | 1 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 6 | 3 | 0 | 8 | 0 | 0 | 0 | 0 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 7 | 0 | 0 | 10 | 0 | 0 | 0 | 0 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | **미구현** | 3 | 11 | 0 | 13 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 6 | 13 | 0 | 16 | 0 | 0 | 0 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 13 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 9 | 0 | 51 | 0 | 0 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 76 | 0 | 5 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 69 | 0 | 0 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 14 | 0 | 26 | 0 | 3 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 86 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 8 | 15 | 0 | 9 | 0 | 0 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 5 | 6 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E2 | 편집·검증 | 있음 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 2 | 12 | 0 | 9 | 0 | 0 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 82 | 0 | 16 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 7 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 6 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 60 | 0 | 9 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 57 | 0 | 12 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 43 | 0 | 0 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K4 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 11 | 0 | 0 | 43 | 0 | 0 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 3 | 43 | 0 | 8 | 0 | 0 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 76 | 31 | 0 | 94 | 0 | 22 | 0 | 0 | 0 | 0 |
| 동적 생성·조회 | 255 | 146 | 6 | 230 | 0 | 9 | 0 | 0 | 0 | 0 |
| 콤보 후보 | 22 | 27 | 0 | 47 | 0 | 1 | 0 | 0 | 0 | 0 |
| Cascade | 13 | 9 | 0 | 196 | 0 | 11 | 0 | 0 | 0 | 0 |
| 편집·검증 | 22 | 134 | 0 | 134 | 0 | 45 | 0 | 0 | 0 | 0 |
| CRUD | 0 | 7 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 161 | 0 | 21 | 0 | 0 | 0 | 0 |
| 공통 기능 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 14 | 43 | 0 | 51 | 0 | 0 | 0 | 0 | 0 | 0 |

## FAIL 인스턴스

- C2|ROW:E01 — 행 집계 — C2 51요소: REVIEW:49 · FAIL:2 (대조표 1행)
- F4|ROW:E02 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- D3|COL:M — 원장 V-8243243b ASIS / 원장 V-c03c107d ASIS / 원장 V-e36b7206 ASIS / 원장 V-e885c307 ASIS / 원장 V-c7a9409a ASIS / 원장 V-2282146b ASIS / 원장 V-c6ee1d63 ASIS / 원장 V-9e8c6818 (대조표 14행)
- D3|COL:N — 원장 V-c7a9409a ASIS / 원장 V-0bf11310 ASIS / 원장 V-c7d705d0 ASIS / 원장 V-154a022d ASIS / 원장 V-826a02fb ASIS / 원장 V-f700acb7 ASIS / 원장 V-f7261ea0 ASIS / 원장 V-db62ed6d (대조표 5행)
- F4|ROW:E04 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- A6|ROW:E05 — 실측[T-186dadfa]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 (대조표 1행)
- F4|ROW:E05 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- G1|ROW:E05 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D4|ROW:E06 — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 1행)
- D6|SCREEN — 실측[T-33ab5070]: 조회 2158행 · r1 셀 클릭 후 Insert → 신규행 맨 위(0) · 행 2158→2159 — AS-IS SpreadInfo.Insert(): 활성 행 위치(r1)에 삽입 — 위치 다름 (대조표 30행)
- F5|SCREEN — 원장 V-870c8e49 RULE_SCREEN / 원장 V-890e2cd5 DEFECT / 원장 V-f53564eb DEFECT / 원장 V-efa6ed8d CONFIRMED / 실측[T-ae6f6625]: Insert → 신규행 CRUD_TYPE='I' · 기존행 END_CUSTOME (대조표 141행)
- X-LOC|ROW:E07 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- F3|SCREEN — 원장 V-034eeb35 DEFECT / 실측[T-030c97ce]: M 원본 값 있는 행/신규행 셀 위치 확인 불가(값 '') (대조표 91행)
- X-LOC|ROW:A-01 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- A6|SP:P_DMF0082_GET_MAIN_DATA — 원장 V-20e289c9 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['SORT_ORDER_NO'] ↔ TO-BE ['TO_N / 실측[T-c59d4ef4]: PKG_DMF0082.P_DMF0082_GET_MAIN_DATA: 정렬 키 SORT_ORDER_NO 가 그리드  (대조표 70행)
- G1|ROW:A-01 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D3|COL:MEASURE — 원장 V-6103516a ASIS / 원장 V-0bf11310 ASIS / 원장 V-423cd9a1 ASIS / 원장 V-4554bac9 ASIS / 원장 V-999595f0 ASIS / 원장 V-ad8773f4 ASIS / 원장 V-e5914055 ASIS / 원장 V-3a196c6d (대조표 29행)
- D1|ROW:A-07 — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:A-07 — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- D1|ROW:A-08 — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:A-08 — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- D1|ROW:A-09 — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:A-09 — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- D1|ROW:A-10 — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:A-10 — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- G1|ROW:A-11 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- B1|ROW:A-11 — 행 집계 — B1 15요소: REVIEW:8 · PASS:6 · FAIL:1 (대조표 1행)
- B4|ROW:A-11 — 행 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 (대조표 1행)
- D5|ROW:A-11 — 행 집계 — D5 15요소: NA:8 · PASS:5 · FAIL:2 (대조표 1행)
- B3|ROW:A-11 — 행 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 (대조표 1행)
- D3|COL:AUTHORITY_YN — 원장 V-999595f0 ASIS / 원장 V-f52613e6 ASIS / 원장 V-550094ae ASIS / 원장 V-719c6960 ASIS / 원장 V-ad8773f4 ASIS / 원장 V-d702fad5 ASIS / 원장 V-af265b50 ASIS / 원장 V-819c9996 (대조표 39행)
- G1|ROW:A-13 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D3|COL:I — 원장 V-c7a9409a ASIS / 원장 V-6103516a ASIS / 원장 V-0bf11310 ASIS / 원장 V-6f20d1e8 ASIS / 원장 V-2ba348a5 ASIS / 원장 V-c7d705d0 ASIS / 원장 V-154a022d ASIS / 원장 V-826a02fb (대조표 6행)
- X-LOC|ROW:A-15 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- A5|ROW:A-15 — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 1행)
- H2|ROW:A-15 — 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 1행)
- F4|ROW:A-15 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- A6|ROW:A-15 — 실측[T-9ea3507c]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 (대조표 1행)
- G1|ROW:A-15 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D3|COL:D — 원장 V-0bf11310 ASIS / 원장 V-6f20d1e8 ASIS / 원장 V-2ba348a5 ASIS / 원장 V-f700acb7 ASIS / 원장 V-f7261ea0 ASIS / 원장 V-db62ed6d ASIS / 원장 V-c9d3eb1a ASIS / 원장 V-b24d6ff8 (대조표 5행)
- E3|COL:CURRENCY — 필수 표시 AS-IS *('Currency*') ↔ TO-BE -('Currency' INPUT_TP_CD=S) — 필수 여부 불일치(저장 검증 checkRequiredOfSpread 대상 차이) (대조표 3행)
- X-LOC|ROW:D-07 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- G1|ROW:D-07 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- E3|COL:PROJECT_CODE — 필수 표시 AS-IS *('Project Code*') ↔ TO-BE -('Project Code' INPUT_TP_CD=S) — 필수 여부 불일치(저장 검증 checkRequiredOfSpread 대상 차이) (대조표 2행)
- E3|COL:END_CUSTOMER — 필수 표시 AS-IS *('End Customer*') ↔ TO-BE -('End Customer' INPUT_TP_CD=S) — 필수 여부 불일치(저장 검증 checkRequiredOfSpread 대상 차이) (대조표 1행)
- F4|ROW:D-14 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- F4|ROW:D-15 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- F4|ROW:D-16 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- C2|COL:DIVISION_ID — 실측[T-0d37e73a]: 신규행 DIVISION_ID 콤보 후보 없음 — 내 Division 목록 콤보 미구현(D00-3-009) (대조표 6행)
- G1|COND:clbDivision — 원장 V-c1efd948 SEARCH (대조표 3행)
- D3|COL:DIVISION_ID — 원장 V-f700acb7 ASIS / 원장 V-4554bac9 ASIS / 원장 V-719c6960 ASIS / 원장 V-ad8773f4 ASIS / 실측[T-490630d8]: DIVISION_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 (대조표 12행)
- G1|ROW:DP-01 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D1|ROW:DP-02 — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:DP-02 — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- E3|ROW:DP-02 — 실측[T-62637cb3]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 (대조표 1행)
- D1|ROW:DP-03 — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:DP-03 — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- D1|ROW:DP-04 — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:DP-04 — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- G1|ROW:DP-04 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- E3|ROW:DP-04 — 실측[T-8716611b]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 (대조표 1행)
- F4|ROW:DP-06 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- F4|ROW:DP-07 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- E3|ROW:DP-08 — 실측[T-9553cf3c]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 (대조표 1행)
- H2|ROW:DP-11 — 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 1행)
- D4|ROW:E06-A — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 1행)
- D3|COL:B — 원장 V-c6ee1d63 ASIS / 원장 V-9e8c6818 ASIS / 원장 V-f97c3dcb ASIS / 원장 V-cae669c8 ASIS / 원장 V-819c9996 ASIS / 실측[T-e150e513]: B: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) (대조표 1행)
- G1|ROW:E07-B — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- H2|COL:ITEM_ID — 원장 V-d9d2a8c3 COLUMN / 원장 V-280085f3 ASIS / 실측[T-48c20115]: ITEM_ID: 기존행 편집 불가인데 노랑 · 신규행 편집 불가인데 노랑 (대조표 3행)
- H2|COL:CELL_PROD_SITE_ID — 원장 V-a35fb514 COLUMN / 실측[T-13ca144b]: CELL_PROD_SITE_ID: 기존행 편집 불가인데 노랑 · 신규행 편집 불가인데 노랑 (대조표 2행)
- D4|COL:C — 원장 V-784d4aa4 ASIS / 원장 V-9b36903b ASIS / 실측[T-83ce85d5]: 신규행 C='' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) (대조표 1행)
- G1|ROW:E08-C — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D3|COL:F — 원장 V-c03c107d ASIS / 원장 V-e885c307 ASIS / 원장 V-0bf11310 ASIS / 원장 V-f700acb7 ASIS / 원장 V-f7261ea0 ASIS / 원장 V-db62ed6d ASIS / 원장 V-c9d3eb1a ASIS / 원장 V-b24d6ff8 (대조표 2행)
- A6|ROW:F-02 — 실측[T-0aca18f0]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 (대조표 1행)
- F4|ROW:F-02 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- G1|ROW:F-02 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- B4|COL:FCST_TYPE — 원장 V-67e34115 COLUMN (대조표 5행)
- F4|ROW:F-05 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- F4|ROW:F-06 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- B3|COL:FCST_TYPE — 원장 V-c7a4b5d8 COLUMN (대조표 4행)
- D3|COL:L — 원장 V-8243243b ASIS / 원장 V-c03c107d ASIS / 원장 V-e36b7206 ASIS / 원장 V-e885c307 ASIS / 원장 V-c7a9409a ASIS / 원장 V-2282146b ASIS / 원장 V-c6ee1d63 ASIS / 원장 V-9e8c6818 (대조표 37행)
- G1|ROW:L-03 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- H2|COL:MEASURE — 원장 V-5e7446f0 COLUMN / 실측[T-37ba23e2]: MEASURE: 기존행 편집 불가인데 노랑 · 신규행 편집=true 표시 일치 (대조표 7행)
- B1|COL:CURRENCY — 원장 V-a1173add COLUMN (대조표 4행)
- D5|COL:MEASURE — 실측[T-22cd82b1]: MEASURE: AS-IS TEXT(cell_rules) ↔ TO-BE dataType=1 dataMap=Y — AS-IS TEXT 에디터가 아님 (대조표 5행)
- F4|ROW:M-11 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- F4|ROW:M-12 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- G1|ROW:M-21 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D1|COL:INCOTERMS — 원장 V-935ea8c1 COLUMN / 원장 V-296593a6 COLUMN / 실측[T-02513beb]: To Site 후보에서 PLANT('')/비PLANT('') 입력 실패 — 조건부 잠금 재현 불가(후보 0) (대조표 2행)
- D3|COL:P — 원장 V-0bf11310 ASIS / 원장 V-6f20d1e8 ASIS / 원장 V-2ba348a5 ASIS / 원장 V-c7d705d0 ASIS / 원장 V-154a022d ASIS / 원장 V-39d5c265 ASIS / 원장 V-af265b50 ASIS / 실측[T-2e981994 (대조표 5행)
- G1|ROW:P-04 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D4|COL:I — 원장 V-9b36903b ASIS / 실측[T-e525d615]: 신규행 I='' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) (대조표 3행)
- G1|ROW:P-23 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- A6|ROW:P-24 — 실측[T-19e2aa13]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 (대조표 1행)
- F4|ROW:P-24 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- G1|ROW:P-24 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D3|COL:PROJECT_NAME — 원장 V-d9c042fa ASIS / 원장 V-d702fad5 ASIS / 실측[T-ec363efd]: PROJECT_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 (대조표 6행)
- D3|COL:ITEM_CLASS_NAME — 원장 V-de6fefba ASIS / 원장 V-d98cbb9f ASIS / 실측[T-e8e7ac0f]: ITEM_CLASS_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 (대조표 5행)
- D3|COL:ITEM_NAME — 원장 V-65bbf7d5 ASIS / 원장 V-f452433d ASIS / 실측[T-6b64805f]: ITEM_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 (대조표 5행)
- D3|COL:NICK_NAME — 원장 V-16bb2eee ASIS / 원장 V-07303a9b ASIS / 실측[T-20413ada]: NICK_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 (대조표 5행)
- G1|ROW:PL-33 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- A6|ROW:PL-36 — 실측[T-1cd782b7]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 (대조표 1행)
- F4|ROW:PL-36 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- G1|ROW:PL-36 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- G1|ROW:S-01 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- X-LOC|ROW:S-07 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- F4|ROW:S-07 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- A6|ROW:S-07 — 실측[T-b72b45a9]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 (대조표 1행)
- G1|ROW:S-07 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D3|COL:S — 원장 V-c03c107d ASIS / 원장 V-e885c307 ASIS / 원장 V-c7a9409a ASIS / 원장 V-6103516a ASIS / 원장 V-0bf11310 ASIS / 원장 V-6f20d1e8 ASIS / 원장 V-2ba348a5 ASIS / 원장 V-5b23be70 (대조표 5행)
- F4|ROW:S-19 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- X-LOC|ROW:S-22 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- A6|ROW:S-24 — 실측[T-515232e6]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 (대조표 1행)
- F4|ROW:S-24 — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- G1|ROW:S-24 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- G1|ROW:S-25 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- F4|ROW:CRUD:E02:SAVE — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- F4|ROW:CRUD:E04:SAVE — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- E3|ROW:CRUD:E04:SAVE — 실측[T-6a3d2db5]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 (대조표 1행)
- A6|ROW:CRUD:E05:SEARCH — 실측[T-3bf12ddb]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 (대조표 1행)
- F4|ROW:CRUD:E05:SEARCH — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- G1|ROW:CRUD:E05:SEARCH — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D4|ROW:CRUD:E06:INSERT — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 1행)
- F4|SP:POPUP_GET_FUTUREPRICE_INFO — 실측[T-d7c7bae7]: POPUP_GET_FUTUREPRICE_INFO: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인) — 화면 진입·조회 중 호출 없음 (대조표 1행)
- D1|ROW:MODAL:ExchangeRateModal — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:MODAL:ExchangeRateModal — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- X-LOC|ROW:REQ:CHAT-20260915-PRICEPJTGAP — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- F4|SP:PKG_DMF0082 — 실측[T-3052e069]: PKG_DMF0082: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인) — 화면 진입·조회 중 호출 없음 (대조표 1행)
- X-LOC|ROW:REQ:CHAT-20260915-EXLASTUPD — 구현 위치 실존 안 함: procedures.d.ts 없음 (대조표 1행)
- A5|ROW:REQ:CHAT-20260915-EXLASTUPD — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 1행)
- H2|ROW:REQ:CHAT-20260915-EXLASTUPD — 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 1행)
- D4|ROW:REQ:CHAT-20260915-EXLASTUPD — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 1행)
- G1|ROW:REQ:CHAT-20260915-EXLASTUPD — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- G1|ROW:MODAL:ForecastTemplateModal — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- A5|ROW:MODAL:SavePricePeriodModal — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 1행)
- A5|ROW:MODAL:VersionSelectModal — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 1행)
- H2|ROW:MODAL:VersionSelectModal — 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 1행)
- G1|ROW:MODAL:VersionSelectModal — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- X-LOC|ROW:MODAL:MeasureSelectModal — 구현 위치 실존 안 함: components/modals/MeasureSelectModal.tsx 없음 (대조표 1행)
- D5|COL:DIVISION_ID — 원장 V-09e00564 COLUMN / 실측[T-0230a46d]: DIVISION_ID: AS-IS COMBO(cell_rules) ↔ TO-BE dataType=1 dataMap=N — AS-IS COMBO 에디터가 아님 (대조표 1행)
- D3|COL:SCM_SITE_ID — 원장 V-b24d6ff8 ASIS / 실측[T-e1e055f8]: SCM_SITE_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 (대조표 13행)
- G1|ROW:E01-A — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- G1|ROW:E01-B — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- E3|ROW:E01-B1 — 실측[T-f1796be5]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 (대조표 1행)
- X-LOC|ROW:CRUD:MAIN:SEARCH — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- G1|ROW:CRUD:MAIN:SEARCH — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- X-LOC|ROW:CRUD:MAIN:SEARCH_CURRENT — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- G1|ROW:CRUD:MAIN:SEARCH_CURRENT — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- X-LOC|ROW:CRUD:MAIN:UPDATE — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:CRUD:MAIN:SAVE — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- A5|ROW:CRUD:MAIN:SAVE — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 1행)
- X-LOC|ROW:CRUD:MAIN:UPLOAD — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- D4|ROW:COMMON:UC-01 — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 2행)
- G1|ROW:COMMON:UC-02 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 2행)
- D4|ROW:COMMON:UC-03 — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 2행)
- G1|ROW:COMMON:UC-03 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 2행)
- B1|ROW:COMMON:UC-05 — 행 집계 — B1 15요소: REVIEW:8 · PASS:6 · FAIL:1 (대조표 2행)
- B4|ROW:COMMON:UC-05 — 행 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 (대조표 2행)
- D5|ROW:COMMON:UC-05 — 행 집계 — D5 15요소: NA:8 · PASS:5 · FAIL:2 (대조표 2행)
- G1|ROW:COMMON:UC-06 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 2행)
- X-LOC|ROW:COMMON:UC-07 — 구현 위치 실존 안 함: DataGrid.tsx 없음 (대조표 2행)
- A5|ROW:COMMON:UC-07 — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 2행)
- H2|ROW:COMMON:UC-07 — 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 2행)
- G1|ROW:COMMON:UC-07 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 2행)
- X-LOC|ROW:REQ:1ST-33-2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-33-3 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-33-4 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-35-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-36-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-37-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-37-2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- G1|ROW:REQ:1ST-37-2 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 2행)
- D4|ROW:REQ:1ST-38-1 — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 2행)
- E3|ROW:REQ:1ST-38-1 — 실측[T-f723492f]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 (대조표 2행)
- X-LOC|ROW:REQ:1ST-39-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- G1|ROW:REQ:1ST-39-1 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 2행)
- X-LOC|ROW:REQ:1ST-39-2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- G1|ROW:REQ:1ST-39-2 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 2행)
- X-LOC|ROW:REQ:1ST-39-3 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-40-2 — 구현 위치 실존 안 함: ColumnSelectDualList.tsx 없음 (대조표 2행)
- X-LOC|ROW:REQ:1ST-41-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- E3|ROW:REQ:1ST-41-1 — 실측[T-7e7d1b54]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 (대조표 2행)
- X-LOC|ROW:REQ:1ST-42-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-44-2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-45-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-45-2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-47-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-47-2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-47-3 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-48-2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-48-3 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- C2|ROW:REQ:1ST-48-3 — 행 집계 — C2 51요소: REVIEW:49 · FAIL:2 (대조표 2행)
- X-LOC|ROW:REQ:1ST-48-4 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-49-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-63-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-63-2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-63-3 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-64-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-65-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-65-2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-65-3 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:1ST-66-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- G1|ROW:REQ:1ST-66-1 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 2행)
- X-LOC|ROW:REQ:1ST-67-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- A5|ROW:REQ:CHAT-20260820-1 — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 1행)
- H2|ROW:REQ:CHAT-20260820-1 — 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 1행)
- D4|ROW:REQ:CHAT-20260820-1 — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 1행)
- A5|ROW:L7 `titleSet` 시트 — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 1행)
- H2|ROW:L7 `titleSet` 시트 — 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 1행)
- D4|ROW:L2P `hotkey DELETE` 권한 0그룹 — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 1행)
- G1|ROW:버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02) — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D4|ROW:L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 1행)
- D1|ROW:L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- D1|ROW:AsIncotermsEdit — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:AsIncotermsEdit — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- H2|COL:END_CUSTOMER — 원장 V-7d068c94 COLUMN / 실측[T-221120c7]: END_CUSTOMER: 기존행 편집 불가인데 노랑 · 신규행 편집=true 표시 일치 (대조표 1행)
- H2|COL:SCM_SITE_ID — 원장 V-edfc2808 COLUMN / 원장 V-280085f3 ASIS / 실측[T-4dc83538]: SCM_SITE_ID: 기존행 편집 불가인데 노랑 · 신규행 편집=true 표시 일치 (대조표 1행)
- G1|ROW:EVENT:E-03 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- X-LOC|ROW:EVENT:E-04 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- D3|COL:E — 원장 V-c7a9409a ASIS / 원장 V-6103516a ASIS / 원장 V-2282146b ASIS / 원장 V-c6ee1d63 ASIS / 원장 V-9e8c6818 ASIS / 원장 V-0bf11310 ASIS / 원장 V-999595f0 ASIS / 원장 V-f52613e6 (대조표 4행)
- A5|COL:MEASURE — 원장 V-bea468af COLUMN / 실측[T-f839cdb9]: MEASURE: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 VISIBLE=Y) (대조표 5행)
- H2|COL:INCOTERMS — 원장 V-d5552a30 COLUMN / 실측[T-bb06ef86]: INCOTERMS: 기존행 편집 불가인데 노랑 · 신규행 편집=true 표시 일치 (대조표 2행)
- H2|COL:CURRENCY — 원장 V-9cfe3f33 COLUMN / 실측[T-6d4e5f78]: CURRENCY: 기존행 편집 불가인데 노랑 · 신규행 편집=true 표시 일치 (대조표 1행)
- D3|COL:CURRENCY — 원장 V-0bf11310 ASIS / 실측[T-b3a6c9e2]: CURRENCY: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 (대조표 1행)
- G1|ROW:EVENT:E-12 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- G1|ROW:EVENT:E-14 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D1|ROW:HANDLER:EditButton — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:HANDLER:EditButton — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- A6|ROW:HANDLER:FindData — 실측[T-65112855]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 (대조표 1행)
- F4|ROW:HANDLER:FindData — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- G1|ROW:HANDLER:FindData — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- E3|ROW:HANDLER:FindData — 실측[T-2ee0e938]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 (대조표 1행)
- G1|ROW:HANDLER:Form_Load — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- D4|ROW:HANDLER:InsertRow — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 1행)
- F4|ROW:HANDLER:SaveData — 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 1행)
- E3|ROW:HANDLER:SaveData — 실측[T-4ad3e083]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 (대조표 1행)
- H2|ROW:HANDLER:btnItemId_Click — 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 1행)
- A5|ROW:HANDLER:btnSavePricePeriod_Click — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 1행)
- D1|ROW:HANDLER:btnSavePricePeriod_Click — 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 1행)
- D3|ROW:HANDLER:btnSavePricePeriod_Click — 행 집계 — D3 79요소: FAIL:73 · NA:6 (대조표 1행)
- D4|ROW:HANDLER:cboBucketType_Click — 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 (대조표 1행)
- G1|ROW:HANDLER:clbCustomer_SelectedIndexChanged — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- G1|ROW:HANDLER:clbTeam_SelectedIndexChanged — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- C2|ROW:HANDLER:spdMain_Changed — 행 집계 — C2 51요소: REVIEW:49 · FAIL:2 (대조표 1행)
- C2|COL:INCOTERMS — 실측[T-38610295]: To Site 후보에 PLANT/SALES 타입이 모두 없음(PLANT '' · SALES '', 후보 0) — 사이트 타입 분기 재현 불가 (대조표 1행)
- X-LOC|ROW:DPF-01 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- A5|ROW:DPF-01 — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 1행)
- H2|ROW:DPF-01 — 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 1행)
- G1|ROW:DPF-01 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- X-LOC|ROW:DPF-02 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- G1|ROW:DPF-02 — 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 (대조표 1행)
- X-LOC|ROW:DPF-04 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- A5|ROW:DPF-04 — 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 (대조표 1행)
- H2|ROW:DPF-04 — 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 1행)
- F4|SP:SCM0001_GET_BIZ_TYPE_BY_DIVISION — 실측[T-ed359344]: SCM0001_GET_BIZ_TYPE_BY_DIVISION: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인) — 화면 진입·조회 중 호출 없음 (대조표 3행)
- H2|ENTRY:DMF0082_FcstNPrice_Mgmt.CreateSpread — 진입점 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 (대조표 5행)
- D5|ENTRY:DMF0082_FcstNPrice_Mgmt.CreateSpread — 진입점 집계 — D5 15요소: NA:8 · PASS:5 · FAIL:2 (대조표 5행)
- X-ROW|ENTRY:DMF0082_FcstNPrice_Mgmt.DeleteButton — 진입점 집계 13검사 — REVIEW:11 · FAIL:1 · PASS:1 (대조표 4행)
- X-ROW|ENTRY:DMF0082_FcstNPrice_Mgmt.Draw — 진입점 집계 4검사 — REVIEW:3 · FAIL:1 (대조표 134행)
- D3|LEDGER:V-8243243b — 원장 V-8243243b / 실측[T-834da954]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 (대조표 1행)
- X-ROW|ENTRY:DMF0082_FcstNPrice_Mgmt.EditButton — 진입점 집계 14검사 — REVIEW:7 · FAIL:4 · NA:2 · PASS:1 (대조표 8행)
- D1|ENTRY:DMF0082_FcstNPrice_Mgmt.EditButton — 진입점 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 (대조표 17행)
- D3|ENTRY:DMF0082_FcstNPrice_Mgmt.EditButton — 원장 V-c03c107d ASIS / 원장 V-e36b7206 ASIS / 원장 V-e885c307 ASIS / 실측[T-866a5b0d]: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) (대조표 17행)
- D3|LEDGER:V-c03c107d — 원장 V-c03c107d / 실측[T-4ab90941]: siMain.SetLockFlag: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 (대조표 1행)
- D3|LEDGER:V-e36b7206 — 원장 V-e36b7206 / 실측[T-ad2ca1e4]: siMain.LockColumn2: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 (대조표 1행)
- D3|LEDGER:V-e885c307 — 원장 V-e885c307 / 실측[T-8fb88c57]: siMain.SetLockFlag: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 (대조표 1행)
- X-ROW|ENTRY:DMF0082_FcstNPrice_Mgmt.FindButton — 실측[T-b9427555]: 진입점 집계 6검사 — REVIEW:2 · NOT_RUN:2 · FAIL:1 · PASS:1 (대조표 1행)
- G1|COND:clbTeam — 원장 V-8d4c7bcb SEARCH (대조표 3행)
- G1|COND:txtVersion — 원장 V-2507864c SEARCH (대조표 7행)
- G1|COND:txtItemId — 원장 V-a795197a SEARCH (대조표 2행)
- X-ROW|ENTRY:DMF0082_FcstNPrice_Mgmt.FindData — 실측[T-4db7283f]: 진입점 집계 34검사 — NOT_RUN:27 · PASS:3 · REVIEW:2 · FAIL:1 · TODO:1 (대조표 10행)
- X-ROW|ENTRY:DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision — 진입점 집계 5검사 — REVIEW:3 · PASS:1 · FAIL:1 (대조표 2행)
- B4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision — 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 (대조표 4행)
- B3|ENTRY:DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision — 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 (대조표 4행)
- X-ROW|ENTRY:DMF0082_FcstNPrice_Mgmt.GetBucketType — 진입점 집계 5검사 — REVIEW:3 · PASS:1 · FAIL:1 (대조표 2행)
- B4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetBucketType — 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 (대조표 3행)
- B3|ENTRY:DMF0082_FcstNPrice_Mgmt.GetBucketType — 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 (대조표 3행)
- F4|SP:DMF0003_GET_BUCKET_TYPE_CODE — 실측[T-786235be]: DMF0003_GET_BUCKET_TYPE_CODE: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인) — 화면 진입·조회 중 호출 없음 (대조표 2행)
- B4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook — 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 (대조표 9행)
- B3|ENTRY:DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook — 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 (대조표 9행)
- F4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook — 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 2행)
- B4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetDayRange — 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 (대조표 5행)
- B3|ENTRY:DMF0082_FcstNPrice_Mgmt.GetDayRange — 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 (대조표 5행)
- F4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetDayRange — 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 2행)
- B4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetFcstType — 진입점 집계 — B4 1요소: FAIL:1 (대조표 8행)
- B3|ENTRY:DMF0082_FcstNPrice_Mgmt.GetFcstType — 진입점 집계 — B3 1요소: FAIL:1 (대조표 8행)
- F4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetFcstType — 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 2행)
- F4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetFuturePriceInfo — 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 2행)
- F4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetIncotermsType — 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 2행)
- B4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetLookupValues — 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 (대조표 9행)
- B3|ENTRY:DMF0082_FcstNPrice_Mgmt.GetLookupValues — 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 (대조표 9행)
- F4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetLookupValues — 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 2행)
- B4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetSalesSite — 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 (대조표 9행)
- B3|ENTRY:DMF0082_FcstNPrice_Mgmt.GetSalesSite — 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 (대조표 9행)
- F4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetSalesSite — 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 2행)
- B4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetSalesSite40 — 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 (대조표 9행)
- B3|ENTRY:DMF0082_FcstNPrice_Mgmt.GetSalesSite40 — 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 (대조표 9행)
- F4|ENTRY:DMF0082_FcstNPrice_Mgmt.GetSalesSite40 — 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 (대조표 2행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

