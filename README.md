# 🧑‍💼 multi-role-flutter-auth

A modular and scalable **Flutter + Supabase authentication template** with **dynamic role-based onboarding and dashboards**.

Built for developers building logistics, multi-user apps, or admin panels where users like **drivers**, **admins**, **agents**, etc., need **tailored views and features** — this project gives you a clean head start.

---

## 🚀 Features

- 🔑 Email/password login using [Supabase](https://supabase.com/)
- 🧩 Role-based onboarding flow
- 🧭 Clean separation of login, signup, and role selection screens
- 🧑‍💼 Easily configurable roles like `Guest`, `Member`, `Lead`, `Admin`, `SuperAdmin`
- 🛡️ `.env`-based secrets handling with [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- 🎯 Scalable structure for real-world multi-role apps
- 📱 Built with modern Material 3 Flutter UI

---

## 📁 Project Structure
ib/
├── auth/
│ ├── login_screen.dart
│ ├── signup_screen.dart
├── models/
│ └── user_role.dart
├── onboarding/
│ ├── role_selection_page.dart
│ └── profile_setup_page.dart
├── dashboards/
│ └── ...
├── main.dart
