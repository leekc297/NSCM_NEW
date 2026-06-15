# DMF0008 패키지 — 2026-06-10 patch 보강

> 본 patch 는 기존 패키지 (`README.md` / 2026-06-05 작성) 의 후속.
> 클라우드 이관 시 **기존 절차 그대로 + 본 patch 의 추가 step** 으로 적용.

## 적용 배경 (사용자 사고)

오늘 (2026-06-10) 로컬 docker DB 에서 4 사고 진단:

| # | 사고 | 원인 | 해당 fix |
|---|---|---|---|
| 1 | SUMMARY 빈 결과 | 메인 cursor 가 line 132 `OPEN O_RC1 FOR SELECT NULL DUMMY` 로 덮어쓰기 | `01_SP_BODY/020_*FIX.sql` (기존, 동일) |
| 2 | SUMMARY/REPAIR 빈 결과 | `NVL(EXCEPTION_FLAG, NULL) != 'Y'` NULL 비교 anti-pattern | `01_SP_BODY/050_*NVL_FIX.sql` + `060_*Recompile.sql` (기존, 동일) |
| 3 | SALES_SITE dblClick error | UTL_CALL_STACK.SUBPROGRAM(1)(1) 안전 체크 누락 → ORA-06533 | `01_SP_BODY/040_*UtlCallStack.sql` (기존, 동일) |
| 4 | **PROC_M signature mismatch** | **O_RESULT_CURSOR 메타 누락 → ORA-06550 PLS-00306** | **`03_META/100_*PROC_M_O_RESULT_CURSOR_boost.sql` ⭐ 신규 (본 patch)** |

→ 사고 1-3 의 SP body fix 는 기존 `01_SP_BODY/` 폴더에 이미 반영. **사고 4 가 신규** — `03_META/100_*` 로 추가.

## 추가 신규 파일

```
03_META/100_DMF0008_PROC_M_O_RESULT_CURSOR_boost.sql               ← sqlplus 호환
03_META/100_DMF0008_PROC_M_O_RESULT_CURSOR_boost_DBeaver.sql        ← DBeaver 호환
03_META/100_DMF0008_PROC_M_O_RESULT_CURSOR_boost_DBeaver_Verify.sql ← UNION ALL 단일 SELECT 검증
```

## FE 파일 보강 (2026-06-09 refactor)

이전 패키지의 FE 는 `ErpEdiMaster.tsx` 한 파일에 4 grid + UpdateHistory bar inline JSX (440 lines).

오늘 룰 v2 신설 `_tobe/01_file_structure.md §1.5` + hook `components-folder-pattern.md` 에 따라 **components/ sub-component 분리** 완료:

```
01_FE/erp-edi-master/
├── ErpEdiMaster.tsx                 ← 307 lines (composition only)
├── erp-edi-master.utils.ts          ← 신규 (applyReadOnlyColoring 공용)
├── components/
│   ├── ErpEdiMasterForm.tsx         (기존)
│   ├── ErpEdiMasterSummaryGrid.tsx  ← 신규
│   ├── ErpEdiMasterRepairGrid.tsx   ← 신규
│   ├── ErpEdiMasterSalesSiteGrid.tsx (개정 — broken dead code 정리)
│   ├── ErpEdiMasterSspmGrid.tsx     ← 신규
│   ├── ErpEdiMasterUpdateHistoryBar.tsx ← 신규
│   └── modals/                      ← 룰 01 §1.5.2 의무 폴더
│       └── .gitkeep
```

## 적용 순서 (기존 + 신규)

```
Phase A : 00_DDL/  (기존 그대로)
Phase B : 02_SEED_DATA/  (skip — 비어있음)
        : 03_META/010 → 020 → 030 → 040 → 050 → 060 → 070 → 080 → 090
        : 03_META/100_DMF0008_PROC_M_O_RESULT_CURSOR_boost.sql  ⭐ 신규
Phase C : 01_SP_BODY/010 → 020 → 030 → 040 → 050 → 060  (기존 그대로)
        : 04_GRANT_SYNONYM/  (기존 그대로)
Phase D : 05_VERIFY/
        : 03_META/100_DMF0008_PROC_M_O_RESULT_CURSOR_boost_DBeaver_Verify.sql  ⭐ 신규
Phase E : FE 클라우드 진입 → DMF0008 → 4 sheet 모두 조회 + Repair row 더블클릭 → SalesSite/SSPM tab 데이터 표시 검증
```

## 트러블슈팅

### "조회 success 인데 grid 빈 행" (사고 1, 2)
→ `01_SP_BODY/020 + 050 + 060` 미적용. CREATE OR REPLACE 후 STATUS=VALID 확인.

### "ORA-06550 PLS-00306 인수의 갯수나 유형이 잘못되었습니다" (사고 4)
→ `03_META/100_*` 미적용. PROC_M 카운트 검증:
- SUMMARY=8 rows / REPAIR=9 rows / SSPM=7 rows 모두 충족해야 함.

### "Repair 더블클릭 시 ORA-20001 오류가 발생했습니다" (사고 3)
→ `01_SP_BODY/040_*UtlCallStack.sql` 미적용. UTL_CALL_STACK.SUBPROGRAM(1).COUNT >= 2 안전 체크 패턴 적용 확인.

## 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-05 | 초기 패키지 (40 파일) |
| 2026-06-10 | 03_META/100_* 3종 추가 (PROC_M O_RESULT_CURSOR 보강) + FE refactor (6 component + modals/) |
