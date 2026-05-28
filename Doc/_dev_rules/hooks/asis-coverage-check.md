# Hook — As-Is Coverage Check (Event/API/Validation/Expression 100% 매핑 검증)

> ⚠ **신규 화면 작성 후 의무 hook**
> As-Is 원본 `.cs` 의 모든 Event/API/Validation/Expression 이 To-Be 코드에 매핑되었는지 자동 검증.

작성: 2026-05-22 (DMF0020 modal simplification 시 12건 누락 사고 후)
관련 룰: `Doc/_dev_rules/24_ASIS_CROSSCHECK.md`
상위 룰: `Doc/_dev_rules/hooks/anti-simplification.md`

---

## §0. 적용 시점

| 시점 | 행위 |
|---|---|
| **PRE-WRITE** (작성 전) | As-Is `.cs` Read + 분석 자료 4종 Read 의무 |
| **WRITE** (작성 중) | 각 핸들러/SP/검증/계산에 `// AS-IS: {ScreenId}.cs:LLLL` 주석 |
| **POST-WRITE** (작성 직후) | 매핑 카운트 검증 (`__asis-mapping__.md` ↔ To-Be 코드) |
| **PRE-SUBMIT** (PR 직전) | 4축 자동 검증 + 누락 0건 확인 |

---

## §1. PRE-WRITE 체크리스트 (모두 ✓ 필수)

### 1.1 As-Is 원본 직접 Read

```
☐ As-Is .cs 파일 직접 Read (전체)
   Read: Doc/_legacy_source/.../{ScreenId}.cs
   - 2000줄 초과 → offset/limit 분할 Read (생략 금지)
   - 핸들러/메서드/SP 호출 모두 확인

☐ As-Is .Designer.cs 직접 Read
   - 이벤트 핸들러 등록
   - DefColumns struct
   - 컨트롤 인벤토리

☐ POPUP .cs 파일들 직접 Read
   grep -E "new (\w+)Popup\b" {ScreenId}.cs → POPUP 목록 추출
   find Doc/_legacy_source/ -name "*{Popup}*.cs" → 각 .cs Read
```

### 1.2 분석 자료 4종 Read

```
☐ Doc/_analysis/domain_*/screens/{ScreenId}/analysis.md
   - §4 Event 핸들러 (개수 확인)
   - §5 호출 Endpoint
   - §4.5 Grid 컬럼 정의

☐ Doc/_analysis/domain_*/screens/{ScreenId}/validation.md
   - 카테고리별 요약 (필수값/날짜기간/중복/모드분기/사업부분기)
   - 메서드(Handler)별 Validation 상세
   - v6/v6.2 보강 — POPUP Validation

☐ Doc/_analysis/domain_*/screens/{ScreenId}/expressions.md
   - SUM 헤더 / Cell.Formula / LockRange / 산술연산

☐ Doc/_analysis/domain_*/screens/{ScreenId}/tobe_design.md
   - §2 REST API 매핑
   - §9 v6 To-Be 정형화 (조회조건 schema, 동적 컬럼, 3단 헤더 등)
```

### 1.3 Diff (원본 vs 분석 자료)

```
☐ 원본에서 발견한 모든 EVENT 가 analysis.md §4 에 있는가?
☐ 원본에서 발견한 모든 MSG##### 가 validation.md 에 있는가?
☐ 원본에서 발견한 모든 ColumnHeaderSpan/Cell.Formula 가 expressions.md 에 있는가?
☐ 원본에서 발견한 모든 FoxDataRequest 가 analysis.md §5 에 있는가?
☐ 분석 자료에 누락된 항목이 있으면 사용자에게 보고 (단순 SKIP 금지)
```

---

## §2. WRITE — 매핑 주석 의무

To-Be 코드 작성 시 매 핸들러/SP/검증/계산에 다음 주석 의무:

```tsx
/** AS-IS: DMF0020_SalesFuturePrice.cs:1933 SaveData MSG00004 confirm */
const confirmSaveData = useCallback(...);

/** AS-IS: DMF0020_SalesFuturePrice.cs:2369 btnSavePricePeriod_Click MSG00408 guardLock */
const guardLock = (): boolean => { ... };

/** AS-IS: DMF0020_SalesFuturePrice.cs:645,673 SetSpreadHeaderSpan SUM 헤더 */
const buildLargeSumHeader = useCallback(...);

/** AS-IS: DMF0020_SaveSalesFuturePrice_Popup.cs (PriceAll 셀 변경 핸들러) */
const onCellEditEnded = (s, e) => { ... };
```

**누락 검출 의무**: `__asis-mapping__.md` 의 모든 ✅ 행은 To-Be 코드에 동일 주석이 있어야 함.

---

## §3. POST-WRITE 자동 검증 명령

### 3.1 As-Is 주석 카운트 vs 매핑 매트릭스 행 수

```bash
SCREEN=DMF0020   # 예시
PATH_TO=features/master/src/pages/sales-future-price

# 3.1.1 To-Be 코드의 `// AS-IS:` 주석 카운트
ASIS_COMMENT_CNT=$(grep -rcE "// AS-IS: ${SCREEN}|AS-IS: ${SCREEN}" $PATH_TO | awk -F: '{s+=$2} END {print s}')
echo "To-Be AS-IS 주석: $ASIS_COMMENT_CNT 건"

# 3.1.2 __asis-mapping__.md 의 ✅ 행 카운트
MAP_OK_CNT=$(grep -cE "\| ✅ \|" $PATH_TO/__asis-mapping__.md)
echo "Mapping ✅ 행: $MAP_OK_CNT 건"

# 3.1.3 validation.md 의 전체 행 카운트
VAL_CNT=$(grep -cE "^\| [0-9]+ \|" Doc/_analysis/domain_DM/screens/${SCREEN}_*/validation.md)
echo "validation.md 행: $VAL_CNT 건"

# 카운트 일치 확인
[[ $ASIS_COMMENT_CNT -ge $VAL_CNT ]] || echo "❌ 누락 의심 — AS-IS 주석 < validation.md 행 수"
```

### 3.2 4축 매핑 검증 (PowerShell, Windows)

```powershell
$Screen = "DMF0020"
$Path = "C:\Projects\NSCM\nscm-fe\features\master\src\pages\sales-future-price"
$Analysis = "C:\Projects\NSCM\Doc\_analysis\domain_DM\screens\${Screen}_SalesFuturePrice"

# Event 카운트
$EventInAnalysis = (Select-String -Path "$Analysis\analysis.md" -Pattern "^\| \d+ \| `" \w+`"" -ErrorAction SilentlyContinue).Count
$EventInToBe = (Select-String -Path "$Path\*" -Recurse -Pattern "AS-IS: ${Screen}_\w+\.cs:\d+" -ErrorAction SilentlyContinue).Count

# Validation 카운트
$ValInAnalysis = (Select-String -Path "$Analysis\validation.md" -Pattern "^\| \d+ \|").Count
$ValInToBe = (Select-String -Path "$Path\hooks\*Validation.ts" -Pattern "const \w+ = useCallback").Count

# Expression 카운트
$ExpInAnalysis = (Select-String -Path "$Analysis\expressions.md" -Pattern "^\| \d+ \|").Count
$ExpInToBe = (Select-String -Path "$Path\hooks\*Expression.ts" -Pattern "const \w+ = useCallback").Count

Write-Host "Event:      analysis=$EventInAnalysis | To-Be=$EventInToBe"
Write-Host "Validation: analysis=$ValInAnalysis | To-Be=$ValInToBe"
Write-Host "Expression: analysis=$ExpInAnalysis | To-Be=$ExpInToBe"
```

### 3.3 시각적 grep — 누락 의심 패턴 검출

```bash
# Modal 에서 mutation/save 함수 누락 검출
grep -L "useProcMutation" $PATH_TO/components/modals/*.tsx
# → 출력 파일은 mutation 없음 → 의심

# Modal 에서 validatePeriodOrder/guardLock 누락 검출
for f in $PATH_TO/components/modals/*.tsx; do
  has_lock=$(grep -c "guardLock\|isReadOnly" $f)
  has_period=$(grep -c "validatePeriod\|periodFrom.*periodTo" $f)
  echo "$f: lock=$has_lock period=$has_period"
done

# Hook 에서 hardcoded 사업부 분기 (40/81/82) 보존 확인
grep -cE "DIVISION_CODE\.(AUTOMOTIVE|ESS|POWER)" $PATH_TO/hooks/use*Validation.ts
# → analysis.md 의 "사업부분기 35건" 과 유사 카운트 기대
```

---

## §4. 4축 누락 매트릭스 — DMF0020 사고 사례 (2026-05-22)

DMF0020 modal simplification 시 발생한 누락 12건을 본 hook 이 자동 검출했어야 함:

| 축 | 항목 | 누락 위치 | 검출 방법 |
|---|---|---|---|
| Validation | P1 MSG00142 guardLock | ExchangeRateModal | `grep MSG00142 components/modals/Exchange*.tsx → 0건` |
| Validation | P2 MSG00108 validatePeriodOrder | ExchangeRateModal | `grep validatePeriod components/modals/Exchange*.tsx → 0건` |
| Validation | P3 MSG00135 guardLock1 | PriceBatchInputModal | `grep MSG00135 components/modals/PriceBatch*.tsx → 0건` |
| Validation | P4 MSG00408 guardLock2 | PriceBatchInputModal | `grep MSG00408 components/modals/PriceBatch*.tsx → 0건` |
| Validation | P5 MSG00002 BatchInputRowSchema | PriceBatchInputModal | `grep REQUIRED_FIELDS components/modals/PriceBatch*.tsx → 0건` |
| Validation | P6 MSG00108 validatePeriodOrder | PriceBatchInputModal | (P2와 동일 패턴) |
| Event | #70 cboBucketType_Click MSG00227 | SalesFuturePriceForm | `grep MSG00227 SalesFuturePriceForm.tsx → 0건` |
| API | DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL | ExchangeRateModal | `grep useProcMutation Exchange*.tsx → 0건` |
| API | DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP | PriceBatchInputModal | `grep useProcMutation PriceBatch*.tsx → 0건` |
| API | save in SalesPriceRangeModal | SalesPriceRangeModal | `grep useProcMutation SalesPriceRange*.tsx → 0건` |
| Expression | PriceAll auto-fill | PriceBatchInputModal | `grep "PriceAll" components/modals/PriceBatch*.tsx → 0건` |
| Expression | onCellEditEnded W_* sync | PriceBatchInputModal | (위와 동일) |

**모두 PR 머지 직전에 본 hook 으로 자동 검출되어야 함**.

---

## §5. PRE-SUBMIT 머지 게이트

다음 4축 모두 통과해야 PR 머지 가능:

```
☐ Event:      To-Be 코드의 AS-IS 주석 카운트 >= analysis.md §4 Event 핸들러 카운트
☐ API:        To-Be 코드의 useTabProcQuery/useProcMutation 호출 + As-Is endpoint 카운트 일치
☐ Validation: To-Be hook 의 메서드 + 호출처 카운트 >= validation.md 전체 행 수
☐ Expression: To-Be hook 의 메서드 + 호출처 카운트 >= expressions.md 전체 행 수
☐ POPUP:      POPUP .cs 파일별 validation 모두 Modal 컴포넌트에 반영
☐ Mapping:    __asis-mapping__.md 의 모든 ✅ 행이 실제 grep 으로 검증됨
```

**1건이라도 ✗ → PR Reject**.

---

## §6. ❌ 절대 금지 패턴

| # | 금지 | 사유 |
|---:|---|---|
| 1 | 신규화면 작성 시 As-Is .cs 미Read | 단순화 → 누락 |
| 2 | Modal/POPUP 별도 .cs 미Read | DMF0020 사고 사례 |
| 3 | analysis.md 만 보고 To-Be 작성 | 분석 누락 시 To-Be 도 누락 |
| 4 | "모달은 단순 조회만" 가정 (As-Is 가 save 가능한데도) | 저장 기능 누락 |
| 5 | 사업부 분기 통합 (40+81+82 단일 로직화) | 룰 09 §10 위반 |
| 6 | `__asis-mapping__.md` 의 ✅ 마킹이 실제 코드와 불일치 | 신뢰 손상 |
| 7 | 작성 직후 본 hook 의 §3 자동 검증 SKIP | 누락 미검출 |

---

## §7. 다른 룰과의 관계

| 룰 | 관계 |
|---|---|
| `anti-simplification.md` | 본 hook 의 상위 룰 — 추출 누락 금지 |
| `09_WIJMO_VALIDATION_EXPRESSION.md` | 본 hook 의 §3.3 매핑 방식 (사업부 분기 보존) |
| `23_FE_IMPORT_INVENTORY.md` | import 정확성 (본 hook 과 별도 축) |
| `24_ASIS_CROSSCHECK.md` | 본 hook 의 데이터 룰 |
| `hooks/fe-import-check.md` | import 검증 (본 hook 과 짝) |
| `hooks/pre-write.md` / `post-write.md` / `pre-submit.md` | 본 hook 이 이들의 As-Is 축 보강 |

---

## §8. 변경 이력

- 2026-05-22: 신규 작성 (DMF0020 modal simplification 시 12건 누락 사고 후).
  - 4축 (Event/API/Validation/Expression) 매핑 검증 자동화.
  - PRE-WRITE / WRITE / POST-WRITE / PRE-SUBMIT 4단계 hook.
