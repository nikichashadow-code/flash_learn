
# Flash Learn

Educational mobile app for learning Linux, terminal commands, and system administration through flashcards, command references, quizzes, and interactive tools.

## Features

- **Terminal Command Reference** - Browse Linux commands with flags and examples
- **Command Quizzes** - Test your knowledge with interactive quizzes
- **Flashcard System** - Create and study custom flashcard sets
- **Linux History** - Explore the history and evolution of Linux
- **Linux Basics & Distributions** - Learn Linux fundamentals and explore different distributions
- **SSH Client** - Connect to remote servers directly from the app
- **Terminal Simulator** - Practice terminal commands safely
- **AI Linux Tutor** - Ask Ollama questions in a conversational learning screen
- **User Accounts** - Save your progress and sync across sessions
- **Multi-language Support** - Available in multiple languages

## AI tutor setup

The AI tutor uses [Ollama](https://ollama.com/) running on a computer that your
Android device can reach. The app connects directly to that Ollama server; it
does not download or host the model itself.

### 1. Install a model

Install Ollama on your computer, then download a model. For example:

```bash
ollama pull qwen3:4b
```

Check which models are installed with:

```bash
ollama list
```

### 2. Make Ollama reachable on your network

Your computer and Android device should be on the same trusted Wi-Fi network.
Ollama may listen only on the computer itself by default. To allow devices on
your local network to connect, configure Ollama to listen on:

```text
0.0.0.0:11434
```

Restart Ollama after changing its listen address. If your computer's firewall
asks, allow Ollama on your **private/local network**. Do not expose the Ollama
port to the public internet.

### 3. Enter the server URL in the app

Open **Settings → AI tutor** and enter the server's base URL. Replace the
example IP below with your computer's local network IP address:

```text
http://192.168.1.25:11434
```

Do not use `localhost` on your Android device: it points to the device itself,
not your computer.

### 4. Choose a model and start chatting

Save the URL. The app refreshes the installed models when settings open and
when the server URL changes. Tap a model to select it, then open the AI tutor
chat. The thinking-level choices are loaded from Ollama for the selected model;
**Model default** leaves the `think` option unset. Settings are saved on your
device.

## Known Limitations

- Terminal simulator is in beta
- Android only

## Author

**nikichashadow-code** - [GitHub](https://github.com/nikichashadow-code)
