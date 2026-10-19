import { useEffect, useRef, type ClipboardEvent, type FormEvent, type MouseEvent } from 'react';

import { sanitizeNoticeHtml } from '../notice-setup.util';
import { useNoticeSetupStore } from '../useNoticeSetupStore';

import styles from './NoticeRichTextEditor.module.scss';

type NoticeTextFormat = 'p' | 'h1' | 'h2';
const FORMAT_TYPING_MARKER = '\u200B';
const NOTICE_STYLE_TAGS = new Set(['B', 'STRONG', 'I', 'EM', 'U']);

type NoticeStyleKind = 'bold' | 'italic' | 'underline';
// bold/italic/underline 은 이제 native execCommand 대신 자체 span(data-notice-bold 등)으로 관리한다.
const NOTICE_STYLE_DATA_KEY: Record<NoticeStyleKind, string> = {
  bold: 'noticeBold',
  italic: 'noticeItalic',
  underline: 'noticeUnderline',
};

const isNoticeFormatSpan = (element: Element): boolean =>
  element.tagName === 'SPAN' && !!(element as HTMLElement).dataset.noticeFormat;

const getNoticeStyleKind = (element: Element): NoticeStyleKind | undefined => {
  if (element.tagName !== 'SPAN') return undefined;
  const dataset = (element as HTMLElement).dataset;
  if (dataset.noticeBold) return 'bold';
  if (dataset.noticeItalic) return 'italic';
  if (dataset.noticeUnderline) return 'underline';
  return undefined;
};

const isKnownInlineDecorator = (element: Element): boolean =>
  isNoticeFormatSpan(element) || getNoticeStyleKind(element) !== undefined;

// range 시작 지점의 실제 렌더링 상태(computed style)로 굵게/기울임/밑줄 여부를 판정한다.
// native queryCommandState 는 커스텀 span 이 만든 스타일을 항상 정확히 인식한다고 보장할 수 없어
// 직접 getComputedStyle 로 판정한다 - H1 처럼 CSS 로만 굵게인 경우도 정확히 잡아낸다.
const isStyleActiveAt = (node: Node, kind: NoticeStyleKind): boolean => {
  const element = node.nodeType === globalThis.Node.ELEMENT_NODE ? (node as Element) : node.parentElement;
  if (!element) return false;
  const computed = globalThis.getComputedStyle(element);
  if (kind === 'bold') {
    return computed.fontWeight === 'bold' || Number.parseInt(computed.fontWeight, 10) >= 600;
  }
  if (kind === 'italic') return computed.fontStyle === 'italic';
  return computed.textDecorationLine.includes('underline');
};

// textNode 를 감싼 인라인 조상(크기 span + 다른 굵게/기울임/밑줄 span)들을 훑어, kind 에 해당하는
// span 만 제거 대상으로 삼고 나머지는 그대로 보존한 뒤, 맨 안쪽에 새 kind span(on/off 명시)을 씌운다.
const applyNoticeStyle = (
  textNode: Text,
  editor: HTMLDivElement,
  kind: NoticeStyleKind,
  turnOn: boolean
) => {
  type KeptAncestor =
    | { type: 'format'; value: string }
    | { type: 'style'; kind: NoticeStyleKind; value: string };
  const kept: KeptAncestor[] = [];

  let boundaryChild: Node = textNode;
  let ancestor = textNode.parentElement;

  while (ancestor && ancestor !== editor && isKnownInlineDecorator(ancestor)) {
    const formatValue = isNoticeFormatSpan(ancestor) ? ancestor.dataset.noticeFormat : undefined;
    const styleKind = getNoticeStyleKind(ancestor);

    if (formatValue) {
      kept.push({ type: 'format', value: formatValue });
    } else if (styleKind && styleKind !== kind) {
      kept.push({
        type: 'style',
        kind: styleKind,
        value: ancestor.dataset[NOTICE_STYLE_DATA_KEY[styleKind]] as string,
      });
    }

    boundaryChild = ancestor;
    ancestor = ancestor.parentElement;
  }

  // textNode 를 옮기기 전에 삽입 기준점을 미리 확보한다 (boundaryChild 가 detach 될 수 있어서).
  const spliceParent = boundaryChild.parentElement ?? editor;
  const insertionRef = boundaryChild.nextSibling;
  const originalParent = textNode.parentElement;

  let rebuilt: Node = textNode;

  const styleElement = globalThis.document.createElement('span');
  styleElement.dataset[NOTICE_STYLE_DATA_KEY[kind]] = turnOn ? 'on' : 'off';
  styleElement.append(rebuilt);
  rebuilt = styleElement;

  kept.forEach(entry => {
    const element = globalThis.document.createElement('span');
    if (entry.type === 'format') element.dataset.noticeFormat = entry.value;
    else element.dataset[NOTICE_STYLE_DATA_KEY[entry.kind]] = entry.value;
    element.append(rebuilt);
    rebuilt = element;
  });

  spliceParent.insertBefore(rebuilt, insertionRef);

  let cursor = originalParent;
  while (cursor && cursor !== spliceParent && cursor.childNodes.length === 0) {
    const next = cursor.parentElement;
    cursor.remove();
    cursor = next;
  }
};

const applyNoticeFormat = (
  textNode: Text,
  editor: HTMLDivElement,
  format: NoticeTextFormat
): HTMLSpanElement => {
  const kept: { kind: NoticeStyleKind; value: string }[] = [];

  let boundaryChild: Node = textNode;
  let ancestor = textNode.parentElement;

  while (ancestor && ancestor !== editor && isKnownInlineDecorator(ancestor)) {
    const styleKind = getNoticeStyleKind(ancestor);
    if (styleKind) {
      kept.push({ kind: styleKind, value: ancestor.dataset[NOTICE_STYLE_DATA_KEY[styleKind]] as string });
    }

    boundaryChild = ancestor;
    ancestor = ancestor.parentElement;
  }

  const spliceParent = boundaryChild.parentElement ?? editor;
  const insertionRef = boundaryChild.nextSibling;
  const originalParent = textNode.parentElement;

  let rebuilt: Node = textNode;
  kept.forEach(entry => {
    const element = globalThis.document.createElement('span');
    element.dataset[NOTICE_STYLE_DATA_KEY[entry.kind]] = entry.value;
    element.append(rebuilt);
    rebuilt = element;
  });

  const formatElement = globalThis.document.createElement('span');
  formatElement.dataset.noticeFormat = format;
  formatElement.append(rebuilt);

  spliceParent.insertBefore(formatElement, insertionRef);

  let cursor = originalParent;
  while (cursor && cursor !== spliceParent && cursor.childNodes.length === 0) {
    const next = cursor.parentElement;
    cursor.remove();
    cursor = next;
  }

  return formatElement;
};

const clearInlineStyling = (textNode: Text, editor: HTMLDivElement) => {
  let preservedFormat: NoticeTextFormat | undefined;
  let boundaryChild: Node = textNode;
  let ancestor = textNode.parentElement;

  while (ancestor && ancestor !== editor) {
    const formatSpan = isNoticeFormatSpan(ancestor);
    const styleTag =
      NOTICE_STYLE_TAGS.has(ancestor.tagName) || (ancestor.tagName === 'SPAN' && !formatSpan);
    if (!formatSpan && !styleTag) break;

    if (formatSpan && preservedFormat === undefined) {
      preservedFormat = ancestor.dataset.noticeFormat as NoticeTextFormat;
    }
    boundaryChild = ancestor;
    ancestor = ancestor.parentElement;
  }

  if (boundaryChild === textNode) return;

  const originalParent = textNode.parentElement;
  const spliceParent = boundaryChild.parentElement ?? editor;

  let rebuilt: Node = textNode;

  // H1/H2 는 포맷 자체에 font-weight:700 이 내장돼 있어(2026-09-16 사용자 신고 - Tx 눌러도 안 얇아짐),
  // 굵게 span 을 따로 두르지 않았어도 여전히 굵게 보인다. 명시적으로 얇게 강제하는 span 을 하나 더 씌운다.
  if (preservedFormat === 'h1' || preservedFormat === 'h2') {
    const boldOffElement = globalThis.document.createElement('span');
    boldOffElement.dataset.noticeBold = 'off';
    boldOffElement.append(rebuilt);
    rebuilt = boldOffElement;
  }

  if (preservedFormat) {
    const formatElement = globalThis.document.createElement('span');
    formatElement.dataset.noticeFormat = preservedFormat;
    formatElement.append(rebuilt);
    rebuilt = formatElement;
  }

  spliceParent.insertBefore(rebuilt, boundaryChild);

  let cursor = originalParent;
  while (cursor && cursor !== spliceParent && cursor.childNodes.length === 0) {
    const next = cursor.parentElement;
    cursor.remove();
    cursor = next;
  }
};

const collectSplitSelectedTextNodes = (range: Range, editor: HTMLDivElement): Text[] => {
  const matches: { node: Text; start: number; end: number }[] = [];
  const walker = globalThis.document.createTreeWalker(editor, globalThis.NodeFilter.SHOW_TEXT);
  let currentNode = walker.nextNode();

  while (currentNode) {
    const textNode = currentNode as Text;
    if (range.intersectsNode(textNode)) {
      const start = textNode === range.startContainer ? range.startOffset : 0;
      const end = textNode === range.endContainer ? range.endOffset : textNode.data.length;
      if (start < end) matches.push({ node: textNode, start, end });
    }
    currentNode = walker.nextNode();
  }

  const isolated: Text[] = [];
  [...matches].reverse().forEach(({ node, start, end }) => {
    const selectedText = start > 0 ? node.splitText(start) : node;
    const selectedLength = end - start;
    if (selectedLength < selectedText.data.length) selectedText.splitText(selectedLength);
    isolated.unshift(selectedText);
  });

  return isolated;
};

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
    const editor = editorRef.current;
    if (!editor) return;

    // focus() 가 드래그 선택(파란 박스)을 풀고 커서를 맨 앞으로 옮기는 경우가 있어(2026-09-16 사용자
    // 신고), focus 전에 선택 range 를 저장해뒀다가 focus 직후 그대로 복원한다.
    const selection = globalThis.document.getSelection();
    const savedRange =
      selection?.rangeCount && editor.contains(selection.getRangeAt(0).commonAncestorContainer)
        ? selection.getRangeAt(0).cloneRange()
        : undefined;

    editor.focus();

    if (savedRange) {
      selection?.removeAllRanges();
      selection?.addRange(savedRange);
    }

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
      const selectedTextNodes = collectSplitSelectedTextNodes(currentRange, editor);

      const formattedElements: HTMLSpanElement[] = [];
      selectedTextNodes.forEach(selectedText => {
        formattedElements.push(applyNoticeFormat(selectedText, editor, format));
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

  // Tx (서식 지우기) - 굵게/기울임/밑줄 스타일은 전부 제거하되, H1/H2 로 지정된 글자 크기는 유지한다.
  // 선택 영역이 없으면(캐럿만 있으면) 이후 입력될 글자의 서식 상태만 native 명령으로 초기화한다.
  const clearNoticeFormatting = () => {
    const editor = editorRef.current;
    if (!editor) return;

    const selection = globalThis.document.getSelection();
    if (
      !selection?.rangeCount ||
      !editor.contains(selection.getRangeAt(0).commonAncestorContainer)
    ) {
      return;
    }

    const range = selection.getRangeAt(0);
    if (range.collapsed) {
      runCommand('removeFormat');
      return;
    }

    editor.focus();
    const selectedTextNodes = collectSplitSelectedTextNodes(range, editor);
    selectedTextNodes.forEach(textNode => clearInlineStyling(textNode, editor));

    const firstNode = selectedTextNodes[0];
    const lastNode = selectedTextNodes.at(-1);
    if (firstNode && lastNode) {
      const nextRange = globalThis.document.createRange();
      nextRange.setStartBefore(firstNode);
      nextRange.setEndAfter(lastNode);
      selection.removeAllRanges();
      selection.addRange(nextRange);
    }

    syncContent();
  };

  // 굵게/기울임/밑줄 토글 - 선택 영역이 있으면 computed style 로 현재 상태를 판정해 자체 span 으로
  // 토글하고(H1 처럼 CSS 로만 굵은 경우도 정확히 잡아냄), 캐럿만 있으면 기존처럼 native 명령으로
  // 다음 입력 서식만 예약한다.
  const handleToggleStyle = (kind: NoticeStyleKind) => {
    const editor = editorRef.current;
    if (!editor) return;

    const selection = globalThis.document.getSelection();
    if (
      !selection?.rangeCount ||
      !editor.contains(selection.getRangeAt(0).commonAncestorContainer)
    ) {
      return;
    }

    const range = selection.getRangeAt(0);
    if (range.collapsed) {
      runCommand(kind);
      return;
    }

    const turnOn = !isStyleActiveAt(range.startContainer, kind);
    const clonedRange = range.cloneRange();

    editor.focus();
    // focus() 가 드래그 선택을 풀 수 있어 곧바로 같은 range 를 재적용한다.
    selection.removeAllRanges();
    selection.addRange(clonedRange);

    const selectedTextNodes = collectSplitSelectedTextNodes(clonedRange, editor);
    selectedTextNodes.forEach(textNode => applyNoticeStyle(textNode, editor, kind, turnOn));

    const firstNode = selectedTextNodes[0];
    const lastNode = selectedTextNodes.at(-1);
    if (firstNode && lastNode) {
      const nextRange = globalThis.document.createRange();
      nextRange.setStartBefore(firstNode);
      nextRange.setEndAfter(lastNode);
      selection.removeAllRanges();
      selection.addRange(nextRange);
    }

    syncContent();
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
          onClick={() => handleToggleStyle('bold')}
        >
          B
        </button>
        <button
          type='button'
          className={`${styles.toolbarButton} ${styles.italic}`}
          aria-label={t('LBL00838', '_Italic')}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => handleToggleStyle('italic')}
        >
          I
        </button>
        <button
          type='button'
          className={`${styles.toolbarButton} ${styles.underline}`}
          aria-label={t('LBL00839', '_Underline')}
          onMouseDown={handleToolbarMouseDown}
          onClick={() => handleToggleStyle('underline')}
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
          onClick={clearNoticeFormatting}
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
