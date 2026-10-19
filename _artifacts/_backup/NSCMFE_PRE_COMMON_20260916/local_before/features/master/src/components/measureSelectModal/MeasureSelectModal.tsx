import { useEffect, useMemo, useState } from 'react';

import { type DualListColumn, ColumnSelectDualList, CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import styles from './MeasureSelectModal.module.scss';

// 공용 Measure 선택 popup (2026-07-30 통합 — 화면별 5벌 중복 제거):
//   AS-IS DM0002_TitleSetForm_Popup.cs 의 measure 모드 동등 동작. ColumnSettingModal(컬럼 모드) 의 형제.
//   좌측 = 비표시(Base) / 우측 = 표시(User) dual list — 체크 다중선택 + ▶/◀ 이동 +
//   우측 D&D 순서이동 + Default/Cancel/OK 버튼바.
//
//   데이터: measures = SCM_MST_SHEET_MEASURE 동적 fetch(BE GridMeasure camelCase). 화면이 주입.
//   표시 상태: visibleMeasures(이전 OK 결과) 가 있으면 그것으로 복원, 없으면 display 기본.
//   토글 가드: personalizable(=USER_SELECTABLE_FLAG) 행만 체크/이동 가능(비허용 행은 기본측 고정).
//   컬럼: 기본은 Measure Name 만. showMeasureCode 로 Measure Code 컬럼을 앞에 덧붙일 수 있다.
//   OK → 우측(표시) measure 코드 목록(전체 선택 시 null) 을 onApply 로 전달.
//   Default → visibleMeasures/display 무시, defaultFlag='Y' 만 우측(표시)·나머지는 전부 좌측(비표시).
//
//   사용 화면: DMF0002(Mkt Fcst) / DMF0021(Sales Plan) / DMF0022(Business Plan) /
//             DMF0082(Forecast Price) / Sales Monitoring

export interface MeasureMeta {
  /** measure 코드 (COLUMN_NAME) */
  colNm: string;
  /** measure 표시명 (COLUMN_LABEL_NAME) */
  colLblNm?: string;
  /** 소분류 라벨 (SMALL_CLASS_LABEL_NAME) */
  sClsLblNm?: string;
  /** 대분류 라벨 (LARGE_CLASS_LABEL_NAME) */
  lClsLblNm?: string;
  /** USER_SELECTABLE_FLAG — false 면 체크/이동 불가(기본측 고정) */
  personalizable?: boolean;
  /** DISPLAY_FLAG — 모달 최초 진입 시 표시 기본값(BE 가 개인화 반영해 계산한 값) */
  display?: boolean;
  /**
   * DEFAULT_FLAG — Default 버튼 전용 원본 기본값(BE GridMeasure 가 boolean 으로 직렬화).
   * 미제공(BE 미반영) 시 display 로 degrade.
   */
  defaultFlag?: boolean;
  /** SORT_ORDER_NO */
  sortOrd?: number;
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
  /** 'Y'=Default 버튼 시 표시측 */
  defaultFlag: string;
  /** 우측 표시 순서 */
  sortOrderNo: number;
  [key: string]: string | number;
}

interface MeasureSelectModalProps {
  open: boolean;
  modalClose: () => void;
  /** 동적 fetch measure (SCM_MST_SHEET_MEASURE) */
  measures: MeasureMeta[];
  /** 현재 표시 중인 measure 코드 목록(null = 전체). 모달 재진입 시 좌/우 상태 복원. */
  visibleMeasures: string[] | null;
  /** OK — 표시할 measure 코드 목록(전체 선택 시 null) 적용. */
  onApply: (measureCodes: string[] | null) => void;
  /** measures 0건(BE 미적재) 시 degrade 용 코드 목록. 미지정 시 빈 목록. */
  fallbackCodes?: readonly string[];
  /**
   * Measure Code(colNm) 컬럼 노출 여부. 미지정(false) 이면 표시명만 노출.
   * DMF0082 전용 — 통합테스트 1st No.40 "Measure Code, Measure Name만" 요구.
   */
  showMeasureCode?: boolean;
}

// Default 버튼 기준값 — BE 가 defaultFlag 를 아직 안 내려주면 display 로 degrade
//   (Default 가 우측을 통째로 비우는 사고 방지). BE 반영 후에는 개인화와 무관한 원본 기본값을 쓴다.
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
  fallbackCodes,
  showMeasureCode = false,
}: MeasureSelectModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // 표시 후보 measure — SP 가 이미 VALID_YN='Y' 필터 + SORT_ORDER_NO 정렬 → FE 정렬/필터 불필요(순서 보존).
  const sourceRows = useMemo(
    () =>
      measures.length > 0
        ? measures.map(measure => ({
            colNm: measure.colNm,
            colLblNm: measure.colLblNm || measure.colNm,
            sClsLblNm: measure.sClsLblNm ?? '',
            personalizable: (measure.personalizable ?? true) ? 'Y' : 'N',
            display: (measure.display ?? false) ? 'Y' : 'N',
            defaultFlag: resolveDefaultFlag(measure),
          }))
        : // BE 미적재 degrade — 코드만 존재(라벨/분류/기본값 없음). fallback 미지정 화면은 빈 목록.
          (fallbackCodes ?? []).map(code => ({
            colNm: code,
            colLblNm: code,
            sClsLblNm: '',
            personalizable: 'Y',
            display: 'N',
            defaultFlag: 'N',
          })),
    [measures, fallbackCodes]
  );

  // useVisibleOverride=true  : 모달 open 복원 — visibleMeasures(이전 OK 결과) 우선, 없으면 display.
  // useVisibleOverride=false : Default 버튼 — defaultFlag='Y' 만 표시측, 나머지는 전부 비표시측.
  //   personalizable='N' 행도 예외 없이 defaultFlag 기준으로 재배치한다.
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
      return {
        ...row,
        userFlag: selected ? 'Y' : 'N',
        sortOrderNo: selected ? sequence : 0,
      };
    });
  };

  const [rows, setRows] = useState<MeasureDualRow[]>([]);
  const [checkedLeft, setCheckedLeft] = useState<Set<string>>(new Set());
  const [checkedRight, setCheckedRight] = useState<Set<string>>(new Set());

  // popup 닫힐 때 rows/체크 reset
  useEffect(() => {
    if (!open) {
      setRows([]);
      setCheckedLeft(new Set());
      setCheckedRight(new Set());
    }
  }, [open]);

  // popup open + measure 도착 시점 1회만 setRows (사용자 이동 결과 보존)
  useEffect(() => {
    if (open && rows.length === 0 && sourceRows.length > 0) {
      setRows(buildRows(true));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, sourceRows, visibleMeasures, rows.length]);

  const baseRows = useMemo(() => rows.filter(row => row.userFlag === 'N'), [rows]);
  const userRows = useMemo(
    () => rows.filter(row => row.userFlag === 'Y').sort((a, b) => a.sortOrderNo - b.sortOrderNo),
    [rows]
  );
  const isSelectable = (key: string) => rows.find(row => row.colNm === key)?.personalizable === 'Y';

  const toggleLeft = (key: string) => {
    if (!isSelectable(key)) return;
    setCheckedLeft(previous => {
      const next = new Set(previous);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };
  const toggleRight = (key: string) => {
    if (!isSelectable(key)) return;
    setCheckedRight(previous => {
      const next = new Set(previous);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };
  const toggleAllLeft = (checked: boolean) =>
    setCheckedLeft(
      checked
        ? new Set(baseRows.filter(row => row.personalizable === 'Y').map(row => row.colNm))
        : new Set()
    );
  const toggleAllRight = (checked: boolean) =>
    setCheckedRight(
      checked
        ? new Set(userRows.filter(row => row.personalizable === 'Y').map(row => row.colNm))
        : new Set()
    );

  // 기본은 표시명만 노출 — Measure Code(colNm) 는 showMeasureCode 로 켜는 화면에서만 보인다.
  //   itemKey/체크·이동 키는 노출 여부와 무관하게 항상 colNm 을 쓴다.
  //   컬럼 폭 드래그 조절은 ColumnSelectDualList 기본 동작이라 별도 prop 이 없다.
  const measureColumns: DualListColumn<MeasureDualRow>[] = useMemo(
    () => [
      ...(showMeasureCode
        ? [{ key: 'colNm' as const, header: 'Measure Code', width: 120, align: 'left' as const }]
        : []),
      { key: 'colLblNm', header: 'Measure Name', align: 'left' },
    ],
    [showMeasureCode]
  );

  const moveToUser = () => {
    if (checkedLeft.size === 0) {
      void setAlert({ type: 'alert', content: t('LBL00713', '_Select at least one measure.') });
      return;
    }
    setRows(previous => {
      let sequence = Math.max(
        0,
        ...previous.filter(row => row.userFlag === 'Y').map(row => row.sortOrderNo)
      );
      return previous.map(row => {
        if (row.userFlag !== 'N' || !checkedLeft.has(row.colNm)) return row;
        sequence += 1;
        return { ...row, userFlag: 'Y', sortOrderNo: sequence };
      });
    });
    setCheckedLeft(new Set());
  };

  // 더블클릭 — 해당 행 1개만 우측(표시)으로 이동 (▶ 와 동일 동작, 체크상태 무관).
  //   personalizable='N' 행은 이동 불가 — 체크 토글 가드와 동일.
  const moveOneToUser = (key: string) => {
    if (!isSelectable(key)) return;
    setRows(previous => {
      let sequence = Math.max(
        0,
        ...previous.filter(row => row.userFlag === 'Y').map(row => row.sortOrderNo)
      );
      return previous.map(row => {
        if (row.userFlag !== 'N' || row.colNm !== key) return row;
        sequence += 1;
        return { ...row, userFlag: 'Y', sortOrderNo: sequence };
      });
    });
    setCheckedLeft(previous => {
      const next = new Set(previous);
      next.delete(key);
      return next;
    });
  };

  // 더블클릭 — 해당 행 1개만 좌측(비표시)으로 이동 (◀ 와 동일 동작, 체크상태 무관)
  const moveOneToBase = (key: string) => {
    if (!isSelectable(key)) return;
    setRows(previous =>
      previous.map(row =>
        row.userFlag === 'Y' && row.colNm === key ? { ...row, userFlag: 'N', sortOrderNo: 0 } : row
      )
    );
    setCheckedRight(previous => {
      const next = new Set(previous);
      next.delete(key);
      return next;
    });
  };

  const moveToBase = () => {
    if (checkedRight.size === 0) {
      void setAlert({ type: 'alert', content: t('LBL00713', '_Select at least one measure.') });
      return;
    }
    setRows(previous =>
      previous.map(row =>
        row.userFlag === 'Y' && checkedRight.has(row.colNm)
          ? { ...row, userFlag: 'N', sortOrderNo: 0 }
          : row
      )
    );
    setCheckedRight(new Set());
  };

  // 우측 grid D&D 순서이동 — 재정렬된 key 순서(위→아래)대로 sortOrderNo 재부여.
  const reorderRight = (orderedKeys: string[]) =>
    setRows(previous =>
      previous.map(row => {
        if (row.userFlag !== 'Y') return row;
        const index = orderedKeys.indexOf(row.colNm);
        return index === -1 ? row : { ...row, sortOrderNo: index + 1 };
      })
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
    const selected = userRows.map(row => row.colNm);
    // 변경 없음이면 onApply(=titleSet 저장·재조회)를 건너뛰고 닫기만 한다 (2026-09-08 요청 —
    //   무변경 OK 가 각 화면 onApply 의 saveTitleSet·재조회를 돌려 조회 결과를 갱신하던 동작 제거).
    //   기준값 = 팝업이 열린 시점 상태(buildRows(true) — setRows 초기값과 동일). 비교 축은 표시 measure
    //   코드의 순서 포함 목록(순서도 저장·그리드에 반영되는 실제 변경이라 순서 민감 비교).
    const initialSelected = buildRows(true)
      .filter(row => row.userFlag === 'Y')
      .sort((a, b) => a.sortOrderNo - b.sortOrderNo)
      .map(row => row.colNm);
    const unchanged =
      initialSelected.length === selected.length &&
      initialSelected.every((code, i) => code === selected[i]);
    if (unchanged) {
      modalClose();
      return;
    }
    onApply(selected.length === rows.length ? null : selected);
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
      title={t('LBL00712', '_Measure')}
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
            onToggleLeft={toggleLeft}
            onToggleRight={toggleRight}
            onToggleAllLeft={toggleAllLeft}
            onToggleAllRight={toggleAllRight}
            onMoveRight={moveToUser}
            onMoveLeft={moveToBase}
            onReorderRight={reorderRight}
            onRowDoubleClickLeft={moveOneToUser}
            onRowDoubleClickRight={moveOneToBase}
          />

          {/* 버튼바 — Default·Cancel=outlined, OK=contained+ConfirmIcon. 순서는 OK 다음 Cancel. */}
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
