# Hook — Runtime Error Prevention (신규 화면 기본 오류 방지)

> ⚠️ **사용자 요구 (2026-05-28)**: "화면 생성 시 이미 만들어져 있는 화면을 참조해서 기본적인 오류는 발생하지 않도록 rule 을 강화해서 적용해주세요."
> 신규 화면 작성 시 (1) Vite SyntaxError (import 미존재), (2) ReferenceError (변수 미정의) 두 사고 유형 절대 금지.

작성: 2026-05-28 (DMF0020 SalesPriceVersionModal / SalesFuturePriceForm 사고 후)
상위 룰: `hooks/anti-simplification.md` / `25_NEW_SCREEN_MANDATORY_CHECKLIST.md`
관련: `23_FE_IMPORT_INVENTORY.md` / `hooks/fe-import-check.md` / `hooks/post-write.md`

---

## §0. 사고 사례 (2026-05-28)

| # | 사고 | 발생 라인 | 원인 | 결과 |
|---:|---|---|---|---|
| 1 | `Box is not exported from '@shared/mui'` | `SalesPriceVersionModal.tsx:18`, `ColumnTitleSetModal.tsx:23` | `@shared/mui` 의 실제 export 인벤토리 확인 없이 MUI 의 `Box` 를 추측으로 import | Vite SyntaxError → 화면 진입 실패 |
| 2 | `isEss is not defined` | `SalesFuturePriceForm.tsx:193` | Edit 으로 `const isEss = ...` 선언을 `showTemplateButton` prop 으로 대체할 때 라인 193 의 `disabled={!isEss}` 사용처를 갱신 안 함 | ReferenceError → 컴포넌트 render 실패 |

**공통 패턴**: 신규 화면 작성 시 **기존 화면의 정확한 import 패턴 및 변수 사용처를 cross-check 하지 않은 단순화** 가 원인.

---

## §1. 절대 금지 (Hard Rules)

| # | 금지 |
|---:|---|
| 1 | ❌ `@shared/mui`, `@shared/components`, `@shared/lges`, `@foundation/*` 에서 **확인 없이** 컴포넌트/함수 import |
| 2 | ❌ "MUI 에 있으니까 `@shared/mui` 에도 있겠지" 추측 (Box / Container / Paper / IconButton / TextField 등) |
| 3 | ❌ Edit 으로 변수 선언 삭제/변경 후 **사용처 grep 검증 없이** 완료 보고 |
| 4 | ❌ 작성 직후 dev 서버 동작 검증 없이 "완료" 보고 (사용자가 첫 오류 발견하는 사태) |
| 5 | ❌ 기존 화면 (특히 `customer-forecast-master`, `user-management`) 의 import block 을 cross-check 하지 않고 신규 화면 작성 |

---

## §2. 의무 (작성 직전 / 직후)

### 2.1 PRE-WRITE — import 인벤토리 확인

신규 화면 코드 작성 시 import 줄 작성 직전 **다음 3 단계 모두 수행**:

```
[Step 1] 룰 23 (`23_FE_IMPORT_INVENTORY.md`) Read
   - §1 `@shared/components` 정확 목록
   - §2 `@shared/lges` 정확 목록
   - §5.1 `@shared/mui` 정확 목록 (2026-05-28 보강 — Box/Container/Paper 미존재)
   - §6 `@foundation/*` 정확 목록

[Step 2] 의심 import 가 있으면 즉시 실제 파일 Read 로 검증
   - `Read: nscm-fe/packages/shared/src/lib/mui.ts`
   - `Read: nscm-fe/packages/shared/src/components/index.ts`
   - `Read: nscm-fe/packages/shared/src/lib/lges.ts`

[Step 3] 기존 유사 화면의 import block 직접 Read 로 패턴 차용
   - Master 도메인 신규 화면 → `customer-forecast-master/` 의 import 패턴 참조
   - Admin 도메인 신규 화면 → `user-management/` 의 import 패턴 참조
   - Modal 신규 → 기존 modal (`ExchangeRateModal.tsx` 등) 의 import block 참조
```

⛔ 위 3 단계 중 1건이라도 SKIP → anti-simplification 룰 위반.

### 2.2 POST-WRITE — 사용처 grep 검증

Edit 으로 변수/import 를 변경한 경우 **즉시 grep 검증 의무**:

```bash
# 변수명 grep (선언 제거 후 사용처 잔존 확인)
grep -nE "\b{삭제된_변수명}\b" {수정한_파일} && echo "ERROR: 미정의 변수 사용 잔존" || echo "OK"

# import grep (삭제된 import 의 잔존 사용처 확인)
grep -nE "\b{삭제된_import}\b" {수정한_파일} && echo "ERROR: 미import 항목 사용 잔존" || echo "OK"
```

### 2.3 작성 완료 시 자체 점검 6항목

```
[ ] 1. 모든 import 가 룰 23 의 정확 인벤토리와 일치하는가?
[ ] 2. `Box` / `Container` / `Paper` / `IconButton` 등 추측 import 0건인가?
[ ] 3. Edit 으로 선언 변경한 변수의 사용처 grep 0건 미정의?
[ ] 4. 기존 유사 화면 1개 이상의 import block 과 패턴 비교 완료?
[ ] 5. 메모리 트리거 `feedback_no_type_cast_around_runtime.md` 적용 — 강제 cast 없이 의도된 데이터 형식?
[ ] 6. 컴포넌트 props (Form/Grid/Modal 등) 의 prop 전달 완전성 확인 (메인 ↔ 자식 일치)?
```

❌ 6항목 중 1건이라도 ✗ → 사용자에게 "기본 오류 가능성 N건 — 다음 자체 점검 후 재진행" 보고.

---

## §3. 자동 검증 명령 (PRE-SUBMIT)

신규 화면 작성 후 PR 직전 다음 grep 자동 검증 의무:

```bash
SCREEN_PATH="nscm-fe/features/{domain}/src/pages/{kebab-name}"

# 1. @shared/mui 에 없는 항목 사용 검출 (Box / Container / Paper / IconButton / TextField / Dialog / Autocomplete)
for bad in Box Container Paper IconButton TextField Dialog Autocomplete; do
  cnt=$(grep -rE "import\s+\{[^}]*\b$bad\b[^}]*\}\s+from\s+'@shared/mui'" $SCREEN_PATH | wc -l)
  [ $cnt -gt 0 ] && echo "❌ $bad: $cnt 위치에서 잘못된 import"
done

# 2. 미정의 변수 사용 검출 (간단 — JSX 안의 자주 사고 변수)
for v in isEss isPower isAutomotive division divisionCode; do
  declared=$(grep -E "(const|let|var|prop)\s+$v\b|$v[?:]?[\s,}=]" $SCREEN_PATH | wc -l)
  used=$(grep -E "\{!?$v\}|disabled=\{!?$v\}" $SCREEN_PATH | wc -l)
  [ $used -gt 0 ] && [ $declared -eq 0 ] && echo "❌ $v: 미선언 사용 $used 위치"
done

# 3. Vite dev 서버 동작 검증 (선택)
# 사용자 직접 서버 기동 후 화면 진입 → "Unexpected Application Error" 발생 0건 확인
```

---

## §4. 룰 25 §1.5 보강 — Hook 자동 적용

`Doc/_dev_rules/25_NEW_SCREEN_MANDATORY_CHECKLIST.md` §1.5 Hook MD (3종) 에 본 hook 을 4번째로 추가:

```
[ ] new-screen-pre-build.md       ⭐ 본 체크리스트의 실행 hook
[ ] pre-write.md                  ⭐ 파일 작성 직전
[ ] fe-import-check.md            ⭐ FE 작업 시
[ ] asis-coverage-check.md        ⭐ As-Is 4축 매핑 검증
[ ] runtime-error-prevention.md   ⭐ NEW (2026-05-28) — 신규 화면 기본 오류 방지
```

---

## §5. 적용 범위

본 hook 은 **모든 FE 신규 화면 + Modal + Hook + Form** 에 적용. 단순 Edit 으로 기존 화면의 1~2 라인 수정 시는 적용 면제 (단 import 변경 시는 적용).

---

## §6. 위반 시 결과

위반으로 발생한 사고 사례 (2026-05-28 — DMF0020):

| 사고 | 사용자 체험 |
|---|---|
| `Box is not exported` | 시크릿 창 재로그인 후 메뉴 클릭 → 빈 화면 + Error Boundary 노출 |
| `isEss is not defined` | 위 수정 후 재진입 → 다시 Error Boundary 노출 (반복 사고) |

→ AI 신뢰도 손상 + 사용자 시간 낭비. 사용자가 직접 디버깅하게 만드는 결과.

---

## §7. 변경 이력

- 2026-05-28: 신규 작성 (DMF0020 Box/isEss 2건 사고 후).
  - 룰 23 §5.1 `@shared/mui` 정확 export 목록 보강 + Box/Container/Paper 미존재 명시
  - 룰 25 §1.5 에 본 hook 추가
