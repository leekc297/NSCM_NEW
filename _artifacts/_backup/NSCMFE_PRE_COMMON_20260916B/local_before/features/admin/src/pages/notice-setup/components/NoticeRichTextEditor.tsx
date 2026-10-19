import { useEffect, useRef, type ClipboardEvent, type FormEvent, type MouseEvent } from 'react';

import { sanitizeNoticeHtml } from '../notice-setup.util';
import { useNoticeSetupStore } from '../useNoticeSetupStore';

import styles from './NoticeRichTextEditor.module.scss';

type NoticeTextFormat = 'p' | 'h1' | 'h2';
const FORMAT_TYPING_MARKER = '\u200B';

const removeFormatTypingMarkers = (editor: HTMLDivElement) => {
  const selection = globalThis.document.getSelection();
  const caretNode =
    selection?.isCollapsed && selection.anchorNode?.nodeType === globalThis.Node.TEXT_NODE
      ? (selection.anchorNode as Text)
      : undefined;
  const caretOffset = caretNode ? selection?.anchorOffset : undefined;
  let nextCaretOffset = caretOffset;

  const walker = globalThis.document.createTreeWalker(editor, globalThis.NodeFilter.SHOW_TEXT);
  const textNodes: Text[] = [];
  let currentNode = walker.nextNode();
  while (currentNode) {
    textNodes.push(currentNode as Text);
    currentNode = walker.nextNode();
  }

  textNodes.forEach(textNode => {
    if (!textNode.data.includes(FORMAT_TYPING_MARKER)) return;

    if (textNode === caretNode && caretOffset !== undefined) {
      nextCaretOffset = textNode.data
        .slice(0, caretOffset)
        .replaceAll(FORMAT_TYPING_MARKER, '').length;
    }
    textNode.data = textNode.data.replaceAll(FORMAT_TYPING_MARKER, '');
  });

  if (caretNode?.isConnected && nextCaretOffset !== undefined) {
    const nextRange = globalThis.document.createRange();
    nextRange.setStart(caretNode, Math.min(nextCaretOffset, caretNode.data.length));
    nextRange.collapse(true);
    selection?.removeAllRanges();
    selection?.addRange(nextRange);
  }
};

export const NoticeRichTextEditor = () => {
  const { t } = useTranslation();
  const editorRef = useRef<HTMLDivElement>(null);
  const persistenceTimerRef = useRef<ReturnType<typeof setTimeout> | undefined>(undefined);

  const content = useNoticeSetupStore(state => state.draft.NOTICE_CONTENT);
  const setDraft = useNoticeSetupStore(state => state.setDraft);

  const syncContent = () => {
    if (persistenceTimerRef.current !== undefined) {
      clearTimeout(persistenceTimerRef.current);
      persistenceTimerRef.current = undefined;
    }

    const editor = editorRef.current;
    if (editor) removeFormatTypingMarkers(editor);
    const nextContent = sanitizeNoticeHtml(editor?.innerHTML ?? '');
    setDraft({ NOTICE_CONTENT: nextContent });
  };

  const runCommand = (command: string, value?: string) => {
    editorRef.current?.focus();
    globalThis.document.execCommand(command, false, value);
    syncContent();
  };

  const applyTextFormat = (format: NoticeTextFormat) => {
    const editor = editorRef.current;
    if (!editor) return;

    const selection = globalThis.document.getSelection();
    const currentRange =
      selection?.rangeCount && editor.contains(selection.getRangeAt(0).commonAncestorContainer)
        ? selection.getRangeAt(0).cloneRange()
        : globalThis.document.createRange();

    if (
      !selection?.rangeCount ||
      !editor.contains(selection.getRangeAt(0).commonAncestorContainer)
    ) {
      currentRange.selectNodeContents(editor);
      currentRange.collapse(false);
    }

    const hasSelectedText = !currentRange.collapsed;
    editor.focus();

    if (currentRange.collapsed) {
      const pendingFormatElement =
        currentRange.startContainer.nodeType === globalThis.Node.TEXT_NODE
          ? currentRange.startContainer.parentElement?.closest<HTMLSpanElement>(
              'span[data-notice-format]'
            )
          : undefined;

      if (pendingFormatElement?.textContent === FORMAT_TYPING_MARKER) {
        pendingFormatElement.dataset.noticeFormat = format;
        return;
      }

      const formatElement = globalThis.document.createElement('span');
      formatElement.dataset.noticeFormat = format;
      const typingMarker = globalThis.document.createTextNode(FORMAT_TYPING_MARKER);
      formatElement.append(typingMarker);
      currentRange.insertNode(formatElement);
      currentRange.setStart(typingMarker, typingMarker.data.length);
      currentRange.collapse(true);

      const nextSelection = globalThis.document.getSelection();
      nextSelection?.removeAllRanges();
      nextSelection?.addRange(currentRange);
    } else {
      const selectedTextNodes: { node: Text; start: number; end: number }[] = [];
      const walker = globalThis.document.createTreeWalker(editor, globalThis.NodeFilter.SHOW_TEXT);
      let currentNode = walker.nextNode();

      while (currentNode) {
        const textNode = currentNode as Text;
        if (currentRange.intersectsNode(textNode)) {
          const start = textNode === currentRange.startContainer ? currentRange.startOffset : 0;
          const end =
            textNode === currentRange.endContainer ? currentRange.endOffset : textNode.data.length;
          if (start < end) selectedTextNodes.push({ node: textNode, start, end });
        }
        currentNode = walker.nextNode();
      }

      const formattedElements: HTMLSpanElement[] = [];
      [...selectedTextNodes].reverse().forEach(({ node, start, end }) => {
        const selectedText = start > 0 ? node.splitText(start) : node;
        const selectedLength = end - start;
        if (selectedLength < selectedText.data.length) selectedText.splitText(selectedLength);

        const formatElement = globalThis.document.createElement('span');
        formatElement.dataset.noticeFormat = format;
        selectedText.replaceWith(formatElement);
        formatElement.append(selectedText);
        formattedElements.unshift(formatElement);
      });

      const firstElement = formattedElements[0];
      const lastElement = formattedElements.at(-1);
      if (firstElement && lastElement) {
        currentRange.setStart(firstElement, 0);
        currentRange.setEnd(lastElement, lastElement.childNodes.length);

        const nextSelection = globalThis.document.getSelection();
        nextSelection?.removeAllRanges();
        nextSelection?.addRange(currentRange);
      }
    }

    if (hasSelectedText) syncContent();
  };

  const handleToolbarMouseDown = (event: MouseEvent<HTMLButtonElement>) => {
    event.preventDefault();
  };

  const handleCreateLink = () => {
    const url = globalThis.prompt(t('LBL00832', '_Enter a link URL'), 'https://');
    if (!url) return;

    try {
      const parsedUrl = new URL(url);
      if (!['http:', 'https:', 'mailto:'].includes(parsedUrl.protocol)) return;
      runCommand('createLink', url);
    } catch {
      return;
    }
  };

  const handleInput = (event: FormEvent<HTMLDivElement>) => {
    if (persistenceTimerRef.current !== undefined) {
      clearTimeout(persistenceTimerRef.current);
    }

    if ((event.nativeEvent as InputEvent).isComposing) return;

    removeFormatTypingMarkers(event.currentTarget);
    const nextContent = sanitizeNoticeHtml(event.currentTarget.innerHTML);

    persistenceTimerRef.current = setTimeout(() => {
      setDraft({ NOTICE_CONTENT: nextContent });
      persistenceTimerRef.current = undefined;
    }, 250);
  };

  const handlePaste = (event: ClipboardEvent<HTMLDivElement>) => {
    event.preventDefault();
    const plainText = event.clipboardData.getData('text/plain');
    globalThis.document.execCommand('insertText', false, plainText);
    globalThis.queueMicrotask(syncContent);
  };

  useEffect(
    () => () => {
      if (persistenceTimerRef.current !== undefined) {
        clearTimeout(persistenceTimerRef.current);
      }
    },
    []
  );

  useEffect(() => {
    const editor = editorRef.current;
    const sanitizedContent = sanitizeNoticeHtml(content);
    if (editor && editor.innerHTML !== sanitizedContent) editor.innerHTML = sanitizedContent;
  }, [content]);

  return (
    <div className={styles.editorWrapper}>
      <div className={styles.toolbar} role='toolbar' aria-label={t('LBL00833', '_Text format')}>
        <button
          type='button'
          className={styles.toolbarButton}
          aria-label={t('LBL00834', '_Paragraph')}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => applyTextFormat('p')}
        >
          P
        </button>
        <button
          type='button'
          className={styles.toolbarButton}
          aria-label={`${t('LBL00833', '_Text format')} H1`}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => applyTextFormat('h1')}
        >
          H1
        </button>
        <button
          type='button'
          className={styles.toolbarButton}
          aria-label={t('LBL00835', '_Heading 2')}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => applyTextFormat('h2')}
        >
          H2
        </button>
        <span className={styles.divider} />
        <button
          type='button'
          className={`${styles.toolbarButton} ${styles.bold}`}
          aria-label={t('LBL00837', '_Bold')}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => runCommand('bold')}
        >
          B
        </button>
        <button
          type='button'
          className={`${styles.toolbarButton} ${styles.italic}`}
          aria-label={t('LBL00838', '_Italic')}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => runCommand('italic')}
        >
          I
        </button>
        <button
          type='button'
          className={`${styles.toolbarButton} ${styles.underline}`}
          aria-label={t('LBL00839', '_Underline')}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => runCommand('underline')}
        >
          U
        </button>
        <span className={styles.divider} />
        <button
          type='button'
          className={styles.toolbarButton}
          aria-label={t('LBL00840', '_Bullet list')}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => runCommand('insertUnorderedList')}
        >
          •
        </button>
        <button
          type='button'
          className={styles.toolbarButton}
          aria-label={t('LBL00841', '_Numbered list')}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => runCommand('insertOrderedList')}
        >
          1.
        </button>
        <button
          type='button'
          className={styles.toolbarButton}
          aria-label={t('LBL00842', '_Link')}
          onMouseDown={handleToolbarMouseDown}
          onClick={handleCreateLink}
        >
          ↗
        </button>
        <button
          type='button'
          className={styles.toolbarButton}
          aria-label={t('LBL00843', '_Clear formatting')}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => runCommand('removeFormat')}
        >
          Tx
        </button>
      </div>
      <div
        ref={editorRef}
        className={styles.editor}
        contentEditable
        role='textbox'
        aria-multiline='true'
        aria-label={t('LBL00826', '_Notice Content')}
        suppressContentEditableWarning
        onInput={handleInput}
        onPaste={handlePaste}
        onBlur={syncContent}
      />
    </div>
  );
};
