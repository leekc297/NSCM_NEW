// SCP0007 BOD — TobeGen 생성 골격 (As-is SCP0007_BOD, Fact Pack Doc/asisfacts/screens/SCP0007)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is Validation 100% 적용 (룰 09) — Doc/_analysis/.../SCP0007_BOD/validation.md 8건.
//   V-nnn 마커는 게이트(check.js V01)가 센다 — 삭제·병합 금지. 적용이 끝나면 apply 본문을 채우고 마커는 유지.
import { useCallback } from 'react';

export interface AsisValidationRule {
  id: string;        // V-nnn (validation.md #)
  asisLine: number;  // As-is .cs 줄
  msg?: string;      // TO-BE MSG 코드(AS-IS ID 를 문구로 재매핑 — Doc/gen/<ID>/msg_map.json). MSG????? = TO-BE 에 같은 문구 없음 → 신규 등록 후 기입
  apply: () => void; // TODO(이식): 조건·차단 로직
}

export const BOD_VALIDATIONS: AsisValidationRule[] = [
  // V-001 [기타/GMessageBox] Lundefined MSG00043 col="( Route Id : " + dtErr.Rows[0
  //   As-is: 865 → undefined "errMsg = "(Division/From Site/To Site/Incoterms/Priority)"; "
  { id: 'V-001', asisLine: 0, msg: 'MSG00043', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-002 [에러/GMessageBox] Lundefined MSG00003(AS-IS MSG00006 — KO 문구 일치)
  //   As-is: 932 → undefined "errorMsg += "Error!" + "\n";                                "
  { id: 'V-002', asisLine: 0, msg: 'MSG00003', apply: () => { /* TODO(이식): 에러 — undefined */ } },
  // V-003 [기타/GMessageBox] Lundefined SaveData_Main MSG00165 col=null
  //   As-is: 720 → undefined "if (Encoding.Default.GetByteCount(sRemarks) >= 150)         "
  { id: 'V-003', asisLine: 0, msg: 'MSG00165', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-004 [기타/GMessageBox] Lundefined SaveData_Main MSG01230(AS-IS MSG00219 — EN 문구 일치)
  //   As-is: 727 → undefined "//PJ20209642 : BOT LT 2단계 개발                         if (Con"
  { id: 'V-004', asisLine: 0, msg: 'MSG01230', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-005 [기타/GMessageBox] Lundefined SaveData_Main MSG01349(AS-IS MSG00355 — KO 문구 일치) col="FROM", "Monday"
  //   As-is: 735 → undefined "if (dtFromYyyymmdd.DayOfWeek != DayOfWeek.Monday)           "
  { id: 'V-005', asisLine: 0, msg: 'MSG01349', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-006 [기타/GMessageBox] Lundefined SaveData_Main MSG01349(AS-IS MSG00355 — KO 문구 일치) col="TO", "Sunday"
  //   As-is: 743 → undefined "if (dtToYyyymmdd.DayOfWeek != DayOfWeek.Sunday)             "
  { id: 'V-006', asisLine: 0, msg: 'MSG01349', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-007 [기타/GMessageBox] Lundefined SaveData_Main MSG01263(AS-IS MSG00253 — KO 문구 일치)
  //   As-is: 780 → undefined "if (iCount > 0 && !valid_chk)                     {         "
  { id: 'V-007', asisLine: 0, msg: 'MSG01263', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-008 [확인메시지/GMessageBox] Lundefined SaveData_Main MSG00672(AS-IS MSG00004 — KO 문구 일치) col=response.DataSet.Tables[0].Row
  //   As-is: 827 → undefined "if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")"
  { id: 'V-008', asisLine: 0, msg: 'MSG00672', apply: () => { /* TODO(이식): 확인메시지 — undefined */ } },
];

export const useBodValidation = () => {
  // 저장/조회 직전에 순서대로 적용한다. 실패 시 메시지(MSG) 후 중단 — As-is GMessageBox 흐름 1:1.
  const runAll = useCallback(() => { for (const r of BOD_VALIDATIONS) r.apply(); }, []);
  return { rules: BOD_VALIDATIONS, runAll };
};
