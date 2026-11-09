# SCP0016 Shipment Plan FG Waterfall — FE 보완 가이드 (DB MODE · 직접 수정 안 함) · 2026-11-07

## 1. I4 같은 문구 다른 코드 중복 채번 (CheckList v18 조치필요 V-c34ab6ef)
- 실측(META 11-07): t() 코드 16개 중 'Column' 문구가 LBL00309(KO/EN/CN 'Column') 로 먼저 등록돼 있는데 LBL00711(KO/EN/CN 'Column') 을 새로 채번해 사용
- TO-BE 위치: `nscm-fe/features/supply/src/pages/waterfall-shipment-plan-fg/waterfall-shipment-plan-fg.constants.ts:93` `COLUMN: 'LBL00711', // Column (ColumnLayoutModal title)`
- 변경: `COLUMN: 'LBL00309'` — 문구 동일(SCM_ADM_MSG_M 07:32 실측 KO/EN/CN 모두 'Column'). LBL00711 은 다른 화면 참조가 없으면 메타 삭제는 하지 않고(이관 취합 INSERT … NOT EXISTS 전용 #140) 미사용으로 둔다.
- 검증: Column Setting 팝업 제목 'Column' 유지 · CheckList I4 행 재측정 PASS.

## 2. K3 동적 일자 컬럼 Hide Column 무동작 (V-e0565aea · V-eeadaa8c)
- 실측(E2E 11-07 07:02): 헤더(D_20260824) 우클릭 → Hide Column → 컬럼 여전히 표시 (정적 컬럼 Hide 는 SCP0084 등에서 PASS)
- 공용 DataGrid 의 동적 컬럼 숨김 경로: `nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1110-1124` — `dynamicColumns` prop 으로 받은 컬럼은 leaf 까지 `hiddenColumns` 를 적용하고, 화면의 visible 재계산이 숨김을 되살리지 않도록 `_userHiddenColumns` 그리드 프로퍼티로 전달한다.
- 화면 쪽 확인 지점: `nscm-fe/features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgGrid.tsx:103-195`
  - 103행 `dynamicColumns = useMemo(...)` 가 DataGrid 의 `dynamicColumns` prop 으로 전달되는지(정적 columns 에 합쳐 넘기면 공용 숨김 경로를 타지 않는다)
  - 163행 이펙트(bucket/sum/조회 변경 시 visible 재계산)가 `_userHiddenColumns` 를 존중하는지 — 재계산에서 `grid['_userHiddenColumns']` 에 든 binding 은 `visible=false` 유지
- 변경 방향(화면 코드만): 동적 컬럼을 `dynamicColumns` prop 으로 넘기고, visible 재계산 시 사용자 숨김 집합을 제외. 공용 DataGrid 수정은 하지 않는다(공통 컴포넌트 수정 금지).
- 검증: D_YYYYMMDD 헤더 Hide Column → 비표시 · Unhide All → 복원 · 조회 재실행 후에도 숨김 유지(또는 공용 규약대로 초기화) · CheckList K3 행 재측정.

## 3. H4 화면샷 1920/1366 (V-74b29c26 · V-7753e74e) — 결함 아님 · 사용자 결정
- 승인 골든(11-06 22:16)은 개인화(Team 컬럼 숨김) 상태의 헤더 띠. 사용자 지시 3-2(11-07 00:11 개인화 삭제) 뒤 헤더에 Team 이 보여 띠 전체가 어긋남(diff png = 헤더 띠만 붉음).
- 조치: `python tools/Harness/verify/snap_approve.py SCP0016 --item 화면샷_1920 --item 화면샷_1366 --by <이름>` 로 재승인(사용자 결정 후).
