# 작업 원장 — DMF0021 · 2026-10-26 12:49

> 검사 인스턴스 2298건 중 PASS·NA 307건 외 **1991건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 56 | 구현 위치 실존 |
| W3 | 동작 수정 | 93 | 재판정 PASS |
| W4 | 검사기 구현 | 15 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 95 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 404 | 실행 → PASS |
| W7 | 기대값 확정 | 1328 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 1268 · E2E 404 · 대조표 116 · 하네스 110 · FE 91 · DB 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 20건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 56 |  |  |  |  | 152 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| D1 | EDIT |  |  |  |  |  | 53 | 118 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 53 | 118 |  |  | 행 값 기반 조건부 잠금 |
| X-ROW | GEN |  |  |  |  |  |  | 162 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| H2 | DESIGN |  |  |  |  |  | 50 | 59 |  |  | 배경·글자색 규칙 |
| E4 | EDIT |  |  |  |  |  | 40 | 61 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E3 | EDIT |  |  | 92 |  |  | 1 |  |  |  | 필수 입력 검증 |
| F4 | DB |  |  |  |  |  | 15 | 75 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 11 |  | 75 |  |  | BE 계정 시노님·권한·대상 객체 |
| X-REASON | DESIGN |  |  |  |  |  |  | 60 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | GEN |  |  |  |  |  |  | 59 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B4 | COMBO |  |  |  |  | 19 |  | 38 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C3 | CASCADE |  |  |  |  |  | 20 | 37 |  |  | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 16 | 39 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C2 | CASCADE |  |  |  |  |  | 16 | 31 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 16 | 31 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| B3 | COMBO |  |  |  | 15 |  |  | 26 |  |  | 콤보 후보 정렬 = AS-IS |
| D4 | EDIT |  |  |  |  |  | 5 | 30 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| G4 | DESIGN |  |  |  |  | 6 | 16 | 12 |  |  | 조회조건 표시·라벨·활성 |
| M4 | POPUP |  |  |  |  |  | 22 | 10 |  |  | 팝업 선택값 반영 |
| G6 | GEN |  |  |  |  |  | 16 | 15 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| D5 | EDIT |  |  |  |  |  | 14 | 15 |  |  | 셀 에디터 유형 |
| C1 | CASCADE |  |  |  |  |  | 8 | 18 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B1 | COMBO |  |  |  |  | 13 |  | 12 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 13 |  | 12 |  |  | 콤보 후보 중복 없음 |
| G5 | POPUP |  |  |  |  | 14 |  | 10 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 10 | 4 | 10 |  |  | 팝업 표준·열림 |
| E5 | EDIT |  |  |  |  | 6 |  | 12 |  |  | 콤보 셀 후보 외 값 차단 |
| A5 | DESIGN |  |  |  |  |  | 9 | 7 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 10 | 6 |  |  | 라벨 명칭 |
| A6 | GEN |  |  |  |  |  | 1 | 14 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| E1 | EDIT |  |  |  |  |  | 7 | 4 |  |  | 숫자 소수자리·정수·부호·범위 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H3 | DESIGN |  |  |  |  |  | 1 |  |  |  | 셀 병합 = AS-IS |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (56)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0021-0001 | X-LOC | CA-152 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 |  | 1 (CA-152) |
| WK-DMF0021-0002 | X-LOC | CA-153 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 |  | 1 (CA-153) |
| WK-DMF0021-0003 | X-LOC | CA-154 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 |  | 1 (CA-154) |
| WK-DMF0021-0004 | X-LOC | CB-109 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 |  | 1 (CB-109) |
| WK-DMF0021-0005 | X-LOC | CB-110 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 |  | 1 (CB-110) |
| WK-DMF0021-0006 | X-LOC | CC-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:71-71 > 50줄 |  | 1 (CC-01) |
| WK-DMF0021-0007 | X-LOC | CC-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:69-69 > 50줄 |  | 1 (CC-03) |
| WK-DMF0021-0008 | X-LOC | CC-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:70-70 > 50줄 |  | 1 (CC-06) |
| WK-DMF0021-0009 | X-LOC | CC-09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:68-68 > 50줄 |  | 1 (CC-09) |
| WK-DMF0021-0010 | X-LOC | CC-107 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CC-107) |
| WK-DMF0021-0011 | X-LOC | CC-117 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CC-117) |
| WK-DMF0021-0012 | X-LOC | CC-12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CC-12) |
| WK-DMF0021-0013 | X-LOC | CC-17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:75-75 > 50줄 |  | 1 (CC-17) |
| WK-DMF0021-0014 | X-LOC | CC-18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:76-76 > 50줄 |  | 1 (CC-18) |
| WK-DMF0021-0015 | X-LOC | CC-19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:77-77 > 50줄 |  | 1 (CC-19) |
| WK-DMF0021-0016 | X-LOC | CC-20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-88 > 50줄 |  | 1 (CC-20) |
| WK-DMF0021-0017 | X-LOC | CC-21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:71-72 > 50줄 |  | 1 (CC-21) |
| WK-DMF0021-0018 | X-LOC | CC-22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:73-73 > 50줄 |  | 1 (CC-22) |
| WK-DMF0021-0019 | X-LOC | CC-25 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:80-82 > 50줄 |  | 1 (CC-25) |
| WK-DMF0021-0020 | X-LOC | CE-105 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:75-75 > 50줄 |  | 1 (CE-105) |
| WK-DMF0021-0021 | X-LOC | CF-100 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-100) |
| WK-DMF0021-0022 | X-LOC | CF-101 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-101) |
| WK-DMF0021-0023 | X-LOC | CF-102 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-102) |
| WK-DMF0021-0024 | X-LOC | CF-103 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-103) |
| WK-DMF0021-0025 | X-LOC | CF-104 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-104) |
| WK-DMF0021-0026 | X-LOC | CF-105 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-105) |
| WK-DMF0021-0027 | X-LOC | CF-106 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-106) |
| WK-DMF0021-0028 | X-LOC | CF-107 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-107) |
| WK-DMF0021-0029 | X-LOC | CF-108 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-108) |
| WK-DMF0021-0030 | X-LOC | CF-87 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-87) |
| WK-DMF0021-0031 | X-LOC | CF-88 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-88) |
| WK-DMF0021-0032 | X-LOC | CF-89 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-89) |
| WK-DMF0021-0033 | X-LOC | CF-91 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-91) |
| WK-DMF0021-0034 | X-LOC | CF-92 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-92) |
| WK-DMF0021-0035 | X-LOC | CF-93 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-93) |
| WK-DMF0021-0036 | X-LOC | CF-94 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-94) |
| WK-DMF0021-0037 | X-LOC | CF-95 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-95) |
| WK-DMF0021-0038 | X-LOC | CF-96 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-96) |
| WK-DMF0021-0039 | X-LOC | CF-98 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-98) |
| WK-DMF0021-0040 | X-LOC | CF-99 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (CF-99) |
| WK-DMF0021-0041 | X-LOC | CG-00 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 |  | 1 (CG-00) |
| WK-DMF0021-0042 | X-LOC | CRUD:E04:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:99-213 > 203줄 |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0021-0043 | X-LOC | Delete (F9) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Delete (F9)) |
| WK-DMF0021-0044 | X-LOC | E04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:99-213 > 203줄 |  | 1 (E04) |
| WK-DMF0021-0045 | X-LOC | E06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts 없음 |  | 1 (E06) |
| WK-DMF0021-0046 | X-LOC | Edit (F2) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Edit (F2)) |
| WK-DMF0021-0047 | X-LOC | Excel (F12) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Excel (F12)) |
| WK-DMF0021-0048 | X-LOC | Filter/Sort/Condition/Reset | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Filter/Sort/Condition/Reset) |
| WK-DMF0021-0049 | X-LOC | Find (F5) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Find (F5)) |
| WK-DMF0021-0050 | X-LOC | HANDLER:SaveData | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.save.ts:99-213 > 203줄 |  | 1 (HANDLER:SaveData) |
| WK-DMF0021-0051 | X-LOC | HANDLER:spdMain_ComboSelChange | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts:61-83 > 50줄 |  | 1 (HANDLER:spdMain_ComboSelChange) |
| WK-DMF0021-0052 | X-LOC | Insert (F8) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Insert (F8)) |
| WK-DMF0021-0053 | X-LOC | MODAL:MeasureSelectModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/sales-plan/components/modals/MeasureSelectModal.tsx 없음 |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0021-0054 | X-LOC | Save (F7) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Save (F7)) |
| WK-DMF0021-0055 | X-LOC | btnColumn/btnMeasure | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnColumn/btnMeasure) |
| WK-DMF0021-0056 | X-LOC | btnProject/btnItemId/btnOwner | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnProject/btnItemId/btnOwner) |

## W3 동작 수정 (93)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0021-0057 | H10 | DMF0021 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — DMF0021 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: utils/sales-plan.validate.ts |  | 36 (CA-111 CA-112 CA-128 CA-139 CA-142 CD-11) |
| WK-DMF0021-0058 | E3 | 10 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 10: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (10) |
| WK-DMF0021-0059 | E3 | 102 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 102: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (102) |
| WK-DMF0021-0060 | E3 | 103 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 103: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (103) |
| WK-DMF0021-0061 | E3 | 104 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 104: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (104) |
| WK-DMF0021-0062 | E3 | 105 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 105: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (105) |
| WK-DMF0021-0063 | E3 | 106 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 106: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (106) |
| WK-DMF0021-0064 | E3 | 107 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 107: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (107) |
| WK-DMF0021-0065 | E3 | 108 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 108: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (108) |
| WK-DMF0021-0066 | E3 | 109 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 109: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (109) |
| WK-DMF0021-0067 | E3 | 11 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 11: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (11) |
| WK-DMF0021-0068 | E3 | 110 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 110: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (110) |
| WK-DMF0021-0069 | E3 | 111 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 111: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (111) |
| WK-DMF0021-0070 | E3 | 135 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 135: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (135) |
| WK-DMF0021-0071 | E3 | 136 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 136: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (136) |
| WK-DMF0021-0072 | E3 | 137 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 137: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (137) |
| WK-DMF0021-0073 | E3 | 138 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 138: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (138) |
| WK-DMF0021-0074 | E3 | 139 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 139: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (139) |
| WK-DMF0021-0075 | E3 | 140 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 140: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (140) |
| WK-DMF0021-0076 | E3 | 141 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 141: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (141) |
| WK-DMF0021-0077 | E3 | 28 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 28: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (28) |
| WK-DMF0021-0078 | E3 | 31 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 31: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (31) |
| WK-DMF0021-0079 | E3 | 32 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 32: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (32) |
| WK-DMF0021-0080 | E3 | 33 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 33: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (33) |
| WK-DMF0021-0081 | E3 | 34 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 34: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (34) |
| WK-DMF0021-0082 | E3 | 35 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 35: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (35) |
| WK-DMF0021-0083 | E3 | 37 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 37: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 0 () |
| WK-DMF0021-0084 | E3 | 38 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 38: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (38) |
| WK-DMF0021-0085 | E3 | 39 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 39: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (39) |
| WK-DMF0021-0086 | E3 | 40 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 40: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (40) |
| WK-DMF0021-0087 | E3 | 41 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 41: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (41) |
| WK-DMF0021-0088 | E3 | 42 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 42: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (42) |
| WK-DMF0021-0089 | E3 | 43 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 43: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (43) |
| WK-DMF0021-0090 | E3 | 45 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 45: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (45) |
| WK-DMF0021-0091 | E3 | 5 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 5: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (5) |
| WK-DMF0021-0092 | E3 | 59 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 59: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (59) |
| WK-DMF0021-0093 | E3 | 6 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 6: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (6) |
| WK-DMF0021-0094 | E3 | 60 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 60: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (60) |
| WK-DMF0021-0095 | E3 | 61 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 61: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (61) |
| WK-DMF0021-0096 | E3 | 62 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 62: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (62) |
| WK-DMF0021-0097 | E3 | 63 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 63: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (63) |
| WK-DMF0021-0098 | E3 | 64 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 64: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (64) |
| WK-DMF0021-0099 | E3 | 65 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 65: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (65) |
| WK-DMF0021-0100 | E3 | 66 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 66: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (66) |
| WK-DMF0021-0101 | E3 | 67 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 67: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (67) |
| WK-DMF0021-0102 | E3 | 68 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 68: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (68) |
| WK-DMF0021-0103 | E3 | 69 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 69: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (69) |
| WK-DMF0021-0104 | E3 | 7 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 7: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (7) |
| WK-DMF0021-0105 | E3 | 70 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 70: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (70) |
| WK-DMF0021-0106 | E3 | 71 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 71: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (71) |
| WK-DMF0021-0107 | E3 | 73 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 73: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (73) |
| WK-DMF0021-0108 | E3 | 74 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 74: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (74) |
| WK-DMF0021-0109 | E3 | 75 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 75: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (75) |
| WK-DMF0021-0110 | E3 | 76 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 76: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (76) |
| WK-DMF0021-0111 | E3 | 77 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 77: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (77) |
| WK-DMF0021-0112 | E3 | 78 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 78: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (78) |
| WK-DMF0021-0113 | E3 | 79 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 79: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (79) |
| WK-DMF0021-0114 | E3 | 80 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 80: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (80) |
| WK-DMF0021-0115 | E3 | 81 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 81: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (81) |
| WK-DMF0021-0116 | E3 | 82 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 82: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (82) |
| WK-DMF0021-0117 | E3 | 83 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 83: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (83) |
| WK-DMF0021-0118 | E3 | 84 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 84: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (84) |
| WK-DMF0021-0119 | E3 | 85 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 85: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (85) |
| WK-DMF0021-0120 | E3 | 88 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 88: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (88) |
| WK-DMF0021-0121 | E3 | 89 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 89: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (89) |
| WK-DMF0021-0122 | E3 | 9 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 9: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (9) |
| WK-DMF0021-0123 | E3 | 90 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 90: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (90) |
| WK-DMF0021-0124 | E3 | 91 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 91: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (91) |
| WK-DMF0021-0125 | E3 | 92 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 92: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (92) |
| WK-DMF0021-0126 | E3 | 97 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 97: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (97) |
| WK-DMF0021-0127 | E3 | 98 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 98: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (98) |
| WK-DMF0021-0128 | E3 | CA-126 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CA-126: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CA-126) |
| WK-DMF0021-0129 | E3 | CA-128 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CA-128: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CA-128) |
| WK-DMF0021-0130 | E3 | CA-129 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CA-129: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CA-129) |
| WK-DMF0021-0131 | E3 | CA-130 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CA-130: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CA-130) |
| WK-DMF0021-0132 | E3 | CA-134 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CA-134: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CA-134) |
| WK-DMF0021-0133 | E3 | CA-135 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CA-135: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CA-135) |
| WK-DMF0021-0134 | E3 | CA-137 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CA-137: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CA-137) |
| WK-DMF0021-0135 | E3 | CA-138 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CA-138: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CA-138) |
| WK-DMF0021-0136 | E3 | CA-139 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CA-139: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CA-139) |
| WK-DMF0021-0137 | E3 | CD-113 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CD-113: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CD-113) |
| WK-DMF0021-0138 | E3 | CD-119 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CD-119: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CD-119) |
| WK-DMF0021-0139 | E3 | CD-120 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CD-120: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CD-120) |
| WK-DMF0021-0140 | E3 | CD-130 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CD-130: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CD-130) |
| WK-DMF0021-0141 | E3 | CD-137 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CD-137: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CD-137) |
| WK-DMF0021-0142 | E3 | CG-01 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CG-01: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CG-01) |
| WK-DMF0021-0143 | E3 | CG-02 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CG-02: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CG-02) |
| WK-DMF0021-0144 | E3 | CRUD:E07:SEARCH | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — CRUD:E07:SEARCH: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (CRUD:E07:SEARCH) |
| WK-DMF0021-0145 | E3 | DEPT_ID | DB(🛠️/🧯 적용 가능) | E3 FAIL 수정 — DEPT_ID: 필수 표시 AS-IS -('Team') ↔ TO-BE *('Team_ID' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 checkRequiredOfSpread 대상 차이) |  | 6 (27 86 119 120 121 122) |
| WK-DMF0021-0146 | E3 | E07 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — E07: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (E07) |
| WK-DMF0021-0147 | E3 | END_CUSTOMER | DB(🛠️/🧯 적용 가능) | E3 FAIL 수정 — END_CUSTOMER: 필수 표시 AS-IS -('End Customer') ↔ TO-BE *('End Customer' INPUT_TP_CD=IM) — 필수 여부 불일치(저장 검증 checkRequiredO |  | 5 (CA-131 123 124 125 126) |
| WK-DMF0021-0148 | E3 | HANDLER:FindData | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — HANDLER:FindData: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (HANDLER:FindData) |
| WK-DMF0021-0149 | E3 | HANDLER:cboBucketType_Click | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — HANDLER:cboBucketType_Click: 행 집계 — E3 10요소: PASS:7 · FAIL:2 · NOT_RUN:1 |  | 1 (HANDLER:cboBucketType_Click) |

## W4 검사기 구현 (15)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0021-0150 | B3 | CELL_PROD_SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CELL_PROD_SITE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0021_SalesPlan.InsertRow:2946:35 ) |
| WK-DMF0021-0151 | B3 | D | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 D | 있음(FE 소스) | 0 () |
| WK-DMF0021-0152 | B3 | DEPT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DEPT_ID | 있음(SHEET_COLUMNS) | 11 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0153 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 19 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0154 | B3 | END_CUSTOMER | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0155 | B3 | END_CUSTOMER40 | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 END_CUSTOMER40 | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0156 | B3 | ITEM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ITEM_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0021_SalesPlan.spdMain_ClipboardP) |
| WK-DMF0021-0157 | B3 | P | 하네스(검증 엔진 _trace.spec.ts) + 구현 확인(TO-BE  | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 P | 없음 | 1 (ACT:DMF0021_SalesPlan.GetIncotermsType:5) |
| WK-DMF0021-0158 | B3 | PLANT_SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0159 | B3 | SCM_SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SCM_SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0160 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (ACT:DMF0021_SalesPlan.EditButton:880:48 ) |
| WK-DMF0021-0161 | B3 | clbCustomer / End Customer / Customer | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbCustomer / End Customer / Customer | 있음(FE 소스) | 2 (ACT:DMF0021_SalesPlan.clbCustomer_Select) |
| WK-DMF0021-0162 | B3 | clbDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision / Division | 있음(FE 소스) | 10 (ACT:DMF0021_SalesPlan.EditButton:880:48 ) |
| WK-DMF0021-0163 | B3 | clbTeam / Team | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbTeam / Team | 있음(FE 소스) | 6 (ACT:DMF0021_SalesPlan.InsertRow:1679:220) |
| WK-DMF0021-0164 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 5 (ACT:DMF0021_SalesPlan.GetSpdTitle ACT:DM) |

## W5 검사기 연결 (95)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0021-0165 | B1 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL C | 있음(FE 소스) | 0 () |
| WK-DMF0021-0166 | B1 | CELL_PROD_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL CELL_PROD_SITE_ID | 있음(SHEET_COLUMNS) | 4 (CELL_PROD_SITE_ID ACT:DMF0021_SalesPlan.) |
| WK-DMF0021-0167 | B1 | CURRENCY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL CURRENCY | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.InsertRow:3035:84 ) |
| WK-DMF0021-0168 | B1 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL D | 있음(FE 소스) | 0 () |
| WK-DMF0021-0169 | B1 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 16 (ACT:DMF0021_SalesPlan.InsertRow:2925:25 ) |
| WK-DMF0021-0170 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 26 (1 2 3 4 ACT:DMF0021_SalesPlan.spdMain_Co) |
| WK-DMF0021-0171 | B1 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 9 (123 124 125 126 ACT:DMF0021_SalesPlan.In) |
| WK-DMF0021-0172 | B1 | END_CUSTOMER40 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER40 | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0021_SalesPlan.InsertRow:1688:227) |
| WK-DMF0021-0173 | B1 | INCOTERMS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL INCOTERMS | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0174 | B1 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 5 (1 2 3 4 ACT:DMF0021_SalesPlan.spdMain_Cl) |
| WK-DMF0021-0175 | B1 | MEASURE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL MEASURE | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.InsertRow:2960:42 ) |
| WK-DMF0021-0176 | B1 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0177 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 10 (ACT:DMF0021_SalesPlan.InsertRow:2954:40 ) |
| WK-DMF0021-0178 | B2 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL C | 있음(FE 소스) | 0 () |
| WK-DMF0021-0179 | B2 | CELL_PROD_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL CELL_PROD_SITE_ID | 있음(SHEET_COLUMNS) | 4 (CELL_PROD_SITE_ID ACT:DMF0021_SalesPlan.) |
| WK-DMF0021-0180 | B2 | CURRENCY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL CURRENCY | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.InsertRow:3035:84 ) |
| WK-DMF0021-0181 | B2 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL D | 있음(FE 소스) | 0 () |
| WK-DMF0021-0182 | B2 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 16 (ACT:DMF0021_SalesPlan.InsertRow:2925:25 ) |
| WK-DMF0021-0183 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 26 (1 2 3 4 ACT:DMF0021_SalesPlan.spdMain_Co) |
| WK-DMF0021-0184 | B2 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 9 (123 124 125 126 ACT:DMF0021_SalesPlan.In) |
| WK-DMF0021-0185 | B2 | END_CUSTOMER40 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER40 | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0021_SalesPlan.InsertRow:1688:227) |
| WK-DMF0021-0186 | B2 | INCOTERMS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL INCOTERMS | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0187 | B2 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 5 (1 2 3 4 ACT:DMF0021_SalesPlan.spdMain_Cl) |
| WK-DMF0021-0188 | B2 | MEASURE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL MEASURE | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.InsertRow:2960:42 ) |
| WK-DMF0021-0189 | B2 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0190 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 10 (ACT:DMF0021_SalesPlan.InsertRow:2954:40 ) |
| WK-DMF0021-0191 | B4 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL C | 있음(FE 소스) | 0 () |
| WK-DMF0021-0192 | B4 | CELL_PROD_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CELL_PROD_SITE_ID | 있음(SHEET_COLUMNS) | 7 (CELL_PROD_SITE_ID ACT:DMF0021_SalesPlan.) |
| WK-DMF0021-0193 | B4 | CURRENCY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CURRENCY | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.InsertRow:3035:84 ) |
| WK-DMF0021-0194 | B4 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL D | 있음(FE 소스) | 0 () |
| WK-DMF0021-0195 | B4 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 27 (ACT:DMF0021_SalesPlan.InsertRow:2925:25 ) |
| WK-DMF0021-0196 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 45 (1 2 3 4 ACT:DMF0021_SalesPlan.spdMain_Co) |
| WK-DMF0021-0197 | B4 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 11 (123 124 125 126 ACT:DMF0021_SalesPlan.In) |
| WK-DMF0021-0198 | B4 | END_CUSTOMER40 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER40 | 있음(SHEET_COLUMNS) | 6 (ACT:DMF0021_SalesPlan.InsertRow:1688:227) |
| WK-DMF0021-0199 | B4 | INCOTERMS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL INCOTERMS | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0200 | B4 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 6 (1 2 3 4 ACT:DMF0021_SalesPlan.spdMain_Cl) |
| WK-DMF0021-0201 | B4 | MEASURE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL MEASURE | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0021_SalesPlan.InsertRow:2960:42 ) |
| WK-DMF0021-0202 | B4 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL P | 없음 | 1 (ACT:DMF0021_SalesPlan.GetIncotermsType:5) |
| WK-DMF0021-0203 | B4 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0204 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 12 (ACT:DMF0021_SalesPlan.InsertRow:2954:40 ) |
| WK-DMF0021-0205 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (ACT:DMF0021_SalesPlan.EditButton:880:48 ) |
| WK-DMF0021-0206 | B4 | clbCustomer / End Customer / Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbCustomer / End Customer / Customer | 있음(FE 소스) | 2 (ACT:DMF0021_SalesPlan.clbCustomer_Select) |
| WK-DMF0021-0207 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 10 (ACT:DMF0021_SalesPlan.EditButton:880:48 ) |
| WK-DMF0021-0208 | B4 | clbTeam / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbTeam / Team | 있음(FE 소스) | 6 (ACT:DMF0021_SalesPlan.InsertRow:1679:220) |
| WK-DMF0021-0209 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 5 (ACT:DMF0021_SalesPlan.GetSpdTitle ACT:DM) |
| WK-DMF0021-0210 | F2 | DMF0021 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0021 화면 | 판단불가(대상 단위 SCREEN) | 595 (E04 CA-142 CA-143 CC-113 CD-125 CD-129 C) |
| WK-DMF0021-0211 | F6 | DMF0021 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0021 화면 | 판단불가(대상 단위 SCREEN) | 629 (E04 CA-126 CA-127 CA-128 CA-129 CA-130 C) |
| WK-DMF0021-0212 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 3 (ACT:DMF0021_SalesPlan.GetBucketType:3431) |
| WK-DMF0021-0213 | DB-SYN | DM0021_GET_SPREAD_TITLE_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0021_GET_SPREAD_TITLE_DATE | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0021_SalesPlan.InitSpread_X:437:8) |
| WK-DMF0021-0214 | DB-SYN | DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0021_SalesPlan.SaveData_All:1261:) |
| WK-DMF0021-0215 | DB-SYN | DMF0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 3 (ACT:DMF0021_SalesPlan.GetBucketType:3430) |
| WK-DMF0021-0216 | DB-SYN | DMF0021_GET_SALES_PLAN_MEASUREINFO2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0021_GET_SALES_PLAN_MEASUREINFO2 | 없음(PROC_M 대응 없음) | 4 (ACT:DMF0021_SalesPlan.GetSALESPLAN_MEASU) |
| WK-DMF0021-0217 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | 없음(PROC_M 대응 없음) | 8 (ACT:DMF0021_SalesPlan.GetBizTypebyDivisi) |
| WK-DMF0021-0218 | DB-SYN | SCM0001_GET_CUSTOMER_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_CUSTOMER_BY_DIVISION | 없음(PROC_M 대응 없음) | 12 (ACT:DMF0021_SalesPlan.GetCustomerbyDivis) |
| WK-DMF0021-0219 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 4 (ACT:DMF0021_SalesPlan.GetItemType:3442:3) |
| WK-DMF0021-0220 | DB-SYN | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 없음(PROC_M 대응 없음) | 8 (ACT:DMF0021_SalesPlan.GetPlantSitebyEndC) |
| WK-DMF0021-0221 | DB-SYN | SCM0001_GET_SITE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SITE_BY_DIVISION | 없음(PROC_M 대응 없음) | 8 (ACT:DMF0021_SalesPlan.GetScmSitebyDivisi) |
| WK-DMF0021-0222 | DB-SYN | SCM0001_GET_TEAM_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_TEAM_BY_DIVISION | 없음(PROC_M 대응 없음) | 8 (ACT:DMF0021_SalesPlan.GetTeambyDivision:) |
| WK-DMF0021-0223 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (btnColumn/btnMeasure) |
| WK-DMF0021-0224 | G4 | btnCutOff | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnCutOff | 없음 | 6 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0225 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-0226 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (btnColumn/btnMeasure) |
| WK-DMF0021-0227 | G4 | btnOwner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnOwner | 없음 | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-0228 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 있음(FE 소스) | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-0229 | E5 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL C | 있음(FE 소스) | 0 () |
| WK-DMF0021-0230 | E5 | CELL_PROD_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL CELL_PROD_SITE_ID | 있음(SHEET_COLUMNS) | 1 (CELL_PROD_SITE_ID) |
| WK-DMF0021-0231 | E5 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL D | 있음(FE 소스) | 0 () |
| WK-DMF0021-0232 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (1 2 3 4) |
| WK-DMF0021-0233 | E5 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 4 (123 124 125 126) |
| WK-DMF0021-0234 | E5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 4 (1 2 3 4) |
| WK-DMF0021-0235 | G03-WIRE | DMF0021 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0021 화면 | 판단불가(대상 단위 SCREEN) | 14 (ACT:DMF0021_SalesPlan..ctor ACT:DMF0021_) |
| WK-DMF0021-0236 | G5 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL C | 있음(FE 소스) | 0 () |
| WK-DMF0021-0237 | G5 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL D | 있음(FE 소스) | 0 () |
| WK-DMF0021-0238 | G5 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL I | 있음(FE 소스) | 1 (CA-159) |
| WK-DMF0021-0239 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 9 (CC-02 99 ACT:DMF0021_SalesPlan.spdMain_C) |
| WK-DMF0021-0240 | G5 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 1 (CA-159) |
| WK-DMF0021-0241 | G5 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnColumn | 있음(FE 소스) | 0 () |
| WK-DMF0021-0242 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-0243 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnMeasure | 있음(FE 소스) | 0 () |
| WK-DMF0021-0244 | G5 | btnOwner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnOwner | 없음 | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-0245 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProject | 있음(FE 소스) | 3 (CA-104 btnProject/btnItemId/btnOwner 97) |
| WK-DMF0021-0246 | G5 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 10 (ACT:DMF0021_SalesPlan.btnColumn_Click:44) |
| WK-DMF0021-0247 | G5 | txtItemId / Model / Item Id | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Item Id | 있음(FE 소스) | 1 (7) |
| WK-DMF0021-0248 | G5 | txtOwner / Owner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtOwner / Owner | 있음(FE 소스) | 0 () |
| WK-DMF0021-0249 | G5 | txtProject / Project | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtProject / Project | 있음(FE 소스) | 1 (6) |
| WK-DMF0021-0250 | H6 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL C | 있음(FE 소스) | 0 () |
| WK-DMF0021-0251 | H6 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL D | 있음(FE 소스) | 0 () |
| WK-DMF0021-0252 | H6 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL I | 있음(FE 소스) | 1 (CA-159) |
| WK-DMF0021-0253 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 9 (CC-02 99 ACT:DMF0021_SalesPlan.spdMain_C) |
| WK-DMF0021-0254 | H6 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 1 (CA-159) |
| WK-DMF0021-0255 | H6 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnColumn | 있음(FE 소스) | 0 () |
| WK-DMF0021-0256 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-0257 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 있음(FE 소스) | 0 () |
| WK-DMF0021-0258 | H6 | btnOwner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnOwner | 없음 | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-0259 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 있음(FE 소스) | 3 (CA-104 btnProject/btnItemId/btnOwner 97) |

## W6 검증 실행 (404)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0021-0260 | J2 | DMF0021 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0021 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 252 (E03 E04 E05 E07 CA-102 CA-111 CA-112 CA-) |
| WK-DMF0021-0261 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.InitControls:515:3) |
| WK-DMF0021-0262 | C1 | clbBizType / Biz.Type / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbBizType / Biz.Type / Biz Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 8 (ACT:DMF0021_SalesPlan.InitControls:452:1) |
| WK-DMF0021-0263 | C1 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 8 (ACT:DMF0021_SalesPlan.InitControls:497:2) |
| WK-DMF0021-0264 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 6 (ACT:DMF0021_SalesPlan.InitControls:431:2) |
| WK-DMF0021-0265 | C1 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.InitControls:520:3) |
| WK-DMF0021-0266 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.InitControls:511:3) |
| WK-DMF0021-0267 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 8 (ACT:DMF0021_SalesPlan.InitControls:504:3) |
| WK-DMF0021-0268 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.InitControls:439:5) |
| WK-DMF0021-0269 | C2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.clbCustomer_Select) |
| WK-DMF0021-0270 | C2 | CELL_PROD_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CELL_PROD_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0271 | C2 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0272 | C2 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 279 (119 120 121 122 ACT:DMF0021_SalesPlan.sp) |
| WK-DMF0021-0273 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 358 (CB-110 ACT:DMF0021_SalesPlan.spdMain_Com) |
| WK-DMF0021-0274 | C2 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 28 (123 124 125 126 ACT:DMF0021_SalesPlan.sp) |
| WK-DMF0021-0275 | C2 | END_CUSTOMER40 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — END_CUSTOMER40 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 21 (CC-115 127 128 129 130 ACT:DMF0021_Sales) |
| WK-DMF0021-0276 | C2 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0277 | C2 | ITEM_CLASS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_CLASS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 20 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0278 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 74 (CC-115 CC-116 115 116 117 118 ACT:DMF002) |
| WK-DMF0021-0279 | C2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 96 (E01 CC-117 CD-118 101 ACT:DMF0021_SalesP) |
| WK-DMF0021-0280 | C2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 16 (113 114 ACT:DMF0021_SalesPlan.spdMain_Co) |
| WK-DMF0021-0281 | C2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 14 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0282 | C2 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 14 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0283 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 32 (CC-116 131 132 133 134 ACT:DMF0021_Sales) |
| WK-DMF0021-0284 | C2 | TEXT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TEXT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0285 | C3 | B | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — B · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0286 | C3 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0287 | C3 | CELL_PROD_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CELL_PROD_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:DMF0021_SalesPlan.Draw:1830:88 ACT:D) |
| WK-DMF0021-0288 | C3 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0289 | C3 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 282 (119 120 121 122 ACT:DMF0021_SalesPlan.Se) |
| WK-DMF0021-0290 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 382 (CB-110 1 2 3 4 ACT:DMF0021_SalesPlan.Ins) |
| WK-DMF0021-0291 | C3 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 33 (123 124 125 126 ACT:DMF0021_SalesPlan.Se) |
| WK-DMF0021-0292 | C3 | END_CUSTOMER40 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_CUSTOMER40 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 21 (CC-115 127 128 129 130 ACT:DMF0021_Sales) |
| WK-DMF0021-0293 | C3 | GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.SetChangeControl A) |
| WK-DMF0021-0294 | C3 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (ACT:DMF0021_SalesPlan.SetSaveData ACT:DM) |
| WK-DMF0021-0295 | C3 | ITEM_CLASS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_CLASS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 22 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0296 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 97 (CC-115 CC-116 1 2 3 4 115 116 117 118 HA) |
| WK-DMF0021-0297 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 113 (E01 CC-117 CD-118 101 ACT:DMF0021_SalesP) |
| WK-DMF0021-0298 | C3 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 16 (113 114 ACT:DMF0021_SalesPlan.spdMain_Co) |
| WK-DMF0021-0299 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 42 (ACT:DMF0021_SalesPlan.Draw:1825:86 ACT:D) |
| WK-DMF0021-0300 | C3 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 16 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0301 | C3 | PROJECT_OWNER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_OWNER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0302 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 41 (CC-116 131 132 133 134 ACT:DMF0021_Sales) |
| WK-DMF0021-0303 | C3 | TEXT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TEXT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (ACT:DMF0021_SalesPlan.SetSaveData ACT:DM) |
| WK-DMF0021-0304 | C3 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:DMF0021_SalesPlan.SetSaveData ACT:DM) |
| WK-DMF0021-0305 | C6 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.clbCustomer_Select) |
| WK-DMF0021-0306 | C6 | CELL_PROD_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CELL_PROD_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0307 | C6 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0308 | C6 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 279 (119 120 121 122 ACT:DMF0021_SalesPlan.sp) |
| WK-DMF0021-0309 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 358 (CB-110 ACT:DMF0021_SalesPlan.spdMain_Com) |
| WK-DMF0021-0310 | C6 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 28 (123 124 125 126 ACT:DMF0021_SalesPlan.sp) |
| WK-DMF0021-0311 | C6 | END_CUSTOMER40 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — END_CUSTOMER40 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 21 (CC-115 127 128 129 130 ACT:DMF0021_Sales) |
| WK-DMF0021-0312 | C6 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0313 | C6 | ITEM_CLASS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_CLASS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 20 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0314 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 74 (CC-115 CC-116 115 116 117 118 ACT:DMF002) |
| WK-DMF0021-0315 | C6 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 96 (E01 CC-117 CD-118 101 ACT:DMF0021_SalesP) |
| WK-DMF0021-0316 | C6 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 16 (113 114 ACT:DMF0021_SalesPlan.spdMain_Co) |
| WK-DMF0021-0317 | C6 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 14 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0318 | C6 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 14 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0319 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 32 (CC-116 131 132 133 134 ACT:DMF0021_Sales) |
| WK-DMF0021-0320 | C6 | TEXT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TEXT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0321 | K4 | DMF0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0021 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 112 (ACT:DMF0021_SalesPlan.btnColumn_Click AC) |
| WK-DMF0021-0322 | F1 | DMF0021 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0021 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 643 (E04 CA-126 CA-127 CA-128 CA-129 CA-130 C) |
| WK-DMF0021-0323 | F3 | DMF0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — DMF0021 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 19 (E08 1 2 3 4 HANDLER:spdMain_ClipboardPas) |
| WK-DMF0021-0324 | F5 | DMF0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0021 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 8 (CE-103 Delete (F9) HANDLER:DeleteButton ) |
| WK-DMF0021-0325 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 3 (ACT:DMF0021_SalesPlan.GetBucketType:3431) |
| WK-DMF0021-0326 | F4 | DM0021_GET_SPREAD_TITLE_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0021_GET_SPREAD_TITLE_DATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (ACT:DMF0021_SalesPlan.InitSpread_X:437:8) |
| WK-DMF0021-0327 | F4 | DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0021_SAVE_DM_PLN_SALES_PLAN_ALL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 85 (ACT:DMF0021_SalesPlan.SaveData_All ACT:D) |
| WK-DMF0021-0328 | F4 | DMF0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 3 (ACT:DMF0021_SalesPlan.GetBucketType:3430) |
| WK-DMF0021-0329 | F4 | DMF0021_GET_SALES_PLAN_MEASUREINFO2 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0021_GET_SALES_PLAN_MEASUREINFO2 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 4 (ACT:DMF0021_SalesPlan.GetSALESPLAN_MEASU) |
| WK-DMF0021-0330 | F4 | PKG_DMF0021.P_DMF0021_GET_SALES_PLAN_MEA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0021.P_DMF0021_GET_SALES_PLAN_MEASUREINFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 4 (ACT:DMF0021_SalesPlan.GetSALESPLAN_MEASU) |
| WK-DMF0021-0331 | F4 | PKG_DMF0021.P_DMF0021_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0021.P_DMF0021_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 715 (ACT:DMF0021_SalesPlan.FindButton ACT:DMF) |
| WK-DMF0021-0332 | F4 | PKG_DMF0021.P_DMF0021_SAVE_DM_PLN_SALES_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0021.P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 489 (ACT:DMF0021_SalesPlan.SaveButton ACT:DMF) |
| WK-DMF0021-0333 | F4 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_BIZ_TYPE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 8 (ACT:DMF0021_SalesPlan.GetBizTypebyDivisi) |
| WK-DMF0021-0334 | F4 | SCM0001_GET_CUSTOMER_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_CUSTOMER_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 12 (ACT:DMF0021_SalesPlan.GetCustomerbyDivis) |
| WK-DMF0021-0335 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 4 (ACT:DMF0021_SalesPlan.GetDivision:3380:3) |
| WK-DMF0021-0336 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 4 (ACT:DMF0021_SalesPlan.GetItemType:3442:3) |
| WK-DMF0021-0337 | F4 | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 8 (ACT:DMF0021_SalesPlan.GetPlantSitebyEndC) |
| WK-DMF0021-0338 | F4 | SCM0001_GET_SITE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SITE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 8 (ACT:DMF0021_SalesPlan.GetScmSitebyDivisi) |
| WK-DMF0021-0339 | F4 | SCM0001_GET_TEAM_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_TEAM_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 8 (ACT:DMF0021_SalesPlan.GetTeambyDivision:) |
| WK-DMF0021-0340 | A5 | B | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — B · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0341 | A5 | C | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — C · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0342 | A5 | D | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — D · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 0 () |
| WK-DMF0021-0343 | A5 | DEPT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0344 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (CA-149 ACT:DMF0021_SalesPlan.spdMain_Com) |
| WK-DMF0021-0345 | A5 | MEASURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 11 (ACT:DMF0021_SalesPlan.InitSpread_X:533:6) |
| WK-DMF0021-0346 | A5 | N | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — N · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 0 () |
| WK-DMF0021-0347 | A5 | PLANT_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (CA-149) |
| WK-DMF0021-0348 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0349 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0350 | G4 | cboCellQty / . / Cell Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboCellQty / . / Cell Qty · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 0 () |
| WK-DMF0021-0351 | G4 | cboUnitYN / Unit YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboUnitYN / Unit YN · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0021_SalesPlan.InitControls:260:5) |
| WK-DMF0021-0352 | G4 | chkColor / Color | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkColor / Color · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0353 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0354 | G4 | clbBizType / Biz.Type / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbBizType / Biz.Type / Biz Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0355 | G4 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0356 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 12 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0357 | G4 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbItemType / Item Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0358 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0359 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0360 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0361 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 28 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0362 | G4 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0363 | G4 | txtOwner / Owner | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtOwner / Owner · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 0 () |
| WK-DMF0021-0364 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0365 | H2 | APPLICATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — APPLICATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0366 | H2 | B | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — B · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0367 | H2 | BIZ_TYPE_NAME40 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — BIZ_TYPE_NAME40 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0368 | H2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0369 | H2 | CELL_MODEL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CELL_MODEL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0370 | H2 | CELL_MODEL_INFO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CELL_MODEL_INFO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0371 | H2 | CELL_MODEL_NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CELL_MODEL_NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0372 | H2 | CELL_PER_CAR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CELL_PER_CAR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0373 | H2 | CELL_PER_MODULE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CELL_PER_MODULE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0374 | H2 | CELL_QUANTITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CELL_QUANTITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0375 | H2 | CELL_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CELL_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0376 | H2 | CITY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CITY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0377 | H2 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0378 | H2 | COUNTRY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — COUNTRY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0379 | H2 | CUST_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CUST_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0380 | H2 | CUST_GROUP_DTL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CUST_GROUP_DTL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0381 | H2 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0382 | H2 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0383 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (CA-149) |
| WK-DMF0021-0384 | H2 | DMS_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DMS_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0385 | H2 | DMS_SALES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DMS_SALES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0386 | H2 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0387 | H2 | ENERGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ENERGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0388 | H2 | ENERGE_WH | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ENERGE_WH · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0389 | H2 | FORECAST_INFOR_VERSION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FORECAST_INFOR_VERSION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0390 | H2 | FORECAST_INFO_ALL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FORECAST_INFO_ALL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0391 | H2 | FORECAST_INFO_CELL_PACK_COUNT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FORECAST_INFO_CELL_PACK_COUNT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0392 | H2 | FORECAST_INFO_PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FORECAST_INFO_PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0393 | H2 | FORECAST_INFO_SPEC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FORECAST_INFO_SPEC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0394 | H2 | GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0395 | H2 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0396 | H2 | INTERNAL_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — INTERNAL_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0397 | H2 | ITEM_CLASS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_CLASS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0398 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0399 | H2 | ITEM_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0400 | H2 | MDM_PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MDM_PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0401 | H2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (ACT:DMF0021_SalesPlan.Draw:1910:121 ACT:) |
| WK-DMF0021-0402 | H2 | MIN_CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MIN_CAPACITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0403 | H2 | MODULE_PER_CAR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MODULE_PER_CAR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0404 | H2 | OWNER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OWNER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0405 | H2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (CA-149) |
| WK-DMF0021-0406 | H2 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0407 | H2 | PROJECT_OWNER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_OWNER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0408 | H2 | ROUTE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ROUTE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0409 | H2 | SALES_COMPANY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SALES_COMPANY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0410 | H2 | SALES_PLANT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SALES_PLANT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0411 | H2 | SALES_PLAN_ADJUST_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SALES_PLAN_ADJUST_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0412 | H2 | SCP_USE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SCP_USE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0413 | H2 | TEAM_INCHARGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TEAM_INCHARGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0414 | H2 | VMI_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VMI_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0415 | H3 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — D · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0416 | H4 | DMF0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0021 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 7 (ACT:DMF0021_SalesPlan.spdMain_TopChange ) |
| WK-DMF0021-0417 | H5 | B | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — B · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0418 | H5 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — C · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0419 | H5 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DEPT_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0420 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (CA-149 ACT:DMF0021_SalesPlan.spdMain_Com) |
| WK-DMF0021-0421 | H5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 11 (ACT:DMF0021_SalesPlan.InitSpread_X:533:6) |
| WK-DMF0021-0422 | H5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_SITE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (CA-149) |
| WK-DMF0021-0423 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 35 (ACT:DMF0021_SalesPlan.SetSpreadColumn AC) |
| WK-DMF0021-0424 | H5 | chkColor / Color | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkColor / Color · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 19 (ACT:DMF0021_SalesPlan.SetSpreadColumn AC) |
| WK-DMF0021-0425 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:DMF0021_SalesPlan.SetSpreadColumn AC) |
| WK-DMF0021-0426 | H5 | drpPeriod / Period | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — drpPeriod / Period · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 17 (ACT:DMF0021_SalesPlan.InitSpread ACT:DMF) |
| WK-DMF0021-0427 | I1 | DMF0021 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0021 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 78 (CA-111 CA-112 CA-128 CA-139 CA-142 CD-11) |
| WK-DMF0021-0428 | SC1 | DMF0021 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0021 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 11 (Find (F5) Insert (F8) Delete (F9) Edit () |
| WK-DMF0021-0429 | D1 | APPLICATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — APPLICATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:765:193) |
| WK-DMF0021-0430 | D1 | BIZ_TYPE_NAME40 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — BIZ_TYPE_NAME40 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3096:118) |
| WK-DMF0021-0431 | D1 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0432 | D1 | CELL_MODEL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_MODEL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3120:130) |
| WK-DMF0021-0433 | D1 | CELL_MODEL_INFO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_MODEL_INFO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3116:128) |
| WK-DMF0021-0434 | D1 | CELL_MODEL_NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_MODEL_NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3136:138) |
| WK-DMF0021-0435 | D1 | CELL_PACK_COUNT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_PACK_COUNT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (ACT:DMF0021_SalesPlan.EditButton:773:201) |
| WK-DMF0021-0436 | D1 | CELL_PER_CAR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_PER_CAR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3148:144) |
| WK-DMF0021-0437 | D1 | CELL_PER_MODULE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_PER_MODULE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3152:146) |
| WK-DMF0021-0438 | D1 | CELL_QUANTITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_QUANTITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3168:154) |
| WK-DMF0021-0439 | D1 | CELL_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:771:199) |
| WK-DMF0021-0440 | D1 | CITY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CITY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:780:207) |
| WK-DMF0021-0441 | D1 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3076:108) |
| WK-DMF0021-0442 | D1 | COUNTRY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — COUNTRY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:778:205) |
| WK-DMF0021-0443 | D1 | CUST_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CUST_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:759:187) |
| WK-DMF0021-0444 | D1 | CUST_GROUP_DTL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CUST_GROUP_DTL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:761:189) |
| WK-DMF0021-0445 | D1 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0446 | D1 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 27 (CC-13 CC-20 CF-90 27 ACT:DMF0021_SalesPl) |
| WK-DMF0021-0447 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 53 (CA-118 CA-119 CA-149 ACT:DMF0021_SalesPl) |
| WK-DMF0021-0448 | D1 | DMS_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DMS_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3176:158) |
| WK-DMF0021-0449 | D1 | DMS_SALES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DMS_SALES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3172:156) |
| WK-DMF0021-0450 | D1 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0451 | D1 | ENERGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ENERGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3160:150) |
| WK-DMF0021-0452 | D1 | ENERGE_WH | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ENERGE_WH · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3164:152) |
| WK-DMF0021-0453 | D1 | FORECAST_INFOR_VERSION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FORECAST_INFOR_VERSION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3132:136) |
| WK-DMF0021-0454 | D1 | FORECAST_INFO_ALL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FORECAST_INFO_ALL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3124:132) |
| WK-DMF0021-0455 | D1 | FORECAST_INFO_CELL_MODEL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FORECAST_INFO_CELL_MODEL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.EditButton:782:209) |
| WK-DMF0021-0456 | D1 | FORECAST_INFO_CELL_PACK_COUNT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FORECAST_INFO_CELL_PACK_COUNT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3112:126) |
| WK-DMF0021-0457 | D1 | FORECAST_INFO_PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FORECAST_INFO_PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:784:211) |
| WK-DMF0021-0458 | D1 | FORECAST_INFO_SPEC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FORECAST_INFO_SPEC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:786:213) |
| WK-DMF0021-0459 | D1 | GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3100:120) |
| WK-DMF0021-0460 | D1 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 8 (CC-07 CC-19 ACT:DMF0021_SalesPlan.EditBu) |
| WK-DMF0021-0461 | D1 | INTERNAL_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — INTERNAL_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:769:197) |
| WK-DMF0021-0462 | D1 | ITEM_CLASS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_CLASS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:745:175) |
| WK-DMF0021-0463 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0464 | D1 | ITEM_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:747:177) |
| WK-DMF0021-0465 | D1 | MDM_PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MDM_PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:788:215) |
| WK-DMF0021-0466 | D1 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 54 (CA-118 CA-155 CA-156 CA-157 CB-103 CB-10) |
| WK-DMF0021-0467 | D1 | MEASURE_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.EditButton:790:217) |
| WK-DMF0021-0468 | D1 | MIN_CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MIN_CAPACITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:792:219) |
| WK-DMF0021-0469 | D1 | MODULE_PER_CAR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MODULE_PER_CAR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3156:148) |
| WK-DMF0021-0470 | D1 | OWNER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OWNER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:763:191) |
| WK-DMF0021-0471 | D1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 12 (CA-111 CA-112 CA-149 CF-85 CF-86 113 114) |
| WK-DMF0021-0472 | D1 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.EditButton:599:126) |
| WK-DMF0021-0473 | D1 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:737:167) |
| WK-DMF0021-0474 | D1 | PROJECT_OWNER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_OWNER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:741:171) |
| WK-DMF0021-0475 | D1 | ROUTE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ROUTE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:767:195) |
| WK-DMF0021-0476 | D1 | SALES_COMPANY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SALES_COMPANY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3007:68) |
| WK-DMF0021-0477 | D1 | SALES_PLANT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SALES_PLANT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3009:70) |
| WK-DMF0021-0478 | D1 | SALES_PLAN_ADJUST_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SALES_PLAN_ADJUST_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (ACT:DMF0021_SalesPlan.EditButton:963:77 ) |
| WK-DMF0021-0479 | D1 | SCP_USE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SCP_USE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3184:160) |
| WK-DMF0021-0480 | D1 | TEAM_INCHARGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TEAM_INCHARGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:735:165) |
| WK-DMF0021-0481 | D1 | VMI_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VMI_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:794:221) |
| WK-DMF0021-0482 | D3 | APPLICATION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — APPLICATION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:765:193) |
| WK-DMF0021-0483 | D3 | BIZ_TYPE_NAME40 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — BIZ_TYPE_NAME40 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3096:118) |
| WK-DMF0021-0484 | D3 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — C · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0485 | D3 | CELL_MODEL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_MODEL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3120:130) |
| WK-DMF0021-0486 | D3 | CELL_MODEL_INFO | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_MODEL_INFO · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3116:128) |
| WK-DMF0021-0487 | D3 | CELL_MODEL_NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_MODEL_NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3136:138) |
| WK-DMF0021-0488 | D3 | CELL_PACK_COUNT | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_PACK_COUNT · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (ACT:DMF0021_SalesPlan.EditButton:773:201) |
| WK-DMF0021-0489 | D3 | CELL_PER_CAR | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_PER_CAR · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3148:144) |
| WK-DMF0021-0490 | D3 | CELL_PER_MODULE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_PER_MODULE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3152:146) |
| WK-DMF0021-0491 | D3 | CELL_QUANTITY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_QUANTITY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3168:154) |
| WK-DMF0021-0492 | D3 | CELL_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:771:199) |
| WK-DMF0021-0493 | D3 | CITY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CITY_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:780:207) |
| WK-DMF0021-0494 | D3 | COMPANY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — COMPANY_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3076:108) |
| WK-DMF0021-0495 | D3 | COUNTRY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — COUNTRY_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:778:205) |
| WK-DMF0021-0496 | D3 | CUST_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CUST_GROUP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:759:187) |
| WK-DMF0021-0497 | D3 | CUST_GROUP_DTL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CUST_GROUP_DTL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:761:189) |
| WK-DMF0021-0498 | D3 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — D · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0499 | D3 | DEPT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DEPT_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 27 (CC-13 CC-20 CF-90 27 ACT:DMF0021_SalesPl) |
| WK-DMF0021-0500 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 53 (CA-118 CA-119 CA-149 ACT:DMF0021_SalesPl) |
| WK-DMF0021-0501 | D3 | DMS_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DMS_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3176:158) |
| WK-DMF0021-0502 | D3 | DMS_SALES | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DMS_SALES · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3172:156) |
| WK-DMF0021-0503 | D3 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0504 | D3 | ENERGE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ENERGE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3160:150) |
| WK-DMF0021-0505 | D3 | ENERGE_WH | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ENERGE_WH · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3164:152) |
| WK-DMF0021-0506 | D3 | FORECAST_INFOR_VERSION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FORECAST_INFOR_VERSION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3132:136) |
| WK-DMF0021-0507 | D3 | FORECAST_INFO_ALL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FORECAST_INFO_ALL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3124:132) |
| WK-DMF0021-0508 | D3 | FORECAST_INFO_CELL_MODEL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FORECAST_INFO_CELL_MODEL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.EditButton:782:209) |
| WK-DMF0021-0509 | D3 | FORECAST_INFO_CELL_PACK_COUNT | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FORECAST_INFO_CELL_PACK_COUNT · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: tra |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3112:126) |
| WK-DMF0021-0510 | D3 | FORECAST_INFO_PRODUCT_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FORECAST_INFO_PRODUCT_GROUP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:784:211) |
| WK-DMF0021-0511 | D3 | FORECAST_INFO_SPEC | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FORECAST_INFO_SPEC · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:786:213) |
| WK-DMF0021-0512 | D3 | GROUP_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — GROUP_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3100:120) |
| WK-DMF0021-0513 | D3 | INCOTERMS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — INCOTERMS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 8 (CC-07 CC-19 ACT:DMF0021_SalesPlan.EditBu) |
| WK-DMF0021-0514 | D3 | INTERNAL_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — INTERNAL_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:769:197) |
| WK-DMF0021-0515 | D3 | ITEM_CLASS_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_CLASS_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:745:175) |
| WK-DMF0021-0516 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0517 | D3 | ITEM_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:747:177) |
| WK-DMF0021-0518 | D3 | MDM_PROJECT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MDM_PROJECT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:788:215) |
| WK-DMF0021-0519 | D3 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 54 (CA-118 CA-155 CA-156 CA-157 CB-103 CB-10) |
| WK-DMF0021-0520 | D3 | MEASURE_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE_GROUP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.EditButton:790:217) |
| WK-DMF0021-0521 | D3 | MIN_CAPACITY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MIN_CAPACITY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:792:219) |
| WK-DMF0021-0522 | D3 | MODULE_PER_CAR | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MODULE_PER_CAR · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3156:148) |
| WK-DMF0021-0523 | D3 | OWNER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OWNER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:763:191) |
| WK-DMF0021-0524 | D3 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 12 (CA-111 CA-112 CA-149 CF-85 CF-86 113 114) |
| WK-DMF0021-0525 | D3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.EditButton:599:126) |
| WK-DMF0021-0526 | D3 | PROJECT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:737:167) |
| WK-DMF0021-0527 | D3 | PROJECT_OWNER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_OWNER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:741:171) |
| WK-DMF0021-0528 | D3 | ROUTE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ROUTE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:767:195) |
| WK-DMF0021-0529 | D3 | SALES_COMPANY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SALES_COMPANY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3007:68) |
| WK-DMF0021-0530 | D3 | SALES_PLANT | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SALES_PLANT · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3009:70) |
| WK-DMF0021-0531 | D3 | SALES_PLAN_ADJUST_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SALES_PLAN_ADJUST_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (ACT:DMF0021_SalesPlan.EditButton:963:77 ) |
| WK-DMF0021-0532 | D3 | SCP_USE_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCP_USE_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.InsertRow:3184:160) |
| WK-DMF0021-0533 | D3 | TEAM_INCHARGE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TEAM_INCHARGE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:735:165) |
| WK-DMF0021-0534 | D3 | VMI_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VMI_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.EditButton:794:221) |
| WK-DMF0021-0535 | D4 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — I · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (CA-159) |
| WK-DMF0021-0536 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 8 (93 94 95 96 115 116 117 118) |
| WK-DMF0021-0537 | D4 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 4 (CC-104 CF-75 CF-78 CF-81) |
| WK-DMF0021-0538 | D4 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (113 114) |
| WK-DMF0021-0539 | D4 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (CA-159) |
| WK-DMF0021-0540 | D5 | B | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — B · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 8 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0541 | D5 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0542 | D5 | CELL_PROD_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CELL_PROD_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (CELL_PROD_SITE_ID ACT:DMF0021_SalesPlan.) |
| WK-DMF0021-0543 | D5 | CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.InsertRow:3035:84 ) |
| WK-DMF0021-0544 | D5 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0545 | D5 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 16 (ACT:DMF0021_SalesPlan.InsertRow:2925:25 ) |
| WK-DMF0021-0546 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 26 (1 2 3 4 ACT:DMF0021_SalesPlan.spdMain_Co) |
| WK-DMF0021-0547 | D5 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 9 (123 124 125 126 ACT:DMF0021_SalesPlan.In) |
| WK-DMF0021-0548 | D5 | END_CUSTOMER40 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — END_CUSTOMER40 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.InsertRow:1688:227) |
| WK-DMF0021-0549 | D5 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0550 | D5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (1 2 3 4 ACT:DMF0021_SalesPlan.spdMain_Cl) |
| WK-DMF0021-0551 | D5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 12 (ACT:DMF0021_SalesPlan.InsertRow:2960:42 ) |
| WK-DMF0021-0552 | D5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0553 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 10 (ACT:DMF0021_SalesPlan.InsertRow:2954:40 ) |
| WK-DMF0021-0554 | D6 | DMF0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0021 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 45 (E05 CA-146 CA-147 CA-159 CB-106 CC-104 C) |
| WK-DMF0021-0555 | E1 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0556 | E1 | CELL_PROD_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — CELL_PROD_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.spdMain_ClipboardP) |
| WK-DMF0021-0557 | E1 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0558 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 7 (1 2 3 4 ACT:DMF0021_SalesPlan.spdMain_Cl) |
| WK-DMF0021-0559 | E1 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.spdMain_ClipboardP) |
| WK-DMF0021-0560 | E1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 16 (1 2 3 4 HANDLER:spdMain_ClipboardPasted ) |
| WK-DMF0021-0561 | E1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.spdMain_ClipboardP) |
| WK-DMF0021-0562 | E3 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E3 실행 — D · 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요 |  | 0 () |
| WK-DMF0021-0563 | E4 | B | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — B · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0564 | E4 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — C · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0565 | E4 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — D · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-DMF0021-0566 | E4 | DEPT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DEPT_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 9 (27 86 119 120 121 122 ACT:DMF0021_SalesP) |
| WK-DMF0021-0567 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 27 (1 2 3 4 ACT:DMF0021_SalesPlan.EditButton) |
| WK-DMF0021-0568 | E4 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (CA-131 123 124 125 126 ACT:DMF0021_Sales) |
| WK-DMF0021-0569 | E4 | END_CUSTOMER40 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — END_CUSTOMER40 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (72 127 128 129 130) |
| WK-DMF0021-0570 | E4 | GROUP_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — GROUP_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0021_SalesPlan.SetChangeControl A) |
| WK-DMF0021-0571 | E4 | INCOTERMS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — INCOTERMS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (CA-136 ACT:DMF0021_SalesPlan.SetSaveData) |
| WK-DMF0021-0572 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 18 (1 2 3 4 93 94 95 96 99 115 116 117) |
| WK-DMF0021-0573 | E4 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 17 (87 101 ACT:DMF0021_SalesPlan.SetSaveData) |
| WK-DMF0021-0574 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 9 (CA-139 70 74 75 76 84 ACT:DMF0021_SalesP) |
| WK-DMF0021-0575 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (38 ACT:DMF0021_SalesPlan.ExportExcel:144) |
| WK-DMF0021-0576 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (84 ACT:DMF0021_SalesPlan.SaveData:2826:3) |
| WK-DMF0021-0577 | E4 | MSG00043 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00043 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (71 ACT:DMF0021_SalesPlan.SaveData:1493:3) |
| WK-DMF0021-0578 | E4 | MSG00085 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00085 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (CA-142 78 ACT:DMF0021_SalesPlan.SaveData) |
| WK-DMF0021-0579 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (42 ACT:DMF0021_SalesPlan.FindData:1530:3) |
| WK-DMF0021-0580 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (CD-119 40 ACT:DMF0021_SalesPlan.FindData) |
| WK-DMF0021-0581 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (10) |
| WK-DMF0021-0582 | E4 | MSG00113 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00113 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 18 (CA-111 CA-112 CA-128 CG-01 CG-02 31 32 5) |
| WK-DMF0021-0583 | E4 | MSG00137 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00137 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (39 45 ACT:DMF0021_SalesPlan.FindData:841) |
| WK-DMF0021-0584 | E4 | MSG00146 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00146 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (CD-137 79 ACT:DMF0021_SalesPlan.SaveData) |
| WK-DMF0021-0585 | E4 | MSG00164 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00164 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (CD-120 41 ACT:DMF0021_SalesPlan.FindData) |
| WK-DMF0021-0586 | E4 | MSG00227 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00227 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (CD-130 140 141 ACT:DMF0021_SalesPlan.cbo) |
| WK-DMF0021-0587 | E4 | MSG00361 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00361 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (CD-123 35 ACT:DMF0021_SalesPlan.EditButt) |
| WK-DMF0021-0588 | E4 | MSG00428 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00428 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (80) |
| WK-DMF0021-0589 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (CA-139 28 70 74 ACT:DMF0021_SalesPlan.Ed) |
| WK-DMF0021-0590 | E4 | MSG00670 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00670 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (CD-137 79) |
| WK-DMF0021-0591 | E4 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (CA-111 CA-112 CA-127 113 114) |
| WK-DMF0021-0592 | E4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:DMF0021_SalesPlan.EditButton:622:129) |
| WK-DMF0021-0593 | E4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 11 (131 132 133 134 ACT:DMF0021_SalesPlan.Se) |
| WK-DMF0021-0594 | E4 | TEXT | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TEXT · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0021_SalesPlan.SetSaveData ACT:DM) |
| WK-DMF0021-0595 | E4 | YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:DMF0021_SalesPlan.SetSaveData ACT:DM) |
| WK-DMF0021-0596 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 37 (ACT:DMF0021_SalesPlan.EditButton:1113:12) |
| WK-DMF0021-0597 | E4 | chkColor / Color | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkColor / Color · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 19 (ACT:DMF0021_SalesPlan.SetSpreadColumn AC) |
| WK-DMF0021-0598 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:DMF0021_SalesPlan.SetSpreadColumn AC) |
| WK-DMF0021-0599 | E4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 10 (ACT:DMF0021_SalesPlan.EditButton:730:4 A) |
| WK-DMF0021-0600 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0021_SalesPlan.FindData:1498:10 A) |
| WK-DMF0021-0601 | E4 | txtItemId / Model / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtItemId / Model / Item Id · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — |  | 1 (7) |
| WK-DMF0021-0602 | E4 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 1 (6) |
| WK-DMF0021-0603 | A10 | DMF0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0021 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 258 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0604 | A6 | PKG_DMF0021.P_DMF0021_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0021.P_DMF0021_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 226 (ACT:DMF0021_SalesPlan.FindButton ACT:DMF) |
| WK-DMF0021-0605 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 28 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0606 | G1 | cboCellQty / . / Cell Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboCellQty / . / Cell Qty · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 0 () |
| WK-DMF0021-0607 | G1 | cboUnitYN / Unit YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboUnitYN / Unit YN · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (ACT:DMF0021_SalesPlan.FindData:931:150) |
| WK-DMF0021-0608 | G1 | chkColor / Color | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkColor / Color · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 0 () |
| WK-DMF0021-0609 | G1 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkSum / Sum · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 0 () |
| WK-DMF0021-0610 | G1 | clbBizType / Biz.Type / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbBizType / Biz.Type / Biz Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0611 | G1 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0612 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0613 | G1 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbItemType / Item Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0614 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0615 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0616 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0617 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 22 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0618 | G1 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0619 | G1 | txtOwner / Owner | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtOwner / Owner · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0620 | G1 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0021_SalesPlan.FindData ACT:DMF00) |
| WK-DMF0021-0621 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0622 | G6 | cboCellQty / . / Cell Qty | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboCellQty / . / Cell Qty · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0623 | G6 | cboUnitYN / Unit YN | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboUnitYN / Unit YN · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.InitControls:260:5) |
| WK-DMF0021-0624 | G6 | chkColor / Color | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkColor / Color · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0625 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0626 | G6 | clbBizType / Biz.Type / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbBizType / Biz.Type / Biz Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0627 | G6 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0628 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 10 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0629 | G6 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0630 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0631 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0632 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:DMF0021_SalesPlan.InitControls ACT:D) |
| WK-DMF0021-0633 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 26 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0634 | G6 | txtItemId / Model / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0635 | G6 | txtOwner / Owner | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtOwner / Owner · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0636 | G6 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0021_SalesPlan.DefineProperty ACT) |
| WK-DMF0021-0637 | X-REOPEN | DMF0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0021 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 50 (ACT:DMF0021_SalesPlan.Dispose ACT:DMF002) |
| WK-DMF0021-0638 | H6 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 10 (ACT:DMF0021_SalesPlan.btnColumn_Click:44) |
| WK-DMF0021-0639 | H6 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (7) |
| WK-DMF0021-0640 | H6 | txtOwner / Owner | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtOwner / Owner · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 0 () |
| WK-DMF0021-0641 | H6 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtProject / Project · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (6) |
| WK-DMF0021-0642 | M4 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — C · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0643 | M4 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — D · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0644 | M4 | DEPT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DEPT_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 7 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0645 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0646 | M4 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0647 | M4 | END_CUSTOMER40 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — END_CUSTOMER40 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0648 | M4 | I | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — I · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (CA-159) |
| WK-DMF0021-0649 | M4 | ITEM_CLASS_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_CLASS_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0650 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 9 (CC-02 99 ACT:DMF0021_SalesPlan.spdMain_C) |
| WK-DMF0021-0651 | M4 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0652 | M4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 75 (CA-159 ACT:DMF0021_SalesPlan.spdMain_Cel) |
| WK-DMF0021-0653 | M4 | PROJECT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0654 | M4 | PROJECT_OWNER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_OWNER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0655 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 11 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-0656 | M4 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0657 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-0658 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0659 | M4 | btnOwner | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnOwner · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-0660 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (CA-104 btnProject/btnItemId/btnOwner 97) |
| WK-DMF0021-0661 | M4 | txtItemId / Model / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Item Id · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (7) |
| WK-DMF0021-0662 | M4 | txtOwner / Owner | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtOwner / Owner · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-DMF0021-0663 | M4 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (6) |

## W7 기대값 확정 (1328)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0021-0664 | C1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 10: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0665 | C1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 11: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0666 | C1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 12: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0667 | C1 | 138 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 138: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (138) |
| WK-DMF0021-0668 | C1 | 139 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 139: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (139) |
| WK-DMF0021-0669 | C1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 3: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0670 | C1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 4: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0671 | C1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 5: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0672 | C1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 6: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0673 | C1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 8: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0674 | C1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 9: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0675 | C1 | CA-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — CA-102: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (CA-102) |
| WK-DMF0021-0676 | C1 | CA-103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — CA-103: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (CA-103) |
| WK-DMF0021-0677 | C1 | HANDLER:cboBucketType_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:cboBucketType_SelectedIndexChanged: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboBucketType_SelectedIndexChang) |
| WK-DMF0021-0678 | C1 | HANDLER:chkSum_CheckedChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:chkSum_CheckedChanged: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:chkSum_CheckedChanged) |
| WK-DMF0021-0679 | C1 | HANDLER:clbCustomer_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbCustomer_SelectedIndexChanged: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbCustomer_SelectedIndexChanged) |
| WK-DMF0021-0680 | C1 | HANDLER:clbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbDivision_SelectedIndexChanged: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbDivision_SelectedIndexChanged) |
| WK-DMF0021-0681 | C1 | HANDLER:clbTeam_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbTeam_SelectedIndexChanged: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbTeam_SelectedIndexChanged) |
| WK-DMF0021-0682 | C2 | 102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 102: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0683 | C2 | 103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 103: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0684 | C2 | 104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 104: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0685 | C2 | 117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 117: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0686 | C2 | 118 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 118: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0687 | C2 | 119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 119: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0688 | C2 | 120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 120: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0689 | C2 | 135 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 135: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (135) |
| WK-DMF0021-0690 | C2 | 136 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 136: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (136) |
| WK-DMF0021-0691 | C2 | 137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 137: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (137) |
| WK-DMF0021-0692 | C2 | 95 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 95: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0693 | C2 | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 98: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0694 | C2 | CC-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CC-106: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CC-106) |
| WK-DMF0021-0695 | C2 | CC-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CC-107: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CC-107) |
| WK-DMF0021-0696 | C2 | CE-104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CE-104: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CE-104) |
| WK-DMF0021-0697 | C2 | CE-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CE-105: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CE-105) |
| WK-DMF0021-0698 | C2 | DMF0021_SalesPlan.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.Dsdm_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:DMF0021_SalesPlan.Dsdm_Changed:3961:) |
| WK-DMF0021-0699 | C2 | DMF0021_SalesPlan.cboBucketType_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.cboBucketType_SelectedIndexChang: 진입점 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0021_SalesPlan.cboBucketType_Sele) |
| WK-DMF0021-0700 | C2 | DMF0021_SalesPlan.cboKRW_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.cboKRW_SelectedIndexChanged: 진입점 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.cboKRW_SelectedInd) |
| WK-DMF0021-0701 | C2 | DMF0021_SalesPlan.cboLOC_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.cboLOC_SelectedIndexChanged: 진입점 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.cboLOC_SelectedInd) |
| WK-DMF0021-0702 | C2 | DMF0021_SalesPlan.cboUSD_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.cboUSD_SelectedIndexChanged: 진입점 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.cboUSD_SelectedInd) |
| WK-DMF0021-0703 | C2 | DMF0021_SalesPlan.chkColor_CheckedChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.chkColor_CheckedChanged: 진입점 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.chkColor_CheckedCh) |
| WK-DMF0021-0704 | C2 | DMF0021_SalesPlan.chkSum_CheckedChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.chkSum_CheckedChanged: 진입점 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.chkSum_CheckedChan) |
| WK-DMF0021-0705 | C2 | DMF0021_SalesPlan.clbCustomer_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.clbCustomer_SelectedIndexChanged: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.clbCustomer_Select) |
| WK-DMF0021-0706 | C2 | DMF0021_SalesPlan.clbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.clbDivision_SelectedIndexChanged: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 49 (ACT:DMF0021_SalesPlan.clbDivision_Select) |
| WK-DMF0021-0707 | C2 | DMF0021_SalesPlan.clbTeam_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.clbTeam_SelectedIndexChanged: 진입점 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 16 (ACT:DMF0021_SalesPlan.clbTeam_SelectedIn) |
| WK-DMF0021-0708 | C2 | DMF0021_SalesPlan.spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0021_SalesPlan.spdMain_ComboSelChange: 진입점 집계 — C2 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0709 | C2 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — E06: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0021-0710 | C2 | HANDLER:Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — HANDLER:Dsdm_Changed: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:Dsdm_Changed) |
| WK-DMF0021-0711 | C2 | HANDLER:spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — HANDLER:spdMain_ComboSelChange: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_ComboSelChange) |
| WK-DMF0021-0712 | C2 | HANDLER:spdMain_LeaveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — HANDLER:spdMain_LeaveCell: 행 집계 — C2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_LeaveCell) |
| WK-DMF0021-0713 | C3 | 102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 102: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0714 | C3 | 103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 103: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0715 | C3 | 104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 104: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0716 | C3 | 117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 117: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0717 | C3 | 118 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 118: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0718 | C3 | 119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 119: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0719 | C3 | 120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 120: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0720 | C3 | 135 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 135: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (135) |
| WK-DMF0021-0721 | C3 | 136 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 136: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (136) |
| WK-DMF0021-0722 | C3 | 137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 137: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (137) |
| WK-DMF0021-0723 | C3 | 95 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 95: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0724 | C3 | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 98: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0725 | C3 | CC-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — CC-106: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (CC-106) |
| WK-DMF0021-0726 | C3 | CC-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — CC-107: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (CC-107) |
| WK-DMF0021-0727 | C3 | CE-104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — CE-104: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (CE-104) |
| WK-DMF0021-0728 | C3 | CE-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — CE-105: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (CE-105) |
| WK-DMF0021-0729 | C3 | DMF0021_SalesPlan.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.Dsdm_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:DMF0021_SalesPlan.Dsdm_Changed:3961:) |
| WK-DMF0021-0730 | C3 | DMF0021_SalesPlan.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.SetChangeControl: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.SetChangeControl:3) |
| WK-DMF0021-0731 | C3 | DMF0021_SalesPlan.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.SetSaveData: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 22 (ACT:DMF0021_SalesPlan.SetSaveData:4150:6) |
| WK-DMF0021-0732 | C3 | DMF0021_SalesPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.SetSpreadColumn: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-0733 | C3 | DMF0021_SalesPlan.SetSpreadHeaderSpan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.SetSpreadHeaderSpan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 101 (ACT:DMF0021_SalesPlan.SetSpreadHeaderSpa) |
| WK-DMF0021-0734 | C3 | DMF0021_SalesPlan.cboBucketType_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.cboBucketType_SelectedIndexChang: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0021_SalesPlan.cboBucketType_Sele) |
| WK-DMF0021-0735 | C3 | DMF0021_SalesPlan.cboKRW_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.cboKRW_SelectedIndexChanged: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.cboKRW_SelectedInd) |
| WK-DMF0021-0736 | C3 | DMF0021_SalesPlan.cboLOC_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.cboLOC_SelectedIndexChanged: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.cboLOC_SelectedInd) |
| WK-DMF0021-0737 | C3 | DMF0021_SalesPlan.cboUSD_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.cboUSD_SelectedIndexChanged: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.cboUSD_SelectedInd) |
| WK-DMF0021-0738 | C3 | DMF0021_SalesPlan.chkColor_CheckedChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.chkColor_CheckedChanged: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.chkColor_CheckedCh) |
| WK-DMF0021-0739 | C3 | DMF0021_SalesPlan.chkSum_CheckedChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.chkSum_CheckedChanged: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.chkSum_CheckedChan) |
| WK-DMF0021-0740 | C3 | DMF0021_SalesPlan.clbCustomer_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.clbCustomer_SelectedIndexChanged: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.clbCustomer_Select) |
| WK-DMF0021-0741 | C3 | DMF0021_SalesPlan.clbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.clbDivision_SelectedIndexChanged: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 49 (ACT:DMF0021_SalesPlan.clbDivision_Select) |
| WK-DMF0021-0742 | C3 | DMF0021_SalesPlan.clbTeam_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.clbTeam_SelectedIndexChanged: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 16 (ACT:DMF0021_SalesPlan.clbTeam_SelectedIn) |
| WK-DMF0021-0743 | C3 | DMF0021_SalesPlan.spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0021_SalesPlan.spdMain_ComboSelChange: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0744 | C3 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — E06: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0021-0745 | C3 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — E08: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0021-0746 | C3 | HANDLER:Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — HANDLER:Dsdm_Changed: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:Dsdm_Changed) |
| WK-DMF0021-0747 | C3 | HANDLER:spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — HANDLER:spdMain_ComboSelChange: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_ComboSelChange) |
| WK-DMF0021-0748 | C3 | HANDLER:spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — HANDLER:spdMain_KeyUp: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_KeyUp) |
| WK-DMF0021-0749 | C3 | HANDLER:spdMain_LeaveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — HANDLER:spdMain_LeaveCell: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_LeaveCell) |
| WK-DMF0021-0750 | C6 | 102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 102: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0751 | C6 | 103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 103: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0752 | C6 | 104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 104: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0753 | C6 | 117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 117: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0754 | C6 | 118 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 118: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0755 | C6 | 119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 119: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0756 | C6 | 120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 120: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0757 | C6 | 135 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 135: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (135) |
| WK-DMF0021-0758 | C6 | 136 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 136: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (136) |
| WK-DMF0021-0759 | C6 | 137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 137: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (137) |
| WK-DMF0021-0760 | C6 | 95 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 95: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0761 | C6 | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 98: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0762 | C6 | CC-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — CC-106: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CC-106) |
| WK-DMF0021-0763 | C6 | CC-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — CC-107: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CC-107) |
| WK-DMF0021-0764 | C6 | CE-104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — CE-104: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CE-104) |
| WK-DMF0021-0765 | C6 | CE-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — CE-105: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CE-105) |
| WK-DMF0021-0766 | C6 | DMF0021_SalesPlan.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.Dsdm_Changed: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:DMF0021_SalesPlan.Dsdm_Changed:3961:) |
| WK-DMF0021-0767 | C6 | DMF0021_SalesPlan.cboBucketType_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.cboBucketType_SelectedIndexChang: 진입점 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0021_SalesPlan.cboBucketType_Sele) |
| WK-DMF0021-0768 | C6 | DMF0021_SalesPlan.cboKRW_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.cboKRW_SelectedIndexChanged: 진입점 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.cboKRW_SelectedInd) |
| WK-DMF0021-0769 | C6 | DMF0021_SalesPlan.cboLOC_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.cboLOC_SelectedIndexChanged: 진입점 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.cboLOC_SelectedInd) |
| WK-DMF0021-0770 | C6 | DMF0021_SalesPlan.cboUSD_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.cboUSD_SelectedIndexChanged: 진입점 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.cboUSD_SelectedInd) |
| WK-DMF0021-0771 | C6 | DMF0021_SalesPlan.chkColor_CheckedChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.chkColor_CheckedChanged: 진입점 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.chkColor_CheckedCh) |
| WK-DMF0021-0772 | C6 | DMF0021_SalesPlan.chkSum_CheckedChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.chkSum_CheckedChanged: 진입점 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.chkSum_CheckedChan) |
| WK-DMF0021-0773 | C6 | DMF0021_SalesPlan.clbCustomer_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.clbCustomer_SelectedIndexChanged: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.clbCustomer_Select) |
| WK-DMF0021-0774 | C6 | DMF0021_SalesPlan.clbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.clbDivision_SelectedIndexChanged: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 49 (ACT:DMF0021_SalesPlan.clbDivision_Select) |
| WK-DMF0021-0775 | C6 | DMF0021_SalesPlan.clbTeam_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.clbTeam_SelectedIndexChanged: 진입점 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 16 (ACT:DMF0021_SalesPlan.clbTeam_SelectedIn) |
| WK-DMF0021-0776 | C6 | DMF0021_SalesPlan.spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0021_SalesPlan.spdMain_ComboSelChange: 진입점 집계 — C6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-0777 | C6 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — E06: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0021-0778 | C6 | HANDLER:Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — HANDLER:Dsdm_Changed: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:Dsdm_Changed) |
| WK-DMF0021-0779 | C6 | HANDLER:spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — HANDLER:spdMain_ComboSelChange: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_ComboSelChange) |
| WK-DMF0021-0780 | C6 | HANDLER:spdMain_LeaveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — HANDLER:spdMain_LeaveCell: 행 집계 — C6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_LeaveCell) |
| WK-DMF0021-0781 | B1 | AsIncotermsEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — AsIncotermsEdit: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (AsIncotermsEdit) |
| WK-DMF0021-0782 | B1 | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — BizTypeByDivision: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (BizTypeByDivision) |
| WK-DMF0021-0783 | B1 | CC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — CC-04: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (CC-04) |
| WK-DMF0021-0784 | B1 | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — CurrencyList: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (CurrencyList) |
| WK-DMF0021-0785 | B1 | CustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — CustomsHandbook: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (CustomsHandbook) |
| WK-DMF0021-0786 | B1 | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — Division: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (Division) |
| WK-DMF0021-0787 | B1 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — E06: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0021-0788 | B1 | EndCustomerByDivisionDept | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — EndCustomerByDivisionDept: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (EndCustomerByDivisionDept) |
| WK-DMF0021-0789 | B1 | FromSiteByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — FromSiteByDivision: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (FromSiteByDivision) |
| WK-DMF0021-0790 | B1 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — Measure: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-DMF0021-0791 | B1 | SalesPlanItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — SalesPlanItemId: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (SalesPlanItemId) |
| WK-DMF0021-0792 | B1 | SiteByEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — SiteByEndCustomer: 행 집계 — B1 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (SiteByEndCustomer) |
| WK-DMF0021-0793 | B2 | AsIncotermsEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — AsIncotermsEdit: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (AsIncotermsEdit) |
| WK-DMF0021-0794 | B2 | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — BizTypeByDivision: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (BizTypeByDivision) |
| WK-DMF0021-0795 | B2 | CC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — CC-04: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (CC-04) |
| WK-DMF0021-0796 | B2 | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — CurrencyList: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (CurrencyList) |
| WK-DMF0021-0797 | B2 | CustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — CustomsHandbook: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (CustomsHandbook) |
| WK-DMF0021-0798 | B2 | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — Division: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (Division) |
| WK-DMF0021-0799 | B2 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — E06: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0021-0800 | B2 | EndCustomerByDivisionDept | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — EndCustomerByDivisionDept: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (EndCustomerByDivisionDept) |
| WK-DMF0021-0801 | B2 | FromSiteByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — FromSiteByDivision: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (FromSiteByDivision) |
| WK-DMF0021-0802 | B2 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — Measure: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-DMF0021-0803 | B2 | SalesPlanItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — SalesPlanItemId: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (SalesPlanItemId) |
| WK-DMF0021-0804 | B2 | SiteByEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — SiteByEndCustomer: 행 집계 — B2 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (SiteByEndCustomer) |
| WK-DMF0021-0805 | B3 | 139 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 139: 행 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 1 (139) |
| WK-DMF0021-0806 | B3 | DMF0021_SalesPlan.GetBizTypebyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetBizTypebyDivision: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0021_SalesPlan.GetBizTypebyDivisi) |
| WK-DMF0021-0807 | B3 | DMF0021_SalesPlan.GetBizTypebyDivisionAs | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetBizTypebyDivisionAsync: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0021_SalesPlan.GetBizTypebyDivisi) |
| WK-DMF0021-0808 | B3 | DMF0021_SalesPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetBucketType: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.GetBucketType:3426) |
| WK-DMF0021-0809 | B3 | DMF0021_SalesPlan.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetCellColor: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetCellColor:4319:) |
| WK-DMF0021-0810 | B3 | DMF0021_SalesPlan.GetCustomerbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetCustomerbyDivision: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetCustomerbyDivis) |
| WK-DMF0021-0811 | B3 | DMF0021_SalesPlan.GetCustomerbyDivisionA | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetCustomerbyDivisionAsync: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetCustomerbyDivis) |
| WK-DMF0021-0812 | B3 | DMF0021_SalesPlan.GetCustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetCustomsHandbook: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetCustomsHandbook) |
| WK-DMF0021-0813 | B3 | DMF0021_SalesPlan.GetDataTableMeargeForD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetDataTableMeargeForDate: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 46 (ACT:DMF0021_SalesPlan.GetDataTableMearge) |
| WK-DMF0021-0814 | B3 | DMF0021_SalesPlan.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetDayRange: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetDayRange:3406:1) |
| WK-DMF0021-0815 | B3 | DMF0021_SalesPlan.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetDivision: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.GetDivision:3376:1) |
| WK-DMF0021-0816 | B3 | DMF0021_SalesPlan.GetEndCustomerbyDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetEndCustomerbyDivision: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetEndCustomerbyDi) |
| WK-DMF0021-0817 | B3 | DMF0021_SalesPlan.GetFcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetFcstType: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetFcstType:5581:1) |
| WK-DMF0021-0818 | B3 | DMF0021_SalesPlan.GetIncotermsType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetIncotermsType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetIncotermsType:5) |
| WK-DMF0021-0819 | B3 | DMF0021_SalesPlan.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetItemType: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0021_SalesPlan.GetItemType:3438:1) |
| WK-DMF0021-0820 | B3 | DMF0021_SalesPlan.GetLookupValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetLookupValues: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetLookupValues:56) |
| WK-DMF0021-0821 | B3 | DMF0021_SalesPlan.GetPlantSitebyEndCusto | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetPlantSitebyEndCustomer: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetPlantSitebyEndC) |
| WK-DMF0021-0822 | B3 | DMF0021_SalesPlan.GetPlantSitebyEndCusto | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetPlantSitebyEndCustomerAsync: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetPlantSitebyEndC) |
| WK-DMF0021-0823 | B3 | DMF0021_SalesPlan.GetSALESPLAN_MEASUREIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetSALESPLAN_MEASUREInfo: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.GetSALESPLAN_MEASU) |
| WK-DMF0021-0824 | B3 | DMF0021_SalesPlan.GetSALESPLAN_MEASUREIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetSALESPLAN_MEASUREInfo2: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.GetSALESPLAN_MEASU) |
| WK-DMF0021-0825 | B3 | DMF0021_SalesPlan.GetScmSitebyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetScmSitebyDivision: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetScmSitebyDivisi) |
| WK-DMF0021-0826 | B3 | DMF0021_SalesPlan.GetScmSitebyDivisionAs | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetScmSitebyDivisionAsync: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetScmSitebyDivisi) |
| WK-DMF0021-0827 | B3 | DMF0021_SalesPlan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetSpdTitle: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0021_SalesPlan.GetSpdTitle:655:5 ) |
| WK-DMF0021-0828 | B3 | DMF0021_SalesPlan.GetTeambyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetTeambyDivision: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0021_SalesPlan.GetTeambyDivision:) |
| WK-DMF0021-0829 | B3 | DMF0021_SalesPlan.GetTeambyDivisionAsync | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetTeambyDivisionAsync: 진입점 집계 — B3 15요소: TODO:15 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0021_SalesPlan.GetTeambyDivisionA) |
| WK-DMF0021-0830 | B3 | DMF0021_SalesPlan.GetThisWeekMonday | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0021_SalesPlan.GetThisWeekMonday: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:DMF0021_SalesPlan.GetThisWeekMonday:) |
| WK-DMF0021-0831 | B4 | 139 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 139: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (139) |
| WK-DMF0021-0832 | B4 | AsIncotermsEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — AsIncotermsEdit: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (AsIncotermsEdit) |
| WK-DMF0021-0833 | B4 | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — BizTypeByDivision: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (BizTypeByDivision) |
| WK-DMF0021-0834 | B4 | CC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — CC-04: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (CC-04) |
| WK-DMF0021-0835 | B4 | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — CurrencyList: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (CurrencyList) |
| WK-DMF0021-0836 | B4 | CustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — CustomsHandbook: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (CustomsHandbook) |
| WK-DMF0021-0837 | B4 | DMF0021_SalesPlan.GetBizTypebyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetBizTypebyDivision: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0021_SalesPlan.GetBizTypebyDivisi) |
| WK-DMF0021-0838 | B4 | DMF0021_SalesPlan.GetBizTypebyDivisionAs | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetBizTypebyDivisionAsync: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0021_SalesPlan.GetBizTypebyDivisi) |
| WK-DMF0021-0839 | B4 | DMF0021_SalesPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetBucketType: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.GetBucketType:3426) |
| WK-DMF0021-0840 | B4 | DMF0021_SalesPlan.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetCellColor: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetCellColor:4319:) |
| WK-DMF0021-0841 | B4 | DMF0021_SalesPlan.GetCustomerbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetCustomerbyDivision: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetCustomerbyDivis) |
| WK-DMF0021-0842 | B4 | DMF0021_SalesPlan.GetCustomerbyDivisionA | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetCustomerbyDivisionAsync: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetCustomerbyDivis) |
| WK-DMF0021-0843 | B4 | DMF0021_SalesPlan.GetCustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetCustomsHandbook: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetCustomsHandbook) |
| WK-DMF0021-0844 | B4 | DMF0021_SalesPlan.GetDataTableMeargeForD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetDataTableMeargeForDate: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 46 (ACT:DMF0021_SalesPlan.GetDataTableMearge) |
| WK-DMF0021-0845 | B4 | DMF0021_SalesPlan.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetDayRange: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetDayRange:3406:1) |
| WK-DMF0021-0846 | B4 | DMF0021_SalesPlan.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetDivision: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.GetDivision:3376:1) |
| WK-DMF0021-0847 | B4 | DMF0021_SalesPlan.GetEndCustomerbyDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetEndCustomerbyDivision: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetEndCustomerbyDi) |
| WK-DMF0021-0848 | B4 | DMF0021_SalesPlan.GetFcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetFcstType: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetFcstType:5581:1) |
| WK-DMF0021-0849 | B4 | DMF0021_SalesPlan.GetIncotermsType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetIncotermsType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetIncotermsType:5) |
| WK-DMF0021-0850 | B4 | DMF0021_SalesPlan.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetItemType: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0021_SalesPlan.GetItemType:3438:1) |
| WK-DMF0021-0851 | B4 | DMF0021_SalesPlan.GetLookupValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetLookupValues: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.GetLookupValues:56) |
| WK-DMF0021-0852 | B4 | DMF0021_SalesPlan.GetPlantSitebyEndCusto | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetPlantSitebyEndCustomer: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetPlantSitebyEndC) |
| WK-DMF0021-0853 | B4 | DMF0021_SalesPlan.GetPlantSitebyEndCusto | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetPlantSitebyEndCustomerAsync: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetPlantSitebyEndC) |
| WK-DMF0021-0854 | B4 | DMF0021_SalesPlan.GetSALESPLAN_MEASUREIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetSALESPLAN_MEASUREInfo: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.GetSALESPLAN_MEASU) |
| WK-DMF0021-0855 | B4 | DMF0021_SalesPlan.GetSALESPLAN_MEASUREIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetSALESPLAN_MEASUREInfo2: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.GetSALESPLAN_MEASU) |
| WK-DMF0021-0856 | B4 | DMF0021_SalesPlan.GetScmSitebyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetScmSitebyDivision: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetScmSitebyDivisi) |
| WK-DMF0021-0857 | B4 | DMF0021_SalesPlan.GetScmSitebyDivisionAs | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetScmSitebyDivisionAsync: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetScmSitebyDivisi) |
| WK-DMF0021-0858 | B4 | DMF0021_SalesPlan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetSpdTitle: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0021_SalesPlan.GetSpdTitle:655:5 ) |
| WK-DMF0021-0859 | B4 | DMF0021_SalesPlan.GetTeambyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetTeambyDivision: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0021_SalesPlan.GetTeambyDivision:) |
| WK-DMF0021-0860 | B4 | DMF0021_SalesPlan.GetTeambyDivisionAsync | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetTeambyDivisionAsync: 진입점 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0021_SalesPlan.GetTeambyDivisionA) |
| WK-DMF0021-0861 | B4 | DMF0021_SalesPlan.GetThisWeekMonday | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0021_SalesPlan.GetThisWeekMonday: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:DMF0021_SalesPlan.GetThisWeekMonday:) |
| WK-DMF0021-0862 | B4 | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — Division: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (Division) |
| WK-DMF0021-0863 | B4 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — E06: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0021-0864 | B4 | EndCustomerByDivisionDept | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — EndCustomerByDivisionDept: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (EndCustomerByDivisionDept) |
| WK-DMF0021-0865 | B4 | FromSiteByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — FromSiteByDivision: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (FromSiteByDivision) |
| WK-DMF0021-0866 | B4 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — Measure: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-DMF0021-0867 | B4 | SalesPlanItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SalesPlanItemId: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (SalesPlanItemId) |
| WK-DMF0021-0868 | B4 | SiteByEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SiteByEndCustomer: 행 집계 — B4 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (SiteByEndCustomer) |
| WK-DMF0021-0869 | DB-SYN | 33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 33: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0870 | DB-SYN | 37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 37: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0871 | DB-SYN | 39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 39: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (39) |
| WK-DMF0021-0872 | DB-SYN | 40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 40: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (40) |
| WK-DMF0021-0873 | DB-SYN | 41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 41: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (41) |
| WK-DMF0021-0874 | DB-SYN | 42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 42: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (42) |
| WK-DMF0021-0875 | DB-SYN | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 43: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (43) |
| WK-DMF0021-0876 | DB-SYN | 45 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 45: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (45) |
| WK-DMF0021-0877 | DB-SYN | 59 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 59: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (59) |
| WK-DMF0021-0878 | DB-SYN | 60 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 60: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (60) |
| WK-DMF0021-0879 | DB-SYN | 61 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 61: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (61) |
| WK-DMF0021-0880 | DB-SYN | 62 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 62: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (62) |
| WK-DMF0021-0881 | DB-SYN | 63 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 63: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (63) |
| WK-DMF0021-0882 | DB-SYN | 64 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 64: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (64) |
| WK-DMF0021-0883 | DB-SYN | 65 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 65: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (65) |
| WK-DMF0021-0884 | DB-SYN | 66 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 66: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (66) |
| WK-DMF0021-0885 | DB-SYN | 67 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 67: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (67) |
| WK-DMF0021-0886 | DB-SYN | 68 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 68: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (68) |
| WK-DMF0021-0887 | DB-SYN | 69 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 69: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (69) |
| WK-DMF0021-0888 | DB-SYN | 70 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 70: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (70) |
| WK-DMF0021-0889 | DB-SYN | 71 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 71: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (71) |
| WK-DMF0021-0890 | DB-SYN | 72 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 72: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (72) |
| WK-DMF0021-0891 | DB-SYN | 73 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 73: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (73) |
| WK-DMF0021-0892 | DB-SYN | 74 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 74: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (74) |
| WK-DMF0021-0893 | DB-SYN | 75 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 75: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (75) |
| WK-DMF0021-0894 | DB-SYN | 76 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 76: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (76) |
| WK-DMF0021-0895 | DB-SYN | 77 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 77: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (77) |
| WK-DMF0021-0896 | DB-SYN | 78 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 78: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (78) |
| WK-DMF0021-0897 | DB-SYN | 79 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 79: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (79) |
| WK-DMF0021-0898 | DB-SYN | 80 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 80: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (80) |
| WK-DMF0021-0899 | DB-SYN | 81 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 81: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (81) |
| WK-DMF0021-0900 | DB-SYN | 82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 82: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (82) |
| WK-DMF0021-0901 | DB-SYN | 83 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 83: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (83) |
| WK-DMF0021-0902 | DB-SYN | 84 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 84: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (84) |
| WK-DMF0021-0903 | DB-SYN | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 9: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0904 | DB-SYN | CA-126 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-126: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-126) |
| WK-DMF0021-0905 | DB-SYN | CA-127 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-127: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-127) |
| WK-DMF0021-0906 | DB-SYN | CA-128 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-128: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-128) |
| WK-DMF0021-0907 | DB-SYN | CA-129 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-129: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-129) |
| WK-DMF0021-0908 | DB-SYN | CA-130 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-130: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-130) |
| WK-DMF0021-0909 | DB-SYN | CA-131 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-131: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-131) |
| WK-DMF0021-0910 | DB-SYN | CA-133 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-133: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-133) |
| WK-DMF0021-0911 | DB-SYN | CA-134 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-134: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-134) |
| WK-DMF0021-0912 | DB-SYN | CA-135 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-135: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-135) |
| WK-DMF0021-0913 | DB-SYN | CA-136 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-136: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-136) |
| WK-DMF0021-0914 | DB-SYN | CA-137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-137: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-137) |
| WK-DMF0021-0915 | DB-SYN | CA-138 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-138: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-138) |
| WK-DMF0021-0916 | DB-SYN | CA-139 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-139: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-139) |
| WK-DMF0021-0917 | DB-SYN | CA-140 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-140: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-140) |
| WK-DMF0021-0918 | DB-SYN | CA-141 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-141: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-141) |
| WK-DMF0021-0919 | DB-SYN | CA-142 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-142: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-142) |
| WK-DMF0021-0920 | DB-SYN | CA-143 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CA-143: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-143) |
| WK-DMF0021-0921 | DB-SYN | CB-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CB-107: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CB-107) |
| WK-DMF0021-0922 | DB-SYN | CC-111 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CC-111: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CC-111) |
| WK-DMF0021-0923 | DB-SYN | CC-112 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CC-112: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CC-112) |
| WK-DMF0021-0924 | DB-SYN | CC-113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CC-113: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CC-113) |
| WK-DMF0021-0925 | DB-SYN | CD-119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CD-119: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CD-119) |
| WK-DMF0021-0926 | DB-SYN | CD-120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CD-120: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CD-120) |
| WK-DMF0021-0927 | DB-SYN | CD-125 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CD-125: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CD-125) |
| WK-DMF0021-0928 | DB-SYN | CE-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CE-107: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CE-107) |
| WK-DMF0021-0929 | DB-SYN | CE-108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CE-108: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CE-108) |
| WK-DMF0021-0930 | DB-SYN | CF-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CF-02: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CF-02) |
| WK-DMF0021-0931 | DB-SYN | CG-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CG-02: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CG-02) |
| WK-DMF0021-0932 | DB-SYN | CG-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CG-03: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CG-03) |
| WK-DMF0021-0933 | DB-SYN | CRUD:E04:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:E04:SAVE: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0021-0934 | DB-SYN | CRUD:E07:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:E07:SEARCH: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E07:SEARCH) |
| WK-DMF0021-0935 | DB-SYN | DMF0021_SalesPlan.GetCustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0021_SalesPlan.GetCustomsHandbook: 진입점 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.GetCustomsHandbook) |
| WK-DMF0021-0936 | DB-SYN | DMF0021_SalesPlan.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0021_SalesPlan.GetDayRange: 진입점 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.GetDayRange:3410:3) |
| WK-DMF0021-0937 | DB-SYN | DMF0021_SalesPlan.GetFcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0021_SalesPlan.GetFcstType: 진입점 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.GetFcstType:5585:3) |
| WK-DMF0021-0938 | DB-SYN | DMF0021_SalesPlan.GetIncotermsType | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0021_SalesPlan.GetIncotermsType: 진입점 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.GetIncotermsType:5) |
| WK-DMF0021-0939 | DB-SYN | DMF0021_SalesPlan.GetLookupValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0021_SalesPlan.GetLookupValues: 진입점 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.GetLookupValues:56) |
| WK-DMF0021-0940 | DB-SYN | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — E04: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0021-0941 | DB-SYN | E07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — E07: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (E07) |
| WK-DMF0021-0942 | DB-SYN | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:FindData: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0021-0943 | DB-SYN | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:SaveData: 행 집계 — DB-SYN 15요소: NOPATH:11 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SaveData) |
| WK-DMF0021-0944 | F4 | 33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 33: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0945 | F4 | 37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 37: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0946 | F4 | 39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 39: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (39) |
| WK-DMF0021-0947 | F4 | 40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 40: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (40) |
| WK-DMF0021-0948 | F4 | 41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 41: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (41) |
| WK-DMF0021-0949 | F4 | 42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 42: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (42) |
| WK-DMF0021-0950 | F4 | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 43: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (43) |
| WK-DMF0021-0951 | F4 | 45 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 45: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (45) |
| WK-DMF0021-0952 | F4 | 59 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 59: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (59) |
| WK-DMF0021-0953 | F4 | 60 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 60: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (60) |
| WK-DMF0021-0954 | F4 | 61 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 61: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (61) |
| WK-DMF0021-0955 | F4 | 62 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 62: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (62) |
| WK-DMF0021-0956 | F4 | 63 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 63: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (63) |
| WK-DMF0021-0957 | F4 | 64 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 64: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (64) |
| WK-DMF0021-0958 | F4 | 65 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 65: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (65) |
| WK-DMF0021-0959 | F4 | 66 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 66: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (66) |
| WK-DMF0021-0960 | F4 | 67 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 67: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (67) |
| WK-DMF0021-0961 | F4 | 68 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 68: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (68) |
| WK-DMF0021-0962 | F4 | 69 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 69: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (69) |
| WK-DMF0021-0963 | F4 | 70 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 70: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (70) |
| WK-DMF0021-0964 | F4 | 71 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 71: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (71) |
| WK-DMF0021-0965 | F4 | 72 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 72: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (72) |
| WK-DMF0021-0966 | F4 | 73 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 73: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (73) |
| WK-DMF0021-0967 | F4 | 74 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 74: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (74) |
| WK-DMF0021-0968 | F4 | 75 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 75: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (75) |
| WK-DMF0021-0969 | F4 | 76 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 76: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (76) |
| WK-DMF0021-0970 | F4 | 77 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 77: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (77) |
| WK-DMF0021-0971 | F4 | 78 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 78: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (78) |
| WK-DMF0021-0972 | F4 | 79 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 79: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (79) |
| WK-DMF0021-0973 | F4 | 80 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 80: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (80) |
| WK-DMF0021-0974 | F4 | 81 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 81: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (81) |
| WK-DMF0021-0975 | F4 | 82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 82: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (82) |
| WK-DMF0021-0976 | F4 | 83 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 83: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (83) |
| WK-DMF0021-0977 | F4 | 84 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 84: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (84) |
| WK-DMF0021-0978 | F4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 9: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-0979 | F4 | CA-126 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-126: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-126) |
| WK-DMF0021-0980 | F4 | CA-127 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-127: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-127) |
| WK-DMF0021-0981 | F4 | CA-128 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-128: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-128) |
| WK-DMF0021-0982 | F4 | CA-129 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-129: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-129) |
| WK-DMF0021-0983 | F4 | CA-130 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-130: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-130) |
| WK-DMF0021-0984 | F4 | CA-131 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-131: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-131) |
| WK-DMF0021-0985 | F4 | CA-133 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-133: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-133) |
| WK-DMF0021-0986 | F4 | CA-134 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-134: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-134) |
| WK-DMF0021-0987 | F4 | CA-135 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-135: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-135) |
| WK-DMF0021-0988 | F4 | CA-136 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-136: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-136) |
| WK-DMF0021-0989 | F4 | CA-137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-137: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-137) |
| WK-DMF0021-0990 | F4 | CA-138 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-138: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-138) |
| WK-DMF0021-0991 | F4 | CA-139 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-139: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-139) |
| WK-DMF0021-0992 | F4 | CA-140 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-140: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-140) |
| WK-DMF0021-0993 | F4 | CA-141 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-141: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-141) |
| WK-DMF0021-0994 | F4 | CA-142 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-142: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-142) |
| WK-DMF0021-0995 | F4 | CA-143 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CA-143: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CA-143) |
| WK-DMF0021-0996 | F4 | CB-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CB-107: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CB-107) |
| WK-DMF0021-0997 | F4 | CC-111 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CC-111: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CC-111) |
| WK-DMF0021-0998 | F4 | CC-112 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CC-112: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CC-112) |
| WK-DMF0021-0999 | F4 | CC-113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CC-113: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CC-113) |
| WK-DMF0021-1000 | F4 | CD-119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CD-119: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CD-119) |
| WK-DMF0021-1001 | F4 | CD-120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CD-120: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CD-120) |
| WK-DMF0021-1002 | F4 | CD-125 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CD-125: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CD-125) |
| WK-DMF0021-1003 | F4 | CE-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CE-107: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CE-107) |
| WK-DMF0021-1004 | F4 | CE-108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CE-108: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CE-108) |
| WK-DMF0021-1005 | F4 | CF-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CF-02: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CF-02) |
| WK-DMF0021-1006 | F4 | CG-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CG-02: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CG-02) |
| WK-DMF0021-1007 | F4 | CG-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CG-03: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CG-03) |
| WK-DMF0021-1008 | F4 | CRUD:E04:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CRUD:E04:SAVE: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0021-1009 | F4 | CRUD:E07:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CRUD:E07:SEARCH: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E07:SEARCH) |
| WK-DMF0021-1010 | F4 | DMF0021_SalesPlan.GetCustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0021_SalesPlan.GetCustomsHandbook: 진입점 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.GetCustomsHandbook) |
| WK-DMF0021-1011 | F4 | DMF0021_SalesPlan.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0021_SalesPlan.GetDayRange: 진입점 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.GetDayRange:3410:3) |
| WK-DMF0021-1012 | F4 | DMF0021_SalesPlan.GetFcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0021_SalesPlan.GetFcstType: 진입점 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.GetFcstType:5585:3) |
| WK-DMF0021-1013 | F4 | DMF0021_SalesPlan.GetIncotermsType | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0021_SalesPlan.GetIncotermsType: 진입점 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.GetIncotermsType:5) |
| WK-DMF0021-1014 | F4 | DMF0021_SalesPlan.GetLookupValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0021_SalesPlan.GetLookupValues: 진입점 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.GetLookupValues:56) |
| WK-DMF0021-1015 | F4 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — E04: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0021-1016 | F4 | E07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — E07: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (E07) |
| WK-DMF0021-1017 | F4 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:FindData: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0021-1018 | F4 | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:SaveData: 행 집계 — F4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SaveData) |
| WK-DMF0021-1019 | A5 | 38 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 38: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1020 | A5 | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 43: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (43) |
| WK-DMF0021-1021 | A5 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 9: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1022 | A5 | DMF0021_SalesPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0021_SalesPlan.CreateSpread: 진입점 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.CreateSpread:581:1) |
| WK-DMF0021-1023 | A5 | DMF0021_SalesPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0021_SalesPlan.SetSpreadColumn: 진입점 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-1024 | A5 | DMF0021_SalesPlan.SetSpreadHeaderSpan | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0021_SalesPlan.SetSpreadHeaderSpan: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 101 (ACT:DMF0021_SalesPlan.SetSpreadHeaderSpa) |
| WK-DMF0021-1025 | A5 | HANDLER:ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — HANDLER:ExcelButton: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0021-1026 | G4 | 113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 113: 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (113) |
| WK-DMF0021-1027 | G4 | 114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 114: 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (114) |
| WK-DMF0021-1028 | G4 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 14: 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1029 | G4 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 15: 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1030 | G4 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 17: 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1031 | G4 | Delete (F9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Delete (F9): 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Delete (F9)) |
| WK-DMF0021-1032 | G4 | Edit (F2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Edit (F2): 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Edit (F2)) |
| WK-DMF0021-1033 | G4 | Excel (F12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Excel (F12): 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Excel (F12)) |
| WK-DMF0021-1034 | G4 | Filter/Sort/Condition/Reset | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Filter/Sort/Condition/Reset: 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Filter/Sort/Condition/Reset) |
| WK-DMF0021-1035 | G4 | Find (F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Find (F5): 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Find (F5)) |
| WK-DMF0021-1036 | G4 | Insert (F8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Insert (F8): 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Insert (F8)) |
| WK-DMF0021-1037 | G4 | Save (F7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Save (F7): 행 집계 — G4 22요소: NOT_RUN:16 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Save (F7)) |
| WK-DMF0021-1038 | H2 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 1: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1039 | H2 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 10: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1040 | H2 | 102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 102: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1041 | H2 | 103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 103: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1042 | H2 | 104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 104: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1043 | H2 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 11: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1044 | H2 | 117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 117: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1045 | H2 | 118 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 118: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1046 | H2 | 119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 119: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1047 | H2 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 12: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1048 | H2 | 120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 120: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1049 | H2 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 13: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1050 | H2 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 17: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1051 | H2 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 2: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1052 | H2 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 20: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1053 | H2 | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 22: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1054 | H2 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 25: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1055 | H2 | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 28: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1056 | H2 | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 29: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1057 | H2 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1058 | H2 | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 30: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1059 | H2 | 31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 31: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1060 | H2 | 33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 33: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1061 | H2 | 38 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 38: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1062 | H2 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 4: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1063 | H2 | 41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 41: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1064 | H2 | 42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 42: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1065 | H2 | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 43: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 1 (43) |
| WK-DMF0021-1066 | H2 | 44 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 44: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1067 | H2 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 5: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1068 | H2 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 6: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1069 | H2 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 7: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1070 | H2 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 8: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1071 | H2 | 82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 82: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1072 | H2 | 83 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 83: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1073 | H2 | 84 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 84: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1074 | H2 | 85 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 85: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1075 | H2 | 86 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 86: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1076 | H2 | 87 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 87: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1077 | H2 | 88 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 88: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1078 | H2 | 89 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 89: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1079 | H2 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 9: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1080 | H2 | 90 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 90: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1081 | H2 | 91 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 91: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1082 | H2 | 92 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 92: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1083 | H2 | 95 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 95: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1084 | H2 | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 98: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1085 | H2 | CD-135 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — CD-135: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 1 (CD-135) |
| WK-DMF0021-1086 | H2 | CD-142 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — CD-142: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 1 (CD-142) |
| WK-DMF0021-1087 | H2 | CD-144 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — CD-144: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 1 (CD-144) |
| WK-DMF0021-1088 | H2 | CD-147 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — CD-147: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 1 (CD-147) |
| WK-DMF0021-1089 | H2 | DMF0021_SalesPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0021_SalesPlan.CreateSpread: 진입점 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.CreateSpread:581:1) |
| WK-DMF0021-1090 | H2 | DMF0021_SalesPlan.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0021_SalesPlan.GetCellColor: 진입점 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.GetCellColor:4319:) |
| WK-DMF0021-1091 | H2 | DMF0021_SalesPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0021_SalesPlan.SetSpreadColumn: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-1092 | H2 | DMF0021_SalesPlan.SetSpreadHeaderSpan | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0021_SalesPlan.SetSpreadHeaderSpan: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 101 (ACT:DMF0021_SalesPlan.SetSpreadHeaderSpa) |
| WK-DMF0021-1093 | H2 | DMF0021_SalesPlan.chkColor_CheckedChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0021_SalesPlan.chkColor_CheckedChanged: 진입점 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0021_SalesPlan.chkColor_CheckedCh) |
| WK-DMF0021-1094 | H2 | HANDLER:ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — HANDLER:ExcelButton: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0021-1095 | H2 | HANDLER:btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — HANDLER:btnItemId_Click: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:btnItemId_Click) |
| WK-DMF0021-1096 | H2 | HANDLER:btnOwner_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — HANDLER:btnOwner_Click: 행 집계 — H2 50요소: NOT_RUN:50 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:btnOwner_Click) |
| WK-DMF0021-1097 | H5 | 38 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 38: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1098 | H5 | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 43: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (43) |
| WK-DMF0021-1099 | H5 | DMF0021_SalesPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0021_SalesPlan.CreateSpread: 진입점 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.CreateSpread:581:1) |
| WK-DMF0021-1100 | H5 | DMF0021_SalesPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0021_SalesPlan.SetSpreadColumn: 진입점 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-1101 | H5 | DMF0021_SalesPlan.SetSpreadHeaderSpan | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0021_SalesPlan.SetSpreadHeaderSpan: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 101 (ACT:DMF0021_SalesPlan.SetSpreadHeaderSpa) |
| WK-DMF0021-1102 | H5 | HANDLER:ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — HANDLER:ExcelButton: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0021-1103 | X-REASON | 12 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 12 EditButton - DIVISION_ID 703 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (12) |
| WK-DMF0021-1104 | X-REASON | 13 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 13 EditButton - PROJECT_CODE 704 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (13) |
| WK-DMF0021-1105 | X-REASON | 14 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 14 EditButton - END_CUSTOMER40 705 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRow |  | 1 (14) |
| WK-DMF0021-1106 | X-REASON | 15 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 15 EditButton - END_CUSTOMER 706 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (15) |
| WK-DMF0021-1107 | X-REASON | 16 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 16 EditButton - SCM_SITE_ID 707 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (16) |
| WK-DMF0021-1108 | X-REASON | 17 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 17 EditButton - ITEM_ID 708 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (17) |
| WK-DMF0021-1109 | X-REASON | 18 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 18 EditButton - TEXT 709 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (18) |
| WK-DMF0021-1110 | X-REASON | 19 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 19 EditButton - DomExp 710 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (19) |
| WK-DMF0021-1111 | X-REASON | 20 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 20 EditButton - FcstType 711 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (20) |
| WK-DMF0021-1112 | X-REASON | 21 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 21 EditButton - INCOTERMS 712 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (21) |
| WK-DMF0021-1113 | X-REASON | 22 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 22 EditButton - MEASURE 713 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (22) |
| WK-DMF0021-1114 | X-REASON | 23 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 23 EditButton - CURRENCY 714 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (23) |
| WK-DMF0021-1115 | X-REASON | 24 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 24 EditButton - DEPT_ID 715 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSaveRows) |  | 1 (24) |
| WK-DMF0021-1116 | X-REASON | 25 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 25 EditButton - CELL_PROD_SITE_ID 716 해당없음 — admin SHEET_COLUMNS 66건 고정 배선으로 컬럼 존재 보장. 값 검증 = V-V1(validateSave |  | 1 (25) |
| WK-DMF0021-1117 | X-REASON | 29 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 29 EditButton - CELL_PROD_SITE_ID 724 해당없음 — CELL_PROD_SITE_ID 컬럼 존재 = 메타 보장. 값 검증 = V-V1(40) |  | 1 (29) |
| WK-DMF0021-1118 | X-REASON | 30 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 30 EditButton - Division 724 해당없음 — CELL_PROD_SITE_ID 컬럼 존재 = 메타 보장. 값 검증 = V-V1(40) |  | 1 (30) |
| WK-DMF0021-1119 | X-REASON | 46 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 46 SaveData - DIVISION_ID 2007 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (46) |
| WK-DMF0021-1120 | X-REASON | 47 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 47 SaveData - PROJECT_CODE 2008 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (47) |
| WK-DMF0021-1121 | X-REASON | 48 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 48 SaveData - END_CUSTOMER40 2009 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (48) |
| WK-DMF0021-1122 | X-REASON | 49 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 49 SaveData - END_CUSTOMER 2010 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (49) |
| WK-DMF0021-1123 | X-REASON | 50 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 50 SaveData - SCM_SITE_ID 2011 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (50) |
| WK-DMF0021-1124 | X-REASON | 51 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 51 SaveData - ITEM_ID 2012 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (51) |
| WK-DMF0021-1125 | X-REASON | 52 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 52 SaveData - TEXT 2013 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (52) |
| WK-DMF0021-1126 | X-REASON | 53 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 53 SaveData - FcstType 2015 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (53) |
| WK-DMF0021-1127 | X-REASON | 54 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 54 SaveData - INCOTERMS 2016 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (54) |
| WK-DMF0021-1128 | X-REASON | 55 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 55 SaveData - MEASURE 2017 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (55) |
| WK-DMF0021-1129 | X-REASON | 56 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 56 SaveData - CURRENCY 2018 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (56) |
| WK-DMF0021-1130 | X-REASON | 57 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 57 SaveData - DEPT_ID 2019 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (57) |
| WK-DMF0021-1131 | X-REASON | 58 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 58 SaveData - CELL_PROD_SITE_ID 2022 해당없음 — 컬럼 존재 = admin 메타 보장. 값 검증 = V-V1 |  | 1 (58) |
| WK-DMF0021-1132 | X-REASON | CA-132 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-132 §1.4 [원문 무번호] SaveData 행별 필수값 / `=="40" && sDeptId=="" && sMeasure!="Catch_Up"` → "[TEAM]"  통합테스트 1st No |  | 1 (CA-132) |
| WK-DMF0021-1133 | X-REASON | CA-144 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-144 §1.5 [원문 무번호] InsertRow / `sDivision=="40" && DEPT_ID 존재`  통합테스트 1st No.61-④ — Team 전 Div 입력 불가(마스터 파생 표 |  | 1 (CA-144) |
| WK-DMF0021-1134 | X-REASON | CB-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CB-101 §2 [원문 무번호] 기능 / 권한 조건  표 헤더 행(기능/권한 조건 라벨) — 판정 대상 아님 해당없음 |  | 1 (CB-101) |
| WK-DMF0021-1135 | X-REASON | CB-108 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CB-108 §2 [원문 무번호] EditButton — 팀 권한 조회 / `Data.UserTeamByDivisionAuth(NowGroupID, UserId, divis…  AS-IS 취득만 하고 |  | 1 (CB-108) |
| WK-DMF0021-1136 | X-REASON | CC-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CC-101 §3.1 [원문 무번호] Measure / 위치  표 헤더 행 — 판정 대상 아님 해당없음 |  | 1 (CC-101) |
| WK-DMF0021-1137 | X-REASON | CC-108 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CC-108 §3.2 [원문 무번호] Measure / 위치  표 헤더 행 — 판정 대상 아님 해당없음 |  | 1 (CC-108) |
| WK-DMF0021-1138 | X-REASON | CC-118 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CC-118 §3.4 [원문 무번호] Measure / 위치  표 헤더 행 — 판정 대상 아님 해당없음 |  | 1 (CC-118) |
| WK-DMF0021-1139 | X-REASON | CD-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CD-101 §4.1 [원문 무번호] 규칙 / 조건  표 헤더 행 — 판정 대상 아님 해당없음 |  | 1 (CD-101) |
| WK-DMF0021-1140 | X-REASON | CD-107 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CD-107 §4.1 [원문 무번호] Edit 시작 컬럼 보정 / 첫 컬럼이 M_ 이면 +1 (M_ 뒤 W_ 항상 존재)  TO-BE 는 binding 태그 판정 — 컬럼 인덱스 +1 보정 구조 자체 |  | 1 (CD-107) |
| WK-DMF0021-1141 | X-REASON | CD-121 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CD-121 §4.1 [원문 무번호] 과거-과거 첫달 회색 버그 보정 / `조회시작월 >= this_YYYYMM` → iResultMonth+1  TO-BE isPast = 태그 비교 — AS-IS  |  | 1 (CD-121) |
| WK-DMF0021-1142 | X-REASON | CD-122 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CD-122 §4.2 [원문 무번호] 규칙 / 조건  표 헤더 행 — 판정 대상 아님 해당없음 |  | 1 (CD-122) |
| WK-DMF0021-1143 | X-REASON | CD-138 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CD-138 §4.3 [원문 무번호] 규칙 / 조건  표 헤더 행 — 판정 대상 아님 해당없음 |  | 1 (CD-138) |
| WK-DMF0021-1144 | X-REASON | CD-139 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CD-139 §4.3 [원문 무번호] 색상 모드(chkColor=true) — 과거 회색 / 전주(pre_YYYYMMWW)까지 `Color.Gainsboro` 배경  Color 체크박스 제거(2026 |  | 1 (CD-139) |
| WK-DMF0021-1145 | X-REASON | CD-140 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CD-140 §4.3 [원문 무번호] 색상 모드 — 당월 White 복원 / this_YYYYMM 컬럼 White  Color 체크박스 제거(2026-07 사용자 확정) — chkColor=true  |  | 1 (CD-140) |
| WK-DMF0021-1146 | X-REASON | CD-145 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CD-145 §4.3 [원문 무번호] 색상 모드 시 헤더 리셋 / chkColor=true → ForeColor/Font 리셋  Color 체크박스 제거(2026-07 사용자 확정) — chkColo |  | 1 (CD-145) |
| WK-DMF0021-1147 | X-REASON | CF-97 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CF-97 §6.4 DEPT_ID (SalesAmt_LOC 복귀 — 팀 입력 개방) / false  통합테스트 1st No.61-④ — ETC 복귀 시 팀 입력 개방(AS-IS L5007)은 전 Di |  | 1 (CF-97) |
| WK-DMF0021-1148 | X-REASON | CI-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CI-101 §9 [원문 무번호] 1. Division 비교 분기 / **73곳**  축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 해당없음 |  | 1 (CI-101) |
| WK-DMF0021-1149 | X-REASON | CI-102 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CI-102 §9 [원문 무번호] 2. 권한 / **16곳**  축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 해당없음 |  | 1 (CI-102) |
| WK-DMF0021-1150 | X-REASON | CI-103 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CI-103 §9 [원문 무번호] 3. Measure / **22곳 비교 + 전환 cascade 25규칙**  축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 해당없음 |  | 1 (CI-103) |
| WK-DMF0021-1151 | X-REASON | CI-104 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CI-104 §9 [원문 무번호] 4. 기간·버킷 / **42건**  축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 해당없음 |  | 1 (CI-104) |
| WK-DMF0021-1152 | X-REASON | CI-105 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CI-105 §9 [원문 무번호] 5. FCST_TYPE / **8곳**  축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 해당없음 |  | 1 (CI-105) |
| WK-DMF0021-1153 | X-REASON | CI-106 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CI-106 §9 [원문 무번호] 6. Lock / **108건 + 소비 8곳**  축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 해당없음 |  | 1 (CI-106) |
| WK-DMF0021-1154 | X-REASON | CI-108 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CI-108 §9 [원문 무번호] 8. 비활성 인벤토리 / 17그룹  축별 카운트 요약 행 — 각 축 개별 행에서 판정 완료 해당없음 |  | 1 (CI-108) |
| WK-DMF0021-1155 | X-REASON | HANDLER:DMF0021_SalesPlan_Load | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:DMF0021_SalesPlan_Load AS-IS `DMF0021_SalesPlan.cs:5534` (라이브 2행) · **사문(빈 몸통)**  AS-IS 사문(빈 몸통) — 이관 대 |  | 1 (HANDLER:DMF0021_SalesPlan_Load) |
| WK-DMF0021-1156 | X-REASON | HANDLER:FindButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:FindButton AS-IS `DMF0021_SalesPlan.cs:669` (라이브 3행) · **사문(빈 몸통)**  AS-IS 사문(빈 몸통) — 이관 대상 아님 해당없음 |  | 1 (HANDLER:FindButton) |
| WK-DMF0021-1157 | X-REASON | HANDLER:InsertButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:InsertButton AS-IS `DMF0021_SalesPlan.cs:674` (라이브 3행) · **사문(빈 몸통)**  AS-IS 사문(빈 몸통) — 이관 대상 아님 해당없음 |  | 1 (HANDLER:InsertButton) |
| WK-DMF0021-1158 | X-REASON | HANDLER:SaveButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:SaveButton AS-IS `DMF0021_SalesPlan.cs:1125` (라이브 3행) · **사문(빈 몸통)**  AS-IS 사문(빈 몸통) — 이관 대상 아님 해당없음 |  | 1 (HANDLER:SaveButton) |
| WK-DMF0021-1159 | X-REASON | HANDLER:chkColor_CheckedChanged | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:chkColor_CheckedChanged AS-IS `DMF0021_SalesPlan.cs:5255` (라이브 6행)  Color 체크박스 제거(2026-07 사용자 확정) 제외 |  | 1 (HANDLER:chkColor_CheckedChanged) |
| WK-DMF0021-1160 | X-REASON | HANDLER:spdMain_EditChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_EditChange AS-IS `DMF0021_SalesPlan.cs:4447` (라이브 2행) · **사문(빈 몸통)**  AS-IS 사문(빈 몸통) — 이관 대상 아님 |  | 1 (HANDLER:spdMain_EditChange) |
| WK-DMF0021-1161 | X-REASON | HANDLER:spdMain_TextChanged | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_TextChanged AS-IS `DMF0021_SalesPlan.cs:4440` (라이브 2행) · **사문(빈 몸통)**  AS-IS 사문(빈 몸통) — 이관 대상 아 |  | 1 (HANDLER:spdMain_TextChanged) |
| WK-DMF0021-1162 | X-REASON | HANDLER:spdMain_TopChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_TopChange AS-IS `DMF0021_SalesPlan.cs:3569` (라이브 5행)  AS-IS 스크롤 시 SmartColMerge 재호출 — TO-BE Hie |  | 1 (HANDLER:spdMain_TopChange) |
| WK-DMF0021-1163 | D1 | **[E20260331-000648]** | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — **[E20260331-000648]**: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (**[E20260331-000648]**) |
| WK-DMF0021-1164 | D1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 1: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1165 | D1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 10: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-DMF0021-1166 | D1 | 102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 102: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1167 | D1 | 103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 103: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1168 | D1 | 104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 104: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1169 | D1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 11: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-DMF0021-1170 | D1 | 117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 117: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1171 | D1 | 118 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 118: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1172 | D1 | 119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 119: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1173 | D1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 12: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1174 | D1 | 120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 120: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1175 | D1 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 13: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1176 | D1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 17: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1177 | D1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1178 | D1 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 20: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1179 | D1 | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 22: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1180 | D1 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 25: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1181 | D1 | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 28: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (28) |
| WK-DMF0021-1182 | D1 | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 29: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1183 | D1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 3: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1184 | D1 | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 30: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1185 | D1 | 31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 31: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (31) |
| WK-DMF0021-1186 | D1 | 32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 32: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (32) |
| WK-DMF0021-1187 | D1 | 33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 33: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (33) |
| WK-DMF0021-1188 | D1 | 34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 34: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (34) |
| WK-DMF0021-1189 | D1 | 35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 35: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (35) |
| WK-DMF0021-1190 | D1 | 36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 36: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1191 | D1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 4: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1192 | D1 | 41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 41: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1193 | D1 | 42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 42: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1194 | D1 | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 43: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1195 | D1 | 44 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 44: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1196 | D1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 5: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1197 | D1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 6: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1198 | D1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 7: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1199 | D1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 8: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1200 | D1 | 82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 82: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1201 | D1 | 83 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 83: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1202 | D1 | 84 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 84: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1203 | D1 | 85 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 85: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1204 | D1 | 86 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 86: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1205 | D1 | 87 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 87: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1206 | D1 | 88 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 88: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1207 | D1 | 89 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 89: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1208 | D1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 9: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-DMF0021-1209 | D1 | 90 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 90: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (90) |
| WK-DMF0021-1210 | D1 | 91 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 91: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (91) |
| WK-DMF0021-1211 | D1 | 92 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 92: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1212 | D1 | 95 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 95: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1213 | D1 | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 98: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1214 | D1 | AsIncotermsEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — AsIncotermsEdit: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (AsIncotermsEdit) |
| WK-DMF0021-1215 | D1 | CA-115 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CA-115: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CA-115) |
| WK-DMF0021-1216 | D1 | CA-116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CA-116: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CA-116) |
| WK-DMF0021-1217 | D1 | CA-146 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CA-146: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CA-146) |
| WK-DMF0021-1218 | D1 | CA-147 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CA-147: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CA-147) |
| WK-DMF0021-1219 | D1 | CB-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CB-102: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CB-102) |
| WK-DMF0021-1220 | D1 | CB-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CB-105: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CB-105) |
| WK-DMF0021-1221 | D1 | CC-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-102: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-102) |
| WK-DMF0021-1222 | D1 | CC-103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-103: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-103) |
| WK-DMF0021-1223 | D1 | CC-109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-109: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-109) |
| WK-DMF0021-1224 | D1 | CC-110 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-110: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-110) |
| WK-DMF0021-1225 | D1 | CC-119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-119: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-119) |
| WK-DMF0021-1226 | D1 | CC-120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-120: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-120) |
| WK-DMF0021-1227 | D1 | CC-121 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-121: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-121) |
| WK-DMF0021-1228 | D1 | CC-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-15: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-15) |
| WK-DMF0021-1229 | D1 | CC-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-17: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-17) |
| WK-DMF0021-1230 | D1 | CC-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-18: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-18) |
| WK-DMF0021-1231 | D1 | CC-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-24: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-24) |
| WK-DMF0021-1232 | D1 | CC-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CC-25: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-25) |
| WK-DMF0021-1233 | D1 | CD-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-102: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-102) |
| WK-DMF0021-1234 | D1 | CD-103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-103: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-103) |
| WK-DMF0021-1235 | D1 | CD-104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-104: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-104) |
| WK-DMF0021-1236 | D1 | CD-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-105: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-105) |
| WK-DMF0021-1237 | D1 | CD-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-106: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-106) |
| WK-DMF0021-1238 | D1 | CD-108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-108: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-108) |
| WK-DMF0021-1239 | D1 | CD-109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-109: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-109) |
| WK-DMF0021-1240 | D1 | CD-111 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-111: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-111) |
| WK-DMF0021-1241 | D1 | CD-112 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-112: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-112) |
| WK-DMF0021-1242 | D1 | CD-113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-113: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-113) |
| WK-DMF0021-1243 | D1 | CD-116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-116: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-116) |
| WK-DMF0021-1244 | D1 | CD-117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-117: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-117) |
| WK-DMF0021-1245 | D1 | CD-123 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-123: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-123) |
| WK-DMF0021-1246 | D1 | CD-124 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-124: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-124) |
| WK-DMF0021-1247 | D1 | CD-126 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-126: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-126) |
| WK-DMF0021-1248 | D1 | CD-127 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-127: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-127) |
| WK-DMF0021-1249 | D1 | CD-128 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-128: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-128) |
| WK-DMF0021-1250 | D1 | CD-130 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-130: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-130) |
| WK-DMF0021-1251 | D1 | CD-131 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-131: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-131) |
| WK-DMF0021-1252 | D1 | CD-132 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CD-132: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-132) |
| WK-DMF0021-1253 | D1 | CE-101 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CE-101: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CE-101) |
| WK-DMF0021-1254 | D1 | CE-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CE-102: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CE-102) |
| WK-DMF0021-1255 | D1 | CE-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CE-105: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CE-105) |
| WK-DMF0021-1256 | D1 | CF-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-01: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-01) |
| WK-DMF0021-1257 | D1 | CF-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-02: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-02) |
| WK-DMF0021-1258 | D1 | CF-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-03: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-03) |
| WK-DMF0021-1259 | D1 | CF-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-04: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-04) |
| WK-DMF0021-1260 | D1 | CF-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-05: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-05) |
| WK-DMF0021-1261 | D1 | CF-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-06: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-06) |
| WK-DMF0021-1262 | D1 | CF-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-07: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-07) |
| WK-DMF0021-1263 | D1 | CF-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-08: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-08) |
| WK-DMF0021-1264 | D1 | CF-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-09: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-09) |
| WK-DMF0021-1265 | D1 | CF-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-10: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-10) |
| WK-DMF0021-1266 | D1 | CF-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-11: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-11) |
| WK-DMF0021-1267 | D1 | CF-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-12: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-12) |
| WK-DMF0021-1268 | D1 | CF-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-13: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-13) |
| WK-DMF0021-1269 | D1 | CF-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-14: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-14) |
| WK-DMF0021-1270 | D1 | CF-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-15: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-15) |
| WK-DMF0021-1271 | D1 | CF-76 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-76: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-76) |
| WK-DMF0021-1272 | D1 | CF-77 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-77: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-77) |
| WK-DMF0021-1273 | D1 | CF-80 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CF-80: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-80) |
| WK-DMF0021-1274 | D1 | CG-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CG-01: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CG-01) |
| WK-DMF0021-1275 | D1 | CG-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CG-04: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CG-04) |
| WK-DMF0021-1276 | D1 | CRUD:E03:EDIT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CRUD:E03:EDIT: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E03:EDIT) |
| WK-DMF0021-1277 | D1 | DMF0021_SalesPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DMF0021_SalesPlan.EditButton: 진입점 집계 — D1 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 133 (ACT:DMF0021_SalesPlan.EditButton:689:1 A) |
| WK-DMF0021-1278 | D1 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — E03: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (E03) |
| WK-DMF0021-1279 | D1 | Edit (F2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit (F2): 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (Edit (F2)) |
| WK-DMF0021-1280 | D1 | HANDLER:EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — HANDLER:EditButton: 행 집계 — D1 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:EditButton) |
| WK-DMF0021-1281 | D3 | **[E20260331-000648]** | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — **[E20260331-000648]**: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (**[E20260331-000648]**) |
| WK-DMF0021-1282 | D3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 1: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1283 | D3 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 10: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-DMF0021-1284 | D3 | 102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 102: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1285 | D3 | 103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 103: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1286 | D3 | 104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 104: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1287 | D3 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 11: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-DMF0021-1288 | D3 | 117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 117: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1289 | D3 | 118 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 118: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1290 | D3 | 119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 119: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1291 | D3 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 12: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1292 | D3 | 120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 120: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1293 | D3 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 13: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1294 | D3 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 17: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1295 | D3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1296 | D3 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 20: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1297 | D3 | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 22: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1298 | D3 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 25: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1299 | D3 | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 28: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (28) |
| WK-DMF0021-1300 | D3 | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 29: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1301 | D3 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 3: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1302 | D3 | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 30: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1303 | D3 | 31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 31: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (31) |
| WK-DMF0021-1304 | D3 | 32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 32: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (32) |
| WK-DMF0021-1305 | D3 | 33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 33: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (33) |
| WK-DMF0021-1306 | D3 | 34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 34: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (34) |
| WK-DMF0021-1307 | D3 | 35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 35: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (35) |
| WK-DMF0021-1308 | D3 | 36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 36: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1309 | D3 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 4: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1310 | D3 | 41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 41: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1311 | D3 | 42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 42: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1312 | D3 | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 43: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1313 | D3 | 44 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 44: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1314 | D3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 5: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1315 | D3 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 6: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1316 | D3 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 7: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1317 | D3 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 8: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1318 | D3 | 82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 82: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1319 | D3 | 83 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 83: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1320 | D3 | 84 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 84: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1321 | D3 | 85 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 85: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1322 | D3 | 86 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 86: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1323 | D3 | 87 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 87: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1324 | D3 | 88 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 88: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1325 | D3 | 89 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 89: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1326 | D3 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 9: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-DMF0021-1327 | D3 | 90 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 90: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (90) |
| WK-DMF0021-1328 | D3 | 91 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 91: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (91) |
| WK-DMF0021-1329 | D3 | 92 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 92: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1330 | D3 | 95 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 95: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1331 | D3 | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 98: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1332 | D3 | AsIncotermsEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — AsIncotermsEdit: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (AsIncotermsEdit) |
| WK-DMF0021-1333 | D3 | CA-115 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CA-115: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CA-115) |
| WK-DMF0021-1334 | D3 | CA-116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CA-116: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CA-116) |
| WK-DMF0021-1335 | D3 | CA-146 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CA-146: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CA-146) |
| WK-DMF0021-1336 | D3 | CA-147 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CA-147: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CA-147) |
| WK-DMF0021-1337 | D3 | CB-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CB-102: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CB-102) |
| WK-DMF0021-1338 | D3 | CB-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CB-105: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CB-105) |
| WK-DMF0021-1339 | D3 | CC-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-102: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-102) |
| WK-DMF0021-1340 | D3 | CC-103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-103: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-103) |
| WK-DMF0021-1341 | D3 | CC-109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-109: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-109) |
| WK-DMF0021-1342 | D3 | CC-110 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-110: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-110) |
| WK-DMF0021-1343 | D3 | CC-119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-119: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-119) |
| WK-DMF0021-1344 | D3 | CC-120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-120: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-120) |
| WK-DMF0021-1345 | D3 | CC-121 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-121: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-121) |
| WK-DMF0021-1346 | D3 | CC-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-15: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-15) |
| WK-DMF0021-1347 | D3 | CC-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-17: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-17) |
| WK-DMF0021-1348 | D3 | CC-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-18: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-18) |
| WK-DMF0021-1349 | D3 | CC-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-24: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-24) |
| WK-DMF0021-1350 | D3 | CC-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CC-25: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CC-25) |
| WK-DMF0021-1351 | D3 | CD-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-102: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-102) |
| WK-DMF0021-1352 | D3 | CD-103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-103: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-103) |
| WK-DMF0021-1353 | D3 | CD-104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-104: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-104) |
| WK-DMF0021-1354 | D3 | CD-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-105: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-105) |
| WK-DMF0021-1355 | D3 | CD-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-106: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-106) |
| WK-DMF0021-1356 | D3 | CD-108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-108: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-108) |
| WK-DMF0021-1357 | D3 | CD-109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-109: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-109) |
| WK-DMF0021-1358 | D3 | CD-111 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-111: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-111) |
| WK-DMF0021-1359 | D3 | CD-112 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-112: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-112) |
| WK-DMF0021-1360 | D3 | CD-113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-113: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-113) |
| WK-DMF0021-1361 | D3 | CD-116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-116: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-116) |
| WK-DMF0021-1362 | D3 | CD-117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-117: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-117) |
| WK-DMF0021-1363 | D3 | CD-123 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-123: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-123) |
| WK-DMF0021-1364 | D3 | CD-124 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-124: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-124) |
| WK-DMF0021-1365 | D3 | CD-126 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-126: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-126) |
| WK-DMF0021-1366 | D3 | CD-127 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-127: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-127) |
| WK-DMF0021-1367 | D3 | CD-128 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-128: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-128) |
| WK-DMF0021-1368 | D3 | CD-130 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-130: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-130) |
| WK-DMF0021-1369 | D3 | CD-131 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-131: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-131) |
| WK-DMF0021-1370 | D3 | CD-132 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CD-132: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CD-132) |
| WK-DMF0021-1371 | D3 | CE-101 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CE-101: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CE-101) |
| WK-DMF0021-1372 | D3 | CE-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CE-102: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CE-102) |
| WK-DMF0021-1373 | D3 | CE-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CE-105: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CE-105) |
| WK-DMF0021-1374 | D3 | CF-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-01: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-01) |
| WK-DMF0021-1375 | D3 | CF-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-02: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-02) |
| WK-DMF0021-1376 | D3 | CF-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-03: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-03) |
| WK-DMF0021-1377 | D3 | CF-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-04: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-04) |
| WK-DMF0021-1378 | D3 | CF-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-05: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-05) |
| WK-DMF0021-1379 | D3 | CF-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-06: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-06) |
| WK-DMF0021-1380 | D3 | CF-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-07: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-07) |
| WK-DMF0021-1381 | D3 | CF-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-08: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-08) |
| WK-DMF0021-1382 | D3 | CF-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-09: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-09) |
| WK-DMF0021-1383 | D3 | CF-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-10: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-10) |
| WK-DMF0021-1384 | D3 | CF-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-11: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-11) |
| WK-DMF0021-1385 | D3 | CF-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-12: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-12) |
| WK-DMF0021-1386 | D3 | CF-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-13: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-13) |
| WK-DMF0021-1387 | D3 | CF-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-14: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-14) |
| WK-DMF0021-1388 | D3 | CF-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-15: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-15) |
| WK-DMF0021-1389 | D3 | CF-76 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-76: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-76) |
| WK-DMF0021-1390 | D3 | CF-77 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-77: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-77) |
| WK-DMF0021-1391 | D3 | CF-80 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CF-80: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CF-80) |
| WK-DMF0021-1392 | D3 | CG-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CG-01: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CG-01) |
| WK-DMF0021-1393 | D3 | CG-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CG-04: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CG-04) |
| WK-DMF0021-1394 | D3 | CRUD:E03:EDIT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CRUD:E03:EDIT: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E03:EDIT) |
| WK-DMF0021-1395 | D3 | DMF0021_SalesPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DMF0021_SalesPlan.EditButton: 진입점 집계 — D3 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 133 (ACT:DMF0021_SalesPlan.EditButton:689:1 A) |
| WK-DMF0021-1396 | D3 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E03: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (E03) |
| WK-DMF0021-1397 | D3 | Edit (F2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit (F2): 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (Edit (F2)) |
| WK-DMF0021-1398 | D3 | HANDLER:EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — HANDLER:EditButton: 행 집계 — D3 53요소: NOT_RUN:53 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:EditButton) |
| WK-DMF0021-1399 | D4 | **[E20260331-000648]** | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — **[E20260331-000648]**: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (**[E20260331-000648]**) |
| WK-DMF0021-1400 | D4 | 34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 34: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1401 | D4 | 35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 35: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (35) |
| WK-DMF0021-1402 | D4 | 85 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 85: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (85) |
| WK-DMF0021-1403 | D4 | 89 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 89: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (89) |
| WK-DMF0021-1404 | D4 | 90 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 90: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (90) |
| WK-DMF0021-1405 | D4 | 91 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 91: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (91) |
| WK-DMF0021-1406 | D4 | CA-146 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CA-146: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CA-146) |
| WK-DMF0021-1407 | D4 | CA-147 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CA-147: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CA-147) |
| WK-DMF0021-1408 | D4 | CB-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CB-106: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CB-106) |
| WK-DMF0021-1409 | D4 | CC-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CC-25: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CC-25) |
| WK-DMF0021-1410 | D4 | CD-114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CD-114: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CD-114) |
| WK-DMF0021-1411 | D4 | CD-115 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CD-115: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CD-115) |
| WK-DMF0021-1412 | D4 | CD-116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CD-116: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CD-116) |
| WK-DMF0021-1413 | D4 | CD-117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CD-117: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CD-117) |
| WK-DMF0021-1414 | D4 | CD-126 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CD-126: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CD-126) |
| WK-DMF0021-1415 | D4 | CD-127 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CD-127: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CD-127) |
| WK-DMF0021-1416 | D4 | CD-128 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CD-128: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CD-128) |
| WK-DMF0021-1417 | D4 | CE-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CE-102: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CE-102) |
| WK-DMF0021-1418 | D4 | CF-76 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CF-76: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CF-76) |
| WK-DMF0021-1419 | D4 | CF-77 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CF-77: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CF-77) |
| WK-DMF0021-1420 | D4 | CF-79 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CF-79: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CF-79) |
| WK-DMF0021-1421 | D4 | CF-80 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CF-80: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CF-80) |
| WK-DMF0021-1422 | D4 | CF-82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CF-82: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CF-82) |
| WK-DMF0021-1423 | D4 | CF-83 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CF-83: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CF-83) |
| WK-DMF0021-1424 | D4 | CF-84 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CF-84: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CF-84) |
| WK-DMF0021-1425 | D4 | CRUD:E05:INSERT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CRUD:E05:INSERT: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E05:INSERT) |
| WK-DMF0021-1426 | D4 | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — E05: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E05) |
| WK-DMF0021-1427 | D4 | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — HANDLER:Form_Load: 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:Form_Load) |
| WK-DMF0021-1428 | D4 | Insert (F8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Insert (F8): 행 집계 — D4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Insert (F8)) |
| WK-DMF0021-1429 | D5 | AsIncotermsEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — AsIncotermsEdit: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (AsIncotermsEdit) |
| WK-DMF0021-1430 | D5 | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — BizTypeByDivision: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (BizTypeByDivision) |
| WK-DMF0021-1431 | D5 | CC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — CC-04: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (CC-04) |
| WK-DMF0021-1432 | D5 | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — CurrencyList: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (CurrencyList) |
| WK-DMF0021-1433 | D5 | CustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — CustomsHandbook: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (CustomsHandbook) |
| WK-DMF0021-1434 | D5 | DMF0021_SalesPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0021_SalesPlan.CreateSpread: 진입점 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.CreateSpread:581:1) |
| WK-DMF0021-1435 | D5 | DMF0021_SalesPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0021_SalesPlan.SetSpreadColumn: 진입점 집계 — D5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-1436 | D5 | DMF0021_SalesPlan.SetSpreadHeaderSpan | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0021_SalesPlan.SetSpreadHeaderSpan: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 101 (ACT:DMF0021_SalesPlan.SetSpreadHeaderSpa) |
| WK-DMF0021-1437 | D5 | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — Division: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Division) |
| WK-DMF0021-1438 | D5 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — E06: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0021-1439 | D5 | EndCustomerByDivisionDept | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — EndCustomerByDivisionDept: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (EndCustomerByDivisionDept) |
| WK-DMF0021-1440 | D5 | FromSiteByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — FromSiteByDivision: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FromSiteByDivision) |
| WK-DMF0021-1441 | D5 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — Measure: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-DMF0021-1442 | D5 | SalesPlanItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SalesPlanItemId: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (SalesPlanItemId) |
| WK-DMF0021-1443 | D5 | SiteByEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SiteByEndCustomer: 행 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (SiteByEndCustomer) |
| WK-DMF0021-1444 | E1 | CC-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — CC-105: 행 집계 — E1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (CC-105) |
| WK-DMF0021-1445 | E1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — E02: 행 집계 — E1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0021-1446 | E1 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — E08: 행 집계 — E1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0021-1447 | E1 | HANDLER:spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — HANDLER:spdMain_KeyUp: 행 집계 — E1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_KeyUp) |
| WK-DMF0021-1448 | E4 | 102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 102: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (102) |
| WK-DMF0021-1449 | E4 | 103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 103: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (103) |
| WK-DMF0021-1450 | E4 | 104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 104: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (104) |
| WK-DMF0021-1451 | E4 | 105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 105: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (105) |
| WK-DMF0021-1452 | E4 | 106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 106: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (106) |
| WK-DMF0021-1453 | E4 | 107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 107: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (107) |
| WK-DMF0021-1454 | E4 | 108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 108: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (108) |
| WK-DMF0021-1455 | E4 | 109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 109: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (109) |
| WK-DMF0021-1456 | E4 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 11: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-DMF0021-1457 | E4 | 110 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 110: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (110) |
| WK-DMF0021-1458 | E4 | 111 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 111: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (111) |
| WK-DMF0021-1459 | E4 | 135 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 135: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (135) |
| WK-DMF0021-1460 | E4 | 136 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 136: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (136) |
| WK-DMF0021-1461 | E4 | 137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 137: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (137) |
| WK-DMF0021-1462 | E4 | 138 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 138: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (138) |
| WK-DMF0021-1463 | E4 | 139 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 139: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (139) |
| WK-DMF0021-1464 | E4 | 33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 33: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (33) |
| WK-DMF0021-1465 | E4 | 34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 34: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (34) |
| WK-DMF0021-1466 | E4 | 37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 37: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1467 | E4 | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 43: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (43) |
| WK-DMF0021-1468 | E4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 5: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-DMF0021-1469 | E4 | 60 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 60: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (60) |
| WK-DMF0021-1470 | E4 | 61 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 61: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (61) |
| WK-DMF0021-1471 | E4 | 62 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 62: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (62) |
| WK-DMF0021-1472 | E4 | 63 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 63: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (63) |
| WK-DMF0021-1473 | E4 | 64 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 64: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (64) |
| WK-DMF0021-1474 | E4 | 65 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 65: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (65) |
| WK-DMF0021-1475 | E4 | 66 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 66: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (66) |
| WK-DMF0021-1476 | E4 | 67 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 67: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (67) |
| WK-DMF0021-1477 | E4 | 68 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 68: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (68) |
| WK-DMF0021-1478 | E4 | 69 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 69: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (69) |
| WK-DMF0021-1479 | E4 | 73 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 73: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (73) |
| WK-DMF0021-1480 | E4 | 77 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 77: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (77) |
| WK-DMF0021-1481 | E4 | 81 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 81: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (81) |
| WK-DMF0021-1482 | E4 | 82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 82: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (82) |
| WK-DMF0021-1483 | E4 | 83 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 83: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (83) |
| WK-DMF0021-1484 | E4 | 85 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 85: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (85) |
| WK-DMF0021-1485 | E4 | 88 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 88: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (88) |
| WK-DMF0021-1486 | E4 | 89 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 89: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (89) |
| WK-DMF0021-1487 | E4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 9: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-DMF0021-1488 | E4 | 90 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 90: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (90) |
| WK-DMF0021-1489 | E4 | 91 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 91: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (91) |
| WK-DMF0021-1490 | E4 | 92 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 92: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (92) |
| WK-DMF0021-1491 | E4 | 97 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 97: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (97) |
| WK-DMF0021-1492 | E4 | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 98: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (98) |
| WK-DMF0021-1493 | E4 | CA-126 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CA-126: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (CA-126) |
| WK-DMF0021-1494 | E4 | CA-129 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CA-129: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (CA-129) |
| WK-DMF0021-1495 | E4 | CA-130 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CA-130: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (CA-130) |
| WK-DMF0021-1496 | E4 | CA-134 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CA-134: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (CA-134) |
| WK-DMF0021-1497 | E4 | CA-135 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CA-135: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (CA-135) |
| WK-DMF0021-1498 | E4 | CA-137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CA-137: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (CA-137) |
| WK-DMF0021-1499 | E4 | CA-138 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CA-138: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (CA-138) |
| WK-DMF0021-1500 | E4 | CD-113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CD-113: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (CD-113) |
| WK-DMF0021-1501 | E4 | CRUD:E07:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CRUD:E07:SEARCH: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E07:SEARCH) |
| WK-DMF0021-1502 | E4 | DMF0021_SalesPlan.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0021_SalesPlan.SetChangeControl: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0021_SalesPlan.SetChangeControl:3) |
| WK-DMF0021-1503 | E4 | DMF0021_SalesPlan.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0021_SalesPlan.SetSaveData: 진입점 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 22 (ACT:DMF0021_SalesPlan.SetSaveData:4150:6) |
| WK-DMF0021-1504 | E4 | DMF0021_SalesPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0021_SalesPlan.SetSpreadColumn: 진입점 집계 — E4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-1505 | E4 | DMF0021_SalesPlan.SetSpreadHeaderSpan | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0021_SalesPlan.SetSpreadHeaderSpan: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 101 (ACT:DMF0021_SalesPlan.SetSpreadHeaderSpa) |
| WK-DMF0021-1506 | E4 | E07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E07: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (E07) |
| WK-DMF0021-1507 | E4 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — HANDLER:FindData: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0021-1508 | E4 | HANDLER:cboBucketType_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — HANDLER:cboBucketType_Click: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboBucketType_Click) |
| WK-DMF0021-1509 | E5 | AsIncotermsEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — AsIncotermsEdit: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (AsIncotermsEdit) |
| WK-DMF0021-1510 | E5 | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — BizTypeByDivision: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (BizTypeByDivision) |
| WK-DMF0021-1511 | E5 | CC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — CC-04: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (CC-04) |
| WK-DMF0021-1512 | E5 | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — CurrencyList: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (CurrencyList) |
| WK-DMF0021-1513 | E5 | CustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — CustomsHandbook: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (CustomsHandbook) |
| WK-DMF0021-1514 | E5 | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — Division: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Division) |
| WK-DMF0021-1515 | E5 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — E06: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0021-1516 | E5 | EndCustomerByDivisionDept | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — EndCustomerByDivisionDept: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (EndCustomerByDivisionDept) |
| WK-DMF0021-1517 | E5 | FromSiteByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — FromSiteByDivision: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (FromSiteByDivision) |
| WK-DMF0021-1518 | E5 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — Measure: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-DMF0021-1519 | E5 | SalesPlanItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — SalesPlanItemId: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (SalesPlanItemId) |
| WK-DMF0021-1520 | E5 | SiteByEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — SiteByEndCustomer: 행 집계 — E5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (SiteByEndCustomer) |
| WK-DMF0021-1521 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1522 | A1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 10: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1523 | A1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 11: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1524 | A1 | 113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 113: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (113) |
| WK-DMF0021-1525 | A1 | 114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 114: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (114) |
| WK-DMF0021-1526 | A1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 12: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1527 | A1 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 13: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1528 | A1 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 14: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1529 | A1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 15: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1530 | A1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 16: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1531 | A1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 17: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1532 | A1 | 18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 18: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1533 | A1 | 19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 19: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1534 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1535 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1536 | A1 | 33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 33: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1537 | A1 | 37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 37: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1538 | A1 | 39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 39: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (39) |
| WK-DMF0021-1539 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1540 | A1 | 40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 40: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (40) |
| WK-DMF0021-1541 | A1 | 41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 41: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (41) |
| WK-DMF0021-1542 | A1 | 42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 42: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (42) |
| WK-DMF0021-1543 | A1 | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 43: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (43) |
| WK-DMF0021-1544 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1545 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1546 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1547 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1548 | A1 | 84 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 84: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (84) |
| WK-DMF0021-1549 | A1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-DMF0021-1550 | A1 | CA-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CA-102: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CA-102) |
| WK-DMF0021-1551 | A1 | CA-146 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CA-146: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CA-146) |
| WK-DMF0021-1552 | A1 | CA-147 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CA-147: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CA-147) |
| WK-DMF0021-1553 | A1 | CA-150 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CA-150: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CA-150) |
| WK-DMF0021-1554 | A1 | CA-156 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CA-156: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CA-156) |
| WK-DMF0021-1555 | A1 | CB-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CB-106: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CB-106) |
| WK-DMF0021-1556 | A1 | CB-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CB-107: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CB-107) |
| WK-DMF0021-1557 | A1 | CD-104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CD-104: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CD-104) |
| WK-DMF0021-1558 | A1 | CD-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CD-106: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CD-106) |
| WK-DMF0021-1559 | A1 | CD-108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CD-108: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CD-108) |
| WK-DMF0021-1560 | A1 | CD-116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CD-116: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CD-116) |
| WK-DMF0021-1561 | A1 | CD-119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CD-119: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CD-119) |
| WK-DMF0021-1562 | A1 | CD-120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CD-120: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CD-120) |
| WK-DMF0021-1563 | A1 | CD-131 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CD-131: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CD-131) |
| WK-DMF0021-1564 | A1 | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CELL_PROD_SITE_ID: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CELL_PROD_SITE_ID) |
| WK-DMF0021-1565 | A1 | CF-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-02: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CF-02) |
| WK-DMF0021-1566 | A1 | CF-75 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-75: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CF-75) |
| WK-DMF0021-1567 | A1 | CRUD:E07:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E07:SEARCH: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (CRUD:E07:SEARCH) |
| WK-DMF0021-1568 | A1 | Delete (F9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Delete (F9): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Delete (F9)) |
| WK-DMF0021-1569 | A1 | E07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E07: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (E07) |
| WK-DMF0021-1570 | A1 | Edit (F2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Edit (F2): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Edit (F2)) |
| WK-DMF0021-1571 | A1 | Excel (F12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Excel (F12): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Excel (F12)) |
| WK-DMF0021-1572 | A1 | Filter/Sort/Condition/Reset | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Filter/Sort/Condition/Reset: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Filter/Sort/Condition/Reset) |
| WK-DMF0021-1573 | A1 | Find (F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Find (F5): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Find (F5)) |
| WK-DMF0021-1574 | A1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindData: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (HANDLER:FindData) |
| WK-DMF0021-1575 | A1 | Insert (F8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Insert (F8): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Insert (F8)) |
| WK-DMF0021-1576 | A1 | PKG_DMF0021.P_DMF0021_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0021.P_DMF0021_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0021.P_DMF0021_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 226 (ACT:DMF0021_SalesPlan.FindButton ACT:DMF) |
| WK-DMF0021-1577 | A1 | Save (F7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Save (F7): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Save (F7)) |
| WK-DMF0021-1578 | A1 | btnColumn/btnMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnColumn/btnMeasure: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (btnColumn/btnMeasure) |
| WK-DMF0021-1579 | A1 | btnProject/btnItemId/btnOwner | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnProject/btnItemId/btnOwner: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-1580 | A6 | 33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 33: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1581 | A6 | 39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 39: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (39) |
| WK-DMF0021-1582 | A6 | 40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 40: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (40) |
| WK-DMF0021-1583 | A6 | 41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 41: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (41) |
| WK-DMF0021-1584 | A6 | 42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 42: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (42) |
| WK-DMF0021-1585 | A6 | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 43: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (43) |
| WK-DMF0021-1586 | A6 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 9: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1587 | A6 | CB-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — CB-107: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (CB-107) |
| WK-DMF0021-1588 | A6 | CD-119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — CD-119: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (CD-119) |
| WK-DMF0021-1589 | A6 | CD-120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — CD-120: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (CD-120) |
| WK-DMF0021-1590 | A6 | CF-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — CF-02: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (CF-02) |
| WK-DMF0021-1591 | A6 | CRUD:E07:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — CRUD:E07:SEARCH: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E07:SEARCH) |
| WK-DMF0021-1592 | A6 | E07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — E07: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E07) |
| WK-DMF0021-1593 | A6 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — HANDLER:FindData: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0021-1594 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1595 | G1 | 113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 113: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (113) |
| WK-DMF0021-1596 | G1 | 114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 114: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (114) |
| WK-DMF0021-1597 | G1 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 14: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1598 | G1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 15: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1599 | G1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 17: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1600 | G1 | 18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 18: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1601 | G1 | 19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 19: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1602 | G1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 3: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1603 | G1 | 33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 33: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1604 | G1 | 37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 37: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1605 | G1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 4: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1606 | G1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 5: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1607 | G1 | 84 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 84: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (84) |
| WK-DMF0021-1608 | G1 | CA-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CA-102: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CA-102) |
| WK-DMF0021-1609 | G1 | CA-146 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CA-146: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CA-146) |
| WK-DMF0021-1610 | G1 | CA-147 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CA-147: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CA-147) |
| WK-DMF0021-1611 | G1 | CA-150 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CA-150: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CA-150) |
| WK-DMF0021-1612 | G1 | CA-156 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CA-156: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CA-156) |
| WK-DMF0021-1613 | G1 | CB-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CB-106: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CB-106) |
| WK-DMF0021-1614 | G1 | CB-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CB-107: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CB-107) |
| WK-DMF0021-1615 | G1 | CD-104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CD-104: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CD-104) |
| WK-DMF0021-1616 | G1 | CD-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CD-106: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CD-106) |
| WK-DMF0021-1617 | G1 | CD-108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CD-108: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CD-108) |
| WK-DMF0021-1618 | G1 | CD-116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CD-116: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CD-116) |
| WK-DMF0021-1619 | G1 | CD-131 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CD-131: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CD-131) |
| WK-DMF0021-1620 | G1 | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CELL_PROD_SITE_ID: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CELL_PROD_SITE_ID) |
| WK-DMF0021-1621 | G1 | CF-75 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CF-75: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CF-75) |
| WK-DMF0021-1622 | G1 | CRUD:E07:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:E07:SEARCH: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E07:SEARCH) |
| WK-DMF0021-1623 | G1 | Delete (F9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Delete (F9): 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Delete (F9)) |
| WK-DMF0021-1624 | G1 | E07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E07: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (E07) |
| WK-DMF0021-1625 | G1 | Edit (F2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Edit (F2): 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Edit (F2)) |
| WK-DMF0021-1626 | G1 | Excel (F12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Excel (F12): 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Excel (F12)) |
| WK-DMF0021-1627 | G1 | Filter/Sort/Condition/Reset | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Filter/Sort/Condition/Reset: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Filter/Sort/Condition/Reset) |
| WK-DMF0021-1628 | G1 | Find (F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Find (F5): 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Find (F5)) |
| WK-DMF0021-1629 | G1 | Insert (F8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Insert (F8): 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Insert (F8)) |
| WK-DMF0021-1630 | G1 | Save (F7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Save (F7): 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Save (F7)) |
| WK-DMF0021-1631 | G1 | btnColumn/btnMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnColumn/btnMeasure: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (btnColumn/btnMeasure) |
| WK-DMF0021-1632 | G1 | btnProject/btnItemId/btnOwner | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnProject/btnItemId/btnOwner: 행 집계 — G1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-1633 | G6 | 113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 113: 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (113) |
| WK-DMF0021-1634 | G6 | 114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 114: 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (114) |
| WK-DMF0021-1635 | G6 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 14: 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1636 | G6 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 15: 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1637 | G6 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 17: 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1638 | G6 | 18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 18: 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1639 | G6 | Delete (F9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Delete (F9): 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Delete (F9)) |
| WK-DMF0021-1640 | G6 | Edit (F2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Edit (F2): 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Edit (F2)) |
| WK-DMF0021-1641 | G6 | Excel (F12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Excel (F12): 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Excel (F12)) |
| WK-DMF0021-1642 | G6 | Filter/Sort/Condition/Reset | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Filter/Sort/Condition/Reset: 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Filter/Sort/Condition/Reset) |
| WK-DMF0021-1643 | G6 | Find (F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Find (F5): 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Find (F5)) |
| WK-DMF0021-1644 | G6 | Insert (F8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Insert (F8): 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Insert (F8)) |
| WK-DMF0021-1645 | G6 | Save (F7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Save (F7): 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Save (F7)) |
| WK-DMF0021-1646 | G6 | btnColumn/btnMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — btnColumn/btnMeasure: 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (btnColumn/btnMeasure) |
| WK-DMF0021-1647 | G6 | btnProject/btnItemId/btnOwner | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — btnProject/btnItemId/btnOwner: 행 집계 — G6 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (btnProject/btnItemId/btnOwner) |
| WK-DMF0021-1648 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-DMF0021-1649 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-DMF0021-1650 | X-LOC | 100 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 100: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1651 | X-LOC | 101 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 101: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (101) |
| WK-DMF0021-1652 | X-LOC | 102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 102: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (102) |
| WK-DMF0021-1653 | X-LOC | 103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 103: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (103) |
| WK-DMF0021-1654 | X-LOC | 104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 104: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (104) |
| WK-DMF0021-1655 | X-LOC | 105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 105: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (105) |
| WK-DMF0021-1656 | X-LOC | 106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 106: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (106) |
| WK-DMF0021-1657 | X-LOC | 107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 107: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (107) |
| WK-DMF0021-1658 | X-LOC | 108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 108: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (108) |
| WK-DMF0021-1659 | X-LOC | 109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 109: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (109) |
| WK-DMF0021-1660 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-DMF0021-1661 | X-LOC | 110 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 110: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (110) |
| WK-DMF0021-1662 | X-LOC | 111 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 111: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (111) |
| WK-DMF0021-1663 | X-LOC | 112 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 112: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1664 | X-LOC | 113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 113: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (113) |
| WK-DMF0021-1665 | X-LOC | 114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 114: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (114) |
| WK-DMF0021-1666 | X-LOC | 115 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 115: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (115) |
| WK-DMF0021-1667 | X-LOC | 116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 116: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (116) |
| WK-DMF0021-1668 | X-LOC | 117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 117: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (117) |
| WK-DMF0021-1669 | X-LOC | 118 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 118: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (118) |
| WK-DMF0021-1670 | X-LOC | 119 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 119: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (119) |
| WK-DMF0021-1671 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1672 | X-LOC | 120 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 120: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (120) |
| WK-DMF0021-1673 | X-LOC | 121 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 121: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (121) |
| WK-DMF0021-1674 | X-LOC | 122 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 122: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (122) |
| WK-DMF0021-1675 | X-LOC | 123 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 123: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (123) |
| WK-DMF0021-1676 | X-LOC | 124 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 124: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (124) |
| WK-DMF0021-1677 | X-LOC | 125 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 125: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (125) |
| WK-DMF0021-1678 | X-LOC | 126 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 126: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (126) |
| WK-DMF0021-1679 | X-LOC | 127 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 127: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (127) |
| WK-DMF0021-1680 | X-LOC | 128 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 128: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (128) |
| WK-DMF0021-1681 | X-LOC | 129 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 129: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (129) |
| WK-DMF0021-1682 | X-LOC | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1683 | X-LOC | 130 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 130: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (130) |
| WK-DMF0021-1684 | X-LOC | 131 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 131: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (131) |
| WK-DMF0021-1685 | X-LOC | 132 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 132: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (132) |
| WK-DMF0021-1686 | X-LOC | 133 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 133: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (133) |
| WK-DMF0021-1687 | X-LOC | 134 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 134: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (134) |
| WK-DMF0021-1688 | X-LOC | 135 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 135: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (135) |
| WK-DMF0021-1689 | X-LOC | 136 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 136: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (136) |
| WK-DMF0021-1690 | X-LOC | 137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 137: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (137) |
| WK-DMF0021-1691 | X-LOC | 138 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 138: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (138) |
| WK-DMF0021-1692 | X-LOC | 139 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 139: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (139) |
| WK-DMF0021-1693 | X-LOC | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1694 | X-LOC | 140 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 140: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (140) |
| WK-DMF0021-1695 | X-LOC | 141 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 141: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (141) |
| WK-DMF0021-1696 | X-LOC | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 15: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1697 | X-LOC | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1698 | X-LOC | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 17: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1699 | X-LOC | 18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 18: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1700 | X-LOC | 19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 19: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1701 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-DMF0021-1702 | X-LOC | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 20: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1703 | X-LOC | 21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 21: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1704 | X-LOC | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 22: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1705 | X-LOC | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 23: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1706 | X-LOC | 24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 24: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1707 | X-LOC | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 25: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1708 | X-LOC | 26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 26: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1709 | X-LOC | 27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 27: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (27) |
| WK-DMF0021-1710 | X-LOC | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 28: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (28) |
| WK-DMF0021-1711 | X-LOC | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 29: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1712 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-DMF0021-1713 | X-LOC | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 30: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1714 | X-LOC | 31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 31: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (31) |
| WK-DMF0021-1715 | X-LOC | 32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 32: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (32) |
| WK-DMF0021-1716 | X-LOC | 33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 33: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (33) |
| WK-DMF0021-1717 | X-LOC | 34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 34: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (34) |
| WK-DMF0021-1718 | X-LOC | 35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 35: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (35) |
| WK-DMF0021-1719 | X-LOC | 36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 36: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1720 | X-LOC | 37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 37: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1721 | X-LOC | 38 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 38: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (38) |
| WK-DMF0021-1722 | X-LOC | 39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 39: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (39) |
| WK-DMF0021-1723 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-DMF0021-1724 | X-LOC | 40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 40: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (40) |
| WK-DMF0021-1725 | X-LOC | 41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 41: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (41) |
| WK-DMF0021-1726 | X-LOC | 42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 42: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (42) |
| WK-DMF0021-1727 | X-LOC | 43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 43: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (43) |
| WK-DMF0021-1728 | X-LOC | 44 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 44: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1729 | X-LOC | 45 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 45: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (45) |
| WK-DMF0021-1730 | X-LOC | 46 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 46: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1731 | X-LOC | 47 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 47: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1732 | X-LOC | 48 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 48: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1733 | X-LOC | 49 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 49: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1734 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-DMF0021-1735 | X-LOC | 50 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 50: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1736 | X-LOC | 51 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 51: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1737 | X-LOC | 52 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 52: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1738 | X-LOC | 53 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 53: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1739 | X-LOC | 54 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 54: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1740 | X-LOC | 55 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 55: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1741 | X-LOC | 56 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 56: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1742 | X-LOC | 57 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 57: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1743 | X-LOC | 58 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 58: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1744 | X-LOC | 59 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 59: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (59) |
| WK-DMF0021-1745 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-DMF0021-1746 | X-LOC | 60 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 60: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (60) |
| WK-DMF0021-1747 | X-LOC | 61 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 61: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (61) |
| WK-DMF0021-1748 | X-LOC | 62 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 62: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (62) |
| WK-DMF0021-1749 | X-LOC | 63 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 63: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (63) |
| WK-DMF0021-1750 | X-LOC | 64 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 64: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (64) |
| WK-DMF0021-1751 | X-LOC | 65 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 65: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (65) |
| WK-DMF0021-1752 | X-LOC | 66 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 66: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (66) |
| WK-DMF0021-1753 | X-LOC | 67 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 67: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (67) |
| WK-DMF0021-1754 | X-LOC | 68 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 68: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (68) |
| WK-DMF0021-1755 | X-LOC | 69 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 69: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (69) |
| WK-DMF0021-1756 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-DMF0021-1757 | X-LOC | 70 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 70: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (70) |
| WK-DMF0021-1758 | X-LOC | 71 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 71: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (71) |
| WK-DMF0021-1759 | X-LOC | 72 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 72: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (72) |
| WK-DMF0021-1760 | X-LOC | 73 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 73: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (73) |
| WK-DMF0021-1761 | X-LOC | 74 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 74: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (74) |
| WK-DMF0021-1762 | X-LOC | 75 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 75: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (75) |
| WK-DMF0021-1763 | X-LOC | 76 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 76: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (76) |
| WK-DMF0021-1764 | X-LOC | 77 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 77: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (77) |
| WK-DMF0021-1765 | X-LOC | 78 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 78: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (78) |
| WK-DMF0021-1766 | X-LOC | 79 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 79: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (79) |
| WK-DMF0021-1767 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-DMF0021-1768 | X-LOC | 80 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 80: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (80) |
| WK-DMF0021-1769 | X-LOC | 81 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 81: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (81) |
| WK-DMF0021-1770 | X-LOC | 82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 82: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (82) |
| WK-DMF0021-1771 | X-LOC | 83 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 83: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (83) |
| WK-DMF0021-1772 | X-LOC | 84 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 84: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (84) |
| WK-DMF0021-1773 | X-LOC | 85 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 85: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (85) |
| WK-DMF0021-1774 | X-LOC | 86 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 86: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (86) |
| WK-DMF0021-1775 | X-LOC | 87 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 87: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (87) |
| WK-DMF0021-1776 | X-LOC | 88 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 88: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (88) |
| WK-DMF0021-1777 | X-LOC | 89 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 89: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (89) |
| WK-DMF0021-1778 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-DMF0021-1779 | X-LOC | 90 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 90: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (90) |
| WK-DMF0021-1780 | X-LOC | 91 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 91: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (91) |
| WK-DMF0021-1781 | X-LOC | 92 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 92: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (92) |
| WK-DMF0021-1782 | X-LOC | 93 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 93: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (93) |
| WK-DMF0021-1783 | X-LOC | 94 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 94: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (94) |
| WK-DMF0021-1784 | X-LOC | 95 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 95: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (95) |
| WK-DMF0021-1785 | X-LOC | 96 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 96: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (96) |
| WK-DMF0021-1786 | X-LOC | 97 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 97: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (97) |
| WK-DMF0021-1787 | X-LOC | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 98: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (98) |
| WK-DMF0021-1788 | X-LOC | 99 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 99: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (99) |
| WK-DMF0021-1789 | X-LOC | AsIncotermsEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AsIncotermsEdit: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AsIncotermsEdit) |
| WK-DMF0021-1790 | X-LOC | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BizTypeByDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BizTypeByDivision) |
| WK-DMF0021-1791 | X-LOC | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CELL_PROD_SITE_ID: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CELL_PROD_SITE_ID) |
| WK-DMF0021-1792 | X-LOC | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CurrencyList: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CurrencyList) |
| WK-DMF0021-1793 | X-LOC | CustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CustomsHandbook: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CustomsHandbook) |
| WK-DMF0021-1794 | X-LOC | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division) |
| WK-DMF0021-1795 | X-LOC | EndCustomerByDivisionDept | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EndCustomerByDivisionDept: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EndCustomerByDivisionDept) |
| WK-DMF0021-1796 | X-LOC | FromSiteByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FromSiteByDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FromSiteByDivision) |
| WK-DMF0021-1797 | X-LOC | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Measure: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Measure) |
| WK-DMF0021-1798 | X-LOC | SalesPlanItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SalesPlanItemId: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SalesPlanItemId) |
| WK-DMF0021-1799 | X-LOC | SiteByEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SiteByEndCustomer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SiteByEndCustomer) |
| WK-DMF0021-1800 | X-ROW | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0021-1801 | X-ROW | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 28: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0021-1802 | X-ROW | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 29: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0021-1803 | X-ROW | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 30: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0021-1804 | X-ROW | 31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 31: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0021-1805 | X-ROW | 32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 32: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0021-1806 | X-ROW | CA-101 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CA-101: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CA-101) |
| WK-DMF0021-1807 | X-ROW | CA-145 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CA-145: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CA-145) |
| WK-DMF0021-1808 | X-ROW | CA-148 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CA-148: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CA-148) |
| WK-DMF0021-1809 | X-ROW | CA-151 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CA-151: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CA-151) |
| WK-DMF0021-1810 | X-ROW | CA-152 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CA-152: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CA-152) |
| WK-DMF0021-1811 | X-ROW | CA-153 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CA-153: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CA-153) |
| WK-DMF0021-1812 | X-ROW | CA-154 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CA-154: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CA-154) |
| WK-DMF0021-1813 | X-ROW | CB-109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-109: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-109) |
| WK-DMF0021-1814 | X-ROW | CC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-01) |
| WK-DMF0021-1815 | X-ROW | CC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-03) |
| WK-DMF0021-1816 | X-ROW | CC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-05: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-05) |
| WK-DMF0021-1817 | X-ROW | CC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-06) |
| WK-DMF0021-1818 | X-ROW | CC-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-08) |
| WK-DMF0021-1819 | X-ROW | CC-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-09) |
| WK-DMF0021-1820 | X-ROW | CC-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-10) |
| WK-DMF0021-1821 | X-ROW | CC-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-11) |
| WK-DMF0021-1822 | X-ROW | CC-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-12) |
| WK-DMF0021-1823 | X-ROW | CC-122 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-122: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-122) |
| WK-DMF0021-1824 | X-ROW | CC-123 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-123: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-123) |
| WK-DMF0021-1825 | X-ROW | CC-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-14) |
| WK-DMF0021-1826 | X-ROW | CC-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-21) |
| WK-DMF0021-1827 | X-ROW | CC-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-22: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-22) |
| WK-DMF0021-1828 | X-ROW | CD-110 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CD-110: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CD-110) |
| WK-DMF0021-1829 | X-ROW | CD-133 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CD-133: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CD-133) |
| WK-DMF0021-1830 | X-ROW | CD-141 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CD-141: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CD-141) |
| WK-DMF0021-1831 | X-ROW | CD-143 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CD-143: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CD-143) |
| WK-DMF0021-1832 | X-ROW | CD-146 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CD-146: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CD-146) |
| WK-DMF0021-1833 | X-ROW | CE-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CE-106: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CE-106) |
| WK-DMF0021-1834 | X-ROW | CF-101 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-101: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-101) |
| WK-DMF0021-1835 | X-ROW | CF-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-102: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-102) |
| WK-DMF0021-1836 | X-ROW | CF-104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-104: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-104) |
| WK-DMF0021-1837 | X-ROW | CF-105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-105: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-105) |
| WK-DMF0021-1838 | X-ROW | CF-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-106: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-106) |
| WK-DMF0021-1839 | X-ROW | CF-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-107: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-107) |
| WK-DMF0021-1840 | X-ROW | CF-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-16: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-16) |
| WK-DMF0021-1841 | X-ROW | CF-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-17: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-17) |
| WK-DMF0021-1842 | X-ROW | CF-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-18: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-18) |
| WK-DMF0021-1843 | X-ROW | CF-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-19: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-19) |
| WK-DMF0021-1844 | X-ROW | CF-20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-20: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-20) |
| WK-DMF0021-1845 | X-ROW | CF-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-21) |
| WK-DMF0021-1846 | X-ROW | CF-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-22: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-22) |
| WK-DMF0021-1847 | X-ROW | CF-23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-23: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-23) |
| WK-DMF0021-1848 | X-ROW | CF-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-24: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-24) |
| WK-DMF0021-1849 | X-ROW | CF-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-25: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-25) |
| WK-DMF0021-1850 | X-ROW | CF-26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-26: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-26) |
| WK-DMF0021-1851 | X-ROW | CF-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-27: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-27) |
| WK-DMF0021-1852 | X-ROW | CF-28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-28: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-28) |
| WK-DMF0021-1853 | X-ROW | CF-29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-29: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-29) |
| WK-DMF0021-1854 | X-ROW | CF-30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-30: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-30) |
| WK-DMF0021-1855 | X-ROW | CF-31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-31: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-31) |
| WK-DMF0021-1856 | X-ROW | CF-32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-32: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-32) |
| WK-DMF0021-1857 | X-ROW | CF-33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-33: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-33) |
| WK-DMF0021-1858 | X-ROW | CF-34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-34: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-34) |
| WK-DMF0021-1859 | X-ROW | CF-35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-35: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-35) |
| WK-DMF0021-1860 | X-ROW | CF-36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-36: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-36) |
| WK-DMF0021-1861 | X-ROW | CF-37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-37: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-37) |
| WK-DMF0021-1862 | X-ROW | CF-38 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-38: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-38) |
| WK-DMF0021-1863 | X-ROW | CF-39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-39: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-39) |
| WK-DMF0021-1864 | X-ROW | CF-40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-40: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-40) |
| WK-DMF0021-1865 | X-ROW | CF-41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-41: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-41) |
| WK-DMF0021-1866 | X-ROW | CF-42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-42: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-42) |
| WK-DMF0021-1867 | X-ROW | CF-43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-43: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-43) |
| WK-DMF0021-1868 | X-ROW | CF-44 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-44: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-44) |
| WK-DMF0021-1869 | X-ROW | CF-45 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-45: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-45) |
| WK-DMF0021-1870 | X-ROW | CF-87 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-87: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-87) |
| WK-DMF0021-1871 | X-ROW | CF-88 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-88: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-88) |
| WK-DMF0021-1872 | X-ROW | CF-89 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-89: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-89) |
| WK-DMF0021-1873 | X-ROW | CF-91 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-91: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-91) |
| WK-DMF0021-1874 | X-ROW | CF-92 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-92: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-92) |
| WK-DMF0021-1875 | X-ROW | CF-93 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-93: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-93) |
| WK-DMF0021-1876 | X-ROW | CF-94 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-94: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-94) |
| WK-DMF0021-1877 | X-ROW | CF-95 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-95: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-95) |
| WK-DMF0021-1878 | X-ROW | CF-96 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-96: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-96) |
| WK-DMF0021-1879 | X-ROW | CF-98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-98: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-98) |
| WK-DMF0021-1880 | X-ROW | CG-00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CG-00: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CG-00) |
| WK-DMF0021-1881 | X-ROW | CG-108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CG-108: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CG-108) |
| WK-DMF0021-1882 | X-ROW | CG-109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CG-109: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CG-109) |
| WK-DMF0021-1883 | X-ROW | CG-110 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CG-110: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CG-110) |
| WK-DMF0021-1884 | X-ROW | CG-111 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CG-111: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CG-111) |
| WK-DMF0021-1885 | X-ROW | DMF0021_SalesPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.CreateSpread: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.CreateSpread) |
| WK-DMF0021-1886 | X-ROW | DMF0021_SalesPlan.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.DefineProperty: 진입점 집계 13검사 — NOT_RUN:11 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 14 (ACT:DMF0021_SalesPlan.DefineProperty:546) |
| WK-DMF0021-1887 | X-ROW | DMF0021_SalesPlan.Draw | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.Draw: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 136 (ACT:DMF0021_SalesPlan.Draw ACT:DMF0021_S) |
| WK-DMF0021-1888 | X-ROW | DMF0021_SalesPlan.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.Dsdm_Changed: 진입점 집계 6검사 — NOT_RUN:3 · REVIEW:3 |  | 6 (ACT:DMF0021_SalesPlan.Dsdm_Changed:3983:) |
| WK-DMF0021-1889 | X-ROW | DMF0021_SalesPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.EditButton: 진입점 집계 69검사 — NOT_RUN:63 · REVIEW:2 · NOPATH:2 · TODO:2 |  | 4 (ACT:DMF0021_SalesPlan.EditButton:834:40 ) |
| WK-DMF0021-1890 | X-ROW | DMF0021_SalesPlan.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 요소 검사 |  | 15 (ACT:DMF0021_SalesPlan.ExcelButton ACT:DM) |
| WK-DMF0021-1891 | X-ROW | DMF0021_SalesPlan.ExportExcel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.ExportExcel: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 113 (ACT:DMF0021_SalesPlan.ExportExcel ACT:DM) |
| WK-DMF0021-1892 | X-ROW | DMF0021_SalesPlan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:DMF0021_SalesPlan.FindButton) |
| WK-DMF0021-1893 | X-ROW | DMF0021_SalesPlan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.FindData: 진입점 집계 29검사 — NOT_RUN:27 · REVIEW:1 · PASS:1 |  | 23 (ACT:DMF0021_SalesPlan.FindData:1468:1 AC) |
| WK-DMF0021-1894 | X-ROW | DMF0021_SalesPlan.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.Form_Load) |
| WK-DMF0021-1895 | X-ROW | DMF0021_SalesPlan.GetBizTypebyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetBizTypebyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetBizTypebyDivisi) |
| WK-DMF0021-1896 | X-ROW | DMF0021_SalesPlan.GetBizTypebyDivisionAs | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetBizTypebyDivisionAsync: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetBizTypebyDivisi) |
| WK-DMF0021-1897 | X-ROW | DMF0021_SalesPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetBucketType: 진입점 집계 7검사 — NOPATH:3 · NOT_RUN:3 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetBucketType) |
| WK-DMF0021-1898 | X-ROW | DMF0021_SalesPlan.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetCellColor: 진입점 집계 3검사 — NOT_RUN:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetCellColor) |
| WK-DMF0021-1899 | X-ROW | DMF0021_SalesPlan.GetCustomerbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetCustomerbyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetCustomerbyDivis) |
| WK-DMF0021-1900 | X-ROW | DMF0021_SalesPlan.GetCustomerbyDivisionA | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetCustomerbyDivisionAsync: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetCustomerbyDivis) |
| WK-DMF0021-1901 | X-ROW | DMF0021_SalesPlan.GetCustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetCustomsHandbook: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetCustomsHandbook) |
| WK-DMF0021-1902 | X-ROW | DMF0021_SalesPlan.GetDataTableMeargeForD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetDataTableMeargeForDate: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetDataTableMearge) |
| WK-DMF0021-1903 | X-ROW | DMF0021_SalesPlan.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetDayRange) |
| WK-DMF0021-1904 | X-ROW | DMF0021_SalesPlan.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetDivision) |
| WK-DMF0021-1905 | X-ROW | DMF0021_SalesPlan.GetEndCustomerbyDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetEndCustomerbyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetEndCustomerbyDi) |
| WK-DMF0021-1906 | X-ROW | DMF0021_SalesPlan.GetFcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetFcstType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetFcstType) |
| WK-DMF0021-1907 | X-ROW | DMF0021_SalesPlan.GetIncotermsType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetIncotermsType: 진입점 집계 7검사 — NOPATH:3 · TODO:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetIncotermsType) |
| WK-DMF0021-1908 | X-ROW | DMF0021_SalesPlan.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetItemType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetItemType) |
| WK-DMF0021-1909 | X-ROW | DMF0021_SalesPlan.GetLookupValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetLookupValues: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetLookupValues) |
| WK-DMF0021-1910 | X-ROW | DMF0021_SalesPlan.GetPlantSitebyEndCusto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetPlantSitebyEndCustomer: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetPlantSitebyEndC) |
| WK-DMF0021-1911 | X-ROW | DMF0021_SalesPlan.GetPlantSitebyEndCusto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetPlantSitebyEndCustomerAsync: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetPlantSitebyEndC) |
| WK-DMF0021-1912 | X-ROW | DMF0021_SalesPlan.GetSALESPLAN_MEASUREIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetSALESPLAN_MEASUREInfo: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetSALESPLAN_MEASU) |
| WK-DMF0021-1913 | X-ROW | DMF0021_SalesPlan.GetSALESPLAN_MEASUREIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetSALESPLAN_MEASUREInfo2: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetSALESPLAN_MEASU) |
| WK-DMF0021-1914 | X-ROW | DMF0021_SalesPlan.GetScmSitebyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetScmSitebyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetScmSitebyDivisi) |
| WK-DMF0021-1915 | X-ROW | DMF0021_SalesPlan.GetScmSitebyDivisionAs | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetScmSitebyDivisionAsync: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetScmSitebyDivisi) |
| WK-DMF0021-1916 | X-ROW | DMF0021_SalesPlan.GetTeambyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetTeambyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetTeambyDivision) |
| WK-DMF0021-1917 | X-ROW | DMF0021_SalesPlan.GetTeambyDivisionAsync | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetTeambyDivisionAsync: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetTeambyDivisionA) |
| WK-DMF0021-1918 | X-ROW | DMF0021_SalesPlan.GetThisWeekMonday | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.GetThisWeekMonday: 진입점 집계 4검사 — NOPATH:2 · TODO:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.GetThisWeekMonday) |
| WK-DMF0021-1919 | X-ROW | DMF0021_SalesPlan.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.InitControls: 진입점 집계 37검사 — NOT_RUN:35 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 32 (ACT:DMF0021_SalesPlan.InitControls:431:2) |
| WK-DMF0021-1920 | X-ROW | DMF0021_SalesPlan.InitSaveDataTable | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.InitSaveDataTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.InitSaveDataTable) |
| WK-DMF0021-1921 | X-ROW | DMF0021_SalesPlan.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.InitSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0021_SalesPlan.InitSpread ACT:DMF) |
| WK-DMF0021-1922 | X-ROW | DMF0021_SalesPlan.InitSpreadFooterSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.InitSpreadFooterSum: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0021_SalesPlan.InitSpreadFooterSu) |
| WK-DMF0021-1923 | X-ROW | DMF0021_SalesPlan.InitSpread_X | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.InitSpread_X: 진입점 집계 7검사 — NOT_RUN:6 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:DMF0021_SalesPlan.InitSpread_X:458:1) |
| WK-DMF0021-1924 | X-ROW | DMF0021_SalesPlan.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.InsertButton) |
| WK-DMF0021-1925 | X-ROW | DMF0021_SalesPlan.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.InsertRow: 진입점 집계 134검사 — NOT_RUN:107 · NOPATH:25 · TODO:2 (미실행 검사가 남아 판정필요) |  | 310 (ACT:DMF0021_SalesPlan.InsertRow ACT:DMF0) |
| WK-DMF0021-1926 | X-ROW | DMF0021_SalesPlan.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.SaveData: 진입점 집계 18검사 — NOT_RUN:14 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0021_SalesPlan.SaveData:2270:128 ) |
| WK-DMF0021-1927 | X-ROW | DMF0021_SalesPlan.SaveData_All | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.SaveData_All: 진입점 집계 7검사 — NOT_RUN:4 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0021_SalesPlan.SaveData_All:1150:) |
| WK-DMF0021-1928 | X-ROW | DMF0021_SalesPlan.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.SetChangeControl: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:2 |  | 7 (ACT:DMF0021_SalesPlan.SetChangeControl:3) |
| WK-DMF0021-1929 | X-ROW | DMF0021_SalesPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.SetSpreadColumn: 진입점 집계 30검사 — NOT_RUN:24 · REVIEW:6 |  | 21 (ACT:DMF0021_SalesPlan.SetSpreadColumn:36) |
| WK-DMF0021-1930 | X-ROW | DMF0021_SalesPlan.SetSpreadHeaderSpan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.SetSpreadHeaderSpan: 진입점 집계 12검사 — REVIEW:6 · NOT_RUN:6 |  | 2 (ACT:DMF0021_SalesPlan.SetSpreadHeaderSpa) |
| WK-DMF0021-1931 | X-ROW | DMF0021_SalesPlan.btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.btnColumn_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.btnColumn_Click:44) |
| WK-DMF0021-1932 | X-ROW | DMF0021_SalesPlan.btnCutOff_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.btnCutOff_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.btnCutOff_Click:29) |
| WK-DMF0021-1933 | X-ROW | DMF0021_SalesPlan.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.btnItemId_Click:35) |
| WK-DMF0021-1934 | X-ROW | DMF0021_SalesPlan.btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.btnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.btnMeasure_Click:4) |
| WK-DMF0021-1935 | X-ROW | DMF0021_SalesPlan.btnOwner_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.btnOwner_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0021_SalesPlan.btnOwner_Click:550) |
| WK-DMF0021-1936 | X-ROW | DMF0021_SalesPlan.btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.btnProject_Click: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.btnProject_Click:3) |
| WK-DMF0021-1937 | X-ROW | DMF0021_SalesPlan.cboBucketType_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.cboBucketType_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0021_SalesPlan.cboBucketType_Sele) |
| WK-DMF0021-1938 | X-ROW | DMF0021_SalesPlan.cboKRW_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.cboKRW_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.cboKRW_SelectedInd) |
| WK-DMF0021-1939 | X-ROW | DMF0021_SalesPlan.cboLOC_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.cboLOC_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.cboLOC_SelectedInd) |
| WK-DMF0021-1940 | X-ROW | DMF0021_SalesPlan.cboUSD_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.cboUSD_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.cboUSD_SelectedInd) |
| WK-DMF0021-1941 | X-ROW | DMF0021_SalesPlan.chkColor_CheckedChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.chkColor_CheckedChanged: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.chkColor_CheckedCh) |
| WK-DMF0021-1942 | X-ROW | DMF0021_SalesPlan.chkSum_CheckedChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.chkSum_CheckedChan) |
| WK-DMF0021-1943 | X-ROW | DMF0021_SalesPlan.clbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.clbDivision_SelectedIndexChanged: 진입점 집계 13검사 — NOT_RUN:8 · REVIEW:3 · NOPATH:1 · TODO:1 |  | 7 (ACT:DMF0021_SalesPlan.clbDivision_Select) |
| WK-DMF0021-1944 | X-ROW | DMF0021_SalesPlan.clbTeam_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.clbTeam_SelectedIndexChanged: 진입점 집계 12검사 — NOT_RUN:6 · NOPATH:3 · TODO:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0021_SalesPlan.clbTeam_SelectedIn) |
| WK-DMF0021-1945 | X-ROW | DMF0021_SalesPlan.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLAG/FLOW/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 106 (ACT:DMF0021_SalesPlan.fnValidation ACT:D) |
| WK-DMF0021-1946 | X-ROW | DMF0021_SalesPlan.spdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.spdMain_CellDoubleClick: 진입점 집계 22검사 — NOT_RUN:18 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 28 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-1947 | X-ROW | DMF0021_SalesPlan.spdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.spdMain_ComboSelChange: 진입점 집계 104검사 — NOT_RUN:65 · NOPATH:28 · TODO:8 · REVIEW:3 |  | 57 (ACT:DMF0021_SalesPlan.spdMain_ComboSelCh) |
| WK-DMF0021-1948 | X-ROW | DMF0021_SalesPlan.spdMain_EnterCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.spdMain_EnterCell: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/FLAG/LOCAL, 연결된 요소 검사 없음 |  | 11 (ACT:DMF0021_SalesPlan.spdMain_EnterCell ) |
| WK-DMF0021-1949 | X-ROW | DMF0021_SalesPlan.spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.spdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 15 (ACT:DMF0021_SalesPlan.spdMain_KeyUp ACT:) |
| WK-DMF0021-1950 | X-ROW | DMF0021_SalesPlan.spdMain_LeaveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.spdMain_LeaveCell: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/FLAG/FLOW/GRID_SE |  | 36 (ACT:DMF0021_SalesPlan.spdMain_LeaveCell ) |
| WK-DMF0021-1951 | X-ROW | DMF0021_SalesPlan.spdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0021_SalesPlan.spdMain_TopChange ) |
| WK-DMF0021-1952 | X-ROW | DMF0021_SalesPlan.txtItemId_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.txtItemId_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0021_SalesPlan.txtItemId_KeyDown ) |
| WK-DMF0021-1953 | X-ROW | DMF0021_SalesPlan.txtProject_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0021_SalesPlan.txtProject_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0021_SalesPlan.txtProject_KeyDown) |
| WK-DMF0021-1954 | X-ROW | HANDLER:InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:InsertRow) |
| WK-DMF0021-1955 | X-ROW | HANDLER:btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnColumn_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnColumn_Click) |
| WK-DMF0021-1956 | X-ROW | HANDLER:btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnMeasure_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnMeasure_Click) |
| WK-DMF0021-1957 | X-ROW | HANDLER:btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnProject_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnProject_Click) |
| WK-DMF0021-1958 | X-ROW | HANDLER:spdMain_EnterCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:spdMain_EnterCell: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:spdMain_EnterCell) |
| WK-DMF0021-1959 | X-ROW | HANDLER:txtItemId_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:txtItemId_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:txtItemId_KeyDown) |
| WK-DMF0021-1960 | X-ROW | HANDLER:txtProject_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:txtProject_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:txtProject_KeyDown) |
| WK-DMF0021-1961 | X-ROW | MODAL:MeasureSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:MeasureSelectModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0021-1962 | G5 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 13: 행 집계 — G5 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1963 | G5 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 14: 행 집계 — G5 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1964 | G5 | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 98: 행 집계 — G5 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (98) |
| WK-DMF0021-1965 | G5 | CA-158 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — CA-158: 행 집계 — G5 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (CA-158) |
| WK-DMF0021-1966 | G5 | CC-114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — CC-114: 행 집계 — G5 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (CC-114) |
| WK-DMF0021-1967 | G5 | DMF0021_SalesPlan.spdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0021_SalesPlan.spdMain_CellDoubleClick: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 54 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-1968 | G5 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E08: 행 집계 — G5 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0021-1969 | G5 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — G5 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0021-1970 | G5 | MODAL:SalesPlanModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:SalesPlanModals: 행 집계 — G5 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:SalesPlanModals) |
| WK-DMF0021-1971 | G5 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ShowDialog: 행 집계 — G5 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-DMF0021-1972 | H6 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 13: 행 집계 — H6 14요소: NOPATH:10 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1973 | H6 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 14: 행 집계 — H6 14요소: NOPATH:10 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1974 | H6 | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 98: 행 집계 — H6 14요소: NOPATH:10 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (98) |
| WK-DMF0021-1975 | H6 | CA-158 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — CA-158: 행 집계 — H6 14요소: NOPATH:10 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (CA-158) |
| WK-DMF0021-1976 | H6 | CC-114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — CC-114: 행 집계 — H6 14요소: NOPATH:10 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (CC-114) |
| WK-DMF0021-1977 | H6 | DMF0021_SalesPlan.spdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0021_SalesPlan.spdMain_CellDoubleClick: 진입점 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 54 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-1978 | H6 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E08: 행 집계 — H6 14요소: NOPATH:10 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0021-1979 | H6 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — H6 14요소: NOPATH:10 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0021-1980 | H6 | MODAL:SalesPlanModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:SalesPlanModals: 행 집계 — H6 14요소: NOPATH:10 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:SalesPlanModals) |
| WK-DMF0021-1981 | H6 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ShowDialog: 행 집계 — H6 14요소: NOPATH:10 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-DMF0021-1982 | M4 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 13: 행 집계 — M4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1983 | M4 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 14: 행 집계 — M4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0021-1984 | M4 | 98 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 98: 행 집계 — M4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (98) |
| WK-DMF0021-1985 | M4 | CA-158 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — CA-158: 행 집계 — M4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (CA-158) |
| WK-DMF0021-1986 | M4 | CC-114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — CC-114: 행 집계 — M4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (CC-114) |
| WK-DMF0021-1987 | M4 | DMF0021_SalesPlan.spdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0021_SalesPlan.spdMain_CellDoubleClick: 진입점 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 54 (ACT:DMF0021_SalesPlan.spdMain_CellDouble) |
| WK-DMF0021-1988 | M4 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E08: 행 집계 — M4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0021-1989 | M4 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — M4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0021-1990 | M4 | MODAL:SalesPlanModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:SalesPlanModals: 행 집계 — M4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:SalesPlanModals) |
| WK-DMF0021-1991 | M4 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ShowDialog: 행 집계 — M4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
