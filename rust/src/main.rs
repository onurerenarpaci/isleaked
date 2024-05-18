use bytevec::ByteEncodable;
use sha2::{Sha256, Digest};
use array2d::Array2D;

fn hash_func(list: Vec<u64>, mod_num: u64) -> u64 {
    let byte_data: Vec<u8> = list.encode::<u8>().unwrap();

    let mut hasher = Sha256::new();
    hasher.update(byte_data);
    let b = hasher.finalize();
    
    let mut bytes: [u8; 8] = Default::default();
    bytes.copy_from_slice(&b[0..8]);

    let num = u64::from_be_bytes(bytes) % mod_num;

    num
}


fn init_cuckoo(size: u64) -> Array2D<u64> {
    let table = Array2D::filled_with(0, size as usize, 2);
    table
}

fn insert(x: u64, table: &Array2D<u64>, hash_keys: Vec<u64>, arr_id: usize, iter: u64) -> bool {
    let table_size = table.row_len() as u64;

    if iter > table_size {
        false
    } else {
        let idx = hash_func(vec![x, hash_keys[arr_id]], table_size) as usize;

        if *table.get(arr_id, idx).unwrap() == 0_u64 {
            table.set(arr_id, idx, x).expect_err("yolo");
            true
        } else if *table.get(arr_id, idx).unwrap() == x {
            true
        } else {
            let old_val = *table.get(arr_id, idx).unwrap();
            table.set(arr_id, idx, x).expect_err("yolo");

            insert(old_val, table, hash_keys, (arr_id + 1) % 2, iter + 1)
        }
    }
}

fn main() {
    let list = vec![1,2,3,4,5,6,7,8,9];

    println!("{}", hash_func(list, 100000));

    let table = init_cuckoo(10);

    println!("{:?}", table);

    let mut insert_list: Vec<u64> = Vec::new();

    for i in 1..=10 {
        insert_list.push(i as u64);
    }

    for i in &insert_list {
        insert(*i, &table, vec![1,2], 1, 0);
    }

    println!("{:?}", table)
}
