# SYS0013 Dynamic Query — 클라우드 이관 패키지 v1 full

생성일: 2026-06-12 · **2026-06-22 PKG/SP 추가 (클라우드 SQL Error fix)**
작성자: minyonglee1
범위: SYS0013 (Dynamic Query) 전체 파일

## ⚠️ 2026-06-22 클라우드 SQL Error fix — PKG/SP 추가 이관

> 사용자 보고: SYS0013 화면 오픈 시 BE `-9994 SQL Error`. dev/local 정상.
> ROOT CAUSE: PKG_SYS0013 + 종속 SP/FUNC/TYPE 클라우드 누락.

### 추가 이관 파일 (dev/local DDL 기반 — 적용 순서 의존 우선)

| 순서 | 파일 | 행수 | 내용 |
|---:|---|---:|---|
| 1 | `04_PKG_SP/500_DQ_TYPES.sql` | 124 | TYPE 8 (FN_DQ_*_ROW/TAB + T_DQ_*) — 의존 root |
| 2 | `04_PKG_SP/400_FN_DQ_FUNCTIONS.sql` | 1,242 | FN_DQ_* 4 functions (FP_PLAN/MKT_FCST_81/PROD_PLAN/STOCK) |
| 3 | `04_PKG_SP/300_PR_DM_ADM_DQ_ALL.sql` | 1,639 | PR_DM_ADM_DQ_* 10 procedures (HIST + CREATE) |
| 4 | `04_PKG_SP/200_SYS0013_ALL_SP.sql` | 1,129 | SYS0013_* standalone 14 procedures |
| 5 | `04_PKG_SP/100_PKG_SYS0013_FULL.sql` | **1,984** | ⭐ PKG_SYS0013 spec + body (main API entry, 77 KB) |
| 6 | `04_GRANT_SYNONYM/100_GRANT_SCMD_APP.sql` | 111 | EXECUTE/SELECT/INSERT/UPDATE/DELETE + PUBLIC SYNONYM 일괄 (37 EXECUTE + 10 TABLE + 5 SEQ) |

### BTN_MPG api_ids → 실 SP path (8 API)
- GET_QUERY_LIST / EXECUTE_QUERY / GET_COLUMNS / GET_PARAMETERS / SAVE_QUERY / SAVE_COLUMNS / SAVE_PARAMETERS → `PKG_SYS0013.P_SYS0013_*`
- GET_HISTORY → `SYS0013_GET_HISTORY` (standalone)

### 적용 절차 (SCM_MGR 계정)
```
1. 500_DQ_TYPES.sql           (의존 root)
2. 400_FN_DQ_FUNCTIONS.sql    (TYPE 사용)
3. 300_PR_DM_ADM_DQ_ALL.sql   (PR_DM_ADM_DQ_*)
4. 200_SYS0013_ALL_SP.sql     (SYS0013_* standalone)
5. 100_PKG_SYS0013_FULL.sql   (PKG spec + body)
6. 100_GRANT_SCMD_APP.sql     (SCMD_APP 권한 + SYNONYM)
7. 화면 진입 검증
```

### 검증
- `SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_SYS0013'` → BODY VALID
- SCMD_APP 으로 `PKG_SYS0013.P_SYS0013_GET_QUERY_LIST` 호출 시 cursor 반환

---


## 1. 변경 요약

- UI 동적 속성관리 (master hook) 적용: store staticColumns + fetchStaticColumns + Grid prop + Search refetch
- FE source: features/admin/src/pages/dynamic-query

## 2. 폴더 구조

```
SYS0013_v1_full/
├─ 00_README.md
├─ 01_FE/dynamic-query/
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
cp -r /path/01_FE/dynamic-query  features/admin/src/pages/
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
