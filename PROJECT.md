# FonixFlow Tracker Setup

## Goals
- One-click Live Link camera tracking setup for Unreal Engine
- Single "Setup Now" button automates entire 3D tracking pipeline
- Support FreeD (3D Protocol) and OpenTrack IO protocols
- Prime and Zoom lens support with configurable focal length ranges
- Live encoder readout and calibration from FreeD data stream
- Target UE 5.5–5.8 with pre-built Win64 binaries

## In Progress
- [ ] Runtime testing — verify full flow end-to-end in UE Editor
- [ ] OpenTrack IO protocol support (UI ready, implementation pending)
- [ ] Verify lens file quality — encoder mapping, focal length tables, image center

## To Do
- [ ] Multi-camera setup support (multiple cameras in one scene)
- [ ] Lens file auto-generation from tracking data over time
- [ ] Virtual camera integration (VCamCore wiring)
- [ ] Auto-detect FreeD packets on network
- [ ] Blueprint function library for procedural setups
- [ ] Save/load tracking presets
- [ ] Camera rig preset defaults (encoder ranges per manufacturer: Generic, Sony, Panasonic, Mosys, stYpe, Ncam)
- [ ] Documentation and examples
- [ ] AI Chat: streaming responses, markdown rendering
- [ ] AI Chat: context-aware setup suggestions (read current scene state)

## Done
- [x] v1.4.0 — LAN adapter IP selector + UE 5.8 pre-built binary
  - [x] Replace single GetLocalHostAddr() with Windows GetAdaptersAddresses() enumeration
  - [x] Filter to wired Ethernet only (IF_TYPE_ETHERNET_CSMACD) — Wi-Fi and virtual adapters excluded
  - [x] NETWORK section replaced with SComboBox dropdown of all qualifying LAN adapters
  - [x] Selection is informational — plugin continues to listen on 0.0.0.0
  - [x] BuildPlugin.bat for one-click builds targeting UE 5.5, 5.6, 5.7, 5.8
  - [x] Pre-built Win64 binary for UE 5.8 on GitHub Releases
  - [x] Version bump to 1.4.0
- [x] v1.3.0 — AI Chat function calling + state awareness
  - [x] FFonixFlowTrackerState struct + JSON serialization
  - [x] IFonixFlowTrackerActions interface — setup panel implements it, chat panel calls it
  - [x] FonixFlowAIChatTools: tool schema definitions + execution (select_camera, set_protocol, set_lens_type, run_setup, capture_calibration, apply_calibration, get_plugin_state)
  - [x] Function calling loop in SFonixFlowTrackerAIChatPanel
  - [x] State injected into system prompt on every message
- [x] v1.2.0 — UE 5.5–5.8 compatibility, pre-built binaries
  - [x] Verified all APIs compatible across UE 5.5, 5.6, 5.7, 5.8
  - [x] Pre-built Win64 binaries for UE 5.5, 5.6, 5.7 on GitHub Releases
  - [x] Build pipeline: RunUAT BuildPlugin via BatchFiles, packages into ZIP
  - [x] CLAUDE.md added for agent guidance
- [x] v1.1.0 — UE 5.7 compatibility + workflow improvements
  - [x] Replace `TObjectIterator` for-loops with `GetObjectsOfClass()` (fixes UE5.7 C++20 MSVC C7568 error)
  - [x] Drop Log tab from UI — log now writes to `Saved/Logs/FonixFlowTracker.log`
  - [x] FF blue square PNG toolbar icon (20×20, #1a3a58 background, white FF pixels)
  - [x] Active tab highlighting
  - [x] Auto-enable ICVFX and LiveLinkLens plugins via `.uplugin` dependency list
  - [x] "APPLY LENS FILE" button appears after calibration
  - [x] Skip duplicate FreeD source — SETUP NOW checks ActiveSourceGuid before creating
  - [x] 2-tab layout: Camera Setup + Calibration
- [x] v1.0.0 — Full calibration pipeline
  - [x] FreeD source creation on 0.0.0.0 via reflection
  - [x] LiveLink polling — reads actual encoder values from FreeD at 20Hz
  - [x] Prime/Zoom lens selector with explicit visibility control
  - [x] Focus distance range (near/far cm) captured from live encoder
  - [x] ApplyCalibration sets FreeD UseManualRange=true and UseCameraRange on controller
  - [x] Lens file: correct encoder mapping for prime and zoom
- [x] v0.3.0 — UE 5.6 compatibility
  - [x] UE 5.6 API fixes (FEditorStyle→FAppStyle, CineCamera includes, VCamCore)
  - [x] Runtime reflection for FLiveLinkFreeDConnectionSettings (private header)
- [x] v0.2.0 — AI Chat, Camera Picker
  - [x] AI Chat Panel (SFonixFlowTrackerAIChatPanel)
  - [x] Camera picker — lists CineCameraActors in level
  - [x] Editor toolbar integration
- [x] v0.1.0 — Initial scaffold
  - [x] Plugin scaffold (Runtime + Editor modules)
  - [x] Core types, Subsystem architecture
  - [x] GitHub repo created

## Blocked
- (none)

## Releases
- v1.4.0 — LAN adapter dropdown, UE 5.8 pre-built binary, BuildPlugin.bat (current)
- v1.3.0 — AI Chat function calling, state awareness, IFonixFlowTrackerActions interface
- v1.2.0 — UE 5.5–5.8 compat, pre-built Win64 binaries (5.5/5.6/5.7), CLAUDE.md
- v1.1.0 — UE5.7 C++20 compat, 6 workflow improvements, log to file, FF icon, tab highlight
- v1.0.0 — Full calibration pipeline, LiveLink polling, prime/zoom, FreeD manual range
- v0.3.0 — UE 5.6 compatibility, reflection-based FreeD source creation
- v0.2.0 — AI Chat, Camera Picker
- v0.1.0 — Initial scaffold

## Notes
- UE engine installs: D:\UE_Engine\UE_5.5 through UE_5.8 on this machine
- FreeD module: Engine/Plugins/VirtualProduction/LiveLinkFreeD
- FreeDConnectionSettings struct is in Private/ — access via reflection (GetObjectsOfClass)
- FreeD source factory: ULiveLinkFreeDSourceFactory — use ExportText for connection string
- LiveLinkCameraController: access via ControllerMap[ULiveLinkCameraRole::StaticClass()]
- bUseCameraRange is on ULiveLinkCameraController (not on ULiveLinkComponentController)
- ILiveLinkClient::GetSubjects(false, false) — UE 5.6+ API signature
- EvaluateFrame_AnyThread takes FLiveLinkSubjectFrameData (not FLiveLinkStaticDataStruct)
- SVerticalBox::FSlot does NOT have .Visibility() — use SAssignNew + SetVisibility instead
- FreeD zoom encoder is in µm — divide by 1000 to get mm
- FreeD default port: 40000
- Key modules: Sockets, Networking, LiveLinkCamera, LiveLinkFreeD
- LAN detection: Windows GetAdaptersAddresses(), IF_TYPE_ETHERNET_CSMACD (type 6) = wired Ethernet
- Build: BuildPlugin.bat at repo root — calls RunUAT BuildPlugin for each UE version
