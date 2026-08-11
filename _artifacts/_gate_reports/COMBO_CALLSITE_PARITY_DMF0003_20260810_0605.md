# AS-IS ↔ TO-BE 콤보 **호출 지점 수(N:N)** 대사

> 실행 2026-08-10 06:05 · `_artifacts/_diagnostics/combo_callsite_parity.py` · **읽기 전용**
> 룰 = hook #117 §5.12. SQL·파라미터가 맞아도 **부르는 시점이 빠지면 조용히 죽는다.**
> 섹션 7·E2E D2축이 못 보는 축 — 이 대사표가 유일한 방어선이다.

판정: **FAIL** = 배선 자체 부재(AS-IS ≥2 지점) 또는 **행 생성(InsertRow) 지점 누락** /
**WARN** = AS-IS 지점 수 > TO-BE(트리거 부족 의심) 또는 대응 콤보 미식별 / **PASS** = 그 외

## 종합 — FAIL **0** / WARN **9** / PASS **9** (화면 1개)

## DMF0003 (FAIL 0 / WARN 9 / PASS 9)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0003_MktFcst/DMF0003_MktFcst.cs (7143행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 3개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| AS_FROM_SITE | AS_FROM_SITE | 3 | 6 | 3 | 0 | O | ✅ PASS |  |
| AS_INCOTERMS | AS_INCOTERMS | 1 | 2 | 0 | 1 | - | ✅ PASS |  |
| DM_CUSTOMS_HANDBOOK | CustomsHandbook | 1 | 1 | 2 | 0 | O | ✅ PASS |  |
| DM_PLANNER_EDIT_FLAG | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DM_UI_EDITABLE_DIVISION | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DM_VMI_YN | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DefaultBucketDay | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| EndCustomerByDivision40 | - | 1 | 2 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| EndCustomerByDivisionDeptAuth | EndCustomerByDivisionDeptAuth | 1 | 2 | 3 | 0 | O | ✅ PASS |  |
| FCST_TYPE | FcstType | 2 | 5 | 2 | 0 | O | ✅ PASS |  |
| MktFcstEditMeasure | MktFcstEditMeasure | 4 | 12 | 0 | 1 | - | ⚠ WARN | AS-IS 이벤트 4종 > TO-BE 트리거 0 — 부족 의심 |
| PlantSiteByItem | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SCP_PLANNER_EDIT_FLAG | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SalesPlant | - | 1 | 2 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SiteByEndCustomer | SiteByEndCustomer | 5 | 7 | 3 | 0 | O | ✅ PASS | AS-IS 5지점 ↔ TO-BE **반응형 구독 1개**로 대체 — queryKey 파라미터 변화 시 자동 재조회 (메타 반응형 재조회: divisionId); (메타 반응형 재조회: mnuId) |
| SiteByEndCustomer40 | ScmSitebyEndCustomer40 | 3 | 3 | 0 | 1 | - | ✅ PASS | AS-IS 3지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| SiteByEndCustomerAuth | SiteByEndCustomerAuth | 1 | 3 | 3 | 0 | O | ✅ PASS |  |
| TeamByDivisionAuth | TeambyDivisionAuth | 1 | 1 | 3 | 0 | O | ✅ PASS |  |

### 상세 (FAIL/WARN)

- **DM_PLANNER_EDIT_FLAG** → `-` · AS-IS 호출 메서드: EditButton
  - TO-BE 트리거: 없음
- **DM_UI_EDITABLE_DIVISION** → `-` · AS-IS 호출 메서드: EditButton
  - TO-BE 트리거: 없음
- **DM_VMI_YN** → `-` · AS-IS 호출 메서드: spdMain_Changed
  - TO-BE 트리거: 없음
- **DefaultBucketDay** → `-` · AS-IS 호출 메서드: FindData · 주석처리 1건(사문=미이관 파리티)
  - TO-BE 트리거: 없음
- **EndCustomerByDivision40** → `-` · AS-IS 호출 메서드: spdMain_ComboSelChange · 주석처리 4건(사문=미이관 파리티)
  - TO-BE 트리거: 없음
- **MktFcstEditMeasure** → `MktFcstEditMeasure` · AS-IS 호출 메서드: Form_Load, spdMain_CellClick, spdMain_Changed, spdMain_ClipboardPasted, spdMain_ComboSelChange · 주석처리 2건(사문=미이관 파리티)
  - TO-BE 트리거: 없음
- **PlantSiteByItem** → `-` · AS-IS 호출 메서드: spdMain_CellClick
  - TO-BE 트리거: 없음
- **SCP_PLANNER_EDIT_FLAG** → `-` · AS-IS 호출 메서드: EditButton
  - TO-BE 트리거: 없음
- **SalesPlant** → `-` · AS-IS 호출 메서드: spdMain_Changed
  - TO-BE 트리거: 없음

## 한계 (은폐 없음)
- AS-IS 명명 헬퍼는 **1단계**만 해소한다(헬퍼 안의 헬퍼는 미추적).
- TO-BE 트리거 추출은 `binding === 'X'` 정적 매칭 — 동적 분기(맵/스위치)는 누락될 수 있다.
- 이름이 다른 대응 콤보는 정규화(영숫자 소문자) 매칭이 실패하면 '미식별 WARN' 으로 노출한다(조용한 통과 없음).
- 주석 처리된 AS-IS 호출은 **제외하되 건수를 표에 기록**한다 — 사문 = 미이관이 파리티.

