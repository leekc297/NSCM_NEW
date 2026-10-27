// DMF0045 — 저장 검증 (AS-IS DMF0045_ShipmentRequest.cs SaveData/fnValidation — design 03 §4.3).
//   근거(라인 = AS-IS cs):
//     · 필수 7종 (SaveData cs 2140~2189): Division / Project Code / FROM_SITE(Sales Site) /
//       Item(Model) / FCST Type / Incoterms / Measure — MSG00002 '{0} 필수'.
//     · Division='81' 계열 조건부 (startsWith('81')): TO_SITE(Plant) 추가 필수.
//     · 음수 qty 차단 (fnValidation cs 2205~2229): AS-IS MSG00084(미배포) → 사내 MSG00085 재매핑
//       (__asis-mapping__ 기록). D_ 정규화 후 조립행(SaveUnfoldRow) qty 기준으로 판정.
//     · 중복행 검증 (fnValidation cs 2190~2242): SP 내장 재구현 금지 — 저장 응답 alert 로 위임
//       (dmf0045.api parseSaveOutcome). 여기서는 클라이언트 선제 검증(필수/음수) 만.
//   대상 = 신규(I)·수정(M) 조립행 전체. 필수값 검증은 신규(I) 행 한정(수정행은 조회 시점 결손 가능 —
//     sales-plan 선례 2026-08-11 확정)이라, 여기서는 조립행이 아니라 원본 행(신규분) 을 받아 검증한다.
import { useMessageStore } from '@shared/stores';

import { MSG } from '../dmf0045.constants';
import type { ShipmentRequestRow, ValidationResult } from '../dmf0045.types';

import { isDiv81 } from './dmf0045.division';
import type { SaveUnfoldRow } from './dmf0045.save';

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

// 필수 7종 (컬럼, 라벨 fallback) — 라벨은 t(MSG00002 {0}) 치환용. i18n LBL 코드가 있는 항목은
//   LBL 을 우선(convert-core §2.4 자유 형식 금지), 없으면 컬럼 캡션 fallback.
const REQUIRED_FIELDS: ReadonlyArray<{ col: string; lblKey?: string; fallback: string }> = [
  { col: 'DIVISION_ID', fallback: 'Division' },
  { col: 'PROJECT_CODE', fallback: 'Project Code' },
  { col: 'FROM_SITE', fallback: 'Sales Site' },
  { col: 'ITEM_ID', fallback: 'Model' },
  { col: 'FCST_TYPE', fallback: 'FCST Type' },
  { col: 'INCOTERMS', fallback: 'Incoterms' },
  { col: 'MEASURE', fallback: 'Measure' },
];

export const useShipmentRequestValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  // ===== 조회 가드 — Division 미선택 (FindData cs:609 MSG00097) =====
  //   기간 역전/최대기간은 drpPeriod readOnly(오늘~오늘+55일 고정)라 AS-IS 에도 없음 — 미이식.
  const validateFind = (divisionId: string): ValidationResult => {
    if (!str(divisionId)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Division 을 선택하세요.'),
      });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION };
    }
    return { ok: true };
  };

  // ===== Bucket 변경 가드 — 변경분(신규 행/수정 셀) 존재 시 차단 (cboBucketType_Click MSG00227) =====
  //   AS-IS = 편집모드 중 차단. TO-BE 상시편집 = pending 변경 존재 시 차단(sales-plan 동형).
  const validateBucketChange = (hasPendingChanges: boolean): ValidationResult => {
    if (hasPendingChanges) {
      void setAlert({
        type: 'alert',
        content: t(MSG.BUCKET_CHANGE_BLOCK, '_변경된 내용이 있어 Bucket 을 변경할 수 없습니다.'),
      });
      return { ok: false, msgId: MSG.BUCKET_CHANGE_BLOCK };
    }
    return { ok: true };
  };

  /**
   * 저장 검증 — 필수 7종(+81 조건부 TO_SITE) 및 음수 qty.
   *   @param insertedRows 신규(I) 원본 행 — 필수값 검증 대상(수정행 제외).
   *   @param saveRows     D_ 정규화 조립행(SaveUnfoldRow[]) — 음수 qty 및 변경 0건 판정 대상.
   *   @param divisionId   현재 조회 division (81 조건부 판정).
   *   중복행은 SP 내장 검증(fnValidation)에 위임 — 여기서 재구현 금지.
   */
  const validateSaveRows = (
    insertedRows: ShipmentRequestRow[],
    saveRows: SaveUnfoldRow[],
    divisionId: string
  ): ValidationResult => {
    // 변경/신규 없음 → toast (필수·음수 등 검증 실패는 modal alert 유지 — sales-plan 규약).
    if (saveRows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return { ok: false, msgId: MSG.NO_CHANGES };
    }

    // 필수 7종 — 신규(I) 행만. 81 계열이면 TO_SITE(Plant) 추가 필수.
    const requires = isDiv81(divisionId)
      ? [...REQUIRED_FIELDS, { col: 'TO_SITE', fallback: 'Plant Site' }]
      : REQUIRED_FIELDS;
    for (let i = 0; i < insertedRows.length; i++) {
      const r = insertedRows[i] as Record<string, unknown>;
      for (const field of requires) {
        if (str(r[field.col]) === '') {
          const label = field.lblKey ? t(field.lblKey, field.fallback) : field.fallback;
          void setAlert({
            type: 'alert',
            content: `${t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', label)} (${i + 1})`,
          });
          return { ok: false, msgId: MSG.REQUIRED_FIELD, rowIdx: i, detail: field.col };
        }
      }
    }

    // 음수 qty 차단 (fnValidation cs 2205~2229 — MSG00084→MSG00085 재매핑).
    for (const row of saveRows) {
      if (Number(row.qty) < 0) {
        void setAlert({
          type: 'alert',
          content: t(MSG.NEGATIVE_QTY, '_0 이상 값만 입력 가능합니다.'),
        });
        return { ok: false, msgId: MSG.NEGATIVE_QTY };
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
