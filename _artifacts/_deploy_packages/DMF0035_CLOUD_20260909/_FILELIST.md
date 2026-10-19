# 파일 목록 — 적용 순서 (3 PKG 상호 독립, 메타는 PKG 이후)

| 순서 | 파일 | 사내 배포시각 | 용도 |
|---:|---|---|---|
| 1 | `01_DB/01_PKG_DMF0035_BODY.sql` | 2026-09-10 18:47:08 | MKT FCST |
| 2 | `01_DB/02_PKG_DMF0022_BODY.sql` | 2026-09-10 17:20:08 | SALES PLAN |
| 3 | `01_DB/03_PKG_DMF0051_BODY.sql` | 2026-09-10 18:08:00 | BIZ PLAN |
| 4 | `02_META/10_CMBO_DMF0035_MEASURE.sql` | — | 시트 한정 MEASURE 콤보 3종 (멱등 MERGE) |
| 5 | `02_META/11_SHEET_COLUMNS_MEASURE_COMBO.sql` | — | MEASURE 컬럼 콤보 배선 3행 |
| 6 | `90_VERIFY.sql` | — | 검증 G1~G26 (읽기 전용) |
| - | `00_README.md` | — | 변경 내역 · AS-IS 근거 · 검증 실측 |

## 마커 (LIVE 기준 확인용)

> ⚠️ 마커 문자열은 설명 주석에도 인용되므로 **단순 카운트로 판정하지 말 것.**
> 적용 판정은 `90_VERIFY.sql` 의 게이트(`LTRIM(TEXT) NOT LIKE '--%'` 로 LIVE 만 계수)로 한다.

| 마커 | 대상 | 내용 |
|---|---|---|
| `E20260909-SHEETUNIFY` | 0035 | titleset 시트명 = AS-IS 실등록명 |
| `E20260909-TYPEAXIS` | 0022 / 0051 | 메타 축 PROGRAM_ID = `DMF0035` |
| `E20260909-MEASURECOL` | 0035 | MEASURE 컬럼 보장 |
| `E20260910-MEASURECOL` | 0022 / 0051 | 〃 |
| `E20260910-GRAINFIX` | 0035 / 0022 / 0051 | GROUP BY 확장 블록(ALLCOLS) 제거 |
| `E20260910-LOCAVG` | 0035 | 단가 LOC = AVG (AS-IS 동형) |
| `E20260910-FROMSITE` | 0022 | `FROM_SITE_ID` 컬럼사전 등재 |
| `E20260910-COMPANYID` | 0022 | `@#@#@#` → `NVL(TRIM(...),'-')` |
| `E20260910-ENERGE` | 0022 | Energy 참조 컬럼 `ENERGE_WH` → `ENERGE` |
| `E20260910-ENERGESCALE` | 0022 | AS-IS `CONVERT(NUMERIC(15,3))` 2단 복원 |
| `E20260910-KWHNUM` | 0022 / 0035 | `ATTRIBUTE8` 변환 실패 시 0 |
| `E20260910-QTYMASK` | 0022 | 82 QTY 고정폭 마스크 → `ROUND(A.QTY,10)` |
| `E20260910-CURFALL` | 0022 / 0051 | 빈 통화 폴백 = AS-IS `A.CURRENCY <> ''` 동치 |
| `E20260910-MEASDIV` | 0051 | 개인화 메저를 마스터(DIVISION+VALID)로 제한 |
| `E20260910-SITEITEMCOL` | 0035 | `GT_DM35_SITE_ITEM` 적재 누락 컬럼 복원 |

## 철회된 것

| 마커 | 사유 |
|---|---|
| `E20260910-PERSDIV` | 개인화 **컬럼** DIVISION 필터. GROUP BY grain 이 바뀌어 AS-IS 대비 div81 29행 병합 소실 → 원복. AS-IS DMF0022 는 2019-01-25 이 조건을 의도적으로 주석처리(KHSONG). 현재 컬럼 축 필터는 `PKG_DMF0051` L1498(AS-IS 원본 `[C20221107-000343]`) 에만 존재. |

⚠ 공유 콤보 `Measure` 는 **미포함**(FE 차후 적용 예정). 타 화면 작업분도 미포함.
