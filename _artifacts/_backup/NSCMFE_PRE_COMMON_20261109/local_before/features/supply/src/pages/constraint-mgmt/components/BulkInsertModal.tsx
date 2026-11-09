import { useEffect, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { BULK_INSERT_MAX, BULK_INSERT_MIN, LBL, MSG } from '../constraint-mgmt.constants';

import styles from './BulkInsertModal.module.scss';

interface Props {
    open: boolean;
    modalClose: () => void;
    /** 화면에 보여줄 상위 Lookup Type (읽기 전용). */
    lookupType: string;
    /** OK 시 입력 건수를 넘긴다. */
    onConfirm: (count: number) => void;
}

/**
 * 하단 Lookup Values 그리드에 빈 행을 여러 건 한 번에 추가하는 팝업.
 * open state 는 페이지(ConstraintMgmt)가 소유한다.
 */
export const BulkInsertModal = ({ open, modalClose, lookupType, onConfirm }: Props) => {
    const { t } = useTranslation();
    const setAlert = useMessageStore.getState().setAlert;
    const [count, setCount] = useState('');

    // 다시 열 때마다 입력칸을 비운다.
    useEffect(() => {
        if (open) setCount('');
    }, [open]);

    const handleSubmit = () => {
        const parsed = Number(count);
        const valid =
            count.trim() !== '' &&
            Number.isInteger(parsed) &&
            parsed >= BULK_INSERT_MIN &&
            parsed <= BULK_INSERT_MAX;
        if (!valid) {
            void setAlert({
                type: 'alert',
                content: t(MSG.INVALID_NUMBER, '_This is not a valid numeric format. {0}').replace(
                    '{0}',
                    count
                ),
            });
            return;
        }
        // 먼저 닫고 행을 추가한다 — 추가 중 예외가 나도 팝업은 닫혀 있게.
        modalClose();
        onConfirm(parsed);
    };

    return (
        <CustomDialog
            open={open}
            type='modal'
            position='basic'
            size={600}
            disableScale
            handleClose={modalClose}
            title='Bulk Insert'
            customContentArea={
                <div className={styles.contentWrapper}>
                    <div className={styles.notice}>{`* 직접 입력, 최대 ${BULK_INSERT_MAX}건 가능`}</div>

                    <div className={styles.sectionTitle}>{t(LBL.LOOKUP_VALUES, '_Lookup Values')}</div>

                    {/* 상위 Lookup Type — 보여주기만 하고 수정은 못 하게 disabled */}
                    <div className={styles.lookupTypeBox}>
                        <FormItem
                            className={commonStyles.formItem}
                            label={t(LBL.LOOKUP_TYPE, '_Lookup Type')}
                            labelAlign='right'
                            render={() => <InputField fullWidth disabled value={lookupType} />}
                        />
                    </div>

                    {/* 추가 Row 수 — 숫자만 입력, Enter 로도 확인 */}
                    <FormItem
                        className={commonStyles.formItem}
                        label='추가 Row 수'
                        labelAlign='right'
                        render={() => (
                            <InputField
                                fullWidth
                                autoFocus
                                placeholder={String(BULK_INSERT_MAX)}
                                value={count}
                                onChange={e => setCount(e.target.value.replace(/[^0-9]/g, ''))}
                                onKeyDown={e => {
                                    if (e.key !== 'Enter') return;
                                    // 필수: 기본동작을 막지 않으면 닫힌 뒤 포커스가 돌아간 Bulk Insert 버튼이 다시 눌린다.
                                    e.preventDefault();
                                    handleSubmit();
                                }}
                            />
                        )}
                    />

                    <div className={styles.buttonWrapper}>
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
