# 작업 원장 — SCP0001 · 2026-10-26 12:52

> 검사 인스턴스 700건 중 PASS·NA 25건 외 **675건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 35 | 구현 위치 실존 |
| W4 | 검사기 구현 | 4 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 34 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 281 | 실행 → PASS |
| W7 | 기대값 확정 | 312 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 8 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 311 · E2E 281 · 하네스 38 · 대조표 36 · 선행 W1 완료 후 E2E 7 · FE 1 · 선행 W1 완료 후 검증 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| E4 | EDIT |  |  |  |  |  | 40 | 15 | 1 |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-LOC | GEN |  | 35 |  |  |  |  | 15 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| C3 | CASCADE |  |  |  |  |  | 35 | 14 |  |  | 연쇄 자동 채움 |
| X-ROW | GEN |  |  |  |  |  |  | 39 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A5 | DESIGN |  |  |  |  |  | 13 | 23 | 1 |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 11 | 24 | 1 |  | 배경·글자색 규칙 |
| D1 | EDIT |  |  |  |  |  | 24 | 12 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 24 | 12 |  |  | 행 값 기반 조건부 잠금 |
| H5 | DESIGN |  |  |  |  |  | 11 | 23 | 1 |  | 라벨 명칭 |
| C2 | CASCADE |  |  |  |  |  | 24 | 10 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 24 | 10 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G1 | GEN |  |  |  |  |  | 5 | 23 | 1 |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 27 | 1 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| M4 | POPUP |  |  |  |  |  | 15 | 7 |  |  | 팝업 선택값 반영 |
| E3 | EDIT |  |  |  |  |  | 1 | 16 | 1 |  | 필수 입력 검증 |
| G5 | POPUP |  |  |  |  | 5 |  | 7 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 4 | 1 | 7 |  |  | 팝업 표준·열림 |
| D5 | EDIT |  |  |  |  |  | 9 | 3 |  |  | 셀 에디터 유형 |
| B4 | COMBO |  |  |  |  | 8 |  | 3 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| E1 | EDIT |  |  |  |  |  | 7 | 3 |  |  | 숫자 소수자리·정수·부호·범위 |
| B1 | COMBO |  |  |  |  | 6 |  | 2 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 6 |  | 2 |  |  | 콤보 후보 중복 없음 |
| F4 | DB |  |  |  |  |  | 8 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G4 | DESIGN |  |  |  |  |  | 3 | 5 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 3 | 5 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| D4 | EDIT |  |  |  |  |  | 3 | 3 | 1 |  | 신규행 기본값·자동세팅·Insert 전제 |
| B3 | COMBO |  |  |  | 4 |  |  | 1 |  |  | 콤보 후보 정렬 = AS-IS |
| A6 | GEN |  |  |  |  |  | 4 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C1 | CASCADE |  |  |  |  |  | 3 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| DB-SYN | DB |  |  |  |  | 2 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
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

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0001-0001 | X-NOTIMPL | COMMON:UC-03 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) `nscm-fe/packages/ |  | 1 (COMMON:UC-03) |

## W2 구현 위치 확인 (35)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0001-0002 | X-LOC | ALL → 권한 division 콤마 확장(권한 함정) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ALL → 권한 division 콤마 확장(권한 함정)) |
| WK-SCP0001-0003 | X-LOC | COMMON:UC-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx 없음 |  | 1 (COMMON:UC-01) |
| WK-SCP0001-0004 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/packages/shared/src/stores/useDirtyRegistry.ts 없음, nscm-fe/packages/shared/src/components/ |  | 1 (COMMON:UC-02) |
| WK-SCP0001-0005 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/packages/shared/src/hooks/useCustomQueryClient.ts 없음 |  | 1 (COMMON:UC-04) |
| WK-SCP0001-0006 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/packages/foundation/src/utils/gridAction.ts 없음 |  | 1 (COMMON:UC-05) |
| WK-SCP0001-0007 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx 없음 |  | 1 (COMMON:UC-07) |
| WK-SCP0001-0008 | X-LOC | Division 다중 + EE 필터 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Division 다중 + EE 필터) |
| WK-SCP0001-0009 | X-LOC | OSP/Active YesOrNo + ALL sentinel | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (OSP/Active YesOrNo + ALL sentinel) |
| WK-SCP0001-0010 | X-LOC | Plant/Vendor·Plant Site 텍스트(UPPER LIKE) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Plant/Vendor·Plant Site 텍스트(UPPER LIKE)) |
| WK-SCP0001-0011 | X-LOC | R-05 Warranty 특례 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0012 | X-LOC | R-06① main dirty↔sub 배타(G6) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-06① main dirty↔sub 배타(G6)) |
| WK-SCP0001-0013 | X-LOC | R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0014 | X-LOC | R-10 locationOsp 신규행 SITE_DESCRIPTION 마스 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-10 locationOsp 신규행 SITE_DESCRIPTION 마스) |
| WK-SCP0001-0015 | X-LOC | R-11~14 Location cascade/배타 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0016 | X-LOC | R-15 customer div→site 재조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-15 customer div→site 재조회) |
| WK-SCP0001-0017 | X-LOC | R-16 osp plant→storage 재조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-16 osp plant→storage 재조회) |
| WK-SCP0001-0018 | X-LOC | R-17 Vendor 팝업(신규행 PLANT_NAME) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-17 Vendor 팝업(신규행 PLANT_NAME)) |
| WK-SCP0001-0019 | X-LOC | R-18 HQ Vendor 팝업 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-18 HQ Vendor 팝업) |
| WK-SCP0001-0020 | X-LOC | R-20 City 팝업 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-20 City 팝업) |
| WK-SCP0001-0021 | X-LOC | R-21 SCM_SITE_ID 재파생 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-21 SCM_SITE_ID 재파생) |
| WK-SCP0001-0022 | X-LOC | R-22/23 packer 행잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-22/23 packer 행잠금) |
| WK-SCP0001-0023 | X-LOC | R-24 PROD_FROZEN→FP_PLAN_PERIOD | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-24 PROD_FROZEN→FP_PLAN_PERIOD) |
| WK-SCP0001-0024 | X-LOC | R-25 HQ 클리어 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0025 | X-LOC | R-26 REP 단일성 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-26 REP 단일성) |
| WK-SCP0001-0026 | X-LOC | R-27/28 Customer 팝업+중복 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-27/28 Customer 팝업+중복) |
| WK-SCP0001-0027 | X-LOC | R-31 붙여넣기 name→code(G4) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0028 | X-LOC | R-32 편집 중 탭 전환 차단(G8) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-32 편집 중 탭 전환 차단(G8)) |
| WK-SCP0001-0029 | X-LOC | R-33 Location 필수(G1) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-33 Location 필수(G1)) |
| WK-SCP0001-0030 | X-LOC | R-34 Location 중복(G2) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-34 Location 중복(G2)) |
| WK-SCP0001-0031 | X-LOC | R-38 customer 신규필수(G3) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-38 customer 신규필수(G3)) |
| WK-SCP0001-0032 | X-LOC | SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP) |
| WK-SCP0001-0033 | X-LOC | SAVE_PLANT_SITE (vmiYn='N', FlagD→validY | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SAVE_PLANT_SITE (vmiYn='N', FlagD→validY) |
| WK-SCP0001-0034 | X-LOC | p_new_yn 항상 null | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (p_new_yn 항상 null) |
| WK-SCP0001-0035 | X-LOC | site.DIVISION_ID 셀 EE 필터(G7) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (site.DIVISION_ID 셀 EE 필터(G7)) |
| WK-SCP0001-0036 | X-LOC | 셀 병합(G10) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (셀 병합(G10)) |

## W4 검사기 구현 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0001-0037 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (site.DIVISION_ID 셀 EE 필터(G7)) |
| WK-SCP0001-0038 | B3 | FP_PLAN_PERIOD | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FP_PLAN_PERIOD | 있음(SHEET_COLUMNS) | 1 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0039 | B3 | LINK_PLANT_SITE_CODE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 LINK_PLANT_SITE_CODE | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0040 | B3 | PROD_FROZEN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PROD_FROZEN | 있음(SHEET_COLUMNS) | 1 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |

## W5 검사기 연결 (34)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0001-0041 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0001_PlantSite.InsertRow:1437:5 A) |
| WK-SCP0001-0042 | B1 | LINK_PLANT_SITE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL LINK_PLANT_SITE_CODE | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0043 | B1 | LOGISTIC_PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL LOGISTIC_PLANT_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SetWarranty:717:5) |
| WK-SCP0001-0044 | B1 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SetWarranty:716:4) |
| WK-SCP0001-0045 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0001_PlantSite.Dsdm_Changed:1599:) |
| WK-SCP0001-0046 | B1 | STORAGE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL STORAGE_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SpdSub_ComboSelCha) |
| WK-SCP0001-0047 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0001_PlantSite.InsertRow:1437:5 A) |
| WK-SCP0001-0048 | B2 | LINK_PLANT_SITE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL LINK_PLANT_SITE_CODE | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0049 | B2 | LOGISTIC_PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL LOGISTIC_PLANT_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SetWarranty:717:5) |
| WK-SCP0001-0050 | B2 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SetWarranty:716:4) |
| WK-SCP0001-0051 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0001_PlantSite.Dsdm_Changed:1599:) |
| WK-SCP0001-0052 | B2 | STORAGE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL STORAGE_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SpdSub_ComboSelCha) |
| WK-SCP0001-0053 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (site.DIVISION_ID 셀 EE 필터(G7) ACT:SCP0001) |
| WK-SCP0001-0054 | B4 | FP_PLAN_PERIOD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FP_PLAN_PERIOD | 있음(SHEET_COLUMNS) | 1 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0055 | B4 | LINK_PLANT_SITE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LINK_PLANT_SITE_CODE | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0056 | B4 | LOGISTIC_PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LOGISTIC_PLANT_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SetWarranty:717:5) |
| WK-SCP0001-0057 | B4 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SetWarranty:716:4) |
| WK-SCP0001-0058 | B4 | PROD_FROZEN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PROD_FROZEN | 있음(SHEET_COLUMNS) | 1 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0059 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0001_PlantSite.Dsdm_Changed:1599:) |
| WK-SCP0001-0060 | B4 | STORAGE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL STORAGE_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0001_PlantSite.SpdSub_ComboSelCha) |
| WK-SCP0001-0061 | F2 | SCP0001 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0001 화면 | 판단불가(대상 단위 SCREEN) | 329 (COMMON:UC-03 COMMON:UC-04 R-33 Location ) |
| WK-SCP0001-0062 | F6 | SCP0001 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0001 화면 | 판단불가(대상 단위 SCREEN) | 322 (ACT:SCP0001_PlantSite.SaveButton ACT:SCP) |
| WK-SCP0001-0063 | DB-SYN | DM0004_GET_SALES_SITE_CUSTOMER_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0004_GET_SALES_SITE_CUSTOMER_DATA | 없음(PROC_M 대응 없음) | 6 (ACT:SCP0001_PlantSite.FindData_SubCustom) |
| WK-SCP0001-0064 | DB-SYN | SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA | 없음(PROC_M 대응 없음) | 5 (ACT:SCP0001_PlantSite.SaveData:1006:73 A) |
| WK-SCP0001-0065 | G03-WIRE | SCP0001 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0001 화면 | 판단불가(대상 단위 SCREEN) | 22 (ACT:SCP0001_PlantSite..ctor ACT:SCP0001_) |
| WK-SCP0001-0066 | G5 | CITY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL CITY | 있음(SHEET_COLUMNS) | 11 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0067 | G5 | COUNTRY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL COUNTRY | 있음(SHEET_COLUMNS) | 12 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0068 | G5 | HQ_VENDOR_CODE_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL HQ_VENDOR_CODE_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0069 | G5 | PLANT_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PLANT_NAME | 있음(SHEET_COLUMNS) | 3 (R-17 Vendor 팝업(신규행 PLANT_NAME) ACT:SCP00) |
| WK-SCP0001-0070 | G5 | cboValid / Valid / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboValid / Valid / Active | 있음(FE 소스) | 3 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0071 | H6 | CITY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CITY | 있음(SHEET_COLUMNS) | 11 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0072 | H6 | COUNTRY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL COUNTRY | 있음(SHEET_COLUMNS) | 12 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0073 | H6 | HQ_VENDOR_CODE_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL HQ_VENDOR_CODE_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0074 | H6 | PLANT_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PLANT_NAME | 있음(SHEET_COLUMNS) | 3 (R-17 Vendor 팝업(신규행 PLANT_NAME) ACT:SCP00) |

## W6 검증 실행 (281)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0001-0075 | J2 | SCP0001 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0001 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 46 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0001-0076 | C1 | cboOutsourcing / Outsourcing / OSP | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOutsourcing / Outsourcing / OSP · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InitControls:266:6) |
| WK-SCP0001-0077 | C1 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InitControls:267:7) |
| WK-SCP0001-0078 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InitControls:263:4) |
| WK-SCP0001-0079 | C2 | BUILDING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — BUILDING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0080 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 27 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0081 | C2 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0082 | C2 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0083 | C2 | FACTORY_ID2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FACTORY_ID2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 20 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0084 | C2 | FP_PLAN_PERIOD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FP_PLAN_PERIOD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (R-24 PROD_FROZEN→FP_PLAN_PERIOD ACT:SCP0) |
| WK-SCP0001-0085 | C2 | HQ_VENDOR_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — HQ_VENDOR_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.spdMainDsdm_Change) |
| WK-SCP0001-0086 | C2 | HQ_VENDOR_CODE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — HQ_VENDOR_CODE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.spdMainDsdm_Change) |
| WK-SCP0001-0087 | C2 | LOCATION_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LOCATION_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0088 | C2 | LOCATION_CODE2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LOCATION_CODE2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 14 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0089 | C2 | LOCATION_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LOCATION_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0090 | C2 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 22 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0091 | C2 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0092 | C2 | OPERATION_ID2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPERATION_ID2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 16 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0093 | C2 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0094 | C2 | PACKER_ITEM_ID_SUFFIX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PACKER_ITEM_ID_SUFFIX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0095 | C2 | PACKER_LINE_ACTIVE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PACKER_LINE_ACTIVE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0096 | C2 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (R-16 osp plant→storage 재조회 ACT:SCP0001_P) |
| WK-SCP0001-0097 | C2 | PROD_FROZEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROD_FROZEN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (R-24 PROD_FROZEN→FP_PLAN_PERIOD ACT:SCP0) |
| WK-SCP0001-0098 | C2 | REP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — REP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (R-26 REP 단일성 ACT:SCP0001_PlantSite.shtCu) |
| WK-SCP0001-0099 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (R-21 SCM_SITE_ID 재파생 ACT:SCP0001_PlantSi) |
| WK-SCP0001-0100 | C2 | SHIP_TO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SHIP_TO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.shtCustomerDataMod) |
| WK-SCP0001-0101 | C2 | SOLD_TO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SOLD_TO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.shtCustomerDataMod) |
| WK-SCP0001-0102 | C2 | STORAGE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — STORAGE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 23 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0103 | C3 | BUILDING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BUILDING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0104 | C3 | CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0105 | C3 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0106 | C3 | COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0107 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 29 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0108 | C3 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0109 | C3 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0110 | C3 | FACTORY_ID2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FACTORY_ID2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 23 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0111 | C3 | FP_PLAN_PERIOD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FP_PLAN_PERIOD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (R-24 PROD_FROZEN→FP_PLAN_PERIOD ACT:SCP0) |
| WK-SCP0001-0112 | C3 | HQ_VENDOR_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — HQ_VENDOR_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0113 | C3 | HQ_VENDOR_CODE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — HQ_VENDOR_CODE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0114 | C3 | LOCATION_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LOCATION_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0115 | C3 | LOCATION_CODE2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LOCATION_CODE2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 18 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0116 | C3 | LOCATION_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LOCATION_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0117 | C3 | LOGISTIC_PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LOGISTIC_PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.SetWarranty ACT:SC) |
| WK-SCP0001-0118 | C3 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 27 (ACT:SCP0001_PlantSite.SetWarranty ACT:SC) |
| WK-SCP0001-0119 | C3 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0120 | C3 | OPERATION_ID2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_ID2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 19 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0121 | C3 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0122 | C3 | PACKER_ITEM_ID_SUFFIX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PACKER_ITEM_ID_SUFFIX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0123 | C3 | PACKER_LINE_ACTIVE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PACKER_LINE_ACTIVE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0124 | C3 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (R-16 osp plant→storage 재조회 ACT:SCP0001_P) |
| WK-SCP0001-0125 | C3 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0126 | C3 | PROD_FROZEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROD_FROZEN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (R-24 PROD_FROZEN→FP_PLAN_PERIOD ACT:SCP0) |
| WK-SCP0001-0127 | C3 | REP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (R-26 REP 단일성 ACT:SCP0001_PlantSite.Inser) |
| WK-SCP0001-0128 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (R-21 SCM_SITE_ID 재파생 ACT:SCP0001_PlantSi) |
| WK-SCP0001-0129 | C3 | SHIP_TO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIP_TO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0001_PlantSite.FindData_SubCustom) |
| WK-SCP0001-0130 | C3 | SHIP_TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIP_TO_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0131 | C3 | SHIP_TO_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIP_TO_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0132 | C3 | SHIP_TO_REGION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIP_TO_REGION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0133 | C3 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InsertRow:1514:59) |
| WK-SCP0001-0134 | C3 | SOLD_TO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SOLD_TO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 17 (ACT:SCP0001_PlantSite.FindData_SubCustom) |
| WK-SCP0001-0135 | C3 | SOLD_TO_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SOLD_TO_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0136 | C3 | STORAGE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — STORAGE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 26 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0137 | C3 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.InsertRow:1508:55 ) |
| WK-SCP0001-0138 | C6 | BUILDING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — BUILDING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0139 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 27 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0140 | C6 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0141 | C6 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0142 | C6 | FACTORY_ID2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FACTORY_ID2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 20 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0143 | C6 | FP_PLAN_PERIOD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FP_PLAN_PERIOD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (R-24 PROD_FROZEN→FP_PLAN_PERIOD ACT:SCP0) |
| WK-SCP0001-0144 | C6 | HQ_VENDOR_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — HQ_VENDOR_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.spdMainDsdm_Change) |
| WK-SCP0001-0145 | C6 | HQ_VENDOR_CODE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — HQ_VENDOR_CODE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.spdMainDsdm_Change) |
| WK-SCP0001-0146 | C6 | LOCATION_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LOCATION_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0147 | C6 | LOCATION_CODE2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LOCATION_CODE2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 14 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0148 | C6 | LOCATION_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LOCATION_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0149 | C6 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 22 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0150 | C6 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0151 | C6 | OPERATION_ID2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPERATION_ID2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 16 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0152 | C6 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0153 | C6 | PACKER_ITEM_ID_SUFFIX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PACKER_ITEM_ID_SUFFIX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0154 | C6 | PACKER_LINE_ACTIVE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PACKER_LINE_ACTIVE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0155 | C6 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (R-16 osp plant→storage 재조회 ACT:SCP0001_P) |
| WK-SCP0001-0156 | C6 | PROD_FROZEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROD_FROZEN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (R-24 PROD_FROZEN→FP_PLAN_PERIOD ACT:SCP0) |
| WK-SCP0001-0157 | C6 | REP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — REP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (R-26 REP 단일성 ACT:SCP0001_PlantSite.shtCu) |
| WK-SCP0001-0158 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (R-21 SCM_SITE_ID 재파생 ACT:SCP0001_PlantSi) |
| WK-SCP0001-0159 | C6 | SHIP_TO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SHIP_TO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.shtCustomerDataMod) |
| WK-SCP0001-0160 | C6 | SOLD_TO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SOLD_TO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.shtCustomerDataMod) |
| WK-SCP0001-0161 | C6 | STORAGE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — STORAGE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 23 (ACT:SCP0001_PlantSite.Dsdm_Changed ACT:S) |
| WK-SCP0001-0162 | G3 | SCP0001 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0001 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 6 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0001-0163 | K-SA | SCP0001 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0001 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (COMMON:UC-02) |
| WK-SCP0001-0164 | K4 | SCP0001 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0001 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 6 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0001-0165 | F1 | SCP0001 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0001 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 347 (COMMON:UC-03 COMMON:UC-04 R-02 활성그리드 라우팅) |
| WK-SCP0001-0166 | F3 | SCP0001 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0001 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 28 (R-06 sub 편집 3중 배타 R-31 붙여넣기 name→code(G4) |
| WK-SCP0001-0167 | F5 | SCP0001 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0001 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 18 (R-02 활성그리드 라우팅(INSERT/DELETE) R-03 Delet) |
| WK-SCP0001-0168 | F4 | DM0004_GET_SALES_SITE_CUSTOMER_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0004_GET_SALES_SITE_CUSTOMER_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 341 (ACT:SCP0001_PlantSite.FindData_SubCustom) |
| WK-SCP0001-0169 | F4 | PKG_SCP0001.P_SCP0001_GET_LOCATION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0001.P_SCP0001_GET_LOCATION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 343 (ACT:SCP0001_PlantSite.FindData_Sub ACT:S) |
| WK-SCP0001-0170 | F4 | PKG_SCP0001.P_SCP0001_GET_LOCATION_OSP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0001.P_SCP0001_GET_LOCATION_OSP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 343 (ACT:SCP0001_PlantSite.FindData_LocationO) |
| WK-SCP0001-0171 | F4 | PKG_SCP0001.P_SCP0001_GET_PLANT_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0001.P_SCP0001_GET_PLANT_SITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 358 (ACT:SCP0001_PlantSite.FindButton ACT:SCP) |
| WK-SCP0001-0172 | F4 | PKG_SCP0001.P_SCP0001_SAVE_LOCATION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0001.P_SCP0001_SAVE_LOCATION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 318 (ACT:SCP0001_PlantSite.SaveButton ACT:SCP) |
| WK-SCP0001-0173 | F4 | PKG_SCP0001.P_SCP0001_SAVE_LOCATION_OSP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0001.P_SCP0001_SAVE_LOCATION_OSP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 318 (ACT:SCP0001_PlantSite.SaveButton ACT:SCP) |
| WK-SCP0001-0174 | F4 | PKG_SCP0001.P_SCP0001_SAVE_PLANT_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0001.P_SCP0001_SAVE_PLANT_SITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 318 (ACT:SCP0001_PlantSite.SaveButton ACT:SCP) |
| WK-SCP0001-0175 | F4 | SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 319 (ACT:SCP0001_PlantSite.SaveButton ACT:SCP) |
| WK-SCP0001-0176 | A5 | CITY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CITY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0177 | A5 | COUNTRY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — COUNTRY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0178 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (site.DIVISION_ID 셀 EE 필터(G7) ACT:SCP0001) |
| WK-SCP0001-0179 | A5 | FP_PLAN_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FP_PLAN_PERIOD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0180 | A5 | HQ_VENDOR_CODE_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — HQ_VENDOR_CODE_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0181 | A5 | LOCATION_SEQ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LOCATION_SEQ · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0001_PlantSite.InitSpread:396:6) |
| WK-SCP0001-0182 | A5 | PLANT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-16 osp plant→storage 재조회) |
| WK-SCP0001-0183 | A5 | PLANT_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (R-17 Vendor 팝업(신규행 PLANT_NAME) ACT:SCP00) |
| WK-SCP0001-0184 | A5 | PROD_FROZEN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROD_FROZEN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0185 | A5 | REP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — REP · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-26 REP 단일성) |
| WK-SCP0001-0186 | A5 | SCM_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-21 SCM_SITE_ID 재파생) |
| WK-SCP0001-0187 | A5 | SITE_DESCRIPTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-10 locationOsp 신규행 SITE_DESCRIPTION 마스) |
| WK-SCP0001-0188 | A5 | SOLD_TO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SOLD_TO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0189 | G4 | cboOutsourcing / Outsourcing / OSP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOutsourcing / Outsourcing / OSP · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0001_PlantSite.InitControls ACT:S) |
| WK-SCP0001-0190 | G4 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0001_PlantSite.InitControls ACT:S) |
| WK-SCP0001-0191 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0001_PlantSite.InitControls ACT:S) |
| WK-SCP0001-0192 | H2 | CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0193 | H2 | COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0194 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (site.DIVISION_ID 셀 EE 필터(G7) ACT:SCP0001) |
| WK-SCP0001-0195 | H2 | FP_PLAN_PERIOD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FP_PLAN_PERIOD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0196 | H2 | LOCATION_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LOCATION_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InitSpread:396:6) |
| WK-SCP0001-0197 | H2 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-16 osp plant→storage 재조회) |
| WK-SCP0001-0198 | H2 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-17 Vendor 팝업(신규행 PLANT_NAME)) |
| WK-SCP0001-0199 | H2 | PROD_FROZEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROD_FROZEN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0200 | H2 | REP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-26 REP 단일성) |
| WK-SCP0001-0201 | H2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-21 SCM_SITE_ID 재파생) |
| WK-SCP0001-0202 | H2 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-10 locationOsp 신규행 SITE_DESCRIPTION 마스) |
| WK-SCP0001-0203 | H4 | SCP0001 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0001 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.spdSub_TopChange A) |
| WK-SCP0001-0204 | H5 | CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CITY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0205 | H5 | COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — COUNTRY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0206 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (site.DIVISION_ID 셀 EE 필터(G7) ACT:SCP0001) |
| WK-SCP0001-0207 | H5 | FP_PLAN_PERIOD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FP_PLAN_PERIOD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0208 | H5 | LOCATION_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LOCATION_SEQ · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InitSpread:396:6) |
| WK-SCP0001-0209 | H5 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-16 osp plant→storage 재조회) |
| WK-SCP0001-0210 | H5 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-17 Vendor 팝업(신규행 PLANT_NAME)) |
| WK-SCP0001-0211 | H5 | PROD_FROZEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROD_FROZEN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0212 | H5 | REP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — REP · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-26 REP 단일성) |
| WK-SCP0001-0213 | H5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SCM_SITE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-21 SCM_SITE_ID 재파생) |
| WK-SCP0001-0214 | H5 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SITE_DESCRIPTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-10 locationOsp 신규행 SITE_DESCRIPTION 마스) |
| WK-SCP0001-0215 | I1 | SCP0001 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0001 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 39 (COMMON:UC-02 COMMON:UC-04 R-01 Division ) |
| WK-SCP0001-0216 | SC1 | SCP0001 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0001 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 5 (Division 다중 + EE 필터 ALL → 권한 division 콤마) |
| WK-SCP0001-0217 | D1 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0218 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0219 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 12 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0220 | D1 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0221 | D1 | FP_PLAN_PERIOD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FP_PLAN_PERIOD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (R-24 PROD_FROZEN→FP_PLAN_PERIOD ACT:SCP0) |
| WK-SCP0001-0222 | D1 | HQ_VENDOR_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — HQ_VENDOR_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.EditButton:519:5 A) |
| WK-SCP0001-0223 | D1 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InsertRow:1502:51) |
| WK-SCP0001-0224 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 9 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0225 | D1 | LINK_PLANT_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LINK_PLANT_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0226 | D1 | LOCATION_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LOCATION_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0227 | D1 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0228 | D1 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0229 | D1 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0230 | D1 | PACKER_ITEM_ID_SUFFIX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PACKER_ITEM_ID_SUFFIX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0231 | D1 | PACKER_LINE_ACTIVE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PACKER_LINE_ACTIVE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0232 | D1 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (R-16 osp plant→storage 재조회 ACT:SCP0001_P) |
| WK-SCP0001-0233 | D1 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InsertRow:1462:26) |
| WK-SCP0001-0234 | D1 | PROD_FROZEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROD_FROZEN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (R-24 PROD_FROZEN→FP_PLAN_PERIOD) |
| WK-SCP0001-0235 | D1 | REP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — REP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (R-26 REP 단일성) |
| WK-SCP0001-0236 | D1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (R-21 SCM_SITE_ID 재파생 ACT:SCP0001_PlantSi) |
| WK-SCP0001-0237 | D1 | SHIP_TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIP_TO_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.EditButton:593:40 ) |
| WK-SCP0001-0238 | D1 | SHIP_TO_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIP_TO_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InsertRow:1501:50) |
| WK-SCP0001-0239 | D1 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.EditButton:607:47 ) |
| WK-SCP0001-0240 | D1 | SOLD_TO_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SOLD_TO_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InsertRow:1500:49) |
| WK-SCP0001-0241 | D3 | COMPANY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — COMPANY_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0242 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0243 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 12 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0244 | D3 | FACTORY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FACTORY_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0245 | D3 | FP_PLAN_PERIOD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FP_PLAN_PERIOD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (R-24 PROD_FROZEN→FP_PLAN_PERIOD ACT:SCP0) |
| WK-SCP0001-0246 | D3 | HQ_VENDOR_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — HQ_VENDOR_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.EditButton:519:5 A) |
| WK-SCP0001-0247 | D3 | LAST_UPDATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InsertRow:1502:51) |
| WK-SCP0001-0248 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 9 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0249 | D3 | LINK_PLANT_SITE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LINK_PLANT_SITE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0250 | D3 | LOCATION_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LOCATION_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0251 | D3 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0252 | D3 | OPERATION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0253 | D3 | OSP_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OSP_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0254 | D3 | PACKER_ITEM_ID_SUFFIX | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PACKER_ITEM_ID_SUFFIX · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0255 | D3 | PACKER_LINE_ACTIVE_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PACKER_LINE_ACTIVE_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (ACT:SCP0001_PlantSite.EditButton ACT:SCP) |
| WK-SCP0001-0256 | D3 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (R-16 osp plant→storage 재조회 ACT:SCP0001_P) |
| WK-SCP0001-0257 | D3 | PLANT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InsertRow:1462:26) |
| WK-SCP0001-0258 | D3 | PROD_FROZEN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROD_FROZEN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (R-24 PROD_FROZEN→FP_PLAN_PERIOD) |
| WK-SCP0001-0259 | D3 | REP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (R-26 REP 단일성) |
| WK-SCP0001-0260 | D3 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (R-21 SCM_SITE_ID 재파생 ACT:SCP0001_PlantSi) |
| WK-SCP0001-0261 | D3 | SHIP_TO_CITY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIP_TO_CITY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.EditButton:593:40 ) |
| WK-SCP0001-0262 | D3 | SHIP_TO_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIP_TO_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InsertRow:1501:50) |
| WK-SCP0001-0263 | D3 | SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.EditButton:607:47 ) |
| WK-SCP0001-0264 | D3 | SOLD_TO_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SOLD_TO_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InsertRow:1500:49) |
| WK-SCP0001-0265 | D4 | FP_PLAN_PERIOD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — FP_PLAN_PERIOD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0266 | D4 | PROD_FROZEN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PROD_FROZEN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0267 | D4 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-10 locationOsp 신규행 SITE_DESCRIPTION 마스) |
| WK-SCP0001-0268 | D5 | CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0269 | D5 | COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0270 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.InitSpread:358:1 A) |
| WK-SCP0001-0271 | D5 | LINK_PLANT_SITE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LINK_PLANT_SITE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.SpdMain_CellClick:) |
| WK-SCP0001-0272 | D5 | LOCATION_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LOCATION_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.InitSpread:396:6) |
| WK-SCP0001-0273 | D5 | LOGISTIC_PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LOGISTIC_PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.SetWarranty:717:5) |
| WK-SCP0001-0274 | D5 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.SetWarranty:716:4) |
| WK-SCP0001-0275 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.Dsdm_Changed:1599:) |
| WK-SCP0001-0276 | D5 | STORAGE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — STORAGE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCP0001_PlantSite.SpdSub_ComboSelCha) |
| WK-SCP0001-0277 | D6 | SCP0001 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0001 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 7 (COMMON:UC-01 COMMON:UC-03 R-02 활성그리드 라우팅) |
| WK-SCP0001-0278 | E1 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.SpdSub_ClipboardPa) |
| WK-SCP0001-0279 | E1 | FACTORY_ID2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — FACTORY_ID2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.SpdSub_ClipboardPa) |
| WK-SCP0001-0280 | E1 | LOCATION_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — LOCATION_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.SpdSub_ClipboardPa) |
| WK-SCP0001-0281 | E1 | LOCATION_CODE2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — LOCATION_CODE2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdSub_ClipboardPa) |
| WK-SCP0001-0282 | E1 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.SpdSub_ClipboardPa) |
| WK-SCP0001-0283 | E1 | OPERATION_ID2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPERATION_ID2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.SpdSub_ClipboardPa) |
| WK-SCP0001-0284 | E1 | STORAGE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — STORAGE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.SpdSub_ClipboardPa) |
| WK-SCP0001-0285 | E3 | REP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E3 실행 — REP · 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요 |  | 1 (R-26 REP 단일성) |
| WK-SCP0001-0286 | E4 | CITY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CITY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0287 | E4 | COUNTRY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — COUNTRY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0001_PlantSite.SetImageCell ACT:S) |
| WK-SCP0001-0288 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (site.DIVISION_ID 셀 EE 필터(G7)) |
| WK-SCP0001-0289 | E4 | FP_PLAN_PERIOD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FP_PLAN_PERIOD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0290 | E4 | LOGISTIC_PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LOGISTIC_PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0001_PlantSite.SetWarranty ACT:SC) |
| WK-SCP0001-0291 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (COMMON:UC-04 필수값 공백(R-33) ACT:SCP0001_Pl) |
| WK-SCP0001-0292 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0001_PlantSite.SaveData:1049:105 ) |
| WK-SCP0001-0293 | E4 | MSG00005 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00005 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0001_PlantSite.SaveData:1338:269) |
| WK-SCP0001-0294 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0001_PlantSite.SaveData:1058:110 ) |
| WK-SCP0001-0295 | E4 | MSG00014 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00014 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (마스터 미선택(P-06, Insert 방어)) |
| WK-SCP0001-0296 | E4 | MSG00028 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00028 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (Rep 단일성(R-26)) |
| WK-SCP0001-0297 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (중복 키(R-34/28) ACT:SCP0001_PlantSite.Chec) |
| WK-SCP0001-0298 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (R-01 Division 권한 0건 → 조회영역 비활성 권한 divisi) |
| WK-SCP0001-0299 | E4 | MSG00120 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00120 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (customer 신규필수(R-38) ACT:SCP0001_PlantSit) |
| WK-SCP0001-0300 | E4 | MSG00129 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00129 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (R-06 sub 편집 3중 배타 R-06① main dirty↔sub 배) |
| WK-SCP0001-0301 | E4 | MSG00130 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00130 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (main/sub 편집 배타(R-06①) 탭 전환 차단(R-32) ACT:) |
| WK-SCP0001-0302 | E4 | MSG00149 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00149 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (Rep 단일성(R-26) ACT:SCP0001_PlantSite.shtC) |
| WK-SCP0001-0303 | E4 | MSG00161 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00161 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (마스터 미선택(P-06, Insert 방어)) |
| WK-SCP0001-0304 | E4 | MSG00168 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00168 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (외주 Location 불가(R-06②) ACT:SCP0001_PlantS) |
| WK-SCP0001-0305 | E4 | MSG00224 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00224 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (외주만 Location(OSP)(R-06③) ACT:SCP0001_Pla) |
| WK-SCP0001-0306 | E4 | MSG00614 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00614 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (필수값 공백(R-33)) |
| WK-SCP0001-0307 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0001-0308 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0001-0309 | E4 | MSG01079 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01079 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (붙여넣기 미일치(R-31)) |
| WK-SCP0001-0310 | E4 | MSG01144 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01144 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (customer 신규필수(R-38)) |
| WK-SCP0001-0311 | E4 | MSG01149 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01149 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (탭 전환 차단(R-32)) |
| WK-SCP0001-0312 | E4 | MSG01183 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01183 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (외주 Location 불가(R-06②)) |
| WK-SCP0001-0313 | E4 | MSG01235 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01235 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (외주만 Location(OSP)(R-06③)) |
| WK-SCP0001-0314 | E4 | MSG01467 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01467 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (탭 전환 차단(R-32)) |
| WK-SCP0001-0315 | E4 | MSG01468 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01468 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (R-32 편집 중 탭 전환 차단(G8) 탭 전환 차단(R-32)) |
| WK-SCP0001-0316 | E4 | MSG99999 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG99999 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (탭 전환 차단(R-32)) |
| WK-SCP0001-0317 | E4 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCP0001_PlantSite.SetWarranty ACT:SC) |
| WK-SCP0001-0318 | E4 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R-16 osp plant→storage 재조회) |
| WK-SCP0001-0319 | E4 | PLANT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R-17 Vendor 팝업(신규행 PLANT_NAME)) |
| WK-SCP0001-0320 | E4 | PROD_FROZEN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROD_FROZEN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0321 | E4 | REP | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REP · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (R-26 REP 단일성 ACT:SCP0001_PlantSite.shtCu) |
| WK-SCP0001-0322 | E4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R-21 SCM_SITE_ID 재파생) |
| WK-SCP0001-0323 | E4 | SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R-10 locationOsp 신규행 SITE_DESCRIPTION 마스) |
| WK-SCP0001-0324 | E4 | SOLD_TO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SOLD_TO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0325 | E4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0001_PlantSite.SetChangedControl ) |
| WK-SCP0001-0326 | A10 | SCP0001 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0001 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 61 (ACT:SCP0001_PlantSite.DefineProperty ACT) |
| WK-SCP0001-0327 | A6 | DM0004_GET_SALES_SITE_CUSTOMER_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DM0004_GET_SALES_SITE_CUSTOMER_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 24 (ACT:SCP0001_PlantSite.FindData_SubCustom) |
| WK-SCP0001-0328 | A6 | PKG_SCP0001.P_SCP0001_GET_LOCATION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0001.P_SCP0001_GET_LOCATION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tra |  | 26 (ACT:SCP0001_PlantSite.FindData_Sub ACT:S) |
| WK-SCP0001-0329 | A6 | PKG_SCP0001.P_SCP0001_GET_LOCATION_OSP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0001.P_SCP0001_GET_LOCATION_OSP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 26 (ACT:SCP0001_PlantSite.FindData_LocationO) |
| WK-SCP0001-0330 | A6 | PKG_SCP0001.P_SCP0001_GET_PLANT_SITE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0001.P_SCP0001_GET_PLANT_SITE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 41 (ACT:SCP0001_PlantSite.FindButton ACT:SCP) |
| WK-SCP0001-0331 | G1 | cboOutsourcing / Outsourcing / OSP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboOutsourcing / Outsourcing / OSP · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0001_PlantSite.FindData_Main ACT:) |
| WK-SCP0001-0332 | G1 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0001_PlantSite.FindData_LocationO) |
| WK-SCP0001-0333 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0001_PlantSite.FindData_Main ACT:) |
| WK-SCP0001-0334 | G1 | txtPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0001_PlantSite.FindData_Main ACT:) |
| WK-SCP0001-0335 | G1 | txtPlantVendor / Plant/Vendor / Plant Ve | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtPlantVendor / Plant/Vendor / Plant Vendor · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0001_PlantSite.FindData_Main ACT:) |
| WK-SCP0001-0336 | G6 | cboOutsourcing / Outsourcing / OSP | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOutsourcing / Outsourcing / OSP · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.InitControls ACT:S) |
| WK-SCP0001-0337 | G6 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.InitControls ACT:S) |
| WK-SCP0001-0338 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.InitControls ACT:S) |
| WK-SCP0001-0339 | X-REOPEN | SCP0001 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0001 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 12 (ACT:SCP0001_PlantSite.Dispose ACT:SCP000) |
| WK-SCP0001-0340 | H6 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboValid / Valid / Active · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 3 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0341 | M4 | CITY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CITY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 11 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0342 | M4 | COUNTRY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — COUNTRY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 12 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0343 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 6 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0344 | M4 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0345 | M4 | OSP_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — OSP_YN · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0346 | M4 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0347 | M4 | PLANT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PLANT_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (R-17 Vendor 팝업(신규행 PLANT_NAME)) |
| WK-SCP0001-0348 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0349 | M4 | SHIP_TO | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SHIP_TO · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0350 | M4 | SHIP_TO_CITY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SHIP_TO_CITY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0351 | M4 | SHIP_TO_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SHIP_TO_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0352 | M4 | SHIP_TO_REGION | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SHIP_TO_REGION · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0353 | M4 | SOLD_TO | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SOLD_TO · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 33 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0354 | M4 | SOLD_TO_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SOLD_TO_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0355 | M4 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |

## W7 기대값 확정 (312)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0001-0356 | C2 | R-05 Warranty 특례 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — R-05 Warranty 특례: 행 집계 — C2 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0357 | C2 | R-11~14 Location cascade/배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — R-11~14 Location cascade/배타: 행 집계 — C2 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0358 | C2 | R-25 HQ 클리어 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — R-25 HQ 클리어: 행 집계 — C2 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0359 | C2 | SCP0001_PlantSite.ClbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0001_PlantSite.ClbDivision_SelectedIndexChanged: 진입점 집계 — C2 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.ClbDivision_Select) |
| WK-SCP0001-0360 | C2 | SCP0001_PlantSite.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0001_PlantSite.Dsdm_Changed: 진입점 집계 — C2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.Dsdm_Changed:1535:) |
| WK-SCP0001-0361 | C2 | SCP0001_PlantSite.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0001_PlantSite.SpdMain_ComboSelChange: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0362 | C2 | SCP0001_PlantSite.SpdSub_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0001_PlantSite.SpdSub_ActiveSheetChanged: 진입점 집계 — C2 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.SpdSub_ActiveSheet) |
| WK-SCP0001-0363 | C2 | SCP0001_PlantSite.SpdSub_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0001_PlantSite.SpdSub_ComboSelChange: 진입점 집계 — C2 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0001_PlantSite.SpdSub_ComboSelCha) |
| WK-SCP0001-0364 | C2 | SCP0001_PlantSite.shtCustomerDataModel_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0001_PlantSite.shtCustomerDataModel_Changed: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.shtCustomerDataMod) |
| WK-SCP0001-0365 | C2 | SCP0001_PlantSite.spdMainDsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0001_PlantSite.spdMainDsdm_Changed: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0001_PlantSite.spdMainDsdm_Change) |
| WK-SCP0001-0366 | C3 | R-05 Warranty 특례 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — R-05 Warranty 특례: 행 집계 — C3 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0367 | C3 | R-06 sub 편집 3중 배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — R-06 sub 편집 3중 배타: 행 집계 — C3 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (R-06 sub 편집 3중 배타) |
| WK-SCP0001-0368 | C3 | R-11~14 Location cascade/배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — R-11~14 Location cascade/배타: 행 집계 — C3 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0369 | C3 | R-25 HQ 클리어 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — R-25 HQ 클리어: 행 집계 — C3 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0370 | C3 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — C3 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0371 | C3 | SCP0001_PlantSite.ClbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0001_PlantSite.ClbDivision_SelectedIndexChanged: 진입점 집계 — C3 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.ClbDivision_Select) |
| WK-SCP0001-0372 | C3 | SCP0001_PlantSite.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0001_PlantSite.Dsdm_Changed: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.Dsdm_Changed:1535:) |
| WK-SCP0001-0373 | C3 | SCP0001_PlantSite.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0001_PlantSite.SetChangedControl: 진입점 집계 — C3 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0001_PlantSite.SetChangedControl:) |
| WK-SCP0001-0374 | C3 | SCP0001_PlantSite.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0001_PlantSite.SpdMain_ComboSelChange: 진입점 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0375 | C3 | SCP0001_PlantSite.SpdSub_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0001_PlantSite.SpdSub_ActiveSheetChanged: 진입점 집계 — C3 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.SpdSub_ActiveSheet) |
| WK-SCP0001-0376 | C3 | SCP0001_PlantSite.SpdSub_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0001_PlantSite.SpdSub_ComboSelChange: 진입점 집계 — C3 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0001_PlantSite.SpdSub_ComboSelCha) |
| WK-SCP0001-0377 | C3 | SCP0001_PlantSite.shtCustomerDataModel_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0001_PlantSite.shtCustomerDataModel_Changed: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.shtCustomerDataMod) |
| WK-SCP0001-0378 | C3 | SCP0001_PlantSite.spdMainDsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0001_PlantSite.spdMainDsdm_Changed: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0001_PlantSite.spdMainDsdm_Change) |
| WK-SCP0001-0379 | C3 | 붙여넣기 미일치(R-31) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 붙여넣기 미일치(R-31): 행 집계 — C3 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (붙여넣기 미일치(R-31)) |
| WK-SCP0001-0380 | C6 | R-05 Warranty 특례 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — R-05 Warranty 특례: 행 집계 — C6 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0381 | C6 | R-11~14 Location cascade/배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — R-11~14 Location cascade/배타: 행 집계 — C6 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0382 | C6 | R-25 HQ 클리어 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — R-25 HQ 클리어: 행 집계 — C6 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0383 | C6 | SCP0001_PlantSite.ClbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0001_PlantSite.ClbDivision_SelectedIndexChanged: 진입점 집계 — C6 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.ClbDivision_Select) |
| WK-SCP0001-0384 | C6 | SCP0001_PlantSite.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0001_PlantSite.Dsdm_Changed: 진입점 집계 — C6 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.Dsdm_Changed:1535:) |
| WK-SCP0001-0385 | C6 | SCP0001_PlantSite.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0001_PlantSite.SpdMain_ComboSelChange: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0386 | C6 | SCP0001_PlantSite.SpdSub_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0001_PlantSite.SpdSub_ActiveSheetChanged: 진입점 집계 — C6 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.SpdSub_ActiveSheet) |
| WK-SCP0001-0387 | C6 | SCP0001_PlantSite.SpdSub_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0001_PlantSite.SpdSub_ComboSelChange: 진입점 집계 — C6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0001_PlantSite.SpdSub_ComboSelCha) |
| WK-SCP0001-0388 | C6 | SCP0001_PlantSite.shtCustomerDataModel_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0001_PlantSite.shtCustomerDataModel_Changed: 진입점 집계 — C6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.shtCustomerDataMod) |
| WK-SCP0001-0389 | C6 | SCP0001_PlantSite.spdMainDsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0001_PlantSite.spdMainDsdm_Changed: 진입점 집계 — C6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0001_PlantSite.spdMainDsdm_Change) |
| WK-SCP0001-0390 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0001-0391 | B1 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — B1 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0392 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0001-0393 | B2 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — B2 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0394 | B3 | Division 다중 + EE 필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — Division 다중 + EE 필터: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (Division 다중 + EE 필터) |
| WK-SCP0001-0395 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0001-0396 | B4 | Division 다중 + EE 필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — Division 다중 + EE 필터: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (Division 다중 + EE 필터) |
| WK-SCP0001-0397 | B4 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0398 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0001-0399 | A5 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-04: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCP0001-0400 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0001-0401 | A5 | R-02 활성그리드 라우팅(INSERT/DELETE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-02 활성그리드 라우팅(INSERT/DELETE): 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-02 활성그리드 라우팅(INSERT/DELETE)) |
| WK-SCP0001-0402 | A5 | R-05 Warranty 특례 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-05 Warranty 특례: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0403 | A5 | R-06 sub 편집 3중 배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-06 sub 편집 3중 배타: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-06 sub 편집 3중 배타) |
| WK-SCP0001-0404 | A5 | R-06① main dirty↔sub 배타(G6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-06① main dirty↔sub 배타(G6): 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-06① main dirty↔sub 배타(G6)) |
| WK-SCP0001-0405 | A5 | R-08 시트 탭 상시 표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-08 시트 탭 상시 표시: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-08 시트 탭 상시 표시) |
| WK-SCP0001-0406 | A5 | R-11~14 Location cascade/배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-11~14 Location cascade/배타: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0407 | A5 | R-15 customer div→site 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-15 customer div→site 재조회: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-15 customer div→site 재조회) |
| WK-SCP0001-0408 | A5 | R-18 HQ Vendor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-18 HQ Vendor 팝업: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-18 HQ Vendor 팝업) |
| WK-SCP0001-0409 | A5 | R-20 City 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-20 City 팝업: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-20 City 팝업) |
| WK-SCP0001-0410 | A5 | R-22/23 packer 행잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-22/23 packer 행잠금: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-22/23 packer 행잠금) |
| WK-SCP0001-0411 | A5 | R-25 HQ 클리어 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-25 HQ 클리어: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0412 | A5 | R-27/28 Customer 팝업+중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-27/28 Customer 팝업+중복: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-27/28 Customer 팝업+중복) |
| WK-SCP0001-0413 | A5 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0414 | A5 | R-32 편집 중 탭 전환 차단(G8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-32 편집 중 탭 전환 차단(G8): 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-32 편집 중 탭 전환 차단(G8)) |
| WK-SCP0001-0415 | A5 | R-33 Location 필수(G1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-33 Location 필수(G1): 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-33 Location 필수(G1)) |
| WK-SCP0001-0416 | A5 | R-34 Location 중복(G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-34 Location 중복(G2): 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-34 Location 중복(G2)) |
| WK-SCP0001-0417 | A5 | R-38 customer 신규필수(G3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-38 customer 신규필수(G3): 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (R-38 customer 신규필수(G3)) |
| WK-SCP0001-0418 | A5 | SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP: 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP) |
| WK-SCP0001-0419 | A5 | SCP0001_PlantSite.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0001_PlantSite.CreateSpread: 진입점 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 20 (ACT:SCP0001_PlantSite.CreateSpread:322:1) |
| WK-SCP0001-0420 | A5 | 셀 병합(G10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 셀 병합(G10): 행 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합(G10)) |
| WK-SCP0001-0421 | G4 | ALL → 권한 division 콤마 확장(권한 함정) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — ALL → 권한 division 콤마 확장(권한 함정): 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ALL → 권한 division 콤마 확장(권한 함정)) |
| WK-SCP0001-0422 | G4 | Division 다중 + EE 필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Division 다중 + EE 필터: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Division 다중 + EE 필터) |
| WK-SCP0001-0423 | G4 | OSP/Active YesOrNo + ALL sentinel | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — OSP/Active YesOrNo + ALL sentinel: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (OSP/Active YesOrNo + ALL sentinel) |
| WK-SCP0001-0424 | G4 | Plant/Vendor·Plant Site 텍스트(UPPER LIKE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Plant/Vendor·Plant Site 텍스트(UPPER LIKE): 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Plant/Vendor·Plant Site 텍스트(UPPER LIKE)) |
| WK-SCP0001-0425 | G4 | p_new_yn 항상 null | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — p_new_yn 항상 null: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (p_new_yn 항상 null) |
| WK-SCP0001-0426 | H2 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-01: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0001-0427 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0001-0428 | H2 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-04: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCP0001-0429 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0001-0430 | H2 | R-02 활성그리드 라우팅(INSERT/DELETE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-02 활성그리드 라우팅(INSERT/DELETE): 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-02 활성그리드 라우팅(INSERT/DELETE)) |
| WK-SCP0001-0431 | H2 | R-05 Warranty 특례 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-05 Warranty 특례: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0432 | H2 | R-06 sub 편집 3중 배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-06 sub 편집 3중 배타: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-06 sub 편집 3중 배타) |
| WK-SCP0001-0433 | H2 | R-06① main dirty↔sub 배타(G6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-06① main dirty↔sub 배타(G6): 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-06① main dirty↔sub 배타(G6)) |
| WK-SCP0001-0434 | H2 | R-08 시트 탭 상시 표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-08 시트 탭 상시 표시: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-08 시트 탭 상시 표시) |
| WK-SCP0001-0435 | H2 | R-11~14 Location cascade/배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-11~14 Location cascade/배타: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0436 | H2 | R-15 customer div→site 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-15 customer div→site 재조회: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-15 customer div→site 재조회) |
| WK-SCP0001-0437 | H2 | R-18 HQ Vendor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-18 HQ Vendor 팝업: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-18 HQ Vendor 팝업) |
| WK-SCP0001-0438 | H2 | R-20 City 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-20 City 팝업: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-20 City 팝업) |
| WK-SCP0001-0439 | H2 | R-22/23 packer 행잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-22/23 packer 행잠금: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-22/23 packer 행잠금) |
| WK-SCP0001-0440 | H2 | R-25 HQ 클리어 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-25 HQ 클리어: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0441 | H2 | R-27/28 Customer 팝업+중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-27/28 Customer 팝업+중복: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-27/28 Customer 팝업+중복) |
| WK-SCP0001-0442 | H2 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0443 | H2 | R-32 편집 중 탭 전환 차단(G8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-32 편집 중 탭 전환 차단(G8): 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-32 편집 중 탭 전환 차단(G8)) |
| WK-SCP0001-0444 | H2 | R-33 Location 필수(G1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-33 Location 필수(G1): 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-33 Location 필수(G1)) |
| WK-SCP0001-0445 | H2 | R-34 Location 중복(G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-34 Location 중복(G2): 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-34 Location 중복(G2)) |
| WK-SCP0001-0446 | H2 | R-38 customer 신규필수(G3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-38 customer 신규필수(G3): 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-38 customer 신규필수(G3)) |
| WK-SCP0001-0447 | H2 | SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP) |
| WK-SCP0001-0448 | H2 | SCP0001_PlantSite.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0001_PlantSite.CreateSpread: 진입점 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 20 (ACT:SCP0001_PlantSite.CreateSpread:322:1) |
| WK-SCP0001-0449 | H2 | 셀 병합(G10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 셀 병합(G10): 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합(G10)) |
| WK-SCP0001-0450 | H5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-01: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0001-0451 | H5 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-04: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCP0001-0452 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0001-0453 | H5 | R-02 활성그리드 라우팅(INSERT/DELETE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-02 활성그리드 라우팅(INSERT/DELETE): 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-02 활성그리드 라우팅(INSERT/DELETE)) |
| WK-SCP0001-0454 | H5 | R-05 Warranty 특례 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-05 Warranty 특례: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0455 | H5 | R-06 sub 편집 3중 배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-06 sub 편집 3중 배타: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-06 sub 편집 3중 배타) |
| WK-SCP0001-0456 | H5 | R-06① main dirty↔sub 배타(G6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-06① main dirty↔sub 배타(G6): 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-06① main dirty↔sub 배타(G6)) |
| WK-SCP0001-0457 | H5 | R-08 시트 탭 상시 표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-08 시트 탭 상시 표시: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-08 시트 탭 상시 표시) |
| WK-SCP0001-0458 | H5 | R-11~14 Location cascade/배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-11~14 Location cascade/배타: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0459 | H5 | R-15 customer div→site 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-15 customer div→site 재조회: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-15 customer div→site 재조회) |
| WK-SCP0001-0460 | H5 | R-18 HQ Vendor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-18 HQ Vendor 팝업: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-18 HQ Vendor 팝업) |
| WK-SCP0001-0461 | H5 | R-20 City 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-20 City 팝업: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-20 City 팝업) |
| WK-SCP0001-0462 | H5 | R-22/23 packer 행잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-22/23 packer 행잠금: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-22/23 packer 행잠금) |
| WK-SCP0001-0463 | H5 | R-25 HQ 클리어 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-25 HQ 클리어: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0464 | H5 | R-27/28 Customer 팝업+중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-27/28 Customer 팝업+중복: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-27/28 Customer 팝업+중복) |
| WK-SCP0001-0465 | H5 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0466 | H5 | R-32 편집 중 탭 전환 차단(G8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-32 편집 중 탭 전환 차단(G8): 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-32 편집 중 탭 전환 차단(G8)) |
| WK-SCP0001-0467 | H5 | R-33 Location 필수(G1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-33 Location 필수(G1): 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-33 Location 필수(G1)) |
| WK-SCP0001-0468 | H5 | R-34 Location 중복(G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-34 Location 중복(G2): 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-34 Location 중복(G2)) |
| WK-SCP0001-0469 | H5 | R-38 customer 신규필수(G3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-38 customer 신규필수(G3): 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-38 customer 신규필수(G3)) |
| WK-SCP0001-0470 | H5 | SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP) |
| WK-SCP0001-0471 | H5 | SCP0001_PlantSite.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0001_PlantSite.CreateSpread: 진입점 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 20 (ACT:SCP0001_PlantSite.CreateSpread:322:1) |
| WK-SCP0001-0472 | H5 | 셀 병합(G10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 셀 병합(G10): 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합(G10)) |
| WK-SCP0001-0473 | X-REASON | MODAL:FPModal | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:FPModal AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 — 정규식 오탐(RE_MD_POPUP 이 `00_checklist.md:469` 산문 "셀유형 FPMo |  | 1 (MODAL:FPModal) |
| WK-SCP0001-0474 | D1 | R-04/R-07 편집잠금 카탈로그 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-04/R-07 편집잠금 카탈로그: 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-04/R-07 편집잠금 카탈로그) |
| WK-SCP0001-0475 | D1 | R-05 Warranty 특례 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-05 Warranty 특례: 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0476 | D1 | R-05 packer 2컬럼 행조건 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-05 packer 2컬럼 행조건 잠금: 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-05 packer 2컬럼 행조건 잠금) |
| WK-SCP0001-0477 | D1 | R-06 sub 편집 3중 배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-06 sub 편집 3중 배타: 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-06 sub 편집 3중 배타) |
| WK-SCP0001-0478 | D1 | R-06① main dirty↔sub 배타(G6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-06① main dirty↔sub 배타(G6): 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-06① main dirty↔sub 배타(G6)) |
| WK-SCP0001-0479 | D1 | R-11~14 Location cascade/배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-11~14 Location cascade/배타: 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0480 | D1 | R-15 customer div→site 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-15 customer div→site 재조회: 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-15 customer div→site 재조회) |
| WK-SCP0001-0481 | D1 | R-22/23 packer 행잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-22/23 packer 행잠금: 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-22/23 packer 행잠금) |
| WK-SCP0001-0482 | D1 | R-25 HQ 클리어 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-25 HQ 클리어: 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0483 | D1 | R-32 편집 중 탭 전환 차단(G8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-32 편집 중 탭 전환 차단(G8): 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-32 편집 중 탭 전환 차단(G8)) |
| WK-SCP0001-0484 | D1 | SCP0001_PlantSite.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0001_PlantSite.EditButton: 진입점 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SCP0001_PlantSite.EditButton:516:3 A) |
| WK-SCP0001-0485 | D1 | main/sub 편집 배타(R-06①) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — main/sub 편집 배타(R-06①): 행 집계 — D1 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (main/sub 편집 배타(R-06①)) |
| WK-SCP0001-0486 | D3 | R-04/R-07 편집잠금 카탈로그 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-04/R-07 편집잠금 카탈로그: 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-04/R-07 편집잠금 카탈로그) |
| WK-SCP0001-0487 | D3 | R-05 Warranty 특례 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-05 Warranty 특례: 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0488 | D3 | R-05 packer 2컬럼 행조건 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-05 packer 2컬럼 행조건 잠금: 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-05 packer 2컬럼 행조건 잠금) |
| WK-SCP0001-0489 | D3 | R-06 sub 편집 3중 배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-06 sub 편집 3중 배타: 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-06 sub 편집 3중 배타) |
| WK-SCP0001-0490 | D3 | R-06① main dirty↔sub 배타(G6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-06① main dirty↔sub 배타(G6): 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-06① main dirty↔sub 배타(G6)) |
| WK-SCP0001-0491 | D3 | R-11~14 Location cascade/배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-11~14 Location cascade/배타: 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0492 | D3 | R-15 customer div→site 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-15 customer div→site 재조회: 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-15 customer div→site 재조회) |
| WK-SCP0001-0493 | D3 | R-22/23 packer 행잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-22/23 packer 행잠금: 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-22/23 packer 행잠금) |
| WK-SCP0001-0494 | D3 | R-25 HQ 클리어 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-25 HQ 클리어: 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0495 | D3 | R-32 편집 중 탭 전환 차단(G8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-32 편집 중 탭 전환 차단(G8): 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R-32 편집 중 탭 전환 차단(G8)) |
| WK-SCP0001-0496 | D3 | SCP0001_PlantSite.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0001_PlantSite.EditButton: 진입점 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SCP0001_PlantSite.EditButton:516:3 A) |
| WK-SCP0001-0497 | D3 | main/sub 편집 배타(R-06①) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — main/sub 편집 배타(R-06①): 행 집계 — D3 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (main/sub 편집 배타(R-06①)) |
| WK-SCP0001-0498 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0001-0499 | D4 | R-02 활성그리드 라우팅(INSERT/DELETE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — R-02 활성그리드 라우팅(INSERT/DELETE): 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-02 활성그리드 라우팅(INSERT/DELETE)) |
| WK-SCP0001-0500 | D4 | 마스터 미선택(P-06, Insert 방어) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 마스터 미선택(P-06, Insert 방어): 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (마스터 미선택(P-06, Insert 방어)) |
| WK-SCP0001-0501 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0001-0502 | D5 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — D5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0503 | D5 | SCP0001_PlantSite.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0001_PlantSite.CreateSpread: 진입점 집계 — D5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 20 (ACT:SCP0001_PlantSite.CreateSpread:322:1) |
| WK-SCP0001-0504 | E1 | R-06 sub 편집 3중 배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — R-06 sub 편집 3중 배타: 행 집계 — E1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-06 sub 편집 3중 배타) |
| WK-SCP0001-0505 | E1 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — E1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0506 | E1 | 붙여넣기 미일치(R-31) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 붙여넣기 미일치(R-31): 행 집계 — E1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (붙여넣기 미일치(R-31)) |
| WK-SCP0001-0507 | E3 | R-05 Warranty 특례 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-05 Warranty 특례: 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0508 | E3 | R-06① main dirty↔sub 배타(G6) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-06① main dirty↔sub 배타(G6): 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-06① main dirty↔sub 배타(G6)) |
| WK-SCP0001-0509 | E3 | R-11~14 Location cascade/배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-11~14 Location cascade/배타: 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0510 | E3 | R-15 customer div→site 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-15 customer div→site 재조회: 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-15 customer div→site 재조회) |
| WK-SCP0001-0511 | E3 | R-18 HQ Vendor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-18 HQ Vendor 팝업: 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-18 HQ Vendor 팝업) |
| WK-SCP0001-0512 | E3 | R-20 City 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-20 City 팝업: 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-20 City 팝업) |
| WK-SCP0001-0513 | E3 | R-22/23 packer 행잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-22/23 packer 행잠금: 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-22/23 packer 행잠금) |
| WK-SCP0001-0514 | E3 | R-25 HQ 클리어 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-25 HQ 클리어: 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0515 | E3 | R-27/28 Customer 팝업+중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-27/28 Customer 팝업+중복: 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-27/28 Customer 팝업+중복) |
| WK-SCP0001-0516 | E3 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0517 | E3 | R-32 편집 중 탭 전환 차단(G8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-32 편집 중 탭 전환 차단(G8): 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-32 편집 중 탭 전환 차단(G8)) |
| WK-SCP0001-0518 | E3 | R-33 Location 필수(G1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-33 Location 필수(G1): 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-33 Location 필수(G1)) |
| WK-SCP0001-0519 | E3 | R-34 Location 중복(G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-34 Location 중복(G2): 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-34 Location 중복(G2)) |
| WK-SCP0001-0520 | E3 | R-38 customer 신규필수(G3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-38 customer 신규필수(G3): 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-38 customer 신규필수(G3)) |
| WK-SCP0001-0521 | E3 | SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP: 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP) |
| WK-SCP0001-0522 | E3 | 셀 병합(G10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 셀 병합(G10): 행 집계 — E3 8요소: PASS:7 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합(G10)) |
| WK-SCP0001-0523 | E4 | R-05 Warranty 특례 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-05 Warranty 특례: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-05 Warranty 특례) |
| WK-SCP0001-0524 | E4 | R-11~14 Location cascade/배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-11~14 Location cascade/배타: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-11~14 Location cascade/배타) |
| WK-SCP0001-0525 | E4 | R-15 customer div→site 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-15 customer div→site 재조회: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-15 customer div→site 재조회) |
| WK-SCP0001-0526 | E4 | R-18 HQ Vendor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-18 HQ Vendor 팝업: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-18 HQ Vendor 팝업) |
| WK-SCP0001-0527 | E4 | R-20 City 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-20 City 팝업: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-20 City 팝업) |
| WK-SCP0001-0528 | E4 | R-22/23 packer 행잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-22/23 packer 행잠금: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-22/23 packer 행잠금) |
| WK-SCP0001-0529 | E4 | R-25 HQ 클리어 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-25 HQ 클리어: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-25 HQ 클리어) |
| WK-SCP0001-0530 | E4 | R-27/28 Customer 팝업+중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-27/28 Customer 팝업+중복: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-27/28 Customer 팝업+중복) |
| WK-SCP0001-0531 | E4 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0532 | E4 | R-33 Location 필수(G1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-33 Location 필수(G1): 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-33 Location 필수(G1)) |
| WK-SCP0001-0533 | E4 | R-34 Location 중복(G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-34 Location 중복(G2): 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-34 Location 중복(G2)) |
| WK-SCP0001-0534 | E4 | R-38 customer 신규필수(G3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-38 customer 신규필수(G3): 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R-38 customer 신규필수(G3)) |
| WK-SCP0001-0535 | E4 | SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (SAVE_LOCATION/SITE_CUSTOMER/LOCATION_OSP) |
| WK-SCP0001-0536 | E4 | SCP0001_PlantSite.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0001_PlantSite.SetChangedControl: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0001_PlantSite.SetChangedControl:) |
| WK-SCP0001-0537 | E4 | 셀 병합(G10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 셀 병합(G10): 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합(G10)) |
| WK-SCP0001-0538 | A1 | ALL → 권한 division 콤마 확장(권한 함정) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ALL → 권한 division 콤마 확장(권한 함정): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (ALL → 권한 division 콤마 확장(권한 함정)) |
| WK-SCP0001-0539 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (COMMON:UC-02) |
| WK-SCP0001-0540 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (COMMON:UC-07) |
| WK-SCP0001-0541 | A1 | DM0004_GET_SALES_SITE_CUSTOMER_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DM0004_GET_SALES_SITE_CUSTOMER_DATA: 골든 비교 케이스 없음(DM0004_GET_SALES_SITE_CUSTOMER_DATA — 팝업·보조 SP 는 golden_cases.csv 에  |  | 24 (ACT:SCP0001_PlantSite.FindData_SubCustom) |
| WK-SCP0001-0542 | A1 | Division 다중 + EE 필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Division 다중 + EE 필터: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Division 다중 + EE 필터) |
| WK-SCP0001-0543 | A1 | OSP/Active YesOrNo + ALL sentinel | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — OSP/Active YesOrNo + ALL sentinel: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (OSP/Active YesOrNo + ALL sentinel) |
| WK-SCP0001-0544 | A1 | PKG_SCP0001.P_SCP0001_GET_LOCATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0001.P_SCP0001_GET_LOCATION: 골든 비교 케이스 없음(PKG_SCP0001.P_SCP0001_GET_LOCATION — 팝업·보조 SP 는 golden_cases.csv 에 FE |  | 26 (ACT:SCP0001_PlantSite.FindData_Sub ACT:S) |
| WK-SCP0001-0545 | A1 | PKG_SCP0001.P_SCP0001_GET_LOCATION_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0001.P_SCP0001_GET_LOCATION_OSP: 골든 비교 케이스 없음(PKG_SCP0001.P_SCP0001_GET_LOCATION_OSP — 팝업·보조 SP 는 golden_cases. |  | 26 (ACT:SCP0001_PlantSite.FindData_LocationO) |
| WK-SCP0001-0546 | A1 | PKG_SCP0001.P_SCP0001_GET_PLANT_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0001.P_SCP0001_GET_PLANT_SITE: 골든 비교 케이스 없음(PKG_SCP0001.P_SCP0001_GET_PLANT_SITE — 팝업·보조 SP 는 golden_cases.csv  |  | 41 (ACT:SCP0001_PlantSite.FindButton ACT:SCP) |
| WK-SCP0001-0547 | A1 | Plant/Vendor·Plant Site 텍스트(UPPER LIKE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Plant/Vendor·Plant Site 텍스트(UPPER LIKE): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Plant/Vendor·Plant Site 텍스트(UPPER LIKE)) |
| WK-SCP0001-0548 | A1 | R-01 Division 권한 0건 → 조회영역 비활성 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-01 Division 권한 0건 → 조회영역 비활성: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (R-01 Division 권한 0건 → 조회영역 비활성) |
| WK-SCP0001-0549 | A1 | R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PLAN_PERIOD): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0550 | A1 | R-15 customer div→site 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-15 customer div→site 재조회: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (R-15 customer div→site 재조회) |
| WK-SCP0001-0551 | A1 | R-16 osp plant→storage 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-16 osp plant→storage 재조회: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (R-16 osp plant→storage 재조회) |
| WK-SCP0001-0552 | A1 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0553 | A1 | Rep 단일성(R-26) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Rep 단일성(R-26): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Rep 단일성(R-26)) |
| WK-SCP0001-0554 | A1 | customer 신규필수(R-38) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — customer 신규필수(R-38): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (customer 신규필수(R-38)) |
| WK-SCP0001-0555 | A1 | main/sub 편집 배타(R-06①) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — main/sub 편집 배타(R-06①): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (main/sub 편집 배타(R-06①)) |
| WK-SCP0001-0556 | A1 | p_new_yn 항상 null | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — p_new_yn 항상 null: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (p_new_yn 항상 null) |
| WK-SCP0001-0557 | A1 | 권한 division 0(R-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 권한 division 0(R-01): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (권한 division 0(R-01)) |
| WK-SCP0001-0558 | A1 | 마스터 미선택(P-06, Insert 방어) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 마스터 미선택(P-06, Insert 방어): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (마스터 미선택(P-06, Insert 방어)) |
| WK-SCP0001-0559 | A1 | 붙여넣기 미일치(R-31) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 붙여넣기 미일치(R-31): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (붙여넣기 미일치(R-31)) |
| WK-SCP0001-0560 | A1 | 외주 Location 불가(R-06②) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 외주 Location 불가(R-06②): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (외주 Location 불가(R-06②)) |
| WK-SCP0001-0561 | A1 | 외주만 Location(OSP)(R-06③) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 외주만 Location(OSP)(R-06③): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (외주만 Location(OSP)(R-06③)) |
| WK-SCP0001-0562 | A1 | 중복 키(R-34/28) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 중복 키(R-34/28): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (중복 키(R-34/28)) |
| WK-SCP0001-0563 | A1 | 탭 전환 차단(R-32) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 탭 전환 차단(R-32): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (탭 전환 차단(R-32)) |
| WK-SCP0001-0564 | A1 | 필수값 공백(R-33) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 필수값 공백(R-33): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (필수값 공백(R-33)) |
| WK-SCP0001-0565 | G1 | ALL → 권한 division 콤마 확장(권한 함정) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ALL → 권한 division 콤마 확장(권한 함정): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ALL → 권한 division 콤마 확장(권한 함정)) |
| WK-SCP0001-0566 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0001-0567 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0001-0568 | G1 | Division 다중 + EE 필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Division 다중 + EE 필터: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Division 다중 + EE 필터) |
| WK-SCP0001-0569 | G1 | OSP/Active YesOrNo + ALL sentinel | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — OSP/Active YesOrNo + ALL sentinel: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (OSP/Active YesOrNo + ALL sentinel) |
| WK-SCP0001-0570 | G1 | Plant/Vendor·Plant Site 텍스트(UPPER LIKE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Plant/Vendor·Plant Site 텍스트(UPPER LIKE): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Plant/Vendor·Plant Site 텍스트(UPPER LIKE)) |
| WK-SCP0001-0571 | G1 | R-01 Division 권한 0건 → 조회영역 비활성 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-01 Division 권한 0건 → 조회영역 비활성: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-01 Division 권한 0건 → 조회영역 비활성) |
| WK-SCP0001-0572 | G1 | R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PLAN_PERIOD): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-07 site 신규행 기본값(SHIP/PROD_FROZEN·FP_PL) |
| WK-SCP0001-0573 | G1 | R-15 customer div→site 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-15 customer div→site 재조회: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-15 customer div→site 재조회) |
| WK-SCP0001-0574 | G1 | R-16 osp plant→storage 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-16 osp plant→storage 재조회: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-16 osp plant→storage 재조회) |
| WK-SCP0001-0575 | G1 | R-31 붙여넣기 name→code(G4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-31 붙여넣기 name→code(G4): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-31 붙여넣기 name→code(G4)) |
| WK-SCP0001-0576 | G1 | Rep 단일성(R-26) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Rep 단일성(R-26): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Rep 단일성(R-26)) |
| WK-SCP0001-0577 | G1 | customer 신규필수(R-38) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — customer 신규필수(R-38): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (customer 신규필수(R-38)) |
| WK-SCP0001-0578 | G1 | main/sub 편집 배타(R-06①) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — main/sub 편집 배타(R-06①): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (main/sub 편집 배타(R-06①)) |
| WK-SCP0001-0579 | G1 | p_new_yn 항상 null | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — p_new_yn 항상 null: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (p_new_yn 항상 null) |
| WK-SCP0001-0580 | G1 | 권한 division 0(R-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 권한 division 0(R-01): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (권한 division 0(R-01)) |
| WK-SCP0001-0581 | G1 | 마스터 미선택(P-06, Insert 방어) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 마스터 미선택(P-06, Insert 방어): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (마스터 미선택(P-06, Insert 방어)) |
| WK-SCP0001-0582 | G1 | 붙여넣기 미일치(R-31) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 붙여넣기 미일치(R-31): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (붙여넣기 미일치(R-31)) |
| WK-SCP0001-0583 | G1 | 외주 Location 불가(R-06②) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 외주 Location 불가(R-06②): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (외주 Location 불가(R-06②)) |
| WK-SCP0001-0584 | G1 | 외주만 Location(OSP)(R-06③) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 외주만 Location(OSP)(R-06③): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (외주만 Location(OSP)(R-06③)) |
| WK-SCP0001-0585 | G1 | 중복 키(R-34/28) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 중복 키(R-34/28): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (중복 키(R-34/28)) |
| WK-SCP0001-0586 | G1 | 탭 전환 차단(R-32) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 탭 전환 차단(R-32): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (탭 전환 차단(R-32)) |
| WK-SCP0001-0587 | G1 | 필수값 공백(R-33) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 필수값 공백(R-33): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (필수값 공백(R-33)) |
| WK-SCP0001-0588 | G6 | ALL → 권한 division 콤마 확장(권한 함정) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — ALL → 권한 division 콤마 확장(권한 함정): 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ALL → 권한 division 콤마 확장(권한 함정)) |
| WK-SCP0001-0589 | G6 | Division 다중 + EE 필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Division 다중 + EE 필터: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Division 다중 + EE 필터) |
| WK-SCP0001-0590 | G6 | OSP/Active YesOrNo + ALL sentinel | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — OSP/Active YesOrNo + ALL sentinel: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (OSP/Active YesOrNo + ALL sentinel) |
| WK-SCP0001-0591 | G6 | Plant/Vendor·Plant Site 텍스트(UPPER LIKE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Plant/Vendor·Plant Site 텍스트(UPPER LIKE): 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Plant/Vendor·Plant Site 텍스트(UPPER LIKE)) |
| WK-SCP0001-0592 | G6 | p_new_yn 항상 null | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — p_new_yn 항상 null: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (p_new_yn 항상 null) |
| WK-SCP0001-0593 | X-LOC | R-01 Division 권한 0건 → 조회영역 비활성 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-01 Division 권한 0건 → 조회영역 비활성: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-01 Division 권한 0건 → 조회영역 비활성) |
| WK-SCP0001-0594 | X-LOC | R-03 Delete=신규행('I') 전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-03 Delete=신규행('I') 전용: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-03 Delete=신규행('I') 전용) |
| WK-SCP0001-0595 | X-LOC | R-04/R-07 편집잠금 카탈로그 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-04/R-07 편집잠금 카탈로그: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-04/R-07 편집잠금 카탈로그) |
| WK-SCP0001-0596 | X-LOC | R-05 packer 2컬럼 행조건 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-05 packer 2컬럼 행조건 잠금: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-05 packer 2컬럼 행조건 잠금) |
| WK-SCP0001-0597 | X-LOC | R-06 sub 편집 3중 배타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R-06 sub 편집 3중 배타: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R-06 sub 편집 3중 배타) |
| WK-SCP0001-0598 | X-LOC | Rep 단일성(R-26) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Rep 단일성(R-26): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Rep 단일성(R-26)) |
| WK-SCP0001-0599 | X-LOC | customer 신규필수(R-38) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — customer 신규필수(R-38): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (customer 신규필수(R-38)) |
| WK-SCP0001-0600 | X-LOC | main/sub 편집 배타(R-06①) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — main/sub 편집 배타(R-06①): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (main/sub 편집 배타(R-06①)) |
| WK-SCP0001-0601 | X-LOC | 권한 division 0(R-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 권한 division 0(R-01): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (권한 division 0(R-01)) |
| WK-SCP0001-0602 | X-LOC | 마스터 미선택(P-06, Insert 방어) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 마스터 미선택(P-06, Insert 방어): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (마스터 미선택(P-06, Insert 방어)) |
| WK-SCP0001-0603 | X-LOC | 붙여넣기 미일치(R-31) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 붙여넣기 미일치(R-31): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (붙여넣기 미일치(R-31)) |
| WK-SCP0001-0604 | X-LOC | 외주 Location 불가(R-06②) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 외주 Location 불가(R-06②): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (외주 Location 불가(R-06②)) |
| WK-SCP0001-0605 | X-LOC | 외주만 Location(OSP)(R-06③) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 외주만 Location(OSP)(R-06③): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (외주만 Location(OSP)(R-06③)) |
| WK-SCP0001-0606 | X-LOC | 중복 키(R-34/28) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 중복 키(R-34/28): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (중복 키(R-34/28)) |
| WK-SCP0001-0607 | X-LOC | 필수값 공백(R-33) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 필수값 공백(R-33): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (필수값 공백(R-33)) |
| WK-SCP0001-0608 | X-ROW | MODAL:CityByCountryModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:CityByCountryModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:CityByCountryModal) |
| WK-SCP0001-0609 | X-ROW | SCP0001_PlantSite.CheckValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.CheckValidation: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 34 (ACT:SCP0001_PlantSite.CheckValidation AC) |
| WK-SCP0001-0610 | X-ROW | SCP0001_PlantSite.ClbDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.ClbDivision_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.ClbDivision_Select) |
| WK-SCP0001-0611 | X-ROW | SCP0001_PlantSite.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.CreateSpread: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.CreateSpread) |
| WK-SCP0001-0612 | X-ROW | SCP0001_PlantSite.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0001_PlantSite.DefineProperty ACT) |
| WK-SCP0001-0613 | X-ROW | SCP0001_PlantSite.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.Dsdm_Changed: 진입점 집계 43검사 — NOT_RUN:37 · REVIEW:3 · NOPATH:3 |  | 15 (ACT:SCP0001_PlantSite.Dsdm_Changed:1544:) |
| WK-SCP0001-0614 | X-ROW | SCP0001_PlantSite.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0001_PlantSite.FindButton) |
| WK-SCP0001-0615 | X-ROW | SCP0001_PlantSite.FindData_LocationOSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.FindData_LocationOSP: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · PASS:1 |  | 6 (ACT:SCP0001_PlantSite.FindData_LocationO) |
| WK-SCP0001-0616 | X-ROW | SCP0001_PlantSite.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.FindData_Main: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0001_PlantSite.FindData_Main:625:) |
| WK-SCP0001-0617 | X-ROW | SCP0001_PlantSite.FindData_Sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.FindData_Sub: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · PASS:1 |  | 6 (ACT:SCP0001_PlantSite.FindData_Sub:727:1) |
| WK-SCP0001-0618 | X-ROW | SCP0001_PlantSite.FindData_SubCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.FindData_SubCustomer: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:1 · NOPATH:1 |  | 4 (ACT:SCP0001_PlantSite.FindData_SubCustom) |
| WK-SCP0001-0619 | X-ROW | SCP0001_PlantSite.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.Form_Load) |
| WK-SCP0001-0620 | X-ROW | SCP0001_PlantSite.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.InitControls: 진입점 집계 11검사 — NOT_RUN:10 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0001_PlantSite.InitControls:261:3) |
| WK-SCP0001-0621 | X-ROW | SCP0001_PlantSite.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.InitEvent: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.InitEvent) |
| WK-SCP0001-0622 | X-ROW | SCP0001_PlantSite.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.InitSpread: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0001_PlantSite.InitSpread ACT:SCP) |
| WK-SCP0001-0623 | X-ROW | SCP0001_PlantSite.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.InsertButton) |
| WK-SCP0001-0624 | X-ROW | SCP0001_PlantSite.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.InsertRow: 진입점 집계 49검사 — NOT_RUN:46 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 64 (ACT:SCP0001_PlantSite.InsertRow ACT:SCP0) |
| WK-SCP0001-0625 | X-ROW | SCP0001_PlantSite.RefreshDetailSalesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.RefreshDetailSalesSite: 진입점 동작 재현 시나리오 필요 — 문장 종류 COMBO_DATA/ENTRY/EXPR, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0001_PlantSite.RefreshDetailSales) |
| WK-SCP0001-0626 | X-ROW | SCP0001_PlantSite.RefreshOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.RefreshOperation: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LOCAL, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0001_PlantSite.RefreshOperation A) |
| WK-SCP0001-0627 | X-ROW | SCP0001_PlantSite.RefreshPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.RefreshPlant: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0001_PlantSite.RefreshPlant ACT:S) |
| WK-SCP0001-0628 | X-ROW | SCP0001_PlantSite.RefreshPlantSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.RefreshPlantSite: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0001_PlantSite.RefreshPlantSite A) |
| WK-SCP0001-0629 | X-ROW | SCP0001_PlantSite.RefreshStorageByDivPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.RefreshStorageByDivPlant: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0001_PlantSite.RefreshStorageByDi) |
| WK-SCP0001-0630 | X-ROW | SCP0001_PlantSite.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.SaveData: 진입점 집계 26검사 — NOT_RUN:16 · PASS:6 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0001_PlantSite.SaveData:940:31 AC) |
| WK-SCP0001-0631 | X-ROW | SCP0001_PlantSite.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.SetChangedControl: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.SetChangedControl) |
| WK-SCP0001-0632 | X-ROW | SCP0001_PlantSite.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.SetImageCell: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.SetImageCell:703:2) |
| WK-SCP0001-0633 | X-ROW | SCP0001_PlantSite.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.SpdMain_CellClick: 진입점 집계 17검사 — NOT_RUN:9 · NOPATH:7 · TODO:1 (미실행 검사가 남아 판정필요) |  | 32 (ACT:SCP0001_PlantSite.SpdMain_CellClick ) |
| WK-SCP0001-0634 | X-ROW | SCP0001_PlantSite.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.SpdMain_CellDoubleClick: 진입점 집계 21검사 — NOT_RUN:13 · NOPATH:5 · REVIEW:3 |  | 15 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0635 | X-ROW | SCP0001_PlantSite.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.SpdMain_ComboSelChange: 진입점 집계 32검사 — NOT_RUN:29 · REVIEW:3 |  | 2 (ACT:SCP0001_PlantSite.SpdMain_ComboSelCh) |
| WK-SCP0001-0636 | X-ROW | SCP0001_PlantSite.SpdMain_KeyPress | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/UI_PROP, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0001_PlantSite.SpdMain_KeyPress A) |
| WK-SCP0001-0637 | X-ROW | SCP0001_PlantSite.SpdSub_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.SpdSub_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0001_PlantSite.SpdSub_ActiveSheet) |
| WK-SCP0001-0638 | X-ROW | SCP0001_PlantSite.SpdSub_ClipboardPasted | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.SpdSub_ClipboardPasted: 진입점 집계 15검사 — NOT_RUN:15 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0001_PlantSite.SpdSub_ClipboardPa) |
| WK-SCP0001-0639 | X-ROW | SCP0001_PlantSite.SpdSub_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.SpdSub_ComboSelChange: 진입점 집계 51검사 — NOT_RUN:41 · NOPATH:7 · REVIEW:3 |  | 16 (ACT:SCP0001_PlantSite.SpdSub_ComboSelCha) |
| WK-SCP0001-0640 | X-ROW | SCP0001_PlantSite.shtCustomerDataModel_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.shtCustomerDataModel_Changed: 진입점 집계 18검사 — NOT_RUN:15 · REVIEW:3 |  | 1 (ACT:SCP0001_PlantSite.shtCustomerDataMod) |
| WK-SCP0001-0641 | X-ROW | SCP0001_PlantSite.spdMainDsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.spdMainDsdm_Changed: 진입점 집계 16검사 — NOT_RUN:12 · REVIEW:3 · NOPATH:1 |  | 2 (ACT:SCP0001_PlantSite.spdMainDsdm_Change) |
| WK-SCP0001-0642 | X-ROW | SCP0001_PlantSite.spdSub_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.spdSub_ActiveSheetChanging: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0001_PlantSite.spdSub_ActiveSheet) |
| WK-SCP0001-0643 | X-ROW | SCP0001_PlantSite.spdSub_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.spdSub_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR, 연결된 요소 검사 없음 |  | 6 (ACT:SCP0001_PlantSite.spdSub_CellClick A) |
| WK-SCP0001-0644 | X-ROW | SCP0001_PlantSite.spdSub_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.spdSub_CellDoubleClick: 진입점 집계 21검사 — NOT_RUN:19 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0645 | X-ROW | SCP0001_PlantSite.spdSub_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.spdSub_EditChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0001_PlantSite.spdSub_EditChange ) |
| WK-SCP0001-0646 | X-ROW | SCP0001_PlantSite.spdSub_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0001_PlantSite.spdSub_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.spdSub_TopChange A) |
| WK-SCP0001-0647 | G5 | MODAL:CustomerModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:CustomerModal: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CustomerModal) |
| WK-SCP0001-0648 | G5 | MODAL:VendorModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:VendorModal: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:VendorModal) |
| WK-SCP0001-0649 | G5 | R-18 HQ Vendor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — R-18 HQ Vendor 팝업: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (R-18 HQ Vendor 팝업) |
| WK-SCP0001-0650 | G5 | R-20 City 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — R-20 City 팝업: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (R-20 City 팝업) |
| WK-SCP0001-0651 | G5 | R-27/28 Customer 팝업+중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — R-27/28 Customer 팝업+중복: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (R-27/28 Customer 팝업+중복) |
| WK-SCP0001-0652 | G5 | SCP0001_PlantSite.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0001_PlantSite.SpdMain_CellDoubleClick: 진입점 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 27 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0653 | G5 | SCP0001_PlantSite.spdSub_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0001_PlantSite.spdSub_CellDoubleClick: 진입점 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0654 | H6 | MODAL:CustomerModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:CustomerModal: 행 집계 — H6 5요소: NOPATH:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CustomerModal) |
| WK-SCP0001-0655 | H6 | MODAL:VendorModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:VendorModal: 행 집계 — H6 5요소: NOPATH:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:VendorModal) |
| WK-SCP0001-0656 | H6 | R-18 HQ Vendor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — R-18 HQ Vendor 팝업: 행 집계 — H6 5요소: NOPATH:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-18 HQ Vendor 팝업) |
| WK-SCP0001-0657 | H6 | R-20 City 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — R-20 City 팝업: 행 집계 — H6 5요소: NOPATH:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-20 City 팝업) |
| WK-SCP0001-0658 | H6 | R-27/28 Customer 팝업+중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — R-27/28 Customer 팝업+중복: 행 집계 — H6 5요소: NOPATH:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R-27/28 Customer 팝업+중복) |
| WK-SCP0001-0659 | H6 | SCP0001_PlantSite.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0001_PlantSite.SpdMain_CellDoubleClick: 진입점 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 27 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0660 | H6 | SCP0001_PlantSite.spdSub_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0001_PlantSite.spdSub_CellDoubleClick: 진입점 집계 — H6 5요소: NOPATH:4 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |
| WK-SCP0001-0661 | M4 | MODAL:CustomerModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:CustomerModal: 행 집계 — M4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CustomerModal) |
| WK-SCP0001-0662 | M4 | MODAL:VendorModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:VendorModal: 행 집계 — M4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:VendorModal) |
| WK-SCP0001-0663 | M4 | R-18 HQ Vendor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — R-18 HQ Vendor 팝업: 행 집계 — M4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R-18 HQ Vendor 팝업) |
| WK-SCP0001-0664 | M4 | R-20 City 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — R-20 City 팝업: 행 집계 — M4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R-20 City 팝업) |
| WK-SCP0001-0665 | M4 | R-27/28 Customer 팝업+중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — R-27/28 Customer 팝업+중복: 행 집계 — M4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R-27/28 Customer 팝업+중복) |
| WK-SCP0001-0666 | M4 | SCP0001_PlantSite.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0001_PlantSite.SpdMain_CellDoubleClick: 진입점 집계 — M4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 27 (ACT:SCP0001_PlantSite.SpdMain_CellDouble) |
| WK-SCP0001-0667 | M4 | SCP0001_PlantSite.spdSub_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0001_PlantSite.spdSub_CellDoubleClick: 진입점 집계 — M4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0001_PlantSite.spdSub_CellDoubleC) |

## W8 구현 후 검증 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0001-0668 | A5 | COMMON:UC-03 | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-SCP0001-0669 | H2 | COMMON:UC-03 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-SCP0001-0670 | H5 | COMMON:UC-03 | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-SCP0001-0671 | D4 | COMMON:UC-03 | 선행 W1 완료 후 E2E | D4 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-SCP0001-0672 | E3 | COMMON:UC-03 | 선행 W1 완료 후 E2E | E3 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-SCP0001-0673 | E4 | COMMON:UC-03 | 선행 W1 완료 후 E2E | E4 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-SCP0001-0674 | A1 | COMMON:UC-03 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-SCP0001-0675 | G1 | COMMON:UC-03 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
