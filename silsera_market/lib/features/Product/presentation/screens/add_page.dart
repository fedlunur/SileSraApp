// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/core/config/settings.dart';
import 'package:silesra/core/config/shareddata.dart';
import 'package:silesra/features/Auth/models/user_model.dart';
import 'package:silesra/features/Auth/presentation/block/user_bloc.dart';
import 'package:silesra/features/Auth/presentation/block/user_state.dart';

class AddPage extends StatefulWidget {
  final String city;

  const AddPage({
    super.key,
    required this.city,
  });
  @override
  _AddWidgetState createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddPage> {
  void navigateWithCity(
      BuildContext context, String path, int catagory, User user) {
    SharedData().setCategory(catagory, widget.city, user.id, user.phone!);

    GoRouter.of(context).go('$path?city=${widget.city}&category=$catagory');
  }

  bool isloading = true;
  List<Category> catagories = [];
  @override
  void initState() {
    super.initState();
    loadCatagories();
  }

  Future<void> loadCatagories() async {
    try {
      print("%%% Try to fetch Catagories ");
      List<Category> catag = await ApiService.fetchCategories();
      print("%%% Error loading Catagories ");
      setState(() {
        catagories = catag;
        isloading = false;
      });
    } catch (e) {
      print("Error loading car types: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final city = widget.city;
    final user = context.select((UserBloc bloc) =>
        bloc.state is UserLoaded ? (bloc.state as UserLoaded).user : null);

    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 253, 255, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Choose Category $city',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : catagories.isEmpty
              ? Center(
                  child: Text(
                    "Error in the network check your data",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Select a Category to Advert',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: catagories.map((category) {
                              return _buildCategoryButton(
                                  icon: getCategoryIcon(
                                      category.icon), // Default icon
                                  label: category.name,
                                  color: parseColor(
                                      category.color), // Convert HEX to Color
                                  id: category.id,
                                  context: context,
                                  user: user!);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildCategoryButton(
      {required IconData icon,
      required String label,
      required Color color,
      required int id,
      required BuildContext context,
      required User user}) {
    return GestureDetector(
      onTap: () {
        String city = widget.city;

        switch (label) {
          case 'House':
            print(" !!!!!!!!!!!!   called with $id and city $city");
            navigateWithCity(context, '/add_house', id, user);
            break;
          case 'Car':
            print(" !!!!!!!!!!!!   called with $id and city $city");
            navigateWithCity(context, '/add_car', id, user);
            break;
          case 'Accessories':
            print(" !!!!!!!!!!!!   called with $id and city $city");
            navigateWithCity(context, '/add_accessory', id, user);
            break;
          case 'Fashion':
            print(" !!!!!!!!!!!!   called with $id and city $city");
            navigateWithCity(context, '/add_fashion', id, user);
            break;
          case 'Electronics':
            print(" !!!!!!!!!!!!   called with $id");
            navigateWithCity(context, '/add_electronics', id, user);
            break;
          case 'Services':
            navigateWithCity(context, '/add_service', id, user);
            break;
          case 'Lost or Found':
            navigateWithCity(context, '/add_lostorfound', id, user);
            break;
          case 'Job Vacancy':
            navigateWithCity(context, '/add_jobvacancy', id, user);
            break;
          case 'Free staff or Item':
            navigateWithCity(context, '/add_freeitem', id, user);
            break;
          case 'Job':
            navigateWithCity(context, '/add_jobvacancy', id, user);
            break;

          case 'Others':
            navigateWithCity(context, '/add_others', id, user);
            break;
          default:
            context
                .push('/categorydetails', extra: {'category': label, 'id': id});
        }
      },
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(22, 138, 227, 0.08),
              offset: Offset(0, 1.5),
              blurRadius: 7.1,
            ),
          ],
          color: Colors.white,
          border: Border.all(
            color: Color.fromRGBO(21, 138, 226, 1),
            width: 0.5,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color,
              ),
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Icon(
                icon,
                size: 40,
                color: Color.fromRGBO(21, 138, 226, 1),
              ),
            ),
            SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
