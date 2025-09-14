# CRM App - Customer Relationship Management System

A modern, feature-rich Customer Relationship Management application built with Flutter and powered by a robust backend API.

## 🚀 Features

- **Customer Management**: Add, edit, and track customer information
- **Contact History**: Maintain detailed interaction logs
- **Dashboard Analytics**: Visual insights into customer data
- **Real-time Sync**: Seamless data synchronization across devices
- **Secure Authentication**: User login and access control
- **Responsive Design**: Works perfectly on mobile and tablet devices

## 📱 Screenshots

*Add screenshots of your app here*

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Node.js/Express (or your backend framework)
- **Database**: [Your database choice]
- **Deployment**: [Your deployment platform]

## 🏁 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/crm_app.git
   cd crm_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Backend URL**
   
   Update the backend URL in `lib/backend.dart`:
   ```dart
   final BACKEND_URL = "https://crmbackend.pugazhmukilan.tech";
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Backend Setup

The app connects to a backend API hosted at `https://crmbackend.pugazhmukilan.tech`. For local development:

1. Uncomment the localhost URL in `lib/backend.dart`
2. Ensure your local backend is running on port 8001
3. Update API endpoints as needed

### Environment Variables

Create a `.env` file in the root directory (if needed):
```
API_URL=https://crmbackend.pugazhmukilan.tech
DEBUG_MODE=false
```

## 📖 Usage

1. **Launch the app** on your device or emulator
2. **Sign in** with your credentials
3. **Navigate** through the dashboard to manage customers
4. **Add new customers** using the + button
5. **Track interactions** and update customer information
6. **View analytics** on the dashboard

## 🏗️ Project Structure

```
crm_app/
├── lib/
│   ├── backend.dart          # API configuration
│   ├── main.dart            # App entry point
│   ├── screens/             # UI screens
│   ├── widgets/             # Reusable components
│   ├── models/              # Data models
│   └── services/            # API services
├── android/                 # Android-specific files
├── ios/                     # iOS-specific files
└── pubspec.yaml            # Dependencies
```

## 🔗 API Documentation

### Base URL
```
https://crmbackend.pugazhmukilan.tech
```

### Endpoints

- `GET /api/customers` - Fetch all customers
- `POST /api/customers` - Create new customer
- `PUT /api/customers/:id` - Update customer
- `DELETE /api/customers/:id` - Delete customer

*For detailed API documentation, visit: [API Docs Link]*

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Pugazh Mukilan**
- Website: [pugazhmukilan.tech](https://pugazhmukilan.tech)

## 🆘 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/pugazhmukilan/crm_app/issues) page
2. Create a new issue if your problem isn't listed
3. Contact: [pugazhmukilanoffical2004@gmail.com](mailto:pugazhmukilanoffical2004@gmail.com)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- [Any other libraries or resources you used]
- Contributors and testers

---

⭐ **Star this repository if you found it helpful!**

Made with ❤️ by Pugazh Mukilan