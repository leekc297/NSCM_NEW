# Hook — asis-button-mapping (CRUD 6 + Search Aux 4 = 10 키 매핑 의무)

> **트리거**: 신규 화면 hotkeyConfig 작성 시
>
> **목적**: AS-IS .cs 의 button override + BaseForm default → TO-BE hotkeyConfig 의 10 키 매핑 의무

---

## §0 PRE-WRITE 분석 (메모리 `feedback_asis_button_mapping_mandatory.md`)

### §0.1 AS-IS .cs 의 CRUD 6대 (protected override)

```bash
CS="GSCM/06.UIL/.../DMF{XXX}_*.cs"

# AS-IS override 인벤토리
grep -cE "protected override void (FindButton|InsertButton|EditButton|DeleteButton|SaveButton|ExcelButton|HelpButton|CloseButton)\s*\(" "$CS"
```

→ override 있음 = 화면이 그 동작 사용. override 없음 = BaseForm default (대부분 빈 메서드).

### §0.2 AS-IS .cs 의 Search Aux 4대 (BaseForm.cs default)

> BaseForm.cs 의 `OnClickSortButton` (5268) / `OnClickFilterButton` (5054) / `OnClickConditionButton` (5237) / `OnClickResetConditionButton` (5245) — non-virtual.

도메인 화면이 override 하지 않으면 BaseForm default 사용 (Search Aux 4대 모두 자동 활성).

### §0.3 AS-IS UsrConditionPanel 사용 여부

```bash
DESIGNER="GSCM/06.UIL/.../DMF{XXX}_*.Designer.cs"
grep -c "new UsrConditionPanel" "$DESIGNER"
# 1 = 있음 (Condition / ResetCondition 의미 있음)
# 0 = 없음 (condition / resetCondition 의미 없음 — false 명시)
```

---

## §1 hotkeyConfig 10 키 결정

### §1.1 CRUD 6 키 (의무 명시)

```typescript
const hotkeyConfig: HotkeyConfig = {
  search: handleSearch,      // F5 — Find override → handleSearch (setFilters 등)
  insert: handleInsert,      // F8 — InsertButton override → handleInsert (GridAction.addRow)
  delete: handleDelete,      // F9 — DeleteButton override → handleDelete (GridAction.removeRow)
  save: handleSave,          // F7 — SaveButton override → handleSave (saveWithValidation + mutate)
  // F2 (Edit) → 미사용 (column meta 자동)
  // F12 (Excel) → SubTitle excelFileName 자동
  manual: false,             // 의무 (Help 매뉴얼 미사용)
  upload: false,             // 의무 (Excel 업로드 미사용)
};
```

### §1.2 Search Aux 4 키 (정책)

```typescript
// (a) UsrConditionPanel 있음 + AS-IS 의 OnClickConditionButton 의미 있음:
//     → condition / resetCondition 생략 (자동 활성 — Phase 5 G1 후)
//     → sort / filter 생략 (자동 활성)

// (b) UsrConditionPanel 없음 + 조회조건 영역 자체 없음:
//     → condition: false, resetCondition: false (명시)
//     → sort / filter 생략 (자동 활성)
```

### §1.3 customButtons (화면 특화)

AS-IS 의 화면 안 추가 button 이 있으면 `customButtons` 로 매핑:

```typescript
customButtons: [
  {
    id: 'auto-sync',
    label: t('LBL_AUTO_SYNC'),
    icon: <SyncIcon />,
    onClick: handleAutoSync,
  },
];
```

---

## §2 POST-WRITE grep 검증

```bash
MAIN="features/{domain}/src/pages/{screen}/{Name}.tsx"
CS="GSCM/06.UIL/.../DMF{XXX}_*.cs"

# 1. AS-IS override CRUD 카운트 = TO-BE hotkeyConfig 의 명시 키 카운트
AS_OVR=$(grep -cE "protected override void (FindButton|InsertButton|DeleteButton|SaveButton)" "$CS")
TO_KEYS=$(awk '/hotkeyConfig:.*HotkeyConfig/,/^\s*\};/' "$MAIN" | grep -cE "(search|insert|delete|save):\s*(handle|set)")
test "$TO_KEYS" -ge "$AS_OVR"

# 2. manual / upload 명시 의무
awk '/hotkeyConfig:.*HotkeyConfig/,/^\s*\};/' "$MAIN" | grep -c "manual:"   # ≥ 1
awk '/hotkeyConfig:.*HotkeyConfig/,/^\s*\};/' "$MAIN" | grep -c "upload:"   # ≥ 1

# 3. () => undefined / () => {} 금지
grep -cE "=> undefined|=> \{\s*\}" "$MAIN"   # = 0

# 4. UsrConditionPanel 0건 + condition 명시
USR_COND=$(grep -c "new UsrConditionPanel" "$(dirname $CS)/$(basename $CS .cs).Designer.cs")
if [ "$USR_COND" = "0" ]; then
  awk '/hotkeyConfig:.*HotkeyConfig/,/^\s*\};/' "$MAIN" | grep -c "condition: false"   # ≥ 1
fi
```

---

## §3 PR 머지 게이트

- [ ] __asis-mapping__.md 에 **Button 매핑 표** 의무 (AS-IS override 6 + Aux 4 → TO-BE hotkeyConfig 10 키)
- [ ] AS-IS .cs `protected override` 카운트 = __asis-mapping__.md Button 매핑 행 수
- [ ] `() => undefined` 빈 handler = 0 건 (사고 패턴)

---

## §4 적용 룰 cross-ref

| 항목 | 룰 |
|---|---|
| 10 키 매핑 표 | `_tobe/09_subtitle_hotkey.md` §2 |
| 공통 버튼 기본 표시 정책 (2026-06-06) | `_tobe/09_subtitle_hotkey.md` §2.2.1 |
| SearchArea 부재 searchAction (2026-06-06) | `_tobe/09_subtitle_hotkey.md` §2.5 |
| AS-IS BaseForm CRUD 6 + Aux 4 | `_asis/00_framework/01_BaseForm.md` §3 |
| `() => undefined` 금지 | 메모리 `feedback_asis_button_mapping_mandatory.md` |
| 일괄 false 금지 (2026-06-06) | 메모리 `feedback_common_button_visibility_default.md` |
| Search Aux 기본 활성 | 메모리 `feedback_search_aux_default_activation.md` |
| customButtons 패턴 | `_tobe/09_subtitle_hotkey.md` §4 |

---

## §5 ⭐ 공통 버튼 기본 표시 정책 (2026-06-06 사용자 명시 요구)

> **"각 화면에 공통기능 버튼은 기본적으로 전체를 표기하는 것을 전체로 추가/삭제 기능이 없으면 추가/삭제 버튼은 삭제, 저장기능이 없으면 저장 버튼은 삭제 그외 버튼은 전체가 항상 보이고 기능을 구현해주세요. 조회조건이 없는 경우에는 공통버튼 왼쪽에 서치 버튼 추가해주세요."**

### §5.1 의무 매트릭스

| 키 | 정책 | false 허용 조건 |
|---|---|---|
| `insert` | **Hidden allowlist** | AS-IS InsertButton 없음 + customButtons 가 대체 |
| `delete` | **Hidden allowlist** | AS-IS DeleteButton 없음 + customButtons 가 대체 |
| `save` | **Hidden allowlist** | AS-IS SaveButton 없음 + customButtons 즉시 mutate |
| `search` | **Always-visible** | false 금지. SearchArea 처리 또는 `searchAction` prop 의무 |
| `sort` | **Always-visible** | false 금지. 생략 = 자동 활성 |
| `filter` | **Always-visible** | false 금지. 생략 = 자동 활성 |
| `excel` | **Always-visible** | false 금지. 생략 = 자동 활성 |
| `condition` | 조건부 false | UsrConditionPanel 부재 시만 |
| `resetCondition` | 조건부 false | UsrConditionPanel 부재 시만 |
| `manual` | Always-false | `manual: false` 명시 |
| `upload` | 조건부 함수 | AS-IS 업로드 버튼 있을 때만 함수 |

### §5.2 SCM0008 위반 사례 (2026-06-06)

```typescript
// ❌ 위반 — 9 키 전부 false
const hotkeyConfig: HotkeyConfig = {
  insert: false, delete: false, save: false,
  search: false, condition: false, resetCondition: false,
  excel: false, upload: false, manual: false,
};
```

→ Sort/Filter/Excel 까지 숨김 + SearchArea 부재 + search false → 조회 트리거 불가.

```typescript
// ✅ Fix
const hotkeyConfig: HotkeyConfig = {
  insert: false,           // customButtons 'Add' 대체
  delete: false,           // customButtons 'Delete' 대체
  save: false,             // customButtons 'Request' 즉시 mutate
  condition: false,        // UsrConditionPanel 부재
  resetCondition: false,
  manual: false,
  upload: false,
  // sort / filter / excel: 생략 = 자동 활성
};

<SubTitle ... hotkeyConfig={hotkeyConfig} searchAction={handleSearch} />
```

### §5.3 PRE-WRITE 자기 점검 (2026-06-06 추가)

```
☐ Hidden allowlist (insert/delete/save) 외 false 키 있나? → 위반 (제거 필요)
☐ MainTitle disableSearchArea 또는 SearchArea 미사용? → SubTitle searchAction prop 의무
☐ AS-IS .cs §4 Button 분석 결과를 __asis-mapping__.md ## Button 매핑 표로 기재했나?
```

### §5.4 POST-WRITE grep

```bash
MAIN="features/{domain}/src/pages/{screen}/{Name}.tsx"

# 일괄 false 위반 검출 (sort/filter/excel false = 0 의무)
awk '/hotkeyConfig:.*HotkeyConfig/,/^\s*\};/' "$MAIN" | grep -cE "(sort|filter|excel):\s*false"  # = 0

# SearchArea 부재 + searchAction 누락 검출
if grep -q "disableSearchArea" "$MAIN"; then
  grep -c "searchAction=" "$MAIN"  # ≥ 1 의무
fi
```
