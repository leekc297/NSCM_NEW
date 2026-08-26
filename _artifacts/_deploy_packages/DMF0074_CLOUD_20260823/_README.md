# DMF0074 (Metal Link Price) 클라우드 이관 — 전 축 취합 (2026-08-23)

> **상태: 취합 완료 / 클라우드 미적용.** 사내 기준 2026-08-23 (PKG BODY VALID, LAST_DDL 08-23 13:30).
> 축 도출 = `_artifacts/_tools/make_cloud_package_full.py --menu DMF0074` (기계 전수 스윕) + 사내 실측 대조.
> 원자료 = `_survey/collect_report.json` · BODY delta = `_survey/delta_vs_DMF0074_CLOUD_20260819.diff`.
> ⚠ 선행 3본(`DMF0074_CLOUD_20260818` / `_20260819` / `_20260820`)은 **본 패키지에 흡수**되었다.

## 1. 이관 대상 (기계 스윕 + 사내 실측)

| 축 | 대상 | 실측 | 파일 | 방식 |
|---|---|---:|---|---|
| GTT | `GT_DM74_*` 17종 | 17 | `A_DB/00_GTT_DDL.sql` | 기존재 skip · 멱등 (DBMS_METADATA 원문) |
| DB 객체 | `PKG_DMF0074` SPEC | 51줄 | `A_DB/01_PKG_DMF0074_SPEC.sql` | 전체 교체 |
| DB 객체 | `PKG_DMF0074` BODY | 3,980줄 | `A_DB/02_PKG_DMF0074_BODY.sql` | 전체 교체 |
| 시퀀스 | `DM_BPS_METAL_LINK_PRICE_H.HISTORY_SEQ` | — | `A_DB/05_FIX_HISTORY_SEQ_RESEED.sql` | 재시드 (**PRECHECK C5 로 필요 여부 판단**) |
| 메타 | `SCM_MST_SHEET_COLUMNS` | 58행 (1시트) | `A_DB/10_SHEET_COLUMNS.sql` | 시트 단위 삭제 후 재적재 (hook #98 §9) |
| 메타 | `SCM_ADM_EXCEL_COLUMNS` | **2행** ⭐ | `A_DB/12_EXCEL_COLUMNS.sql` | 패밀리 범위 삭제 후 재적재 |
| 배선 | `PROGRAM` 1 · `MNU_M` 1 · `API_M` 8 · `PROC_M` 24 · `BTN_MPG` **9** | 43행 | `A_DB/20_WIRING_AUTH.sql` | MERGE (PK 실측) |
| 권한 | `USER_GR_MNU` 3 · `USER_GR_BTN` **24** | 27행 | `A_DB/20_WIRING_AUTH.sql` | MERGE ⚠ 그룹 실존 확인 |
| MSG/LBL/MNU | 소비 코드 → `SCM_ADM_MSG_M` | 69행 | `A_DB/30_MSG_LBL_MNU.sql` | **INSERT-only (NOT EXISTS)** — `MSG01015` 포함 |
| FE | 재판정 후 **7** (+ 병합 4) | **7** | `B_FE/**` | 경로 그대로 (§FE 이관 경로 상세) |

⭐ **`DMF0074_40` 을 놓치지 말 것.** `SCM_ADM_EXCEL_COLUMNS`(1) · `MNU_BTN_MPG_M`(1, UPLOAD) ·
`USER_GR_MNU_BTN_MPG_M`(2) 에 **division 40 전용 배선**이 별도 PROGRAM_ID/MNU_ID 로 존재한다.
`PROGRAM_ID='DMF0074'` 로만 뜨면 4행이 조용히 빠지고 **40 사용자의 Excel Upload 만 실패**한다.
(이번에 생성기 스코프를 `MENU` + `MENU_%` 패밀리로 고쳤다 — 종전 산출물은 이 4행이 없었다.)

## 2. 담긴 정정 (BODY)

직전 패키지 `DMF0074_CLOUD_20260819` 대비 **BODY delta = +0행**. 즉 08-19 이후 PKG 본문 변경은 없다.
(08-23 의 `LAST_DDL` 은 재컴파일 흔적이며 본문 텍스트는 동일하다 — diff 로 확인.)
따라서 본 패키지의 값은 **BODY 가 아니라 ①`DMF0074_40` 4행 ②GTT 자급 DDL ③FE 필수 3본** 에 있다.

계보상 이미 반영되어 있는 정정: `''=NULL` 결함 5건(2026-08-16) · Excel Form/Upload 2-Step 검증 ·
`MSG01015` 신규 채번(2026-08-20, 구 MSG00656 오지시 교체).

## 3. 이관 제외 (스윕에는 잡혔으나 대상 아님 — 사유 명시)

| 대상 | 실측 | 사유 |
|---|---:|---|
| `SCM_ADM_EXCEL_UPLOAD` | 1,024행 | 엑셀 업로드 **스테이징 실행 데이터** (메타 아님) |
| `SCM_ADM_USER_MNU_SRCH_COND_M` | 4행 | **사용자별 조회조건 개인화** — 환경별 사용자 상이 |
| `SCM_MST_SHEET_COLUMNS_0408` / `_260408` | 58 / 58 | **백업 테이블** (이름만 걸린 것) |
| 단독 SP 6본 (`DMF0074_EXCEL_UPLOAD` / `_KJJ_TEST` / `_TEST2` / `DMF0074_GET_METAL_LINK_PRICE` / `DMF0074_GET_METAL_LINK_TEMPLATE` / `P_DMF0074_GET_METAL_LINK_PRICE`) | — | 사내에서도 **INVALID** 인 폐기 잔재. 배선은 전부 `PKG_DMF0074.*` 를 가리킨다 |
| `BAK_DMF0074_SPC_W34_20260823` | 1표 | 오늘 사내 데이터 정정의 **백업 테이블** |
| `SCM_MST_SHEET_MEASURE` · `LOOKUP_MASTER_DETAIL` | 0행 | DMF0074 해당 행 없음 |
| FE 공용 (폐포 밖) | — | 화면이 닿지 않는 공용 변경분은 제외. **닿는 91본은 동봉**한다 — 배럴 재수출·신규 심볼 때문에 빼면 클라우드 빌드가 선다는 보장이 없다(§FE 이관 경로 상세) |
| `public/locales/*.json` · `configs/types/procedures.d.ts` | — | 기준선과 **동일**(변경 0) |

<!-- FE-PATHMAP -->
## FE 이관 경로 상세 — **최신 공통소스 기준 재판정본 (2026-08-24)**

> 배포 루트 = `nscm-fe`. `B_FE/` 아래 경로가 곧 배포 경로다.
> 최신 공통소스(`common` HEAD `badd49a0`)와 71본을 전수 대조했다.

| 판정 | 본수 | 처리 |
|---|---:|---|
| 공통 최신과 **바이트 동일** | **60** | 이관 불필요 — 제외 |
| 우리 것이 공통보다 앞섬 / 신규 | **7** | `B_FE/` — 그대로 덮는다 |
| 공통에만 있는 코드 보유 | **4** | `B_FE_MERGE/` — ⛔ 병합 |

화면 폴더 13본 중 이관 대상은 **2본**(`MetalLinkTemplateModal.tsx`, `metal-link-price.constants.ts`)뿐이다.
이 둘은 **우리가 앞선다** — 공통은 아직 `MSG00656` 을 쓰고 우리는 `MSG01015` 로 재채번했다(2026-08-20).
나머지 11본은 이미 공통에 반영돼 있다.

### ① 화면 폴더 — **폴더 통째** (`index.ts` 가 viewRegistry 등록 키)

| 패키지 내 위치 | **이관 대상 경로 (배포 루트 기준)** | 파일 | 파일명 |
|---|---|---:|---|
| `B_FE/features/demand/src/pages/metal-link-price` | **`nscm-fe/features/demand/src/pages/metal-link-price`** | 1 | `metal-link-price.constants.ts` |
| `B_FE/features/demand/src/pages/metal-link-price/components/modals` | **`nscm-fe/features/demand/src/pages/metal-link-price/components/modals`** | 1 | `MetalLinkTemplateModal.tsx` |

### ② 공용 — 화면이 실제로 닿는 **변경분 폐포**(기계 산출). 미변경 공용은 클라우드 것을 그대로 둔다

| 패키지 내 위치 | **이관 대상 경로 (배포 루트 기준)** | 파일 | 파일명 |
|---|---|---:|---|
| `B_FE/packages/foundation/src/utils` | **`nscm-fe/packages/foundation/src/utils`** | 1 | `string.ts` |
| `B_FE/packages/shared/src/components/organisms` | **`nscm-fe/packages/shared/src/components/organisms`** | 1 | `index.ts` |
| `B_FE/packages/shared/src/components/organisms/olap-pivot-grid` | **`nscm-fe/packages/shared/src/components/organisms/olap-pivot-grid`** | 2 | `OlapPivotGrid.tsx`, `olapUtils.ts` |
| `B_FE/packages/shared/src/components/templates/modals/column-layout-modal` | **`nscm-fe/packages/shared/src/components/templates/modals/column-layout-modal`** | 1 | `columnLayoutModal.utils.ts` |


> `B_FE_MERGE/` 4본은 `*.COMMON.txt`(공통 최신 원본)를 함께 넣었다. 절차 = `B_FE_MERGE/_READ_FIRST.md`.


### 🔁 `B_FE_POOL/` — 클라우드가 뒤처졌을 때만 쓰는 예비분 (2026-08-24 신설)

**클라우드 트리는 사내와도, 공통소스와도 다르다.** 실사고 3연발이 그걸 증명했다.

| 방향 | 실사고 | 증상 |
|---|---|---|
| 클라우드가 **앞섬** | `CascadeFields` / `useCascadeFields` (클라우드에만) | 우리 것으로 덮어 **TS2305** ×2 |
| 클라우드가 **뒤처짐** | `CELL_CONTROL_TYPE.TEXT_MODAL` (공통엔 있는데 클라우드엔 없음) | **TS2339** |

그래서 "무엇을 올릴지"는 사내에서 다 정할 수 없다 — **클라우드에서 판정해야** 한 번에 끝난다.

- `B_FE/` … 반드시 덮는다 (우리가 앞서거나 클라우드에 없는 신규)
- `B_FE_POOL/` … 사내 = 공통소스가 **완전히 같은** 파일들. 클라우드가 최신이면 **아무것도 안 올린다**
- `B_FE_MERGE/` … ⛔ 덮기 금지, 병합

```
# 배포 루트(nscm-fe) 에서
node <이 폴더>/_cloud_gap_check.mjs <이 폴더>/B_FE_POOL           # 진단만 (SAME / STALE / MISSING)
node <이 폴더>/_cloud_gap_check.mjs <이 폴더>/B_FE_POOL --apply   # 다른 것만 실제 복사
```

`STALE`/`MISSING` 로 잡힌 것만 최신화되므로 클라우드 고유 작업을 덮지 않는다.
이번 `TEXT_MODAL`(TS2339) 도 `packages/foundation/src/constants/column-config.ts` 가
`STALE` 로 잡혀 한 번에 해소된다.

**권장 순서**: ① `_precopy_export_guard.mjs` → ② `B_FE/` 덮기 → ③ `_cloud_gap_check.mjs --apply`
→ ④ `B_FE_MERGE/` 병합 → ⑤ `pnpm exec turbo run type-check --continue`

<!-- /FE-PATHMAP -->

## FE 검증 (이관 취합의 일부 — 2026-08-23)

넥서스 미접속 로컬 검증(`_artifacts/_tools/fe-check.ps1`, 고정 pnpm 10.28.2)을 **패키지 취합 시점에** 돌렸다.

| 항목 | 결과 |
|---|---|
| `type-check` | **13/13 성공 · error 0** |
| `lint` | **13/13 성공 · error 0** (warning 193 — `import/no-relative-parent-imports` 등 기존분) |

원문 = `_survey/fe_check_20260823.txt`.
⚠ 이 검증은 **우리 작업 트리 기준**이다. 클라우드는 공용 세대가 달라, 위 §FE 이관 경로의 공용 폐포를 **함께** 올린 뒤
클라우드에서 `type-check` 를 한 번 더 돌려야 한다(TS2305/TS2322 는 그때만 드러난다).


## 4. 적용 순서

1. `00_CLOUD_PRECHECK.sql` (QA·DEV 각각) — **C3 가 `DMF0074_40` 판별**, C5 가 시퀀스, C6 가 Excel Form 0건 축
2. `A_DB/00_GTT_DDL.sql` (C2 에 MISSING 이 있을 때만 실질 동작 — 멱등)
3. `A_DB/01_PKG_DMF0074_SPEC.sql` → `A_DB/02_PKG_DMF0074_BODY.sql`
4. `A_DB/05_FIX_HISTORY_SEQ_RESEED.sql` (**C5 가 `SEQ_LAST_NUMBER <= MAX_SEQ` 일 때만**)
5. `A_DB/10_SHEET_COLUMNS.sql` → `12_EXCEL_COLUMNS.sql` → `20_WIRING_AUTH.sql` → `30_MSG_LBL_MNU.sql`
6. `B_FE/**` 배포 → `pnpm type-check` (⭐ `cascade` prop 오류가 사라져야 한다)
7. `A_DB/90_VERIFY.sql` → 화면 스모크 V7 (S1~S5, **S5 = division 40 계정**)

진단 전용(적용 아님): `91_DIAG_TEMPLATE_EMPTY` / `92_DIAG_CLOUD_MRFPARITY` /
`93_DIAG_CLOUD_TEMPLATE_FUNNEL` / `94_DIAG_CLOUD_SPW_LEDGER` · 조치안 `95_FIX_CLOUD_EMPTY_SPW_VERSION`.

## 5. 미해결 — 적용해도 남는 것

- ⛔ **주간 `SP_W_*` 버전이 원장(`DM_PLN_SALES_PLAN_C`)을 적재하지 않는 근본원인은 미해결.**
  사내 2026-08-23 실측: `SP_W_20260820_V002`(W34) div 40 = 0행 → 원장 28,085행을 그 버전으로 **재지정**해
  Excel Form 을 살렸다(대증요법, 백업 `BAK_DMF0074_SPC_W34_20260823`). **나머지 division 은 미정정** —
  같은 실측에서 `SP_W_20260821_V001` 의 81 / 81_UC / 81_ST / 81_HG / 81_HD / 81_HM / 82 가 **전부 0행**이다.
  클라우드도 같은 배치를 쓰면 동일 증상이 난다 → `94` 로 확인, `95` 로 임시 조치.
- FE 공용 세대차 59본은 미해결 상태로 남는다(범위 밖). DMF0074 는 기준선 공용으로 동작하되,
  `searchFields` 3본만은 **필수**다(없으면 type-check 가 막는다).
- 사내 데이터 정정(`_apply_corporate/DMF0074_W34_VERSION_ALIGN_20260823/`)은 **사내 전용**이며 이관하지 않는다.
