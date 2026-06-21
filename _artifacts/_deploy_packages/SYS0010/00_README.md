# SYS0010 Lookup — 클라우드 이관 패키지 v1 full

생성일: 2026-06-12
작성자: minyonglee1
범위: SYS0010 (Lookup) 전체 파일

## 1. 변경 요약

- UI 동적 속성관리 (master hook) 적용: store staticColumns + fetchStaticColumns + Grid prop + Search refetch
- FE source: features/admin/src/pages/lookup

## 2. 폴더 구조

```
SYS0010_v1_full/
├─ 00_README.md
├─ 01_FE/lookup/
├─ 03_META/
│  ├─ 01_MNU_i18n.sql
│  ├─ 02_SHEET_COLUMNS.sql
│  ├─ 03_MNU_BTN_MPG.sql
│  ├─ 04_API_M.sql
│  ├─ 05_PROC_M.sql
│  └─ 06_USER_GR_BTN.sql
└─ 04_PKG_SP/
```

## 3. 적용 순서

### Step 1. FE 복사
```bash
cd nscm-fe/
cp -r /path/01_FE/lookup  features/admin/src/pages/
pnpm type-check && pnpm build
```

### Step 2. SP body 컴파일
```sql
@04_PKG_SP/*.sql
```

### Step 3. DB 메타
```sql
@03_META/01_MNU_i18n.sql
@03_META/02_SHEET_COLUMNS.sql
@03_META/03_MNU_BTN_MPG.sql
@03_META/04_API_M.sql
@03_META/05_PROC_M.sql
@03_META/06_USER_GR_BTN.sql
```

### Step 4. BE 재기동

### Step 5. 화면 검증

## 4. 참조 룰

- master hook: `Doc/_rules_v2/hooks/ui-dynamic-property-management.md`
- column 메타: `Doc/_rules_v2/hooks/ui-category-setup-column-meta.md`
- button: `Doc/_rules_v2/hooks/menu-button-dynamic-fetch.md`
- 클라우드 type-check: `Doc/_rules_v2/hooks/fe-cloud-type-lint-readiness.md`
