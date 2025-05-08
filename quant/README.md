nix develop

huggingface-cli download Qwen/Qwen3-4B --local-dir model

nix build .#default

{
https://qwen.readthedocs.io/en/latest/quantization/llama.cpp.html?utm_source=chatgpt.com 

./result/convert_hf_to_gguf.py ./model/ --outtype f32 --outfile qwen3-8b-f32.gguf

./result/build/bin/llama-quantize # todo symlink
}

{
TODO: 

change build/installPhase in packages.nix to use builder input with custom build script 

https://ertt.ca/nix/shell-scripts/ 

https://blog.ielliott.io/nix-docs/mkDerivation.html
}

using this imatrix calibration dataset https://gist.github.com/bartowski1182/eb213dccb3571f863da82e99418f81e8 