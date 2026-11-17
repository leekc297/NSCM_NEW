# 작업 원장 — SSP0200 · 2026-11-15 08:53

> 검사 인스턴스 1357건 중 PASS·NA 478건 외 **879건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 13 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 3 | 구현 위치 실존 |
| W3 | 동작 수정 | 167 | 재판정 PASS |
| W5 | 검사기 연결 | 44 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 2 | 실행 → PASS |
| W7 | 기대값 확정 | 117 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 22 | 선행 W1 → PASS |
| W9 | 도구 오류 | 511 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 511 · 사람 판정 / AS-IS 원문 확인 → 재판정 116 · 화면 FE 105 · 하네스 44 · 사람판정 33 · DB 메타 25 · 선행 W1 완료 후 E2E 17 · FE 15 · 선행 W1 완료 후 검증 5 · 대조표 4 · DB 2 · E2E 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 7건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| C6 | CASCADE |  |  |  |  |  |  |  |  | 81 | 무변경 편집 종료 시 연쇄 미발동 |
| X-LOC | GEN |  | 3 |  |  |  |  | 71 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  |  |  |  | 69 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 62 | 연쇄 자동 채움 |
| D3 | EDIT |  |  |  |  |  |  |  |  | 53 | 행 값 기반 조건부 잠금 |
| A5 | DESIGN |  |  | 33 |  |  |  | 2 | 5 | 12 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  | 28 |  |  |  |  | 5 | 19 | 배경·글자색 규칙 |
| X-ROW | GEN |  |  | 25 |  |  |  | 1 | 1 | 24 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 44 | 그리드 셀 cascade 후보 |
| G1 | GEN |  |  | 31 |  |  |  |  | 1 | 3 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 35 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| H5 | DESIGN |  |  |  |  |  |  | 1 | 5 | 28 | 라벨 명칭 |
| H6 | POPUP |  |  |  |  | 8 |  |  |  | 24 | 팝업 표준·열림 |
| G4 | DESIGN |  |  | 18 |  | 6 | 2 |  | 1 |  | 조회조건 표시·라벨·활성 |
| D1 | EDIT |  |  | 19 |  |  |  |  |  | 4 | 컬럼 편집 가능 여부(신규행·기존행) |
| B4 | COMBO |  |  |  |  | 5 |  |  | 1 | 12 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G5 | POPUP |  |  |  |  | 8 |  |  |  | 9 | 팝업 조건 연동(인자) |
| F4 | DB |  |  |  |  |  |  | 4 |  | 13 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| M4 | POPUP |  |  |  |  |  |  | 1 |  | 13 | 팝업 선택값 반영 |
| X-NOTIMPL | GEN | 13 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| A6 | GEN |  |  | 6 |  |  |  |  |  | 5 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| D4 | EDIT |  |  |  |  |  |  |  | 1 | 9 | 신규행 기본값·자동세팅·Insert 전제 |
| E3 | EDIT |  |  |  |  |  |  |  |  | 10 | 필수 입력 검증 |
| M3 | POPUP |  |  | 1 |  |  |  |  |  | 8 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| D5 | EDIT |  |  | 3 |  |  |  |  |  | 2 | 셀 에디터 유형 |
| B1 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 중복 없음 |
| DB-SYN | DB |  |  |  |  | 4 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| B3 | COMBO |  |  |  |  | 2 |  |  | 1 |  | 콤보 후보 정렬 = AS-IS |
| K-SA | COMMON |  |  | 1 |  |  |  |  |  |  | 조회영역 토글 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| I1 | DESIGN |  |  | 1 |  |  |  |  |  |  | LBL/MSG 언어별 등록 |
| E5 | EDIT |  |  |  |  | 1 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| X-REASON | DESIGN |  |  |  |  |  |  | 1 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| H3 | DESIGN |  |  |  |  |  |  |  | 1 |  | 셀 병합 = AS-IS |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |

## W1 기능 구현 (13)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0001 | X-NOTIMPL | **C4** | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — **C4** `JVFlag = dtMyDivision[ATTRIBUTE1] == '0'` **미구현(false 고정)** — 원천 `SSP0200_GET_SHIPMENT_DIVISION` 미이관. 대체 콤보 |  | 1 (**C4**) |
| WK-SSP0200-0002 | X-NOTIMPL | **L-065·L-070·L-071** | DB(🛠️/🧯 적용 가능) | 대조표 미구현 행 구현 — **L-065·L-070·L-071** `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` · `SCM_SSP_DELETE_..._BY_CONFIRM` · `PR_SSP_XIF_..._IFSE |  | 1 (**L-065·L-070·L-071**) |
| WK-SSP0200-0003 | X-NOTIMPL | **R-30** | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — **R-30** `CHK` 헤더 전체선택 8건 **미구현** — shtMain 에 `CHK` 컬럼이 없고(메타 실측) `spdSub` 이벤트 배선도 0건이라 **AS-IS 동작 여부가 불명**(설계 §6 # |  | 1 (**R-30**) |
| WK-SSP0200-0004 | X-NOTIMPL | L-066 ~ L-069 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — L-066 ~ L-069 `DELETE_..._DRAFTING` / `GET_SHIPMENT_STATUS` / `GET_ERP_SO_NO_CNT` 배선 메타(`05_register.sql` API 6행)만  |  | 1 (L-066 ~ L-069) |
| WK-SSP0200-0005 | X-NOTIMPL | L-149·L-150 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — L-149·L-150 `CHANGE_REQ_DAY`(`D`/`-56`) → `dDay` → `dBaseDate = 오늘 + dDay` **미구현** — 출하일 하한 검증(`MSG00194`)의 기준일. in |  | 1 (L-149·L-150) |
| WK-SSP0200-0006 | X-NOTIMPL | L-151 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — L-151 `SHIPMENT_PERIOD_DAY`(`1D+`=56 / `2D-`=30) → 출하일 상·하한 없음 미구현 — inner-table 환산식(설계 R-3) 미확정 + 콤보 `SHIPMENT_PER |  | 1 (L-151) |
| WK-SSP0200-0007 | X-NOTIMPL | R-31① | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — R-31① `RollBack_Flag` 포커스 복귀 미구현 — 셀 롤백 시 Wijmo 기본 동작에 맡겼다 미구현 |  | 1 (R-31①) |
| WK-SSP0200-0008 | X-NOTIMPL | R-60 C12·C13 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — R-60 C12·C13 `GetItemFromBOD` 전극 판정 미구현(SP 미이관) 미구현(SP) |  | 1 (R-60 C12·C13) |
| WK-SSP0200-0009 | X-NOTIMPL | R-60 C7~C9 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — R-60 C7~C9 원본 스냅샷 대조 미구현 — 확정 체인(SP 미이관)과 함께 보류 미구현 |  | 1 (R-60 C7~C9) |
| WK-SSP0200-0010 | X-NOTIMPL | R-70 D17 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — R-70 D17 `CharacterCasing.Upper`(ITEM_ID/PROJECT_CODE 대문자 강제) **미구현** — 메타 `UPPERCASE_APPLY_FLAG` 가 124행 전건 `'-'` 라 |  | 1 (R-70 D17) |
| WK-SSP0200-0011 | X-NOTIMPL | R-70 D18 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — R-70 D18 `SuspendLayout`/`ResumeLayout` Wijmo `deferUpdate` 미적용 — 현재 대량 갱신 경로(다건 삽입)가 루프 1건 단위라 체감 영향 없음 미구현(성능) |  | 1 (R-70 D18) |
| WK-SSP0200-0012 | X-NOTIMPL | R-70 D3·D6 | DB(🛠️/🧯 적용 가능) | 대조표 미구현 행 구현 — R-70 D3·D6 수량 라벨 동적 교체 **미구현** — `Shipment Plan Qty`/`Shipment Confirm Qty` 둘 다 TO-BE `SCM_ADM_MSG_M` **0행**(신규 등록  |  | 1 (R-70 D3·D6) |
| WK-SSP0200-0013 | X-NOTIMPL | R-70 D7·D8 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — R-70 D7·D8 shtSub CHK 헤더 체크박스 + 장식 Border 미구현(R-30) / Border 는 장식이라 미이식 미구현 |  | 1 (R-70 D7·D8) |

## W2 구현 위치 확인 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0014 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: MainGrid.tsx 없음 |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0015 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: hooks/useShipmentChangeRequestPlanToolbar.ts:57-57 > 54줄 |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0016 | X-LOC | R-01·R-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: MainGrid.tsx 없음, SubGrid.tsx 없음 |  | 1 (R-01·R-02) |

## W3 동작 수정 (167)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0017 | K-SA | SSP0200 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | K-SA FAIL 수정 — SSP0200 화면: E2E smoke common Search Area 조회영역 토글 |  | 3 (L-002·L-003·L-005 L-057 COMMON:UC-02) |
| WK-SSP0200-0018 | A5 | **L-050** | 사람판정(사람판정 대기) | A5 FAIL 수정 — **L-050**: 행 집계 — 대조표 **L-050** '`PlanType1`(Change Type 라벨/콤보) `Visibility=Never`(' 의 A5 38요소: PASS:19 · ERROR:11 ·  |  | 1 (**L-050**) |
| WK-SSP0200-0019 | A5 | CHANGE_REQ_NO / Change Request No | DB 메타(적용 예정) | A5 FAIL 수정 — CHANGE_REQ_NO / Change Request No: E2E smoke columns / 실측[T-2991ac67]: CHANGE_REQ_NO: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0020 | A5 | COMMON:UC-02 | 사람판정(사람판정 대기) | A5 FAIL 수정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A5 38요소: PASS:19 · ERROR |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0021 | A5 | COMMON:UC-07 | 사람판정(사람판정 대기) | A5 FAIL 수정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 38요소: PASS:19 · ERROR |  | 1 (COMMON:UC-07) |
| WK-SSP0200-0022 | A5 | EditButton cs:783 | 사람판정(사람판정 대기) | A5 FAIL 수정 — EditButton cs:783: 행 집계 — 대조표 EditButton cs:783 '`siSub.RowCount==0` 일 때만 편집모드 진입 = 작성 중 요청이 있으면 상단' 의 A5 38요소: PASS: |  | 1 (EditButton cs:783) |
| WK-SSP0200-0023 | A5 | L-014·L-015·**L-126** | 사람판정(사람판정 대기) | A5 FAIL 수정 — L-014·L-015·**L-126**: 행 집계 — 대조표 L-014·L-015·**L-126** '`layoutControlItem5`/`txtRequestNo` — `Visibility=' 의 A5 38요 |  | 1 (L-014·L-015·**L-126**) |
| WK-SSP0200-0024 | A5 | L-062·L-063 | 사람판정(사람판정 대기) | A5 FAIL 수정 — L-062·L-063: 행 집계 — 대조표 L-062·L-063 '`VisibleTab(true)` 2건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL  |  | 1 (L-062·L-063) |
| WK-SSP0200-0025 | A5 | L-081 | 사람판정(사람판정 대기) | A5 FAIL 수정 — L-081: 행 집계 — 대조표 L-081 '`SheetName == shtMain` 일 때만 저장' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: |  | 1 (L-081) |
| WK-SSP0200-0026 | A5 | NEW_ETA / ETA | DB 메타(적용 예정) | A5 FAIL 수정 — NEW_ETA / ETA: E2E smoke columns / 실측[T-73f3aab1]: NEW_ETA: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 VIS |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0027 | A5 | NEW_ETD / ETD | DB 메타(적용 예정) | A5 FAIL 수정 — NEW_ETD / ETD: E2E smoke columns / 실측[T-d1d6151b]: NEW_ETD: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 VIS |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0028 | A5 | NEW_LT_DAY / L/T(Day | DB 메타(적용 예정) | A5 FAIL 수정 — NEW_LT_DAY / L/T(Day: E2E smoke columns / 실측[T-ef617a07]: NEW_LT_DAY: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO |  | 5 (R-22 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0029 | A5 | NEW_SHIPMENT_DATE / Shipment Date | DB 메타(적용 예정) | A5 FAIL 수정 — NEW_SHIPMENT_DATE / Shipment Date: E2E smoke columns / 실측[T-3898decd]: NEW_SHIPMENT_DATE: AS-IS(Div 40) '숨김' ↔ TO-BE  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0030 | A5 | NEW_TRANSPORT_MODE / Trans Mode | DB 메타(적용 예정) | A5 FAIL 수정 — NEW_TRANSPORT_MODE / Trans Mode: E2E smoke columns / 실측[T-dbfd9888]: NEW_TRANSPORT_MODE: AS-IS(Div 40) '숨김' ↔ TO-BE 표 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0031 | A5 | R-01·R-02 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-01·R-02: 행 집계 — 대조표 R-01·R-02 '`FpSpread` 2 + 이벤트 10' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소:  |  | 1 (R-01·R-02) |
| WK-SSP0200-0032 | A5 | R-10 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-10: 행 집계 — 대조표 R-10 '시트 초기화 폭/라벨/헤더 span/소수 32건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_ |  | 1 (R-10) |
| WK-SSP0200-0033 | A5 | R-12 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-12: 행 집계 — 대조표 R-12 'div 40/EE 컬럼 표시 전환(시트 축) 12건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDI |  | 1 (R-12) |
| WK-SSP0200-0034 | A5 | R-13 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-13: 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_M |  | 1 (R-13) |
| WK-SSP0200-0035 | A5 | R-18 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-18: 행 집계 — 대조표 R-18 'BOD 0행 처리' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke  |  | 1 (R-18) |
| WK-SSP0200-0036 | A5 | R-20·R-21 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-20·R-21: 행 집계 — 대조표 R-20·R-21 "동일 SO 전파 + 행상태 `'M'`" 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: E |  | 1 (R-20·R-21) |
| WK-SSP0200-0037 | A5 | R-24 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-24: 행 집계 — 대조표 R-24 'CHANGE_REASON 연동 11건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — |  | 1 (R-24) |
| WK-SSP0200-0038 | A5 | R-27 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-27: 행 집계 — 대조표 R-27 '소수자릿수 동적 전환 8건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E s |  | 1 (R-27) |
| WK-SSP0200-0039 | A5 | R-29 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-29: 행 집계 — 대조표 R-29 '검증 전 색/상태 초기화 16건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2 |  | 1 (R-29) |
| WK-SSP0200-0040 | A5 | R-31② | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-31②: 행 집계 — 대조표 R-31② 'EditButton 잠금 8건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E |  | 1 (R-31②) |
| WK-SSP0200-0041 | A5 | R-31③④ | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-31③④: 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소 |  | 1 (R-31③④) |
| WK-SSP0200-0042 | A5 | R-40 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-40: 행 집계 — 대조표 R-40 'spCalls 12건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smok |  | 1 (R-40) |
| WK-SSP0200-0043 | A5 | R-41 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-41: 행 집계 — 대조표 R-41 'entryPoints 12건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E  |  | 1 (R-41) |
| WK-SSP0200-0044 | A5 | R-50 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-50: 행 집계 — 대조표 R-50 'buttonGuards 52건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E |  | 1 (R-50) |
| WK-SSP0200-0045 | A5 | R-51 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-51: 행 집계 — 대조표 R-51 'validations 36건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E  |  | 1 (R-51) |
| WK-SSP0200-0046 | A5 | R-52 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-52: 행 집계 — 대조표 R-52 'popups 5건' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소: EDIT_MAIN — E2E smoke  |  | 1 (R-52) |
| WK-SSP0200-0047 | A5 | R-60 C10 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-60 C10: 행 집계 — 대조표 R-60 C10 '동일 SO 부분선택 → `MSG00247`' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FAIL 요소:  |  | 1 (R-60 C10) |
| WK-SSP0200-0048 | A5 | R-70 D11~D16 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-70 D11~D16: 행 집계 — 대조표 R-70 D11~D16 '`cellTypeImage` 경로별 차이' 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW:2 · FA |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0049 | A5 | R-70 D1·D2·D4·D5 | 사람판정(사람판정 대기) | A5 FAIL 수정 — R-70 D1·D2·D4·D5: 행 집계 — 대조표 R-70 D1·D2·D4·D5 "ChangeType='P' 폭 0/복원" 의 A5 38요소: PASS:19 · ERROR:11 · FAIL:6 · REVIEW |  | 1 (R-70 D1·D2·D4·D5) |
| WK-SSP0200-0050 | A5 | cascade 5단계 | 사람판정(사람판정 대기) | A5 FAIL 수정 — cascade 5단계: 행 집계 — 대조표 cascade 5단계 'Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출' 의 A5 38요소: PASS:19 · ERROR:1 |  | 1 (cascade 5단계) |
| WK-SSP0200-0051 | G4 | **C1** | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — **C1**: 행 집계 — 대조표 **C1** '`dtChangeStatusCode.Rows.RemoveAt(0)` = Status 콤보에' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 ·  |  | 1 (**C1**) |
| WK-SSP0200-0052 | G4 | **C2·C3** | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — **C2·C3**: 행 집계 — 대조표 **C2·C3** '`CODE != "EE"` — **완전일치 1건만** 제외' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 ·  |  | 1 (**C2·C3**) |
| WK-SSP0200-0053 | G4 | **C5** | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — **C5**: 행 집계 — 대조표 **C5** '`GetCheckedListValue(..., !JVFlag)` — 3번째 인자 false' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 ·  |  | 1 (**C5**) |
| WK-SSP0200-0054 | G4 | 9필드 인벤토리 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — 9필드 인벤토리: 행 집계 — 대조표 9필드 인벤토리 'Div / From Site / To Site / Status / Shipment Date' 의 G4 15요소: NOPATH:6 · NA:4 · PASS: |  | 1 (9필드 인벤토리) |
| WK-SSP0200-0055 | G4 | COMMON:UC-06 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G4 15요소: NOPATH:6 · NA:4 · PASS: |  | 1 (COMMON:UC-06) |
| WK-SSP0200-0056 | G4 | Designer 잔여 초기값 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — Designer 잔여 초기값: 행 집계 — 대조표 Designer 잔여 초기값 '`2013-07-12` / `1999-01-01`' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_R |  | 1 (Designer 잔여 초기값) |
| WK-SSP0200-0057 | G4 | L-047 ~ L-049·L-053 ~ L-056 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — L-047 ~ L-049·L-053 ~ L-056: 행 집계 — 대조표 L-047 ~ L-049·L-053 ~ L-056 '조회조건 라벨' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · N |  | 1 (L-047 ~ L-049·L-053 ~ L-056) |
| WK-SSP0200-0058 | G4 | Model 팝업 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — Model 팝업: 행 집계 — 대조표 Model 팝업 '`SCM0002_ItembyDivisionPopup` — `sdivision` + **`s' 의 G4 15요소: NOPATH:6 · NA:4 · PASS: |  | 1 (Model 팝업) |
| WK-SSP0200-0059 | G4 | Period 기본값 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — Period 기본값: 행 집계 — 대조표 Period 기본값 '`GetDayRange("")` = `SCM0001_GET_SCP_DAY_PERIOD`' 의 G4 15요소: NOPATH:6 · NA:4 · PAS |  | 1 (Period 기본값) |
| WK-SSP0200-0060 | G4 | R-12 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — R-12: 행 집계 — 대조표 R-12 'div 40/EE 컬럼 표시 전환(시트 축) 12건' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL  |  | 1 (R-12) |
| WK-SSP0200-0061 | G4 | R-13 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — R-13: 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: |  | 1 (R-13) |
| WK-SSP0200-0062 | G4 | `ChangeType='A'` | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — `ChangeType='A'`: 행 집계 — 대조표 `ChangeType='A'` '목록에 있고 항상 else 경로' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · F |  | 1 (`ChangeType='A'`) |
| WK-SSP0200-0063 | G4 | cascade 5단계 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — cascade 5단계: 행 집계 — 대조표 cascade 5단계 'Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출' 의 G4 15요소: NOPATH:6 · NA:4 · |  | 1 (cascade 5단계) |
| WK-SSP0200-0064 | G4 | payload 12키 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — payload 12키: 행 집계 — 대조표 payload 12키 'cs:1468~1482 · 1540~1541' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL |  | 1 (payload 12키) |
| WK-SSP0200-0065 | G4 | txtItemId / Item Id / Item | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — txtItemId / Item Id / Item: E2E smoke labels — 누락 라벨 |  | 1 (`txtItemId`(F1) · FCST Type(B4/F8)) |
| WK-SSP0200-0066 | G4 | 자동조회 금지 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — 자동조회 금지: 행 집계 — 대조표 자동조회 금지 '`FindData_Main` 은 `FindButton` 에서만' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FA |  | 1 (자동조회 금지) |
| WK-SSP0200-0067 | G4 | 초기 mount 무발화 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — 초기 mount 무발화: 행 집계 — 대조표 초기 mount 무발화 '`InitEvent()` 가 마지막이라 초기 설정이 cascade 를 트리거하지 않는다' 의 G4 15요소: NOPATH:6 · NA:4 · |  | 1 (초기 mount 무발화) |
| WK-SSP0200-0068 | G4 | 필드 수 > 6 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — 필드 수 > 6: 행 집계 — 대조표 필드 수 > 6 '—' 의 G4 15요소: NOPATH:6 · NA:4 · PASS:2 · NOT_RUN:2 · FAIL:1 · FAIL 요소: txtItemId / Ite |  | 1 (필드 수 > 6) |
| WK-SSP0200-0069 | H10 | SSP0200 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H10 FAIL 수정 — SSP0200 화면: 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 34 (L-083·L-089 L-087 L-090 ~ L-121 **L-127·) |
| WK-SSP0200-0070 | H2 | **L-050** | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — **L-050**: 행 집계 — 대조표 **L-050** '`PlanType1`(Change Type 라벨/콤보) `Visibility=Never`(' 의 H2 48요소: ERROR:19 · PASS:14 ·  |  | 1 (**L-050**) |
| WK-SSP0200-0071 | H2 | COMMON:UC-02 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 H2 48요소: ERROR:19 · PASS |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0072 | H2 | COMMON:UC-07 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H2 48요소: ERROR:19 · PASS |  | 1 (COMMON:UC-07) |
| WK-SSP0200-0073 | H2 | EditButton cs:783 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — EditButton cs:783: 행 집계 — 대조표 EditButton cs:783 '`siSub.RowCount==0` 일 때만 편집모드 진입 = 작성 중 요청이 있으면 상단' 의 H2 48요소: ERROR |  | 1 (EditButton cs:783) |
| WK-SSP0200-0074 | H2 | L-062·L-063 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — L-062·L-063: 행 집계 — 대조표 L-062·L-063 '`VisibleTab(true)` 2건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: |  | 1 (L-062·L-063) |
| WK-SSP0200-0075 | H2 | L-081 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — L-081: 행 집계 — 대조표 L-081 '`SheetName == shtMain` 일 때만 저장' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TR |  | 1 (L-081) |
| WK-SSP0200-0076 | H2 | R-01·R-02 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-01·R-02: 행 집계 — 대조표 R-01·R-02 '`FpSpread` 2 + 이벤트 10' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRA |  | 1 (R-01·R-02) |
| WK-SSP0200-0077 | H2 | R-10 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-10: 행 집계 — 대조표 R-10 '시트 초기화 폭/라벨/헤더 span/소수 32건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPOR |  | 1 (R-10) |
| WK-SSP0200-0078 | H2 | R-12 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-12: 행 집계 — 대조표 R-12 'div 40/EE 컬럼 표시 전환(시트 축) 12건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSP |  | 1 (R-12) |
| WK-SSP0200-0079 | H2 | R-13 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-13: 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT |  | 1 (R-13) |
| WK-SSP0200-0080 | H2 | R-18 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-18: 행 집계 — 대조표 R-18 'BOD 0행 처리' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mo |  | 1 (R-18) |
| WK-SSP0200-0081 | H2 | R-20·R-21 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-20·R-21: 행 집계 — 대조표 R-20·R-21 "동일 SO 전파 + 행상태 `'M'`" 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRAN |  | 1 (R-20·R-21) |
| WK-SSP0200-0082 | H2 | R-24 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-24: 행 집계 — 대조표 R-24 'CHANGE_REASON 연동 11건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE |  | 1 (R-24) |
| WK-SSP0200-0083 | H2 | R-27 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-27: 행 집계 — 대조표 R-27 '소수자릿수 동적 전환 8건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Tra |  | 1 (R-27) |
| WK-SSP0200-0084 | H2 | R-29 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-29: 행 집계 — 대조표 R-29 '검증 전 색/상태 초기화 16건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE /  |  | 1 (R-29) |
| WK-SSP0200-0085 | H2 | R-31② | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-31②: 행 집계 — 대조표 R-31② 'EditButton 잠금 8건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / |  | 1 (R-31②) |
| WK-SSP0200-0086 | H2 | R-31③④ | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-31③④: 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: T |  | 1 (R-31③④) |
| WK-SSP0200-0087 | H2 | R-40 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-40: 행 집계 — 대조표 R-40 'spCalls 12건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans  |  | 1 (R-40) |
| WK-SSP0200-0088 | H2 | R-41 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-41: 행 집계 — 대조표 R-41 'entryPoints 12건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Tr |  | 1 (R-41) |
| WK-SSP0200-0089 | H2 | R-50 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-50: 행 집계 — 대조표 R-50 'buttonGuards 52건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / T |  | 1 (R-50) |
| WK-SSP0200-0090 | H2 | R-51 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-51: 행 집계 — 대조표 R-51 'validations 36건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Tr |  | 1 (R-51) |
| WK-SSP0200-0091 | H2 | R-52 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-52: 행 집계 — 대조표 R-52 'popups 5건' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRANSPORT_MODE / Trans Mo |  | 1 (R-52) |
| WK-SSP0200-0092 | H2 | R-60 C10 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-60 C10: 행 집계 — 대조표 R-60 C10 '동일 SO 부분선택 → `MSG00247`' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL 요소: TRA |  | 1 (R-60 C10) |
| WK-SSP0200-0093 | H2 | R-70 D11~D16 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-70 D11~D16: 행 집계 — 대조표 R-70 D11~D16 '`cellTypeImage` 경로별 차이' 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1 · FAIL  |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0094 | H2 | R-70 D1·D2·D4·D5 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R-70 D1·D2·D4·D5: 행 집계 — 대조표 R-70 D1·D2·D4·D5 "ChangeType='P' 폭 0/복원" 의 H2 48요소: ERROR:19 · PASS:14 · NA:14 · FAIL:1  |  | 1 (R-70 D1·D2·D4·D5) |
| WK-SSP0200-0095 | H2 | SSP0200_ShipmentChangeRequest.CreateSpre | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — SSP0200_ShipmentChangeRequest.CreateSpread: 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.CreateSpread 의 H2 48요소: ERROR: |  | 8 (ACT:SSP0200_ShipmentChangeRequest.Create) |
| WK-SSP0200-0096 | H2 | TRANSPORT_MODE / Trans Mode | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — TRANSPORT_MODE / Trans Mode: 원장 V-5c9d1bd7 COLUMN / 원장 V-aa0a2227 COLUMN / 원장 V-d5f5548e ASIS / 원장 V-39282d7d ASIS /  |  | 7 (R-14 R-17 R-31⑥⑦ ACT:SSP0200_ShipmentCha) |
| WK-SSP0200-0097 | H2 | cascade 5단계 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — cascade 5단계: 행 집계 — 대조표 cascade 5단계 'Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출' 의 H2 48요소: ERROR:19 · PASS:1 |  | 1 (cascade 5단계) |
| WK-SSP0200-0098 | I1 | SSP0200 화면 | DB 메타(적용 예정) | I1 FAIL 수정 — SSP0200 화면: 원장 V-416fa20f RULE_SCREEN / 원장 V-d990dbbd RULE_SCREEN / 원장 V-18228284 RULE_SCREEN / 원장 V-49529088 DEFECT  |  | 111 (L-083·L-089 L-087 L-090 ~ L-121 **L-127·) |
| WK-SSP0200-0099 | D1 | **L-127·L-128** | DB 메타(적용 예정) | D1 FAIL 수정 — **L-127·L-128**: 행 집계 — 대조표 **L-127·L-128** 'Division 권한 0건 → 조회영역 전체 잠금 + `return`(이후 초기화 전부 중' 의 D1 19요소: FAIL:11 · |  | 1 (**L-127·L-128**) |
| WK-SSP0200-0100 | D1 | DIVISION_ID / Div | DB 메타(적용 예정) | D1 FAIL 수정 — DIVISION_ID / Div: 원장 V-1c4187ef COLUMN / 원장 V-00e520c0 COLUMN / 실측[T-d71b66e9]: 기존행 r0 DIVISION_ID 편집=false — AS-IS  |  | 10 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0101 | D1 | END_CUSTOMER / End Customer | DB 메타(적용 예정) | D1 FAIL 수정 — END_CUSTOMER / End Customer: 원장 V-edeb1a39 COLUMN / 원장 V-b6c480c3 COLUMN / 실측[T-50556479]: 기존행 r0 END_CUSTOMER 편집=fal |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0102 | D1 | EditButton cs:783 | DB 메타(적용 예정) | D1 FAIL 수정 — EditButton cs:783: 행 집계 — 대조표 EditButton cs:783 '`siSub.RowCount==0` 일 때만 편집모드 진입 = 작성 중 요청이 있으면 상단' 의 D1 19요소: FAIL: |  | 1 (EditButton cs:783) |
| WK-SSP0200-0103 | D1 | FROM_SITE_DESCRIPTION / From Site | DB 메타(적용 예정) | D1 FAIL 수정 — FROM_SITE_DESCRIPTION / From Site: 원장 V-c164dd22 COLUMN / 원장 V-66d3dadf COLUMN / 원장 V-3cfb5bb1 COLUMN / 원장 V-eb060858 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0104 | D1 | NICK_NAME / Nick Name | DB 메타(적용 예정) | D1 FAIL 수정 — NICK_NAME / Nick Name: 원장 V-403efb05 COLUMN / 원장 V-9c0b6388 COLUMN / 원장 V-b3f93c40 COLUMN / 원장 V-788c2db1 COLUMN / 실측 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0105 | D1 | PROJECT_CODE / Project Code | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — PROJECT_CODE / Project Code: 원장 V-9139fd4a COLUMN / 원장 V-e4fbca0b COLUMN / 실측[T-2d24645e]: 기존행 r0 PROJECT_CODE 편집=fal |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0106 | D1 | PROJECT_NAME / Project Name | DB 메타(적용 예정) | D1 FAIL 수정 — PROJECT_NAME / Project Name: 원장 V-e5aeb32c COLUMN / 원장 V-b5d3a9ee COLUMN / 원장 V-ea095339 COLUMN / 원장 V-185f3a85 COLUM |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0107 | D1 | R-13 | DB 메타(적용 예정) | D1 FAIL 수정 — R-13: 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div —  |  | 1 (R-13) |
| WK-SSP0200-0108 | D1 | R-27 | DB 메타(적용 예정) | D1 FAIL 수정 — R-27: 행 집계 — 대조표 R-27 '소수자릿수 동적 전환 8건' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c4187 |  | 1 (R-27) |
| WK-SSP0200-0109 | D1 | R-31② | DB 메타(적용 예정) | D1 FAIL 수정 — R-31②: 행 집계 — 대조표 R-31② 'EditButton 잠금 8건' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c |  | 1 (R-31②) |
| WK-SSP0200-0110 | D1 | R-31③④ | DB 메타(적용 예정) | D1 FAIL 수정 — R-31③④: 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID  |  | 1 (R-31③④) |
| WK-SSP0200-0111 | D1 | R-50 | DB 메타(적용 예정) | D1 FAIL 수정 — R-50: 행 집계 — 대조표 R-50 'buttonGuards 52건' 의 D1 19요소: FAIL:11 · NA:4 · ERROR:4 · FAIL 요소: DIVISION_ID / Div — 원장 V-1c41 |  | 1 (R-50) |
| WK-SSP0200-0112 | D1 | REQUESTOR / Shipment Requestor | DB 메타(적용 예정) | D1 FAIL 수정 — REQUESTOR / Shipment Requestor: 원장 V-a0894ec7 COLUMN / 원장 V-9ea7e1a0 COLUMN / 실측[T-cbeb0b33]: 기존행 r0 REQUESTOR 편집=fal |  | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0113 | D1 | REQUEST_DATE / Request Date | DB 메타(적용 예정) | D1 FAIL 수정 — REQUEST_DATE / Request Date: 원장 V-d26e6d6e COLUMN / 원장 V-e1d9252c COLUMN / 실측[T-85467553]: 기존행 r0 REQUEST_DATE 편집=fal |  | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0114 | D1 | SHIPMENT_STATUS / Status | DB 메타(적용 예정) | D1 FAIL 수정 — SHIPMENT_STATUS / Status: 원장 V-416bcf91 COLUMN / 원장 V-fdc2334f COLUMN / 실측[T-5cff5e2b]: 기존행 r0 SHIPMENT_STATUS 편집=fal |  | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0115 | D1 | SSP0200_ShipmentChangeRequest.EditButton | DB 메타(적용 예정) | D1 FAIL 수정 — SSP0200_ShipmentChangeRequest.EditButton: 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.EditButton 의 D1 12요소: FAIL:8 · E |  | 9 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0116 | D1 | TO_SITE_DESCRIPTION / To Site | DB 메타(적용 예정) | D1 FAIL 수정 — TO_SITE_DESCRIPTION / To Site: 원장 V-32342f7f COLUMN / 원장 V-9538d71f COLUMN / 원장 V-7296b0a3 COLUMN / 원장 V-c9f1f773 COL |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0117 | D1 | TO_SITE_SOLDTO_CODE / Sold to | DB 메타(적용 예정) | D1 FAIL 수정 — TO_SITE_SOLDTO_CODE / Sold to: 원장 V-1696486e COLUMN / 원장 V-67fc9977 COLUMN / 실측[T-f5eeba53]: 기존행 r0 TO_SITE_SOLDTO_CO |  | 5 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0118 | D5 | COMMON:UC-05 | 화면 FE(범위 밖(가이드만)) | D5 FAIL 수정 — COMMON:UC-05: 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 D5 25요소: PASS:12 · NA:10 |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0119 | D5 | LT_DAY / L/T(Day | 화면 FE(범위 밖(가이드만)) | D5 FAIL 수정 — LT_DAY / L/T(Day: 실측[T-a14fa2d0]: LT_DAY: AS-IS TEXT(cell_rules) ↔ TO-BE dataType=2 dataMap=N — AS-IS TEXT 에디터가 아님 (F |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0120 | D5 | SSP0200_ShipmentChangeRequest.CreateSpre | 화면 FE(범위 밖(가이드만)) | D5 FAIL 수정 — SSP0200_ShipmentChangeRequest.CreateSpread: 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.CreateSpread 의 D5 25요소: PASS:1 |  | 8 (ACT:SSP0200_ShipmentChangeRequest.Create) |
| WK-SSP0200-0121 | A6 | **L-152** | 사람판정(사람판정 대기) | A6 FAIL 수정 — **L-152**: 행 집계 — 대조표 **L-152** '조회 SP 2번째 커서로 승인자 **빈칸일 때만** 자동채움' 의 A6 8요소: ERROR:5 · NA:1 · PASS:1 · FAIL:1 · FAIL |  | 1 (**L-152**) |
| WK-SSP0200-0122 | A6 | L-072 | 사람판정(사람판정 대기) | A6 FAIL 수정 — L-072: 행 집계 — 대조표 L-072 '`FindButton` = `FindData_Main(); FindData_Sub_Draf' 의 A6 8요소: ERROR:5 · NA:1 · PASS:1 · FAIL |  | 1 (L-072) |
| WK-SSP0200-0123 | A6 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUE | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTING: 원장 V-0e0257e2 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['NEW_SHIPMENT_DA |  | 64 (ACT:SSP0200_ShipmentChangeRequest.FindBu) |
| WK-SSP0200-0124 | A6 | R-14 | 사람판정(사람판정 대기) | A6 FAIL 수정 — R-14: 행 집계 — 대조표 R-14 'TO_SITE/FROM_SITE 변경 → `INCOTERMS`/`TRANSPORT_MODE' 의 A6 8요소: ERROR:5 · NA:1 · PASS:1 · FAIL:1 |  | 1 (R-14) |
| WK-SSP0200-0125 | A6 | R-18 | 사람판정(사람판정 대기) | A6 FAIL 수정 — R-18: 행 집계 — 대조표 R-18 'BOD 0행 처리' 의 A6 8요소: ERROR:5 · NA:1 · PASS:1 · FAIL:1 · FAIL 요소: PKG_SSP0200.P_SSP0200_GET_SHI |  | 1 (R-18) |
| WK-SSP0200-0126 | A6 | 자동조회 금지 | 사람판정(사람판정 대기) | A6 FAIL 수정 — 자동조회 금지: 행 집계 — 대조표 자동조회 금지 '`FindData_Main` 은 `FindButton` 에서만' 의 A6 8요소: ERROR:5 · NA:1 · PASS:1 · FAIL:1 · FAIL 요소 |  | 1 (자동조회 금지) |
| WK-SSP0200-0127 | G1 | **C1** | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — **C1**: 행 집계 — 대조표 **C1** '`dtChangeStatusCode.Rows.RemoveAt(0)` = Status 콤보에' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · F |  | 1 (**C1**) |
| WK-SSP0200-0128 | G1 | **C2·C3** | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — **C2·C3**: 행 집계 — 대조표 **C2·C3** '`CODE != "EE"` — **완전일치 1건만** 제외' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL |  | 1 (**C2·C3**) |
| WK-SSP0200-0129 | G1 | **C5** | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — **C5**: 행 집계 — 대조표 **C5** '`GetCheckedListValue(..., !JVFlag)` — 3번째 인자 false' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · F |  | 1 (**C5**) |
| WK-SSP0200-0130 | G1 | **L-127·L-128** | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — **L-127·L-128**: 행 집계 — 대조표 **L-127·L-128** 'Division 권한 0건 → 조회영역 전체 잠금 + `return`(이후 초기화 전부 중' 의 G1 12요소: PASS:6 ·  |  | 1 (**L-127·L-128**) |
| WK-SSP0200-0131 | G1 | **L-152** | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — **L-152**: 행 집계 — 대조표 **L-152** '조회 SP 2번째 커서로 승인자 **빈칸일 때만** 자동채움' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAI |  | 1 (**L-152**) |
| WK-SSP0200-0132 | G1 | 9필드 인벤토리 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — 9필드 인벤토리: 행 집계 — 대조표 9필드 인벤토리 'Div / From Site / To Site / Status / Shipment Date' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 |  | 1 (9필드 인벤토리) |
| WK-SSP0200-0133 | G1 | COMMON:UC-02 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 12요소: PASS:6 · ERROR: |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0134 | G1 | COMMON:UC-03 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 G1 12요소: PASS:6 · ERROR: |  | 1 (COMMON:UC-03) |
| WK-SSP0200-0135 | G1 | COMMON:UC-05 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — COMMON:UC-05: 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 G1 12요소: PASS:6 · ERROR: |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0136 | G1 | COMMON:UC-06 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 |  | 1 (COMMON:UC-06) |
| WK-SSP0200-0137 | G1 | COMMON:UC-07 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 12요소: PASS:6 · ERROR: |  | 1 (COMMON:UC-07) |
| WK-SSP0200-0138 | G1 | Designer 잔여 초기값 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — Designer 잔여 초기값: 행 집계 — 대조표 Designer 잔여 초기값 '`2013-07-12` / `1999-01-01`' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 |  | 1 (Designer 잔여 초기값) |
| WK-SSP0200-0139 | G1 | L-016 ~ L-019·**L-148** | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — L-016 ~ L-019·**L-148**: 행 집계 — 대조표 L-016 ~ L-019·**L-148** '요청자/부서 세션 주입(언어별 `UserName`/`UserName_E`)' 의 G1 12요소: PA |  | 1 (L-016 ~ L-019·**L-148**) |
| WK-SSP0200-0140 | G1 | L-047 ~ L-049·L-053 ~ L-056 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — L-047 ~ L-049·L-053 ~ L-056: 행 집계 — 대조표 L-047 ~ L-049·L-053 ~ L-056 '조회조건 라벨' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FA |  | 1 (L-047 ~ L-049·L-053 ~ L-056) |
| WK-SSP0200-0141 | G1 | L-072 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — L-072: 행 집계 — 대조표 L-072 '`FindButton` = `FindData_Main(); FindData_Sub_Draf' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAI |  | 1 (L-072) |
| WK-SSP0200-0142 | G1 | Model 팝업 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — Model 팝업: 행 집계 — 대조표 Model 팝업 '`SCM0002_ItembyDivisionPopup` — `sdivision` + **`s' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 |  | 1 (Model 팝업) |
| WK-SSP0200-0143 | G1 | Period 기본값 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — Period 기본값: 행 집계 — 대조표 Period 기본값 '`GetDayRange("")` = `SCM0001_GET_SCP_DAY_PERIOD`' 의 G1 12요소: PASS:6 · ERROR:3 · NA |  | 1 (Period 기본값) |
| WK-SSP0200-0144 | G1 | R-12 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — R-12: 행 집계 — 대조표 R-12 'div 40/EE 컬럼 표시 전환(시트 축) 12건' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus |  | 1 (R-12) |
| WK-SSP0200-0145 | G1 | R-13 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — R-13: 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus /  |  | 1 (R-13) |
| WK-SSP0200-0146 | G1 | R-14 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — R-14: 행 집계 — 대조표 R-14 'TO_SITE/FROM_SITE 변경 → `INCOTERMS`/`TRANSPORT_MODE' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL: |  | 1 (R-14) |
| WK-SSP0200-0147 | G1 | R-27 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — R-27: 행 집계 — 대조표 R-27 '소수자릿수 동적 전환 8건' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 |  | 1 (R-27) |
| WK-SSP0200-0148 | G1 | R-31③④ | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — R-31③④: 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboS |  | 1 (R-31③④) |
| WK-SSP0200-0149 | G1 | R-41 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — R-41: 행 집계 — 대조표 R-41 'entryPoints 12건' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원 |  | 1 (R-41) |
| WK-SSP0200-0150 | G1 | `ChangeType='A'` | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — `ChangeType='A'`: 행 집계 — 대조표 `ChangeType='A'` '목록에 있고 항상 else 경로' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL  |  | 1 (`ChangeType='A'`) |
| WK-SSP0200-0151 | G1 | cascade 5단계 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — cascade 5단계: 행 집계 — 대조표 cascade 5단계 'Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출' 의 G1 12요소: PASS:6 · ERROR:3  |  | 1 (cascade 5단계) |
| WK-SSP0200-0152 | G1 | cboStatus / Status | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — cboStatus / Status: 원장 V-38259ec9 SEARCH / E2E smoke cond combo (FX-SSP0200-020) |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0153 | G1 | payload 12키 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — payload 12키: 행 집계 — 대조표 payload 12키 'cs:1468~1482 · 1540~1541' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: |  | 1 (payload 12키) |
| WK-SSP0200-0154 | G1 | 설계 정본 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — 설계 정본: 행 집계 — 대조표 설계 정본 '`.atlas/gscm-design/SSP0200/design/00_checklist.md' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAI |  | 1 (설계 정본) |
| WK-SSP0200-0155 | G1 | 자동조회 금지 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — 자동조회 금지: 행 집계 — 대조표 자동조회 금지 '`FindData_Main` 은 `FindButton` 에서만' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요 |  | 1 (자동조회 금지) |
| WK-SSP0200-0156 | G1 | 초기 mount 무발화 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — 초기 mount 무발화: 행 집계 — 대조표 초기 mount 무발화 '`InitEvent()` 가 마지막이라 초기 설정이 cascade 를 트리거하지 않는다' 의 G1 12요소: PASS:6 · ERROR:3  |  | 1 (초기 mount 무발화) |
| WK-SSP0200-0157 | G1 | 필드 수 > 6 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — 필드 수 > 6: 행 집계 — 대조표 필드 수 > 6 '—' 의 G1 12요소: PASS:6 · ERROR:3 · NA:2 · FAIL:1 · FAIL 요소: cboStatus / Status — 원장 V-38 |  | 1 (필드 수 > 6) |
| WK-SSP0200-0158 | X-ROW | SSP0200_ShipmentChangeRequest.BtnChangeR | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.BtnChangeRe_Click: 진입점 집계 13검사 — ERROR:12 · FAIL:1 (FX-SSP0200-288) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0159 | X-ROW | SSP0200_ShipmentChangeRequest.BtnNew_Cli | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.BtnNew_Click: 진입점 집계 46검사 — ERROR:26 · NOPATH:9 · FAIL:7 · PASS:4 (FX-SSP0200-289) |  | 7 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0160 | X-ROW | SSP0200_ShipmentChangeRequest.DeleteData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.DeleteDataDrafting: 진입점 집계 12검사 — PASS:6 · ERROR:4 · NA:1 · FAIL:1 (FX-SSP0200-300) |  | 45 (ACT:SSP0200_ShipmentChangeRequest.Delete) |
| WK-SSP0200-0161 | X-ROW | SSP0200_ShipmentChangeRequest.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.FindButton: 진입점 집계 6검사 — PASS:4 · REVIEW:1 · FAIL:1 (FX-SSP0200-304) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.FindBu) |
| WK-SSP0200-0162 | X-ROW | SSP0200_ShipmentChangeRequest.FindData_M | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.FindData_Main: 진입점 집계 16검사 — PASS:11 · NA:2 · ERROR:2 · FAIL:1 (FX-SSP0200-307) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0163 | X-ROW | SSP0200_ShipmentChangeRequest.FindData_M | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.FindData_Main_Nonasync: 진입점 집계 15검사 — PASS:7 · ERROR:3 · NA:3 · REVIEW:1 · FAIL:1 (F |  | 5 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0164 | X-ROW | SSP0200_ShipmentChangeRequest.FindData_S | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.FindData_Sub_Draft: 진입점 집계 10검사 — PASS:4 · ERROR:2 · NA:2 · REVIEW:1 · FAIL:1 (FX-SS |  | 5 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0165 | X-ROW | SSP0200_ShipmentChangeRequest.GetErpIFCh | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.GetErpIFCheck: 진입점 집계 12검사 — ERROR:6 · NOPATH:2 · PASS:2 · FAIL:1 · NA:1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0166 | X-ROW | SSP0200_ShipmentChangeRequest.InitSpread | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.InitSpread: 진입점 집계 105검사 — PASS:50 · NA:33 · ERROR:12 · FAIL:7 · NOT_RUN:2 · REVIEW: |  | 22 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0167 | X-ROW | SSP0200_ShipmentChangeRequest.InsertRow | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.InsertRow: 진입점 집계 40검사 — ERROR:20 · NOPATH:10 · FAIL:7 · PASS:3 (FX-SSP0200-320) |  | 53 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0168 | X-ROW | SSP0200_ShipmentChangeRequest.InsertRowM | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.InsertRowMultiple: 진입점 집계 39검사 — ERROR:19 · NOPATH:10 · FAIL:7 · PASS:3 (FX-SSP0200- |  | 68 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0169 | X-ROW | SSP0200_ShipmentChangeRequest.NewNonSoNo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.NewNonSoNo: 진입점 집계 6검사 — PASS:3 · NA:1 · FAIL:1 · ERROR:1 (FX-SSP0200-322) |  | 138 (ACT:SSP0200_ShipmentChangeRequest.NewNon) |
| WK-SSP0200-0170 | X-ROW | SSP0200_ShipmentChangeRequest.NonSoNo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.NonSoNo: 진입점 집계 10검사 — NA:5 · PASS:2 · ERROR:2 · FAIL:1 (FX-SSP0200-323) |  | 152 (ACT:SSP0200_ShipmentChangeRequest.NonSoN) |
| WK-SSP0200-0171 | X-ROW | SSP0200_ShipmentChangeRequest.SSP_Main_V | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.SSP_Main_Validation: 진입점 집계 29검사 — ERROR:22 · NA:5 · FAIL:2 (FX-SSP0200-324) |  | 125 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0172 | X-ROW | SSP0200_ShipmentChangeRequest.SaveButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.SaveButton: 진입점 집계 42검사 — NA:21 · PASS:11 · ERROR:9 · FAIL:1 (FX-SSP0200-325) |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SaveBu) |
| WK-SSP0200-0173 | X-ROW | SSP0200_ShipmentChangeRequest.SaveDataDr | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.SaveDataDrafting: 진입점 집계 24검사 — NA:12 · PASS:6 · ERROR:5 · FAIL:1 (FX-SSP0200-326) |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SaveDa) |
| WK-SSP0200-0174 | X-ROW | SSP0200_ShipmentChangeRequest.SoNo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.SoNo: 진입점 집계 10검사 — NA:5 · PASS:2 · ERROR:2 · FAIL:1 (FX-SSP0200-327) |  | 175 (ACT:SSP0200_ShipmentChangeRequest.SoNo A) |
| WK-SSP0200-0175 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_Ce | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.SpdMain_CellClick: 진입점 집계 28검사 — ERROR:17 · NOPATH:7 · FAIL:2 · PASS:2 (FX-SSP0200-3 |  | 70 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0176 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_Ce | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.SpdMain_CellDoubleClick: 진입점 집계 59검사 — ERROR:37 · NA:12 · NOPATH:4 · PASS:3 · FAIL:2 |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0177 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_Co | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.SpdMain_ComboSelChange: 진입점 집계 174검사 — ERROR:149 · NOPATH:10 · NA:6 · PASS:5 · FAIL: |  | 45 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0178 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_Ed | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.SpdMain_EditChange: 진입점 집계 42검사 — ERROR:39 · PASS:2 · FAIL:1 (FX-SSP0200-333) |  | 52 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0179 | X-ROW | SSP0200_ShipmentChangeRequest.checkRequi | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.checkRequired: 진입점 집계 10검사 — ERROR:9 · FAIL:1 (FX-SSP0200-334) |  | 20 (ACT:SSP0200_ShipmentChangeRequest.checkR) |
| WK-SSP0200-0180 | X-ROW | SSP0200_ShipmentChangeRequest.chkERPIFBl | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.chkERPIFBlockYn: 진입점 집계 3검사 — NA:2 · FAIL:1 (FX-SSP0200-335) |  | 13 (ACT:SSP0200_ShipmentChangeRequest.chkERP) |
| WK-SSP0200-0181 | X-ROW | SSP0200_ShipmentChangeRequest.shtMain_Ch | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequest.shtMain_Change: 진입점 집계 7검사 — ERROR:5 · NA:1 · FAIL:1 (FX-SSP0200-336) |  | 106 (ACT:SSP0200_ShipmentChangeRequest.shtMai) |
| WK-SSP0200-0182 | X-ROW | SSP0200_ShipmentChangeRequestInsertPopup | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0200_ShipmentChangeRequestInsertPopup.SaveData: 진입점 집계 7검사 — ERROR:5 · FAIL:1 · NA:1 (FX-SSP0200-337) |  | 2 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0183 | M3 | new SSP0300_OrderDetailPopup() | 화면 FE(범위 밖(가이드만)) | M3 FAIL 수정 — new SSP0300_OrderDetailPopup(): 원장 V-1075a1e6 (FX-SSP0200-048) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |

## W5 검사기 연결 (44)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0184 | B1 | DIVISION_ID / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID / Div | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0185 | B1 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 3 (R-26 ACT:SSP0200_ShipmentChangeRequest.s) |
| WK-SSP0200-0186 | B1 | FROM_SITE_DESCRIPTION / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION / From Site | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0187 | B1 | TO_SITE_DESCRIPTION / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION / To Site | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0188 | B1 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0189 | B2 | DIVISION_ID / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID / Div | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0190 | B2 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 3 (R-26 ACT:SSP0200_ShipmentChangeRequest.s) |
| WK-SSP0200-0191 | B2 | FROM_SITE_DESCRIPTION / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION / From Site | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0192 | B2 | TO_SITE_DESCRIPTION / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION / To Site | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0193 | B2 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0194 | B3 | DIVISION_ID / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL DIVISION_ID / Div | 있음(SHEET_COLUMNS) | 7 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0195 | B3 | FROM_SITE_DESCRIPTION / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL FROM_SITE_DESCRIPTION / From Site | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0196 | B4 | DIVISION_ID / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID / Div | 있음(SHEET_COLUMNS) | 13 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0197 | B4 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 3 (R-26 ACT:SSP0200_ShipmentChangeRequest.s) |
| WK-SSP0200-0198 | B4 | FROM_SITE_DESCRIPTION / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FROM_SITE_DESCRIPTION / From Site | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0199 | B4 | TO_SITE_DESCRIPTION / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TO_SITE_DESCRIPTION / To Site | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0200 | B4 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0201 | DB-SYN | SSP0200_GET_ITEM_FROM_BOD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_ITEM_FROM_BOD | 없음(PROC_M 대응 없음) | 3 (R-27 ACT:SSP0200_ShipmentChangeRequest.G) |
| WK-SSP0200-0202 | DB-SYN | SSP0200_GET_SHIPMENT_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_SHIPMENT_DIVISION | 없음(PROC_M 대응 없음) | 3 (**C4** ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0203 | DB-SYN | SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVIS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPE | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0200_ShipmentChangeRequest.GetPla) |
| WK-SSP0200-0204 | DB-SYN | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 없음(PROC_M 대응 없음) | 3 (ACT:SSP0200_ShipmentChangeRequest.GetDiv) |
| WK-SSP0200-0205 | G4 | btnApprovalUser | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnApprovalUser | 있음(FE 소스) | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0206 | G4 | btnCancel | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnCancel | 없음 | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0207 | G4 | btnChangeRe2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnChangeRe2 | 없음 | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0208 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0209 | G4 | btnNew | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNew | 있음(FE 소스) | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0210 | G4 | btnSave | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSave | 있음(FE 소스) | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0211 | E5 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 1 (R-26) |
| WK-SSP0200-0212 | G5 | FROM_SITE / From Site ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL FROM_SITE / From Site ID | 있음(SHEET_COLUMNS) | 1 (R-28) |
| WK-SSP0200-0213 | G5 | FROM_SITE_DESCRIPTION / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL FROM_SITE_DESCRIPTION / From Site | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0214 | G5 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0215 | G5 | PROJECT_NAME / Project Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL PROJECT_NAME / Project Name | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0216 | G5 | TO_SITE / To Site ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TO_SITE / To Site ID | 있음(SHEET_COLUMNS) | 1 (R-28) |
| WK-SSP0200-0217 | G5 | TO_SITE_DESCRIPTION / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TO_SITE_DESCRIPTION / To Site | 있음(SHEET_COLUMNS) | 4 (R-28 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0218 | G5 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0219 | G5 | btnApprovalUser | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnApprovalUser | 있음(FE 소스) | 1 (L-020 ~ L-023·L-024·L-026·**L-078·L-125*) |
| WK-SSP0200-0220 | H6 | FROM_SITE / From Site ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_SITE / From Site ID | 있음(SHEET_COLUMNS) | 1 (R-28) |
| WK-SSP0200-0221 | H6 | FROM_SITE_DESCRIPTION / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_SITE_DESCRIPTION / From Site | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0222 | H6 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0223 | H6 | PROJECT_NAME / Project Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_NAME / Project Name | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0224 | H6 | TO_SITE / To Site ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_SITE / To Site ID | 있음(SHEET_COLUMNS) | 1 (R-28) |
| WK-SSP0200-0225 | H6 | TO_SITE_DESCRIPTION / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_SITE_DESCRIPTION / To Site | 있음(SHEET_COLUMNS) | 4 (R-28 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0226 | H6 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0227 | H6 | btnApprovalUser | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnApprovalUser | 있음(FE 소스) | 1 (L-020 ~ L-023·L-024·L-026·**L-078·L-125*) |

## W6 검증 실행 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0228 | G4 | cboChangeType / Change Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboChangeType / Change Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 48 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0229 | G4 | dtDate / Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — dtDate / Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |

## W7 기대값 확정 (117)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0230 | F4 | SSP0200_GET_ITEM_FROM_BOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0200_GET_ITEM_FROM_BOD: 실측[T-f546e099]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confi |  | 3 (R-27 ACT:SSP0200_ShipmentChangeRequest.G) |
| WK-SSP0200-0231 | F4 | SSP0200_GET_SHIPMENT_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0200_GET_SHIPMENT_DIVISION: 실측[T-2cb54d5b]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=c |  | 3 (**C4** ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0232 | F4 | SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVIS | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPE: 실측[T-3a28cb86]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_ |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetPla) |
| WK-SSP0200-0233 | F4 | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE: 실측[T-07439b8b]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv s |  | 3 (ACT:SSP0200_ShipmentChangeRequest.GetDiv) |
| WK-SSP0200-0234 | A5 | CHK / ALL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — CHK / ALL: E2E smoke columns / 실측[T-15635aea]: CHK: AS-IS(Div 40) '→숨김?' — 표시 여부가 조건 분기(원문 미해석 '?')라 정답 미확정 → 수동 검수 W7 |  | 8 (**R-30** R-70 D7·D8 R-70 D9 ACT:SSP0200_) |
| WK-SSP0200-0235 | A5 | EDIT_MAIN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — EDIT_MAIN: E2E smoke columns / 실측[T-4e2e49d9]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] EDIT_MAIN: |  | 1 (R-19) |
| WK-SSP0200-0236 | H5 | cboChangeType / Change Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — cboChangeType / Change Type: 검증 엔진이 실행됐으나 이 대상(COND cboChangeType)을 판정하지 못함 — 라벨 명칭 시나리오 수동 확인 또는 엔진 확장 |  | 43 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0237 | X-REASON | L-012·L-013 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — L-012·L-013 `usrLabel2` 섹션 헤더(정적, `.cs` 참조 0건) 미이식 — 정적 장식 라벨, TO-BE 폼에 대응 영역 없음 미이식(장식) |  | 1 (L-012·L-013) |
| WK-SSP0200-0238 | A1 | **C1** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **C1**: 행 집계 — 대조표 **C1** '`dtChangeStatusCode.Rows.RemoveAt(0)` = Status 콤보에' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소:  |  | 1 (**C1**) |
| WK-SSP0200-0239 | A1 | **C2·C3** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **C2·C3**: 행 집계 — 대조표 **C2·C3** '`CODE != "EE"` — **완전일치 1건만** 제외' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET_ |  | 1 (**C2·C3**) |
| WK-SSP0200-0240 | A1 | **C5** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **C5**: 행 집계 — 대조표 **C5** '`GetCheckedListValue(..., !JVFlag)` — 3번째 인자 false' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소:  |  | 1 (**C5**) |
| WK-SSP0200-0241 | A1 | **L-127·L-128** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **L-127·L-128**: 행 집계 — 대조표 **L-127·L-128** 'Division 권한 0건 → 조회영역 전체 잠금 + `return`(이후 초기화 전부 중' 의 A1 8요소: REVIEW:5 ·  |  | 1 (**L-127·L-128**) |
| WK-SSP0200-0242 | A1 | **L-152** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **L-152**: 행 집계 — 대조표 **L-152** '조회 SP 2번째 커서로 승인자 **빈칸일 때만** 자동채움' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET |  | 1 (**L-152**) |
| WK-SSP0200-0243 | A1 | 9필드 인벤토리 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9필드 인벤토리: 행 집계 — 대조표 9필드 인벤토리 'Div / From Site / To Site / Status / Shipment Date' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL  |  | 1 (9필드 인벤토리) |
| WK-SSP0200-0244 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 8요소: REVIEW:5 · PASS:3 |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0245 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 A1 8요소: REVIEW:5 · PASS:3 |  | 1 (COMMON:UC-03) |
| WK-SSP0200-0246 | A1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-05: 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 A1 8요소: REVIEW:5 · PASS:3 |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0247 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL  |  | 1 (COMMON:UC-06) |
| WK-SSP0200-0248 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 8요소: REVIEW:5 · PASS:3 |  | 1 (COMMON:UC-07) |
| WK-SSP0200-0249 | A1 | Designer 잔여 초기값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Designer 잔여 초기값: 행 집계 — 대조표 Designer 잔여 초기값 '`2013-07-12` / `1999-01-01`' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP02 |  | 1 (Designer 잔여 초기값) |
| WK-SSP0200-0250 | A1 | L-016 ~ L-019·**L-148** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L-016 ~ L-019·**L-148**: 행 집계 — 대조표 L-016 ~ L-019·**L-148** '요청자/부서 세션 주입(언어별 `UserName`/`UserName_E`)' 의 A1 8요소: REVI |  | 1 (L-016 ~ L-019·**L-148**) |
| WK-SSP0200-0251 | A1 | L-047 ~ L-049·L-053 ~ L-056 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L-047 ~ L-049·L-053 ~ L-056: 행 집계 — 대조표 L-047 ~ L-049·L-053 ~ L-056 '조회조건 라벨' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: S |  | 1 (L-047 ~ L-049·L-053 ~ L-056) |
| WK-SSP0200-0252 | A1 | L-072 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L-072: 행 집계 — 대조표 L-072 '`FindButton` = `FindData_Main(); FindData_Sub_Draf' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SS |  | 1 (L-072) |
| WK-SSP0200-0253 | A1 | Model 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Model 팝업: 행 집계 — 대조표 Model 팝업 '`SCM0002_ItembyDivisionPopup` — `sdivision` + **`s' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL  |  | 1 (Model 팝업) |
| WK-SSP0200-0254 | A1 | PKG_SSP0026.P_SSP0026_GET_BOD_ITEM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0026.P_SSP0026_GET_BOD_ITEM: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0200/SSP0026_GET_BOD_ITEM.md — 파라 |  | 31 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0255 | A1 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANG | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_: golden DIFF AS-IS 0행 ↔ TO-BE 0행: Doc/golden/SSP0200/SSP0200_GET_SH |  | 44 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0256 | A1 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTIN: golden DIFF AS-IS 0행 ↔ TO-BE 0행: Doc/golden/SSP0200/SSP0200_GET_SH |  | 64 (ACT:SSP0200_ShipmentChangeRequest.FindBu) |
| WK-SSP0200-0257 | A1 | R-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-12: 행 집계 — 대조표 R-12 'div 40/EE 컬럼 표시 전환(시트 축) 12건' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET_SHIPMENT_DIVIS |  | 1 (R-12) |
| WK-SSP0200-0258 | A1 | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-13: 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET_SHIPMENT_DIVISION |  | 1 (R-13) |
| WK-SSP0200-0259 | A1 | R-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-14: 행 집계 — 대조표 R-14 'TO_SITE/FROM_SITE 변경 → `INCOTERMS`/`TRANSPORT_MODE' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0 |  | 1 (R-14) |
| WK-SSP0200-0260 | A1 | R-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-18: 행 집계 — 대조표 R-18 'BOD 0행 처리' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET_SHIPMENT_DIVISION — golden SKIP A |  | 1 (R-18) |
| WK-SSP0200-0261 | A1 | R-31③④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-31③④: 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET_SHIPMENT_ |  | 1 (R-31③④) |
| WK-SSP0200-0262 | A1 | R-41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-41: 행 집계 — 대조표 R-41 'entryPoints 12건' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET_SHIPMENT_DIVISION — golden  |  | 1 (R-41) |
| WK-SSP0200-0263 | A1 | SSP0200_GET_ITEM_FROM_BOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0200_GET_ITEM_FROM_BOD: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0200/SSP0200_GET_ITEM_FROM_BOD.md — 파라미터 미 |  | 1 (R-27) |
| WK-SSP0200-0264 | A1 | SSP0200_GET_SHIPMENT_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0200_GET_SHIPMENT_DIVISION: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0200/SSP0200_GET_SHIPMENT_DIVISION.md  |  | 1 (**C4**) |
| WK-SSP0200-0265 | A1 | `ChangeType='A'` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `ChangeType='A'`: 행 집계 — 대조표 `ChangeType='A'` '목록에 있고 항상 else 경로' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET_S |  | 1 (`ChangeType='A'`) |
| WK-SSP0200-0266 | A1 | `txtItemId`(F1) · FCST Type(B4/F8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `txtItemId`(F1) · FCST Type(B4/F8): 행 집계 — 대조표 `txtItemId`(F1) · FCST Type(B4/F8) 'dead' 의 A1 8요소: REVIEW:5 · PASS:3 · |  | 1 (`txtItemId`(F1) · FCST Type(B4/F8)) |
| WK-SSP0200-0267 | A1 | cascade 5단계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cascade 5단계: 행 집계 — 대조표 cascade 5단계 'Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출' 의 A1 8요소: REVIEW:5 · PASS:3 · |  | 1 (cascade 5단계) |
| WK-SSP0200-0268 | A1 | payload 12키 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — payload 12키: 행 집계 — 대조표 payload 12키 'cs:1468~1482 · 1540~1541' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET_SHIP |  | 1 (payload 12키) |
| WK-SSP0200-0269 | A1 | 설계 정본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 설계 정본: 행 집계 — 대조표 설계 정본 '`.atlas/gscm-design/SSP0200/design/00_checklist.md' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SS |  | 1 (설계 정본) |
| WK-SSP0200-0270 | A1 | 자동조회 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 자동조회 금지: 행 집계 — 대조표 자동조회 금지 '`FindData_Main` 은 `FindButton` 에서만' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET_SH |  | 1 (자동조회 금지) |
| WK-SSP0200-0271 | A1 | 초기 mount 무발화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 초기 mount 무발화: 행 집계 — 대조표 초기 mount 무발화 '`InitEvent()` 가 마지막이라 초기 설정이 cascade 를 트리거하지 않는다' 의 A1 8요소: REVIEW:5 · PASS:3 · |  | 1 (초기 mount 무발화) |
| WK-SSP0200-0272 | A1 | 필드 수 > 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 필드 수 > 6: 행 집계 — 대조표 필드 수 > 6 '—' 의 A1 8요소: REVIEW:5 · PASS:3 · FAIL 요소: SSP0200_GET_SHIPMENT_DIVISION — golden SKIP A |  | 1 (필드 수 > 6) |
| WK-SSP0200-0273 | G03-WIRE | SSP0200 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SSP0200 화면: 게이트 G03 As-is 이벤트 btnInsertMultiple.Click → btnI / 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에  |  | 25 (ACT:SSP0200_ShipmentChangeRequest..ctor ) |
| WK-SSP0200-0274 | X-LOC | **L-050** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **L-050**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**L-050**) |
| WK-SSP0200-0275 | X-LOC | **L-074** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **L-074**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**L-074**) |
| WK-SSP0200-0276 | X-LOC | **L-088** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **L-088**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**L-088**) |
| WK-SSP0200-0277 | X-LOC | **L-127·L-128** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **L-127·L-128**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**L-127·L-128**) |
| WK-SSP0200-0278 | X-LOC | AS-IS 정본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS 정본: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS 정본) |
| WK-SSP0200-0279 | X-LOC | EditButton cs:783 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EditButton cs:783: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EditButton cs:783) |
| WK-SSP0200-0280 | X-LOC | L-002·L-003·L-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-002·L-003·L-005: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-002·L-003·L-005) |
| WK-SSP0200-0281 | X-LOC | L-006 ~ L-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-006 ~ L-011: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-006 ~ L-011) |
| WK-SSP0200-0282 | X-LOC | L-014·L-015·**L-126** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-014·L-015·**L-126**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-014·L-015·**L-126**) |
| WK-SSP0200-0283 | X-LOC | L-016 ~ L-019·**L-148** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-016 ~ L-019·**L-148**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-016 ~ L-019·**L-148**) |
| WK-SSP0200-0284 | X-LOC | L-020 ~ L-023·L-024·L-026·**L-078·L-125* | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-020 ~ L-023·L-024·L-026·**L-078·L-125**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-020 ~ L-023·L-024·L-026·**L-078·L-125*) |
| WK-SSP0200-0285 | X-LOC | L-027·L-028·L-030·L-032·L-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-027·L-028·L-030·L-032·L-033: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-027·L-028·L-030·L-032·L-033) |
| WK-SSP0200-0286 | X-LOC | L-035 ~ L-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-035 ~ L-038: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-035 ~ L-038) |
| WK-SSP0200-0287 | X-LOC | L-047 ~ L-049·L-053 ~ L-056 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-047 ~ L-049·L-053 ~ L-056: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-047 ~ L-049·L-053 ~ L-056) |
| WK-SSP0200-0288 | X-LOC | L-051·L-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-051·L-052: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-051·L-052) |
| WK-SSP0200-0289 | X-LOC | L-057 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-057: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-057) |
| WK-SSP0200-0290 | X-LOC | L-058 ~ L-060 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-058 ~ L-060: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-058 ~ L-060) |
| WK-SSP0200-0291 | X-LOC | L-062·L-063 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-062·L-063: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-062·L-063) |
| WK-SSP0200-0292 | X-LOC | L-072 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-072: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-072) |
| WK-SSP0200-0293 | X-LOC | L-073 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-073: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-073) |
| WK-SSP0200-0294 | X-LOC | L-075·L-076 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-075·L-076: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-075·L-076) |
| WK-SSP0200-0295 | X-LOC | L-079·L-082·L-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-079·L-082·L-102: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-079·L-082·L-102) |
| WK-SSP0200-0296 | X-LOC | L-081 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-081: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-081) |
| WK-SSP0200-0297 | X-LOC | L-083·L-089 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-083·L-089: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-083·L-089) |
| WK-SSP0200-0298 | X-LOC | L-087 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-087: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-087) |
| WK-SSP0200-0299 | X-LOC | L-090 ~ L-121 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-090 ~ L-121: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-090 ~ L-121) |
| WK-SSP0200-0300 | X-LOC | L-122 ~ L-124 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-122 ~ L-124: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-122 ~ L-124) |
| WK-SSP0200-0301 | X-LOC | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00002: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00002) |
| WK-SSP0200-0302 | X-LOC | MSG00012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00012: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00012) |
| WK-SSP0200-0303 | X-LOC | MSG00097 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00097: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00097) |
| WK-SSP0200-0304 | X-LOC | MSG00133 / MSG00328 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00133 / MSG00328: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00133 / MSG00328) |
| WK-SSP0200-0305 | X-LOC | MSG00174 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00174: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00174) |
| WK-SSP0200-0306 | X-LOC | MSG00189 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00189: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00189) |
| WK-SSP0200-0307 | X-LOC | MSG00195 / MSG00267 / MSG00173 / MSG0024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00195 / MSG00267 / MSG00173 / MSG00249 / MSG000: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0308 | X-LOC | MSG00248 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00248: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00248) |
| WK-SSP0200-0309 | X-LOC | MSG00284 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00284: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00284) |
| WK-SSP0200-0310 | X-LOC | MSG00293 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00293: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00293) |
| WK-SSP0200-0311 | X-LOC | R-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-12) |
| WK-SSP0200-0312 | X-LOC | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-13) |
| WK-SSP0200-0313 | X-LOC | R-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-14) |
| WK-SSP0200-0314 | X-LOC | R-15·R-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-15·R-16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-15·R-16) |
| WK-SSP0200-0315 | X-LOC | R-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-17: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-17) |
| WK-SSP0200-0316 | X-LOC | R-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-18: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-18) |
| WK-SSP0200-0317 | X-LOC | R-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-19: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-19) |
| WK-SSP0200-0318 | X-LOC | R-20·R-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-20·R-21: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-20·R-21) |
| WK-SSP0200-0319 | X-LOC | R-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-22: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-22) |
| WK-SSP0200-0320 | X-LOC | R-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-24: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-24) |
| WK-SSP0200-0321 | X-LOC | R-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-25: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-25) |
| WK-SSP0200-0322 | X-LOC | R-26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-26: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-26) |
| WK-SSP0200-0323 | X-LOC | R-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-27: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-27) |
| WK-SSP0200-0324 | X-LOC | R-28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-28: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-28) |
| WK-SSP0200-0325 | X-LOC | R-29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-29: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-29) |
| WK-SSP0200-0326 | X-LOC | R-31② | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-31②: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-31②) |
| WK-SSP0200-0327 | X-LOC | R-31③④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-31③④: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-31③④) |
| WK-SSP0200-0328 | X-LOC | R-31⑥⑦ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-31⑥⑦: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-31⑥⑦) |
| WK-SSP0200-0329 | X-LOC | R-40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-40: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-40) |
| WK-SSP0200-0330 | X-LOC | R-41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-41: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-41) |
| WK-SSP0200-0331 | X-LOC | R-50 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-50: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-50) |
| WK-SSP0200-0332 | X-LOC | R-51 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-51: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-51) |
| WK-SSP0200-0333 | X-LOC | R-52 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-52: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-52) |
| WK-SSP0200-0334 | X-LOC | R-60 C10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-60 C10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-60 C10) |
| WK-SSP0200-0335 | X-LOC | R-70 D10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-70 D10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-70 D10) |
| WK-SSP0200-0336 | X-LOC | R-70 D11~D16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-70 D11~D16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0337 | X-LOC | R-70 D1·D2·D4·D5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-70 D1·D2·D4·D5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-70 D1·D2·D4·D5) |
| WK-SSP0200-0338 | X-LOC | R-70 D9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-70 D9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-70 D9) |
| WK-SSP0200-0339 | X-LOC | TO-BE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TO-BE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TO-BE) |
| WK-SSP0200-0340 | X-LOC | `Confirmed` / `Change` / `Shipment Plan  | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `Confirmed` / `Change` / `Shipment Plan Qty` / `Sh: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`Confirmed` / `Change` / `Shipment Plan ) |
| WK-SSP0200-0341 | X-LOC | 설계 정본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 설계 정본: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (설계 정본) |
| WK-SSP0200-0342 | X-LOC | 자매 주의 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 자매 주의: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (자매 주의) |
| WK-SSP0200-0343 | X-LOC | 폐기 입력 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 폐기 입력: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (폐기 입력) |
| WK-SSP0200-0344 | X-LOC | 화면코드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 화면코드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (화면코드) |
| WK-SSP0200-0345 | X-ROW | SSP0200_ShipmentChangeRequest.ClearReque | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.ClearRequestInfo: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG/VALUE_CLEAR/VALUE_SET, 연결된 요소  |  | 10 (ACT:SSP0200_ShipmentChangeRequest.ClearR) |
| WK-SSP0200-0346 | M4 | Item | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — Item: 검증 엔진이 실행됐으나 이 대상(POPUP Item)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 19 (Model 팝업 R-52 ACT:SSP0200_ShipmentChange) |

## W8 구현 후 검증 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0347 | B3 | L-151 | 선행 W1 완료 후 E2E | B3 — 대조표 미구현 행 L-151 구현 후 검증 · 대상 L-151 |  | 1 (L-151) |
| WK-SSP0200-0348 | B4 | L-151 | 선행 W1 완료 후 E2E | B4 — 대조표 미구현 행 L-151 구현 후 검증 · 대상 L-151 |  | 1 (L-151) |
| WK-SSP0200-0349 | A5 | R-31① | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-31① 구현 후 검증 · 대상 R-31① |  | 1 (R-31①) |
| WK-SSP0200-0350 | A5 | R-60 C12·C13 | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-60 C12·C13 구현 후 검증 · 대상 R-60 C12·C13 |  | 1 (R-60 C12·C13) |
| WK-SSP0200-0351 | A5 | R-60 C7~C9 | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-60 C7~C9 구현 후 검증 · 대상 R-60 C7~C9 |  | 1 (R-60 C7~C9) |
| WK-SSP0200-0352 | A5 | R-70 D18 | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-70 D18 구현 후 검증 · 대상 R-70 D18 |  | 1 (R-70 D18) |
| WK-SSP0200-0353 | A5 | R-70 D3·D6 | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-70 D3·D6 구현 후 검증 · 대상 R-70 D3·D6 |  | 1 (R-70 D3·D6) |
| WK-SSP0200-0354 | G4 | **C4** | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 **C4** 구현 후 검증 · 대상 **C4** |  | 1 (**C4**) |
| WK-SSP0200-0355 | H2 | R-31① | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-31① 구현 후 검증 · 대상 R-31① |  | 1 (R-31①) |
| WK-SSP0200-0356 | H2 | R-60 C12·C13 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-60 C12·C13 구현 후 검증 · 대상 R-60 C12·C13 |  | 1 (R-60 C12·C13) |
| WK-SSP0200-0357 | H2 | R-60 C7~C9 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-60 C7~C9 구현 후 검증 · 대상 R-60 C7~C9 |  | 1 (R-60 C7~C9) |
| WK-SSP0200-0358 | H2 | R-70 D18 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-70 D18 구현 후 검증 · 대상 R-70 D18 |  | 1 (R-70 D18) |
| WK-SSP0200-0359 | H2 | R-70 D3·D6 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-70 D3·D6 구현 후 검증 · 대상 R-70 D3·D6 |  | 1 (R-70 D3·D6) |
| WK-SSP0200-0360 | H3 | **L-065·L-070·L-071** | 선행 W1 완료 후 E2E | H3 — 대조표 미구현 행 **L-065·L-070·L-071** 구현 후 검증 · 대상 **L-065·L-070·L-071** |  | 1 (**L-065·L-070·L-071**) |
| WK-SSP0200-0361 | H5 | R-31① | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-31① 구현 후 검증 · 대상 R-31① |  | 1 (R-31①) |
| WK-SSP0200-0362 | H5 | R-60 C12·C13 | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-60 C12·C13 구현 후 검증 · 대상 R-60 C12·C13 |  | 1 (R-60 C12·C13) |
| WK-SSP0200-0363 | H5 | R-60 C7~C9 | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-60 C7~C9 구현 후 검증 · 대상 R-60 C7~C9 |  | 1 (R-60 C7~C9) |
| WK-SSP0200-0364 | H5 | R-70 D18 | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-70 D18 구현 후 검증 · 대상 R-70 D18 |  | 1 (R-70 D18) |
| WK-SSP0200-0365 | H5 | R-70 D3·D6 | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-70 D3·D6 구현 후 검증 · 대상 R-70 D3·D6 |  | 1 (R-70 D3·D6) |
| WK-SSP0200-0366 | D4 | **C4** | 선행 W1 완료 후 E2E | D4 — 대조표 미구현 행 **C4** 구현 후 검증 · 대상 **C4** |  | 1 (**C4**) |
| WK-SSP0200-0367 | G1 | **C4** | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 **C4** 구현 후 검증 · 대상 **C4** |  | 1 (**C4**) |
| WK-SSP0200-0368 | X-ROW | L-066 ~ L-069 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 L-066 ~ L-069 구현 후 검증 · 대상 L-066 ~ L-069 |  | 1 (L-066 ~ L-069) |

## W9 도구 오류 (511)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0369 | J2 | SSP0200 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-70aace54 RULE_SCREEN / 원장 V-45a35f4b DEFECT / 원장 V-d2bb599e GENERAL / 원장 V-7139355a GENERAL / 원장 V-9c59e407 GENERA |  | 192 (설계 정본 L-016 ~ L-019·**L-148** TO-BE 추가(2) |
| WK-SSP0200-0370 | C2 | A_COUNTRY / A Country | 하네스·환경 | C2 도구 오류 — 실측[T-cac93043]: A_COUNTRY 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0371 | C2 | A_PORT_CODE / A Port | 하네스·환경 | C2 도구 오류 — 실측[T-8fa449df]: A_PORT_CODE 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) /  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0372 | C2 | BOD_ID / bod_id | 하네스·환경 | C2 도구 오류 — 실측[T-21cb405e]: BOD_ID 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 9 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0373 | C2 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C2 도구 오류 — 실측[T-30b56e16]: CHANGE_REASON_CODE 연쇄 원천 해석 불가 — AS-IS SpdMain_ComboSelChange:5861 siMain.GetColumnIndex(DefColumns.CHA |  | 24 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0374 | C2 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C2 도구 오류 — 실측[T-9b5b74e0]: 원천 CHANGE_REASON_CODE 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [ |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0375 | C2 | DIVISION_ID | 하네스·환경 | C2 도구 오류 — 원장 V-20fd07a2 / 실측[T-63b91c48]: 신규행 DIVISION_ID 후보 14 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0376 | C2 | DIVISION_ID | 하네스·환경 | C2 도구 오류 — 원장 V-13bac30a / 실측[T-4d07bca0]: 신규행 DIVISION_ID 후보 14 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0377 | C2 | DIVISION_ID | 하네스·환경 | C2 도구 오류 — 원장 V-cb9b9247 / 실측[T-1010119a]: 신규행 DIVISION_ID 후보 14 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0378 | C2 | DIVISION_ID | 하네스·환경 | C2 도구 오류 — 원장 V-a40208c5 / 실측[T-5ee3d6c4]: 신규행 DIVISION_ID 후보 14 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0379 | C2 | DIVISION_ID / Div | 하네스·환경 | C2 도구 오류 — 원장 V-20fd07a2 ASIS / 원장 V-13bac30a ASIS / 원장 V-cb9b9247 ASIS / 원장 V-a40208c5 ASIS / 원장 V-b77c5c94 ASIS / 원장 V-117f1170  |  | 36 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0380 | C2 | D_COUNTRY / D Country | 하네스·환경 | C2 도구 오류 — 실측[T-9f72a769]: D_COUNTRY 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0381 | C2 | D_PORT_CODE / D Port | 하네스·환경 | C2 도구 오류 — 실측[T-d0a42179]: D_PORT_CODE 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) /  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0382 | C2 | EDIT_MAIN | 하네스·환경 | C2 도구 오류 — 실측[T-578ab1ca]: 원천 TRANSPORT_MODE 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0383 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-c2c25664 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.setEnd) |
| WK-SSP0200-0384 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-31fefd89 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.setEnd) |
| WK-SSP0200-0385 | C2 | END_CUSTOMER / End Customer | 하네스·환경 | C2 도구 오류 — 원장 V-c2c25664 ASIS / 원장 V-31fefd89 ASIS |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0386 | C2 | ERP_SO_NO / SO No | 하네스·환경 | C2 도구 오류 — 실측[T-1c035f5b]: 원천 TRANSPORT_MODE 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0387 | C2 | FCST_TYPE / FCST Type | 하네스·환경 | C2 도구 오류 — 실측[T-9f7ce835]: 원천 DIVISION_ID 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0388 | C2 | FROM_SITE / From Site ID | 하네스·환경 | C2 도구 오류 — 실측[T-5dfee732]: FROM_SITE 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 1 (R-14) |
| WK-SSP0200-0389 | C2 | FROM_SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-c38ae6fa |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0390 | C2 | FROM_SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-7ebfd9d1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0391 | C2 | FROM_SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-72a2f485 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0392 | C2 | FROM_SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-b77c5c94 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0393 | C2 | FROM_SITE_DESCRIPTION / From Site | 하네스·환경 | C2 도구 오류 — 원장 V-c38ae6fa ASIS / 원장 V-7ebfd9d1 ASIS / 원장 V-72a2f485 ASIS / 원장 V-75c12875 ASIS / 원장 V-b77c5c94 ASIS / 실측[T-c3e2917a] |  | 29 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0394 | C2 | INCOTERMS / Incoterms | 하네스·환경 | C2 도구 오류 — 원장 V-75c12875 ASIS / 실측[T-24f7f6f4]: FROM_SITE_DESCRIPTION='AZ Mobile Assy-Cell' → INCOTERMS 후보 16건 · FROM_SITE_DESCRIP |  | 35 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0395 | C2 | ITEM_ID / Model | 하네스·환경 | C2 도구 오류 — 원장 V-75c12875 ASIS / 실측[T-bd0820a6]: ITEM_ID 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0396 | C2 | NEW_ROUTE_ID / Route | 하네스·환경 | C2 도구 오류 — 실측[T-fa0eab17]: 원천 TRANSPORT_MODE 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0397 | C2 | NICK_NAME / Nick Name | 하네스·환경 | C2 도구 오류 — 실측[T-666f8007]: 원천 DIVISION_ID 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0398 | C2 | PROJECT_CODE / Project Code | 하네스·환경 | C2 도구 오류 — 원장 V-75c12875 ASIS |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0399 | C2 | PROJECT_NAME / Project Name | 하네스·환경 | C2 도구 오류 — 실측[T-3d37df41]: 원천 DIVISION_ID 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0400 | C2 | ROUTE_ID / Route | 하네스·환경 | C2 도구 오류 — 실측[T-a54fdb30]: ROUTE_ID 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0401 | C2 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | C2 도구 오류 — 실측[T-36045c45]: 원천 TRANSPORT_MODE 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0402 | C2 | SSP0200_ShipmentChangeRequest.CboChangeT | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.CboChangeType_SelectedIndexChanged 의 C2 43요소: ERROR:41 · NA:2 |  | 16 (ACT:SSP0200_ShipmentChangeRequest.CboCha) |
| WK-SSP0200-0403 | C2 | SSP0200_ShipmentChangeRequest.SpdMain_Cu | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.SpdMain_CursorChanged 의 C2 43요소: ERROR:41 · NA:2 |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0404 | C2 | SSP0200_ShipmentChangeRequest.clbDivisio | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.clbDivision_ID_SelectedIndexChanged 의 C2 43요소: ERROR:41 · NA:2 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.clbDiv) |
| WK-SSP0200-0405 | C2 | TO_SITE / To Site ID | 하네스·환경 | C2 도구 오류 — 실측[T-48d92652]: TO_SITE 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증 |  | 1 (R-14) |
| WK-SSP0200-0406 | C2 | TO_SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-e56e9638 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0407 | C2 | TO_SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-996587ad |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0408 | C2 | TO_SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-6bcf06e3 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0409 | C2 | TO_SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-117f1170 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0410 | C2 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | C2 도구 오류 — 원장 V-e56e9638 ASIS / 원장 V-996587ad ASIS / 원장 V-6bcf06e3 ASIS / 원장 V-75c12875 ASIS / 원장 V-117f1170 ASIS |  | 22 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0411 | C2 | TRANSPORT_MODE | 하네스·환경 | C2 도구 오류 — 원장 V-42a02278 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0412 | C2 | TRANSPORT_MODE | 하네스·환경 | C2 도구 오류 — 원장 V-75c12875 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0413 | C2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C2 도구 오류 — 원장 V-42a02278 ASIS / 원장 V-75c12875 ASIS / 실측[T-2cea720e]: FROM_SITE_DESCRIPTION='AZ Mobile Assy-Cell' → TRANSPORT_MODE  |  | 70 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0414 | C3 | A_COUNTRY / A Country | 하네스·환경 | C3 도구 오류 — 실측[T-3b64a59f]: A_COUNTRY 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0415 | C3 | A_PORT_CODE / A Port | 하네스·환경 | C3 도구 오류 — 실측[T-43c9ee80]: A_PORT_CODE 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0416 | C3 | BOD_ID / bod_id | 하네스·환경 | C3 도구 오류 — 실측[T-fa3114d8]: BOD_ID: 원천 FROM_SITE_DESCRIPTION/TO_SITE_DESCRIPTION/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 |  | 10 (R-14 ACT:SSP0200_ShipmentChangeRequest.F) |
| WK-SSP0200-0417 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-814062a3 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0418 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-84296472 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0419 | C3 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C3 도구 오류 — 원장 V-8ab89bd7 ASIS / 원장 V-9dd0c6f8 ASIS / 원장 V-814062a3 ASIS / 원장 V-b17d7afa ASIS / 원장 V-84296472 ASIS / 원장 V-8ef749a6  |  | 28 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0420 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-8ef749a6 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0421 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-962610f9 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0422 | C3 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C3 도구 오류 — 원장 V-8ef749a6 ASIS / 원장 V-018c9693 ASIS / 원장 V-962610f9 ASIS / 원장 V-1ae2810a ASIS |  | 11 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0423 | C3 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | C3 도구 오류 — 실측[T-09a8e000]: CHANGE_REQ_NO 연쇄 원천 컬럼 해석 불가 — AS-IS SetMainStatus:3015 siMain.GetValue(iSelRow, siMain.GetColumnIndex( |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0424 | C3 | CONFIRM_ID / Confirm/Plan ID | 하네스·환경 | C3 도구 오류 — 실측[T-d6015105]: CONFIRM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS InitSpread:608 spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefC |  | 10 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0425 | C3 | DIVISION_ID / Div | 하네스·환경 | C3 도구 오류 — 원장 V-f218a18c ASIS / 실측[T-0e10e33f]: DIVISION_ID 연쇄 원천 컬럼 해석 불가 — AS-IS BtnNew_Click:3383 siMain.SetValue(insCell, siMa |  | 43 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0426 | C3 | D_COUNTRY / D Country | 하네스·환경 | C3 도구 오류 — 실측[T-75cdab5a]: D_COUNTRY 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0427 | C3 | D_PORT_CODE / D Port | 하네스·환경 | C3 도구 오류 — 실측[T-3f445688]: D_PORT_CODE 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0428 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-a7bef1c3 ASIS / 원장 V-afae9d8d ASIS / 원장 V-8ab89bd7 ASIS / 원장 V-9dd0c6f8 ASIS / 원장 V-b17d7afa ASIS / 원장 V-de92d0d5  |  | 20 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0429 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-8ab89bd7 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0430 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-9dd0c6f8 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0431 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-b17d7afa |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0432 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-de92d0d5 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0433 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-14feab86 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0434 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-9c4ab260 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0435 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-018c9693 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0436 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-1ae2810a |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0437 | C3 | END_CUSTOMER / End Customer | 하네스·환경 | C3 도구 오류 — 실측[T-aa39717f]: END_CUSTOMER: 원천 DIVISION_ID/ITEM_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 |  | 16 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0438 | C3 | FCST_TYPE / FCST Type | 하네스·환경 | C3 도구 오류 — 실측[T-39a9e7e7]: FCST_TYPE 연쇄 프로브 불가 — 원천 DIVISION_ID 신규행 편집 불가(팝업 전용 셀이면 M4 에서 판정) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0439 | C3 | FROM_SITE / From Site ID | 하네스·환경 | C3 도구 오류 — 실측[T-5d70e8f1]: FROM_SITE 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (R-14) |
| WK-SSP0200-0440 | C3 | FROM_SITE_DESCRIPTION / From Site | 하네스·환경 | C3 도구 오류 — 실측[T-dc8c9ef7]: FROM_SITE_DESCRIPTION 연쇄 프로브 불가 — 원천 DIVISION_ID 신규행 편집 불가(팝업 전용 셀이면 M4 에서 판정) — 검사기가 원천 셀을 열 수 없어 측정하지 |  | 31 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0441 | C3 | INCOTERMS / Incoterms | 하네스·환경 | C3 도구 오류 — 실측[T-aadf7188]: INCOTERMS: 원천 FROM_SITE_DESCRIPTION/TO_SITE_DESCRIPTION/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업  |  | 35 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0442 | C3 | ITEM_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-2c6291b7]: ITEM_ID 연쇄 프로브 불가 — 원천 DIVISION_ID 신규행 편집 불가(팝업 전용 셀이면 M4 에서 판정) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화 |  | 19 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0443 | C3 | NEW_ETA | 하네스·환경 | C3 도구 오류 — 원장 V-e2a9300b |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0444 | C3 | NEW_ETA | 하네스·환경 | C3 도구 오류 — 원장 V-894a7e51 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0445 | C3 | NEW_ETA / ETA | 하네스·환경 | C3 도구 오류 — 원장 V-e2a9300b ASIS / 원장 V-894a7e51 ASIS |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0446 | C3 | NEW_ETD | 하네스·환경 | C3 도구 오류 — 원장 V-eb32467a |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0447 | C3 | NEW_ETD | 하네스·환경 | C3 도구 오류 — 원장 V-2b8cf565 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0448 | C3 | NEW_ETD / ETD | 하네스·환경 | C3 도구 오류 — 원장 V-eb32467a ASIS / 원장 V-2b8cf565 ASIS |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0449 | C3 | NEW_ROUTE_ID / Route | 하네스·환경 | C3 도구 오류 — 실측[T-879f0f65]: NEW_ROUTE_ID: 원천 TRANSPORT_MODE 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0450 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-470584a4 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0451 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-638b2996 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0452 | C3 | NEW_SHIPMENT_DATE / Shipment Date | 하네스·환경 | C3 도구 오류 — 원장 V-470584a4 ASIS / 원장 V-638b2996 ASIS |  | 11 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0453 | C3 | NICK_NAME / Nick Name | 하네스·환경 | C3 도구 오류 — 실측[T-888470dc]: NICK_NAME: 원천 ITEM_ID/DIVISION_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0454 | C3 | PROJECT_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-f218a18c |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0455 | C3 | PROJECT_CODE / Project Code | 하네스·환경 | C3 도구 오류 — 원장 V-f218a18c ASIS |  | 15 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0456 | C3 | REQUEST_USER | 하네스·환경 | C3 도구 오류 — 실측[T-f7c64c21]: REQUEST_USER 연쇄 원천 컬럼 해석 불가 — AS-IS SetMainStatus:3033 if (txtRequestNo.Text == sChkRequestNo) { siMain |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0457 | C3 | REQUEST_USER_NAME | 하네스·환경 | C3 도구 오류 — 실측[T-e3c4c175]: REQUEST_USER_NAME 연쇄 원천 컬럼 해석 불가 — AS-IS SetMainStatus:3037 siMain.SetValue(iRow, siMain.GetColumnIndex |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0458 | C3 | ROUTE_ID / Route | 하네스·환경 | C3 도구 오류 — 실측[T-8a920694]: ROUTE_ID 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0459 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-e4d803b8 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0460 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-16093f7d |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0461 | C3 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | C3 도구 오류 — 원장 V-eb32467a ASIS / 원장 V-e2a9300b ASIS / 원장 V-e4d803b8 ASIS / 원장 V-470584a4 ASIS / 원장 V-14feab86 ASIS / 원장 V-16093f7d  |  | 21 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0462 | C3 | SHIPMENT_STATUS / Status | 하네스·환경 | C3 도구 오류 — 실측[T-10c82f22]: SHIPMENT_STATUS 연쇄 원천 컬럼 해석 불가 — AS-IS SetMainStatus:3017 for (int iRow = 0; iRow < siMain.ActiveSheet. |  | 14 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0463 | C3 | SSP0200_ShipmentChangeRequest.CboChangeT | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.CboChangeType_SelectedIndexChanged 의 C3 71요소: ERROR:55 · NA:14 · PASS:2 |  | 16 (ACT:SSP0200_ShipmentChangeRequest.CboCha) |
| WK-SSP0200-0464 | C3 | SSP0200_ShipmentChangeRequest.SetChangeC | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.SetChangeControl 의 C3 1요소: ERROR:1 |  | 9 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0465 | C3 | SSP0200_ShipmentChangeRequest.SetChangeR | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.SetChangeRequestInfo 의 C3 5요소: ERROR:5 |  | 11 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0466 | C3 | SSP0200_ShipmentChangeRequest.SetChanged | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.SetChangedControl 의 C3 71요소: ERROR:55 · NA:14 · PASS:2 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0467 | C3 | SSP0200_ShipmentChangeRequest.SpdMain_Cu | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.SpdMain_CursorChanged 의 C3 71요소: ERROR:55 · NA:14 · PASS:2 |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0468 | C3 | SSP0200_ShipmentChangeRequest.clbDivisio | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.clbDivision_ID_SelectedIndexChanged 의 C3 71요소: ERROR:55 · NA:14 · PASS:2 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.clbDiv) |
| WK-SSP0200-0469 | C3 | SSP0200_ShipmentChangeRequest.setEndCust | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.setEndCustomer 의 C3 4요소: ERROR:4 |  | 9 (ACT:SSP0200_ShipmentChangeRequest.setEnd) |
| WK-SSP0200-0470 | C3 | TO_CITY / To City | 하네스·환경 | C3 도구 오류 — 실측[T-759d80cd]: [전제 미충족 T300] TO_CITY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0471 | C3 | TO_COUNTRY / To Country | 하네스·환경 | C3 도구 오류 — 실측[T-1944fdad]: [전제 미충족 T300] TO_COUNTRY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0472 | C3 | TO_SITE / To Site ID | 하네스·환경 | C3 도구 오류 — 실측[T-2d2ee10c]: TO_SITE 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (R-14) |
| WK-SSP0200-0473 | C3 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | C3 도구 오류 — 실측[T-1cfa3893]: TO_SITE_DESCRIPTION 연쇄 프로브 불가 — 원천 DIVISION_ID 신규행 편집 불가(팝업 전용 셀이면 M4 에서 판정) — 검사기가 원천 셀을 열 수 없어 측정하지 못 |  | 26 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0474 | C3 | TRANSPORT_MODE | 하네스·환경 | C3 도구 오류 — 원장 V-b92b9cdb |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0475 | C3 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C3 도구 오류 — 원장 V-a7bef1c3 ASIS / 원장 V-b92b9cdb ASIS / 원장 V-afae9d8d ASIS / 원장 V-8ab89bd7 ASIS / 원장 V-9dd0c6f8 ASIS / 원장 V-814062a3  |  | 73 (R-14 ACT:SSP0200_ShipmentChangeRequest.F) |
| WK-SSP0200-0476 | C6 | A_COUNTRY / A Country | 하네스·환경 | C6 도구 오류 — 실측[T-38bbc589]: A_COUNTRY 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_ |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0477 | C6 | A_PORT_CODE / A Port | 하네스·환경 | C6 도구 오류 — 실측[T-4e3b5e6b]: A_PORT_CODE 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0478 | C6 | BOD_ID | 하네스·환경 | C6 도구 오류 — 원장 V-9315dadb |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0479 | C6 | BOD_ID | 하네스·환경 | C6 도구 오류 — 원장 V-d06c67de |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0480 | C6 | BOD_ID | 하네스·환경 | C6 도구 오류 — 원장 V-0f71e882 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0481 | C6 | BOD_ID | 하네스·환경 | C6 도구 오류 — 원장 V-3b2492c3 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0482 | C6 | BOD_ID | 하네스·환경 | C6 도구 오류 — 원장 V-c748f36e |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0483 | C6 | BOD_ID | 하네스·환경 | C6 도구 오류 — 원장 V-7d3f8e5a |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0484 | C6 | BOD_ID / bod_id | 하네스·환경 | C6 도구 오류 — 원장 V-9315dadb ASIS / 원장 V-d06c67de ASIS / 원장 V-0f71e882 ASIS / 원장 V-3b2492c3 ASIS / 원장 V-c748f36e ASIS / 원장 V-7d3f8e5a  |  | 9 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0485 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-d4f8b4b6 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0486 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-2d8676ab |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0487 | C6 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C6 도구 오류 — 원장 V-8474364c ASIS / 원장 V-fd8c25b0 ASIS / 원장 V-1e31de43 ASIS / 원장 V-d4f8b4b6 ASIS / 원장 V-dc477502 ASIS / 원장 V-57901d13  |  | 24 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0488 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-fd8c25b0 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0489 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-dc477502 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0490 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-c398ae21 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0491 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-f665acaf |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0492 | C6 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C6 도구 오류 — 원장 V-fd8c25b0 ASIS / 원장 V-dc477502 ASIS / 원장 V-c398ae21 ASIS / 원장 V-7e2c4c62 ASIS / 원장 V-f665acaf ASIS / 원장 V-15b13681  |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0493 | C6 | DIVISION_ID / Div | 하네스·환경 | C6 도구 오류 — 원장 V-1acb9cbf ASIS / 원장 V-f92a114b ASIS / 원장 V-0a60efdb ASIS / 원장 V-2981804a ASIS / 원장 V-54ad3b11 ASIS / 원장 V-3cc29827  |  | 36 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0494 | C6 | D_COUNTRY / D Country | 하네스·환경 | C6 도구 오류 — 실측[T-72ad9484]: D_COUNTRY 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_ |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0495 | C6 | D_PORT_CODE / D Port | 하네스·환경 | C6 도구 오류 — 실측[T-ad994974]: D_PORT_CODE 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0496 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-c1e83f16 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0497 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-c1e83f16 ASIS / 원장 V-bc8e042e ASIS / 원장 V-8474364c ASIS / 원장 V-1e31de43 ASIS / 원장 V-57901d13 ASIS / 원장 V-45003598  |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0498 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-bc8e042e |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0499 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-8474364c |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0500 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-1e31de43 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0501 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-57901d13 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0502 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-45003598 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0503 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-d4b69ed7 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0504 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-afeaaf0f |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0505 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-7e2c4c62 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0506 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-15b13681 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0507 | C6 | END_CUSTOMER | 하네스·환경 | C6 도구 오류 — 원장 V-3cc29827 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0508 | C6 | END_CUSTOMER / End Customer | 하네스·환경 | C6 도구 오류 — 원장 V-3cc29827 ASIS |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0509 | C6 | ERP_SO_NO / SO No | 하네스·환경 | C6 도구 오류 — 실측[T-590d9a7d]: 원천 TRANSPORT_MODE 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0510 | C6 | FCST_TYPE | 하네스·환경 | C6 도구 오류 — 원장 V-982e8a1b |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0511 | C6 | FCST_TYPE / FCST Type | 하네스·환경 | C6 도구 오류 — 원장 V-982e8a1b ASIS |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0512 | C6 | FROM_SITE / From Site ID | 하네스·환경 | C6 도구 오류 — 실측[T-dd662a56]: FROM_SITE 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_ |  | 1 (R-14) |
| WK-SSP0200-0513 | C6 | FROM_SITE_DESCRIPTION | 하네스·환경 | C6 도구 오류 — 원장 V-1acb9cbf |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0514 | C6 | FROM_SITE_DESCRIPTION / From Site | 하네스·환경 | C6 도구 오류 — 원장 V-216a2c84 ASIS / 원장 V-f627ce0d ASIS / 원장 V-9315dadb ASIS / 원장 V-693bb09c ASIS / 원장 V-e143a4b0 ASIS / 원장 V-d06c67de  |  | 29 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0515 | C6 | INCOTERMS | 하네스·환경 | C6 도구 오류 — 원장 V-216a2c84 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0516 | C6 | INCOTERMS | 하네스·환경 | C6 도구 오류 — 원장 V-693bb09c |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0517 | C6 | INCOTERMS | 하네스·환경 | C6 도구 오류 — 원장 V-286a36a5 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0518 | C6 | INCOTERMS | 하네스·환경 | C6 도구 오류 — 원장 V-ab17525f |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0519 | C6 | INCOTERMS | 하네스·환경 | C6 도구 오류 — 원장 V-3ccb6389 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0520 | C6 | INCOTERMS | 하네스·환경 | C6 도구 오류 — 원장 V-265d5405 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0521 | C6 | INCOTERMS | 하네스·환경 | C6 도구 오류 — 원장 V-efbd780a |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0522 | C6 | INCOTERMS / Incoterms | 하네스·환경 | C6 도구 오류 — 원장 V-216a2c84 ASIS / 원장 V-693bb09c ASIS / 원장 V-286a36a5 ASIS / 원장 V-ab17525f ASIS / 원장 V-3ccb6389 ASIS / 원장 V-265d5405  |  | 35 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0523 | C6 | ITEM_ID | 하네스·환경 | C6 도구 오류 — 원장 V-0a60efdb |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0524 | C6 | ITEM_ID / Model | 하네스·환경 | C6 도구 오류 — 원장 V-0a60efdb ASIS / 원장 V-efbd780a ASIS / 실측[T-d420f964]: FROM_SITE_DESCRIPTION 셀 위치 확인 불가 |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0525 | C6 | NEW_ETA | 하네스·환경 | C6 도구 오류 — 원장 V-b5a183e5 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0526 | C6 | NEW_ETA | 하네스·환경 | C6 도구 오류 — 원장 V-8782e281 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0527 | C6 | NEW_ETD | 하네스·환경 | C6 도구 오류 — 원장 V-8b2ec1b1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0528 | C6 | NEW_ETD | 하네스·환경 | C6 도구 오류 — 원장 V-bf494048 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0529 | C6 | NEW_ROUTE_ID / Route | 하네스·환경 | C6 도구 오류 — 실측[T-bcaf9c41]: 원천 TRANSPORT_MODE 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0530 | C6 | NEW_SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-d0859428 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0531 | C6 | NEW_SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-d6a0e4b2 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0532 | C6 | NICK_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-2981804a |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0533 | C6 | NICK_NAME / Nick Name | 하네스·환경 | C6 도구 오류 — 원장 V-2981804a ASIS |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0534 | C6 | PROJECT_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-54ad3b11 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0535 | C6 | PROJECT_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-d466c9ff |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0536 | C6 | PROJECT_CODE / Project Code | 하네스·환경 | C6 도구 오류 — 원장 V-54ad3b11 ASIS / 원장 V-d466c9ff ASIS |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0537 | C6 | PROJECT_NAME / Project Name | 하네스·환경 | C6 도구 오류 — 실측[T-3bddfd70]: 원천 DIVISION_ID 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0538 | C6 | ROUTE_ID / Route | 하네스·환경 | C6 도구 오류 — 실측[T-f7ea905e]: ROUTE_ID 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_v |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0539 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-f9252c6a |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0540 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-ca65d335 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0541 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-487fc283 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0542 | C6 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | C6 도구 오류 — 원장 V-15b35f20 ASIS / 원장 V-c748f36e ASIS / 원장 V-f9252c6a ASIS / 원장 V-8b2ec1b1 ASIS / 원장 V-b5a183e5 ASIS / 원장 V-ca65d335  |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0543 | C6 | SSP0200_ShipmentChangeRequest.CboChangeT | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.CboChangeType_SelectedIndexChanged 의 C6 80요소: ERROR:78 · NA:2 |  | 16 (ACT:SSP0200_ShipmentChangeRequest.CboCha) |
| WK-SSP0200-0544 | C6 | SSP0200_ShipmentChangeRequest.SpdMain_Cu | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.SpdMain_CursorChanged 의 C6 80요소: ERROR:78 · NA:2 |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0545 | C6 | SSP0200_ShipmentChangeRequest.clbDivisio | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.clbDivision_ID_SelectedIndexChanged 의 C6 80요소: ERROR:78 · NA:2 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.clbDiv) |
| WK-SSP0200-0546 | C6 | TO_SITE / To Site ID | 하네스·환경 | C6 도구 오류 — 실측[T-0cbfee12]: TO_SITE 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_ve |  | 1 (R-14) |
| WK-SSP0200-0547 | C6 | TO_SITE_DESCRIPTION | 하네스·환경 | C6 도구 오류 — 원장 V-f92a114b |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0548 | C6 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | C6 도구 오류 — 원장 V-693bb09c ASIS / 원장 V-e143a4b0 ASIS / 원장 V-d06c67de ASIS / 원장 V-f92a114b ASIS / 원장 V-265d5405 ASIS |  | 22 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0549 | C6 | TRANSPORT_MODE | 하네스·환경 | C6 도구 오류 — 원장 V-f627ce0d |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0550 | C6 | TRANSPORT_MODE | 하네스·환경 | C6 도구 오류 — 원장 V-e143a4b0 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0551 | C6 | TRANSPORT_MODE | 하네스·환경 | C6 도구 오류 — 원장 V-0ebd9fb7 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0552 | C6 | TRANSPORT_MODE | 하네스·환경 | C6 도구 오류 — 원장 V-1a48ece3 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0553 | C6 | TRANSPORT_MODE | 하네스·환경 | C6 도구 오류 — 원장 V-15b35f20 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0554 | C6 | TRANSPORT_MODE | 하네스·환경 | C6 도구 오류 — 원장 V-d3e0b15a |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0555 | C6 | TRANSPORT_MODE | 하네스·환경 | C6 도구 오류 — 원장 V-7952f734 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0556 | C6 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C6 도구 오류 — 원장 V-f627ce0d ASIS / 원장 V-e143a4b0 ASIS / 원장 V-0ebd9fb7 ASIS / 원장 V-1a48ece3 ASIS / 원장 V-15b35f20 ASIS / 원장 V-c748f36e  |  | 70 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0557 | B4 | COMMON:UC-05 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 B4 14요소: NA:7 · NOPATH:5 · ERROR:2 |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0558 | B4 | SHIPMENT_STATUS / Status | 하네스·환경 | B4 도구 오류 — 원장 V-7edf74f9 COLUMN |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0559 | B4 | SSP0200_ShipmentChangeRequest.GetDayRang | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetDayRange 의 B4 14요소: NA:7 · NOPATH:5 · ERROR:2 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetDay) |
| WK-SSP0200-0560 | B4 | SSP0200_ShipmentChangeRequest.GetDivisio | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetDivision 의 B4 1요소: ERROR:1 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetDiv) |
| WK-SSP0200-0561 | B4 | SSP0200_ShipmentChangeRequest.GetErpIFCh | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetErpIFCheck 의 B4 14요소: NA:7 · NOPATH:5 · ERROR:2 |  | 24 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0562 | B4 | SSP0200_ShipmentChangeRequest.GetErpIFCh | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetErpIFCheckNew 의 B4 14요소: NA:7 · NOPATH:5 · ERROR:2 |  | 32 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0563 | B4 | SSP0200_ShipmentChangeRequest.GetErpIFSe | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetErpIFSeqMerge 의 B4 14요소: NA:7 · NOPATH:5 · ERROR:2 |  | 8 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0564 | B4 | SSP0200_ShipmentChangeRequest.GetErpSoNo | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetErpSoNoCnt 의 B4 14요소: NA:7 · NOPATH:5 · ERROR:2 |  | 9 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0565 | B4 | SSP0200_ShipmentChangeRequest.GetItemFro | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetItemFromBOD 의 B4 14요소: NA:7 · NOPATH:5 · ERROR:2 |  | 11 (ACT:SSP0200_ShipmentChangeRequest.GetIte) |
| WK-SSP0200-0566 | B4 | SSP0200_ShipmentChangeRequest.GetPlantSi | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetPlantSiteByDivisionEEOperation 의 B4 14요소: NA:7 · NOPATH:5 · ERROR:2 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetPla) |
| WK-SSP0200-0567 | B4 | SSP0200_ShipmentChangeRequest.GetShipmen | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetShipmentPlanPlantSite 의 B4 14요소: NA:7 · NOPATH:5 · ERROR:2 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetShi) |
| WK-SSP0200-0568 | B4 | clbDivision_ID / Div / Division_ID / Div | 하네스·환경 | B4 도구 오류 — 원장 V-ea02097d SEARCH |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0569 | K4 | SSP0200 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-6070219d GENERAL / 원장 V-70dbe688 GENERAL / 원장 V-2b0ce237 GENERAL / 원장 V-5052020d GENERAL / 원장 V-a0a3f0ba GENERAL / |  | 142 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SSP0200-0570 | F1 | SSP0200 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-a4728d6b RULE_SCREEN / 원장 V-481becbb RULE_SCREEN / 원장 V-e985d455 RULE_SCREEN / 원장 V-0faf54fe RULE_SCREEN / 원장 V-ff |  | 368 (L-073 **L-074** L-079·L-082·L-102 L-081 ) |
| WK-SSP0200-0571 | F2 | SSP0200 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-3f2c6384 RULE_SCREEN / 원장 V-19443831 RULE_SCREEN / 원장 V-e2d64066 RULE_SCREEN / 원장 V-fe1168cb GENERAL / 원장 V-dc915f |  | 366 (L-073 L-079·L-082·L-102 L-081 EditButton) |
| WK-SSP0200-0572 | F3 | SSP0200 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-32e5dbbf RULE_SCREEN / 원장 V-699673f4 RULE_SCREEN / 원장 V-264eca82 RULE_SCREEN / 원장 V-10debc47 RULE_SCREEN / 원장 V-17 |  | 14 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0573 | F6 | SSP0200 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-a488de52 RULE_SCREEN / 원장 V-7f5fc752 RULE_SCREEN / 원장 V-6da1fa9b RULE_SCREEN / 원장 V-73a59c47 RULE_SCREEN / 원장 V-25 |  | 350 (`FoxDataRequest("SSP.SSP0200_SAVE_SHIPME) |
| WK-SSP0200-0574 | F4 | **L-152** | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 **L-152** '조회 SP 2번째 커서로 승인자 **빈칸일 때만** 자동채움' 의 F4 16요소: ERROR:5 · REVIEW:4 · NA:4 · PASS:3 · FAIL 요소: SSP02 |  | 1 (**L-152**) |
| WK-SSP0200-0575 | F4 | L-072 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 L-072 '`FindButton` = `FindData_Main(); FindData_Sub_Draf' 의 F4 16요소: ERROR:5 · REVIEW:4 · NA:4 · PASS:3 · F |  | 1 (L-072) |
| WK-SSP0200-0576 | F4 | PKG_SSP0026.P_SSP0026_GET_BOD_ITEM | 하네스·환경 | F4 도구 오류 — 실측[T-3178eefd]: PKG_SSP0026.P_SSP0026_GET_BOD_ITEM: SSP0026/bodItem/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에 |  | 31 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0577 | F4 | PKG_SSP0200.P_SSP0200_GET_CHANGE_REQ_NO | 하네스·환경 | F4 도구 오류 — 실측[T-5d943d98]: PKG_SSP0200.P_SSP0200_GET_CHANGE_REQ_NO: SSP0200/main/GET_CHANGE_REQ_NO — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회  |  | 187 (L-064 ACT:SSP0200_ShipmentChangeRequest.) |
| WK-SSP0200-0578 | F4 | PKG_SSP0200.P_SSP0200_GET_ERP_SO_NO_CNT | 하네스·환경 | F4 도구 오류 — 실측[T-f9c9ab35]: PKG_SSP0200.P_SSP0200_GET_ERP_SO_NO_CNT: SSP0200/main/GET_ERP_SO_NO_CNT — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회  |  | 189 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0579 | F4 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANG | 하네스·환경 | F4 도구 오류 — 실측[T-b3018eed]: PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N: SSP0200/main/SEARCH_NEW — 화면 진입·조회 중 호출 없음(셀 이벤트·팝 |  | 228 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0580 | F4 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_STATU | 하네스·환경 | F4 도구 오류 — 실측[T-464603eb]: PKG_SSP0200.P_SSP0200_GET_SHIPMENT_STATUS: SSP0003/main/SCS_CHECK, SSP0200/main/GET_SHIPMENT_STATUS — 화 |  | 189 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0581 | F4 | R-14 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 R-14 'TO_SITE/FROM_SITE 변경 → `INCOTERMS`/`TRANSPORT_MODE' 의 F4 16요소: ERROR:5 · REVIEW:4 · NA:4 · PASS:3 · FA |  | 1 (R-14) |
| WK-SSP0200-0582 | F4 | R-18 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 R-18 'BOD 0행 처리' 의 F4 16요소: ERROR:5 · REVIEW:4 · NA:4 · PASS:3 · FAIL 요소: SSP0200_GET_SHIPMENT_DIVISION — 실측 |  | 1 (R-18) |
| WK-SSP0200-0583 | F4 | SSP0200_ShipmentChangeRequest.GetErpIFCh | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetErpIFCheckNew 의 F4 16요소: ERROR:5 · REVIEW:4 · NA:4 · PASS:3 · FAIL 요소: SS |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0584 | F4 | SSP0200_ShipmentChangeRequest.GetErpIFSe | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.GetErpIFSeqMerge 의 F4 16요소: ERROR:5 · REVIEW:4 · NA:4 · PASS:3 · FAIL 요소: SS |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0585 | F4 | SSP0200_ShipmentChangeRequestInsertPopup | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequestInsertPopup.SaveData 의 F4 16요소: ERROR:5 · REVIEW:4 · NA:4 · PASS:3 · FAIL 요소: |  | 1 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0586 | F4 | 자동조회 금지 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 자동조회 금지 '`FindData_Main` 은 `FindButton` 에서만' 의 F4 16요소: ERROR:5 · REVIEW:4 · NA:4 · PASS:3 · FAIL 요소: SSP020 |  | 1 (자동조회 금지) |
| WK-SSP0200-0587 | A5 | END_CUSTOMER | 하네스·환경 | A5 도구 오류 — 원장 V-bb6b67d9 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0588 | A5 | END_CUSTOMER | 하네스·환경 | A5 도구 오류 — 원장 V-da7a87a3 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0589 | A5 | END_CUSTOMER / End Customer | 하네스·환경 | A5 도구 오류 — 원장 V-bb6b67d9 ASIS / 원장 V-da7a87a3 ASIS / E2E smoke columns / 실측[T-6dc724ab]: END_CUSTOMER: AS-IS(Div 40) '기본 →표시 →표시?' |  | 4 (R-26 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0590 | A5 | FROM_SITE / From Site ID | 하네스·환경 | A5 도구 오류 — 원장 V-d5c6cdec COLUMN / E2E smoke columns / 실측[T-a22f90aa]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] |  | 2 (R-14 R-28) |
| WK-SSP0200-0591 | A5 | PROJECT_CODE | 하네스·환경 | A5 도구 오류 — 원장 V-ae7dcc31 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0592 | A5 | PROJECT_CODE | 하네스·환경 | A5 도구 오류 — 원장 V-c4f1baa9 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0593 | A5 | PROJECT_CODE / Project Code | 하네스·환경 | A5 도구 오류 — 원장 V-ae7dcc31 ASIS / 원장 V-c4f1baa9 ASIS / E2E smoke columns / 실측[T-631f7c12]: PROJECT_CODE: AS-IS(Div 40) '기본 →숨김 →숨김?' |  | 7 (R-31⑥⑦ R-70 D17 ACT:SSP0200_ShipmentChan) |
| WK-SSP0200-0594 | A5 | PROJECT_NAME | 하네스·환경 | A5 도구 오류 — 원장 V-aa0ce241 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0595 | A5 | PROJECT_NAME | 하네스·환경 | A5 도구 오류 — 원장 V-dbc91178 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0596 | A5 | PROJECT_NAME / Project Name | 하네스·환경 | A5 도구 오류 — 원장 V-aa0ce241 ASIS / 원장 V-dbc91178 ASIS / E2E smoke columns / 실측[T-e5cbaf6e]: PROJECT_NAME: AS-IS(Div 40) '기본 →숨김 →숨김?' |  | 4 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0597 | A5 | SSP0200_ShipmentChangeRequest.CreateSpre | 하네스·환경 | A5 도구 오류 — 실측[T-737c9d9b]: AS-IS 기본 표시 컬럼 2 ⊆ TO-BE 그리드 40: 누락 ATTRIBUTE10 (AS-IS 숨김·코드추가 helper 컬럼은 비교 제외: BOD_ID, CHANGE_REASON_ |  | 8 (ACT:SSP0200_ShipmentChangeRequest.Create) |
| WK-SSP0200-0598 | A5 | TO_SITE / To Site ID | 하네스·환경 | A5 도구 오류 — 원장 V-f8f46093 COLUMN / E2E smoke columns / 실측[T-bf7a4574]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] |  | 2 (R-14 R-28) |
| WK-SSP0200-0599 | H2 | REMARKS / Remarks | 하네스·환경 | H2 도구 오류 — 원장 V-535a2d97 COLUMN / 원장 V-44315b73 COLUMN / 원장 V-82c3a36f ASIS / 원장 V-71245f46 ASIS / 실측[T-665c60ac]: REMARKS: 기존행 편집 |  | 4 (R-70 D10 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0600 | H2 | REMARKS2 / Building | 하네스·환경 | H2 도구 오류 — 원장 V-ddf96cd7 COLUMN / 원장 V-21591bc1 COLUMN / 원장 V-83016e3c ASIS / 원장 V-8483fdc3 ASIS / 실측[T-d5cfb57b]: REMARKS2: 기존행 편 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0601 | H2 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | H2 도구 오류 — 원장 V-dffd90b9 COLUMN / 원장 V-b0a065af COLUMN / 원장 V-8b73ca85 ASIS / 원장 V-126bfb61 ASIS / 원장 V-1a3aa539 ASIS / 원장 V-13437 |  | 8 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0602 | H2 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | H2 도구 오류 — 원장 V-b556344d COLUMN / 원장 V-a2e3bd1e COLUMN / 원장 V-134378af ASIS / 원장 V-d5cd1d48 ASIS / 원장 V-96ae2c44 ASIS / 실측[T-cd9df |  | 6 (R-22 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0603 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-8b73ca85 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0604 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-126bfb61 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0605 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-99ff1a58 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0606 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-45a4ba40 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0607 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-82c3a36f |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0608 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-71245f46 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0609 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-83016e3c |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0610 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-8483fdc3 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0611 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-1a3aa539 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0612 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-cea7dc94 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0613 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-134378af |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0614 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-d5cd1d48 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0615 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-d5f5548e |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0616 | H2 | siMain.ActiveSheet.Cells[i, siMain.GetCo | 하네스·환경 | H2 도구 오류 — 원장 V-39282d7d |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0617 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-d87885c7 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0618 | H4 | SSP0200 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-9500601e RULE_SCREEN / 원장 V-bd16b3f2 RULE_SCREEN / 원장 V-33f20f99 RULE_SCREEN / 원장 V-bb175aa4 RULE_SCREEN / 원장 V-f9 |  | 4 (R-41 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0619 | H5 | **L-050** | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 **L-050** '`PlanType1`(Change Type 라벨/콤보) `Visibility=Never`(' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RU |  | 1 (**L-050**) |
| WK-SSP0200-0620 | H5 | COMMON:UC-02 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0621 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT |  | 1 (COMMON:UC-07) |
| WK-SSP0200-0622 | H5 | EDIT_MAIN | 하네스·환경 | H5 도구 오류 — 실측[T-a8dd4af5]: EDIT_MAIN 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (R-19) |
| WK-SSP0200-0623 | H5 | EditButton cs:783 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 EditButton cs:783 '`siSub.RowCount==0` 일 때만 편집모드 진입 = 작성 중 요청이 있으면 상단' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2  |  | 1 (EditButton cs:783) |
| WK-SSP0200-0624 | H5 | L-062·L-063 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 L-062·L-063 '`VisibleTab(true)` 2건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (L-062·L-063) |
| WK-SSP0200-0625 | H5 | L-081 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 L-081 '`SheetName == shtMain` 일 때만 저장' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (L-081) |
| WK-SSP0200-0626 | H5 | NEW_SHIPMENT_CONFIRM_QTY / Qty | 하네스·환경 | H5 도구 오류 — 실측[T-f2926f9a]: NEW_SHIPMENT_CONFIRM_QTY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0627 | H5 | R-01·R-02 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-01·R-02 '`FpSpread` 2 + 이벤트 10' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-01·R-02) |
| WK-SSP0200-0628 | H5 | R-10 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-10 '시트 초기화 폭/라벨/헤더 span/소수 32건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-10) |
| WK-SSP0200-0629 | H5 | R-12 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-12 'div 40/EE 컬럼 표시 전환(시트 축) 12건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-12) |
| WK-SSP0200-0630 | H5 | R-13 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-13) |
| WK-SSP0200-0631 | H5 | R-18 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-18 'BOD 0행 처리' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-18) |
| WK-SSP0200-0632 | H5 | R-24 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-24 'CHANGE_REASON 연동 11건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-24) |
| WK-SSP0200-0633 | H5 | R-27 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-27 '소수자릿수 동적 전환 8건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-27) |
| WK-SSP0200-0634 | H5 | R-29 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-29 '검증 전 색/상태 초기화 16건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-29) |
| WK-SSP0200-0635 | H5 | R-31② | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-31② 'EditButton 잠금 8건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-31②) |
| WK-SSP0200-0636 | H5 | R-31③④ | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-31③④) |
| WK-SSP0200-0637 | H5 | R-40 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-40 'spCalls 12건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-40) |
| WK-SSP0200-0638 | H5 | R-41 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-41 'entryPoints 12건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-41) |
| WK-SSP0200-0639 | H5 | R-50 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-50 'buttonGuards 52건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-50) |
| WK-SSP0200-0640 | H5 | R-51 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-51 'validations 36건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-51) |
| WK-SSP0200-0641 | H5 | R-52 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-52 'popups 5건' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-52) |
| WK-SSP0200-0642 | H5 | R-60 C10 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-60 C10 '동일 SO 부분선택 → `MSG00247`' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-60 C10) |
| WK-SSP0200-0643 | H5 | R-70 D11~D16 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-70 D11~D16 '`cellTypeImage` 경로별 차이' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0644 | H5 | R-70 D1·D2·D4·D5 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R-70 D1·D2·D4·D5 "ChangeType='P' 폭 0/복원" 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 1 (R-70 D1·D2·D4·D5) |
| WK-SSP0200-0645 | H5 | SSP0200_ShipmentChangeRequest.CreateSpre | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0200_ShipmentChangeRequest.CreateSpread 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_RUN:1 |  | 8 (ACT:SSP0200_ShipmentChangeRequest.Create) |
| WK-SSP0200-0646 | H5 | cascade 5단계 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 cascade 5단계 'Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출' 의 H5 34요소: PASS:21 · NA:10 · ERROR:2 · NOT_ |  | 1 (cascade 5단계) |
| WK-SSP0200-0647 | D1 | ERP_SO_NO / SO No | 하네스·환경 | D1 도구 오류 — 원장 V-338d80af COLUMN / 원장 V-a21de601 COLUMN / 원장 V-91193a2a COLUMN / 원장 V-93646def COLUMN / 실측[T-dcc5266b]: 기존행 r0 ERP_ |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0648 | D1 | ITEM_ID / Model | 하네스·환경 | D1 도구 오류 — 원장 V-3eaf4874 COLUMN / 원장 V-29fd0d45 COLUMN / 원장 V-83b0de58 COLUMN / 원장 V-c79635b0 COLUMN / 실측[T-2921d025]: 기존행 r0 ITEM |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0649 | D1 | REMARKS3 / Customer Requirement | 하네스·환경 | D1 도구 오류 — 원장 V-42dc49e9 COLUMN / 원장 V-657fe604 COLUMN / 원장 V-f75cdb78 COLUMN / 원장 V-3e60150d COLUMN / 실측[T-91e0ff3f]: 기존행 r0 REMA |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0650 | D1 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | D1 도구 오류 — 원장 V-52450ad4 COLUMN / 원장 V-4428c524 COLUMN / 원장 V-f654576e COLUMN / 원장 V-d3757f98 COLUMN / 실측[T-447fcf3a]: 기존행 r0 SHIP |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0651 | D3 | **L-127·L-128** | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 **L-127·L-128** 'Division 권한 0건 → 조회영역 전체 잠금 + `return`(이후 초기화 전부 중' 의 D3 47요소: ERROR:45 · NA:2 |  | 1 (**L-127·L-128**) |
| WK-SSP0200-0652 | D3 | DIVISION_ID / Div | 하네스·환경 | D3 도구 오류 — 원장 V-2032ef7a ASIS / 원장 V-6d504176 ASIS / 원장 V-41485ee2 ASIS / 원장 V-7a0dd436 ASIS / 원장 V-5d9c3880 ASIS / 원장 V-17f49304  |  | 10 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0653 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-2032ef7a / 실측[T-370f0da3]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0654 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-41485ee2 / 실측[T-6e7ebf8b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0655 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-7a0dd436 / 실측[T-77d8882e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0656 | D3 | DIVISION_ID,TO_SITE_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-6d504176 / 실측[T-29bf24a9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0657 | D3 | END_CUSTOMER / End Customer | 하네스·환경 | D3 도구 오류 — 원장 V-b9070d07 ASIS / 원장 V-17f49304 ASIS / 원장 V-08e302a5 ASIS / 실측[T-98a2fc2f]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0658 | D3 | END_CUSTOMER,END_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-17f49304 / 실측[T-c85d8f84]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0659 | D3 | END_CUSTOMER,END_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-08e302a5 / 실측[T-14a3655c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0660 | D3 | ERP_SO_NO / SO No | 하네스·환경 | D3 도구 오류 — 원장 V-596aaf7d ASIS / 원장 V-3f44785d ASIS / 원장 V-23853a54 ASIS / 실측[T-5e9dad9d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0661 | D3 | ERP_SO_NO,SHIPMENT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-596aaf7d / 실측[T-a454e892]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0662 | D3 | ERP_SO_NO,SHIPMENT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-3f44785d / 실측[T-04f24aea]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0663 | D3 | ERP_SO_NO,SHIPMENT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-23853a54 / 실측[T-001f7fe6]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0664 | D3 | ERP_STATUS / erp_status | 하네스·환경 | D3 도구 오류 — 실측[T-34fb31e0]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / else of (sStatus == |  | 3 (R-25 ACT:SSP0200_ShipmentChangeRequest.E) |
| WK-SSP0200-0665 | D3 | EditButton cs:783 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 EditButton cs:783 '`siSub.RowCount==0` 일 때만 편집모드 진입 = 작성 중 요청이 있으면 상단' 의 D3 47요소: ERROR:45 · NA:2 |  | 1 (EditButton cs:783) |
| WK-SSP0200-0666 | D3 | FROM_SITE_DESCRIPTION / From Site | 하네스·환경 | D3 도구 오류 — 원장 V-b9070d07 ASIS / 실측[T-82221d55]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0)  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0667 | D3 | FROM_SITE_DESCRIPTION,END_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-b9070d07 / 실측[T-99d786f3]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0668 | D3 | ITEM_ID / Model | 하네스·환경 | D3 도구 오류 — 원장 V-9a06ff67 ASIS / 실측[T-91fd684c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0)  |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0669 | D3 | ITEM_ID,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-9a06ff67 / 실측[T-6a4a3969]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0670 | D3 | NICK_NAME / Nick Name | 하네스·환경 | D3 도구 오류 — 원장 V-d884dc02 ASIS / 원장 V-a48cb417 ASIS / 원장 V-94aaf9c6 ASIS / 실측[T-79c40a0b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0671 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-d884dc02 / 실측[T-fdcb7a2d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0672 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-a48cb417 / 실측[T-ffb40485]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0673 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-94aaf9c6 / 실측[T-2fd2ea2b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0674 | D3 | PROJECT_CODE / Project Code | 하네스·환경 | D3 도구 오류 — 원장 V-5d9c3880 ASIS / 원장 V-ef054008 ASIS / 실측[T-9f6cbc26]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.Active |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0675 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-5d9c3880 / 실측[T-d82ffce5]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0676 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-ef054008 / 실측[T-e393663a]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0677 | D3 | PROJECT_NAME / Project Name | 하네스·환경 | D3 도구 오류 — 원장 V-589b3704 ASIS / 원장 V-b0c9d2ab ASIS / 원장 V-d7054b43 ASIS / 실측[T-33719066]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0678 | D3 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-589b3704 / 실측[T-63e21d65]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0679 | D3 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-b0c9d2ab / 실측[T-b63aec29]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0680 | D3 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-d7054b43 / 실측[T-84d8c3ee]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0681 | D3 | R-13 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 R-13 'div 셀 변경 cascade(행 축) 23건' 의 D3 47요소: ERROR:45 · NA:2 |  | 1 (R-13) |
| WK-SSP0200-0682 | D3 | R-27 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 R-27 '소수자릿수 동적 전환 8건' 의 D3 47요소: ERROR:45 · NA:2 |  | 1 (R-27) |
| WK-SSP0200-0683 | D3 | R-31② | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 R-31② 'EditButton 잠금 8건' 의 D3 47요소: ERROR:45 · NA:2 |  | 1 (R-31②) |
| WK-SSP0200-0684 | D3 | R-31③④ | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 R-31③④ '`Query(ds)` 바인딩 / 조회 직후 전열 잠금' 의 D3 47요소: ERROR:45 · NA:2 |  | 1 (R-31③④) |
| WK-SSP0200-0685 | D3 | R-50 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 R-50 'buttonGuards 52건' 의 D3 47요소: ERROR:45 · NA:2 |  | 1 (R-50) |
| WK-SSP0200-0686 | D3 | REMARKS3 / Customer Requirement | 하네스·환경 | D3 도구 오류 — 원장 V-8a830f17 ASIS / 실측[T-f78a927c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0)  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0687 | D3 | REQUESTOR / Shipment Requestor | 하네스·환경 | D3 도구 오류 — 원장 V-4108c9c8 ASIS / 원장 V-8644c66a ASIS / 원장 V-eadc48b7 ASIS / 실측[T-be07c250]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미 |  | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0688 | D3 | REQUESTOR,REQUESTOR | 하네스·환경 | D3 도구 오류 — 원장 V-4108c9c8 / 실측[T-052d2b35]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0689 | D3 | REQUESTOR,REQUESTOR | 하네스·환경 | D3 도구 오류 — 원장 V-8644c66a / 실측[T-a3e1129d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0690 | D3 | REQUESTOR,REQUESTOR | 하네스·환경 | D3 도구 오류 — 원장 V-eadc48b7 / 실측[T-5cded171]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0691 | D3 | REQUEST_DATE / Request Date | 하네스·환경 | D3 도구 오류 — 원장 V-44a48fb4 ASIS / 원장 V-2112ba88 ASIS / 원장 V-71736a3f ASIS / 원장 V-3c7f5ffa ASIS / 실측[T-9ba4c16b]: 조건 계산 불가(검사기가 AS-IS |  | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0692 | D3 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | D3 도구 오류 — 원장 V-8a830f17 ASIS / 실측[T-232bea8a]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0)  |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0693 | D3 | SHIPMENT_CONFIRM_QTY,REMARKS3 | 하네스·환경 | D3 도구 오류 — 원장 V-8a830f17 / 실측[T-f9cdfe47]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0694 | D3 | SHIPMENT_STATUS / Status | 하네스·환경 | D3 도구 오류 — 원장 V-596aaf7d ASIS / 원장 V-3f44785d ASIS / 원장 V-23853a54 ASIS / 실측[T-d1b5ac39]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미 |  | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0695 | D3 | SSP0200_ShipmentChangeRequest.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-2739ed8f ASIS / 원장 V-6d504176 ASIS / 원장 V-2112ba88 ASIS / 원장 V-2dc158e4 ASIS / 원장 V-9a06ff67 ASIS / 원장 V-b9070d07  |  | 9 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0696 | D3 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | D3 도구 오류 — 원장 V-6d504176 ASIS / 실측[T-9b125566]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0)  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0697 | D3 | TO_SITE_SOLDTO_CODE / Sold to | 하네스·환경 | D3 도구 오류 — 원장 V-44a48fb4 ASIS / 원장 V-2112ba88 ASIS / 원장 V-71736a3f ASIS / 원장 V-3c7f5ffa ASIS / 실측[T-d04426a9]: 조건 계산 불가(검사기가 AS-IS |  | 5 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0698 | D3 | TO_SITE_SOLDTO_CODE,REQUEST_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-44a48fb4 / 실측[T-6507b1d1]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0699 | D3 | TO_SITE_SOLDTO_CODE,REQUEST_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-2112ba88 / 실측[T-b7522f44]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0700 | D3 | TO_SITE_SOLDTO_CODE,REQUEST_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-71736a3f / 실측[T-d3c98440]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0701 | D3 | TO_SITE_SOLDTO_CODE,REQUEST_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-3c7f5ffa / 실측[T-6a152ea5]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siSub.ActiveSheet.RowCount == 0) / els |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0702 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-1f73b566 / 실측[T-d4ebd917]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0703 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-2739ed8f / 실측[T-a40fc5a4]: siMain.SwitchLock: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0704 | D4 | COMMON:UC-01 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (ke' 의 D4 3요소: PASS:2 · ERROR:1 |  | 1 (COMMON:UC-01) |
| WK-SSP0200-0705 | D4 | COMMON:UC-03 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 D4 3요소: PASS:2 · ERROR:1 |  | 1 (COMMON:UC-03) |
| WK-SSP0200-0706 | D4 | EditButton cs:783 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 EditButton cs:783 '`siSub.RowCount==0` 일 때만 편집모드 진입 = 작성 중 요청이 있으면 상단' 의 D4 3요소: PASS:2 · ERROR:1 |  | 1 (EditButton cs:783) |
| WK-SSP0200-0707 | D4 | MSG00202(수량 0) | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 MSG00202(수량 0) '`MSG00202` 유지' 의 D4 3요소: PASS:2 · ERROR:1 |  | 1 (MSG00202(수량 0)) |
| WK-SSP0200-0708 | D4 | Period 기본값 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 Period 기본값 '`GetDayRange("")` = `SCM0001_GET_SCP_DAY_PERIOD`' 의 D4 3요소: PASS:2 · ERROR:1 |  | 1 (Period 기본값) |
| WK-SSP0200-0709 | D4 | R-41 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 R-41 'entryPoints 12건' 의 D4 3요소: PASS:2 · ERROR:1 |  | 1 (R-41) |
| WK-SSP0200-0710 | D4 | TO-BE 추가(2026-11-12) | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 TO-BE 추가(2026-11-12) '(AS-IS 없음 — 사용자 지시) 요청정보 영역 접기/펼치기 + 펼침/접힘 고정 · 입력' 의 D4 3요소: PASS:2 · ERROR:1 |  | 1 (TO-BE 추가(2026-11-12)) |
| WK-SSP0200-0711 | D4 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | D4 도구 오류 — 실측[T-76fa4154]: 신규행 TO_SITE_DESCRIPTION='Unit Pack Power_HK_KWN' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 |  | 1 (R-28) |
| WK-SSP0200-0712 | D4 | 초기 mount 무발화 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 초기 mount 무발화 '`InitEvent()` 가 마지막이라 초기 설정이 cascade 를 트리거하지 않는다' 의 D4 3요소: PASS:2 · ERROR:1 |  | 1 (초기 mount 무발화) |
| WK-SSP0200-0713 | D5 | END_CUSTOMER / End Customer | 하네스·환경 | D5 도구 오류 — 실측[T-0ee8b779]: END_CUSTOMER: AS-IS COMBO(AS-IS 문장) ↔ TO-BE dataType=1 dataMap=N — 편집 불가 칸이라 입력 방식 차이 없음 · 표시 표본 [Unit  |  | 6 (R-26 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0714 | D5 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | D5 도구 오류 — 실측[T-eae35093]: TRANSPORT_MODE: AS-IS COMBO(AS-IS 문장) ↔ TO-BE dataType=1 dataMap=N — 편집 불가 칸이라 입력 방식 차이 없음 · 표시 표본 [TRK |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0715 | E3 | DataUtil.checkRequiredOfSpread | 하네스·환경 | E3 도구 오류 — 원장 V-6086c484 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0716 | E3 | DataUtil.checkRequiredOfSpread | 하네스·환경 | E3 도구 오류 — 원장 V-84d45794 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SaveBu) |
| WK-SSP0200-0717 | E3 | DataUtil.checkRequiredOfSpread | 하네스·환경 | E3 도구 오류 — 원장 V-4577c3b3 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SaveDa) |
| WK-SSP0200-0718 | E3 | L-073 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 L-073 '`SaveButton` 6가드' 의 E3 7요소: ERROR:3 · PASS:2 · NA:2 |  | 1 (L-073) |
| WK-SSP0200-0719 | E3 | L-079·L-082·L-102 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 L-079·L-082·L-102 "`SSPBlockCheckIF` → `BLOCK_YN='Y'` 면 저장 차단 + PERIO" 의 E3 7요소: ERROR:3 · PASS:2 · NA:2 |  | 1 (L-079·L-082·L-102) |
| WK-SSP0200-0720 | E3 | L-090 ~ L-121 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 L-090 ~ L-121 '검증 메시지 33건' 의 E3 7요소: ERROR:3 · PASS:2 · NA:2 |  | 1 (L-090 ~ L-121) |
| WK-SSP0200-0721 | E3 | R-29 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 R-29 '검증 전 색/상태 초기화 16건' 의 E3 7요소: ERROR:3 · PASS:2 · NA:2 |  | 1 (R-29) |
| WK-SSP0200-0722 | E3 | R-50 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 R-50 'buttonGuards 52건' 의 E3 7요소: ERROR:3 · PASS:2 · NA:2 |  | 1 (R-50) |
| WK-SSP0200-0723 | E3 | R-51 | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 R-51 'validations 36건' 의 E3 7요소: ERROR:3 · PASS:2 · NA:2 |  | 1 (R-51) |
| WK-SSP0200-0724 | E3 | TO-BE 추가(2026-11-12) | 하네스·환경 | E3 도구 오류 — 행 집계 — 대조표 TO-BE 추가(2026-11-12) '(AS-IS 없음 — 사용자 지시) 요청정보 영역 접기/펼치기 + 펼침/접힘 고정 · 입력' 의 E3 7요소: ERROR:3 · PASS:2 · NA:2 |  | 1 (TO-BE 추가(2026-11-12)) |
| WK-SSP0200-0725 | E4 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | E4 도구 오류 — 원장 V-20013f3d ASIS / 실측[T-6a7b85e7]: MSG00287 — SpdMain_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(S |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0726 | E4 | DIVISION_ID / Div | 하네스·환경 | E4 도구 오류 — 원장 V-0ef874ed ASIS / 실측[T-ed461aa7]: MSG00098 — SpdMain_ComboSelChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0727 | E4 | FROM_SITE_DESCRIPTION / From Site | 하네스·환경 | E4 도구 오류 — 원장 V-56c3d505 ASIS / 원장 V-d42a17d3 ASIS / 원장 V-62a6a4f9 ASIS / 원장 V-c860e418 ASIS / 원장 V-7229258b ASIS / 실측[T-9fd30681] |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0728 | E4 | INCOTERMS / Incoterms | 하네스·환경 | E4 도구 오류 — 원장 V-62a6a4f9 ASIS / 원장 V-0ef874ed ASIS / 원장 V-7229258b ASIS / 원장 V-21ef23af ASIS / 원장 V-160080d7 ASIS / 원장 V-f1819b93  |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0729 | E4 | ITEM_ID / Model | 하네스·환경 | E4 도구 오류 — 원장 V-62a6a4f9 ASIS / 원장 V-8c6250a2 ASIS / 원장 V-d7d72459 ASIS / 원장 V-b281e110 ASIS / 원장 V-c5410a1d ASIS / 원장 V-dbb75eae  |  | 10 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0730 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-62a6a4f9 ASIS / 원장 V-11b4854b ASIS / 원장 V-7c9601ff ASIS / 원장 V-07f48f5e ASIS / 원장 V-c4677ee3 ASIS / 실측[T-97f48cbb] |  | 6 (MSG00002 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0731 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-62a6a4f9 / 실측[T-19f12c97]: MSG00002 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0732 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-11b4854b / 실측[T-31f33112]: MSG00002 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.checkR) |
| WK-SSP0200-0733 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-7c9601ff / 실측[T-8873b9f0]: MSG00002 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.checkR) |
| WK-SSP0200-0734 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-07f48f5e / 실측[T-1e6d4322]: MSG00002 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.checkR) |
| WK-SSP0200-0735 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-c4677ee3 / 실측[T-2c16071f]: MSG00002 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.checkR) |
| WK-SSP0200-0736 | E4 | MSG00050 | 하네스·환경 | E4 도구 오류 — 원장 V-e15f0c3b / 실측[T-e5d2b776]: MSG00050 — btnButtonList_UsrButtonList_Click_Detected 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 |  | 1 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0737 | E4 | MSG00050 | 하네스·환경 | E4 도구 오류 — 원장 V-e15f0c3b ASIS / 실측[T-9e88f272]: MSG00050 — btnButtonList_UsrButtonList_Click_Detected 경로 메시지(저장 전 검증 아님 · Save 진입점 |  | 1 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0738 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-56c3d505 ASIS / 원장 V-d42a17d3 ASIS / 원장 V-8c6250a2 ASIS / 원장 V-d7d72459 ASIS / 원장 V-b281e110 ASIS / 원장 V-c5410a1d  |  | 17 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0739 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-56c3d505 / 실측[T-38e428c3]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0740 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-d42a17d3 / 실측[T-20b9b054]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0741 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-8c6250a2 / 실측[T-c862369e]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0742 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-d7d72459 / 실측[T-faf83230]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0743 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-b281e110 / 실측[T-54509186]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0744 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-c5410a1d / 실측[T-da13a109]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0745 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-dbb75eae / 실측[T-499189aa]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0746 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-300d2050 / 실측[T-4134e953]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0747 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-2bf0d543 / 실측[T-d7a746dd]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0748 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-c860e418 / 실측[T-6fc9c24d]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0749 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-0ef874ed / 실측[T-065bcb75]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0750 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-7229258b / 실측[T-ef45aef9]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0751 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-21ef23af / 실측[T-5c211a6b]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0752 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-160080d7 / 실측[T-9d303e56]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0753 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-be06cda6 / 실측[T-32ea50ed]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0754 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-f1819b93 / 실측[T-6a6106b7]: MSG00098 — SpdMain_CellClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMain |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0755 | E4 | MSG00189 | 하네스·환경 | E4 도구 오류 — 원장 V-b021196b ASIS / 원장 V-6e2fdc54 ASIS / 실측[T-220433ad]: MSG00189: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guar |  | 3 (MSG00189 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0756 | E4 | MSG00189 | 하네스·환경 | E4 도구 오류 — 원장 V-6e2fdc54 / 실측[T-9e2dd2b3]: MSG00189: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (ds.Tables[2].Rows.C |  | 1 (ACT:SSP0200_ShipmentChangeRequest.shtMai) |
| WK-SSP0200-0757 | E4 | MSG00194 | 하네스·환경 | E4 도구 오류 — 원장 V-e1530e76 ASIS / 원장 V-074d8f1c ASIS / 원장 V-12a1110d ASIS / 원장 V-af4b736f ASIS / 실측[T-d71ec798]: MSG00194 — BtnChang |  | 7 (L-149·L-150 R-22 MSG00195 / MSG00267 / M) |
| WK-SSP0200-0758 | E4 | MSG00194 | 하네스·환경 | E4 도구 오류 — 원장 V-e1530e76 / 실측[T-2f952a0b]: MSG00194 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnChan |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0759 | E4 | MSG00194 | 하네스·환경 | E4 도구 오류 — 원장 V-074d8f1c / 실측[T-f95901c6]: MSG00194 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnChan |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0760 | E4 | MSG00194 | 하네스·환경 | E4 도구 오류 — 원장 V-12a1110d / 실측[T-8c20a4b1]: MSG00194 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnChan |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0761 | E4 | MSG00194 | 하네스·환경 | E4 도구 오류 — 원장 V-af4b736f / 실측[T-4082096c]: MSG00194 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnChan |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0762 | E4 | MSG00195 | 하네스·환경 | E4 도구 오류 — 원장 V-085d0ea0 ASIS / 실측[T-29e10910]: MSG00195 — BtnCancel_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnC |  | 2 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0763 | E4 | MSG00195 | 하네스·환경 | E4 도구 오류 — 원장 V-085d0ea0 / 실측[T-bf25f16d]: MSG00195 — BtnCancel_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnCancel |  | 2 (ACT:SSP0200_ShipmentChangeRequest.BtnCan) |
| WK-SSP0200-0764 | E4 | MSG00197 | 하네스·환경 | E4 도구 오류 — 원장 V-fd7ff8f8 ASIS / 원장 V-65c760b1 ASIS / 실측[T-26d4a8f9]: MSG00197: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guar |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0765 | E4 | MSG00197 | 하네스·환경 | E4 도구 오류 — 원장 V-65c760b1 / 실측[T-82630852]: MSG00197: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (errConfirmList.Coun |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0766 | E4 | MSG00198 | 하네스·환경 | E4 도구 오류 — 원장 V-c5d157b9 / 실측[T-b81436af]: MSG00198 — DeleteDataDrafting 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Delete |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Delete) |
| WK-SSP0200-0767 | E4 | MSG00198 | 하네스·환경 | E4 도구 오류 — 원장 V-c5d157b9 ASIS / 실측[T-4caec78b]: MSG00198 — DeleteDataDrafting 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(D |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Delete) |
| WK-SSP0200-0768 | E4 | MSG00201 | 하네스·환경 | E4 도구 오류 — 원장 V-0df6aa86 / 실측[T-fb08330c]: MSG00201 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnChan |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0769 | E4 | MSG00201 | 하네스·환경 | E4 도구 오류 — 원장 V-0df6aa86 ASIS / 실측[T-2971e636]: MSG00201 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Bt |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0770 | E4 | MSG00202 | 하네스·환경 | E4 도구 오류 — 원장 V-0604c80e ASIS / 원장 V-e2b68cce ASIS / 실측[T-810f3cd2]: MSG00202 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿 |  | 4 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0771 | E4 | MSG00202 | 하네스·환경 | E4 도구 오류 — 원장 V-0604c80e / 실측[T-685f45cc]: MSG00202 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnChan |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0772 | E4 | MSG00202 | 하네스·환경 | E4 도구 오류 — 원장 V-e2b68cce / 실측[T-028f669a]: MSG00202 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnChan |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0773 | E4 | MSG00204 | 하네스·환경 | E4 도구 오류 — 원장 V-275b77da ASIS / 원장 V-783b46e6 ASIS / 실측[T-9d8d6539]: MSG00204: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guar |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0774 | E4 | MSG00204 | 하네스·환경 | E4 도구 오류 — 원장 V-783b46e6 / 실측[T-37c5c142]: MSG00204: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (String.IsNullOrEmpt |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0775 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-3e03c0d8 ASIS / 원장 V-8fce904a ASIS / 원장 V-2387c575 ASIS / 원장 V-0fc67979 ASIS / 원장 V-52727234 ASIS / 원장 V-c3d2478f  |  | 9 (MSG00284 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0776 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-3e03c0d8 / 실측[T-1c6dda88]: 검사 대상 아님 — catch 블록 예외 메시지(프레임워크 공통 오류 표시) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Delete) |
| WK-SSP0200-0777 | E4 | MSG00287 | 하네스·환경 | E4 도구 오류 — 원장 V-20013f3d ASIS / 실측[T-8858aa96]: MSG00287 — SpdMain_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(S |  | 2 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0778 | E4 | MSG00287 | 하네스·환경 | E4 도구 오류 — 원장 V-20013f3d / 실측[T-53006526]: MSG00287 — SpdMain_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdMai |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0779 | E4 | MSG00293 | 하네스·환경 | E4 도구 오류 — 원장 V-29f929f0 ASIS / 원장 V-0262cfec ASIS / 원장 V-d0698363 ASIS / 실측[T-7580ff9f]: MSG00293: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류  |  | 5 (MSG00293 MSG00293(Trans Mode 콤보 미로드) ACT) |
| WK-SSP0200-0780 | E4 | MSG00293 | 하네스·환경 | E4 도구 오류 — 원장 V-d0698363 / 실측[T-2106d64e]: MSG00293: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (check_error_type == |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0781 | E4 | MSG00306 | 하네스·환경 | E4 도구 오류 — 원장 V-518265d2 / 실측[T-5be4c6ed]: MSG00306 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErpIFChe |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0782 | E4 | MSG00306 | 하네스·환경 | E4 도구 오류 — 원장 V-518265d2 ASIS / 실측[T-dc2655f9]: MSG00306 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErp |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0783 | E4 | NEW_YN / new_yn | 하네스·환경 | E4 도구 오류 — 원장 V-e2b68cce ASIS / 실측[T-90b9dd90]: MSG00202 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Bt |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0784 | E4 | PROJECT_CODE / Project Code | 하네스·환경 | E4 도구 오류 — 원장 V-62a6a4f9 ASIS / 원장 V-c5410a1d ASIS / 원장 V-dbb75eae ASIS / 원장 V-300d2050 ASIS / 원장 V-2bf0d543 ASIS / 실측[T-ced486e1] |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0785 | E4 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | E4 도구 오류 — 원장 V-20d7f321 ASIS / 원장 V-727f5f45 ASIS / 원장 V-546af6b5 ASIS / 원장 V-be06cda6 ASIS / 원장 V-af4b736f ASIS / 원장 V-20013f3d  |  | 6 (L-149·L-150 R-22 ACT:SSP0200_ShipmentCha) |
| WK-SSP0200-0786 | E4 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | E4 도구 오류 — 원장 V-d42a17d3 ASIS / 원장 V-62a6a4f9 ASIS / 원장 V-c860e418 ASIS / 원장 V-21ef23af ASIS / 실측[T-13692f0d]: MSG00098 — SpdMain_ |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0787 | E4 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | E4 도구 오류 — 원장 V-62a6a4f9 ASIS / 원장 V-d0698363 ASIS / 원장 V-be06cda6 ASIS / 원장 V-f1819b93 ASIS / 실측[T-af539c33]: MSG00002 — SpdMain_ |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0788 | E4 | cboChangeReason / Change Reason | 하네스·환경 | E4 도구 오류 — 실측[T-37d86c91]: MSG00002 — checkRequired 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(checkRequired)에서 판정 → 기계 판정 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0789 | E4 | cboChangeType / Change Type | 하네스·환경 | E4 도구 오류 — 실측[T-93094233]: MSG00202 — BtnChangeRe_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnChangeRe_Click)에서 판정 |  | 10 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0790 | E4 | txtApproval / Approval | 하네스·환경 | E4 도구 오류 — 실측[T-33b594f6]: MSG00002 — checkRequired 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(checkRequired)에서 판정 → 기계 판정 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0791 | E4 | txtCurrentInsert_Qty / Confirm Id / Curr | 하네스·환경 | E4 도구 오류 — 실측[T-c8facac1]: MSG00050 — btnButtonList_UsrButtonList_Click_Detected 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리 |  | 1 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0792 | E4 | txtReasonDetail / Reason Detail | 하네스·환경 | E4 도구 오류 — 실측[T-8139b5d8]: MSG00002 — checkRequired 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(checkRequired)에서 판정 → 기계 판정 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0793 | E4 | txtTitle / Title | 하네스·환경 | E4 도구 오류 — 실측[T-c1b79af2]: MSG00002 — checkRequired 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(checkRequired)에서 판정 → 기계 판정 |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0794 | A6 | PKG_SSP0026.P_SSP0026_GET_BOD_ITEM | 하네스·환경 | A6 도구 오류 — 원장 V-34c85b81 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-8ca56d20]: PKG_SSP0026.P_SSP0026_GET_BOD_ITEM: 화면 진입·조회 경로에서 이 SP 가 결과를  |  | 31 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0795 | A6 | PKG_SSP0200.P_SSP0200_GET_CHANGE_REQ_NO | 하네스·환경 | A6 도구 오류 — 원장 V-c94166dd SP / 정렬대조 NA AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드 비바인딩 룩업 SP(PROC_M / 실측[T-05403f8a]: PKG_SSP0200.P_SSP0200_G |  | 1 (L-064) |
| WK-SSP0200-0796 | A6 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANG | 하네스·환경 | A6 도구 오류 — 원장 V-008f20a8 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-0bacbe98]: PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N: 화면 진입·조회 |  | 44 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0797 | A6 | SSP0200_GET_ITEM_FROM_BOD | 하네스·환경 | A6 도구 오류 — 원장 V-5e278197 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-1f280d42]: SSP0200_GET_ITEM_FROM_BOD: 화면 진입 |  | 1 (R-27) |
| WK-SSP0200-0798 | A6 | SSP0200_GET_SHIPMENT_DIVISION | 하네스·환경 | A6 도구 오류 — 원장 V-1b355eab SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-3fbec085]: SSP0200_GET_SHIPMENT_DIVISION: 화 |  | 1 (**C4**) |
| WK-SSP0200-0799 | G1 | txtAppDeptName / Dept Name / App Dept Na | 하네스·환경 | G1 도구 오류 — 원장 V-39e934b9 SEARCH / 원장 V-5f987414 SEARCH / E2E smoke cond text |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0800 | G1 | txtApproval / Approval | 하네스·환경 | G1 도구 오류 — 원장 V-065e78b7 SEARCH / E2E smoke cond text |  | 10 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0801 | G1 | txtRequest / sItemId / Request / Request | 하네스·환경 | G1 도구 오류 — 원장 V-c3235bf9 SEARCH / E2E smoke cond text |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0802 | X-ROW | Item.ClassToItem | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 17 (ACT:Item.ClassToItem ACT:Item.ClassToIte) |
| WK-SSP0200-0803 | X-ROW | SSP0200_ShipmentChangeRequest.BtnApprova | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:7 |  | 11 (ACT:SSP0200_ShipmentChangeRequest.BtnApp) |
| WK-SSP0200-0804 | X-ROW | SSP0200_ShipmentChangeRequest.CboChangeT | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.CboCha) |
| WK-SSP0200-0805 | X-ROW | SSP0200_ShipmentChangeRequest.CreateSpre | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · ERROR:1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Create) |
| WK-SSP0200-0806 | X-ROW | SSP0200_ShipmentChangeRequest.FindData_B | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 13검사 — ERROR:6 · NOPATH:3 · PASS:2 · REVIEW:1 · NA:1 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0807 | X-ROW | SSP0200_ShipmentChangeRequest.GetDivisio | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — PASS:4 · ERROR:2 · REVIEW:2 · NOPATH:2 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetDiv) |
| WK-SSP0200-0808 | X-ROW | SSP0200_ShipmentChangeRequest.GetErpSoNo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0809 | X-ROW | SSP0200_ShipmentChangeRequest.GetItemFro | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:1 · NA:1 · REVIEW:1 · NOPATH:1 · PASS:1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetIte) |
| WK-SSP0200-0810 | X-ROW | SSP0200_ShipmentChangeRequest.GetPlantSi | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:1 · NA:1 · REVIEW:1 · NOPATH:1 · PASS:1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetPla) |
| WK-SSP0200-0811 | X-ROW | SSP0200_ShipmentChangeRequest.GetShipmen | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:1 · NA:1 · REVIEW:1 · NOPATH:1 · PASS:1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetShi) |
| WK-SSP0200-0812 | X-ROW | SSP0200_ShipmentChangeRequest.InitContro | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 21검사 — PASS:12 · NA:7 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0813 | X-ROW | SSP0200_ShipmentChangeRequest.SetChangeC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:3 · NA:2 · PASS:1 |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0814 | X-ROW | SSP0200_ShipmentChangeRequest.SetChangeR | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 20검사 — ERROR:11 · NA:9 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0815 | X-ROW | SSP0200_ShipmentChangeRequest.SetChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — NA:4 · PASS:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0816 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_Cu | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · ERROR:1 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0817 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_To | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0818 | X-ROW | SSP0200_ShipmentChangeRequest.btnInsertM | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:9 |  | 4 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0819 | X-ROW | SSP0200_ShipmentChangeRequest.btnItemId_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:6 · PASS:3 · NA:2 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.btnIte) |
| WK-SSP0200-0820 | X-ROW | SSP0200_ShipmentChangeRequest.clbDivisio | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.clbDiv) |
| WK-SSP0200-0821 | X-ROW | SSP0200_ShipmentChangeRequest.setEndCust | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — ERROR:11 · NOPATH:3 · NA:2 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.setEnd) |
| WK-SSP0200-0822 | X-ROW | SSP0200_ShipmentChangeRequestInsertPopup | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — WARN:1 · ERROR:1 |  | 2 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0823 | X-ROW | SSP0200_ShipmentChangeRequestInsertPopup | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0824 | X-ROW | SSP0200_ShipmentChangeRequestInsertPopup | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0825 | X-ROW | SSP0200_ShipmentChangeRequestInsertPopup | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0826 | G5 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | G5 도구 오류 — 원장 V-f90d7a4a ASIS / 원장 V-f255983d ASIS |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0827 | G5 | R-70 D11~D16 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 R-70 D11~D16 '`cellTypeImage` 경로별 차이' 의 G5 32요소: NA:14 · NOPATH:8 · ERROR:8 · PASS:2 |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0828 | G5 | SSP0200_ShipmentChangeRequestInsertPopup | 하네스·환경 | G5 도구 오류 — 원장 V-8eeb190a ASIS |  | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0829 | G5 | new SCM0002_ShipmentPlanRequestPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-f90d7a4a |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0830 | G5 | new SSP0002_UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-db5ac9ce |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnApp) |
| WK-SSP0200-0831 | G5 | new SSP0200_ShipmentChangeRequestInsertP | 하네스·환경 | G5 도구 오류 — 원장 V-8eeb190a |  | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0832 | G5 | pop.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-f255983d |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0833 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-e7e6c2a1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnApp) |
| WK-SSP0200-0834 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-2f7e74e8 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0835 | H6 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | H6 도구 오류 — 원장 V-c136839c ASIS / 원장 V-1ac5006b ASIS |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0836 | H6 | ERP_SO_NO / SO No | 하네스·환경 | H6 도구 오류 — 원장 V-1829e87e ASIS / 원장 V-51e5857a ASIS / 원장 V-5c849204 ASIS |  | 12 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0837 | H6 | ITEM_ID / Model | 하네스·환경 | H6 도구 오류 — 원장 V-0e1c11f1 ASIS / 원장 V-ed200438 ASIS / 원장 V-24e9e183 ASIS / 원장 V-a64ce32b ASIS / 원장 V-65985bd2 ASIS / 원장 V-6c94b91e  |  | 74 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0838 | H6 | Item | 하네스·환경 | H6 도구 오류 — 원장 V-0e1c11f1 ASIS / 원장 V-ed200438 ASIS / 원장 V-24e9e183 ASIS / 원장 V-51e5857a ASIS / 원장 V-5ee0749e ASIS / 원장 V-473744a6  |  | 22 (Model 팝업 R-52 ACT:SSP0200_ShipmentChange) |
| WK-SSP0200-0839 | H6 | PROJECT_CODE / Project Code | 하네스·환경 | H6 도구 오류 — 원장 V-a64ce32b ASIS / 원장 V-65985bd2 ASIS / 원장 V-6c94b91e ASIS / 원장 V-1829e87e ASIS / 원장 V-51e5857a ASIS / 원장 V-5c849204  |  | 44 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0840 | H6 | R-70 D11~D16 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 R-70 D11~D16 '`cellTypeImage` 경로별 차이' 의 H6 32요소: ERROR:23 · NOPATH:8 · PASS:1 |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0841 | H6 | SSP0200_ShipmentChangeRequestInsertPopup | 하네스·환경 | H6 도구 오류 — 원장 V-ea0fcc20 ASIS |  | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0842 | H6 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-0e1c11f1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0843 | H6 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-5ee0749e |  | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIte) |
| WK-SSP0200-0844 | H6 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-a64ce32b |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0845 | H6 | new SCM0002_ShipmentPlanRequestPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-c136839c |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0846 | H6 | new SSP0002_UserInfoPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-e5273b72 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnApp) |
| WK-SSP0200-0847 | H6 | new SSP0200_ShipmentChangeRequestInsertP | 하네스·환경 | H6 도구 오류 — 원장 V-ea0fcc20 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0848 | H6 | new SSP0300_OrderDetailPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-1829e87e |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0849 | H6 | pop.Form_Load(_DivisionID, _ErpSoNo, _Co | 하네스·환경 | H6 도구 오류 — 원장 V-51e5857a |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0850 | H6 | pop.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-1ac5006b |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0851 | H6 | pop.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-5c849204 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0852 | H6 | popItem.Form_Load(false, sdivision, sScm | 하네스·환경 | H6 도구 오류 — 원장 V-ed200438 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0853 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-24e9e183 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0854 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-2ae319bf |  | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIte) |
| WK-SSP0200-0855 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-65985bd2 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0856 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-6c94b91e |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0857 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-2b73b8cf |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnApp) |
| WK-SSP0200-0858 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-801a1a53 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0859 | M3 | Item | 하네스·환경 | M3 도구 오류 — 원장 V-944ca4c7 ASIS / 원장 V-b538c26e ASIS |  | 18 (ACT:Item.ClassToItem ACT:Item.ClassToIte) |
| WK-SSP0200-0860 | M3 | SSP0200_ShipmentChangeRequestInsertPopup | 하네스·환경 | M3 도구 오류 — 원장 V-def2bad0 ASIS |  | 6 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0861 | M3 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-944ca4c7 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0862 | M3 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-b538c26e |  | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIte) |
| WK-SSP0200-0863 | M3 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-49332fe5 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0864 | M3 | new SCM0002_ShipmentPlanRequestPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-030ae2aa |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0865 | M3 | new SSP0002_UserInfoPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-350f1b89 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnApp) |
| WK-SSP0200-0866 | M3 | new SSP0200_ShipmentChangeRequestInsertP | 하네스·환경 | M3 도구 오류 — 원장 V-def2bad0 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0867 | M4 | CONFIRM_ID / Confirm/Plan ID | 하네스·환경 | M4 도구 오류 — 실측[T-1c6e838b]: [검사기 미검증] PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0868 | M4 | DIVISION_ID / Div | 하네스·환경 | M4 도구 오류 — 실측[T-2c9b82f8]: [검사기 미검증] PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0869 | M4 | ERP_SO_NO / SO No | 하네스·환경 | M4 도구 오류 — 실측[T-71719ea0]: [검사기 미검증] PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 12 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0870 | M4 | FROM_SITE / From Site ID | 하네스·환경 | M4 도구 오류 — 실측[T-9b757792]: [검사기 미검증] PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (R-28) |
| WK-SSP0200-0871 | M4 | FROM_SITE_DESCRIPTION / From Site | 하네스·환경 | M4 도구 오류 — 실측[T-50eeec63]: [검사기 미검증] PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0872 | M4 | ITEM_ID / Model | 하네스·환경 | M4 도구 오류 — 실측[T-3071b062]: [검사기 미검증] ITEM_ID: PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 74 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0873 | M4 | NICK_NAME / Nick Name | 하네스·환경 | M4 도구 오류 — 실측[T-fc0b0cd9]: [검사기 미검증] NICK_NAME: PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0874 | M4 | PROJECT_CODE / Project Code | 하네스·환경 | M4 도구 오류 — 실측[T-906d6765]: [검사기 미검증] PROJECT_CODE: PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 44 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0875 | M4 | PROJECT_NAME / Project Name | 하네스·환경 | M4 도구 오류 — 실측[T-89d421e9]: [검사기 미검증] PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (R-31⑥⑦) |
| WK-SSP0200-0876 | M4 | R-70 D11~D16 | 하네스·환경 | M4 도구 오류 — 실측[T-6a435b2d]: [검사기 미검증] PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0877 | M4 | TO_SITE / To Site ID | 하네스·환경 | M4 도구 오류 — 실측[T-ee3ed435]: [검사기 미검증] PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (R-28) |
| WK-SSP0200-0878 | M4 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | M4 도구 오류 — 실측[T-fd3bb664]: [검사기 미검증] PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (R-28 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0879 | M4 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | M4 도구 오류 — 실측[T-e321d8f5]: [검사기 미검증] PROJECT_CODE 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (R-31⑥⑦) |
