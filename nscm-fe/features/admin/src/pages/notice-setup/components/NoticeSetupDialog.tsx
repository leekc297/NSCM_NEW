import dayjs, { type Dayjs } from 'dayjs';
import { useEffect, useRef, type ChangeEvent } from 'react';

import { CustomDialog, CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { COMBO_ID } from '../notice-setup.constants';
import type { ComboOption } from '../notice-setup.types';
import { formatFileSize, getAttachmentDownloadUrl } from '../notice-setup.util';
import { useAttachmentUpload } from '../useAttachmentUpload';
import { useNoticeAttachmentsQuery } from '../useNoticeAttachments';
import { useNoticeImageUpload } from '../useNoticeImageUpload';
import { useNoticeSetupStore } from '../useNoticeSetupStore';

// 첨부파일 최대 개수
const MAX_ATTACHMENTS = 10;
// 첨부파일 1개 최대 용량(서버 multipart 상한과 동일) — 업로드 전 사전 차단용
const MAX_ATTACHMENT_SIZE = 500 * 1024 * 1024;

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
  const attachments = useNoticeSetupStore(state => state.attachments);
  const addAttachments = useNoticeSetupStore(state => state.addAttachments);
  const removeAttachment = useNoticeSetupStore(state => state.removeAttachment);
  const setAttachments = useNoticeSetupStore(state => state.setAttachments);
  const { data: loadedAttachments } = useNoticeAttachmentsQuery(
    String(draft.NOTICE_ID ?? ''),
    isEditorOpen && dialogMode === 'edit'
  );
  // 편집 열 때 서버 첨부를 "그 공지당 한 번만" 스토어에 싣는다. 이후 사용자가 추가/삭제한 목록을
  // 덮어쓰지 않도록(방금 업로드한 파일이 사라지지 않도록) 이미 실은 공지면 재설정하지 않는다.
  const loadedNoticeIdRef = useRef<string | null>(null);
  useEffect(() => {
    if (!isEditorOpen || dialogMode !== 'edit') {
      loadedNoticeIdRef.current = null;
      return;
    }
    if (!loadedAttachments) return;
    const noticeId = String(draft.NOTICE_ID ?? '');
    if (loadedNoticeIdRef.current === noticeId) return;
    loadedNoticeIdRef.current = noticeId;
    setAttachments(loadedAttachments);
  }, [isEditorOpen, dialogMode, loadedAttachments, draft.NOTICE_ID, setAttachments]);

  // 본문 인라인 이미지 업로드(에디터에 전달) — 첨부와 별개 엔드포인트(/file/image-upload)
  const { mutateAsync: uploadImage, isPending: isImageUploading } = useNoticeImageUpload();
  // 첨부파일 업로드(/file/upload, 임의 종류·최대 500MB)
  const { mutateAsync: uploadAttachment, isPending: isAttachmentUploading } = useAttachmentUpload();

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
  const startDateValue = draft.START_DATE ? dayjs(draft.START_DATE) : null;
  const endDateValue = draft.END_DATE ? dayjs(draft.END_DATE) : null;

  const handleAttachmentChange = async (event: ChangeEvent<HTMLInputElement>) => {
    const input = event.currentTarget;
    const files = Array.from(input.files ?? []);
    input.value = '';
    if (files.length === 0 || isAttachmentUploading) return;

    const remaining = MAX_ATTACHMENTS - attachments.length;
    if (remaining <= 0) {
      void setAlert({
        type: 'alert',
        content: `첨부파일은 최대 ${MAX_ATTACHMENTS}개까지 등록할 수 있습니다.`,
      });
      return;
    }

    const targets = files.slice(0, remaining);
    // 대용량(최대 500MB) 파일이 병렬로 몰리지 않도록 순차 업로드한다.
    await targets.reduce(async (prev, file) => {
      await prev;
      // 500MB 초과는 서버에 보내기 전에 막는다(전송 낭비·불명확한 500 방지).
      if (file.size > MAX_ATTACHMENT_SIZE) {
        void setAlert({
          type: 'alert',
          content: `${file.name} : 첨부파일은 최대 500MB까지 가능합니다.`,
        });
        return;
      }
      try {
        const uploaded = await uploadAttachment(file);
        addAttachments([
          {
            fileId: uploaded.fileId,
            fileName: uploaded.fileName,
            size: uploaded.size,
            ext: uploaded.ext,
          },
        ]);
      } catch (error) {
        void setAlert({
          type: 'alert',
          content:
            error instanceof Error && error.message
              ? error.message
              : t('MSG00003', '_Upload failed.'),
        });
      }
    }, Promise.resolve());
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
                <div className={styles.attachmentField}>
                  {/* TODO i18n: 'Attachment'·'Select files' 라벨은 LBL 코드 등록 후 t() 로 교체 */}
                  <span className={styles.attachmentLabel}>Attachment</span>
                  <div className={styles.attachmentArea}>
                    <div className={styles.attachmentActions}>
                      <input
                        id='notice-attachment-upload'
                        className={styles.fileInput}
                        type='file'
                        multiple
                        disabled={isAttachmentUploading}
                        onChange={handleAttachmentChange}
                      />
                      <label
                        className={styles.fileSelectButton}
                        htmlFor='notice-attachment-upload'
                        aria-disabled={isAttachmentUploading}
                      >
                        {isAttachmentUploading ? 'Uploading...' : 'Select files'}
                      </label>
                    </div>
                    {attachments.length === 0 ? (
                      <span className={styles.fileName}>{t('LBL00393', '_No file selected')}</span>
                    ) : (
                      <ul className={styles.attachmentList}>
                        {attachments.map(attachment => (
                          <li key={attachment.fileId} className={styles.attachmentItem}>
                            <a
                              className={styles.attachmentName}
                              href={getAttachmentDownloadUrl(attachment.fileId)}
                              download={attachment.fileName}
                            >
                              {attachment.fileName}
                            </a>
                            <span className={styles.attachmentSize}>
                              {formatFileSize(attachment.size)}
                            </span>
                            <button
                              type='button'
                              className={styles.fileRemoveButton}
                              onClick={() => removeAttachment(attachment.fileId)}
                            >
                              {t('LBL00407', '_Remove')}
                            </button>
                          </li>
                        ))}
                      </ul>
                    )}
                  </div>
                </div>
                <div className={styles.contentField}>
                  <span className={styles.contentLabel}>{t('LBL00386', '_Notice Content *')}</span>
                  <div className={styles.editorField}>
                    <NoticeRichTextEditor
                      uploadImage={uploadImage}
                      isImageUploading={isImageUploading}
                    />
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
