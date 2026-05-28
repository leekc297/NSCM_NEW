import { i18n, I18nextProvider } from '@foundation/i18n';
import { queryClient, PersistQueryClientProvider, idbPersister } from '@foundation/query-client';
import { ThemeSwitchProvider } from '@shared/lges';

interface ProvidersProps {
  children: React.ReactNode;
}

export const Providers = ({ children }: ProvidersProps) => {
  return (
    <PersistQueryClientProvider
      client={queryClient}
      persistOptions={{ persister: idbPersister, maxAge: 1000 * 60 * 60 * 8 }}
    >
      <I18nextProvider i18n={i18n}>
        <ThemeSwitchProvider initialThemeMode='system'>{children}</ThemeSwitchProvider>
      </I18nextProvider>
    </PersistQueryClientProvider>
  );
};
