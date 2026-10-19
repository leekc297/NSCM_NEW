import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea } from '@shared/components';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  BATCH_DAY_OF_WEEK,
  BATCH_DEFAULT_OFF_TIME,
  BATCH_DEFAULT_WEEKS,
  BATCH_GRID_COLUMNS,
  BATCH_LINE_DELIMITER,
  BATCH_ROW_DELIMITER,
  COLUMN,
  FALLBACK_LABEL,
  LBL,
  MENU_ID,
  MSG,
  SHEETS,
} from '../../opt-capa.constants';
import type { BatchGridRow, ComboOption, LineRow } from '../../opt-capa.types';
import { buildLineOptions, str } from '../../utils/optCapa.candidates';

import styles from './NoWorkBatchModal.module.scss';

interface Props {
  open: boolean;
  /** 부모가 확정한 조회조건 — AS-IS `popup.Form_Load(division, dtPlantId, dtLineAll)`(cs:3852). */
  divisionId: string;
  plantOptions: ComboOption[];
  /** `dtLineAll` 원본 — 팝업이 Plant 선택으로 다시 좁히므로 옵션이 아니라 행을 받는다(cs:172). */
  lineAll: LineRow[];
  onClose: () => void;
  /** AS-IS `DialogResult.OK` — **저장 성공 시에만** 부모가 재조회한다(cs:3855-3858 / R07). */
  onSaved: () => void;
}

/** 이번 주 월요일 ~ 일요일 `YYYYMMDD` — AS-IS `GetDayRange()`(BatchPopup cs:177-196). */
const thisWeekRange = (): { start: string; end: string } => {
  // `dayjs().day()` 는 일요일=0 이다. AS-IS 는 `(dayOfWeek + 6) % 7` 로 월요일 기준을 만든다.
  const daysUntilMonday = (dayjs().day() + 6) % 7;
  const monday = dayjs().subtract(daysUntilMonday, 'day');
  return { start: monday.format('YYYYMMDD'), end: monday.add(6, 'day').format('YYYYMMDD') };
};

/**
 * `YYYYMMDD` 가 월요일인가 — `dayjs(text, 'YYYYMMDD')` 를 쓰지 않는다.
 * 이 환경은 dayjs `customParseFormat` 플러그인이 미등록이라 포맷 파싱이 성립하지 않는다
 * (공용 `SearchFields.tsx:1090` 주석과 같은 이유 — 거기도 수동 슬라이스로 변환한다).
 */
const isMonday = (yyyymmdd: string): boolean => {
  if (!/^\d{8}$/.test(yyyymmdd)) return false;
  const probe = new Date(
    Number(yyyymmdd.slice(0, 4)),
    Number(yyyymmdd.slice(4, 6)) - 1,
    Number(yyyymmdd.slice(6, 8))
  );
  return probe.getDay() === 1;
};

/** 컬럼 메타가 없는 클라 생성 그리드 — AS-IS `InitSpread`(BatchPopup cs:153-163)가 정본이다. */
const BATCH_COLUMNS: RawFlexGridColumnConfig[] = BATCH_GRID_COLUMNS.map(column => ({
  colNm: column.key,
  colLblNm: column.label,
  colWth: column.width,
  horzAlgnCd: column.align,
  visible: true,
  display: true,
  // `SEQ`/`DAY_OF_WEEK` 는 Edit 후에도 잠긴다(cs:212-213) → 읽기전용. 나머지는 입력 대상이다.
  inputTpCd:
    column.key === COLUMN.SEQ || column.key === COLUMN.DAY_OF_WEEK ? 'S' : 'O',
})) as RawFlexGridColumnConfig[];

/**
 * No Work 일괄저장 팝업 — AS-IS `SCP0126_NoWork_BatchPopup.cs`(design 01 R07).
 *
 * 구조 요약(AS-IS 그대로):
 *   · Division 은 부모 값 고정 + **비활성**(cs:116·120). Plant/Line 은 부모가 넘긴 후보를 쓴다.
 *   · Period 기본 = 이번 주 월~일, Weeks 기본 `1`.
 *   · Search 는 **서버를 부르지 않는다** — `Weeks × 7` 행을 클라에서 생성한다(cs:242-253).
 *   · Save 가드 3종: 시작일이 월요일이 아님 / 기간 역전 / Line 미선택(cs:289-315).
 *   · 저장 성공(`'S'`) 후 팝업을 닫고 부모가 재조회한다.
 *
 * 하단 버튼은 액션(OK) 먼저, Close 를 마지막에 둔다 — flex-end 정렬이라 DOM 순서상 마지막이
 * 최우측이다(nscm-patterns §3.7).
 */
export const NoWorkBatchModal = ({
  open,
  divisionId,
  plantOptions,
  lineAll,
  onClose,
  onSaved,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const gridRef = useRef<FlexGridType | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const savingRef = useRef(false);

  // 팝업 로컬 상태 — `open` 을 초기화 트리거로 쓰지 않는다(재오픈 시 검색조건 유지,
  //   CommonCheckList 팝업 §"재오픈 시 검색조건 유지").
  const [plantIds, setPlantIds] = useState<string[]>([]);
  const [lineIds, setLineIds] = useState<string[]>([]);
  const [period, setPeriod] = useState(thisWeekRange);
  const [weeks, setWeeks] = useState(BATCH_DEFAULT_WEEKS);
  const [rows, setRows] = useState<BatchGridRow[]>([]);
  const [saving, setSaving] = useState(false);

  /**
   * Line 후보 — AS-IS `RefreshLine`(BatchPopup cs:165-175):
   * `DIVISION_ID = '<부모 division>' AND PLANT_ID IN (선택 Plant)`.
   * Plant 미선택(ALL)이면 부모가 넘긴 Plant 후보 전체를 전개한다(`GetCheckedListValue` 규약).
   */
  const scopedLineOptions = useMemo(() => {
    const plantCodes =
      plantIds.length > 0 ? plantIds : plantOptions.map(option => option.value).filter(Boolean);
    return buildLineOptions(lineAll, divisionId, [...new Set(plantCodes)]);
  }, [lineAll, divisionId, plantIds, plantOptions]);

  /** Search — 서버 호출 없이 `Weeks × 7` 행을 만든다(cs:242-253). 0 이하면 0행이다. */
  const handleSearch = () => {
    const weekCount = Number(weeks.trim());
    if (!Number.isFinite(weekCount) || weekCount <= 0) {
      setRows([]);
      return;
    }
    const next: BatchGridRow[] = [];
    let seq = 1;
    for (let week = 0; week < weekCount; week += 1) {
      for (const dayOfWeek of BATCH_DAY_OF_WEEK) {
        next.push({
          SEQ: seq,
          DAY_OF_WEEK: dayOfWeek,
          OFF_TIME: BATCH_DEFAULT_OFF_TIME,
          DESC: '',
        });
        seq += 1;
      }
    }
    setRows(next);
  };

  const handleSave = () => {
    void (async () => {
      if (savingRef.current) return;
      const grid = gridRef.current;
      grid?.finishEditing();
      const source = (grid?.collectionView?.sourceCollection ?? rows) as unknown as BatchGridRow[];
      if (source.length === 0) return; // AS-IS `RowCount == 0` → 무동작(cs:279)

      // 가드 ① 시작일이 월요일이 아니면 차단(cs:289-297).
      if (!isMonday(period.start)) {
        void setAlert({
          type: 'alert',
          content: t(MSG.BATCH_START_NOT_MONDAY, {
            defaultValue: 'Select period again. (Monday)',
          }),
        });
        return;
      }
      // 가드 ② 기간 역전(cs:300-305). AS-IS MSG00344 → TO-BE MSG01340(문구 역조회).
      if (period.start > period.end) {
        void setAlert({
          type: 'alert',
          content: t(MSG.PERIOD_INVALID, { defaultValue: 'Please check the Period.' }),
        });
        return;
      }
      // 가드 ③ Line 미선택(cs:307-315). AS-IS MSG00061 은 TO-BE 미등록 → 필수 문구로 대체.
      if (lineIds.length === 0) {
        void setAlert({
          type: 'alert',
          content: t(MSG.BATCH_LINE_REQUIRED, { defaultValue: '{0} value is required.' }).replace(
            '{0}',
            `[${t(LBL.LINE, { defaultValue: 'Line' })}]`
          ),
        });
        return;
      }

      savingRef.current = true;
      setSaving(true);
      try {
        // `P_SCP0126_SAVE_NO_WORK_BATCH` — `SCM_ADM_PROC_M.COL_NM` 실측(camelCase, 9 IN).
        //
        // 구분자가 축마다 다르다(배포 SP 본문 실측 — {@link BATCH_ROW_DELIMITER} 주석 참조):
        //   · CLOB 4종(`seq`/`offTime`/`type`/`desc`) -> `'^'`  (`P_SPLIT`, BODY:3447-3450)
        //   · VARCHAR `lineId`                        -> `','`  (`STRING_SPLIT`, BODY:3467)
        // 하나로 합쳐 쓰면 `F_INT` 가 `INVALID_NUMBER` 를 던져 일괄저장이 전건 실패한다(RP-3).
        //
        // `type` 은 AS-IS 워킹트리가 보내지 않는 신 리비전 파라미터다(§6-L1) — 행마다 빈 값을
        //   자리수만 맞춰 보낸다(누락하면 다른 CLOB 과 행 수가 어긋난다). SP 는 이 값을
        //   `SCP_OPMZ_NO_WORK.ATTRIBUTE2`(NULLABLE) 에 넣으므로 공백이어도 NOT NULL 위반이 아니다
        //   (BODY:3516 `V_DAY_TYPE -- ATTRIBUTE2 AS TYPE`, 컬럼 실측 `NULLABLE='Y'`).
        const payload = {
          divisionId,
          lineId: lineIds.join(BATCH_LINE_DELIMITER),
          startDate: period.start,
          endDate: period.end,
          seq: source.map(row => str(row.SEQ)).join(BATCH_ROW_DELIMITER),
          offTime: source.map(row => str(row.OFF_TIME)).join(BATCH_ROW_DELIMITER),
          // 행 수만 맞춘 공백 토큰 — 감사키가 아니라 위치 정렬용이다(위 주석 참조).
          type: new Array(source.length).fill('').join(BATCH_ROW_DELIMITER),
          desc: source.map(row => str(row.DESC)).join(BATCH_ROW_DELIMITER),
          sesUserId: useSessionStore.getState().session.userId ?? '',
        };
        const res = await apiClient.post<Record<string, unknown>>(
          `/${MENU_ID}/${SHEETS.NO_WORK_BATCH}/SAVE/call-proc`,
          payload
        );
        // false-success 차단(전송 계층) — 인터셉터가 403/500 은 resolve 한다(§5-10).
        //   SP 롤백(`CODE='-1'`)은 공용 `responseInterceptor` 가 throw 하므로 아래 catch 로 온다
        //   ({@link submitOptCapaSave} 주석 = 근거 정본 1곳). 여기서 다시 판정하지 않는다.
        if (res.status >= 400 || Number(res.data?.code)) {
          void setAlert({
            type: 'alert',
            content:
              (res.data as { message?: string })?.message?.trim() ||
              t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
          });
          return;
        }
        void setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, { defaultValue: '{0} data saved.' }).replace(
            '{0}',
            String(source.length)
          ),
        });
        onSaved();
        onClose();
      } catch (error) {
        void setAlert({
          type: 'alert',
          content:
            error instanceof Error
              ? error.message
              : t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
        });
      } finally {
        savingRef.current = false;
        setSaving(false);
      }
    })();
  };

  const multiCondition = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: ComboOption[],
    onPick: (codes: string[]) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(String(picked ?? '').split(',').filter(Boolean))
            }
          />
        )}
      />
    </Grid>
  );

  return (
    <CustomDialog
      size={900}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{FALLBACK_LABEL.BATCH_TITLE}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <ProgressIndicator
            shape='circular'
            apprearance='infinite'
            open={saving}
            placement='parent'
          />
          <Grid container spacing={1}>
            {/* Division — 부모 값 고정 + 비활성(cs:116·120). 사용자가 바꿀 수 없다. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, { defaultValue: 'Division' })}
                labelAlign='right'
                render={() => <InputField fullWidth readOnly disabled value={divisionId} />}
              />
            </Grid>
            {multiCondition(LBL.PLANT, 'Plant', plantIds, plantOptions, codes => {
              setPlantIds(codes);
              setLineIds([]);
            })}
            {multiCondition(LBL.LINE, 'Line', lineIds, scopedLineOptions, setLineIds)}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={FALLBACK_LABEL.WEEKS}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    value={weeks}
                    onChange={event => setWeeks(event.target.value)}
                    onKeyDown={event => event.key === 'Enter' && handleSearch()}
                  />
                )}
              />
            </Grid>
          </Grid>
          <div className={styles.periodRow}>
            <InputField
              value={period.start}
              onChange={event => setPeriod({ ...period, start: event.target.value })}
            />
            <span className={styles.periodSep}>~</span>
            <InputField
              value={period.end}
              onChange={event => setPeriod({ ...period, end: event.target.value })}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='small'
              buttonLabel={t(LBL.SEARCH, { defaultValue: 'Search' })}
              onClick={handleSearch}
            />
          </div>
          <div className={styles.gridWrapper}>
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={rows as unknown as WijmoRowItem[]}
                staticColumns={BATCH_COLUMNS}
                sheetName={SHEETS.NO_WORK_BATCH}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              disabled={saving}
              buttonLabel={t(LBL.OK, { defaultValue: 'OK' })}
              onClick={handleSave}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CANCEL, { defaultValue: 'Cancel' })}
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
