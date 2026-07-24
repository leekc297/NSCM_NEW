# DMF0044 조회조건·Grid Cell Combo AS-IS 차이분석 + 정합 — 2026-07-23

## A. Grid Cell Combo Data Type 대조 (AS-IS MSSQL ↔ 사내 Oracle SHEET_COLUMNS 전수)
- 구조: 행수/시트/컬럼 완전 일치 (누락 0). CELL_CONTROL/CELL_COMBO_DATA_TYPE 상이분만 아래 표.
- 등록명 camelCase rename(CURRENCY_LIST→CurrencyList 등)은 **값 집합 실측 완전 동일 = 실질 일치** (AS-IS 해석기 `UP_FX_GetCommonDataList` 분기 ↔ TO-BE CMBO 대조).
- ⭐ 공통 실질 차이 2건 → **사내 정정 완료 + 본 폴더 sql 동봉**:
  | CMBO | 차이 | 정정 |
  |---|---|---|
  | `FcstType` | TO-BE가 ATTR2='Y'(WS/WSF) 제외 12종 — AS-IS 해석기 FCST_TYPE = SALES_TYPE_CODE 전체 **14종** | ATTR2 필터 제거 → 14종 (실측 OK) |
  | `DmBizType` | TO-BE 'ALL' UNION 행 — AS-IS DM_Biz_Type 에 없음. 셀 에디터에 'ALL' 선택지 노출(저장 오염 위험) + 조회조건에선 FE allOption 과 중복 | 'ALL' 행 제거 → 3종 (실측 OK) |

- DMF0044 관련 상이: BIZ_TYPE_NAME40(DmBizType)/CURRENCY(CurrencyList — 값 동일)/FCST_TYPE(FcstType) — 정정 2건 반영.

## B. 조회조건 데이터 소스 대조
| 항목 | 판정 | 근거 |
|---|---|---|
| Division(MyDivision) / Type(MDF_TYPE) / DataType(MDF_TYPE2) / Year(CALENDAR_YYYY) / SP Version | ✅ 전항 일치 | AS-IS GetLookupData("MDF_TYPE"/"MDF_TYPE2")·CALENDAR_YYYY ↔ TO-BE 동명 CMBO lookup 1:1 |

## 적용 (클라우드)
1) sql/01_CMBO_ASIS_PARITY.sql (FcstType/DmBizType — FE 변경 없음)
