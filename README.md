<div align="center">
<h1>🌊 Vave</h1>
<p align="center">
A crazy simple library for reading/writing WAV files written in V!
</p>
<p align="center">
<img src="https://i.imgur.com/ssfAcm7.png"/>
</p>
</div>

## Installation:

Install using `vpkg`

```bash
vpkg get https://github.com/thecodrr/vave
```

Install using `V`'s builtin `vpm` (you will need to import the module with: `import thecodrr.vave` with this method of installation):

```shell
v install thecodrr.vave
```

Install using `git`:

```bash
cd path/to/your/project
git clone https://github.com/thecodrr/vave
```

Then in the wherever you want to use it:

```javascript
import thecodrr.vave //OR simply vave depending on how you installed
```

And that's it!

## Usage

_This library is in use in the [vspeech](https://github.com/thecodrr/vspeech) (Bindings for DeepSpeech) utility that uses [Mozilla's DeepSpeech](https://github.com/mozilla/DeepSpeech) for Speech-to-Text. Do check that out as well._

### vave.open(`path`,`mode`)

Open a new WAV file in the specified mode. All mode supported by `C.fopen` are supported (e.g. `r`, `rb` etc.)

```javascript
mut wav := vave.open("/path/to/vave/file", "r") //open for reading
```

**NOTES:** The data is read into a `byteptr` and needs to be manually freed each and everytime or it will cause a huge memory leak. This library has been tested with `valgrind` and after freeing there is no other memory leak (if you find any, do report). I haven't implemented writing samples yet due to lack of time but its in my future plans.

### WavFile `struct`

`WavFile` struct is used for reading/writing samples and other metadata. It is returned by `vave.open`.

#### Read:

#### WavFile.read_raw()

Read all the samples from the file in their raw form.

#### WaveFile.read_samples(`count`)

Read a specific amount of samples from the file.

#### WaveFile.read_sample()

Read only one sample from the file.

#### Write:

**TODO**

#### WaveFile.close()

Close the file and free all associated resources.

### Metadata Methods:

#### WaveFile.total_samples()

Get total number of audio samples in the file.

#### WaveFile.duration()

Get total duration of the audio file.

#### WaveFile.data_len()

Get the total length of sample bytes in the file.

#### WaveFile.bytes_per_sample()

Get total bytes per each sample.

#### WaveFile.sample_rate()

Get the sample rate (samples per second).

#### WaveFile.sample_size()

Get the size of one sample()

#### WaveFile.format()

Get the format of the WAV audio. Either `PCM`, `IEEE`, `ALAW`,`MULAW` or `EXTENSIBLE`.

#### WaveFile.num_channels()

Get the total number of channels in the audio stream.

#### WaveFile.valid_bits_per_sample()

Get the bits per each sample.

## Supported Formats:

Currently only the following formats are supported:

1. PCM

2. IEEE

3. ALAW

4. MULAW

5. EXTENSIBLE

### Find this library useful? :heart:

Support it by joining **[stargazers](https://github.com/thecodrr/vave/stargazers)** for this repository. :star:or [buy me a cup of coffee](https://ko-fi.com/thecodrr)
And **[follow](https://github.com/thecodrr)** me for my next creations! 🤩

# License

```xml
MIT License

Copyright (c) 2019 Abdullah Atta

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
