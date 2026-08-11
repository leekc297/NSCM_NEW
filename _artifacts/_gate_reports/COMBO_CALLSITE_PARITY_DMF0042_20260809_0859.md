# AS-IS ↔ TO-BE 콤보 **호출 지점 수(N:N)** 대사

> 실행 2026-08-09 08:59 · `_artifacts/_diagnostics/combo_callsite_parity.py` · **읽기 전용**
> 룰 = hook #117 §5.12. SQL·파라미터가 맞아도 **부르는 시점이 빠지면 조용히 죽는다.**
> 섹션 7·E2E D2축이 못 보는 축 — 이 대사표가 유일한 방어선이다.

판정: **FAIL** = 배선 자체 부재(AS-IS ≥2 지점) 또는 **행 생성(InsertRow) 지점 누락** /
**WARN** = AS-IS 지점 수 > TO-BE(트리거 부족 의심) 또는 대응 콤보 미식별 / **PASS** = 그 외

## 종합 — FAIL **5** / WARN **5** / PASS **3** (화면 1개)

## DMF0042 (FAIL 5 / WARN 5 / PASS 3)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs (3564행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| CURRENCY_LIST | CurrencyList | 2 | 2 | 0 | 1 | - | ⚠ WARN | AS-IS 이벤트 2종 > TO-BE 트리거 0 — 부족 의심 |
| DMF0042_BP_Measure | DMF0042_BP_Measure | 2 | 6 | 0 | 0 | O | ✅ PASS |  |
| DM_BIZ_TYPE | - | 2 | 2 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| EndCustomerByDivision40 | EndCustomerByDivision40 | 4 | 4 | 0 | 0 | O | ✅ PASS |  |
| EndCustomerByDivisionDept | EndCustomerByDivisionDept | 3 | 5 | 0 | 0 | O | ✅ PASS |  |
| EndCustomerByDivisionDeptAuth | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| MyDivision | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| PlantSiteByDivision | - | 2 | 2 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| SiteByEndCustomer | SiteByEndCustomer | 6 | 7 | 0 | 0 | O | ⛔ FAIL | AS-IS 에 **행 생성 지점**(InsertRow)이 있고 콤보가 행 종속 토큰(divisionId, endCustomer)을 갖는데 TO-BE 신규행 프라이밍 없음 — 메타 자동 바인딩은 렌더 1회라 대체 불가 |
| SiteByEndCustomer40 | - | 2 | 2 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| SiteByEndCustomerAuth | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| TeamByDivision | - | 2 | 2 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| TeamByDivisionAuth | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |

### 상세 (FAIL/WARN)

- **CURRENCY_LIST** → `CurrencyList` · AS-IS 호출 메서드: InitControls, cboDivision_SelectedIndexChanged
  - TO-BE 트리거: 없음
- **DM_BIZ_TYPE** → `-` · AS-IS 호출 메서드: InitControls, cboDivision_SelectedIndexChanged
  - TO-BE 트리거: 없음
- **EndCustomerByDivisionDeptAuth** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음
- **MyDivision** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음
- **PlantSiteByDivision** → `-` · AS-IS 호출 메서드: InitControls, cboDivision_SelectedIndexChanged
  - TO-BE 트리거: 없음
- **SiteByEndCustomer** → `SiteByEndCustomer` · AS-IS 호출 메서드: InitControls, InsertRow, cboDivision_SelectedIndexChanged, clbCustomer_SelectedIndexChanged, clbTeam_SelectedIndexChanged, spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **SiteByEndCustomer40** → `-` · AS-IS 호출 메서드: clbCustomer_SelectedIndexChanged, clbTeam_SelectedIndexChanged
  - TO-BE 트리거: 없음
- **SiteByEndCustomerAuth** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음
- **TeamByDivision** → `-` · AS-IS 호출 메서드: InitControls, cboDivision_SelectedIndexChanged
  - TO-BE 트리거: 없음
- **TeamByDivisionAuth** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음

## 한계 (은폐 없음)
- AS-IS 명명 헬퍼는 **1단계**만 해소한다(헬퍼 안의 헬퍼는 미추적).
- TO-BE 트리거 추출은 `binding === 'X'` 정적 매칭 — 동적 분기(맵/스위치)는 누락될 수 있다.
- 이름이 다른 대응 콤보는 정규화(영숫자 소문자) 매칭이 실패하면 '미식별 WARN' 으로 노출한다(조용한 통과 없음).
- 주석 처리된 AS-IS 호출은 **제외하되 건수를 표에 기록**한다 — 사문 = 미이관이 파리티.

