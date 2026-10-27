import { useEffect, useMemo, useState } from 'react';

import { type DualListColumn, ColumnSelectDualList, CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import styles from './MeasureSelectModal.module.scss';

/**
 * SSP0060 Measure 선택 popup (AS-IS `TitleSetForm`(Measure) = D00-4e-006 / BtnMeasure_Click).
 *
 * 왜 화면 전용인가 — 종전에는 공용 `ColumnSettingModal`(= `ColumnLayoutModal`)에 `columnType='M'`
 *   만 바꿔 끼워 썼는데, 그 팝업의 조회 proc `DMF0002_GET_TITLESET_POPUP` 은 목록 원천이 항상
 *   `SCM_MST_SHEET_COLUMNS`(= 그리드 컬럼)다. `P_COLUMN_TYPE` 은 사용자 저장분을 거르는 데만 쓰여
 *   Measure 를 내려주지 않는다. SSP0060 의 컬럼 18개와 measure 20개는 **교집합 0**(DB 실측
 *   2026-10-12)이라, 그 배선으로는 애초에 Measure 를 고를 수 없었다. 게다가 같은 proc 의 division
 *   조건이 `P_DIVISION_ID IN (split(C.DIVISION_ID))` 라서 `C.DIVISION_ID` 가 NULL 인 SSP0060 메타는
 *   어떤 division 을 넣어도 걸러져 **목록이 통째로 0건**이었다(사용자 신고 "조회가 되지 않는다").
 *   타 도메인(`features/master`) 팝업 직접 import 는 이 화면에서 금지돼 있어(사용자 확정
 *   2026-09-25, RequestorModal 선례) 화면 전용으로 둔다. 동작 기준은
 *   `features/master/src/components/measureSelectModal` 와 같다.
 *
 * 데이터 원천 — `POST /admin/menu/SSP0060/measure { sheetNm }` →
 *   `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_MEASURE_LIST` → `SCM_MST_SHEET_MEASURE` 20행.
 *   필수: `divisionId` 를 넘기지 않는다 — 그 proc 은 `P_DIVISION_ID IS NULL` 탈출만 있고
 *   `M.DIVISION_ID IS NULL` 탈출이 없어, 값을 주면 NULL division 메타가 전부 걸러져 0행이 된다
 *   (실측: div=NULL → 20행 / div='40' → 0행). 그리드 컬럼 메타 조회도 같은 이유로 sheetNm 만 넘긴다.
 *
 * 저장 — OK 결과는 호출부가 `saveTitleSet({ columnType: 'M' })` 로 영구 저장한다.
 *   `PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN`(L2086~2116)이
 *   `SCM_MST_TITLESET_USER ... USER_INQUIRY_COLUMN_TYPE_CODE='M'` 로 측정축을 거르므로,
 *   **measure 코드가 아닌 값이 'M' 으로 저장되면 Grid1 이 통째로 0건이 된다**(2026-10-06 사고,
 *   design/17_fix_titleset_user_measure.sql). 이 모달이 measure 목록만 내보내는 것이 그 방지선이다.
 */

export interface MeasureMeta {
  /** measure 코드 (COLUMN_NAME) */
  colNm: string;
  /** measure 표시명 (COLUMN_LABEL_NAME) */
  colLblNm?: string;
  /** 소분류 라벨 (SMALL_CLASS_LABEL_NAME) */
  sClsLblNm?: string;
  /** USER_SELECTABLE_FLAG — false 면 체크/이동 불가(기본측 고정) */
  personalizable?: boolean;
  /** DISPLAY_FLAG — 최초 진입 표시 기본값(BE 가 개인화 반영해 계산) */
  display?: boolean;
  /** DEFAULT_FLAG — Default 버튼 전용 원본 기본값 */
  defaultFlag?: boolean;
}

// dual list 행 — ColumnSelectDualList 제약(Record<string, string | number>) 상 boolean 금지 → 'Y'/'N'.
interface MeasureDualRow {
  colNm: string;
  colLblNm: string;
  sClsLblNm: string;
  /** 'Y'=표시(우측) / 'N'=비표시(좌측) */
  userFlag: string;
  personalizable: string;
  display: string;
  defaultFlag: string;
  sortOrderNo: number;
  [key: string]: string | number;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  /** `/admin/menu/SSP0060/measure` 응답(SCM_MST_SHEET_MEASURE) */
  measures: MeasureMeta[];
  /** 현재 표시 중인 measure 코드 목록(null = 전체) — 재진입 시 좌/우 복원 */
  visibleMeasures: string[] | null;
  /** OK — 표시할 measure 코드를 순서대로 전달 */
  onApply: (measureCodes: string[]) => void;
}

// Default 기준값 — BE 가 defaultFlag 를 안 내려주면 display 로 degrade(우측이 통째로 비는 사고 방지).
const resolveDefaultFlag = (measure: MeasureMeta): string => {
  if (measure.defaultFlag != null) return measure.defaultFlag ? 'Y' : 'N';
  return (measure.display ?? false) ? 'Y' : 'N';
};

export const MeasureSelectModal = ({
  open,
  modalClose,
  measures,
  visibleMeasures,
  onApply,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // SP 가 VALID_YN 필터 + SORT_ORDER_NO 정렬까지 하므로 FE 재정렬 금지(순서 보존).
  const sourceRows = useMemo(
    () =>
      measures.map(measure => ({
        colNm: measure.colNm,
        colLblNm: measure.colLblNm || measure.colNm,
        sClsLblNm: measure.sClsLblNm ?? '',
        personalizable: (measure.personalizable ?? true) ? 'Y' : 'N',
        display: (measure.display ?? false) ? 'Y' : 'N',
        defaultFlag: resolveDefaultFlag(measure),
      })),
    [measures]
  );

  // useVisibleOverride=true  : open 복원 — visibleMeasures(이전 OK) 우선, 없으면 display.
  // useVisibleOverride=false : Default 버튼 — defaultFlag='Y' 만 표시측.
  const buildRows = (useVisibleOverride: boolean): MeasureDualRow[] => {
    let sequence = 0;
    return sourceRows.map(row => {
      let selected: boolean;
      if (!useVisibleOverride) {
        selected = row.defaultFlag === 'Y';
      } else if (row.personalizable !== 'Y' || visibleMeasures === null) {
        selected = row.display === 'Y';
      } else {
        selected = visibleMeasures.includes(row.colNm);
      }
      sequence += selected ? 1 : 0;
      return { ...row, userFlag: selected ? 'Y' : 'N', sortOrderNo: selected ? sequence : 0 };
    });
  };

  const [rows, setRows] = useState<MeasureDualRow[]>([]);
  const [checkedLeft, setCheckedLeft] = useState<Set<string>>(new Set());
  const [checkedRight, setCheckedRight] = useState<Set<string>>(new Set());

  useEffect(() => {
    if (!open) {
      setRows([]);
      setCheckedLeft(new Set());
      setCheckedRight(new Set());
    }
  }, [open]);

  // open + measure 도착 시점 1회만 — 사용자가 옮긴 결과를 재렌더로 덮지 않는다.
  useEffect(() => {
    if (open && rows.length === 0 && sourceRows.length > 0) setRows(buildRows(true));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, sourceRows, visibleMeasures, rows.length]);

  const baseRows = useMemo(() => rows.filter(r => r.userFlag === 'N'), [rows]);
  const userRows = useMemo(
    () => rows.filter(r => r.userFlag === 'Y').sort((a, b) => a.sortOrderNo - b.sortOrderNo),
    [rows]
  );
  const isSelectable = (key: string) => rows.find(r => r.colNm === key)?.personalizable === 'Y';

  const toggle = (setter: typeof setCheckedLeft) => (key: string) => {
    if (!isSelectable(key)) return;
    setter(previous => {
      const next = new Set(previous);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };

  const nextSequence = (list: MeasureDualRow[]): number =>
    Math.max(0, ...list.filter(r => r.userFlag === 'Y').map(r => r.sortOrderNo));

  const moveToUser = (keys: Set<string>) => {
    setRows(previous => {
      let sequence = nextSequence(previous);
      return previous.map(row => {
        if (row.userFlag !== 'N' || !keys.has(row.colNm)) return row;
        sequence += 1;
        return { ...row, userFlag: 'Y', sortOrderNo: sequence };
      });
    });
    setCheckedLeft(new Set());
  };

  const moveToBase = (keys: Set<string>) => {
    setRows(previous =>
      previous.map(row =>
        row.userFlag === 'Y' && keys.has(row.colNm)
          ? { ...row, userFlag: 'N', sortOrderNo: 0 }
          : row
      )
    );
    setCheckedRight(new Set());
  };

  const requireChecked = (checked: Set<string>, move: (keys: Set<string>) => void) => () => {
    if (checked.size === 0) {
      void setAlert({ type: 'alert', content: t('LBL00713', '_Select at least one measure.') });
      return;
    }
    move(checked);
  };

  // 더블클릭 — 체크 상태와 무관하게 그 행 1개만 이동(▶/◀ 와 동일).
  const moveOne = (move: (keys: Set<string>) => void) => (key: string) => {
    if (!isSelectable(key)) return;
    move(new Set([key]));
  };

  // 우측 D&D 순서이동 — 재정렬된 key 순서대로 sortOrderNo 재부여.
  const reorderRight = (orderedKeys: string[]) =>
    setRows(previous =>
      previous.map(row => {
        if (row.userFlag !== 'Y') return row;
        const index = orderedKeys.indexOf(row.colNm);
        return index === -1 ? row : { ...row, sortOrderNo: index + 1 };
      })
    );

  const measureColumns: DualListColumn<MeasureDualRow>[] = useMemo(
    () => [{ key: 'colLblNm', header: 'Measure Name', align: 'left' }],
    []
  );

  const handleDefault = () => {
    setRows(buildRows(false));
    setCheckedLeft(new Set());
    setCheckedRight(new Set());
  };

  const handleOk = () => {
    if (userRows.length === 0) {
      void setAlert({ type: 'alert', content: t('LBL00713', '_Select at least one measure.') });
      return;
    }
    const selected = userRows.map(r => r.colNm);
    // 무변경 OK 는 저장·재조회를 건너뛰고 닫기만 한다. 비교는 순서 포함 — 순서도 저장·반영된다.
    const initial = buildRows(true)
      .filter(r => r.userFlag === 'Y')
      .sort((a, b) => a.sortOrderNo - b.sortOrderNo)
      .map(r => r.colNm);
    if (initial.length === selected.length && initial.every((code, i) => code === selected[i])) {
      modalClose();
      return;
    }
    onApply(selected);
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1260}
      handleClose={modalClose}
      disableButtonCancel
      disableScale
      title={t('LBL00310', '_Measure')}
      customContentArea={
        <div className={styles.container}>
          <ColumnSelectDualList<MeasureDualRow>
            leftItems={baseRows}
            rightItems={userRows}
            leftColumns={measureColumns}
            rightColumns={measureColumns}
            leftTitle={t('LBL00764', 'Invisible')}
            rightTitle={t('LBL00765', 'Visible')}
            itemKey='colNm'
            checkedLeft={checkedLeft}
            checkedRight={checkedRight}
            onToggleLeft={toggle(setCheckedLeft)}
            onToggleRight={toggle(setCheckedRight)}
            onToggleAllLeft={checked =>
              setCheckedLeft(
                checked
                  ? new Set(baseRows.filter(r => r.personalizable === 'Y').map(r => r.colNm))
                  : new Set()
              )
            }
            onToggleAllRight={checked =>
              setCheckedRight(
                checked
                  ? new Set(userRows.filter(r => r.personalizable === 'Y').map(r => r.colNm))
                  : new Set()
              )
            }
            onMoveRight={requireChecked(checkedLeft, moveToUser)}
            onMoveLeft={requireChecked(checkedRight, moveToBase)}
            onReorderRight={reorderRight}
            onRowDoubleClickLeft={moveOne(moveToUser)}
            onRowDoubleClickRight={moveOne(moveToBase)}
          />

          <div className={styles.actionBar}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Default'
              onClick={handleDefault}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleOk}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Cancel'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
