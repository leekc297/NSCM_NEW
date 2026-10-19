# DMF0074 Metal Link Price — Excel Form AS-IS 2단 양식 + Upload 보완 (2026-09-14)

기준 양식: `C:\TRANFILE\RECEIVE\DMF0074_MetalLinkPricePopup_ASIS.xlsx` (53열 · 2단 병합 헤더 · 시트명 `Metal Link Price`)
사내 적용: ZIOUI1 (SCM_MGR) · 로컬 BE 재기동 · 클라우드 ⛔ 미적용

## 변경 내역

| 축 | 대상 | 내용 | 마커 |
|---|---|---|---|
| DB 메타 | `SCM_ADM_EXCEL_COLUMNS` (DMF0074 / DMF0074_40) | HEADER_CONTENT 메탈 42 토큰 → `그룹명_하위명` (`Period(Fr)_Ni` …) | E20260914-EXCELFORM2TIER |
| DB PKG (공용) | `PKG_NSCM_UI_EXCEL.PR_GET_EXCEL_UPLOAD_RESULT` | 결과 목록 `EXCEL_ROW` = 엑셀 실제 행 번호 (구: 오류 행 순번) | E20260914-EXCELROW |
| BE (공용) | `framework/utils/ExcelUtils.java` | `convertGroupedHeaderExcelToJson` 신설 — 2단 병합 헤더 판정·키 합성·행 위치 보존·정수 숫자 셀 소수점 제거 | — |
| BE (공용) | `general/file/FileServiceImpl.java` | 2단 판정 우선 → 아니면 기존 1단 파싱 (1단 화면 동작 불변) | — |
| FE (공용) | `packages/foundation/src/utils/gridAction.ts` | `groupedHeaderExcelDownload` 신설 (공통소스 5471ce3f 최신본 위에 추가만) | — |
| FE (공용) | `features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx` | Error Detail 컬럼 = HEADER_CONTENT 전 토큰 + 전 행 키 합집합 (첫 행 키만 → NULL 컬럼 소실 결함) | — |
| FE | `features/demand/src/pages/metal-link-price/metal-link-price.constants.ts` · `MetalLinkPrice.tsx` | Excel Form = 2단 양식 다운로드 · 업로드 토큰 `그룹명_하위명` | — |

## 파일

- `01_UPDATE_SCM_ADM_EXCEL_COLUMNS.sql` / `99_ROLLBACK_SCM_ADM_EXCEL_COLUMNS.sql` (적용 전 값 원복)
- `02_PKG_NSCM_UI_EXCEL_BODY.sql` / `BACKUP_PKG_NSCM_UI_EXCEL_BODY_pre_20260914.sql`
- `apply.py` (01 사내 적용 실행분)

## 클라우드 반영 순서 (의존)

DB 01 · 02 → BE 2파일 빌드·배포 → FE 4파일. **01 만 먼저 반영하면 구 BE 가 `Period(Fr)_Ni` 토큰을 못 찾아 메탈 35열이 조용히 탈락**한다 — BE 와 동시 반영.

## 실측 검증 (사내, minyonglee1)

- 2단 양식 7행 업로드: 53열 위치 매핑 일치 · 2행/빈 행 SKIP · 숫자 셀 `202610`/`6` 정상 (`dmf0074_2tier_upload_probe.py`)
- 케이스 51행 1파일(중간 빈 행 포함): 오류 행 전부 EXCEL_ROW = 엑셀 행 · 메시지 행 일치 48/51 (나머지 3 = 테스트 구성 기인) (`dmf0074_2tier_batch_cases.py`)
- 55열(82) 양식: 55개 값 위치 전부 일치 (`dmf0074_2tier_55col_probe.py`)
- 저장 왕복: 검증 SUCCESS 1 → [OK] P_MODE=1 CODE 0 → 원장 1행(Key M035·6/0·18.5/0.75/0.42) → 삭제 → 36,855 원복 (`dmf0074_2tier_save_roundtrip.py`)
- FE 생성 양식(실코드 esbuild 실행) ↔ AS-IS 파일: 시트명·53열·1/2행 명칭·병합·Arial 9·#F0F0F0·테두리·열너비(±0.006) 일치, 생성 양식 업로드 정상
- 회귀: DMF0014(1단) 업로드 검증 정상 동작 · EXCEL_ROW 2 = 엑셀 2행

## 주의

- 이전에 받은 1단 양식(`PeriodFr_Ni` 헤더)은 더 이상 메탈 35열이 매핑되지 않는다 — Excel Form 재다운로드 필요.
- `PKG_NSCM_UI_EXCEL` 은 전 Excel Upload 화면 공용 — Error Detail 'Row' 가 전 화면에서 엑셀 행 번호로 바뀐다.
- `gridAction.ts` 는 공통소스 최신본 채택으로 09-09 정렬 로직도 함께 반영됨 (로컬 `DataGrid.tsx` 는 미변경).
- type-check/lint 미수행 (상시 지시 — 요청 시 수행).
