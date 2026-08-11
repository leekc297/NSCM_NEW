# AS-IS ↔ TO-BE 콤보 **호출 지점 수(N:N)** 대사

> 실행 2026-08-10 05:40 · `_artifacts/_diagnostics/combo_callsite_parity.py` · **읽기 전용**
> 룰 = hook #117 §5.12. SQL·파라미터가 맞아도 **부르는 시점이 빠지면 조용히 죽는다.**
> 섹션 7·E2E D2축이 못 보는 축 — 이 대사표가 유일한 방어선이다.

판정: **FAIL** = 배선 자체 부재(AS-IS ≥2 지점) 또는 **행 생성(InsertRow) 지점 누락** /
**WARN** = AS-IS 지점 수 > TO-BE(트리거 부족 의심) 또는 대응 콤보 미식별 / **PASS** = 그 외

## 종합 — FAIL **1** / WARN **1** / PASS **4** (화면 1개)

## DMF0044 (FAIL 1 / WARN 1 / PASS 4)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0044_Sales_Reports/DMF0044_Sales_Reports.cs (1483행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| CALENDAR_YYYY | CALENDAR_YYYY | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| DMF0005_REPORT_GROUP2 | DMF0005_REPORT_GROUP2 | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| DMF0044_DEPARTMENT_TEAM | DMF0044_DEPARTMENT_TEAM | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| DMF0044_DEPARTMENT_TEAM2 | DMF0044_DEPARTMENT_TEAM2 | 1 | 1 | 1 | 0 | - | ⛔ FAIL | AS-IS 에 **행 생성 지점**(InsertRow)이 있고 콤보가 행 종속 토큰(divisionId)을 갖는데 TO-BE 신규행 프라이밍 없음 — 메타 자동 바인딩은 렌더 1회라 대체 불가 |
| DMF0044_ETC_SALE_RESULT_TYPE_40 | DMF0044_ETC_SALE_RESULT_TYPE_40 | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| DMF0044_MDF_ENDCUST_REPORT | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |

### 상세 (FAIL/WARN)

- **DMF0044_DEPARTMENT_TEAM2** → `DMF0044_DEPARTMENT_TEAM2` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: (상수 맵 ROW_COMBO_IDS 경유 일괄 구독)
- **DMF0044_MDF_ENDCUST_REPORT** → `-` · AS-IS 호출 메서드: spdMain_Changed
  - TO-BE 트리거: 없음

## 한계 (은폐 없음)
- AS-IS 명명 헬퍼는 **1단계**만 해소한다(헬퍼 안의 헬퍼는 미추적).
- TO-BE 트리거 추출은 `binding === 'X'` 정적 매칭 — 동적 분기(맵/스위치)는 누락될 수 있다.
- 이름이 다른 대응 콤보는 정규화(영숫자 소문자) 매칭이 실패하면 '미식별 WARN' 으로 노출한다(조용한 통과 없음).
- 주석 처리된 AS-IS 호출은 **제외하되 건수를 표에 기록**한다 — 사문 = 미이관이 파리티.

