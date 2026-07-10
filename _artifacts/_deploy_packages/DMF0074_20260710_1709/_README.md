# DMF0074 Metal Link Price — 클라우드 이관 (전체 이관대상 · 2026-07-10)

> 범위 = **신규 화면 전체** (FE + 메타 + 분석 산출물). BE 코드 변경 0 — call-proc/excel-upload 공용 체인 재사용.

## 구성

### SQL (클라우드 DB — 순서대로 · 전부 멱등 MERGE/UPDATE)
| 파일 | 내용 |
|---|---|
| `sql/01_dmf0074_meta_wiring.sql` | 메타 배선 8블록 — API_M 7 / PROC_M 19 / BTN_MPG 8 / USER_GR 22 / EXCEL_COLUMNS STORAGE 교정 2 / MSG00656·LBL00762·763 / MNU_URL=`metal-link-price` / (⭐ #92 개정: ATTRIBUTE3 원복 — DIVISION_ID 직접 사용) |
| `sql/02_dmf0074_upload_save.sql` | Excel Upload 2-Step 저장 배선 — API `DMF0074_main_SAVE` / PROC 5 / BTN `SAVE`+DIV40 / USER_GR / MSG657~659 |
| `sql/99_verify_meta.sql` | 검증 카운트 |

### FE (신규 화면 + 공유 변경분)
```
fe/features/demand/src/pages/metal-link-price/   ← 신규 화면 전체 (진입/constants/types/store/Form/Grid/modals×2/__asis-mapping__)
fe/features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx(+scss)   ← ⚠ 공유 (2-Step onSave + 스피너)
fe/features/master/src/components/searchFields/SearchFields.tsx                  ← ⚠ 공유 (PlantSiteField)
fe/packages/foundation/src/constants/route-paths.ts   ← DMF0074:'metal-link-price' (additive)
fe/packages/shared/src/lib/lges-icons.ts              ← (FileExceldownloadIcon — 기존)
fe/apps/web/src/core/Router.tsx                       ← DEMAND>DEMAND_PLAN 라우트 추가
fe/configs/types/procedures.d.ts                      ← DMF0074 3시트 (additive)
```

### docs (분석 산출물 — hook #105)
`docs/DMF0074_MetalLinkPrice_UI분석서_v1.0.xlsx` (11시트) · `..._상세동작_개발용.md` · `DMF0074_데이터연결_마인드맵.html`

## 화면 요약

- 조회전용 그리드 58컬럼(Base 16 + 메탈 6그룹×7원소 42, 2단 헤더) · 편집제어 = 단일 division-gate(EDIT_AUTH_V INNER JOIN)
- 저장 = **Excel Upload 2-Step**(파일선택=검증·분류 / OK=저장, 전량 게이트 · DIV=40 formId `DMF0074_40`)
- Template(Excel Form) 다운로드 모달 · Version 모달(DMF0073_GET_VERSION_SALESPRICE, SP_W)
- Plant Site = `PlantSitebyEndCustomer`(81* enable)

## 적용 순서

1. `sql/01_...meta_wiring.sql` → `sql/02_...upload_save.sql` (멱등)
2. FE 배포 (route-paths/Router/procedures.d.ts additive — 기존 화면 무영향)
3. `sql/99_verify_meta.sql` 로 카운트 확인
- ⚠ standalone SP 5종 INVALID (운영=PKG_DMF0074 VALID) — 배선 전부 PKG 경로. 추가 GRANT 불요(기부여).

## 전제조건 (클라우드 DB)

- `PKG_DMF0074` (spec+body) VALID + SCMD_APP EXECUTE GRANT/SYNONYM (사내 기부여 — 클라우드 확인)
- CMBO_SQL_M `PlantSitebyEndCustomer`/`MyDivision`/`TeambyDivision`/`EndCustomer`/`SalesSite` 등록
- MSG/LBL 채번 충돌 시 클라우드 MAX 재확인 후 조정 (사내 = MSG00656~659 / LBL00762~763)

## 검증

verify_meta.sql: API 8 / PROC main14·template5·version9 / BTN 9 / USER_GR 24 / EXCEL PKG 2 / MSG·LBL / MNU_URL / ATTRIBUTE3 원복 0 / SAVE 배선.
화면: 메뉴 진입→조회(division-gate)→Excel Form(템플릿 다운로드)→Excel Upload(2-Step)→Version 모달→DIV=40 분기.
