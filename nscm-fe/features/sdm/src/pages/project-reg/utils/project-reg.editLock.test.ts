import { describe, expect, it } from 'vitest';

import type { RawFlexGridColumnConfig } from '@foundation/models';

import { REG_STATUS } from '../project-reg.constants';
import type { Tab1Row } from '../project-reg.types';

import {
  canOpenAuthRegModal,
  isCellEditable,
  isRowCancelable,
  isRowDeletable,
  isRowEditable,
  isRowRequestable,
  requiredInsertColumns,
} from './project-reg.editLock';

// ⭐ SDM1010 상태머신 × 행/셀 가드 전수 (제약 P-15/P-17/P-07/P-09/P-12 매트릭스).
//   ⭐ 신본 도메인 (계약 §17 · 결정 6): DRAFT/WRITING/WAITING/COMPLETE/REJECT (REQUEST/CHG_* 폐지)
//   축 = 신규C / DRAFT / WRITING / WAITING / COMPLETE / REJECT
//     × 편집(isRowEditable·isCellEditable) / 삭제(isRowDeletable) / 등록요청(isRowRequestable)
//     / 요청취소(isRowCancelable) / 권한등록 링크(canOpenAuthRegModal).
//   셀 게이트 = INPUT_TP_CD 단일 원천 (IM/IO=신규행만 · M/O=행 게이트 통과 시 · S/미지정=불가).

// 저장된 행(비 C) — DPJT_KEY 보유. 신규행은 crud('C') + DPJT_KEY '' 로 생성
const saved = (status: string, over: Record<string, unknown> = {}): Tab1Row =>
  ({ DPJT_KEY: 'TEMP_20260813000000000001_000001', DPJT_REG_STATUS: status, ...over }) as unknown as Tab1Row;
const inserted = (over: Record<string, unknown> = {}): Tab1Row =>
  ({ DPJT_KEY: '', DPJT_REG_STATUS: '', CRUD_TYPE: 'C', ...over }) as unknown as Tab1Row;

describe('P-15/P-17 행 편집 게이트 — 신규(C)/DRAFT/WRITING 만 (isRowEditable — 계약 결정 6)', () => {
  it('신규행(CRUD_TYPE C) = 편집 가능 (상태값 무관)', () => {
    expect(isRowEditable(inserted())).toBe(true);
  });

  it('DRAFT(신규 저장분 §2)/WRITING(작성중) = 편집 가능', () => {
    expect(isRowEditable(saved(REG_STATUS.DRAFT))).toBe(true);
    expect(isRowEditable(saved(REG_STATUS.WRITING))).toBe(true);
  });

  it('승인대기(WAITING) = 수정 불가 (P-17)', () => {
    expect(isRowEditable(saved(REG_STATUS.WAITING))).toBe(false);
  });

  it('등록완료(COMPLETE)/반려(REJECT)·미지정 상태·행 부재 = 편집 불가', () => {
    expect(isRowEditable(saved(REG_STATUS.COMPLETE))).toBe(false);
    expect(isRowEditable(saved(REG_STATUS.REJECT))).toBe(false);
    expect(isRowEditable(saved(''))).toBe(false);
    expect(isRowEditable(undefined)).toBe(false);
  });
});

describe('P-16 셀 편집 게이트 — INPUT_TP_CD(IM/IO/M/O/S) × 행 상태 (isCellEditable)', () => {
  it('IM/IO = 신규행(C)만 편집 (기존 DRAFT/WRITING 행도 잠금 — 식별키성 컬럼)', () => {
    expect(isCellEditable('IM', inserted())).toBe(true);
    expect(isCellEditable('IO', inserted())).toBe(true);
    expect(isCellEditable('IM', saved(REG_STATUS.DRAFT))).toBe(false);
    expect(isCellEditable('IO', saved(REG_STATUS.WRITING))).toBe(false);
  });

  it('M/O = 행 게이트 통과 시 편집 (신규 + DRAFT/WRITING 개방·WAITING 잠금)', () => {
    expect(isCellEditable('M', inserted())).toBe(true);
    expect(isCellEditable('O', inserted())).toBe(true);
    expect(isCellEditable('M', saved(REG_STATUS.DRAFT))).toBe(true);
    expect(isCellEditable('O', saved(REG_STATUS.WRITING))).toBe(true);
    expect(isCellEditable('M', saved(REG_STATUS.WAITING))).toBe(false);
    expect(isCellEditable('O', saved(REG_STATUS.COMPLETE))).toBe(false);
  });

  it('S/미지정 = 신규행이어도 항상 잠금', () => {
    expect(isCellEditable('S', inserted())).toBe(false);
    expect(isCellEditable(undefined, inserted())).toBe(false);
    expect(isCellEditable('S', saved(REG_STATUS.WRITING))).toBe(false);
  });

  it('행 상태가 잠금이면 INPUT_TP_CD 무관 전 컬럼 잠금 (WAITING/COMPLETE/REJECT)', () => {
    for (const tp of ['IM', 'IO', 'M', 'O', 'S']) {
      expect(isCellEditable(tp, saved(REG_STATUS.WAITING))).toBe(false);
      expect(isCellEditable(tp, saved(REG_STATUS.REJECT))).toBe(false);
    }
    expect(isCellEditable('M', undefined)).toBe(false);
  });
});

describe('P-07 삭제 가드 — 신규(C)/DRAFT/WRITING 만 (isRowDeletable = 행 편집 게이트 동일 술어)', () => {
  it('신규행·DRAFT·WRITING = 삭제 가능 (⚠ 서버 §2 D 가드는 WRITING 한정 — DRAFT 는 EVENT=0 안내)', () => {
    expect(isRowDeletable(inserted())).toBe(true);
    expect(isRowDeletable(saved(REG_STATUS.DRAFT))).toBe(true);
    expect(isRowDeletable(saved(REG_STATUS.WRITING))).toBe(true);
  });

  it('WAITING/COMPLETE/REJECT = 삭제 불가 (MSG00706 차단 대상)', () => {
    expect(isRowDeletable(saved(REG_STATUS.WAITING))).toBe(false);
    expect(isRowDeletable(saved(REG_STATUS.COMPLETE))).toBe(false);
    expect(isRowDeletable(saved(REG_STATUS.REJECT))).toBe(false);
  });
});

describe('P-09 등록요청 가드 — 저장된 DRAFT/WRITING 만 (isRowRequestable)', () => {
  it('저장된 DRAFT/WRITING = 요청 가능 (§3 서버 가드는 WRITING→WAITING — DRAFT 는 EVENT=0 안내)', () => {
    expect(isRowRequestable(saved(REG_STATUS.DRAFT))).toBe(true);
    expect(isRowRequestable(saved(REG_STATUS.WRITING))).toBe(true);
  });

  it('신규(미저장 C) 행 = 요청 불가 — 상태값이 편집 개방이어도 차단 (확인사항 5.1)', () => {
    expect(isRowRequestable(inserted())).toBe(false);
    expect(isRowRequestable(inserted({ DPJT_REG_STATUS: REG_STATUS.WRITING }))).toBe(false);
  });

  it('WAITING/COMPLETE/REJECT = 요청 불가 (MSG00708)', () => {
    expect(isRowRequestable(saved(REG_STATUS.WAITING))).toBe(false);
    expect(isRowRequestable(saved(REG_STATUS.COMPLETE))).toBe(false);
    expect(isRowRequestable(saved(REG_STATUS.REJECT))).toBe(false);
    expect(isRowRequestable(undefined)).toBe(false);
  });
});

describe('P-12 요청취소 가드 — 저장된 WAITING 만 (isRowCancelable — §4 WAITING→WRITING)', () => {
  it('승인대기(WAITING) = 취소 가능', () => {
    expect(isRowCancelable(saved(REG_STATUS.WAITING))).toBe(true);
  });

  it('신규 C·DRAFT·WRITING·COMPLETE·REJECT = 취소 불가 (MSG00713)', () => {
    expect(isRowCancelable(inserted())).toBe(false);
    expect(isRowCancelable(inserted({ DPJT_REG_STATUS: REG_STATUS.WAITING }))).toBe(false);
    expect(isRowCancelable(saved(REG_STATUS.DRAFT))).toBe(false);
    expect(isRowCancelable(saved(REG_STATUS.WRITING))).toBe(false);
    expect(isRowCancelable(saved(REG_STATUS.COMPLETE))).toBe(false);
    expect(isRowCancelable(saved(REG_STATUS.REJECT))).toBe(false);
    expect(isRowCancelable(undefined)).toBe(false);
  });
});

describe('P-31·P-17 권한등록 링크 가드 — 저장된 행(DPJT_KEY 보유)만, 상태 무관 (canOpenAuthRegModal)', () => {
  it('저장된 행 = 전 상태 허용 — 승인대기(WAITING)도 링크는 허용 (P-17)', () => {
    expect(canOpenAuthRegModal(saved(REG_STATUS.DRAFT))).toBe(true);
    expect(canOpenAuthRegModal(saved(REG_STATUS.WRITING))).toBe(true);
    expect(canOpenAuthRegModal(saved(REG_STATUS.WAITING))).toBe(true);
    expect(canOpenAuthRegModal(saved(REG_STATUS.COMPLETE))).toBe(true);
    expect(canOpenAuthRegModal(saved(REG_STATUS.REJECT))).toBe(true);
  });

  it('신규(미저장) 행·키 없는 행 = 차단 (P-31 — 저장 후 권한 등록)', () => {
    expect(canOpenAuthRegModal(inserted())).toBe(false);
    expect(canOpenAuthRegModal(saved(REG_STATUS.WRITING, { DPJT_KEY: '' }))).toBe(false);
    expect(canOpenAuthRegModal(undefined)).toBe(false);
  });
});

describe('requiredInsertColumns — IM(신규행 필수) 컬럼만 추출 (메타 단일 원천)', () => {
  const col = (colNm: string, inputTpCd?: string): RawFlexGridColumnConfig =>
    ({ colNm, inputTpCd }) as unknown as RawFlexGridColumnConfig;

  it('IM 만 필수 — IO/M/O/S/미지정 제외', () => {
    const cols = [
      col('DPJT_CLASS_NAME', 'IM'),
      col('END_CUSTOMER', 'IM'),
      col('DPJT_NAME', 'IM'),
      col('CELL_TYPE_NAME', 'IO'),
      col('STACK_METHOD_NAME', 'IO'),
      col('DPJT_KEY', 'S'),
      col('DEPT_NAME'),
    ];
    expect(requiredInsertColumns(cols).map(c => c.colNm)).toEqual([
      'DPJT_CLASS_NAME',
      'END_CUSTOMER',
      'DPJT_NAME',
    ]);
  });

  it('메타 미적재(undefined/빈 배열) = 빈 목록 (FALLBACK 금지)', () => {
    expect(requiredInsertColumns(undefined)).toEqual([]);
    expect(requiredInsertColumns([])).toEqual([]);
  });
});
