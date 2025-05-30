NamesTable :: struct {
    Kind :: enum u8 {
        UNKNOWN;
        TYPE;
        NAMESPACE;
        ENUM;
    }

    lock  : RWLock;
    names : Table(string, Kind);
}

createNamesTables :: () {
    init(*g_jaiNames.lock);
    init(*g_cNames.lock);
    init(*g_cppNames.lock);
}

destroyNamesTables :: () {
    for g_cppNames.names { free(it_index); }
    deinit(*g_cppNames.names);
    destroy(*g_cppNames.lock);

    for g_cNames.names { free(it_index); }
    deinit(*g_cNames.names);
    destroy(*g_cNames.lock);

    for g_jaiNames.names { free(it_index); }
    deinit(*g_jaiNames.names);
    destroy(*g_jaiNames.lock);
}

resetNamesTables :: () {
    lock(*g_jaiNames.lock);
    lock(*g_cNames.lock);
    lock(*g_cppNames.lock);

    for g_jaiNames.names { free(it_index); }
    table_reset(*g_jaiNames.names);
    unlock(*g_jaiNames.lock);

    for g_cNames.names { free(it_index); }
    table_reset(*g_cNames.names);
    unlock(*g_cNames.lock);

    for g_cppNames.names { free(it_index); }
    table_reset(*g_cppNames.names);
    unlock(*g_cppNames.lock);
}

addNameOrChangeKind :: (table : *NamesTable, name : string, kind : NamesTable.Kind) {
    lock_scoped(*table.lock);

    value := table_find_pointer(*table.names, name);
    if value {
        value.* = kind;
    } else {
        table_add(*table.names, copy_string(name), kind);
    }
}

isNameAnyOfKinds :: (table : *NamesTable, name : string, kinds : ..NamesTable.Kind) -> bool {
    lock_scoped(*table.lock, true);

    value := table_find_pointer(*table.names, name);
    if value for kinds {
        if it == value.* return true;
    }
    return false;
}

g_jaiNames : NamesTable;
g_cNames   : NamesTable;
g_cppNames : NamesTable;
