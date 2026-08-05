package com.lgcns.nscm.framework.interceptor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * SQL 실행 로그를 비동기로 기록하는 워커.
 * <ul>
 *   <li>offer(): 요청 스레드가 호출. 논블로킹. 큐가 가득 차면 가장 오래된 로그를 버린다(drop-oldest).</li>
 *   <li>워커 스레드: 큐를 배치로 drain 하여 전용 DataSource 로 batch insert.</li>
 * </ul>
 * 로그는 부가기능이므로 어떤 실패도 예외로 전파하지 않는다(업무 로직 우선).
 * DataSource 는 업무 풀과 분리된 로그 전용 풀을 주입받아, 로깅이 업무 커넥션과 경쟁하지 않게 한다.
 */
public class SqlLogWriter implements AutoCloseable {

    private static final Logger log = LoggerFactory.getLogger(SqlLogWriter.class);

    static final String INSERT_SQL =
            "INSERT INTO SCM_COM_SQL_LOG " +
            " (SQL_ID, SQL_TYPE, SQL_TEXT, ELAPSED_MS, EXECUTE_TIME, CREATED_BY, PARAMS, RESULT_COUNT, EXCEPTION) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private final DataSource dataSource;
    private final int batchSize;
    private final long flushIntervalMs;
    private final BlockingQueue<SqlLogRecord> queue;
    private final AtomicLong droppedCount = new AtomicLong();

    private volatile boolean running = true;
    private Thread worker;
    private long lastReportedDropped = 0;

    public SqlLogWriter(DataSource dataSource, int queueCapacity, int batchSize, long flushIntervalMs) {
        this.dataSource = dataSource;
        this.batchSize = batchSize;
        this.flushIntervalMs = flushIntervalMs;
        this.queue = new ArrayBlockingQueue<>(queueCapacity);
    }

    /** 데몬 워커 스레드 기동. 애플리케이션 시작 시 1회 호출한다. */
    public void start() {
        this.running = true;
        this.worker = new Thread(this::run, "sql-log-writer");
        this.worker.setDaemon(true);
        this.worker.start();
    }

    /** 요청 스레드에서 호출. 논블로킹, 큐 full 시 오래된 것부터 버린다. */
    public void offer(SqlLogRecord record) {
        while (!queue.offer(record)) {
            if (queue.poll() != null) {
                droppedCount.incrementAndGet();
            }
        }
    }

    private void run() {
        List<SqlLogRecord> batch = new ArrayList<>(batchSize);
        while (running) {
            try {
                SqlLogRecord first = queue.poll(flushIntervalMs, TimeUnit.MILLISECONDS);
                if (first != null) {
                    batch.add(first);
                    queue.drainTo(batch, batchSize - 1);
                    flush(batch);
                    batch.clear();
                }
                reportDroppedIfNeeded();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }
    }

    private void reportDroppedIfNeeded() {
        long dropped = droppedCount.get();
        if (dropped > lastReportedDropped) {
            log.warn("dropped {} sql-logs (queue full). total dropped={}", dropped - lastReportedDropped, dropped);
            lastReportedDropped = dropped;
        }
    }

    /** 한 커넥션에서 batch insert. 실패해도 예외를 전파하지 않는다(로그는 부가기능). */
    void flush(List<SqlLogRecord> batch) {
        if (batch.isEmpty()) {
            return;
        }
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {

            conn.setAutoCommit(false);
            for (SqlLogRecord r : batch) {
                ps.setString(1, r.sqlId());
                ps.setString(2, r.sqlType());
                ps.setString(3, r.sqlText());
                ps.setInt(4, r.elapsedMs());
                ps.setTimestamp(5, Timestamp.valueOf(r.executeTime()));
                ps.setString(6, r.userId());
                ps.setString(7, r.paramsJson());
                if (r.resultCount() < 0) {
                    ps.setNull(8, java.sql.Types.INTEGER);
                } else {
                    ps.setInt(8, r.resultCount());
                }
                ps.setString(9, r.exceptionMsg());
                ps.addBatch();
            }
            ps.executeBatch();
            conn.commit();
        } catch (Exception e) {
            log.warn("Failed to batch-insert SCM_COM_SQL_LOG. size={}, error={}", batch.size(), e.getMessage());
        }
    }

    int queueSize() {
        return queue.size();
    }

    public long getDroppedCount() {
        return droppedCount.get();
    }

    @Override
    public void close() {
        running = false;
        if (worker != null) {
            worker.interrupt();
            try {
                worker.join(2000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
        // 남은 큐를 배치 단위로 끝까지 flush
        List<SqlLogRecord> remaining = new ArrayList<>();
        queue.drainTo(remaining);
        for (int i = 0; i < remaining.size(); i += batchSize) {
            flush(remaining.subList(i, Math.min(i + batchSize, remaining.size())));
        }
    }
}
