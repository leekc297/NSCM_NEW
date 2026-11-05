# 대조표 ↔ 검증 추적표 v2 — SCP0084 (AS-IS SCP0084) · 2026-11-05T07:51:32

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 22행 (nscm-fe\features\supply\src\pages\long-term-stock\__asis-mapping__.md) · AS-IS 액션 350행(진입점 + 전 문장) = **372행** → 검사 인스턴스 **212개**
- 행 판정: FAIL 298 · 검증완료 53 · 미검증 21
- 인스턴스 결과: PASS 74 · NA 72 · FAIL 36 · ERROR 16 · REVIEW 12 · NOPATH 2

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 13 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 2 | 11 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H5 | 정적 디자인 | 있음 | 13 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 10 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 2 | 0 | 0 | 0 | 7 | 1 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 3 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 22 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 3 | 6 | 0 | 1 | 6 | 0 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B3 | 콤보 후보 | 있음 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 11 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 8 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E3 | 편집·검증 | 있음 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 22 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F1 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F6 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| G3 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| J1 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 2 | 0 | 0 | 0 | 0 | 2 | 0 | 1 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 1 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 37 | 13 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 동적 생성·조회 | 10 | 7 | 0 | 12 | 13 | 27 | 0 | 1 | 0 | 0 |
| 콤보 후보 | 3 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 |
| Cascade | 3 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 |
| 편집·검증 | 16 | 8 | 0 | 0 | 0 | 30 | 0 | 0 | 0 | 0 |
| CRUD | 0 | 3 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 |
| 공통 기능 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 3 | 4 | 0 | 0 | 0 | 2 | 0 | 1 | 0 | 0 |

## FAIL 인스턴스

- SC1|SCREEN — E2E smoke cond order / 실측[T-cd8baac8]: 조회조건 순서 = AS-IS 화면 배치 순서(디자이너 좌표: 위→아래 줄, 줄 안 왼→오른) — 기준표 tobe_order 번호와는 다르나 그 번호는 화면 좌표 순서가 아님(2026-10-30 SCP0100 판정 오류 (대조표 7행)
- F4|SP:SCP0084_GET_MONTH_RANGE — 실측[T-e10eea6a]: SCP0084_GET_MONTH_RANGE: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인) — 화면 진입·조회 중 호출 없음 (대조표 3행)
- J2|SCREEN — 원장 V-6f68ca62 RULE_SCREEN / 원장 V-84371ffd DEFECT / 원장 V-7bb8d701 GENERAL / 원장 V-26902320 GENERAL / 원장 V-ef267bea GENERAL / 원장 V-58000142 GENERAL / 원장 V-30ff3f8b (대조표 22행)
- I1|SCREEN — 원장 V-87b9620a RULE_SCREEN / 원장 V-eb8bf778 RULE_SCREEN / 원장 V-afbf57f8 RULE_SCREEN / 원장 V-90652cbe DEFECT / 원장 V-8592a017 DEFECT / 원장 V-b221e353 DEFECT / 원장 V-85 (대조표 10행)
- H2|ROW:조회 후 전 컬럼 Lock (R2, W4) — 행 집계 — 대조표 조회 후 전 컬럼 Lock (R2, W4) '327' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 (대조표 1행)
- D3|ROW:조회 후 전 컬럼 Lock (R2, W4) — 행 집계 — 대조표 조회 후 전 컬럼 Lock (R2, W4) '327' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0]: r0  → MEMO 편집=true (AS-IS 잠금 EditButton:242) NG · r1  → MEMO 편집= (대조표 1행)
- D3|COL:MEMO — 실측[T-1a8ec3b0]: r0  → MEMO 편집=true (AS-IS 잠금 EditButton:242) NG · r1  → MEMO 편집=true (AS-IS 잠금 EditButton:242) NG · r0  → MEMO 편집=true (AS-IS 해제 EditButton:249) (대조표 4행)
- D3|ROW:**EditButton 노출** — 행 집계 — 대조표 **EditButton 노출** '227' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0]: r0  → MEMO 편집=true (AS-IS 잠금 EditButton:242) NG · r1  → MEMO 편집= (대조표 1행)
- F1|SCREEN — 원장 V-c2b915da RULE_SCREEN / 원장 V-c4427e25 RULE_SCREEN / 원장 V-e34556f7 RULE_SCREEN / 원장 V-2828d9b5 RULE_SCREEN / 원장 V-e3eba8ba GENERAL / 원장 V-657df251 GENERAL /  (대조표 86행)
- F2|SCREEN — 원장 V-854a8a97 RULE_SCREEN / 원장 V-b8408c5e RULE_SCREEN / 원장 V-fca772ec GENERAL / 원장 V-a2d5679c GENERAL / 원장 V-b36b747c GENERAL / 원장 V-a20567a6 GENERAL / 원장 V-74a (대조표 86행)
- D3|ROW:Edit 가드 fps==null (R4) — 행 집계 — 대조표 Edit 가드 fps==null (R4) '229' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0]: r0  → MEMO 편집=true (AS-IS 잠금 EditButton:242) NG · r1  → MEMO 편집= (대조표 1행)
- D3|ROW:Edit 가드 RowCount==0 (R5) — 행 집계 — 대조표 Edit 가드 RowCount==0 (R5) '231' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0]: r0  → MEMO 편집=true (AS-IS 잠금 EditButton:242) NG · r1  → MEMO 편집= (대조표 1행)
- H2|ROW:Edit 가드 Action(String) 컬럼 hidden (R6) — 행 집계 — 대조표 Edit 가드 Action(String) 컬럼 hidden (R6) '244' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 (대조표 1행)
- D3|ROW:Edit 가드 Action(String) 컬럼 hidden (R6) — 행 집계 — 대조표 Edit 가드 Action(String) 컬럼 hidden (R6) '244' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0]: r0  → MEMO 편집=true (AS-IS 잠금 EditButton:242) NG · r1   (대조표 1행)
- D3|ROW:cellclipboardPast=false (R7) — 행 집계 — 대조표 cellclipboardPast=false (R7) '237~240' 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0]: r0  → MEMO 편집=true (AS-IS 잠금 EditButton:242) NG · r1  → MEM (대조표 1행)
- H2|ROW:SetSheetHeaderColumn + ColumnHeaderHeight(0,50) 다단 헤더 (R1/W2 — 행 집계 — 대조표 SetSheetHeaderColumn + ColumnHeaderHeight(0,50) 다단 헤더 (R1/W2 '205~207' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데  (대조표 1행)
- H2|ROW:siMain.Query(ds) 컬럼명 바인딩 (W3) — 행 집계 — 대조표 siMain.Query(ds) 컬럼명 바인딩 (W3) '325' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 (대조표 1행)
- H2|ROW:FIXED_FLAG=Y (ITEM_UOM) 틀고정 — 행 집계 — 대조표 FIXED_FLAG=Y (ITEM_UOM) 틀고정 '메타' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 (대조표 1행)
- H2|ROW:통화 파생(SP CASE) — 행 집계 — 대조표 통화 파생(SP CASE) 'SP' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 (대조표 1행)
- H2|COL:MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 (대조표 1행)
- F6|SCREEN — 원장 V-8294a827 RULE_SCREEN / 원장 V-b6a3890b RULE_SCREEN / 원장 V-39b8853b RULE_SCREEN / 원장 V-73a21b12 RULE_SCREEN / 원장 V-2fd45166 RULE_SCREEN / 원장 V-84337a0b GENERA (대조표 78행)
- F4|ROW:SaveData_Memo (I/M/D 행, 6키+MEMO) — 행 집계 — 대조표 SaveData_Memo (I/M/D 행, 6키+MEMO) '405~420' 의 F4 3요소: FAIL:2 · PASS:1 · FAIL 요소: SCP0084_GET_MONTH_RANGE — 실측[T-e10eea6a]: SCP0084_GET_MONTH_RANGE: (P (대조표 1행)
- H2|ROW:ExcelButton + MSG00100 confirm (R9) — 행 집계 — 대조표 ExcelButton + MSG00100 confirm (R9) '258~274/263~270' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 (대조표 1행)
- H2|ROW:ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1~12 등) — 행 집계 — 대조표 ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1~12 등) '미배선' 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 (대조표 1행)
- H2|ENTRY:SCP0084_LongTermStock.CreateSpread — 진입점 집계 — 대조표 SCP0084_LongTermStock.CreateSpread 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 (대조표 4행)
- X-REOPEN|SCREEN — 실측[T-5ebb12ee]: 탭 닫기 → 재오픈: 치명 콘솔 0 · 5xx 1 · 재오픈 직후 행 0(최초 진입 0) (대조표 8행)
- D3|ENTRY:SCP0084_LongTermStock.EditButton — 진입점 집계 — 대조표 SCP0084_LongTermStock.EditButton 의 D3 1요소: FAIL:1 · FAIL 요소: MEMO — 실측[T-1a8ec3b0]: r0  → MEMO 편집=true (AS-IS 잠금 EditButton:242) NG · r1  → MEMO 편집 (대조표 12행)
- X-ROW|ENTRY:SCP0084_LongTermStock.ExcelButton — 진입점 집계 3검사 — NA:2 · FAIL:1 (대조표 7행)
- X-ROW|ENTRY:SCP0084_LongTermStock.ExportExcelData — 진입점 집계 5검사 — NA:4 · FAIL:1 (대조표 164행)
- X-ROW|ENTRY:SCP0084_LongTermStock.Find_Data — 진입점 집계 8검사 — PASS:3 · NA:2 · FAIL:2 · REVIEW:1 (대조표 51행)
- X-ROW|ENTRY:SCP0084_LongTermStock.GetMonthRange — 진입점 집계 5검사 — NOPATH:3 · FAIL:2 (대조표 2행)
- X-ROW|ENTRY:SCP0084_LongTermStock.SCM_SYS_LOG_BATCH — 진입점 집계 3검사 — NOT_RUN:1 · NOPATH:1 · FAIL:1 (대조표 12행)
- F4|ENTRY:SCP0084_LongTermStock.SCM_SYS_LOG_BATCH — 진입점 집계 — 대조표 SCP0084_LongTermStock.SCM_SYS_LOG_BATCH 의 F4 3요소: FAIL:2 · PASS:1 · FAIL 요소: SCP0084_GET_MONTH_RANGE — 실측[T-e10eea6a]: SCP0084_GET_MONTH_RANGE: (PR (대조표 2행)
- F4|SP:P_SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET — 실측[T-3408d1cb]: PKG_SCP0084.P_SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET: 셀을 수정하고 Save 를 눌렀는데 main/SAVE 호출 0건 — Save 버튼이 저장 호출을 내지 않음 · 알림 'SAVE: 수정한 내용이 없습니 (대조표 77행)
- X-ROW|ENTRY:SCP0084_LongTermStock.SaveData_Memo — 진입점 집계 15검사 — FAIL:6 · NA:6 · PASS:3 (대조표 6행)
- H2|ENTRY:SCP0084_LongTermStock.SetSpreadInit — 진입점 집계 — 대조표 SCP0084_LongTermStock.SetSpreadInit 의 H2 3요소: PASS:2 · FAIL:1 · FAIL 요소: MEMO — 실측[T-1cef9004]: MEMO: 기존행 편집 가능인데 노랑 아님 (대조표 3행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

