# GEN_NOTES — SCP0096 Shipment_Working_Day_OSP (TobeGen 2026-10-19)

생성 대상: `features/supply/src/pages/shipment-working-day-osp/` (To-Be 메뉴 메타 확정: 상위 Supply_Master, MNU_URL shipment-working-day-osp, USE_YN=Y)
As-is grid_mode: HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경) · 시트 1 (+팝업 0) · 조회조건 6 · 버튼 2 · 이벤트 8 · 엔드포인트 5

## 기계가 끝낸 것 (손대지 말 것 — 사전 규칙)
- constants(MENU_ID/SHEETS/RESPONSE_SET/DIVISION), store(검색 파라미터·메타 컬럼·저장 조회조건), Page 조합, Form 필드 6개, Grid(DataGrid), __asis-mapping__.md 초기본, register.json

## Claude Code 가 채울 것 (TODO(이식) 표시 지점만)
1. 라벨 코드: 자동 매칭 6/6 (To-Be 코드 사용 빈도 사전 rules/lbl_codes.csv). 미확정 `LBL?????` 0곳: 없음 → 메시지 마스터(SCM_ADM_MSG_M) 조회 후 코드 기입, 없으면 신규 채번 요청. Doc/tobefacts/db/msg_master.csv 가 있으면 생성기가 자동 조회
2. 콤보ID 4개: cboDivision→'Division*', clbPlantSite→'PlantSite', cboInputValue→'InputValue', cboDayWeek→'Dayoftheweek' — As-is 소스는 Fact Pack endpoints 의 UP_FX_GetCommonDataList_* / meta_reads 참조
3. 이벤트 핸들러 로직 7개 (flow.csv 의 호출 체인 그대로)
4. 팝업/모달: 없음
5. 스프레드 1개 → spdMain→Grid(Shipment Working Day OSP)
6. division 변형: 40, 81, 82, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC — grid_effective 의 division 열이 비어있지 않은 컬럼은 표시 조건 분기
7. 검증/표현식: hooks/useShipmentWorkingDayOspValidation.ts V-마커 0건(+팝업 0) · useShipmentWorkingDayOspExpression.ts E-마커 0건 — apply 본문 채우기 (마커 수 = validation.md 행 수, 게이트 V01)
8. register.json → P_REGISTER_SCREEN (클라우드) → `pnpm gen:procedures` → procedures.d.ts 반영 후 타입 느슨 구간 제거

## 사전에 없던 것 (룰 보완 후보 — rules/*.csv 에 추가)
- 없음

