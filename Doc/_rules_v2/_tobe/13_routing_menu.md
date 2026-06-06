# TO-BE 룰 13 — Routing / Menu (MNU_URL slug + route-paths.ts + 메뉴 미표시 디버깅)

> **추출 reference**: `nscm-fe/apps/web/src/app/router/route-paths.ts` (추정) + 메모리 `reference_scm_adm_mnu_m_url_slug.md` / `feedback_mnu_uppr_case_standard.md` / `feedback_sheet_name_main_standard.md` / hook `menu-not-displayed-debug.md`

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 13 |
| 토픽 | MNU_URL slug + FE route-paths.ts 매핑 + 메뉴 미표시 7단계 디버깅 |
| 적용 trigger | 신규 화면 라우팅 등록 |
| 관련 hook | `menu-not-displayed-debug.md` |

---

## §1 표준 (의무)

### §1.1 MNU_URL 형식 (메모리 룰)

> 메모리 `reference_scm_adm_mnu_m_url_slug.md`:

**의무**:
```sql
INSERT INTO SCM_ADM_MNU_M (..., MNU_URL, ...)
VALUES (..., 'sales-future-price', ...);   -- ⭐ slug only (leaf)
```

**금지**:
```sql
MNU_URL = '/master/demand-master/sales-future-price'   -- ❌ 전체 path
MNU_URL = '/sales-future-price'   -- ❌ leading slash
```

**사유**: FE 라우터가 자동으로 부모 트리 walk-up 해서 전체 경로 조립. MNU_URL 에 slug 만 있어도 `/master/demand-master/sales-future-price` 자동 생성.

### §1.2 FE route-paths.ts 매핑 의무

```typescript
// nscm-fe/apps/web/src/app/router/route-paths.ts
export const ROUTE_PATHS = {
  // ...
  CUSTOMER_FORECAST_MASTER: 'customer-forecast-master',   // ← MNU_URL 과 정확 일치
  SALES_SITE: 'sales-site',
  SALES_SITE_PROJECT_MODEL: 'sales-site-project-model',
  CUSTOMER_MODEL_MAPPING: 'customer-model-mapping',
  // ...
};
```

**의무**: DB `SCM_ADM_MNU_M.MNU_URL` 값과 FE `ROUTE_PATHS.X` 값 정확히 일치 (slug, kebab-case).

### §1.3 React Router 등록

```typescript
// nscm-fe/apps/web/src/app/router/AppRouter.tsx (또는 동등)
import { CustomerForecastMaster } from '@master/pages/customer-forecast-master';

const routes = [
  // ...
  { path: ROUTE_PATHS.CUSTOMER_FORECAST_MASTER, element: <CustomerForecastMaster tabId={...} title={...} /> },
];
```

→ `path` 도 slug only. 부모 path 는 부모 router 가 처리.

### §1.4 MDI Tab 통합 (룰 15 cross-ref)

```typescript
import { LazyLoader } from '@shared/components';

// MDI 탭 정의
{
  path: ROUTE_PATHS.CUSTOMER_FORECAST_MASTER,
  element: <LazyLoader load={() => import('@master/pages/customer-forecast-master')} />,
}
```

→ React.lazy + Suspense + ErrorBoundary 통합.

---

## §2 표준 부모 메뉴 인벤토리 (메모리 룰)

> 메모리 `feedback_mnu_uppr_case_standard.md`: `UPPR_MNU_ID` 대소문자 표준.

### §2.1 Lv1 부모 (대분류)

| UPPR_MNU_ID 값 | 의미 |
|---|---|
| `Master` | 마스터 데이터 (`/master/`) |
| `Demand` | Demand (`/demand/`) |
| `Report` | Report (`/report/`) |
| `Admin` | 관리자 (`/admin/`) |
| `Authority` | 권한 (`/authority/`) |
| `Popup` | 공용 popup (`/popup/`) — 메뉴에는 표시 안 함 |
| `OPT` | Optimization (`/opt/`) |

### §2.2 Lv2 부모 (중분류 — Demand 도메인)

| UPPR_MNU_ID 값 | 의미 | 자매 화면 예 |
|---|---|---|
| `Demand_Master` | 마스터 (DMF0004~) | DMF0004 SalesSite / DMF0007 CustomerFcstMaster / DMF0020 SalesFuturePrice |
| `Demand_Plan` | 계획 | (DMP000~) |
| `Demand_Report` | 리포트 | (DMR000~) |
| `Demand_Shipment` | 배송 | (DMS000~) |
| `SCM_Master` | SCM 마스터 | (SCM 도메인) |

### §2.3 ⚠️ 사고 패턴 (DMF0020 메뉴 미표시 사고)

**금지**:
```sql
UPPR_MNU_ID = 'DEMAND_MASTER'   ❌ 대문자 → 부모 트리 walk-up 실패
```

**의무**:
```sql
UPPR_MNU_ID = 'Demand_Master'   ✅ PascalCase + underscore (자매 화면 7개 표준)
```

→ 자매 화면 (DMF0004 / DMF0007 등) 의 UPPR_MNU_ID 정확 복사. 임의 변경 금지.

---

## §3 SHT_NM 표준 (메뉴 미표시 사고 회피)

### §3.1 의무 (메모리 룰)

> 메모리 `feedback_sheet_name_main_standard.md`:

**의무**:
```sql
-- 단일 sheet 화면
INSERT INTO SCM_ADM_MNU_M_SHEET ... (MNU_ID, SHT_NM, ...) VALUES ('DMF0099', 'main', ...);

-- FE constants.ts
export enum SHEETS {
  MAIN = 'main',   // ⭐ 'main' 표준
}
```

### §3.2 ⚠️ 사고 패턴 (DMF0020)

**금지**:
```sql
-- DB
SHT_NM = 'futurePrice'   ❌ 화면 의미 이름

-- FE constants.ts
SHEETS.MAIN = 'futurePrice'   ❌
```

**증상**: 화면 진입 시 `ORA-01403` at `PKG_NSCM_UI_COMM:17` (retrieveBtnInfoList) — SHT_NM 불일치로 메뉴 조회 실패.

**의무**: 단일 sheet 는 항상 `'main'`. 다중 sheet 만 의미 이름 (DMF0008 `summary` / `repair` / `sspm`).

---

## §4 7-단계 메뉴 미표시 디버깅 (hook 룰화)

> hook `menu-not-displayed-debug.md` 의 7단계 (메모리 + 룰 21):

### §4.1 사용자 신고 "메뉴 클릭 후 화면 안 나옴" 시 (또는 "권한 없다고 떠요")

> ⚠️ **권한 누락 단정 금지**. 7단계 순서로 진단.

### §4.2 Step 1 — MNU_URL ↔ FE slug 정합

```bash
# DB
SELECT MNU_URL FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0099';
-- 결과: 'new-screen'

# FE
grep -n "ROUTE_PATHS.\|new-screen" nscm-fe/apps/web/src/app/router/route-paths.ts
# 결과: ROUTE_PATHS.NEW_SCREEN = 'new-screen'  ← 일치 확인
```

→ 불일치 시 fix.

### §4.3 Step 1.5 — UPPR_MNU_ID 대소문자 정합 (DMF0020 사고)

```bash
SELECT UPPR_MNU_ID FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0099';
-- 'Demand_Master'   ← PascalCase 표준 확인

-- 자매 화면 cross-check
SELECT MNU_ID, UPPR_MNU_ID FROM SCM_ADM_MNU_M WHERE UPPR_MNU_ID = 'Demand_Master';
-- 7+ 자매 화면 표시 (DMF0004 등)
```

### §4.4 Step 1.6 — SHT_NM 자매 화면 cross-check (DMF0020 사고)

```bash
SELECT SHT_NM FROM SCM_ADM_MNU_M_SHEET WHERE MNU_ID = 'DMF0099';
-- 'main'   ← 표준

-- FE 와 일치 확인
grep "SHEETS\." features/master/src/pages/new-screen/new-screen.constants.ts
-- SHEETS.MAIN = 'main'   ← 일치
```

### §4.5 Step 2 — FE 라우터 등록 정합

```bash
grep -n "new-screen\|NewScreen" nscm-fe/apps/web/src/app/router/
# AppRouter 또는 동등 안에 등록되어 있는지 확인
```

### §4.6 Step 3 — 메뉴 권한 확인 (`SCM_ADM_USER_GR_MNU_MPG_M`)

```sql
SELECT FIND_AUTH_YN FROM SCM_ADM_USER_GR_MNU_MPG_M 
WHERE USER_ID = 'minyonglee1' AND GR_ID = 'ADMIN' AND MNU_ID = 'DMF0099';
-- 'Y' 또는 NULL (NULL = row 없음 = 권한 누락)
```

### §4.7 Step 4 — 부모 권한 확인 (Lv1 + Lv2)

```sql
SELECT MNU_ID, FIND_AUTH_YN 
FROM SCM_ADM_USER_GR_MNU_MPG_M 
WHERE USER_ID='minyonglee1' AND MNU_ID IN ('Master', 'Demand_Master');
-- 부모 권한 없으면 자식 메뉴 표시 안 됨
```

### §4.8 Step 5 — 런타임 오류 (브라우저 콘솔)

```
F12 콘솔 → 404 / 500 / TypeError 확인
```

흔한 오류:
- `_setOwnerList is not a function` (Wijmo FlexGridColumnGroup 사고 — 룰 07 §3.2)
- `value?.trim is not a function` (NUMBER → String 변환 사고 — 룰 07 §3.6)
- 404 (BE endpoint 미등록)

### §4.9 Step 6 — BE 메타 누락 (PROC_M / API_M)

```sql
SELECT COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM = 'P_DMF0099_GET_MAIN';
-- 0 이면 메타 누락 → BLOCK 4 INSERT 필요 → PLS-00306 사고

SELECT COUNT(*) FROM SCM_ADM_API_M WHERE MNU_ID = 'DMF0099';
-- 0 이면 endpoint 등록 누락 → BLOCK 5 INSERT 필요
```

### §4.10 Step 7 — i18n 누락

```bash
grep "MSG00099\|LBL00501" nscm-fe/apps/web/public/locales/ko/translation.json
# 등록 안 되면 텍스트 = key 자체 표시 (사용성 ↓)
```

---

## §5 router-paths.ts 의 build (메모리 룰)

### §5.1 작성 시점

신규 화면 추가 시:
1. BLOCK 2 (`SCM_ADM_MNU_M`) 의 `MNU_URL = 'new-screen'` INSERT
2. FE `ROUTE_PATHS.NEW_SCREEN = 'new-screen'` 추가
3. AppRouter 안에 `path: ROUTE_PATHS.NEW_SCREEN, element: <NewScreen />` 등록

### §5.2 자동 검증

```bash
# DB 의 모든 MNU_URL 추출
DB_URLS=$(sqlplus -s ... "SELECT MNU_URL FROM SCM_ADM_MNU_M WHERE MNU_URL IS NOT NULL")

# FE 의 ROUTE_PATHS 값 추출
FE_URLS=$(grep -oE "'\w+(-\w+)*'" nscm-fe/apps/web/src/app/router/route-paths.ts)

# 차이 비교
diff <(echo "$DB_URLS" | sort) <(echo "$FE_URLS" | sort)
# 0 = 일치, > 0 = 불일치 사고 위험
```

---

## §6 MDI 탭 + Tab 영속화 (룰 15 cross-ref)

### §6.1 tabId prop 전달

```typescript
// AppRouter 또는 MDI 탭
<NewScreen tabId={getTabId()} title={t('LBL_NEW_SCREEN')} />
```

→ `tabId` 가 store 의 persistent key 의 일부 (`createPersistedStoreWithTab` 의 slug + tabId).

### §6.2 TabWrapper persist

```typescript
<TabWrapper persist activeTabIndex={activeIndex} setActiveTabIndex={setActiveIndex}>
  <TabItem label={...}><Grid1 /></TabItem>
  <TabItem label={...}><Grid2 /></TabItem>
</TabWrapper>
```

→ MDI 탭 닫고 다시 열어도 마지막 active tab 복원.

---

## §7 금지 (anti-pattern)

### §7.1 MNU_URL 에 leading slash / full path

**금지**:
```sql
MNU_URL = '/sales-future-price'   ❌
MNU_URL = '/master/demand-master/sales-future-price'   ❌
```

**의무**: slug only (`'sales-future-price'`).

### §7.2 UPPR_MNU_ID 대문자

**금지**:
```sql
UPPR_MNU_ID = 'DEMAND_MASTER'   ❌
UPPR_MNU_ID = 'demand_master'   ❌
```

**의무**: PascalCase (`'Demand_Master'`).

### §7.3 SHT_NM 의 자유명 (단일 sheet)

**금지**:
```sql
SHT_NM = 'futurePrice'   ❌ (단일 sheet)
SHT_NM = 'salesSite'     ❌
```

**의무**: 단일 sheet = `'main'`. 다중 sheet = 의미명 (`summary` / `customer` 등).

### §7.4 FE slug 와 MNU_URL 불일치

**금지**: DB 의 `MNU_URL = 'new-screen'` 인데 FE 의 ROUTE_PATHS 가 `NEW_SCREEN = 'newScreen'` (camelCase) → 라우터 매칭 실패.

**의무**: 둘 다 kebab-case 정확 일치.

### §7.5 메뉴 미표시 시 "권한 없다" 단정 (메모리 룰)

**금지** (메모리 `feedback_mnu_uppr_case_standard.md` 사고 원인):
- 메뉴 미표시 → 즉시 권한 INSERT 시도 → 4 화면 사고

**의무**: 7-단계 디버깅 (§4) 의 Step 1~Step 7 모두 검증. 권한 누락은 Step 3~4 에서만 결정.

---

## §8 자동 검증 (PR 머지 게이트)

```bash
# 1. MNU_URL 형식 (slug only)
sqlplus -s ... "SELECT COUNT(*) FROM SCM_ADM_MNU_M WHERE MNU_URL LIKE '/%' OR MNU_URL LIKE '%/%'"   # = 0

# 2. UPPR_MNU_ID 대문자 (사고 패턴)
sqlplus -s ... "SELECT COUNT(*) FROM SCM_ADM_MNU_M WHERE UPPR_MNU_ID IN ('DEMAND_MASTER','MASTER','DEMAND','REPORT')"   # = 0

# 3. SHT_NM 단일 sheet 표준
sqlplus -s ... "SELECT MNU_ID, SHT_NM FROM SCM_ADM_MNU_M_SHEET WHERE SHT_NM NOT IN ('main','summary','repair','sspm','customer','location','bucket','production','purchase','customerFcst','customerPsi','customerModelMapping') AND ..."
# 자매 화면 표준 외 자유명 검출

# 4. FE ROUTE_PATHS ↔ DB MNU_URL 정합
# (위 §5.2 의 diff 명령)

# 5. AppRouter 등록 확인
grep -c "NewScreen" nscm-fe/apps/web/src/app/router/AppRouter.tsx   # ≥ 1

# 6. ⭐ MNU_DESC NULL 검출 (2026-06-09 SYS0015 사고) — 메뉴 트리 sidebar 표시 의무
sqlplus -s ... "SELECT COUNT(*) FROM SCM_ADM_MNU_M WHERE MNU_DESC IS NULL AND USE_YN='Y'"   # = 0
# MNU_DESC NULL = sidebar 에 메뉴명 표시 못해서 skip → 화면 미표시
```

---

## §10 MNU_DESC 필수 의무 (2026-06-09 신규)

### §10.1 사고 (SYS0015 Program)

신규 메뉴 INSERT 시 `MNU_DESC` 컬럼 누락 → DB row 는 있지만 sidebar 메뉴 트리에서 미표시.
- BE `PR_GET_MENU_LIST` 결과: `{MNU_ID:'SYS0015', MNU_URL:'program', MNU_DESC: null, ...}` 정상 반환
- FE sidebar: `MNU_DESC` 가 NULL 인 row 는 메뉴명 렌더 불가로 skip → **메뉴 안 보임**

### §10.2 의무 패턴

```sql
-- ✅ 의무 — MNU_DESC 명시
INSERT INTO SCM_ADM_MNU_M
  (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, MNU_TP_CD, UNIT_TP_CD, MNU_LV_NO, USE_YN, SORT_ORD, ...)
VALUES ('SYS0015', 'Admin_Menu', 'program', 'MNU_SYS0015',
        'Program' /* ⭐ 의무 */, 'SCREEN', '-', 3, 'Y', 150, ...);
```

```sql
-- ❌ 금지 — MNU_DESC 누락
INSERT INTO SCM_ADM_MNU_M (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, ...) VALUES (...);  -- MNU_DESC 컬럼 미포함
```

### §10.3 자매 화면 cross-check

```sql
SELECT MNU_ID, MNU_DESC FROM SCM_ADM_MNU_M WHERE MNU_ID IN ('SYS0001','SYS0010','SYS0013','{NEW_ID}');
-- 자매 화면 모두 MNU_DESC 채워져 있어야 함
```

### §10.4 cross-ref

- hook `menu-not-displayed-debug.md` §1.3.5 (Step 1.7)
- 메모리 `feedback_mnu_desc_required.md`
- 사고: SYS0015 (2026-06-09)

---

## §9 AS-IS 매핑

| AS-IS BaseForm + FoxForm | TO-BE Routing |
|---|---|
| `BaseForm.ViewModel.MenuId` (화면 ID) | `MENU_ID` const (constants.ts) |
| `openSubMenu(prgId, ...)` (자식 메뉴 열기) | MDI 탭 + `useNavigate(ROUTE_PATHS.X)` |
| `openSubMenu` 의 `msc` (ManualSearchCondition) | `useNavigate(..., { state: { ... } })` 또는 store action |
| `Authentication.SaveMenuConnect` (open/close 로그) | Phase 5 G3 `@PerfLog action='menu_open'/'menu_close'` |
| `GSCM_MainForm.OpenUserMenu(prgId)` | React Router + MDI 탭 (룰 15) |
| WinForms MDI Parent + Child | React + TabWrapper persist (룰 03 §2.2) |

---

## §10 reference 위치

| 위치 | 용도 |
|---|---|
| `nscm-fe/apps/web/src/app/router/route-paths.ts` | FE ROUTE_PATHS 정의 |
| `nscm-fe/apps/web/src/app/router/AppRouter.tsx` (또는 동등) | React Router 등록 |
| `SCM_ADM_MNU_M` (DB) | MNU_URL / UPPR_MNU_ID 등록 |
| `Doc/_dev_rules/15_ROUTING_MDI.md` (기존 룰 v1) | 상세 라우팅 정책 (Phase 4 에서 유지 결정 검토) |

---

## §11 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | route-paths.ts + MNU_URL slug + 메모리 룰 (UPPR_MNU_ID 대소문자 + SHT_NM main) + 7-단계 디버깅 통합 |
