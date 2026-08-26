# Hook — Grid 머지·편집 제어 + admin 메타(API_ID/INPUT_TP_CD) + Division cascade/period 정합 (화면 QA 이슈 도출)

> 작성 / Authored: 2026-06-23 (PM — 일일 이슈목록 `이슈목록_2026-06-23.md` 룰 후보 **R-6·R-7·R-8·R-9·R-10** 정식 승격)
> 출처 / Source: `issue-feed-rules.md` 2026-06-23(2차) 블록 (DMF0072 / DMF0043 / DMF0020 QA 이슈, Excel 18:08 PM 갱신)
> 강도 / Strength: **PR 차단** — 위반 시 머지 거부 (머지 그룹·편집 제어·admin 메타 정합은 운영 데이터/저장 신뢰성 직결)
> 적용 / Apply: T01 신규 화면 · T01M 화면 수정 · T04 Grid/머지 · T05 검색조건/cascade · T08/T10 SP 저장·메타 사고
> 짝 / Pair: #87 `screen-combo-validation-message-mandatory` (오전 R-1~R-5) — 본 hook 은 PM R-6~R-10 (같은 이슈목록 2차 갱신)

화면 QA(`이슈목록관리.xlsx`) PM 갱신에서 도출한 **재사용 정합 룰 5종**. 모두 "운영 메타가 옳은데 화면 측 하드코딩·timing·JOIN 키 불일치로 오작동, 또는 머지/편집 제어 미구현" 패턴.

| 분류 | 출처 이슈 No. | 화면 | 한 줄 |
|---|---:|---|---|
| **G** (Grid Merge) | 14 | DMF0020 | mergeManager = DataGrid **props 직접 세팅**(useEffect 주입 무시됨) + sameRow 머지 기준 = `CRUD_TYPE`+`INSERT_GROUP_ID` |
| **E** (Edit 제어) | 10, 13 | DMF0072 | 컬럼 편집 범위 = admin 메타 `INPUT_TP_CD`('IM' 부분/'M' 전체) + 조건부 행 잠금 = `beginningEdit` handler |
| **A** (API_ID 정합) | 7 | DMF0072 | 프로시저 조회 JOIN 키 `SCM_ADM_MNU_BTN_MPG_M.API_ID` ↔ `SCM_ADM_API_M.API_ID` **매칭 필수** |
| **P** (Period/cascade) | 14 | DMF0020 | Division 변경 시 검색조건 초기화+그리드 비움+disabled 분기 + period default(당월1일~6개월말일) |
| **M+** (Message 연장) | 12 | DMF0043 | 비규격 문자열 메시지 코드 → 표준 코드(`MSG00002/MSG00003`) 교체 (#87 §3 M 연장) |

---

## §1. G — Grid 머지 매니저 props 직접 세팅 + CRUD_TYPE/INSERT_GROUP_ID 머지 그룹

> 출처: No.14 (DMF0020 Sales Price) ①②번 — "AI 재작업 시 필요한 기능"

### 1.1 사고 (timing)

- 기존 소스: `useEffect` 안에서 MergeManager 인스턴스 생성 후 `grid.mergeManager = ...` 주입
- → 데이터 로드 + 그리드 행 DOM 이 **완전히 생성되기 전** 실행으로 판단되어 코드가 **무시됨** (머지 미적용)

### 1.2 룰 — mergeManager 는 DataGrid props 로 전달

```
[필수 1] 커스텀 MergeManager 는 DataGrid 컴포넌트 props 로 직접 세팅한다.
  - ❌ useEffect 안에서 grid.mergeManager = new XxxMergeManager() 주입 (timing 사고)
  - ✅ <DataGrid mergeManager={mergeManager} ... /> props 경유 (wrapper 가 initialized 시점에 적용)
  - CustomMergeManager 는 @foundation/utils 표준 사용 (메모리 feedback_datagrid_shared_component_mandatory)
```

### 1.3 룰 — sameRow 머지 기준 = CRUD_TYPE + INSERT_GROUP_ID

> 머지 그룹 판정: **기존 조회 데이터 + 수정 중 데이터 = 같은 그룹**, **신규 insert 데이터 = 건별 분리**.

```
[필수 2] sameRow(a, b) 머지 동일 그룹 판정에 CRUD_TYPE + INSERT_GROUP_ID 를 포함한다.
  - 조회 데이터는 CRUD_TYPE 없음 / 변경 데이터는 CRUD_TYPE='M' → default 'M' 으로 동일 취급
  - 조회 데이터는 INSERT_GROUP_ID 없음 → default 'RGRP'(READ GROUP) 동일 취급
  - 신규 insert row 는 각자 다른 INSERT_GROUP_ID → 건별 머지 (한 덩어리로 합쳐지지 않음)
```

```tsx
// No.14 처리내역 표준 (SalesFuturePriceFlexGrid.tsx sameRow)
const sameRow = (a: number, b: number): boolean => {
  const ra = rowItem(a);
  const rb = rowItem(b);

  // 조회 데이터엔 CRUD_TYPE 없고 변경 데이터엔 'M' → CRUD_TYPE 없는 row 를 변경 row 와 같게 보도록 default 'M'
  let crudTypeA = 'M';
  let crudTypeB = 'M';
  if (ra?.CRUD_TYPE) crudTypeA = ra.CRUD_TYPE as string;
  if (rb?.CRUD_TYPE) crudTypeB = rb.CRUD_TYPE as string;

  // 조회 데이터엔 INSERT_GROUP_ID 없음 → 임의 READ GROUP 'RGRP' default
  let groupIdA = 'RGRP';
  let groupIdB = 'RGRP';
  if (ra?.INSERT_GROUP_ID) groupIdA = ra.INSERT_GROUP_ID as string;
  if (rb?.INSERT_GROUP_ID) groupIdB = rb.INSERT_GROUP_ID as string;

  const isSame = crudTypeA === crudTypeB && groupIdA === groupIdB;
  if (!ra || !rb) return false;
  return leftBindings.every(k =>
    (((ra as Record<string, string>)[k] ?? '') === ((rb as Record<string, string>)[k] ?? '')) && isSame,
  );
};
```

> ⚠️ `itemsSource` row 에 `CRUD_TYPE` **임의 set 금지** (`screen-runtime-pitfalls-mandatory §2.7` — EditTracker 자체 마킹 보호). 위 sameRow 의 default 'M' 은 **읽기 전용 판정 로컬 변수**이지 row 객체에 set 하는 것이 아님.

---

## §2. E — 컬럼 편집 범위 = admin 메타 `INPUT_TP_CD` + 조건부 행 잠금 `beginningEdit`

### 2.1 INPUT_TP_CD — 일부 컬럼만 수정 (출처 No.10 DMF0072, DB 구분)

```
[필수 1] "일부 컬럼만 수정 가능"은 화면 readonly 하드코딩이 아니라 SCM_MST_SHEET_COLUMNS.INPUT_TP_CD 메타로 제어.
  - INPUT_TP_CD = 'M'  → 전체(모든 셀) 수정 가능
  - INPUT_TP_CD = 'IM' → 일부(지정 컬럼)만 수정 가능
  - No.10 사고: DB 작업 후 일부만 수정 가능했어야 하는데 전 컬럼 수정 가능 → INPUT_TP_CD 'M' → 'IM' 수정으로 해결
```

⚠️ `INPUT_TP_CD` 는 `SCM_MST_SHEET_COLUMNS` 의 **NOT NULL 16 컬럼** 중 하나 (`screen-runtime-pitfalls-mandatory §5` 실측). 메타 INSERT/UPDATE 시 누락 금지.
⚠️ admin 메타 값은 **실 데이터만** — AI 임의 추정/생성 금지 (`ui-category-setup-no-arbitrary-data`, 메모리 `feedback_ui_category_setup_no_arbitrary_data`). 변경 필요 시 사용자 확인.

### 2.2 조건부 행 편집 잠금 — `beginningEdit` handler (출처 No.13 DMF0072)

> 특정 컬럼 값(`DATA_TYPE_CODE === 'ERP'`)인 행 전체를 수정 불가로 잠금.

```
[필수 2] 조건부 행/셀 편집 잠금은 gridRef.beginningEdit handler 를 useEffect 에서 등록/해제한다.
  - FlexGrid initialized 내부에서 React state/props 참조 시 과거 상태에 갇히는 Closure 사고 방지
  - 의존성 바뀔 때마다 addHandler + cleanup 에서 removeHandler (FIFO — wrapper 다음 등록 보장)
```

```tsx
// No.13 처리내역 표준 (NnMasterMappingGrid.tsx)
useEffect(() => {
  const g = gridRef.current;
  if (!g) return;

  const handleBeginningEdit = (
    s: FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>,
    e: CellRangeEventArgs,
  ) => {
    const rowData = s.rows[e.row].dataItem as (WijmoRowItem & { CRUD_TYPE?: string }) | null;
    if (rowData && rowData?.DATA_TYPE_CODE === 'ERP') {
      e.cancel = true; // ERP 행 편집 차단
    }
  };

  g.beginningEdit.addHandler(handleBeginningEdit);
  return () => {
    g.beginningEdit.removeHandler(handleBeginningEdit);
  };
}, []);
```

> 이 패턴은 `screen-runtime-pitfalls-mandatory §P7`(동적 cell 편집 EDIT_FLAG 우회) 과 **동일 메커니즘**. P7 은 wrapper `setEditableColumns` 의 `isEditableCell` 분기를 화면 `beginningEdit` 로 override 하는 방향, 본 §2.2 는 추가 조건(특정 컬럼값)으로 잠그는 방향. 둘 다 **useEffect mount + cleanup + FIFO 등록** 의무 동일.

---

## §3. A — 프로시저 조회 JOIN 키 `API_ID` 매칭 정합 (admin 메타)

> 출처: No.7 (DMF0072 N:n Master Mapping, Front-End+DB) — "데이터 수정이 되지 않음"

### 3.1 사고

- 프로시저 정보 조회 시 `SCM_ADM_MNU_BTN_MPG_M` 와 `SCM_ADM_API_M` 를 **`API_ID` 컬럼으로 JOIN**
- 두 테이블의 `API_ID` 가 **매칭되지 않아** 프로시저를 찾지 못함 → 저장 에러
- 해결: `API_ID` 를 **화면설계서 기재값(`P_DMF0072_SAVE`)으로 동기화**

### 3.2 룰

```
[필수 1] 화면 저장/조회 프로시저 매핑은 SCM_ADM_MNU_BTN_MPG_M.API_ID ↔ SCM_ADM_API_M.API_ID 가
         정확히 매칭되어야 한다 (JOIN 키 정합).
  - API_ID 값 = 화면설계서(DMFxxxx) 기재 프로시저명(P_DMFxxxx_SAVE 등) single source
  - 두 메타 테이블의 API_ID 불일치 = 프로시저 미발견 → 저장 silent 실패/에러
[필수 2] 신규/수정 화면 저장 버튼 작성 시 두 테이블 API_ID 정합을 PRE-SUBMIT 로 확인.
  - ❌ AI 임의 API_ID 생성/추정 금지 (ui-category-setup-no-arbitrary-data) — 화면설계서 값 사용
```

### 3.3 POST-WRITE 검증 SQL

```sql
-- 버튼 매핑 API_ID 가 API_M 에 실제 존재하는지 (불일치 = 프로시저 미발견)
SELECT b.MNU_ID, b.MNU_BTN_CD, b.API_ID
FROM   SCM_ADM_MNU_BTN_MPG_M b
LEFT   JOIN SCM_ADM_API_M a ON a.API_ID = b.API_ID
WHERE  b.MNU_ID = '<MNU_ID>' AND a.API_ID IS NULL;
-- 기대: 0 row (모든 버튼 API_ID 가 API_M 에 매칭)
```

> ⚠️ 컬럼명 추측 금지 (`feedback_ddl_grep_before_sql`) — `python ora.py desc SCM_ADM_MNU_BTN_MPG_M` / `desc SCM_ADM_API_M` 로 실 컬럼(`API_ID`) 확인 후 SQL 작성.

---

## §4. P — Division cascade 초기화/disabled + period default

> 출처: No.14 (DMF0020 Sales Price) ③④⑤번

### 4.1 Division 변경 시 (③)

```
[필수 1] 검색조건 Div 변경 시:
  - 검색조건 모두 초기화 + 그리드는 조회 전 "빈 그리드"로 초기화
  - Div = '40' → 검색조건 Project / Plant Site disabled
  - Div = '82' → 검색조건 Plant Site disabled
```

> cascade reset/dedup 표준은 `cascade-combo-filter`(#59) §1 reset + §2 multi-level. 본 §4.1 은 그 위에 **disabled 분기 + 그리드 비우기**를 추가. division 정규화(`'81_X' → '81'`)는 `grid-cell-interaction-patterns-mandatory` 참조.

### 4.2 period default (④)

```
[필수 2] 화면 로드 시 period 기본값 = 당일 기준 "당월 1일 ~ 6개월 뒤 말일".
  - 예: 당일 2026-06-23 → period = 2026-06-01 ~ 2026-11-30
  - dayjs (foundation 표준) 사용: dayjs().startOf('month') ~ dayjs().add(5,'month').endOf('month')
    (당월 포함 6개월 → +5 month 의 말일)
```

```tsx
import dayjs from '@foundation/dayjs';
const periodFrom = dayjs().startOf('month').format('YYYYMMDD');           // 당월 1일
const periodTo   = dayjs().add(5, 'month').endOf('month').format('YYYYMMDD'); // 6개월 뒤 말일
```

### 4.3 LOC 주간 row 편집 제한 (⑤)

```
[필수 3] Div 가 '40' 이 아닌 경우 → Currency 항목 + Measure 의 LOC 해당 "주간 row" 데이터만 수정 가능.
  - 그 외 row/컬럼은 편집 잠금 (§2.2 beginningEdit handler 의 조건 분기로 구현)
  - Div 별 편집 가능 범위는 화면 분석서(.cs) 1:1 매핑 (asis-coverage-check)
```

---

## §5. M+ — 비규격 메시지 코드 → 표준 코드 교체 (#87 §3 M 연장)

> 출처: No.12 (DMF0043 Contribution Rate Reg) — "일부 규격에 맞지 않는 메세지 교체"

```
[필수 1] 임의 문자열 메시지 코드(MSG_SAVE_DONE / MSG_SAVE_FAIL 등) 금지 → SCM_ADM_MSG_M 표준 코드 사용.
  - MSG_SAVE_DONE → MSG00002 (저장 완료 표준)
  - MSG_SAVE_FAIL → MSG00003 (저장 실패 표준)
  - 적용 파일 예: ContributeMain.tsx / ContributeVersionModal.tsx
[필수 2] 표준 코드 ↔ 문구는 SCM_ADM_MSG_M 실 데이터 single source (AI 임의 INSERT/문구 추측 금지).
```

> #87 §3 M("메시지 코드 의미 충돌 금지")의 **연장** — M 은 "동일 코드 다른 문구 금지", M+ 는 "비규격 임의 코드 → 표준 코드 정규화". 둘 다 `SCM_ADM_MSG_M` single source + i18n 3언어 동반(`i18n-ko-en-alignment`).

---

## §6. PRE-WRITE / POST-WRITE 통합

### 6.1 PRE-WRITE (작성 직전)
- [ ] **G**: MergeManager 는 `<DataGrid mergeManager={...} />` props 세팅 (useEffect 주입 금지) + sameRow 머지 기준 `CRUD_TYPE`+`INSERT_GROUP_ID` (조회/변경 default 'M'·'RGRP', 신규 insert 건별)
- [ ] **E**: 컬럼 편집 범위 = `INPUT_TP_CD`('IM'/'M') admin 메타 + 조건부 행 잠금 = `beginningEdit` handler (useEffect 등록/cleanup)
- [ ] **A**: 저장/조회 프로시저 `SCM_ADM_MNU_BTN_MPG_M.API_ID` ↔ `SCM_ADM_API_M.API_ID` 매칭 확인 (화면설계서 값)
- [ ] **P**: Div 변경 시 검색조건 초기화+그리드 비움+disabled 분기(40/82) + period default(당월1일~6개월말일, dayjs) + Div≠40 LOC 주간 row만 편집
- [ ] **M+**: 임의 문자열 메시지 코드 금지 → `SCM_ADM_MSG_M` 표준 코드(`MSG00002/MSG00003`)

### 6.2 POST-WRITE grep (0 hit 의무)
```bash
# G — useEffect 안 mergeManager 주입 안티패턴 검출
grep -rn "\.mergeManager\s*=" features/{domain}/src/pages/{screen}/

# E — 컬럼 readonly/isReadOnly 하드코딩 검출 (INPUT_TP_CD 메타로 대체)
grep -rn "isReadOnly\s*=\s*true\|readOnly:\s*true" features/{domain}/src/pages/{screen}/

# M+ — 비규격 문자열 메시지 코드 검출
grep -rn "MSG_SAVE_DONE\|MSG_SAVE_FAIL\|'MSG_[A-Z_]*'" features/{domain}/src/pages/{screen}/
```
```sql
-- A — 버튼 API_ID 매칭 (0 row 기대)
SELECT b.MNU_BTN_CD, b.API_ID FROM SCM_ADM_MNU_BTN_MPG_M b
LEFT JOIN SCM_ADM_API_M a ON a.API_ID=b.API_ID WHERE b.MNU_ID='<MNU_ID>' AND a.API_ID IS NULL;
```

---

## §7. cross-ref (중복 금지 — 본 hook 은 위 룰들과 동일 방향 강화)

### Hook
- `screen-runtime-pitfalls-mandatory` §P7 (조건부 cell 편집) / §2.7 (`CRUD_TYPE` 임의 set 금지) — 본 §1.3·§2.2 와 짝
- `datagrid-shared-component-mandatory` (#60) — DataGrid + `@foundation/utils` CustomMergeManager (본 §1.2)
- `cascade-combo-filter` (#59) — Division 변경 reset/dedup 1RT (본 §4.1 의 base)
- `grid-cell-interaction-patterns-mandatory` (#66) — division 정규화 + Cell→Popup (본 §4.1)
- `ui-category-setup-no-arbitrary-data` — admin 메타(INPUT_TP_CD/API_ID/MSG) 실 데이터만, AI 임의 생성 금지 (본 §2.1·§3.2·§5)
- `screen-combo-validation-message-mandatory` (#87) §3 M — 메시지 코드 의미 충돌 (본 §5 M+ 의 base)
- `be-infrastructure-reuse` — SP/메타만으로 저장 path 완성 (본 §3 API_ID)
- `i18n-ko-en-alignment` — 신규/변경 메시지 코드 3언어 동반 (본 §5)

### 메모리
- `feedback_datagrid_shared_component_mandatory` — DataGrid + CustomMergeManager (본 §1)
- `feedback_screen_runtime_pitfalls_mandatory` — P7 조건부 편집 / CRUD_TYPE 마킹 (본 §1.3·§2.2)
- `feedback_ui_category_setup_no_arbitrary_data` — admin 메타 실 데이터만 (본 §2.1·§3.2·§5)
- `feedback_ddl_grep_before_sql` — 컬럼명 추측 금지 (본 §3.3)
- `feedback_be_no_modification_rule` — 메타/SP/FE 한정 (본 §3·§5)

### 원천
- `_analysis/이슈목록_2026-06-23.md` §4 룰 후보 R-6~R-11 (PM 갱신)
- `issue-feed-rules.md` 2026-06-23(2차) 블록 (편입완료)

---

## §8. 변경 이력

- 2026-06-23 (PM): 신규 작성. 일일 이슈목록(`이슈목록_2026-06-23.md`) PM 갱신분 처리·머지 완료/처리내역 보유 이슈 5건(R-6·R-7·R-8·R-9·R-10)을 정식 룰로 승격. 사용자 "이슈목록 Rule 적용" 명시 요청. R-11(SYS0010)은 처리내역 부재로 후속조치(미승격).

---

## ⛔ 병합 판정에 상태를 섞지 말 것 (hook #141)

`MergeManager.getMergedRange()` 의 입력은 **행 데이터뿐**이다. `selectionChanged` / `prepareCellForEdit` / MergeManager 가변 상태 필드로 병합을 바꾸면 **"포커스만 가도 병합이 깨진다"** 가 된다.
허용되는 상태 의존은 `cellEditEnded → invalidate()` 하나뿐.

> 본문 = `Doc/_rules_v2/hooks/wijmo-merge-row-data-only.md` (#141, 2026-08-21 사용자 명시).
> "클릭 시 병합이 풀리고 편집 가능" 류 요구 문구는 **결함 신고일 수 있으므로 구현 전 확인**.
