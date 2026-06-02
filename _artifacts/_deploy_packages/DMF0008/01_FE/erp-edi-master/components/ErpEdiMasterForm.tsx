import { useEffect, useMemo } from 'react';

import { useTabProcQuery } from '@shared/hooks';

import { DIVISION_FALLBACK, MENU_ID, SHEETS } from '../erp-edi-master.constants';
import { useErpEdiMasterStore } from '../useErpEdiMasterStore';

import styles from './ErpEdiMasterForm.module.scss';

interface Props {
  onSearch: () => void;
}

interface DivisionRow {
  CODE?: string;
  NAME?: string;
}

// AS-IS Designer.cs 조회조건:
//   - Division: .cs L116 dtDivision = Data.Common(Data.Type.MyDivision)
//     → To-Be: DMF0008_GET_MY_DIVISION_LIST (사용자 권한 기반 SCM_MST_DIVISION + PR_SCM_EDIT_YN)
//   - Period 제거 (사용자 요구 2026-06-02 — Status Update 로 대체)
//   - 초기화 버튼 삭제
export const ErpEdiMasterForm = ({ onSearch }: Props) => {
  const searchCondition = useErpEdiMasterStore(s => s.searchCondition);
  const setSearchCondition = useErpEdiMasterStore(s => s.setSearchCondition);

  // AS-IS .cs L116: dtDivision = DataService.GetDMInnerTable("MyDivision", Filter)
  const { data: divisionData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.DIVISION,
    filters: {},
    enabled: true,
  });

  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const rows = (divisionData?.o_rc1 ?? []) as DivisionRow[];
    if (rows.length === 0) {
      // SP 호출 실패 또는 권한 없음 시 fallback
      return [...DIVISION_FALLBACK];
    }
    // ⛔ NUMBER → String cast 의무 (메모리: feedback_no_type_cast_around_runtime)
    return rows.map(r => ({
      value: String(r.CODE ?? ''),
      label: `${String(r.CODE ?? '')} (${String(r.NAME ?? '')})`,
    }));
  }, [divisionData]);

  // AS-IS InitControls: 첫 옵션 자동 선택 (현재 값이 list 에 없으면)
  useEffect(() => {
    if (divisionOptions.length === 0) return;
    const exists = divisionOptions.some(o => o.value === searchCondition.divisionId);
    if (!exists) {
      setSearchCondition({ divisionId: divisionOptions[0].value });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions]);

  return (
    <div className={styles.searchBar}>
      <div className={styles.searchRow}>
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Division</span>
          <select
            className={styles.select}
            value={searchCondition.divisionId}
            onChange={e => setSearchCondition({ divisionId: e.target.value })}
          >
            {divisionOptions.map(o => (
              <option key={o.value} value={o.value}>
                {o.label}
              </option>
            ))}
          </select>
        </div>

        <button type='button' className={styles.searchButton} onClick={onSearch}>
          조회 (F5)
        </button>
      </div>
    </div>
  );
};
