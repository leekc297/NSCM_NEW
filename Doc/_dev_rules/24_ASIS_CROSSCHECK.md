# 24. As-Is 원본 소스 Cross-Check — Event/API/Validation/Expression 100% 매핑

> ⭐ **신규 화면 생성 시 분석 자료만이 아니라 As-Is 원본 `.cs` / `.Designer.cs` 까지 직접 Read 하여 cross-check 의무**
> 분석 자료 (analysis.md / validation.md / expressions.md / tobe_design.md) 는 추출본이고,
> 추출 시점의 누락이 있을 수 있음. To-Be 코드 작성 시 **원본 소스가 ground truth**.

작성: 2026-05-22 (DMF0020 모달 simplification 시 As-Is validation 12건/Event 4건 누락 사고 후)
관련 룰: `Doc/_dev_rules/09_WIJMO_VALIDATION_EXPRESSION.md`, `Doc/_dev_rules/23_FE_IMPORT_INVENTORY.md`
상위 룰: `Doc/_dev_rules/hooks/anti-simplification.md`

---

## §1. Cross-Check 4축

신규 화면 작성 시 다음 **4축**을 모두 As-Is 원본과 1:1 매핑 의무:

| 축 | As-Is 원본 위치 | 분석 자료 | To-Be 매핑 위치 |
|---|---|---|---|
| **1. EVENT (이벤트 핸들러)** | `.cs` `private void` 메서드 + `.Designer.cs` 이벤트 등록 | `analysis.md §4` | `<Screen>.tsx` + `<Screen>Form.tsx` + `<Screen>Grid.tsx` |
| **2. API (Endpoint / SP 호출)** | `.cs` `FoxDataRequest(...)` / `FoxQuery` | `analysis.md §5` + `tobe_design.md §2` | `useTabProcQuery` / `useProcMutation` 호출 |
| **3. VALIDATION** | `.cs` `MessageHelper.GMessageBox` + `if (조건) return` | `validation.md` | `hooks/use<Screen>Validation.ts` + 호출처 |
| **4. EXPRESSION** | `.cs` `Cell.Formula` / `ColumnHeaderSpan(SUM)` / `LockRange` / `SetValue` 계산 | `expressions.md` | `hooks/use<Screen>Expression.ts` + Grid `formatItem`/`cellEditEnded` |

---

## §2. 작업 시작 전 의무 (PRE-WRITE)

### 2.1 원본 소스 직접 Read

```
[Step 1] As-Is .cs 파일 직접 Read (전체 또는 분할)
   Read: Doc/_legacy_source/06_UIL/domain_DM/.../{ScreenId}/{ScreenId}.cs
   - 파일이 2000줄 초과면 offset/limit 분할 Read (생략 금지)
   - 핸들러/메서드/SP 호출 모두 직접 확인

[Step 2] As-Is .Designer.cs 직접 Read
   - 이벤트 핸들러 등록 (`this.btn1.Click += new EventHandler(this.btn1_Click)`)
   - DefColumns struct (그리드 컬럼 정의)
   - 컨트롤 인벤토리 확인
```

### 2.2 분석 자료 4종 Read

```
[Step 3] 분석 자료 4종 Read
   - analysis.md (Event 24개 + API 19개 + 컬럼 33개 + Sub-Sheet)
   - validation.md (모든 MSG##### + 사전검증분기)
   - expressions.md (Cell.Formula + ColumnHeaderSpan SUM)
   - tobe_design.md (To-Be REST API + State + 권한)
```

### 2.3 원본 vs 분석 자료 Diff

```
[Step 4] 원본에서 발견한 항목이 분석 자료에 있는지 확인
   - 분석 자료에 누락된 항목 → To-Be 코드에 그대로 반영 + __asis-mapping__.md 에 "원본 발견" 표기
   - 누락 의심 시 사용자에게 보고 (단순 SKIP 금지 — Anti-Simplification)
```

---

## §3. To-Be 코드 작성 매핑 규약

### 3.1 EVENT 매핑

| As-Is 패턴 | To-Be 매핑 |
|---|---|
| `Form_Load` | `<Screen>.tsx` 의 `useEffect(() => { fetchStaticColumns() }, [tabId])` |
| `<Control>_Click` (button) | onClick 핸들러 또는 `useHotkey` (F5/F7/F8 등) |
| `<Combo>_SelectedIndexChanged` | `<Form>.tsx` 의 `onChange` 핸들러 + store action |
| `<Input>_KeyDown` (Enter 검색) | `onKeyDown` + Enter check |
| `<Spread>_ComboSelChange` | Grid `cellEditEnded` 의 binding === 'X' 분기 |
| `<Spread>_CellClick` | Grid `cellClick` |
| `<Spread>_CellDoubleClick` | Grid `dblClick` |
| `Dsdm_Changed` (DataModel.Changed) | Grid `cellEditEnded` (EditFlag='U' 마킹) |
| `_Resize` (Form Resize) | 미구현 (React 자체 반응형) |
| `<Control>_KeyUp` | 필요 시 onKeyUp |
| F5/F7/F8/F9/F12 단축키 (BaseForm) | `useHotkey` 또는 `hotkeyConfig` |

**누락 검출 의무**: As-Is 의 이벤트 핸들러 24건 중 To-Be 미구현이 있다면 **`__asis-mapping__.md` 에 명시적으로 "[BLOCKED]" 또는 "[SKIPPED]" 사유 기재**.

### 3.2 API 매핑

| As-Is 패턴 | To-Be 매핑 |
|---|---|
| `FoxDataRequest("DMF0020_GET_XXX", ...)` (조회) | `useTabProcQuery({ menuId, sheetName, filters })` |
| `FoxDataRequest("DMF0020_SAVE_XXX", ...)` (저장) | `useProcMutation({ menuId, sheetName, onSuccess })` |
| `siMain.SpreadObject.DataSource = ds.Tables[0]` | `<DataGrid itemsSource={data?.o_rc} />` |
| 사업부 분기 SP (40 vs 81 vs 82 다른 SP) | sheetName 분기 또는 단일 SP + division filter |
| 동적 컬럼 SP (`GET_SPREAD_TITLE_DATE`) | `fetchDynamicColumns` (store) 또는 별도 `useQuery` |

**누락 검출 의무**: As-Is 19~20개 endpoint 중 To-Be 미사용은 `__asis-mapping__.md` 에 ❌ + 사유 기재.

### 3.3 VALIDATION 매핑

| As-Is 패턴 | To-Be 매핑 |
|---|---|
| `if (X == "") { GMessageBox("MSG00002"); return; }` | hook: `validateRequiredX()` + `setAlert({ type: 'alert', content: t('MSG00002', ...) })` |
| `if (sDivision == "40") { ... }` | hook: `<Behavior>ForDivision40()` 분기 메서드 (사업부 분기 통합 금지) |
| `if (!siMain.IsLock(...)) { ... return; }` | hook: `guardLock()` 또는 modal 내 `gridRef.current?.isReadOnly` 검사 |
| `if (blnWork) return;` | TanStack Query `isFetching` 또는 store flag |
| `if (sPeriod[0] > sPeriod[1])` | `validatePeriodOrder` |
| `if (Rows.Count <= 0)` 사전검증 (silent) | `guardEmptyResult` (조용히 return) |
| `MessageBox.Show(sErrMsg)` | `setAlert({ type: 'alert', content: errMsg })` |
| `MessageBox.Show(ds.Tables[...])` | `showErrorFromResultSet` |
| `GMessageBox("MSG00004")` confirm | `setAlert({ type: 'confirm', onConfirm })` |
| `siMain.GetColumnIndex(X) < 0` | `grid.columns.some(c => c.binding === 'X')` |
| `GetText(iRow, 0) == FlagI` (INSERT 행 체크) | `data?.o_rc?.some(r => r.CRUD_TYPE === CRUD_TYPE.INSERT)` |

**누락 검출 의무**: validation.md 의 모든 행 (보통 50~100건) 이 100% 매핑되어야 함. **누락 1건이라도 PR Reject** (룰 09 §11 동일).

### 3.4 EXPRESSION 매핑

| As-Is 패턴 | To-Be 매핑 |
|---|---|
| `ColumnHeaderSpan(row, col, 2, 1, span, "SUM", ...)` | `buildLargeSumHeader()` → Wijmo `<Col header="SUM" columnGroup={[...]}>` |
| `cell.Formula = "=SUM(...)"` | Wijmo FlexGrid `setCellData(r, c, expr, true)` 또는 Footer Aggregate |
| `LockRange(r1, c1, r2, c2, true)` | Wijmo `cellEditEnding` 에서 `e.cancel = true` 분기 |
| `cell.Locked = true/false` | Wijmo column `isReadOnly={true}` 또는 row level guard |
| `SetValue(r, c, val * rate)` (산술) | `cellEditEnded` 에서 `row[c] = row[c] * rate` |
| `SetExchangeValues()` (환율 적용) | `setExchangeValues()` hook |
| `GetThisWeekMonday(date)` (주 시작일 계산) | `getThisWeekMonday()` hook |

### 3.5 ⛔ AS-IS UI 요소 중 TO-BE 미반영 대상 (2026-06-01 신규)

**원칙**: AS-IS 1:1 매핑은 **로직/이벤트/Validation/Expression** 한정. UI 보조 요소 중 **공통 컴포넌트가 대체하는 것** 은 절대 그대로 가져오지 말 것.

| # | AS-IS UI 요소 | TO-BE 미반영 이유 / 대체 |
|---:|---|---|
| 1 | `btnReset` / `btnClear` "초기화" 버튼 | AS-IS BaseForm 기본 제공. TO-BE 는 사용자 명시 요구 없으면 생성 금지. 필터 초기화는 `useStore.reset()` 만 store 에 유지 |
| 2 | "F5=조회 / F7=저장 / F8=추가 / F9=삭제 / F12=Excel" hotkey hint 텍스트 | `<SubTitle hotkeyConfig={...}/>` 가 통합 표시. SearchBar 에 별도 텍스트 라벨 금지 |
| 3 | `btnPrint` "인쇄" / `btnExport` "Excel" 버튼 (단독) | `<SubTitle excelFileName=.../>` 가 통합 |
| 4 | `lblStatus` 하단 상태 라벨 ("총 N건") | `<SubTitle dataCount={N}/>` 통합 |
| 5 | `btnHelp` "도움말" 버튼 | TO-BE 미적용 (별도 manual flag 가 SubTitle 에 있음) |
| 6 | AS-IS `MainMenu` / `MenuStrip` | TO-BE 는 MDI 탭 + 라우터가 처리 (룰 15) |

**판별 기준**: AS-IS 의 UI 컨트롤이 다음 중 하나에 해당하면 TO-BE 미반영:
1. 공통 컴포넌트 (`MainTitle`/`SubTitle`/`SearchArea`/`hotkeyConfig`) 가 같은 기능을 제공
2. BaseForm/MDI 자동 제공 (close/print/help 등)
3. 사용자가 명시적으로 요청하지 않은 BaseForm 잔존 위젯

**위반 시 영향**: 화면에 중복 UI 가 발생하여 사용자가 "어디서 나왔는지 모르는" 버튼을 만나게 됨. AS-IS 충실도 ≠ UI 가독성.

**사고 사례 (DMF0043 2026-06-01)**: SearchBar 에 "초기화" 버튼 + "F5=조회 / F7=저장 / F8=추가 / F9=삭제 / F12=Excel" hint 텍스트를 AS-IS 추출 그대로 노출 → 사용자가 "어디서 나왔는지 모르겠다" 지적 + SubTitle 의 hotkeyConfig 와 중복.

**Pre-write hook 추가 grep**:
```bash
# TO-BE SearchBar/조회영역 에서 다음 패턴이 보이면 즉시 제거
grep -nE "초기화|onReset|resetButton|F5=조회|F7=저장|F12=Excel" \
  nscm-fe/features/<domain>/src/pages/<screen>/components/SearchBar.tsx
```

---

## §4. POPUP 매핑 (별도 .cs 파일 cross-check)

POPUP 은 각각 별도 `.cs` 파일로 존재. 메인 화면 작업 시 모든 POPUP 도 함께 cross-check:

```
[Step P1] 호출되는 POPUP 목록 추출
   grep -E "new (Xxx)Popup|new Xxx_Popup" {ScreenId}.cs

[Step P2] 각 POPUP 의 .cs 파일 위치 확인
   find Doc/_legacy_source/ -name "*{Popup}*.cs"

[Step P3] 각 POPUP 의 validation/expression 도 동일하게 cross-check
   - validation.md 의 "팝업 Validation" 섹션 (v6 보강분)
   - 메인 화면의 호출부 가드 (예: btnExchangeRate_Click L2404 MSG00142)

[Step P4] To-Be Modal 컴포넌트에 모두 반영
   - `components/modals/<X>Modal.tsx`
   - 메인 화면 호출 직전 가드 + Modal 내부 가드 양쪽 모두 구현
```

**누락 검출 의무**: 메인 화면 분석서 `validation.md` 의 v6/v6.2 보강 popup 섹션 (보통 6~12건) 모두 반영.

---

## §5. `__asis-mapping__.md` 작성 의무

To-Be 화면 폴더에 `__asis-mapping__.md` 파일을 **반드시 작성**. 위치:
```
features/<domain>/src/pages/<screen>/__asis-mapping__.md
```

내용 구조 (4축):

```markdown
# {ScreenId} As-Is → To-Be 매핑 매트릭스

**As-Is 소스**: Doc/_legacy_source/.../{ScreenId}.cs (NNNN줄)
**To-Be 위치**: nscm-fe/features/<domain>/src/pages/<screen>/
**총 매핑 건수**: NN건 (Validation NN + Expression NN + Event NN + Popup NN)

> **룰**: 1) 모든 As-Is 행은 To-Be 코드 위치에 1:1 매핑된다.
> 2) 각 To-Be 코드에는 `// AS-IS: {ScreenId}.cs:LLLL` 주석을 단다.
> 3) ❌ 행이 1건도 남으면 PR Reject.
> 4) 사업부 분기 (40/81/82) 는 통합하지 않고 그대로 보존한다.

---

## 1. Event 매핑 (NN건)

| # | As-Is Handler | As-Is Line | To-Be 위치 | 상태 |
|---:|---|---:|---|:---:|
| 1 | Form_Load | 156 | `<Screen>.tsx:useEffect(fetchStaticColumns)` | ✅ |
| ... |

## 2. API 매핑 (NN건)

| # | As-Is Endpoint | To-Be Hook 호출처 | 상태 |
|---:|---|---|:---:|
| ... |

## 3. Validation 매핑 (NN건)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| ... |

## 4. Expression 매핑 (NN건)

| # | Handler | As-Is Line | As-Is Expression | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| ... |

## 5. POPUP 별도 .cs 매핑 (NN건)

| # | POPUP .cs | Handler | Msg ID | 조건 | To-Be 위치 | 상태 |
|---:|---|---|---|---|---|:---:|
| ... |

---

## 카운트 검증

| 구분 | As-Is 카운트 | To-Be 매핑 ✅ | 일치 |
|---|---:|---:|:---:|
| Event | N | N | ✅ |
| API | N | N | ✅ |
| Validation (메인) | N | N | ✅ |
| Expression (메인) | N | N | ✅ |
| Popup Validation | N | N | ✅ |
| **합계** | **N** | **N** | ✅ |
```

---

## §6. POST-WRITE 자동 검증

```bash
# 6.1 매핑 카운트 검증
#   __asis-mapping__.md 의 행 수 vs analysis/validation/expression 카운트 비교
grep -cE "^\| [0-9]+ \|" __asis-mapping__.md

# 6.2 To-Be 코드의 AS-IS 주석 카운트
grep -rcE "// AS-IS: {ScreenId}\.cs:[0-9]+" features/<domain>/src/pages/<screen>/

# 6.3 Validation Hook 의 export 메서드 카운트 vs validation.md 행 수
grep -cE "^\s+const \w+ = useCallback" hooks/use<Screen>Validation.ts
```

---

## ⭐ §6.5 AS-IS DB 직접 조회 의무 (2026-06-01 신규)

**원칙**: DB 오류 발생 또는 데이터 미일치 / 사용자 요청 시 — **반드시 AS-IS MSSQL DB 에 직접 연결** 하여 원본 데이터/SP body/스키마 cross-check 후 수정. 추측/단순 fallback 절대 금지.

### 6.5.1 트리거 조건

다음 조건 중 1개 이상 → AS-IS DB 직접 조회 의무:

| 트리거 | 예시 |
|---|---|
| DB 오류 ORA-xxxxx 발생 (ORA-01400/01427/01489/01722/06502/56907 등) | DMF0043 PIVOT 중복 alias / NULL CREATED_BY |
| 화면 데이터 0건 / 일부 누락 / 값 불일치 | 로컬 SITE_ITEM ATTRIBUTE1/2 NULL — As-Is 18건 |
| To-Be 와 As-Is 결과 row 수 불일치 | DMF0043 As-Is 11건 vs To-Be 0건 |
| SP / Table / Column 스키마 의문 | REPORT_GROUP3 컬럼 누락 여부 |
| 사용자가 "As-Is 확인 후 진행" 명시 요청 | "AS-IS 소스 확인 부탁드립니다" |

### 6.5.2 연결 정보 (gitignore)

`.env.asis` 파일 (2026-06-01 생성, `.gitignore` `.env.*` 패턴으로 자동 제외):
```
ASIS_DB_HOST=165.244.95.223
ASIS_DB_PORT=1433
ASIS_DB_NAME=LGCE_SCMDEV       # ⚠ LGCD 아님 — D vs E 주의
ASIS_DB_USER=scp_mgr_dev
ASIS_DB_PASS=(env)
```

### 6.5.3 sqlcmd 호출 패턴 (Git Bash)

```bash
source .env.asis 2>/dev/null
sqlcmd -S "${ASIS_DB_HOST},${ASIS_DB_PORT}" -d "${ASIS_DB_NAME}" \
  -U "${ASIS_DB_USER}" -P "${ASIS_DB_PASS}" -C -W \
  -Q "SET NOCOUNT ON; <쿼리>"
```

### 6.5.4 자주 사용하는 진단 쿼리

```sql
-- 1) As-Is SP 본문 추출
SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('<SP_NAME>')

-- 2) 테이블 컬럼 인벤토리
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='<T>' ORDER BY ORDINAL_POSITION

-- 3) row 수 차이 진단
SELECT COUNT(*) FROM <table> WHERE <key>='<value>'   -- As-Is
SELECT COUNT(*) FROM SCM_MGR.<table> WHERE <key>='<value>'   -- Local (Oracle)

-- 4) SP 직접 실행 (영향 X — SELECT only)
EXEC dbo.<SP_NAME> @p1='...', @p2='...'
```

### 6.5.5 적용 흐름

1. **DB 오류 메시지 → AS-IS 동일 쿼리/SP 실행** → 정상 동작 시 To-Be 환경 차이 확인
2. **데이터 불일치 → AS-IS row 수 / sample 추출** → 차이 분석
3. **As-Is SP body 와 To-Be SP body 비교** → MSSQL → Oracle 변환 누락/오류 식별
4. **누락 row import 시** — AS-IS 에서 직접 추출 → `_artifacts/{seq}_*_Import.sql` 생성하여 로컬 import
5. **변환 누락 fix 시** — `_artifacts/{seq}_{SP}_Fix.sql` 생성하여 SP recompile

### 6.5.6 사고 사례 (2026-06-01 DMF0043)

| 사고 | As-Is 직접 조회로 발견 | Fix |
|---|---|---|
| 화면 0건 | As-Is 11건 JOIN 매칭, 로컬 0건 | `_artifacts/63/64` site_item dim import |
| Trend Power_01 값 0 | As-Is DTL 96건, 로컬 0건 | `_artifacts/66` DTL bulk import |
| SP `[col]` 변환 누락 | As-Is SP body 와 1:1 비교 — Oracle 변환 부분 다수 | `_artifacts/61` 전면 재변환 |
| REPORT_GROUP3 컬럼 누락 | As-Is `SCM_MST_SITE_ITEM` 컬럼 인벤토리 | `_artifacts/63` ALTER TABLE ADD |

---

## §7. ❌ 절대 금지 패턴

| # | 금지 | 사유 |
|---:|---|---|
| 1 | "신규화면 모양만 만들고 As-Is 항목 무시" | 시스템 동작 불일치 → 사용자 신뢰 손상 |
| 2 | analysis.md 만 보고 .cs 원본 미Read | 분석 추출 누락 시 To-Be 도 누락 |
| 3 | POPUP 별도 .cs 미Read (메인 .cs 만 봄) | POPUP validation 6~12건 누락 |
| 4 | 사업부 분기 (40/81/82) 통합 후 단일 로직화 | 비즈니스 룰 손실 (룰 09 §10 위반) |
| 5 | "이벤트 핸들러는 React 라이프사이클로 충분" 가정 | KeyDown/Resize 등 명시적 핸들러 누락 |
| 6 | Modal 단순화 시 validation 제거 (UI 만 남김) | DMF0020 사고 사례 (P1-P6 12건 누락) |
| 7 | save mutation 없이 query 만 구현 (read-only 모달) | As-Is 가 read+write 인데 read 만 됨 |
| 8 | Cell.Formula / ColumnHeaderSpan 같은 Expression 무시 | SUM 헤더 / 환율 계산 누락 |

---

## §8. 사고 사례 (DMF0020, 2026-05-22)

**상황**: option C 정밀 재작성 시 Modal 4종 단순화로 다음 누락 발생:

| Modal | 누락 항목 | 영향 |
|---|---|---|
| ExchangeRateModal | P1 (MSG00142 guardLock), P2 (MSG00108 validatePeriodOrder), Save mutation | 저장 불가, 잠금 가드 없음 |
| PriceBatchInputModal | P3 (MSG00135), P4 (MSG00408), P5 (MSG00002 BatchInputRowSchema), P6 (MSG00108), PriceAll auto-fill, Save mutation | 일괄입력 핵심 기능 전체 누락 |
| SalesPriceRangeModal | Save mutation | 조회만 가능 |
| Form | #70 cboBucketType_Click MSG00227 INSERT 행 체크 | 데이터 손실 위험 |

**원인**: 옵션 C 재작성 시 "import 오류 해결" 우선순위로 modal 본문을 단순화. 분석 자료 (`__asis-mapping__.md`) 와 실제 To-Be 코드가 불일치.

**재발 방지**:
1. 본 룰 24 명문화
2. Hook `asis-coverage-check.md` 신규
3. `__asis-mapping__.md` 의 ✅ 항목을 실제 To-Be 코드 grep 으로 자동 검증

---

## §9. 변경 이력

- 2026-05-22: 신규 작성. DMF0020 사고 (modal P1-P6 12건 + Event #70 1건 누락) 후 항구 방지 룰.
- 2026-06-01: §3.5 신규 — AS-IS UI 요소 중 TO-BE 미반영 대상 (초기화 버튼 / hotkey hint 텍스트 / 인쇄·Excel 단독 버튼 등 6종). DMF0043 SearchBar 에 "초기화" + "F5=조회 ~ F12=Excel" hint 텍스트 그대로 노출 → SubTitle hotkeyConfig 와 중복 + 사용자 "어디서 나왔는지 모르겠다" 지적 후 항구 방지.
