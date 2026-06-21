# DMF0020 — Sales Future Price 클라우드 이관 ⭐

> Domain: master · Folder: `nscm-fe/features/master/src/pages/sales-future-price/`
> 이번 turn 핵심 작업 — 헤더 정합 / sticky merge / LOC editable / GTT 통계

## FE 이관 (18 파일)
- Modified: 15 / New: 3 (modal scss 3개) / Deleted: 0
- 폴더 전체 이관 + 마스터 `_README.md §2` 공통 packages 동반

### 이번 turn 직접 변경 (필수)
- `components/SalesFuturePriceFlexGrid.tsx` — v4 viewport sticky merge + LOC editable + 헤더 16px
- `SalesFuturePrice.module.scss` — `.wj-colheaders .wj-row { height: 16px !important; }`

### ⚠️ 의존 공통 컴포넌트 (마스터 `_README.md §2.B` 필수 동반 이관)
- `features/master/src/components/columnSettingModal/ColumnSettingModal.tsx` — **`initialVisibleKeys` prop 추가됨** (클라우드 누락 시 type-check L356 error)

## DB 적용 순서 (SCM_MGR 계정 — sub 폴더 순차 실행)

| # | Sub 폴더 | 내용 |
|---:|---|---|
| 1 | `01_GRANT_SYNONYM/` | GRANT + SYNONYM |
| 2 | `02_MNU_M/` | SCM_ADM_MNU_M 메뉴 등록 |
| 3 | `03_BTN_AUTH/` | SCM_ADM_BTN_* 버튼 권한 |
| 4 | `04_SHEET_COLUMNS/` | SCM_ADM_SHEET_COLUMNS + Dynamic Property |
| 5 | `05_PROC_M/` | SCM_ADM_PROC_M SP 매핑 |
| 6 | `06_SP_BODY/` | (이번 turn 변경 없음 — 기존 SP body 그대로 유지) |
| 7 | `07_I18N/` | i18n MSG 3 언어 |
| 8 | `08_VERIFY/` | 검증 SELECT |
| 9 | `09_GTT_STATS/` ⭐ | **patch_B — 14 GTT `GLOBAL_TEMP_TABLE_STATS = SESSION`** (이번 turn 핵심) |

## 09_GTT_STATS 핵심 적용

```sql
-- 09_GTT_STATS/_apply_patch_B.sql (SCM_MGR 30초)
BEGIN
    FOR R IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'GT_FTPR_%') LOOP
        BEGIN
            DBMS_STATS.SET_TABLE_PREFS(USER, R.TABLE_NAME, 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
END;
/
```

**효과**: 14 GT_FTPR_* GTT 의 옵티마이저 plan 이 실제 row 기반 (default cardinality 회피).
**결과 정합**: 100% 보장 (SP body 무변경).
**측정 baseline** (dev/local): 31.6초 (DIV=81, 28일, 3회 평균).

## 검증
- 화면 진입 → 헤더 정합 (3단 × 16 = 48px) + 정적 col sticky merge + LOC measure row 만 동적 col 편집
- elapsed 체감 ≤ 31.6초
- `08_VERIFY/` + `09_GTT_STATS/_verify.sql` (`ALL_TAB_STAT_PREFS` 14 row 모두 `SESSION`)
