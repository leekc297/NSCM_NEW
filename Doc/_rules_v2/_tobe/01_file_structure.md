# TO-BE 룰 01 — 파일 구조 / 폴더 구조

> **추출 reference**: DMF0004 (sales-site) / DMF0005 (sales-site-project-model) / DMF0006 (customer-model-mapping) / DMF0007 (customer-forecast-master)

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 01 |
| 토픽 | 파일/폴더 구조 |
| 적용 trigger | 신규 화면 생성 |
| 관련 hook | `screen-create-checklist.md`, `pre-write.md` |

---

## §1 표준 폴더 구조

### §1.1 의무

신규 화면은 다음 구조 정확히 준수:

```
nscm-fe/features/{domain}/src/pages/{kebab-case-screen-name}/
├─ index.ts                              ⭐ 의무: 단 한 줄 export
├─ {PascalCaseName}.tsx                  ⭐ 의무: 메인 컴포넌트 (entry)
├─ use{PascalCaseName}Store.ts           ⭐ 의무: Zustand store
├─ {kebab-case-name}.constants.ts        ⭐ 의무: MENU_ID / SHEETS / RESPONSE_SET enum
├─ {kebab-case-name}.types.ts            (선택 — SearchParamProps 분리 시)
├─ components/                            ⭐ 의무: sub-component 폴더
│  ├─ {PascalCaseName}Form.tsx          (SearchArea + Form)
│  ├─ {PascalCaseName}Grid.tsx           (DataGrid)
│  └─ (추가 sheet grid: {Name}DetailGrid.tsx)
├─ utils/                                 (선택 — 화면 특화 util)
│  └─ {functionPurpose}.ts
└─ {PascalCaseName}.module.scss          (선택 — 화면 layout 특화)
```

### §1.2 명명 규약 의무

| 항목 | 형식 | 예 |
|---|---|---|
| 폴더 | `kebab-case` | `customer-model-mapping`, `sales-site-project-model` |
| 메인 컴포넌트 | `PascalCase.tsx` | `CustomerModelMapping.tsx`, `SalesSiteProjectModel.tsx` |
| Store | `use{PascalCase}Store.ts` | `useCustomerModelMappingStore.ts` |
| Constants | `{kebab-case}.constants.ts` | `customer-model-mapping.constants.ts` |
| Types (선택) | `{kebab-case}.types.ts` | `customer-model-mapping.types.ts` |
| Sub-component | `{PascalCase}{Purpose}.tsx` | `CustomerModelMappingForm.tsx`, `SalesSiteProjectModelGrid.tsx` |

> **단일 source of truth**: 폴더명 = MENU_ID 의 영문 의미 (DMF0006 = customer-model-mapping). MENU_ID 자체 (DMF0006) 는 폴더명에 사용 안 함.

### §1.3 features 폴더 매핑 (신규 화면 위치 결정 의무) — Phase 7 후속 추가 (2026-06-04)

> 신규 화면 작성 시 `{domain}` 폴더 결정 = **SCM_ADM_MNU_M 의 최상위 부모 MNU_ID** (UPPR_MNU_ID 트리 walk-up Lv 0) 기준.

| 최상위 MNU_ID | features 폴더 | 자식 메뉴 예 |
|---|---|---|
| `Master` | `features/master/` | DMF0004 sales-site / DMF0005 sales-site-project-model / DMF0006 customer-model-mapping / DMF0007 customer-fcst-master / DMF0008 erp-edi-master / DMF0020 sales-future-price / DMF0043/0043_01 contribute-main/view / DMF0072 nn-master-mapping |
| `Demand` | `features/demand/` | DMF0014 customer-fcst-upload / DMF0082 forecast-price |
| `Report` | `features/report/` | DMF0022 sales-plan-waterfall |
| `Admin` | `features/admin/` | SYS0001 message-management / SYS0002 user-management / SYS0003 menu-management / SYS0005 procedure-management / SYS0006 api-management / SYS0010 lookup / SYS0013 dynamic-query |
| `Authority` | `features/authority/` | SYS0011 auth-request / SYS0012 auth-approval |

⚠️ **사고 사례 (Phase 7 후속, 2026-06-04)**: SCM0008 Auth Request (UPPR_MNU_ID=Auth_Mgmt) 의 최상위 부모는 `Authority` — `features/authority/` 가 정답. UPPR_MNU_ID 만 보고 admin 으로 잘못 매핑 → 9 파일 중복 작성 사고. **트리 walk-up 의무**.

### §1.4 신규 화면 작성 전 5 단계 의무 grep (anti-simplification)

```bash
# 1. SCM_ADM_MNU_M 트리 walk-up (최상위 부모 식별)
sqlplus> WITH parents AS (
            SELECT MNU_ID, UPPR_MNU_ID, MNU_DESC, 0 AS LV FROM SCM_ADM_MNU_M WHERE MNU_ID = '{TARGET_MENU_ID}'
            UNION ALL
            SELECT m.MNU_ID, m.UPPR_MNU_ID, m.MNU_DESC, p.LV + 1
              FROM SCM_ADM_MNU_M m JOIN parents p ON m.MNU_ID = p.UPPR_MNU_ID
         )
         SELECT * FROM parents ORDER BY LV DESC;

# 2. 최상위 MNU_ID → features 폴더 매핑 (§1.3 표)

# 3. Router.tsx import 검색 (기존 작성 여부)
rg -nE "from '@(admin|authority|master|demand|report|supply|shipping|factory)/{kebab-case}'" \
    nscm-fe/apps/web/src/core/Router.tsx
# 결과 ≥ 1 → 기존 작성됨 → cross-check 만 (신규 작성 금지)

# 4. features/{layer}/src/pages/ 인벤토리 grep (자매 화면 + 표준 패턴)
ls nscm-fe/features/{layer}/src/pages/

# 5. 결과 보고 — 신규 작성 / cross-check 결정 + 자매 reference + 패턴
```

→ 5 단계 누락 시 **anti-simplification 위반** + 중복 작성 사고 위험.

---

## §2 허용 변형

### §2.1 `components/` 오타 (`componenets/`)

**현실**: DMF0005 (`componenets/`) + DMF0007 (`componenets/`) 가 오타 (`componenets` = component 의 오타). DMF0004 (`components/`) + DMF0006 (`components/`) 는 정상.

**룰**: **신규 화면은 무조건 `components/` 사용**. 기존 오타는 향후 rename 대상 (별도 PR).

### §2.2 `index.ts` 형식

**의무**:
```typescript
export { CustomerModelMapping } from './CustomerModelMapping';
```

**금지**:
- 여러 export
- default export
- type export 통합

### §2.3 sub-component 추가 (multi-sheet 화면)

| 화면 | sub-component 수 | 예 |
|---|---:|---|
| DMF0006 (single sheet) | 2 | Form + Grid |
| DMF0004 (4 sheet) | 5 | Form + Grid + CustomerGrid + LocationGrid + BucketGrid |
| DMF0005 (2 sheet) | 3 | Form + Grid + PurchaseGrid |
| DMF0007 (2 sheet + dynamic) | 3 | Form + FcstGrid + PsiGrid |

→ sheet 별로 별도 Grid 컴포넌트 분리. 메인 grid 외 sheet 는 명시적 이름 (Customer/Location/Bucket/Purchase/Fcst/Psi).

### §2.4 utils/ 폴더 (선택)

| 화면 | utils 파일 | 용도 |
|---|---|---|
| DMF0004 | `sales-site.util.ts` | applySalesSite (SCM_SITE_ID 자동 생성) |
| DMF0007 | `CustomerFcstMasterDateColumns.ts` | `getFcstRangeByBucket(bucket)` — 동적 date column 생성 |

→ 화면 특화 util 만 utils/. 공용 util 은 `@foundation/utils` 또는 `@shared/utils` 에 추가 (별도 PR).

---

## §3 금지 (anti-pattern)

### §3.1 폴더명 = MENU_ID

**금지**:
```
features/master/src/pages/DMF0006/   ❌
```

**의무**:
```
features/master/src/pages/customer-model-mapping/   ✅
```

**사유**: MENU_ID 는 변경되지만 영문 의미는 stable. URL routing (route-paths.ts) 도 영문 slug 사용.

### §3.2 sub-component 인라인 정의

**금지**: 메인 컴포넌트 안에 Form / Grid 컴포넌트 인라인 정의. 200 lines 이상 시 분할 의무.

### §3.3 *.module.scss 외의 CSS 파일

**금지**: `.css` 또는 `.scss` (global) 신규 작성.
**의무**: SCSS Module (`*.module.scss`) 만 사용. global CSS 는 `_tobe/14_error_handling.md` § styling 참조.

### §3.4 알리아스 이외 상대 경로 import

**금지**:
```typescript
import { Foo } from '../../../shared/components';   ❌
```

**의무**:
```typescript
import { Foo } from '@shared/components';   ✅
```

상세는 `_tobe/02_imports.md` 참조.

---

## §4 자동 검증 (PR 머지 게이트)

```bash
# 1. 표준 폴더 구조 검증
test -f "{path}/index.ts"
test -f "{path}/{PascalName}.tsx"
test -f "{path}/use{PascalName}Store.ts"
test -f "{path}/{kebab-name}.constants.ts"

# 2. index.ts 한 줄 export
grep -c "^export " {path}/index.ts  # = 1

# 3. 폴더명 검증 (MENU_ID 사용 금지)
case $(basename "{path}") in
  DMF*) echo "ERROR: MENU_ID as folder name"; exit 1 ;;
esac

# 4. sub-component components/ 폴더 (componenets 오타 금지)
test ! -d "{path}/componenets"  # 신규 = 무조건 components

# 5. SCSS Module 검증
find {path} -name "*.scss" | grep -v ".module.scss" | wc -l  # = 0
```

---

## §5 AS-IS 매핑

| AS-IS (GSCM) | TO-BE (NSCM) |
|---|---|
| `06.UIL/GSCM.DM.Master.UIL/DMF0006_CustomerModelMapping.cs` | `nscm-fe/features/master/src/pages/customer-model-mapping/` |
| `.cs` 파일 1 + `.Designer.cs` 파일 1 | 7+ .ts/.tsx 파일 (분할) |
| Form_Load + InitForm + InitControls + CreateSpread + InitSpread + InitEvent 통합 | `useEffect + fetchStaticColumns` (lifecycle 자동) |
| protected override CRUD 메서드 | `handleInsert / handleDelete / handleSave + hotkeyConfig` |

---

## §6 reference file:line 인용

| 패턴 | reference |
|---|---|
| 최소 폴더 구조 | `nscm-fe/features/master/src/pages/customer-model-mapping/` (DMF0006) |
| 최대 폴더 구조 | `nscm-fe/features/master/src/pages/sales-site/` (DMF0004 — 4 sheet) |
| index.ts 표준 | `customer-model-mapping/index.ts:1` |
| utils 사용 예 | `customer-forecast-master/utils/CustomerFcstMasterDateColumns.ts` |
| types 분리 예 | `customer-model-mapping/customer-model-mapping.types.ts` |

---

## §7 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | DMF0004~7 reference 분석 |
