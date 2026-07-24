import { useEffect, useMemo, useState } from 'react';

import { type DualListColumn, ColumnSelectDualList, CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { MEASURE_FALLBACK } from '../../mkt-fcst.constants';
import styles from '../../MktFcst.module.scss';
import type { MeasureMeta } from '../../useMktFcstStore';

// ⭐ #3 — Measure 선택 모달 (AS-IS btnMeasure_Click → DM0002_TitleSetForm_Popup 'M' 모드, .cs L4710~4719).
//   AS-IS 는 btnColumn(L4700, 컬럼)·btnMeasure(L4712, measure) 가 동일 TitleSet popup 을 mode 만 달리 호출.
//   TO-BE 도 동일 — 공용 ColumnSettingModal 과 같은 dual list(ColumnSelectDualList) 양쪽 구성:
//     좌측 = 비표시(Base) measure / 우측 = 표시(User) measure. 체크 다중선택 + ▶/◀ 이동 +
//     우측 D&D 순서이동 + Default/Cancel/OK 버튼바 (ColumnSettingModal 1:1 형태).
//
//   데이터: staticMeasures = SCM_MST_SHEET_MEASURE(SHEET_NAME='Mkt Fcst', VALID_YN='Y') 동적 fetch(BE
//   GridMeasure camelCase). 0개(BE 미적재)면 MEASURE_FALLBACK(사내 실측 23 코드, 라벨 없음)로 degrade.
//
//   표시 상태: visibleMeasures(이전 OK 결과) 가 있으면 그것으로 복원, 없으면 display(=DEFAULT_FLAG) 기본.
//   토글 가드: personalizable(=USER_SELECTABLE_FLAG='Y') 행만 체크/이동 가능(비허용 행은 기본측 고정).
//   OK → 우측(표시) measure 코드 목록(전체 선택 시 null) 을 applyVisibleMeasures 로 적용 → measure 행 필터.
//   Default → visibleMeasures 무시, display(DEFAULT_FLAG) 기본값으로 좌/우 재배치 (BE 기본 reset 동등).

// dual list 행 — ColumnSelectDualList 제약(Record<string, string | number>) 상 boolean 금지 → 'Y'/'N'.
interface MeasureDualRow {
  /** measure 코드 (COLUMN_NAME) — 행 고유키 */
  colNm: string;
  /** measure 표시명 (COLUMN_LABEL_NAME) */
  colLblNm: string;
  /** 소분류 라벨 (SMALL_CLASS_LABEL_NAME — MKT/RTF/CUST …) */
  sClsLblNm: string;
  /** 'Y'=표시(우측) / 'N'=비표시(좌측) */
  userFlag: string;
  /** USER_SELECTABLE_FLAG — 'N' 이면 체크/이동 불가(기본측 고정) */
  personalizable: string;
  /** DEFAULT_FLAG — Default reset 시 표시 기본값 */
  display: string;
  /** 우측 표시 순서 */
  sortOrderNo: number;
  [key: string]: string | number;
}

interface MeasureSelectModalProps {
  open: boolean;
  modalClose: () => void;
  /** 동적 fetch measure (SCM_MST_SHEET_MEASURE) — 0개면 MEASURE_FALLBACK 사용. */
  measures: MeasureMeta[];
  /** 현재 표시 중인 measure 코드 목록(null = 전체). 모달 재진입 시 좌/우 상태 복원. */
  visibleMeasures: string[] | null;
  /** OK — 표시할 measure 코드 목록(전체 선택 시 null) 적용. */
  onApply: (measureCodes: string[] | null) => void;
}

export const MeasureSelectModal = ({
  open,
  modalClose,
  measures,
  visibleMeasures,
  onApply,
}: MeasureSelectModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // 표시 후보 measure — staticMeasures(BE camelCase) → 0개 시 fallback(코드만, 라벨=코드).
  //   SP 가 이미 VALID_YN='Y' 필터 + SORT_ORDER_NO 정렬 → FE 정렬/필터 불필요(순서 보존).
  const sourceRows = useMemo(() => {
    // ⭐ 2026-07-23 (DMF0003 ColumnSetting 사고 동일 계열 방어) — colNm dedup.
    //   BE 메타에 중복행이 유입되면 dual list 키(colNm) 충돌 → 중복 표시·이동/체크 오동작.
    //   첫 행 유지. (titleset 'M' 저장은 메인 SP 가 SHEET_MEASURE VALID_YN='Y' 조인으로 면역)
    const seen = new Set<string>();
    const dedup = measures.filter(m => {
      if (!m.colNm || seen.has(m.colNm)) return false;
      seen.add(m.colNm);
      return true;
    });
    return dedup.length > 0
      ? dedup.map(m => ({
          colNm: m.colNm,
          colLblNm: m.colLblNm || m.colNm,
          sClsLblNm: m.sClsLblNm ?? '',
          personalizable: (m.personalizable ?? true) ? 'Y' : 'N',
          display: (m.display ?? false) ? 'Y' : 'N',
        }))
      : // BE 미적재 degrade — 코드만 존재(라벨/분류/기본값 없음). 사용자 인지용.
        MEASURE_FALLBACK.map(code => ({
          colNm: code,
          colLblNm: code,
          sClsLblNm: '',
          personalizable: 'Y',
          display: 'N',
        }));
  }, [measures]);

  // visibleMeasures 미설정(null) 시 display(DEFAULT_FLAG) 기본, 설정 시 그 목록으로 표시측 복원.
  //   personalizable='N' 행은 항상 기본값 고정(사용자 토글 가드).
  const buildRows = (useVisibleOverride: boolean): MeasureDualRow[] => {
    let seq = 0;
    return sourceRows.map(r => {
      const byDefault = r.display === 'Y';
      const flag =
        r.personalizable !== 'Y' || !useVisibleOverride || visibleMeasures === null
          ? byDefault
          : visibleMeasures.includes(r.colNm);
      seq += flag ? 1 : 0;
      return { ...r, userFlag: flag ? 'Y' : 'N', sortOrderNo: flag ? seq : 0 };
    });
  };

  const [rows, setRows] = useState<MeasureDualRow[]>([]);

  // 체크박스 다중선택 — 체크된 행을 ▶/◀ 로 이동 (ColumnSettingModal 동일).
  const [checkedLeft, setCheckedLeft] = useState<Set<string>>(new Set());
  const [checkedRight, setCheckedRight] = useState<Set<string>>(new Set());

  // popup 닫힐 때 rows/체크 reset — 재진입 시 visibleMeasures 로 재구성.
  useEffect(() => {
    if (!open) {
      setRows([]);
      setCheckedLeft(new Set());
      setCheckedRight(new Set());
    }
  }, [open]);

  // popup open 시점 1회만 setRows (사용자 이동 결과 보존 — 무조건 setRows 시 원복 사고).
  useEffect(() => {
    if (open && rows.length === 0 && sourceRows.length > 0) {
      setRows(buildRows(true));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, sourceRows, visibleMeasures, rows.length]);

  const baseRows = useMemo(() => rows.filter(r => r.userFlag === 'N'), [rows]);
  const userRows = useMemo(
    () => rows.filter(r => r.userFlag === 'Y').sort((a, b) => a.sortOrderNo - b.sortOrderNo),
    [rows]
  );

  // 토글 가드 — personalizable='N' 행은 체크 자체 불가(기본측 고정).
  const isSelectable = (key: string) => rows.find(r => r.colNm === key)?.personalizable === 'Y';

  const toggleLeft = (key: string) => {
    if (!isSelectable(key)) return;
    setCheckedLeft(prev => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };
  const toggleRight = (key: string) => {
    if (!isSelectable(key)) return;
    setCheckedRight(prev => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };
  const toggleAllLeft = (checked: boolean) =>
    setCheckedLeft(
      checked
        ? new Set(baseRows.filter(r => r.personalizable === 'Y').map(r => r.colNm))
        : new Set()
    );
  const toggleAllRight = (checked: boolean) =>
    setCheckedRight(
      checked
        ? new Set(userRows.filter(r => r.personalizable === 'Y').map(r => r.colNm))
        : new Set()
    );

  // 좌/우 컬럼 — 기존 3컬럼 정보(Class/Measure Code/Measure Name) 유지 (체크박스/No 는 dual list 자동).
  const MEASURE_COLUMNS: DualListColumn<MeasureDualRow>[] = [
    { key: 'sClsLblNm', header: 'Class', width: 70, align: 'left' },
    { key: 'colNm', header: 'Measure Code', width: 120, align: 'left' },
    { key: 'colLblNm', header: 'Measure Name', align: 'left' },
  ];

  const moveToUser = () => {
    if (checkedLeft.size === 0) {
      void setAlert({ type: 'alert', content: '좌측 measure 선택' });
      return;
    }
    setRows(prev => {
      let maxSeq = Math.max(0, ...prev.filter(r => r.userFlag === 'Y').map(r => r.sortOrderNo));
      return prev.map(r => {
        if (r.userFlag === 'N' && checkedLeft.has(r.colNm)) {
          maxSeq += 1;
          return { ...r, userFlag: 'Y', sortOrderNo: maxSeq };
        }
        return r;
      });
    });
    setCheckedLeft(new Set());
  };

  const moveToBase = () => {
    if (checkedRight.size === 0) {
      void setAlert({ type: 'alert', content: '우측 measure 선택' });
      return;
    }
    setRows(prev =>
      prev.map(r =>
        r.userFlag === 'Y' && checkedRight.has(r.colNm)
          ? { ...r, userFlag: 'N', sortOrderNo: 0 }
          : r
      )
    );
    setCheckedRight(new Set());
  };

  // 우측 grid D&D 순서이동 — 재정렬된 key 순서(위→아래)대로 sortOrderNo 재부여.
  const reorderRight = (orderedKeys: string[]) =>
    setRows(prev =>
      prev.map(r => {
        if (r.userFlag !== 'Y') return r;
        const idx = orderedKeys.indexOf(r.colNm);
        return idx === -1 ? r : { ...r, sortOrderNo: idx + 1 };
      })
    );

  // Default — visibleMeasures 무시, display(DEFAULT_FLAG) 기본값으로 좌/우 재배치.
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
    // 전체 선택이면 null(전체 표시) 로 정규화.
    const selected = userRows.map(r => r.colNm);
    onApply(selected.length === rows.length ? null : selected);
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      // ⭐ 가로 150% 확대 (840→1260) — Measure Name(flex 컬럼) 가독성 (사용자 요구 2026-07-11).
      size={1260}
      handleClose={modalClose}
      disableButtonCancel
      title={t('LBL00712', '_Measure')}
      customContentArea={
        <div className={styles.measureDualContainer}>
          <ColumnSelectDualList<MeasureDualRow>
            leftItems={baseRows}
            rightItems={userRows}
            leftColumns={MEASURE_COLUMNS}
            rightColumns={MEASURE_COLUMNS}
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
          />

          {/* 버튼바 — ColumnSettingModal 표준 버튼 동일. Default·Cancel=outlined, OK=contained+ConfirmIcon. */}
          <div className={styles.measureActionBar}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Default'
              onClick={handleDefault}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Cancel'
              onClick={modalClose}
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
          </div>
        </div>
      }
    />
  );
};
