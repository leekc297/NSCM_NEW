# DMF0043 — Contribute Main 클라우드 이관 패키지

작성: 2026-06-02

---

## 1. 개요

DMF0043 (Contribute Main — 기여율 입력 화면) PIVOT 동적 컬럼 + 12 컬럼 + Validator + Version/Rate Popup.

### 1.1 적용 범위

| 영역 | 변경 |
|---|---|
| FE | 신규 화면 `contribute-main` (11 파일 — SearchBar / Grid / ContributeRatePopup / VersionPopup / Validators 포함) |
| DB 메타 | API_M / BTN_MPG / PROC_M / GUEST 권한 + SHEET_COLUMNS dedupe |
| SP / PKG | 다수 fix (61_Full_Oracle_Conversion, 56_SHEET_COLUMNS_Dedupe, 57_PK_NonUnique, 63/64_SITE_ITEM DimData) |

---

## 2. 폴더 구조

```
DMF0043/
├── README.md
├── 01_FE/
│   └── contribute-main/                ← 화면 파일 (12 파일)
├── 02_DB_Meta_SQL/                     ← 메타 등록
│   └── 41_DMF0043_meta.sql
├── 03_SP_PKG/                          ← SP/PKG/Seed/Cleanup SQL
│   ├── 46_DMF0043_Seed_Version_Data.sql
│   ├── 47_DMF0043_Seed_Ratio_MST_DTL.sql
│   ├── 48_DMF0043_CONTRIBUTE_MAIN_DATA_OpenFallback.sql
│   ├── 51_DMF0043_GET_MAIN_SPREAD_TITLE_22Col_Fallback.sql
│   ├── 55_DMF0043_GET_MAIN_SPREAD_TITLE_EditYnColRemove.sql
│   ├── 56_DMF0043_SHEET_COLUMNS_Dedupe.sql
│   ├── 57_SCM_MST_SHEET_COLUMNS_PK_NonUnique_Plus_DMF0043_Dedupe.sql
│   ├── 61_DMF0043_GET_CONTRIBUTE_MAIN_DATA_Full_Oracle_Conversion.sql
│   ├── 63_DMF0043_SITE_ITEM_AsIs_DimData_Import.sql
│   └── 64_DMF0043_SITE_ITEM_DimData_BySiteOnly.sql
└── 04_Verify/                          ← (각 SQL 의 사후 카운트 BLOCK)
```

---

## 3. 적용 순서

### Step 1. DB 메타 (02_DB_Meta_SQL/)
```
@41_DMF0043_meta.sql  → MSG_M / API_M / BTN_MPG / PROC_M / GUEST 권한
```

### Step 2. SP / PKG / Seed / Cleanup (03_SP_PKG/) — 순서 의무

```
1) @56_DMF0043_SHEET_COLUMNS_Dedupe.sql            → 기존 duplicate cleanup (필요시)
2) @57_SCM_MST_SHEET_COLUMNS_PK_NonUnique_*.sql    → PK NonUnique fix
3) @51_DMF0043_GET_MAIN_SPREAD_TITLE_22Col_Fallback.sql
4) @55_DMF0043_GET_MAIN_SPREAD_TITLE_EditYnColRemove.sql
5) @61_DMF0043_GET_CONTRIBUTE_MAIN_DATA_Full_Oracle_Conversion.sql  ← 메인 SP 본문 Oracle 변환
6) @48_DMF0043_CONTRIBUTE_MAIN_DATA_OpenFallback.sql                ← OPEN cursor fallback
7) @46_DMF0043_Seed_Version_Data.sql                                 ← Seed: version 데이터
8) @47_DMF0043_Seed_Ratio_MST_DTL.sql                                ← Seed: ratio 마스터/상세
9) @63_DMF0043_SITE_ITEM_AsIs_DimData_Import.sql                     ← SITE_ITEM dim data import (As-Is)
10) @64_DMF0043_SITE_ITEM_DimData_BySiteOnly.sql                     ← SITE 기준 dim 보강
```

### Step 3. FE 파일 배포
```
contribute-main/ → nscm-fe/features/master/src/pages/contribute-main/
```

### Step 4. BE 재시작 + 브라우저 검증

1. 메뉴 DMF0043 진입
2. Version Popup 선택 → 메인 grid 조회 (PIVOT 12 × 9 = 108 컬럼 + BASE 6 = 114)
3. 기여율 입력 + Validation (합계 100%) + 저장
4. Rate Popup 동작 확인

---

## 4. 의존성

| 항목 | 위치 |
|---|---|
| As-Is `.cs` | `Doc/_legacy_source/06_UIL/domain_DM/.../DMF0043_Contribute_Main/` |
| To-Be PKG | `PKG_DMF0043` (BODY VALID 의무) |
| SITE_ITEM 데이터 | DimData import SQL 적용 후 row 충분 (1.5M+ 권장) |

---

## 5. 영향 분석

- 메타: ~30 row (API_M / BTN_MPG / PROC_M 등)
- SP CREATE OR REPLACE: 3종 (MAIN SPREAD TITLE / CONTRIBUTE_MAIN_DATA)
- Seed: Version + Ratio MST/DTL 데이터 (운영 데이터 동기화 필요 시)

---

## 6. 변경 이력

- 2026-06-02: 본 패키지 작성 (DMF0043 풀스택 + fix 통합)
