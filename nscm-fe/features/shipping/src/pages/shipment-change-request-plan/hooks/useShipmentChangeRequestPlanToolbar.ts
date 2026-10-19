import type { HotkeyConfig } from '@foundation/models';

interface Params {
  hasButton: (code: string) => boolean;
  onSearch: () => void;
  onInsert: () => void;
  onSave: () => void;
  onDelete: () => void;
}

/**
 * SubTitle 툴바 구성 — `01_layout.md §2-E` 확정값을 그대로 옮긴다(재판단 금지).
 *
 *  - `search` : master + detail **동시** 조회(`FindButton` cs:757).
 *  - `insert` : `InsertButton` 내부 가드(`RowCount>0`) 재현은 핸들러 쪽.
 *  - `save`   : `useSaveWithValidation` 과 세트.
 *  - `delete` : **저장 전 신규행만** 제거한다(사용자 지시 2026-10-03). 수정행·기존행은 건드리지 않는다.
 *               AS-IS `DeleteButton()`(cs:706~709)은 본문이 빈 NO-OP 라 종전에는 `() => undefined` 로
 *               두었으나(V-11), 넣은 신규행을 되돌릴 방법이 없어 실동작을 부여했다.
 *               키를 생략하면 공용 SubTitle 기본 `removeRow`(= `deleteOnlyNew=false`)가 살아나
 *               **기존행까지 'D' 마킹**되므로 생략은 여전히 금지다 — 반드시 화면 핸들러를 넘긴다.
 *  - `edit`   : `hotkeyConfig.edit` 는 Hotkeys enum 에 없는 **죽은 키**라 두지 않는다. `EDIT` 는 권한축으로만
 *               쓴다(`canEdit = hasButton('EDIT')`).
 *
 * `New`/`Insert Multiple` 은 AS-IS 좌표상 **조회영역 1단 우측 버튼**(btnNew x980 / btnInsertMultiple x1082,
 * design 01 §5.1)이라 SubTitle 툴바가 아니라 SearchArea 의 `extraButtons` 로 옮겼다(사용자 지시 2026-09-29).
 * → 이 훅은 표준 툴바(search/insert/save/delete/excel)만 구성한다.
 */
export const useShipmentChangeRequestPlanToolbar = ({
  hasButton,
  onSearch,
  onInsert,
  onSave,
  onDelete,
}: Params): { hotkeyConfig: HotkeyConfig } => {
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? onSearch : false,
    insert: hasButton('INSERT') ? onInsert : false,
    save: hasButton('SAVE') ? onSave : false,
    // DELETE 는 SCM_ADM_MNU_BTN_MPG_M 에 등록돼 있다(SSP0200/main, ora.py 실측) — 다른 키와 같은
    //   권한 축으로 둔다. 하드코딩 금지(CLAUDE.md §2 체크 3항).
    delete: hasButton('DELETE') ? onDelete : false,
    manual: false,
    upload: false,
    // Excel 은 권한 메타로만 노출한다. 키를 생략하면 공용 SubTitle 의 기본 엑셀 핸들러가 그대로
    //   살아나(`SubTitle.tsx:444` `buttonActions.excel === false || (…)`) admin 에서 끄지 않은
    //   버튼이 화면에 남는다(CLAUDE.md §2 체크 3항 — 하드코딩 금지). `EXCEL` 이 등록되면 키를
    //   넣지 않아 기본 핸들러가 다시 살아난다. AS-IS 툴바 override 7건에 Excel 은 없다(01_layout §2-E).
    ...(hasButton('EXCEL') ? {} : { excel: false as const }),
  };

  return { hotkeyConfig };
};
