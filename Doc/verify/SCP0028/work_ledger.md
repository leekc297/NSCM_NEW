# 작업 원장 — SCP0028 · 2026-10-26 12:53

> 검사 인스턴스 354건 중 PASS·NA 10건 외 **344건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 38 | 구현 위치 실존 |
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 21 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 124 | 실행 → PASS |
| W7 | 기대값 확정 | 158 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 158 · E2E 124 · 대조표 38 · 하네스 24
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 38 |  |  |  |  | 4 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 18 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A1 | GEN |  |  |  |  |  |  | 21 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-ROW | GEN |  |  |  |  |  |  | 21 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| D1 | EDIT |  |  |  |  |  | 8 | 12 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 8 | 12 |  |  | 행 값 기반 조건부 잠금 |
| A5 | DESIGN |  |  |  |  |  | 4 | 11 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 4 | 11 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 4 | 10 |  |  | 라벨 명칭 |
| G1 | GEN |  |  |  |  |  | 7 | 7 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G5 | POPUP |  |  |  |  | 7 |  | 5 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 4 | 3 | 5 |  |  | 팝업 표준·열림 |
| H3 | DESIGN |  |  |  |  |  | 4 | 8 |  |  | 셀 병합 = AS-IS |
| M4 | POPUP |  |  |  |  |  | 7 | 5 |  |  | 팝업 선택값 반영 |
| G4 | DESIGN |  |  |  |  | 3 | 7 | 1 |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 7 | 4 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D4 | EDIT |  |  |  |  |  | 2 | 7 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| A6 | GEN |  |  |  |  |  | 6 | 2 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G6 | GEN |  |  |  |  |  | 7 | 1 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C1 | CASCADE |  |  |  |  |  | 6 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| DB-SYN | DB |  |  |  |  | 1 |  | 4 |  |  | BE 계정 시노님·권한·대상 객체 |
| B3 | COMBO |  |  |  | 3 |  |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C2 | CASCADE |  |  |  |  |  | 2 | 1 |  |  | 그리드 셀 cascade 후보 |
| C3 | CASCADE |  |  |  |  |  | 2 | 1 |  |  | 연쇄 자동 채움 |
| C6 | CASCADE |  |  |  |  |  | 2 | 1 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| D5 | EDIT |  |  |  |  |  | 2 | 1 |  |  | 셀 에디터 유형 |
| E1 | EDIT |  |  |  |  |  | 2 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (38)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0001 | X-LOC | **SAVE SP 분기 = M/D 2종** | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**SAVE SP 분기 = M/D 2종**) |
| WK-SCP0028-0002 | X-LOC | **`FindInput` 5 CSV 위치조인 (cs:394~429)** | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**`FindInput` 5 CSV 위치조인 (cs:394~429)**) |
| WK-SCP0028-0003 | X-LOC | **toolbar DeleteButton remove-new (cs:21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0004 | X-LOC | **toolbar InsertButton no-op (cs:200~203 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**toolbar InsertButton no-op (cs:200~203) |
| WK-SCP0028-0005 | X-LOC | **저장대상 = 편집행만** (cs:582~603·631~654) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**저장대상 = 편집행만** (cs:582~603·631~654)) |
| WK-SCP0028-0006 | X-LOC | **팝업 Find — From Site 필수** (SCM0002 팝업 c | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0007 | X-LOC | **팝업 OK `SaveData` (cs:308~369)** | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0008 | X-LOC | Delete() 신규행만 (cs:213~224, #3) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Delete() 신규행만 (cs:213~224, #3)) |
| WK-SCP0028-0009 | X-LOC | EditButton SwitchLock (cs:229~236) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton SwitchLock (cs:229~236)) |
| WK-SCP0028-0010 | X-LOC | FindButton (cs) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton (cs)) |
| WK-SCP0028-0011 | X-LOC | LockColumn(DIV..TRANS,234)/(audit,235)/( | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(DIV..TRANS,234)/(audit,235)/() |
| WK-SCP0028-0012 | X-LOC | Query(ds) FindData (cs:368) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0013 | X-LOC | SaveButton SaveData (cs:574~) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton SaveData (cs:574~)) |
| WK-SCP0028-0014 | X-LOC | SetDivisionAuthCheck (cs:131~132, R1) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetDivisionAuthCheck (cs:131~132, R1)) |
| WK-SCP0028-0015 | X-LOC | SetReNumerCellType(LOT_SIZE/INCREMENT,0) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetReNumerCellType(LOT_SIZE/INCREMENT,0)) |
| WK-SCP0028-0016 | X-LOC | SetValue(INCREMENT=LOT_SIZE) (cs:735, gr | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetValue(INCREMENT=LOT_SIZE) (cs:735, gr) |
| WK-SCP0028-0017 | X-LOC | SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594, | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0018 | X-LOC | SmartColMerge (cs:371,438,721, #9/#12/#1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SmartColMerge (cs:371,438,721, #9/#12/#1) |
| WK-SCP0028-0019 | X-LOC | SwitchLock (cs:232, gridSignals#4) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SwitchLock (cs:232, gridSignals#4)) |
| WK-SCP0028-0020 | X-LOC | `FindDelete` `p_transport_mode="X"` (cs: | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`FindDelete` `p_transport_mode="X"` (cs:) |
| WK-SCP0028-0021 | X-LOC | `SetChangedControl` cascade (cs:158~171) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0022 | X-LOC | btnDelete "Delete" 일괄삭제 팝업 (cs:288~314,  | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnDelete "Delete" 일괄삭제 팝업 (cs:288~314, ) |
| WK-SCP0028-0023 | X-LOC | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0024 | X-LOC | btnItemId Item 팝업 (cs:238~257, R7) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnItemId Item 팝업 (cs:238~257, R7)) |
| WK-SCP0028-0025 | X-LOC | cboDivision `Data_SCP.Common(Type.Divisi | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0026 | X-LOC | cboOperationGroup `LookupCommon("OPERATI | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0027 | X-LOC | cboValid `DataBind(Type.YesOrNo,true)` ( | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboValid `DataBind(Type.YesOrNo,true)` () |
| WK-SCP0028-0028 | X-LOC | checkRequiredOfSpread | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (checkRequiredOfSpread) |
| WK-SCP0028-0029 | X-LOC | checkValidSize LOT<INC / 0값 (cs:762~773) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (checkValidSize LOT<INC / 0값 (cs:762~773)) |
| WK-SCP0028-0030 | X-LOC | clbFromSite `FromSiteByDivision` (cs:166 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0031 | X-LOC | clbToSite `ToSiteByDivision` (cs:169) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbToSite `ToSiteByDivision` (cs:169)) |
| WK-SCP0028-0032 | X-LOC | clbTransMode `LookupCommon("TRANSPORT_MO | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbTransMode `LookupCommon("TRANSPORT_MO) |
| WK-SCP0028-0033 | X-LOC | txtItemId + btnItemId `SCM0002_ItembyDiv | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0034 | X-LOC | 두 버튼 **노출** 조건 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0035 | X-LOC | 팝업 Form_Load `//FindData();` (cs:146) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0036 | X-LOC | 팝업 `clbFromSite`/`clbToSite` CheckedList | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (팝업 `clbFromSite`/`clbToSite` CheckedList) |
| WK-SCP0028-0037 | X-LOC | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0038 | X-LOC | 편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0039 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 3 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0040 | B3 | cboOperationGroup / Operation Group | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboOperationGroup / Operation Group | 있음(FE 소스) | 1 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0041 | B3 | clbTransMode / Trans Mode | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbTransMode / Trans Mode | 있음(FE 소스) | 1 (clbTransMode `LookupCommon("TRANSPORT_MO) |

## W5 검사기 연결 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0042 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 3 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0043 | B4 | cboOperationGroup / Operation Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboOperationGroup / Operation Group | 있음(FE 소스) | 1 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0044 | B4 | clbTransMode / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbTransMode / Trans Mode | 있음(FE 소스) | 1 (clbTransMode `LookupCommon("TRANSPORT_MO) |
| WK-SCP0028-0045 | F2 | SCP0028 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0028 화면 | 판단불가(대상 단위 SCREEN) | 83 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0046 | F6 | SCP0028 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0028 화면 | 판단불가(대상 단위 SCREEN) | 80 (SaveButton SaveData (cs:574~) **팝업 OK `S) |
| WK-SCP0028-0047 | DB-SYN | PR_GET_MNU_BTN_AUTH | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PR_GET_MNU_BTN_AUTH | 없음(PROC_M 대응 없음) | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0048 | G4 | btnDelete | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnDelete | 있음(FE 소스) | 2 (ACT:SCP0028_Shipment_Lot_Size.InitEvent ) |
| WK-SCP0028-0049 | G4 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnInput | 있음(FE 소스) | 2 (ACT:SCP0028_Shipment_Lot_Size.InitEvent ) |
| WK-SCP0028-0050 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 3 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0051 | G03-WIRE | SCP0028 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0028 화면 | 판단불가(대상 단위 SCREEN) | 11 (ACT:SCP0028_Shipment_Lot_Size..ctor ACT:) |
| WK-SCP0028-0052 | G5 | TRANS_MODE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL TRANS_MODE_CODE | 있음(SHEET_COLUMNS) | 1 (`FindDelete` `p_transport_mode="X"` (cs:) |
| WK-SCP0028-0053 | G5 | btnDelete | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnDelete | 있음(FE 소스) | 1 (btnDelete "Delete" 일괄삭제 팝업 (cs:288~314, ) |
| WK-SCP0028-0054 | G5 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnInput | 있음(FE 소스) | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0055 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 2 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0056 | G5 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 2 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0057 | G5 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 1 (팝업 `clbFromSite`/`clbToSite` CheckedList) |
| WK-SCP0028-0058 | G5 | txtItemId / Model / Item Id | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Item Id | 있음(FE 소스) | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0059 | H6 | TRANS_MODE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TRANS_MODE_CODE | 있음(SHEET_COLUMNS) | 1 (`FindDelete` `p_transport_mode="X"` (cs:) |
| WK-SCP0028-0060 | H6 | btnDelete | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnDelete | 있음(FE 소스) | 1 (btnDelete "Delete" 일괄삭제 팝업 (cs:288~314, ) |
| WK-SCP0028-0061 | H6 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnInput | 있음(FE 소스) | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0062 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 2 (txtItemId + btnItemId `SCM0002_ItembyDiv) |

## W6 검증 실행 (124)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0063 | J2 | SCP0028 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0028 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 80 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0064 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0028_Shipment_Lot_Size.InitContro) |
| WK-SCP0028-0065 | C1 | cboOperationGroup / Operation Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOperationGroup / Operation Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0028_Shipment_Lot_Size.InitContro) |
| WK-SCP0028-0066 | C1 | cboValid / Valid | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0028_Shipment_Lot_Size.InitContro) |
| WK-SCP0028-0067 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0028_Shipment_Lot_Size.SetChanged) |
| WK-SCP0028-0068 | C1 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0028_Shipment_Lot_Size.SetChanged) |
| WK-SCP0028-0069 | C1 | clbTransMode / Trans Mode | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTransMode / Trans Mode · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0028_Shipment_Lot_Size.InitContro) |
| WK-SCP0028-0070 | C2 | INCREMENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — INCREMENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SetValue(INCREMENT=LOT_SIZE) (cs:735, gr) |
| WK-SCP0028-0071 | C2 | LOT_SIZE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LOT_SIZE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SetValue(INCREMENT=LOT_SIZE) (cs:735, gr) |
| WK-SCP0028-0072 | C3 | INCREMENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — INCREMENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (SetValue(INCREMENT=LOT_SIZE) (cs:735, gr) |
| WK-SCP0028-0073 | C3 | LOT_SIZE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LOT_SIZE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (SetValue(INCREMENT=LOT_SIZE) (cs:735, gr) |
| WK-SCP0028-0074 | C6 | INCREMENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — INCREMENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SetValue(INCREMENT=LOT_SIZE) (cs:735, gr) |
| WK-SCP0028-0075 | C6 | LOT_SIZE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LOT_SIZE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SetValue(INCREMENT=LOT_SIZE) (cs:735, gr) |
| WK-SCP0028-0076 | G3 | SCP0028 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0028 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0077 | K-SA | SCP0028 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0028 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0078 | K4 | SCP0028 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0028 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 44 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0079 | F1 | SCP0028 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0028 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 98 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0080 | F5 | SCP0028 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0028 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 16 (Delete() 신규행만 (cs:213~224, #3) **SAVE SP) |
| WK-SCP0028-0081 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0082 | F4 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0083 | F4 | PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_S | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0084 | F4 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_S | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 117 (P_SCP0028_GET_SHIPMENT_LOT_SIZE ACT:SCP0) |
| WK-SCP0028-0085 | F4 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_S | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 4 (P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT AC) |
| WK-SCP0028-0086 | F4 | PKG_SCP0028.P_SCP0028_SAVE_SHIPMENT_LOT_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0028.P_SCP0028_SAVE_SHIPMENT_LOT_SIZE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 80 (P_SCP0028_SAVE_SHIPMENT_LOT_SIZE ACT:SCP) |
| WK-SCP0028-0087 | F4 | PR_GET_MNU_BTN_AUTH | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PR_GET_MNU_BTN_AUTH · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0088 | A5 | INCREMENT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — INCREMENT · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0089 | A5 | LOT_SIZE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LOT_SIZE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0090 | A5 | SPLIT_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SPLIT_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0091 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0092 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0093 | G4 | cboOperationGroup / Operation Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOperationGroup / Operation Group · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0094 | G4 | cboValid / Valid | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (cboValid `DataBind(Type.YesOrNo,true)` () |
| WK-SCP0028-0095 | G4 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFromSite / From Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0096 | G4 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbToSite / To Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbToSite `ToSiteByDivision` (cs:169)) |
| WK-SCP0028-0097 | G4 | clbTransMode / Trans Mode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTransMode / Trans Mode · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (clbTransMode `LookupCommon("TRANSPORT_MO) |
| WK-SCP0028-0098 | G4 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0099 | H2 | INCREMENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — INCREMENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0100 | H2 | LOT_SIZE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LOT_SIZE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0101 | H2 | SPLIT_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SPLIT_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0102 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0103 | H3 | INCREMENT | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — INCREMENT · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 3 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0104 | H3 | LOT_SIZE | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — LOT_SIZE · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 3 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0105 | H3 | SPLIT_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — SPLIT_YN · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0106 | H3 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0107 | H4 | SCP0028 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0028 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SCP0028_Shipment_Lot_Size.SpdMain_To) |
| WK-SCP0028-0108 | H5 | INCREMENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — INCREMENT · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0109 | H5 | LOT_SIZE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LOT_SIZE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0110 | H5 | SPLIT_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SPLIT_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0111 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0112 | I1 | SCP0028 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0028 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 9 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0113 | SC1 | SCP0028 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0028 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0114 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0028_Shipment_Lot_Size.EditButton) |
| WK-SCP0028-0115 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0028_Shipment_Lot_Size.EditButton) |
| WK-SCP0028-0116 | D1 | INCREMENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — INCREMENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0117 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0028_Shipment_Lot_Size.EditButton) |
| WK-SCP0028-0118 | D1 | LOT_SIZE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LOT_SIZE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0119 | D1 | SPLIT_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SPLIT_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0120 | D1 | TRANS_MODE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TRANS_MODE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0028_Shipment_Lot_Size.EditButton) |
| WK-SCP0028-0121 | D1 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0122 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0028_Shipment_Lot_Size.EditButton) |
| WK-SCP0028-0123 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0028_Shipment_Lot_Size.EditButton) |
| WK-SCP0028-0124 | D3 | INCREMENT | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — INCREMENT · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0125 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0028_Shipment_Lot_Size.EditButton) |
| WK-SCP0028-0126 | D3 | LOT_SIZE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LOT_SIZE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0127 | D3 | SPLIT_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SPLIT_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0128 | D3 | TRANS_MODE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TRANS_MODE_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0028_Shipment_Lot_Size.EditButton) |
| WK-SCP0028-0129 | D3 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (편집 4컬럼 LOT_SIZE/INCREMENT/VALID_YN/SPLIT) |
| WK-SCP0028-0130 | D4 | INCREMENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — INCREMENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (SetValue(INCREMENT=LOT_SIZE) (cs:735, gr) |
| WK-SCP0028-0131 | D4 | LOT_SIZE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — LOT_SIZE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (SetValue(INCREMENT=LOT_SIZE) (cs:735, gr) |
| WK-SCP0028-0132 | D5 | INCREMENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — INCREMENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0028_Shipment_Lot_Size.InitSpread) |
| WK-SCP0028-0133 | D5 | LOT_SIZE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LOT_SIZE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0028_Shipment_Lot_Size.InitSpread) |
| WK-SCP0028-0134 | D6 | SCP0028 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0028 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 7 (**SAVE SP 분기 = M/D 2종** **toolbar Insert) |
| WK-SCP0028-0135 | E1 | INCREMENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — INCREMENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (SetReNumerCellType(LOT_SIZE/INCREMENT,0)) |
| WK-SCP0028-0136 | E1 | LOT_SIZE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — LOT_SIZE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (SetReNumerCellType(LOT_SIZE/INCREMENT,0)) |
| WK-SCP0028-0137 | E4 | LOT_SIZE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LOT_SIZE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0028_Shipment_Lot_Size.checkValid) |
| WK-SCP0028-0138 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0139 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0028_Shipment_Lot_Size.SaveData:6) |
| WK-SCP0028-0140 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0028_Shipment_Lot_Size.SaveData:7) |
| WK-SCP0028-0141 | E4 | MSG00014 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00014 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0142 | E4 | MSG00016 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00016 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0143 | E4 | MSG00031 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00031 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0144 | E4 | MSG00059 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00059 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0145 | E4 | MSG00084 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00084 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0028_Shipment_Lot_Size.checkValid) |
| WK-SCP0028-0146 | E4 | MSG00099 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00099 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0028_Shipment_Lot_Size.checkValid) |
| WK-SCP0028-0147 | E4 | MSG00133 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00133 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0028_Shipment_Lot_Size.SaveData:6) |
| WK-SCP0028-0148 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0149 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0150 | E4 | MSG00683 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00683 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0151 | E4 | MSG01091 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01091 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0152 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 4 (ACT:SCP0028_Shipment_Lot_Size.SetChanged) |
| WK-SCP0028-0153 | E4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 3 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0154 | E4 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0028_Shipment_Lot_Size.SetChanged) |
| WK-SCP0028-0155 | A10 | SCP0028 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0028 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 29 (ACT:SCP0028_Shipment_Lot_Size.Form_Load ) |
| WK-SCP0028-0156 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0157 | A6 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0158 | A6 | PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_S | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURC |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0159 | A6 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_S | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조 |  | 41 (P_SCP0028_GET_SHIPMENT_LOT_SIZE ACT:SCP0) |
| WK-SCP0028-0160 | A6 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_S | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURC |  | 1 (P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT) |
| WK-SCP0028-0161 | A6 | PR_GET_MNU_BTN_AUTH | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PR_GET_MNU_BTN_AUTH · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0162 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0163 | G1 | cboOperationGroup / Operation Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboOperationGroup / Operation Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0164 | G1 | cboValid / Valid | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboValid `DataBind(Type.YesOrNo,true)` () |
| WK-SCP0028-0165 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0166 | G1 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbToSite / To Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbToSite `ToSiteByDivision` (cs:169) AC) |
| WK-SCP0028-0167 | G1 | clbTransMode / Trans Mode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTransMode / Trans Mode · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbTransMode `LookupCommon("TRANSPORT_MO) |
| WK-SCP0028-0168 | G1 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0169 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0170 | G6 | cboOperationGroup / Operation Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOperationGroup / Operation Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0171 | G6 | cboValid / Valid | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (cboValid `DataBind(Type.YesOrNo,true)` () |
| WK-SCP0028-0172 | G6 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0173 | G6 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbToSite `ToSiteByDivision` (cs:169)) |
| WK-SCP0028-0174 | G6 | clbTransMode / Trans Mode | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTransMode / Trans Mode · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (clbTransMode `LookupCommon("TRANSPORT_MO) |
| WK-SCP0028-0175 | G6 | txtItemId / Model / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0176 | X-REOPEN | SCP0028 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0028 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 8 (ACT:SCP0028_Shipment_Lot_Size.Dispose AC) |
| WK-SCP0028-0177 | H6 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbFromSite / From Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0178 | H6 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbToSite / To Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (팝업 `clbFromSite`/`clbToSite` CheckedList) |
| WK-SCP0028-0179 | H6 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0180 | M4 | TRANS_MODE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TRANS_MODE_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (`FindDelete` `p_transport_mode="X"` (cs:) |
| WK-SCP0028-0181 | M4 | btnDelete | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnDelete · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (btnDelete "Delete" 일괄삭제 팝업 (cs:288~314, ) |
| WK-SCP0028-0182 | M4 | btnInput | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnInput · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0183 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0184 | M4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0185 | M4 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (팝업 `clbFromSite`/`clbToSite` CheckedList) |
| WK-SCP0028-0186 | M4 | txtItemId / Model / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Item Id · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |

## W7 기대값 확정 (158)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0028-0187 | C2 | SCP0028_Shipment_Lot_Size.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0028_Shipment_Lot_Size.ClbDivision_SelectedInde: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.ClbDivisio) |
| WK-SCP0028-0188 | C3 | SCP0028_Shipment_Lot_Size.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0028_Shipment_Lot_Size.ClbDivision_SelectedInde: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.ClbDivisio) |
| WK-SCP0028-0189 | C6 | SCP0028_Shipment_Lot_Size.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0028_Shipment_Lot_Size.ClbDivision_SelectedInde: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.ClbDivisio) |
| WK-SCP0028-0190 | DB-SYN | **팝업 OK `SaveData` (cs:308~369)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — DB-SYN 7요소: PASS:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0191 | DB-SYN | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — DB-SYN 7요소: PASS:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0192 | DB-SYN | SaveButton SaveData (cs:574~) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SaveButton SaveData (cs:574~): 행 집계 — DB-SYN 7요소: PASS:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton SaveData (cs:574~)) |
| WK-SCP0028-0193 | DB-SYN | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — DB-SYN 7요소: PASS:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0194 | F4 | **팝업 OK `SaveData` (cs:308~369)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0195 | F4 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0196 | F4 | SaveButton SaveData (cs:574~) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveButton SaveData (cs:574~): 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton SaveData (cs:574~)) |
| WK-SCP0028-0197 | F4 | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0198 | A5 | **팝업 OK `SaveData` (cs:308~369)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0199 | A5 | Delete() 신규행만 (cs:213~224, #3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Delete() 신규행만 (cs:213~224, #3): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Delete() 신규행만 (cs:213~224, #3)) |
| WK-SCP0028-0200 | A5 | LockColumn(DIV..TRANS,234)/(audit,235)/( | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — LockColumn(DIV..TRANS,234)/(audit,235)/(0..max,369: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(DIV..TRANS,234)/(audit,235)/() |
| WK-SCP0028-0201 | A5 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0202 | A5 | SCP0028_Shipment_Lot_Size.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0028_Shipment_Lot_Size.CreateSpread: 진입점 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0028_Shipment_Lot_Size.CreateSpre) |
| WK-SCP0028-0203 | A5 | SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594, | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0204 | A5 | SmartColMerge (cs:371,438,721, #9/#12/#1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SmartColMerge (cs:371,438,721, #9/#12/#15): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge (cs:371,438,721, #9/#12/#1) |
| WK-SCP0028-0205 | A5 | SwitchLock (cs:232, gridSignals#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SwitchLock (cs:232, gridSignals#4): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock (cs:232, gridSignals#4)) |
| WK-SCP0028-0206 | A5 | checkRequiredOfSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — checkRequiredOfSpread: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSpread) |
| WK-SCP0028-0207 | A5 | checkValidSize LOT<INC / 0값 (cs:762~773) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — checkValidSize LOT<INC / 0값 (cs:762~773): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (checkValidSize LOT<INC / 0값 (cs:762~773)) |
| WK-SCP0028-0208 | A5 | 두 버튼 **노출** 조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 두 버튼 **노출** 조건: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0209 | G4 | `SetChangedControl` cascade (cs:158~171) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `SetChangedControl` cascade (cs:158~171): 행 집계 — G4 10요소: NOT_RUN:7 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0210 | H2 | **팝업 OK `SaveData` (cs:308~369)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0211 | H2 | Delete() 신규행만 (cs:213~224, #3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Delete() 신규행만 (cs:213~224, #3): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Delete() 신규행만 (cs:213~224, #3)) |
| WK-SCP0028-0212 | H2 | LockColumn(DIV..TRANS,234)/(audit,235)/( | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — LockColumn(DIV..TRANS,234)/(audit,235)/(0..max,369: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(DIV..TRANS,234)/(audit,235)/() |
| WK-SCP0028-0213 | H2 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0214 | H2 | SCP0028_Shipment_Lot_Size.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0028_Shipment_Lot_Size.CreateSpread: 진입점 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0028_Shipment_Lot_Size.CreateSpre) |
| WK-SCP0028-0215 | H2 | SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594, | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0216 | H2 | SmartColMerge (cs:371,438,721, #9/#12/#1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SmartColMerge (cs:371,438,721, #9/#12/#15): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge (cs:371,438,721, #9/#12/#1) |
| WK-SCP0028-0217 | H2 | SwitchLock (cs:232, gridSignals#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SwitchLock (cs:232, gridSignals#4): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock (cs:232, gridSignals#4)) |
| WK-SCP0028-0218 | H2 | checkRequiredOfSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — checkRequiredOfSpread: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSpread) |
| WK-SCP0028-0219 | H2 | checkValidSize LOT<INC / 0값 (cs:762~773) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — checkValidSize LOT<INC / 0값 (cs:762~773): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (checkValidSize LOT<INC / 0값 (cs:762~773)) |
| WK-SCP0028-0220 | H2 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0221 | H3 | Delete() 신규행만 (cs:213~224, #3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — Delete() 신규행만 (cs:213~224, #3): 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Delete() 신규행만 (cs:213~224, #3)) |
| WK-SCP0028-0222 | H3 | LockColumn(DIV..TRANS,234)/(audit,235)/( | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — LockColumn(DIV..TRANS,234)/(audit,235)/(0..max,369: 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(DIV..TRANS,234)/(audit,235)/() |
| WK-SCP0028-0223 | H3 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0224 | H3 | SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594, | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#: 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0225 | H3 | SmartColMerge (cs:371,438,721, #9/#12/#1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — SmartColMerge (cs:371,438,721, #9/#12/#15): 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge (cs:371,438,721, #9/#12/#1) |
| WK-SCP0028-0226 | H3 | SwitchLock (cs:232, gridSignals#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — SwitchLock (cs:232, gridSignals#4): 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock (cs:232, gridSignals#4)) |
| WK-SCP0028-0227 | H3 | checkRequiredOfSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — checkRequiredOfSpread: 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSpread) |
| WK-SCP0028-0228 | H3 | checkValidSize LOT<INC / 0값 (cs:762~773) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — checkValidSize LOT<INC / 0값 (cs:762~773): 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (checkValidSize LOT<INC / 0값 (cs:762~773)) |
| WK-SCP0028-0229 | H5 | **팝업 OK `SaveData` (cs:308~369)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0230 | H5 | Delete() 신규행만 (cs:213~224, #3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Delete() 신규행만 (cs:213~224, #3): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Delete() 신규행만 (cs:213~224, #3)) |
| WK-SCP0028-0231 | H5 | LockColumn(DIV..TRANS,234)/(audit,235)/( | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — LockColumn(DIV..TRANS,234)/(audit,235)/(0..max,369: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(DIV..TRANS,234)/(audit,235)/() |
| WK-SCP0028-0232 | H5 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0233 | H5 | SCP0028_Shipment_Lot_Size.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0028_Shipment_Lot_Size.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0028_Shipment_Lot_Size.CreateSpre) |
| WK-SCP0028-0234 | H5 | SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594, | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0235 | H5 | SmartColMerge (cs:371,438,721, #9/#12/#1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SmartColMerge (cs:371,438,721, #9/#12/#15): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge (cs:371,438,721, #9/#12/#1) |
| WK-SCP0028-0236 | H5 | SwitchLock (cs:232, gridSignals#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SwitchLock (cs:232, gridSignals#4): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock (cs:232, gridSignals#4)) |
| WK-SCP0028-0237 | H5 | checkRequiredOfSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — checkRequiredOfSpread: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSpread) |
| WK-SCP0028-0238 | H5 | checkValidSize LOT<INC / 0값 (cs:762~773) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — checkValidSize LOT<INC / 0값 (cs:762~773): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (checkValidSize LOT<INC / 0값 (cs:762~773)) |
| WK-SCP0028-0239 | D1 | **저장대상 = 편집행만** (cs:582~603·631~654) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — **저장대상 = 편집행만** (cs:582~603·631~654): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (**저장대상 = 편집행만** (cs:582~603·631~654)) |
| WK-SCP0028-0240 | D1 | Delete() 신규행만 (cs:213~224, #3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Delete() 신규행만 (cs:213~224, #3): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Delete() 신규행만 (cs:213~224, #3)) |
| WK-SCP0028-0241 | D1 | EditButton SwitchLock (cs:229~236) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton SwitchLock (cs:229~236): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (EditButton SwitchLock (cs:229~236)) |
| WK-SCP0028-0242 | D1 | LockColumn(DIV..TRANS,234)/(audit,235)/( | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — LockColumn(DIV..TRANS,234)/(audit,235)/(0..max,369: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(DIV..TRANS,234)/(audit,235)/() |
| WK-SCP0028-0243 | D1 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0244 | D1 | SCP0028_Shipment_Lot_Size.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0028_Shipment_Lot_Size.EditButton: 진입점 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0028_Shipment_Lot_Size.EditButton) |
| WK-SCP0028-0245 | D1 | SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594, | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0246 | D1 | SmartColMerge (cs:371,438,721, #9/#12/#1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SmartColMerge (cs:371,438,721, #9/#12/#15): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge (cs:371,438,721, #9/#12/#1) |
| WK-SCP0028-0247 | D1 | SwitchLock (cs:232, gridSignals#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SwitchLock (cs:232, gridSignals#4): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock (cs:232, gridSignals#4)) |
| WK-SCP0028-0248 | D1 | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — btnInput "Input" 일괄입력 팝업 (cs:260~286, R5): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0249 | D1 | checkRequiredOfSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — checkRequiredOfSpread: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSpread) |
| WK-SCP0028-0250 | D1 | checkValidSize LOT<INC / 0값 (cs:762~773) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — checkValidSize LOT<INC / 0값 (cs:762~773): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (checkValidSize LOT<INC / 0값 (cs:762~773)) |
| WK-SCP0028-0251 | D3 | **저장대상 = 편집행만** (cs:582~603·631~654) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — **저장대상 = 편집행만** (cs:582~603·631~654): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (**저장대상 = 편집행만** (cs:582~603·631~654)) |
| WK-SCP0028-0252 | D3 | Delete() 신규행만 (cs:213~224, #3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Delete() 신규행만 (cs:213~224, #3): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Delete() 신규행만 (cs:213~224, #3)) |
| WK-SCP0028-0253 | D3 | EditButton SwitchLock (cs:229~236) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton SwitchLock (cs:229~236): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (EditButton SwitchLock (cs:229~236)) |
| WK-SCP0028-0254 | D3 | LockColumn(DIV..TRANS,234)/(audit,235)/( | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — LockColumn(DIV..TRANS,234)/(audit,235)/(0..max,369: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(DIV..TRANS,234)/(audit,235)/() |
| WK-SCP0028-0255 | D3 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0256 | D3 | SCP0028_Shipment_Lot_Size.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0028_Shipment_Lot_Size.EditButton: 진입점 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0028_Shipment_Lot_Size.EditButton) |
| WK-SCP0028-0257 | D3 | SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594, | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0258 | D3 | SmartColMerge (cs:371,438,721, #9/#12/#1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SmartColMerge (cs:371,438,721, #9/#12/#15): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge (cs:371,438,721, #9/#12/#1) |
| WK-SCP0028-0259 | D3 | SwitchLock (cs:232, gridSignals#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SwitchLock (cs:232, gridSignals#4): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock (cs:232, gridSignals#4)) |
| WK-SCP0028-0260 | D3 | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — btnInput "Input" 일괄입력 팝업 (cs:260~286, R5): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0261 | D3 | checkRequiredOfSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — checkRequiredOfSpread: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSpread) |
| WK-SCP0028-0262 | D3 | checkValidSize LOT<INC / 0값 (cs:762~773) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — checkValidSize LOT<INC / 0값 (cs:762~773): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (checkValidSize LOT<INC / 0값 (cs:762~773)) |
| WK-SCP0028-0263 | D4 | **SAVE SP 분기 = M/D 2종** | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — **SAVE SP 분기 = M/D 2종**: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (**SAVE SP 분기 = M/D 2종**) |
| WK-SCP0028-0264 | D4 | **toolbar DeleteButton remove-new (cs:21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — **toolbar DeleteButton remove-new (cs:213~224, R4): 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0265 | D4 | **toolbar InsertButton no-op (cs:200~203 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — **toolbar InsertButton no-op (cs:200~203, R10)**: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (**toolbar InsertButton no-op (cs:200~203) |
| WK-SCP0028-0266 | D4 | **저장대상 = 편집행만** (cs:582~603·631~654) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — **저장대상 = 편집행만** (cs:582~603·631~654): 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (**저장대상 = 편집행만** (cs:582~603·631~654)) |
| WK-SCP0028-0267 | D4 | P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT) |
| WK-SCP0028-0268 | D4 | SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594, | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,595, #13/#: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SetValue/BGColor 기본값 회귀 CRUD 해제 (cs:594,) |
| WK-SCP0028-0269 | D4 | 두 버튼 **노출** 조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 두 버튼 **노출** 조건: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0270 | D5 | SCP0028_Shipment_Lot_Size.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0028_Shipment_Lot_Size.CreateSpread: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0028_Shipment_Lot_Size.CreateSpre) |
| WK-SCP0028-0271 | E4 | **저장대상 = 편집행만** (cs:582~603·631~654) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — **저장대상 = 편집행만** (cs:582~603·631~654): 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (**저장대상 = 편집행만** (cs:582~603·631~654)) |
| WK-SCP0028-0272 | E4 | checkRequiredOfSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — checkRequiredOfSpread: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSpread) |
| WK-SCP0028-0273 | E4 | checkValidSize LOT<INC / 0값 (cs:762~773) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — checkValidSize LOT<INC / 0값 (cs:762~773): 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (checkValidSize LOT<INC / 0값 (cs:762~773)) |
| WK-SCP0028-0274 | A1 | **toolbar DeleteButton remove-new (cs:21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **toolbar DeleteButton remove-new (cs:213~224, R4): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0275 | A1 | **팝업 Find — From Site 필수** (SCM0002 팝업 c | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **팝업 Find — From Site 필수** (SCM0002 팝업 cs:261~266): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (**팝업 Find — From Site 필수** (SCM0002 팝업 c) |
| WK-SCP0028-0276 | A1 | FindButton (cs) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton (cs): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (FindButton (cs)) |
| WK-SCP0028-0277 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0278 | A1 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION — 팝업·보조 SP |  | 1 (txtItemId + btnItemId `SCM0002_ItembyDiv) |
| WK-SCP0028-0279 | A1 | PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 골든 비교 케이스 없음(PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP — 팝업 |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0280 | A1 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE: 골든 비교 케이스 없음(PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE — 팝업·보조 SP 는 gol |  | 41 (P_SCP0028_GET_SHIPMENT_LOT_SIZE ACT:SCP0) |
| WK-SCP0028-0281 | A1 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT: 골든 비교 케이스 없음(PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT — 팝업 |  | 2 (P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT AC) |
| WK-SCP0028-0282 | A1 | PR_GET_MNU_BTN_AUTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PR_GET_MNU_BTN_AUTH: 골든 비교 케이스 없음(PR_GET_MNU_BTN_AUTH — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (두 버튼 **노출** 조건) |
| WK-SCP0028-0283 | A1 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0284 | A1 | SetDivisionAuthCheck (cs:131~132, R1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SetDivisionAuthCheck (cs:131~132, R1): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (SetDivisionAuthCheck (cs:131~132, R1)) |
| WK-SCP0028-0285 | A1 | `SetChangedControl` cascade (cs:158~171) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SetChangedControl` cascade (cs:158~171): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0286 | A1 | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnInput "Input" 일괄입력 팝업 (cs:260~286, R5): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0287 | A1 | cboDivision `Data_SCP.Common(Type.Divisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision `Data_SCP.Common(Type.Division)` + Get: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (cboDivision `Data_SCP.Common(Type.Divisi) |
| WK-SCP0028-0288 | A1 | cboOperationGroup `LookupCommon("OPERATI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboOperationGroup `LookupCommon("OPERATION_GROUP"): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (cboOperationGroup `LookupCommon("OPERATI) |
| WK-SCP0028-0289 | A1 | cboValid `DataBind(Type.YesOrNo,true)` ( | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboValid `DataBind(Type.YesOrNo,true)` (cs:135): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (cboValid `DataBind(Type.YesOrNo,true)` () |
| WK-SCP0028-0290 | A1 | clbFromSite `FromSiteByDivision` (cs:166 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbFromSite `FromSiteByDivision` (cs:166): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (clbFromSite `FromSiteByDivision` (cs:166) |
| WK-SCP0028-0291 | A1 | clbToSite `ToSiteByDivision` (cs:169) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbToSite `ToSiteByDivision` (cs:169): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (clbToSite `ToSiteByDivision` (cs:169)) |
| WK-SCP0028-0292 | A1 | clbTransMode `LookupCommon("TRANSPORT_MO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbTransMode `LookupCommon("TRANSPORT_MODE_CODE")`: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (clbTransMode `LookupCommon("TRANSPORT_MO) |
| WK-SCP0028-0293 | A1 | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0294 | A1 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0295 | A6 | Query(ds) FindData (cs:368) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — Query(ds) FindData (cs:368): 행 집계 — A6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) FindData (cs:368)) |
| WK-SCP0028-0296 | A6 | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — A6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0297 | G1 | **toolbar DeleteButton remove-new (cs:21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — **toolbar DeleteButton remove-new (cs:213~224, R4): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0298 | G1 | FindButton (cs) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton (cs): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (cs)) |
| WK-SCP0028-0299 | G1 | SetDivisionAuthCheck (cs:131~132, R1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SetDivisionAuthCheck (cs:131~132, R1): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SetDivisionAuthCheck (cs:131~132, R1)) |
| WK-SCP0028-0300 | G1 | `SetChangedControl` cascade (cs:158~171) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `SetChangedControl` cascade (cs:158~171): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0301 | G1 | btnInput "Input" 일괄입력 팝업 (cs:260~286, R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnInput "Input" 일괄입력 팝업 (cs:260~286, R5): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (btnInput "Input" 일괄입력 팝업 (cs:260~286, R5) |
| WK-SCP0028-0302 | G1 | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0303 | G1 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0304 | G6 | `SetChangedControl` cascade (cs:158~171) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `SetChangedControl` cascade (cs:158~171): 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`SetChangedControl` cascade (cs:158~171)) |
| WK-SCP0028-0305 | X-LOC | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0306 | X-LOC | P_SCP0028_GET_SHIPMENT_LOT_SIZE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SCP0028_GET_SHIPMENT_LOT_SIZE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SCP0028_GET_SHIPMENT_LOT_SIZE) |
| WK-SCP0028-0307 | X-LOC | P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT) |
| WK-SCP0028-0308 | X-LOC | P_SCP0028_SAVE_SHIPMENT_LOT_SIZE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SCP0028_SAVE_SHIPMENT_LOT_SIZE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SCP0028_SAVE_SHIPMENT_LOT_SIZE) |
| WK-SCP0028-0309 | X-ROW | **`FindInput` 5 CSV 위치조인 (cs:394~429)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — **`FindInput` 5 CSV 위치조인 (cs:394~429)**: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (**`FindInput` 5 CSV 위치조인 (cs:394~429)**) |
| WK-SCP0028-0310 | X-ROW | SCP0028_Shipment_Lot_Size.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.ClbDivision_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.ClbDivisio) |
| WK-SCP0028-0311 | X-ROW | SCP0028_Shipment_Lot_Size.ClearUsrChecke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된  |  | 4 (ACT:SCP0028_Shipment_Lot_Size.ClearUsrCh) |
| WK-SCP0028-0312 | X-ROW | SCP0028_Shipment_Lot_Size.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.CreateSpre) |
| WK-SCP0028-0313 | X-ROW | SCP0028_Shipment_Lot_Size.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0028_Shipment_Lot_Size.FindButton) |
| WK-SCP0028-0314 | X-ROW | SCP0028_Shipment_Lot_Size.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.FindData: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0028_Shipment_Lot_Size.FindData:3) |
| WK-SCP0028-0315 | X-ROW | SCP0028_Shipment_Lot_Size.FindDelete | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.FindDelete: 진입점 집계 8검사 — NOT_RUN:6 · PASS:2 (미실행 검사가 남아 판정필요) |  | 61 (ACT:SCP0028_Shipment_Lot_Size.FindDelete) |
| WK-SCP0028-0316 | X-ROW | SCP0028_Shipment_Lot_Size.FindInput | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.FindInput: 진입점 집계 4검사 — NOT_RUN:2 · PASS:1 · REVIEW:1 |  | 31 (ACT:SCP0028_Shipment_Lot_Size.FindInput ) |
| WK-SCP0028-0317 | X-ROW | SCP0028_Shipment_Lot_Size.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.Form_Load) |
| WK-SCP0028-0318 | X-ROW | SCP0028_Shipment_Lot_Size.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.InitControls: 진입점 집계 15검사 — NOT_RUN:13 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0028_Shipment_Lot_Size.InitContro) |
| WK-SCP0028-0319 | X-ROW | SCP0028_Shipment_Lot_Size.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.InitEvent: 진입점 집계 4검사 — NOPATH:3 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.InitEvent) |
| WK-SCP0028-0320 | X-ROW | SCP0028_Shipment_Lot_Size.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.InitSpread: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.InitSpread) |
| WK-SCP0028-0321 | X-ROW | SCP0028_Shipment_Lot_Size.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0028_Shipment_Lot_Size.InsertButt) |
| WK-SCP0028-0322 | X-ROW | SCP0028_Shipment_Lot_Size.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.SaveData: 진입점 집계 12검사 — NOT_RUN:8 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0028_Shipment_Lot_Size.SaveData:5) |
| WK-SCP0028-0323 | X-ROW | SCP0028_Shipment_Lot_Size.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.SetChangedControl: 진입점 집계 7검사 — NOT_RUN:5 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0028_Shipment_Lot_Size.SetChanged) |
| WK-SCP0028-0324 | X-ROW | SCP0028_Shipment_Lot_Size.SpdMain_TopCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0028_Shipment_Lot_Size.SpdMain_To) |
| WK-SCP0028-0325 | X-ROW | SCP0028_Shipment_Lot_Size.btnDelete_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.btnDelete_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnDelete_) |
| WK-SCP0028-0326 | X-ROW | SCP0028_Shipment_Lot_Size.btnInput_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.btnInput_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnInput_C) |
| WK-SCP0028-0327 | X-ROW | SCP0028_Shipment_Lot_Size.btnItemId_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0028_Shipment_Lot_Size.btnItemId_) |
| WK-SCP0028-0328 | X-ROW | SCP0028_Shipment_Lot_Size.checkValidSize | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.checkValidSize: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0028_Shipment_Lot_Size.checkValid) |
| WK-SCP0028-0329 | X-ROW | SCP0028_Shipment_Lot_Size.spdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0028_Shipment_Lot_Size.spdMain_Change: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0028_Shipment_Lot_Size.spdMain_Ch) |
| WK-SCP0028-0330 | G5 | **toolbar DeleteButton remove-new (cs:21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — **toolbar DeleteButton remove-new (cs:213~224, R4): 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0331 | G5 | **팝업 OK `SaveData` (cs:308~369)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0332 | G5 | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0333 | G5 | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0334 | G5 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0335 | H6 | **toolbar DeleteButton remove-new (cs:21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — **toolbar DeleteButton remove-new (cs:213~224, R4): 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0336 | H6 | **팝업 OK `SaveData` (cs:308~369)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0337 | H6 | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0338 | H6 | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0339 | H6 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
| WK-SCP0028-0340 | M4 | **toolbar DeleteButton remove-new (cs:21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — **toolbar DeleteButton remove-new (cs:213~224, R4): 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (**toolbar DeleteButton remove-new (cs:21) |
| WK-SCP0028-0341 | M4 | **팝업 OK `SaveData` (cs:308~369)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — **팝업 OK `SaveData` (cs:308~369)**: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (**팝업 OK `SaveData` (cs:308~369)**) |
| WK-SCP0028-0342 | M4 | P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP) |
| WK-SCP0028-0343 | M4 | 팝업 Form_Load `//FindData();` (cs:146) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 팝업 Form_Load `//FindData();` (cs:146): 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (팝업 Form_Load `//FindData();` (cs:146)) |
| WK-SCP0028-0344 | M4 | 팝업 검색영역 + Find 버튼 (cs 상단 검색영역) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 팝업 검색영역 + Find 버튼 (cs 상단 검색영역): 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (팝업 검색영역 + Find 버튼 (cs 상단 검색영역)) |
