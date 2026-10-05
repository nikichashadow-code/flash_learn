
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

Run Ollama on a computer reachable from the device and make sure the chosen
model is installed there (for example, `ollama pull qwen3:4b`). In the app, open
**Settings → AI tutor** and enter the Ollama server's base URL and model name.
Installed models refresh automatically when settings open and when the server
URL changes. Tap an installed model to select it. The URL should include the
port when it is not the default, but should not end with `/api/chat`. Settings
are saved on the device. Thinking options refresh automatically for the selected
model using Ollama's `/api/show` metadata; the selector only offers the values
Ollama reports. **Model default** omits the `think` request field.

## Known Limitations

- Terminal simulator is in beta
- Android only

## Author

**nikichashadow-code** - [GitHub](https://github.com/nikichashadow-code)
