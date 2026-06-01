import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../contribute-main.constants';
import type { ContributeRatePopupResult } from '../types';
import { useContributeMainStore } from '../useContributeMainStore';

interface Props {
  yyyy: string;
  onSelect?: (row: ContributeRatePopupResult) => void;
}

// AS-IS DMF0043_ContributeRatePopup — 기여율 설정 POPUP (룰 25 §3 자동 생성)
export const ContributeRatePopup = ({ yyyy, onSelect }: Props) => {
  const open = useContributeMainStore(s => s.ratePopupOpen);
  const setOpen = useContributeMainStore(s => s.setRatePopupOpen);

  const { data } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.RATE_POPUP,
    filters: { yyyy },
    enabled: open && !!yyyy,
  });

  if (!open) return null;

  const rows = (data?.o_rc1 ?? []) as ContributeRatePopupResult[];

  return (
    <div
      style={{
        position: 'fixed',
        inset: 0,
        background: 'rgba(0,0,0,0.4)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        zIndex: 1000,
      }}
      onClick={() => setOpen(false)}
    >
      <div
        style={{
          background: 'white',
          padding: 16,
          borderRadius: 4,
          minWidth: 400,
          maxHeight: '80vh',
          overflow: 'auto',
        }}
        onClick={e => e.stopPropagation()}
      >
        <h3>기여율 설정 ({yyyy})</h3>
        <table style={{ width: '100%' }}>
          <thead>
            <tr>
              <th>Division</th>
              <th>YYYYMM</th>
              <th>OS Corp</th>
              <th>Type</th>
              <th>Ratio</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr
                key={i}
                style={{ cursor: 'pointer' }}
                onClick={() => {
                  onSelect?.(r);
                  setOpen(false);
                }}
              >
                <td>{String(r.divisionId)}</td>
                <td>{String(r.yyyymm)}</td>
                <td>{String(r.osCorpCd)}</td>
                <td>{String(r.contributionType)}</td>
                <td>{String(r.contributionRatio)}</td>
              </tr>
            ))}
          </tbody>
        </table>
        <button type='button' onClick={() => setOpen(false)}>
          닫기
        </button>
      </div>
    </div>
  );
};
