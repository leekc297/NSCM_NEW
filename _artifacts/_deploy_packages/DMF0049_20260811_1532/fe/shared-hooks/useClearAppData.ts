import { useQueryClient } from '@foundation/query-client';

import { resetAllStores } from '../stores/storeRegistry';

export const useClearAppData = () => {
  const queryClient = useQueryClient();

  const clearAllData = () => {
    resetAllStores();
    queryClient.clear();
    sessionStorage.clear();
  };

  return { clearAllData };
};
