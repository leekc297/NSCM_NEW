# 대조표 ↔ 검증 추적표 v2 — SCP0104 (AS-IS SCP0104) · 2026-11-17T17:49:32

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 114행 (nscm-fe\features\supply\src\pages\capa-line-assign\__asis-mapping__.md) · AS-IS 액션 3035행(진입점 + 전 문장) = **3149행** → 검사 인스턴스 **1381개**
- 행 판정: 검증완료 2380 · FAIL 590 · 해당없음 178 · 미구현 1
- 인스턴스 결과: PASS 787 · NA 413 · FAIL 181

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 41 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 22 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 35 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 36 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 3 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 49 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 9 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 36 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 9 | 0 | 0 | 0 | 0 | 10 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 44 | 1 | 0 | 0 | 0 | 63 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-NOTIMPL | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 미구현 = 구현 대상(FAIL) |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 185 | 61 | 0 | 0 | 0 | 43 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 3 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 3 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 61 | 0 | 0 | 0 | 0 | 37 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 28 | 35 | 0 | 0 | 0 | 37 | 0 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 11 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 10 | 20 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 35 | 0 | 0 | 0 | 0 | 22 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 5 | 25 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 36 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 33 | 0 | 0 | 0 | 0 | 14 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 30 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 5 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 4 | 0 | 0 | 0 | 0 | 64 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 1 | 3 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 11 | 10 | 0 | 0 | 0 | 19 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 36 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 4 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 17 | 13 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 9 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 1 | 13 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 142 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 |
| 동적 생성·조회 | 287 | 62 | 0 | 0 | 0 | 169 | 0 | 0 | 0 | 0 |
| 콤보 후보 | 95 | 35 | 0 | 0 | 0 | 78 | 0 | 0 | 0 | 0 |
| Cascade | 64 | 45 | 0 | 0 | 0 | 28 | 0 | 0 | 0 | 0 |
| 편집·검증 | 110 | 3 | 0 | 0 | 0 | 98 | 0 | 0 | 0 | 0 |
| CRUD | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 68 | 23 | 0 | 0 | 0 | 30 | 0 | 0 | 0 | 0 |
| 공통 기능 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 10 | 13 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 |

## FAIL 인스턴스

- G5|ROW:영역2 조회조건 S01~S15 — 행 집계 — 대조표 영역2 조회조건 S01~S15 '15' 의 G5 29요소: NA:18 · PASS:10 · FAIL:1 · FAIL 요소: SCP0104_CAPA_Line_Assign_Model — 실측[T-79cc3699]: [정적 판정] AS-IS 는 메인 조회조건 Site, P (대조표 1행)
- M4|ROW:영역2 조회조건 S01~S15 — 행 집계 — 대조표 영역2 조회조건 S01~S15 '15' 의 M4 23요소: PASS:17 · NA:4 · FAIL:2 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3de1469]: [정적 판정] AS-IS 는 Item 팝업에서 여러 행을 고르고 OK 하면  (대조표 1행)
- G5|ROW:팝업 P01~P04 — 행 집계 — 대조표 팝업 P01~P04 '4' 의 G5 29요소: NA:18 · PASS:10 · FAIL:1 · FAIL 요소: SCP0104_CAPA_Line_Assign_Model — 실측[T-79cc3699]: [정적 판정] AS-IS 는 메인 조회조건 Site, Plant, B (대조표 1행)
- M4|ROW:팝업 P01~P04 — 행 집계 — 대조표 팝업 P01~P04 '4' 의 M4 23요소: PASS:17 · NA:4 · FAIL:2 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3de1469]: [정적 판정] AS-IS 는 Item 팝업에서 여러 행을 고르고 OK 하면 고른 건수만큼 (대조표 1행)
- M4|COL:NICK_NAME — 실측[T-f3de1469]: [정적 판정] AS-IS 는 Item 팝업에서 여러 행을 고르고 OK 하면 고른 건수만큼 Assign 행을 추가함. TO-BE 그리드 셀 경로는 단일 선택이라 1건만 현재 행에 반영함. CapaLineAssign.tsx:900-907 주석의 OK 버튼 없음  (대조표 19행)
- B4|ROW:셀 콤보 16종 — 행 집계 — 대조표 셀 콤보 16종 '`SheetUtils.SetComboDataRow` 60+ 런타임 주입' 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정 (대조표 1행)
- E5|ROW:셀 콤보 16종 — 행 집계 — 대조표 셀 콤보 16종 '`SheetUtils.SetComboDataRow` 60+ 런타임 주입' 의 E5 3요소: FAIL:1 · PASS:1 · NA:1 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-4ae38c68]: [정적 판 (대조표 1행)
- C2|ROW:코드↔명칭 동기 — 행 집계 — 대조표 코드↔명칭 동기 '`CheckValidId`/`CheckValidName`(cs:3160-3699)' 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2f6848 (대조표 1행)
- C6|ROW:코드↔명칭 동기 — 행 집계 — 대조표 코드↔명칭 동기 '`CheckValidId`/`CheckValidName`(cs:3160-3699)' 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화면 재현 (대조표 1행)
- G5|ROW:행 추가 — 행 집계 — 대조표 행 추가 '`Insert_Row_Assign`/`_Line`/`_Sop`' 의 G5 29요소: NA:18 · PASS:10 · FAIL:1 · FAIL 요소: SCP0104_CAPA_Line_Assign_Model — 실측[T-79cc3699]: [정적 판정] AS- (대조표 1행)
- M4|ROW:행 추가 — 행 집계 — 대조표 행 추가 '`Insert_Row_Assign`/`_Line`/`_Sop`' 의 M4 23요소: PASS:17 · NA:4 · FAIL:2 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3de1469]: [정적 판정] AS-IS 는 Item 팝 (대조표 1행)
- F4|ROW:저장 — 행 집계 — 대조표 저장 '`SaveData` `^`/`;` 다발' 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품목명 Dummy 코드 생성  (대조표 1행)
- C2|ROW:B04~B09 — 행 집계 — 대조표 B04~B09 '`_defaultDataModel_Changed` 재진입/타입 가드' 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2f6848]: [정적 판정 (대조표 1행)
- C6|ROW:B04~B09 — 행 집계 — 대조표 B04~B09 '`_defaultDataModel_Changed` 재진입/타입 가드' 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화면 재현(2026-11- (대조표 1행)
- G5|ROW:B11~B13 — 행 집계 — 대조표 B11~B13 'Insert 가드' 의 G5 29요소: NA:18 · PASS:10 · FAIL:1 · FAIL 요소: SCP0104_CAPA_Line_Assign_Model — 실측[T-79cc3699]: [정적 판정] AS-IS 는 메인 조회조건 Site, Pla (대조표 1행)
- M4|ROW:B11~B13 — 행 집계 — 대조표 B11~B13 'Insert 가드' 의 M4 23요소: PASS:17 · NA:4 · FAIL:2 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3de1469]: [정적 판정] AS-IS 는 Item 팝업에서 여러 행을 고르고 OK 하면 고른 (대조표 1행)
- B4|ROW:B26~B33 — 행 집계 — 대조표 B26~B33 '셀 콤보/클릭 가드' 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cell 모드 Division 81 기준 A (대조표 1행)
- E5|ROW:B26~B33 — 행 집계 — 대조표 B26~B33 '셀 콤보/클릭 가드' 의 E5 3요소: FAIL:1 · PASS:1 · NA:1 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-4ae38c68]: [정적 판정] [사용자 확정 11-17 · 권장안] 후보가 '- (대조표 1행)
- M4|COL:ITEM_ID — 실측[T-2ad5be22]: [정적 판정] AS-IS 는 Item 팝업에서 여러 행을 고르고 OK 하면 고른 건수만큼 Assign 행을 추가함. TO-BE 그리드 셀 경로는 단일 선택이라 1건만 현재 행에 반영함. CapaLineAssign.tsx:900-907 주석의 OK 버튼 없음  (대조표 13행)
- G5|ROW:버튼 노출 — 행 집계 — 대조표 버튼 노출 '툴바 override 5종(Search/Insert/Edit/Delete/Save)' 의 G5 29요소: NA:18 · PASS:10 · FAIL:1 · FAIL 요소: SCP0104_CAPA_Line_Assign_Model — 실측[T-79cc3699] (대조표 1행)
- M4|ROW:버튼 노출 — 행 집계 — 대조표 버튼 노출 '툴바 override 5종(Search/Insert/Edit/Delete/Save)' 의 M4 23요소: PASS:17 · NA:4 · FAIL:2 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3de1469]: [정적 판정] A (대조표 1행)
- X-LOC|ROW:~~6-1~~ — 실측[T-9f1114a7]: [정적 판정] [사용자 확정 11-17 · 권장안] 품목 팝업 다중 선택 — AS-IS 는 그리드 셀에서 연 품목 팝업에서 여러 개를 골라 OK 하면 고른 수만큼 행 추가(SCP0104_CAPA_Line_Assign.cs:5713~5734). TO-BE 셀  (대조표 1행)
- G5|ROW:~~6-1~~ — 행 집계 — 대조표 ~~6-1~~ '~~P01 Item 팝업 다중선택 → 행 추가(A-6)~~' 의 G5 29요소: NA:18 · PASS:10 · FAIL:1 · FAIL 요소: SCP0104_CAPA_Line_Assign_Model — 실측[T-79cc3699]: [정적 판정] AS (대조표 1행)
- M4|ROW:~~6-1~~ — 행 집계 — 대조표 ~~6-1~~ '~~P01 Item 팝업 다중선택 → 행 추가(A-6)~~' 의 M4 23요소: PASS:17 · NA:4 · FAIL:2 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3de1469]: [정적 판정] AS-IS 는 Item  (대조표 1행)
- G5|ROW:6-11 — 행 집계 — 대조표 6-11 'SOP·팝업 2종 그리드가 **3단 헤더로 렌더**된다(설계 C-8 = 1단)' 의 G5 29요소: NA:18 · PASS:10 · FAIL:1 · FAIL 요소: SCP0104_CAPA_Line_Assign_Model — 실측[T-79cc3699]: [정 (대조표 1행)
- M4|ROW:6-11 — 행 집계 — 대조표 6-11 'SOP·팝업 2종 그리드가 **3단 헤더로 렌더**된다(설계 C-8 = 1단)' 의 M4 23요소: PASS:17 · NA:4 · FAIL:2 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3de1469]: [정적 판정] AS-IS (대조표 1행)
- C2|COL:ELTR_LN_TP_CD — 실측[T-bc2f6848]: [정적 판정] TO-BE codesOf 가 CODE '-' 를 후보에서 뺌. OperationElectrodeType_SCP_ALL 에서 Division 81 A9000, AFFFF, P5500, P9500 의 Line Type 은 '-' 1건뿐임(2026- (대조표 6행)
- E5|COL:ELTR_LN_TP_CD — 실측[T-4ae38c68]: [정적 판정] [사용자 확정 11-17 · 권장안] 후보가 '-' 뿐인 Operation(A9000·AFFFF·P5500·P9500)의 Line Type — TO-BE 는 '-' 를 후보에서 빼 후보 0건이 되어 값 제한(DataMap)이 풀림(CapaLin (대조표 2행)
- G5|POPUP:SCP0104_CAPA_Line_Assign_Model — 실측[T-79cc3699]: [정적 판정] AS-IS 는 메인 조회조건 Site, Plant, Building, Line, Operation, Line Type 선택값을 팝업 조건에 넣어 첫 목록을 거름. TO-BE 는 Division, Version 만 전달함. 화면 전용 모달이라 C (대조표 2행)
- G5|ROW:MODAL:CustomDialog — 행 집계 — 대조표 MODAL:CustomDialog 'P01 Item 팝업(AS-IS `ShowItem` → `SCM0002_CAPAItemPo' 의 G5 29요소: NA:18 · PASS:10 · FAIL:1 · FAIL 요소: SCP0104_CAPA_Line_Assign_Model (대조표 1행)
- M4|ROW:MODAL:CustomDialog — 행 집계 — 대조표 MODAL:CustomDialog 'P01 Item 팝업(AS-IS `ShowItem` → `SCM0002_CAPAItemPo' 의 M4 23요소: PASS:17 · NA:4 · FAIL:2 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3d (대조표 1행)
- M4|ROW:MODAL:ShowDialog — 행 집계 — 대조표 MODAL:ShowDialog 'P04 컬럼 표시설정 + alert/toast 계열 범용 다이얼로그' 의 M4 23요소: PASS:17 · NA:4 · FAIL:2 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3de1469]: [정적 판정] (대조표 1행)
- G5|ROW:COMMON:UC-06 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회' 의 G5 29요소: NA:18 · PASS:10 · FAIL:1 · FAIL 요소: SCP0104_CAPA_Line_Assign_Model — 실측[T-79cc3699]: [정적  (대조표 1행)
- M4|ROW:COMMON:UC-06 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회' 의 M4 23요소: PASS:17 · NA:4 · FAIL:2 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3de1469]: [정적 판정] AS-IS 는 (대조표 1행)
- X-ROW|ENTRY:SCP0104_CAPA_Line.FindButton — 진입점 집계 5검사 — NA:2 · PASS:2 · FAIL:1 (대조표 6행)
- F4|ENTRY:SCP0104_CAPA_Line.FindButton — 진입점 집계 — 대조표 SCP0104_CAPA_Line.FindButton 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품목명 Dummy 코드 (대조표 1행)
- X-ROW|ENTRY:SCP0104_CAPA_Line.FindData — 진입점 집계 5검사 — PASS:3 · NA:1 · FAIL:1 (대조표 3행)
- F4|ENTRY:SCP0104_CAPA_Line.FindData — 진입점 집계 — 대조표 SCP0104_CAPA_Line.FindData 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품목명 Dummy 코드 생 (대조표 1행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.CheckNameOnDummyCodeDB — 진입점 집계 3검사 — PASS:2 · FAIL:1 (대조표 19행)
- F4|SP:P_SCP0104_CHECK_NAME_ON_DUMMY_CODE — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품목명 Dummy 코드 생성 불가 — 오류(사용자 판정 '오류로 판정해주세요') · AS-IS 입력 즉시 DMY_ 코드 생성 + Dummy=Y 저장 · TO-BE 입력 차단(실측 11-17 15:27) (사용자(대화) 20 (대조표 4행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.CheckValidName — 진입점 집계 11검사 — PASS:7 · FAIL:4 (대조표 142행)
- C2|COL:FACTORY_ID — 실측[T-04e8f5c3]: [정적 판정] AS-IS 는 Building 후보를 행 Company 로도 거르고 Plant 가 DMY_ 코드면 Plant 조건을 뺌. TO-BE 는 Division + Plant 만 봄. Plant 가 채워진 행은 같은 집합임(마스터 콤보에서 Plant 1 (대조표 9행)
- C2|COL:FACTORY_NAME — 실측[T-a8dd3fa6]: [정적 판정] AS-IS 는 Building 후보를 행 Company 로도 거르고 Plant 가 DMY_ 코드면 Plant 조건을 뺌. TO-BE 는 Division + Plant 만 봄. Plant 가 채워진 행은 같은 집합임(마스터 콤보에서 Plant 1 (대조표 6행)
- C2|COL:LINE_ID — 실측[T-14b55da2]: [정적 판정] AS-IS 는 Line 후보를 행 Plant + Building 으로 거름. TO-BE 는 Division + Building 만 봄. Plant 를 바꾸면 Building, Line 이 지워지므로(capa-line-assign.constant (대조표 9행)
- C2|COL:LINE_NAME — 실측[T-07f53041]: [정적 판정] AS-IS 는 Line 후보를 행 Plant + Building 으로 거름. TO-BE 는 Division + Building 만 봄. Plant 를 바꾸면 Building, Line 이 지워지므로(capa-line-assign.constant (대조표 6행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.Edit_Row_Assign — 실측[T-25489c40]: [사용자판정] FAIL — 추가 행 품목 선택 때 기본값 재설정 없음 — 오류(사용자 판정 '오류로 판정') · 추가 행 기간 칸·Active 를 먼저 바꾼 뒤 품목 1건 선택 시 AS-IS 1·Y 로 되돌림(cs:5292~5310) · TO-BE 유지 (사 (대조표 23행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.FindButton — 진입점 집계 5검사 — NA:2 · PASS:2 · FAIL:1 (대조표 3행)
- F4|ENTRY:SCP0104_CAPA_Line_Assign.FindButton — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.FindButton 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품목명 D (대조표 5행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.FindDataAssign — 진입점 집계 5검사 — PASS:3 · NA:1 · FAIL:1 (대조표 1행)
- F4|ENTRY:SCP0104_CAPA_Line_Assign.FindDataAssign — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.FindDataAssign 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.FindDataSOP — 진입점 집계 5검사 — PASS:3 · NA:1 · FAIL:1 (대조표 1행)
- F4|ENTRY:SCP0104_CAPA_Line_Assign.FindDataSOP — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.FindDataSOP 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품목명  (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.GetCurrEditType — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.GetCurrEditType — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.GetCurrEditType 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Ce (대조표 3행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.GetDummyCheckedCode — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.GetDummyCheckedCode — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.GetDummyCheckedCode 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.GetIdByName — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.GetIdByName — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.GetIdByName 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cell 모 (대조표 6행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.GetNameById — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.GetNameById — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.GetNameById 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cell 모 (대조표 6행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.RefreshCompanySpread — 실측[T-261e9e8e]: [정적 판정] 필터 조건은 같음(utils/capaLineAssign.gridCombos.ts:108~118). NAME 후보 순서가 다름. AS-IS 는 코드순 정렬 후 DMY_ 를 뒤로 보낸 표를 그대로 NAME 콤보에 씀(SCP0104_CAPA_Line (대조표 7행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.RefreshFactorySpread — 실측[T-0cb8d43f]: [정적 판정] TO-BE 는 Division, Plant 로만 거름(utils/capaLineAssign.gridCombos.ts:130~140). AS-IS 의 COMPANY_ID 조건(ScpCapaBL.cs:489~499)이 없어 Plant 가 빈 행에서 (대조표 8행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.RefreshLineSpread — 실측[T-2ea34689]: [정적 판정] TO-BE LINE_ID 후보는 DMY_ 코드를 뺌(utils/capaLineAssign.gridCombos.ts:51). AS-IS 는 DMY_ 를 목록 끝에 둠(ScpCapaBL.cs:81~136). 마스터의 DMY_ Line 은 SCP_M (대조표 9행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.RefreshPlantSpread — 실측[T-96d7cbbb]: [정적 판정] ELTR 일 때 AS-IS 는 SHOP_GROUP_ID=E 로 거름(ScpCapaBL.cs:445). TO-BE 는 ELTR 마스터를 거르지 않음(hooks/useCapaLineCascade.ts:145). SCP_MST_CAPA_ELTR_LI (대조표 7행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.RefreshSiteSpread — 실측[T-5b37f06a]: [정적 판정] 필터 조건은 같음(utils/capaLineAssign.gridCombos.ts:100~107). NAME 후보 순서가 다름. AS-IS 는 코드순 정렬 후 DMY_ 를 뒤로 보낸 표를 그대로 NAME 콤보에 씀(SCP0104_CAPA_Line (대조표 7행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.RefreshSpreadComboAll — 진입점 집계 13검사 — PASS:8 · FAIL:5 (대조표 27행)
- F4|ENTRY:SCP0104_CAPA_Line_Assign.SaveButton — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.SaveButton 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품목명 D (대조표 1행)
- F4|ENTRY:SCP0104_CAPA_Line_Assign.SaveData — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.SaveData 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품목명 Dum (대조표 1행)
- F4|ENTRY:SCP0104_CAPA_Line_Assign.SaveDataAssign — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.SaveDataAssign 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품 (대조표 1행)
- F4|ENTRY:SCP0104_CAPA_Line_Assign.SaveDataSOP — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.SaveDataSOP 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품목명  (대조표 1행)
- C2|COL:NICK_NAME — 실측[T-26160058]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 NICK_NAME 칸에 목록에 없는 명칭 입력 → 값이 들어가지 않음 · 후보 3,891건 · 후보 밖 입력 불가) · AS-IS ASSEMBLY NICK_NAME 셀은 텍스트 칸이라 목록에 (대조표 3행)
- C2|COL:ITEM_ID — 실측[T-dacd5310]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 NICK_NAME 칸에 목록에 없는 명칭 입력 → 값이 들어가지 않음 · 후보 3,891건 · 후보 밖 입력 불가) · AS-IS ELTR ITEM_ID 셀은 텍스트 칸이라 목록에 없는 명칭 (대조표 2행)
- C6|COL:SITE_ID — 실측[T-9f7a81a0]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 16행)
- C6|COL:SITE_NAME — 실측[T-2157e939]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 2행)
- C6|COL:COMPANY_ID — 실측[T-9407819e]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 4행)
- C6|COL:COMPANY_NAME — 실측[T-5e69f0c0]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 3행)
- C6|COL:PLANT_ID — 실측[T-4a361502]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 13행)
- C6|COL:PLANT_NAME — 실측[T-a86b60fe]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 3행)
- C6|COL:FACTORY_ID — 실측[T-9669ca5f]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 6행)
- C6|COL:FACTORY_NAME — 실측[T-932f5b37]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 3행)
- C6|COL:LINE_ID — 실측[T-fe6c000f]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 6행)
- C6|COL:LINE_NAME — 실측[T-744b42e7]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 3행)
- C6|COL:OPERATION_ID — 실측[T-e3e85b8a]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 8행)
- C6|COL:OPERATION_NAME — 실측[T-55e5ceee]: [정적 판정] 화면 재현(2026-11-16 18:25 · 신규 행 SITE_ID 칸을 F2 로 열고 Esc·Enter 로 값 변경 없이 종료 → COMPANY_ID~LINE_NAME 8칸이 빈 값이 됨) · TO-BE cellEditEnded 핸들러가 값  (대조표 4행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign._defaultDataModel_Changed — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign._defaultDataModel_Changed 의 C2 15요소: PASS:8 · FAIL:7 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2f6848]: [정적 판정] T (대조표 31행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign._defaultDataModel_Changed — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign._defaultDataModel_Changed 의 C6 15요소: FAIL:12 · PASS:3 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화면 재현(2026-11-16 (대조표 31행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign._defaultDataModel_Changed — 진입점 집계 49검사 — FAIL:21 · PASS:19 · NA:9 (대조표 13행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.cboDivision_SelectedIndexChanged — 진입점 집계 3검사 — FAIL:2 · PASS:1 (대조표 3행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign.cboDivision_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboDivision_SelectedIndexChanged 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2f6 (대조표 6행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign.cboDivision_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboDivision_SelectedIndexChanged 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화면 (대조표 6행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.cboVersionSeq_SelectedIndexChanged — 진입점 집계 3검사 — FAIL:2 · PASS:1 (대조표 3행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign.cboVersionSeq_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboVersionSeq_SelectedIndexChanged 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2 (대조표 4행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign.cboVersionSeq_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboVersionSeq_SelectedIndexChanged 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정]  (대조표 4행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.cboVersion_SelectedIndexChanged — 진입점 집계 3검사 — FAIL:2 · PASS:1 (대조표 3행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign.cboVersion_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboVersion_SelectedIndexChanged 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2f68 (대조표 5행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign.cboVersion_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.cboVersion_SelectedIndexChanged 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화면  (대조표 5행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.clbFactory_SelectedIndexChanged — 진입점 집계 3검사 — FAIL:2 · PASS:1 (대조표 3행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign.clbFactory_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbFactory_SelectedIndexChanged 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2f68 (대조표 3행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign.clbFactory_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbFactory_SelectedIndexChanged 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화면  (대조표 3행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.clbLine_SelectedIndexChanged — 진입점 집계 3검사 — FAIL:2 · PASS:1 (대조표 3행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign.clbLine_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbLine_SelectedIndexChanged 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2f6848] (대조표 2행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign.clbLine_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbLine_SelectedIndexChanged 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화면 재현( (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.clbOperation_SelectedIndexChanged — 진입점 집계 3검사 — FAIL:2 · PASS:1 (대조표 3행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign.clbOperation_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbOperation_SelectedIndexChanged 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2f (대조표 1행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign.clbOperation_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbOperation_SelectedIndexChanged 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화 (대조표 1행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.clbPlant_SelectedIndexChanged — 진입점 집계 3검사 — FAIL:2 · PASS:1 (대조표 3행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign.clbPlant_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbPlant_SelectedIndexChanged 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2f6848 (대조표 4행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign.clbPlant_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbPlant_SelectedIndexChanged 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화면 재현 (대조표 4행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.clbSite_SelectedIndexChanged — 진입점 집계 3검사 — FAIL:2 · PASS:1 (대조표 3행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign.clbSite_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbSite_SelectedIndexChanged 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T-bc2f6848] (대조표 5행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign.clbSite_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.clbSite_SelectedIndexChanged 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화면 재현( (대조표 5행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAction — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAction — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAction 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cell (대조표 4행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignAction — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignAction — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignAction 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignCompany — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignCompany — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignCompany 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignDivision — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignDivision — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignDivision 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적  (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignDummyYn — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignDummyYn — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignDummyYn 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignElectrodeType — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignElectrodeType — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignElectrodeType 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignFactory — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignFactory — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignFactory 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignLine — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignLine — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignLine 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정]  (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignOperation — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignOperation — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignOperation 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignPlant — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignPlant — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignPlant 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignSite — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignSite — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignSite 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정]  (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignValidYn — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrAssignValidYn — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrAssignValidYn 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopAction — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopAction — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrSopAction 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] C (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopCompany — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopCompany — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrSopCompany 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정]  (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopDivision — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopDivision — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrSopDivision 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopElectrodeType — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopElectrodeType — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrSopElectrodeType 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopFactory — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopFactory — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrSopFactory 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정]  (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopLine — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopLine — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrSopLine 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cel (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopOperation — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopOperation — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrSopOperation 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopPlant — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopPlant — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrSopPlant 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Ce (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopSite — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopSite — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrSopSite 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cel (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopValidYn — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getCurrSopValidYn — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getCurrSopValidYn 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정]  (대조표 2행)
- B4|COND:clbElectrodeType — 실측[T-b943b4c9]: [정적 판정] Cell 모드 Division 81 기준 AS-IS 후보 10건(Anode ~ AZS Stacking, '-'), TO-BE 9건으로 '-' 가 빠짐(2026-11-16 18:20 사내 DB 조회, Division 81_HD, 81_HG, 81 (대조표 6행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getElectrodeType — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getElectrodeType 의 B4 1요소: FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cell 모드 Division 81  (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getIsPageSOP — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getIsPageSOP — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getIsPageSOP 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cell  (대조표 1행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getOriElectrodeType — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getOriElectrodeType 의 B4 1요소: FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cell 모드 Division  (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getPlanType — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getPlanType — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getPlanType 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cell 모 (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getProgressStatus — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getProgressStatus — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getProgressStatus 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정]  (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.getShopGroup — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:SCP0104_CAPA_Line_Assign.getShopGroup — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.getShopGroup 의 B4 31요소: NA:19 · PASS:11 · FAIL:1 · FAIL 요소: clbElectrodeType / Line Type / — 실측[T-b943b4c9]: [정적 판정] Cell  (대조표 2행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.rgrpDivisionType_SelectedIndexChanged — 진입점 집계 3검사 — FAIL:2 · PASS:1 (대조표 3행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign.rgrpDivisionType_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.rgrpDivisionType_SelectedIndexChanged 의 C2 19요소: PASS:10 · FAIL:7 · NA:2 · FAIL 요소: ELTR_LN_TP_CD / Equipment Type — 실측[T- (대조표 7행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign.rgrpDivisionType_SelectedIndexChanged — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.rgrpDivisionType_SelectedIndexChanged 의 C6 18요소: FAIL:12 · PASS:5 · NA:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판 (대조표 7행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign.spdAssign_CellClick — 진입점 집계 13검사 — PASS:8 · FAIL:5 (대조표 53행)
- M4|ENTRY:SCP0104_CAPA_Line_Assign.spdAssign_CellDoubleClick — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.spdAssign_CellDoubleClick 의 M4 3요소: FAIL:2 · PASS:1 · FAIL 요소: NICK_NAME / Nickname — 실측[T-f3de1469]: [정적 판정] AS-IS 는 Item (대조표 6행)
- C2|ENTRY:SCP0104_CAPA_Line_Assign.spdAssign_ComboSelChange — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.spdAssign_ComboSelChange 의 C2 6요소: PASS:4 · FAIL:2 · FAIL 요소: FACTORY_ID / Building — 실측[T-04e8f5c3]: [정적 판정] AS-IS 는 Buil (대조표 8행)
- C6|ENTRY:SCP0104_CAPA_Line_Assign.spdAssign_ComboSelChange — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign.spdAssign_ComboSelChange 의 C6 6요소: FAIL:5 · PASS:1 · FAIL 요소: SITE_ID / Site — 실측[T-9f7a81a0]: [정적 판정] 화면 재현(2026-11-16 18 (대조표 8행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign_Model.CheckNameOnDummyCodeDB — 진입점 집계 5검사 — PASS:3 · NA:1 · FAIL:1 (대조표 37행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign_Model.FindButton — 진입점 집계 6검사 — NA:3 · PASS:2 · FAIL:1 (대조표 6행)
- F4|ENTRY:SCP0104_CAPA_Line_Assign_Model.FindButton — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign_Model.FindButton 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 (대조표 1행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign_Model.FindData — 진입점 집계 6검사 — PASS:3 · NA:2 · FAIL:1 (대조표 3행)
- F4|ENTRY:SCP0104_CAPA_Line_Assign_Model.FindData — 진입점 집계 — 대조표 SCP0104_CAPA_Line_Assign_Model.FindData 의 F4 2요소: FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0104.P_SCP0104_CHECK_NA — 실측[T-228fc738]: [사용자판정] FAIL — 목록 밖 품 (대조표 1행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign_Model.getElectrodeType — 진입점 집계 4검사 — PASS:2 · FAIL:1 · NA:1 (대조표 3행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign_Model.rgrpDivisionType_SelectedIndexChanged — 진입점 집계 5검사 — PASS:2 · NA:2 · FAIL:1 (대조표 11행)
- X-ROW|ENTRY:SCP0104_CAPA_Line_Assign_Model.spdAssign_CellDoubleClick — 진입점 집계 8검사 — PASS:6 · FAIL:1 · NA:1 (대조표 5행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

