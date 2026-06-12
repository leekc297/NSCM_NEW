# Hook — Menu Button 동적 fetch (Visible/Enable)

> ⚠ **신규/수정 화면 작업 시 반드시 적용**
> 화면의 **모든 Button** (Search/Insert/Delete/Save/Excel/Upload/Manual + customButtons) 은
> SYS0009 **Menu Button** admin UI 에서 관리하는 데이터를 기준으로 Visible / Enable.
> 하드코딩 절대 금지.

작성: 2026-06-12 (사용자 명시 — "UI 생성의 동적 속성관리" Menu Button 부분)
상위 룰: `ui-dynamic-property-management.md`
관련 룰: `_tobe/09_subtitle_hotkey.md` (10대 버튼) / `_tobe/12_metadata_sql.md §13` (MNU_BTN_CD 표준)

---

## §0. 트리거

| 트리거 | 적용 시점 |
|---|---|
| 신규 화면 작성 (T01) | PRE-WRITE 1단계 + 신규 등록 + POST-WRITE |
| Button 추가/수정 (`customButtons`, `hotkeyConfig`) | PRE-WRITE + POST-WRITE |
| Sheet 추가 | PRE-WRITE |
| `hotkeyConfig` 키워드 등장 | POST-WRITE 검증 |

---

## §1. WHY — Menu Button admin UI 의 역할

SYS0009 Menu Button (`menu-button-management`) admin 화면 + 두 테이블이 화면 button 의 표시/권한 일체 관리:

| 테이블 | 의미 | FE 결과 |
|---|---|---|
| `SCM_ADM_MNU_BTN_MPG_M` | 화면별 button 정의 (M:N 화면 × button) | **Visible**: `USE_YN = 'Y'` 면 button 자체 노출 |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 사용자 그룹별 button 권한 | **Enable**: 로그인 사용자 그룹의 row 존재 + `USE_YN = 'Y'` 면 클릭 가능 |

### 1.1 Visible/Enable 결정 매트릭스

| 시나리오 | MNU_BTN_MPG_M | USER_GR_MNU_BTN_MPG_M | Visible | Enable |
|---|---|---|---|---|
| 정상 button | USE_YN='Y' | USE_YN='Y' (사용자 그룹 일치) | ✅ | ✅ |
| admin 이 button 비활성 | USE_YN='N' | (관계없음) | ❌ | - |
| 권한 없음 (사용자 그룹 미부여) | USE_YN='Y' | row 없음 | ✅ | ❌ disabled |
| 정의 자체 없음 | row 없음 | - | ❌ | - |

→ **하드코딩 `hotkeyConfig: { search: handleSearch }` 만 작성** = admin 의 모든 변경 무시 → SCM0008 사고 family.

---

## §2. FE 구현 패턴 (의무)

### 2.1 useTabBtnPermissions hook 사용

```tsx
import { useTabBtnPermissions } from '@shared/hooks';

const SalesPriceComponent = () => {
  const { hasButton, isEnabled } = useTabBtnPermissions({
    menuId: MENU_ID,
    shtNm: SHEETS.MAIN,
  });

  // hotkeyConfig - 권한 + Visible 통합
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save:   hasButton('SAVE')   ? handleSave   : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    excel:  hasButton('EXCEL')  ? handleExcel  : false,
    upload: hasButton('UPLOAD') ? handleUpload : false,
    manual: false,   // admin 정의 자체 없음 (예외 명시)
  };

  // customButtons - 동적
  const customButtons = ALL_CUSTOM_BTNS.filter(b => hasButton(b.code));

  /* ... */
};
```

### 2.2 customButtons 동적 fetch

```tsx
const ALL_CUSTOM_BTNS = [
  { code: 'EXCHANGE_RATE',  label: 'Exchange Rate',  action: () => setOpenExchange(true) },
  { code: 'PRICE_BATCH',    label: 'Price Batch',    action: () => setOpenBatch(true) },
  { code: 'COLUMN_SETUP',   label: 'Column Setup',   action: () => setOpenTitleSet(true) },
  /* ... */
];

const customButtons = useMemo(() => {
  return ALL_CUSTOM_BTNS.filter(b => hasButton(b.code));
}, [hasButton]);

<SubTitle hotkeyConfig={hotkeyConfig} customButtons={customButtons} />
```

### 2.3 SubTitle searchAction

```tsx
<SubTitle
  hotkeyConfig={hotkeyConfig}
  customButtons={customButtons}
  searchAction={hasButton('SEARCH') ? handleSearch : undefined}
  /* ... */
/>
```

---

## §3. 신규 화면 작성 시 신규 등록 의무

### Step 1 — 점검 (PRE-WRITE)

```sql
SELECT b.SHT_NM, b.MNU_BTN_CD, b.USE_YN, COUNT(u.USER_GR_ID) auth_grp_cnt
  FROM SCM_ADM_MNU_BTN_MPG_M b
  LEFT JOIN SCM_ADM_USER_GR_MNU_BTN_MPG_M u
    ON b.MNU_ID = u.MNU_ID AND b.SHT_NM = u.SHT_NM AND b.MNU_BTN_CD = u.MNU_BTN_CD AND u.USE_YN = 'Y'
 WHERE b.MNU_ID = '{NEW_MENU_ID}'
 GROUP BY b.SHT_NM, b.MNU_BTN_CD, b.USE_YN;
```

→ 0 건 또는 부족 → Step 2.

### Step 2 — deploy SQL BLOCK 3 (멱등 INSERT)

```sql
-- 표준 6 button (SEARCH, INSERT, DELETE, SAVE, EXCEL, MANUAL) for each sheet
WITH bt AS (
  SELECT '{NEW_MENU_ID}' MNU_ID, sh.SHT_NM, b.MNU_BTN_CD, '{NEW_MENU_ID}_'||sh.SHT_NM||'_'||b.MNU_BTN_CD API_ID
    FROM (SELECT 'main' SHT_NM FROM DUAL UNION ALL SELECT 'popup' FROM DUAL) sh
    CROSS JOIN (SELECT 'SEARCH' MNU_BTN_CD FROM DUAL UNION ALL SELECT 'INSERT' FROM DUAL UNION ALL
                SELECT 'DELETE' FROM DUAL UNION ALL SELECT 'SAVE' FROM DUAL UNION ALL
                SELECT 'EXCEL' FROM DUAL UNION ALL SELECT 'MANUAL' FROM DUAL) b
)
INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT bt.MNU_ID, bt.SHT_NM, bt.MNU_BTN_CD, bt.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM bt
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M e
                    WHERE e.MNU_ID = bt.MNU_ID AND e.SHT_NM = bt.SHT_NM AND e.MNU_BTN_CD = bt.MNU_BTN_CD);

-- USER_GR_MNU_BTN_MPG_M (사용자 그룹 권한 — 자매 화면 그룹 동적 복사)
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, b.MNU_ID, b.SHT_NM, b.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_ADM_MNU_BTN_MPG_M b
  CROSS JOIN (SELECT DISTINCT USER_GR_ID FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
                WHERE MNU_ID = '{SISTER_MENU_ID}' AND SHT_NM = 'main' AND MNU_BTN_CD = 'SEARCH') u
 WHERE b.MNU_ID = '{NEW_MENU_ID}'
   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M e
                    WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = b.MNU_ID
                      AND e.SHT_NM = b.SHT_NM AND e.MNU_BTN_CD = b.MNU_BTN_CD);
```

### Step 3 — admin UI 변경 시 자동 반영

- 화면 mount 시 `useTabBtnPermissions` 가 BE 호출 → fresh 결과 적용
- Search 시점에도 fetch (현 정책: button 변경 즉시 반영)
- BE cache 사용 시 SYS0009 SAVE 트리거가 cache invalidate 필요

---

## §4. PRE-WRITE 자기 점검

- [ ] `SCM_ADM_MNU_BTN_MPG_M` 의 `{NEW_MENU_ID}` × `{SHT_NM}` × MNU_BTN_CD 정의 존재?
- [ ] `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 의 사용자 그룹 권한 정의 존재?
- [ ] 부재 시 deploy SQL BLOCK 3 / BLOCK 7 멱등 INSERT 포함?
- [ ] FE `useTabBtnPermissions` hook 사용?
- [ ] `hotkeyConfig` 가 `hasButton(...)` 조건부 callback 사용?
- [ ] `customButtons` 가 `hasButton(...)` 필터링 사용?
- [ ] 하드코딩된 `search: handleSearch` 직접 작성 없음?

---

## §5. POST-WRITE 자동 검증 (grep)

```bash
# 1) hotkeyConfig 하드코딩 검출 — hasButton 없이 직접 callback
grep -rn "hotkeyConfig.*=\s*{" features/*/src/pages/{NEW_SCREEN}/{Screen}.tsx -A 10 \
  | grep -E "search:\s*handle|insert:\s*handle|save:\s*handle" \
  | grep -v "hasButton"

# 2) useTabBtnPermissions 미사용 검출
grep -L "useTabBtnPermissions" features/*/src/pages/{NEW_SCREEN}/{Screen}.tsx

# 3) deploy SQL BLOCK 3 (MNU_BTN_MPG_M) 존재 검출
grep -l "INSERT INTO SCM_ADM_MNU_BTN_MPG_M\|MERGE INTO SCM_ADM_MNU_BTN_MPG_M" \
  _artifacts/_deploy_packages/{NEW_MENU_ID}/03_META/*.sql

# 4) deploy SQL BLOCK 7 (USER_GR_MNU_BTN_MPG_M) 존재 검출
grep -l "INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M" \
  _artifacts/_deploy_packages/{NEW_MENU_ID}/03_META/*.sql
```

---

## §6. anti-pattern 사고 사례

### 6.1 (실제) hotkeyConfig 일괄 false (SCM0008 사고)
```tsx
// ❌ 9 키 모두 false → Sort/Filter/Excel 까지 숨김 → 사용자 조회 불가
const hotkeyConfig = {
  insert: false, delete: false, save: false, search: false,
  condition: false, resetCondition: false, excel: false, upload: false, manual: false,
};
```
→ **fix**: Hidden allowlist 정책 (insert/delete/save 만 false 명시, 나머지 자동 활성).
참조: 메모리 `feedback_common_button_visibility_default.md`

### 6.2 (실제) `search: handleSearch` 직접 — admin USE_YN 무시
```tsx
const hotkeyConfig = { search: handleSearch };   // ❌
```
→ **fix**: `search: hasButton('SEARCH') ? handleSearch : false`.

### 6.3 (실제) BLOCK 3 미작성 → BE callProc "권한없음"
- 새 화면 deploy SQL 작성 시 BLOCK 3 누락
- 결과: SCM_ADM_USER_GR_MNU_BTN_MPG_M 정의 자체 없어서 권한 매칭 실패
- fix: BLOCK 3 + BLOCK 7 멱등 INSERT 추가
- 참조: SCM0008/SCM0009 사고

### 6.4 (실제) MNU_BTN_CD = 'RETRIEVE' (오타)
- 표준 = `SEARCH` / 일부 화면이 'RETRIEVE' 사용 → 권한 매칭 안 됨
- 참조: 메모리 `feedback_button_code_consistency_search_vs_retrieve.md`
- fix: 표준 SEARCH 사용. 표준 인벤토리 = `SEARCH/INSERT/DELETE/SAVE/EXCEL/UPLOAD/MANUAL/CONDITION/SORT/FILTER`

---

## §7. Cross-ref

- 상위: `Doc/_rules_v2/hooks/ui-dynamic-property-management.md`
- 동급: `Doc/_rules_v2/hooks/ui-category-setup-column-meta.md` (Column / Measure)
- 룰 09 §2.2.1 — 공통 버튼 기본 표시 정책
- 룰 12 §13 — MNU_BTN_CD 표준
- 메모리: `feedback_common_button_visibility_default.md` / `feedback_button_code_consistency_search_vs_retrieve.md` / `feedback_search_button_when_no_searcharea.md`

---

## §8. 위반 시 대응

- PRE-SUBMIT 시 §4 + §5 모두 통과 의무
- 1건이라도 위반 = PR 머지 차단
- 사고 사례 §6 중 어느 것이라도 재현 가능 → 즉시 fix
- anti-simplification 위반 (하드코딩으로 admin 결정 무시) = 도구 사용 중단
