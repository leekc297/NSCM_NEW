// ⭐ DMF0049 — 조회/저장/편집 게이트 검증.
//   조회 전 버전(MSG00283 L528) / 저장 전 버전(MSG00688 — AS-IS 00281 L633) /
//   편집 권한(MSG00096 — DM Planner && Div≠82, EditButton L344).
import { MSG } from '../etc-sales-reports.constants';
import type { ValidationResult } from '../etc-sales-reports.types';

import { isEditBlockedGroup } from './etc-sales-reports.editLock';

export const validateFind = (versionNo: string): ValidationResult =>
  versionNo.trim() === '' ? { ok: false, msgId: MSG.REQUIRE_VERSION_FIND } : { ok: true };

export const validateVersionForAction = (versionNo: string): ValidationResult =>
  versionNo.trim() === '' ? { ok: false, msgId: MSG.REQUIRE_VERSION_ACTION } : { ok: true };

export const validateEditGate = (userGroup: string, divisionId: string): ValidationResult =>
  isEditBlockedGroup(userGroup, divisionId)
    ? { ok: false, msgId: MSG.NO_PERMISSION }
    : { ok: true };
