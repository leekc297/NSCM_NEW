import type { FlexChart } from '@mescius/wijmo.chart';

export interface GanttTask {
  index?: number; // repeatAxis용. 같은 index끼리 한 줄에 그림
  name: string;
  start: Date;
  end: Date;
  parent?: string; // 'Task3,Task4' 처럼 콤마로 여러 개 가능
  percent?: number;
}

interface GanttRect {
  left: number;
  top: number;
  width: number;
  height: number;
  bottom: number;
}

// itemFormatter, tooltip, rendered 콜백에서 사용
interface GanttHit {
  item: GanttTask;
  series: { chart: FlexChart };
  engine: {
    fill: string;
    drawRect: (x: number, y: number, w: number, h: number) => void;
    drawLines: (xs: number[], ys: number[], cls: string, style: Record<string, string>) => void;
    drawPolygon: (xs: number[], ys: number[], cls: string, style: Record<string, string>) => void;
  };
}

const addDays = (date: Date, days: number) => {
  const d = new Date(date);
  d.setDate(d.getDate() + days);
  return d;
};

const formatGanttDate = (date: Date) =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;

// 더미데이터 생성
const createGanttTasks = (): GanttTask[] => {
  const year = new Date().getFullYear();
  return [
    { name: 'Task1', start: new Date(year, 0, 1), end: new Date(year, 2, 31), percent: 100 },
    {
      name: 'Task2',
      start: new Date(year, 3, 1),
      end: new Date(year, 3, 30),
      parent: 'Task1',
      percent: 100,
    },
    {
      name: 'Task3',
      start: new Date(year, 4, 1),
      end: new Date(year, 6, 31),
      parent: 'Task2',
      percent: 75,
    },
    {
      name: 'Task4',
      start: new Date(year, 3, 1),
      end: new Date(year, 6, 31),
      parent: 'Task1',
      percent: 33,
    },
    {
      name: 'Task5',
      start: new Date(year, 7, 1),
      end: new Date(year, 8, 30),
      parent: 'Task3,Task4',
      percent: 0,
    },
    {
      name: 'Task6',
      start: new Date(year, 9, 1),
      end: new Date(year, 11, 31),
      parent: 'Task1,Task5',
      percent: 0,
    },
    { name: 'Task7', start: new Date(year, 0, 1), end: new Date(year, 11, 31), percent: 50 },
  ];
};

const createRepeatGanttTasks = (): GanttTask[] => {
  const startDt = new Date(new Date().getFullYear(), 6, 1);
  const tasks: GanttTask[] = [
    { index: 0, name: 'Regular Task1', start: addDays(startDt, 1), end: addDays(startDt, 5) },
    { index: 1, name: 'Regular Task2', start: addDays(startDt, 4), end: addDays(startDt, 12) },
    { index: 2, name: 'Regular Task3', start: addDays(startDt, 10), end: addDays(startDt, 18) },
  ];

  for (let i = 0; i < 5; i += 1) {
    tasks.push(
      {
        index: 3,
        name: 'Repeating Task1',
        start: addDays(startDt, i * 7),
        end: addDays(startDt, i * 7 + 1),
      },
      {
        index: 4,
        name: 'Repeating Task2',
        start: addDays(startDt, i * 7 + 2),
        end: addDays(startDt, i * 7 + 4),
      }
    );
  }
  return tasks;
};

export const ganttTasks = createGanttTasks();
export const repeatGanttTasks = createRepeatGanttTasks();

// Wijmo 사이트 샘플 코드는 indexOf를 사용했지만, 데이터 많으면 속도 이슈 생길 것 같아서 Map사용
const taskIndexCache = new Map<FlexChart, Map<GanttTask, number>>();

const getTaskRow = (chart: FlexChart, task: GanttTask) => {
  let cache = taskIndexCache.get(chart);
  if (!cache) {
    cache = new Map();
    (chart.collectionView.items as GanttTask[]).forEach((t, i) => cache!.set(t, i));
    taskIndexCache.set(chart, cache);
  }
  return cache.get(task) ?? 0;
};

const getTaskRect = (chart: FlexChart, task: GanttTask): GanttRect => {
  const row = getTaskRow(chart, task);
  const left = chart.axisX.convert(task.start.valueOf());
  const right = chart.axisX.convert(task.end.valueOf());
  // 0.35: 막대 두께 (행 하나를 1로 봤을 때 위아래 여백 남기는 값)
  const top = chart.axisY.convert(row - 0.35);
  const bottom = chart.axisY.convert(row + 0.35);

  return { left, top, width: right - left, height: bottom - top, bottom };
};

export const getGanttTooltipContent = (hitTestInfo: unknown) => {
  const task = (hitTestInfo as GanttHit).item;
  if (!task) return '';

  const progress = task.percent != null ? `<br/>진행률: ${task.percent}%` : '';
  return `<b>${task.name}</b><br/>${formatGanttDate(task.start)} - ${formatGanttDate(task.end)}${progress}`;
};

// repeatAxis 켰을 때 Y축에 0,1,2... 대신 작업명 나오게
export const formatRepeatGanttAxisLabel =
  (tasks: GanttTask[]) => (_engine: unknown, label: unknown) => {
    const axisLabel = label as { val: number; text: string };
    const task = tasks.find(t => t.index === axisLabel.val);
    if (task) axisLabel.text = task.name;
    return axisLabel;
  };

export const renderGanttProgress = (
  engine: unknown,
  hitTestInfo: unknown,
  defaultFormatter: () => void
) => {
  defaultFormatter();

  const hit = hitTestInfo as GanttHit;
  const task = hit.item;
  const chart = hit.series.chart;
  const renderEngine = engine as NonNullable<GanttHit['engine']>;

  if (!task || !chart || !task.percent) return;

  const rect = getTaskRect(chart, task);
  //작업 막대 안 작업률 막대 패딩
  const pad = 8;
  renderEngine.fill = task.percent >= 100 ? '#2e7d32' : '#f9a825'; // 진행률 100이면 녹색, 아니면 노란색
  renderEngine.drawRect(
    rect.left + pad,
    rect.top + pad,
    (rect.width - pad * 2) * (task.percent / 100),
    rect.height - pad * 2
  );
};

const getParentTasks = (items: GanttTask[], task: GanttTask) =>
  (task.parent ?? '')
    .split(',')
    .map(name => items.find(t => t.name === name.trim()))
    .filter((t): t is GanttTask => !!t);

export const renderGanttDependencies = (chart: FlexChart, eventArgs: unknown) => {
  const engine = (eventArgs as GanttHit).engine;
  if (!engine) return;

  const items = chart.collectionView.items as GanttTask[];

  items.forEach(task => {
    getParentTasks(items, task).forEach(parent => {
      const p = getTaskRect(chart, parent);
      const c = getTaskRect(chart, task);
      const arrow = 5;
      const x = p.left + p.width / 2;
      const y1 = p.bottom;
      const y2 = c.top + c.height / 2;

      engine.drawLines([x, x, c.left], [y1, y2, y2], 'gantt-connector', { stroke: 'black' });
      engine.drawPolygon(
        [c.left - arrow * 2, c.left, c.left - arrow * 2],
        [y2 - arrow, y2, y2 + arrow],
        'gantt-arrow',
        { fill: 'black' }
      );
    });
  });
};
