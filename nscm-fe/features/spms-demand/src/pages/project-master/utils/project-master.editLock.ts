// ⭐ SDM5010 — 편집/버튼/체크박스 잠금 순수함수 (테스트 대상 — beginningEdit/formatItem 공용 단일 원천).
//   TAB1 (P-07) : 수정 항목 11종 = INPUT_TP_CD 메타(IM/IO — 계약 ④ 재지정 F-14) 단일 원천.
//     D-PJT Code는 행의 DPJT_CODE_MOD_YN='Y'인 경우에만 편집 가능.
//   TAB2 (P-12) : 편집 = DPJT_DEVELOP_STATUS(IO 콤보) + DISABLE_YN(IO 체크) 2컬럼만 — 메타 IO 축.
//   색(Yellow/Gray)과 편집 판정이 같은 함수를 본다 — 갈리면 "노란칸인데 못 고침" 사고.
import { isCheckToggleable, isEditableInputTp } from '../../../lib/grid';
import { DPJT_CODE_BINDING, DPJT_CODE_LENGTH, REG_CAT_MOD } from '../project-master.constants';
import type { Tab1Row } from '../project-master.types';

import { toText } from './project-master.value';

// '수정' 구분 행 판정 (P-05 행 색상 전용 — DPJT_REG_CAT='MOD')
export const isModRow = (row: { DPJT_REG_CAT?: unknown } | undefined): boolean =>
  !!row && toText(row.DPJT_REG_CAT) === REG_CAT_MOD;

// INPUT_TP_CD 편집형 판정 — SDM 공통(lib/grid) 재노출 (기존 화면 내 import 경로 유지)
export { isEditableInputTp } from '../../../lib/grid';

// TAB1 셀 편집 게이트 (P-06/P-07) — 메타 편집형 × D-PJT Code 수정 허용 여부
export const isCellEditableTab1 = (
  inputTpCd: string | undefined,
  binding: string,
  row: Tab1Row | undefined
): boolean => {
  if (!row || !isEditableInputTp(inputTpCd)) return false;
  if (binding === DPJT_CODE_BINDING) return toText(row.DPJT_CODE_MOD_YN).trim() === 'Y';
  return true;
};

// TAB2 셀 편집 게이트 (P-12) — 메타 편집형(개발현황/비활성 2컬럼 IO)만. 행 게이트 없음.
//   ⚠ DISABLE_YN(FPCheckBox)은 편집기 경유 금지 — beginningEdit 차단 후 클릭 토글만 (그리드 몫)
export const isCellEditableTab2 = (inputTpCd: string | undefined): boolean =>
  isEditableInputTp(inputTpCd);

// 비활성 체크 토글 게이트 (계약 ⑥ — CHECKED/UNCHECKED 서버 2값만 토글. 그 외 값 = 잠금)
export const isDisableToggleable = (value: unknown): boolean => isCheckToggleable(value);

// 승인 D-PJT Code 6자리 게이트 (P-08 — SP WHERE LENGTH=6 가드의 FE 선검증 D12.
//   '수정' 행은 SP 가 기존 CODE 유지(P-06) — 검증은 현재 행 값 기준 동일 적용)
export const isDpjtCodeValid = (dpjtCode: unknown): boolean =>
  toText(dpjtCode).trim().length === DPJT_CODE_LENGTH;
