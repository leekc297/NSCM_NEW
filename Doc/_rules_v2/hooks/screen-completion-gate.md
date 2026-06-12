# Hook — screen-completion-gate (UI 화면 완성도 통합 게이트) ⭐ 2026-06-11 신설

> **트리거**: 신규 화면 작성 완료 직전 / 화면 수정 작업 종료 직전 / "화면 다 됐어?" / PR 제출 전
> **목적**: 화면 개발 시 누락·미구현·런타임 오류가 반복되는 문제 해소.
> 개별 hook 은 작성 "중" 체크인 반면, 본 게이트는 작업 **종료 선언 전 마지막 관문**이다.
> ⚠️ **아래 G1~G8 중 1개라도 미수행 상태로 "완료" 보고 금지.** 각 게이트는 증거(카운트/grep 결과/캡쳐)와 함께 보고한다.

---

## §0 게이트 매트릭스 (8 게이트 — 전부 의무)

| # | 게이트 | 판정 기준 | 근거 룰/Hook |
|---|---|---|---|
| G1 | AS-IS 매핑 완전성 | `__asis-mapping__.md` 4축 (Event/API/Validation/Expression) 카운트 = AS-IS 분석 자료 행 수와 **정확 일치, 누락 0** | asis-coverage-check + CLAUDE.md §4-11 |
| G2 | 버튼 10대 매핑 | CRUD 6 + Search Aux 4 전수 판정 (구현/숨김/자동활성 명시). `() => undefined` 빈 핸들러 0건 | asis-button-mapping |
| G3 | Grid 메타 완전성 | 전 grid: DataGrid 래퍼 + `_inputEditType`/`_ctrlType`/`_modalKey` + SHEET_COLUMNS ↔ SP alias 일치 + selectionMode 명시 | grid-column-meta + sheet-columns-binding-match + grid-interaction-patterns |
| G4 | 메타/라우팅 정합 | MNU_M (UPPR 대소문자/MNU_DESC/MNU_TP_CD) + SHT_NM FE↔DB 일치 + PROC_M positional + 권한 (MNU_BTN_MPG_M ↔ USER_GR) | menu-not-displayed-debug 7단계 + proc-meta-signature-match |
| G5 | 정적 검증 | `pnpm lint:fix` + `pnpm type-check` + `pnpm build` 3종 PASS (출력 첨부) + type-check-error-patterns 17종 grep 0건 | type-check-error-patterns + post-write |
| G6 | 런타임 smoke (실행 증명) | 화면 진입 → 조회 → (편집 화면이면) Insert/수정/Save → **DB SELECT 로 실반영 확인** + 브라우저 콘솔 에러 0건. "alert 떴으니 됨" 금지 | oracle-db-workflow §2.5 + runtime-error-prevention |
| G7 | 표준 패턴 정합 | 자매 화면(동일 features 폴더) 1개와 구조 비교: SearchArea/FormItem/Store/Constants/components 폴더 — 임의 작성 0건 | _tobe/01~10 + components-folder-pattern + screen-create-checklist |
| G8 | 이관 완전성 | deploy package 5종 인벤토리 (DDL/META/SP body/GRANT/i18n) + 멱등 SQL + 공용/wrapper SP 포함 | deploy-package-completeness |

## §1 누락 다발 지점 (사고 통계 기반 — 우선 점검)

> 2026-05~06 사고 이력에서 반복 빈도 상위:

1. **validation.md / expressions.md 매핑 누락** (G1) — 카운트 불일치 = PR 머지 불가
2. **메타 1글자 불일치** (G4) — UPPR_MNU_ID 대소문자 / SHT_NM / COL_NM camelCase / COLUMN_NAME alias → 화면 미표시·빈 grid·권한없음
3. **silent fail** (G6) — 컴파일 PASS·alert 표시·DB 미반영. DB SELECT 검증 없이는 발견 불가
4. **빈 버튼 핸들러 / hotkeyConfig 일괄 false** (G2) — 기능 자체가 조용히 사라짐
5. **자매 화면 미참조 임의 작성** (G7) — DMF0020 조회조건 사고: label+input 임의 작성 → 전면 재작성
6. **lookup combo / popup SP / i18n 키 이관 누락** (G8) — 화면은 되는데 배포처에서 깨짐

## §2 게이트 실행 절차

```
1. 작업 종료 선언 전, 본 파일 §0 표를 그대로 복사하여 보고서 작성
2. 각 게이트에 PASS/FAIL + 증거 1줄 (카운트, grep 0건, 캡쳐 경로, SELECT 결과)
3. FAIL 1건이라도 있으면: 보완 → 해당 게이트 재실행 (전체 재실행 불요)
4. 8/8 PASS 후에만 "완료" 보고 + pre-submit hook 진입
```

### 보고 양식 (복사용)

```md
## screen-completion-gate 보고 — {MENU_ID} ({날짜})
| G | 결과 | 증거 |
|---|---|---|
| G1 AS-IS 매핑 | PASS | validation 23/23, expression 14/14 |
| G2 버튼 10대 | PASS | CRUD 3 구현 + 3 숨김, Aux 4 자동활성 |
| G3 Grid 메타 | PASS | 2 grid, SHEET_COLUMNS 17/17 alias 일치 |
| G4 메타/라우팅 | PASS | MNU_DESC OK, SHT_NM='xxx' FE=DB |
| G5 정적 검증 | PASS | lint/type-check/build 3종 (로그 경로) |
| G6 런타임 smoke | PASS | 조회 152 row, SAVE 후 SELECT 3 row 확인, 콘솔 0 |
| G7 표준 정합 | PASS | 자매 DMF0007 대비 구조 동일 |
| G8 이관 완전성 | PASS | 5종 인벤토리 (zip 경로) |
```

## §3 부분 수정 작업 시 축소 적용

화면 전체가 아닌 부분 수정(버그 fix, 컬럼 1개 추가 등)은 **영향 게이트만** 적용하되, **G5(정적) + G6(런타임 smoke)은 항상 의무**:

| 수정 범위 | 의무 게이트 |
|---|---|
| Grid/컬럼 | G3 + G5 + G6 |
| 버튼/이벤트 | G2 + G5 + G6 |
| 조회조건 | G7 + G5 + G6 |
| SP/메타 | G4 + G6 + oracle-db-workflow §2 |
| 단순 스타일 | G5 + G6(진입 확인만) |

---

> Cross-ref: pre-submit.md (본 게이트 8/8 PASS 가 선행 조건) | 00_INDEX §A T01 | anti-simplification.md (게이트 생략 = 위반)
