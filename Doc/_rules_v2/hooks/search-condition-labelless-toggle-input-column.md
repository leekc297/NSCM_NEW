---
trigger: 조회조건(SearchArea conditions/extraConditions · 팝업 모달 조회조건) 에 RadioGroup/Radio · Checkbox 신규 작성 또는 위치·라벨 수정 (T01/T01M/T05)
mode: PRE-WRITE 의무 + POST-WRITE 검증
related: hooks/form-common-styles-mandatory.md(#121) · hooks/search-condition-height-uniformity.md(#94) · hooks/search-area-extra-conditions.md · hooks/figma-layout-parity-mandatory.md(#90)
created: 2026-10-21
revised: 2026-10-23 (v2 — 좌측 라벨 열에 조건명 + 입력 열 시작선에 컨트롤. v1 의 NBSP 무라벨·박스 옆 글자·한 칸 묶음 패턴 폐지)
reason: 사용자 명시 (2026-10-21 신설 / 2026-10-23 캡처로 디자인 보완) — 아래 §0
---

# Hook #154 — 조회조건 Radio/CheckBox 디자인 = 좌측 라벨 열(조건명) + 입력 열 시작선(컨트롤) ⭐⭐⭐ (디자인 필수)

> **한 줄**: 조회조건의 **CheckBox** 는 조건명을 **좌측 라벨 열**(다른 조건 라벨과 같은 우측정렬·굵기)에 두고, 체크박스 박스만 **입력 열 시작선**에 둔다(박스 옆 글자 없음).
> **Radio** 는 그룹명(예: `Search Mode`)을 **좌측 라벨 열**에 두고, 라디오 선택지(원 + 선택지 글자)를 **입력 열 시작선부터 가로로** 둔다.
> 구현 = 정본 `features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx` 의 `checkbox()` · `radio()` 헬퍼(L269-293 · L380-396) 그대로.
> 파일명(`…-labelless-toggle-input-column`)은 참조 호환을 위해 유지한다 — 내용은 v2.

---

## §0. 사용자 지시 원문

**2026-10-23 (v2 — 현행)** — 캡처 1장(SCP0100 Global PSI Report 조회조건, 노란 표시 = `Search Mode` 라벨 · `Cell Qty` 라벨)
> UI 조회조건의 CHECKBOX, RADIOBUTTON 에 대한 DESIGN 은 첨부와 같이 되도록 이미 적용된 RULE에 대해서 보완해주세요

캡처 실측(같은 열 위·아래 정렬):

| 조회조건 | 좌측 라벨 열 (우측정렬) | 입력 열 시작선부터 |
|---|---|---|
| Radio | `Search Mode` (2행 `*Plan Date` 라벨과 같은 열·같은 오른쪽 끝) | `◉ Search Level  ○ Detail` (선택지 글자는 원 오른쪽) |
| CheckBox | `Cell Qty` (아래 행 `Plan Type`·위 행 `Bucket` 라벨과 같은 오른쪽 끝) | `☑` 박스만 (위 행 `Monthly` 콤보 박스 왼쪽 끝과 같은 x) |
| CheckBox | `A/S` (아래 행 `Scale` 라벨과 같은 오른쪽 끝) | `☐` 박스만 |

**2026-10-21 (v1 — 폐지된 부분 포함)**
> Label 이 없이 조회조건을 적용하는 Radio Button, Check box 의 경우에는 위치를 입력창의 위치에 놓이도록 Rule 을 적용해주세요.

v1 의 "**컨트롤은 입력 열 시작선**" 은 v2 에서도 유지된다. v1 의 "라벨 없음(NBSP 라벨) · 박스 옆 글자(`labelText`) · 여러 체크박스를 한 칸에 묶음" 은 **v2 로 폐지**(조건명은 좌측 라벨 열로 이동, 체크박스는 조건마다 한 칸).

---

## §1. 적용 대상 / 비대상

| 구분 | 대상 여부 |
|---|---|
| 조회조건 영역(SearchArea `conditions`/`extraConditions`)의 Checkbox — 1개든 여러 개든 | ✅ 대상 (조건마다 한 칸) |
| 조회조건 영역의 Radio(RadioGroup) | ✅ 대상 |
| 팝업 모달의 조회조건(검색 필터 바)에 있는 같은 형태의 Radio/Checkbox | ✅ 대상 (Main UI 와 동일 — #94 와 같은 범위) |
| 그리드 셀 체크박스 · SubTitle/툴바 체크박스 · 저장 폼(편집 화면) 체크박스 · 모달 목록 선택 체크박스 | ⛔ 비대상 (조회조건 아님) |

---

## §2. 의무 패턴 (MUST) — 정본 GlobalPsiReportForm 헬퍼

```tsx
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { Checkbox, FormItem, Radio, RadioGroup } from '@shared/lges';
import { Grid } from '@shared/mui';

// CheckBox — 조건명 = FormItem 라벨(좌측 라벨 열), 박스만 입력 열 시작선
const checkbox = (labelText: string, checked: boolean, onToggle: (v: boolean) => void) => (
  <Grid size={3} className={commonStyles.customGrid}>
    <FormItem
      className={commonStyles.formItem}
      label={labelText}
      labelAlign='right'
      render={() => (
        <div className={commonStyles.customCheckbox}>
          <Checkbox checked={checked} onChange={onToggle} />
        </div>
      )}
    />
  </Grid>
);

// Radio — 그룹명 = FormItem 라벨, 선택지(원 + 글자)는 입력 열 시작선부터 가로
const radio = (labelText: string, value: string, options: readonly Option[], onPick: (code: string) => void, required?: boolean) => (
  <Grid size={3}>
    <FormItem
      className={commonStyles.formItem}
      label={labelText}
      labelAlign='right'
      required={required}
      render={() => (
        <RadioGroup row value={value} onChange={(_, v) => onPick(String(v ?? ''))}>
          {options.map(o => (
            <Radio key={o.value} value={o.value} labelText={o.label} />
          ))}
        </RadioGroup>
      )}
    />
  </Grid>
);

{checkbox(t(LBL.CELL_QTY, 'Cell Qty'), sc.chkCellQty, checked => set({ chkCellQty: checked }))}
{checkbox(t(LBL.AS, 'A/S'), sc.chkAs, checked => set({ chkAs: checked }))}
{radio(t(LBL.SEARCH_MODE, 'Search Mode'), searchMode, SEARCH_MODE_OPTIONS, v => setSearchMode(v))}
```

| # | 규칙 | 이유 |
|---|---|---|
| M1 | Checkbox/RadioGroup 은 **반드시 `FormItem`** 으로 감싼다 (`className={commonStyles.formItem}` · `labelAlign='right'`) | 공용 `.formItem` 라벨 트랙(`minmax(70px,140px)`)이 있어야 컨트롤이 다른 조건의 입력박스와 같은 x 에서 시작 |
| M2 | FormItem `label` = **실제 조건명**(`t(LBL…, '기본문구')`). Checkbox 는 체크 대상의 이름(예: `Cell Qty`), Radio 는 **그룹명**(예: `Search Mode`) | 캡처: 조건명이 라벨 열에서 다른 라벨과 같은 우측정렬·굵기 |
| M3 | Checkbox 에는 **`labelText`(박스 옆 글자)를 주지 않는다** — 박스만 | 조건명이 라벨 열에 있으므로 중복·정렬 깨짐 |
| M4 | 체크박스 **조건마다 Grid 칸 1개**(`Grid size={3} className={commonStyles.customGrid}` + FormItem 1개). 여러 체크박스를 한 FormItem 안에 묶지 않는다 | 각 조건명이 자기 라벨 열을 가져야 위·아래 행과 정렬 |
| M5 | Radio 선택지 글자는 `Radio labelText` 로 원 오른쪽에(`RadioGroup row`). 선택지가 길어 칸을 넘치면 `Grid size` 를 늘린다(3→6) | 캡처 `◉ Search Level ○ Detail` |
| M6 | 라벨 문구 원천 = 조회조건 기준표 To-Be 명칭(SCP·SSP — `tools/VibeManager/rules/40_SEARCH_COND.md`, 룰 E11) → AS-IS 레이아웃 라벨(layoutControlItem.Text) → AS-IS 체크박스/라디오 글자. AS-IS 에 그룹명이 없는 라디오(`NoName`)도 기준표 명칭을 쓰고, 어디에도 없으면 `LBL?????` + GEN_NOTES 에 명칭 확인 요청(임의 작명 금지) | 사람 판단 필요 지점 명시 |
| M7 | 높이 36px(#94) — 체크박스/라디오 행도 다른 조회조건 행과 같은 높이로 세로 가운데(`customGrid`/`customCheckbox` 가 담당) | 행 높이 들쭉날쭉 방지 |
| M8 | LBL 코드 = 기존 재사용, 없으면 신규 채번(E5/i18n 3점 동기화). 미등록이면 정본처럼 `t('', '문구')` 리터럴 + GEN_NOTES | 정본 `'Search Mode'` 선례 |

---

## §3. 금지 (MUST NOT)

| # | 안티 패턴 | 결과 |
|---|---|---|
| X1 | `<FormItem label='' …>` · `label` 미지정 FormItem | 라벨 트랙 미생성 → 컨트롤이 라벨 열 맨 왼쪽에 붙음 (v1 캡처 ① 현상) |
| X2 | FormItem 없이 `<Grid className={commonStyles.customGrid}><div className={commonStyles.customCheckbox}>…` 로 직접 배치 | 라벨 트랙 없음 → 칸 맨 왼쪽(= 라벨 열)부터 시작 (v1 캡처 ② 현상) |
| X3 | **NBSP/공백 라벨**(`label={'\u00A0'}` · `label={' '}`) + 박스 옆 `labelText` — v1 패턴 | 조건명이 라벨 열에 없음 (v2 위반) |
| X4 | 조회조건 Checkbox 에 `labelText` 부여(박스 옆 글자) | 조건명 이중 표시·라벨 열 비어 보임 |
| X5 | 여러 체크박스를 한 FormItem(`Stack row`) 안에 묶기 | 각 조건명의 라벨 열 정렬 불가 |
| X6 | 라벨 열 안에서 `justifyContent:'flex-end'` + `paddingRight` 등 **inline style 로 수동 맞춤** · 페이지 로컬 scss 오프셋(`margin-left:140px`) | 절대금지 ⑤(inline style) · #121 위반 |
| X7 | 공용 `FormItem`/`SearchArea`/`Checkbox` 기본값(shared default) 을 바꿔서 해결 | 절대원칙 2 "shared default 변경 금지" |
| X8 | AS-IS 라디오를 드롭다운으로 대체 | 하네스 게이트 H04 (2026-10-21) |

---

## §4. 이전 결정과의 관계 (우선순위)

- 본 v2 는 **2026-10-23 사용자 일반 규칙**이며 v1(2026-10-21) 의 NBSP·`labelText`·한 칸 묶음 패턴과 **반대 방향**이다. 아래 화면은 **수정(touch) 시 사용자에게 1줄 확인 후** v2 로 맞춘다(확인 없이 임의로 되돌리지도, 방치하지도 않는다).
  - v1 패턴(NBSP/공백 라벨 + 박스 옆 글자) 적용 화면 — 스캐너 `OLD_V1_NBSP`/`OLD_V1_SPACE` 분류(§6)
  - `ProductionPlanForm.tsx` / `ShipmentPlanSemiForm.tsx` — Sum 체크박스를 Plan Date 라벨 글자선에 맞춤(2026-10-07 사용자 지시, `label=''` + flex-end + inline paddingRight)
  - DMF0082 `MktFcstForm.tsx` 의 Sum/Qty≥0/Cell Qty 묶음(`customGrid` 직접 배치) — reference 화면이므로 변경 시 동일 패턴 화면 전수 동반
- **정본** = SCP0100 `GlobalPsiReportForm.tsx`(공통소스판, 2026-10-22 채택) — Cell Qty·A/S·Search Mode 가 v2 그대로.
- #121 §1 표의 `customGrid`/`customCheckbox` 는 **조회조건에서는 본 hook §2 패턴 안에서만** 쓴다.
- **소급 일괄 수정 금지** — 현행 위반은 스캐너 인벤토리로만 관리하고, 화면 신규 작성·보완(touch) 시 적용한다. FE 수정은 CLAUDE.md §1-8 및 사용자 지시(2026-10-23 "FE 직접 수정 요청 전에는 룰·하네스 작업에서 FE 를 고치지 않는다")를 따른다. (2026-11-13 정정: 2026-10-23 지시는 2026-11-02 작업 모드로 대체 — FE 직접 수정 여부는 `tools/Harness/harness.json` repairScope: UI/DB MODE(DB_FE) = 직접 수정 / DB MODE(DB_ONLY) = 가이드만 · 실행 hook `check-work-mode`)

---

## §5. PRE-WRITE 체크 (조회조건 작성·수정 직전)

```
[ ] 1. 조회조건의 Checkbox/Radio 를 전부 나열 (AS-IS designer 의 layoutControlItem.TextVisible=false 항목 포함)
[ ] 2. 각 조건의 라벨 문구 확정 — 기준표 To-Be 명칭 → AS-IS 레이아웃 라벨 → AS-IS 글자 (M6)
[ ] 3. Checkbox = Grid(customGrid) + FormItem(label=조건명) + customCheckbox + <Checkbox> (labelText 없음) — 조건마다 1칸 (M1~M4)
[ ] 4. Radio = Grid + FormItem(label=그룹명) + <RadioGroup row> + <Radio labelText=선택지> (M5)
[ ] 5. 위·아래 행과 같은 열에 배치(캡처/Figma), §4 의 이전 결정 화면이면 사용자 1줄 확인
```

## §6. POST-WRITE 검증

```bash
# 전수 스캔 (조회조건 보유 tsx 의 Radio/Checkbox 를 감싼 Grid·FormItem·label·labelText 분류)
python -I scripts/rules/scan_labelless_toggle.py nscm-fe/features
#  OK_V2                                   = 준수 (라벨=조건명 · Checkbox labelText 없음)
#  NO_FORMITEM / EMPTY_LABEL / FORMITEM_NOLABEL = 위반 후보 (X1·X2)
#  OLD_V1_NBSP / OLD_V1_SPACE                  = v1 패턴 (X3) — touch 시 v2 로
#  LABELED_WITH_TEXT                           = 라벨 + 박스 옆 글자 (X4)
```

- 실행 hook `check-ui-gates.ps1` **G-H [WARN]** 이 편집 직후 같은 판정을 경고한다(비차단 — 기존 위반 파일 편집을 막지 않기 위함).
- 하네스 `tools/Harness/check.js` **H03** — 조회조건 Form 에서 X3·X4·X5 를 판정(생성본 `--final` BLOCK, 그 외 WARN).
- 스캔 한계(명시): ①헬퍼 함수(`checkbox()` 등)로 렌더하면 헬퍼 정의 구간 기준으로 분류 ②`<Box>`/`<div>` 레이아웃 팝업은 Grid 가 없어 누락 가능 ③조회조건 아닌 체크박스(버전 모달 목록 등)도 SearchArea 보유 파일이면 잡힘 → **화면 캡처 실측으로 최종 판정**.
- 최종 확인 = 화면 실측: 조건명 라벨의 오른쪽 끝 x == 같은 열 다른 라벨의 오른쪽 끝 x, Checkbox 박스/Radio 첫 원의 왼쪽 x == 같은 열 입력박스 왼쪽 x (±2px).

---

## §7. 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-10-21 | 신설(v1) — 사용자 지시(캡처 2장, SCP0100). 라벨 없는 Radio/Checkbox = NBSP 라벨로 입력 열 배치 · #121 §1 동반 개정 · check-ui-gates G-H(WARN) · 스캐너 |
| 2026-10-23 | **v2 개정** — 사용자 지시(캡처 1장, SCP0100 공통소스판). 조건명 = 좌측 라벨 열 · Checkbox 박스만(labelText 금지) · 조건마다 1칸 · Radio 그룹명 라벨. v1 NBSP·한 칸 묶음 폐지. 정본 GlobalPsiReportForm `checkbox()`/`radio()`. 동반 개정: #121 · RULESET_MASTER · UI_MANDATORY_CHECKLIST · 카테고리 01/04 · G-H · 스캐너 분류 · 하네스 H03/templates · VM 룰 E12. 이전본 `search-condition-labelless-toggle-input-column.md.bak_20261023` |
