// ⭐ DMF0021 — 조회/저장/버킷 검증 (validation.md 141건 중 활성 메시지·silent 분기 매핑 —
//   전체 매트릭스 = __asis-mapping__.md. anti-simplification: 각 가드에 AS-IS 라인 근거 주석 보존).
//   근거(라인 = AS-IS DMF0021_SalesPlan.cs):
//     V-S1 Division 필수 (FindData L1513 MSG00097) / V-S2 기간 역전 (L1474 MSG00108) /
//     V-S3 3년 초과 — 종료일 = 시작일+3년 보정 후 차단 (L1481 MSG00164. 주석은 "2년"이나 코드 = 3년) /
//     V-E3 Bucket 변경 차단 — 변경분 존재 시 (cboBucketType_Click L5475 MSG00227) /
//     V-V1 필수 13종 division 분기 (SaveData L2198~2239 — AS-IS MSG00002 용법 → 사내 MSG00429 재매핑) /
//     V-V3 변경 0건 (MSG00004 '수정한 내용이 없습니다') — Catch_Up 음수(MSG00085)·라인 변경 0건
//       (MSG00146)은 조립 단계(sales-plan.save.ts buildUnfoldRows)에서 검증.
//   SP 내장(재구현 금지): 중복검증/배분/MERGE — 결과 'messageCode^addmessage' split alert (api 헬퍼).
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useMessageStore } from '@shared/stores';

import { MSG } from '../sales-plan.constants';
import type { SalesPlanRow, SearchCondition, ValidationResult } from '../sales-plan.types';

import { isDiv81, requiredFieldsFor } from './sales-plan.division';

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

export const useSalesPlanValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // ===== 조회 (FindData L1460~1513 — validation.md #39~42) =====
  const validateFind = (c: SearchCondition): ValidationResult => {
    // #42 — Division 미선택 (L1513)
    if (!str(c.divisionId)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Division 을 선택하세요.'),
      });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION };
    }
    const start = str(c.startYyyymmdd);
    const end = str(c.endYyyymmdd);
    // #40 — 기간 역전 (L1474)
    if (start && end && start > end) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_INVERTED, '_조회 기간이 잘못되었습니다 (시작일 > 종료일).'),
      });
      return { ok: false, msgId: MSG.PERIOD_INVERTED };
    }
    // #41 — 3년 초과 (L1481 drpPeriod.Value1.AddYears(3) < Value2 — 종료일 보정 후 차단)
    const startY = Number(start.slice(0, 4));
    if (start && end && Number.isFinite(startY)) {
      const limit = String(startY + 3) + start.slice(4);
      if (end > limit) {
        void setAlert({
          type: 'alert',
          content: t(MSG.PERIOD_MAX_3YEAR, '_조회 기간은 3년 이내로 입력해주세요.'),
        });
        return { ok: false, msgId: MSG.PERIOD_MAX_3YEAR, adjustedEnd: limit };
      }
    }
    return { ok: true };
  };

  // ===== Bucket 변경 가드 (cboBucketType_Click L5468~5488 — validation.md #140/141) =====
  //   AS-IS = 편집모드(비잠금) 중 차단. TO-BE 상시편집 = 변경분(신규 행/수정 셀) 존재 시 차단.
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

  // ===== 저장 1차 — 필수 13종 division×measure 분기 (SaveData L2198~2239 — validation.md #60~70/74~76) =====
  //   대상 = 신규(I) + 수정(M) 행. 첫 결손 필드로 MSG00429 {0} + 행 번호 병기.
  const validateSaveRows = (
    rows: SalesPlanRow[],
    divisionId: string,
    staticColumns: RawFlexGridColumnConfig[]
  ): ValidationResult => {
    if (isDiv81(divisionId)) {
      const columnSet = new Set(staticColumns.map(column => column.colNm?.toUpperCase()));
      const missingColumns = ['FROM_SITE_ID', 'PLANT_SITE_ID'].filter(
        column => !columnSet.has(column)
      );
      if (missingColumns.length > 0) {
        void setAlert({
          type: 'alert',
          content: `${t(MSG.REQUIRED_COLUMN, '_Required input column is missing.')} (${missingColumns.join(', ')})`,
        });
        return { ok: false, msgId: MSG.REQUIRED_COLUMN, detail: missingColumns.join(',') };
      }
    }

    if (rows.length === 0) {
      // 변경 0건 (MSG00004 '수정한 내용이 없습니다')
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return { ok: false, msgId: MSG.NO_CHANGES };
    }
    for (let i = 0; i < rows.length; i++) {
      const r = rows[i] as Record<string, unknown>;
      const measure = str(r.MEASURE);
      // [No.59] 81 TEXT 필수는 ETC 행만 — 행별 FCST_TYPE 전달
      const required = requiredFieldsFor(divisionId, measure, str(r.FCST_TYPE));
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

  return {
    validateFind,
    validateBucketChange,
    validateSaveRows,
  };
};
