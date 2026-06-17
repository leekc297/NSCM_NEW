# UI 동적 속성관리 — 4 화면 일괄 이관 패키지 (2026-06-17)

## 변경 요지

사용자 명시 (2026-06-16): "DMF0043 / DMF0043_01 / DMF0008 / DMF0072 4 화면에 'UI 생성의 동적 속성관리' 통합 master hook 정형화 — 3 구성요소 (Menu Button / Column / Measure) 적용."

각 화면의 **Button (Visible/Enable)** + **Column (Visible/Width/Label/InputType 등)** 은 admin UI (SYS0009 Menu Button + SYS0004 UI Category Setup) 의 데이터를 기준으로 **동적 fetch + 즉시 반영**. 4 화면 모두 PIVOT/Measure 미사용 (N/A).

| 화면 | 변경 영역 |
|---|---|
| **DMF0008** (ErpEdiMaster) | `useTabBtnPermissions` 추가 — hotkeyConfig (SEARCH/SAVE/INSERT) + customButtons (STATUS_UPDATE) `hasButton(...)` 조건부. Column 동적 fetch 는 이미 적용 상태 유지. |
| **DMF0072** (NnMasterMapping) | Store `staticColumns` + `fetchStaticColumns` 신규 (v2 schema). `useTabBtnPermissions` (SEARCH/INSERT/SAVE/DELETE). `mergedColumns`/`visibleColumns` useMemo — admin 메타 (visible/width/label/inputType) override + `MAIN_COLUMNS` 상수 fallback. |
| **DMF0043_01** (ContributeView) | Store `staticColumns` + `fetchStaticColumns` 신규 (v2 schema). `useTabBtnPermissions` (SEARCH/COLUMN_SETUP). `ContributeViewGrid` 에 `staticColumns` prop 전달 + `baseColumns` (9 BASE) 메타 override (visible/width/label). 동적 컬럼 (region × commission/markup) 은 별도 (`MAIN_TITLE` SP 결과) 그대로. |
| **DMF0043** (ContributeMain) | Store `staticColumns` + `fetchStaticColumns` 신규 (v2 schema). `useTabBtnPermissions` (SEARCH/SAVE/VERSION_MGT). `ContributeMainGrid` 에 `staticColumns` prop 전달 + `baseColumns` (6 BASE) 메타 override. 동적 M#/Y# 컬럼은 별도 처리 그대로. |

## 폴더 구조

```
UI_dynamic_property_4screens_20260616/
├─ 00_README.md                                       (이 파일)
├─ 01_FE/
│  ├─ erp-edi-master/                                 ⭐ DMF0008 (18 files)
│  ├─ contribute-main/                                ⭐ DMF0043 (13 files)
│  ├─ contribute-view/                                ⭐ DMF0043_01 (17 files)
│  ├─ nn-master-mapping/                              ⭐ DMF0072 (7 files)
│  └─ locales/
│      ├─ {KO,EN,CN}.json                             현 FE 통합 i18n (475/457/450 라인) — 참고용
│      └─ {KO,EN,CN}.{DMF0008,DMF0043,DMF0043_01,DMF0072}_PATCH.json   ⭐ 화면별 i18n 키 추출 (각 MNU_DMF*)
└─ 03_META/
   └─ 00_Verify_SHEET_COLUMNS.sql                     ⭐ 4 화면 SCM_MST_SHEET_COLUMNS 등록 검증 SQL
```

## 적용 순서

> **사전 조건**: 4 화면 모두 사내 운영 중. BE / SP / API_M / PROC_M / MNU 메타는 변경 없음. 이 패키지는 **FE incremental + 메타 검증** 만.

### Step 1: DB 메타 사전 검증

`03_META/00_Verify_SHEET_COLUMNS.sql` 실행 — 4 화면의 `SCM_MST_SHEET_COLUMNS` 등록 row 수 확인.

```sql
SELECT PROGRAM_ID, SHEET_NAME, COUNT(*) AS COL_COUNT
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID IN ('DMF0008', 'DMF0043', 'DMF0043_01', 'DMF0072')
 GROUP BY PROGRAM_ID, SHEET_NAME
 ORDER BY PROGRAM_ID, SHEET_NAME;
```

기대값:
- DMF0008 / summary, repair, salesSite, sspm: 각 sheet ≥ 1
- DMF0043 / main: 6 (BASE) 이상
- DMF0043_01 (또는 DMF0043 + sheet ContributeSalesList): 9 BASE
- DMF0072 / main: 23

⚠ 누락 발견 시 admin SYS0004 UI Category Setup 에서 컬럼 등록 (또는 별도 INSERT SQL). 누락 상태로도 FE 는 BASE_COLUMNS 상수 fallback 으로 정상 동작 — admin 변경 무효화만 발생.

### Step 2: FE 적용

4 화면 폴더를 클라우드 FE workspace 의 해당 위치에 덮어쓰기:

```
nscm-fe/features/master/src/pages/
   ├─ erp-edi-master/              ← 01_FE/erp-edi-master/
   ├─ contribute-main/             ← 01_FE/contribute-main/
   ├─ contribute-view/             ← 01_FE/contribute-view/
   └─ nn-master-mapping/           ← 01_FE/nn-master-mapping/
```

### Step 3: 다국어 i18n PATCH ⭐

> **⚠ 통째 덮어쓰기 금지** — `01_FE/locales/{KO,EN,CN}.json` 은 현 PC 통합 i18n 스냅샷. 다른 화면 키 모두 포함되어 클라우드와 차이 있음.

**권장 — PATCH JSON merge**: 4 화면 PATCH (각 `MNU_DMF{ID}` 키) 를 클라우드 통합 i18n 에 merge.

```powershell
foreach ($l in 'KO','EN','CN') {
  $base = Get-Content "<cloud>/locales/$l.json" -Raw | ConvertFrom-Json
  foreach ($menu in 'DMF0008','DMF0043','DMF0043_01','DMF0072') {
    $patch = Get-Content "$l.${menu}_PATCH.json" -Raw | ConvertFrom-Json
    foreach ($p in $patch.PSObject.Properties) { $base | Add-Member -Force NoteProperty $p.Name $p.Value }
  }
  $base | ConvertTo-Json -Depth 5 | Out-File "<cloud>/locales/$l.json" -Encoding utf8NoBOM
}
```

> 각 화면 i18n 키 매우 적음 (MNU_DMF* 1개씩). 화면 내부 라벨은 generic LBL00### + SHEET_COLUMNS.COLUMN_LABEL_NAME (admin) 의존.

### Step 4: 검증 (브라우저)

| 검증 항목 | 기대 결과 |
|---|---|
| 4 화면 진입 시 Network 탭 `/admin/menu/{MENU_ID}/column` 응답 | 200 OK + column 메타 배열 (DMF0008 은 4 sheet 각각) |
| 4 화면 진입 시 Network 탭 `/admin/menu/{MENU_ID}/auth` 응답 | 200 OK + `mnuBtnAuth` 배열 (Button code list) |
| Button 활성 상태 | `mnuBtnAuth` 에 있는 button code 만 클릭 가능 (admin USE_YN 즉시 반영) |
| Column visible/width/label | admin SYS0004 UI Category Setup 변경 → 화면 재진입 시 즉시 반영 |

## 의존성 (변경 없음)

- BE: nscm-be 의 4 화면 Controller / Service / MyBatis (변경 없음 — 기존 `/admin/menu/{mnuId}/column` + `/auth` endpoint 사용)
- SP: 4 화면 main SP (변경 없음)
- 메타: MNU_M / API_M / PROC_M / USER_GR_BTN / CMBO_SQL_M (변경 없음)

## 롤백 (필요 시)

각 화면 FE 폴더만 이전 버전으로 복원. Store storageName 이 `-v2` suffix 라 sessionStorage stale 자동 무시 (롤백 시에도 안전).

```bash
# DMF0072 예시
git checkout HEAD~1 -- nscm-fe/features/master/src/pages/nn-master-mapping/
```

DB 메타 변경 없음 — 롤백 불필요.

## 작성자 / 일자

- 작성: 2026-06-17
- 변경 사용자 요청 (2026-06-16): "UI 생성의 동적 속성관리 통합 master hook 으로 정형화 + 3 구성요소 (Menu Button / Column / Measure)" 4 화면 일괄 적용
- 룰 적용 hook: `Doc/_rules_v2/hooks/ui-dynamic-property-management.md` (master) + `menu-button-dynamic-fetch.md` (child) + `ui-category-setup-column-meta.md` (child)
