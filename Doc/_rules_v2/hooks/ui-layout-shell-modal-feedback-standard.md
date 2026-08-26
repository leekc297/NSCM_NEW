# Hook #132 — ui-layout-shell-modal-feedback-standard ⭐⭐⭐ (사용자 명시 2026-08-12)

> **트리거**: nscm-fe UI 생성(T01)·보완(T01M) 전부 — 페이지 최상위 구조 / DataGrid 배치 / 조회조건 FormItem /
> Measure·Column 설정 모달 / 저장 성공 피드백 을 만들거나 고치는 모든 작업.
> **한 줄**: 셸(ViewContainer)이 세로 배치를 소유한다 — 페이지는 래퍼 div 를 만들지 않고,
> 공용 모달을 사본 없이 쓰고, 설정 저장 시 그리드를 비우고, 저장 성공은 Toast 로 알린다.
> **연관**: #121 form-common-styles-mandatory(2-1 의 단일 소스) · #97 공통버튼 라우팅 · #113 Grid 컬럼 표준 ·
> Division 변경 Grid 초기화 규약(memory feedback_division_change_grid_reset)

---

## §1. FE 화면 레이아웃 규칙

### §1-1. 조회조건 FormItem 은 공용 클래스를 쓴다 (= hook #121, 재확인)

페이지 로컬 scss 로 폼 칸을 잡지 말고 `@foundation/styles/common-styles.module.scss` 의
`formItem` 을 `FormItem` 의 `className` 으로 넘긴다. 팝업 검색 입력은 `popupSearchField`.

```tsx
import commonStyles from '@foundation/styles/common-styles.module.scss';

<FormItem
  label={t('LBL00086', '_Year')}
  labelAlign='right'
  className={commonStyles.formItem}
  render={() => <CustomDropdown ... />}
/>;
```

**이유**: `formItem` 이 필드 열의 `min-width:0` 해제와 HD 해상도 라벨폭(50px)을 담당한다.
빠뜨리면 칩 같은 넓은 콘텐츠가 Grid 셀 폭을 넘어 옆 칼럼을 침범한다.

공용 클래스 목록 = `nscm-fe/packages/foundation/src/styles/common-styles.module.scss`
(`formItem` / `popupSearchField` / `customGrid` / `customCheckbox`).

### §1-2. 페이지 최상위에 `<div className={styles.container}>` 를 만들지 않는다

`<>` 로 감싼다.

```tsx
// 나쁜 예                              // 좋은 예
<div className={styles.container}>      <>
  <MainTitle ... />                       <MainTitle ... />
  <XxxForm />                             <XxxForm />
  <SubTitle ... />                        <SubTitle ... />
  <XxxGrid ... />                         <XxxGrid ... />
</div>                                  </>
```

**이유**: `MainTitle` / `SearchArea` / `SubTitle` / 그리드의 세로 배치는 셸이 담당한다
(`nscm-fe/apps/web/src/mdi/ViewContainer.tsx` 의 `.view` 가 이미 `display:flex` column).
페이지가 컨테이너를 또 만들면 flex 단계가 하나 더 생겨 그리드 높이 계산이 어긋난다.

### §1-3. DataGrid 위에 `<div className={styles.gridContainer}>` 를 만들지 않는다

래퍼 없이 `DataGrid` 를 그대로 반환한다(모달 등 형제 요소가 있으면 `<>` 로 감싼다).

```tsx
// 나쁜 예                              // 좋은 예
<div className={styles.gridContainer}>  <DataGrid ... />
  <DataGrid ... />
</div>
```

**이유**: 공용 `DataGrid` 가 `flex:1 1 0 / height:100% / minHeight:0` 을 직접 걸고 있어
(`nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx`),
셸의 flex 자식으로 놓이면 남은 높이를 알아서 채운다. 래퍼를 끼우면 그 계약이 깨진다.

`.grid` 처럼 그리드 **내부** 스타일(헤더 타이포 등)을 덮는 클래스는 `DataGrid` 의 `className`
으로 계속 넘겨도 된다 — 금지 대상은 감싸는 `div` 다.

## §2. FE 공통 모달 규칙

### §2-1. Measure / Column 설정 모달은 공용 컴포넌트를 쓴다 ⭐ 확정 RULE (2026-08-13 사용자 확정 — 전 UI 일괄 적용 / **2026-08-20 Column 정본 이동**)

화면 폴더 안에 사본을 만들지 말고 공용 모달을 import 한다.

```tsx
// Column (GRID COLUMN SET) — ⭐ 2026-08-20 사용자 확정: shared 표준 정본 직행
import { ColumnLayoutModal, toColumnLayoutSettings } from '@shared/components';
// Measure (MEASURE SET) — master 공용 유지
import { MeasureSelectModal } from 'features/master/src/components';
```

| 용도 | 공용 정본 (유일) |
| --- | --- |
| Measure 선택 (MEASURE SET) | `nscm-fe/features/master/src/components/measureSelectModal/MeasureSelectModal.tsx` |
| Column 표시/순서/폭/색 (GRID COLUMN SET) | ⭐ **`nscm-fe/packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx`** (2026-08-20 사용자 확정 — 다른 것 사용 금지) |

⭐ **Column 모달 정본 이동 (2026-08-20 사용자 확정)**:
- 정본 = 위 `packages/shared/.../column-layout-modal` **유일**. import 는 `@shared/components` 로 한다.
- 구 정본이던 `features/master/src/components/columnLayoutModal/` 은 **재수출 스텁**으로만 유지
  (기존 화면 호환 — 스텁이므로 기존 import 도 런타임은 정본을 쓴다). 스텁에 구현을 되살리는 것 금지.
- 사본 간 fix 분기 이력: HIDDEN_FROM_LIST(MEASURE) 순번 fix(2026-08-13, 구 master 사본에만 존재)는
  2026-08-20 정본에 이식 완료 — 정본 외 파일에 fix 를 넣으면 이런 분기가 재발한다.
- 신규 화면 grep 게이트: `grep -rn "master/src/components'.*ColumnLayoutModal\|columnLayoutModal" {페이지}/` = 0
  (Column 모달은 `@shared/components` 만).

⛔ **금지 3종** (2026-08-13 사용자 확정 — "작업 시점 전환" 정책 폐기, 전 UI 일괄 소급 완료):
1. **화면 로컬 사본** — `{화면}/components/**/MeasureSelectModal.tsx` 류. 기존 7화면 사본
   (DMF0003/0021/0044/0048/0049/0082/SCP0013) 전부 공용 전환·삭제 완료.
2. **`ColumnSettingModal` 사용** — 구세대 컬럼 모달. 신규 사용 금지, 잔존 사용처
   (DMF0020/0021/0043_01/0048) 는 `ColumnLayoutModal` 로 전환 완료. 컴포넌트는 DEPRECATED.
3. **Column 모달의 master 경로 신규 import** — 신규 화면이 `features/master/src/components` 에서
   `ColumnLayoutModal`/`toColumnLayoutSettings` 를 가져오는 것 (스텁은 기존 화면 호환 전용).
   DMF0082 는 2026-08-20 `@shared/components` 직행으로 전환 완료(전환 정본 예).

⛔ **금지 4번째 (2026-08-26 사용자 확정)** — **Measure 모달의 화면별 표시 변형 옵션 사용 금지**:
Measure 모달의 정본 사용형 = **DMF0003(MktFcst) 배선** (master 공용 `MeasureSelectModal`,
표시 변형 옵션 없이). 특정 화면만 모양을 바꾸는 옵션(예: `showMeasureCode` — Measure Code 컬럼
추가 노출)을 켜면 사용자에게 "화면마다 다른 모달"로 보인다. DMF0082 의 `showMeasureCode` 는
통합테스트 1st No.40 요구로 켰던 것을 **2026-08-26 사용자 지시로 제거(No.40 역전 기록)**.
optional prop 확장 규칙(아래)은 유지하되, **표시(모양) 차이를 만드는 옵션은 전 화면 미사용**이 정본.

**이유**: 사본을 만들면 계약(`measures` / `visibleMeasures` / `onApply`)이 화면마다 갈라져
공용 쪽 수정이 반영되지 않는다. 화면별 차이는 **props 로만** 흡수하고, props 로 표현할 수 없으면
공용 컴포넌트에 **선택적(optional) prop 을 추가**해 기존 호출부 동작을 바꾸지 않는 방식으로 확장한다.
배선 정본 예 = `features/demand/src/pages/business-plan/components/BusinessPlanModals.tsx`
(ColumnLayoutModal: `columnType='C'` + initialSettings/defaultSettings/fallbackColumns +
onSave→`saveTitleSet('C')`→모달 캐시 invalidate→fetchStaticColumns / MeasureSelectModal:
`measures`/`visibleMeasures`/`onApply`→`saveTitleSet('M')` — 저장 성패 무관 §2-2 그리드 비움).

### §2-2. Measure / Column 설정을 저장하면 그리드를 비운다

설정을 적용하면 **그리드를 비운다**(초기화). 화면에 남은 결과는 이전 Measure/Column 구성으로
조회된 것이라 새 구성과 어긋나고, 미저장 편집이 남아 있으면 바뀐 전제로 저장될 수 있다.
사용자가 Search 를 다시 눌러 새 구성으로 조회하게 한다.

Division 변경 시와 **같은 초기화 규약**을 쓴다 — 화면에 이미 있으면 그 함수를 재사용한다.

```tsx
// 부모 화면 — 그리드 초기화 (Division 변경과 동일 규약)
const resetGrid = () => {
  setInsertedRows([]);                        // 신규행 폐기
  editTrackerRef.current?.clearChanges();     // 미저장 편집 폐기
  setHasSearched(false);                      // 명시 조회 게이트 복귀
  clearFilters();                             // filters 제거 → useTabProcQuery disabled → rows 비움
};

// 모달에 넘긴다
<MeasureSelectModal ... onApply={...} />   // 모달 onApply 안에서 부모 콜백 호출
```

- **자동 재조회하지 않는다.** `invalidateQueries` / `refetch` 로 다시 받아오지 않는다.
- 개인화 저장(`saveTitleSet`) 성패와 **무관하게** 비운다 — 선택은 이미 스토어에 반영되므로
  저장이 실패해도 화면에 남은 이전 결과는 어차피 어긋난다.
- `clearFilters()` 로 filters 가 사라지면 편집 게이트도 미조회 상태(잠금)로 함께 떨어진다.

## §3. FE 저장 피드백 규칙

**저장 성공은 Alert 가 아니라 Toast 로 알린다.** 성공은 사용자가 확인 버튼을 누를 이유가 없다.

```tsx
// 좋은 예
void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });

// 나쁜 예
void setAlert({ type: 'alert', content: t(MSG.SAVED, '_성공적으로 저장되었습니다.') });
```

`setToast` / `setAlert` 둘 다 `useMessageStore` 에서 가져온다
(`const setToast = useMessageStore.getState().setToast;`).

**Alert 로 남기는 것** — 사용자가 읽고 넘어가야 하는 메시지:

- 저장 실패, SP 가 내려준 오류문 passthrough(`res.message`)
- 검증 실패 (필수값 누락, 편집 차단, 변경 없음, 저장 대상 0건 등)
- 삭제·전송취소 등 confirm

## §4. 점검 (PRE-WRITE / POST-WRITE grep)

```bash
# §1-2/§1-3 — 래퍼 div 검출 (페이지 진입 컴포넌트·Grid 컴포넌트)
grep -n "styles.container\|styles.gridContainer" {페이지}/*.tsx {페이지}/components/*.tsx
# §2-1 — 모달 사본 검출
ls {페이지}/components/modals/ | grep -i "MeasureSelect\|ColumnLayout"   # 사본이면 위반(공용 import 로 교체)
# §2-1 — 구세대 ColumnSettingModal 사용 검출 (0건 의무 — ColumnLayoutModal 로 전환)
grep -rn "ColumnSettingModal" {페이지}/
# §3 — 저장 성공 Alert 검출
grep -n "setAlert" {페이지}/*.tsx | grep -i "SAVED\|저장되었"
```
