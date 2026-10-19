import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';

import type { AllReceiverRow, SelReceiverRow } from '../sms-setup.types';
import { useSmsSetupStore } from '../useSmsSetupStore';

import styles from './SmsTabGrid.module.scss';

interface SmsReceiverPanelProps {
  allGridRef: MutableRefObject<FlexGrid<AllReceiverRow> | undefined>;
  allGridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  selGridRef: MutableRefObject<FlexGrid<SelReceiverRow> | undefined>;
  selGridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  allReceivers: AllReceiverRow[];
  selReceivers: SelReceiverRow[];
  onSearchReceiver: () => void;
  onAddReceiver: () => void;
  onAddReceiverRow: (row: AllReceiverRow) => void;
  onRemoveReceiver: () => void;
  /** Sel_Receiver 더블클릭 — 그 행 하나만 삭제 마킹(D) — ◀ 버튼과 동일하게 Save 버튼을 눌러야 반영 */
  onRemoveReceiverRow: (row: SelReceiverRow) => void;
  onAllReceiverFocus?: () => void;
  onSelReceiverFocus?: () => void;
}

/**
 * All_Receiver = SMS Group 마스터 검색 결과(SP `SCM0007_GET_RECIPIENT_SMS_GROUP_LIST`),
 * Sel_Receiver = 선택된 Category 에 할당된 SMS Group(SP `SCM0007_GET_RECIPIENT_SMS_ASSIGN`).
 * 이동 버튼은 AS-IS `btnRAdd`/`btnRDel` 에 대응하며 Mail(SYS0017) 과 동일한 ▶/◀ 아이콘 버튼으로 표시한다.
 */
export const SmsReceiverPanel = ({
  allGridRef,
  allGridFilterRef,
  selGridRef,
  selGridFilterRef,
  allReceivers,
  selReceivers,
  onSearchReceiver,
  onAddReceiver,
  onAddReceiverRow,
  onRemoveReceiver,
  onRemoveReceiverRow,
  onAllReceiverFocus,
  onSelReceiverFocus,
}: SmsReceiverPanelProps) => {
  const { t } = useTranslation();

  const receiverSearchParams = useSmsSetupStore(state => state.receiverSearchParams);
  const setReceiverSearchParams = useSmsSetupStore(state => state.setReceiverSearchParams);
  const allReceiverColumns = useSmsSetupStore(state => state.allReceiverColumns);
  const selReceiverColumns = useSmsSetupStore(state => state.selReceiverColumns);

  // SMS_PHONE 은 숫자만 허용 — AS-IS All_Receiver_EditChange(cs:1462-1479) 는 타이핑 중 매 keystroke 마다
  // 숫자가 아니면 마지막 글자를 지운다. Wijmo FlexGrid 는 keystroke 단위 이벤트를 제공하지 않아 동일한
  // 실시간 편집 중 제거는 재현할 수 없고, 커밋 시점(cellEditEnded/pastedCell)에 숫자 외 문자를 제거해
  // 최종 저장값의 무결성만 동일하게 보장한다(SmsCategoryGrid GC4 의 커밋 시점 보정 패턴과 동일 관례).
  useEffect(() => {
    const grid = allGridRef.current;
    if (!grid) return;

    const sanitizePhoneHandler = (
      sender: FlexGrid<AllReceiverRow>,
      e: { row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'SMS_PHONE') return;
      const row = sender.rows[e.row]?.dataItem as AllReceiverRow | undefined;
      if (!row?.SMS_PHONE) return;
      const digitsOnly = row.SMS_PHONE.replace(/\D/g, '');
      if (digitsOnly === row.SMS_PHONE) return;
      row.SMS_PHONE = digitsOnly;
      sender.invalidate();
    };
    grid.cellEditEnded.addHandler(sanitizePhoneHandler);
    grid.pastedCell.addHandler(sanitizePhoneHandler);

    return () => {
      grid.cellEditEnded.removeHandler(sanitizePhoneHandler);
      grid.pastedCell.removeHandler(sanitizePhoneHandler);
    };
  }, [allGridRef, allReceiverColumns]);

  // 더블클릭 = 클릭한 행 하나만 Sel_Receiver 로 이동한다(그룹 전체/다중 선택 확장 없음). dblClick 은
  // DataGrid 가 그리드 host element 전체에 배선해(헤더·빈 영역 포함) 실제 데이터 셀을 더블클릭했을
  // 때만 동작하도록 hitTest 로 걸러준다(SmsMessageGrid 의 handleDoubleClick 과 동일 패턴) — 그렇지
  // 않으면 헤더나 빈 공간을 더블클릭해도 행이 추가돼버린다.
  const handleAllReceiverDoubleClick = (mouseEvent: MouseEvent) => {
    const grid = allGridRef.current;
    if (!grid) return;
    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;

    const row = grid.rows[hitTest.row]?.dataItem as AllReceiverRow | undefined;
    if (!row) return;
    onAddReceiverRow(row);
  };

  // Sel_Receiver 더블클릭 = 클릭한 행 하나만 삭제 마킹한다(MailReceiverPanel 과 동일 패턴). 자동 저장
  // 없이 ◀ 버튼과 동일하게 마킹만 하고 Save(F7)를 눌러야 반영된다.
  const handleSelReceiverDoubleClick = (mouseEvent: MouseEvent) => {
    const grid = selGridRef.current;
    if (!grid) return;
    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;

    const row = grid.rows[hitTest.row]?.dataItem as SelReceiverRow | undefined;
    if (!row) return;
    onRemoveReceiverRow(row);
  };

  return (
    <div className={styles.receiverPanel}>
      <div className={styles.receiverSide}>
        <div className={styles.receiverSearch}>
          <FormItem
            label={t('LBL00037', '_Group Name')}
            labelAlign='right'
            render={() => (
              <InputField
                value={receiverSearchParams.group}
                onChange={event => setReceiverSearchParams({ group: event.target.value })}
              />
            )}
          />
          {/* AS-IS Designer.cs:615 lcCallPhone.Text = "CellPhoneNum" — LBL01048 로 신규 채번(2026-09-11) */}
          <FormItem
            label={t('LBL01048', '_CellPhoneNum')}
            labelAlign='right'
            render={() => (
              <InputField
                value={receiverSearchParams.phone}
                onChange={event => setReceiverSearchParams({ phone: event.target.value })}
              />
            )}
          />
          <Button size='small' onClick={onSearchReceiver}>
            {t('LBL00112', '_Search')}
          </Button>
        </div>
        <div className={styles.receiverGrid}>
          {/*
            AS-IS SaveButton 엔트리포인트는 SAVE_RECIPIENT_SMS_GROUP 도 함께 호출한다
            (screen-analysis.json entryPoints.SaveButton.sps) — 즉 All_Receiver(SMS Group 마스터)는
            Mail 의 읽기전용 수신자 마스터와 달리 이 화면에서 직접 CRUD 되는 대상이다. isReadOnly 를
            주지 않고 표준 그리드 편집(F8 Insert/F9 Delete/셀 편집)을 그대로 허용한다.
          */}
          <DataGrid<AllReceiverRow>
            gridRef={allGridRef}
            gridFilterRef={allGridFilterRef}
            itemsSource={allReceivers}
            staticColumns={allReceiverColumns}
            useSummaryTooltip={false}
            gotFocus={onAllReceiverFocus}
            dblClick={handleAllReceiverDoubleClick}
          />
        </div>
      </div>

      <div className={styles.transferButtons}>
        <Button size='small' onClick={onAddReceiver} aria-label={t('LBL00109', '_Add Row')}>
          ▶
        </Button>
        <Button size='small' onClick={onRemoveReceiver} aria-label={t('LBL00407', '_Remove')}>
          ◀
        </Button>
      </div>

      <div className={styles.receiverSide}>
        {/* 좌측 검색줄과 높이를 맞추기 위한 spacer — 좌측 그리드와 시작 y 좌표를 정렬한다
            (MailReceiverPanel.tsx 와 동일 패턴). */}
        <div className={styles.receiverSearch} aria-hidden style={{ visibility: 'hidden' }}>
          <FormItem
            label={t('LBL00037', '_Group Name')}
            labelAlign='right'
            render={() => <InputField value='' onChange={() => {}} tabIndex={-1} />}
          />
          <FormItem
            label={t('LBL01048', '_CellPhoneNum')}
            labelAlign='right'
            render={() => <InputField value='' onChange={() => {}} tabIndex={-1} />}
          />
          <Button size='small' tabIndex={-1}>
            {t('LBL00112', '_Search')}
          </Button>
        </div>
        <div className={styles.receiverGrid}>
          <DataGrid<SelReceiverRow>
            gridRef={selGridRef}
            gridFilterRef={selGridFilterRef}
            itemsSource={selReceivers}
            staticColumns={selReceiverColumns}
            useSummaryTooltip={false}
            gotFocus={onSelReceiverFocus}
            dblClick={handleSelReceiverDoubleClick}
          />
        </div>
      </div>
    </div>
  );
};
