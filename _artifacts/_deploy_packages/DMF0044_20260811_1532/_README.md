# DMF0044 — 클라우드 이관 패키지 (20260811_1532)

> 생성: `_artifacts/_diagnostics/build_cloud_packages_20260811.py` — **사내 Oracle live 실측 스냅샷**.
> ⚠️ 클라우드 DB 는 **QA·DEV 2DB 동시 적용** 의무 (feedback_cloud_be_build_out_of_sync_diagnosis §0).

## 0. 이 패키지가 담은 것 (실측 건수)

| 구분 | 파일 | 건수 |
|---|---|---:|
| GTT 자급 DDL | `01_GTT_DDL.sql` | 19 |
| PACKAGE SPEC | `02_PKG_SPEC.sql` | 1 |
| PACKAGE BODY | `03_PKG_BODY.sql` | 1 |
| 배선 메타 (MNU/API/BTN/PROC) | `10_META_WIRING.sql` | API 28 / BTN 28 / PROC 180 |
| ⭐ **UI Category Setup** | `11_META_SHEET_COLUMNS.sql` | 62 (**MERGE INTO**) |
| Measure 메타 | `12_META_SHEET_MEASURE.sql` | 18 (MERGE INTO) |
| ⭐ **화면 사용 COMBO 전수** | `13_META_CMBO_SQL.sql` | **27종** (MERGE INTO) |
| MSG/LBL | `14_META_MSG_LBL.sql` | 31코드 / 75행 |
| 권한 (메뉴/버튼) | `15_META_AUTH.sql` | 메뉴 3 / 버튼 75 |
| i18n 런타임 원천 | `locales_PATCH.json` | FE `public/locales` 병합용 |
| FE 소스 | `fe/` | 화면 폴더 + 공용 `versionModal` |
| 검증 | `90_VERIFY.sql` | 10항목 |

### COMBO 27종 (사용자 요청 — "UI 에 사용을 위하여 추가한 COMBO 가 모두")
수집 근거 = **셀 콤보(`SHEET_COLUMNS.CELL_COMBO_DATA_TYPE`) ∪ FE 소스 참조**(조회조건·행별 콤보·모달).
등록만 가고 배선이 빠지면 화면은 **조용히 빈 콤보**가 되므로 `11_META_SHEET_COLUMNS.sql` 과 **반드시 함께** 적용한다.

```
APPLICATION
CALENDAR_YYYY
COUNTRY_MST
CUST_GROUP_DTL
CurrencyList
DMF0005_REPORT_GROUP1
DMF0005_REPORT_GROUP2
DMF0005_REPORT_GROUP3
DMF0005_REPORT_GROUP4
DMF0005_REPORT_GROUP6
DMF0044_DEPARTMENT_TEAM
DMF0044_DEPARTMENT_TEAM2
DMF0044_ETC_SALE_RESULT_TYPE_40
DMF0044_MDF_DEPARTMENT
DMF0044_MDF_MEASURE
DM_COMPANY
DM_LOOKUP_DIV
Division
DmBizType
END_CUST_REPORT
FcstType
MDF_TYPE
MDF_TYPE2
MDF_TYPE_BP_POPUP
MDF_TYPE_SP_POPUP
Measure
SOLD_TO_CUST_REPORT
```

## 1. 적용 순서 (SCM_MGR 계정)

| 순서 | 파일 | 비고 |
|---:|---|---|
| 0 | (클라우드 BE 정지) | library cache pin 방지. `ALTER SESSION SET DDL_LOCK_TIMEOUT=120` |
| 1 | `01_GTT_DDL.sql` | 미존재 시에만 생성(멱등) |
| 2 | `02_PKG_SPEC.sql` | |
| 3 | `03_PKG_BODY.sql` | ⚠ SPEC 먼저 |
| 4 | `10_META_WIRING.sql` | |
| 5 | `11_META_SHEET_COLUMNS.sql` | ⭐ **MERGE — 값 갱신 반영** |
| 6 | `12_META_SHEET_MEASURE.sql` | |
| 7 | `13_META_CMBO_SQL.sql` | ⭐ COMBO |
| 8 | `14_META_MSG_LBL.sql` | |
| 9 | `15_META_AUTH.sql` | 가드 INSERT (기존 권한 불변) |
| 10 | (클라우드 BE 재기동) | |
| 11 | `90_VERIFY.sql` | 전 항목 PASS 확인 |

## 2. FE 동시 이관 (DB 만 가면 LBL fallback / 팝업 미동작)

> 원칙: **파일 단위 덮어쓰기 금지 — 폴더 전체 checkout** (feedback_cloud_shell_generation_mismatch).

1. `fe/sales-reports/` → `nscm-fe/features/demand/src/pages/sales-reports/`
2. `fe/components/` → `nscm-fe/features/demand/src/components/` **폴더 전체 교체**
   ⛔ 사고 이력(2026-08-11 클라우드 실증): versionModal/ 만 복사하면
   `The requested module '.../components/index.ts' does not provide an export named 'VersionModal'`
   — 화면이 **barrel(index.ts)** 경유로 import 하는데 구본 barrel 에 export 줄이 없다.
   barrel 은 fcst-upload-modal 도 export 하므로 index.ts 단독 교체도 금물 — **폴더 전체**가 단위다.
2-1. **외부 의존 검증(클라우드 셸)** — 두 화면은 `features/master/src/components` 의 5개 export 를 쓴다:
   `ColumnLayoutModal / ItemByDivisionModal / ProjectByDivisionModal / DivisionField / VersionField`
   `grep -c "ColumnLayoutModal\|ItemByDivisionModal\|ProjectByDivisionModal\|DivisionField\|VersionField" features/master/src/components/index.ts`
   가 5 미만이면 master components 도 구본 — `features/master/src/components/` 폴더 전체 checkout 후 진행.
   (⚠ DMF0049 의 ProjectByDivisionModal 은 2026-07-22 'etc' 1줄 확장본이어야 한다 — `etc` grep 로 확인)
3. `locales_PATCH.json` 의 KO/EN/CN 을 `nscm-fe/public/locales/{KO,EN,CN}.json` 에 **부분 병합**
   (들여쓰기·키 순서 보존 — 전체 재포맷 금지)
4. `fe/configs/types/procedures.d.ts` → `nscm-fe/configs/types/procedures.d.ts` **전체 교체** — DMF0044/0049 블록 포함본. 누락 시 tsc 실패
   (viewRegistry/Router 는 이관 불요 — glob 자동 수집 + DB ROUTE_PATH 가 10_META_WIRING 에 포함)
5. 클라우드 셸에서 `tsc --noEmit` 0 + `eslint` 0

⚠️ **locales 미등록 코드 3건**: LBL00513, LBL00764, LBL00765
   → 이 코드는 DB·locales 어디에도 없어 화면에 fallback 문자열이 그대로 뜬다. **신규 채번 필요**
     (임의 생성 금지 — 채번 후 DB 3언어 + locales 3파일 + 본 PATCH 3점 동시 반영. hook #114 §5)

## 3. MERGE 채택 사유 (2026-08-11 사용자 지시)

UI Category Setup 은 **값 갱신**(예: `INPUT_TP_CD`, `VISIBLE_FLAG`)이 목적이라 INSERT-only 로는 반영되지 않는다.
따라서 `MERGE INTO ... WHEN MATCHED THEN UPDATE / WHEN NOT MATCHED THEN INSERT` 를 쓴다.
⭐ **DELETE 절은 없다** — 클라우드에만 있는 행이 지워지지 않는다(2026-08-07 "시트 메타 MERGE 금지" 는
DELETE 동반 사고가 원인이었고, 본 패키지는 그 위험을 구조적으로 제거했다).

## 4. 적용 후 화면 검증

DB 검증(`90_VERIFY.sql`)은 **메타가 들어갔는지**만 본다. 화면 동작은 별도다 (hook #130):
- 조회 → 편집 매트릭스 → Insert 세트 → 저장 → 재조회 (값 반영 육안)
- 셀 콤보가 **명칭(NAME)** 으로 뜨는지 (코드로 뜨면 파라미터 미전달)
- Department/Team 컬럼이 **각 1개**만 보이는지
- 조회조건 라벨이 `_` 접두 fallback 없이 뜨는지

## 2-4. ⭐ 적용 잔여 확인 절차 (2026-08-11 3차 — 오류 대조로 판정. **여기부터 실행하면 된다**)

클라우드 재실행 결과(type-check 4오류 + lint 이전과 동일)는 **아래 2단계가 아직 미적용**이라는 뜻이다.
(`shared-hooks` 와 고아 삭제는 반영 확인됨 — WijmoRowItem·UnitedVersionModal 오류가 사라졌다.)

```bash
cd /c/Projects/NSCM/nscm-fe
PKG44=<DMF0044_20260811_1532 경로>
PKG49=<DMF0049_20260811_1532 경로>

# [1] master components 교체 — type-check 4오류(disabled/label)의 원인 전부
#     (기존 폴더를 먼저 지우고 복사할 것 — 복사-병합 금지)
rm -r features/master/src/components
cp -r "$PKG44/fe/master-components" features/master/src/components

# [2] demand 페이지·공용 — lint 정정판으로 재복사 (이전에 복사한 판은 정정 **전** 판이다)
rm -r features/demand/src/pages/sales-reports
rm -r features/demand/src/pages/etc-sales-reports
rm -r features/demand/src/pages/demand-manager
rm -r features/demand/src/components
cp -r "$PKG44/fe/sales-reports"     features/demand/src/pages/sales-reports
cp -r "$PKG49/fe/etc-sales-reports" features/demand/src/pages/etc-sales-reports
cp -r "$PKG44/fe/demand-manager"    features/demand/src/pages/demand-manager
cp -r "$PKG44/fe/components"        features/demand/src/components

pnpm run type-check && pnpm run lint
```

- ⚠ `demand-manager` 는 DMF0068 화면이지만 **lint 게이트가 리포 전체**라 정정판 17파일을 동봉했다.
- 적용 여부 빠른 판별: `grep -c disabled features/master/src/components/searchFields/SearchFields.tsx`
  → **0 이면 미적용(구본)**, 1 이상이면 적용됨.

## 2-5. ⛔ 환율 모달 Div/Currency/Unit 2중 표시 정정 (2026-08-11 클라우드 실증)

실행 파일: **`91_FIX_EXCHANGE_SHEET_DUP.sql`** (§1 진단 → §2 백업 → §3 정정 → §4 검증. QA·DEV 2DB).

- 원천: 모달 정적 컬럼 = `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID='DMF0044', SHEET_NAME='exchangeRate') —
  FE 는 응답을 그대로 렌더하므로(ExchangeRateModal.tsx L265~277, dedup 없음) **DB 행 2배 = 화면 2배**.
- 사내 정본 = 정확히 **4행**(DIVISION_ID/CURRENCY/UNIT_CURRENCY 표시 + CURRENCY_UNITCURRENCY 숨김).
  7월 패키지에는 이 시트가 없었다 — 클라우드의 여분 행은 그 사이 다른 표기(변형 키)로 생긴 것.
- 이 테이블은 **PK 가 없어** 완전 동일 키 물리 중복도 가능하다 — 이관 MERGE 는 그런 중복을 제거하지 못한다.
  스크립트가 두 계보(ROWID dedup + 변형 키 제거)를 모두 잡고, 정본 4행 부재 시엔 **아무것도 지우지 않는다**.
- §1 진단 출력은 보관 권장 — 여분 행의 정확한 표기(따옴표·LENGTH)가 남는다.

## 2-2. ⛔ 클라우드 type-check 오류 3계보 정정 절차 (2026-08-11 실증 — 8오류 전수 규명)

`pnpm run type-check` 에서 난 @demand 8오류는 전부 **클라우드 FE 세대 혼재**다. 로컬 demand tsc = 0.

| 계보 | 오류 | 원인 | 조치 |
|---|---|---|---|
| A. 고아 파일 | `UnitedVersionModal.tsx` TS2305 ×4 | 클라우드에만 있는 구본 파일(로컬 부재 — 공용 VersionModal 로 대체됨). **복사-병합**하면 남는다 | `rm features/demand/src/pages/sales-reports/components/modals/UnitedVersionModal.tsx` |
| B. master 구본 | `disabled`/`label` TS2322 ×3 | 클라우드 `SearchFields.tsx` 에 `DivisionFieldProps.disabled`·`VersionFieldProps.label/emptyText` 없음 | `fe/master-components/` → `features/master/src/components/` **폴더 전체 교체** |
| C. shared 구본 | `WijmoRowItem` 유니온 TS2322 ×1 | 클라우드 `useCustomQueryClient.ts`(useTabProcQuery) 반환 타입이 구세대 | `fe/shared-hooks/` → `packages/shared/src/hooks/` **폴더 전체 교체** |

⭐ **모든 폴더 교체는 "삭제 후 복사"다** (rm -rf → cp). 복사-병합은 A 계보를 재생산한다.
   교체 후 `etc-sales-reports`/`sales-reports` 에도 로컬에 없는 파일이 남았는지 대조:
   패키지 `fe/{페이지폴더}` 의 파일 목록과 클라우드 폴더를 diff — **패키지에 없는 파일 = 삭제 대상**.

⚠ B·C 는 **공용 코드**라 다른 화면도 영향받는다. 로컬 모노레포는 이 판으로 11패키지 type-check 전부
   통과하므로(사내 실측) 같은 세대로 맞추는 것이 정합이다. 클라우드 고유 수정이 있었다면 diff 선확인.
   근본 해법은 **git 동기화(사내 push → 클라우드 pull, 룰 28)** — 파일 단위 이관은 세대 혼재를 계속 만든다.
## 2-3. ⛔ 클라우드 lint 오류 정정 (2026-08-11 실증 2차)

`pnpm run lint` @demand 오류의 원인은 2종이다:
1. **고아 파일 — 양쪽 페이지 모두**: `UnitedVersionModal.tsx` 가 `sales-reports/components/modals/` 와
   `etc-sales-reports/components/modals/` **둘 다**에 남아 있다(로컬 부재 — 공용 VersionModal 로 대체됨).
   ⇒ 두 파일 모두 삭제. **폴더 교체는 반드시 "기존 폴더 삭제 → 패키지 폴더 복사" 순서** — 복사-병합이 고아를 만든다.
2. **사내 기준 잔존 lint 오류 21건** — 2026-08-11 사내에서 전량 정정 완료(import/order 16 자동 +
   no-base-to-string 5 수기 — unknown 값 String() 직행 금지, 타입 좁힘으로 교체).
   본 패키지 `fe/` 는 **정정 후 판**이다(0 errors / tsc 0 / 테스트 83 실측). 반드시 이 판으로 교체할 것.

⚠ 참고: 나머지 warning 들(admin/master/shared/web 등)은 **본 패키지 범위 밖의 리포 전반 기존 부채**로
   error 가 아니라 lint 를 막지 않는다 — 본 이관에서 손대지 않는다.