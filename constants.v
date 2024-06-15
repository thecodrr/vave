module vave

const wav_riff_chunk_id = 'RIFF'.str
const wav_format_chunk_id = 'fmt '.str
const wav_fact_chunk_id = 'fact'.str
const wav_data_chunk_id = 'data'.str
const wave_id = 'WAVE'.str
const wav_riff_header_size = u32(8)
const default_sub_format = [0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38,
	0x9b, 0x71]

pub enum Formats {
	pcm        = 0x0001
	ieee       = 0x0003
	alaw       = 0x0006
	mulaw      = 0x0007
	extensible = 0xfffe
}
