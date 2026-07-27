# TikTok Streak Bot

An unofficial community-maintained fork of the original TikTok Streak Bot by thetrekir.

This project automates sending a daily message to maintain TikTok streaks. It is designed to survive TikTok UI changes, iframe blocks, and run reliably on low-memory VPS instances.

The original repository by thetrekir is no longer available. This fork continues development by preserving the original functionality while adding bug fixes, deployment improvements, and compatibility updates.

## Disclaimer

This project is not affiliated with, endorsed by, or sponsored by TikTok or the original author. It is an independent community fork intended to preserve a useful open-source project.

## What’s New in this Fork

Compared to the original project, this fork includes:

* Better resilience against TikTok UI updates
* Automatic iframe detection and handling
* Improved message verification and retry logic
* Better low-memory VPS support
* Docker deployment
* Windows Service support
* Improved process cleanup
* Ongoing maintenance and bug fixes

## Core Mechanics

*   **Smart Verification:** TikTok frequently drops messages silently. The bot doesn't just hit enter; it checks if the input box actually cleared. If not, it refreshes and retries.
*   **Iframe Bypass:** TikTok recently started hiding the DM interface inside iframes. The bot detects this and automatically switches context.
*   **Low-RAM Optimized:** Forces single-process mode, disables images/GPU, and uses `/dev/shm` workarounds to prevent Out-Of-Memory (OOM) crashes on Low RAM VPS environments. 
*   **Process Management:** Automatically kills lingering zombie `chromedriver` or `chrome` processes before and after runs. No memory leaks over time.

## 1. Initial Setup (All Platforms)

1.  **Clone the Repo:**
    ```bash
    git clone https://github.com/maya329/tiktok-autostreak.git
    cd tiktok-autostreak
    ```

2.  **Get Your Cookies:**
    *   Log in to TikTok in your browser.
    *   Use an extension like [Cookie-Editor](https://cookie-editor.com/) to export your cookies for the `tiktok.com` domain.
    *   Save the JSON data into a file named `cookies.json` in the bot's root directory.

3.  **Configure:**
    Run the bot once or create `config.json` manually:
    ```json
    {
      "TEST_MODE": false,
      "TARGET_USERS": ["username1", "username2"],
      "MESSAGE_TO_SEND": "husky",
      "TARGET_SEND_TIME_HM": [0, 2],
      "COOKIES_FILE": "cookies.json",
      "LOG_FILENAME": "tiktok_bot.txt",
      "HEADLESS_MODE": true
    }
    ```
    *   `TEST_MODE`: `true` ignores the schedule and runs immediately. Useful for debugging.
    *   `TARGET_SEND_TIME_HM`: `[Hour, Minute]` in 24-hour format (e.g., `[0, 2]` = 00:02 AM).

## 2. Deployment Options

Choose how you want to run the bot based on your environment.

### Option A: Docker (Recommended for Linux VPS)

The cleanest way to run this on a server. It packages its own Chrome binaries and dependencies.

1. Ensure your `cookies.json` and `config.json` are in the project root (or inside the `/data` dir if you have it mounted).
2. Edit your timezone in `docker-compose.yml` if necessary.
3. Build and run in the background:
   ```bash
   docker compose up -d --build
   ```
4. View logs:
   ```bash
   docker compose logs -f
   ```

### Option B: Windows Background Service (.exe)

If you use a Windows PC and want the bot to run completely hidden in the background, surviving reboots.

1. Download the latest `tiktok-bot.exe` from the **Releases** tab.
2. Put the `.exe`, `config.json`, and `cookies.json` in a folder (e.g., `C:\TikTokBot`).
3. Download [NSSM](http://nssm.cc/), extract `nssm.exe` (win64).
4. Open Command Prompt **as Admin** and run:
   ```cmd
   nssm install TikTokStreakBot
   ```
5. In the NSSM GUI, set the **Path** to your `tiktok-bot.exe`. Click **Install service**.
6. Start the service:
   ```cmd
   sc start TikTokStreakBot
   ```
The bot will now run silently every time your PC turns on. Check `tiktok_bot.txt` for logs.

### Option C: Manual Python Execution (Mac/Linux/Windows)

If you just want to run the script directly.

1. Install requirements:
   ```bash
   pip install -r requirements.txt
   ```
2. Run it:
   ```bash
   python main.py
   ```
*(For a background run on Windows without a console window, use `pythonw.exe main.py`)*

## Credits

This project is based on the original TikTok Streak Bot created by thetrekir.

Although the original repository is no longer available, this fork would not exist without the original work. Many thanks to the original author for creating and open-sourcing the project.

This repository continues development independently and welcomes community contributions.

## Logs & Debugging

The bot writes all operations, retries, and errors to `tiktok_bot.txt` (or whatever you named it in `config.json`). If a message fails, check this log. It will tell you if the element wasn't found, if it got stuck in an iframe, or if the cookie expired.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
