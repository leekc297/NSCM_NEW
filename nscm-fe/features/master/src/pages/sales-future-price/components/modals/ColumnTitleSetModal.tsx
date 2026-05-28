/**
 * DMF0020 SalesFuturePrice — Column Title Set Modal (DM0002 연동)
 *
 * AS-IS POPUP: DM0002_TitleSetForm_Popup (DMF0020 의 btnColumn L3792 에서 호출).
 * 분석서: Doc/_analysis/domain_DM/screens/DMF0020_POPUP_GridColumnSetting/
 *
 * 룰 25 §3.4 — 자체 modal 신규 생성 (사용자 결정).
 *
 * BE: SP 없음 — admin/menu 도메인의 column endpoint 재사용
 *     - GET  `/admin/menu/{menuId}/column?sheetNm=...`  (기존)
 *     - POST `/admin/menu/{menuId}/column/visibility`   (신규 — BE 측 별도 endpoint 작성 필요)
 *
 * Validation (validation.md v6.2):
 *   - G1: SaveData 시 Visible=Y 컬럼 0개 → MSG00002
 *   - G2: COLUMN_NAME 중복 (메타 상 발생 가능) → MSG00043
 */
import { useEffect, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog } from '@shared/components';
import { Button, Checkbox } from '@shared/lges';
import { Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import styles from './ColumnTitleSetModal.module.scss';

interface ColumnTitleSetModalProps {
  open: boolean;
  modalClose: () => void;
  menuId: string;
  sheetName: string;
}

interface ColumnVisibilityRow {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  VISIBLE_FLAG: 'Y' | 'N';
}

export const ColumnTitleSetModal = ({
  open,
  modalClose,
  menuId,
  sheetName,
}: ColumnTitleSetModalProps) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const [columns, setColumns] = useState<ColumnVisibilityRow[]>([]);

  // 초기 진입 시 staticColumns 메타 조회 (GET /admin/menu/{menuId}/column)
  useEffect(() => {
    if (!open) return;
    void (async () => {
      const { data } = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${menuId}/column`,
        { sheetNm: sheetName }
      );
      const list: ColumnVisibilityRow[] = (data.result ?? []).map(col => ({
        COLUMN_NAME: col.binding ?? '',
        COLUMN_LABEL_NAME: col.header ?? col.binding ?? '',
        VISIBLE_FLAG: col.visible === false ? 'N' : 'Y',
      }));
      setColumns(list);
    })();
  }, [open, menuId, sheetName]);

  const toggle = (idx: number) => {
    setColumns(prev =>
      prev.map((c, i) => (i === idx ? { ...c, VISIBLE_FLAG: c.VISIBLE_FLAG === 'Y' ? 'N' : 'Y' } : c))
    );
  };

  const selectAll = (value: 'Y' | 'N') => {
    setColumns(prev => prev.map(c => ({ ...c, VISIBLE_FLAG: value })));
  };

  /** G1: Visible=Y 컬럼 0개 → MSG00002 / G2: COLUMN_NAME 중복 → MSG00043 */
  const onSave = async () => {
    const visibleCount = columns.filter(c => c.VISIBLE_FLAG === 'Y').length;
    if (visibleCount === 0) {
      void setAlert({
        type: 'alert',
        content: t('MSG00002', '_[{0}]은 필수 입력사항입니다.', {
          0: t('LBL_DMF0020_VISIBLE_COLUMN', '_표시 컬럼 최소 1개'),
        }),
      });
      return;
    }
    const names = columns.map(c => c.COLUMN_NAME);
    const dup = names.find((name, idx) => names.indexOf(name) !== idx);
    if (dup) {
      void setAlert({
        type: 'alert',
        content: t('MSG00043', '_저장시 중복 오류가 발생하였습니다.{0}', { 0: dup }),
      });
      return;
    }
    await apiClient.post(`/admin/menu/${menuId}/column/visibility`, {
      sheetNm: sheetName,
      columns: columns.map(c => ({
        columnName: c.COLUMN_NAME,
        visibleFlag: c.VISIBLE_FLAG,
      })),
    });
    void setAlert({ type: 'alert', content: t('MSG00007', '_저장되었습니다.') });
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      onClose={modalClose}
      maxWidth='sm'
      fullWidth
      title={t('LBL_DMF0020_COLUMN_TITLE', '_컬럼 표시 설정')}
    >
      <div className={styles.container}>
        <Stack direction='row' spacing={1} className={styles.toolbar}>
          <Button appearance='outlined' priority='normal' size='small' onClick={() => selectAll('Y')}>
            {t('LBL_DMF0020_SELECT_ALL', '_All')}
          </Button>
          <Button appearance='outlined' priority='normal' size='small' onClick={() => selectAll('N')}>
            {t('LBL_DMF0020_DESELECT_ALL', '_None')}
          </Button>
        </Stack>

        <div className={styles.list}>
          {columns.length === 0 ? (
            <div className={styles.empty}>
              {t('LBL_DMF0020_NO_COLUMNS', '_컬럼이 없습니다.')}
            </div>
          ) : (
            columns.map((c, idx) => (
              <div key={c.COLUMN_NAME} className={styles.row}>
                <Checkbox
                  labelText={c.COLUMN_LABEL_NAME || c.COLUMN_NAME}
                  checked={c.VISIBLE_FLAG === 'Y'}
                  onChange={() => toggle(idx)}
                />
                <span className={styles.colName}>{c.COLUMN_NAME}</span>
              </div>
            ))
          )}
        </div>

        <Stack direction='row' spacing={1} justifyContent='flex-end' className={styles.actions}>
          <Button appearance='contained' priority='normal' onClick={onSave}>
            {t('LBL00115', '_Save')}
          </Button>
          <Button appearance='outlined' priority='normal' onClick={modalClose}>
            {t('LBL00114', '_Close')}
          </Button>
        </Stack>
      </div>
    </CustomDialog>
  );
};
