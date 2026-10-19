---
paths:
  - "nscm-fe/**"
---
# FE 화면 규약 (nscm-fe/** 를 만질 때 자동 로드) — 구 CLAUDE.md Step 3 / 3.5 / 4 / §5 FE / §6 FE / §7 승계

## A. 작업 진입 (FULL 모드 — 생략 금지)
- T01(신규) / T01M(수정) / T04~T07 해당 여부를 먼저 판별 → `Doc/_rules_consolidation/TRIGGER_ROUTER.md` 행의 핵심 Hook Read.
- T01/T01M 은 `Doc/_rules_consolidation/UI_MANDATORY_CHECKLIST.md` PRE-WRITE 통과 + 종료 전 `hooks/screen-completion-gate.md` 8 게이트.
- **절대 누락 금지 3종** (admin 동적 속성관리 master): `hooks/ui-dynamic-property-management.md`(1순위) → `hooks/menu-button-dynamic-fetch.md` → `hooks/ui-category-setup-column-meta.md`. 누락 = admin 운영 결정이 화면에서 무효화 = 신뢰성 손상.
- 실행 hook `check-rules-read.ps1` 가 `features/**/pages/**` 저장 전에 위 필수 hook 열람 여부를 검사해 미열람 시 차단한다.

## B. 기존 유사 코드 참조 (신규 파일 작성 전 필수)
- 표준 패턴: `nscm-fe/features/admin/src/pages/user-management/` · reference 화면 Tab형=DMF0004 / Panel형=DMF0005 / 단일 grid=DMF0006.
- 신규 코드는 기존 패턴과 폴더 구조·import 순서·명명·주석 헤더까지 완전히 동일 ("한 사람이 개발한 것처럼").

## C. ⭐ 신규 화면 features 폴더 결정 5단계 (SCM0008 사고 — 9 파일 중복 작성 위험)
1. `SCM_ADM_MNU_M` 트리 walk-up — `UPPR_MNU_ID` 최상위 부모(Lv 0) 식별
2. 최상위 → features 매핑: Master/Demand/Report → 동명 폴더 / Admin → `features/admin` / **Authority(UPPR_MNU_ID=Auth_Mgmt 포함) → `features/authority`**
3. `Router.tsx` import 검색 — `@authority/auth-request` 같은 import 가 있으면 **기존 작성 = cross-check 만**
4. `features/{layer}/src/pages/` 인벤토리 grep — 자매 화면 표준 패턴 학습
5. 결과 보고 — 신규 작성 / cross-check 결정 명시
> 근거 룰: `_rules_v2/_tobe/01_file_structure.md` §1.3/§1.4

## D. 화면별 분석 자료 (FE 신규 화면 필수)
- `Doc/_analysis/domain_{DM|Common|SCM}/screens/{화면ID}/` 8개 MD — 특히 **validation.md + expressions.md 필독**.
- Excel: `_analysis/_screens/{27|28|29|30|31|32}_*_Screens/*_{화면ID}.xlsx` 의 `11_Validation` + `12_Expression` 시트.
- ⭐ **카운트 일치 의무**: 위 자료 행 수 = To-Be 코드 적용 건수 (누락 0) — PR 머지 조건. `__asis-mapping__.md` 작성 필수.
- ⭐ **xlsx 1~10 시트 신뢰 금지**: `00_정정안내_READ_ME` 시트가 있거나 `1_화면개요` 화면 ID 가 파일명과 다르면 **MD 폴더를 1차 신뢰** (27_DM 14개 파일 오염 사고).

## E. 명명 / 표준 호출
- 컴포넌트 `PascalCase.tsx` · 폴더 `kebab-case/` · 훅/스토어/유틸 `camelCase.ts` · 타입/상수 `kebab-case.{types,constants}.ts` · alias `@foundation` `@shared` `@admin` `@demand` …
- API: `useTabProcQuery<MENU_ID>({ menuId, sheetName, tabId, filters, enabled })` / `useProcMutation<MENU_ID>({ menuId, sheetName, tabId })` — 직접 `fetch`/`axios` 금지. `filters` 에 인라인 객체 리터럴 금지(참조 비교 → 무한 재요청).
- Grid = 공용 `DataGrid` 만(FlexGrid JSX 직접 금지) · Form = SearchArea/FormItem/CustomDropdown + `commonStyles.formItem` · 메시지 = `useMessageStore` (`window.alert` 금지) · 저장 행 판정 = `CRUD_TYPE` 전용 · `apiClient.post(call-proc)` 는 `res.status >= 400 || Number(res.data.code)` 판정 동반.

## F. 작성 직후 자기 점검
✅ 명명 규약 ✅ Layer 위반 0 ✅ 기존 패턴 참조 ✅ 표준 호출 ✅ SCSS Module(inline style 0) ✅ `any`/`as unknown as` 0 ✅ validation/expressions 누락 0 + `__asis-mapping__.md` ✅ `pnpm lint:fix` · `pnpm type-check` · `pnpm build` 통과 → 상세 `hooks/post-write.md`
