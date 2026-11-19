import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/food/presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // 1. Kiểm tra xem người dùng đã từng đăng nhập trước đó chưa (Token còn trong máy)
  final token = await TokenStorage.getToken();
  final bool isLoggedIn = token != null && token.isNotEmpty;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'FoodHub Sài Gòn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFCFCFD),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFEA580C),
            primary: const Color(0xFFEA580C),
          ),
        ),
        // 2. Nếu đã đăng nhập rồi -> Vào thẳng HomeScreen; chưa thì hiện LoginScreen
        home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}
