# DMF0003 (MKT FCST) — 정본 재대사 보완 클라우드 이관 패키지 (2026-08-12)

정본(`GSCM.DM.Forms.UIL/Plan/DMF0003_MktFcst/` 7,143줄) 전량 재대사(EID 1:1 159행) 결과의 보완분.
판정·근거 = `nscm-fe/features/demand/src/pages/mkt-fcst/__asis-mapping__.md` +
`Doc/화면분석서/DMF0003_MktFcst_{주요이벤트_상세분석,제약매트릭스_상세}.md` +
`DMF0003_정본전환_diff_20260812.md`. 순차 테스트 = `DMF0003_테스트시나리오_체크리스트_20260812.md`.

## 적용 순서

| # | 파일 | 내용 | 방식 |
|---|---|---|---|
| 1 | `A_META/10_CMBO_PLANTSITEBYITEM.sql` | CMBO `PlantSiteByItem` 신설 — 행별 Plant Site(project·item 조건, AS-IS UP_FX L5858~5884 1:1). 사내 실측 무필터 27→조건 5행 | MERGE + CLOB 1800자 청크 |
| 2 | `A_META/11_PROCM_CURSOR_FIX.sql` | PROC_M REF CURSOR 오등재 정정 14행(PSI/Car 계열 무해존치 SP + O_RESULT_CURSOR 2행). ⚠ `owner`(IN VARCHAR)는 대상 아님 | UPDATE (조건 가드) |
| 2.5 | `A_META/13_LOOKUP_MKT_FCST_MEASURE_82_EXCLUDE.sql` | (통합테스트 1st No.52) 82 편집 measure 콤보에서 BNPIn·RTF_SYS_RP·VMI_In_Plan·VMI_Inv 제외 — ATTRIBUTE2='Y' 마킹(행 삭제 아님·멱등) | UPDATE (조건 가드) |
| 3 | `B_FE/mkt-fcst/` | 폴더 전체(26파일) — 갭 7건 보완 + 단위테스트 신설 + 대사표 + **통합테스트 1st No.54/56-①/57 FE 보완**(FCST Type 82 WS/WSF 제외·AS From Site 미입력 잠금·Insert 행 머지 제외) | 폴더 교체(룰22 §10 폐포) |
| 4 | `B_FE/ForecastPriceGridUtils.{ts,test.ts}` | (DMF0082 부수) 08-08 배분·LOC 결함 수정분 복원 — 배치 경로 `forecast-price/components/` | 파일 교체 |
| 5 | `B_FE/useSalesPlanStore.test.tsx` / `useBusinessPlanStore.test.tsx` | (참고 동봉) 복원 검증 후 **최종 상태는 cfb81e9 본과 동일** — 클라우드가 이미 최신이면 적용 불필요 | 대조용 |

## 보완 내역 (mkt-fcst — 대사표 갭 7건)

| ID | 내용 |
|---|---|
| CA-04 | MSG00478 DM Planner류 시간창 게이트 **주석 복원**(재활성) |
| CA-07 | 조회 선행 가드(hasSearched — MSG00662) |
| CD-02 | AS(비축)향 사이트 행 INCOTERMS = `AsIncotermsEdit` 스왑 |
| CD-10 | 행별 Plant Site 재조회(`PlantSiteByItem` 신설 + applyPlantSites, 81* 전용) |
| CE-02 | AS_FROM_SITE 편집 판정에 **비축향 축** 추가 |
| CE-04 | Site/FcstType 변경으로 AS 조건 파기 시 **AS_FROM_SITE·MEASURE 값 클리어** |
| CG-05 | I 행 키값 변경 시 **수량(D_/W_/M_) 전부 클리어**(그리드+팝업 경로) |

부수: `SHEETS.MEASURE_COUNT` 사문 enum 제거 / 미소비 export 3종 내부 강등 / E2E `SCENARIOS["DMF0003"]` 신설 /
combo_callsite_parity `MENU_CODE_ALIAS·DISPOSITION["DMF0003"]` 등재.

## 적용 후 기대치 (사내 실측)

| 축 | 값 |
|---|---|
| 대사표 | 159/159 PASS (+ citations 148행) |
| 게이트 9섹션 | FAIL 0 (§3 WARN 1 = PR_GET_DAY_RANGE NUMBER 암묵변환 공용 SP — hook #109 기록) |
| E2E 15계정 | FAIL 0 / WARN 1 — **M축은 전용 키 probe 로 HTTP 왕복 실행 PASS**(SAVE M qty=7→반영→원복→소거, `DMF0003_http_e2e_20260812_0704.md` §F), WARN 은 일반 행 왕복 생략 사유(원장 보호)뿐 |
| 단위테스트 | demand 156 PASS (mkt-fcst 16 신설) |
| 82 SEARCH | code 0 / 626행 (기간 20250801~20260801) |
