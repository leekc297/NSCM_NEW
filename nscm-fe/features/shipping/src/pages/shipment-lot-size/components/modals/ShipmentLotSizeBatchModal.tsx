import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  COMBO,
  DIVISION_EE_EXCLUDE,
  LBL,
  LOOKUP_TYPE,
  MENU_ID,
  MSG,
  SHEETS,
} from '../../shipment-lot-size.constants';
import type { BatchMode, LotSizePopupRow } from '../../shipment-lot-size.types';

import styles from './ShipmentLotSizeBatchModal.module.scss';

// AS-IS SCM0002_ShipmentLotSizePopup ("ShipmentLotSize Input/Delete Popup", btnInput "I" 일괄입력 /
//   btnDelete "D" 일괄삭제, design 01 R5/R6). AS-IS 팝업 구성(사용자 제공 스샷 2026-09-30):
//     검색영역 = Div*(단일 필수) / From Site(단일+ALL) / To Site(단일+ALL) / Model(텍스트) /
//                Operation Group(단일+ALL) + Find/OK/Cancel
//     그리드   = Check(선택) / Div / Operation Group / From Site / To Site / Model / Nick Name
//   후보 조회 SP = PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP (SHT_NM='popup',
//     IN divisionId/operationGroup/fromSite/toSite/itemId/actionFlag). Find 로 검색조건을 실어 재조회하고,
//     체크한 후보를 onConfirm 으로 반환하면 부모가 I=GET_INPUT 재조회+편집모드 / D=SAVE(active_flag='D') 처리.

interface Props {
  open: boolean;
  mode: BatchMode; // 'I' 일괄입력 / 'D' 일괄삭제
  divisionId: string; // 부모 확정 division (팝업 Div 초기값)
  onClose: () => void;
  onConfirm: (rows: LotSizePopupRow[]) => void;
}

interface Option {
  label: string;
  value: string;
}

const ALL = 'ALL';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// ALL/빈값은 SP 에 '' 로 넘긴다(후보 필터 미적용). From/To Site 는 다중선택이라 값이 'A,B' CSV 일 수 있고,
//   그대로 넘기면 POPUP SP 의 IN-list 필터에 실린다(본화면 store orEmpty 와 동일 규약).
const listOrEmpty = (v: string): string => (v && v !== ALL ? v : '');

export const ShipmentLotSizeBatchModal = ({ open, mode, divisionId, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const gridRef = useRef<FlexGrid<LotSizePopupRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  // 팝업 자체 검색조건(AS-IS 팝업 검색영역). Div 는 부모 division 으로 시작, 나머지는 ALL/빈값.
  const [div, setDiv] = useState('');
  const [fromSite, setFromSite] = useState(ALL);
  const [toSite, setToSite] = useState(ALL);
  const [opGroup, setOpGroup] = useState(ALL);
  const [model, setModel] = useState('');

  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.POPUP> | undefined>();

  // 검색영역 콤보 — Div(EE 제외 클라필터) / Operation Group / From·To Site(팝업 Div 로 cascade).
  const [divisionRows, opGroupRows, fromSiteRows, toSiteRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      { comboId: COMBO.LOOKUP_COMMON, lookupType: LOOKUP_TYPE.OPERATION_GROUP },
      { comboId: COMBO.FROM_SITE, mnuId: MENU_ID, divisionId: div },
      { comboId: COMBO.TO_SITE, divisionId: div },
    ],
    enabled: open,
  });

  const divisionOptions: Option[] = (divisionRows ?? [])
    .filter(r => str(r.ATTRIBUTE3) !== DIVISION_EE_EXCLUDE)
    .map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));
  const opGroupOptions = toOptions(opGroupRows);
  const fromSiteOptions = toOptions(fromSiteRows);
  const toSiteOptions = toOptions(toSiteRows);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP,
    tabId: MENU_ID,
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  // useMemo — 매 렌더 새 배열이면 그리드 re-bind 로 체크박스 선택(row.isSelected)이 풀린다(DivisionModal 규약).
  const columns = useMemo(
    () =>
      [
        buildNoColumn(t('LBL00674', 'No')),
        { colNm: 'DIVISION_ID', colLblNm: t(LBL.DIVISION, 'Division'), display: true, visible: true, colWth: 90, horzAlgnCd: 'C' },
        { colNm: 'OPERATION_GROUP_ID', colLblNm: t(LBL.OPERATION_GROUP, 'Operation Group'), display: true, visible: true, colWth: 120 },
        { colNm: 'FROM_SITE_DESCRIPTION', colLblNm: t(LBL.FROM_SITE, 'From Site'), display: true, visible: true, colWth: 150 },
        { colNm: 'TO_SITE_DESCRIPTION', colLblNm: t(LBL.TO_SITE, 'To Site'), display: true, visible: true, colWth: 150 },
        { colNm: 'ITEM_ID', colLblNm: t(LBL.MODEL, 'Model'), display: true, visible: true, colWth: 130 },
        { colNm: 'NICK_NAME', colLblNm: t('LBL00767', 'Nick Name'), display: true, visible: true, colWth: 130 },
      ] as RawFlexGridColumnConfig[],
    [t]
  );

  const rows = useMemo(() => withRowNo(data?.o_rc1 ?? []), [data]);

  // 팝업 open 시 검색조건 초기화(Div=부모 division). close 시 초기화.
  //
  // 진입 자동조회는 'D'(일괄삭제)만 한다 — 'D' 후보는 이미 등록된 Lot Size 행이라 division 하나로도
  //   건수가 유계다. 'I'(일괄입력)는 미등록 '조합'을 만들어내는 쿼리라 무조건 자동조회하면 안 된다:
  //   POPUP SP 'I' 분기는 SCM_MST_SITE_ITEM_PRIORITY × SCM_MST_FINAL_ITEM_V × SCP_MST_BOD 3중 조인
  //   DISTINCT + NOT EXISTS 이고 행마다 스칼라 함수 3개(FN_GET_LOOKUP_CODE_DESC·FN_GET_SCM_SITE_DESCRIPTION
  //   ×2)를 호출한다. 필터 없이 division 만 주면 실측 52만행(div 81, ora.py 2026-10-07)이 나와 조회·전송·
  //   그리드 바인딩이 끝나지 않고 로딩바가 계속 돌았다(사용자 신고 2026-10-07).
  //   AS-IS 도 Form_Load 의 FindData() 가 주석(cs:146)이라 진입 시 그리드가 비어 있고, 'I' 는 From Site
  //   선택을 강제한다(cs:261 가드 = 아래 handleFind) — 자동조회 금지가 AS-IS 파리티이기도 하다.
  //   금지: 'I' 를 여기서 자동조회로 되돌리기. 후보는 From Site 를 고르고 Search 를 눌러 좁혀 받는다.
  useEffect(() => {
    if (open) {
      setDiv(divisionId);
      setFromSite(ALL);
      setToSite(ALL);
      setOpGroup(ALL);
      setModel('');
      setFilters(
        divisionId && mode === 'D'
          ? { divisionId, operationGroup: '', fromSite: '', toSite: '', itemId: '', actionFlag: mode }
          : undefined
      );
    } else {
      setFilters(undefined);
    }
  }, [open, divisionId, mode]);

  // Find — 현재 검색조건으로 후보 재조회(AS-IS Find 버튼).
  const handleFind = () => {
    if (!div) return;
    // From Site 필수 — AS-IS FindData(cs:261) `action_flag=="I" && "ALL"==clbFromSite.ControlValues` 가드.
    //   'I'(일괄입력) 한정이고 'D'(일괄삭제)는 ALL 허용이다(AS-IS 동일). 다중선택이라도 CustomDropdown 은
    //   전체선택을 'ALL' 단독 센티널로 내보내므로(SELECT ALL 규약) 'ALL' 비교로 충분하다. 빈값도 SP 에
    //   ''(무필터)로 나가 ALL 과 결과가 같아 함께 막는다 — AS-IS 는 전체 체크해제 시 ""로 빠져나가는 구멍이 있었다.
    if (mode === 'I' && (!fromSite.trim() || fromSite.trim() === ALL)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_VALUE, '_{0} value is required.').replace(
          '{0}',
          t(LBL.FROM_SITE, 'From Site')
        ),
      });
      return;
    }
    setFilters({
      divisionId: div,
      operationGroup: listOrEmpty(opGroup),
      fromSite: listOrEmpty(fromSite),
      toSite: listOrEmpty(toSite),
      itemId: model.trim(),
      actionFlag: mode,
    });
  };

  const collectCheckedRows = (grid: FlexGrid<LotSizePopupRow> | null | undefined): LotSizePopupRow[] => {
    if (!grid) return [];
    const picked: LotSizePopupRow[] = [];
    for (const row of grid.rows) {
      if (row?.isSelected) picked.push(row.dataItem as LotSizePopupRow);
    }
    return picked;
  };

  // OK — AS-IS SaveData(팝업 cs:308~369) 순서 그대로: 그리드 0행 차단 → 체크 0건 차단 → 'D'면 삭제확인 →
  //   체크행 반환 + 닫기. 종전에는 세 단계가 모두 없어 체크 0건이면 조용히 닫히고 삭제는 확인 없이 실행됐다.
  const handleConfirm = () => {
    if (rows.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.POPUP_SEARCH_FIRST, '_Check before adding.'),
      });
      return;
    }
    const picked = collectCheckedRows(gridRef.current);
    if (picked.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.POPUP_NO_ROW, '_No row selected.') });
      return;
    }
    if (mode === 'D') {
      // AS-IS `if (action_flag=="D") { if (GMessageBox("MSG00016") != Yes) return; }` (cs:362~364).
      void (async () => {
        const confirmed = await setAlert({
          type: 'confirm',
          content: t(MSG.POPUP_DELETE_CONFIRM, '_Do you want to delete it?'),
        });
        if (confirmed) onConfirm(picked);
      })();
      return;
    }
    onConfirm(picked);
  };

  const title =
    mode === 'I'
      ? t(LBL.INPUT, '_Input')
      : t(LBL.DELETE, '_Delete');

  const headerTitle = (
    <div className={styles.headerContainer}>
      <div className={styles.headerDot} />
      <h2 className={styles.headerTitle}>{`${t('MNU00091', '_Shipment Lot Size')} - ${title}`}</h2>
    </div>
  );

  return (
    <CustomDialog
      open={open}
      size={900}
      type='modal'
      position='basic'
      handleClose={onClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={headerTitle}
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          {/* 검색영역 — 공용 SearchArea(사용자 지시 2026-10-07). 종전 자체 Grid + outlined 'Find' 버튼
              (미등록 라벨키 '_scp0028.find')을 공용 컴포넌트로 교체 — Search 버튼(LBL00112, contained + 돋보기)과
              조회조건 칸이 다른 팝업들과 같아지고 팝업 스코프 F5 조회도 SearchArea 가 제공한다(SRCH-01).
              칸은 size=4(한 줄 3칸) — 이 팝업 폭 900px = SEARCH_POPUP_WIDTH 로 같은 폭인 공용 팝업
              (ItemByDivisionModal·MaterialByDivisionModal)과 콤보 폭을 맞춘 값이다(사용자 지시 2026-10-07).
              size=3(한 줄 4칸, 페이지 기준 SRCH-01)으로 되돌리면 팝업에서만 콤보가 좁아져 다른 팝업과 어긋난다.
              버튼도 조회조건 칸으로 되돌리지 마라. */}
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH, '_Search')}
            onSearch={handleFind}
            conditions={
              <>
                {/* Div* — 단일 필수. AS-IS 팝업 시각 순서 그대로 Div / From Site / To Site / Model / Operation Group */}
                <Grid size={4}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t(LBL.DIVISION, { defaultValue: 'Division' })}
                    labelAlign='right'
                    required
                    render={() => (
                      <CustomDropdown
                        value={div}
                        options={divisionOptions}
                        onChange={(_, picked) => {
                          // Division 변경 = 나머지 조회조건 전부 초기값 reset(사용자 지시 2026-10-02, 본화면
                          //   조회영역과 동형). From/To Site 콤보는 div 키로 자동 재조회.
                          const nextDiv = String(picked ?? '');
                          if (nextDiv !== div) {
                            setFromSite(ALL);
                            setToSite(ALL);
                            setOpGroup(ALL);
                            setModel('');
                          }
                          setDiv(nextDiv);
                        }}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t(LBL.FROM_SITE, { defaultValue: 'From Site' })}
                    labelAlign='right'
                    // 'I'(일괄입력)는 From Site 가 필수다(handleFind 가드) — 본화면 Division 과 같은 * 표시로 알린다.
                    required={mode === 'I'}
                    render={() => (
                      // 다중선택 — AS-IS clbFromSite 는 CheckedListBox(체크 다중)다(팝업 cs:184 setListBox).
                      <CustomDropdown
                        multiple
                        allOption
                        value={fromSite}
                        options={fromSiteOptions}
                        onChange={(_, picked) => setFromSite(String(picked ?? ALL))}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t(LBL.TO_SITE, { defaultValue: 'To Site' })}
                    labelAlign='right'
                    render={() => (
                      // 다중선택 — AS-IS clbToSite 도 CheckedListBox 다(팝업 cs:188 setListBox).
                      <CustomDropdown
                        multiple
                        allOption
                        value={toSite}
                        options={toSiteOptions}
                        onChange={(_, picked) => setToSite(String(picked ?? ALL))}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    className={commonStyles.formItem}
                    // 라벨 LBL00618 'Model/Nickname'(사용자 지시 2026-10-07) — POPUP SP 가 이 한 칸으로
                    //   ITEM_ID·NICK_NAME 을 함께 부분검색한다. 그리드 ITEM_ID 컬럼 헤더는 'Model' 유지.
                    label={t(LBL.MODEL_NICKNAME, { defaultValue: 'Model/Nickname' })}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={model}
                        onChange={e => setModel(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleFind()}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t(LBL.OPERATION_GROUP, { defaultValue: 'Operation Group' })}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        allOption
                        value={opGroup}
                        options={opGroupOptions}
                        onChange={(_, picked) => setOpGroup(String(picked ?? ALL))}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />

          <div className={styles.gridWrapper}>
            <ProgressIndicator shape='circular' apprearance='infinite' open={loading} placement='parent' />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<LotSizePopupRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={rows}
                staticColumns={columns}
                useCheckbox
                isReadOnly
              />
            </ResultArea>
          </div>

          {/* 우하단 버튼 — 액션(OK) 먼저, Close 마지막(CommonCheckList §팝업, nscm-patterns §3.7) */}
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel={t(LBL.OK, '_OK')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleConfirm}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
