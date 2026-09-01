# DMF0040_CLOUD_20260826 — MKT FCST Comparison 신규 화면 (T01 전 절차)

> 신규 생성 2026-08-26~27. 플랜 승인 후 분석 md → 분석서 → 설계서 → 메타 시딩 → FE 구현 → 대사표 → E2E.
> AS-IS 정본 = Forms.UIL `DMF0040_MktFcst_Comparison.cs` 1,875행 (읽기 전용 비교 리포트 — 저장 경로 없음).

## 적용 순서: A_DB `01` → `02` → `03` → `05` → `06` → (B_FE 배포) → `04` → `90`

| # | 파일 | 방식 | 내용 |
|---|---|---|---|
| 01 | 01_SHEET_MEASURE.sql | DELETE+INSERT 3행 | Measure = AS-IS 실사용 3종 (Version(A)/Version(B)/Difference — SP 고정 생성 축·titleset 'M' 실측) |
| 02 | 02_API_M.sql | MERGE 3행 | API 3본 (main/spreadTitle/version — PROC_SELECT) |
| 03 | 03_PROC_BTN_AUTH.sql | DELETE+INSERT 27 + MERGE 25 | PROC_M positional (main 20·spreadTitle 7 — PKG_SCM0002 는 기이관 전제) + BTN 5(main/spreadTitle/version/titleSet×2) + **titleSet API_M 2본** [E20260827-TITLESETAPI] + 그룹권한 4그룹×5 |
| 05 | 05_PKG_DMF0040_BODY.sql | 전체 교체 | **변환 잠재결함 4계열 정정** (SHEETNAME 1 / DATEINS 13 / SORTCODE 6 / ORDERSKIP 1 — 컴파일 VALID 였으나 최초 실행에서 순차 노출·전부 실증 정정) |
| 06 | 06_META_FIX.sql | UPDATE | SHEET_COLUMNS DEFAULT_FLAG(VERSION_NO/MEASURE='Y') + titleset 정렬코드 '-' 정정 |
| 04 | 04_MNU_ROUTE.sql | UPDATE 1행 | ROUTE_PATH/MNU_URL = `mkt-fcst-comparison` — **B_FE 배포 후 마지막** (선실행 시 Page Not Found) |
| 90 | (검증) | — | 마커 4계열 + 배선 5축 + R 스모크 (아래) |

## B_FE (실경로 13파일 — hook §1.8)
`features/demand/src/pages/mkt-fcst-comparison/` 전체 (페이지 5 + components 4 + utils 1 + 대사표) + `configs/types/procedures.d.ts` (DMF0040 계약 블록 추가분 — 병합 주의: 전체 교체 파일이므로 클라우드 판과 diff 확인 후 반영).

## 사내 검증 실측 (2026-08-27)
- 게이트 러너 10섹션: **FAIL 0** (PASS 7 / WARN 3 — 리포트 `_gate_reports/DMF0040_20260827_0101.md`).
  WARN 3건 = 전부 사유 실측 기재: ③L7 titleSet 리터럴 sheetName(DMF0082 계보 동형) ⑦콤보 토큰은 master 공용 검색필드가 전달(도구 스캔 범위=페이지 폴더 한계 — 대사표 §5.6 대사표 기재) ⑨값 검증 대상 배분/판정 순수 함수 부재(계산 전량 SP — R 스모크+E2E rows 로 검증).
- 단위테스트 케이스: `Doc/단위테스트/DMF0040_MktFcstComparison_TestCases.xlsx` (40/81/82 시트 각 28행 + DATA 시트 — 권한 5계정 행 포함).
- R 스모크 (SP 직접): 40=854행(4.7s) / 81=462행(3.4s) / 82=585행(3.1s) · MEASURE=Version(A)/(B)/Difference · CODE=0
- versionNo='Current' 지원 (81=544행) — E2E 안정 파라미터
- HTTP E2E: E 축 40=774/81=544/82=558행 · H 축 15계정 매트릭스 전 축 기대 일치 (SEARCH 권한 4그룹 200·무권한 403·SAVE 전 계정 403)
- 대사표: 81/81 행 PASS (`asis_mapping_gate --check`) · 사전 게이트: `06_verify --program DMF0040` ERROR 0
- 타입체크 3/3 PASS

## 미결·확인 축
- DM Planner / DM Planner (W/S) 는 **메뉴권한 자체가 미등재** (AS-IS 이관 4그룹: ADMIN/DM ADMIN/DM Viewer/SCP Planner) — E2E 403 은 정합. 개방 여부는 운영 결정.
- 브라우저 실조작(드릴다운·회색 표시·모달) = 사용자 확인 축.
