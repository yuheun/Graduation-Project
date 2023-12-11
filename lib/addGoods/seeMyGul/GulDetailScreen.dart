import 'package:flutter/material.dart';
import '../../firebase/gulItem.dart';
import '../../main.dart';

class GulDetailScreen extends StatelessWidget {
  final GulItem gulItem;

  const GulDetailScreen({required this.gulItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 상세 정보'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyAppPage()),
                    (Route<dynamic> route) => false,
              );
            },
          )
        ],
      ),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Display the details of the selected GulItem
            Image.network(
              gulItem.image_url,
              width: 430,
              height: 430,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 20),


            // Text('종류:      ${gulItem.subcategory}', style: TextStyle(
            //   fontSize: 20.0,
            //   fontWeight: FontWeight.bold,
            // ),),
            // const SizedBox(height: 10),
            // Text('대분류:  ${gulItem.category}', style: TextStyle(
            //   fontSize: 20.0,
            //   fontWeight: FontWeight.bold,
            // ),),
            // const SizedBox(height: 10),
            // Text('특징:      ${gulItem.yolo_label}', style: TextStyle(
            //   fontSize: 20.0,
            //   fontWeight: FontWeight.bold,
            // ),),

            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // Set border radius
                  //border: Border.all(color: Colors.black), // Set border color
                  border: Border.all(color: Colors.transparent),
                ),
                child: Table(
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Colors.black), // Set color for horizontal gridlines
                    verticalInside: BorderSide.none, // Set vertical gridlines to none
                  ),
                  //border: TableBorder.symmetric(inside: BorderSide(color: Colors.black)),
                  columnWidths: {
                    0: FixedColumnWidth(70.0), // Set width for the label column
                    1: FixedColumnWidth(200.0), // Set width for the value column
                  },
                  children: [
                    _buildTableRow('종류', gulItem.subcategory),
                    _buildTableRow('대분류', gulItem.category),
                    _buildTableRow('특징', gulItem.yolo_label),
                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}


TableRow _buildTableRow(String label, String value) {
  return TableRow(
    children: [
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          //padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
          //padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(
                fontSize: 20.0,
                //fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 103, 169)
            ),
          ),
        ),
      ),
    ],
  );
}