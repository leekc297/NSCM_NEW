# DMF0043_01 Contribution Sales — 클라우드 이관 패키지 v3 full

생성일: 2026-06-12
작성자: minyonglee1
범위: DMF0043_01 (조회 전용, 해외법인 기여매출) 전체 파일 + 성능 튜닝 인덱스

---

## 1. 변경 요약

### 1.1 화면명 변경
- FE MNU00031: `Overseas Subs. Contribution Sales` → **`Contribution Sales`** (KO/EN/CN 3 lang)
- DB MNU_DESC: `해외법인 기여매출` 유지 (한글)

### 1.2 SP body 수정
- `DMF0043_GET_CONTRIBUTION_SALES_LIST` (line 334, 561):
  - `'' AS PRODUCT_GROUP` → `'N' AS PRODUCT_GROUP` (SITE_ITEM REPORT_GROUP3 dropped 회피)
  - 사내 schema 정렬 (메모리 `feedback_dropped_column_get_save_alignment.md`)

### 1.3 성능 튜닝 인덱스 (2026-06-11 적용)
- `IDX01_DM_MST_CONTRIBUTE_RATIO_DTL` (8-key: VER_SEQ + 6 join + YYYYMMDD) NOLOGGING COMPRESS 4
- `IDX_DM_PLN_SALES_PLAN_REPORT_C_VMD` (VERSION_NO+MEASURE+DIVISION+YYYYMMDD)
- `FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1` (REGEXP_SUBSTR OWNER FBI)
- DBMS_STATS 3 tables refresh

### 1.4 화면 작업
- ContributeView 읽기 전용 (Insert/Save 제거)
- HierarchicalMergeManager BASE 9 cols cascade merge
- ContributeVersionModal / ColumnTitleSetModal
- ColumnSettingModal 공용 컴포넌트 (DMF0020 과 공유)

---

## 2. 폴더 구조

```
DMF0043_01_v3_full/
├─ 00_README.md
├─ 01_FE/
│  ├─ contribute-view/             → features/master/src/pages/
│  ├─ components/columnSettingModal/  → features/master/src/components/  (DMF0020 공유)
│  └─ locales/                     → public/locales/  (KO/EN/CN.json — MNU00031 'Contribution Sales')
├─ 03_META/
│  ├─ 01_MNU_i18n.sql
│  ├─ 02_SHEET_COLUMNS.sql         (VersionPopup 5 cols)
│  ├─ 03_MNU_BTN_MPG.sql           (6 buttons)
│  ├─ 04_API_M.sql                 (0 entries — API_M 별도 등록 필요 검증)
│  ├─ 05_PROC_M.sql                (2 SPs signature)
│  └─ 06_USER_GR_BTN.sql           (USER_GR_MNU_BTN_MPG_M 자매 복사)
├─ 04_PKG_SP/
│  ├─ DMF0043_GET_CONTRIBUTION_SALES_LIST.sql   (main SP)
│  └─ _indexes.sql                              (성능 튜닝 3 인덱스 + STATS)
└─ 05_VERIFY/
```

---

## 3. 적용 순서

### Step 1. FE 소스 복사
```bash
cd nscm-fe/
cp -r /path/01_FE/contribute-view/                features/master/src/pages/
cp -r /path/01_FE/components/columnSettingModal/  features/master/src/components/   # DMF0020 과 공유
cp /path/01_FE/locales/*.json                      public/locales/
pnpm type-check && pnpm build
```

### Step 2. DB SP body
```sql
@04_PKG_SP/DMF0043_GET_CONTRIBUTION_SALES_LIST.sql
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST';
```

### Step 3. 성능 튜닝 인덱스 (운영 시간 외 권장)
```sql
@04_PKG_SP/_indexes.sql       -- ONLINE 옵션 적용 — 운영 중 가능
```

### Step 4. DB 메타
```sql
@03_META/01_MNU_i18n.sql
@03_META/02_SHEET_COLUMNS.sql
@03_META/03_MNU_BTN_MPG.sql
@03_META/04_API_M.sql        -- ⚠ 0 entries: 사내에 API_M 등록되어 있는지 확인 후 별도 등록
@03_META/05_PROC_M.sql
@03_META/06_USER_GR_BTN.sql
```

### Step 5. BE 재기동 + 화면 검증
- 로그인 → 메뉴: Master → Demand Master → **Contribution Sales**
- 조회 가능 조건: VER_SEQ=12 + R_S_20260128_V002_C
- HierarchicalMergeManager BASE 9 cols cell merge
- ColumnSettingModal popup 동작

---

## 4. 참조 룰
- 동적 속성관리: `Doc/_rules_v2/hooks/ui-dynamic-property-management.md` (master)
- column/measure: `Doc/_rules_v2/hooks/ui-category-setup-column-meta.md`
- i18n: `Doc/_rules_v2/hooks/i18n-ko-en-alignment.md` (KO=EN 전체 통일)
- 메모리:
  - `feedback_dropped_column_get_save_alignment.md` (SITE_ITEM REPORT_GROUP3 dropped)
  - `feedback_corporate_schema_dropped_col_save_default.md`
  - `feedback_wijmo_hierarchical_merge.md`

---

## 5. 알려진 제약
- main grid 의 RATIO/TARGET 값 표시는 사내 데이터 마이그레이션 후 확인 필요
- 기존 cloud 데이터 (원통형 26K rows 등) 미표시 — PRODUCT_GROUP 정렬 후속 작업 (별도 데이터 마이그레이션 결정 보류)

---

## 6. 롤백
- SP body: DBMS_METADATA.GET_DDL 백업 후 작업
- 인덱스: `DROP INDEX SCM_MGR.IDX01_DM_MST_CONTRIBUTE_RATIO_DTL;` 등
- 메타: MERGE/DELETE+INSERT — 재실행 가능
- FE: git revert
