-- 1. Accounts Table: Holds current user balances
CREATE TABLE accounts (
    user_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    balance NUMERIC(15, 2) DEFAULT 0.00
);
 
-- 2. DailyTrades Table: Holds pending trades for the current day
CREATE TABLE daily_trades (
    trade_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES accounts(user_id),
    symbol TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    price_at_execution NUMERIC(12, 2) NOT NULL,
    profit_loss NUMERIC(12, 2) NOT NULL, -- Calculated during execution
    status TEXT DEFAULT 'Pending'       -- 'Pending' or 'Processed'
);
 -- 3. TradesHistory Table: Archive for processed trades
CREATE TABLE trades_history (
    trade_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    symbol TEXT,
    quantity INTEGER,
    profit_loss NUMERIC(12, 2),
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
-- 4. ProcessLog Table: Audit trail for the reconciliation process
CREATE TABLE process_log (
    log_id SERIAL PRIMARY KEY,
    process_name TEXT DEFAULT 'End-of-Day Reconciliation',
    trades_count INTEGER,
    status TEXT,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
-- Insert Sample Data
INSERT INTO accounts (username, balance) VALUES ('trader_alpha', 10000.00), ('trader_beta', 5000.00);
INSERT INTO daily_trades (user_id, symbol, quantity, price_at_execution, profit_loss, status) 
VALUES (1, 'AAPL', 10, 150.00, 500.00, 'Pending'), (2, 'TSLA', 5, 700.00, -200.00, 'Pending');
 
SELECT * from accounts;
select * from daily_trades;
select * from process_log;
select * from trades_history;

create OR REPLACE PROCEDURE sp_ReconcileDailyTrades()
LANGUAGE plpgsql
AS $$
DECLARE
    trade_record RECORD;
    v_trades_count INTEGER;
BEGIN
    select count(*) into v_trades_count from daily_trades where status='pending';

    INSERT INTO process_log(trades_count,status,message)
    VALUES(v_trades_count,'started','starting reconciliation for'||v_trades_count||'trades.');

    FOR trade_record IN
        select * from daily_trades WHERE status='pending'
    loop
        update accounts 
        set balance = balance+ trade_record.profit_loss
        where userd_id = trade_record.user_id;

       -- ARCHIVE Trade: Move data to the history table
        INSERT INTO trades_history (trade_id, user_id, symbol, quantity, profit_loss)
        VALUES (trade_record.trade_id, trade_record.user_id, trade_record.symbol, trade_record.quantity, trade_record.profit_loss);
 
		-- UPDATE Status: Mark as processed (Ensures idempotency if run again)
        UPDATE daily_trades 
        SET status = 'Processed' 
        WHERE trade_id = trade_record.trade_id;

        		 -- ARCHIVE Trade: Move data to the history table
        INSERT INTO trades_history (trade_id, user_id, symbol, quantity, profit_loss)
        VALUES (trade_record.trade_id, trade_record.user_id, trade_record.symbol, trade_record.quantity, trade_record.profit_loss);
 
		-- UPDATE Status: Mark as processed (Ensures idempotency if run again)
        UPDATE daily_trades 
        SET status = 'Processed' 
        WHERE trade_id = trade_record.trade_id;

	 END LOOP;
	 -- 3. COMMIT: Save all changes if the loop completes without error
     INSERT INTO process_log (trades_count, status, message) 
     VALUES (v_trades_count, 'SUCCESS', 'All trades processed and committed.');
     COMMIT;
 
	 EXCEPTION
    -- 4. ERROR HANDLING: Rollback if any step fails
    WHEN OTHERS THEN
        ROLLBACK;
        -- Log the failure to the audit trail
        -- Note: Logging here requires a separate transaction/independent table if using older Postgres versions, 
        -- but in this procedure, we log the failure after the rollback.
        INSERT INTO process_log (status, message) 
        VALUES ('FAILED', 'Error encountered. Entire transaction rolled back. Error: ' || SQLERRM);
        COMMIT; -- Commit the log entry itself
END;
$$;

REVOKE all ON PROCEDURE sp_ReconcileDailyTrades() FROM public;

call sp_ReconcileDailyTrades();