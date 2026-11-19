// Input All 팝업(AS-IS SCM0002_ProjectRouteListSavePopup) — Division 기준 후보 Model×Item 목록을
//   조회해 Plant Site/Valid/Priority/FROM/TO 를 일괄 입력·저장한다.
//   AS-IS 원본: GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ProjectRouteListSavePopup.cs(1413줄, 전체
//   정독) + .Designer.cs. 이 파일의 동작(검색조건/그리드 컬럼/행 캐스케이딩/검증 순서/저장 SP)은
//   전부 그 소스 실측 기반이다 — 추정 없음.
//
// admin 등록 상태: 완료(project-route-list-save-modal.constants.ts 헤더 주석 참고, 2026-09-22
//   ora.py 재실측 + 로컬 BE 실 HTTP 왕복으로 Find 정상 동작 실증). Save 는 SCP0006 본 화면과
//   동일 SP 재사용이라 별도 등록 불요.
import { CellType, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, safeString } from '@foundation/utils';
import {
  CustomDialog,
  CustomDropdown,
  DataGrid,
  ResultArea,
  SearchArea,
} from '@shared/components';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { useProjectRouteValidation } from '../../hooks/useProjectRouteValidation';
import { MSG } from '../../project-route.constants';
import type { PlantRow } from '../../project-route.types';
import { deriveOrgDates, syncOrgDates } from '../../utils/projectRoute.plantDerive';
import { submitPlantSaveRequest, type PlantSaveRow } from '../../utils/projectRoute.plantSaveRequest';

import {
  buildProjectRouteListSaveColumns,
  DefColumns,
  DEFAULT_TIME_ZONE,
  LBL,
  MENU_ID_INPUT_ALL_POPUP,
  MSG_CONFIRM_SAVE,
  MSG_NO_CHECKED_ROWS,
  MSG_NO_ROWS,
  MSG_REQUIRED_FIELD,
  PROJECT_ROUTE_LIST_SAVE_MSG_IDS,
  REQUIRED_FIELD_CHECKS,
} from './project-route-list-save-modal.constants';
import styles from './ProjectRouteListSaveModal.module.scss';

// AS-IS DataRow 는 느슨한 딕셔너리다 — 이 화면 그리드는 WijmoRowItem(Record<string,WijmoPrimitive>)
//   을 그대로 쓴다(admin 메타 미등록, procedures.d.ts 에 아직 이 화면 항목이 없어 ResponseData<>
//   를 못 쓴다 — 등록 후 교체 대상). 필드명 참고용 타입은 아래 ProjectRouteListSaveFields(그리드
//   제네릭에는 쓰지 않음, record 캐스팅 시 필드명 자동완성 용도).
export type ProjectRouteListSaveRow = WijmoRowItem;

export interface ProjectRouteListSaveFields {
  DIVISION_ID?: string;
  SCM_SITE_ID?: string;
  SCM_SITE_NAME?: string;
  PROJECT_CODE?: string;
  MODEL_ID?: string;
  NICK_NAME?: string;
  OPERATION_GROUP_ID?: string;
  OPERATION_GROUP?: string;
  ITEM_ID?: string;
  ITEM_NAME?: string;
  PLANT_SITE_ID?: string;
  VALID_YN?: string;
  PRIORITY?: number;
  FROM_YYYYMMDD?: string;
  TO_YYYYMMDD?: string;
  CREATED_BY?: string;
  CREATION_DATE?: string;
  LAST_UPDATED_BY?: string;
  LAST_UPDATE_DATE?: string;
  ORG_FROM_YYYYMMDD?: string;
  ORG_TO_YYYYMMDD?: string;
}

interface Props {
  open: boolean;
  onClose: () => void;
  divisionId: string;
  /** Division 콤보 NAME(부모 화면의 `divisions` 조회 결과에서 divisionId 로 찾은 값) — 코드만 아니라
   *  "40 Mobility & IT Battery" 처럼 AS-IS Form_Load(division) 가 보여주는 라벨을 그대로 재현한다.
   *  못 찾으면 divisionId 코드로 폴백. */
  divisionName?: string;
  /** 저장 성공(AS-IS saveSucs=true) 시 호출 — 부모화면이 현재 조회조건으로 재조회한다(design/02 §5). */
  onSaved: () => void;
}

export const ProjectRouteListSaveModal = ({
  open,
  onClose,
  divisionId,
  divisionName,
  onSaved,
}: Props) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore.getState();
  const sessionUserId = useSessionStore(s => s.session.userId);
  const { validatePlantSave } = useProjectRouteValidation();

  const gridRef = useRef<FlexGrid<ProjectRouteListSaveRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ProjectRouteListSaveRow>>();

  const [modelId, setModelId] = useState('');
  const [itemId, setItemId] = useState('');
  const [rows, setRows] = useState<ProjectRouteListSaveRow[]>([]);
  const [loading, setLoading] = useState(false);
  // 저장검증(N1~N9) 비교 베이스 — AS-IS dsFullBinding(조회 SP O_RC2 '전체 route'). 해당 Div 의 기존
  //   VALID_YN='Y' Plant 일정 전부다. AS-IS SaveData(L349)는 이 전체 일정을 복사한 데이터셋에 체크한
  //   신규 행을 더해 N1~N9 를 돌린다 — 기존 일정과의 기간 중첩/중복까지 잡기 위함. 그리드(rows,
  //   O_RC1=입력후보)만으로 검증하면 기존 일정과의 N5 중첩 등을 놓친다(2026-11-18 실측 버그). 저장
  //   payload 에는 쓰지 않는다(검증 비교용 배경 데이터).
  const fullRouteRef = useRef<ProjectRouteListSaveRow[]>([]);

  const staticColumns = useMemo(() => buildProjectRouteListSaveColumns(divisionId), [divisionId]);

  // FindData(L298-333) — division/modelId/itemId 로 후보 목록 재조회(admin 등록 완료, 위 헤더 참고).
  const fetchList = async () => {
    setLoading(true);
    try {
      const res = await apiClient.post<{
        o_rc1?: ProjectRouteListSaveRow[];
        o_rc2?: ProjectRouteListSaveRow[];
      }>(
        `/${MENU_ID_INPUT_ALL_POPUP}/mainList/SEARCH/call-proc`,
        { divisionId, modelId, itemId, timeZone: DEFAULT_TIME_ZONE }
      );
      setRows(res.data?.result?.o_rc1 ?? []);
      // O_RC2 = 기존 전체 route 일정(검증 비교 베이스, AS-IS dsFullBinding). 저장검증에서만 사용.
      fullRouteRef.current = res.data?.result?.o_rc2 ?? [];
    } catch {
      setRows([]);
      fullRouteRef.current = [];
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (!open) return;
    setModelId('');
    setItemId('');
    setRows([]);
    void fetchList();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // spdMain_Change(L625-644) + SpdMain_ComboSelChange(L533-547) — PLANT_SITE_ID 입력/삭제에 따라
  //   해당 행 체크 자동 on/off. FROM/TO 변경 시 ORG_FROM/ORG_TO 파생(R-ORG, SetOrgData L647-663 대응,
  //   SCP0006 본 그리드 deriveOrgDates 재사용).
  const handleCellEdit = (grid: FlexGrid<ProjectRouteListSaveRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!binding || !dataItem) return;
    const record = dataItem as Record<string, unknown>;

    if (binding === DefColumns.PLANT_SITE_ID) {
      const filled = !!safeString(record[DefColumns.PLANT_SITE_ID]);
      const row = grid.rows[e.row];
      if (row) row.isSelected = filled;
    }

    if (binding === DefColumns.FROM_YYYYMMDD || binding === DefColumns.TO_YYYYMMDD) {
      const derived = deriveOrgDates(record.FROM_YYYYMMDD, record.TO_YYYYMMDD);
      (Object.keys(derived) as (keyof typeof derived)[]).forEach(col => {
        editTrackerRef.current?.storeChange(dataItem, col, record[col] as string, derived[col]);
        record[col] = derived[col];
      });
      GridUtils.refreshRow(grid, e.row);
    }
  };

  // SpdMain_CellClick(L549-623) 중 CHK(=Selector RowHeader) 클릭 분기 — 바로 윗행이 이미 체크·
  //   PLANT_SITE_ID 입력완료 상태이고 같은 OPERATION_GROUP_ID 면 그 값을 그대로 복사(반복입력
  //   단축 UX). 확인 필요: Wijmo Selector 의 체크 반영 순서상 클릭 직후 시점 값 재확인 필요
  //   (브라우저 실동작 검증 대상 — 이 세션은 코드 작성까지, §Context 정직 고지).
  // Delete/Backspace 로 셀을 비울 때, 이 팝업 그리드는 useCheckbox 라 DataGrid 가
  //   SelectionMode.MultiRange 를 강제한다(범위 드래그 선택 복원 목적). 그 결과 셀을 돌아다니며
  //   편집하면 grid.selectedRanges 에 여러 셀이 **분리된 range 로 누적**되고, wijmo 네이티브 Delete 는
  //   활성 range(grid.selection) 가 아니라 selectedRanges 전체를 비운다 — 활성셀 하나만 선택한 것처럼
  //   보여도 같은 행의 Valid/Priority 까지 통째로 날아간다(2026-11-18 실측: selection rowSpan=colSpan=1
  //   인데 PLANT_SITE_ID/VALID_YN/PRIORITY 3셀 동시 커밋). grid.selection 만 좁혀선 selectedRanges 의
  //   나머지 range 가 남아 소용없다. AS-IS FarPoint 단일 활성셀 Delete 와 등가로, 활성 셀 하나만
  //   비우고 wijmo 기본 처리를 막는다(preventDefault). 명시적 범위 삭제가 필요 없는 일괄입력 팝업이라
  //   이 화면에 한정해 가드한다.
  const handleGridInitialized = (grid: FlexGrid<ProjectRouteListSaveRow>) => {
    grid.hostElement?.addEventListener(
      'keydown',
      event => {
        if (event.key !== 'Delete' && event.key !== 'Backspace') return;
        if (grid.isReadOnly || grid.activeEditor) return;
        const sel = grid.selection;
        const col = grid.columns[sel.col];
        if (!col || col.isReadOnly || sel.row < 0 || sel.col < 0) return;
        const row = GridUtils.getRow(grid, sel.row) as Record<string, unknown> | undefined;
        if (!row) return;
        const binding = col.binding;
        if (!binding) return;
        // 활성 셀 하나만 비운다. editTracker 의 cellEditEnded 자동 기록을 타도록 setCellData 대신
        //   값 치환 + refreshRow, 변경 기록은 storeChange 로 남긴다(cell-changed/저장 반영).
        const prev = row[binding];
        if (prev === null || prev === '' || prev === undefined) {
          event.preventDefault();
          event.stopImmediatePropagation();
          return;
        }
        editTrackerRef.current?.storeChange(row as ProjectRouteListSaveRow, binding, prev as string, '');
        row[binding] = '';
        // handleCellEdit 의 입력완료 후처리와 등가로 맞춘다 — PLANT_SITE_ID 는 체크 해제,
        //   FROM/TO 는 ORG 파생 재계산(비운 값 기준).
        if (binding === DefColumns.PLANT_SITE_ID) {
          const gridRow = grid.rows[sel.row];
          if (gridRow) gridRow.isSelected = false;
        }
        if (binding === DefColumns.FROM_YYYYMMDD || binding === DefColumns.TO_YYYYMMDD) {
          const derived = deriveOrgDates(row.FROM_YYYYMMDD, row.TO_YYYYMMDD);
          (Object.keys(derived) as (keyof typeof derived)[]).forEach(dcol => {
            editTrackerRef.current?.storeChange(
              row as ProjectRouteListSaveRow,
              dcol,
              row[dcol] as string,
              derived[dcol]
            );
            row[dcol] = derived[dcol];
          });
        }
        GridUtils.refreshRow(grid, sel.row);
        event.preventDefault();
        event.stopImmediatePropagation();
      },
      true
    );
  };

  const handleGridClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.RowHeader || ht.row <= 0) return;

    const currentItem = GridUtils.getRow(grid, ht.row);
    const prevRow = grid.rows[ht.row - 1];
    const prev = prevRow?.dataItem as ProjectRouteListSaveFields | undefined;
    if (!currentItem || !prev) return;
    const current = currentItem as ProjectRouteListSaveFields;

    // click 이벤트는 Wijmo Selector 가 isSelected 를 토글한 "후" 발생한다 → isSelected 가 곧 결과 상태.
    //   체크하는 순간(isSelected=true)에만 복사한다. 종전 `!isSelected` 는 반전이라 체크-해제 시 복사되는
    //   오동작(AS-IS bCheck 는 "체크로 바뀌는 중" 의미) — 토글 후 값 그대로가 bCheck 와 동치.
    const willCheck = !!grid.rows[ht.row]?.isSelected;
    if (!willCheck) return;
    if (!prevRow?.isSelected) return;
    if (current.PLANT_SITE_ID) return; // 이미 값 있으면 덮어쓰지 않음
    if (!prev.PLANT_SITE_ID) return;
    if (current.OPERATION_GROUP_ID !== prev.OPERATION_GROUP_ID) return;

    const record = currentItem as Record<string, unknown>;
    editTrackerRef.current?.storeChange(
      currentItem,
      'PLANT_SITE_ID',
      record.PLANT_SITE_ID as string,
      prev.PLANT_SITE_ID
    );
    record.PLANT_SITE_ID = prev.PLANT_SITE_ID;
    GridUtils.refreshRow(grid, ht.row);
  };

  // Save(L335-521) — 0건/미체크/필수값/confirm/N1~N9 순서 그대로.
  const handleSave = async () => {
    const grid = gridRef.current;
    if (!grid) return;
    grid.finishEditing();

    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG_NO_ROWS, '_저장할 대상이 없습니다.') });
      return;
    }

    const checked: ProjectRouteListSaveRow[] = [];
    for (let i = 0; i < grid.rows.length; i++) {
      if (grid.rows[i]?.isSelected) checked.push(grid.rows[i].dataItem as ProjectRouteListSaveRow);
    }
    if (checked.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG_NO_CHECKED_ROWS, '_체크된 행이 없습니다.'),
      });
      return;
    }

    // chk_ValidDataSet(L687-721) — 체크 행 필수값.
    for (const row of checked) {
      const missing = REQUIRED_FIELD_CHECKS.find(f => !safeString(row[f.column]));
      if (missing) {
        // MSG00429 등록 문구가 '{0}' 그대로라 치환 필요(forecast-price ExchangeRateModal.tsx 동일 패턴).
        void setAlert({
          type: 'alert',
          content: t(MSG_REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', missing.label),
        });
        return;
      }
    }

    // 주의(2026-11-18 교정): AS-IS SaveData(L335-401)는 "저장하시겠습니까?" 확인을 주석-out(L339)하고
    //   곧바로 필수값(L361) → N1~N9(L393-401) 검증을 돌려 전부 통과한 뒤에만 저장한다 — 검증이 확인보다
    //   먼저다. 종전 TO-BE 는 확인 다이얼로그를 검증보다 앞에 둬, 중첩기간이 있어도 "저장하시겠습니까"가
    //   먼저 떠서 검증이 없는 것처럼 보였다(사용자 실측 버그). 검증을 확인 앞으로 되돌려 AS-IS 파리티 복원.

    // 검증 직전 ORG_*/MERGE_DATE 를 현재 화면값으로 재동기화 — 붙여넣기/채우기 편집 시 cellEditEnded
    //   미발생으로 ORG 가 stale 해져 N1 오탐하는 것 방지(본 그리드와 동일 보강, syncOrgDates 주석 참고).
    syncOrgDates(checked);
    // N1~N9(팝업 전용 MSG 세트, SCP0006 본 그리드와 규칙 공유) — useProjectRouteValidation 재사용.
    //   주의: AS-IS SaveData(L349)는 dsFullBinding(기존 전체 일정 O_RC2) 복사본에 체크한 신규 행을 더해
    //   N1~N9 를 돌리되, 바깥 루프를 신규/수정행(action=I/M/D)으로만 제한해 "신규 행이 기존/다른 일정과
    //   겹치는가"를 본다(기존끼리는 검사 안 함). 공유 훅 validatePlantSave 에 baseRows(=fullRouteRef)를
    //   넘기면 체크 행만 위반 '주체'가 되고 기존 전체 일정은 비교 대상에만 들어가 AS-IS 와 1:1 등가다
    //   (N1~N6·N9 기존 일정 중첩/중복/연속성까지 포함, 2026-11-18 실측 버그 교정). baseRows 미전달 본
    //   화면은 종전 동작 유지(전행이 주체).
    const v = validatePlantSave(
      checked as unknown as PlantRow[],
      PROJECT_ROUTE_LIST_SAVE_MSG_IDS,
      fullRouteRef.current as unknown as PlantRow[]
    );
    if (!v.ok) {
      void setAlert({ type: 'alert', content: t(v.msgId ?? MSG.SAVE_ERROR, '_저장 검증 실패') });
      return;
    }

    // 검증을 전부 통과한 뒤에만 저장 확인(AS-IS 는 확인 자체가 없으나, TO-BE 저장 화면 관행대로 확인은 유지).
    const confirmed = await setAlert({
      type: 'confirm',
      content: t(MSG_CONFIRM_SAVE, '_저장하시겠습니까?'),
    });
    if (!confirmed) return;

    // 팝업은 항상 신규 삽입(AS-IS action = CAppSetting.FlagI 고정, L437) — CRUD_TYPE 'I' 로 통일.
    const toSave = checked.map(row => ({ ...row, CRUD_TYPE: 'I' })) as unknown as PlantSaveRow[];
    const result = await submitPlantSaveRequest(toSave, sessionUserId ?? '');
    if (!result.ok) {
      void setAlert({ type: 'alert', content: result.message ?? t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.') });
      return;
    }

    void setToast({ type: 'success', message: t(MSG.SAVE_RESULT, '_저장되었습니다.') });
    onSaved();
    void fetchList(); // AS-IS SaveData 성공 시 FindData() 재조회(L503)
  };

  return (
    <CustomDialog
      size={1200}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* AS-IS 창 제목(Designer.cs this.Text) — 버튼 캡션(LBL.INPUT_ALL='Input All')과는 별개.
              등록된 LBL ID 미확인이라 Save/Cancel 버튼과 동일하게 하드코딩(오등록 재방지). */}
          <h2 className='headerTitle'>Project Route List For Save</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={() => void fetchList()}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00001', '_Div.')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        disabled
                        value={divisionId}
                        options={[{ label: divisionName || divisionId, value: divisionId }]}
                      />
                    )}
                  />
                </Grid>
                {/* AS-IS txtModelId/txtItemId(Designer.cs) 는 별도 캡션 없는 텍스트박스 — 라벨은
                    화면 캡션(Model/Item Code, Designer.cs lblModel/lblItemId.Text) 그대로. 등록된
                    LBL ID 가 확인되지 않아(오등록 재발 방지, project-route.constants.ts LBL 참고)
                    하드코딩한다. */}
                <Grid size={4}>
                  <FormItem
                    label='Model'
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={modelId}
                        onChange={e => setModelId(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && void fetchList()}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label='Item Code'
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={itemId}
                        onChange={e => setItemId(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && void fetchList()}
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
              <DataGrid<ProjectRouteListSaveRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                editTrackerRef={editTrackerRef}
                itemsSource={rows}
                staticColumns={staticColumns}
                useCheckbox
                initialized={handleGridInitialized}
                cellEditEnded={handleCellEdit}
                click={handleGridClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            {/* AS-IS btnButtonList(Save/Cancel) — 등록된 LBL ID 미확인(오등록 재방지), 하드코딩
                유지(ItemByDivisionModal OK/Close 버튼과 동일 관례). */}
            <Button appearance='contained' priority='primary' size='medium' buttonLabel='Save' onClick={() => void handleSave()} />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Cancel' onClick={onClose} />
          </div>
        </div>
      }
    />
  );
};
