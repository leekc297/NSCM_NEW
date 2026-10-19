import {
  ArrowCondensedIcon,
  ControlAddIcon,
  ControlRefreshIcon,
  EditDeleteIcon,
  ListFunnelIcon,
  ListTodoIcon,
  FileExceluploadIcon,
  FileExceldownloadIcon,
  FunctionSearchIcon,
} from '@lges/design-system/icon';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { memo, type RefObject, useContext, useEffect, useRef } from 'react';

import { IcSave } from '@foundation/assets';
import { type HotkeyConfig, Hotkeys } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { useFilteredGridCount } from '@shared/hooks';
import type { ButtonProps } from '@shared/lges';
import { Button, TitleArea, Tooltip } from '@shared/lges';
import {
  confirmIfDirtyKey,
  DialogScopeContext,
  scopeDirtyKey,
  tabDirtyKey,
  registerViewActions,
  unregisterViewActions,
  useDialogStore,
  useMessageStore,
  useMotherStore,
  useTabid,
  useUIStore,
} from '@shared/stores';

// Atlas 브리지 노출 게이트 — dev 또는 VITE_ATLAS_BRIDGE 플래그일 때만 액션을 registry 에 등록.
// (운영에서는 registry 등록 자체를 하지 않아 자동화 표면이 노출되지 않는다)
const BRIDGE_ENABLED = import.meta.env.DEV || import.meta.env.VITE_ATLAS_BRIDGE === 'true';

const isHotKeyName = (key: string): key is keyof typeof Hotkeys => {
  return key in Hotkeys;
};

// @lges/design-system 의 SubTitleDepthType 과 동일하나 @shared/lges 에서 re-export 되지 않아 로컬 정의.
type SubTitleDepthType = 'h3' | 'h4' | 'h5';

type CustomButtonProps = ButtonProps & {
  label: string;
  action: () => void;
};

interface SubTitleProps {
  menuId: string;
  grid: RefObject<FlexGrid | undefined>;
  gridFilter: RefObject<FlexGridFilter | undefined>;
  dataCount: number;
  /**
   * 툴바 왼쪽에 표시할 영역 제목. 지정하면 이 줄이 곧 그리드의 제목 줄이 되므로,
   * 화면이 그리드 위에 따로 TitleArea 를 두지 않아도 된다(제목/건수/버튼 한 줄).
   * 미지정(기본 '')이면 종전과 동일하게 제목 없는 툴바 줄.
   */
  title?: string;
  /** title 지정 시 제목 depth. 미지정이면 TitleArea 기본값. */
  depth?: SubTitleDepthType;
  /**
   * 건수 표시(그리드 필터 반영) 기준 그리드. 미지정이면 grid.
   * 그리드가 여럿이라 grid 가 포커스에 따라 바뀌는 화면에서, 제목 줄의 건수만 특정
   * 그리드에 고정하고 싶을 때 지정한다(툴바 동작 대상은 그대로 grid).
   */
  countGrid?: RefObject<FlexGrid | undefined>;
  /**
   * true 면 건수 배지를 숨긴다. 화면에 그리드가 여럿이고 각 그리드 제목 줄에서
   * 개별 건수를 이미 표시하는 경우, 이 상단 툴바 줄의 건수 배지가 특정 그리드를
   * 가리키는지 모호해지므로 숨긴다(툴바 동작 자체는 grid 대상 그대로 유지).
   */
  hideTotalCases?: boolean;
  excelFileName?: string;
  useHotkey?: boolean;
  visible?: boolean;
  hotkeyConfig?: HotkeyConfig;
  searchParam?: Record<keyof object, string>;
  customButtons?: CustomButtonProps[];
  searchAction?: () => void;
}

const SubTitleComp = ({
  menuId,
  grid,
  gridFilter,
  dataCount,
  title = '',
  depth,
  countGrid,
  hideTotalCases = false,
  excelFileName,
  useHotkey = true,
  visible = true,
  hotkeyConfig,
  searchParam,
  customButtons,
  searchAction,
}: SubTitleProps) => {
  const { t } = useTranslation();
  // 이 SubTitle이 속한 단축키 스코프. 다이얼로그 안이면 그 스코프 id, 페이지 최상위면 null(root).
  const scopeId = useContext(DialogScopeContext);
  const setAlert = useMessageStore.getState().setAlert;
  const setProgress = useUIStore.getState().setProgress;
  const tabId = useTabid();
  const resetSearchCondition = useMotherStore().resetSearchCondition;

  // 건수 기준 그리드 — 미지정이면 툴바 대상 그리드와 동일(종전 동작).
  const countGridRef = countGrid ?? grid;

  // 필터 적용 시 collectionView 기준 필터된 건수, 미적용 시 dataCount 그대로 반환.
  const totalCasesValue = useFilteredGridCount(countGridRef, gridFilter, dataCount);
  const displayTotalCases = hideTotalCases ? undefined : totalCasesValue;

  const DefaultButtonActions: HotkeyConfig = {
    [Hotkeys.F1]: () => GridAction.getManual(menuId),
    [Hotkeys.F2]: () => console.error('F2 clicked'),
    [Hotkeys.F3]: () => grid.current && GridAction.toggleColumnSort(grid.current),
    [Hotkeys.F4]: () =>
      grid.current &&
      gridFilter.current &&
      GridAction.toggleColumnFilter(grid.current, gridFilter.current),
    //[Hotkeys.F5]: () => alert('검색은 화면별로 구현하세요.'),
    // F5 는 앱 전역 조회 단축키(브라우저 새로고침 아님) — 화면이 search 를 구현하지 않았으면
    // 아무 동작도 하지 않는다. (개발자 플레이스홀더 alert 가 사용자에게 노출되던 것 제거)
    [Hotkeys.F5]: () => undefined,
    [Hotkeys.F6]: () =>
      searchParam &&
      void GridAction.personalizeCondition(menuId, searchParam)
        .then(() =>
          setAlert({
            type: 'alert',
            content: t('MSG00010', '_조회 조건이 저장되었습니다.'),
          })
        )
        // ⚠️ 실패(예: BE 400/500)를 조용히 삼키지 않고 표시 — 저장 실패 무피드백 방지(2026-07-01).
        .catch(() =>
          setAlert({
            type: 'alert',
            content: t('MSG00011', '_조회 조건 저장에 실패했습니다.'),
          })
        ),
    //[Hotkeys.F7]: () => alert('저장은 화면별로 구현하세요.'),
    [Hotkeys.F7]: () => undefined, // save 미구현 화면 — no-op (F5 와 동일한 이유)
    // 주의: addRow 의 반환값(신규행)을 그대로 돌려주지 말 것. grid prop 이 FlexGrid<any> 라
    //   제네릭 T 가 any 로 추론되고, 핸들러 계약(HotkeyConfig = () => void)상 버려질 값이
    //   any 로 새어 no-unsafe-return 이 걸린다.
    [Hotkeys.F8]: () => {
      if (grid.current) GridAction.addRow(grid.current, {});
    },
    [Hotkeys.F9]: () =>
      new Proxy(() => grid.current && GridAction.removeRow(grid.current), {
        apply: target => {
          const result = target();
          if (!result)
            void setAlert({
              type: 'alert',
              content: t('MSG00014', '_No selection'),
            });
        },
      })(),
    [Hotkeys.F10]: () => {
      void (async () => {
        if (
          await setAlert({
            type: 'confirm',
            content: t('MSG00009', '_저장된 검색조건을 초기화 하겠습니까?'),
          })
        )
          await GridAction.resetPersonalizedCondition(menuId).then(() => {
            void setAlert({
              type: 'alert',
              content: t('MSG00011', '_검색조건이 초기화 되었습니다.'),
            });
            //if (storageReset) storageReset();
            resetSearchCondition(tabId);
          });
      })();
    },
    [Hotkeys._Excel]: () =>
      grid.current &&
      void GridAction.excelDownload(grid.current, excelFileName ?? 'Excel File', setProgress),
  };

  const buttonActions = { ...DefaultButtonActions, ...hotkeyConfig };
  if (searchAction) buttonActions[Hotkeys.F5] = searchAction;

  // 조회(F5/Search 버튼) 미저장 변경 가드 — 조회는 그리드 데이터를 통째로 덮어쓰므로
  //   dirty 면 confirm 후 실행한다. 화면이 주입한 search 액션을 여기서 공통으로 감싼다
  //   (화면 코드 무수정). 다이얼로그 안 SubTitle 은 그 다이얼로그의 그리드만 검사한다.
  const dirtyKey = scopeId === null ? tabDirtyKey(tabId) : scopeDirtyKey(scopeId);
  const rawSearch = buttonActions[Hotkeys.F5];
  if (typeof rawSearch === 'function' && rawSearch !== DefaultButtonActions[Hotkeys.F5]) {
    buttonActions[Hotkeys.F5] = () => {
      void confirmIfDirtyKey(dirtyKey, 'search').then(ok => {
        if (ok) rawSearch();
      });
    };
  }

  // 편집형 저장/행조작 공통 커밋 가드 — F7(저장)/F8(삽입)/F9(삭제)을 단축키로 누르면 편집 중이던
  //   셀 에디터가 열린 채라 cellEditEnded 가 아직 안 떠 변경이 커밋되지 않는다(EditTracker 미기록).
  //   그대로 저장하면 수집 대상이 0건이 되어 "수정한 내용이 없습니다" 로 빠진다. 버튼 클릭은
  //   포커스 상실로 Wijmo 가 자동 커밋하지만 단축키 경로는 아니다. 버튼/단축키가 같은 buttonActions
  //   를 공유하므로 여기서 한 번 감싸면 양쪽 모두, 모든 편집형 화면이 편집을 커밋한 뒤 실행된다.
  const wrapWithEditCommit = (raw: false | (() => void) | undefined): false | (() => void) => {
    if (typeof raw !== 'function') return raw ?? false;
    return () => {
      if (grid.current?.activeEditor) grid.current.finishEditing();
      raw();
    };
  };
  buttonActions[Hotkeys.F7] = wrapWithEditCommit(buttonActions[Hotkeys.F7]);
  buttonActions[Hotkeys.F8] = wrapWithEditCommit(buttonActions[Hotkeys.F8]);
  buttonActions[Hotkeys.F9] = wrapWithEditCommit(buttonActions[Hotkeys.F9]);

  // Atlas 브리지 액션 노출 — 툴바가 실제로 실행하는 buttonActions(가드 포함)를 tabId 로
  // registry 에 등록한다. 브라우저 에이전트가 call_page_tool 로 버튼과 동일한 동작을 호출한다.
  // 페이지 최상위 SubTitle 만 등록(scopeId===null) — 다이얼로그 SubTitle 이 덮어쓰지 않게.
  // 안정 래퍼가 ref 로 최신 buttonActions 를 읽으므로 매 렌더 재등록이 불필요하다.
  const buttonActionsRef = useRef(buttonActions);
  buttonActionsRef.current = buttonActions;
  useEffect(() => {
    if (!BRIDGE_ENABLED || !tabId || scopeId !== null) return;
    const wrapped: Record<string, (args?: unknown) => unknown> = {};
    for (const name of Object.values(Hotkeys)) {
      wrapped[name] = () => {
        const action = buttonActionsRef.current[name as Hotkeys];
        if (typeof action !== 'function') return { error: `action not available: ${name}` };
        action();
        return { ok: true, action: name };
      };
    }
    registerViewActions(tabId, wrapped);
    return () => unregisterViewActions(tabId);
  }, [tabId, scopeId]);

  useEffect(() => {
    const hotkeyHandler = (keyboardEvent: KeyboardEvent) => {
      // 현재 활성(최상위) 스코프에서만 단축키가 동작한다.
      // 팝업이 열려 활성 스코프이면 부모(root/하위 다이얼로그) SubTitle은 여기서 종료된다.
      if (!useDialogStore.getState().isActiveScope(scopeId)) return;
      if (!isHotKeyName(keyboardEvent.key)) return;

      const action = buttonActions[Hotkeys[keyboardEvent.key]];

      if (action === false) return;
      // keep-alive MDI — 숨김(비활성) 탭의 SubTitle 리스너도 살아 있으므로, 화면이 보이지 않으면
      // 무시한다. (F5 가 포커스 검사를 우회해 열린 모든 탭에서 동시 실행되던 버그 방지)
      if (grid.current?.hostElement && !grid.current.hostElement.offsetParent) return;
      if (!grid.current?.containsFocus() && keyboardEvent.key !== 'F5') return;
      // TODO: F4에서 wijmo 기본 동작인 datamap이 열리고 있음.. 일단 F4만 조치 (버블링 모드 -> 캡처링 모드) - 강민재
      if (keyboardEvent.key === 'F4') {
        keyboardEvent.preventDefault();
        keyboardEvent.stopImmediatePropagation();
      }
      // F5 는 앱의 조회 단축키 — 브라우저 새로고침(기본 동작)을 차단해 열린 탭들의
      // 미저장 편집이 날아가는 것을 방지한다. (새로고침이 필요하면 Ctrl+R / 브라우저 버튼 사용)
      if (keyboardEvent.key === 'F5') keyboardEvent.preventDefault();

      action?.();
    };

    globalThis.window.addEventListener('keydown', hotkeyHandler, true);

    return () => {
      globalThis.window.removeEventListener('keydown', hotkeyHandler, true);
    };
  }, [grid.current, gridFilter.current, hotkeyConfig, useHotkey, searchAction, scopeId]);

  if (!useHotkey) {
    return (
      <TitleArea
        sx={{
          padding: '4px 0px',
        }}
        title={title}
        depth={depth}
        totalCases={displayTotalCases}
        isSubTitle
      />
    );
  }

  return (
    visible && (
      <TitleArea
        sx={{
          padding: '12px 0 4px 0',
        }}
        title={title}
        depth={depth}
        totalCases={displayTotalCases}
        isSubTitle
        rightButtons={
          <>
            {customButtons?.map(({ label, action, appearance, priority, size, ...buttonProps }) => (
              <Tooltip followCursor title={label} placement='bottom' key={label}>
                <div>
                  <Button
                    appearance={appearance ?? 'outlined'}
                    priority={priority ?? 'normal'}
                    size={size ?? 'small'}
                    buttonLabel={label}
                    onClick={action}
                    {...buttonProps}
                  />
                </div>
              </Tooltip>
            ))}
            {searchAction && (
              <Tooltip followCursor title='Search' placement='bottom'>
                <div style={{ marginRight: '12px' }}>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='Search(F5)'
                    // 직접 searchAction 을 호출하지 않는다 — 미저장 변경 가드가 감싼 F5 액션 경유
                    onClick={() => {
                      const action = buttonActions[Hotkeys.F5];
                      if (typeof action === 'function') action();
                    }}
                    iconComponent={<FunctionSearchIcon appearance='lined' iconSize={20} />}
                  />
                </div>
              </Tooltip>
            )}
            {buttonActions.upload === false || (
              <Tooltip followCursor title='Upload' placement='bottom'>
                <div>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel={t('LBL00346', 'Excel Upload')} // ⭐ 아이콘 우측 텍스트 (사용자 요구 2026-07-07)
                    onClick={buttonActions.upload}
                    iconComponent={<FileExceluploadIcon />}
                  />
                </div>
              </Tooltip>
            )}
            {buttonActions.insert === false || (
              <Tooltip followCursor title='Insert Row' placement='bottom'>
                <div>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='Insert(F8)'
                    onClick={buttonActions.insert}
                    iconComponent={<ControlAddIcon size='default' />}
                  />
                </div>
              </Tooltip>
            )}
            {buttonActions.delete === false || (
              <Tooltip followCursor title='Remove' placement='bottom'>
                <div>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='Delete(F9)'
                    onClick={buttonActions.delete}
                    iconComponent={<EditDeleteIcon appearance='lined' />}
                  />
                </div>
              </Tooltip>
            )}
            {buttonActions.save === false || (
              <Tooltip followCursor title='Save' placement='bottom'>
                <div>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='Save(F7)'
                    onClick={buttonActions.save}
                    iconComponent={<IcSave />}
                  />
                </div>
              </Tooltip>
            )}
            {buttonActions.sort === false || (
              <Tooltip followCursor title='Sort' placement='bottom'>
                <div>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='Sort(F3)'
                    onClick={buttonActions.sort}
                    iconComponent={<ArrowCondensedIcon direction='up-down' />}
                  />
                </div>
              </Tooltip>
            )}
            {buttonActions.filter === false || (
              <Tooltip followCursor title='Filter' placement='bottom'>
                <div>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='Filter(F4)'
                    onClick={buttonActions.filter}
                    iconComponent={<ListFunnelIcon appearance='lined' />}
                  />
                </div>
              </Tooltip>
            )}
            {buttonActions.condition === false || (
              <Tooltip followCursor title='Condition' placement='bottom'>
                <div>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='Condition(F6)'
                    onClick={buttonActions.condition}
                    iconComponent={<ListTodoIcon />}
                  />
                </div>
              </Tooltip>
            )}
            {buttonActions.resetCondition === false || (
              <Tooltip followCursor title='Reset Condition' placement='bottom'>
                <div>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='Reset Condition(F10)'
                    onClick={buttonActions.resetCondition}
                    iconComponent={<ControlRefreshIcon size='default' />}
                  />
                </div>
              </Tooltip>
            )}
            {buttonActions.excel === false || (
              <Tooltip followCursor title='Excel' placement='bottom'>
                <div>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    onClick={buttonActions.excel}
                    iconComponent={<FileExceldownloadIcon />}
                  />
                </div>
              </Tooltip>
            )}
            {buttonActions.manual === false || (
              // manual 버튼 전체 삭제 예정 - 강민재
              <Tooltip followCursor title='Manual' placement='bottom'>
                <div>
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='Manual(F1)'
                    onClick={buttonActions.manual}
                  />
                </div>
              </Tooltip>
            )}
          </>
        }
      />
    )
  );
};

export const SubTitle = memo(SubTitleComp);
