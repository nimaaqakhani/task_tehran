# Flutter Text Analyzer App

A Flutter application demonstrating **Clean Architecture**, **Hive local storage**, and **Bloc state management** for text analysis.

---

## Overview

This app allows users to:

- Input text and analyze it (count letters and words).
- Store analyzed text in a local Hive database.
- Search, edit, delete, or clear historical entries.
- Follow **Clean Architecture principles**: separating UI, domain, and data layers.
- Use **Bloc** for predictable state management.

---

## Architecture Diagram

lib/
├── core/
│ └── platform_channel.dart # Android method channel integration
├── features/
│ └── hive_text/
│ ├── data/
│ │ ├── model/history_item.dart
│ │ └── repository/hive_repository_impl.dart
│ ├── domain/usecases/
│ │ ├── analyze_input.dart
│ │ └── clear_history.dart
│ └── presentation/
│ ├── bloc/
│ │ ├── hive_text_bloc.dart
│ │ ├── hive_text_event.dart
│ │ └── hive_text_state.dart
│ └── pages/hive_text_screen.dart
└── main.dart



---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.3.0 < 3.8.0
- Dart SDK >= 3.3.0 < 3.8.0
- Android Studio / VS Code
- Git

### Installation

```bash
git clone https://github.com/nimaaqakhani/task_tehran.git
cd task_tehran
flutter pub get
flutter run

SOLID & Clean Architecture

SRP: Each class has a single responsibility.

OCP: Logic can be extended without modifying existing code.

LSP: Use cases and repositories are easily replaceable.

ISP: Classes depend only on the interfaces they need.

DIP: Presentation layer depends on abstractions, not concrete implementations.

Dependencies

flutter_bloc – State management

hive & hive_flutter – Local storage

equatable – Value comparison for events and states

Future Improvements

Word frequency analysis

Sentiment analysis

Unit & widget tests

Enhanced UI/UX with animations and responsive design