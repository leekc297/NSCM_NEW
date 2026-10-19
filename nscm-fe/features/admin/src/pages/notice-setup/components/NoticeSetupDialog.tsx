import dayjs, { type Dayjs } from 'dayjs';
import { type ChangeEvent, type DragEvent } from 'react';

import { CustomDialog, CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { COMBO_ID } from '../notice-setup.constants';
import type { ComboOption } from '../notice-setup.types';
import { getSafeNoticeImageSource } from '../notice-setup.util';
import { useNoticeImageUpload } from '../useNoticeImageUpload';
import { useNoticeSetupStore } from '../useNoticeSetupStore';

import { NoticeRichTextEditor } from './NoticeRichTextEditor';
import styles from './NoticeSetupDialog.module.scss';

interface NoticeSetupDialogProps {
  onSave: () => void;
  onDelete: () => void;
  isSaving: boolean;
}

export const NoticeSetupDialog = ({ onSave, onDelete, isSaving }: NoticeSetupDialogProps) => {
  const { t } = useTranslation();

  const isEditorOpen = useNoticeSetupStore(state => state.isEditorOpen);
  const dialogMode = useNoticeSetupStore(state => state.dialogMode);
  const draft = useNoticeSetupStore(state => state.draft);
  const setDraft = useNoticeSetupStore(state => state.setDraft);
  const closeEditor = useNoticeSetupStore(state => state.closeEditor);
  const openDraftPreview = useNoticeSetupStore(state => state.openDraftPreview);
  const setAlert = useMessageStore(state => state.setAlert);

  const { mutateAsync: uploadImage, isPending: isImageUploading } = useNoticeImageUpload();

  // 이전 comboId 'Module'/'SubModule' 은 SCM_ADM_CMBO_SQL_M 에 등록되지 않아 신규 등록 시
  // module 선택 콤보가 항상 빈 목록이었다(2026-09-11). mail-setup 표준으로 교체.
  // const [modules, subModules] = useTabComboQueries({
  //   filters: ['Module', { comboId: 'SubModule', module: draft.MODULE }],
  //   enabled: isEditorOpen,
  // });
  const [modules, subModules] = useTabComboQueries({
    filters: [COMBO_ID.MODULE, COMBO_ID.SUB_MODULE],
    enabled: isEditorOpen,
  });

  const moduleOptions =
    (modules as ComboOption[] | undefined)?.map(item => ({ label: item.NAME, value: item.CODE })) ??
    [];
  // 2026-09-16 사용자 요구 - Module:Sub Module 은 1:1 매핑이라 입력 칸을 없애고 Module 선택 시
  // 매핑되는 Sub Module 을 자동으로 draft 에 채워 저장한다 (rawSubModules 는 CMBO 원본, PARENT_CODE=Module).
  const rawSubModules = (subModules as ComboOption[] | undefined) ?? [];
  const imageSource = getSafeNoticeImageSource(draft.NOTICE_IMAGE);
  const startDateValue = draft.START_DATE ? dayjs(draft.START_DATE) : null;
  const endDateValue = draft.END_DATE ? dayjs(draft.END_DATE) : null;

  const uploadImageFile = async (file: File, input?: HTMLInputElement) => {
    const resetInput = () => {
      if (input) input.value = '';
    };

    if (isImageUploading) {
      resetInput();
      return;
    }

    try {
      const uploadedImage = await uploadImage(file);
      setDraft({
        NOTICE_IMAGE: uploadedImage.fileId,
        IMAGE_FILE_NM: uploadedImage.fileName,
      });
    } catch (error) {
      void setAlert({
        type: 'alert',
        content:
          error instanceof Error && error.message
            ? error.message
            : t('MSG00003', '_Image upload failed.'),
      });
    } finally {
      resetInput();
    }
  };

  const handleImageChange = (event: ChangeEvent<HTMLInputElement>) => {
    const input = event.currentTarget;
    const file = input.files?.[0];
    if (!file) return;

    void uploadImageFile(file, input);
  };

  const handleImageDragOver = (event: DragEvent<HTMLDivElement>) => {
    event.preventDefault();
    event.dataTransfer.dropEffect = isImageUploading ? 'none' : 'copy';
  };

  const handleImageDrop = (event: DragEvent<HTMLDivElement>) => {
    event.preventDefault();
    if (isImageUploading) return;
    const file = event.dataTransfer.files[0];
    if (file) void uploadImageFile(file);
  };

  const handleDateChange = (field: 'START_DATE' | 'END_DATE', date: Dayjs | null) => {
    const value = date?.format('YYYY-MM-DD') ?? '';
    if (field === 'START_DATE') setDraft({ START_DATE: value });
    else setDraft({ END_DATE: value });
  };

  const title =
    dialogMode === 'create' ? t('LBL00380', '_Register Notice') : t('LBL00396', '_Edit Notice');

  return (
    <CustomDialog
      open={isEditorOpen}
      size={614}
      height='58vh'
      type='modal'
      position='basic'
      handleClose={() => {
        if (!isImageUploading) closeEditor();
      }}
      disableButtonCancel
      customHeaderTitle={
        <div className={styles.header}>
          <span className={styles.headerDot} />
          <h2 className={styles.headerTitle}>{title}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <div className={styles.scrollArea}>
            <section className={styles.sectionWrapper}>
              <h3 className={styles.sectionTitle}>{t('LBL00391', '_Basic Information')}</h3>
              <div className={styles.section}>
              <div className={styles.formGrid}>
                <FormItem
                  label={t('LBL00379', '_Module')}
                  labelAlign='right'
                  required
                  render={() => (
                    <CustomDropdown
                      isInput={false}
                      value={draft.MODULE}
                      options={moduleOptions}
                      onChange={(_, option) => {
                        const nextModule = option ?? '';
                        // Module:Sub Module 1:1 매핑 - PARENT_CODE 로 매칭되는 Sub Module 을 자동 채움
                        const matchedSubModule = rawSubModules.find(
                          item => item.PARENT_CODE === nextModule
                        );
                        setDraft({
                          MODULE: nextModule,
                          MODULE_NM: '',
                          SUB_MODULE: matchedSubModule?.CODE ?? '',
                          SUB_MODULE_NM: matchedSubModule?.NAME ?? '',
                        });
                      }}
                    />
                  )}
                />
                {/* 2026-09-16 사용자 요구 - Module:Sub Module 1:1 매핑이라 입력 칸 제거, Module 선택 시 자동 매핑
                <FormItem
                  label={t('LBL00378', '_Sub Module')}
                  labelAlign='right'
                  required
                  render={() => (
                    <CustomDropdown
                      isInput={false}
                      value={draft.SUB_MODULE}
                      options={subModuleOptions}
                      onChange={(_, option) => setDraft({ SUB_MODULE: option, SUB_MODULE_NM: '' })}
                    />
                  )}
                />
                */}
                <div className={styles.fullRow}>
                  <FormItem
                    label={t('LBL00388', '_Notice *')}
                    required
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={draft.NOTICE}
                        placeholder={t('LBL00397', '_Enter a notice identifier')}
                        onChange={(event: ChangeEvent<HTMLInputElement>) =>
                          setDraft({ NOTICE: event.target.value })
                        }
                      />
                    )}
                  />
                </div>
                <div className={styles.fullRow}>
                  <FormItem
                    label={t('LBL00007', '_Active')}
                    labelAlign='right'
                    render={() => (
                      <div className={styles.radioGroup}>
                        <label className={styles.radioOption}>
                          <input
                            type='radio'
                            name='notice-active'
                            value='Y'
                            checked={draft.ACTIVE === 'Y'}
                            onChange={() => setDraft({ ACTIVE: 'Y' })}
                          />
                          <span>{t('LBL00398', '_Y (Use)')}</span>
                        </label>
                        <label className={styles.radioOption}>
                          <input
                            type='radio'
                            name='notice-active'
                            value='N'
                            checked={draft.ACTIVE === 'N'}
                            onChange={() => setDraft({ ACTIVE: 'N' })}
                          />
                          <span>{t('LBL00399', '_N (Unused)')}</span>
                        </label>
                      </div>
                    )}
                  />
                </div>
                <div className={styles.fullRow}>
                  <FormItem
                    label={t('LBL00382', '_Popup Exposure')}
                    labelAlign='right'
                    render={() => (
                      <div className={styles.radioGroup}>
                        <label className={styles.radioOption}>
                          <input
                            type='radio'
                            name='notice-popup-exposure'
                            value='Y'
                            checked={draft.POPUP_YN === 'Y'}
                            onChange={() => setDraft({ POPUP_YN: 'Y' })}
                          />
                          <span>{t('LBL00402', '_Y (Visible)')}</span>
                        </label>
                        <label className={styles.radioOption}>
                          <input
                            type='radio'
                            name='notice-popup-exposure'
                            value='N'
                            checked={draft.POPUP_YN === 'N'}
                            onChange={() => setDraft({ POPUP_YN: 'N' })}
                          />
                          <span>{t('LBL00401', '_N (Hidden)')}</span>
                        </label>
                      </div>
                    )}
                  />
                </div>
              </div>
              </div>
            </section>

            <section className={styles.sectionWrapper}>
              <h3 className={styles.sectionTitle}>{t('LBL00389', '_Publication Period')}</h3>
              <div className={styles.section}>
              <div className={styles.dateRow}>
                <label className={styles.dateField}>
                  <span>{t('LBL00390', '_Start Date')}</span>
                  <div className={styles.datePickerFix}>
                    <DatePickerCalendar
                      usecase='date'
                      elevation
                      size='small'
                      format='YYYY.MM.DD'
                      value={startDateValue}
                      onChange={
                        ((date: Dayjs | null) => handleDateChange('START_DATE', date)) as never
                      }
                    />
                  </div>
                </label>
                <span className={styles.dateSeparator}>–</span>
                <label className={styles.dateField}>
                  <span>{t('LBL00392', '_End Date')}</span>
                  <div className={styles.datePickerFix}>
                    <DatePickerCalendar
                      usecase='date'
                      elevation
                      size='small'
                      format='YYYY.MM.DD'
                      value={endDateValue}
                      mindate={startDateValue ?? undefined}
                      onChange={
                        ((date: Dayjs | null) => handleDateChange('END_DATE', date)) as never
                      }
                    />
                  </div>
                </label>
              </div>
              </div>
            </section>

            <section className={styles.sectionWrapper}>
              <h3 className={styles.sectionTitle}>{t('LBL00383', '_Message Setup')}</h3>
              <div className={styles.section}>
              <div className={styles.messageFields}>
                <FormItem
                  label={t('LBL00384', '_Notice Title *')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      value={draft.NOTICE_TITLE}
                      placeholder={t('LBL00404', '_Title displayed at the top of the popup')}
                      onChange={(event: ChangeEvent<HTMLInputElement>) =>
                        setDraft({ NOTICE_TITLE: event.target.value })
                      }
                    />
                  )}
                />
                <div className={styles.imageField}>
                  <span className={styles.imageLabel}>{t('LBL00410', '_Image')}</span>
                  <div
                    className={styles.imageUploadArea}
                    role='group'
                    aria-label={t('LBL00410', '_Image')}
                    onDragOver={handleImageDragOver}
                    onDrop={handleImageDrop}
                  >
                    <div className={styles.imageThumbnail}>
                      {imageSource ? (
                        <img src={imageSource} alt={draft.IMAGE_FILE_NM} />
                      ) : (
                        <span>{t('LBL00411', '_No Image')}</span>
                      )}
                    </div>
                    <div className={styles.imageMeta}>
                      <span className={styles.fileName}>
                        {draft.IMAGE_FILE_NM || t('LBL00393', '_No file selected')}
                      </span>
                      <div className={styles.imageActions}>
                        <input
                          id='notice-image-upload'
                          className={styles.fileInput}
                          type='file'
                          accept='.jpg,.jpeg,.png,.gif,.webp,image/jpeg,image/png,image/gif,image/webp'
                          disabled={isImageUploading}
                          onChange={handleImageChange}
                        />
                        <label
                          className={styles.fileSelectButton}
                          htmlFor='notice-image-upload'
                          aria-disabled={isImageUploading}
                        >
                          {isImageUploading
                            ? t('LBL00416', '_Uploading...')
                            : t('LBL00406', '_Select image')}
                        </label>
                        {draft.IMAGE_FILE_NM && (
                          <button
                            type='button'
                            className={styles.fileRemoveButton}
                            disabled={isImageUploading}
                            onClick={() => setDraft({ NOTICE_IMAGE: '', IMAGE_FILE_NM: '' })}
                          >
                            {t('LBL00407', '_Remove')}
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
                <div className={styles.contentField}>
                  <span className={styles.contentLabel}>{t('LBL00386', '_Notice Content *')}</span>
                  <div className={styles.editorField}>
                    <NoticeRichTextEditor />
                  </div>
                </div>
              </div>
              </div>
            </section>
          </div>

          <div className={styles.buttonRow}>
            <Button
              appearance='outlined'
              priority='normal'
              buttonLabel={t('LBL00385', '_Preview')}
              disabled={isImageUploading}
              onClick={openDraftPreview}
            />
            <Button
              appearance='contained'
              priority='primary'
              buttonLabel={t('LBL00395', '_Save')}
              disabled={isSaving || isImageUploading}
              onClick={onSave}
            />
            {dialogMode === 'edit' && (
              <Button
                appearance='outlined'
                priority='normal'
                buttonLabel={t('LBL00407', '_Delete')}
                disabled={isSaving || isImageUploading}
                onClick={onDelete}
              />
            )}
            <Button
              appearance='outlined'
              priority='normal'
              buttonLabel={t('LBL00394', '_Cancel')}
              disabled={isImageUploading}
              onClick={closeEditor}
            />
          </div>
        </div>
      }
    />
  );
};
