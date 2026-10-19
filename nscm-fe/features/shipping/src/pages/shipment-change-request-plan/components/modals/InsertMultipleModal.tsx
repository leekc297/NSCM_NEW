import { useEffect, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { MSG, LBL, SCREEN_TEXT } from '../../shipment-change-request-plan.constants';

import styles from './InsertMultipleModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 확인 시 입력 건수를 넘긴다(1 이상). */
  onConfirm: (count: number) => void;
}

// AS-IS 유효 범위 — 팝업 OK 검증 `int.TryParse && iCount > 0 && iCount < 51`(cs:120~128) = 1~50.
const MIN_COUNT = 1;
const MAX_COUNT = 50;

/**
 * SSP0200_ShipmentChangeRequestInsertPopup (design 00 §4f / 03 R-52 #4).
 *   AS-IS 는 건수 하나만 입력받아 `InsertRowMultiple(n)` 을 호출한다(전용 팝업, 149행).
 *   건수 범위(1~50)를 질문에 가이드로 표시하고, 범위 밖/빈값은 OK 시 MSG00050 으로 안내한다
 *   (AS-IS usrLabel1 + GMessageBox("MSG00050"), 사용자 지시 2026-10-07).
 *   화면 전용 팝업이라 공용 모달을 쓰지 않고 여기에 둔다. open state 는 페이지가 소유한다.
 */
export const InsertMultipleModal = ({ open, modalClose, onConfirm }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const [count, setCount] = useState('1');

  useEffect(() => {
    if (open) setCount('1');
  }, [open]);

  const handleSubmit = () => {
    // AS-IS 와 동일하게 OK 시점에 검증한다(버튼 비활성 대신 메시지). 1~50 정수 외(빈값/0/>50)는 차단 + 안내.
    const parsed = Number(count);
    const valid =
      count.trim() !== '' &&
      Number.isInteger(parsed) &&
      parsed >= MIN_COUNT &&
      parsed <= MAX_COUNT;
    if (!valid) {
      // MSG00050 '유효한 숫자 형식이 아닙니다. {0}' — {0}=입력값. i18next 보간({{}})이 아니라 수동 replace.
      void setAlert({
        type: 'alert',
        content: t(MSG.INVALID_NUMBER_FORMAT, {
          defaultValue: '_This is not a valid numeric format. {0}',
        }).replace('{0}', count),
      });
      return;
    }
    // 팝업을 먼저 닫고 삽입을 호출한다(AS-IS: OK -> 팝업 Close -> InsertRowMultiple 순서). 삽입은
    //   페이지 그리드에 대한 명령형 작업이라 팝업 unmount 와 무관하고, 혹시 삽입(그리드 refresh 중
    //   formatItem/converter)이 예외를 던져도 팝업은 이미 닫혀 있다 — 종전엔 onConfirm 이 먼저라
    //   예외 시 modalClose 가 스킵되어 "행은 추가됐는데 팝업이 안 닫히는" 증상이 났다(사용자 신고 2026-10-07).
    modalClose();
    onConfirm(parsed);
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={420}
      disableScale
      handleClose={modalClose}
      handleSubmit={handleSubmit}
      title={t(SCREEN_TEXT.INSERT_MULTIPLE, { defaultValue: 'Insert Multiple' })}
      customContentArea={
        // customContentArea 를 쓰면 CustomDialog 의 기본 푸터(취소/확인)가 렌더되지 않는다
        //   (CustomDialogContent.tsx:91). 종전엔 그 사실을 놓쳐 버튼이 하나도 없었고, 입력 후
        //   Enter 외에는 확정도 닫기도 할 수 없었다(사용자 신고 2026-10-02). 코드베이스 모달
        //   공통 규약대로 우하단에 확인/취소를 직접 둔다 — 액션 먼저, 닫기 마지막.
        <div className={styles.contentWrapper}>
          {/* 건수 가이드 — AS-IS usrLabel1 "선택한 계획을 몇 개 추가하시겠습니까? ( 1 ~ 50 )". 범위는 MIN/MAX
              상수로 덧붙여 검증과 동기화한다(수치 하드코딩 금지). */}
          <div className={styles.question}>
            {`${t(SCREEN_TEXT.INSERT_QUESTION, {
              defaultValue: 'How many plans do you want to insert selected?',
            })} ( ${MIN_COUNT} ~ ${MAX_COUNT} )`}
          </div>
          <FormItem
            className={commonStyles.formItem}
            label={t(SCREEN_TEXT.INSERT_COUNT, { defaultValue: 'Count' })}
            labelAlign='right'
            render={() => (
              <InputField
                fullWidth
                autoFocus
                value={count}
                onChange={e => setCount(e.target.value.replace(/[^0-9]/g, ''))}
                onKeyDown={e => {
                  if (e.key !== 'Enter') return;
                  // 필수: Enter 기본동작 취소. 이게 없으면 handleSubmit->modalClose 로 다이얼로그가 닫히며
                  //   MUI 가 포커스를 "열었던 트리거 버튼(Insert Multiple)"으로 복원하고, 리스너가 끝난 뒤
                  //   브라우저가 이 Enter 의 기본동작을 그 버튼에 적용해 버튼이 다시 눌린다(팝업 재오픈 +
                  //   count 1 리셋, 사용자 신고 2026-10-07). preventDefault 로 그 재활성화를 끊는다.
                  e.preventDefault();
                  handleSubmit();
                }}
              />
            )}
          />
          <div className={styles.buttonWrapper}>
            {/* 라벨 코드는 CustomDialog 기본 푸터와 동일(LBL00359 확인 / LBL00107 취소)로 맞춘다 */}
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t(LBL.CONFIRM, '_확인')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CANCEL, '_취소')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
