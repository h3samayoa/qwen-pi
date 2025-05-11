nix develop

huggingface-cli download Qwen/Qwen3-4B --local-dir model

nix build .#default

https://qwen.readthedocs.io/en/latest/quantization/llama.cpp.html?utm_source=chatgpt.com 

./result/convert_hf_to_gguf.py ./model/ --outtype f32 --outfile qwen3-8b-f32.gguf

install_name_tool -add_rpath "@executable_path" $out/build/bin/llama-quantize
install_name_tool -add_rpath "@executable_path" $out/build/bin/llama-imatrix
install_name_tool -add_rpath "@executable_path" $out/build/bin/llama-perplexity

generate imatrix with calibration dataset

using this imatrix calibration dataset https://gist.github.com/bartowski1182/eb213dccb3571f863da82e99418f81e8 

./result/build/bin/llama-imatrix -m ./qwen3-8b-f32.gguf -f calibration_datav3.txt -o Qwen3-4B-imatrix.dat

quantize model 

./result/build/bin/llama-quantize --imatrix Qwen3-4B-imatrix.dat ./qwen3-8b-f32.gguf Qwen3-4B-Q5_K_M.gguf Q5_K_M

test model with llama-perplexity

todo find test file for benchmarking 
./llama-perplexity -m Qwen3-4B-Q5_K_M.gguf -f wiki.test.raw -ngl 80
