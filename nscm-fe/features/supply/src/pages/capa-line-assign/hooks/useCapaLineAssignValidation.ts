import { COLUMN, DATE_COLUMN_AXIS_LABEL } from '../capa-line-assign.constants';
import type { GridRow } from '../capa-line-assign.types';
import { isDateColumn } from '../utils/capaLineAssign.editLock';

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

/** 전 SAVE SP 공통 7키 — 하나라도 공백이면 서버가 **에러 없이** 그 행을 버린다(design 03 §4.3-d). */
const COMMON_KEYS: readonly string[] = [
  COLUMN.DIVISION_ID,
  COLUMN.COMPANY_ID,
  COLUMN.SITE_ID,
  COLUMN.PLANT_ID,
  COLUMN.FACTORY_ID,
  COLUMN.LINE_ID,
  COLUMN.OPERATION_ID,
];

export interface MissingKey {
  column: string;
  rowIndex: number;
}

/**
 * 저장 전 업무 검증 — AS-IS 에는 없고 **서버에도 없다**.
 *
 * 13본 SAVE/CHECK SP 전체에 `RAISERROR` 가 0건이고(§4.3-e), 필수키가 비면 `result_code='S'` 를
 * 돌려주면서 그 행만 조용히 버린다(§4.3-d). 즉 "저장했습니다" 토스트가 뜨는데 데이터는 안 들어간다.
 * 그래서 업무 검증은 전적으로 FE 책임이다(K-18).
 *
 * 메타 기반 필수검증(`useSaveWithValidation`)과는 **별개 축**이다 — 그쪽은 `INPUT_TP_CD=M/IM`
 * 컬럼을 보고, 이쪽은 SP 가 실제로 행을 버리는 조건을 본다. 둘 다 건다.
 */
export const useCapaLineAssignValidation = () => {
  /**
   * @param rows 저장 대상 행(CRUD_TYPE 마킹분)
   * @param options.isEltr        Electrode 시트 여부
   * @param options.isSop         SOP 탭 여부
   * @param options.dateBindings  Assign 탭의 동적 기간컬럼 binding 목록(SOP 는 미해당 = 빈 배열)
   */
  const findDroppedRowKey = (
    rows: GridRow[],
    options: { isEltr: boolean; isSop: boolean; dateBindings: readonly string[] }
  ): MissingKey | null => {
    const { isEltr, isSop, dateBindings } = options;
    /**
     * `YYYYMM` 공백 탈락(design 03 §4.3-d) — Assign SAVE SP 는 `p_date_column_names` 를 `;` 로
     * 쪼개 `M_01YYYYMM`/`Y_YYYY` 에서 `YYYYMM` 을 뽑는다. 이름이 하나도 없으면 그 행은 통째로
     * 버려지는데 `result_cnt` 는 전송 행 수를 그대로 돌려주므로 **성공 토스트가 뜬다**(§4.3-e).
     * 실제 발생 경로: `SPREAD_TITLE` 미응답(Version 공백 / SP 미배포) → `dateBindings` 0건.
     * 이름 목록은 행과 무관하게 같으므로 행 루프 앞에서 1회만 판정한다.
     */
    const hasDateColumnNames = !isSop && dateBindings.some(isDateColumn);
    if (!isSop && !hasDateColumnNames && rows.length > 0) {
      return { column: DATE_COLUMN_AXIS_LABEL, rowIndex: 0 };
    }
    for (let index = 0; index < rows.length; index += 1) {
      const row = rows[index];
      for (const column of COMMON_KEYS) {
        if (!str(row[column])) return { column, rowIndex: index };
      }
      if (isSop) {
        // SAVE_SOP_ASSEMBLY 는 `ELTR_LN_TP_CD` 도 검사한다. SOP_ELTR 은 그 검사가 주석 처리돼 있다.
        if (!isEltr && !str(row[COLUMN.ELTR_LN_TP_CD])) {
          return { column: COLUMN.ELTR_LN_TP_CD, rowIndex: index };
        }
        continue;
      }
      if (isEltr) {
        // SAVE_ASSIGN_ELTR — `ITEM_ID` 단독 공백이면 탈락(ELTR 은 ITEM_ID 가 주키).
        if (!str(row[COLUMN.ITEM_ID])) return { column: COLUMN.ITEM_ID, rowIndex: index };
        continue;
      }
      // SAVE_ASSIGN_ASSEMBLY — `ELTR_LN_TP_CD` 공백 탈락 + (`ITEM_ID`·`NICK_NAME` 둘 다 공백) 탈락.
      if (!str(row[COLUMN.ELTR_LN_TP_CD])) {
        return { column: COLUMN.ELTR_LN_TP_CD, rowIndex: index };
      }
      if (!str(row[COLUMN.ITEM_ID]) && !str(row[COLUMN.NICK_NAME])) {
        return { column: COLUMN.NICK_NAME, rowIndex: index };
      }
    }
    return null;
  };

  return { findDroppedRowKey };
};
