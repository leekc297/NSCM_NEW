import { PivotPanel } from '@mescius/wijmo.react.olap';
import type { MutableRefObject } from 'react';

import { CustomDialog, CustomDropdown, type OlapPivotGridRef } from '@shared/components';
import { Button, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import type { RowTotalsMode } from '../demand-plan-waterfall.types';

// OLAP Layout 편집기 (사용자 요청 2026-08-06) — Wijmo PivotPanel(Excel 피벗식 드래그&드롭
// 필드 배치: Filters/Columns/Rows/Values) + Subtotal 표기 드롭다운(엔진 전역 showRowTotals).
// 그리드와 같은 PivotEngine 을 공유하므로 패널 편집이 즉시 그리드에 반영된다.
// ⚠ 재조회(데이터 갱신) 시 필드가 표준 배치(titleset 순서)로 재구성됨 — 배치 영구 저장
//   (viewDefinition → titleset 계열 서버 저장)은 2차 항목.

const ROW_TOTALS_OPTIONS: Array<{ value: RowTotalsMode; label: string }> = [
  { value: 'None', label: 'None (소계·총계 없음)' },
  { value: 'GrandTotals', label: 'Grand Totals (총계만)' },
  { value: 'Subtotals', label: 'Subtotals (항목별 소계+총계)' },
];

interface OlapLayoutModalProps {
  open: boolean;
  modalClose: () => void;
  olapRef: MutableRefObject<OlapPivotGridRef | null>;
  rowTotals: RowTotalsMode;
  onRowTotalsChange: (mode: RowTotalsMode) => void;
}

export const OlapLayoutModal = ({
  open,
  modalClose,
  olapRef,
  rowTotals,
  onRowTotalsChange,
}: OlapLayoutModalProps) => {
  const { t } = useTranslation();
  const engine = olapRef.current?.engine ?? null;

  return (
    <CustomDialog
      open={open}
      size={560}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('', 'Grid Layout')}</h2>
        </div>
      }
      customContentArea={
        // 다이얼로그 콘텐츠 전체 높이를 flex 로 채움 — 패널이 남은 높이를 전부 차지해
        // 내부 스크롤바가 생기지 않고, Close 는 최하단 고정 (사용자 지시 2026-08-06)
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            gap: 12,
            padding: '4px 0',
            height: '100%',
            minHeight: 0,
          }}
        >
          <Grid container columns={12} sx={{ flexShrink: 0 }}>
            <Grid size={12}>
              <FormItem
                label={t('', 'Subtotal')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={rowTotals}
                    options={ROW_TOTALS_OPTIONS}
                    onChange={(_, option) => onRowTotalsChange(option as RowTotalsMode)}
                  />
                )}
              />
            </Grid>
          </Grid>
          {engine ? (
            <div
              style={{
                border: '1px solid #e0e4e9',
                borderRadius: 4,
                flex: '1 1 auto',
                minHeight: 420,
                overflow: 'hidden',
              }}
            >
              {/* 같은 엔진 공유 — 드래그 배치 즉시 그리드 반영 */}
              <PivotPanel itemsSource={engine} style={{ height: '100%' }} />
            </div>
          ) : (
            <div style={{ padding: 24, color: '#888', flex: '1 1 auto' }}>
              {t('', 'Run a search first — the layout editor uses the current pivot data.')}
            </div>
          )}
          <div style={{ display: 'flex', justifyContent: 'flex-end', flexShrink: 0 }}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
