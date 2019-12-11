module vave

//TODO implement different reading functions like mono, stereo etc.

//read_sample reads one sample from the audio stream
//it can be used for streaming etc. The returned data
//must be freed manually or it will cause a memory leak.
pub fn (w &WavFile) read_sample() byteptr {
	return w.read_samples(1)
}

//read_raw reads all the audio data from the audio stream
//the data is put into w.data instead of returning it
//and automatically frees it on w.close()
pub fn (w mut WavFile) read_raw() byteptr {
	return w.read_samples(int(w.total_samples()))
}

//read_samples reads multiple samples from the audio stream
//the returned data must be freed manually or it will cause a memory leak.
pub fn (w &WavFile) read_samples(count int) byteptr {
	if w.mode in ['wb', 'wbx', 'ab'] {
		panic("File was opened in wrong mode.")
	}
	if w.chunk.format_chunk.format_tag == u16(Formats.extensible) {
		println("warn: EXTENSIBLE format is not supported.")
	}
	total_samples := int(w.num_channels()) * count * int(w.sample_size())
	data := malloc(total_samples)
	C.fread(data, w.sample_size(), int(w.num_channels()) * count, w.fp)
	if ferror(w.fp) > 0 {
        panic("Failed to read the data chunk.")
    }
	return data
}