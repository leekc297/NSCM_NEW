# AS-IS ↔ TO-BE 콤보 **호출 지점 수(N:N)** 대사

> 실행 2026-08-08 18:07 · `_artifacts/_diagnostics/combo_callsite_parity.py` · **읽기 전용**
> 룰 = hook #117 §5.12. SQL·파라미터가 맞아도 **부르는 시점이 빠지면 조용히 죽는다.**
> 섹션 7·E2E D2축이 못 보는 축 — 이 대사표가 유일한 방어선이다.

판정: **FAIL** = 배선 자체 부재(AS-IS ≥2 지점) 또는 **행 생성(InsertRow) 지점 누락** /
**WARN** = AS-IS 지점 수 > TO-BE(트리거 부족 의심) 또는 대응 콤보 미식별 / **PASS** = 그 외

## 종합 — FAIL **0** / WARN **5** / PASS **9** (화면 1개)

## DMF0082 (FAIL 0 / WARN 5 / PASS 9)

> AS-IS 원천: `Doc\_legacy_source\06_UIL\domain_DM\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.cs`

| AS-IS CODE | TO-BE 콤보 | AS-IS 지점 | TO-BE 지점 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|:-:|---|---|
| AS_INCOTERMS | AsIncotermsEdit | 1 | 0 | 1 | - | ✅ PASS |  |
| CELL_PROD_SITE_ID | CELL_PROD_SITE_ID | 4 | 1 | 0 | O | ⚠ WARN | AS-IS 4지점 > TO-BE 1지점 — 트리거 부족 의심 |
| CURRENCY_LIST | CurrencyList | 2 | 0 | 0 | O | ✅ PASS |  |
| DM_CUSTOMS_HANDBOOK | CustomsHandbook | 1 | 0 | 2 | - | ✅ PASS |  |
| DefaultBucketDay | DefaultBucketDay | 1 | 0 | 1 | - | ✅ PASS |  |
| EndCustomerByDivision40 | EndCustomerByDivision40 | 3 | 0 | 0 | O | ✅ PASS |  |
| FCST_PRICE_EDIT_MEASURE | FcstPriceEditMeasure | 6 | 1 | 0 | - | ⚠ WARN | AS-IS 6지점 > TO-BE 1지점 — 트리거 부족 의심 |
| FCST_TYPE | FcstType | 1 | 0 | 1 | - | ✅ PASS |  |
| INCOTERMS | Incoterms | 3 | 0 | 0 | O | ✅ PASS |  |
| NO_DATA | - | 1 | 0 | 0 | - | ✅ PASS | 이식 안 함(사유 기재): AS-IS 는 빈 목록 콤보로 입력 차단 — TO-BE 는 빈 DataMap 스왑으로 동등 구현(콤보 불요) |
| SALES_BUCKET | SalesBucket | 3 | 1 | 0 | - | ⚠ WARN | AS-IS 3지점 > TO-BE 1지점 — 트리거 부족 의심 |
| SiteByEndCustomer | SiteByEndCustomer | 5 | 1 | 0 | O | ⚠ WARN | AS-IS 5지점 > TO-BE 1지점 — 트리거 부족 의심 |
| SiteByEndCustomer40 | - | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| TeamByDivisionAuth | - | 1 | 0 | 0 | - | ✅ PASS | 이식 안 함(사유 기재): TEAM_ID 는 SAVE 파라미터 부재 = 표시 전용 → 편집판 미적용(hook #117 §5.10) |

### 상세 (FAIL/WARN)

- **CELL_PROD_SITE_ID** → `CELL_PROD_SITE_ID` · AS-IS 호출 메서드: InsertRow, spdMain_Changed, spdMain_ClipboardPasted · 주석처리 6건(사문=미이관 파리티)
  - TO-BE 트리거: (신규행 프라이밍), DIVISION_ID, INCOTERMS, ITEM_ID, SCM_SITE_ID
- **FCST_PRICE_EDIT_MEASURE** → `FcstPriceEditMeasure` · AS-IS 호출 메서드: InsertRow, spdMain_Changed, spdMain_ClipboardPasted, spdMain_ComboSelChange · 주석처리 1건(사문=미이관 파리티)
  - TO-BE 트리거: (신규행 프라이밍), DIVISION_ID, INCOTERMS, SCM_SITE_ID
- **SALES_BUCKET** → `SalesBucket` · AS-IS 호출 메서드: spdMain_Changed, spdMain_ComboSelChange
  - TO-BE 트리거: INCOTERMS, SCM_SITE_ID
- **SiteByEndCustomer** → `SiteByEndCustomer` · AS-IS 호출 메서드: InsertRow, clbCustomer_SelectedIndexChanged, spdMain_ComboSelChange
  - TO-BE 트리거: (신규행 프라이밍), DIVISION_ID, END_CUSTOMER, ITEM_ID
- **SiteByEndCustomer40** → `-` · AS-IS 호출 메서드: clbCustomer_SelectedIndexChanged · 주석처리 1건(사문=미이관 파리티)
  - TO-BE 트리거: 없음

## 한계 (은폐 없음)
- AS-IS 명명 헬퍼는 **1단계**만 해소한다(헬퍼 안의 헬퍼는 미추적).
- TO-BE 트리거 추출은 `binding === 'X'` 정적 매칭 — 동적 분기(맵/스위치)는 누락될 수 있다.
- 이름이 다른 대응 콤보는 정규화(영숫자 소문자) 매칭이 실패하면 '미식별 WARN' 으로 노출한다(조용한 통과 없음).
- 주석 처리된 AS-IS 호출은 **제외하되 건수를 표에 기록**한다 — 사문 = 미이관이 파리티.

