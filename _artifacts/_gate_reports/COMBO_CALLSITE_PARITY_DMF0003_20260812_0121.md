# AS-IS ↔ TO-BE 콤보 **호출 지점 수(N:N)** 대사

> 실행 2026-08-12 01:21 · `_artifacts/_diagnostics/combo_callsite_parity.py` · **읽기 전용**
> 룰 = hook #117 §5.12. SQL·파라미터가 맞아도 **부르는 시점이 빠지면 조용히 죽는다.**
> 섹션 7·E2E D2축이 못 보는 축 — 이 대사표가 유일한 방어선이다.

판정: **FAIL** = 배선 자체 부재(AS-IS ≥2 지점) 또는 **행 생성(InsertRow) 지점 누락** /
**WARN** = AS-IS 지점 수 > TO-BE(트리거 부족 의심) 또는 대응 콤보 미식별 / **PASS** = 그 외

## 종합 — FAIL **0** / WARN **0** / PASS **18** (화면 1개)

## DMF0003 (FAIL 0 / WARN 0 / PASS 18)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0003_MktFcst/DMF0003_MktFcst.cs (7143행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 3개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| AS_FROM_SITE | AS_FROM_SITE | 3 | 6 | 3 | 0 | O | ✅ PASS |  |
| AS_INCOTERMS | AsIncotermsEdit | 1 | 2 | 1 | 0 | - | ✅ PASS |  |
| DM_CUSTOMS_HANDBOOK | CustomsHandbook | 1 | 1 | 2 | 0 | O | ✅ PASS |  |
| DM_PLANNER_EDIT_FLAG | Dmf0003DmPlannerEditFlag | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| DM_UI_EDITABLE_DIVISION | MktFcstEditableDivision | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| DM_VMI_YN | - | 1 | 1 | 0 | 0 | - | ✅ PASS | 이식 안 함(사유 기재): AS-IS 82×Site 변경 시 행 VMI_YN/VMI_STD_DIO 를 세팅(.cs L4114~4136)하나 그 소비처는 ①VMI-In Req 자동배분(C20201015 원복 사문) ②표시 — TO-BE 는 조회행 VMI_YN 을 GET 이 반환하고 Insert 행 measure 후보는 서버(MktFcstEditMeasure @site, SCM_MST_SITE.VMI_YN)가 가리므로 셀 세팅 자체가 불필요(표시 전용 잔재) |
| DefaultBucketDay | - | 1 | 1 | 0 | 0 | - | ✅ PASS | 이식 안 함(사유 기재): AS-IS FindData 말미 sDefaultDay 조회(.cs L1934) — TO-BE 는 division 기본 요일비트 상수(DEFAULT_BUCKET_40=MON/ETC=FRI, AS-IS SP 기본값 1:1)를 recalc defaultBucket 으로 사용. 운영에서 기본요일을 바꾸는 경우가 생기면 CMBO 등재 후 bucketBitsOfDay 로 전환(후속) |
| EndCustomerByDivision40 | - | 1 | 2 | 0 | 0 | - | ✅ PASS | 이식 안 함(사유 기재): 40 그리드 END_CUSTOMER40 셀 — admin 메타 CELL_COMBO_DATA_TYPE 자동 배선 |
| EndCustomerByDivisionDeptAuth | EndCustomerByDivisionDeptAuth | 1 | 2 | 3 | 0 | O | ✅ PASS |  |
| FCST_TYPE | FcstType | 2 | 5 | 2 | 0 | O | ✅ PASS |  |
| MktFcstEditMeasure | MktFcstEditMeasure | 4 | 12 | 0 | 1 | - | ✅ PASS | 이식 안 함(사유 기재): TO-BE 트리거는 GRID_EDIT_COMBO 맵 경유(beginningEdit 스왑 — MktFcstGrid L723~) — 정적 `binding===` 매칭이 못 보는 동적 분기. 셀 콤보 파라미터 축(§7)이 실전달을 검증 |
| PlantSiteByItem | PlantSiteByItem | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| SCP_PLANNER_EDIT_FLAG | Dmf0003ScpPlannerEditFlag | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| SalesPlant | PlantSiteByItem | 1 | 2 | 1 | 0 | - | ✅ PASS |  |
| SiteByEndCustomer | SiteByEndCustomer | 5 | 7 | 3 | 0 | O | ✅ PASS | AS-IS 5지점 ↔ TO-BE **반응형 구독 1개**로 대체 — queryKey 파라미터 변화 시 자동 재조회 (메타 반응형 재조회: divisionId); (메타 반응형 재조회: mnuId) |
| SiteByEndCustomer40 | UserSiteByEndCustomer | 3 | 3 | 1 | 0 | - | ✅ PASS | AS-IS 3지점 ↔ TO-BE **반응형 구독 1개**로 대체 — queryKey 파라미터 변화 시 자동 재조회 (반응형 재조회: deptId, divisionId, endCustomer) |
| SiteByEndCustomerAuth | SiteByEndCustomerAuth | 1 | 3 | 3 | 0 | O | ✅ PASS |  |
| TeamByDivisionAuth | TeambyDivisionAuth | 1 | 1 | 2 | 0 | O | ✅ PASS |  |

## 한계 (은폐 없음)
- AS-IS 명명 헬퍼는 **1단계**만 해소한다(헬퍼 안의 헬퍼는 미추적).
- TO-BE 트리거 추출은 `binding === 'X'` 정적 매칭 — 동적 분기(맵/스위치)는 누락될 수 있다.
- 이름이 다른 대응 콤보는 정규화(영숫자 소문자) 매칭이 실패하면 '미식별 WARN' 으로 노출한다(조용한 통과 없음).
- 주석 처리된 AS-IS 호출은 **제외하되 건수를 표에 기록**한다 — 사문 = 미이관이 파리티.

