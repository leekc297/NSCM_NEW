import { useEffect, useState } from 'react';

import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../contribute-main.constants';
import styles from '../ContributeMain.module.scss';
import { useContributeMainStore } from '../useContributeMainStore';

interface VersionOption {
  CODE: string;
  NAME2?: string;
  NAME?: string;
}

interface Props {
  onSearch: () => void;
  onOpenVersionPopup: () => void;
}

// AS-IS DMF0043_Contribute_Main 조회 영역
//   - usrYear (Combo)        : 년도 선택 — GET_MAIN_VARSION_DATA SP
//   - chkYear (Checkbox)     : 년도별 필터
//   - usrDiscard (Checkbox)  : 불일치 조회
//   - usrHis (Checkbox)      : History
//   - btnCutOff (Button)     : 기여율버전관리 POPUP (현재 비활성, hidden)
//
// AS-IS 미반영 (룰 24 §3.5):
//   - 초기화 버튼 (BaseForm reset 패턴)
//   - F5=조회 ~ F12=Excel hint 라벨 (BaseForm hotkey hint)
//   → SubTitle 컴포넌트의 hotkeyConfig 로 통합
export const SearchBar = ({ onSearch, onOpenVersionPopup }: Props) => {
  const searchCondition = useContributeMainStore(s => s.searchCondition);
  const setSearchCondition = useContributeMainStore(s => s.setSearchCondition);

  // 년도 콤보 데이터 — DMF0043_GET_MAIN_VARSION_DATA standalone SP
  const { data: yearData, isLoading: yearLoading } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters: {},
    enabled: true,
  });

  const [yearOptions, setYearOptions] = useState<VersionOption[]>([]);

  useEffect(() => {
    const rows = (yearData?.o_rc1 ?? []) as unknown as VersionOption[];
    setYearOptions(rows);
    // AS-IS InitControls — 첫 옵션 자동 선택
    if (rows.length > 0 && !searchCondition.verSeq) {
      const first = rows[0];
      setSearchCondition({
        verSeq: String(first.CODE ?? ''),
        yyyy: String(first.NAME2 ?? first.NAME ?? '').substring(0, 4),
      });
    }
  }, [yearData]);

  return (
    <div className={styles.searchBar}>
      <div className={styles.searchRow}>
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Year</span>
          <select
            className={styles.yearSelect}
            value={searchCondition.verSeq}
            onChange={e => {
              const opt = yearOptions.find(o => String(o.CODE) === e.target.value);
              setSearchCondition({
                verSeq: e.target.value,
                yyyy: String(opt?.NAME2 ?? opt?.NAME ?? '').substring(0, 4),
              });
            }}
          >
            <option value=''>{yearLoading ? '로딩 중...' : '선택'}</option>
            {yearOptions.map(o => (
              <option key={String(o.CODE)} value={String(o.CODE)}>
                {String(o.NAME2 ?? o.NAME ?? o.CODE)}
              </option>
            ))}
          </select>
        </div>

        {/* AS-IS chkYear: 토글 시 즉시 Y#/M# 컬럼 가시성 토글 — Grid 측에서 store 구독 (재조회 X) */}
        <label className={styles.checkField}>
          <input
            type='checkbox'
            checked={searchCondition.chkYear}
            onChange={e => setSearchCondition({ chkYear: e.target.checked })}
          />
          년도별
        </label>

        {/* AS-IS usrDiscard_Click : his=false 강제 + 즉시 재조회 */}
        <label className={styles.checkField}>
          <input
            type='checkbox'
            checked={searchCondition.dis === 'N'}
            onChange={e => {
              setSearchCondition({ dis: e.target.checked ? 'N' : 'ALL', his: 'N' });
              // 다음 paint 후 재조회 (state 반영 보장)
              setTimeout(onSearch, 0);
            }}
          />
          불일치조회
        </label>

        {/* AS-IS usrHis_CheckedChanged : dis='ALL' 강제 + 즉시 재조회 */}
        <label className={styles.checkField}>
          <input
            type='checkbox'
            checked={searchCondition.his === 'Y'}
            onChange={e => {
              setSearchCondition({ his: e.target.checked ? 'Y' : 'N', dis: 'ALL' });
              setTimeout(onSearch, 0);
            }}
          />
          History
        </label>

        {/* 기여율버전관리 — 일단 hidden (룰 보강 후 재노출 검토) */}
        <button type='button' className={styles.cutoffButton} onClick={onOpenVersionPopup} hidden>
          기여율버전관리
        </button>

        <button type='button' className={styles.searchButton} onClick={onSearch}>
          조회 (F5)
        </button>
      </div>
    </div>
  );
};
