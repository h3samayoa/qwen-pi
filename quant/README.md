nix develop

huggingface-cli download Qwen/Qwen3-4B --local-dir model

convert_hf_to_gguf.py ./model --outfile qwen3_4b.gguf

llama-quantize to Q4_K_M

todo: quantize to Q5_K_M and benchmark against Q4