# 작업 원장 — SSP0024 · 2026-10-26 12:59

> 검사 인스턴스 678건 중 PASS·NA 132건 외 **546건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 36 | 구현 위치 실존 |
| W4 | 검사기 구현 | 5 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 55 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 182 | 실행 → PASS |
| W7 | 기대값 확정 | 268 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 268 · E2E 182 · 하네스 60 · 대조표 36
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 63 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 36 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G1 | GEN |  |  |  |  |  | 7 | 22 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C3 | CASCADE |  |  |  |  |  | 14 | 14 |  |  | 연쇄 자동 채움 |
| D1 | EDIT |  |  |  |  |  | 11 | 16 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 11 | 16 |  |  | 행 값 기반 조건부 잠금 |
| A1 | GEN |  |  |  |  |  |  | 26 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  |  |  |  | 18 | 4 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C2 | CASCADE |  |  |  |  |  | 12 | 6 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 12 | 6 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| B4 | COMBO |  |  |  |  | 9 |  | 8 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G5 | POPUP |  |  |  |  | 11 |  | 6 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 11 |  | 6 |  |  | 팝업 표준·열림 |
| A5 | DESIGN |  |  |  |  |  | 8 | 9 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| M4 | POPUP |  |  |  |  |  | 11 | 6 |  |  | 팝업 선택값 반영 |
| H2 | DESIGN |  |  |  |  |  | 8 | 8 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 8 | 8 |  |  | 라벨 명칭 |
| G4 | DESIGN |  |  |  |  | 2 | 7 | 6 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 7 | 8 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| E1 | EDIT |  |  |  |  |  | 8 | 6 |  |  | 숫자 소수자리·정수·부호·범위 |
| B3 | COMBO |  |  |  | 5 |  |  | 7 |  |  | 콤보 후보 정렬 = AS-IS |
| B1 | COMBO |  |  |  |  | 7 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 7 |  | 1 |  |  | 콤보 후보 중복 없음 |
| D5 | EDIT |  |  |  |  |  | 6 | 2 |  |  | 셀 에디터 유형 |
| E3 | EDIT |  |  |  |  |  | 1 | 7 |  |  | 필수 입력 검증 |
| F4 | DB |  |  |  |  |  | 7 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 6 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C1 | CASCADE |  |  |  |  |  | 4 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D4 | EDIT |  |  |  |  |  | 2 | 3 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| E5 | EDIT |  |  |  |  | 2 |  | 1 |  |  | 콤보 셀 후보 외 값 차단 |
| B6 | COMBO |  |  |  |  | 2 |  |  |  |  | ALL 옵션·다중선택 사양 |
| C4 | CASCADE |  |  |  |  |  | 1 | 1 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M3 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 내부 기능(조회·CRUD) |

## W2 구현 위치 확인 (36)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0001 | X-LOC | **BuildingForShipMasterElec** (셀, cs:52) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (**BuildingForShipMasterElec** (셀, cs:52)) |
| WK-SSP0024-0002 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-SSP0024-0003 | X-LOC | 10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (10) |
| WK-SSP0024-0004 | X-LOC | 11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (11) |
| WK-SSP0024-0005 | X-LOC | 12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (12) |
| WK-SSP0024-0006 | X-LOC | 13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (13) |
| WK-SSP0024-0007 | X-LOC | 14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (14) |
| WK-SSP0024-0008 | X-LOC | 15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (15) |
| WK-SSP0024-0009 | X-LOC | 2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2) |
| WK-SSP0024-0010 | X-LOC | 3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3) |
| WK-SSP0024-0011 | X-LOC | 4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (4) |
| WK-SSP0024-0012 | X-LOC | 5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (5) |
| WK-SSP0024-0013 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-SSP0024-0014 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-SSP0024-0015 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-SSP0024-0016 | X-LOC | 9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9) |
| WK-SSP0024-0017 | X-LOC | BtnMaterialId_Click (cs:730) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0018 | X-LOC | BtnModelId_Click (cs:750) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0019 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: sub-title/SubTitle.tsx 없음 |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0020 | X-LOC | ClbDivision_SelectedIndexChanged (cs:771 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ClbDivision_SelectedIndexChanged (cs:771) |
| WK-SSP0024-0021 | X-LOC | D00-3-047 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: packages/shared/.../DataGrid.tsx 없음 |  | 1 (D00-3-047) |
| WK-SSP0024-0022 | X-LOC | D00-3-051 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: packages/shared/.../DataGrid.tsx 없음 |  | 1 (D00-3-051) |
| WK-SSP0024-0023 | X-LOC | DeleteButton (cs:262) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DeleteButton (cs:262)) |
| WK-SSP0024-0024 | X-LOC | DomExpTypeCode (셀, cs:51) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DomExpTypeCode (셀, cs:51)) |
| WK-SSP0024-0025 | X-LOC | ElectrodePackageType (셀, cs:55) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ElectrodePackageType (셀, cs:55)) |
| WK-SSP0024-0026 | X-LOC | ElectrodePostOperCode (셀, cs:49) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ElectrodePostOperCode (셀, cs:49)) |
| WK-SSP0024-0027 | X-LOC | FindButton (cs:230) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton (cs:230)) |
| WK-SSP0024-0028 | X-LOC | InsertButton (cs:235) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InsertButton (cs:235)) |
| WK-SSP0024-0029 | X-LOC | MyDivision (cs:37) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MyDivision (cs:37)) |
| WK-SSP0024-0030 | X-LOC | PlantSiteByFactoryEEOperation "40,81,82, | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (PlantSiteByFactoryEEOperation "40,81,82,) |
| WK-SSP0024-0031 | X-LOC | PlantSiteByFactoryEEOperation (cs:191) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (PlantSiteByFactoryEEOperation (cs:191)) |
| WK-SSP0024-0032 | X-LOC | SaveButton (cs:280) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton (cs:280)) |
| WK-SSP0024-0033 | X-LOC | SpdMain_CellClick (cs:530) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SpdMain_CellClick (cs:530)) |
| WK-SSP0024-0034 | X-LOC | SpdMain_ClipboardPasted (cs:659) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SpdMain_ClipboardPasted (cs:659)) |
| WK-SSP0024-0035 | X-LOC | SpdMain_ComboSelChange (cs:596) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SpdMain_ComboSelChange (cs:596)) |
| WK-SSP0024-0036 | X-LOC | SpdMain_KeyPress (cs:646) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SpdMain_KeyPress (cs:646)) |

## W4 검사기 구현 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0037 | B3 | D | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 D | 판단불가(대상 단위 PCOL) | 1 (D00-4b-002) |
| WK-SSP0024-0038 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (D00-4b-002 D00-4b-003) |
| WK-SSP0024-0039 | B3 | N | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 N | 판단불가(대상 단위 PCOL) | 2 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0040 | B3 | POST_OPER | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 POST_OPER | 있음(SHEET_COLUMNS) | 1 (D00-3-031) |
| WK-SSP0024-0041 | B3 | POST_OPER_LT | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 POST_OPER_LT | 있음(SHEET_COLUMNS) | 1 (D00-3-031) |

## W5 검사기 연결 (55)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0042 | B1 | BUILDING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL BUILDING | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0043 | B1 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 PCOL D | 판단불가(대상 단위 PCOL) | 1 (D00-3-052) |
| WK-SSP0024-0044 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0045 | B1 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 3 (D00-3-050 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0046 | B1 | POST_OPER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL POST_OPER | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0047 | B1 | cboDivision / Div / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Div / Division | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SSP0024-0048 | B1 | cboPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SSP0024-0049 | B2 | BUILDING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL BUILDING | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0050 | B2 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 PCOL D | 판단불가(대상 단위 PCOL) | 1 (D00-3-052) |
| WK-SSP0024-0051 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0052 | B2 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 3 (D00-3-050 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0053 | B2 | POST_OPER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL POST_OPER | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0054 | B2 | cboDivision / Div / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Div / Division | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SSP0024-0055 | B2 | cboPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SSP0024-0056 | B4 | BUILDING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL BUILDING | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0057 | B4 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL D | 판단불가(대상 단위 PCOL) | 2 (D00-3-052 D00-4b-002) |
| WK-SSP0024-0058 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (D00-4b-002 D00-4b-003 ACT:SSP0024_Shipme) |
| WK-SSP0024-0059 | B4 | N | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL N | 판단불가(대상 단위 PCOL) | 2 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0060 | B4 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 3 (D00-3-050 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0061 | B4 | POST_OPER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL POST_OPER | 있음(SHEET_COLUMNS) | 2 (D00-3-031 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0062 | B4 | POST_OPER_LT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL POST_OPER_LT | 있음(SHEET_COLUMNS) | 1 (D00-3-031) |
| WK-SSP0024-0063 | B4 | cboDivision / Div / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Div / Division | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SSP0024-0064 | B4 | cboPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SSP0024-0065 | B6 | cboDivision / Div / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Div / Division | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SSP0024-0066 | B6 | cboPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SSP0024-0067 | F2 | SSP0024 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0024 화면 | 판단불가(대상 단위 SCREEN) | 90 (D00-4a-002 D00-4e-002 D00-4e-003 D00-4e-) |
| WK-SSP0024-0068 | F6 | SSP0024 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0024 화면 | 판단불가(대상 단위 SCREEN) | 86 (D00-4a-002 ACT:SSP0024_ShipmentMasterEle) |
| WK-SSP0024-0069 | DB-SYN | PKG_SSP0024 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SSP0024 | 없음(PROC_M 대응 없음) | 1 (D00-4a-001) |
| WK-SSP0024-0070 | G4 | btnMaterialId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMaterialId | 있음(FE 소스) | 3 (D00-2-002 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0071 | G4 | btnModelId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnModelId | 있음(FE 소스) | 3 (D00-2-003 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0072 | E5 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 PCOL D | 판단불가(대상 단위 PCOL) | 1 (D00-3-052) |
| WK-SSP0024-0073 | E5 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-050) |
| WK-SSP0024-0074 | G03-WIRE | SSP0024 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0024 화면 | 판단불가(대상 단위 SCREEN) | 14 (ACT:SSP0024_ItembyDivisionPopup..ctor AC) |
| WK-SSP0024-0075 | G5 | CELL_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL CELL_TYPE | 있음(SHEET_COLUMNS) | 1 (D00-3-025) |
| WK-SSP0024-0076 | G5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-020) |
| WK-SSP0024-0077 | G5 | ELECTRODE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ELECTRODE_TYPE | 있음(SHEET_COLUMNS) | 1 (D00-3-027) |
| WK-SSP0024-0078 | G5 | ITEM_UOM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_UOM | 있음(SHEET_COLUMNS) | 1 (D00-3-028) |
| WK-SSP0024-0079 | G5 | MATERIAL_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL MATERIAL_ID | 있음(SHEET_COLUMNS) | 4 (D00-3-023 D00-4d-013 SpdMain_CellClick () |
| WK-SSP0024-0080 | G5 | MODEL_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL MODEL_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-024) |
| WK-SSP0024-0081 | G5 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (D00-3-026) |
| WK-SSP0024-0082 | G5 | PLANT_SITE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PLANT_SITE_CODE | 있음(SHEET_COLUMNS) | 2 (D00-3-021 D00-3-022) |
| WK-SSP0024-0083 | G5 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-022) |
| WK-SSP0024-0084 | G5 | SSP0024_ItembyDivisionPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SSP0024_ItembyDivisionPopup | 판단불가(대상 단위 POPUP) | 8 (D00-4f-002 D00-4f-003 D00-4f-004 MODAL:S) |
| WK-SSP0024-0085 | G5 | UOM_CONVERT_IN_TACT_TIME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL UOM_CONVERT_IN_TACT_TIME | 있음(SHEET_COLUMNS) | 1 (D00-3-029) |
| WK-SSP0024-0086 | H6 | CELL_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CELL_TYPE | 있음(SHEET_COLUMNS) | 1 (D00-3-025) |
| WK-SSP0024-0087 | H6 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-020) |
| WK-SSP0024-0088 | H6 | ELECTRODE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ELECTRODE_TYPE | 있음(SHEET_COLUMNS) | 1 (D00-3-027) |
| WK-SSP0024-0089 | H6 | ITEM_UOM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_UOM | 있음(SHEET_COLUMNS) | 1 (D00-3-028) |
| WK-SSP0024-0090 | H6 | MATERIAL_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MATERIAL_ID | 있음(SHEET_COLUMNS) | 4 (D00-3-023 D00-4d-013 SpdMain_CellClick () |
| WK-SSP0024-0091 | H6 | MODEL_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MODEL_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-024) |
| WK-SSP0024-0092 | H6 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (D00-3-026) |
| WK-SSP0024-0093 | H6 | PLANT_SITE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PLANT_SITE_CODE | 있음(SHEET_COLUMNS) | 2 (D00-3-021 D00-3-022) |
| WK-SSP0024-0094 | H6 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-022) |
| WK-SSP0024-0095 | H6 | SSP0024_ItembyDivisionPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SSP0024_ItembyDivisionPopup | 판단불가(대상 단위 POPUP) | 8 (D00-4f-002 D00-4f-003 D00-4f-004 MODAL:S) |
| WK-SSP0024-0096 | H6 | UOM_CONVERT_IN_TACT_TIME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL UOM_CONVERT_IN_TACT_TIME | 있음(SHEET_COLUMNS) | 1 (D00-3-029) |

## W6 검증 실행 (182)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0097 | J2 | SSP0024 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0024 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 85 (D00-1-017 D00-1-018 D00-1-020 D00-2-001 ) |
| WK-SSP0024-0098 | C1 | cboDivision / Div / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Div / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-001 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0099 | C1 | cboPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0100 | C1 | clbDivisionId / Division / Division Id | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivisionId / Division / Division Id · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0101 | C1 | clbPlantSiteId / Plant Site / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSiteId / Plant Site / Plant Site Id · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0102 | C2 | BUILDING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — BUILDING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0103 | C2 | BUILDING_DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — BUILDING_DESC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0104 | C2 | CELL_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CELL_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0105 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0106 | C2 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0107 | C2 | MATERIAL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MATERIAL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0108 | C2 | MODEL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MODEL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0109 | C2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0110 | C2 | PLANT_SITE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_SITE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0111 | C2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0112 | C2 | POST_OPER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — POST_OPER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0113 | C2 | POST_OPER_LT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — POST_OPER_LT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0114 | C3 | BUILDING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BUILDING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 13 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0115 | C3 | BUILDING_DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BUILDING_DESC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0116 | C3 | CELL_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CELL_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (D00-3-044 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0117 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 33 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0118 | C3 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (D00-3-046 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0119 | C3 | ITEM_UOM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_UOM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0120 | C3 | MATERIAL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MATERIAL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (D00-3-042 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0121 | C3 | MODEL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MODEL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (D00-3-043 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0122 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (D00-3-045 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0123 | C3 | PLANT_SITE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (D00-3-040 D00-3-049 ACT:SSP0024_Shipment) |
| WK-SSP0024-0124 | C3 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 18 (D00-3-041 D00-3-049 ACT:SSP0024_Shipment) |
| WK-SSP0024-0125 | C3 | POST_OPER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — POST_OPER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0126 | C3 | POST_OPER_LT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — POST_OPER_LT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0127 | C3 | UOM_CONVERT_IN_TACT_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — UOM_CONVERT_IN_TACT_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0128 | C4 | cboDivision / Div / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Div / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-001) |
| WK-SSP0024-0129 | C6 | BUILDING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — BUILDING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0130 | C6 | BUILDING_DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — BUILDING_DESC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (D00-3-030 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0131 | C6 | CELL_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CELL_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0132 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0133 | C6 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0134 | C6 | MATERIAL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — MATERIAL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0135 | C6 | MODEL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — MODEL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0136 | C6 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0137 | C6 | PLANT_SITE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_SITE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0138 | C6 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0139 | C6 | POST_OPER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — POST_OPER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0140 | C6 | POST_OPER_LT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — POST_OPER_LT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0141 | G3 | SSP0024 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0024 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 10 (D00-1-010 D00-1-012 D00-1-014 COMMON:UC-) |
| WK-SSP0024-0142 | K-SA | SSP0024 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0024 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 4 (D00-1-010 D00-1-012 D00-1-014 COMMON:UC-) |
| WK-SSP0024-0143 | K4 | SSP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0024 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 39 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SSP0024-0144 | F1 | SSP0024 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0024 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 106 (D00-3-006 D00-4a-002 D00-4d-002 D00-4d-0) |
| WK-SSP0024-0145 | F3 | SSP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SSP0024 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 46 (D00-2-007 D00-3-040 D00-3-041 D00-3-042 ) |
| WK-SSP0024-0146 | F5 | SSP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0024 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 16 (D00-3-006 D00-4d-002 D00-4d-004 DeleteBu) |
| WK-SSP0024-0147 | F4 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 4 (D00-4a-003 ACT:SSP0024_ShipmentMasterEle) |
| WK-SSP0024-0148 | F4 | PKG_SSP0020.P_USER_CHECK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0020.P_USER_CHECK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4a-003) |
| WK-SSP0024-0149 | F4 | PKG_SSP0024 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0024 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4a-001) |
| WK-SSP0024-0150 | F4 | PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 30 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0151 | F4 | PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 120 (D00-4a-001 FindButton (cs:230) ACT:SSP00) |
| WK-SSP0024-0152 | F4 | PKG_SSP0024.P_SSP0024_SAVE_SHIP_MASTER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0024.P_SSP0024_SAVE_SHIP_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 86 (D00-4a-002 ACT:SSP0024_ShipmentMasterEle) |
| WK-SSP0024-0153 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SSP0024_ItembyDivisionPopup.GetDivis) |
| WK-SSP0024-0154 | A5 | BUILDING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — BUILDING · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (**BuildingForShipMasterElec** (셀, cs:52)) |
| WK-SSP0024-0155 | A5 | D | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — D · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (PlantSiteByFactoryEEOperation "40,81,82,) |
| WK-SSP0024-0156 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (D00-3-047 PlantSiteByFactoryEEOperation ) |
| WK-SSP0024-0157 | A5 | DOM_EXP_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DOM_EXP_TYPE_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (DomExpTypeCode (셀, cs:51)) |
| WK-SSP0024-0158 | A5 | ITEM_UOM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_UOM · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0159 | A5 | PACKAGE_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PACKAGE_TYPE_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ElectrodePackageType (셀, cs:55)) |
| WK-SSP0024-0160 | A5 | PLANT_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (D00-3-047 D00-3-050 D00-3-051 PlantSiteB) |
| WK-SSP0024-0161 | A5 | POST_OPER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — POST_OPER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ElectrodePostOperCode (셀, cs:49)) |
| WK-SSP0024-0162 | G4 | cboDivision / Div / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Div / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (D00-1-013 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0163 | G4 | cboPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-015) |
| WK-SSP0024-0164 | G4 | clbDivisionId / Division / Division Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivisionId / Division / Division Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0165 | G4 | clbPlantSiteId / Plant Site / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSiteId / Plant Site / Plant Site Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0166 | G4 | txtMaterialId / Material / Material Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtMaterialId / Material / Material Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-016 ACT:SSP0024_ItembyDivisionPopu) |
| WK-SSP0024-0167 | G4 | txtModelId / Model / Model Id / Model/Ni | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtModelId / Model / Model Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-019) |
| WK-SSP0024-0168 | G4 | txtNickName / Nick Name / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-018) |
| WK-SSP0024-0169 | H2 | BUILDING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — BUILDING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (**BuildingForShipMasterElec** (셀, cs:52)) |
| WK-SSP0024-0170 | H2 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (PlantSiteByFactoryEEOperation "40,81,82,) |
| WK-SSP0024-0171 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (D00-3-047 PlantSiteByFactoryEEOperation ) |
| WK-SSP0024-0172 | H2 | DOM_EXP_TYPE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DOM_EXP_TYPE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (DomExpTypeCode (셀, cs:51)) |
| WK-SSP0024-0173 | H2 | ITEM_UOM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_UOM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0174 | H2 | PACKAGE_TYPE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PACKAGE_TYPE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ElectrodePackageType (셀, cs:55)) |
| WK-SSP0024-0175 | H2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (D00-3-047 D00-3-050 D00-3-051 PlantSiteB) |
| WK-SSP0024-0176 | H2 | POST_OPER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — POST_OPER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ElectrodePostOperCode (셀, cs:49)) |
| WK-SSP0024-0177 | H5 | BUILDING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — BUILDING · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (**BuildingForShipMasterElec** (셀, cs:52)) |
| WK-SSP0024-0178 | H5 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — D · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (PlantSiteByFactoryEEOperation "40,81,82,) |
| WK-SSP0024-0179 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (D00-3-047 PlantSiteByFactoryEEOperation ) |
| WK-SSP0024-0180 | H5 | DOM_EXP_TYPE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DOM_EXP_TYPE_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (DomExpTypeCode (셀, cs:51)) |
| WK-SSP0024-0181 | H5 | ITEM_UOM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_UOM · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0182 | H5 | PACKAGE_TYPE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PACKAGE_TYPE_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ElectrodePackageType (셀, cs:55)) |
| WK-SSP0024-0183 | H5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_SITE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (D00-3-047 D00-3-050 D00-3-051 PlantSiteB) |
| WK-SSP0024-0184 | H5 | POST_OPER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — POST_OPER · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ElectrodePostOperCode (셀, cs:49)) |
| WK-SSP0024-0185 | I1 | SSP0024 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0024 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 18 (D00-4d-007 D00-4d-010 D00-4e-001 D00-4e-) |
| WK-SSP0024-0186 | SC1 | SSP0024 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0024 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 13 (D00-1-012 D00-1-013 D00-1-014 D00-1-015 ) |
| WK-SSP0024-0187 | D1 | BUILDING_DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — BUILDING_DESC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (D00-3-004 D00-3-018 ACT:SSP0024_Shipment) |
| WK-SSP0024-0188 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (D00-3-005 D00-3-019 ACT:SSP0024_Shipment) |
| WK-SSP0024-0189 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (D00-3-002 D00-4d-007 D00-4e-005 ACT:SSP0) |
| WK-SSP0024-0190 | D1 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — I · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (InsertButton (cs:235)) |
| WK-SSP0024-0191 | D1 | ITEM_UOM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_UOM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-3-002 D00-3-016 ACT:SSP0024_Shipment) |
| WK-SSP0024-0192 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-3-005 D00-3-019 ACT:SSP0024_Shipment) |
| WK-SSP0024-0193 | D1 | MATERIAL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MATERIAL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-2-006 SpdMain_KeyPress (cs:646) 13) |
| WK-SSP0024-0194 | D1 | MODEL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MODEL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-016 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0195 | D1 | PLANT_SITE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_SITE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-015 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0196 | D1 | POST_OPER_LT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — POST_OPER_LT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (D00-3-003 D00-3-017 ACT:SSP0024_Shipment) |
| WK-SSP0024-0197 | D1 | UOM_CONVERT_IN_TACT_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — UOM_CONVERT_IN_TACT_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-3-003 D00-3-017 ACT:SSP0024_Shipment) |
| WK-SSP0024-0198 | D3 | BUILDING_DESC | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — BUILDING_DESC · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (D00-3-004 D00-3-018 ACT:SSP0024_Shipment) |
| WK-SSP0024-0199 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (D00-3-005 D00-3-019 ACT:SSP0024_Shipment) |
| WK-SSP0024-0200 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (D00-3-002 D00-4d-007 D00-4e-005 ACT:SSP0) |
| WK-SSP0024-0201 | D3 | I | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — I · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (InsertButton (cs:235)) |
| WK-SSP0024-0202 | D3 | ITEM_UOM | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_UOM · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-3-002 D00-3-016 ACT:SSP0024_Shipment) |
| WK-SSP0024-0203 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-3-005 D00-3-019 ACT:SSP0024_Shipment) |
| WK-SSP0024-0204 | D3 | MATERIAL_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MATERIAL_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-2-006 SpdMain_KeyPress (cs:646) 13) |
| WK-SSP0024-0205 | D3 | MODEL_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MODEL_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-016 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0206 | D3 | PLANT_SITE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_SITE_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-015 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0207 | D3 | POST_OPER_LT | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — POST_OPER_LT · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (D00-3-003 D00-3-017 ACT:SSP0024_Shipment) |
| WK-SSP0024-0208 | D3 | UOM_CONVERT_IN_TACT_TIME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — UOM_CONVERT_IN_TACT_TIME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-3-003 D00-3-017 ACT:SSP0024_Shipment) |
| WK-SSP0024-0209 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-014) |
| WK-SSP0024-0210 | D4 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — I · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (InsertButton (cs:235)) |
| WK-SSP0024-0211 | D5 | BUILDING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — BUILDING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0212 | D5 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (D00-3-052) |
| WK-SSP0024-0213 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0214 | D5 | ITEM_UOM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ITEM_UOM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0215 | D5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (D00-3-050 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0216 | D5 | POST_OPER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — POST_OPER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0217 | D6 | SSP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0024 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 6 (D00-3-009 COMMON:UC-01 COMMON:UC-03 Inse) |
| WK-SSP0024-0218 | E1 | CELL_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — CELL_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (D00-3-044 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0219 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 22 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0220 | E1 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (D00-3-046 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0221 | E1 | MATERIAL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — MATERIAL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (D00-3-042 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0222 | E1 | MODEL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — MODEL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (D00-3-043 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0223 | E1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (D00-3-045 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0224 | E1 | PLANT_SITE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — PLANT_SITE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 8 (D00-3-040 D00-3-049 ACT:SSP0024_Shipment) |
| WK-SSP0024-0225 | E1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 13 (D00-3-041 D00-3-049 ACT:SSP0024_Shipment) |
| WK-SSP0024-0226 | E3 | N | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E3 실행 — N · 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요 |  | 0 () |
| WK-SSP0024-0227 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 9 (D00-4d-007 D00-4e-005 ACT:SSP0024_Shipme) |
| WK-SSP0024-0228 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4e-004) |
| WK-SSP0024-0229 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4e-002 ACT:SSP0024_ShipmentMasterEle) |
| WK-SSP0024-0230 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4e-004 ACT:SSP0024_ShipmentMasterEle) |
| WK-SSP0024-0231 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4e-007 ACT:SSP0024_ShipmentMasterEle) |
| WK-SSP0024-0232 | E4 | MSG00093 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00093 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (D00-4e-005 D00-4e-006 ACT:SSP0024_Shipme) |
| WK-SSP0024-0233 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4d-007 D00-4e-005 7) |
| WK-SSP0024-0234 | E4 | MSG00251 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00251 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4e-001 ACT:SSP0024_ShipmentMasterEle) |
| WK-SSP0024-0235 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4d-010 D00-4e-006 10) |
| WK-SSP0024-0236 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4e-002) |
| WK-SSP0024-0237 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0238 | E4 | MSG01261 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01261 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4e-001) |
| WK-SSP0024-0239 | E4 | N | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — N · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4e-004) |
| WK-SSP0024-0240 | E4 | PLANT_SITE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_SITE_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4d-010) |
| WK-SSP0024-0241 | E4 | cboDivision / Div / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Div / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정)  |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0242 | E4 | cboPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0243 | E4 | txtMaterialId / Material / Material Id | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtMaterialId / Material / Material Id · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지· |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0244 | E4 | txtModelId / Model / Model Id / Model/Ni | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtModelId / Model / Model Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단 |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0245 | A10 | SSP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0024 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 88 (ACT:SSP0024_ItembyDivisionPopup.DefinePr) |
| WK-SSP0024-0246 | A6 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (D00-4a-003) |
| WK-SSP0024-0247 | A6 | PKG_SSP0020.P_USER_CHECK | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0020.P_USER_CHECK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 1 (D00-4a-003) |
| WK-SSP0024-0248 | A6 | PKG_SSP0024 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0024 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (D00-4a-001) |
| WK-SSP0024-0249 | A6 | PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 30 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0250 | A6 | PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 37 (D00-4a-001 FindButton (cs:230) ACT:SSP00) |
| WK-SSP0024-0251 | A6 | PKG_SSP0024.P_SSP0024_SAVE_SHIP_MASTER | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0024.P_SSP0024_SAVE_SHIP_MASTER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 1 (D00-4a-002) |
| WK-SSP0024-0252 | G1 | cboDivision / Div / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Div / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-013 D00-2-001 ACT:SSP0024_Shipment) |
| WK-SSP0024-0253 | G1 | cboPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-015 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0254 | G1 | clbDivisionId / Division / Division Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisionId / Division / Division Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0024_ItembyDivisionPopup.FindData) |
| WK-SSP0024-0255 | G1 | clbPlantSiteId / Plant Site / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSiteId / Plant Site / Plant Site Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0024_ItembyDivisionPopup.FindData) |
| WK-SSP0024-0256 | G1 | txtMaterialId / Material / Material Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtMaterialId / Material / Material Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (D00-1-016 ACT:SSP0024_ItembyDivisionPopu) |
| WK-SSP0024-0257 | G1 | txtModelId / Model / Model Id / Model/Ni | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtModelId / Model / Model Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-019 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0258 | G1 | txtNickName / Nick Name / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-018 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0259 | G6 | cboDivision / Div / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Div / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (D00-1-013 ACT:SSP0024_ShipmentMasterElec) |
| WK-SSP0024-0260 | G6 | cboPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-015) |
| WK-SSP0024-0261 | G6 | clbDivisionId / Division / Division Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivisionId / Division / Division Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0262 | G6 | clbPlantSiteId / Plant Site / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSiteId / Plant Site / Plant Site Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0263 | G6 | txtMaterialId / Material / Material Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtMaterialId / Material / Material Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-016 ACT:SSP0024_ItembyDivisionPopu) |
| WK-SSP0024-0264 | G6 | txtModelId / Model / Model Id / Model/Ni | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtModelId / Model / Model Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-019) |
| WK-SSP0024-0265 | G6 | txtNickName / Nick Name / Model/Nickname | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-018) |
| WK-SSP0024-0266 | X-REOPEN | SSP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0024 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 13 (ACT:SSP0024_ItembyDivisionPopup.Dispose ) |
| WK-SSP0024-0267 | M3 | SSP0024_ItembyDivisionPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SSP0024_ItembyDivisionPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 19 (D00-4f-002 D00-4f-003 D00-4f-004 MODAL:S) |
| WK-SSP0024-0268 | M4 | CELL_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CELL_TYPE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-3-025) |
| WK-SSP0024-0269 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-3-020) |
| WK-SSP0024-0270 | M4 | ELECTRODE_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ELECTRODE_TYPE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-3-027) |
| WK-SSP0024-0271 | M4 | ITEM_UOM | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_UOM · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-3-028) |
| WK-SSP0024-0272 | M4 | MATERIAL_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MATERIAL_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (D00-3-023 D00-4d-013 SpdMain_CellClick () |
| WK-SSP0024-0273 | M4 | MODEL_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MODEL_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-3-024) |
| WK-SSP0024-0274 | M4 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-3-026) |
| WK-SSP0024-0275 | M4 | PLANT_SITE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PLANT_SITE_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-3-021 D00-3-022) |
| WK-SSP0024-0276 | M4 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-3-022) |
| WK-SSP0024-0277 | M4 | SSP0024_ItembyDivisionPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SSP0024_ItembyDivisionPopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (D00-4f-002 D00-4f-003 D00-4f-004 MODAL:S) |
| WK-SSP0024-0278 | M4 | UOM_CONVERT_IN_TACT_TIME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — UOM_CONVERT_IN_TACT_TIME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-3-029) |

## W7 기대값 확정 (268)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0024-0279 | C1 | ClbDivision_SelectedIndexChanged (cs:771 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — ClbDivision_SelectedIndexChanged (cs:771): 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ClbDivision_SelectedIndexChanged (cs:771) |
| WK-SSP0024-0280 | C2 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 11: 행 집계 — C2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SSP0024-0281 | C2 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-005: 행 집계 — C2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-005) |
| WK-SSP0024-0282 | C2 | D00-4d-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-011: 행 집계 — C2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-011) |
| WK-SSP0024-0283 | C2 | SSP0024_ShipmentMasterElectrode.ClbDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0024_ShipmentMasterElectrode.ClbDivision_Select: 진입점 집계 — C2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.ClbD) |
| WK-SSP0024-0284 | C2 | SSP0024_ShipmentMasterElectrode.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0024_ShipmentMasterElectrode.SpdMain_ComboSelCh: 진입점 집계 — C2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0285 | C2 | SpdMain_ComboSelChange (cs:596) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SpdMain_ComboSelChange (cs:596): 행 집계 — C2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_ComboSelChange (cs:596)) |
| WK-SSP0024-0286 | C3 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 11: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SSP0024-0287 | C3 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 14: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (14) |
| WK-SSP0024-0288 | C3 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 15: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (15) |
| WK-SSP0024-0289 | C3 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-005: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-005) |
| WK-SSP0024-0290 | C3 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-007: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-007) |
| WK-SSP0024-0291 | C3 | D00-4d-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-011: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-011) |
| WK-SSP0024-0292 | C3 | D00-4d-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-014: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-014) |
| WK-SSP0024-0293 | C3 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-015: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SSP0024-0294 | C3 | SSP0024_ShipmentMasterElectrode.ClbDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0024_ShipmentMasterElectrode.ClbDivision_Select: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.ClbD) |
| WK-SSP0024-0295 | C3 | SSP0024_ShipmentMasterElectrode.SetCellC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0024_ShipmentMasterElectrode.SetCellCombo: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0296 | C3 | SSP0024_ShipmentMasterElectrode.SetChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0024_ShipmentMasterElectrode.SetChangedControl: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0297 | C3 | SSP0024_ShipmentMasterElectrode.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0024_ShipmentMasterElectrode.SpdMain_ComboSelCh: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0298 | C3 | SpdMain_ClipboardPasted (cs:659) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SpdMain_ClipboardPasted (cs:659): 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_ClipboardPasted (cs:659)) |
| WK-SSP0024-0299 | C3 | SpdMain_ComboSelChange (cs:596) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SpdMain_ComboSelChange (cs:596): 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_ComboSelChange (cs:596)) |
| WK-SSP0024-0300 | C4 | ClbDivision_SelectedIndexChanged (cs:771 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — ClbDivision_SelectedIndexChanged (cs:771): 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ClbDivision_SelectedIndexChanged (cs:771) |
| WK-SSP0024-0301 | C6 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 11: 행 집계 — C6 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SSP0024-0302 | C6 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-005: 행 집계 — C6 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-005) |
| WK-SSP0024-0303 | C6 | D00-4d-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-011: 행 집계 — C6 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-011) |
| WK-SSP0024-0304 | C6 | SSP0024_ShipmentMasterElectrode.ClbDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0024_ShipmentMasterElectrode.ClbDivision_Select: 진입점 집계 — C6 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.ClbD) |
| WK-SSP0024-0305 | C6 | SSP0024_ShipmentMasterElectrode.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0024_ShipmentMasterElectrode.SpdMain_ComboSelCh: 진입점 집계 — C6 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0306 | C6 | SpdMain_ComboSelChange (cs:596) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SpdMain_ComboSelChange (cs:596): 행 집계 — C6 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_ComboSelChange (cs:596)) |
| WK-SSP0024-0307 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0024-0308 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0024-0309 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SSP0024-0310 | B3 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-004: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SSP0024-0311 | B3 | D00-4b-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-005: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-005) |
| WK-SSP0024-0312 | B3 | D00-4b-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-006: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-006) |
| WK-SSP0024-0313 | B3 | D00-4b-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-007: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-007) |
| WK-SSP0024-0314 | B3 | SSP0024_ShipmentMasterElectrode.GetSSPUs | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0024_ShipmentMasterElectrode.GetSSPUserCheck: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0315 | B3 | SSP0024_ShipmentMasterElectrode.GetSelec | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0024_ShipmentMasterElectrode.GetSelectedListNam: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0316 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0024-0317 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SSP0024-0318 | B4 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-004: 행 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SSP0024-0319 | B4 | D00-4b-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-005: 행 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-005) |
| WK-SSP0024-0320 | B4 | D00-4b-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-006: 행 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-006) |
| WK-SSP0024-0321 | B4 | D00-4b-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-007: 행 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-007) |
| WK-SSP0024-0322 | B4 | SSP0024_ShipmentMasterElectrode.GetSSPUs | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0024_ShipmentMasterElectrode.GetSSPUserCheck: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0323 | B4 | SSP0024_ShipmentMasterElectrode.GetSelec | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0024_ShipmentMasterElectrode.GetSelectedListNam: 진입점 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0324 | A5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 3: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SSP0024-0325 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0326 | A5 | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-014: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-014) |
| WK-SSP0024-0327 | A5 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-021: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-021) |
| WK-SSP0024-0328 | A5 | D00-1-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-022: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-022) |
| WK-SSP0024-0329 | A5 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-004: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-004) |
| WK-SSP0024-0330 | A5 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-007: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-007) |
| WK-SSP0024-0331 | A5 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4b-001: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SSP0024-0332 | A5 | SSP0024_ShipmentMasterElectrode.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0024_ShipmentMasterElectrode.CreateSpread: 진입점 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0333 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0024-0334 | G4 | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-012: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-012) |
| WK-SSP0024-0335 | G4 | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-014: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-014) |
| WK-SSP0024-0336 | G4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-4b-001: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SSP0024-0337 | G4 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-4f-003: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-003) |
| WK-SSP0024-0338 | G4 | D00-4f-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-4f-004: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-004) |
| WK-SSP0024-0339 | H2 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SSP0024-0340 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0341 | H2 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-021: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-021) |
| WK-SSP0024-0342 | H2 | D00-1-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-022: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-022) |
| WK-SSP0024-0343 | H2 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-004: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-004) |
| WK-SSP0024-0344 | H2 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-007: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-007) |
| WK-SSP0024-0345 | H2 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4b-001: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SSP0024-0346 | H2 | SSP0024_ShipmentMasterElectrode.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0024_ShipmentMasterElectrode.CreateSpread: 진입점 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0347 | H5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 3: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SSP0024-0348 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0349 | H5 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-021: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-021) |
| WK-SSP0024-0350 | H5 | D00-1-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-022: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-022) |
| WK-SSP0024-0351 | H5 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-2-004: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-004) |
| WK-SSP0024-0352 | H5 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-007: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-007) |
| WK-SSP0024-0353 | H5 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4b-001: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SSP0024-0354 | H5 | SSP0024_ShipmentMasterElectrode.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0024_ShipmentMasterElectrode.CreateSpread: 진입점 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0355 | D1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 1: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0024-0356 | D1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 12: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SSP0024-0357 | D1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 15: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (15) |
| WK-SSP0024-0358 | D1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 5: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0359 | D1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 6: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SSP0024-0360 | D1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 7: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SSP0024-0361 | D1 | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-1-018: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-018) |
| WK-SSP0024-0362 | D1 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-001: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SSP0024-0363 | D1 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-008: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-008) |
| WK-SSP0024-0364 | D1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-001: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SSP0024-0365 | D1 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-006: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SSP0024-0366 | D1 | D00-4d-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-012: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-012) |
| WK-SSP0024-0367 | D1 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4e-001: 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SSP0024-0368 | D1 | EditButton (cs:240) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton (cs:240): 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (EditButton (cs:240)) |
| WK-SSP0024-0369 | D1 | SSP0024_ShipmentMasterElectrode.EditButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSP0024_ShipmentMasterElectrode.EditButton: 진입점 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0024_ShipmentMasterElectrode.Edit) |
| WK-SSP0024-0370 | D1 | SaveButton (cs:280) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SaveButton (cs:280): 행 집계 — D1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton (cs:280)) |
| WK-SSP0024-0371 | D3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 1: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0024-0372 | D3 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 12: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SSP0024-0373 | D3 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 15: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (15) |
| WK-SSP0024-0374 | D3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 5: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0375 | D3 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 6: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SSP0024-0376 | D3 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 7: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SSP0024-0377 | D3 | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-1-018: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-018) |
| WK-SSP0024-0378 | D3 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-001: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SSP0024-0379 | D3 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-008: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-008) |
| WK-SSP0024-0380 | D3 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-001: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SSP0024-0381 | D3 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-006: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SSP0024-0382 | D3 | D00-4d-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-012: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-012) |
| WK-SSP0024-0383 | D3 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4e-001: 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SSP0024-0384 | D3 | EditButton (cs:240) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton (cs:240): 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (EditButton (cs:240)) |
| WK-SSP0024-0385 | D3 | SSP0024_ShipmentMasterElectrode.EditButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSP0024_ShipmentMasterElectrode.EditButton: 진입점 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0024_ShipmentMasterElectrode.Edit) |
| WK-SSP0024-0386 | D3 | SaveButton (cs:280) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SaveButton (cs:280): 행 집계 — D3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton (cs:280)) |
| WK-SSP0024-0387 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SSP0024-0388 | D4 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-03: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SSP0024-0389 | D4 | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-009: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-009) |
| WK-SSP0024-0390 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0024-0391 | D5 | SSP0024_ShipmentMasterElectrode.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0024_ShipmentMasterElectrode.CreateSpread: 진입점 집계 — D5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0392 | E1 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 14: 행 집계 — E1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (14) |
| WK-SSP0024-0393 | E1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 15: 행 집계 — E1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (15) |
| WK-SSP0024-0394 | E1 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-2-007: 행 집계 — E1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-007) |
| WK-SSP0024-0395 | E1 | D00-4d-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-4d-014: 행 집계 — E1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-014) |
| WK-SSP0024-0396 | E1 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-4d-015: 행 집계 — E1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SSP0024-0397 | E1 | SpdMain_ClipboardPasted (cs:659) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — SpdMain_ClipboardPasted (cs:659): 행 집계 — E1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_ClipboardPasted (cs:659)) |
| WK-SSP0024-0398 | E3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 1: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0399 | E3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 2: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0400 | E3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 5: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0401 | E3 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 6: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0402 | E3 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 7: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0024-0403 | E3 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — D00-4a-003: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-003) |
| WK-SSP0024-0404 | E3 | SaveButton (cs:280) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — SaveButton (cs:280): 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton (cs:280)) |
| WK-SSP0024-0405 | E4 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4a-003: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-003) |
| WK-SSP0024-0406 | E4 | SSP0024_ShipmentMasterElectrode.SetCellC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0024_ShipmentMasterElectrode.SetCellCombo: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0407 | E4 | SSP0024_ShipmentMasterElectrode.SetChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0024_ShipmentMasterElectrode.SetChangedControl: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0408 | E4 | SaveButton (cs:280) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SaveButton (cs:280): 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton (cs:280)) |
| WK-SSP0024-0409 | E5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — COMMON:UC-05: 행 집계 — E5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0024-0410 | A1 | BtnMaterialId_Click (cs:730) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BtnMaterialId_Click (cs:730): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0411 | A1 | BtnModelId_Click (cs:750) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BtnModelId_Click (cs:750): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0412 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0413 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (COMMON:UC-03) |
| WK-SSP0024-0414 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (COMMON:UC-06) |
| WK-SSP0024-0415 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0416 | A1 | ClbDivision_SelectedIndexChanged (cs:771 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ClbDivision_SelectedIndexChanged (cs:771): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (ClbDivision_SelectedIndexChanged (cs:771) |
| WK-SSP0024-0417 | A1 | D00-1-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-017: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-1-017) |
| WK-SSP0024-0418 | A1 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-020: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-1-020) |
| WK-SSP0024-0419 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-2-001) |
| WK-SSP0024-0420 | A1 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-002: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-2-002) |
| WK-SSP0024-0421 | A1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-003: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-2-003) |
| WK-SSP0024-0422 | A1 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-007: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-3-007) |
| WK-SSP0024-0423 | A1 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-008: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-3-008) |
| WK-SSP0024-0424 | A1 | D00-3-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-052: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-3-052) |
| WK-SSP0024-0425 | A1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-001: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-4b-001) |
| WK-SSP0024-0426 | A1 | D00-4f-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-001: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-4f-001) |
| WK-SSP0024-0427 | A1 | D00-4f-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-002: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-4f-002) |
| WK-SSP0024-0428 | A1 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-003: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-4f-003) |
| WK-SSP0024-0429 | A1 | D00-4f-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-004: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (D00-4f-004) |
| WK-SSP0024-0430 | A1 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST: 골든 비교 케이스 없음(PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST — 팝업·보조 SP 는 golden_ca |  | 1 (D00-4a-003) |
| WK-SSP0024-0431 | A1 | PKG_SSP0020.P_USER_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0020.P_USER_CHECK: 골든 비교 케이스 없음(PKG_SSP0020.P_USER_CHECK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 1 (D00-4a-003) |
| WK-SSP0024-0432 | A1 | PKG_SSP0024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0024: 골든 비교 케이스 없음(PKG_SSP0024 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-4a-001) |
| WK-SSP0024-0433 | A1 | PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 30 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0434 | A1 | PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER: 골든 비교 케이스 없음(PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER — 팝업·보조 SP 는 golden_cases.cs |  | 37 (D00-4a-001 FindButton (cs:230) ACT:SSP00) |
| WK-SSP0024-0435 | A1 | PKG_SSP0024.P_SSP0024_SAVE_SHIP_MASTER | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0024.P_SSP0024_SAVE_SHIP_MASTER: 골든 비교 케이스 없음(PKG_SSP0024.P_SSP0024_SAVE_SHIP_MASTER — 팝업·보조 SP 는 golden_cases. |  | 1 (D00-4a-002) |
| WK-SSP0024-0436 | G1 | BtnMaterialId_Click (cs:730) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — BtnMaterialId_Click (cs:730): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0437 | G1 | BtnModelId_Click (cs:750) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — BtnModelId_Click (cs:750): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0438 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0439 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SSP0024-0440 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0024-0441 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0024-0442 | G1 | ClbDivision_SelectedIndexChanged (cs:771 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ClbDivision_SelectedIndexChanged (cs:771): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ClbDivision_SelectedIndexChanged (cs:771) |
| WK-SSP0024-0443 | G1 | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-012: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-012) |
| WK-SSP0024-0444 | G1 | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-014: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-014) |
| WK-SSP0024-0445 | G1 | D00-1-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-017: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-017) |
| WK-SSP0024-0446 | G1 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-020: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-020) |
| WK-SSP0024-0447 | G1 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-002: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SSP0024-0448 | G1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-003: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-003) |
| WK-SSP0024-0449 | G1 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-007: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-007) |
| WK-SSP0024-0450 | G1 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-008: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-008) |
| WK-SSP0024-0451 | G1 | D00-3-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-052: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-052) |
| WK-SSP0024-0452 | G1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4b-001: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SSP0024-0453 | G1 | D00-4f-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4f-001: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-001) |
| WK-SSP0024-0454 | G1 | D00-4f-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4f-002: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-002) |
| WK-SSP0024-0455 | G1 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4f-003: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-003) |
| WK-SSP0024-0456 | G1 | D00-4f-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4f-004: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-004) |
| WK-SSP0024-0457 | G1 | FindButton (cs:230) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton (cs:230): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (cs:230)) |
| WK-SSP0024-0458 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0024-0459 | G6 | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-012: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-012) |
| WK-SSP0024-0460 | G6 | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-014: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-014) |
| WK-SSP0024-0461 | G6 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-2-002: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SSP0024-0462 | G6 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-2-003: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-003) |
| WK-SSP0024-0463 | G6 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-4b-001: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SSP0024-0464 | G6 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-4f-003: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-003) |
| WK-SSP0024-0465 | G6 | D00-4f-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-4f-004: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-004) |
| WK-SSP0024-0466 | X-ROW | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (5) |
| WK-SSP0024-0467 | X-ROW | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 8: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (8) |
| WK-SSP0024-0468 | X-ROW | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-001) |
| WK-SSP0024-0469 | X-ROW | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-002) |
| WK-SSP0024-0470 | X-ROW | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-003) |
| WK-SSP0024-0471 | X-ROW | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-004) |
| WK-SSP0024-0472 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SSP0024-0473 | X-ROW | D00-1-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-006) |
| WK-SSP0024-0474 | X-ROW | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-007) |
| WK-SSP0024-0475 | X-ROW | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-010) |
| WK-SSP0024-0476 | X-ROW | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-011) |
| WK-SSP0024-0477 | X-ROW | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-012: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-012) |
| WK-SSP0024-0478 | X-ROW | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-013: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-013) |
| WK-SSP0024-0479 | X-ROW | D00-3-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-032: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-032) |
| WK-SSP0024-0480 | X-ROW | D00-3-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-033: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-033) |
| WK-SSP0024-0481 | X-ROW | D00-3-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-034: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-034) |
| WK-SSP0024-0482 | X-ROW | D00-3-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-035) |
| WK-SSP0024-0483 | X-ROW | D00-3-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-036: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-036) |
| WK-SSP0024-0484 | X-ROW | D00-3-037 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-037: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-037) |
| WK-SSP0024-0485 | X-ROW | D00-3-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-038: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-038) |
| WK-SSP0024-0486 | X-ROW | D00-3-039 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-039: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-039) |
| WK-SSP0024-0487 | X-ROW | D00-3-048 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-048: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-048) |
| WK-SSP0024-0488 | X-ROW | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-005) |
| WK-SSP0024-0489 | X-ROW | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-008) |
| WK-SSP0024-0490 | X-ROW | MyDivision (cs:37) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MyDivision (cs:37): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MyDivision (cs:37)) |
| WK-SSP0024-0491 | X-ROW | PlantSiteByFactoryEEOperation (cs:191) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — PlantSiteByFactoryEEOperation (cs:191): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (PlantSiteByFactoryEEOperation (cs:191)) |
| WK-SSP0024-0492 | X-ROW | SSP0024_ItembyDivisionPopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0024_ItembyDivisionPopup..ctor:15) |
| WK-SSP0024-0493 | X-ROW | SSP0024_ItembyDivisionPopup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0024_ItembyDivisionPopup.CreateSp) |
| WK-SSP0024-0494 | X-ROW | SSP0024_ItembyDivisionPopup.DefineProper | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0024_ItembyDivisionPopup.DefinePr) |
| WK-SSP0024-0495 | X-ROW | SSP0024_ItembyDivisionPopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0024_ItembyDivisionPopup.Dispose:) |
| WK-SSP0024-0496 | X-ROW | SSP0024_ItembyDivisionPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:SSP0024_ItembyDivisionPopup.FindButt) |
| WK-SSP0024-0497 | X-ROW | SSP0024_ItembyDivisionPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.FindData: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:1 · PASS:1 |  | 27 (ACT:SSP0024_ItembyDivisionPopup.FindData) |
| WK-SSP0024-0498 | X-ROW | SSP0024_ItembyDivisionPopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SSP0024_ItembyDivisionPopup.Form_Loa) |
| WK-SSP0024-0499 | X-ROW | SSP0024_ItembyDivisionPopup.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.GetDivision: 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SSP0024_ItembyDivisionPopup.GetDivis) |
| WK-SSP0024-0500 | X-ROW | SSP0024_ItembyDivisionPopup.GetDivisionb | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.GetDivisionbyPlantSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0024_ItembyDivisionPopup.GetDivis) |
| WK-SSP0024-0501 | X-ROW | SSP0024_ItembyDivisionPopup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.InitControls: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SSP0024_ItembyDivisionPopup.InitCont) |
| WK-SSP0024-0502 | X-ROW | SSP0024_ItembyDivisionPopup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.InitSpread: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SSP0024_ItembyDivisionPopup.InitSpre) |
| WK-SSP0024-0503 | X-ROW | SSP0024_ItembyDivisionPopup.SetMaterial | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.SetMaterial: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 40 (ACT:SSP0024_ItembyDivisionPopup.SetMater) |
| WK-SSP0024-0504 | X-ROW | SSP0024_ItembyDivisionPopup.btnButtonLis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.btnButtonList_UsrButto: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0024_ItembyDivisionPopup.btnButto) |
| WK-SSP0024-0505 | X-ROW | SSP0024_ItembyDivisionPopup.clbDivision_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.clbDivision_SelectedIn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0024_ItembyDivisionPopup.clbDivis) |
| WK-SSP0024-0506 | X-ROW | SSP0024_ItembyDivisionPopup.spdMain_Cell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ItembyDivisionPopup.spdMain_CellDoubleClic: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0024_ItembyDivisionPopup.spdMain_) |
| WK-SSP0024-0507 | X-ROW | SSP0024_ShipmentMasterElectrode.BtnMater | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.BtnMaterialId_Clic: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0508 | X-ROW | SSP0024_ShipmentMasterElectrode.BtnModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.BtnModelId_Click: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0024_ShipmentMasterElectrode.BtnM) |
| WK-SSP0024-0509 | X-ROW | SSP0024_ShipmentMasterElectrode.ClbDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.ClbDivision_Select: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.ClbD) |
| WK-SSP0024-0510 | X-ROW | SSP0024_ShipmentMasterElectrode.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Crea) |
| WK-SSP0024-0511 | X-ROW | SSP0024_ShipmentMasterElectrode.DefinePr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Defi) |
| WK-SSP0024-0512 | X-ROW | SSP0024_ShipmentMasterElectrode.FindButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Find) |
| WK-SSP0024-0513 | X-ROW | SSP0024_ShipmentMasterElectrode.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.FindData: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:1 · PASS:1 |  | 6 (ACT:SSP0024_ShipmentMasterElectrode.Find) |
| WK-SSP0024-0514 | X-ROW | SSP0024_ShipmentMasterElectrode.Form_Loa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Form) |
| WK-SSP0024-0515 | X-ROW | SSP0024_ShipmentMasterElectrode.GetSelec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.GetSelectedListNam: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.GetS) |
| WK-SSP0024-0516 | X-ROW | SSP0024_ShipmentMasterElectrode.InitCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.InitControls: 진입점 집계 7검사 — NOT_RUN:4 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.Init) |
| WK-SSP0024-0517 | X-ROW | SSP0024_ShipmentMasterElectrode.InitSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0024_ShipmentMasterElectrode.Init) |
| WK-SSP0024-0518 | X-ROW | SSP0024_ShipmentMasterElectrode.InsertBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0519 | X-ROW | SSP0024_ShipmentMasterElectrode.InsertRo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.InsertRow: 진입점 집계 32검사 — NOT_RUN:20 · NOPATH:12 (미실행 검사가 남아 판정필요) |  | 17 (ACT:SSP0024_ShipmentMasterElectrode.Inse) |
| WK-SSP0024-0520 | X-ROW | SSP0024_ShipmentMasterElectrode.Re_Desig | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.Re_Design: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LIST_REBIND, 연결된 요소 검사 없음 |  | 5 (ACT:SSP0024_ShipmentMasterElectrode.Re_D) |
| WK-SSP0024-0521 | X-ROW | SSP0024_ShipmentMasterElectrode.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.SaveData: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0024_ShipmentMasterElectrode.Save) |
| WK-SSP0024-0522 | X-ROW | SSP0024_ShipmentMasterElectrode.SetCellC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.SetCellCombo: 진입점 집계 4검사 — REVIEW:2 · NOT_RUN:2 |  | 1 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0523 | X-ROW | SSP0024_ShipmentMasterElectrode.SetChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.SetChangedControl: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0024_ShipmentMasterElectrode.SetC) |
| WK-SSP0024-0524 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.SpdMain_CellClick: 진입점 집계 15검사 — NOT_RUN:13 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 37 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0525 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.SpdMain_ClipboardP: 진입점 집계 25검사 — NOT_RUN:19 · NOPATH:6 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0526 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.SpdMain_ComboSelCh: 진입점 집계 39검사 — NOT_RUN:36 · REVIEW:3 |  | 10 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0527 | X-ROW | SSP0024_ShipmentMasterElectrode.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/RETURN/UI_PROP, 연결된 요 |  | 5 (ACT:SSP0024_ShipmentMasterElectrode.SpdM) |
| WK-SSP0024-0528 | X-ROW | SSP0024_ShipmentMasterElectrode.checkVal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0024_ShipmentMasterElectrode.checkValidN1: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SSP0024_ShipmentMasterElectrode.chec) |
| WK-SSP0024-0529 | G5 | BtnMaterialId_Click (cs:730) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — BtnMaterialId_Click (cs:730): 행 집계 — G5 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0530 | G5 | BtnModelId_Click (cs:750) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — BtnModelId_Click (cs:750): 행 집계 — G5 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0531 | G5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — COMMON:UC-02: 행 집계 — G5 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0532 | G5 | D00-4d-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4d-009: 행 집계 — G5 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-009) |
| WK-SSP0024-0533 | G5 | D00-4f-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4f-001: 행 집계 — G5 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-001) |
| WK-SSP0024-0534 | G5 | MODAL:ElectrodeItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ElectrodeItemByDivisionModal: 행 집계 — G5 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ElectrodeItemByDivisionModal) |
| WK-SSP0024-0535 | H6 | BtnMaterialId_Click (cs:730) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — BtnMaterialId_Click (cs:730): 행 집계 — H6 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0536 | H6 | BtnModelId_Click (cs:750) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — BtnModelId_Click (cs:750): 행 집계 — H6 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0537 | H6 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — COMMON:UC-02: 행 집계 — H6 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0538 | H6 | D00-4d-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4d-009: 행 집계 — H6 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-009) |
| WK-SSP0024-0539 | H6 | D00-4f-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4f-001: 행 집계 — H6 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-001) |
| WK-SSP0024-0540 | H6 | MODAL:ElectrodeItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ElectrodeItemByDivisionModal: 행 집계 — H6 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ElectrodeItemByDivisionModal) |
| WK-SSP0024-0541 | M4 | BtnMaterialId_Click (cs:730) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — BtnMaterialId_Click (cs:730): 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (BtnMaterialId_Click (cs:730)) |
| WK-SSP0024-0542 | M4 | BtnModelId_Click (cs:750) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — BtnModelId_Click (cs:750): 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (BtnModelId_Click (cs:750)) |
| WK-SSP0024-0543 | M4 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — COMMON:UC-02: 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0024-0544 | M4 | D00-4d-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-009: 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-009) |
| WK-SSP0024-0545 | M4 | D00-4f-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4f-001: 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-001) |
| WK-SSP0024-0546 | M4 | MODAL:ElectrodeItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ElectrodeItemByDivisionModal: 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ElectrodeItemByDivisionModal) |
