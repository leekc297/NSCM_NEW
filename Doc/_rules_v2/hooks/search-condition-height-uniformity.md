# Hook — 조회조건 객체 높이 동일화 (디자인 필수) + Figma 1단 4개 배치

> ⚠️ **디자인 필수 룰 (사용자 명시 2026-06-27)**
> 조회조건(Search Area)의 **모든 입력 객체** — Dropdown / Popup(InputField) / Text / DatePicker / Date input — 의
> 높이는 **디자인 기준 36px 로 동일**해야 한다. **Main UI 와 Popup 모두 동일 기준.**
> 추가: 조회조건은 **Figma 기준 1단(row)에 4개씩** 배치한다 (gridSize override).

작성: 2026-06-27 (DMF0020 sales-future-price 작업 — 사용자 명시 디자인 필수)
상위 룰: `anti-simplification.md`
관련 룰: `figma-layout-parity-mandatory.md` (#90 — Figma↔구현 정합) / `grid-multi-tier-header-height.md` (#93 — grid 헤더 높이) / `screen-shell-composition-mandatory.md` (#61 — Form/SearchArea) / `messaging-api-and-search-fields-mandatory.md` (#69 — searchFields 카탈로그/CustomDialog)
단일 출처(높이): `packages/shared/src/components/molecules/customDropdown/CustomDropdownMui.module.scss` `height: 36px`
reference: `features/master/src/components/searchFields/SearchFields.tsx` (`gridSize` prop + `.datePickerFix`)

---

## §0. 트리거 (작업 키워드 매칭 시 자동 적용)

| 트리거 | 적용 시점 |
|---|---|
| 신규 화면 조회조건 Form (T01) | PRE-WRITE + POST-WRITE |
| 화면 조회조건 수정 (T01M) | PRE-WRITE + POST-WRITE |
| Popup 모달 내 검색조건 (T03) | PRE-WRITE + POST-WRITE |
| `<select>` / `<input>` / `DatePickerCalendar` / `dropdown` / 조회조건 키워드 등장 | POST-WRITE 검증 |

---

## §1. WHY — 높이 불일치 사고 (DMF0020)

- 표준 컴포넌트 `CustomDropdown` 은 NSCM override 로 **height 36px** 고정. 반면 raw `<select>`/`<input type=date>` 는 브라우저 기본(28~32px) → 조회조건 객체 높이 제각각.
- design-system `DatePickerCalendar size='small'` 은 **본래 28px** (내부 input 은 36 으로 맞춰도 바깥 `MuiBox` wrapper 가 28 → overflow) → 다른 36px 필드와 어긋남.
- Figma(DMF0020.md ANALYSIS, node `4790:134480`)는 조회조건 **2행 × 4개** 인데 구현이 3/2/3/4/1 로 행당 개수 불일치 → Figma 미준수.

---

## §2. 디자인 기준 높이 = 36px (단일 값)

| 객체 | 표준 처리 | 높이 |
|---|---|---|
| Dropdown(콤보) | `CustomDropdown` (@shared/components) | 36px (override) |
| Text / Popup trigger | `InputField` + `FunctionSearchIcon`(@shared/lges-icons) endAdornment | 36px |
| DatePicker | `DatePickerCalendar` (@shared/lges) — **wrapper CSS 로 36 강제** | 36px |
| Date input(popup raw) | `<input type='date'>` — `height:36px; box-sizing:border-box` | 36px |
| Select(popup raw) | `<select>` — `height:36px; box-sizing:border-box` | 36px |

> ⭐ **Main UI** 는 표준 searchFields 카탈로그(`CustomDropdown`/`InputField` via `SearchArea`+`FormItem`)를 쓰면 36px 자동. **Popup** 의 raw 컨트롤만 명시 36px 보정 필요.

---

## §3. 의무 패턴

### (P1) Main UI — 표준 컴포넌트 사용 (36px 자동)
`SearchArea` + `FormItem` + `CustomDropdown`/`InputField`/`DatePickerCalendar`. searchFields 카탈로그(`@master/searchFields`) 우선 사용.

### (P2) Popup 모달 — raw 컨트롤 36px 보정
```scss
// XxxModal.module.scss
.filterBar {
  .select, .input { height: 36px; box-sizing: border-box; padding: 0 8px; }
}
```
(ExchangeRateModal / SalesPriceVersionModal / PriceBatchInputModal 적용)

### (P3) DatePicker — wrapper CSS 전 레벨 36px 강제 ⭐ (design-system 내부 28px 보정)
`DatePickerCalendar` 는 sx 가 forward 되지 않고, 내부 `MuiOutlinedInput-root` 안쪽은 36 이어도 바깥 `MuiBox` wrapper 가 28 → overflow. **wrapper div + 부분일치 셀렉터**로 **모든 레벨(Box/FormControl/OutlinedInput/InputBase) 36px** 강제:
```tsx
<div className={styles.datePickerFix}>
  <DatePickerCalendar usecase='date-range-multi' size='small' ... />
</div>
```
```scss
.datePickerFix {
  width: 100%; height: 36px; display: flex; align-items: center;
  :global {
    [class*='MuiBox-root'], [class*='MuiFormControl-root'], [class*='MuiTextField-root'] { height: 36px !important; min-height: 36px !important; box-sizing: border-box; }
    [class*='MuiOutlinedInput-root'], [class*='MuiInputBase-root'] { height: 36px !important; min-height: 36px !important; box-sizing: border-box; }
    [class*='MuiInputBase-input'], input { box-sizing: border-box; padding-top: 0 !important; padding-bottom: 0 !important; }
  }
}
```
> 진단법(라이브): input 부모 체인 높이 확인 — `MuiOutlinedInput-root`(36) 바깥 `MuiBox`(28) 가 범인. emotion hash 클래스는 부분일치(`[class*='...']`)로 비의존 타깃.

### (P4) Figma 1단 4개 배치 — gridSize override (additive)
12-col Grid 에서 4개/행 = 각 필드 `size=3`. searchFields 필드는 size 가 하드코딩(Div=4/Period=8/Bucket=2/Version=6) → **optional `gridSize?: number` prop 추가(default=기존값 → 타 화면 회귀 0)** 후 화면에서 `gridSize={3}` 전달.
```tsx
// 카탈로그 필드: <Grid size={gridSize ?? 4}> (기존 default 보존)
// 화면 Form: <DivisionField gridSize={3} .../> ... (행당 4개)
```
- 배치 순서/항목 구성은 **Figma 분석 MD**(`Doc/_figma/screens/<ID>_*_ANALYSIS.md`)의 `Search Area > Row` x좌표(예 278/646/1014/1383 = 4컬럼) 기준. #90 Figma 정합.
- 조건부 표시 필드는 화면 레벨에서 `{cond && <Field/>}` (예 DMF0020: `divisionId !== '40'` 일 때만 Project).

---

## §4. PRE-WRITE 자기 점검

- [ ] 조회조건 모든 객체 높이 = **36px** (Main UI + Popup 동일).
- [ ] Main UI = 표준 searchFields/CustomDropdown/InputField (raw `<select>` 지양).
- [ ] Popup raw `<select>`/`<input type=date>` 에 `height:36px; box-sizing:border-box`.
- [ ] DatePicker = `.datePickerFix` wrapper(전 레벨 36px) 적용 (sx 단독 금지 — forward 안 됨).
- [ ] Figma 분석 MD 확인 → 1단 4개(gridSize={3}) 배치 + 항목/순서 Figma 정합(#90).
- [ ] gridSize 는 카탈로그에 **additive prop(default 보존)** 으로 추가 (타 화면 회귀 0).

---

## §5. POST-WRITE 자동 검증 (grep)

```bash
# (1) popup 모달 raw select/input 에 36px 높이 부여 확인
grep -nE "height:\s*36px" features/**/components/modals/*.module.scss
# (2) DatePicker wrapper(.datePickerFix 류) 존재 — 36px 전 레벨 강제
grep -nE "datePickerFix|MuiOutlinedInput-root|MuiBox-root" features/**/*.module.scss
# (3) 조회조건 4개/행 — gridSize={3} 전달
grep -nE "gridSize=\{3\}" features/**/components/*Form.tsx
# (4) 안티: DatePickerCalendar 에 sx 단독으로 높이 시도 (forward 안 됨 → 무효)
grep -nE "DatePickerCalendar[\s\S]{0,200}sx=" features/**/*.tsx
```

---

## §6. 안티패턴 (사고 사례)

| # | 안티패턴 | 결과 |
|---|---|---|
| 6.1 | 조회조건에 raw `<select>`/`<input>` 를 높이 보정 없이 사용 | 객체별 높이 제각각 (28~40 혼재) |
| 6.2 | DatePicker 높이를 `sx={{...}}` 단독으로 시도 | design-system 이 sx forward 안 함 → 무효 |
| 6.3 | DatePicker 안쪽 input 만 36 으로 보정 | 바깥 `MuiBox`(28) overflow → 여전히 어긋남 |
| 6.4 | 조회조건 행당 개수 임의(3/2/4 혼재) | Figma 미준수 (#90 위반) |
| 6.5 | 카탈로그 필드 size 를 직접 변경(default 깨짐) | 타 master 화면 레이아웃 회귀 |
| 6.6 | gridSize 없이 화면에서 강제 CSS 로 4개/행 | MUI Grid 클래스 의존 → 취약 |

---

## §7. 적용 이력

| 화면/영역 | 적용일 | 비고 |
|---|---|---|
| DMF0020 Main UI (SalesFuturePriceForm) | 2026-06-27 | gridSize={3} 4개/행 (Figma 정합) + Project `divisionId!=='40'` 조건부 |
| DMF0020 PeriodField (searchFields 공유) | 2026-06-27 | `.datePickerFix` 전 레벨 36px (design-system 28px 보정) — 모든 master Period 정합 |
| DMF0020 Popup 3종 (PriceBatch/ExchangeRate/SalesPriceVersion) | 2026-06-27 | raw select/date 36px |

---

## Cross-ref
- `figma-layout-parity-mandatory.md` (#90) — Figma 분석 MD ↔ 구현 레이아웃 정합 (1단 4개 근거)
- `grid-multi-tier-header-height.md` (#93) — grid 다단 헤더 높이(48px) — 본 룰은 **조회조건 객체 높이(36px)**, 헤더와 별개
- `messaging-api-and-search-fields-mandatory.md` (#69) — searchFields 카탈로그 / CustomDialog 표준 size
- reference: `features/master/src/components/searchFields/SearchFields.tsx` (`gridSize` + `.datePickerFix`) / `CustomDropdownMui.module.scss` (36px 단일 출처)
