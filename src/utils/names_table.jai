NamesTable :: struct {
    names            : Table(string, bool); // bool is just a dummy value type, we don't need it, but Table logic does
    lock             : Platform_RWLock;
    lock_initialized : bool;
}

addNameIfNew :: (table : *NamesTable, name : string) {
    if !atomic_swap(*table.lock_initialized, true) {
        platform_create_rwlock(*table.lock);
    }

    platform_lock_rwlock_scoped(*table.lock);

    if !table_contains(*table.names, name) {
        table_add(*table.names, copy_string(name), true);
    }
}

removeName :: (table : *NamesTable, name : string) -> bool {
    if !atomic_swap(*table.lock_initialized, true) {
        platform_create_rwlock(*table.lock);
    }

    platform_lock_rwlock_scoped(*table.lock);

    return table_remove(*table.names, name);
}

containsName :: (table : *NamesTable, name : string) -> bool {
    if !atomic_swap(*table.lock_initialized, true) {
        platform_create_rwlock(*table.lock);
    }

    platform_lock_rwlock_scoped(*table.lock, true);

    return table_contains(*table.names, name);
}
