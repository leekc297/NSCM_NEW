# DMF0021 (Sales Plan) — 전체 보완 이관 패키지 (2026-08-12, 사내 적용 완료·클라우드 미적용)

> 2026-08-12 전체 보완 세션 산출: 대사표 신양식 전환(345행) + 통합테스트 사전점검 1st **No.58~62(하위 12항목)**
> 전건 처리 + RTF Cutoff 게이트(RTFGATE) + SEARCH 성능(PERFHINT >600s→17.1s) + 3축 FAIL 0.
> 판정 전문 = `Doc/화면분석서/DMF0021_단위테스트결함_대조_20260812.md` / 육안 = `DMF0021_테스트시나리오_체크리스트_20260812.md`.

## A_DB — 적용 순서 (sqlplus, SET DEFINE OFF)

| # | 파일 | 내용 | 방식 |
|---|---|---|---|
| 1 | `01_PKG_DMF0021_BODY.sql` | BODY 현행 3,597행 — **RTFGATE**(GET 시간창+SAVE 게이트, No.58) + **PERFHINT**(SINGLE_V 적재 LOOKA NO_PUSH_PRED) 포함 최종형 | CREATE OR REPLACE |
| 2 | `02_CMBO_SALESPLANITEMID.sql` | Insert Model = `SALES_PLAN_ITEM_ID` lookup 콤보 신설 (No.61-③, 정확 division 우선 dedup) | MERGE 멱등 |
| 3 | `03_MSG00704.sql` | RTF Cutoff 차단 MSG 3언어 (채번 규약: MSG99999 제외 실순번 MAX+1) | MERGE 멱등 |
| 4 | `90_VERIFY.sql` | 기대치 명기 검증 5항목 | SELECT only |

전제(기존재 — 본 패키지 미동봉): lookup `GET_ADMIN_GROUP_MEASURE` SEGMENT2='DMF0021' 54행(운영 기등록 — RTFGATE 가 소비).

## B_FE

| 경로 | 내용 |
|---|---|
| `B_FE/sales-plan/` | 페이지 폴더 전체 26파일 — 대사표(345행)+신설 테스트 17 포함. 폴더 교체(룰22 §10) |
| `B_FE/gridAction.ts` | ⚠ 공용(`packages/foundation/src/utils/`) — Excel dataMap 승계 (No.60-① "★ 모든 화면". DMF0003_CLOUD_20260812 와 동일 파일) |
| `B_FE/locales/` | ⚠ 공용 — MSG00703/MSG00704 키 포함 현행본. **키 병합**(파일 덮어쓰기 금지) |

## FE 주요 변경 (2026-08-12)

| 파일 | 변경 |
|---|---|
| `utils/sales-plan.editLock.ts` | DEPT_ID 전 Div 잠금(No.61-④) |
| `utils/sales-plan.division.ts` | TEXT 필수=ETC 행 한정(No.59)·Team 필수 해제·미소비 export 강등 |
| `utils/sales-plan.gridCombos.ts` | applyMeasureSwitch DEPT_ID clear(CC-12/20) |
| `utils/sales-plan.merge.ts` | Insert 행 머지 제외(DMF0003 No.57 계보 선제) |
| `utils/sales-plan.comboContext.ts` | Measure 콤보 mnuId 전달(빈 콤보 정정 — 게이트 §7) |
| `components/SalesPlanGrid.tsx` | Model=SalesPlanItemId 콤보 교체(No.61-③)·행종속 콤보 폴백(No.61-①)·Catch_Up 편집 콤보 2종 배선 |
| `sales-plan.constants.ts` | GRID_EDIT_COMBO DOM_EXP/INCOTERMS 추가 |
| `utils/sales-plan.editLock.test.ts` | 신설 17 tests (AS-IS 산식 1:1) |

## 적용 후 기대치 (사내 실측)

| 축 | 값 |
|---|---|
| PKG | VALID + RTFGATE/PERFHINT 마커 |
| 81 SEARCH (2개월) | ~17s (구 >600s) |
| 81 RTF 편집권 | 시간창 반영 — 평일 'N' / 토 16:00 후 'Y' |
| 81 RTF 저장(시간창 밖) | CODE -1 / `MSG00704^` + 원장 불변 |
| Model 콤보(82) | ETC/Sample/SI/MDF 4종 |
| 게이트/E2E/parity | FAIL 0 / FAIL 0 / FAIL 0 (PASS 13) |
