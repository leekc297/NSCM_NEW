// ⭐ DMF0044 — 조회/저장/팝업 진입 검증 (분석서 Validation 14건 중 게이트 계열 집약).
//   V-게이트: Version 필수 (조회 MSG00283 / 저장·팝업 MSG00688[AS-IS 00281]) + Data Type ALL 차단(MSG00681)
//   + pending 차단(MSG00680 — Exchange 진입, AS-IS 00142 용법).
import { DATA_TYPE, MSG } from '../sales-reports.constants';
import type { ValidationResult } from '../sales-reports.types';

// 조회 전 — Version 필수 (FindData L437 MSG00283)
export const validateFind = (versionNo: string): ValidationResult =>
  versionNo.trim() === '' ? { ok: false, msgId: MSG.REQUIRE_VERSION_FIND } : { ok: true };

// 저장/팝업 진입 전 — Version 필수 (SaveData L506 / btnExchangeRate L1437 / btnTextbox L1472 —
//   AS-IS MSG00281 → 신규 MSG00688)
export const validateVersionForAction = (versionNo: string): ValidationResult =>
  versionNo.trim() === '' ? { ok: false, msgId: MSG.REQUIRE_VERSION_ACTION } : { ok: true };

// 편집/저장 게이트 — Data Type ALL 차단 (EditButton L272~276 / SaveData L512 — MSG00321 → MSG00681)
export const validateNotAll = (dataType: string): ValidationResult =>
  dataType === DATA_TYPE.ALL ? { ok: false, msgId: MSG.ALL_BLOCK } : { ok: true };

// pending 변경 차단 — Exchange 팝업 진입 (btnExchangeRate L1431 !IsLock — AS-IS 00142 → MSG00680)
export const validateNoPending = (hasPending: boolean): ValidationResult =>
  hasPending ? { ok: false, msgId: MSG.PENDING_BLOCK } : { ok: true };
