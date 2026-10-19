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
  { key: 'TO_SITE_NAME', header: 'To Site', width: 120, align: 'L' },
  { key: 'BOH', header: 'BOH (To Site)', width: 90, align: 'R' },
  { key: 'INCOTERMS', header: 'Incoterms', width: 90, align: 'L' },
  { key: 'DEPT_NAME_KO', header: 'Team', width: 90, align: 'L' },
  { key: 'PROJECT_CODE', header: 'Project Code', width: 100, align: 'L' },
  { key: 'PROJECT_NAME', header: 'Project', width: 120, align: 'L' },
  { key: 'PROJECT_OWNER', header: 'Project Owner', width: 100, align: 'L' },
  { key: 'ITEM_TYPE', header: 'Item Type', width: 90, align: 'L' },
  { key: 'ORIGIN_FROM_DIVISION_ID', header: 'Origin From Div', width: 90, align: 'L' }, // division EE* 만 표시
  { key: 'FROM_SITE_NAME', header: 'From Site', width: 120, align: 'L' },
  { key: 'TRANSPORT_MODE', header: 'Trans Mode', width: 90, align: 'L' },
  { key: 'LT_DAY', header: 'L/T(Day)', width: 70, align: 'R' },
  { key: 'PRODUCT_GROUP', header: 'Product Group', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'CELL_MODEL', header: 'Cell Model', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'CELL_PACK_COUNT', header: 'Cell Pack Count', width: 100, align: 'R' }, // division==='40' 만 표시
  { key: 'APPLICATION', header: 'Application', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'MIN_CAPACITY', header: 'Min Capacity', width: 100, align: 'R' }, // division==='40' 만 표시
  { key: 'SOLDTO_CUSTOMER', header: 'Sold Customer', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'MODEL_SPEC', header: 'Model Spec', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'MODEL_VERSION', header: 'Model Version', width: 100, align: 'L' }, // division==='40' 만 표시
  { key: 'SPEC_VERSION', header: 'Spec & Version', width: 110, align: 'L' }, // division==='40' 만 표시
  { key: 'ENERGY', header: 'Energy kWh', width: 100, align: 'R' }, // division==='82' 만 값 존재
  { key: 'MEASURE', header: 'Measure', width: 0, visible: false },
  { key: 'MEASURE_LABEL', header: 'Measure', width: 130, align: 'L', frozen: true }, // FIXED — Freeze 경계 앵커
  { key: 'MEASURE_ORDER_NO', header: 'MEASURE_ORDER_NO', width: 0, visible: false },
  { key: 'BIZ_TYPE', header: 'Biz. Type', width: 0, visible: false },
  { key: 'TO_SITE', header: 'To Site', width: 0, visible: false },
  { key: 'FROM_SITE', header: 'From Site', width: 0, visible: false },
  { key: 'SHIP_FROZEN', header: 'SHIP_FROZEN', width: 0, visible: false },
  { key: 'BOD_ID', header: 'BOD ID', width: 0, visible: false },
  { key: 'KEY_IDX', header: 'KEY_IDX', width: 0, visible: false },
  { key: 'BOD_FROM_YYYYMMDD', header: 'BOD_FROM_YYYYMMDD', width: 0, visible: false },
  { key: 'BOD_TO_YYYYMMDD', header: 'BOD_TO_YYYYMMDD', width: 0, visible: false },
  { key: 'PLAN_START_YYYYMMDD', header: 'plan_start_yyyymmdd', width: 0, visible: false },
  { key: 'PLAN_TYPE', header: 'plan_type', width: 0, visible: false },
  { key: 'SEQ', header: 'seq', width: 0, visible: false },
  { key: 'TO_YYYYMMDD', header: 'to_yyyymmdd', width: 0, visible: false },
];

// division==='40' 조건부 표시 컬럼 (design 03 §1.A gridSignals R-B)
export const DIVISION_40_ONLY_COLUMNS = [
  'EXTRA_SPEC',
  'PRODUCT_GROUP',
  'CELL_MODEL',
  'CELL_PACK_COUNT',
  'APPLICATION',
  'MIN_CAPACITY',
  'SOLDTO_CUSTOMER',
  'MODEL_SPEC',
  'MODEL_VERSION',
  'SPEC_VERSION',
] as const;
// division EE* (Substring(0,2)==='EE') 조건부 표시 컬럼 (design 03 §1.A gridSignals R-A)
export const DIVISION_EE_ONLY_COLUMNS = [
  'ELECTRODE_TYPE',
  'ORIGIN_TO_DIVISION_ID',
  'ORIGIN_FROM_DIVISION_ID',
] as const;
// Freeze 경계(SmartColMerge 병합 대상 = 이 컬럼까지, design 03 §3 R-I) — MEASURE_LABEL 포함 그 앞까지
export const FREEZE_ANCHOR_COLUMN = 'MEASURE_LABEL';
