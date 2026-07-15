// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silesra/features/Product/presentation/widgets/circular_steppers.dart';
import 'package:silesra/features/Product/presentation/widgets/custom_app_bar.dart';
import 'package:silesra/features/Product/presentation/widgets/custom_choice_box.dart';
import 'package:silesra/features/Product/presentation/widgets/input_fields.dart';

class AddPropertyHouse extends StatefulWidget {
  const AddPropertyHouse({super.key});

  @override
  State<AddPropertyHouse> createState() => _AddPropertyHouseState();
}

class _AddPropertyHouseState extends State<AddPropertyHouse> {
  final int active_step = 3;
  final VoidCallback tap = () {};
  bool isSelected = false;
  final TextEditingController bedroom_controller = TextEditingController();
  final TextEditingController bathroom_controller = TextEditingController();
  final TextEditingController price_controller = TextEditingController();
  final TextEditingController area_controller = TextEditingController();
  final TextEditingController description_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CustomAppBar(
            name: 'Add Property',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 29.0, left: 29, right: 29),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Steps',
                        style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(22, 138, 227, 1)),
                      ),
                      Text(
                        'Property Detail',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  StepperWidget(
                    activeStep: active_step,
                  ),
                ],
              ),
              // Spacer(),
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Is the property for Sale or Rent?',
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: SelectableCard(
                              label: 'Sale',
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  isSelected = !isSelected;
                                });
                              },
                            ),
                          ),
                          GestureDetector(
                              child: SelectableCard(
                            label: "Rent",
                            isSelected: !isSelected,
                            onTap: () {
                              setState(() {
                                isSelected = !isSelected;
                              });
                            },
                          ))
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: DropdownMenu(
                      width: MediaQuery.of(context).size.width,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: 1,
                          label: 'None',
                        ),
                        DropdownMenuEntry(
                          value: 2,
                          label: 'Condominium',
                        ),
                        DropdownMenuEntry(
                          value: 3,
                          label: 'Land',
                        )
                      ],
                      hintText: 'Select Property Type',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SegmentedInput(
                            firstController: bedroom_controller,
                            firstHint: 'Bedroom',
                            width: MediaQuery.of(context).size.width * 0.41),
                        SegmentedInput(
                            firstController: bathroom_controller,
                            firstHint: 'Bathroom',
                            width: MediaQuery.of(context).size.width * 0.41)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SegmentedInput(
                        firstController: price_controller,
                        firstHint: 'Price (Monthly Rent)',
                        width: MediaQuery.of(context).size.width),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SegmentedInput(
                        firstController: area_controller,
                        firstHint: 'Square Meters',
                        width: MediaQuery.of(context).size.width),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SegmentedInput(
                        firstController: description_controller,
                        firstHint: 'Description',
                        width: MediaQuery.of(context).size.width),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.41,
                          height: 50,
                          child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  side: BorderSide(
                                      color: Color.fromRGBO(22, 138, 227, 1))),
                              child: Text('Cancel')),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.41,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(22, 138, 227, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                )),
                            child: Text('Continue '),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
