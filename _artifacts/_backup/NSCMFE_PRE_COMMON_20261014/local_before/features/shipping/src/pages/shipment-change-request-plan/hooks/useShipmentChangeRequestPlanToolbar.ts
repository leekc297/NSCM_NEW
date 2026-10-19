import type { HotkeyConfig } from '@foundation/models';

import { LBL, SCREEN_TEXT } from '../shipment-change-request-plan.constants';

interface Params {
  hasButton: (code: string) => boolean;
  onSearch: () => void;
  onInsert: () => void;
  onSave: () => void;
  onNew: () => void;
  onInsertMultiple: () => void;
}

interface CustomButton {
  label: string;
  title: string;
  action: () => void;
}

/**
 * SubTitle 툴바 구성 — `01_layout.md §2-E` 확정값을 그대로 옮긴다(재판단 금지).
 *
 *  - `search` : master + detail **동시** 조회(`FindButton` cs:757).
 *  - `insert` : `InsertButton` 내부 가드(`RowCount>0`) 재현은 핸들러 쪽.
 *  - `save`   : `useSaveWithValidation` 과 세트.
 *  - `delete` : `DeleteButton`(cs:770) 본문이 **완전 공백 = NO-OP** 다. 버튼을 **노출한 채 명시적 무동작**으로
 *               둔다(V-11). 키를 생략하면 공용 SubTitle 기본 `removeRow` 가 살아나 AS-IS 에 없는 삭제가
 *               실행되고, `false` 로 두면 AS-IS 에 있던 버튼이 사라진다 — 둘 다 금지.
 *  - `edit`   : `hotkeyConfig.edit` 는 Hotkeys enum 에 없는 **죽은 키**라 두지 않는다. `EDIT` 는 권한축으로만
 *               쓴다(`canEdit = hasButton('EDIT')`).
 *
 * 화면 고유 버튼은 전건 `hasButton()` 게이트다. 전용 `MNU_BTN_CD` 는 자매 실등록행·AS-IS 권한 테이블
 * 어디에도 근거가 없어 등록하지 않았고(임의 생성 금지 — convert-core §2.3), 기능이 가까운 표준 코드로
 * 묶었다 — 04 리포트 확인필요. `New`/`Insert Multiple` 은 AS-IS 좌표상 조회영역 우측 버튼이다.
 */
export const useShipmentChangeRequestPlanToolbar = ({
  hasButton,
  onSearch,
  onInsert,
  onSave,
  onNew,
  onInsertMultiple,
}: Params): { hotkeyConfig: HotkeyConfig; customButtons: CustomButton[] } => {
  const { t } = useTranslation();

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? onSearch : false,
    insert: hasButton('INSERT') ? onInsert : false,
    save: hasButton('SAVE') ? onSave : false,
    delete: () => undefined,
    manual: false,
    upload: false,
    // Excel 은 권한 메타로만 노출한다. 키를 생략하면 공용 SubTitle 의 기본 엑셀 핸들러가 그대로
    //   살아나(`SubTitle.tsx:444` `buttonActions.excel === false || (…)`) admin 에서 끄지 않은
    //   버튼이 화면에 남는다(CLAUDE.md §2 체크 3항 — 하드코딩 금지). `EXCEL` 이 등록되면 키를
    //   넣지 않아 기본 핸들러가 다시 살아난다. AS-IS 툴바 override 7건에 Excel 은 없다(01_layout §2-E).
    ...(hasButton('EXCEL') ? {} : { excel: false as const }),
  };

  const newLabel = t(LBL.NEW, { defaultValue: 'New' });
  const multipleLabel = t(SCREEN_TEXT.INSERT_MULTIPLE, { defaultValue: 'Insert Multiple' });
  const customButtons: CustomButton[] = hasButton('INSERT')
    ? [
        { label: newLabel, title: newLabel, action: onNew },
        { label: multipleLabel, title: multipleLabel, action: onInsertMultiple },
      ]
    : [];

  return { hotkeyConfig, customButtons };
};
