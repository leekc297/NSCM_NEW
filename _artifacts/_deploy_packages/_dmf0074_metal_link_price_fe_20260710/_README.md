# DMF0074 Metal Link Price — 신규 FE 화면 이관 패키지 (2026-07-10)

> BE(nscm-be) 코드 변경 **0** — call-proc/excel-upload 공용 체인 재사용. SP 변경 0 (PKG_DMF0074 VALID 기존).
> 스펙 정본 = `Doc/화면설계서/DMF0074_MetalLinkPrice_상세동작_개발용.md` + `..._UI분석서_v1.0.xlsx` (hook #105).

## 구성

| 경로 | 내용 |
|---|---|
| `01_META/01_dmf0074_meta_wiring.sql` | 사내 메타 배선 8 BLOCK (멱등 MERGE — 재실행 안전 · DBeaver 호환) |
| `04_VERIFY/verify_meta.sql` | 적용 검증 (카운트 10종 + BTN→API→PROC 체인 조인) |
| `apply_meta.py` | 적용+검증 일체 (python-oracledb · `.env.asis` TOBE_DB_*) |

## 메타 8 BLOCK 요약

1. **API_M 7행** — main SEARCH/EXCEL/SORT/FILTER(→PKG GET)·UPLOAD(→PKG EXCEL_UPLOAD) + template_SEARCH + version_SEARCH(PROC_SELECT→DMF0073_GET_VERSION_SALESPRICE)
2. **PROC_M 19행** — main 14(divisionId~versionType + sesUserId/mnuId BE자동 + o_rc1/o_result_cursor) + template 5. version 9행 기존 공유(미등록)
3. **BTN_MPG 8행** — main×5 + template/version SEARCH + ⭐ `DMF0074_40` UPLOAD (DIV=40 excel-upload auth — FK 없음 실측)
4. **USER_GR_BTN 22행** — ADMIN/DM ADMIN 전체 · DM Viewer=UPLOAD 미부여 (DMF0014 선례)
5. **EXCEL_COLUMNS UPDATE 2** — STORAGE_SQL_ID: INVALID standalone → `PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD`
6. **MSG/LBL 신규** — MSG00656(템플릿 0건) + LBL00762('Excel Form') + LBL00763('Excel Download') — KO=EN=CN · 채번 = 사내 MAX 실측(MSG00655/LBL00761)+1
7. **MNU_M UPDATE** — MNU_URL `dmf0074` → `metal-link-price` (3-SET 정합)
8. **SHEET_COLUMNS ATTRIBUTE3 ← DIVISION_ID 복사 (58행)** — hook #92 FE 토큰 필터 (롤백: SET ATTRIBUTE3=NULL)

## FE 파일 (nscm-fe — git 커밋 대상)

```
features/demand/src/pages/metal-link-price/
├─ index.ts / MetalLinkPrice.tsx(271줄) / metal-link-price.constants.ts / metal-link-price.types.ts
├─ useMetalLinkPriceStore.ts / __asis-mapping__.md
└─ components/ MetalLinkPriceForm.tsx(+scss) / MetalLinkPriceGrid.tsx
   └─ modals/ MetalLinkTemplateModal.tsx(+scss) ⭐템플릿 다운로드 / MetalLinkVersionModal.tsx(+scss)
packages/foundation/src/constants/route-paths.ts   (DMF0074: 'metal-link-price' — additive)
apps/web/src/core/Router.tsx                        (⑨ DEMAND>DEMAND_PLAN children)
configs/types/procedures.d.ts                       (DMF0074 3시트 — additive)
```

## 적용 순서 (사내 → 클라우드 동일)

1. `python apply_meta.py` (멱등 — 재실행 안전. 검증 카운트 자동 출력)
2. FE 배포 (위 파일 세트)
3. 스모크: 메뉴 진입(3그룹) → 조회(division-gate 행 필터) → Excel Form(템플릿 조회+다운로드) →
   Excel Upload(DMF0074/DMF0074_40 분기·검증오류 리포트) → 버전 모달(SP·최대 2) → Excel 다운로드

## 검증 기대치 (verify_meta.sql)

API 7 / PROC main 14·template 5·version 9 / BTN 8 / USER_GR 22 / EXCEL PKG 2 / MSG00656 3 / LBL00762 3 / MNU_URL 1 / ATTRIBUTE3 58
