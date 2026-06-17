# DMF0020 v4 — 클라우드 이관 패키지 (2026-06-16)

## 변경 요지

이번 이관의 핵심 변경은 **메인 그리드 동적 컬럼 분리 로직** 1건. 그 외 시각적 시도 (세로 머지 sticky 효과) 는 모두 정리 + 폐기.

### v3_full → v4 차이점

| # | 영역 | 파일 | 변경 |
|---:|---|---|---|
| 1 | FE | `SalesFuturePriceFlexGrid.tsx` (`dynBindings` useMemo) | **6월 W27 + 7월 W27 분리** — 한 주가 두 달에 걸친 경우 (예: 2026-06-29 월 ~ 2026-07-05 일) 동적 컬럼을 두 컬럼으로 분리. 월요일 (주 시작일) ∪ 월 변경 첫 날 (dd === 1) 모두 컬럼화. 기존 머지 로직 (`p.ym === dyn.ym`) 이 자동 분리. |
| 2 | FE | `SalesFuturePriceFlexGrid.tsx` | sticky 시도 (translateY / overlay / RAF / mergeManager stickyStart / 진단 console) 모두 폐기. 세로 머지 표준 동작만 유지. |

> **클라우드 사내 환경에서 기능적 변화**: 메인 그리드 헤더 1단 (YYYY-MM) / 2단 (Wxx) 이 월 경계에서 자동 분리됨. 데이터 단위가 일별 (W_yyyymmdd) 이면 자연스럽게 분리 표시. 주 단위 (월요일에만 PRICE 채움) 라면 새 컬럼 (예: W_20260701) 은 빈 셀.

## 폴더 구조

```
DMF0020_v4_20260616_w27_split/
├─ 00_README.md                            (이 파일)
├─ 01_FE/
│  ├─ sales-future-price/                  (DMF0020 화면 폴더 전체 — 현 상태 스냅샷)
│  │   ├─ SalesFuturePrice.tsx
│  │   ├─ SalesFuturePriceFlexGrid.tsx    ⭐ 핵심 변경 (단, components/ 안 파일이 정본)
│  │   ├─ SalesFuturePrice.module.scss
│  │   ├─ sales-future-price.constants.ts
│  │   ├─ sales-future-price.types.ts
│  │   ├─ useSalesFuturePriceStore.ts
│  │   ├─ index.ts
│  │   ├─ __asis-mapping__.md
│  │   ├─ components/
│  │   │   ├─ SalesFuturePriceFlexGrid.tsx ⭐ 핵심 변경 (dynBindings — 6월/7월 W27 분리)
│  │   │   ├─ SalesFuturePriceForm.tsx
│  │   │   └─ modals/  (Exchange / Batch / Version / TitleSet / Range / Template 6 modal)
│  │   ├─ hooks/  (Expression / Validation)
│  │   └─ utils/  (futurePriceDate / longToPivot / wideToLong)
│  └─ locales/                             ⭐ 다국어 i18n
│      ├─ KO.json / EN.json / CN.json     (현 FE 통합 i18n 전체 — 참고용 / 통째 덮어쓰기 금지)
│      └─ {KO,EN,CN}.DMF0020_PATCH.json   ⭐ DMF0020 전용 15 키만 추출 — 클라우드 통합 파일에 merge
└─ 03_META/
   ├─ 02_SHEET_COLUMNS_main.sql           ⭐ Column 메타 (15 cols) — DMF0020 main 시트 동적 컬럼 정의
   └─ 03_SHEET_MEASURE.sql                 ⭐ Measure 메타 (4 row: RTF / KRW / USD / LOC)
```

## 적용 순서 (클라우드)

> **사전 조건**: DMF0020 v3_full 이미 사내 적용된 상태 가정. BE / SP / MNU / API_M / PROC_M / USER_GR_BTN / i18n / CMBO_SQL 메타는 변경 없음 (v3_full 그대로 유지).

### Step 1: META 적용 (변경 없으면 skip 가능)

`03_META/02_SHEET_COLUMNS_main.sql`, `03_META/03_SHEET_MEASURE.sql` 의 SHEET_COLUMNS / SHEET_MEASURE 가 v3_full 과 동일하면 재실행 불필요. 검증만:

```sql
SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0020' AND SHEET_NAME='main';  -- 기대 15
SELECT COUNT(*) FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0020' AND SHEET_NAME='main';  -- 기대 4
```

차이가 있으면 `02_SHEET_COLUMNS_main.sql` 재실행 (DELETE + INSERT 멱등 패턴).

### Step 2: FE 적용

1. `01_FE/sales-future-price/` 폴더 전체를 클라우드 FE workspace 의 다음 위치에 덮어쓰기:
   ```
   nscm-fe/features/master/src/pages/sales-future-price/
   ```
2. 빌드 / type-check / lint 통과 확인 (변경 파일 1개라 영향 범위 최소)
3. 브라우저에서 DMF0020 진입 → 데이터 조회 → 헤더 1단 (YYYY-MM) 이 월 경계에서 분리되는지 확인

### Step 2.5: 다국어 i18n 적용 ⭐

> **⚠ 통째 덮어쓰기 금지** — `01_FE/locales/{KO,EN,CN}.json` 은 현 PC 작업 환경의 **통합 i18n** 스냅샷 (475/457/450 라인). 다른 화면 키도 모두 포함되어 있어 클라우드와 차이가 있을 수 있음. 그대로 덮어쓰면 다른 화면 i18n 키 손실 위험.

**권장 적용 방식 — PATCH JSON merge**:

`01_FE/locales/{KO,EN,CN}.DMF0020_PATCH.json` 에 DMF0020 전용 15 키만 추출되어 있음 (예: `MNU_DMF0020`, `LBL_DMF0020_BATCH_JOB`, `MSG_API_DMF0020_MAIN_SAVE` 등). 클라우드 통합 i18n 에 다음 방식으로 merge:

- **jq merge** (Linux/WSL/Git Bash):
  ```bash
  for L in KO EN CN; do
    jq -s '.[0] * .[1]' /path/to/cloud/locales/${L}.json ${L}.DMF0020_PATCH.json > tmp.json
    mv tmp.json /path/to/cloud/locales/${L}.json
  done
  ```
- **PowerShell merge** (Windows):
  ```powershell
  foreach ($l in 'KO','EN','CN') {
    $base = Get-Content "<cloud>/locales/$l.json" -Raw | ConvertFrom-Json
    $patch = Get-Content "$l.DMF0020_PATCH.json" -Raw | ConvertFrom-Json
    foreach ($p in $patch.PSObject.Properties) { $base | Add-Member -Force NoteProperty $p.Name $p.Value }
    $base | ConvertTo-Json -Depth 5 | Out-File "<cloud>/locales/$l.json" -Encoding utf8NoBOM
  }
  ```
- **수동**: 통합 KO.json 을 텍스트 편집기로 열고 `*DMF0020*` 검색, 해당 15 키들을 PATCH 값과 비교/추가

> KO=EN 정책: KO 값과 EN 값이 동일 (Korean Localization 가이드라인). CN 만 일부 미적용.

### Step 3: 검증

| 검증 항목 | 기대 결과 |
|---|---|
| 메인 그리드 조회 후 동적 컬럼 헤더 | 1단 (YYYY-MM) 머지가 월 단위로 분리 — 한 주가 두 달에 걸치면 두 그룹 |
| W27 컬럼 (2026-06-29 시작) | "2026-06 / W27 / 0629" + "2026-07 / W27 / 0701" 두 컬럼 |
| 세로 머지 (좌측 Division / Team / 등) | 같은 그룹 row 들 표준 머지 그대로 |
| sticky 효과 | **없음** (의도적으로 제거 — wijmo virtual scroll 환경 제약) |

## 의존성 (변경 없음)

이번 패키지는 v3_full 기반 incremental. 다음은 v3_full 의 것을 그대로 사용:

- BE: nscm-be 의 DMF0020 Controller / Service / MyBatis XML (없음 — 표준 dynamic SP 호출 path 사용)
- SP: `DMF0020_GET_SCM_MST_FUTURE_PRICE` + `DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` + `DMF0073_GET_VERSION_SALESPRICE`
- 메타: MNU_M / MNU_BTN_MPG_M / API_M / PROC_M / USER_GR_BTN / i18n (KO/EN/CN) / CMBO_SQL_M (BizType / FcstType / CustomsHandbook 신규 등록 v3_full 에서 처리)

## 롤백 (필요 시)

FE 1개 파일 (`SalesFuturePriceFlexGrid.tsx`) 만 v3_full 버전으로 복원하면 즉시 롤백.

```bash
cp <v3_full_path>/01_FE/sales-future-price/components/SalesFuturePriceFlexGrid.tsx \
   <cloud_FE>/nscm-fe/features/master/src/pages/sales-future-price/components/
```

META 는 변경 없으므로 롤백 불필요.

## 작성자 / 일자

- 작성: 2026-06-16
- 변경 사용자 요청: "대상년월별 주차 추출 시 대상년월이 다르면 동일 주차라도 별도 컬럼으로 분리"
