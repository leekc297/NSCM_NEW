# DMF0082 (Fcst & Price MGMT) — 통합테스트 보완 클라우드 이관 패키지 (2026-08-11)

`Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 의 DMF0082 해당분 **28건 전수 판정 → 미보완 0** 달성분과,
`No.65` measure 축 보완분을 클라우드로 옮기기 위한 패키지다.

- 판정표: `Doc/화면분석서/DMF0082_통합테스트_보완대사표_20260811.md`
- No.65 상세: `Doc/화면분석서/DMF0082_No65_measure_이식명세_20260811.md` (**1차 명세 폐기·정정본**)

## 적용 순서

| # | 파일 | 내용 | 방식 |
|---|---|---|---|
| 1 | `A_PKG/01_PKG_DMF0082_BODY.sql` | `P_DMF0082_GET_MAIN_DATA` 에 Team(deptId) 필터 신설 (마커 `TEAMFILTER`) — No.37 | CREATE OR REPLACE |
| 2 | `B_META/20_SHEET_COLUMNS.sql` | 10행 — division 스코프 정합. **No.39 `CELL_PROD_SITE_ID` = `40,82`(81 제외)** + **No.63-② `AS_FROM_SITE.INPUT_TP_CD` = `IO`** 포함 | **MERGE INTO** (DELETE 절 없음) |
| 3 | `B_META/21_LOOKUP.sql` | 14행 — No.63 고객향/비축향 3분기 + `GET_ADMIN_GROUP_MEASURE` W/S 권한 + `DM_UI_EDITABLE_MEASURE` 81 계열 | MERGE (5 SEGMENT 복합키) |
| 4 | `B_META/22_CMBO_SQL.sql` | 2건 — `FcstPriceEditMeasure`(No.63 3분기) / `Division` | MERGE + CLOB 1800자 청크 |
| 5 | `D_MEASURE_NO65/10_SHEET_MEASURE_NO65.sql` | **8행 INSERT-only** — No.65 81 measure 등재 | INSERT (NOT EXISTS 가드) |
| 6 | `C_FE/forecast-price/` | 8파일 — 그리드 편집 메타 게이트, C1~C4 공통 보완, 모달 2종, **No.63-② `utils/forecast-price.asFromSite.ts` + 단위테스트** | 파일 교체 |
| 7 | `C_FE/shared-columnSelectDualList/` | 2파일 — **No.40-②** 공용 `ColumnSelectDualList` 컬럼 리사이즈(opt-in `resizableColumns`). 배치 경로 = `nscm-fe/packages/shared/src/components/molecules/columnSelectDualList/` | 파일 교체 |
| 8 | `C_FE/locales/` | 3파일 (ko/en/…) — 정본은 `nscm-fe/public/locales` | 파일 교체 |
| 9 | `90_VERIFY.sql` | 적용 검증 | SELECT |

## 주의

- **SHEET_COLUMNS 는 MERGE INTO** (2026-08-11 사용자 지시). DELETE 절은 넣지 않았다 — 과거 DELETE 절 MERGE 로
  원장이 소실된 사고가 있었다. 미존재 행은 INSERT, 존재 행은 해당 컬럼만 UPDATE 한다.
- `SHEET_MEASURE` 는 **INSERT-only**. 기존 14행은 손대지 않는다.
- FE 는 `forecast-price/` 폴더 단위로 옮긴다(룰22 §10 — import 폐포).

## 적용 후 기대치 (사내 실측 기준)

| 항목 | 값 |
|---|---|
| `SHEET_MEASURE` (DMF0082/FcstNPrice) | 14행 → **22행** |
| 조회 행수 div 40 | 17,495 (**불변**) |
| 조회 행수 div 81 | 6,693 → **6,785** (+92 = `CUST_FCST`) |
| 조회 행수 div 82 | 4,904 (**불변**) |
| Team 필터 | `deptId` 지정 시 해당 팀만 (보완 전 = 무시되어 전 팀 반환) |

⚠ 신규 measure 는 **Measure Setting 팝업에서 선택해야** 화면에 나타난다(기존 사용자 titleset 은 변하지 않는다).
`CUST_FCST` 만 `DEFAULT_FLAG='Y'` 라 titleset 이 비어 있는 신규 사용자에게 자동 시드된다.
