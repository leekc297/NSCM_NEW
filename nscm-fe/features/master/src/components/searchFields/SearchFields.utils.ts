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
