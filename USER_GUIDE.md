# FonixFlow Tracker Setup — User Guide

For camera operators and technicians setting up FreeD lens tracking in Unreal Engine.

---

## Before You Start

**What you need:**
- A FreeD tracking device (e.g. Mosys, stYpe, Ncam, EZtrack) connected to the same network via **wired Ethernet**
- The device configured to send UDP data to **port 40000** on your machine's IP
- A CineCameraActor in the UE level representing your physical camera
- The plugin installed and enabled (Edit > Plugins > FonixFlow Tracker Setup)

---

## Opening the Panel

Click the **FF** button (blue square) in the Level Editor toolbar.

The panel opens as a dockable window. It has two tabs: **Camera Setup** and **Calibration**.

---

## Step 1 — Camera Setup Tab

Work through this tab top to bottom, then click SETUP NOW.

### CAMERA
A list of all CineCameraActors in your level appears.
- **Click your camera** to select it.
- Click **Refresh** if you added the camera after opening the panel.

### LENS
Choose your lens type:

| Type | When to use |
|------|-------------|
| **PRIME** | Fixed focal length lens — enter the focal length in mm |
| **ZOOM** | Variable focal length — enter the min (wide) and max (tele) focal lengths in mm |

Examples: Prime 50 mm · Zoom 28–100 mm

### PROTOCOL
Select **FreeD 3D** (the default — covers all FreeD-compatible trackers).
OpenTrack IO is listed but not yet implemented.

### NETWORK
Shows a dropdown of all **wired Ethernet adapters** currently connected on your machine. Wi-Fi and virtual adapters (VMware, Hyper-V, VirtualBox, TAP, etc.) are automatically excluded.

The selected IP and port (40000) is the address you configure on your tracking device.

> **Configure your tracker to send UDP to `<selected IP>:40000`**

If your adapter isn't listed, click **Refresh** to re-detect. The plugin listens on all interfaces (`0.0.0.0`) so tracking works regardless of which adapter you select — the dropdown is there to help you identify the right IP for your device configuration.

### SETUP NOW
Click **SETUP NOW** when the camera and lens are configured.

What this does automatically:
1. Enables ICVFX and LiveLinkLens plugins (first run only — requires editor restart)
2. Creates a Live Link FreeD source on `0.0.0.0:40000` (skips if one is already active)
3. Adds a LiveLink Controller component to the selected camera
4. Sets the camera role and enables UseCameraRange

After clicking, the panel switches to the **Calibration** tab.

> **Check the log** at `Saved/Logs/FonixFlowTracker.log` if anything looks wrong.

---

## Step 2 — Calibration Tab

**The tracker must be sending data before you calibrate.**
Verify the live Focus and Zoom values are updating at the top of the tab.

### Live Readout
```
Focus  123.45 cm        Zoom  35.00 mm
```
These update at ~20 Hz from the FreeD stream. If they show `0.00`, the tracker is not sending data — check network and port.

### Focus Calibration
You need to capture the focus encoder at two distances:

| Row | Instructions |
|-----|-------------|
| **NEAR** | Focus the lens to its **minimum focus distance** (closest subject), then click **CAPTURE** |
| **FAR**  | Focus the lens to **infinity** (∞), then click **CAPTURE** |

The captured value appears in the row after clicking.

### Zoom Calibration (Zoom lens only)
| Row | Instructions |
|-----|-------------|
| **WIDE** | Zoom the lens to its **widest** focal length, then click **CAPTURE** |
| **TELE** | Zoom the lens to its **longest** focal length, then click **CAPTURE** |

### APPLY CALIBRATION
Click **APPLY CALIBRATION** after capturing all required values.

What this does:
1. Writes the encoder min/max values to a Lens File at `/Game/FonixFlowTrackerSetup/TrackedLens`
2. Sets UseManualRange on the FreeD source so encoder values are used directly
3. Enables UseCameraRange on the LiveLink camera controller

> After applying, the **APPLY LENS FILE** button appears (see below).

---

## Subsequent Sessions — Apply Lens File

If you've calibrated before and **haven't moved the lens**, you don't need to re-capture.

Click **APPLY LENS FILE** to re-apply the previously saved lens file to the camera.
This runs the same apply step without overwriting your captured values.

---

## Troubleshooting

| Problem | Check |
|---------|-------|
| Live readout shows `0.00` | Tracker is not sending to `<your IP>:40000` — verify device config and firewall |
| SETUP NOW is greyed out | No camera selected in the CAMERA list |
| Calibration drifts after apply | Re-capture NEAR/FAR at the actual physical limits of your lens |
| Plugin not visible in toolbar | Edit > Plugins > FonixFlow Tracker Setup > Enable, restart editor |
| Log shows "No LiveLink controller" | Run SETUP NOW before APPLY CALIBRATION |
| Editor restart prompt after SETUP NOW | ICVFX or LiveLinkLens was just enabled — restart, then run SETUP NOW again |
| No adapters in NETWORK dropdown | Click Refresh; if still empty the plugin falls back to the system default IP |
| Wrong IP shown in dropdown | Select the correct adapter from the list; Wi-Fi and virtual adapters are hidden by design |

**Log file:** `<ProjectDir>/Saved/Logs/FonixFlowTracker.log`
Every step the plugin takes is written there with a timestamp.

---

## Port Reference

| Setting | Value |
|---------|-------|
| Protocol | UDP |
| Listen address | `0.0.0.0` (all interfaces) |
| Port | `40000` |
| Data format | FreeD 3D Protocol (D-packet, 29 bytes) |

---

## Workflow Summary

```
Open panel (FF toolbar button)
  └─ Camera Setup tab
       ├─ Select camera
       ├─ Set lens type + focal length
       ├─ Select your LAN adapter IP in the NETWORK dropdown
       ├─ Configure tracker to send to <that IP>:40000
       └─ Click SETUP NOW
            └─ Calibration tab (auto-switch)
                 ├─ Verify live focus/zoom values are updating
                 ├─ Rotate lens: capture NEAR, FAR (+ WIDE, TELE for zoom)
                 └─ Click APPLY CALIBRATION
                      └─ Done — tracking is active
```
