// SSP0014 편집잠금/셀 판정 (design 01_layout §2.2, 03_grid-columns §3 white-list).
//   순수 함수 — 그리드는 조회 직후부터 기본 편집 가능(Edit 토글 없음, 사용자 지시).
//   편집 가능 대상은 VALID_YN(인라인 콤보 편집) + USER 계열 7(더블클릭 팝업, 인라인 편집 아님).
//   그 외 13열(키/이름/감사)은 lock 유지(cs:274-278).

import { USER_POPUP_COLUMNS, VALID_YN_COLUMN } from '../shipment-model-pic.constants';

const USER_SET = new Set<string>(USER_POPUP_COLUMNS);

// 팝업 셀(이미지셀 7) — 더블클릭 UserInfoPopup 로만 값 입력. 인라인 편집은 취소한다(nscm-patterns §5-16).
export const isUserPopupColumn = (binding: string): boolean => USER_SET.has(binding);

// 인라인 편집 허용 셀 — VALID_YN(콤보) 만. USER 계열은 팝업 전용이라 인라인 편집 불가.
export const isInlineEditable = (binding: string): boolean => binding === VALID_YN_COLUMN;
