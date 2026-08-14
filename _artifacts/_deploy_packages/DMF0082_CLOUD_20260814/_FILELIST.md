# DMF0082_CLOUD_20260814 — 파일 인벤토리 (총 114파일)

> ⚠️ **FE 는 폴더 단위 전체 교체본**입니다 (2026-08-14 정정 — 사용자 지시).
> 최초본은 "기준선 대비 변경분만" 담아 `forecast-price/index.ts` 가 빠졌고, 그 결과
> 클라우드에서 **탭 안에 "Page Not Found"** 가 떴습니다. 원인·규약은 `_README.md` B_FE 절 참조.

## A_DB (10)

| 파일 | 내용 |
|---|---|
| `00_PRECHECK_CLOUD.sql` | READ-ONLY 선판정 (기준선/CTRL/INPUT_TP_CD/채번/콤보·SP 존재) |
| `01_GTT_DDL.sql` | BODY 참조 GTT 자급 DDL |
| `02_PKG_DMF0082_SPEC.sql` | SPEC 현행 |
| `03_PKG_DMF0082_BODY.sql` | BODY 현행 (08-13·08-14 누적 최종) |
| `04_LOOKUP_GET_ADMIN_GROUP_MEASURE.sql` | measure 편집권한 116행 MERGE |
| `05_CMBO_SYNC.sql` | 소비 콤보 4종 MERGE |
| `06_SHEET_META_SYNC.sql` | COLUMNS 86 + MEASURE 22 MERGE |
| `07_PROCM_API_SYNC.sql` | PROC 18 + API 17 MERGE |
| `08_MSG_SYNC.sql` | MSG00703/00705 3언어 6행 |
| `09_BTN_WIRING_SYNC.sql` | ⭐ 버튼 배선 18행 + 권한 100행 (`FORM_DATA` = Excel Form) |
| `10_EXCEL_META_SYNC.sql` | Excel 메타 — UPLOAD 13행 + COLUMNS 1행 |
| `90_VERIFY.sql` | 적용 후 값 단언 11섹션 |

## B_FE (31) — 페이지 폴더 전체

| 폴더 | 대상 경로 | 파일 |
|---|---|---:|
| `forecast-price/` | `nscm-fe/features/demand/src/pages/forecast-price/` | 31 (⭐`index.ts` 포함) |

## C_FE_SHARED (51) — 수정 있는 컴포넌트 폴더만

| 폴더 | 대상 경로 | 파일 |
|---|---|---:|
| `master-components/` | `nscm-fe/features/master/src/components/` | 51 (13폴더 + `index.ts` barrel) |

**제외**: `contributeRateModal` · `storageLocationModal` · `teamModal`(수정 0건) /
`features/demand/src/components/`(수정 0건 → 폴더 통째 제외)

> 반입 범위 = **수정 파일이 있는 폴더는 전체 / 수정 0건 폴더는 제외** (사용자 지시 2026-08-14).
> 단 페이지 폴더는 폴더 자체가 단위라 미수정 `index.ts` 도 포함한다 — 빠지면 Page Not Found 재발.

## 반입 후 필수 확인

```bash
ls features/demand/src/pages/forecast-price/index.ts                                   # 있어야 정상
ls features/demand/src/pages/forecast-price/components/modals/MeasureSelectModal.tsx   # 없어야 정상
pnpm build
```
