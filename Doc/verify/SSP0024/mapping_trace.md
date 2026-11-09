# 대조표 ↔ 검증 추적표 v2 — SSP0024 (AS-IS SSP0024) · 2026-11-09T12:11:25

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 168행 (nscm-fe\features\shipping\src\pages\shipment-master-electrode\__asis-mapping__.md) · AS-IS 액션 581행(진입점 + 전 문장) = **749행** → 검사 인스턴스 **747개**
- 행 판정: FAIL 338 · 검증완료 239 · 미검증 167 · 해당없음 5
- 인스턴스 결과: PASS 319 · NA 214 · ERROR 102 · NOPATH 43 · FAIL 38 · REVIEW 30 · NOT_RUN 1

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 8 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 7 | 0 | 0 | 0 | 0 | 5 | 0 | 2 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 7 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H5 | 정적 디자인 | 있음 | 8 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 5 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 24 | 0 | 1 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 2 | 0 | 1 | 0 | 2 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 23 | 3 | 1 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 3 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 123 | 0 | 0 | 0 | 0 | 33 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 5 | 16 | 0 | 2 | 7 | 33 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 2 | 0 | 0 | 0 | 0 | 1 | 0 | 5 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 2 | 0 | 0 | 0 | 0 | 1 | 0 | 5 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 1 | 0 | 0 | 0 | 0 | 6 | 0 | 5 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 1 | 0 | 0 | 0 | 0 | 8 | 0 | 7 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B6 | 콤보 후보 | 있음 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | ALL 옵션·다중선택 사양 |
| C1 | Cascade | 있음 | 3 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 10 | 0 | 0 | 0 | 0 | 14 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 8 | 18 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 36 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 30 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 29 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 5 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 14 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E3 | 편집·검증 | 있음 | 1 | 0 | 0 | 1 | 7 | 1 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 2 | 0 | 0 | 0 | 0 | 27 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 2 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 3 | 0 | 0 | 0 | 15 | 0 | 0 | 8 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 18 | 0 | 8 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 2 | 15 | 0 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 6 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 2 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 36 | 0 | 0 | 0 | 27 | 6 | 0 | 2 | 0 | 0 |
| 동적 생성·조회 | 133 | 19 | 0 | 27 | 30 | 83 | 1 | 1 | 0 | 0 |
| 콤보 후보 | 8 | 0 | 0 | 0 | 0 | 16 | 0 | 22 | 0 | 0 |
| Cascade | 59 | 18 | 0 | 0 | 0 | 27 | 0 | 0 | 0 | 0 |
| 편집·검증 | 68 | 0 | 0 | 1 | 10 | 55 | 0 | 2 | 0 | 0 |
| CRUD | 0 | 1 | 0 | 0 | 4 | 1 | 0 | 0 | 0 | 0 |
| 팝업 | 3 | 0 | 0 | 2 | 30 | 22 | 0 | 16 | 0 | 0 |
| 공통 기능 | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 8 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 |

## FAIL 인스턴스

- C3|ROW:D00-2-005 — 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51aa29 (대조표 1행)
- C3|ROW:D00-2-007 — 행 집계 — 대조표 D00-2-007 '§2 spdMain / ClipboardPasted' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51aa2 (대조표 1행)
- C3|COL:BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51aa299a]: BUILDING 연쇄 원천 컬럼 해석 불가 — AS-IS SpdMain_ComboSelChange:603 siMain.GetColumnIndex(DefColumns.BUILDING)  (대조표 13행)
- C3|COL:MATERIAL_ID — 실측[T-16208542]: 신규행 연쇄 DIVISION_ID → MATERIAL_ID: DIVISION_ID='81' → MATERIAL_ID='' | DIVISION_ID='40' → MATERIAL_ID='' | DIVISION_ID='82' → MATERIAL_ID='' — 원천 (대조표 7행)
- A6|SP:P_SSP0024_GET_SHIP_MASTER — 원장 V-a0e87555 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['DIVISION_ID', 'SCM_SITE_ID', ' / 실측[T-3376bbb3]: PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER: 결과 190행이 AS-IS 키 [DIVIS (대조표 37행)
- F2|SCREEN — 원장 V-5e35aff2 RULE_SCREEN / 원장 V-95b573aa RULE_SCREEN / 원장 V-8e986a5b RULE_SCREEN / 원장 V-fdd9071a GENERAL / 원장 V-55fbd3b1 GENERAL / 원장 V-528b373c GENERAL / 원장 V (대조표 95행)
- C3|ROW:D00-4d-011 — 행 집계 — 대조표 D00-4d-011 '§4d SpdMain_ComboSelChange / -' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51 (대조표 1행)
- C3|ROW:D00-4d-014 — 행 집계 — 대조표 D00-4d-014 '§4d SpdMain_ClipboardPasted / -' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-5 (대조표 1행)
- C3|ROW:D00-4d-015 — 행 집계 — 대조표 D00-4d-015 '§4d SpdMain_ClipboardPasted / -' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-5 (대조표 1행)
- C3|ROW:SpdMain_ComboSelChange (cs:596) — 행 집계 — 대조표 SpdMain_ComboSelChange (cs:596) '파생' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51aa299a] (대조표 1행)
- C3|ROW:SpdMain_ClipboardPasted (cs:659) — 행 집계 — 대조표 SpdMain_ClipboardPasted (cs:659) '붙여넣기' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51aa29 (대조표 1행)
- C3|ROW:11 — 행 집계 — 대조표 11 'SpdMain_ComboSelChange' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51aa299a]: BUILDIN (대조표 1행)
- C3|ROW:14 — 행 집계 — 대조표 14 'SpdMain_ClipboardPasted' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51aa299a]: BUILDI (대조표 1행)
- C3|ROW:15 — 행 집계 — 대조표 15 'SpdMain_ClipboardPasted' 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 실측[T-51aa299a]: BUILDI (대조표 1행)
- X-ROW|ENTRY:SSP0024_ItembyDivisionPopup.DefineProperty — 진입점 집계 2검사 — NA:1 · FAIL:1 (대조표 4행)
- A10|SCREEN — 원장 V-6f37342c RULE_SCREEN / 원장 V-44fd59ae GENERAL / 실측[T-9031acab]: 화면 진입 직후(조회 전) 그리드 0행 · 진입 시 호출 없음 — 기대 자동 조회 (AS-IS 로드 중 조회 호출: Form_Load:166 FindData() [] (대조표 92행)
- X-ROW|ENTRY:SSP0024_ItembyDivisionPopup.FindButton — 진입점 집계 4검사 — NA:2 · REVIEW:1 · FAIL:1 (대조표 2행)
- A6|SP:P_SSP0024_GET_ITEM_BY_DIVISION_POPUP — 원장 V-d7b352eb SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['DIVISION_ID', 'SCM_SITE_ID', ' / 실측[T-11ad13e2]: PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP: 화면 진입·조회 경로에 (대조표 30행)
- X-ROW|ENTRY:SSP0024_ItembyDivisionPopup.FindData — 진입점 집계 10검사 — NA:4 · PASS:2 · REVIEW:1 · FAIL:1 · ERROR:1 · NOT_RUN:1 (대조표 29행)
- X-ROW|ENTRY:SSP0024_ItembyDivisionPopup.Form_Load — 진입점 집계 2검사 — FAIL:1 · NA:1 (대조표 12행)
- X-ROW|ENTRY:SSP0024_ItembyDivisionPopup.InitControls — 진입점 집계 10검사 — NA:6 · PASS:3 · FAIL:1 (대조표 16행)
- X-ROW|ENTRY:SSP0024_ItembyDivisionPopup.InitSpread — 진입점 집계 6검사 — PASS:4 · FAIL:1 · NA:1 (대조표 15행)
- C3|ENTRY:SSP0024_ShipmentMasterElectrode.ClbDivision_SelectedIndexChanged — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.ClbDivision_SelectedIndexChanged 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V- (대조표 1행)
- X-ROW|ENTRY:SSP0024_ShipmentMasterElectrode.DefineProperty — 진입점 집계 1검사 — FAIL:1 (대조표 2행)
- X-ROW|ENTRY:SSP0024_ShipmentMasterElectrode.FindButton — 진입점 집계 3검사 — REVIEW:1 · FAIL:1 · PASS:1 (대조표 1행)
- X-ROW|ENTRY:SSP0024_ShipmentMasterElectrode.FindData — 진입점 집계 12검사 — NA:5 · PASS:4 · REVIEW:1 · FAIL:1 · ERROR:1 (대조표 12행)
- X-ROW|ENTRY:SSP0024_ShipmentMasterElectrode.Form_Load — 진입점 집계 1검사 — FAIL:1 (대조표 2행)
- X-ROW|ENTRY:SSP0024_ShipmentMasterElectrode.InitControls — 진입점 집계 8검사 — PASS:4 · NOPATH:3 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:SSP0024_ShipmentMasterElectrode.InitSpread — 진입점 집계 1검사 — FAIL:1 (대조표 14행)
- X-ROW|ENTRY:SSP0024_ShipmentMasterElectrode.SaveData — 진입점 집계 15검사 — PASS:7 · NA:4 · ERROR:3 · FAIL:1 (대조표 3행)
- C3|ENTRY:SSP0024_ShipmentMasterElectrode.SetChangedControl — 진입점 집계 — 대조표 SSP0024_ShipmentMasterElectrode.SetChangedControl 의 C3 20요소: NA:8 · PASS:7 · FAIL:5 · FAIL 요소: BUILDING — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / (대조표 2행)
- X-ROW|ENTRY:SSP0024_ShipmentMasterElectrode.SpdMain_CellClick — 진입점 집계 24검사 — NA:15 · PASS:4 · ERROR:4 · FAIL:1 (대조표 53행)
- X-ROW|ENTRY:SSP0024_ShipmentMasterElectrode.SpdMain_ClipboardPasted — 진입점 집계 41검사 — PASS:18 · NA:15 · NOPATH:6 · ERROR:1 · FAIL:1 (대조표 11행)
- C3|COL:POST_OPER_LT — 원장 V-a4d95037 ASIS / 실측[T-3586562e]: POST_OPER_LT: 원천 POST_OPER 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) (대조표 3행)
- C3|COL:POST_OPER — 원장 V-a4d95037 ASIS / 실측[T-1898295d]: POST_OPER: AS-IS 문장이 값 대입이 아님(잠금·셀 타입·스타일) — 연쇄 채움 대상 아님(D1/D3/H2 에서 판정) (대조표 10행)
- C3|ENTRY:SSP0024_ShipmentMasterElectrode.SpdMain_ComboSelChange — 원장 V-87a7dad2 ASIS / 원장 V-a4d95037 ASIS / 원장 V-b69f3426 ASIS (대조표 4행)
- X-ROW|ENTRY:SSP0024_ShipmentMasterElectrode.SpdMain_ComboSelChange — 진입점 집계 52검사 — PASS:29 · NA:17 · FAIL:6 (대조표 10행)
- C3|LEDGER:V-a4d95037 — 원장 V-a4d95037 (대조표 1행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- G1|COND:clbDivisionId — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
