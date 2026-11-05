# 대조표 ↔ 검증 추적표 v2 — DMF0021 (AS-IS DMF0021) · 2026-11-04T10:43:50

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 686행 (nscm-fe\features\demand\src\pages\sales-plan\__asis-mapping__.md) · AS-IS 액션 3787행(진입점 + 전 문장) = **4473행** → 검사 인스턴스 **2561개**
- 행 판정: 미검증 3587 · 검증완료 498 · FAIL 233 · 해당없음 155
- 인스턴스 결과: ERROR 729 · NOT_RUN 573 · NA 479 · PASS 288 · REVIEW 279 · FAIL 138 · NOPATH 75

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 7 | 0 | 9 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 12 | 16 | 6 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 59 | 6 | 51 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 6 | 0 | 10 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 51 | 0 | 0 | 60 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 59 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 14 | 0 | 1 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 39 | 4 | 16 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 15 | 0 | 16 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 226 | 46 | 0 | 152 | 0 | 9 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 8 | 29 | 125 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 12 | 0 | 13 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 12 | 0 | 13 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 26 | 4 | 11 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 38 | 4 | 15 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 0 | 0 | 0 | 0 | 18 | 0 | 8 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 31 | 9 | 41 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 37 | 2 | 27 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 18 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 31 | 3 | 53 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 118 | 0 | 53 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 118 | 85 | 77 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 30 | 0 | 5 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 15 | 0 | 14 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 4 | 0 | 7 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E2 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 8 | 91 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 61 | 13 | 41 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 12 | 0 | 6 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 1 | 9 | 31 | 2 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 10 | 0 | 33 | 0 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 7 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 10 | 0 | 22 | 0 | 0 | 0 | 팝업 선택값 반영 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 3 | 0 | 0 | 0 | 0 | 79 | 0 | 8 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 0 | 75 | 4 | 11 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 51 | 1 | 0 | 60 | 72 | 18 | 90 | 6 | 0 | 0 |
| 동적 생성·조회 | 226 | 46 | 0 | 219 | 97 | 138 | 35 | 1 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 0 | 88 | 8 | 52 | 0 | 0 |
| Cascade | 0 | 0 | 0 | 0 | 117 | 32 | 129 | 0 | 0 | 0 |
| 편집·검증 | 8 | 91 | 0 | 0 | 346 | 111 | 199 | 6 | 0 | 0 |
| CRUD | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 0 | 22 | 9 | 93 | 2 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| DB 실행·접근 | 3 | 0 | 0 | 0 | 75 | 83 | 11 | 8 | 0 | 0 |

## FAIL 인스턴스

- X-LOC|ROW:E04 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:99-213 > 203줄 (대조표 1행)
- X-LOC|ROW:E06 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 (대조표 1행)
- E3|ROW:E07 — 행 집계 — 대조표 E07 '§7 FindData (F5) — 조회 (FindButton L669~672 → FindD' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *( (대조표 1행)
- H10|SCREEN — 표준 메시지 대신 브라우저 alert/confirm 직접 호출: utils/sales-plan.validate.ts (대조표 39행)
- E3|ROW:CA-126 — 행 집계 — 대조표 CA-126 '§1.4 [원문 무번호] SaveData 필수컬럼 ⭐E20260512 / `Substrin' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CA-128 — 행 집계 — 대조표 CA-128 '§1.4 [원문 무번호] SaveData 미실패 시 MSG00113 / 상기 조합' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('T (대조표 1행)
- E3|ROW:CA-129 — 행 집계 — 대조표 CA-129 '§1.4 [원문 무번호] SaveData 행별 필수값 / `sDivisionId==""` ' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CA-130 — 행 집계 — 대조표 CA-130 '§1.4 [원문 무번호] SaveData 행별 필수값 / `!="40" && sProjec' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CA-134 — 행 집계 — 대조표 CA-134 '§1.4 [원문 무번호] SaveData 행별 필수값 / `=="40" && Catch_U' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CA-135 — 행 집계 — 대조표 CA-135 '§1.4 [원문 무번호] SaveData 행별 필수값 / `=="40" && Catch_U' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CA-137 — 행 집계 — 대조표 CA-137 '§1.4 [원문 무번호] SaveData 행별 필수값 / `=="40" && sCellPr' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CA-138 — 행 집계 — 대조표 CA-138 '§1.4 [원문 무번호] SaveData (공통 무분기) / sScmSiteId/sItem' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CA-139 — 행 집계 — 대조표 CA-139 '§1.4 [원문 무번호] SaveData 실패 메시지 / MSG00002(sMsg) + 포' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- X-LOC|ROW:CA-152 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 (대조표 1행)
- X-LOC|ROW:CA-153 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 (대조표 1행)
- X-LOC|ROW:CA-154 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 (대조표 1행)
- X-LOC|ROW:CB-109 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 (대조표 1행)
- X-LOC|ROW:CB-110 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 (대조표 1행)
- X-LOC|ROW:CC-01 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:71-71 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-03 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:69-69 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-06 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:70-70 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-09 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:68-68 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-107 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-117 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-12 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-17 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:75-75 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-18 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:76-76 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-19 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:77-77 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-20 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-88 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-21 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:71-72 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-22 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:73-73 > 50줄 (대조표 1행)
- X-LOC|ROW:CC-25 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:80-82 > 50줄 (대조표 1행)
- E3|ROW:CD-113 — 행 집계 — 대조표 CD-113 '§4.1 [원문 무번호] 버킷-prefix 일치 검증 / `Weekly && W_` 또는 ' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CD-119 — 행 집계 — 대조표 CD-119 '§4.1 [원문 무번호] FindData — 기간 역전 / `sPeriod[0] > sPe' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CD-120 — 행 집계 — 대조표 CD-120 '§4.1 [원문 무번호] FindData — 기간 상한 / `Value1.AddYears(' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CD-130 — 행 집계 — 대조표 CD-130 '§4.2 [원문 무번호] **편집 중 버킷 변경 금지** / `!siMain.IsLock(' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- E3|ROW:CD-137 — 행 집계 — 대조표 CD-137 '§4.2 [원문 무번호] 저장 0건 검증 / iDateCount==0 → MSG00146(' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE (대조표 1행)
- X-LOC|ROW:CE-105 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:75-75 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-100 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-101 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-102 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-103 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-104 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-105 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-106 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-107 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-108 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-87 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-88 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-89 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-91 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-92 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-93 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-94 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-95 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-96 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-98 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CF-99 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)
- X-LOC|ROW:CG-00 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 (대조표 1행)
- E3|ROW:CG-01 — 행 집계 — 대조표 CG-01 '§7.2 EditButton 필수컬럼 / `Substring(0,2)=="81" && Ge' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE  (대조표 1행)
- E3|ROW:CG-02 — 행 집계 — 대조표 CG-02 '§7.2 SaveData 필수컬럼 / 동일 2개 조건식 → MSG00113 후 저장 차단' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE * (대조표 1행)
- X-LOC|ROW:CRUD:E04:SAVE — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:99-213 > 203줄 (대조표 1행)
- E3|ROW:CRUD:E07:SEARCH — 행 집계 — 대조표 CRUD:E07:SEARCH '[SEARCH] §7 FindData (F5) — 조회 (FindButton L669~67' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team' (대조표 1행)
- E3|ROW:33 — 행 집계 — 대조표 33 'EditButton' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장  (대조표 2행)
- E3|ROW:37 — 행 집계 — 대조표 37 'ExportExcel' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 (대조표 1행)
- E3|ROW:5 — 행 집계 — 대조표 5 'InitControls' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 (대조표 1행)
- E3|ROW:6 — 행 집계 — 대조표 6 'txtProject_KeyDown' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부  (대조표 1행)
- E3|ROW:7 — 행 집계 — 대조표 7 'txtItemId_KeyDown' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불 (대조표 1행)
- E3|ROW:9 — 행 집계 — 대조표 9 'EditButton' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검 (대조표 1행)
- E3|ROW:10 — 행 집계 — 대조표 10 'EditButton' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장  (대조표 1행)
- E3|ROW:11 — 행 집계 — 대조표 11 'EditButton' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장  (대조표 1행)
- E3|COL:DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 checkRequiredOfSpread 대상 차이) (대조표 6행)
- E3|ROW:28 — 행 집계 — 대조표 28 'EditButton' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장  (대조표 1행)
- E3|ROW:31 — 행 집계 — 대조표 31 'EditButton' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장  (대조표 1행)
- E3|ROW:32 — 행 집계 — 대조표 32 'EditButton' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장  (대조표 1행)
- E3|ROW:34 — 행 집계 — 대조표 34 'EditButton' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장  (대조표 1행)
- E3|ROW:35 — 행 집계 — 대조표 35 'EditButton' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장  (대조표 1행)
- E3|ROW:38 — 행 집계 — 대조표 38 'ExportExcel' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 (대조표 1행)
- E3|ROW:39 — 행 집계 — 대조표 39 'FindData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:40 — 행 집계 — 대조표 40 'FindData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:41 — 행 집계 — 대조표 41 'FindData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:42 — 행 집계 — 대조표 42 'FindData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:43 — 행 집계 — 대조표 43 'FindData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:45 — 행 집계 — 대조표 45 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:59 — 행 집계 — 대조표 59 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:60 — 행 집계 — 대조표 60 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:61 — 행 집계 — 대조표 61 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:62 — 행 집계 — 대조표 62 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:63 — 행 집계 — 대조표 63 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:64 — 행 집계 — 대조표 64 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:65 — 행 집계 — 대조표 65 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:66 — 행 집계 — 대조표 66 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:67 — 행 집계 — 대조표 67 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:68 — 행 집계 — 대조표 68 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:69 — 행 집계 — 대조표 69 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:70 — 행 집계 — 대조표 70 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:71 — 행 집계 — 대조표 71 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:73 — 행 집계 — 대조표 73 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:74 — 행 집계 — 대조표 74 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:75 — 행 집계 — 대조표 75 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:76 — 행 집계 — 대조표 76 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:77 — 행 집계 — 대조표 77 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:78 — 행 집계 — 대조표 78 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:79 — 행 집계 — 대조표 79 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:80 — 행 집계 — 대조표 80 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:81 — 행 집계 — 대조표 81 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:82 — 행 집계 — 대조표 82 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:83 — 행 집계 — 대조표 83 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:84 — 행 집계 — 대조표 84 'SaveData' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 (대조표 1행)
- E3|ROW:85 — 행 집계 — 대조표 85 'InsertRow' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검 (대조표 1행)
- E3|ROW:88 — 행 집계 — 대조표 88 'InsertRow' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검 (대조표 1행)
- E3|ROW:89 — 행 집계 — 대조표 89 'InsertRow' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검 (대조표 1행)
- E3|ROW:90 — 행 집계 — 대조표 90 'InsertRow' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검 (대조표 1행)
- E3|ROW:91 — 행 집계 — 대조표 91 'InsertRow' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검 (대조표 1행)
- E3|ROW:92 — 행 집계 — 대조표 92 'InsertRow' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검 (대조표 1행)
- E3|ROW:97 — 행 집계 — 대조표 97 'btnProject_Click' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불 (대조표 1행)
- E3|ROW:98 — 행 집계 — 대조표 98 'spdMain_CellDoubleClick' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) —  (대조표 1행)
- E3|ROW:102 — 행 집계 — 대조표 102 'fnValidation' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치( (대조표 1행)
- E3|ROW:103 — 행 집계 — 대조표 103 'fnValidation' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치( (대조표 1행)
- E3|ROW:104 — 행 집계 — 대조표 104 'fnValidation' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치( (대조표 1행)
- E3|ROW:105 — 행 집계 — 대조표 105 'fnValidation' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치( (대조표 1행)
- E3|ROW:106 — 행 집계 — 대조표 106 'fnValidation' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치( (대조표 1행)
- E3|ROW:107 — 행 집계 — 대조표 107 'fnValidation' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치( (대조표 1행)
- E3|ROW:108 — 행 집계 — 대조표 108 'fnValidation' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치( (대조표 1행)
- E3|ROW:109 — 행 집계 — 대조표 109 'fnValidation' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치( (대조표 1행)
- E3|ROW:110 — 행 집계 — 대조표 110 'spdMain_TextChanged' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수  (대조표 1행)
- E3|ROW:111 — 행 집계 — 대조표 111 'spdMain_EditChange' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여 (대조표 1행)
- E3|ROW:135 — 행 집계 — 대조표 135 'spdMain_ComboSelChange' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) —  (대조표 1행)
- E3|ROW:136 — 행 집계 — 대조표 136 'spdMain_ComboSelChange' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) —  (대조표 1행)
- E3|ROW:137 — 행 집계 — 대조표 137 'spdMain_ComboSelChange' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) —  (대조표 1행)
- E3|ROW:138 — 행 집계 — 대조표 138 'clbDivision_SelectedIndexChanged' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP (대조표 1행)
- E3|ROW:139 — 행 집계 — 대조표 139 'clbTeam_SelectedIndexChanged' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD= (대조표 1행)
- E3|ROW:140 — 행 집계 — 대조표 140 'cboBucketType_Click' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수  (대조표 1행)
- E3|ROW:141 — 행 집계 — 대조표 141 'cboBucketType_Click' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수  (대조표 1행)
- E3|ROW:HANDLER:FindData — 행 집계 — 대조표 HANDLER:FindData 'AS-IS `DMF0021_SalesPlan.cs:1465` (라이브 116행)' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('Team') ↔ T (대조표 1행)
- X-LOC|ROW:HANDLER:SaveData — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:99-213 > 203줄 (대조표 1행)
- E3|ROW:HANDLER:cboBucketType_Click — 행 집계 — 대조표 HANDLER:cboBucketType_Click 'AS-IS `DMF0021_SalesPlan.cs:5512` (라이브 7행)' 의 E3 10요소: PASS:8 · NOT_RUN:1 · FAIL:1 · FAIL 요소: DEPT_ID — 필수 표시 AS-IS -('T (대조표 1행)
- X-LOC|ROW:HANDLER:spdMain_ComboSelChange — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 (대조표 1행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- C2|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- J2|SCREEN — 검사기 있음(auth·authcrud spec) — 실행 필요: 원장 행 실행(@verify)
- F1|SCREEN — 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: 원장 행 실행(@verify)
- F6|SCREEN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- F2|SCREEN — 검사기 있음(_verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: 원장 행 실행(@verify)
- F3|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: 원장 행 실행(@verify)
- H6|BTN:btnProject — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|BTN:btnProject — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|BTN:btnProject — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D1|COL:PLANT_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:PLANT_SITE_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- E4|COL:PLANT_SITE_ID — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00113 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D1|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:MEASURE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D3|COL:DIVISION_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- E4|COL:END_CUSTOMER — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COL:INCOTERMS — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00002 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00429 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00085 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- A5|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:PLANT_SITE_ID — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- H5|COL:DIVISION_ID — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:PLANT_SITE_ID — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H2|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:PLANT_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H6|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- H6|COL:I — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:PROJECT_CODE — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:I — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COL:PROJECT_CODE — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:I — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D4|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- D4|COL:I — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- C2|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H6|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:ITEM_ID — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COL:ITEM_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D1|COL:INCOTERMS — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:INCOTERMS — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- D4|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- C2|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C2|COL:END_CUSTOMER40 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:END_CUSTOMER40 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:END_CUSTOMER40 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C2|COL:SCM_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:SCM_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:SCM_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:DEPT_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:DEPT_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00108 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00164 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00361 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00227 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00146 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E4|MSG:MSG00670 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- F5|SCREEN — 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: 원장 행 실행(@verify)
- G4|COND:clbDivision — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- SC1|SCREEN — 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke
- G1|COND:clbDivision — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:clbDivision — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbTeam — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:clbTeam — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:clbTeam — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbCustomer — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:clbCustomer — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:clbCustomer — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbBizType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:clbBizType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:clbBizType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbSalesSite — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:clbSalesSite — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:clbSalesSite — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbPlantSite — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:clbPlantSite — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:clbPlantSite — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbItemType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:clbItemType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:clbItemType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:cboBucketType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:cboBucketType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:cboBucketType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- E4|COND:cboBucketType — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- G4|COND:drpPeriod — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:drpPeriod — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:drpPeriod — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- H5|COND:drpPeriod — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: 원장 행 실행(@verify)
- G4|COND:txtProject — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:txtProject — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:txtProject — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:txtItemId — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:txtItemId — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:txtItemId — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:txtOwner — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:txtOwner — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:txtOwner — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:chkSum — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:chkSum — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:chkSum — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:chkColor — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:chkColor — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:chkColor — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- A5|COL:N — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- G4|COND:cboCellQty — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:cboCellQty — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: 원장 행 실행(@verify)
- G6|COND:cboCellQty — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- H6|BTN:btnItemId — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- H6|BTN:btnOwner — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|BTN:btnItemId — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- G5|BTN:btnOwner — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|BTN:btnItemId — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|BTN:btnOwner — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D1|COL:D — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:D — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- E4|COL:D — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: 원장 행 실행(@verify)
- E3|COL:D — 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요: trace
- H2|COL:D — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- H6|COND:txtProject — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- H6|COL:D — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|COND:txtProject — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:D — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COND:txtProject — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:D — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- H6|COND:txtItemId — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- M4|COND:txtItemId — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- H6|COND:txtOwner — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- G5|COND:txtOwner — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|COND:txtOwner — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- H6|BTN:btnColumn — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- H6|COL:C — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|BTN:btnColumn — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- G5|COL:C — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|BTN:btnColumn — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COL:C — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- H6|BTN:btnMeasure — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: 원장 행 실행(@verify)
- G5|BTN:btnMeasure — 검사기 있음(popup_args_check.py · _verify.spec(@verify)) — 실행 필요: 원장 행 실행(@verify)
- M4|BTN:btnMeasure — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C2|COL:D — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- C3|COL:D — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- C6|COL:D — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- D5|COL:D — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- E1|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace
- E1|COL:D — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace
- E1|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace
- C3|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행 실행(@verify)
- D5|COL:ITEM_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- A5|COL:D — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:C — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- D1|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:C — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H4|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: 원장 행 실행(@verify)
- H3|COL:D — 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace
- H2|COL:DEPT_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)
- D1|COL:TEAM_INCHARGE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:TEAM_INCHARGE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:TEAM_INCHARGE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:PROJECT_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:PROJECT_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:PROJECT_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:PROJECT_OWNER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:PROJECT_OWNER — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:PROJECT_OWNER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:ITEM_CLASS_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:ITEM_CLASS_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:ITEM_CLASS_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:ITEM_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:ITEM_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:ITEM_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:SALES_COMPANY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:SALES_COMPANY — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:SALES_COMPANY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:SALES_PLANT — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:SALES_PLANT — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:SALES_PLANT — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:SALES_PLAN_ADJUST_YN — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:SALES_PLAN_ADJUST_YN — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:SALES_PLAN_ADJUST_YN — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:INCOTERMS — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:OWNER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:OWNER — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:OWNER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:COUNTRY_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:COUNTRY_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:COUNTRY_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:CITY_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:CITY_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: 원장 행 실행(@verify)
- H2|COL:CITY_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- D1|COL:FORECAST_INFO_PRODUCT_GROUP — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
