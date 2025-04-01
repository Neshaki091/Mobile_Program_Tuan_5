import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_services.dart';
import 'main.dart';

Widget createwidget(String title, String description) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 16)),
      SizedBox(height: 5),
      TextField(
        decoration: InputDecoration(
          labelText: description,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        enabled: false,
      ),
      SizedBox(height: 5),
    ],
  );
}

DateTime? picked = null;

TextEditingController _timeController = TextEditingController();
Future<void> _selectDate(BuildContext context) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked != null)
    _timeController.text = '${picked.day}/${picked.month}/${picked.year}';
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthServices>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(82, 255, 255, 255),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () async {
                  await authProvider.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  }
                },
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue),
              ),
              SizedBox(width: 80),
              Text(
                "Trang Chủ",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child:
            user != null && user.photoURL != null
                ? Column(
                  children: [
                    Stack(
                      children: [
                        ClipOval(child: Image.network(user.photoURL!)),
                        Positioned(
                          bottom: 0, // Cách cạnh dưới 5px
                          right: 0, // Cách cạnh phải 5px
                          child: Image.asset("assets/Vector.png"),
                        ),
                      ],
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          createwidget("Name", user.displayName!),
                          createwidget("Email", user.email!),
                          Text("Date of Birth", style: TextStyle(fontSize: 16)),
                          SizedBox(height: 5),
                          TextField(
                            controller: _timeController,
                            decoration: InputDecoration(
                              labelText: 'Chọn ngày',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 260),
                    ElevatedButton(
                      onPressed: () async {
                        await authProvider.signOut();
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 50,
                        ),
                      ),
                      child: Text(
                        "Back To Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
                : Text("Không có dữ liệu người dùng"),
      ),
    );
  }
}
