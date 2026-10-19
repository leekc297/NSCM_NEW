import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { Button } from '@shared/lges';
import { Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { LABEL, MENU_ID, MSG, NEW_POPUP_CODE, SHEETS } from '../../production-plan-line.constants';

interface Props {
  open: boolean;
  modalClose: () => void;
  // newPopup 파라미터 원천 — 부모 조회조건(division/opGroup/planDate/planType/seq). design 01 R5(cs:866-871).
  params: {
    divisionId: string;
    operationGroupId: string;
    planStartYyyymmdd: string;
    planType: string;
    planSeq: string;
  };
  // 선택 확정(OK) — 선택 Item_id + originDivisionId(EE 원천 division)를 부모에 반환한다. 부모는 R5 후처리
  //   (비EE txtItemId 세팅 + MSG00265 재조회)를 수행한다. 취소(modalClose)는 반환 없이 닫는다.
  onConfirm: (itemId: string, originDivisionId: string) => void;
}

// newPopup(P_SCP0013_GET_NEW_POPUP_INFO) 반환 컬럼 — PKG body 실측(backup sp-2026-09-17, cs:674-700).
interface NewPopupRow {
  CODE?: string; // ITEM_ID
  NAME?: string; // ITEM_ID(표시)
  PLANT_SITE_ID?: string;
  SITE_DESCRIPTION?: string;
  NICK_NAME?: string;
  ITEM_TYPE?: string;
  OPERATION_ID?: string;
  DIVISION_ID?: string; // originDivisionId 원천(EE)
  OSP_YN?: string;
}

// AS-IS SCM0002_ProductionPlanInsertPopup(공통 팝업) 의 Item 후보 조회·선택 부분을 화면 전용 모달로 재현.
//   데이터 원천 = newPopup SP(P_SCP0013_GET_NEW_POPUP_INFO, code='ItemProdPlanLinePopup' + param1..5),
//   PROC_M named param 실측 확정(ora.py 2026-09-27). 선택 Item_id 를 부모에 반환(design 01 R5 트리거·반환처리).
//   주의: 신규 라인 확정 저장(newCheck+savePopup)은 lineId·라인배정 UI 가 필요한 팝업 내부 로직으로,
//   AS-IS 공통팝업(SCM0002, 저장소 밖) 원본이 있어야 재현 가능 — 04_react-gap.md 에 "팝업 전용 산출/확인필요"로 남긴다.
const NEW_POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'NAME', colLblNm: LABEL.MATERIAL, colWth: 160 },
  { colNm: 'NICK_NAME', colLblNm: LABEL.NICK_NAME, colWth: 120 },
  { colNm: 'SITE_DESCRIPTION', colLblNm: LABEL.PLANT_SITE, colWth: 140 },
  { colNm: 'OPERATION_ID', colLblNm: LABEL.OPERATION_GROUP, colWth: 100 },
  { colNm: 'ITEM_TYPE', colLblNm: 'Item Type', colWth: 90 },
].map(c => ({
  ...c,
  fixed: false,
  visible: true,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
})) as RawFlexGridColumnConfig[];

export const ProductionPlanInsertModal = ({ open, modalClose, params, onConfirm }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<NewPopupRow> | null>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const [rows, setRows] = useState<NewPopupRow[]>([]);

  // 팝업 오픈 시 Item 후보 조회 — apiClient.callProc(newPopup/SEARCH). 부모 조회조건을 param1..5 로 전달.
  //   결과판정 res.code(false-success 방지). 서버 실동작·목록 형상은 runtime-parity-gate 브라우저 축.
  useEffect(() => {
    if (!open) return;
    let cancelled = false;
    const load = async () => {
      try {
        const res = await apiClient.callProc<MENU_ID, SHEETS.NEW_POPUP>(MENU_ID, SHEETS.NEW_POPUP, 'SEARCH', {
          code: NEW_POPUP_CODE,
          param1: params.divisionId,
          param2: params.operationGroupId,
          param3: params.planStartYyyymmdd,
          param4: params.planType,
          param5: params.planSeq,
        });
        if (cancelled) return;
        if (Number(res.code)) {
          setRows([]);
          return;
        }
        setRows((res.result as { o_rc1?: NewPopupRow[] })?.o_rc1 ?? []);
      } catch {
        if (!cancelled) setRows([]);
      }
    };
    void load();
    return () => {
      cancelled = true;
    };
  }, [open, params.divisionId, params.operationGroupId, params.planStartYyyymmdd, params.planType, params.planSeq]);

  const source = useMemo(() => rows as unknown as WijmoRowItem[], [rows]);

  const handleOk = () => {
    const sel = gridRef.current?.selectedItems?.[0] as NewPopupRow | undefined;
    if (!sel) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_TARGET, '_No row selected.') });
      return;
    }
    onConfirm(String(sel.CODE ?? ''), String(sel.DIVISION_ID ?? ''));
  };

  return (
    <CustomDialog
      open={open}
      size={800}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* New — LBL01028(New, ora.py 실측). Item 후보 선택 팝업. */}
          <h2 className='headerTitle'>{t('LBL01028', { defaultValue: LABEL.NEW })}</h2>
        </div>
      }
      customContentArea={
        <div>
          <ResultArea title='' count={rows.length} gridRef={gridRef as never} gridFilterRef={gridFilterRef}>
            <DataGrid
              gridRef={gridRef as never}
              gridFilterRef={gridFilterRef}
              isReadOnly
              itemsSource={source}
              staticColumns={NEW_POPUP_COLUMNS}
            />
          </ResultArea>
          <Stack direction='row' spacing={1} justifyContent='flex-end' marginTop={1}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t('LBL00003', { defaultValue: 'OK' })}
              onClick={handleOk}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', { defaultValue: 'Close' })}
              onClick={modalClose}
            />
          </Stack>
        </div>
      }
    />
  );
};
