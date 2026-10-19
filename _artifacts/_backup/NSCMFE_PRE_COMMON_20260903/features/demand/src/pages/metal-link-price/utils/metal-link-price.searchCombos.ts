/**
 * Sales Site 콤보를 다시 만든 계기. AS-IS 는 네 곳에서 만드는데 펼치는 곳이 한 곳뿐이라
 * 진입과 그 이후만 구분하면 된다.
 */
export type SalesSiteComboTrigger = 'entry' | 'change';

/**
 * Sales Site 콤보에 걸 END_CUSTOMER 코드 집합 - AS-IS CString.GetCheckedListValue 재현.
 *
 * AS-IS 는 Sales Site 를 네 곳에서 다시 만드는데, 전체선택을 고객 전체 CODE 로 펼치는 곳은
 * 진입 한 곳뿐이다.
 *
 *   진입           :212  GetCheckedListValue(dtEndCustomer, ...)  펼침
 *   Division 변경  :567  GetCheckedListValue(dtCustomer,    ...)  안 펼침
 *   Team 변경      :622  GetCheckedListValue(dtCustomer,    ...)  안 펼침
 *   End Customer   :628  clbEndCustomer.ControlValues             안 펼침
 *
 * dtCustomer 는 .cs :48 에서 null 로 선언만 되고 값이 들어가지 않는다. GetCheckedListValue 는
 * 테이블이 null 이면 받은 값을 그대로 돌려주므로(CString.cs :531) 저 두 곳은 펼치기가 없는
 * 것과 같다. 콤보구성 문서 §4-4 가 지적한 결함이지만 화면에 보이는 목록이 달라지므로 옮긴다.
 *
 * 차이가 드러나는 지점: 펼치면 END_CUSTOMER 축이 켜져 그 컬럼이 비어 있는 사이트 행이 잘리고,
 * 안 펼치면 축이 통째로 꺼져 그 행들이 살아남는다. 진입 직후와 조작 후의 목록이 다를 수 있다.
 *
 * @param controlValues 스토어가 들고 있는 콤마조인 선택값 (전체선택은 'ALL' sentinel)
 */
export const resolveEndCustomerCodes = (
  trigger: SalesSiteComboTrigger,
  controlValues: string,
  options: readonly { value: string }[]
): string[] => {
  // 전체선택('ALL')과 전체해제는 필터상 같다 - 둘 다 빈 목록이 된다
  //   (bigFilterCombo 의 toSelectedCodes 와 같은 규칙. 테스트가 이 파일만 읽도록 여기에 둔다).
  const selected = controlValues
    .split(',')
    .map(value => value.trim())
    .filter(value => value !== '' && value.toUpperCase() !== 'ALL');
  if (selected.length > 0) return selected;

  // 미선택 = 'ALL'. 진입만 목록 전체로 펼치고, 그 뒤로는 빈 목록 = 축 미적용이다.
  return trigger === 'entry' ? options.map(option => option.value) : [];
};
