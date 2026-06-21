# Hook — procedure.d.ts SSOT 타입 체인 (백엔드 통신 규격 단일화)

> **Trigger**: T01 (신규 화면) + T07 (데이터 조회/SAVE) + T08 (BE/SP)
> **출처(공식)**: `NSCM_FE 프로그램설계서.docx` §3 "API 통신프로토콜 정의" + `NSCM_FE 인수인계서.docx` §3-3 "신규 페이지 구성시 주의사항"
> **PR 차단 강도**: ⭐⭐⭐ (타입 SSOT 붕괴 = 전 화면 휴먼 에러 전파)
> **신설일**: 2026-06-19 (03.Framework 룰화)
> **상위 hook**: `framework-foundation-entry.md` §4 SSOT

## 0. 원칙 — "procedure.d.ts 가 모든 타입 추론의 뿌리"

모든 DB 프로시저의 IN/OUT 규격을 **`procedure.d.ts` 한 파일**에 전역 인터페이스로 정의한다. API 호출부에서 타입을 매번 재정의하지 않고, 프로젝트 전체가 동일 규격을 참조한다. TypeScript 가 매우 strict 하게 설정되어 있어 **제네릭을 통한 타입 추론의 기반이 곧 procedure.d.ts** 다. 이 파일이 틀리면 화면 전체가 잘못된 타입으로 컴파일된다.

> 인수인계서 §3-3 명시: "(중요) procedure.d.ts 설정 — 프로시저 IN/OUT 을 정확하게 작성해야 함. 이후 페이지 내 모든 부분에서 이 정보를 바탕으로 작업이 이루어집니다."

---

## 1. 작성 순서 (신규 화면 의무 — 역순 금지)

1. **procedure.d.ts 에 SP IN/OUT 정확 작성** — MENU_ID 별 프로시저 입력 파라미터 + Out Parameter + Result Set 타입.
2. `.constants.ts` 에 procedure.d.ts 와 정합하는 **MENU_ID / SHEETS / RESPONSE_SET / SHEET_INDEX** 작성.
3. constants 기반으로 store / hook / Grid / Form 개발 → 제네릭이 procedure.d.ts 에서 타입 자동 추론.

⚠️ procedure.d.ts 없이 화면 코드를 먼저 쓰면 `any` 누수 / 타입 불일치 / 런타임 에러 발생. **타입부터** 정의한다.

---

## 2. Result Set 정형화

- 프로시저가 반환하는 복잡한 결과(Out Parameter + Result Set)에 **명확한 타입** 부여.
- 데이터 가공(Formatting) / UI 바인딩 시 휴먼 에러 최소화.
- 화면 코드의 제네릭 패턴(기존 hook 과 정합):
  - `useTabProcQuery<MENU_ID, SHEETS.X>` — 조회 결과 타입 자동 추론
  - `useProcMutation<MENU_ID, SHEETS.X>` — SAVE 입력 타입 자동 추론
  - `ResponseData<MENU_ID, 'sheet', 'cursor'>` — 결과 셋 타입 인용 (재정의 금지)
  - `ProcRequest<MENU_ID, SHEETS>` — 요청 파라미터 타입

## 3. SSOT 강제 규칙

- ❌ 화면/컴포넌트에서 SP 응답 타입을 **로컬 interface 로 재정의** 금지 → procedure.d.ts 참조.
- ❌ `any` / `as unknown as` 로 타입 우회 금지 (strict mode 위반, #regression-zero 사고 카탈로그).
- ✅ 외부 라이브러리 타입 부실 시 직접 `any` 대신 **Type Guard 유틸**(설계서 §3.2 Utility-based Type Handling).
- ✅ 다른 화면/popup 의 결과 타입이 필요하면 그 화면의 constants `MODAL_XXX`/`MENU_ID` 를 import 해 `ResponseData<...>` 로 인용 (#grid-cell-interaction §5).
- 신규 개발자는 procedure.d.ts 만 확인하면 사용 중인 모든 프로시저 인터페이스 명세를 한눈에 파악 가능해야 함 (인수인계 효율).

---

## 4. PRE-WRITE 체크리스트

- [ ] 화면 작성 **전에** procedure.d.ts 에 해당 SP IN/OUT 을 정확히 정의했는가?
- [ ] `.constants.ts` 의 MENU_ID/SHEETS/RESPONSE_SET 이 procedure.d.ts 와 1:1 정합인가?
- [ ] 조회/저장 훅에 제네릭 `<MENU_ID, SHEETS.X>` 를 명시했는가?
- [ ] SP 응답 타입을 로컬 interface 로 재정의하지 않았는가?
- [ ] `any` / 불필요 `as` 캐스팅 0 인가?
- [ ] SP IN/OUT 이 BE PROC_M 메타 시그니처와 일치하는가? (#proc-meta-signature-match cross-ref)

## 5. POST-WRITE grep (0 hit 의무)

```bash
grep -rEn ":\s*any\b" features/*/src/pages/                    # 0 (any 금지)
grep -rEn "as unknown as" features/                            # 0 (강제 캐스팅 금지)
# 화면 안에서 SP 응답 interface 재정의 흔적 (Response/Row 직접 선언)
grep -rEn "interface \w+(Response|ResultSet)\b" features/*/src/pages/   # 검토 (procedure.d.ts 참조여야)
```

## 6. 안티패턴

| ❌ | ✅ |
|---|---|
| 화면 코드 먼저, 타입 나중 | procedure.d.ts IN/OUT 먼저 |
| `const data = res as any` | procedure.d.ts 기반 제네릭 추론 |
| 화면에 `interface XxxResponse {...}` 재정의 | `ResponseData<MENU_ID,'sheet','cursor'>` 인용 |
| 외부 lib 타입 부실 → `any` | Type Guard 유틸 |
| constants 의 SHEETS 가 procedure.d.ts 와 불일치 | 1:1 정합 (cross-check) |

## 7. Cross-ref

- `framework-foundation-entry.md` (상위 SSOT) / `screen-conventions-mandatory.md` (#47, constants 5 export) / `proc-meta-signature-match.md` (#39, BE 메타 정합) / `regression-zero-mandatory.md` (#41, TS 사고) / `type-check-error-patterns.md` (#64) / `_tobe/05_constants.md`
