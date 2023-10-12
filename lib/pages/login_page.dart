import 'package:fe_cnpmn/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Log in',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text('Please log in to continue'),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : () {
                    setState(() {
                      isLoading = true;
                    });
                    Future<void>.delayed(const Duration(seconds: 2)).then((_) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    });
                  },
                  child: isLoading ? const CircularProgressIndicator.adaptive() : const Text('Log in'),
                ),
              ],
            ),
          ),
        ),
      );
}
