CREATE OR REPLACE FUNCTION attach_audit_trigger(table_name text)
RETURNS void AS $$
BEGIN
  EXECUTE format(
    'CREATE TRIGGER audit_%I_changes AFTER INSERT OR UPDATE OR DELETE ON %I
     FOR EACH ROW EXECUTE FUNCTION audit_row_changes()',
    table_name,
    table_name
  );
END;
$$ LANGUAGE plpgsql;

SELECT attach_audit_trigger('roles');
SELECT attach_audit_trigger('permissions');
SELECT attach_audit_trigger('role_permissions');
SELECT attach_audit_trigger('users');
SELECT attach_audit_trigger('login_history');
SELECT attach_audit_trigger('customers');
SELECT attach_audit_trigger('customer_accounts');
SELECT attach_audit_trigger('customer_transactions');
SELECT attach_audit_trigger('containers');
SELECT attach_audit_trigger('bl_information');
SELECT attach_audit_trigger('container_status');
SELECT attach_audit_trigger('container_routes');
SELECT attach_audit_trigger('container_tracking');
SELECT attach_audit_trigger('container_expenses');
SELECT attach_audit_trigger('drivers');
SELECT attach_audit_trigger('trucks');
SELECT attach_audit_trigger('truck_loads');
SELECT attach_audit_trigger('truck_expenses');
SELECT attach_audit_trigger('exchange_offices');
SELECT attach_audit_trigger('exchange_transactions');
SELECT attach_audit_trigger('border_offices');
SELECT attach_audit_trigger('border_transactions');
SELECT attach_audit_trigger('border_expenses');
SELECT attach_audit_trigger('border_payments');
SELECT attach_audit_trigger('invoices');
SELECT attach_audit_trigger('invoice_items');
SELECT attach_audit_trigger('payments');
SELECT attach_audit_trigger('accounts');
SELECT attach_audit_trigger('journal_entries');
SELECT attach_audit_trigger('journal_entry_lines');
