// ⭐ DMF0042 — 조회/저장/버킷 검증 (validation.md 99건 중 활성 메시지·silent 분기 매핑 —
//   전체 매트릭스 = __asis-mapping__.md. anti-simplification: 각 가드에 AS-IS 라인 근거 주석 보존).
//   근거(라인 = AS-IS DMF0042_1_BizPlan.cs):
//     V-S1 Division 필수 (FindData L697 MSG00097) / V-S2 기간 역전 (L705 MSG00108) /
//     V-S3 6년 초과 — 종료일 = 시작일+6년 보정 후 차단 (L711 AS-IS MSG00276 → 신설 MSG00677) /
//     V-E3 Bucket 변경 차단 — 변경분 존재 시 (cboBucketType_Click L2969 MSG00227) /
//     V-V1 필수값 division 분기 (SaveData L887~1057 — AS-IS MSG00310 용법 → 사내 MSG00429 재매핑) /
//     V-V3 변경 0건 (MSG00004) — 중복 키(MSG00043)는 조립 단계(business-plan.save.ts)에서 검증.
//   SP 내장(재구현 금지): 파생 수량/금액 산출·MERGE — 결과 passthrough alert (api 헬퍼).
import { useMessageStore } from '@shared/stores';

import { EDIT_MEASURE, MSG } from '../business-plan.constants';
import type { BusinessPlanRow, SearchCondition, ValidationResult } from '../business-plan.types';

import { requiredFieldsFor } from './business-plan.division';

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

export const useBusinessPlanValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // ===== 조회 (FindData L684~799 — validation.md #9~12) =====
  const validateFind = (c: SearchCondition): ValidationResult => {
    // #10 — Division 미선택 (L697)
    if (!str(c.divisionId)) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Division 을 선택하세요.') });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION };
    }
    const start = str(c.startYyyymmdd);
    const end = str(c.endYyyymmdd);
    // #11 — 기간 역전 (L705)
    if (start && end && start > end) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_INVERTED, '_조회 기간이 잘못되었습니다 (시작일 > 종료일).'),
      });
      return { ok: false, msgId: MSG.PERIOD_INVERTED };
    }
    // #12 — 6년 초과 (L711 drpPeriod.Value1.AddYears(6) < Value2 — 종료일 보정 후 차단)
    const startY = Number(start.slice(0, 4));
    if (start && end && Number.isFinite(startY)) {
      const limit = String(startY + 6) + start.slice(4);
      if (end > limit) {
        void setAlert({
          type: 'alert',
          content: t(MSG.PERIOD_MAX_6YEAR, '_조회 기간은 6년 이상 설정 할 수 없습니다.'),
        });
        return { ok: false, msgId: MSG.PERIOD_MAX_6YEAR, adjustedEnd: limit };
      }
    }
    return { ok: true };
  };

  // ===== Bucket 변경 가드 (cboBucketType_Click L2963~2973 — validation.md #43) =====
  //   AS-IS = 삽입 행(Action='I') 존재 시 차단. TO-BE 상시편집 = 변경분(신규 행/수정 셀) 존재 시 차단.
  const validateBucketChange = (hasPendingChanges: boolean): ValidationResult => {
    if (hasPendingChanges) {
      void setAlert({
        type: 'alert',
        content: t(MSG.BUCKET_CHANGE_BLOCK, '_Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.'),
      });
      return { ok: false, msgId: MSG.BUCKET_CHANGE_BLOCK };
    }
    return { ok: true };
  };

  // ===== 저장 1차 — 필수값 division 분기 (SaveData L887~1057 — validation.md #14~16) =====
  //   대상 = 신규(I) + 수정(M) 행 중 입력 measure(Business_Plan/LOC) 행. 첫 결손 필드로 MSG00429 {0}.
  const validateSaveRows = (rows: BusinessPlanRow[], divisionId: string): ValidationResult => {
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return { ok: false, msgId: MSG.NO_CHANGES };
    }
    const required = requiredFieldsFor(divisionId);
    for (let i = 0; i < rows.length; i++) {
      const r = rows[i] as Record<string, unknown>;
      const measure = str(r.MEASURE);
      // 필수값 검증은 입력 대상 행(Business_Plan/LOC)만 — 파생 행은 저장 수집 자체 제외 (save.ts L866)
      if (measure !== EDIT_MEASURE.BUSINESS_PLAN && measure !== EDIT_MEASURE.LOC) continue;
      for (const field of required) {
        const value = field.read ? field.read(r) : str(r[field.col]);
        if (value === '') {
          const label = field.lblKey ? t(field.lblKey, field.fallback) : field.fallback;
          void setAlert({
            type: 'alert',
            content: `${t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', label)} (${i + 1})`,
          });
          return { ok: false, msgId: MSG.REQUIRED_FIELD, rowIdx: i, detail: field.col };
        }
      }
    }
    return { ok: true };
  };

  // ===== pending 변경 중 기능 차단 (Exchange Rate L2989 MSG00142 / CutOff L2844·Replace L3386 인라인 —
  //   TO-BE 상시편집 문구 신설 MSG00680) =====
  const validateNoPending = (hasPendingChanges: boolean): ValidationResult => {
    if (hasPendingChanges) {
      void setAlert({
        type: 'alert',
        content: t(
          MSG.PENDING_BLOCK,
          '_변경 중인 데이터가 있어 수행할 수 없습니다. 저장 또는 취소 후 다시 시도해 주세요.'
        ),
      });
      return { ok: false, msgId: MSG.PENDING_BLOCK };
    }
    return { ok: true };
  };

  return {
    validateFind,
    validateBucketChange,
    validateSaveRows,
    validateNoPending,
  };
};
