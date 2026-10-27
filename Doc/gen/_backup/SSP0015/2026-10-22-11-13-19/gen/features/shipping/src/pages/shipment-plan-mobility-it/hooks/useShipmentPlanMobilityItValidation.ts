// SSP0015 ShipmentPSI — TobeGen 생성 골격 (As-is SSP0015_ShipmentPSI, Fact Pack Doc/asisfacts/screens/SSP0015)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is Validation 100% 적용 (룰 09) — Doc/_analysis/.../SSP0015_ShipmentPSI/validation.md 16건.
//   V-nnn 마커는 게이트(check.js V01)가 센다 — 삭제·병합 금지. 적용이 끝나면 apply 본문을 채우고 마커는 유지.
import { useCallback } from 'react';

export interface AsisValidationRule {
  id: string;        // V-nnn (validation.md #)
  asisLine: number;  // As-is .cs 줄
  msg?: string;      // MSG 코드 → t('msg.MSGxxxxx')
  apply: () => void; // TODO(이식): 조건·차단 로직
}

export const SHIPMENTPLANMOBILITYIT_VALIDATIONS: AsisValidationRule[] = [
  // V-001 [기타/GMessageBox] Lundefined MSG00284
  //   As-is: 5614 → undefined "*/                                      //보안취약점 조치 사항       "
  { id: 'V-001', asisLine: 0, msg: 'MSG00284', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-002 [기타/GMessageBox] Lundefined MSG00324
  //   As-is: 5840 → undefined "else if (ds.Tables[0].Rows[0][0].ToString() == "X")         "
  { id: 'V-002', asisLine: 0, msg: 'MSG00324', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-003 [기타/GMessageBox] Lundefined MSG00324
  //   As-is: 5846 → undefined "}                                     // Old Code           "
  { id: 'V-003', asisLine: 0, msg: 'MSG00324', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-004 [기타/GMessageBox] Lundefined MSG00284
  //   As-is: 5862 → undefined "*/                                      //보안취약점 조치 사항       "
  { id: 'V-004', asisLine: 0, msg: 'MSG00284', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-005 [확인메시지/GMessageBox] Lundefined MSG00004 col=t.DataSet.Tables[0].Rows[0][1]
  //   As-is: 5979 → undefined "if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")       "
  { id: 'V-005', asisLine: 0, msg: 'MSG00004', apply: () => { /* TODO(이식): 확인메시지 — undefined */ } },
  // V-006 [기타/GMessageBox] Lundefined MSG00284
  //   As-is: 5994 → undefined "*/                                  //보안취약점 조치 사항           "
  { id: 'V-006', asisLine: 0, msg: 'MSG00284', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-007 [확인메시지/GMessageBox] Lundefined MSG00004 col=t.DataSet.Tables[0].Rows[0][1]
  //   As-is: 6079 → undefined "if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")       "
  { id: 'V-007', asisLine: 0, msg: 'MSG00004', apply: () => { /* TODO(이식): 확인메시지 — undefined */ } },
  // V-008 [기타/GMessageBox] Lundefined MSG00284
  //   As-is: 6101 → undefined "else                             {                          "
  { id: 'V-008', asisLine: 0, msg: 'MSG00284', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-009 [확인메시지/GMessageBox] Lundefined MSG00004 col=t.DataSet.Tables[0].Rows[0][1]
  //   As-is: 6186 → undefined "if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")       "
  { id: 'V-009', asisLine: 0, msg: 'MSG00004', apply: () => { /* TODO(이식): 확인메시지 — undefined */ } },
  // V-010 [기타/GMessageBox] Lundefined MSG00284
  //   As-is: 6208 → undefined "else                             {                          "
  { id: 'V-010', asisLine: 0, msg: 'MSG00284', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-011 [기타/GMessageBox] Lundefined MSG00286 col=(i + 1).ToString()
  //   As-is: 6443 → undefined "siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefCol"
  { id: 'V-011', asisLine: 0, msg: 'MSG00286', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-012 [기타/GMessageBox] Lundefined MSG00204 col=arg
  //   As-is: 6662 → undefined "}                      object arg = F_CE_requestNo.ToString("
  { id: 'V-012', asisLine: 0, msg: 'MSG00204', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-013 [기타/GMessageBox] Lundefined MSG00284
  //   As-is: 7097 → undefined "*/                          //보안취약점 조치 사항                   "
  { id: 'V-013', asisLine: 0, msg: 'MSG00284', apply: () => { /* TODO(이식): 기타 — undefined */ } },
  // V-001 [확인메시지/GMessageBox] Lundefined SaveData MSG00012
  //   As-is: 331 → undefined "p_change_flag = "N";                 }                      "
  { id: 'V-001', asisLine: 0, msg: 'MSG00012', apply: () => { /* TODO(이식): 확인메시지 — undefined */ } },
  // V-002 [확인메시지/GMessageBox] Lundefined SaveData MSG00004 col="1"
  //   As-is: 368 → undefined "{                                                          /"
  { id: 'V-002', asisLine: 0, msg: 'MSG00004', apply: () => { /* TODO(이식): 확인메시지 — undefined */ } },
  // V-003 [기타/GMessageBox] Lundefined SaveData MSG00284
  //   As-is: 376 → undefined "{                              //보안취약점 조치                   "
  { id: 'V-003', asisLine: 0, msg: 'MSG00284', apply: () => { /* TODO(이식): 기타 — undefined */ } },
];

export const useShipmentPlanMobilityItValidation = () => {
  // 저장/조회 직전에 순서대로 적용한다. 실패 시 메시지(MSG) 후 중단 — As-is GMessageBox 흐름 1:1.
  const runAll = useCallback(() => { for (const r of SHIPMENTPLANMOBILITYIT_VALIDATIONS) r.apply(); }, []);
  return { rules: SHIPMENTPLANMOBILITYIT_VALIDATIONS, runAll };
};
