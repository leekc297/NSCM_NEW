import { DataType } from '@mescius/wijmo';
import { type CellRangeEventArgs, CellType, DataMap, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import { COMBO } from '../sales-site-priority.constants';
import type { SalesSitePriorityRow } from '../sales-site-priority.types';
import {
  filterSiteByDivision,
  findPlanGroupCodeByName,
  isPlanGroupCodeInCombo,
  toCascadeSource,
} from '../utils/sales-site-priority.cascadeCombo';
import { applyItemSelect, isCellEditable, isItemPopupCell, s } from '../utils/sales-site-priority.editLock';

interface Props {
  rows: SalesSitePriorityRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

// design 03 §1.1: 그리드 셀콤보 SQL_ID 리터럴 3종(PlanGroup/ScmSite/ValidYn)이 admin 메타
//   CELL_COMBO_DATA_TYPE 에 실려 있으면 공용 DataGrid 자동콤보 경로가 처리한다(§04 콤보_TO-BE.md §4).
//   OPMZ_PLAN_GR_ID(filterCalls#6)·SCM_SITE_ID 둘 다 division cascade PARAM2='DIVISION_ID:DIVISION_ID'
//   가 admin 메타(SCM_MST_SHEET_COLUMNS.ATTRIBUTE2)에 등록돼 있다(gap-resolve iter-1, ora.py 실측 확인).
export const SalesSitePriorityGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  onFocus,
}: Props) => {
  const [openItem, setOpenItem] = useState(false);
  const [clickedRow, setClickedRow] = useState<number>(-1);

  // Plan Group 붙여넣기 NAME->CODE 역변환용 원본(AS-IS dtPlanGroupAll, l1062). 조회조건과 별도로
  //   그리드 단독 fetch — 화면 전역 division 이 아니라 붙여넣기 대상 행의 DIVISION_ID 로 좁힌다.
  const [planGroupsRaw] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });
  const planGroupSource = useMemo(() => toCascadeSource(planGroupsRaw), [planGroupsRaw]);
  // 활성(콤보 등록=VALID_YN='Y') Plan Group 코드 집합 — 비활성 코드(예: PG0031/PG0004)를 표시·엑셀에서
  //   빈칸 처리하는 dataMap 패치의 판정 기준. updatedLayout 패치 클로저가 최신 집합을 읽도록 ref 로 든다.
  const planGroupActive = useMemo(
    () => new Set(planGroupSource.map(r => r.CODE)),
    [planGroupSource]
  );
  const planGroupActiveRef = useRef(planGroupActive);
  planGroupActiveRef.current = planGroupActive;

  // SCM site 셀콤보 원본(ScmSite, DIVISION_ID 반환) — 조회조건 Site 콤보와 동일 소스(getCombo 세션
  //   캐시 공유). admin 자동콤보 경로는 PARAM2='DIVISION_ID:DIVISION_ID' 로 행 DIVISION_ID 정확일치만
  //   좁혀, 가상 division 'EE'(및 EE_UC 등)가 실사이트 division(81/40/82·81_UC…)과 안 맞아 후보 0건이
  //   된다(AS-IS 와 불일치). AS-IS RefreshSiteByDivision(cs:254-268)은 EE->81/40/82 합집합, EE_xx->81_xx
  //   로 확장한 dtScmSite 를 리스트박스와 셀콤보(SetComBoParam "ScmSite", cs:306)에 공용으로 바인딩한다.
  //   편집 진입 시 행 DIVISION_ID 로 그 확장(filterSiteByDivision)을 재현한 dataMap 으로 스왑한다
  //   (형제 SCP0037 operation-lt 의 SCM_SITE_ID 편집/표시 이원화 패턴 동일).
  const [sitesRaw] = useTabComboQueries({ filters: [COMBO.SITE] });
  const siteSource = useMemo(() => toCascadeSource(sitesRaw), [sitesRaw]);
  const siteSourceRef = useRef(siteSource);
  siteSourceRef.current = siteSource;
  // 편집 진입 시 스왑하고 종료 시 되돌릴 admin 자동콤보 원본 dataMap(표시용 전체 매핑).
  const scmSiteOriginalMap = useRef<DataMap | null>(null);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 white-list — DIVISION_ID·감사4칸·PRE_KEY_VALUES 항상 잠금, ITEM_ID 는 인라인 입력 허용(AS-IS 동일).
    const beginningEditHandler = (
      sender: FlexGrid,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!isCellEditable(binding)) {
        e.cancel = true;
        return;
      }
      // SCM site 셀콤보 — 행 DIVISION_ID 로 좁힌 EE 확장 후보로 dataMap 스왑(위 siteSource 주석).
      //   admin 자동콤보 원본은 EE 행에서 후보 0건이라 드롭다운이 빈 채로 열린다 — filterSiteByDivision
      //   이 EE->81/40/82, EE_xx->81_xx 로 확장한 후보를 편집 전용 dataMap 으로 건다. 비-EE division 은
      //   정확일치와 동일 결과라 기존 동작 불변. 종료 시 cellEditEnded 가 원본 표시 매핑으로 되돌린다.
      if (binding === 'SCM_SITE_ID') {
        const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
        if (!row) return;
        const col = sender.columns[e.col];
        if (scmSiteOriginalMap.current === null) scmSiteOriginalMap.current = col.dataMap;
        const candidates = filterSiteByDivision(siteSourceRef.current, s(row.DIVISION_ID));
        col.dataMap = new DataMap(
          candidates.map(c => ({ CODE: c.CODE, NAME: c.NAME || c.CODE })),
          'CODE',
          'NAME'
        );
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // SCM site 편집 종료 -> admin 전체 표시 매핑으로 원복(편집/표시 이원화, 형제 SCP0037 동일).
    const cellEditEndedHandler = (sender: FlexGrid, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding === 'SCM_SITE_ID' && scmSiteOriginalMap.current !== null) {
        sender.columns[e.col].dataMap = scmSiteOriginalMap.current;
      }
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    // 레이아웃 재계산(컬럼 재생성)마다 재적용하는 보정 2종 — 공용 DataGrid 가 updatedLayout 에서
    //   컬럼/콤보 dataMap 을 재대입하므로 즉시 1회 + updatedLayout 핸들러로 건다.
    const applyLayoutFixes = () => {
      // No.9) FROM/TO 날짜 컬럼 dataType=Date + 'yyyy-MM-dd' — FPDate(InputDate 달력) 편집 성립 +
      //   빈 셀(신규행) 편집 시 직전 행 Date 가 에디터에 남아 새어드는 누수 차단(행을 Date 로 들어 빈값=
      //   ''(null 등가)이면 에디터가 비어 열린다). 형제 demand-exception/SCP0127/0128 동형.
      for (const binding of ['FROM_YYYYMMDD', 'TO_YYYYMMDD']) {
        const col = g.getColumn(binding);
        if (!col) continue;
        if (col.dataType !== DataType.Date) col.dataType = DataType.Date;
        if (col.format !== 'yyyy-MM-dd') col.format = 'yyyy-MM-dd';
        // Wijmo InputDate(col.editor) 의 isRequired 기본값(true)은 빈 셀 편집기에 null 대입을 거부해
        //   직전 행 날짜를 유지한다(새어듦). 편집기 인스턴스에 직접 false 를 박아 공유 columnMapping
        //   빌드 상태와 무관하게 확실히 적용한다(No.9, Column.isRequired 와는 별개 속성).
        const editor = col.editor as { isRequired?: boolean } | null | undefined;
        if (editor && editor.isRequired !== false) editor.isRequired = false;
      }
      // No.10) 비활성(콤보 미등록=VALID_YN='N', 예 PG0031/PG0004) Plan Group 코드는 셀 표시·엑셀
      //   다운로드 모두 빈칸 — AS-IS FarPoint 는 콤보 후보에 없는 값을 빈칸으로 그리고(formatItem 이
      //   그리드 DOM 은 이미 가린다), 엑셀 변환기는 dataMap.getDisplayValue 로 값을 뽑아 미등록 코드는
      //   원문(PG0031)을 그대로 내보낸다. dataMap 의 getDisplayValue 를 패치해 활성 집합 밖 코드는 ''
      //   을 돌려주면 그리드·엑셀(export 가 live col.dataMap 인스턴스를 그대로 스냅샷, gridAction
      //   collectLiveColumnExportMeta)이 함께 빈칸이 된다. 드롭다운 후보(getDisplayValues)는 패치하지
      //   않아 cascade 편집은 그대로다. applyComboDataMaps 가 매 재대입하는 새 dataMap 에 플래그로 1회씩 건다.
      const pgCol = g.getColumn('OPMZ_PLAN_GR_ID');
      const dm = pgCol?.dataMap as (DataMap & { __blankMiss?: boolean }) | null | undefined;
      if (dm && !dm.__blankMiss) {
        const orig = dm.getDisplayValue.bind(dm);
        dm.getDisplayValue = (key: unknown) =>
          planGroupActiveRef.current.has(s(key)) ? orig(key) : '';
        dm.__blankMiss = true;
      }
    };
    applyLayoutFixes();
    g.updatedLayout.addHandler(applyLayoutFixes);

    // PRIO_RANK 는 1 이상의 정수만 허용 — 편집 중 숫자(0~9) 이외의 문자는 셀에 남지 않게 막는다(AS-IS 등가).
    //   AS-IS 메타는 PRIO_RANK 가 FPNumber/DATA_SCALE_NUMBER=NULL 이고, FarPoint NumberCellType 은
    //   DecimalPlaces 미지정 시 기본 0 이라 소수·문자 입력이 애초에 안 된다(asis.py 실측). TO-BE 공통
    //   columnMapping 은 scale==null 이면 편집기를 안 붙여 소수·텍스트가 입력되므로(구조적 갭) 이 화면에서 막는다.
    //
    //   구현 주의(2026-11-10 dom_listeners 실측): Wijmo 기본 그리드 에디터(input.wj-grid-editor, type=tel)는
    //   keydown/keypress 단계에서 값을 직접 editor.value 에 써넣어 beforeinput.preventDefault 와 host keydown
    //   capture 를 모두 우회한다(Wijmo core 가 같은 요소에 더 먼저 등록된 capture keydown 다수를 가진다).
    //   그래서 '선제 차단'은 이 에디터에서 신뢰할 수 없다 — 대신 값이 반영된 직후 input 이벤트에서 숫자 외
    //   문자를 즉시 제거하는 sanitize 를 주력으로 쓴다. 동기 제거라 렌더 전에 값이 정리돼 화면에 글자가 남지
    //   않는다. 붙여넣기·IME 조합확정(insertFromPaste/insertCompositionText)도 같은 input 경로라 함께 걸린다.
    //   붙여넣기 Plan Group 변환 등 다른 경로는 저장검증(Number.isInteger, MSG01190)이 막는 이중 안전망.
    //
    //   자릿수 cap(15) — PRIO_RANK 는 number 셀('n0')이라 16자리 이상 입력하면 JS 수치가
    //   Number.MAX_SAFE_INTEGER(≈9e15)를 넘어 정밀도가 깨지고 1e21↑은 지수표기(1.23e+24)로 뭉개진다
    //   (화면 표시·저장값 손상). 15자리는 항상 안전정수라 그 손상을 막는다. AS-IS 자체엔 입력 자릿수
    //   제한이 없고 저장 시 Int32 초과를 OverflowException 으로 막지만(cs:675), 그 상한(2,147,483,647,
    //   10자리)은 15자리 어떤 값도 넘으므로 저장검증(MSG01036)이 그대로 걸러 AS-IS 저장 중단과 등가다.
    const PRIO_MAX_DIGITS = 15;
    const sanitizePrioInput = (ev: Event) => {
      const el = ev.target as HTMLInputElement;
      const cleaned = el.value.replace(/\D/g, '').slice(0, PRIO_MAX_DIGITS);
      if (cleaned === el.value) return;
      const caret = (el.selectionStart ?? el.value.length) - (el.value.length - cleaned.length);
      el.value = cleaned;
      const pos = Math.max(0, caret);
      el.setSelectionRange(pos, pos);
    };
    const prepareEditHandler = (_s: FlexGrid, e: CellRangeEventArgs) => {
      const binding = _s.columns[e.col]?.binding ?? '';
      // Plan Group 편집 진입 시 숨긴 코드(비활성 Plan Group) 노출 차단 — AS-IS FarPoint 등가.
      //   AS-IS ComboBoxCellType 은 EditorValue=ItemData 라 저장값이 콤보 후보(ItemData)에 없으면
      //   매칭 인덱스가 없어 에디터가 미선택(빈) 상태로 열린다(SpreadInfo.LoadCombo l6046~6067).
      //   반면 Wijmo 는 편집 진입 시 셀 원문(dataItem.OPMZ_PLAN_GR_ID=숨긴 코드 PG0004 등)을
      //   에디터 input 에 그대로 채워 코드가 노출된다. formatItem 으로 가린 셀과 같은 판정
      //   (isPlanGroupCodeInCombo)으로, 미매칭이면 에디터 초기값을 비워 AS-IS 처럼 빈 상태로 연다.
      //   값 자체(dataItem)는 건드리지 않으므로 사용자가 다른 코드를 고르지 않으면 원 저장값이 유지된다.
      if (binding === 'OPMZ_PLAN_GR_ID') {
        const row = _s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
        const editor = _s.activeEditor;
        if (
          row &&
          editor &&
          !isPlanGroupCodeInCombo(planGroupSource, s(row.DIVISION_ID), s(row.OPMZ_PLAN_GR_ID))
        ) {
          editor.value = '';
        }
        return;
      }
      // FROM/TO 날짜 편집기 — 빈 셀(신규행)을 열면 공유 InputDate 인스턴스가 직전 행의 Date 를 들고
      //   있어 입력 없이 Tab 해도 그 날짜가 새어든다(No.9). isRequired=true(Wijmo 기본)면 null 대입이
      //   거부되므로 먼저 false 로 열고, 셀값이 비어 있으면 편집기 값을 명시적으로 null 로 비운다
      //   (applyLayoutFixes 의 isRequired override 와 이중 안전망 — 실셀 편집 시점에 직접 clear).
      if (binding === 'FROM_YYYYMMDD' || binding === 'TO_YYYYMMDD') {
        const row = _s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
        const dateEditor = _s.getColumn(binding)?.editor as
          | { isRequired?: boolean; value?: unknown }
          | null
          | undefined;
        if (dateEditor) {
          dateEditor.isRequired = false;
          const cur = row?.[binding];
          if (cur === '' || cur === null || cur === undefined) dateEditor.value = null;
        }
        return;
      }
      if (binding !== 'PRIO_RANK') return;
      const el = _s.activeEditor;
      if (!el) return;
      // 같은 editor input 이 재사용되며 같은 함수 참조라 브라우저가 중복 등록을 제거 — 리스너가 쌓이지 않는다.
      el.addEventListener('input', sanitizePrioInput);
    };
    g.prepareCellForEdit.addHandler(prepareEditHandler);

    // 붙여넣기 Plan Group 표시명(NAME) -> 코드(CODE) 변환(AS-IS SpdMain_ClipboardPasted l1050~1070,
    //   validations#10~#12/events#5 — 원본 확인 결과 붙여넣기 이벤트가 하는 일은 이 변환뿐이다.
    //   From/To 검증은 붙여넣기 경로에 없다, __asis-mapping__.md 갱신).
    const pastedCellHandler = (sender: FlexGrid, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const pastedName = s(row.OPMZ_PLAN_GR_ID);
      if (!pastedName) return;
      const matchedCode = findPlanGroupCodeByName(planGroupSource, s(row.DIVISION_ID), pastedName);
      if (matchedCode !== undefined) {
        row.OPMZ_PLAN_GR_ID = matchedCode;
        GridUtils.refreshRow(sender, e.row);
      }
    };
    g.pastedCell.addHandler(pastedCellHandler);

    // Plan Group 셀 표시 등가(AS-IS FarPoint ComboBoxCellType) — 셀 저장값이 그 행 DIVISION_ID 로
    //   좁힌 활성 콤보 후보에 없으면 빈칸으로 그린다. DataMap.getDisplayValue 가 미매칭 코드를 원문
    //   그대로 돌려 비활성(VALID_YN='N') Plan Group 코드가 노출되는 것을 이 화면 한정으로 가린다
    //   (isPlanGroupCodeInCombo). 데이터(dataItem.OPMZ_PLAN_GR_ID)는 건드리지 않고 셀 텍스트만 비운다.
    //
    //   주의: 편집 진입(더블클릭 등) 시점에도 formatItem 이 같은 셀로 다시 불린다. 그때 cell DOM 을
    //   비우면 Wijmo 가 그 셀에 붙이는 콤보 에디터까지 날려 드롭다운이 안 열린다(회귀). editRange 가
    //   이 셀을 가리키면(=지금 편집 중) 표시를 건드리지 않고 에디터를 그대로 둔다 — AS-IS 도 빈칸 셀을
    //   클릭하면 콤보가 정상 펼쳐진다(SetComboDataRow, 저장값이 리스트에 없으면 미선택 상태로 열림).
    const formatItemHandler = (
      _s: FlexGrid,
      e: { panel: { cellType: CellType }; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel.cellType !== CellType.Cell) return;
      if (_s.columns[e.col]?.binding !== 'OPMZ_PLAN_GR_ID') return;
      if (_s.editRange?.contains(e.row, e.col)) return; // 편집 중 셀은 에디터 보존
      const row = _s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      if (!isPlanGroupCodeInCombo(planGroupSource, s(row.DIVISION_ID), s(row.OPMZ_PLAN_GR_ID))) {
        e.cell.textContent = '';
        e.cell.title = ''; // 셀 텍스트와 함께 코드가 툴팁(title)으로 새는 것도 막는다.
      }
    };
    g.formatItem.addHandler(formatItemHandler);

    // ITEM_ID 셀 더블클릭 -> MaterialByDivisionModal(design 02 §4.6, gridSignals#13).
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (!isItemPopupCell(binding)) return;
      setClickedRow(ht.row);
      setOpenItem(true);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.updatedLayout?.removeHandler(applyLayoutFixes);
        g.pastedCell?.removeHandler(pastedCellHandler);
        g.prepareCellForEdit?.removeHandler(prepareEditHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns, planGroupSource]);

  return (
    <>
      <DataGrid<SalesSitePriorityRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={rows as unknown as WijmoRowItem[]}
        staticColumns={adminColumns ?? []}
        // SCM_SITE_ID 그리드 셀 콤보는 admin 메타 CELL_COMBO_DATA_TYPE='ScmSite'(AS-IS SCP0128 포팅,
        //   SALES+PLANT, DIVISION_ID 반환)를 쓰며 division 좁힘은 ATTRIBUTE2 PARAM2='DIVISION_ID:DIVISION_ID'
        //   cascade 가 행별 DIVISION_ID 로 처리한다. ScmSite 는 @siteType 를 받지 않으므로 이전 comboParams
        //   siteType='SALES' 는 무효 no-op(그리드가 SiteMasterAll_SCP 를 쓴다는 스테일 가정의 잔재)이라 제거.
        gotFocus={onFocus}
      />
      {/* 그리드 셀 Item 팝업 — MaterialByDivisionModal(COM0013), 조회영역과 동일 팝업 재사용(design 02 §4.6). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          const row = GridUtils.getRow(gridRef.current, clickedRow) as
            | Record<string, unknown>
            | undefined;
          if (!row) return;
          applyItemSelect(row, items);
          GridUtils.refreshRow(gridRef.current, clickedRow);
        }}
        preSearchParams={{
          divisionId: s(
            (GridUtils.getRow(gridRef.current, clickedRow) as Record<string, unknown> | undefined)
              ?.DIVISION_ID
          ),
          itemId: '',
        }}
      />
    </>
  );
};
