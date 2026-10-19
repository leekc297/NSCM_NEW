// SSP0014 팝업 셀 판정 (design 03_grid-columns §3 R4/R6).
//   편집가능 여부는 이 파일이 아니라 admin 메타(SCM_MST_SHEET_COLUMNS.INPUT_TP_CD)가 정한다 —
//   실측 9열 편집(M 1 = USER_ID, O 8 = PART_LEADER/TEAM_LEADER/MAIL_USER1~5/VALID_YN) + S 12열 잠금.
//   화면이 beginningEdit 로 편집가능을 재정의하면 admin 속성 덮어쓰기 금지 룰 위반이다(CLAUDE.md §2-4,
//   hook #130: AS-IS LockColumn 을 FE 상수배열로 이식 금지).

import { USER_POPUP_COLUMNS } from '../shipment-model-pic.constants';

const USER_SET = new Set<string>(USER_POPUP_COLUMNS);

// 팝업 셀(AS-IS cellTypeImage = TextCellType + edit.png 배경, cs:162~164/225~233) — 더블클릭하면
//   UserInfoPopup 이 열린다. AS-IS 는 텍스트셀이라 직접 키인도 가능하고, TO-BE 메타도 동일하게
//   FPTextModal(= 키인 + 모달 동시 허용, foundation column-config.ts:12)로 등록돼 있다.
//   따라서 이 판정은 "더블클릭 팝업 대상인가"에만 쓰고 편집 차단에는 쓰지 않는다.
export const isUserPopupColumn = (binding: string): boolean => USER_SET.has(binding);
