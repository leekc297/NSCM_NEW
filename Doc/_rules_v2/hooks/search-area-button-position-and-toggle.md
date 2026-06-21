# Hook — SearchArea 의 검색 버튼 위치 + 펼침/닫기 토글 의무 (2026-06-20)

> 사용자 명시 (2026-06-20, DMF0072 fix 중) — **rule 로 추가**.
> 위반 시: search button 이 InputField 안에 끼어들거나 (시각 오류) / 3단 이상 조회조건이 펼침/닫기 없이 항상 표시 (UI 혼잡).

---

## §1. Search button 위치 — InputField 오른쪽 (외부)

### 적용 조건
조회조건 안에 **InputField + endAdornment Button** (검색 popup trigger) 가 있을 때.

### 안티패턴 (위반)
```scss
.inputWithSearch {
  /* button 위치 미지정 → InputField 안에 끼어듦 */
}
```

### 표준 (의무)
```scss
.inputWithSearch {
  & > div:first-child {
    display: flex;
    align-items: center;
  }
  & button {
    position: absolute;
    right: -40px;   /* Input 외부 오른쪽으로 분리 */
  }
}
```

### Reference
- `features/master/src/pages/contribute-view/components/ContributeViewForm.module.scss` (DMF0043_01)
- `features/master/src/pages/sales-site-project-model/components/SalesSiteProjectModelForm.module.scss` (DMF0005)
- `features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.module.scss` (DMF0072, 2026-06-20 적용)

### POST-WRITE grep
```bash
# InputField + endAdornment Button 사용처에 inputWithSearch SCSS 가드 확인
rg -n "endAdornment.*Button" features/{master,demand,...}/src/pages/<screen>/components | wc -l
# inputWithSearch class 존재 확인
rg -n "\\.inputWithSearch" features/<domain>/src/pages/<screen>/components | wc -l
# 0 vs 0 — 양쪽 카운트 일치 의무
```

---

## §2. 조회조건 2단 초과 시 펼침/닫기 토글 의무

### 적용 조건
화면 조회조건이 **2단 (= 6 FormItem, size=4) 초과** 일 때 (즉 7번째 FormItem 이상).

### 안티패턴 (위반)
```tsx
<SearchArea
  conditions={
    <>
      <Grid size={4}>...</Grid> {/* 1번째 */}
      <Grid size={4}>...</Grid> {/* 2번째 */}
      <Grid size={4}>...</Grid> {/* 3번째 */}
      <Grid size={4}>...</Grid> {/* 4번째 */}
      <Grid size={4}>...</Grid> {/* 5번째 */}
      <Grid size={4}>...</Grid> {/* 6번째 */}
      <Grid size={4}>...</Grid> {/* 7번째 — 3단 시작, 펼침/닫기 없이 항상 표시 */}
    </>
  }
/>
```

### 표준 (의무)
3단 이후 FormItem 은 `extraConditions` prop 로 분리 → SearchArea 가 자동으로 펼침/닫기 토글 버튼 표시.

```tsx
<SearchArea
  conditions={
    <>
      {/* 6 FormItem = 2단 (size=4 × 3 = 1단, 12 grid unit) */}
      <Grid size={4}>...1번째...</Grid>
      <Grid size={4}>...2번째...</Grid>
      <Grid size={4}>...3번째...</Grid>
      <Grid size={4}>...4번째...</Grid>
      <Grid size={4}>...5번째...</Grid>
      <Grid size={4}>...6번째...</Grid>
    </>
  }
  extraConditions={
    <>
      {/* 7번째 이후 — 자동 펼침/닫기 토글 */}
      <Grid size={4}>...7번째...</Grid>
    </>
  }
/>
```

### Reference
- `features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx` (DMF0072, 2026-06-20 — Sales Site 를 extraConditions 로 분리)
- DMF0003 + DMF0020 도 동일 패턴 (5단 → 2단+3단 분리, 2026-06-16)
- 기존 hook: `search-area-extra-conditions.md` (메모리 #56, 2026-06-16) — 본 hook 은 그 강화 + Search button 위치 룰 통합

### POST-WRITE grep
```bash
# SearchArea 의 conditions 안 FormItem 수 측정
rg -nc "<FormItem\b" features/<domain>/src/pages/<screen>/components | head -1
# extraConditions prop 존재 확인 (≥ 7 FormItem 시 의무)
rg -n "extraConditions=" features/<domain>/src/pages/<screen>/components
# FormItem ≥ 7 이고 extraConditions= 0 hit → 위반
```

---

## §3. 적용 표 (현재 + 향후 점검)

| 화면 | FormItem 수 | extraConditions | inputWithSearch | 상태 |
|---|:---:|:---:|:---:|---|
| DMF0072 (nn-master-mapping) | 7 | ✅ | ✅ | 2026-06-20 적용 |
| DMF0043_01 (contribute-view) | ? | (점검 필요) | ✅ | inputWithSearch 표준 |
| DMF0003 (mkt-forecast-master) | 5 → 2+3 | ✅ | – | 2026-06-16 적용 (이전 hook) |
| DMF0020 | 5 → 2+3 | ✅ | – | 2026-06-16 적용 |
| DMF0008 (erp-edi-master) | 1 | – | – | N.A. (단일 dropdown) |
| 그 외 master 도메인 ≥ 7 FormItem | ? | ? | ? | 일괄 점검 대상 |

---

## §4. RULESET_MASTER §3 UI-MANDATORY 통합

PRE-WRITE 추가 (UI-MANDATORY 통합 체크리스트):
- ✅ InputField + endAdornment Button 사용 시 `inputWithSearch` SCSS class 적용
- ✅ FormItem ≥ 7 시 `extraConditions` prop 분리

POST-WRITE grep:
- `<Form>` 컴포넌트 안 FormItem 수 ≥ 7 → `extraConditions=` 1+ hit 의무
- `endAdornment.*Button` 사용 시 `\.inputWithSearch` SCSS class 1+ hit 의무
