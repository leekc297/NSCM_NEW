// 정보컬럼 constants fallback — admin SCM_MST_SHEET_COLUMNS 가 이미 등록돼 있으므로(design 03 §0,
//   80행 확인) 화면은 fetchStaticColumns 로 admin 메타를 우선 사용한다. 이 파일은 fetch 실패/지연 시의
//   최소 fallback 이며, 편집가능 여부(INPUT_TP_CD)는 전건 'S'(읽기전용) — 동적 pivot 컬럼만 편집대상(§0).
//   근거: .atlas/gscm-design/SCP0009/design/03_grid-columns.md §1.A/§1.B/§1.C (DB 실측 컬럼 순서 그대로).
import type { MainColumnMeta } from './shipment-plan-fg.types';

// ===== spdMain(메인) — SHEET_NAME='Shipment Request' 44건 (design 03 §1.A) =====
//   division 조건부 visible 은 utils/shipment-plan-fg.editLock.ts 의 runtime 파생(admin 메타 밖의 축).
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division', width: 70, align: 'C' },
  { key: 'BIZ_TYPE_NAME', header: 'Operation Group', width: 110, align: 'L' },
  { key: 'ITEM_ID', header: 'Model', width: 110, align: 'L' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 100, align: 'L' },
  { key: 'EXTRA_SPEC', header: 'Extra Spec', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', width: 100, align: 'L' }, // division EE* 만 표시
  { key: 'ORIGIN_TO_DIVISION_ID', header: 'Origin To Div', width: 90, align: 'L' }, // division EE* 만 표시
  { key: 'to_site_name', header: 'To Site', width: 120, align: 'L' },
  { key: 'boh', header: 'BOH (To Site)', width: 90, align: 'R' },
  { key: 'incoterms', header: 'Incoterms', width: 90, align: 'L' },
  { key: 'DEPT_NAME_KO', header: 'Team', width: 90, align: 'L' },
  { key: 'project_code', header: 'Project Code', width: 100, align: 'L' },
  { key: 'project_name', header: 'Project', width: 120, align: 'L' },
  { key: 'project_owner', header: 'Project Owner', width: 100, align: 'L' },
  { key: 'ITEM_TYPE', header: 'Item Type', width: 90, align: 'L' },
  { key: 'ORIGIN_FROM_DIVISION_ID', header: 'Origin From Div', width: 90, align: 'L' }, // division EE* 만 표시
  { key: 'from_site_name', header: 'From Site', width: 120, align: 'L' },
  { key: 'transport_mode', header: 'Trans Mode', width: 90, align: 'L' },
  { key: 'lt_day', header: 'L/T(Day)', width: 70, align: 'R' },
  { key: 'product_group', header: 'Product Group', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'cell_model', header: 'Cell Model', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'cell_pack_count', header: 'Cell Pack Count', width: 100, align: 'R' }, // division==='40' 만 표시
  { key: 'application', header: 'Application', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'min_capacity', header: 'Min Capacity', width: 100, align: 'R' }, // division==='40' 만 표시
  { key: 'soldto_customer', header: 'Sold Customer', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'model_spec', header: 'Model Spec', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'model_version', header: 'Model Version', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'spec_version', header: 'Spec & Version', width: 110, align: 'L' }, // division==='40' 만 표시
  { key: 'ENERGY', header: 'Energy kWh', width: 100, align: 'R' }, // division==='82' 만 값 존재
  { key: 'measure', header: 'Measure', width: 0, visible: false },
  { key: 'measure_label', header: 'Measure', width: 130, align: 'L', frozen: true }, // FIXED — Freeze 경계 앵커
  { key: 'measure_order_no', header: 'MEASURE_ORDER_NO', width: 0, visible: false },
  { key: 'biz_type', header: 'Biz. Type', width: 0, visible: false },
  { key: 'to_site', header: 'To Site', width: 0, visible: false },
  { key: 'from_site', header: 'From Site', width: 0, visible: false },
  { key: 'SHIP_FROZEN', header: 'SHIP_FROZEN', width: 0, visible: false },
  { key: 'bod_id', header: 'BOD ID', width: 0, visible: false },
  { key: 'KEY_IDX', header: 'KEY_IDX', width: 0, visible: false },
  { key: 'BOD_FROM_YYYYMMDD', header: 'BOD_FROM_YYYYMMDD', width: 0, visible: false },
  { key: 'BOD_TO_YYYYMMDD', header: 'BOD_TO_YYYYMMDD', width: 0, visible: false },
  { key: 'plan_start_yyyymmdd', header: 'plan_start_yyyymmdd', width: 0, visible: false },
  { key: 'plan_type', header: 'plan_type', width: 0, visible: false },
  { key: 'seq', header: 'seq', width: 0, visible: false },
  { key: 'to_yyyymmdd', header: 'to_yyyymmdd', width: 0, visible: false },
];

// division==='40' 조건부 표시 컬럼 (design 03 §1.A gridSignals R-B)
export const DIVISION_40_ONLY_COLUMNS = [
  'EXTRA_SPEC',
  'product_group',
  'cell_model',
  'cell_pack_count',
  'application',
  'min_capacity',
  'soldto_customer',
  'model_spec',
  'model_version',
  'spec_version',
] as const;
// division EE* (Substring(0,2)==='EE') 조건부 표시 컬럼 (design 03 §1.A gridSignals R-A)
export const DIVISION_EE_ONLY_COLUMNS = [
  'ELECTRODE_TYPE',
  'ORIGIN_TO_DIVISION_ID',
  'ORIGIN_FROM_DIVISION_ID',
] as const;
// Freeze 경계(SmartColMerge 병합 대상 = 이 컬럼까지, design 03 §3 R-I) — measure_label 포함 그 앞까지
export const FREEZE_ANCHOR_COLUMN = 'measure_label';

// ===== spdPeggingInfo(서브) — SHEET_NAME='Pegging Info' 24건, 전건 읽기전용 (design 03 §1.B) =====
//   8개(problem_seq/REQUEST_TIME/RESPONSE_TIME/OPERATION_GROUP 중복라벨/ELECTRODE_TYPE·To Site 중복라벨/
//   ENG_PROBLEM_TYPE/ENG_PROBLEM_DESC/problem_qty)는 SP 미반환 — 원천 확인 필요(design 03 §6#1).
export const PEGGING_COLUMNS: MainColumnMeta[] = [
  { key: 'problem_seq', header: 'Problem Seq', width: 90, align: 'R' },
  { key: 'PEGGING_OPERATION', header: 'Pegging Operation', width: 120, align: 'L' },
  { key: 'biz_type_name', header: 'Operation Group', width: 110, align: 'L' },
  { key: 'item_id', header: 'Model', width: 110, align: 'L' },
  { key: 'ORIGIN_FROM_DIVISION_ID', header: 'Origin From Div', width: 100, align: 'L' },
  { key: 'FROM_SITE', header: 'From Site', width: 110, align: 'L' },
  { key: 'ORIGIN_TO_DIVISION_ID', header: 'Origin To Div', width: 100, align: 'L' },
  { key: 'to_site', header: 'To Site', width: 110, align: 'L' },
  { key: 'DUE_DATE', header: 'Due Date', width: 100, align: 'C' },
  { key: 'REQUEST_TIME', header: 'Request Date', width: 100, align: 'C' },
  { key: 'RESPONSE_TIME', header: 'Response Date', width: 100, align: 'C' },
  { key: 'PLAN_START_DATE', header: 'Start Date', width: 100, align: 'C' },
  { key: 'PLAN_END_DATE', header: 'End Date', width: 100, align: 'C' },
  { key: 'OPERATION_GROUP', header: 'Operation Group', width: 110, align: 'L' },
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', width: 100, align: 'L' },
  { key: 'REQUIRED_QTY', header: 'Required Qty', width: 100, align: 'L', visible: false },
  { key: 'PLANNED_QTY', header: 'Planned Qty', width: 100, align: 'R' },
  { key: 'PROBLEM_TYPE', header: 'Problem Type', width: 100, align: 'L', visible: false },
  { key: 'LPST', header: 'LPST', width: 90, align: 'L' },
  { key: 'STOCK_PLAN_LOT_ID', header: 'Stock Plan Lot Id', width: 120, align: 'L' },
  // design 03 §1.B #21 "to_site 중복 라벨" 은 DB 컬럼명 자체가 #8 과 같아(대소문자 구분만 다를 가능성)
  //   fallback 목록에서 중복 바인딩을 만들 수 없다 — admin 메타(fetchStaticColumns) 원천이 정본이고,
  //   이 fallback 은 #8 하나로만 소진한다. 확인 필요(design 03 §6#1) — __asis-mapping__.md 참조.
  { key: 'ENG_PROBLEM_TYPE', header: 'Problem Type', width: 100, align: 'L' },
  { key: 'ENG_PROBLEM_DESC', header: 'Problem Desc', width: 150, align: 'L' },
  { key: 'problem_qty', header: 'Problem Qty', width: 100, align: 'R' },
];

// ===== spdPlanProblem(서브) — SHEET_NAME='Plan Problem' 12건, 전건 읽기전용 (design 03 §1.C) =====
//   6개(nick_name/EXTRA_SPEC/ELECTRODE_TYPE/ORIGIN_TO_DIVISION_ID/boh/to_site_name)는 SP 미반환 —
//   더블클릭한 부모(메인 그리드) 행 컨텍스트 복사로 추정되나 코드 특정 못함(design 03 §6#2, 확인 필요).
export const PROBLEM_COLUMNS: MainColumnMeta[] = [
  { key: 'problem_seq', header: 'Problem Seq', width: 90, align: 'R' },
  { key: 'ENG_PROBLEM_TYPE', header: 'Problem Type', width: 100, align: 'L' },
  { key: 'ENG_PROBLEM_DESC', header: 'Problem Desc', width: 150, align: 'L' },
  { key: 'nick_name', header: 'Nick Name', width: 100, align: 'L' },
  { key: 'EXTRA_SPEC', header: 'Extra Spec', width: 100, align: 'L' },
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', width: 100, align: 'L' },
  { key: 'ORIGIN_TO_DIVISION_ID', header: 'Origin To Div', width: 100, align: 'L' },
  { key: 'REQUEST_TIME', header: 'Request Date', width: 100, align: 'C' },
  { key: 'RESPONSE_TIME', header: 'Response Date', width: 100, align: 'C' },
  { key: 'boh', header: 'BOH (To Site)', width: 90, align: 'R' },
  { key: 'problem_qty', header: 'Problem Qty', width: 100, align: 'R' },
  { key: 'to_site_name', header: 'To Site', width: 110, align: 'L' },
];
