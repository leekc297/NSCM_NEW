# DMF0049 조회조건·Grid Cell Combo AS-IS 차이분석 + 정합 — 2026-07-23

## A. Grid Cell Combo Data Type 대조 (AS-IS MSSQL ↔ 사내 Oracle SHEET_COLUMNS 전수)
- 구조: 행수/시트/컬럼 완전 일치 (누락 0). CELL_CONTROL/CELL_COMBO_DATA_TYPE 상이분만 아래 표.
- 등록명 camelCase rename(CURRENCY_LIST→CurrencyList 등)은 **값 집합 실측 완전 동일 = 실질 일치** (AS-IS 해석기 `UP_FX_GetCommonDataList` 분기 ↔ TO-BE CMBO 대조).
- ⭐ 공통 실질 차이 2건 → **사내 정정 완료 + 본 폴더 sql 동봉**:
  | CMBO | 차이 | 정정 |
  |---|---|---|
  | `FcstType` | TO-BE가 ATTR2='Y'(WS/WSF) 제외 12종 — AS-IS 해석기 FCST_TYPE = SALES_TYPE_CODE 전체 **14종** | ATTR2 필터 제거 → 14종 (실측 OK) |
  | `DmBizType` | TO-BE 'ALL' UNION 행 — AS-IS DM_Biz_Type 에 없음. 셀 에디터에 'ALL' 선택지 노출(저장 오염 위험) + 조회조건에선 FE allOption 과 중복 | 'ALL' 행 제거 → 3종 (실측 OK) |

- DMF0049 관련 상이: CURRENCY(CurrencyList — 값 동일 rename ✅)/FCST_TYPE(FcstType — 정정 반영).

## B. 조회조건 데이터 소스 대조
| 항목 | 판정 | 근거 |
|---|---|---|
| Division / Type(MDF_TYPE) / Year(CALENDAR_YYYY) / Plan·Result(ReportGroup3 — 조회조건 ALL 은 표준) / Report Group(DMF0005_REPORT_GROUP2) / SP Version | ✅ 전항 일치 | AS-IS lookup 타입 1:1 (DMF0044 형제 화면 기검증) |

## 적용 (클라우드)
1) sql/01_CMBO_ASIS_PARITY.sql (FcstType — FE 변경 없음)
