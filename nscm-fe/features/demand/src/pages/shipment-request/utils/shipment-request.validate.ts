// DMF0045 — 저장 검증 (AS-IS DMF0045_ShipmentRequest.cs SaveData/fnValidation — design 03 §4.3).
//   근거(라인 = AS-IS cs):
//     · 필수 9종 (SaveData cs 815 checkRequiredOfSpread): Division / Project Code / FROM_SITE /
//       Item(Model) / FCST Type / Incoterms / Measure / Trans Mode / BOD ID — MSG00429 '{0} 필수'.
//     · Division='81' 계열 조건부 (startsWith('81')): TO_SITE(Plant) 추가 필수.
//     · 음수 qty 차단 (fnValidation cs 2205~2229): AS-IS MSG00084(미배포) → 사내 MSG00085 재매핑
//       (__asis-mapping__ 기록). D_ 정규화 후 조립행(SaveUnfoldRow) qty 기준으로 판정.
//     · 중복행 검증 (fnValidation cs 2190~2242): SP 내장 재구현 금지 — 저장 응답 alert 로 위임
//       (shipment-request.api parseSaveOutcome). 여기서는 클라이언트 선제 검증(필수/음수) 만.
//   대상 = 신규(I)·수정(M) 조립행 전체. 필수값 검증은 신규(I) 행 한정(수정행은 조회 시점 결손 가능 —
//     sales-plan 선례 2026-08-11 확정)이라, 여기서는 조립행이 아니라 원본 행(신규분) 을 받아 검증한다.
import { useMessageStore } from '@shared/stores';

import { FROZEN_PERIOD_MSG, MSG } from '../shipment-request.constants';
import type { ShipmentRequestRow, ValidationResult } from '../shipment-request.types';

import { isDiv81 } from './shipment-request.division';
import { dynKindOf, isFrozenDayCell } from './shipment-request.editLock';
import type { SaveUnfoldRow } from './shipment-request.save';

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

// frozen 위반 셀 — 저장 대상 D_ 셀 중 마감 구간에 걸린 것(그리드 위치 이동용으로 행·binding 을 함께 넘긴다).
export interface FrozenCell {
  row: ShipmentRequestRow;
  binding: string;
}

const ymdLabel = (binding: string): string => {
  const ymd = binding.slice(2);
  return `${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`;
};

/**
 * 저장 대상 D_ 셀 중 frozen 구간에 있는 셀을 찾는다(순수 함수).
 *   셀 잠금(evalShipmentDynCell)이 1차 방어지만, Weekly/Monthly 입력이 하위 D_ 로 전개되거나(recalc)
 *   잠금이 빠진 경로로 frozen 일자 값이 바뀌면 SP 는 그대로 저장/거부해 원인을 알 수 없었다(#236).
 *   판정 기준은 잠금과 같은 isFrozenDayCell 이다.
 *   - 신규행: 값이 있는 D_ 셀(buildUnfoldRows 신규 수집 기준과 동일).
 *   - 수정행: EditTracker 가 잡은 변경 D_ 셀.
 */
export const findFrozenCells = (params: {
  insertedRows: ShipmentRequestRow[];
  editedChanges: Map<ShipmentRequestRow, Record<string, unknown>>;
  dOrderedDayBindings: readonly string[];
  insertFrozenCutoffYmd: string;
}): FrozenCell[] => {
  const { insertedRows, editedChanges, dOrderedDayBindings, insertFrozenCutoffYmd } = params;
  const out: FrozenCell[] = [];
  const check = (row: ShipmentRequestRow, binding: string) => {
    if (dynKindOf(binding) !== 'D') return;
    if (isFrozenDayCell(binding, row, dOrderedDayBindings, insertFrozenCutoffYmd)) {
      out.push({ row, binding });
    }
  };
  for (const row of insertedRows) {
    const rec = row as Record<string, unknown>;
    for (const key of Object.keys(rec)) {
      const v = rec[key];
      if (v == null || v === '') continue;
      check(row, key);
    }
  }
  for (const [row, changed] of editedChanges) {
    if (row.CRUD_TYPE === 'I') continue;
    for (const key of Object.keys(changed)) check(row, key);
  }
  return out;
};

/**
 * frozen 상세 문구 — From Plant 별 "Plant ~ 마지막 frozen 일자". 같은 Plant 는 한 번만.
 *   마지막 일자 = 그 행의 frozen 판정이 참인 D_ 중 가장 늦은 일자(잠금 구간의 끝).
 */
export const describeFrozenCells = (
  cells: FrozenCell[],
  dOrderedDayBindings: readonly string[],
  insertFrozenCutoffYmd: string
): string => {
  const bySite = new Map<string, string>();
  for (const { row } of cells) {
    const site = str(row.FROM_SITE) || 'New Row';
    const lastFrozen = dOrderedDayBindings
      .filter(b => isFrozenDayCell(b, row, dOrderedDayBindings, insertFrozenCutoffYmd))
      .at(-1);
    if (!lastFrozen) continue;
    const prev = bySite.get(site);
    if (!prev || lastFrozen > prev) bySite.set(site, lastFrozen);
  }
  return [...bySite.entries()].map(([site, b]) => `${site} ~ ${ymdLabel(b)}`).join(', ');
};

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
  // Trans Mode / BOD ID — AS-IS checkRequiredOfSpread 는 라벨 '*' 컬럼 전부를 본다(SHEET_COLUMNS 실측:
  //   'Trans Mode*', 'BOD ID*'). 누락 시 SP 가 TRANSPORT_MODE/BOD_ID NOT NULL 위반(ORA-01400)으로
  //   실패해 원문 오류가 알럿에 그대로 노출됐다. TR_MODE 를 먼저 검사(BOD 팝업이 둘을 함께 채운다).
  { col: 'TR_MODE', fallback: 'Trans Mode' },
  { col: 'BOD_ID', fallback: 'BOD ID' },
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

  /**
   * frozen 구간 저장 차단 — 위반 셀이 있으면 SP 를 부르지 않고 frozen 때문임을 밝혀 안내한다(#236).
   *   SP(P_DMF0045_SAVE_SHIPMENT_REQUEST)에는 frozen 검사가 없어, 이 가드가 없으면 원인 모를 실패나
   *   frozen 일자 저장으로 이어진다. 전용 MSG 가 등록되기 전에는 MSG01196 + 상세 줄로 표시한다.
   */
  const validateFrozenCells = (
    cells: FrozenCell[],
    dOrderedDayBindings: readonly string[],
    insertFrozenCutoffYmd: string
  ): ValidationResult => {
    if (cells.length === 0) return { ok: true };
    const detail = describeFrozenCells(cells, dOrderedDayBindings, insertFrozenCutoffYmd);
    const content = FROZEN_PERIOD_MSG
      ? t(FROZEN_PERIOD_MSG, FROZEN_PERIOD_MSG).replace('{0}', detail)
      : `${t(MSG.PLAN_NOT_EDITABLE, '_수정할 수 없는 플랜입니다.')}\nFrozen: ${detail}`;
    void setAlert({ type: 'alert', content });
    return { ok: false, msgId: FROZEN_PERIOD_MSG ?? MSG.PLAN_NOT_EDITABLE, detail };
  };

  return {
    validateFind,
    validateBucketChange,
    validateSaveRows,
    validateFrozenCells,
  };
};
