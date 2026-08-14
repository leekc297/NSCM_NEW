// ⭐ SDM1010 — 편집/잠금 규칙 순수함수 (테스트 대상 — beginningEdit/formatItem 공용 단일 원천).
//   ⭐ 신본 도메인 (계약 결정 6): 행 편집/삭제 = REG_STATUS ∈ {DRAFT, WRITING} 또는 신규행 'C' /
//   등록요청 = 저장된 행 ∈ {DRAFT, WRITING} / 요청취소 = WAITING.
//   셀 게이트 : UI Category Setup `INPUT_TP_CD` 단일 원천 (IM/IO=신규행만 · M/O=행 게이트 통과 시 ·
//   S/미지정=불가). 색(Yellow/Gray)과 편집 판정이 같은 함수를 본다 — 갈리면 "노란칸인데 못 고침" 사고.
import type { RawFlexGridColumnConfig } from '@foundation/models';

import { REG_STATUS } from '../project-reg.constants';
import type { Tab1Row } from '../project-reg.types';

// 편집 개방 상태 집합 — DRAFT(신규 INSERT 초기값 §2)/WRITING(작성중)
const EDITABLE_STATUSES: readonly string[] = [REG_STATUS.DRAFT, REG_STATUS.WRITING];

// 행 편집 게이트 — 신규(C) 또는 DRAFT/WRITING 만 (그 외 상태 행은 전 컬럼 잠금)
export const isRowEditable = (row: Tab1Row | undefined): boolean => {
  if (!row) return false;
  if (row.CRUD_TYPE === 'C') return true;
  return EDITABLE_STATUSES.includes(String(row.DPJT_REG_STATUS ?? ''));
};

// 셀 편집 게이트 — INPUT_TP_CD 메타 × 행 상태 (하드코딩 컬럼 목록 금지)
export const isCellEditable = (
  inputTpCd: string | undefined,
  row: Tab1Row | undefined
): boolean => {
  if (!row || !isRowEditable(row)) return false;
  switch (inputTpCd) {
    case 'M':
    case 'O':
      return true;
    case 'IM':
    case 'IO':
      return row.CRUD_TYPE === 'C';
    default: // 'S' 및 미지정
      return false;
  }
};

// IM(신규행 필수) 컬럼 바인딩 — Save FE 검증(MSG00113) 대상 (메타 단일 원천)
export const requiredInsertColumns = (
  columns: RawFlexGridColumnConfig[] | undefined
): RawFlexGridColumnConfig[] => (columns ?? []).filter(c => c.inputTpCd === 'IM');

// ── 상태머신 행 가드 (P-07/P-09/P-12/P-31 — ProjectReg 핸들러·단위테스트 공용 단일 원천) ──
// 삭제 가드 (P-07) — 신규(C) 또는 DRAFT/WRITING 만 (행 편집 게이트와 동일 술어.
//   ⚠ 서버 §2 D 가드는 WRITING 한정 — DRAFT 행은 EVENT=0 (§18-9① 발신처 확인 대상, FE 는 안내 처리)
export const isRowDeletable = isRowEditable;

// 등록요청 가드 (P-09) — 저장된 행(비 C) 이면서 DRAFT/WRITING 만. 신규(미저장) 행 불가
//   (⚠ 서버 §3 가드는 WRITING 한정 — DRAFT 행은 EVENT=0, 동일 §18-9① 계보)
export const isRowRequestable = (row: Tab1Row | undefined): boolean =>
  !!row &&
  row.CRUD_TYPE !== 'C' &&
  EDITABLE_STATUSES.includes(String(row.DPJT_REG_STATUS ?? ''));

// 요청취소 가드 (P-12) — 저장된 행(비 C) 이면서 승인대기(WAITING)만 (§4 WAITING→WRITING)
export const isRowCancelable = (row: Tab1Row | undefined): boolean =>
  !!row && row.CRUD_TYPE !== 'C' && String(row.DPJT_REG_STATUS ?? '') === REG_STATUS.WAITING;

// 권한등록 링크 가드 (P-31·P-17) — 저장된 행(DPJT_KEY 보유)만. 행 상태(승인대기 포함)는 무관
export const canOpenAuthRegModal = (row: Tab1Row | undefined): boolean =>
  !!row && row.CRUD_TYPE !== 'C' && String(row.DPJT_KEY ?? '') !== '';
