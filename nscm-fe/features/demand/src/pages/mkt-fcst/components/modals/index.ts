// ⭐ Phase 2e POPUP 모달 barrel — MktFcst.tsx 에서 일괄 import.
export { SspSyncCompareModal, type SspSyncCompareParams } from './SspSyncCompareModal';
export { SspSyncResultModal, type SspSyncResultRow } from './SspSyncResultModal';
export { PrModal, type PrModalParams } from './PrModal';
export { PrHistoryModal, type PrHistoryParams } from './PrHistoryModal';
// (MeasureSelectModal 사본 삭제 — 2026-08-13 공용 정본 전환: features/master/src/components/measureSelectModal.
//  hook #132 §2-1 화면별 사본 금지. titleSet 'M' 저장 로직은 MktFcst.tsx onApply 소유.)
// (CustDemandAnalysisModal 제거 — 2026-07-03 PSI 패널 제거 결정. DMF0003_PSI_20260703 패키지 보존.)
// (MasterChgModal 제거 — 2026-07-13 사용자 결정: Master Change 버튼·기능 전체 삭제.)
