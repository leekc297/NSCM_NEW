---
trigger: 조회조건 form 작성 / 수정 시 (T01 신규 화면, T04 Grid/Column 메타, T05 SearchArea 부재 등)
mode: PRE-WRITE 의무
related: hooks/search-button-when-no-searcharea.md, hooks/ui-dynamic-property-management.md, feedback_search_fields_catalog.md
created: 2026-06-16
reason: 사용자 명시 (2026-06-16) — "조회조건 영역 2단 초과할 때 확장 button 생성 및 확장기능 룰화"
sample: DMF0006 (`features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx`)
applied: DMF0003 (MktForecastMasterForm.tsx) / DMF0020 (SalesFuturePriceForm.tsx) — 2026-06-16
---

# Hook — SearchArea 2단 초과 시 extraConditions 분리 의무 (확장 화살표 자동)

> ⭐ **핵심 룰** — 조회조건 영역이 12 column Grid 기준 **2단 (6 필드)** 을 초과하면, 표준 공용 `SearchArea` 컴포넌트의 **`extraConditions` prop 으로 3단 이후 분리** 의무.
> 분리 시 `SearchArea` 가 자동으로 **Search 버튼 우측에 아래 화살표 (확장/축소 토글)** 표시 — 사용자가 필요 시만 확장 단 노출.
> 위반 — 조회 영역 무한 확장 → 메인 grid 영역 압박 + UX 일관성 손상.

## 1. 트리거 조건

| 조건 | 적용 의무 |
|---|---|
| 신규 화면 작성 (T01) | 조회 필드 개수 인벤토리 + 2단 초과 판단 |
| 기존 화면 조회 영역 추가 (T04 / T05) | 필드 추가 시 2단 초과 여부 재판단 |
| Grid size 합계 > 24 (12 × 2 단) | 즉시 적용 |
| 표준 카탈로그 (`@master/searchFields`) 필드 사용 | 각 필드의 Grid size 합산 (대부분 `size={4}` 또는 `size={3}`) |

## 2. 표준 사용 패턴

### 2.1 `SearchArea` Props (공용 컴포넌트)

```tsx
<SearchArea
  searchButtonLabel={t('LBL00514', { defaultValue: 'Search' })}
  isHidden={!openSearchArea}
  onSearch={onSearch}
  conditions={ /* 기본 1~2단 (항상 표시) */ }
  extraConditions={ /* 3단 이후 (확장 시 표시) */ }
/>
```

- `conditions` (필수): 기본 표시 — `Grid size 합계 ≤ 24` (1~2단)
- `extraConditions` (선택): 확장 시 표시 — `extraConditions` prop 존재 시 SearchArea 가 자동으로 Search 우측 ▼ 화살표 표시 + 토글

### 2.2 분리 기준 (4 우선순위)

| 순위 | 분리 기준 | 예시 |
|---|---|---|
| 1 | **필수 / 자주 사용** → `conditions` | Division / Team / End Customer / Period |
| 2 | **종속 종속 (cascade 측 후속)** → `extraConditions` | Project / Item / Owner / Sales Site (Division/Team 선택 후) |
| 3 | **선택적 기능 toggle (checkbox 측)** → `extraConditions` | Sum / Color / Qty 등 표시 옵션 |
| 4 | **고급 / 드물게 사용** → `extraConditions` | Version / Bucket / Search Range 등 화면 특화 |

### 2.3 적용 sample (DMF0006 표준)

```tsx
// features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx
<SearchArea
  ...
  conditions={
    <>
      {/* Row 1~2 — 기본 (Division / Team / End Customer / Sales Site / Project / Model + ...) */}
      <Grid size={3}><DivisionField .../></Grid>
      <Grid size={3}><TeamField .../></Grid>
      ...
    </>
  }
  extraConditions={
    <Grid size={3}>
      <FormItem label='Active' render={() => (<CustomDropdown ... />)} />
    </Grid>
  }
/>
```

### 2.4 적용 사례 (2026-06-16)

| 화면 | 기본 (`conditions`) | 확장 (`extraConditions`) |
|---|---|---|
| **DMF0003** (Mkt Fcst Master) | Row 1: Division / Team / End Customer<br>Row 2: Biz Type / Sales Site / Plant Site | Row 3: Period / Bucket<br>Row 4: Project / Item / Owner<br>Row 5: 4 Checkbox (Sum / Color / Qty≥0 / Cell Qty) |
| **DMF0020** (Sales Future Price) | Row 1: Division / Team / End Customer<br>Row 2: Biz Type / Period | Row 3: Sales Site / Project / Plant Site<br>Row 4: Item / Owner / Bucket / SearchOverRange<br>Row 5: Version |

## 3. PRE-WRITE 체크리스트 (조회 form 작성 직전)

```
[ ] 1. 조회 필드 인벤토리 (AS-IS 분석 자료 + 표준 카탈로그 `@master/searchFields`) — 필드별 Grid size 명시
[ ] 2. Grid size 합계 계산 — 24 (12 × 2단) 초과 여부 판단
[ ] 3. 2단 초과 시:
       (a) 기본 단 (필수 / 자주 사용 — `conditions`) — Grid size 합계 ≤ 24
       (b) 확장 단 (선택 / 후속 / 옵션 — `extraConditions`) — 나머지
[ ] 4. SearchArea 의 `extraConditions` prop 추가 (확장 화살표 자동 표시)
[ ] 5. 단 별 의미 라벨 주석 명시 (예: "Row 3 — Period / Bucket")
```

## 4. POST-WRITE 검증

```bash
# 1) 6 필드 초과 form 에 extraConditions 누락 검출
grep -l "SearchArea" features/**/components/*Form.tsx | while read f; do
  cond_cnt=$(grep -c "<\(DivisionField\|TeamField\|EndCustomerField\|BizTypeField\|SalesSiteField\|PlantSiteField\|PeriodField\|BucketField\|ProjectField\|ItemField\|OwnerField\|VersionField\)" "$f")
  has_extra=$(grep -c "extraConditions=" "$f")
  if [ "$cond_cnt" -gt 6 ] && [ "$has_extra" -eq 0 ]; then
    echo "⚠️ $f 의 조회 필드 $cond_cnt 개 — extraConditions 누락"
  fi
done

# 2) extraConditions 사용 form 의 conditions 측 필드 수 ≤ 6 검증
grep -A 30 "conditions={" features/**/components/*Form.tsx \
  | grep -c "<[A-Z][a-zA-Z]*Field" \
  # ≤ 6 expect
```

## 5. 안티 패턴 (위반 사례)

| 패턴 | 위반 | 올바른 방법 |
|---|---|---|
| 18 조회 필드 모두 `conditions` 안 | 5+ 단 무조건 표시 — 메인 grid 영역 압박 | 2단 초과 3단 이후 `extraConditions` 분리 |
| 자체 expand/collapse state + 자체 토글 버튼 작성 | 공용 SearchArea 컴포넌트 인프라 무시 | `extraConditions` prop 만으로 자동 처리 |
| `isHidden` prop 으로 전체 toggle 만 사용 | "최소화" 와 "확장" 다른 의미 — 사용자가 토글 단 일부 만 추가 노출 불가 | `isHidden` (전체 토글) + `extraConditions` (확장 토글) 분리 |

## 6. 자매 hook cross-ref

- `hooks/search-button-when-no-searcharea.md` — SearchArea 부재 시 `SubTitle.searchAction` prop 의무 (반대 경우)
- `hooks/ui-dynamic-property-management.md` — admin SYS0004 단일 진실 source 표준
- `feedback_search_fields_catalog.md` — `@master/searchFields` 표준 카탈로그 사용 의무

## 7. 축소 시 여백 0 보장 (공용 SearchArea 컴포넌트 의무)

축소 상태에서 form 하단 잔여 공간 발생 금지. SearchArea 의 extraConditions 측 **조건부 render** (DOM 자체 미생성):

```tsx
// ❌ 안티 (display:none + margin-top 부분 공간 잔여)
<Box mt='10px' display={isExpanded ? 'block' : 'none'}>{extraConditions}</Box>

// ✅ 표준 (조건부 render — 축소 시 DOM 자체 없음)
{isExpanded && extraConditions && (
  <Box mt='10px'>{extraConditions}</Box>
)}
```

위치: `nscm-fe/packages/shared/src/components/organisms/search-area/SearchArea.tsx` (2026-06-16 적용).

## 8. 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-16 | 신설 — 사용자 명시 "조회 2단 초과 시 확장 button + 확장기능 룰화". DMF0003 + DMF0020 적용 사례 동반 |
| 2026-06-16 (밤) | §7 추가 — 축소 시 여백 0 보장 (SearchArea 의 extraConditions Box 조건부 render). 사용자 명시 "축소 상태에서 form 전체 하단에 공간 발생" 사고 fix |
