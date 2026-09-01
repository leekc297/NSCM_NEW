// ⭐ SDM1020 — 편집/링크/체크박스 잠금 순수함수 (테스트 대상 — beginningEdit/formatItem 공용 단일 원천).
//   ⭐ 행 게이트 = **나의 권한 ADMIN 행만 편집** (P-01 — GET 커서 DPJT_AUTH_TYPE 행별 판정.
//     SDM1010 과 달리 신규행('C')·등록상태 축 없음 — 조회/변경 화면, 저장 버튼 없음 P-25).
//   셀 게이트 = UI Category Setup `INPUT_TP_CD` 단일 원천 (IM/IO = 편집 컬럼 — 정오표 D5 재지정 축.
//   S/미지정 = 불가). 색(Yellow/Gray)과 편집 판정이 같은 함수를 본다 — 갈리면 "노란칸인데 못 고침" 사고.
//   링크/체크박스 = SP 산출값 단일 원천 (P-02 '-' 봉인 / P-04 3상태 DISABLED — FE 재파생 금지).
import { AUTH_TYPE, LINK_SEALED, REG_STATUS, REQ_CHECK } from '../project-list.constants';
import type { MainRow } from '../project-list.types';

import { toText } from './project-list.value';

// 행 편집 게이트 (P-01) — 나의 권한 ADMIN 행만 (비관리자 행 = 전 셀 잠금 Gray)
export const isAdminRow = (row: MainRow | undefined): boolean =>
  !!row && toText(row.DPJT_AUTH_TYPE) === AUTH_TYPE.ADMIN;

export const isRejectRow = (row: MainRow | undefined): boolean =>
  !!row && toText(row.DPJT_REG_STATUS) === REG_STATUS.REJECT;
// 셀 편집 게이트 — INPUT_TP_CD 메타 × ADMIN 행 (하드코딩 컬럼 목록 금지. FPCheckBox 셀은
//   isReqCheckToggleable 이 별도 지배 — beginningEdit 에서 편집기 자체를 차단하고 클릭 토글만 허용)
export const isCellEditable = (
  inputTpCd: string | undefined,
  row: MainRow | undefined
): boolean => {
  if (!row || !isAdminRow(row) || isRejectRow(row)) return false;
  switch (inputTpCd) {
    case 'IM':
    case 'IO':
    case 'M':
    case 'O':
      return true;
    default: // 'S' 및 미지정
      return false;
  }
};

// 권한요청 체크박스 토글 게이트 (P-04) — 서버 3상태 단일 원천 (DISABLED = 잠금)
export const isReqCheckToggleable = (value: unknown): boolean => {
  const s = toText(value);
  return s === REQ_CHECK.CHECKED || s === REQ_CHECK.UNCHECKED;
};

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
