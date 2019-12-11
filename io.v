module wav

fn (w &WavFile) read_bytes(buf voidptr, len int) bool {
	return C.fread(buf, len, 1, w.fp) == 1
}

fn (w &WavFile) read_u32(buf voidptr) bool {
	return w.read_bytes(buf, sizeof(u32))
}

fn (w &WavFile) read_u16(buf voidptr) bool {
	return w.read_bytes(buf, sizeof(u16))
}

fn (w &WavFile) read_into_struct(c voidptr, skip int, size u32) bool {
	return w.read_bytes(*byte(c) + skip, int(size))
}

/* fn (w &WavFile) pos() i64 {
    pos := ftell(w.fp)
    if (pos == i64(-1)) {
        panic("Failed to get file position.")
    } else {
        header_size := i64(w.get_header_size())
		println("header size:" + header_size.str())
        return (pos - header_size) / i64(w.chunk.format_chunk.block_align)
    }
} */

fn (w &WavFile) eof() bool {
    return feof(w.fp) > -1 || ftell(w.fp) == int(w.get_header_size() + w.chunk.data_chunk.size)
}