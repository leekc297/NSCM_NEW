import { D_EDIT_MEASURES, M_EDIT_MEASURES } from '../capa-mobility-it.constants';
import type { CapaRowItem } from '../capa-mobility-it.types';

import { kindOf } from './capa-mobility-it.dynamicColumns';

/**
 * measure별 편집 매트릭스 (design 01 §2 A그룹 / design 03 §R3 — AS-IS EditButton LockRange 이식).
 *   AS-IS 모드토글(EditButton)은 미이식(convert-core §2.4) — 편집 기본 ON. 컬럼단위 잠금만 재현.
 *
 * 규칙:
 *   - 0~MEASURE_NAME 키/라벨 컬럼(정적) = 항상 잠금(INPUT_TP_CD='S').
 *   - PRODUCT_READY = 항상 편집 가능(A4).
 *   - measure=DAILY_CAPA 행: M_ 컬럼만 편집(A7), 그 외 잠금.
 *   - measure∈{NO_WORK,LOAD_RATE,RAMP_UP} 행: 非M_(D_/W_) 컬럼 편집(A10), M_ 잠금(A9).
 */
export const isCellEditable = (
  binding: string,
  row: CapaRowItem | undefined,
  staticBindings: ReadonlySet<string>
): boolean => {
  if (!binding || !row) return false;

  // 정적 컬럼: PRODUCT_READY 만 편집, 나머지 전부 잠금(키/라벨).
  if (staticBindings.has(binding)) return binding === 'PRODUCT_READY';

  const kind = kindOf(binding);
  if (!kind) return false; // 동적 아님 & 정적 아님 = 미지 컬럼 → 잠금
  if (kind === 'PR') return false; // PR_M_ 읽기 전용

  const measure = typeof row.MEASURE_UI === 'string' ? row.MEASURE_UI : '';
  if (M_EDIT_MEASURES.includes(measure)) return kind === 'M';
  // 非M_ 편집(A10)이나 저장 SP 는 D_(일)만 받는다(P_SAVE_SCP_CAPA_WORK) — W_(집계)는 읽기.
  if (D_EDIT_MEASURES.includes(measure)) return kind === 'D';
  return false;
};
