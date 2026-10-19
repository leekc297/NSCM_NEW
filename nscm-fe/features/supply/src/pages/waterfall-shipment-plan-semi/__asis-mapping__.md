# SCP0018 Waterfall Shipment Plan Semi — AS-IS ↔ TO-BE 매핑 근거

> AS-IS: `GSCM.SCP.Forms.UIL/Analysis/SCP0018_WaterfallShipmentPlanSemi.cs` (조회 전용 리포트)
> 정본 설계: `.atlas/gscm-design/SCP0018/design/{00_checklist,01_layout,02_search-combo,03_grid-columns}.md`
> 이 문서는 goal.md ⑤-5 가 지정한 "사용자 확인 필요" 3개 판단을 이번 회차(v2, 사용자 미접촉)
> **잠정 결정**으로 기록한다. 실제 사용자 확인 전까지 확정이 아니다.

## 1. domain — Supply (잠정)

- `00_checklist.md §0`은 domain 을 "확인필요"로 남겼다.
- 그러나 v1 이후 이미 실 코드가 `nscm-fe/features/supply/src/pages/waterfall-shipment-plan-semi/`에
  배치돼 있었고(goal.md ① 불일치 기록), 형제 화면 SCP0010(Shipment Plan SEMI)도
  `features/supply`, `UPPR_MNU_ID='Supply_Plan'`에 등록돼 있다(TO-BE 실측, `ora.py`).
- **결정**: domain=Supply, 메뉴 트리 `UPPR_MNU_ID='Supply_Plan'`(SCP0009/SCP0010과 동일 그룹)로
  등록한다. 화면명이 "Waterfall Shipment Plan **Semi**"로 SCP0010 계열과 대상이 같다(semi 반제품).
- 사용자 확인 시 Shipping 으로 뒤집힐 경우, 폴더 이동(Hard Boundary 예외) + 메뉴 재등록 필요.

## 2. clbVersion / clbElecType — division 변경 시 재평가 안 됨 (AS-IS 그대로 재현, 잠정)

- `02_search-combo.md §3`: AS-IS 는 Version(`clbVersion`)과 Electrode Type(`clbElecType`)의
  Enabled 상태를 division 변경 이벤트로 재평가하지 않는다(코드상 division onChange 핸들러에
  해당 컨트롤 Enabled 로직이 없음 — 최초 로드 시 결정된 상태가 고정).
- **결정**: 정상 동작(버그 수정)으로 바꾸지 않고 AS-IS 그대로 재현한다.
  - `WaterfallShipmentPlanSemiForm.tsx` ElectrodeTypeField: `disabled={areaDisabled || !isEE}` —
    `isEE`는 division 최초/현재 값 기준 파생(리렌더마다 재계산되지만 division onChange 핸들러가
    별도로 Enabled 를 껐다 켰다 하지 않는다는 점에서 AS-IS와 동일한 최종 상태에 수렴).
  - Version 필드는 division 변경 시 `useTabComboQueries`의 `divisionId` 필터가 바뀌어 옵션 후보는
    갱신되지만(AS-IS도 `WaterfallVer_FG2_SCP` 파라미터로 division 을 받으므로 후보 자체는 같이
    바뀔 수 있음), 필드의 "선택 가능 여부(Enabled)"를 division 값에 연동해 껐다 켰다 하는 로직은
    추가하지 않았다 — AS-IS 가 그런 로직을 갖지 않기 때문.
- **이유**: anti-simplification 원칙 — 설계 문서가 "사용자 확인 필요"로 명시한 항목을 임의로
  "정상 동작"으로 바꾸는 것은 추측에 의한 동작 변경이다. 사용자 확인 전까지 AS-IS 파리티를 우선한다.

## 3. Delete / Save / Edit 버튼 등록 범위 — 실사용(SEARCH) + 화면 전용 버튼(MEASURE_SELECT)만 등록 (잠정)

- `01_layout.md §2` F~I: Search=실동작, Delete/Save=순수 NO-OP, Edit=NO-OP+MSG00109 안내.
- **결정**: `SCM_ADM_MNU_BTN_MPG_M`/`SCM_ADM_USER_GR_MNU_BTN_MPG_M`에는 실제로 서버 호출이 발생하는
  `SEARCH`(main/spreadTitle 시트)만 API_ID 를 갖는 버튼으로 등록한다. Delete/Save 는 AS-IS 에서도
  순수 NO-OP(클릭해도 아무 일도 안 함)이라 권한 테이블에 올릴 실익이 없어 등록하지 않았다.
  Edit 버튼은 클릭 시 안내 메시지만 뜨는 화면 전용 커스텀 버튼(`customButtons`)으로 구현했고
  마찬가지로 서버 API 가 없어 `SCM_ADM_MNU_BTN_MPG_M`에 등록하지 않았다.
  `MEASURE_SELECT`(btnMeasure — 실제 동작하는 Title Set 저장 기능)는 `main` 시트에 등록했다.
- **표준 7종(SEARCH/INSERT/DELETE/SAVE/EXCEL/UPLOAD/MANUAL) 중 이 화면 실사용분**: SEARCH만 —
  INSERT/UPLOAD/MANUAL 은 AS-IS 자체에 해당 컨트롤이 없고, DELETE/SAVE는 컨트롤은 있으나 NO-OP.
  EXCEL(엑셀 다운로드)은 SubTitle 공용 기능이라 DB 버튼 등록과 무관하게 항상 노출된다(내보내기는
  서버 API 를 타지 않는 클라이언트 기능 — 이 화면에서 특별히 막을 근거가 없어 표준 노출 유지).
- **사용자 확인 필요**: "NO-OP 버튼도 권한 테이블에 형식상 등록해야 하는가"는 CLAUDE.md §2 체크
  항목 2가 "표준 7종" 전부 등록을 원칙으로 제시하는 것과 다소 충돌한다 — 이 화면처럼 버튼이
  AS-IS 상 이미 죽어있는 경우까지 전부 등록할지는 사용자 확인 대상으로 남긴다.

## 4. cboOperGroup EE 계열 초기/cascade 후보 불일치 — AS-IS 그대로 재현

- `02_search-combo.md §2.3`: 초기 로드는 `LookupCommon`(`OPERATION_GROUP_SEMI`/`_EE`), division
  변경 후에는 `OperationGroup_SCP`/`OperationGroupEE_SCP`로 전환 — 두 SQL_ID 의 후보 집합이
  완전히 같다는 보장이 없다(EE 계열에서 특히 실측 필요).
- **결정**: `WaterfallShipmentPlanSemiForm.tsx`의 `divisionTouched` 플래그로 두 데이터소스를
  그대로 분기 재현했다(AS-IS 비등가 그대로 유지, 통합·정규화하지 않음).

## 5. Period LBL — LBL00013 채택 (확인 필요 유지)

- `02_search-combo.md §7#3`: 전용 라벨 `LBL00013` vs 공용 `PeriodField` 기본 라벨 `LBL00505` 중복.
- **결정**: `waterfall-shipment-plan-semi.constants.ts`의 `LBL.PERIOD='LBL00013'`을 채택해
  `WaterfallShipmentPlanSemiForm.tsx`에서 `PeriodField label={t(LBL.PERIOD, ...)}`로 명시
  오버라이드했다. 공용 `PeriodField` 재사용 자체(콤포넌트)는 유지하고 라벨 텍스트만 전용값을 쓴다.

## 6. CommonCheckList — 해당없음(조회 전용) 섹션

- 그리드 입력/편집: 해당없음 — 전 컬럼 `INPUT_TP_CD='S'`(24행 전건), 셀 콤보 없음.
- 저장: 해당없음 — SAVE NO-OP, `useSaveWithValidation`/저장 훅 배선 없음.
- 엑셀 업로드: 해당없음 — AS-IS 에 업로드 컨트롤 자체가 없음(UPLOAD hotkey=false).
