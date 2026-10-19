# NSCMFE_PRE_COMMON_20260915 — 공통소스 2a96a90c 반영 전 백업 + 분류표

- 공통 HEAD: **2a96a90c** (2026-09-15 09:20 "fix: 191번 User, Group User 화면 간 구분을 위한 새 파라미터 추가")
- 직전 기준선: **bb9c5113** (2026-09-09 적용) — `git merge-base --is-ancestor` 로 조상 확인(force-push 재작성 없음)
- 변경 범위: 4폴더(apps·features·packages·public) **168파일** + 동반 `configs/types/procedures.d.ts`
- 사용자 지시: **"공통소스 중 내가 가지고 있는 소스가 더 최신이면 내 걸로 유지"**
- 판정: mtime ⛔ — 3자 내용 대조 + 개행 정규화(LF·BOM) + 공통 이력 전수 대조 + Python 바이너리 I/O
- 백업 = 이번 반영으로 덮인 로컬 원본 **96파일** (`nscm-fe/` 이하 실경로). 적용 목록 = `applied_files.json`

## ⭐ 이번 회차 방법 정정 — 3-way base = "로컬이 실제 출발한 공통 판본"
직전 기준선(bb9c5113)을 base 로 쓰면, **과거 회차에서 충돌→로컬유지 된 파일**은 로컬이 기준선보다 훨씬 낡아
공통의 옛 개선분이 전부 "내 편집"으로 오판된다. 실측: `DataGrid.tsx` 로컬 = 공통 **08-27(08326f42) 판본 + 내 편집 33줄**
(09-04~09-10 공통 개선 — F3 정렬 유지·itemsSource 교체 시 정렬/신규행 고정·필터 Clear/상한/레이아웃·sheetName — 누락 상태였음).
⇒ 로컬 편집 파일은 **공통 이력 중 로컬과 변경량 최소 판본을 base** 로 병합 (`nearest_base`). 결과 충돌 5→2.

## 분류 (168)
| 구분 | 건수 | 처리 |
|---|---:|---|
| 공통채택 (로컬=기준선) | 83 | 공통본 적용 |
| 신규 추가 | 72 | 공통본 추가 |
| 3-way 병합 성공 | 3 | 양쪽 변경 병합 |
| 충돌 → hunk 단위 해결 | 9 | 아래 표 |
| 충돌 → 로컬 유지 (파일 전체) | 1 | MetalLinkPrice.tsx |

반영 후 검증: 168 중 **156 = 공통 HEAD 동일**, 12 = 내 편집 보존 병합본, 충돌 마커 잔존 0.

### 신규 추가 (72) — 화면
- admin: `batch-log`(SCM0016) · `sms-setup`(SCM0007)
- supply: `formation` · `project-route` · `tact-time`(SCP0020)
- master: `components/materialByDivisionModal`(COM0013) · sales-future-price `utils/salesPriceAutoMap(.test).ts`
- demand: `sales-plan/__asis-analysis__.md`

### 3-way 병합 성공 (3)
| 파일 | base | 보존된 내 편집 |
|---|---|---|
| features/admin/src/pages/dynamic-query/DynamicQuery.tsx | ed28bb5b | (결과 = 공통 HEAD 동일) |
| features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx | 546c994e | E20260908-EXCELFORM-PERIOD `validateSearchParams` 분리 |
| packages/foundation/src/utils/gridAction.ts | b48bd692 | DMF0074 `groupedHeaderExcelDownload` (09-14) |

### 충돌 → hunk 단위 해결 (9)
| 파일 | 해결 | 근거 |
|---|---|---|
| packages/shared/.../data-grid/DataGrid.tsx | **합집합** — 내 `comboParamExcludes`(E20260901-CPSDISP) + 공통 `sheetName`·`EMPTY_COMBO_PARAMS` | 독립 기능. 내 #93 헤더 높이 row 단위 강제도 보존 |
| features/demand/.../forecast-price/components/ForecastPriceGrid.tsx | **합집합** — `comboParamExcludes={['CELL_PROD_SITE_ID']}` + `sheetName={SHEETS.FCST_N_PRICE_40}` | 독립 prop |
| packages/shared/.../data-grid/dataGridUtils.ts | 공통 표기 채택(2 hunk) | FPTextModal 아이콘 — 양쪽 의미 동일(공통 09-14 58e9775d). 내 편집 주석 보존 |
| features/demand/.../sales-reports/SalesReports.tsx | **로컬** — Delete = `searched.dataType === ETC` | 공통 aa6108e0(09-04) `sc.dataType !== CUTOFF` 보다 내 편집(09-11, Cutoff SP D 미취급)이 최신. 공통 Division 자동선택·Insert 포커스/pin 등은 병합 |
| features/demand/.../sales-reports/components/SalesReportsGrid.tsx | **로컬**(주석 1줄) | 공통 DEPT_ID 신규행 전용 재도입(08-31)·동적 컬럼 필터 허용·allowSorting 제거는 병합 채택 |
| features/demand/.../sales-reports/utils/sales-reports.editLock.ts | **로컬** + 공통 `reportType: string` 중복 선언 1줄 제거 | 동일 수정(BP_M isPast) 양쪽 구현 — 병합 시 속성 이중 선언 발생해 정정 |
| features/demand/.../sales-reports/utils/sales-reports.save.ts | **로컬**(2 hunk, 주석) | cellProdSite/plantSiteId 동일 수정 |
| public/locales/EN.json | 키 단위 병합 +28 | 로컬 전용 키 0 → 공통에만 있는 키 전부 추가(과거 회차 누락 25 + 신규 LBL01035~01037) |
| public/locales/KO.json | 키 단위 병합 +23, 값 채택 1 (`LBL00397` 공지 식별명→제목) | 로컬이 바꾼 값은 유지 |

### 충돌 → 로컬 유지 (1) → ⭐ 사용자 지시로 공통본 채택 (2026-09-15 후속: "METALLINKPRICE 내소스 무시하고 공통 최신으로")
- features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx → **공통 HEAD 동일본으로 교체** (로컬 원본 백업 = 본 폴더 동일 경로)
  - 짝 확인: `GridAction.excelDownload` 4번째 인자 headerCellStyle · `captureGridSort/Filter`·`restoreGridSort/Filter` export 로컬 gridAction.ts 존재
  - ⚠ 재업로드 잔존 격차: 공통 양식 = 메인 그리드 2단 헤더 export. 로컬 BE 는 `convertGroupedHeaderExcelToJson`(그룹명_하위명 합성) 이며
    공통 BE `convertExcelToJsonTwoHeaderRows`(06bb51c1) 는 미적용 → 공통 양식 재업로드 헤더 매칭은 별도 검증 필요
- (종전 판단 기록)
  - 로컬(09-14) = AS-IS 2단 병합 헤더 **정적 컬럼 양식**(`groupedHeaderExcelDownload`) — 사내 DB HEADER_CONTENT 그룹명_하위명 + BE `convertGroupedHeaderExcelToJson` 과 **짝**.
  - 공통(09-14) = 메인 그리드를 데이터만 비워 export. 비충돌 hunk(`captureGridSort` import·`.finally`)가 공통 방식 전용이라 hunk 병합 불가 → 파일 전체 로컬 유지.

## 4폴더 밖 동반 조치 — configs/types/procedures.d.ts
공통 변경 = 추가만(삭제 0). 전체본 덮어쓰기 ⛔ — 블록 단위 삽입:
- `ssoUser.request` 에 `ssoUserYn: string;` 1필드 (SsoUserModal 공통채택본 짝)
- 신규 블록 6종 **SCM0016 · COM0013 · SCM0007 · SCP0007 · SCP0005 · SCP0022** (로컬 부재 확인) → RawProcedureMap 닫는 괄호 앞 삽입(382줄, 중괄호 균형 확인)

## ⚠ 4폴더 밖 미수행 — BE (사용자 결정 필요)
| 공통 커밋 | 파일 | 판단 |
|---|---|---|
| 06bb51c1 "Excel 재업로드 시 2단 헤더 파서 적용" | ExcelUtils.java(`convertExcelToJsonTwoHeaderRows`) · FileServiceImpl.java(mnuId DMF0074 분기) | **미적용 권고** — 로컬에 동일 목적 `convertGroupedHeaderExcelToJson`(09-14, DB·FE 짝)이 이미 있음. 공통 파서는 공통 MetalLinkPrice 양식 전용 |
| 228a2494 / 68f4d37e SYS0013 동적쿼리 타임아웃 | sql/admin/DynamicQuery.xml `timeout="300"` | 독립 1줄 — 필요 시 별도 지시 |
| (CI) | nscm-be/.gitlab-ci.yml | 대상 아님 |

## 미수행 — 검증
type-check / lint 미실행 (사용자 지시 2026-09-02 "별도 요청 전까지 자동 수행 금지"). 병합 쌍 파일(DataGrid↔useRowParamCombos·useTabComboQueries, SalesReportsGrid↔gridCombos, editLock↔test) 대상 심볼 grep 대조만 수행.
요청 시 `_artifacts/_tools/fe-check.ps1`.

## 원복
1. 본 폴더 `nscm-fe/` 이하를 `C:\Projects\NSCM\nscm-fe\` 에 실경로 복사 (96파일)
2. `applied_files.json` 의 `add` 72파일 삭제
