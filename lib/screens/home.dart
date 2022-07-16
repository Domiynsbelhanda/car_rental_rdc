import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toksmo_auto/data/firestore_service.dart';

import '../screens/detail.dart';
import '../screens/rented.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/car.dart';
import '../data/brand.dart';
import '../constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var _dataStream =
          FirebaseFirestore.instance.collection('donnees');
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              height: size.height * 0.07,
              width: size.width,
              margin: const EdgeInsets.fromLTRB(15, 20, 16, 24),
              padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                color: kShadeColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Rechercher un item',
                  hintStyle: kSearchHint,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Vehicule',
                    style: kSectionTitle,
                  ),
                  Text(
                    'voir tout',
                    style: kViewAll,
                  ),
                ],
              ),
            ),

            item(context, size, _dataStream, 'vehicule'),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 16, 15, 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Camion',
                    style: kSectionTitle,
                  ),
                  Text(
                    'voir tout',
                    style: kViewAll,
                  ),
                ],
              ),
            ),

            item(context, size, _dataStream, 'camion'),

            const Padding(
              padding: EdgeInsets.fromLTRB(15, 24, 15, 13),
              child: Text('Top Dealers', style: kSectionTitle),
            ),
            Container(
              width: size.width,
              height: size.height * 0.1,
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kShadeColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/kristy.png'),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Kristy's Garage", style: kBrand),
                      const SizedBox(height: 3),
                      Text(
                        "123 Swanston Street",
                        style: kBrand.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item(BuildContext context, size, _dataStream, type){
    return SizedBox(
      height: size.height * 0.21,
      child: StreamBuilder<QuerySnapshot>(
        stream: _dataStream.doc('$type').collection('item')
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Something went wrong',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Loading",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            );
          }
          var datas = snapshot.data!.docs;
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (ctx, i) {
                Map<String, dynamic> data = datas[i].data()! as Map<String, dynamic>;
                return Stack(
                  children: [
                    Container(
                      height: size.height * 0.2,
                      width: size.width * 0.35,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      padding: const EdgeInsets.fromLTRB(12, 16, 0, 11),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              '${data['image'][0]}'
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 17.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: size.width * 0.34,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: kBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(fontSize: 12.0),
                              text: TextSpan(
                                style: TextStyle(color: Colors.white),
                                text: '${data['marque']} ${data['name']}',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 1.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: kBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(fontSize: 12.0),
                              text: TextSpan(
                                style: TextStyle(color: Colors.white),
                                text: '${data['prix']}',
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
          );
        },
      ),
    );
  }
}
