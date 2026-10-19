import { describe, expect, it } from 'vitest';

import { SHEETS } from '../capa-speed-plan.constants';
import type { Scp0105Row } from '../capa-speed-plan.types';

import {
  isCellEditable,
  isElectrodeTypeEditable,
  isPriorityNone,
  syncElectrodeTypeAcrossLine,
} from './capaSpeedPlan.editLock';

/**
 * design 03_grid-columns §5-3 V-18~V-25 (편집 조건) / V-33 (설비유형 동기화) 검증 축.
 *   AS-IS `SetLockColumnsASSEMBLY`(cs:1479~1572) / `SetLockColumnsELTR`(cs:1574~1693) /
 *   `CheckEltrEquipmentType`(cs:2946~3083). 좌표가 아니라 의미로 판정한다(hook #130).
 */

const PERIOD = 'M_01202510';

const row = (patch: Record<string, unknown> = {}): Scp0105Row =>
  ({
    VER_ID: '202509',
    VER_SEQ: '1',
    DIVISION_ID: '81',
    COMPANY_ID: 'C1',
    SITE_ID: 'S1',
    PLANT_ID: 'P1',
    FACTORY_ID: 'F1',
    LINE_ID: 'L1',
    OPERATION_ID: 'A5000',
    ELTR_LN_TP_CD: 'Anode',
    ITEM_ID: 'I1',
    NICK_NAME: 'N1',
    MSR_TP_CD: 'EQP_NBU',
    EDITABLE_YN: 'Y',
    [`${PERIOD}_ASSIGN_PRIORITY`]: '1',
    ...patch,
  }) as Scp0105Row;

describe('isPriorityNone — 짝 우선순위 컬럼 (V-20/V-21)', () => {
  it('공백·0·숫자 아님이면 "우선순위 없음"', () => {
    expect(isPriorityNone(row({ [`${PERIOD}_ASSIGN_PRIORITY`]: '' }), PERIOD)).toBe(true);
    expect(isPriorityNone(row({ [`${PERIOD}_ASSIGN_PRIORITY`]: '0' }), PERIOD)).toBe(true);
    expect(isPriorityNone(row({ [`${PERIOD}_ASSIGN_PRIORITY`]: 'x' }), PERIOD)).toBe(true);
    expect(isPriorityNone(undefined, PERIOD)).toBe(true);
  });

  it('0 이 아닌 숫자면 우선순위 있음', () => {
    expect(isPriorityNone(row({ [`${PERIOD}_ASSIGN_PRIORITY`]: '2' }), PERIOD)).toBe(false);
    expect(isPriorityNone(row({ [`${PERIOD}_ASSIGN_PRIORITY`]: 3 }), PERIOD)).toBe(false);
  });
});

describe('isCellEditable — (a) 조회 직후 전 셀 읽기전용 (V-18/R-24)', () => {
  it('편집모드가 아니면 기간열도 잠금', () => {
    expect(
      isCellEditable({ sheetName: SHEETS.ASSEMBLY, binding: PERIOD, row: row(), isEditMode: false })
    ).toBe(false);
  });

  it('행·binding 이 없으면 잠금', () => {
    expect(
      isCellEditable({ sheetName: SHEETS.ASSEMBLY, binding: PERIOD, row: undefined, isEditMode: true })
    ).toBe(false);
    expect(
      isCellEditable({ sheetName: SHEETS.ASSEMBLY, binding: '', row: row(), isEditMode: true })
    ).toBe(false);
  });
});

describe('isCellEditable — 고정영역 전 행 잠금 (V-22, LockRange2 등가)', () => {
  it('기간열이 아니면 전부 잠금', () => {
    for (const binding of ['BASE_QTY', 'PFRSLT_QTY', 'LINE_ID', 'MEASURE_NAME', 'IDX']) {
      expect(
        isCellEditable({ sheetName: SHEETS.ASSEMBLY, binding, row: row(), isEditMode: true })
      ).toBe(false);
    }
  });

  it('`_ASSIGN_PRIORITY` 접미 컬럼도 편집 대상이 아니다', () => {
    expect(
      isCellEditable({
        sheetName: SHEETS.ASSEMBLY,
        binding: `${PERIOD}_ASSIGN_PRIORITY`,
        row: row(),
        isEditMode: true,
      })
    ).toBe(false);
  });
});

describe('isCellEditable — 기간 셀 (V-20 ASSEMBLY / V-21 ELTR)', () => {
  it('ASSEMBLY: priority 있음 AND EDITABLE_YN=Y 일 때만 열린다', () => {
    const open = { sheetName: SHEETS.ASSEMBLY, binding: PERIOD, isEditMode: true } as const;
    expect(isCellEditable({ ...open, row: row() })).toBe(true);
    expect(isCellEditable({ ...open, row: row({ EDITABLE_YN: 'N' }) })).toBe(false);
    expect(
      isCellEditable({ ...open, row: row({ [`${PERIOD}_ASSIGN_PRIORITY`]: '0' }) })
    ).toBe(false);
  });

  it('ELTR: priority 만 본다 — EDITABLE_YN 미반환이어도 열린다(전 셀 잠김 사고 방지)', () => {
    const eltrRow = row({ EDITABLE_YN: undefined });
    expect(
      isCellEditable({ sheetName: SHEETS.ELTR, binding: PERIOD, row: eltrRow, isEditMode: true })
    ).toBe(true);
  });
});

describe('isElectrodeTypeEditable / ELTR_LN_TP_CD (V-23, R-08)', () => {
  it('설비유형 공백 OR EQUIPMENT_ID 공백 OR UI_UPD_YN=Y 일 때만 편집', () => {
    expect(isElectrodeTypeEditable(row({ ELTR_LN_TP_CD: '', EQUIPMENT_ID: 'E1' }))).toBe(true);
    expect(isElectrodeTypeEditable(row({ EQUIPMENT_ID: '' }))).toBe(true);
    expect(isElectrodeTypeEditable(row({ EQUIPMENT_ID: 'E1', UI_UPD_YN: 'Y' }))).toBe(true);
    expect(isElectrodeTypeEditable(row({ EQUIPMENT_ID: 'E1', UI_UPD_YN: 'N' }))).toBe(false);
  });

  it('ASSEMBLY 의 Line Type 은 표시 전용이다 (03 §1.1 #7)', () => {
    const editable = row({ EQUIPMENT_ID: '' });
    expect(
      isCellEditable({
        sheetName: SHEETS.ASSEMBLY,
        binding: 'ELTR_LN_TP_CD',
        row: editable,
        isEditMode: true,
      })
    ).toBe(false);
    expect(
      isCellEditable({
        sheetName: SHEETS.ELTR,
        binding: 'ELTR_LN_TP_CD',
        row: editable,
        isEditMode: true,
      })
    ).toBe(true);
  });
});

describe('syncElectrodeTypeAcrossLine — 설비유형 일괄 동기화 (V-33)', () => {
  it('6키가 같은 다른 행만 덮어쓴다 (자기 행 제외)', () => {
    const edited = row({ ELTR_LN_TP_CD: 'Cathode' });
    const same = row({ ELTR_LN_TP_CD: 'Anode', EQUIPMENT_ID: 'E2' });
    const otherLine = row({ LINE_ID: 'L9', ELTR_LN_TP_CD: 'Anode' });
    const synced = syncElectrodeTypeAcrossLine([edited, same, otherLine], edited);
    expect(synced).toHaveLength(1);
    expect(synced[0].row).toBe(same);
    expect(synced[0].previousValue).toBe('Anode');
    expect(synced[0].nextValue).toBe('Cathode');
  });

  it('6키 중 하나라도 공백이면 발동하지 않는다', () => {
    const edited = row({ COMPANY_ID: '', ELTR_LN_TP_CD: 'Cathode' });
    const other = row({ COMPANY_ID: '', ELTR_LN_TP_CD: 'Anode' });
    expect(syncElectrodeTypeAcrossLine([edited, other], edited)).toHaveLength(0);
  });

  it('값이 이미 같은 행은 건너뛴다 (의도적 편차 — 원복 불가 M 마킹 방지)', () => {
    const edited = row({ ELTR_LN_TP_CD: 'Anode' });
    const same = row({ ELTR_LN_TP_CD: 'Anode', EQUIPMENT_ID: 'E2' });
    expect(syncElectrodeTypeAcrossLine([edited, same], edited)).toHaveLength(0);
  });
});
