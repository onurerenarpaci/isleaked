using SHA

NumType = Int64

function hash_func(data_list::Vector{NumType}, mod_num::NumType) :: NumType

    if Base.hastypemax(NumType)
        byte_data = reinterpret(UInt8, data_list)
        hash = sha256(byte_data)
    else
        byte_data = Vector{UInt8}()
        for data in data_list
            byte_data = vcat(byte_data, digits(UInt8, data; base=256))
        end
        hash = sha256(byte_data)
    end

    return NumType(mod(parse(BigInt, bytes2hex(hash), base=16), mod_num))
end

function init_cuckoo(n::NumType)
    return zeros(NumType, 2, n)
end

function insert(x::NumType, table::Array{NumType, 2}, hash_keys::Vector{NumType}, arr_id::Integer, iter::Integer)
    table_size = size(table, 2)
    if iter > table_size
        return false
    end

    idx::NumType = hash_func([x, hash_keys[arr_id]], table_size) + 1

    if table[arr_id, idx] == 0
        table[arr_id, idx] = x
        return true
    end

    if table[arr_id, idx] == x
        return true
    end

    old_val = table[arr_id, idx]
    table[arr_id, idx] = x
    return insert(old_val, table, hash_keys, (arr_id % 2) + 1, iter + 1)
end





