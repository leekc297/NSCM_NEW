# TO-BE 룰 05 — Constants (MENU_ID / SHEETS / RESPONSE_SET)

> **추출 reference**: DMF0006 (단순) + DMF0004 (multi-sheet + RESPONSE_SET) + DMF0007 (SHEET_INDEX)

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 05 |
| 토픽 | constants.ts (MENU_ID + SHEETS + RESPONSE_SET + SHEET_INDEX) |
| 적용 trigger | 신규 화면 constants 작성 |
| 관련 hook | (없음 — i18n 룰 cross-ref) |

---

## §1 표준 구조 (의무)

### §1.1 단일 sheet 화면 (DMF0006 baseline)

```typescript
export const MENU_ID = 'DMF0006' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  CUSTOMER_MODEL_MAPPING = 'customerModelMapping',
}

export enum RESPONSE_SET {
  DATA = 'o_rc1',
}
```

**의무 사항**:
| # | 의무 | 의미 |
|---:|---|---|
| 1 | `MENU_ID` const 정의 + `typeof MENU_ID` 타입 alias | 화면 진입 권한 / API URL 의 `:menuId` |
| 2 | `SHEETS` enum 정의 | useTabProcQuery / useProcMutation 의 sheetName 인자 |
| 3 | SHEETS value 형식 = `camelCase` 또는 `'main'` | BE response 와 매칭 |
| 4 | `RESPONSE_SET` enum 정의 | BE response 의 key |
| 5 | 단일 sheet 의 RESPONSE_SET = `'o_rc1'` (BE 기본 응답 key) | DMF0006 표준 |

### §1.2 Multi-sheet 화면 (DMF0004)

```typescript
export const MENU_ID = 'DMF0004' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  SITE = 'site',
  CUSTOMER = 'customer',
  LOCATION = 'location',
  BUCKET = 'bucket',
}

export enum RESPONSE_SET {
  SITE = 'salesSite',
  CUSTOMER = 'salesCustomer',
  LOCATION = 'salesLocation',
  BUCKET = 'salesBucket',
}

export enum SHEET_INDEX {
  SITE,
  CUSTOMER,
  LOCATION,
  BUCKET,
}
```

**추가 의무 (multi-sheet)**:
| # | 의무 | 의미 |
|---:|---|---|
| 1 | SHEETS 의 각 value = camelCase + 의미 (FE 요청 sheetName) | `site` / `customer` / 등 |
| 2 | RESPONSE_SET 의 각 value = camelCase + 의미 있는 이름 (BE response key) | `salesSite` / `salesCustomer` / 등 |
| 3 | SHEETS 와 RESPONSE_SET 1:1 매핑 (같은 enum key) | `SHEETS.SITE` ↔ `RESPONSE_SET.SITE` |
| 4 | `SHEET_INDEX` enum (선택) — gridRefs[] array 인덱스 매핑용 | 0/1/2/3 (numeric enum) |

### §1.3 SHEETS value 형식 표준

| 화면 종류 | SHEETS value | reference |
|---|---|---|
| 단일 sheet (메인 = main) | `'main'` (메뉴 미표시 사고 회피, 메모리 `feedback_sheet_name_main_standard.md`) | DMF0020 표준 |
| 단일 sheet (의미 있는 이름) | camelCase 자유 (`'customerModelMapping'` 등) | DMF0006 |
| Multi-sheet | 각 sheet 의 camelCase 자유 | DMF0004 (`site/customer/location/bucket`) |

> **⚠️ 메모리 의무**: 화면 메뉴 등록 시 FE 의 SHEETS value 와 DB `SCM_ADM_API_M.SHT_NM` 일치 의무. 불일치 → ORA-01403. 의무: BLOCK 6 의 `SHT_NM` = FE `SHEETS.MAIN = 'main'` 표준.

---

## §2 허용 변형

### §2.1 추가 sub-enum

| 화면 | 추가 enum | 용도 |
|---|---|---|
| DMF0004 | `SHEET_INDEX` | gridRefs[] array 인덱스 매핑 |
| DMF0005 | `SHEET_INDEX` (PRODUCTION/PURCHASE) | activeTab state 매핑 |
| DMF0007 | `SHEET_INDEX` (CUSTOMER_FCST/CUSTOMER_PSI) | activeIndex 매핑 |

### §2.2 SHEETS value 가 RESPONSE_SET value 와 다른 경우

```typescript
// DMF0004 예
SHEETS.SITE = 'site'              // FE 요청: { sheetName: 'site' }
RESPONSE_SET.SITE = 'salesSite'   // BE 응답: { salesSite: [...] }
```

→ BE response 의 key 가 의미 있게 명명 (단순 'o_rc1' 보다 가독성 ↑). `useTabProcQuery<MENU_ID, SHEETS.SITE>` 의 ResponseData 타입이 자동 매핑.

### §2.3 화면별 추가 const

| 추가 | 예 | 사용 |
|---|---|---|
| `CRUD_TYPE` import | `import { CRUD_TYPE } from '@foundation/constants'` (별도) | DMF0007 의 `CRUD_TYPE.MODIFY` |
| `MEASURE_GROUP` 등 화면 특화 | `MEASURE_GROUP.CUST_FCST = 'CUST_FCST'` | DMF0007 |
| Bucket 종류 | `BUCKET_TYPE.DAILY / WEEKLY / MONTHLY` | DMF0007 |

→ 화면 특화 const 는 constants.ts 에 추가. 다만 `@foundation/constants` 의 표준 (CRUD_TYPE / CELL_INPUT_EDIT_TYPE) 은 별도 import.

---

## §3 금지 (anti-pattern)

### §3.1 MENU_ID 형식 위반

**금지**:
```typescript
export const MENU_ID = 'DMF0006';   ❌ as const 누락 → string 으로 추론
export const MENU_ID: string = 'DMF0006';   ❌ 동일
```

**의무**:
```typescript
export const MENU_ID = 'DMF0006' as const;   ✅
export type MENU_ID = typeof MENU_ID;        // type alias 의무
```

**사유**: `as const` 없으면 type 이 `string` 으로 추론되어 generic 타입 (`<MENU_ID>`) 작동 안 함.

### §3.2 SHEETS value = MENU_ID 또는 PascalCase

**금지**:
```typescript
export enum SHEETS {
  MAIN = 'DMF0006',          ❌ MENU_ID 재사용
  MAIN = 'CustomerModelMapping',  ❌ PascalCase
  MAIN = 'customer_model_mapping',  ❌ snake_case
}
```

**의무**:
```typescript
export enum SHEETS {
  MAIN = 'main',                 ✅ (단일 sheet 시 권장)
  X = 'customerModelMapping',    ✅ camelCase
}
```

### §3.3 RESPONSE_SET 누락

**금지**: 단일 sheet 화면이지만 RESPONSE_SET 정의 안 함 → `data?.o_rc1` 가 type 추론 안 됨.

**의무**:
```typescript
export enum RESPONSE_SET {
  DATA = 'o_rc1',   // 단일 sheet
}
```

### §3.4 i18n LBL 코드 위반 (메모리 룰 위반 사례)

**reference 코드 (위반 사례)**:
```typescript
// DMF0007 의 CustomerFcstMaster.tsx:218
<TabItem label={t('LBL_DMF0007_CUSTOMER_FCST', '_Customer FCST')}>   ❌ 자유 형식
```

**의무 (메모리 `feedback_i18n_lbl_code_pattern.md` 룰)**:
- 신규 화면: `LBL` + 5자리 숫자만 (`LBL00501` ~)
- 자유 형식 (`LBL_DMF0007_X`) 절대 금지
- 신규 영역은 KO.json 최대값 +1 부터 100-block 단위 (DMF0020 = LBL00501~514)

→ DMF0007 의 자유 형식은 **레거시** — 신규 화면은 따라가지 않음.

---

## §4 자동 검증 (PR 머지 게이트)

```bash
CONST="features/{domain}/src/pages/{screen}/{kebab-name}.constants.ts"

# 1. MENU_ID 형식
grep -E "^export const MENU_ID = '[A-Z0-9_]+' as const;" "$CONST" | wc -l  # = 1
grep -E "^export type MENU_ID = typeof MENU_ID;" "$CONST" | wc -l  # = 1

# 2. SHEETS enum 존재
grep -c "^export enum SHEETS " "$CONST"  # ≥ 1

# 3. RESPONSE_SET enum 존재
grep -c "^export enum RESPONSE_SET " "$CONST"  # ≥ 1

# 4. SHEETS value 형식 (camelCase 또는 'main')
awk '/^export enum SHEETS/,/^}/' "$CONST" | grep -E "='[A-Z_]+'"  # 결과 = 0 (대문자/언더스코어 금지)

# 5. i18n LBL 코드 자유 형식 검증 (메모리 룰)
rg "LBL_[A-Z]+_" features/{domain}/src/pages/{screen}/ | wc -l  # = 0
```

---

## §5 AS-IS 매핑

| AS-IS | TO-BE |
|---|---|
| `_MenuID = "DMF0006"` (BaseForm 속성) | `MENU_ID = 'DMF0006' as const` |
| `_MenuGroup = "DMF0006"` | (TO-BE 미사용) |
| `siMain.SheetName = "Main"` | `SHEETS.MAIN = 'main'` |
| `siSub.SheetName = "Customer"` | `SHEETS.CUSTOMER = 'customer'` |
| `MessageHelper.GetTerm("LBL_DIVISION")` | `t('LBL00001')` (5자리 표준) |

---

## §6 reference file:line 인용

| 패턴 | reference |
|---|---|
| 단일 sheet | `customer-model-mapping.constants.ts` (10 lines) |
| Multi-sheet + RESPONSE_SET 의미명 | `sales-site.constants.ts` (23 lines) |
| SHEET_INDEX (배열 매핑) | `sales-site.constants.ts:18-23` |
| BUCKET / Project Model (2 sheet) | `sales-site-project-model.constants.ts` (17 lines) |
| Customer FCST / PSI | `customer-fcst-master.constants.ts` (17 lines) |

---

## §7 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | DMF0004~7 constants 통합 분석 + i18n LBL 위반 사례 식별 |
| 2026-06-12 | SHEETS enum 값 = 클라우드 `procedures.d.ts` 유니온 정확 일치 + DB `SCM_ADM_MNU_BTN_MPG_M.SHT_NM` 정렬 의무. i18n 키 KO=EN 정확 동일 의무 (CN 제외). **hook `fe-cloud-type-lint-readiness.md` §1 + `i18n-ko-en-alignment.md`** 참조 | DMF0020 클라우드 TS2820 + 다국어 영문화 정책 |
