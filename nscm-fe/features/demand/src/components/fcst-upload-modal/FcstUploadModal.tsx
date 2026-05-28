import { DataGrid, CustomDialog } from '@shared/components';
import { Button, FileUploader, FormItem, Label, TextField } from '@shared/lges';
import { ControlConfirmIcon, FileUploadIcon } from '@shared/lges-icons';

import styles from './FcstUploadModal.module.scss';

interface FcstUploadModalProps {
  open: boolean;
  modalClose: () => void;
}

export const FcstUploadModal = ({ open, modalClose }: FcstUploadModalProps) => {
  const { t } = useTranslation();

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('', 'FCST Upload')}</h2>
        </div>
      }
      customContentArea={
        <>
          <div className={styles.inputContainer}>
            <FormItem
              label={t('', 'Excel File')}
              labelAlign='right'
              render={() => (
                <div className={styles.uploadFile}>
                  <FileUploader
                    placeholder=''
                    multiple
                    containerBoxProps={{
                      width: '240px',
                      // '& button': {},
                    }}
                  />
                  <Button
                    iconComponent={<FileUploadIcon />}
                    priority='normal'
                    appearance='outlined'
                  />
                </div>
              )}
            />
            <div className={styles.buttonGroup}>
              <Button priority='normal' appearance='outlined'>
                {t('', 'Cancel')}
              </Button>
              <Button iconComponent={<ControlConfirmIcon size='default' />} priority='normal'>
                {t('', 'OK')}
              </Button>
            </div>
          </div>
          <Label
            labelText={t('', 'Upload Result')}
            sx={{ lineHeight: '150%', fontSize: '14px', marginBottom: '10px' }}
          />
          <div className={styles.statusContainer}>
            <FormItem
              label={t('', 'Success')}
              labelAlign='left'
              render={() => <TextField className={styles.statusInput} value='' fullWidth />}
              sx={{ marginLeft: '8px' }}
            />
            <FormItem
              label={t('', 'Error')}
              labelAlign='left'
              render={() => <TextField className={styles.statusInput} value='' fullWidth />}
              sx={{ marginLeft: '8px' }}
            />
            <FormItem
              label={t('', 'Total')}
              labelAlign='left'
              render={() => <TextField className={styles.statusInput} value='' fullWidth />}
              sx={{ marginLeft: '8px' }}
            />
          </div>
          <Label
            labelText={t('', 'Error Detail')}
            sx={{ lineHeight: '150%', fontSize: '14px', marginBottom: '10px' }}
          />
          <DataGrid isReadOnly staticColumns={[]} itemsSource={[]} />
        </>
      }
    />
  );
};
