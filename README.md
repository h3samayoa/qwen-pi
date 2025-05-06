## TODO

### convert / quantize
- [ ] Convert Qwen3 model to `.gguf` format
- [ ] Quantize model to `Q8_0` for testing
- [ ] Re-quantize model to `Q4_K_M` for Pi deployment
- [ ] Test model locally with `llama-cli`

### fastAPI
- [ ] Create FastAPI `app.py` using subprocess inference
- [ ] Apply Qwen3 sampling settings in API
- [ ] Test FastAPI locally on port 8000

### rpi
- [ ] Finalize `configuration.nix` for Raspberry Pi
- [ ] Build and flash Pi NixOS image

### tailscale
- [ ] Create `tailscale.nix` module
- [ ] Enable and test Tailscale access on Pi
- [ ] Use `tailscale serve` to enable HTTPS for frontend
- [ ] Assign Pi a subnet alias for easier frontend reference
- [ ] Configure ACLs to restrict Pi access via Tailscale admin panel

### start srvr
- [ ] Transfer model and binaries to Pi
- [ ] Deploy and run FastAPI app on Pi
- [ ] Add systemd service for FastAPI on Pi

### frontend
- [ ] Build frontend (Rust + HTMX)
- [ ] Deploy frontend via Fly.io or Nix container
- [ ] Connect frontend to FastAPI through Tailscale

### extra
- [ ] Template prompts for consistent outputs (math, code)
- [ ] Apply presence penalty using `--repeat-penalty` to reduce repetition
- [ ] Limit chat history to reduce memory/token use
- [ ] Optimize prompts and token limits
- [ ] Add basic error handling and logs to API
- [ ] (Optional) Add chat memory or WebSocket support
