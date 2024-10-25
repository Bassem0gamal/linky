import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linky/ui/screen/home/home_screen.dart';
import 'package:linky/ui/screen/sign_in/sign_in_screen.dart';
import 'package:linky/ui/widget/text_form_field_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  bool _obscureTextP = true;
  bool _obscureTextPC = true;

  final _formKey = GlobalKey<FormState>();

  final _userNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Linky',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                const SizedBox(height: 20),
                const Text('Register and let’s chat with Linky'),
                const SizedBox(height: 8),

                TextFormFieldWidget(
                  controller: _userNameTextController,
                  textLabel: 'User name',
                  errorMessage: 'Please enter your name',
                  obscureText: false,
                ),

                TextFormFieldWidget(
                  controller: _emailTextController,
                  textLabel: 'Email',
                  errorMessage: 'Please enter your email',
                  obscureText: false,
                ),

                TextFormFieldWidget(
                  controller: _passwordTextController,
                  textLabel: 'Password',
                  errorMessage: 'Please enter your password',
                  obscureText: true,
                  iconButton: IconButton(
                    icon: Icon(_obscureTextP
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureTextP = !_obscureTextP;
                      });
                    },
                  ),
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordTextController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  controller: _confirmPasswordTextController,
                  obscureText: _obscureTextPC,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureTextPC
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureTextPC = !_obscureTextPC;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _onRegisterPressed(
                        _emailTextController.text,
                        _passwordTextController.text,
                        context,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(
                  color: Colors.grey,
                  thickness: .5,
                ),
                const Text(
                  'If you already registered \n please Sign-in',
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                  },
                  child: const Text(
                    'Sign-in',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

_onRegisterPressed(String email, String password, context) async {
  try {
    const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.blue),
    );
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen()));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful!'),
        backgroundColor: Colors.green,
      ),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text('The password provided is too weak.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'The account already exists for that email.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}