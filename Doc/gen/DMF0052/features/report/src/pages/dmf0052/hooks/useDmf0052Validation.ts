// DMF0052 EDISummary — TobeGen 생성 골격 (As-is DMF0052_EDISummary, Fact Pack Doc/asisfacts/screens/DMF0052)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is Validation 100% 적용 (룰 09) — Doc/_analysis/.../DMF0052_EDISummary/validation.md 4건.
//   V-nnn 마커는 게이트(check.js V01)가 센다 — 삭제·병합 금지. 적용이 끝나면 apply 본문을 채우고 마커는 유지.
import { useCallback } from 'react';

export interface AsisValidationRule {
  id: string;        // V-nnn (validation.md #)
  asisLine: number;  // As-is .cs 줄
  msg?: string;      // MSG 코드 → t('msg.MSGxxxxx')
  apply: () => void; // TODO(이식): 조건·차단 로직
}

export const DMF0052_VALIDATIONS: AsisValidationRule[] = [
  // V-001 [사업부분기/GMessageBox] L283 FindData_Main MSG00097
  //   As-is: if (sEDISender == "") → 사용자 통보 "Division 을 선택하세요."
  { id: 'V-001', asisLine: 283, msg: 'MSG00097', apply: () => { /* TODO(이식): 사업부분기 — 사용자 통보 */ } },
  // V-002 [날짜기간/GMessageBox] L292 FindData_Main MSG00108
  //   As-is: if (sEDISender == "") if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) → 사용자 통보 "조회된 데이터가 없습니다."
  { id: 'V-002', asisLine: 292, msg: 'MSG00108', apply: () => { /* TODO(이식): 날짜기간 — 사용자 통보 */ } },
  // V-003 [기타/사전검증분기] L572 spdPjt_CellDoubleClick
  //   As-is: siPjt.ActiveSheet.Rows.Count <= 0 → 조건 미충족 시 종료
  { id: 'V-003', asisLine: 572, msg: undefined, apply: () => { /* TODO(이식): 기타 — 조건 미충족 시 종료 */ } },
  // V-004 [기타/사전검증분기] L634 spdData_CellDoubleClick
  //   As-is: siMain.ActiveSheet.Rows.Count <= 0 → 조건 미충족 시 종료
  { id: 'V-004', asisLine: 634, msg: undefined, apply: () => { /* TODO(이식): 기타 — 조건 미충족 시 종료 */ } },
];

export const useDmf0052Validation = () => {
  // 저장/조회 직전에 순서대로 적용한다. 실패 시 메시지(MSG) 후 중단 — As-is GMessageBox 흐름 1:1.
  const runAll = useCallback(() => { for (const r of DMF0052_VALIDATIONS) r.apply(); }, []);
  return { rules: DMF0052_VALIDATIONS, runAll };
};
