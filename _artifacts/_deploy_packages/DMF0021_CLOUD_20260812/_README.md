# DMF0021 (Sales Plan) — 클라우드 이관 패키지 (2026-08-12)

> **기준선**: 클라우드 = `CLOUD_6SCREENS_20260722_1002` 적용 상태(2026-07-22). 본 패키지 = 그 이후 사내
> 변경분을 **현행 스냅샷**으로 취합(감사컬럼 실측 + 전수 UPSERT — 클라우드 행 부재/기존재 어느 쪽이든 안전).
> QA·DEV **2개 DB 각각** 적용.

## 담는 작업 (7/22 이후 누적)

07-21 결재분 반영(E20260331 RTF·E20260512 FROM_SITE_ID) → 07-30~31 trunc/ORA30926 → 08-04 AUTHUNION →
08-06 PLANTNORM·DS2·SITE 107 → **08-12 전체 보완**(대사표 345·RTFGATE(No.58)·PERFHINT(>600s→17s)·
결함 No.58~62/공통 C1·C2·Team 잠금·SalesPlanItemId 콤보·2단 접기·Footer 삭제·UI CATEGORY AS-IS 정합).

## A_DB — 적용 순서 (sqlplus, `SET DEFINE OFF`)

| # | 파일 | 내용 | 방식 |
|---|---|---|---|
| 1 | `01_GTT_DDL.sql` | PKG 참조 GTT 19개 자급 | ORA-955 skip 멱등 |
| 2 | `02_PKG_DMF0021_SPEC.sql` | SPEC 현행 | CREATE OR REPLACE |
| 3 | `03_PKG_DMF0021_BODY.sql` | **BODY 현행** — AUTHUNION+PLANTNORM+trunc2delete+**RTFGATE**+**PERFHINT**+⭐**COLDEDUP**(2026-08-12 ORA-00960 정정 — ColList COLUMN_NAME dedup 안전망 2곳, 마커 [E20260812-COLDEDUP]. 클라우드 조회 SQL ERROR 해소분 — **재적용 필수**) | CREATE OR REPLACE |
| 4 | `04_CMBO_SYNC.sql` | 소비 콤보 중 기준선 후 변경 6종(SalesPlanItemId 신설 등) | MERGE (CLOB 청크) |
| 5 | `05_PROCM_SYNC.sql` | PROC_M 배선 49행 전수 | MERGE — DELETE 금지 |
| 6 | `06_SHEET_META_SYNC.sql` **(v4)** | ⭐ hook #98 §9(2026-08-12 역전 확정) — **SHEET_NAME 단위 DELETE 후 사내 전 행 재적재**: 'Sales Plan' COLUMNS 89(DMF1007 공유분 포함 전량)+MEASURE 46 / 'Sales Plan Waterfall' MEASURE 84. 삭제=삽입 219행 일치·VERIFY 동봉(사내 드라이런 PASS) | DELETE+INSERT 완전 교체 |
| 7 | `07_LOOKUP_SYNC.sql` **(v2)** | `GET_ADMIN_GROUP_MEASURE`(DMF0021 — **RTFGATE 소비**) + `SALES_PLAN_ITEM_ID` 76행 — **PK 6컬럼(SEG1~5)** MERGE + 같은 SEG1~4 의 SEGMENT5 상이 구행 선삭제(구판 ORA-00001 원인) + 말미 VERIFY | DELETE(표적)+MERGE |
| 8 | `08_BTN_WIRING_SYNC.sql` | 버튼 배선+권한 95행 전수 | MERGE |
| 9 | `09_API_SYNC.sql` | API 14행 전수 | MERGE |
| 10 | `10_MSG_SYNC.sql` | MSG00703(공통 재조회)·**MSG00704**(RTF Cutoff 차단) 3언어 | MERGE |
| 11 | `11_SCM_MST_SITE_MISSING_107.sql` | ⛔ **적용 제외 확정(2026-08-12 사용자)** — 마스터 누락은 클라우드 환경에서 원인 확인 예정. 참고용 동봉만 | (실행 안 함) |

## B_FE

| 경로 | 내용 |
|---|---|
| `B_FE/sales-plan/` | 페이지 폴더 전체 26파일(대사표 345행+테스트 33 포함) — 폴더 교체(룰22 §10 폐포) |
| `B_FE/SearchFields.tsx` | ⚠ 공용(`features/master/src/components/searchFields/`) — **TeamField divisionId 콤보 전달**(2026-08-12 — 40 owner 분기 활성. AS-IS 콜사이트 계약 1:1. 미반영 시 40 Team 0건) |
| `B_FE/gridAction.ts` | ⚠ 공용 — Excel dataMap 승계(전 화면. DMF0003/0082 패키지와 동일 파일) |
| `B_FE/locales/` | ⚠ 공용 — MSG00703/704 키. **키 병합**(덮어쓰기 금지) |

## 적용 후 기대치 (사내 실측)

| 축 | 값 |
|---|---|
| PKG | VALID + RTFGATE 2/PERFHINT 1 마커 |
| 81 SEARCH(2026-07~08 2개월) | ~17s |
| 81 RTF | 편집권 시간창(평일 N/토 16:00 후 Y) + 시간창 밖 저장 `CODE -1 / MSG00704^` |
| Insert Model 콤보(82) | ETC/Sample/SI/MDF (SalesPlanItemId lookup) |
| 게이트/E2E/parity | FAIL 0 (사내 리포트 `DMF0021_20260812_1052.md` 등) |

문서: `Doc/화면분석서/DMF0021_{단위테스트결함_대조,테스트시나리오_체크리스트}_20260812.md`
