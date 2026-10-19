import { EDITABLE_COLUMNS } from '../shipment-lot-size.constants';

// SCP0028 편집잠금 판정 (design 03 §1·§3).
//   AS-IS 편집 상태머신: Edit(F2) SwitchLock 로 편집 4컬럼(LOT_SIZE/INCREMENT/VALID_YN/SPLIT_YN)만 해제(cs:232),
//   식별/표시(1~7)·audit(12~15)·OPERATION_GROUP_ID 는 편집모드에서도 항상 잠금(cs:234/235).
//   → TO-BE: NSCM 상시편집 표준(Edit 토글 미이식, 자매 SSP0025/SCP0005 동형) — 편집가부 = 편집 화이트리스트 컬럼
//   여부만. 조회 직후 4컬럼 즉시 편집. LockColumn 상수배열 이식 금지(hook #130), INPUT_TP_CD 메타로 파리티.

const EDITABLE = new Set<string>(EDITABLE_COLUMNS);

// 편집 화이트리스트(LOT_SIZE/INCREMENT/VALID_YN/SPLIT_YN) 컬럼만 편집 가능. 그 외는 항상 잠금.
//   OPERATION_GROUP_ID 는 셀 콤보이나 편집 화이트리스트가 아니라 잠금(코드→표시명 렌더 전용, design 03 §5.1.1).
export const isLotSizeCellEditable = (binding: string): boolean => EDITABLE.has(binding);
