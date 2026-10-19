import type { ComponentProps } from 'react';

import { ProcessTab } from '@shared/lges';

import styles from './ProcessFlow.module.scss';

/**
 * SDM 공통 — LGES ProcessTab(Complex) 래퍼.
 *
 * 단계별 진행 건수/진행률을 표시하는 프로세스 흐름 바.
 * SDM 화면들은 "지연" 영역을 쓰지 않는데 LGES 컴포넌트에는
 * 이를 끄는 prop이 없어 래퍼 CSS로 숨긴다(모듈 scss 참고).
 */
export const ProcessFlow = (props: ComponentProps<typeof ProcessTab>) => (
  <div className={styles.processFlow}>
    <ProcessTab appearance='complex' {...props} />
  </div>
);
