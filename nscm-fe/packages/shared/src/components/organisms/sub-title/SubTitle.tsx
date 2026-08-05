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
import { memo, type RefObject, useContext, useEffect, useState } from 'react';

import { IcSave } from '@foundation/assets';
import { type HotkeyConfig, Hotkeys } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { ButtonProps } from '@shared/lges';
import { Button, TitleArea, Tooltip } from '@shared/lges';
import {
  DialogScopeContext,
  useDialogStore,
  useMessageStore,
  useMotherStore,
  useTabid,
  useUIStore,
} from '@shared/stores';

const isHotKeyName = (key: string): key is keyof typeof Hotkeys => {
  return key in Hotkeys;
};

type CustomButtonProps = ButtonProps & {
  label: string;
  action: () => void;
};

interface SubTitleProps {
  menuId: string;
  grid: RefObject<FlexGrid | undefined>;
  gridFilter: RefObject<FlexGridFilter | undefined>;
  dataCount: number;
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

  // 필터 적용 시 collectionView 기준 필터된 건수, 미적용 시 null (DB dataCount 사용)
  const [filteredCount, setFilteredCount] = useState<number | null>(null);

  useEffect(() => {
    const gridInstance = grid.current;
    if (!gridInstance) return;

    // 현재 collectionView 기준으로 필터된 건수 재계산
    const recompute = () => {
      const collectionView = gridInstance.collectionView;
      if (!collectionView) return;
      const total = collectionView.sourceCollection?.length ?? 0;
      const visible = collectionView.items?.length ?? 0;
      // 필터가 행을 숨기고 있으면 필터된 건수, 아니면 null(=DB dataCount)
      setFilteredCount(visible < total ? visible : null);
    };

    // Wijmo는 itemsSource(배열) 변경 시 collectionView를 새 인스턴스로 교체하므로
    // 교체될 때마다 collectionChanged 핸들러를 다시 붙여준다.
    let boundView: FlexGrid['collectionView'] | undefined;
    const bindView = () => {
      const collectionView = gridInstance.collectionView;
      if (collectionView === boundView) {
        recompute();
        return;
      }
      boundView?.collectionChanged.removeHandler(recompute);
      boundView = collectionView;
      boundView?.collectionChanged.addHandler(recompute);
      recompute();
    };

    gridInstance.itemsSourceChanged.addHandler(bindView);
    gridFilter.current?.filterChanged.addHandler(recompute);
    bindView();

    return () => {
      gridInstance.itemsSourceChanged.removeHandler(bindView);
      gridFilter.current?.filterChanged.removeHandler(recompute);
      boundView?.collectionChanged.removeHandler(recompute);
    };
  }, [grid.current, gridFilter.current, dataCount]);

  // 필터 적용 시엔 0건이어도 명시 표시, 미적용 시엔 dataCount가 0이면 숨김
  const totalCasesValue =
    filteredCount !== null ? filteredCount : dataCount === 0 ? undefined : dataCount;

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
    [Hotkeys.F8]: () => grid.current && GridAction.addRow(grid.current, {}),
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
        title=''
        totalCases={totalCasesValue}
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
        title=''
        totalCases={totalCasesValue}
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
                    onClick={searchAction}
                    iconComponent={<FunctionSearchIcon appearance='lined' iconSize={20} />}
                  />
                </div>
              </Tooltip>
            )}
            {!searchAction && customButtons && customButtons.length > 0 && (
              <div style={{ marginRight: '12px' }} />
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
