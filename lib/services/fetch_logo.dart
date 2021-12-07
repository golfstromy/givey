import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

Future<String> fetchLogo(donationTitle) async {
  var url =
      'https://autocomplete.clearbit.com/v1/companies/suggest?query=:$donationTitle';

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var logoUrl = jsonResponse[0]['logo'];
    return (logoUrl);
  } else {
    return ('Request failed with status: ${response.statusCode}.');
  }
}
