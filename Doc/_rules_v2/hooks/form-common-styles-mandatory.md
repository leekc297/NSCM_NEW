# Hook #121 — form-common-styles-mandatory ⭐⭐ (사용자 명시 2026-08-04)

> **트리거**: nscm-fe 에서 `SearchArea` 조회조건·입력 폼(`FormItem` / `InputField` / `Checkbox`) 신규 작성 또는 수정 (T01/T01M/T05)
> **한 줄**: 폼 레이아웃 스타일은 **페이지 로컬 `*.module.scss` 에 새로 만들지 말고 `@foundation/styles/common-styles.module.scss` 공용 클래스를 쓴다.**
> **정본**: `nscm-fe/features/master/src/pages/sales-site/components/SalesSiteForm.tsx`

---

## §1 의무 (MUST)

```tsx
import commonStyles from '@foundation/styles/common-styles.module.scss';
```

| 공용 클래스 | 대상 | 내용 |
|---|---|---|
| `commonStyles.formItem` | **모든 `<FormItem>` 필수** | HD 50px / FHD 140px 라벨 칼럼 + `min-width:0` (멀티선택 칩 오버플로 방지) |
| `commonStyles.customGrid` | 라벨 없는 `<Grid>` 셀 (체크박스 등) | 세로 정렬 |
| `commonStyles.customCheckbox` | Checkbox + Label | 가로 배치 |
| `commonStyles.popupSearchField` | 팝업 검색 아이콘 버튼이 붙는 `<InputField>` | 아이콘 버튼 결합 레이아웃 |

원본: `nscm-fe/packages/foundation/src/styles/common-styles.module.scss`

## §2 금지 (MUST NOT)

- ❌ 페이지 로컬 `*.module.scss` 에 폼/인풋 **레이아웃** 규칙(라벨 폭·필드 높이·정렬) 신설 — 공용 클래스가 단일 소스
- ❌ 공용 클래스와 동일 목적의 로컬 클래스 중복 정의 (라벨 칼럼 폭·HD/FHD 브레이크포인트가 화면별로 어긋남)

**Why**: 화면마다 로컬 scss 로 폼 스타일을 따로 잡으면 라벨 칼럼 폭·필드 높이가 화면별로 어긋나고, 브레이크포인트(HD/FHD) 대응이 한 곳에서 안 된다. 공용 클래스가 그 규칙의 단일 소스다.

## §3 적용 절차 (How to apply)

1. 새 폼 작성 또는 기존 폼 수정 시 `<FormItem>` 에 `className={commonStyles.formItem}` 부착.
2. 그 화면 전용 scss 에 남은 폼/인풋 레이아웃 규칙은 공용 클래스로 **대체 후 삭제** — 빈 파일이 되면 dead 파일 삭제.
3. **화면 고유 스타일만** 페이지 `.module.scss` 에 남긴다: 그리드/모달/셀 컬러링 등 (폼 레이아웃 아님).

## §4 주의 (경계 사례)

- ⚠️ `features/master/src/components/searchFields/SearchFields.tsx` **카탈로그 필드**(DivisionField 등)는 아직 내부에서 `commonStyles.formItem` 을 붙이지 않는다 — **카탈로그 필드와 인라인 FormItem 을 한 행에 섞으면 라벨 폭이 어긋날 수 있음.** 섞어야 하면 행 단위로 폭 정합을 확인하고, 카탈로그 필드에 공용 클래스를 붙이는 개선은 shared 변경(분리 PR + 소비자 전수 회귀 — regression-zero-mandatory)으로만.
- 높이 36px 균일화(#94)·1단 4필드(gridSize)는 별도 hook — 본 hook 은 **라벨 칼럼 폭/정렬/오버플로의 공용 클래스 사용** 축.

## §5 POST-WRITE grep

```
# 폼 파일에 FormItem 이 있는데 commonStyles import 가 없으면 위반 의심
grep -L "common-styles.module.scss" $(grep -rl "<FormItem" nscm-fe/features/**/components/*Form.tsx)
# 로컬 scss 의 폼 레이아웃 잔재 (formItem/label width/min-width:0 재정의) 확인
```

---

> Cross-ref: `_tobe/06_search_area.md` (SearchArea 구조) / #94 search-condition-height-uniformity (높이 36px) / #41 regression-zero-mandatory (shared 변경 경계) / RULESET_MASTER §3.1 PRE-WRITE 항목
