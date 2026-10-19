import { CustomDialog } from '@shared/components';

import styles from './PlaceholderPopup.module.scss';

// supply 공통 팝업의 공통 prop 계약 (스켈레톤 단계).
//   onSelect 반환 타입과 조회 파라미터는 SP·컬럼이 확정된 뒤 각 팝업에서 구체화한다.
export interface SupplyPopupProps {
  open: boolean;
  // 닫기 (X / Cancel)
  onClose: () => void;
  // OK 확정 시 선택값 반환 — 반환 타입은 설계 확정 후 구체화
  onSelect?: (selected: unknown) => void;
  // 호출 변형 라벨 (예: 프1, 프2) — 지금은 헤더에 표시만, 이후 조회 파라미터로 확장
  variant?: string;
  // 호출 화면이 넘기는 조회 파라미터 (지금은 하드코딩) — 실제 구현 시 조회 SP 로 전달
  params?: Record<string, unknown>;
}

interface PlaceholderPopupProps extends SupplyPopupProps {
  // 팝업 제목 (예: Model by Division)
  title: string;
  // 본문 안내 문구 (미지정 시 기본 문구)
  description?: string;
}

// 아직 SP·컬럼·반환값이 확정되지 않은 supply 공통 팝업의 임시 뼈대.
//   CustomDialog 셸(헤더 + OK/Close)만 제공하고 본문은 placeholder 다.
//   각 팝업을 실제 구현할 때 이 컴포넌트 대신 SearchArea + DataGrid 로 교체한다.
export const PlaceholderPopup = ({
  open,
  onClose,
  onSelect,
  variant,
  params,
  title,
  description,
}: PlaceholderPopupProps) => (
  <CustomDialog
    size={720}
    type='modal'
    position='basic'
    open={open}
    title={variant ? `${title} (${variant})` : title}
    handleClose={onClose}
    handleSubmit={() => onSelect?.(null)}
    customContentArea={
      <div className={styles.placeholder}>
        <p className={styles.title}>{title} 팝업 (스켈레톤)</p>
        <p className={styles.hint}>
          {description ?? '조회조건 · 그리드 · 반환값은 설계 확정 후 구현합니다.'}
        </p>
        {variant ? <p className={styles.variant}>호출 라벨: {variant}</p> : null}
        {params ? (
          <pre className={styles.params}>{JSON.stringify(params, null, 2)}</pre>
        ) : null}
      </div>
    }
  />
);
