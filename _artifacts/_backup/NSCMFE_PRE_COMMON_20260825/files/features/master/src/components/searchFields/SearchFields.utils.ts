/**
 * ⭐ 조회조건 팝업 3종(Owner / Model·Nickname / Project) 공통 가로 폭 (2026-08-06 사용자 요청 —
 *   "owner, model, project 세 개 사이즈 같도록"). 이전에는 1200 / 1000 / 1000 으로 제각각이라
 *   같은 조회조건 행에서 팝업을 띄울 때마다 크기가 달라 보였다.
 *
 * ⚠ CustomDialog 는 size 에 DIALOG_SCALE(1.5) 을 곱한다 → 실제 렌더 폭 = 900 * 1.5 = 1350px.
 *   값 산정 기준은 셋 중 컬럼이 가장 많은 Model/Nickname(11컬럼) — 더 줄이면 Team 등 긴 텍스트
 *   컬럼의 말줄임이 심해진다.
 *
 * 위치 — 이 셋은 SearchFields 카탈로그(Project/Item/OwnerField)가 띄우는 팝업이라 카탈로그
 *   유틸에 둔다. SearchFields.tsx 본체는 세 모달을 import 하므로 거기 두면 순환이 된다.
 */
export const SEARCH_POPUP_WIDTH = 900;

// DivisionField 자동 보정 — 각 화면 스토어의 divisionId 기본값은 하드코딩('40'/'81' 등)이고
//   persist 로 남는다. 사용자 보유 Div(MyDivision 콤보)에 그 값이 없으면 CustomDropdown 이
//   options.find(o => o.value === value) → undefined 로 빈칸을 렌더한다(필수 필드인데 미선택).
//   해법: 옵션이 도착한 뒤 값이 미보유면 첫 옵션으로 보정. NnMasterMappingForm L145~155 선례 동일.
/**
 * @returns 보정할 division 값. 보정이 필요 없으면 null (유효한 선택은 절대 덮어쓰지 않는다).
 */
export const resolveDivisionAutoSelect = (
  options: { value: string }[],
  value: string
): string | null => {
  // 콤보 로딩 중/권한 0건 — 기존 값 보존 (여기서 덮어쓰면 도착 후 되돌릴 근거가 사라진다)
  if (options.length === 0) return null;
  if (options.some(o => o.value === value)) return null;
  return options[0].value;
};
