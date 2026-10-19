// ⭐ SDM1020 — 편집/링크/체크박스 잠금 순수함수 (테스트 대상 — beginningEdit/formatItem 공용 단일 원천).
//   ⭐ 행 게이트 = GET 커서 MOD_ROW_YN='Y'인 행만 편집 (P-01 — 프로시저 판정 단일 원천).
//   셀 게이트 = UI Category Setup `INPUT_TP_CD` 단일 원천 (IM/IO = 편집 컬럼 — 정오표 D5 재지정 축.
//   S/미지정 = 불가). 색(Yellow/Gray)과 편집 판정이 같은 함수를 본다 — 갈리면 "노란칸인데 못 고침" 사고.
//   링크/체크박스 = SP 산출값 단일 원천 (P-02 '-' 봉인 / P-04 3상태 DISABLED — FE 재파생 금지).
import { isCheckToggleable, isEditableInputTp } from '../../../lib/grid';
import { LINK_SEALED, REQ_CHECK } from '../project-list.constants';
import type { MainRow } from '../project-list.types';

import { toText } from './project-list.value';

// 행 편집 게이트 (P-01) — 프로시저가 편집 가능 여부를 행별로 판정한다.
export const isModifiableRow = (row: MainRow | undefined): boolean =>
  !!row && toText(row.MOD_ROW_YN) === 'Y';

// 셀 편집 게이트 — INPUT_TP_CD 메타 × 편집 가능 행 (하드코딩 컬럼 목록 금지. FPCheckBox 셀은
//   isReqCheckToggleable 이 별도 지배 — beginningEdit 에서 편집기 자체를 차단하고 클릭 토글만 허용)
export const isCellEditable = (
  inputTpCd: string | undefined,
  row: MainRow | undefined
): boolean => {
  if (!row || !isModifiableRow(row)) return false;
  return isEditableInputTp(inputTpCd); // 'S' 및 미지정 = 불가 (컬럼 축 = SDM 공통)
};

// 권한요청 체크박스 토글 게이트 (P-04) — 서버 3상태 단일 원천 (DISABLED = 잠금)
export const isReqCheckToggleable = (value: unknown): boolean => isCheckToggleable(value);

// 권한관리 링크 게이트 (P-02) — SP 가 ADMIN 행만 ''(NULL·노출), 그 외 '-'(봉인). 값 단일 원천
export const canOpenAuthMgmt = (row: MainRow | undefined): boolean =>
  !!row && toText(row.DPJT_AUTH_MGMT) !== LINK_SEALED;

// 권한요청 링크 게이트 (P-03) — 체크박스 3상태에서 파생: 둘 다 DISABLED(ADMIN·WRITE CONFIRM) = 봉인 '-'
export const canReqAuth = (row: MainRow | undefined): boolean =>
  !!row &&
  (isReqCheckToggleable(row.DPJT_AUTH_REQ_WRITE) || isReqCheckToggleable(row.DPJT_AUTH_REQ_READ));

// 체크 존재 판정 (P-11/P-12 — 현재값·원본값 공용 술어)
export const hasCheckedReq = (write: unknown, read: unknown): boolean =>
  toText(write) === REQ_CHECK.CHECKED || toText(read) === REQ_CHECK.CHECKED;
