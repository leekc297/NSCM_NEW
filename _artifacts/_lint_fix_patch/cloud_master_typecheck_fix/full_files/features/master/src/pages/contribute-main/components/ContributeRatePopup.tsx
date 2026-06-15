import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../contribute-main.constants';
import type { ContributeRatePopupResult } from '../types';

interface Props {
  yyyy: string;
  open: boolean;
  onClose: () => void;
  onSelect?: (row: ContributeRatePopupResult) => void;
}

// AS-IS DMF0043_ContributeRatePopup — 기여율 설정 POPUP (룰 25 §3 자동 생성)
// Main + View 양쪽에서 재사용 — store-agnostic (open/onClose 를 props 로 받음)
export const ContributeRatePopup = ({ yyyy, open, onClose, onSelect }: Props) => {
  const { data } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.RATE_POPUP,
    tabId: MENU_ID,
    filters: { yyyy },
    enabled: open && !!yyyy,
  });

  if (!open) return null;

  const rows = (data?.o_rc1 ?? []) as unknown as ContributeRatePopupResult[];

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
      onClick={onClose}
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
                  onClose();
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
        <button type='button' onClick={onClose}>
          닫기
        </button>
      </div>
    </div>
  );
};
