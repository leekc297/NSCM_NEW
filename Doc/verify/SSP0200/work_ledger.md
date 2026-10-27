# 작업 원장 — SSP0200 · 2026-10-26 13:00

> 검사 인스턴스 1051건 중 PASS·NA 45건 외 **1006건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 13 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 33 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 11 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 67 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 419 | 실행 → PASS |
| W7 | 기대값 확정 | 433 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 29 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 432 · E2E 419 · 하네스 78 · 대조표 34 · 선행 W1 완료 후 E2E 24 · FE 12 · 선행 W1 완료 후 검증 5 · DB 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 8건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 33 |  |  |  |  | 70 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 86 | 17 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  |  |  |  |  | 77 | 1 |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A5 | DESIGN |  |  |  |  |  | 32 | 27 | 5 |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 34 | 25 | 5 |  | 라벨 명칭 |
| H2 | DESIGN |  |  |  |  |  | 32 | 26 | 5 |  | 배경·글자색 규칙 |
| C3 | CASCADE |  |  |  |  |  | 40 | 11 |  |  | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 12 | 30 | 1 |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 39 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G4 | DESIGN |  |  |  |  | 6 | 9 | 17 | 1 |  | 조회조건 표시·라벨·활성 |
| B4 | COMBO |  |  |  |  | 14 |  | 13 | 1 |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D5 | EDIT |  |  |  |  |  | 25 | 2 |  |  | 셀 에디터 유형 |
| G6 | GEN |  |  |  |  |  | 9 | 17 | 1 |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F4 | DB |  |  |  |  |  | 17 | 8 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B3 | COMBO |  |  |  | 11 |  |  | 12 | 1 |  | 콤보 후보 정렬 = AS-IS |
| D1 | EDIT |  |  |  |  |  | 17 | 7 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 17 | 7 |  |  | 행 값 기반 조건부 잠금 |
| C2 | CASCADE |  |  |  |  |  | 20 | 3 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 20 | 3 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G5 | POPUP |  |  |  |  | 14 |  | 1 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 14 |  | 1 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 14 | 1 |  |  | 팝업 선택값 반영 |
| A6 | GEN |  |  |  |  |  | 8 |  | 6 |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-NOTIMPL | GEN | 13 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| DB-SYN | DB |  |  |  |  | 5 |  | 7 |  |  | BE 계정 시노님·권한·대상 객체 |
| D4 | EDIT |  |  |  |  |  | 3 | 6 | 1 |  | 신규행 기본값·자동세팅·Insert 전제 |
| B1 | COMBO |  |  |  |  | 5 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 5 |  | 1 |  |  | 콤보 후보 중복 없음 |
| C1 | CASCADE |  |  |  |  |  | 5 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| E1 | EDIT |  |  |  |  |  | 3 | 2 |  |  | 숫자 소수자리·정수·부호·범위 |
| E5 | EDIT |  |  |  |  | 1 |  | 1 |  |  | 콤보 셀 후보 외 값 차단 |
| H3 | DESIGN |  |  |  |  |  | 1 |  | 1 |  | 셀 병합 = AS-IS |
| M3 | POPUP |  |  |  |  |  | 2 |  |  |  | 팝업 내부 기능(조회·CRUD) |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-REASON | DESIGN |  |  |  |  |  |  | 1 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |

## W1 기능 구현 (13)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0001 | X-NOTIMPL | **C4** | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — **C4** `JVFlag = dtMyDivision[ATTRIBUTE1] == '0'` **미구현(false 고정)** — 원천 `SSP0200_GET_SHIPMENT_DIVISION` 미이관. 대체 콤보 |  | 1 (**C4**) |
| WK-SSP0200-0002 | X-NOTIMPL | **L-065·L-070·L-071** | DB(🛠️/🧯 적용 가능) | 대조표 미구현 행 구현 — **L-065·L-070·L-071** `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` · `SCM_SSP_DELETE_..._BY_CONFIRM` · `PR_SSP_XIF_..._IFSE |  | 1 (**L-065·L-070·L-071**) |
| WK-SSP0200-0003 | X-NOTIMPL | **R-30** | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — **R-30** `CHK` 헤더 전체선택 8건 **미구현** — shtMain 에 `CHK` 컬럼이 없고(메타 실측) `spdSub` 이벤트 배선도 0건이라 **AS-IS 동작 여부가 불명**(설계 §6 # |  | 1 (**R-30**) |
| WK-SSP0200-0004 | X-NOTIMPL | L-066 ~ L-069 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — L-066 ~ L-069 `DELETE_..._DRAFTING` / `GET_SHIPMENT_STATUS` / `GET_ERP_SO_NO_CNT` 배선 메타(`05_register.sql` API 6행)만  |  | 1 (L-066 ~ L-069) |
| WK-SSP0200-0005 | X-NOTIMPL | L-149·L-150 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — L-149·L-150 `CHANGE_REQ_DAY`(`D`/`-56`) → `dDay` → `dBaseDate = 오늘 + dDay` **미구현** — 출하일 하한 검증(`MSG00194`)의 기준일. in |  | 1 (L-149·L-150) |
| WK-SSP0200-0006 | X-NOTIMPL | L-151 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — L-151 `SHIPMENT_PERIOD_DAY`(`1D+`=56 / `2D-`=30) → 출하일 상·하한 없음 미구현 — inner-table 환산식(설계 R-3) 미확정 + 콤보 `SHIPMENT_PER |  | 1 (L-151) |
| WK-SSP0200-0007 | X-NOTIMPL | R-31① | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — R-31① `RollBack_Flag` 포커스 복귀 미구현 — 셀 롤백 시 Wijmo 기본 동작에 맡겼다 미구현 |  | 1 (R-31①) |
| WK-SSP0200-0008 | X-NOTIMPL | R-60 C12·C13 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — R-60 C12·C13 `GetItemFromBOD` 전극 판정 미구현(SP 미이관) 미구현(SP) |  | 1 (R-60 C12·C13) |
| WK-SSP0200-0009 | X-NOTIMPL | R-60 C7~C9 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — R-60 C7~C9 원본 스냅샷 대조 미구현 — 확정 체인(SP 미이관)과 함께 보류 미구현 |  | 1 (R-60 C7~C9) |
| WK-SSP0200-0010 | X-NOTIMPL | R-70 D17 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — R-70 D17 `CharacterCasing.Upper`(ITEM_ID/PROJECT_CODE 대문자 강제) **미구현** — 메타 `UPPERCASE_APPLY_FLAG` 가 124행 전건 `'-'` 라 |  | 1 (R-70 D17) |
| WK-SSP0200-0011 | X-NOTIMPL | R-70 D18 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — R-70 D18 `SuspendLayout`/`ResumeLayout` Wijmo `deferUpdate` 미적용 — 현재 대량 갱신 경로(다건 삽입)가 루프 1건 단위라 체감 영향 없음 미구현(성능) |  | 1 (R-70 D18) |
| WK-SSP0200-0012 | X-NOTIMPL | R-70 D3·D6 | DB(🛠️/🧯 적용 가능) | 대조표 미구현 행 구현 — R-70 D3·D6 수량 라벨 동적 교체 **미구현** — `Shipment Plan Qty`/`Shipment Confirm Qty` 둘 다 TO-BE `SCM_ADM_MSG_M` **0행**(신규 등록  |  | 1 (R-70 D3·D6) |
| WK-SSP0200-0013 | X-NOTIMPL | R-70 D7·D8 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — R-70 D7·D8 shtSub CHK 헤더 체크박스 + 장식 Border 미구현(R-30) / Border 는 장식이라 미이식 미구현 |  | 1 (R-70 D7·D8) |

## W2 구현 위치 확인 (33)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0014 | X-LOC | **C1** | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**C1**) |
| WK-SSP0200-0015 | X-LOC | **C2·C3** | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**C2·C3**) |
| WK-SSP0200-0016 | X-LOC | **C5** | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**C5**) |
| WK-SSP0200-0017 | X-LOC | 9필드 인벤토리 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9필드 인벤토리) |
| WK-SSP0200-0018 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: DataGrid.tsx 없음, MainGrid.tsx 없음, SearchArea.tsx 없음, SubTitle.tsx 없음 |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0019 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: hooks/useShipmentChangeRequestPlanToolbar.ts:57-57 > 54줄 |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0020 | X-LOC | Designer 잔여 초기값 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Designer 잔여 초기값) |
| WK-SSP0200-0021 | X-LOC | MSG00173(요청완료 안내) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00173(요청완료 안내)) |
| WK-SSP0200-0022 | X-LOC | MSG00202(수량 0) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00202(수량 0)) |
| WK-SSP0200-0023 | X-LOC | MSG00247(SO 부분선택) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00247(SO 부분선택)) |
| WK-SSP0200-0024 | X-LOC | MSG00261(저장결과 'N') | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00261(저장결과 'N')) |
| WK-SSP0200-0025 | X-LOC | MSG00293(Trans Mode 콤보 미로드) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00293(Trans Mode 콤보 미로드)) |
| WK-SSP0200-0026 | X-LOC | MSG00429 사용처(Change Reason 미선택) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00429 사용처(Change Reason 미선택)) |
| WK-SSP0200-0027 | X-LOC | Model 팝업 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Model 팝업) |
| WK-SSP0200-0028 | X-LOC | Period 기본값 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Period 기본값) |
| WK-SSP0200-0029 | X-LOC | R-01·R-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: MainGrid.tsx 없음, SubGrid.tsx 없음 |  | 1 (R-01·R-02) |
| WK-SSP0200-0030 | X-LOC | `ChangeType='A'` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`ChangeType='A'`) |
| WK-SSP0200-0031 | X-LOC | `Convert.ToDateTime(...).ToString("yyyy- | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`Convert.ToDateTime(...).ToString("yyyy-) |
| WK-SSP0200-0032 | X-LOC | `FoxDataRequest("SSP.SSP0200_SAVE_SHIPME | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`FoxDataRequest("SSP.SSP0200_SAVE_SHIPME) |
| WK-SSP0200-0033 | X-LOC | `GetNewERPInterface()` 실패 시 `MessageBox( | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`GetNewERPInterface()` 실패 시 `MessageBox() |
| WK-SSP0200-0034 | X-LOC | `ds.Tables[0].Rows[0][0] == "S"/"N"/"F"/ | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`ds.Tables[0].Rows[0][0] == "S"/"N"/"F"/) |
| WK-SSP0200-0035 | X-LOC | `if (action != CAppSetting.FlagI) contin | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`if (action != CAppSetting.FlagI) contin) |
| WK-SSP0200-0036 | X-LOC | `p_a_conuntry` (원문 오타) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`p_a_conuntry` (원문 오타)) |
| WK-SSP0200-0037 | X-LOC | `p_lt/p_route_id/p_bod_id/p_d_*/p_a_*/p_ | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`p_lt/p_route_id/p_bod_id/p_d_*/p_a_*/p_) |
| WK-SSP0200-0038 | X-LOC | `p_project_code40 ← END_CUSTOMER` / `p_p | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`p_project_code40 ← END_CUSTOMER` / `p_p) |
| WK-SSP0200-0039 | X-LOC | `txtItemId`(F1) · FCST Type(B4/F8) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`txtItemId`(F1) · FCST Type(B4/F8)) |
| WK-SSP0200-0040 | X-LOC | cascade 5단계 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cascade 5단계) |
| WK-SSP0200-0041 | X-LOC | payload 12키 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (payload 12키) |
| WK-SSP0200-0042 | X-LOC | shtSub 2단 헤더 'P' 분기 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (shtSub 2단 헤더 'P' 분기) |
| WK-SSP0200-0043 | X-LOC | 자동조회 금지 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (자동조회 금지) |
| WK-SSP0200-0044 | X-LOC | 저장 성공 toast | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (저장 성공 toast) |
| WK-SSP0200-0045 | X-LOC | 초기 mount 무발화 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (초기 mount 무발화) |
| WK-SSP0200-0046 | X-LOC | 필드 수 > 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (필드 수 > 6) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0047 | H10 | SSP0200 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SSP0200 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: ShipmentChangeRequestPlan.tsx, components/ShipmentChangeRequestPlanF |  | 33 (L-083·L-089 L-087 L-090 ~ L-121 **L-127·) |

## W4 검사기 구현 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0048 | B3 | ATTRIBUTE10 | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ATTRIBUTE10 | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0200_ShipmentChangeRequest.GetNew) |
| WK-SSP0200-0049 | B3 | CHANGE_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CHANGE_TYPE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0050 | B3 | CONFIRM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CONFIRM_ID | 있음(SHEET_COLUMNS) | 13 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0051 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 7 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0052 | B3 | EDIT_MAIN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 EDIT_MAIN | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0053 | B3 | ERP_SO_NO | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ERP_SO_NO | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0054 | B3 | FROM_SITE_DESCRIPTION | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0055 | B3 | SHIPMENT_DATE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 7 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0056 | B3 | SHIPMENT_STATUS | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0057 | B3 | chkSingleProcess / Single Process | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 chkSingleProcess / Single Process | 있음(FE 소스) | 3 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0058 | B3 | clbDivision_ID / Div / Division_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision_ID / Div / Division_ID | 있음(FE 소스) | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |

## W5 검사기 연결 (67)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0059 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0060 | B1 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 3 (R-26 ACT:SSP0200_ShipmentChangeRequest.s) |
| WK-SSP0200-0061 | B1 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0062 | B1 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0063 | B1 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0064 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0065 | B2 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 3 (R-26 ACT:SSP0200_ShipmentChangeRequest.s) |
| WK-SSP0200-0066 | B2 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0067 | B2 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0068 | B2 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0069 | B4 | ATTRIBUTE10 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ATTRIBUTE10 | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0200_ShipmentChangeRequest.GetNew) |
| WK-SSP0200-0070 | B4 | CHANGE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CHANGE_TYPE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0071 | B4 | CONFIRM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CONFIRM_ID | 있음(SHEET_COLUMNS) | 13 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0072 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 13 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0073 | B4 | EDIT_MAIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL EDIT_MAIN | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0074 | B4 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 3 (R-26 ACT:SSP0200_ShipmentChangeRequest.s) |
| WK-SSP0200-0075 | B4 | ERP_SO_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ERP_SO_NO | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0076 | B4 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0077 | B4 | SHIPMENT_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 7 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0078 | B4 | SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0079 | B4 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0080 | B4 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0081 | B4 | chkSingleProcess / Single Process | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND chkSingleProcess / Single Process | 있음(FE 소스) | 3 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0082 | B4 | clbDivision_ID / Div / Division_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision_ID / Div / Division_ID | 있음(FE 소스) | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0083 | F2 | SSP0200 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0200 화면 | 판단불가(대상 단위 SCREEN) | 365 (L-073 L-079·L-082·L-102 L-081 R-41 MSG00) |
| WK-SSP0200-0084 | F6 | SSP0200 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0200 화면 | 판단불가(대상 단위 SCREEN) | 350 (`FoxDataRequest("SSP.SSP0200_SAVE_SHIPME) |
| WK-SSP0200-0085 | DB-SYN | PKG_SSP0200 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SSP0200 | 없음(PROC_M 대응 없음) | 1 (L-064) |
| WK-SSP0200-0086 | DB-SYN | SSP0200_GET_ITEM_FROM_BOD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_ITEM_FROM_BOD | 없음(PROC_M 대응 없음) | 3 (R-27 ACT:SSP0200_ShipmentChangeRequest.G) |
| WK-SSP0200-0087 | DB-SYN | SSP0200_GET_SHIPMENT_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_SHIPMENT_DIVISION | 없음(PROC_M 대응 없음) | 3 (**C4** ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0088 | DB-SYN | SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVIS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPE | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0200_ShipmentChangeRequest.GetPla) |
| WK-SSP0200-0089 | DB-SYN | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 없음(PROC_M 대응 없음) | 3 (ACT:SSP0200_ShipmentChangeRequest.GetDiv) |
| WK-SSP0200-0090 | G4 | btnApprovalUser | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnApprovalUser | 있음(FE 소스) | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0091 | G4 | btnCancel | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnCancel | 없음 | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0092 | G4 | btnChangeRe2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnChangeRe2 | 없음 | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0093 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0094 | G4 | btnNew | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNew | 있음(FE 소스) | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0095 | G4 | btnSave | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSave | 있음(FE 소스) | 2 (ACT:SSP0200_ShipmentChangeRequest.InitEv) |
| WK-SSP0200-0096 | E5 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 1 (R-26) |
| WK-SSP0200-0097 | G03-WIRE | SSP0200 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0200 화면 | 판단불가(대상 단위 SCREEN) | 25 (ACT:SSP0200_ShipmentChangeRequest..ctor ) |
| WK-SSP0200-0098 | G5 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0099 | G5 | ERP_SO_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ERP_SO_NO | 있음(SHEET_COLUMNS) | 12 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0100 | G5 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 1 (R-28) |
| WK-SSP0200-0101 | G5 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0102 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 74 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0103 | G5 | Item | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP Item | 판단불가(대상 단위 POPUP) | 22 (Model 팝업 R-52 ACT:SSP0200_ShipmentChange) |
| WK-SSP0200-0104 | G5 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0105 | G5 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 44 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0106 | G5 | PROJECT_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PROJECT_NAME | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0107 | G5 | SSP0200_ShipmentChangeRequestInsertPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SSP0200_ShipmentChangeRequestInsertPopup | 판단불가(대상 단위 POPUP) | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0108 | G5 | TO_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL TO_SITE | 있음(SHEET_COLUMNS) | 1 (R-28) |
| WK-SSP0200-0109 | G5 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 4 (R-28 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0110 | G5 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0111 | G5 | btnApprovalUser | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnApprovalUser | 있음(FE 소스) | 1 (L-020 ~ L-023·L-024·L-026·**L-078·L-125*) |
| WK-SSP0200-0112 | H6 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0113 | H6 | ERP_SO_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ERP_SO_NO | 있음(SHEET_COLUMNS) | 12 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0114 | H6 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 1 (R-28) |
| WK-SSP0200-0115 | H6 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0116 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 74 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0117 | H6 | Item | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP Item | 판단불가(대상 단위 POPUP) | 22 (Model 팝업 R-52 ACT:SSP0200_ShipmentChange) |
| WK-SSP0200-0118 | H6 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0119 | H6 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 44 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0120 | H6 | PROJECT_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_NAME | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0121 | H6 | SSP0200_ShipmentChangeRequestInsertPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SSP0200_ShipmentChangeRequestInsertPopup | 판단불가(대상 단위 POPUP) | 1 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0122 | H6 | TO_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_SITE | 있음(SHEET_COLUMNS) | 1 (R-28) |
| WK-SSP0200-0123 | H6 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 4 (R-28 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0124 | H6 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 1 (R-31⑥⑦) |
| WK-SSP0200-0125 | H6 | btnApprovalUser | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnApprovalUser | 있음(FE 소스) | 1 (L-020 ~ L-023·L-024·L-026·**L-078·L-125*) |

## W6 검증 실행 (419)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0126 | J2 | SSP0200 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0200 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 190 (설계 정본 L-016 ~ L-019·**L-148** L-047 ~ L-) |
| WK-SSP0200-0127 | C1 | cboChangeType / Change Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboChangeType / Change Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0128 | C1 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0129 | C1 | clbDivision_ID / Div / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetDiv) |
| WK-SSP0200-0130 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0131 | C1 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0132 | C2 | BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — BOD_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0133 | C2 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 24 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0134 | C2 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0135 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 36 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0136 | C2 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0137 | C2 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0138 | C2 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0139 | C2 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0140 | C2 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-14) |
| WK-SSP0200-0141 | C2 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 29 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0142 | C2 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 35 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0143 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0144 | C2 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0145 | C2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0146 | C2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0147 | C2 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0148 | C2 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0149 | C2 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-14) |
| WK-SSP0200-0150 | C2 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 22 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0151 | C2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 70 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0152 | C3 | BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BOD_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (R-14 ACT:SSP0200_ShipmentChangeRequest.F) |
| WK-SSP0200-0153 | C3 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 28 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0154 | C3 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0155 | C3 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0156 | C3 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0157 | C3 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0158 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 43 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0159 | C3 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 20 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0160 | C3 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 16 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0161 | C3 | ERP_ATTR1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ERP_ATTR1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0162 | C3 | ERP_ATTR2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ERP_ATTR2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0163 | C3 | ERP_ATTR3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ERP_ATTR3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0164 | C3 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 18 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0165 | C3 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0166 | C3 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (R-14) |
| WK-SSP0200-0167 | C3 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 31 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0168 | C3 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 35 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0169 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 19 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0170 | C3 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0171 | C3 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0172 | C3 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0173 | C3 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0174 | C3 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0175 | C3 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0176 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0177 | C3 | PLAN_CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLAN_CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SetMai) |
| WK-SSP0200-0178 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 15 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0179 | C3 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0180 | C3 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 21 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0181 | C3 | REMARKS2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REMARKS2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0182 | C3 | REMARKS3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REMARKS3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0183 | C3 | REQUEST_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REQUEST_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SetMai) |
| WK-SSP0200-0184 | C3 | REQUEST_USER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REQUEST_USER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0185 | C3 | REQUEST_USER_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REQUEST_USER_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0186 | C3 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 21 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0187 | C3 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0188 | C3 | STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetSta) |
| WK-SSP0200-0189 | C3 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (R-14) |
| WK-SSP0200-0190 | C3 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 26 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0191 | C3 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 73 (R-14 ACT:SSP0200_ShipmentChangeRequest.F) |
| WK-SSP0200-0192 | C6 | BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — BOD_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0193 | C6 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 24 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0194 | C6 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0195 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 36 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0196 | C6 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0197 | C6 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0198 | C6 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0199 | C6 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0200 | C6 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-14) |
| WK-SSP0200-0201 | C6 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 29 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0202 | C6 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 35 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0203 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0204 | C6 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0205 | C6 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0206 | C6 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0207 | C6 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0208 | C6 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0209 | C6 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-14) |
| WK-SSP0200-0210 | C6 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 22 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0211 | C6 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 70 (R-14 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0212 | G3 | SSP0200 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0200 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 9 (L-002·L-003·L-005 L-057 COMMON:UC-01 COM) |
| WK-SSP0200-0213 | K-SA | SSP0200 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0200 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 3 (L-002·L-003·L-005 L-057 COMMON:UC-02) |
| WK-SSP0200-0214 | K4 | SSP0200 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0200 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 142 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SSP0200-0215 | F1 | SSP0200 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0200 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 367 (L-073 **L-074** L-079·L-082·L-102 L-081 ) |
| WK-SSP0200-0216 | F3 | SSP0200 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SSP0200 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 14 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0217 | F5 | SSP0200 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0200 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (**L-074** R-60 C10) |
| WK-SSP0200-0218 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (Period 기본값 ACT:SSP0200_ShipmentChangeReq) |
| WK-SSP0200-0219 | F4 | PKG_SSP0026.P_SSP0026_GET_BOD_ITEM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0026.P_SSP0026_GET_BOD_ITEM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 31 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0220 | F4 | PKG_SSP0200 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (L-064) |
| WK-SSP0200-0221 | F4 | PKG_SSP0200.P_SSP0200_DELETE_SHIPMENT_RE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_DELETE_SHIPMENT_REQUEST_DRAF · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 192 (ACT:SSP0200_ShipmentChangeRequest.Delete) |
| WK-SSP0200-0222 | F4 | PKG_SSP0200.P_SSP0200_GET_CHANGE_REQ_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_GET_CHANGE_REQ_NO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 187 (L-064 ACT:SSP0200_ShipmentChangeRequest.) |
| WK-SSP0200-0223 | F4 | PKG_SSP0200.P_SSP0200_GET_ERP_SO_NO_CNT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_GET_ERP_SO_NO_CNT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 189 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0224 | F4 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 403 (ACT:SSP0200_ShipmentChangeRequest.Delete) |
| WK-SSP0200-0225 | F4 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_ · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 228 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0226 | F4 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTIN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 407 (ACT:SSP0200_ShipmentChangeRequest.Delete) |
| WK-SSP0200-0227 | F4 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_STATU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_STATUS · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 189 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0228 | F4 | PKG_SSP0200.P_SSP0200_SAVE_SHIPMENT_CONF | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_SAVE_SHIPMENT_CONFIRM_NEW · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — |  | 186 (`FoxDataRequest("SSP.SSP0200_SAVE_SHIPME) |
| WK-SSP0200-0229 | F4 | PKG_SSP0200.P_SSP0200_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_SAVE_SHIPMENT_REQUEST_COMPLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 159 (ACT:SSP0200_ShipmentChangeRequest.SaveDa) |
| WK-SSP0200-0230 | F4 | PKG_SSP0200.P_SSP0200_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTI · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 6 (ACT:SSP0200_ShipmentChangeRequest.NewNon) |
| WK-SSP0200-0231 | F4 | SSP0200_GET_ITEM_FROM_BOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0200_GET_ITEM_FROM_BOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 3 (R-27 ACT:SSP0200_ShipmentChangeRequest.G) |
| WK-SSP0200-0232 | F4 | SSP0200_GET_SHIPMENT_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0200_GET_SHIPMENT_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 3 (**C4** ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0233 | F4 | SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVIS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetPla) |
| WK-SSP0200-0234 | F4 | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 3 (ACT:SSP0200_ShipmentChangeRequest.GetDiv) |
| WK-SSP0200-0235 | A5 | BOD_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — BOD_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-14) |
| WK-SSP0200-0236 | A5 | CHANGE_REQ_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0237 | A5 | CHK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHK · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (**R-30** R-70 D7·D8 R-70 D9 ACT:SSP0200_) |
| WK-SSP0200-0238 | A5 | CONFIRM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0239 | A5 | EDIT_MAIN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-19) |
| WK-SSP0200-0240 | A5 | END_CUSTOMER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (R-26 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0241 | A5 | ERP_ATTR1 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_ATTR1 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0242 | A5 | ERP_ATTR2 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_ATTR2 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0243 | A5 | ERP_ATTR3 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_ATTR3 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0244 | A5 | ERP_SO_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0245 | A5 | ERP_STATUS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_STATUS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-25) |
| WK-SSP0200-0246 | A5 | ETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ETA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0247 | A5 | ETD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ETD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0248 | A5 | FROM_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (R-14 R-28) |
| WK-SSP0200-0249 | A5 | INCOTERMS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (R-14 R-15·R-16) |
| WK-SSP0200-0250 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (R-31⑥⑦ R-70 D17 ACT:SSP0200_ShipmentChan) |
| WK-SSP0200-0251 | A5 | LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0252 | A5 | NEW_ETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0253 | A5 | NEW_ETD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0254 | A5 | NEW_LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (R-22 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0255 | A5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0256 | A5 | NEW_SHIPMENT_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0257 | A5 | NEW_TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0258 | A5 | NICK_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-31⑥⑦) |
| WK-SSP0200-0259 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 7 (R-31⑥⑦ R-70 D17 ACT:SSP0200_ShipmentChan) |
| WK-SSP0200-0260 | A5 | PROJECT_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0261 | A5 | REMARKS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — REMARKS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (R-70 D10 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0262 | A5 | SHIPMENT_CONFIRM_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Div |  | 6 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0263 | A5 | SHIPMENT_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (R-22 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0264 | A5 | TO_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (R-14 R-28) |
| WK-SSP0200-0265 | A5 | TO_SITE_DESCRIPTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-28) |
| WK-SSP0200-0266 | A5 | TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (R-14 R-17 R-31⑥⑦ ACT:SSP0200_ShipmentCha) |
| WK-SSP0200-0267 | G4 | cboChangeReason / Change Reason | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboChangeReason / Change Reason · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0268 | G4 | cboChangeType / Change Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboChangeType / Change Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 48 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0269 | G4 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboStatus / Status · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0270 | G4 | clbDivision_ID / Div / Division_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 18 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0271 | G4 | drpPeriod / Shipment Date / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Shipment Date / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0272 | G4 | dtDate / Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — dtDate / Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0273 | G4 | txtItemId / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (`txtItemId`(F1) · FCST Type(B4/F8)) |
| WK-SSP0200-0274 | G4 | txtRequestDeptName / Dept Name / Request | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtRequestDeptName / Dept Name / Request Dept Name · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0275 | G4 | txtRequestor / Requestor | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtRequestor / Requestor · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0276 | H2 | BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — BOD_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-14) |
| WK-SSP0200-0277 | H2 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (**R-30** R-70 D7·D8 R-70 D9 ACT:SSP0200_) |
| WK-SSP0200-0278 | H2 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0279 | H2 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-19) |
| WK-SSP0200-0280 | H2 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (R-26 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0281 | H2 | ERP_ATTR1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_ATTR1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0282 | H2 | ERP_ATTR2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_ATTR2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0283 | H2 | ERP_ATTR3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_ATTR3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0284 | H2 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0285 | H2 | ERP_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-25) |
| WK-SSP0200-0286 | H2 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0287 | H2 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0288 | H2 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R-14 R-28) |
| WK-SSP0200-0289 | H2 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R-14 R-15·R-16) |
| WK-SSP0200-0290 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R-31⑥⑦ R-70 D17) |
| WK-SSP0200-0291 | H2 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0292 | H2 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0293 | H2 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0294 | H2 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (R-22 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0295 | H2 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0296 | H2 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0297 | H2 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0298 | H2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-31⑥⑦) |
| WK-SSP0200-0299 | H2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (R-31⑥⑦ R-70 D17 ACT:SSP0200_ShipmentChan) |
| WK-SSP0200-0300 | H2 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0301 | H2 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (R-70 D10 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0302 | H2 | REMARKS2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REMARKS2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0303 | H2 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0304 | H2 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (R-22 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0305 | H2 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R-14 R-28) |
| WK-SSP0200-0306 | H2 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-28) |
| WK-SSP0200-0307 | H2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (R-14 R-17 R-31⑥⑦ ACT:SSP0200_ShipmentCha) |
| WK-SSP0200-0308 | H3 | CHK | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — CHK · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (R-70 D9) |
| WK-SSP0200-0309 | H4 | SSP0200 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0200 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (R-41 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0310 | H5 | BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — BOD_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-14) |
| WK-SSP0200-0311 | H5 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHK · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (**R-30** R-70 D7·D8 R-70 D9 ACT:SSP0200_) |
| WK-SSP0200-0312 | H5 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CONFIRM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0313 | H5 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — EDIT_MAIN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-19) |
| WK-SSP0200-0314 | H5 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — END_CUSTOMER · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (R-26 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0315 | H5 | ERP_ATTR1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_ATTR1 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0316 | H5 | ERP_ATTR2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_ATTR2 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0317 | H5 | ERP_ATTR3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_ATTR3 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0318 | H5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_SO_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0319 | H5 | ERP_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_STATUS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-25) |
| WK-SSP0200-0320 | H5 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ETA · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0321 | H5 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ETD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0322 | H5 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FROM_SITE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (R-14 R-28) |
| WK-SSP0200-0323 | H5 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — INCOTERMS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (R-14 R-15·R-16) |
| WK-SSP0200-0324 | H5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (R-31⑥⑦ R-70 D17) |
| WK-SSP0200-0325 | H5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0326 | H5 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ETA · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0327 | H5 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ETD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0328 | H5 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (R-22 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0329 | H5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0330 | H5 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0331 | H5 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0332 | H5 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NICK_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-31⑥⑦) |
| WK-SSP0200-0333 | H5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (R-31⑥⑦ R-70 D17 ACT:SSP0200_ShipmentChan) |
| WK-SSP0200-0334 | H5 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0335 | H5 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — REMARKS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (R-70 D10 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0336 | H5 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0337 | H5 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (R-22 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0338 | H5 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TO_SITE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (R-14 R-28) |
| WK-SSP0200-0339 | H5 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-28) |
| WK-SSP0200-0340 | H5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (R-14 R-17 R-31⑥⑦ ACT:SSP0200_ShipmentCha) |
| WK-SSP0200-0341 | H5 | cboChangeType / Change Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboChangeType / Change Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: tr |  | 43 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0342 | H5 | chkSingleProcess / Single Process | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSingleProcess / Single Process · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행  |  | 1 (R-20·R-21) |
| WK-SSP0200-0343 | H5 | clbDivision_ID / Div / Division_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 |  | 14 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0344 | I1 | SSP0200 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0200 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 110 (L-083·L-089 L-087 L-090 ~ L-121 **L-127·) |
| WK-SSP0200-0345 | SC1 | SSP0200 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0200 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 19 (L-047 ~ L-049·L-053 ~ L-056 9필드 인벤토리 필드 ) |
| WK-SSP0200-0346 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 10 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0347 | D1 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0348 | D1 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0349 | D1 | ERP_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ERP_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (R-25 ACT:SSP0200_ShipmentChangeRequest.E) |
| WK-SSP0200-0350 | D1 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0351 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0352 | D1 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0353 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0354 | D1 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0355 | D1 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0356 | D1 | REMARKS3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — REMARKS3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0357 | D1 | REQUESTOR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — REQUESTOR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0358 | D1 | REQUEST_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — REQUEST_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0359 | D1 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0360 | D1 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0361 | D1 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0362 | D1 | TO_SITE_SOLDTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TO_SITE_SOLDTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0363 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 10 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0364 | D3 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0365 | D3 | ERP_SO_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ERP_SO_NO · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0366 | D3 | ERP_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ERP_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (R-25 ACT:SSP0200_ShipmentChangeRequest.E) |
| WK-SSP0200-0367 | D3 | FROM_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0368 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0369 | D3 | NEW_ETA | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NEW_ETA · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0370 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0371 | D3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0372 | D3 | PROJECT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0373 | D3 | REMARKS3 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REMARKS3 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0374 | D3 | REQUESTOR | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REQUESTOR · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0375 | D3 | REQUEST_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REQUEST_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0376 | D3 | SHIPMENT_CONFIRM_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0377 | D3 | SHIPMENT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIPMENT_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0378 | D3 | TO_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0379 | D3 | TO_SITE_SOLDTO_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TO_SITE_SOLDTO_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0380 | D4 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-28) |
| WK-SSP0200-0381 | D4 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-28) |
| WK-SSP0200-0382 | D4 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-28) |
| WK-SSP0200-0383 | D5 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0384 | D5 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0385 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0386 | D5 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (R-26 ACT:SSP0200_ShipmentChangeRequest.I) |
| WK-SSP0200-0387 | D5 | ERP_ATTR1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ERP_ATTR1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0388 | D5 | ERP_ATTR2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ERP_ATTR2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0389 | D5 | ERP_ATTR3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ERP_ATTR3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0390 | D5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0391 | D5 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0392 | D5 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0393 | D5 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0394 | D5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0395 | D5 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0396 | D5 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0397 | D5 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0398 | D5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0399 | D5 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0400 | D5 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0401 | D5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0402 | D5 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0403 | D5 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0404 | D5 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0405 | D5 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0406 | D5 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0407 | D5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0408 | D6 | SSP0200 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0200 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 7 (R-28 R-41 MSG00202(수량 0) COMMON:UC-01 CO) |
| WK-SSP0200-0409 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0410 | E1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0411 | E1 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0412 | E4 | CHANGE_REASON_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REASON_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0413 | E4 | CHANGE_REASON_DETAIL | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0414 | E4 | CHANGE_REQ_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REQ_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0415 | E4 | CHK | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHK · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0416 | E4 | CONFIRM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CONFIRM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SetMai) |
| WK-SSP0200-0417 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0418 | E4 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SSP0200_ShipmentChangeRequest.setEnd) |
| WK-SSP0200-0419 | E4 | ERP_SO_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ERP_SO_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SetMai) |
| WK-SSP0200-0420 | E4 | FROM_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0421 | E4 | INCOTERMS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — INCOTERMS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0422 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0423 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00012) |
| WK-SSP0200-0424 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (MSG00002 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0425 | E4 | MSG00012 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00012 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00012 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0426 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0427 | E4 | MSG00050 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00050 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0428 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00097) |
| WK-SSP0200-0429 | E4 | MSG00098 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00098 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 17 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0430 | E4 | MSG00133 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00133 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (L-083·L-089 MSG00133 / MSG00328 ACT:SSP0) |
| WK-SSP0200-0431 | E4 | MSG00173 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00173 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0432 | E4 | MSG00174 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00174 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00174 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0433 | E4 | MSG00189 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00189 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00189 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0434 | E4 | MSG00194 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00194 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (L-149·L-150 R-22 MSG00195 / MSG00267 / M) |
| WK-SSP0200-0435 | E4 | MSG00195 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00195 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0436 | E4 | MSG00197 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00197 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0437 | E4 | MSG00198 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00198 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Delete) |
| WK-SSP0200-0438 | E4 | MSG00201 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00201 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0439 | E4 | MSG00202 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00202 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0440 | E4 | MSG00204 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00204 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0441 | E4 | MSG00247 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00247 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (R-60 C10 MSG00195 / MSG00267 / MSG00173 ) |
| WK-SSP0200-0442 | E4 | MSG00248 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00248 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00248 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0443 | E4 | MSG00249 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00249 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0444 | E4 | MSG00261 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00261 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (`ds.Tables[0].Rows[0][0] == "S"/"N"/"F"/) |
| WK-SSP0200-0445 | E4 | MSG00267 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00267 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0446 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 9 (MSG00284 ACT:SSP0200_ShipmentChangeReque) |
| WK-SSP0200-0447 | E4 | MSG00286 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00286 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0448 | E4 | MSG00287 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00287 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0449 | E4 | MSG00293 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00293 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (MSG00293 MSG00293(Trans Mode 콤보 미로드) ACT) |
| WK-SSP0200-0450 | E4 | MSG00306 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00306 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0451 | E4 | MSG00316 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00316 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SaveDa) |
| WK-SSP0200-0452 | E4 | MSG00324 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00324 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SaveBu) |
| WK-SSP0200-0453 | E4 | MSG00328 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00328 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00133 / MSG00328 `ds.Tables[0].Rows[0) |
| WK-SSP0200-0454 | E4 | MSG00353 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00353 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SaveDa) |
| WK-SSP0200-0455 | E4 | MSG00359 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00359 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0456 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00002 MSG00429 사용처(Change Reason 미선택)) |
| WK-SSP0200-0457 | E4 | MSG00614 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00614 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00002) |
| WK-SSP0200-0458 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (**L-127·L-128** MSG00097) |
| WK-SSP0200-0459 | E4 | MSG00684 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00684 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-04) |
| WK-SSP0200-0460 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0461 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0462 | E4 | MSG01188 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01188 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-04) |
| WK-SSP0200-0463 | E4 | MSG01189 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01189 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00174) |
| WK-SSP0200-0464 | E4 | MSG01202 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01202 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00189) |
| WK-SSP0200-0465 | E4 | MSG01258 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01258 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00248) |
| WK-SSP0200-0466 | E4 | MSG01296 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01296 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00293 MSG00293(Trans Mode 콤보 미로드)) |
| WK-SSP0200-0467 | E4 | NEW_ETA | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_ETA · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0468 | E4 | NEW_LT_DAY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_LT_DAY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R-22) |
| WK-SSP0200-0469 | E4 | NEW_SHIPMENT_CONFIRM_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0470 | E4 | NEW_SHIPMENT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SSP0200_ShipmentChangeRequest.SaveDa) |
| WK-SSP0200-0471 | E4 | NEW_TRANSPORT_MODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0472 | E4 | NEW_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0473 | E4 | PLAN_CONFIRM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLAN_CONFIRM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SetMai) |
| WK-SSP0200-0474 | E4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0475 | E4 | REMARKS2 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REMARKS2 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0476 | E4 | REMARKS3 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REMARKS3 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0477 | E4 | REQUEST_TIME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REQUEST_TIME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SetMai) |
| WK-SSP0200-0478 | E4 | REQUEST_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REQUEST_USER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0479 | E4 | REQUEST_USER_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REQUEST_USER_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0480 | E4 | SHIPMENT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SHIPMENT_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (L-149·L-150 R-22 ACT:SSP0200_ShipmentCha) |
| WK-SSP0200-0481 | E4 | SHIPMENT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SHIPMENT_STATUS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 14 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0482 | E4 | STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — STATUS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetSta) |
| WK-SSP0200-0483 | E4 | TO_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0484 | E4 | TRANSPORT_MODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TRANSPORT_MODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0485 | E4 | cboChangeReason / Change Reason | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboChangeReason / Change Reason · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0486 | E4 | cboChangeType / Change Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboChangeType / Change Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — |  | 10 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0487 | E4 | clbDivision_ID / Div / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0488 | E4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0489 | E4 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0490 | E4 | txtAppDeptName / Dept Name / App Dept Na | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtAppDeptName / Dept Name / App Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) →  |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0491 | E4 | txtApproval / Approval | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtApproval / Approval · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0492 | E4 | txtCurrentInsert_Qty / Confirm Id / Curr | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtCurrentInsert_Qty / Confirm Id / Current Insert · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 1 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0493 | E4 | txtReasonDetail / Reason Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtReasonDetail / Reason Detail · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0494 | E4 | txtRequestDeptName / Dept Name / Request | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestDeptName / Dept Name / Request Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0495 | E4 | txtRequestNo / Request No | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestNo / Request No · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 12 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0496 | E4 | txtRequestor / Requestor | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestor / Requestor · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0497 | E4 | txtTitle / Title | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtTitle / Title · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0498 | A10 | SSP0200 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0200 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 162 (ACT:SSP0200_ShipmentChangeRequest.Define) |
| WK-SSP0200-0499 | A6 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (Period 기본값) |
| WK-SSP0200-0500 | A6 | PKG_SSP0026.P_SSP0026_GET_BOD_ITEM | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0026.P_SSP0026_GET_BOD_ITEM · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tra |  | 31 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0501 | A6 | PKG_SSP0200 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0200 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (L-064) |
| WK-SSP0200-0502 | A6 | PKG_SSP0200.P_SSP0200_GET_CHANGE_REQ_NO | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0200.P_SSP0200_GET_CHANGE_REQ_NO · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · |  | 1 (L-064) |
| WK-SSP0200-0503 | A6 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANG | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURC |  | 60 (ACT:SSP0200_ShipmentChangeRequest.FindBu) |
| WK-SSP0200-0504 | A6 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANG | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_ · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 44 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0505 | A6 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTIN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 64 (ACT:SSP0200_ShipmentChangeRequest.FindBu) |
| WK-SSP0200-0506 | A6 | SSP0200_GET_ITEM_FROM_BOD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SSP0200_GET_ITEM_FROM_BOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@ |  | 1 (R-27) |
| WK-SSP0200-0507 | G1 | cboChangeType / Change Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboChangeType / Change Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 12 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0508 | G1 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboStatus / Status · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0509 | G1 | clbDivision_ID / Div / Division_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0510 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0511 | G1 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbToSite / To Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0512 | G1 | drpPeriod / Shipment Date / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Shipment Date / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 9 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0513 | G1 | txtAppDeptName / Dept Name / App Dept Na | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtAppDeptName / Dept Name / App Dept Name · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0514 | G1 | txtApproval / Approval | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtApproval / Approval · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 10 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0515 | G1 | txtConfirmId / Confirm Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtConfirmId / Confirm Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0516 | G1 | txtItemId / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (`txtItemId`(F1) · FCST Type(B4/F8)) |
| WK-SSP0200-0517 | G1 | txtRequest / sItemId / Request | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtRequest / sItemId / Request · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0518 | G1 | txtSoNo / SO No / So No | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtSoNo / SO No / So No · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0519 | G6 | cboChangeReason / Change Reason | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboChangeReason / Change Reason · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0520 | G6 | cboChangeType / Change Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboChangeType / Change Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 48 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0521 | G6 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0522 | G6 | clbDivision_ID / Div / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 18 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0523 | G6 | drpPeriod / Shipment Date / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Shipment Date / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0524 | G6 | dtDate / Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — dtDate / Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0525 | G6 | txtItemId / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (`txtItemId`(F1) · FCST Type(B4/F8)) |
| WK-SSP0200-0526 | G6 | txtRequestDeptName / Dept Name / Request | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtRequestDeptName / Dept Name / Request Dept Name · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0527 | G6 | txtRequestor / Requestor | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtRequestor / Requestor · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0528 | X-REOPEN | SSP0200 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0200 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 35 (ACT:SSP0200_ShipmentChangeRequest.Delete) |
| WK-SSP0200-0529 | M3 | Item | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — Item · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 18 (ACT:Item.ClassToItem ACT:Item.ClassToIte) |
| WK-SSP0200-0530 | M3 | SSP0200_ShipmentChangeRequestInsertPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SSP0200_ShipmentChangeRequestInsertPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 6 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0531 | M4 | CONFIRM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CONFIRM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0532 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0533 | M4 | ERP_SO_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ERP_SO_NO · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 12 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0534 | M4 | FROM_SITE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FROM_SITE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (R-28) |
| WK-SSP0200-0535 | M4 | FROM_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0536 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 74 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0537 | M4 | Item | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — Item · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 19 (Model 팝업 R-52 ACT:SSP0200_ShipmentChange) |
| WK-SSP0200-0538 | M4 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0539 | M4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 44 (R-31⑥⑦ ACT:SSP0200_ShipmentChangeRequest) |
| WK-SSP0200-0540 | M4 | PROJECT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (R-31⑥⑦) |
| WK-SSP0200-0541 | M4 | TO_SITE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TO_SITE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (R-28) |
| WK-SSP0200-0542 | M4 | TO_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (R-28 ACT:SSP0200_ShipmentChangeRequest.S) |
| WK-SSP0200-0543 | M4 | TRANSPORT_MODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TRANSPORT_MODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (R-31⑥⑦) |
| WK-SSP0200-0544 | M4 | btnApprovalUser | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnApprovalUser · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (L-020 ~ L-023·L-024·L-026·**L-078·L-125*) |

## W7 기대값 확정 (433)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0545 | C2 | SSP0200_ShipmentChangeRequest.CboChangeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0200_ShipmentChangeRequest.CboChangeType_Select: 진입점 집계 — C2 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0200_ShipmentChangeRequest.CboCha) |
| WK-SSP0200-0546 | C2 | SSP0200_ShipmentChangeRequest.SpdMain_Cu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0200_ShipmentChangeRequest.SpdMain_CursorChange: 진입점 집계 — C2 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0547 | C2 | SSP0200_ShipmentChangeRequest.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0200_ShipmentChangeRequest.clbDivision_ID_Selec: 진입점 집계 — C2 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.clbDiv) |
| WK-SSP0200-0548 | C3 | SSP0200_ShipmentChangeRequest.CboChangeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.CboChangeType_Select: 진입점 집계 — C3 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0200_ShipmentChangeRequest.CboCha) |
| WK-SSP0200-0549 | C3 | SSP0200_ShipmentChangeRequest.SetButtonV | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.SetButtonVisual: 진입점 집계 — C3 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SetBut) |
| WK-SSP0200-0550 | C3 | SSP0200_ShipmentChangeRequest.SetChangeC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangeControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0551 | C3 | SSP0200_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangeRequestInfo: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0552 | C3 | SSP0200_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangeRequestSOGr: 진입점 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0553 | C3 | SSP0200_ShipmentChangeRequest.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangedControl: 진입점 집계 — C3 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0554 | C3 | SSP0200_ShipmentChangeRequest.SetMainSta | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.SetMainStatus: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SetMai) |
| WK-SSP0200-0555 | C3 | SSP0200_ShipmentChangeRequest.SetStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.SetStatus: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SetSta) |
| WK-SSP0200-0556 | C3 | SSP0200_ShipmentChangeRequest.SpdMain_Cu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.SpdMain_CursorChange: 진입점 집계 — C3 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0557 | C3 | SSP0200_ShipmentChangeRequest.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.clbDivision_ID_Selec: 진입점 집계 — C3 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.clbDiv) |
| WK-SSP0200-0558 | C3 | SSP0200_ShipmentChangeRequest.setEndCust | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0200_ShipmentChangeRequest.setEndCustomer: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0200_ShipmentChangeRequest.setEnd) |
| WK-SSP0200-0559 | C6 | SSP0200_ShipmentChangeRequest.CboChangeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0200_ShipmentChangeRequest.CboChangeType_Select: 진입점 집계 — C6 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0200_ShipmentChangeRequest.CboCha) |
| WK-SSP0200-0560 | C6 | SSP0200_ShipmentChangeRequest.SpdMain_Cu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0200_ShipmentChangeRequest.SpdMain_CursorChange: 진입점 집계 — C6 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0561 | C6 | SSP0200_ShipmentChangeRequest.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0200_ShipmentChangeRequest.clbDivision_ID_Selec: 진입점 집계 — C6 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.clbDiv) |
| WK-SSP0200-0562 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0563 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0564 | B3 | SSP0200_ShipmentChangeRequest.GetDayRang | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetDayRange: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetDay) |
| WK-SSP0200-0565 | B3 | SSP0200_ShipmentChangeRequest.GetDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetDiv) |
| WK-SSP0200-0566 | B3 | SSP0200_ShipmentChangeRequest.GetERPInte | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetERPInterface: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 85 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0567 | B3 | SSP0200_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFCheck: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 24 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0568 | B3 | SSP0200_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFCheckNew: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0569 | B3 | SSP0200_ShipmentChangeRequest.GetErpIFSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFSeqMerge: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0570 | B3 | SSP0200_ShipmentChangeRequest.GetErpSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpSoNoCnt: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0571 | B3 | SSP0200_ShipmentChangeRequest.GetItemFro | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetItemFromBOD: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0200_ShipmentChangeRequest.GetIte) |
| WK-SSP0200-0572 | B3 | SSP0200_ShipmentChangeRequest.GetNewERPI | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetNewERPInterface: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SSP0200_ShipmentChangeRequest.GetNew) |
| WK-SSP0200-0573 | B3 | SSP0200_ShipmentChangeRequest.GetPlantSi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetPlantSiteByDivisi: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetPla) |
| WK-SSP0200-0574 | B3 | SSP0200_ShipmentChangeRequest.GetShipmen | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetShipmentPlanPlant: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetShi) |
| WK-SSP0200-0575 | B3 | SSP0200_ShipmentChangeRequest.GetShipmen | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0200_ShipmentChangeRequest.GetShipmentStatusChk: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0200_ShipmentChangeRequest.GetShi) |
| WK-SSP0200-0576 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0577 | B4 | SSP0200_ShipmentChangeRequest.GetDayRang | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetDayRange: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetDay) |
| WK-SSP0200-0578 | B4 | SSP0200_ShipmentChangeRequest.GetDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetDiv) |
| WK-SSP0200-0579 | B4 | SSP0200_ShipmentChangeRequest.GetERPInte | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetERPInterface: 진입점 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 85 (ACT:SSP0200_ShipmentChangeRequest.GetERP) |
| WK-SSP0200-0580 | B4 | SSP0200_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFCheck: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 24 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0581 | B4 | SSP0200_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFCheckNew: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0582 | B4 | SSP0200_ShipmentChangeRequest.GetErpIFSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFSeqMerge: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0583 | B4 | SSP0200_ShipmentChangeRequest.GetErpSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpSoNoCnt: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0584 | B4 | SSP0200_ShipmentChangeRequest.GetItemFro | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetItemFromBOD: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0200_ShipmentChangeRequest.GetIte) |
| WK-SSP0200-0585 | B4 | SSP0200_ShipmentChangeRequest.GetNewERPI | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetNewERPInterface: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SSP0200_ShipmentChangeRequest.GetNew) |
| WK-SSP0200-0586 | B4 | SSP0200_ShipmentChangeRequest.GetPlantSi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetPlantSiteByDivisi: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetPla) |
| WK-SSP0200-0587 | B4 | SSP0200_ShipmentChangeRequest.GetShipmen | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetShipmentPlanPlant: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.GetShi) |
| WK-SSP0200-0588 | B4 | SSP0200_ShipmentChangeRequest.GetShipmen | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetShipmentStatusChk: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0200_ShipmentChangeRequest.GetShi) |
| WK-SSP0200-0589 | DB-SYN | **L-152** | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — **L-152**: 행 집계 — DB-SYN 17요소: PASS:12 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (**L-152**) |
| WK-SSP0200-0590 | DB-SYN | L-072 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — L-072: 행 집계 — DB-SYN 17요소: PASS:12 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (L-072) |
| WK-SSP0200-0591 | DB-SYN | R-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — R-14: 행 집계 — DB-SYN 17요소: PASS:12 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (R-14) |
| WK-SSP0200-0592 | DB-SYN | R-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — R-18: 행 집계 — DB-SYN 17요소: PASS:12 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (R-18) |
| WK-SSP0200-0593 | DB-SYN | SSP0200_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFCheckNew: 진입점 집계 — DB-SYN 17요소: PASS:12 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0594 | DB-SYN | SSP0200_ShipmentChangeRequest.GetErpIFSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFSeqMerge: 진입점 집계 — DB-SYN 17요소: PASS:12 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0595 | DB-SYN | 자동조회 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 자동조회 금지: 행 집계 — DB-SYN 17요소: PASS:12 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (자동조회 금지) |
| WK-SSP0200-0596 | F4 | **L-152** | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — **L-152**: 행 집계 — F4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (**L-152**) |
| WK-SSP0200-0597 | F4 | L-072 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — L-072: 행 집계 — F4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (L-072) |
| WK-SSP0200-0598 | F4 | R-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — R-14: 행 집계 — F4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-14) |
| WK-SSP0200-0599 | F4 | R-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — R-18: 행 집계 — F4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-18) |
| WK-SSP0200-0600 | F4 | SSP0200_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFCheckNew: 진입점 집계 — F4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0601 | F4 | SSP0200_ShipmentChangeRequest.GetErpIFSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFSeqMerge: 진입점 집계 — F4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0602 | F4 | SSP0200_ShipmentChangeRequestInsertPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0200_ShipmentChangeRequestInsertPopup.SaveData: 진입점 집계 — F4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0603 | F4 | 자동조회 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 자동조회 금지: 행 집계 — F4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (자동조회 금지) |
| WK-SSP0200-0604 | A5 | **L-050** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — **L-050**: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (**L-050**) |
| WK-SSP0200-0605 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0606 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0200-0607 | A5 | L-014·L-015·**L-126** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — L-014·L-015·**L-126**: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (L-014·L-015·**L-126**) |
| WK-SSP0200-0608 | A5 | L-062·L-063 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — L-062·L-063: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (L-062·L-063) |
| WK-SSP0200-0609 | A5 | L-081 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — L-081: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (L-081) |
| WK-SSP0200-0610 | A5 | R-01·R-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-01·R-02: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-01·R-02) |
| WK-SSP0200-0611 | A5 | R-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-10: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-10) |
| WK-SSP0200-0612 | A5 | R-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-12: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-12) |
| WK-SSP0200-0613 | A5 | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-13: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-13) |
| WK-SSP0200-0614 | A5 | R-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-18: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-18) |
| WK-SSP0200-0615 | A5 | R-20·R-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-20·R-21: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-20·R-21) |
| WK-SSP0200-0616 | A5 | R-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-24: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-24) |
| WK-SSP0200-0617 | A5 | R-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-27: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-27) |
| WK-SSP0200-0618 | A5 | R-29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-29: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-29) |
| WK-SSP0200-0619 | A5 | R-31② | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-31②: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-31②) |
| WK-SSP0200-0620 | A5 | R-31③④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-31③④: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-31③④) |
| WK-SSP0200-0621 | A5 | R-40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-40: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-40) |
| WK-SSP0200-0622 | A5 | R-41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-41: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-41) |
| WK-SSP0200-0623 | A5 | R-50 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-50: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-50) |
| WK-SSP0200-0624 | A5 | R-51 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-51: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-51) |
| WK-SSP0200-0625 | A5 | R-52 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-52: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-52) |
| WK-SSP0200-0626 | A5 | R-60 C10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-60 C10: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-60 C10) |
| WK-SSP0200-0627 | A5 | R-70 D11~D16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-70 D11~D16: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0628 | A5 | R-70 D1·D2·D4·D5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-70 D1·D2·D4·D5: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-70 D1·D2·D4·D5) |
| WK-SSP0200-0629 | A5 | SSP0200_ShipmentChangeRequest.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0200_ShipmentChangeRequest.CreateSpread: 진입점 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0200_ShipmentChangeRequest.Create) |
| WK-SSP0200-0630 | A5 | cascade 5단계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — cascade 5단계: 행 집계 — A5 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (cascade 5단계) |
| WK-SSP0200-0631 | G4 | **C1** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — **C1**: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (**C1**) |
| WK-SSP0200-0632 | G4 | **C2·C3** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — **C2·C3**: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (**C2·C3**) |
| WK-SSP0200-0633 | G4 | **C5** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — **C5**: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (**C5**) |
| WK-SSP0200-0634 | G4 | 9필드 인벤토리 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 9필드 인벤토리: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (9필드 인벤토리) |
| WK-SSP0200-0635 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0200-0636 | G4 | Designer 잔여 초기값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Designer 잔여 초기값: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Designer 잔여 초기값) |
| WK-SSP0200-0637 | G4 | L-047 ~ L-049·L-053 ~ L-056 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — L-047 ~ L-049·L-053 ~ L-056: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (L-047 ~ L-049·L-053 ~ L-056) |
| WK-SSP0200-0638 | G4 | Model 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Model 팝업: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Model 팝업) |
| WK-SSP0200-0639 | G4 | Period 기본값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Period 기본값: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Period 기본값) |
| WK-SSP0200-0640 | G4 | R-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — R-12: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (R-12) |
| WK-SSP0200-0641 | G4 | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — R-13: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (R-13) |
| WK-SSP0200-0642 | G4 | `ChangeType='A'` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `ChangeType='A'`: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (`ChangeType='A'`) |
| WK-SSP0200-0643 | G4 | cascade 5단계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — cascade 5단계: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (cascade 5단계) |
| WK-SSP0200-0644 | G4 | payload 12키 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — payload 12키: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (payload 12키) |
| WK-SSP0200-0645 | G4 | 자동조회 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 자동조회 금지: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (자동조회 금지) |
| WK-SSP0200-0646 | G4 | 초기 mount 무발화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 초기 mount 무발화: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (초기 mount 무발화) |
| WK-SSP0200-0647 | G4 | 필드 수 > 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 필드 수 > 6: 행 집계 — G4 15요소: NOT_RUN:9 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (필드 수 > 6) |
| WK-SSP0200-0648 | H2 | **L-050** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — **L-050**: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (**L-050**) |
| WK-SSP0200-0649 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0650 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0200-0651 | H2 | L-062·L-063 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — L-062·L-063: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (L-062·L-063) |
| WK-SSP0200-0652 | H2 | L-081 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — L-081: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (L-081) |
| WK-SSP0200-0653 | H2 | R-01·R-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-01·R-02: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-01·R-02) |
| WK-SSP0200-0654 | H2 | R-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-10: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-10) |
| WK-SSP0200-0655 | H2 | R-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-12: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-12) |
| WK-SSP0200-0656 | H2 | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-13: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-13) |
| WK-SSP0200-0657 | H2 | R-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-18: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-18) |
| WK-SSP0200-0658 | H2 | R-20·R-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-20·R-21: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-20·R-21) |
| WK-SSP0200-0659 | H2 | R-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-24: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-24) |
| WK-SSP0200-0660 | H2 | R-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-27: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-27) |
| WK-SSP0200-0661 | H2 | R-29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-29: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-29) |
| WK-SSP0200-0662 | H2 | R-31② | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-31②: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-31②) |
| WK-SSP0200-0663 | H2 | R-31③④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-31③④: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-31③④) |
| WK-SSP0200-0664 | H2 | R-40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-40: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-40) |
| WK-SSP0200-0665 | H2 | R-41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-41: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-41) |
| WK-SSP0200-0666 | H2 | R-50 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-50: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-50) |
| WK-SSP0200-0667 | H2 | R-51 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-51: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-51) |
| WK-SSP0200-0668 | H2 | R-52 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-52: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-52) |
| WK-SSP0200-0669 | H2 | R-60 C10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-60 C10: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-60 C10) |
| WK-SSP0200-0670 | H2 | R-70 D11~D16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-70 D11~D16: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0671 | H2 | R-70 D1·D2·D4·D5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-70 D1·D2·D4·D5: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-70 D1·D2·D4·D5) |
| WK-SSP0200-0672 | H2 | SSP0200_ShipmentChangeRequest.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0200_ShipmentChangeRequest.CreateSpread: 진입점 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0200_ShipmentChangeRequest.Create) |
| WK-SSP0200-0673 | H2 | cascade 5단계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — cascade 5단계: 행 집계 — H2 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (cascade 5단계) |
| WK-SSP0200-0674 | H5 | **L-050** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — **L-050**: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (**L-050**) |
| WK-SSP0200-0675 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0676 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0200-0677 | H5 | L-062·L-063 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — L-062·L-063: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (L-062·L-063) |
| WK-SSP0200-0678 | H5 | L-081 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — L-081: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (L-081) |
| WK-SSP0200-0679 | H5 | R-01·R-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-01·R-02: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-01·R-02) |
| WK-SSP0200-0680 | H5 | R-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-10: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-10) |
| WK-SSP0200-0681 | H5 | R-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-12: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-12) |
| WK-SSP0200-0682 | H5 | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-13: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-13) |
| WK-SSP0200-0683 | H5 | R-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-18: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-18) |
| WK-SSP0200-0684 | H5 | R-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-24: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-24) |
| WK-SSP0200-0685 | H5 | R-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-27: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-27) |
| WK-SSP0200-0686 | H5 | R-29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-29: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-29) |
| WK-SSP0200-0687 | H5 | R-31② | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-31②: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-31②) |
| WK-SSP0200-0688 | H5 | R-31③④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-31③④: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-31③④) |
| WK-SSP0200-0689 | H5 | R-40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-40: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-40) |
| WK-SSP0200-0690 | H5 | R-41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-41: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-41) |
| WK-SSP0200-0691 | H5 | R-50 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-50: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-50) |
| WK-SSP0200-0692 | H5 | R-51 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-51: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-51) |
| WK-SSP0200-0693 | H5 | R-52 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-52: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-52) |
| WK-SSP0200-0694 | H5 | R-60 C10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-60 C10: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-60 C10) |
| WK-SSP0200-0695 | H5 | R-70 D11~D16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-70 D11~D16: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0696 | H5 | R-70 D1·D2·D4·D5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-70 D1·D2·D4·D5: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (R-70 D1·D2·D4·D5) |
| WK-SSP0200-0697 | H5 | SSP0200_ShipmentChangeRequest.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0200_ShipmentChangeRequest.CreateSpread: 진입점 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0200_ShipmentChangeRequest.Create) |
| WK-SSP0200-0698 | H5 | cascade 5단계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — cascade 5단계: 행 집계 — H5 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (cascade 5단계) |
| WK-SSP0200-0699 | X-REASON | L-012·L-013 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — L-012·L-013 `usrLabel2` 섹션 헤더(정적, `.cs` 참조 0건) 미이식 — 정적 장식 라벨, TO-BE 폼에 대응 영역 없음 미이식(장식) |  | 1 (L-012·L-013) |
| WK-SSP0200-0700 | D1 | **L-127·L-128** | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — **L-127·L-128**: 행 집계 — D1 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (**L-127·L-128**) |
| WK-SSP0200-0701 | D1 | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-13: 행 집계 — D1 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-13) |
| WK-SSP0200-0702 | D1 | R-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-27: 행 집계 — D1 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-27) |
| WK-SSP0200-0703 | D1 | R-31② | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-31②: 행 집계 — D1 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-31②) |
| WK-SSP0200-0704 | D1 | R-31③④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-31③④: 행 집계 — D1 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-31③④) |
| WK-SSP0200-0705 | D1 | R-50 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-50: 행 집계 — D1 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-50) |
| WK-SSP0200-0706 | D1 | SSP0200_ShipmentChangeRequest.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSP0200_ShipmentChangeRequest.EditButton: 진입점 집계 — D1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0707 | D3 | **L-127·L-128** | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — **L-127·L-128**: 행 집계 — D3 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (**L-127·L-128**) |
| WK-SSP0200-0708 | D3 | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-13: 행 집계 — D3 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-13) |
| WK-SSP0200-0709 | D3 | R-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-27: 행 집계 — D3 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-27) |
| WK-SSP0200-0710 | D3 | R-31② | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-31②: 행 집계 — D3 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-31②) |
| WK-SSP0200-0711 | D3 | R-31③④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-31③④: 행 집계 — D3 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-31③④) |
| WK-SSP0200-0712 | D3 | R-50 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-50: 행 집계 — D3 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (R-50) |
| WK-SSP0200-0713 | D3 | SSP0200_ShipmentChangeRequest.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSP0200_ShipmentChangeRequest.EditButton: 진입점 집계 — D3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0200_ShipmentChangeRequest.EditBu) |
| WK-SSP0200-0714 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SSP0200-0715 | D4 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-03: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SSP0200-0716 | D4 | MSG00202(수량 0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — MSG00202(수량 0): 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MSG00202(수량 0)) |
| WK-SSP0200-0717 | D4 | Period 기본값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Period 기본값: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Period 기본값) |
| WK-SSP0200-0718 | D4 | R-41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — R-41: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-41) |
| WK-SSP0200-0719 | D4 | 초기 mount 무발화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 초기 mount 무발화: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (초기 mount 무발화) |
| WK-SSP0200-0720 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 25요소: NOT_RUN:25 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0721 | D5 | SSP0200_ShipmentChangeRequest.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0200_ShipmentChangeRequest.CreateSpread: 진입점 집계 — D5 25요소: NOT_RUN:25 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0200_ShipmentChangeRequest.Create) |
| WK-SSP0200-0722 | E1 | R-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — R-10: 행 집계 — E1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-10) |
| WK-SSP0200-0723 | E1 | R-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — R-27: 행 집계 — E1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-27) |
| WK-SSP0200-0724 | E4 | L-073 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — L-073: 행 집계 — E4 86요소: NOT_RUN:86 (미실행 요소가 남아 판정필요) |  | 1 (L-073) |
| WK-SSP0200-0725 | E4 | L-079·L-082·L-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — L-079·L-082·L-102: 행 집계 — E4 86요소: NOT_RUN:86 (미실행 요소가 남아 판정필요) |  | 1 (L-079·L-082·L-102) |
| WK-SSP0200-0726 | E4 | L-087 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — L-087: 행 집계 — E4 86요소: NOT_RUN:86 (미실행 요소가 남아 판정필요) |  | 1 (L-087) |
| WK-SSP0200-0727 | E4 | L-090 ~ L-121 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — L-090 ~ L-121: 행 집계 — E4 86요소: NOT_RUN:86 (미실행 요소가 남아 판정필요) |  | 1 (L-090 ~ L-121) |
| WK-SSP0200-0728 | E4 | R-29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-29: 행 집계 — E4 86요소: NOT_RUN:86 (미실행 요소가 남아 판정필요) |  | 1 (R-29) |
| WK-SSP0200-0729 | E4 | R-50 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-50: 행 집계 — E4 86요소: NOT_RUN:86 (미실행 요소가 남아 판정필요) |  | 1 (R-50) |
| WK-SSP0200-0730 | E4 | R-51 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-51: 행 집계 — E4 86요소: NOT_RUN:86 (미실행 요소가 남아 판정필요) |  | 1 (R-51) |
| WK-SSP0200-0731 | E4 | SSP0200_ShipmentChangeRequest.SetButtonV | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0200_ShipmentChangeRequest.SetButtonVisual: 진입점 집계 — E4 86요소: NOT_RUN:86 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SetBut) |
| WK-SSP0200-0732 | E4 | SSP0200_ShipmentChangeRequest.SetChangeC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangeControl: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0733 | E4 | SSP0200_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangeRequestInfo: 진입점 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0734 | E4 | SSP0200_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangeRequestSOGr: 진입점 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0735 | E4 | SSP0200_ShipmentChangeRequest.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangedControl: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0736 | E4 | SSP0200_ShipmentChangeRequest.SetMainSta | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0200_ShipmentChangeRequest.SetMainStatus: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.SetMai) |
| WK-SSP0200-0737 | E4 | SSP0200_ShipmentChangeRequest.SetStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0200_ShipmentChangeRequest.SetStatus: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SSP0200_ShipmentChangeRequest.SetSta) |
| WK-SSP0200-0738 | E4 | SSP0200_ShipmentChangeRequest.setEndCust | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0200_ShipmentChangeRequest.setEndCustomer: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0200_ShipmentChangeRequest.setEnd) |
| WK-SSP0200-0739 | E4 | shtSub 2단 헤더 'P' 분기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — shtSub 2단 헤더 'P' 분기: 행 집계 — E4 86요소: NOT_RUN:86 (미실행 요소가 남아 판정필요) |  | 1 (shtSub 2단 헤더 'P' 분기) |
| WK-SSP0200-0740 | E4 | 저장 성공 toast | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 저장 성공 toast: 행 집계 — E4 86요소: NOT_RUN:86 (미실행 요소가 남아 판정필요) |  | 1 (저장 성공 toast) |
| WK-SSP0200-0741 | E5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — COMMON:UC-05: 행 집계 — E5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0742 | A1 | **C1** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **C1**: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (**C1**) |
| WK-SSP0200-0743 | A1 | **C2·C3** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **C2·C3**: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (**C2·C3**) |
| WK-SSP0200-0744 | A1 | **C5** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **C5**: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (**C5**) |
| WK-SSP0200-0745 | A1 | **L-127·L-128** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **L-127·L-128**: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (**L-127·L-128**) |
| WK-SSP0200-0746 | A1 | **L-152** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **L-152**: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (**L-152**) |
| WK-SSP0200-0747 | A1 | 9필드 인벤토리 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9필드 인벤토리: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (9필드 인벤토리) |
| WK-SSP0200-0748 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0749 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (COMMON:UC-03) |
| WK-SSP0200-0750 | A1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-05: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0751 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (COMMON:UC-06) |
| WK-SSP0200-0752 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (COMMON:UC-07) |
| WK-SSP0200-0753 | A1 | Designer 잔여 초기값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Designer 잔여 초기값: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (Designer 잔여 초기값) |
| WK-SSP0200-0754 | A1 | L-016 ~ L-019·**L-148** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L-016 ~ L-019·**L-148**: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (L-016 ~ L-019·**L-148**) |
| WK-SSP0200-0755 | A1 | L-047 ~ L-049·L-053 ~ L-056 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L-047 ~ L-049·L-053 ~ L-056: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (L-047 ~ L-049·L-053 ~ L-056) |
| WK-SSP0200-0756 | A1 | L-072 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L-072: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (L-072) |
| WK-SSP0200-0757 | A1 | Model 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Model 팝업: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (Model 팝업) |
| WK-SSP0200-0758 | A1 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD: 골든 비교 케이스 없음(PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD — 팝업·보조 SP 는 golden_ca |  | 1 (Period 기본값) |
| WK-SSP0200-0759 | A1 | PKG_SSP0026.P_SSP0026_GET_BOD_ITEM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0026.P_SSP0026_GET_BOD_ITEM: 골든 비교 케이스 없음(PKG_SSP0026.P_SSP0026_GET_BOD_ITEM — 팝업·보조 SP 는 golden_cases.csv 에 FE |  | 31 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0760 | A1 | PKG_SSP0200 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0200: 골든 비교 케이스 없음(PKG_SSP0200 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (L-064) |
| WK-SSP0200-0761 | A1 | PKG_SSP0200.P_SSP0200_GET_CHANGE_REQ_NO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0200.P_SSP0200_GET_CHANGE_REQ_NO: 골든 비교 케이스 없음(PKG_SSP0200.P_SSP0200_GET_CHANGE_REQ_NO — 팝업·보조 SP 는 golden_case |  | 1 (L-064) |
| WK-SSP0200-0762 | A1 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANG | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST: 골든 비교 케이스 없음(PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST — 팝업 |  | 60 (ACT:SSP0200_ShipmentChangeRequest.FindBu) |
| WK-SSP0200-0763 | A1 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANG | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_: 골든 비교 케이스 없음(PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N — |  | 44 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0764 | A1 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTIN: 골든 비교 케이스 없음(PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTING — |  | 64 (ACT:SSP0200_ShipmentChangeRequest.FindBu) |
| WK-SSP0200-0765 | A1 | R-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-12: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (R-12) |
| WK-SSP0200-0766 | A1 | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-13: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (R-13) |
| WK-SSP0200-0767 | A1 | R-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-14: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (R-14) |
| WK-SSP0200-0768 | A1 | R-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-18: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (R-18) |
| WK-SSP0200-0769 | A1 | R-31③④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-31③④: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (R-31③④) |
| WK-SSP0200-0770 | A1 | R-41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-41: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (R-41) |
| WK-SSP0200-0771 | A1 | SSP0200_GET_ITEM_FROM_BOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0200_GET_ITEM_FROM_BOD: 골든 비교 케이스 없음(SSP0200_GET_ITEM_FROM_BOD — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가  |  | 1 (R-27) |
| WK-SSP0200-0772 | A1 | SSP0200_GET_SHIPMENT_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0200_GET_SHIPMENT_DIVISION: 골든 비교 케이스 없음(SSP0200_GET_SHIPMENT_DIVISION — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 |  | 1 (**C4**) |
| WK-SSP0200-0773 | A1 | `ChangeType='A'` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `ChangeType='A'`: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (`ChangeType='A'`) |
| WK-SSP0200-0774 | A1 | `txtItemId`(F1) · FCST Type(B4/F8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `txtItemId`(F1) · FCST Type(B4/F8): 행 집계 — A1 9요소: REVIEW:9 |  | 1 (`txtItemId`(F1) · FCST Type(B4/F8)) |
| WK-SSP0200-0775 | A1 | cascade 5단계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cascade 5단계: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (cascade 5단계) |
| WK-SSP0200-0776 | A1 | payload 12키 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — payload 12키: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (payload 12키) |
| WK-SSP0200-0777 | A1 | 설계 정본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 설계 정본: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (설계 정본) |
| WK-SSP0200-0778 | A1 | 자동조회 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 자동조회 금지: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (자동조회 금지) |
| WK-SSP0200-0779 | A1 | 초기 mount 무발화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 초기 mount 무발화: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (초기 mount 무발화) |
| WK-SSP0200-0780 | A1 | 필드 수 > 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 필드 수 > 6: 행 집계 — A1 9요소: REVIEW:9 |  | 1 (필드 수 > 6) |
| WK-SSP0200-0781 | G1 | **C1** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — **C1**: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (**C1**) |
| WK-SSP0200-0782 | G1 | **C2·C3** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — **C2·C3**: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (**C2·C3**) |
| WK-SSP0200-0783 | G1 | **C5** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — **C5**: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (**C5**) |
| WK-SSP0200-0784 | G1 | **L-127·L-128** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — **L-127·L-128**: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (**L-127·L-128**) |
| WK-SSP0200-0785 | G1 | **L-152** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — **L-152**: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (**L-152**) |
| WK-SSP0200-0786 | G1 | 9필드 인벤토리 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 9필드 인벤토리: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (9필드 인벤토리) |
| WK-SSP0200-0787 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0200-0788 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SSP0200-0789 | G1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-05: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0200-0790 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0200-0791 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0200-0792 | G1 | Designer 잔여 초기값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Designer 잔여 초기값: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Designer 잔여 초기값) |
| WK-SSP0200-0793 | G1 | L-016 ~ L-019·**L-148** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — L-016 ~ L-019·**L-148**: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (L-016 ~ L-019·**L-148**) |
| WK-SSP0200-0794 | G1 | L-047 ~ L-049·L-053 ~ L-056 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — L-047 ~ L-049·L-053 ~ L-056: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (L-047 ~ L-049·L-053 ~ L-056) |
| WK-SSP0200-0795 | G1 | L-072 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — L-072: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (L-072) |
| WK-SSP0200-0796 | G1 | Model 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Model 팝업: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Model 팝업) |
| WK-SSP0200-0797 | G1 | Period 기본값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Period 기본값: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Period 기본값) |
| WK-SSP0200-0798 | G1 | R-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-12: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-12) |
| WK-SSP0200-0799 | G1 | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-13: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-13) |
| WK-SSP0200-0800 | G1 | R-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-14: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-14) |
| WK-SSP0200-0801 | G1 | R-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-27: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-27) |
| WK-SSP0200-0802 | G1 | R-31③④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-31③④: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-31③④) |
| WK-SSP0200-0803 | G1 | R-41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-41: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-41) |
| WK-SSP0200-0804 | G1 | `ChangeType='A'` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `ChangeType='A'`: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (`ChangeType='A'`) |
| WK-SSP0200-0805 | G1 | cascade 5단계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cascade 5단계: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (cascade 5단계) |
| WK-SSP0200-0806 | G1 | payload 12키 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — payload 12키: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (payload 12키) |
| WK-SSP0200-0807 | G1 | 설계 정본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 설계 정본: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (설계 정본) |
| WK-SSP0200-0808 | G1 | 자동조회 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 자동조회 금지: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (자동조회 금지) |
| WK-SSP0200-0809 | G1 | 초기 mount 무발화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 초기 mount 무발화: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (초기 mount 무발화) |
| WK-SSP0200-0810 | G1 | 필드 수 > 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 필드 수 > 6: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (필드 수 > 6) |
| WK-SSP0200-0811 | G6 | **C1** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — **C1**: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (**C1**) |
| WK-SSP0200-0812 | G6 | **C2·C3** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — **C2·C3**: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (**C2·C3**) |
| WK-SSP0200-0813 | G6 | **C5** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — **C5**: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (**C5**) |
| WK-SSP0200-0814 | G6 | 9필드 인벤토리 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 9필드 인벤토리: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (9필드 인벤토리) |
| WK-SSP0200-0815 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0200-0816 | G6 | Designer 잔여 초기값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Designer 잔여 초기값: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (Designer 잔여 초기값) |
| WK-SSP0200-0817 | G6 | L-047 ~ L-049·L-053 ~ L-056 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — L-047 ~ L-049·L-053 ~ L-056: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (L-047 ~ L-049·L-053 ~ L-056) |
| WK-SSP0200-0818 | G6 | Model 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Model 팝업: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (Model 팝업) |
| WK-SSP0200-0819 | G6 | Period 기본값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Period 기본값: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (Period 기본값) |
| WK-SSP0200-0820 | G6 | R-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — R-12: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (R-12) |
| WK-SSP0200-0821 | G6 | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — R-13: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (R-13) |
| WK-SSP0200-0822 | G6 | `ChangeType='A'` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `ChangeType='A'`: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (`ChangeType='A'`) |
| WK-SSP0200-0823 | G6 | cascade 5단계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — cascade 5단계: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (cascade 5단계) |
| WK-SSP0200-0824 | G6 | payload 12키 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — payload 12키: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (payload 12키) |
| WK-SSP0200-0825 | G6 | 자동조회 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 자동조회 금지: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (자동조회 금지) |
| WK-SSP0200-0826 | G6 | 초기 mount 무발화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 초기 mount 무발화: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (초기 mount 무발화) |
| WK-SSP0200-0827 | G6 | 필드 수 > 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 필드 수 > 6: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (필드 수 > 6) |
| WK-SSP0200-0828 | X-LOC | **L-050** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **L-050**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**L-050**) |
| WK-SSP0200-0829 | X-LOC | **L-074** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **L-074**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**L-074**) |
| WK-SSP0200-0830 | X-LOC | **L-088** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **L-088**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**L-088**) |
| WK-SSP0200-0831 | X-LOC | **L-127·L-128** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **L-127·L-128**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**L-127·L-128**) |
| WK-SSP0200-0832 | X-LOC | AS-IS 정본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS 정본: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS 정본) |
| WK-SSP0200-0833 | X-LOC | L-002·L-003·L-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-002·L-003·L-005: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-002·L-003·L-005) |
| WK-SSP0200-0834 | X-LOC | L-006 ~ L-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-006 ~ L-011: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-006 ~ L-011) |
| WK-SSP0200-0835 | X-LOC | L-014·L-015·**L-126** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-014·L-015·**L-126**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-014·L-015·**L-126**) |
| WK-SSP0200-0836 | X-LOC | L-016 ~ L-019·**L-148** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-016 ~ L-019·**L-148**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-016 ~ L-019·**L-148**) |
| WK-SSP0200-0837 | X-LOC | L-020 ~ L-023·L-024·L-026·**L-078·L-125* | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-020 ~ L-023·L-024·L-026·**L-078·L-125**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-020 ~ L-023·L-024·L-026·**L-078·L-125*) |
| WK-SSP0200-0838 | X-LOC | L-027·L-028·L-030·L-032·L-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-027·L-028·L-030·L-032·L-033: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-027·L-028·L-030·L-032·L-033) |
| WK-SSP0200-0839 | X-LOC | L-035 ~ L-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-035 ~ L-038: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-035 ~ L-038) |
| WK-SSP0200-0840 | X-LOC | L-047 ~ L-049·L-053 ~ L-056 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-047 ~ L-049·L-053 ~ L-056: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-047 ~ L-049·L-053 ~ L-056) |
| WK-SSP0200-0841 | X-LOC | L-051·L-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-051·L-052: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-051·L-052) |
| WK-SSP0200-0842 | X-LOC | L-057 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-057: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-057) |
| WK-SSP0200-0843 | X-LOC | L-058 ~ L-060 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-058 ~ L-060: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-058 ~ L-060) |
| WK-SSP0200-0844 | X-LOC | L-062·L-063 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-062·L-063: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-062·L-063) |
| WK-SSP0200-0845 | X-LOC | L-072 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-072: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-072) |
| WK-SSP0200-0846 | X-LOC | L-073 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-073: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-073) |
| WK-SSP0200-0847 | X-LOC | L-075·L-076 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-075·L-076: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-075·L-076) |
| WK-SSP0200-0848 | X-LOC | L-079·L-082·L-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-079·L-082·L-102: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-079·L-082·L-102) |
| WK-SSP0200-0849 | X-LOC | L-081 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-081: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-081) |
| WK-SSP0200-0850 | X-LOC | L-083·L-089 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-083·L-089: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-083·L-089) |
| WK-SSP0200-0851 | X-LOC | L-087 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-087: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-087) |
| WK-SSP0200-0852 | X-LOC | L-090 ~ L-121 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-090 ~ L-121: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-090 ~ L-121) |
| WK-SSP0200-0853 | X-LOC | L-122 ~ L-124 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L-122 ~ L-124: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L-122 ~ L-124) |
| WK-SSP0200-0854 | X-LOC | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00002: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00002) |
| WK-SSP0200-0855 | X-LOC | MSG00012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00012: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00012) |
| WK-SSP0200-0856 | X-LOC | MSG00097 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00097: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00097) |
| WK-SSP0200-0857 | X-LOC | MSG00133 / MSG00328 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00133 / MSG00328: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00133 / MSG00328) |
| WK-SSP0200-0858 | X-LOC | MSG00174 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00174: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00174) |
| WK-SSP0200-0859 | X-LOC | MSG00189 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00189: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00189) |
| WK-SSP0200-0860 | X-LOC | MSG00195 / MSG00267 / MSG00173 / MSG0024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00195 / MSG00267 / MSG00173 / MSG00249 / MSG000: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00195 / MSG00267 / MSG00173 / MSG0024) |
| WK-SSP0200-0861 | X-LOC | MSG00248 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00248: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00248) |
| WK-SSP0200-0862 | X-LOC | MSG00284 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00284: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00284) |
| WK-SSP0200-0863 | X-LOC | MSG00293 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00293: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00293) |
| WK-SSP0200-0864 | X-LOC | R-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-12) |
| WK-SSP0200-0865 | X-LOC | R-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-13) |
| WK-SSP0200-0866 | X-LOC | R-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-14) |
| WK-SSP0200-0867 | X-LOC | R-15·R-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-15·R-16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-15·R-16) |
| WK-SSP0200-0868 | X-LOC | R-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-17: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-17) |
| WK-SSP0200-0869 | X-LOC | R-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-18: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-18) |
| WK-SSP0200-0870 | X-LOC | R-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-19: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-19) |
| WK-SSP0200-0871 | X-LOC | R-20·R-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-20·R-21: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-20·R-21) |
| WK-SSP0200-0872 | X-LOC | R-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-22: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-22) |
| WK-SSP0200-0873 | X-LOC | R-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-24: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-24) |
| WK-SSP0200-0874 | X-LOC | R-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-25: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-25) |
| WK-SSP0200-0875 | X-LOC | R-26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-26: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-26) |
| WK-SSP0200-0876 | X-LOC | R-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-27: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-27) |
| WK-SSP0200-0877 | X-LOC | R-28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-28: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-28) |
| WK-SSP0200-0878 | X-LOC | R-29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-29: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-29) |
| WK-SSP0200-0879 | X-LOC | R-31② | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-31②: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-31②) |
| WK-SSP0200-0880 | X-LOC | R-31③④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-31③④: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-31③④) |
| WK-SSP0200-0881 | X-LOC | R-31⑥⑦ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-31⑥⑦: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-31⑥⑦) |
| WK-SSP0200-0882 | X-LOC | R-40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-40: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-40) |
| WK-SSP0200-0883 | X-LOC | R-41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-41: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-41) |
| WK-SSP0200-0884 | X-LOC | R-50 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-50: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-50) |
| WK-SSP0200-0885 | X-LOC | R-51 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-51: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-51) |
| WK-SSP0200-0886 | X-LOC | R-52 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-52: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-52) |
| WK-SSP0200-0887 | X-LOC | R-60 C10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-60 C10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-60 C10) |
| WK-SSP0200-0888 | X-LOC | R-70 D10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-70 D10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-70 D10) |
| WK-SSP0200-0889 | X-LOC | R-70 D11~D16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-70 D11~D16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0890 | X-LOC | R-70 D1·D2·D4·D5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-70 D1·D2·D4·D5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-70 D1·D2·D4·D5) |
| WK-SSP0200-0891 | X-LOC | R-70 D9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-70 D9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-70 D9) |
| WK-SSP0200-0892 | X-LOC | TO-BE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TO-BE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TO-BE) |
| WK-SSP0200-0893 | X-LOC | `Confirmed` / `Change` / `Shipment Plan  | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `Confirmed` / `Change` / `Shipment Plan Qty` / `Sh: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`Confirmed` / `Change` / `Shipment Plan ) |
| WK-SSP0200-0894 | X-LOC | 설계 정본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 설계 정본: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (설계 정본) |
| WK-SSP0200-0895 | X-LOC | 자매 주의 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 자매 주의: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (자매 주의) |
| WK-SSP0200-0896 | X-LOC | 폐기 입력 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 폐기 입력: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (폐기 입력) |
| WK-SSP0200-0897 | X-LOC | 화면코드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 화면코드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (화면코드) |
| WK-SSP0200-0898 | X-ROW | **L-088** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — **L-088**: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (**L-088**) |
| WK-SSP0200-0899 | X-ROW | AS-IS 정본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AS-IS 정본: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (AS-IS 정본) |
| WK-SSP0200-0900 | X-ROW | Item.ClassToItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Item.ClassToItem: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 17 (ACT:Item.ClassToItem ACT:Item.ClassToIte) |
| WK-SSP0200-0901 | X-ROW | L-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L-001) |
| WK-SSP0200-0902 | X-ROW | L-006 ~ L-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L-006 ~ L-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L-006 ~ L-011) |
| WK-SSP0200-0903 | X-ROW | L-027·L-028·L-030·L-032·L-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L-027·L-028·L-030·L-032·L-033: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L-027·L-028·L-030·L-032·L-033) |
| WK-SSP0200-0904 | X-ROW | L-035 ~ L-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L-035 ~ L-038: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L-035 ~ L-038) |
| WK-SSP0200-0905 | X-ROW | L-051·L-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L-051·L-052: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L-051·L-052) |
| WK-SSP0200-0906 | X-ROW | L-058 ~ L-060 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L-058 ~ L-060: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L-058 ~ L-060) |
| WK-SSP0200-0907 | X-ROW | L-075·L-076 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L-075·L-076: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L-075·L-076) |
| WK-SSP0200-0908 | X-ROW | L-122 ~ L-124 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L-122 ~ L-124: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L-122 ~ L-124) |
| WK-SSP0200-0909 | X-ROW | SSP0200_ShipmentChangeRequest.Backup_Val | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.Backup_Value: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 12 (ACT:SSP0200_ShipmentChangeRequest.Backup) |
| WK-SSP0200-0910 | X-ROW | SSP0200_ShipmentChangeRequest.BtnApprova | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.BtnApprovalUser_Clic: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SSP0200_ShipmentChangeRequest.BtnApp) |
| WK-SSP0200-0911 | X-ROW | SSP0200_ShipmentChangeRequest.BtnChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.BtnChangeRe_Click: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.BtnCha) |
| WK-SSP0200-0912 | X-ROW | SSP0200_ShipmentChangeRequest.BtnNew_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.BtnNew_Click: 진입점 집계 36검사 — NOT_RUN:25 · NOPATH:10 · TODO:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0200_ShipmentChangeRequest.BtnNew) |
| WK-SSP0200-0913 | X-ROW | SSP0200_ShipmentChangeRequest.CboChangeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.CboChangeType_Select: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.CboCha) |
| WK-SSP0200-0914 | X-ROW | SSP0200_ShipmentChangeRequest.Change_ReV | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.Change_ReValue: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 15 (ACT:SSP0200_ShipmentChangeRequest.Change) |
| WK-SSP0200-0915 | X-ROW | SSP0200_ShipmentChangeRequest.ClearReque | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.ClearRequestInfo: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG/VALUE_CLEAR/VALUE_SET, 연결된 요소  |  | 10 (ACT:SSP0200_ShipmentChangeRequest.ClearR) |
| WK-SSP0200-0916 | X-ROW | SSP0200_ShipmentChangeRequest.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Create) |
| WK-SSP0200-0917 | X-ROW | SSP0200_ShipmentChangeRequest.DefineProp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0200_ShipmentChangeRequest.Define) |
| WK-SSP0200-0918 | X-ROW | SSP0200_ShipmentChangeRequest.DeleteData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.DeleteDataDrafting: 진입점 집계 10검사 — NOT_RUN:7 · PASS:3 (미실행 검사가 남아 판정필요) |  | 45 (ACT:SSP0200_ShipmentChangeRequest.Delete) |
| WK-SSP0200-0919 | X-ROW | SSP0200_ShipmentChangeRequest.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.FindBu) |
| WK-SSP0200-0920 | X-ROW | SSP0200_ShipmentChangeRequest.FindData_B | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.FindData_BOD: 진입점 집계 12검사 — NOT_RUN:7 · NOPATH:3 · REVIEW:1 · PASS:1 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0921 | X-ROW | SSP0200_ShipmentChangeRequest.FindData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.FindData_Main: 진입점 집계 14검사 — NOT_RUN:12 · REVIEW:1 · PASS:1 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0922 | X-ROW | SSP0200_ShipmentChangeRequest.FindData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.FindData_Main_Nonasy: 진입점 집계 13검사 — NOT_RUN:11 · REVIEW:1 · PASS:1 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0923 | X-ROW | SSP0200_ShipmentChangeRequest.FindData_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.FindData_Sub_Draft: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:1 · PASS:1 |  | 5 (ACT:SSP0200_ShipmentChangeRequest.FindDa) |
| WK-SSP0200-0924 | X-ROW | SSP0200_ShipmentChangeRequest.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Form_L) |
| WK-SSP0200-0925 | X-ROW | SSP0200_ShipmentChangeRequest.GetDayRang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetDay) |
| WK-SSP0200-0926 | X-ROW | SSP0200_ShipmentChangeRequest.GetDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.GetDivision: 진입점 집계 10검사 — NOT_RUN:4 · NOPATH:3 · REVIEW:2 · TODO:1 |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetDiv) |
| WK-SSP0200-0927 | X-ROW | SSP0200_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFCheck: 진입점 집계 9검사 — NOT_RUN:6 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0928 | X-ROW | SSP0200_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFCheckNew: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0929 | X-ROW | SSP0200_ShipmentChangeRequest.GetErpIFSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpIFSeqMerge: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0930 | X-ROW | SSP0200_ShipmentChangeRequest.GetErpSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.GetErpSoNoCnt: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetErp) |
| WK-SSP0200-0931 | X-ROW | SSP0200_ShipmentChangeRequest.GetItemFro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.GetItemFromBOD: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetIte) |
| WK-SSP0200-0932 | X-ROW | SSP0200_ShipmentChangeRequest.GetPlantSi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.GetPlantSiteByDivisi: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetPla) |
| WK-SSP0200-0933 | X-ROW | SSP0200_ShipmentChangeRequest.GetShipmen | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.GetShipmentPlanPlant: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.GetShi) |
| WK-SSP0200-0934 | X-ROW | SSP0200_ShipmentChangeRequest.InitContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.InitControls: 진입점 집계 20검사 — NOT_RUN:20 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0200_ShipmentChangeRequest.InitCo) |
| WK-SSP0200-0935 | X-ROW | SSP0200_ShipmentChangeRequest.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.InitSpread: 진입점 집계 105검사 — NOT_RUN:105 (미실행 검사가 남아 판정필요) |  | 22 (ACT:SSP0200_ShipmentChangeRequest.InitSp) |
| WK-SSP0200-0936 | X-ROW | SSP0200_ShipmentChangeRequest.InsertButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0937 | X-ROW | SSP0200_ShipmentChangeRequest.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.InsertRow: 진입점 집계 31검사 — NOT_RUN:21 · NOPATH:9 · TODO:1 (미실행 검사가 남아 판정필요) |  | 53 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0938 | X-ROW | SSP0200_ShipmentChangeRequest.InsertRowM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.InsertRowMultiple: 진입점 집계 30검사 — NOT_RUN:20 · NOPATH:9 · TODO:1 (미실행 검사가 남아 판정필요) |  | 68 (ACT:SSP0200_ShipmentChangeRequest.Insert) |
| WK-SSP0200-0939 | X-ROW | SSP0200_ShipmentChangeRequest.NewNonSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.NewNonSoNo: 진입점 집계 5검사 — NOT_RUN:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 138 (ACT:SSP0200_ShipmentChangeRequest.NewNon) |
| WK-SSP0200-0940 | X-ROW | SSP0200_ShipmentChangeRequest.NonSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.NonSoNo: 진입점 집계 6검사 — NOT_RUN:5 · PASS:1 (미실행 검사가 남아 판정필요) |  | 152 (ACT:SSP0200_ShipmentChangeRequest.NonSoN) |
| WK-SSP0200-0941 | X-ROW | SSP0200_ShipmentChangeRequest.SSP_Main_V | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SSP_Main_Validation: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 125 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0942 | X-ROW | SSP0200_ShipmentChangeRequest.SSP_Main_V | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SSP_Main_Validation_: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SSP0200_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0200-0943 | X-ROW | SSP0200_ShipmentChangeRequest.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SaveButton: 진입점 집계 28검사 — NOT_RUN:18 · PASS:8 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0200_ShipmentChangeRequest.SaveBu) |
| WK-SSP0200-0944 | X-ROW | SSP0200_ShipmentChangeRequest.SaveDataDr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SaveDataDrafting: 진입점 집계 17검사 — NOT_RUN:12 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0200_ShipmentChangeRequest.SaveDa) |
| WK-SSP0200-0945 | X-ROW | SSP0200_ShipmentChangeRequest.SetButtonV | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SetButtonVisual: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0200_ShipmentChangeRequest.SetBut) |
| WK-SSP0200-0946 | X-ROW | SSP0200_ShipmentChangeRequest.SetChangeC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangeControl: 진입점 집계 6검사 — REVIEW:2 · NOT_RUN:2 · NOPATH:1 · TODO:1 |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0947 | X-ROW | SSP0200_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangeRequestInfo: 진입점 집계 20검사 — NOT_RUN:18 · REVIEW:2 |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0948 | X-ROW | SSP0200_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangeRequestSOGr: 진입점 집계 18검사 — NOT_RUN:16 · REVIEW:2 |  | 22 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0949 | X-ROW | SSP0200_ShipmentChangeRequest.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SetChangedControl: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0200_ShipmentChangeRequest.SetCha) |
| WK-SSP0200-0950 | X-ROW | SSP0200_ShipmentChangeRequest.SetMainSta | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SetMainStatus: 진입점 집계 20검사 — NOT_RUN:18 · REVIEW:2 |  | 20 (ACT:SSP0200_ShipmentChangeRequest.SetMai) |
| WK-SSP0200-0951 | X-ROW | SSP0200_ShipmentChangeRequest.SoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SoNo: 진입점 집계 6검사 — NOT_RUN:5 · PASS:1 (미실행 검사가 남아 판정필요) |  | 175 (ACT:SSP0200_ShipmentChangeRequest.SoNo A) |
| WK-SSP0200-0952 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SpdMain_CellClick: 진입점 집계 19검사 — NOT_RUN:10 · NOPATH:8 · TODO:1 (미실행 검사가 남아 판정필요) |  | 70 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0953 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SpdMain_CellDoubleCl: 진입점 집계 31검사 — NOT_RUN:19 · NOPATH:12 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0954 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_Co | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SpdMain_ComboSelChan: 진입점 집계 83검사 — NOT_RUN:73 · NOPATH:9 · TODO:1 (미실행 검사가 남아 판정필요) |  | 45 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0955 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_Cu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SpdMain_CursorChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0956 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_Ed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SpdMain_EditChange: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 52 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0957 | X-ROW | SSP0200_ShipmentChangeRequest.SpdMain_To | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.SpdMai) |
| WK-SSP0200-0958 | X-ROW | SSP0200_ShipmentChangeRequest.btnInsertM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.btnInsertMultiple_Cl: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0200_ShipmentChangeRequest.btnIns) |
| WK-SSP0200-0959 | X-ROW | SSP0200_ShipmentChangeRequest.btnItemId_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.btnItemId_Click: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequest.btnIte) |
| WK-SSP0200-0960 | X-ROW | SSP0200_ShipmentChangeRequest.checkRequi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.checkRequired: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SSP0200_ShipmentChangeRequest.checkR) |
| WK-SSP0200-0961 | X-ROW | SSP0200_ShipmentChangeRequest.chkERPIFBl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.chkERPIFBlockYn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0200_ShipmentChangeRequest.chkERP) |
| WK-SSP0200-0962 | X-ROW | SSP0200_ShipmentChangeRequest.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.clbDivision_ID_Selec: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0200_ShipmentChangeRequest.clbDiv) |
| WK-SSP0200-0963 | X-ROW | SSP0200_ShipmentChangeRequest.setEndCust | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.setEndCustomer: 진입점 집계 14검사 — NOT_RUN:9 · NOPATH:3 · REVIEW:2 |  | 3 (ACT:SSP0200_ShipmentChangeRequest.setEnd) |
| WK-SSP0200-0964 | X-ROW | SSP0200_ShipmentChangeRequest.shtMain_Ch | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequest.shtMain_Change: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 106 (ACT:SSP0200_ShipmentChangeRequest.shtMai) |
| WK-SSP0200-0965 | X-ROW | SSP0200_ShipmentChangeRequestInsertPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequestInsertPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0966 | X-ROW | SSP0200_ShipmentChangeRequestInsertPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequestInsertPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0967 | X-ROW | SSP0200_ShipmentChangeRequestInsertPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequestInsertPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0968 | X-ROW | SSP0200_ShipmentChangeRequestInsertPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequestInsertPopup.SaveData: 진입점 집계 6검사 — NOT_RUN:3 · NOPATH:2 · REVIEW:1 |  | 2 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0969 | X-ROW | SSP0200_ShipmentChangeRequestInsertPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0200_ShipmentChangeRequestInsertPopup.Validatio: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0200_ShipmentChangeRequestInsertP) |
| WK-SSP0200-0970 | X-ROW | TO-BE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — TO-BE: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (TO-BE) |
| WK-SSP0200-0971 | X-ROW | `Confirmed` / `Change` / `Shipment Plan  | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `Confirmed` / `Change` / `Shipment Plan Qty` / `Sh: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`Confirmed` / `Change` / `Shipment Plan ) |
| WK-SSP0200-0972 | X-ROW | 자매 주의 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 자매 주의: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (자매 주의) |
| WK-SSP0200-0973 | X-ROW | 폐기 입력 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 폐기 입력: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (폐기 입력) |
| WK-SSP0200-0974 | X-ROW | 화면코드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 화면코드: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (화면코드) |
| WK-SSP0200-0975 | G5 | R-70 D11~D16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — R-70 D11~D16: 행 집계 — G5 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0976 | H6 | R-70 D11~D16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — R-70 D11~D16: 행 집계 — H6 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (R-70 D11~D16) |
| WK-SSP0200-0977 | M4 | R-70 D11~D16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — R-70 D11~D16: 행 집계 — M4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (R-70 D11~D16) |

## W8 구현 후 검증 (29)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0200-0978 | B3 | L-151 | 선행 W1 완료 후 E2E | B3 — 대조표 미구현 행 L-151 구현 후 검증 · 대상 L-151 |  | 1 (L-151) |
| WK-SSP0200-0979 | B4 | L-151 | 선행 W1 완료 후 E2E | B4 — 대조표 미구현 행 L-151 구현 후 검증 · 대상 L-151 |  | 1 (L-151) |
| WK-SSP0200-0980 | A5 | R-31① | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-31① 구현 후 검증 · 대상 R-31① |  | 1 (R-31①) |
| WK-SSP0200-0981 | A5 | R-60 C12·C13 | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-60 C12·C13 구현 후 검증 · 대상 R-60 C12·C13 |  | 1 (R-60 C12·C13) |
| WK-SSP0200-0982 | A5 | R-60 C7~C9 | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-60 C7~C9 구현 후 검증 · 대상 R-60 C7~C9 |  | 1 (R-60 C7~C9) |
| WK-SSP0200-0983 | A5 | R-70 D18 | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-70 D18 구현 후 검증 · 대상 R-70 D18 |  | 1 (R-70 D18) |
| WK-SSP0200-0984 | A5 | R-70 D3·D6 | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-70 D3·D6 구현 후 검증 · 대상 R-70 D3·D6 |  | 1 (R-70 D3·D6) |
| WK-SSP0200-0985 | G4 | **C4** | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 **C4** 구현 후 검증 · 대상 **C4** |  | 1 (**C4**) |
| WK-SSP0200-0986 | H2 | R-31① | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-31① 구현 후 검증 · 대상 R-31① |  | 1 (R-31①) |
| WK-SSP0200-0987 | H2 | R-60 C12·C13 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-60 C12·C13 구현 후 검증 · 대상 R-60 C12·C13 |  | 1 (R-60 C12·C13) |
| WK-SSP0200-0988 | H2 | R-60 C7~C9 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-60 C7~C9 구현 후 검증 · 대상 R-60 C7~C9 |  | 1 (R-60 C7~C9) |
| WK-SSP0200-0989 | H2 | R-70 D18 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-70 D18 구현 후 검증 · 대상 R-70 D18 |  | 1 (R-70 D18) |
| WK-SSP0200-0990 | H2 | R-70 D3·D6 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-70 D3·D6 구현 후 검증 · 대상 R-70 D3·D6 |  | 1 (R-70 D3·D6) |
| WK-SSP0200-0991 | H3 | **L-065·L-070·L-071** | 선행 W1 완료 후 E2E | H3 — 대조표 미구현 행 **L-065·L-070·L-071** 구현 후 검증 · 대상 **L-065·L-070·L-071** |  | 1 (**L-065·L-070·L-071**) |
| WK-SSP0200-0992 | H5 | R-31① | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-31① 구현 후 검증 · 대상 R-31① |  | 1 (R-31①) |
| WK-SSP0200-0993 | H5 | R-60 C12·C13 | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-60 C12·C13 구현 후 검증 · 대상 R-60 C12·C13 |  | 1 (R-60 C12·C13) |
| WK-SSP0200-0994 | H5 | R-60 C7~C9 | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-60 C7~C9 구현 후 검증 · 대상 R-60 C7~C9 |  | 1 (R-60 C7~C9) |
| WK-SSP0200-0995 | H5 | R-70 D18 | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-70 D18 구현 후 검증 · 대상 R-70 D18 |  | 1 (R-70 D18) |
| WK-SSP0200-0996 | H5 | R-70 D3·D6 | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-70 D3·D6 구현 후 검증 · 대상 R-70 D3·D6 |  | 1 (R-70 D3·D6) |
| WK-SSP0200-0997 | D4 | **C4** | 선행 W1 완료 후 E2E | D4 — 대조표 미구현 행 **C4** 구현 후 검증 · 대상 **C4** |  | 1 (**C4**) |
| WK-SSP0200-0998 | A6 | **L-152** | 선행 W1 완료 후 E2E | A6 — 대조표 미구현 행  구현 후 검증 · 대상 **L-152** |  | 1 (**L-152**) |
| WK-SSP0200-0999 | A6 | L-072 | 선행 W1 완료 후 E2E | A6 — 대조표 미구현 행  구현 후 검증 · 대상 L-072 |  | 1 (L-072) |
| WK-SSP0200-1000 | A6 | R-14 | 선행 W1 완료 후 E2E | A6 — 대조표 미구현 행  구현 후 검증 · 대상 R-14 |  | 1 (R-14) |
| WK-SSP0200-1001 | A6 | R-18 | 선행 W1 완료 후 E2E | A6 — 대조표 미구현 행  구현 후 검증 · 대상 R-18 |  | 1 (R-18) |
| WK-SSP0200-1002 | A6 | SSP0200_GET_SHIPMENT_DIVISION | 선행 W1 완료 후 E2E | A6 — 대조표 미구현 행 **C4** 구현 후 검증 · 대상 SSP0200_GET_SHIPMENT_DIVISION |  | 1 (**C4**) |
| WK-SSP0200-1003 | A6 | 자동조회 금지 | 선행 W1 완료 후 E2E | A6 — 대조표 미구현 행  구현 후 검증 · 대상 자동조회 금지 |  | 1 (자동조회 금지) |
| WK-SSP0200-1004 | G1 | **C4** | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 **C4** 구현 후 검증 · 대상 **C4** |  | 1 (**C4**) |
| WK-SSP0200-1005 | G6 | **C4** | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행 **C4** 구현 후 검증 · 대상 **C4** |  | 1 (**C4**) |
| WK-SSP0200-1006 | X-ROW | L-066 ~ L-069 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 L-066 ~ L-069 구현 후 검증 · 대상 L-066 ~ L-069 |  | 1 (L-066 ~ L-069) |
