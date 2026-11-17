import type { DataMap, FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';
import { useMutation } from '@foundation/query-client';
import { sessionTimeZone } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Box, Stack } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  DRAFTING_TITLE,
  LBL,
  MENU_ID,
  MSG,
  MSG_CHAIN,
  SCREEN_TEXT,
  SHEETS,
  STANDARD_MANUAL_URL,
} from '../../shipment-plan.constants';
import {
  type ErpChainDeps,
  runRequestErpChain,
  runRequestPreChecks,
  splitRequestRowsBySo,
} from '../../utils/shipment-plan.erpChain';
import { useShipmentPlanLookups } from '../../utils/shipment-plan.lookups';
import {
  collectRequestConfirmSaveRows,
  isRequestRowChanged,
  toYmd8,
} from '../../utils/shipment-plan.save';

interface Props {
  open: boolean;
  // R8: 팝업 종료(취소 포함) 후 페이지가 무조건 Main 재조회 — modalClose 가 그 트리거를 겸한다.
  modalClose: () => void;
  tabId: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS SSP0060_ShipmentPlanRequestPopup (Shipment Request Popup — cs 2,029줄):
//   Main Shipment Plan 저장(SAVE_SHIPMENT_PLAN = 변경요청 draft 생성) 직후 무조건 오픈(_sRequestNo='').
//   draft(Confirmed vs Change diff)를 보여주고 **Change Reason + Reason Detail** 을 받아 확정 저장한다.
//     조회 = GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING('')  (o_rc1: Confirmed/Change 짝 + DIFF_QTY + ACT_FLAG 선계산)
//     저장 = SAVE_SHIPMENT_REQUEST_CONFIRM             (하단 Plan Detail Confirm 과 동일 SP·엔드포인트 planDetail/SAVE)
//   팝업 닫히면(확정·취소 무관) 페이지가 Main 재조회(R8, modalClose 트리거).
//   컬럼/버튼 배치는 AS-IS 캡처(2026-10-22) 1:1: 좌측 식별 8컬럼 + [Confirmed 6] + [Change 6] + Diff Qty +
//   Change Reason + Reason Detail, 상단 툴바 = Auto Set · Change Reason* · Reason Detail* · Save · Cancel.
//   저장 연쇄(AS-IS SaveData RP:401~700 → GetERPInterface RP:894~1106)는 utils/shipment-plan.erpChain.ts 로
//   배선했다(2026-10-27). SO 행은 CHG_BATCH('C')(RP:1253) 라우팅이 없어 보류한다 — handleSave 주석.

// 편집 가능 컬럼 (AS-IS EditButton L326~327: NEW_SHIPMENT_DATE/NEW_SHIPMENT_CONFIRM_QTY +
//   CHANGE_REASON_CODE/CHANGE_REASON_DETAIL). 나머지는 조회전용.
const EDITABLE_BINDINGS: ReadonlySet<string> = new Set([
  'NEW_SHIPMENT_DATE',
  'NEW_SHIPMENT_CONFIRM_QTY',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
]);

// 2단 그룹 헤더(Confirmed/Change 상단 + leaf 하단) 행 높이(px/행) — 글자 잘림 방지.
const HEADER_ROW_HEIGHT = 26;

// 저장 결과 'X'(기준정보 미등록) 구분용 센티넬 — 화면 본문 SAVE_RESULT_X 와 같은 역할.
const SAVE_RESULT_X = '__SSP0060_REQUEST_SAVE_RESULT_X__';

export const ShipmentRequestModal = ({ open, modalClose, tabId }: Props) => {
  const { t } = useTranslation();
  const session = useSessionStore(s => s.session);
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType>();
  // 상단 Auto Set 입력 (AS-IS Auto Set + Change Reason*/Reason Detail* 툴바 — 변경 행에 일괄 적용)
  const [autoReason, setAutoReason] = useState('');
  const [autoDetail, setAutoDetail] = useState('');

  const filters = useMemo(
    () => ({
      changeRequestNo: '', // AS-IS pop._sRequestNo='' (R8 — 사용자 drafting 전건)
      userId: session.userId ?? '',
      language: session.langCd ?? '',
    }),
    [session.userId, session.langCd]
  );

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.CONFIRM_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.CONFIRM_DETAIL,
    tabId,
    filters,
    enabled: open,
  });
  // 열릴 때마다 강제 재조회 — filters(queryKey)가 고정이라 react-query 가 직전 캐시를 돌려줘,
  //   Main 저장으로 **방금 생성된 draft** 가 팝업에 안 보였다(2026-10-22 실사고: DB 상세 2건인데
  //   네트워크에 조회 0회 = 캐시 재사용). AS-IS 팝업은 Form_Load 마다 FindData_Main 재조회.
  useEffect(() => {
    if (open) void refetch();
  }, [open, refetch]);
  // 그리드가 행 객체를 직접 수정(NEW 수량/일자·사유)하므로 react-query 캐시를 건드리지 않도록 복제한다.
  const rows = useMemo(
    () => (data?.o_rc1 ?? []).map(r => ({ ...(r as Record<string, unknown>) })),
    [data]
  );

  // Change Reason 콤보 — 그리드 셀(DataMap) + 상단 Auto Set 드롭다운(options) 양쪽에 쓴다.
  //   DataMap 은 useShipmentPlanLookups 가 참조 안정화(useStableLookup)해 돌려준다 — 하단 Detail 탭과
  //   같은 인스턴스. 상단 드롭다운 옵션도 같은 DataMap 의 항목('CODE : 명', '-' 해제 제외)에서 유도해
  //   중복 lookup 호출(불안정 배열 → 매 렌더 재생성)을 없앤다.
  const { changeReasonDataMap } = useShipmentPlanLookups();
  const reasonOptions = useMemo(() => {
    const items = (changeReasonDataMap?.collectionView?.items ?? []) as {
      CODE?: unknown;
      NAME?: unknown;
    }[];
    return items
      .filter(r => str(r.CODE) !== '' && str(r.CODE) !== '-')
      .map(r => ({ value: str(r.CODE), label: str(r.NAME) }));
  }, [changeReasonDataMap]);

  // 전 컬럼을 하나의 2단 그룹 구조(dynamicColumns)로 준다 — 좌측 식별 컬럼은 단일(= 2단 rowspan),
  //   Confirmed/Change 만 그룹. 정적/동적을 섞으면 ONE_DEPTH 정적(height 48)과 2단 동적의 헤더 단이
  //   어긋나 컬럼이 밀린다(AS-IS 는 단일 2단 헤더) — 전부 dynamicColumns 로 통일해 균일 2단 헤더를 만든다.
  //   라벨은 SCM_ADM_MSG_M 실측 코드로 다국어. ETD/ETA/Qty/L/T(Day)/Confirmed/Change/Diff Qty 는 코드
  //   부재 + AS-IS 도 전 언어 영문이라 리터럴 유지.
  const columns = useMemo<FlexGridColumnConfig[]>(() => {
    const shipDate = t('LBL01115', '_Shipment Date');
    const transMode = t('LBL00025', '_Trans Mode');
    const leaf = (
      binding: string,
      header: string,
      width: number,
      align: 'left' | 'center' | 'right',
      editable = false,
      dataMap?: DataMap
    ): FlexGridColumnConfig => ({
      binding,
      header,
      align,
      width,
      allowSorting: false,
      ...(editable ? { _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL } : {}),
      ...(dataMap ? { dataMap } : {}),
    });
    return [
      leaf('CONFIRM_ID', 'Confirm/Plan ID', 140, 'left'),
      leaf('ERP_SO_NO', t('LBL01111', '_SO No'), 110, 'center'),
      leaf('PROJECT_NAME', t('LBL00869', '_Project Name'), 140, 'left'),
      leaf('FCST_TYPE', t('LBL01141', '_FCST Type'), 90, 'left'),
      leaf('ITEM_ID', t('LBL00669', '_Model'), 120, 'left'),
      leaf('FROM_SITE', t('LBL00022', '_From Site'), 90, 'left'),
      leaf('TO_SITE', t('LBL00023', '_To Site'), 120, 'left'),
      leaf('INCOTERMS', t('LBL00024', '_Incoterms'), 80, 'center'),
      {
        header: 'Confirmed',
        align: 'center',
        allowSorting: false,
        columns: [
          leaf('LT_DAY', 'L/T(Day)', 70, 'center'),
          leaf('ETD', 'ETD', 90, 'center'),
          leaf('ETA', 'ETA', 90, 'center'),
          leaf('TRANSPORT_MODE', transMode, 85, 'center'),
          leaf('SHIPMENT_DATE', shipDate, 110, 'center'),
          leaf('SHIPMENT_CONFIRM_QTY', 'Qty', 80, 'right'),
        ],
      },
      {
        header: 'Change',
        align: 'center',
        allowSorting: false,
        columns: [
          leaf('NEW_LT_DAY', 'L/T(Day)', 70, 'center'),
          leaf('NEW_ETD', 'ETD', 90, 'center'),
          leaf('NEW_ETA', 'ETA', 90, 'center'),
          leaf('NEW_TRANSPORT_MODE', transMode, 85, 'center'),
          leaf('NEW_SHIPMENT_DATE', shipDate, 110, 'center', true),
          // 숫자 입력제한(positiveOnly 등)은 넣지 않는다 — DataGrid 가 동적 leaf config 를 Wijmo Column 에
          //   그대로 복사해 Unknown property assertion 실패(MainGrid 동적 leaf 도 미사용). NEW 수량은 선계산값.
          leaf('NEW_SHIPMENT_CONFIRM_QTY', 'Qty', 80, 'right', true),
        ],
      },
      leaf('DIFF_QTY', 'Diff Qty', 80, 'right'),
      // Change Reason 셀 콤보(하단 Shipment Plan Detail 탭과 동일 DataMap) — 컬럼 정의에 **직접** 싣는다.
      //   changeReasonDataMap 은 useShipmentPlanLookups 가 참조 안정화(useStableLookup+useMemo)해 돌려주는
      //   단일 인스턴스라 렌더마다 새 참조가 아니다 → columnGroups 재대입 루프가 없다. 종전엔 사후
      //   주입(applyLayout)만 했는데, columnGroups 재생성 직후~재주입 사이 창에서 dataMap 이 비어 편집기가
      //   드롭다운이 아니라 **일반 텍스트 입력**으로 떠서 콤보 선택이 커밋되지 않았다(2026-10-22 사용자 신고).
      //   config 에 실으면 Wijmo 가 컬럼 생성 때마다 dataMap 과 함께 만들어 항상 콤보다. (과거 이 자리에
      //   dataMap 을 못 실은 건 '불안정 lookup 배열' 때문이었고, 그 전제가 안정 인스턴스로 바뀌었다.
      //   무한 루프의 실제 원인은 공용 DataGrid staticColumns 기본값 `=[]` 였고 별도 수정했다.)
      leaf('CHANGE_REASON_CODE', t('LBL01060', '_Change Reason'), 140, 'left', true, changeReasonDataMap ?? undefined),
      leaf('CHANGE_REASON_DETAIL', t('LBL01104', '_Reason Detail'), 180, 'left', true),
    ];
  }, [t, changeReasonDataMap]);

  // CHANGE_REASON_CODE 셀 콤보(DataMap) 주입 + 편집 잠금(4컬럼) + 편집가능 시각(wj-cell-editable) +
  //   2단 헤더 높이(글자 잘림 방지). columnGroups 재생성·lookup 비동기 도착 시 updatedLayout 마다 재적용.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyLayout = () => {
      // 편집 중(콤보 드롭다운 열림/셀 편집 진행)에는 레이아웃을 건드리지 않는다 — 여기서 g.invalidate()
      //   를 부르면 refresh 가 finishEditing 을 불러 드롭다운이 닫히고 **선택이 커밋되기 전에 편집이
      //   끝난다**(2026-10-22 사용자 신고: 콤보는 뜨는데 선택이 안 됨). 2단 그룹 헤더를 26px 로 강제하면
      //   헤더 높이가 매 updatedLayout 마다 목표와 어긋나 invalidate 가 반복되는데, 그게 열린 드롭다운을
      //   계속 닫아버렸다. DataGrid.drainRowParamReval 주석도 "편집 중 invalidate 금지"를 경고한다.
      //   편집이 끝나면 다음 updatedLayout 에서 다시 적용된다.
      if (g.activeEditor) return;
      const hr = g.columnHeaders?.rows;
      if (hr && hr.length > 0) {
        let changed = false;
        for (let i = 0; i < hr.length; i += 1) {
          if (Math.round(hr[i].height ?? hr.defaultSize) !== HEADER_ROW_HEIGHT) {
            hr[i].height = HEADER_ROW_HEIGHT;
            changed = true;
          }
        }
        if (Math.round(hr.defaultSize) !== HEADER_ROW_HEIGHT) {
          hr.defaultSize = HEADER_ROW_HEIGHT;
          changed = true;
        }
        if (changed) g.invalidate(true);
      }
    };
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      e.cancel = !EDITABLE_BINDINGS.has(binding);
    };
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      e.cell.classList.toggle('wj-cell-editable', EDITABLE_BINDINGS.has(binding));
    };
    g.updatedLayout.addHandler(applyLayout);
    g.beginningEdit.addHandler(beginningEditHandler);
    g.formatItem.addHandler(formatItemHandler);
    applyLayout();
    g.invalidate();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyLayout);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.formatItem?.removeHandler(formatItemHandler);
      } catch {
        // unmount race
      }
    };
  }, [changeReasonDataMap, rows]);

  // Confirm 저장 — SAVE_SHIPMENT_REQUEST_CONFIRM(planDetail/SAVE). 38 IN '^'-폴딩 단일 객체 직배선.
  //   (배열 {data:[]} 전송은 38 IN 전건 null 바인딩 → false-success. Main/Detail 저장과 동일 처방.)
  const { mutate: mutateConfirm, isPending } = useMutation({
    mutationKey: [tabId, SHEETS.PLAN_DETAIL, 'SAVE'],
    mutationFn: async (payload: Record<string, string>) => {
      const res = await apiClient.post(
        `/${MENU_ID}/${SHEETS.PLAN_DETAIL}/SAVE/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        throw new Error(t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      // 업무결과 검사 (gap-audit G05) — o_rc1 RESULT_CODE!='S' 면 미저장(false-success 방지).
      const result = (
        res.data as {
          result?: {
            o_rc1?: { RESULT_CODE?: unknown; ERR_MESSAGE?: unknown }[];
            o_rc2?: { ERR_MESSAGE?: unknown }[];
          };
        }
      )?.result;
      const rc = result?.o_rc1?.[0];
      const resultCode = str(rc?.RESULT_CODE);
      // 'X' = 기준정보(BOD/route) 미등록 — AS-IS 팝업(SSP0060_ShipmentPlanRequestPopup.cs L648~657)은
      //   일반 실패(MSG00284)와 달리 예/아니오 확인 후 '예' 면 SSP 매뉴얼을 연다. 화면 본문(ShipmentPlan
      //   handleSaveError)과 같은 메시지·동작으로 맞춘다(결함 B8). 센티넬로 구분해 onError 에서 분기한다.
      if (resultCode === 'X') {
        throw new Error(SAVE_RESULT_X);
      }
      if (resultCode && resultCode !== 'S') {
        const errMsg = str(rc?.ERR_MESSAGE) || str(result?.o_rc2?.[0]?.ERR_MESSAGE);
        throw new Error(errMsg || t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      return res.data;
    },
    onSuccess: () => {
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      modalClose(); // 닫힘 시 페이지가 Main 재조회(R8)
    },
    onError: (error: Error) => {
      if (error.message === SAVE_RESULT_X) {
        void setAlert({
          type: 'confirm',
          content: t(MSG.STD_INFO_NOT_REGISTERED, '_기준정보가 등록되어 있지 않습니다. 참고자료를 열람하시겠습니까?'),
          onConfirm: () => {
            window.open(STANDARD_MANUAL_URL, '_blank', 'noopener,noreferrer');
          },
        });
        return;
      }
      void setAlert({ type: 'alert', content: error.message || t(MSG.SAVE_FAILED, '__Save failed.') });
    },
  });

  const sourceRows = (): Record<string, unknown>[] =>
    (gridRef.current?.collectionView?.sourceCollection as Record<string, unknown>[]) ?? rows;

  // Auto Set — 변경 행(수량/일자 차이) 전체에 상단 Change Reason/Reason Detail 일괄 적용.
  const handleAutoSet = () => {
    gridRef.current?.finishEditing();
    sourceRows().forEach(r => {
      if (!isRequestRowChanged(r)) return;
      r.CHANGE_REASON_CODE = autoReason;
      r.CHANGE_REASON_DETAIL = autoDetail;
    });
    gridRef.current?.collectionView?.refresh();
  };

  const erpDeps = useMemo<ErpChainDeps>(
    () => ({
      post: (url, body) => apiClient.post(url, body),
      getCombo: params => apiClient.getCombo(params),
      t: (key, fallback) => t(key, fallback),
      alert: content => setAlert({ type: 'alert', content }),
      confirm: content => setAlert({ type: 'confirm', content }),
      userId: session.userId ?? '',
      timeZone: sessionTimeZone(session),
    }),
    [t, setAlert, session]
  );
  const savingRef = useRef(false);
  // 저장 전체 구간(검증~ERP 연쇄~확정저장) 동안 팝업을 Dim+잠금 — 중복 클릭 차단(사용자 요청 2026-11-10).
  //   savingRef(동기 재진입 가드)는 리렌더를 못 일으켜 버튼 시각잠금/오버레이에 쓸 수 없어 state 를 병행한다.
  const [saving, setSaving] = useState(false);

  // 저장 — AS-IS SaveData(RP:401~700) 순서:
  //   검증(RP:422, 아래) → [엔진 진행 검사 RP:412 SSP0003_GET_SSP_PLAN_PROCESSING_CHECK — TO-BE 메타 없음, 보류]
  //   → ERP 중단기간(RP:415) → 전 행 상태 재검증(RP:429~436) → 확인창(RP:440) →
  //   GetERPInterface(RP:455 → 894~1106: 날짜·2분 잠금·행별 DRAFTING_MAIN·CHG_BATCH_NEW_C·ERP·보상) →
  //   SAVE_SHIPMENT_REQUEST_CONFIRM(RP:584, planDetail/SAVE — activeFlag 'M' 고정 B1 유지).
  //   SO 행(ERP_SO_NO 有)은 AS-IS SoNo 가 PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH('C')(RP:1253) 로 XIF 'C' 를 적재하는데
  //   TO-BE 에 그 경로의 라우팅이 없다. 적재 없이 송신·확정하면 ERP 와 계획이 어긋나므로 SO 행은 이번 저장에서
  //   빼고(DRAFTING·ERP·CONFIRM 모두) 알린다. 전부 SO 행이면 저장하지 않는다.
  const runSave = async (src: Record<string, unknown>[]): Promise<void> => {
    const changed = src.filter(isRequestRowChanged);
    const { soRows, nonSoRows } = splitRequestRowsBySo(changed);
    const soList = Array.from(new Set(soRows.map(r => str(r.ERP_SO_NO).trim()))).join(', ');
    if (nonSoRows.length === 0) {
      await setAlert({
        type: 'alert',
        content: t(
          SCREEN_TEXT.SO_ROW_HOLD_ALL,
          '__Rows with an SO number cannot be sent to ERP yet (CHG_BATCH C routing is not registered), so nothing was saved. [ SO NO : {0} ]'
        ).replace('{0}', soList),
      });
      return;
    }
    if (!(await runRequestPreChecks(erpDeps, src))) return;
    if (soRows.length > 0) {
      await setAlert({
        type: 'alert',
        content: t(
          SCREEN_TEXT.SO_ROW_HOLD,
          '__Rows with an SO number are excluded from this save (CHG_BATCH C routing is not registered). [ SO NO : {0} ]'
        ).replace('{0}', soList),
      });
    }
    const ok = await setAlert({
      type: 'confirm',
      content: t(MSG.CONFIRM_SAVE, {
        defaultValue: '_Are you sure you want to confirm the shipping plan change requests?',
      }),
    });
    if (!ok) return;
    const { proceed, excludeRows, excludeConfirmIds } = await runRequestErpChain(erpDeps, {
      rows: nonSoRows,
      meta: { userId: session.userId ?? '', title: DRAFTING_TITLE.REQUEST_POPUP, programId: MENU_ID },
    });
    if (!proceed) return;
    // 실패 행(DRAFTING_MAIN 실패·요청번호 없음, E, F/C_E, 'B' 적재 실패, 예외)과 ERP 거절 CONFIRM_ID
    //   (AS-IS errConfrimList2, RP:522~533)는 확정에서 뺀다(검토 R3).
    const targets = nonSoRows.filter(
      r => !excludeRows.has(r) && !excludeConfirmIds.has(str(r.CONFIRM_ID).trim())
    );
    const payload = collectRequestConfirmSaveRows(targets, session.userId ?? '');
    if (payload) mutateConfirm(payload);
  };

  const handleSave = async () => {
    gridRef.current?.finishEditing();
    const src = sourceRows();
    // 변경 행의 Change Shipment Date 형식 선검사 (사용자 요청 2026-11-06).
    //   AS-IS 는 확인창 이후 GetERPInterface(RP:945~950)에서야 검사해, 잘못된 날짜도 서버 사전검사·확인창을
    //   다 거친 뒤에 막혔다. 같은 판정(toYmd8)·같은 메시지(MSG01081)를 Save 클릭 첫 단계로 앞당긴다.
    //   runRequestErpChain 의 기존 검사는 방어용으로 그대로 둔다. {0} 에는 행 번호와 입력값을 넣는다.
    for (let i = 0; i < src.length; i += 1) {
      const r = src[i];
      if (!isRequestRowChanged(r)) continue;
      if (!toYmd8(r.NEW_SHIPMENT_DATE)) {
        void setAlert({
          type: 'alert',
          content: t(MSG_CHAIN.INVALID_DATE_FORMAT, '__This is not a valid date format. {0}').replace(
            '{0}',
            `[${i + 1}] ${str(r.NEW_SHIPMENT_DATE)}`
          ),
        });
        return;
      }
    }
    // 검증 (AS-IS Validation_Check L777~809): 변경 행은 Change Reason 코드(≠''/'-') + Reason Detail 필수.
    for (let i = 0; i < src.length; i += 1) {
      const r = src[i];
      if (!isRequestRowChanged(r)) continue;
      const code = str(r.CHANGE_REASON_CODE).trim();
      const detail = str(r.CHANGE_REASON_DETAIL).trim();
      if (code === '' || code === '-' || detail === '') {
        void setAlert({
          type: 'alert',
          content: t(MSG.ROW_REASON_REQUIRED, {
            defaultValue: '_There is a shipment change in {0} row.\nPlease enter Change_Reason.',
          })
            .replace('{0}', String(i + 1))
            .replace(/\\r/g, '')
            .replace(/\\n/g, '\n'),
        });
        return;
      }
    }
    const payload = collectRequestConfirmSaveRows(src, session.userId ?? '');
    if (!payload) {
      setToast({ type: 'error', message: t(MSG.NO_MODIFICATION, '__No modifications have been made.') });
      return;
    }
    if (isPending || savingRef.current) return; // 연쇄 진행 중 재진입 차단
    savingRef.current = true;
    setSaving(true); // 팝업 Dim+버튼 잠금 ON
    try {
      await runSave(src);
    } finally {
      savingRef.current = false;
      setSaving(false); // 저장 완료/실패 후 해제
    }
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1280}
      // 기본 높이 — 미지정 시 CustomDialog 기본값 '50vh' 가 그리드 영역(460px)+툴바보다 짧아 처음 열면
      //   하단(가로 스크롤바)이 잘렸다(2026-10-22 사용자 신고). 콘텐츠(헤더+툴바+460 그리드+여백)에 맞춰
      //   고정 px 로 올린다 — 리사이즈는 그대로 가능.
      height={640}
      handleClose={modalClose}
      disableButtonCancel
      disableScale
      // 그리드 셀 콤보(Change Reason dataMap) 필수 — MUI FocusTrap(enforceFocus)이 다이얼로그 컨테이너
      //   밖에 append 되는 Wijmo 드롭다운 ListBox 로 나간 포커스를 즉시 되돌려, 항목을 클릭해도
      //   finishEditing 이 선택값을 버리고 리스트만 닫힌다(CustomDialog 상단 주석 L47~53, DMF0082 선례).
      //   이게 "콤보는 뜨는데 선택이 커밋 안 됨"의 실제 원인이었다(2026-10-22).
      disableEnforceFocus
      title={t(LBL.REQUEST, '_Shipment Request')}
      customContentArea={
        <Box sx={{ position: 'relative' }}>
          {/* 저장 중 팝업 Dim+클릭 차단(placement='parent' 백드롭이 부모 전체를 덮어 버튼 재클릭까지 막음) —
              하단 그리드만 Dim 되어 중복 클릭 가능하던 문제 해소(사용자 요청 2026-11-10, FcstUploadModal 패턴). */}
          <ProgressIndicator
            shape='circular'
            apprearance='infinite'
            open={saving || isPending}
            placement='parent'
          />
          <Stack direction='column' spacing={1}>
          {/* 상단 툴바 (AS-IS 캡처 1:1) — Auto Set · Change Reason* · Reason Detail* · Save · Cancel */}
          <Stack direction='row' justifyContent='flex-end' alignItems='center' spacing={1}>
            <Button appearance='outlined' priority='normal' disabled={saving} onClick={handleAutoSet}>
              Auto Set
            </Button>
            <FormItem
              label={`${t('LBL01060', '_Change Reason')}*`}
              labelAlign='right'
              render={() => (
                <Box sx={{ width: 200 }}>
                  <CustomDropdown
                    useClearIcon
                    value={autoReason}
                    options={reasonOptions}
                    onChange={(_, picked) => setAutoReason(str(picked))}
                  />
                </Box>
              )}
            />
            <FormItem
              label={`${t('LBL01104', '_Reason Detail')}*`}
              labelAlign='right'
              render={() => (
                <InputField value={autoDetail} onChange={e => setAutoDetail(e.target.value)} />
              )}
            />
            <Button
              appearance='contained'
              priority='primary'
              disabled={saving || isPending}
              onClick={() => void handleSave()}
            >
              {t(LBL.OK, '_Save')}
            </Button>
            <Button appearance='outlined' priority='normal' onClick={modalClose}>
              {t(LBL.CLOSE, '_Cancel')}
            </Button>
          </Stack>
          <Box sx={{ height: 460 }}>
            <DataGrid gridRef={gridRef} itemsSource={rows as unknown as WijmoRowItem[]} dynamicColumns={columns} />
          </Box>
          </Stack>
        </Box>
      }
    />
  );
};
