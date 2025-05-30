NamesTable :: struct {
    Kind :: enum u8 {
        UNKNOWN;
        TYPE;
        NAMESPACE;
        ENUM;
    }

    names            : Table(string, Kind);
    lock             : Platform_RWLock;
    lock_initialized : bool;
}

addNameOrChangeKind :: (table : *NamesTable, name : string, kind : NamesTable.Kind) {
    if !atomic_swap(*table.lock_initialized, true) {
        platform_create_rwlock(*table.lock);
    }

    platform_lock_rwlock_scoped(*table.lock);

    value := table_find_pointer(*table.names, name);
    if value {
        value.* = kind;
    } else {
        table_add(*table.names, copy_string(name), kind);
    }
}

isNameAnyOfKinds :: (table : *NamesTable, name : string, kinds : ..NamesTable.Kind) -> bool {
    if !atomic_swap(*table.lock_initialized, true) {
        platform_create_rwlock(*table.lock);
    }

    platform_lock_rwlock_scoped(*table.lock, true);

    value := table_find_pointer(*table.names, name);
    if value for kinds {
        if it == value.* return true;
    }
    return false;
}
