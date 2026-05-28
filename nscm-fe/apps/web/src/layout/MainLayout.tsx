import { clsx } from '@shared/clsx';

import { MDIContainer } from '../mdi/MDIContainer';

import { Header } from './header/Header';
import styles from './MainLayout.module.scss';
import { Sidebar } from './sidebar/Sidebar';

export const MainLayout = () => {
  return (
    <>
      <Header />
      <div className={clsx(styles.layoutContent, { [styles.showMenu]: true })}>
        <Sidebar />
        <main className={styles.pageContent}>
          <MDIContainer />
        </main>
      </div>
    </>
  );
};
