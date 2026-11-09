import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE, CRUD_MSG } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { CustomDialog, DataGrid } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { Button } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  COMBO,
  LBL,
  MENU_ID,
  MSG,
  POPUP,
  SHEETS,
  STANDARD_MANUAL_URL,
} from '../../shipment-request-electrode.constants';
import type {
  ShipmentPsiRow,
  ShipmentRequestInsertRow,
} from '../../shipment-request-electrode.types';
import { postShipmentRequestSave, str, ymd8 } from '../../utils/shipment-request-electrode.save';

import styles from './ShipmentRequestInsertModal.module.scss';

// ETA 요청 팝업(SSP0022_ShipmentRequestPopup "Shipment Request Insert") — 메인 pivot 의 Shipment Request ETA
//   (R_SHIP_REQ_ETA) 측정라벨(MEASURE_NAME) 셀 더블클릭으로 열린다(AS-IS SpdMain_CellDoubleClick, bRealFlag 가드).
//   AS-IS CreateSpread(cs:256-287) + InsertRow(cs:319-332)의 1행 편집 그리드를 공용 CustomDialog + DataGrid 로 재현.
//   - 행 상태 = 'I'(AS-IS siMain.Insert()). 저장 SP 파라미터는 p_active_flag='M' 고정(cs:563)으로 별개다.
//   - 편집 가능(AS-IS InsertRow lock 제외분, cs:327-331): From Site·To Site·Incoterms·Trans Mode(셀 콤보) +
//     Shipment Date·Qty. Div·Model·Material 은 더블클릭한 메인 행값으로 고정(lock) — 사용자 결정 2026-11-04(코드 기준).
//   - 셀 콤보 = **공용 DataGrid 정식 경로(cellCboDataTp + comboParams)에 위임**한다. 수동으로 col.dataMap 을
//     붙이면 wrapper 재적용과 부착 주체가 둘이 되어 "값이 미리 채워진 셀에서 드롭다운이 안 열리고 이후까지
//     전파되는" 경합이 난다(선례 ExchangeRateModal 주석 "수동 부착 3회 실패" + 사용자 신고 2026-11-04).
//     wrapper 가 cellCboDataTp(=SQL_ID)로 조회→DataMap 생성→부착을 단독으로 한다. From/To Site 의 division/
//     company 필터는 comboParams(@segment5=divisionId, @segment4=companyId)로 넘긴다(DB 실측 계약, USE_YN='Y').
//     Incoterms/TransMode 는 무파라미터라 segment* 를 무시한다(BE makeComboQuery 가 미사용 @키를 버림).
//   - 캐스케이드(AS-IS SpdMain_ComboSelChange cs:980-998): From/To Site 변경 시 Incoterms/TransMode/BOD/ConfirmDay
//     클리어(값은 행 객체에 직접 써 setCellData coerce 경로를 피한다 — ExchangeRateModal 주석 동일).
//   - 저장: P_SSP0022_SAVE_SHIPMENT_REQUEST(p_active_flag='M', 단일행, 2026-10-27 DB 실측 배포·VALID) —
//     요청상세 저장과 동일 SP/엔드포인트(postShipmentRequestSave). 결과 'S' 성공 → 메인 재조회(onSaved).

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 더블클릭한 메인 pivot 행(R_SHIP_REQ_ETA) — null 이면 렌더만 하고 행을 만들지 않는다. */
  row: ShipmentPsiRow | null;
  /** 조회조건 companyId(저장 p_company_id + From/To Site 콤보 @segment4). */
  companyId: string;
  /** 조회조건 planDate(AS-IS FindData P_PLAN_START_YYYYMMDD). */
  planDate: string;
  /** 저장 성공 콜백 — 호출부가 메인 재조회·모달 닫기를 수행한다. */
  onSaved: () => void;
}

// 날짜 토큰 → yyyymmdd 8자리. FPDate 가 Date 객체로 바인딩될 수 있어 Date 도 흡수한다(그 외는 save.ymd8 위임).
const toYmd8 = (v: unknown): string =>
  v instanceof Date ? dayjs(v).format('YYYYMMDD') : ymd8(v);

const isValidYmd8 = (s: string): boolean =>
  /^\d{8}$/.test(s) && dayjs(`${s.slice(0, 4)}-${s.slice(4, 6)}-${s.slice(6, 8)}`).isValid();

// 컬럼 1건 정의. combo(=SQL_ID) 지정 시 cellCtrlObjTpCd=COMBO + cellCboDataTp(wrapper 자동 조회·부착).
//   edit 지정 시 날짜/숫자 편집. 둘 다 미지정 = inputTpCd='S'(SEARCH_ONLY, locked 텍스트).
const col = (
  colNm: string,
  colLblNm: string,
  width: number,
  opts?: { edit?: 'date' | 'num'; combo?: string; align?: 'L' | 'C' | 'R' }
): RawFlexGridColumnConfig => ({
  colNm,
  colLblNm,
  horzAlgnCd: opts?.align ?? (opts?.edit === 'num' ? 'R' : 'C'),
  colWth: width,
  visible: true,
  display: true,
  inputTpCd: opts?.edit || opts?.combo ? CELL_INPUT_EDIT_TYPE.OPTIONAL : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  // 날짜 편집은 FPDate(달력 피커 — 사용자 요구 2026-11-04). wijmo InputDate 는 빈 셀 편집 시 "오늘"을 기본
  //   커밋하므로, 출하일 하한(D+1) 검증은 cellEditEnded 인라인이 아니라 저장 시(handleSave)에만 한다 — 인라인이면
  //   피커를 열기만 해도 오늘이 커밋돼 MSG00194 가 조기 발화한다(사용자 신고).
  cellCtrlObjTpCd:
    opts?.edit === 'date'
      ? CELL_CONTROL_TYPE.DATE
      : opts?.edit === 'num'
        ? CELL_CONTROL_TYPE.NUMBER
        : opts?.combo
          ? CELL_CONTROL_TYPE.COMBO
          : undefined,
  ...(opts?.combo ? { cellCboDataTp: opts.combo } : {}),
  ...(opts?.edit === 'num' ? { scale: 1 } : {}), // AS-IS SetReNumerCellType(SHIPMENT_QTY, 1)
});

export const ShipmentRequestInsertModal = ({
  open,
  modalClose,
  row,
  companyId,
  planDate,
  onSaved,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const session = useSessionStore(state => state.session);

  const gridRef = useRef<FlexGridType<ShipmentRequestInsertRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ShipmentRequestInsertRow>>();

  const [rows, setRows] = useState<ShipmentRequestInsertRow[]>([]);
  const [saving, setSaving] = useState(false);

  // 더블클릭한 레인의 Division(locked) — From/To Site 콤보 @segment5. company 는 prop(@segment4).
  const divisionId = open && row ? str(row.DIVISION_ID) : '';
  // 셀 콤보 파라미터 — wrapper 가 모든 cellCboDataTp 콤보에 함께 싣는다. From/To Site 는 @segment5/@segment4 로
  //   필터, Incoterms/TransMode 는 미사용(BE 가 버림). DB 실측 매핑(ELECTRODE_SHIP_FROM_TO SEGMENT5=div/SEGMENT4=company).
  const comboParams = useMemo<Record<string, string>>(
    () => ({ segment5: divisionId, segment4: companyId }),
    [divisionId, companyId]
  );

  // 출하일 하한 오프셋(D+n) — AS-IS dtBaseDay=LookupCommon('CHANGE_REQ_DAY'), dDay=row[0][1](cs:196-197).
  //   lookup 값컬럼 실측 미확정 → NAME/CODE 를 Number 로 시도, 실패 시 기본 1(AS-IS dtBaseDay 빈 경우와 동일).
  const [changeReqDayRows] = useTabLookupQueries({
    filters: [{ lookupType: POPUP.CHANGE_REQ_DAY_LOOKUP }],
  });
  const dDay = useMemo(() => {
    const r0 = (changeReqDayRows ?? [])[0] as { NAME?: unknown; CODE?: unknown } | undefined;
    const n = Number(str(r0?.NAME) || str(r0?.CODE));
    return Number.isFinite(n) && n > 0 ? n : POPUP.CHANGE_REQ_DAY_DEFAULT;
  }, [changeReqDayRows]);
  // AS-IS dBaseDate = 오늘(timezone) + dDay, 출하일 >= dBaseDate 만 허용(cs:200-202, 1054). client 오늘로 등가.
  const minShipYmd = useMemo(() => dayjs().add(dDay, 'day').format('YYYYMMDD'), [dDay]);

  // 오픈 시 더블클릭한 메인 행값으로 1행 구성(AS-IS clbDivision_SelectedIndexChanged SetValue 묶음, cs:1281-1290).
  useEffect(() => {
    if (!open || !row) {
      setRows([]);
      return;
    }
    const p = row;
    setRows([
      {
        // AS-IS siMain.Insert() — 팝업 열자마자 행 액션 'I'(cs:324). 닫기 무경고는 DataGrid
        //   excludeFromDirtyCheck 가 담당한다(아래) — insert 행을 dirty 로 세지 않아 X/Cancel 둘 다 조용.
        CRUD_TYPE: 'I',
        DIVISION_ID: str(p.DIVISION_ID),
        // AS-IS 저장 p_division_id = _pDivision_org(siMain TEMPCOLUMN, SORT 26 실측) — 미존재 시 폴백.
        DIVISION_ORG:
          str(p.TEMPCOLUMN) || str(p.ORIGIN_FROM_DIVISION_ID) || str(p.DIVISION_ID),
        SCM_SITE_ID: str(p.SCM_SITE_ID),
        PLANT_ID: str(p.PLANT_ID),
        FROM_SITE: str(p.FROM_SITE),
        TO_SITE: str(p.TO_SITE),
        MODEL_ID: str(p.MODEL_ID),
        ITEM_ID: str(p.ITEM_ID),
        NICK_NAME: str(p.NICK_NAME),
        SHIPMENT_DATE: '',
        SHIPMENT_QTY: '',
        INCOTERMS: str(p.INCOTERMS),
        TRANSPORT_MODE: str(p.TRANSPORT_MODE),
        // AS-IS _pBodId="" (cs:1394-1395) — 부모 BOD_ID 를 싣지 않고 공백을 넘겨 SP 가 BOD 를 Priority 1 로
        //   재계산하게 한다("출하요청 팝업 오픈 시 BOD_ID 는 항상 Priority 1 순위로 셋팅"). 저장 p_bod_id=''.
        BOD_ID: '',
        CONFIRM_DAY: str(p.CONFIRM_DAY),
      },
    ]);
  }, [open, row]);

  // FindData 재채움(AS-IS FindData cs:345-437) — GET_ITEM_POPUP(=SSP0022_GET_ITEM_POPUP, sheet 'bodItemPopup'
  //   /SEARCH, DB 실측 매핑)로 그 행의 Div_org/From/To/Item/BOD/Incoterms/TransMode/PlanDate 를 넘겨 유효한
  //   Incoterms/TransMode/BOD/ConfirmDay(+ORIGIN division)를 되받아 채운다. 0행/실패면 AS-IS else 처럼 무동작
  //   (클리어 유지). 값은 행 객체에 직접 써 setCellData coerce 경로를 피한다(ExchangeRateModal 주석 동일).
  const applyFindData = useCallback(
    async (sender: FlexGridType<ShipmentRequestInsertRow>, r: ShipmentRequestInsertRow) => {
      const from = str(r.FROM_SITE);
      const to = str(r.TO_SITE);
      if (!from || !to) return; // from/to 미완이면 proc 0행 — 불필요 호출 생략(AS-IS 도 0행 시 무동작)
      try {
        const res = await apiClient.callProc<MENU_ID, SHEETS.BOD_ITEM_POPUP>(
          MENU_ID,
          SHEETS.BOD_ITEM_POPUP,
          'SEARCH',
          {
            divisionId: str(r.DIVISION_ORG),
            fromSiteId: from,
            toSiteId: to,
            itemId: str(r.ITEM_ID),
            bodId: str(r.BOD_ID),
            incoterms: str(r.INCOTERMS),
            transportMode: str(r.TRANSPORT_MODE),
            planStartYyyymmdd: planDate,
          }
        );
        const row0 = ((res.result as { o_rc1?: Record<string, unknown>[] })?.o_rc1 ?? [])[0];
        if (!row0) return; // AS-IS else(cs:438) — 아무것도 안 함(클리어 상태 유지)
        r.DIVISION_ORG = str(row0.DIVISION_ID) || str(r.DIVISION_ORG);
        r.INCOTERMS = str(row0.INCOTERMS);
        r.TRANSPORT_MODE = str(row0.TRANSPORT_MODE);
        r.BOD_ID = str(row0.BOD_ID);
        r.CONFIRM_DAY = str(row0.CONFIRM_DAY);
        sender.invalidate();
      } catch {
        /* AS-IS: 조회 실패 시 재채움 없음(클리어 유지) */
      }
    },
    [planDate]
  );

  // AS-IS 오픈 시 FindData(clbDivision_SelectedIndexChanged cs:1292-1295) — From/To 가 채워져 열리므로 1회 돌려
  //   BOD(공백 전달)·Incoterms·TransMode·ConfirmDay 를 표준정보 기준으로 맞춘다. 그리드 빌드 전이면 rAF 재시도
  //   (ExchangeRateModal 동일 사유 — itemsSource 바인딩이 비동기).
  useEffect(() => {
    if (!open || !row) return;
    let raf = 0;
    let done = false;
    const tick = () => {
      if (done) return;
      const g = gridRef.current;
      const r = g?.collectionView?.sourceCollection?.[0];
      if (g && r) {
        done = true;
        void applyFindData(g, r);
        return;
      }
      raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    return () => {
      done = true;
      cancelAnimationFrame(raf);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, row]);

  const columns = useMemo<RawFlexGridColumnConfig[]>(
    () => [
      col('DIVISION_ID', `${t(LBL.DIV, 'Div')}*`, 90), // locked(AS-IS LockRange3 cs:327)
      col('FROM_SITE', `${t(LBL.FROM_SITE, 'From Site')}*`, 120, {
        combo: COMBO.CELL_FROM_SITE,
        align: 'L',
      }),
      col('TO_SITE', 'To Site*', 120, { combo: COMBO.CELL_TO_SITE, align: 'L' }),
      col('MODEL_ID', 'Model*', 150, { align: 'L' }), // locked(AS-IS LockRange3 cs:330)
      col('ITEM_ID', `${t(LBL.MATERIAL, 'Material')}*`, 150, { align: 'L' }), // locked(cs:331)
      col('SHIPMENT_DATE', 'Shipment Date*', 110, { edit: 'date' }),
      col('SHIPMENT_QTY', 'Qty*', 80, { edit: 'num' }),
      col('INCOTERMS', 'Incoterms*', 90, { combo: COMBO.CELL_INCOTERMS }),
      col('TRANSPORT_MODE', 'Trans Mode*', 90, { combo: COMBO.CELL_TRANSPORT_MODE }),
    ],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    []
  );

  // 셀 편집 종료 캐스케이드. (출하일 하한 MSG00194 는 FPDate 피커의 오늘-기본값 때문에 인라인하지 않고 저장 시만.)
  //   - FROM_SITE/TO_SITE 변경: Incoterms/TransMode/BOD/ConfirmDay 클리어만(cs:980-998). AS-IS 는 이어서 FindData 를
  //     부르나 그 proc 가 비운 incoterms/transmode 로는 0행이라 재채움이 없다(= AS-IS 관찰도 "빈 값", 아래 분기 주석).
  //   - INCOTERMS/TRANSPORT_MODE 변경: FindData 재채움(cs:1000-1041) — 둘 다 채워지면 proc 가 route 를 줘 BOD/
  //     ConfirmDay 가 채워진다.
  //     값은 행 객체에 직접 써 setCellData coerce 경로를 피한다(ExchangeRateModal 주석 동일).
  useEffect(() => {
    // 매 오픈마다 재부착해야 한다 — CustomDialog 는 닫힐 때 DataGrid 를 언마운트하고 다시 열면 **새 그리드**를
    //   만든다. open 을 dep 에 넣지 않으면 effect 가 재실행되지 않아 첫 그리드에만 붙고, 재오픈한 새 그리드에는
    //   cellEditEnded 가 안 붙어 From/To 클리어·가드·FindData 가 안 돈다(사용자 신고 2026-11-04 "재오픈 시 안 됨").
    if (!open) return;
    let raf = 0;
    let attachedGrid: FlexGridType<ShipmentRequestInsertRow> | undefined;
    const onEdit = (sender: FlexGridType<ShipmentRequestInsertRow>, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const r = sender.rows[e.row]?.dataItem as ShipmentRequestInsertRow | undefined;
      if (!r) return;
      // 출하일 하한(MSG00194)은 여기서 안 한다 — FPDate 피커가 빈 셀에 오늘을 기본 커밋해 조기 발화하므로
      //   저장 시(handleSave)에만 검증한다(사용자 신고 2026-11-04).
      if (binding === 'FROM_SITE' || binding === 'TO_SITE') {
        // AS-IS 는 클리어 후 FindData 를 부르지만, GET_ITEM_POPUP WHERE 가 incoterms/transmode 를 필터한다
        //   (SA.INCOTERMS=P_INCOTERMS / SA.TRANSPORT_MODE=P_TRANSPORT_MODE, pkg body 실측 L425-428). 방금 비운
        //   ''로는 두 조건이 모두 거짓 → 항상 0행 → 재채움 없음. 그래서 AS-IS 관찰 결과가 "Incoterms/TransMode
        //   가 빈 값이 된다"이다(사용자 확인 2026-11-04). 무의미한 호출을 생략하고 클리어만 한다 — 관찰 동작
        //   동일. 재채움은 Incoterms/TransMode 를 고른 시점(아래)과 오픈 시점(applyFindData)에만 일어난다.
        r.INCOTERMS = '';
        r.TRANSPORT_MODE = '';
        r.BOD_ID = '';
        r.CONFIRM_DAY = '';
        sender.invalidate();
      } else if (binding === 'INCOTERMS' || binding === 'TRANSPORT_MODE') {
        void applyFindData(sender, r);
      }
    };
    // 그리드는 handleInitialized(비동기)에서 gridRef.current 로 세팅되므로, 준비될 때까지 rAF 로 재시도해
    //   핸들러를 반드시 붙인다(on-open FindData 와 동일 사유 — 안 그러면 cellEditEnded 가 영영 안 붙어
    //   From/To 클리어·날짜 가드·FindData 재채움이 전부 안 돈다, 사용자 신고 2026-11-04).
    const attach = () => {
      const g = gridRef.current;
      if (g) {
        g.cellEditEnded.addHandler(onEdit as never);
        attachedGrid = g;
        return;
      }
      raf = requestAnimationFrame(attach);
    };
    attach();
    return () => {
      cancelAnimationFrame(raf);
      try {
        attachedGrid?.cellEditEnded?.removeHandler(onEdit as never);
      } catch {
        /* unmount race — 그리드가 먼저 dispose 됐으면 무시 */
      }
    };
  }, [open, applyFindData]);

  const required = (label: string): string =>
    t('MSG00429', '{0} is required.').replace('{0}', label);

  const handleSave = async () => {
    const g = gridRef.current;
    g?.finishEditing();
    const r = rows[0];
    if (!r) return;

    // S1 필수(AS-IS checkRequiredOfSpread, cs:488) — 9 표시컬럼 전부. 날짜/수량 외는 parent prefill 또는 셀 콤보.
    const emptyCol = columns.find(c => {
      if (c.colNm === 'SHIPMENT_DATE') return !toYmd8(r.SHIPMENT_DATE);
      if (c.colNm === 'SHIPMENT_QTY') return str(r.SHIPMENT_QTY).replace(/,/g, '').trim() === '';
      return str(r[c.colNm as keyof ShipmentRequestInsertRow]).trim() === '';
    });
    if (emptyCol) {
      void setAlert({ type: 'alert', content: required((emptyCol.colLblNm ?? '').replace('*', '')) });
      return;
    }

    // S3 날짜형식(cs:499-508) — MSG00049 재번호(MSG00611).
    const shipYmd = toYmd8(r.SHIPMENT_DATE);
    if (!isValidYmd8(shipYmd)) {
      void setAlert({ type: 'alert', content: t(MSG.INVALID_DATE, 'Invalid date format. (YYYYMMDD)') });
      return;
    }
    // 출하일 하한(MSG00194) — 편집 가드를 우회(직접 입력/붙여넣기)한 경우 대비해 저장 시 재검증.
    if (shipYmd < minShipYmd) {
      void setAlert({
        type: 'alert',
        content: t(MSG.CHANGE_REQ_MIN_SHIP, 'Change requests are possible from the current D+{0} ship date.').replace(
          '{0}',
          String(dDay)
        ),
      });
      return;
    }
    // S4 출하일 < 확정일(ConfirmDayChk, cs:720-755) — MSG00323. ConfirmDay 가 비었으면 제약 없음.
    const confirmYmd = ymd8(r.CONFIRM_DAY);
    if (isValidYmd8(confirmYmd) && confirmYmd > shipYmd) {
      void setAlert({
        type: 'alert',
        content: t(MSG.CONFIRM_DAY_BEFORE, 'Shipment date cannot be entered before {0}').replace(
          '{0}',
          confirmYmd
        ),
      });
      return;
    }

    // S5 저장확인 — AS-IS MSG00012 는 TO-BE 재사용 충돌이라 공용 SAVE_CONFIRM(요청상세 저장과 동일).
    const confirmed = await setAlert({
      type: 'confirm',
      content: t(CRUD_MSG.SAVE_CONFIRM.id, CRUD_MSG.SAVE_CONFIRM.fallback),
    });
    if (!confirmed) return;

    // AS-IS SaveData(cs:539-583) 1행 payload — p_active_flag='M'. 파라미터명은 SCM_ADM_PROC_M.COL_NM(camelCase,
    //   '^'-폴딩 대상이나 단일행이라 값 그대로). scm_site_id/plant_id/division 은 parent 행값(요청상세 fold 와 매핑 상이).
    const payload: Record<string, string> = {
      activeFlag: 'M',
      divisionId: str(r.DIVISION_ORG),
      companyId,
      scmSiteId: str(r.SCM_SITE_ID),
      plantId: str(r.PLANT_ID),
      modelId: str(r.MODEL_ID).toUpperCase(),
      itemId: str(r.ITEM_ID).toUpperCase(),
      fromSite: str(r.FROM_SITE),
      toSite: str(r.TO_SITE),
      etaDate: shipYmd,
      bodId: str(r.BOD_ID),
      qty: str(r.SHIPMENT_QTY).replace(/,/g, ''),
      incoterms: str(r.INCOTERMS),
      transportMode: str(r.TRANSPORT_MODE),
      createdBy: str(session.userId),
      debugMode: 'N',
    };

    setSaving(true);
    try {
      const result = await postShipmentRequestSave(payload);
      if (!result.ok) {
        void setAlert({
          type: 'alert',
          content: result.message || t(CRUD_MSG.SAVE_FAIL.id, CRUD_MSG.SAVE_FAIL.fallback),
        });
        return;
      }
      // S6 'S' 성공 — 공용 SAVED. 'X'=표준정보 미등록(route/BOD NULL) / 'F'·그 외=서버오류(AS-IS MSG00324/00042).
      if (result.code === 'S') {
        void setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });
        onSaved();
        return;
      }
      // S7 'X' = 기준정보(route/BOD) 미등록 — AS-IS SaveData(cs:606-616)는 MSG00324 를 예/아니오로 띄우고
      //   '예' 면 base.AddHelpButton("Standard Information SSP Manual") 로 매뉴얼을 연다. TO-BE 는 MSG01321
      //   (예/아니오) + onConfirm 으로 매뉴얼 새 탭(선례 ShipmentPlan/ShipmentRequestModal 동형).
      if (result.code === 'X') {
        void setAlert({
          type: 'confirm',
          content: t(MSG.STANDARD_INFO, 'Standard information is not registered. Would you like to view the reference?'),
          onConfirm: () => window.open(STANDARD_MANUAL_URL, '_blank', 'noopener,noreferrer'),
        });
        return;
      }
      void setAlert({
        type: 'alert',
        content:
          result.message ||
          t(MSG.SYSTEM_ERROR, 'A system error occurred. Capture the screen and contact the administrator.'),
      });
    } catch {
      void setAlert({ type: 'alert', content: t(CRUD_MSG.SAVE_FAIL.id, CRUD_MSG.SAVE_FAIL.fallback) });
    } finally {
      setSaving(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      size={900}
      height={260}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Shipment Request Insert</h2>
        </div>
      }
      customContentArea={
        <div className={styles.contentWrap}>
          <div className={styles.toolbar}>
            <Button
              appearance='contained'
              priority='primary'
              size='small'
              buttonLabel='Save'
              disabled={saving || rows.length === 0}
              onClick={() => void handleSave()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='small'
              buttonLabel='Cancel'
              onClick={modalClose}
            />
          </div>

          <div className={styles.gridWrap}>
            <DataGrid<ShipmentRequestInsertRow>
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
              editTrackerRef={editTrackerRef}
              itemsSource={rows}
              staticColumns={columns}
              comboParams={comboParams}
              // AS-IS parity — insert 행('I')을 열어둔 채 닫아도 경고가 없어야 한다. 이 그리드를 dirty
              //   집계에서 제외해 X/Cancel 둘 다 무경고로 닫히게 한다(편집 후 닫기도 AS-IS 처럼 폐기).
              excludeFromDirtyCheck
            />
          </div>
        </div>
      }
    />
  );
};
