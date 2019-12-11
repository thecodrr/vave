module vave

import os

struct C.FILE
fn C.feof(f &FILE) int
fn C.ferror() int

struct WavFile {
    filename string
	mut:
    chunk WavMasterChunk
	fp &C.FILE
	mode string
}

//open opens a WAV file for read/write in the specified mode
pub fn open(path, mode string) &WavFile {
	os.tmpdir() //hack to include os import

	mut wav := &WavFile{
		fp: C.NULL,
		data: C.NULL
	}
	match mode {
		"rb", "r" {wav.mode = "rb"}
		"r+", "rb+", "r+b" {wav.mode = "rb+"}
		"w", "wb" {wav.mode = "wb"}
		"w+", "wb+", "w+b" {wav.mode = "wb+"}
		"wx", "wbx" {wav.mode = "wbx"}
		"w+x", "wb+x", "w+bx" {wav.mode = "wb+x"}
		"a", "ab" {wav.mode = "ab"}
		"a+","ab+","ab+b" {wav.mode = "ab+"}
		else {
			panic("init: wrong 'mode' given.")
		}
	}

	$if windows {
		wav.fp = C._wfopen(path.replace('/', '\\').to_wide(), wav.mode.to_wide())
	} $if linux {
		wav.fp = C.fopen(path.replace('\\', '/').str, wav.mode.str)
	}

	if wav.fp == C.NULL {
		panic("Couldn't open file: ${path}. Make sure it exists.")
	}

	if wav.mode[0] == `r` {
		wav.parse_header()
	} else if wav.mode[0] == `a` {
		if !wav.parse_header() {
			C.rewind(wav.fp)
		}
	}
	return wav
}

pub fn (w mut WavFile) close() int {
	if !w.finalize() {
		panic("Failed to close the file.")
	}
	unsafe {
		free(w)
	}
	return 0
}

pub fn (w &WavFile) bytes_per_sample() u16 {
    return w.chunk.format_chunk.bits_per_sample / u16(8)
}

pub fn (w &WavFile) total_samples() u32 {
    return w.chunk.data_chunk.size / u32(w.chunk.format_chunk.block_align)
}

pub fn (w &WavFile) sample_rate() u32 {
    return w.chunk.format_chunk.sample_rate
}

pub fn (w &WavFile) channel_mask() u32 {
    return w.chunk.format_chunk.channel_mask
}

pub fn (w &WavFile) sub_format() u16 {
    return w.chunk.format_chunk.sub_format.format_code
}

pub fn (w &WavFile) sample_size() u16 {
    return w.chunk.format_chunk.block_align / w.chunk.format_chunk.n_channels
}

pub fn (w &WavFile) format() Formats {
    return Formats(w.chunk.format_chunk.format_tag)
}

pub fn (w &WavFile) num_channels() u16 {
    return w.chunk.format_chunk.n_channels
}

pub fn (w &WavFile) valid_bits_per_sample() u16 {
    if w.chunk.format_chunk.format_tag != u16(Formats.extensible) {
        return w.chunk.format_chunk.bits_per_sample
    } else {
        return w.chunk.format_chunk.valid_bits_per_sample
    }
}

pub fn (w &WavFile) duration() u32 {
	return w.total_samples() / w.sample_rate()
}

pub fn (w &WavFile) data_len() int {
	return int(w.chunk.data_chunk.size)
}

// Private

fn (w mut WavFile) finalize () bool {
    if w.fp == C.NULL {
        return false
    }

    ret := C.fclose(w.fp)
    if (ret != 0) {
        panic("Couldn't close the file properly.")
    }
	return true
}

/* fn (w mut WavFile) reopen(path, mode string) &WavFile {
	w.finalize()
	return init(path, mode)
} */

fn (w &WavFile) get_header_size() u32 {
    mut header_size := WAV_RIFF_HEADER_SIZE + u32(4) +
                         WAV_RIFF_HEADER_SIZE + w.chunk.format_chunk.size +
                         WAV_RIFF_HEADER_SIZE

    if compare(&w.chunk.fact_chunk.id, WAV_FACT_CHUNK_ID) {
        header_size += WAV_RIFF_HEADER_SIZE + w.chunk.fact_chunk.size
    }

    return header_size
}