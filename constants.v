module wav

const (
	WAV_RIFF_CHUNK_ID = 'RIFF'.str
	WAV_FORMAT_CHUNK_ID = 'fmt '.str
	WAV_FACT_CHUNK_ID = 'fact'.str
	WAV_DATA_CHUNK_ID = 'data'.str
	WAVE_ID = 'WAVE'.str
	WAV_RIFF_HEADER_SIZE = u32(8)
	DEFAULT_SUB_FORMAT = [0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71]
)

pub enum Formats {
	pcm = 0x0001,
	ieee = 0x0003,
	alaw = 0x0006,
	mulaw = 0x0007,
	extensible = 0xfffe
}