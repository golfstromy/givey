import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linn01/components/gv_text_field.dart';
import 'package:linn01/modals/donation.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GvListTile extends StatelessWidget {
  final 
  const GvTextField({
     Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
                          onTap: () => {
                                showCupertinoModalBottomSheet(
                                  context: context,
                                  expand: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return NewDonation(
                                        title: donation['title'],
                                        amount: donation['amount'],
                                        donationId: document.id);
                                  },
                                ),
                              },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.network((snapshot.data!),
                                  frameBuilder: (context, child, frame, _) {
                                if (frame == null) {
                                  return Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                          color: circleColor.withOpacity(0.5),
                                          blurRadius: 20,
                                        )
                                      ]),
                                      width: 56,
                                      height: double.infinity,
                                      child: Center(
                                          child: Text('${donation['title'][0]}',
                                              // textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ))));
                                } else {
                                  return child;
                                }
                              }, width: 56, height: 56)),
                          title: Text(
                            '${donation['title']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                              // '${DateFormat('MMM', 'en').format(donation['date'].toDate())} \'${DateFormat('yy', 'en').format(donation['date'].toDate())} • monthly'),
                              '${DateFormat('MMM', 'de').format(donation['date'].toDate())} \'${DateFormat('yy', 'de').format(donation['date'].toDate())} • monatlich'),
                          trailing: Text(donation['amount'].toString(),
                              style: const TextStyle(
                                fontSize: 17,
                              )));
  }
}


