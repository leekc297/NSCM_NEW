import { Chip, DropdownField } from '@lges/design-system';
import type { DropdownFieldProps, DropdownOption } from '@lges/design-system';
import type { AutocompleteChangeDetails, AutocompleteChangeReason } from '@mui/material';
import { autocompleteClasses, createFilterOptions, Popper } from '@mui/material';
import { styled } from '@mui/material/styles';
import { useCallback, useEffect, useRef, useState } from 'react';
// 주의: KeyboardEvent 는 별칭으로 받는다. 같은 이름으로 import type 하면 DOM 전역
//   KeyboardEvent 가 가려져 handleSearchKeyDown 의 new KeyboardEvent(...) 가 막힌다.
import type {
  FocusEvent,
  KeyboardEvent as ReactKeyboardEvent,
  MouseEvent as ReactMouseEvent,
  SyntheticEvent,
} from 'react';
import { useListRef } from 'react-window';

import { clsx } from '@shared/clsx';

import { CustomListbox, DROPDOWN_SEARCH_ATTR } from './components/CustomListbox';
import type { CustomListboxProps } from './components/CustomListbox';
import type { ListboxChild } from './components/CustomListboxRow';
import styles from './CustomDropdownMui.module.scss';

const StyledPopper = styled(Popper)({
  [`& .${autocompleteClasses.listbox}`]: {
    boxSizing: 'border-box',
    '& ul': {
      padding: 0,
      margin: 0,
    },
    '& li': {
      gap: '5px',
    },
  },
});

interface SingleProps<T> extends Omit<DropdownFieldProps<T>, 'multiple' | 'onChange' | 'value'> {
  multiple?: false;
  allOption?: boolean;
  value?: string;
  onChange?: (event: React.SyntheticEvent, value: string) => void;
}

// 2. 다중 선택용 Props
interface MultipleProps<T> extends Omit<DropdownFieldProps<T>, 'multiple' | 'onChange' | 'value'> {
  multiple: true;
  allOption?: boolean;
  value?: string;
  onChange?: (event: React.SyntheticEvent, value: string) => void;
}

const MULTI_CHIP_WIDTH_SX = {
  '& .MuiAutocomplete-inputRoot': {
    flexWrap: 'nowrap',
    // 글자를 치는 칸이 아니라 '누르면 목록이 열리는' 칸임을 커서로 알린다.
    cursor: 'pointer',
  },
  '& .MuiAutocomplete-tag': {
    maxWidth: '100% !important',
  },
  '& input.MuiAutocomplete-input': {
    flex: '1 1 0 !important',
    width: '0 !important',
    minWidth: '0 !important',
    caretColor: 'transparent',
    cursor: 'pointer',
  },
};

// MUI 기본 목록 필터(대소문자 무시, 부분일치). 아래 두 곳에서 같은 기준을 써야
// '목록에 보이는 것'과 'SELECT ALL 이 고르는 것'이 어긋나지 않는다.
const listFilter = createFilterOptions<DropdownOption>();

/**
 * 팝업 검색칸에서 필드 입력창으로 넘겨줄 키.
 *
 * 포커스가 팝업 검색칸에 있으면 MUI 의 키 처리(getInputProps().onKeyDown)가 붙어 있는
 * 필드 입력창에 이벤트가 닿지 않아 방향키/Enter/Esc 가 죽는다. 그래서 이 키들만 네이티브
 * KeyboardEvent 로 다시 쏴 준다(React 는 루트에서 keydown 을 듣기 때문에 그대로 잡힌다).
 *
 * Home/End 는 일부러 뺐다 - 검색칸 안에서 커서를 옮기는 편이 자연스럽다.
 */
const FORWARDED_KEYS = new Set(['ArrowDown', 'ArrowUp', 'Enter', 'Escape', 'PageUp', 'PageDown']);

/**
 * 지금 펼쳐져 있는 목록. 화면 전체에서 하나만 열리게 하려고 모듈 수준에 하나만 둔다
 * (사용자 요구 2026-08-21 - 조회조건 콤보 두 개가 동시에 펼쳐져 있던 문제).
 *
 * blur 로 닫는 것에 기댈 수 없는 이유: MUI getRootProps().onMouseDown 은 마우스다운
 * 대상이 입력창 자신이 아니면 preventDefault() 한다. 그래서 다른 콤보의 칩/여백/화살표를
 * 누르면 포커스가 아예 옮겨가지 않고, 먼저 열려 있던 목록의 검색칸은 blur 되지 않는다.
 * 열리는 쪽에서 직전 목록을 직접 닫으면 포커스가 어디에 있든 상관이 없다.
 *
 * 다중 선택만 등록한다 - open 을 제어하는 것이 그쪽뿐이라 닫을 수단이 있다.
 */
let openList: { id: object; close: () => void } | null = null;

const SELECT_ALL_OPTION = {
  value: '',
  label: 'SELECT ALL',
};

const SINGLE_ALL_OPTION = {
  value: '',
  label: 'ALL',
};

/**
 * ⭐ [2026-08-16] 콤보 옵션 **중복 제거** — 전 화면 일괄 적용 지점.
 *
 * Lookup/CMBO 계열 SQL 은 화면 표시용 CODE/NAME 외에 cascade 용 부가 컬럼
 * (DIVISION_ID·DEPT_ID·END_CUSTOMER …)을 함께 반환한다. 그래서 **같은 CODE 가
 * 부가 컬럼 값마다 여러 행**으로 온다(실측: SCM_MST_SITE 의 END_CUSTOMER 'LGESMI'
 * = 8행/5부서). 화면이 그 행을 그대로 옵션으로 만들면 드롭다운에 같은 값이 여러 번 뜬다
 * (사용자 신고 2026-08-16 — 클라우드 DMF0003 조회조건 End Customer 에 'LGE' 2회).
 *
 * ⚠ 데이터 계층(useTabComboQueries/apiClient)에서 지우면 **cascade 가 깨진다** —
 *   부가 컬럼별 행이 하위 콤보를 좁히는 근거이기 때문. 그래서 **표시 직전인 여기**에서만
 *   value 기준으로 first-wins 합친다(행 데이터는 그대로 보존).
 * value 는 코드값이라 앞뒤 공백 변형도 같은 값으로 본다(TRIM 후 비교).
 */
const dedupeOptions = <T extends { value: string; label?: unknown }>(opts: T[]): T[] => {
  const seen = new Map<string, T>();
  for (const o of opts) {
    const key = String(o?.value ?? '').trim();
    if (!seen.has(key)) seen.set(key, o);
  }
  return seen.size === opts.length ? opts : [...seen.values()];
};

/**
 * ⭐ [2026-08-18 사용자 확정] 센티널 4형(`' '` / `''` / `'-'` / `'--'`) 옵션 **제외** — 전 화면 일괄.
 *
 * 원장은 '미지정'을 여러 표기로 들고 있다(PK 센티널 정규화 표준: 변형 3형 = `'-'` 통일,
 * 초기값 `NVL(x,'-')`). 그래서 콤보 원천에 값들이 **동시에** 존재하고, 위 dedupe 는 문자열이
 * 달라 못 묶는다 — 실측 `DM_PLN_SALES_PLAN.PLANT_SITE_ID` = `' '` 14,131 / `'-'` 13,675 /
 * `'--'` 3,095 건. 결과적으로 조회조건 드롭다운에 의미 없는 행이 여러 줄 뜬다.
 * (`' '` 는 TRIM 후 `''` 로 흡수되므로 셋에 `''` 만 두면 둘 다 걸린다)
 *
 * ⚠ **조회 범위는 좁히지 않는다.** 목록에서 빼는 것은 *표시*뿐이고, 전체 선택은
 *   `handleMultipleChange` 에서 `'ALL'` sentinel(= 필터 없음)로 내보내므로 센티널 값을 가진
 *   행도 ALL 조회 대상에 그대로 포함된다.
 * ⚠ **현재 선택된 값이 센티널이면 그 항목은 남긴다.** 원장에 이미 `'-'` 로 저장된 행을
 *   편집 폼에서 열었을 때 선택지가 없어 빈칸으로 보이고, 그대로 저장하면 값이 뒤바뀌기 때문.
 *   (선택지로 새로 고를 수는 없고, 기존 값 표시만 유지된다.)
 */
const SENTINEL_VALUES = new Set(['', '-', '--']);
const isSentinelValue = (v: string | null | undefined): boolean =>
  SENTINEL_VALUES.has((v ?? '').trim());

const dropSentinelOptions = <T extends { value: string }>(opts: T[], keep: Set<string>): T[] => {
  const kept = opts.filter(o => !isSentinelValue(o?.value) || keep.has(o?.value));
  return kept.length === opts.length ? opts : kept;
};

export const CustomDropdown = ({
  options: rawOptions,
  value,
  onChange,
  // 앱 표준: 칩 1개 + "+N". 명시적으로 넘기지 않은 화면(구 default 2)도 일관되게 맞춘다.
  // 2개 이상 노출이 필요한 곳은 limitTags 를 직접 지정한다(예: Templates 데모).
  limitTags = 1,
  allOption,
  className,
  ...props
}: SingleProps<DropdownOption> | MultipleProps<DropdownOption>) => {
  const internalListRef = useListRef(null);
  const optionIndexMapRef = useRef<Map<string, number>>(new Map());
  const lastIndexRef = useRef<number | null>(null);

  const [selectAllChecked, setSelectAllChecked] = useState(false);
  const isAllSentinel = value?.trim() === 'ALL';

  const [listSearch, setListSearch] = useState('');
  const isSearchControlled = !!props.multiple;

  /**
   * 목록 열림 상태. 다중 선택일 때는 MUI 의 open 을 여기서 '제어'한다.
   *
   * 제어해야 하는 이유: 팝업 안 검색칸에 포커스가 있으면 필드 입력창은 blur 된 상태이고,
   *   MUI 가 바깥 클릭으로 목록을 닫는 유일한 경로가 그 필드 입력창의 blur 다. 즉 제어하지
   *   않으면 바깥을 눌러도 목록이 닫히지 않는다. handleSearchBlur 에서 대신 닫는다.
   * 단일 선택은 제어하지 않는다 - 종전대로 MUI 에 맡긴다.
   */
  const [listOpen, setListOpen] = useState(false);

  // 필드(팝업 제외) DOM. 팝업은 body 로 portal 되므로 여기 querySelector 에 걸리지 않는다.
  //   - 키 포워딩 대상인 필드 입력창을 찾는 데
  //   - 검색칸 blur 시 '위젯 안으로 옮겨간 포커스'인지 판정하는 데 쓴다.
  const rootRef = useRef<HTMLDivElement>(null);

  // 팝업 안 검색칸 DOM. 포커스를 되돌리는 데만 쓴다(handleFocusCapture 참조).
  const searchInputRef = useRef<HTMLInputElement>(null);

  // 이 인스턴스를 가리키는 표식. 위 openList 가 '나'인지 판정하는 데만 쓴다.
  const listId = useRef({});

  const closeList = useCallback(() => {
    if (openList?.id === listId.current) openList = null;
    setListSearch('');
    setListOpen(false);
  }, []);

  // 열어 둔 채 화면을 떠나면(cascade 로 언마운트 등) 등록만 남아 다음 콤보를 닫지 못한다.
  useEffect(() => {
    // 주의: cleanup 안에서 listId.current 를 직접 읽지 않는다(react-hooks/exhaustive-deps).
    //   마운트 시점 값을 지역 변수로 복사해 둔다 - 이 ref 는 애초에 값이 바뀌지 않는다.
    const id = listId.current;

    return () => {
      if (openList?.id === id) openList = null;
    };
  }, []);

  // 부모가 특정 값으로 바꾸면(cascade 초기화, 개별 선택 등) 전체 체크 표시는 버린다.
  useEffect(() => {
    if (!isAllSentinel) setSelectAllChecked(false);
  }, [isAllSentinel]);

  // const splitValueSet = new Set(value?.trim().split(',') ?? []);
  const splitValueSet = new Set(value?.trim().split(',').filter(Boolean) ?? []);

  // 표시 직전 정리 — ① 센티널 3형 제외(현재 선택값은 보존) ② value 기준 중복 제거.
  //   (둘 다 변화가 없으면 원본 배열 참조를 그대로 돌려주어 불필요한 리렌더를 만들지 않는다)
  const options = dedupeOptions(dropSentinelOptions(rawOptions, splitValueSet));

  // TODO: 성능 개선 필요해보임, mockHeavyDropdown 기준 버벅거림 있음 - 강민재
  const isAllSelected = splitValueSet.size > 0 && splitValueSet.size === options.length;

  const allOptionEntry = props.multiple ? SELECT_ALL_OPTION : SINGLE_ALL_OPTION;
  const optionsWithAll = allOption ? [allOptionEntry, ...options] : options;
  const singleValue =
    allOption && value === 'ALL'
      ? SINGLE_ALL_OPTION
      : optionsWithAll.find(opt => opt.value === value);

  // 전 항목 체크로 보여야 하는 상태 - 값을 전부 열거한 경우와 'ALL' sentinel + SELECT ALL 선택 이력 둘 다.
  const allEntriesSelected = !!allOption && (isAllSelected || (isAllSentinel && selectAllChecked));

  const selectedOptions = options.filter(opt => splitValueSet.has(opt.value));

  const multipleValue = allEntriesSelected ? optionsWithAll : selectedOptions;

  const dropdownValue = props.multiple ? multipleValue : singleValue;

  const handleOptionsBuilt = useCallback((optionIndexMap: Map<string, number>) => {
    optionIndexMapRef.current = optionIndexMap;
  }, []);

  // 목록이 펼쳐져 있는 동안 포커스는 팝업 검색칸에 있어야 한다 - 열자마자 바로 칠 수 있게.
  //   검색칸에 autoFocus 를 걸어 두었지만 그것만으로는 유지되지 않는다. MUI
  //   getRootProps().onClick 이 조건 없이 inputRef.current.focus() 를 부르는데, 목록은
  //   mousedown 단계에서 열리므로 같은 클릭의 click 단계에서 포커스를 도로 필드 입력창이
  //   가져간다. 그래서 필드 쪽으로 포커스가 넘어가면 검색칸으로 되돌린다.
  //   되돌리는 시점을 다음 프레임으로 미루는 이유: 목록을 닫는 클릭도 같은 focus 를 부르는데,
  //   커밋이 끝나면 검색칸은 언마운트되어 isConnected 가 false 이므로 그냥 지나가게 된다.
  const handleFocusCapture = (event: FocusEvent<HTMLDivElement>) => {
    if (!isSearchControlled || !listOpen) return;
    if (event.target === searchInputRef.current) return;

    requestAnimationFrame(() => {
      const searchInput = searchInputRef.current;
      if (searchInput?.isConnected) searchInput.focus();
    });
  };

  const handleBlurCapture = (event: FocusEvent<HTMLDivElement>) => {
    if (!isSearchControlled) return;

    const next = event.relatedTarget as HTMLElement | null;
    if (next?.hasAttribute?.(DROPDOWN_SEARCH_ATTR)) event.stopPropagation();
  };

  // 팝업 검색칸에서 누른 키 중 목록 조작용만 필드 입력창으로 되돌려 준다(위 FORWARDED_KEYS 참조).
  const handleSearchKeyDown = (event: ReactKeyboardEvent<HTMLInputElement>) => {
    if (!FORWARDED_KEYS.has(event.key)) return;
    // 한글 조합 중의 Enter 는 '조합 확정'이라 항목 선택으로 넘기면 안 된다.
    if (event.key === 'Enter' && event.nativeEvent.isComposing) return;

    const fieldInput = rootRef.current?.querySelector<HTMLInputElement>('input');
    if (!fieldInput) return;

    event.preventDefault();
    fieldInput.dispatchEvent(
      new KeyboardEvent('keydown', {
        key: event.key,
        code: event.code,
        bubbles: true,
        cancelable: true,
      })
    );
  };

  // 바깥을 눌렀을 때 목록을 닫는다. 원래 MUI 가 필드 입력창의 blur 로 하던 일인데,
  //   포커스가 검색칸에 있어 그 blur 자체가 일어나지 않으므로 여기서 대신 한다.
  //   (팝업 안 클릭은 아래 slotProps.popper 의 mousedown preventDefault 로 blur 가 안 난다)
  const handleSearchBlur = (event: FocusEvent<HTMLInputElement>) => {
    const next = event.relatedTarget as Node | null;
    if (next && rootRef.current?.contains(next)) return;

    closeList();
    props.onClose?.(event, 'blur');
  };

  const handleHighlightChange = (_: SyntheticEvent, option: Lookup | null) => {
    if (!option || !internalListRef.current) return;

    const index = optionIndexMapRef.current.get(option.CODE);

    if (!index) return;
    if (lastIndexRef.current === index) return;

    lastIndexRef.current = index;
    internalListRef.current.scrollToRow({ index: index, align: 'auto' });
  };

  const handleSelectAll = (
    newValue: DropdownOption[],
    reason: AutocompleteChangeReason,
    // 클릭 직전 목록 검색어. 빈 문자열이면 검색 중이 아니다.
    searchText: string,
    details?: AutocompleteChangeDetails<DropdownOption>
  ) => {
    const clickedOptionValue = details?.option.value;
    if (
      (reason !== 'selectOption' && reason !== 'removeOption') ||
      dropdownValue === undefined ||
      // SELECT ALL 옵션의 value 는 빈 문자열('')이라 !clickedOptionValue 로 거르면 안 된다.
      // (옵션 클릭이 없을 때만, 즉 details 미존재일 때만 통과)
      clickedOptionValue === undefined
    )
      return newValue;

    if (clickedOptionValue === SELECT_ALL_OPTION.value) {
      // 검색 중이면 대상은 '그때 목록에 보이던 항목'뿐이다. 검색에 안 걸린 기존 선택은 건드리지 않는다.
      // 아래 filterOptions 와 같은 listFilter 를 써야 보이던 것과 골라지는 것이 일치한다.
      if (searchText) {
        const visible = listFilter(options, {
          inputValue: searchText,
          getOptionLabel: opt => opt.label || '',
        });

        if (reason === 'selectOption')
          return [...selectedOptions, ...visible.filter(opt => !splitValueSet.has(opt.value))];

        const visibleValues = new Set(visible.map(opt => opt.value));
        return selectedOptions.filter(opt => !visibleValues.has(opt.value));
      }
      // 체크 해제는 "아무것도 안 고름"이다. 종전엔 [SELECT_ALL_OPTION] 을 돌려줘서
      // 아래에서 value 가 빈 문자열('')로 나갔고, 그대로 프로시저 필터로 실려 조회가 0건이 됐다.
      if (reason === 'selectOption') return options;
      else return [];
    }

    return newValue.filter(opt => opt.value !== SELECT_ALL_OPTION.value);
  };

  const handleMultipleChange = (
    event: SyntheticEvent<Element, Event>,
    value: DropdownOption[],
    reason: AutocompleteChangeReason,
    details?: AutocompleteChangeDetails<DropdownOption>
  ) => {
    // 클릭 시점의 검색어. inputValue 를 제어하고 있어 MUI 의 resetInputValue 로도 지워지지
    // 않으므로, 이 렌더의 state 를 그대로 읽으면 '그때 목록에 보이던 것' 기준이 된다.
    const searchText = props.multiple && allOption ? listSearch : '';

    if (value.length === 0) {
      setSelectAllChecked(false);
      onChange?.(event, 'ALL');
      return;
    }
    if (allOption) {
      const nextValue = handleSelectAll(value, reason, searchText, details);
      // ⭐ [2026-08-18 사용자 요구] 전체 선택은 **열거가 아니라 'ALL' sentinel** 로 내보낸다.
      //   종전엔 보이는 옵션 value 를 콤마로 나열해 필터로 보냈다. 그 방식이면 위에서 화면 표시상
      //   제외한 센티널 값(' '/''/'-'/'--')이 **필터 목록에서도 빠져 조회 대상이 줄어든다.**
      //   'ALL' 은 스토어 규약(빈 배열 → 'ALL')과 동일한 "필터 없음"이라 센티널 행도 조회에 포함된다.
      //   (SELECT ALL 클릭 + 보이는 항목을 손으로 전부 고른 경우 둘 다 해당)
      const picked = nextValue.filter(item => item.value !== SELECT_ALL_OPTION.value);
      // 검색 중 SELECT ALL 은 '보이는 것 전체'라서 'ALL'(필터 없음)이 아니다 - 값을 열거해 내보낸다.
      const clickedSelectAll =
        !searchText &&
        reason === 'selectOption' &&
        details?.option.value === SELECT_ALL_OPTION.value;
      const pickedEveryVisible = picked.length > 0 && picked.length >= options.length;
      // 주의: 옵션이 1개뿐이면 '보이는 것을 전부 골랐다'와 '그 하나를 지정했다'가 구분되지 않는다.
      //   그 경우까지 'ALL'(필터 없음)로 뭉개면 단일 지정이 필터 해제로 뒤집혀 cascade 가 풀린다
      //   옵션이 1개일 때는 SELECT ALL 을 직접 누른 경우에만 'ALL', 그 외에는 값을 그대로 열거한다.
      if (clickedSelectAll || (pickedEveryVisible && options.length > 1)) {
        setSelectAllChecked(true);
        onChange?.(event, 'ALL');
        return;
      }
      // SELECT ALL 체크 해제. 필터로는 'ALL'(필터 없음)과 같고 화면만 비운다.
      if (picked.length === 0) {
        setSelectAllChecked(false);
        onChange?.(event, 'ALL');
        return;
      }
      setSelectAllChecked(false);
      onChange?.(event, picked.map(item => item.value).toString());
    } else onChange?.(event, value.map(item => item.value).toString());
  };

  return (
    // display:contents 래퍼 - 레이아웃에는 없는 것처럼 굴면서 blur 를 캡처 단계에서 가로챈다
    //   (handleBlurCapture 주석 참조). rootRef 는 '팝업을 뺀 필드 DOM' 을 가리킨다.
    <div
      ref={rootRef}
      style={{ display: 'contents' }}
      onFocusCapture={handleFocusCapture}
      onBlurCapture={handleBlurCapture}
    >
      <DropdownField<DropdownOption>
        className={clsx(styles.customDropdown, className)}
        disableListWrap
        options={optionsWithAll}
        value={dropdownValue}
        placeholder={props.placeholder ?? (props.multiple ? 'ALL' : undefined)}
        onChange={
          props.multiple
            ? handleMultipleChange
            : (event, value: DropdownOption) => onChange?.(event, value.value)
        }
        limitTags={limitTags}
        /**
         * TODO: List box 내에서 그룹핑 필요할 경우 사용 - 강민재
         * groupBy={option => option.label[0].toUpperCase()}
         * renderGroup={params => params as unknown as ReactNode}
         */
        renderTags={(selectedRows, getTagProps) => {
          const rowsWithoutAll = selectedRows.filter(row => row.value !== SELECT_ALL_OPTION.value);
          const visibleChips = rowsWithoutAll.slice(0, limitTags ?? undefined);
          const hiddenCount = rowsWithoutAll.length - visibleChips.length;

          return (
            <>
              {visibleChips.map(option => {
                // 값 배열 맨 앞에 SELECT ALL 항목이 끼는 경우가 있어(전체 체크/검색 결과 전체 체크)
                // 위치를 가정하지 않고 실제 인덱스를 찾는다.
                const { key, ...itemProps } = getTagProps({ index: selectedRows.indexOf(option) });

                return (
                  // span 래퍼: 남는 폭에 맞춰 줄고(flex), hover 시 전체 라벨 툴팁(title).
                  <span key={key} className={styles.chipClip} title={option.label}>
                    <Chip
                      {...itemProps}
                      sx={{
                        minWidth: 0,
                        overflow: 'hidden',
                        // 칩 내부 Box/Typography 가 줄어들며 라벨을 …로 자르게 한다.
                        '& .MuiBox-root': { minWidth: 0 },
                        '& .MuiTypography-root': {
                          display: 'block',
                          overflow: 'hidden',
                          textOverflow: 'ellipsis',
                          whiteSpace: 'nowrap',
                        },
                        '& > div:last-of-type': {
                          flexShrink: 0,
                          minWidth: '20px',
                          marginLeft: 0,
                        },
                      }}
                      chipText={option.label}
                      size='small'
                      type='input'
                      deletable
                    />
                  </span>
                );
              })}

              {hiddenCount > 0 && (
                // span 래퍼: +N 이 라벨 칩보다 먼저 자리를 확보한다(축소 금지). 줄어드는 쪽은 라벨 칩.
                <span className={styles.chipCount}>
                  <Chip
                    size='small'
                    type='input'
                    chipText={`+${hiddenCount}`}
                    sx={{
                      flexShrink: 0,
                      pointerEvents: 'none',
                    }}
                  />
                </span>
              )}
            </>
          );
        }}
        renderOption={(props, option, state) =>
          [{ ...props }, option.value, option.label, state.index, state.selected] as ListboxChild
        }
        onHighlightChange={handleHighlightChange}
        slots={{
          popper: StyledPopper,
        }}
        slotProps={{
          popper: {
            // 팝업 여백(Paper)을 눌러도 검색칸이 포커스를 잃지 않게 한다.
            //   리스트박스 안쪽은 MUI 가 이미 같은 처리를 하지만 Paper 여백은 비어 있다.
            //   검색칸 자신은 통과시켜야 클릭으로 커서를 옮길 수 있다.
            onMouseDown: (event: ReactMouseEvent<HTMLDivElement>) => {
              const target = event.target as HTMLElement;
              if (!target.closest?.(`[${DROPDOWN_SEARCH_ATTR}]`)) event.preventDefault();
            },
          },
          listbox: {
            component: CustomListbox,
            internalListRef: internalListRef,
            onOptionsBuilt: handleOptionsBuilt,
            multiple: props.multiple,
            // searchValue 가 undefined 면 검색줄을 그리지 않는다 - 단일 선택이 그 경우다.
            searchValue: isSearchControlled ? listSearch : undefined,
            searchInputRef: searchInputRef,
            searchPlaceholder: 'Search',
            onSearchChange: setListSearch,
            onSearchKeyDown: handleSearchKeyDown,
            onSearchBlur: handleSearchBlur,
          } as CustomListboxProps,
        }}
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        {...(props as any)}
        // 검색해도 SELECT ALL 은 목록 맨 위에 남긴다(라벨이 검색어와 안 맞아도 유지).
        // 주의: 다중 선택 + allOption 일 때만 손댄다. 단일 선택의 'ALL' 항목은 종전대로
        //   검색어에 걸릴 때만 보이는 게 맞다(전체 조회를 뜻하는 평범한 한 개 선택지라서).
        filterOptions={(opts, state) => {
          // 다중 선택의 검색어는 필드 입력창이 아니라 팝업 안 검색칸(listSearch)에 있다.
          //   필드의 inputValue 는 '' 로 고정해 두었으므로 state.inputValue 를 그대로 쓰면
          //   무엇을 쳐도 항상 전체 목록이 나온다.
          const searchState = isSearchControlled ? { ...state, inputValue: listSearch } : state;

          if (!props.multiple || !allOption) return listFilter(opts, searchState);

          return [
            SELECT_ALL_OPTION,
            ...listFilter(
              opts.filter(opt => opt.value !== SELECT_ALL_OPTION.value),
              searchState
            ),
          ];
        }}
        // 다중 선택은 필드 입력창을 '항상 비어 있는' 상태로 못 박는다.
        //   검색은 팝업 안 검색칸이 맡으므로 필드에 글자가 남을 일이 없어야 한다
        //   (칩 옆에 검색어가 남으면 그게 선택값처럼 보인다 - 사용자 지적 2026-08-21).
        //   비워 두는 것도 제어가 필요하다. MUI 는 옵션 선택/값 참조 변경 때마다
        //   resetInputValue 로 입력창을 건드리기 때문이다.
        // open 을 함께 제어하는 이유는 위 listOpen 주석 참조.
        // 필수: props 스프레드 뒤에 둘 것 - 호출부가 넘긴 값에 덮이면 제어가 풀린다.
        {...(isSearchControlled ? { inputValue: '', open: listOpen } : {})}
        onOpen={event => {
          if (isSearchControlled) {
            // 먼저 펼쳐져 있던 목록을 닫는다(위 openList 참조).
            if (openList && openList.id !== listId.current) openList.close();
            openList = { id: listId.current, close: closeList };
            setListOpen(true);
          }
          props.onOpen?.(event);
        }}
        onInputChange={(_, __, reason) => {
          // 필드 입력창의 X 버튼. 선택값과 함께 검색어도 비운다.
          //   그 외 reason 은 전부 무시한다 - 검색어의 출처는 팝업 검색칸뿐이다.
          if (isSearchControlled && reason === 'clear') setListSearch('');
        }}
        // 목록을 닫으면 검색어를 버린다 - 다음에 열 때는 전체 목록에서 시작해야 한다.
        onClose={(event, reason) => {
          if (isSearchControlled) closeList();
          props.onClose?.(event, reason);
        }}
        // 필수: props 스프레드 뒤에 둔다 — 호출부가 sx 를 넘기더라도 칩 폭 규칙이 유지되고,
        //   같은 키를 넘긴 경우에만 호출부 값이 이긴다.
        sx={
          props.multiple
            ? {
                ...MULTI_CHIP_WIDTH_SX,
                ...((props.sx as unknown as Record<string, unknown>) ?? {}),
              }
            : props.sx
        }
      />
    </div>
  );
};
