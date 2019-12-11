module vave

struct WavMasterChunk {
	mut:
    /* RIFF header */
	id u32
    size u32
    wave_id u32
    format_chunk WavFormatChunk
    fact_chunk WavFactChunk
    data_chunk WavDataChunk
}

struct WavFormatChunk {
	mut:
    /* RIFF header */
    id u32
    size u32
    format_tag u16
    n_channels u16
    sample_rate u32
    avg_bytes_per_sec u32
    block_align u16
    bits_per_sample u16
    ext_size u16
    valid_bits_per_sample u16
    channel_mask u32
	sub_format SubFormat
}

struct SubFormat {
	format_code u16
	fixed_str [14]byte
}

struct WavFactChunk {
	mut:
    /* RIFF header */
    id u32
    size u32
    sample_length u32
}

struct WavDataChunk{ 
	mut:
    /* RIFF header */
    id u32
    size u32
}

fn (w &WavFile) parse_format_chunk() WavFormatChunk {
	chunk := WavFormatChunk{}
	
	if !w.parse_chunk_header(&chunk) && !compare(&chunk.id, WAV_FORMAT_CHUNK_ID) {
		panic("Couldn't find the format chunk.")
	}

	if chunk.size > 40 {
		panic("Size of format chunk is too big. Must be less than or equal to 40.")
	}

	if !w.parse_chunk_body(&chunk, chunk.size) {
		panic("Failed to read the format chunk body.")
	}

	if chunk.n_channels > 2 && chunk.format_tag != u16(Formats.extensible) {
		panic("This wav file has more than 2 channels but isn't WAV_FORMAT_EXTENSIBLE.")
	}

	if !(Formats(chunk.format_tag) in [.pcm, .ieee, .alaw, .mulaw]) {
    	if chunk.ext_size != 0 {
			if !(Formats(chunk.sub_format.format_code) in [.pcm, .ieee, .alaw, .mulaw]) {
               	panic("Only PCM, IEEE float and log-PCM log files are accepted.")
            }
		} else {
			panic("Only PCM, IEEE float and log-PCM log files are accepted.")
	 	}
	}

	return chunk
}

fn (w &WavFile) parse_master_chunk() WavMasterChunk {
	chunk := WavMasterChunk{}
	if !w.parse_chunk_header(&chunk) || !compare(&chunk.id, WAV_RIFF_CHUNK_ID) || !w.read_u32(&chunk.wave_id) || !compare(&chunk.wave_id, WAVE_ID) {
		panic("Couldn't find the RIFF chunk. This is probably not a WAVE file.")
	}
	return chunk
}

fn (w &WavFile) parse_fact_chunk() WavFactChunk {
	chunk := WavFactChunk{}
	if w.parse_chunk_header(&chunk) && compare(&chunk.id, WAV_FACT_CHUNK_ID) && w.parse_chunk_body(&chunk, chunk.size) {
		return chunk
	}
	return chunk
}

fn (w mut WavFile) parse_header() bool {
	w.chunk = w.parse_master_chunk()
	w.chunk.format_chunk = w.parse_format_chunk()
	w.chunk.fact_chunk = w.parse_fact_chunk()
	if compare(&w.chunk.fact_chunk.id, WAV_DATA_CHUNK_ID) {
		w.chunk.data_chunk.id   = w.chunk.fact_chunk.id
		w.chunk.data_chunk.size = w.chunk.fact_chunk.size
		w.chunk.fact_chunk.size = 0
	} else {
		for !compare(&w.chunk.data_chunk.id, WAV_DATA_CHUNK_ID) && !w.eof() {
			w.read_u32(&w.chunk.data_chunk.id)
		}
		if w.eof() {
			panic("Couldn't find data chunk.")
		}
		w.read_u32(&w.chunk.data_chunk.size)
		return true
	}
	return false
}

fn (w &WavFile) parse_chunk_header(chunk voidptr) bool {
	return w.read_into_struct(chunk, 0, u32(8))
}

fn (w &WavFile) parse_chunk_body(chunk voidptr, size u32) bool {
	// a quick way to read everything after the header into the struct
	// NOTE: the RIFF header is 8 bytes long
	return w.read_into_struct(chunk, 8, size)
}

fn compare(a voidptr, b byteptr) bool {
	data := byteptr(a)
	for i in 0..4 {
		if byte(data[i]) != b[i] {return false}
	}
	return true
}