# AS-IS ↔ TO-BE 콤보 **호출 지점 수(N:N)** 대사

> 실행 2026-08-12 01:29 · `_artifacts/_diagnostics/combo_callsite_parity.py` · **읽기 전용**
> 룰 = hook #117 §5.12. SQL·파라미터가 맞아도 **부르는 시점이 빠지면 조용히 죽는다.**
> 섹션 7·E2E D2축이 못 보는 축 — 이 대사표가 유일한 방어선이다.

판정: **FAIL** = 배선 자체 부재(AS-IS ≥2 지점) 또는 **행 생성(InsertRow) 지점 누락** /
**WARN** = AS-IS 지점 수 > TO-BE(트리거 부족 의심) 또는 대응 콤보 미식별 / **PASS** = 그 외

## 종합 — FAIL **0** / WARN **0** / PASS **8** (화면 1개)

## DMF0049 (FAIL 0 / WARN 0 / PASS 8)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0049_Sales_ETC_Reports/DMF0049_Sales_ETC_Reports.cs (1727행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| CALENDAR_YYYY | CALENDAR_YYYY | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| DMF0005_REPORT_GROUP2 | DMF0005_REPORT_GROUP2 | 2 | 3 | 1 | 1 | - | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| DMF0044_DEPARTMENT_TEAM | DMF0044_DEPARTMENT_TEAM | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| DMF0044_DEPARTMENT_TEAM2 | DMF0044_DEPARTMENT_TEAM2 | 2 | 2 | 2 | 0 | O | ✅ PASS |  |
| DM_LOOKUP_DIV | DM_LOOKUP_DIV | 2 | 2 | 2 | 1 | O | ✅ PASS |  |
| END_CUST_REPORT | END_CUST_REPORT | 1 | 1 | 1 | 0 | O | ✅ PASS |  |
| EndCustomerByDivisionDeptAuth | - | 1 | 1 | 0 | 0 | - | ✅ PASS | 이식 안 함(사유 기재): AS-IS L989(InsertRow, 81계열)가 END_CUSTOMER 컬럼에 권한판을 붙이지만 그 컬럼은 AS-IS·TO-BE 메타 모두 VISIBLE_FLAG='N'(숨김) — 사용자가 편집할 수 없어 적용 대상 없음. (참고: DMF0042 실측으로 권한판 자체가 '교체 금지' 확정된 계열) |
| SiteByEndCustomer | - | 1 | 1 | 0 | 0 | - | ✅ PASS | 이식 안 함(사유 기재): AS-IS L1410 이 END_CUSTOMER 변경 시 SCM_SITE_ID 에 붙이지만, TO-BE·AS-IS 메타 모두 SCM_SITE_ID = CTRL 공백 + VISIBLE_FLAG='N' 이고 **트리거인 END_CUSTOMER 도 숨김**이라 이벤트 자체가 발생하지 않는다 — 적용 대상 없음 |

## 한계 (은폐 없음)
- AS-IS 명명 헬퍼는 **1단계**만 해소한다(헬퍼 안의 헬퍼는 미추적).
- TO-BE 트리거 추출은 `binding === 'X'` 정적 매칭 — 동적 분기(맵/스위치)는 누락될 수 있다.
- 이름이 다른 대응 콤보는 정규화(영숫자 소문자) 매칭이 실패하면 '미식별 WARN' 으로 노출한다(조용한 통과 없음).
- 주석 처리된 AS-IS 호출은 **제외하되 건수를 표에 기록**한다 — 사문 = 미이관이 파리티.

