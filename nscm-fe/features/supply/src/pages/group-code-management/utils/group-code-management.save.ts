import type { TFunction } from 'i18next';

import { BASIC_END_CUSTOMER_MAX_LEN, MSG } from '../group-code-management.constants';
import type { GroupCodeRow } from '../group-code-management.types';

// useMessageStore.setToast 인자 구조형(스토어가 ToastProps 를 export 하지 않아 최소 구조로 재선언).
type ToastArg = { message: string; type?: 'default' | 'success' | 'error' | 'warning' };

// SAVE SP 실측 계약 (DB ALL_SOURCE PKG_SCP0080.P_SCP0080_SAVE_GROUP_CODE_MANAGEMENT):
//   - 39 IN 전부 CLOB, 행 index 정렬로 V_DELIMITER='^' 연접(설계 03 §4-2 의 '|' 는 C# 표기 — 실 SP 는 '^').
//   - 행 식별 = DIVISION_ID + MODEL_ID(=ITEM_ID). WHEN MATCHED UPDATE 만(MERGE INTO SCP_MST_FINAL_ITEM).
//     신규 master row INSERT 없음 → Insert/Delete 버튼 NO-OP 와 정합(수정행 'M' 만 저장).
//   - USER_ID 토큰 = 감사 사용자(M.LAST_UPDATED_BY = A.USER_ID). 행별 세션 userId 반복(PIC 아님).
//   - SALES_PRIORITY 는 SP 가 숫자 아니면 NULL 처리 — FE 는 값 가공 없이 원본 문자열 전달.
const SAVE_DELIMITER = '^';

// SAVE payload 필드 (39 IN, camelCase — BE makeProcedure 가 PROC_M COL_NM 으로 P_* 에 매핑).
//   나열 순서는 무관(키 매칭)이나 SP IN 순서와 동일하게 둬 대사 편의를 준다.
interface SaveField {
  divisionId: string;
  modelId: string;
  picId: string;
  salesModel: string;
  salesValidYn: string;
  salesPriority: string;
  salesFromYyyymmdd: string;
  salesToYyyymmdd: string;
  userId: string;
  level1Group: string;
  level2Code: string;
  statusPrototype: string;
  statusMass: string;
  statusNew: string;
  replacement: string;
  basicEndCustomer: string;
  basicFinishedProduct: string;
  mktDept: string;
  remark: string;
  groupCode1: string;
  groupCode2: string;
  groupCode3: string;
  groupCode4: string;
  groupCode5: string;
  groupCode6: string;
  groupCode7: string;
  groupCode8: string;
  groupCode9: string;
  groupCode10: string;
  attribute1: string;
  attribute2: string;
  attribute3: string;
  attribute4: string;
  attribute5: string;
  attribute6: string;
  attribute7: string;
  attribute8: string;
  attribute9: string;
  attribute10: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 81 계열만 SALES 검증 대상 (AS-IS this._division.Substring(0,2)=='81' 게이트, 03 §3-4).
const isSalesValidationDivision = (divisionId: string): boolean => divisionId.startsWith('81');

// SP IN 순서대로 행 -> SaveField. USER_ID 는 감사 사용자(세션)라 여기서 주입.
const toSaveField = (row: GroupCodeRow, userId: string): SaveField => ({
  divisionId: str(row.DIVISION_ID),
  modelId: str(row.ITEM_ID),
  picId: str(row.PIC_ID),
  salesModel: str(row.SALES_MODEL),
  salesValidYn: str(row.SALES_VALID_YN),
  salesPriority: str(row.SALES_PRIORITY),
  salesFromYyyymmdd: str(row.SALES_FROM_YYYYMMDD),
  salesToYyyymmdd: str(row.SALES_TO_YYYYMMDD),
  userId,
  level1Group: str(row.LEVEL1_GROUP),
  level2Code: str(row.LEVEL2_CODE),
  statusPrototype: str(row.STATUS_PROTOTYPE),
  statusMass: str(row.STATUS_MASS),
  statusNew: str(row.STATUS_NEW),
  replacement: str(row.REPLACEMENT),
  basicEndCustomer: str(row.BASIC_END_CUSTOMER),
  basicFinishedProduct: str(row.BASIC_FINISHED_PRODUCT),
  mktDept: str(row.MKT_DEPT),
  remark: str(row.REMARK),
  groupCode1: str(row.GROUP_CODE1),
  groupCode2: str(row.GROUP_CODE2),
  groupCode3: str(row.GROUP_CODE3),
  groupCode4: str(row.GROUP_CODE4),
  groupCode5: str(row.GROUP_CODE5),
  groupCode6: str(row.GROUP_CODE6),
  groupCode7: str(row.GROUP_CODE7),
  groupCode8: str(row.GROUP_CODE8),
  groupCode9: str(row.GROUP_CODE9),
  groupCode10: str(row.GROUP_CODE10),
  attribute1: str(row.ATTRIBUTE1),
  attribute2: str(row.ATTRIBUTE2),
  attribute3: str(row.ATTRIBUTE3),
  attribute4: str(row.ATTRIBUTE4),
  attribute5: str(row.ATTRIBUTE5),
  attribute6: str(row.ATTRIBUTE6),
  attribute7: str(row.ATTRIBUTE7),
  attribute8: str(row.ATTRIBUTE8),
  attribute9: str(row.ATTRIBUTE9),
  attribute10: str(row.ATTRIBUTE10),
});

// 저장검증 (03 §3-4 validations). 실패 시 toast + null 반환(SP 미전송). 통과 시 39 IN '^' payload.
//   - V-DATE-ORDER(MSG00048, 81*): SALES_FROM > SALES_TO 시 중단.
//   - V-ENDCUST-LEN(81*): BASIC_END_CUSTOMER 길이 50 초과 시 중단.
//   - V-SALES-MODEL(81*): SALES_MODEL 유효성은 AS-IS 가 ProductionModels(ITEM_ID) Contains 로 검증하나,
//       그 원천 목록은 조회 커서에 없어(별도 GTT) FE 단독 재현 불가 -> react-gap(확인필요)로 남긴다.
//       현재는 미검증 통과(SP 측 MERGE 키 미매치 시 무반영). 값 위조 금지 원칙상 가짜 통과 로직 만들지 않음.
//   - V-SALES-PRIORITY: AS-IS 무력화(항상 true, cs:743) — 재현 안 함(과충실 금지, 03 §3-4 주).
//   productionModels(V-SALES-MODEL 원천) 는 호출측이 알 수 없어 인자로 받지 않는다.
export const buildSaveRows = (
  dirtyRows: GroupCodeRow[],
  divisionId: string,
  userId: string,
  t: TFunction,
  setToast: (toast: ToastArg) => void
): Record<string, string> | null => {
  const salesGate = isSalesValidationDivision(divisionId);

  for (const row of dirtyRows) {
    if (salesGate) {
      // V-DATE-ORDER — 둘 다 값이 있을 때만 순서 비교(YYYYMMDD 사전식 = 수치 순서).
      const from = str(row.SALES_FROM_YYYYMMDD).trim();
      const to = str(row.SALES_TO_YYYYMMDD).trim();
      if (from && to && from > to) {
        setToast({
          type: 'error',
          message: t(MSG.DATE_ORDER, { defaultValue: '_Start date must not be later than end date.' }),
        });
        return null;
      }
      // V-ENDCUST-LEN — BASIC_END_CUSTOMER 50자 초과 금지 (AS-IS MessageBox "50 Over Digits!", 전용 MSG id 없음).
      if (str(row.BASIC_END_CUSTOMER).length > BASIC_END_CUSTOMER_MAX_LEN) {
        setToast({
          type: 'error',
          message: `Basic End Customer: ${BASIC_END_CUSTOMER_MAX_LEN} Over Digits!`,
        });
        return null;
      }
    }
  }

  const fields = dirtyRows.map(row => toSaveField(row, userId));
  const join = (pick: (f: SaveField) => string): string =>
    fields.map(pick).join(SAVE_DELIMITER);

  return {
    divisionId: join(f => f.divisionId),
    modelId: join(f => f.modelId),
    picId: join(f => f.picId),
    salesModel: join(f => f.salesModel),
    salesValidYn: join(f => f.salesValidYn),
    salesPriority: join(f => f.salesPriority),
    salesFromYyyymmdd: join(f => f.salesFromYyyymmdd),
    salesToYyyymmdd: join(f => f.salesToYyyymmdd),
    userId: join(f => f.userId),
    level1Group: join(f => f.level1Group),
    level2Code: join(f => f.level2Code),
    statusPrototype: join(f => f.statusPrototype),
    statusMass: join(f => f.statusMass),
    statusNew: join(f => f.statusNew),
    replacement: join(f => f.replacement),
    basicEndCustomer: join(f => f.basicEndCustomer),
    basicFinishedProduct: join(f => f.basicFinishedProduct),
    mktDept: join(f => f.mktDept),
    remark: join(f => f.remark),
    groupCode1: join(f => f.groupCode1),
    groupCode2: join(f => f.groupCode2),
    groupCode3: join(f => f.groupCode3),
    groupCode4: join(f => f.groupCode4),
    groupCode5: join(f => f.groupCode5),
    groupCode6: join(f => f.groupCode6),
    groupCode7: join(f => f.groupCode7),
    groupCode8: join(f => f.groupCode8),
    groupCode9: join(f => f.groupCode9),
    groupCode10: join(f => f.groupCode10),
    attribute1: join(f => f.attribute1),
    attribute2: join(f => f.attribute2),
    attribute3: join(f => f.attribute3),
    attribute4: join(f => f.attribute4),
    attribute5: join(f => f.attribute5),
    attribute6: join(f => f.attribute6),
    attribute7: join(f => f.attribute7),
    attribute8: join(f => f.attribute8),
    attribute9: join(f => f.attribute9),
    attribute10: join(f => f.attribute10),
  };
};
