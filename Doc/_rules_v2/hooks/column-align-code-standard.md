# Hook #96 — column-align-code-standard (컬럼 정렬코드 단일문자 C/L/R 표준)

> **트리거**: UI Category Setup 컬럼 메타 작성/적용 (T04 grid / SHEET_COLUMNS INSERT·UPDATE / "정렬이 안 맞아요/우정렬돼요")
> **상태**: ⭐⭐ 필수 (사용자 명시 2026-06-28, SYS0013 정렬 미적용 사고)
> **PR/적용 차단**: `HORIZONTAL_ALIGN_CODE` 에 전체단어("Center"/"Left"/"Right") 사용 금지.

---

## §0. 표준 (불변)
`SCM_MST_SHEET_COLUMNS.HORIZONTAL_ALIGN_CODE` 는 **단일문자만**: `C`(center) / `L`(left) / `R`(right).
- 전사 표준 = 단일문자 (318+ 화면 C/L/R). 전체단어("Center" 등)는 **비표준 아웃라이어**(~24 화면, SYS0013 포함).

## §1. 사고 메커니즘 (SYS0013)
- 증상: UI Category Setup 에 `Center` 설정인데 화면은 **우정렬**.
- 원인: FE `packages/foundation/src/utils/columnMapping.ts` 의 `alignMap = { L:'left', R:'right', C:'center' }` 는 **단일문자만** 키. → `alignMap['Center'] = undefined` → `align` 미설정 → 숫자 컬럼은 Wijmo 기본 **우정렬**.
- 즉 "UI Category Setup 적용 안 됨"의 정체 = 메타값이 비표준 전체단어.

## §2. 진단·교정
```sql
-- 비표준 전체단어 탐지 (화면 단위)
SELECT SHEET_NAME, COLUMN_NAME, HORIZONTAL_ALIGN_CODE
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = :mnu AND HORIZONTAL_ALIGN_CODE NOT IN ('C','L','R');
-- 교정 (멱등) — Center→C / Left→L / Right→R
UPDATE SCM_MST_SHEET_COLUMNS SET HORIZONTAL_ALIGN_CODE='C'
 WHERE PROGRAM_ID=:mnu AND HORIZONTAL_ALIGN_CODE='Center';  -- Left→L, Right→R 동일
```
- 사례 스크립트: `_artifacts/_apply_corporate/26_sys0013_align_code_fix.sql`.
- FE 무변경(alignMap 이미 C/L/R 지원). 신규 메타 작성 시 처음부터 C/L/R.

## §3. cross-ref
- FE: `foundation/utils/columnMapping.ts alignMap`(불변) · 짝 hook `ui-category-setup-column-meta` · `sheet-columns-binding-match`
- 짝 룰: 메타 INSERT NOT NULL 정합 = `corp-meta-integrity-and-wiring`(#98)
