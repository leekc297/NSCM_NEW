// SDM 공통 승격분 (project-registration/ProjectGrid 원본 — SDM1010/1020/5010 그리드가
// page 경계를 넘어 import 하던 것을 화면군 공통 위치로 이동. 로직 변경 없음).
import { forwardRef, useImperativeHandle, useRef, useState } from 'react';
import { createPortal } from 'react-dom';

import { Tag, type TagColorType } from '@shared/lges';

const TAG_COLOR_TYPES: TagColorType[] = [
  'confirmed',
  'error',
  'warning-minor',
  'warning-major',
  'done',
  'colorA',
  'colorB',
  'colorC',
  'colorD',
  'secondary',
  'primary',
];

/**
 * 서버에서 내려온 COLOR_TYPE이
 * TagColorType에 해당하는 값인지 검사한다.
 *
 * 잘못된 값이면 secondary 사용.
 */
const normalizeTagColorType = (value: unknown): TagColorType => {
  if (typeof value === 'string' && TAG_COLOR_TYPES.includes(value as TagColorType)) {
    return value as TagColorType;
  }

  return 'secondary';
};

/* =========================================================
 * Tag Layer
 * ========================================================= */

interface TagInfo {
  label: string;
  colorType: TagColorType;
  mount: HTMLDivElement;
}

export interface TagLayerHandle {
  apply: (cell: HTMLElement, label: string, colorType: unknown) => void;

  clear: (cell: HTMLElement) => void;
}

/**
 * Wijmo Cell 안에 LGES Tag를 Portal로 렌더링한다.
 *
 * createRoot를 사용하지 않는 이유:
 * 별도 React Root를 생성하면 LGES Design System이 사용하는
 * Theme Context가 끊길 수 있다.
 *
 * createPortal은 현재 React Tree의 Context를 그대로 유지한다.
 */
export const TagLayer = forwardRef<TagLayerHandle>((_props, ref) => {
  const [tags, setTags] = useState(() => new Map<HTMLElement, TagInfo>());

  /**
   * React Portal key용 Cell ID
   */
  const cellIdsRef = useRef(new WeakMap<HTMLElement, number>());

  const nextCellIdRef = useRef(0);

  const getCellId = (cell: HTMLElement) => {
    let id = cellIdsRef.current.get(cell);

    if (id === undefined) {
      id = nextCellIdRef.current++;

      cellIdsRef.current.set(cell, id);
    }

    return id;
  };

  useImperativeHandle(
    ref,
    () => ({
      apply: (cell: HTMLElement, label: string, colorTypeValue: unknown) => {
        const colorType = normalizeTagColorType(colorTypeValue);

        setTags(prev => {
          const current = prev.get(cell);

          /**
           * 기존 mount가 실제로 Wijmo Cell에 남아있는지 검사.
           *
           * Wijmo는 refresh / virtual scroll 과정에서
           * Cell 내부 DOM을 다시 만들 수 있기 때문에
           * React state에 있다고 해서 DOM에도 있다고 볼 수 없다.
           */
          const mountExists = current?.mount.parentElement === cell;

          /**
           * 기존 Mount가 정상적으로 존재
           */
          if (current && mountExists) {
            /**
             * 같은 데이터라면 다시 setState하지 않는다.
             */
            if (current.label === label && current.colorType === colorType) {
              return prev;
            }

            const next = new Map(prev);

            next.set(cell, {
              ...current,
              label,
              colorType,
            });

            return next;
          }

          /**
           * state에는 있지만 Wijmo가 mount DOM을 제거한 경우
           */
          const next = new Map(prev);

          if (current) {
            next.delete(cell);
          }

          /**
           * Tag 전용 DOM 생성
           */
          const mount = document.createElement('div');

          mount.dataset.projectStatusTag = 'true';

          /**
           * 중요:
           *
           * cell.style.position은 절대로 변경하지 않는다.
           *
           * Wijmo Cell은 자체 position 값을 이용해
           * Row / Column 위치를 계산하기 때문에
           * relative로 변경하면 Grid Layout이 깨질 수 있다.
           */
          mount.style.position = 'absolute';
          mount.style.left = '0';
          mount.style.top = '0';
          mount.style.right = '0';
          mount.style.bottom = '0';

          mount.style.display = 'flex';
          mount.style.alignItems = 'center';
          mount.style.justifyContent = 'center';

          mount.style.boxSizing = 'border-box';

          mount.style.pointerEvents = 'none';

          /**
           * Wijmo 기본 문자열보다 위에 표시
           */
          mount.style.zIndex = '1';

          /**
           * 셀의 배경색을 사용해
           * Wijmo 원본 문자열을 가린다.
           *
           * cell.textContent = ''처럼 직접 지우지 않기 때문에
           * Wijmo가 Cell Layout을 다시 계산하는 문제를 피한다.
           */
          const backgroundColor = window.getComputedStyle(cell).backgroundColor;

          mount.style.backgroundColor = backgroundColor;

          cell.appendChild(mount);

          next.set(cell, {
            label,
            colorType,
            mount,
          });

          return next;
        });
      },

      clear: (cell: HTMLElement) => {
        setTags(prev => {
          const current = prev.get(cell);

          if (!current) {
            return prev;
          }

          /**
           * mount가 아직 Cell 안에 존재하면 제거
           */
          if (current.mount.parentElement === cell) {
            current.mount.remove();
          }

          const next = new Map(prev);

          next.delete(cell);

          return next;
        });
      },
    }),
    []
  );

  return (
    <>
      {[...tags.entries()].map(([cell, tag]) =>
        createPortal(
          <Tag colorType={tag.colorType} appearance='boxing'>
            {tag.label}
          </Tag>,
          tag.mount,
          String(getCellId(cell))
        )
      )}
    </>
  );
});

TagLayer.displayName = 'TagLayer';
